
import 'package:quran_images/data/data_client.dart';
import 'package:quran_images/data/model/sorah.dart';
import 'package:sqflite/sqflite.dart';

class SorahRepository {
  DataBaseClient _client;
  SorahRepository(){
    _client = DataBaseClient.instance;
  }

  Future<List<Sorah>> all() async {
    Database database = await _client.database;
    List<Map> results = await database.query(Sorah.tableName,columns: Sorah.columns);
    List<Sorah> sorahList =  List();
    results.forEach((result) {
      sorahList.add(Sorah.fromMap(result));
    });
    return sorahList;
  }
}