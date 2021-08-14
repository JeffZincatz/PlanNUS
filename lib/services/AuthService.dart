import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// A collection of authentication service related methods
class AuthService {
  /// firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// auth change user stream
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  /// Sign in with [email] and [password]
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCred.user;
    } catch (error) {
      return null;
    }
  }

  /// Sign up with [email] and [password]
  Future signUpWithEmailAndPassword(String username, String email, String password) async {
    try {
      UserCredential userCred = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((cred) {
        _db.collection("users").doc(cred.user.uid).set({
          "username": username,
          "email": email,
          "profilePic": "https://firebasestorage.googleapis.com/v0/b/plannus-5a15b.appspot.com/o/images%2Fdefault_cat.jpg?alt=media&token=b382e580-2822-46f8-a5e5-0157c6257449",
        });
        return cred;
      });
      return userCred.user;
    } catch (error) {
      return null;
    }
  }

  /// Sign out of current user account
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      return null;
    }
  }

  /// Get the current logged in user
  User getCurrentUser() {
    return _auth.currentUser;
  }

  /// Send password reset email to [email]
  Future<void> sendPasswordResetEmail({String email}) async {
    return await _auth.sendPasswordResetEmail(email: email);
  }

  /// Change user old password to [password]
  ///
  /// Note that this function does not validate for password strength.
  /// Validation should be done by the form.
  Future<void> changePassword({String password}) async {
    return _auth.currentUser.updatePassword(password);
  }

  /// Permanently remove current user from Firebase auth
  ///
  /// It requires recent sign in.
  /// Use with care as it removed the user auth information.
  Future deleteUser() async {
    return _auth.currentUser.delete();
  }
}
