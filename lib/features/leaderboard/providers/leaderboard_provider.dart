import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../tracker/models/tracker_model.dart';
import '../../../core/services/api_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LEADERBOARD FILTER
// ─────────────────────────────────────────────────────────────────────────────

class LeaderboardFilter {
  final int year;
  final int month;
  final int page;
  final int limit;
  final String? gender;

  const LeaderboardFilter({
    required this.year,
    required this.month,
    this.page = 1,
    this.limit = 20,
    this.gender,
  });

  LeaderboardFilter copyWith({
    int? year,
    int? month,
    int? page,
    int? limit,
    String? gender,
    bool clearGender = false,
  }) =>
      LeaderboardFilter(
        year: year ?? this.year,
        month: month ?? this.month,
        page: page ?? this.page,
        limit: limit ?? this.limit,
        gender: clearGender ? null : (gender ?? this.gender),
      );

  String get queryString {
    final params = <String>[];
    params.add('year=$year');
    params.add('month=$month');
    params.add('page=$page');
    params.add('limit=$limit');
    if (gender != null) params.add('gender=$gender');
    return params.join('&');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeaderboardFilter &&
          year == other.year &&
          month == other.month &&
          page == other.page &&
          limit == other.limit &&
          gender == other.gender;

  @override
  int get hashCode =>
      year.hashCode ^
      month.hashCode ^
      page.hashCode ^
      limit.hashCode ^
      gender.hashCode;
}

// ─────────────────────────────────────────────────────────────────────────────
// MY RANK DATA — points বাদ, completion + farz + jamaat + streak
// ─────────────────────────────────────────────────────────────────────────────

class MyRankData {
  final int? rank;
  final String? id;
  final String? district;

  // ── Primary metrics — leaderboard sort order অনুযায়ী ──────────────────────
  final double completionPercentage; // #1 sort key
  final int farzCompletedDays; // #2 sort key — সব ফরজ পূর্ণ দিন
  final int congregationDaysTotal; // #3 sort key — মোট জামাত
  final int streakDays; // #4 sort key — ধারাবাহিক দিন

  // ── Additional info ────────────────────────────────────────────────────────
  final int daysActive;
  final int eligibleDays;
  final int exemptDays;

  // ── Winner ─────────────────────────────────────────────────────────────────
  final bool isWinner;
  final String? winnerCategory;

  const MyRankData({
    this.rank,
    this.id,
    this.district,
    required this.completionPercentage,
    required this.farzCompletedDays,
    required this.congregationDaysTotal,
    required this.streakDays,
    required this.daysActive,
    required this.eligibleDays,
    required this.exemptDays,
    required this.isWinner,
    this.winnerCategory,
  });

  factory MyRankData.fromProgressSummary(Map<String, dynamic> data) {
    // GET /tracker/progress এর response এর currentMonth field থেকে build করা হয়
    final currentMonth = data['currentMonth'];
    final rank = (currentMonth?['rank'] as num?)?.toInt();

    return MyRankData(
      rank: rank,
      id: data['id'],
      district: data['district'],
      completionPercentage:
          (currentMonth?['completionPercentage'] as num?)?.toDouble() ?? 0,
      farzCompletedDays:
          (currentMonth?['farzCompletedDays'] as num?)?.toInt() ?? 0,
      congregationDaysTotal:
          (currentMonth?['congregationDaysTotal'] as num?)?.toInt() ?? 0,
      streakDays: (currentMonth?['streakDays'] as num?)?.toInt() ?? 0,
      daysActive: (currentMonth?['daysActive'] as num?)?.toInt() ?? 0,
      eligibleDays: (currentMonth?['eligibleDays'] as num?)?.toInt() ?? 1,
      exemptDays: (currentMonth?['exemptDays'] as num?)?.toInt() ?? 0,
      isWinner: currentMonth?['isWinner'] ?? false,
      winnerCategory: currentMonth?['winnerCategory'],
    );
  }

  // Fallback empty
  static const empty = MyRankData(
    completionPercentage: 0,
    farzCompletedDays: 0,
    congregationDaysTotal: 0,
    streakDays: 0,
    daysActive: 0,
    eligibleDays: 1,
    exemptDays: 0,
    isWinner: false,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// LEADERBOARD STATE
// ─────────────────────────────────────────────────────────────────────────────

class LeaderboardState {
  final List<LeaderboardEntry> entries;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isRefreshing;
  final bool hasMore;
  final String? error;
  final int currentPage;
  final int total;

  const LeaderboardState({
    this.entries = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.hasMore = true,
    this.error,
    this.currentPage = 1,
    this.total = 0,
  });

  LeaderboardState copyWith({
    List<LeaderboardEntry>? entries,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    bool? hasMore,
    String? error,
    int? currentPage,
    int? total,
    bool clearError = false,
  }) =>
      LeaderboardState(
        entries: entries ?? this.entries,
        isLoading: isLoading ?? this.isLoading,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        isRefreshing: isRefreshing ?? this.isRefreshing,
        hasMore: hasMore ?? this.hasMore,
        error: clearError ? null : (error ?? this.error),
        currentPage: currentPage ?? this.currentPage,
        total: total ?? this.total,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// LEADERBOARD NOTIFIER
// ─────────────────────────────────────────────────────────────────────────────

class LeaderboardNotifier extends StateNotifier<LeaderboardState> {
  final ApiService _api;

  LeaderboardNotifier(this._api) : super(const LeaderboardState());

  Future<void> load(LeaderboardFilter filter, {bool refresh = false}) async {
    if (refresh) {
      if (state.entries.isEmpty) {
        state = state.copyWith(isLoading: true, clearError: true);
      } else {
        state = state.copyWith(isRefreshing: true, clearError: true);
      }
    } else {
      if (state.isLoadingMore || !state.hasMore) return;
      state = state.copyWith(isLoadingMore: true, clearError: true);
    }

    try {
      final res = await _api.get<Map<String, dynamic>>(
        '/leaderboard?${filter.queryString}',
      );

      final List rawData = res['data'] ?? [];
      final meta = res['meta'] ?? {};
      final total = (meta['total'] as num?)?.toInt() ?? rawData.length;
      final page = filter.page;
      final limit = filter.limit;

      // rank offset — page based
      final startRank = (page - 1) * limit + 1;
      final newEntries = rawData.asMap().entries.map((e) {
        return LeaderboardEntry.fromJson(e.value, startRank + e.key);
      }).toList();

      final hasMore = newEntries.length >= limit && (page * limit) < total;

      if (refresh) {
        state = state.copyWith(
          entries: newEntries,
          isLoading: false,
          isRefreshing: false,
          hasMore: hasMore,
          currentPage: page,
          total: total,
        );
      } else {
        state = state.copyWith(
          entries: [...state.entries, ...newEntries],
          isLoadingMore: false,
          isRefreshing: false,
          hasMore: hasMore,
          currentPage: page,
          total: total,
        );
      }
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        error: e.message,
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MY RANK PROVIDER — /tracker/progress endpoint থেকে currentMonth নেয়
// ─────────────────────────────────────────────────────────────────────────────

final myRankProvider = FutureProvider.autoDispose
    .family<MyRankData, ({int year, int month})>((ref, params) async {
  final api = ref.read(apiServiceProvider);
  try {
    final res = await api.get<Map<String, dynamic>>(
      '/tracker/progress?year=${params.year}&month=${params.month}',
    );
    final data = res['data'] ?? {};
    return MyRankData.fromProgressSummary(data);
  } on ApiException {
    return MyRankData.empty;
  }
});

// ─────────────────────────────────────────────────────────────────────────────
// PUBLIC PROFILE PROVIDER — GET /tracker/profile/:userId/:year/:month
// ─────────────────────────────────────────────────────────────────────────────

final publicProfileProvider = FutureProvider.autoDispose
    .family<PublicMonthlyDetail, ({String userId, int year, int month})>(
        (ref, params) async {
  final api = ref.read(apiServiceProvider);
  final res = await api.get<Map<String, dynamic>>(
    '/tracker/profile/${params.userId}/${params.year}/${params.month}',
  );
  return PublicMonthlyDetail.fromJson(res['data'] ?? {});
});

// ─────────────────────────────────────────────────────────────────────────────
// FILTER PROVIDER
// ─────────────────────────────────────────────────────────────────────────────

final leaderboardFilterProvider = StateProvider<LeaderboardFilter>((ref) {
  final now = DateTime.now();
  return LeaderboardFilter(year: now.year, month: now.month);
});

// ─────────────────────────────────────────────────────────────────────────────
// LEADERBOARD PROVIDER
// ─────────────────────────────────────────────────────────────────────────────

final leaderboardProvider =
    StateNotifierProvider<LeaderboardNotifier, LeaderboardState>(
  (ref) => LeaderboardNotifier(ref.read(apiServiceProvider)),
);

// ─────────────────────────────────────────────────────────────────────────────
// LEADERBOARD PREVIEW — home screen এর জন্য lightweight top-3 fetch
// পুরো leaderboardProvider এর pagination state এর সাথে interfere করে না
// ─────────────────────────────────────────────────────────────────────────────

class LeaderboardPreviewState {
  final List<LeaderboardEntry> entries;
  final bool isLoading;
  final String? error;

  const LeaderboardPreviewState({
    this.entries = const [],
    this.isLoading = false,
    this.error,
  });

  LeaderboardPreviewState copyWith({
    List<LeaderboardEntry>? entries,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) =>
      LeaderboardPreviewState(
        entries: entries ?? this.entries,
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : (error ?? this.error),
      );
}

class LeaderboardPreviewNotifier
    extends StateNotifier<LeaderboardPreviewState> {
  final ApiService _api;

  LeaderboardPreviewNotifier(this._api)
      : super(const LeaderboardPreviewState()) {
    _load();
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final now = DateTime.now();
      final res = await _api.get<Map<String, dynamic>>(
        '/leaderboard?year=${now.year}&month=${now.month}&page=1&limit=3',
      );
      final List rawData = res['data'] ?? [];
      final entries = rawData
          .asMap()
          .entries
          .map((e) => LeaderboardEntry.fromJson(e.value, e.key + 1))
          .toList();
      state = state.copyWith(entries: entries, isLoading: false);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  Future<void> refresh() => _load();
}

final leaderboardPreviewProvider =
    StateNotifierProvider<LeaderboardPreviewNotifier, LeaderboardPreviewState>(
  (ref) => LeaderboardPreviewNotifier(ref.read(apiServiceProvider)),
);
