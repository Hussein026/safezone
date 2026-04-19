import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/firebase_service.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final FirebaseService _firebaseService;

  NotificationBloc({required FirebaseService firebaseService})
      : _firebaseService = firebaseService,
        super(NotificationInitial()) {
    on<NotificationLoadRequested>(_onLoadRequested);
    on<NotificationMarkReadRequested>(_onMarkReadRequested);
  }

  Future<void> _onLoadRequested(
    NotificationLoadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      final notifications = await _firebaseService
          .notificationsStream(event.userId)
          .first;
      final unreadCount =
          notifications.where((n) => !n.isRead).length;
      emit(NotificationLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(NotificationError(message: 'Failed to load notifications'));
    }
  }

  Future<void> _onMarkReadRequested(
    NotificationMarkReadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _firebaseService.markNotificationRead(
          event.userId, event.notificationId);
      add(NotificationLoadRequested(userId: event.userId));
    } catch (e) {
      emit(NotificationError(message: 'Failed to mark as read'));
    }
  }
}