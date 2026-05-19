import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../achievements/presentation/providers/achievement_providers.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../data/models/lesson_models.dart';
import '../../data/repositories/lesson_answer_validator.dart';
import 'lesson_providers.dart';

final lessonEngineProvider =
    AsyncNotifierProvider.family<
      LessonEngineController,
      LessonEngineState,
      String
    >(LessonEngineController.new);

class LessonEngineController
    extends FamilyAsyncNotifier<LessonEngineState, String> {
  @override
  Future<LessonEngineState> build(String lessonId) async {
    final repository = ref.read(lessonRepositoryProvider);
    final lesson = await repository.fetchLessonById(lessonId);
    final exercises = await repository.fetchExercisesByLesson(lessonId);

    if (exercises.isEmpty) {
      return LessonEngineState.loading(
        lessonId,
      ).copyWith(status: LessonEngineStatus.empty, lesson: lesson);
    }

    return LessonEngineState.loading(lessonId).copyWith(
      status: LessonEngineStatus.ready,
      lesson: lesson,
      exercises: exercises,
    );
  }

  Future<LessonAnswerResult> submitAnswer(
    LessonAnswer answer, {
    int? timeSpentSeconds,
  }) async {
    final currentState = state.valueOrNull;
    final exercise = currentState?.currentExercise;

    if (currentState == null || exercise == null) {
      throw StateError('No active exercise is loaded.');
    }

    if (currentState.currentExerciseAnswered) {
      throw StateError('The current exercise has already been answered.');
    }

    state = AsyncData(
      currentState.copyWith(status: LessonEngineStatus.submittingAnswer),
    );

    final session = await ref.read(startupAuthProvider.future);
    final repository = ref.read(lessonRepositoryProvider);
    const validator = LessonAnswerValidator();
    final isCorrect = _validateAnswer(exercise, answer);
    final answerResult = LessonAnswerResult(
      exerciseId: exercise.id,
      isCorrect: isCorrect,
      correctAnswer: validator.correctAnswerFor(exercise),
      selectedAnswer: answer.serialized,
      explanation: exercise.explanation,
    );

    await repository.saveExerciseAttempt(
      userId: session.user.id,
      attempt: ExerciseAttemptInput(
        exerciseId: exercise.id,
        selectedAnswer: answer.serialized,
        isCorrect: isCorrect,
        timeSpentSeconds: timeSpentSeconds,
      ),
    );

    if (!isCorrect) {
      await repository.saveMistake(
        userId: session.user.id,
        exerciseId: exercise.id,
      );
    }

    final updatedState = currentState.copyWith(
      status: LessonEngineStatus.ready,
      correctAnswers: currentState.correctAnswers + (isCorrect ? 1 : 0),
      wrongAnswers: currentState.wrongAnswers + (isCorrect ? 0 : 1),
      currentExerciseAnswered: true,
      lastAnswerResult: answerResult,
      xpEarned: _calculateXp(
        lesson: currentState.lesson,
        correctAnswers: currentState.correctAnswers + (isCorrect ? 1 : 0),
        totalExercises: currentState.totalExercises,
      ),
    );

    state = AsyncData(updatedState);
    return answerResult;
  }

  void goToNextExercise() {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.exercises.isEmpty) return;
    if (!currentState.currentExerciseAnswered || currentState.isLastExercise) {
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

  Future<UserLessonProgressModel> completeLesson() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.lesson == null) {
      throw StateError('No lesson is loaded.');
    }

    if (!currentState.canComplete) {
      throw StateError('All exercises must be answered before completion.');
    }

    state = AsyncData(
      currentState.copyWith(status: LessonEngineStatus.completing),
    );

    final session = await ref.read(startupAuthProvider.future);
    final repository = ref.read(lessonRepositoryProvider);
    final existingProgress = await repository.fetchUserLessonProgress(
      userId: session.user.id,
      lessonId: currentState.lessonId,
    );

    if (existingProgress?.completed == true) {
      state = AsyncData(
        currentState.copyWith(
          status: LessonEngineStatus.completed,
          xpEarned: existingProgress!.xpEarned,
          progress: existingProgress,
        ),
      );
      return existingProgress;
    }

    final xpEarned = _calculateXp(
      lesson: currentState.lesson,
      correctAnswers: currentState.correctAnswers,
      totalExercises: currentState.totalExercises,
    );

    final progress = await repository.saveLessonProgress(
      userId: session.user.id,
      progress: LessonProgressInput(
        lessonId: currentState.lessonId,
        completed: true,
        score: currentState.correctAnswers,
        accuracy: currentState.accuracy,
        correctAnswers: currentState.correctAnswers,
        wrongAnswers: currentState.wrongAnswers,
        xpEarned: xpEarned,
      ),
    );

    await repository.addUserXp(userId: session.user.id, xpEarned: xpEarned);

    await repository.updateDailyActivity(
      userId: session.user.id,
      xpEarned: xpEarned,
      exercisesCompleted: currentState.totalExercises,
      minutesPracticed: _estimateMinutesPracticed(currentState.totalExercises),
    );

    await ref
        .read(achievementUnlockControllerProvider.notifier)
        .checkAndUnlock();

    ref.invalidate(userProgressProvider);
    ref.invalidate(userLessonProgressProvider(currentState.lessonId));
    ref.invalidate(homeContentProvider);
    ref.invalidate(startupAuthProvider);

    state = AsyncData(
      currentState.copyWith(
        status: LessonEngineStatus.completed,
        xpEarned: xpEarned,
        progress: progress,
      ),
    );

    return progress;
  }

  bool _validateAnswer(ExerciseModel exercise, LessonAnswer answer) {
    return const LessonAnswerValidator().validate(exercise, answer);
  }

  int _calculateXp({
    required LessonModel? lesson,
    required int correctAnswers,
    required int totalExercises,
  }) {
    if (lesson == null || totalExercises == 0) return 0;

    final earned = lesson.xpReward * (correctAnswers / totalExercises);
    return earned.round().clamp(0, lesson.xpReward);
  }

  int _estimateMinutesPracticed(int exerciseCount) {
    return (exerciseCount / 3).ceil().clamp(1, 60);
  }
}
