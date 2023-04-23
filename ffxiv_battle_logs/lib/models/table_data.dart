import 'package:ffxiv_battle_logs/models/ability.dart';
import 'package:ffxiv_battle_logs/models/death_event.dart';

class TableData {
  final int totalTime;
  final List<Ability> damageTaken;
  final List<DeathEvent> deathEvents;

  TableData.fromJson(Map<String, dynamic> json)
      : totalTime = json['totalTime'],
        damageTaken = (json['damageTaken'] as List)
            .map((c) => Ability.fromJson(c))
            .toList(),
        deathEvents = (json['deathEvents'] as List)
            .map((d) => DeathEvent.fromJson(d))
            .toList();
}