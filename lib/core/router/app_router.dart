import 'package:amal_tracker/core/router/route_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amal_tracker/features/auth/screens/login_screen.dart';
import 'package:amal_tracker/features/auth/screens/register_screen.dart';
import 'package:amal_tracker/features/home/screens/home_screen.dart';
import 'package:amal_tracker/features/home/screens/splash_screen.dart';
import 'package:amal_tracker/features/leaderboard/screens/leaderboard_screen.dart';
import 'package:amal_tracker/features/tracker/screens/monthly_view_screen.dart';
import 'package:amal_tracker/features/tracker/screens/tracker_screen.dart';
import 'package:amal_tracker/shared/widgets/main_shell.dart';

// ── Route path constants ───────────────────────────────────────────────────
class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const tracker = '/tracker';
  static const monthlyView = '/monthly';
  static const leaderboard = '/leaderboard';
}

// ── Navigator keys — declared at top level so they are NEVER recreated ─────
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _homeNavKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _trackerNavKey = GlobalKey<NavigatorState>(debugLabel: 'tracker');
final _monthlyNavKey = GlobalKey<NavigatorState>(debugLabel: 'monthly');
final _leaderboardNavKey = GlobalKey<NavigatorState>(debugLabel: 'leaderboard');

// ── Router provider — use ref.watch so disposal is handled by Riverpod ─────
final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider.notifier);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,

    // Delegates to RouterNotifier which is a proper Listenable
    refreshListenable: notifier,

    // Delegates redirect logic to RouterNotifier
    redirect: notifier.redirect,

    routes: [
      // ── Public / Auth routes ─────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),

      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),

      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
          transitionsBuilder: (_, animation, __, child) => SlideTransition(
            position: Tween(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            )),
            child: child,
          ),
        ),
      ),

      // ── Shell — 4 branches, each with its own navigator stack ────────
      // StatefulShellRoute.indexedStack preserves each tab's scroll/state
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          // ── Branch 0: Home ─────────────────────────────────────────
          StatefulShellBranch(
            navigatorKey: _homeNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (_, __) =>
                    const NoTransitionPage(child: HomeScreen()),
              ),
            ],
          ),

          // ── Branch 1: Tracker ───────────────────────────────────────
          // Sub-routes nested here get pushed inside the tracker stack,
          // so back-button returns to TrackerScreen, not a black screen.
          StatefulShellBranch(
            navigatorKey: _trackerNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.tracker,
                pageBuilder: (_, __) =>
                    const NoTransitionPage(child: TrackerScreen()),
                // routes: [
                //   // Example: context.go('/tracker/detail/123')
                //   // GoRoute(
                //   //   path: 'detail/:id',
                //   //   pageBuilder: (_, state) => CustomTransitionPage(
                //   //     key: state.pageKey,
                //   //     child: TrackerDetailScreen(
                //   //       id: state.pathParameters['id']!,
                //   //     ),
                //   //     transitionsBuilder: (_, anim, __, child) =>
                //   //         SlideTransition(
                //   //       position: Tween(
                //   //         begin: const Offset(1, 0),
                //   //         end: Offset.zero,
                //   //       ).animate(CurvedAnimation(
                //   //         parent: anim,
                //   //         curve: Curves.easeInOutCubic,
                //   //       )),
                //   //       child: child,
                //   //     ),
                //   //   ),
                //   // ),
                // ],
              ),
            ],
          ),

          // ── Branch 2: Monthly / রিপোর্ট ───────────────────────────
          StatefulShellBranch(
            navigatorKey: _monthlyNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.monthlyView,
                pageBuilder: (_, __) =>
                    const NoTransitionPage(child: MonthlyViewScreen()),
              ),
            ],
          ),

          // ── Branch 3: Leaderboard ───────────────────────────────────
          StatefulShellBranch(
            navigatorKey: _leaderboardNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.leaderboard,
                pageBuilder: (_, __) =>
                    const NoTransitionPage(child: LeaderboardScreen()),
              ),
            ],
          ),
        ],
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            const Text('পেজ খুঁজে পাওয়া যায়নি'),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('হোমে ফিরে যান'),
            ),
          ],
        ),
      ),
    ),
  );
});
