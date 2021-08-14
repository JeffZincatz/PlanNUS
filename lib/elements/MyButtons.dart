import 'package:flutter/material.dart';
import 'package:planaholic/util/PresetColors.dart';

/// A collection of preset customised button styles
class MyButtons {

  /// Create a customised blue button with rounded corners
  static TextButton roundedBlue(
      {@required Function onPressed, @required String text, @required Key key}) {
    return TextButton(
      key: key,
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
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

  /// Create a customised white button with rounded corners
  static TextButton roundedWhite(
      {@required Function onPressed, @required String text, @required Key key}) {
    return TextButton(
      key: key,
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
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

  /// Create a customised red button with rounded corners
  static TextButton roundedRed(
      {@required Function onPressed, @required String text, @required Key key}) {
    return TextButton(
      key: key,
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: Colors.red,
        padding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
      ),
    );
  }
}
