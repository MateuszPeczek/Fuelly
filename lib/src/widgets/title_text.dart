import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final _text;

  TitleText(this._text);

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(
        //color: Colors.black,
        fontSize: 60, 
      ),
    );
  }
}
