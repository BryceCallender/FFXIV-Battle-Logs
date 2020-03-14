import 'dart:convert';
import 'dart:io';

import 'package:ffxiv_battle_logs/ffxiv_classes.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';

//Requesting personal reports
class FFLogReport {
  final String id;
  final String title;
  final String owner;
  final int start;
  final int end;
  final int zone;

  FFLogReport({this.id, this.title, this.owner, this.start, this.end, this.zone});

  factory FFLogReport.fromJson(Map<String, dynamic> json) {
    return FFLogReport(
      id: json["id"] as String,
      title: json["title"] as String,
      owner: json["owner"] as String,
      start: json["start"] as int,
      end: json["end"] as int,
      zone: json["zone"] as int
    );
  }
}

//Requesting other people
class FFLogParseReport {
  final String encounterName;
  final String classType;
  final String reportID;
  final int startTime;
  final int duration;
  final int difficulty;

  FFLogParseReport({this.encounterName, this.classType, this.reportID, this.startTime, this.duration, this.difficulty});

  factory FFLogParseReport.fromJson(Map<String, dynamic> json) {
    return FFLogParseReport(
        encounterName: json["encounterName"] as String,
        classType: json["spec"] as String,
        startTime: json["startTime"] as int,
        reportID: json["reportID"],
        duration: json["duration"] as int,
        difficulty: json["difficulty"] as int
    );
  }
}

class FFLogZone {
  final int id;
  final String zoneName;
  final bool isFrozen;
  final List<Encounter> encounters;

  FFLogZone({this.id,this.zoneName,this.isFrozen,this.encounters});

  factory FFLogZone.fromJson(Map<String, dynamic> json) {
    List<Encounter> encounters = [];

    if(json["encounters"] != null) {
      var encounterList = json["encounters"] as List;

      encounterList.forEach((data) {
        encounters.add(Encounter.fromJson(data));
      });
    }

    return FFLogZone(
      id: json["id"] as int,
      zoneName: json["name"] as String,
      isFrozen: json["frozen"] as bool,
      encounters: encounters
    );
  }
}

class FFLogZones {
  List<FFLogZone> zones;

  FFLogZones() {
    zones = [];

    Future<String> contents = rootBundle.loadString("assets/zones.json");

    contents.then((result) {
      var zoneList = jsonDecode(result) as List;

      zoneList.forEach((zoneData) {
        zones.add(FFLogZone.fromJson(zoneData));
      });
    });
  }

  String zoneIDToName(int id) {
    String name = "";
    zones.forEach((zone) {
      if(zone.id == id) {
        name = zone.zoneName;
      }
    });
    return name;
  }

  bool isZoneExtreme(int id) {
    bool isExtreme = false;
    zones.forEach((zone) {
      if(zone.zoneName.contains("Extreme") && zone.id == id) {
        isExtreme = true;
      }
    });
    return isExtreme;
  }

  List<String> getZoneNames() {
    List<String> zoneNames = [];

    this.zones.forEach((zone) {
        zoneNames.add(zone.zoneName);
    });

    return zoneNames;
  }


  Future<List<Tuple2<String,int>>> getZoneNamesAsync() async {
    String contents = await rootBundle.loadString("assets/zones.json");

    bool foundDungeon = false;
    bool foundTrial = false;

    List<String> appendData = ["ARR and HW ", "Stormblood ", "Shadowbringers "];
    int appendIndex = 0;

    var zoneList = jsonDecode(contents) as List;
    zones = [];

    zoneList.forEach((zoneData) {
      zones.add(FFLogZone.fromJson(zoneData));
    });

    List<Tuple2<String,int>> zoneNames = [];

    this.zones.forEach((zone) {
      String zoneName = zone.zoneName;
      if(zone.zoneName == "Dungeons (Endgame)") {
        foundDungeon = true;
        zoneName = appendData[appendIndex] + zoneName;
      }else if(zone.zoneName == "Trials (Extreme)") {
        foundTrial = true;
        zoneName = appendData[appendIndex] + zoneName;
      }

      if(foundDungeon && foundTrial) {
        appendIndex++;
        foundDungeon = false;
        foundTrial = false;
      }

      zoneNames.add(Tuple2<String,int>(zoneName, zone.id));
    });

    return zoneNames;
  }
}

class Encounter {
  final int id;
  final String name;

  Encounter({this.id,this.name});

  factory Encounter.fromJson(Map<String, dynamic> json) {
    return Encounter(
      id: json["id"] as int,
      name: json["name"] as String
    );
  }
}

class FFLogAccount {
  final String userName;

  FFLogAccount(this.userName);
}

class FFLogFight {
  final List<FFLogFightData> ffLogFightData;
  final List<Friendly> partyMembersInvolved;

  FFLogFight({this.ffLogFightData,this.partyMembersInvolved});

  factory FFLogFight.fromJson(Map<String, dynamic> json) {
    List<FFLogFightData> fights = [];
    List<Friendly> friendlies = [];

    if(json["fights"] != null) {
      var list = json["fights"] as List;

      list.forEach((fight) {
        if(fight["bossPercentage"] != null) {
          fights.add(FFLogFightData.fromJson(fight));
        }
      });
    }

    if(json["friendlies"] != null) {
      var list = json["friendlies"] as List;

      list.forEach((friendly) {
        if(friendly["server"] != null && friendly["type"] != "Unknown") {
          friendlies.add(Friendly.fromJson(friendly));
        }
      });
    }

    return FFLogFight(
      ffLogFightData: fights,
      partyMembersInvolved: friendlies
    );
  }
}

class FFLogFightData {
  final int id;
  final int start;
  final int end;
  final int boss;
  final String name;
  final int zoneID;
  final String zoneName;
  final int difficulty; //Will determine normal,hard,extreme,savage,etc...
  final bool kill;
  final int bossPercentage;
  final int phase;

  FFLogFightData({this.id,this.start,this.end,this.boss,this.name,this.zoneID,
    this.zoneName, this.difficulty,this.kill, this.bossPercentage, this.phase});

  factory FFLogFightData.fromJson(Map<String, dynamic> json) {
    return FFLogFightData(
      id: json["id"] as int,
      start: json["start_time"] as int,
      end: json["end_time"] as int,
      boss: json["boss"] as int,
      name: json["name"] as String,
      zoneID: json["zoneID"] as int,
      zoneName: json["zoneName"] as String,
      difficulty: json["difficulty"] as int,
      kill: json["kill"] as bool,
      bossPercentage: json["bossPercentage"] as int,
      phase: json["lastPhaseForPercentageDisplay"] as int
    );
  }
}

class Friendly {
  final int id;
  final int guid;
  final FFXIVCharacter character;
  final List<Fight> fightIds;

  Friendly({this.id,this.guid,this.character,this.fightIds});

  factory Friendly.fromJson(Map<String, dynamic> json) {
    List<Fight> fights = [];

    if(json["fights"] != null) {
      var list = json["fights"] as List;

      list.forEach((fight) {
        fights.add(Fight.fromJson(fight));
      });
    }

    return Friendly(
      id: json["id"] as int,
      guid: json["guid"] as int,
      character: FFXIVCharacter(
          json["name"] as String,
          json["id"] as int,
          json["server"] as String,
          FFXIVClass(json["type"] as String)
      ),
      fightIds: fights
    );
  }
}

class Fight {
  final int id;

  Fight({this.id});

  factory Fight.fromJson(Map<String, dynamic> json) {
    return Fight(
      id: json["id"]
    );
  }
}

enum EventView {
  summary,
  damage_done,
  damage_taken,
  healing,
}

class FFLogEvents {
  //final EventView eventView;

}

class FFLogSummaryEvent {

}

class FFLogDamageDoneEvent {
  final int timeStamp; //when was it used
  final String type;
  final int sourceID; //Who used it
  final Ability ability;
  final int amount;

  FFLogDamageDoneEvent({this.timeStamp, this.type, this.sourceID, this.ability, this.amount});

  factory FFLogDamageDoneEvent.fromJson(Map<String, dynamic> json) {
    return FFLogDamageDoneEvent(
      timeStamp: json["timestamp"] as int,
      type: json["type"] as String,
      sourceID: json["sourceID"] as int,
      ability: Ability.fromJson(json["ability"]),
      amount: json["amount"] as int
    );
  }

}

class Ability {
  final String name;
  final String abilityIcon;

  Ability({this.name,this.abilityIcon});

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      name: json["name"] as String,
      abilityIcon: json["abilityIcon"].toString().replaceAll("-", "/")
    );
  }
}

enum TableView {
  damage_done,
  damage_taken,
  healing,
}

class FFLogTableView {
  final TableView tableView;

  FFLogTableView({this.tableView});
}