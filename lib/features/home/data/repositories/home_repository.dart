import '../../../lessons/data/models/lesson_models.dart';
import '../../../profile/data/models/profile_model.dart';
import '../../../lessons/data/repositories/lesson_repository.dart';
import '../models/home_models.dart';

class HomeRepository {
  final LessonRepository _lessonRepository;

  const HomeRepository(this._lessonRepository);

  Future<HomeContent> fetchHomeContent({
    required String userId,
    required ProfileModel profile,
  }) async {
    final units = await _lessonRepository.fetchUnits();
    final lessons = await _lessonRepository.fetchLessons();
    final progress = await _lessonRepository.fetchUserProgress(userId);

    final unitIds = units.map((unit) => unit.id).toSet();
    final lessonsByUnit = <String, List<LessonModel>>{};
    for (final lesson in lessons.where(
      (lesson) => unitIds.contains(lesson.unitId),
    )) {
      lessonsByUnit.putIfAbsent(lesson.unitId, () => []).add(lesson);
    }

    for (final unitLessons in lessonsByUnit.values) {
      unitLessons.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    }

    final progressByLesson = {for (final item in progress) item.lessonId: item};
    final completedLessonIds = progressByLesson.entries
        .where((entry) => entry.value.completed)
        .map((entry) => entry.key)
        .toSet();

    final orderedLessons = <LessonModel>[];
    for (final unit in units) {
      orderedLessons.addAll(lessonsByUnit[unit.id] ?? const []);
    }

    final currentLessonId = _findCurrentLessonId(
      orderedLessons: orderedLessons,
      completedLessonIds: completedLessonIds,
    );

    final homeUnits = units.map((unit) {
      final homeLessons = (lessonsByUnit[unit.id] ?? const <LessonModel>[]).map(
        (lesson) {
          return HomeLesson(
            lesson: lesson,
            unit: unit,
            status: _resolveStatus(
              lesson: lesson,
              currentLessonId: currentLessonId,
              completedLessonIds: completedLessonIds,
            ),
            progress: progressByLesson[lesson.id],
          );
        },
      ).toList();

      return HomeUnit(unit: unit, lessons: homeLessons);
    }).toList();

    HomeLesson? currentLesson;
    HomeUnit? currentUnit;
    for (final unit in homeUnits) {
      for (final lesson in unit.lessons) {
        if (lesson.status == HomeLessonStatus.current) {
          currentLesson = lesson;
          currentUnit = unit;
          break;
        }
      }
      if (currentLesson != null) break;
    }

    return HomeContent(
      profile: profile,
      units: homeUnits,
      currentUnit: currentUnit,
      currentLesson: currentLesson,
    );
  }

  String? _findCurrentLessonId({
    required List<LessonModel> orderedLessons,
    required Set<String> completedLessonIds,
  }) {
    for (final lesson in orderedLessons) {
      if (!completedLessonIds.contains(lesson.id)) {
        return lesson.id;
      }
    }
    return null;
  }

  HomeLessonStatus _resolveStatus({
    required LessonModel lesson,
    required String? currentLessonId,
    required Set<String> completedLessonIds,
  }) {
    if (completedLessonIds.contains(lesson.id)) {
      return HomeLessonStatus.completed;
    }

    if (lesson.id == currentLessonId) {
      return HomeLessonStatus.current;
    }

    return HomeLessonStatus.locked;
  }
}
