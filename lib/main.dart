import 'package:amal_tracker/core/services/connectivity_service.dart';
import 'package:amal_tracker/core/services/notification_service.dart';
import 'package:amal_tracker/core/services/push_notification_service.dart';
import 'package:amal_tracker/features/auth/providers/auth_provider.dart';
import 'package:amal_tracker/features/notification/model/notification_model.dart';
import 'package:amal_tracker/features/notification/provider/notification_provider.dart';
import 'package:amal_tracker/features/onboarding/provider/onboarding_provider.dart';
import 'package:amal_tracker/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'core/router/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// Top-level FCM background handler — MUST be top-level
@pragma('vm:entry-point')
Future<void> _fbBgHandler(RemoteMessage message) async {
  // backgroundHandler এখন ইন্টারনাল ট্রাই-ক্যাচ দিয়ে সুরক্ষিত
  await PushNotificationService.backgroundHandler(message);
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // ১. নেটিভ স্প্ল্যাশ স্ক্রিন প্রিজার্ভ করা
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // ২. ইউআই এবং অরিয়েন্টেশন সেটআপ (নিরাপদ, ট্রাই-ক্যাচ ছাড়া রাখা যায়)
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

  // ৩. কানেক্টিভিটি সার্ভিস ইনিশিয়ালাইজেশন
  try {
    await ConnectivityService.instance.initialize();
  } catch (e) {
    debugPrint("Connectivity Initialization Failed: $e");
  }

  // ৪. ফায়ারবেস কোর ইনিশিয়ালাইজেশন
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    // ব্যাকগ্রাউন্ড মেসেজ হ্যান্ডলার রেজিস্ট্রেশন
    FirebaseMessaging.onBackgroundMessage(_fbBgHandler);
  } catch (e) {
    debugPrint("Firebase Core Initialization Failed: $e");
  }

  // ৫. লোকাল নোটিফিকেশন সার্ভিস
  try {
    await NotificationService.instance.initialize();
  } catch (e) {
    debugPrint("Local Notification Initialization Failed: $e");
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ৬. এফসিএম পুশ সার্ভিস ইনিশিয়ালাইজেশন (AWAIT রিমুভ করা হয়েছে)
  // এটি ব্যাকগ্রাউন্ডে নিজের মতো কাজ করবে, প্রথম রানে টোকেন ফেইল করলেও অ্যাপ আটকাবে না।
  // ─────────────────────────────────────────────────────────────────────────
  PushNotificationService.instance.initialize();

  // ৭. অনবোর্ডিং ডেটা লোড
  try {
    final hasSeen = await loadOnboardingSeen();
    onboardingSeenNotifier.value = hasSeen;
  } catch (e) {
    debugPrint("Failed to load onboarding status: $e");
    onboardingSeenNotifier.value = false; // নিরাপদ ফলব্যাক
  }

  // ৮. অ্যাপ রান করা
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

  // Foreground FCM + opened-from-notification callbacks
  void _wirePushCallbacks() {
    PushNotificationService.instance.onMessageOpenedApp = (message) {
      _addPushToHistory(message);
      final route = message.data['route'] as String?;
      if (route != null && route.isNotEmpty) {
        ref.read(routerProvider).push(route);
      }
    };

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

  void _wireLocalNotificationTap() {
    NotificationService.instance.onNotificationTapped = (payload) {
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
      if (payload.route.isNotEmpty) {
        ref.read(routerProvider).push(payload.route);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = ref.watch(authProvider.select((state) => state.status));
    final router = ref.watch(routerProvider);

    // টোকেন চেকিং (Initializing) শেষ হওয়া মাত্র নেটিভ স্প্ল্যাশ স্ক্রিন রিমুভ হবে
    ref.listen<AuthStatus>(
      authProvider.select((state) => state.status),
      (previous, next) {
        if (previous == AuthStatus.unknown && next != AuthStatus.unknown) {
          FlutterNativeSplash.remove();
        }
      },
    );

    // টোকেন চেক চলাকালীন সময় GoRouter কে রেন্ডার হতে দেওয়া হবে না।
    if (authStatus == AuthStatus.unknown) {
      final themeMode = ref.watch(themeModeProvider);
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        home: const Scaffold(body: SizedBox.shrink()),
      );
    }

    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'আমল ট্র্যাকার',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('bn'),
      ],
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) {
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
