import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plannus/models/Event.dart';
import 'package:plannus/screens/home/EventTile.dart';
import 'package:plannus/screens/home/EmptyCardWithText.dart';

class UncompletedPastEventList extends StatefulWidget {
  const UncompletedPastEventList({Key key}) : super(key: key);

  @override
  _UncompletedPastEventList createState() => _UncompletedPastEventList();
}

class _UncompletedPastEventList extends State<UncompletedPastEventList> {
  @override
  Widget build(BuildContext context) {
    int comparator(Event b, Event a) {
      int temp = a.startTime.compareTo(b.startTime);
      return temp != 0
          ? temp
          : a.endTime.compareTo(b.endTime);
    }

    List<Event> events = Provider.of<List<Event>>(context) ?? [];
    events = events.where((Event e) => e.passed && !e.completed).toList();
    if (events.length == 0) {
      return EmptyCardWithText(text: "No activities to show.");
    }
    events.sort(comparator);
    events = events.length > 10 ? events.sublist(0, 10) : events;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventTile(event: events[index],);
      },
    );
  }
}