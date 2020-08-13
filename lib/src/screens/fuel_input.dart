import 'package:flutter/material.dart';
import 'package:fuel_calc/src/enums/adjust_mode.dart';
import 'package:fuel_calc/src/enums/input_type.dart';
import 'package:fuel_calc/src/localization/app_localizations.dart';
import 'package:fuel_calc/src/screens/input_view.dart';
import 'package:fuel_calc/src/state/app_model.dart';
import 'package:fuel_calc/src/widgets/adjust_input_button.dart';
import 'package:fuel_calc/src/widgets/next_page_button.dart';
import 'package:scoped_model/scoped_model.dart';

class FuelInputView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppModel model = ScopedModel.of<AppModel>(context);

    return InputView(
      AppLocalizations.of(context).fuel,
      InputType.Fuel,
      NextPageButton(
        "/calculating",
        model,
        key: UniqueKey(),
      ),
      AdjustInputButton(
          AdjustMode.Increase,
          ScopedModel.of<AppModel>(context, rebuildOnChange: false)
              .increaseFuel),
      AdjustInputButton(
          AdjustMode.Decrease,
          ScopedModel.of<AppModel>(context, rebuildOnChange: false)
              .decreaseFuel),
      UniqueKey(),
    );
  }
}
