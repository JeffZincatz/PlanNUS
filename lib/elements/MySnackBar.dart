import 'package:flutter/material.dart';

/// A class to show snack bar prompt
class MySnackBar {

  /// Show a customised snack bar prompt with the [content]
  static void show(BuildContext context, Widget content) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
      content: content,
      backgroundColor:
      Colors.black26.withOpacity(0.8),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
            Radius.circular(
                screenHeight * 0.1)),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.08),
      margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenWidth * 0.02),
    ));
  }
}