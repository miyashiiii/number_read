import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;

  SizeConfig(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
  }

  static double getSizePerHeight(double percent) {
    return screenHeight! * percent / 100;
  }

  static double getSizePerWidth(int percent) {
    return screenWidth! * percent / 100;
  }
}
