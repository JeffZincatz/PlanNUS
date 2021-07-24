import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planaholic/elements/ActivityCompletedDialog.dart';
import 'package:planaholic/models/Event.dart';
import 'package:planaholic/services/DbService.dart';
import 'package:planaholic/screens/home/EditOrDelete.dart';
import 'package:planaholic/util/PresetColors.dart';

class EventTile extends StatelessWidget {
  final Event event;

  EventTile({this.event});

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

  bool sameDay(DateTime first, DateTime second) {
    return (first.year == second.year &&
        first.month == second.month &&
        first.day == second.day);
  }

  @override
  Widget build(BuildContext context) {

    void editOrDelete() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => EditOrDelete(event: event)),
      );
    }

    void showActivityCompleted(Event event) {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ActivityCompleted(event: event)));
      showDialog(
          context: context,
          builder: (context) =>
              ActivityCompletedDialog(event: event));
    }

    void askWhetherCompleted() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Have you done this activity?"),
            children: [
              makeIcon(event.category),
              SizedBox(
                height: 10,
              ),
              Text(
                event.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Text(event.startTime.toString().substring(0, 10)),
                  Text(
                    "${DateFormat.Hms().format(event.startTime).substring(0, 5)} - ${DateFormat.Hms().format(event.endTime).substring(0, 5)}",
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () {
                        DbService().markCompleted(event);
                        Navigator.pop(context, true);
                        // I'm not sure why this throws some error but it still works fine somehow
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityCompleted(event: event)));
                        showActivityCompleted(event);
                      }),
                  SizedBox(width: 48),
                  IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        DbService().markUncompleted(event);
                        Navigator.pop(context, true);
                      }),
                ],
              ),
            ],
          );
        },
      );
    }



    return OutlinedButton(
        onPressed: () {
          if (event.endTime.compareTo(DateTime.now()) > 0) {
            // haven't ended
            editOrDelete();
          } else if (!event.passed) {
            askWhetherCompleted();
          } else if (event.completed) {
            showActivityCompleted(event);
          }
        },
        style: ButtonStyle(
          foregroundColor:
              MaterialStateColor.resolveWith((states) => PresetColors.blackAccent),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: makeIcon(event.category),
            ),
            Expanded(
              flex: 1,
              child: Text(
                event.description.length > 20
                    ? event.description.substring(0, 17) + "..."
                    : event.description,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                      // event.startTime.toString().substring(0, 10),
                      sameDay(event.startTime, event.endTime)
                          ? event.startTime.toString().substring(0, 10)
                          : event.startTime.toString().substring(0, 10) +
                              " "
                                  "${DateFormat.Hms().format(event.startTime).substring(0, 5)}" +
                              " to "),
                  Flexible(
                    child: Text(
                      sameDay(event.startTime, event.endTime)
                          ? "${DateFormat.Hms().format(event.startTime).substring(0, 5)} - ${DateFormat.Hms().format(event.endTime).substring(0, 5)}"
                          : event.endTime.toString().substring(0, 10) +
                              " "
                                  "${DateFormat.Hms().format(event.endTime).substring(0, 5)}",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
