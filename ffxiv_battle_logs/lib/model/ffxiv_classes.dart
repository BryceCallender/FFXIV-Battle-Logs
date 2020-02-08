enum Priority {
  TANK,
  HEALER,
  DPS
}

class FFXIVClass {
  final String name;
  String iconPath;
  Priority priority;

  static const tanks = ["Paladin", "Dark Knight", "Warrior", "Gunbreaker"];
  static const healers = ["White Mage", "Scholar", "Astrologian"];

  FFXIVClass(this.name) {
    iconPath = "assets/images/class_icons/" + name.replaceAll(" ", "_").toLowerCase() + ".png";

    if(tanks.contains(name)) {
      priority = Priority.TANK;
    }else if(healers.contains(name)) {
      priority = Priority.HEALER;
    }else {
      priority = Priority.DPS;
    }
  }
}

class FFXIVCharacter {
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


  FFXIVCharacter(this.name, this.world, this.playerClass) {
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

  FFXIVParty({this.characters});

  sortClassesByPriority() {
    characters.sort((a,b) => a.playerClass.priority.index.compareTo(b.playerClass.priority.index));
  }

  addPlayersToParty(List<FFXIVCharacter> players) => characters = players;
}

