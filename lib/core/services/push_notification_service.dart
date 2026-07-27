import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_service.dart';

// ─── Background message handler (top-level, required by FCM) ─
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
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
  /// এই মেথডটি কোনো অবস্থাতেই ক্র্যাশ বা মেইন থ্রেডকে ব্লক করবে না।
  Future<void> initialize() async {
    try {
      // ১. পারমিশন রিকোয়েস্ট (iOS / Android 13+)
      await _requestPermission();
    } catch (e) {
      debugPrint('[PushService] Permission request failed: $e');
    }

    // ২. টোকেন কালেকশন এবং টপিক সাবস্ক্রিপশন সম্পূর্ণ সেফ জোনে ব্যাকগ্রাউন্ডে রান করবে
    // এগুলো ফেইল করলেও নিচের লিসেনারগুলো কাজ করা বন্ধ করবে না।
    _refreshAndSaveTokenWithRetry();
    _subscribeToDefaultTopicWithRetry();

    // ৩. ফোরগ্রাউন্ড মেসেজ হ্যান্ডলার
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // ৪. অ্যাপ ব্যাকগ্রাউন্ড থেকে নোটিফিকেশনের মাধ্যমে ওপেন হলে লিসেনার
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // ৫. অ্যাপ টার্মিনেটেড স্টেট থেকে ওপেন হলে চেক করা
    try {
      await _checkInitialMessage();
    } catch (e) {
      debugPrint('[PushService] Check initial message failed: $e');
    }

    debugPrint('[PushService] Initialized Successfully');
  }

  // ── Robust Topic Subscription Loop ──────────────────────────
  Future<void> _subscribeToDefaultTopicWithRetry() async {
    int retryCount = 0;
    const int maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        await _fcm.subscribeToTopic('all_users');
        debugPrint('[PushService] Successfully subscribed to topic: all_users');
        break;
      } catch (e) {
        retryCount++;
        debugPrint(
            '[PushService] Topic subscription failed (Attempt $retryCount/$maxRetries): $e');
        if (retryCount >= maxRetries) {
          debugPrint(
              '[PushService] Giving up on initial topic subscription. FCM will retry automatically in background.');
          break;
        }
        await Future.delayed(const Duration(seconds: 5));
      }
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _fcm.subscribeToTopic(topic);
    } catch (e) {
      debugPrint('[PushService] Dynamic subscription failed for $topic: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _fcm.unsubscribeFromTopic(topic);
    } catch (e) {
      debugPrint('[PushService] Unsubscription failed for $topic: $e');
    }
  }

  // ── Get FCM Token ──────────────────────────────────────────
  Future<String?> getFCMToken() async {
    try {
      return await _fcm.getToken();
    } catch (e) {
      debugPrint('[PushService] Token error inside getFCMToken(): $e');
      return null;
    }
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

  /// টোকেন জেনারেট করার সময় try-catch এবং Retry লজিক হ্যান্ডেল করে (আপনার মূল সমস্যার সমাধান)
  Future<void> _refreshAndSaveTokenWithRetry() async {
    int retryCount = 0;
    const int maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        final String? token = await _fcm.getToken();
        if (token != null) {
          await _saveToken(token);
          debugPrint(
              '[PushService] FCM Token saved: ${token.substring(0, 20)}...');

          // টোকেন রিফ্রেশ লিসেনার সেট করা
          _fcm.onTokenRefresh.listen(_onTokenRefresh);
          break;
        }
      } catch (e) {
        retryCount++;
        debugPrint(
            '[PushService] Token fetch failed (Attempt $retryCount/$maxRetries): $e');
        if (retryCount >= maxRetries) {
          debugPrint(
              '[PushService] Failed to fetch token after max retries. Moving on to let app start.');
          break;
        }
        // ৩ সেকেন্ড অপেক্ষা করে আবার ট্রাই করবে নেটওয়ার্ক ফিরে পাওয়ার জন্য
        await Future.delayed(const Duration(seconds: 3));
      }
    }
  }

  void _onTokenRefresh(String token) {
    _saveToken(token);
    debugPrint('[PushService] Token refreshed');
    // TODO: Send new token to your backend API here
  }

  Future<void> _saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
      final timestamp = DateTime.now().toIso8601String();
      await prefs.setString('fcm_token_updated_at', timestamp);
    } catch (e) {
      debugPrint('[PushService] Failed to save token to SharedPreferences: $e');
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    debugPrint('[PushService] Foreground: ${message.notification?.title}');
    _displayPushAsLocal(message);
    _saveToHistory(message);
    onForegroundMessage?.call(message);
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint('[PushService] Opened from background: ${message.data}');
    _saveToHistory(message);
    onMessageOpenedApp?.call(message);
  }

  Future<void> _checkInitialMessage() async {
    final RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      debugPrint(
          '[PushService] Opened from terminated: ${initialMessage.data}');
      _saveToHistory(initialMessage);
      Future.delayed(const Duration(milliseconds: 500), () {
        onMessageOpenedApp?.call(initialMessage);
      });
    }
  }

  Future<void> _displayPushAsLocal(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final int id = NotificationIds.pushBaseId +
        (DateTime.now().millisecondsSinceEpoch % 1000);

    try {
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
    } catch (e) {
      debugPrint('[PushService] Local notification display failed: $e');
    }
  }

  static Future<void> backgroundHandler(RemoteMessage message) =>
      _handleBackgroundMessage(message);

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    try {
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
      if (history.length > 100) history.removeRange(100, history.length);
      await prefs.setStringList('push_history', history);
    } catch (e) {
      debugPrint('[PushService] Background history save failed: $e');
    }
  }

  Future<void> _saveToHistory(RemoteMessage message) async {
    try {
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
    } catch (e) {
      debugPrint('[PushService] History save failed: $e');
    }
  }
}
