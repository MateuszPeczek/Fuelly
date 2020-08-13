import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:fuel_calc/src/enums/units_mode.dart';
import 'package:fuel_calc/src/localization/app_localizations.dart';
import 'package:fuel_calc/src/models/report.dart';
import 'package:fuel_calc/src/models/stats.dart';
import 'package:fuel_calc/src/repository/repository.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:fuel_calc/src/wrappers/primitive_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel extends Model {
  static const String _unitModeKey = "UNITS_MODE";
  static const String _appStartupCountKey = "APP_STARTUP_COUNTER";
  static const String _isAppRatedKey = "IS_APP_RATED";

  AppModel(this._preferences) {
    try {
      var persistedUnitsMode = _preferences.getInt(_unitModeKey);
      _unitsMode = UnitMode.values[persistedUnitsMode];
    } catch (e) {
      _unitsMode = UnitMode.Metric;
    }

    try {
      _appStartCounter = _preferences.getInt(_appStartupCountKey) ?? 0;
      _appStartCounter++;
      if (_appStartCounter < 4 || _appStartCounter >= 0)
        _preferences.setInt(_appStartupCountKey, _appStartCounter);
    } catch (e) {
      _appStartCounter = 0;
    }

    try {
      _isAppRated = _preferences.getBool(_isAppRatedKey) ?? false;
    } catch (e) {
      _isAppRated = false;
    }
  }

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  final Repository _repository = Repository();
  final SharedPreferences _preferences;
  final PrimitiveWrapper _distance = PrimitiveWrapper(0);
  final PrimitiveWrapper _fuel = PrimitiveWrapper(0);
  final PrimitiveWrapper _thumbPercent = PrimitiveWrapper(0);
  final PrimitiveWrapper _progress = PrimitiveWrapper(0);
  final List<Report> _reports = new List<Report>();
  UnitMode _unitsMode = UnitMode.Metric;
  int _appStartCounter = 0;
  bool _isAppRated = false;
  Report _currentReport;
  Report _previousReport;
  Stats _stats;

  PrimitiveWrapper get progress => _progress;
  PrimitiveWrapper get thumbPercent => _thumbPercent;
  PrimitiveWrapper get distance => _distance;
  PrimitiveWrapper get fuel => _fuel;

  double get consumption => _getConsumption(fuel.value, distance.value);
  Report get currentReport => _currentReport;
  Report get previousReport => _previousReport;
  bool get initialInput => _distance.value == 0 && _fuel.value == 0;
  List<Report> get reports => _reports;
  String get consumptionUnitLabel => getConsumptionUnitLabel();

  UnitMode get unitsMode => _unitsMode;
  int get appStartupCounter => _appStartCounter;
  bool get isAppRated => _isAppRated;

  set unitsMode(UnitMode newValue) {
    _unitsMode = newValue;
    _preferences.setInt(_unitModeKey, newValue.index);
    notifyListeners();
  }

  void restartView(BuildContext context) {
    clearConsumption();
    setLastDbReportAsPrevious();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  double _getConsumption(double fuel, double distance) {
    if (distance <= 0) return null;

    if (_currentReport == null) {
      setLastDbReportAsPrevious();
      _currentReport = Report(distance, fuel, DateTime.now(), _unitsMode);
    }

    return _currentReport.getConsumption(_unitsMode);
  }

  void increaseDistance() {
    _distance.value++;
    _thumbPercent.value = _thumbPercent.value + 0.001;
    _progress.value = _progress.value + 0.001;
    notifyListeners();
  }

  void decreaseDistance() {
    if (_distance.value.round() > 1) {
      _distance.value--;
      _thumbPercent.value = _thumbPercent.value - 0.001;
      _progress.value = _progress.value - 0.001;
      notifyListeners();
    }
  }

  void increaseFuel() {
    _fuel.value = _fuel.value + 0.1;
    _thumbPercent.value = _thumbPercent.value + 0.001;
    notifyListeners();
  }

  void decreaseFuel() {
    if ((_fuel.value * 10).round() > 1) {
      _fuel.value = _fuel.value - 0.1;
      _thumbPercent.value = _thumbPercent.value - 0.001;
      notifyListeners();
    }
  }

  void clearConsumption() {
    distance.value = 0.0;
    fuel.value = 0.0;
    _currentReport = null;
  }

  void resetAppCounter() async {
    _appStartCounter = 0;
    await _preferences.setInt(_appStartupCountKey, _appStartCounter);
  }

  void markAppAsRated() async {
    _isAppRated = true;
    await _preferences.setBool(_isAppRatedKey, _isAppRated);
  }

  Future<Report> saveReport() async {
    setLastDbReportAsPrevious();
    var result = await _repository.saveReport(_currentReport);
    _reports.add(result);
    return result;
  }

  Future<int> deleteReport(Report report) async {
    var result = await _repository.removeReport(report.id);
    if (result == 1) {
      _reports.remove(report);
    }
    return result;
  }

  Future<List<Report>> getAllReports() async {
    return _repository.getAllReports().then((value) {
      _reports.clear();
      _reports.addAll(value);

      return value;
    });
  }

  Future<double> getLastConsumptionValue() async {
    final Report lastReport = await _repository.getLastReport();
    return lastReport?.getConsumption(_unitsMode);
  }

  double getCurrentUnitsConsumption() {
    return _currentReport?.getConsumption(_unitsMode) ?? 0;
  }

  double getCurentUnitsLastConsumption() {
    return _previousReport?.getConsumption(_unitsMode) ?? 0;
  }

  Future<void> calculateOverallStats() async {
    _stats = await _repository.getOverallStats();
  }

  double getCurrentUnitsOverallConsumption() {
    return _stats?.getOverallConsumption(_unitsMode);
  }

  Future<void> setLastDbReportAsPrevious() async {
    _previousReport = await _repository.getLastReport();
  }

  String getConsumptionUnitLabel() {
    switch (_unitsMode) {
      case UnitMode.Imperial:
        return "mpg";
      case UnitMode.Metric:
        return "l/100km";
      default:
        throw Exception();
    }
  }

  String getDistanceUnitLabel(BuildContext context) {
    switch (_unitsMode) {
      case UnitMode.Imperial:
        return AppLocalizations.of(context).distanceImperialUnit;
      case UnitMode.Metric:
        return AppLocalizations.of(context).distanceMetricUnit;
      default:
        throw Exception();
    }
  }

  String getFuelUnitLabel(BuildContext context) {
    switch (_unitsMode) {
      case UnitMode.Imperial:
        return AppLocalizations.of(context).fuelImperialUnit;
      case UnitMode.Metric:
        return AppLocalizations.of(context).fuelMetricUnit;
      default:
        throw Exception();
    }
  }

  static AppModel of(BuildContext context) => ScopedModel.of<AppModel>(context);
}
