import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:preferences/preference_service.dart';
import 'package:quran_images/helper/locale_helper.dart';
import 'package:quran_images/main.dart';
import 'package:quran_images/module/books/book_list.dart';
import 'package:quran_images/module/notes/note_list.dart';
import 'package:quran_images/module/quran/quran_search.dart';

import '../../about_page.dart';

class TopBar extends StatefulWidget {

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    LocaleHelper localeHelper = new LocaleHelper(context: context);
    // TODO: implement build
    return Container(
      height: 105,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blueGrey[900],Colors.cyan[900]]
        )
      ),
      padding: EdgeInsets.only(top:5),
      //color: Colors.blueGrey[800],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 50,
            padding: EdgeInsets.only(top: 7),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(
                          builder: ((context) => QuranSearch())
                      ));
                    },
                    child: Card(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
    ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                  child: Text(localeHelper.searchHint(),
                                  style: TextStyle(
                                    fontFamily: "cairo",
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: Colors.blueGrey[100]
                                  ),)
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: Icon(Icons.search,color: Colors.blueGrey[100],),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  color: Colors.blueGrey[800],
                  icon: Icon(Icons.notifications_active,color: Colors.blueGrey[200],),
                  onPressed: () {
                    DatePicker.showTimePicker(
                        context,
                        locale: LocaleType.ar,
                      showTitleActions: true,
                      onConfirm: (time){
                          print("Time ${time.hour}:${time.minute}");
                      }
                    );
                  },
                ),
                IconButton(
                  color: Colors.blueGrey[800],
                  icon: Icon(Icons.language,color: Colors.blueGrey[200],),
                  onPressed: () {
                    PrefService.setString("lang", localeHelper.lang() == "en"  ? "ar" : "en");
                    RestartWidget.restartApp(context);
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 48,
            //padding: EdgeInsets.only(top: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _btnIcon(localeHelper.islamic(), Icons.library_books, BookList()),
                _btnIcon(localeHelper.notes(), Icons.speaker_notes, NoteList()),
                _btnIcon(localeHelper.aboutUs(), Icons.info, AboutPage()),
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget _btnIcon(String title,IconData iconData,Widget page) {
    return RaisedButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(
            builder: ((context) => page)
        ));
      },
      color: Colors.transparent,
      elevation: 0,
      textColor: Colors.blueGrey[200],
      child: Column(
        children: <Widget>[
          Icon(iconData),
          Text(title,
          style: TextStyle(
            fontSize: 12
          ),)
        ],
      ),
    );
  }
}