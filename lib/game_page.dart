import 'dart:async';

import 'package:flutter/material.dart';
import 'package:number_read/util.dart';
import "dart:math";

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class GamePage extends StatefulWidget {
  GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int highScore = 0;
  int score = 0;

  String answer = "";
  String answerNumber = "";
  String answerUnit = "";

  String firstNumber = "";

  String questionNumber = "";

  final Color correctColor = Colors.lightGreen;
  final Color incorrectColor = Colors.red.shade300;

  final Color baseColor = Colors.white;

  Color numberCardColor = Colors.white;
  Color timeCardColor = Colors.white;
  bool _isJudgeEnabled = false;
  bool _isButtonsEnabled = true;

  @override
  void didPopNext() {
    _refresh();
  }

  void _refresh() {
    setState(() {
      answer = "";
      answerNumber = "";
      answerUnit = "";
      numberCardColor = baseColor;
      timeCardColor = baseColor;
      _isJudgeEnabled = false;
    });
    setTimer();
    _randomFirstNumber();
    _randomQuestionNumber();
  }

  Timer? _timer;
  int remainTime = 3;

  void setTimer() {
    _timer?.cancel();
    setState(() {
      remainTime = 5;
    });

    _timer = Timer.periodic(
        // 定期実行する間隔の設定.
        Duration(seconds: 1),
        // 定期実行関数.
        (Timer t) {
      setState(() {
        remainTime -= 1;
      });
      if (remainTime == 0) {
        _timer?.cancel();
        setState(() {
          timeCardColor = incorrectColor;
          numberCardColor = incorrectColor;
        });
        showAnswer();

        _onFinish();
      }
    });
  }

  void _onFinish() async {
    setState(() {
      _isJudgeEnabled = false;
      _isButtonsEnabled = false;
    });
    _timer?.cancel();

    await new Future.delayed(new Duration(milliseconds: 2000));
    pushAndInitStateWhenPop();
  }

  void _randomQuestionNumber() {
    var random = new Random();

    setState(() {
      var zeros = _weightedChoice([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
      var questionNumStr = firstNumber + "0" * zeros;
      final formatter = NumberFormat("#,###");
      questionNumber = formatter.format(int.parse(questionNumStr));
    });
  }

  void _randomFirstNumber() {
    var random = new Random();
    setState(() {
      firstNumber = (1 + random.nextInt(9 - 1)).toString();
    });
  }

  void pushAndInitStateWhenPop() async {
    await Navigator.pushNamed(context, "/result", arguments: score);
    _refresh();
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

  void _updateNumber(String tmpNumber) {
    setState(() {
      answerNumber = tmpNumber;
      answer = tmpNumber + answerUnit;
      _isJudgeEnabled = true;
    });
  }

  void _updateUnit(String tmpUnit) {
    setState(() {
      answerUnit = tmpUnit;
      answer = answerNumber + tmpUnit;
    });
  }

  List<String> units = ["", "万", "億"];

  bool _checkAnswer() {
    // return true;
    return questionNumber == answer;
  }

  void showAnswer() {
    setState(() {
      var digits = questionNumber.replaceAll(",", "").length - 1;
      var number = digits % 4;
      var unitIdx = digits ~/ 4;
      var unit = units[unitIdx];
      if (digits > 0) {}
      questionNumber = firstNumber.toString() + "0" * number + unit;
    });
  }

  void _judgeAnswerAndRefresh() async {
    if (answerNumber == "") return;
    showAnswer();
    var result = _checkAnswer();
    var addScore = 0;
    Color color;
    if (result) {
      addScore = 10;
      color = correctColor;
      _timer?.cancel();
    } else {
      color = incorrectColor;
    }
    await new Future.delayed(new Duration(milliseconds: 500));
    setState(() {
      numberCardColor = color;
    });
    if (result) {
      await new Future.delayed(new Duration(milliseconds: 500));
      setState(() {
        score += addScore;
        if (score > highScore) {
          highScore = score;
        }
      });
      _refresh();
    } else {
      _onFinish();
    }
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void getHighScore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = (prefs.getInt('HighScore') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    getHighScore();
    return Scaffold(
      appBar: AppBar(
        title: Text("数読 -SUDOKU-"),
      ),
      body: Column(
        children: [
          SizedBox(height: SizeConfig.getSizePerHeight(3)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "highscore",
                                ),
                                Text(
                                  "$highScore",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                        width: SizeConfig.getSizePerHeight(18),
                        height: SizeConfig.getSizePerHeight(8)),
                  ),
                  Card(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "score",
                              ),
                              Text(
                                score.toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                      width: SizeConfig.getSizePerHeight(18),
                      height: SizeConfig.getSizePerHeight(8),
                    ),
                  ),
                ],
              ),
              Card(
                color: timeCardColor,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "time",
                          ),
                          Text(
                            remainTime.toString(),
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                    ],
                  ),
                  width: SizeConfig.getSizePerHeight(20),
                  height: SizeConfig.getSizePerHeight(17),
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.getSizePerHeight(4),
          ),
          Text("Question"),
          Card(
            color: numberCardColor,
            // Question
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        questionNumber,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
              width: SizeConfig.getSizePerHeight(40),
              height: SizeConfig.getSizePerHeight(10),
            ),
          ),
          SizedBox(
            height: SizeConfig.getSizePerHeight(2),
          ),
          Text("Answer"),
          Card(
            color: numberCardColor,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        answer,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
              width: SizeConfig.getSizePerHeight(40),
              height: SizeConfig.getSizePerHeight(10),
            ),
          ),
          SizedBox(
            height: SizeConfig.getSizePerHeight(6),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: SizeConfig.getSizePerHeight(7),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15)),
                  onPressed: !_isButtonsEnabled
                      ? null
                      : () {
                          _updateNumber("${firstNumber}000");
                        },
                  child: Text("${firstNumber}000"),
                ),
              ),
              SizedBox(
                width: SizeConfig.getSizePerHeight(2),
              ),
              SizedBox(
                height: SizeConfig.getSizePerHeight(7),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15)),
                  onPressed: !_isButtonsEnabled
                      ? null
                      : () {
                          _updateNumber("${firstNumber}00");
                        },
                  child: Text('${firstNumber}00'),
                ),
              ),
              SizedBox(
                width: SizeConfig.getSizePerHeight(2),
              ),
              SizedBox(
                height: SizeConfig.getSizePerHeight(7),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15)),
                  onPressed: !_isButtonsEnabled
                      ? null
                      : () {
                          _updateNumber("${firstNumber}0");
                        },
                  child: Text('${firstNumber}0'),
                ),
              ),
              SizedBox(
                width: SizeConfig.getSizePerHeight(2),
              ),
              SizedBox(
                height: SizeConfig.getSizePerHeight(7),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15)),
                  onPressed: !_isButtonsEnabled
                      ? null
                      : () {
                          _updateNumber("$firstNumber");
                        },
                  child: Text('$firstNumber'),
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.getSizePerHeight(2),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: SizeConfig.getSizePerHeight(2),
              ),
              SizedBox(
                height: SizeConfig.getSizePerHeight(7),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 15),
                  ),
                  onPressed: !_isButtonsEnabled
                      ? null
                      : () {
                          _updateUnit("億");
                        },
                  child: const Text('億'),
                ),
              ),
              SizedBox(
                width: SizeConfig.getSizePerHeight(2),
              ),
              SizedBox(
                height: SizeConfig.getSizePerHeight(7),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 15),
                  ),
                  onPressed: !_isButtonsEnabled
                      ? null
                      : () {
                          _updateUnit("万");
                        },
                  child: const Text('万'),
                ),
              ),
              SizedBox(
                width: SizeConfig.getSizePerHeight(2),
              ),
              SizedBox(
                height: SizeConfig.getSizePerHeight(7),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 15),
                  ),
                  onPressed: !_isButtonsEnabled
                      ? null
                      : () {
                          _updateUnit("");
                        },
                  child: const Text('(なし)'),
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.getSizePerHeight(2),
          ),
          SizedBox(
            height: SizeConfig.getSizePerHeight(7),
            width: SizeConfig.getSizePerHeight(15),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 15),
              ),
              onPressed: !_isJudgeEnabled
                  ? null
                  : () {
                      _judgeAnswerAndRefresh();
                    },
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }
}
