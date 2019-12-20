/*
* CREATE TABLE "moyassar_ayat_Test" (
	`AyaID`	INTEGER NOT NULL,
	`TooltipFileName`	TEXT,
	`AyaInfo`	TEXT,
	PRIMARY KEY(AyaID)
)
* */
class Tafseer {
  static String tableName = "moyassar_ayat_Test";
  int ayaId;
  String ayaInfo;
  static final columns = ["AyaID", "AyaInfo"];

  static fromMap(Map map) {
    Tafseer tafseer = new Tafseer();
    tafseer.ayaId = map["AyaID"];
    tafseer.ayaInfo = map["AyaInfo"];
    return tafseer;
  }
}