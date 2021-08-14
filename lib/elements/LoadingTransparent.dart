import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:planaholic/util/PresetColors.dart';

/// A loading widget shown while loading with transparent background
class LoadingTransparent extends StatelessWidget {
  const LoadingTransparent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.4),
      child: Center(
        child: SpinKitFoldingCube(
          color: PresetColors.blueAccent,
          size: 50,
        ),
      ),

    );
  }
}
