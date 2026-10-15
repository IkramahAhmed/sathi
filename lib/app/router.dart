import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/prayer/domain/entities/prayer_name.dart';
import '../features/prayer/presentation/screens/home_screen.dart';
import '../features/prayer/presentation/screens/monthly_timetable_screen.dart';
import '../features/prayer/presentation/screens/onboarding_screen.dart';
import '../features/prayer/presentation/screens/permission_guide_screen.dart';
import '../features/prayer/presentation/screens/qibla_screen.dart';
import '../features/prayer/presentation/screens/settings_screen.dart';
import 'app_shell.dart';

part 'router.g.dart';

abstract final class Routes {
  static const home = '/';
  static const monthly = '/monthly';
  static const qibla = '/qibla';
  static const settings = '/settings';
  static const onboarding = '/onboarding';
  static const oemGuide = '/oem-guide';
  static const verify = '/verify';
}

/// The first route to show. Overridden in `main()` once onboarding state is known.
@Riverpod(keepAlive: true)
String initialRoute(Ref ref) => Routes.home;

final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: ref.watch(initialRouteProvider),
    routes: [
      GoRoute(path: Routes.onboarding, builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: Routes.oemGuide, builder: (_, _) => const PermissionGuideScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.home,
              builder: (_, state) => HomeScreen(
                highlight: PrayerName.values
                    .where((p) => p.name == state.uri.queryParameters['highlight'])
                    .firstOrNull,
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.monthly, builder: (_, _) => const MonthlyTimetableScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.qibla, builder: (_, _) => const QiblaScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.settings, builder: (_, _) => const SettingsScreen()),
          ]),
        ],
      ),
    ],
  );
}
