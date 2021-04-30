import 'package:ffxiv_battle_logs/searchresults.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tuple/tuple.dart';

import 'fflog_classes.dart';
import 'package:flutter/foundation.dart' as foundation;

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class SearchUsers extends StatefulWidget {
  SearchUsers({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchUserStats();
}

class _SearchUserStats extends State<SearchUsers> {
  String name = "";
  String world = "Adamantoise";
  String server = "NA";

  final nameController = TextEditingController();
  final worldController = TextEditingController(text: "World");
  final serverController = TextEditingController(text: "NA");
  final zoneController = TextEditingController(text: "Zone");

  var worldScrollController = FixedExtentScrollController();
  var serverScrollController = FixedExtentScrollController();
  var zoneScrollController = FixedExtentScrollController(initialItem: 33);

  Tuple2<String, int> zoneID = Tuple2<String, int>("Eden's Verse", 33);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text("Search for Parses"),
        backgroundColor: CupertinoColors.activeBlue,
        ios: (_) => CupertinoNavigationBarData(
          heroTag: "searchUsers",
          transitionBetweenRoutes: false,
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PlatformTextField(
                controller: nameController,
                ios: (_) => CupertinoTextFieldData(
                    keyboardType: TextInputType.text,
                    prefix: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(CupertinoIcons.search),
                    ),
                    placeholder: "Character name"),
                android: (_) => MaterialTextFieldData(
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Character name",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    )),
              ),
            ),
            ...platformPickers(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PlatformButton(
                child: Text("Submit"),
                ios: (_) => CupertinoButtonData(
                  color: CupertinoColors.activeBlue,
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => SearchResults(
                            nameController.text, world, server,
                            zoneNumber: zoneID.item2),
                      ),
                    );
                  },
                ),
                android: (_) => MaterialRaisedButtonData(
                  color: Colors.blue,
                  splashColor: Colors.lightBlue,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchResults(
                              nameController.text, world, server,
                              zoneNumber: zoneID.item2)),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> platformPickers() {
    if (isIOS) {
      return [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CupertinoTextField(
            readOnly: true,
            controller: worldController,
            placeholder: "World",
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 200,
                    child: CupertinoPicker(
                      itemExtent: 30.0,
                      backgroundColor: CupertinoColors.activeBlue,
                      scrollController: worldScrollController,
                      onSelectedItemChanged: (int value) {
                        world = GameData.worlds[value];
                        worldController.text = world;
                        worldScrollController =
                            FixedExtentScrollController(initialItem: value);
                        print(world);
                      },
                      children: GameData.worlds.map((world) {
                        return Text(world);
                      }).toList(),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CupertinoTextField(
            readOnly: true,
            controller: serverController,
            placeholder: "Server",
            onTap: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 200,
                      child: CupertinoPicker(
                        itemExtent: 25.0,
                        scrollController: serverScrollController,
                        backgroundColor: CupertinoColors.activeBlue,
                        onSelectedItemChanged: (int value) {
                          server = GameData.regions[value];
                          serverController.text = server;
                          serverScrollController =
                              FixedExtentScrollController(initialItem: value);
                          print(server);
                        },
                        children: GameData.regions.map((region) {
                          return Text(region);
                        }).toList(),
                      ),
                    );
                  });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CupertinoTextField(
            readOnly: true,
            controller: zoneController,
            placeholder: "Zone",
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 200,
                    child: CupertinoPicker(
                      itemExtent: 30.0,
                      scrollController: zoneScrollController,
                      backgroundColor: CupertinoColors.activeBlue,
                      onSelectedItemChanged: (int value) {
                        FFLogZone zoneData = GameData.zones.zones[value];
                        Tuple2<String, int> data =
                            Tuple2<String, int>(zoneData.zoneName, zoneData.id);
                        zoneID = data;
                        zoneController.text = data.item1;
                        zoneScrollController =
                            FixedExtentScrollController(initialItem: value);
                        print(zoneID);
                      },
                      children:
                          GameData.zones.getZonesAsTuple().map<Text>((tuple) {
                        return Text(tuple.item1);
                      }).toList(),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ];
    } else {
      return [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButton(
            value: world,
            isExpanded: true,
            items:
                GameData.worlds.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                world = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButton(
            value: server,
            isExpanded: true,
            items:
                GameData.regions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                server = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButton(
            value: zoneID,
            isExpanded: true,
            items: GameData.zones.getZonesAsTuple().map<DropdownMenuItem<Tuple2<String, int>>>(
                (Tuple2<String, int> value) {
              return DropdownMenuItem<Tuple2<String, int>>(
                value: value,
                child: Text(value.item1),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                zoneID = value;
              });
            },
          ),
        ),
      ];
    }
  }
}
