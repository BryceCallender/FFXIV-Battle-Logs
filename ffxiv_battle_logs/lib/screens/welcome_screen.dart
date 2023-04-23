import 'package:flutter/material.dart';
import 'package:ffxiv_battle_logs/styles.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatelessWidget {
  static const List<String> textToShow = ["View", "Analyze", "Discover"];

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset("assets/images/AppIconWithoutLog.png"),
                SizedBox(
                  height: 200.0,
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: textToShow
                        .map(
                          (e) => ScaleAnimatedText(e, textStyle: TextStyles.h1),
                        )
                        .toList(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Begin"),
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
                              "FINAL FANTASY is a registered trademark of Square Enix Holdings Co., Ltd.",
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
