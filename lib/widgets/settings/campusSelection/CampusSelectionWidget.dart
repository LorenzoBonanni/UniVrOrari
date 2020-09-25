import 'package:flutter/material.dart';
import 'package:school_timetable/utils/SettingUtils.dart';

class CampusSelectionWidget extends StatefulWidget {
  final _campuses;

  CampusSelectionWidget(this._campuses);

  @override
  CampusSelectionWidgetState createState() =>
      CampusSelectionWidgetState();
}

class CampusSelectionWidgetState extends State<CampusSelectionWidget> {
  bool _setted = false;
  Widget _hint;
  List<DropdownMenuItem<String>> _items;

  CampusSelectionWidgetState();

  generateItems() async {
    List<DropdownMenuItem<String>> items = [];
    for (var campus in widget._campuses) {
      items.add(
        new DropdownMenuItem<String>(
          value: campus["label"],
          child: new Text(
            campus["label"],
            style: TextStyle(color: Theme.of(context).textTheme.display1.color),
          ),
        ),
      );
    }
    return items;
  }

  void dropDownChanged(label) {
    // get map where value correspond to selected value
    var map = widget._campuses.where((c) => c["label"] == label).toList();
    map = map[0];
    setState(() {
      _hint = new Text(map["label"]);
      _setted = true;
    });
    SettingUtils.setCampusList(map["valore"]);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _hint = new Text("Seleziona un Polo");
    });
  }

  @override
  Widget build(BuildContext context) {
    generateItems().then((items) {
      setState(() {
        _items = items;
      });
    });
    return this._items != null
        ? DropdownButton(
            hint: _hint,
            isExpanded: true,
            items: this._items,
            onChanged: !_setted ? dropDownChanged : null,
            style: Theme.of(context).textTheme.display1
          )
        : DropdownButton(items: [], onChanged: null);
  }
}
