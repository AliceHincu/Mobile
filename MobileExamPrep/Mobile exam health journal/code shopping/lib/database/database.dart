// database.dart
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../dao/symptom_dao.dart';
import '../models/symptom.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Symptom])
abstract class AppDatabase extends FloorDatabase {
  SymptomDao get symptomDao;
}