import '../../models/symptom.dart';
import '../../repo/repo.dart';

class Screen1ViewModel {
  final Repo _repo;

  Screen1ViewModel(this._repo);

  Future<List<String>> getDates() {
    print("VM get dates");
    return _repo.getDates();
  }

  Future<List<Symptom>> getSymptomsForDate(String date) {
    print("VM get entity for $date");
    return _repo.getSymptomsForDate(date);
  }

  Future<bool> addEntity(Symptom parking) {
    print("VM add entity");
    return _repo.addEntity(parking);
  }

  Future<bool> deleteEntity(int id) {
    print("VM delete entity");
    return _repo.deleteEntity(id);
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

  Future<Map> top3Doctors() async {
    print("VM get top 3");
    var entities = await _repo.getEntities();
    var doctors = {};
    // entities.sort((a, b) {
    //   int cmp = b.doctor!.compareTo(a.doctor!);
    //   return cmp;
    // });
    // return entities.take(3);
    for (var e in entities) {
      if (e.doctor != null) {
        if (!doctors.containsKey(e.doctor)) {
          doctors[e.doctor] = 1;
        } else {
          doctors[e.doctor] += 1;
        }
      }
    }

    var sortedByValueMapDescending = Map.fromEntries(doctors.entries.toList()
      ..sort((e1, e2) => e2.value.compareTo(e1.value)));

    print(sortedByValueMapDescending);
    return sortedByValueMapDescending;
  }

  Future<Map> getProgress() async {
    print("VM get progress");
    var entities = await _repo.getEntities();

    // final propertyA = d(a);
    // final propertyB = someProperty(b);
    //
    // if (propertyA < propertyB) {
    //   return -1;
    // } else if (propertyA > propertyB) {
    //   return 1;
    // } else {
    //   return 0;
    // }

    // books.sort((a, b) => {if (a.number < b.number) {
    //   return -1;
    // } else if (a.number > b.number) {
    // return 1;
    // } else {
    // return 0;
    // }})

    var months = {};
    var monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    for (String name in monthNames) {
      months[name] = 0;
    }

    for (var e in entities) {
      if (e.date != null) {
        print(e.toString());
        int m = DateTime.parse(e.date!).month;
        String name = monthNames[m - 1];
        months[name] += 1;
      }
    }
    // books.sort((a, b) => b.count!.compareTo(a.count!));
    //
    // List<Symptom> result = [];
    // for (var i = 0; i < 15; i++) {
    //   print(books[i].number);
    //   result.add(books[i]);
    // }
    return months;
  }
}
