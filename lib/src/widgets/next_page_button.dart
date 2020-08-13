import 'package:flutter/material.dart';
import 'package:fuel_calc/src/localization/app_localizations.dart';
import 'package:fuel_calc/src/state/app_model.dart';

class NextPageButton extends StatefulWidget {
  final AppModel _model;
  final _NextPageButtonState _state = _NextPageButtonState();
  final String _pageRoute;

  NextPageButton(this._pageRoute, this._model, {Key key}) : super(key: key);

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
  _NextPageButtonState createState() => _state;
}

class _NextPageButtonState extends State<NextPageButton>
    with TickerProviderStateMixin {
  var _enabled = false;
  AnimationController _animationController;

  _NextPageButtonState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    widget._model.removeListener(fadeIn);
    widget._model.removeListener(fadeOut);

    return FadeTransition(
      opacity: _animationController,
      child: FlatButton.icon(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        color: Theme.of(context).accentColor,
        icon: Icon(Icons.arrow_forward),
        label: Text(
          AppLocalizations.of(context).next,
          style: TextStyle(fontSize: 20),
        ),
        onPressed: onPressed,
      ),
    );
  }

  void onPressed() {
    if (_enabled) {
      Navigator.pushNamed(context, widget._pageRoute);
    }
  }

  void fadeIn() {
    // if (widget != null &&
    //     widget._model != null &&
    //     !widget._model.preventButtonsReload)
    _animationController.forward();
  }

  void fadeOut() {
    // if (widget != null &&
    //     widget._model != null &&
    //     !widget._model.preventButtonsReload)
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
