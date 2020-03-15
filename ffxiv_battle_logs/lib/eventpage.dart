import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:ffxiv_battle_logs/SlidingAbilities.dart';
import 'package:ffxiv_battle_logs/report_data_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'fflog_classes.dart';
import 'dart:async';

class DPSEvent {
  final String name;
  int DPS;

  DPSEvent(this.name, this.DPS);

  void addDamage(int amount) {
    DPS += amount;
  }
}

class EventPage extends StatefulWidget {
  final String playerName;
  final String reportID;
  final int start;
  final int end;
  final int sourceID;

  EventPage(
      this.playerName, this.reportID, this.start, this.end, this.sourceID);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<charts.Series<DPSEvent, String>> dpsData = [];
  DPSEvent currentDPSData;
  String currentDPSTime = "";

  List<SlidingAbilities> usedAbilities = [];
  List<Widget> textTimeEvents = [];

  final AsyncMemoizer<List<FFLogDamageDoneEvent>> _memoizer = AsyncMemoizer();

  @override
  void initState() {
    super.initState();
    currentDPSData = new DPSEvent(widget.playerName, 0);
  }

  @override
  Widget build(BuildContext context) {
    var data = [currentDPSData];

    var series = [
      charts.Series(
        id: widget.playerName,
        data: data,
        domainFn: (DPSEvent dps, _) => dps.name,
        measureFn: ((DPSEvent dps, _) => dps.DPS),
        labelAccessorFn: (DPSEvent dps, _) =>
            "DPS: ${currentDPSData.DPS.toStringAsFixed(1)}",
        insideLabelStyleAccessorFn: (DPSEvent dps, _) {
          return new charts.TextStyleSpec(color: charts.MaterialPalette.black);
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.playerName}'s real time events"),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 20),
            child: SizedBox(
              height: 400,
              child: ReportDataChart(series, animate: true, vertical: true),
            ),
          ),
          Center(child: Text("Boss time: " + currentDPSTime)),
          SizedBox(
            height: 100,
            child: Stack(
                alignment: Alignment.centerRight, children: usedAbilities),
          ),
          SizedBox(height: 50),
          FutureBuilder(
            future: getEventData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.data == null) {
                return Container();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(children: [
                    Text("Reading all event data may take some time!"),
                    CircularProgressIndicator()
                  ]),
                );
              }

              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: textTimeEvents,
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<List<FFLogDamageDoneEvent>> getEventData() {
    return _memoizer.runOnce(() async {
      print("Running to get event data!");

      List<FFLogDamageDoneEvent> eventData = [];

      http.Response response = await http.get(
          "https://www.fflogs.com/v1/report/events/summary/${widget.reportID}?start=${widget.start}&end=${widget.end}&sourceid=${widget.sourceID}&api_key=a468c182a1d6b2464526fb12ce56044f");

      print(
          "https://www.fflogs.com/v1/report/events/summary/${widget.reportID}?start=${widget.start}&end=${widget.end}&sourceid=${widget.sourceID}&api_key=a468c182a1d6b2464526fb12ce56044f");

      var events = jsonDecode(response.body)["events"] as List;

      events.forEach((event) {
        eventData.add(FFLogDamageDoneEvent.fromJson(event));
      });

      calculateDPSFromEvents(eventData);
      showSkillsFromEvents(eventData);

      return eventData;
    });
  }

  void calculateDPSFromEvents(List<FFLogDamageDoneEvent> eventData) async {
    eventData = eventData
        .where((event) =>
            (event.type == "damage") && event.sourceID == widget.sourceID)
        .toList();

    int totalDamage = 0;
    int eventIndex = 0;

    int currentMillis = widget.start;

    while (currentMillis < widget.end && eventIndex < eventData.length) {
      //If we have data
      if (eventData.isNotEmpty) {
        //grab and store the data
        FFLogDamageDoneEvent event = eventData[eventIndex];
        //If we hit the event we want to display it
        if (currentMillis == event.timeStamp) {
          if (event.type == "damage") {
            setState(() {
              totalDamage += event.amount;
              int eventTime = event.timeStamp - widget.start;
              int second = (eventTime ~/ 1000);
              if (second != 0) {
                currentDPSData.DPS = totalDamage ~/ second;
              }
              Duration duration =
                  new Duration(milliseconds: (currentMillis - widget.start));
              currentDPSTime =
                  duration.toString().split('.').first.padLeft(8, "0");

              textTimeEvents.add(Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("[${duration.toString().split('.').first.padLeft(8, "0")}]: "),
                  Image.asset(
                      "assets/images/class_action_icons/${event.ability.abilityIcon}"),
                  Text(" hit for ${event.amount}")
                ],
              ));
              //print("DPS: ${currentDPSData.DPS} Time: $currentDPSTime");
            });
          }
          eventIndex++;
        } else {
          //Update the build since its a new second so lets just update the time
          if(currentMillis % 1000 == 0) {
            setState(() {
              Duration duration =
              new Duration(milliseconds: (currentMillis - widget.start));
              currentDPSTime =
                  duration.toString().split('.').first.padLeft(8, "0");
            });
          }
          //It was not equal therefore we can go to the next millisecond
          await Future.delayed(Duration(milliseconds: 1));
          currentMillis++;
        }
      }
    }

    //Good code for a second per tick
//    for (FFLogDamageDoneEvent event in eventData) {
//      int eventTime = event.timeStamp - startTime;
//      int second = (eventTime ~/ 1000);
////      print(second);
////      print(event.ability.name +
////          " was used with " +
////          event.amount.toString() +
////          " damage");
//      totalDamage += event.amount;
//
//      for (; currentTime < second; currentTime++) {
//        setState(() {
//          Duration duration = new Duration(seconds: currentTime);
//          currentDPSTime = duration.toString().split('.').first.padLeft(8, "0");
//        });
//        await Future.delayed(Duration(seconds: 1));
//      }
//
//      if (currentTime == second) {
//        setState(() {
//          if (second != 0) {
//            currentDPSData.DPS = totalDamage ~/ second;
//          }
//          Duration duration = new Duration(seconds: currentTime);
//          currentDPSTime = duration.toString().split('.').first.padLeft(8, "0");
//          //print("DPS: ${currentDPSData.DPS} Time: $currentDPSTime");
//        });
//      }
//    }

    setState(() {
      //Find out the totalDamage at the end of everything even after dying
      currentDPSData.DPS = totalDamage ~/ ((widget.end - widget.start) / 1000);
      //print("Final DPS: ${currentDPSData.DPS}");
    });
  }

  void showSkillsFromEvents(List<FFLogDamageDoneEvent> eventData) async {
    eventData = eventData
        .where((event) =>
            event.type == "cast" && event.sourceID == widget.sourceID)
        .toList();
    double heightSlide = 0.0;
    int eventIndex = 0;
    int currentMillis = widget.start;
    int previousEventMillis = 0;

    while (currentMillis < widget.end && eventIndex < eventData.length) {
      //If we have data
      if (eventData.isNotEmpty) {
        //grab and store the data
        FFLogDamageDoneEvent event = eventData[eventIndex];
        //If we hit the event we want to display it
        if (currentMillis == event.timeStamp) {
          Duration duration =
              new Duration(milliseconds: (currentMillis - widget.start));
          textTimeEvents.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                  "[${duration.toString().split('.').first.padLeft(8, "0")}]: ${widget.playerName} casted "),
              Image.asset(
                  "assets/images/class_action_icons/${event.ability.abilityIcon}")
            ],
          ));
          //If something before it matches the time close by (weaving or auto on same time event)
          if ((currentMillis - previousEventMillis).abs() < 100) {
            heightSlide += 1.0;
          } else {
            heightSlide = 0.0;
          }
          //print("Casted: ${event.ability.name}");
          setState(() {
            usedAbilities.add(SlidingAbilities(
              abilityPath:
                  "assets/images/class_action_icons/${event.ability.abilityIcon}",
              heightSlide: heightSlide,
            ));
          });
          previousEventMillis = currentMillis;
          eventIndex++;
        } else {
          currentMillis++;
          //It was not equal therefore we can go to the next millisecond
          await Future.delayed(Duration(milliseconds: 1));
        }
      }
    }
  }
}
