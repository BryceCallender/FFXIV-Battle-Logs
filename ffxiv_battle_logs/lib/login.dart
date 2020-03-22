import 'package:ffxiv_battle_logs/authentication.dart';
import 'package:ffxiv_battle_logs/fflog_classes.dart';
import 'package:ffxiv_battle_logs/home_page.dart';
import 'package:ffxiv_battle_logs/personallog.dart';
import 'package:ffxiv_battle_logs/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  final String title;

  Login({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuthentication _auth = new FirebaseAuthentication();

  String _email;
  String _password;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter your email";
                  }
                  return null;
                },
                onSaved: (value) => _email = value.trim()
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: TextFormField(
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
                  onSaved: (value) => _password = value
                ),
              ),
              Text(
                  _auth.errorMessage,
                  style: new TextStyle(color: Colors.red),
              ),
              RaisedButton(
                child: Text("Login"),
                onPressed: validateAndSubmit,
              ),
              RaisedButton(
                child: Text("Login with Google"),
                onPressed: googleSignIn,
              ),
              RaisedButton(
                child: Text("Create an Account"),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Register()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<FirebaseUser> googleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    return user;
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
    if(validateAndSave() && _formKey.currentState.validate()) {

      FirebaseUser user = await _auth.signIn(_email, _password);
      print("Logged in $user");

      if(user != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(userName: user.displayName)));
      }
    }
  }
}
