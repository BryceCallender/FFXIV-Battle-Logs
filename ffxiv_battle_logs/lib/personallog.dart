import 'dart:async';
import 'dart:convert';

import 'package:ffxiv_battle_logs/authentication.dart';
import 'package:ffxiv_battle_logs/ff_logfights_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'styles.dart';

import 'fflog_classes.dart';
import 'package:flutter/foundation.dart' as foundation;

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class PersonalLogPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyPersonalLogPage();

  FFLogZones zoneData;
  String userName;

  PersonalLogPage() {
    zoneData = new FFLogZones();
  }
}

class _MyPersonalLogPage extends State<PersonalLogPage> {
  @override
  void initState() {
    widget.userName = FirebaseAuthentication.currentUser.displayName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(widget.userName + " Personal Logs"),
        backgroundColor: CupertinoColors.activeBlue,
        cupertino: (_, __) => CupertinoNavigationBarData(
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

          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
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
                                  widget.zoneData.isZoneExtreme(
                                          snapshot.data[index].zone)
                                      ? "assets/images/map_icons/trial.png"
                                      : "assets/images/map_icons/high_end_duty.png",
                                  fit: BoxFit.cover),
                            ),
                            title: Text(widget.zoneData
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

    http.Response response = await http.get(Uri.parse(
        "https://www.fflogs.com/v1/reports/user/" +
            widget.userName +
            "?api_key=a468c182a1d6b2464526fb12ce56044f"));

    var reportList = jsonDecode(response.body) as List;

    for (int i = 0; i < reportList.length; i++) {
      reports.add(FFLogReport.fromJson(reportList[i]));
    }

    return reports;
  }
}
