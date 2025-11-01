import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static pushAndRemoveUntil(BuildContext context, Widget widget) {
    return Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder: (context) => widget), (route) => false);
  }

  static push(BuildContext context, Widget widget) {
    return Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }
  static back(BuildContext context) {
    return Navigator.pop(context);
  }


}