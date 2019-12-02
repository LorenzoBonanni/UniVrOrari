import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SettingUtils {
  static Set<String> _selectedCampuses = Set();

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

  static Future<bool> setSetted(value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool("setted", value);
  }

  static Future<bool> getIsSet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('setted');
  }

  static setCampusList(String value) async {
    _selectedCampuses.add(value);
  }

  static Future<List<String>> getCampusList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("campuses");
  }

  static updateCampusList() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setStringList("campuses", _selectedCampuses.toList());
  }

  static resetCampusList() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setStringList("campuses", []);
  }
}