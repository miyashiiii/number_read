import 'package:flutter/material.dart';

class SettingsModel extends ChangeNotifier {

  SettingsModel();
  bool isPlaySound = true;
  double soundVolume = 1;

  void toggleSound() {
    print('volume: $soundVolume');

    isPlaySound = !isPlaySound;
    soundVolume = isPlaySound ? 1.0 : 0.0;
    notifyListeners();
    print('volume: $soundVolume');
  }
}
