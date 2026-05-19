import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/lesson_models.dart';
import 'lesson_selection_provider.dart';

final matchPairsProvider =
    NotifierProvider.family<
      MatchPairsController,
      MatchPairsState,
      MatchPairsKey
    >(MatchPairsController.new);

class MatchPairsKey {
  final String lessonId;
  final String exerciseId;

  const MatchPairsKey({required this.lessonId, required this.exerciseId});

  @override
  bool operator ==(Object other) {
    return other is MatchPairsKey &&
        other.lessonId == lessonId &&
        other.exerciseId == exerciseId;
  }

  @override
  int get hashCode => Object.hash(lessonId, exerciseId);
}

class MatchPairsState {
  final String? selectedLeft;
  final Map<String, String> matchedPairs;
  final String? wrongLeft;
  final String? wrongRight;
  final bool submittedToEngine;

  const MatchPairsState({
    this.selectedLeft,
    this.matchedPairs = const {},
    this.wrongLeft,
    this.wrongRight,
    this.submittedToEngine = false,
  });

  bool isMatchedLeft(String left) => matchedPairs.containsKey(left);
  bool isMatchedRight(String right) => matchedPairs.containsValue(right);

  bool isWrongPair({required String left, required String right}) {
    return wrongLeft == left && wrongRight == right;
  }

  bool allPairsMatched(ExerciseModel exercise) {
    return matchedPairs.length == exercise.metadata.pairs.length;
  }

  MatchPairsState copyWith({
    String? selectedLeft,
    Map<String, String>? matchedPairs,
    String? wrongLeft,
    String? wrongRight,
    bool? submittedToEngine,
    bool clearSelectedLeft = false,
    bool clearWrongPair = false,
  }) {
    return MatchPairsState(
      selectedLeft: clearSelectedLeft
          ? null
          : selectedLeft ?? this.selectedLeft,
      matchedPairs: matchedPairs ?? this.matchedPairs,
      wrongLeft: clearWrongPair ? null : wrongLeft ?? this.wrongLeft,
      wrongRight: clearWrongPair ? null : wrongRight ?? this.wrongRight,
      submittedToEngine: submittedToEngine ?? this.submittedToEngine,
    );
  }
}

class MatchPairsController
    extends FamilyNotifier<MatchPairsState, MatchPairsKey> {
  @override
  MatchPairsState build(MatchPairsKey arg) {
    return const MatchPairsState();
  }

  void selectLeft(String left) {
    if (state.isMatchedLeft(left)) return;

    state = state.copyWith(selectedLeft: left, clearWrongPair: true);
  }

  void selectRight({required ExerciseModel exercise, required String right}) {
    final left = state.selectedLeft;
    if (left == null || state.isMatchedRight(right)) return;

    if (_isCorrectPair(exercise: exercise, left: left, right: right)) {
      final matchedPairs = {...state.matchedPairs, left: right};

      ref
          .read(lessonSelectionProvider(arg.lessonId).notifier)
          .selectPairs(matchedPairs);

      state = state.copyWith(
        matchedPairs: matchedPairs,
        clearSelectedLeft: true,
        clearWrongPair: true,
      );
      return;
    }

    state = state.copyWith(
      wrongLeft: left,
      wrongRight: right,
      clearSelectedLeft: true,
    );
  }

  void markSubmittedToEngine() {
    state = state.copyWith(submittedToEngine: true);
  }

  void reset() {
    state = const MatchPairsState();
  }

  bool _isCorrectPair({
    required ExerciseModel exercise,
    required String left,
    required String right,
  }) {
    for (final pair in exercise.metadata.pairs) {
      if (_same(pair.left, left) && _same(pair.right, right)) {
        return true;
      }
    }
    return false;
  }

  bool _same(String a, String b) {
    return a.trim().toLowerCase() == b.trim().toLowerCase();
  }
}
