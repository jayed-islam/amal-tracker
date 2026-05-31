// enum AmalInputType { binary, counter, duration }

// extension AmalInputTypeExt on AmalInputType {
//   String get value {
//     switch (this) {
//       case AmalInputType.binary:
//         return 'binary';
//       case AmalInputType.counter:
//         return 'counter';
//       case AmalInputType.duration:
//         return 'duration';
//     }
//   }

//   static AmalInputType fromString(String? s) {
//     switch (s) {
//       case 'counter':
//         return AmalInputType.counter;
//       case 'duration':
//         return AmalInputType.duration;
//       default:
//         return AmalInputType.binary; // safe fallback
//     }
//   }
// }

// // ─── Amal Category ───────────────────────────────────────────────────────────

// class AmalCategory {
//   final String id;
//   final String key;
//   final String nameEn;
//   final String nameBn;
//   final String section;
//   final String type;
//   final bool isPrayer;
//   final int basePoints;
//   final int congregationPoints;
//   final int order;
//   final bool isActive;
//   final String? description;
//   final String? icon;

//   // ── New: input type & counter config (all from backend) ──────────────────
//   final AmalInputType inputType; // "binary" | "counter" | "duration"
//   final double? pointsPerUnit; // points per unit for counter/duration
//   final String? unit; // "ayah" | "day" | "person" | "minute" | null
//   final int? minValue; // minimum allowed value (null = 0)
//   final int? maxValue; // maximum allowed value (null = unlimited)

//   const AmalCategory({
//     required this.id,
//     required this.key,
//     required this.nameEn,
//     required this.nameBn,
//     required this.section,
//     required this.type,
//     required this.isPrayer,
//     required this.basePoints,
//     required this.congregationPoints,
//     required this.order,
//     required this.isActive,
//     this.description,
//     this.icon,
//     this.inputType = AmalInputType.binary,
//     this.pointsPerUnit,
//     this.unit,
//     this.minValue,
//     this.maxValue,
//   });

//   factory AmalCategory.fromJson(Map<String, dynamic> json) => AmalCategory(
//         id: json['_id'] ?? '',
//         key: json['key'] ?? '',
//         nameEn: json['nameEn'] ?? '',
//         nameBn: json['nameBn'] ?? '',
//         section: json['section'] ?? '',
//         type: json['type'] ?? 'daily',
//         isPrayer: json['isPrayer'] ?? false,
//         basePoints: json['basePoints'] ?? 1,
//         congregationPoints: json['congregationPoints'] ?? 2,
//         order: json['order'] ?? 0,
//         isActive: json['isActive'] ?? true,
//         description: json['description'],
//         icon: json['icon'],
//         // New fields — safe fallback to binary / null if backend omits them
//         inputType: AmalInputTypeExt.fromString(json['inputType']),
//         pointsPerUnit: (json['pointsPerUnit'] as num?)?.toDouble(),
//         unit: json['unit'],
//         minValue: (json['minValue'] as num?)?.toInt(),
//         maxValue: (json['maxValue'] as num?)?.toInt(),
//       );

//   /// Effective points-per-unit: falls back to basePoints if backend omits it.
//   /// Use this in point calculation instead of accessing pointsPerUnit directly.
//   double get effectivePointsPerUnit => pointsPerUnit ?? basePoints.toDouble();

//   /// Whether this category uses incremental counting (not a simple checkbox).
//   bool get isCounter => inputType == AmalInputType.counter;

//   /// Whether a maximum value cap is enforced.
//   bool get isBounded => maxValue != null;
// }

// // ─── Prayer Mode ──────────────────────────────────────────────────────────────

// enum PrayerMode { congregation, solo, missed }

// extension PrayerModeExt on PrayerMode {
//   String get value {
//     switch (this) {
//       case PrayerMode.congregation:
//         return 'congregation';
//       case PrayerMode.solo:
//         return 'solo';
//       case PrayerMode.missed:
//         return 'missed';
//     }
//   }

//   String get label {
//     switch (this) {
//       case PrayerMode.congregation:
//         return 'জামাতে';
//       case PrayerMode.solo:
//         return 'একাকী';
//       case PrayerMode.missed:
//         return 'মিস';
//     }
//   }

//   static PrayerMode fromString(String? s) {
//     switch (s) {
//       case 'congregation':
//         return PrayerMode.congregation;
//       case 'solo':
//         return PrayerMode.solo;
//       default:
//         return PrayerMode.missed;
//     }
//   }
// }

// // ─── Daily Entry Item ─────────────────────────────────────────────────────────

// class DailyEntryItem {
//   final String categoryId;
//   bool completed;
//   PrayerMode? prayerMode;
//   int count;
//   int points;

//   DailyEntryItem({
//     required this.categoryId,
//     required this.completed,
//     this.prayerMode,
//     this.count = 0,
//     this.points = 0,
//   });

//   factory DailyEntryItem.fromJson(Map<String, dynamic> json) {
//     // categoryId — handles String, populated object, or anything else
//     String categoryId = '';
//     final raw = json['categoryId'];
//     if (raw == null) {
//       categoryId = '';
//     } else if (raw is String) {
//       categoryId = raw;
//     } else if (raw is Map<String, dynamic>) {
//       categoryId = raw['_id']?.toString() ?? '';
//     } else {
//       categoryId = raw.toString();
//     }

//     // prayerMode — handles String or object shape
//     PrayerMode? prayerMode;
//     final pmRaw = json['prayerMode'];
//     if (pmRaw is String) {
//       prayerMode = PrayerModeExt.fromString(pmRaw);
//     } else if (pmRaw is Map) {
//       prayerMode = PrayerModeExt.fromString(pmRaw['value']?.toString());
//     }

//     return DailyEntryItem(
//       categoryId: categoryId,
//       completed: json['completed'] == true,
//       prayerMode: prayerMode,
//       count: (json['count'] as int?) ?? 0,
//       points: (json['points'] as int?) ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'categoryId': categoryId,
//         'completed': completed,
//         if (prayerMode != null) 'prayerMode': prayerMode!.value,
//         'count': count,
//       };
// }

// // ─── Daily Entry ─────────────────────────────────────────────────────────────

// class DailyEntry {
//   final String id;
//   final String userId;
//   final DateTime date;
//   final int year;
//   final int month;
//   final int day;
//   final List<DailyEntryItem> entries;
//   final int totalPoints;

//   DailyEntry({
//     required this.id,
//     required this.userId,
//     required this.date,
//     required this.year,
//     required this.month,
//     required this.day,
//     required this.entries,
//     required this.totalPoints,
//   });

//   factory DailyEntry.fromJson(Map<String, dynamic> json) => DailyEntry(
//         id: json['_id'] ?? '',
//         userId: json['userId'] ?? '',
//         date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
//         year: json['year'] ?? 0,
//         month: json['month'] ?? 0,
//         day: json['day'] ?? 0,
//         entries: (json['entries'] as List<dynamic>? ?? [])
//             .map((e) => DailyEntryItem.fromJson(e))
//             .toList(),
//         totalPoints: json['totalPoints'] ?? 0,
//       );
// }

// // ─── Monthly Tracker ──────────────────────────────────────────────────────────

// class MonthlyTracker {
//   final String id;
//   final String userId;
//   final int year;
//   final int month;
//   final int totalPoints;
//   final int daysCompleted;
//   final int streakDays;
//   final int weeklyPoints;
//   final int monthlyPoints;
//   final int dailyPoints;
//   final double completionPercentage;
//   final int? rank;
//   final bool isWinner;
//   final String? winnerCategory;

//   MonthlyTracker({
//     required this.id,
//     required this.userId,
//     required this.year,
//     required this.month,
//     required this.totalPoints,
//     required this.daysCompleted,
//     required this.streakDays,
//     required this.weeklyPoints,
//     required this.monthlyPoints,
//     required this.dailyPoints,
//     required this.completionPercentage,
//     this.rank,
//     required this.isWinner,
//     this.winnerCategory,
//   });

//   factory MonthlyTracker.fromJson(Map<String, dynamic> json) => MonthlyTracker(
//         id: json['_id'] ?? '',
//         userId: json['userId'] ?? '',
//         year: json['year'] ?? 0,
//         month: json['month'] ?? 0,
//         totalPoints: json['totalPoints'] ?? 0,
//         daysCompleted: json['daysCompleted'] ?? 0,
//         streakDays: json['streakDays'] ?? 0,
//         weeklyPoints: json['weeklyPoints'] ?? 0,
//         monthlyPoints: json['monthlyPoints'] ?? 0,
//         dailyPoints: json['dailyPoints'] ?? 0,
//         completionPercentage: (json['completionPercentage'] ?? 0).toDouble(),
//         rank: json['rank'],
//         isWinner: json['isWinner'] ?? false,
//         winnerCategory: json['winnerCategory'],
//       );
// }

// // ─── Leaderboard Entry ────────────────────────────────────────────────────────

// class LeaderboardEntry {
//   final int rank;
//   final String userId;
//   final String name;
//   final String id;
//   final String district;
//   final String? department;
//   final String? designation;
//   final String? avatar;
//   final int totalPoints;
//   final double completionPercentage;
//   final int streakDays;
//   final bool isWinner;
//   final String? winnerCategory;

//   LeaderboardEntry({
//     required this.rank,
//     required this.userId,
//     required this.id,
//     required this.district,
//     required this.name,
//     this.department,
//     this.designation,
//     this.avatar,
//     required this.totalPoints,
//     required this.completionPercentage,
//     required this.streakDays,
//     required this.isWinner,
//     this.winnerCategory,
//   });

//   factory LeaderboardEntry.fromJson(Map<String, dynamic> json, int rank) {
//     final user = json['user'] ?? {};
//     return LeaderboardEntry(
//       rank: rank,
//       userId: json['userId']?.toString() ?? '',
//       name: user['name'] ?? '',
//       id: user['id'] ?? '',
//       district: user['district'] ?? '',
//       department: user['department'],
//       designation: user['designation'],
//       avatar: user['avatar'],
//       totalPoints: json['totalPoints'] ?? 0,
//       completionPercentage: (json['completionPercentage'] ?? 0).toDouble(),
//       streakDays: json['streakDays'] ?? 0,
//       isWinner: json['isWinner'] ?? false,
//       winnerCategory: json['winnerCategory'],
//     );
//   }
// }

// // ─── Progress Summary ─────────────────────────────────────────────────────────

// class ProgressSummary {
//   final MonthlyTracker? currentMonth;
//   final List<MonthlyTracker> recentMonths;
//   final DailyEntry? todayEntry;
//   final int weeklyPoints;

//   ProgressSummary({
//     this.currentMonth,
//     required this.recentMonths,
//     this.todayEntry,
//     required this.weeklyPoints,
//   });

//   factory ProgressSummary.fromJson(Map<String, dynamic> json) =>
//       ProgressSummary(
//         currentMonth: json['currentMonth'] != null
//             ? MonthlyTracker.fromJson(json['currentMonth'])
//             : null,
//         recentMonths: (json['recentMonths'] as List<dynamic>? ?? [])
//             .map((m) => MonthlyTracker.fromJson(m))
//             .toList(),
//         todayEntry: json['todayEntry'] != null
//             ? DailyEntry.fromJson(json['todayEntry'])
//             : null,
//         weeklyPoints: json['weeklyPoints'] ?? 0,
//       );
// }
enum AmalInputType { binary, counter, duration }

extension AmalInputTypeExt on AmalInputType {
  String get value {
    switch (this) {
      case AmalInputType.binary:
        return 'binary';
      case AmalInputType.counter:
        return 'counter';
      case AmalInputType.duration:
        return 'duration';
    }
  }

  static AmalInputType fromString(String? s) {
    switch (s) {
      case 'counter':
        return AmalInputType.counter;
      case 'duration':
        return AmalInputType.duration;
      default:
        return AmalInputType.binary; // safe fallback
    }
  }
}

// ─── Amal Category ───────────────────────────────────────────────────────────

class AmalCategory {
  final String id;
  final String key;
  final String nameEn;
  final String nameBn;
  final String section;
  final String type;
  final bool isPrayer;
  final bool isFasting;
  final bool isFard; // NEW: whether this is a Fard (obligatory) category
  final int basePoints;
  final int congregationPoints;
  final int order;
  final bool isActive;
  final String? description;
  final String? icon;

  // ── New: input type & counter config (all from backend) ──────────────────
  final AmalInputType inputType; // "binary" | "counter" | "duration"
  final double? pointsPerUnit; // points per unit for counter/duration
  final String? unit; // "ayah" | "day" | "person" | "minute" | null
  final int? minValue; // minimum allowed value (null = 0)
  final int? maxValue; // maximum allowed value (null = unlimited)

  const AmalCategory({
    required this.id,
    required this.key,
    required this.nameEn,
    required this.nameBn,
    required this.section,
    required this.type,
    required this.isPrayer,
    required this.isFasting,
    required this.isFard, // NEW
    required this.basePoints,
    required this.congregationPoints,
    required this.order,
    required this.isActive,
    this.description,
    this.icon,
    this.inputType = AmalInputType.binary,
    this.pointsPerUnit,
    this.unit,
    this.minValue,
    this.maxValue,
  });

  factory AmalCategory.fromJson(Map<String, dynamic> json) => AmalCategory(
        id: json['_id'] ?? '',
        key: json['key'] ?? '',
        nameEn: json['nameEn'] ?? '',
        nameBn: json['nameBn'] ?? '',
        section: json['section'] ?? '',
        type: json['type'] ?? 'daily',
        isPrayer: json['isPrayer'] ?? false,
        isFasting: json['isFasting'] ?? false,
        isFard: json['isFard'] ?? false, // NEW - defaults to false
        basePoints: json['basePoints'] ?? 1,
        congregationPoints: json['congregationPoints'] ?? 2,
        order: json['order'] ?? 0,
        isActive: json['isActive'] ?? true,
        description: json['description'],
        icon: json['icon'],
        // New fields — safe fallback to binary / null if backend omits them
        inputType: AmalInputTypeExt.fromString(json['inputType']),
        pointsPerUnit: (json['pointsPerUnit'] as num?)?.toDouble(),
        unit: json['unit'],
        minValue: (json['minValue'] as num?)?.toInt(),
        maxValue: (json['maxValue'] as num?)?.toInt(),
      );

  /// Effective points-per-unit: falls back to basePoints if backend omits it.
  /// Use this in point calculation instead of accessing pointsPerUnit directly.
  double get effectivePointsPerUnit => pointsPerUnit ?? basePoints.toDouble();

  /// Whether this category uses incremental counting (not a simple checkbox).
  bool get isCounter => inputType == AmalInputType.counter;

  /// Whether a maximum value cap is enforced.
  bool get isBounded => maxValue != null;

  bool get isExemptDuringPeriod => isPrayer || isFasting;
}

// ─── Prayer Mode ──────────────────────────────────────────────────────────────

enum PrayerMode { congregation, solo, missed }

extension PrayerModeExt on PrayerMode {
  String get value {
    switch (this) {
      case PrayerMode.congregation:
        return 'congregation';
      case PrayerMode.solo:
        return 'solo';
      case PrayerMode.missed:
        return 'missed';
    }
  }

  String get label {
    switch (this) {
      case PrayerMode.congregation:
        return 'জামাতে';
      case PrayerMode.solo:
        return 'একাকী';
      case PrayerMode.missed:
        return 'মিস';
    }
  }

  static PrayerMode fromString(String? s) {
    switch (s) {
      case 'congregation':
        return PrayerMode.congregation;
      case 'solo':
        return PrayerMode.solo;
      default:
        return PrayerMode.missed;
    }
  }
}

// ─── Daily Entry Item ─────────────────────────────────────────────────────────

class DailyEntryItem {
  final String categoryId;
  bool completed;
  PrayerMode? prayerMode;
  int count;
  int points;

  DailyEntryItem({
    required this.categoryId,
    required this.completed,
    this.prayerMode,
    this.count = 0,
    this.points = 0,
  });

  factory DailyEntryItem.fromJson(Map<String, dynamic> json) {
    // categoryId — handles String, populated object, or anything else
    String categoryId = '';
    final raw = json['categoryId'];
    if (raw == null) {
      categoryId = '';
    } else if (raw is String) {
      categoryId = raw;
    } else if (raw is Map<String, dynamic>) {
      categoryId = raw['_id']?.toString() ?? '';
    } else {
      categoryId = raw.toString();
    }

    // prayerMode — handles String or object shape
    PrayerMode? prayerMode;
    final pmRaw = json['prayerMode'];
    if (pmRaw is String) {
      prayerMode = PrayerModeExt.fromString(pmRaw);
    } else if (pmRaw is Map) {
      prayerMode = PrayerModeExt.fromString(pmRaw['value']?.toString());
    }

    return DailyEntryItem(
      categoryId: categoryId,
      completed: json['completed'] == true,
      prayerMode: prayerMode,
      count: (json['count'] as int?) ?? 0,
      points: (json['points'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'completed': completed,
        if (prayerMode != null) 'prayerMode': prayerMode!.value,
        'count': count,
      };
}

// ─── Daily Entry ─────────────────────────────────────────────────────────────

class DailyEntry {
  final String id;
  final String userId;
  final DateTime date;
  final int year;
  final int month;
  final int day;
  final List<DailyEntryItem> entries;
  final int totalPoints;
  final bool isExemptDay; // NEW: whether this day is exempted from tracking

  DailyEntry({
    required this.id,
    required this.userId,
    required this.date,
    required this.year,
    required this.month,
    required this.day,
    required this.entries,
    required this.totalPoints,
    required this.isExemptDay, // NEW
  });

  factory DailyEntry.fromJson(Map<String, dynamic> json) => DailyEntry(
        id: json['_id'] ?? '',
        userId: json['userId'] ?? '',
        date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
        year: json['year'] ?? 0,
        month: json['month'] ?? 0,
        day: json['day'] ?? 0,
        entries: (json['entries'] as List<dynamic>? ?? [])
            .map((e) => DailyEntryItem.fromJson(e))
            .toList(),
        totalPoints: json['totalPoints'] ?? 0,
        isExemptDay: json['isExemptDay'] ?? false, // NEW - defaults to false
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId,
        'date': date.toIso8601String(),
        'year': year,
        'month': month,
        'day': day,
        'entries': entries.map((e) => e.toJson()).toList(),
        'totalPoints': totalPoints,
        'isExemptDay': isExemptDay, // NEW
      };
}

// ─── Monthly Tracker ──────────────────────────────────────────────────────────

class MonthlyTracker {
  final String id;
  final String userId;
  final int year;
  final int month;
  final int totalPoints;
  final int daysCompleted;
  final int streakDays;
  final int weeklyPoints;
  final int monthlyPoints;
  final int dailyPoints;
  final double completionPercentage;
  final int? rank;
  final bool isWinner;
  final String? winnerCategory;

  MonthlyTracker({
    required this.id,
    required this.userId,
    required this.year,
    required this.month,
    required this.totalPoints,
    required this.daysCompleted,
    required this.streakDays,
    required this.weeklyPoints,
    required this.monthlyPoints,
    required this.dailyPoints,
    required this.completionPercentage,
    this.rank,
    required this.isWinner,
    this.winnerCategory,
  });

  factory MonthlyTracker.fromJson(Map<String, dynamic> json) => MonthlyTracker(
        id: json['_id'] ?? '',
        userId: json['userId'] ?? '',
        year: json['year'] ?? 0,
        month: json['month'] ?? 0,
        totalPoints: json['totalPoints'] ?? 0,
        daysCompleted: json['daysCompleted'] ?? 0,
        streakDays: json['streakDays'] ?? 0,
        weeklyPoints: json['weeklyPoints'] ?? 0,
        monthlyPoints: json['monthlyPoints'] ?? 0,
        dailyPoints: json['dailyPoints'] ?? 0,
        completionPercentage: (json['completionPercentage'] ?? 0).toDouble(),
        rank: json['rank'],
        isWinner: json['isWinner'] ?? false,
        winnerCategory: json['winnerCategory'],
      );
}

// ─── Leaderboard Entry ────────────────────────────────────────────────────────

class LeaderboardEntry {
  final int rank;
  final String userId;
  final String name;
  final String id;
  final String district;
  final String? department;
  final String? designation;
  final String? avatar;
  final int totalPoints;
  final double completionPercentage;
  final int streakDays;
  final bool isWinner;
  final String? winnerCategory;
  final bool isProfilePublic; // নতুন — details দেখা যাবে কিনা
  final String? gender; // নতুন — female badge এর জন্য

  LeaderboardEntry(
      {required this.rank,
      required this.userId,
      required this.id,
      required this.district,
      required this.name,
      this.department,
      this.designation,
      this.avatar,
      required this.totalPoints,
      required this.completionPercentage,
      required this.streakDays,
      required this.isWinner,
      this.winnerCategory,
      required this.isProfilePublic,
      this.gender});

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json, int rank) {
    final user = json['user'] ?? {};
    return LeaderboardEntry(
      rank: rank,
      userId: json['userId']?.toString() ?? '',
      name: user['name'] ?? '',
      id: user['id'] ?? '',
      district: user['district'] ?? '',
      department: user['department'],
      designation: user['designation'],
      avatar: user['avatar'],
      totalPoints: json['totalPoints'] ?? 0,
      completionPercentage: (json['completionPercentage'] ?? 0).toDouble(),
      streakDays: json['streakDays'] ?? 0,
      isWinner: json['isWinner'] ?? false,
      winnerCategory: json['winnerCategory'],
      isProfilePublic: user['shareProfile']?['isPublic'] ?? false,
      gender: user['gender'],
    );
  }
}

// ─── Weekly Bar Data Model (নতুন যুক্ত করুন) ──────────────────────────────────
class WeeklyBarData {
  final String day;
  final String date;
  final int points;
  final int fardDone;
  final int totalFard;
  final int jamatCount;
  final int sunnahCount; // 👈 নতুন ফিল্ড
  final bool hasData;
  final bool isExemptDay;

  WeeklyBarData({
    required this.day,
    required this.date,
    required this.points,
    required this.fardDone,
    required this.totalFard,
    required this.jamatCount,
    required this.sunnahCount,
    required this.hasData,
    required this.isExemptDay,
  });

  factory WeeklyBarData.fromJson(Map<String, dynamic> json) => WeeklyBarData(
        day: json['day'] ?? '',
        date: json['date'] ?? '',
        points: json['points'] ?? 0,
        fardDone: json['fardDone'] ?? 0,
        totalFard: json['totalFard'] ?? 0,
        jamatCount: json['jamatCount'] ?? 0,
        sunnahCount: json['sunnahCount'] ?? 0, // ম্যাপিং করা হলো
        hasData: json['hasData'] ?? false,
        isExemptDay: json['isExemptDay'] ?? false,
      );
}
// ─── Progress Summary ─────────────────────────────────────────────────────────

class ProgressSummary {
  final String userGender;
  final MonthlyTracker? currentMonth;
  final List<MonthlyTracker> recentMonths;
  final DailyEntry? todayEntry;
  final int weeklyPoints;
  final List<WeeklyBarData> currentWeek;

  ProgressSummary({
    required this.userGender,
    this.currentMonth,
    required this.recentMonths,
    this.todayEntry,
    required this.weeklyPoints,
    required this.currentWeek,
  });

  factory ProgressSummary.fromJson(Map<String, dynamic> json) =>
      ProgressSummary(
        userGender: json['userGender'] ?? 'male', // ব্যাকএন্ড থেকে রিসিভ
        currentMonth: json['currentMonth'] != null
            ? MonthlyTracker.fromJson(json['currentMonth'])
            : null,
        recentMonths: (json['recentMonths'] as List<dynamic>? ?? [])
            .map((m) => MonthlyTracker.fromJson(m))
            .toList(),
        todayEntry: json['todayEntry'] != null
            ? DailyEntry.fromJson(json['todayEntry'])
            : null,
        weeklyPoints: json['weeklyPoints'] ?? 0,
        currentWeek: (json['currentWeek'] as List<dynamic>? ??
                []) // 👈 ব্যাকএন্ড অ্যারে ম্যাপিং
            .map((w) => WeeklyBarData.fromJson(w))
            .toList(),
      );
}

// নতুন model — public profile detail
class PublicMonthlyDetail {
  final String name;
  final String id;
  final String district;
  final String? gender;
  final MonthlyTracker? tracker;
  final List<DailyEntry> entries;

  PublicMonthlyDetail({
    required this.name,
    required this.id,
    required this.district,
    this.gender,
    this.tracker,
    required this.entries,
  });

  factory PublicMonthlyDetail.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    return PublicMonthlyDetail(
      name: user['name'] ?? '',
      id: user['id'] ?? '',
      district: user['district'] ?? '',
      gender: user['gender'],
      tracker: json['tracker'] != null
          ? MonthlyTracker.fromJson(json['tracker'])
          : null,
      entries: (json['entries'] as List<dynamic>? ?? [])
          .map((e) => DailyEntry.fromJson(e))
          .toList(),
    );
  }
}
