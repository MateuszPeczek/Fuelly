import 'package:flutter/material.dart';
import 'package:fuel_calc/src/enums/adjust_mode.dart';

class AdjustInputButton extends StatefulWidget {
  final _AdjustInputButtonState _state = _AdjustInputButtonState();
  final AdjustMode _adjustMode;
  final Function() _function;

  AdjustInputButton(this._adjustMode, this._function, {Key key})
      : super(key: key);

  void fadeIn() {
    _state.fadeIn();
  }

  void fadeOut() {
    _state.fadeOut();
  }

  void disableTap() {
    _state.disableTap();
  }

  void enableTap() {
    _state.enableTap();
  }

  @override
  _AdjustInputButtonState createState() => _state;
}

class _AdjustInputButtonState extends State<AdjustInputButton>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  var _enabled = false;

  _AdjustInputButtonState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: OutlineButton(
        shape: CircleBorder(),
        child:
            widget._adjustMode == AdjustMode.Increase ? Text("+") : Text("-"),
        onPressed: handleClick,
      ),
    );
  }

  void handleClick() {
    if (_enabled) {
      widget._function();
    }
  }

  void fadeIn() {
    _animationController.forward();
  }

  void fadeOut() {
    _animationController.reverse();
  }

  void disableTap() {
    _enabled = false;
  }

  void enableTap() {
    _enabled = true;
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}
