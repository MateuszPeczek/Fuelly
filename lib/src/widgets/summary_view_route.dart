import 'package:flutter/material.dart';

class SummaryViewRoute extends PageRouteBuilder {
  final Widget page;

  SummaryViewRoute({this.page}) 
  : super(
    transitionDuration: const Duration(milliseconds: 600),

    pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return page;
          },
    transitionsBuilder: (BuildContext context,
               Animation<double> animation,
               Animation<double> secondaryAnimation,
               Widget child) {
             return SlideTransition(
               child: child,
               position: Tween<Offset>(
                 begin: const Offset(-1, 0),
                 end: Offset.zero,
               ).animate(CurvedAnimation(
                 parent: animation,
                 curve: Curves.decelerate
               )),
             );
           },
  );
}

