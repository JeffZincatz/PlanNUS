import 'package:plannus/models/Event.dart';

class TimeUtil {
  // static Duration oneWeek = Duration(days: 7);

  static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  static double getEvenHours(Event event) {
    Duration d = event.endTime.difference(event.startTime);
    return d.inSeconds / 3600;
  }

  static bool isNowOneWeekLater(DateTime time) {
    return time.difference(DateTime.now()).abs() > Duration(days: 7);
  }
}
