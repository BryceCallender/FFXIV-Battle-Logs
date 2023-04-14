import 'package:ffxiv_battle_logs/models/fight.dart';
import 'package:ffxiv_battle_logs/models/time_data.dart';

class Preview extends TimeData {
  final List<Fight> fights;

  Preview.fromJson(Map<String, dynamic> json)
      : fights =
            (json['fights'] as List).map((x) => Fight.fromJson(x)).toList(),
        super.fromJson(json);
}
