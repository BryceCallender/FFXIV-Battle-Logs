import 'package:ffxiv_battle_logs/authentication.dart';
import 'package:ffxiv_battle_logs/styles.dart';
import 'package:ffxiv_battle_logs/update_fflog_username.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter/foundation.dart' as foundation;

import 'forgot_password.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuthentication _auth = FirebaseAuthentication();

  final displayNameController = TextEditingController();
  String username = FirebaseAuthentication.currentUser.displayName;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text("Profile"),
        backgroundColor: CupertinoColors.activeBlue,
        ios: (_) => CupertinoNavigationBarData(
          heroTag: "profile",
          transitionBetweenRoutes: false,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                Text(username),
                Text(FirebaseAuthentication.currentUser.email),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformButton(
                    child: Text("Update FF Log Username",
                        style: Styles.getTextStyleFromBrightness(context)),
                    color: CupertinoColors.activeBlue,
                    onPressed: () {
                      if(isIOS) {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) => UpdateUsername())).then((value) {
                          setState(() {
                            if(value != null) {
                              username = value;
                            }
                          });
                        });
                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => UpdateUsername())).then((value) {
                          setState(() {
                            if(value != null) {
                              username = value;
                            }
                          });
                        });
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformButton(
                    child: Text("Change Password",
                        style: Styles.getTextStyleFromBrightness(context)),
                    color: CupertinoColors.activeBlue,
                    onPressed: () {
                      if(isIOS) {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) => ForgotPassword()));
                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ForgotPassword()));
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformButton(
                    child: Text("Log out",
                        style: Styles.getTextStyleFromBrightness(context)),
                    color: CupertinoColors.activeBlue,
                    onPressed: () {
                      _auth.signOut();
                      Navigator.popUntil(context,
                          ModalRoute.withName(Navigator.defaultRouteName));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
