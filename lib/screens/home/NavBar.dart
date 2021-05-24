import 'package:flutter/material.dart';
import 'package:plannus/services/AuthService.dart';
import 'package:plannus/util/PresetColors.dart';

class NavBar extends StatelessWidget {

  final AuthService _auth = AuthService();

  //const NavBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: screenHeight * 0.3,
          backgroundColor: PresetColors.blueAccent,
          title: Row(
            children: [
              Icon(
                  Icons.person_pin,
                size: screenHeight * 0.1,
              ),
              SizedBox(
                width: screenWidth * 0.45,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                        "Xu Jiheng",
                      style: TextStyle(
                        fontSize: screenHeight * 0.04,
                      ),
                    ),
                    Text(
                        "jeffzincatz@gmail.com",
                      style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        decoration: TextDecoration.underline,
                      ),
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
                  child: Text("Calendar",
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
                  child: Text("My Profile",
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
                  child: Text("Settings",
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
                  child: Text("Sign Out",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
                onPressed: () async {
                  await _auth.signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
