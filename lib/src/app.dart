import 'package:flutter/material.dart';
import 'package:fuel_calc/src/localization/app_localizations.dart';
import 'package:fuel_calc/src/screens/calculating_view.dart';
import 'package:fuel_calc/src/screens/distance_input.dart';
import 'package:fuel_calc/src/screens/fuel_input.dart';
import 'package:fuel_calc/src/screens/history_view.dart';

import 'package:fuel_calc/src/screens/settings_view.dart';
import 'package:fuel_calc/src/screens/summary_view.dart';
import 'package:fuel_calc/src/state/app_model.dart';
import 'package:fuel_calc/src/state/theme_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuelly',
      theme: ScopedModel.of<ThemeModel>(context, rebuildOnChange: true).theme,
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('pl', 'PL'), // Polish
        // ... other locales the app supports
      ],
      routes: <String, WidgetBuilder>{
        '/': (context) => DistanceInputView(),
        '/fuel': (context) => FuelInputView(),
        '/calculating': (context) => CalculatingView(),
        '/summary': (context) => SummaryView(),
        '/settings': (context) => SettingsView(),
        '/history': (context) => HistoryView()
      },
      navigatorObservers: <NavigatorObserver>[AppModel.observer],
    );
  }
}
