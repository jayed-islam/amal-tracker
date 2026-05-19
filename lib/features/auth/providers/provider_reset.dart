import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../tracker/providers/tracker_provider.dart';
import '../../leaderboard/providers/leaderboard_provider.dart';

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
  ref.invalidate(leaderboardPreviewProvider);
  ref.invalidate(leaderboardFilterProvider);
  ref.invalidate(myRankProvider);
  ref.invalidate(winnersProvider);
}

/// Refreshes data AFTER submitting/updating/deleting an entry
/// This is more targeted and efficient than invalidateUserProviders
void refreshAfterEntryUpdate(
  WidgetRef ref, {
  required int year,
  required int month,
  String? specificDateStr, // Format: YYYY-MM-DD
}) {
  // 1. Refresh the specific date entry (if provided)
  if (specificDateStr != null) {
    ref.invalidate(dailyEntryProvider(specificDateStr));
  }

  // 2. Refresh monthly data for the affected month
  ref.invalidate(monthlyEntriesProvider((year: year, month: month)));
  ref.invalidate(monthlyTrackerProvider((year: year, month: month)));

  // 3. Refresh home screen stats (if watching current month)
  ref.invalidate(progressSummaryProvider);

  // 4. Refresh leaderboard for this specific month
  final currentFilter = ref.read(leaderboardFilterProvider);
  ref.invalidate(leaderboardProvider);

  // 5. Refresh user's rank for this month
  ref.invalidate(myRankProvider((year: year, month: month)));

  // 6. If the updated date is in current month, also refresh winners
  final now = DateTime.now();
  if (year == now.year && month == now.month) {
    ref.invalidate(winnersProvider);
  }

  // 7. OPTIONAL: If you have monthly view for other months,
  //    you might want to invalidate adjacent months
  // ref.invalidate(monthlyEntriesProvider((year: year, month: month - 1)));
  // ref.invalidate(monthlyEntriesProvider((year: year, month: month + 1)));
}

/// Use this when you need to refresh everything (after bulk operations)
void refreshAllTrackingData(WidgetRef ref) {
  final now = DateTime.now();

  // Refresh current and previous 2 months (for leaderboard)
  for (int i = 0; i < 3; i++) {
    final date = DateTime(now.year, now.month - i);
    ref.invalidate(
        monthlyEntriesProvider((year: date.year, month: date.month)));
    ref.invalidate(myRankProvider((year: date.year, month: date.month)));
  }

  ref.invalidate(progressSummaryProvider);
  ref.invalidate(leaderboardProvider);
  ref.invalidate(winnersProvider);
  ref.invalidate(dailyEntryProvider);
  ref.invalidate(leaderboardPreviewProvider);
}
