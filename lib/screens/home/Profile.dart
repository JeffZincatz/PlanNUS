import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plannus/elements/MyButtons.dart';
import 'package:plannus/elements/ProfilePic.dart';
import 'package:plannus/screens/home/NavBar.dart';
import 'package:plannus/elements/MyAppBar.dart';
import 'package:plannus/services/DbService.dart';
import 'package:plannus/services/AuthService.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:plannus/util/PresetColors.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static DbService _db = new DbService();
  static AuthService _auth = new AuthService();
  static FirebaseStorage _storage = FirebaseStorage.instance;

  // change profile
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();

  /// initialise user stats on opening profile if stats docs is empty.
  /// should be ok to move functionality to sign up after old accounts are synced.
  static void initStats() async {
    bool isUserStatsEmpty = await _db.isUserStatsEmpty();
    if (isUserStatsEmpty) {
      _db.initUserStats();
    }
  }

  var i = initStats();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MyAppBar(context),
      drawer: NavBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView(shrinkWrap: true, children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  "My Profile",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              FutureBuilder(
                  future: _db.getUserProfilePic(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(children: [
                              ProfilePic(
                                image: snapshot.data,
                                radius: 60,
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 4,
                                          color: PresetColors.background,
                                        ),
                                        color: PresetColors.blue),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: ((builder) => bottomSheet()),
                                        );
                                      },
                                    ),
                                  )),
                            ]),
                          )
                        : Icon(Icons.person);
                  }),
              FutureBuilder(
                future: _db.getUserLevel(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Text(
                          "Level " + snapshot.data.toString(),
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        )
                      : Text("");
                },
              ),
              FutureBuilder(
                future: _db.getUsername(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            snapshot.data,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Text("");
                },
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
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder(
                      future: _db.getUserCurrentExp(),
                      builder: (context, snapshot) {
                        return Text(
                          "Current EXP: " + snapshot.data.toString(),
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        );
                      },
                    ),
                    FutureBuilder(
                      future: _db.getUserNextExp(),
                      builder: (context, snapshot) {
                        return Text(
                          "EXP to next lvl: " + snapshot.data.toString(),
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: (() async {
                  return {
                    "current": await _db.getUserCurrentExp(),
                    "next": await _db.getUserNextExp(),
                  };
                })(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.grey[400],
                            valueColor:
                                AlwaysStoppedAnimation(PresetColors.blue),
                            value: snapshot.data["current"] *
                                1.0 /
                                snapshot.data["next"],
                            minHeight: 15,
                          ),
                        )
                      : Container();
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
                        child: AspectRatio(
                          // need to wrap this around Chart for sizing
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
                                            title: "Studies\n" +
                                                snapshot.data["Studies"]
                                                    .toString(),
                                            value:
                                                snapshot.data["Studies"] * 1.0,
                                            showTitle: true,
                                            radius: screenWidth * 0.28,
                                            color: PresetColors.blue,
                                            titleStyle: TextStyle(fontSize: 18),
                                          ),
                                          PieChartSectionData(
                                            title: "Fitness\n" +
                                                snapshot.data["Fitness"]
                                                    .toString(),
                                            value:
                                                snapshot.data["Fitness"] * 1.0,
                                            showTitle: true,
                                            radius: screenWidth * 0.28,
                                            color: PresetColors.purple,
                                            titleStyle: TextStyle(fontSize: 18),
                                          ),
                                          PieChartSectionData(
                                            title: "Arts\n" +
                                                snapshot.data["Arts"]
                                                    .toString(),
                                            value: snapshot.data["Arts"] * 1.0,
                                            showTitle: true,
                                            radius: screenWidth * 0.28,
                                            color: PresetColors.lightGreen,
                                            titleStyle: TextStyle(fontSize: 18),
                                          ),
                                          PieChartSectionData(
                                            title: "Social\n" +
                                                snapshot.data["Social"]
                                                    .toString(),
                                            value:
                                                snapshot.data["Social"] * 1.0,
                                            showTitle: true,
                                            radius: screenWidth * 0.28,
                                            color: PresetColors.orangeAccent,
                                            titleStyle: TextStyle(fontSize: 18),
                                          ),
                                          PieChartSectionData(
                                            title: "Others\n" +
                                                snapshot.data["Others"]
                                                    .toString(),
                                            value:
                                                snapshot.data["Others"] * 1.0,
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
                                  "Total activities completed:",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              FutureBuilder(
                                future:
                                    _db.countCompletedEventByCategory("total"),
                                builder: (context, snapshot) {
                                  return snapshot.hasData
                                      ? Text(
                                          snapshot.data.toString(),
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      : Text("");
                                },
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
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              FutureBuilder(
                                future: _db
                                    .countCompletedEventByCategory("Studies"),
                                builder: (context, snapshot) {
                                  return snapshot.hasData
                                      ? Text(
                                          snapshot.data.toString(),
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      : Text("");
                                },
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
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              FutureBuilder(
                                future: _db
                                    .countCompletedEventByCategory("Fitness"),
                                builder: (context, snapshot) {
                                  return snapshot.hasData
                                      ? Text(
                                          snapshot.data.toString(),
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      : Text("");
                                },
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
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              FutureBuilder(
                                future:
                                    _db.countCompletedEventByCategory("Arts"),
                                builder: (context, snapshot) {
                                  return snapshot.hasData
                                      ? Text(
                                          snapshot.data.toString(),
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      : Text("");
                                },
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
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              FutureBuilder(
                                future:
                                    _db.countCompletedEventByCategory("Social"),
                                builder: (context, snapshot) {
                                  return snapshot.hasData
                                      ? Text(
                                          snapshot.data.toString(),
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      : Text("");
                                },
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
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              FutureBuilder(
                                future:
                                    _db.countCompletedEventByCategory("Others"),
                                builder: (context, snapshot) {
                                  return snapshot.hasData
                                      ? Text(
                                          snapshot.data.toString(),
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      : Text("");
                                },
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: MyButtons.roundedRed(
              text: "Sign Out",
              onPressed: () async {
                await _auth.signOut();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ),
        ]),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton(
                  child: Row(
                    children: [
                      Icon(Icons.camera),
                      Text(
                        "Camera",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  },
                ),
                TextButton(
                  child: Row(
                    children: [
                      Icon(Icons.image),
                      Text(
                        "Gallery",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                ),
              ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        maxHeight: 200, // limit pic size to 200*200
        maxWidth: 200,
      );
      setState(() {
        _imageFile = pickedFile;
      });

      // save image to storage
      File image = File(_imageFile.path);
      String imagePath = "profilePics/" + _auth.getCurrentUser().uid + ".jpg";
      await _storage.ref(imagePath).putFile(image);

      // update db users profilePic
      String url = await _storage.ref(imagePath).getDownloadURL();
      _db.updateUserProfilePic(url);

      setState(() {}); // refresh profile page
      Navigator.pop(context); // close bottom sheet
    } catch (error) {
      print(error); // TODO: remove temp debug
      return null;
    }
  }
}
