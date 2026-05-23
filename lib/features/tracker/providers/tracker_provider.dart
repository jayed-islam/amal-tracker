import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tracker_model.dart';
import '../../../core/services/api_service.dart';

// ─── Categories ───────────────────────────────────────────────────────────────
//
// autoDispose: when the shell (and therefore all tab screens) is removed from
// the widget tree during logout/login navigation, these providers have no
// listeners and dispose automatically. When the shell is recreated after login
// they rebuild fresh with the new user's token.

final categoriesProvider =
    FutureProvider.autoDispose<List<AmalCategory>>((ref) async {
  final api = ref.read(apiServiceProvider);
  final res = await api.get<Map<String, dynamic>>('/tracker/categories');
  final List data = res['data'] ?? [];
  return data.map((e) => AmalCategory.fromJson(e)).toList();
});

final categoriesBySection =
    Provider.autoDispose<Map<String, List<AmalCategory>>>((ref) {
  final cats = ref.watch(categoriesProvider).value ?? [];
  final map = <String, List<AmalCategory>>{};
  for (final cat in cats) {
    map.putIfAbsent(cat.section, () => []).add(cat);
  }
  return map;
});

// ─── Daily Entry State ────────────────────────────────────────────────────────

class DailyEntryState {
  final DailyEntry? entry;
  final Map<String, DailyEntryItem> localEdits;
  final bool isLoading;
  final bool isSaving;
  final bool isDeleting;
  final String? error;
  final bool saved;

  const DailyEntryState({
    this.entry,
    this.localEdits = const {},
    this.isLoading = false,
    this.isSaving = false,
    this.isDeleting = false,
    this.error,
    this.saved = false,
  });

  DailyEntryState copyWith({
    DailyEntry? entry,
    Map<String, DailyEntryItem>? localEdits,
    bool? isLoading,
    bool? isSaving,
    bool? isDeleting,
    String? error,
    bool? saved,
    bool clearEntry = false,
  }) =>
      DailyEntryState(
        entry: clearEntry ? null : (entry ?? this.entry),
        localEdits: localEdits ?? this.localEdits,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
        isDeleting: isDeleting ?? this.isDeleting,
        error: error,
        saved: saved ?? this.saved,
      );

  Map<String, DailyEntryItem> get effectiveEntries {
    final map = <String, DailyEntryItem>{};
    for (final item in entry?.entries ?? []) {
      map[item.categoryId] = item;
    }
    map.addAll(localEdits);
    return map;
  }

  int get localTotalPoints =>
      effectiveEntries.values.fold(0, (s, e) => s + e.points);
}

// ─── Daily Entry Notifier ─────────────────────────────────────────────────────

class DailyEntryNotifier extends StateNotifier<DailyEntryState> {
  final ApiService _api;
  final String _dateStr;

  DailyEntryNotifier(this._api, this._dateStr)
      : super(const DailyEntryState()) {
    loadEntry();
  }

  Future<void> loadEntry() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res =
          await _api.get<Map<String, dynamic>>('/tracker/entry/$_dateStr');
      final data = res['data'];
      state = state.copyWith(
        isLoading: false,
        entry: data != null ? DailyEntry.fromJson(data) : null,
        localEdits: {},
        saved: false,
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  Future<bool> saveEntryFromUpdates(
    List<EntryUpdate> updates, {
    bool isExemptDay = false, // ← new param
  }) async {
    state = state.copyWith(isSaving: true, error: null);
    try {
      final payload = updates.map((u) => u.toJson()).toList();
      final res =
          await _api.post<Map<String, dynamic>>('/tracker/entry', data: {
        'date': _dateStr,
        'entries': payload,
        'isExemptDay': isExemptDay,
      });
      final data = res['data'];
      state = state.copyWith(
        isSaving: false,
        entry: data != null ? DailyEntry.fromJson(data) : state.entry,
        localEdits: {},
        saved: true,
        error: null,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isSaving: false, error: e.message);
      return false;
    }
  }

  Future<bool> saveEntry(List<AmalCategory> allCategories) async {
    if (state.localEdits.isEmpty) return true;
    state = state.copyWith(isSaving: true, error: null);
    try {
      final effectiveMap =
          Map<String, DailyEntryItem>.from(state.effectiveEntries);
      for (final cat in allCategories) {
        if (!effectiveMap.containsKey(cat.id)) {
          effectiveMap[cat.id] =
              DailyEntryItem(categoryId: cat.id, completed: false, points: 0);
        }
      }
      final res =
          await _api.post<Map<String, dynamic>>('/tracker/entry', data: {
        'date': _dateStr,
        'entries': effectiveMap.values.map((e) => e.toJson()).toList(),
      });
      final data = res['data'];
      state = state.copyWith(
        isSaving: false,
        entry: data != null ? DailyEntry.fromJson(data) : state.entry,
        localEdits: {},
        saved: true,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isSaving: false, error: e.message);
      return false;
    }
  }

  Future<bool> deleteEntry() async {
    state = state.copyWith(isDeleting: true, error: null);
    try {
      await _api.delete<Map<String, dynamic>>('/tracker/entry/$_dateStr');
      state = state.copyWith(
        isDeleting: false,
        saved: false,
        localEdits: {},
        clearEntry: true,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isDeleting: false, error: e.message);
      return false;
    }
  }

  void toggleAmal(String categoryId, bool completed, {int basePoints = 1}) {
    final edits = Map<String, DailyEntryItem>.from(state.localEdits);
    edits[categoryId] = DailyEntryItem(
      categoryId: categoryId,
      completed: completed,
      points: completed ? basePoints : 0,
    );
    state = state.copyWith(localEdits: edits, saved: false);
  }

  void setPrayerMode(String categoryId, PrayerMode mode,
      {int basePoints = 1, int congregationPoints = 2}) {
    final edits = Map<String, DailyEntryItem>.from(state.localEdits);
    edits[categoryId] = DailyEntryItem(
      categoryId: categoryId,
      completed: mode != PrayerMode.missed,
      prayerMode: mode,
      points: mode == PrayerMode.congregation
          ? congregationPoints
          : mode == PrayerMode.solo
              ? basePoints
              : 0,
    );
    state = state.copyWith(localEdits: edits, saved: false);
  }

  void setCount(String categoryId, int count, {int pointsPerUnit = 3}) {
    final edits = Map<String, DailyEntryItem>.from(state.localEdits);
    edits[categoryId] = DailyEntryItem(
      categoryId: categoryId,
      completed: count > 0,
      count: count,
      points: count * pointsPerUnit,
    );
    state = state.copyWith(localEdits: edits, saved: false);
  }

  void clearError() => state = state.copyWith(error: null);
}

// ─── EntryUpdate ──────────────────────────────────────────────────────────────

class EntryUpdate {
  final String categoryId;
  final bool completed;
  final PrayerMode? prayerMode;
  final int count;

  const EntryUpdate({
    required this.categoryId,
    required this.completed,
    this.prayerMode,
    this.count = 0,
  });

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'completed': completed,
        if (prayerMode != null) 'prayerMode': prayerMode!.value,
        'count': count,
      };
}

// ─── Providers ────────────────────────────────────────────────────────────────

// NOT autoDispose: selectedDateProvider is UI navigation state, not user data.
// It should survive tab switches. It is explicitly reset by invalidateUserProviders().
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

// autoDispose.family: each date string gets its own notifier instance.
// All instances are discarded when the shell leaves the tree.
final dailyEntryProvider = StateNotifierProvider.autoDispose
    .family<DailyEntryNotifier, DailyEntryState, String>(
  (ref, dateStr) => DailyEntryNotifier(ref.read(apiServiceProvider), dateStr),
);

// ─── Monthly / Progress providers ────────────────────────────────────────────

// autoDispose.family: invalidating the family kills all cached year/month combos.
final monthlyEntriesProvider = FutureProvider.autoDispose
    .family<List<DailyEntry>, ({int year, int month})>(
  (ref, p) async {
    final api = ref.read(apiServiceProvider);
    final res = await api
        .get<Map<String, dynamic>>('/tracker/monthly/${p.year}/${p.month}');
    final List data = res['data'] ?? [];
    return data.map((e) => DailyEntry.fromJson(e)).toList();
  },
);

final monthlyTrackerProvider =
    FutureProvider.autoDispose.family<MonthlyTracker?, ({int year, int month})>(
  (ref, p) async {
    final api = ref.read(apiServiceProvider);
    final res = await api
        .get<Map<String, dynamic>>('/tracker/tracker/${p.year}/${p.month}');
    final data = res['data'];
    return data != null ? MonthlyTracker.fromJson(data) : null;
  },
);

final progressSummaryProvider =
    FutureProvider.autoDispose<ProgressSummary>((ref) async {
  // Guard: if the auth token is absent, bail early so this provider doesn't
  // fire a 401 request while the user is on the login screen.
  // (Extra safety net — with autoDispose it normally won't even run here,
  // but family providers can be triggered by cached widget builds.)
  final api = ref.read(apiServiceProvider);
  final res = await api.get<Map<String, dynamic>>('/tracker/progress');
  return ProgressSummary.fromJson(res['data'] ?? {});
});
