import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planaholic/elements/MySnackBar.dart';
import 'package:planaholic/models/Event.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:planaholic/services/DbService.dart';
import 'package:planaholic/util/PresetColors.dart';
import 'package:planaholic/services/NotifService.dart';
import 'package:planaholic/services/DbNotifService.dart';

/// Event editing page
class EventEditingPage extends StatefulWidget {
  final DateTime currentDate;

  EventEditingPage({this.currentDate});

  @override
  _EventEditingPageState createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  /// Check if the [currentDate] is today
  bool today(DateTime currentDate) {
    return (currentDate.year == DateTime.now().year &&
        currentDate.month == DateTime.now().month &&
        currentDate.day == DateTime.now().day);
  }

  // Not needed if MySnackBar works well
  // String errorMessage = "";

  String description = "";
  int difficulty = 5;
  String startDate;
  String endDate;
  String dropdownValue = "Studies";
  String startTime;
  String endTime;

  /// Create the edit and delete actions icons
  List<Widget> buildEditingActions() {
    return [
      ElevatedButton.icon(
        onPressed: () async {
          // save data to firestore
          Event submitted = Event(
            completed: false,
            passed: false,
            category: dropdownValue,
            description: description,
            startTime: DateTime(
                int.parse(startDate.substring(
                    startDate.lastIndexOf('/') + 1, startDate.length)),
                int.parse(startDate.substring(
                    startDate.indexOf('/') + 1, startDate.lastIndexOf('/'))),
                int.parse(startDate.substring(0, startDate.indexOf('/'))),
                int.parse(startTime.substring(0, 2)),
                int.parse(startTime.substring(3, 5))),
            endTime: DateTime(
                int.parse(endDate.substring(
                    endDate.lastIndexOf('/') + 1, endDate.length)),
                int.parse(endDate.substring(
                    endDate.indexOf('/') + 1, endDate.lastIndexOf('/'))),
                int.parse(endDate.substring(0, endDate.indexOf('/'))),
                int.parse(endTime.substring(0, 2)),
                int.parse(endTime.substring(3, 5))),
            difficulty: difficulty,
          );

          DateTime now = DateTime.now();
          DateTime nowToNearestMin =
              DateTime(now.year, now.month, now.day, now.hour, now.minute);

          if (submitted.description == "") {
            // errorMessage = "Please add a description";
            // setState(() {});
            MySnackBar.show(context, Text("Please add a description."));
          } else if (submitted.startTime.compareTo(nowToNearestMin) < 0) {
            // errorMessage = "Start Time cannot be in the past!";
            // setState(() {});
            MySnackBar.show(context, Text("Start Time cannot be in the past!"));
          } else if (submitted.endTime.compareTo(submitted.startTime) <= 0) {
            // errorMessage = "End Time has to be after Start Time";
            // setState(() {});
            MySnackBar.show(
                context, Text("End Time has to be after Start Time."));
          } else {
            DocumentReference docRef = await DbService().addNewEvent(submitted);
            DbService().editEvent2(
                docRef.id,
                Event(
                  completed: false,
                  passed: false,
                  category: dropdownValue,
                  description: description,
                  id: docRef.id,
                  startTime: DateTime(
                      int.parse(startDate.substring(
                          startDate.lastIndexOf('/') + 1, startDate.length)),
                      int.parse(startDate.substring(startDate.indexOf('/') + 1,
                          startDate.lastIndexOf('/'))),
                      int.parse(startDate.substring(0, startDate.indexOf('/'))),
                      int.parse(startTime.substring(0, 2)),
                      int.parse(startTime.substring(3, 5))),
                  endTime: DateTime(
                      int.parse(endDate.substring(
                          endDate.lastIndexOf('/') + 1, endDate.length)),
                      int.parse(endDate.substring(
                          endDate.indexOf('/') + 1, endDate.lastIndexOf('/'))),
                      int.parse(endDate.substring(0, endDate.indexOf('/'))),
                      int.parse(endTime.substring(0, 2)),
                      int.parse(endTime.substring(3, 5))),
                  difficulty: difficulty,
                ));
            Navigator.pop(context);
            MySnackBar.show(context, Text("Activity successfully added."));
            DateTime startTimeDb = DateTime(
                int.parse(startDate.substring(
                    startDate.lastIndexOf('/') + 1, startDate.length)),
                int.parse(startDate.substring(
                    startDate.indexOf('/') + 1, startDate.lastIndexOf('/'))),
                int.parse(startDate.substring(0, startDate.indexOf('/'))),
                int.parse(startTime.substring(0, 2)),
                int.parse(startTime.substring(3, 5)));
            int before = await DbNotifService().getBefore();
            if (startTimeDb
                    .subtract(Duration(minutes: before))
                    .compareTo(DateTime.now()) >
                0) {
              List<dynamic> lsInit = await DbNotifService().getAvailable();
              List<int> ls = lsInit.cast<int>();
              int notifId = ls[0];
              ls.removeAt(0);
              await DbNotifService().updateAvailable(ls);
              await DbNotifService().addToTaken(notifId, docRef.id);
              await NotifService.notifyScheduled(submitted, notifId, before);
              MySnackBar.show(context, Text("Activity created successfully."));
            }
          }
        },
        icon: Icon(Icons.done),
        label: Text("SAVE"),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(PresetColors.blueAccent),
        ),
      )
    ];
  }

  /// Check if the [first] and [second] are the same day
  bool sameDay(DateTime first, DateTime second) {
    return (first.year == second.year &&
        first.month == second.month &&
        first.day == second.day);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    startDate = startDate ??
        DateFormat.d().format(widget.currentDate) +
            "/" +
            DateFormat.M().format(widget.currentDate) +
            "/" +
            DateFormat.y().format(widget.currentDate);
    endDate = endDate ??
        DateFormat.d().format(widget.currentDate) +
            "/" +
            DateFormat.M().format(widget.currentDate) +
            "/" +
            DateFormat.y().format(widget.currentDate);
    startTime = startTime ??
        (sameDay(widget.currentDate, DateTime.now())
            ? DateFormat.Hms().format(DateTime.now()).substring(0, 5)
            : "12.00");
    endTime = endTime ?? startTime;

    return Scaffold(
      appBar: AppBar(
        actions: buildEditingActions(),
        title: Text("Add an activity"),
        backgroundColor: PresetColors.blueAccent,
      ),
      body: GestureDetector(
        onTap: () {
          // un-focus text form field when tapped outside
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth / 24, vertical: screenHeight / 30),
              child: Wrap(
                runSpacing: screenHeight / 30,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            items: <String>[
                              "Studies",
                              "Fitness",
                              "Arts",
                              "Social",
                              "Others"
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
                            }).toList(),
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
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      TextFormField(
                        key: ValueKey("descField"),
                        decoration: InputDecoration(
                          hintText: 'Enter description',
                          labelText: 'Description',
                        ),
                        onChanged: (String desc) {
                          description = desc;
                        },

                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              onChanged: (val) =>
                                  setState(() => difficulty = val.round()),
                            ),
                          ),
                          // Expanded(flex: 1, child: Text(difficulty.toString())),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Start Date",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                        return SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  currentTime: DateTime(
                                    int.parse(startDate.substring(
                                        startDate.lastIndexOf('/') + 1,
                                        startDate.length)),
                                    int.parse(startDate.substring(
                                        startDate.indexOf('/') + 1,
                                        startDate.lastIndexOf('/'))),
                                    int.parse(startDate.substring(
                                        0, startDate.indexOf('/'))),
                                  ), onConfirm: (val) {
                                startDate = DateFormat.d().format(val) +
                                    "/" +
                                    DateFormat.M().format(val) +
                                    "/" +
                                    DateFormat.y().format(val);
                                setState(() {});
                              });
                            },
                            child: Text(
                              startDate,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Start Time",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                        return SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            key: ValueKey("startTimePicker"),
                            onPressed: () {
                              DatePicker.showTimePicker(context,
                                  currentTime: DateTime(
                                      2021,
                                      1,
                                      1,
                                      int.parse(startTime.substring(0, 2)),
                                      int.parse(startTime.substring(3, 5))),
                                  showSecondsColumn: false, onConfirm: (date) {
                                startTime =
                                    DateFormat.Hms().format(date).substring(0, 5);
                                setState(() {});
                              });
                            },
                            child: Text(
                              startTime,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "End Date",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                        return SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  currentTime: DateTime(
                                    int.parse(endDate.substring(
                                        endDate.lastIndexOf('/') + 1,
                                        endDate.length)),
                                    int.parse(endDate.substring(
                                        endDate.indexOf('/') + 1,
                                        endDate.lastIndexOf('/'))),
                                    int.parse(endDate.substring(
                                        0, endDate.indexOf('/'))),
                                  ), onConfirm: (val) {
                                endDate = DateFormat.d().format(val) +
                                    "/" +
                                    DateFormat.M().format(val) +
                                    "/" +
                                    DateFormat.y().format(val);
                                setState(() {});
                              });
                            },
                            child: Text(
                              endDate,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "End Time",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              key: ValueKey("endTimePicker"),
                              onPressed: () {
                                DatePicker.showTimePicker(context,
                                    currentTime: DateTime(
                                        2021,
                                        1,
                                        1,
                                        int.parse(endTime.substring(0, 2)),
                                        int.parse(endTime.substring(3, 5))),
                                    showSecondsColumn: false, onConfirm: (date) {
                                  endTime = DateFormat.Hms()
                                      .format(date)
                                      .substring(0, 5);
                                  setState(() {});
                                });
                              },
                              child: Text(
                                endTime,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  // Not needed if MySnackBar works well
                  // Text(
                  //   errorMessage,
                  //   style: TextStyle(
                  //     color: Colors.red,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
