import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:school_timetable/screens/CourseSelectionScreen.dart';
import 'package:school_timetable/utils/DataGetter.dart';
import 'package:school_timetable/utils/SettingUtils.dart';

class YearSelectionWidget extends StatefulWidget {
  @override
  _YearSelectionWidgetState createState() => _YearSelectionWidgetState();
}

class _YearSelectionWidgetState extends State<YearSelectionWidget> {
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
    this._years.forEach((year) => {
          setState(() {
            this._items.add(
                  new DropdownMenuItem<String>(
                    value: year[0],
                    child: new Text(year[0],
                        style: TextStyle(
                            color: Theme.of(context).textTheme.display1.color
                        ),
                    ),
                  ),
                );
          })
        });
  }

  valueChanged(value) {
    createItems().whenComplete(() {
      // get the array containing year code and label
      var yearArr = _years.where((y) => y[0] == value).toList()[0];
      SettingUtils.setData("corso", null);
      SettingUtils.setData("anno", yearArr[1]);
    });
    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CourseSelectionScreen()));
  }

  @override
  void initState() {
    SettingUtils.getData("anno").then((yearCode) {
      if (yearCode != null) {
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
              color: Theme.of(context).textTheme.display1.color
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: new DropdownButton<String>(
              items: this._items,
              hint: new Text(
                _hint,
                style: TextStyle(
                    color: Theme.of(context).textTheme.display1.color
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
