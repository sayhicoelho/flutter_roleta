import 'package:flutter/material.dart';

class RoletaWidget extends StatefulWidget {
  final Function onStop;
  final AnimationController animationController;
  final double end;

  const RoletaWidget({Key key, this.onStop, @required this.animationController, @required this.end}) : super(key: key);

  @override
  _RoletaWidgetState createState() => _RoletaWidgetState();
}

class _RoletaWidgetState extends State<RoletaWidget> with TickerProviderStateMixin {
  CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();

    _curvedAnimation = CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.easeOut,
    );

    _curvedAnimation.addListener(() => setState(() {}));
    _curvedAnimation.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        widget.onStop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: widget.end).animate(_curvedAnimation),
      child: Image.asset('images/roleta.png', height: 300.0,),
    );
  }
}
