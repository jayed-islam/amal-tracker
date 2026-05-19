// ─── Amal Category ───────────────────────────────────────────────────────────

class AmalCategory {
  final String id;
  final String key;
  final String nameEn;
  final String nameBn;
  final String section;
  final String type;
  final bool isPrayer;
  final int basePoints;
  final int congregationPoints;
  final int order;
  final bool isActive;
  final String? description;
  final String? icon;

  const AmalCategory({
    required this.id,
    required this.key,
    required this.nameEn,
    required this.nameBn,
    required this.section,
    required this.type,
    required this.isPrayer,
    required this.basePoints,
    required this.congregationPoints,
    required this.order,
    required this.isActive,
    this.description,
    this.icon,
  });

  factory AmalCategory.fromJson(Map<String, dynamic> json) => AmalCategory(
        id: json['_id'] ?? '',
        key: json['key'] ?? '',
        nameEn: json['nameEn'] ?? '',
        nameBn: json['nameBn'] ?? '',
        section: json['section'] ?? '',
        type: json['type'] ?? 'daily',
        isPrayer: json['isPrayer'] ?? false,
        basePoints: json['basePoints'] ?? 1,
        congregationPoints: json['congregationPoints'] ?? 2,
        order: json['order'] ?? 0,
        isActive: json['isActive'] ?? true,
        description: json['description'],
        icon: json['icon'],
      );
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

  // factory DailyEntryItem.fromJson(Map<String, dynamic> json) => DailyEntryItem(
  //       categoryId: json['categoryId']?['_id'] ?? json['categoryId'] ?? '',
  //       completed: json['completed'] ?? false,
  //       prayerMode: json['prayerMode'] != null
  //           ? PrayerModeExt.fromString(json['prayerMode'])
  //           : null,
  //       count: json['count'] ?? 0,
  //       points: json['points'] ?? 0,
  //     );
  factory DailyEntryItem.fromJson(Map<String, dynamic> json) {
    // categoryId safely extract করা
    String categoryId = '';
    final categoryIdRaw = json['categoryId'];

    if (categoryIdRaw == null) {
      categoryId = '';
    } else if (categoryIdRaw is String) {
      categoryId = categoryIdRaw;
    } else if (categoryIdRaw is Map<String, dynamic>) {
      categoryId = categoryIdRaw['_id']?.toString() ?? '';
    } else {
      categoryId = categoryIdRaw.toString();
    }

    // prayerMode safely extract করা
    PrayerMode? prayerMode;
    final prayerModeRaw = json['prayerMode'];
    if (prayerModeRaw != null && prayerModeRaw is String) {
      prayerMode = PrayerModeExt.fromString(prayerModeRaw);
    } else if (prayerModeRaw != null && prayerModeRaw is Map) {
      // যদি object হয়
      prayerMode = PrayerModeExt.fromString(prayerModeRaw['value']?.toString());
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

  DailyEntry({
    required this.id,
    required this.userId,
    required this.date,
    required this.year,
    required this.month,
    required this.day,
    required this.entries,
    required this.totalPoints,
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
      );
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
  final String serialId;
  final String district;
  final String? department;
  final String? designation;
  final String? avatar;
  final int totalPoints;
  final double completionPercentage;
  final int streakDays;
  final bool isWinner;
  final String? winnerCategory;

  LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.serialId,
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
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json, int rank) {
    final user = json['user'] ?? {};
    return LeaderboardEntry(
      rank: rank,
      userId: json['userId']?.toString() ?? '',
      name: user['name'] ?? '',
      serialId: user['id'] ?? '',
      district: user['district'] ?? '',
      department: user['department'],
      designation: user['designation'],
      avatar: user['avatar'],
      totalPoints: json['totalPoints'] ?? 0,
      completionPercentage: (json['completionPercentage'] ?? 0).toDouble(),
      streakDays: json['streakDays'] ?? 0,
      isWinner: json['isWinner'] ?? false,
      winnerCategory: json['winnerCategory'],
    );
  }
}

// ─── Progress Summary ─────────────────────────────────────────────────────────

class ProgressSummary {
  final MonthlyTracker? currentMonth;
  final List<MonthlyTracker> recentMonths;
  final DailyEntry? todayEntry;
  final int weeklyPoints;

  ProgressSummary({
    this.currentMonth,
    required this.recentMonths,
    this.todayEntry,
    required this.weeklyPoints,
  });

  factory ProgressSummary.fromJson(Map<String, dynamic> json) =>
      ProgressSummary(
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
      );
}
