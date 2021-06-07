import 'package:flutter/material.dart';
import 'package:plannus/screens/home/Debug.dart';
import 'package:plannus/util/PresetColors.dart';

class MyAppBar extends AppBar {

  MyAppBar(context) : super(
    backgroundColor: PresetColors.blueAccent,
    elevation: 10,
    actions: [
      TextButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: ((builder) => Debug()),
          );
        },
        child: Row(
          children: [
            Icon(Icons.bug_report_outlined),
            Text("Debug"),
          ],
        ),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
      ),
    ],
    title: Center(
      child: Text(
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
    ),
  );

}