import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/analytics.dart';

import 'admob_widget.dart';
import 'empty_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      appBar: EmptyAppBar(),
      body: Container(
        // padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 300.h,
                  ),
                  Text(
                    "結果発表!",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 100.h,
                  ),
                  Visibility(
                    child: Text('ハイスコア更新！'),
                    visible: _isHighScore,
                  ),
                  Text("正解数: " + score.toString(),
                      style: TextStyle(fontSize: 20)),
                  SizedBox(
                    height: 300.h,
                  ),
                  SizedBox(
                    height: 120.h,
                    width: 500.h,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.pop(context);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "/game", ModalRoute.withName("/first"));
                      },
                      child: Text("リトライ"),
                    ),
                  ),
                  SizedBox(height: 50.h),
                  SizedBox(
                    height: 120.h,
                    width: 500.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/first", (r) => false);
                      },
                      child: Text('トップに戻る'),
                    ),
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
