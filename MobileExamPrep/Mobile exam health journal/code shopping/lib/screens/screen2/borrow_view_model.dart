//
//
// import 'package:code_shopping/models/symptom.dart';
//
// import '../../repo/repo.dart';
//
// class BorrowViewModel {
//   final Repo _repo;
//
//   BorrowViewModel(this._repo);
//
//   Future<List<Symptom>> getAvailable() {
//     return _repo.getAvailableParkings();
//   }
//
//   Future<Symptom> borrowBook(int? id) async{
//     var book = _repo.takeParking(id!);
//     return await book;
//   }
//
// }