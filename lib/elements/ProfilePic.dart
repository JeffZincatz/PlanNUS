import 'package:flutter/material.dart';
import 'package:plannus/util/PresetColors.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({Key key, this.image, this.radius}) : super(key: key);

  final String image;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        border: Border.all(
          width: 4,
          color: PresetColors.background,
        ),
        boxShadow: [
          BoxShadow(
              spreadRadius: 5,
              blurRadius: 15,
              color: Colors.black.withOpacity(0.5),
              offset: Offset(0, 10))
        ],
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(image),
        ),
      ),
    );
  }
}

