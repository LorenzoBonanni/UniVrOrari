import 'package:flutter/material.dart';
import 'package:school_timetable/utils/DataGetter.dart';
import 'package:school_timetable/widgets/EmptyRoom/EmptyRoomCard.dart';
import 'package:school_timetable/widgets/lessonsViews/NoRoomAvailable.dart';

class EmptyRoomCampus extends StatefulWidget {
  final campuses;
  final id;

  EmptyRoomCampus({this.campuses, this.id});

  @override
  _EmptyRoomCampusState createState() => _EmptyRoomCampusState();
}

class _EmptyRoomCampusState extends State<EmptyRoomCampus> {
  var _rooms = [];

  getEmptyRooms() async {
    var rooms = await DataGetter.getEmptyRooms(widget.id);
    return rooms.where((r) => r["isFree"] == true).toList();
  }

  @override
  void initState() {
    getEmptyRooms().then((rooms){
      setState(() {
        _rooms = rooms;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var campusMap = widget.campuses.where((c) => c["valore"] == widget.id).toList()[0];
    String campusName = campusMap["label"];

    return Column(
      children: <Widget>[
        Text(
            campusName,
            style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 18)
        ),
        _rooms != null
            ? _rooms.isNotEmpty
              ? new EmptyRoomCard(_rooms)
              : new NoRoomAvailable()
            : new NoRoomAvailable()
      ],
    );
  }
}
