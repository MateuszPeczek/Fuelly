import 'package:flutter/material.dart';
import 'package:fuel_calc/src/state/app_model.dart';
import 'package:scoped_model/scoped_model.dart';

class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  TransparentAppBar({Key key})
      : preferredSize = Size.fromHeight(64.0),
        super(key: key);

  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, AppModel model) {
        return AppBar(
          elevation: 0,
          brightness: Theme.of(context).brightness,
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        );
      },
    );
  }
}
