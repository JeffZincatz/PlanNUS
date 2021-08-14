import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:provider/provider.dart';
import 'package:planaholic/models/Event.dart';
import 'package:planaholic/models/EventDataSource.dart';
import 'package:planaholic/screens/home/home_elements/TaskWidget.dart';

/// The abstraction for the calendar UI
class Calendar2 extends StatefulWidget {

  final Function updateCurrentDate;

  Calendar2({this.updateCurrentDate});

  @override
  _Calendar2State createState() => _Calendar2State();
}

class _Calendar2State extends State<Calendar2> {
  final CalendarController _calendarController= CalendarController();

  @override
  Widget build(BuildContext context) {

    List<Event> events = Provider.of<List<Event>>(context) ?? [];

    return SfCalendar(
      monthViewSettings: MonthViewSettings(
        appointmentDisplayCount: 7
      ),
      dataSource: EventDataSource(events),
      controller: _calendarController,
      headerStyle: CalendarHeaderStyle(
        textAlign: TextAlign.left,
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
      view: CalendarView.month,
      showNavigationArrow: true,
      showDatePickerButton: true,
      onViewChanged: (ViewChangedDetails details) {
        List<DateTime> dateTimes = details.visibleDates;
        int mid = (dateTimes.length / 2).round();
        DateTime midOfMonth = dateTimes[mid];
        if (midOfMonth.year == DateTime.now().year && midOfMonth.month == DateTime.now().month) {
          widget.updateCurrentDate(
              new DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day
              )
          );
          SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
            _calendarController.selectedDate = new DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day
            );
          });
        } else {
        widget.updateCurrentDate(
          new DateTime(
            midOfMonth.year,
            midOfMonth.month,
            1
          )
        );
        SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
          _calendarController.selectedDate = new DateTime(
            midOfMonth.year,
            midOfMonth.month,
            1
          );
        });
        }

        // _calendarController.selectedDate = new DateTime(
        //     midOfMonth.year,
        //     midOfMonth.month,
        //     1
        // );

      },
      initialSelectedDate: DateTime.now(),
      onTap: (CalendarTapDetails details) {
        widget.updateCurrentDate(details.date);
      },
      onLongPress: (CalendarLongPressDetails detail) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return TaskWidget(date: detail.date, events: events);
          },
        );
      },
    );
  }
}
