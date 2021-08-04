import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'admob_widget.dart';
import 'empty_app_bar.dart';
import 'game_model.dart';

class GamePage extends StatefulWidget {
  GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int highScore = 0;
  int score = 0;

  final Color baseColor = Colors.white;

  bool isFirst=true;

  void _init() {
    // initTimer();

  }

  void _refresh() {
    updateTimer();
    gameModel.refresh();
  }

  Timer? _timer;

  void updateTimer() {
    _timer?.cancel();
    gameModel.remainTime = 5;
    initTimer();
  }

  void initTimer() {
    _timer = Timer.periodic(
        // 定期実行する間隔の設定.
        Duration(seconds: 1),
        // 定期実行関数.
        (Timer t) {
      gameModel.remainTime -= 1;
      if (gameModel.remainTime == 0) {
        _timer?.cancel();
        gameModel.onTimeOver();

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
      addScore = 1;
      _timer?.cancel();
    } else {}
    await new Future.delayed(new Duration(milliseconds: 500));
    gameModel.changeCardColor(result);
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
        appBar: EmptyAppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              SizedBox(
                height: 100.h,
              ),
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
                                      "ハイスコア",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    SizedBox(height:15.h),
                                    Text(
                                      "$highScore",
                                      style: TextStyle(fontSize: 25),
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
                                    "正解数",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  SizedBox(height:15.h),
                                  Text(
                                    score.toString(),
                                    style: TextStyle(fontSize: 25),
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
                                  "残り時間",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                Text(
                                  model.remainTime>=0?model.remainTime.toString():"-",
                                  // model.remainTime.toString(),
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
    //           Text("Question",
    //               style: TextStyle(color: Colors.blue),
    // ),
              SizedBox(
                height: 50.h,
              ),
              Divider(thickness:2,indent:100.h,endIndent: 100.h,),
              SizedBox(
                height: 50.h,
              ),
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
                              style: TextStyle(fontSize: 30),
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
                height: 20.h,
              ),
              // Text("Answer",
              //   style: TextStyle(color: Colors.blue),
              // ),
              Icon(Icons.arrow_downward,size:80.h),
              SizedBox(
                height: 20.h,
              ),
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
                              style: TextStyle(fontSize: 30),
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
                  NumberButton(zeros: "000"),
                  SizedBox(
                    width: 40.h,
                  ),
                  NumberButton(zeros: "00"),
                  SizedBox(
                    width: 40.h,
                  ),
                  NumberButton(zeros: "0"),
                  SizedBox(
                    width: 40.h,
                  ),
                  NumberButton(zeros: ""),
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
                  UnitButton(unit: "億"),
                  SizedBox(
                    width: 40.h,
                  ),
                  UnitButton(unit: "万"),
                  SizedBox(
                    width: 40.h,
                  ),
                  UnitButton(unit: "")
                ],
              ),
              SizedBox(
                height: 40.h,
              ),
              SizedBox(
                  height: 140.h,
                  width: 300.h,
                  child: Consumer<GameModel>(builder: (context, model, child) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                      onPressed: !model.canAnswer
                          ? null
                          : () {
                              _judgeAnswerAndRefresh();
                            },
                      child: const Text('OK'),
                    );
                  })),
            ]),
            AdmobBannerAdWidget(),
          ],
        ));
  }
}

class NumberButton extends StatelessWidget {
  final String zeros;

  const NumberButton({required this.zeros, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 140.h,
        child: Consumer<GameModel>(
          builder: (context, model, child) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 15)),
              onPressed: !model.isButtonsEnabled
                  ? null
                  : () {
                      model.updateNumber("${model.firstNumber}$zeros");
                    },
              child: Text("${model.firstNumber}$zeros"),
            );
          },
        ));
  }
}

class UnitButton extends StatelessWidget {
  final String unit;

  const UnitButton({required this.unit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 140.h,
        child: Consumer<GameModel>(
          builder: (context, model, child) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 15),
              ),
              onPressed: !model.isButtonsEnabled
                  ? null
                  : () {
                      model.updateUnit(unit);
                    },
              child: child,
            );
          },
          child: Text(unit != "" ? unit : "(なし)"),
        ));
  }
}
