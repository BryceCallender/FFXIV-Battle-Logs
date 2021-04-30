import 'dart:convert';

import 'package:ffxiv_battle_logs/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';

import 'ff_logfights_page.dart';
import 'fflog_classes.dart';
import 'package:http/http.dart' as http;

class SearchResults extends StatelessWidget {
  final String characterName;
  final String serverName;
  final String serverRegion;
  final int zoneNumber;

  SearchResults(this.characterName, this.serverName, this.serverRegion,
      {this.zoneNumber = 33});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text("Results for: $characterName"),
        backgroundColor: CupertinoColors.activeBlue,
        ios: (_) => CupertinoNavigationBarData(
          title: Text("Results for: $characterName"),
            heroTag: "searchresults",
            transitionBetweenRoutes: false,
        ),
      ),
      body: FutureBuilder(
        future: getReports(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done && snapshot.data == null) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("The search for $characterName returned no results. Either the name is incorrect or there is no logs under this username!"),
            );
          }

          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {
            return Container();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
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
                  var mediaQuery = MediaQuery.of(context);
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
                                  snapshot.data[index].difficulty == 100
                                      ? "assets/images/map_icons/trial.png"
                                      : "assets/images/map_icons/high_end_duty.png",
                                  fit: BoxFit.cover),
                            ),
                            title: Text(snapshot.data[index].encounterName,
                            style: Styles.getTextStyleFromBrightness(context)),
                            subtitle: Text("Date Logged: " +
                                DateFormat.yMMMMd().add_jm().format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        snapshot.data[index].startTime)),
                                style: Styles.getTextStyleFromBrightness(context)),
                            trailing: isIOS? Icon(CupertinoIcons.forward, color: Styles.getColorFromBrightness(context)) : Icon(Icons.keyboard_arrow_right, color: Styles.getColorFromBrightness(context)),
                            onTap: () {
                              Navigator.push(context,
                                  platformPageRoute(builder: (context) {
                                    FFLogParseReport reportData = snapshot.data[index];
                                    print(reportData.encounterName);
                                    FFLogReport parseToReport = FFLogReport(id: reportData.reportID,
                                        title: reportData.encounterName,
                                        start: reportData.startTime,
                                        end: reportData.startTime + reportData.duration,
                                        zone: zoneNumber);

                                return FFLogFightsPage(
                                    report: parseToReport);
                              }, context: context));
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

  Future<List<FFLogParseReport>> getReports() async {
    List<FFLogParseReport> reports = [];

    http.Response response = await http.get(
        "https://www.fflogs.com/v1/parses/character/$characterName/$serverName/$serverRegion" +
            "?zone=$zoneNumber&api_key=a468c182a1d6b2464526fb12ce56044f");

    var reportList = jsonDecode(response.body) as List;

    print(reportList);

    for (int i = 0; i < reportList.length; i++) {
      reports.add(FFLogParseReport.fromJson(reportList[i]));
    }

    return reports;
  }
}
