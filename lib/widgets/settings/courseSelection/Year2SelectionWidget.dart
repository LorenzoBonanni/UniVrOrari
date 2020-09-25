import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:school_timetable/screens/CourseSelectionScreen.dart';
import 'package:school_timetable/utils/DataGetter.dart';
import 'package:school_timetable/utils/SettingUtils.dart';

class Year2SelectionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new Year2SelectionWidgetState();
  }
}

class Year2SelectionWidgetState extends State<Year2SelectionWidget> {
  String _hint = "select value";
  String _disabledHint = "disabled";
  var _year2s;
  List<DropdownMenuItem<String>> _items = [];

  createItems(courseCode, yearCode) async {
    var courses = await DataGetter.getCourses(yearCode);
    setState(() {
      _items = [];
    });
    var courseArr = courses.where((c) => c[1] == courseCode).toList()[0];
    var year2Arr = courseArr[2];
    List<DropdownMenuItem<String>> items = [];
    year2Arr.forEach((year2Map) {
      items.add(
        new DropdownMenuItem<String>(
          value: year2Map["label"],
          child: new Text(year2Map["label"],
              style: new TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).textTheme.display1.color
              )
          ),
        ),
      );
    });
    setState(() {
      _items = items;
    });
  }

  void valueChanged(String year2Label) {
    var year2Map = _year2s.where((y2) => y2["label"] == year2Label).toList()[0];
    SettingUtils.setData("anno2", year2Map["valore"]);
    SettingUtils.setData("txt_curr", year2Label);
    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CourseSelectionScreen()));
  }

  @override
  void initState() {
    SettingUtils.getData("anno").then((yearCode) {
      if (yearCode != null) {
        DataGetter.getCourses(yearCode).then((courses) async {
          // set hint to currently setted value
          var courseCode = await SettingUtils.getData("corso");
          if(courseCode != null) {
            var year2Code = await SettingUtils.getData("anno2");
            var courseArr = courses.where((c) => c[1] == courseCode).toList()[0];
            var year2Arr = courseArr[2];
            setState(() {
              _year2s = year2Arr;
            });

            // set hint to current value
            if (year2Code != null){
              var year2Map = year2Arr.where((y2) => y2["valore"] == year2Code).toList()[0];
              setState(() {
                _hint =  year2Map["label"];
              });
            }
            createItems(courseCode, yearCode);
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color disabledColor = Theme.of(context)
        .buttonTheme
        .getDisabledFillColor(new MaterialButton(onPressed: null));

    return Column(
      children: <Widget>[
        Text(
          "Anno di Studio ",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.display1.color),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: new DropdownButton<String>(
                items: this._items,
                hint: new Text(
                  _hint,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.display1.color,
                  ),
                ),
                disabledHint: new Text(
                  _disabledHint,
                  style: TextStyle(
                    color: disabledColor,
                  ),
                ),
                onChanged: valueChanged
            )
        ),
      ],
    );
  }
}
