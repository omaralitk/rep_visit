import 'package:shared_preferences/shared_preferences.dart';

class UserCache {
  // Keys
  static const String _keyIsLogin = "is_login";
  static const String _keyOnBoarding = "on_boarding";
  static const String _keyToken = "token";

  /// -------------------- SET METHODS --------------------
  static Future<void> setIsLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLogin, value);
  }

  static Future<void> setOnBoarding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnBoarding, value);
  }
  static Future<void> setToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, value);
  }

  /// -------------------- GET METHODS --------------------
  static Future<bool> getIsLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLogin) ?? false;
  }

  static Future<bool> getOnBoarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnBoarding) ?? false;
  }
  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken) ??"";
  }

  /// -------------------- CLEAR METHODS --------------------
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> clearIsLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLogin);
  }

  static Future<void> clearOnBoarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyOnBoarding);
  }
}
