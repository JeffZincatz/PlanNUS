import 'package:plannus/models/Event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }

  Event getEvent(int index) => appointments[index] as Event;

  @override
  DateTime getStartTime(int index) => getEvent(index).startTime;

  @override
  DateTime getEndTime(int index) => getEvent(index).endTime;

  @override
  String getSubject(int index) => getEvent(index).description;

  @override
  Color getColor(int index) {
    Event event = getEvent(index);
    if (event.completed) {
      return Colors.blue;
    } else if (event.passed) {
      return Colors.grey;
    } else if (event.endTime.compareTo(DateTime.now()) <= 0) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}