class ProfileStatsModel {
  final int completedLessons;
  final double accuracyPercentage;

  const ProfileStatsModel({
    required this.completedLessons,
    required this.accuracyPercentage,
  });

  String get accuracyLabel => '${accuracyPercentage.round()}%';
}
