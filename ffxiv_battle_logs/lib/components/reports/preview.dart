import 'package:cached_network_image/cached_network_image.dart';
import 'package:ffxiv_battle_logs/helpers/color_helper.dart';
import 'package:ffxiv_battle_logs/helpers/map_helper.dart';
import 'package:ffxiv_battle_logs/models/fight.dart';
import 'package:ffxiv_battle_logs/providers/reports_model.dart';
import 'package:ffxiv_battle_logs/screens/breakdown_screen.dart';
import 'package:ffxiv_battle_logs/styles.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:ffxiv_battle_logs/extensions/duration_extensions.dart';

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
              leading: CachedNetworkImage(
                imageUrl: MapHelper.mapToImageUrl(fight.map?.id ?? 0),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error_outline_outlined),
              ),
              title: RichText(
                text: TextSpan(
                  text: fight.name,
                  children: [
                    TextSpan(
                        text: " (${fight.duration.toHHMMSS()})",
                        style: TextStyles.caption)
                  ],
                ),
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 4,
                  ),
                  if (!(fight.kill ?? false))
                    LinearPercentIndicator(
                      lineHeight: 20.0,
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
                  else
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          "Kill",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: FontSizes.s14,
                          ),
                        )
                      ],
                    )
                ],
              ),
              trailing: Icon(Icons.keyboard_arrow_right_rounded),
              onTap: () {
                var reportsModel = context.read<ReportsModel>();
                reportsModel.setFightIds([fight.id]);
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
