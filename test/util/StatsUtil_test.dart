import 'package:flutter_test/flutter_test.dart';
import 'package:planaholic/models/Event.dart';
import 'package:planaholic/util/StatsUtil.dart';

void main() {
  group("EventToExp", () {
    // roundToNearest5(<duration in hours> * <difficulty> * 3*e)
    test("Event with 0 duration give 0 Exp", () {
      // Arrange
      // Fake event with same start and end time, hence 0 duration
      Event eventWith0Duration = new Event(
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
      int actualExp = StatsUtil.eventToExp(eventWith0Duration);

      // Assert
      expect(actualExp, 0);
    });

    test("Event with 2.25hrs duration & 7 difficulty give 130 Exp", () {
      // Arrange
      // Fake event with same start and end time, hence 0 duration
      Event e = new Event(
        category: "",
        description: "",
        startTime: DateTime(2021, 1, 1, 0, 0),
        endTime: DateTime(2021, 1, 1, 2, 15),
        id: "",
        completed: false,
        passed: false,
        difficulty: 7,
      );

      // Act
      int actualExp = StatsUtil.eventToExp(e);

      // Assert
      expect(actualExp, 130);
    });
  });

  group("expToNextLevel", () {
    // round(10 sqrt(1.5 x) - 2.5) * 10
    test("Exp needed for level 0 to level up is 100", () {
      // Arrange

      // Act
      int actualExp = StatsUtil.expToNextLevel(0);

      // Assert
      expect(actualExp, 100);
    });

    test("Exp needed for level 45 & level 46 to level up are both 810", () {
      // Arrange

      // Act
      int actualExp1 = StatsUtil.expToNextLevel(45);
      int actualExp2 = StatsUtil.expToNextLevel(46);

      // Assert
      expect(actualExp1, 810);
      expect(actualExp2, 810);
      expect(actualExp1, actualExp2);
    });
  });

  group("eventToAttributes", () {
    // round(duration * diff * sqrt(14))
    // add for each /4 if is Others category
    test("Event of Others with 0 duration adds 0 to all attributes", () {
      // Arrange
      Event eventWith0Duration = new Event(
        category: "Others",
        description: "",
        startTime: DateTime(2021, 1, 1, 0, 0),
        endTime: DateTime(2021, 1, 1, 0, 0),
        id: "",
        completed: true,
        passed: true,
        difficulty: 5,
      );

      // Act
      Map actualAdded = StatsUtil.eventToAttributes(eventWith0Duration);

      // Assert
      Map expectedAdded = {
        "Intelligence": 0,
        "Vitality": 0,
        "Spirit": 0,
        "Charm": 0,
        "Resolve": 0,
      };
      expect(actualAdded, expectedAdded);
    });

    test("Event of Arts with 0 duration adds 0 to Resolve & Spirit", () {
      // Arrange
      Event eventWith0Duration = new Event(
        category: "Arts",
        description: "",
        startTime: DateTime(2021, 1, 1, 0, 0),
        endTime: DateTime(2021, 1, 1, 0, 0),
        id: "",
        completed: true,
        passed: true,
        difficulty: 5,
      );

      // Act
      Map actualAdded = StatsUtil.eventToAttributes(eventWith0Duration);

      // Assert
      Map expectedAdded = {
        "Spirit": 0,
        "Resolve": 0,
      };
      expect(actualAdded, expectedAdded);
    });

    test("Event of Others with 1.75hrs 6 difficulty adds 10 to all attributes", () {
      // Arrange
      Event eventWith0Duration = new Event(
        category: "Others",
        description: "",
        startTime: DateTime(2021, 1, 1, 0, 0),
        endTime: DateTime(2021, 1, 1, 1, 45),
        id: "",
        completed: true,
        passed: true,
        difficulty: 6,
      );

      // Act
      Map actualAdded = StatsUtil.eventToAttributes(eventWith0Duration);

      // Assert
      Map expectedAdded = {
        "Intelligence": 10,
        "Vitality": 10,
        "Spirit": 10,
        "Charm": 10,
        "Resolve": 10,
      };
      expect(actualAdded, expectedAdded);
    });

    test("Event of Fitness with 2.2 hrs 5 difficulty adds 10 to Resolve & 41 to Vitality", () {
      // Arrange
      Event eventWith0Duration = new Event(
        category: "Fitness",
        description: "",
        startTime: DateTime(2021, 1, 1, 0, 0),
        endTime: DateTime(2021, 1, 1, 2, 12),
        id: "",
        completed: true,
        passed: true,
        difficulty: 5,
      );

      // Act
      Map actualAdded = StatsUtil.eventToAttributes(eventWith0Duration);

      // Assert
      Map expectedAdded = {
        "Vitality": 41,
        "Resolve": 10,
      };
      expect(actualAdded, expectedAdded);
    });

    test("Event uncompleted with 3.5 hrs 8 difficulty deduct 52 to Resolve", () {
      // Arrange
      Event eventWith0Duration = new Event(
        category: "",
        description: "",
        startTime: DateTime(2021, 1, 1, 0, 0),
        endTime: DateTime(2021, 1, 1, 3, 30),
        id: "",
        completed: false,
        passed: true,
        difficulty: 8,
      );

      // Act
      Map actualAdded = StatsUtil.eventToAttributes(eventWith0Duration);

      // Assert
      Map expectedAdded = {
        "Resolve": -52,
      };
      expect(actualAdded, expectedAdded);
    });
  });
}
