// import 'package:amal_tracker/features/home/screens/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class MainShell extends StatelessWidget {
//   final StatefulNavigationShell navigationShell;

//   const MainShell({super.key, required this.navigationShell});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // navigationShell IS the body — it owns the IndexedStack internally
//       body: navigationShell,
//       bottomNavigationBar: _BottomNav(
//         currentIndex: navigationShell.currentIndex,
//         onTap: _onTap,
//       ),
//     );
//   }

//   void _onTap(int index) {
//     navigationShell.goBranch(
//       index,
//       // Tapping the CURRENT tab pops its stack back to the branch root.
//       // Tapping a DIFFERENT tab restores that branch's last location.
//       initialLocation: index == navigationShell.currentIndex,
//     );
//   }
// }

// // ── Bottom Navigation Bar ──────────────────────────────────────────────────

// class _BottomNav extends StatelessWidget {
//   final int currentIndex;
//   final void Function(int) onTap;

//   const _BottomNav({required this.currentIndex, required this.onTap});

//   static const _items = [
//     _NavItem(icon: Icons.home_rounded, label: 'হোম'),
//     _NavItem(icon: Icons.list_alt_rounded, label: 'ট্র্যাকার'),
//     _NavItem(icon: Icons.bar_chart_rounded, label: 'রিপোর্ট'),
//     _NavItem(icon: Icons.emoji_events_rounded, label: 'র‍্যাংকিং'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: ColorT.cardBg,
//         border: Border(top: BorderSide(color: ColorT.border, width: 0.5)),
//       ),
//       child: SafeArea(
//         top: false,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: List.generate(_items.length, (index) {
//               final active = index == currentIndex;
//               return GestureDetector(
//                 onTap: () => onTap(index),
//                 behavior: HitTestBehavior.opaque, // bigger tap area
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   curve: Curves.easeInOut,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 7,
//                   ),
//                   decoration: BoxDecoration(
//                     color: active ? ColorT.greenLight : Colors.transparent,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       AnimatedSwitcher(
//                         duration: const Duration(milliseconds: 200),
//                         child: Icon(
//                           _items[index].icon,
//                           key: ValueKey(active),
//                           size: 22,
//                           color:
//                               active ? ColorT.darkGreen : ColorT.textSecondary,
//                         ),
//                       ),
//                       const SizedBox(height: 3),
//                       Text(
//                         _items[index].label,
//                         style: TextStyle(
//                           color:
//                               active ? ColorT.darkGreen : ColorT.textSecondary,
//                           fontSize: 9,
//                           fontWeight:
//                               active ? FontWeight.w700 : FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _NavItem {
//   final IconData icon;
//   final String label;
//   const _NavItem({required this.icon, required this.label});
// }
// lib/shared/widgets/main_shell.dart  — complete replacement

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:amal_tracker/core/providers/connectivity_provider.dart';
// import 'package:amal_tracker/features/home/screens/home_screen.dart'
//     show ColorT;
// import 'package:amal_tracker/shared/widgets/offline_banner.dart';

// // ─── MainShell ────────────────────────────────────────────────────────────────
// //
// // Key changes from the original:
// //   • Converted to ConsumerStatefulWidget so ref.listen can fire a snackbar.
// //   • OfflineBanner inserted between SafeArea and the body.
// //   • ref.listen on isOnlineProvider: when the user comes back online the shell
// //     shows a "সংযোগ পুনরুদ্ধার হয়েছে ✓" snackbar and auto-dismisses.

// class MainShell extends ConsumerStatefulWidget {
//   final StatefulNavigationShell navigationShell;

//   const MainShell({super.key, required this.navigationShell});

//   @override
//   ConsumerState<MainShell> createState() => _MainShellState();
// }

// class _MainShellState extends ConsumerState<MainShell> {
//   // Track previous online state so we only show the "back online" snackbar
//   // when transitioning from offline → online, not on initial load.
//   bool? _wasOnline;

//   @override
//   Widget build(BuildContext context) {
//     // ref.listen fires on every change AFTER the first build.
//     ref.listen<bool>(isOnlineProvider, (previous, next) {
//       // previous == false && next == true  →  just came back online
//       if (previous == false && next == true) {
//         _showBackOnlineSnackbar();
//       }
//       _wasOnline = next;
//     });

//     return Scaffold(
//       // ── Body: offline banner stacked above the shell content ──────────────
//       body: Column(
//         children: [
//           // The banner animates its own height (46 → 0) so no layout jumps.
//           const OfflineBanner(),
//           // navigationShell owns its own IndexedStack internally.
//           Expanded(child: widget.navigationShell),
//         ],
//       ),
//       bottomNavigationBar: _BottomNav(
//         currentIndex: widget.navigationShell.currentIndex,
//         onTap: _onTap,
//       ),
//     );
//   }

//   void _onTap(int index) {
//     widget.navigationShell.goBranch(
//       index,
//       initialLocation: index == widget.navigationShell.currentIndex,
//     );
//   }

//   void _showBackOnlineSnackbar() {
//     // Clear any existing snackbar (e.g. a lingering error) before showing this.
//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Row(
//           children: [
//             Icon(Icons.wifi_rounded, color: Colors.white, size: 16),
//             SizedBox(width: 8),
//             Text(
//               'সংযোগ পুনরুদ্ধার হয়েছে',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 13,
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: ColorT.green,
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 3),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
//       ),
//     );
//   }
// }

// // ─── Bottom Navigation Bar ────────────────────────────────────────────────────
// // Identical to your original — untouched.

// class _BottomNav extends StatelessWidget {
//   final int currentIndex;
//   final void Function(int) onTap;

//   const _BottomNav({required this.currentIndex, required this.onTap});

//   static const _items = [
//     _NavItem(icon: Icons.home_rounded, label: 'হোম'),
//     _NavItem(icon: Icons.list_alt_rounded, label: 'ট্র্যাকার'),
//     _NavItem(icon: Icons.bar_chart_rounded, label: 'রিপোর্ট'),
//     _NavItem(icon: Icons.emoji_events_rounded, label: 'র‍্যাংকিং'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: ColorT.cardBg,
//         border: Border(top: BorderSide(color: ColorT.border, width: 0.5)),
//       ),
//       child: SafeArea(
//         top: false,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: List.generate(_items.length, (index) {
//               final active = index == currentIndex;
//               return GestureDetector(
//                 onTap: () => onTap(index),
//                 behavior: HitTestBehavior.opaque,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   curve: Curves.easeInOut,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 7,
//                   ),
//                   decoration: BoxDecoration(
//                     color: active ? ColorT.greenLight : Colors.transparent,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       AnimatedSwitcher(
//                         duration: const Duration(milliseconds: 200),
//                         child: Icon(
//                           _items[index].icon,
//                           key: ValueKey(active),
//                           size: 22,
//                           color:
//                               active ? ColorT.darkGreen : ColorT.textSecondary,
//                         ),
//                       ),
//                       const SizedBox(height: 3),
//                       Text(
//                         _items[index].label,
//                         style: TextStyle(
//                           color:
//                               active ? ColorT.darkGreen : ColorT.textSecondary,
//                           fontSize: 9,
//                           fontWeight:
//                               active ? FontWeight.w700 : FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _NavItem {
//   final IconData icon;
//   final String label;
//   const _NavItem({required this.icon, required this.label});
// }
// lib/shared/widgets/main_shell.dart  — FIXED: banner moves to bottom

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amal_tracker/core/providers/connectivity_provider.dart';
import 'package:amal_tracker/core/router/app_router.dart';
import 'package:amal_tracker/features/home/screens/home_screen.dart'
    show ColorT;
import 'package:amal_tracker/shared/widgets/offline_banner.dart';

class MainShell extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  @override
  Widget build(BuildContext context) {
    // When offline → online: show a brief green snackbar.
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
            // Sits just above the bottom nav, same location as the offline
            // banner — the visual transition feels connected and intentional.
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          ),
        );
      }
    });

    return Scaffold(
      // ── body is COMPLETELY CLEAN ──────────────────────────────────────────
      // No Column. No banner. Content never moves. Ever.
      body: widget.navigationShell,

      // ── bottomNavigationBar holds ALL chrome ──────────────────────────────
      // The Scaffold automatically resizes its body to exclude this widget's
      // height. So when OfflineBanner expands (0 → 42px), the body shrinks
      // from the BOTTOM — the user's reading position at the top is
      // completely undisturbed. This is how Gmail, WhatsApp, and Google Maps
      // all handle offline state.
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Height = 0 when online, 42 when offline.
          // AnimatedContainer handles the smooth transition internally.
          const OfflineBanner(),
          _BottomNav(
            currentIndex: widget.navigationShell.currentIndex,
            onTap: _onTap,
          ),
        ],
      ),
    );
  }

  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}

// ─── Bottom Navigation Bar (unchanged from your original) ────────────────────

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  static const _items = [
    _NavItem(icon: Icons.home_rounded, label: 'হোম'),
    _NavItem(icon: Icons.list_alt_rounded, label: 'ট্র্যাকার'),
    _NavItem(icon: Icons.bar_chart_rounded, label: 'রিপোর্ট'),
    _NavItem(icon: Icons.emoji_events_rounded, label: 'র‍্যাংকিং'),
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
            children: List.generate(_items.length, (index) {
              final active = index == currentIndex;
              return GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
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
                          _items[index].icon,
                          key: ValueKey(active),
                          size: 22,
                          color:
                              active ? ColorT.darkGreen : ColorT.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _items[index].label,
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
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
