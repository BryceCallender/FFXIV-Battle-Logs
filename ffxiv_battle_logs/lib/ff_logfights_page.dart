import 'dart:async';
import 'dart:convert';

import 'package:ffxiv_battle_logs/fflog_classes.dart';
import 'package:ffxiv_battle_logs/specificfight.dart';
import 'package:ffxiv_battle_logs/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter/foundation.dart' as foundation;

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class FFLogFightsPage extends StatelessWidget {
  final FFLogReport report;

  FFLogFightsPage({Key key, @required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(report.title),
        backgroundColor: CupertinoColors.activeBlue,
        ios: (_) => CupertinoNavigationBarData(
          heroTag: "fights",
          transitionBetweenRoutes: false,
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: getFights(),
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
              return ListView.builder(
                itemCount: snapshot.data.ffLogFightData.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Card(
                      color: mediaQuery.platformBrightness == Brightness.dark
                          ? ThemeData.dark().cardColor
                          : ThemeData.light().cardColor,
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2.0,
                                    color:
                                        snapshot.data.ffLogFightData[index].kill
                                            ? Colors.green
                                            : Colors.red)),
                            child: ListTile(
                              dense: true,
                              leading: Image.asset(
                                  "assets/images/banners/112000/" +
                                      snapshot.data.ffLogFightData[index].name
                                          .replaceAll(" ", "_") +
                                      ".png"),
                              title: Text(
                                  snapshot.data.ffLogFightData[index].zoneName,
                                  style: Styles.getTextStyleFromBrightness(
                                      context)),
                              subtitle: Wrap(
                                children: [
                                  Text(
                                      "Duration: " +
                                          Duration(
                                                  milliseconds: (snapshot
                                                          .data
                                                          .ffLogFightData[index]
                                                          .end -
                                                      snapshot
                                                          .data
                                                          .ffLogFightData[index]
                                                          .start))
                                              .toString()
                                              .split('.')
                                              .first
                                              .padLeft(8, "0"),
                                      style: Styles.getTextStyleFromBrightness(
                                          context)),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 3.0, bottom: 3.0),
                                    child: Offstage(
                                      offstage: snapshot
                                          .data.ffLogFightData[index].kill,
                                      child: LinearPercentIndicator(
                                        lineHeight: 16.0,
                                        animation: true,
                                        percent: (snapshot
                                                .data
                                                .ffLogFightData[index]
                                                .bossPercentage /
                                            10000),
                                        backgroundColor: Colors.grey,
                                        progressColor: getProgressColor(snapshot
                                                .data
                                                .ffLogFightData[index]
                                                .bossPercentage /
                                            100),
                                        center: Text(
                                          "${snapshot.data.ffLogFightData[index].bossPercentage / 100}% HP",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: isIOS? Icon(CupertinoIcons.forward, color: Styles.getColorFromBrightness(context)) : Icon(Icons.keyboard_arrow_right, color: Styles.getColorFromBrightness(context)),
                              onTap: () {
                                if (isIOS) {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => SpecificFightReport(
                                        ffLogFightData:
                                            snapshot.data.ffLogFightData[index],
                                        partyMembers:
                                            snapshot.data.partyMembersInvolved,
                                        reportID: report.id,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SpecificFightReport(
                                        ffLogFightData:
                                            snapshot.data.ffLogFightData[index],
                                        partyMembers:
                                            snapshot.data.partyMembersInvolved,
                                        reportID: report.id,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Future<FFLogFight> getFights() async {
    http.Response response = await http.get(
        "https://www.fflogs.com/v1/report/fights/" +
            report.id +
            "?api_key=a468c182a1d6b2464526fb12ce56044f");

    print("https://www.fflogs.com/v1/report/fights/" +
        report.id +
        "?api_key=a468c182a1d6b2464526fb12ce56044f");

    var fightData = jsonDecode(response.body);

    FFLogFight fight = FFLogFight.fromJson(fightData);

    print(fight.ffLogFightData.length);

    return fight;
  }

  Color getProgressColor(double progressPercent) {
    if (progressPercent > 75) {
      return Colors.white;
    } else if (progressPercent <= 75 && progressPercent > 50) {
      return Colors.green;
    } else if (progressPercent <= 50 && progressPercent > 20) {
      return Colors.blue;
    } else if (progressPercent <= 20 && progressPercent > 10) {
      return Colors.deepPurpleAccent;
    } else {
      return Colors.deepOrangeAccent;
    }
  }
}
