import 'package:flutter/material.dart';
import 'package:plannus/util/PresetColors.dart';

class Verifying extends StatefulWidget {
  const Verifying({Key key}) : super(key: key);

  @override
  _VerifyingState createState() => _VerifyingState();
}

class _VerifyingState extends State<Verifying> {
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
            SizedBox(height: 20,),
            Text(
              "Almost there!\nGo check your email and verify to get started!",
              style: TextStyle(
                fontSize: 36,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
