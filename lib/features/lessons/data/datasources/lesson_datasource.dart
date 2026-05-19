import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/lesson_models.dart';

class LessonDatasource {
  final SupabaseClient _client;

  const LessonDatasource(this._client);

  Future<List<UnitModel>> fetchUnits() async {
    final response = await _client
        .from('units')
        .select()
        .eq('is_active', true)
        .order('order_index');

    return response.map(UnitModel.fromJson).toList();
  }

  Future<List<LessonModel>> fetchLessonsByUnit(String unitId) async {
    final response = await _client
        .from('lessons')
        .select()
        .eq('unit_id', unitId)
        .eq('is_active', true)
        .order('order_index');

    return response.map(LessonModel.fromJson).toList();
  }

  Future<List<LessonModel>> fetchLessons() async {
    final response = await _client
        .from('lessons')
        .select()
        .eq('is_active', true)
        .order('unit_id')
        .order('order_index');

    return response.map(LessonModel.fromJson).toList();
  }

  Future<LessonModel> fetchLessonById(String lessonId) async {
    final response = await _client
        .from('lessons')
        .select()
        .eq('id', lessonId)
        .single();

    return LessonModel.fromJson(response);
  }

  Future<List<ExerciseModel>> fetchExercisesByLesson(String lessonId) async {
    final response = await _client
        .from('exercises')
        .select()
        .eq('lesson_id', lessonId)
        .eq('is_active', true)
        .order('order_index');

    return response.map(ExerciseModel.fromJson).toList();
  }

  Future<List<ExerciseModel>> fetchExercisesByIds(
    List<String> exerciseIds,
  ) async {
    if (exerciseIds.isEmpty) return const [];

    final response = await _client
        .from('exercises')
        .select()
        .inFilter('id', exerciseIds)
        .eq('is_active', true);

    return response.map(ExerciseModel.fromJson).toList();
  }

  Future<List<ExerciseModel>> fetchExercisesByTypes(
    List<ExerciseType> exerciseTypes, {
    int limit = 10,
  }) async {
    final response = await _client
        .from('exercises')
        .select()
        .inFilter(
          'exercise_type',
          exerciseTypes.map((type) => type.value).toList(),
        )
        .eq('is_active', true)
        .limit(limit);

    return response.map(ExerciseModel.fromJson).toList();
  }

  Future<List<UserLessonProgressModel>> fetchUserProgress(String userId) async {
    final response = await _client
        .from('user_lesson_progress')
        .select()
        .eq('user_id', userId);

    return response.map(UserLessonProgressModel.fromJson).toList();
  }

  Future<UserLessonProgressModel?> fetchUserLessonProgress({
    required String userId,
    required String lessonId,
  }) async {
    final response = await _client
        .from('user_lesson_progress')
        .select()
        .eq('user_id', userId)
        .eq('lesson_id', lessonId)
        .maybeSingle();

    if (response == null) return null;
    return UserLessonProgressModel.fromJson(response);
  }

  Future<UserLessonProgressModel> saveLessonProgress({
    required String userId,
    required LessonProgressInput progress,
  }) async {
    final response = await _client
        .from('user_lesson_progress')
        .upsert({
          'user_id': userId,
          'lesson_id': progress.lessonId,
          'completed': progress.completed,
          'score': progress.score,
          'accuracy': progress.accuracy,
          'correct_answers': progress.correctAnswers,
          'wrong_answers': progress.wrongAnswers,
          'xp_earned': progress.xpEarned,
          'completed_at': progress.completed
              ? DateTime.now().toUtc().toIso8601String()
              : null,
        }, onConflict: 'user_id,lesson_id')
        .select()
        .single();

    return UserLessonProgressModel.fromJson(response);
  }

  Future<ExerciseAttemptModel> saveExerciseAttempt({
    required String userId,
    required ExerciseAttemptInput attempt,
  }) async {
    final response = await _client
        .from('user_exercise_attempts')
        .insert({
          'user_id': userId,
          'exercise_id': attempt.exerciseId,
          'selected_answer': attempt.selectedAnswer,
          'is_correct': attempt.isCorrect,
          'time_spent_seconds': attempt.timeSpentSeconds,
        })
        .select()
        .single();

    return ExerciseAttemptModel.fromJson(response);
  }

  Future<UserMistakeModel?> fetchMistake({
    required String userId,
    required String exerciseId,
  }) async {
    final response = await _client
        .from('user_mistakes')
        .select()
        .eq('user_id', userId)
        .eq('exercise_id', exerciseId)
        .maybeSingle();

    if (response == null) return null;
    return UserMistakeModel.fromJson(response);
  }

  Future<List<UserMistakeModel>> fetchUserMistakes(String userId) async {
    final response = await _client
        .from('user_mistakes')
        .select()
        .eq('user_id', userId)
        .eq('resolved', false)
        .order('mistake_count', ascending: false)
        .order('last_wrong_at', ascending: false);

    return response.map(UserMistakeModel.fromJson).toList();
  }

  Future<UserMistakeModel> upsertMistake({
    required String userId,
    required String exerciseId,
    required int mistakeCount,
  }) async {
    final response = await _client
        .from('user_mistakes')
        .upsert({
          'user_id': userId,
          'exercise_id': exerciseId,
          'mistake_count': mistakeCount,
          'last_wrong_at': DateTime.now().toUtc().toIso8601String(),
          'resolved': false,
        }, onConflict: 'user_id,exercise_id')
        .select()
        .single();

    return UserMistakeModel.fromJson(response);
  }

  Future<UserMistakeModel?> markMistakeResolved({
    required String userId,
    required String exerciseId,
  }) async {
    final response = await _client
        .from('user_mistakes')
        .update({
          'resolved': true,
          'last_reviewed_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('user_id', userId)
        .eq('exercise_id', exerciseId)
        .select()
        .maybeSingle();

    if (response == null) return null;
    return UserMistakeModel.fromJson(response);
  }

  Future<void> incrementUserXp({
    required String userId,
    required int xpEarned,
  }) async {
    final profile = await _client
        .from('profiles')
        .select('total_xp')
        .eq('id', userId)
        .single();

    final currentXp = profile['total_xp'] as int? ?? 0;

    await _client
        .from('profiles')
        .update({'total_xp': currentXp + xpEarned})
        .eq('id', userId);
  }

  Future<void> updateProfileStreakAfterLesson({
    required String userId,
    required DateTime activityDate,
  }) async {
    final profile = await _client
        .from('profiles')
        .select('current_streak,longest_streak,last_activity_date')
        .eq('id', userId)
        .single();

    final today = _dateOnly(activityDate);
    final yesterday = _dateOnly(activityDate.subtract(const Duration(days: 1)));
    final lastActivityDate = profile['last_activity_date'] as String?;
    final currentStreak = profile['current_streak'] as int? ?? 0;
    final longestStreak = profile['longest_streak'] as int? ?? 0;

    final nextStreak = switch (lastActivityDate) {
      String date when date == today => currentStreak == 0 ? 1 : currentStreak,
      String date when date == yesterday => currentStreak + 1,
      _ => 1,
    };

    await _client
        .from('profiles')
        .update({
          'current_streak': nextStreak,
          'longest_streak': nextStreak > longestStreak
              ? nextStreak
              : longestStreak,
          'last_activity_date': today,
        })
        .eq('id', userId);
  }

  Future<DailyActivityModel?> fetchDailyActivity({
    required String userId,
    required DateTime activityDate,
  }) async {
    final response = await _client
        .from('user_daily_activity')
        .select()
        .eq('user_id', userId)
        .eq('activity_date', _dateOnly(activityDate))
        .maybeSingle();

    if (response == null) return null;
    return DailyActivityModel.fromJson(response);
  }

  Future<DailyActivityModel> upsertDailyActivity({
    required String userId,
    required DateTime activityDate,
    required int xpEarned,
    required int lessonsCompleted,
    required int exercisesCompleted,
    required int minutesPracticed,
  }) async {
    final response = await _client
        .from('user_daily_activity')
        .upsert({
          'user_id': userId,
          'activity_date': _dateOnly(activityDate),
          'xp_earned': xpEarned,
          'lessons_completed': lessonsCompleted,
          'exercises_completed': exercisesCompleted,
          'minutes_practiced': minutesPracticed,
        }, onConflict: 'user_id,activity_date')
        .select()
        .single();

    return DailyActivityModel.fromJson(response);
  }

  String _dateOnly(DateTime date) {
    final localDate = date.toLocal();
    final month = localDate.month.toString().padLeft(2, '0');
    final day = localDate.day.toString().padLeft(2, '0');
    return '${localDate.year}-$month-$day';
  }
}
