import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_timetable/utils/DataGetter.dart';
import 'package:school_timetable/widgets/Loading.dart';
import 'package:school_timetable/widgets/settings/subjectSelection/SubjectSelectionWidget.dart';
import 'MainScreen.dart';

class SubjectSelectionScreen extends StatefulWidget {
  @override
  _SubjectSelectionScreenState createState() => _SubjectSelectionScreenState();
}

class _SubjectSelectionScreenState extends State<SubjectSelectionScreen> {
  var _subjects;

  void finishCallback() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(),
      ),
    );
  }


  @override
  void initState() {
    String date = new DateFormat("dd-MM-yyyy").format(new DateTime.now());
    DataGetter.getSubjects(date).then((s) {
      var subjects = s[0]["lezioni"];
      var subjectsExtra = s[1]["lezioni"];
      subjects = subjects + subjectsExtra;
      setState(() {
        this._subjects = subjects;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Filtra Lezioni"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: _subjects != null
            ? new Column(
                children: [
                  new Text(
                      "Seleziona le lezioni di Interesse",
                      style: TextStyle(color: Theme.of(context).textTheme.headline4!.color),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: _subjects.length,
                        itemBuilder: (context, index) => new SubjectSelectionWidget(_subjects[index])
                    ),
                  ),
                  new TextButton(
                      onPressed: finishCallback,
                      child: new Text("FINE", style: new TextStyle(color: Colors.green))
                  )
                ],
              )
            : new Loading(),
    );
  }
}
