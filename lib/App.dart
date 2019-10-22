import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_timetable/Settings.dart';
import 'package:school_timetable/common/SettingUtils.dart';

import 'common/DataGetter.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AppState();
  }
}

class AppState extends State<App> {
  var _lessons;
  DateTime now;
  String selected = "Day";
  String _firstDay;
  String _lastDay;
  List<Widget> _lessonsWidget = [];
  final ScrollController _homeController = ScrollController();
  final _nomeGiorni = ["Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì"];

  initState() {
    super.initState();
    this.now = new DateTime.now();
    updateTimetable().then((_) {
      generateDayView();
    });
  }

  // retrieve data and update timetable variables
  updateTimetable() async {
    var date = new DateFormat("dd-MM-yyyy").format(this.now);
    var timetable = await DataGetter.getTimetable(date);
    this._lessons = timetable["lezioni"];
    this._firstDay = timetable["first_day"];
    this._lastDay = timetable["last_day"];
    return "";
  }

  // generate card widget based on parameters
  generateCard(lezione, docente, aula, inizio, fine) {
    return new Card(
      child: new Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 3.0),
            child: new Row(
              children: <Widget>[
                new Text("Lezione: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                new SizedBox(
                  child: new Text(lezione),
                  width: 300.0,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3.0),
            child: new Row(
              children: <Widget>[
                new Text("Docente: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                new Text(docente)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3.0),
            child: new Row(
              children: <Widget>[
                new Text("Aula: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                new SizedBox(
                  child: new Text(aula),
                  width: 300.0,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3.0),
            child: new Row(
              children: <Widget>[
                new Text("Inizio: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                new Text(inizio)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3.0),
            child: new Row(
              children: <Widget>[
                new Text("Fine: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                new Text(fine)
              ],
            ),
          ),
        ],
      ),
    );
  }

  // generate widgets to be viewed fow week view
  generateWeekView() {
    this._lessonsWidget = [];
    String giorno = "";

    setState(() {
      this._lessonsWidget.add(Text(this._firstDay + " - " + this._lastDay));
    });

    this._lessons.forEach((lesson) {
      String currGiorno = this._nomeGiorni[int.parse(lesson["giorno"]) - 1];
      if (giorno != currGiorno) {
        giorno = currGiorno;
        setState(() {
          this._lessonsWidget.add(new Text(currGiorno,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)));
        });
      }

      setState(() {
        this._lessonsWidget.add(
              generateCard(
                lesson["nome_insegnamento"],
                lesson["docente"],
                lesson["aula"],
                lesson["ora_inizio"],
                lesson["ora_fine"],
              ),
            );
      });
    });

    setState(() {
      this._lessonsWidget.add(new ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: const Text('PREV WEEK'),
                onPressed: () {
                  this.now = this.now.subtract(new Duration(days: 7));
                  this.updateTimetable().then((_) {
                    this.generateWeekView();
                    this.scrollBack();
                  });
                },
              ),
              FlatButton(
                child: const Text('NEXT WEEK'),
                onPressed: () {
                  this.now = this.now.add(new Duration(days: 7));
                  this.updateTimetable().then((_) {
                    this.generateWeekView();
                    this.scrollBack();
                  });
                },
              ),
            ],
          ));
    });
  }

  generateDayView() {
    setState(() {
      this._lessonsWidget = [];
    });
    List<String> splittedFirstDay = this._firstDay.split("/");
    var firstDay = DateTime(
      int.parse(splittedFirstDay[2]),
      int.parse(splittedFirstDay[1]),
      int.parse(splittedFirstDay[0]),
    );
    // days between first day and now
    var dayDifference = this.now.difference(firstDay).inDays;
    setState(() {
      this._lessonsWidget.add(
            new Text(
              this._nomeGiorni[dayDifference] + " " + new DateFormat("dd-MM-yyyy").format(this.now),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          );
    });
    this._lessons.forEach((lesson) {
      if (int.parse(lesson["giorno"]) == dayDifference + 1) {
        setState(() {
          this._lessonsWidget.add(
                generateCard(
                  lesson["nome_insegnamento"],
                  lesson["docente"],
                  lesson["aula"],
                  lesson["ora_inizio"],
                  lesson["ora_fine"],
                ),
              );
        });
      }
    });

    setState(() {
      this._lessonsWidget.add(new ButtonBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            child: const Text('PREV DAY'),
            onPressed: () {
              do {
                this.now = this.now.subtract(new Duration(days: 1));
              } while(DateFormat('EEEE').format(this.now) == "Sunday" || DateFormat('EEEE').format(this.now) == "Saturday");

              this.updateTimetable().then((_) {
                this.generateDayView();
              });
            },
          ),
          FlatButton(
            child: const Text('NEXT DAY'),
            onPressed: () {
              do {
                this.now = this.now.add(new Duration(days: 1));
              } while(DateFormat('EEEE').format(this.now) == "Sunday" || DateFormat('EEEE').format(this.now) == "Saturday");

              this.updateTimetable().then((_) {
                this.generateDayView();
              });
            },
          ),
        ],
      ));
    });
  }

  scrollBack() {
    this._homeController.animateTo(
          0.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 600),
        );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: new Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.blue,
            ),
            child: DropdownButtonHideUnderline(
              child: new DropdownButton(
                  value: this.selected,
                  items: <String>["Day", "Week"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: new TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != this.selected) {
                      this.now = new DateTime.now();
                      this.selected = value;
                      this.updateTimetable().then((_) {
                        if (value == "Week") {
                          this.generateWeekView();
                        } else {
                          this.generateDayView();
                        }
                      });
                    }
                  }),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: new Icon(Icons.settings),
              onPressed: () {
                SettingUtils.setSetted(false);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
              },
            ),
          ],
        ),
        body: new SingleChildScrollView(
          controller: this._homeController,
          child: new Column(
            children: this._lessonsWidget,
          ),
        ));
  }
}
