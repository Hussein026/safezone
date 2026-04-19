class AppConstants {
  // Alert Radius Options
  static const List<double> alertRadiusOptions = [500, 1000, 5000];
  static const List<String> alertRadiusLabels = ['500m', '1km', '5km'];

  // Incident Categories
  static const List<String> incidentCategories = [
    'Theft',
    'Fire',
    'Accident',
    'Suspicious Activity',
    'Medical Emergency',
    'Natural Disaster',
  ];

  // Severity Levels
  static const List<String> severityLevels = [
    'low',
    'medium',
    'high',
    'critical',
  ];

  // Incident Status
  static const String statusOngoing = 'ongoing';
  static const String statusInvestigating = 'investigating';
  static const String statusResolved = 'resolved';

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String incidentsCollection = 'incidents';
  static const String notificationsCollection = 'notifications';
  static const String groupsCollection = 'groups';
  static const String commentsCollection = 'comments';

  // Hive Boxes
  static const String incidentsBox = 'incidents_box';
  static const String notificationsBox = 'notifications_box';
  static const String userBox = 'user_box';

  // WebSocket
  static const String wsUrl = 'wss://echo.websocket.org';

  // Emergency
  static const String emergencyNumber = '112';
}