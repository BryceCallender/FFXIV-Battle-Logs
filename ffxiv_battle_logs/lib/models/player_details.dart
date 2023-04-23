import 'package:ffxiv_battle_logs/models/character.dart';
import 'package:ffxiv_battle_logs/models/role.dart';

class PlayerDetails {
  final List<Character> healers;
  final List<Character> tanks;
  final List<Character> dps;

  PlayerDetails.fromJson(Map<String, dynamic> json)
      : healers = (json['healers'] as List)
            .map((c) => Character.fromJson(c, role: Role.Healer))
            .toList(),
        tanks = (json['tanks'] as List)
            .map((c) => Character.fromJson(c, role: Role.Tank))
            .toList(),
        dps = (json['dps'] as List)
            .map((c) => Character.fromJson(c, role: Role.Dps))
            .toList();
}
