import 'package:email_validator/email_validator.dart';
import 'package:ffxiv_battle_logs/authentication.dart';
import 'package:ffxiv_battle_logs/forgot_password.dart';
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
        ios: (_) => CupertinoNavigationBarData(
          heroTag: "login",
          transitionBetweenRoutes: false,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              PlatformTextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                ios: (_) => CupertinoTextFieldData(
                  padding: const EdgeInsets.all(12.0),
                  placeholder: "Email",
                ),
                android: (_) => MaterialTextFieldData(
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefix: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              PlatformTextField(
                controller: passwordController,
                obscureText: true,
                keyboardType: TextInputType.text,
                ios: (_) => CupertinoTextFieldData(
                    padding: const EdgeInsets.all(12.0),
                    placeholder: "Password"),
                android: (_) => MaterialTextFieldData(
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefix: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              PlatformButton(
                child: Text("Forgot Password?"),
                ios: (_) => CupertinoButtonData(onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => ForgotPassword()));
                }),
                android: (_) => MaterialRaisedButtonData(
                  color: CupertinoColors.activeBlue,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ForgotPassword()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PlatformButton(
                  child: Text("Login"),
                  color: CupertinoColors.activeBlue,
                  onPressed: validateAndSubmit,
                ),
              ),
              PlatformButton(
                child: Text("Create an Account"),
                ios: (_) => CupertinoButtonData(onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => Register()));
                }),
                android: (_) => MaterialRaisedButtonData(
                  color: CupertinoColors.activeBlue,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Check if form is valid before perform login or signup
  bool validateTextFields() {
    final form = _formKey.currentState;
    if (form.validate()) {
      if (EmailValidator.validate(emailController.text) &&
          passwordController.text.length > 0) {
        form.save();
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateTextFields()) {
      FirebaseUser user =
          await _auth.signIn(emailController.text, passwordController.text);

      if (user != null) {
        print("Logged in ${user.displayName}");
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
