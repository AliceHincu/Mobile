import 'package:intl/intl.dart';

String noteTable = 'note_table';

class NoteFields {
  static const String id = '_id';
  static const String title = 'title';
  static const String description = 'description';
  static const String date = 'date';
  static const String emotion = 'emotion';

  static final List<String> values = [
    id, title, description, date, emotion
  ];
}

class Note {
  int? id;
  String title;
  String description;
  String date;
  int emotion;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.emotion
  });

  // Convert a Note object into a Map object
  Map<String, Object?> toJson() {
    return {
      NoteFields.id: id,
      NoteFields.title: title,
      NoteFields.description: description,
      NoteFields.emotion: emotion,
      NoteFields.date: date,
    };
  }

  // Extract a Note object from a Map object using a name constructor
  static Note fromJson(Map<String, dynamic> json) {
    var id = json[NoteFields.id] as int?;
    var title = json[NoteFields.title] as String;
    var description = json[NoteFields.description] as String;
    var emotion = json[NoteFields.emotion] as int;
    var date;
    if(int.tryParse(json[NoteFields.date].toString()) == null ) {
      date = json[NoteFields.date] as String;
    } else {
      var d = json[NoteFields.date] as int;
      var dt = DateTime.fromMillisecondsSinceEpoch(d);
      date = DateFormat('dd/MM/yyyy').format(dt).toString();
    }
    return Note(id: id, title: title, description: description, date: date, emotion: emotion);
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, description: $description, date: $date, emotion: $emotion}';
  }

  Note copy({
    int? id,
    String? title,
    String? description,
    String? date,
    int? emotion
  }) =>
      Note(
          id: id ?? this.id,
          title: title ?? this.title,
          description: description ?? this.description,
          date: date ?? this.date,
          emotion: emotion ?? this.emotion
      );
}