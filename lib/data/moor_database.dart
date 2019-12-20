import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

// Moor works by source gen. This file will all the generated code.
part 'moor_database.g.dart';

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength()();
  TextColumn get description => text().nullable().withLength()();
}

class Bookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().nullable()();
  IntColumn get pageNum => integer()();
  TextColumn get lastRead => text().nullable()();
}

@UseMoor(tables: [Notes,Bookmarks])
// _$AppDatabase is the name of the generated class
class AppDatabase extends _$AppDatabase {
  AppDatabase()
  // Specify the location of the database file
      : super((FlutterQueryExecutor.inDatabaseFolder(
    path: 'notes_db.sqlite',
    // Good for debugging - prints SQL in the console
    logStatements: true,
  )));

  // Bump this when changing tables and columns.
  @override
  int get schemaVersion => 1;

  Stream<List<Note>> watchAllNotes() => select(notes).watch();

  Future insertNote(Note note) => into(notes).insert(note);

  Future updateNote(Note note) => update(notes).replace(note);

  Future deleteNote(Note note) => delete(notes).delete(note);

  /// Bookmarks fun
  Stream<List<Bookmark>> watchAllBookmarks() => select(bookmarks).watch();

  Future insertBookmark(Bookmark bookmark) => into(bookmarks).insert(bookmark);

  Future updateBookmark(Bookmark bookmark) => update(bookmarks).replace(bookmark);

  Future deleteBookmark(Bookmark bookmark) => delete(bookmarks).delete(bookmark);

}