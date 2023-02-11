import 'package:floor/floor.dart';
import '../models/symptom.dart';


@dao
abstract class SymptomDao {
  @Query('SELECT * FROM Symptom')
  Future<List<Symptom>> findAllSymptoms();

  @Query('SELECT DISTINCT date FROM Symptom')
  Future<List<String>> findAllUniqueValues();

  @Query('SELECT * FROM Symptom WHERE id = :id')
  Future<Symptom?> findEntityById(int id);

  @Query('SELECT * FROM Symptom WHERE date = :date')
  Future<List<Symptom>> findEntityByDate(String date);

  @insert
  Future<void> insertEntity(Symptom entity);

  @delete
  Future<void> deleteEntity(Symptom entity);

  @update
  Future<void> updateEntity(Symptom entity);
}