import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plannus/models/Event.dart';
import 'package:plannus/screens/home/EventTile.dart';

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
    events = events.where((Event e) => e.endTime.compareTo(DateTime.now()) > 0 && !e.completed).toList();
    events.sort(comparator);

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventTile(event: events[index]);
      },
    );
  }
}