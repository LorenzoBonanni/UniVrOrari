import 'package:flutter/material.dart';
import 'package:school_timetable/screens/MainScreen.dart';
import 'package:school_timetable/utils/DataGetter.dart';
import 'package:school_timetable/utils/SettingUtils.dart';

class CourseSelectionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CourseSelectionScreenState();
  }
}

class CourseSelectionScreenState extends State<CourseSelectionScreen> {
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
          MaterialPageRoute(builder: (context) => MainScreen()),
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
                    value: year[1],
                    child: new Text(
                      year[0],
                      style: TextStyle(
                          color: Theme.of(context).textTheme.display1.color),
                    ),
                  ),
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
                        style: new TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).textTheme.display1.color),
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
                                style: new TextStyle(
                                    fontSize: 10,
                                    color: Theme.of(context)
                                        .textTheme
                                        .display1
                                        .color),
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
        title: new Text("Course Selection"),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: new Column(
          children: <Widget>[
            buildColumn(),
            buildColumn2(),
            buildColumn3(),
          ],
        ),
      ),
    );
  }

  Column buildColumn3() {
    return Column(
      children: <Widget>[
        Center(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      "Anno di Studio: ",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.display1.color),
                    ),
                    Text(this._selectedYear2, style: TextStyle(color: Theme.of(context).textTheme.display1.color),)
                  ],
                ),
              ),
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
                color: Theme.of(context).textTheme.display1.color,
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
    );
  }

  Column buildColumn2() {
    return Column(
      children: <Widget>[
        Center(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      "Nome Corso: ",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.display1.color),
                    ),
                    Text(this._selectedCourse, style: TextStyle(color: Theme.of(context).textTheme.display1.color),)
                  ],
                ),
              ),
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
    );
  }

  Column buildColumn() {
    return Column(
      children: <Widget>[
        Center(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Text(
                      "Anno Accademico: ",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.display1.color),
                    ),
                    Text(this._selectedYear, style: TextStyle(color: Theme.of(context).textTheme.display1.color),)
                  ],
                ),
              ),
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
                color: Theme.of(context).textTheme.display1.color,
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
    );
  }
}
