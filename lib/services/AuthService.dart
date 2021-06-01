import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // auth change user stream
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  // sign in anonymously
  @deprecated
  Future signInAnon() async {
    try {
      UserCredential userCred = await _auth.signInAnonymously();
      return userCred.user;
    } catch (error) {
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCred.user;
    } catch (error) {
      print(error); // TODO: remove temp debug
      return null;
    }
  }

  // sign up with email and password
  Future signUpWithEmailAndPassword(String username, String email, String password) async {
    try {
      UserCredential userCred = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((cred) {
        _db.collection("users").doc(cred.user.uid).set({
          "username": username,
          "email": email,
          "profilePic": "https://firebasestorage.googleapis.com/v0/b/plannus-5a15b.appspot.com/o/images%2Fdefault_cat.jpg?alt=media&token=b382e580-2822-46f8-a5e5-0157c6257449",
          "stats": null,
        });
        return cred;
      });
      return userCred.user;
    } catch (error) {
      print(error); // TODO: remove temp debug
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString()); //TODO: remove temp debug
      return null;
    }
  }

  // get current user
  User getCurrentUser() {
    return _auth.currentUser;
  }
}
