import 'package:ffxiv_battle_logs/searchresults.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'fflog_classes.dart';

class SearchUsers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchUserStats();
}

class _SearchUserStats extends State<SearchUsers> {
  final nameController = TextEditingController();
  String name = "";
  String world = "Adamantoise";
  String server = "NA";
  Tuple2<String,int> zoneID = Tuple2<String,int>("Eden's Verse", 33);

  FFLogZones ffLogZones = FFLogZones();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search for Parses"),
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                labelText: 'Character Name',
              ),
              controller: nameController,
            ),
            DropdownButton(
              value: world,
              isExpanded: true,
              items: <String>[
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
              ].map<DropdownMenuItem<String>>((String value) {
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
              items: <String>["NA", "EU", "JP"]
                  .map<DropdownMenuItem<String>>((String value) {
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
                if(snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  return DropdownButton(
                    value: zoneID,
                    isExpanded: true,
                    items: snapshot.data
                        .map<DropdownMenuItem<Tuple2<String,int>>>((Tuple2<String,int> value) {
                      return DropdownMenuItem<Tuple2<String,int>>(
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
                }else if(snapshot.connectionState == ConnectionState.waiting){
                  return CircularProgressIndicator();
                }else {
                  return Container();
                }
              }
            ),
            RaisedButton(
              child: Text("Search"),
              color: Colors.blue,
              onPressed: () {
                print("Searching for ${nameController.text} in $server:$world with zone $zoneID");
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchResults(nameController.text, world, server, zoneNumber: zoneID.item2)));
              },
            )
          ],
        ),
      ),
    );
  }
}
