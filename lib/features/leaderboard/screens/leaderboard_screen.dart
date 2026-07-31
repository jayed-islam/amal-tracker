// import 'package:amal_tracker/features/auth/providers/auth_provider.dart';
// import 'package:amal_tracker/features/leaderboard/widgets/gender_filter.dart';
// import 'package:amal_tracker/features/leaderboard/widgets/public_profile_sheet.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/leaderboard_provider.dart';
// import '../../tracker/models/tracker_model.dart';
// import '../../../core/constants/app_constants.dart';
// import '../../../core/providers/cache_provider.dart';
// import '../../../shared/widgets/delayed_progress_indicator.dart';
// import 'package:amal_tracker/core/theme/app_color_tokens.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // DESIGN TOKENS
// // ─────────────────────────────────────────────────────────────────────────────
// // ─────────────────────────────────────────────────────────────────────────────
// // LEADERBOARD SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// class LeaderboardScreen extends ConsumerStatefulWidget {
//   const LeaderboardScreen({super.key});

//   @override
//   ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
// }

// class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
//   final _sc = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _sc.addListener(_onScroll);
//   }

//   void _onScroll() {
//     if (_sc.position.pixels >= _sc.position.maxScrollExtent - 200) {
//       final state = ref.read(leaderboardProvider);
//       if (!state.isLoadingMore && state.hasMore) {
//         final f = ref.read(leaderboardFilterProvider);
//         ref
//             .read(leaderboardProvider.notifier)
//             .load(f.copyWith(page: state.currentPage + 1));
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _sc.dispose();
//     super.dispose();
//   }

//   Future<void> _refresh() async {
//     final f = ref.read(leaderboardFilterProvider);
//     ref
//         .read(cacheStatusProvider.notifier)
//         .updateLastFetched(CacheTab.leaderboard);
//     await Future.wait([
//       ref.read(leaderboardProvider.notifier).load(f, refresh: true),
//       ref.refresh(myRankProvider((year: f.year, month: f.month)).future),
//     ]);
//   }

//   void _pickMonth() {
//     final f = ref.read(leaderboardFilterProvider);
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) => _MonthPickerSheet(
//         year: f.year,
//         month: f.month,
//         onPicked: (y, m) {
//           final next = f.copyWith(year: y, month: m, page: 1);
//           ref.read(leaderboardFilterProvider.notifier).state = next;
//           ref.read(leaderboardProvider.notifier).load(next, refresh: true);
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     ref.watch(cacheStatusProvider); // Watch to rebuild on lifecycle/app resume
//     final filter = ref.watch(leaderboardFilterProvider);

//     // Lazy check-and-refresh for Leaderboard Tab data
//     final activeIndex = ref.watch(activeTabIndexProvider);
//     if (activeIndex == 4) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           checkAndRefreshTab(ref, CacheTab.leaderboard, () {
//             ref.read(leaderboardProvider.notifier).load(filter, refresh: true);
//             ref.refresh(
//                 myRankProvider((year: filter.year, month: filter.month)));
//           }, ttl: const Duration(minutes: 5));
//         }
//       });
//     }

//     final state = ref.watch(leaderboardProvider);
//     final myRank = ref.watch(
//       myRankProvider((year: filter.year, month: filter.month)),
//     );

//     // Current user gender — male user শুধু male profile দেখতে পাবে
//     final currentUser = ref.watch(currentUserProvider);
//     final isMaleUser = currentUser?.gender?.toLowerCase() == 'male';

//     final isBackgroundRefreshing =
//         state.isRefreshing || (myRank.isLoading && myRank.hasValue);

//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: context.colors.pageBg,
//         body: Stack(
//           children: [
//             RefreshIndicator(
//               color: context.colors.darkGreen,
//               onRefresh: _refresh,
//               child: CustomScrollView(
//                 controller: _sc,
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 slivers: [
//                   // ── App Bar ─────────────────────────────────────────────
//                   SliverAppBar(
//                     pinned: true,
//                     expandedHeight: 0,
//                     toolbarHeight: 56,
//                     backgroundColor: context.colors.darkGreen,
//                     surfaceTintColor: Colors.transparent,
//                     shadowColor: Colors.transparent,
//                     automaticallyImplyLeading: false,
//                     systemOverlayStyle: SystemUiOverlayStyle.light,
//                     title: Row(children: [
//                       Container(
//                         width: 30,
//                         height: 30,
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(
//                               color: Colors.white.withOpacity(0.15),
//                               width: 0.5),
//                         ),
//                         child: const Icon(Icons.leaderboard_rounded,
//                             color: Colors.white, size: 15),
//                       ),
//                       const SizedBox(width: 10),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text('লিডারবোর্ড',
//                               style: TextStyle(
//                                   color: Colors.white.withOpacity(0.55),
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w500)),
//                           Text(
//                               '${AppConstants.bengaliMonths[filter.month - 1]} ${filter.year}',
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w800,
//                                   letterSpacing: -0.3,
//                                   height: 1.1)),
//                         ],
//                       ),
//                     ]),
//                     actions: [
//                       GestureDetector(
//                         onTap: _pickMonth,
//                         child: Container(
//                           margin: const EdgeInsets.only(right: 16),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 11, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(
//                                 color: Colors.white.withOpacity(0.18),
//                                 width: 0.5),
//                           ),
//                           child: Row(mainAxisSize: MainAxisSize.min, children: [
//                             Icon(Icons.swap_horiz_rounded,
//                                 size: 13, color: Colors.white.withOpacity(0.7)),
//                             const SizedBox(width: 5),
//                             const Text('মাস বদলান',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: 12)),
//                           ]),
//                         ),
//                       ),
//                     ],
//                   ),

//                   // ── Hero Band ────────────────────────────────────────────
//                   SliverToBoxAdapter(
//                     child: _HeroBand(
//                       filter: filter,
//                       myRankAsync: myRank,
//                       ref: ref,
//                     ).animate().fadeIn(duration: 280.ms),
//                   ),

//                   // ── Month Chips (sticky) ──────────────────────────────────
//                   SliverPersistentHeader(
//                     pinned: true,
//                     delegate: _MonthChipDelegate(
//                       filter: filter,
//                       onPick: _pickMonth,
//                     ),
//                   ),

//                   // ── Gender Filter ─────────────────────────────────────────
//                   // Male user হলে gender filter disabled — শুধু male দেখবে
//                   SliverToBoxAdapter(
//                     child: GenderFilterChips(
//                       selected: filter.gender,
//                       onChanged: (g) {
//                         if (isMaleUser)
//                           return; // male user — gender toggle disabled, no-op
//                         final next = ref
//                             .read(leaderboardFilterProvider.notifier)
//                             .state
//                             .copyWith(
//                               gender: g,
//                               clearGender: g == null,
//                               page: 1,
//                             );
//                         ref.read(leaderboardFilterProvider.notifier).state =
//                             next;
//                         ref
//                             .read(leaderboardProvider.notifier)
//                             .load(next, refresh: true);
//                       },
//                     ),
//                   ),

//                   // ── Body ─────────────────────────────────────────────────
//                   SliverPadding(
//                     padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
//                     sliver: _buildBody(state, filter, isMaleUser),
//                   ),
//                 ],
//               ),
//             ),
//             if (isBackgroundRefreshing)
//               Positioned(
//                 top: MediaQuery.of(context).padding.top + 54,
//                 left: 0,
//                 right: 0,
//                 child: const SizedBox(
//                   height: 2,
//                   child: DelayedLinearProgressIndicator(
//                     color: Colors.white,
//                     backgroundColor: Colors.transparent,
//                     delay: Duration(milliseconds: 400),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBody(
//       LeaderboardState state, LeaderboardFilter filter, bool isMaleUser) {
//     if (state.isLoading) {
//       return SliverToBoxAdapter(
//           child: const _LeaderboardSkeleton()
//               .animate()
//               .fadeIn(delay: 80.ms, duration: 260.ms));
//     }

//     if (state.error != null) {
//       return SliverToBoxAdapter(
//           child: _ErrorCard(message: state.error!, onRetry: _refresh)
//               .animate()
//               .fadeIn(duration: 260.ms));
//     }

//     if (state.entries.isEmpty) {
//       return SliverToBoxAdapter(
//           child: const _EmptyCard(label: 'এই মাসে এখনো কেউ আমল রেকর্ড করেননি')
//               .animate()
//               .fadeIn(duration: 260.ms));
//     }

//     final top3 = state.entries.take(3).toList();
//     final rest = state.entries.length > 3
//         ? state.entries.sublist(3)
//         : <LeaderboardEntry>[];

//     return SliverList(
//       delegate: SliverChildListDelegate([
//         const SizedBox(height: 8),
//         _SectionHeader(title: 'শীর্ষ তিনজন', emoji: '🥇')
//             .animate()
//             .fadeIn(delay: 100.ms),
//         const SizedBox(height: 12),
//         if (top3.isNotEmpty)
//           _PodiumCard(
//             top3: top3,
//             year: filter.year,
//             month: filter.month,
//             isMaleUser: isMaleUser,
//           )
//               .animate()
//               .fadeIn(delay: 120.ms, duration: 320.ms)
//               .slideY(begin: 0.08, curve: Curves.easeOut),
//         const SizedBox(height: 24),
//         if (rest.isNotEmpty) ...[
//           _SectionHeader(title: 'সম্পূর্ণ তালিকা', emoji: '📋')
//               .animate()
//               .fadeIn(delay: 160.ms),
//           const SizedBox(height: 12),
//           Container(
//             decoration: BoxDecoration(
//               color: context.colors.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: context.colors.border, width: 0.5),
//             ),
//             child: Column(
//               children: List.generate(rest.length, (i) {
//                 return _RankTile(
//                   entry: rest[i],
//                   isLast: i == rest.length - 1,
//                   delay: 180 + i * 40,
//                   year: filter.year,
//                   month: filter.month,
//                   isMaleUser: isMaleUser,
//                 );
//               }),
//             ),
//           ).animate().fadeIn(delay: 180.ms, duration: 280.ms),
//         ],
//         if (state.isLoadingMore) ...[
//           const SizedBox(height: 20),
//           Center(
//               child: SizedBox(
//                   width: 22,
//                   height: 22,
//                   child: CircularProgressIndicator(
//                       color: context.colors.darkGreen, strokeWidth: 2))),
//           const SizedBox(height: 20),
//         ] else
//           const SizedBox(height: 8),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // HERO BAND — points বাদ, completion % + farz + jamaat + streak
// // ─────────────────────────────────────────────────────────────────────────────

// class _HeroBand extends StatelessWidget {
//   final LeaderboardFilter filter;
//   final AsyncValue<MyRankData> myRankAsync;
//   final WidgetRef ref;

//   const _HeroBand(
//       {required this.filter, required this.myRankAsync, required this.ref});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: context.colors.darkGreen,
//       child: Stack(children: [
//         Positioned(
//             top: -45,
//             right: -45,
//             child: Container(
//                 width: 140,
//                 height: 140,
//                 decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white.withOpacity(0.04)))),
//         Positioned(
//             bottom: -25,
//             left: 20,
//             child: Container(
//                 width: 90,
//                 height: 90,
//                 decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white.withOpacity(0.03)))),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text(
//                 '${AppConstants.bengaliMonths[filter.month - 1]} ${filter.year} · শীর্ষ আমলকারীরা',
//                 style: TextStyle(
//                     color: Colors.white.withOpacity(0.4),
//                     fontSize: 11,
//                     fontWeight: FontWeight.w500)),
//             const SizedBox(height: 10),
//             myRankAsync.when(
//               loading: () => const _MyRankSkeleton(),
//               error: (error, _) => _MyRankErrorCard(
//                 message: error.toString(),
//                 onRetry: () {
//                   final f = ref.read(leaderboardFilterProvider);
//                   ref.invalidate(
//                       myRankProvider((year: f.year, month: f.month)));
//                 },
//               ),
//               data: (d) => _MyRankCard(data: d),
//             ),
//           ]),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // MY RANK CARD — points বাদ, completion % + farz + jamaat + streak
// // ─────────────────────────────────────────────────────────────────────────────

// class _MyRankCard extends StatelessWidget {
//   final MyRankData data;
//   const _MyRankCard({required this.data});

//   @override
//   Widget build(BuildContext context) {
//     final pct = data.completionPercentage.toInt();
//     final farzDays = data.farzCompletedDays ?? 0;
//     final jamaat = data.congregationDaysTotal ?? 0;
//     final streak = data.streakDays ?? 0;

//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.09),
//           borderRadius: BorderRadius.circular(14),
//           border:
//               Border.all(color: Colors.white.withOpacity(0.18), width: 0.5)),
//       child: Row(children: [
//         // Rank badge
//         Container(
//           width: 54,
//           height: 54,
//           decoration: BoxDecoration(
//               color: context.colors.gold,
//               borderRadius: BorderRadius.circular(13)),
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Text(data.rank != null ? '#${data.rank}' : '—',
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w900,
//                     fontSize: 15,
//                     height: 1)),
//             Text('আমার',
//                 style: TextStyle(
//                     color: Colors.white.withOpacity(0.7),
//                     fontSize: 8,
//                     fontWeight: FontWeight.w600)),
//           ]),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text('আমার অবস্থান',
//               style: TextStyle(
//                   color: Colors.white.withOpacity(0.5), fontSize: 10)),
//           const SizedBox(height: 4),
//           // Completion % big
//           Row(children: [
//             Text('$pct%',
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w900,
//                     fontSize: 20,
//                     letterSpacing: -0.4,
//                     height: 1)),
//             const SizedBox(width: 6),
//             Text('ফরজ সম্পন্ন',
//                 style: TextStyle(
//                     color: Colors.white.withOpacity(0.5), fontSize: 10.5)),
//             if (data.isWinner) ...[
//               const SizedBox(width: 8),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
//                 decoration: BoxDecoration(
//                     color: context.colors.gold,
//                     borderRadius: BorderRadius.circular(20)),
//                 child: Row(mainAxisSize: MainAxisSize.min, children: [
//                   const Text('🏆', style: TextStyle(fontSize: 9)),
//                   const SizedBox(width: 3),
//                   Text(data.winnerCategory ?? 'বিজয়ী',
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 9,
//                           fontWeight: FontWeight.w700)),
//                 ]),
//               ),
//             ],
//           ]),
//           const SizedBox(height: 6),
//           // Chips row
//           Wrap(spacing: 5, runSpacing: 4, children: [
//             _MyRankChip(
//                 icon: Icons.check_circle_rounded, label: '$farzDays ফরজ দিন'),
//             _MyRankChip(icon: Icons.people_rounded, label: '$jamaat জামাত'),
//             if (streak > 0)
//               _MyRankChip(
//                   icon: Icons.local_fire_department_rounded,
//                   label: '$streak ধারা'),
//           ]),
//         ])),
//       ]),
//     );
//   }
// }

// class _MyRankChip extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   const _MyRankChip({required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
//       decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.12),
//           borderRadius: BorderRadius.circular(20)),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [
//         Icon(icon, color: Colors.white.withOpacity(0.65), size: 10),
//         const SizedBox(width: 3),
//         Text(label,
//             style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 9.5,
//                 fontWeight: FontWeight.w600)),
//       ]),
//     );
//   }
// }

// class _MyRankSkeleton extends StatelessWidget {
//   const _MyRankSkeleton();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 90,
//       decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.08),
//           borderRadius: BorderRadius.circular(14)),
//     ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, colors: [
//       Colors.white.withOpacity(0.02),
//       Colors.white.withOpacity(0.12),
//       Colors.white.withOpacity(0.02),
//     ]);
//   }
// }

// class _MyRankErrorCard extends StatelessWidget {
//   final String message;
//   final VoidCallback onRetry;
//   const _MyRankErrorCard({required this.message, required this.onRetry});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.09),
//           borderRadius: BorderRadius.circular(14),
//           border:
//               Border.all(color: Colors.white.withOpacity(0.18), width: 0.5)),
//       child: Row(children: [
//         Container(
//           width: 48,
//           height: 48,
//           decoration: BoxDecoration(
//               color: context.colors.red.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12)),
//           child: const Icon(Icons.error_outline_rounded,
//               color: Colors.white, size: 24),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//             child: Text('আমার অবস্থান লোড হয়নি',
//                 style: TextStyle(
//                     color: Colors.white.withOpacity(0.7),
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600))),
//         GestureDetector(
//           onTap: onRetry,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(8)),
//             child: const Text('রিট্রাই',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 11)),
//           ),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION HEADER
// // ─────────────────────────────────────────────────────────────────────────────

// class _SectionHeader extends StatelessWidget {
//   final String title, emoji;
//   const _SectionHeader({required this.title, required this.emoji});

//   @override
//   Widget build(BuildContext context) {
//     return Row(children: [
//       Text(emoji, style: const TextStyle(fontSize: 14)),
//       const SizedBox(width: 7),
//       Text(title,
//           style: TextStyle(
//               color: context.colors.textPrimary,
//               fontWeight: FontWeight.w800,
//               fontSize: 15,
//               letterSpacing: -0.2)),
//     ]);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SHARED WIDGETS
// // ─────────────────────────────────────────────────────────────────────────────

// class _SerialBadge extends StatelessWidget {
//   final String id;
//   final bool onDark;
//   const _SerialBadge({required this.id, this.onDark = false});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
//       decoration: BoxDecoration(
//         color:
//             onDark ? Colors.white.withOpacity(0.12) : context.colors.serialBg,
//         borderRadius: BorderRadius.circular(5),
//         border: Border.all(
//             color:
//                 onDark ? Colors.white.withOpacity(0.18) : context.colors.border,
//             width: 0.5),
//       ),
//       child: Text(id,
//           style: TextStyle(
//               color: onDark
//                   ? Colors.white.withOpacity(0.55)
//                   : context.colors.serialText,
//               fontSize: 8.5,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.2)),
//     );
//   }
// }

// class _DistrictPill extends StatelessWidget {
//   final String district;
//   final bool onDark;
//   final bool compact;
//   const _DistrictPill(
//       {required this.district, this.onDark = false, this.compact = false});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//           horizontal: compact ? 5 : 6, vertical: compact ? 2 : 2.5),
//       decoration: BoxDecoration(
//         color:
//             onDark ? Colors.white.withOpacity(0.12) : context.colors.districtBg,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//             color:
//                 onDark ? Colors.white.withOpacity(0.18) : context.colors.border,
//             width: 0.5),
//       ),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [
//         Icon(Icons.location_on_rounded,
//             size: compact ? 7.5 : 8.5,
//             color: onDark
//                 ? Colors.white.withOpacity(0.55)
//                 : context.colors.districtText),
//         const SizedBox(width: 2),
//         Text(district,
//             style: TextStyle(
//                 color: onDark
//                     ? Colors.white.withOpacity(0.7)
//                     : context.colors.districtText,
//                 fontSize: compact ? 8.5 : 9.5,
//                 fontWeight: FontWeight.w600)),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // HELPER: can current user view this entry's profile?
// // Male user → শুধু male profiles দেখতে পাবে
// // Female user → সবার profile দেখতে পাবে
// // ─────────────────────────────────────────────────────────────────────────────

// bool _canViewProfile(LeaderboardEntry entry, bool isMaleUser) {
//   if (!entry.isProfilePublic) return false;
//   if (isMaleUser && entry.gender?.toLowerCase() == 'female') return false;
//   return true;
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PODIUM CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _PodiumCard extends StatelessWidget {
//   final List<LeaderboardEntry> top3;
//   final int year, month;
//   final bool isMaleUser;

//   const _PodiumCard({
//     required this.top3,
//     required this.year,
//     required this.month,
//     required this.isMaleUser,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final first = top3[0];
//     final second = top3.length > 1 ? top3[1] : null;
//     final third = top3.length > 2 ? top3[2] : null;

//     final title = top3.length == 1
//         ? 'এই মাসের শীর্ষ আমলকারী'
//         : (top3.length == 2 ? 'এই মাসের শীর্ষ দুইজন' : 'এই মাসের শীর্ষ তিনজন');

//     return Container(
//       decoration: BoxDecoration(
//           color: context.colors.cardBg,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: context.colors.border, width: 0.5)),
//       child: Column(children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//           child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             const Text('🌟', style: TextStyle(fontSize: 13)),
//             const SizedBox(width: 6),
//             Text(title,
//                 style: TextStyle(
//                     color: context.colors.textSecondary,
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600)),
//             const SizedBox(width: 6),
//             const Text('🌟', style: TextStyle(fontSize: 13)),
//           ]),
//         ),
//         const SizedBox(height: 10),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               if (second != null) ...[
//                 _PodiumPillar(
//                     entry: second,
//                     rank: 2,
//                     year: year,
//                     month: month,
//                     isMaleUser: isMaleUser),
//                 const SizedBox(width: 12),
//               ],
//               _PodiumPillar(
//                   entry: first,
//                   rank: 1,
//                   isFirst: true,
//                   year: year,
//                   month: month,
//                   isMaleUser: isMaleUser),
//               if (third != null) ...[
//                 const SizedBox(width: 12),
//                 _PodiumPillar(
//                     entry: third,
//                     rank: 3,
//                     year: year,
//                     month: month,
//                     isMaleUser: isMaleUser),
//               ],
//             ],
//           ),
//         ),
//       ]),
//     );
//   }
// }

// class _PodiumPillar extends StatelessWidget {
//   final LeaderboardEntry entry;
//   final int rank;
//   final bool isFirst;
//   final int year, month;
//   final bool isMaleUser;

//   const _PodiumPillar({
//     required this.entry,
//     required this.rank,
//     required this.year,
//     required this.month,
//     required this.isMaleUser,
//     this.isFirst = false,
//   });

//   Color _rankColor(BuildContext context) => rank == 1
//       ? context.colors.rankGold
//       : rank == 2
//           ? context.colors.rankSilver
//           : context.colors.rankBronze;

//   String get _rankEmoji => rank == 1
//       ? '🥇'
//       : rank == 2
//           ? '🥈'
//           : '🥉';
//   double get _avatarSize => isFirst
//       ? 60.0
//       : rank == 2
//           ? 48.0
//           : 44.0;
//   double get _pillarWidth => isFirst
//       ? 100.0
//       : rank == 2
//           ? 88.0
//           : 80.0;
//   EdgeInsets get _pillarPadding => EdgeInsets.symmetric(
//       vertical: rank == 1 ? 6.0 : (rank == 2 ? 5.0 : 4.0),
//       horizontal: 4.0);

//   @override
//   Widget build(BuildContext context) {
//     final canView = _canViewProfile(entry, isMaleUser);
//     final initial = entry.name.isNotEmpty ? entry.name[0].toUpperCase() : 'U';

//     return GestureDetector(
//       onTap: () {
//         HapticFeedback.selectionClick();
//         if (canView) {
//           showPublicProfileSheet(context,
//               entry: entry,
//               year: year,
//               month: month,
//               isMaleUser: isMaleUser);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Row(children: [
//               const Icon(Icons.lock_outline_rounded, color: Colors.white, size: 16),
//               const SizedBox(width: 8),
//               Text(entry.isProfilePublic
//                   ? 'নিরাপত্তা জনিত কারণে আপনি এই প্রোফাইলটি দেখতে পারবেন না।'
//                   : 'এই ব্যবহারকারীর প্রোফাইলটি ব্যক্তিগত (Private) করা আছে।'),
//             ]),
//             backgroundColor: context.colors.textPrimary,
//             behavior: SnackBarBehavior.floating,
//             margin: const EdgeInsets.all(16),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             duration: const Duration(seconds: 2),
//           ));
//         }
//       },
//       behavior: HitTestBehavior.opaque,
//       child: SizedBox(
//         width: _pillarWidth,
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           // Medal
//           Text(_rankEmoji, style: TextStyle(fontSize: isFirst ? 24 : 20))
//               .animate()
//               .scale(
//                   delay: Duration(milliseconds: rank * 80),
//                   duration: 380.ms,
//                   curve: Curves.elasticOut),
//           const SizedBox(height: 4),

//           // Avatar
//           Stack(
//               clipBehavior: Clip.none,
//               alignment: Alignment.center,
//               children: [
//                 if (isFirst)
//                   Container(
//                     width: _avatarSize + 12,
//                     height: _avatarSize + 12,
//                     decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: RadialGradient(colors: [
//                           _rankColor(context).withOpacity(0.20),
//                           _rankColor(context).withOpacity(0.0),
//                         ])),
//                   ),
//                 Container(
//                   width: _avatarSize,
//                   height: _avatarSize,
//                   decoration: BoxDecoration(
//                       color: _rankColor(context).withOpacity(0.10),
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                           color: _rankColor(context),
//                           width: isFirst ? 2.5 : 2.0),
//                       boxShadow: [
//                         BoxShadow(
//                             color: _rankColor(context)
//                                 .withOpacity(isFirst ? 0.30 : 0.15),
//                             blurRadius: isFirst ? 14 : 8)
//                       ]),
//                   child: Center(
//                       child: Text(initial,
//                           style: TextStyle(
//                               color: _rankColor(context),
//                               fontSize: isFirst
//                                   ? 24
//                                   : rank == 2
//                                       ? 18
//                                       : 16,
//                               fontWeight: FontWeight.w900,
//                               height: 1))),
//                 ),
//                 // Public/Private dot
//                 Positioned(
//                   top: isFirst ? -2 : -1,
//                   right: isFirst ? -2 : -1,
//                   child: Container(
//                     width: 16,
//                     height: 16,
//                     decoration: BoxDecoration(
//                         color: canView
//                             ? context.colors.avatar4
//                             : context.colors.textHint,
//                         shape: BoxShape.circle,
//                         border:
//                             Border.all(color: context.colors.cardBg, width: 2)),
//                     child: Icon(
//                         canView ? Icons.visibility_rounded : Icons.lock_rounded,
//                         size: 8,
//                         color: canView
//                             ? Colors.white
//                             : (Theme.of(context).brightness == Brightness.dark
//                                 ? Colors.black87
//                                 : Colors.white)),
//                   ),
//                 ),
//               ]),
//           const SizedBox(height: 5),

//           // Name
//           Text(entry.name.split(' ').first,
//               textAlign: TextAlign.center,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                   color: context.colors.textPrimary,
//                   fontSize: isFirst ? 13.5 : 11.5,
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: -0.2)),
//           const SizedBox(height: 1),

//           // ID
//           if (entry.id.isNotEmpty)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
//               decoration: BoxDecoration(
//                   color: context.colors.serialBg,
//                   borderRadius: BorderRadius.circular(5),
//                   border: Border.all(color: context.colors.border, width: 0.5)),
//               child: Text(entry.id,
//                   style: TextStyle(
//                       color: context.colors.serialText,
//                       fontSize: 8.5,
//                       fontWeight: FontWeight.w600)),
//             ),
//           const SizedBox(height: 1),

//           // District
//           if (entry.district.isNotEmpty)
//             Text(entry.district,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     color: context.colors.districtText,
//                     fontSize: 9.0,
//                     fontWeight: FontWeight.w600)),
//           const SizedBox(height: 6),

//           // Pillar bar — points বাদ, completion + farz + jamaat
//           _PillarBar(
//             entry: entry,
//             rank: rank,
//             isFirst: isFirst,
//             rankColor: _rankColor(context),
//             pillarWidth: _pillarWidth,
//             pillarPadding: _pillarPadding,
//             pillarHeight: rank == 1 ? 108.0 : (rank == 2 ? 90.0 : 76.0),
//           ),
//         ]),
//       ),
//     );
//   }
// }

// // ── Pillar bar — completion % + farz days + jamaat ───────────────────────────

// class _PillarBar extends StatelessWidget {
//   final LeaderboardEntry entry;
//   final int rank;
//   final bool isFirst;
//   final Color rankColor;
//   final double pillarWidth;
//   final EdgeInsets pillarPadding;
//   final double pillarHeight;

//   const _PillarBar({
//     required this.entry,
//     required this.rank,
//     required this.isFirst,
//     required this.rankColor,
//     required this.pillarWidth,
//     required this.pillarPadding,
//     required this.pillarHeight,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final pct = entry.completionPercentage.toInt();
//     final farz = entry.farzCompletedDays;
//     final jamaat = entry.congregationDaysTotal;
//     final streak = entry.streakDays;
//     final daysActive = entry.daysActive;

//     return Container(
//       width: pillarWidth,
//       height: pillarHeight,
//       clipBehavior: Clip.antiAlias, // Smoothly clips children to this container's rounded corners
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               rankColor.withOpacity(0.9),
//               rankColor.withOpacity(0.55),
//             ]),
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
//         boxShadow: [
//           BoxShadow(
//             color: rankColor.withOpacity(0.15),
//             blurRadius: 8,
//             offset: const Offset(0, -2),
//           ),
//         ],
//         border: Border.all(color: Colors.white.withOpacity(0.2), width: 0.75),
//       ),
//       child: Stack(
//         children: [
//           // Top highlight line inside the pillar
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: 2.5,
//               color: rankColor,
//             ),
//           ),

//           Positioned.fill(
//             child: Padding(
//               padding: pillarPadding,
//               child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center, // Center contents horizontally
//               children: [
//                 const SizedBox(height: 2), // Space for Positioned bar
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.center, // Center text horizontally
//                   children: [
//                     Text(
//                       '$pct%',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w900,
//                         fontSize: isFirst ? 16 : 13,
//                         height: 1,
//                         letterSpacing: -0.5,
//                       ),
//                     ),
//                     const SizedBox(height: 1),
//                     Text(
//                       'সম্পন্ন',
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.75),
//                         fontSize: isFirst ? 8.0 : 7.0,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),

//                 FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.center, // Center stats horizontally
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.check_circle_rounded, size: 8, color: Colors.white.withOpacity(0.85)),
//                           const SizedBox(width: 1),
//                           Text(
//                             '$farz',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 8,
//                               fontWeight: FontWeight.w800,
//                             ),
//                           ),
//                           const SizedBox(width: 4),
//                           Icon(Icons.people_rounded, size: 8, color: Colors.white.withOpacity(0.85)),
//                           const SizedBox(width: 1),
//                           Text(
//                             '$jamaat',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 8,
//                               fontWeight: FontWeight.w800,
//                             ),
//                           ),
//                           if (streak > 0) ...[
//                             const SizedBox(width: 4),
//                             const Text('🔥', style: TextStyle(fontSize: 8)),
//                             const SizedBox(width: 0.5),
//                             Text(
//                               '$streak',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 8,
//                                 fontWeight: FontWeight.w800,
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                       const SizedBox(height: 1),
//                       Text(
//                         '$daysActive দিন সক্রিয়',
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.8),
//                           fontSize: 7.0,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 Text(
//                   '#$rank',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.9),
//                     fontWeight: FontWeight.w900,
//                     fontSize: isFirst ? 16 : 13,
//                     height: 1,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//       ),
//     );
//   }
// }

// class _PillarPill extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//   final bool isFirst;
//   const _PillarPill(
//       {required this.icon,
//       required this.label,
//       required this.color,
//       required this.isFirst});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//           horizontal: isFirst ? 9 : 7, vertical: isFirst ? 4 : 3),
//       decoration: BoxDecoration(
//           color: color.withOpacity(0.12),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: color.withOpacity(0.25), width: 0.75)),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [
//         Icon(icon, size: isFirst ? 9.5 : 8.5, color: color.withOpacity(0.85)),
//         const SizedBox(width: 3),
//         Text(label,
//             style: TextStyle(
//                 color: color,
//                 fontSize: isFirst ? 9.5 : 8.5,
//                 fontWeight: FontWeight.w700)),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // RANK TILE — points বাদ, completion + farz + jamaat + streak
// // ─────────────────────────────────────────────────────────────────────────────

// class _RankTile extends StatelessWidget {
//   final LeaderboardEntry entry;
//   final bool isLast;
//   final int delay, year, month;
//   final bool isMaleUser;

//   const _RankTile({
//     required this.entry,
//     required this.isLast,
//     required this.delay,
//     required this.year,
//     required this.month,
//     required this.isMaleUser,
//   });

//   List<Color> _avatarColors(BuildContext context) => [
//         context.colors.avatar1,
//         context.colors.avatar2,
//         context.colors.avatar3,
//         context.colors.avatar4,
//         context.colors.avatar5,
//       ];

//   Color _avatarColor(BuildContext context) {
//     final colors = _avatarColors(context);
//     return colors[(entry.rank - 4).clamp(0, colors.length - 1) % colors.length];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isTop10 = entry.rank <= 10;
//     final isWinner = entry.isWinner;
//     final canView = _canViewProfile(entry, isMaleUser);
//     final pct = entry.completionPercentage.toInt();
//     final farz = entry.farzCompletedDays;
//     final jamaat = entry.congregationDaysTotal;

//     return GestureDetector(
//       onTap: () {
//         HapticFeedback.selectionClick();
//         if (canView) {
//           showPublicProfileSheet(context,
//               entry: entry,
//               year: year,
//               month: month,
//               isMaleUser: isMaleUser);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Row(children: [
//               const Icon(Icons.lock_outline_rounded, color: Colors.white, size: 16),
//               const SizedBox(width: 8),
//               Text(entry.isProfilePublic
//                   ? 'নিরাপত্তা জনিত কারণে আপনি এই প্রোফাইলটি দেখতে পারবেন না।'
//                   : 'এই ব্যবহারকারীর প্রোফাইলটি ব্যক্তিগত (Private) করা আছে।'),
//             ]),
//             backgroundColor: context.colors.textPrimary,
//             behavior: SnackBarBehavior.floating,
//             margin: const EdgeInsets.all(16),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             duration: const Duration(seconds: 2),
//           ));
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
//         decoration: BoxDecoration(
//           color: isWinner ? context.colors.goldPale : Colors.transparent,
//           borderRadius: isLast
//               ? const BorderRadius.vertical(bottom: Radius.circular(16))
//               : null,
//           border: isLast
//               ? null
//               : Border(
//                   bottom: BorderSide(color: context.colors.border, width: 0.5)),
//         ),
//         child: Row(children: [
//           // Rank
//           SizedBox(
//             width: 36,
//             child: Text('#${entry.rank}',
//                 style: TextStyle(
//                     color: isTop10
//                         ? context.colors.darkGreen
//                         : context.colors.textHint,
//                     fontWeight: FontWeight.w800,
//                     fontSize: isTop10 ? 14 : 12,
//                     height: 1)),
//           ),
//           const SizedBox(width: 6),

//           // Avatar
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//                 color: isTop10
//                     ? _avatarColor(context)
//                     : context.colors.textHint.withOpacity(0.4),
//                 borderRadius: BorderRadius.circular(11)),
//             child: Center(
//                 child: Text(
//                     entry.name.isNotEmpty ? entry.name[0].toUpperCase() : 'U',
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w800,
//                         fontSize: 16))),
//           ),
//           const SizedBox(width: 10),

//           // Name + meta
//           Expanded(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                 Row(children: [
//                   Flexible(
//                       child: Text(entry.name,
//                           style: TextStyle(
//                               color: context.colors.textPrimary,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 13),
//                           overflow: TextOverflow.ellipsis)),
//                   if (isWinner) ...[
//                     const SizedBox(width: 4),
//                     const Text('🏆', style: TextStyle(fontSize: 11)),
//                   ],
//                 ]),
//                 const SizedBox(height: 4),
//                 _MetaRow(entry: entry),
//               ])),
//           const SizedBox(width: 8),

//           // Completion % + farz + profile badge
//           Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
//             Text('$pct%',
//                 style: TextStyle(
//                     color: isWinner
//                         ? context.colors.gold
//                         : isTop10
//                             ? context.colors.darkGreen
//                             : context.colors.textPrimary,
//                     fontWeight: FontWeight.w900,
//                     fontSize: 16,
//                     height: 1)),
//             const SizedBox(height: 2),
//             Text('$farz  ফরজ · $jamaat  জামাত · ${entry.daysActive}  দিন সক্রিয়',
//                 style: TextStyle(
//                     color: context.colors.textHint,
//                     fontSize: 9,
//                     fontWeight: FontWeight.w500)),
//             const SizedBox(height: 4),
//             _ProfileBadge(isPublic: canView),
//           ]),
//         ]),
//       ),
//     )
//         .animate(delay: Duration(milliseconds: delay))
//         .fadeIn(duration: 260.ms)
//         .slideX(begin: 0.04, curve: Curves.easeOut);
//   }
// }

// class _MetaRow extends StatelessWidget {
//   final LeaderboardEntry entry;
//   const _MetaRow({required this.entry});

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 4,
//       runSpacing: 3,
//       crossAxisAlignment: WrapCrossAlignment.center,
//       children: [
//         if (entry.id.isNotEmpty)
//           Text('ID: ${entry.id}',
//               style:
//                   TextStyle(color: context.colors.textSecondary, fontSize: 10)),
//         if (entry.id.isNotEmpty && entry.district.isNotEmpty)
//           Text('·',
//               style: TextStyle(color: context.colors.textHint, fontSize: 10)),
//         if (entry.district.isNotEmpty) _DistrictPill(district: entry.district),
//         if ((entry.id.isNotEmpty || entry.district.isNotEmpty) &&
//             entry.streakDays > 0)
//           Text('·',
//               style: TextStyle(color: context.colors.textHint, fontSize: 10)),
//         if (entry.streakDays > 0)
//           Text('🔥 ${entry.streakDays}',
//               style: TextStyle(
//                   color: context.colors.amber2,
//                   fontSize: 10,
//                   fontWeight: FontWeight.w600)),
//       ],
//     );
//   }
// }

// class _ProfileBadge extends StatelessWidget {
//   final bool isPublic;
//   const _ProfileBadge({required this.isPublic});

//   @override
//   Widget build(BuildContext context) {
//     if (!isPublic) {
//       return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
//         decoration: BoxDecoration(
//             color: context.colors.bg,
//             borderRadius: BorderRadius.circular(5),
//             border: Border.all(color: context.colors.border, width: 0.5)),
//         child: Row(mainAxisSize: MainAxisSize.min, children: [
//           Icon(Icons.lock_outline_rounded,
//               size: 8, color: context.colors.textHint),
//           SizedBox(width: 2),
//           Text('Private',
//               style: TextStyle(
//                   color: context.colors.textHint,
//                   fontSize: 8,
//                   fontWeight: FontWeight.w500)),
//         ]),
//       );
//     }
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
//       decoration: BoxDecoration(
//           color: context.colors.blueLight,
//           borderRadius: BorderRadius.circular(5),
//           border: Border.all(
//               color: context.colors.avatar4.withOpacity(0.3), width: 0.5)),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [
//         Icon(Icons.visibility_outlined, size: 8, color: context.colors.avatar4),
//         SizedBox(width: 2),
//         Text('দেখুন',
//             style: TextStyle(
//                 color: context.colors.avatar4,
//                 fontSize: 8,
//                 fontWeight: FontWeight.w600)),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // MONTH CHIP DELEGATE (sticky)
// // ─────────────────────────────────────────────────────────────────────────────

// class _MonthChipDelegate extends SliverPersistentHeaderDelegate {
//   final LeaderboardFilter filter;
//   final VoidCallback onPick;
//   const _MonthChipDelegate({required this.filter, required this.onPick});

//   static const _height = 53.0;

//   @override
//   double get minExtent => _height;
//   @override
//   double get maxExtent => _height;
//   @override
//   bool shouldRebuild(_MonthChipDelegate old) => old.filter != filter;

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     final now = DateTime.now();
//     final months = List.generate(6, (i) {
//       final dt = DateTime(now.year, now.month - i);
//       return (year: dt.year, month: dt.month);
//     });

//     return Container(
//       color: context.colors.cardBg,
//       child: Column(children: [
//         Expanded(
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.fromLTRB(16, 11, 16, 11),
//             child: Row(
//               children: months.map((m) {
//                 final isActive =
//                     m.month == filter.month && m.year == filter.year;
//                 final label = AppConstants.bengaliMonths[m.month - 1];
//                 return GestureDetector(
//                   onTap: onPick,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 180),
//                     margin: const EdgeInsets.only(right: 8),
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
//                     decoration: BoxDecoration(
//                         color: isActive
//                             ? context.colors.darkGreen
//                             : context.colors.pageBg,
//                         borderRadius: BorderRadius.circular(99),
//                         border: Border.all(
//                             color: isActive
//                                 ? context.colors.darkGreen
//                                 : context.colors.border,
//                             width: 0.5)),
//                     child: Text(m.year == now.year ? label : '$label ${m.year}',
//                         style: TextStyle(
//                             color: isActive
//                                 ? Colors.white
//                                 : context.colors.textSecondary,
//                             fontSize: 11,
//                             fontWeight:
//                                 isActive ? FontWeight.w700 : FontWeight.w500)),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//         Divider(color: context.colors.border, height: 0.5, thickness: 0.5),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // MONTH PICKER SHEET
// // ─────────────────────────────────────────────────────────────────────────────

// class _MonthPickerSheet extends StatefulWidget {
//   final int year, month;
//   final void Function(int, int) onPicked;
//   const _MonthPickerSheet(
//       {required this.year, required this.month, required this.onPicked});

//   @override
//   State<_MonthPickerSheet> createState() => _MonthPickerSheetState();
// }

// class _MonthPickerSheetState extends State<_MonthPickerSheet> {
//   late int _y, _m;

//   @override
//   void initState() {
//     super.initState();
//     _y = widget.year;
//     _m = widget.month;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final now = DateTime.now();
//     return Container(
//       decoration: BoxDecoration(
//           color: context.colors.cardBg,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
//       padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         Container(
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//                 color: context.colors.border,
//                 borderRadius: BorderRadius.circular(99))),
//         const SizedBox(height: 20),
//         Text('মাস বেছে নিন',
//             style: TextStyle(
//                 color: context.colors.textPrimary,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700)),
//         const SizedBox(height: 18),
//         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           _YearBtn(
//               icon: Icons.chevron_left_rounded,
//               onTap: () => setState(() => _y--)),
//           Container(
//               padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
//               decoration: BoxDecoration(
//                   color: context.colors.greenLight,
//                   borderRadius: BorderRadius.circular(12)),
//               child: Text('$_y',
//                   style: TextStyle(
//                       color: context.colors.darkGreen,
//                       fontWeight: FontWeight.w800,
//                       fontSize: 18))),
//           _YearBtn(
//               icon: Icons.chevron_right_rounded,
//               onTap: _y < now.year ? () => setState(() => _y++) : null),
//         ]),
//         const SizedBox(height: 16),
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 4,
//               crossAxisSpacing: 8,
//               mainAxisSpacing: 8,
//               childAspectRatio: 1.75),
//           itemCount: 12,
//           itemBuilder: (_, i) {
//             final isSelected = i + 1 == _m;
//             final isFuture = _y == now.year && i + 1 > now.month;
//             return GestureDetector(
//               onTap: isFuture
//                   ? null
//                   : () {
//                       widget.onPicked(_y, i + 1);
//                       Navigator.pop(context);
//                     },
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 180),
//                 decoration: BoxDecoration(
//                     color: isSelected
//                         ? context.colors.darkGreen
//                         : context.colors.pageBg,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                         color: isSelected
//                             ? context.colors.darkGreen
//                             : isFuture
//                                 ? context.colors.border.withOpacity(0.4)
//                                 : context.colors.border,
//                         width: 0.5)),
//                 child: Center(
//                     child: Text(AppConstants.bengaliMonths[i],
//                         style: TextStyle(
//                             color: isSelected
//                                 ? Colors.white
//                                 : isFuture
//                                     ? context.colors.textHint
//                                     : context.colors.textSecondary,
//                             fontSize: 12,
//                             fontWeight: isSelected
//                                 ? FontWeight.w700
//                                 : FontWeight.w500))),
//               ),
//             );
//           },
//         ),
//         const SizedBox(height: 4),
//       ]),
//     );
//   }
// }

// class _YearBtn extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback? onTap;
//   const _YearBtn({required this.icon, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 38,
//         height: 38,
//         margin: const EdgeInsets.symmetric(horizontal: 10),
//         decoration: BoxDecoration(
//             color: onTap != null
//                 ? context.colors.greenLight
//                 : context.colors.pageBg,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//                 color: onTap != null
//                     ? context.colors.borderMid2
//                     : context.colors.border,
//                 width: 0.5)),
//         child: Icon(icon,
//             color: onTap != null
//                 ? context.colors.darkGreen
//                 : context.colors.textHint,
//             size: 20),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SKELETONS
// // ─────────────────────────────────────────────────────────────────────────────

// class _LeaderboardSkeleton extends StatelessWidget {
//   const _LeaderboardSkeleton();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         _shimBox(width: 100, height: 14, context: context),
//         const SizedBox(height: 12),
//         _shimBox(
//             width: double.infinity, height: 290, radius: 16, context: context),
//         const SizedBox(height: 24),
//         _shimBox(width: 100, height: 14, context: context),
//         const SizedBox(height: 12),
//         Container(
//           decoration: BoxDecoration(
//               color: context.colors.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: context.colors.border, width: 0.5)),
//           child: Column(
//               children: List.generate(
//                   5,
//                   (i) => Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
//                         decoration: BoxDecoration(
//                           border: i == 4 ? null : Border(bottom: BorderSide(color: context.colors.border, width: 0.5)),
//                         ),
//                         child: Row(
//                           children: [
//                             // Rank
//                             Container(
//                               width: 24,
//                               height: 14,
//                               decoration: BoxDecoration(
//                                   color: context.colors.pageBg,
//                                   borderRadius: BorderRadius.circular(4)),
//                             ),
//                             const SizedBox(width: 18),
//                             // Avatar
//                             Container(
//                               width: 40,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                   color: context.colors.pageBg,
//                                   borderRadius: BorderRadius.circular(11)),
//                             ),
//                             const SizedBox(width: 12),
//                             // Name & district
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Container(
//                                   width: 80,
//                                   height: 12,
//                                   decoration: BoxDecoration(
//                                       color: context.colors.pageBg,
//                                       borderRadius: BorderRadius.circular(4)),
//                                 ),
//                                 const SizedBox(height: 6),
//                                 Container(
//                                   width: 50,
//                                   height: 9,
//                                   decoration: BoxDecoration(
//                                       color: context.colors.pageBg.withOpacity(0.6),
//                                       borderRadius: BorderRadius.circular(4)),
//                                 ),
//                               ],
//                             ),
//                             const Spacer(),
//                             // Stats
//                             Container(
//                               width: 65,
//                               height: 12,
//                               decoration: BoxDecoration(
//                                   color: context.colors.pageBg,
//                                   borderRadius: BorderRadius.circular(4)),
//                             ),
//                             const SizedBox(width: 10),
//                             // Arrow
//                             Container(
//                               width: 18,
//                               height: 18,
//                               decoration: BoxDecoration(
//                                   color: context.colors.pageBg,
//                                   shape: BoxShape.circle),
//                             ),
//                           ],
//                         ),
//                       ).animate(onPlay: (c) => c.repeat()).shimmer(
//                         duration: 1200.ms,
//                         delay: Duration(milliseconds: i * 70),
//                         colors: [
//                           context.colors.cardBg,
//                           context.colors.shimmerHighlight,
//                           context.colors.cardBg
//                         ],
//                       ))),
//         ),
//       ]),
//     );
//   }

//   Widget _shimBox(
//       {required double width,
//       required double height,
//       double radius = 10,
//       required BuildContext context}) {
//     return Container(
//       width: width,
//       height: height,
//       decoration: BoxDecoration(
//           color: context.colors.cardBg,
//           borderRadius: BorderRadius.circular(radius),
//           border: Border.all(color: context.colors.border, width: 0.5)),
//     ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, colors: [
//       context.colors.cardBg,
//       context.colors.shimmerHighlight,
//       context.colors.cardBg
//     ]);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // ERROR + EMPTY
// // ─────────────────────────────────────────────────────────────────────────────

// class _ErrorCard extends StatelessWidget {
//   final String message;
//   final VoidCallback onRetry;
//   const _ErrorCard({required this.message, required this.onRetry});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//             color: context.colors.cardBg,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: context.colors.border, width: 0.5)),
//         child: Column(children: [
//           Icon(Icons.error_outline_rounded,
//               color: context.colors.red, size: 28),
//           const SizedBox(height: 10),
//           Text('ত্রুটি হয়েছে',
//               style: TextStyle(
//                   color: context.colors.textPrimary,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 14)),
//           const SizedBox(height: 6),
//           Text(message,
//               textAlign: TextAlign.center,
//               style:
//                   TextStyle(color: context.colors.textSecondary, fontSize: 12)),
//           const SizedBox(height: 16),
//           GestureDetector(
//               onTap: onRetry,
//               child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
//                   decoration: BoxDecoration(
//                       color: context.colors.greenLight,
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Text('পুনরায় চেষ্টা করুন',
//                       style: TextStyle(
//                           color: context.colors.darkGreen,
//                           fontWeight: FontWeight.w700,
//                           fontSize: 12)))),
//         ]),
//       ),
//     );
//   }
// }

// class _EmptyCard extends StatelessWidget {
//   final String label;
//   const _EmptyCard({required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
//       child: Container(
//         height: 120,
//         decoration: BoxDecoration(
//             color: context.colors.cardBg,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: context.colors.border, width: 0.5)),
//         child: Center(
//             child:
//                 Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//           const Text('📭', style: TextStyle(fontSize: 24)),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: Text(label,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     color: context.colors.textHint,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500)),
//           ),
//         ])),
//       ),
//     );
//   }
// }
import 'package:amal_tracker/features/auth/providers/auth_provider.dart';
import 'package:amal_tracker/features/leaderboard/widgets/gender_filter.dart';
import 'package:amal_tracker/features/leaderboard/widgets/public_profile_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/leaderboard_provider.dart';
import '../../tracker/models/tracker_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/cache_provider.dart';
import '../../../shared/widgets/delayed_progress_indicator.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────
// LEADERBOARD SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  final _sc = ScrollController();

  @override
  void initState() {
    super.initState();
    _sc.addListener(_onScroll);
  }

  void _onScroll() {
    if (_sc.position.pixels >= _sc.position.maxScrollExtent - 200) {
      final state = ref.read(leaderboardProvider);
      if (!state.isLoadingMore && state.hasMore) {
        final f = ref.read(leaderboardFilterProvider);
        ref
            .read(leaderboardProvider.notifier)
            .load(f.copyWith(page: state.currentPage + 1));
      }
    }
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final f = ref.read(leaderboardFilterProvider);
    ref
        .read(cacheStatusProvider.notifier)
        .updateLastFetched(CacheTab.leaderboard);
    await Future.wait([
      ref.read(leaderboardProvider.notifier).load(f, refresh: true),
      ref.refresh(myRankProvider((year: f.year, month: f.month)).future),
    ]);
  }

  /// Single place that actually switches the selected month — called both
  /// by a direct tap on one of the recent-month chips and by the full month
  /// picker sheet, so there's exactly one code path for "change month"
  /// instead of the chip row and the picker doing slightly different things.
  void _applyMonth(int year, int month) {
    final f = ref.read(leaderboardFilterProvider);
    final next = f.copyWith(year: year, month: month, page: 1);
    ref.read(leaderboardFilterProvider.notifier).state = next;
    ref.read(leaderboardProvider.notifier).load(next, refresh: true);
  }

  void _pickMonth() {
    final f = ref.read(leaderboardFilterProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _MonthPickerSheet(
        year: f.year,
        month: f.month,
        onPicked: _applyMonth,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(cacheStatusProvider); // Watch to rebuild on lifecycle/app resume
    final filter = ref.watch(leaderboardFilterProvider);

    // Lazy check-and-refresh for Leaderboard Tab data
    final activeIndex = ref.watch(activeTabIndexProvider);
    if (activeIndex == 4) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          checkAndRefreshTab(ref, CacheTab.leaderboard, () {
            ref.read(leaderboardProvider.notifier).load(filter, refresh: true);
            ref.refresh(
                myRankProvider((year: filter.year, month: filter.month)));
          }, ttl: const Duration(minutes: 5));
        }
      });
    }

    final state = ref.watch(leaderboardProvider);
    final myRank = ref.watch(
      myRankProvider((year: filter.year, month: filter.month)),
    );

    // Current user gender — male user শুধু male profile দেখতে পাবে
    final currentUser = ref.watch(currentUserProvider);
    final isMaleUser = currentUser?.gender?.toLowerCase() == 'male';

    final isBackgroundRefreshing =
        state.isRefreshing || (myRank.isLoading && myRank.hasValue);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: context.colors.pageBg,
        body: Stack(
          children: [
            RefreshIndicator(
              color: context.colors.darkGreen,
              onRefresh: _refresh,
              child: CustomScrollView(
                controller: _sc,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // ── App Bar ─────────────────────────────────────────────
                  // Kept intentionally simple — just the section identity.
                  // Month display + switching lives in exactly one place now
                  // (the sticky chip row below), so it isn't repeated here.
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 0,
                    toolbarHeight: 52,
                    backgroundColor: context.colors.darkGreen,
                    surfaceTintColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    systemOverlayStyle: SystemUiOverlayStyle.light,
                    title: Row(children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.15),
                              width: 0.5),
                        ),
                        child: const Icon(Icons.leaderboard_rounded,
                            color: Colors.white, size: 15),
                      ),
                      const SizedBox(width: 10),
                      const Text('লিডারবোর্ড',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2)),
                    ]),
                  ),

                  // ── Hero Band ────────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: _HeroBand(
                      myRankAsync: myRank,
                      ref: ref,
                    ).animate().fadeIn(duration: 280.ms),
                  ),

                  // ── Month Chips (sticky) — the single month control ──────
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _MonthChipDelegate(
                      filter: filter,
                      onSelect: _applyMonth,
                      onOpenPicker: _pickMonth,
                    ),
                  ),

                  // ── Gender Filter ─────────────────────────────────────────
                  // Male users can't actually use this (only ever see male
                  // profiles), so showing a permanently-disabled filter row
                  // just costs them vertical space for nothing — hide it
                  // entirely for that group instead of rendering a dead control.
                  if (!isMaleUser)
                    SliverToBoxAdapter(
                      child: GenderFilterChips(
                        selected: filter.gender,
                        onChanged: (g) {
                          final next = ref
                              .read(leaderboardFilterProvider.notifier)
                              .state
                              .copyWith(
                                gender: g,
                                clearGender: g == null,
                                page: 1,
                              );
                          ref.read(leaderboardFilterProvider.notifier).state =
                              next;
                          ref
                              .read(leaderboardProvider.notifier)
                              .load(next, refresh: true);
                        },
                      ),
                    ),

                  // ── Body ─────────────────────────────────────────────────
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    sliver: _buildBody(state, filter, isMaleUser),
                  ),
                ],
              ),
            ),
            if (isBackgroundRefreshing)
              Positioned(
                top: MediaQuery.of(context).padding.top + 50,
                left: 0,
                right: 0,
                child: const SizedBox(
                  height: 2,
                  child: DelayedLinearProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.transparent,
                    delay: Duration(milliseconds: 400),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
      LeaderboardState state, LeaderboardFilter filter, bool isMaleUser) {
    if (state.isLoading) {
      return SliverToBoxAdapter(
          child: const _LeaderboardSkeleton()
              .animate()
              .fadeIn(delay: 80.ms, duration: 260.ms));
    }

    if (state.error != null) {
      return SliverToBoxAdapter(
          child: _ErrorCard(message: state.error!, onRetry: _refresh)
              .animate()
              .fadeIn(duration: 260.ms));
    }

    if (state.entries.isEmpty) {
      return SliverToBoxAdapter(
          child: const _EmptyCard(label: 'এই মাসে এখনো কেউ আমল রেকর্ড করেননি')
              .animate()
              .fadeIn(duration: 260.ms));
    }

    final top3 = state.entries.take(3).toList();
    final rest = state.entries.length > 3
        ? state.entries.sublist(3)
        : <LeaderboardEntry>[];

    return SliverList(
      delegate: SliverChildListDelegate([
        const SizedBox(height: 8),
        _SectionHeader(title: 'শীর্ষ তিনজন', emoji: '🥇')
            .animate()
            .fadeIn(delay: 100.ms),
        const SizedBox(height: 12),
        if (top3.isNotEmpty)
          _PodiumCard(
            top3: top3,
            year: filter.year,
            month: filter.month,
            isMaleUser: isMaleUser,
          )
              .animate()
              .fadeIn(delay: 120.ms, duration: 320.ms)
              .slideY(begin: 0.08, curve: Curves.easeOut),
        const SizedBox(height: 24),
        if (rest.isNotEmpty) ...[
          _SectionHeader(title: 'সম্পূর্ণ তালিকা', emoji: '📋')
              .animate()
              .fadeIn(delay: 160.ms),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: context.colors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.colors.border, width: 0.5),
            ),
            child: Column(
              children: List.generate(rest.length, (i) {
                return _RankTile(
                  entry: rest[i],
                  isLast: i == rest.length - 1,
                  delay: 180 + i * 40,
                  year: filter.year,
                  month: filter.month,
                  isMaleUser: isMaleUser,
                );
              }),
            ),
          ).animate().fadeIn(delay: 180.ms, duration: 280.ms),
        ],
        if (state.isLoadingMore) ...[
          const SizedBox(height: 20),
          Center(
              child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      color: context.colors.darkGreen, strokeWidth: 2))),
          const SizedBox(height: 20),
        ] else
          const SizedBox(height: 8),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HERO BAND — points বাদ, completion % + farz + jamaat + streak
// month/year আর এখানে repeat করা হয় না — sticky chip row-ই এখন month
// display ও control-এর একমাত্র জায়গা।
// ─────────────────────────────────────────────────────────────────────────────

class _HeroBand extends StatelessWidget {
  final AsyncValue<MyRankData> myRankAsync;
  final WidgetRef ref;

  const _HeroBand({required this.myRankAsync, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.darkGreen,
      child: Stack(children: [
        Positioned(
            top: -45,
            right: -45,
            child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.04)))),
        Positioned(
            bottom: -25,
            left: 20,
            child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.03)))),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('শীর্ষ আমলকারীরা',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            myRankAsync.when(
              loading: () => const _MyRankSkeleton(),
              error: (error, _) => _MyRankErrorCard(
                message: error.toString(),
                onRetry: () {
                  final f = ref.read(leaderboardFilterProvider);
                  ref.invalidate(
                      myRankProvider((year: f.year, month: f.month)));
                },
              ),
              data: (d) => _MyRankCard(data: d),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MY RANK CARD — points বাদ, completion % + farz + jamaat + streak
// ─────────────────────────────────────────────────────────────────────────────

class _MyRankCard extends StatelessWidget {
  final MyRankData data;
  const _MyRankCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final pct = data.completionPercentage.toInt();
    final farzDays = data.farzCompletedDays ?? 0;
    final jamaat = data.congregationDaysTotal ?? 0;
    final streak = data.streakDays ?? 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.09),
          borderRadius: BorderRadius.circular(14),
          border:
              Border.all(color: Colors.white.withOpacity(0.18), width: 0.5)),
      child: Row(children: [
        // Rank badge
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
              color: context.colors.gold,
              borderRadius: BorderRadius.circular(13)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(data.rank != null ? '#${data.rank}' : '—',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    height: 1)),
            Text('আমার',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 8,
                    fontWeight: FontWeight.w600)),
          ]),
        ),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('আমার অবস্থান',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5), fontSize: 10)),
          const SizedBox(height: 4),
          // Completion % big
          Row(children: [
            Text('$pct%',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    letterSpacing: -0.4,
                    height: 1)),
            const SizedBox(width: 6),
            Text('ফরজ সম্পন্ন',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: 10.5)),
            if (data.isWinner) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                    color: context.colors.gold,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Text('🏆', style: TextStyle(fontSize: 9)),
                  const SizedBox(width: 3),
                  Text(data.winnerCategory ?? 'বিজয়ী',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700)),
                ]),
              ),
            ],
          ]),
          const SizedBox(height: 6),
          // Chips row
          Wrap(spacing: 5, runSpacing: 4, children: [
            _MyRankChip(
                icon: Icons.check_circle_rounded, label: '$farzDays ফরজ দিন'),
            _MyRankChip(icon: Icons.people_rounded, label: '$jamaat জামাত'),
            if (streak > 0)
              _MyRankChip(
                  icon: Icons.local_fire_department_rounded,
                  label: '$streak ধারা'),
          ]),
        ])),
      ]),
    );
  }
}

class _MyRankChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MyRankChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: Colors.white.withOpacity(0.65), size: 10),
        const SizedBox(width: 3),
        Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 9.5,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _MyRankSkeleton extends StatelessWidget {
  const _MyRankSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14)),
    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, colors: [
      Colors.white.withOpacity(0.02),
      Colors.white.withOpacity(0.12),
      Colors.white.withOpacity(0.02),
    ]);
  }
}

class _MyRankErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _MyRankErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.09),
          borderRadius: BorderRadius.circular(14),
          border:
              Border.all(color: Colors.white.withOpacity(0.18), width: 0.5)),
      child: Row(children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
              color: context.colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.error_outline_rounded,
              color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
            child: Text('আমার অবস্থান লোড হয়নি',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 11,
                    fontWeight: FontWeight.w600))),
        GestureDetector(
          onTap: onRetry,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8)),
            child: const Text('রিট্রাই',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11)),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title, emoji;
  const _SectionHeader({required this.title, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 14)),
      const SizedBox(width: 7),
      Text(title,
          style: TextStyle(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 15,
              letterSpacing: -0.2)),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _SerialBadge extends StatelessWidget {
  final String id;
  final bool onDark;
  const _SerialBadge({required this.id, this.onDark = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color:
            onDark ? Colors.white.withOpacity(0.12) : context.colors.serialBg,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color:
                onDark ? Colors.white.withOpacity(0.18) : context.colors.border,
            width: 0.5),
      ),
      child: Text(id,
          style: TextStyle(
              color: onDark
                  ? Colors.white.withOpacity(0.55)
                  : context.colors.serialText,
              fontSize: 8.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2)),
    );
  }
}

class _DistrictPill extends StatelessWidget {
  final String district;
  final bool onDark;
  final bool compact;
  const _DistrictPill(
      {required this.district, this.onDark = false, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: compact ? 5 : 6, vertical: compact ? 2 : 2.5),
      decoration: BoxDecoration(
        color:
            onDark ? Colors.white.withOpacity(0.12) : context.colors.districtBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color:
                onDark ? Colors.white.withOpacity(0.18) : context.colors.border,
            width: 0.5),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.location_on_rounded,
            size: compact ? 7.5 : 8.5,
            color: onDark
                ? Colors.white.withOpacity(0.55)
                : context.colors.districtText),
        const SizedBox(width: 2),
        Text(district,
            style: TextStyle(
                color: onDark
                    ? Colors.white.withOpacity(0.7)
                    : context.colors.districtText,
                fontSize: compact ? 8.5 : 9.5,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPER: can current user view this entry's profile?
// Male user → শুধু male profiles দেখতে পাবে
// Female user → সবার profile দেখতে পাবে
// ─────────────────────────────────────────────────────────────────────────────

bool _canViewProfile(LeaderboardEntry entry, bool isMaleUser) {
  if (!entry.isProfilePublic) return false;
  if (isMaleUser && entry.gender?.toLowerCase() == 'female') return false;
  return true;
}

// ─────────────────────────────────────────────────────────────────────────────
// PODIUM CARD
// ─────────────────────────────────────────────────────────────────────────────

class _PodiumCard extends StatelessWidget {
  final List<LeaderboardEntry> top3;
  final int year, month;
  final bool isMaleUser;

  const _PodiumCard({
    required this.top3,
    required this.year,
    required this.month,
    required this.isMaleUser,
  });

  @override
  Widget build(BuildContext context) {
    final first = top3[0];
    final second = top3.length > 1 ? top3[1] : null;
    final third = top3.length > 2 ? top3[2] : null;

    final title = top3.length == 1
        ? 'এই মাসের শীর্ষ আমলকারী'
        : (top3.length == 2 ? 'এই মাসের শীর্ষ দুইজন' : 'এই মাসের শীর্ষ তিনজন');

    return Container(
      decoration: BoxDecoration(
          color: context.colors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.colors.border, width: 0.5)),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('🌟', style: TextStyle(fontSize: 13)),
            const SizedBox(width: 6),
            Text(title,
                style: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
            const SizedBox(width: 6),
            const Text('🌟', style: TextStyle(fontSize: 13)),
          ]),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (second != null) ...[
                _PodiumPillar(
                    entry: second,
                    rank: 2,
                    year: year,
                    month: month,
                    isMaleUser: isMaleUser),
                const SizedBox(width: 12),
              ],
              _PodiumPillar(
                  entry: first,
                  rank: 1,
                  isFirst: true,
                  year: year,
                  month: month,
                  isMaleUser: isMaleUser),
              if (third != null) ...[
                const SizedBox(width: 12),
                _PodiumPillar(
                    entry: third,
                    rank: 3,
                    year: year,
                    month: month,
                    isMaleUser: isMaleUser),
              ],
            ],
          ),
        ),
      ]),
    );
  }
}

class _PodiumPillar extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;
  final bool isFirst;
  final int year, month;
  final bool isMaleUser;

  const _PodiumPillar({
    required this.entry,
    required this.rank,
    required this.year,
    required this.month,
    required this.isMaleUser,
    this.isFirst = false,
  });

  Color _rankColor(BuildContext context) => rank == 1
      ? context.colors.rankGold
      : rank == 2
          ? context.colors.rankSilver
          : context.colors.rankBronze;

  String get _rankEmoji => rank == 1
      ? '🥇'
      : rank == 2
          ? '🥈'
          : '🥉';
  double get _avatarSize => isFirst
      ? 60.0
      : rank == 2
          ? 48.0
          : 44.0;
  double get _pillarWidth => isFirst
      ? 100.0
      : rank == 2
          ? 88.0
          : 80.0;
  EdgeInsets get _pillarPadding => EdgeInsets.symmetric(
      vertical: rank == 1 ? 6.0 : (rank == 2 ? 5.0 : 4.0), horizontal: 4.0);

  @override
  Widget build(BuildContext context) {
    final canView = _canViewProfile(entry, isMaleUser);
    final initial = entry.name.isNotEmpty ? entry.name[0].toUpperCase() : 'U';

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        if (canView) {
          showPublicProfileSheet(context,
              entry: entry, year: year, month: month, isMaleUser: isMaleUser);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(children: [
              const Icon(Icons.lock_outline_rounded,
                  color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(entry.isProfilePublic
                  ? 'নিরাপত্তা জনিত কারণে আপনি এই প্রোফাইলটি দেখতে পারবেন না।'
                  : 'এই ব্যবহারকারীর প্রোফাইলটি ব্যক্তিগত (Private) করা আছে।'),
            ]),
            backgroundColor: context.colors.textPrimary,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ));
        }
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: _pillarWidth,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Medal
          Text(_rankEmoji, style: TextStyle(fontSize: isFirst ? 24 : 20))
              .animate()
              .scale(
                  delay: Duration(milliseconds: rank * 80),
                  duration: 380.ms,
                  curve: Curves.elasticOut),
          const SizedBox(height: 4),

          // Avatar
          Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                if (isFirst)
                  Container(
                    width: _avatarSize + 12,
                    height: _avatarSize + 12,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          _rankColor(context).withOpacity(0.20),
                          _rankColor(context).withOpacity(0.0),
                        ])),
                  ),
                Container(
                  width: _avatarSize,
                  height: _avatarSize,
                  decoration: BoxDecoration(
                      color: _rankColor(context).withOpacity(0.10),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: _rankColor(context),
                          width: isFirst ? 2.5 : 2.0),
                      boxShadow: [
                        BoxShadow(
                            color: _rankColor(context)
                                .withOpacity(isFirst ? 0.30 : 0.15),
                            blurRadius: isFirst ? 14 : 8)
                      ]),
                  child: Center(
                      child: Text(initial,
                          style: TextStyle(
                              color: _rankColor(context),
                              fontSize: isFirst
                                  ? 24
                                  : rank == 2
                                      ? 18
                                      : 16,
                              fontWeight: FontWeight.w900,
                              height: 1))),
                ),
                // Public/Private dot
                Positioned(
                  top: isFirst ? -2 : -1,
                  right: isFirst ? -2 : -1,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                        color: canView
                            ? context.colors.avatar4
                            : context.colors.textHint,
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: context.colors.cardBg, width: 2)),
                    child: Icon(
                        canView ? Icons.visibility_rounded : Icons.lock_rounded,
                        size: 8,
                        color: canView
                            ? Colors.white
                            : (Theme.of(context).brightness == Brightness.dark
                                ? Colors.black87
                                : Colors.white)),
                  ),
                ),
              ]),
          const SizedBox(height: 5),

          // Name
          Text(entry.name.split(' ').first,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: isFirst ? 13.5 : 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2)),
          const SizedBox(height: 1),

          // ID
          if (entry.id.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
              decoration: BoxDecoration(
                  color: context.colors.serialBg,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: context.colors.border, width: 0.5)),
              child: Text(entry.id,
                  style: TextStyle(
                      color: context.colors.serialText,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w600)),
            ),
          const SizedBox(height: 1),

          // District
          if (entry.district.isNotEmpty)
            Text(entry.district,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: context.colors.districtText,
                    fontSize: 9.0,
                    fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),

          // Pillar bar — points বাদ, completion + farz + jamaat
          _PillarBar(
            entry: entry,
            rank: rank,
            isFirst: isFirst,
            rankColor: _rankColor(context),
            pillarWidth: _pillarWidth,
            pillarPadding: _pillarPadding,
            pillarHeight: rank == 1 ? 108.0 : (rank == 2 ? 90.0 : 76.0),
          ),
        ]),
      ),
    );
  }
}

// ── Pillar bar — completion % + farz days + jamaat ───────────────────────────

class _PillarBar extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;
  final bool isFirst;
  final Color rankColor;
  final double pillarWidth;
  final EdgeInsets pillarPadding;
  final double pillarHeight;

  const _PillarBar({
    required this.entry,
    required this.rank,
    required this.isFirst,
    required this.rankColor,
    required this.pillarWidth,
    required this.pillarPadding,
    required this.pillarHeight,
  });

  @override
  Widget build(BuildContext context) {
    final pct = entry.completionPercentage.toInt();
    final farz = entry.farzCompletedDays;
    final jamaat = entry.congregationDaysTotal;
    final streak = entry.streakDays;
    final daysActive = entry.daysActive;

    return Container(
      width: pillarWidth,
      height: pillarHeight,
      clipBehavior: Clip
          .antiAlias, // Smoothly clips children to this container's rounded corners
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              rankColor.withOpacity(0.9),
              rankColor.withOpacity(0.55),
            ]),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
        boxShadow: [
          BoxShadow(
            color: rankColor.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 0.75),
      ),
      child: Stack(
        children: [
          // Top highlight line inside the pillar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 2.5,
              color: rankColor,
            ),
          ),

          Positioned.fill(
            child: Padding(
              padding: pillarPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center contents horizontally
                children: [
                  const SizedBox(height: 2), // Space for Positioned bar
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Center text horizontally
                    children: [
                      Text(
                        '$pct%',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: isFirst ? 16 : 13,
                          height: 1,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'সম্পন্ন',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: isFirst ? 8.0 : 7.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Center stats horizontally
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_rounded,
                                size: 8, color: Colors.white.withOpacity(0.85)),
                            const SizedBox(width: 1),
                            Text(
                              '$farz',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.people_rounded,
                                size: 8, color: Colors.white.withOpacity(0.85)),
                            const SizedBox(width: 1),
                            Text(
                              '$jamaat',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (streak > 0) ...[
                              const SizedBox(width: 4),
                              const Text('🔥', style: TextStyle(fontSize: 8)),
                              const SizedBox(width: 0.5),
                              Text(
                                '$streak',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 1),
                        Text(
                          '$daysActive দিন সক্রিয়',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 7.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    '#$rank',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w900,
                      fontSize: isFirst ? 16 : 13,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillarPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isFirst;
  const _PillarPill(
      {required this.icon,
      required this.label,
      required this.color,
      required this.isFirst});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isFirst ? 9 : 7, vertical: isFirst ? 4 : 3),
      decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.25), width: 0.75)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: isFirst ? 9.5 : 8.5, color: color.withOpacity(0.85)),
        const SizedBox(width: 3),
        Text(label,
            style: TextStyle(
                color: color,
                fontSize: isFirst ? 9.5 : 8.5,
                fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RANK TILE — points বাদ, completion + farz + jamaat + streak
// ─────────────────────────────────────────────────────────────────────────────

class _RankTile extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool isLast;
  final int delay, year, month;
  final bool isMaleUser;

  const _RankTile({
    required this.entry,
    required this.isLast,
    required this.delay,
    required this.year,
    required this.month,
    required this.isMaleUser,
  });

  List<Color> _avatarColors(BuildContext context) => [
        context.colors.avatar1,
        context.colors.avatar2,
        context.colors.avatar3,
        context.colors.avatar4,
        context.colors.avatar5,
      ];

  Color _avatarColor(BuildContext context) {
    final colors = _avatarColors(context);
    return colors[(entry.rank - 4).clamp(0, colors.length - 1) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final isTop10 = entry.rank <= 10;
    final isWinner = entry.isWinner;
    final canView = _canViewProfile(entry, isMaleUser);
    final pct = entry.completionPercentage.toInt();
    final farz = entry.farzCompletedDays;
    final jamaat = entry.congregationDaysTotal;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        if (canView) {
          showPublicProfileSheet(context,
              entry: entry, year: year, month: month, isMaleUser: isMaleUser);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(children: [
              const Icon(Icons.lock_outline_rounded,
                  color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(entry.isProfilePublic
                  ? 'নিরাপত্তা জনিত কারণে আপনি এই প্রোফাইলটি দেখতে পারবেন না।'
                  : 'এই ব্যবহারকারীর প্রোফাইলটি ব্যক্তিগত (Private) করা আছে।'),
            ]),
            backgroundColor: context.colors.textPrimary,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: isWinner ? context.colors.goldPale : Colors.transparent,
          borderRadius: isLast
              ? const BorderRadius.vertical(bottom: Radius.circular(16))
              : null,
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(color: context.colors.border, width: 0.5)),
        ),
        child: Row(children: [
          // Rank
          SizedBox(
            width: 36,
            child: Text('#${entry.rank}',
                style: TextStyle(
                    color: isTop10
                        ? context.colors.darkGreen
                        : context.colors.textHint,
                    fontWeight: FontWeight.w800,
                    fontSize: isTop10 ? 14 : 12,
                    height: 1)),
          ),
          const SizedBox(width: 6),

          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: isTop10
                    ? _avatarColor(context)
                    : context.colors.textHint.withOpacity(0.4),
                borderRadius: BorderRadius.circular(11)),
            child: Center(
                child: Text(
                    entry.name.isNotEmpty ? entry.name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16))),
          ),
          const SizedBox(width: 10),

          // Name + meta
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(children: [
                  Flexible(
                      child: Text(entry.name,
                          style: TextStyle(
                              color: context.colors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13),
                          overflow: TextOverflow.ellipsis)),
                  if (isWinner) ...[
                    const SizedBox(width: 4),
                    const Text('🏆', style: TextStyle(fontSize: 11)),
                  ],
                ]),
                const SizedBox(height: 4),
                _MetaRow(entry: entry),
              ])),
          const SizedBox(width: 8),

          // Completion % + farz + profile badge
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('$pct%',
                style: TextStyle(
                    color: isWinner
                        ? context.colors.gold
                        : isTop10
                            ? context.colors.darkGreen
                            : context.colors.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    height: 1)),
            const SizedBox(height: 2),
            Text(
                '$farz  ফরজ · $jamaat  জামাত · ${entry.daysActive}  দিন সক্রিয়',
                style: TextStyle(
                    color: context.colors.textHint,
                    fontSize: 9,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            _ProfileBadge(isPublic: canView),
          ]),
        ]),
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 260.ms)
        .slideX(begin: 0.04, curve: Curves.easeOut);
  }
}

class _MetaRow extends StatelessWidget {
  final LeaderboardEntry entry;
  const _MetaRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 3,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (entry.id.isNotEmpty)
          Text('ID: ${entry.id}',
              style:
                  TextStyle(color: context.colors.textSecondary, fontSize: 10)),
        if (entry.id.isNotEmpty && entry.district.isNotEmpty)
          Text('·',
              style: TextStyle(color: context.colors.textHint, fontSize: 10)),
        if (entry.district.isNotEmpty) _DistrictPill(district: entry.district),
        if ((entry.id.isNotEmpty || entry.district.isNotEmpty) &&
            entry.streakDays > 0)
          Text('·',
              style: TextStyle(color: context.colors.textHint, fontSize: 10)),
        if (entry.streakDays > 0)
          Text('🔥 ${entry.streakDays}',
              style: TextStyle(
                  color: context.colors.amber2,
                  fontSize: 10,
                  fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ProfileBadge extends StatelessWidget {
  final bool isPublic;
  const _ProfileBadge({required this.isPublic});

  @override
  Widget build(BuildContext context) {
    if (!isPublic) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
            color: context.colors.bg,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: context.colors.border, width: 0.5)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.lock_outline_rounded,
              size: 8, color: context.colors.textHint),
          SizedBox(width: 2),
          Text('Private',
              style: TextStyle(
                  color: context.colors.textHint,
                  fontSize: 8,
                  fontWeight: FontWeight.w500)),
        ]),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
          color: context.colors.blueLight,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              color: context.colors.avatar4.withOpacity(0.3), width: 0.5)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.visibility_outlined, size: 8, color: context.colors.avatar4),
        SizedBox(width: 2),
        Text('দেখুন',
            style: TextStyle(
                color: context.colors.avatar4,
                fontSize: 8,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MONTH CHIP DELEGATE (sticky) — the single functional month control.
// Tapping a recent-month chip switches DIRECTLY to that month (no sheet).
// A trailing calendar icon opens the full picker for anything older than
// the last 6 months.
// ─────────────────────────────────────────────────────────────────────────────

class _MonthChipDelegate extends SliverPersistentHeaderDelegate {
  final LeaderboardFilter filter;
  final void Function(int year, int month) onSelect;
  final VoidCallback onOpenPicker;
  const _MonthChipDelegate({
    required this.filter,
    required this.onSelect,
    required this.onOpenPicker,
  });

  static const _height = 53.0;

  @override
  double get minExtent => _height;
  @override
  double get maxExtent => _height;
  @override
  bool shouldRebuild(_MonthChipDelegate old) => old.filter != filter;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final now = DateTime.now();
    final months = List.generate(6, (i) {
      final dt = DateTime(now.year, now.month - i);
      return (year: dt.year, month: dt.month);
    });

    return Container(
      color: context.colors.cardBg,
      child: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 11, 16, 11),
            child: Row(
              children: [
                ...months.map((m) {
                  final isActive =
                      m.month == filter.month && m.year == filter.year;
                  final label = AppConstants.bengaliMonths[m.month - 1];
                  return GestureDetector(
                    onTap: () => onSelect(m.year, m.month),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                          color: isActive
                              ? context.colors.darkGreen
                              : context.colors.pageBg,
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(
                              color: isActive
                                  ? context.colors.darkGreen
                                  : context.colors.border,
                              width: 0.5)),
                      child: Text(
                          m.year == now.year ? label : '$label ${m.year}',
                          style: TextStyle(
                              color: isActive
                                  ? Colors.white
                                  : context.colors.textSecondary,
                              fontSize: 11,
                              fontWeight: isActive
                                  ? FontWeight.w700
                                  : FontWeight.w500)),
                    ),
                  );
                }),
                // "Other months" — opens the full picker for anything
                // outside the last 6, the only remaining use for the sheet.
                GestureDetector(
                  onTap: onOpenPicker,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                        color: context.colors.pageBg,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: context.colors.border, width: 0.5)),
                    child: Icon(Icons.calendar_month_rounded,
                        size: 15, color: context.colors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(color: context.colors.border, height: 0.5, thickness: 0.5),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MONTH PICKER SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _MonthPickerSheet extends StatefulWidget {
  final int year, month;
  final void Function(int, int) onPicked;
  const _MonthPickerSheet(
      {required this.year, required this.month, required this.onPicked});

  @override
  State<_MonthPickerSheet> createState() => _MonthPickerSheetState();
}

class _MonthPickerSheetState extends State<_MonthPickerSheet> {
  late int _y, _m;

  @override
  void initState() {
    super.initState();
    _y = widget.year;
    _m = widget.month;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Container(
      decoration: BoxDecoration(
          color: context.colors.cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(99))),
        const SizedBox(height: 20),
        Text('মাস বেছে নিন',
            style: TextStyle(
                color: context.colors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 18),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _YearBtn(
              icon: Icons.chevron_left_rounded,
              onTap: () => setState(() => _y--)),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              decoration: BoxDecoration(
                  color: context.colors.greenLight,
                  borderRadius: BorderRadius.circular(12)),
              child: Text('$_y',
                  style: TextStyle(
                      color: context.colors.darkGreen,
                      fontWeight: FontWeight.w800,
                      fontSize: 18))),
          _YearBtn(
              icon: Icons.chevron_right_rounded,
              onTap: _y < now.year ? () => setState(() => _y++) : null),
        ]),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.75),
          itemCount: 12,
          itemBuilder: (_, i) {
            final isSelected = i + 1 == _m;
            final isFuture = _y == now.year && i + 1 > now.month;
            return GestureDetector(
              onTap: isFuture
                  ? null
                  : () {
                      widget.onPicked(_y, i + 1);
                      Navigator.pop(context);
                    },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                    color: isSelected
                        ? context.colors.darkGreen
                        : context.colors.pageBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: isSelected
                            ? context.colors.darkGreen
                            : isFuture
                                ? context.colors.border.withOpacity(0.4)
                                : context.colors.border,
                        width: 0.5)),
                child: Center(
                    child: Text(AppConstants.bengaliMonths[i],
                        style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : isFuture
                                    ? context.colors.textHint
                                    : context.colors.textSecondary,
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500))),
              ),
            );
          },
        ),
        const SizedBox(height: 4),
      ]),
    );
  }
}

class _YearBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _YearBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: onTap != null
                ? context.colors.greenLight
                : context.colors.pageBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: onTap != null
                    ? context.colors.borderMid2
                    : context.colors.border,
                width: 0.5)),
        child: Icon(icon,
            color: onTap != null
                ? context.colors.darkGreen
                : context.colors.textHint,
            size: 20),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SKELETONS
// ─────────────────────────────────────────────────────────────────────────────

class _LeaderboardSkeleton extends StatelessWidget {
  const _LeaderboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _shimBox(width: 100, height: 14, context: context),
        const SizedBox(height: 12),
        const _PodiumSkeleton(),
        const SizedBox(height: 24),
        _shimBox(width: 100, height: 14, context: context),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
              color: context.colors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.colors.border, width: 0.5)),
          child: Column(
              children: List.generate(
                  5,
                  (i) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 11),
                        decoration: BoxDecoration(
                          border: i == 4
                              ? null
                              : Border(
                                  bottom: BorderSide(
                                      color: context.colors.border,
                                      width: 0.5)),
                        ),
                        child: Row(
                          children: [
                            // Rank
                            Container(
                              width: 24,
                              height: 14,
                              decoration: BoxDecoration(
                                  color: context.colors.pageBg,
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            const SizedBox(width: 18),
                            // Avatar
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: context.colors.pageBg,
                                  borderRadius: BorderRadius.circular(11)),
                            ),
                            const SizedBox(width: 12),
                            // Name & district
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 80,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      color: context.colors.pageBg,
                                      borderRadius: BorderRadius.circular(4)),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: 50,
                                  height: 9,
                                  decoration: BoxDecoration(
                                      color: context.colors.pageBg
                                          .withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(4)),
                                ),
                              ],
                            ),
                            const Spacer(),
                            // Stats
                            Container(
                              width: 65,
                              height: 12,
                              decoration: BoxDecoration(
                                  color: context.colors.pageBg,
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            const SizedBox(width: 10),
                            // Arrow
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                  color: context.colors.pageBg,
                                  shape: BoxShape.circle),
                            ),
                          ],
                        ),
                      ).animate(onPlay: (c) => c.repeat()).shimmer(
                        duration: 1200.ms,
                        delay: Duration(milliseconds: i * 70),
                        colors: [
                          context.colors.cardBg,
                          context.colors.shimmerHighlight,
                          context.colors.cardBg
                        ],
                      ))),
        ),
      ]),
    );
  }

  Widget _shimBox(
      {required double width,
      required double height,
      double radius = 10,
      required BuildContext context}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: context.colors.cardBg,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: context.colors.border, width: 0.5)),
    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, colors: [
      context.colors.cardBg,
      context.colors.shimmerHighlight,
      context.colors.cardBg
    ]);
  }
}

// ── Real-shape podium skeleton ───────────────────────────────────────────────
// Mirrors _PodiumCard/_PodiumPillar/_PillarBar exactly: same title row, same
// 2nd–1st–3rd ordering, same avatar sizes (48/60/44), same pillar widths
// (88/100/80) and heights (90/108/76). So when the real data lands, nothing
// jumps or resizes — bones are just replaced by real content in place.
class _PodiumSkeleton extends StatelessWidget {
  const _PodiumSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: context.colors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.colors.border, width: 0.5)),
      child: Column(children: [
        const SizedBox(height: 12),
        _bone(context, width: 150, height: 13, radius: 7),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _pillar(context,
                  avatarSize: 48, pillarWidth: 88, pillarHeight: 90),
              const SizedBox(width: 12),
              _pillar(context,
                  avatarSize: 60, pillarWidth: 100, pillarHeight: 108),
              const SizedBox(width: 12),
              _pillar(context,
                  avatarSize: 44, pillarWidth: 80, pillarHeight: 76),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _pillar(
    BuildContext context, {
    required double avatarSize,
    required double pillarWidth,
    required double pillarHeight,
  }) {
    return SizedBox(
      width: pillarWidth,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _bone(context, width: 20, height: 20, radius: 99), // medal
        const SizedBox(height: 4),
        _bone(context,
            width: avatarSize, height: avatarSize, radius: avatarSize / 2),
        const SizedBox(height: 5),
        _bone(context, width: pillarWidth * 0.62, height: 11, radius: 4),
        const SizedBox(height: 4),
        _bone(context, width: pillarWidth * 0.42, height: 8, radius: 4),
        const SizedBox(height: 6),
        _bone(
          context,
          width: pillarWidth,
          height: pillarHeight,
          radius: 14,
          topRadiusOnly: true,
        ),
      ]),
    );
  }

  Widget _bone(
    BuildContext context, {
    required double width,
    required double height,
    double radius = 8,
    bool topRadiusOnly = false,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: context.colors.pageBg,
          borderRadius: topRadiusOnly
              ? BorderRadius.vertical(top: Radius.circular(radius))
              : BorderRadius.circular(radius)),
    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, colors: [
      context.colors.cardBg,
      context.colors.shimmerHighlight,
      context.colors.cardBg,
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ERROR + EMPTY
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: context.colors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colors.border, width: 0.5)),
        child: Column(children: [
          Icon(Icons.error_outline_rounded,
              color: context.colors.red, size: 28),
          const SizedBox(height: 10),
          Text('ত্রুটি হয়েছে',
              style: TextStyle(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14)),
          const SizedBox(height: 6),
          Text(message,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: context.colors.textSecondary, fontSize: 12)),
          const SizedBox(height: 16),
          GestureDetector(
              onTap: onRetry,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                  decoration: BoxDecoration(
                      color: context.colors.greenLight,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text('পুনরায় চেষ্টা করুন',
                      style: TextStyle(
                          color: context.colors.darkGreen,
                          fontWeight: FontWeight.w700,
                          fontSize: 12)))),
        ]),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String label;
  const _EmptyCard({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
            color: context.colors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colors.border, width: 0.5)),
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('📭', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: context.colors.textHint,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ),
        ])),
      ),
    );
  }
}
