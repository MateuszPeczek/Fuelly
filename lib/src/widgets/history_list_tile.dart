import 'package:flutter/material.dart';
import 'package:fuel_calc/src/models/report.dart';
import 'package:fuel_calc/src/state/app_model.dart';

class HistoryListTile extends StatelessWidget {
  final AppModel model;
  final Report report;

  HistoryListTile(this.model, this.report);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _buildTrailingListTile(
            context, model, _size, report.getConsumption(model.unitsMode)),
        SizedBox(
          width: 2.0,
        ),
        _buildInformationLabels(
          report.getDistance(model.unitsMode),
          model.getDistanceUnitLabel(context),
          report.getFuelUsed(model.unitsMode),
          model.getFuelUnitLabel(context),
          _size,
        ),
        SizedBox(
          width: 10.0,
        ),
        _buildDateInfo(DateTime.parse(report.reportDate), _size)
      ]),
    );
  }

  Widget _buildTrailingListTile(
    BuildContext context,
    AppModel model,
    Size size,
    double consumption,
  ) {
    var circleRadius = size.height * 0.15;

    return Stack(alignment: Alignment.center, children: [
      Container(
        width: circleRadius,
        height: circleRadius,
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).accentColor, width: size.width * 0.015),
          shape: BoxShape.circle,
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: circleRadius,
            child: Material(
              color: Colors.transparent,
              child: Text(
                "${consumption.toStringAsFixed(1)}",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          Text(
            model.getConsumptionUnitLabel(),
            style: TextStyle(color: Colors.grey[600], fontSize: 10.0),
          )
        ],
      ),
    ]);
  }

  Widget _buildInformationLabels(
    double distance,
    String distanceLabel,
    double fuel,
    String fuelLabel,
    Size size,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(Icons.drive_eta),
            SizedBox(
              width: 8.0,
            ),
            Text("${distance.toStringAsFixed(0)} $distanceLabel"),
          ],
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Row(
          children: <Widget>[
            Icon(Icons.local_gas_station),
            SizedBox(
              width: 8.0,
            ),
            Text("${fuel.toStringAsFixed(1)} $fuelLabel")
          ],
        ),
      ],
    );
  }

  Widget _buildDateInfo(DateTime date, Size size) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.calendar_today),
              SizedBox(
                width: 8.0,
              ),
              Text(
                  "${date.day.toString().padLeft(2, "0")}-${date.month.toString().padLeft(2, "0")}-${date.year}"),
            ],
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Row(
            children: <Widget>[
              Icon(Icons.watch_later),
              SizedBox(
                width: 8.0,
              ),
              Text(
                  "${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}")
            ],
          ),
        ],
      ),
    );
  }
}
