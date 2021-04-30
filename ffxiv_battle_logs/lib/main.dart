import 'package:ffxiv_battle_logs/FadingTextWidget.dart';
import 'package:ffxiv_battle_logs/home_page.dart';
import 'package:ffxiv_battle_logs/login.dart';
import 'package:ffxiv_battle_logs/searchusers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:overlay_support/overlay_support.dart';
import 'authentication.dart';
import 'package:flutter/foundation.dart' as foundation;

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    print(WidgetsBinding.instance.window
        .platformBrightness); // should print Brightness.light / Brightness.dark when you switch
    super.didChangePlatformBrightness(); // make sure you call this
    setState(
        () {}); //Once tabbed back into the app this will rebuild with new brightness :)
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: PlatformApp(
        home: MyHomePage(title: "FFXIV Battle Logs"),
        debugShowCheckedModeBanner: false,
        cupertino: (_, __) => CupertinoAppData(
          theme: CupertinoThemeData(
              primaryColor: CupertinoColors.activeBlue,
              textTheme: CupertinoTextThemeData(
                  primaryColor:
                      WidgetsBinding.instance.window.platformBrightness ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black),
              brightness: WidgetsBinding.instance.window.platformBrightness),
        ),
        material: (_, __) => MaterialAppData(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
        ),
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
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(widget.title),
        backgroundColor: CupertinoColors.activeBlue,
        cupertino: (_, __) => CupertinoNavigationBarData(
          heroTag: "main",
          transitionBetweenRoutes: false,
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset("assets/images/AppIconWithoutLog.png"),
                FadingTextWidget(),
                FutureBuilder(
                  future: showLoginOrHomePageButton(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(children: snapshot.data);
                    }
                    return Container();
                  },
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SafeArea(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "FINAL FANTASY XIV © 2010 - 2020 SQUARE ENIX CO., LTD. All Rights Reserved.",
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Widget>> showLoginOrHomePageButton() async {
    FirebaseUser user = await _auth.getCurrentUser();

    if (user == null) {
      return [
        PlatformButton(
          child: Text("Login"),
          cupertino: (_, __) => CupertinoButtonData(
            color: CupertinoColors.activeBlue,
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => Login(title: "Login Page"),
                ),
              );
            },
          ),
          material: (_, __) => MaterialRaisedButtonData(
            color: Colors.blue,
            splashColor: Colors.lightBlue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Login(title: "Login Page")),
              );
            },
          ),
        ),
        PlatformButton(
          child: Text("Search"),
          cupertino: (_, __) => CupertinoButtonData(
            color: CupertinoColors.activeBlue,
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SearchUsers(),
                ),
              );
            },
          ),
          material: (_, __) => MaterialRaisedButtonData(
            color: Colors.blue,
            splashColor: Colors.lightBlue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchUsers()),
              );
            },
          ),
        ),
      ];
    } else {
      return [
        PlatformButton(
          child: Text(" Home "),
          cupertino: (_, __) => CupertinoButtonData(
            color: CupertinoColors.activeBlue,
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => HomePage(userName: user.displayName),
                ),
              );
            },
          ),
          material: (_, __) => MaterialRaisedButtonData(
            color: Colors.blue,
            splashColor: Colors.lightBlue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(userName: user.displayName),
                ),
              );
            },
          ),
        ),
        PlatformButton(
          child: Text("Search"),
          cupertino: (_, __) => CupertinoButtonData(
            color: CupertinoColors.activeBlue,
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SearchUsers(),
                ),
              );
            },
          ),
          material: (_, __) => MaterialRaisedButtonData(
            color: Colors.blue,
            splashColor: Colors.lightBlue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchUsers()),
              );
            },
          ),
        ),
      ];
    }
  }
}
