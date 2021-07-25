import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _highScore = 0;

  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  void checkHighScore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScore = (prefs.getInt('HighScore') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      // error log
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      // error log
    }
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(1080, 2160),
        orientation: Orientation.portrait);
    checkHighScore();
    return Scaffold(
      appBar: AppBar(
        title: Text('数読 -SUDOKU-'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              Text("ハイスコア:" + _highScore.toString()),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/hint");
                },
                child: Text('ヒント'),
              ),
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
