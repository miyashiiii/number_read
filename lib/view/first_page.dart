import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/admob_widget.dart';
import 'common/empty_app_bar.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _highScore = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> checkHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScore = prefs.getInt('HighScore') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      designSize: const Size(1080, 2160),
    );
    checkHighScore();
    return Scaffold(
      appBar: EmptyAppBar(),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 400.h),
                  SizedBox(
                    height: 500.h,
                    width: 500.h,
                    child: const Image(
                      image: AssetImage('assets/images/sudoku_logo.png'),
                    ),
                  ),
                  SizedBox(height: 200.h),
                  Text('ハイスコア: $_highScore'),
                  SizedBox(height: 100.h),
                  SizedBox(
                    height: 120.h,
                    width: 500.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                      child: const Text('設定'),
                    ),
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  SizedBox(
                    height: 120.h,
                    width: 500.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/game');
                      },
                      child: const Text('ゲーム開始'),
                    ),
                  ),
                ],
              ),
              const AdmobBannerAdWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
