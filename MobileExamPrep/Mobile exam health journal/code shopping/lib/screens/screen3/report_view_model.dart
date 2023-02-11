// import 'package:code_shopping/models/symptom.dart';
// import 'package:code_shopping/repo/repo.dart';
//
// abstract class ReportVM {
//   Future<List<Symptom>> getReport();
// }
//
// class ReportViewModel extends ReportVM{
//   final Repo _repo;
//
//   ReportViewModel(this._repo);
//
//   Future<List<Symptom>> getReport() async {
//     print("VM get report");
//     var books = await _repo.getAllParkings();
//
//     // final propertyA = d(a);
//     // final propertyB = someProperty(b);
//     //
//     // if (propertyA < propertyB) {
//     //   return -1;
//     // } else if (propertyA > propertyB) {
//     //   return 1;
//     // } else {
//     //   return 0;
//     // }
//
//     // books.sort((a, b) => {if (a.number < b.number) {
//     //   return -1;
//     // } else if (a.number > b.number) {
//     // return 1;
//     // } else {
//     // return 0;
//     // }})
//
//     books.sort((a, b) => b.count!.compareTo(a.count!));
//
//     List<Symptom> result = [];
//     for (var i = 0; i < 15; i++) {
//       print(books[i].number);
//       result.add(books[i]);
//     }
//
//     return result;
//   }
//
// }