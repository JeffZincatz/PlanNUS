import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plannus/screens/home/Home.dart';
import 'package:plannus/screens/authenticate/Authenticate.dart';
import 'package:provider/provider.dart';
import 'authenticate/Verifying.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    // return either Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else if (user.emailVerified) {
      return Home();
    } else {
      return Verifying();
    }
  }
}
