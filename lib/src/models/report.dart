import 'package:fuel_calc/src/enums/units_mode.dart';

class Report {
  int id;
  String reportDate;

  double _litres;
  double _gallons;
  double _kilometers;
  double _miles;
  double _litresPer100Kilometers;
  double _milesPerGallon;

  Report(double distance, double fuel, DateTime date, UnitMode unitMode) {
    switch (unitMode) {
      case UnitMode.Imperial:
        _miles = distance;
        _gallons = fuel;

        _kilometers = _miles * 1.609;
        _litres = _gallons * 3.785;
        reportDate = date.toIso8601String();

        _milesPerGallon = _miles / _gallons;
        _litresPer100Kilometers = (_litres * 100) / _kilometers;
        break;
      case UnitMode.Metric:
        _kilometers = distance;
        _litres = fuel;

        _miles = _kilometers * 0.62;
        _gallons = _litres * 0.264;
        reportDate = date.toIso8601String();

        _milesPerGallon = _miles / _gallons;
        _litresPer100Kilometers = (_litres * 100) / _kilometers;
        break;
      default:
        throw Exception("Not supported units type");
    }
  }

  Report.fromMap(Map<String,dynamic> data) :
    id = data['id'],
    _gallons = data['gallons'],
    _kilometers = data['kilometers'],
    _litres = data['litres'],
    _litresPer100Kilometers = data['litresPer100Kilometers'],
    _miles = data['miles'],
    _milesPerGallon = data['milesPerGallon'],
    reportDate = data['reportDate'];

  Map<String, dynamic> toMap() {
    return <String,dynamic>{
      "id":id,
      "gallons":_gallons,
      "kilometers":_kilometers,
      "litres":_litres,
      "litresPer100Kilometers":_litresPer100Kilometers,
      "miles":_miles,
      "milesPerGallon":_milesPerGallon,
      "reportDate":reportDate
    };
  }

  double getDistance(UnitMode units) {
    switch (units) {
      case UnitMode.Imperial:
        return _miles;
      case UnitMode.Metric:
        return _kilometers;
      default:
        throw Exception("Not supported units type");
    }
  }

  double getFuelUsed(UnitMode units) {
    switch (units) {
      case UnitMode.Imperial:
        return _gallons;
      case UnitMode.Metric:
        return _litres;
      default:
        throw Exception("Not supported units type");
    }
  }

  double getConsumption(UnitMode units) {
    switch (units) {
      case UnitMode.Imperial:
        return _milesPerGallon;
      case UnitMode.Metric:
        return _litresPer100Kilometers;
      default:
        throw Exception("Not supported units type");
    }
  }
}