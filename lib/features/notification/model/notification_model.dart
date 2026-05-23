// // ============================================================
// // notification_model.dart
// // All data models for the notification system
// // ============================================================

// import 'package:flutter/material.dart';

// // ─── Notification Type ────────────────────────────────────────
// enum NotificationType {
//   dailyAmal,
//   weeklyReview,
//   streakAlert,
//   push,
//   unknown;

//   String get label {
//     switch (this) {
//       case NotificationType.dailyAmal:
//         return 'Daily Amal';
//       case NotificationType.weeklyReview:
//         return 'Weekly Review';
//       case NotificationType.streakAlert:
//         return 'Streak Alert';
//       case NotificationType.push:
//         return 'App Update';
//       case NotificationType.unknown:
//         return 'Notification';
//     }
//   }

//   IconData get icon {
//     switch (this) {
//       case NotificationType.dailyAmal:
//         return Icons.auto_awesome;
//       case NotificationType.weeklyReview:
//         return Icons.bar_chart_rounded;
//       case NotificationType.streakAlert:
//         return Icons.local_fire_department;
//       case NotificationType.push:
//         return Icons.campaign_rounded;
//       case NotificationType.unknown:
//         return Icons.notifications;
//     }
//   }

//   Color get color {
//     switch (this) {
//       case NotificationType.dailyAmal:
//         return const Color(0xFF6C63FF);
//       case NotificationType.weeklyReview:
//         return const Color(0xFF00BFA5);
//       case NotificationType.streakAlert:
//         return const Color(0xFFFF6B35);
//       case NotificationType.push:
//         return const Color(0xFF2196F3);
//       case NotificationType.unknown:
//         return const Color(0xFF9E9E9E);
//     }
//   }
// }

// // ─── Tap Payload ──────────────────────────────────────────────
// class NotificationTapPayload {
//   final NotificationType type;
//   final String route;
//   final Map<String, dynamic>? extra;

//   const NotificationTapPayload({
//     required this.type,
//     required this.route,
//     this.extra,
//   });

//   factory NotificationTapPayload.fromJson(Map<String, dynamic> json) {
//     return NotificationTapPayload(
//       type: NotificationType.values.firstWhere(
//         (e) => e.name == json['type'],
//         orElse: () => NotificationType.unknown,
//       ),
//       route: json['route'] as String? ?? '/',
//       extra: json['extra'] as Map<String, dynamic>?,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'type': type.name,
//         'route': route,
//         if (extra != null) 'extra': extra,
//       };
// }

// // ─── In-App Notification History Item ────────────────────────
// class AppNotification {
//   final String id;
//   final String title;
//   final String body;
//   final NotificationType type;
//   final DateTime receivedAt;
//   bool isRead;
//   final String? route;
//   final Map<String, dynamic>? data;

//   AppNotification({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.type,
//     required this.receivedAt,
//     this.isRead = false,
//     this.route,
//     this.data,
//   });

//   factory AppNotification.fromJson(Map<String, dynamic> json) {
//     return AppNotification(
//       id: json['id'] as String,
//       title: json['title'] as String,
//       body: json['body'] as String,
//       type: NotificationType.values.firstWhere(
//         (e) => e.name == (json['type'] as String? ?? ''),
//         orElse: () => NotificationType.unknown,
//       ),
//       receivedAt: DateTime.parse(json['receivedAt'] as String),
//       isRead: json['isRead'] as bool? ?? false,
//       route: json['route'] as String?,
//       data: json['data'] as Map<String, dynamic>?,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'title': title,
//         'body': body,
//         'type': type.name,
//         'receivedAt': receivedAt.toIso8601String(),
//         'isRead': isRead,
//         if (route != null) 'route': route,
//         if (data != null) 'data': data,
//       };

//   AppNotification copyWith({bool? isRead}) {
//     return AppNotification(
//       id: id,
//       title: title,
//       body: body,
//       type: type,
//       receivedAt: receivedAt,
//       isRead: isRead ?? this.isRead,
//       route: route,
//       data: data,
//     );
//   }
// }
// ============================================================
// notification_model.dart  — Bangla labels
// ============================================================

import 'package:flutter/material.dart';

enum NotificationType {
  dailyAmal,
  weeklyReview,
  streakAlert,
  push,
  unknown;

  String get label {
    switch (this) {
      case NotificationType.dailyAmal:
        return 'দৈনিক আমল';
      case NotificationType.weeklyReview:
        return 'সাপ্তাহিক রিভিউ';
      case NotificationType.streakAlert:
        return 'স্ট্রিক অ্যালার্ট';
      case NotificationType.push:
        return 'অ্যাপ আপডেট';
      case NotificationType.unknown:
        return 'নোটিফিকেশন';
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.dailyAmal:
        return Icons.auto_awesome_rounded;
      case NotificationType.weeklyReview:
        return Icons.bar_chart_rounded;
      case NotificationType.streakAlert:
        return Icons.local_fire_department_rounded;
      case NotificationType.push:
        return Icons.campaign_rounded;
      case NotificationType.unknown:
        return Icons.notifications_rounded;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.dailyAmal:
        return const Color(0xFF6C63FF);
      case NotificationType.weeklyReview:
        return const Color(0xFF00BFA5);
      case NotificationType.streakAlert:
        return const Color(0xFFFF6B35);
      case NotificationType.push:
        return const Color(0xFF2196F3);
      case NotificationType.unknown:
        return const Color(0xFF9E9E9E);
    }
  }
}

class NotificationTapPayload {
  final NotificationType type;
  final String route;
  final Map<String, dynamic>? extra;

  const NotificationTapPayload({
    required this.type,
    required this.route,
    this.extra,
  });

  factory NotificationTapPayload.fromJson(Map<String, dynamic> json) =>
      NotificationTapPayload(
        type: NotificationType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => NotificationType.unknown,
        ),
        route: json['route'] as String? ?? '/',
        extra: json['extra'] as Map<String, dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'route': route,
        if (extra != null) 'extra': extra,
      };
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime receivedAt;
  bool isRead;
  final String? route;
  final Map<String, dynamic>? data;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.receivedAt,
    this.isRead = false,
    this.route,
    this.data,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        type: NotificationType.values.firstWhere(
          (e) => e.name == (json['type'] as String? ?? ''),
          orElse: () => NotificationType.unknown,
        ),
        receivedAt: DateTime.parse(json['receivedAt'] as String),
        isRead: json['isRead'] as bool? ?? false,
        route: json['route'] as String?,
        data: json['data'] as Map<String, dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'type': type.name,
        'receivedAt': receivedAt.toIso8601String(),
        'isRead': isRead,
        if (route != null) 'route': route,
        if (data != null) 'data': data,
      };

  AppNotification copyWith({bool? isRead}) => AppNotification(
        id: id,
        title: title,
        body: body,
        type: type,
        receivedAt: receivedAt,
        isRead: isRead ?? this.isRead,
        route: route,
        data: data,
      );
}
