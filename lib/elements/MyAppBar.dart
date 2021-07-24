import 'package:flutter/material.dart';
import 'package:planaholic/util/PresetColors.dart';

class MyAppBar extends AppBar {

  MyAppBar(context) : super(
    backgroundColor: PresetColors.blueAccent,
    elevation: 10,
    title: Center(
      child: Text(
        // manually added spacing before title to center, due to debug button
        // remove temp spacing after removing debug button
        // "          " + "Planaholic",
        "Planaholic",
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
    ),
  );

}