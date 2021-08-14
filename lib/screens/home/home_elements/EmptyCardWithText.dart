import 'package:flutter/material.dart';

/// An abstraction for an empty card if there is no event to show
class EmptyCardWithText extends StatelessWidget {
  final String text;

  EmptyCardWithText({this.text});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      child: Center(child: Text(text, textAlign: TextAlign.center,)),
    );
  }
}
