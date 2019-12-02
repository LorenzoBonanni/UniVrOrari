import 'package:flutter/material.dart';
import 'package:school_timetable/utils/SettingUtils.dart';

class CampusSelectionWidget extends StatefulWidget {
  var _campuses;

  CampusSelectionWidget(this._campuses);

  @override
  CampusSelectionWidgetState createState() =>
      CampusSelectionWidgetState(this._campuses);
}

class CampusSelectionWidgetState extends State<CampusSelectionWidget> {
  var _campuses;
  bool _setted = false;
  Widget _hint = new Text("Seleziona un Polo");
  List<DropdownMenuItem<String>> _items;

  CampusSelectionWidgetState(this._campuses);

  generateItems() async {
    List<DropdownMenuItem<String>> items = [];
    for (var campus in this._campuses) {
      items.add(
        new DropdownMenuItem<String>(
          value: campus["label"],
          child: new Text(
            campus["label"],
            // style: TextStyle(color: Theme.of(context).textTheme.display1.color),
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );
    }
    return items;
  }

  void dropDownChanged(label) {
    // get map where value correspond to selected value
    var map = this._campuses.where((c) => c["label"] == label).toList();
    map = map[0];
    setState(() {
      _hint = new Text(map["label"]);
      _setted = true;
    });
    SettingUtils.setCampusList(map["valore"]);
  }

  void initState() {
    generateItems().then((items) {
      setState(() {
        _items = items;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return this._items != null
        ? DropdownButton(
            hint: _hint,
            isExpanded: true,
            items: this._items,
            onChanged: !_setted ? dropDownChanged : null,
          )
        : DropdownButton(items: [], onChanged: null);
  }
}
