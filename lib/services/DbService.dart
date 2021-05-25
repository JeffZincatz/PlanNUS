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
}
