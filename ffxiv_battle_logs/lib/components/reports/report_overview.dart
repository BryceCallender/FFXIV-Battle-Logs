import 'package:ffxiv_battle_logs/screens/previews_screen.dart';
import 'package:flutter/material.dart';
import 'package:ffxiv_battle_logs/models/report.dart';
import 'package:intl/intl.dart';

class ReportOverview extends StatelessWidget {
  final Report data;

  const ReportOverview({Key? key, required this.data}) : super(key: key);

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
                child: Image.asset("assets/images/map_icons/trial.png",
                    fit: BoxFit.cover),
              ),
              title: Text(data.title ?? data.zone?.name ?? "No Name Given..."),
              subtitle: Text(
                DateFormat.yMMMMd().add_jm().format(
                      DateTime.fromMillisecondsSinceEpoch(data.startTime),
                    ),
              ),
              trailing: Icon(Icons.keyboard_arrow_right_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviewsScreen(
                      report: data,
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
}
