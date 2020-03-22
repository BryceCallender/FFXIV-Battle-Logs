import 'package:ffxiv_battle_logs/FadingTextWidget.dart';
import 'package:ffxiv_battle_logs/home_page.dart';
import 'package:ffxiv_battle_logs/login.dart';
import 'package:ffxiv_battle_logs/searchusers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return PlatformApp(
      ios: (_) => CupertinoAppData(
        home: MyHomePage(title: "FFXIV Battle Logs"),
        theme: CupertinoThemeData(
            primaryColor: CupertinoColors.activeBlue,
            brightness: WidgetsBinding.instance.window.platformBrightness),
        debugShowCheckedModeBanner: false,
      ),
      android: (_) => MaterialAppData(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: MyHomePage(title: 'FFXIV Battle Logs'),
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
        ios: (_) => CupertinoNavigationBarData(
            title: Text(widget.title),
            backgroundColor: CupertinoColors.activeBlue),
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
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return snapshot.data;
                    } else {
                      return PlatformButton(
                        child: Text("Login"),
                        ios: (_) => CupertinoButtonData(
                          color: CupertinoColors.activeBlue,
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    Login(title: "Login Page"),
                              ),
                            );
                          },
                        ),
                        android: (_) => MaterialRaisedButtonData(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Login(title: "Login Page")),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
                PlatformButton(
                  child: Text("Search"),
                  ios: (_) => CupertinoButtonData(
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
                  android: (_) => MaterialRaisedButtonData(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchUsers()),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SafeArea(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "FINAL FANTASY XIV ©️ 2010 - 2020 SQUARE ENIX CO., LTD. All Rights Reserved.",
                            textAlign: TextAlign.center,
                          )
                        ],
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

  Future<Widget> showLoginOrHomePageButton() async {
    FirebaseUser user = await _auth.getCurrentUser();

    if (user == null) {
      return PlatformButton(
        child: Text("Login"),
        ios: (_) => CupertinoButtonData(
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
        android: (_) => MaterialRaisedButtonData(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Login(title: "Login Page")),
            );
          },
        ),
      );
    } else {
      return PlatformButton(
        child: Text("Home page"),
        ios: (_) => CupertinoButtonData(
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
        android: (_) => MaterialRaisedButtonData(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(userName: user.displayName),
              ),
            );
          },
        ),
      );
    }
  }
}
