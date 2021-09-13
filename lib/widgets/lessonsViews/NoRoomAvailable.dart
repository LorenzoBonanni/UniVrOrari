import 'package:flutter/material.dart';

class NoRoomAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Text("Nessuna Aula Disponibie",
          style: Theme.of(context).textTheme.headline3),
    );
  }
}