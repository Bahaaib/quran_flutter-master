
import 'package:quran_images/data/model/aya.dart';
import 'package:sqflite/sqflite.dart';

import '../data_client.dart';

class AyaRepository {
  DataBaseClient _client;
  AyaRepository(){
    _client = DataBaseClient.instance;
  }

  Future<List<Aya>> search(String text) async {
    Database database = await _client.database;
    List<Map> results = await database.query(Aya.tableName,columns: Aya.columns ,
        where: "SearchText LIKE '%$text%'");
    List<Aya> ayaList =  List();
    results.forEach((result) {
      ayaList.add(Aya.fromMap(result));
    });
    return ayaList;
  }

  Future<List<Aya>> getPage(int pageNum) async {
    Database database = await _client.database;
    List<Map> results = await database.query(Aya.tableName,columns: Aya.columns,
    where: "PageNum = $pageNum");
    List<Aya> ayaList =  List();
    results.forEach((result) {
      ayaList.add(Aya.fromMap(result));
    });
    return ayaList;
  }
}