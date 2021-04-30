import 'dart:convert';
import 'dart:io';

import 'package:ffxiv_battle_logs/ffxiv_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';

class FFLogParsePercentage {
  static String percentageToColor(double percentage) {
    if (percentage > 99) {
      return Colors.yellow.value.toRadixString(16);
    } else if (percentage >= 95 && percentage <= 99) {
      return Colors.orange.value.toRadixString(16);
    } else if (percentage >= 75 && percentage <= 94) {
      return Colors.purple.value.toRadixString(16);
    } else if (percentage >= 50 && percentage <= 74) {
      return Colors.blue.value.toRadixString(16);
    } else if (percentage >= 25 && percentage <= 49) {
      return Colors.green.value.toRadixString(16);
    } else {
      return Colors.grey.value.toRadixString(16);
    }
  }
}

//Requesting personal reports
class FFLogReport {
  final String id;
  final String title;
  final String owner;
  final int start;
  final int end;
  final int zone;

  FFLogReport(
      {this.id, this.title, this.owner, this.start, this.end, this.zone});

  factory FFLogReport.fromJson(Map<String, dynamic> json) {
    return FFLogReport(
        id: json["id"] as String,
        title: json["title"] as String,
        owner: json["owner"] as String,
        start: json["start"] as int,
        end: json["end"] as int,
        zone: json["zone"] as int);
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

  FFLogParseReport(
      {this.encounterName,
      this.classType,
      this.reportID,
      this.startTime,
      this.duration,
      this.difficulty});

  factory FFLogParseReport.fromJson(Map<String, dynamic> json) {
    return FFLogParseReport(
        encounterName: json["encounterName"] as String,
        classType: json["spec"] as String,
        startTime: json["startTime"] as int,
        reportID: json["reportID"],
        duration: json["duration"] as int,
        difficulty: json["difficulty"] as int);
  }
}

class FFLogZone {
  final int id;
  String zoneName;
  final bool isFrozen;
  final String expansion;
  final List<Encounter> encounters;

  FFLogZone({this.id, this.zoneName, this.isFrozen, this.expansion, this.encounters});

  factory FFLogZone.fromJson(Map<String, dynamic> json) {
    List<Encounter> encounters = [];

    if (json["encounters"] != null) {
      var encounterList = json["encounters"] as List;

      encounterList.forEach((data) {
        encounters.add(Encounter.fromJson(data));
      });
    }

    return FFLogZone(
        id: json["id"] as int,
        zoneName: json["name"] as String,
        isFrozen: json["frozen"] as bool,
        expansion: json["expansion"]["name"] as String,
        encounters: encounters);
  }
}

class GameData {
  static FFLogZones zones;
  static List<String> regions;
  static List<String> worlds = [
    "Adamantoise",
    "Aegis",
    "Alexander",
    "Anima",
    "Asura",
    "Atomos",
    "Bahamut",
    "Balmung",
    "Behemoth",
    "Belias",
    "Brynhildr",
    "Cactuar",
    "Carbuncle",
    "Cerberus",
    "Chocobo",
    "Coeurl",
    "Diabolos",
    "Durandal",
    "Excalibur",
    "Exodus",
    "Faerie",
    "Famfrit",
    "Fenrir",
    "Garuda",
    "Gilgamesh",
    "Goblin",
    "Gungnir",
    "Hades",
    "Hyperion",
    "Ifrit",
    "Ixion",
    "Jenova",
    "Kujata",
    "Lamia",
    "Leviathan",
    "Lich",
    "Louisoix",
    "Malboro",
    "Mandragora",
    "Masamune",
    "Mateus",
    "Midgardsormr",
    "Moogle",
    "Odin",
    "Omega",
    "Pandaemonium",
    "Phoenix",
    "Ragnarok",
    "Ramuh",
    "Ridill",
    "Sargatanas",
    "Shinryu",
    "Shiva",
    "Siren",
    "Tiamat",
    "Titan",
    "Tonberry",
    "Typhon",
    "Ultima",
    "Ultros",
    "Unicorn",
    "Valefor",
    "Yojimbo",
    "Zalera",
    "Zeromus",
    "Zodiark",
    "Spriggan",
    "Twintania"
  ];
}

class FFLogZones {
  List<FFLogZone> zones;

  FFLogZones(String contents) {
    var zoneList = jsonDecode(contents) as List;
    zones = [];

    zoneList.forEach((zoneData) {
      zones.add(FFLogZone.fromJson(zoneData));

      FFLogZone zoneAdded = zones[zones.length - 1];

      if (zoneAdded.zoneName == "Dungeons (Endgame)" ||
          zoneAdded.zoneName == "Trials (Extreme)") {
        zoneAdded.zoneName += "  ${zoneAdded.expansion}";
      }
    });

    zones.sort((FFLogZone a, FFLogZone b) {
      return a.id.compareTo(b.id);
    });
  }

  String zoneIDToName(int id) {
    String name = "";
    zones.forEach((zone) {
      if (zone.id == id) {
        name = zone.zoneName;
      }
    });
    return name;
  }

  bool isZoneExtreme(int id) {
    bool isExtreme = false;
    zones.forEach((zone) {
      if (zone.zoneName.contains("Extreme") && zone.id == id) {
        isExtreme = true;
      }
    });
    return isExtreme;
  }

  List<String> getZoneNames() {
    List<String> zoneNames = [];

    zones.forEach((zone) {
      zoneNames.add(zone.zoneName);

      if (zone.zoneName == "Dungeons (Endgame)" || zone.zoneName == "Trials (Extreme)") {
        zone.zoneName += "  ${zone.expansion}";
      }
    });

    zones.sort((FFLogZone a, FFLogZone b) {
      return a.id.compareTo(b.id);
    });

    return zoneNames;
  }

  List<Tuple2<String, int>> getZonesAsTuple()  {
    List<Tuple2<String, int>> zoneNames = [];

    zones.forEach((zone) {
      String zoneName = zone.zoneName;

      zoneNames.add(Tuple2<String, int>(zoneName, zone.id));
    });

    return zoneNames;
  }
}

class Encounter {
  final int id;
  final String name;

  Encounter({this.id, this.name});

  factory Encounter.fromJson(Map<String, dynamic> json) {
    return Encounter(id: json["id"] as int, name: json["name"] as String);
  }
}

class FFLogFight {
  final List<FFLogFightData> ffLogFightData;
  final List<Friendly> partyMembersInvolved;
  final List<Enemy> enemiesInvolved;

  FFLogFight(
      {this.ffLogFightData, this.partyMembersInvolved, this.enemiesInvolved});

  factory FFLogFight.fromJson(Map<String, dynamic> json) {
    List<FFLogFightData> fights = [];
    List<Friendly> friendlies = [];
    List<Enemy> enemies = [];

    if (json["fights"] != null) {
      var list = json["fights"] as List;

      list.forEach((fight) {
        if (fight["bossPercentage"] != null) {
          fights.add(FFLogFightData.fromJson(fight));
        }
      });
    }

    if (json["friendlies"] != null) {
      var list = json["friendlies"] as List;

      list.forEach((friendly) {
        if (friendly["server"] != null && friendly["type"] != "Unknown") {
          friendlies.add(Friendly.fromJson(friendly));
        }
      });
    }

    if (json["enemies"] != null) {
      var list = json["enemies"] as List;

      list.forEach((enemy) {
        enemies.add(Enemy.fromJson(enemy));
      });
    }

    return FFLogFight(
        ffLogFightData: fights,
        partyMembersInvolved: friendlies,
        enemiesInvolved: enemies);
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

  FFLogFightData(
      {this.id,
      this.start,
      this.end,
      this.boss,
      this.name,
      this.zoneID,
      this.zoneName,
      this.difficulty,
      this.kill,
      this.bossPercentage,
      this.phase});

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
        phase: json["lastPhaseForPercentageDisplay"] as int);
  }
}

class Friendly {
  final int id;
  final int guid;
  final FFXIVCharacter character;
  final List<Fight> fightIds;

  Friendly({this.id, this.guid, this.character, this.fightIds});

  factory Friendly.fromJson(Map<String, dynamic> json) {
    List<Fight> fights = [];

    if (json["fights"] != null) {
      var list = json["fights"] as List;

      list.forEach((fight) {
        fights.add(Fight.fromJson(fight));
      });
    }

    return Friendly(
        id: json["id"] as int,
        guid: json["guid"] as int,
        character: FFXIVCharacter(json["name"] as String, json["id"] as int,
            json["server"] as String, FFXIVClass(json["type"] as String)),
        fightIds: fights);
  }
}

class Enemy {
  final String name;
  final int id;
  final List<Fight> fightIds;

  Enemy({this.name, this.id, this.fightIds});

  factory Enemy.fromJson(Map<String, dynamic> json) {
    List<Fight> fights = [];

    if (json["fights"] != null) {
      var list = json["fights"] as List;

      list.forEach((fight) {
        fights.add(Fight.fromJson(fight));
      });
    }

    return Enemy(
        name: json["name"] as String, id: json["id"] as int, fightIds: fights);
  }
}

class Fight {
  final int id;

  Fight({this.id});

  factory Fight.fromJson(Map<String, dynamic> json) {
    return Fight(id: json["id"]);
  }
}

class FFLogEvent {
  final int timestamp; //when was it used
  final String type;
  final int sourceID; //Who used it
  final int targetID;
  final Ability ability;
  final int amount;

  FFLogEvent(
      {this.timestamp,
      this.type,
      this.sourceID,
      this.targetID,
      this.ability,
      this.amount});

  factory FFLogEvent.fromJson(Map<String, dynamic> json) {
    return FFLogEvent(
        timestamp: json["timestamp"] as int,
        type: json["type"] as String,
        sourceID: json["sourceID"] as int,
        targetID: json["targetID"] as int,
        ability: Ability.fromJson(json["ability"]),
        amount: json["amount"] as int);
  }
}

class Ability {
  final String name;
  final String abilityIcon;

  Ability({this.name, this.abilityIcon});

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
        name: json["name"] as String,
        abilityIcon: json["abilityIcon"].toString().replaceAll("-", "/"));
  }

  @override
  bool operator ==(other) {
    return other is Ability && this.name == other.name;
  }

  @override
  int get hashCode => this.name.hashCode;
}

class AbilityDamageInformation {
  int totalDamage;
  double dps;
  double percentage;

  AbilityDamageInformation(this.totalDamage, this.dps, this.percentage);
}

class FFLogDeathEvent {
  final String playerName;
  final String className;
  final int playerID;

  final int timestamp;

  final String killer;
  final int killerID;

  final Ability ability;
  final int damage;

  FFLogDeathEvent(
      {this.playerName,
      this.className,
      this.playerID,
      this.timestamp,
      this.killer,
      this.killerID,
      this.ability,
      this.damage});

  factory FFLogDeathEvent.fromJson(Map<String, dynamic> json) {
    var damage = jsonDecode(jsonEncode(json["damage"]));
    var sourceList = damage["sources"] as List;
    var source = jsonDecode(jsonEncode(sourceList));

    var events = jsonDecode(jsonEncode(json["events"]));

    Ability ability;

    if (json["killingBlow"] != null) {
      ability = Ability.fromJson(json["killingBlow"]);
    } else {
      ability = Ability(name: "", abilityIcon: "");
    }

    return FFLogDeathEvent(
        playerName: json["name"] as String,
        className: json["type"] as String,
        playerID: json["id"] as int,
        timestamp: json["timestamp"] as int,
        killer: source.length > 0 ? source[0]["name"] as String : "fall damage",
        killerID: events.length > 0 ? events[0]["sourceID"] : -1,
        ability: ability,
        damage: damage["total"] as int);
  }
}
