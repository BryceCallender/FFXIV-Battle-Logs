import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:ffxiv_battle_logs/authentication.dart';
import 'package:ffxiv_battle_logs/ff_logfights_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'fflog_classes.dart';

class PersonalLogPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyPersonalLogPage();

  final FFLogZones zoneData;
  final String userName;

  PersonalLogPage(this.userName, this.zoneData);
}

class _MyPersonalLogPage extends State<PersonalLogPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.userName + " Personal Logs")),
      body: FutureBuilder(
          future: getReports(),
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
                    return Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Card(
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
                                child: Image.asset(widget.zoneData.isZoneExtreme(snapshot.data[index].zone) ?
                                    "assets/images/map_icons/060000/060834.png":
                                    "assets/images/map_icons/060000/060855.png",
                                    fit: BoxFit.cover),
                              ),
                              title: Text(widget.zoneData
                                  .zoneIDToName(snapshot.data[index].zone)),
                              subtitle: Text("Date Logged: " +
                                  DateFormat.yMMMMd().add_jm().format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          snapshot.data[index].start))),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FFLogFightsPage(
                                            report: snapshot.data[index])));
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
          }),
    );
  }

  Future<List<FFLogReport>> getReports() async {
//    print("Getting zone data");
//    var zoneResponse = await http.get(
//        "https://www.fflogs.com/v1/zones?api_key=a468c182a1d6b2464526fb12ce56044f");
//
//    var zoneList = jsonDecode(zoneResponse.body) as List;
//
//    zoneList.forEach((zoneData) {
//      widget.zoneData.addZone(FFLogZone.fromJson(zoneData));
//    });

    List<FFLogReport> reports = [];

    http.Response response = await http.get(
        "https://www.fflogs.com/v1/reports/user/" +
            widget.userName +
            "?api_key=a468c182a1d6b2464526fb12ce56044f");

    var reportList = jsonDecode(response.body) as List;

    for (int i = 0; i < reportList.length; i++) {
      reports.add(FFLogReport.fromJson(reportList[i]));
    }

    return reports;
  }
}
