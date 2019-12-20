import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:quran_images/helper/locale_helper.dart';

class SettingPage extends StatefulWidget{
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    LocaleHelper localeHelper = LocaleHelper(context: context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.settings
        ),
        title: Text(
          "الاعدادات"
        ),
      ),
      body: Container(
        //color: Colors.blueGrey.shade600,
        padding: EdgeInsets.only(right: 8,left: 8),
        child: PreferencePage([
          PreferenceTitle(' لغة عرض التطبيق',style: TextStyle(
            color: Colors.blueGrey
          ),),
          Container(
            height: 35,
            child: RadioPreference(
              'اللغة العربية',
              'ar',
              'lang',
              isDefault: true,
            ),
          ),
          Container(
            height: 35,
            child: RadioPreference(
              'اللغة الانجليزية',
              'en',
              'lang',
            ),
          ),
          SizedBox(height: 20,),
          Divider(),
          PreferenceTitle(localeHelper.selectPlayer(),style: TextStyle(
              color: Colors.blueGrey
          ),),
          Container(
            height: 40,
            child: RadioPreference(
              localeHelper.lang() == 'ar' ? 'عبد الباسط عبد الصمد' : "Abdul Basit Abdul Samad",
              'Abdul_Basit_Murattal_64kbps',
              'audio_player_sound',

            ),
          ),
          Container(
            height: 40,
            child: RadioPreference(
              localeHelper.lang() == 'ar' ? 'محمد صديق المنشاوي' : "Muhamad sidiyq almunshawi",
              'Minshawy_Murattal_128kbps',
              'audio_player_sound',

            ),
          ),
          Container(
            height: 40,
            child: RadioPreference(
              localeHelper.lang() == 'ar' ?  'ماهر المعيقلي' : "Maher Almaikulai",
              'Maher_AlMuaiqly_64kbps',
              'audio_player_sound',
            ),
          ),
          Container(
            height: 40,
            child: RadioPreference(
              localeHelper.lang() == 'ar' ? 'عبدالرحمن السديس' : "Abdullrahman Alsudais",
              'Abdurrahmaan_As-Sudais_64kbps',
              'audio_player_sound',
            ),
          ),
          Container(
            height: 40,
            child: RadioPreference(
              localeHelper.lang() == 'ar' ? 'سعد الغامدي' : "Saad Al-Ghamdi",
              'Ghamadi_40kbps',
              'audio_player_sound',
            ),
          ),
          Container(
            height: 40,
            child: RadioPreference(
              localeHelper.lang() == 'ar' ? 'عبد الرحمن الحذيفي': "Abdur Rahman Al Huthaify",
              'Hudhaify_64kbps',
              'audio_player_sound',
            ),
          ),
          Container(
            height: 40,
            child: RadioPreference(
              localeHelper.lang() == 'ar' ? 'صلاح بدير' : "Salah Bdyr",
              'Salah_Al_Budair_128kbps',
              'audio_player_sound',
            ),
          ),
          Container(
            height: 40,
            child: RadioPreference(
              localeHelper.lang() == 'ar' ? 'سعود الشريم' : "Saud Al-Shuraim",
              'Saood_ash-Shuraym_64kbps',
              'audio_player_sound',
            ),
          ),
          SizedBox(height: 30,),
          Divider(),
          RaisedButton(
            color: Colors.blueGrey[800],
            textColor: Colors.white,
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.check),
                SizedBox(width: 10,),
                Text(localeHelper.save())
              ],
            ),
            onPressed: (){
              Navigator.of(context).pushNamed("/HomeScreen");
            },
          ),
          SizedBox(height: 10,),
        ]),
      ),
    );
  }
}