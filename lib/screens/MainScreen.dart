import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:school_timetable/screens/SettingScreen.dart';
import 'package:school_timetable/views/EmptyRoomsView.dart';
import 'package:school_timetable/views/WeekView.dart';
import 'package:school_timetable/views/DayView.dart';
import 'package:school_timetable/utils/DataGetter.dart';
import 'package:school_timetable/widgets/Loading.dart';


class MainScreen extends StatefulWidget {
  var _now;
  bool _changeTab = false;

  MainScreen([this._now, this._changeTab]);

  @override
  State<StatefulWidget> createState() {
    if (_now != null) {
      return new MainScreenState(_now, _changeTab);
    } else {
      return new MainScreenState();
    }
  }
}

class MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  static var _lessons;
  static DateTime _now;
  static String _firstDay;
  static String _lastDay;
  static var _dayWidget;
  static var _weekWidget;
  bool _isVisible = true;
  ScrollController _scrollViewController;
  Text _tabsTitle;
  bool _changeTab = false;
  int _index = 0;
  Widget _widget;

  MainScreenState([now, changeTab]) {
    _dayWidget = null;
    _weekWidget = null;
    if (now != null) {
      _now = now;
      _changeTab = changeTab;
    }
  }

  // retrieve data and update timetable variables
  static updateTimetable() async {
    var date = new DateFormat("dd-MM-yyyy").format(_now);
    var timetable = await DataGetter.getTimetable(date);
    _lessons = timetable["lezioni"];
    _firstDay = timetable["first_day"];
    _lastDay = timetable["last_day"];
    return "";
  }

  nextDay() {
    // if weekend skip to monday
    do {
      _now = _now.add(new Duration(days: 1));
    } while (DateFormat('EEEE').format(_now) == "Sunday" ||
        DateFormat('EEEE').format(_now) == "Saturday");

    updateTimetable().then((_) {
      setState(() {
        _dayWidget = new DayView(_firstDay, _lessons, _now);
      });
    });
    changePage(false);
  }

  prevDay() {
    // if weekend skip to friday
    do {
      _now = _now.subtract(new Duration(days: 1));
    } while (DateFormat('EEEE').format(_now) == "Sunday" ||
        DateFormat('EEEE').format(_now) == "Saturday");

    MainScreenState.updateTimetable().then((_) {
      setState(() {
        _dayWidget = new DayView(_firstDay, _lessons, _now);
      });
    });
    changePage(false);
  }

  nextWeek() {
    _now = _now.add(new Duration(days: 7));
    updateTimetable().then((_) {
      setState(() {
        _weekWidget = new WeekView(_lessons, _now);
      });
    });
    changePage(true);
  }

  prevWeek() async {
    _now = _now.subtract(new Duration(days: 7));
    updateTimetable().then((_) {
      setState(() {
        _weekWidget = new WeekView(_lessons, _now);
      });
    });
    changePage(true);
  }

  static getDayTitle() {
    final nomeGiorni = ["Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì"];
    List<String> splittedFirstDay = _firstDay.split("/");
    DateTime firstDay = DateTime(
      int.parse(splittedFirstDay[2]),
      int.parse(splittedFirstDay[1]),
      int.parse(splittedFirstDay[0]),
    );
    // days between first day and now
    var dayDifference = _now.difference(firstDay).inDays;

    // day title
    if (dayDifference <= 4 && dayDifference >= 0) {
      return new Text(
        nomeGiorni[dayDifference] +
            " " +
            new DateFormat("dd-MM-yyyy").format(_now),
      );
    } else {
      return new Text("");
    }
  }

  static getWeekTitle() {
    return new Text(
      _firstDay + " - " + _lastDay,
    );
  }

  void _handleSelected(index) {
    if (index == 0) {
      setState(() {
        _index = 0;
      });
    } else if (index == 1) {
      setState(() {
        _index = 1;
      });
    } else if (index == 2) {
      setState(() {
        _index = 2;
      });
    }
  }


  void changePage(bool changeTab) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: MainScreen(_now, changeTab)
        )
    );
  }


  void setupScroll() {
    _scrollViewController = new ScrollController();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
        });
      }
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  initState() {
    setupScroll();
    if (_changeTab) {
      _index = 1;
    }

    // if now isn't set it
    if (_now == null) {
      _now = new DateTime.now();
    }

    // if the date is weekend go to monday
    while (
        DateFormat('EEEE').format(_now) == "Sunday" ||
        DateFormat('EEEE').format(_now) == "Saturday"
    ) {
      _now = _now.add(new Duration(days: 1));
    }

    // set DayView and WeekView widgets
    MainScreenState.updateTimetable().then((_) {
      setState(() {
        _dayWidget = new DayView(_firstDay, _lessons, _now);
        _weekWidget = new WeekView( _lessons, _now);
      });
    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch(_index){
      case 0:
        Widget dayView = GestureDetector(
          child: new SingleChildScrollView(child: _dayWidget),
          onPanUpdate: (details) {
            if (details.delta.dx > 0) {
              prevDay();
            } else {
              nextDay();
            }
          },
        );
        setState(() {
          _widget = null;
          _tabsTitle = _firstDay != null ? getDayTitle() : new Text("");
          _widget = _dayWidget != null ? dayView : Loading();
        });
        break;

      case 1:
        Widget weekView = GestureDetector(
          child: new SingleChildScrollView(child: _weekWidget),
          onPanUpdate: (details) {
            if (details.delta.dx > 0) {
              prevWeek();
            } else {
              nextWeek();
            }
          },
        );

        setState(() {
          _tabsTitle = _firstDay != null ? getWeekTitle() : new Text("");
          _widget = _weekWidget != null ? weekView : Loading();
        });
        break;

      case 2:
        setState(() {
          _tabsTitle = new Text("Aule Libere");
          _widget = new EmptyRoomsView();
        });
        break;
    }

    return new Scaffold(
      body: new NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: _firstDay != null ? _tabsTitle : new Text(""),
              forceElevated: innerBoxIsScrolled,
              actions: <Widget>[
                IconButton(
                  icon: new Icon(
                    Icons.settings,
                    // color: Theme.of(context).appBarTheme.textTheme.title.color,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  ),
                ),
              ],
            )
          ];
        },
        body: _widget != null ? _widget : Loading()
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: _isVisible ? 56.0 : 0.0,
        child: Wrap(
          children: <Widget>[
            new BottomNavigationBar(
              onTap: _handleSelected,
              type: BottomNavigationBarType.fixed,
              items: [
                new BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.calendarDay),
                  title: Text('Day'),
                ),
                new BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.calendarWeek),
                  title: Text('Week'),
                ),
                new BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.doorOpen),
                  title: Text('Aule Libere'),
                )
              ],
              currentIndex: _index,
              selectedItemColor: Theme.of(context).iconTheme.color,
              unselectedItemColor: Theme.of(context).iconTheme.color,
              unselectedIconTheme: IconThemeData(
                color: Theme.of(context).iconTheme.color.withAlpha(100),
              ),
              unselectedLabelStyle: TextStyle(
                color: Theme.of(context).iconTheme.color.withAlpha(100),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// TODO: filtro lezioni
