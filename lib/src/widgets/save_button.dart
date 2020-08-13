import 'package:flutter/material.dart';
import 'package:fuel_calc/src/localization/app_localizations.dart';
import 'package:fuel_calc/src/state/app_model.dart';

class SaveButton extends StatefulWidget {
  final _state = _SaveButtonState();
  final AppModel _model;

  SaveButton(this._model);

  @override
  _SaveButtonState createState() => _state;
}

class _SaveButtonState extends State<SaveButton> {
  var _reportSaved = false;

  @override
  Widget build(BuildContext context) {
    if (!_reportSaved) {
      return FlatButton.icon(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        label: Text(AppLocalizations.of(context).save),
        color: Theme.of(context).accentColor,
        splashColor: Theme.of(context).accentColor,
        icon: Icon(Icons.save),
        onPressed: () {
          widget._model.saveReport();
          _reportSaved = true;
          setState(() {});
        },
      );
    } else {
      return FlatButton.icon(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          label: Text(AppLocalizations.of(context).save),
          color: Theme.of(context).accentColor,
          splashColor: Theme.of(context).accentColor,
          icon: Icon(Icons.check),
          onPressed: null);
          }
    }
  }