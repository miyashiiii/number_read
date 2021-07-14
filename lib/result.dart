import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'main.dart';

class ResultPage extends StatefulWidget {
  final int score;

  ResultPage({required this.score});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NextPage'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: [
              Text(widget.score.toString()),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade, child: MyHomePage()));
                },
                child: Text('mainページに戻る'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
