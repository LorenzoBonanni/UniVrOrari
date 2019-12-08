import 'package:flutter/material.dart';
import 'package:school_timetable/utils/DataGetter.dart';
import 'package:school_timetable/utils/SettingUtils.dart';
import 'package:school_timetable/widgets/EmptyRoomCard.dart';
import 'package:school_timetable/widgets/Loading.dart';
import 'package:school_timetable/widgets/lessonsViews/NoRoomAvailable.dart';

class EmptyRoomsView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new EmptyRoomsViewState();
  }
}



class EmptyRoomsViewState extends State<EmptyRoomsView> {
  var _campuses;
  var _widgets = [];

  getEmptyRooms(id) async {
    var rooms = await DataGetter.getEmptyRooms(id);
    var emptyRooms = rooms.where((r) => r["isFree"] == true).toList();
    return emptyRooms;
  }

  getWidgets(id, rooms) {
    var widgets = [];
    var campusMap = _campuses.where((c) => c["valore"] == id).toList()[0];
    String campusName = campusMap["label"];
    widgets.add(
        Text(
          campusName,
          style: Theme.of(context).textTheme.display2.copyWith(fontSize: 18)
        )
    );
    widgets.add(
        rooms.isNotEmpty
            ? new EmptyRoomCard(rooms)
            : new NoRoomAvailable()
    );
    return widgets;
  }


  @override
  void initState() {
    DataGetter.getCampuses().then((campuses){
      _campuses = campuses;

      // retrieve selected campuses and for each one build its widgets
      SettingUtils.getCampusList().then((campusIds){

        // forEach selectedId retrieve its empty rooms
        for (var id in campusIds) {

          // retrieve EmptyRooms for selected Campus
          getEmptyRooms(id).then((rooms) {
            var widgets = _widgets;
            widgets.addAll(getWidgets(id, rooms));
            setState(() {
              _widgets = widgets;
            });
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _widgets.isNotEmpty
        ? new ListView.builder(
            itemCount: _widgets.length,
            itemBuilder: (context, index) => _widgets[index]
          )
        : Loading();
  }
}