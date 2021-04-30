import 'dart:convert';

import 'package:ffxiv_battle_logs/ffxiv_classes.dart';
import 'package:ffxiv_battle_logs/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'fflog_classes.dart';
import 'package:http/http.dart' as http;

class DeathSection extends StatefulWidget {
  final String reportID;
  final FFLogFightData fightData;

  DeathSection({this.reportID, this.fightData});

  @override
  _DeathSectionState createState() => _DeathSectionState();
}

class _DeathSectionState extends State<DeathSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Center(
              child: Text(
                "Deaths",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 8.0),
            constraints: BoxConstraints.expand(height: 100.0),
            decoration: BoxDecoration(color: Colors.transparent),
            child: Image.asset(
              "assets/images/class_action_icons/015000/015010.png",
              fit: BoxFit.contain,
            ),
          ),
          FutureBuilder(
            future: getDeaths(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.data == null) {
                return Container();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: PlatformCircularProgressIndicator(),
                );
              }

              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                if(snapshot.data.length == 0) {
                  return Column(children: <Widget>[
                    Text(
                        "No Deaths"
                    )
                  ]);
                }
                return Column(children: snapshot.data);
              }

              return new Container();
            },
          ),
        ],
      ),
    );
  }

  Future<List<Widget>> getDeaths() async {
    List<Widget> deaths = [];

    http.Response response = await http.get(Uri.parse(
        "https://www.fflogs.com/v1/report/tables/deaths/" +
            widget.reportID +
            "?start=" +
            widget.fightData.start.toString() +
            "&end=" +
            widget.fightData.end.toString() +
            "&api_key=a468c182a1d6b2464526fb12ce56044f"));

    print("https://www.fflogs.com/v1/report/tables/deaths/" +
        widget.reportID +
        "?start=" +
        widget.fightData.start.toString() +
        "&end=" +
        widget.fightData.end.toString() +
        "&api_key=a468c182a1d6b2464526fb12ce56044f");

    var deathList = jsonDecode(response.body)["entries"] as List;

    deathList.forEach((deathEvent) {
      print(deathEvent);
      FFLogDeathEvent event = FFLogDeathEvent.fromJson(deathEvent);
      deaths.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                      "[${Duration(milliseconds: event.timestamp - widget.fightData.start).toString().split('.').first.padLeft(8, "0")}]")),
              Expanded(
                flex: 3,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: "${event.playerName} ",
                          style: TextStyle(
                              color: Color(int.parse(
                                  "FF" +
                                      FFXIVClass.classToColor(event.className)
                                          .replaceAll("#", ""),
                                  radix: 16)))),
                      TextSpan(
                          text: event.killer != "fall damage" ? "was killed by ${event.killer} using" : "jumped off and died from ${event.killer}"
                      ),
                      TextSpan(
                          text: event.killer != "fall damage" ? " ${event.ability.name.isEmpty? "Unknown" : event.ability.name} " : "",
                          style: TextStyle(
                              color: Colors.lightBlueAccent
                          )
                      ),
                      TextSpan(
                          text: event.killer != "fall damage" ? "for ${event.damage.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} damage" : ""
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      deaths.add(Divider(color: Styles.getColorFromBrightness(context), thickness: 2.0,));
    });

    return deaths;
  }
}