import 'package:flutter/material.dart';
import 'package:school_timetable/utils/DataGetter.dart';
import 'package:school_timetable/utils/SettingUtils.dart';
import 'package:school_timetable/widgets/EmptyRoom/EmptyRoomCampus.dart';

class EmptyRoomsView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new EmptyRoomsViewState();
  }
}



class EmptyRoomsViewState extends State<EmptyRoomsView> {
  var _campuses;
  var _campusIds = [];

  @override
  void initState() {
    DataGetter.getCampuses().then((campuses) async {
      // retrieve selected campuses and for each one build its widgets
      var campusIds =  await SettingUtils.getCampusList();
      setState(() {
        _campuses = campuses;
        _campusIds = campusIds;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: _campusIds.length,
        itemBuilder: (context, index) {
          var id = _campusIds[index];
          return EmptyRoomCampus(
            campuses: this._campuses,
            id: id
          );
        }
    );
  }
}