import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_model.dart';
import '../models/profile_stats_model.dart';

class ProfileDatasource {
  final SupabaseClient _client;

  const ProfileDatasource(this._client);

  Future<ProfileModel?> fetchProfile(String userId) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> createProfile({
    required String userId,
    String username = 'Explorer',
  }) async {
    final response = await _client
        .from('profiles')
        .upsert({'id': userId, 'username': username})
        .select()
        .single();

    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> updateOnboardingCompleted({
    required String userId,
    required bool completed,
  }) async {
    final response = await _client
        .from('profiles')
        .update({'onboarding_completed': completed})
        .eq('id', userId)
        .select()
        .single();

    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> updateOnboardingProfile({
    required String userId,
    required String username,
    required int dailyGoalMinutes,
    required bool onboardingCompleted,
  }) async {
    final response = await _client
        .from('profiles')
        .update({
          'username': username,
          'daily_goal_minutes': dailyGoalMinutes,
          'onboarding_completed': onboardingCompleted,
        })
        .eq('id', userId)
        .select()
        .single();

    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> updateUsername({
    required String userId,
    required String username,
  }) async {
    final response = await _client
        .from('profiles')
        .update({'username': username})
        .eq('id', userId)
        .select()
        .single();

    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> updateDailyGoal({
    required String userId,
    required int dailyGoalMinutes,
  }) async {
    final response = await _client
        .from('profiles')
        .update({'daily_goal_minutes': dailyGoalMinutes})
        .eq('id', userId)
        .select()
        .single();

    return ProfileModel.fromJson(response);
  }

  Future<ProfileStatsModel> fetchStats(String userId) async {
    final response = await _client
        .from('user_lesson_progress')
        .select('accuracy')
        .eq('user_id', userId)
        .eq('completed', true);

    final completedLessons = response.length;
    if (completedLessons == 0) {
      return const ProfileStatsModel(
        completedLessons: 0,
        accuracyPercentage: 0,
      );
    }

    final accuracyTotal = response.fold<double>(0, (total, row) {
      return total + ((row['accuracy'] as num?)?.toDouble() ?? 0);
    });

    return ProfileStatsModel(
      completedLessons: completedLessons,
      accuracyPercentage: accuracyTotal / completedLessons,
    );
  }
}
