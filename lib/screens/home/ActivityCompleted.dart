import 'package:flutter/material.dart';
import 'package:planaholic/models/Event.dart';
import 'package:planaholic/services/DbService.dart';
import 'package:flutter_social_content_share/flutter_social_content_share.dart';
import 'package:planaholic/util/PresetColors.dart';
import 'package:social_share/social_share.dart';

class ActivityCompleted extends StatefulWidget {
  final Event event;

  ActivityCompleted({this.event});


  @override
  _ActivityCompletedState createState() => _ActivityCompletedState();
}

class _ActivityCompletedState extends State<ActivityCompleted> {
  DbService dbService = new DbService();

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}h ${twoDigitMinutes}m";
  }
  
  String duration(DateTime one, DateTime two) {
    return _printDuration(one.difference(two));
  }

  int whichBadge(int n) {
    return n < 5
        ? 1
        : n < 15
        ? 5
        : n < 30
        ? 15
        : n < 60
        ? 30
        : n < 100
        ? 60
        : 100;
  }

  int badgeNo;
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Great Job"),
        backgroundColor: PresetColors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Card(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: FutureBuilder(
                      future: dbService.countCompletedEventByCategory(widget.event.category),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          badgeNo = whichBadge(snapshot.data);
                          return Image.asset(
                            'assets/badges/${widget.event.category}${badgeNo}.png',
                            scale: 1/5,
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      "Activity Completed Successfully",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Category: ${widget.event.category}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 3,),
                              Text(
                                "Description: ${widget.event.description}",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 3,),
                              Flexible(
                                  child: Text(
                                    "Ended at ${widget.event.endTime.toString().substring(0, 16)}",
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            duration(widget.event.endTime, widget.event.startTime),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Card(
              child: Column(
                children: [
                  Text(
                    "Share It!",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          child: Image.asset("assets/social_media/twitter_logo.png"),
                          onPressed: () {
                            SocialShare.shareTwitter(
                                "I just did an activity via Planaholic. \n"
                                    "Category: ${this.widget.event.category} \n"
                                    "Description: ${this.widget.event.description} \n"
                                    "Ended at ${widget.event.endTime.toString().substring(0, 16)}",
                                hashtags: ["Planaholic", "BogoPlan", "GamifiedPlanner"],
                                url:"https://github.com/bernarduskrishna/Planaholic");
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          child: Image.asset("assets/social_media/facebook_logo.png"),
                          onPressed: () {
                            FlutterSocialContentShare.share(
                                type: ShareType.facebookWithoutImage,
                                url: "https://github.com/bernarduskrishna/Planaholic",
                                quote: "I just did an activity via Planaholic. \n"
                                    "Category: ${this.widget.event.category} \n"
                                    "Description: ${this.widget.event.description} \n"
                                    "Ended at ${widget.event.endTime.toString().substring(0, 16)} \n"
                                    "#Planaholic #BogoPlan #GamifiedPlanner");
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
