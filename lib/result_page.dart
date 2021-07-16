import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    final score = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: Text('結果発表!'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: [
              Text("得点:" + score.toString()),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("リトライ"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/first'));
                },
                child: Text('トップに戻る'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
