import 'package:flutter/material.dart';
import 'package:flutter_social_content_share/flutter_social_content_share.dart';
import 'package:social_share/social_share.dart';

class BadgeShareTotalDialog extends StatefulWidget {
  final int no;
  final String desc;

  BadgeShareTotalDialog({Key key, this.no, this.desc}): super(key: key);

  @override
  _BadgeShareTotalDialogState createState() => _BadgeShareTotalDialogState();
}

class _BadgeShareTotalDialogState extends State<BadgeShareTotalDialog> {
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
                  'assets/badges/${widget.no}.png',
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
                        "I have done ${widget.no} ${activityOrActivities()}.",
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
                                "I have done ${widget.no} ${activityOrActivities()} via Planaholic",
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
                                "I have done ${widget.no} ${activityOrActivities()} via Planaholic \n"
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
