import 'package:ffxiv_battle_logs/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:overlay_support/overlay_support.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  FirebaseAuthentication _auth = FirebaseAuthentication();

  final emailController = TextEditingController();
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text("Forgot password"),
        backgroundColor: CupertinoColors.activeBlue,
        cupertino: (_, __) => CupertinoNavigationBarData(
          heroTag: "forgotpassword",
          transitionBetweenRoutes: false,
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              PlatformTextField(
                keyboardType: TextInputType.text,
                controller: emailController,
                cupertino: (_, __) => CupertinoTextFieldData(placeholder: "Email"),
                material: (_, __) => MaterialTextFieldData(
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: PlatformButton(
                  child: Text("Send Email"),
                  color: CupertinoColors.activeBlue,
                  onPressed: () {
                    if (emailController.text.length > 0) {
                      _auth
                          .sendPasswordResetEmail(emailController.text)
                          .then((value) {
                        setState(() {
                          errorMessage = "";
                        });
                        //show a notification at top of screen
                        showOverlay((context, t) {
                          return CustomAnimationToast(value: t);
                        }, key: ValueKey('hello'), curve: Curves.decelerate);
                      }).catchError((error) {
                        if (error is PlatformException) {
                          error = error as PlatformException;
                          setState(() {
                            errorMessage = error.message;
                          });
                        }
                      });
                    } else {
                      setState(() {
                        errorMessage = "Email must not be empty";
                      });
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class IosStyleToast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.black87,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    Text("Email sent")
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Example to show how to popup overlay with custom animation.
class CustomAnimationToast extends StatelessWidget {
  final double value;

  static final Tween<Offset> tweenOffset =
      Tween<Offset>(begin: Offset(0, 40), end: Offset(0, 0));

  static final Tween<double> tweenOpacity = Tween<double>(begin: 0, end: 1);

  const CustomAnimationToast({Key key, @required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: tweenOffset.transform(value),
      child: Opacity(
        child: IosStyleToast(),
        opacity: tweenOpacity.transform(value),
      ),
    );
  }
}
