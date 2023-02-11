import 'package:flutter/cupertino.dart';

import 'note.dart';

class NoteListModel extends ChangeNotifier{
  final List<Note> _dataList = [];

  List<Note> get dataList => _dataList;

  addItem(Note note) {
    debugPrint("add Item func before: $_dataList");
    _dataList.add(note);
    debugPrint("add Item func after: $_dataList");
    notifyListeners();
  }

  updateItem(Note note) {
    final position = _dataList.indexWhere((element) => element.id == note.id);
    _dataList[position] = note;
    notifyListeners();
  }

  deleteItem(int id) {
    final position = _dataList.indexWhere((element) => element.id == id);
    _dataList.removeAt(position);
    notifyListeners();
  }

  getCount() {
    return _dataList.length;
  }
}