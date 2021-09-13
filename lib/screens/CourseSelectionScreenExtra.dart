import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_timetable/screens/MainScreen.dart';
import 'package:school_timetable/utils/SettingUtils.dart';
import 'package:school_timetable/widgets/settings/courseSelectionExtra/CourseSelectionWidgetExtra.dart';
import 'package:school_timetable/widgets/settings/courseSelectionExtra/Year2SelectionWidgetExtra.dart';
import 'package:school_timetable/widgets/settings/courseSelectionExtra/YearSelectionWidgetExtra.dart';

class CourseSelectionScreenExtra extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SettingUtils.setSetted(false);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Selezione Corso di Studio Extra"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new YearSelectionWidgetExtra(),
            new CourseSelectionWidgetExtra(),
            new Year2SelectionWidgetExtra(),
            new FlatButton(
                onPressed: () {
                  SettingUtils.updateCampusList().then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      ),
                    );
                  });

                  SettingUtils.setData("lessons", json.encode({}));
                },
                child: new Text(
                  "FINE",
                  style: new TextStyle(color: Colors.green)
                )
            )
          ],
        ),
      ),
    );
  }
}
