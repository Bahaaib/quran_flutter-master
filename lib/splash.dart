import 'dart:async';

import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';
import 'package:quran_images/helper/locale_helper.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  LocaleHelper localeHelper;

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    String routeName = "/HomeScreen";
    if(PrefService.getBool("is_first_time")) {
      routeName = "/SettingPage";
      PrefService.setBool("is_first_time", false);
    }
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    localeHelper = new LocaleHelper(context: context);
    return Scaffold(
      body: Container(
       // color: Colors.blueGrey[900],
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blueGrey[900],
              Colors.blueGrey[800],
              Colors.blueGrey[900],
            ],
          ),
        ),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 80,),
            Image.asset("assets/images/icon.jpg",width: 180,),
            Expanded(
              child: SizedBox(width: 20,),
            ),
            Container(
              height: 90,
              width: 90,
              child: Card(
                child: Image.asset("assets/images/entrprice.jpg"),
              ),
            ),
            Container(
              child: Text(
                localeHelper.appPay(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.blueGrey[100]),
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}
