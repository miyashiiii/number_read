import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/viewmodel/settings_model.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../viewmodel/game_model.dart';
import 'common/admob_widget.dart';
import 'common/empty_app_bar.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final Color baseColor = Colors.white;

  bool isFirst = true;
  AnimationController? timeBarController;

  final _audioPlayer = AudioPlayer();

  Timer? _timer;

  late GameModel gameModel;
  late SettingsModel settingsModel;

  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey keyButtonQuestion = GlobalKey();
  GlobalKey keyButtonAnswer = GlobalKey();
  GlobalKey keyButtonKeyBoard = GlobalKey();
  GlobalKey keyTimeIndicator = GlobalKey();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('state = $state');
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('onResumed');
        _audioPlayer.play();
        break;
      case AppLifecycleState.inactive:
        debugPrint('onInActive');
        break;
      case AppLifecycleState.paused:
        debugPrint('onPaused');
        _audioPlayer.pause();
        break;
      case AppLifecycleState.detached:
        debugPrint('onDetached');
        break;
    }
  }

  void startTimeBar() {
    timeBarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )
      ..addListener(() {
        setState(() {});
      })
      ..forward();
  }

  void _refresh() {
    updateTimer();
    gameModel.newQuestion();
  }

  void updateTimer() {
    _timer?.cancel();
    gameModel.remainTime = 5;
    initTimer();
    startTimeBar();
  }

  void initTimer() {
    _timer = Timer.periodic(
        // 定期実行する間隔の設定.
        const Duration(seconds: 1),
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

  Future<void> _onTimeOver() async {
    gameModel.isButtonsEnabled = false;
    gameModel.onFinish();

    await Future.delayed(const Duration(milliseconds: 2000));
    await _audioPlayer.dispose();
    await pushAndInitStateWhenPop();
  }

  Future<void> pushAndInitStateWhenPop() async {
    await Navigator.pushNamed(context, '/result', arguments: gameModel.score);

    gameModel.gameInit();
    await startMusic();
    timeBarController = null;
  }

  Future<void> _judgeAnswerAndRefresh() async {
    gameModel.canAnswer = false;
    gameModel.showAnswer();
    final isCorrect = gameModel.questionNumber == gameModel.answer;
    debugPrint(gameModel.questionNumber);

    _timer?.cancel();
    timeBarController?.stop();
    await Future.delayed(const Duration(milliseconds: 500));
    gameModel.changeCardColor(isCorrect);
    if (isCorrect) {
      await Future.delayed(const Duration(milliseconds: 500));
      gameModel.updateHighScore();

      _refresh();
    } else {
      await _onTimeOver();
    }
  }

  _checkIsDoneTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    final isDoneTutorial = prefs.getBool('isDoneTutorial') ?? false;
    if (!isDoneTutorial) {
      showTutorial();
    }
    // Future.delayed(Duration.zero, showTutorial);
    await prefs.setBool('isDoneTutorial', true);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    startMusic();
    _checkIsDoneTutorial();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    timeBarController?.dispose();
    tutorialCoachMark.finish();
    super.dispose();
  }

  Future<void> startMusic() async {
    await _audioPlayer.setAsset('assets/audio/thinkingtime7.mp3');
    await _audioPlayer.setLoopMode(LoopMode.one);
    await _audioPlayer.setVolume(settingsModel.soundVolume);
    if (settingsModel.isPlaySound) {
      await _audioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    gameModel = Provider.of<GameModel>(context, listen: false);
    settingsModel = Provider.of<SettingsModel>(context, listen: false);
    return Scaffold(
      appBar: EmptyAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: 100.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
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
              Consumer<GameModel>(
                builder: (context, model, child) {
                  return Card(
                    key: keyButtonQuestion,
                    color: model.numberCardColor,
                    // Question
                    child: SizedBox(
                      width: 800.h,
                      height: 200.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                model.questionNumber,
                                style: const TextStyle(fontSize: 30),
                                strutStyle: const StrutStyle(
                                  fontSize: 30,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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
              Consumer<GameModel>(
                builder: (context, model, child) {
                  return Card(
                    key: keyButtonAnswer,
                    color: model.numberCardColor,
                    child: SizedBox(
                      width: 800.h,
                      height: 200.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                model.answer,
                                style: const TextStyle(fontSize: 30),
                                strutStyle: const StrutStyle(
                                  fontSize: 30,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 50.h,
              ),
              SizedBox(
                width: 950.h,
                key: keyTimeIndicator,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('残り時間:', style: TextStyle(fontSize: 40.h)),
                    Consumer<GameModel>(
                      builder: (context, model, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 700.h,
                              child: LinearProgressIndicator(
                                backgroundColor: model.timeCardColor,
                                minHeight: 70.h,
                                value: 1 - (timeBarController?.value ?? 0),
                                semanticsLabel: 'Linear progress indicator',
                              ),
                            ),
                            Text(
                              model.remainTime >= 0
                                  ? model.remainTime.toString()
                                  : '',
                              // "5",
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
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
              SizedBox(
                width: 900.h,
                child: Column(
                  key: keyButtonKeyBoard,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        NumberButton(zeros: '000'),
                        // SizedBox(
                        //   width: 40.h,
                        // ),
                        NumberButton(zeros: '00'),
                        // SizedBox(
                        //   width: 40.h,
                        // ),
                        NumberButton(zeros: '0'),
                        // SizedBox(
                        //   width: 40.h,
                        // ),
                        NumberButton(zeros: ''),
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
                        const UnitButton(unit: '億'),
                        SizedBox(
                          width: 40.h,
                        ),
                        const UnitButton(unit: '万'),
                        SizedBox(
                          width: 40.h,
                        ),
                        const UnitButton(unit: '')
                      ],
                    ),
                    SizedBox(
                      height: 60.h,
                    ),
                    SizedBox(
                      height: 140.h,
                      width: 300.h,
                      child: Consumer<GameModel>(
                        builder: (context, model, child) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 15),
                            ),
                            onPressed: !model.canAnswer
                                ? null
                                : _judgeAnswerAndRefresh,
                            child: const Text('OK'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const AdmobBannerAdWidget(),
        ],
      ),
    );
  }

  void showTutorial() {
    initTargets();
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.blue,
      onFinish: () {
        debugPrint('finish');
      },
      onClickTarget: (target) {
        debugPrint('onClickTarget: $target');
      },
      onSkip: () {
        debugPrint('skip');
      },
      onClickOverlay: (target) {
        debugPrint('onClickOverlay: $target');
      },
    )..show();
  }

  void initTargets() {
    targets.clear();
    addTarget(
      'question',
      keyButtonQuestion,
      ContentAlign.bottom,
      'ここに数字が表示されます。',
      isFirst: true,
    );
    addTarget(
      'keyBoard',
      keyButtonKeyBoard,
      ContentAlign.top,
      'キーボードを使って読みを入力します。',
    );
    addTarget(
      'Answer',
      keyButtonAnswer,
      ContentAlign.bottom,
      '入力した数字はここに表示されます。',
    );
    addTarget(
      'time',
      keyTimeIndicator,
      ContentAlign.top,
      '残り時間に注意しながら、\n連続正解を目指しましょう！\n※1問目は制限時間がありません。',
    );
  }

  Future<void> addTarget(
    String identify,
    GlobalKey key,
    ContentAlign textPos,
    String text, {
    bool isFirst = false,
  }) async {
    targets.add(
      TargetFocus(
        identify: identify,
        keyTarget: key,
        color: Colors.blue,
        shape: ShapeLightFocus.RRect,
        radius: 5,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: textPos,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Visibility(
                      visible: !isFirst,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {
                          controller.previous();
                        },
                        child:
                            const Icon(Icons.chevron_left, color: Colors.blue),
                      ),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class ScoreCard extends StatelessWidget {
  const ScoreCard({required this.isHighScore, super.key});
  final bool isHighScore;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 360.h,
        height: 160.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isHighScore ? 'ハイスコア' : 'スコア',
              style: TextStyle(color: Colors.blue, fontSize: 40.h),
            ),
            SizedBox(height: 15.h),
            Consumer<GameModel>(
              builder: (context, model, child) {
                return Text(
                  isHighScore
                      ? model.highScoreView.toString()
                      : model.score.toString(),
                  style: TextStyle(fontSize: 60.h),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  const NumberButton({required this.zeros, super.key});
  final String zeros;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.h,
      width: 200.h,
      child: Consumer<GameModel>(
        builder: (context, model, child) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(fontSize: 50.h),
            ),
            onPressed: !model.isButtonsEnabled
                ? null
                : () {
                    model.updateNumber('${model.firstNumber}$zeros');
                  },
            child: Text('${model.firstNumber}$zeros'),
          );
        },
      ),
    );
  }
}

class UnitButton extends StatelessWidget {
  const UnitButton({required this.unit, super.key});
  final String unit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.h,
      width: 200.h,
      child: Consumer<GameModel>(
        builder: (context, model, child) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(fontSize: unit != '' ? 50.h : 40.h),
            ),
            onPressed: !model.isButtonsEnabled
                ? null
                : () {
                    model.updateUnit(unit);
                  },
            child: child,
          );
        },
        child: Text(unit != '' ? unit : '(なし)'),
      ),
    );
  }
}
