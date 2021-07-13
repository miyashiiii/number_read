import 'package:flutter/material.dart';
import 'package:number_read/result.dart';
import 'package:page_transition/page_transition.dart';
import "dart:math";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String answer = "";
  String answerNumber = "";
  String answerUnit = "";

  String firstNumber = "";


  void _refresh() {
    setState(() {
      answer = "";
      answerNumber = "";
      answerUnit = "";
    });
    _randomFirstNumber();
  }



  void _randomFirstNumber() {
    var random = new Random();
    setState(() {
      firstNumber = (1 + random.nextInt(9 - 1)).toString();
    });
  }

  int _weightedChoice(List<int> weights) {
    List<int> l = [];
    weights.asMap().forEach((int idx, int weight) {
      // weightsの各要素とそのindexを取得
      l += List.filled(weight, idx); // 長さ:weight, 全要素がidxの作成してlに連結していく
    });
    //print(l); // ["0", "1", "1", "2", "2", "2", "3", "3", "3", "3", ]

    // 上記で生成した配列から1つ選ぶことで、重みつきのchoiceを実行
    var _random = new Random();
    return l[_random.nextInt(l.length)];
  }

  void _updateNumber(String tmpNumber) {
    setState(() {
      answerNumber = tmpNumber;
      answer = tmpNumber + answerUnit;
    });
  }

  void _updateUnit(String tmpUnit) {
    setState(() {
      answerUnit = tmpUnit;
      answer = answerNumber + tmpUnit;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("number read training"),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "highscore",
                              ),
                              Text(
                                "10",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                      width: 180,
                      height: 80,
                    ),
                  ),
                  Card(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "score",
                              ),
                              Text(
                                "10",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                      width: 180,
                      height: 80,
                    ),
                  ),
                ],
              ),
              Card(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "time",
                          ),
                          Text(
                            "10",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                  width: 180,
                  height: 180,
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Text("Question"),
          Card(
            // Question
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        firstNumber+"00,000,000",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
              width: 300,
              height: 80,
            ),
          ),
          SizedBox(height: 20),
          Text("Answer"),
          Card(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        answer,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
              width: 300,
              height: 80,
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15)),
                  onPressed: () {
                    _updateNumber("${firstNumber}000");
                  },
                  child: Text("${firstNumber}000"),
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15)),
                  onPressed: () {
                    _updateNumber("${firstNumber}00");
                  },
                  child: Text('${firstNumber}00'),
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15)),
                  onPressed: () {
                    _updateNumber("${firstNumber}0");
                  },
                  child: Text('${firstNumber}0'),
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15)),
                  onPressed: () {
                    _updateNumber("$firstNumber");
                  },
                  child: Text('$firstNumber'),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15),
                      primary: Colors.green),
                  onPressed: () {
                    _updateUnit("億");
                  },
                  child: const Text('億'),
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15),
                      primary: Colors.green),
                  onPressed: () {
                    _updateUnit("万");
                  },
                  child: const Text('万'),
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15),
                      primary: Colors.green),
                  onPressed: () {
                    _updateUnit("");
                  },
                  child: const Text('(なし)'),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              _refresh();
              // Navigator.push(
              //     context,
              //     PageTransition(
              //         type: PageTransitionType.fade, child: ResultPage()));
            },
            child: const Icon(Icons.navigate_next),
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
