class FightMap {
  final int id;

  FightMap.fromJson(Map<String, dynamic> json)
    : id = json['id'];
}