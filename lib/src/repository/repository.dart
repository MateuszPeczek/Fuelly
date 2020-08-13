import 'dart:io';

import 'package:fuel_calc/src/contracts/cache.dart';
import 'package:fuel_calc/src/models/report.dart';
import 'package:fuel_calc/src/models/stats.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:sqflite/sqflite.dart';

class Repository implements Cache {
  Database db;
  Future _isInitialized;

  Future get isInitialized => _isInitialized;

  Repository() {
    _isInitialized = init();
  }

  Future<void> init() async {
    await checkPermissions();

    Directory documentsDirectory = await getExternalStorageDirectory();
    final path = join(documentsDirectory.path, "fuellyReports.db");
    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
      newDb.execute("""
          CREATE TABLE Reports 
            (
              id INTEGER PRIMARY KEY,
              litres real,
              gallons real,
              kilometers real,
              miles real,
              litresPer100Kilometers real,
              milesPerGallon real,
              reportDate TEXT
            )
        """);
    });
  }

  @override
  Future<Report> getLastReport() async {
    final result =
        await db.rawQuery("SELECT * FROM Reports order by id desc LIMIT 1");

    if (result.length > 0) return Report.fromMap(result.first);

    return null;
  }

  @override
  Future<List<Report>> getAllReports() async {
    List<Report> result = List<Report>();
    final queryResult =
        await db.rawQuery("SELECT * FROM Reports order by reportDate desc");

    for (Map<String, dynamic> report in queryResult) {
      result.add(Report.fromMap(report));
    }

    return result.toList();
  }

  @override
  Future<Report> saveReport(Report report) async {
    var newRecordId = await db.insert("Reports", report.toMap());
    var queryResult =
        await db.query("Reports", where: "id == ?", whereArgs: [newRecordId]);

    if (queryResult.length > 0)
      return Report.fromMap(queryResult.first);
    else
      return null;
  }

  @override
  Future<int> removeReport(int id) async {
    return db.delete("Reports", where: "id == ?", whereArgs: [id]);
  }

  @override
  Future<Stats> getOverallStats() async {
    Stats stats;
    var _recordsCount =
        await db.rawQuery("SELECT Count(1) as Amount FROM Reports");
    var overallConsumption = await db.rawQuery(
        "SELECT SUM(litresPer100Kilometers) as SummaryMetric, SUM(milesPerGallon) as SummaryImperial FROM Reports");

    final recordsCountResult = _recordsCount.first["Amount"];
    final summaryMetricResult = overallConsumption.first["SummaryMetric"];
    final summaryImperialResult = overallConsumption.first["SummaryImperial"];

    if (recordsCountResult > 0) {
      stats = Stats(summaryMetricResult / recordsCountResult,
          summaryImperialResult / recordsCountResult);
    } else {
      stats = Stats(0.0, 0.0);
    }
    return stats;
  }

  Future<void> checkPermissions() async {
    await new Future.delayed(new Duration(seconds: 1));
    bool checkResult = await SimplePermissions.checkPermission(
        Permission.WriteExternalStorage);
    if (!checkResult) {
      var status = await SimplePermissions.requestPermission(
          Permission.WriteExternalStorage);
      if (status == PermissionStatus.authorized) {
        return;
      } else {
        exit(0);
      }
    } else {
      var status = await SimplePermissions.requestPermission(
          Permission.WriteExternalStorage);
      if (status != PermissionStatus.authorized) {
        exit(0);
      }
    }
  }
}
