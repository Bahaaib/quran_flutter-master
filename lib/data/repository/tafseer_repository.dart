import 'package:quran_images/data/model/ayat.dart';
import 'package:quran_images/data/model/tafseer.dart';
import 'package:quran_images/data/tafseer_data_client.dart';
import 'package:sqflite/sqflite.dart';

class TafseerRepository{
  TafseerDataBaseClient _client;
  TafseerRepository(){
    _client = TafseerDataBaseClient.instance;
  }

  Future<List<Ayat>> getPageTafseer(int pageNum) async {
    Database database = await _client.database;
    List<Map> results = await database
        .rawQuery(" SELECT * FROM ${Ayat.tableName} "
        "LEFT JOIN ${Tafseer.tableName} "
        "ON ${Tafseer.tableName}.AyaID =  ${Ayat.tableName}.AID "
        "WHERE PageNum = $pageNum");
    List<Ayat> ayaList =  List();
    results.forEach((result) {
      ayaList.add(Ayat.fromMap(result));
    });
    return ayaList;
  }
}