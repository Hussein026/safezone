class GroupModel {
  final String id;
  final String name;
  final String code;
  final String createdBy;
  final List<String> members;
  final double safetyScore;
  final DateTime createdAt;

  GroupModel({
    required this.id,
    required this.name,
    required this.code,
    required this.createdBy,
    this.members = const [],
    this.safetyScore = 100,
    required this.createdAt,
  });

  factory GroupModel.fromMap(Map<String, dynamic> map, String id) {
    return GroupModel(
      id: id,
      name: map['name'],
      code: map['code'],
      createdBy: map['createdBy'],
      members: List<String>.from(map['members'] ?? []),
      safetyScore: map['safetyScore'] ?? 100,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
      'createdBy': createdBy,
      'members': members,
      'safetyScore': safetyScore,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}