import 'package:flutter/material.dart';
import 'package:fuel_calc/src/localization/app_localizations.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text(
              AppLocalizations.of(context).options,
              style: TextStyle(fontSize: 16),
            ),
            padding: EdgeInsets.all(20),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(AppLocalizations.of(context).settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed("/settings");
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text(AppLocalizations.of(context).history),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed("/history");
            },
          ),
        ],
      ),
    );
  }
}
