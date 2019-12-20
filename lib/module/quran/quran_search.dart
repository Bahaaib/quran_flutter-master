import 'package:flutter/material.dart';
import 'package:quran_images/data/model/aya.dart';
import 'package:quran_images/data/repository/aya_repository.dart';
import 'package:quran_images/helper/locale_helper.dart';
import 'package:quran_images/module/quran/show.dart';

class QuranSearch extends StatefulWidget {
  @override
  _QuranSearchState createState() => _QuranSearchState();
}

class _QuranSearchState extends State<QuranSearch> {
  AyaRepository ayaRepository = new AyaRepository();
  LocaleHelper localeHelper;
  List<Aya> ayahList;

  @override
  void initState() {
    super.initState();
  }


  search(String text) async {
   ayaRepository.search(text).then((values) {
     setState(() {
       ayahList = values;
     });

   });
  }

  @override
  Widget build(BuildContext context) {
    localeHelper = new LocaleHelper(context: context);
    // TODO: implement build
   return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localeHelper.searchHint(),
          style: TextStyle(fontFamily: "me_quran",fontSize: 20),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 50,
            color: Colors.white,
            padding: EdgeInsets.only(top:10,right: 30,left: 30),
            child: TextField(
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if(value != null) {
                  search(value);
                }
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.grey)),
                  hintText: localeHelper.searchWord(),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Colors.green,
                  ),
                  hintStyle: TextStyle(height: 1)),
            ),
          ),
          Expanded(
            child: Container(
                child: ayahList != null ? ListView.builder(
                    itemCount: ayahList.length,
                    itemBuilder: (_,index){
                      Aya aya = ayahList[index];
                      return Container(
                        color: ( index % 2 == 0 ? Colors.grey[100] : Colors.white),
                        child: ListTile(
                          onTap: (){
                            Navigator.push(context, new MaterialPageRoute(
                                builder: ((context) => QuranShow(initialPageNum: int.parse(aya.pageNum)))
                            ));
                          },
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                    style: TextStyle(
                                        fontFamily: "me_quran",
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        color: Colors.blueGrey[800]),
                                    text: aya.text,
                                    children: [
                                      WidgetSpan(
                                          child: _ayaNum("${aya.ayaNum}")
                                      )
                                    ]
                                )
                            ),
                          ),
                          subtitle: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  color: Colors.green[200],
                                  child: Text("${localeHelper.sorah()}: ${aya.sorahName}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black
                                    ),),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    color: Colors.yellow[200],
                                    child: Text(" ${localeHelper.part()}: ${aya.partNum}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black
                                      ),
                                    )
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    color: Colors.purple[200],
                                    //height: 60,
                                    child: Text(" ${localeHelper.page()}: ${aya.pageNum}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black
                                      ),
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }) : Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(localeHelper.searchDescription(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.grey,
                        fontFamily: "uthman"
                    ),),
                )

            ),
          )

        ],
      )
    );
  }
}
Widget _ayaNum(String num){
  return Padding(
    padding: const EdgeInsets.only(left:5,right: 5),
    child: Transform.translate(
      offset: Offset(0,0),
      child: Container(
        width: 20,
        height: 25,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/aya.png"),
            fit: BoxFit.contain,
          ),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              Padding(
                padding: const EdgeInsets.only(top:3),
                child: Text(num,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,fontFamily: "maddina"),),
              )
            ]
        ),
      ),
    ),
  );
}
