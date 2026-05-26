// // ============================================================
// // notification_provider.dart
// // ChangeNotifier for notification settings + history
// // Wire to your app's Provider/Riverpod/Bloc layer
// // ============================================================

// import 'dart:convert';
// import 'package:amal_tracker/core/services/notification_service.dart';
// import 'package:amal_tracker/features/notification/model/notification_model.dart';
// import 'package:amal_tracker/features/notification/model/notification_setting_model.dart'
//     as ns;
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class NotificationProvider extends ChangeNotifier {
//   ns.NotificationSettings _settings = const ns.NotificationSettings();
//   List<AppNotification> _notifications = [];
//   bool _hasPermission = false;
//   bool _isLoading = true;
//   int _unreadCount = 0;

//   // ── Getters ─────────────────────────────────────────────
//   ns.NotificationSettings get settings => _settings;
//   List<AppNotification> get notifications => List.unmodifiable(_notifications);
//   bool get hasPermission => _hasPermission;
//   bool get isLoading => _isLoading;
//   int get unreadCount => _unreadCount;

//   // Grouped by date for notification center
//   Map<String, List<AppNotification>> get groupedNotifications {
//     final Map<String, List<AppNotification>> grouped = {};
//     for (final notif in _notifications) {
//       final String key = _dateKey(notif.receivedAt);
//       grouped.putIfAbsent(key, () => []).add(notif);
//     }
//     return grouped;
//   }

//   // ── Initialize ──────────────────────────────────────────
//   Future<void> initialize() async {
//     _isLoading = true;
//     notifyListeners();

//     _settings = await ns.NotificationSettings.load();
//     _hasPermission = await NotificationService.instance.hasPermission();
//     await _loadHistory();

//     // Register tap callback
//     NotificationService.instance.onNotificationTapped = _onNotificationTapped;

//     _isLoading = false;
//     notifyListeners();
//   }

//   // ── Update Settings ─────────────────────────────────────
//   Future<void> updateSettings(ns.NotificationSettings newSettings) async {
//     _settings = newSettings;
//     await _settings.save();

//     // Reschedule all notifications with new settings
//     await NotificationService.instance.rescheduleFromSettings(_settings);

//     notifyListeners();
//   }

//   // ── Request Permission ──────────────────────────────────
//   Future<bool> requestPermission() async {
//     final granted = await NotificationService.instance.requestPermission();
//     _hasPermission = granted;
//     if (granted) {
//       await NotificationService.instance.rescheduleFromSettings(_settings);
//     }
//     notifyListeners();
//     return granted;
//   }

//   // ── Mark as Read ────────────────────────────────────────
//   Future<void> markAsRead(String id) async {
//     final index = _notifications.indexWhere((n) => n.id == id);
//     if (index == -1) return;
//     _notifications[index] = _notifications[index].copyWith(isRead: true);
//     _unreadCount = _notifications.where((n) => !n.isRead).length;
//     await _saveHistory();
//     notifyListeners();
//   }

//   Future<void> markAllAsRead() async {
//     _notifications =
//         _notifications.map((n) => n.copyWith(isRead: true)).toList();
//     _unreadCount = 0;
//     await _saveHistory();
//     notifyListeners();
//   }

//   Future<void> deleteNotification(String id) async {
//     _notifications.removeWhere((n) => n.id == id);
//     _unreadCount = _notifications.where((n) => !n.isRead).length;
//     await _saveHistory();
//     notifyListeners();
//   }

//   Future<void> clearAll() async {
//     _notifications.clear();
//     _unreadCount = 0;
//     await _saveHistory();
//     notifyListeners();
//   }

//   // ── Add notification to history (called from service callbacks) ─
//   Future<void> addToHistory(AppNotification notification) async {
//     _notifications.insert(0, notification);
//     if (!notification.isRead) _unreadCount++;
//     if (_notifications.length > 200) {
//       _notifications.removeRange(200, _notifications.length);
//     }
//     await _saveHistory();
//     notifyListeners();
//   }

//   // ── Update streak (call when user logs amal) ─────────────
//   Future<void> updateStreak(int newStreak) async {
//     _settings = _settings.copyWith(currentStreak: newStreak);
//     await _settings.save();
//     // Reschedule streak notification with updated streak count
//     if (_settings.streakAlertEnabled) {
//       await NotificationService.instance.scheduleStreakAlert(
//         time: _settings.streakAlertTime,
//         currentStreak: newStreak,
//         enabled: true,
//       );
//     }
//     notifyListeners();
//   }

//   // ── Private ─────────────────────────────────────────────
//   void _onNotificationTapped(NotificationTapPayload payload) {
//     // Add local notification to in-app history when tapped
//     // Navigation is handled by the router listening to this provider
//     final appNotif = AppNotification(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       title: payload.type.label,
//       body: 'Tapped from notification',
//       type: payload.type,
//       receivedAt: DateTime.now(),
//       isRead: true, // Already tapped = read
//       route: payload.route,
//     );
//     addToHistory(appNotif);
//   }

//   Future<void> _loadHistory() async {
//     final prefs = await SharedPreferences.getInstance();
//     final List<String> raw = prefs.getStringList('app_notif_history') ?? [];
//     _notifications = raw
//         .map((s) {
//           try {
//             return AppNotification.fromJson(
//                 jsonDecode(s) as Map<String, dynamic>);
//           } catch (_) {
//             return null;
//           }
//         })
//         .whereType<AppNotification>()
//         .toList();
//     _unreadCount = _notifications.where((n) => !n.isRead).length;
//   }

//   Future<void> _saveHistory() async {
//     final prefs = await SharedPreferences.getInstance();
//     final raw = _notifications.map((n) => jsonEncode(n.toJson())).toList();
//     await prefs.setStringList('app_notif_history', raw);
//   }

//   String _dateKey(DateTime dt) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final yesterday = today.subtract(const Duration(days: 1));
//     final date = DateTime(dt.year, dt.month, dt.day);

//     if (date == today) return 'Today';
//     if (date == yesterday) return 'Yesterday';

//     const months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec'
//     ];
//     return '${months[dt.month - 1]} ${dt.day}';
//   }
// }
// ============================================================
// notification_provider.dart
// Riverpod state management for notifications
// Drop into your existing Riverpod setup — no extra packages
// ============================================================

// import 'dart:convert';
// import 'package:amal_tracker/core/services/notification_service.dart';
// import 'package:amal_tracker/features/notification/model/notification_model.dart';
// import 'package:amal_tracker/features/notification/model/notification_setting_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // ─── Shared Preferences Provider ─────────────────────────────
// // If you already have this in your app, import it instead
// final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
//   throw UnimplementedError('Override in ProviderScope overrides');
// });

// // ─── Notification Settings State ─────────────────────────────

// class NotificationSettingsNotifier extends AsyncNotifier<NotificationSettings> {
//   @override
//   Future<NotificationSettings> build() async {
//     return NotificationSettings.load();
//   }

//   /// Save + reschedule all notifications
//   Future<void> updateSettings(NotificationSettings updated) async {
//     state = const AsyncValue.loading();
//     await updated.save();
//     await NotificationService.instance.rescheduleFromSettings(updated);
//     state = AsyncValue.data(updated);
//   }

//   /// Update a single field and reschedule
//   Future<void> toggleDailyReminder(bool enabled) async {
//     final current = state.valueOrNull;
//     if (current == null) return;
//     await updateSettings(current.copyWith(dailyReminderEnabled: enabled));
//   }

//   Future<void> setDailyReminderTime(TimeOfDay time) async {
//     final current = state.valueOrNull;
//     if (current == null) return;
//     await updateSettings(current.copyWith(dailyReminderTime: time));
//   }

//   Future<void> setDailyMessage(String message) async {
//     final current = state.valueOrNull;
//     if (current == null) return;
//     await updateSettings(current.copyWith(dailyReminderMessage: message));
//   }

//   Future<void> toggleWeeklyReview(bool enabled) async {
//     final current = state.valueOrNull;
//     if (current == null) return;
//     await updateSettings(current.copyWith(weeklyReviewEnabled: enabled));
//   }

//   Future<void> setWeeklyDay(int weekday) async {
//     final current = state.valueOrNull;
//     if (current == null) return;
//     await updateSettings(current.copyWith(weeklyReviewWeekday: weekday));
//   }

//   Future<void> setWeeklyTime(TimeOfDay time) async {
//     final current = state.valueOrNull;
//     if (current == null) return;
//     await updateSettings(current.copyWith(weeklyReviewTime: time));
//   }

//   Future<void> toggleStreakAlert(bool enabled) async {
//     final current = state.valueOrNull;
//     if (current == null) return;
//     await updateSettings(current.copyWith(streakAlertEnabled: enabled));
//   }

//   Future<void> setStreakAlertTime(TimeOfDay time) async {
//     final current = state.valueOrNull;
//     if (current == null) return;
//     await updateSettings(current.copyWith(streakAlertTime: time));
//   }

//   Future<void> togglePush(bool enabled) async {
//     final current = state.valueOrNull;
//     if (current == null) return;
//     await updateSettings(current.copyWith(pushNotificationsEnabled: enabled));
//   }

//   Future<void> toggleSound(bool enabled) async {
//     final current = state.valueOrNull;
//     if (current == null) return;
//     await updateSettings(current.copyWith(soundEnabled: enabled));
//   }

//   Future<void> toggleVibration(bool enabled) async {
//     final current = state.valueOrNull;
//     if (current == null) return;
//     await updateSettings(current.copyWith(vibrationEnabled: enabled));
//   }

//   /// Called when user logs amal — updates streak & reschedules alert
//   Future<void> onAmalLogged(int newStreak) async {
//     final current = state.valueOrNull;
//     if (current == null) return;
//     final updated = current.copyWith(currentStreak: newStreak);
//     await updated.save();
//     if (updated.streakAlertEnabled) {
//       await NotificationService.instance.scheduleStreakAlert(
//         time: updated.streakAlertTime,
//         currentStreak: newStreak,
//         enabled: true,
//       );
//     }
//     state = AsyncValue.data(updated);
//   }
// }

// final notificationSettingsProvider =
//     AsyncNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
//   NotificationSettingsNotifier.new,
// );

// // ─── Notification Permission State ────────────────────────────

// class NotificationPermissionNotifier extends AsyncNotifier<bool> {
//   @override
//   Future<bool> build() async {
//     return NotificationService.instance.hasPermission();
//   }

//   Future<bool> requestPermission() async {
//     final granted = await NotificationService.instance.requestPermission();
//     state = AsyncValue.data(granted);
//     if (granted) {
//       // Reschedule after permission granted
//       final settings = await ref.read(notificationSettingsProvider.future);
//       await NotificationService.instance.rescheduleFromSettings(settings);
//     }
//     return granted;
//   }

//   Future<void> refresh() async {
//     final has = await NotificationService.instance.hasPermission();
//     state = AsyncValue.data(has);
//   }
// }

// final notificationPermissionProvider =
//     AsyncNotifierProvider<NotificationPermissionNotifier, bool>(
//   NotificationPermissionNotifier.new,
// );

// // ─── Notification History State ───────────────────────────────

// class NotificationHistoryNotifier extends AsyncNotifier<List<AppNotification>> {
//   static const String _key = 'app_notif_history';

//   @override
//   Future<List<AppNotification>> build() async {
//     return _loadFromPrefs();
//   }

//   Future<void> add(AppNotification notification) async {
//     final current = state.valueOrNull ?? [];
//     final updated = [notification, ...current];
//     final capped = updated.length > 200 ? updated.sublist(0, 200) : updated;
//     state = AsyncValue.data(capped);
//     await _saveToPrefs(capped);
//   }

//   Future<void> markAsRead(String id) async {
//     final current = state.valueOrNull ?? [];
//     final updated =
//         current.map((n) => n.id == id ? n.copyWith(isRead: true) : n).toList();
//     state = AsyncValue.data(updated);
//     await _saveToPrefs(updated);
//   }

//   Future<void> markAllAsRead() async {
//     final current = state.valueOrNull ?? [];
//     final updated = current.map((n) => n.copyWith(isRead: true)).toList();
//     state = AsyncValue.data(updated);
//     await _saveToPrefs(updated);
//   }

//   Future<void> delete(String id) async {
//     final current = state.valueOrNull ?? [];
//     final updated = current.where((n) => n.id != id).toList();
//     state = AsyncValue.data(updated);
//     await _saveToPrefs(updated);
//   }

//   Future<void> clearAll() async {
//     state = const AsyncValue.data([]);
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_key);
//   }

//   // ── helpers ─────────────────────────────────────────────
//   Future<List<AppNotification>> _loadFromPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     final raw = prefs.getStringList(_key) ?? [];
//     return raw
//         .map((s) {
//           try {
//             return AppNotification.fromJson(
//                 jsonDecode(s) as Map<String, dynamic>);
//           } catch (_) {
//             return null;
//           }
//         })
//         .whereType<AppNotification>()
//         .toList();
//   }

//   Future<void> _saveToPrefs(List<AppNotification> list) async {
//     final prefs = await SharedPreferences.getInstance();
//     final raw = list.map((n) => jsonEncode(n.toJson())).toList();
//     await prefs.setStringList(_key, raw);
//   }
// }

// final notificationHistoryProvider =
//     AsyncNotifierProvider<NotificationHistoryNotifier, List<AppNotification>>(
//   NotificationHistoryNotifier.new,
// );

// // ─── Derived: Unread Count ────────────────────────────────────
// final unreadNotificationCountProvider = Provider<int>((ref) {
//   final history = ref.watch(notificationHistoryProvider);
//   return history.whenOrNull(
//         data: (list) => list.where((n) => !n.isRead).length,
//       ) ??
//       0;
// });

// // ─── Derived: Grouped by date (for notification center UI) ────
// final groupedNotificationsProvider =
//     Provider<Map<String, List<AppNotification>>>((ref) {
//   final history = ref.watch(notificationHistoryProvider);
//   return history.whenOrNull(
//         data: (list) => _groupByDate(list),
//       ) ??
//       {};
// });

// Map<String, List<AppNotification>> _groupByDate(List<AppNotification> items) {
//   final Map<String, List<AppNotification>> grouped = {};
//   for (final item in items) {
//     final key = _dateLabel(item.receivedAt);
//     grouped.putIfAbsent(key, () => []).add(item);
//   }
//   return grouped;
// }

// String _dateLabel(DateTime dt) {
//   final now = DateTime.now();
//   final today = DateTime(now.year, now.month, now.day);
//   final yesterday = today.subtract(const Duration(days: 1));
//   final date = DateTime(dt.year, dt.month, dt.day);
//   if (date == today) return 'আজ'; // Today in Bangla
//   if (date == yesterday) return 'গতকাল'; // Yesterday in Bangla
//   // Format: দিন মাস (Bangla months)
//   const months = [
//     'জানুয়ারি',
//     'ফেব্রুয়ারি',
//     'মার্চ',
//     'এপ্রিল',
//     'মে',
//     'জুন',
//     'জুলাই',
//     'আগস্ট',
//     'সেপ্টেম্বর',
//     'অক্টোবর',
//     'নভেম্বর',
//     'ডিসেম্বর',
//   ];
//   return '${dt.day} ${months[dt.month - 1]}';
// }
// ============================================================
// notification_provider.dart
// Riverpod state management for notifications
// Drop into your existing Riverpod setup — no extra packages
// ============================================================

import 'dart:convert';
import 'package:amal_tracker/core/services/notification_service.dart';
import 'package:amal_tracker/features/notification/model/notification_model.dart';
import 'package:amal_tracker/features/notification/model/notification_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Shared Preferences Provider ─────────────────────────────
// If you already have this in your app, import it instead
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override in ProviderScope overrides');
});

// ─── Notification Settings State ─────────────────────────────

class NotificationSettingsNotifier extends AsyncNotifier<NotificationSettings> {
  @override
  Future<NotificationSettings> build() async {
    return NotificationSettings.load();
  }

  /// Save + reschedule all notifications.
  /// NOTE: Never set state = AsyncValue.loading() here.
  /// The screen manages its own _isSaving spinner.
  /// Setting loading() triggers when(loading:) and wipes the entire scaffold UI.
  Future<void> updateSettings(NotificationSettings updated) async {
    await updated.save();
    await NotificationService.instance.rescheduleFromSettings(updated);
    state = AsyncValue.data(updated);
  }

  /// Update a single field and reschedule
  Future<void> toggleDailyReminder(bool enabled) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await updateSettings(current.copyWith(dailyReminderEnabled: enabled));
  }

  Future<void> setDailyReminderTime(TimeOfDay time) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await updateSettings(current.copyWith(dailyReminderTime: time));
  }

  Future<void> setDailyMessage(String message) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await updateSettings(current.copyWith(dailyReminderMessage: message));
  }

  Future<void> toggleWeeklyReview(bool enabled) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await updateSettings(current.copyWith(weeklyReviewEnabled: enabled));
  }

  Future<void> setWeeklyDay(int weekday) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await updateSettings(current.copyWith(weeklyReviewWeekday: weekday));
  }

  Future<void> setWeeklyTime(TimeOfDay time) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await updateSettings(current.copyWith(weeklyReviewTime: time));
  }

  Future<void> toggleStreakAlert(bool enabled) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await updateSettings(current.copyWith(streakAlertEnabled: enabled));
  }

  Future<void> setStreakAlertTime(TimeOfDay time) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await updateSettings(current.copyWith(streakAlertTime: time));
  }

  Future<void> togglePush(bool enabled) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await updateSettings(current.copyWith(pushNotificationsEnabled: enabled));
  }

  Future<void> toggleSound(bool enabled) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await updateSettings(current.copyWith(soundEnabled: enabled));
  }

  Future<void> toggleVibration(bool enabled) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await updateSettings(current.copyWith(vibrationEnabled: enabled));
  }

  /// Called when user logs amal — updates streak & reschedules alert
  Future<void> onAmalLogged(int newStreak) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = current.copyWith(currentStreak: newStreak);
    await updated.save();
    if (updated.streakAlertEnabled) {
      await NotificationService.instance.scheduleStreakAlert(
        time: updated.streakAlertTime,
        currentStreak: newStreak,
        enabled: true,
      );
    }
    state = AsyncValue.data(updated);
  }
}

final notificationSettingsProvider =
    AsyncNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
  NotificationSettingsNotifier.new,
);

// ─── Notification Permission State ────────────────────────────

class NotificationPermissionNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    return NotificationService.instance.hasPermission();
  }

  Future<bool> requestPermission() async {
    final granted = await NotificationService.instance.requestPermission();
    state = AsyncValue.data(granted);
    if (granted) {
      // Reschedule after permission granted
      final settings = await ref.read(notificationSettingsProvider.future);
      await NotificationService.instance.rescheduleFromSettings(settings);
    }
    return granted;
  }

  Future<void> refresh() async {
    final has = await NotificationService.instance.hasPermission();
    state = AsyncValue.data(has);
  }
}

final notificationPermissionProvider =
    AsyncNotifierProvider<NotificationPermissionNotifier, bool>(
  NotificationPermissionNotifier.new,
);

// ─── Notification History State ───────────────────────────────

class NotificationHistoryNotifier extends AsyncNotifier<List<AppNotification>> {
  static const String _key = 'app_notif_history';

  @override
  Future<List<AppNotification>> build() async {
    return _loadFromPrefs();
  }

  Future<void> add(AppNotification notification) async {
    final current = state.valueOrNull ?? [];
    final updated = [notification, ...current];
    final capped = updated.length > 200 ? updated.sublist(0, 200) : updated;
    state = AsyncValue.data(capped);
    await _saveToPrefs(capped);
  }

  Future<void> markAsRead(String id) async {
    final current = state.valueOrNull ?? [];
    final updated =
        current.map((n) => n.id == id ? n.copyWith(isRead: true) : n).toList();
    state = AsyncValue.data(updated);
    await _saveToPrefs(updated);
  }

  Future<void> markAllAsRead() async {
    final current = state.valueOrNull ?? [];
    final updated = current.map((n) => n.copyWith(isRead: true)).toList();
    state = AsyncValue.data(updated);
    await _saveToPrefs(updated);
  }

  Future<void> delete(String id) async {
    final current = state.valueOrNull ?? [];
    final updated = current.where((n) => n.id != id).toList();
    state = AsyncValue.data(updated);
    await _saveToPrefs(updated);
  }

  Future<void> clearAll() async {
    state = const AsyncValue.data([]);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  // ── helpers ─────────────────────────────────────────────
  Future<List<AppNotification>> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map((s) {
          try {
            return AppNotification.fromJson(
                jsonDecode(s) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<AppNotification>()
        .toList();
  }

  Future<void> _saveToPrefs(List<AppNotification> list) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = list.map((n) => jsonEncode(n.toJson())).toList();
    await prefs.setStringList(_key, raw);
  }
}

final notificationHistoryProvider =
    AsyncNotifierProvider<NotificationHistoryNotifier, List<AppNotification>>(
  NotificationHistoryNotifier.new,
);

// ─── Derived: Unread Count ────────────────────────────────────
final unreadNotificationCountProvider = Provider<int>((ref) {
  final history = ref.watch(notificationHistoryProvider);
  return history.whenOrNull(
        data: (list) => list.where((n) => !n.isRead).length,
      ) ??
      0;
});

// ─── Derived: Grouped by date (for notification center UI) ────
final groupedNotificationsProvider =
    Provider<Map<String, List<AppNotification>>>((ref) {
  final history = ref.watch(notificationHistoryProvider);
  return history.whenOrNull(
        data: (list) => _groupByDate(list),
      ) ??
      {};
});

Map<String, List<AppNotification>> _groupByDate(List<AppNotification> items) {
  final Map<String, List<AppNotification>> grouped = {};
  for (final item in items) {
    final key = _dateLabel(item.receivedAt);
    grouped.putIfAbsent(key, () => []).add(item);
  }
  return grouped;
}

String _dateLabel(DateTime dt) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final date = DateTime(dt.year, dt.month, dt.day);
  if (date == today) return 'আজ'; // Today in Bangla
  if (date == yesterday) return 'গতকাল'; // Yesterday in Bangla
  // Format: দিন মাস (Bangla months)
  const months = [
    'জানুয়ারি',
    'ফেব্রুয়ারি',
    'মার্চ',
    'এপ্রিল',
    'মে',
    'জুন',
    'জুলাই',
    'আগস্ট',
    'সেপ্টেম্বর',
    'অক্টোবর',
    'নভেম্বর',
    'ডিসেম্বর',
  ];
  return '${dt.day} ${months[dt.month - 1]}';
}

// ─── Re-export TimeOfDay so pages don't need extra import ────
// (TimeOfDay is from flutter/material.dart — already imported in service)
// export 'package:flutter/material.dart' show TimeOfDay;
