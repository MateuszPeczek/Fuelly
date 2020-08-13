import 'package:flutter/material.dart';

class CenteredTitleAppBar extends StatelessWidget
    implements PreferredSizeWidget {
      
  CenteredTitleAppBar(this._title, {Key key})
      : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  final String _title;
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //iconTheme: IconThemeData(color: Colors.black87),
      brightness: Theme.of(context).brightness,
      backgroundColor: Theme.of(context).backgroundColor,
      centerTitle: true,
      textTheme: Theme.of(context).textTheme,
      title: Text(_title),
    );
  }
}
