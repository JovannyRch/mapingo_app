class LessonProgressInput {
  final String lessonId;
  final bool completed;
  final int score;
  final double accuracy;
  final int correctAnswers;
  final int wrongAnswers;
  final int xpEarned;

  const LessonProgressInput({
    required this.lessonId,
    required this.completed,
    required this.score,
    required this.accuracy,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.xpEarned,
  });
}
