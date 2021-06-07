import 'package:flutter/material.dart';
import 'package:plannus/services/DbService.dart';
import 'package:plannus/models/Event.dart';
import 'dart:math';

class Debug extends StatelessWidget {
  const Debug({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final DbService _db = DbService();

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            Text(
              "Debugging functions",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            StreamBuilder<List<Event>>(
                stream: _db.eventsStream,
                builder: (context, snapshot) {
                  return TextButton(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Debug - add difficulties",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      for (Event x in snapshot.data) {
                        Event submitted = Event(
                          completed: x.completed,
                          passed: x.passed,
                          category: x.category,
                          description: x.description,
                          startTime: x.startTime,
                          endTime: x.endTime,
                          difficulty: (new Random()).nextInt(8) + 1,
                        );
                        _db.editEvent(x, submitted);
                      }
                    },
                  );
                }
            ),
            TextButton(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Debug - isUserStatsEmpty",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
              ),
              onPressed: () async {
                print(await _db.isUserStatsEmpty());
              },
            ),
            TextButton(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Debug - initUserStats",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
              ),
              onPressed: () async {
                if (await _db.isUserStatsEmpty()) {
                  await _db.initUserStats();
                  print("User stats initialised.");
                } else {
                  print("User stats already exists.");
                }
              },
            ),
            TextButton(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Debug - syncUserStats",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
              ),
              onPressed: () async {
                await _db.syncUserStats();
              },
            ),
          ],
        ),
      ),
    );
  }
}