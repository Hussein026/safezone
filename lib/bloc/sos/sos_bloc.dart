import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/firebase_service.dart';
import '../../core/services/location_service.dart';
import '../../data/models/incident_model.dart';
import 'sos_event.dart';
import 'sos_state.dart' hide SosCancelled;

class SosBloc extends Bloc<SosEvent, SosState> {
  final FirebaseService _firebaseService;

  SosBloc({required FirebaseService firebaseService})
      : _firebaseService = firebaseService,
        super(SosInitial()) {
    on<SosActivated>(_onSosActivated);
    on<SosCancelled>(_onSosCancelled);
  }

  Future<void> _onSosActivated(
    SosActivated event,
    Emitter<SosState> emit,
  ) async {
    emit(SosActivating());
    try {
      final position = await LocationService.getCurrentLocation();
      final lat = position?.latitude ?? event.latitude;
      final lng = position?.longitude ?? event.longitude;

      final sosIncident = IncidentModel(
        id: '',
        title: '🆘 SOS Emergency Alert',
        description: 'User triggered SOS emergency alert',
        category: 'Medical Emergency',
        severity: 'critical',
        latitude: lat,
        longitude: lng,
        createdAt: DateTime.now(),
        status: 'ongoing',
      );

      await _firebaseService.createIncident(sosIncident);
      emit(SosActive(latitude: lat, longitude: lng));
    } catch (e) {
      emit(SosError(message: 'Failed to send SOS'));
    }
  }

  Future<void> _onSosCancelled(
    SosCancelled event,
    Emitter<SosState> emit,
  ) async {
    emit(SosCancelled() as SosState);
  }
}