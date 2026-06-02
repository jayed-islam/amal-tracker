import 'package:amal_tracker/features/auth/providers/auth_provider.dart';
import 'package:amal_tracker/features/jannah_garden/screen/jannah_garden_screen.dart';
import 'package:amal_tracker/features/notification/screen/notification_screen.dart';
import 'package:amal_tracker/features/notification/screen/notification_settings_screen.dart';
import 'package:amal_tracker/features/settings/screens/legal_screen.dart';
import 'package:amal_tracker/features/settings/screens/settings_screen.dart';
import 'package:amal_tracker/features/user/screen/how_its_work_screen.dart';
import 'package:amal_tracker/features/user/screen/password_change_screen.dart';
import 'package:amal_tracker/features/user/screen/profile_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amal_tracker/features/auth/screens/login_screen.dart';
import 'package:amal_tracker/features/auth/screens/register_screen.dart';
import 'package:amal_tracker/shared/widgets/main_shell.dart';

// ── Route path constants ───────────────────────────────────────────────────
class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const tracker = '/tracker';
  static const monthlyView = '/monthly';
  static const leaderboard = '/leaderboard';
  static const profileEdit = '/profile/edit';
  static const howItWorks = '/how-it-works';
  static const settings = '/settings';
  static const changePassword = '/change-password';
  static const notifications = '/notifications';
  static const notificationSettings = '/notification-settings';
  static const legal = '/legal';
  static const jannahGarden = '/jannah-garden';
}

// ── Single root navigator key — that's all we need now ────────────────────
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

// ── Router provider ────────────────────────────────────────────────────────
final routerProvider = Provider<GoRouter>((ref) {
  // final notifier = ref.watch(routerNotifierProvider.notifier);
  final authState = ref.watch(authProvider);
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.login,

    // ২. স্টেট বদলালেই গো-রাউটার রিফ্রেশ হবে
    refreshListenable: ValueNotifier<AuthState>(authState),

    redirect: (context, state) {
      final isAuth = authState.status == AuthStatus.authenticated;
      final loc = state.matchedLocation;

      // 🟢 ম্যাজিক কন্ডিশন: ইউজার যদি অলরেডি রেজিস্টার পেজে থাকে এবং তার এপিআই লোডিংয়ে থাকে,
      // তাকে জোর করে লগইন পেজে পাঠানো যাবে না।
      if (loc == AppRoutes.register && authState.isLoading) {
        return null; // কোনো রিডাইরেক্ট হবে না, রেজিস্টার স্ক্রিনেই ধরে রাখো
      }

      final isAuthPage = loc == AppRoutes.login || loc == AppRoutes.register;

      if (!isAuth && !isAuthPage) return AppRoutes.login;
      if (isAuth && isAuthPage) return AppRoutes.home;

      return null;
    },

    routes: [
      // ── Auth ──────────────────────────────────────────────────────────
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

      // ── Main app shell (tabs live inside MainShell) ───────────────────
      // GoRouter handles auth redirect → /home
      // MainShell handles which tab is visible
      GoRoute(
        path: AppRoutes.home,
        builder: (_, __) => const MainShell(),
      ),

      // ── Full-screen pages (pushed on top of shell, no bottom nav) ─────
      GoRoute(
        path: AppRoutes.profileEdit,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ProfileEditScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),

      GoRoute(
        path: AppRoutes.jannahGarden,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const JannahWorldScreen(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
      ),

      GoRoute(
        path: AppRoutes.howItWorks,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HowItWorksScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),

      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SettingsScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),

      GoRoute(
        path: AppRoutes.legal,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: LegalScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ChangePasswordScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),

      GoRoute(
        path: AppRoutes.notifications,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const NotificationScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),

      GoRoute(
        path: AppRoutes.notificationSettings,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const NotificationSettingsScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
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
