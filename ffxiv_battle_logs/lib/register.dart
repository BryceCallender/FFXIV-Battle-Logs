import 'package:email_validator/email_validator.dart';
import 'package:ffxiv_battle_logs/authentication.dart';
import 'package:ffxiv_battle_logs/fflog_classes.dart';
import 'package:ffxiv_battle_logs/personallog.dart';
import 'package:ffxiv_battle_logs/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter/foundation.dart' as foundation;
import 'package:overlay_support/overlay_support.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool hasVerifiedFFLogUsername = false;

  String errorMessage = "";

  final FirebaseAuthentication _auth = new FirebaseAuthentication();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fflogUsernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text("Register an account"),
        backgroundColor: CupertinoColors.activeBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 16.0, left: 8.0, right: 8.0, bottom: 8.0),
        child: SafeArea(
          child: Builder(
            builder: (context) => Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  PlatformTextField(
                    controller: fflogUsernameController,
                    ios: (_) =>
                        CupertinoTextFieldData(placeholder: "FF Log username"),
                    android: (_) => MaterialTextFieldData(
                      decoration: InputDecoration(
                        hintText: "FF Log username",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
//                  TextFormField(
//                    decoration: InputDecoration(
//                      border: OutlineInputBorder(),
//                      labelText: 'FF Logs Username',
//                    ),
//                    validator: (value) {
//                      if (value.isEmpty) {
//                        return "Please enter your FF Log username";
//                      }
//                      return null;
//                    },
//                    onSaved: (value) => _ffLogUsername = value,
//                  ),
                  Row(
                    children: [
                      PlatformSwitch(
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
                  PlatformTextField(
                    controller: emailController,
                    ios: (_) => CupertinoTextFieldData(placeholder: "Email"),
                    android: (_) => MaterialTextFieldData(
                      decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  PlatformTextField(
                    controller: passwordController,
                    obscureText: true,
                    ios: (_) => CupertinoTextFieldData(placeholder: "Password"),
                    android: (_) => MaterialTextFieldData(
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
//                  TextFormField(
//                    decoration: InputDecoration(
//                      border: OutlineInputBorder(),
//                      labelText: 'Email',
//                    ),
//                    validator: (value) {
//                      if (value.isEmpty) {
//                        return "Please enter a email";
//                      }
//                      return null;
//                    },
//                    onSaved: (value) => _email = value.trim(),
//                  ),
//                  TextFormField(
//                    obscureText: true,
//                    decoration: InputDecoration(
//                      border: OutlineInputBorder(),
//                      labelText: 'Password',
//                    ),
//                    validator: (value) {
//                      if (value.isEmpty) {
//                        return "Please enter a password";
//                      }
//                      return null;
//                    },
//                    onSaved: (value) => _password = value,
//                  ),
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PlatformButton(
                      child: Text("Create my account"),
                      color: CupertinoColors.activeBlue,
                      onPressed: () async {
                        // Validate returns true if the form is valid, otherwise false.
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          if (hasVerifiedFFLogUsername) {
//                          Scaffold.of(context).showSnackBar(
//                              SnackBar(content: Text('Processing Data')));
                            validateAndSubmit();
                          } else {
                            showSimpleNotification(
                                Text("Please verify your FF Logs username"),
                                background: Colors.red
                            );
//                          Scaffold.of(context).showSnackBar(
//                            SnackBar(
//                              content: Text(
//                                  'Please verify your FF Log username and hit the checkbox'),
//                            ),
//                          );
                          }
                        }
                      },
                    ),
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
      if(emailController.text.length > 0
          && passwordController.text.length > 0
          && fflogUsernameController.text.length > 0) {
        return true;
      } else {

      }
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave() && _formKey.currentState.validate()) {
      FirebaseUser user = await _auth
          .signUp(emailController.text, passwordController.text, fflogUsernameController.text)
          .catchError((error) {
            print(error.toString());
        if (error is PlatformException) { //ERROR_WEAK_PASSWORD, ERROR_INVALID_EMAIL, ERROR_EMAIL_ALREADY_IN_USE errors caught
          error = error as PlatformException;
          setState(() {
            errorMessage = error.message;
          });
        }
      });

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
