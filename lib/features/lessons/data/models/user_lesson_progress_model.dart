class UserLessonProgressModel {
  final String id;
  final String userId;
  final String lessonId;
  final bool completed;
  final int score;
  final double accuracy;
  final int correctAnswers;
  final int wrongAnswers;
  final int xpEarned;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserLessonProgressModel({
    required this.id,
    required this.userId,
    required this.lessonId,
    required this.completed,
    required this.score,
    required this.accuracy,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.xpEarned,
    required this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserLessonProgressModel.fromJson(Map<String, dynamic> json) {
    return UserLessonProgressModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      lessonId: json['lesson_id'] as String,
      completed: json['completed'] as bool? ?? false,
      score: json['score'] as int? ?? 0,
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0,
      correctAnswers: json['correct_answers'] as int? ?? 0,
      wrongAnswers: json['wrong_answers'] as int? ?? 0,
      xpEarned: json['xp_earned'] as int? ?? 0,
      completedAt: _parseOptionalDate(json['completed_at']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  static DateTime? _parseOptionalDate(Object? value) {
    if (value == null) return null;
    return DateTime.tryParse(value as String);
  }
}
