import 'dart:collection';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:ffxiv_battle_logs/SlidingAbilities.dart';
import 'package:ffxiv_battle_logs/eventpage.dart';
import 'package:ffxiv_battle_logs/fflog_classes.dart';
import 'package:ffxiv_battle_logs/ffxiv_classes.dart';
import 'package:ffxiv_battle_logs/report_data_chart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'SkillDamageChart.dart';

class RealTimeEventSystem extends StatefulWidget {
  final String playerName;
  final String reportID;
  final String className;
  final int start;
  final int end;
  final int sourceID;

  RealTimeEventSystem(
      {this.playerName,
        this.reportID,
        this.start,
        this.end,
        this.sourceID,
        this.className});

  @override
  _RealTimeEventSystemState createState() => _RealTimeEventSystemState();
}

class _RealTimeEventSystemState extends State<RealTimeEventSystem> {
  List<Widget> textTimeEvents = [];
  String currentDPSTime = "";
  List<SlidingAbilities> usedAbilities = [];
  List<charts.Series<DPSEvent, String>> dpsData = [];
  DPSEvent currentDPSData;

  Map<Ability, AbilityDamageInformation> skillDamageMap =
  new Map<Ability, AbilityDamageInformation>();

  final AsyncMemoizer<List<FFLogEvent>> _memoizer = AsyncMemoizer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentDPSData = new DPSEvent(widget.playerName, 0);
  }

  @override
  Widget build(BuildContext context) {
    var data = [currentDPSData];
    var brightness = MediaQuery.of(context).platformBrightness;

    var series = [
      charts.Series(
        id: widget.playerName,
        data: data,
        domainFn: (DPSEvent dps, _) => dps.name,
        measureFn: ((DPSEvent dps, _) => dps.DPS),
        colorFn: ((DPSEvent dps, _) => charts.Color.fromHex(
            code: FFXIVClass.classToColor(widget.className))),
        labelAccessorFn: (DPSEvent dps, _) =>
        "DPS: ${currentDPSData.DPS.toStringAsFixed(1)}",
        insideLabelStyleAccessorFn: (DPSEvent dps, _) {
          return new charts.TextStyleSpec(color: charts.MaterialPalette.black);
        },
      ),
    ];

    List<SkillInfo> skills = [];
    skillDamageMap.forEach((key, value) => skills.add(SkillInfo(key, value)));

    skills.sort((a, b) => b.abilityDamageInformation.percentage
        .compareTo(a.abilityDamageInformation.percentage));

    var skillSeries = [
      charts.Series(
        id: "skills",
        data: skills,
        domainFn: (SkillInfo skillInfo, _) => skillInfo.ability.name.length < 15
            ? skillInfo.ability.name
            : skillInfo.ability.name.substring(0, 12) + "...",
        measureFn: (SkillInfo skillInfo, _) =>
        skillInfo.abilityDamageInformation.percentage,
        colorFn: (SkillInfo skillInfo, _) =>
            charts.Color.fromHex(code: "#FFA500"),
        labelAccessorFn: (SkillInfo skillInfo, _) =>
        "${NumberFormat.compact().format(skillInfo.abilityDamageInformation.totalDamage)}(${NumberFormat.compact().format(skillInfo.abilityDamageInformation.dps)}, ${skillInfo.abilityDamageInformation.percentage.truncate()}%)",
        insideLabelStyleAccessorFn: (SkillInfo skillInfo, _) {
          return new charts.TextStyleSpec(color: charts.MaterialPalette.black);
        },
        outsideLabelStyleAccessorFn: (SkillInfo skillInfo, _) {
          return new charts.TextStyleSpec(
              color: brightness == Brightness.dark
                  ? charts.MaterialPalette.white
                  : charts.MaterialPalette.black);
        },
      )
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
        SizedBox(
          height: 100,
          child:
          Stack(alignment: Alignment.centerRight, children: usedAbilities),
        ),
        SizedBox(height: 50.0),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Center(child: Text("Skill Breakdown")),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: SizedBox(
            height: 300,
            child:
            SkillDamageChart(skillSeries, animate: true, vertical: false),
          ),
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
    );
  }

  Future<List<FFLogEvent>> getEventData() {
    return _memoizer.runOnce(() async {
      print("Running to get event data!");

      List<FFLogEvent> eventData = [];

      http.Response response = await http.get(
          Uri.parse("https://www.fflogs.com/v1/report/events/summary/${widget.reportID}?start=${widget.start}&end=${widget.end}&sourceid=${widget.sourceID}&api_key=a468c182a1d6b2464526fb12ce56044f"));

      print(
          "https://www.fflogs.com/v1/report/events/summary/${widget.reportID}?start=${widget.start}&end=${widget.end}&sourceid=${widget.sourceID}&api_key=a468c182a1d6b2464526fb12ce56044f");

      var events = jsonDecode(response.body)["events"] as List;

      events.forEach((event) {
        eventData.add(FFLogEvent.fromJson(event));
      });

      calculateDPSFromEvents(eventData);
      showSkillsFromEvents(eventData);

      return eventData;
    });
  }

  void calculateDPSFromEvents(List<FFLogEvent> eventData) async {
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
        FFLogEvent event = eventData[eventIndex];
        //If we hit the event we want to display it
        if (currentMillis == event.timestamp) {
          if (event.type == "damage") {
            totalDamage += event.amount;
            int eventTime = event.timestamp - widget.start;
            int second = (eventTime ~/ 1000);

            skillDamageMap.forEach((ability, damageInformation) {
              damageInformation.dps =
                  damageInformation.totalDamage / (second == 0 ? 1 : second);

              damageInformation.percentage =
                  (damageInformation.totalDamage / totalDamage) * 100;
            });

            skillDamageMap.update(
              event.ability,
                  (oldAbilityDamageInformation) {
                oldAbilityDamageInformation.totalDamage += event.amount;
                oldAbilityDamageInformation.dps =
                    oldAbilityDamageInformation.totalDamage /
                        (second == 0 ? 1 : second);
                oldAbilityDamageInformation.percentage =
                    (oldAbilityDamageInformation.totalDamage / totalDamage) *
                        100;

                return oldAbilityDamageInformation;
              },
              ifAbsent: () {
                //print(event.ability.name + " added to the map");
                return AbilityDamageInformation(
                    event.amount,
                    event.amount / (second == 0 ? 1 : second),
                    (event.amount / totalDamage * 100));
              },
            );

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
                Text(
                    "[${duration.toString().substring(0, 11).padLeft(12, "0")}]: "),
                Image.asset(
                    "assets/images/class_action_icons/${event.ability.abilityIcon}"),
                Text(" hit for ${event.amount}")
              ],
            ));
          }
          eventIndex++;
        } else {
          //Update the build since its a new second so lets just update the time
          if (currentMillis % 1000 == 0) {
            if (this.mounted) {
              setState(() {
                Duration duration =
                new Duration(milliseconds: (currentMillis - widget.start));
                currentDPSTime =
                    duration
                        .toString()
                        .split('.')
                        .first
                        .padLeft(8, "0");
              });
            }
          }
          //It was not equal therefore we can go to the next millisecond
          await Future.delayed(Duration(milliseconds: 1));
          currentMillis++;
        }
      }
    }

    //Find out the totalDamage at the end of everything even after dying
    currentDPSData.DPS = totalDamage ~/ ((widget.end - widget.start) / 1000);
    //print("Final DPS: ${currentDPSData.DPS}");

    skillDamageMap.forEach((ability, damageInformation) {
      damageInformation.dps = damageInformation.totalDamage /
          ((widget.end - widget.start) / 1000);

      damageInformation.percentage =
          (damageInformation.totalDamage / totalDamage) * 100;
    });
  }

  void showSkillsFromEvents(List<FFLogEvent> eventData) async {
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
        FFLogEvent event = eventData[eventIndex];

        //If we hit the event we want to display it
        if (currentMillis == event.timestamp) {
          Duration duration =
          new Duration(milliseconds: (currentMillis - widget.start));
          textTimeEvents.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                  "[${duration.toString().substring(0, 11).padLeft(12, "0")}]: ${widget.playerName} casted "),
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

          usedAbilities.add(SlidingAbilities(
            abilityPath:
            "assets/images/class_action_icons/${event.ability.abilityIcon}",
            heightSlide: heightSlide,
          ));

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