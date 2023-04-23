import 'package:ffxiv_battle_logs/models/rankings.dart';
import 'package:ffxiv_battle_logs/styles.dart';
import 'package:flutter/material.dart';
import 'package:ffxiv_battle_logs/components/class_card.dart';
import 'package:ffxiv_battle_logs/models/player_details.dart';

class PartySection extends StatelessWidget {
  final PlayerDetails players;
  final Rankings rankings;
  const PartySection({super.key, required this.players, required this.rankings});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Party Composition",
            style: TextStyles.h2,
          ),
        ),
        for (var tank in players.tanks)
          ClassCard(
            character: tank,
            rank: rankings.characterRankings?[tank.name],
          ),
        for (var healer in players.healers)
          ClassCard(
            character: healer,
            rank: rankings.characterRankings?[healer.name],
          ),
        for (var dps in players.dps)
          ClassCard(
            character: dps,
            rank: rankings.characterRankings?[dps.name],
          )
      ],
    );
  }
}
