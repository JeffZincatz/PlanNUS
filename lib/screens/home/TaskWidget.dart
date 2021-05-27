import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plannus/models/Event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:plannus/models/EventDataSource.dart';


class TaskWidget extends StatefulWidget {

  final DateTime date;
  final List<Event> events;
  TaskWidget({this.date, this.events});

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {

  bool sameDay(DateTime first, DateTime second) {
    return (first.year == second.year
        && first.month == second.month
        && first.day == second.day);
  }

  @override
  Widget build(BuildContext context) {
    // List<Event> events = Provider.of<List<Event>>(context) ?? [];
    List<Event> selectedEvents = widget.events.where((event) => sameDay(event.startTime, widget.date)).toList();

    if (selectedEvents.isEmpty) {
      return Center(
        child: Text(
          "No events found",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      );
    } else {
      return SfCalendar(
        view: CalendarView.timelineDay,
        dataSource: EventDataSource(selectedEvents),
        minDate: widget.date,
        maxDate: widget.date.add(Duration(hours: 24)),
        initialDisplayDate: widget.date,
        headerStyle: CalendarHeaderStyle(
          textAlign: TextAlign.center,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      );
    }
  }
}
