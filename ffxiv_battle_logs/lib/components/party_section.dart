import 'package:flutter/material.dart';
import 'package:ffxiv_battle_logs/components/class_card.dart';
import 'package:ffxiv_battle_logs/models/player_details.dart';

class PartySection extends StatelessWidget {
  final PlayerDetails players;

  const PartySection({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Party Composition",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        for (var tank in players.tanks) ClassCard(character: tank),
        for (var healer in players.healers) ClassCard(character: healer),
        for (var dps in players.dps) ClassCard(character: dps)
      ],
    );
  }
}
