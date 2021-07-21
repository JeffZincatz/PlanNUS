import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planaholic/screens/home/event_list/UnfinishedEventList.dart';
import 'package:planaholic/screens/home/home_elements/Calendar2.dart';
import 'package:planaholic/screens/home/EventEditingPage.dart';
import 'package:planaholic/screens/home/event_list/MaybeFinishedEventList.dart';
import 'package:planaholic/screens/home/event_list/CompletedEventList.dart';
import 'package:planaholic/screens/home/event_list/UncompletedPastEventList.dart';
import 'package:planaholic/services/DbService.dart';
import 'package:planaholic/util/PresetColors.dart';
import 'package:planaholic/models/Event.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
    // DbNotifService().initialise();
    // DbNotifService().getAvailable();
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {});
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
          body: SmartRefresher(
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 18),
              children: [
                Calendar2(updateCurrentDate: updateCurrentDate),
                Divider(
                  height: screenHeight / 20,
                  thickness: 3.0,
                  color: Colors.blue[100],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Upcoming Activities",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 140,
                  child: UnfinishedEventList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Have you done these activities?",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 140,
                  child: MaybeFinishedEventList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Completed Activities",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 140,
                  child: CompletedEventList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Uncompleted past activities",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 140,
                  child: UncompletedPastEventList(),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            key: ValueKey("adding_activity"),
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
            }, // onPressed
          ), // floatingActionButton
        ); // Scaffold
      } // builder
    ); // StreamProvider
  } // build
}
