import 'package:flutter/material.dart';
import 'package:ffxiv_battle_logs/models/role.dart';

const tanks = ['paladin', 'warrior', 'darkknight', 'gunbreaker'];
const healers = ['whitemage', 'scholar', 'astrologian', 'sage'];
const meleeDps = ['monk', 'dragoon', 'ninja', 'samurai', 'reaper'];
const physRanged = ['bard', 'machinist', 'dancer'];
const magical = ['blackmage', 'summoner', 'redmage', 'bluemage'];

class Character {
  final int id;
  final int guid;
  final String name;
  final String type;
  final String? server;
  final int? total;
  final int? rank;
  final Role role;

  Color get roleColor {
    switch (role) {
      case Role.Tank:
        return Colors.blueAccent.withAlpha(200);
      case Role.Healer:
        return Colors.green.withAlpha(200);
      default:
        return Colors.red.withAlpha(200);
    }
  }

  Color get roleTypeColor {
    final classType = type.toLowerCase();
    if (tanks.contains(classType)) {
      return Colors.blue;
    } else if (healers.contains(classType)) {
      return Colors.green;
    } else if (meleeDps.contains(classType)) {
      return Colors.red;
    } else if (physRanged.contains(classType)) {
      return Colors.yellow;
    } else if (magical.contains(classType)) {
      return Colors.purple;
    }

    return Colors.white;
  }

  Character.fromJson(Map<String, dynamic> json, {Role? role = Role.Unknown})
      : id = json['id'],
        guid = json['guid'],
        name = json['name'],
        type = json['type'],
        server = json['server'],
        total = json['total'],
        rank = null,
        role = role ?? Role.Unknown;
}