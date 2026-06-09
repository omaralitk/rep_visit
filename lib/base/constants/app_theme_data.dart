import 'package:flutter/material.dart';

class AppThemeData {


  static ThemeData theme() {

    return ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: Colors.white,
      fontFamily:"Manrope",
      visualDensity: VisualDensity.adaptivePlatformDensity,

    );
  }

}
