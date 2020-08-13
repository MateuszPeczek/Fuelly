import 'package:flutter/material.dart';
import 'package:fuel_calc/src/enums/arrow_direction.dart';
import 'package:fuel_calc/src/state/app_model.dart';

class CompareResultsRow extends StatelessWidget {
  final String descriptionLabel;
  final double value;
  final AppModel model;

  CompareResultsRow(this.model, this.descriptionLabel, this.value);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final direction = _compareResult(model.getCurrentUnitsConsumption(), value);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Icon(_getDirectionIcon(direction), 
            color: _getDirectionColor(direction),
            size: size.height * 0.1,
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Text(descriptionLabel,
                  style: TextStyle(fontSize: 15, color: Colors.grey)),
              Text(
                "${value.toStringAsFixed(1)}",
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ArrowDirection _compareResult(double currentConsumption, double valueToCompare) {

    var currentRounded = double.parse(currentConsumption.toStringAsFixed(1));
    var toCompareRounded = double.parse(valueToCompare.toStringAsFixed(1));

    if (currentRounded > toCompareRounded)
      return ArrowDirection.Upwards;
    else if (currentRounded < toCompareRounded)
      return ArrowDirection.Downwards;
    else return ArrowDirection.Equal;
  }

  IconData _getDirectionIcon(ArrowDirection direction) {
    switch(direction) {
        case ArrowDirection.Downwards:
          return Icons.arrow_downward;
        case ArrowDirection.Upwards:
          return Icons.arrow_upward;
        default:
          return Icons.import_export;
    }
  }

  Color _getDirectionColor(ArrowDirection direction) {
    switch(direction) {
        case ArrowDirection.Downwards:
          return Colors.green;
        case ArrowDirection.Upwards:
          return Colors.red;
        default:
          return Colors.blue;
    }
  }
}