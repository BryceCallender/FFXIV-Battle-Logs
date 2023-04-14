import 'dart:async';
import 'dart:io';

import 'package:ffxiv_battle_logs/components/reports/report_overview.dart';
import 'package:ffxiv_battle_logs/graphql/graphql_queries.dart';
import 'package:ffxiv_battle_logs/models/reports.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:flutter/material.dart';
import 'package:ffxiv_battle_logs/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

StreamSubscription? subscription;

Future<Uri?> listen(Uri redirectUrl) async {
  Uri? responseUrl;

  // Attach a listener to the stream
  final completer = Completer<Uri?>();

  subscription = uriLinkStream.listen((Uri? uri) async {
    // Use the uri and warn the user, if it is not correct
    if (uri.toString().startsWith(redirectUrl.toString())) {
      responseUrl = uri;
      completer.complete(responseUrl);
    }
  }, onError: (err) {
    // Handle exception by warning the user their action did not succeed
    print(err);
  });

  return completer.future;
}

Future<oauth2.Client> createClient() async {
  final path = await _localPath;
  final credentialsFile = File('$path/credentials.json');
  var exists = await credentialsFile.exists();

  // If the OAuth2 credentials have already been saved from a previous run, we
  // just want to reload them.
  if (exists) {
    var credentials =
        oauth2.Credentials.fromJson(await credentialsFile.readAsString());
    return oauth2.Client(credentials,
        identifier: Constants.identifier, secret: Constants.secret);
  }

  // If we don't have OAuth2 credentials yet, we need to get the resource owner
  // to authorize us. We're assuming here that we're a command-line application.
  var grant = oauth2.AuthorizationCodeGrant(Constants.identifier,
      Constants.authorizationEndpoint, Constants.tokenEndpoint,
      secret: Constants.secret);

  // A URL on the authorization server (authorizationEndpoint with some additional
  // query parameters). Scopes and state can optionally be passed into this method.
  var authorizationUrl = grant.getAuthorizationUrl(Constants.redirectUrl);

  if (await canLaunchUrl(authorizationUrl)) {
    await launchUrl(authorizationUrl, mode: LaunchMode.externalApplication);
  }

  var responseUrl = await listen(Constants.redirectUrl);

  // Once the user is redirected to `redirectUrl`, pass the query parameters to
  // the AuthorizationCodeGrant. It will validate them and extract the
  // authorization code to create a new Client.
  return await grant.handleAuthorizationResponse(responseUrl!.queryParameters);
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var client = await createClient();
  subscription?.cancel();

  final path = await _localPath;
  final credentialsFile = File('$path/credentials.json');

  // Once we're done with the client, save the credentials file. This ensures
  // that if the credentials were automatically refreshed while using the
  // client, the new credentials are available for the next run of the
  // program.
  await credentialsFile.writeAsString(client.credentials.toJson());
  Animate.restartOnHotReload = true;
  runApp(MyApp(credentials: client.credentials));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.credentials});

  final oauth2.Credentials credentials;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ValueNotifier<GraphQLClient>? client;

  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();

    final HttpLink httpLink = HttpLink(Constants.userURI.toString());

    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer ${widget.credentials.accessToken}',
    );

    final Link link = authLink.concat(httpLink);

    client = ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(),
        link: link,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark(
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Query(
                options: QueryOptions(
                  document: gql(GraphQLQueries.reports),
                  variables: {'page': 1, 'userID': 0},
                ),
                builder: (QueryResult result,
                    {VoidCallback? refetch, FetchMore? fetchMore}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }

                  if (result.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  Reports reportData = Reports.fromJson(
                      result.data?['reportData']?['reports'] ?? {});

                  if (reportData.reports.isEmpty) {
                    return const Text('No repositories');
                  }

                  final int nextPage = reportData.currentPage + 1;

                  FetchMoreOptions opts = FetchMoreOptions(
                    variables: {'page': nextPage},
                    updateQuery: (previousResultData, fetchMoreResultData) {
                      final List<dynamic> reports = [
                        ...previousResultData?['reportData']['reports']['data']
                            as List<dynamic>,
                        ...fetchMoreResultData?['reportData']['reports']['data']
                            as List<dynamic>
                      ];

                      fetchMoreResultData?['reportData']['reports']['data'] =
                          reports;

                      return fetchMoreResultData;
                    },
                  );

                  return NotificationListener(
                    child: ListView.builder(
                      key: PageStorageKey<String>('reports'),
                      controller: _controller,
                      shrinkWrap: true,
                      itemCount: reportData.reports.length,
                      itemBuilder: (context, index) {
                        return ReportOverview(
                          data: reportData.reports[index],
                        );
                      },
                    ),
                    onNotification: (t) {
                      if (t is ScrollEndNotification &&
                          t.metrics.atEdge &&
                          reportData.hasMorePages) {
                        fetchMore!(opts);
                      }
                      return true;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
