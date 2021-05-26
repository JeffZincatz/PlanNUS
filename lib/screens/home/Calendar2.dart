import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar2 extends StatefulWidget {
  final Function updateCurrentDate;

  Calendar2({this.updateCurrentDate});

  @override
  _Calendar2State createState() => _Calendar2State();
}

class _Calendar2State extends State<Calendar2> {
  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      headerStyle: CalendarHeaderStyle(
        textAlign: TextAlign.center,
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
      view: CalendarView.month,
      initialSelectedDate: DateTime.now(),
      onTap: (CalendarTapDetails details) {
        widget.updateCurrentDate(details.date);
      },
    );
  }
}
