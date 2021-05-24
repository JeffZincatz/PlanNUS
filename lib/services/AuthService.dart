import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  // firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // auth change user stream
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  // sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential userCred = await _auth.signInAnonymously();
      return userCred.user;
    } catch (error) {
      print(error.toString()); // TODO: remove temp debug
      return null;
    }
  }

  // sign in with email and password

  // sign up with email and password
  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCred.user;
    } catch (error) {
      print(error); // TODO: remove temp debug
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

}