import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:school_timetable/screens/SettingScreen.dart';
import 'package:school_timetable/tabs/WeekView.dart';
import 'package:school_timetable/tabs/DayView.dart';
import 'package:school_timetable/utils/DataGetter.dart';
import 'package:school_timetable/utils/FadeRoute.dart';
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

class MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  static var _lessons;
  static DateTime _now;
  static String _firstDay;
  static String _lastDay;
  static var _dayWidget;
  static var _weekWidget;
  ScrollController _scrollViewController;
  TabController _tabController;
  var _tabsTitle;
  bool _changeTab = false;

  MainScreenState([now, changeTab]) {
    _dayWidget = null;
    _weekWidget = null;
    if (now != null) {
      _now = now;
      _changeTab = changeTab;
    }
  }

  initState() {
    super.initState();
    if (_now == null) {
      _now = new DateTime.now();
    }

    while (DateFormat('EEEE').format(_now) == "Sunday" ||
        DateFormat('EEEE').format(_now) == "Saturday")
      _now = _now.add(new Duration(days: 1));

    MainScreenState.updateTimetable().then((_) {
      setState(() {
        _dayWidget = new DayView(_firstDay, _lessons, _now);
        _weekWidget = new WeekView(_firstDay, _lastDay, _lessons);
      });
    });
    _scrollViewController = new ScrollController();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(_handleSelected);
    if (_changeTab) {
      _tabController.animateTo(1);
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
        _weekWidget = new WeekView(_firstDay, _lastDay, _lessons);
      });
    });
    changePage(true);
  }

  prevWeek() async {
    _now = _now.subtract(new Duration(days: 7));
    updateTimetable().then((_) {
      setState(() {
        _weekWidget = new WeekView(_firstDay, _lastDay, _lessons);
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
        nomeGiorni[dayDifference] + " " + new DateFormat("dd-MM-yyyy").format(_now),
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

  getDayButtons() {
    return new ButtonBar(
      alignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          child: new Text('PREV DAY'),
          onPressed: () {
            prevDay();
          },
          textColor: Theme.of(context).buttonColor,
        ),
        FlatButton(
          child: new Text('NEXT DAY'),
          onPressed: () {
            this.nextDay();
            changePage(false);
          },
          textColor: Theme.of(context).buttonColor,
        ),
      ],
    );
  }

  getWeekButtons() {
    return new ButtonBar(
      alignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          child: new Text(
            'PREV WEEK',
          ),
          onPressed: () {
            prevWeek();
          },
        ),
        FlatButton(
          child: new Text(
            'NEXT WEEK',
          ),
          onPressed: () {
            nextWeek();
          },
        ),
      ],
    );
  }

  void _handleSelected() {
    if (_tabController.index == 0) {
      setState(() {
        _tabsTitle = getDayTitle();
      });
    } else {
      setState(() {
        _tabsTitle = getWeekTitle();
      });
    }
  }

  void changePage(changeTab) {
    Navigator.push(
      context,
      FadeRoute(builder: (context) => MainScreen(_now, changeTab)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController.index == 0) {
      _firstDay != null
          ? _tabsTitle = getDayTitle()
          : _tabsTitle = new Text("");
    } else {
      setState(() {
        _firstDay != null
            ? _tabsTitle = getWeekTitle()
            : _tabsTitle = new Text("");
      });
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
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(FontAwesomeIcons.calendarDay),
                    text: "Day",
                  ),
                  Tab(icon: Icon(FontAwesomeIcons.calendarWeek), text: "Week"),
                ],
                controller: _tabController,
              ),
              actions: <Widget>[
                IconButton(
                  icon: new Icon(Icons.settings),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  ),
                ),
              ],
            )
          ];
        },
        body: new TabBarView(
          // getDayButtons
          children: [
            _dayWidget != null
                ? new SingleChildScrollView(
                    child: new Column(children: <Widget>[
                      _dayWidget,
                      getDayButtons(),
                    ]),
                  )
                : Loading(),
            _weekWidget != null
                ? new SingleChildScrollView(
                    child: new Column(children: <Widget>[
                      _weekWidget,
                      getWeekButtons(),
                    ]),
                  )
                : Loading(),
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}

// TODO: dark mode
// TODO: swipe right -> next day/week
// TODO: swipe left -> prev day/week
// TODO: lezioni passate in grigio
// TODO: aule libere
// TODO: filtro lezioni
