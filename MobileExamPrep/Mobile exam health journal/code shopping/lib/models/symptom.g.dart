// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symptom.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Symptom _$SymptomFromJson(Map<String, dynamic> json) => Symptom(
      id: json['id'] as int?,
      date: json['date'] as String?,
      symptom: json['symptom'] as String?,
      medication: json['medication'] as String?,
      dosage: json['dosage'] as String?,
      doctor: json['doctor'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$SymptomToJson(Symptom instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'symptom': instance.symptom,
      'medication': instance.medication,
      'dosage': instance.dosage,
      'doctor': instance.doctor,
      'notes': instance.notes,
    };
