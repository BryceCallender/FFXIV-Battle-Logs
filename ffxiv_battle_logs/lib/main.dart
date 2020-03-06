import 'package:ffxiv_battle_logs/FadingTextWidget.dart';
import 'package:ffxiv_battle_logs/login.dart';
import 'package:ffxiv_battle_logs/searchusers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'authentication.dart';
import 'fflog_classes.dart';
import 'home_page.dart';

void main() {
//  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//      .then((_) {
//    runApp(new MyApp());
//  });
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'FFXIV Battle Logs'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuthentication _auth = new FirebaseAuthentication();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'FFXIV Battle Logs',
              ),
              Image.asset("assets/images/AppIconWithoutLog.png"),
              FadingTextWidget(),
              FutureBuilder(
                future: showLoginOrHomePageButton(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    return snapshot.data;
                  }else {
                    return FlatButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.blueAccent,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login(title: "Login Page")),
                          );
                        },
                        child: Text("Login"),
                    );
                  }
                },
              ),
              FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchUsers()),
                    );
                  },
                  child: Text("Search"))
            ],
          ),
        ),
      ),
    );
  }

  Widget _getLandingPage() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.providerData.length ==
              1) { // logged in using email and password
            return PersonalLogPage(snapshot.data.displayName, new FFLogZones());
//          }
            //else { // logged in using other providers
//            return MainPage();
//          }
          } else {
            return Login(title: "Login Page");
          }
        }else {
          return MyHomePage(title: 'FFXIV Battle Logs');
        }
      },
    );
  }

  Future<Widget> showLoginOrHomePageButton() async {
    FirebaseUser user = await _auth.getCurrentUser();

    if(user == null) {
      return FlatButton(
          color: Colors.blue,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(8.0),
          splashColor: Colors.blueAccent,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Login(title: "Login Page")),
            );
          },
          child: Text("Login"),
      );
    }else {
      return FlatButton(
          color: Colors.blue,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(8.0),
          splashColor: Colors.blueAccent,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PersonalLogPage(user.displayName, new FFLogZones())),
            );
          },
          child: Text("Home page"));
    }
  }
}
