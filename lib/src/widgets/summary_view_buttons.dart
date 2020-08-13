import 'package:flutter/material.dart';
import 'package:fuel_calc/src/localization/app_localizations.dart';
import 'package:fuel_calc/src/state/app_model.dart';
import 'package:fuel_calc/src/widgets/save_button.dart';

class SummaryViewButtons extends StatelessWidget {
  final AppModel _model;

  SummaryViewButtons(this._model);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      SaveButton(_model),
      FlatButton.icon(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        label: Text(AppLocalizations.of(context).history),
        color: Theme.of(context).accentColor,
        splashColor: Theme.of(context).accentColor,
        icon: Icon(Icons.history),
        onPressed: () {
          Navigator.of(context).pushNamed("/history");
          //_model.restartView(context);
        },
      ),
    ]);
  }
}
