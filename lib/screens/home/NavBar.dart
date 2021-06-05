import 'package:flutter/material.dart';
import 'package:plannus/screens/home/Achievements.dart';
import 'package:plannus/services/AuthService.dart';
import 'package:plannus/util/PresetColors.dart';
import 'package:plannus/services/DbService.dart';
import 'package:plannus/screens/home/Home.dart';
import 'package:plannus/screens/home/Profile.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final AuthService _auth = new AuthService();
  final DbService _db = new DbService();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: screenHeight * 0.3,
          backgroundColor: PresetColors.blueAccent,
          title: Row(
            children: [
              Expanded(
                flex: 4,
                child: FutureBuilder(
                    future: _db.getUserProfilePic(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(snapshot.data),
                              backgroundColor: Colors.grey,
                              radius: 40,
                            )
                          : Icon(Icons.person);
                    }),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Expanded(
                flex: 8,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    FutureBuilder(
                      future: _db.getUsername(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? Text(
                                snapshot.data,
                                style: TextStyle(
                                  fontSize: screenHeight * 0.04,
                                ),
                              )
                            : Text("");
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FutureBuilder(
                      future: _db.getEmail(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? Text(
                                snapshot.data,
                                style: TextStyle(
                                  fontSize: screenHeight * 0.02,
                                  decoration: TextDecoration.underline,
                                ),
                              )
                            : Text("");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: ListView(
            shrinkWrap: true,
            children: [
              TextButton(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Calendar",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "My Profile",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Profile(),
                      ));
                },
              ),
              TextButton(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Achievements/Badges",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Achievements(),
                      ));
                },
              ),
              TextButton(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
                onPressed: () {},
              ),
              TextButton(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              TextButton(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Debug - isUserStatsEmpty",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
                onPressed: () async {
                  print(await _db.isUserStatsEmpty());
                },
              ),
              TextButton(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Debug - initUserStats",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
                onPressed: () async {
                  if (await _db.isUserStatsEmpty()) {
                    await _db.initUserStats();
                    print("User stats initialised.");
                  } else {
                    print("User stats already exists.");
                  }
                },
              ),
              TextButton(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Debug - syncUserStats",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
                onPressed: () async {
                  await _db.syncUserStats();
                },
              ),
              TextButton(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Debug - getTotal",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
                onPressed: () async {
                  await _db.countCompletedEventByCategory("total");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
