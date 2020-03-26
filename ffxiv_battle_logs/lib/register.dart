import 'package:ffxiv_battle_logs/authentication.dart';
import 'package:ffxiv_battle_logs/fflog_classes.dart';
import 'package:ffxiv_battle_logs/personallog.dart';
import 'package:ffxiv_battle_logs/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter/foundation.dart' as foundation;

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool hasVerifiedFFLogUsername = false;
  String _email;
  String _password;
  String _ffLogUsername;

  final FirebaseAuthentication _auth = new FirebaseAuthentication();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text("Register an account"),
        backgroundColor: CupertinoColors.activeBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0, bottom: 8.0),
        child: SafeArea(
          child: Builder(
            builder: (context) => Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'FF Logs Username',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter your FF Log username";
                      }
                      return null;
                    },
                    onSaved: (value) => _ffLogUsername = value,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: hasVerifiedFFLogUsername,
                        onChanged: (value) {
                          setState(() {
                            hasVerifiedFFLogUsername = value;
                          });
                        },
                      ),
                      Text("This is my FF Logs username")
                    ],
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter a email";
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value.trim(),
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter a password";
                      }
                      return null;
                    },
                    onSaved: (value) => _password = value,
                  ),
                  PlatformButton(
                    child: Text("Create my account"),
                    color: CupertinoColors.activeBlue,
                    onPressed: () async {
                      // Validate returns true if the form is valid, otherwise false.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        if (hasVerifiedFFLogUsername) {
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Processing Data')));
                          validateAndSubmit();
                        } else {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Please verify your FF Log username and hit the checkbox')));
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave() && _formKey.currentState.validate()) {
      FirebaseUser user = await _auth.signUp(_email, _password, _ffLogUsername);
      print("Logged in $user");

      if (user != null) {
        if (isIOS) {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => Login(title: "Login Page")));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Login(title: "Login Page")));
        }
      }
    }
  }
}
