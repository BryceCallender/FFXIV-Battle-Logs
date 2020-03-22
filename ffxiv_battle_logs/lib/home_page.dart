import 'package:ffxiv_battle_logs/authentication.dart';
import 'package:ffxiv_battle_logs/fflog_classes.dart';
import 'package:ffxiv_battle_logs/personallog.dart';
import 'package:ffxiv_battle_logs/profile_page.dart';
import 'package:ffxiv_battle_logs/searchusers.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String userName;

  const HomePage({Key key, this.userName}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  List<Widget> widgets = [PersonalLogPage(FirebaseAuthentication.currentUser.displayName, new FFLogZones()), SearchUsers(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(title: Text(widget.userName + " Personal Logs")),
//      endDrawer: Drawer(
//        child: ListView(
//          padding: EdgeInsets.zero,
//          children: <Widget>[
//            UserAccountsDrawerHeader(
//              accountName: Text(FirebaseAuthentication.currentUser.displayName),
//              accountEmail: Text(FirebaseAuthentication.currentUser.email),
//              currentAccountPicture: CircleAvatar(
//                  child: Icon(Icons.account_circle)
//              ),
//            ),
//            ListTile(
//              leading: Icon(Icons.account_circle),
//              title: Text('Profile'),
//              trailing: Icon(Icons.keyboard_arrow_right),
//            ),
//            ListTile(
//              leading: Icon(Icons.settings),
//              title: Text('Settings'),
//              trailing: Icon(Icons.keyboard_arrow_right),
//            ),
//          ],
//        ),
//      ),
      body: widgets.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onBarItemTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.search),
            title: new Text('Search'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile')
          ),
        ],
      ),
    );
  }

  void onBarItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}