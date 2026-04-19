import '../../data/models/incident_model.dart';

abstract class IncidentEvent {}

class IncidentLoadRequested extends IncidentEvent {}

class IncidentCreateRequested extends IncidentEvent {
  final IncidentModel incident;
  IncidentCreateRequested({required this.incident});
}

class IncidentConfirmRequested extends IncidentEvent {
  final String incidentId;
  IncidentConfirmRequested({required this.incidentId});
}

class IncidentFlagRequested extends IncidentEvent {
  final String incidentId;
  IncidentFlagRequested({required this.incidentId});
}

class IncidentStatusUpdateRequested extends IncidentEvent {
  final String incidentId;
  final String status;
  IncidentStatusUpdateRequested({
    required this.incidentId,
    required this.status,
  });
}