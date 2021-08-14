import 'package:flutter/material.dart';
import 'package:planaholic/screens/home/achievements_elements/CategoryBadgeRowView.dart';

/// Abstraction for ALL categoried badges
class BadgesView extends StatefulWidget {

  final List<String> cat;
  BadgesView({this.cat});

  @override
  _BadgesViewState createState() => _BadgesViewState();
}

class _BadgesViewState extends State<BadgesView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.cat.length,
      itemBuilder: (context, index) {
        return CategoryBadgeRowView(cat: widget.cat[index],);
      },
    );
  }
}
