import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../lessons/data/models/lesson_models.dart';
import '../../../lessons/data/repositories/lesson_answer_validator.dart';
import '../../../lessons/presentation/providers/lesson_providers.dart';
import '../../data/models/practice_models.dart';
import '../../data/repositories/practice_repository.dart';

final practiceRepositoryProvider = Provider<PracticeRepository>((ref) {
  return PracticeRepository(ref.watch(lessonRepositoryProvider));
});

final practiceControllerProvider =
    AsyncNotifierProvider<PracticeController, PracticeSessionState>(
      PracticeController.new,
    );

class PracticeController extends AsyncNotifier<PracticeSessionState> {
  @override
  Future<PracticeSessionState> build() async {
    return PracticeSessionState.initial();
  }

  Future<void> startMode(PracticeMode mode) async {
    state = AsyncData(
      PracticeSessionState.initial().copyWith(
        status: PracticeSessionStatus.loading,
        mode: mode,
      ),
    );

    state = await AsyncValue.guard(() async {
      final session = await ref.read(startupAuthProvider.future);
      final exerciseSet = await ref
          .read(practiceRepositoryProvider)
          .fetchPracticeExercises(userId: session.user.id, mode: mode);

      return PracticeSessionState.initial().copyWith(
        status: exerciseSet.exercises.isEmpty
            ? PracticeSessionStatus.empty
            : PracticeSessionStatus.ready,
        mode: mode,
        exercises: exerciseSet.exercises,
        mistakeExerciseIds: exerciseSet.mistakeExerciseIds,
      );
    });
  }

  Future<LessonAnswerResult> submitAnswer(LessonAnswer answer) async {
    final currentState = state.valueOrNull;
    final exercise = currentState?.currentExercise;

    if (currentState == null || exercise == null) {
      throw StateError('No active practice exercise is loaded.');
    }
    if (currentState.currentExerciseAnswered) {
      throw StateError('The current exercise has already been answered.');
    }

    state = AsyncData(
      currentState.copyWith(status: PracticeSessionStatus.submittingAnswer),
    );

    const validator = LessonAnswerValidator();
    final isCorrect = validator.validate(exercise, answer);
    final result = LessonAnswerResult(
      exerciseId: exercise.id,
      isCorrect: isCorrect,
      correctAnswer: validator.correctAnswerFor(exercise),
      selectedAnswer: answer.serialized,
      explanation: exercise.explanation,
    );

    final session = await ref.read(startupAuthProvider.future);
    await ref
        .read(practiceRepositoryProvider)
        .savePracticeAttempt(
          userId: session.user.id,
          attempt: ExerciseAttemptInput(
            exerciseId: exercise.id,
            selectedAnswer: answer.serialized,
            isCorrect: isCorrect,
          ),
          isMistakeReviewExercise: currentState.mistakeExerciseIds.contains(
            exercise.id,
          ),
        );

    state = AsyncData(
      currentState.copyWith(
        status: PracticeSessionStatus.ready,
        correctAnswers: currentState.correctAnswers + (isCorrect ? 1 : 0),
        wrongAnswers: currentState.wrongAnswers + (isCorrect ? 0 : 1),
        currentExerciseAnswered: true,
        lastAnswerResult: result,
      ),
    );

    return result;
  }

  void nextExercise() {
    final currentState = state.valueOrNull;
    if (currentState == null || !currentState.currentExerciseAnswered) return;

    if (currentState.isLastExercise) {
      state = AsyncData(
        currentState.copyWith(status: PracticeSessionStatus.completed),
      );
      return;
    }

    state = AsyncData(
      currentState.copyWith(
        currentExerciseIndex: currentState.currentExerciseIndex + 1,
        currentExerciseAnswered: false,
        clearLastAnswerResult: true,
      ),
    );
  }

  void reset() {
    state = AsyncData(PracticeSessionState.initial());
  }
}
