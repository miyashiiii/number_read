import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'game_model.dart';

class GamePage extends StatefulWidget {
  GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int highScore = 0;
  int score = 0;

  final Color correctColor = Colors.lightGreen;
  final Color incorrectColor = Colors.red.shade300;

  final Color baseColor = Colors.white;

  void _init() {
    setState(() {
      ;
    });
    setTimer();
  }

  void _refresh() {
    _init();
    gameModel.refresh();
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
          gameModel.timeCardColor = incorrectColor;
          gameModel.numberCardColor = incorrectColor;
        });

        gameModel.showAnswer();
        _onFinish();
      }
    });
  }

  late GameModel gameModel;

  void _onFinish() async {
    gameModel.isButtonsEnabled = false;
    _timer?.cancel();
    gameModel.onFinish();

    await new Future.delayed(new Duration(milliseconds: 2000));
    pushAndInitStateWhenPop();
  }

  void pushAndInitStateWhenPop() async {
    await Navigator.pushNamed(context, "/result", arguments: score);
    _init();
  }

  void _judgeAnswerAndRefresh() async {
    gameModel.showAnswer();
    var result = gameModel.questionNumber == gameModel.answer;
    print(gameModel.questionNumber);

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
    gameModel.numberCardColor = color;
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
    _init();
  }

  void getHighScore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = (prefs.getInt('HighScore') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    gameModel = Provider.of<GameModel>(context);
    getHighScore();
    return Scaffold(
      appBar: AppBar(
        title: Text("数読 -SUDOKU-"),
      ),
      body: Column(
        children: [
          SizedBox(height: 60.h),
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
                        width: 360.h,
                        height: 160.h),
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
                      width: 360.h,
                      height: 160.h,
                    ),
                  ),
                ],
              ),
              Consumer<GameModel>(builder: (context, model, child) {
                return Card(
                  color: model.timeCardColor,
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
                    width: 400.h,
                    height: 340.h,
                  ),
                );
              })
            ],
          ),
          SizedBox(
            height: 80.h,
          ),
          Text("Question"),
          Consumer<GameModel>(builder: (context, model, child) {
            return Card(
              color: model.numberCardColor,
              // Question
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          model.questionNumber,
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
                width: 800.h,
                height: 200.h,
              ),
            );
          }),
          SizedBox(
            height: 40.h,
          ),
          Text("Answer"),
          Consumer<GameModel>(builder: (context, model, child) {
            return Card(
              color: model.numberCardColor,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          model.answer,
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
                width: 800.h,
                height: 200.h,
              ),
            );
          }),
          SizedBox(
            height: 120.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 140.h,
                  child: Consumer<GameModel>(
                    builder: (context, model, child) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 15)),
                        onPressed: !model.isButtonsEnabled
                            ? null
                            : () {
                                model.updateNumber("${model.firstNumber}000");
                              },
                        child: Text("${model.firstNumber}000"),
                      );
                    },
                  )),
              SizedBox(
                width: 40.h,
              ),
              SizedBox(
                  height: 140.h,
                  child: Consumer<GameModel>(
                    builder: (context, model, child) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 15)),
                        onPressed: !model.isButtonsEnabled
                            ? null
                            : () {
                                model.updateNumber("${model.firstNumber}00");
                              },
                        child: Text("${model.firstNumber}00"),
                      );
                    },
                  )),
              SizedBox(
                width: 40.h,
              ),
              SizedBox(
                  height: 140.h,
                  child: Consumer<GameModel>(
                    builder: (context, model, child) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 15)),
                        onPressed: !model.isButtonsEnabled
                            ? null
                            : () {
                                model.updateNumber("${model.firstNumber}0");
                              },
                        child: Text("${model.firstNumber}0"),
                      );
                    },
                  )),
              SizedBox(
                width: 40.h,
              ),
              SizedBox(
                  height: 140.h,
                  child: Consumer<GameModel>(
                    builder: (context, model, child) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 15)),
                        onPressed: !model.isButtonsEnabled
                            ? null
                            : () {
                                model.updateNumber("${model.firstNumber}");
                              },
                        child: Text("${model.firstNumber}"),
                      );
                    },
                  )),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 40.h,
              ),
              SizedBox(
                  height: 140.h,
                  child: Consumer<GameModel>(builder: (context, model, child) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                      onPressed: !model.isButtonsEnabled
                          ? null
                          : () {
                              model.updateUnit("億");
                            },
                      child: const Text('億'),
                    );
                  })),
              SizedBox(
                width: 40.h,
              ),
              SizedBox(
                  height: 140.h,
                  child: Consumer<GameModel>(builder: (context, model, child) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                      onPressed: !model.isButtonsEnabled
                          ? null
                          : () {
                              model.updateUnit("万");
                            },
                      child: const Text('万'),
                    );
                  })),
              SizedBox(
                width: 40.h,
              ),
              SizedBox(
                  height: 140.h,
                  child: Consumer<GameModel>(builder: (context, model, child) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                      onPressed: !model.isButtonsEnabled
                          ? null
                          : () {
                              model.updateUnit("");
                            },
                      child: const Text('なし'),
                    );
                  })),
            ],
          ),
          SizedBox(
            height: 40.h,
          ),
          SizedBox(
            height: 140.h,
            width: 300.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 15),
              ),
              onPressed: !gameModel.canAnswer
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
