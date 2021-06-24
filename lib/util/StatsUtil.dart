import 'package:planaholic/models/Event.dart';
import 'TimeUtil.dart';
import 'dart:math';

class StatsUtil {

  // Event EXP calculation
  // roundToNearest5(duration(hours) * difficulty * 3*e)
  static int eventToExp(Event event) {
    double hours = TimeUtil.getEvenHours(event);
    return (hours * event.difficulty * 3 * e / 5).round() * 5;
  }

  // EXP required for the next level
  // round(10 sqrt(1.5 x) - 2.5) * 10
  static int expToNextLevel(int currentLvl) {
    return (10 * sqrt(1.5 * (currentLvl + 1)) - 2.5).round() * 10;
  }

  // Attribute points added to each category for an event
  // round(duration * diff * sqrt(14))
  // add for each /4 if is Others category
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
