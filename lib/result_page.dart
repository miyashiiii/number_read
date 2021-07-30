import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/analytics.dart';

import 'admob_widget.dart';

class ResultPage extends StatelessWidget {
  int _highScore = 0;
  bool _isHighScore = false;

  void checkHighScore(int score) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _highScore = (prefs.getInt('HighScore') ?? 0);
    if (score > _highScore) {
      Analytics.analytics.logPostScore(score: score);
      _isHighScore = true;
      await prefs.setInt('HighScore', score);
    }
  }

  @override
  Widget build(BuildContext context) {
    final score = ModalRoute.of(context)!.settings.arguments as int;
    checkHighScore(score);

    return Scaffold(
      appBar: AppBar(
        title: Text('結果発表!'),
        centerTitle: true,
      ),
      body: Container(
        // padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Visibility(
                    child: Text('ハイスコア更新！'),
                    visible: _isHighScore,
                  ),
                  Text("得点:" + score.toString()),
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          "/game", ModalRoute.withName("/first"));
                    },
                    child: Text("リトライ"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/first", (r) => false);
                    },
                    child: Text('トップに戻る'),
                  ),

                ],
              ),
              AdmobBannerAdWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
