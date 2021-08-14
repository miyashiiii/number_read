import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  bool isPlaySound =true;
  double soundVolume =1.0;

  SettingsModel();


  void toggleSound() {
    print("volume: "+soundVolume.toString());

    isPlaySound=!isPlaySound;
    soundVolume=isPlaySound? 1.0 : 0.0;
    notifyListeners();
    print("volume: "+soundVolume.toString());
  }
}
