import '../datasources/lesson_datasource.dart';
import '../models/lesson_models.dart';

class LessonRepository {
  final LessonDatasource _datasource;

  const LessonRepository(this._datasource);

  Future<List<UnitModel>> fetchUnits() {
    return _datasource.fetchUnits();
  }

  Future<List<LessonModel>> fetchLessons() {
    return _datasource.fetchLessons();
  }

  Future<LessonModel> fetchLessonById(String lessonId) {
    return _datasource.fetchLessonById(lessonId);
  }

  Future<List<LessonModel>> fetchLessonsByUnit(String unitId) {
    return _datasource.fetchLessonsByUnit(unitId);
  }

  Future<List<ExerciseModel>> fetchExercisesByLesson(String lessonId) {
    return _datasource.fetchExercisesByLesson(lessonId);
  }

  Future<List<ExerciseModel>> fetchExercisesByIds(List<String> exerciseIds) {
    return _datasource.fetchExercisesByIds(exerciseIds);
  }

  Future<List<ExerciseModel>> fetchExercisesByTypes(
    List<ExerciseType> exerciseTypes, {
    int limit = 10,
  }) {
    return _datasource.fetchExercisesByTypes(exerciseTypes, limit: limit);
  }

  Future<List<UserLessonProgressModel>> fetchUserProgress(String userId) {
    return _datasource.fetchUserProgress(userId);
  }

  Future<UserLessonProgressModel?> fetchUserLessonProgress({
    required String userId,
    required String lessonId,
  }) {
    return _datasource.fetchUserLessonProgress(
      userId: userId,
      lessonId: lessonId,
    );
  }

  Future<UserLessonProgressModel> saveLessonProgress({
    required String userId,
    required LessonProgressInput progress,
  }) {
    final normalizedProgress = LessonProgressInput(
      lessonId: progress.lessonId,
      completed: progress.completed,
      score: progress.score.clamp(0, 1000000),
      accuracy: progress.accuracy.clamp(0, 100),
      correctAnswers: progress.correctAnswers.clamp(0, 1000000),
      wrongAnswers: progress.wrongAnswers.clamp(0, 1000000),
      xpEarned: progress.xpEarned.clamp(0, 1000000),
    );

    return _datasource.saveLessonProgress(
      userId: userId,
      progress: normalizedProgress,
    );
  }

  Future<ExerciseAttemptModel> saveExerciseAttempt({
    required String userId,
    required ExerciseAttemptInput attempt,
  }) {
    return _datasource.saveExerciseAttempt(userId: userId, attempt: attempt);
  }

  Future<UserMistakeModel> saveMistake({
    required String userId,
    required String exerciseId,
  }) async {
    final existingMistake = await _datasource.fetchMistake(
      userId: userId,
      exerciseId: exerciseId,
    );

    return _datasource.upsertMistake(
      userId: userId,
      exerciseId: exerciseId,
      mistakeCount: (existingMistake?.mistakeCount ?? 0) + 1,
    );
  }

  Future<List<UserMistakeModel>> fetchUserMistakes(String userId) {
    return _datasource.fetchUserMistakes(userId);
  }

  Future<UserMistakeModel?> markMistakeResolved({
    required String userId,
    required String exerciseId,
  }) {
    return _datasource.markMistakeResolved(
      userId: userId,
      exerciseId: exerciseId,
    );
  }

  Future<void> addUserXp({required String userId, required int xpEarned}) {
    if (xpEarned <= 0) return Future.value();

    return _datasource.incrementUserXp(userId: userId, xpEarned: xpEarned);
  }

  Future<DailyActivityModel> updateDailyActivity({
    required String userId,
    required int xpEarned,
    required int exercisesCompleted,
    required int minutesPracticed,
    int lessonsCompleted = 1,
  }) async {
    final today = DateTime.now();
    final existingActivity = await _datasource.fetchDailyActivity(
      userId: userId,
      activityDate: today,
    );

    final activity = await _datasource.upsertDailyActivity(
      userId: userId,
      activityDate: today,
      xpEarned: (existingActivity?.xpEarned ?? 0) + xpEarned,
      lessonsCompleted:
          (existingActivity?.lessonsCompleted ?? 0) + lessonsCompleted,
      exercisesCompleted:
          (existingActivity?.exercisesCompleted ?? 0) + exercisesCompleted,
      minutesPracticed:
          (existingActivity?.minutesPracticed ?? 0) + minutesPracticed,
    );

    if (lessonsCompleted > 0) {
      await _datasource.updateProfileStreakAfterLesson(
        userId: userId,
        activityDate: today,
      );
    }

    return activity;
  }
}
