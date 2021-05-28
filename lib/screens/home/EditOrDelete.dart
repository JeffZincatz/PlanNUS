import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plannus/models/Event.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:plannus/services/DbService.dart';

class EditOrDelete extends StatefulWidget {

  final Event event;
  EditOrDelete({this.event});

  @override
  _EditOrDelete createState() => _EditOrDelete();
}

class _EditOrDelete extends State<EditOrDelete> {

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

  List<Widget> buildEditingActions() {
    return [ElevatedButton.icon(
      onPressed: () async {
        // save data to firestore
        Event submitted = Event(
          completed: false,
          passed: false,
          category: dropdownValue,
          description: description,
          startTime: DateTime(widget.event.startTime.year, widget.event.startTime.month, widget.event.startTime.day,
              int.parse(startTime.substring(0, 2)), int.parse(startTime.substring(3, 5))),
          endTime: DateTime(widget.event.startTime.year, widget.event.startTime.month, widget.event.startTime.day,
              int.parse(endTime.substring(0, 2)), int.parse(endTime.substring(3, 5))),
        );

        if (submitted.description == "") {
          errorMessage = "Please add a description";
          setState(() {});
        } else if (today(submitted.startTime) && submitted.startTime.compareTo(DateTime.now()) < 0) {
          errorMessage = "Start Time cannot be in the past!";
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
    ),
      ElevatedButton.icon(
        onPressed: () async {
          await DbService().delete(widget.event);
          Navigator.pop(context);
        },
        icon: Icon(Icons.close),
        label: Text("DELETE"),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    description = description ?? widget.event.description;
    dropdownValue = dropdownValue ?? widget.event.category;
    startTime = startTime ?? DateFormat.Hms().format(widget.event.startTime).substring(0, 5);
    endTime = endTime ?? DateFormat.Hms().format(widget.event.endTime).substring(0, 5);
    return Scaffold(
      appBar: AppBar(
        actions: buildEditingActions(),
        title: Text("Edit or delete"),
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