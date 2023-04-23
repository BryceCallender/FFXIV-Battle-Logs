import 'package:ffxiv_battle_logs/components/header.dart';
import 'package:flutter/material.dart';
import 'package:ffxiv_battle_logs/components/ability_table.dart';
import 'package:ffxiv_battle_logs/components/death_table.dart';
import 'package:ffxiv_battle_logs/models/fight_table_user_data.dart';
import 'package:ffxiv_battle_logs/styles.dart';

class UserDetailTableSection extends StatelessWidget {
  final FightTableUserData tableData;
  const UserDetailTableSection({super.key, required this.tableData});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Header(title: "Damage Done"),
        AbilityTable(
          abilities: tableData.damageDone,
          measure: "DPS",
          totalTime: tableData.totalTime,
        ),
        Header(title: "Healing Done"),
        AbilityTable(
          abilities: tableData.healingDone,
          measure: "HPS",
          totalTime: tableData.totalTime,
        ),
        Header(title: "Damage Taken"),
        AbilityTable(
          abilities: tableData.damageTaken,
          totalTime: tableData.totalTime,
          measure: "DTPS",
        ),
        Header(title: "Deaths"),
        DeathTable(
          deathEvents: tableData.deathEvents,
        ),
      ],
    );
  }
}
