import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plannus/models/Event.dart';
import 'package:plannus/screens/home/EventTile.dart';
import 'package:plannus/screens/home/EmptyCardWithText.dart';

class CompletedEventList extends StatefulWidget {
  const CompletedEventList({Key key}) : super(key: key);

  @override
  _CompletedEventList createState() => _CompletedEventList();
}

class _CompletedEventList extends State<CompletedEventList> {
  @override
  Widget build(BuildContext context) {
    int comparator(Event b, Event a) {
      int temp = a.startTime.compareTo(b.startTime);
      return temp != 0
          ? temp
          : a.endTime.compareTo(b.endTime);
    }

    List<Event> events = Provider.of<List<Event>>(context) ?? [];
    events = events.where((Event e) => e.completed).toList();
    if (events.length == 0) {
      return EmptyCardWithText(text: "No completed activities yet. Start doing your activities now!");
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