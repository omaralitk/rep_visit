import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LangService{
  static void changeLang(BuildContext context) {
    final currentLocale = context.locale;

    if (currentLocale.languageCode == 'en') {
      context.setLocale(const Locale('ar'));
    } else {
      context.setLocale(const Locale('en'));
    }
  }
}