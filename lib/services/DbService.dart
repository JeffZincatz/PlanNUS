import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plannus/models/Event.dart';

class DbService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference events = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("events");

  String uuid = FirebaseAuth.instance.currentUser.uid;

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

    CollectionReference stats =
        _db.collection("users").doc(uuid).collection("stats");
    stats.doc(event.category).update({
      "value": FieldValue.increment(1),
    });
    stats.doc("total").update({
      "value": FieldValue.increment(1),
    });

    return await temp.update({
      "passed": true,
      "completed": true,
    });
  }

  Future markUncompleted(Event event) async {
    DocumentReference temp = events.doc(event.id);
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
      "completed": old.completed,
      "passed": old.passed,
      "difficulty": change.difficulty,
    });
  }

  Future<void> delete(Event event) async {
    return await events.doc(event.id).delete();
  }

  Future<int> countCompletedEventByCategory(String category) async {
    DocumentSnapshot snapshot = await _db
        .collection("users")
        .doc(uuid)
        .collection("stats")
        .doc("counts")
        .get();

    if (category == "total") {
      return snapshot.get("total");
    } else {
      return snapshot.get("data")[category];
    }
  }

  Future<Map<String, int>> getAllCompletedEventCount() async {
    return {
      "total": await countCompletedEventByCategory("total"),
      "Studies": await countCompletedEventByCategory("Studies"),
      "Fitness": await countCompletedEventByCategory("Fitness"),
      "Arts": await countCompletedEventByCategory("Arts"),
      "Social": await countCompletedEventByCategory("Social"),
      "Others": await countCompletedEventByCategory("Others"),
    };
  }

  Future<int> getUserLevel() async {
    DocumentSnapshot snapshot = await _db
        .collection("users")
        .doc(uuid)
        .collection("stats")
        .doc("level")
        .get();
    return snapshot.get("value");
  }

  Future<int> getUserCurrentExp() async {
    DocumentSnapshot snapshot = await _db
        .collection("users")
        .doc(uuid)
        .collection("stats")
        .doc("level")
        .get();
    return snapshot.get("exp");
  }

  Future<int> getUserNextExp() async {
    DocumentSnapshot snapshot = await _db
        .collection("users")
        .doc(uuid)
        .collection("stats")
        .doc("level")
        .get();
    return snapshot.get("next");
  }

  /// Reset user level info
  /// Use for initialising new/existing user level info
  Future<void> initUserLevel() async {
    CollectionReference stats =
        _db.collection("users").doc(uuid).collection("stats");

    stats.doc("level").set({
      "category": "level",
      "value": 0,
      "exp": 0,
      "next": 100, // exp required for level 1.
    });
  }

  /// Reset user weekly stats.
  /// Only use to initialise weekly db document.
  void initWeekly() async {
    _db.collection("users").doc(uuid).collection("stats").doc("weekly").set({
      "lastDeduction": DateTime.now(),
      "data": {
        "Studies": 0,
        "Fitness": 0,
        "Arts": 0,
        "Social": 0,
        "Others": 0,
      }
    });
  }

  Future<void> addToWeekly(String category) async {
    await _db
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

  Future getWeekly() async {
    DocumentSnapshot weekly = await _db
        .collection("users")
        .doc(uuid)
        .collection("stats")
        .doc("weekly")
        .get();
    return weekly["data"];
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
