import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:plannus/screens/home/NavBar.dart';
import 'package:plannus/elements/MyAppBar.dart';
import 'package:plannus/services/DbService.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:plannus/util/PresetColors.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DbService _db = new DbService();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MyAppBar(),
      drawer: NavBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
        child: ListView(shrinkWrap: true, children: [
          Column(
            children: [
              Text(
                "My Profile",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                    future: _db.getUserProfilePic(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(snapshot.data),
                              backgroundColor: Colors.grey,
                              radius: 60,
                            )
                          : Icon(Icons.person);
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: _db.getUsername(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? Text(
                            snapshot.data,
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          )
                        : Text("");
                  },
                ),
              ),
              FutureBuilder(
                future: _db.getEmail(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Text(
                          snapshot.data,
                          style: TextStyle(
                            fontFamily: "monospace",
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        )
                      : Text("");
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
                child: SizedBox(
                  width: screenWidth * 0.8,
                  child: Column(
                    // column of all stats
                    children: [
                      Center(
                        widthFactor: 0.7,
                        child: AspectRatio( // need to wrap this around Chart for sizing
                          aspectRatio: 1,
                          child: FutureBuilder(
                            future: _db.getAllCompletedEventCount(),
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? PieChart(
                                    PieChartData(
                                      centerSpaceRadius: screenWidth * 0.12,
                                      sections: [
                                        PieChartSectionData(
                                          title: "Studies\n" + snapshot.data["studies"].toString(),
                                          value: snapshot.data["studies"] * 1.0,
                                          showTitle: true,
                                          radius: screenWidth * 0.28,
                                          color: PresetColors.blue,
                                          titleStyle: TextStyle(fontSize: 18),
                                        ),
                                        PieChartSectionData(
                                          title: "Fitness\n" + snapshot.data["fitness"].toString(),
                                          value: snapshot.data["fitness"] * 1.0,
                                          showTitle: true,
                                          radius: screenWidth * 0.28,
                                          color: PresetColors.purple,
                                          titleStyle: TextStyle(fontSize: 18),
                                        ),
                                        PieChartSectionData(
                                          title: "Arts\n" + snapshot.data["arts"].toString(),
                                          value: snapshot.data["arts"] * 1.0,
                                          showTitle: true,
                                          radius: screenWidth * 0.28,
                                          color: PresetColors.lightGreen,
                                          titleStyle: TextStyle(fontSize: 18),
                                        ),
                                        PieChartSectionData(
                                          title: "Social\n" + snapshot.data["social"].toString(),
                                          value: snapshot.data["social"] * 1.0,
                                          showTitle: true,
                                          radius: screenWidth * 0.28,
                                          color: PresetColors.orangeAccent,
                                          titleStyle: TextStyle(fontSize: 18),
                                        ),
                                        PieChartSectionData(
                                          title: "Others\n" + snapshot.data["others"].toString(),
                                          value: snapshot.data["others"] * 1.0,
                                          showTitle: true,
                                          radius: screenWidth * 0.28,
                                          color: PresetColors.red,
                                          titleStyle: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  )
                                  : Container();
                            },
                          ),
                        ),
                      ),
                      Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 0),
                                child: Text(
                                  "Level:",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Center(
                                child: FutureBuilder(
                                  future: _db.countAllCompletedEvent(),
                                  builder: (context, snapshot) {
                                    return snapshot.hasData
                                        ? Text(
                                      snapshot.data.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    )
                                        : Text("");
                                  },
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 0),
                                child: Text(
                                  "Total activities completed:",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Center(
                                child: FutureBuilder(
                                  future: _db.countAllCompletedEvent(),
                                  builder: (context, snapshot) {
                                    return snapshot.hasData
                                        ? Text(
                                            snapshot.data.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          )
                                        : Text("");
                                  },
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 0),
                                child: Text(
                                  "Studies:",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Center(
                                child: FutureBuilder(
                                  future: _db
                                      .countCompletedEventByCategory("Studies"),
                                  builder: (context, snapshot) {
                                    return snapshot.hasData
                                        ? Text(
                                            snapshot.data.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          )
                                        : Text("");
                                  },
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 0),
                                child: Text(
                                  "Fitness:",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Center(
                                child: FutureBuilder(
                                  future: _db
                                      .countCompletedEventByCategory("Fitness"),
                                  builder: (context, snapshot) {
                                    return snapshot.hasData
                                        ? Text(
                                            snapshot.data.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          )
                                        : Text("");
                                  },
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 0),
                                child: Text(
                                  "Arts:",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Center(
                                child: FutureBuilder(
                                  future:
                                      _db.countCompletedEventByCategory("Arts"),
                                  builder: (context, snapshot) {
                                    return snapshot.hasData
                                        ? Text(
                                            snapshot.data.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          )
                                        : Text("");
                                  },
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 0),
                                child: Text(
                                  "Social:",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Center(
                                child: FutureBuilder(
                                  future: _db
                                      .countCompletedEventByCategory("Social"),
                                  builder: (context, snapshot) {
                                    return snapshot.hasData
                                        ? Text(
                                            snapshot.data.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          )
                                        : Text("");
                                  },
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 0),
                                child: Text(
                                  "Others:",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Center(
                                child: FutureBuilder(
                                  future: _db
                                      .countCompletedEventByCategory("Others"),
                                  builder: (context, snapshot) {
                                    return snapshot.hasData
                                        ? Text(
                                            snapshot.data.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          )
                                        : Text("");
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
