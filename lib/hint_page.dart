import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HintPage extends StatelessWidget {
  Divider createDivider(index) {
    double dividerThickness = 1;
    Color dividerColor = Colors.black12;
    if (index % 4 == 0) {
      dividerThickness = 2;
      dividerColor = Colors.black26;
    }
    return Divider(
      height: 4.h,
      indent: 100.h,
      endIndent: 100.h,
      thickness: dividerThickness,
      color: dividerColor,
    );
  }

  @override
  Widget build(BuildContext context) {
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
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('ヒント'),
          ),
          body: Column(children: [
            Expanded(
                child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: map.length + 1,
                    separatorBuilder: (context, index) {
                      return createDivider(index);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      if (index == map.length) {
                        return createDivider(index);
                      }
                      bool isHeader = index == 0;
                      String key = map.keys.elementAt(index);
                      var topMargin = 0.h;
                      if (index % 4 == 1) {
                        topMargin = 30.h;
                      }
                      return Container(
                          height: 100.h+topMargin,
                          padding: EdgeInsets.only(top:topMargin),
                          child: Row(
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
                                    map[key],
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  )),
                            ],
                          ));
                    })),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('戻る'),
            ),
            SizedBox(height: 150.h),
          ])),
    );
  }
}
