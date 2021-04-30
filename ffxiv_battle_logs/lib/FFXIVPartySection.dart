import 'package:ffxiv_battle_logs/eventpage.dart';
import 'package:ffxiv_battle_logs/ffxiv_classes.dart';
import 'package:ffxiv_battle_logs/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

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
    var mediaQuery = MediaQuery.of(context);

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
        padding: EdgeInsets.only(bottom: 8.0),
        constraints: BoxConstraints.expand(height: 100.0),
        decoration: BoxDecoration(color: Colors.transparent),
        child: Image.asset(
          "assets/images/class_icons/Tank_Icon_1.png",
          fit: BoxFit.contain,
        ),
      ),
      Container(
        //padding: const EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withAlpha(200),
                blurRadius: 10.0,
                spreadRadius: 0.0,
              ),
            ],
        ),
        child: Card(
          color: mediaQuery.platformBrightness == Brightness.dark
              ? ThemeData.dark().cardColor
              : ThemeData.light().cardColor,
          child: ListTile(
            title: Text(ffxivParty.characters[0].name,
                style: Styles.getTextStyleFromBrightness(context)),
            leading: Image.asset(ffxivParty.characters[0].playerClass.iconPath,
                width: icon_size, height: icon_size),
            trailing: isIOS
                ? Icon(CupertinoIcons.forward,
                color: Styles.getColorFromBrightness(context))
                : Icon(Icons.keyboard_arrow_right,
                color: Styles.getColorFromBrightness(context)),
            onTap: () {
              if (isIOS) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) {
                      return EventPage(
                          ffxivParty.characters[0],
                          reportID,
                          start,
                          end
                      );
                    },
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return EventPage(
                          ffxivParty.characters[0],
                          reportID,
                          start,
                          end
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    ];

    if (partyCount == 8) {
      builder.add(
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withAlpha(200),
                blurRadius: 10.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Card(
            color: mediaQuery.platformBrightness == Brightness.dark
                ? ThemeData.dark().cardColor
                : ThemeData.light().cardColor,
            child: ListTile(
              title: Text(ffxivParty.characters[1].name,
                  style: Styles.getTextStyleFromBrightness(context)),
              leading: Image.asset(ffxivParty.characters[1].playerClass.iconPath,
                  width: icon_size, height: icon_size),
              trailing: isIOS
                  ? Icon(CupertinoIcons.forward,
                      color: Styles.getColorFromBrightness(context))
                  : Icon(Icons.keyboard_arrow_right,
                      color: Styles.getColorFromBrightness(context)),
              onTap: () {
                if (isIOS) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return EventPage(
                            ffxivParty.characters[1],
                            reportID,
                            start,
                            end
                        );
                      },
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EventPage(
                            ffxivParty.characters[1],
                            reportID,
                            start,
                            end
                        );
                      },
                    ),
                  );
                }
              },
            ),
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
        padding: EdgeInsets.only(bottom: 8.0),
        constraints: BoxConstraints.expand(height: 100.0),
        decoration: BoxDecoration(color: Colors.transparent),
        child: Image.asset(
          "assets/images/class_icons/Healer_Icon_1.png",
          fit: BoxFit.contain,
        ),
      ),
    );

    if (partyCount == 4) {
      builder.add(
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.green.withAlpha(200),
                blurRadius: 10.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Card(
            color: mediaQuery.platformBrightness == Brightness.dark
                ? ThemeData.dark().cardColor
                : ThemeData.light().cardColor,
            child: ListTile(
              title: Text(ffxivParty.characters[1].name,
                  style: Styles.getTextStyleFromBrightness(context)),
              leading: Image.asset(ffxivParty.characters[1].playerClass.iconPath,
                  width: icon_size, height: icon_size),
              trailing: isIOS
                  ? Icon(CupertinoIcons.forward,
                  color: Styles.getColorFromBrightness(context))
                  : Icon(Icons.keyboard_arrow_right,
                  color: Styles.getColorFromBrightness(context)),
              onTap: () {
                if (isIOS) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return EventPage(
                            ffxivParty.characters[1],
                            reportID,
                            start,
                            end
                        );
                      },
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EventPage(
                            ffxivParty.characters[1],
                            reportID,
                            start,
                            end
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );
    } else if (partyCount == 8) {
      builder.add(
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.green.withAlpha(200),
                blurRadius: 10.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Card(
            color: mediaQuery.platformBrightness == Brightness.dark
                ? ThemeData.dark().cardColor
                : ThemeData.light().cardColor,
            child: ListTile(
              title: Text(ffxivParty.characters[2].name,
                  style: Styles.getTextStyleFromBrightness(context)),
              leading: Image.asset(ffxivParty.characters[2].playerClass.iconPath,
                  width: icon_size, height: icon_size),
              trailing: isIOS
                  ? Icon(CupertinoIcons.forward,
                  color: Styles.getColorFromBrightness(context))
                  : Icon(Icons.keyboard_arrow_right,
                  color: Styles.getColorFromBrightness(context)),
              onTap: () {
                if (isIOS) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return EventPage(
                            ffxivParty.characters[2],
                            reportID,
                            start,
                            end
                        );
                      },
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EventPage(
                            ffxivParty.characters[2],
                            reportID,
                            start,
                            end
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );

      builder.add(
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.green.withAlpha(200),
                blurRadius: 10.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Card(
            color: mediaQuery.platformBrightness == Brightness.dark
                ? ThemeData.dark().cardColor
                : ThemeData.light().cardColor,
            child: ListTile(
              title: Text(ffxivParty.characters[3].name,
                  style: Styles.getTextStyleFromBrightness(context)),
              leading: Image.asset(ffxivParty.characters[3].playerClass.iconPath,
                  width: icon_size, height: icon_size),
              trailing: isIOS
                  ? Icon(CupertinoIcons.forward,
                      color: Styles.getColorFromBrightness(context))
                  : Icon(Icons.keyboard_arrow_right,
                      color: Styles.getColorFromBrightness(context)),
              onTap: () {
                if (isIOS) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return EventPage(
                            ffxivParty.characters[3],
                            reportID,
                            start,
                            end
                        );
                      },
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EventPage(
                            ffxivParty.characters[3],
                            reportID,
                            start,
                            end
                        );
                      },
                    ),
                  );
                }
              },
            ),
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
      padding: EdgeInsets.only(bottom: 8.0),
      constraints: BoxConstraints.expand(height: 100.0),
      decoration: BoxDecoration(color: Colors.transparent),
      child: Image.asset(
        "assets/images/class_icons/Dps_Icon_1.png",
        fit: BoxFit.contain,
      ),
    ));

    if (partyCount == 4) {
      builder.add(
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.red.withAlpha(200),
                blurRadius: 10.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Card(
            color: mediaQuery.platformBrightness == Brightness.dark
                ? ThemeData.dark().cardColor
                : ThemeData.light().cardColor,
            child: ListTile(
              title: Text(ffxivParty.characters[2].name,
                  style: Styles.getTextStyleFromBrightness(context)),
              leading: Image.asset(ffxivParty.characters[2].playerClass.iconPath,
                  width: icon_size, height: icon_size),
              trailing: isIOS
                  ? Icon(CupertinoIcons.forward,
                  color: Styles.getColorFromBrightness(context))
                  : Icon(Icons.keyboard_arrow_right,
                  color: Styles.getColorFromBrightness(context)),
              onTap: () {
                if (isIOS) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return EventPage(
                            ffxivParty.characters[2],
                            reportID,
                            start,
                            end
                        );
                      },
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EventPage(
                            ffxivParty.characters[2],
                            reportID,
                            start,
                            end
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );

      builder.add(
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.red.withAlpha(200),
                blurRadius: 10.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Card(
            color: mediaQuery.platformBrightness == Brightness.dark
                ? ThemeData.dark().cardColor
                : ThemeData.light().cardColor,
            child: ListTile(
              title: Text(ffxivParty.characters[3].name,
                  style: Styles.getTextStyleFromBrightness(context)),
              leading: Image.asset(ffxivParty.characters[3].playerClass.iconPath,
                  width: icon_size, height: icon_size),
              trailing: isIOS
                  ? Icon(CupertinoIcons.forward,
                      color: Styles.getColorFromBrightness(context))
                  : Icon(Icons.keyboard_arrow_right,
                      color: Styles.getColorFromBrightness(context)),
              onTap: () {
                if (isIOS) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return EventPage(
                            ffxivParty.characters[3],
                            reportID,
                            start,
                            end
                        );
                      },
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EventPage(
                            ffxivParty.characters[3],
                            reportID,
                            start,
                            end
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );
    } else if (partyCount == 8) {
      builder.add(
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.red.withAlpha(200),
                blurRadius: 10.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Card(
            color: mediaQuery.platformBrightness == Brightness.dark
                ? ThemeData.dark().cardColor
                : ThemeData.light().cardColor,
            child: ListTile(
              title: Text(ffxivParty.characters[4].name,
                  style: Styles.getTextStyleFromBrightness(context)),
              leading: Image.asset(ffxivParty.characters[4].playerClass.iconPath,
                  width: icon_size, height: icon_size),
              trailing: isIOS
                  ? Icon(CupertinoIcons.forward,
                  color: Styles.getColorFromBrightness(context))
                  : Icon(Icons.keyboard_arrow_right,
                  color: Styles.getColorFromBrightness(context)),
              onTap: () {
                if (isIOS) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return EventPage(
                            ffxivParty.characters[4],
                            reportID,
                            start,
                            end
                        );
                      },
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EventPage(
                            ffxivParty.characters[4],
                            reportID,
                            start,
                            end
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );
      builder.add(
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.red.withAlpha(200),
                blurRadius: 10.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Card(
            color: mediaQuery.platformBrightness == Brightness.dark
                ? ThemeData.dark().cardColor
                : ThemeData.light().cardColor,
            child: ListTile(
              title: Text(ffxivParty.characters[5].name,
                  style: Styles.getTextStyleFromBrightness(context)),
              leading: Image.asset(ffxivParty.characters[5].playerClass.iconPath,
                  width: icon_size, height: icon_size),
              trailing: isIOS
                  ? Icon(CupertinoIcons.forward,
                  color: Styles.getColorFromBrightness(context))
                  : Icon(Icons.keyboard_arrow_right,
                  color: Styles.getColorFromBrightness(context)),
              onTap: () {
                if (isIOS) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return EventPage(
                            ffxivParty.characters[5],
                            reportID,
                            start,
                            end
                        );
                      },
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EventPage(
                            ffxivParty.characters[5],
                            reportID,
                            start,
                            end
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );
      builder.add(
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.red.withAlpha(200),
                blurRadius: 10.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Card(
            color: mediaQuery.platformBrightness == Brightness.dark
                ? ThemeData.dark().cardColor
                : ThemeData.light().cardColor,
            child: ListTile(
              title: Text(ffxivParty.characters[6].name,
                  style: Styles.getTextStyleFromBrightness(context)),
              leading: Image.asset(ffxivParty.characters[6].playerClass.iconPath,
                  width: icon_size, height: icon_size),
              trailing: isIOS
                  ? Icon(CupertinoIcons.forward,
                  color: Styles.getColorFromBrightness(context))
                  : Icon(Icons.keyboard_arrow_right,
                  color: Styles.getColorFromBrightness(context)),
              onTap: () {
                if (isIOS) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return EventPage(
                            ffxivParty.characters[6],
                            reportID,
                            start,
                            end
                        );
                      },
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EventPage(
                            ffxivParty.characters[6],
                            reportID,
                            start,
                            end
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );

      builder.add(
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.red.withAlpha(200),
                blurRadius: 10.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Card(
            color: mediaQuery.platformBrightness == Brightness.dark
                ? ThemeData.dark().cardColor
                : ThemeData.light().cardColor,
            child: ListTile(
              title: Text(ffxivParty.characters[7].name,
                  style: Styles.getTextStyleFromBrightness(context)),
              leading: Image.asset(ffxivParty.characters[7].playerClass.iconPath,
                  width: icon_size, height: icon_size),
              trailing: isIOS
                  ? Icon(CupertinoIcons.forward,
                      color: Styles.getColorFromBrightness(context))
                  : Icon(Icons.keyboard_arrow_right,
                      color: Styles.getColorFromBrightness(context)),
              onTap: () {
                if (isIOS) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return EventPage(
                            ffxivParty.characters[7],
                            reportID,
                            start,
                            end
                        );
                      },
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EventPage(
                            ffxivParty.characters[7],
                            reportID,
                            start,
                            end
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );
    }

    return builder;
  }
}
