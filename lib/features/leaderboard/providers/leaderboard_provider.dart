import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../tracker/models/tracker_model.dart';
import '../../auth/providers/auth_provider.dart';

// ─── Leaderboard Filter ───────────────────────────────────────────────────────

class LeaderboardFilter {
  final int year;
  final int month;
  final String? department;
  final String? gender; // "male" | "female" | null (সবাই)
  final int page;
  final int limit;

  const LeaderboardFilter({
    required this.year,
    required this.month,
    this.department,
    this.gender,
    this.page = 1,
    this.limit = 30,
  });

  LeaderboardFilter copyWith({
    int? year,
    int? month,
    String? department,
    String? gender,
    bool clearGender = false,
    int? page,
  }) =>
      LeaderboardFilter(
        year: year ?? this.year,
        month: month ?? this.month,
        department: department ?? this.department,
        gender: clearGender ? null : (gender ?? this.gender),
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

  Future<void> load(LeaderboardFilter filter, {bool refresh = false}) async {
    if (refresh || filter.page == 1) {
      state = const LeaderboardState(isLoading: true);
    } else {
      state = state.copyWith(isLoadingMore: true, clearError: true);
    }

    try {
      final params = <String, dynamic>{
        'year': filter.year,
        'month': filter.month,
        'page': filter.page,
        'limit': filter.limit,
        if (filter.department != null) 'department': filter.department,
        if (filter.gender != null) 'gender': filter.gender, // gender pass
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
        entries:
            filter.page == 1 ? newEntries : [...state.entries, ...newEntries],
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

// Filter provider — current user এর gender default হিসেবে
// user login করলে তার gender automatically set হবে
final leaderboardFilterProvider = StateProvider<LeaderboardFilter>((ref) {
  final now = DateTime.now();
  final user = ref.watch(currentUserProvider);
  // default: current user এর gender (male/female)
  // user null হলে null (সবাই দেখাবে)
  return LeaderboardFilter(
    year: now.year,
    month: now.month,
    gender: user?.gender, // auto set from current user
  );
});

final leaderboardProvider =
    StateNotifierProvider.autoDispose<LeaderboardNotifier, LeaderboardState>(
  (ref) => LeaderboardNotifier(ref.read(apiServiceProvider)),
);

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

final publicProfileProvider = FutureProvider.autoDispose
    .family<PublicMonthlyDetail, ({String userId, int year, int month})>(
  (ref, params) async {
    final api = ref.read(apiServiceProvider);
    final response = await api.get<Map<String, dynamic>>(
      '/tracker/profile/${params.userId}/${params.year}/${params.month}',
    );
    return PublicMonthlyDetail.fromJson(response['data'] ?? {});
  },
);
