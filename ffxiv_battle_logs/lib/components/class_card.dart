import 'package:ffxiv_battle_logs/models/character.dart';
import 'package:ffxiv_battle_logs/models/role.dart';
import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {
  final Character character;
  static const icon_size = 40.0;

  const ClassCard({super.key, required this.character});

  Color roleToColor() {
    switch (character.role) {
      case Role.Tank:
        return Colors.blueAccent.withAlpha(200);
      case Role.Healer:
        return Colors.green.withAlpha(200);
      default:
        return Colors.red.withAlpha(200);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   border: BoxBorder(
      //
      //   ),
      //   boxShadow: [
      //     BoxShadow(
      //       color: roleToColor(),
      //       blurRadius: 10.0,
      //       spreadRadius: 0.0,
      //     ),
      //   ],
      // ),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.0,
          color: roleToColor(),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Card(
        child: ListTile(
          title: Text(character.name),
          leading: Image.asset(
            "assets/images/class_icons/${character.type.toLowerCase()}.png",
            width: icon_size,
            height: icon_size,
            errorBuilder: (context, exception, trace) => Image.asset(
              "assets/images/class_icons/none.png",
              width: icon_size,
              height: icon_size,
            ),
          ),
          trailing: Icon(Icons.keyboard_arrow_right_rounded),
          onTap: () {},
        ),
      ),
    );
  }
}
