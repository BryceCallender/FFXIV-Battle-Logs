import 'package:ffxiv_battle_logs/searchresults.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:tuple/tuple.dart';

import 'fflog_classes.dart';
import 'package:flutter/foundation.dart' as foundation;

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class SearchUsers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchUserStats();
}

class _SearchUserStats extends State<SearchUsers> {
  String name = "";
  String world = "Adamantoise";
  String server = "NA";

  final nameController = TextEditingController();
  final worldController = TextEditingController(text: "Adamantoise");
  final serverController = TextEditingController(text: "NA");
  final zoneController = TextEditingController(text: "Eden's Verse");

  Tuple2<String, int> zoneID = Tuple2<String, int>("Eden's Verse", 33);

  final List<String> worlds = [
    "Adamantoise",
    "Aegis",
    "Alexander",
    "Anima",
    "Asura",
    "Atomos",
    "Bahamut",
    "Balmung",
    "Behemoth",
    "Belias",
    "Brynhildr",
    "Cactuar",
    "Carbuncle",
    "Cerberus",
    "Chocobo",
    "Coeurl",
    "Diabolos",
    "Durandal",
    "Excalibur",
    "Exodus",
    "Faerie",
    "Famfrit",
    "Fenrir",
    "Garuda",
    "Gilgamesh",
    "Goblin",
    "Gungnir",
    "Hades",
    "Hyperion",
    "Ifrit",
    "Ixion",
    "Jenova",
    "Kujata",
    "Lamia",
    "Leviathan",
    "Lich",
    "Louisoix",
    "Malboro",
    "Mandragora",
    "Masamune",
    "Mateus",
    "Midgardsormr",
    "Moogle",
    "Odin",
    "Omega",
    "Pandaemonium",
    "Phoenix",
    "Ragnarok",
    "Ramuh",
    "Ridill",
    "Sargatanas",
    "Shinryu",
    "Shiva",
    "Siren",
    "Tiamat",
    "Titan",
    "Tonberry",
    "Typhon",
    "Ultima",
    "Ultros",
    "Unicorn",
    "Valefor",
    "Yojimbo",
    "Zalera",
    "Zeromus",
    "Zodiark",
    "Spriggan",
    "Twintania"
  ];

  final List<String> servers = ["NA", "EU", "JP"];
  FFLogZones ffLogZones = FFLogZones();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        ios: (_) => CupertinoNavigationBarData(
          backgroundColor: Colors.blue,
          title: Text("Search for Parses"),
        ),
        android: (_) => MaterialAppBarData(title: Text("Search for Parses")),
      ),
      body: Container(
        child: Column(children: [
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
            ),
          ),
          ...platformPickers(),
          PlatformButton(
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
                }),
          ),
        ]),
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
                        backgroundColor: Colors.blue,
                        itemExtent: 30.0,
                        onSelectedItemChanged: (int value) {
                            world = worlds[value];
                            worldController.text = world;
                            print(world);
                        },
                        children: worlds.map((world) {
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
                        onSelectedItemChanged: (int value) {
                            server = servers[value];
                            serverController.text = server;
                            print(server);
                        },
                        children: servers.map((server) {
                          return Text(server);
                        }).toList(),
                      ),
                    );
                  });
            },
          ),
        ),
        FutureBuilder(
          future: ffLogZones.getZoneNamesAsync(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: CupertinoTextField(
                  readOnly: true,
                  controller: zoneController,
                  placeholder: "World",
                  onTap: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 200,
                          child: CupertinoPicker(
                            itemExtent: 30.0,
                            onSelectedItemChanged: (int value) {
                                Tuple2<String, int> data =
                                    snapshot.data[value] as Tuple2<String, int>;
                                zoneID = data;
                                zoneController.text = data.item1;
                                print(zoneID);
                            },
                            children: snapshot.data.map<Text>((tuple) {
                              return Text(tuple.item1);
                            }).toList(),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return CupertinoActivityIndicator();
            } else {
              return Container();
            }
          },
        ),
      ];
    } else {
      return [
        DropdownButton(
          value: world,
          isExpanded: true,
          items: worlds.map<DropdownMenuItem<String>>((String value) {
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
        DropdownButton(
          value: server,
          isExpanded: true,
          items: servers.map<DropdownMenuItem<String>>((String value) {
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
        FutureBuilder(
          future: ffLogZones.getZoneNamesAsync(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return DropdownButton(
                value: zoneID,
                isExpanded: true,
                items: snapshot.data.map<DropdownMenuItem<Tuple2<String, int>>>(
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
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              return Container();
            }
          },
        ),
        RaisedButton(
          child: Text("Search"),
          color: Colors.blue,
          onPressed: () {
            print(
                "Searching for ${nameController.text} in $server:$world with zone $zoneID");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchResults(
                        nameController.text, world, server,
                        zoneNumber: zoneID.item2)));
          },
        )
      ];
    }
  }
}
