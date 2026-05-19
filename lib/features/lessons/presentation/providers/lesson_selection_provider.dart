import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/lesson_models.dart';
import 'lesson_engine_state.dart';

final lessonSelectionProvider =
    NotifierProvider.family<
      LessonSelectionController,
      LessonSelectionState,
      String
    >(LessonSelectionController.new);

class LessonSelectionState {
  final String? selectedValue;
  final Map<String, String> selectedPairs;

  const LessonSelectionState({
    this.selectedValue,
    this.selectedPairs = const {},
  });

  LessonAnswer? answerFor(ExerciseModel exercise) {
    if (exercise.exerciseType == ExerciseType.matchPairs) {
      if (selectedPairs.length != exercise.metadata.pairs.length) return null;
      return LessonAnswer.pairs(selectedPairs);
    }

    final value = selectedValue;
    if (value == null) return null;
    return LessonAnswer.value(value);
  }

  LessonSelectionState copyWith({
    String? selectedValue,
    Map<String, String>? selectedPairs,
    bool clearValue = false,
  }) {
    return LessonSelectionState(
      selectedValue: clearValue ? null : selectedValue ?? this.selectedValue,
      selectedPairs: selectedPairs ?? this.selectedPairs,
    );
  }
}

class LessonSelectionController
    extends FamilyNotifier<LessonSelectionState, String> {
  @override
  LessonSelectionState build(String arg) {
    return const LessonSelectionState();
  }

  void selectValue(String value) {
    state = state.copyWith(selectedValue: value);
  }

  void selectPair({required String left, required String right}) {
    state = state.copyWith(
      selectedPairs: {...state.selectedPairs, left: right},
    );
  }

  void selectPairs(Map<String, String> pairs) {
    state = state.copyWith(selectedPairs: pairs);
  }

  void reset() {
    state = const LessonSelectionState();
  }
}
