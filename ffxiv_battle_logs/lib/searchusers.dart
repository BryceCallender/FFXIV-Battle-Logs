import 'package:ffxiv_battle_logs/searchresults.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
  var zoneScrollController = FixedExtentScrollController(initialItem: 34);

  Tuple2<String, int> zoneID = Tuple2<String, int>("Eden's Promise", 38);

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
        title: Text("Search for Parses"),
        backgroundColor: CupertinoColors.activeBlue,
      ),
      body: Container(
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PlatformTextField(
              controller: nameController,
              cupertino: (_, __) => CupertinoTextFieldData(
                  keyboardType: TextInputType.text,
                  prefix: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(CupertinoIcons.search),
                  ),
                  placeholder: "Character name"),
              material: (_, __) => MaterialTextFieldData(
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
              cupertino: (_, __) => CupertinoButtonData(
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
              material: (_, __) => MaterialRaisedButtonData(
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
                  }),
            ),
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
                      itemExtent: 30.0,
                      backgroundColor: CupertinoColors.activeBlue,
                      scrollController: worldScrollController,
                      onSelectedItemChanged: (int value) {
                        world = worlds[value];
                        worldController.text = world;
                        worldScrollController = FixedExtentScrollController(initialItem: value);
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
                        scrollController: serverScrollController,
                        backgroundColor: CupertinoColors.activeBlue,
                        onSelectedItemChanged: (int value) {
                          server = servers[value];
                          serverController.text = server;
                          serverScrollController = FixedExtentScrollController(initialItem: value);
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
                              Tuple2<String, int> data =
                                  snapshot.data[value] as Tuple2<String, int>;
                              zoneID = data;
                              zoneController.text = data.item1;
                              zoneScrollController = FixedExtentScrollController(initialItem: value);
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButton(
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
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButton(
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
        ),
        FutureBuilder(
          future: ffLogZones.getZoneNamesAsync(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButton(
                  value: zoneID,
                  isExpanded: true,
                  items: snapshot.data
                      .map<DropdownMenuItem<Tuple2<String, int>>>(
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
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              return Container();
            }
          },
        ),
      ];
    }
  }
}
