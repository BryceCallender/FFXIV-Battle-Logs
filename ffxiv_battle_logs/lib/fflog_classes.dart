import 'package:ffxiv_battle_logs/ffxiv_classes.dart';

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

class FFLogZone {
  final int id;
  final String zoneName;
  final bool isFrozen;
  final List<Encounter> encounters;

  FFLogZone({this.id,this.zoneName,this.isFrozen,this.encounters});

  factory FFLogZone.fromJson(Map<String, dynamic> json) {
    List<Encounter> encounters = new List();

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
  final List<FFLogZone> zones;

  FFLogZones(this.zones);

  void addZone(FFLogZone zone) {
    zones.add(zone);
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
    List<FFLogFightData> fights = new List();
    List<Friendly> friendlies = new List();

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
  final int phase;//Will be > 8 since its for every fight which incorporates people who joined/left.

  FFLogFightData({this.id,this.start,this.end,this.boss,this.name,this.zoneID,
    this.zoneName, this.difficulty,this.kill,this.phase});

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
    List<Fight> fights = new List();

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
  final String typeToSearch = "calculateddamage";

//  final int timeStamp;
//  final String type;
//  final int sourceID; //Who used it
//  final Ability ability;
//  final int amount;
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