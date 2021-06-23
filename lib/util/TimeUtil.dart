import 'package:planaholic/models/Event.dart';

class TimeUtil {
  static Duration oneWeek = Duration(days: 7);
  static Duration threeDays = Duration(days: 3);

  static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    DateTime temp = dateTime.subtract(Duration(days: dateTime.weekday - 1));
    return DateTime(temp.year, temp.month, temp.day);
  }

  static double getEvenHours(Event event) {
    Duration d = event.endTime.difference(event.startTime);
    return d.inSeconds / 3600;
  }

  /// Used to reset weekly overview
  static bool isAtLeastOneWeekApart(DateTime t1, DateTime t2) {
    return t1.difference(t2).abs().compareTo(oneWeek) == 1;
  }

  /// Used to deduct attributes for inactivity
  static bool isAtLeastThreeDaysApart(DateTime t1, DateTime t2) {
    return t1.difference(t2).abs().compareTo(threeDays) == 1;
  }
}
