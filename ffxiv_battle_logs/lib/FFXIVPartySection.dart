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
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: getPartyMembers(ffxivParty.characters.length));
  }

  List<Widget> getPartyMembers(int partyCount) {
    var builder = [
      Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Center(
          child: Text(
            "Party Composition",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Container(
        constraints: BoxConstraints.expand(height: 100.0),
        decoration: BoxDecoration(color: Colors.transparent),
        child: Image.asset(
          "assets/images/class_icons/tank.png",
          fit: BoxFit.contain,
        ),
      ),
      Text("Tanks"),
      GestureDetector(
        child: Row(
          children: [
            Image.asset(ffxivParty.characters[0].playerClass.iconPath,
                width: icon_size, height: icon_size),
            SizedBox(width: boxSeparationSize),
            Text(ffxivParty.characters[0].name),
          ],
        ),
      ),
    ];

    if (partyCount == 8) {
      builder.add(
        Row(
          children: [
            Image.asset(ffxivParty.characters[1].playerClass.iconPath,
                width: icon_size, height: icon_size),
            SizedBox(width: boxSeparationSize),
            Text(ffxivParty.characters[1].name)
          ],
        ),
      );
    }

    builder.add(
      Divider(
        thickness: 3.0,
      ),
    );

    builder.add(
      Container(
        constraints: BoxConstraints.expand(height: 100.0),
        decoration: BoxDecoration(color: Colors.transparent),
        child: Image.asset(
          "assets/images/class_icons/healer.png",
          fit: BoxFit.contain,
        ),
      ),
    );

    builder.add(Text("Healers"));

    if (partyCount == 4) {
      builder.add(Row(
        children: [
          Image.asset(ffxivParty.characters[1].playerClass.iconPath,
              width: icon_size, height: icon_size),
          SizedBox(width: boxSeparationSize),
          Text(ffxivParty.characters[1].name)
        ],
      ));
    } else if (partyCount == 8) {
      builder.add(Row(
        children: [
          Image.asset(ffxivParty.characters[2].playerClass.iconPath,
              width: icon_size, height: icon_size),
          SizedBox(width: boxSeparationSize),
          Text(ffxivParty.characters[2].name)
        ],
      ));

      builder.add(
        Row(
          children: [
            Image.asset(ffxivParty.characters[3].playerClass.iconPath,
                width: icon_size, height: icon_size),
            SizedBox(width: boxSeparationSize),
            Text(ffxivParty.characters[3].name)
          ],
        ),
      );
    }

    builder.add(
      Divider(
        thickness: 3.0,
      ),
    );

    builder.add(Container(
      constraints: BoxConstraints.expand(height: 100.0),
      decoration: BoxDecoration(color: Colors.transparent),
      child: Image.asset(
        "assets/images/class_icons/dps.png",
        fit: BoxFit.contain,
      ),
    ));

    builder.add(Text("DPS"));

    if (partyCount == 4) {
      builder.add(Row(
        children: [
          Image.asset(ffxivParty.characters[2].playerClass.iconPath,
              width: icon_size, height: icon_size),
          SizedBox(width: boxSeparationSize),
          Text(ffxivParty.characters[2].name)
        ],
      ));

      builder.add(
        Row(
          children: [
            Image.asset(ffxivParty.characters[3].playerClass.iconPath,
                width: icon_size, height: icon_size),
            SizedBox(width: boxSeparationSize),
            Text(ffxivParty.characters[3].name)
          ],
        ),
      );
    } else if (partyCount == 8) {
      builder.add(Row(
        children: [
          Image.asset(ffxivParty.characters[4].playerClass.iconPath,
              width: icon_size, height: icon_size),
          SizedBox(width: boxSeparationSize),
          Text(ffxivParty.characters[4].name)
        ],
      ));
      builder.add(Row(
        children: [
          Image.asset(ffxivParty.characters[5].playerClass.iconPath,
              width: icon_size, height: icon_size),
          SizedBox(width: boxSeparationSize),
          Text(ffxivParty.characters[5].name)
        ],
      ));
      builder.add(Row(
        children: [
          Image.asset(ffxivParty.characters[6].playerClass.iconPath,
              width: icon_size, height: icon_size),
          SizedBox(width: boxSeparationSize),
          Text(ffxivParty.characters[6].name)
        ],
      ));

      builder.add(
        Row(
          children: [
            Image.asset(ffxivParty.characters[7].playerClass.iconPath,
                width: icon_size, height: icon_size),
            SizedBox(width: boxSeparationSize),
            Text(ffxivParty.characters[7].name)
          ],
        ),
      );
    }

    return builder;
  }
}
