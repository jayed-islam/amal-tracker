// ─── Amal Input Type ─────────────────────────────────────────────────────────

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
        return AmalInputType.binary;
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
  final bool isFard;
  final int order;
  final bool isActive;
  final String? description;
  final String? icon;
  final AmalInputType inputType;
  final String? unit; // "rakaat" | "ayah" | "day" | "minute" | "time"
  final double? minValue;
  final double? maxValue;
  final List<int>? applicableDays; // null = all days, [5] = Friday only

  const AmalCategory({
    required this.id,
    required this.key,
    required this.nameEn,
    required this.nameBn,
    required this.section,
    required this.type,
    required this.isPrayer,
    required this.isFasting,
    required this.isFard,
    required this.order,
    required this.isActive,
    this.description,
    this.icon,
    this.inputType = AmalInputType.binary,
    this.unit,
    this.minValue,
    this.maxValue,
    this.applicableDays,
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
        isFard: json['isFard'] ?? false,
        order: json['order'] ?? 0,
        isActive: json['isActive'] ?? true,
        description: json['description'],
        icon: json['icon'],
        inputType: AmalInputTypeExt.fromString(json['inputType']),
        unit: json['unit'],
        minValue: (json['minValue'] as num?)?.toDouble(),
        maxValue: (json['maxValue'] as num?)?.toDouble(),
        applicableDays: (json['applicableDays'] as List<dynamic>?)
            ?.map((e) => e as int)
            .toList(),
      );

  // Whether this amal is exempted during female period (hayez)
  bool get isExemptDuringPeriod => isPrayer || isFasting;

  // Flutter weekday: Mon=1…Sun=7  →  JS: Sun=0…Sat=6
  bool isApplicableOn(DateTime date) {
    if (applicableDays == null || applicableDays!.isEmpty) return true;
    return applicableDays!.contains(date.weekday % 7);
  }
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

  String get labelBn {
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
// points নেই — raw input only

class DailyEntryItem {
  final String categoryId;
  final bool completed;
  final PrayerMode? prayerMode;
  final int count;

  const DailyEntryItem({
    required this.categoryId,
    required this.completed,
    this.prayerMode,
    this.count = 0,
  });

  factory DailyEntryItem.fromJson(Map<String, dynamic> json) {
    String categoryId = '';
    final raw = json['categoryId'];
    if (raw == null) {
      categoryId = '';
    } else if (raw is String) {
      categoryId = raw;
    } else if (raw is Map<String, dynamic>) {
      // backend থেকে কখনো populated document এলেও (legacy endpoints) সেফলি
      // handle করা — যদিও monthly-progress/home-summary এখন raw ObjectId
      // string পাঠায় (populate বাগ ফিক্সের পর)
      categoryId = raw['_id']?.toString() ?? '';
    } else {
      categoryId = raw.toString();
    }

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
      count: (json['count'] as num?)?.toInt() ?? 0,
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
  final bool hasActivity;
  final bool isExemptDay;

  const DailyEntry({
    required this.id,
    required this.userId,
    required this.date,
    required this.year,
    required this.month,
    required this.day,
    required this.entries,
    required this.hasActivity,
    required this.isExemptDay,
  });

  factory DailyEntry.fromJson(Map<String, dynamic> json) => DailyEntry(
        id: json['_id'] ?? '',
        userId: json['userId']?.toString() ?? '',
        date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
        year: json['year'] ?? 0,
        month: json['month'] ?? 0,
        day: json['day'] ?? 0,
        entries: (json['entries'] as List<dynamic>? ?? [])
            .map((e) => DailyEntryItem.fromJson(e))
            .toList(),
        hasActivity: json['hasActivity'] ?? false,
        isExemptDay: json['isExemptDay'] ?? false,
      );
}

// ─── Category Stat ────────────────────────────────────────────────────────────
// Per-category monthly breakdown from MonthlyTracker.categoryStats

class CategoryStat {
  final int daysActive; // কতদিন এই আমল করা হয়েছে
  final int totalCount; // COUNTER/DURATION মোট (রাকাত / আয়াত ইত্যাদি)
  final int congregationDays; // fard prayer — জামাত দিন
  final int soloDays; // fard prayer — একা দিন
  final int missedDays; // fard prayer — মিস দিন

  const CategoryStat({
    this.daysActive = 0,
    this.totalCount = 0,
    this.congregationDays = 0,
    this.soloDays = 0,
    this.missedDays = 0,
  });

  factory CategoryStat.fromJson(Map<String, dynamic> json) => CategoryStat(
        daysActive: (json['daysActive'] as num?)?.toInt() ?? 0,
        totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
        congregationDays: (json['congregationDays'] as num?)?.toInt() ?? 0,
        soloDays: (json['soloDays'] as num?)?.toInt() ?? 0,
        missedDays: (json['missedDays'] as num?)?.toInt() ?? 0,
      );

  static const empty = CategoryStat();
}

// ─── Monthly Tracker ──────────────────────────────────────────────────────────
// এটা শুধু `currentMonth` এর জন্য — পূর্ণাঙ্গ tracker document।
// `recentMonths` এখন এই ক্লাস ব্যবহার করে না, নিচের RecentMonthSummary
// ব্যবহার করে (backend trimmed response পাঠায়)।

class MonthlyTracker {
  final String id;
  final String userId;
  final int year;
  final int month;

  // ── Activity ──────────────────────────────────────────────────────────────
  final int daysActive; // কোনো না কোনো আমল করা দিন
  final int streakDays; // ধারাবাহিক দিন

  // ── Fard tracking — leaderboard primary metrics ───────────────────────────
  final int farzCompletedDays; // সব ফরজ পূর্ণ দিন
  final double
      completionPercentage; // (farzCompleted + exempt) / eligible × 100
  final int
      congregationDaysSum; // ৫ ওয়াক্ত মিলিয়ে মোট জামাত দিন (male tiebreak)
  final int exemptDays; // হায়েজ দিন (female)
  final int eligibleDays; // মোট গণনাযোগ্য দিন

  // ── Wajib / Sunnah / Nafl / Quran / Dhikr / Fasting / Akhlaq ──────────────
  // এগুলো এখন সরাসরি UI তে static bucket হিসেবে না দেখিয়ে শুধু raw data
  // হিসেবে রাখা হয়েছে — real per-category progress এর জন্য
  // categoryProgressProvider (/tracker/category/:id/progress) ব্যবহার হয়
  final int witrRakaatTotal;
  final int sunnahRakaatTotal;
  final int naflRakaatTotal;
  final int quranAyahTotal;
  final int dhikrScore;
  final int fastingDays;
  final int akhlaqDays;

  // ── Per-category stats ────────────────────────────────────────────────────
  final Map<String, CategoryStat> categoryStats;

  // ── Winner / rank ─────────────────────────────────────────────────────────
  final int? rank;
  final bool isWinner;
  final String?
      winnerCategory; // "TOP_FARZ" | "TOP_JAMAAT" | "TOP_QURAN" | "TOP_STREAK"

  const MonthlyTracker({
    required this.id,
    required this.userId,
    required this.year,
    required this.month,
    required this.daysActive,
    required this.streakDays,
    required this.farzCompletedDays,
    required this.completionPercentage,
    required this.congregationDaysSum,
    required this.exemptDays,
    required this.eligibleDays,
    this.witrRakaatTotal = 0,
    this.sunnahRakaatTotal = 0,
    this.naflRakaatTotal = 0,
    this.quranAyahTotal = 0,
    this.dhikrScore = 0,
    this.fastingDays = 0,
    this.akhlaqDays = 0,
    this.categoryStats = const {},
    this.rank,
    required this.isWinner,
    this.winnerCategory,
  });

  factory MonthlyTracker.fromJson(Map<String, dynamic> json) {
    final rawStats = json['categoryStats'];
    final Map<String, CategoryStat> statsMap = {};
    if (rawStats is Map) {
      rawStats.forEach((key, val) {
        if (val is Map<String, dynamic>) {
          statsMap[key] = CategoryStat.fromJson(val);
        }
      });
    }

    return MonthlyTracker(
      id: json['_id'] ?? '',
      userId: json['userId']?.toString() ?? '',
      year: json['year'] ?? 0,
      month: json['month'] ?? 0,
      daysActive: (json['daysActive'] as num?)?.toInt() ?? 0,
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      farzCompletedDays: (json['farzCompletedDays'] as num?)?.toInt() ?? 0,
      completionPercentage:
          (json['completionPercentage'] as num?)?.toDouble() ?? 0,
      congregationDaysSum: (json['congregationDaysSum'] as num?)?.toInt() ?? 0,
      exemptDays: (json['exemptDays'] as num?)?.toInt() ?? 0,
      eligibleDays: (json['eligibleDays'] as num?)?.toInt() ?? 1,
      witrRakaatTotal: (json['witrRakaatTotal'] as num?)?.toInt() ?? 0,
      sunnahRakaatTotal: (json['sunnahRakaatTotal'] as num?)?.toInt() ?? 0,
      naflRakaatTotal: (json['naflRakaatTotal'] as num?)?.toInt() ?? 0,
      quranAyahTotal: (json['quranAyahTotal'] as num?)?.toInt() ?? 0,
      dhikrScore: (json['dhikrScore'] as num?)?.toInt() ?? 0,
      fastingDays: (json['fastingDays'] as num?)?.toInt() ?? 0,
      akhlaqDays: (json['akhlaqDays'] as num?)?.toInt() ?? 0,
      categoryStats: statsMap,
      rank: (json['rank'] as num?)?.toInt(),
      isWinner: json['isWinner'] ?? false,
      winnerCategory: json['winnerCategory'],
    );
  }
}

// ─── Recent Month Summary ──────────────────────────────────────────────────────
// `recentMonths` এখন backend থেকে ট্রিমড অবজেক্ট আসে (পুরো MonthlyTracker
// document না — categoryStats/id/userId/daysActive ইত্যাদি বাদ) কারণ মাসিক
// তুলনা চার্টে শুধু এই ৮টা scalar মেট্রিকই লাগে। পূর্ণ MonthlyTracker আর
// ব্যবহার করা হয় না এখানে, unnecessary payload এড়াতে।

class RecentMonthSummary {
  final int year;
  final int month;
  final int rank;
  final double completionPercentage;
  final int farzCompletedDays;
  final int congregationDaysSum;
  final int quranAyahTotal;
  final int dhikrScore;
  final int fastingDays;
  final int akhlaqDays;
  final int streakDays;
  final int daysActive;
  final int eligibleDays;
  final bool isWinner;
  final String? winnerCategory;

  const RecentMonthSummary({
    required this.year,
    required this.month,
    required this.rank,
    required this.completionPercentage,
    required this.farzCompletedDays,
    required this.congregationDaysSum,
    required this.quranAyahTotal,
    required this.dhikrScore,
    required this.fastingDays,
    required this.akhlaqDays,
    required this.streakDays,
    this.daysActive = 0,
    this.eligibleDays = 0,
    this.isWinner = false,
    this.winnerCategory,
  });

  factory RecentMonthSummary.fromJson(Map<String, dynamic> json) =>
      RecentMonthSummary(
        year: json['year'] ?? 0,
        month: json['month'] ?? 0,
        rank: (json['rank'] as num?)?.toInt() ?? 0,
        completionPercentage:
            (json['completionPercentage'] as num?)?.toDouble() ?? 0,
        farzCompletedDays: (json['farzCompletedDays'] as num?)?.toInt() ?? 0,
        congregationDaysSum:
            (json['congregationDaysSum'] as num?)?.toInt() ?? 0,
        quranAyahTotal: (json['quranAyahTotal'] as num?)?.toInt() ?? 0,
        dhikrScore: (json['dhikrScore'] as num?)?.toInt() ?? 0,
        fastingDays: (json['fastingDays'] as num?)?.toInt() ?? 0,
        akhlaqDays: (json['akhlaqDays'] as num?)?.toInt() ?? 0,
        streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
        daysActive: (json['daysActive'] as num?)?.toInt() ?? 0,
        eligibleDays: (json['eligibleDays'] as num?)?.toInt() ?? 0,
        isWinner: json['isWinner'] ?? false,
        winnerCategory: json['winnerCategory'],
      );
}

// ─── Weekly Day Progress ──────────────────────────────────────────────────────
// Monthly screen এর সাপ্তাহিক bar chart — hasActivity ভিত্তিক।
// completedCount ঐচ্ছিক: monthly-progress endpoint এটা পাঠায় না (শুধু
// hasActivity বুলিয়ান), কিন্তু home-summary পাঠায় — একই মডেল দুই জায়গায়
// reuse করার জন্য nullable/default রাখা হলো।

class WeeklyDayProgress {
  final String day; // "Sun" | "Mon" | …
  final String date; // "2025-06-01"
  final bool hasActivity; // কোনো আমল করা হয়েছে কিনা
  final bool isExemptDay; // হায়েজ দিন
  final int completedCount; // home-summary তে থাকে, monthly-progress এ 0

  const WeeklyDayProgress({
    required this.day,
    required this.date,
    required this.hasActivity,
    required this.isExemptDay,
    this.completedCount = 0,
  });

  factory WeeklyDayProgress.fromJson(Map<String, dynamic> json) =>
      WeeklyDayProgress(
        day: json['day'] ?? '',
        date: json['date'] ?? '',
        hasActivity: json['hasActivity'] ?? false,
        isExemptDay: json['isExemptDay'] ?? false,
        completedCount: (json['completedCount'] as num?)?.toInt() ?? 0,
      );
}

// ─── Prayer Breakdown Item ────────────────────────────────────────────────────
// Home/monthly screen — আজকের ৫ ওয়াক্তের status

class PrayerBreakdownItem {
  final String categoryId;
  final String key;
  final String nameBn;
  final String? icon;
  final PrayerMode? mode; // null = এখনো লগ করা হয়নি

  const PrayerBreakdownItem({
    required this.categoryId,
    required this.key,
    required this.nameBn,
    this.icon,
    this.mode,
  });

  factory PrayerBreakdownItem.fromJson(Map<String, dynamic> json) =>
      PrayerBreakdownItem(
        categoryId: json['categoryId'] ?? '',
        key: json['key'] ?? '',
        nameBn: json['nameBn'] ?? '',
        icon: json['icon'],
        mode: json['mode'] != null
            ? PrayerModeExt.fromString(json['mode'])
            : null,
      );
}

// ─── Progress Summary ─────────────────────────────────────────────────────────
// GET /tracker/monthly-progress — মাসিক স্ক্রিনের জন্য (আগে endpoint নাম
// ছিল /tracker/progress, রিনেম হয়েছে যাতে home vs monthly স্পষ্ট আলাদা থাকে)

class ProgressSummary {
  final String userGender;
  final MonthlyTracker? currentMonth; // rank সহ, পূর্ণাঙ্গ
  final List<RecentMonthSummary>
      recentMonths; // trimmed, শুধু compare chart এর জন্য
  final DailyEntry? todayEntry;
  final List<PrayerBreakdownItem> todayPrayerBreakdown;
  final List<WeeklyDayProgress> currentWeekProgress; // Sun–Sat hasActivity

  const ProgressSummary({
    required this.userGender,
    this.currentMonth,
    required this.recentMonths,
    this.todayEntry,
    required this.todayPrayerBreakdown,
    required this.currentWeekProgress,
  });

  factory ProgressSummary.fromJson(Map<String, dynamic> json) =>
      ProgressSummary(
        userGender: json['userGender'] ?? 'male',
        currentMonth: json['currentMonth'] != null
            ? MonthlyTracker.fromJson(json['currentMonth'])
            : null,
        recentMonths: (json['recentMonths'] as List<dynamic>? ?? [])
            .map((m) => RecentMonthSummary.fromJson(m))
            .toList(),
        todayEntry: json['todayEntry'] != null
            ? DailyEntry.fromJson(json['todayEntry'])
            : null,
        todayPrayerBreakdown:
            (json['todayPrayerBreakdown'] as List<dynamic>? ?? [])
                .map((e) => PrayerBreakdownItem.fromJson(e))
                .toList(),
        currentWeekProgress:
            (json['currentWeekProgress'] as List<dynamic>? ?? [])
                .map((w) => WeeklyDayProgress.fromJson(w))
                .toList(),
      );
}

// ─── Home Summary ─────────────────────────────────────────────────────────────
// GET /tracker/home-summary — নতুন, lightweight endpoint শুধু home screen
// প্রথম লোডের জন্য। কোনো category catalog, categoryStats, recentMonths,
// rank — কিছুই নেই, শুধু আজকের সংক্ষিপ্ত অবস্থা + সপ্তাহ + মাসের এক-লাইন glance।

class TodaySummary {
  final String date;
  final int completedCount; // আজকে কয়টা আমল সম্পন্ন — points নয়, শুধু গণনা
  final int fardTotal; // সাধারণত 5
  final List<PrayerBreakdownItem> prayerBreakdown;
  final bool isExemptDay;

  const TodaySummary({
    required this.date,
    required this.completedCount,
    required this.fardTotal,
    required this.prayerBreakdown,
    required this.isExemptDay,
  });

  factory TodaySummary.fromJson(Map<String, dynamic> json) => TodaySummary(
        date: json['date'] ?? '',
        completedCount: (json['completedCount'] as num?)?.toInt() ?? 0,
        fardTotal: (json['fardTotal'] as num?)?.toInt() ?? 5,
        prayerBreakdown: (json['prayerBreakdown'] as List<dynamic>? ?? [])
            .map((e) => PrayerBreakdownItem.fromJson(e))
            .toList(),
        isExemptDay: json['isExemptDay'] ?? false,
      );
}

class MonthGlance {
  final double completionPercentage;
  final int farzCompletedDays;
  final int eligibleDays;
  final int daysActive;
  final int? rank;
  final bool isWinner;
  final String? winnerCategory;

  const MonthGlance({
    required this.completionPercentage,
    required this.farzCompletedDays,
    required this.eligibleDays,
    required this.daysActive,
    this.rank,
    this.isWinner = false,
    this.winnerCategory,
  });

  factory MonthGlance.fromJson(Map<String, dynamic> json) => MonthGlance(
        completionPercentage:
            (json['completionPercentage'] as num?)?.toDouble() ?? 0,
        farzCompletedDays: (json['farzCompletedDays'] as num?)?.toInt() ?? 0,
        eligibleDays: (json['eligibleDays'] as num?)?.toInt() ?? 0,
        daysActive: (json['daysActive'] as num?)?.toInt() ?? 0,
        rank: (json['rank'] as num?)?.toInt(),
        isWinner: json['isWinner'] ?? false,
        winnerCategory: json['winnerCategory'],
      );
}

class HabitItem {
  final String key;
  final String label;

  const HabitItem({required this.key, required this.label});

  factory HabitItem.fromJson(Map<String, dynamic> json) => HabitItem(
        key: json['key'] ?? '',
        label: json['label'] ?? '',
      );
}

class HabitDayEntry {
  final String date;
  final bool isExemptDay;
  final List<String>? statuses; // "grid" টাইপে — items[] এর সাথে index মিলিয়ে
  final double? value; // "line" টাইপে — আসল সংখ্যা

  const HabitDayEntry({
    required this.date,
    required this.isExemptDay,
    this.statuses,
    this.value,
  });

  factory HabitDayEntry.fromJson(Map<String, dynamic> json) => HabitDayEntry(
        date: json['date'] ?? '',
        isExemptDay: json['isExemptDay'] ?? false,
        statuses: (json['statuses'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        value: (json['value'] as num?)?.toDouble(),
      );
}

class WeeklyHabit {
  final String key;
  final String label;
  final String icon; // Material IconData তে ম্যাপ হবে
  final String displayType; // "grid" | "line"
  final List<HabitItem>? items; // শুধু grid টাইপে
  final String? unit; // শুধু line টাইপে ("আয়াত" | "রাকাত")
  final String?
      categoryId; // single-category habit হলে — tap-through detail sheet এর জন্য
  final List<HabitDayEntry> days;

  const WeeklyHabit({
    required this.key,
    required this.label,
    required this.icon,
    required this.displayType,
    this.items,
    this.unit,
    this.categoryId,
    required this.days,
  });

  bool get isGrid => displayType == 'grid';

  factory WeeklyHabit.fromJson(Map<String, dynamic> json) => WeeklyHabit(
        key: json['key'] ?? '',
        label: json['label'] ?? '',
        icon: json['icon'] ?? '',
        displayType: json['displayType'] ?? 'line',
        items: (json['items'] as List<dynamic>?)
            ?.map((i) => HabitItem.fromJson(i))
            .toList(),
        unit: json['unit'],
        categoryId: json['categoryId'],
        days: (json['days'] as List<dynamic>? ?? [])
            .map((d) => HabitDayEntry.fromJson(d))
            .toList(),
      );
}

class HomeSummary {
  final String userGender;
  final TodaySummary today;
  final int streakDays;
  final List<WeeklyDayProgress>
      weekProgress; // completedCount সহ (legacy/reserve)
  final List<WeeklyHabit> weeklyHabits; // নতুন focused chart এর ডেটা
  final List<RecentMonthSummary> recentMonths; // ৩ মাসের serial progress
  final MonthGlance monthGlance;

  const HomeSummary({
    required this.userGender,
    required this.today,
    required this.streakDays,
    required this.weekProgress,
    required this.weeklyHabits,
    required this.recentMonths,
    required this.monthGlance,
  });

  factory HomeSummary.fromJson(Map<String, dynamic> json) => HomeSummary(
        userGender: json['userGender'] ?? 'male',
        today: TodaySummary.fromJson(json['today'] ?? {}),
        streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
        weekProgress: (json['weekProgress'] as List<dynamic>? ?? [])
            .map((w) => WeeklyDayProgress.fromJson(w))
            .toList(),
        weeklyHabits: (json['weeklyHabits'] as List<dynamic>? ?? [])
            .map((h) => WeeklyHabit.fromJson(h))
            .toList(),
        recentMonths: (json['recentMonths'] as List<dynamic>? ?? [])
            .map((m) => RecentMonthSummary.fromJson(m))
            .toList(),
        monthGlance: MonthGlance.fromJson(json['monthGlance'] ?? {}),
      );
}

// ─── Leaderboard Entry ────────────────────────────────────────────────────────

class LeaderboardEntry {
  final int rank;
  final String userId;
  final String name;
  final String id; // display ID
  final String district;
  final String? department;
  final String? avatar;
  final String? gender;

  // ── Metrics — points নেই ─────────────────────────────────────────────────
  final double completionPercentage;
  final int farzCompletedDays;
  final int congregationDaysTotal;
  final int streakDays;
  final int daysActive;
  final int eligibleDays;
  final int exemptDays;

  // ── Winner ────────────────────────────────────────────────────────────────
  final bool isWinner;
  final String? winnerCategory;

  final bool isProfilePublic;

  const LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.name,
    required this.id,
    required this.district,
    this.department,
    this.avatar,
    this.gender,
    required this.completionPercentage,
    required this.farzCompletedDays,
    required this.congregationDaysTotal,
    required this.streakDays,
    required this.daysActive,
    required this.eligibleDays,
    required this.exemptDays,
    required this.isWinner,
    this.winnerCategory,
    required this.isProfilePublic,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json, int rank) {
    final user = json['user'] ?? {};
    return LeaderboardEntry(
      rank: rank,
      userId: json['userId']?.toString() ?? '',
      name: user['name'] ?? '',
      id: user['id'] ?? '',
      district: user['district'] ?? '',
      department: user['department'],
      avatar: user['avatar'],
      gender: user['gender'],
      completionPercentage:
          (json['completionPercentage'] as num?)?.toDouble() ?? 0,
      farzCompletedDays: (json['farzCompletedDays'] as num?)?.toInt() ?? 0,
      congregationDaysTotal:
          (json['congregationDaysSum'] as num?)?.toInt() ?? 0,
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      daysActive: (json['daysActive'] as num?)?.toInt() ?? 0,
      eligibleDays: (json['eligibleDays'] as num?)?.toInt() ?? 1,
      exemptDays: (json['exemptDays'] as num?)?.toInt() ?? 0,
      isWinner: json['isWinner'] ?? false,
      winnerCategory: json['winnerCategory'],
      isProfilePublic: user['shareProfile']?['isPublic'] ?? false,
    );
  }
}

// ─── Public Monthly Detail ────────────────────────────────────────────────────

class PublicMonthlyDetail {
  final String name;
  final String id;
  final String district;
  final String? gender;
  final MonthlyTracker? tracker;
  final List<DailyEntry> entries;

  const PublicMonthlyDetail({
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
