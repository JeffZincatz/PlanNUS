import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planaholic/elements/BadgeShareDialog.dart';
import 'package:planaholic/services/DbService.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class IndividualBadge extends StatefulWidget {
  final String cat;
  final int no;
  final String desc;

  IndividualBadge({this.cat, this.no, this.desc});

  @override
  _IndividualBadgeState createState() => _IndividualBadgeState();
}

class _IndividualBadgeState extends State<IndividualBadge> {
  DbService _db = new DbService();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: _db.countCompletedEventByCategory(widget.cat),
      builder: (context, snapshot) {
        return !snapshot.hasData
            ? Container()
            : snapshot.data >= widget.no
                ? Container(
                    height: screenHeight / 9,
                    width: screenWidth / 6,
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => BadgeShare(cat: widget.cat, no: widget.no, desc: widget.desc,)));
                        showDialog(
                            context: context,
                            builder: (context) => BadgeShareDialog(
                                  cat: widget.cat,
                                  no: widget.no,
                                  desc: widget.desc,
                                ));
                      },
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image.asset(
                              "assets/badges/${widget.cat}${widget.no}.png",
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                widget.desc,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                : Stack(
                    children: <Widget>[
                      Container(
                          height: screenHeight / 9,
                          width: screenWidth / 6,
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Image.asset(
                                  "assets/badges/${widget.cat}${widget.no}.png",
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    widget.desc,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Container(
                        height: screenHeight / 9,
                        width: screenWidth / 6,
                        color: Colors.grey.withOpacity(0.9),
                        child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: IconButton(
                                    icon: Icon(Icons.lock),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                "Badge locked",
                                                textAlign: TextAlign.center,
                                              ),
                                              scrollable: true,
                                              content: Text(
                                                "Complete ${widget.no} activities in ${widget.cat} category",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: LinearPercentIndicator(
                                    percent: snapshot.data / widget.no,
                                    backgroundColor: Colors.black,
                                    progressColor: Colors.blueGrey,
                                  ),
                                )
                              ],
                            )),
                      ),
                    ],
                  );
      },
    );
  }
}
