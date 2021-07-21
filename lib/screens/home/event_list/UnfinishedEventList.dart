import 'package:flutter/material.dart';
import 'package:planaholic/services/DbNotifService.dart';
import 'package:provider/provider.dart';
import 'package:planaholic/models/Event.dart';
import 'package:planaholic/screens/home/home_elements/EventTile.dart';
import 'package:planaholic/screens/home/home_elements/EmptyCardWithText.dart';

class UnfinishedEventList extends StatefulWidget {
  const UnfinishedEventList({Key key}) : super(key: key);

  @override
  _UnfinishedEventListState createState() => _UnfinishedEventListState();
}

class _UnfinishedEventListState extends State<UnfinishedEventList> {
  @override
  Widget build(BuildContext context) {

    int comparator(Event a, Event b) {
      int temp = a.startTime.compareTo(b.startTime);
      return temp != 0
          ? temp
          : a.endTime.compareTo(b.endTime);
    }

    List<Event> events = Provider.of<List<Event>>(context) ?? [];

    void updateDbNotif() async {
      for (Event event in events) {
        int notifId = await DbNotifService().findIndex(event.id ?? "not avail");
        if (notifId != null && event.endTime.compareTo(DateTime.now()) < 0) {
          DbNotifService().removeFromTaken(event.id);
          List<dynamic> lsInit = await DbNotifService().getAvailable();
          List<int> ls = lsInit.cast<int>();
          ls.add(notifId);
          DbNotifService().updateAvailable(ls);
        }
      }
    }

    updateDbNotif();

    events = events.where((Event e) => e.endTime.compareTo(DateTime.now()) > 0 && !e.passed).toList();
    if (events.length == 0) {
      return EmptyCardWithText(text: "No upcoming activities. What are you waiting for?");
    }
    events.sort(comparator);
    events = events.length > 10 ? events.sublist(0, 10) : events;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventTile(event: events[index]);
      },
    );
  }
}