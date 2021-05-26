import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plannus/models/Event.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:plannus/services/DbService.dart';

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
  String dropdownValue = "Studies";
  String startTime = "12:00";
  String endTime = "12:00";

  List<Widget> buildEditingActions() {
    return [ElevatedButton.icon(
      onPressed: () async {
        // save data to firestore
        Event submitted = Event(
          completed: false,
          passed: false,
          category: dropdownValue,
          description: description,
          startTime: DateTime(widget.currentDate.year, widget.currentDate.month, widget.currentDate.day,
                int.parse(startTime.substring(0, 2)), int.parse(startTime.substring(3, 5))),
          endTime: DateTime(widget.currentDate.year, widget.currentDate.month, widget.currentDate.day,
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
          await DbService().addNewEvent(submitted);
          Navigator.pop(context);
        }
      },
      icon: Icon(Icons.done),
      label: Text("SAVE"),
    )];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: buildEditingActions(),
        title: Text("Add an activity"),
      ),
      body: Column(
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
