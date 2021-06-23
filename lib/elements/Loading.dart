import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:planaholic/util/PresetColors.dart';

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent[100],
      child: Center(
        child: SpinKitFoldingCube(
          color: PresetColors.blueAccent,
          size: 50,
        ),
      ),

    );
  }
}
