import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/achievement_models.dart';

class AchievementDatasource {
  final SupabaseClient _client;

  const AchievementDatasource(this._client);

  Future<List<AchievementModel>> fetchAchievements() async {
    final response = await _client
        .from('achievements')
        .select()
        .eq('is_active', true)
        .order('condition_value');

    return response.map(AchievementModel.fromJson).toList();
  }

  Future<List<UserAchievementModel>> fetchUserAchievements(
    String userId,
  ) async {
    final response = await _client
        .from('user_achievements')
        .select()
        .eq('user_id', userId)
        .order('unlocked_at', ascending: false);

    return response.map(UserAchievementModel.fromJson).toList();
  }

  Future<UserAchievementModel> unlockAchievement({
    required String userId,
    required String achievementId,
  }) async {
    final response = await _client
        .from('user_achievements')
        .upsert({
          'user_id': userId,
          'achievement_id': achievementId,
        }, onConflict: 'user_id,achievement_id')
        .select()
        .single();

    return UserAchievementModel.fromJson(response);
  }

  Future<AchievementProgressStats> fetchProgressStats(String userId) async {
    final profile = await _client
        .from('profiles')
        .select('total_xp,current_streak')
        .eq('id', userId)
        .single();

    final progressRows = await _client
        .from('user_lesson_progress')
        .select('lesson_id,completed,accuracy,correct_answers')
        .eq('user_id', userId)
        .eq('completed', true);

    final lessonRows = await _client
        .from('lessons')
        .select('id,unit_id,lesson_type');

    final attemptRows = await _client
        .from('user_exercise_attempts')
        .select('is_correct, exercises(exercise_type)')
        .eq('user_id', userId)
        .eq('is_correct', true);

    final completedLessonIds = {
      for (final row in progressRows) row['lesson_id'] as String,
    };
    final unitLessonCounts = <String, int>{};
    final completedUnitLessonCounts = <String, int>{};
    var mapLessonsCompleted = 0;

    for (final lesson in lessonRows) {
      final unitId = lesson['unit_id'] as String;
      unitLessonCounts[unitId] = (unitLessonCounts[unitId] ?? 0) + 1;

      if (completedLessonIds.contains(lesson['id'])) {
        completedUnitLessonCounts[unitId] =
            (completedUnitLessonCounts[unitId] ?? 0) + 1;
        if (lesson['lesson_type'] == 'map_practice') {
          mapLessonsCompleted += 1;
        }
      }
    }

    final unitsCompleted = unitLessonCounts.entries.where((entry) {
      return completedUnitLessonCounts[entry.key] == entry.value;
    }).length;

    var capitalQuestionsCorrect = 0;
    var mapTapCorrect = 0;
    for (final attempt in attemptRows) {
      final exercise = _parseJsonMap(attempt['exercises']);
      switch (exercise?['exercise_type']) {
        case 'multiple_choice_capital':
          capitalQuestionsCorrect += 1;
        case 'map_tap':
          mapTapCorrect += 1;
      }
    }

    return AchievementProgressStats(
      lessonsCompleted: progressRows.length,
      perfectLessons: progressRows
          .where((row) => ((row['accuracy'] as num?)?.toDouble() ?? 0) >= 100)
          .length,
      currentStreak: profile['current_streak'] as int? ?? 0,
      totalXp: profile['total_xp'] as int? ?? 0,
      mapLessonsCompleted: mapLessonsCompleted,
      unitsCompleted: unitsCompleted,
      capitalQuestionsCorrect: capitalQuestionsCorrect,
      mapTapCorrect: mapTapCorrect,
    );
  }

  Map<String, dynamic>? _parseJsonMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }
}
