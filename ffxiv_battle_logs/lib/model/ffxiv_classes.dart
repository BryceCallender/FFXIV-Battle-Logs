class FFXIVClass {
  final String _name;

  FFXIVClass(this._name);
}

class FFXIVCharacter {
  final String _name;
  final String _region;
  final String _world;

  final FFXIVClass _class;

  FFXIVCharacter(this._name, this._region, this._world, this._class);
}

class FFXIVParty {
  final List<FFXIVCharacter> _characters;

  FFXIVParty(this._characters);
}

