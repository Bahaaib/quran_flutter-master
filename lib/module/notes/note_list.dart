import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:quran_images/data/moor_database.dart';
import 'package:quran_images/helper/locale_helper.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  AppDatabase database;
  LocaleHelper localeHelper;
  String title;
  String description;
  Note editNote;

  @override
  void initState() {
    super.initState();
    title = null;
    description = null;
    editNote = null;
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
          localeHelper.notes(),
          style: TextStyle(fontFamily: "me_quran",fontSize: 20),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildNoteList(context))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.note),
        onPressed: () {
          showDialog(context: context,
          builder: (BuildContext context) {
            return _newNoteDialog();
          });
      },
      ),
    );
  }

  StreamBuilder<List<Note>> _buildNoteList(BuildContext context) {

    return StreamBuilder(
      stream: database.watchAllNotes(),
      builder: (context, AsyncSnapshot<List<Note>> snapshot) {
        final tasks = snapshot.data ?? List();

        return Directionality(
          textDirection: TextDirection.rtl,
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (_, index) {
              final itemTask = tasks[index];
              return _buildListItem(itemTask, database);
            },
          ),
        );
      },
    );
  }

  Widget _buildListItem(Note itemNote, AppDatabase database) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: localeHelper.delete(),
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => database.deleteNote(itemNote),
        )
      ],
      child: ListTile(
        title: Text(itemNote.title),
        subtitle: Text(itemNote.description),
        onTap: (){
          setState(() {
            editNote = itemNote;
            title = itemNote.title;
            description = itemNote.description;
          });
          showDialog(context: context,builder: (BuildContext context) {
            return _newNoteDialog();
          });
        },
      ),
    );
  }

  Widget _newNoteDialog() {
    return AlertDialog(
      title: Text(editNote == null ? localeHelper.addNewNote() : localeHelper.edit() ),
      contentPadding: EdgeInsets.all(8),
      actions: <Widget>[
        RaisedButton(
          color: Colors.green[800],
          child: Text(localeHelper.save(),style: TextStyle(color: Colors.white),),
          onPressed: () {
            if(editNote == null) {
              Note note = new Note(id: null, title: title,description: description);
              database.insertNote(note);
            } else {
              Note note = new Note(id: editNote.id, title: title,description: description);
              database.updateNote(note);
              setState(() {
                editNote = null;
              });
            }

            Navigator.pop(context);
          },
        )
      ],
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                height: 40,
                child:  TextFormField(
                  initialValue: editNote != null ? editNote.title : null,
                  onChanged: (value) {
                    setState(() {
                     title = value.trim();
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey)),
                      hintText: localeHelper.noteTitle(),
                      suffixIcon: const Icon(
                        Icons.note,
                        color: Colors.blueGrey,
                      ),
                      hintStyle: TextStyle(height: 0.5)),
                )
            ),
            SizedBox(height: 10,),
            Container(
                child:  TextFormField(
                  initialValue: editNote != null ? editNote.description : null,
                  textAlign: TextAlign.right,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) {
                    setState(() {
                      description = value.trim();
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey)),
                      hintText: localeHelper.noteDetails(),

                      hintStyle: TextStyle(height: 0.5)),
                )
            ),

          ],
        ),
      ),
    );
  }
}