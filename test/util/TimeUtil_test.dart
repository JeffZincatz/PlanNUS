import 'package:flutter_test/flutter_test.dart';
import 'package:planaholic/models/Event.dart';
import 'package:planaholic/util/TimeUtil.dart';

void main() {
  group("getEventHours", () {
    test("Event with same start and end time has 0 event hours", () {
      // Arrange
      Event eventWithSameStartEndTime = new Event(
        category: "",
        description: "",
        startTime: DateTime(2021, 1, 1, 0, 0),
        endTime: DateTime(2021, 1, 1, 0, 0),
        id: "",
        completed: false,
        passed: false,
        difficulty: 5,
      );

      // Act
      double actualDuration = TimeUtil.getEvenHours(eventWithSameStartEndTime);

      // Assert
      expect(actualDuration, 0.0);
    });

    test("Event with exact 1 hr duration has 1.0 event duration hour", () {
      // Arrange
      Event eventWith1HourDuration = new Event(
        category: "",
        description: "",
        startTime: DateTime(2021, 1, 1, 0, 0),
        endTime: DateTime(2021, 1, 1, 1, 0),
        id: "",
        completed: false,
        passed: false,
        difficulty: 5,
      );

      // Act
      double actualDuration = TimeUtil.getEvenHours(eventWith1HourDuration);

      // Assert
      expect(actualDuration, 1.0);
    });

    test("Event with exact 2 hr 34 min 57 sec duration has 2.5825 event duration hour", () {
      // Arrange
      Event eventWith1HourDuration = new Event(
        category: "",
        description: "",
        startTime: DateTime(2021, 1, 1, 0, 0),
        endTime: DateTime(2021, 1, 1, 2, 34, 57),
        id: "",
        completed: false,
        passed: false,
        difficulty: 5,
      );

      // Act
      double actualDuration = TimeUtil.getEvenHours(eventWith1HourDuration);

      // Assert
      expect(actualDuration, 2.5825);
    });
  });

  group("findFirstDateOfTheWeek", () {
    test("First date of a Monday at time 00:00:00.000 is itself", () {
      // Arrange
      // 2021/6/21 is a Monday
      DateTime monday = DateTime(2021, 6, 21);

      // Act
      DateTime actualMonday = TimeUtil.findFirstDateOfTheWeek(monday);

      // Assert
      expect(actualMonday, monday);
    });

    test("First date of a 2021/6/20 (Sun) 23:59:59.000 is 2021/6/14 00:00:00.000", () {
      // Arrange
      // 2021/6/20 is a Sunday
      DateTime sunday = DateTime(2021, 6, 20, 23, 59, 59);

      // Act
      DateTime actualMonday = TimeUtil.findFirstDateOfTheWeek(sunday);

      // Assert
      DateTime monday = DateTime(2021, 6, 14);
      expect(actualMonday, monday);
    });
  });

  group("isAtLeastOneWeekApart", () {
    test("2 of the same date time are not at least 1 week apart", () {
      // Arrange
      DateTime d1 = DateTime(2021, 6, 24, 20, 12);

      // Act
      bool actual = TimeUtil.isAtLeastOneWeekApart(d1, d1);

      // Assert
      expect(actual, false);
    });

    test("2021/6/24 20:00:00 & 2021/6/17 20:00:01 are not at least 1 week apart", () {
      // Arrange
      DateTime d1 = DateTime(2021, 6, 24, 20, 00);
      DateTime d2 = DateTime(2021, 6, 17, 20, 00, 1);

      // Act
      bool actual = TimeUtil.isAtLeastOneWeekApart(d1, d2);

      // Assert
      expect(actual, false);
    });

    test("2021/6/24 20:00:00 & 2021/6/17 19:59:59 are at least 1 week apart", () {
      // Arrange
      DateTime d1 = DateTime(2021, 6, 24, 20, 00);
      DateTime d2 = DateTime(2021, 6, 17, 19, 59, 59);

      // Act
      bool actual = TimeUtil.isAtLeastOneWeekApart(d1, d2);

      // Assert
      expect(actual, true);
    });
  });

  group("isAtLeastThreeDaysApart", () {
    test("2 of the same date time are not at least 3 days apart", () {
      // Arrange
      DateTime d1 = DateTime(2021, 6, 24, 20, 12);

      // Act
      bool actual = TimeUtil.isAtLeastThreeDaysApart(d1, d1);

      // Assert
      expect(actual, false);
    });

    test("2021/6/24 20:00:00 & 2021/6/21 20:00:01 are not at least 3 days apart", () {
      // Arrange
      DateTime d1 = DateTime(2021, 6, 24, 20, 00);
      DateTime d2 = DateTime(2021, 6, 21, 20, 00, 1);

      // Act
      bool actual = TimeUtil.isAtLeastThreeDaysApart(d1, d2);

      // Assert
      expect(actual, false);
    });

    test("2021/6/24 20:00:00 & 2021/6/21 19:59:59 are at least 3 days apart", () {
      // Arrange
      DateTime d1 = DateTime(2021, 6, 24, 20, 00);
      DateTime d2 = DateTime(2021, 6, 21, 19, 59, 59);

      // Act
      bool actual = TimeUtil.isAtLeastThreeDaysApart(d1, d2);

      // Assert
      expect(actual, true);
    });
  });

}