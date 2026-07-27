import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../tracker/providers/tracker_provider.dart';
import '../../leaderboard/providers/leaderboard_provider.dart';
import '../../../core/providers/cache_provider.dart';

/// Invalidates every provider that holds user-specific data.
/// Call this ONLY for user login/logout scenarios
void invalidateUserProviders(WidgetRef ref) {
  // ── Tracker ─────────────────────────────────────────────────────────────
  ref.invalidate(progressSummaryProvider);
  ref.invalidate(categoriesProvider);
  ref.invalidate(categoriesBySection);
  ref.invalidate(dailyEntryProvider);
  ref.invalidate(monthlyEntriesProvider);
  ref.invalidate(monthlyTrackerProvider);
  ref.invalidate(selectedDateProvider);

  // ── Leaderboard ──────────────────────────────────────────────────────────
  ref.invalidate(leaderboardProvider);
  ref.invalidate(leaderboardFilterProvider);
  ref.invalidate(myRankProvider);
}

// Entry save/update/delete এর পর call করো
// শুধু currently visible data refresh করে
void refreshAfterEntryUpdate(
  WidgetRef ref, {
  required int year,
  required int month,
  String? specificDateStr,
}) {
  if (specificDateStr != null) {
    ref.invalidate(dailyEntryProvider(specificDateStr));
  }
  
  // Mark all pages dirty so they refetch on their next lazy load/visit
  ref.read(cacheStatusProvider.notifier).markAllDirty();
}
