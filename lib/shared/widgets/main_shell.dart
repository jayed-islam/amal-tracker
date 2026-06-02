import 'package:amal_tracker/features/jannah_garden/screen/jannah_garden_screen.dart';
import 'package:amal_tracker/features/notification/widgets/notification_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amal_tracker/core/providers/connectivity_provider.dart';
import 'package:amal_tracker/features/home/screens/home_screen.dart';

import 'package:amal_tracker/features/leaderboard/screens/leaderboard_screen.dart';
import 'package:amal_tracker/features/tracker/screens/monthly_view_screen.dart';
import 'package:amal_tracker/features/tracker/screens/tracker_screen.dart';
import 'package:amal_tracker/shared/widgets/offline_banner.dart';

// ── Tab index constants — magic numbers ব্যবহার নেই ──────────────────────
enum AppTab {
  home,
  tracker,
  monthly,
  leaderboard,
  jannahGarden,
}

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  AppTab _activeTab = AppTab.home;

  // ── visitedTabs tracks which tabs have been opened at least once.
  // IndexedStack keeps every child alive, but we only BUILD a tab's
  // widget the first time the user taps it — this avoids unnecessary
  // API calls on startup (lazy initialisation, same as Instagram/Grab).
  final Set<AppTab> _visitedTabs = {AppTab.home};

  void _onTabTap(AppTab tab) {
    if (_activeTab == tab) {
      // Same tab tapped again → notify the tab to scroll to top.
      // Each screen listens to this notifier and scrolls if it has a list.
      tabScrollToTopNotifier.value = tab;
      return;
    }
    setState(() {
      _activeTab = tab;
      _visitedTabs.add(tab); // mark as visited so IndexedStack builds it
    });
  }

  @override
  Widget build(BuildContext context) {
    // ── Connectivity listener: online snackbar ─────────────────────────
    ref.listen<bool>(isOnlineProvider, (previous, next) {
      if (previous == false && next == true) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.wifi_rounded, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  'সংযোগ পুনরুদ্ধার হয়েছে',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            backgroundColor: ColorT.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          ),
        );
      }
    });

    return Scaffold(
      // ── IndexedStack — industry standard for bottom nav ───────────────
      //
      // WHY IndexedStack:
      //   • All visited tabs stay alive in memory (no API re-call on switch)
      //   • Scroll position is preserved (intended UX — like Instagram)
      //   • Unvisited tabs are NOT built yet (lazy loading)
      //
      // WHY NOT StatefulShellRoute.indexedStack:
      //   • That's a GoRouter abstraction for deep-linking across tabs
      //   • Adds complexity we don't need
      //   • Tab UX is a UI concern, not a routing concern
      //
      body: IndexedStack(
        index: _activeTab.index,
        children: AppTab.values.map((tab) {
          // Lazy: if tab hasn't been visited yet, render an empty box.
          // Once visited, the real screen is built and kept alive forever.
          if (!_visitedTabs.contains(tab)) return const SizedBox.shrink();

          return switch (tab) {
            AppTab.home => const HomeScreen(),
            AppTab.tracker => const TrackerScreen(),
            // Monthly and Leaderboard get a UniqueKey so they REBUILD
            // every time the user visits — fresh data, no stale state.
            // Home and Tracker preserve scroll/state like Instagram.
            AppTab.monthly => MonthlyViewScreen(key: UniqueKey()),
            AppTab.leaderboard => LeaderboardScreen(key: UniqueKey()),
            AppTab.jannahGarden => JannahWorldScreen(key: UniqueKey()),
          };
        }).toList(),
      ),

      // ── Bottom nav + offline banner ────────────────────────────────────
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const OfflineBanner(),
          _BottomNav(
            activeTab: _activeTab,
            onTap: _onTabTap,
          ),
        ],
      ),
    );
  }
}

// ── Scroll-to-top notifier ─────────────────────────────────────────────────
// When the user taps the active tab again, this fires.
// Screens that want scroll-to-top behaviour listen to this.
//
// Usage inside HomeScreen (example):
//   @override void initState() {
//     super.initState();
//     tabScrollToTopNotifier.addListener(_onScrollToTop);
//   }
//   void _onScrollToTop() {
//     if (tabScrollToTopNotifier.value == AppTab.home) {
//       _scrollController.animateTo(0, ...);
//     }
//   }
final ValueNotifier<AppTab?> tabScrollToTopNotifier = ValueNotifier(null);

// ── Bottom Navigation Bar ──────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final AppTab activeTab;
  final void Function(AppTab) onTap;

  const _BottomNav({required this.activeTab, required this.onTap});

  static const _items = [
    _NavItem(tab: AppTab.home, icon: Icons.home_rounded, label: 'হোম'),
    _NavItem(
        tab: AppTab.tracker, icon: Icons.list_alt_rounded, label: 'ট্র্যাকার'),
    _NavItem(
        tab: AppTab.monthly, icon: Icons.bar_chart_rounded, label: 'রিপোর্ট'),
    _NavItem(
        tab: AppTab.leaderboard,
        icon: Icons.emoji_events_rounded,
        label: 'র‍্যাংকিং'),
    _NavItem(
      tab: AppTab.jannahGarden,
      icon: Icons.park_rounded,
      label: 'জান্নাত',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorT.cardBg,
        border: Border(top: BorderSide(color: ColorT.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _items.map((item) {
              final active = item.tab == activeTab;
              return GestureDetector(
                onTap: () => onTap(item.tab),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: active ? ColorT.greenLight : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          item.icon,
                          key: ValueKey(active),
                          size: 22,
                          color:
                              active ? ColorT.darkGreen : ColorT.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: TextStyle(
                          color:
                              active ? ColorT.darkGreen : ColorT.textSecondary,
                          fontSize: 9,
                          fontWeight:
                              active ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final AppTab tab;
  final IconData icon;
  final String label;
  const _NavItem({
    required this.tab,
    required this.icon,
    required this.label,
  });
}
