import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ffxiv_battle_logs/providers/reports_model.dart';
import 'package:ffxiv_battle_logs/screens/user_detail_screen.dart';
import 'package:ffxiv_battle_logs/models/character.dart';

class ClassCard extends StatelessWidget {
  final Character character;
  final int? rank;
  static const icon_size = 40.0;

  const ClassCard({super.key, required this.character, this.rank});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: character.roleColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Row(
          children: [
            Text(character.name),
            if (rank != null) ...[
              const SizedBox(
                width: 8,
              ),
              Text(
                rank.toString(),
                style: TextStyle(color: rankingToColor(rank!)),
              ),
            ]
          ],
        ),
        leading: Hero(
          tag: '${character.type}',
          child: Image.asset(
            "assets/images/class_icons/${character.type.toLowerCase()}.png",
            width: icon_size,
            height: icon_size,
          ),
        ),
        trailing: Icon(Icons.keyboard_arrow_right_rounded),
        onTap: () {
          var reportsModel = context.read<ReportsModel>();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailScreen(
                code: reportsModel.code,
                fightIds: reportsModel.fightIds,
                character: character,
              ),
            ),
          );
        },
      ),
    );
  }

  Color rankingToColor(int rank) {
    if (rank == 100) {
      return Color(0xFFE5CC80);
    } else if (rank < 25) {
      return Color(0xFF666666);
    } else if (rank < 50) {
      return Color(0xFF1EFF00);
    } else if (rank < 75) {
      return Color(0xFF0070FF);
    } else if (rank < 90) {
      return Color(0xFFA335EE);
    } else if (rank < 99) {
      return Color(0xFFFF8000);
    } else {
      return Color(0xFFE268A8);
    }
  }
}
