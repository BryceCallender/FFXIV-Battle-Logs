import 'package:ffxiv_battle_logs/fflog_classes.dart';
import 'package:ffxiv_battle_logs/home_page.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool hasVerifiedFFLogUsername = false;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Text("Register an account"),
      ),
      body: Builder(
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
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a username";
                  }
                  return null;
                },
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
              ),
              RaisedButton(
                child: Text("Create my account"),
                onPressed: () {
                  // Validate returns true if the form is valid, otherwise false.
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.

                    if(hasVerifiedFFLogUsername) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')));
                    } else {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Please verify your FF Log username and hit the checkbox')));
                    }

                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
