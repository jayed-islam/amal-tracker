// import 'package:amal_tracker/features/auth/providers/auth_provider.dart';
// import 'package:amal_tracker/features/jannah_garden/screen/jannah_garden_screen.dart';
// import 'package:amal_tracker/features/notification/screen/notification_screen.dart';
// import 'package:amal_tracker/features/notification/screen/notification_settings_screen.dart';
// import 'package:amal_tracker/features/settings/screens/legal_screen.dart';
// import 'package:amal_tracker/features/settings/screens/settings_screen.dart';
// import 'package:amal_tracker/features/user/screen/how_its_work_screen.dart';
// import 'package:amal_tracker/features/user/screen/password_change_screen.dart';
// import 'package:amal_tracker/features/user/screen/profile_edit_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:amal_tracker/features/auth/screens/login_screen.dart';
// import 'package:amal_tracker/features/auth/screens/register_screen.dart';
import 'package:amal_tracker/features/auth/screens/otp_verification_screen.dart';
// import 'package:amal_tracker/shared/widgets/main_shell.dart';

//   static const howItWorks = '/how-it-works';
//   static const settings = '/settings';
//   static const changePassword = '/change-password';
//   static const notifications = '/notifications';
//   static const notificationSettings = '/notification-settings';
//   static const legal = '/legal';
//   static const jannahGarden = '/jannah-garden';
// }

// // ── Single root navigator key — that's all we need now ────────────────────
// final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
// final _routerStatusController = ValueNotifier<AuthStatus>(AuthStatus.unknown);

// // ── Router provider ────────────────────────────────────────────────────────
// final routerProvider = Provider<GoRouter>((ref) {
//   // final notifier = ref.watch(routerNotifierProvider.notifier);
//   // final authState = ref.watch(authProvider);

//   ref.listen(
//     authProvider.select((s) => s.status),
//     (_, next) => _routerStatusController.value = next,
//   );

//   // final authStatus = ref.watch(
//   //   authProvider.select((s) => s.status),
//   // );

//   // final listenable = _StatusListenable(authStatus);

//   return GoRouter(
//     navigatorKey: _rootNavigatorKey,
//     initialLocation: AppRoutes.login,
//     refreshListenable: _routerStatusController,
//     redirect: (context, state) {
//       final authStatus = _routerStatusController.value;
//       final isAuth = authStatus == AuthStatus.authenticated;
//       final loc = state.matchedLocation;
//       final isAuthPage = loc == AppRoutes.login || loc == AppRoutes.register;

//       if (!isAuth && !isAuthPage) return AppRoutes.login;
//       if (isAuth && isAuthPage) return AppRoutes.home;
//       return null;
//     },
//     // initialLocation: AppRoutes.login,

//     // // ২. স্টেট বদলালেই গো-রাউটার রিফ্রেশ হবে
//     // // refreshListenable: ValueNotifier<AuthState>(authState),
//     // refreshListenable: listenable,

//     // redirect: (context, state) {
//     //   final isAuth = authStatus == AuthStatus.authenticated;
//     //   final loc = state.matchedLocation;
//     //   final isAuthPage = loc == AppRoutes.login || loc == AppRoutes.register;

//     //   if (!isAuth && !isAuthPage) return AppRoutes.login;
//     //   if (isAuth && isAuthPage) return AppRoutes.home;
//     //   return null;
//     // },

//     // redirect: (context, state) {
//     //   final isAuth = authState.status == AuthStatus.authenticated;
//     //   final loc = state.matchedLocation;

//     // ম্যাজিক কন্ডিশন: ইউজার যদি অলরেডি রেজিস্টার পেজে থাকে এবং তার এপিআই লোডিংয়ে থাকে,
//     //   // তাকে জোর করে লগইন পেজে পাঠানো যাবে না।
//     //   if (loc == AppRoutes.register && authState.isLoading) {
//     //     return null; // কোনো রিডাইরেক্ট হবে না, রেজিস্টার স্ক্রিনেই ধরে রাখো
//     //   }

//     //   final isAuthPage = loc == AppRoutes.login || loc == AppRoutes.register;

//     //   if (!isAuth && !isAuthPage) return AppRoutes.login;
//     //   if (isAuth && isAuthPage) return AppRoutes.home;

//     //   return null;
//     // },

//     routes: [
//       // ── Auth ──────────────────────────────────────────────────────────
//       GoRoute(
//         path: AppRoutes.login,
//         pageBuilder: (_, state) => CustomTransitionPage(
//           key: state.pageKey,
//           child: const LoginScreen(),
//           transitionsBuilder: (_, animation, __, child) =>
//               FadeTransition(opacity: animation, child: child),
//         ),
//       ),

//       GoRoute(
//         path: AppRoutes.register,
//         pageBuilder: (_, state) => CustomTransitionPage(
//           key: state.pageKey,
//           child: const RegisterScreen(),
//           transitionsBuilder: (_, animation, __, child) => SlideTransition(
//             position: Tween(
//               begin: const Offset(1, 0),
//               end: Offset.zero,
//             ).animate(CurvedAnimation(
//               parent: animation,
//               curve: Curves.easeInOutCubic,
//             )),
//             child: child,
//           ),
//         ),
//       ),

//       // ── Main app shell (tabs live inside MainShell) ───────────────────
//       // GoRouter handles auth redirect → /home
//       // MainShell handles which tab is visible
//       GoRoute(
//         path: AppRoutes.home,
//         builder: (_, __) => const MainShell(),
//       ),

//       // ── Full-screen pages (pushed on top of shell, no bottom nav) ─────
//       GoRoute(
//         path: AppRoutes.profileEdit,
//         pageBuilder: (_, state) => CustomTransitionPage(
//           key: state.pageKey,
//           child: const ProfileEditScreen(),
//           transitionsBuilder: (_, animation, __, child) =>
//               FadeTransition(opacity: animation, child: child),
//         ),
//       ),

//       GoRoute(
//         path: AppRoutes.jannahGarden,
//         pageBuilder: (_, state) => CustomTransitionPage(
//           key: state.pageKey,
//           child: const JannahWorldScreen(),
//           transitionsBuilder: (_, animation, __, child) => FadeTransition(
//             opacity: animation,
//             child: child,
//           ),
//         ),
//       ),

//       GoRoute(
//         path: AppRoutes.howItWorks,
//         pageBuilder: (_, state) => CustomTransitionPage(
//           key: state.pageKey,
//           child: const HowItWorksScreen(),
//           transitionsBuilder: (_, animation, __, child) =>
//               FadeTransition(opacity: animation, child: child),
//         ),
//       ),

//       GoRoute(
//         path: AppRoutes.settings,
//         pageBuilder: (_, state) => CustomTransitionPage(
//           key: state.pageKey,
//           child: const SettingsScreen(),
//           transitionsBuilder: (_, animation, __, child) =>
//               FadeTransition(opacity: animation, child: child),
//         ),
//       ),

//       GoRoute(
//         path: AppRoutes.legal,
//         pageBuilder: (_, state) => CustomTransitionPage(
//           key: state.pageKey,
//           child: LegalScreen(),
//           transitionsBuilder: (_, animation, __, child) =>
//               FadeTransition(opacity: animation, child: child),
//         ),
//       ),
//       GoRoute(
//         path: AppRoutes.changePassword,
//         pageBuilder: (_, state) => CustomTransitionPage(
//           key: state.pageKey,
//           child: const ChangePasswordScreen(),
//           transitionsBuilder: (_, animation, __, child) =>
//               FadeTransition(opacity: animation, child: child),
//         ),
//       ),

//       GoRoute(
//         path: AppRoutes.notifications,
//         pageBuilder: (_, state) => CustomTransitionPage(
//           key: state.pageKey,
//           child: const NotificationScreen(),
//           transitionsBuilder: (_, animation, __, child) =>
//               FadeTransition(opacity: animation, child: child),
//         ),
//       ),

//       GoRoute(
//         path: AppRoutes.notificationSettings,
//         pageBuilder: (_, state) => CustomTransitionPage(
//           key: state.pageKey,
//           child: const NotificationSettingsScreen(),
//           transitionsBuilder: (_, animation, __, child) =>
//               FadeTransition(opacity: animation, child: child),
//         ),
//       ),
//     ],
//     errorBuilder: (context, state) => Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 48, color: Colors.red),
//             const SizedBox(height: 12),
//             const Text('পেজ খুঁজে পাওয়া যায়নি'),
//             const SizedBox(height: 12),
//             TextButton(
//               onPressed: () => context.go(AppRoutes.home),
//               child: const Text('হোমে ফিরে যান'),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// });
// import 'package:amal_tracker/features/auth/providers/auth_provider.dart';
// import 'package:amal_tracker/features/auth/screens/login_screen.dart';
// import 'package:amal_tracker/features/auth/screens/register_screen.dart';
// import 'package:amal_tracker/features/home/screens/home_screen.dart';
// import 'package:amal_tracker/features/jannah_garden/screen/jannah_garden_screen.dart';
// import 'package:amal_tracker/features/leaderboard/screens/leaderboard_screen.dart';
// import 'package:amal_tracker/features/notification/screen/notification_screen.dart';
// import 'package:amal_tracker/features/notification/screen/notification_settings_screen.dart';
// import 'package:amal_tracker/features/settings/screens/legal_screen.dart';
// import 'package:amal_tracker/features/settings/screens/settings_screen.dart';
// import 'package:amal_tracker/features/tracker/screens/monthly_view_screen.dart';
// import 'package:amal_tracker/features/tracker/screens/tracker_screen.dart';
// import 'package:amal_tracker/features/user/screen/how_its_work_screen.dart';
// import 'package:amal_tracker/features/user/screen/password_change_screen.dart';
// import 'package:amal_tracker/features/user/screen/profile_edit_screen.dart';
// import 'package:amal_tracker/shared/widgets/main_shell.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// // ── Route path constants ───────────────────────────────────────────────────
// class AppRoutes {
//   static const login = '/login';
//   static const register = '/register';

//   // Shell tabs
//   static const home = '/home';
//   static const tracker = '/tracker';
//   static const monthlyView = '/monthly';
//   static const leaderboard = '/leaderboard';

//   // Full-screen (root navigator — no bottom nav)
//   static const profileEdit = '/profile/edit';
//   static const howItWorks = '/how-it-works';
//   static const settings = '/settings';
//   static const changePassword = '/change-password';
//   static const notifications = '/notifications';
//   static const notificationSettings = '/notification-settings';
//   static const legal = '/legal';
//   static const jannahGarden = '/jannah-garden';
// }

// // ── Navigator keys ─────────────────────────────────────────────────────────
// final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

// // Auth status listenable — GoRouter refreshes on change
// final _routerStatusController = ValueNotifier<AuthStatus>(AuthStatus.unknown);

// // ── Router provider ────────────────────────────────────────────────────────
// final routerProvider = Provider<GoRouter>((ref) {
//   ref.listen(
//     authProvider.select((s) => s.status),
//     (_, next) => _routerStatusController.value = next,
//   );

//   return GoRouter(
//     navigatorKey: _rootNavigatorKey,
//     initialLocation: AppRoutes.home,
//     refreshListenable: _routerStatusController,
//     redirect: (context, state) {
//       final status = _routerStatusController.value;

//       // Still initialising — don't redirect yet
//       if (status == AuthStatus.unknown) return null;

//       final isAuth = status == AuthStatus.authenticated;
//       final loc = state.matchedLocation;
//       final isAuthPage = loc == AppRoutes.login || loc == AppRoutes.register;

//       if (!isAuth && !isAuthPage) return AppRoutes.login;
//       if (isAuth && isAuthPage) return AppRoutes.home;
//       return null;
//     },
//     routes: [
//       // ── Auth ────────────────────────────────────────────────────────
//       GoRoute(
//         path: AppRoutes.login,
//         pageBuilder: (_, state) => CustomTransitionPage(
//           key: state.pageKey,
//           child: const LoginScreen(),
//           transitionsBuilder: (_, anim, __, child) =>
//               FadeTransition(opacity: anim, child: child),
//         ),
//       ),

//       GoRoute(
//         path: AppRoutes.register,
//         pageBuilder: (_, state) => CustomTransitionPage(
//           key: state.pageKey,
//           child: const RegisterScreen(),
//           transitionsBuilder: (_, anim, __, child) => SlideTransition(
//             position: Tween(
//               begin: const Offset(1, 0),
//               end: Offset.zero,
//             ).animate(
//                 CurvedAnimation(parent: anim, curve: Curves.easeInOutCubic)),
//             child: child,
//           ),
//         ),
//       ),

//       // ── Shell with tab branches ──────────────────────────────────────
//       StatefulShellRoute.indexedStack(
//         builder: (context, state, navigationShell) =>
//             MainShell(navigationShell: navigationShell),
//         branches: [
//           // Branch 0 — Home
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: AppRoutes.home,
//                 builder: (_, __) => const HomeScreen(),
//               ),
//             ],
//           ),

//           // Branch 1 — Tracker
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: AppRoutes.tracker,
//                 builder: (_, __) => const TrackerScreen(),
//               ),
//             ],
//           ),

//           // Branch 2 — Monthly
//           // UniqueKey() দিলে প্রতিবার fresh build হবে (stale state নেই)
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: AppRoutes.monthlyView,
//                 builder: (_, __) => MonthlyViewScreen(key: UniqueKey()),
//               ),
//             ],
//           ),

//           // Branch 3 — Leaderboard
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: AppRoutes.leaderboard,
//                 builder: (_, __) => LeaderboardScreen(key: UniqueKey()),
//               ),
//             ],
//           ),
//         ],
//       ),

//       // ── Full-screen routes (root navigator — shell/bottom nav bypass) ─
//       GoRoute(
//         path: AppRoutes.jannahGarden,
//         parentNavigatorKey: _rootNavigatorKey,
//         pageBuilder: (_, state) => CustomTransitionPage(
//           key: state.pageKey,
//           child: const JannahWorldScreen(),
//           transitionsBuilder: (_, anim, __, child) =>
//               FadeTransition(opacity: anim, child: child),
//         ),
//       ),

//       GoRoute(
//         path: AppRoutes.profileEdit,
//         parentNavigatorKey: _rootNavigatorKey,
//         pageBuilder: (_, state) => CustomTransitionPage(
//           key: state.pageKey,
//           child: const ProfileEditScreen(),
//           transitionsBuilder: (_, anim, __, child) =>
//               FadeTransition(opacity: anim, child: child),
//         ),
//       ),

//       GoRoute(
//         path: AppRoutes.settings,
//         parentNavigatorKey: _rootNavigatorKey,
//         pageBuilder: (_, state) => CustomTransitionPage(
//           key: state.pageKey,
//           child: const SettingsScreen(),
//           transitionsBuilder: (_, anim, __, child) =>
//               FadeTransition(opacity: anim, child: child),
//         ),
//       ),

//       GoRoute(
//         path: AppRoutes.changePassword,
//         parentNavigatorKey: _rootNavigatorKey,
//         pageBuilder: (_, state) => CustomTransitionPage(
//           key: state.pageKey,
//           child: const ChangePasswordScreen(),
//           transitionsBuilder: (_, anim, __, child) =>
//               FadeTransition(opacity: anim, child: child),
//         ),
//       ),

//       GoRoute(
//         path: AppRoutes.notifications,
//         parentNavigatorKey: _rootNavigatorKey,
//         pageBuilder: (_, state) => CustomTransitionPage(
//           key: state.pageKey,
//           child: const NotificationScreen(),
//           transitionsBuilder: (_, anim, __, child) =>
//               FadeTransition(opacity: anim, child: child),
//         ),
//       ),

//       GoRoute(
//         path: AppRoutes.notificationSettings,
//         parentNavigatorKey: _rootNavigatorKey,
//         pageBuilder: (_, state) => CustomTransitionPage(
//           key: state.pageKey,
//           child: const NotificationSettingsScreen(),
//           transitionsBuilder: (_, anim, __, child) =>
//               FadeTransition(opacity: anim, child: child),
//         ),
//       ),

//       GoRoute(
//         path: AppRoutes.legal,
//         parentNavigatorKey: _rootNavigatorKey,
//         pageBuilder: (_, state) => CustomTransitionPage(
//           key: state.pageKey,
//           child: LegalScreen(),
//           transitionsBuilder: (_, anim, __, child) =>
//               FadeTransition(opacity: anim, child: child),
//         ),
//       ),

//       GoRoute(
//         path: AppRoutes.howItWorks,
//         parentNavigatorKey: _rootNavigatorKey,
//         pageBuilder: (_, state) => CustomTransitionPage(
//           key: state.pageKey,
//           child: const HowItWorksScreen(),
//           transitionsBuilder: (_, anim, __, child) =>
//               FadeTransition(opacity: anim, child: child),
//         ),
//       ),
//     ],
//     errorBuilder: (context, state) => Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 48, color: Colors.red),
//             const SizedBox(height: 12),
//             const Text('পেজ খুঁজে পাওয়া যায়নি'),
//             const SizedBox(height: 12),
//             TextButton(
//               onPressed: () => context.go(AppRoutes.home),
//               child: const Text('হোমে ফিরে যান'),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// });
// lib/core/router/app_router.dart

import 'package:amal_tracker/features/auth/providers/auth_provider.dart';
import 'package:amal_tracker/features/auth/screens/forgot_password_screen.dart';
import 'package:amal_tracker/features/auth/screens/login_screen.dart';
import 'package:amal_tracker/features/auth/screens/register_screen.dart';
import 'package:amal_tracker/features/challenge/screens/challenge_list_screen.dart';
import 'package:amal_tracker/features/sadakah/screens/sadakah_screen.dart';

import 'package:amal_tracker/features/home/screens/home_screen.dart';
import 'package:amal_tracker/features/leaderboard/screens/leaderboard_screen.dart';
import 'package:amal_tracker/features/notification/screen/notification_screen.dart';
import 'package:amal_tracker/features/notification/screen/notification_settings_screen.dart';
import 'package:amal_tracker/features/onboarding/screens/onboarding_screen.dart';
import 'package:amal_tracker/features/settings/screens/legal_screen.dart';
import 'package:amal_tracker/features/settings/screens/settings_screen.dart';
import 'package:amal_tracker/features/settings/screens/about_us_screen.dart';
import 'package:amal_tracker/features/tracker/screens/monthly_view_screen.dart';
import 'package:amal_tracker/features/tracker/screens/tracker_screen.dart';
import 'package:amal_tracker/features/user/screen/how_its_work_screen.dart';
import 'package:amal_tracker/features/user/screen/password_change_screen.dart';
import 'package:amal_tracker/features/user/screen/profile_edit_screen.dart';
import 'package:amal_tracker/shared/widgets/main_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ── Route path constants ───────────────────────────────────────────────────
class AppRoutes {
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const verifyOtp = '/verify-otp';

  // Shell tabs
  static const home = '/home';
  static const tracker = '/tracker';
  static const monthlyView = '/monthly';
  static const leaderboard = '/leaderboard';

  // Full-screen (root navigator — no bottom nav)
  static const profileEdit = '/profile/edit';
  static const howItWorks = '/how-it-works';
  static const settings = '/settings';
  static const changePassword = '/change-password';
  static const notifications = '/notifications';
  static const notificationSettings = '/notification-settings';
  static const legal = '/legal';
  static const jannahGarden = '/jannah-garden';
  static const sadaqah = '/sadaqah';
  static const challenges = '/challenges';
  static const aboutUs = '/about-us';
}

// ── Navigator keys ─────────────────────────────────────────────────────────
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Set this from main() before runApp so the very first redirect is correct.
/// Then call router.refresh() (via the notifier) when onboarding completes.
final onboardingSeenNotifier = ValueNotifier<bool>(false);

// A single listenable that fires when authState or onboarding status changes
class _AuthRouterNotifier extends ChangeNotifier {
  _AuthRouterNotifier(Ref ref) {
    ref.listen(authProvider, (_, __) {
      notifyListeners();
    });
    onboardingSeenNotifier.addListener(notifyListeners);
  }
}

// ── Router provider ────────────────────────────────────────────────────────
final routerProvider = Provider<GoRouter>((ref) {
  final refreshListenable = _AuthRouterNotifier(ref);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final hasSeen = onboardingSeenNotifier.value;
      final loc = state.matchedLocation;

      // ── Step 1: Onboarding gate (runs before everything) ──────────────
      // First-ever install: show onboarding, block all other routes
      if (!hasSeen) {
        return loc == AppRoutes.onboarding ? null : AppRoutes.onboarding;
      }

      // ── Step 2: Auth & Email Verification gate ────────────────────────
      final authState = ref.read(authProvider);
      final status = authState.status;

      if (status == AuthStatus.unknown) return null; // still initialising

      final isAuth = status == AuthStatus.authenticated;
      final user = authState.user;
      final isEmailVerified =
          user?.isEmailVerified ?? user?.isVerified ?? false;

      final isAuthPage = loc == AppRoutes.login ||
          loc == AppRoutes.register ||
          loc == AppRoutes.forgotPassword;
      final isOtpPage = loc == AppRoutes.verifyOtp;

      // Case A: Unauthenticated user -> can access login, register, forgot-password, or verify-otp
      if (!isAuth) {
        if (!isAuthPage && !isOtpPage) return AppRoutes.login;
        return null;
      }

      // Case B: Authenticated user with UNVERIFIED email -> MUST go to verify-otp page
      if (!isEmailVerified) {
        if (!isOtpPage) return AppRoutes.verifyOtp;
        return null;
      }

      // Case C: Authenticated user with VERIFIED email -> cannot stay on auth/otp/onboarding pages
      if (isAuthPage || isOtpPage || loc == AppRoutes.onboarding) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      // ── Onboarding (root navigator — no shell/bottom nav) ───────────
      GoRoute(
        path: AppRoutes.onboarding,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      ),

      // ── Auth ────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      ),

      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
          transitionsBuilder: (_, anim, __, child) => SlideTransition(
            position: Tween(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeInOutCubic),
            ),
            child: child,
          ),
        ),
      ),

      GoRoute(
        path: AppRoutes.forgotPassword,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ForgotPasswordScreen(),
          transitionsBuilder: (_, anim, __, child) => SlideTransition(
            position: Tween(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeInOutCubic),
            ),
            child: child,
          ),
        ),
      ),

      GoRoute(
        path: AppRoutes.verifyOtp,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OtpVerificationScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      ),

      // GoRoute(
      //   path: AppRoutes.challenges,
      //   parentNavigatorKey: _rootNavigatorKey,
      //   pageBuilder: (_, state) => CustomTransitionPage(
      //     key: state.pageKey,
      //     child: const ChallengeListScreen(),
      //     transitionsBuilder: (_, anim, __, child) =>
      //         FadeTransition(opacity: anim, child: child),
      //   ),
      // ),

      // ── Shell with tab branches ──────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (_, __) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.tracker,
                builder: (_, __) => const TrackerScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.challenges,
                builder: (_, __) => const ChallengeListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.monthlyView,
                builder: (_, __) => const MonthlyViewScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.leaderboard,
                builder: (_, __) => const LeaderboardScreen(),
              ),
            ],
          ),
          // StatefulShellBranch(
          //   routes: [
          //     GoRoute(
          //       path: AppRoutes.group,
          //       builder: (_, __) => const GroupHomeScreen(),
          //     ),
          //   ],
          // ),
        ],
      ),

      // ── Full-screen routes ───────────────────────────────────────────
      // GoRoute(
      //   path: AppRoutes.jannahGarden,
      //   parentNavigatorKey: _rootNavigatorKey,
      //   pageBuilder: (_, state) => CustomTransitionPage(
      //     key: state.pageKey,
      //     child: const JannahWorldScreen(),
      //     transitionsBuilder: (_, anim, __, child) =>
      //         FadeTransition(opacity: anim, child: child),
      //   ),
      // ),
      GoRoute(
        path: AppRoutes.profileEdit,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ProfileEditScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SettingsScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ChangePasswordScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const NotificationScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.notificationSettings,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const NotificationSettingsScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.legal,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: LegalScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.aboutUs,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AboutUsScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.howItWorks,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HowItWorksScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.sadaqah,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SadaqahScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
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
