import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plannus/models/Event.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:plannus/services/DbService.dart';
import 'package:plannus/util/PresetColors.dart';

class EditOrDelete extends StatefulWidget {

  final Event event;
  EditOrDelete({this.event});

  @override
  _EditOrDelete createState() => _EditOrDelete();
}

class _EditOrDelete extends State<EditOrDelete> {

  Widget makeIcon(String category) {
    return category == "Studies"
        ? Icon(Icons.book)
        : category == "Fitness"
        ? Icon(Icons.sports_baseball)
        : category == "Arts"
        ? Icon(Icons.music_note)
        : category == "Social"
        ? Icon(Icons.phone_in_talk)
        : Icon(Icons.thumb_up);
  }

  bool today(DateTime currentDate) {
    return (currentDate.year == DateTime.now().year
        && currentDate.month == DateTime.now().month
        && currentDate.day == DateTime.now().day);
  }

  String errorMessage = "";

  String description;
  String dropdownValue;
  String startTime;
  String endTime;
  int difficulty;
  String startDate;
  String endDate;

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
        } else if (submitted.endTime.compareTo(submitted.startTime) <= 0) {
          errorMessage = "End Time has to be after Start Time";
          setState(() {});
        } else {
          await DbService().editEvent(widget.event, submitted);
          Navigator.pop(context);
        }
      },
      icon: Icon(Icons.done),
      label: Text("EDIT"),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(PresetColors.blueAccent),
      ),
    ),
      ElevatedButton.icon(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: Text("Are you sure you want to delete?"),
                children: [
                  makeIcon(widget.event.category),
                  SizedBox(height: 10,),
                  Text(
                    widget.event.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Column(
                    children: [
                      Text(
                        widget.event.startTime.toString().substring(0, 10),
                      ),
                      Text(
                        "${DateFormat.Hms().format(widget.event.startTime).substring(0, 5)} - ${DateFormat.Hms().format(widget.event.endTime).substring(0, 5)}",
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(icon: Icon(Icons.done), onPressed: () async {
                        await DbService().delete(widget.event);
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }),
                      IconButton(icon: Icon(Icons.close), onPressed: () {
                        Navigator.pop(context);
                      }),
                    ],
                  ),
                ],
              );
            },
          );
        },
        icon: Icon(Icons.close),
        label: Text("DELETE"),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(PresetColors.blueAccent),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    description = description ?? widget.event.description;
    dropdownValue = dropdownValue ?? widget.event.category;
    startTime = startTime ?? DateFormat.Hms().format(widget.event.startTime).substring(0, 5);
    endTime = endTime ?? DateFormat.Hms().format(widget.event.endTime).substring(0, 5);
    difficulty = difficulty ?? widget.event.difficulty;
    startDate = startDate ?? DateFormat.d().format(widget.event.startTime)
      + "/"
      + DateFormat.M().format(widget.event.startTime)
      + "/"
      + DateFormat.y().format(widget.event.startTime);
    endDate = endDate ?? DateFormat.d().format(widget.event.endTime)
        + "/"
        + DateFormat.M().format(widget.event.endTime)
        + "/"
        + DateFormat.y().format(widget.event.endTime);

    return Scaffold(
      appBar: AppBar(
        actions: buildEditingActions(),
        title: Text("Edit or delete"),
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
            initialValue: description,
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
                  // value: difficulty ?? 5,
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
          SizedBox(height: 20.0,),
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
          SizedBox(height: 20.0,),
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
