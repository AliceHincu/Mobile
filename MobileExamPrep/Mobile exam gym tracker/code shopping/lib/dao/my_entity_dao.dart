import 'package:floor/floor.dart';

import '../models/my_entity.dart';

@dao
abstract class MyEntityDao {
  @Query('SELECT * FROM MyEntity')
  Future<List<MyEntity>> findAllEntities();

  @Query('SELECT DISTINCT category FROM MyEntity')
  Future<List<String>> findAllUniqueValues();

  @Query('SELECT * FROM MyEntity WHERE id = :id')
  Future<MyEntity?> findMyEntityById(int id);

  @Query('SELECT * FROM MyEntity WHERE category = :category')
  Future<List<MyEntity>> findMyEntityByColumn(String category);

  @insert
  Future<void> insertMyEntity(MyEntity myEntity);

  @delete
  Future<void> deleteMyEntity(MyEntity myEntity);

  @update
  Future<void> updateMyEntity(MyEntity myEntity);
}