import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:school_timetable/screens/CourseSelectionScreenExtra.dart';
import 'package:school_timetable/utils/DataGetter.dart';
import 'package:school_timetable/utils/SettingUtils.dart';

class CourseSelectionWidgetExtra extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CourseSelectionWidgetStateExtra();
  }
}

class CourseSelectionWidgetStateExtra extends State<CourseSelectionWidgetExtra> {
  String _hint = "select value";
  String _disabledHint = "disabled";
  var _courses;
  List<DropdownMenuItem<String>> _items = [];

  createItems(year) async {
    List<DropdownMenuItem<String>> items = [];
    this._courses.forEach((course) {
      items.add(
        new DropdownMenuItem<String>(
          value: course[0],
          child: new Text(
            course[0],
            style: new TextStyle(
                fontSize: 10,
                color: Theme.of(context).textTheme.headline4!.color
            ),
          ),
        ),
      );
    });
    setState(() {
      _items = items;
    });
  }

  valueChanged(yearLabel) {
    var yearArr = _courses.where((c) => c[0] == yearLabel).toList()[0];
    SettingUtils.setData("corsoExtra", yearArr[1]);
    SettingUtils.setData("anno2Extra", null);
    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CourseSelectionScreenExtra()));
  }

  @override
  void initState() {
    SettingUtils.getData("annoExtra").then((yearCode) {
      if (yearCode != null) {
        DataGetter.getCourses(yearCode).then((courses) async {
          // set courses
          setState(() {
            _courses = courses;
          });
          createItems(yearCode);

          // set hint to currently setted value
          var courseCode = await SettingUtils.getData("corsoExtra");
          if(courseCode != null) {
            var courseArr = courses.where((c) => c[1] == courseCode).toList()[0];
            setState(() {
              _hint = courseArr[0];
            });
          }

        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color disabledColor = Theme.of(context).buttonTheme.getDisabledFillColor(
        new MaterialButton(onPressed: null)
    );

    return Column(
      children: <Widget>[
        Text(
          "Nome Corso",
          style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.headline4!.color),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: new DropdownButton<String>(
            isExpanded: true,
            items: _items,
            hint: new Text(
              _hint,
              style: TextStyle(
                color: Theme.of(context).textTheme.headline4!.color,
              ),
            ),
            disabledHint: new Text(
              _disabledHint,
              style: TextStyle(
                color: disabledColor,
              ),
            ),
            onChanged: valueChanged,
          ),
        ),
      ],
    );
  }
}
