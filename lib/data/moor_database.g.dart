// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Note extends DataClass implements Insertable<Note> {
  final int id;
  final String title;
  final String description;
  Note({@required this.id, @required this.title, this.description});
  factory Note.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Note(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      description: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
    );
  }
  factory Note.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Note(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
    };
  }

  @override
  NotesCompanion createCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  Note copyWith({int id, String title, String description}) => Note(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
      );
  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(title.hashCode, description.hashCode)));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> description;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    @required String title,
    this.description = const Value.absent(),
  }) : title = Value(title);
  NotesCompanion copyWith(
      {Value<int> id, Value<String> title, Value<String> description}) {
    return NotesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  final GeneratedDatabase _db;
  final String _alias;
  $NotesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  GeneratedTextColumn _description;
  @override
  GeneratedTextColumn get description =>
      _description ??= _constructDescription();
  GeneratedTextColumn _constructDescription() {
    return GeneratedTextColumn(
      'description',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, title, description];
  @override
  $NotesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'notes';
  @override
  final String actualTableName = 'notes';
  @override
  VerificationContext validateIntegrity(NotesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.title.present) {
      context.handle(
          _titleMeta, title.isAcceptableValue(d.title.value, _titleMeta));
    } else if (title.isRequired && isInserting) {
      context.missing(_titleMeta);
    }
    if (d.description.present) {
      context.handle(_descriptionMeta,
          description.isAcceptableValue(d.description.value, _descriptionMeta));
    } else if (description.isRequired && isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Note.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(NotesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.title.present) {
      map['title'] = Variable<String, StringType>(d.title.value);
    }
    if (d.description.present) {
      map['description'] = Variable<String, StringType>(d.description.value);
    }
    return map;
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(_db, alias);
  }
}

class Bookmark extends DataClass implements Insertable<Bookmark> {
  final int id;
  final String title;
  final int pageNum;
  final String lastRead;
  Bookmark(
      {@required this.id, this.title, @required this.pageNum, this.lastRead});
  factory Bookmark.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Bookmark(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      pageNum:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}page_num']),
      lastRead: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_read']),
    );
  }
  factory Bookmark.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Bookmark(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      pageNum: serializer.fromJson<int>(json['pageNum']),
      lastRead: serializer.fromJson<String>(json['lastRead']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'pageNum': serializer.toJson<int>(pageNum),
      'lastRead': serializer.toJson<String>(lastRead),
    };
  }

  @override
  BookmarksCompanion createCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      pageNum: pageNum == null && nullToAbsent
          ? const Value.absent()
          : Value(pageNum),
      lastRead: lastRead == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRead),
    );
  }

  Bookmark copyWith({int id, String title, int pageNum, String lastRead}) =>
      Bookmark(
        id: id ?? this.id,
        title: title ?? this.title,
        pageNum: pageNum ?? this.pageNum,
        lastRead: lastRead ?? this.lastRead,
      );
  @override
  String toString() {
    return (StringBuffer('Bookmark(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('pageNum: $pageNum, ')
          ..write('lastRead: $lastRead')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(title.hashCode, $mrjc(pageNum.hashCode, lastRead.hashCode))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Bookmark &&
          other.id == this.id &&
          other.title == this.title &&
          other.pageNum == this.pageNum &&
          other.lastRead == this.lastRead);
}

class BookmarksCompanion extends UpdateCompanion<Bookmark> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> pageNum;
  final Value<String> lastRead;
  const BookmarksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.pageNum = const Value.absent(),
    this.lastRead = const Value.absent(),
  });
  BookmarksCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    @required int pageNum,
    this.lastRead = const Value.absent(),
  }) : pageNum = Value(pageNum);
  BookmarksCompanion copyWith(
      {Value<int> id,
      Value<String> title,
      Value<int> pageNum,
      Value<String> lastRead}) {
    return BookmarksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      pageNum: pageNum ?? this.pageNum,
      lastRead: lastRead ?? this.lastRead,
    );
  }
}

class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, Bookmark> {
  final GeneratedDatabase _db;
  final String _alias;
  $BookmarksTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      true,
    );
  }

  final VerificationMeta _pageNumMeta = const VerificationMeta('pageNum');
  GeneratedIntColumn _pageNum;
  @override
  GeneratedIntColumn get pageNum => _pageNum ??= _constructPageNum();
  GeneratedIntColumn _constructPageNum() {
    return GeneratedIntColumn(
      'page_num',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lastReadMeta = const VerificationMeta('lastRead');
  GeneratedTextColumn _lastRead;
  @override
  GeneratedTextColumn get lastRead => _lastRead ??= _constructLastRead();
  GeneratedTextColumn _constructLastRead() {
    return GeneratedTextColumn(
      'last_read',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, title, pageNum, lastRead];
  @override
  $BookmarksTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'bookmarks';
  @override
  final String actualTableName = 'bookmarks';
  @override
  VerificationContext validateIntegrity(BookmarksCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.title.present) {
      context.handle(
          _titleMeta, title.isAcceptableValue(d.title.value, _titleMeta));
    } else if (title.isRequired && isInserting) {
      context.missing(_titleMeta);
    }
    if (d.pageNum.present) {
      context.handle(_pageNumMeta,
          pageNum.isAcceptableValue(d.pageNum.value, _pageNumMeta));
    } else if (pageNum.isRequired && isInserting) {
      context.missing(_pageNumMeta);
    }
    if (d.lastRead.present) {
      context.handle(_lastReadMeta,
          lastRead.isAcceptableValue(d.lastRead.value, _lastReadMeta));
    } else if (lastRead.isRequired && isInserting) {
      context.missing(_lastReadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bookmark map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Bookmark.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(BookmarksCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.title.present) {
      map['title'] = Variable<String, StringType>(d.title.value);
    }
    if (d.pageNum.present) {
      map['page_num'] = Variable<int, IntType>(d.pageNum.value);
    }
    if (d.lastRead.present) {
      map['last_read'] = Variable<String, StringType>(d.lastRead.value);
    }
    return map;
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $NotesTable _notes;
  $NotesTable get notes => _notes ??= $NotesTable(this);
  $BookmarksTable _bookmarks;
  $BookmarksTable get bookmarks => _bookmarks ??= $BookmarksTable(this);
  @override
  List<TableInfo> get allTables => [notes, bookmarks];
}
