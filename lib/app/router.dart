import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes.dart';
import '../features/auth/presentation/screens/startup_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/lessons/presentation/screens/lesson_result_screen.dart';
import '../features/lessons/presentation/screens/lesson_screen.dart';
import '../features/map_explorer/presentation/screens/map_explorer_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/practice/presentation/screens/practice_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../l10n/app_localizations.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRouteNames.splash,
        builder: (context, state) => const StartupScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => _MainScaffold(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: AppRouteNames.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.practice,
            name: AppRouteNames.practice,
            builder: (context, state) => const PracticeScreen(),
          ),
          GoRoute(
            path: AppRoutes.mapExplorer,
            name: AppRouteNames.mapExplorer,
            builder: (context, state) => const MapExplorerScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: AppRouteNames.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.lessonResult,
        name: AppRouteNames.lessonResult,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return LessonResultScreen(lessonId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.lessonDetail,
        name: AppRouteNames.lessonDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return LessonScreen(lessonId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: AppRouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});

class _MainScaffold extends StatelessWidget {
  final Widget child;

  const _MainScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _MapingoBottomNavigation(),
    );
  }
}

class _MapingoBottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    int currentIndex = 0;
    if (location == AppRoutes.practice) {
      currentIndex = 1;
    } else if (location == AppRoutes.mapExplorer) {
      currentIndex = 2;
    } else if (location == AppRoutes.profile) {
      currentIndex = 3;
    }

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go(AppRoutes.home);
          case 1:
            context.go(AppRoutes.practice);
          case 2:
            context.go(AppRoutes.mapExplorer);
          case 3:
            context.go(AppRoutes.profile);
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_rounded),
          label: AppLocalizations.of(context)!.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.quiz_rounded),
          label: AppLocalizations.of(context)!.practice,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.map_rounded),
          label: AppLocalizations.of(context)!.map,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_rounded),
          label: AppLocalizations.of(context)!.profile,
        ),
      ],
    );
  }
}
