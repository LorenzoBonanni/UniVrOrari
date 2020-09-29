import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_timetable/blocs/theme.dart';
import 'package:school_timetable/screens/CampusesSelectionScreen.dart';
import 'package:school_timetable/screens/CourseSelectionScreen.dart';
import 'package:school_timetable/screens/SubjectSelectionScreen.dart';
import 'package:school_timetable/themes/darkTheme.dart';
import 'package:school_timetable/themes/lightTheme.dart';
import 'package:school_timetable/utils/SettingUtils.dart';


//TODO make responsive
class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsScreenState();
  }
}

class SettingsScreenState extends State<SettingsScreen> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    SettingUtils.getData("darktheme").then((value) {
      setState(() {
        _value = value.toLowerCase() == "true";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Impostazioni"),
          centerTitle: true,
        ),
        body: new ListView(
          children: <Widget>[
            new FlatButton(
              child: new Text(
                "CAMBIA CORSO",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseSelectionScreen(),
                  ),
                );
              },
            ),
            new FlatButton(
              child: new Text(
                "FILTRA LEZIONI",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubjectSelectionScreen(),
                  ),
                );
              },
            ),
            // new FlatButton(
            //   child: new Text(
            //     "CAMBIA POLI",
            //     style: TextStyle(color: Colors.green),
            //   ),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => CampusesSelectionScreen(),
            //       ),
            //     );
            //   },
            // ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "DARKMODE",
                  style: TextStyle(color: Colors.green),
                ),
                Center(
                  child: new Switch(
                    value: _value,
                    onChanged: (bool value) {
                      final theme = Provider.of<ThemeChanger>(context);
                      setState(() {
                        _value = value;
                      });
                      if (value) {
                        theme.setTheme(darkTheme());
                        SettingUtils.setData("darktheme", "True");
                      } else {
                        theme.setTheme(lightTheme());
                        SettingUtils.setData("darktheme", "False");
                      }
                    },
                    activeColor: Theme.of(context).buttonColor,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
