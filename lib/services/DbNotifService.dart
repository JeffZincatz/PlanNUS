import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// A collection of methods concerning database services that aid in notifications
class DbNotifService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference notif = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("notif");

  String uuid = FirebaseAuth.instance.currentUser.uid;

  DocumentReference available = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("notif")
      .doc("available");

  DocumentReference taken = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("notif")
      .doc("taken");

  DocumentReference before = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("notif")
      .doc("before");

  List<int> newLi = List.generate(100, (x) => x);

  /// To initialise the available field
  Future<void> addInitialAvail() async {
    return await available.set({"available": newLi});
  }

  /// To initialise the taken field
  Future<void> addInitialTaken() async {
    await taken.set({"test": 1});
    await taken.update({"test": FieldValue.delete()});
  }

  /// To initialise taken and available field
  Future<void> initialise() async {
    await addInitialTaken();
    await addInitialAvail();
  }

  /// To initialise the "before" field
  Future<void> initialiseBefore() async {
    await before.set({"before": 10});
  }

  /// get the available indexes for notifications
  Future<List<dynamic>> getAvailable() async {
    try {
      DocumentSnapshot snapshot = await available.get();
      return snapshot.get("available");
    } catch(e) {
      await initialise();
      DocumentSnapshot snapshot = await available.get();
      return snapshot.get("available");
    }
  }

  /// Get the "before" (how early does the person want to be notified)
  Future<int> getBefore() async {
    try {
      DocumentSnapshot snapshot = await before.get();
      return snapshot.get("before");
    } catch(e) {
      await initialiseBefore();
      DocumentSnapshot snapshot = await before.get();
      return snapshot.get("before");
    }
  }

  /// Return AN available index
  int availableIndex(List<int> ls) {
    return ls[0];
  }

  /// Update the "before" field
  Future<void> updateBefore(int x) async {
    return await before.set({"before": x});
  }

  /// Update the "available" field
  Future<void> updateAvailable(List<int> ls) async {
    return await available.set({"available": ls});
  }

  /// Update the "taken" field by adding an index attached to an id
  Future<void> addToTaken(int index, String id) async {
    await taken.update({id: index});
  }

  /// Update the "taken" field by removing an index attached to an id
  Future<void> removeFromTaken(String id) async {
    await taken.update({id: FieldValue.delete()});
  }

  /// Get a notification index of an event id
  Future<int> findIndex(String id) async {
    DocumentSnapshot snapShot = await taken.get();
    try {
      return snapShot.get(id);
    } catch(e) {
      return null;
    }
  }
}
