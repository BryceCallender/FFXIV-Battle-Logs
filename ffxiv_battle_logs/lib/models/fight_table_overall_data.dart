import 'package:ffxiv_battle_logs/models/character.dart';
import 'package:ffxiv_battle_logs/models/table_data.dart';

class FightTableOverallData extends TableData {
  final List<Character> damageDone;
  final List<Character> healingDone;

  FightTableOverallData.fromJson(Map<String, dynamic> json)
      : damageDone = (json['damageDone'] as List)
            .map((c) => Character.fromJson(c))
            .toList(),
        healingDone = (json['healingDone'] as List)
            .map((c) => Character.fromJson(c))
            .toList(),
        super.fromJson(json);
}
