import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planaholic/models/Event.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:planaholic/services/DbService.dart';
import 'package:planaholic/util/PresetColors.dart';

class EventEditingPage extends StatefulWidget {

  final DateTime currentDate;
  EventEditingPage({this.currentDate});

  @override
  _EventEditingPageState createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {

  bool today(DateTime currentDate) {
    return (currentDate.year == DateTime.now().year
        && currentDate.month == DateTime.now().month
        && currentDate.day == DateTime.now().day);
  }

  String errorMessage = "";

  String description = "";
  int difficulty = 5;
  String startDate;
  String endDate;
  String dropdownValue = "Studies";
  String startTime;
  String endTime;

  List<Widget> buildEditingActions() {
    return [ElevatedButton.icon(
      onPressed: () async {
        // save data to firestore
        Event submitted = Event(
          completed: false,
          passed: false,
          category: dropdownValue,
          description: description,
          startTime: DateTime(int.parse(startDate.substring(startDate.lastIndexOf('/') + 1, startDate.length)),
              int.parse(startDate.substring(startDate.indexOf('/') + 1, startDate.lastIndexOf('/'))),
              int.parse(startDate.substring(0, startDate.indexOf('/'))),
              int.parse(startTime.substring(0, 2)), int.parse(startTime.substring(3, 5))),
          endTime: DateTime(int.parse(endDate.substring(endDate.lastIndexOf('/') + 1, endDate.length)),
              int.parse(endDate.substring(endDate.indexOf('/') + 1, endDate.lastIndexOf('/'))),
              int.parse(endDate.substring(0, endDate.indexOf('/'))),
              int.parse(endTime.substring(0, 2)), int.parse(endTime.substring(3, 5))),
          difficulty: difficulty,
        );

        if (submitted.description == "") {
          errorMessage = "Please add a description";
          setState(() {});
        } else if (submitted.startTime.compareTo(DateTime.now()) < 0) {
          errorMessage = "Start Time cannot be in the past!";
          setState(() {});
        } else if (submitted.endTime.compareTo(submitted.startTime) <= 0) {
          errorMessage = "End Time has to be after Start Time";
          setState(() {});
        } else {
          await DbService().addNewEvent(submitted);
          Navigator.pop(context);
        }
      },
      icon: Icon(Icons.done),
      label: Text("SAVE"),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(PresetColors.blueAccent),
      ),
    )];
  }

  bool sameDay(DateTime first, DateTime second) {
    return (first.year == second.year
        && first.month == second.month
        && first.day == second.day);
  }

  @override
  Widget build(BuildContext context) {
    startDate = startDate ?? DateFormat.d().format(widget.currentDate)
      + "/"
      + DateFormat.M().format(widget.currentDate)
      + "/"
      + DateFormat.y().format(widget.currentDate);
    endDate = endDate ?? DateFormat.d().format(widget.currentDate)
        + "/"
        + DateFormat.M().format(widget.currentDate)
        + "/"
        + DateFormat.y().format(widget.currentDate);
    startTime = startTime ?? (sameDay(widget.currentDate, DateTime.now())
      ? DateFormat.Hms().format(DateTime.now()).substring(0, 5)
      : "12.00"
    );
    endTime = endTime ?? startTime;
    return Scaffold(
      appBar: AppBar(
        actions: buildEditingActions(),
        title: Text("Add an activity"),
        backgroundColor: PresetColors.blueAccent,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Category",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButton<String>(
                isExpanded: true,
                items: <String>["Studies", "Fitness", "Arts", "Social", "Others"]
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    })
                    .toList(),
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
              );
            },
          ),
          SizedBox(height: 20.0,),
          Text(
            "Description",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter description',
              labelText: 'Description',
            ),
            onChanged: (String desc) {
              description = desc;
            },
          ),
          SizedBox(height: 20.0,),
          Text(
            "Perceived Difficulty",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 13,
                child: Slider(
                  value: difficulty.toDouble(),
                  activeColor: Colors.blue[difficulty * 100],
                  inactiveColor: Colors.blue[difficulty * 100],
                  min: 1,
                  max: 9,
                  divisions: 8,
                  onChanged: (val) => setState(() => difficulty = val.round()),
                ),
              ),
              Expanded(flex: 1, child: Text(difficulty.toString())),
            ],
          ),
          Text(
            "Start Date",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return OutlinedButton(
                  onPressed: () {
                    DatePicker.showDatePicker(
                        context,
                        currentTime: DateTime(
                          int.parse(startDate.substring(startDate.lastIndexOf('/') + 1, startDate.length)),
                          int.parse(startDate.substring(startDate.indexOf('/') + 1, startDate.lastIndexOf('/'))),
                          int.parse(startDate.substring(0, startDate.indexOf('/'))),
                        ),
                        onConfirm: (val) {
                          startDate = DateFormat.d().format(val)
                              + "/"
                              + DateFormat.M().format(val)
                              + "/"
                              + DateFormat.y().format(val);
                          setState((){});
                        }
                    );
                  },
                  child: Text(
                    startDate,
                  ),
                );
              }
          ),
          Text(
            "Start Time",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return OutlinedButton(
                onPressed: () {
                  DatePicker.showTimePicker(
                    context,
                      currentTime: DateTime(2021, 1, 1, int.parse(startTime.substring(0, 2)), int.parse(startTime.substring(3, 5))),
                    showSecondsColumn: false,
                    onConfirm: (date) {
                      startTime = DateFormat.Hms().format(date).substring(0, 5);
                      setState(() {});
                    }
                  );
                },
                child: Text(
                  startTime,
                ),
              );
            }
          ),
          SizedBox(height: 20.0,),
          Text(
            "End Date",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return OutlinedButton(
                  onPressed: () {
                    DatePicker.showDatePicker(
                        context,
                        currentTime: DateTime(
                          int.parse(endDate.substring(endDate.lastIndexOf('/') + 1, endDate.length)),
                          int.parse(endDate.substring(endDate.indexOf('/') + 1, endDate.lastIndexOf('/'))),
                          int.parse(endDate.substring(0, endDate.indexOf('/'))),
                        ),
                        onConfirm: (val) {
                          endDate = DateFormat.d().format(val)
                              + "/"
                              + DateFormat.M().format(val)
                              + "/"
                              + DateFormat.y().format(val);
                          setState((){});
                        }
                    );
                  },
                  child: Text(
                    endDate,
                  ),
                );
              }
          ),
          Text(
            "End Time",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return OutlinedButton(
                onPressed: () {
                  DatePicker.showTimePicker(
                    context,
                    currentTime: DateTime(2021, 1, 1, int.parse(endTime.substring(0, 2)), int.parse(endTime.substring(3, 5))),
                    showSecondsColumn: false,
                    onConfirm: (date) {
                      endTime = DateFormat.Hms().format(date).substring(0, 5);
                      setState(() {});
                    }
                  );
                },
                child: Text(
                  endTime,
                ),
              );
            },
          ),
          SizedBox(height: 10,),
          Text(
            errorMessage,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
