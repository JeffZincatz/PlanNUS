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

  // edit username button
  bool isEditing = false;
  static String username = "";
  static String newName = "";

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MyAppBar(context),
      drawer: NavBar(),
      body: ListView(shrinkWrap: true, children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  "My Profile",
                  style: TextStyle(
                    fontSize: 20,
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
                        : Icon(Icons.person, size: 135,);
                  }),
              FutureBuilder(
                future: _db.getUserLevel(),
                builder: (context, snapshot) {
                  String lvl = snapshot.hasData ? snapshot.data.toString() : " ";
                  return Text(
                    "Level " + lvl,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: isEditing ? 0 : screenWidth * 0.11,
                  ),
                  isEditing
                      ? Container(
                          height: 50,
                          width: screenWidth * 0.65,
                          // color: Colors.red,
                          child: TextFormField(
                            initialValue: username,
                            style: TextStyle(
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: isEditing
                                  ? UnderlineInputBorder()
                                  : InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (String value) {
                              setState(() {
                                newName = value;
                              });
                            },
                          ),
                        )
                      : FutureBuilder(
                          future: _db.getUsername(),
                          builder: (context, snapshot) {
                            username =
                                snapshot.hasData ? snapshot.data : username;
                            return Text(
                              username,
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            );
                          }),
                  isEditing
                      ? Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () async {
                                await _db.updateUsername(newName);
                                setState(() {
                                  isEditing = false;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  isEditing = false;
                                  newName = "";
                                });
                              },
                            ),
                          ],
                        )
                      : IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              isEditing = true;
                            });
                          },
                        ),
                ],
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
                        String currExp =
                            snapshot.hasData ? snapshot.data.toString() : "";
                        return Text(
                          "Current EXP: " + currExp,
                          style: TextStyle(
                              // fontSize: 12,
                              ),
                        );
                      },
                    ),
                    FutureBuilder(
                      future: _db.getUserNextExp(),
                      builder: (context, snapshot) {
                        String nextExp =
                            snapshot.hasData ? snapshot.data.toString() : "";
                        return Text(
                          "EXP to next lvl: " + nextExp,
                          style: TextStyle(
                              // fontSize: 12,
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
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey[400],
                        valueColor: AlwaysStoppedAnimation(PresetColors.blue),
                        value: snapshot.hasData
                            ? snapshot.data["current"] *
                                1.0 /
                                snapshot.data["next"]
                            : 0,
                        minHeight: 15,
                      ),
                    ),
                  );
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
                              int studies = 0;
                              int fitness = 0;
                              int arts = 0;
                              int social = 0;
                              int others = 0;
                              int placeholder = 1;
                              if (snapshot.hasData) {
                                studies = snapshot.data["Studies"];
                                fitness = snapshot.data["Fitness"];
                                arts = snapshot.data["Arts"];
                                social = snapshot.data["Social"];
                                others = snapshot.data["Others"];
                                placeholder = 0;
                              }
                              return PieChart(
                                PieChartData(
                                  centerSpaceRadius: screenWidth * 0.12,
                                  sections: [
                                    PieChartSectionData(
                                      // placeholder, loaded before other fields
                                      // such that non-blank pie chart is displayed
                                      title: "",
                                      value: placeholder * 1.0,
                                      showTitle: false,
                                      radius: screenWidth * 0.28,
                                      color: Colors.grey[400],
                                    ),
                                    PieChartSectionData(
                                      title: "Studies\n" + studies.toString(),
                                      value: studies * 1.0,
                                      showTitle: true,
                                      radius: screenWidth * 0.28,
                                      color: PresetColors.blue,
                                      titleStyle: TextStyle(fontSize: 15),
                                    ),
                                    PieChartSectionData(
                                      title: "Fitness\n" + fitness.toString(),
                                      value: fitness * 1.0,
                                      showTitle: true,
                                      radius: screenWidth * 0.28,
                                      color: PresetColors.purple,
                                      titleStyle: TextStyle(fontSize: 15),
                                    ),
                                    PieChartSectionData(
                                      title: "Arts\n" + arts.toString(),
                                      value: arts * 1.0,
                                      showTitle: true,
                                      radius: screenWidth * 0.28,
                                      color: PresetColors.lightGreen,
                                      titleStyle: TextStyle(fontSize: 15),
                                    ),
                                    PieChartSectionData(
                                      title: "Social\n" + social.toString(),
                                      value: social * 1.0,
                                      showTitle: true,
                                      radius: screenWidth * 0.28,
                                      color: PresetColors.orangeAccent,
                                      titleStyle: TextStyle(fontSize: 15),
                                    ),
                                    PieChartSectionData(
                                      title: "Others\n" + others.toString(),
                                      value: others * 1.0,
                                      showTitle: true,
                                      radius: screenWidth * 0.28,
                                      color: PresetColors.red,
                                      titleStyle: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              );
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
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: MyButtons.roundedRed(
            text: "Sign Out",
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ),
      ]),
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
