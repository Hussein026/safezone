class IncidentModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String severity;
  final double latitude;
  final double longitude;
  final String? imageUrl;
  final bool isAnonymous;
  final String? reportedBy;
  final DateTime createdAt;
  String status;
  int confirmations;

  IncidentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.severity,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    this.isAnonymous = false,
    this.reportedBy,
    required this.createdAt,
    this.status = 'ongoing',
    this.confirmations = 0,
  });

  factory IncidentModel.fromMap(Map<String, dynamic> map, String id) {
    return IncidentModel(
      id: id,
      title: map['title'],
      description: map['description'],
      category: map['category'],
      severity: map['severity'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      imageUrl: map['imageUrl'],
      isAnonymous: map['isAnonymous'] ?? false,
      reportedBy: map['reportedBy'],
      createdAt: DateTime.parse(map['createdAt']),
      status: map['status'] ?? 'ongoing',
      confirmations: map['confirmations'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'severity': severity,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'isAnonymous': isAnonymous,
      'reportedBy': reportedBy,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'confirmations': confirmations,
    };
  }
}