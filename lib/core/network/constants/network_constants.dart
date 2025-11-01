import 'dart:developer';

import '../../cach/cach_manager.dart';


class NetworkConstants {
  static Future<String> getToken() async {
    final token = await UserCache.getToken();
    return token;
  }
  static final headers = {
    'accept': '*/*',
    'Content-type': 'application/json',
    'Authorization': 'Bearer ${getToken()}',

  };
  static Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'accept': '*/*',
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
      // 'lang': 'en'
    };
  }


}