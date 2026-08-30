// Copyright (c) Periodt. 2026
//
// This file is part of Periodt and licensed under the PSAL v1.0.
// See the LICENSE file for details.
//
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:periodt/core/settings/models.dart';
import 'package:periodt/core/settings/notifier.dart';
import 'package:periodt/core/theme/app.dart';
import 'package:periodt/core/widgets/layout/navbar.dart';
import 'package:periodt/features/home/screens/home.dart';
import 'package:periodt/features/period-log/screens/period-log.dart';
import 'package:periodt/features/pin-setup/screens/pin_setup.dart';
import 'package:periodt/features/settings/screens/cycle.dart';
import 'package:periodt/features/settings/screens/developer.dart';
import 'package:periodt/features/settings/screens/profile.dart';
import 'package:periodt/features/settings/screens/root.dart';
import 'package:periodt/features/settings/screens/security.dart';
import 'package:periodt/features/setup/screens/setup-screen-2.dart';
import 'package:periodt/features/splash/screens/splash_screen.dart';
import 'package:periodt/features/symptom-tracker/screens/symptoms.dart';
import 'package:periodt/i18n/strings.g.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();

  runApp(const ProviderScope(child: PeriodtApp()));
}

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    // Listen to the settings provider. Whenever it changes (e.g., finishes loading,
    // or user completes setup), notify GoRouter to re-run its redirect logic.
    _ref.listen<PeriodtSettings?>(
      settingsNotifier,
      (_, _) => notifyListeners(),
    );
  }
}

final _router = Provider((ref) {
  return GoRouter(
    routes: <RouteBase>[
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: Stack(children: [child, const PeriodtNavbar()]),
          );
        },
        routes: [
          GoRoute(
            path: "/home",
            builder: (context, state) => const HomeScreen(),
          ),
        ],
      ),
      GoRoute(
        path: "/period-log",
        builder: (context, state) => const PeriodLogScreen(),
      ),
      GoRoute(path: "/", builder: (context, state) => const SplashScreen()),
      GoRoute(path: "/setup", builder: (context, state) => const SetupScreen()),
      GoRoute(
        path: "/pin-setup",
        builder: (context, state) => const PinSetupScreen(),
      ),
      GoRoute(
        path: "/daily-log",
        builder: (context, state) => const DailyLogScreen(),
      ),
      GoRoute(
        path: "/settings",
        builder: (context, state) => const SettingsRootScreen(),
        routes: [
          GoRoute(
            path: "/security",
            builder: (context, state) => const SecuritySettingsScreen(),
          ),
          GoRoute(
            path: "/cycle",
            builder: (context, state) => const CycleSettingsScreen(),
          ),
          GoRoute(
            path: "/developer",
            builder: (context, state) => const DeveloperSettingsScreen(),
          ),
          GoRoute(
            path: "/profile",
            builder: (context, state) => const ProfileSettingsScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final settings = ref.read(settingsNotifier);

      final isSetupComplete = settings.setupComplete;

      final currentPath = state.uri.path;

      // 2. Define exactly which paths users are allowed to see BEFORE setup is complete.
      // This easily scales if you add '/terms', '/help', or '/setup-step-2'
      final allowedUnsetPaths = ['/setup', '/terms', '/privacy'];
      final isGoingToAllowedUnsetPath = allowedUnsetPaths.contains(currentPath);

      // 3. Setup State
      if (!isSetupComplete) {
        // If they aren't fully set up, only let them navigate to allowed paths.
        // Otherwise, force them to the primary setup screen.
        return isGoingToAllowedUnsetPath ? null : '/setup';
      }

      if (settings.security.method == SecurityMethod.pin) {}

      // 4. Fully Set Up State
      // If they are completely set up but trying to access the Splash screen
      // or a setup-only screen, politely shove them to the home page.
      if (currentPath == '/' || isGoingToAllowedUnsetPath) {
        return '/home';
      }

      // 5. Catch-All for normal navigation
      // They are set up and going to /profile, /settings, /feed, etc. Let them proceed.
      return null;
    },
    refreshListenable: RouterNotifier(ref),
  );
});

final class PeriodtApp extends ConsumerWidget {
  const PeriodtApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(_router);

    return MaterialApp.router(routerConfig: router, theme: theme);
  }
}
