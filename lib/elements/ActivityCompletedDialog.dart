import 'package:flutter/material.dart';
import 'package:flutter_social_content_share/flutter_social_content_share.dart';
import 'package:planaholic/models/Event.dart';
import 'package:planaholic/services/DbService.dart';
import 'package:social_share/social_share.dart';

class ActivityCompletedDialog extends StatefulWidget {
  final Event event;

  const ActivityCompletedDialog({Key key, this.event}) : super(key: key);

  @override
  _ActivityCompletedDialogState createState() => _ActivityCompletedDialogState();
}

class _ActivityCompletedDialogState extends State<ActivityCompletedDialog> {
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

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      scrollable: true,
      content: Column(
        children: [
          Card(
            child: Column(
              children: [
                FutureBuilder(
                  future: dbService.countCompletedEventByCategory(widget.event.category),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      badgeNo = whichBadge(snapshot.data);
                      return Image.asset(
                        'assets/badges/${widget.event.category}$badgeNo.png',
                        scale: 1/5,
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                Text(
                  "Activity Completed Successfully!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenHeight * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Category: ${widget.event.category}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * 0.025,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.01),
                      child: Text(
                        "Description: ${widget.event.description}",
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.01),
                      child: Text(
                        "Ended at ${widget.event.endTime.toString().substring(0, 16)}",
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.01),
                  child: Text(
                    duration(widget.event.endTime, widget.event.startTime),
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: Column(
              children: [
                Text(
                  "Share It!",
                  style: TextStyle(
                    fontSize: screenHeight * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      child: Image.asset("assets/social_media/twitter_logo.png",width: screenWidth / 4,),
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
                    TextButton(
                      child: Image.asset("assets/social_media/facebook_logo.png", width: screenWidth / 4,),
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
