import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common/admob_widget.dart';
import 'common/empty_app_bar.dart';

class SettingsPage extends StatelessWidget {
  String googleFormURL ="https://docs.google.com/forms/d/e/1FAIpQLSf0WsAufMiUA0SWyNo_pZfXd39kWZOIH50pjGFMP78nRNr7AQ/viewform";
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
              _menuItem(context,"お問い合わせフォーム", Icon(Icons.mail),url:googleFormURL),
              _menuItem(context,"", null),
              _menuItem(context,"権利表記", Icon(Icons.edit)),
              Container(child: Text("version"),height: 200.h,alignment: Alignment.center,),
            ]),
              AdmobBannerAdWidget(),
            ],
      ),
    ),);
  }
  void _launchURL(url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  Widget _menuItem(BuildContext context,String title, Icon? icon, {String? route, String? url, bool isFirst=false }) {
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
          else if(url!=null){
            _launchURL(url);
          }
        } // タップ
      ),
    );
  }
}
