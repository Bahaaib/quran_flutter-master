import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:preferences/preference_service.dart';
import 'package:provider/provider.dart';

import 'package:quran_images/data/moor_database.dart';
import 'package:quran_images/module/quran/show.dart';
import 'package:quran_images/setting_page.dart';
import 'package:quran_images/splash.dart';

import 'helper/app_localizations.dart';

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.blueGrey[900]
    ));
    // TODO: implement build
    return Provider(
      builder: (_) => AppDatabase(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "القران الكريم",
        supportedLocales: [
          Locale('ar', 'SA'),
          Locale('en', 'US'),
        ],
        // These delegates make sure that the localization data for the proper language is loaded
        localizationsDelegates: [
          // THIS CLASS WILL BE ADDED LATER
          // A class which loads the translations from JSON files
          AppLocalizations.delegate,
          // Built-in localization of basic text for Material widgets
          GlobalMaterialLocalizations.delegate,
          // Built-in localization for text direction LTR/RTL
          GlobalWidgetsLocalizations.delegate,
        ],
        // Returns a locale which will be used by the app
        localeResolutionCallback: (locale, supportedLocales) {
          // Check if the current device locale is supported
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == PrefService.getString("lang")) {
              return supportedLocale;
            }
          }
          // If the locale of the device is not supported, use the first one
          // from the list (English, in this case).
          return supportedLocales.first;
        },
        theme: ThemeData(
          primaryColor: Colors.blueGrey[800],
          fontFamily: "cairo",
        ),
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          '/HomeScreen': (BuildContext context) => QuranShow(initialPageNum: PrefService.getInt("start_page")),
          '/SettingPage': (BuildContext context) => SettingPage()
        },
      ),
    );
  }
}