import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/prayer/domain/entities/prayer_name.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/prayer/presentation/screens/home_screen.dart';
import '../features/prayer/presentation/screens/monthly_timetable_screen.dart';
import '../features/prayer/presentation/screens/onboarding_screen.dart';
import '../features/prayer/presentation/screens/permission_guide_screen.dart';
import '../features/prayer/presentation/screens/qaza_screen.dart';
import '../features/prayer/presentation/screens/qibla_screen.dart';
import '../features/prayer/presentation/screens/settings_screen.dart';
import '../features/prayer/presentation/screens/setup_check_screen.dart';
import '../features/prayer/presentation/screens/tracker_screen.dart';
import '../features/prayer/presentation/screens/ramadan_imsakiya_screen.dart';
import '../features/prayer/presentation/screens/verify_screen.dart';
import '../features/khata/presentation/screens/khata_screen.dart';
import 'app_shell.dart';

part 'router.g.dart';

abstract final class Routes {
  static const home = '/';
  static const prayer = '/prayer';
  static const tracker = '/tracker';
  static const qaza = '/qaza';
  static const monthly = '/monthly';
  static const qibla = '/qibla';
  static const khata = '/khata';
  static const settings = '/settings';
  static const onboarding = '/onboarding';
  static const oemGuide = '/oem-guide';
  static const verify = '/verify';
  static const setupCheck = '/setup-check';
  static const imsakiya = '/imsakiya';
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
      GoRoute(path: Routes.qaza, builder: (_, _) => const QazaScreen()),
      GoRoute(path: Routes.tracker, builder: (_, _) => const TrackerScreen()),
      GoRoute(path: Routes.monthly, builder: (_, _) => const MonthlyTimetableScreen()),
      GoRoute(path: Routes.qibla, builder: (_, _) => const QiblaScreen()),
      GoRoute(path: Routes.imsakiya, builder: (_, _) => const RamadanImsakiyaScreen()),
      GoRoute(path: Routes.setupCheck, builder: (_, _) => const SetupCheckScreen()),
      GoRoute(
        path: Routes.verify,
        builder: (_, state) {
          final prayer = PrayerName.values
                  .where((p) => p.name == state.uri.queryParameters['prayer'])
                  .firstOrNull ??
              PrayerName.fajr;
          final date = DateTime.tryParse(state.uri.queryParameters['date'] ?? '') ?? DateTime.now();
          return VerifyScreen(
            prayer: prayer,
            date: DateTime(date.year, date.month, date.day),
            isTest: state.uri.queryParameters['test'] == '1',
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.home, builder: (_, _) => const DashboardScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.prayer,
              builder: (_, state) => HomeScreen(
                highlight: PrayerName.values
                    .where((p) => p.name == state.uri.queryParameters['highlight'])
                    .firstOrNull,
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.khata, builder: (_, _) => const KhataScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.settings, builder: (_, _) => const SettingsScreen()),
          ]),
        ],
      ),
    ],
  );
}
