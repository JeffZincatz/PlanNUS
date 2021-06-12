import 'package:plannus/models/Event.dart';

class TimeUtil {
  static Duration oneWeek = Duration(days: 7);

  static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    DateTime temp = dateTime.subtract(Duration(days: dateTime.weekday - 1));
    return DateTime(temp.year, temp.month, temp.day);
  }

  static double getEvenHours(Event event) {
    Duration d = event.endTime.difference(event.startTime);
    return d.inSeconds / 3600;
  }

  static bool isAtLeastOneWeekApart(DateTime t1, DateTime t2) {
    return t1.difference(t2).abs().compareTo(oneWeek) == 1;
  }
}
