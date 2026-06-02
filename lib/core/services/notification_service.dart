import 'dart:io';
import 'dart:convert';
import 'package:amal_tracker/features/notification/model/notification_model.dart';
import 'package:amal_tracker/features/notification/model/notification_setting_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Notification IDs (stable, never change these) ───────────
// 3 active local notifications as per requirement
class NotificationIds {
  static const int dailyAmalReminder = 1001; // Daily amal submission
  static const int weeklyReview = 1002; // Weekly review/summary
  static const int streakAlert = 1003; // Streak motivation

  // FCM / push display IDs start from 2000
  static const int pushBaseId = 2000;
}

// ─── Notification Channels (Android) ─────────────────────────
class NotificationChannels {
  static const AndroidNotificationChannel dailyReminder =
      AndroidNotificationChannel(
    'amal_daily_reminder',
    'Daily Amal Reminder',
    description: 'Reminds you to log your daily amal',
    importance: Importance.high,
    enableLights: true,
    enableVibration: true,
    playSound: true,
  );

  static const AndroidNotificationChannel weeklyReview =
      AndroidNotificationChannel(
    'amal_weekly_review',
    'Weekly Review',
    description: 'Weekly amal review and progress summary',
    importance: Importance.defaultImportance,
    enableLights: true,
    enableVibration: false,
  );

  static const AndroidNotificationChannel streakAlert =
      AndroidNotificationChannel(
    'amal_streak_alert',
    'Streak Alerts',
    description: 'Motivational alerts for your amal streak',
    importance: Importance.high,
    enableLights: true,
    enableVibration: true,
  );

  static const AndroidNotificationChannel push = AndroidNotificationChannel(
    'amal_push',
    'App Updates & Announcements',
    description: 'Important updates and announcements from Amal Tracker',
    importance: Importance.high,
    enableLights: true,
    enableVibration: true,
  );
}

// ─── Notification Service ─────────────────────────────────────
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  // Callback for when notification is tapped (set by app)
  void Function(NotificationTapPayload)? onNotificationTapped;

  // ── Initialize ─────────────────────────────────────────────
  Future<void> initialize() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();
    final TimezoneInfo timezoneInfo = await FlutterTimezone.getLocalTimezone();
    final String timezoneName = timezoneInfo.identifier; // ← correct property
    tz.setLocalLocation(tz.getLocation(timezoneName));
    // tz.initializeTimeZones();
    // final String timezoneName = await FlutterTimezone.getLocalTimezone();
    // tz.setLocalLocation(tz.getLocation(timezoneName));

    // Android init settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS init settings
    final DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false, // Ask separately at right moment
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: _buildIOSCategories(),
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse:
          _onBackgroundNotificationTapped,
    );

    // Create Android channels
    await _createAndroidChannels();

    _isInitialized = true;
    debugPrint(
        '[NotificationService] Initialized with timezone: $timezoneName');
  }

  // ── Request Permission ──────────────────────────────────────
  Future<bool> requestPermission() async {
    if (Platform.isIOS) {
      final bool? granted = await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    }

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImpl =
          _plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final bool? granted = await androidImpl?.requestNotificationsPermission();
      return granted ?? false;
    }

    return true;
  }

  Future<bool> hasPermission() async {
    if (Platform.isIOS) {
      final impl = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      // Check if we've been authorized previously
      return impl != null;
    }
    if (Platform.isAndroid) {
      final impl = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      return await impl?.areNotificationsEnabled() ?? false;
    }
    return false;
  }

  // ── Schedule: Daily Amal Reminder ──────────────────────────
  Future<void> scheduleDailyAmalReminder({
    required TimeOfDay time,
    required String message,
    bool enabled = true,
  }) async {
    await _plugin.cancel(NotificationIds.dailyAmalReminder);
    if (!enabled) return;

    final tz.TZDateTime scheduledTime = _nextInstanceOfTime(time);

    await _plugin.zonedSchedule(
      NotificationIds.dailyAmalReminder,
      '📿 Daily Amal Reminder',
      message,
      scheduledTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationChannels.dailyReminder.id,
          NotificationChannels.dailyReminder.name,
          channelDescription: NotificationChannels.dailyReminder.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          styleInformation: BigTextStyleInformation(message),
          actions: [
            const AndroidNotificationAction(
              'action_log_now',
              'Log Now',
              showsUserInterface: true,
              cancelNotification: true,
            ),
            const AndroidNotificationAction(
              'action_snooze_30',
              'Snooze 30m',
              cancelNotification: true,
            ),
          ],
        ),
        iOS: const DarwinNotificationDetails(
          categoryIdentifier: 'DAILY_AMAL',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: 'default',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
      payload: jsonEncode(NotificationTapPayload(
        type: NotificationType.dailyAmal,
        route: '/log-amal',
      ).toJson()),
    );

    debugPrint(
        '[NotificationService] Daily amal scheduled at ${time.hour}:${time.minute.toString().padLeft(2, '0')}');
    await _saveScheduleLog(NotificationIds.dailyAmalReminder, scheduledTime);
  }

  // ── Schedule: Weekly Review ─────────────────────────────────
  Future<void> scheduleWeeklyReview({
    required int weekday, // DateTime.monday = 1
    required TimeOfDay time,
    bool enabled = true,
  }) async {
    await _plugin.cancel(NotificationIds.weeklyReview);
    if (!enabled) return;

    final tz.TZDateTime scheduledTime = _nextInstanceOfWeekday(weekday, time);

    await _plugin.zonedSchedule(
      NotificationIds.weeklyReview,
      '📊 Weekly Amal Review',
      'Your weekly amal summary is ready. See how you did this week!',
      scheduledTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationChannels.weeklyReview.id,
          NotificationChannels.weeklyReview.name,
          channelDescription: NotificationChannels.weeklyReview.description,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          styleInformation: const BigTextStyleInformation(
            'Your weekly amal summary is ready. Tap to review your progress, see your streak, and plan for next week.',
          ),
        ),
        iOS: const DarwinNotificationDetails(
          categoryIdentifier: 'WEEKLY_REVIEW',
          presentAlert: true,
          presentBadge: false,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: jsonEncode(NotificationTapPayload(
        type: NotificationType.weeklyReview,
        route: '/weekly-review',
      ).toJson()),
    );

    debugPrint(
        '[NotificationService] Weekly review scheduled on weekday $weekday at ${time.hour}:${time.minute}');
    await _saveScheduleLog(NotificationIds.weeklyReview, scheduledTime);
  }

  // ── Schedule: Streak Alert ──────────────────────────────────
  Future<void> scheduleStreakAlert({
    required TimeOfDay time,
    required int currentStreak,
    bool enabled = true,
  }) async {
    await _plugin.cancel(NotificationIds.streakAlert);
    if (!enabled) return;

    // Schedule slightly before end-of-day to warn if not logged
    final String streakMsg = currentStreak > 0
        ? "🔥 Don't break your $currentStreak day streak! Log your amal today."
        : "Start a new streak today! Log your first amal now.";

    final tz.TZDateTime scheduledTime = _nextInstanceOfTime(time);

    await _plugin.zonedSchedule(
      NotificationIds.streakAlert,
      '🔥 Streak Alert',
      streakMsg,
      scheduledTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationChannels.streakAlert.id,
          NotificationChannels.streakAlert.name,
          channelDescription: NotificationChannels.streakAlert.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFFFF6B35),
          actions: [
            const AndroidNotificationAction(
              'action_log_now',
              'Log Now',
              showsUserInterface: true,
              cancelNotification: true,
            ),
          ],
        ),
        iOS: const DarwinNotificationDetails(
          categoryIdentifier: 'STREAK_ALERT',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: jsonEncode(NotificationTapPayload(
        type: NotificationType.streakAlert,
        route: '/log-amal',
      ).toJson()),
    );

    debugPrint(
        '[NotificationService] Streak alert scheduled at ${time.hour}:${time.minute}');
    await _saveScheduleLog(NotificationIds.streakAlert, scheduledTime);
  }

  // ── Cancel individual notifications ─────────────────────────
  Future<void> cancelDailyAmalReminder() async {
    await _plugin.cancel(NotificationIds.dailyAmalReminder);
  }

  Future<void> cancelWeeklyReview() async {
    await _plugin.cancel(NotificationIds.weeklyReview);
  }

  Future<void> cancelStreakAlert() async {
    await _plugin.cancel(NotificationIds.streakAlert);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // ── Show immediate notification (for testing / push display) ─
  Future<void> showImmediate({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationChannelType channelType = NotificationChannelType.push,
  }) async {
    final channel = _channelForType(channelType);

    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          styleInformation: BigTextStyleInformation(body),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  // ── Get pending notifications ─────────────────────────────
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _plugin.pendingNotificationRequests();
  }

  // ── Reschedule all from saved settings ─────────────────────
  Future<void> rescheduleFromSettings(NotificationSettings settings) async {
    // Daily amal
    await scheduleDailyAmalReminder(
      time: settings.dailyReminderTime,
      message: settings.dailyReminderMessage,
      enabled: settings.dailyReminderEnabled,
    );

    // Weekly review
    await scheduleWeeklyReview(
      weekday: settings.weeklyReviewWeekday,
      time: settings.weeklyReviewTime,
      enabled: settings.weeklyReviewEnabled,
    );

    // Streak alert
    await scheduleStreakAlert(
      time: settings.streakAlertTime,
      currentStreak: settings.currentStreak,
      enabled: settings.streakAlertEnabled,
    );
  }

  // ── Private helpers ─────────────────────────────────────────
  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  tz.TZDateTime _nextInstanceOfWeekday(int weekday, TimeOfDay time) {
    tz.TZDateTime scheduled = _nextInstanceOfTime(time);
    while (scheduled.weekday != weekday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  AndroidNotificationChannel _channelForType(NotificationChannelType type) {
    switch (type) {
      case NotificationChannelType.daily:
        return NotificationChannels.dailyReminder;
      case NotificationChannelType.weekly:
        return NotificationChannels.weeklyReview;
      case NotificationChannelType.streak:
        return NotificationChannels.streakAlert;
      case NotificationChannelType.push:
        return NotificationChannels.push;
    }
  }

  Future<void> _createAndroidChannels() async {
    if (!Platform.isAndroid) return;
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl == null) return;

    await androidImpl
        .createNotificationChannel(NotificationChannels.dailyReminder);
    await androidImpl
        .createNotificationChannel(NotificationChannels.weeklyReview);
    await androidImpl
        .createNotificationChannel(NotificationChannels.streakAlert);
    await androidImpl.createNotificationChannel(NotificationChannels.push);
  }

  List<DarwinNotificationCategory> _buildIOSCategories() {
    return [
      DarwinNotificationCategory(
        'DAILY_AMAL',
        actions: [
          DarwinNotificationAction.plain('action_log_now', 'Log Now',
              options: {DarwinNotificationActionOption.foreground}),
          DarwinNotificationAction.plain('action_snooze_30', 'Snooze 30m'),
        ],
      ),
      DarwinNotificationCategory(
        'STREAK_ALERT',
        actions: [
          DarwinNotificationAction.plain('action_log_now', 'Log Now',
              options: {DarwinNotificationActionOption.foreground}),
        ],
      ),
      const DarwinNotificationCategory('WEEKLY_REVIEW'),
    ];
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('[NotificationService] Tapped: ${response.payload}');
    _handleActionOrTap(response);
  }

  void _handleActionOrTap(NotificationResponse response) {
    if (response.payload == null) return;
    try {
      final payload = NotificationTapPayload.fromJson(
          jsonDecode(response.payload!) as Map<String, dynamic>);

      // Handle action buttons
      if (response.actionId == 'action_snooze_30') {
        _snooze30Minutes(response.id ?? 0, payload);
        return;
      }

      onNotificationTapped?.call(payload);
    } catch (e) {
      debugPrint('[NotificationService] Payload parse error: $e');
    }
  }

  Future<void> _snooze30Minutes(
      int originalId, NotificationTapPayload payload) async {
    final tz.TZDateTime snoozeTime =
        tz.TZDateTime.now(tz.local).add(const Duration(minutes: 30));
    await _plugin.zonedSchedule(
      originalId,
      '📿 Daily Amal Reminder (Snoozed)',
      'Snoozed reminder — time to log your amal!',
      snoozeTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationChannels.dailyReminder.id,
          NotificationChannels.dailyReminder.name,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
            presentAlert: true, presentSound: true),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: jsonEncode(payload.toJson()),
    );
  }

  Future<void> _saveScheduleLog(int id, tz.TZDateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'notif_schedule_$id',
      time.toIso8601String(),
    );
  }
}

// Background handler — must be top-level function
@pragma('vm:entry-point')
void _onBackgroundNotificationTapped(NotificationResponse response) {
  debugPrint('[NotificationService] Background tap: ${response.payload}');
  // Route handling will be picked up when app opens
}

enum NotificationChannelType { daily, weekly, streak, push }
