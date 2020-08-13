import 'package:flutter/material.dart';
import 'package:fuel_calc/src/enums/input_type.dart';
import 'package:fuel_calc/src/state/app_model.dart';
import 'package:fuel_calc/src/widgets/adjust_input_button.dart';
import 'package:fuel_calc/src/widgets/drawer.dart';
import 'package:fuel_calc/src/widgets/next_page_button.dart';
import 'package:fuel_calc/src/widgets/transparent_appbar.dart';
import 'package:fuel_calc/src/widgets/circular_amount_input.dart';
import 'package:fuel_calc/src/widgets/title_text.dart';
import 'package:scoped_model/scoped_model.dart';

class InputView extends StatelessWidget {
  final String _title;
  final InputType _inputType;
  final bool initialInput;
  final NextPageButton _nextPageButton;
  final AdjustInputButton _increaseButton;
  final AdjustInputButton _decreaseButton;
  final UniqueKey key;

  InputView(this._title, this._inputType, this._nextPageButton,
      this._increaseButton, this._decreaseButton, this.key,
      {this.initialInput = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: TransparentAppBar(),
      drawer: _buildDrawer(),
      body: Container(
        alignment: Alignment.center,
        color: Theme.of(context).backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: _size.height * 0.01,
            ),
            SizedBox(
                height: _size.height * 0.12,
                width: _size.width * 0.8,
                child: Align(
                  alignment: Alignment.center,
                  child: TitleText(_title),
                )),
            SizedBox(
              height: _size.height * 0.08,
            ),
            Container(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  CircularAmountInput(
                      ScopedModel.of<AppModel>(context, rebuildOnChange: true),
                      _inputType,
                      _dragEndCallback,
                      _dragStartCallback),
                  Column(
                    children: <Widget>[
                      _increaseButton,
                      SizedBox(
                        height: _size.height * 0.22,
                      ),
                      _decreaseButton
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: _size.height * 0.05,
            ),
            _nextPageButton
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    if (!initialInput) return null;

    return CustomDrawer();
  }

  void _dragStartCallback(double value) {
    _nextPageButton.disableTap();
  }

  void _dragEndCallback(double value) {
    if (value > 0) {
      _nextPageButton.enableTap();
      _increaseButton.enableTap();
      _decreaseButton.enableTap();
      _nextPageButton.fadeIn();
      _increaseButton.fadeIn();
      _decreaseButton.fadeIn();
    } else {
      _nextPageButton.disableTap();
      _increaseButton.disableTap();
      _decreaseButton.disableTap();
      _nextPageButton.fadeOut();
      _increaseButton.fadeOut();
      _decreaseButton.fadeOut();
    }
  }
}
