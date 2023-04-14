import 'package:ffxiv_battle_logs/models/role.dart';

class Character {
  final int id;
  final int guid;
  final String name;
  final String type;
  final String server;
  final Role role;

  Character.fromJson(Map<String, dynamic> json, Role? role)
      : id = json['id'],
        guid = json['guid'],
        name = json['name'],
        type = json['type'],
        server = json['server'],
        role = role ?? Role.Unknown;
}