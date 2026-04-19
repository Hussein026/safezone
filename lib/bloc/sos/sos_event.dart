abstract class SosEvent {}

class SosActivated extends SosEvent {
  final double latitude;
  final double longitude;
  SosActivated({required this.latitude, required this.longitude});
}

class SosCancelled extends SosEvent {}