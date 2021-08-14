import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:planaholic/models/Event.dart';
import 'package:planaholic/util/TimeUtil.dart';
import 'package:planaholic/util/StatsUtil.dart';

/// A collection of database service related methods
class DbService {

  /// firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// user events collection reference
  final CollectionReference events = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("events");

  /// current user uuid
  String uuid = FirebaseAuth.instance.currentUser.uid;

  /// user weekly statistics document reference
  DocumentReference weekly = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("stats")
      .doc("weekly");

  /// user counts statistics document reference
  DocumentReference counts = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("stats")
      .doc("counts");

  /// user level statistics document reference
  DocumentReference level = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("stats")
      .doc("level");

  /// user attribute statistics document reference
  DocumentReference attr = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("stats")
      .doc("attributes");

  /// Get the current user profile picture address
  Future<String> getUserProfilePic() async {
    try {
      DocumentSnapshot snapshot = await _db.collection("users").doc(uuid).get();
      return snapshot["profilePic"];
    } catch (error) {
      return null;
    }
  }

  /// Get current username
  Future<String> getUsername() async {
    try {
      DocumentSnapshot snapshot = await _db.collection("users").doc(uuid).get();
      return snapshot["username"];
    } catch (error) {
      return null;
    }
  }


  /// Update current user username to [newName]
  Future<void> updateUsername(String newName) async {
    try {
      await _db.collection("users").doc(uuid).update({
        "username": newName,
      });
    } catch (error) {
      return null;
    }
  }

  /// Get the current user email
  Future<String> getEmail() async {
    try {
      DocumentSnapshot snapshot = await _db.collection("users").doc(uuid).get();
      return snapshot["email"];
    } catch (error) {
      return null;
    }
  }

  /// Add the new [event] to the user's event collection
  Future addNewEvent(Event event) async {
    return await events.add(event.toMap());
  }

  /// Getting the list of event gotten from a snapshot (gotten from a stream)
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

  /// To get a stream of list of events from the database
  Stream<List<Event>> get eventsStream {
    return events.snapshots().map(_eventListFromSnapshot);
  }

  /// Mark the [event] as completed in database.
  ///
  /// Other related stats including levels and attributes are also updated.
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

  /// Mark the [event] as uncompleted in database.
  ///
  /// Other related stats including levels and attributes are also updated.
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

  /// Edit the [old] event to [change]
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

  /// Edit the old event with [id] to [change]
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

  /// Sync the event [id] to its id field in database
  Future<void> syncEventId(String id) async {
    return await events.doc(id).update({"id": id});
  }

  /// Delete the [event] from the database
  Future<void> delete(Event event) async {
    return await events.doc(event.id).delete();
  }

  /// Count the number of completed events of the [category]
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

  /// Get the counts of all passed events of the user
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

  /// Get the user's current level
  Future<int> getUserLevel() async {
    try {
      DocumentSnapshot snapshot = await level.get();
      return snapshot.get("value");
    } catch (error) {
      await initUserLevel();
      return getUserLevel();
    }
  }

  /// Set user level to [level]
  Future<int> _setUserLevel(int level) async {
    try {
      await DbService().level.set({"value": level}, SetOptions(merge: true));
      return level;
    } catch (error) {
      await initUserLevel();
      return _setUserLevel(level);
    }
  }

  /// Level up the user by 1
  Future<int> levelUp() async {
    int currentLevel = await getUserLevel();
    await setUserNextExp(StatsUtil.expToNextLevel(currentLevel + 1));
    return _setUserLevel(currentLevel + 1);
  }

  /// Get the current EXP of the user
  Future<int> getUserCurrentExp() async {
    try {
      DocumentSnapshot snapshot = await level.get();
      return snapshot.get("exp");
    } catch (error) {
      await initUserLevel();
      return getUserCurrentExp();
    }
  }

  /// Set the current EXP of the user to [exp]
  Future<int> setUserCurrentExp(int exp) async {
    try {
      await level.set({"exp": exp}, SetOptions(merge: true));
      return exp;
    } catch (error) {
      await initUserLevel();
      return setUserCurrentExp(exp);
    }
  }

  /// Get the EXP needed for the user to reach the next level
  Future<int> getUserNextExp() async {
    try {
      return (await level.get())["next"];
    } catch (error) {
      await initUserLevel();
      return getUserNextExp();
    }
  }

  /// Set the EXP needed for the user to reach the next level to [exp]
  Future<int> setUserNextExp(int exp) async {
    try {
      await level.set({"next": exp}, SetOptions(merge: true));
      return exp;
    } catch (error) {
      await initUserLevel();
      return setUserNextExp(exp);
    }
  }

  /// Add [exp] to the current user
  ///
  /// Level up the user accordingly until all [exp] are added.
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

  /// Initialise all user level information
  ///
  /// This is used to initialise new user level information.
  Future<void> initUserLevel() async {
    await level.set({
      "category": "level",
      "value": 0,
      "exp": 0,
      "next": 100, // exp required for level 1.
    });
  }

  /// Initialise user weekly stats
  ///
  /// This is use to initialise weekly counts document.
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

  /// Add a count of this [category] event to the weekly counts
  Future<void> addToWeekly(String category) async {
    return await weekly.set({
      "data": {
        category: FieldValue.increment(1),
      },
      "thisMonday": TimeUtil.findFirstDateOfTheWeek(DateTime.now())
    }, SetOptions(merge: true));
  }

  /// Get the weekly counts of the user
  Future getWeekly() async {
    try {
      return (await weekly.get())["data"];
    } catch (error) {
      await initWeekly();
      return getWeekly();
    }
  }

  /// Check and update the weekly counts of the user accordingly.
  ///
  /// Only initialised if it is the next week since last update.
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

  /// Get all user attributes
  Future getUserAttributes() async {
    try {
      return (await attr.get())["data"];
    } catch (error) {
      await initAttributes();
      return getUserAttributes();
    }
  }

  /// Set the user [attribute] value to [value]
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

  /// Reduce user attribute of the [category] to its 80% value
  Future reduceAttributeTo80Percent(String category) async {

    String catToAttr(String category) {
      switch(category) {
        case "Studies":
          return "Intelligence";
          break;
        case "Social":
          return "Charm";
          break;
        case "Arts":
          return "Spirit";
          break;
        case "Fitness":
          return "Vitality";
          break;
        default:
          return null;
      }
    }

    String attribute = catToAttr(category);
    Map attr = await getUserAttributes();
    int currentValue = attr[attribute];
    await _setUserAttribute(category, (currentValue * 0.8).ceil());
  }

  /// Get the last check time for user attributes
  Future getLastCheckTime() async {
    try {
      return (await attr.get())["lastCheckTime"];
    } catch (error) {
      await initAttributes();
      return getLastCheckTime();
    }
  }

  /// Reset time updated for the [attribute] to now
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

  /// Get the count of uncompleted events
  Future<int> getUncompletedCount() async {
    try {
      return (await counts.get())["uncompleted"];
    } catch (error) {
      await counts.set({"uncompleted": 0}, SetOptions(merge: true));
      return getUncompletedCount();
    }
  }

  /// Initialise all user attributes
  ///
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

  /// Initialised the counts of the user
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
  ///
  /// This is done by marking the user database as deleted.
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

  /// Upload new user profile picture [profilePic]
  Future<void> uploadProfilePic(File profilePic) async {
    FirebaseStorage _storage = FirebaseStorage.instance;

    String imagePath = "profilePics/" + uuid + ".jpg";
    await _storage.ref(imagePath).putFile(profilePic);

    // update db users profilePic
    String url = await _storage.ref(imagePath).getDownloadURL();
    return await _db.collection("users").doc(uuid).update({
      "profilePic": url,
    });
  }

  /// Get a list of all events for exporting
  Future<List<Event>> getAllEvents() async {
    QuerySnapshot snapshot = await events.get();
    List<QueryDocumentSnapshot> docs = snapshot.docs;

    List<Event> allEvents = [];
    docs.forEach((element) {
      Event event = new Event(
        description: element["description"],
        startTime: element["startTime"].toDate(),
        endTime: element["endTime"].toDate(),
        // unimportant fields for export
        category: "",
        id: element.id,
        completed: false,
        passed: false,
      );
      allEvents.add(event);
    });

    return allEvents;
  }
}
