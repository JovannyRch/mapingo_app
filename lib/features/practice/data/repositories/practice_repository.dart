import '../../../lessons/data/models/lesson_models.dart';
import '../../../lessons/data/repositories/lesson_repository.dart';
import '../models/practice_models.dart';

class PracticeRepository {
  final LessonRepository _lessonRepository;

  const PracticeRepository(this._lessonRepository);

  Future<PracticeExerciseSet> fetchPracticeExercises({
    required String userId,
    required PracticeMode mode,
  }) async {
    switch (mode) {
      case PracticeMode.mistakes:
        return _fetchMistakeExercises(userId);
      case PracticeMode.capitals:
        final exercises = await _lessonRepository.fetchExercisesByTypes([
          ExerciseType.multipleChoiceCapital,
        ], limit: 10);
        return PracticeExerciseSet(
          exercises: exercises,
          mistakeExerciseIds: {},
        );
      case PracticeMode.map:
        final exercises = await _lessonRepository.fetchExercisesByTypes([
          ExerciseType.mapTap,
        ], limit: 10);
        return PracticeExerciseSet(
          exercises: exercises,
          mistakeExerciseIds: {},
        );
      case PracticeMode.quickChallenge:
        final exercises = await _lessonRepository.fetchExercisesByTypes([
          ExerciseType.multipleChoiceState,
          ExerciseType.multipleChoiceCapital,
          ExerciseType.trueFalse,
          ExerciseType.mapTap,
          ExerciseType.matchPairs,
        ], limit: 10);
        return PracticeExerciseSet(
          exercises: exercises,
          mistakeExerciseIds: {},
        );
    }
  }

  Future<void> savePracticeAttempt({
    required String userId,
    required ExerciseAttemptInput attempt,
    required bool isMistakeReviewExercise,
  }) async {
    await _lessonRepository.saveExerciseAttempt(
      userId: userId,
      attempt: attempt,
    );

    if (attempt.isCorrect) {
      if (!isMistakeReviewExercise) return;

      await _lessonRepository.markMistakeResolved(
        userId: userId,
        exerciseId: attempt.exerciseId,
      );
      return;
    }

    await _lessonRepository.saveMistake(
      userId: userId,
      exerciseId: attempt.exerciseId,
    );
  }

  Future<PracticeExerciseSet> _fetchMistakeExercises(String userId) async {
    final mistakes = await _lessonRepository.fetchUserMistakes(userId);
    if (mistakes.isEmpty) {
      return const PracticeExerciseSet(exercises: [], mistakeExerciseIds: {});
    }

    final orderedIds = mistakes.map((mistake) => mistake.exerciseId).toList();
    final exercises = await _lessonRepository.fetchExercisesByIds(orderedIds);
    final exercisesById = {
      for (final exercise in exercises) exercise.id: exercise,
    };
    final orderedExercises = [
      for (final id in orderedIds)
        if (exercisesById[id] != null) exercisesById[id]!,
    ];

    return PracticeExerciseSet(
      exercises: orderedExercises.take(10).toList(),
      mistakeExerciseIds: orderedIds.toSet(),
    );
  }
}

class PracticeExerciseSet {
  final List<ExerciseModel> exercises;
  final Set<String> mistakeExerciseIds;

  const PracticeExerciseSet({
    required this.exercises,
    required this.mistakeExerciseIds,
  });
}
