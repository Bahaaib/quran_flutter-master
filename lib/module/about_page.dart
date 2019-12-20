import 'package:flutter/material.dart';
import 'package:quran_images/helper/locale_helper.dart';

class AboutPage extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    LocaleHelper localeHelper = new LocaleHelper(context: context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localeHelper.aboutUs(),
          style: TextStyle(fontFamily: "me_quran",fontSize: 20),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 50),
          Center(child: Image.asset("assets/images/entrprice.jpg",width: 180,)),
          SizedBox(height: 20,),
          Text(localeHelper.stopTitle(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.blueGrey
          ),),
          Center(
            child: Text(localeHelper.appPay(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.blueGrey
              ),),
          ),
          Center(
            child: Text(localeHelper.email(),
            style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey
            ),),
          )
        ],
      ),
    );
  }
  
}