import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GameModel extends ChangeNotifier {
  String firstNumber = "";
  String questionNumber = "";

  String answer = "";
  String answerNumber = "";
  String answerUnit = "";

  bool canAnswer = false;

  Color numberCardColor = Colors.white;
  Color timeCardColor = Colors.white;

  bool isButtonsEnabled = true;

  GameModel() {
    refresh();
  }

  void refresh() {
    answer = "";
    answerNumber = "";
    answerUnit = "";
    numberCardColor = Colors.white;
    timeCardColor = Colors.white;
    _randomFirstNumber();
    _randomQuestionNumber();
    notifyListeners();
  }

  void onFinish() {
    canAnswer = false;
  }

  void _randomFirstNumber() {
    var random = new Random();
    firstNumber = (1 + random.nextInt(9 - 1)).toString();
  }

  void _randomQuestionNumber() {
    var zeros = _weightedChoice([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
    var questionNumStr = firstNumber + "0" * zeros;
    final formatter = NumberFormat("#,###");
    questionNumber = formatter.format(int.parse(questionNumStr));
  }

  int _weightedChoice(List<int> weights) {
    List<int> l = [];
    weights.asMap().forEach((int idx, int weight) {
      // weightsの各要素とそのindexを取得
      l += List.filled(weight, idx); // 長さ:weight, 全要素がidxの作成してlに連結していく
    });
    //print(l); // ["0", "1", "1", "2", "2", "2", "3", "3", "3", "3", ]

    // 上記で生成した配列から1つ選ぶことで、重みつきのchoiceを実行
    var _random = new Random();
    return l[_random.nextInt(l.length)];
  }

  final List<String> units = ["", "万", "億"];

  void showAnswer() {
    print(questionNumber);

    var digits = questionNumber.replaceAll(",", "").length - 1;
    var number = digits % 4;
    var unitIdx = digits ~/ 4;
    var unit = units[unitIdx];
    if (digits > 0) {}
    questionNumber = firstNumber.toString() + "0" * number + unit;
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
}
