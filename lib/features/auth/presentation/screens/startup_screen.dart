import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../shared/components/error_view.dart';
import '../../../../shared/components/loading_view.dart';
import '../providers/auth_provider.dart';

class StartupScreen extends ConsumerWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        loading: () => const LoadingView(message: 'Starting Mapingo...'),
        error: (error, stackTrace) => ErrorView(
          title: 'Could not start Mapingo',
          message: _startupErrorMessage(error),
          actionLabel: 'Try again',
          onAction: () => ref.read(startupAuthProvider.notifier).retry(),
        ),
        data: (_) => const LoadingView(message: 'Opening your map...'),
      ),
    );
  }

  String _startupErrorMessage(Object error) {
    final message = error.toString();
    if (message.contains('anonymous_provider_disabled')) {
      return 'Anonymous sign-ins are disabled in Supabase. Enable Anonymous sign-ins in Authentication > Providers before starting Mapingo.';
    }
    if (message.contains('Failed host lookup') ||
        message.contains('SocketException') ||
        message.contains('AuthRetryableFetchException')) {
      return 'Mapingo could not reach Supabase. Check the network connection and Supabase URL, then try again.';
    }
    if (message.contains('Supabase is not configured')) {
      return 'Supabase is not configured for this build. Add SUPABASE_URL and SUPABASE_ANON_KEY when launching the app.';
    }

    return 'Something went wrong while starting Mapingo. Please try again.';
  }
}
