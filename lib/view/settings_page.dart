import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'common/admob_widget.dart';
import 'common/empty_app_bar.dart';

class SettingsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: EmptyAppBar(),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            ListView(
            shrinkWrap: true,

            children: [
              SizedBox(height:100.h),
              _menuItem(context,"音声オフ", Icon(Icons.volume_off),isFirst:true),
              _menuItem(context,"遊び方", Icon(Icons.videogame_asset)),
              _menuItem(context,"ヒント", Icon(Icons.lightbulb),route:"/hint"),
              _menuItem(context,"お問い合わせフォーム", Icon(Icons.mail)),
              _menuItem(context,"", null),
              _menuItem(context,"権利表記", Icon(Icons.edit)),
              Container(child: Text("version"),height: 200.h,alignment: Alignment.center,),
            ]),
              AdmobBannerAdWidget(),
            ],
      ),
    ),);
  }

  Widget _menuItem(BuildContext context,String title, Icon? icon, {String? route,bool isFirst=false }) {
    BorderSide borderSide = BorderSide(width: 1.0, color: Colors.grey);
    return Container(
      decoration: new BoxDecoration(
          border:
          new Border(top: isFirst? borderSide: BorderSide.none, bottom: borderSide )),
      child: ListTile(
        leading: icon,
        title: Text(
          title,
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        onTap: () {
          if(route!=null){

            Navigator.pushNamed(context, route);
          }
        } // タップ
      ),
    );
  }
}
