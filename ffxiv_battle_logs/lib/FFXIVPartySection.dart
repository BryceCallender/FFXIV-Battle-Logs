import 'package:ffxiv_battle_logs/eventpage.dart';
import 'package:ffxiv_battle_logs/ffxiv_classes.dart';
import 'package:flutter/material.dart';

class FFXIVPartySection extends StatelessWidget {
  static const icon_size = 40.0;
  static const boxSeparationSize = 8.0;

  final FFXIVParty ffxivParty;
  final String reportID;
  final int start;
  final int end;

  FFXIVPartySection(this.ffxivParty, this.reportID, this.start, this.end) {
    ffxivParty.sortClassesByPriority();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: getPartyMembers(context, ffxivParty.characters.length));
  }

  List<Widget> getPartyMembers(BuildContext context, int partyCount) {
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
      Card(
        child: ListTile(
          title: Text(ffxivParty.characters[0].name),
          leading: Image.asset(ffxivParty.characters[0].playerClass.iconPath,
              width: icon_size, height: icon_size),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EventPage(ffxivParty.characters[0].name, reportID,
                      ffxivParty.characters[0].playerClass.name,
                      start, end, ffxivParty.characters[0].sourceID);
                },
              ),
            );
          },
        ),
      ),
    ];

    if (partyCount == 8) {
      builder.add(
        Card(
          child: ListTile(
            title: Text(ffxivParty.characters[1].name),
            leading: Image.asset(ffxivParty.characters[1].playerClass.iconPath,
                width: icon_size, height: icon_size),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return EventPage(ffxivParty.characters[1].name, reportID,
                        ffxivParty.characters[1].playerClass.name,
                        start, end, ffxivParty.characters[1].sourceID);
                  },
                ),
              );
            },
          ),
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

    if (partyCount == 4) {
      builder.add(Card(
        child: ListTile(
          title: Text(ffxivParty.characters[1].name),
          leading: Image.asset(ffxivParty.characters[1].playerClass.iconPath,
              width: icon_size, height: icon_size),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EventPage(ffxivParty.characters[1].name, reportID,
                      ffxivParty.characters[1].playerClass.name,
                      start, end, ffxivParty.characters[1].sourceID);
                },
              ),
            );
          },
        ),
      ),);
    } else if (partyCount == 8) {
      builder.add(Card(
        child: ListTile(
          title: Text(ffxivParty.characters[2].name),
          leading: Image.asset(ffxivParty.characters[2].playerClass.iconPath,
              width: icon_size, height: icon_size),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EventPage(ffxivParty.characters[2].name, reportID,
                      ffxivParty.characters[2].playerClass.name,
                      start, end, ffxivParty.characters[2].sourceID);
                },
              ),
            );
          },
        ),
      ),);

      builder.add(
        Card(
          child: ListTile(
            title: Text(ffxivParty.characters[3].name),
            leading: Image.asset(ffxivParty.characters[3].playerClass.iconPath,
                width: icon_size, height: icon_size),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return EventPage(ffxivParty.characters[4].name, reportID,
                        ffxivParty.characters[4].playerClass.name,
                        start, end, ffxivParty.characters[4].sourceID);
                  },
                ),
              );
            },
          ),
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

    if (partyCount == 4) {
      builder.add(Card(
        child: ListTile(
          title: Text(ffxivParty.characters[2].name),
          leading: Image.asset(ffxivParty.characters[2].playerClass.iconPath,
              width: icon_size, height: icon_size),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EventPage(ffxivParty.characters[2].name, reportID,
                      ffxivParty.characters[2].playerClass.name,
                      start, end, ffxivParty.characters[2].sourceID);
                },
              ),
            );
          },
        ),
      ),);

      builder.add(
        Card(
          child: ListTile(
            title: Text(ffxivParty.characters[3].name),
            leading: Image.asset(ffxivParty.characters[3].playerClass.iconPath,
                width: icon_size, height: icon_size),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return EventPage(ffxivParty.characters[3].name, reportID,
                        ffxivParty.characters[3].playerClass.name,
                        start, end, ffxivParty.characters[3].sourceID);
                  },
                ),
              );
            },
          ),
        ),
      );
    } else if (partyCount == 8) {
      builder.add(Card(
        child: ListTile(
          title: Text(ffxivParty.characters[4].name),
          leading: Image.asset(ffxivParty.characters[4].playerClass.iconPath,
              width: icon_size, height: icon_size),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EventPage(ffxivParty.characters[4].name, reportID,
                      ffxivParty.characters[4].playerClass.name,
                      start, end, ffxivParty.characters[4].sourceID);
                },
              ),
            );
          },
        ),
      ),);
      builder.add(Card(
        child: ListTile(
          title: Text(ffxivParty.characters[5].name),
          leading: Image.asset(ffxivParty.characters[5].playerClass.iconPath,
              width: icon_size, height: icon_size),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EventPage(ffxivParty.characters[5].name, reportID,
                      ffxivParty.characters[5].playerClass.name,
                      start, end, ffxivParty.characters[5].sourceID);
                },
              ),
            );
          },
        ),
      ),);
      builder.add(Card(
        child: ListTile(
          title: Text(ffxivParty.characters[6].name),
          leading: Image.asset(ffxivParty.characters[6].playerClass.iconPath,
              width: icon_size, height: icon_size),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EventPage(ffxivParty.characters[6].name, reportID,
                      ffxivParty.characters[6].playerClass.name,
                      start, end, ffxivParty.characters[6].sourceID);
                },
              ),
            );
          },
        ),
      ),);

      builder.add(
        Card(
          child: ListTile(
            title: Text(ffxivParty.characters[7].name),
            leading: Image.asset(ffxivParty.characters[7].playerClass.iconPath,
                width: icon_size, height: icon_size),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return EventPage(ffxivParty.characters[7].name, reportID,
                        ffxivParty.characters[7].playerClass.name,
                        start, end, ffxivParty.characters[7].sourceID);
                  },
                ),
              );
            },
          ),
        ),
      );
    }

    return builder;
  }
}
