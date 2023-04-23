import 'package:ffxiv_battle_logs/components/ability_table.dart';
import 'package:ffxiv_battle_logs/components/death_table.dart';
import 'package:ffxiv_battle_logs/components/header.dart';
import 'package:ffxiv_battle_logs/styles.dart';
import 'package:flutter/material.dart';
import 'package:ffxiv_battle_logs/components/character_data_table.dart';
import 'package:ffxiv_battle_logs/models/fight_table_overall_data.dart';

class TableSection extends StatelessWidget {
  final FightTableOverallData tableData;
  const TableSection({super.key, required this.tableData});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Header(title: "Damage Done"),
        CharacterDataTable(
          characterData: tableData.damageDone,
          measure: "DPS",
          totalTime: tableData.totalTime,
        ),
        Header(title: "Healing Done"),
        CharacterDataTable(
          characterData: tableData.healingDone,
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
