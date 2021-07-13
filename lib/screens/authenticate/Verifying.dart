import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planaholic/elements/MyButtons.dart';
import 'package:planaholic/util/PresetColors.dart';
import 'package:planaholic/services/AuthService.dart';

class Verifying extends StatefulWidget {
  const Verifying({Key key}) : super(key: key);

  @override
  _VerifyingState createState() => _VerifyingState();
}

class _VerifyingState extends State<Verifying> {
  final AuthService _auth = new AuthService();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(backgroundColor: PresetColors.blueAccent),
      body: ListView(
        children: [Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: screenHeight * 0.025,
              ),
              Icon(
                Icons.thumb_up_alt_outlined,
                color: PresetColors.blueAccent,
                size: screenHeight * 0.12,
              ),
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Text(
                "Almost there!\nGo check your email and verify before you log in!",
                style: TextStyle(
                  fontSize: screenHeight * 0.055,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: screenHeight * 0.1,
              ),
              MyButtons.roundedBlue(
                key: ValueKey("verifying-go-back-button"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: "Go Back"
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              TextButton(
                key: ValueKey("verifying-resend-verification-email"),
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
        )],
      ),
    );
  }
}
