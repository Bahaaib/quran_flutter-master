import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_images/helper/locale_helper.dart';
import 'package:quran_images/qibla.dart';
import 'book_show.dart';

class BookList extends StatelessWidget {
  static const platform = const MethodChannel('codeline.net.quran_images/qibla');
  LocaleHelper localeHelper;

  @override
  Widget build(BuildContext context) {
    localeHelper = new LocaleHelper(context: context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localeHelper.islamic(),
          style: TextStyle(fontFamily: "me_quran",fontSize: 20),
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            onTap: (){
             return Navigator.push(context, new MaterialPageRoute(
                  builder: ((context) => BookShow(bookName: "tafseer",total: 114,))
              ));
            },
            title: Text(localeHelper.tafseer()),
          ),
          ListTile(
            onTap: (){
              return Navigator.push(context, new MaterialPageRoute(
                  builder: ((context) => BookShow(bookName: "ryad",total: 372,))
              ));
            },
            title: Text(localeHelper.ryad()),
          ),
          ListTile(
            onTap: (){
              return Navigator.push(context, new MaterialPageRoute(
                  builder: ((context) => BookShow(bookName: "azkar",total: 133,))
              ));
            },
            title: Text(localeHelper.azkar()),
          ),
          ListTile(
            title: Text(localeHelper.qibla()),
            onTap: (){
              _showQiblaActivity(context);
            },
          ),
          ListTile(title: Text(localeHelper.salat()),
            onTap: (){
              _showPrayerTimeActivity();
            },
          ),
        ],
      ),
    );
  }

  _showQiblaActivity(BuildContext context) async {
    try {
      //await platform.invokeMethod('showQiblaActivity');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QiblaPage()),
      );
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  _showPrayerTimeActivity() async {
    try {
      await platform.invokeMethod('showPrayerTimeActivity');
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

}