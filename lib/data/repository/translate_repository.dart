import 'package:quran_images/data/model/ayat.dart';
import 'package:quran_images/data/model/translate.dart';
import 'package:quran_images/data/tafseer_data_client.dart';
import 'package:sqflite/sqflite.dart';

class TranslateRepository {
  TafseerDataBaseClient _client;
  TranslateRepository(){
    _client = TafseerDataBaseClient.instance;
  }

  Future<List<Ayat>> getPageTranslate(int pageNum) async {
    Database database = await _client.database;
    List<Map> results = await database
        .rawQuery(" SELECT * FROM ${Ayat.tableName} "
        "LEFT JOIN ${Translate.tableName} "
        "ON (${Translate.tableName}.aya = ${Ayat.tableName}.Verse) AND (${Translate.tableName}.sura = ${Ayat.tableName}.SuraNum) "
        "WHERE PageNum = $pageNum");
    List<Ayat> ayaList =  List();
    results.forEach((result) {
      ayaList.add(Ayat.fromMap(result));
    });
    return ayaList;
  }
}