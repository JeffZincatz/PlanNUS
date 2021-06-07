import 'package:flutter/material.dart';
import 'package:plannus/elements/MyAppBar.dart';
import 'package:plannus/screens/home/NavBar.dart';
import 'package:plannus/screens/home/achievements_elements/BadgesView.dart';
import 'package:plannus/screens/home/achievements_elements/TotalActivitiesBadges.dart';

class Achievements extends StatefulWidget {

  @override
  _AchievementsState createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {

  List<String> cat = ["Studies", "Fitness", "Arts", "Social", "Others"];
  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MyAppBar(context),
      drawer: NavBar(),
      body: ListView(
        children: [
          Text(
            "Achievement Page",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          SizedBox(
            width: screenWidth,
            height: screenHeight * 1 / 7,
            child: TotalActivitiesBadges(),
          ),
          SizedBox(
            child: BadgesView(cat: cat),
            width: screenWidth,
            height: screenHeight * 5 / 7,
          ),
        ],
      ),
    );
  }
}
