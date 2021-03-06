import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/analytics.dart';

import 'common/admob_widget.dart';
import 'common/empty_app_bar.dart';

class ResultPage extends StatefulWidget {
  ResultPage({Key? key}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _isHighScore = false;

  void checkHighScore(int score) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int highScore = (prefs.getInt('HighScore') ?? 0);
    if (score > highScore) {
      Analytics.analytics.logPostScore(score: score);
      setState(() {
        _isHighScore = true;
      });
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
