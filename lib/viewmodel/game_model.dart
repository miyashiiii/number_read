import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameModel extends ChangeNotifier {

  GameModel() {
    gameInit();
  }
  String firstNumber = '';
  String questionNumber = '';

  String answer = '';
  String answerNumber = '';
  String answerUnit = '';

  bool canAnswer = false;

  Color numberCardColor = Colors.white;
  Color timeCardColor = Colors.white;

  bool isButtonsEnabled = true;

  int remainTime = -1;

  final Color correctColor = Colors.lightGreen;
  final Color incorrectColor = Colors.red.shade300;

  late final int highScoreSaved;
  int highScoreView = 0;
  int score = 0;

  void gameInit() {
    score = 0;
    remainTime = -1;
    isButtonsEnabled = true;
    loadHighScore();
    newQuestion();
  }

  void newQuestion() {
    answer = '';
    answerNumber = '';
    answerUnit = '';
    numberCardColor = Colors.white;
    timeCardColor = Colors.white;
    canAnswer = false;
    _randomFirstNumber();
    _randomQuestionNumber();
    notifyListeners();
  }

  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScoreSaved = prefs.getInt('HighScore') ?? 0;
    highScoreView = highScoreSaved;
    notifyListeners();
  }

  void onFinish() {
    canAnswer = false;
  }

  void _randomFirstNumber() {
    final random = Random();
    firstNumber = (1 + random.nextInt(9 - 1)).toString();
  }

  void _randomQuestionNumber() {
    final zeros = _weightedChoice([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
    final questionNumStr = firstNumber + '0' * zeros;
    final formatter = NumberFormat('#,###');
    questionNumber = formatter.format(int.parse(questionNumStr));
  }

  int _weightedChoice(List<int> weights) {
    var l = <int>[];
    weights.asMap().forEach((int idx, int weight) {
      // weightsの各要素とそのindexを取得
      l += List.filled(weight, idx); // 長さ:weight, 全要素がidxの作成してlに連結していく
    });
    //print(l); // ["0", "1", "1", "2", "2", "2", "3", "3", "3", "3", ]

    // 上記で生成した配列から1つ選ぶことで、重みつきのchoiceを実行
    final random = Random();
    return l[random.nextInt(l.length)];
  }

  final List<String> units = ['', '万', '億'];

  void showAnswer() {
    print(questionNumber);

    final digits = questionNumber.replaceAll(',', '').length - 1;
    final number = digits % 4;
    final unitIdx = digits ~/ 4;
    final unit = units[unitIdx];
    if (digits > 0) {}
    questionNumber = firstNumber.toString() + '0' * number + unit;
    print(questionNumber);
    notifyListeners();
  }

  void updateNumber(String tmpNumber) {
    answerNumber = tmpNumber;
    answer = tmpNumber + answerUnit;
    canAnswer = true;
    notifyListeners();
  }

  void updateUnit(String tmpUnit) {
    answerUnit = tmpUnit;
    answer = answerNumber + tmpUnit;
    notifyListeners();
  }

  void onTimeOver() {
    timeCardColor = incorrectColor;
    numberCardColor = incorrectColor;

    showAnswer();
  }

  void changeCardColor(bool result) {
    numberCardColor = result ? correctColor : incorrectColor;
    notifyListeners();
  }

  void updateHighScore() {
    score++;
    if (score > highScoreSaved) {
      highScoreView = score;
      print('highScoreSaved: $highScoreSaved');
      print('highScoreView: $highScoreView');
    }
  }
}
