import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_timetable/blocs/theme.dart';
import 'package:school_timetable/screens/MainScreen.dart';
import 'package:school_timetable/themes/darkTheme.dart';
import 'package:school_timetable/themes/lightTheme.dart';
import 'package:school_timetable/utils/SettingUtils.dart';
import 'package:school_timetable/widgets/Loading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

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
     if (value != "") {
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
            create: (_) => ThemeChanger(_theme),
            child: new MyAppWithTheme(),
          )
        : new MaterialApp(home: Loading());
  }
}

class MyAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
      title: "Univr Orari",
      theme: theme.getTheme(),
    );
  }
}