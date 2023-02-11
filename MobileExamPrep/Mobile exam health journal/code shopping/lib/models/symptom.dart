import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'symptom.g.dart';

@entity
@JsonSerializable()
class Symptom {
  @JsonKey(name: 'id')
  @PrimaryKey()
  int? id;
  String? date;
  String? symptom;
  String? medication;
  String? dosage;
  String? doctor;
  String? notes;

  Symptom({
    this.id,
    required this.date,
    required this.symptom,
    required this.medication,
    required this.dosage,
    required this.doctor,
    required this.notes,
  });

  factory Symptom.fromJson(Map<String, dynamic> json) =>
      _$SymptomFromJson(json);

  Map<String, dynamic> toJson() => _$SymptomToJson(this);

}
