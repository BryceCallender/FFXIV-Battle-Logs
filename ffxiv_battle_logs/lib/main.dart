import 'package:ffxiv_battle_logs/FadingTextWidget.dart';
import 'package:ffxiv_battle_logs/login.dart';
import 'package:ffxiv_battle_logs/searchusers.dart';
import 'package:ffxiv_battle_logs/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication.dart';
import 'darkthemepreference.dart';
import 'fflog_classes.dart';
import 'home_page.dart';

void main() {
//  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//      .then((_) {
//    runApp(new MyApp());
//  });
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeProvider = new DarkThemeProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeProvider.darkTheme =
        await themeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => themeProvider,
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, DarkThemeProvider value, Widget child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: Styles.themeData(themeProvider.darkTheme, context),
            home: MyHomePage(title: 'FFXIV Battle Logs'),
          );
        },
      ),
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
    var themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
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
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return snapshot.data;
                  } else {
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
                  child: Text("Search"),
              ),
              Checkbox(
                  value: themeChange.darkTheme,
                  onChanged: (bool value) {
                    themeChange.darkTheme = value;
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Widget> showLoginOrHomePageButton() async {
    FirebaseUser user = await _auth.getCurrentUser();

    if (user == null) {
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
            MaterialPageRoute(builder: (context) => Login(title: "Login Page")),
          );
        },
        child: Text("Login"),
      );
    } else {
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
                  builder: (context) =>
                      PersonalLogPage(user.displayName, new FFLogZones())),
            );
          },
          child: Text("Home page"));
    }
  }
}
