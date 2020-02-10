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
    print(zones.length);
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

}

class FFLogEvents {

}

enum TableView {
  damage_done,
  damage_taken,
  healing,
  casts,
  summons,
  buffs,
  debuffs,
  deaths
}

class FFLogTableView {
  final TableView _tableView;

  FFLogTableView(this._tableView);
}