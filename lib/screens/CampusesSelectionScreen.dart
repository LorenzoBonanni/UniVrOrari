import 'package:school_timetable/screens/MainScreen.dart';
import 'package:school_timetable/utils/DataGetter.dart';
import 'package:flutter/material.dart';
import 'package:school_timetable/utils/SettingUtils.dart';
import 'package:school_timetable/widgets/settings/campusSelection/CampusSelectionWidget.dart';
import 'package:school_timetable/widgets/Loading.dart';



class CampusesSelectionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CampusesSelectionScreenState();
  }
}


class CampusesSelectionScreenState extends State<CampusesSelectionScreen> {
  List<Widget> _widgets = [];
  var _campuses;

  addDropDown() {
    List<Widget> widgets = [];
    Widget buttonBar = new ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        new FlatButton(
            onPressed: addDropDown,
            child: new Text("AGGIUNGI POLO", style: new TextStyle(color: Colors.green),)
        ),
        new FlatButton(
            onPressed: () {
              SettingUtils.updateCampusList().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScreen(),
                  ),
                );
              });
            },
            child: new Text("FINE", style: new TextStyle(color: Colors.green),)
        )
      ],
    );

    if (_widgets.isNotEmpty) {
      widgets = _widgets;
      widgets.removeLast();
    }

    widgets.add(new CampusSelectionWidget(_campuses));
    widgets.add(buttonBar);
    setState(() {
      _widgets = widgets;
    });
  }

  @override
  void initState() {
    SettingUtils.resetCampusList();
    DataGetter.getCampuses().then((campuses) {
      setState(() {
        _campuses = campuses;
      });
      addDropDown();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Selezione Campus di Interesse"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: _widgets.isNotEmpty
          ? ListView.builder(
              itemCount: _widgets.length,
              itemBuilder: (BuildContext context, int index) => _widgets[index],
            )
          : new Loading(),
    );
  }
}
