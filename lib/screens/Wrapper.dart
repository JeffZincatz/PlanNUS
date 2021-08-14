import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planaholic/screens/authenticate/Authenticate.dart';
import 'package:provider/provider.dart';
import 'home/Navigation.dart';

/// Wrapper page that directs user to either authentication or home page
class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    // return either Navigation or Authenticate widget
    if (user == null || !user.emailVerified) {
      return Authenticate();
    } else {
      return Navigation();
    }

  }
}
