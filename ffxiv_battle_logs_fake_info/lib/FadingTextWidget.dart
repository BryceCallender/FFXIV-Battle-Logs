import 'package:flutter/material.dart';

class FadingTextWidget extends StatefulWidget {
  final Widget child;
  int textIndex = 0;

  FadingTextWidget({this.child, Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FadingTextWidgetState();

}

class _FadingTextWidgetState extends State<FadingTextWidget> with SingleTickerProviderStateMixin {
  static const List<String> textToShow = ["Check your FF Log Reports", "Analyze DPS and HPS", "Watch your events unfold skill by skill", "Search for others"];

  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5)
    );

    _animation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(_controller);

    _controller.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        setState(() {
          widget.textIndex = ++widget.textIndex % textToShow.length;
          _controller.repeat();
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return FadeTransition(
      opacity: _animation,
      child: Text(textToShow[widget.textIndex])
    );
  }

}