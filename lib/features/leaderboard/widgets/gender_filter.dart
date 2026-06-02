// ─────────────────────────────────────────────────────────────────────────────
// এই file এ দুটো জিনিস আছে:
//
// 1. _GenderFilterChips — LeaderboardScreen এ SliverPersistentHeader এর
//    নিচে যোগ করুন (Zone 3.5 হিসেবে)
//
// 2. HomeScreen preview load — leaderboardPreviewProvider এ gender auto pass
// ─────────────────────────────────────────────────────────────────────────────

// ════════════════════════════════════════════════════════════════════════
// PART 1 — LeaderboardScreen এ এই widget যোগ করুন
//
// _buildBody এর আগে SliverToBoxAdapter হিসেবে:
//
//   SliverToBoxAdapter(
//     child: _GenderFilterChips(
//       selected: filter.gender,
//       onChanged: (g) {
//         final next = ref
//             .read(leaderboardFilterProvider.notifier)
//             .state
//             .copyWith(gender: g, clearGender: g == null, page: 1);
//         ref.read(leaderboardFilterProvider.notifier).state = next;
//         ref.read(leaderboardProvider.notifier).load(next, refresh: true);
//       },
//     ),
//   ),
// ════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _C {
  static const pageBg = Color(0xFFF4F6F1);
  static const cardBg = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const border = Color(0xFFE4EAE4);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
  static const blue = Color(0xFF0891B2);
  static const blueLight = Color(0xFFE0F2FE);
  static const purple = Color(0xFF7C3AED);
  static const purpleLight = Color(0xFFEDE9FE);
}

// ─────────────────────────────────────────────────────────────────────────────
// GENDER FILTER CHIPS
// ─────────────────────────────────────────────────────────────────────────────

class GenderFilterChips extends StatelessWidget {
  final String? selected; // "male" | "female" | null
  final ValueChanged<String?> onChanged;

  const GenderFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _C.cardBg,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(
              children: [
                // Label
                Text(
                  'দেখাচ্ছে:',
                  style: TextStyle(
                    color: _C.textHint,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),

                // ছেলে chip
                _GenderChip(
                  label: '👨 ছেলেদের',
                  value: 'male',
                  selected: selected,
                  activeColor: _C.blue,
                  activeBg: _C.blueLight,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    // same tap করলে toggle off (সবাই দেখাবে)
                    onChanged(selected == 'male' ? null : 'male');
                  },
                ),

                const SizedBox(width: 8),

                // মেয়ে chip
                _GenderChip(
                  label: '👩 মেয়েদের',
                  value: 'female',
                  selected: selected,
                  activeColor: _C.purple,
                  activeBg: _C.purpleLight,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onChanged(selected == 'female' ? null : 'female');
                  },
                ),

                const Spacer(),

                // Total count indicator
                if (selected != null)
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onChanged(null); // সবাই দেখাও
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _C.pageBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _C.border, width: 0.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.close_rounded,
                              size: 10, color: _C.textHint),
                          SizedBox(width: 3),
                          Text(
                            'সবাই',
                            style: TextStyle(
                              color: _C.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 0.5, thickness: 0.5, color: _C.border),
        ],
      ),
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String label;
  final String value;
  final String? selected;
  final Color activeColor;
  final Color activeBg;
  final VoidCallback onTap;

  const _GenderChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.activeColor,
    required this.activeBg,
    required this.onTap,
  });

  bool get isActive => selected == value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? activeBg : _C.pageBg,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: isActive ? activeColor : _C.border,
            width: isActive ? 1.5 : 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? activeColor : _C.textSecondary,
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LEADERBOARD SCREEN এ যোগ করার জায়গা
//
// LeaderboardScreen._LeaderboardScreenState এর build() method এ
// Zone 3 (SliverPersistentHeader) এর পরে এটা যোগ করুন:
// ─────────────────────────────────────────────────────────────────────────────

// SliverToBoxAdapter(
//   child: GenderFilterChips(
//     selected: filter.gender,
//     onChanged: (g) {
//       final next = ref
//           .read(leaderboardFilterProvider.notifier)
//           .state
//           .copyWith(
//             gender: g,
//             clearGender: g == null,
//             page: 1,
//           );
//       ref.read(leaderboardFilterProvider.notifier).state = next;
//       ref.read(leaderboardProvider.notifier).load(next, refresh: true);
//     },
//   ),
// ),

// ─────────────────────────────────────────────────────────────────────────────
// PART 2 — HomeScreen এ preview load
//
// HomeScreen এর initState বা _loadPreview() যেখানে leaderboardPreviewProvider
// load করা হয় সেখানে gender auto pass করুন:
// ─────────────────────────────────────────────────────────────────────────────

// void _loadPreview() {
//   final now = DateTime.now();
//   final user = ref.read(currentUserProvider);
//   final filter = LeaderboardFilter(
//     year: now.year,
//     month: now.month,
//     gender: user?.gender, // current user এর gender auto pass
//     limit: 3,             // home এ শুধু ৩টা দেখাবে
//   );
//   ref.read(leaderboardPreviewProvider.notifier).load(filter);
// }

// ─────────────────────────────────────────────────────────────────────────────
// COMPLETE LeaderboardScreen build() snippet
// শুধু Zone 3.5 (gender filter) যোগ করার অংশ দেখানো হচ্ছে
// ─────────────────────────────────────────────────────────────────────────────

// @override
// Widget build(BuildContext context) {
//   final state  = ref.watch(leaderboardProvider);
//   final filter = ref.watch(leaderboardFilterProvider);
//   final myRank = ref.watch(
//     myRankProvider((year: filter.year, month: filter.month)),
//   );
//
//   return AnnotatedRegion<SystemUiOverlayStyle>(
//     ...
//     child: Scaffold(
//       body: RefreshIndicator(
//         child: CustomScrollView(
//           slivers: [
//             // Zone 1: App Bar
//             SliverAppBar(...),
//
//             // Zone 2: Hero Band
//             SliverToBoxAdapter(child: _HeroBand(...)),
//
//             // Zone 3: Month chips (sticky)
//             SliverPersistentHeader(
//               pinned: true,
//               delegate: _MonthChipDelegate(filter: filter, onPick: _pickMonth),
//             ),
//
//             // ── Zone 3.5: Gender filter ───────────────────────────────────
//             SliverToBoxAdapter(
//               child: GenderFilterChips(
//                 selected: filter.gender,
//                 onChanged: (g) {
//                   final next = ref
//                       .read(leaderboardFilterProvider.notifier)
//                       .state
//                       .copyWith(
//                         gender: g,
//                         clearGender: g == null,
//                         page: 1,
//                       );
//                   ref.read(leaderboardFilterProvider.notifier).state = next;
//                   ref
//                       .read(leaderboardProvider.notifier)
//                       .load(next, refresh: true);
//                 },
//               ),
//             ),
//             // ─────────────────────────────────────────────────────────────
//
//             // Zone 4: Body
//             SliverPadding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
//               sliver: _buildBody(state, filter),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
