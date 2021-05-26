import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plannus/models/Event.dart';
import 'package:plannus/services/DbService.dart';

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

  @override
  Widget build(BuildContext context) {
    void askWhetherCompleted() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Have you done this activity?"),
            children: [
              makeIcon(event.category),
              SizedBox(height: 10,),
              Text(
                event.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10,),
              Column(
                children: [
                  Text(
                    event.startTime.toString().substring(0, 10),
                  ),
                  Text(
                    "${DateFormat.Hms().format(event.startTime).substring(0, 5)} - ${DateFormat.Hms().format(event.endTime).substring(0, 5)}",
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: Icon(Icons.done), onPressed: () {
                    DbService().markCompleted(event);
                    Navigator.pop(context, true);
                  }),
                  IconButton(icon: Icon(Icons.close), onPressed: () {

                  }),
                ],
              ),
            ],
          );
        },
      );
    }

    return TextButton(
        onPressed: () {
          if (event.endTime.compareTo(DateTime.now()) > 0) { // haven't ended

          } else {
            askWhetherCompleted();
          }
        },
        style: ButtonStyle(
            foregroundColor: MaterialStateColor.resolveWith((states) => Colors.black)
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
                event.description,
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
                    event.startTime.toString().substring(0, 10),
                  ),
                  Flexible(
                    child: Text(
                      "${DateFormat.Hms().format(event.startTime).substring(0, 5)} - ${DateFormat.Hms().format(event.endTime).substring(0, 5)}",
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}
