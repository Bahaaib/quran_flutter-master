/*
* CREATE TABLE "Ayat" ("AID" integer PRIMARY KEY  NOT NULL ,"SuraNum" integer,"Verse" integer,"PageNum" integer,"PartNum" integer)
* */
class Ayat {
  static String tableName = "Ayat";

  int ayaId;
  int pageNum;
  int ayaNum;
  String tafsser;
  String translate;

  static final columns = ["AID",'PageNum','Verse'];

  static fromMap(Map map) {
    Ayat aya = new Ayat();
    aya.ayaId = map["AID"];
    aya.pageNum = map["PageNum"];
    aya.tafsser = map["AyaInfo"];
    aya.translate = map["text"];
    aya.ayaNum = map["Verse"];
    return aya;
  }
}
