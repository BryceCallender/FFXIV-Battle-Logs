import 'package:ffxiv_battle_logs/models/ability.dart';
import 'package:ffxiv_battle_logs/models/character.dart';

class DeathEvent {
  final Character character;
  final int deathTime;
  final Ability? ability;

  DeathEvent.fromJson(Map<String, dynamic> json)
    : character = Character.fromJson(json),
      deathTime = json['deathTime'],
      ability = Ability.fromJson(json['ability']);
}