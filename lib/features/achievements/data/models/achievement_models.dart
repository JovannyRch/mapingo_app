class AchievementModel {
  final String id;
  final String code;
  final String title;
  final String description;
  final String? icon;
  final int xpReward;
  final String conditionType;
  final int conditionValue;
  final bool isActive;

  const AchievementModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.icon,
    required this.xpReward,
    required this.conditionType,
    required this.conditionValue,
    required this.isActive,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String,
      code: json['code'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String?,
      xpReward: json['xp_reward'] as int? ?? 0,
      conditionType: json['condition_type'] as String,
      conditionValue: json['condition_value'] as int? ?? 1,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

class UserAchievementModel {
  final String id;
  final String userId;
  final String achievementId;
  final DateTime unlockedAt;

  const UserAchievementModel({
    required this.id,
    required this.userId,
    required this.achievementId,
    required this.unlockedAt,
  });

  factory UserAchievementModel.fromJson(Map<String, dynamic> json) {
    return UserAchievementModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      achievementId: json['achievement_id'] as String,
      unlockedAt: DateTime.parse(json['unlocked_at'] as String),
    );
  }
}

class AchievementProgressStats {
  final int lessonsCompleted;
  final int perfectLessons;
  final int currentStreak;
  final int totalXp;
  final int mapLessonsCompleted;
  final int unitsCompleted;
  final int capitalQuestionsCorrect;
  final int mapTapCorrect;

  const AchievementProgressStats({
    required this.lessonsCompleted,
    required this.perfectLessons,
    required this.currentStreak,
    required this.totalXp,
    required this.mapLessonsCompleted,
    required this.unitsCompleted,
    required this.capitalQuestionsCorrect,
    required this.mapTapCorrect,
  });

  int valueFor(String conditionType) {
    switch (conditionType) {
      case 'lessons_completed':
        return lessonsCompleted;
      case 'perfect_lessons':
        return perfectLessons;
      case 'streak_days':
      case 'daily_streak':
        return currentStreak;
      case 'total_xp':
      case 'xp_earned':
        return totalXp;
      case 'map_lessons_completed':
        return mapLessonsCompleted;
      case 'region_completed':
      case 'regions_completed':
      case 'units_completed':
        return unitsCompleted;
      case 'capital_questions_correct':
        return capitalQuestionsCorrect;
      case 'map_tap_correct':
        return mapTapCorrect;
      default:
        return 0;
    }
  }
}

class AchievementDisplayModel {
  final AchievementModel achievement;
  final UserAchievementModel? unlocked;
  final int progressValue;

  const AchievementDisplayModel({
    required this.achievement,
    required this.unlocked,
    required this.progressValue,
  });

  bool get isUnlocked => unlocked != null;
}

class AchievementsContent {
  final List<AchievementDisplayModel> achievements;
  final List<AchievementModel> newlyUnlocked;

  const AchievementsContent({
    required this.achievements,
    this.newlyUnlocked = const [],
  });

  int get unlockedCount {
    return achievements.where((item) => item.isUnlocked).length;
  }
}
