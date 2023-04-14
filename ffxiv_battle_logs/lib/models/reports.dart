import 'package:ffxiv_battle_logs/models/report.dart';

class Reports {
  final int currentPage;
  final bool hasMorePages;
  final List<Report> reports;

  Reports.fromJson(Map<String, dynamic> json)
      : currentPage = json['current_page'],
        hasMorePages = json['has_more_pages'],
        reports = (json['data'] as List).map((x) => Report.fromJson(x)).toList();
}