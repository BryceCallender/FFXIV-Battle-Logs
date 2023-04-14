import 'package:ffxiv_battle_logs/models/time_data.dart';

class Fight extends TimeData {
  final int id;
  final int encounterID;
  final String name;
  final num? bossPercentage;
  final num? fightPercentage;
  final bool? kill;

  Fight.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        encounterID = json['encounterID'],
        name = json['name'],
        bossPercentage = json['bossPercentage'],
        fightPercentage = json['fightPercentage'],
        kill = json['kill'], super.fromJson(json);
}