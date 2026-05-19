import '../../data/models/lesson_models.dart';

enum LessonEngineStatus {
  loading,
  ready,
  submittingAnswer,
  completing,
  completed,
  empty,
}

class LessonAnswer {
  final String? value;
  final Map<String, String>? pairs;

  const LessonAnswer._({this.value, this.pairs});

  const LessonAnswer.value(String value) : this._(value: value);

  const LessonAnswer.pairs(Map<String, String> pairs) : this._(pairs: pairs);

  String? get serialized {
    if (value != null) return value;
    if (pairs == null) return null;

    final entries = pairs!.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return entries.map((entry) => '${entry.key}:${entry.value}').join('|');
  }
}

class LessonAnswerResult {
  final String exerciseId;
  final bool isCorrect;
  final String correctAnswer;
  final String? selectedAnswer;
  final String? explanation;

  const LessonAnswerResult({
    required this.exerciseId,
    required this.isCorrect,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.explanation,
  });
}

class LessonEngineState {
  final LessonEngineStatus status;
  final String lessonId;
  final LessonModel? lesson;
  final List<ExerciseModel> exercises;
  final int currentExerciseIndex;
  final int correctAnswers;
  final int wrongAnswers;
  final int xpEarned;
  final bool currentExerciseAnswered;
  final LessonAnswerResult? lastAnswerResult;
  final UserLessonProgressModel? progress;

  const LessonEngineState({
    required this.status,
    required this.lessonId,
    required this.lesson,
    required this.exercises,
    required this.currentExerciseIndex,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.xpEarned,
    required this.currentExerciseAnswered,
    required this.lastAnswerResult,
    required this.progress,
  });

  factory LessonEngineState.loading(String lessonId) {
    return LessonEngineState(
      status: LessonEngineStatus.loading,
      lessonId: lessonId,
      lesson: null,
      exercises: const [],
      currentExerciseIndex: 0,
      correctAnswers: 0,
      wrongAnswers: 0,
      xpEarned: 0,
      currentExerciseAnswered: false,
      lastAnswerResult: null,
      progress: null,
    );
  }

  ExerciseModel? get currentExercise {
    if (exercises.isEmpty || currentExerciseIndex >= exercises.length) {
      return null;
    }
    return exercises[currentExerciseIndex];
  }

  int get answeredCount => correctAnswers + wrongAnswers;
  int get totalExercises => exercises.length;
  bool get isLastExercise => currentExerciseIndex == exercises.length - 1;
  bool get canComplete =>
      exercises.isNotEmpty && answeredCount >= exercises.length;

  double get accuracy {
    if (answeredCount == 0) return 0;
    return (correctAnswers / answeredCount) * 100;
  }

  LessonEngineState copyWith({
    LessonEngineStatus? status,
    LessonModel? lesson,
    List<ExerciseModel>? exercises,
    int? currentExerciseIndex,
    int? correctAnswers,
    int? wrongAnswers,
    int? xpEarned,
    bool? currentExerciseAnswered,
    LessonAnswerResult? lastAnswerResult,
    bool clearLastAnswerResult = false,
    UserLessonProgressModel? progress,
  }) {
    return LessonEngineState(
      status: status ?? this.status,
      lessonId: lessonId,
      lesson: lesson ?? this.lesson,
      exercises: exercises ?? this.exercises,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      xpEarned: xpEarned ?? this.xpEarned,
      currentExerciseAnswered:
          currentExerciseAnswered ?? this.currentExerciseAnswered,
      lastAnswerResult: clearLastAnswerResult
          ? null
          : lastAnswerResult ?? this.lastAnswerResult,
      progress: progress ?? this.progress,
    );
  }
}
