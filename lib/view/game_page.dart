import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../viewmodel/game_model.dart';
import 'common/admob_widget.dart';
import 'common/empty_app_bar.dart';

class GamePage extends StatefulWidget {
  GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  final Color baseColor = Colors.white;

  bool isFirst = true;
  AnimationController? controller;

  void startProgress() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )
      ..addListener(() {
        setState(() {});
      })
      ..forward();
    // controller.repeat(reverse: true);
  }

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
    startProgress();
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

        _onTimeOver();
      }
    });
  }

  late GameModel gameModel;

  void _onTimeOver() async {
    gameModel.isButtonsEnabled = false;
    _timer?.cancel();
    gameModel.onFinish();

    await new Future.delayed(new Duration(milliseconds: 2000));
    pushAndInitStateWhenPop();
  }

  void pushAndInitStateWhenPop() async {
    await Navigator.pushNamed(context, "/result", arguments: gameModel.score);
    _init();
  }

  void _judgeAnswerAndRefresh() async {
    gameModel.showAnswer();
    var isCorrect = gameModel.questionNumber == gameModel.answer;
    print(gameModel.questionNumber);

    if (isCorrect) {
      _timer?.cancel();
      controller?.stop();
    } else {}
    await new Future.delayed(new Duration(milliseconds: 500));
    gameModel.changeCardColor(isCorrect);
    if (isCorrect) {
      await new Future.delayed(new Duration(milliseconds: 500));
      gameModel.updateHighScore();

      _refresh();
    } else {
      _onTimeOver();
    }
  }

  @override
  void initState() {
    super.initState();
    startMusic();
    _init();
  }

  @override
  void dispose() {
    _ap.stop();
    controller!.dispose();

    super.dispose();
  }

  void startMusic() async {
    _ap = await _player.loop('audio/thinkingtime7.mp3');
  }

  late AudioPlayer _ap;
  AudioCache _player = AudioCache();

  @override
  Widget build(BuildContext context) {
    gameModel = Provider.of<GameModel>(context);
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
                  ScoreCard(isHighScore: true),
                  ScoreCard(isHighScore: false)
                ],
              ),
              SizedBox(
                height: 50.h,
              ),
              Divider(
                thickness: 2,
                indent: 100.h,
                endIndent: 100.h,
              ),
              SizedBox(
                height: 20.h,
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
                height: 10.h,
              ),
              // Text("Answer",
              //   style: TextStyle(color: Colors.blue),
              // ),
              Icon(Icons.arrow_downward, size: 60.h),
              SizedBox(
                height: 10.h,
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
                height: 50.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("残り時間:", style: TextStyle(fontSize: 15)),
                  SizedBox(
                    width: 50.h,
                  ),
                  Consumer<GameModel>(builder: (context, model, child) {
                    return Stack(alignment: Alignment.center, children: [
                      SizedBox(
                        width: 700.h,
                        child: LinearProgressIndicator(
                          backgroundColor: model.timeCardColor,
                          minHeight: 80.h,
                          value: 1 - (controller?.value ?? 0),
                          semanticsLabel: 'Linear progress indicator',
                        ),
                      ),
                      Text(
                        model.remainTime >= 0
                            ? model.remainTime.toString()
                            : "",
                        // "5",
                        style: TextStyle(fontSize: 20),
                      )
                    ]);
                  }),
                ],
              ),
              SizedBox(
                height: 50.h,
              ),
              Divider(
                thickness: 2,
                indent: 100.h,
                endIndent: 100.h,
              ),
              SizedBox(
                height: 100.h,
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
                height: 40.h,
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
                height: 60.h,
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

class ScoreCard extends StatelessWidget {
  final bool isHighScore;

  const ScoreCard({required this.isHighScore, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isHighScore ? "ハイスコア" : "スコア",
                style: TextStyle(color: Colors.blue),
              ),
              SizedBox(height: 15.h),
              Consumer<GameModel>(builder: (context, model, child) {
                return Text(
                  isHighScore
                      ? model.highScoreView.toString()
                      : model.score.toString(),
                  style: TextStyle(fontSize: 25),
                );
              }),
            ],
          ),
          width: 360.h,
          height: 160.h),
    );
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
