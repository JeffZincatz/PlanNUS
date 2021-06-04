import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plannus/elements/MyButtons.dart';
import 'package:plannus/util/PresetColors.dart';
import 'package:plannus/services/AuthService.dart';


import '../Wrapper.dart';

class Verifying extends StatefulWidget {
  const Verifying({Key key}) : super(key: key);

  @override
  _VerifyingState createState() => _VerifyingState();
}

class _VerifyingState extends State<Verifying> {
  final AuthService _auth = new AuthService();

  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: PresetColors.blueAccent),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.thumb_up_alt_outlined,
              color: PresetColors.blueAccent,
              size: 72,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Almost there!\nGo check your email and verify before you log in!",
              style: TextStyle(
                fontSize: 36,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              error,
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            MyButtons.roundedBlue(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: "Go Back"
            ),
            TextButton(
              child: Text(
                "Resend verification email"
              ),
              onPressed: () async {
                User user = _auth.getCurrentUser();
                await user.sendEmailVerification().then((_) {
                  Navigator.pop(context);
                  // setState(() => error = "");
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
