import 'package:flutter/material.dart';
import 'package:planaholic/screens/home/achievements_elements/BadgesView.dart';
import 'package:planaholic/screens/home/achievements_elements/TotalActivitiesBadges.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView(
          children: [
            Text(
              "Achievement Page",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(height: 5.0,),
            SizedBox(
              width: screenWidth,
              height: screenHeight * 1 / 6,
              child: TotalActivitiesBadges(),
            ),
            SizedBox(
              child: BadgesView(cat: cat),
              width: screenWidth,
              height: screenHeight * 5 / 6,
            ),
          ],
        ),
      ),
    );
  }
}
