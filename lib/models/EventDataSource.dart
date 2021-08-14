import 'package:planaholic/models/Event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

/// A class to represents all the events that will be fed to the calendar
class EventDataSource extends CalendarDataSource {
  /// Constructor for the EventDataSource that takes in a list of Events
  EventDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }

  /// Get a particular event at [index]
  Event getEvent(int index) => appointments[index] as Event;

  /// Get start time of a particular event at [index]
  @override
  DateTime getStartTime(int index) => getEvent(index).startTime;

  /// Get end time of a particular event at [index]
  @override
  DateTime getEndTime(int index) => getEvent(index).endTime;

  /// Get subject of a particular event at [index]
  @override
  String getSubject(int index) => getEvent(index).description;

  /// Get the color representation of a particular event at [index]
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