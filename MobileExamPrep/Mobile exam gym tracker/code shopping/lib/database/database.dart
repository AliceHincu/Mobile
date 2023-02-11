// database.dart
import 'dart:async';
import 'package:floor/floor.dart';
import '../dao/my_entity_dao.dart';
import '../models/my_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';

part 'database.g.dart';

@Database(version: 1, entities: [MyEntity])
abstract class AppDatabase extends FloorDatabase {
  MyEntityDao get myEntityDao;
}