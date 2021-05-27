import 'package:flutter/material.dart';
import 'package:plannus/screens/home/NavBar.dart';
import 'package:plannus/services/DbService.dart';
import 'package:plannus/util/PresetColors.dart';
import 'package:plannus/util/MyAppBar.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DbService _db = new DbService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: ListView(
        // Testing content below
        children: [
          Text("Home Screen"),

          Center(
            widthFactor: 0.2,
            child: FutureBuilder(
                future: _db.getUserProfilePic(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data),
                    backgroundColor: Colors.grey,
                    radius: 50,
                  )
                      : Icon(Icons.person);
                }),
          ),
        ],
      ),
      drawer: NavBar(),
    );
  }
}
