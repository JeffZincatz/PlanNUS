import 'package:flutter/material.dart';
import 'package:plannus/services/DbService.dart';
import 'package:plannus/models/Event.dart';
import 'dart:math';
import 'package:plannus/util/StatsUtil.dart';
import 'package:plannus/util/TimeUtil.dart';

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
        child: ListView(
          children: <Widget>[
            Text(
              "Debugging functions",
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            StreamBuilder<List<Event>>(
                stream: _db.eventsStream,
                builder: (context, snapshot) {
                  return debugButton("add difficulties", () async {
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
                  });
                }),
            debugButton("check userLevelExits", () async {
              print(await _db.userLevelExists());
            }),
            debugButton("initUserLevel", () async {
              if (await _db.userLevelExists()) {
                print("User level info already exists.");
              } else {
                await _db.initUserLevel();
                print("User level info initialised.");
              }
            }),
            debugButton("syncUserStats - New data structure", () async {
              await _db.syncUserStats();
            }),
            debugButton("initWeekly (reset to 0)", _db.initWeekly),
            debugButton("addToWeekly - Arts", () => _db.addToWeekly("Arts")),
            debugButton("getWeekly", () async {
              var res = await _db.getWeekly();
              print(res);
            }),
            debugButton("updateWeekly", _db.updateWeekly),
            debugButton("isAtLeastOneWeekApart", () => print(TimeUtil.isAtLeastOneWeekApart(DateTime(2021, 1, 1), DateTime.now()))),
          ],
        ),
      ),
    );
  }

  Widget debugButton(String name, Function function) {
    return TextButton(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          name,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      onPressed: function,
    );
  }
}
