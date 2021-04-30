import 'dart:convert';

import 'package:ffxiv_battle_logs/fflog_classes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:http/http.dart' as http;

import 'ffxiv_classes.dart';

class BossActions extends StatelessWidget {
  final String reportID;
  final FFLogFightData fightData;
  final List<Friendly> partyMembers;

  BossActions({this.reportID, this.fightData, this.partyMembers});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text("${fightData.name}'s Events"),
        backgroundColor: CupertinoColors.activeBlue,
        cupertino: (_, __) => CupertinoNavigationBarData(
            heroTag: "bossActions", transitionBetweenRoutes: false),
      ),
      body: SafeArea(
        child: Container(
          child: FutureBuilder(
            future: getBossActions(),
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
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    FFLogEvent event = snapshot.data[index];
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                                "[${Duration(milliseconds: event.timestamp - fightData.start).toString().split('.').first.padLeft(8, "0")}] "
                            ),
                            Expanded(
                              flex: 3,
                              child: Text.rich(
                                TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "${fightData.name} ",
                                          style: TextStyle(
                                              color: Colors.grey
                                          )
                                      ),
                                      TextSpan(
                                          text: event.type == "calculateddamage"? "prepares " : "used "
                                      ),
                                      TextSpan(
                                          text: "${event.ability.name.isEmpty? "Unknown" : event.ability.name} ",
                                          style: TextStyle(
                                              color: Colors.lightBlueAccent
                                          )
                                      ),
                                      TextSpan(
                                          text: "${event.type == "calculateddamage"? "targeting " : "hitting "}"
                                      ),
                                      TextSpan(
                                        text:  "${getNameFromID(event.targetID)}",
                                        style: TextStyle(
                                          color: Color(int.parse(
                                              "FF" +
                                                  FFXIVClass.classToColor(getClassNameFromID(event.targetID))
                                                      .replaceAll("#", ""),
                                              radix: 16),
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                          text: " for ${event.amount.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} damage"
                                      )
                                    ]
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return new Container();
            },
          ),
        ),
      ),
    );
  }

  Future<List<FFLogEvent>> getBossActions() async {
    List<FFLogEvent> eventActions = [];

    http.Response response = await http.get(Uri.parse(
        "https://www.fflogs.com/v1/report/events/damage-done/" +
            reportID +
            "?start=" +
            fightData.start.toString() +
            "&end=" +
            fightData.end.toString() +
            "&hostility=1" +
            "&api_key=a468c182a1d6b2464526fb12ce56044f"));

    print("https://www.fflogs.com/v1/report/events/damage-done/" +
        reportID +
        "?start=" +
        fightData.start.toString() +
        "&end=" +
        fightData.end.toString() +
        "&hostility=1" +
        "&api_key=a468c182a1d6b2464526fb12ce56044f");

    var bossActions = jsonDecode(response.body)["events"];

    bossActions.forEach((eventData) {
      eventActions.add(FFLogEvent.fromJson(eventData));
    });

    return eventActions;
  }

  String getNameFromID(int id) {
    return partyMembers.where((character) => character.id == id).first.character.name;
  }

  String getClassNameFromID(int id) {
    return partyMembers.where((character) => character.id == id).first.character.playerClass.name;
  }
}