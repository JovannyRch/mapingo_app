import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';
import '../components/error_view.dart';
import '../components/loading_view.dart';

class StartupAuthCheck extends ConsumerWidget {
  final Widget authenticatedChild;
  final Widget unauthenticatedChild;

  const StartupAuthCheck({
    super.key,
    required this.authenticatedChild,
    required this.unauthenticatedChild,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(startupAuthProvider);

    return authState.when(
      loading: () =>
          const Scaffold(body: LoadingView(message: 'Starting Mapingo...')),
      error: (error, stackTrace) => Scaffold(
        body: ErrorView(
          title: 'Could not start Mapingo',
          message: error.toString(),
          actionLabel: 'Try again',
          onAction: () => ref.read(startupAuthProvider.notifier).retry(),
        ),
      ),
      data: (session) => session.profile.onboardingCompleted
          ? authenticatedChild
          : unauthenticatedChild,
    );
  }
}
