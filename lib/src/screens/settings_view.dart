import 'package:flutter/material.dart';
import 'package:fuel_calc/src/enums/units_mode.dart';
import 'package:fuel_calc/src/localization/app_localizations.dart';
import 'package:fuel_calc/src/state/app_model.dart';
import 'package:fuel_calc/src/state/theme_model.dart';
import 'package:fuel_calc/src/widgets/centered_title_appbar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CenteredTitleAppBar(AppLocalizations.of(context).settings),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(child: ScopedModelDescendant<AppModel>(
        builder: (context, child, AppModel model) {
          var themeModel = ScopedModel.of<ThemeModel>(context);

          return Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
            child: Column(
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).apperance,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                _buildDarkModeSettingsRow(context, themeModel),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                _buildAccentColorSettingsRow(context, themeModel),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                Divider(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                Text(
                  AppLocalizations.of(context).units,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                _buildMetricSettingsRow(context, model),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                _buildImperialSettingsRow(context, model),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                )
              ],
            ),
          );
        },
      )),
    );
  }

  Widget _buildDarkModeSettingsRow(BuildContext context, ThemeModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(AppLocalizations.of(context).darkMode),
        Switch(
          activeColor: Theme.of(context).accentColor,
          onChanged: (val) async => await model.switchDarkMode(),
          value: model.brightness == Brightness.dark,
        ),
      ],
    );
  }

  Widget _buildAccentColorSettingsRow(BuildContext context, ThemeModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(AppLocalizations.of(context).accentColor),
        Padding(
          padding: EdgeInsets.only(right: 7),
          child: CircleColor(
              elevation: 2.5,
              circleSize: MediaQuery.of(context).size.width * 0.1,
              color: Theme.of(context).accentColor,
              onColorChoose: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _buildColorPickerDialog(context, model);
                    });
              }),
        ),
      ],
    );
  }

  Widget _buildMetricSettingsRow(BuildContext context, AppModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(AppLocalizations.of(context).metricUnits),
        Radio(
          activeColor: Theme.of(context).accentColor,
          value: UnitMode.Metric,
          groupValue: model.unitsMode,
          onChanged: (UnitMode newValue) {
            model.unitsMode = newValue;
          },
        )
      ],
    );
  }

  Widget _buildImperialSettingsRow(BuildContext context, AppModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(AppLocalizations.of(context).imperialUnits),
        Radio(
          activeColor: Theme.of(context).accentColor,
          value: UnitMode.Imperial,
          groupValue: model.unitsMode,
          onChanged: (UnitMode newValue) {
            model.unitsMode = newValue;
          },
        )
      ],
    );
  }

  Widget _buildColorPickerDialog(BuildContext context, ThemeModel model) {
    Color _color = Theme.of(context).accentColor;

    return SimpleDialog(
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).backgroundColor,
      title: Text(AppLocalizations.of(context).chooseAccentColor),
      children: <Widget>[
        MaterialColorPicker(
          selectedColor: _color,
          onColorChange: (Color color) {
            _color = color;
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: Text(AppLocalizations.of(context).cancel),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(AppLocalizations.of(context).select),
              onPressed: () {
                model.updateAccentColor(_color);
                Navigator.pop(context);
              },
            ),
          ],
        )
      ],
    );
  }
}
