import 'package:flutter/material.dart';
import 'package:fuel_calc/src/localization/app_localizations.dart';
import 'package:fuel_calc/src/models/report.dart';
import 'package:fuel_calc/src/state/app_model.dart';
import 'package:fuel_calc/src/widgets/centered_title_appbar.dart';
import 'package:fuel_calc/src/widgets/history_list_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class HistoryView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HistoryViewState();
}

class HistoryViewState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {
    var model = ScopedModel.of<AppModel>(context);

    return Scaffold(
        appBar: CenteredTitleAppBar(AppLocalizations.of(context).history),
        backgroundColor: Theme.of(context).backgroundColor,
        body: _buildAnimatedList(model));
  }

  Widget _buildAnimatedList(AppModel model) {
    return FutureBuilder(
        future: model.getAllReports(),
        builder: (BuildContext context, AsyncSnapshot<List<Report>> snapshot) {
          if (snapshot.data == null ||
              snapshot.connectionState != ConnectionState.done)
            return Center(child: CircularProgressIndicator());
          else {
            return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                      key: ValueKey(snapshot.data[index].id),
                      movementDuration: Duration(milliseconds: 500),
                      resizeDuration: Duration(milliseconds: 500),
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Icon(Icons.delete)]),
                        ),
                      ),
                      onDismissed: (direction) {
                        model.deleteReport(model.reports[index]);
                        snapshot.data.removeAt(index);
                      },
                      confirmDismiss: _confirmDelete,
                      child: HistoryListTile(model, snapshot.data[index]));
                });
          }
        });
  }

  Future<bool> _confirmDelete(DismissDirection direction) async {
    bool result = false;

    await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Text(AppLocalizations.of(context).deleteConfirmation),
            actions: <Widget>[
              new FlatButton(
                  child: new Text(AppLocalizations.of(context).yes),
                  onPressed: () {
                    result = true;
                    Navigator.of(context).pop();
                  }),
              new FlatButton(
                  child: new Text(AppLocalizations.of(context).cancel),
                  onPressed: () {
                    result = false;
                    Navigator.of(context).pop();
                  })
            ],
          );
        });

    return result;
  }
}
