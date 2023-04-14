import 'package:ffxiv_battle_logs/models/player_details.dart';

class Breakdown {
  final PlayerDetails playerDetails;

  Breakdown.fromJson(Map<String, dynamic> json)
    : playerDetails = PlayerDetails.fromJson(json['playerDetails']['data']['playerDetails']);
}