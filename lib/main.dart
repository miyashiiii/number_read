import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/view/first_page.dart';
import 'package:sudoku/view/result_page.dart';
import 'package:sudoku/view/settings_page.dart';
import 'package:sudoku/viewmodel/game_model.dart';
import 'package:sudoku/viewmodel/settings_model.dart';

import 'view/game_page.dart';
import 'view/hint_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runZonedGuarded(() {
    MobileAds.instance.initialize();
    SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],)
        .then((_) {
      runApp(MyApp());
    });
  }, FirebaseCrashlytics.instance.recordError,);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const locale = Locale('ja', 'JP');

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<SettingsModel>(
            create: (context) => SettingsModel(),
          ),
        ],
        child: MaterialApp(
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
                    child: ChangeNotifierProvider<GameModel>(
                        create: (_) => GameModel(), child: const GamePage(),),
                    type: PageTransitionType.fade,
                    settings: settings,
                  );
                case '/result':
                  return PageTransition(
                    child: const ResultPage(),
                    type: PageTransitionType.fade,
                    settings: settings,
                  );
                default:
                  return null;
              }
            },),);
  }
}
