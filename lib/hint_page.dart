import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HintPage extends StatelessWidget {
  List<Widget> hintTable(context) {
    List<Widget> list = [];
    Map map = {
      '読み': '数字',
      '1': '1',
      '10': '10',
      '100': '100',
      '1000': '1,000',
      '1万': '10,000',
      '10万': '100,000',
      '100万': '1,000,000',
      '1000万': '10,000,000',
      '1億': '100,000,000',
      '10億': '1,000,000,000',
      '100億': '10,000,000,000',
      '1000億': '100,000,000,000'
    };
    var count = 0;
    var isHeader = true;
    map.forEach((var key, var value) {
      var topMargin = 10;
      double dividerThickness = 1;
      Color dividerColor = Colors.black12;
      if (count % 4 == 1) {
        topMargin = 20;
      } else if (count % 4 == 0) {
        dividerThickness = 2;
        dividerColor = Colors.black26;
      }
      count++;
      list.addAll([
        SizedBox(
          height: topMargin.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                alignment: Alignment.centerRight,
                width: 60,
                child: Text(
                  key,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
            Container(
                alignment: Alignment.center,
                width: 60,
                child: Text(isHeader ? "" : "→")),
            Container(
                alignment: Alignment.centerRight,
                width: 120,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
          ],
        ),
        Divider(
          thickness: dividerThickness,
          color: dividerColor,
          indent: 60.h,
          endIndent: 60.h,
        )
      ]);
      isHeader = false;
    });
    list.addAll([
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('戻る'),
      )
    ]);
    return list;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('ヒント'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: hintTable(context),
          ),
        ),
      ),
    );
  }
}
