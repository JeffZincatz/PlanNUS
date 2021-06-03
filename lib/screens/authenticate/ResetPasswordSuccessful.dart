import 'package:flutter/material.dart';
import 'package:plannus/util/PresetColors.dart';

class ResetPasswordSuccessful extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: PresetColors.blueAccent),
      backgroundColor: PresetColors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.thumb_up_alt_outlined,
            color: PresetColors.blueAccent,
            size: 72,
          ),
          Center(
            child: Text(
              "Password reset email sent! Please check your email to reset your password.",
              style: TextStyle(
                fontSize: 36,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 50,),
        ],
      ),
    );
  }
}
