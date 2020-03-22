import 'package:ffxiv_battle_logs/authentication.dart';
import 'package:ffxiv_battle_logs/darkthemepreference.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DarkThemeProvider themeProvider = new DarkThemeProvider();
  FirebaseAuthentication _auth = new FirebaseAuthentication();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeProvider.darkTheme =
        await themeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Page")),
      body: Container(
        child: Column(
          children: [
            Text(FirebaseAuthentication.currentUser.displayName),
            Text(FirebaseAuthentication.currentUser.email),
            RaisedButton(
              child: Text("Update FF Log Username"),
              onPressed: () {},
            ),
            RaisedButton(
              child: Text("Change Password"),
              onPressed: () {},
            ),
            RaisedButton(
              child: Text("Log out"),
              onPressed: () {
                _auth.signOut();
                Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
              },
            )
          ],
        ),
      ),
    );
  }
}
