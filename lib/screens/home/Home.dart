import 'package:flutter/material.dart';
import 'package:plannus/screens/home/NavBar.dart';
import 'package:plannus/util/PresetColors.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Text("Home Screen"),
      drawer: NavBar(),
    );
  }
}
