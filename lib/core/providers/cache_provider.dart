import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CacheTab { home, monthly, leaderboard }

class TabCacheMetadata {
  final bool isDirty;
  final DateTime lastFetched;

  const TabCacheMetadata({
    required this.isDirty,
    required this.lastFetched,
  });

  TabCacheMetadata copyWith({
    bool? isDirty,
    DateTime? lastFetched,
  }) {
    return TabCacheMetadata(
      isDirty: isDirty ?? this.isDirty,
      lastFetched: lastFetched ?? this.lastFetched,
    );
  }
}

class CacheStatusState {
  final Map<CacheTab, TabCacheMetadata> tabs;

  const CacheStatusState(this.tabs);

  bool isDirty(CacheTab tab) => tabs[tab]?.isDirty ?? true;
  DateTime lastFetched(CacheTab tab) => tabs[tab]?.lastFetched ?? DateTime.fromMillisecondsSinceEpoch(0);
}

class CacheStatusNotifier extends StateNotifier<CacheStatusState> {
  CacheStatusNotifier()
      : super(CacheStatusState({
          CacheTab.home: TabCacheMetadata(isDirty: true, lastFetched: DateTime.fromMillisecondsSinceEpoch(0)),
          CacheTab.monthly: TabCacheMetadata(isDirty: true, lastFetched: DateTime.fromMillisecondsSinceEpoch(0)),
          CacheTab.leaderboard: TabCacheMetadata(isDirty: true, lastFetched: DateTime.fromMillisecondsSinceEpoch(0)),
        }));

  void markDirty(CacheTab tab) {
    state = CacheStatusState({
      ...state.tabs,
      tab: state.tabs[tab]!.copyWith(isDirty: true),
    });
  }

  void markAllDirty() {
    state = CacheStatusState({
      CacheTab.home: state.tabs[CacheTab.home]!.copyWith(isDirty: true),
      CacheTab.monthly: state.tabs[CacheTab.monthly]!.copyWith(isDirty: true),
      CacheTab.leaderboard: state.tabs[CacheTab.leaderboard]!.copyWith(isDirty: true),
    });
  }

  void updateLastFetched(CacheTab tab) {
    state = CacheStatusState({
      ...state.tabs,
      tab: TabCacheMetadata(
        isDirty: false,
        lastFetched: DateTime.now(),
      ),
    });
  }

  void checkTtlAndMarkDirty() {
    final now = DateTime.now();
    final updatedTabs = <CacheTab, TabCacheMetadata>{};
    bool changed = false;

    state.tabs.forEach((tab, metadata) {
      final ttl = _getTtlForTab(tab);
      if (!metadata.isDirty && now.difference(metadata.lastFetched) > ttl) {
        updatedTabs[tab] = metadata.copyWith(isDirty: true);
        changed = true;
      } else {
        updatedTabs[tab] = metadata;
      }
    });

    if (changed) {
      state = CacheStatusState(updatedTabs);
    }
  }

  Duration _getTtlForTab(CacheTab tab) {
    switch (tab) {
      case CacheTab.home:
        return const Duration(minutes: 5);
      case CacheTab.monthly:
        return const Duration(minutes: 10);
      case CacheTab.leaderboard:
        return const Duration(minutes: 5);
    }
  }
}

final cacheStatusProvider =
    StateNotifierProvider<CacheStatusNotifier, CacheStatusState>((ref) {
  return CacheStatusNotifier();
});

final activeTabIndexProvider = StateProvider<int>((ref) => 0);

void checkAndRefreshTab(
  WidgetRef ref,
  CacheTab tab,
  void Function() onRefresh, {
  Duration ttl = const Duration(minutes: 5),
}) {
  final cacheStatus = ref.read(cacheStatusProvider);
  final isDirty = cacheStatus.isDirty(tab);
  final lastFetched = cacheStatus.lastFetched(tab);
  final isExpired = DateTime.now().difference(lastFetched) > ttl;

  if (isDirty || isExpired) {
    // Clear dirty flag and update lastFetched immediately to prevent duplicate runs
    ref.read(cacheStatusProvider.notifier).updateLastFetched(tab);
    // Execute refresh
    onRefresh();
  }
}
