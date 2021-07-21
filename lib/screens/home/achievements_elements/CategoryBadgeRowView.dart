import 'package:flutter/material.dart';
import 'package:planaholic/screens/home/achievements_elements/IndividualBadge.dart';

class CategoryBadgeRowView extends StatefulWidget {

  final List<int> no = [1, 5, 15, 30, 60, 100];

  final List<String> ifStudies = [
    "Kindergarten",
    "Amateur Mugger",
    "The bookworm",
    "Addicted to studying",
    "Academic Scholar",
    "Polymath"
  ];

  final List<String> ifFitness = [
    "Baby steps",
    "Burn those fats!",
    "Athlete Wannabe",
    "Get those abs",
    "Usain Bolt",
    "Workoutholic"
  ];

  final List<String> ifArts = [
    "Baby artist",
    "New hobby?",
    "Artist in the making",
    "Creative genius",
    "My first masterpiece",
    "Van Gogh"
  ];

  final List<String> ifSocial = [
    "New kid on the block",
    "Extrovert in the making",
    "Popular kid",
    "Partygoer",
    "Social butterfly",
    "Socialite"
  ];

  final List<String> ifOthers = [
    "First endeavour",
    "On the way to greatness",
    "Hard-worker",
    "Over-achiever",
    "Adventurer",
    "Whizz-kid"
  ];

  List<String> chooseList(String name) {
    return name == "Studies"
        ? ifStudies
        : name == "Fitness"
          ? ifFitness
          : name == "Arts"
            ? ifArts
            : name == "Social"
              ? ifSocial
              : ifOthers;
  }

  final String cat;

  CategoryBadgeRowView({this.cat});

  @override
  _CategoryBadgeRowViewState createState() => _CategoryBadgeRowViewState();
}

class _CategoryBadgeRowViewState extends State<CategoryBadgeRowView> {

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenHeight / 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.cat,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 8.0,),
          SizedBox(
            height: screenHeight / 9,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.no.length,
              itemBuilder: (context, index) {
                return IndividualBadge(cat: widget.cat, no: widget.no[index], desc: widget.chooseList(widget.cat)[index],);
              },
            ),
          ),
        ],
      ),
    );
  }
}
