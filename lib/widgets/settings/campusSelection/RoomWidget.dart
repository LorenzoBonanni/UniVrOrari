import 'package:flutter/material.dart';

class RoomWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RoomWidgetState();
  }
}

class RoomWidgetState extends State<RoomWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: new Text("data"),
    );
  }
}