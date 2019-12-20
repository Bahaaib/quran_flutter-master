import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';
import 'package:quran_images/data/model/ayat.dart';
import 'package:quran_images/data/moor_database.dart';
import 'package:quran_images/data/repository/tafseer_repository.dart';
import 'package:quran_images/data/repository/translate_repository.dart';
import 'package:quran_images/helper/locale_helper.dart';
import 'package:quran_images/module/quran/quran_bookmarks.dart';
import 'package:quran_images/module/quran/sora_list.dart';
import 'package:wakelock/wakelock.dart';

import 'widgets/top_bar.dart';

class QuranShow extends StatefulWidget {
  int initialPageNum;
  Bookmark bookmark;
  int sorahNum;

  QuranShow({Key key, this.initialPageNum, this.bookmark, this.sorahNum})
      : super(key: key);

  @override
  _QuranShowState createState() => _QuranShowState();
}

class _QuranShowState extends State<QuranShow>
    with AutomaticKeepAliveClientMixin<QuranShow>, WidgetsBindingObserver {
  LocaleHelper localeHelper;
  AppDatabase database;
  PageController _pageController;
  Duration duration;
  Duration position;
  AudioPlayer audioPlayer = new AudioPlayer();
  bool isPlay;
  String currentPlay;
  int currentPage;
  int currentIndex;
  bool isShowControl;
  double sliderValue;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  bool downloading = false;
  String progressString = "0%";
  double progress = 0;
  bool autoPlay = false;

  void initAudioPlayer() {
    _positionSubscription =
        audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              position = p;
              //print("posiotn ${p.inMilliseconds}");
            }));
    _durationSubscription = audioPlayer.onDurationChanged.listen((Duration d) {
      if (duration == null) {
        //print("posiotn ${d.inMilliseconds}");
        setState(() => duration = d);
      }
    });
  }

  Future playFile(String url, String fileName) async {
    var path;
    int result;
    try {
      var dir = await getApplicationDocumentsDirectory();
      path = join(dir.path, fileName);
      var file = File(path);
      bool exists = await file.exists();
      if (!exists) {
        try {
          await Directory(dirname(path)).create(recursive: true);
        } catch (e) {
          print(e);
        }
        await downloadFile(path, url, fileName);
      }
      result = await audioPlayer.play(path, isLocal: true);
      if (result == 1) {
        setState(() {
          isPlay = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future downloadFile(String path, String url, String fileName) async {
    Dio dio = Dio();
    try {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print(e);
      }
      setState(() {
        downloading = true;
        progressString = "0%";
        progress = 0;
      });
      await dio.download(url, path, onReceiveProgress: (rec, total) {
        //print("Rec: $rec , Total: $total");
        setState(() {
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
          progress = (rec / total).toDouble();
        });
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "100%";
    });
    //print("Download completed");
  }

  showControl() {
    setState(() {
      isShowControl = !isShowControl;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    initAudioPlayer();
    isPlay = false;
    currentPlay = null;
    isShowControl = false;
    currentPage = widget.initialPageNum;
    currentIndex = widget.initialPageNum - 1;
    _pageController = PageController(initialPage: widget.initialPageNum - 1);
    sliderValue = 0;
  }

  _replay(BuildContext context) {
    Navigator.pop(context);
    setState(() {
      isPlay = false;
      currentPlay = null;
    });
    if (widget.sorahNum != null) {
      playSorah();
    } else {
      play(currentPage.toString());
    }
  }

  @override
  void deactivate() {
    _positionSubscription.cancel();
    _durationSubscription.cancel();
    if (isPlay) {
      audioPlayer.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (isPlay) {
        audioPlayer.pause();
        setState(() {
          isPlay = false;
        });
      }
    }
    //print('state = $state');
  }

  saveLastPlace() async {
    PrefService.setInt("start_page", currentPage);
    if (widget.bookmark != null) {
      await saveBookmark();
    }
  }

  saveBookmark() async {
    var now = new DateTime.now();
    String lastRead = "${now.year}-${now.month}-${now.day}";
    Bookmark bookmark = new Bookmark(
        id: widget.bookmark.id,
        title: widget.bookmark.title,
        pageNum: currentPage,
        lastRead: lastRead);
    await database.updateBookmark(bookmark);
  }

  playSorah() async {
    String url;
    String sorahName = "${widget.sorahNum}";
    String fileName;
    if (sorahName.length == 1) {
      sorahName = "00$sorahName";
    } else if (sorahName.length == 2) {
      sorahName = "0$sorahName";
    }
    switch (PrefService.getString('audio_player_sound')) {
      case "Maher_AlMuaiqly_64kbps":
        {
          fileName = "maher_256/$sorahName.mp3";
          url = "http://download.quranicaudio.com/quran/$fileName";
        }
        break;
      case "Abdul_Basit_Murattal_64kbps":
        {
          fileName = "abdul_basit_murattal/$sorahName.mp3";
          url = "http://download.quranicaudio.com/quran/$fileName";
        }
        break;
      case "Abdurrahmaan_As-Sudais_64kbps":
        {
          fileName = "abdurrahmaan_as-sudays/$sorahName.mp3";
          url = "http://download.quranicaudio.com/quran/$fileName";
        }
        break;
      case "Ghamadi_40kbps":
        {
          fileName = "sa3d_al-ghaamidi/complete/$sorahName.mp3";
          url = "http://download.quranicaudio.com/quran/$fileName";
        }
        break;
      case "Minshawy_Murattal_128kbps":
        {
          fileName = "muhammad_siddeeq_al-minshaawee/$sorahName.mp3";
          url = "http://download.quranicaudio.com/quran/$fileName";
        }
        break;
      case "Hudhaify_64kbps":
        {
          fileName = "huthayfi/$sorahName.mp3";
          url = "http://download.quranicaudio.com/quran/$fileName";
        }
        break;
      case "Salah_Al_Budair_128kbps":
        {
          fileName = "salahbudair/$sorahName.mp3";
          url = "http://download.quranicaudio.com/quran/$fileName";
        }
        break;
    }

    //print("url $url");
    if (isPlay) {
      audioPlayer.pause();
      setState(() {
        isPlay = false;
      });
    } else {
      await playFile(url, fileName);
    }
  }

  play(String page) async {
    if (isPlay) {
      audioPlayer.pause();
      setState(() {
        isPlay = false;
      });
    } else {
      int result;
      if (currentPlay == page) {
        result = await audioPlayer.resume();
        if (result == 1) {
          setState(() {
            isPlay = true;
          });
        }
      } else {
        currentPlay = page;
        String fileName = page;
        if (page.length == 1) {
          fileName = "00$fileName";
        } else if (page.length == 2) {
          fileName = "0$fileName";
        }
        fileName =
            "${PrefService.getString('audio_player_sound')}/PageMp3s/Page$fileName.mp3";
        String url = "http://everyayah.com/data/$fileName";
        await playFile(url, fileName);
      }
    }
    setState(() {
      currentPlay = page;
    });
    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        isPlay = false;
        currentPlay = null;
        position = null;
        duration = null;
        autoPlay = true;
      });
      if (widget.sorahNum == null) {
        //_pageController.nextPage(duration: Duration(milliseconds: 100), curve: Curves.ease);
        _pageController.jumpToPage(currentIndex+1);
      }
    });
  }

  pageChanged(int index) {
      if (isPlay) audioPlayer.stop();
      print("on Page Changed $index");
      setState(() {
        isPlay = false;
        currentPlay = null;
        currentPage = index + 1;
        currentIndex = index;
        position = null;
        duration = null;
        isShowControl = false;
      });
      if(autoPlay) {
        play(currentPage.toString());
        print("current page $currentPage");
        setState(() {
          autoPlay = false;
        });
      }
    saveLastPlace();
  }

  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);
    localeHelper = new LocaleHelper(context: context);
    super.build(context);
    Wakelock.enable();
    return WillPopScope(
      onWillPop: () async {
        audioPlayer.stop();
        setState(() {
          isPlay = false;
          currentPlay = null;
        });
        Wakelock.disable();
        return true;
      },
      child: Scaffold(
        body: OrientationBuilder(
          builder: (context, orientation) {
            return Container(
              padding: EdgeInsets.only(top: 14),
              child: Stack(
                children: <Widget>[
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: _quranPages(context, orientation)),
                  Visibility(visible: isShowControl, child: TopBar()),
                  _downloadingBar(),
                  _bottomBar(context)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _quranPages(BuildContext context, Orientation orientation) {
    return PageView.builder(
        controller: _pageController ??
            PageController(initialPage: widget.initialPageNum - 1),
        itemCount: 604,
        onPageChanged: (page) {
          print("page changed $page");
          pageChanged(page);
        },
        itemBuilder: (_, index) {
          return SingleChildScrollView(
            child: InkWell(
              onTap: () => showControl(),
              child: Image.asset(
                "assets/pages/00${index + 1}.jpg",
                fit: BoxFit.fill,
                height: orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.height - 14
                    : null,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
              ),
            ),
          );
        });
  }

  Widget _downloadingBar() {
    return Visibility(
      visible: downloading,
      child: Align(
        alignment: Alignment.center,
        child: Card(
          color: Colors.blueGrey[800],
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 8, right: 10, bottom: 8, left: 10),
            child: CircularPercentIndicator(
              radius: 60.0,
              lineWidth: 5.0,
              percent: progress,
              center: new Text(
                progressString,
                style: TextStyle(color: Colors.white),
              ),
              progressColor: Colors.green,
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBar(BuildContext context) {
    return Visibility(
      visible: isShowControl,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 100,
          child: Column(
            children: <Widget>[
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                //color: Colors.blueGrey[800],
                elevation: 20,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                        Colors.blueGrey[900],
                        Colors.cyan[700],
                        Colors.cyan[900]
                      ])),
                  child: Column(
                    children: <Widget>[
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 50,
                              child: FlatButton(
                                //color: Colors.blueGrey[900],
                                child: Icon(
                                  isPlay
                                      ? Icons.pause_circle_outline
                                      : Icons.play_circle_outline,
                                  color: Colors.green,
                                  size: 30,
                                ),
                                onPressed: () {
                                  if (widget.sorahNum != null) {
                                    playSorah();
                                  } else {
                                    play("$currentPage");
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 50,
                                child: SliderTheme(
                                  data: SliderThemeData(
                                      thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 8)),
                                  child: Slider(
                                    activeColor: Colors.green,
                                    min: 0,
                                    max: duration != null
                                        ? duration.inMilliseconds.toDouble()
                                        : 0.0,
                                    value: position != null
                                        ? (position.inMilliseconds.toDouble())
                                        : 0.0,
                                    onChanged: (value) {
                                      audioPlayer.seek(new Duration(
                                          milliseconds: value.toInt()));
                                      setState(() {
                                        sliderValue = value.toDouble();
                                      });
                                    },
                                  ),
                                ),
                              ),
                              flex: 1,
                            ),
                            IconButton(
                              padding: EdgeInsets.only(right: 25),
                              icon: Icon(
                                Icons.person,
                                color: Colors.blueGrey[200],
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return _dialogOptions(context);
                                    });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => SorahList())));
                      },
                      child: _btnCard(localeHelper.quranSorah()),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return localeHelper.lang() == 'ar' ? _showTafseer(currentPage)
                              : _showTranslate(currentPage);
                            });
                      },
                      child: _btnCard(localeHelper.translate()),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => QuranBookmarks())));
                      },
                      child: _btnCard(localeHelper.bookmarks()),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogOptions(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(0),
      title: Text(localeHelper.selectPlayer()),
      children: <Widget>[
        RadioPreference(
          localeHelper.lang() == 'ar'
              ? 'عبد الباسط عبد الصمد'
              : "Abdul Basit Abdul Samad",
          'Abdul_Basit_Murattal_64kbps',
          'audio_player_sound',
          onSelect: () {
            _replay(context);
          },
        ),
        RadioPreference(
          localeHelper.lang() == 'ar'
              ? 'محمد صديق المنشاوي'
              : "Muhamad sidiyq almunshawi",
          'Minshawy_Murattal_128kbps',
          'audio_player_sound',
          onSelect: () {
            _replay(context);
          },
        ),
        RadioPreference(
          localeHelper.lang() == 'ar' ? 'ماهر المعيقلي' : "Maher Almaikulai",
          'Maher_AlMuaiqly_64kbps',
          'audio_player_sound',
          onSelect: () {
            _replay(context);
          },
        ),
        RadioPreference(
          localeHelper.lang() == 'ar'
              ? 'عبدالرحمن السديس'
              : "Abdullrahman Alsudais",
          'Abdurrahmaan_As-Sudais_64kbps',
          'audio_player_sound',
          onSelect: () {
            _replay(context);
          },
        ),
        RadioPreference(
          localeHelper.lang() == 'ar' ? 'سعد الغامدي' : "Saad Al-Ghamdi",
          'Ghamadi_40kbps',
          'audio_player_sound',
          onSelect: () {
            _replay(context);
          },
        ),
        RadioPreference(
          localeHelper.lang() == 'ar'
              ? 'عبد الرحمن الحذيفي'
              : "Abdur Rahman Al Huthaify",
          'Hudhaify_64kbps',
          'audio_player_sound',
          onSelect: () {
            _replay(context);
          },
        ),
        RadioPreference(
          localeHelper.lang() == 'ar' ? 'صلاح بدير' : "Salah Bdyr",
          'Salah_Al_Budair_128kbps',
          'audio_player_sound',
          onSelect: () {
            _replay(context);
          },
        ),
        RadioPreference(
          localeHelper.lang() == 'ar' ? 'سعود الشريم' : "Saud Al-Shuraim",
          'Saood_ash-Shuraym_64kbps',
          'audio_player_sound',
          onSelect: () {
            _replay(context);
          },
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Widget _btnCard(String title) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        decoration: _boxDecoration(),
        padding: EdgeInsets.only(top: 3, bottom: 3),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.blueGrey[200],
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.cyan[900], Colors.blueGrey[800]]));
  }

  Widget _showTafseer(int pageNum) {
    TafseerRepository tafseerRepository = new TafseerRepository();
    return FutureBuilder<List<Ayat>>(
      future: tafseerRepository.getPageTafseer(pageNum),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Ayat> ayat = snapshot.data;
          return AlertDialog(
            contentPadding: EdgeInsets.all(5),
            content: Container(
              width: 300.0,
              height: 500.0,
              child: ListView.builder(
                  itemCount: ayat.length,
                  itemBuilder: (_, position) {
                    Ayat aya = ayat[position];
                    List<String> tafseer = aya.tafsser.split("))");
                    return Column(
                      children: <Widget>[
                    Container(
                      color: Colors.amber[50],
                      child: Text(
                      "${tafseer.first}))",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "me_quran",
                        ),
                      ),
                    ),
                        Text("${tafseer.last.trim()}",
                          textAlign: TextAlign.center,
                        ),
                        Divider()
                      ],
                    );
                  }),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
  Widget _showTranslate(int pageNum) {
    TranslateRepository translateRepository = new TranslateRepository();
    return FutureBuilder<List<Ayat>>(
      future: translateRepository.getPageTranslate(pageNum),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Ayat> ayat = snapshot.data;
          return AlertDialog(
            contentPadding: EdgeInsets.all(5),
            content: Container(
              width: 300.0,
              height: 500.0,
              child: ListView.builder(
                  itemCount: ayat.length,
                  itemBuilder: (_, position) {
                    Ayat aya = ayat[position];
                    return Text("${aya.translate} (${aya.ayaNum})",
                      textAlign: TextAlign.center,
                    );
                  }),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
