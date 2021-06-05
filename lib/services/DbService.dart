import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plannus/models/Event.dart';

class DbService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final User currentUser = FirebaseAuth.instance.currentUser;
  final CollectionReference events = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("events");

  Future<String> getUserProfilePic() async {
    try {
      User currentUser = _auth.currentUser;
      DocumentSnapshot snapshot =
          await _db.collection("users").doc(currentUser.uid).get();
      return snapshot["profilePic"];
    } catch (error) {
      print(error); // TODO: remove temp debug
      return null;
    }
  }

  Future<String> getUsername() async {
    try {
      User currentUser = _auth.currentUser;
      DocumentSnapshot snapshot =
          await _db.collection("users").doc(currentUser.uid).get();
      return snapshot["username"];
    } catch (error) {
      print(error); // TODO: remove temp debug
      return null;
    }
  }

  Future<String> getEmail() async {
    try {
      User currentUser = _auth.currentUser;
      DocumentSnapshot snapshot =
          await _db.collection("users").doc(currentUser.uid).get();
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
      );
    }).toList();
  }

  Stream<List<Event>> get eventsStream {
    return events.snapshots().map(_eventListFromSnapshot);
  }

  Future markCompleted(Event event) async {
    DocumentReference temp = events.doc(event.id);
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
      "completed": false,
      "passed": false,
    });
  }

  void delete(Event event) async {
    return await events.doc(event.id).delete();
  }

  // TODO: improve querying stats by setting up user stats collection in the future
  Future<int> countAllCompletedEvent() async {
    try {
      User currentUser = _auth.currentUser;
      QuerySnapshot snapshot = await _db
          .collection("users")
          .doc(currentUser.uid)
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
      print(error); // TODO: remove temp debug
      return null;
    }
  }

  // TODO: improve querying stats by setting up user stats collection in the future
  Future<int> countCompletedEventByCategory(String category) async {
    try {
      User currentUser = _auth.currentUser;
      QuerySnapshot snapshot = await _db
          .collection("users")
          .doc(currentUser.uid)
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
      print(error); // TODO: remove temp debug
      return null;
    }
  }

  // TODO: improve querying stats by setting up user stats collection in the future
  Future<Map<String, int>> getAllCompletedEventCount() async {
    return {
      "total": await countAllCompletedEvent(),
      "studies": await countCompletedEventByCategory("Studies"),
      "fitness": await countCompletedEventByCategory("Fitness"),
      "arts": await countCompletedEventByCategory("Arts"),
      "social": await countCompletedEventByCategory("Social"),
      "others": await countCompletedEventByCategory("Others"),
    };
  }

  Future<bool> isUserStatsEmpty() async {
    User currentUser = _auth.currentUser;
    QuerySnapshot snapshot = await _db
        .collection("users")
        .doc(currentUser.uid)
        .collection("stats")
        .get();

    List docs = snapshot.docs;
    // print(docs.isEmpty);

    return docs.isEmpty;
  }

  /// Use for initialising new user/old user stats
  Future<void> initUserStats() async {
    User currentUser = _auth.currentUser;
    CollectionReference stats =
        _db.collection("users").doc(currentUser.uid).collection("stats");

    stats.doc("level").set({
      "category": "level",
      "value": 0,
      "exp": 0,
      "next": 100, // exp required for level 1. can be adjusted.
    });

    List<String> categories = [
      "total",
      "Studies",
      "Fitness",
      "Arts",
      "Social",
      "Others"
    ];

    categories.forEach((element) {
      stats.doc(element).set({
        "category": element,
        "value": 0,
      });
    });
  }
}
