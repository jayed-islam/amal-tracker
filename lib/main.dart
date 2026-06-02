// import 'package:amal_tracker/core/services/connectivity_service.dart';
// import 'package:amal_tracker/core/services/notification_service.dart';
// import 'package:amal_tracker/core/services/push_notification_service.dart';
// import 'package:amal_tracker/features/notification/model/notification_model.dart';
// import 'package:amal_tracker/features/notification/provider/notification_provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'core/theme/app_theme.dart';
// import 'core/router/app_router.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

// // Global navigator key for notification-driven navigation
// final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await ConnectivityService.instance.initialize();

//   // Lock to portrait + landscape
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//     DeviceOrientation.landscapeLeft,
//     DeviceOrientation.landscapeRight,
//   ]);

//   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//     statusBarColor: Colors.transparent,
//     statusBarIconBrightness: Brightness.dark,
//     systemNavigationBarColor: Colors.white,
//     systemNavigationBarIconBrightness: Brightness.dark,
//   ));

//   // ── 1. Firebase (required before FCM) ───────────────────
//   await Firebase.initializeApp(
//       // options: DefaultFirebaseOptions.currentPlatform,
//       );

//   // ── 2. Local Notification Service ───────────────────────
//   await NotificationService.instance.initialize();

//   // ── 3. Push Notification Service ────────────────────────
//   await PushNotificationService.instance.initialize();

//   runApp(const ProviderScope(child: AmalTrackerApp()));
// }

// class AmalTrackerApp extends ConsumerStatefulWidget {
//   const AmalTrackerApp({super.key});

//   @override
//   ConsumerState<AmalTrackerApp> createState() => _AmalTrackerAppState();
// }

// class _AmalTrackerAppState extends ConsumerState<AmalTrackerApp> {
//   @override
//   void initState() {
//     super.initState();
//     _wirePushCallbacks();
//   }

//   void _wirePushCallbacks() {
//     // When app is opened from background/terminated via push
//     PushNotificationService.instance.onMessageOpenedApp = (message) {
//       _handlePushNavigation(message.data);
//     };

//     // Foreground push — add to in-app history
//     PushNotificationService.instance.onForegroundMessage = (message) {
//       final provider = context.read<NotificationProvider>();
//       provider.addToHistory(
//         AppNotification(
//           id: message.messageId ?? DateTime.now().toIso8601String(),
//           title: message.notification?.title ?? 'Update',
//           body: message.notification?.body ?? '',
//           type: _pushTypeFromData(message.data),
//           receivedAt: DateTime.now(),
//           route: message.data['route'] as String?,
//           data: message.data,
//         ),
//       );
//     };

//     // Local notification tap navigation
//     NotificationService.instance.onNotificationTapped = (payload) {
//       _navigatorKey.currentState?.pushNamed(payload.route);
//     };
//   }

//   void _handlePushNavigation(Map<String, dynamic> data) {
//     final String? route = data['route'] as String?;
//     if (route != null) {
//       _navigatorKey.currentState?.pushNamed(route);
//     }
//   }

//   NotificationType _pushTypeFromData(Map<String, dynamic> data) {
//     final String type = data['notification_type'] as String? ?? '';
//     return NotificationType.values.firstWhere(
//       (t) => t.name == type,
//       orElse: () => NotificationType.push,
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final router = ref.watch(routerProvider);

//     return MaterialApp.router(
//       title: 'আমল ট্র্যাকার',
//       debugShowCheckedModeBanner: false,
//       localizationsDelegates: const [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: const [
//         Locale('en'),
//         Locale('bn'),
//       ],
//       theme: AppTheme.light,
//       routerConfig: router,
//       builder: (context, child) {
//         // Ensure text doesn't scale beyond 1.3x for accessibility
//         return MediaQuery(
//           data: MediaQuery.of(context).copyWith(
//             textScaler: TextScaler.linear(
//               MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.3),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//   }
// }
import 'package:amal_tracker/core/services/connectivity_service.dart';
import 'package:amal_tracker/core/services/notification_service.dart';
import 'package:amal_tracker/core/services/push_notification_service.dart';
import 'package:amal_tracker/features/auth/providers/auth_provider.dart';
import 'package:amal_tracker/features/notification/model/notification_model.dart';
import 'package:amal_tracker/features/notification/provider/notification_provider.dart';
import 'package:amal_tracker/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

// Top-level FCM background handler — MUST be top-level
@pragma('vm:entry-point')
Future<void> _fbBgHandler(RemoteMessage message) async {
  // If you use Firebase elsewhere, Firebase.initializeApp() is already done.
  // Otherwise uncomment:
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PushNotificationService.backgroundHandler(message);
}

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  // WidgetsFlutterBinding.ensureInitialized();

  await ConnectivityService.instance.initialize();

  // Lock to portrait + landscape
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register FCM background handler BEFORE runApp
  FirebaseMessaging.onBackgroundMessage(_fbBgHandler);

  // Local notification service
  await NotificationService.instance.initialize();

  // FCM push service
  await PushNotificationService.instance.initialize();

  runApp(const ProviderScope(child: AmalTrackerApp()));
}

/// Global key — needed for notification-driven navigation
final navigatorKey = GlobalKey<NavigatorState>();

class AmalTrackerApp extends ConsumerStatefulWidget {
  const AmalTrackerApp({super.key});

  @override
  ConsumerState<AmalTrackerApp> createState() => _AmalTrackerAppState();
}

class _AmalTrackerAppState extends ConsumerState<AmalTrackerApp> {
  @override
  void initState() {
    super.initState();
    _wirePushCallbacks();
    _wireLocalNotificationTap();
  }

  // void _dismissSplashWhenReady() {
  //   // Runs once when isInitializing flips false
  //   ref.listenManual(isInitializingProvider, (_, isInitializing) {
  //     if (!isInitializing) FlutterNativeSplash.remove();
  //   });
  // }

  // Foreground FCM + opened-from-notification callbacks
  void _wirePushCallbacks() {
    // App opened from background / terminated via push notification
    PushNotificationService.instance.onMessageOpenedApp = (message) {
      _addPushToHistory(message);
      final route = message.data['route'] as String?;
      if (route != null) {
        navigatorKey.currentState?.pushNamed(route);
      }
    };

    // Foreground push — show in-app history
    PushNotificationService.instance.onForegroundMessage = (message) {
      _addPushToHistory(message);
    };
  }

  void _addPushToHistory(RemoteMessage message) {
    final notif = AppNotification(
      id: message.messageId ?? DateTime.now().toIso8601String(),
      title: message.notification?.title ?? 'আপডেট',
      body: message.notification?.body ?? '',
      type: NotificationType.push,
      receivedAt: DateTime.now(),
      route: message.data['route'] as String?,
      data: message.data,
    );
    ref.read(notificationHistoryProvider.notifier).add(notif);
  }

  // Local notification tapped — navigate to the right screen
  void _wireLocalNotificationTap() {
    NotificationService.instance.onNotificationTapped = (payload) {
      // Add to history
      final notif = AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: payload.type.label,
        body: 'নোটিফিকেশন থেকে খোলা হয়েছে',
        type: payload.type,
        receivedAt: DateTime.now(),
        isRead: true,
        route: payload.route,
      );
      ref.read(notificationHistoryProvider.notifier).add(notif);
      // Navigate
      navigatorKey.currentState?.pushNamed(payload.route);
    };
  }

  @override
  Widget build(BuildContext context) {
    // Use ref.watch instead of ref.watch with BuildContext
    // final router = ref.watch(routerProvider);
    final router = ref.watch(routerProvider);

    // টোকেন চেকিং (Initializing) শেষ হওয়া মাত্র নেটিভ স্প্ল্যাশ স্ক্রিন রিমুভ হবে
    ref.listen<AuthStatus>(
      authProvider.select((state) => state.status),
      (previous, next) {
        if (previous == AuthStatus.unknown && next != AuthStatus.unknown) {
          FlutterNativeSplash.remove();
        }
      },
    );

    return MaterialApp.router(
      title: 'আমল ট্র্যাকার',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('bn'),
      ],
      theme: AppTheme.light,
      routerConfig: router,
      builder: (context, child) {
        // Ensure text doesn't scale beyond 1.3x for accessibility
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.3),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
