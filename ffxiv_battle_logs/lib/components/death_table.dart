import 'package:ffxiv_battle_logs/models/character.dart';
import 'package:flutter/material.dart';
import 'package:ffxiv_battle_logs/models/death_event.dart';

class DeathTable extends StatelessWidget {
  final List<DeathEvent> deathEvents;
  const DeathTable({super.key, required this.deathEvents});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text("Name"),
          ),
          DataColumn(
            label: Text("Killing Blow"),
          ),
          DataColumn(
            label: Text("Time"),
          ),
        ],
        rows: [for (var de in deathEvents) buildTableRow(de)],
      ),
    );
  }

  DataRow buildTableRow(DeathEvent deathEvent) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              Image.asset(
                "assets/images/class_icons/${deathEvent.character.type.toLowerCase()}.png",
                width: 32,
                height: 32,
              ),
              const SizedBox(
                width: 4.0,
              ),
              Text(deathEvent.character.name)
            ],
          ),
        ),
        DataCell(Text(deathEvent.ability?.name ?? "")),
        DataCell(Text(Duration(milliseconds: deathEvent.deathTime)
            .toString()
            .substring(2, 7)))
      ],
    );
  }
}
