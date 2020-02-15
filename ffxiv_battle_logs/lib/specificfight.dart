import 'package:ffxiv_battle_logs/FFXIVPartySection.dart';
import 'package:ffxiv_battle_logs/fflog_classes.dart';
import 'package:ffxiv_battle_logs/ffxiv_classes.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';

class SpecificFightReport extends StatelessWidget {
  final FFLogFightData ffLogFightData;
  final List<Friendly> partyMembers;

  SpecificFightReport({Key key, @required this.ffLogFightData, @required this.partyMembers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fight #" + ffLogFightData.id.toString()),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            getPartyWidget(),

          ],
        ),
      ),
    );
  }

  Widget getPartyWidget() {
    List<FFXIVCharacter> partyMembersInvolved = new List();

    partyMembers.forEach((friendly) {
      friendly.fightIds.forEach((fightID) {
        if(fightID.id == ffLogFightData.id) {
          partyMembersInvolved.add(friendly.character);
        }
      });
    });

    FFXIVParty ffxivParty = new FFXIVParty(partyMembersInvolved);

    return FFXIVPartySection(ffxivParty);
  }
}