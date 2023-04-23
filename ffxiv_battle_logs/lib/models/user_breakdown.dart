import 'package:ffxiv_battle_logs/models/fight_table_user_data.dart';

class UserBreakdown {
  final FightTableUserData tableData;

  UserBreakdown.fromJson(Map<String, dynamic> json)
      : tableData = FightTableUserData.fromJson(json['table']['data']);
}