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
