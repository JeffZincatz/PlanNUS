import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plannus/screens/home/NavBar.dart';
import 'package:plannus/screens/home/UnfinishedEventList.dart';
import 'package:plannus/services/DbService.dart';
import 'package:plannus/util/PresetColors.dart';
import 'package:plannus/screens/home/Calendar2.dart';
import 'package:plannus/screens/home/EventEditingPage.dart';
import 'package:provider/provider.dart';
import 'package:plannus/models/Event.dart';
import 'package:plannus/screens/home/MaybeFinishedEventList.dart';
import 'package:plannus/screens/home/CompletedEventList.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:plannus/screens/home/UncompletedPastEventList.dart';

import '../../util/PresetColors.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime currentDate = DateTime.now();

  void updateCurrentDate(DateTime newDateTime) {
    currentDate = newDateTime;
  }

  final DbService _db = new DbService();

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {

    bool today(DateTime currentDate) {
      return (currentDate.year == DateTime.now().year
          && currentDate.month == DateTime.now().month
          && currentDate.day == DateTime.now().day);
    }

    double screenHeight = MediaQuery.of(context).size.height;

    // print(_db.unfinishedEventsStream.isEmpty);

    return StreamProvider<List<Event>>.value(
      initialData: [],
      value: _db.eventsStream,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: PresetColors.blueAccent,
            title: Text(
              "PlanNUS",
              style: TextStyle(
                fontFamily: "Lobster Two",
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 32,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(3, 3),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          body: SmartRefresher(
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: ListView(
              children: [
                Calendar2(updateCurrentDate: updateCurrentDate),
                Divider(
                  height: screenHeight / 20,
                  thickness: 3.0,
                  color: Colors.blue[100],
                ),
                Text(
                  "Upcoming Activities",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 140,
                  child: UnfinishedEventList(),
                ),
                Text(
                  "Have you done these activities?",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 140,
                  child: MaybeFinishedEventList(),
                ),
                Text(
                  "Completed Activities",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 140,
                  child: CompletedEventList(),
                ),
                Text(
                  "Uncompleted past activities",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 140,
                  child: UncompletedPastEventList(),
                ),
              ],
            ),
          ),
          drawer: NavBar(),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: PresetColors.blue),
            backgroundColor: Colors.blue[100],
            onPressed: () {
              if (currentDate.compareTo(DateTime.now()) < 0 &&
                  !(today(currentDate))) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Adding activities cannot be done for past dates!'),
                  ),
                );
              } else {
                print(currentDate.toString());
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EventEditingPage(currentDate: currentDate)),
                );
              }
            },
          ),
        );
      }
    );
  }
}
