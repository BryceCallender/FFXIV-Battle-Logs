import 'package:ffxiv_battle_logs/FFXIVPartySection.dart';
import 'package:ffxiv_battle_logs/fflog_classes.dart';
import 'package:ffxiv_battle_logs/ffxiv_classes.dart';
import 'package:ffxiv_battle_logs/report_data_chart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'darkthemepreference.dart';

class SpecificFightReport extends StatefulWidget {
  FFXIVParty ffxivParty;
  final FFLogFightData ffLogFightData;
  final List<Friendly> partyMembers;
  final String reportID;

  SpecificFightReport(
      {Key key,
      @required this.ffLogFightData,
      @required this.partyMembers,
      @required this.reportID,
      this.ffxivParty});

  @override
  _SpecificFightReportState createState() => _SpecificFightReportState();
}

class _SpecificFightReportState extends State<SpecificFightReport> {
  String chartName = "DPS and RDPS";

  List<charts.Series<DPSInfo, String>> dpsData;
  List<charts.Series<HPSInfo, String>> hpsData;

  DarkThemeProvider themeColor;

  @override
  Widget build(BuildContext context) {
    themeColor = Provider.of<DarkThemeProvider>(context);
    print("Dark theme: " + themeColor.darkTheme.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Fight #" + widget.ffLogFightData.id.toString()),
      ),
      body: ListView(
        children: [
          FutureBuilder(
            future: getGraphData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.data == null) {
                return Container();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Stack(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Center(
                            child: Text(chartName,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)))),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: SizedBox(
                        height: 400,
                        child: ReportDataChart(snapshot.data, vertical: false),
                      ),
                    ),
                  ],
                );
              }

              return new Container();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                  child: Text("DPS Stats"),
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      chartName = "DPS And RDPS";
                    });
                  },
              ),
              SizedBox(width: 15.0),
              RaisedButton(
                  child: Text("HPS Stats"),
                  color: Colors.green,
                  onPressed: () {
                    setState(() {
                      chartName = "HPS And Overheal";
                    });
                  },
              )
            ],
          ),
          Divider(
            thickness: 3.0,
          ),
          getPartyWidget(),
//          Text("Events"),
//          FutureBuilder(
//            future: getEventData(),
//            builder: (context, snapshot) {
//              if (snapshot.connectionState == ConnectionState.none &&
//                  snapshot.hasData == null) {
//                return Container();
//              }
//
//              if (snapshot.connectionState == ConnectionState.waiting) {
//                return Center(
//                  child: CircularProgressIndicator(),
//                );
//              }
//
//              if (snapshot.connectionState == ConnectionState.done &&
//                  snapshot.hasData) {
//                return ListView.builder(
//                  itemCount: snapshot.data.length,
//                  itemBuilder: (context, index) {
//                    return Image.asset(
//                      "assets/images/class_action_icons/" +
//                          snapshot.data[index].ability.abilityIcon,
//                      width: 40,
//                      height: 40,
//                    );
//                  },
//                  shrinkWrap: true,
//                );
//              } else {
//                return Container();
//              }
//            },
//          ),
        ],
      ),
    );
  }

  Widget getPartyWidget() {
    List<FFXIVCharacter> partyMembersInvolved = [];

    widget.partyMembers.forEach((friendly) {
      friendly.fightIds.forEach((fightID) {
        if (fightID.id == widget.ffLogFightData.id) {
          partyMembersInvolved.add(friendly.character);
        }
      });
    });

    widget.ffxivParty = new FFXIVParty(partyMembersInvolved);

    return FFXIVPartySection(widget.ffxivParty, widget.reportID, widget.ffLogFightData.start, widget.ffLogFightData.end);
  }

  Future<List<charts.Series>> getGraphData() async {
    if (hpsData == null && dpsData == null) {
      http.Response response = await http.get(
          "https://www.fflogs.com/v1/report/tables/damage-done/" +
              widget.reportID +
              "?start=" +
              widget.ffLogFightData.start.toString() +
              "&end=" +
              widget.ffLogFightData.end.toString() +
              "&api_key=a468c182a1d6b2464526fb12ce56044f");

      var entryList = jsonDecode(response.body)["entries"] as List;

      List<DPSInfo> playerDPSInfo = [];
      List<DPSInfo> sortedByPartyWidgetDPSInfo = [];
      List<charts.Series<DPSInfo, String>> chartData = [];

      entryList.forEach((player) {
        if (player["name"] != "Limit Break" && player["name"] != "Ground Effect") {
          var dps = (player["total"] as int) /
              (widget.ffLogFightData.end - widget.ffLogFightData.start) *
              1000;
          var rdps = (player["totalRDPS"] as double) /
              (widget.ffLogFightData.end - widget.ffLogFightData.start) *
              1000;

          print(player["name"] + ": " + dps.toString() + " " + rdps.toString());

          playerDPSInfo.add(DPSInfo(
              user: player["name"] as String,
              DPS: dps,
              rDPS: rdps,
              color: charts.Color.fromHex(
                  code: classToColor(player["type"] as String))));
        }
      });

      widget.ffxivParty.characters.forEach((character) {
        playerDPSInfo.forEach((player) {
          if (character.name == player.user) {
            sortedByPartyWidgetDPSInfo.add(player);
          }
        });
      });

      chartData.add(new charts.Series(
        id: "DPS",
        data: sortedByPartyWidgetDPSInfo,
        domainFn: (DPSInfo dps, _) => dps.user,
        measureFn: ((DPSInfo dps, _) => dps.DPS),
        colorFn: ((DPSInfo dps, _) => dps.color),
        labelAccessorFn: (DPSInfo dps, _) =>
            "DPS: ${dps.DPS.toStringAsFixed(1)}",
        insideLabelStyleAccessorFn: (DPSInfo dpsInfo, _) {
          return new charts.TextStyleSpec(color: charts.MaterialPalette.black);
        },
        outsideLabelStyleAccessorFn: (DPSInfo dpsInfo, _) {
          return new charts.TextStyleSpec(color: themeColor.darkTheme? charts.MaterialPalette.white : charts.MaterialPalette.black);
        },
      ));

      chartData.add(
        new charts.Series(
          id: "RDPS",
          data: sortedByPartyWidgetDPSInfo,
          domainFn: (DPSInfo dps, _) => dps.user,
          measureFn: ((DPSInfo dps, _) => dps.rDPS),
          colorFn: ((DPSInfo dps, _) => dps.color),
          labelAccessorFn: (DPSInfo dps, _) =>
              "RDPS: ${dps.rDPS.toStringAsFixed(1)}",
          insideLabelStyleAccessorFn: (DPSInfo dpsInfo, _) {
            return new charts.TextStyleSpec(color: charts.MaterialPalette.black);
          },
          outsideLabelStyleAccessorFn: (DPSInfo dpsInfo, _) {
            return new charts.TextStyleSpec(color: themeColor.darkTheme? charts.MaterialPalette.white : charts.MaterialPalette.black);
          },
        ),
      );

      dpsData = chartData;

      response = await http.get(
          "https://www.fflogs.com/v1/report/tables/healing/" +
              widget.reportID +
              "?start=" +
              widget.ffLogFightData.start.toString() +
              "&end=" +
              widget.ffLogFightData.end.toString() +
              "&api_key=a468c182a1d6b2464526fb12ce56044f");

      entryList = jsonDecode(response.body)["entries"] as List;

      List<HPSInfo> playerHPSInfo = [];
      List<HPSInfo> sortedByPartyWidgetHPSInfo = [];
      List<charts.Series<HPSInfo, String>> hpsChartData = [];

      entryList.forEach((player) {
        print(player);
        if (player["name"] != "Limit Break" && player["name"] != "Ground Effect" && player["name"] != "Environment") {
          var hps = (player["total"] as int) /
              (widget.ffLogFightData.end - widget.ffLogFightData.start) *
              1000;

          var overheal = 0.0;
          if (player["overheal"] != null) {
            overheal = (player["overheal"] as int) /
                (widget.ffLogFightData.end - widget.ffLogFightData.start) *
                1000;
          }

          print(player["name"] +
              ": " +
              hps.toString() +
              " " +
              overheal.toString());

          playerHPSInfo.add(HPSInfo(
              user: player["name"] as String,
              HPS: hps,
              overhealPercentage: overheal,
              color: charts.Color.fromHex(
                  code: classToColor(player["type"] as String))));
        }
      });

      widget.ffxivParty.characters.forEach((character) {
        playerHPSInfo.forEach((player) {
          if (character.name == player.user) {
            sortedByPartyWidgetHPSInfo.add(player);
          }
        });
      });

      hpsChartData.add(new charts.Series(
        id: "HPS",
        data: sortedByPartyWidgetHPSInfo,
        domainFn: (HPSInfo hps, _) => hps.user,
        measureFn: ((HPSInfo hps, _) => hps.HPS),
        colorFn: ((HPSInfo hps, _) => hps.color),
        labelAccessorFn: (HPSInfo hps, _) =>
            "HPS: ${hps.HPS.toStringAsFixed(1)}",
        insideLabelStyleAccessorFn: (HPSInfo hps, _) {
          return new charts.TextStyleSpec(color: charts.MaterialPalette.black);
        },
        outsideLabelStyleAccessorFn: (HPSInfo hps, _) {
          return new charts.TextStyleSpec(color: themeColor.darkTheme? charts.MaterialPalette.white : charts.MaterialPalette.black);
        },
      ));

      hpsChartData.add(
        new charts.Series(
          id: "Overheal %",
          data: sortedByPartyWidgetHPSInfo,
          domainFn: (HPSInfo hps, _) => hps.user,
          measureFn: ((HPSInfo hps, _) => hps.overhealPercentage),
          colorFn: ((HPSInfo hps, _) => hps.color),
          labelAccessorFn: (HPSInfo hps, _) =>
              "Overheal: ${hps.overhealPercentage.toStringAsFixed(1)}%",
          insideLabelStyleAccessorFn: (HPSInfo hps, _) {
            return new charts.TextStyleSpec(color: charts.MaterialPalette.black);
          },
          outsideLabelStyleAccessorFn: (HPSInfo hps, _) {
            return new charts.TextStyleSpec(color: themeColor.darkTheme? charts.MaterialPalette.white : charts.MaterialPalette.black);
          },
        ),
      );

      hpsData = hpsChartData;

      return chartData;
    }

    print("I already have information. Here you go");

    if(chartName.contains("DPS")) {
      return dpsData;
    }else {
      return hpsData;
    }
  }

  String classToColor(String className) {
    switch (className) {
      case "Summoner":
        return "#53997a";

      case "Ninja":
        return "#a02c62";

      case "Samurai":
        return "#d5732c";

      case "BlackMage":
        return "#9e7cd0";

      case "Monk":
        return "#ce9e35";

      case "Machinist":
        return "#8cded6";

      case "Dragoon":
        return "#4964c6";

      case "RedMage":
        return "#da817e";

      case "Dancer":
        return "#dab3b0";

      case "Bard":
        return "#9ab86a";

      case "Warrior":
        return "#b8362b";

      case "Gunbreaker":
        return "#776d39";

      case "DarkKnight":
        return "#bf3cc6";

      case "Paladin":
        return "#b1d1e4";

      case "Astrologian":
        return "#fbe768";

      case "WhiteMage":
        return "#fdf1de";

      case "Scholar":
        return "#7f5ef6";
    }
  }
}
