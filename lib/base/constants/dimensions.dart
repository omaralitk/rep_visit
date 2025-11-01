import 'package:flutter/widgets.dart';

class Dimensions {
  static double fullWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double fullHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isTablet(BuildContext context) {
    return fullWidth(context) > 700 ? true : false;
  }
}
