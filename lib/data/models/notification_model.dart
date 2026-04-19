class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type;
  final String? incidentId;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.incidentId,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      title: map['title'],
      body: map['body'],
      type: map['type'],
      incidentId: map['incidentId'],
      isRead: map['isRead'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'type': type,
      'incidentId': incidentId,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}