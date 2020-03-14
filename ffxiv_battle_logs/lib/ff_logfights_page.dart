import 'dart:async';
import 'dart:convert';

import 'package:ffxiv_battle_logs/fflog_classes.dart';
import 'package:ffxiv_battle_logs/specificfight.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';

class FFLogFightsPage extends StatelessWidget {
  final FFLogReport report;

  FFLogFightsPage({Key key, @required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(report.title),
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
                child: CircularProgressIndicator(),
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
                                dense: true, //maybe?
                                leading: Image.asset(
                                    "assets/images/banners/112000/" +
                                        snapshot.data.ffLogFightData[index].name
                                            .replaceAll(" ", "_") +
                                        ".png"),
                                title: Text(snapshot
                                    .data.ffLogFightData[index].zoneName),
                                subtitle:
                                  Wrap(children: [
                                    Text("Duration: " +
                                    Duration(
                                            milliseconds: (snapshot.data.ffLogFightData[index].end - snapshot.data.ffLogFightData[index].start))
                                        .toString()
                                        .split('.')
                                        .first
                                        .padLeft(8, "0")),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                                      child: Offstage(
                                        offstage: snapshot.data.ffLogFightData[index].kill,
                                        child: LinearPercentIndicator(
                                          lineHeight: 16.0,
                                          animation: true,
                                          percent: (snapshot.data.ffLogFightData[index].bossPercentage / 10000),
                                          backgroundColor: Colors.grey,
                                          progressColor: getProgressColor(snapshot.data.ffLogFightData[index].bossPercentage / 100),
                                          center: Text(
                                            "${snapshot.data.ffLogFightData[index].bossPercentage / 100}% HP",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                onTap: () {
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

    var fightData = jsonDecode(response.body);

    FFLogFight fight = FFLogFight.fromJson(fightData);

    print(fight.ffLogFightData.length);

    return fight;
  }

  Color getProgressColor(double progressPercent) {
    if(progressPercent > 75) {
      return Colors.white;
    }else if(progressPercent <= 75 && progressPercent > 50) {
      return Colors.green;
    }else if(progressPercent <= 50 && progressPercent > 20) {
      return Colors.blue;
    }else if(progressPercent <= 20 && progressPercent > 10) {
      return Colors.deepPurpleAccent;
    }else {
      return Colors.deepOrangeAccent;
    }
  }
}
