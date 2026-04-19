import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/firebase_service.dart';
import '../../core/services/hive_service.dart';
import 'incident_event.dart';
import 'incident_state.dart';

class IncidentBloc extends Bloc<IncidentEvent, IncidentState> {
  final FirebaseService _firebaseService;

  IncidentBloc({required FirebaseService firebaseService})
      : _firebaseService = firebaseService,
        super(IncidentInitial()) {
    on<IncidentLoadRequested>(_onLoadRequested);
    on<IncidentCreateRequested>(_onCreateRequested);
    on<IncidentConfirmRequested>(_onConfirmRequested);
    on<IncidentFlagRequested>(_onFlagRequested);
    on<IncidentStatusUpdateRequested>(_onStatusUpdateRequested);
  }

  Future<void> _onLoadRequested(
    IncidentLoadRequested event,
    Emitter<IncidentState> emit,
  ) async {
    emit(IncidentLoading());
    try {
      final incidents = await _firebaseService.getIncidents();
      await HiveService.cacheIncidents(incidents);
      emit(IncidentLoaded(incidents: incidents));
    } catch (e) {
      final cached = HiveService.getCachedIncidents();
      if (cached.isNotEmpty) {
        emit(IncidentLoaded(incidents: cached, isOffline: true));
      } else {
        emit(IncidentError(message: 'Failed to load incidents'));
      }
    }
  }

  Future<void> _onCreateRequested(
    IncidentCreateRequested event,
    Emitter<IncidentState> emit,
  ) async {
    try {
      await _firebaseService.createIncident(event.incident);
      emit(IncidentCreated());
      add(IncidentLoadRequested());
    } catch (e) {
      await HiveService.saveDraftIncident(event.incident.toMap());
      emit(IncidentError(
          message: 'Saved as draft. Will submit when online.'));
    }
  }

  Future<void> _onConfirmRequested(
    IncidentConfirmRequested event,
    Emitter<IncidentState> emit,
  ) async {
    try {
      await _firebaseService.confirmIncident(event.incidentId);
      add(IncidentLoadRequested());
    } catch (e) {
      emit(IncidentError(message: 'Failed to confirm incident'));
    }
  }

  Future<void> _onFlagRequested(
    IncidentFlagRequested event,
    Emitter<IncidentState> emit,
  ) async {
    try {
      await _firebaseService.flagIncident(event.incidentId);
      add(IncidentLoadRequested());
    } catch (e) {
      emit(IncidentError(message: 'Failed to flag incident'));
    }
  }

  Future<void> _onStatusUpdateRequested(
    IncidentStatusUpdateRequested event,
    Emitter<IncidentState> emit,
  ) async {
    try {
      await _firebaseService.updateIncidentStatus(
          event.incidentId, event.status);
      add(IncidentLoadRequested());
    } catch (e) {
      emit(IncidentError(message: 'Failed to update status'));
    }
  }
}