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
import 'package:overlay_support/overlay_support.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class Login extends StatefulWidget {
  final String title;
  final bool registered;

  Login({Key key, this.title, this.registered = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthentication _auth = new FirebaseAuthentication();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = "";

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
        cupertino: (_, __) => CupertinoNavigationBarData(
          heroTag: "login",
          transitionBetweenRoutes: false,
        ),
      ),
      body: ListView(children: [
        Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                PlatformTextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  cupertino: (_, __) => CupertinoTextFieldData(
                    padding: const EdgeInsets.all(12.0),
                    placeholder: "Email",
                  ),
                  material: (_, __) => MaterialTextFieldData(
                    decoration: InputDecoration(
                      labelText: "Email",
                      hasFloatingPlaceholder: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                PlatformTextField(
                  controller: passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  cupertino: (_, __) => CupertinoTextFieldData(
                      padding: const EdgeInsets.all(12.0),
                      placeholder: "Password"),
                  material: (_, __) => MaterialTextFieldData(
                    decoration: InputDecoration(
                      labelText: "Password",
                      hasFloatingPlaceholder: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
                PlatformButton(
                  child: Text("Forgot Password?"),
                  cupertino: (_, __) => CupertinoButtonData(onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => ForgotPassword()));
                  }),
                  material: (_, __) => MaterialRaisedButtonData(
                    color: CupertinoColors.activeBlue,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()));
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
                  cupertino: (_, __) => CupertinoButtonData(onPressed: () {
                    Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => Register()))
                        .then((registered) {
                      if (registered != null && registered) {
                        showSimpleNotification(
                            Text("User account created successfully!"),
                            background: Colors.green);
                      }
                    });
                  }),
                  material: (_, __) => MaterialRaisedButtonData(
                    color: CupertinoColors.activeBlue,
                    onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()))
                          .then((registered) {
                        if (registered != null && registered) {
                          showSimpleNotification(
                              Text("User account created successfully!"),
                              background: Colors.green);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
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
        setState(() {
          if (emailController.text.length > 0 &&
              !EmailValidator.validate(emailController.text)) {
            errorMessage = "Badly formatted email.";
          } else {
            errorMessage = "Please fill in all fields.";
          }
        });
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
        setState(() {
          errorMessage = "";
        });
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
      } else {
        setState(() {
          errorMessage = "Invalid username or password.";
        });
      }
    }
  }
}
