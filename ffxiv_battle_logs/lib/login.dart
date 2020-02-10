import 'package:ffxiv_battle_logs/fflog_classes.dart';
import 'package:ffxiv_battle_logs/home_page.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final String title;

  Login({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

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
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a username";
                  }
                  return null;
                },
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
                ),
              ),
              RaisedButton(
                child: Text("Login"),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
//                    Scaffold.of(context)
//                        .showSnackBar(SnackBar(content: Text("Processing...")));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PersonalLogPage(FFLogZones(new List<FFLogZone>()))));
                  }
                },
              ),
              RaisedButton(
                child: Text("Create an Account"),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
