import 'package:flutter/material.dart';
import 'package:fuel_calc/libraries/seekbar/src/seekbars.dart';

import 'package:fuel_calc/src/enums/input_range_enum.dart';
import 'package:fuel_calc/src/enums/input_type.dart';
import 'package:fuel_calc/src/state/app_model.dart';
import 'package:fuel_calc/src/wrappers/primitive_wrapper.dart';

class CircularAmountInput extends StatefulWidget {
  @override
  CircularAmountInputState createState() => CircularAmountInputState();
  final Function(double) _dragEndCallback;
  final Function(double) _dragStartCallback;

  final InputType _inputType;
  final AppModel _model;

  CircularAmountInput(this._model, this._inputType, this._dragEndCallback,
      this._dragStartCallback);
}

class CircularAmountInputState extends State<CircularAmountInput>
    with SingleTickerProviderStateMixin {
  //double _thumbPercent = 0;
  //double _progress = 0;
  double _previousPercent = 0;
  int _spins = 0;
  bool _isInputDirty = false;
  Color _trackColor;

  PrimitiveWrapper _selectedValue;
  InputRange _range;
  String _label;
  bool _showStartAnimation = true;

  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: Duration(milliseconds: 900), vsync: this);

    _selectedValue = widget._inputType == InputType.Distance
        ? widget._model.distance
        : widget._model.fuel;

    _showStartAnimation = widget._model.initialInput;

    _range = widget._inputType == InputType.Distance
        ? InputRange.Thousand
        : InputRange.Hundred;

    widget._model.thumbPercent.value =
        _selectedValue.value / (_range == InputRange.Hundred ? 100 : 1000);
    widget._model.progress.value = widget._model.thumbPercent.value;
    widget._dragEndCallback(widget._model.thumbPercent.value);

    if (_showStartAnimation) {
      _animation = Tween<double>(begin: 0, end: 0.03).animate(
        new CurvedAnimation(
          parent: _controller,
          curve: Curves.decelerate,
          reverseCurve: Curves.elasticIn,
        ),
      )
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) _controller.reverse();
          if (status == AnimationStatus.dismissed) {
            Future.delayed(const Duration(seconds: 3), () {
              if (!_isInputDirty) _controller.forward();
            });
          }
        })
        ..addListener(() {
          setState(() {});
          widget._model.thumbPercent.value = _animation.value;
        });

      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    _trackColor = Theme.of(context).accentColor;

    _label = widget._inputType == InputType.Distance
        ? widget._model.getDistanceUnitLabel(context)
        : widget._model.getFuelUnitLabel(context);

    return Stack(
      children: [
        Container(
          width: _size.width * 0.75,
          height: _size.width * 0.85,
          color: Colors.transparent,
          child: RadialSeekBar(
            trackColor: _paintTrack(),
            trackWidth: 10,
            progress: widget._model.progress.value,
            progressWidth: 10,
            progressColor: _paintProgress(),
            thumb: _buildThumbWidget(_size),
            thumbPercent: widget._model.thumbPercent.value,
            onDragUpdate: updateValue,
            onDragEnd: onDragEnd,
            onDragStart: onDragStart,
          ),
        ),
        Column(
          children: <Widget>[
            Text(
              "${_selectedValue.value.toStringAsFixed(_range == InputRange.Hundred ? 1 : 0)}",
              style: TextStyle(fontSize: 70),
            ),
            Text(
              _label,
              style: TextStyle(color: Colors.grey[600], fontSize: 25),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          height: _size.width * 0.63,
          width: _size.width * 0.63,
        ),
      ],
      alignment: AlignmentDirectional.center,
    );
  }

  Color _paintTrack() {
    var background = _trackColor;
    if (_spins > 0) {
      var foreground = Color.fromRGBO(0, 0, 0, getTrackCoverOpacity(0.3));
      return Color.alphaBlend(foreground, background);
    }
    return background;
  }

  Color _paintProgress() {
    return Color.alphaBlend(Color.fromRGBO(0, 0, 0, getTrackCoverOpacity(0.4)),
        Theme.of(context).accentColor);
  }

  double getTrackCoverOpacity(double startValue) {
    if (_selectedValue.value <= 0) return 0;

    var opacity = startValue + (_spins * 0.1);
    return opacity > 1 ? 1 : opacity;
  }

  Widget _buildThumbWidget(Size size) {
    final double radius = 40;
    return Material(
      type: MaterialType.circle,
      color: Colors.white,
      elevation: 6,
      child: CircleThumb(
        diameter: radius,
      ),
    );
  }

  void updateValue(double percent) {
    setState(() {
      _controller.stop();
      _isInputDirty = true;
      widget._model.thumbPercent.value = percent;
      widget._model.progress.value = percent;

      final range = _range == InputRange.Hundred ? 100 : 1000;
      final double roundedPercent = (widget._model.thumbPercent.value * range);

      if ((_previousPercent == roundedPercent)) return;
      if (roundedPercent == 0) return;

      if (_previousPercent > (7 * (range / 10)) &&
          roundedPercent < (4 * (range / 10))) {
        _spins++;
      } else if (_previousPercent < (4 * (range / 10)) &&
          roundedPercent > (7 * (range / 10))) if (_spins >= 0) {
        _spins--;
      }

      var result = (_spins * range) + roundedPercent;
      if (result <= 0) {
        widget._model.progress.value = 0;
        result = 0;
      }
      if (result > 99999) result = 99999;

      _selectedValue.value = result;

      if (_previousPercent != roundedPercent) _previousPercent = roundedPercent;
    });
  }

  void onDragEnd(double percent) {
    if (widget._dragEndCallback != null)
      widget._dragEndCallback(_selectedValue.value);
  }

  void onDragStart(double percent) {
    if (widget._dragStartCallback != null)
      widget._dragStartCallback(_selectedValue.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
