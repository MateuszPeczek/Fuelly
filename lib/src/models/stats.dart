import 'package:fuel_calc/src/enums/units_mode.dart';

class Stats {
  double _overallLitresPer100Kilometers;
  double _overalllMilesPerGallons;

  Stats(this._overallLitresPer100Kilometers, 
        this._overalllMilesPerGallons);

  double getOverallConsumption(UnitMode unitsMode) {
    switch (unitsMode) {
      case UnitMode.Imperial:
        return _overalllMilesPerGallons;
      case UnitMode.Metric:
        return _overallLitresPer100Kilometers;
      default:
        throw Exception("Not supported units type");
    }
  }
}