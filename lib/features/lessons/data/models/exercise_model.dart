enum ExerciseType {
  multipleChoiceState('multiple_choice_state'),
  multipleChoiceCapital('multiple_choice_capital'),
  mapTap('map_tap'),
  matchPairs('match_pairs'),
  trueFalse('true_false'),
  silhouette('silhouette'),
  unknown('unknown');

  final String value;

  const ExerciseType(this.value);

  static ExerciseType fromValue(String value) {
    return ExerciseType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ExerciseType.unknown,
    );
  }
}

class MatchPair {
  final String left;
  final String right;

  const MatchPair({required this.left, required this.right});

  factory MatchPair.fromJson(Map<String, dynamic> json) {
    return MatchPair(
      left: json['left'] as String,
      right: json['right'] as String,
    );
  }
}

class ExerciseMetadata {
  final String? targetStateKey;
  final String? state;
  final String? capital;
  final String? mapKey;
  final List<MatchPair> pairs;
  final Map<String, dynamic> raw;

  const ExerciseMetadata({
    required this.targetStateKey,
    required this.state,
    required this.capital,
    required this.mapKey,
    required this.pairs,
    required this.raw,
  });

  factory ExerciseMetadata.fromJson(Map<String, dynamic>? json) {
    final raw = json ?? const <String, dynamic>{};
    final pairValues = raw['pairs'];

    return ExerciseMetadata(
      targetStateKey: raw['targetStateKey'] as String?,
      state: raw['state'] as String?,
      capital: raw['capital'] as String?,
      mapKey: raw['mapKey'] as String?,
      pairs: pairValues is List
          ? pairValues
                .map(_parseJsonMap)
                .whereType<Map<String, dynamic>>()
                .map(MatchPair.fromJson)
                .toList()
          : const [],
      raw: raw,
    );
  }

  static Map<String, dynamic>? _parseJsonMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }
}

class ExerciseModel {
  final String id;
  final String lessonId;
  final ExerciseType exerciseType;
  final String question;
  final String correctAnswer;
  final List<String> options;
  final ExerciseMetadata metadata;
  final String? explanation;
  final int difficulty;
  final int orderIndex;
  final bool isActive;
  final DateTime createdAt;

  const ExerciseModel({
    required this.id,
    required this.lessonId,
    required this.exerciseType,
    required this.question,
    required this.correctAnswer,
    required this.options,
    required this.metadata,
    required this.explanation,
    required this.difficulty,
    required this.orderIndex,
    required this.isActive,
    required this.createdAt,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] as String,
      lessonId: json['lesson_id'] as String,
      exerciseType: ExerciseType.fromValue(json['exercise_type'] as String),
      question: json['question'] as String,
      correctAnswer: json['correct_answer'] as String,
      options: _parseStringList(json['options']),
      metadata: ExerciseMetadata.fromJson(_parseJsonMap(json['metadata'])),
      explanation: json['explanation'] as String?,
      difficulty: json['difficulty'] as int? ?? 1,
      orderIndex: json['order_index'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static List<String> _parseStringList(Object? value) {
    if (value is! List) return const [];
    return value.whereType<String>().toList();
  }

  static Map<String, dynamic>? _parseJsonMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }
}
