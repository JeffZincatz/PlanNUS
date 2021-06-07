import 'package:flutter/material.dart';
import 'package:plannus/screens/home/Achievements.dart';
import 'package:plannus/screens/home/Home.dart';
import 'package:plannus/screens/home/Achievements.dart';
import 'package:plannus/util/PresetColors.dart';

import 'Profile.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {

  int _selectedIndex = 1;

  static List<Widget> _widgetOptions = <Widget>[
    Profile(),
    Home(),
    Achievements(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child:  _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stars),
            label: 'Achievements',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: PresetColors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
