import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plannus/models/Event.dart';

class DbService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final User currentUser = FirebaseAuth.instance.currentUser;
  final CollectionReference events =
      FirebaseFirestore.instance.collection("users")
          .doc(FirebaseAuth.instance.currentUser.uid).collection("events");

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
        startTime: DateTime.parse(doc.get("startTime").toDate().toString()) ?? DateTime.now(),
        endTime: DateTime.parse(doc.get("endTime").toDate().toString()) ?? DateTime.now(),
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

}
