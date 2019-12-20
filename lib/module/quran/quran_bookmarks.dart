import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:quran_images/data/moor_database.dart';
import 'package:quran_images/helper/locale_helper.dart';
import 'package:quran_images/module/quran/show.dart';


class QuranBookmarks extends StatefulWidget {
  @override
  _QuranBookmarksState createState() => _QuranBookmarksState();
}

class _QuranBookmarksState extends State<QuranBookmarks> {
  AppDatabase database;
  LocaleHelper localeHelper;
  String _title;
  Bookmark _editBookmark;
  @override
  void initState() {
    super.initState();
    _title = null;
    _editBookmark = null;
  }

  saveBookmark(){
    if(_editBookmark == null) {
      newBookmark();
    } else {
      updateBookmark();
    }
  }


  newBookmark() async {
    var now = new DateTime.now();
    String lastRead = "${now.year}-${now.month}-${now.day}";
    Bookmark bookmark = new Bookmark(id: null, title: _title,pageNum: 1,lastRead: lastRead);
    await database.insertBookmark(bookmark);
  }

  updateBookmark() async {
    Bookmark bookmark = new Bookmark(id: _editBookmark.id, title: _title,
        pageNum: _editBookmark.pageNum,lastRead: _editBookmark.lastRead);
    await database.updateBookmark(bookmark);
    setState(() {
      _editBookmark = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);
    localeHelper = new LocaleHelper(context: context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localeHelper.bookmarks(),
          style: TextStyle(fontFamily: "me_quran",fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
            builder: (BuildContext context) {
                return _newBookmarkDialog();
            }
          );
        },
        child: Icon(Icons.bookmark),
        backgroundColor: Colors.green,
      ),
      body: _buildBookmarkList(context),
    );
  }

  StreamBuilder<List<Bookmark>> _buildBookmarkList(BuildContext context) {

    return StreamBuilder(
      stream: database.watchAllBookmarks(),
      builder: (context, AsyncSnapshot<List<Bookmark>> snapshot) {
        final bookmarks = snapshot.data ?? List();

        return ListView.builder(
          itemCount: bookmarks.length,
          itemBuilder: (_, index) {
            final bookmark = bookmarks[index];
            return _buildListItem(bookmark, database);
          },
        );
      },
    );
  }

  Widget _buildListItem(Bookmark bookmark, AppDatabase database) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: localeHelper.delete(),
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => database.deleteBookmark(bookmark),
        )
      ],
      child: ListTile(
        title: Text(bookmark.title),
        subtitle: Text("${localeHelper.page()}: ${bookmark.pageNum}"),
        onTap: (){
          Navigator.push(context, new MaterialPageRoute(
              builder: ((context) => QuranShow(initialPageNum: bookmark.pageNum, bookmark: bookmark,) ))
          );
        },
      ),
    );
  }

  Widget _newBookmarkDialog(){
    return AlertDialog(
      title: Text(localeHelper.addNewBookmark()),
      actions: <Widget>[
        RaisedButton(
          color: Colors.green[800],
          child: Text(localeHelper.save(),style: TextStyle(color: Colors.white),),
          onPressed: () {
            saveBookmark();
            Navigator.pop(context);
          },
        )
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              height: 40,
              child:  TextField(
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  setState(() {
                    _title = value.trim();
                  });
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey)),
                    hintText: localeHelper.bookmarkTitle(),
                    suffixIcon: const Icon(
                      Icons.bookmark,
                      color: Colors.blueGrey,
                    ),
                    hintStyle: TextStyle(height: 0.5)),
              )
          ),

        ],
      ),
    );
  }
}
