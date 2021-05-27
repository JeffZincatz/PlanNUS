import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DbService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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

  Future<int> countAllCompletedEvent() async {
    try {
      User currentUser = _auth.currentUser;
      QuerySnapshot snapshot =
      await _db.collection("users").doc(currentUser.uid)
          .collection("events").get();

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

  Future<int> countCompletedEventByCategory(String category) async {
    try {
      User currentUser = _auth.currentUser;
      QuerySnapshot snapshot =
      await _db.collection("users").doc(currentUser.uid)
          .collection("events").get();

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
}
