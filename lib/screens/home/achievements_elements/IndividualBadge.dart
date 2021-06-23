import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planaholic/services/DbService.dart';
import 'package:planaholic/util/PresetColors.dart';
import 'package:planaholic/screens/home/BadgeShare.dart';

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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => BadgeShare(cat: widget.cat, no: widget.no, desc: widget.desc,)));
                    },
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Image.asset(
                            "assets/badges/${widget.cat}${widget.no}.png",
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            widget.desc,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              )
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
                            flex: 2,
                            child: Image.asset(
                              "assets/badges/${widget.cat}${widget.no}.png",
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              widget.desc,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  Container(
                    height: screenHeight / 9,
                    width: screenWidth / 6,
                    color: Colors.grey.withOpacity(0.9),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Complete ${widget.no} activities in ${widget.cat} category",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }
}
