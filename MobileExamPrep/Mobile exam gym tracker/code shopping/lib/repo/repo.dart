import 'dart:collection';

import 'package:code_shopping/dao/my_entity_dao.dart';
import 'package:floor/floor.dart';
import 'package:logger/logger.dart';

import '../models/my_entity.dart';
import '../networking/rest_client.dart';

class Repo {
  static bool hasInternet = true;
  static bool hasSync1 = false; // for list of dates
  static bool hasSync2 = false; // for list of symptoms
  static late final Logger logger;
  static final queue = Queue<MyEntity>();
  static final deleteQueue = Queue<int>();

  static late final MyEntityDao dao;
  static late final RestClient client;
  static List<String> syncDates = [];

  Future<List<String>> getCategories() async {
    print("get all categories");
    logger.d("get all categories");
    var res; // from local storage

    try {
      if (hasInternet) {
        res = client.getCategories().then((value) {
          return value;
        }).onError((error, stackTrace) {
          print(error);
          print(stackTrace);
          return [];
        });
        syncCategoriesToLocalStorage(res);
      } else {
        res = syncDates;
      }
    } on Exception catch (error) {
      return Future.error(error);
    }
    return res;
  }

  Future<void> syncCategoriesToLocalStorage(Future<List<String>> list) async {
    print("Sync categories to local storage");
    logger.d("sync categories");

    syncDates = await list;

    hasSync1 = true;
  }

  Future<List<MyEntity>> getActivitiesForCategory(String category) {
    print("get all activities for a date");
    logger.d("get all symptoms for a date");
    Future<List<MyEntity>> res = dao.findMyEntityByColumn(category);

    try {
      if (hasInternet) {
        res = client.getEntitiesByCategory(category).then((value) {
          return value;
        }).onError((error, stackTrace) {
          print(error);
          print(stackTrace);
          throw Exception("A problem with get all my entities");
        });
        syncEntitiesToLocalStorage(res);
      }
    } on Exception catch (error) {
      return Future.error(error);
    }
    return res;
  }

  Future<void> syncEntitiesToLocalStorage(Future<List<MyEntity>> list) async {
    List<MyEntity> listEntities = await list;

    for (var entity in listEntities) {
      print("syncEntitiesToLocalStorage");
      if (entity.id == null) {
        continue;
      }
      var exists = await dao.findMyEntityById(entity.id!);
      print(exists?.id);

      if (exists == null) {
        await dao.insertMyEntity(entity);
      }
    }
    hasSync2 = true;
  }

  Future<bool> deleteEntity(int id) async {
    print("REPO DELETE $id");

    try {
      print("HAS internet $hasInternet");
      // todo
      if (hasInternet) {
        print("Sending delete request to server");
        await client
            .deleteEntity(id)
            .then((it) => print(it.id))
            .onError((error, stackTrace) {
          print(error);
          print(stackTrace);
        });
      } else {
        deleteQueue.add(id);
      }

      final entity = await dao.findMyEntityById(id);
      if (entity == null) return false;
      dao.deleteMyEntity(entity);
      return true;
    } on Exception catch (error) {
      return Future.error(error);
    }
  }

  Future<bool> addEntity(MyEntity entity) async {
    print("Add entity repo");
    try {
      if (hasInternet) {
        await client.postEntity(entity).then((it) {
          return dao.insertMyEntity(it);
        }).onError((error, stackTrace) {});
      } else {
        entity.id = DateTime.now().millisecondsSinceEpoch;
        await dao.insertMyEntity(entity);
        queue.add(entity);
      }
      return true;
    } on Exception catch (error) {
      return Future.error(error);
    }
  }

  Future<List<MyEntity>> getEntities() async {
    print("get available entities");
    Future<List<MyEntity>> res;
    try {
      if (hasInternet) {
        res = client.getEntities().then((value) {
          print(value);
          return value;
        }).onError((error, stackTrace) {
          print(error);
          print(stackTrace);
          return [];
        });
        return res;
      }
    } on Exception catch (error) {
      return Future.error(error);
    }
    return [];
  }

  Future<bool> setColumn(int id, String col) async {
    print("setting column");
    try {
      if (hasInternet) {
        var ceva = SendObjJson(id, col);
        await client.postMyEntity2(ceva).then((it) {
          print("here");
          print(it.intensity);
          return dao.updateMyEntity(it);
        }).onError((error, stackTrace) {
          print(error);
          print(stackTrace);
        });
      }else {
        var entity = await dao.findMyEntityById(id);
        if (entity != null) {
          entity.id = DateTime
              .now()
              .millisecondsSinceEpoch;
          entity.intensity = col;
          await dao.updateMyEntity(entity);
          queue.add(entity);
        }
      }
      return true;
    } on Exception catch (error) {
      return Future.error(error);
    }
  }
}

class SendObjJson {
  int id = 1;
  String col = "";

  SendObjJson(this.id, this.col);

  Map toJson() => {
        'id': id,
        'intensity': col,
      };
}

///////////

//   Future<MyEntity> takeParking(int id) {
//     print("borrow parking $id");
//     Borrow obj = Borrow(id, "ceva");
//
//     var parking = client.borrowParking(obj).then((value) {
//       print("take");
//       print(value);
//       return value;
//     });
//     return parking;
//   }
//
//   Future<List<MyEntity>> getAllParkings() async {
//     print("get all parkings");
//     Future<List<MyEntity>> res;
//     try {
//       if (hasInternet) {
//         res = client.getAllParkings().then((value) {
//           print("All parkings");
//           print(value);
//           return value;
//         }).onError((error, stackTrace) {
//           print(error);
//           print(stackTrace);
//           throw Exception("Cannot connect");
//
//         });
//         return res;
//       }
//     } on Exception catch (error) {
//       return Future.error(error);
//     }
//     return [];
//   }

//
// class Borrow {
//   int id = 1;
//   String studentName = "J";
//
//   Borrow(this.id, this.studentName);
//
//   Map toJson() => {
//     'id': id,
//     'student': studentName,
//   };
//
// }

// client.borrowParking(obj.toJson());
