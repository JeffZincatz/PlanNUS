import 'package:planaholic/models/Event.dart';
import 'TimeUtil.dart';
import 'dart:math';

/// A collection of user statistics related utility methods
class StatsUtil {

  /// Calculate the EXP gained from an [event]
  ///
  /// The calculation uses the following formula:
  /// roundToNearest5(duration(hours) * difficulty * 3*e)
  static int eventToExp(Event event) {
    double hours = TimeUtil.getEvenHours(event);
    return (hours * event.difficulty * 3 * e / 5).round() * 5;
  }

  /// Calculate the EXP required for the next level of the [currentLvl]
  ///
  /// The calculation uses the following formula:
  /// round(10 sqrt(1.5 x) - 2.5) * 10
  static int expToNextLevel(int currentLvl) {
    return (10 * sqrt(1.5 * (currentLvl + 1)) - 2.5).round() * 10;
  }

  /// Calculate the resulted attribute point changes by an [event]
  ///
  /// The calculation uses the following formula:
  /// round(duration * diff * sqrt(14))
  /// Add points/4 for each attribute if [event] is Others category
  static Map<String, int> eventToAttributes(Event event) {
    String _catToAttr(String cat) {
      switch (cat) {
        case "Studies":
          return "Intelligence";
        case "Fitness":
          return "Vitality";
        case "Arts":
          return "Spirit";
        case "Social":
          return "Charm";
        default:
          return "Others";
      }
    }

    double points =
        TimeUtil.getEvenHours(event) * event.difficulty * sqrt(14);
    if (event.completed) {
      String attr = _catToAttr(event.category);
      if (attr == "Others") {
        int pointsForEach = (points / 4).round();
        return {
          "Intelligence": pointsForEach,
          "Vitality": pointsForEach,
          "Spirit": pointsForEach,
          "Charm": pointsForEach,
          "Resolve": pointsForEach,
        };
      } else {
        return {
          attr: points.round(),
          "Resolve": (points / 4).round(),
        };
      }
    } else {
      return {
        "Resolve": -(points / 2).round(),
      };
    }
  }
}
