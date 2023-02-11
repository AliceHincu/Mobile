import 'dart:collection';

import 'package:logger/logger.dart';


import '../dao/symptom_dao.dart';
import '../models/symptom.dart';
import '../networking/rest_client.dart';

class Repo {
  static bool hasInternet = true;
  static bool hasSync1 = false; // for list of dates
  static bool hasSync2 = false; // for list of symptoms
  static late final Logger logger;
  static final queue = Queue<Symptom>();
  static final deleteQueue = Queue<int>();

  static late final SymptomDao dao;
  static late final RestClient client;
  static List <String> syncDates = [];

  Future<List<String>> getDates() async {
    print("get all dates");
    logger.d("get all dates (/get days)");
    var res; // from local storage

    try {
      if (hasInternet) {
        res = client.getDays().then((value) {
          return value;
        }).onError((error, stackTrace) {
          print(error);
          print(stackTrace);
          return [];
        });
        syncDatesToLocalStorage(res);
      } else {
        res = syncDates;
      }
    } on Exception catch (error) {
      return Future.error(error);
    }
    return res;
  }

  Future<void> syncDatesToLocalStorage(Future<List<String>> list) async {
    print("Sync dates to local storage");
    logger.d("sync dates");

    syncDates = await list;

    hasSync1 = true;
  }

  Future<List<Symptom>> getSymptomsForDate(String date) {
    print("get all symptoms for a date");
    logger.d("get all symptoms for a date");
    Future<List<Symptom>> res = dao.findEntityByDate(date);

    try {
      if (hasInternet) {
        res = client.getSymptomsByDate(date).then((value) {
          return value;
        }).onError((error, stackTrace) {
          print(error);
          print(stackTrace);
          throw Exception("A problem with get all my entities");
        });
        syncSymptomsToLocalStorage(res);
      }
    } on Exception catch (error) {
      return Future.error(error);
    }
    return res;
  }

  Future<void> syncSymptomsToLocalStorage(Future<List<Symptom>> list) async {
    List<Symptom> listEntities = await list;

    for (var entity in listEntities) {
      print("here");
      if (entity.id == null) {
        continue;
      }
      var exists = await dao.findEntityById(entity.id!);
      print(exists?.id);

      if (exists == null) {
        await dao.insertEntity(entity);
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
            .deleteSymptom(id)
            .then((it) => print(it.id))
            .onError((error, stackTrace) {
          print(error);
          print(stackTrace);
        });
      }
      else {
        deleteQueue.add(id);
      }

      final entity = await dao.findEntityById(id);
      if (entity == null) return false;
      dao.deleteEntity(entity);
      return true;
    } on Exception catch (error) {
      return Future.error(error);
    }
  }

  Future<bool> addEntity(Symptom entity) async {
    print("Add entity repo");
    try {
      if (hasInternet) {
        await client.postParking(entity).then((it) {
          return dao.insertEntity(it);
        }).onError((error, stackTrace) {});
      } else {
        entity.id = DateTime.now().millisecondsSinceEpoch;
        await dao.insertEntity(entity);
        queue.add(entity);
      }
      return true;
    } on Exception catch (error) {
      return Future.error(error);
    }
  }

  Future<List<Symptom>> getEntities() async {
    print("get available entities");
    Future<List<Symptom>> res;
    try {
      if (hasInternet) {
        res = client.getSymptoms().then((value) {
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

  ///////////

  Future<Symptom> takeParking(int id) {
    print("borrow parking $id");
    Borrow obj = Borrow(id, "ceva");

    var parking = client.borrowParking(obj).then((value) {
      print("take");
      print(value);
      return value;
    });
    return parking;
  }

  Future<List<Symptom>> getAllParkings() async {
    print("get all parkings");
    Future<List<Symptom>> res;
    try {
      if (hasInternet) {
        res = client.getAllParkings().then((value) {
          print("All parkings");
          print(value);
          return value;
        }).onError((error, stackTrace) {
          print(error);
          print(stackTrace);
          throw Exception("Cannot connect");

        });
        return res;
      }
    } on Exception catch (error) {
      return Future.error(error);
    }
    return [];
  }

}

class Borrow {
  int id = 1;
  String studentName = "J";

  Borrow(this.id, this.studentName);

  Map toJson() => {
    'id': id,
    'student': studentName,
  };

}

// client.borrowParking(obj.toJson());