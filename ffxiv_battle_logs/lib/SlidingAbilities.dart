import 'package:flutter/cupertino.dart';

class SlidingAbilities extends StatefulWidget {
  final String abilityPath;
  final double heightSlide;

  SlidingAbilities({Key key, this.abilityPath, this.heightSlide}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SlidingAbilityState();
}

class SlidingAbilityState extends State<SlidingAbilities>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(1.0, widget.heightSlide),
      end: Offset(-10.0, widget.heightSlide),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.forward();

    _controller.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        dispose();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Image.asset(widget.abilityPath),
      ),
    );
  }
}
