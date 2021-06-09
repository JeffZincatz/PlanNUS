import 'package:plannus/models/Event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plannus/services/DbService.dart';
import 'package:plannus/services/AuthService.dart';
import 'TimeUtil.dart';
import 'dart:math';

class StatsUtil {
  static final DbService _db = DbService();
  static final AuthService _auth = AuthService();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String uuid = _auth.getCurrentUser().uid;

  // Event EXP calculation
  // roundToNearest5(duration(hours) * difficulty * 3*e)
  static int eventToExp(Event event) {
    double hours = TimeUtil.getEvenHours(event);
    return (hours * event.difficulty * 3 * e / 5).round() * 5;
  }

  // EXP required for the next level
  // round(10 sqrt(1.5 x) - 2.5) * 10
  static int expToNextLevel(int current) {
    return (10 * sqrt(1.5 * current + 1) - 2.5).round() * 10;
  }

  // Attribute points added to each category for an event
  // duration * diff * sqrt(14)
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

    int points =
        (TimeUtil.getEvenHours(event) * event.difficulty * sqrt(14)).round();
    if (event.completed) {
      String attr = _catToAttr(event.category);
      if (attr == "Others") {
        int pointsForEach = points ~/ 4;
        return {
          "Intelligence": pointsForEach,
          "Vitality": pointsForEach,
          "Spirit": pointsForEach,
          "Charm": pointsForEach,
          "Resolve": pointsForEach,
        };
      } else {
        return {
          attr: points,
          "Resolve": points ~/ 4,
        };
      }
    } else {
      return {
        "Resolve": -points ~/ 2,
      };
    }
  }

  static void initWeekly() async {
    _firestore
        .collection("users")
        .doc(uuid)
        .collection("stats")
        .doc("weekly")
        .set({
      "lastDeduction": DateTime.now(),
      "data": {
        "Studies": 1,
        "Fitness": 2,
        "Arts": 3,
        "Social": 4,
        "Others": 5,
      }
    });
  }

  static Future<void> addToWeekly(String category) async {
    await _firestore
        .collection("users")
        .doc(uuid)
        .collection("stats")
        .doc("weekly")
        .set({
      "data": {
        category: FieldValue.increment(1),
      }
    }, SetOptions(merge: true));
  }

  /// update user stats Data structure.
// static Future<void> updateStatsDS() async {
//
// }
}
