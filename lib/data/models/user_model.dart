class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String? neighborhood;
  final double alertRadius;
  final bool isAdmin;
  final List<String> emergencyContacts;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.neighborhood,
    this.alertRadius = 1000,
    this.isAdmin = false,
    this.emergencyContacts = const [],
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      photoUrl: map['photoUrl'],
      neighborhood: map['neighborhood'],
      alertRadius: map['alertRadius'] ?? 1000,
      isAdmin: map['isAdmin'] ?? false,
      emergencyContacts: List<String>.from(map['emergencyContacts'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'neighborhood': neighborhood,
      'alertRadius': alertRadius,
      'isAdmin': isAdmin,
      'emergencyContacts': emergencyContacts,
    };
  }
}