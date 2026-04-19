abstract class NotificationEvent {}

class NotificationLoadRequested extends NotificationEvent {
  final String userId;
  NotificationLoadRequested({required this.userId});
}

class NotificationMarkReadRequested extends NotificationEvent {
  final String userId;
  final String notificationId;
  NotificationMarkReadRequested({
    required this.userId,
    required this.notificationId,
  });
}