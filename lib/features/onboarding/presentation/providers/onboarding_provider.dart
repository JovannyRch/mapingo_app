import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';

final onboardingFlowProvider =
    NotifierProvider<OnboardingFlowNotifier, OnboardingFlowState>(
      OnboardingFlowNotifier.new,
    );

class OnboardingFlowState {
  final int stepIndex;
  final int dailyGoalMinutes;
  final String username;
  final AsyncValue<void> submission;

  const OnboardingFlowState({
    this.stepIndex = 0,
    this.dailyGoalMinutes = 5,
    this.username = '',
    this.submission = const AsyncData(null),
  });

  static const int totalSteps = 5;

  bool get isFirstStep => stepIndex == 0;
  bool get isLastStep => stepIndex == totalSteps - 1;
  bool get isSubmitting => submission.isLoading;
  bool get canContinue => true;
  double get progress => (stepIndex + 1) / totalSteps;

  String get cleanUsername {
    final trimmed = username.trim();
    return trimmed.isEmpty ? 'Explorador' : trimmed;
  }

  OnboardingFlowState copyWith({
    int? stepIndex,
    int? dailyGoalMinutes,
    String? username,
    AsyncValue<void>? submission,
  }) {
    return OnboardingFlowState(
      stepIndex: stepIndex ?? this.stepIndex,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      username: username ?? this.username,
      submission: submission ?? this.submission,
    );
  }
}

class OnboardingFlowNotifier extends Notifier<OnboardingFlowState> {
  @override
  OnboardingFlowState build() {
    final profile = ref.watch(currentProfileProvider);

    return OnboardingFlowState(
      dailyGoalMinutes: profile?.dailyGoalMinutes ?? 5,
      username:
          profile?.username == 'Explorador' || profile?.username == 'Explorer'
          ? ''
          : profile?.username ?? '',
    );
  }

  void next() {
    if (!state.canContinue || state.isLastStep) return;

    state = state.copyWith(
      stepIndex: state.stepIndex + 1,
      submission: const AsyncData(null),
    );
  }

  void back() {
    if (state.isFirstStep) return;

    state = state.copyWith(
      stepIndex: state.stepIndex - 1,
      submission: const AsyncData(null),
    );
  }

  void selectDailyGoal(int minutes) {
    state = state.copyWith(
      dailyGoalMinutes: minutes,
      submission: const AsyncData(null),
    );
  }

  void updateUsername(String username) {
    state = state.copyWith(
      username: username,
      submission: const AsyncData(null),
    );
  }

  Future<void> complete() async {
    if (state.isSubmitting) return;

    state = state.copyWith(submission: const AsyncLoading());
    final result = await AsyncValue.guard(() async {
      await ref
          .read(startupAuthProvider.notifier)
          .completeOnboarding(
            username: state.cleanUsername,
            dailyGoalMinutes: state.dailyGoalMinutes,
          );
    });

    state = state.copyWith(submission: result);
  }
}
