import 'package:ffxiv_battle_logs/models/ability.dart';
import 'package:ffxiv_battle_logs/models/table_data.dart';

class FightTableUserData extends TableData {
  final List<Ability> damageDone;
  final List<Ability> healingDone;

  FightTableUserData.fromJson(Map<String, dynamic> json)
      : damageDone = (json['damageDone'] as List)
            .map((c) => Ability.fromJson(c))
            .toList(),
        healingDone = (json['healingDone'] as List)
            .map((c) => Ability.fromJson(c))
            .toList(),
        super.fromJson(json);
}
