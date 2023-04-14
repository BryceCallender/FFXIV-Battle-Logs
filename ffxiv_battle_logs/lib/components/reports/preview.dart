import 'package:ffxiv_battle_logs/helpers/color_helper.dart';
import 'package:ffxiv_battle_logs/models/fight.dart';
import 'package:ffxiv_battle_logs/screens/breakdown_screen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ReportPreview extends StatelessWidget {
  final String code;
  final Fight fight;
  const ReportPreview({Key? key, required this.fight, required this.code})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: (fight.kill ?? false) ? Colors.green : Colors.red,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: ListTile(
              dense: true,
              leading: Image.asset("assets/images/banners/112000/Sophia.png"),
              title: Text(fight.name),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fight.duration.toString().split('.').first.padLeft(8, "0"),
                  ),
                  if (fight.bossPercentage != null)
                    LinearPercentIndicator(
                      lineHeight: 16.0,
                      animation: true,
                      barRadius: Radius.circular(5.0),
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.grey,
                      percent: fight.bossPercentage! / 100,
                      progressColor:
                          ColorHelper.getProgressColor(fight.bossPercentage!),
                      center: Text(
                        "${fight.bossPercentage}% HP",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    )
                ],
              ),
              trailing: Icon(Icons.keyboard_arrow_right_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BreakdownScreen(
                      code: code,
                      fightId: fight.id,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
