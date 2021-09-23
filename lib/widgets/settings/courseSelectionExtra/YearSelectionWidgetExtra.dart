import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:school_timetable/screens/CourseSelectionScreenExtra.dart';
import 'package:school_timetable/utils/DataGetter.dart';
import 'package:school_timetable/utils/SettingUtils.dart';

class YearSelectionWidgetExtra extends StatefulWidget {
  @override
  _YearSelectionWidgetStateExtra createState() => _YearSelectionWidgetStateExtra();
}

class _YearSelectionWidgetStateExtra extends State<YearSelectionWidgetExtra> {
  String _hint = "select value";
  String _disabledHint = "disabled";
  var _years;
  List<DropdownMenuItem<String>> _items = [];

  createItems() async {
    var years = await DataGetter.getYears();
    setState(() {
      _items = [];
      _years = years;
    });
    List<DropdownMenuItem<String>> items = [];
    this._years.forEach((year) => {
    items.add(
      new DropdownMenuItem<String>(
        value: year[0],
        child: new Text(
          year[0],
          style: TextStyle(
            color: Theme.of(context).textTheme.headline4!.color
          ),
        ),
      ),
    )
    });
    setState(() {
      _items = items;
    });
  }

  valueChanged(value) {
    createItems().whenComplete(() {
      // get the array containing year code and label
      var yearArr = _years.where((y) => y[0] == value).toList()[0];
      SettingUtils.setData("corsoExtra", null);
      SettingUtils.setData("annoExtra", yearArr[1]);
    });
    Navigator.push(context, PageTransition(
        type: PageTransitionType.fade,
        child: CourseSelectionScreenExtra())
    );
  }

  @override
  void initState() {
    SettingUtils.getData("annoExtra").then((yearCode) {
      if (yearCode != "") {
        createItems().then((_) {
          // get the array containing year code and label
          var yearArr = _years.where((y) => y[1] == yearCode).toList()[0];
          setState(() {
            _hint = yearArr[0];
          });
        });
      }
      else {
        createItems();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color disabledColor = Theme.of(context).buttonTheme.getDisabledFillColor(
        new MaterialButton(onPressed: null)
    );

    return new Column(
      children: <Widget>[
        Text(
          "Anno Accademico",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.headline4!.color
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: new DropdownButton<String>(
              items: this._items,
              hint: new Text(
                _hint,
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline4!.color
                ),
              ),
              disabledHint: new Text(
                _disabledHint,
                style: TextStyle(
                  color: disabledColor,
                ),
              ),
              onChanged: valueChanged
          ),
        ),
      ],
    );
  }
}
