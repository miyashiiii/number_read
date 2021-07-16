import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
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
