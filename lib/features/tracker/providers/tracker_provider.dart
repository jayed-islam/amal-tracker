
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tracker_model.dart';
import '../../../core/services/api_service.dart';

// ─── Categories ───────────────────────────────────────────────────────────────

final categoriesProvider =
    FutureProvider.autoDispose<List<AmalCategory>>((ref) async {
  final api = ref.read(apiServiceProvider);
  final res = await api.get<Map<String, dynamic>>('/tracker/categories');
  final List data = res['data'] ?? [];
  return data.map((e) => AmalCategory.fromJson(e)).toList();
});

// ⚠️ IMPORTANT — AsyncValue.value vs AsyncValue.valueOrNull:
// `.value` RETHROWS the underlying error when the watched provider is in an
// AsyncError state (e.g. "no internet connection"). That rethrow used to
// propagate uncaught out of this derived provider straight into
// TrackerScreen's build(), crashing the widget tree with a red error screen
// — even though TrackerScreen already has proper error UI (`hasError`,
// `_ErrorCard`) that never got a chance to run.
// `.valueOrNull` NEVER throws — it simply returns null while loading or on
// error, which is exactly what a "best effort" derived provider like this
// one needs. Any derived/computed provider that reads another provider's
// AsyncValue must use `.valueOrNull` (or `.when(...)`), never bare `.value`.
final categoriesBySection =
    Provider.autoDispose<Map<String, List<AmalCategory>>>((ref) {
  final cats = ref.watch(categoriesProvider).valueOrNull ?? [];
  final map = <String, List<AmalCategory>>{};
  for (final cat in cats) {
    map.putIfAbsent(cat.section, () => []).add(cat);
  }
  for (final key in map.keys) {
    map[key]!.sort((a, b) => a.order.compareTo(b.order));
  }
  return map;
});

// ─── Daily Entry State ────────────────────────────────────────────────────────

class DailyEntryState {
  final DailyEntry? entry;
  final bool isLoading;
  final bool isSaving;
  final bool isDeleting;
  final String? error;
  final bool saved;

  const DailyEntryState({
    this.entry,
    this.isLoading = false,
    this.isSaving = false,
    this.isDeleting = false,
    this.error,
    this.saved = false,
  });

  DailyEntryState copyWith({
    DailyEntry? entry,
    bool? isLoading,
    bool? isSaving,
    bool? isDeleting,
    String? error,
    bool? saved,
    bool clearEntry = false,
  }) =>
      DailyEntryState(
        entry: clearEntry ? null : (entry ?? this.entry),
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
        isDeleting: isDeleting ?? this.isDeleting,
        error: error,
        saved: saved ?? this.saved,
      );

  // Server entry থেকে effective map — sheet এ pre-fill করার জন্য
  Map<String, DailyEntryItem> get effectiveEntries {
    final map = <String, DailyEntryItem>{};
    for (final item in entry?.entries ?? []) {
      map[item.categoryId] = item;
    }
    return map;
  }
}

// ─── Daily Entry Notifier ─────────────────────────────────────────────────────
//
// প্রতিটি async action (load/save/delete) দুই স্তরে error ধরে:
//   1) `on ApiException catch (e)` — api_service থেকে আসা expected error
//      (network/timeout/server/validation) — এর message সরাসরি user-facing।
//   2) `catch (e)` fallback — কোনো অপ্রত্যাশিত error (JSON parse বাগ, null
//      cast, ইত্যাদি) যেন কখনোই uncaught exception হয়ে UI crash না করায়।
//      Production app-এ silent crash-এর চেয়ে "কিছু একটা ভুল হয়েছে" দেখানো
//      অনেক ভালো — user retry করতে পারে, app খারাপও হয় না।

class DailyEntryNotifier extends StateNotifier<DailyEntryState> {
  final ApiService _api;
  final String _dateStr;

  DailyEntryNotifier(this._api, this._dateStr)
      : super(const DailyEntryState()) {
    loadEntry();
  }

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> loadEntry() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res =
          await _api.get<Map<String, dynamic>>('/tracker/entry/$_dateStr');
      final data = res['data'];
      state = state.copyWith(
        isLoading: false,
        entry: data != null ? DailyEntry.fromJson(data) : null,
        saved: false,
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      // অপ্রত্যাশিত error (parse error, null issue ইত্যাদি) — crash না করে
      // graceful error state দেখাও।
      state = state.copyWith(
        isLoading: false,
        error: 'কিছু একটা ভুল হয়েছে। আবার চেষ্টা করুন।',
      );
    }
  }

  // ── Save ──────────────────────────────────────────────────────────────────

  Future<bool> saveEntryFromUpdates(
    List<EntryUpdate> updates, {
    bool isExemptDay = false,
  }) async {
    state = state.copyWith(isSaving: true, error: null);
    try {
      final res =
          await _api.post<Map<String, dynamic>>('/tracker/entry', data: {
        'date': _dateStr,
        'entries': updates.map((u) => u.toJson()).toList(),
        'isExemptDay': isExemptDay,
      });
      final data = res['data'];
      state = state.copyWith(
        isSaving: false,
        entry: data != null ? DailyEntry.fromJson(data) : state.entry,
        saved: true,
        error: null,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isSaving: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'সেভ করতে সমস্যা হয়েছে। আবার চেষ্টা করুন।',
      );
      return false;
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<bool> deleteEntry() async {
    state = state.copyWith(isDeleting: true, error: null);
    try {
      await _api.delete<Map<String, dynamic>>('/tracker/entry/$_dateStr');
      state = state.copyWith(
        isDeleting: false,
        saved: false,
        clearEntry: true,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isDeleting: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isDeleting: false,
        error: 'মুছতে সমস্যা হয়েছে। আবার চেষ্টা করুন।',
      );
      return false;
    }
  }

  void clearError() => state = state.copyWith(error: null);
}

// ─── Entry Update ─────────────────────────────────────────────────────────────

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

// ─── Selected Date ────────────────────────────────────────────────────────────

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

// ─── Daily Entry Provider ─────────────────────────────────────────────────────

final dailyEntryProvider = StateNotifierProvider.autoDispose
    .family<DailyEntryNotifier, DailyEntryState, String>(
  (ref, dateStr) => DailyEntryNotifier(ref.read(apiServiceProvider), dateStr),
);

// ─── Monthly Entries ──────────────────────────────────────────────────────────

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

// ─── Monthly Tracker (raw document, rarely needed directly — prefer
//     progressSummaryProvider which already includes currentMonth) ───────────

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

// ─── Home Summary ─────────────────────────────────────────────────────────────
// GET /tracker/home-summary — home screen প্রথম লোডের জন্য, lightweight।
// কোনো category catalog লাগে না, কোনো year/month param লাগে না (সবসময়
// আজকের + বর্তমান মাসের সংক্ষিপ্ত glance)।

final homeSummaryProvider =
    FutureProvider.autoDispose<HomeSummary>((ref) async {
  final api = ref.read(apiServiceProvider);
  final res = await api.get<Map<String, dynamic>>('/tracker/home-summary');
  return HomeSummary.fromJson(res['data'] ?? {});
});

// ─── Monthly Progress ─────────────────────────────────────────────────────────
// GET /tracker/monthly-progress?year=&month= — মাসিক স্ক্রিনের জন্য।
// আগে endpoint ছিল /tracker/progress, রিনেম হয়েছে যাতে home vs monthly
// স্পষ্ট আলাদা থাকে (home হালকা, এটা পূর্ণাঙ্গ)।

final progressSummaryProvider = FutureProvider.autoDispose
    .family<ProgressSummary, ({int year, int month})>((ref, params) async {
  final api = ref.read(apiServiceProvider);
  final res = await api.get<Map<String, dynamic>>(
    '/tracker/monthly-progress?year=${params.year}&month=${params.month}',
  );
  return ProgressSummary.fromJson(res['data'] ?? {});
});

// ─── Monthly Comparison ───────────────────────────────────────────────────────
// GET /tracker/compare?months=2025-06,2025-05

final monthlyComparisonProvider = FutureProvider.autoDispose
    .family<List<dynamic>, List<String>>((ref, monthKeys) async {
  final api = ref.read(apiServiceProvider);
  final query = monthKeys.join(',');
  final res =
      await api.get<Map<String, dynamic>>('/tracker/compare?months=$query');
  return res['data'] ?? [];
});

// ─── Section Progress ─────────────────────────────────────────────────────────
// GET /tracker/section?year=&month=&section=

final sectionProgressProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, ({int year, int month, String? section})>(
  (ref, p) async {
    final api = ref.read(apiServiceProvider);
    final sectionQuery = p.section != null ? '&section=${p.section}' : '';
    final res = await api.get<Map<String, dynamic>>(
      '/tracker/section?year=${p.year}&month=${p.month}$sectionQuery',
    );
    return res['data'] ?? {};
  },
);

// ─── Category Progress ────────────────────────────────────────────────────────
// GET /tracker/category/:categoryId/progress?months=3

final categoryProgressProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, ({String categoryId, int months})>(
  (ref, p) async {
    final api = ref.read(apiServiceProvider);
    final res = await api.get<Map<String, dynamic>>(
      '/tracker/category/${p.categoryId}/progress?months=${p.months}',
    );
    return res['data'] ?? {};
  },
);
