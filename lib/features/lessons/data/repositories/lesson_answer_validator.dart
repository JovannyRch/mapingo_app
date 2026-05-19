import '../../presentation/providers/lesson_engine_state.dart';
import '../models/lesson_models.dart';

class LessonAnswerValidator {
  const LessonAnswerValidator();

  bool validate(ExerciseModel exercise, LessonAnswer answer) {
    switch (exercise.exerciseType) {
      case ExerciseType.multipleChoiceState:
      case ExerciseType.multipleChoiceCapital:
      case ExerciseType.trueFalse:
      case ExerciseType.mapTap:
        return _normalize(answer.value) == _normalize(exercise.correctAnswer);
      case ExerciseType.matchPairs:
        return _validatePairs(exercise, answer.pairs);
      case ExerciseType.silhouette:
      case ExerciseType.unknown:
        return false;
    }
  }

  String correctAnswerFor(ExerciseModel exercise) {
    if (exercise.exerciseType != ExerciseType.matchPairs) {
      return exercise.correctAnswer;
    }

    return exercise.metadata.pairs
        .map((pair) => '${pair.left}:${pair.right}')
        .join('|');
  }

  bool _validatePairs(
    ExerciseModel exercise,
    Map<String, String>? selectedPairs,
  ) {
    if (selectedPairs == null || selectedPairs.isEmpty) return false;

    final expectedPairs = {
      for (final pair in exercise.metadata.pairs)
        _normalize(pair.left): _normalize(pair.right),
    };

    if (expectedPairs.length != selectedPairs.length) return false;

    for (final entry in selectedPairs.entries) {
      if (expectedPairs[_normalize(entry.key)] != _normalize(entry.value)) {
        return false;
      }
    }

    return true;
  }

  String _normalize(String? value) {
    return (value ?? '').trim().toLowerCase();
  }
}
