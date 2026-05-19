import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../shared/components/error_view.dart';
import '../../../../shared/components/loading_view.dart';
import '../../../../shared/components/mapingo_card.dart';
import '../../../../shared/components/primary_button.dart';
import '../../../../shared/components/secondary_button.dart';
import '../providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;
  late final TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(startupAuthProvider, (previous, next) {
      final previousCompleted =
          previous?.valueOrNull?.profile.onboardingCompleted ?? false;

      next.whenOrNull(
        data: (session) {
          if (!previousCompleted && session.profile.onboardingCompleted) {
            context.go(AppRoutes.home);
          }
        },
      );
    });

    ref.listen(onboardingFlowProvider.select((state) => state.stepIndex), (
      previous,
      next,
    ) {
      if (previous != next && _pageController.hasClients) {
        _pageController.animateToPage(
          next,
          duration: MapingoTheme.durationNormal,
          curve: Curves.easeOutCubic,
        );
      }
    });

    final authState = ref.watch(startupAuthProvider);

    return Scaffold(
      body: authState.when(
        loading: () => const LoadingView(message: 'Loading your profile...'),
        error: (error, stackTrace) => ErrorView(
          title: 'Could not load onboarding',
          message: error.toString(),
          actionLabel: 'Try again',
          onAction: () => ref.read(startupAuthProvider.notifier).retry(),
        ),
        data: (_) => _OnboardingContent(
          pageController: _pageController,
          usernameController: _usernameController,
        ),
      ),
    );
  }
}

class _OnboardingContent extends ConsumerWidget {
  final PageController pageController;
  final TextEditingController usernameController;

  const _OnboardingContent({
    required this.pageController,
    required this.usernameController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingFlowProvider);
    final notifier = ref.read(onboardingFlowProvider.notifier);

    final existingUsername = state.username;
    if (usernameController.text != existingUsername) {
      usernameController.value = TextEditingValue(
        text: existingUsername,
        selection: TextSelection.collapsed(offset: existingUsername.length),
      );
    }

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxHeight < 680;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  MapingoSpacing.xl,
                  MapingoSpacing.lg,
                  MapingoSpacing.xl,
                  isCompact ? MapingoSpacing.base : MapingoSpacing.xl,
                ),
                child: Column(
                  children: [
                    _OnboardingProgress(state: state),
                    SizedBox(height: isCompact ? MapingoSpacing.base : 28),
                    Expanded(
                      child: PageView(
                        controller: pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          const _WelcomeStep(),
                          const _PurposeStep(),
                          _DailyGoalStep(
                            selectedMinutes: state.dailyGoalMinutes,
                            onSelected: notifier.selectDailyGoal,
                          ),
                          _UsernameStep(
                            controller: usernameController,
                            onChanged: notifier.updateUsername,
                          ),
                          _StartLearningStep(
                            username: state.cleanUsername,
                            dailyGoalMinutes: state.dailyGoalMinutes,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isCompact ? MapingoSpacing.base : 28),
                    if (state.submission.hasError) ...[
                      Text(
                        state.submission.error.toString(),
                        style: MapingoTypography.bodySmall.copyWith(
                          color: MapingoColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: MapingoSpacing.sm),
                    ],
                    _OnboardingActions(
                      state: state,
                      onBack: notifier.back,
                      onNext: notifier.next,
                      onComplete: notifier.complete,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OnboardingProgress extends StatelessWidget {
  final OnboardingFlowState state;

  const _OnboardingProgress({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Step ${state.stepIndex + 1} of ${OnboardingFlowState.totalSteps}',
              style: MapingoTypography.labelMedium.copyWith(
                color: MapingoColors.grey600,
              ),
            ),
            const Spacer(),
            Text(
              '${(state.progress * 100).round()}%',
              style: MapingoTypography.labelMedium.copyWith(
                color: MapingoColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: MapingoSpacing.sm),
        ClipRRect(
          borderRadius: MapingoTheme.borderRadiusFull,
          child: LinearProgressIndicator(
            minHeight: 10,
            value: state.progress,
            backgroundColor: MapingoColors.grey200,
            valueColor: const AlwaysStoppedAnimation(MapingoColors.primary),
          ),
        ),
      ],
    );
  }
}

class _OnboardingActions extends StatelessWidget {
  final OnboardingFlowState state;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onComplete;

  const _OnboardingActions({
    required this.state,
    required this.onBack,
    required this.onNext,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!state.isFirstStep) ...[
          Expanded(
            child: SecondaryButton(
              label: 'Back',
              icon: Icons.arrow_back_rounded,
              onPressed: state.isSubmitting ? null : onBack,
            ),
          ),
          const SizedBox(width: MapingoSpacing.md),
        ],
        Expanded(
          flex: 2,
          child: PrimaryButton(
            label: state.isLastStep ? 'Start learning' : 'Continue',
            icon: state.isLastStep
                ? Icons.play_arrow_rounded
                : Icons.arrow_forward_rounded,
            isLoading: state.isSubmitting,
            onPressed: !state.canContinue
                ? null
                : state.isLastStep
                ? onComplete
                : onNext,
          ),
        ),
      ],
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep();

  @override
  Widget build(BuildContext context) {
    return const _StepScaffold(
      mascotColor: MapingoColors.primarySurface,
      mascotIcon: Icons.explore_rounded,
      title: 'Welcome to Mapingo',
      body:
          'A playful way to learn Mexico\'s states, capitals, regions, and map shapes.',
      chipText: 'No email needed to begin',
    );
  }
}

class _PurposeStep extends StatelessWidget {
  const _PurposeStep();

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      mascotColor: MapingoColors.infoLight,
      mascotIcon: Icons.school_rounded,
      title: 'Learn by playing',
      body:
          'Short lessons help you recognize each state, remember capitals, and practice on the map.',
      child: Column(
        children: const [
          _PurposeItem(icon: Icons.map_rounded, label: 'Tap states on the map'),
          _PurposeItem(
            icon: Icons.location_city_rounded,
            label: 'Match states and capitals',
          ),
          _PurposeItem(
            icon: Icons.emoji_events_rounded,
            label: 'Earn XP and achievements',
          ),
        ],
      ),
    );
  }
}

class _DailyGoalStep extends StatelessWidget {
  final int selectedMinutes;
  final ValueChanged<int> onSelected;

  const _DailyGoalStep({
    required this.selectedMinutes,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    const goals = [
      _DailyGoalOption(
        minutes: 3,
        title: 'Quick trip',
        subtitle: 'A tiny map warmup',
      ),
      _DailyGoalOption(
        minutes: 5,
        title: 'Steady explorer',
        subtitle: 'Great for every day',
      ),
      _DailyGoalOption(
        minutes: 10,
        title: 'Map champion',
        subtitle: 'More practice and XP',
      ),
    ];

    return _StepScaffold(
      mascotColor: MapingoColors.secondarySurface,
      mascotIcon: Icons.timer_rounded,
      title: 'Choose a daily goal',
      body: 'Pick a goal that feels easy to repeat. You can change it later.',
      child: Column(
        children: [
          for (final goal in goals) ...[
            _DailyGoalCard(
              option: goal,
              isSelected: selectedMinutes == goal.minutes,
              onTap: () => onSelected(goal.minutes),
            ),
            const SizedBox(height: MapingoSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _UsernameStep extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _UsernameStep({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      mascotColor: MapingoColors.warningLight,
      mascotIcon: Icons.person_rounded,
      title: 'What should we call you?',
      body: 'Choose a friendly name for your profile and lesson celebrations.',
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.done,
        textCapitalization: TextCapitalization.words,
        maxLength: 24,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r"[a-zA-Z0-9 áéíóúÁÉÍÓÚñÑ.'-]"),
          ),
        ],
        decoration: const InputDecoration(
          hintText: 'Your name',
          prefixIcon: Icon(Icons.badge_rounded),
          counterText: '',
        ),
      ),
    );
  }
}

class _StartLearningStep extends StatelessWidget {
  final String username;
  final int dailyGoalMinutes;

  const _StartLearningStep({
    required this.username,
    required this.dailyGoalMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      mascotColor: MapingoColors.successLight,
      mascotIcon: Icons.flag_rounded,
      title: 'Ready, $username?',
      body:
          'Your daily goal is $dailyGoalMinutes minutes. Start with Northern Mexico and build your map skills step by step.',
      chipText: 'Let\'s learn Mexico',
      child: const MapingoCard(
        backgroundColor: MapingoColors.primarySurface,
        boxShadow: [],
        child: Row(
          children: [
            Icon(Icons.route_rounded, color: MapingoColors.primary),
            SizedBox(width: MapingoSpacing.md),
            Expanded(
              child: Text(
                'Your first learning path is ready.',
                style: MapingoTypography.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepScaffold extends StatelessWidget {
  final Color mascotColor;
  final IconData mascotIcon;
  final String title;
  final String body;
  final String? chipText;
  final Widget? child;

  const _StepScaffold({
    required this.mascotColor,
    required this.mascotIcon,
    required this.title,
    required this.body,
    this.chipText,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: MapingoSpacing.sm),
          _MascotPlaceholder(backgroundColor: mascotColor, icon: mascotIcon),
          const SizedBox(height: MapingoSpacing.xxl),
          Text(
            title,
            style: MapingoTypography.displayMedium.copyWith(
              color: MapingoColors.grey900,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: MapingoSpacing.md),
          Text(
            body,
            style: MapingoTypography.bodyLarge.copyWith(
              color: MapingoColors.grey700,
            ),
            textAlign: TextAlign.center,
          ),
          if (chipText != null) ...[
            const SizedBox(height: MapingoSpacing.lg),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: MapingoSpacing.base,
                  vertical: MapingoSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: MapingoColors.white,
                  borderRadius: MapingoTheme.borderRadiusFull,
                  boxShadow: MapingoTheme.shadowSm,
                ),
                child: Text(
                  chipText!,
                  style: MapingoTypography.labelMedium.copyWith(
                    color: MapingoColors.primary,
                  ),
                ),
              ),
            ),
          ],
          if (child != null) ...[
            const SizedBox(height: MapingoSpacing.xxl),
            child!,
          ],
          const SizedBox(height: MapingoSpacing.sm),
        ],
      ),
    );
  }
}

class _MascotPlaceholder extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;

  const _MascotPlaceholder({required this.backgroundColor, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 168,
        height: 168,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: MapingoColors.white, width: 8),
          boxShadow: MapingoTheme.shadowMd,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned(
              right: 34,
              top: 36,
              child: Icon(
                Icons.auto_awesome_rounded,
                color: MapingoColors.secondary,
                size: 28,
              ),
            ),
            Icon(icon, color: MapingoColors.primary, size: 80),
          ],
        ),
      ),
    );
  }
}

class _PurposeItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PurposeItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: MapingoSpacing.md),
      child: MapingoCard(
        boxShadow: MapingoTheme.shadowSm,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: MapingoColors.primarySurface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: MapingoColors.primary),
            ),
            const SizedBox(width: MapingoSpacing.md),
            Expanded(child: Text(label, style: MapingoTypography.titleLarge)),
          ],
        ),
      ),
    );
  }
}

class _DailyGoalOption {
  final int minutes;
  final String title;
  final String subtitle;

  const _DailyGoalOption({
    required this.minutes,
    required this.title,
    required this.subtitle,
  });
}

class _DailyGoalCard extends StatelessWidget {
  final _DailyGoalOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _DailyGoalCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MapingoCard(
      onTap: onTap,
      boxShadow: isSelected
          ? MapingoTheme.shadowPrimary
          : MapingoTheme.shadowSm,
      border: Border.all(
        color: isSelected ? MapingoColors.primary : MapingoColors.grey200,
        width: isSelected ? 2 : 1,
      ),
      backgroundColor: isSelected
          ? MapingoColors.primarySurface
          : MapingoColors.white,
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: isSelected ? MapingoColors.primary : MapingoColors.grey100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${option.minutes}',
                style: MapingoTypography.headlineMedium.copyWith(
                  color: isSelected
                      ? MapingoColors.white
                      : MapingoColors.grey700,
                ),
              ),
            ),
          ),
          const SizedBox(width: MapingoSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(option.title, style: MapingoTypography.titleLarge),
                const SizedBox(height: MapingoSpacing.xs),
                Text(
                  '${option.subtitle} • ${option.minutes} min/day',
                  style: MapingoTypography.bodySmall.copyWith(
                    color: MapingoColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: isSelected ? MapingoColors.primary : MapingoColors.grey400,
          ),
        ],
      ),
    );
  }
}
