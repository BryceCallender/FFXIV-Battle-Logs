import 'package:ffxiv_battle_logs/authentication.dart';
import 'package:ffxiv_battle_logs/home_page.dart';
import 'package:ffxiv_battle_logs/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:flutter/foundation.dart' as foundation;

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class Login extends StatefulWidget {
  final String title;

  Login({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthentication _auth = new FirebaseAuthentication();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(widget.title),
        backgroundColor: CupertinoColors.activeBlue,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              PlatformTextField(
                controller: emailController,
              ),
              PlatformTextField(
                controller: passwordController,
                obscureText: true,
              ),
//              TextFormField(
//                  decoration: InputDecoration(
//                    border: OutlineInputBorder(),
//                    labelText: 'Email',
//                  ),
//                  validator: (value) {
//
//                  },
//                  onSaved: (value) => _email = value.trim()),
//              Padding(
//                padding: EdgeInsets.only(top: 10.0),
//                child: TextFormField(
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
//                    onSaved: (value) => _password = value),
//              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PlatformButton(
                  child: Text("Login"),
                  color: CupertinoColors.activeBlue,
                  onPressed: validateAndSubmit,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PlatformButton(
                  child: Text("Create an Account"),
                  color: CupertinoColors.activeBlue,
                  ios: (_) => CupertinoButtonData(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          CupertinoPageRoute(builder: (context) => Register()));
                    }
                  ),
                  android: (_) => MaterialRaisedButtonData(
                    onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  ),
                ),
              )
            ],
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
      FirebaseUser user = await _auth.signIn(emailController.text, passwordController.text);
      print("Logged in ${user.displayName}");

      if (user != null) {
        if (isIOS) {
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                  builder: (BuildContext context) =>
                      HomePage(userName: user.displayName)));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(userName: user.displayName)));
        }
      }
    }
  }
}
