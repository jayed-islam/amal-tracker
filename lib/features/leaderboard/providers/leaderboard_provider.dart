import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../tracker/models/tracker_model.dart';

// ─── Leaderboard Filter ───────────────────────────────────────────────────────

class LeaderboardFilter {
  final int year;
  final int month;
  final String? department;
  final int page;
  final int limit;

  const LeaderboardFilter({
    required this.year,
    required this.month,
    this.department,
    this.page = 1,
    this.limit = 30,
  });

  LeaderboardFilter copyWith({
    int? year,
    int? month,
    String? department,
    int? page,
  }) =>
      LeaderboardFilter(
        year: year ?? this.year,
        month: month ?? this.month,
        department: department ?? this.department,
        page: page ?? this.page,
        limit: limit,
      );
}

// ─── Leaderboard State ────────────────────────────────────────────────────────

class LeaderboardState {
  final List<LeaderboardEntry> entries;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;

  final int totalPages;
  final int currentPage;
  final int total;

  const LeaderboardState({
    this.entries = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.totalPages = 1,
    this.currentPage = 1,
    this.total = 0,
  });

  bool get hasMore => currentPage < totalPages;

  LeaderboardState copyWith({
    List<LeaderboardEntry>? entries,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool clearError = false,
    int? totalPages,
    int? currentPage,
    int? total,
  }) =>
      LeaderboardState(
        entries: entries ?? this.entries,
        isLoading: isLoading ?? this.isLoading,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        error: clearError ? null : (error ?? this.error),
        totalPages: totalPages ?? this.totalPages,
        currentPage: currentPage ?? this.currentPage,
        total: total ?? this.total,
      );
}

// ─── Leaderboard Notifier ─────────────────────────────────────────────────────

class LeaderboardNotifier extends StateNotifier<LeaderboardState> {
  final ApiService _api;

  LeaderboardNotifier(this._api) : super(const LeaderboardState());

  // Future<void> load(LeaderboardFilter filter, {bool refresh = false}) async {
  //   if (refresh) {
  //     state = state.copyWith(isLoading: true, error: null, entries: []);
  //   } else if (filter.page > 1) {
  //     state = state.copyWith(isLoadingMore: true);
  //   } else {
  //     state = state.copyWith(isLoading: true, error: null);
  //   }

  //   try {
  //     final params = <String, dynamic>{
  //       'year': filter.year,
  //       'month': filter.month,
  //       'page': filter.page,
  //       'limit': filter.limit,
  //       if (filter.department != null) 'department': filter.department,
  //     };

  //     final response = await _api.get<Map<String, dynamic>>('/leaderboard',
  //         queryParams: params);
  //     final List data = response['data'] ?? [];
  //     final pagination = response['pagination'] ?? {};

  //     final newEntries = data
  //         .asMap()
  //         .entries
  //         .map((e) => LeaderboardEntry.fromJson(
  //             e.value, ((filter.page - 1) * filter.limit) + e.key + 1))
  //         .toList();

  //     state = state.copyWith(
  //       entries:
  //           filter.page == 1 ? newEntries : [...state.entries, ...newEntries],
  //       isLoading: false,
  //       isLoadingMore: false,
  //       totalPages: pagination['totalPages'] ?? 1,
  //       currentPage: filter.page,
  //       total: pagination['total'] ?? 0,
  //     );
  //   } on ApiException catch (e) {
  //     state = state.copyWith(
  //         isLoading: false, isLoadingMore: false, error: e.message);
  //   }
  // }
  // Future<void> load(LeaderboardFilter filter, {bool refresh = false}) async {
  //   if (refresh) {
  //     state =
  //         const LeaderboardState(isLoading: true); // ← full reset, not copyWith
  //   } else if (filter.page > 1) {
  //     state = state.copyWith(isLoadingMore: true, error: null);
  //   } else {
  //     state = state.copyWith(isLoading: true, error: null, entries: []);
  //   }

  //   try {
  //     final params = <String, dynamic>{
  //       'year': filter.year,
  //       'month': filter.month,
  //       'page': filter.page,
  //       'limit': filter.limit,
  //       if (filter.department != null) 'department': filter.department,
  //     };

  //     final response = await _api.get<Map<String, dynamic>>(
  //       '/leaderboard',
  //       queryParams: params,
  //     );
  //     final List data = response['data'] ?? [];
  //     final pagination = response['pagination'] ?? {};

  //     final newEntries = data
  //         .asMap()
  //         .entries
  //         .map((e) => LeaderboardEntry.fromJson(
  //             e.value, ((filter.page - 1) * filter.limit) + e.key + 1))
  //         .toList();

  //     state = state.copyWith(
  //       entries:
  //           filter.page == 1 ? newEntries : [...state.entries, ...newEntries],
  //       isLoading: false,
  //       isLoadingMore: false,
  //       totalPages: pagination['totalPages'] ?? 1,
  //       currentPage: filter.page,
  //       total: pagination['total'] ?? 0,
  //     );
  //   } on ApiException catch (e) {
  //     state = state.copyWith(
  //       isLoading: false,
  //       isLoadingMore: false,
  //       entries: refresh ? [] : state.entries, // explicit on refresh
  //       error: e.message,
  //     );
  //   } catch (e) {
  //     // ← was completely missing — any non-ApiException left isLoading: true forever
  //     state = state.copyWith(
  //       isLoading: false,
  //       isLoadingMore: false,
  //       entries: refresh ? [] : state.entries,
  //       error: e.toString(),
  //     );
  //   }
  // }
  Future<void> load(LeaderboardFilter filter, {bool refresh = false}) async {
    // ── Set loading state ────────────────────────────────────────────────────
    if (refresh || filter.page == 1) {
      // Full reset: clears entries + error immediately so stale data never shows
      state = const LeaderboardState(isLoading: true);
    } else {
      // Pagination: keep existing entries visible, just show bottom loader
      state = state.copyWith(isLoadingMore: true, clearError: true);
    }

    try {
      final params = <String, dynamic>{
        'year': filter.year,
        'month': filter.month,
        'page': filter.page,
        'limit': filter.limit,
        if (filter.department != null) 'department': filter.department,
      };

      final response = await _api.get<Map<String, dynamic>>(
        '/leaderboard',
        queryParams: params,
      );

      final List data = response['data'] ?? [];
      final pagination = response['pagination'] ?? {};

      final newEntries = data
          .asMap()
          .entries
          .map((e) => LeaderboardEntry.fromJson(
              e.value, ((filter.page - 1) * filter.limit) + e.key + 1))
          .toList();

      state = state.copyWith(
        entries: filter.page == 1
            ? newEntries // page 1: replace entirely (even if [])
            : [...state.entries, ...newEntries], // page 2+: append
        isLoading: false,
        isLoadingMore: false,
        clearError: true,
        totalPages: pagination['totalPages'] ?? 1,
        currentPage: filter.page,
        total: pagination['total'] ?? 0,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        // On pagination error: keep existing entries so user sees what they had
        // On page 1 / refresh error: show empty + error card
        entries: filter.page == 1 ? [] : state.entries,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        entries: filter.page == 1 ? [] : state.entries,
        error: e.toString(),
      );
    }
  }
}

// ─── My Rank Data ─────────────────────────────────────────────────────────────

class MyRankData {
  final int? rank;
  final int totalPoints;
  final double completionPercentage;
  final int streakDays;
  final bool isWinner;
  final String? winnerCategory;

  MyRankData({
    this.rank,
    required this.totalPoints,
    required this.completionPercentage,
    required this.streakDays,
    required this.isWinner,
    this.winnerCategory,
  });

  factory MyRankData.fromJson(Map<String, dynamic> json) => MyRankData(
        rank: json['rank'],
        totalPoints: json['totalPoints'] ?? 0,
        completionPercentage: (json['completionPercentage'] ?? 0).toDouble(),
        streakDays: json['streakDays'] ?? 0,
        isWinner: json['isWinner'] ?? false,
        winnerCategory: json['winnerCategory'],
      );
}

// ─── Providers ────────────────────────────────────────────────────────────────

// NOT autoDispose: the filter is UI state (selected month/department).
// It is reset explicitly by invalidateUserProviders().
final leaderboardFilterProvider = StateProvider<LeaderboardFilter>((ref) {
  final now = DateTime.now();
  return LeaderboardFilter(year: now.year, month: now.month);
});

// autoDispose: the notifier and its entries list are discarded when the shell
// leaves the tree. HomeScreen.initState() re-calls load() every time the
// shell is rebuilt, so no explicit reload is needed after login.
// final leaderboardProvider =
//     StateNotifierProvider.autoDispose<LeaderboardNotifier, LeaderboardState>(
//         (ref) {
//   return LeaderboardNotifier(ref.read(apiServiceProvider));
// });
// Full leaderboard for LeaderboardScreen (autoDispose — dies when screen leaves)
final leaderboardProvider =
    StateNotifierProvider.autoDispose<LeaderboardNotifier, LeaderboardState>(
  (ref) => LeaderboardNotifier(ref.read(apiServiceProvider)),
);

// Separate preview provider for HomeScreen (limit 3, independent lifecycle)
final leaderboardPreviewProvider =
    StateNotifierProvider.autoDispose<LeaderboardNotifier, LeaderboardState>(
  (ref) => LeaderboardNotifier(ref.read(apiServiceProvider)),
);

final myRankProvider =
    FutureProvider.autoDispose.family<MyRankData, ({int year, int month})>(
  (ref, params) async {
    final api = ref.read(apiServiceProvider);
    final response = await api.get<Map<String, dynamic>>(
      '/leaderboard/my-rank',
      queryParams: {'year': params.year, 'month': params.month},
    );
    return MyRankData.fromJson(response['data'] ?? {});
  },
);

final winnersProvider =
    FutureProvider.autoDispose.family<List<dynamic>, ({int year, int month})>(
  (ref, params) async {
    final api = ref.read(apiServiceProvider);
    final response = await api.get<Map<String, dynamic>>(
      '/leaderboard/winners',
      queryParams: {'year': params.year, 'month': params.month},
    );
    return response['data'] ?? [];
  },
);
