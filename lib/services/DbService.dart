import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:planaholic/models/Event.dart';
import 'package:planaholic/util/TimeUtil.dart';
import 'package:planaholic/util/StatsUtil.dart';

class DbService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference events = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("events");

  String uuid = FirebaseAuth.instance.currentUser.uid;

  DocumentReference weekly = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("stats")
      .doc("weekly");

  DocumentReference counts = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("stats")
      .doc("counts");

  DocumentReference level = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("stats")
      .doc("level");

  DocumentReference attr = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("stats")
      .doc("attributes");

  Future<String> getUserProfilePic() async {
    try {
      DocumentSnapshot snapshot = await _db.collection("users").doc(uuid).get();
      return snapshot["profilePic"];
    } catch (error) {
      print(error); // TODO: remove temp debug
      return null;
    }
  }

  Future<void> updateUserProfilePic(String url) async {
    try {
      await _db.collection("users").doc(uuid).update({
        "profilePic": url,
      });
    } catch (error) {
      print(error); // TODO: remove temp debug
      return null;
    }
  }

  Future<String> getUsername() async {
    try {
      DocumentSnapshot snapshot = await _db.collection("users").doc(uuid).get();
      return snapshot["username"];
    } catch (error) {
      print(error); // TODO: remove temp debug
      return null;
    }
  }

  Future<void> updateUsername(String newName) async {
    try {
      await _db.collection("users").doc(uuid).update({
        "username": newName,
      });
    } catch (error) {
      print(error); // TODO: remove temp debug
      return null;
    }
  }

  Future<String> getEmail() async {
    try {
      DocumentSnapshot snapshot = await _db.collection("users").doc(uuid).get();
      return snapshot["email"];
    } catch (error) {
      print(error); // TODO: remove temp debug
      return null;
    }
  }

  Future addNewEvent(Event event) async {
    return await events.add(event.toMap());
  }

  List<Event> _eventListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Event(
        id: doc.id ?? 1,
        completed: doc.get("completed") ?? false,
        passed: doc.get("passed") ?? false,
        category: doc.get("category") ?? '',
        description: doc.get("description") ?? '',
        startTime: DateTime.parse(doc.get("startTime").toDate().toString()) ??
            DateTime.now(),
        endTime: DateTime.parse(doc.get("endTime").toDate().toString()) ??
            DateTime.now(),
        difficulty: doc.get("difficulty") ?? 5,
      );
    }).toList();
  }

  Stream<List<Event>> get eventsStream {
    return events.snapshots().map(_eventListFromSnapshot);
  }

  Future markCompleted(Event event) async {
    DocumentReference temp = events.doc(event.id);

    // overall counts
    counts.set({
      "data": {
        event.category: FieldValue.increment(1),
      },
      "total": FieldValue.increment(1)
    }, SetOptions(merge: true));

    // weekly overview
    addToWeekly(event.category);

    // raise exp
    int expGained = StatsUtil.eventToExp(event);
    _addExpBy(expGained);

    // this is for attribute calculation only
    // somehow modifying event's param does not work
    Event eventTemp = Event(
        category: event.category,
        description: event.description,
        startTime: event.startTime,
        endTime: event.endTime,
        id: event.id,
        passed: true,
        completed: true,
        difficulty: event.difficulty);
    Map added = StatsUtil.eventToAttributes(eventTemp);
    // okay
    var data = await getUserAttributes();
    added.forEach((key, value) async {
      int currValue = data[key];
      _setUserAttribute(key, currValue + value);
    });

    if (event.category == "Others") {
      attr.set({
        "lastCheckTime": {
          "Intelligence": DateTime.now(),
          "Vitality": DateTime.now(),
          "Spirit": DateTime.now(),
          "Charm": DateTime.now(),
          "Resolve": DateTime.now(),
        }
      }, SetOptions(merge: true));
    } else {
      attr.set({
        "lastCheckTime": {
          event.category: DateTime.now(),
        }
      }, SetOptions(merge: true));
    }

    return await temp.update({
      "passed": true,
      "completed": true,
    });
  }

  Future markUncompleted(Event event) async {
    DocumentReference temp = events.doc(event.id);

    counts.set({
      "uncompleted": FieldValue.increment(1),
    }, SetOptions(merge: true));

    await addToWeekly("uncompleted");

    int decreased = StatsUtil.eventToAttributes(event)["Resolve"];
    attr.set({
      "data": {
        "Resolve": FieldValue.increment(decreased),
      }
    }, SetOptions(merge: true));

    return await temp.update({
      "passed": true,
      "completed": false,
    });
  }

  Future editEvent(Event old, Event change) async {
    return await events.doc(old.id).set({
      "category": change.category,
      "description": change.description,
      "startTime": change.startTime,
      "endTime": change.endTime,
      "id": change.id,
      "completed": old.completed,
      "passed": old.passed,
      "difficulty": change.difficulty,
    });
  }

  Future editEvent2(String id, Event change) async {
    return await events.doc(id).set({
      "category": change.category,
      "description": change.description,
      "startTime": change.startTime,
      "id": change.id,
      "endTime": change.endTime,
      "completed": change.completed,
      "passed": change.passed,
      "difficulty": change.difficulty,
    });
  }

  Future<void> delete(Event event) async {
    return await events.doc(event.id).delete();
  }

  Future<int> countCompletedEventByCategory(String category) async {
    try {
      DocumentSnapshot snapshot = await counts.get();

      int res;
      if (category == "total") {
        res = snapshot.get("total");
      } else {
        res = snapshot.get("data")[category];
      }
      return res == null ? 0 : res;
    } catch (error) {
      await initCounts();
      return countCompletedEventByCategory(category);
    }
  }

  Future<Map<String, int>> getAllPassedEventCount() async {
    return {
      "total": await countCompletedEventByCategory("total"),
      "Studies": await countCompletedEventByCategory("Studies"),
      "Fitness": await countCompletedEventByCategory("Fitness"),
      "Arts": await countCompletedEventByCategory("Arts"),
      "Social": await countCompletedEventByCategory("Social"),
      "Others": await countCompletedEventByCategory("Others"),
      "uncompleted": await getUncompletedCount(),
    };
  }

  Future<int> getUserLevel() async {
    try {
      DocumentSnapshot snapshot = await level.get();
      return snapshot.get("value");
    } catch (error) {
      await initUserLevel();
      return getUserLevel();
    }
  }

  Future<int> _setUserLevel(int level) async {
    try {
      await DbService().level.set({"value": level}, SetOptions(merge: true));
      return level;
    } catch (error) {
      await initUserLevel();
      return _setUserLevel(level);
    }
  }

  Future<int> levelUp() async {
    int currentLevel = await getUserLevel();
    await setUserNextExp(StatsUtil.expToNextLevel(currentLevel + 1));
    return _setUserLevel(currentLevel + 1);
  }

  Future<int> getUserCurrentExp() async {
    try {
      DocumentSnapshot snapshot = await level.get();
      return snapshot.get("exp");
    } catch (error) {
      await initUserLevel();
      return getUserCurrentExp();
    }
  }

  Future<int> setUserCurrentExp(int exp) async {
    try {
      await level.set({"exp": exp}, SetOptions(merge: true));
      return exp;
    } catch (error) {
      await initUserLevel();
      return setUserCurrentExp(exp);
    }
  }

  Future<int> getUserNextExp() async {
    try {
      return (await level.get())["next"];
    } catch (error) {
      await initUserLevel();
      return getUserNextExp();
    }
  }

  Future<int> setUserNextExp(int exp) async {
    try {
      await level.set({"next": exp}, SetOptions(merge: true));
      return exp;
    } catch (error) {
      await initUserLevel();
      return setUserNextExp(exp);
    }
  }

  Future<void> _addExpBy(int exp) async {
    int currExp = await getUserCurrentExp();
    int currLevel = await getUserLevel();
    int nextExp = StatsUtil.expToNextLevel(currLevel);

    if (exp + currExp < nextExp) {
      level.set({
        "exp": exp + currExp,
      }, SetOptions(merge: true));
    } else {
      levelUp();
      return _addExpBy(exp - (nextExp - currExp));
    }
  }

  /// Reset user level info
  /// Use for initialising new/existing user level info
  Future<void> initUserLevel() async {
    await level.set({
      "category": "level",
      "value": 0,
      "exp": 0,
      "next": 100, // exp required for level 1.
    });
  }

  /// Reset user weekly stats.
  /// Only use to initialise weekly db document.
  Future<void> initWeekly() async {
    weekly.set({
      "thisMonday": TimeUtil.findFirstDateOfTheWeek(DateTime.now()),
      "data": {
        "Studies": 0,
        "Fitness": 0,
        "Arts": 0,
        "Social": 0,
        "Others": 0,
        "uncompleted": 0,
      }
    });
  }

  Future<void> addToWeekly(String category) async {
    return await weekly.set({
      "data": {
        category: FieldValue.increment(1),
      },
      "thisMonday": TimeUtil.findFirstDateOfTheWeek(DateTime.now())
    }, SetOptions(merge: true));
  }

  Future getWeekly() async {
    try {
      return (await weekly.get())["data"];
    } catch (error) {
      await initWeekly();
      return getWeekly();
    }
  }

  Future<bool> updateWeekly() async {
    try {
      DateTime thisMonday = (await weekly.get())["thisMonday"].toDate();
      if (TimeUtil.isAtLeastOneWeekApart(DateTime.now(), thisMonday)) {
        initWeekly();
        return true;
      }
      return false;
    } catch (error) {
      await initWeekly();
      return updateWeekly();
    }
  }

  Future getUserAttributes() async {
    try {
      Map temp = {
        "Intelligence": 50, // Studies
        "Vitality": 50, // Fitness
        "Spirit": 50, // Arts
        "Charm": 50, // Social
        "Resolve": 50, // completed/uncompleted
      };

      Map res = (await attr.get())["data"];
      // res.forEach((key, value) {
      //   temp[key] = (value / 10).round();
      // });
      return res;
    } catch (error) {
      await initAttributes();
      return getUserAttributes();
    }
  }

  Future<Map<String, int>> _setUserAttribute(
      String attribute, int value) async {
    try {
      await attr.set({
        "data": {
          attribute: value > 1000 ? 1000 : value,
        }
      }, SetOptions(merge: true));
      return {
        attribute: value,
      };
    } catch (error) {
      await initAttributes();
      return _setUserAttribute(attribute, value);
    }
  }

  Future reduceAttributeTo80Percent(String attribute) async {
    Map attr = await getUserAttributes();
    int currentValue = attr[attribute];
    await _setUserAttribute(attribute, (currentValue * 0.8).ceil());
  }

  Future getLastCheckTime() async {
    try {
      return (await attr.get())["lastCheckTime"];
    } catch (error) {
      await initAttributes();
      return getLastCheckTime();
    }
  }

  /// reset timestamp for the attribute to now
  Future refreshLastCheckTime(String attribute) async {
    try {
      return await attr.set({
        "lastCheckTime": {attribute: DateTime.now()}
      }, SetOptions(merge: true));
    } catch (error) {
      await initAttributes();
      return refreshLastCheckTime(attribute);
    }
  }

  Future<int> getUncompletedCount() async {
    try {
      return (await counts.get())["uncompleted"];
    } catch (error) {
      await counts.set({"uncompleted": 0}, SetOptions(merge: true));
      return getUncompletedCount();
    }
  }

  /// Initialise user attributes.
  /// All attributes range from 0 to 1000, 500 by default.
  /// When displayed, an attribute should be <value> ~/ 10.
  Future<void> initAttributes() async {
    await attr.set({
      "data": {
        "Intelligence": 500, // Studies
        "Vitality": 500, // Fitness
        "Spirit": 500, // Arts
        "Charm": 500, // Social
        "Resolve": 500, // completed/uncompleted
      },
      "lastCheckTime": {
        "Intelligence": DateTime.now(),
        "Vitality": DateTime.now(),
        "Spirit": DateTime.now(),
        "Charm": DateTime.now(),
        "Resolve": DateTime.now(),
      },
    });
  }

  Future<void> initCounts() async {
    counts.set({
      "data": {
        "Arts": 0,
        "Fitness": 0,
        "Others": 0,
        "Social": 0,
        "Studies": 0,
      },
      "total": 0,
      "uncompleted": 0,
    });
  }

  /// Pseudo-remove current user from Firebase auth.
  Future<void> deleteUserData() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({"deleted": true}, SetOptions(merge: true));

    // // Below uses true delete. Use with care.
    // return FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(FirebaseAuth.instance.currentUser.uid)
    //     .delete();
  }

  /*
  Below are some debugging functions. They should not be used in any feature implementations.
  They should be okay to be removed in the end.
   */

  Future<bool> userLevelExists() async {
    DocumentSnapshot snapshot = await _db
        .collection("users")
        .doc(uuid)
        .collection("stats")
        .doc("level")
        .get();

    return snapshot.exists;
  }

  // TODO: Remove helper method
  /// Sync user stats from event collection, iteratively.
  /// This should only be called for existing users & used for debugging purposes.
  Future<void> syncUserStats() async {
    try {
      /// iteratively count from user events collection
      Function oldCountCompletedEventByCategory = (String category) async {
        try {
          QuerySnapshot snapshot = await _db
              .collection("users")
              .doc(uuid)
              .collection("events")
              .get();

          int count = 0;
          snapshot.docs.forEach((each) {
            Map data = each.data();
            if (data["category"] == category && data["completed"]) {
              count++;
            }
          });
          return count;
        } catch (error) {
          return null;
        }
      };

      /// iteratively count from user events collection
      Function oldCountTotal = () async {
        try {
          QuerySnapshot snapshot = await _db
              .collection("users")
              .doc(uuid)
              .collection("events")
              .get();

          int count = 0;
          snapshot.docs.forEach((each) {
            Map data = each.data();
            if (data["completed"]) {
              count++;
            }
          });
          return count;
        } catch (error) {
          return null;
        }
      };

      CollectionReference stats =
          _db.collection("users").doc(uuid).collection("stats");

      List<String> categories = [
        "Studies",
        "Fitness",
        "Arts",
        "Social",
        "Others"
      ];

      // writes into the new data structure
      categories.forEach((element) async {
        stats.doc("counts").set({
          "data": {
            element: await oldCountCompletedEventByCategory(element),
          }
        }, SetOptions(merge: true));
      });
      stats.doc("counts").set({
        "total": await oldCountTotal(),
      }, SetOptions(merge: true));

      print("sync finished");
    } catch (error) {
      print(error); // TODO: remove temp debug
      return null;
    }
  }
}
