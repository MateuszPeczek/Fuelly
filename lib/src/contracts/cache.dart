import 'dart:async';

import 'package:fuel_calc/src/models/stats.dart';
import 'package:fuel_calc/src/models/report.dart';

abstract class Cache {
  Future<List<Report>> getAllReports();
  Future<Stats> getOverallStats();
  Future<Report> getLastReport();
  Future<Report> saveReport(Report report);
  Future<int> removeReport(int id);
}