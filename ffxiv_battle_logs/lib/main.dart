import 'dart:convert';
import 'dart:io';

import 'package:ffxiv_battle_logs/FadingTextWidget.dart';
import 'package:ffxiv_battle_logs/fflog_classes.dart';
import 'package:ffxiv_battle_logs/home_page.dart';
import 'package:ffxiv_battle_logs/login.dart';
import 'package:ffxiv_battle_logs/searchusers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:overlay_support/overlay_support.dart';
import 'authentication.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:ffxiv_battle_logs/oauth2data.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(new MyApp());
}

/// Either load an OAuth2 client from saved credentials or authenticate a new
/// one.
Future<oauth2.Client> getClientCredentialsGrant() async {
  // Calling the top-level `clientCredentialsGrant` function will return a
  // [Client] instead.
  var client =
      await oauth2.clientCredentialsGrant(OAuth2Data.tokenEndpoint, OAuth2Data.identifier, OAuth2Data.secret);

  // You can save the client's credentials, which consists of an access token, and
  // potentially a refresh token and expiry date, to a file. This way, subsequent runs
  // do not need to reauthenticate, and you can avoid saving the client identifier and
  // secret.

  //await credentialsFile.writeAsString(client.credentials.toJson());

  return client;
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  ValueNotifier<GraphQLClient> client;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final HttpLink httpLink =
        HttpLink(uri: OAuth2Data.clientURI.toString());

    final AuthLink authLink = AuthLink(
      getToken: () async =>
          'Bearer ${(await getClientCredentialsGrant()).credentials.accessToken}',
    );

    final Link link = authLink.concat(httpLink);

    client = ValueNotifier(
      GraphQLClient(
        cache: InMemoryCache(),
        link: link
      ),
    );

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    print(WidgetsBinding.instance.window
        .platformBrightness); // should print Brightness.light / Brightness.dark when you switch
    super.didChangePlatformBrightness(); // make sure you call this
    setState(
        () {}); //Once tabbed back into the app this will rebuild with new brightness :)
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: OverlaySupport(
        child: PlatformApp(
          home: MyHomePage(title: "FFXIV Battle Logs"),
          debugShowCheckedModeBanner: false,
          ios: (_) => CupertinoAppData(
            theme: CupertinoThemeData(
                primaryColor: CupertinoColors.activeBlue,
                textTheme: CupertinoTextThemeData(
                    primaryColor:
                        WidgetsBinding.instance.window.platformBrightness ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black),
                brightness: WidgetsBinding.instance.window.platformBrightness),
          ),
          android: (_) => MaterialAppData(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuthentication _auth = new FirebaseAuthentication();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(widget.title),
        backgroundColor: CupertinoColors.activeBlue,
        ios: (_) => CupertinoNavigationBarData(
          heroTag: "main",
          transitionBetweenRoutes: false,
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset("assets/images/AppIconWithoutLog.png"),
                FadingTextWidget(),
                FutureBuilder(
                  future: showLoginOrHomePageButton(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(children: snapshot.data);
                    }
                    return Container();
                  },
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SafeArea(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "FINAL FANTASY XIV © 2010 - 2020 SQUARE ENIX CO., LTD. All Rights Reserved.",
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Query(
                  options: QueryOptions(
                    documentNode:
                        gql("""
                            {
                              worldData {
                                regions {
                                  id
                                  name
                                  compactName
                                }
                                zones {
                                  id
                                  name
                                  frozen
                                  expansion {
                                    name
                                  }
                                  encounters {
                                    id
                                    name
                                  }
                                }
                              }
                            }
                            """
                        ),
                  ),
                  // Just like in apollo refetch() could be used to manually trigger a refetch
                  // while fetchMore() can be used for pagination purpose
                  builder: (QueryResult result,
                      {VoidCallback refetch, FetchMore fetchMore}) {
                    if (result.hasException) {
                      return Text('');
                    }

                    if (result.loading) {
                      return Text('');
                    }

                    // it can be either Map or List
                    List<dynamic> regions = result.data["worldData"]["regions"];

                    GameData.zones = new FFLogZones(jsonEncode(result.data["worldData"]["zones"]));
                    GameData.regions = regions.map((region) {return region["compactName"] as String;}).toList();

                    print("Queried for data");

                    return Text('');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Widget>> showLoginOrHomePageButton() async {
    FirebaseUser user = await _auth.getCurrentUser();

    if (user == null) {
      return [
        PlatformWidget(
          ios: (_) => SizedBox(height: 16.0),
        ),
        PlatformButton(
          child: Text("Login"),
          ios: (_) => CupertinoButtonData(
            color: CupertinoColors.activeBlue,
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => Login(title: "Login Page"),
                ),
              );
            },
          ),
          android: (_) => MaterialRaisedButtonData(
            color: Colors.blue,
            splashColor: Colors.lightBlue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Login(title: "Login Page")),
              );
            },
          ),
        ),
        PlatformWidget(
          ios: (_) => SizedBox(height: 16.0),
        ),
        PlatformButton(
          child: Text("Search"),
          ios: (_) => CupertinoButtonData(
            color: CupertinoColors.activeBlue,
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SearchUsers(),
                ),
              );
            },
          ),
          android: (_) => MaterialRaisedButtonData(
            color: Colors.blue,
            splashColor: Colors.lightBlue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchUsers()),
              );
            },
          ),
        ),
      ];
    } else {
      return [
        PlatformWidget(
          ios: (_) => SizedBox(height: 16.0),
        ),
        PlatformButton(
          child: Text(" Home "),
          ios: (_) => CupertinoButtonData(
            color: CupertinoColors.activeBlue,
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => HomePage(userName: user.displayName),
                ),
              );
            },
          ),
          android: (_) => MaterialRaisedButtonData(
            color: Colors.blue,
            splashColor: Colors.lightBlue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(userName: user.displayName),
                ),
              );
            },
          ),
        ),
        PlatformWidget(
          ios: (_) => SizedBox(height: 16.0),
        ),
        PlatformButton(
          child: Text("Search"),
          ios: (_) => CupertinoButtonData(
            color: CupertinoColors.activeBlue,
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SearchUsers(),
                ),
              );
            },
          ),
          android: (_) => MaterialRaisedButtonData(
            color: Colors.blue,
            splashColor: Colors.lightBlue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchUsers()),
              );
            },
          ),
        ),
      ];
    }
  }
}
