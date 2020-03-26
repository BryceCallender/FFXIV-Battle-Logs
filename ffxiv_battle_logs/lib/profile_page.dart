import 'package:ffxiv_battle_logs/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuthentication _auth = FirebaseAuthentication();
  final displayNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text("Profile"),
        backgroundColor: CupertinoColors.activeBlue,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              children: [
                Text(FirebaseAuthentication.currentUser.displayName),
                Text(FirebaseAuthentication.currentUser.email),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformButton(
                    child: Text("Update FF Log Username"),
                    color: CupertinoColors.activeBlue,
                    onPressed: () {
                      showPlatformDialog(
                        context: context,
                        builder: (_) => PlatformAlertDialog(
                          title: Text("Update your FF Log Username"),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                PlatformTextField(
                                  controller: TextEditingController(
                                      text: FirebaseAuthentication
                                          .currentUser.displayName),
                                  readOnly: true,
                                  android: (_) => MaterialTextFieldData(
                                    decoration: InputDecoration(
                                      hintText: "FF Log Username",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                PlatformTextField(
                                  controller: displayNameController,
                                  ios: (_) => CupertinoTextFieldData(
                                      placeholder: "Updated FF Log Username"),
                                  android: (_) => MaterialTextFieldData(
                                    decoration: InputDecoration(
                                      hintText: "FF Log Username",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            PlatformDialogAction(
                              child: PlatformText("Cancel"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            PlatformDialogAction(
                              child: PlatformText("Ok"),
                              onPressed: () {
                                FirebaseAuth.instance.currentUser().then((val) {
                                  UserUpdateInfo updateUser = UserUpdateInfo();
                                  updateUser.displayName =
                                      displayNameController.text;
                                  val.updateProfile(updateUser);
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformButton(
                    child: Text("Change Password"),
                    color: CupertinoColors.activeBlue,
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformButton(
                    child: Text("Log out"),
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