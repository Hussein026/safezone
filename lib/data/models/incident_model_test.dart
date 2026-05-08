import 'package:flutter/material.dart';
import 'incident_model.dart';

void testEquatable() {
  final incident1 = IncidentModel(
    id: '1',
    title: 'Test Incident',
    description: 'Test Description',
    category: 'Theft',
    severity: 'high',
    latitude: 44.4268,
    longitude: 26.1025,
    createdAt: DateTime(2024, 1, 1),
    status: 'ongoing',
    confirmations: 0,
  );

  final incident2 = IncidentModel(
    id: '1',
    title: 'Test Incident',
    description: 'Test Description',
    category: 'Theft',
    severity: 'high',
    latitude: 44.4268,
    longitude: 26.1025,
    createdAt: DateTime(2024, 1, 1),
    status: 'ongoing',
    confirmations: 0,
  );

  debugPrint('=== Task I - Equatable Test ===');
  debugPrint('incident1 == incident2: ${incident1 == incident2}');
  debugPrint('Expected: true');

  final json = incident1.toJson();
  debugPrint('=== JSON Serialization Test ===');
  debugPrint('toJson: $json');

  final fromJson = IncidentModel.fromJson(json);
  debugPrint('fromJson title: ${fromJson.title}');
  debugPrint('fromJson == incident1: ${fromJson == incident1}');
}