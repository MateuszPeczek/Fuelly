import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fuel_calc/src/models/localized_labels.dart';



import 'package:fuel_calc/src/localization/supported_locales.dart'
    show languages;

class AppLocalizations {
  AppLocalizations(this._localizedLabels);
  LocalizedLabels _localizedLabels;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get accentColor => _localizedLabels.accentColor;
  String get apperance => _localizedLabels.apperance;
  String get back => _localizedLabels.back;
  String get cancel => _localizedLabels.cancel;
  String get chooseAccentColor => _localizedLabels.chooseAccentColor;
  String get darkMode => _localizedLabels.darkMode;
  String get deleteConfirmation => _localizedLabels.deleteConfirmation;
  String get distance => _localizedLabels.distance;
  String get distanceImperialUnit => _localizedLabels.distanceImperialUnit;
  String get distanceMetricUnit => _localizedLabels.distanceMetricUnit;
  String get fuel => _localizedLabels.fuel;
  String get fuelImperialUnit => _localizedLabels.fuelImperialUnit;
  String get fuelMetricUnit => _localizedLabels.fuelMetricUnit;
  String get history => _localizedLabels.history;
  String get imperialUnits => _localizedLabels.imperialUnits;
  String get metricUnits => _localizedLabels.metricUnits;
  String get next => _localizedLabels.next;
  String get options => _localizedLabels.options;
  String get overall => _localizedLabels.overall;
  String get previous => _localizedLabels.previous;
  String get save => _localizedLabels.save;
  String get select => _localizedLabels.select;
  String get settings => _localizedLabels.settings;
  String get units => _localizedLabels.units;
  String get yes => _localizedLabels.yes;
  String get later => _localizedLabels.later;
  String get noThanks => _localizedLabels.noThanks;
  String get rateApp => _localizedLabels.rateApp;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => languages.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    var languageCode = locale.languageCode;
    if (!languages.contains(languageCode)) languageCode = "en";

    var parsedJson = await rootBundle.loadString("lib/assets/i18n/$languageCode.json");
    var decodedJson = jsonDecode(parsedJson);
    var localizedLabels = LocalizedLabels.fromJson(decodedJson);

    return SynchronousFuture<AppLocalizations>(AppLocalizations(localizedLabels));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
