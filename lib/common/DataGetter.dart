import 'dart:convert';

import 'package:http/http.dart';
import 'package:school_timetable/common/SettingUtils.dart'; // Contains a client for making API calls

class DataGetter{
  static Future getYears() async {
    var client = Client();
    Response response = await client.get(
        "http://westcost0.altervista.org/orari/api.php?w=getyears"
    );
    return jsonDecode(response.body);
  }

  static Future getCourses(var year) async {
    var client = Client();
    Response response = await client.get(
        "http://westcost0.altervista.org/orari/api.php?w=getcourses&year=$year"
    );

    return jsonDecode(response.body);
  }

  static Future getTimetable(date) async {
    String year = await SettingUtils.getData("anno");
    String course = await SettingUtils.getData("corso");
    String year2 = await SettingUtils.getData("anno2");
    String txtcurr = await SettingUtils.getData("txtcurr");
    var client = Client();
    Response response = await client.get(
        "http://progetti.altervista.org/orari/api.php?anno=$year&corso=$course&anno2=$year2&date=$date&txtcurr=$txtcurr"
    );

    return jsonDecode(response.body);
  }

}
