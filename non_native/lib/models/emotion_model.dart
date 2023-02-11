class EmotionModel {
  late int id;
  late String emotion;

  EmotionModel(this.id, this.emotion); // named constructor

  // Convert a Note object into a Map object
  toMap() {
    return {
      'id': id,
      'emotion': emotion,
    };
  }

  @override
  String toString() {
    return 'Emotion{id: $id, emotion: $emotion}';
  }

  // Extract a Note object from a Map object using a name constructor
  EmotionModel.fromMapObject(Map<String, dynamic> map) {
    id = map['id'];
    emotion = map['emotion'];
  }
}
