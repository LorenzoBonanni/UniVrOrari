import 'dart:convert';
import 'package:http/http.dart';
import 'package:school_timetable/utils/SettingUtils.dart'; // Contains a client for making API calls

class DataGetter{

  static Future<String> _getUrl(String endpoint, date) async {
    String year = await SettingUtils.getData("anno");
    String course = await SettingUtils.getData("corso");
    String year2 = await SettingUtils.getData("anno2");
    String txtcurr = await SettingUtils.getData("txtcurr");
    String url = "https://orariserver.azurewebsites.net$endpoint?anno=$year&corso=$course&anno2=$year2&date=$date&txtcurr=$txtcurr";
    return url;
  }

  static Future<String> _getUrlExtra(String endpoint, date) async {
    String year = await SettingUtils.getData("annoExtra");
    String course = await SettingUtils.getData("corsoExtra");
    String year2 = await SettingUtils.getData("anno2Extra");
    String txtcurr = await SettingUtils.getData("txtcurrExtra");
    String url = "https://orariserver.azurewebsites.net$endpoint?anno=$year&corso=$course&anno2=$year2&date=$date&txtcurr=$txtcurr";
    return url;
  }

  static Future getTimetable(date) async {
    String url = await _getUrl("/", date);
    var client = Client();
    Response response = await client.get(url);
    return jsonDecode(response.body);
  }

  static Future getTimetableExtra(date) async {
    String url = await _getUrlExtra("/", date);
    var client = Client();
    Response response = await client.get(url);
    return jsonDecode(response.body);
  }

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

  static Future getCampuses() async {
    final url = "https://logistica.univr.it/PortaleStudentiUnivr/combo_call.php?sw=rooms_";
    var client = Client();
    // https://regex101.com/r/FdF8U9/1
    RegExp regExp = new RegExp(r'var elenco_sedi = (\[{.+}\])');
    Response response = await client.get(url);
    // apply regex and select only array
    return jsonDecode(regExp.firstMatch(response.body).group(1));
  }

  static Future getEmptyRooms(String id) async {
    var url = "http://progetti.altervista.org/orari/aule.php" + "?id=" + id;
    var client = Client();
    Response response = await client.get(url);
    return jsonDecode(response.body);
  }

  static Future getSubjects(date) async{
    String url = await _getUrl("/subjects", date);
    String urlExtra = await _getUrlExtra("/subjects", date);
    var client = Client();
    Response response = await client.get(url);
    Response responseExtra = await client.get(urlExtra);
    return [
      jsonDecode(response.body),
      jsonDecode(responseExtra.body)
    ];
  }
}
