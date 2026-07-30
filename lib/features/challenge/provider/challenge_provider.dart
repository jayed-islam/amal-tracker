import 'package:amal_tracker/features/challenge/model/challenge_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_service.dart';
// ─────────────────────────────────────────────────────────────────────────
// ACTIVE CHALLENGES — GET /challenges
// ─────────────────────────────────────────────────────────────────────────

final activeChallengesProvider =
    FutureProvider.autoDispose<List<Challenge>>((ref) async {
  final api = ref.read(apiServiceProvider);
  final res = await api.get<Map<String, dynamic>>('/challenges');
  final List data = res['data'] ?? [];
  return data
      .map((e) => Challenge.fromJson(Map<String, dynamic>.from(e)))
      .toList();
});

// ─────────────────────────────────────────────────────────────────────────
// CHALLENGE DETAIL — GET /challenges/:id
// ─────────────────────────────────────────────────────────────────────────

final challengeDetailProvider = FutureProvider.autoDispose
    .family<Challenge, String>((ref, challengeId) async {
  final api = ref.read(apiServiceProvider);
  final res = await api.get<Map<String, dynamic>>('/challenges/$challengeId');
  return Challenge.fromJson(Map<String, dynamic>.from(res['data'] ?? {}));
});

// ─────────────────────────────────────────────────────────────────────────
// MY PROGRESS — GET /challenges/:id/my-progress
// শুধু joined থাকলেই কল হবে (কলার-সাইড guard, UI তে দেখুন)
// ─────────────────────────────────────────────────────────────────────────

final myProgressProvider = FutureProvider.autoDispose
    .family<MyProgressDetail, String>((ref, challengeId) async {
  final api = ref.read(apiServiceProvider);
  final res = await api
      .get<Map<String, dynamic>>('/challenges/$challengeId/my-progress');
  return MyProgressDetail.fromJson(
      Map<String, dynamic>.from(res['data'] ?? {}));
});

// ─────────────────────────────────────────────────────────────────────────
// LEADERBOARD — GET /challenges/:id/leaderboard?page=&limit=
// Paginated, infinite-scroll ধরনের state notifier।
// ─────────────────────────────────────────────────────────────────────────

class LeaderboardState {
  final List<LeaderboardEntry> entries;
  final int page;
  final int limit;
  final int total;
  final bool isLoading; // প্রথম লোড
  final bool isLoadingMore;
  final String? error;

  const LeaderboardState({
    this.entries = const [],
    this.page = 0,
    this.limit = 20,
    this.total = 0,
    this.isLoading = true,
    this.isLoadingMore = false,
    this.error,
  });

  bool get hasMore => entries.length < total;

  LeaderboardState copyWith({
    List<LeaderboardEntry>? entries,
    int? page,
    int? total,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool clearError = false,
  }) =>
      LeaderboardState(
        entries: entries ?? this.entries,
        page: page ?? this.page,
        limit: limit,
        total: total ?? this.total,
        isLoading: isLoading ?? this.isLoading,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        error: clearError ? null : (error ?? this.error),
      );
}

class LeaderboardNotifier extends StateNotifier<LeaderboardState> {
  final ApiService _api;
  final String _challengeId;

  LeaderboardNotifier(this._api, this._challengeId)
      : super(const LeaderboardState()) {
    loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final res = await _api.get<Map<String, dynamic>>(
          '/challenges/$_challengeId/leaderboard?page=1&limit=${state.limit}');
      final List data = res['data'] ?? [];
      final meta = Map<String, dynamic>.from(res['meta'] ?? {});
      state = state.copyWith(
        entries: data
            .map((e) => LeaderboardEntry.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        page: 1,
        total: (meta['total'] as num?)?.toInt() ?? data.length,
        isLoading: false,
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true, clearError: true);
    try {
      final nextPage = state.page + 1;
      final res = await _api.get<Map<String, dynamic>>(
          '/challenges/$_challengeId/leaderboard?page=$nextPage&limit=${state.limit}');
      final List data = res['data'] ?? [];
      final meta = Map<String, dynamic>.from(res['meta'] ?? {});
      state = state.copyWith(
        entries: [
          ...state.entries,
          ...data.map(
              (e) => LeaderboardEntry.fromJson(Map<String, dynamic>.from(e))),
        ],
        page: nextPage,
        total: (meta['total'] as num?)?.toInt() ?? state.total,
        isLoadingMore: false,
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.message);
    }
  }

  Future<void> refresh() => loadFirstPage();
}

final leaderboardProvider = StateNotifierProvider.autoDispose
    .family<LeaderboardNotifier, LeaderboardState, String>(
  (ref, challengeId) =>
      LeaderboardNotifier(ref.read(apiServiceProvider), challengeId),
);

// ─────────────────────────────────────────────────────────────────────────
// LEADERBOARD PREVIEW (top 3) — challenge detail স্ক্রিনের হেড-লাইন অংশে
// হালকা প্রিভিউ দেখানোর জন্য, পুরো পেজিনেটেড state ছাড়াই।
// ─────────────────────────────────────────────────────────────────────────

final leaderboardPreviewForChallengeProvider = FutureProvider.autoDispose
    .family<List<LeaderboardEntry>, String>((ref, challengeId) async {
  final api = ref.read(apiServiceProvider);
  final res = await api.get<Map<String, dynamic>>(
      '/challenges/$challengeId/leaderboard?page=1&limit=3');
  final List data = res['data'] ?? [];
  return data
      .map((e) => LeaderboardEntry.fromJson(Map<String, dynamic>.from(e)))
      .toList();
});

// ─────────────────────────────────────────────────────────────────────────
// ACTIONS — join / leave / update progress
// একটা AsyncValue<void> state যা শুধু button-level loading/error দেখানোর
// জন্য ব্যবহার হয়; সফল হলে সংশ্লিষ্ট সব provider invalidate করে দেয় যাতে
// list/detail/leaderboard/my-progress সব জায়গায় fresh data দেখা যায়।
// ─────────────────────────────────────────────────────────────────────────

class ChallengeActionNotifier extends StateNotifier<AsyncValue<void>> {
  final ApiService _api;
  final Ref _ref;
  final String challengeId;

  ChallengeActionNotifier(this._api, this._ref, this.challengeId)
      : super(const AsyncValue.data(null));

  void _refreshAll() {
    _ref.refresh(activeChallengesProvider);
    _ref.refresh(challengeDetailProvider(challengeId));
    _ref.refresh(myProgressProvider(challengeId));
    _ref.refresh(leaderboardPreviewForChallengeProvider(challengeId));
    // leaderboard এর পেজিনেটেড state রিফ্রেশ করা — পুরো recreate না করে
    if (_ref.exists(leaderboardProvider(challengeId))) {
      _ref.read(leaderboardProvider(challengeId).notifier).refresh();
    }
  }

  Future<bool> join() async {
    state = const AsyncValue.loading();
    try {
      await _api.post<Map<String, dynamic>>('/challenges/$challengeId/join');
      _refreshAll();
      state = const AsyncValue.data(null);
      return true;
    } on ApiException catch (e, st) {
      state = AsyncValue.error(e.message, st);
      return false;
    }
  }

  Future<bool> leave() async {
    state = const AsyncValue.loading();
    try {
      await _api.delete<Map<String, dynamic>>('/challenges/$challengeId/leave');
      _refreshAll();
      state = const AsyncValue.data(null);
      return true;
    } on ApiException catch (e, st) {
      state = AsyncValue.error(e.message, st);
      return false;
    }
  }

  /// রিটার্ন করে isJustCompleted — UI তে celebration দেখানোর জন্য
  Future<({bool success, bool isJustCompleted, String? errorMessage})>
      updateProgress({
    required int addValue,
    int? surahNumber,
    int? ayahInSurah,
  }) async {
    state = const AsyncValue.loading();
    try {
      final res = await _api.post<Map<String, dynamic>>(
          '/challenges/$challengeId/progress',
          data: {
            'addValue': addValue,
            if (surahNumber != null) 'surahNumber': surahNumber,
            if (ayahInSurah != null) 'ayahInSurah': ayahInSurah,
          });
      final data = Map<String, dynamic>.from(res['data'] ?? {});
      _refreshAll();
      state = const AsyncValue.data(null);
      return (
        success: true,
        isJustCompleted: data['isJustCompleted'] == true,
        errorMessage: null,
      );
    } on ApiException catch (e, st) {
      state = AsyncValue.error(e.message, st);
      return (success: false, isJustCompleted: false, errorMessage: e.message);
    }
  }
}

final challengeActionProvider = StateNotifierProvider.autoDispose
    .family<ChallengeActionNotifier, AsyncValue<void>, String>(
  (ref, challengeId) =>
      ChallengeActionNotifier(ref.read(apiServiceProvider), ref, challengeId),
);
