import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_timetable/blocs/theme.dart';
import 'package:school_timetable/screens/MainScreen.dart';
import 'package:school_timetable/screens/SettingScreen.dart';
import 'package:school_timetable/themes/darkTheme.dart';
import 'package:school_timetable/themes/lightTheme.dart';
import 'package:school_timetable/utils/SettingUtils.dart';
import 'package:school_timetable/widgets/Loading.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  var _theme;

  void initState() {
    // check theme
    SettingUtils.getData("darktheme").then((value) {
     if (value != null) {
       bool v = value.toLowerCase() == "true";
       setState(() {
         _theme = v ? darkTheme() : lightTheme();
       });
     } else {
       SettingUtils.setData("darktheme", "False");
       setState(() {
         _theme = lightTheme();
       });
     }
    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _theme != null
        ? ChangeNotifierProvider<ThemeChanger>(
            builder: (_) => ThemeChanger(_theme),
            child: new MyAppWithTheme(),
          )
        : new MaterialApp(home: Loading());
  }
}

class MyAppWithTheme extends StatefulWidget {
  @override
  _MyAppWithThemeState createState() => _MyAppWithThemeState();
}

class _MyAppWithThemeState extends State<MyAppWithTheme> {
  Widget _home;

  @override
  void initState() {
    SettingUtils.getCampusList().then((campuses) async {
      bool isSet = await SettingUtils.getIsSet();
      if(isSet == null) {
        SettingUtils.setSetted(false);
      }
      setState(() {
        _home = (isSet == null || !isSet) && campuses != null ? MainScreen() : SettingsScreen();
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _home != null ? _home : Loading(),
      title: "Univr Orari",
      theme: theme.getTheme(),
    );
  }
}
