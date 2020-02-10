import 'package:ffxiv_battle_logs/ffxiv_classes.dart';
import 'package:flutter/material.dart';

class FFXIVPartySection extends StatelessWidget {
  static const icon_size = 40.0;
  static const boxSeparationSize = 8.0;

  final FFXIVParty ffxivParty;

  FFXIVPartySection(this.ffxivParty) {
    ffxivParty.sortClassesByPriority();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Center(
          child: Text("Party Composition", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
      ),
      Text("Tanks"),
      Row(children: [
        Image.asset(ffxivParty.characters[0].playerClass.iconPath,
            width: icon_size, height: icon_size),
        SizedBox(width: boxSeparationSize),
        Text(ffxivParty.characters[0].name)
      ]),
      Row(children: [
        Image.asset(ffxivParty.characters[1].playerClass.iconPath,
            width: icon_size, height: icon_size),
        SizedBox(width: boxSeparationSize),
        Text(ffxivParty.characters[1].name)
      ]),
      Text("Healers"),
      Row(children: [
        Image.asset(ffxivParty.characters[2].playerClass.iconPath,
            width: icon_size, height: icon_size),
        SizedBox(width: boxSeparationSize),
        Text(ffxivParty.characters[2].name)
      ]),
      Row(children: [
        Image.asset(ffxivParty.characters[3].playerClass.iconPath,
            width: icon_size, height: icon_size),
        SizedBox(width: boxSeparationSize),
        Text(ffxivParty.characters[3].name)
      ]),
      Text("DPS"),
      Row(children: [
        Image.asset(ffxivParty.characters[4].playerClass.iconPath,
            width: icon_size, height: icon_size),
        SizedBox(width: boxSeparationSize),
        Text(ffxivParty.characters[4].name)
      ]),
      Row(children: [
        Image.asset(ffxivParty.characters[5].playerClass.iconPath,
            width: icon_size, height: icon_size),
        SizedBox(width: boxSeparationSize),
        Text(ffxivParty.characters[5].name)
      ]),
      Row(children: [
        Image.asset(ffxivParty.characters[6].playerClass.iconPath,
            width: icon_size, height: icon_size),
        SizedBox(width: boxSeparationSize),
        Text(ffxivParty.characters[6].name)
      ]),
      Row(children: [
        Image.asset(ffxivParty.characters[7].playerClass.iconPath,
            width: icon_size, height: icon_size),
        SizedBox(width: boxSeparationSize),
        Text(ffxivParty.characters[7].name)
      ]),
    ]);
  }
}
