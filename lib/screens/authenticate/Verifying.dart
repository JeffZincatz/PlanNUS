import 'package:flutter/material.dart';
import 'package:plannus/util/PresetColors.dart';
import 'package:plannus/services/AuthService.dart';

class Verifying extends StatefulWidget {
  const Verifying({Key key}) : super(key: key);

  @override
  _VerifyingState createState() => _VerifyingState();
}

class _VerifyingState extends State<Verifying> {
  final AuthService _auth = new AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: PresetColors.blueAccent),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.thumb_up_alt_outlined,
              color: PresetColors.blueAccent,
              size: 60,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Almost there!\nGo check your email and verify to get started!",
              style: TextStyle(
                fontSize: 36,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              child: Text(
                "Switch User",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: PresetColors.blueAccent,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
