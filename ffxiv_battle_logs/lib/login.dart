import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final String title;

  Login({ Key key, this.title}): super(key:key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
            ),
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          ),
          RaisedButton(
            child: Text("Login"),
            onPressed: () {},
            
          ),
          RaisedButton(
            child: Text("Create an Account"),
            onPressed: () {},
            
          )
        ],
      ),
    );
  }

}