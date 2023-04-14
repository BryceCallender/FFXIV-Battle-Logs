import 'package:ffxiv_battle_logs/models/time_data.dart';
import 'package:ffxiv_battle_logs/models/visibility.dart';
import 'package:ffxiv_battle_logs/models/zone.dart';
import 'package:enum_to_string/enum_to_string.dart';

class Report extends TimeData {
  final String code;
  final String? title;
  final Visibility? visibility;
  final Zone? zone;

  Report.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        title = json['title'],
        visibility = EnumToString.fromString(Visibility.values, json['visibility']),
        zone = Zone.fromJson(json['zone']), super.fromJson(json);
}
