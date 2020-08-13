import 'package:flutter/material.dart';
import 'package:fuel_calc/src/state/app_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ConsumptionPresenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final AppModel model = ScopedModel.of<AppModel>(context);
    final double radius = size.width * 0.55;

    return Stack(alignment: Alignment.center, children: [
      Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).accentColor, width: size.width * 0.015),
          shape: BoxShape.circle,
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Hero(
              tag: "consumption",
              flightShuttleBuilder: (flightContext, animation, direction,
                  fromContext, toContext) {
                return Material(
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      "${model.getCurrentUnitsConsumption().toStringAsFixed(1)}",
                      style: TextStyle(fontSize: 60),
                    ),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                width: radius,
                child: Material(
                    color: Colors.transparent,
                    child: Text(
                      "${model.getCurrentUnitsConsumption().toStringAsFixed(1)}",
                      style: TextStyle(fontSize: 60),
                    )),
              ),
            ),
          Text(
            model.getConsumptionUnitLabel(),
            style: TextStyle(color: Colors.grey[600], fontSize: 15.0),
          )
        ],
      ),
    ]);
  }
}
