import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettings {
  final bool dailyReminderEnabled;
  final TimeOfDay dailyReminderTime;
  final String dailyReminderMessage;

  final bool weeklyReviewEnabled;
  final int weeklyReviewWeekday;
  final TimeOfDay weeklyReviewTime;

  final bool streakAlertEnabled;
  final TimeOfDay streakAlertTime;
  final int currentStreak;

  final bool pushNotificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;

  const NotificationSettings({
    this.dailyReminderEnabled = true,
    this.dailyReminderTime = const TimeOfDay(hour: 20, minute: 0),
    this.dailyReminderMessage = 'আজকের আমল লগ করতে ভুলবেন না! ৳',
    this.weeklyReviewEnabled = true,
    this.weeklyReviewWeekday = DateTime.friday,
    this.weeklyReviewTime = const TimeOfDay(hour: 18, minute: 0),
    this.streakAlertEnabled = true,
    this.streakAlertTime = const TimeOfDay(hour: 21, minute: 30),
    this.currentStreak = 0,
    this.pushNotificationsEnabled = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });

  NotificationSettings copyWith({
    bool? dailyReminderEnabled,
    TimeOfDay? dailyReminderTime,
    String? dailyReminderMessage,
    bool? weeklyReviewEnabled,
    int? weeklyReviewWeekday,
    TimeOfDay? weeklyReviewTime,
    bool? streakAlertEnabled,
    TimeOfDay? streakAlertTime,
    int? currentStreak,
    bool? pushNotificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) =>
      NotificationSettings(
        dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
        dailyReminderTime: dailyReminderTime ?? this.dailyReminderTime,
        dailyReminderMessage: dailyReminderMessage ?? this.dailyReminderMessage,
        weeklyReviewEnabled: weeklyReviewEnabled ?? this.weeklyReviewEnabled,
        weeklyReviewWeekday: weeklyReviewWeekday ?? this.weeklyReviewWeekday,
        weeklyReviewTime: weeklyReviewTime ?? this.weeklyReviewTime,
        streakAlertEnabled: streakAlertEnabled ?? this.streakAlertEnabled,
        streakAlertTime: streakAlertTime ?? this.streakAlertTime,
        currentStreak: currentStreak ?? this.currentStreak,
        pushNotificationsEnabled:
            pushNotificationsEnabled ?? this.pushNotificationsEnabled,
        soundEnabled: soundEnabled ?? this.soundEnabled,
        vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      );

  static const _p = 'notif_settings_';

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${_p}daily_on', dailyReminderEnabled);
    await prefs.setInt('${_p}daily_h', dailyReminderTime.hour);
    await prefs.setInt('${_p}daily_m', dailyReminderTime.minute);
    await prefs.setString('${_p}daily_msg', dailyReminderMessage);
    await prefs.setBool('${_p}weekly_on', weeklyReviewEnabled);
    await prefs.setInt('${_p}weekly_day', weeklyReviewWeekday);
    await prefs.setInt('${_p}weekly_h', weeklyReviewTime.hour);
    await prefs.setInt('${_p}weekly_m', weeklyReviewTime.minute);
    await prefs.setBool('${_p}streak_on', streakAlertEnabled);
    await prefs.setInt('${_p}streak_h', streakAlertTime.hour);
    await prefs.setInt('${_p}streak_m', streakAlertTime.minute);
    await prefs.setInt('${_p}streak_count', currentStreak);
    await prefs.setBool('${_p}push_on', pushNotificationsEnabled);
    await prefs.setBool('${_p}sound_on', soundEnabled);
    await prefs.setBool('${_p}vibration_on', vibrationEnabled);
  }

  static Future<NotificationSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    const d = NotificationSettings();
    return NotificationSettings(
      dailyReminderEnabled:
          prefs.getBool('${_p}daily_on') ?? d.dailyReminderEnabled,
      dailyReminderTime: TimeOfDay(
        hour: prefs.getInt('${_p}daily_h') ?? d.dailyReminderTime.hour,
        minute: prefs.getInt('${_p}daily_m') ?? d.dailyReminderTime.minute,
      ),
      dailyReminderMessage:
          prefs.getString('${_p}daily_msg') ?? d.dailyReminderMessage,
      weeklyReviewEnabled:
          prefs.getBool('${_p}weekly_on') ?? d.weeklyReviewEnabled,
      weeklyReviewWeekday:
          prefs.getInt('${_p}weekly_day') ?? d.weeklyReviewWeekday,
      weeklyReviewTime: TimeOfDay(
        hour: prefs.getInt('${_p}weekly_h') ?? d.weeklyReviewTime.hour,
        minute: prefs.getInt('${_p}weekly_m') ?? d.weeklyReviewTime.minute,
      ),
      streakAlertEnabled:
          prefs.getBool('${_p}streak_on') ?? d.streakAlertEnabled,
      streakAlertTime: TimeOfDay(
        hour: prefs.getInt('${_p}streak_h') ?? d.streakAlertTime.hour,
        minute: prefs.getInt('${_p}streak_m') ?? d.streakAlertTime.minute,
      ),
      currentStreak: prefs.getInt('${_p}streak_count') ?? d.currentStreak,
      pushNotificationsEnabled:
          prefs.getBool('${_p}push_on') ?? d.pushNotificationsEnabled,
      soundEnabled: prefs.getBool('${_p}sound_on') ?? d.soundEnabled,
      vibrationEnabled:
          prefs.getBool('${_p}vibration_on') ?? d.vibrationEnabled,
    );
  }
}
