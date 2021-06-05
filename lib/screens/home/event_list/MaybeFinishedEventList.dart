import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plannus/models/Event.dart';
import 'package:plannus/screens/home/home_elements/EventTile.dart';
import 'package:plannus/screens/home/home_elements/EmptyCardWithText.dart';

class MaybeFinishedEventList extends StatefulWidget {
  const MaybeFinishedEventList({Key key}) : super(key: key);

  @override
  _MaybeFinishedEventListState createState() => _MaybeFinishedEventListState();
}

class _MaybeFinishedEventListState extends State<MaybeFinishedEventList> {
  @override
  Widget build(BuildContext context) {
    int comparator(Event b, Event a) {
      int temp = a.startTime.compareTo(b.startTime);
      return temp != 0
          ? temp
          : a.endTime.compareTo(b.endTime);
    }

    List<Event> events = Provider.of<List<Event>>(context) ?? [];
    events = events.where((Event e) => e.endTime.compareTo(DateTime.now()) <= 0 && !e.passed).toList();
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
