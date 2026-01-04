import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:rep_visit/core/navigation_service/navigation_service.dart';
import '../../cach/cach_manager.dart';

class NetworkConstants {
  static Future<String> getToken() async {
    return await UserCache.getToken();
  }

  static Future<String> getCurrentLang() async {
    final context = NavigationService.navigatorKey.currentContext;

    if (context != null) {
      return Localizations.localeOf(context).languageCode;
    }

    /// fallback language
    return 'en';
  }

  static Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    final lang = await getCurrentLang();

    return {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'lang': lang=="ar"?"2":"1",
    };
  }
}
