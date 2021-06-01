import 'package:flutter/material.dart';
import 'package:plannus/util/PresetColors.dart';

class MyAppBar extends AppBar {

  MyAppBar() : super(
    backgroundColor: PresetColors.blueAccent,
    title: Text(
      "PlanNUS",
      style: TextStyle(
        fontFamily: "Lobster Two",
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        fontSize: 32,
        shadows: [
          Shadow(
            color: Colors.black,
            offset: Offset(3, 3),
            blurRadius: 10,
          ),
        ],
      ),
    ),
  );

}