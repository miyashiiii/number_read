import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'common/admob_widget.dart';
import 'common/empty_app_bar.dart';

class HintPage extends StatelessWidget {
  const HintPage({super.key});

  Divider createDivider(index) {
    var dividerThickness = 1;
    var dividerColor = Colors.black12;
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
    final Map map = {
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
        appBar: const EmptyAppBar(),
        body: Column(
          children: [
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
                  final isHeader = index == 0;
                  final String key = map.keys.elementAt(index);
                  var topMargin = 0.h;
                  if (index % 4 == 1) {
                    topMargin = 30.h;
                  }
                  return Container(
                    height: 100.h + topMargin,
                    padding: EdgeInsets.only(top: topMargin),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          width: 60,
                          child: Text(
                            key,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 60,
                          child: Text(isHeader ? '' : '→'),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          width: 120,
                          child: Text(
                            map[key],
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('戻る'),
            ),
            SizedBox(height: 50.h),
            const AdmobBannerAdWidget(),
          ],
        ),
      ),
    );
  }
}
