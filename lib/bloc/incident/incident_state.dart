import '../../data/models/incident_model.dart';

abstract class IncidentState {}

class IncidentInitial extends IncidentState {}

class IncidentLoading extends IncidentState {}

class IncidentLoaded extends IncidentState {
  final List<IncidentModel> incidents;
  final bool isOffline;
  IncidentLoaded({
    required this.incidents,
    this.isOffline = false,
  });
}

class IncidentCreated extends IncidentState {}

class IncidentError extends IncidentState {
  final String message;
  IncidentError({required this.message});
}