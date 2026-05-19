import '../datasources/profile_datasource.dart';
import '../models/profile_model.dart';
import '../models/profile_stats_model.dart';

class ProfileRepository {
  final ProfileDatasource _datasource;

  const ProfileRepository(this._datasource);

  Future<ProfileModel> getOrCreateProfile(String userId) async {
    final existingProfile = await _datasource.fetchProfile(userId);
    if (existingProfile != null) return existingProfile;

    return _datasource.createProfile(userId: userId);
  }

  Future<ProfileModel> completeOnboarding(String userId) {
    return _datasource.updateOnboardingCompleted(
      userId: userId,
      completed: true,
    );
  }

  Future<ProfileModel> saveOnboarding({
    required String userId,
    required String username,
    required int dailyGoalMinutes,
  }) {
    final cleanUsername = username.trim().isEmpty
        ? 'Explorer'
        : username.trim();

    return _datasource.updateOnboardingProfile(
      userId: userId,
      username: cleanUsername,
      dailyGoalMinutes: dailyGoalMinutes,
      onboardingCompleted: true,
    );
  }

  Future<ProfileModel> updateUsername({
    required String userId,
    required String username,
  }) {
    final cleanUsername = username.trim().isEmpty
        ? 'Explorer'
        : username.trim();

    return _datasource.updateUsername(userId: userId, username: cleanUsername);
  }

  Future<ProfileModel> updateDailyGoal({
    required String userId,
    required int dailyGoalMinutes,
  }) {
    final cleanGoal = dailyGoalMinutes.clamp(1, 60);

    return _datasource.updateDailyGoal(
      userId: userId,
      dailyGoalMinutes: cleanGoal,
    );
  }

  Future<ProfileStatsModel> fetchStats(String userId) {
    return _datasource.fetchStats(userId);
  }
}
