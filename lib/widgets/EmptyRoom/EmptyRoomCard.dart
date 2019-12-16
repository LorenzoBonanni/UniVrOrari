import 'package:flutter/material.dart';
import 'package:school_timetable/widgets/EmptyRoom/EmptyRoomText.dart';

class EmptyRoomCard extends StatefulWidget {
  final _roomsData;

  EmptyRoomCard(this._roomsData);

  @override
  State<StatefulWidget> createState() {
    return new EmptyRoomCardState(_roomsData);
  }
}

class EmptyRoomCardState extends State<EmptyRoomCard> {
  var _roomsData;
  List<Widget> _widgets = [];

  EmptyRoomCardState(this._roomsData);

  @override
  void initState() {
    for (var roomData in _roomsData) {
      if(roomData["name"].contains("Ufficio docenti esterni")) {
        continue;
      }
      this._widgets.add(new EmptyRoomText(roomData));
    }
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return this._widgets.isNotEmpty
        ? new Card(
          child: new Column(
            children: _widgets,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
        ),
    )
        : new Card(child: new Text(""));
  }
}
