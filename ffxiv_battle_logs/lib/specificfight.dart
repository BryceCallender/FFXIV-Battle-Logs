import 'package:ffxiv_battle_logs/FFXIVPartySection.dart';
import 'package:ffxiv_battle_logs/fflog_classes.dart';
import 'package:ffxiv_battle_logs/ffxiv_classes.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpecificFightReport extends StatelessWidget {
  final FFLogFightData ffLogFightData;
  final List<Friendly> partyMembers;
  final String reportID;

  SpecificFightReport(
      {Key key,
      @required this.ffLogFightData,
      @required this.partyMembers,
      @required this.reportID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fight #" + ffLogFightData.id.toString()),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            getPartyWidget(),
            Text("Events"),
            Expanded(
              child: FutureBuilder(
                future: getEventData(),
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
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          "assets/images/class_action_icons/" +
                              snapshot.data[index].ability.abilityIcon,
                          width: 40,
                          height: 40,
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getPartyWidget() {
    List<FFXIVCharacter> partyMembersInvolved = new List();

    partyMembers.forEach((friendly) {
      friendly.fightIds.forEach((fightID) {
        if (fightID.id == ffLogFightData.id) {
          partyMembersInvolved.add(friendly.character);
        }
      });
    });

    FFXIVParty ffxivParty = new FFXIVParty(partyMembersInvolved);

    return FFXIVPartySection(ffxivParty);
  }

  Future<List<FFLogDamageDoneEvent>> getEventData() async {
    List<FFLogDamageDoneEvent> eventData = [];

    var events;
    http.Response response;
    String startTimestamp = ffLogFightData.start.toString();

//    do {
//      response = await http.get(
//          "https://www.fflogs.com/v1/report/events/damage-done/" +
//              reportID +
//              "?start=" + startTimestamp +
//              "&end=" + ffLogFightData.end.toString() +
//              "&api_key=a468c182a1d6b2464526fb12ce56044f");
//
//      print("https://www.fflogs.com/v1/report/events/damage-done/" +
//          reportID +
//          "?start=" + startTimestamp +
//          "&end=" + ffLogFightData.end.toString() +
//          "&api_key=a468c182a1d6b2464526fb12ce56044f");
//
//      events = jsonDecode(response.body);
//
//      var listOfEvents = events["events"] as List;
//
//      listOfEvents.forEach((event) {
//        eventData.add(FFLogDamageDoneEvent.fromJson(event));
//      });
//
//      startTimestamp = events["nextPageTimestamp"].toString();
//
//    }while(events.containsKey("nextPageTimestamp"));

    print(eventData.length);

    return eventData;
  }
}
