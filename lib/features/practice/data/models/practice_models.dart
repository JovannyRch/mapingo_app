import '../../../lessons/data/models/lesson_models.dart';
import '../../../lessons/presentation/providers/lesson_engine_state.dart';

enum PracticeMode {
  mistakes,
  capitals,
  map,
  quickChallenge;

  String get title {
    switch (this) {
      case PracticeMode.mistakes:
        return 'Review mistakes';
      case PracticeMode.capitals:
        return 'Practice capitals';
      case PracticeMode.map:
        return 'Practice map';
      case PracticeMode.quickChallenge:
        return 'Quick challenge';
    }
  }
}

enum PracticeSessionStatus {
  choosingMode,
  loading,
  ready,
  submittingAnswer,
  completed,
  empty,
}

class PracticeSessionState {
  final PracticeSessionStatus status;
  final PracticeMode? mode;
  final List<ExerciseModel> exercises;
  final Set<String> mistakeExerciseIds;
  final int currentExerciseIndex;
  final int correctAnswers;
  final int wrongAnswers;
  final bool currentExerciseAnswered;
  final LessonAnswerResult? lastAnswerResult;

  const PracticeSessionState({
    required this.status,
    required this.mode,
    required this.exercises,
    required this.mistakeExerciseIds,
    required this.currentExerciseIndex,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.currentExerciseAnswered,
    required this.lastAnswerResult,
  });

  factory PracticeSessionState.initial() {
    return const PracticeSessionState(
      status: PracticeSessionStatus.choosingMode,
      mode: null,
      exercises: [],
      mistakeExerciseIds: {},
      currentExerciseIndex: 0,
      correctAnswers: 0,
      wrongAnswers: 0,
      currentExerciseAnswered: false,
      lastAnswerResult: null,
    );
  }

  ExerciseModel? get currentExercise {
    if (exercises.isEmpty || currentExerciseIndex >= exercises.length) {
      return null;
    }
    return exercises[currentExerciseIndex];
  }

  int get totalExercises => exercises.length;
  bool get isLastExercise => currentExerciseIndex == exercises.length - 1;

  PracticeSessionState copyWith({
    PracticeSessionStatus? status,
    PracticeMode? mode,
    List<ExerciseModel>? exercises,
    Set<String>? mistakeExerciseIds,
    int? currentExerciseIndex,
    int? correctAnswers,
    int? wrongAnswers,
    bool? currentExerciseAnswered,
    LessonAnswerResult? lastAnswerResult,
    bool clearLastAnswerResult = false,
  }) {
    return PracticeSessionState(
      status: status ?? this.status,
      mode: mode ?? this.mode,
      exercises: exercises ?? this.exercises,
      mistakeExerciseIds: mistakeExerciseIds ?? this.mistakeExerciseIds,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      currentExerciseAnswered:
          currentExerciseAnswered ?? this.currentExerciseAnswered,
      lastAnswerResult: clearLastAnswerResult
          ? null
          : lastAnswerResult ?? this.lastAnswerResult,
    );
  }
}
