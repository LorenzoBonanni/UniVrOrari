import 'package:flutter/material.dart';

class EmptyRoomText extends StatefulWidget {
  var _roomData;

  EmptyRoomText(this._roomData);

  @override
  State<StatefulWidget> createState() {
    return new EmptyRoomTextState(_roomData);
  }
}

class EmptyRoomTextState extends State<EmptyRoomText> {
  var _roomData;
  Widget _widget;

  EmptyRoomTextState(this._roomData);

  @override
  void initState() {
    String roomName = _roomData["name"];
    String closureDate = "";
    if (_roomData["until"] == 0) {
      closureDate += " fino a Chiusura";
    }
    else {
      DateTime datetime = new DateTime.fromMillisecondsSinceEpoch(_roomData["until"] * 1000);
      String time = datetime.hour.toString() + ":" + datetime.minute.toString();
      closureDate += " " + time;
    }
    setState(() {
      _widget = new Wrap(
        children: <Widget>[
          new Text(roomName, style: new TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          new Text(closureDate, style: new TextStyle(color: Colors.black))
        ],
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _widget != null
        ? _widget
        : new Text("empty", style: new TextStyle(color: Colors.black));
  }
}