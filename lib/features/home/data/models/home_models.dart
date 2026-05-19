import '../../../profile/data/models/profile_model.dart';
import '../../../lessons/data/models/lesson_models.dart';

class UnitWithLessons {
  final UnitModel unit;
  final List<LessonModel> lessons;

  const UnitWithLessons({required this.unit, required this.lessons});
}

enum HomeLessonStatus { locked, unlocked, current, completed }

class HomeLesson {
  final LessonModel lesson;
  final UnitModel unit;
  final HomeLessonStatus status;
  final UserLessonProgressModel? progress;

  const HomeLesson({
    required this.lesson,
    required this.unit,
    required this.status,
    required this.progress,
  });

  bool get isLocked => status == HomeLessonStatus.locked;
  bool get isCompleted => status == HomeLessonStatus.completed;
  bool get canOpen => !isLocked;
}

class HomeUnit {
  final UnitModel unit;
  final List<HomeLesson> lessons;

  const HomeUnit({required this.unit, required this.lessons});

  int get completedLessons {
    return lessons.where((lesson) => lesson.isCompleted).length;
  }

  int get totalLessons => lessons.length;
}

class HomeContent {
  final ProfileModel profile;
  final List<HomeUnit> units;
  final HomeUnit? currentUnit;
  final HomeLesson? currentLesson;

  const HomeContent({
    required this.profile,
    required this.units,
    required this.currentUnit,
    required this.currentLesson,
  });

  bool get isEmpty => units.isEmpty;
}
