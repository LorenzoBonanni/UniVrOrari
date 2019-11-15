import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SettingUtils {
  static Future<String> getData(key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);
    return value;
  }

  static setData(key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    return value;
  }

  static Future<String> setSetted(value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("setted", value);
    return "done";
  }

  static Future<bool> getIsSet() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool('setted') ?? false;
    return value;
  }
}