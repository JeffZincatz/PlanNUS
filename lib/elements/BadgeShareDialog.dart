import 'package:flutter/material.dart';
import 'package:flutter_social_content_share/flutter_social_content_share.dart';
import 'package:social_share/social_share.dart';

/// The dialog widget shown upon sharing a badge for each activity
class BadgeShareDialog extends StatefulWidget {
  final String cat;
  final int no;
  final String desc;

  BadgeShareDialog({Key key, this.cat, this.no, this.desc}): super(key: key);

  @override
  _BadgeShareDialogState createState() => _BadgeShareDialogState();
}

class _BadgeShareDialogState extends State<BadgeShareDialog> {
  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    String activityOrActivities() {
      return widget.no > 1
          ? "activities"
          : "activity";
    }

    return AlertDialog(
      scrollable: true,
      content: Column(
        children: [
          Card(
            child: Column(
              children: [
                Image.asset(
                  'assets/badges/${widget.cat}${widget.no}.png',
                  scale: 1/3,
                ),
                Text(
                  "Badge Obtained!",
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
                      "${widget.desc}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * 0.025,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.01),
                      child: Text(
                        "I have done ${widget.no} ${activityOrActivities()} in ${widget.cat} category.",
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
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
                            "Badge obtained: ${widget.desc} \n"
                                "I have done ${widget.no} ${activityOrActivities()} in ${widget.cat} category via Planaholic. ",
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
                            quote: "Badge obtained: ${widget.desc} \n"
                                "I have done ${widget.no} ${activityOrActivities()} in ${widget.cat} category via Planaholic \n"
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
