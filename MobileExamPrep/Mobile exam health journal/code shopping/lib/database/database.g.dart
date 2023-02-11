// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  SymptomDao? _symptomDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Symptom` (`id` INTEGER, `date` TEXT, `symptom` TEXT, `medication` TEXT, `dosage` TEXT, `doctor` TEXT, `notes` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SymptomDao get symptomDao {
    return _symptomDaoInstance ??= _$SymptomDao(database, changeListener);
  }
}

class _$SymptomDao extends SymptomDao {
  _$SymptomDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _symptomInsertionAdapter = InsertionAdapter(
            database,
            'Symptom',
            (Symptom item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'symptom': item.symptom,
                  'medication': item.medication,
                  'dosage': item.dosage,
                  'doctor': item.doctor,
                  'notes': item.notes
                }),
        _symptomUpdateAdapter = UpdateAdapter(
            database,
            'Symptom',
            ['id'],
            (Symptom item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'symptom': item.symptom,
                  'medication': item.medication,
                  'dosage': item.dosage,
                  'doctor': item.doctor,
                  'notes': item.notes
                }),
        _symptomDeletionAdapter = DeletionAdapter(
            database,
            'Symptom',
            ['id'],
            (Symptom item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'symptom': item.symptom,
                  'medication': item.medication,
                  'dosage': item.dosage,
                  'doctor': item.doctor,
                  'notes': item.notes
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Symptom> _symptomInsertionAdapter;

  final UpdateAdapter<Symptom> _symptomUpdateAdapter;

  final DeletionAdapter<Symptom> _symptomDeletionAdapter;

  @override
  Future<List<Symptom>> findAllSymptoms() async {
    return _queryAdapter.queryList('SELECT * FROM Symptom',
        mapper: (Map<String, Object?> row) => Symptom(
            id: row['id'] as int?,
            date: row['date'] as String?,
            symptom: row['symptom'] as String?,
            medication: row['medication'] as String?,
            dosage: row['dosage'] as String?,
            doctor: row['doctor'] as String?,
            notes: row['notes'] as String?));
  }

  @override
  Future<List<String>> findAllUniqueValues() async {
    return _queryAdapter.queryList('SELECT DISTINCT date FROM Symptom',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<Symptom?> findEntityById(int id) async {
    return _queryAdapter.query('SELECT * FROM Symptom WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Symptom(
            id: row['id'] as int?,
            date: row['date'] as String?,
            symptom: row['symptom'] as String?,
            medication: row['medication'] as String?,
            dosage: row['dosage'] as String?,
            doctor: row['doctor'] as String?,
            notes: row['notes'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<Symptom>> findEntityByDate(String date) async {
    return _queryAdapter.queryList('SELECT * FROM Symptom WHERE date = ?1',
        mapper: (Map<String, Object?> row) => Symptom(
            id: row['id'] as int?,
            date: row['date'] as String?,
            symptom: row['symptom'] as String?,
            medication: row['medication'] as String?,
            dosage: row['dosage'] as String?,
            doctor: row['doctor'] as String?,
            notes: row['notes'] as String?),
        arguments: [date]);
  }

  @override
  Future<void> insertEntity(Symptom entity) async {
    await _symptomInsertionAdapter.insert(entity, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateEntity(Symptom entity) async {
    await _symptomUpdateAdapter.update(entity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEntity(Symptom entity) async {
    await _symptomDeletionAdapter.delete(entity);
  }
}
