import 'package:flutter/material.dart';

class AnimatedText extends StatefulWidget {
  @override
  _AnimatedTextState createState() => _AnimatedTextState();

  final double _endValue;
  final double _fontSize;
  final double _startValue;
  final Function _animationCompletedCallback;
  AnimatedText(this._fontSize, this._startValue, this._endValue, this._animationCompletedCallback);
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);

    _animation = Tween<double>(begin: widget._startValue, end: widget._endValue)
        .animate(
            new CurvedAnimation(parent: _controller, curve: Curves.decelerate))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              if (widget._animationCompletedCallback != null) {
                widget._animationCompletedCallback(context);
              }
            }
          });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${_animation.value.toStringAsFixed(1)}",
      style: TextStyle(fontSize: widget._fontSize),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
