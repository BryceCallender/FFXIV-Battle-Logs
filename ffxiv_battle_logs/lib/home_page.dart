import 'package:ffxiv_battle_logs/authentication.dart';
import 'package:ffxiv_battle_logs/fflog_classes.dart';
import 'package:ffxiv_battle_logs/personallog.dart';
import 'package:ffxiv_battle_logs/profile_page.dart';
import 'package:ffxiv_battle_logs/searchusers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class HomePage extends StatefulWidget {
  final String userName;

  const HomePage({Key key, this.userName}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  List<Widget> widgets = [PersonalLogPage(), SearchUsers(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: widgets.elementAt(_currentIndex),
      bottomNavBar: PlatformNavBar(
        itemChanged: onBarItemTapped,
        currentIndex: _currentIndex,
        ios: (_) => CupertinoTabBarData(
          items: [
            BottomNavigationBarItem(
              icon: new Icon(CupertinoIcons.home),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(CupertinoIcons.search),
              title: new Text('Search'),
            ),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person),
                title: Text('Profile')
            ),
          ],
        ),
        android: (_) => MaterialNavBarData(
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
      ),
    );
  }

  void onBarItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}