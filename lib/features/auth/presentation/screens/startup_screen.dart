import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/components/error_view.dart';
import '../../../../shared/components/loading_view.dart';
import '../providers/auth_provider.dart';

class StartupScreen extends ConsumerWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    ref.listen(startupAuthProvider, (previous, next) {
      next.whenOrNull(
        data: (session) {
          final route = session.profile.onboardingCompleted
              ? AppRoutes.home
              : AppRoutes.onboarding;
          context.go(route);
        },
      );
    });

    final startupState = ref.watch(startupAuthProvider);

    return Scaffold(
      body: startupState.when(
        loading: () => LoadingView(message: l10n.startingMapingo),
        error: (error, stackTrace) => ErrorView(
          title: l10n.couldNotStartMapingo,
          message: _startupErrorMessage(error, context),
          actionLabel: l10n.tryAgain,
          onAction: () => ref.read(startupAuthProvider.notifier).retry(),
        ),
        data: (_) => LoadingView(message: l10n.openingYourMap),
      ),
    );
  }

  String _startupErrorMessage(Object error, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final message = error.toString();
    if (message.contains('anonymous_provider_disabled')) {
      return l10n.anonymousSignInsDisabled;
    }
    if (message.contains('Failed host lookup') ||
        message.contains('SocketException') ||
        message.contains('AuthRetryableFetchException')) {
      return l10n.mapingoCouldNotReachSupabase;
    }
    if (message.contains('Supabase is not configured')) {
      return l10n.supabaseNotConfigured;
    }

    return l10n.somethingWentWrong;
  }
}
