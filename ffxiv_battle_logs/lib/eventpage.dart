import 'package:ffxiv_battle_logs/ffxiv_classes.dart';
import 'package:ffxiv_battle_logs/finaleventsystem.dart';
import 'package:ffxiv_battle_logs/realtimeevent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class DPSEvent {
  final String name;
  int DPS;

  DPSEvent(this.name, this.DPS);

  void addDamage(int amount) {
    DPS += amount;
  }
}

class EventPage extends StatefulWidget {
  final FFXIVCharacter player;
  final String reportID;
  final int start;
  final int end;

  EventPage(
      this.player, this.reportID, this.start, this.end);

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
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: _currentIndex == 0? Text("${widget.player.name}'s events"): Text("${widget.player.name}'s real time events"),
        backgroundColor: CupertinoColors.activeBlue,
        ios: (_) => CupertinoNavigationBarData(
          heroTag: "event",
          transitionBetweenRoutes: false,
        ),
      ),
      body: _currentIndex == 0?
      FinalEventSystem(playerName: widget.player.name,
        reportID: widget.reportID,
        className: widget.player.playerClass.name,
        start: widget.start,
        end: widget.end,
        sourceID: widget.player.sourceID,
      ):
      RealTimeEventSystem(playerName: widget.player.name,
        reportID: widget.reportID,
        className: widget.player.playerClass.name,
        start: widget.start,
        end: widget.end,
        sourceID: widget.player.sourceID,
      ),
      bottomNavBar: PlatformNavBar(
        currentIndex: _currentIndex,
        itemChanged: onItemTapped,
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
