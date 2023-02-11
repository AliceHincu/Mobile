import 'package:floor_generator/misc/extension/iterable_extension.dart';

import '../../models/my_entity.dart';
import '../../repo/repo.dart';

class ViewModel {
  final Repo _repo;

  ViewModel(this._repo);

  Future<List<String>> getDates() {
    print("VM get dates");
    return _repo.getCategories();
  }

  Future<List<MyEntity>> getSymptomsForDate(String date) {
    print("VM get entity for $date");
    return _repo.getActivitiesForCategory(date);
  }

  Future<bool> addEntity(MyEntity parking) {
    print("VM add entity");
    return _repo.addEntity(parking);
  }

  Future<bool> deleteEntity(int id) {
    print("VM delete entity");
    return _repo.deleteEntity(id);
  }

  Future<bool> setColumn(String col, int id) {
    return _repo.setColumn(id, col);
  }

  int weeksBetween(DateTime from, DateTime to) {
    from = DateTime.utc(from.year, from.month, from.day);
    to = DateTime.utc(to.year, to.month, to.day);
    return (to.difference(from).inDays / 7).ceil();
  }

  int getWeekNumber(String dateString) {
    DateTime someDate = DateTime.parse(dateString);
    final date = someDate;
    final startOfYear = DateTime(date.year, 1, 1, 0, 0);
    final firstMonday = startOfYear.weekday;
    final daysInFirstWeek = 8 - firstMonday;
    final diff = date.difference(startOfYear);
    var weeks = ((diff.inDays - daysInFirstWeek) / 7).ceil();
// It might differ how you want to treat the first week
    if (daysInFirstWeek > 3) {
      weeks += 1;
    }
    return weeks;
  }

  Future<Map> weekStuff() async {
    // total Symptoms each week
    print("VM get weekly stuff");
    var entities = await _repo.getEntities();
    var weeks = {};

    for (var e in entities) {
      if (e.date != null) {
        final weekNumber = getWeekNumber(e.date!);
        if (!weeks.containsKey(weekNumber)) {
          weeks[weekNumber] = 1;
        } else {
          weeks[weekNumber] += 1;
        }
      }
    }

    return weeks;
  }

  Future<List<MyEntity>> top10Activities() async {
    print("VM get top 10");
    var valDict = {"easy": 0, "medium": 1, "hard": 2};
    var entities = await _repo.getEntities();

    var sortedEntities = entities..sort((a, b) {
      int intensityA = valDict.containsKey(a.intensity) ? valDict[a.intensity]! : 3;
      int intensityB = valDict.containsKey(b.intensity) ? valDict[b.intensity]! : 3;
      if (intensityA != intensityB) {
        return intensityA.compareTo(intensityB);
      } else {
        return a.category!.compareTo(b.category!);
      }
    });

    print(sortedEntities);
    return sortedEntities.sublist(0, 10);
  }
  //
  // Future<Map> getProgress() async {
  //   print("VM get progress");
  //   var entities = await _repo.getEntities();
  //
  //   // final propertyA = d(a);
  //   // final propertyB = someProperty(b);
  //   //
  //   // if (propertyA < propertyB) {
  //   //   return -1;
  //   // } else if (propertyA > propertyB) {
  //   //   return 1;
  //   // } else {
  //   //   return 0;
  //   // }
  //
  //   // books.sort((a, b) => {if (a.number < b.number) {
  //   //   return -1;
  //   // } else if (a.number > b.number) {
  //   // return 1;
  //   // } else {
  //   // return 0;
  //   // }})
  //
  //   var months = {};
  //   var monthNames = [
  //     "January",
  //     "February",
  //     "March",
  //     "April",
  //     "May",
  //     "June",
  //     "July",
  //     "August",
  //     "September",
  //     "October",
  //     "November",
  //     "December"
  //   ];
  //   for (String name in monthNames) {
  //     months[name] = 0;
  //   }
  //
  //   for (var e in entities) {
  //     if (e.date != null) {
  //       print(e.toString());
  //       int m = DateTime.parse(e.date!).month;
  //       String name = monthNames[m - 1];
  //       months[name] += 1;
  //     }
  //   }
  //   // books.sort((a, b) => b.count!.compareTo(a.count!));
  //   //
  //   // List<Symptom> result = [];
  //   // for (var i = 0; i < 15; i++) {
  //   //   print(books[i].number);
  //   //   result.add(books[i]);
  //   // }
  //   return months;
  // }
}
