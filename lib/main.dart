import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:number_read/first_page.dart';
import 'package:number_read/result_page.dart';
import 'package:page_transition/page_transition.dart';

import 'game_page.dart';
import 'hint_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const locale = Locale("ja", "JP");

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        locale: locale,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          locale,
        ],
        initialRoute: '/first',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/first':
              return PageTransition(
                child: FirstPage(),
                type: PageTransitionType.fade,
                settings: settings,
              );
            case '/hint':
              return PageTransition(
                child: HintPage(),
                type: PageTransitionType.fade,
                settings: settings,
              );
            case '/game':
              return PageTransition(
                child: GamePage(),
                type: PageTransitionType.fade,
                settings: settings,
              );
            case '/result':
              return PageTransition(
                child: ResultPage(),
                type: PageTransitionType.fade,
                settings: settings,
              );
            default:
              return null;
          }
        });
  }
}
