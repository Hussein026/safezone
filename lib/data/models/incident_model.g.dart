// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncidentModel _$IncidentModelFromJson(Map<String, dynamic> json) =>
    IncidentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      severity: json['severity'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      reportedBy: json['reportedBy'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String? ?? 'ongoing',
      confirmations: (json['confirmations'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$IncidentModelToJson(IncidentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'severity': instance.severity,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'imageUrl': instance.imageUrl,
      'isAnonymous': instance.isAnonymous,
      'reportedBy': instance.reportedBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': instance.status,
      'confirmations': instance.confirmations,
    };
