class CommentModel {
  final String id;
  final String text;
  final String? authorId;
  final String? authorName;
  final bool isAnonymous;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.text,
    this.authorId,
    this.authorName,
    this.isAnonymous = false,
    required this.createdAt,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map, String id) {
    return CommentModel(
      id: id,
      text: map['text'],
      authorId: map['authorId'],
      authorName: map['authorName'],
      isAnonymous: map['isAnonymous'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'authorId': authorId,
      'authorName': authorName,
      'isAnonymous': isAnonymous,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}