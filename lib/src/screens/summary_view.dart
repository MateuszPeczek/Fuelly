import 'package:flutter/material.dart';
import 'package:fuel_calc/src/localization/app_localizations.dart';
import 'package:fuel_calc/src/widgets/ad_box.dart';
import 'package:fuel_calc/src/widgets/compare_results_row.dart';
import 'package:fuel_calc/src/widgets/consumption_presenter.dart';
import 'package:fuel_calc/src/widgets/drawer.dart';
import 'package:fuel_calc/src/widgets/summary_view_buttons.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:fuel_calc/src/state/app_model.dart';

class SummaryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final AppModel model = ScopedModel.of<AppModel>(context);

    return WillPopScope(
      onWillPop: () async {
        model.restartView(context);
        //return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              model.restartView(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          elevation: 0,
          brightness: Theme.of(context).brightness,
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        ), // move appbars to AppModel state, get rid of scaffolds. replace appbar in app model to other ones and call notifylisteners
        drawer: CustomDrawer(),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Row(
          children: <Widget>[
            SizedBox(
              width: _size.width * 0.05,
            ),
            SizedBox(
              width: _size.width * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: _size.height * 0.28,
                    child: Row(children: <Widget>[
                      ConsumptionPresenter(),
                      _buildCompareResultWidget(context, _size, model),
                    ]),
                  ),
                  SizedBox(
                      height: _size.height * 0.15,
                      child: SummaryViewButtons(model)),
                  Center(child: AdBox()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompareResultWidget(
      BuildContext context, Size size, AppModel model) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CompareResultsRow(model, AppLocalizations.of(context).previous,
              model.getCurentUnitsLastConsumption()),
          SizedBox(height: size.height * 0.05),
          CompareResultsRow(model, AppLocalizations.of(context).overall,
              model.getCurrentUnitsOverallConsumption()),
        ],
      ),
    );
  }
}
