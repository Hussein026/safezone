abstract class SosState {}

class SosInitial extends SosState {}

class SosActivating extends SosState {}

class SosActive extends SosState {
  final double latitude;
  final double longitude;
  SosActive({required this.latitude, required this.longitude});
}

class SosCancelled extends SosState {}

class SosError extends SosState {
  final String message;
  SosError({required this.message});
}