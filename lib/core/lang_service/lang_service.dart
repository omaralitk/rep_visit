import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rep_visit/core/navigation_service/navigation_service.dart';
import 'package:rep_visit/screens/splash_screen/ui/splash_screen.dart';

class LangService{
  static void changeLang(BuildContext context) {
    final currentLocale = context.locale;

    if (currentLocale.languageCode == 'en') {
      NavigationService.pushAndRemoveUntil(const SplashScreen());
      context.setLocale(const Locale('ar'));

    } else {
      NavigationService.pushAndRemoveUntil(const SplashScreen());
      context.setLocale(const Locale('en'));


    }
  }
}