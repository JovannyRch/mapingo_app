class DailyActivityModel {
  final String id;
  final String userId;
  final DateTime activityDate;
  final int xpEarned;
  final int lessonsCompleted;
  final int exercisesCompleted;
  final int minutesPracticed;
  final DateTime createdAt;

  const DailyActivityModel({
    required this.id,
    required this.userId,
    required this.activityDate,
    required this.xpEarned,
    required this.lessonsCompleted,
    required this.exercisesCompleted,
    required this.minutesPracticed,
    required this.createdAt,
  });

  factory DailyActivityModel.fromJson(Map<String, dynamic> json) {
    return DailyActivityModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      activityDate: DateTime.parse(json['activity_date'] as String),
      xpEarned: json['xp_earned'] as int? ?? 0,
      lessonsCompleted: json['lessons_completed'] as int? ?? 0,
      exercisesCompleted: json['exercises_completed'] as int? ?? 0,
      minutesPracticed: json['minutes_practiced'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
