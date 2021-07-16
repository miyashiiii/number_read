import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _highScore = 0;

  void checkHighScore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScore = (prefs.getInt('HighScore') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    checkHighScore();
    return Scaffold(
      appBar: AppBar(
        title: Text('数字読みトレーニング'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: [
              Text("数字読みトレーニング"),
              Text("ハイスコア:" + _highScore.toString()),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/game");
                },
                child: Text('ゲーム開始'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
