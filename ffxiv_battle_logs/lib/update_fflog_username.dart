import 'package:ffxiv_battle_logs/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class UpdateUsername extends StatefulWidget {
  @override
  _UpdateUsernameState createState() => _UpdateUsernameState();
}

class _UpdateUsernameState extends State<UpdateUsername> {
  final TextEditingController displayNameController = TextEditingController();

  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text("Update FF Logs Username"),
        backgroundColor: CupertinoColors.activeBlue,
        ios: (_) => CupertinoNavigationBarData(
          heroTag: "updateusername",
          transitionBetweenRoutes: false,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PlatformTextField(
                controller: TextEditingController(
                    text: FirebaseAuthentication.currentUser.displayName),
                readOnly: true,
                android: (_) => MaterialTextFieldData(
                  decoration: InputDecoration(
                    hintText: "FF Log Username",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PlatformTextField(
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
            ),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            ),
            PlatformButton(
              child: Text("Submit"),
              color: CupertinoColors.activeBlue,
              onPressed: () {
                setState(() {
                  errorMessage = "";
                });

                if(displayNameController.text.length > 0) {
                  FirebaseAuth.instance.currentUser().then(
                        (val) async {
                      UserUpdateInfo updateUser = UserUpdateInfo();
                      updateUser.displayName = displayNameController.text;
                      await val.updateProfile(updateUser);

                      Navigator.pop(context, updateUser.displayName);
                    },
                  );
                } else {
                  setState(() {
                    errorMessage = "Please enter in a username!";
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
