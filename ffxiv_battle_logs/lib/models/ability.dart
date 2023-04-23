class Ability {
  final String? name;
  final int? guid;
  final int? type;
  final String? iconPath;
  final int? total;
  
  String get abilityUrl {
    return 'https://xivapi.com/i/${iconPath?.split('-').join('/')}';
  }

  Ability.fromJson(Map<String, dynamic>? json)
    : name = json?['name'],
      guid = json?['guid'],
      type = json?['type'],
      iconPath = json?['abilityIcon'],
      total = json?['total'];
}