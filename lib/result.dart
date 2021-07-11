import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'main.dart';

class ResultPage extends StatelessWidget {
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
            children: <Widget>[
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
