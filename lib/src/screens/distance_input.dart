import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fuel_calc/src/enums/adjust_mode.dart';
import 'package:fuel_calc/src/enums/input_type.dart';
import 'package:fuel_calc/src/localization/app_localizations.dart';
import 'package:fuel_calc/src/screens/input_view.dart';
import 'package:fuel_calc/src/state/app_model.dart';
import 'package:fuel_calc/src/widgets/adjust_input_button.dart';
import 'package:fuel_calc/src/widgets/next_page_button.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:store_redirect/store_redirect.dart';

class DistanceInputView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final AppModel model = ScopedModel.of(context, rebuildOnChange: true);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (ScopedModel.of<AppModel>(context, rebuildOnChange: false)
                  .appStartupCounter >
              3 &&
          !ScopedModel.of<AppModel>(context, rebuildOnChange: false).isAppRated)
        showRateAppDialog(
            context, ScopedModel.of<AppModel>(context, rebuildOnChange: false));
    });

    return InputView(
      AppLocalizations.of(context).distance,
      InputType.Distance,
      NextPageButton(
        "/fuel",
        ScopedModel.of<AppModel>(context, rebuildOnChange: false),
        key: UniqueKey(),
      ),
      AdjustInputButton(
          AdjustMode.Increase,
          ScopedModel.of<AppModel>(context, rebuildOnChange: false)
              .increaseDistance),
      AdjustInputButton(
          AdjustMode.Decrease,
          ScopedModel.of<AppModel>(context, rebuildOnChange: false)
              .decreaseDistance),
      UniqueKey(),
      initialInput: ScopedModel.of<AppModel>(context, rebuildOnChange: false)
          .initialInput,
    );
  }

  Future showRateAppDialog(BuildContext context, AppModel model) async {
    await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Text(AppLocalizations.of(context).rateApp),
            actions: <Widget>[
              new FlatButton(
                  child: new Text(AppLocalizations.of(context).later),
                  onPressed: () {
                    Navigator.popUntil(context,
                        ModalRoute.withName(Navigator.defaultRouteName));
                    model.resetAppCounter();
                  }),
              new FlatButton(
                  child: new Text(AppLocalizations.of(context).noThanks),
                  onPressed: () {
                    model.markAppAsRated();
                    Navigator.popUntil(context,
                        ModalRoute.withName(Navigator.defaultRouteName));
                  }),
              new FlatButton(
                  child: new Text(AppLocalizations.of(context).yes),
                  onPressed: () {
                    model.markAppAsRated();
                    Navigator.popUntil(context,
                        ModalRoute.withName(Navigator.defaultRouteName));
                    StoreRedirect.redirect(androidAppId: "devon.fuel_calc");
                  }),
            ],
          );
        });
  }
}
