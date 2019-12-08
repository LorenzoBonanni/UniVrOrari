import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  String _roomName;
  String _until;

  EmptyRoomTextState(this._roomData);

  @override
  void initState() {
    setState(() {
      _roomName = _roomData["name"];
    });
    if (_roomData["until"] == 0) {
      setState(() {
        _until = " fino a Chiusura";
      });
    } else {
      DateTime datetime =
          new DateTime.fromMillisecondsSinceEpoch(_roomData["until"] * 1000);
      String time = new DateFormat("HH:mm").format(datetime).toString();
      setState(() {
        _until = " fino alle " + time;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _roomName != null && _until != null
        ? new Wrap(
            children: <Widget>[
              new Text(_roomName, style: Theme.of(context).textTheme.display2),
              new Text(_until, style: Theme.of(context).textTheme.display1)
            ],
          )
        : new Text("empty", style: new TextStyle(color: Colors.black));
  }
}
