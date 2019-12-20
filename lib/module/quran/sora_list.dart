import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quran_images/data/model/sorah.dart';
import 'package:quran_images/data/repository/sorah_repository.dart';
import 'package:quran_images/helper/locale_helper.dart';
import 'package:quran_images/module/quran/show.dart';

class SorahList extends StatefulWidget {
  @override
  _SorahListState createState() => _SorahListState();
}

class _SorahListState extends State<SorahList>
    with AutomaticKeepAliveClientMixin<SorahList> {
  SorahRepository sorahRepository = new SorahRepository();
  List<Sorah> sorahList;

  @override
  void initState() {
    super.initState();
    getList();
  }

  getList() async {
   sorahRepository.all().then((values) {
     setState(() {
       sorahList = values;
     });
   });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    LocaleHelper localeHelper = new LocaleHelper(context: context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localeHelper.quranSorah(),
          style: TextStyle(fontFamily: "me_quran",fontSize: 20),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: sorahList != null ? ListView.builder(
                physics: const AlwaysScrollableScrollPhysics (),
                itemCount: sorahList.length,
                itemBuilder: (_,index) {
                  Sorah sorah = sorahList[index];
                  return Container(
                    color: ( index % 2 == 0 ? Colors.lightGreenAccent[50] : Colors.white),
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, new MaterialPageRoute(
                            builder: ((context) => QuranShow(initialPageNum: sorah.pageNum,))
                        ));
                      },
                      leading: Container(
                        width: 55,
                        height: 55,
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/images/ayah_bg.png"),
                          backgroundColor: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.only(top:3.0),
                            child: Text(
                              "${sorah.id}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "maddina",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      title: Text(localeHelper.lang() == 'en' ? sorah.nameEn : sorah.name,
                        style: TextStyle(
                            fontFamily: "me_quran",
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Colors.blueGrey[900]),
                      ),
                      subtitle: RichText(
                          text: TextSpan(children: [
                            WidgetSpan(
                              child: Text(
                                "${sorah.ayaCount}",
                                style: TextStyle(
                                    fontFamily: "maddina",
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            WidgetSpan(
                              child: Text(
                                "${localeHelper.ayaCount()}: ",
                                style: TextStyle(fontFamily: "uthman"),
                              ),
                            ),
                          ])),
                    ),
                  );
                }
            ) : Text(""),
          )
        ],
      ),
    );

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
