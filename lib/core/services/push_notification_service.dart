// // ============================================================
// // push_notification_service.dart
// // Firebase Cloud Messaging handler for Amal Tracker
// // Handles foreground, background, and terminated state
// // ============================================================

// import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'notification_service.dart';

// // ─── Background message handler (top-level, required by FCM) ─
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // NOTE: FlutterFire must be initialized here if needed
//   // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   debugPrint('[FCM] Background message: ${message.messageId}');
//   await PushNotificationService._handleBackgroundMessage(message);
// }

// // ─── Push Notification Service ────────────────────────────────
// class PushNotificationService {
//   PushNotificationService._();
//   static final PushNotificationService instance = PushNotificationService._();

//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;

//   // Callback: app opened from push notification (terminated/background)
//   void Function(RemoteMessage)? onMessageOpenedApp;

//   // Callback: foreground message received
//   void Function(RemoteMessage)? onForegroundMessage;

//   // ── Initialize ─────────────────────────────────────────────
//   Future<void> initialize() async {
//     // Set background handler BEFORE anything else
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//     // Request permission (iOS / Android 13+)
//     await _requestPermission();

//     // Subscribe to default topic
//     await _fcm.subscribeToTopic('all_users');

//     // Get and save FCM token
//     await _refreshAndSaveToken();

//     // Listen for token refresh
//     _fcm.onTokenRefresh.listen(_onTokenRefresh);

//     // Foreground message handler
//     FirebaseMessaging.onMessage.listen(_onForegroundMessage);

//     // App opened from background state via notification
//     FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

//     // Check if app was opened from terminated state
//     await _checkInitialMessage();

//     debugPrint('[PushService] Initialized');
//   }

//   // ── Get FCM Token ──────────────────────────────────────────
//   Future<String?> getFCMToken() async {
//     try {
//       return await _fcm.getToken();
//     } catch (e) {
//       debugPrint('[PushService] Token error: $e');
//       return null;
//     }
//   }

//   // ── Subscribe / Unsubscribe Topics ────────────────────────
//   Future<void> subscribeToTopic(String topic) async {
//     await _fcm.subscribeToTopic(topic);
//   }

//   Future<void> unsubscribeFromTopic(String topic) async {
//     await _fcm.unsubscribeFromTopic(topic);
//   }

//   // ── Private ────────────────────────────────────────────────
//   Future<void> _requestPermission() async {
//     final NotificationSettings settings = await _fcm.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     debugPrint('[PushService] Permission: ${settings.authorizationStatus}');
//   }

//   Future<void> _refreshAndSaveToken() async {
//     final String? token = await _fcm.getToken();
//     if (token != null) {
//       await _saveToken(token);
//       debugPrint('[PushService] FCM Token saved: ${token.substring(0, 20)}...');
//     }
//   }

//   void _onTokenRefresh(String token) {
//     _saveToken(token);
//     debugPrint('[PushService] Token refreshed');
//     // TODO: Send new token to your backend
//   }

//   Future<void> _saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('fcm_token', token);
//     final timestamp = DateTime.now().toIso8601String();
//     await prefs.setString('fcm_token_updated_at', timestamp);
//   }

//   void _onForegroundMessage(RemoteMessage message) {
//     debugPrint('[PushService] Foreground: ${message.notification?.title}');

//     // Display as local notification while app is open
//     _displayPushAsLocal(message);

//     // Save to in-app notification history
//     _saveToHistory(message);

//     onForegroundMessage?.call(message);
//   }

//   void _onMessageOpenedApp(RemoteMessage message) {
//     debugPrint('[PushService] Opened from background: ${message.data}');
//     _saveToHistory(message);
//     onMessageOpenedApp?.call(message);
//   }

//   Future<void> _checkInitialMessage() async {
//     // App opened from terminated state
//     final RemoteMessage? initialMessage = await _fcm.getInitialMessage();
//     if (initialMessage != null) {
//       debugPrint(
//           '[PushService] Opened from terminated: ${initialMessage.data}');
//       _saveToHistory(initialMessage);
//       // Delay to allow app to fully initialize before routing
//       Future.delayed(const Duration(milliseconds: 500), () {
//         onMessageOpenedApp?.call(initialMessage);
//       });
//     }
//   }

//   Future<void> _displayPushAsLocal(RemoteMessage message) async {
//     final notification = message.notification;
//     if (notification == null) return;

//     // Generate unique ID based on timestamp to avoid collisions
//     final int id = NotificationIds.pushBaseId +
//         (DateTime.now().millisecondsSinceEpoch % 1000);

//     await NotificationService.instance.showImmediate(
//       id: id,
//       title: notification.title ?? 'Amal Tracker',
//       body: notification.body ?? '',
//       payload: jsonEncode({
//         'type': 'push',
//         'data': message.data,
//         'messageId': message.messageId,
//       }),
//       channelType: NotificationChannelType.push,
//     );
//   }

//   static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
//     // Save to history even in background
//     final prefs = await SharedPreferences.getInstance();
//     final List<String> history = prefs.getStringList('push_history') ?? [];

//     final entry = jsonEncode({
//       'id': message.messageId ?? DateTime.now().toIso8601String(),
//       'title': message.notification?.title ?? 'Update',
//       'body': message.notification?.body ?? '',
//       'data': message.data,
//       'receivedAt': DateTime.now().toIso8601String(),
//       'isRead': false,
//       'source': 'push_background',
//     });

//     history.insert(0, entry);
//     // Keep max 100 entries
//     if (history.length > 100) history.removeRange(100, history.length);
//     await prefs.setStringList('push_history', history);
//   }

//   Future<void> _saveToHistory(RemoteMessage message) async {
//     final prefs = await SharedPreferences.getInstance();
//     final List<String> history = prefs.getStringList('push_history') ?? [];

//     final entry = jsonEncode({
//       'id': message.messageId ?? DateTime.now().toIso8601String(),
//       'title': message.notification?.title ?? 'Update',
//       'body': message.notification?.body ?? '',
//       'data': message.data,
//       'receivedAt': DateTime.now().toIso8601String(),
//       'isRead': false,
//       'source': 'push',
//     });

//     history.insert(0, entry);
//     if (history.length > 100) history.removeRange(100, history.length);
//     await prefs.setStringList('push_history', history);
//   }
// }
// ============================================================
// push_notification_service.dart
// Firebase Cloud Messaging handler for Amal Tracker
// Handles foreground, background, and terminated state
// ============================================================

// import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'notification_service.dart';

// // ─── Background message handler (top-level, required by FCM) ─
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // NOTE: FlutterFire must be initialized here if needed
//   // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   debugPrint('[FCM] Background message: ${message.messageId}');
//   await PushNotificationService._handleBackgroundMessage(message);
// }

// // ─── Push Notification Service ────────────────────────────────
// class PushNotificationService {
//   PushNotificationService._();
//   static final PushNotificationService instance = PushNotificationService._();

//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;

//   // Callback: app opened from push notification (terminated/background)
//   void Function(RemoteMessage)? onMessageOpenedApp;

//   // Callback: foreground message received
//   void Function(RemoteMessage)? onForegroundMessage;

//   // ── Initialize ─────────────────────────────────────────────
//   Future<void> initialize() async {
//     // Set background handler BEFORE anything else
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//     // Request permission (iOS / Android 13+)
//     await _requestPermission();

//     // Subscribe to default topic
//     await _fcm.subscribeToTopic('all_users');

//     // Get and save FCM token
//     await _refreshAndSaveToken();

//     // Listen for token refresh
//     _fcm.onTokenRefresh.listen(_onTokenRefresh);

//     // Foreground message handler
//     FirebaseMessaging.onMessage.listen(_onForegroundMessage);

//     // App opened from background state via notification
//     FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

//     // Check if app was opened from terminated state
//     await _checkInitialMessage();

//     debugPrint('[PushService] Initialized');
//   }

//   // ── Get FCM Token ──────────────────────────────────────────
//   Future<String?> getFCMToken() async {
//     try {
//       return await _fcm.getToken();
//     } catch (e) {
//       debugPrint('[PushService] Token error: $e');
//       return null;
//     }
//   }

//   // ── Subscribe / Unsubscribe Topics ────────────────────────
//   Future<void> subscribeToTopic(String topic) async {
//     await _fcm.subscribeToTopic(topic);
//   }

//   Future<void> unsubscribeFromTopic(String topic) async {
//     await _fcm.unsubscribeFromTopic(topic);
//   }

//   // ── Private ────────────────────────────────────────────────
//   Future<void> _requestPermission() async {
//     final NotificationSettings settings = await _fcm.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     debugPrint('[PushService] Permission: ${settings.authorizationStatus}');
//   }

//   Future<void> _refreshAndSaveToken() async {
//     final String? token = await _fcm.getToken();
//     if (token != null) {
//       await _saveToken(token);
//       debugPrint('[PushService] FCM Token saved: ${token.substring(0, 20)}...');
//     }
//   }

//   void _onTokenRefresh(String token) {
//     _saveToken(token);
//     debugPrint('[PushService] Token refreshed');
//     // TODO: Send new token to your backend
//   }

//   Future<void> _saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('fcm_token', token);
//     final timestamp = DateTime.now().toIso8601String();
//     await prefs.setString('fcm_token_updated_at', timestamp);
//   }

//   void _onForegroundMessage(RemoteMessage message) {
//     debugPrint('[PushService] Foreground: ${message.notification?.title}');

//     // Display as local notification while app is open
//     _displayPushAsLocal(message);

//     // Save to in-app notification history
//     _saveToHistory(message);

//     onForegroundMessage?.call(message);
//   }

//   void _onMessageOpenedApp(RemoteMessage message) {
//     debugPrint('[PushService] Opened from background: ${message.data}');
//     _saveToHistory(message);
//     onMessageOpenedApp?.call(message);
//   }

//   Future<void> _checkInitialMessage() async {
//     // App opened from terminated state
//     final RemoteMessage? initialMessage = await _fcm.getInitialMessage();
//     if (initialMessage != null) {
//       debugPrint(
//           '[PushService] Opened from terminated: ${initialMessage.data}');
//       _saveToHistory(initialMessage);
//       // Delay to allow app to fully initialize before routing
//       Future.delayed(const Duration(milliseconds: 500), () {
//         onMessageOpenedApp?.call(initialMessage);
//       });
//     }
//   }

//   Future<void> _displayPushAsLocal(RemoteMessage message) async {
//     final notification = message.notification;
//     if (notification == null) return;

//     // Generate unique ID based on timestamp to avoid collisions
//     final int id = NotificationIds.pushBaseId +
//         (DateTime.now().millisecondsSinceEpoch % 1000);

//     await NotificationService.instance.showImmediate(
//       id: id,
//       title: notification.title ?? 'Amal Tracker',
//       body: notification.body ?? '',
//       payload: jsonEncode({
//         'type': 'push',
//         'data': message.data,
//         'messageId': message.messageId,
//       }),
//       channelType: NotificationChannelType.push,
//     );
//   }

//   static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
//     // Save to history even in background
//     final prefs = await SharedPreferences.getInstance();
//     final List<String> history = prefs.getStringList('push_history') ?? [];

//     final entry = jsonEncode({
//       'id': message.messageId ?? DateTime.now().toIso8601String(),
//       'title': message.notification?.title ?? 'Update',
//       'body': message.notification?.body ?? '',
//       'data': message.data,
//       'receivedAt': DateTime.now().toIso8601String(),
//       'isRead': false,
//       'source': 'push_background',
//     });

//     history.insert(0, entry);
//     // Keep max 100 entries
//     if (history.length > 100) history.removeRange(100, history.length);
//     await prefs.setStringList('push_history', history);
//   }

//   Future<void> _saveToHistory(RemoteMessage message) async {
//     final prefs = await SharedPreferences.getInstance();
//     final List<String> history = prefs.getStringList('push_history') ?? [];

//     final entry = jsonEncode({
//       'id': message.messageId ?? DateTime.now().toIso8601String(),
//       'title': message.notification?.title ?? 'Update',
//       'body': message.notification?.body ?? '',
//       'data': message.data,
//       'receivedAt': DateTime.now().toIso8601String(),
//       'isRead': false,
//       'source': 'push',
//     });

//     history.insert(0, entry);
//     if (history.length > 100) history.removeRange(100, history.length);
//     await prefs.setStringList('push_history', history);
//   }
// }
// ============================================================
// push_notification_service.dart
// Firebase Cloud Messaging handler for Amal Tracker
// Handles foreground, background, and terminated state
// ============================================================

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_service.dart';

// ─── Background message handler (top-level, required by FCM) ─
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // NOTE: FlutterFire must be initialized here if needed
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('[FCM] Background message: ${message.messageId}');
  await PushNotificationService._handleBackgroundMessage(message);
}

// ─── Push Notification Service ────────────────────────────────
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Callback: app opened from push notification (terminated/background)
  void Function(RemoteMessage)? onMessageOpenedApp;

  // Callback: foreground message received
  void Function(RemoteMessage)? onForegroundMessage;

  // ── Initialize ─────────────────────────────────────────────
  Future<void> initialize() async {
    // Set background handler BEFORE anything else
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request permission (iOS / Android 13+)
    await _requestPermission();

    // Subscribe to default topic
    await _fcm.subscribeToTopic('all_users');

    // Get and save FCM token
    await _refreshAndSaveToken();

    // Listen for token refresh
    _fcm.onTokenRefresh.listen(_onTokenRefresh);

    // Foreground message handler
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // App opened from background state via notification
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Check if app was opened from terminated state
    await _checkInitialMessage();

    debugPrint('[PushService] Initialized');
  }

  // ── Get FCM Token ──────────────────────────────────────────
  Future<String?> getFCMToken() async {
    try {
      return await _fcm.getToken();
    } catch (e) {
      debugPrint('[PushService] Token error: $e');
      return null;
    }
  }

  // ── Subscribe / Unsubscribe Topics ────────────────────────
  Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(topic);
  }

  // ── Private ────────────────────────────────────────────────
  Future<void> _requestPermission() async {
    final NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint('[PushService] Permission: ${settings.authorizationStatus}');
  }

  Future<void> _refreshAndSaveToken() async {
    final String? token = await _fcm.getToken();
    if (token != null) {
      await _saveToken(token);
      debugPrint('[PushService] FCM Token saved: ${token.substring(0, 20)}...');
    }
  }

  void _onTokenRefresh(String token) {
    _saveToken(token);
    debugPrint('[PushService] Token refreshed');
    // TODO: Send new token to your backend
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
    final timestamp = DateTime.now().toIso8601String();
    await prefs.setString('fcm_token_updated_at', timestamp);
  }

  void _onForegroundMessage(RemoteMessage message) {
    debugPrint('[PushService] Foreground: ${message.notification?.title}');

    // Display as local notification while app is open
    _displayPushAsLocal(message);

    // Save to in-app notification history
    _saveToHistory(message);

    onForegroundMessage?.call(message);
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint('[PushService] Opened from background: ${message.data}');
    _saveToHistory(message);
    onMessageOpenedApp?.call(message);
  }

  Future<void> _checkInitialMessage() async {
    // App opened from terminated state
    final RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      debugPrint(
          '[PushService] Opened from terminated: ${initialMessage.data}');
      _saveToHistory(initialMessage);
      // Delay to allow app to fully initialize before routing
      Future.delayed(const Duration(milliseconds: 500), () {
        onMessageOpenedApp?.call(initialMessage);
      });
    }
  }

  Future<void> _displayPushAsLocal(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    // Generate unique ID based on timestamp to avoid collisions
    final int id = NotificationIds.pushBaseId +
        (DateTime.now().millisecondsSinceEpoch % 1000);

    await NotificationService.instance.showImmediate(
      id: id,
      title: notification.title ?? 'Amal Tracker',
      body: notification.body ?? '',
      payload: jsonEncode({
        'type': 'push',
        'data': message.data,
        'messageId': message.messageId,
      }),
      channelType: NotificationChannelType.push,
    );
  }

  /// Public alias used by the top-level FCM background handler in main.dart
  static Future<void> backgroundHandler(RemoteMessage message) =>
      _handleBackgroundMessage(message);

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    // Save to history even in background
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList('push_history') ?? [];

    final entry = jsonEncode({
      'id': message.messageId ?? DateTime.now().toIso8601String(),
      'title': message.notification?.title ?? 'Update',
      'body': message.notification?.body ?? '',
      'data': message.data,
      'receivedAt': DateTime.now().toIso8601String(),
      'isRead': false,
      'source': 'push_background',
    });

    history.insert(0, entry);
    // Keep max 100 entries
    if (history.length > 100) history.removeRange(100, history.length);
    await prefs.setStringList('push_history', history);
  }

  Future<void> _saveToHistory(RemoteMessage message) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList('push_history') ?? [];

    final entry = jsonEncode({
      'id': message.messageId ?? DateTime.now().toIso8601String(),
      'title': message.notification?.title ?? 'Update',
      'body': message.notification?.body ?? '',
      'data': message.data,
      'receivedAt': DateTime.now().toIso8601String(),
      'isRead': false,
      'source': 'push',
    });

    history.insert(0, entry);
    if (history.length > 100) history.removeRange(100, history.length);
    await prefs.setStringList('push_history', history);
  }
}
