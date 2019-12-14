import 'package:flutter/material.dart';
import 'package:school_timetable/screens/MainScreen.dart';
import 'package:school_timetable/utils/SettingUtils.dart';
import 'package:school_timetable/widgets/settings/courseSelection/CourseSelectionWidget.dart';
import 'package:school_timetable/widgets/settings/courseSelection/Year2SelectionWidget.dart';
import 'package:school_timetable/widgets/settings/courseSelection/YearSelectionWidget.dart';

class CourseSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SettingUtils.setSetted(false);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Course Selection"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new YearSelectionWidget(),
            new CourseSelectionWidget(),
            new Year2SelectionWidget(),
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
                  SettingUtils.setSetted(true);
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
