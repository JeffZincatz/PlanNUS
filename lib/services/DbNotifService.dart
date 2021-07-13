import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:planaholic/models/Event.dart';
import 'package:planaholic/util/TimeUtil.dart';
import 'package:planaholic/util/StatsUtil.dart';
import 'package:planaholic/services/DbService.dart';

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

  List<int> newLi = List.generate(100, (x) => x);

  Future<void> addInitialAvail() async {
    return await available.set({"available": newLi});
  }

  Future<void> addInitialTaken() async {
    await taken.set({"test": 1});
    await taken.update({"test": FieldValue.delete()});
  }

  Future<void> initialise() async {
    await addInitialTaken();
    await addInitialAvail();
  }

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

  int availableIndex(List<int> ls) {
    return ls[0];
  }

  Future<void> updateAvailable(List<int> ls) async {
    return await available.set({"available": ls});
  }

  Future<void> addToTaken(int index, String id) async {
    await taken.update({id: index});
  }

  Future<void> removeFromTaken(String id) async {
    await taken.update({id: FieldValue.delete()});
  }

  Future<int> findIndex(String id) async {
    DocumentSnapshot snapShot = await taken.get();
    try {
      return snapShot.get(id);
    } catch(e) {
      return null;
    }
  }
}
