class UserMistakeModel {
  final String id;
  final String userId;
  final String exerciseId;
  final int mistakeCount;
  final DateTime lastWrongAt;
  final DateTime? lastReviewedAt;
  final bool resolved;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserMistakeModel({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.mistakeCount,
    required this.lastWrongAt,
    required this.lastReviewedAt,
    required this.resolved,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserMistakeModel.fromJson(Map<String, dynamic> json) {
    return UserMistakeModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      exerciseId: json['exercise_id'] as String,
      mistakeCount: json['mistake_count'] as int? ?? 1,
      lastWrongAt: DateTime.parse(json['last_wrong_at'] as String),
      lastReviewedAt: _parseOptionalDate(json['last_reviewed_at']),
      resolved: json['resolved'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  static DateTime? _parseOptionalDate(Object? value) {
    if (value == null) return null;
    return DateTime.tryParse(value as String);
  }
}
