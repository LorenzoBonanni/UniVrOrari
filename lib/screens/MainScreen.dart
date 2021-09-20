import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:school_timetable/screens/CourseSelectionScreen.dart';
import 'package:school_timetable/screens/SettingScreen.dart';
import 'package:school_timetable/utils/SettingUtils.dart';
import 'package:school_timetable/views/WeekView.dart';
import 'package:school_timetable/views/DayView.dart';
import 'package:school_timetable/utils/DataGetter.dart';
import 'package:school_timetable/widgets/Loading.dart';

// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  final _now;
  bool _changeTab = false;

  MainScreen([this._now, _changeTab]);

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
  static DateTime? _now;
  static String? _firstDay;
  static String? _lastDay;
  static var _dayWidget;
  static var _weekWidget;
  bool _isVisible = true;
  ScrollController? _scrollViewController;
  Text? _tabsTitle;
  Widget? _widget;
  CircularBottomNavigationController _navigationController = new CircularBottomNavigationController(0);
  bool _changeTab = false;

  MainScreenState([now, changeTab]) {
    _dayWidget = null;
    _weekWidget = null;
    if (now != null) {
      _now = now;
      _changeTab = changeTab;
    }
  }

  static sortTimetable(List<dynamic> lezioni) {
    lezioni.sort((l1, l2) {
      l1 = l1["ora_inizio"].split(":");
      l2 = l2["ora_inizio"].split(":");
      var l1H = l1[0];
      var l1M = l1[1];
      var l2H = l2[0];
      var l2M = l2[1];
      var r = l1H.compareTo(l2H);
      if (r != 0)
        return r; // 0 -> equal
      else
        return l1M.compareTo(l2M);
    });
    return lezioni;
  }

  // retrieve data and update timetable variables
  static updateTimetable() async {
    var date = new DateFormat("dd-MM-yyyy").format(_now!);
    Map<String, dynamic> timetable = await DataGetter.getTimetable(date);
    Map<String, dynamic> timetableExtra = await DataGetter.getTimetableExtra(date);
    timetable["lezioni"].forEach((e) => e["extra"] = false);
    timetableExtra["lezioni"].forEach((e) => e["extra"] = true);
    List<dynamic> lezioni = timetable["lezioni"] + timetableExtra["lezioni"];
    lezioni = sortTimetable(lezioni);

    _lessons = lezioni;
    _firstDay = timetable["first_day"];
    _lastDay = timetable["last_day"];
    return [lezioni, timetable["first_day"], timetable["last_day"]];
  }

  createNewDayWidget() {
    updateTimetable().then(([lezioni, firstDay, lastDay]) {
      setState(() {
        _dayWidget = new DayView(firstDay, lezioni, _now);
      });
    });
    changePage(false);
  }

  createNewWeekWidget() {
    updateTimetable().then((_) {
      print("lezioni");
      print(_lessons);
      setState(() {
        _weekWidget = new WeekView(_lessons, _now);
      });
    });
    changePage(true);
  }

  nextDay() {
    // if weekend skip to monday
    do {
      _now = _now!.add(new Duration(days: 1));
    } while (DateFormat('EEEE').format(_now!) == "Sunday" ||
        DateFormat('EEEE').format(_now!) == "Saturday");
    createNewDayWidget();
  }

  prevDay() {
    // if weekend skip to friday
    do {
      _now = _now!.subtract(new Duration(days: 1));
    } while (DateFormat('EEEE').format(_now!) == "Sunday" ||
        DateFormat('EEEE').format(_now!) == "Saturday");
    createNewDayWidget();
  }

  nextWeek() {
    _now = _now!.add(new Duration(days: 7));
    createNewWeekWidget();
  }

  prevWeek() async {
    _now = _now!.subtract(new Duration(days: 7));
    createNewWeekWidget();
  }

  static getDayTitle() {
    final nomeGiorni = ["Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì"];
    List<String> splittedFirstDay = _firstDay!.split("/");
    DateTime firstDay = DateTime(
      int.parse(splittedFirstDay[2]),
      int.parse(splittedFirstDay[1]),
      int.parse(splittedFirstDay[0]),
    );
    // days between first day and now
    var dayDifference = _now!.difference(firstDay).inDays;

    // day title
    if (dayDifference <= 4 && dayDifference >= 0) {
      String text = nomeGiorni[dayDifference] +
          " " +
          new DateFormat("dd-MM-yyyy").format(_now!);
      return new Text(text, style: TextStyle(color: Colors.green));
    } else {
      return new Text("");
    }
  }

  static getWeekTitle() {
    return new Text(_firstDay! + " - " + _lastDay!,
        style: TextStyle(color: Colors.green));
  }

  void _handleSelected(index) {
    setState(() {
      _navigationController.value = index;
    });
  }

  void changePage(bool changeTab) {
    Navigator.pushReplacement(
      context,
      PageTransition(
          type: PageTransitionType.fade, child: MainScreen(_now, changeTab)),
    );
  }

  void setupScroll() {
    _scrollViewController = new ScrollController();
    _scrollViewController!.addListener(() {
      // if user scroll down hide
      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
        });
      }
      // if user scroll up show
      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  initState() {
    SettingUtils.getCampusList().then((campuses) async {
      bool isSet = await SettingUtils.getSetted();
      if (!isSet) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CourseSelectionScreen()),
        );
      }
    });

    setupScroll();
    if (_changeTab == true) {
      _navigationController.value = 1;
    }

    // if now isn't set it
    if (_now == null) {
      _now = new DateTime.now();
    }

    // if the date is weekend go to monday
    while (DateFormat('EEEE').format(_now!) == "Sunday" ||
        DateFormat('EEEE').format(_now!) == "Saturday") {
      _now = _now!.add(new Duration(days: 1));
    }

    // set DayView and WeekView widgets
    MainScreenState.updateTimetable().then((_) {
      print("firstDay:");
      print(_firstDay);
      setState(() {
        _dayWidget = new DayView(_firstDay!, _lessons, _now);
        _weekWidget = new WeekView(_lessons, _now);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (_navigationController.value) {
      case 0:
        Widget dayView = GestureDetector(
          child: _dayWidget,
          onPanUpdate: (details) {
            if (details.delta.dx > 0) {
              prevDay();
            } else {
              nextDay();
            }
          },
        );
        setState(() {
          _tabsTitle = _firstDay != null ? getDayTitle() : new Text("");
          _widget = _dayWidget != null ? dayView : Loading();
        });
        break;

      case 1:
        Widget weekView = GestureDetector(
          child: _weekWidget,
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

      // case 2:
      //   setState(() {
      //     _tabsTitle = new Text("Aule Libere");
      //     _widget = new EmptyRoomsView();
      //   });
      //   break;
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
              // forceElevated: innerBoxIsScrolled,
              actions: <Widget>[
                IconButton(
                  icon: new Icon(
                    Icons.settings,
                  ),
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  ),
                ),
              ],
            )
          ];
        },
        body: (_widget != null ? _widget : Loading()) as Widget,
      ),
      bottomNavigationBar: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: _isVisible ? 80.0 : 0.0,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: new CircularBottomNavigation(
            [
              new TabItem(
                FontAwesomeIcons.calendarDay,
                'Day',
                Colors.green,
                labelStyle: GoogleFonts.roboto().copyWith(color: Colors.green),
              ),
              new TabItem(
                FontAwesomeIcons.calendarWeek,
                'Week',
                Colors.green,
                labelStyle: GoogleFonts.roboto().copyWith(color: Colors.green),
              ),
//              new TabItem(
//                FontAwesomeIcons.doorOpen,
//                'Aule Libere',
//                Colors.green,
//                labelStyle: GoogleFonts.roboto().copyWith(color: Colors.green),
//              )
            ],
            selectedPos: _navigationController.value,
            selectedCallback: _handleSelected,
            selectedIconColor: Theme.of(context).scaffoldBackgroundColor,
            normalIconColor: Colors.green,
            barBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            circleSize: 50.0,
            barHeight: 60.0,
            iconsSize: 19.0,
            controller: _navigationController,
          )),
    );
  }
}
