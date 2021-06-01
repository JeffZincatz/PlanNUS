import 'package:flutter/material.dart';
import 'package:plannus/util/PresetColors.dart';

class MyButtons {
  static TextButton roundedBlue(
      {@required Function onPressed, @required String text}) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: PresetColors.blueAccent,
        padding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
      ),
    );
  }

  static TextButton roundedWhite(
      {@required Function onPressed, @required String text}) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          color: PresetColors.blue,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
      ),
    );
  }
}
