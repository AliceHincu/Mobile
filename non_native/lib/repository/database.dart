import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../domain/message.dart';
import '../domain/message_type.dart';
import '../domain/webSocketClient.dart';
import '../models/note.dart';


class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();
  final WebSocketClient client = WebSocketClient.getInstance();
  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    _database = await _initializeDatabase('notes.db');
    return _database!;
  }

  Future<Database> _initializeDatabase(String filePath) async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, filePath);

    // Open/Create the database at a given path
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future _createDatabase(Database database, int version) async {
    String sql = '''
      CREATE TABLE $noteTable (
        ${NoteFields.id} INTEGER PRIMARY KEY, 
        ${NoteFields.title} TEXT, 
        ${NoteFields.description} TEXT, 
        ${NoteFields.emotion} INTEGER, 
        ${NoteFields.date} TEXT
      )
    ''';

    await database.execute(sql);
  }

  Future _destroyDatabase(Database db) async {
    await db.execute('''
      DROP TABLE $noteTable
    ''');
  }

  Future _rebuildDatabase() async {
    final db = await instance.database;
    await _destroyDatabase(db);
    await _createDatabase(db, 1);
  }

  Future syncDatabaseWithServer() async {
    // await _rebuildDatabase();
    client.subscribe(json.encode(Message<List<Note>>(type: MessageType.GET_ALL, data: await readAllNotes())));
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;

    await db.insert(noteTable, note.toJson());
    return note;
  }

  readNote(table, itemId) async {
    var db = await database;

    final maps =  await db.query(
        table,
        where: 'id=?',
        whereArgs: [itemId]
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $itemId not found!');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;

    final result = await db.query(noteTable);

    final mapping = result.map((json) => Note.fromJson(json)).toList();

    return mapping;
  }


  Future<int> update(Note note) async {
    final db = await instance.database;

    int result =  await db.update(
        noteTable,
        note.toJson(),
        where: '${NoteFields.id} = ?', // Ensure that the Item has a matching id.
        whereArgs: [note.id]); // Pass the Item's id as a whereArg to prevent SQL injection.

    if (result == 0) {
      throw Exception("Item not found in database");
    }

    return result;
  }

  Future<int> delete(itemId) async {
    final db = await instance.database;

    int result = await db.delete(
      noteTable,
      where: '${NoteFields.id} = ?', // Use a `where` clause to delete a specific item.
      whereArgs: [itemId], // Pass the Item's id as a whereArg to prevent SQL injection.
    );

    if (result == 0) {
      throw Exception("Item not found in database");
    }

    return result;
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}