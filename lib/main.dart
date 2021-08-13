import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/view/first_page.dart';
import 'package:sudoku/view/settings_page.dart';
import 'package:sudoku/viewmodel/game_model.dart';
import 'package:sudoku/view/result_page.dart';

import 'view/game_page.dart';
import 'view/hint_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const locale = Locale("ja", "JP");

    return MultiProvider(
    providers: [
      ChangeNotifierProvider<GameModel>(create: (context) => GameModel()),
    ],
    child:MaterialApp(
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
            case '/settings':
              return PageTransition(
                child: SettingsPage(),
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
        })
    );
  }
}
