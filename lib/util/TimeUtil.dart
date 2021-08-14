import 'package:planaholic/models/Event.dart';

/// A collection of time calculation related utility methods
class TimeUtil {
  static final Duration _oneWeek = Duration(days: 7);
  static final Duration _threeDays = Duration(days: 3);

  /// Find the first date of the week that the given [dateTime] is in
  static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    DateTime temp = dateTime.subtract(Duration(days: dateTime.weekday - 1));
    return DateTime(temp.year, temp.month, temp.day);
  }

  /// Calculate the duration of the [event] in hours
  static double getEvenHours(Event event) {
    Duration d = event.endTime.difference(event.startTime);
    return d.inSeconds / 3600;
  }

  /// Check if datetime [t1] and [t2] are at least 1 week apart
  ///
  /// Used to reset weekly overview.
  static bool isAtLeastOneWeekApart(DateTime t1, DateTime t2) {
    return t1.difference(t2).abs().compareTo(_oneWeek) > 0;
  }

  /// Check if datetime [t1] and [t2] are at least 3 days apart
  ///
  /// Used to deduct attributes for inactivity
  static bool isAtLeastThreeDaysApart(DateTime t1, DateTime t2) {
    return t1.difference(t2).abs().compareTo(_threeDays) > 0;
  }
}
