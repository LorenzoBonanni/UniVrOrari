import 'package:flutter/material.dart';
import 'package:school_timetable/App.dart';
import 'package:school_timetable/common/DataGetter.dart';
import 'package:school_timetable/common/SettingUtils.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SettingsState();
  }
}

class SettingsState extends State<Settings> {
  String hint = "select value";
  String disabledHint = "disabled";
  String _selectedYear = "";
  String _selectedCourse = "";
  String _selectedYear2 = "";
  var _years;
  var _courses;
  var _year2map = [];
  List<DropdownMenuItem<String>> _yearsItems = [];
  List<DropdownMenuItem<String>> _coursesItems = [];
  List<DropdownMenuItem<String>> _year2Items = [];

  @override
  void initState() {
    super.initState();
    createYearsItems();
    checkSettings();
  }

  //  check if all settings are setted
  checkSettings() {
    SettingUtils.getIsSet().then((value) {
      if (value == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => App()),
        );
      }
    });
  }

  createYearsItems() async {
    this._years = await DataGetter.getYears();
    setState(() {
      this._yearsItems = [];
    });
    this._years.forEach((year) => {
          setState(() {
            this._yearsItems.add(
                  new DropdownMenuItem<String>(
                      value: year[1], child: new Text(year[0])),
                );
          })
        });
  }

  createCoursesItems(year) async {
    this._courses = await DataGetter.getCourses(year);
    setState(() {
      this._coursesItems = [];
    });
    this._courses.forEach((course) => {
          setState(() {
            this._coursesItems.add(
                  new DropdownMenuItem<String>(
                    value: course[1],
                    child: new SizedBox(
                      width: 300.0,
                      child: new Text(
                        course[0],
                        style: new TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                );
          })
        });
  }

  createYear2Items(selCourse) async {
    setState(() {
      this._year2Items = [];
    });
    this._courses.forEach((course) => {
          if (course[1] == selCourse)
            {
              setState(() {
                this._year2map = course[2];
                course[2].forEach((year2) => {
                      this._year2Items.add(
                            new DropdownMenuItem<String>(
                              value: year2["valore"],
                              child: new Text(
                                year2["label"],
                                style: new TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                    });
              })
            }
        });
  }

  // given year2 find correspondent label
  getTxtCurr(year2Value) {
    this._year2map.forEach((year2arr) {
      if (year2arr["valore"] == year2Value) {
        setState(() {
          this._selectedYear2 = year2arr["label"];
        });
        SettingUtils.setData("txt_curr", year2arr["label"]);
        SettingUtils.setSetted(true).then((val) {
          checkSettings();
        });
      }
    });
  }

  // given value return correspondent label
  getYearLabel(value) {
    this._years.forEach((yearArr) {
      if (yearArr[1] == value) {
        this._selectedYear = yearArr[0];
      }
    });
  }

  // given value return correspondent label
  getCourseLabel(value) {
    this._courses.forEach((course) {
      if (course[1] == value) {
        this._selectedCourse = course[0];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Settings"), automaticallyImplyLeading: false),
      body: Center(
        child: new Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Center(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Anno Accademico: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(this._selectedYear)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new DropdownButton<String>(
                    items: this._yearsItems,
                    hint: new Text(
                      hint,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    disabledHint: new Text(
                      disabledHint,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    onChanged: (value) {
                      this.getYearLabel(value);
                      SettingUtils.setData("anno", value);
                      this.createCoursesItems(value);
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Center(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Nome Corso: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(this._selectedCourse)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new DropdownButton<String>(
                    items: this._coursesItems,
                    hint: new Text(
                      hint,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    disabledHint: new Text(
                      disabledHint,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    onChanged: (value) {
                      getCourseLabel(value);
                      SettingUtils.setData("corso", value);
                      createYear2Items(value);
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Center(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Anno di Studio: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(this._selectedYear2)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new DropdownButton<String>(
                    items: this._year2Items,
                    hint: new Text(
                      hint,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    disabledHint: new Text(
                      disabledHint,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    onChanged: (value) {
                      SettingUtils.setData("anno2", value);
                      this.getTxtCurr(value);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
