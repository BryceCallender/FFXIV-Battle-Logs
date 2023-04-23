import 'package:ffxiv_battle_logs/models/player_details.dart';
import 'package:ffxiv_battle_logs/models/fight_table_overall_data.dart';
import 'package:ffxiv_battle_logs/models/rankings.dart';

class Breakdown {
  final PlayerDetails playerDetails;
  final FightTableOverallData tableData;
  final Rankings rankings;

  Breakdown.fromJson(Map<String, dynamic> json)
    : playerDetails = PlayerDetails.fromJson(json['playerDetails']['data']['playerDetails']),
      tableData = FightTableOverallData.fromJson(json['table']['data']),
      rankings = Rankings.fromJson(json['rankings']?['data']);
}