import 'package:ffxiv_battle_logs/models/expansion.dart';

class Zone {
  final int? id;
  final String? name;
  final Expansion? expansion;

  Zone.fromJson(Map<String, dynamic>? json)
      : id = json?['id'],
        name = json?['name'],
        expansion = Expansion.fromJson(json?['expansion']);
}