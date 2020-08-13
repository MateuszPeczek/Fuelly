import 'package:flutter/material.dart';
import 'package:fuel_calc/src/screens/summary_view.dart';
import 'package:fuel_calc/src/widgets/summary_view_route.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:fuel_calc/src/state/app_model.dart';
import 'package:fuel_calc/src/widgets/animated_text.dart';

class CalculatingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _model = ScopedModel.of<AppModel>(context, rebuildOnChange: true);
    final _consumption = _model.consumption;

    _model.calculateOverallStats();

    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Center(
          child: Hero(
            tag: "consumption",
            child: Container(
              height: 200,
              alignment: Alignment.center,
              child: AnimatedText(
                60,
                0,
                _consumption,
                (context) => Navigator.push(
                      context,
                      SummaryViewRoute(page: SummaryView()),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
