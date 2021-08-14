import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/viewmodel/settings_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common/admob_widget.dart';
import 'common/empty_app_bar.dart';

class SettingsPage extends StatelessWidget {
  final String googleFormURL =
      "https://docs.google.com/forms/d/e/1FAIpQLSf0WsAufMiUA0SWyNo_pZfXd39kWZOIH50pjGFMP78nRNr7AQ/viewform";
  late SettingsModel settingsModel;
  late PackageInfo packageInfo;

  Future<void> loadPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    settingsModel = Provider.of<SettingsModel>(context, listen: false);
    loadPackageInfo();
    print("volume: " + settingsModel.soundVolume.toString());
    return MaterialApp(
      home: Scaffold(
        appBar: EmptyAppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListView(shrinkWrap: true, children: [
              SizedBox(height: 100.h),
              soundMenuItem(context, "音声オン", "音声オフ", Icon(Icons.volume_up),
                  Icon(Icons.volume_off),
                  isFirst: true),
              _menuItem(context, "遊び方", Icon(Icons.videogame_asset)),
              _menuItem(context, "ヒント", Icon(Icons.lightbulb), route: "/hint"),
              _menuItem(context, "お問い合わせフォーム", Icon(Icons.mail),
                  url: googleFormURL),
              _menuItem(context, "", null),
              _menuItem(context, "バージョン情報", Icon(Icons.info), onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: packageInfo.appName,
                  // アプリの名前
                  applicationVersion: packageInfo.version,
                  // バージョン
                  applicationIcon: MyAppIcon(),
                  // アプリのアイコン Widget
                  applicationLegalese: "© 2021 miyashiiii game studio", // 権利情報
                );
              }),
            ]),
            AdmobBannerAdWidget(),
          ],
        ),
      ),
    );
  }

  void _launchURL(url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  Widget _menuItem(BuildContext context, String title, Icon? icon,
      {String? route, String? url, Function? onTap, bool isFirst = false}) {
    BorderSide borderSide = BorderSide(width: 1.0, color: Colors.grey);
    return Container(
      decoration: new BoxDecoration(
          border: new Border(
              top: isFirst ? borderSide : BorderSide.none, bottom: borderSide)),
      child: ListTile(
          leading: icon,
          title: Text(
            title,
            style: TextStyle(color: Colors.black, fontSize: 18.0),
          ),
          onTap: () {
            if (route != null) {
              Navigator.pushNamed(context, route);
            } else if (url != null) {
              _launchURL(url);
            } else if (onTap != null) {
              onTap();
            }
          } // タップ
          ),
    );
  }

  Widget soundMenuItem(BuildContext context, String titleOn, String titleOff,
      Icon iconOn, Icon iconOff,
      {String? route, String? url, bool isFirst = false}) {
    return Consumer<SettingsModel>(builder: (context, model, child) {
      String title;
      Icon icon;
      if (model.isPlaySound) {
        title = titleOn;
        icon = iconOn;
      } else {
        title = titleOff;
        icon = iconOff;
      }
      return _menuItem(context, title, icon, onTap: () {
        model.toggleSound();
      });
    });
  }
}

class MyAppIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          width: 200.h,
          height: 200.h,
          child: Image(image: AssetImage('assets/images/sudoku_logo.png')),
        ),
      ),
    );
  }
}
