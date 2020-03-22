import 'package:ffxiv_battle_logs/finaleventsystem.dart';
import 'package:ffxiv_battle_logs/realtimeevent.dart';
import 'package:flutter/material.dart';

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
  final String className;
  final int start;
  final int end;
  final int sourceID;

  EventPage(
      this.playerName, this.reportID, this.className, this.start, this.end, this.sourceID);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _currentIndex == 0? Text("${widget.playerName}'s events"): Text("${widget.playerName}'s real time events"),
      ),
      body: _currentIndex == 0?
      FinalEventSystem(playerName: widget.playerName,
        reportID: widget.reportID,
        className: widget.className,
        start: widget.start,
        end: widget.end,
        sourceID: widget.sourceID,
      ):
      RealTimeEventSystem(playerName: widget.playerName,
        reportID: widget.reportID,
        className: widget.className,
        start: widget.start,
        end: widget.end,
        sourceID: widget.sourceID,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.flag),
            title: new Text("End Results"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.timer),
            title: new Text("Real Time"),
          ),
        ],
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
