import 'dart:convert';

import 'package:async/async.dart';
import 'package:ffxiv_battle_logs/eventpage.dart';
import 'package:ffxiv_battle_logs/fflog_classes.dart';
import 'package:ffxiv_battle_logs/ffxiv_classes.dart';
import 'package:ffxiv_battle_logs/report_data_chart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;

class FinalEventSystem extends StatefulWidget {
  final String playerName;
  final String reportID;
  final String className;
  final int start;
  final int end;
  final int sourceID;

  FinalEventSystem(
      {this.playerName, this.reportID, this.start, this.end, this.sourceID, this.className});

  @override
  _FinalTimeEventSystemState createState() => _FinalTimeEventSystemState();
}

class _FinalTimeEventSystemState extends State<FinalEventSystem> {
  List<Widget> textTimeEvents = [];
  String currentDPSTime = "";
  List<charts.Series<DPSEvent, String>> dpsData = [];
  DPSEvent currentDPSData;

  final AsyncMemoizer<List<FFLogDamageDoneEvent>> _memoizer = AsyncMemoizer();

  @override
  void initState() {
    // TODO: implement initState
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
        colorFn: ((DPSEvent dps, _) => charts.Color.fromHex(code: FFXIVClass.classToColor(widget.className))),
        labelAccessorFn: (DPSEvent dps, _) =>
            "DPS: ${currentDPSData.DPS.toStringAsFixed(1)}",
        insideLabelStyleAccessorFn: (DPSEvent dps, _) {
          return new charts.TextStyleSpec(color: charts.MaterialPalette.black);
        },
      ),
    ];

    return ListView(
      children: [
        Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 20),
          child: SizedBox(
            height: 400,
            child: ReportDataChart(series, animate: true, vertical: true),
          ),
        ),
        Center(child: Text("Boss time: " + currentDPSTime)),
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

      calculateEvents(eventData);

      return eventData;
    });
  }

  void calculateEvents(List<FFLogDamageDoneEvent> eventData) {
    eventData = eventData
        .where((event) =>
            (event.type == "damage" || event.type == "cast") &&
            event.sourceID == widget.sourceID)
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
          Duration duration =
          new Duration(milliseconds: (currentMillis - widget.start));

          if (event.type == "damage") {
            totalDamage += event.amount;
            int eventTime = event.timeStamp - widget.start;
            int second = (eventTime ~/ 1000);
            if (second != 0) {
              currentDPSData.DPS = totalDamage ~/ second;
            }

            textTimeEvents.add(Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                    "[${duration
                        .toString()
                        .substring(0, 11)
                        .padLeft(12, "0")}]: "),
                Image.asset(
                    "assets/images/class_action_icons/${event.ability
                        .abilityIcon}"),
                Text(" hit for ${event.amount}")
              ],
            ));
          } else {
            textTimeEvents.add(Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                    "[${duration
                        .toString()
                        .substring(0, 11)
                        .padLeft(12, "0")}]: ${widget.playerName} casted "),
                Image.asset(
                    "assets/images/class_action_icons/${event.ability
                        .abilityIcon}")
              ],
            ));
          }
          eventIndex++;
        } else {
          currentMillis++;
        }
      }
    }

    setState(() {
      //Find out the totalDamage at the end of everything even after dying
      currentDPSData.DPS =
          totalDamage ~/ ((widget.end - widget.start) / 1000);
      Duration duration =
          new Duration(milliseconds: (widget.end - widget.start));
      currentDPSTime = duration.toString().split('.').first.padLeft(8, "0");
    });
  }
}
