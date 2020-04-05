enum Priority {
  TANK,
  HEALER,
  DPS
}

class FFXIVClass {
  final String name;
  String iconPath;
  Priority priority;

  static const tanks = ["Paladin", "DarkKnight", "Warrior", "Gunbreaker"];
  static const healers = ["WhiteMage", "Scholar", "Astrologian"];

  FFXIVClass(this.name) {
    iconPath = "assets/images/class_icons/" + name.toLowerCase() + ".png";

    if(tanks.contains(name)) {
      priority = Priority.TANK;
    }else if(healers.contains(name)) {
      priority = Priority.HEALER;
    }else {
      priority = Priority.DPS;
    }

    print(priority.toString() + " " + name);
  }

  static String classToColor(String className) {
    switch (className) {
      case "Summoner":
        return "#53997a";

      case "Ninja":
        return "#a02c62";

      case "Samurai":
        return "#d5732c";

      case "BlackMage":
        return "#9e7cd0";

      case "Monk":
        return "#ce9e35";

      case "Machinist":
        return "#8cded6";

      case "Dragoon":
        return "#4964c6";

      case "RedMage":
        return "#da817e";

      case "Dancer":
        return "#dab3b0";

      case "Bard":
        return "#9ab86a";

      case "Warrior":
        return "#b8362b";

      case "Gunbreaker":
        return "#776d39";

      case "DarkKnight":
        return "#bf3cc6";

      case "Paladin":
        return "#b1d1e4";

      case "Astrologian":
        return "#fbe768";

      case "WhiteMage":
        return "#fdf1de";

      case "Scholar":
        return "#7f5ef6";
    }
  }
}

class FFXIVCharacter {
  final int sourceID;
  final String name;
  String region;
  final String world;

  final FFXIVClass playerClass;

  static const regionNA = ["Balmung","Brynhildr","Coeurl","Diabolos","Goblin",
    "Malboro","Mateus","Zalera", "Adamantoise","Cactuar","Faerie","Gilgamesh",
    "Jenova","Midgardsormr","Sargatanas","Siren","Behemoth","Excalibur","Exodus"
    ,"Famfrit","Hyperion","Lamia","Leviathan","Ultros"];

  static const regionEU = ["Cerberus","Louisoix","Moogle","Omega","Ragnarok",
    "Spriggan", "Lich","Odin","Phoenix","Shiva","Zodiark","Twintania"];

  static const regionJP = ["Aegis","Atomos","Carbuncle","Garuda","Gungnir",
    "Kujata","Ramuh","Tonberry","Typhon","Unicorn", "Alexander","Bahamut",
    "Durandal","Fenrir","Ifrit","Ridill","Tiamat","Ultima","Valefor","Yojimbo",
    "Zeromus","Anima","Asura","Belias","Chocobo","Hades","Ixion","Mandragora",
    "Masamune","Pandaemonium","Shinryu","Titan"];


  FFXIVCharacter(this.name, this.sourceID, this.world, this.playerClass) {
    if(regionNA.contains(world)){
      region = "NA";
    }else if(regionEU.contains(world)){
      region = "EU";
    }else {
      region = "JP";
    }

    print("$name is from the region: $region");
  }
}

class FFXIVParty {
  List<FFXIVCharacter> characters = new List<FFXIVCharacter>();

  FFXIVParty(this.characters) {
    sortClassesByPriority();
  }

  sortClassesByPriority() {
    characters.sort((a,b) => a.playerClass.priority.index.compareTo(b.playerClass.priority.index));
  }

  addPlayersToParty(List<FFXIVCharacter> players) => characters = players;
}

