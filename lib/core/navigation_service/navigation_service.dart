import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static Future<dynamic> pushAndRemoveUntilWithoutContext(Widget page) {
    return navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
          (route) => false,
    );
  }
  static pushAndRemoveUntil( Widget widget) {
    return Navigator.of(NavigationService.navigatorKey.currentContext!).pushAndRemoveUntil( MaterialPageRoute(builder: (context) => widget), (route) => false);
  }

  static push( Widget widget) {
    return Navigator.push(NavigationService.navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => widget));
  }
  static back() {
    return Navigator.pop(NavigationService.navigatorKey.currentContext!);
  }


}