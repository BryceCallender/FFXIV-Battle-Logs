import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ffxiv_battle_logs/providers/reports_model.dart';
import 'package:ffxiv_battle_logs/screens/previews_screen.dart';
import 'package:ffxiv_battle_logs/models/report.dart';
import 'package:ffxiv_battle_logs/models/visibility.dart' as ReportVisibility;

class ReportOverview extends StatelessWidget {
  final Report report;

  const ReportOverview({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                    maxWidth: 64,
                    maxHeight: 64,
                  ),
                  child: visibilityToIcon(report.visibility)),
              title:
                  Text(report.title ?? report.zone?.name ?? "No Name Given..."),
              subtitle: Text(
                DateFormat.yMMMMd().add_jm().format(
                      DateTime.fromMillisecondsSinceEpoch(report.startTime),
                    ),
              ),
              trailing: Icon(Icons.keyboard_arrow_right_rounded),
              onTap: () {
                var reportsModel = context.read<ReportsModel>();
                reportsModel.setReportCode(report.code);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviewsScreen(
                      report: report,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget visibilityToIcon(ReportVisibility.Visibility? visibility) {
    IconData iconData;
    switch (visibility) {
      case ReportVisibility.Visibility.Private:
        iconData = CupertinoIcons.eye_slash;
        break;
      case ReportVisibility.Visibility.Unlisted:
        iconData = Icons.link_rounded;
        break;
      default:
        iconData = Icons.public;
        break;
    }

    return Icon(iconData, size: 48);
  }
}
