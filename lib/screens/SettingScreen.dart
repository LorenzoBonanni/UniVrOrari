import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_timetable/blocs/theme.dart';
import 'package:school_timetable/screens/CourseSelectionScreen.dart';
import 'package:school_timetable/screens/CourseSelectionScreenExtra.dart';
import 'package:school_timetable/screens/MainScreen.dart';
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
    return new Scaffold (
        appBar: new AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainScreen())
              );
            },
          ),
          title: new Text("Impostazioni"),
          centerTitle: true,
        ),
        body: new ListView(
          children: <Widget>[
            new TextButton(
              child: new Text(
                "CAMBIA CORSO",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseSelectionScreen(),
                  ),
                );
              },
            ),
            new TextButton(
              child: new Text(
                "CORSO EXTRA",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseSelectionScreenExtra(),
                  ),
                );
              },
            ),
            Builder(
                builder: (context) => new TextButton(
                  child: new Text(
                    "ELIMINA CORSO EXTRA",
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    SettingUtils.setData("annoExtra", "");
                    SettingUtils.setData("corsoExtra", "");
                    SettingUtils.setData("anno2Extra", "");
                    SettingUtils.setData("txt_currExtra", "");
                    SettingUtils.setData("lessons", json.encode({}));
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: new Text(
                              "Corso Extra Eliminato",
                              style: TextStyle(
                                  color: Theme.of(context).textTheme.headline4!.color
                              ),
                            ),
                          backgroundColor: Theme.of(context).backgroundColor,
                        )
                    );
                  },
                )
            ),
            new TextButton(
              child: new Text(
                "FILTRA LEZIONI",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubjectSelectionScreen(),
                  ),
                );
              },
            ),
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
