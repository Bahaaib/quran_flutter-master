/*
* CREATE TABLE "en_ahmedali" (
	"index"	INTEGER,
	"sura"	INTEGER,
	"aya"	INTEGER,
	"text"	TEXT
)*/
class Translate{
  static String tableName = "en_ahmedali";
  int index;
  int sorah;
  int aya;
  String text;

  static final columns = ["index", "sura",'aya','text'];

  static fromMap(Map map) {
    Translate translate = new Translate();
    translate.aya = map["aya"];
    translate.sorah = map["sura"];
    translate.text = map["text"];
    return translate;
  }

}