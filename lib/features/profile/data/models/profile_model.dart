class ProfileModel {
  final String id;
  final String? username;
  final String? avatarUrl;
  final int totalXp;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;
  final bool onboardingCompleted;
  final int dailyGoalMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileModel({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.totalXp,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastActivityDate,
    required this.onboardingCompleted,
    required this.dailyGoalMinutes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      username: json['username'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      totalXp: json['total_xp'] as int? ?? 0,
      currentStreak: json['current_streak'] as int? ?? 0,
      longestStreak: json['longest_streak'] as int? ?? 0,
      lastActivityDate: _parseOptionalDate(json['last_activity_date']),
      onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
      dailyGoalMinutes: json['daily_goal_minutes'] as int? ?? 5,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar_url': avatarUrl,
      'total_xp': totalXp,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'last_activity_date': lastActivityDate?.toIso8601String(),
      'onboarding_completed': onboardingCompleted,
      'daily_goal_minutes': dailyGoalMinutes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ProfileModel copyWith({
    String? username,
    String? avatarUrl,
    int? totalXp,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActivityDate,
    bool? onboardingCompleted,
    int? dailyGoalMinutes,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalXp: totalXp ?? this.totalXp,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _parseOptionalDate(Object? value) {
    if (value == null) return null;
    return DateTime.tryParse(value as String);
  }
}
