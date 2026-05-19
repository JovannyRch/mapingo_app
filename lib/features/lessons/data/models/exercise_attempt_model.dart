class ExerciseAttemptInput {
  final String exerciseId;
  final String? selectedAnswer;
  final bool isCorrect;
  final int? timeSpentSeconds;

  const ExerciseAttemptInput({
    required this.exerciseId,
    required this.selectedAnswer,
    required this.isCorrect,
    this.timeSpentSeconds,
  });
}

class ExerciseAttemptModel {
  final String id;
  final String userId;
  final String exerciseId;
  final String? selectedAnswer;
  final bool isCorrect;
  final int? timeSpentSeconds;
  final DateTime createdAt;

  const ExerciseAttemptModel({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.selectedAnswer,
    required this.isCorrect,
    required this.timeSpentSeconds,
    required this.createdAt,
  });

  factory ExerciseAttemptModel.fromJson(Map<String, dynamic> json) {
    return ExerciseAttemptModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      exerciseId: json['exercise_id'] as String,
      selectedAnswer: json['selected_answer'] as String?,
      isCorrect: json['is_correct'] as bool,
      timeSpentSeconds: json['time_spent_seconds'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
