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

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
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
      GoRoute(
        path: AppRoutes.home,
        name: AppRouteNames.home,
        builder: (context, state) => const HomeScreen(),
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
      GoRoute(
        path: AppRoutes.settings,
        name: AppRouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
