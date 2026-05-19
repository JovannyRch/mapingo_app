import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/components/components.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _dailyGoalOptions = [3, 5, 10, 15];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(startupAuthProvider);
    final settingsState = ref.watch(settingsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: authState.when(
        loading: () => const LoadingView(message: 'Loading settings...'),
        error: (error, stackTrace) => ErrorView(
          title: 'Could not load settings',
          message: error.toString(),
          actionLabel: 'Try again',
          onAction: () => ref.read(startupAuthProvider.notifier).retry(),
        ),
        data: (session) => settingsState.when(
          loading: () => const LoadingView(message: 'Loading preferences...'),
          error: (error, stackTrace) => ErrorView(
            title: 'Could not load preferences',
            message: error.toString(),
            actionLabel: 'Try again',
            onAction: () => ref.invalidate(settingsControllerProvider),
          ),
          data: (settings) => ListView(
            padding: MapingoSpacing.screenPadding,
            children: [
              _SettingsHeader(username: session.profile.username ?? 'Explorer'),
              const SizedBox(height: MapingoSpacing.xl),
              _SectionTitle(
                icon: Icons.person_rounded,
                title: 'Learner profile',
              ),
              const SizedBox(height: MapingoSpacing.md),
              _UsernameCard(
                username: session.profile.username ?? 'Explorer',
                onTap: () => _showUsernameDialog(
                  context: context,
                  ref: ref,
                  username: session.profile.username ?? 'Explorer',
                ),
              ),
              const SizedBox(height: MapingoSpacing.md),
              _DailyGoalCard(
                selectedGoal: session.profile.dailyGoalMinutes,
                options: _dailyGoalOptions,
                onSelected: (goal) => _updateDailyGoal(context, ref, goal),
              ),
              const SizedBox(height: MapingoSpacing.xl),
              _SectionTitle(icon: Icons.tune_rounded, title: 'Play settings'),
              const SizedBox(height: MapingoSpacing.md),
              _ToggleCard(
                icon: Icons.volume_up_rounded,
                title: 'Sound effects',
                subtitle: 'Play cheerful sounds during lessons',
                value: settings.soundEffectsEnabled,
                onChanged: (value) =>
                    _setSoundEffects(context, ref, value: value),
              ),
              const SizedBox(height: MapingoSpacing.md),
              _ToggleCard(
                icon: Icons.vibration_rounded,
                title: 'Haptic feedback',
                subtitle: 'Use gentle taps for answers and actions',
                value: settings.hapticFeedbackEnabled,
                onChanged: (value) =>
                    _setHapticFeedback(context, ref, value: value),
              ),
              const SizedBox(height: MapingoSpacing.xl),
              _SectionTitle(
                icon: Icons.cleaning_services_rounded,
                title: 'Device and session',
              ),
              const SizedBox(height: MapingoSpacing.md),
              _ActionCard(
                icon: Icons.cached_rounded,
                title: 'Reset local cache',
                subtitle: 'Restore device preferences to defaults',
                actionLabel: 'Reset',
                onPressed: () => _resetLocalCache(context, ref),
              ),
              const SizedBox(height: MapingoSpacing.md),
              _ActionCard(
                icon: Icons.restart_alt_rounded,
                title: 'Reset guest session',
                subtitle: 'Start again with a fresh anonymous profile',
                actionLabel: 'Reset',
                isDestructive: true,
                onPressed: () => _confirmResetGuestSession(context, ref),
              ),
              const SizedBox(height: MapingoSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showUsernameDialog({
    required BuildContext context,
    required WidgetRef ref,
    required String username,
  }) async {
    final controller = TextEditingController(text: username);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit username'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 24,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'Your name',
              counterText: '',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ref
                      .read(settingsControllerProvider.notifier)
                      .updateUsername(controller.text);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    _showSnackBar(context, 'Username updated.');
                  }
                } catch (_) {
                  if (context.mounted) {
                    _showSnackBar(
                      context,
                      'Could not update your username. Please try again.',
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  Future<void> _updateDailyGoal(
    BuildContext context,
    WidgetRef ref,
    int goal,
  ) async {
    try {
      await ref.read(settingsControllerProvider.notifier).updateDailyGoal(goal);
      if (context.mounted) {
        _showSnackBar(context, 'Daily goal set to $goal minutes.');
      }
    } catch (_) {
      if (context.mounted) {
        _showSnackBar(context, 'Could not update your daily goal.');
      }
    }
  }

  Future<void> _setSoundEffects(
    BuildContext context,
    WidgetRef ref, {
    required bool value,
  }) async {
    try {
      await ref
          .read(settingsControllerProvider.notifier)
          .setSoundEffectsEnabled(value);
    } catch (_) {
      if (context.mounted) {
        _showSnackBar(context, 'Could not update sound effects.');
      }
    }
  }

  Future<void> _setHapticFeedback(
    BuildContext context,
    WidgetRef ref, {
    required bool value,
  }) async {
    try {
      await ref
          .read(settingsControllerProvider.notifier)
          .setHapticFeedbackEnabled(value);
    } catch (_) {
      if (context.mounted) {
        _showSnackBar(context, 'Could not update haptic feedback.');
      }
    }
  }

  Future<void> _resetLocalCache(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(settingsControllerProvider.notifier).resetLocalCache();
      if (context.mounted) {
        _showSnackBar(context, 'Local settings reset.');
      }
    } catch (_) {
      if (context.mounted) {
        _showSnackBar(context, 'Could not reset local settings.');
      }
    }
  }

  Future<void> _confirmResetGuestSession(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset guest session?'),
        content: const Text(
          'This signs out of the current anonymous profile and starts a new one.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (shouldReset != true) return;

    try {
      await ref.read(settingsControllerProvider.notifier).resetGuestSession();
      if (context.mounted) {
        context.go(AppRoutes.splash);
      }
    } catch (_) {
      if (context.mounted) {
        _showSnackBar(context, 'Could not reset your guest session.');
      }
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  final String username;

  const _SettingsHeader({required this.username});

  @override
  Widget build(BuildContext context) {
    return MapingoCard(
      backgroundColor: MapingoColors.secondarySurface,
      boxShadow: MapingoTheme.shadowMd,
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: MapingoColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.settings_suggest_rounded,
              color: MapingoColors.secondaryDark,
              size: 40,
            ),
          ),
          const SizedBox(width: MapingoSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: MapingoTypography.headlineMedium.copyWith(
                    color: MapingoColors.grey900,
                  ),
                ),
                const SizedBox(height: MapingoSpacing.xs),
                Text(
                  'Fine tune your Mapingo adventure.',
                  style: MapingoTypography.bodyMedium.copyWith(
                    color: MapingoColors.grey700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: MapingoColors.primary),
        const SizedBox(width: MapingoSpacing.sm),
        Text(title, style: MapingoTypography.headlineSmall),
      ],
    );
  }
}

class _UsernameCard extends StatelessWidget {
  final String username;
  final VoidCallback onTap;

  const _UsernameCard({required this.username, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MapingoCard(
      onTap: onTap,
      child: Row(
        children: [
          const _SettingIcon(icon: Icons.badge_rounded),
          const SizedBox(width: MapingoSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username', style: MapingoTypography.titleLarge),
                const SizedBox(height: MapingoSpacing.xs),
                Text(
                  username,
                  style: MapingoTypography.bodyMedium.copyWith(
                    color: MapingoColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.edit_rounded, color: MapingoColors.primary),
        ],
      ),
    );
  }
}

class _DailyGoalCard extends StatelessWidget {
  final int selectedGoal;
  final List<int> options;
  final ValueChanged<int> onSelected;

  const _DailyGoalCard({
    required this.selectedGoal,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return MapingoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _SettingIcon(icon: Icons.flag_rounded),
              const SizedBox(width: MapingoSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daily goal', style: MapingoTypography.titleLarge),
                    const SizedBox(height: MapingoSpacing.xs),
                    Text(
                      '$selectedGoal minutes per day',
                      style: MapingoTypography.bodyMedium.copyWith(
                        color: MapingoColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: MapingoSpacing.base),
          Wrap(
            spacing: MapingoSpacing.sm,
            runSpacing: MapingoSpacing.sm,
            children: [
              for (final option in options)
                ChoiceChip(
                  label: Text('$option min'),
                  selected: selectedGoal == option,
                  selectedColor: MapingoColors.primarySurface,
                  labelStyle: MapingoTypography.labelLarge.copyWith(
                    color: selectedGoal == option
                        ? MapingoColors.primaryDark
                        : MapingoColors.grey700,
                  ),
                  side: BorderSide(
                    color: selectedGoal == option
                        ? MapingoColors.primary
                        : MapingoColors.grey300,
                  ),
                  onSelected: (_) => onSelected(option),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToggleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MapingoCard(
      child: Row(
        children: [
          _SettingIcon(icon: icon),
          const SizedBox(width: MapingoSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: MapingoTypography.titleLarge),
                const SizedBox(height: MapingoSpacing.xs),
                Text(
                  subtitle,
                  style: MapingoTypography.bodySmall.copyWith(
                    color: MapingoColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: MapingoColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onPressed;
  final bool isDestructive;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onPressed,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? MapingoColors.error : MapingoColors.primary;

    return MapingoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SettingIcon(icon: icon, color: color),
              const SizedBox(width: MapingoSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: MapingoTypography.titleLarge),
                    const SizedBox(height: MapingoSpacing.xs),
                    Text(
                      subtitle,
                      style: MapingoTypography.bodySmall.copyWith(
                        color: MapingoColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: MapingoSpacing.base),
          SecondaryButton(
            label: actionLabel,
            icon: isDestructive
                ? Icons.restart_alt_rounded
                : Icons.cached_rounded,
            isExpanded: false,
            height: 44,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

class _SettingIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _SettingIcon({required this.icon, this.color = MapingoColors.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color),
    );
  }
}
