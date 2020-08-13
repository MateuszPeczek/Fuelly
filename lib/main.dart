import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:fuel_calc/src/app.dart';
import 'package:fuel_calc/src/state/app_model.dart';
import 'package:fuel_calc/src/state/theme_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  Admob.initialize("");
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final SharedPreferences _preferences = await SharedPreferences.getInstance();
  final AppModel _model = AppModel(_preferences);
  final ThemeModel _themeModel = ThemeModel(_preferences);

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
 
  List<DisplayMode> modes = [];
  await FlutterDisplayMode.setMode(modes.last);
  
  runApp(ScopedModel(
      model: _themeModel,
      child: ScopedModel(
        model: _model,
        child: App(),
      )));
}
