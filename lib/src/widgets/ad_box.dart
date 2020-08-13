import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';

class AdBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 1000), () => true),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData)
              return Container(
                height: 250,
                width: 300,
                child: Center(child: CircularProgressIndicator()));
            else {
              return AdmobBanner(
                adUnitId: '',
                adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
              );
            }
          }),
    );
  } 
}
