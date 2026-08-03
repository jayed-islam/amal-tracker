import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/services/api_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// WINNER ENTRY — MonthlyWinners.maleTop / femaleTop / combinedTop এর একটা row
// ─────────────────────────────────────────────────────────────────────────────

class WinnerEntry {
  final String userId;
  final int rank;
  final String name;
  final String? department;
  final double completionPercentage;
  final int farzCompletedDays;
  final int? congregationDaysSum; // female এর জন্য null থাকতে পারে
  final int quranAyahTotal;
  final int streakDays;

  const WinnerEntry({
    required this.userId,
    required this.rank,
    required this.name,
    this.department,
    required this.completionPercentage,
    required this.farzCompletedDays,
    this.congregationDaysSum,
    required this.quranAyahTotal,
    required this.streakDays,
  });

  factory WinnerEntry.fromJson(Map<String, dynamic> json) => WinnerEntry(
        userId: json['userId']?.toString() ?? '',
        rank: (json['rank'] as num?)?.toInt() ?? 0,
        name: json['name'] ?? 'ব্যবহারকারী',
        department: json['department'],
        completionPercentage:
            (json['completionPercentage'] as num?)?.toDouble() ?? 0,
        farzCompletedDays: (json['farzCompletedDays'] as num?)?.toInt() ?? 0,
        congregationDaysSum: (json['congregationDaysSum'] as num?)?.toInt(),
        quranAyahTotal: (json['quranAyahTotal'] as num?)?.toInt() ?? 0,
        streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// CATEGORY AWARD — categoryAwards.TOP_JAMAAT / TOP_QURAN / TOP_STREAK
// ─────────────────────────────────────────────────────────────────────────────

class CategoryAward {
  final String userId;
  final String name;
  final int value;

  const CategoryAward({
    required this.userId,
    required this.name,
    required this.value,
  });

  factory CategoryAward.fromJson(Map<String, dynamic> json) => CategoryAward(
        userId: json['userId']?.toString() ?? '',
        name: json['name'] ?? 'ব্যবহারকারী',
        value: (json['value'] as num?)?.toInt() ?? 0,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// MONTHLY WINNERS DATA — GET /leaderboard/winners এর পুরো response
// ─────────────────────────────────────────────────────────────────────────────

class MonthlyWinnersData {
  final bool finalized;
  final int year;
  final int month;
  final List<WinnerEntry> maleTop;
  final List<WinnerEntry> femaleTop;
  final List<WinnerEntry> combinedTop;
  final Map<String, CategoryAward> categoryAwards;

  const MonthlyWinnersData({
    required this.finalized,
    required this.year,
    required this.month,
    required this.maleTop,
    required this.femaleTop,
    required this.combinedTop,
    required this.categoryAwards,
  });

  factory MonthlyWinnersData.fromJson(
    Map<String, dynamic> json,
    int fallbackYear,
    int fallbackMonth,
  ) {
    List<WinnerEntry> parseList(dynamic raw) =>
        (raw as List? ?? []).map((e) => WinnerEntry.fromJson(e)).toList();

    final awardsRaw = json['categoryAwards'] as Map<String, dynamic>? ?? {};
    final awards = <String, CategoryAward>{};
    awardsRaw.forEach((key, value) {
      if (value != null) awards[key] = CategoryAward.fromJson(value);
    });

    return MonthlyWinnersData(
      finalized: json['finalized'] == true,
      year: (json['year'] as num?)?.toInt() ?? fallbackYear,
      month: (json['month'] as num?)?.toInt() ?? fallbackMonth,
      maleTop: parseList(json['maleTop']),
      femaleTop: parseList(json['femaleTop']),
      combinedTop: parseList(json['combinedTop']),
      categoryAwards: awards,
    );
  }

  static MonthlyWinnersData empty(int year, int month) => MonthlyWinnersData(
        finalized: false,
        year: year,
        month: month,
        maleTop: const [],
        femaleTop: const [],
        combinedTop: const [],
        categoryAwards: const {},
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// WINNERS PROVIDER
// ─────────────────────────────────────────────────────────────────────────────

final monthlyWinnersProvider = FutureProvider.autoDispose
    .family<MonthlyWinnersData, ({int year, int month})>((ref, params) async {
  final api = ref.read(apiServiceProvider);
  try {
    final res = await api.get<Map<String, dynamic>>(
      '/leaderboard/winners?year=${params.year}&month=${params.month}',
    );
    final data = res['data'] ?? {};
    return MonthlyWinnersData.fromJson(data, params.year, params.month);
  } on ApiException {
    return MonthlyWinnersData.empty(params.year, params.month);
  }
});

// ─────────────────────────────────────────────────────────────────────────────
// FILTER — ডিফল্ট গত মাস, কারণ চলতি মাস এখনো finalize হয়নি
// ─────────────────────────────────────────────────────────────────────────────

final winnersFilterProvider = StateProvider<({int year, int month})>((ref) {
  final now = DateTime.now();
  final y = now.month == 1 ? now.year - 1 : now.year;
  final m = now.month == 1 ? 12 : now.month - 1;
  return (year: y, month: m);
});

// ─────────────────────────────────────────────────────────────────────────────
// TAB — কম্বাইন্ড / পুরুষ / মহিলা
// ─────────────────────────────────────────────────────────────────────────────

enum WinnerTab { combined, male, female }

// ── নতুন: gender-aware tab visibility ──────────────────────────────────────
// leaderboard_screen.dart এর _canViewProfile() এর একই নীতি এখানে প্রয়োগ:
// পুরুষ user নারীদের data (নাম/avatar/rank) কোথাও দেখতে পারবে না — তাই
// combined list (যেখানে নারী-পুরুষ মিশ্রিত) ও female tab — দুটোই পুরুষের
// জন্য hidden। নারী user নিজের, পুরুষের, এবং combined — সবগুলো দেখতে পারবে
// (পুরুষের performance দেখে অনুপ্রাণিত হওয়ার সুযোগ থাকছে)।
final availableWinnerTabsProvider = Provider<List<WinnerTab>>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  final isMaleUser = currentUser?.gender?.toLowerCase() == 'male';
  return isMaleUser
      ? const [WinnerTab.male]
      : const [WinnerTab.combined, WinnerTab.male, WinnerTab.female];
});

// ডিফল্ট ট্যাব — পুরুষ হলে male (তার জন্য একমাত্র বিকল্প), নারী হলে combined
final winnerTabProvider = StateProvider.autoDispose<WinnerTab>((ref) {
  final tabs = ref.watch(availableWinnerTabsProvider);
  return tabs.first;
});
