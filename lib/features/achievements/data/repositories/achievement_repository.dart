import '../datasources/achievement_datasource.dart';
import '../models/achievement_models.dart';

class AchievementRepository {
  final AchievementDatasource _datasource;

  const AchievementRepository(this._datasource);

  Future<AchievementsContent> fetchAchievementsContent(String userId) async {
    final achievements = await _datasource.fetchAchievements();
    final unlocked = await _datasource.fetchUserAchievements(userId);
    final stats = await _datasource.fetchProgressStats(userId);

    return AchievementsContent(
      achievements: _buildDisplayModels(
        achievements: achievements,
        unlocked: unlocked,
        stats: stats,
      ),
    );
  }

  Future<List<AchievementModel>> checkAndUnlock(String userId) async {
    final achievements = await _datasource.fetchAchievements();
    final unlocked = await _datasource.fetchUserAchievements(userId);
    final stats = await _datasource.fetchProgressStats(userId);
    final unlockedIds = unlocked.map((item) => item.achievementId).toSet();
    final newlyUnlocked = <AchievementModel>[];

    for (final achievement in achievements) {
      if (unlockedIds.contains(achievement.id)) continue;

      final progress = stats.valueFor(achievement.conditionType);
      if (progress >= achievement.conditionValue) {
        await _datasource.unlockAchievement(
          userId: userId,
          achievementId: achievement.id,
        );
        newlyUnlocked.add(achievement);
      }
    }

    return newlyUnlocked;
  }

  List<AchievementDisplayModel> _buildDisplayModels({
    required List<AchievementModel> achievements,
    required List<UserAchievementModel> unlocked,
    required AchievementProgressStats stats,
  }) {
    final unlockedByAchievementId = {
      for (final item in unlocked) item.achievementId: item,
    };

    return achievements.map((achievement) {
      return AchievementDisplayModel(
        achievement: achievement,
        unlocked: unlockedByAchievementId[achievement.id],
        progressValue: stats.valueFor(achievement.conditionType),
      );
    }).toList();
  }
}
