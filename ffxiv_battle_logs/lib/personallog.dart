import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ffxiv_battle_logs/authentication.dart';
import 'package:ffxiv_battle_logs/ff_logfights_page.dart';
import 'package:ffxiv_battle_logs/oauth2data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'styles.dart';
import 'package:uni_links/uni_links.dart';

import 'fflog_classes.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:oauth2/oauth2.dart' as oauth2;

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class PersonalLogPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyPersonalLogPage();

  String userName;
}

class _MyPersonalLogPage extends State<PersonalLogPage> {
  StreamSubscription _sub;

  @override
  void initState() {
    widget.userName = FirebaseAuthentication.currentUser.displayName;
    super.initState();
  }

  Future<Uri> listen(Uri redirectUrl) async {
    Uri responseUrl;

    // Attach a listener to the stream
    _sub = getUriLinksStream().listen((Uri uri) {
      // Use the uri and warn the user, if it is not correct
      if (uri.toString().startsWith(redirectUrl.toString())) {
        responseUrl = uri;
        _sub.cancel();
        _sub = null;
      }
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
      print(err);
    });

    return responseUrl;
  }

  /// Either load an OAuth2 client from saved credentials or authenticate a new
  /// one.
  Future<oauth2.Client> getClient() async {
//    var exists = await credentialsFile.exists();
//
//    // If the OAuth2 credentials have already been saved from a previous run, we
//    // just want to reload them.
//    if (exists) {
//      var credentials = new oauth2.Credentials.fromJson(
//          await credentialsFile.readAsString());
//      return new oauth2.Client(credentials,
//          identifier: identifier, secret: secret);
//    }

    // If we don't have OAuth2 credentials yet, we need to get the resource owner
    // to authorize us. We're assuming here that we're a command-line application.
    var grant = new oauth2.AuthorizationCodeGrant(
        OAuth2Data.identifier,
        OAuth2Data.authorizationEndpoint,
        OAuth2Data.tokenEndpoint,
        secret: OAuth2Data.secret);

    // A URL on the authorization server (authorizationEndpoint with some additional
    // query parameters). Scopes and state can optionally be passed into this method.
    var authorizationUrl = grant.getAuthorizationUrl(OAuth2Data.redirectUrl);

    print(authorizationUrl);

    // Redirect the resource owner to the authorization URL. Once the resource
    // owner has authorized, they'll be redirected to `redirectUrl` with an
    // authorization code.
    if (await canLaunch(authorizationUrl.toString())) {
      await launch(authorizationUrl.toString());
    }

    // Another imaginary function that listens for a request to `redirectUrl`.
    var responseUrl = await listen(OAuth2Data.redirectUrl);

    print(responseUrl);

    // Once the user is redirected to `redirectUrl`, pass the query parameters to
    // the AuthorizationCodeGrant. It will validate them and extract the
    // authorization code to create a new Client.
    return await grant.handleAuthorizationResponse(responseUrl.queryParameters);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(widget.userName + " Personal Logs"),
        backgroundColor: CupertinoColors.activeBlue,
        ios: (_) => CupertinoNavigationBarData(
          heroTag: "personalLog",
          transitionBetweenRoutes: false,
        ),
      ),
      body: FutureBuilder(
        future: getReports(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {
            return Container();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: PlatformCircularProgressIndicator(),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            if(snapshot.data == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("FFLogs API has shifted to use OAuth in order to grab parses. You must allow this app to access your data in order for this to show. FFXIV Battle Logs does not store any of this information, it just needs access in order to display it."),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: PlatformButton(
                          child: Text("Start Authentication Process!"),
                          ios: (_) => CupertinoButtonData(
                            color: CupertinoColors.activeBlue,
                            onPressed: () async {
                              getClient();
                            },
                          ),
                          android: (_) => MaterialRaisedButtonData(
                            color: Colors.blue,
                            splashColor: Colors.lightBlue,
                            onPressed: () {

                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )
              );
            }

            if (snapshot.data.length == 0) {
              return Center(
                child: Column(
                  children: <Widget>[
                    Text("You have no personal logs yet!"),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Card(
                      elevation: 5.0,
                      color: mediaQuery.platformBrightness == Brightness.dark? ThemeData.dark().cardColor: ThemeData.light().cardColor,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 44,
                                minHeight: 44,
                                maxWidth: 64,
                                maxHeight: 64,
                              ),
                              child: Image.asset(
                                  GameData.zones.isZoneExtreme(
                                          snapshot.data[index].zone)
                                      ? "assets/images/map_icons/trial.png"
                                      : "assets/images/map_icons/high_end_duty.png",
                                  fit: BoxFit.cover),
                            ),
                            title: Text(GameData.zones
                                .zoneIDToName(snapshot.data[index].zone),
                            style: Styles.getTextStyleFromBrightness(context)),
                            subtitle: Text("Date Logged: " +
                                DateFormat.yMMMMd().add_jm().format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        snapshot.data[index].start)),
                                style: Styles.getTextStyleFromBrightness(context)),
                            trailing: isIOS? Icon(CupertinoIcons.forward, color: Styles.getColorFromBrightness(context)) : Icon(Icons.keyboard_arrow_right, color: Styles.getColorFromBrightness(context)),
                            onTap: () {
                              if(isIOS) {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            FFLogFightsPage(
                                                report: snapshot.data[index])));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FFLogFightsPage(
                                                report: snapshot.data[index])));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
          return Container();
        },
      ),
    );
  }

  Future<List<FFLogReport>> getReports() async {
    List<FFLogReport> reports = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getBool("allowedLogReading") == null) {
      return null;
    }

    http.Response response = await http.get(
        "https://www.fflogs.com/v1/reports/user/" +
            widget.userName +
            "?api_key=a468c182a1d6b2464526fb12ce56044f");

    var reportList = jsonDecode(response.body) as List;

    for (int i = 0; i < reportList.length; i++) {
      reports.add(FFLogReport.fromJson(reportList[i]));
    }

    return reports;
  }
}
