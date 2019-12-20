
/*
* CREATE TABLE "Quran" (
	`ID`	INTEGER,
	`SoraNum`	INTEGER,
	`AyaNum`	INTEGER,
	`PageNum`	VARCHAR,
	`SoraName_ar`	TEXT DEFAULT (null),
	`AyaDiac`	TEXT,
	`AyaNoDiac`	TEXT,
	`PartNum`	INTEGER,
	`AyaUserNote`	TEXT DEFAULT (null),
	`SoraName_En`	TEXT,
	`SearchText`	TEXT,
	PRIMARY KEY(`ID`)
)
* */
class Aya {
  Aya();
  static String tableName = "Quran";
  int id;
  int sorahId;
  int ayaNum;
  String pageNum;
  String sorahName;
  String text;
  int partNum;

  static final columns = ["ID", "SoraNum",'AyaNum','PageNum','SoraName_ar','AyaDiac','PartNum'];

  Map toMap() {
    Map map = {
      "SoraNum": sorahId,
      "AyaNum": ayaNum,
      "PageNum": pageNum,
      "SoraName_ar": sorahName,
      "AyaDiac": text,
      "PartNum": partNum,
    };

    if (id != null) {
      map["ID"] = id;
    }

    return map;
  }

  static fromMap(Map map) {
    Aya aya = new Aya();
    aya.id = map["ID"];
    aya.sorahName = map["SoraName_ar"];
    aya.ayaNum = map["AyaNum"];
    aya.sorahId = map["SoraNum"];
    aya.text = map["AyaDiac"];
    aya.partNum = map["PartNum"];
    aya.pageNum = map["PageNum"];
    return aya;
  }
}