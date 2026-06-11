// import 'package:amal_tracker/features/sadakah/screens/sadakah_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// import '../../auth/providers/auth_provider.dart';
// import '../../tracker/providers/tracker_provider.dart';
// import '../../tracker/models/tracker_model.dart';
// import '../../leaderboard/providers/leaderboard_provider.dart';
// import '../../../core/router/app_router.dart';
// import '../../../core/constants/app_constants.dart';
// import '../../notification/widgets/notification_widgets.dart';
// import '../../home/widgets/profile_sheet.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // DESIGN TOKENS
// // ─────────────────────────────────────────────────────────────────────────────

// class _C {
//   static const pageBg = Color(0xFFF4F6F1);
//   static const card = Color(0xFFFFFFFF);
//   static const darkGreen = Color(0xFF0E3D22);
//   static const midGreen = Color(0xFF1B7045);
//   static const gold = Color(0xFFD4A843);
//   static const goldLight = Color(0xFFFFF3E0);
//   static const goldBorder = Color(0xFFFFCC80);
//   static const goldLight2 = Color(0xFFFFF8E7);
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const amber = Color(0xFFF59E0B);
//   static const amberLight = Color(0xFFFFF7ED);
//   static const purple = Color(0xFF7C3AED);
//   static const purpleLight = Color(0xFFEDE9FE);
//   static const purplePale = Color(0xFFF3F0FF);
//   static const red = Color(0xFFEF4444);
//   static const redLight = Color(0xFFFEE2E2);
//   static const textPri = Color(0xFF0A1A0F);
//   static const textSec = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
//   static const border = Color(0xFFE4EAE4);
//   static const rankGold = Color(0xFFD4A843);
//   static const rankSilver = Color(0xFF94A3B8);
//   static const rankBronze = Color(0xFFCD7F32);
// }

// String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}K' : '$n';

// // ─────────────────────────────────────────────────────────────────────────────
// // HOME SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   final _sc = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _loadLeaderboard());
//   }

//   void _loadLeaderboard() {
//     final now = DateTime.now();
//     final user = ref.read(currentUserProvider);
//     ref.read(leaderboardPreviewProvider.notifier).load(
//           LeaderboardFilter(
//             year: now.year,
//             month: now.month,
//             limit: 3,
//             gender: user?.gender,
//           ),
//           refresh: true,
//         );
//   }

//   @override
//   void dispose() {
//     _sc.dispose();
//     super.dispose();
//   }

//   Future<void> _refresh() async {
//     final now = DateTime.now();
//     ref.invalidate(progressSummaryProvider((year: now.year, month: now.month)));
//     await ref.read(leaderboardPreviewProvider.notifier).load(
//           LeaderboardFilter(year: now.year, month: now.month, limit: 3),
//           refresh: true,
//         );
//   }

//   void _showProfile() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) => ProfileSheet(user: ref.read(currentUserProvider)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = ref.watch(currentUserProvider);
//     final now = DateTime.now();
//     final progress =
//         ref.watch(progressSummaryProvider((year: now.year, month: now.month)));
//     final board = ref.watch(leaderboardPreviewProvider);

//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.dark,
//       child: Scaffold(
//         backgroundColor: _C.pageBg,
//         appBar: _TopBar(user: user, onAvatarTap: _showProfile),
//         body: RefreshIndicator(
//           color: _C.darkGreen,
//           onRefresh: _refresh,
//           child: CustomScrollView(
//             controller: _sc,
//             physics: const AlwaysScrollableScrollPhysics(),
//             slivers: [
//               SliverPadding(
//                 padding: const EdgeInsets.fromLTRB(14, 12, 14, 90),
//                 sliver: SliverList(
//                   delegate: SliverChildListDelegate([
//                     // ── Greeting ──────────────────────────────────────────
//                     _Greeting(user: user, progress: progress)
//                         .animate()
//                         .fadeIn(duration: 280.ms),

//                     const SizedBox(height: 12),

//                     // ── Hero Card ─────────────────────────────────────────
//                     // Source: currentMonth (MonthlyTracker) + todayEntry (DailyEntry)
//                     // Shows: totalPoints, completionPercentage, daysCompleted,
//                     //        rank, isWinner, winnerCategory, todayEntry status,
//                     //        fardPoints, farzCompletedDays
//                     progress
//                         .when(
//                           loading: () => const _HeroSkeleton(),
//                           error: (_, __) => _HeroCard(
//                             summary: null,
//                             onTap: () {
//                               debugPrint(
//                                   'Before: ${GoRouter.of(context).routerDelegate.currentConfiguration.matches.map((e) => e.matchedLocation).toList()}');
//                               context.go(AppRoutes.tracker);
//                               debugPrint(
//                                   'After: ${GoRouter.of(context).routerDelegate.currentConfiguration.matches.map((e) => e.matchedLocation).toList()}');
//                             },
//                           ),
//                           data: (s) => _HeroCard(
//                               summary: s,
//                               onTap: () => context.go(AppRoutes.tracker)),
//                         )
//                         .animate()
//                         .fadeIn(delay: 50.ms, duration: 300.ms),

//                     const SizedBox(height: 10),

//                     // ── Weekly Chart ──────────────────────────────────────
//                     // Source: currentWeek (List<WeeklyBarData>)
//                     //   day, date, points, hasData, isExemptDay
//                     // Summary chips: weeklyPoints (ProgressSummary — week total)
//                     //   currentMonth.streakDays, currentMonth.farzCompletedDays
//                     progress
//                         .when(
//                           loading: () => const _WeekSkeleton(),
//                           error: (_, __) => const _WeekStrip(summary: null),
//                           data: (s) => _WeekStrip(summary: s),
//                         )
//                         .animate()
//                         .fadeIn(delay: 90.ms, duration: 280.ms),

//                     const SizedBox(height: 20),

//                     // ── Monthly progress ──────────────────────────────────
//                     _SecHead(
//                       title: 'মাসিক অগ্রগতি',
//                       emoji: '📊',
//                       onSeeAll: () => context.go(AppRoutes.monthlyView),
//                     ).animate().fadeIn(delay: 120.ms),
//                     const SizedBox(height: 8),
//                     progress
//                         .when(
//                           loading: () => const _ListSkeleton(),
//                           error: (_, __) =>
//                               const _EmptyCard(label: 'ডেটা লোড ব্যর্থ'),
//                           data: (s) => s.recentMonths.isEmpty
//                               ? const _EmptyCard(label: 'কোনো রেকর্ড নেই')
//                               : _MonthList(trackers: s.recentMonths),
//                         )
//                         .animate()
//                         .fadeIn(delay: 140.ms),

//                     const SizedBox(height: 20),

//                     // ── Leaderboard ───────────────────────────────────────
//                     _SecHead(
//                       title: 'শীর্ষ তালিকা',
//                       emoji: '🏆',
//                       onSeeAll: () => context.go(AppRoutes.leaderboard),
//                     ).animate().fadeIn(delay: 160.ms),
//                     const SizedBox(height: 8),
//                     (board.isLoading
//                             ? const _ListSkeleton()
//                             : board.entries.isEmpty
//                                 ? const _EmptyCard(label: 'ডেটা নেই')
//                                 : _LeaderList(
//                                     entries: board.entries.take(3).toList(),
//                                     currentUserId:
//                                         ref.read(currentUserProvider)?.id,
//                                   ))
//                         .animate()
//                         .fadeIn(delay: 180.ms),

//                     const SizedBox(height: 20),

//                     // ── Sadaqah Banner ────────────────────────────────────────
//                     SadaqahBanner().animate().fadeIn(delay: 190.ms),

//                     const SizedBox(height: 20),

//                     // ── How it works ──────────────────────────────────────
//                     _HowItWorks(onTap: () => context.push(AppRoutes.howItWorks))
//                         .animate()
//                         .fadeIn(delay: 200.ms),
//                   ]),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // TOP BAR
// // ─────────────────────────────────────────────────────────────────────────────

// class _TopBar extends StatelessWidget implements PreferredSizeWidget {
//   final dynamic user;
//   final VoidCallback onAvatarTap;
//   const _TopBar({this.user, required this.onAvatarTap});

//   @override
//   Size get preferredSize => const Size.fromHeight(54);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: _C.card,
//       child: SafeArea(
//         bottom: false,
//         child: SizedBox(
//           height: 54,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(children: [
//               Container(
//                 width: 30,
//                 height: 30,
//                 decoration: BoxDecoration(
//                     color: _C.darkGreen,
//                     borderRadius: BorderRadius.circular(8)),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.asset('assets/images/sabeq_logo.png',
//                       width: 30,
//                       height: 30,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) => const Icon(
//                           Icons.eco_rounded,
//                           color: Colors.white,
//                           size: 15)),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text('Sabeq',
//                         style: TextStyle(
//                             color: _C.textPri,
//                             fontWeight: FontWeight.w800,
//                             fontSize: 15,
//                             letterSpacing: -0.3)),
//                     Text('নেক আমলে এগিয়ে যাও',
//                         style: TextStyle(
//                             color: _C.textSec,
//                             fontSize: 9,
//                             fontWeight: FontWeight.w500,
//                             letterSpacing: 0.2)),
//                   ]),
//               const Spacer(),
//               const NotificationBellWidget(),
//               const SizedBox(width: 8),
//               const SettingsButtonWidget(),
//               const SizedBox(width: 8),
//               GestureDetector(
//                 onTap: onAvatarTap,
//                 child: Container(
//                   width: 35,
//                   height: 35,
//                   decoration: BoxDecoration(
//                       color: _C.darkGreen,
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Center(
//                       child: Text(
//                           (user?.name?.isNotEmpty == true)
//                               ? user!.name[0].toUpperCase()
//                               : 'U',
//                           style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w800,
//                               fontSize: 12))),
//                 ),
//               ),
//             ]),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // GREETING
// // ─────────────────────────────────────────────────────────────────────────────

// class _Greeting extends StatelessWidget {
//   final dynamic user;
//   final AsyncValue<ProgressSummary> progress;
//   const _Greeting({this.user, required this.progress});

//   @override
//   Widget build(BuildContext context) {
//     // streakDays from MonthlyTracker — backend computed
//     final streak =
//         progress.whenOrNull(data: (s) => s.currentMonth?.streakDays) ?? 0;

//     return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
//       Expanded(
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const Text('আস-সালামু আলাইকুম',
//             style: TextStyle(
//                 color: _C.textHint,
//                 fontSize: 10.5,
//                 fontWeight: FontWeight.w500)),
//         const SizedBox(height: 1),
//         Text(user?.name?.split(' ').first ?? 'বন্ধু',
//             style: const TextStyle(
//                 color: _C.textPri,
//                 fontWeight: FontWeight.w800,
//                 fontSize: 22,
//                 height: 1.1,
//                 letterSpacing: -0.5)),
//       ])),
//       if (streak > 0)
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//           decoration: BoxDecoration(
//             color: _C.goldLight,
//             borderRadius: BorderRadius.circular(99),
//             border: Border.all(color: _C.goldBorder, width: 0.5),
//           ),
//           child: Row(mainAxisSize: MainAxisSize.min, children: [
//             const Text('🔥', style: TextStyle(fontSize: 12)),
//             const SizedBox(width: 4),
//             Text('$streak দিন',
//                 style: const TextStyle(
//                     color: Color(0xFFE65100),
//                     fontSize: 12,
//                     fontWeight: FontWeight.w700)),
//           ]),
//         ),
//     ]);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // HERO CARD
// //
// // Left column  — today status + CTA
// // Right column — totalPoints (gold large) + rank chip
// //
// // Bottom band  — 3 mini-stat chips + fard progress bar
// //
// // All values from backend:
// //   todayEntry.totalPoints          → আজ কতো pts
// //   todayEntry.isExemptDay          → মাফের দিন (female)
// //   currentMonth.totalPoints        → মাসের pts
// //   currentMonth.completionPercentage → fard-based % (backend formula)
// //   currentMonth.daysCompleted      → সম্পন্ন দিন
// //   currentMonth.rank               → nullable
// //   currentMonth.isWinner           → bool
// //   currentMonth.winnerCategory     → 'TOP_FARZ'|'TOP_EFFORT'|'TOP_STREAK'
// //   currentMonth.farzCompletedDays  → পূর্ণ ফরজ দিন
// //   currentMonth.fardPoints         → ফরজ pts (tiebreak)
// //   currentMonth.streakDays         → streak
// //   userGender                      → female exempt badge
// // ─────────────────────────────────────────────────────────────────────────────

// class _HeroCard extends StatelessWidget {
//   final ProgressSummary? summary;
//   final VoidCallback onTap;
//   const _HeroCard({this.summary, required this.onTap});

//   String _winnerLabel(String? cat) {
//     switch (cat) {
//       case 'TOP_FARZ':
//         return 'ফরজ চ্যাম্পিয়ন';
//       case 'TOP_EFFORT':
//         return 'সর্বোচ্চ পয়েন্ট';
//       case 'TOP_STREAK':
//         return 'সেরা স্ট্রিক';
//       default:
//         return 'মাসিক বিজয়ী';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final today = summary?.todayEntry;
//     final month = summary?.currentMonth;
//     final isFemale = summary?.userGender == 'female';

//     final todayPts = today?.totalPoints ?? 0;
//     final isExempt = (today?.isExemptDay ?? false) && isFemale;
//     final hasToday = todayPts > 0 || isExempt;

//     final monthPts = month?.totalPoints ?? 0;
//     final pct = (month?.completionPercentage ?? 0).clamp(0.0, 100.0);
//     final daysComp = month?.daysCompleted ?? 0;
//     final rank = month?.rank;
//     final isWinner = month?.isWinner ?? false;
//     final farzDays = month?.farzCompletedDays ?? 0;
//     final eligDays = month?.eligibleDays ?? 0;
//     final fardPts = month?.fardPoints ?? 0;

//     final now = DateTime.now();
//     final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
//     final monthName = AppConstants.bengaliMonths[now.month - 1];

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: _C.darkGreen,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Stack(children: [
//           // decorative circles — smaller, less intrusive
//           Positioned(
//               top: -30,
//               right: -30,
//               child: Container(
//                   width: 90,
//                   height: 90,
//                   decoration: const BoxDecoration(
//                       shape: BoxShape.circle, color: Color(0x08FFFFFF)))),
//           Positioned(
//               bottom: -15,
//               left: -8,
//               child: Container(
//                   width: 60,
//                   height: 60,
//                   decoration: const BoxDecoration(
//                       shape: BoxShape.circle, color: Color(0x05FFFFFF)))),

//           Padding(
//             padding: const EdgeInsets.all(14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // ── Winner banner ─────────────────────────────────────
//                 if (isWinner) ...[
//                   Container(
//                     margin: const EdgeInsets.only(bottom: 8),
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: _C.gold.withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(6),
//                       border: Border.all(
//                           color: _C.gold.withOpacity(0.3), width: 0.5),
//                     ),
//                     child: Row(mainAxisSize: MainAxisSize.min, children: [
//                       const Text('🏆', style: TextStyle(fontSize: 10)),
//                       const SizedBox(width: 5),
//                       Text(_winnerLabel(month?.winnerCategory),
//                           style: const TextStyle(
//                               color: _C.gold,
//                               fontSize: 10,
//                               fontWeight: FontWeight.w700)),
//                     ]),
//                   ),
//                 ],

//                 // ── Main row: today left, month right ─────────────────
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // Left — today
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           // label
//                           Row(children: [
//                             Icon(Icons.wb_sunny_rounded,
//                                 size: 9, color: Colors.white.withOpacity(0.35)),
//                             const SizedBox(width: 3),
//                             Text(
//                               isExempt ? 'আজ মাফের দিন 🌙' : 'আজকের আমল',
//                               style: TextStyle(
//                                   color: Colors.white.withOpacity(0.4),
//                                   fontSize: 9.5,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                           ]),
//                           const SizedBox(height: 4),

//                           // value
//                           // value — এই অংশটা replace করো
//                           todayPts > 0
//                               ? RichText(
//                                   text: TextSpan(children: [
//                                     TextSpan(
//                                         text: '$todayPts',
//                                         style: const TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 26,
//                                             fontWeight: FontWeight.w900,
//                                             height: 1,
//                                             letterSpacing: -1)),
//                                     const TextSpan(
//                                         text: ' pts',
//                                         style: TextStyle(
//                                             color: Color(0x80FFFFFF),
//                                             fontSize: 11,
//                                             fontWeight: FontWeight.w500)),
//                                   ]),
//                                 )
//                               : isExempt
//                                   ? const Text('মাফের দিন',
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w800,
//                                           height: 1.1))
//                                   : const Text('এখনো রেকর্ড\nহয়নি',
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w800,
//                                           height: 1.2,
//                                           letterSpacing: -0.2)),
//                           // if (todayPts > 0)
//                           //   RichText(
//                           //     text: TextSpan(children: [
//                           //       TextSpan(
//                           //           text: '$todayPts',
//                           //           style: const TextStyle(
//                           //               color: Colors.white,
//                           //               fontSize: 26,
//                           //               fontWeight: FontWeight.w900,
//                           //               height: 1,
//                           //               letterSpacing: -1)),
//                           //       const TextSpan(
//                           //           text: ' pts',
//                           //           style: TextStyle(
//                           //               color: Color(0x80FFFFFF),
//                           //               fontSize: 11,
//                           //               fontWeight: FontWeight.w500)),
//                           //     ]),
//                           //   )
//                           // else if (isExempt)
//                           //   const Text('মাফের দিন',
//                           //       style: TextStyle(
//                           //           color: Colors.white,
//                           //           fontSize: 16,
//                           //           fontWeight: FontWeight.w800,
//                           //           height: 1.1))
//                           // else
//                           //   const Text('এখনো রেকর্ড\nহয়নি',
//                           //       style: TextStyle(
//                           //           color: Colors.white,
//                           //           fontSize: 15,
//                           //           fontWeight: FontWeight.w800,
//                           //           height: 1.2,
//                           //           letterSpacing: -0.2)),

//                           const SizedBox(height: 8),

//                           // CTA
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: hasToday
//                                   ? Colors.white.withOpacity(0.1)
//                                   : _C.gold,
//                               borderRadius: BorderRadius.circular(8),
//                               border: hasToday
//                                   ? Border.all(
//                                       color: Colors.white.withOpacity(0.18),
//                                       width: 0.5)
//                                   : null,
//                             ),
//                             child:
//                                 Row(mainAxisSize: MainAxisSize.min, children: [
//                               Icon(
//                                   hasToday
//                                       ? Icons.edit_rounded
//                                       : Icons.add_rounded,
//                                   color: Colors.white,
//                                   size: 11),
//                               const SizedBox(width: 4),
//                               Text(hasToday ? 'আপডেট করুন' : 'রেকর্ড করুন',
//                                   style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 10.5,
//                                       fontWeight: FontWeight.w700)),
//                             ]),
//                           ),
//                         ],
//                       ),
//                     ),

//                     // Divider
//                     Container(
//                       width: 0.5,
//                       height: 72,
//                       color: Colors.white.withOpacity(0.12),
//                       margin: const EdgeInsets.symmetric(horizontal: 12),
//                     ),

//                     // Right — month summary
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(_fmt(monthPts),
//                             style: TextStyle(
//                                 color: _C.gold,
//                                 fontSize: monthPts >= 10000 ? 20 : 24,
//                                 fontWeight: FontWeight.w800,
//                                 height: 1,
//                                 letterSpacing: -1)),
//                         const SizedBox(height: 2),
//                         Text('মাসের পয়েন্ট',
//                             style: TextStyle(
//                                 color: Colors.white.withOpacity(0.35),
//                                 fontSize: 8.5)),
//                         const SizedBox(height: 6),
//                         // rank + fard pts side by side
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             if (rank != null) ...[
//                               _RightChip(
//                                   top: '#$rank',
//                                   bottom: 'র‍্যাংক',
//                                   isRank: true),
//                               const SizedBox(width: 6),
//                             ],
//                             _RightChip(top: _fmt(fardPts), bottom: 'ফরজ pts'),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 10),

//                 // ── Divider ───────────────────────────────────────────
//                 const Divider(
//                     height: 1, thickness: 0.5, color: Color(0x1AFFFFFF)),

//                 const SizedBox(height: 8),

//                 // ── Bottom row: 3 stats + progress bar ────────────────
//                 Row(children: [
//                   // 3 mini stats
//                   _HeroChip(
//                       value: '$daysComp/$daysInMonth', label: 'সম্পন্ন দিন'),
//                   _heroDivider(),
//                   _HeroChip(
//                       value: '$farzDays${eligDays > 0 ? '/$eligDays' : ''}',
//                       label: 'পূর্ণ ফরজ'),
//                   _heroDivider(),
//                   // progress bar inline
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Text(monthName,
//                                 style: TextStyle(
//                                     color: Colors.white.withOpacity(0.35),
//                                     fontSize: 8.5)),
//                             const SizedBox(width: 4),
//                             Text('${pct.toInt()}%',
//                                 style: const TextStyle(
//                                     color: _C.gold,
//                                     fontSize: 9.5,
//                                     fontWeight: FontWeight.w700)),
//                           ],
//                         ),
//                         const SizedBox(height: 3),
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(99),
//                           child: LinearProgressIndicator(
//                               value: pct / 100,
//                               minHeight: 3.5,
//                               backgroundColor: Colors.white.withOpacity(0.1),
//                               valueColor:
//                                   const AlwaysStoppedAnimation(_C.gold)),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ]),
//               ],
//             ),
//           ),
//         ]),
//       ),
//     );
//   }

//   static Widget _heroDivider() => Container(
//       width: 1,
//       height: 12,
//       color: Colors.white.withOpacity(0.12),
//       margin: const EdgeInsets.symmetric(horizontal: 10));
// }

// class _RightChip extends StatelessWidget {
//   final String top, bottom;
//   final bool isRank;
//   const _RightChip(
//       {required this.top, required this.bottom, this.isRank = false});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: const BoxConstraints(minWidth: 51),
//       padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
//       decoration: BoxDecoration(
//         color: isRank
//             ? const Color(0xFF4ADE80).withOpacity(0.12)
//             : Colors.white.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(7),
//         border: Border.all(
//             color: isRank
//                 ? const Color(0xFF4ADE80).withOpacity(0.25)
//                 : Colors.white.withOpacity(0.1),
//             width: 0.5),
//       ),
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         Text(top,
//             style: TextStyle(
//                 color: isRank ? const Color(0xFF4ADE80) : _C.gold,
//                 fontSize: 11,
//                 fontWeight: FontWeight.w700,
//                 height: 1)),
//         const SizedBox(height: 2),
//         Text(bottom,
//             style:
//                 TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 8)),
//       ]),
//     );
//   }
// }

// class _HeroChip extends StatelessWidget {
//   final String value, label;
//   const _HeroChip({required this.value, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(value,
//               style: const TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.white,
//                   height: 1)),
//           const SizedBox(height: 2),
//           Text(label,
//               style: TextStyle(
//                   fontSize: 8.5, color: Colors.white.withOpacity(0.35))),
//         ]);
//   }
// }

// class _HeroSkeleton extends StatelessWidget {
//   const _HeroSkeleton();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 160,
//       decoration: BoxDecoration(
//           color: _C.darkGreen.withOpacity(0.7),
//           borderRadius: BorderRadius.circular(16)),
//     ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1400.ms, colors: [
//       Colors.white.withOpacity(0.03),
//       Colors.white.withOpacity(0.08),
//       Colors.white.withOpacity(0.03)
//     ]);
//   }
// }

// //

// Color _weekBarColor(double fillFrac) {
//   if (fillFrac >= 0.7) return _C.midGreen; // 70%+ → green
//   if (fillFrac >= 0.4) return const Color(0xFFFFA726); // 40–69% → amber
//   return const Color(0xFFE57373); // <40% → red
// }

// class _WeekStrip extends StatelessWidget {
//   final ProgressSummary? summary;
//   const _WeekStrip({this.summary});

//   static const _bnDay = {
//     'Sun': 'র',
//     'Mon': 'সো',
//     'Tue': 'ম',
//     'Wed': 'বু',
//     'Thu': 'বৃ',
//     'Fri': 'শু',
//     'Sat': 'শ',
//   };

//   @override
//   Widget build(BuildContext context) {
//     final weekData = summary?.currentWeek ?? [];
//     final weekTotal = summary?.weeklyPoints ?? 0;
//     final isFemale = summary?.userGender == 'female';

//     final today = DateTime.now();
//     final maxPts =
//         weekData.map((d) => d.points).fold(0, (a, b) => a > b ? a : b);
//     final safePts = (maxPts < 1 ? 1 : maxPts).toDouble();

//     return Container(
//       padding: const EdgeInsets.fromLTRB(13, 10, 13, 10),
//       decoration: BoxDecoration(
//           color: _C.card,
//           borderRadius: BorderRadius.circular(13),
//           border: Border.all(color: _C.border, width: 0.5)),
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         // Header
//         Row(children: [
//           const Text('এই সপ্তাহ',
//               style: TextStyle(
//                   color: _C.textPri,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 11)),
//           const Spacer(),
//           if (weekTotal > 0) ...[
//             Text('$weekTotal',
//                 style: const TextStyle(
//                     color: _C.green,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 11)),
//             const Text(' pts',
//                 style: TextStyle(
//                     color: _C.textHint,
//                     fontSize: 10,
//                     fontWeight: FontWeight.w500)),
//           ],
//         ]),

//         const SizedBox(height: 8),

//         if (weekData.isEmpty)
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 4),
//             child: Row(
//               children: List.generate(
//                   7,
//                   (i) => Expanded(
//                           child: Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 2),
//                         height: 28,
//                         decoration: BoxDecoration(
//                             color: _C.pageBg,
//                             borderRadius: BorderRadius.circular(4),
//                             border: Border.all(color: _C.border, width: 0.5)),
//                       ))),
//             ),
//           )
//         else
//           LayoutBuilder(builder: (ctx, constraints) {
//             final barAreaH = (constraints.maxWidth * 0.26).clamp(28.0, 52.0);
//             const dayLblH = 12.0;
//             const ptsLblH = 12.0;
//             const gap = 2.0;
//             final totalH = ptsLblH + gap + barAreaH + gap + dayLblH;

//             return SizedBox(
//               height: totalH,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: weekData.map((d) {
//                   final dayDate = DateTime.tryParse(d.date);
//                   final isToday = dayDate != null &&
//                       dayDate.year == today.year &&
//                       dayDate.month == today.month &&
//                       dayDate.day == today.day;
//                   final isFuture = dayDate != null && dayDate.isAfter(today);
//                   final showExempt = d.isExemptDay && isFemale;

//                   // safe fillFrac — NaN/infinity থেকে বাঁচাতে explicit double cast
//                   final pts = d.points.toDouble();
//                   final fillFrac =
//                       pts > 0 ? (pts / safePts).clamp(0.0, 1.0) : 0.0;
//                   final barH = fillFrac > 0
//                       ? (fillFrac * barAreaH).clamp(4.0, barAreaH)
//                       : 0.0;

//                   // opacity: 0.4 → 1.0 based on fillFrac, always valid range
//                   final op = fillFrac > 0
//                       ? (0.4 + fillFrac * 0.6).clamp(0.0, 1.0)
//                       : 0.4;

//                   return Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 2),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           // pts label — bar এর উপরে
//                           SizedBox(
//                             height: ptsLblH,
//                             child: Center(
//                               child: d.points > 0
//                                   ? FittedBox(
//                                       fit: BoxFit.scaleDown,
//                                       child: Text(
//                                         '${d.points}',
//                                         style: TextStyle(
//                                           fontSize: 7.5,
//                                           color: isToday
//                                               ? _C.darkGreen
//                                               : _weekBarColor(fillFrac),
//                                           // color: isToday
//                                           //     ? _C.darkGreen
//                                           //     : _C.textHint,
//                                           fontWeight: isToday
//                                               ? FontWeight.w800
//                                               : FontWeight.w600,
//                                         ),
//                                       ),
//                                     )
//                                   : const SizedBox.shrink(),
//                             ),
//                           ),

//                           const SizedBox(height: gap),

//                           // bar — bottom aligned
//                           SizedBox(
//                             height: barAreaH,
//                             child: Align(
//                               alignment: Alignment.bottomCenter,
//                               child: showExempt
//                                   ? Container(
//                                       height: (barAreaH * 0.6)
//                                           .clamp(16.0, barAreaH),
//                                       width: double.infinity,
//                                       decoration: BoxDecoration(
//                                         color: const Color(0xFFEDE9FE),
//                                         borderRadius: BorderRadius.circular(5),
//                                       ),
//                                       child: const Center(
//                                           child: Text('🌙',
//                                               style: TextStyle(fontSize: 7))),
//                                     )
//                                   : barH > 0
//                                       ? Container(
//                                           height: barH,
//                                           width: double.infinity,
//                                           decoration: BoxDecoration(
//                                             gradient: LinearGradient(
//                                               begin: Alignment.bottomCenter,
//                                               end: Alignment.topCenter,
//                                               colors: isToday
//                                                   ? [_C.darkGreen, _C.midGreen]
//                                                   : [
//                                                       _weekBarColor(fillFrac)
//                                                           .withOpacity(0.6),
//                                                       _weekBarColor(fillFrac),
//                                                     ],
//                                               // colors: isToday
//                                               //     ? [
//                                               //         _C.darkGreen,
//                                               //         _C.midGreen,
//                                               //       ]
//                                               //     : [
//                                               //         _C.midGreen.withOpacity(
//                                               //             op * 0.7),
//                                               //         _C.midGreen
//                                               //             .withOpacity(op),
//                                               //       ],
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(5),
//                                             boxShadow: isToday
//                                                 ? [
//                                                     BoxShadow(
//                                                       color: _C.darkGreen
//                                                           .withOpacity(0.3),
//                                                       blurRadius: 5,
//                                                       offset:
//                                                           const Offset(0, 2),
//                                                     )
//                                                   ]
//                                                 : null,
//                                           ),
//                                         )
//                                       : Container(
//                                           height: 3,
//                                           width: double.infinity,
//                                           decoration: BoxDecoration(
//                                             color: _C.pageBg,
//                                             borderRadius:
//                                                 BorderRadius.circular(2),
//                                             border: Border.all(
//                                                 color: _C.border, width: 0.5),
//                                           ),
//                                         ),
//                               //  Container(
//                               //     height: 3,
//                               //     width: double.infinity,
//                               //     decoration: BoxDecoration(
//                               //       color: isFuture
//                               //           ? Colors.transparent
//                               //           : _C.pageBg,
//                               //       borderRadius:
//                               //           BorderRadius.circular(2),
//                               //       border: Border.all(
//                               //           color: isFuture
//                               //               ? Colors.transparent
//                               //               : _C.border,
//                               //           width: 0.5),
//                               //     ),
//                               //   ),
//                             ),
//                           ),

//                           const SizedBox(height: gap),

//                           // day label
//                           SizedBox(
//                             height: dayLblH,
//                             child: Center(
//                               child: Text(
//                                 _bnDay[d.day] ?? d.day,
//                                 style: TextStyle(
//                                   fontSize: 8.5,
//                                   color: isToday ? _C.darkGreen : _C.textHint,
//                                   fontWeight: isToday
//                                       ? FontWeight.w800
//                                       : FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             );
//           }),
//       ]),
//     );
//   }
// }

// class _WeekSkeleton extends StatelessWidget {
//   const _WeekSkeleton();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 140,
//       decoration: BoxDecoration(
//           color: _C.card,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: _C.border, width: 0.5)),
//     ).animate(onPlay: (c) => c.repeat()).shimmer(
//         duration: 1200.ms, colors: [_C.card, const Color(0xFFE8ECE8), _C.card]);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION HEADER
// // ─────────────────────────────────────────────────────────────────────────────

// class _SecHead extends StatelessWidget {
//   final String title, emoji;
//   final VoidCallback onSeeAll;
//   const _SecHead(
//       {required this.title, required this.emoji, required this.onSeeAll});

//   @override
//   Widget build(BuildContext context) {
//     return Row(children: [
//       Text(emoji, style: const TextStyle(fontSize: 13)),
//       const SizedBox(width: 6),
//       Text(title,
//           style: const TextStyle(
//               color: _C.textPri,
//               fontWeight: FontWeight.w800,
//               fontSize: 13,
//               letterSpacing: -0.1)),
//       const Spacer(),
//       GestureDetector(
//         onTap: onSeeAll,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//           decoration: BoxDecoration(
//               color: _C.greenLight, borderRadius: BorderRadius.circular(99)),
//           child: const Text('সব দেখুন →',
//               style: TextStyle(
//                   color: _C.darkGreen,
//                   fontSize: 10,
//                   fontWeight: FontWeight.w700)),
//         ),
//       ),
//     ]);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // MONTHLY LIST
// // Source: ProgressSummary.recentMonths — List<MonthlyTracker>
// // Each MonthlyTracker: month, totalPoints, completionPercentage, isWinner,
// //                      farzCompletedDays, fardPoints (shown as sub-info)
// // ─────────────────────────────────────────────────────────────────────────────

// class _MonthList extends StatelessWidget {
//   final List<MonthlyTracker> trackers;
//   const _MonthList({required this.trackers});

//   @override
//   Widget build(BuildContext context) {
//     final items = trackers.take(3).toList();

//     return Container(
//       decoration: BoxDecoration(
//           color: _C.card,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: _C.border, width: 0.5)),
//       child: Column(
//         children: List.generate(items.length, (i) {
//           final t = items[i];
//           final month = AppConstants.bengaliMonths[t.month - 1];
//           final pct = (t.completionPercentage / 100).clamp(0.0, 1.0);
//           final barColor = pct > 0.7
//               ? _C.green
//               : pct > 0.4
//                   ? _C.amber
//                   : _C.red;
//           final isLast = i == items.length - 1;

//           return Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             decoration: BoxDecoration(
//                 border: isLast
//                     ? null
//                     : const Border(
//                         bottom: BorderSide(color: _C.border, width: 0.5))),
//             child: Row(children: [
//               // Color dot
//               Container(
//                   width: 7,
//                   height: 7,
//                   decoration:
//                       BoxDecoration(color: barColor, shape: BoxShape.circle)),
//               const SizedBox(width: 10),

//               // Month name + winner badge
//               SizedBox(
//                   width: 46,
//                   child: Row(children: [
//                     Flexible(
//                         child: Text(month,
//                             style: const TextStyle(
//                                 color: _C.textPri,
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 12),
//                             overflow: TextOverflow.ellipsis)),
//                     if (t.isWinner) ...[
//                       const SizedBox(width: 3),
//                       const Text('🏆', style: TextStyle(fontSize: 9))
//                     ],
//                   ])),
//               const SizedBox(width: 8),

//               // Progress bar + %
//               Expanded(
//                   child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                     Text('${(pct * 100).toInt()}%',
//                         style: const TextStyle(
//                             color: _C.textHint,
//                             fontSize: 9,
//                             fontWeight: FontWeight.w500)),
//                     const SizedBox(width: 3),
//                     Expanded(
//                         child: ClipRRect(
//                             borderRadius: BorderRadius.circular(99),
//                             child: LinearProgressIndicator(
//                                 value: pct,
//                                 minHeight: 3,
//                                 backgroundColor: _C.pageBg,
//                                 valueColor: AlwaysStoppedAnimation(barColor)))),
//                   ])),
//               const SizedBox(width: 10),

//               // Points
//               Row(children: [
//                 Text(_fmt(t.totalPoints),
//                     style: TextStyle(
//                         color: barColor,
//                         fontWeight: FontWeight.w800,
//                         fontSize: 13)),
//                 const SizedBox(width: 2),
//                 Text('pts',
//                     style: TextStyle(
//                         color: barColor.withOpacity(0.55),
//                         fontSize: 9,
//                         fontWeight: FontWeight.w600)),
//               ]),
//             ]),
//           ).animate().fadeIn(delay: Duration(milliseconds: i * 50));
//         }),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // LEADERBOARD LIST
// // ─────────────────────────────────────────────────────────────────────────────

// class _LeaderList extends StatelessWidget {
//   final List entries;
//   final String? currentUserId;
//   const _LeaderList({required this.entries, this.currentUserId});

//   static const _emojis = ['🥇', '🥈', '🥉'];
//   static const _rankColors = [_C.rankGold, _C.rankSilver, _C.rankBronze];
//   static const _rowBg = [
//     Color(0xFFFFFBF0),
//     Color(0xFFF8FAFC),
//     Color(0xFFFFF7ED)
//   ];
//   static const _avatarBg = [
//     Color(0xFF0E3D22),
//     Color(0xFF374151),
//     Color(0xFF7C3AED)
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           color: _C.card,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: _C.border, width: 0.5)),
//       child: Column(
//         children: List.generate(entries.length, (i) {
//           final e = entries[i];
//           final isLast = i == entries.length - 1;
//           final isMe =
//               currentUserId != null && e.userId?.toString() == currentUserId;

//           return Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
//             decoration: BoxDecoration(
//               color: _rowBg[i],
//               borderRadius: BorderRadius.vertical(
//                   top: i == 0 ? const Radius.circular(14) : Radius.zero,
//                   bottom: isLast ? const Radius.circular(14) : Radius.zero),
//               border: isLast
//                   ? null
//                   : const Border(
//                       bottom: BorderSide(color: _C.border, width: 0.5)),
//             ),
//             child: Row(children: [
//               // Rank emoji
//               SizedBox(
//                   width: 22,
//                   child: Text(_emojis[i],
//                       style: const TextStyle(fontSize: 16),
//                       textAlign: TextAlign.center)),
//               const SizedBox(width: 8),

//               // Avatar
//               Container(
//                   width: 30,
//                   height: 30,
//                   decoration: BoxDecoration(
//                       color: _avatarBg[i],
//                       borderRadius: BorderRadius.circular(8)),
//                   child: Center(
//                       child: Text(
//                           (e.name?.isNotEmpty == true)
//                               ? e.name[0].toUpperCase()
//                               : 'U',
//                           style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w800,
//                               fontSize: 12)))),
//               const SizedBox(width: 8),

//               // Name + meta
//               Expanded(
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                     Row(children: [
//                       Flexible(
//                           child: Text(e.name?.split(' ').first ?? '',
//                               style: const TextStyle(
//                                   color: _C.textPri,
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 12),
//                               overflow: TextOverflow.ellipsis)),
//                       if (isMe) ...[
//                         const SizedBox(width: 4),
//                         Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 5, vertical: 1),
//                             decoration: BoxDecoration(
//                                 color: _C.greenLight,
//                                 borderRadius: BorderRadius.circular(99)),
//                             child: const Text('আপনি',
//                                 style: TextStyle(
//                                     color: _C.darkGreen,
//                                     fontSize: 8.5,
//                                     fontWeight: FontWeight.w700))),
//                       ],
//                     ]),
//                     if (e.id != null || e.district != null)
//                       Text('ID: ${e.id ?? ''} · ${e.district ?? ''}',
//                           style:
//                               const TextStyle(color: _C.textSec, fontSize: 9),
//                           overflow: TextOverflow.ellipsis),
//                   ])),

//               // Points badge
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 decoration: BoxDecoration(
//                     color: _rankColors[i].withOpacity(0.12),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Column(children: [
//                   Text('${e.totalPoints}',
//                       style: TextStyle(
//                           color: _rankColors[i],
//                           fontWeight: FontWeight.w900,
//                           fontSize: 13,
//                           height: 1)),
//                   Text('pts',
//                       style: TextStyle(
//                           color: _rankColors[i].withOpacity(0.55),
//                           fontSize: 7,
//                           fontWeight: FontWeight.w600)),
//                 ]),
//               ),
//             ]),
//           ).animate().fadeIn(delay: Duration(milliseconds: i * 50));
//         }),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // HOW IT WORKS
// // ─────────────────────────────────────────────────────────────────────────────

// class _HowItWorks extends StatelessWidget {
//   final VoidCallback onTap;
//   const _HowItWorks({required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         decoration: BoxDecoration(
//             color: _C.card,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: _C.border, width: 0.5)),
//         child: Row(children: [
//           Container(
//               width: 34,
//               height: 34,
//               decoration: BoxDecoration(
//                   color: _C.greenLight,
//                   borderRadius: BorderRadius.circular(10)),
//               child: const Icon(Icons.help_outline_rounded,
//                   color: _C.darkGreen, size: 18)),
//           const SizedBox(width: 10),
//           const Expanded(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                 Text('এটি কীভাবে কাজ করে?',
//                     style: TextStyle(
//                         color: _C.textPri,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 12)),
//                 SizedBox(height: 1),
//                 Text('পয়েন্ট, র‍্যাংকিং ও আমল সম্পর্কে জানুন',
//                     style: TextStyle(color: _C.textSec, fontSize: 10.5)),
//               ])),
//           const Icon(Icons.chevron_right_rounded, color: _C.textHint, size: 18),
//         ]),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SHARED SKELETON + EMPTY
// // ─────────────────────────────────────────────────────────────────────────────

// class _ListSkeleton extends StatelessWidget {
//   const _ListSkeleton();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 120,
//       decoration: BoxDecoration(
//           color: _C.card,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: _C.border, width: 0.5)),
//     ).animate(onPlay: (c) => c.repeat()).shimmer(
//         duration: 1200.ms, colors: [_C.card, const Color(0xFFE8ECE8), _C.card]);
//   }
// }

// class _EmptyCard extends StatelessWidget {
//   final String label;
//   const _EmptyCard({required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         height: 80,
//         decoration: BoxDecoration(
//             color: _C.card,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: _C.border, width: 0.5)),
//         child: Center(
//             child: Text(label,
//                 style: const TextStyle(
//                     color: _C.textHint,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500))));
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PUBLIC ALIAS (kept for compatibility)
// // ─────────────────────────────────────────────────────────────────────────────

// class SectionHeaderCompact extends StatelessWidget {
//   final String title, action;
//   final VoidCallback onAction;
//   const SectionHeaderCompact(
//       {required this.title,
//       required this.action,
//       required this.onAction,
//       super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//       Text(title,
//           style: const TextStyle(
//               color: _C.textPri, fontWeight: FontWeight.w700, fontSize: 11)),
//       GestureDetector(
//           onTap: onAction,
//           child: Text(action,
//               style: const TextStyle(
//                   color: _C.darkGreen,
//                   fontSize: 10,
//                   fontWeight: FontWeight.w600))),
//     ]);
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// // import 'package:share_plus/share_plus.dart';
// // import 'package:in_app_review/in_app_review.dart';
// // import 'package:url_launcher/url_launcher.dart';

// import '../../auth/providers/auth_provider.dart';
// import '../../tracker/providers/tracker_provider.dart';
// import '../../tracker/models/tracker_model.dart';
// import '../../leaderboard/providers/leaderboard_provider.dart';
// import '../../../core/router/app_router.dart';
// import '../../../core/constants/app_constants.dart';
// import '../../notification/widgets/notification_widgets.dart';
// import '../../home/widgets/profile_sheet.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // DESIGN TOKENS
// // ─────────────────────────────────────────────────────────────────────────────

// class _C {
//   static const pageBg = Color(0xFFF4F6F1);
//   static const card = Color(0xFFFFFFFF);
//   static const darkGreen = Color(0xFF0E3D22);
//   static const midGreen = Color(0xFF1B7045);
//   static const gold = Color(0xFFD4A843);
//   static const goldLight = Color(0xFFFFF3E0);
//   static const goldBorder = Color(0xFFFFCC80);
//   static const goldLight2 = Color(0xFFFFF8E7);
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const amber = Color(0xFFF59E0B);
//   static const amberLight = Color(0xFFFFF7ED);
//   static const purple = Color(0xFF7C3AED);
//   static const purpleLight = Color(0xFFEDE9FE);
//   static const purplePale = Color(0xFFF3F0FF);
//   static const red = Color(0xFFEF4444);
//   static const redLight = Color(0xFFFEE2E2);
//   static const textPri = Color(0xFF0A1A0F);
//   static const textSec = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
//   static const border = Color(0xFFE4EAE4);
//   static const rankGold = Color(0xFFD4A843);
//   static const rankSilver = Color(0xFF94A3B8);
//   static const rankBronze = Color(0xFFCD7F32);
// }

// String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}K' : '$n';

// // ─────────────────────────────────────────────────────────────────────────────
// // HOME SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   final _sc = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _loadLeaderboard());
//   }

//   void _loadLeaderboard() {
//     final now = DateTime.now();
//     final user = ref.read(currentUserProvider);
//     ref.read(leaderboardPreviewProvider.notifier).load(
//           LeaderboardFilter(
//             year: now.year,
//             month: now.month,
//             limit: 3,
//             gender: user?.gender,
//           ),
//           refresh: true,
//         );
//   }

//   @override
//   void dispose() {
//     _sc.dispose();
//     super.dispose();
//   }

//   Future<void> _refresh() async {
//     final now = DateTime.now();
//     ref.invalidate(progressSummaryProvider((year: now.year, month: now.month)));
//     await ref.read(leaderboardPreviewProvider.notifier).load(
//           LeaderboardFilter(year: now.year, month: now.month, limit: 3),
//           refresh: true,
//         );
//   }

//   void _showProfile() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) => ProfileSheet(user: ref.read(currentUserProvider)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = ref.watch(currentUserProvider);
//     final now = DateTime.now();
//     final progress =
//         ref.watch(progressSummaryProvider((year: now.year, month: now.month)));
//     final board = ref.watch(leaderboardPreviewProvider);

//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.dark,
//       child: Scaffold(
//         backgroundColor: _C.pageBg,
//         appBar: _TopBar(user: user, onAvatarTap: _showProfile),
//         body: RefreshIndicator(
//           color: _C.darkGreen,
//           onRefresh: _refresh,
//           child: CustomScrollView(
//             controller: _sc,
//             physics: const AlwaysScrollableScrollPhysics(),
//             slivers: [
//               SliverPadding(
//                 padding: const EdgeInsets.fromLTRB(14, 12, 14, 90),
//                 sliver: SliverList(
//                   delegate: SliverChildListDelegate([
//                     // ── Greeting ─────────────────────────────────────────
//                     _Greeting(user: user, progress: progress)
//                         .animate()
//                         .fadeIn(duration: 280.ms),

//                     const SizedBox(height: 12),

//                     // ── Hero Card ─────────────────────────────────────────
//                     progress
//                         .when(
//                           loading: () => const _HeroSkeleton(),
//                           error: (_, __) => _HeroCard(
//                               summary: null,
//                               onTap: () => context.go(AppRoutes.tracker)),
//                           data: (s) => _HeroCard(
//                               summary: s,
//                               onTap: () => context.go(AppRoutes.tracker)),
//                         )
//                         .animate()
//                         .fadeIn(delay: 50.ms, duration: 300.ms),

//                     const SizedBox(height: 10),

//                     // ── Weekly Chart ──────────────────────────────────────
//                     progress
//                         .when(
//                           loading: () => const _WeekSkeleton(),
//                           error: (_, __) => const _WeekStrip(summary: null),
//                           data: (s) => _WeekStrip(summary: s),
//                         )
//                         .animate()
//                         .fadeIn(delay: 90.ms, duration: 280.ms),

//                     const SizedBox(height: 20),

//                     // ── Quick Actions Grid (2×2) ───────────────────────────
//                     // Horizontal feel — 4 shortcuts in a 2×2 tile grid
//                     _QuickActions(
//                       onTracker: () => context.go(AppRoutes.tracker),
//                       onLeaderboard: () => context.go(AppRoutes.leaderboard),
//                       onMonthly: () => context.go(AppRoutes.monthlyView),
//                       onSadaqah: () => context.push(AppRoutes.sadaqah),
//                     ).animate().fadeIn(delay: 110.ms),

//                     const SizedBox(height: 20),

//                     // ── Monthly Progress — HORIZONTAL SCROLL ──────────────
//                     _SecHead(
//                       title: 'মাসিক অগ্রগতি',
//                       emoji: '📊',
//                       onSeeAll: () => context.go(AppRoutes.monthlyView),
//                     ).animate().fadeIn(delay: 130.ms),
//                     const SizedBox(height: 10),
//                     progress
//                         .when(
//                           loading: () => const _HScrollSkeleton(),
//                           error: (_, __) =>
//                               const _EmptyCard(label: 'ডেটা লোড ব্যর্থ'),
//                           data: (s) => s.recentMonths.isEmpty
//                               ? const _EmptyCard(label: 'কোনো রেকর্ড নেই')
//                               : _MonthScrollRow(trackers: s.recentMonths),
//                         )
//                         .animate()
//                         .fadeIn(delay: 145.ms),

//                     const SizedBox(height: 20),

//                     // ── Leaderboard ───────────────────────────────────────
//                     _SecHead(
//                       title: 'শীর্ষ তালিকা',
//                       emoji: '🏆',
//                       onSeeAll: () => context.go(AppRoutes.leaderboard),
//                     ).animate().fadeIn(delay: 160.ms),
//                     const SizedBox(height: 10),
//                     (board.isLoading
//                             ? const _ListSkeleton()
//                             : board.entries.isEmpty
//                                 ? const _EmptyCard(label: 'ডেটা নেই')
//                                 : _LeaderList(
//                                     entries: board.entries.take(3).toList(),
//                                     currentUserId:
//                                         ref.read(currentUserProvider)?.id,
//                                   ))
//                         .animate()
//                         .fadeIn(delay: 175.ms),

//                     const SizedBox(height: 20),

//                     // ── Community Row — Rate + Share (HORIZONTAL 2-col) ───
//                     _CommunityRow(
//                       onRate: _handleRateApp,
//                       onShare: _handleShareApp,
//                     ).animate().fadeIn(delay: 190.ms),

//                     const SizedBox(height: 20),

//                     // ── How it works ──────────────────────────────────────
//                     _HowItWorks(onTap: () => context.push(AppRoutes.howItWorks))
//                         .animate()
//                         .fadeIn(delay: 200.ms),
//                   ]),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ── Rate App ───────────────────────────────────────────────────────────────
//   Future<void> _handleRateApp() async {
//     // // final review = InAppReview.instance;
//     // if (await review.isAvailable()) {
//     //   await review.requestReview();
//     // } else {
//     //   // fallback → Play Store page
//     //   final uri = Uri.parse(
//     //     'https://play.google.com/store/apps/details?id=com.yourcompany.sabeq',
//     //   );
//     //   // if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
//     // }
//   }

//   // ── Share App ──────────────────────────────────────────────────────────────
//   Future<void> _handleShareApp() async {
//     // await Share.share(
//     //   'Sabeq — নেক আমল ট্র্যাক করুন, র‍্যাংকিং এ এগিয়ে যান!\n\n'
//     //   '📲 ডাউনলোড করুন:\n'
//     //   'https://play.google.com/store/apps/details?id=com.yourcompany.sabeq',
//     //   subject: 'Sabeq অ্যাপ — নেক আমলে এগিয়ে যাও',
//     // );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // TOP BAR
// // ─────────────────────────────────────────────────────────────────────────────

// class _TopBar extends StatelessWidget implements PreferredSizeWidget {
//   final dynamic user;
//   final VoidCallback onAvatarTap;
//   const _TopBar({this.user, required this.onAvatarTap});

//   @override
//   Size get preferredSize => const Size.fromHeight(54);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: _C.card,
//       child: SafeArea(
//         bottom: false,
//         child: SizedBox(
//           height: 54,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(children: [
//               Container(
//                 width: 30,
//                 height: 30,
//                 decoration: BoxDecoration(
//                     color: _C.darkGreen,
//                     borderRadius: BorderRadius.circular(8)),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.asset(
//                     'assets/images/sabeq_logo.png',
//                     width: 30,
//                     height: 30,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => const Icon(Icons.eco_rounded,
//                         color: Colors.white, size: 15),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text('Sabeq',
//                         style: TextStyle(
//                             color: _C.textPri,
//                             fontWeight: FontWeight.w800,
//                             fontSize: 15,
//                             letterSpacing: -0.3)),
//                     Text('নেক আমলে এগিয়ে যাও',
//                         style: TextStyle(
//                             color: _C.textSec,
//                             fontSize: 9,
//                             fontWeight: FontWeight.w500,
//                             letterSpacing: 0.2)),
//                   ]),
//               const Spacer(),
//               const NotificationBellWidget(),
//               const SizedBox(width: 8),
//               const SettingsButtonWidget(),
//               const SizedBox(width: 8),
//               GestureDetector(
//                 onTap: onAvatarTap,
//                 child: Container(
//                   width: 35,
//                   height: 35,
//                   decoration: BoxDecoration(
//                       color: _C.darkGreen,
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Center(
//                     child: Text(
//                       (user?.name?.isNotEmpty == true)
//                           ? user!.name[0].toUpperCase()
//                           : 'U',
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w800,
//                           fontSize: 12),
//                     ),
//                   ),
//                 ),
//               ),
//             ]),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // GREETING
// // ─────────────────────────────────────────────────────────────────────────────

// class _Greeting extends StatelessWidget {
//   final dynamic user;
//   final AsyncValue<ProgressSummary> progress;
//   const _Greeting({this.user, required this.progress});

//   @override
//   Widget build(BuildContext context) {
//     final streak =
//         progress.whenOrNull(data: (s) => s.currentMonth?.streakDays) ?? 0;
//     return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
//       Expanded(
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const Text('আস-সালামু আলাইকুম',
//             style: TextStyle(
//                 color: _C.textHint,
//                 fontSize: 10.5,
//                 fontWeight: FontWeight.w500)),
//         const SizedBox(height: 1),
//         Text(
//           user?.name?.split(' ').first ?? 'বন্ধু',
//           style: const TextStyle(
//               color: _C.textPri,
//               fontWeight: FontWeight.w800,
//               fontSize: 22,
//               height: 1.1,
//               letterSpacing: -0.5),
//         ),
//       ])),
//       if (streak > 0)
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//           decoration: BoxDecoration(
//             color: _C.goldLight,
//             borderRadius: BorderRadius.circular(99),
//             border: Border.all(color: _C.goldBorder, width: 0.5),
//           ),
//           child: Row(mainAxisSize: MainAxisSize.min, children: [
//             const Text('🔥', style: TextStyle(fontSize: 12)),
//             const SizedBox(width: 4),
//             Text('$streak দিন',
//                 style: const TextStyle(
//                     color: Color(0xFFE65100),
//                     fontSize: 12,
//                     fontWeight: FontWeight.w700)),
//           ]),
//         ),
//     ]);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // HERO CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _HeroCard extends StatelessWidget {
//   final ProgressSummary? summary;
//   final VoidCallback onTap;
//   const _HeroCard({this.summary, required this.onTap});

//   String _winnerLabel(String? cat) {
//     switch (cat) {
//       case 'TOP_FARZ':
//         return 'ফরজ চ্যাম্পিয়ন';
//       case 'TOP_EFFORT':
//         return 'সর্বোচ্চ পয়েন্ট';
//       case 'TOP_STREAK':
//         return 'সেরা স্ট্রিক';
//       default:
//         return 'মাসিক বিজয়ী';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final today = summary?.todayEntry;
//     final month = summary?.currentMonth;
//     final isFemale = summary?.userGender == 'female';

//     final todayPts = today?.totalPoints ?? 0;
//     final isExempt = (today?.isExemptDay ?? false) && isFemale;
//     final hasToday = todayPts > 0 || isExempt;

//     final monthPts = month?.totalPoints ?? 0;
//     final pct = (month?.completionPercentage ?? 0).clamp(0.0, 100.0);
//     final daysComp = month?.daysCompleted ?? 0;
//     final rank = month?.rank;
//     final isWinner = month?.isWinner ?? false;
//     final farzDays = month?.farzCompletedDays ?? 0;
//     final eligDays = month?.eligibleDays ?? 0;
//     final fardPts = month?.fardPoints ?? 0;

//     final now = DateTime.now();
//     final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
//     final monthName = AppConstants.bengaliMonths[now.month - 1];

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//             color: _C.darkGreen, borderRadius: BorderRadius.circular(16)),
//         child: Stack(children: [
//           Positioned(
//               top: -30,
//               right: -30,
//               child: Container(
//                   width: 90,
//                   height: 90,
//                   decoration: const BoxDecoration(
//                       shape: BoxShape.circle, color: Color(0x08FFFFFF)))),
//           Positioned(
//               bottom: -15,
//               left: -8,
//               child: Container(
//                   width: 60,
//                   height: 60,
//                   decoration: const BoxDecoration(
//                       shape: BoxShape.circle, color: Color(0x05FFFFFF)))),
//           Padding(
//             padding: const EdgeInsets.all(14),
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (isWinner) ...[
//                     Container(
//                       margin: const EdgeInsets.only(bottom: 8),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: _C.gold.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(6),
//                         border: Border.all(
//                             color: _C.gold.withOpacity(0.3), width: 0.5),
//                       ),
//                       child: Row(mainAxisSize: MainAxisSize.min, children: [
//                         const Text('🏆', style: TextStyle(fontSize: 10)),
//                         const SizedBox(width: 5),
//                         Text(_winnerLabel(month?.winnerCategory),
//                             style: const TextStyle(
//                                 color: _C.gold,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w700)),
//                       ]),
//                     ),
//                   ],
//                   Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
//                     Expanded(
//                         child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                           Row(children: [
//                             Icon(Icons.wb_sunny_rounded,
//                                 size: 9, color: Colors.white.withOpacity(0.35)),
//                             const SizedBox(width: 3),
//                             Text(isExempt ? 'আজ মাফের দিন 🌙' : 'আজকের আমল',
//                                 style: TextStyle(
//                                     color: Colors.white.withOpacity(0.4),
//                                     fontSize: 9.5,
//                                     fontWeight: FontWeight.w500)),
//                           ]),
//                           const SizedBox(height: 4),
//                           todayPts > 0
//                               ? RichText(
//                                   text: TextSpan(children: [
//                                   TextSpan(
//                                       text: '$todayPts',
//                                       style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 26,
//                                           fontWeight: FontWeight.w900,
//                                           height: 1,
//                                           letterSpacing: -1)),
//                                   const TextSpan(
//                                       text: ' pts',
//                                       style: TextStyle(
//                                           color: Color(0x80FFFFFF),
//                                           fontSize: 11,
//                                           fontWeight: FontWeight.w500)),
//                                 ]))
//                               : isExempt
//                                   ? const Text('মাফের দিন',
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w800,
//                                           height: 1.1))
//                                   : const Text('এখনো রেকর্ড\nহয়নি',
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w800,
//                                           height: 1.2,
//                                           letterSpacing: -0.2)),
//                           const SizedBox(height: 8),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: hasToday
//                                   ? Colors.white.withOpacity(0.1)
//                                   : _C.gold,
//                               borderRadius: BorderRadius.circular(8),
//                               border: hasToday
//                                   ? Border.all(
//                                       color: Colors.white.withOpacity(0.18),
//                                       width: 0.5)
//                                   : null,
//                             ),
//                             child:
//                                 Row(mainAxisSize: MainAxisSize.min, children: [
//                               Icon(
//                                   hasToday
//                                       ? Icons.edit_rounded
//                                       : Icons.add_rounded,
//                                   color: Colors.white,
//                                   size: 11),
//                               const SizedBox(width: 4),
//                               Text(hasToday ? 'আপডেট করুন' : 'রেকর্ড করুন',
//                                   style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 10.5,
//                                       fontWeight: FontWeight.w700)),
//                             ]),
//                           ),
//                         ])),
//                     Container(
//                         width: 0.5,
//                         height: 72,
//                         color: Colors.white.withOpacity(0.12),
//                         margin: const EdgeInsets.symmetric(horizontal: 12)),
//                     Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(_fmt(monthPts),
//                               style: TextStyle(
//                                   color: _C.gold,
//                                   fontSize: monthPts >= 10000 ? 20 : 24,
//                                   fontWeight: FontWeight.w800,
//                                   height: 1,
//                                   letterSpacing: -1)),
//                           const SizedBox(height: 2),
//                           Text('মাসের পয়েন্ট',
//                               style: TextStyle(
//                                   color: Colors.white.withOpacity(0.35),
//                                   fontSize: 8.5)),
//                           const SizedBox(height: 6),
//                           Row(mainAxisSize: MainAxisSize.min, children: [
//                             if (rank != null) ...[
//                               _RightChip(
//                                   top: '#$rank',
//                                   bottom: 'র‍্যাংক',
//                                   isRank: true),
//                               const SizedBox(width: 6),
//                             ],
//                             _RightChip(top: _fmt(fardPts), bottom: 'ফরজ pts'),
//                           ]),
//                         ]),
//                   ]),
//                   const SizedBox(height: 10),
//                   const Divider(
//                       height: 1, thickness: 0.5, color: Color(0x1AFFFFFF)),
//                   const SizedBox(height: 8),
//                   Row(children: [
//                     _HeroChip(
//                         value: '$daysComp/$daysInMonth', label: 'সম্পন্ন দিন'),
//                     _heroDivider(),
//                     _HeroChip(
//                         value: '$farzDays${eligDays > 0 ? '/$eligDays' : ''}',
//                         label: 'পূর্ণ ফরজ'),
//                     _heroDivider(),
//                     Expanded(
//                         child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                           Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Text(monthName,
//                                     style: TextStyle(
//                                         color: Colors.white.withOpacity(0.35),
//                                         fontSize: 8.5)),
//                                 const SizedBox(width: 4),
//                                 Text('${pct.toInt()}%',
//                                     style: const TextStyle(
//                                         color: _C.gold,
//                                         fontSize: 9.5,
//                                         fontWeight: FontWeight.w700)),
//                               ]),
//                           const SizedBox(height: 3),
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(99),
//                             child: LinearProgressIndicator(
//                               value: pct / 100,
//                               minHeight: 3.5,
//                               backgroundColor: Colors.white.withOpacity(0.1),
//                               valueColor: const AlwaysStoppedAnimation(_C.gold),
//                             ),
//                           ),
//                         ])),
//                   ]),
//                 ]),
//           ),
//         ]),
//       ),
//     );
//   }

//   static Widget _heroDivider() => Container(
//       width: 1,
//       height: 12,
//       color: Colors.white.withOpacity(0.12),
//       margin: const EdgeInsets.symmetric(horizontal: 10));
// }

// class _RightChip extends StatelessWidget {
//   final String top, bottom;
//   final bool isRank;
//   const _RightChip(
//       {required this.top, required this.bottom, this.isRank = false});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: const BoxConstraints(minWidth: 51),
//       padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
//       decoration: BoxDecoration(
//         color: isRank
//             ? const Color(0xFF4ADE80).withOpacity(0.12)
//             : Colors.white.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(7),
//         border: Border.all(
//           color: isRank
//               ? const Color(0xFF4ADE80).withOpacity(0.25)
//               : Colors.white.withOpacity(0.1),
//           width: 0.5,
//         ),
//       ),
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         Text(top,
//             style: TextStyle(
//                 color: isRank ? const Color(0xFF4ADE80) : _C.gold,
//                 fontSize: 11,
//                 fontWeight: FontWeight.w700,
//                 height: 1)),
//         const SizedBox(height: 2),
//         Text(bottom,
//             style:
//                 TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 8)),
//       ]),
//     );
//   }
// }

// class _HeroChip extends StatelessWidget {
//   final String value, label;
//   const _HeroChip({required this.value, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(value,
//               style: const TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.white,
//                   height: 1)),
//           const SizedBox(height: 2),
//           Text(label,
//               style: TextStyle(
//                   fontSize: 8.5, color: Colors.white.withOpacity(0.35))),
//         ]);
//   }
// }

// class _HeroSkeleton extends StatelessWidget {
//   const _HeroSkeleton();
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 160,
//       decoration: BoxDecoration(
//           color: _C.darkGreen.withOpacity(0.7),
//           borderRadius: BorderRadius.circular(16)),
//     ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1400.ms, colors: [
//       Colors.white.withOpacity(0.03),
//       Colors.white.withOpacity(0.08),
//       Colors.white.withOpacity(0.03)
//     ]);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // WEEKLY STRIP
// // ─────────────────────────────────────────────────────────────────────────────

// Color _weekBarColor(double fillFrac) {
//   if (fillFrac >= 0.7) return _C.midGreen;
//   if (fillFrac >= 0.4) return const Color(0xFFFFA726);
//   return const Color(0xFFE57373);
// }

// class _WeekStrip extends StatelessWidget {
//   final ProgressSummary? summary;
//   const _WeekStrip({this.summary});

//   static const _bnDay = {
//     'Sun': 'র',
//     'Mon': 'সো',
//     'Tue': 'ম',
//     'Wed': 'বু',
//     'Thu': 'বৃ',
//     'Fri': 'শু',
//     'Sat': 'শ',
//   };

//   @override
//   Widget build(BuildContext context) {
//     final weekData = summary?.currentWeek ?? [];
//     final weekTotal = summary?.weeklyPoints ?? 0;
//     final isFemale = summary?.userGender == 'female';
//     final today = DateTime.now();
//     final maxPts =
//         weekData.map((d) => d.points).fold(0, (a, b) => a > b ? a : b);
//     final safePts = (maxPts < 1 ? 1 : maxPts).toDouble();

//     return Container(
//       padding: const EdgeInsets.fromLTRB(13, 10, 13, 10),
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(13),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         Row(children: [
//           const Text('এই সপ্তাহ',
//               style: TextStyle(
//                   color: _C.textPri,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 11)),
//           const Spacer(),
//           if (weekTotal > 0) ...[
//             Text('$weekTotal',
//                 style: const TextStyle(
//                     color: _C.green,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 11)),
//             const Text(' pts',
//                 style: TextStyle(
//                     color: _C.textHint,
//                     fontSize: 10,
//                     fontWeight: FontWeight.w500)),
//           ],
//         ]),
//         const SizedBox(height: 8),
//         if (weekData.isEmpty)
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 4),
//             child: Row(
//                 children: List.generate(
//                     7,
//                     (i) => Expanded(
//                             child: Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 2),
//                           height: 28,
//                           decoration: BoxDecoration(
//                               color: _C.pageBg,
//                               borderRadius: BorderRadius.circular(4),
//                               border: Border.all(color: _C.border, width: 0.5)),
//                         )))),
//           )
//         else
//           LayoutBuilder(builder: (ctx, constraints) {
//             final barAreaH = (constraints.maxWidth * 0.26).clamp(28.0, 52.0);
//             const dayLblH = 12.0, ptsLblH = 12.0, gap = 2.0;
//             final totalH = ptsLblH + gap + barAreaH + gap + dayLblH;

//             return SizedBox(
//                 height: totalH,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: weekData.map((d) {
//                     final dayDate = DateTime.tryParse(d.date);
//                     final isToday = dayDate != null &&
//                         dayDate.year == today.year &&
//                         dayDate.month == today.month &&
//                         dayDate.day == today.day;
//                     final showExempt = d.isExemptDay && isFemale;
//                     final pts = d.points.toDouble();
//                     final fillFrac =
//                         pts > 0 ? (pts / safePts).clamp(0.0, 1.0) : 0.0;
//                     final barH = fillFrac > 0
//                         ? (fillFrac * barAreaH).clamp(4.0, barAreaH)
//                         : 0.0;

//                     return Expanded(
//                         child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 2),
//                       child: Column(mainAxisSize: MainAxisSize.min, children: [
//                         SizedBox(
//                             height: ptsLblH,
//                             child: Center(
//                               child: d.points > 0
//                                   ? FittedBox(
//                                       fit: BoxFit.scaleDown,
//                                       child: Text('${d.points}',
//                                           style: TextStyle(
//                                               fontSize: 7.5,
//                                               color: isToday
//                                                   ? _C.darkGreen
//                                                   : _weekBarColor(fillFrac),
//                                               fontWeight: isToday
//                                                   ? FontWeight.w800
//                                                   : FontWeight.w600)))
//                                   : const SizedBox.shrink(),
//                             )),
//                         const SizedBox(height: gap),
//                         SizedBox(
//                             height: barAreaH,
//                             child: Align(
//                               alignment: Alignment.bottomCenter,
//                               child: showExempt
//                                   ? Container(
//                                       height: (barAreaH * 0.6)
//                                           .clamp(16.0, barAreaH),
//                                       width: double.infinity,
//                                       decoration: BoxDecoration(
//                                           color: const Color(0xFFEDE9FE),
//                                           borderRadius:
//                                               BorderRadius.circular(5)),
//                                       child: const Center(
//                                           child: Text('🌙',
//                                               style: TextStyle(fontSize: 7))))
//                                   : barH > 0
//                                       ? Container(
//                                           height: barH,
//                                           width: double.infinity,
//                                           decoration: BoxDecoration(
//                                             gradient: LinearGradient(
//                                               begin: Alignment.bottomCenter,
//                                               end: Alignment.topCenter,
//                                               colors: isToday
//                                                   ? [_C.darkGreen, _C.midGreen]
//                                                   : [
//                                                       _weekBarColor(fillFrac)
//                                                           .withOpacity(0.6),
//                                                       _weekBarColor(fillFrac)
//                                                     ],
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(5),
//                                             boxShadow: isToday
//                                                 ? [
//                                                     BoxShadow(
//                                                         color: _C.darkGreen
//                                                             .withOpacity(0.3),
//                                                         blurRadius: 5,
//                                                         offset:
//                                                             const Offset(0, 2))
//                                                   ]
//                                                 : null,
//                                           ))
//                                       : Container(
//                                           height: 3,
//                                           width: double.infinity,
//                                           decoration: BoxDecoration(
//                                               color: _C.pageBg,
//                                               borderRadius:
//                                                   BorderRadius.circular(2),
//                                               border: Border.all(
//                                                   color: _C.border,
//                                                   width: 0.5))),
//                             )),
//                         const SizedBox(height: gap),
//                         SizedBox(
//                             height: dayLblH,
//                             child: Center(
//                                 child: Text(
//                               _bnDay[d.day] ?? d.day,
//                               style: TextStyle(
//                                   fontSize: 8.5,
//                                   color: isToday ? _C.darkGreen : _C.textHint,
//                                   fontWeight: isToday
//                                       ? FontWeight.w800
//                                       : FontWeight.w500),
//                             ))),
//                       ]),
//                     ));
//                   }).toList(),
//                 ));
//           }),
//       ]),
//     );
//   }
// }

// class _WeekSkeleton extends StatelessWidget {
//   const _WeekSkeleton();
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 100,
//       decoration: BoxDecoration(
//           color: _C.card,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: _C.border, width: 0.5)),
//     ).animate(onPlay: (c) => c.repeat()).shimmer(
//         duration: 1200.ms, colors: [_C.card, const Color(0xFFE8ECE8), _C.card]);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // QUICK ACTIONS  ── 2 × 2 tile grid
// // Four equal tiles arranged in a 2-column grid. Each tile has a tinted icon
// // container, a one-line label, and a subtle arrow. The sadaqah tile uses a
// // warm gold tint to distinguish it visually from the navigation tiles.
// // ─────────────────────────────────────────────────────────────────────────────

// class _QuickActions extends StatelessWidget {
//   final VoidCallback onTracker, onLeaderboard, onMonthly, onSadaqah;
//   const _QuickActions({
//     required this.onTracker,
//     required this.onLeaderboard,
//     required this.onMonthly,
//     required this.onSadaqah,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       const Padding(
//         padding: EdgeInsets.only(bottom: 10),
//         child: Row(children: [
//           Text('⚡', style: TextStyle(fontSize: 13)),
//           SizedBox(width: 6),
//           Text('দ্রুত যান',
//               style: TextStyle(
//                   color: _C.textPri,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 13,
//                   letterSpacing: -0.1)),
//         ]),
//       ),
//       Row(children: [
//         Expanded(
//             child: _QTile(
//           emoji: '📿',
//           label: 'আজকের আমল',
//           sublabel: 'রেকর্ড করুন',
//           bg: _C.greenLight,
//           iconBg: _C.darkGreen.withOpacity(0.08),
//           accent: _C.darkGreen,
//           onTap: onTracker,
//         )),
//         const SizedBox(width: 10),
//         Expanded(
//             child: _QTile(
//           emoji: '🏆',
//           label: 'শীর্ষ তালিকা',
//           sublabel: 'র‍্যাংকিং দেখুন',
//           bg: const Color(0xFFFFFBF0),
//           iconBg: _C.gold.withOpacity(0.12),
//           accent: const Color(0xFF92600A),
//           onTap: onLeaderboard,
//         )),
//       ]),
//       const SizedBox(height: 10),
//       Row(children: [
//         Expanded(
//             child: _QTile(
//           emoji: '📊',
//           label: 'মাসিক রিপোর্ট',
//           sublabel: 'অগ্রগতি দেখুন',
//           bg: _C.purplePale,
//           iconBg: _C.purple.withOpacity(0.1),
//           accent: _C.purple,
//           onTap: onMonthly,
//         )),
//         const SizedBox(width: 10),
//         Expanded(
//             child: _QTile(
//           emoji: '🤲',
//           label: 'সদকাহ করুন',
//           sublabel: 'আল্লাহর রাস্তায়',
//           bg: const Color(0xFFFFF8EC),
//           iconBg: const Color(0xFFFFE0A0).withOpacity(0.6),
//           accent: const Color(0xFF7A4500),
//           onTap: onSadaqah,
//           isSadaqah: true,
//         )),
//       ]),
//     ]);
//   }
// }

// class _QTile extends StatelessWidget {
//   final String emoji, label, sublabel;
//   final Color bg, iconBg, accent;
//   final VoidCallback onTap;
//   final bool isSadaqah;

//   const _QTile({
//     required this.emoji,
//     required this.label,
//     required this.sublabel,
//     required this.bg,
//     required this.iconBg,
//     required this.accent,
//     required this.onTap,
//     this.isSadaqah = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: bg,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: isSadaqah
//                 ? const Color(0xFFFFCC80).withOpacity(0.8)
//                 : _C.border,
//             width: isSadaqah ? 0.8 : 0.5,
//           ),
//         ),
//         child: Row(children: [
//           Container(
//             width: 38,
//             height: 38,
//             decoration: BoxDecoration(
//                 color: iconBg, borderRadius: BorderRadius.circular(10)),
//             child: Center(
//                 child: Text(emoji, style: const TextStyle(fontSize: 18))),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                 Text(label,
//                     style: TextStyle(
//                         color: accent,
//                         fontWeight: FontWeight.w800,
//                         fontSize: 11.5,
//                         letterSpacing: -0.2)),
//                 const SizedBox(height: 1),
//                 Text(sublabel,
//                     style: TextStyle(
//                         color: accent.withOpacity(0.55),
//                         fontSize: 9.5,
//                         fontWeight: FontWeight.w500)),
//               ])),
//           Icon(Icons.arrow_forward_ios_rounded,
//               size: 9, color: accent.withOpacity(0.4)),
//         ]),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION HEADER
// // ─────────────────────────────────────────────────────────────────────────────

// class _SecHead extends StatelessWidget {
//   final String title, emoji;
//   final VoidCallback onSeeAll;
//   const _SecHead(
//       {required this.title, required this.emoji, required this.onSeeAll});

//   @override
//   Widget build(BuildContext context) {
//     return Row(children: [
//       Text(emoji, style: const TextStyle(fontSize: 13)),
//       const SizedBox(width: 6),
//       Text(title,
//           style: const TextStyle(
//               color: _C.textPri,
//               fontWeight: FontWeight.w800,
//               fontSize: 13,
//               letterSpacing: -0.1)),
//       const Spacer(),
//       GestureDetector(
//         onTap: onSeeAll,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//           decoration: BoxDecoration(
//               color: _C.greenLight, borderRadius: BorderRadius.circular(99)),
//           child: const Text('সব দেখুন →',
//               style: TextStyle(
//                   color: _C.darkGreen,
//                   fontSize: 10,
//                   fontWeight: FontWeight.w700)),
//         ),
//       ),
//     ]);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // MONTHLY HORIZONTAL SCROLL ROW
// // Each month = a compact card with coloured arc + points + % pill
// // Scrolls horizontally — feels like a film strip of your history
// // ─────────────────────────────────────────────────────────────────────────────

// class _MonthScrollRow extends StatelessWidget {
//   final List<MonthlyTracker> trackers;
//   const _MonthScrollRow({required this.trackers});

//   @override
//   Widget build(BuildContext context) {
//     final items = trackers.take(6).toList();
//     return SizedBox(
//       height: 112,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.zero,
//         clipBehavior: Clip.none,
//         itemCount: items.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 10),
//         itemBuilder: (_, i) {
//           final t = items[i];
//           final month = AppConstants.bengaliMonths[t.month - 1];
//           final pct = (t.completionPercentage / 100).clamp(0.0, 1.0);
//           final barColor = pct > 0.7
//               ? _C.green
//               : pct > 0.4
//                   ? _C.amber
//                   : _C.red;
//           final bgColor = pct > 0.7
//               ? _C.greenLight
//               : pct > 0.4
//                   ? _C.amberLight
//                   : _C.redLight;

//           return Container(
//             width: 90,
//             padding: const EdgeInsets.all(11),
//             decoration: BoxDecoration(
//               color: _C.card,
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(color: _C.border, width: 0.5),
//             ),
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               // Month name + winner
//               Row(children: [
//                 Expanded(
//                     child: Text(month,
//                         style: const TextStyle(
//                             color: _C.textPri,
//                             fontWeight: FontWeight.w800,
//                             fontSize: 12),
//                         overflow: TextOverflow.ellipsis)),
//                 if (t.isWinner) const Text('🏆', style: TextStyle(fontSize: 9)),
//               ]),
//               const SizedBox(height: 6),

//               // Arc-style progress indicator
//               Stack(alignment: Alignment.center, children: [
//                 SizedBox(
//                   width: 50,
//                   height: 50,
//                   child: CircularProgressIndicator(
//                     value: pct,
//                     strokeWidth: 4.5,
//                     backgroundColor: bgColor,
//                     valueColor: AlwaysStoppedAnimation(barColor),
//                     strokeCap: StrokeCap.round,
//                   ),
//                 ),
//                 Column(mainAxisSize: MainAxisSize.min, children: [
//                   Text('${(pct * 100).toInt()}%',
//                       style: TextStyle(
//                           color: barColor,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w800,
//                           height: 1)),
//                 ]),
//               ]),

//               const SizedBox(height: 7),

//               // Points
//               FittedBox(
//                 fit: BoxFit.scaleDown,
//                 child: Text(_fmt(t.totalPoints),
//                     style: TextStyle(
//                         color: barColor,
//                         fontWeight: FontWeight.w800,
//                         fontSize: 12)),
//               ),
//               Text('pts',
//                   style: TextStyle(
//                       color: barColor.withOpacity(0.5), fontSize: 8.5)),
//             ]),
//           ).animate().fadeIn(delay: Duration(milliseconds: i * 60));
//         },
//       ),
//     );
//   }
// }

// class _HScrollSkeleton extends StatelessWidget {
//   const _HScrollSkeleton();
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 112,
//       child: Row(
//           children: List.generate(
//               4,
//               (i) => Container(
//                     width: 90,
//                     margin: const EdgeInsets.only(right: 10),
//                     decoration: BoxDecoration(
//                         color: _C.card,
//                         borderRadius: BorderRadius.circular(14),
//                         border: Border.all(color: _C.border, width: 0.5)),
//                   ).animate(onPlay: (c) => c.repeat()).shimmer(
//                       duration: 1200.ms,
//                       colors: [_C.card, const Color(0xFFE8ECE8), _C.card]))),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // LEADERBOARD LIST  (unchanged — vertical rank order must stay)
// // ─────────────────────────────────────────────────────────────────────────────

// class _LeaderList extends StatelessWidget {
//   final List entries;
//   final String? currentUserId;
//   const _LeaderList({required this.entries, this.currentUserId});

//   static const _emojis = ['🥇', '🥈', '🥉'];
//   static const _rankColors = [_C.rankGold, _C.rankSilver, _C.rankBronze];
//   static const _rowBg = [
//     Color(0xFFFFFBF0),
//     Color(0xFFF8FAFC),
//     Color(0xFFFFF7ED)
//   ];
//   static const _avatarBg = [
//     Color(0xFF0E3D22),
//     Color(0xFF374151),
//     Color(0xFF7C3AED)
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           color: _C.card,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: _C.border, width: 0.5)),
//       child: Column(
//           children: List.generate(entries.length, (i) {
//         final e = entries[i];
//         final isLast = i == entries.length - 1;
//         final isMe =
//             currentUserId != null && e.userId?.toString() == currentUserId;

//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
//           decoration: BoxDecoration(
//             color: _rowBg[i],
//             borderRadius: BorderRadius.vertical(
//               top: i == 0 ? const Radius.circular(14) : Radius.zero,
//               bottom: isLast ? const Radius.circular(14) : Radius.zero,
//             ),
//             border: isLast
//                 ? null
//                 : const Border(
//                     bottom: BorderSide(color: _C.border, width: 0.5)),
//           ),
//           child: Row(children: [
//             SizedBox(
//                 width: 22,
//                 child: Text(_emojis[i],
//                     style: const TextStyle(fontSize: 16),
//                     textAlign: TextAlign.center)),
//             const SizedBox(width: 8),
//             Container(
//               width: 30,
//               height: 30,
//               decoration: BoxDecoration(
//                   color: _avatarBg[i], borderRadius: BorderRadius.circular(8)),
//               child: Center(
//                   child: Text(
//                 (e.name?.isNotEmpty == true) ? e.name[0].toUpperCase() : 'U',
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 12),
//               )),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                   Row(children: [
//                     Flexible(
//                         child: Text(e.name?.split(' ').first ?? '',
//                             style: const TextStyle(
//                                 color: _C.textPri,
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 12),
//                             overflow: TextOverflow.ellipsis)),
//                     if (isMe) ...[
//                       const SizedBox(width: 4),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 5, vertical: 1),
//                         decoration: BoxDecoration(
//                             color: _C.greenLight,
//                             borderRadius: BorderRadius.circular(99)),
//                         child: const Text('আপনি',
//                             style: TextStyle(
//                                 color: _C.darkGreen,
//                                 fontSize: 8.5,
//                                 fontWeight: FontWeight.w700)),
//                       ),
//                     ],
//                   ]),
//                   if (e.id != null || e.district != null)
//                     Text('ID: ${e.id ?? ''} · ${e.district ?? ''}',
//                         style: const TextStyle(color: _C.textSec, fontSize: 9),
//                         overflow: TextOverflow.ellipsis),
//                 ])),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               decoration: BoxDecoration(
//                   color: _rankColors[i].withOpacity(0.12),
//                   borderRadius: BorderRadius.circular(10)),
//               child: Column(children: [
//                 Text('${e.totalPoints}',
//                     style: TextStyle(
//                         color: _rankColors[i],
//                         fontWeight: FontWeight.w900,
//                         fontSize: 13,
//                         height: 1)),
//                 Text('pts',
//                     style: TextStyle(
//                         color: _rankColors[i].withOpacity(0.55),
//                         fontSize: 7,
//                         fontWeight: FontWeight.w600)),
//               ]),
//             ),
//           ]),
//         ).animate().fadeIn(delay: Duration(milliseconds: i * 50));
//       })),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // COMMUNITY ROW  ── Rate App + Share App side-by-side
// // Two equal cards in a horizontal row. Keeps the page from feeling like
// // an endless vertical list, and groups related social actions together.
// // ─────────────────────────────────────────────────────────────────────────────

// class _CommunityRow extends StatelessWidget {
//   final VoidCallback onRate, onShare;
//   const _CommunityRow({required this.onRate, required this.onShare});

//   @override
//   Widget build(BuildContext context) {
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       const Padding(
//         padding: EdgeInsets.only(bottom: 10),
//         child: Row(children: [
//           Text('💬', style: TextStyle(fontSize: 13)),
//           SizedBox(width: 6),
//           Text('কমিউনিটি',
//               style: TextStyle(
//                   color: _C.textPri,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 13,
//                   letterSpacing: -0.1)),
//         ]),
//       ),
//       Row(children: [
//         // Rate card
//         Expanded(
//             child: _CommunityCard(
//           emoji: '⭐',
//           title: 'রেটিং দিন',
//           subtitle: 'Play Store এ রিভিউ করুন',
//           bg: const Color(0xFFFFFBF0),
//           border: const Color(0xFFFFE082),
//           accent: const Color(0xFF7A4500),
//           iconBg: const Color(0xFFFFECB3),
//           onTap: onRate,
//         )),
//         const SizedBox(width: 10),
//         // Share card
//         Expanded(
//             child: _CommunityCard(
//           emoji: '📤',
//           title: 'শেয়ার করুন',
//           subtitle: 'বন্ধুদের জানান',
//           bg: const Color(0xFFEFF6FF),
//           border: const Color(0xFFBFDBFE),
//           accent: const Color(0xFF1D4ED8),
//           iconBg: const Color(0xFFDBEAFE),
//           onTap: onShare,
//         )),
//       ]),
//     ]);
//   }
// }

// class _CommunityCard extends StatelessWidget {
//   final String emoji, title, subtitle;
//   final Color bg, border, accent, iconBg;
//   final VoidCallback onTap;
//   const _CommunityCard({
//     required this.emoji,
//     required this.title,
//     required this.subtitle,
//     required this.bg,
//     required this.border,
//     required this.accent,
//     required this.iconBg,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(13),
//         decoration: BoxDecoration(
//           color: bg,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: border, width: 0.8),
//         ),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           // icon + arrow row
//           Row(children: [
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                   color: iconBg, borderRadius: BorderRadius.circular(10)),
//               child: Center(
//                   child: Text(emoji, style: const TextStyle(fontSize: 17))),
//             ),
//             const Spacer(),
//             Icon(Icons.arrow_outward_rounded,
//                 size: 13, color: accent.withOpacity(0.45)),
//           ]),
//           const SizedBox(height: 9),
//           Text(title,
//               style: TextStyle(
//                   color: accent,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 13,
//                   letterSpacing: -0.2)),
//           const SizedBox(height: 2),
//           Text(subtitle,
//               style: TextStyle(
//                   color: accent.withOpacity(0.55),
//                   fontSize: 9.5,
//                   fontWeight: FontWeight.w500)),
//         ]),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // HOW IT WORKS
// // ─────────────────────────────────────────────────────────────────────────────

// class _HowItWorks extends StatelessWidget {
//   final VoidCallback onTap;
//   const _HowItWorks({required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         decoration: BoxDecoration(
//           color: _C.card,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: _C.border, width: 0.5),
//         ),
//         child: Row(children: [
//           Container(
//             width: 34,
//             height: 34,
//             decoration: BoxDecoration(
//                 color: _C.greenLight, borderRadius: BorderRadius.circular(10)),
//             child: const Icon(Icons.help_outline_rounded,
//                 color: _C.darkGreen, size: 18),
//           ),
//           const SizedBox(width: 10),
//           const Expanded(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                 Text('এটি কীভাবে কাজ করে?',
//                     style: TextStyle(
//                         color: _C.textPri,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 12)),
//                 SizedBox(height: 1),
//                 Text('পয়েন্ট, র‍্যাংকিং ও আমল সম্পর্কে জানুন',
//                     style: TextStyle(color: _C.textSec, fontSize: 10.5)),
//               ])),
//           const Icon(Icons.chevron_right_rounded, color: _C.textHint, size: 18),
//         ]),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SHARED WIDGETS
// // ─────────────────────────────────────────────────────────────────────────────

// class _ListSkeleton extends StatelessWidget {
//   const _ListSkeleton();
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 120,
//       decoration: BoxDecoration(
//           color: _C.card,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: _C.border, width: 0.5)),
//     ).animate(onPlay: (c) => c.repeat()).shimmer(
//         duration: 1200.ms, colors: [_C.card, const Color(0xFFE8ECE8), _C.card]);
//   }
// }

// class _EmptyCard extends StatelessWidget {
//   final String label;
//   const _EmptyCard({required this.label});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 80,
//       decoration: BoxDecoration(
//           color: _C.card,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: _C.border, width: 0.5)),
//       child: Center(
//           child: Text(label,
//               style: const TextStyle(
//                   color: _C.textHint,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500))),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PUBLIC ALIAS
// // ─────────────────────────────────────────────────────────────────────────────

// class SectionHeaderCompact extends StatelessWidget {
//   final String title, action;
//   final VoidCallback onAction;
//   const SectionHeaderCompact(
//       {required this.title,
//       required this.action,
//       required this.onAction,
//       super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//       Text(title,
//           style: const TextStyle(
//               color: _C.textPri, fontWeight: FontWeight.w700, fontSize: 11)),
//       GestureDetector(
//           onTap: onAction,
//           child: Text(action,
//               style: const TextStyle(
//                   color: _C.darkGreen,
//                   fontSize: 10,
//                   fontWeight: FontWeight.w600))),
//     ]);
//   }
// }
import 'dart:convert';
import 'dart:math';

import 'package:amal_tracker/features/home/widgets/daily_ayah_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../auth/providers/auth_provider.dart';
import '../../tracker/providers/tracker_provider.dart';
import '../../tracker/models/tracker_model.dart';
import '../../leaderboard/providers/leaderboard_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../notification/widgets/notification_widgets.dart';
import '../../home/widgets/profile_sheet.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────

class _C {
  static const pageBg = Color(0xFFF4F6F1);
  static const card = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const midGreen = Color(0xFF1B7045);
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFFFF3E0);
  static const goldBorder = Color(0xFFFFCC80);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const amber = Color(0xFFF59E0B);
  static const amberLight = Color(0xFFFFF7ED);
  static const purple = Color(0xFF7C3AED);
  static const purplePale = Color(0xFFF3F0FF);
  static const red = Color(0xFFEF4444);
  static const redLight = Color(0xFFFEE2E2);
  static const textPri = Color(0xFF0A1A0F);
  static const textSec = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
  static const border = Color(0xFFE4EAE4);
  static const rankGold = Color(0xFFD4A843);
  static const rankSilver = Color(0xFF94A3B8);
  static const rankBronze = Color(0xFFCD7F32);
}

String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}K' : '$n';

// ─────────────────────────────────────────────────────────────────────────────
// AYAH PROVIDER
// Fetches one random ayah per day from alquran.cloud.
// Curated list: verses about amal, taqwa, sabr, sadaqah — thematically
// relevant to a good-deeds tracker app.
// Cached in SharedPreferences keyed by YYYY-MM-DD so it only hits the
// network once per calendar day. Falls back to a hardcoded ayah on error.
// ─────────────────────────────────────────────────────────────────────────────

class _AyahData {
  final String arabic;
  final String bengali;
  final String surahName; // Bengali surah name
  final int surahNumber;
  final int ayahNumber;

  const _AyahData({
    required this.arabic,
    required this.bengali,
    required this.surahName,
    required this.surahNumber,
    required this.ayahNumber,
  });
}

// Curated ayah numbers (global index 1-6236) — theme: amal, taqwa, sabr, sadaqah
const _curatedAyahs = [
  255, // 2:255 Ayatul Kursi (tawakkul)
  177, // 2:177 true righteousness
  261, // 2:261 sadaqah parable
  286, // 2:286 Allah burdens not a soul
  102, // 3:102 taqwa
  200, // 3:200 sabr
  1, // 1:1   Bismillah (Fatiha)
  56, // 2:56  gratitude
  153, // 2:153 sabr & salah
  183, // 2:183 fasting & taqwa
  284, // 2:284 to Allah belongs all
  45, // 2:45  seek help with sabr & salah
  274, // 2:274 sadaqah by night & day
  3996, // 31:17 establish prayer
  4674, // 39:10 reward of sabr
  5765, // 94:5  ease after difficulty
  5766, // 94:6  ease after difficulty (repeated for emphasis)
  4847, // 49:13 taqwa is honour
  4618, // 45:15 whoever does righteous deeds
  2788, // 22:37 taqwa reaches Allah
];

// Bengali surah names (1-indexed, only the ones we reference — extend as needed)
const _bnSurahNames = <int, String>{
  1: 'আল-ফাতিহা',
  2: 'আল-বাকারা',
  3: 'আলে-ইমরান',
  22: 'আল-হাজ্জ',
  23: 'আল-হাজ্জ',
  31: 'লোকমান',
  39: 'আয-যুমার',
  45: 'আল-জাছিয়া',
  49: 'আল-হুজুরাত',
  94: 'আশ-শারহ',
};

final _ayahProvider = FutureProvider<_AyahData>((ref) => _fetchDailyAyah());

Future<_AyahData> _fetchDailyAyah() async {
  final today = DateTime.now();
  final key = 'daily_ayah_${today.year}_${today.month}_${today.day}';

  // Try cache first
  try {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(key);
    if (cached != null) {
      final map = jsonDecode(cached) as Map<String, dynamic>;
      return _AyahData(
        arabic: map['arabic'] as String,
        bengali: map['bengali'] as String,
        surahName: map['surahName'] as String,
        surahNumber: map['surahNumber'] as int,
        ayahNumber: map['ayahNumber'] as int,
      );
    }
  } catch (_) {}

  // Pick a random ayah from curated list, seeded by date so same all day
  final rng = Random(today.year * 10000 + today.month * 100 + today.day);
  final ayahNum = _curatedAyahs[rng.nextInt(_curatedAyahs.length)];

  try {
    final uri = Uri.parse(
      'https://api.alquran.cloud/v1/ayah/$ayahNum/editions/quran-uthmani,bn.bengali',
    );
    final resp = await http.get(uri).timeout(const Duration(seconds: 8));
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      final data = body['data'] as List<dynamic>;
      final arEntry = data[0] as Map<String, dynamic>;
      final bnEntry = data[1] as Map<String, dynamic>;

      final arabic = arEntry['text'] as String;
      final bengali = bnEntry['text'] as String;
      final surahNum = (arEntry['surah']['number'] as int?) ?? 0;
      final ayahInSurah = (arEntry['numberInSurah'] as int?) ?? 0;
      final surahName = _bnSurahNames[surahNum] ?? 'সূরা #$surahNum';

      final result = _AyahData(
        arabic: arabic,
        bengali: bengali,
        surahName: surahName,
        surahNumber: surahNum,
        ayahNumber: ayahInSurah,
      );

      // Cache it
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            key,
            jsonEncode({
              'arabic': arabic,
              'bengali': bengali,
              'surahName': surahName,
              'surahNumber': surahNum,
              'ayahNumber': ayahInSurah,
            }));
      } catch (_) {}

      return result;
    }
  } catch (_) {}

  // Hardcoded fallback — never shows empty
  return const _AyahData(
    arabic: 'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
    bengali: 'নিশ্চয়ই আল্লাহ ধৈর্যশীলদের সাথে আছেন।',
    surahName: 'আল-বাকারা',
    surahNumber: 2,
    ayahNumber: 153,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// HOME SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _sc = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLeaderboard());
  }

  void _loadLeaderboard() {
    final now = DateTime.now();
    final user = ref.read(currentUserProvider);
    ref.read(leaderboardPreviewProvider.notifier).load(
          LeaderboardFilter(
              year: now.year, month: now.month, limit: 3, gender: user?.gender),
          refresh: true,
        );
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final now = DateTime.now();
    ref.invalidate(progressSummaryProvider((year: now.year, month: now.month)));
    ref.invalidate(_ayahProvider);
    await ref.read(leaderboardPreviewProvider.notifier).load(
          LeaderboardFilter(year: now.year, month: now.month, limit: 3),
          refresh: true,
        );
  }

  void _showProfile() => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => ProfileSheet(user: ref.read(currentUserProvider)),
      );

  Future<void> _handleRateApp() async {
    final review = InAppReview.instance;
    if (await review.isAvailable()) {
      await review.requestReview();
    } else {
      final uri = Uri.parse(
          'https://play.google.com/store/apps/details?id=com.yourcompany.sabeq');
      if (await canLaunchUrl(uri))
        launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _handleShareApp() async {
    await Share.share(
      'Sabeq — নেক আমল ট্র্যাক করুন, র‍্যাংকিং এ এগিয়ে যান!\n\n'
      '📲 ডাউনলোড করুন:\nhttps://play.google.com/store/apps/details?id=com.yourcompany.sabeq',
      subject: 'Sabeq অ্যাপ — নেক আমলে এগিয়ে যাও',
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final now = DateTime.now();
    final progress =
        ref.watch(progressSummaryProvider((year: now.year, month: now.month)));
    final board = ref.watch(leaderboardPreviewProvider);
    final ayah = ref.watch(_ayahProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: _C.pageBg,
        appBar: _TopBar(user: user, onAvatarTap: _showProfile),
        body: RefreshIndicator(
          color: _C.darkGreen,
          onRefresh: _refresh,
          child: CustomScrollView(
            controller: _sc,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 90),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── 1. Greeting ──────────────────────────────────────
                    _Greeting(user: user, progress: progress)
                        .animate()
                        .fadeIn(duration: 280.ms),
                    const SizedBox(height: 12),

                    // ── 2. Hero Card ─────────────────────────────────────
                    progress
                        .when(
                          loading: () => const _HeroSkeleton(),
                          error: (_, __) => _HeroCard(
                              summary: null,
                              onTap: () => context.go(AppRoutes.tracker)),
                          data: (s) => _HeroCard(
                              summary: s,
                              onTap: () => context.go(AppRoutes.tracker)),
                        )
                        .animate()
                        .fadeIn(delay: 50.ms, duration: 300.ms),
                    const SizedBox(height: 10),

                    // ── 3. Weekly Chart ───────────────────────────────────
                    progress
                        .when(
                          loading: () => const _WeekSkeleton(),
                          error: (_, __) => const _WeekStrip(summary: null),
                          data: (s) => _WeekStrip(summary: s),
                        )
                        .animate()
                        .fadeIn(delay: 90.ms, duration: 280.ms),

                    const SizedBox(height: 20),

                    // ── 4. Daily Ayah ─────────────────────────────────────────
                    //  ↑ NEW — replaces old _DailyAyahCard
                    const DailyAyahSection()
                        .animate()
                        .fadeIn(delay: 110.ms, duration: 300.ms),
                    const SizedBox(height: 20),

                    // ── 5. Monthly History ────────────────────────────────
                    // Current month is already in hero card.
                    // This section shows ONLY previous months.
                    progress.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (s) {
                        // skip current month (index 0) — already in hero card
                        final older = s.recentMonths.skip(1).toList();
                        if (older.isEmpty) return const SizedBox.shrink();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SecHead(
                              title: 'আগের মাস',
                              emoji: '📅',
                              onSeeAll: () => context.go(AppRoutes.monthlyView),
                            ).animate().fadeIn(delay: 135.ms),
                            const SizedBox(height: 10),
                            _MonthHistoryList(trackers: older)
                                .animate()
                                .fadeIn(delay: 148.ms),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    ),

                    // ── 6. Leaderboard teaser ─────────────────────────────
                    _SecHead(
                      title: 'শীর্ষ তালিকা',
                      emoji: '🏆',
                      onSeeAll: () => context.go(AppRoutes.leaderboard),
                    ).animate().fadeIn(delay: 165.ms),
                    const SizedBox(height: 10),
                    (board.isLoading
                            ? const _ListSkeleton()
                            : board.entries.isEmpty
                                ? const _EmptyCard(label: 'ডেটা নেই')
                                : _LeaderList(
                                    entries: board.entries.take(3).toList(),
                                    currentUserId:
                                        ref.read(currentUserProvider)?.id,
                                  ))
                        .animate()
                        .fadeIn(delay: 178.ms),
                    const SizedBox(height: 20),

                    // ── 7. Community: Rate + Share ────────────────────────
                    _CommunityRow(
                            onRate: _handleRateApp, onShare: _handleShareApp)
                        .animate()
                        .fadeIn(delay: 192.ms),
                    const SizedBox(height: 20),

                    // ── 8. How it works ───────────────────────────────────
                    _HowItWorks(onTap: () => context.push(AppRoutes.howItWorks))
                        .animate()
                        .fadeIn(delay: 200.ms),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic user;
  final VoidCallback onAvatarTap;
  const _TopBar({this.user, required this.onAvatarTap});

  @override
  Size get preferredSize => const Size.fromHeight(54);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _C.card,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 54,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: _C.darkGreen,
                    borderRadius: BorderRadius.circular(8)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset('assets/images/sabeq_logo.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.eco_rounded,
                          color: Colors.white,
                          size: 15)),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Sabeq',
                        style: TextStyle(
                            color: _C.textPri,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            letterSpacing: -0.3)),
                    Text('নেক আমলে এগিয়ে যাও',
                        style: TextStyle(
                            color: _C.textSec,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2)),
                  ]),
              const Spacer(),
              const NotificationBellWidget(),
              const SizedBox(width: 8),
              const SettingsButtonWidget(),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onAvatarTap,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                      color: _C.darkGreen,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    (user?.name?.isNotEmpty == true)
                        ? user!.name[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 12),
                  )),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GREETING
// ─────────────────────────────────────────────────────────────────────────────

class _Greeting extends StatelessWidget {
  final dynamic user;
  final AsyncValue<ProgressSummary> progress;
  const _Greeting({this.user, required this.progress});

  @override
  Widget build(BuildContext context) {
    final streak =
        progress.whenOrNull(data: (s) => s.currentMonth?.streakDays) ?? 0;
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('আস-সালামু আলাইকুম',
            style: TextStyle(
                color: _C.textHint,
                fontSize: 10.5,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 1),
        Text(user?.name?.split(' ').first ?? 'বন্ধু',
            style: const TextStyle(
                color: _C.textPri,
                fontWeight: FontWeight.w800,
                fontSize: 22,
                height: 1.1,
                letterSpacing: -0.5)),
      ])),
      if (streak > 0)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: _C.goldLight,
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: _C.goldBorder, width: 0.5)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Text('🔥', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Text('$streak দিন',
                style: const TextStyle(
                    color: Color(0xFFE65100),
                    fontSize: 12,
                    fontWeight: FontWeight.w700)),
          ]),
        ),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HERO CARD
// ─────────────────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  final ProgressSummary? summary;
  final VoidCallback onTap;
  const _HeroCard({this.summary, required this.onTap});

  String _winnerLabel(String? cat) => switch (cat) {
        'TOP_FARZ' => 'ফরজ চ্যাম্পিয়ন',
        'TOP_EFFORT' => 'সর্বোচ্চ পয়েন্ট',
        'TOP_STREAK' => 'সেরা স্ট্রিক',
        _ => 'মাসিক বিজয়ী',
      };

  @override
  Widget build(BuildContext context) {
    final today = summary?.todayEntry;
    final month = summary?.currentMonth;
    final isFemale = summary?.userGender == 'female';
    final todayPts = today?.totalPoints ?? 0;
    final isExempt = (today?.isExemptDay ?? false) && isFemale;
    final hasToday = todayPts > 0 || isExempt;
    final monthPts = month?.totalPoints ?? 0;
    final pct = (month?.completionPercentage ?? 0).clamp(0.0, 100.0);
    final daysComp = month?.daysCompleted ?? 0;
    final rank = month?.rank;
    final isWinner = month?.isWinner ?? false;
    final farzDays = month?.farzCompletedDays ?? 0;
    final eligDays = month?.eligibleDays ?? 0;
    final fardPts = month?.fardPoints ?? 0;
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final monthName = AppConstants.bengaliMonths[now.month - 1];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: _C.darkGreen, borderRadius: BorderRadius.circular(16)),
        child: Stack(children: [
          Positioned(
              top: -30,
              right: -30,
              child: Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0x08FFFFFF)))),
          Positioned(
              bottom: -15,
              left: -8,
              child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0x05FFFFFF)))),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isWinner) ...[
                    Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: _C.gold.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: _C.gold.withOpacity(0.3), width: 0.5)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Text('🏆', style: TextStyle(fontSize: 10)),
                          const SizedBox(width: 5),
                          Text(_winnerLabel(month?.winnerCategory),
                              style: const TextStyle(
                                  color: _C.gold,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700)),
                        ])),
                  ],
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                          Row(children: [
                            Icon(Icons.wb_sunny_rounded,
                                size: 9, color: Colors.white.withOpacity(0.35)),
                            const SizedBox(width: 3),
                            Text(isExempt ? 'আজ মাফের দিন 🌙' : 'আজকের আমল',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.4),
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w500)),
                          ]),
                          const SizedBox(height: 4),
                          if (todayPts > 0)
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: '$todayPts',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                      height: 1,
                                      letterSpacing: -1)),
                              const TextSpan(
                                  text: ' pts',
                                  style: TextStyle(
                                      color: Color(0x80FFFFFF),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500)),
                            ]))
                          else if (isExempt)
                            const Text('মাফের দিন',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    height: 1.1))
                          else
                            const Text('এখনো রেকর্ড\nহয়নি',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    height: 1.2,
                                    letterSpacing: -0.2)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: hasToday
                                  ? Colors.white.withOpacity(0.1)
                                  : _C.gold,
                              borderRadius: BorderRadius.circular(8),
                              border: hasToday
                                  ? Border.all(
                                      color: Colors.white.withOpacity(0.18),
                                      width: 0.5)
                                  : null,
                            ),
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(
                                  hasToday
                                      ? Icons.edit_rounded
                                      : Icons.add_rounded,
                                  color: Colors.white,
                                  size: 11),
                              const SizedBox(width: 4),
                              Text(hasToday ? 'আপডেট করুন' : 'রেকর্ড করুন',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700)),
                            ]),
                          ),
                        ])),
                    Container(
                        width: 0.5,
                        height: 72,
                        color: Colors.white.withOpacity(0.12),
                        margin: const EdgeInsets.symmetric(horizontal: 12)),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_fmt(monthPts),
                              style: TextStyle(
                                  color: _C.gold,
                                  fontSize: monthPts >= 10000 ? 20 : 24,
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                  letterSpacing: -1)),
                          const SizedBox(height: 2),
                          Text('মাসের পয়েন্ট',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.35),
                                  fontSize: 8.5)),
                          const SizedBox(height: 6),
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            if (rank != null) ...[
                              _RightChip(
                                  top: '#$rank',
                                  bottom: 'র‍্যাংক',
                                  isRank: true),
                              const SizedBox(width: 6),
                            ],
                            _RightChip(top: _fmt(fardPts), bottom: 'ফরজ pts'),
                          ]),
                        ]),
                  ]),
                  const SizedBox(height: 10),
                  const Divider(
                      height: 1, thickness: 0.5, color: Color(0x1AFFFFFF)),
                  const SizedBox(height: 8),
                  Row(children: [
                    _HeroChip(
                        value: '$daysComp/$daysInMonth', label: 'সম্পন্ন দিন'),
                    _heroDivider(),
                    _HeroChip(
                        value: '$farzDays${eligDays > 0 ? '/$eligDays' : ''}',
                        label: 'পূর্ণ ফরজ'),
                    _heroDivider(),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(monthName,
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.35),
                                        fontSize: 8.5)),
                                const SizedBox(width: 4),
                                Text('${pct.toInt()}%',
                                    style: const TextStyle(
                                        color: _C.gold,
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w700)),
                              ]),
                          const SizedBox(height: 3),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: LinearProgressIndicator(
                                  value: pct / 100,
                                  minHeight: 3.5,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.1),
                                  valueColor:
                                      const AlwaysStoppedAnimation(_C.gold))),
                        ])),
                  ]),
                ]),
          ),
        ]),
      ),
    );
  }

  static Widget _heroDivider() => Container(
      width: 1,
      height: 12,
      color: Colors.white.withOpacity(0.12),
      margin: const EdgeInsets.symmetric(horizontal: 10));
}

class _RightChip extends StatelessWidget {
  final String top, bottom;
  final bool isRank;
  const _RightChip(
      {required this.top, required this.bottom, this.isRank = false});
  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(minWidth: 51),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
            color: isRank
                ? const Color(0xFF4ADE80).withOpacity(0.12)
                : Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
                color: isRank
                    ? const Color(0xFF4ADE80).withOpacity(0.25)
                    : Colors.white.withOpacity(0.1),
                width: 0.5)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(top,
              style: TextStyle(
                  color: isRank ? const Color(0xFF4ADE80) : _C.gold,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  height: 1)),
          const SizedBox(height: 2),
          Text(bottom,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.35), fontSize: 8)),
        ]),
      );
}

class _HeroChip extends StatelessWidget {
  final String value, label;
  const _HeroChip({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 8.5, color: Colors.white.withOpacity(0.35))),
          ]);
}

class _HeroSkeleton extends StatelessWidget {
  const _HeroSkeleton();
  @override
  Widget build(BuildContext context) => Container(
        height: 160,
        decoration: BoxDecoration(
            color: _C.darkGreen.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16)),
      ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1400.ms, colors: [
        Colors.white.withOpacity(0.03),
        Colors.white.withOpacity(0.08),
        Colors.white.withOpacity(0.03)
      ]);
}

// ─────────────────────────────────────────────────────────────────────────────
// WEEKLY STRIP
// ─────────────────────────────────────────────────────────────────────────────

Color _weekBarColor(double f) => f >= 0.7
    ? _C.midGreen
    : f >= 0.4
        ? const Color(0xFFFFA726)
        : const Color(0xFFE57373);

class _WeekStrip extends StatelessWidget {
  final ProgressSummary? summary;
  const _WeekStrip({this.summary});

  static const _bnDay = {
    'Sun': 'র',
    'Mon': 'সো',
    'Tue': 'ম',
    'Wed': 'বু',
    'Thu': 'বৃ',
    'Fri': 'শু',
    'Sat': 'শ',
  };

  @override
  Widget build(BuildContext context) {
    final weekData = summary?.currentWeek ?? [];
    final weekTotal = summary?.weeklyPoints ?? 0;
    final isFemale = summary?.userGender == 'female';
    final today = DateTime.now();
    final maxPts =
        weekData.map((d) => d.points).fold(0, (a, b) => a > b ? a : b);
    final safePts = (maxPts < 1 ? 1 : maxPts).toDouble();

    return Container(
      padding: const EdgeInsets.fromLTRB(13, 10, 13, 10),
      decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: _C.border, width: 0.5)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          const Text('এই সপ্তাহ',
              style: TextStyle(
                  color: _C.textPri,
                  fontWeight: FontWeight.w700,
                  fontSize: 11)),
          const Spacer(),
          if (weekTotal > 0) ...[
            Text('$weekTotal',
                style: const TextStyle(
                    color: _C.green,
                    fontWeight: FontWeight.w800,
                    fontSize: 11)),
            const Text(' pts',
                style: TextStyle(
                    color: _C.textHint,
                    fontSize: 10,
                    fontWeight: FontWeight.w500)),
          ],
        ]),
        const SizedBox(height: 8),
        if (weekData.isEmpty)
          Row(
              children: List.generate(
                  7,
                  (_) => Expanded(
                      child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: 28,
                          decoration: BoxDecoration(
                              color: _C.pageBg,
                              borderRadius: BorderRadius.circular(4),
                              border:
                                  Border.all(color: _C.border, width: 0.5))))))
        else
          LayoutBuilder(builder: (_, c) {
            final bH = (c.maxWidth * 0.26).clamp(28.0, 52.0);
            const lH = 12.0, g = 2.0;
            return SizedBox(
                height: lH + g + bH + g + lH,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: weekData.map((d) {
                    final dd = DateTime.tryParse(d.date);
                    final isTdy = dd != null &&
                        dd.year == today.year &&
                        dd.month == today.month &&
                        dd.day == today.day;
                    final exempt = d.isExemptDay && isFemale;
                    final pts = d.points.toDouble();
                    final fill =
                        pts > 0 ? (pts / safePts).clamp(0.0, 1.0) : 0.0;
                    final bh = fill > 0 ? (fill * bH).clamp(4.0, bH) : 0.0;

                    return Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        SizedBox(
                            height: lH,
                            child: Center(
                                child: d.points > 0
                                    ? FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text('${d.points}',
                                            style: TextStyle(
                                                fontSize: 7.5,
                                                color: isTdy
                                                    ? _C.darkGreen
                                                    : _weekBarColor(fill),
                                                fontWeight: isTdy
                                                    ? FontWeight.w800
                                                    : FontWeight.w600)))
                                    : const SizedBox.shrink())),
                        const SizedBox(height: g),
                        SizedBox(
                            height: bH,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: exempt
                                    ? Container(
                                        height: (bH * 0.6).clamp(16.0, bH),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFEDE9FE),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: const Center(
                                            child: Text('🌙',
                                                style: TextStyle(fontSize: 7))))
                                    : bh > 0
                                        ? Container(
                                            height: bh,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    colors: isTdy
                                                        ? [
                                                            _C.darkGreen,
                                                            _C.midGreen
                                                          ]
                                                        : [
                                                            _weekBarColor(fill)
                                                                .withOpacity(
                                                                    0.6),
                                                            _weekBarColor(fill)
                                                          ]),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                boxShadow: isTdy
                                                    ? [
                                                        BoxShadow(
                                                            color: _C.darkGreen
                                                                .withOpacity(
                                                                    0.3),
                                                            blurRadius: 5,
                                                            offset:
                                                                const Offset(
                                                                    0, 2))
                                                      ]
                                                    : null))
                                        : Container(
                                            height: 3,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: _C.pageBg,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                border: Border.all(
                                                    color: _C.border,
                                                    width: 0.5))))),
                        const SizedBox(height: g),
                        SizedBox(
                            height: lH,
                            child: Center(
                                child: Text(_bnDay[d.day] ?? d.day,
                                    style: TextStyle(
                                        fontSize: 8.5,
                                        color:
                                            isTdy ? _C.darkGreen : _C.textHint,
                                        fontWeight: isTdy
                                            ? FontWeight.w800
                                            : FontWeight.w500)))),
                      ]),
                    ));
                  }).toList(),
                ));
          }),
      ]),
    );
  }
}

class _WeekSkeleton extends StatelessWidget {
  const _WeekSkeleton();
  @override
  Widget build(BuildContext context) => Container(
        height: 100,
        decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.border, width: 0.5)),
      ).animate(onPlay: (c) => c.repeat()).shimmer(
          duration: 1200.ms,
          colors: [_C.card, const Color(0xFFE8ECE8), _C.card]);
}

// ─────────────────────────────────────────────────────────────────────────────
// DAILY AYAH CARD
// Bengali text is the primary — large, prominent.
// Arabic below it, smaller, right-aligned.
// Source reference as a pill badge.
// Three states: loading skeleton / error fallback / data.
// ─────────────────────────────────────────────────────────────────────────────

class _DailyAyahCard extends StatelessWidget {
  final AsyncValue<_AyahData> ayah;
  const _DailyAyahCard({required this.ayah});

  @override
  Widget build(BuildContext context) {
    return ayah.when(
      loading: () => _AyahSkeleton(),
      error: (_, __) => _AyahContent(
        ayah: const _AyahData(
          arabic: 'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
          bengali: 'নিশ্চয়ই আল্লাহ ধৈর্যশীলদের সাথে আছেন।',
          surahName: 'আল-বাকারা',
          surahNumber: 2,
          ayahNumber: 153,
        ),
      ),
      data: (d) => _AyahContent(ayah: d),
    );
  }
}

class _AyahContent extends StatelessWidget {
  final _AyahData ayah;
  const _AyahContent({required this.ayah});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A2E17), Color(0xFF163D25)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Header row ────────────────────────────────────────────────
        Row(children: [
          // Label badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _C.gold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: _C.gold.withOpacity(0.3), width: 0.5),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Text('📖', style: TextStyle(fontSize: 9)),
              const SizedBox(width: 4),
              const Text('আজকের আয়াত',
                  style: TextStyle(
                      color: _C.gold,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700)),
            ]),
          ),
          const Spacer(),
          // Source reference
          Text(
            '${ayah.surahName} ${ayah.surahNumber}:${ayah.ayahNumber}',
            style:
                TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 8.5),
          ),
        ]),

        const SizedBox(height: 14),

        // ── Bengali translation — PRIMARY, large ──────────────────────
        Text(
          ayah.bengali,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            height: 1.65,
            letterSpacing: 0.1,
          ),
        ),

        const SizedBox(height: 12),

        // ── Divider ───────────────────────────────────────────────────
        Container(height: 0.5, color: Colors.white.withOpacity(0.1)),
        const SizedBox(height: 12),

        // ── Arabic — secondary, right-aligned ─────────────────────────
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            ayah.arabic,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: _C.gold.withOpacity(0.8),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.8,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ]),
    );
  }
}

class _AyahSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        height: 148,
        decoration: BoxDecoration(
          color: const Color(0xFF0A2E17),
          borderRadius: BorderRadius.circular(16),
        ),
      ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1400.ms, colors: [
        Colors.white.withOpacity(0.02),
        Colors.white.withOpacity(0.07),
        Colors.white.withOpacity(0.02)
      ]);
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _SecHead extends StatelessWidget {
  final String title, emoji;
  final VoidCallback onSeeAll;
  const _SecHead(
      {required this.title, required this.emoji, required this.onSeeAll});

  @override
  Widget build(BuildContext context) => Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 6),
        Text(title,
            style: const TextStyle(
                color: _C.textPri,
                fontWeight: FontWeight.w800,
                fontSize: 13,
                letterSpacing: -0.1)),
        const Spacer(),
        GestureDetector(
            onTap: onSeeAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: _C.greenLight,
                  borderRadius: BorderRadius.circular(99)),
              child: const Text('সব দেখুন →',
                  style: TextStyle(
                      color: _C.darkGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.w700)),
            )),
      ]);
}

// ─────────────────────────────────────────────────────────────────────────────
// MONTHLY HISTORY LIST
// Shows previous months only (current month is in the hero card).
// Clean, consistent rows. No duplication of current month data.
// ─────────────────────────────────────────────────────────────────────────────

class _MonthHistoryList extends StatelessWidget {
  final List<MonthlyTracker> trackers;
  const _MonthHistoryList({required this.trackers});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _C.border, width: 0.5)),
      child: Column(
          children: List.generate(trackers.length, (i) {
        final t = trackers[i];
        final month = AppConstants.bengaliMonths[t.month - 1];
        final pct = (t.completionPercentage / 100).clamp(0.0, 1.0);
        final color = pct > 0.7
            ? _C.green
            : pct > 0.4
                ? _C.amber
                : _C.red;
        final isLast = i == trackers.length - 1;
        final now = DateTime.now();
        final totalD = DateUtils.getDaysInMonth(now.year, t.month);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(
                      bottom: BorderSide(color: _C.border, width: 0.5))),
          child: Row(children: [
            // Color dot
            Container(
                width: 7,
                height: 7,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 10),

            // Month + winner
            SizedBox(
                width: 52,
                child: Row(children: [
                  Flexible(
                      child: Text(month,
                          style: const TextStyle(
                              color: _C.textPri,
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                          overflow: TextOverflow.ellipsis)),
                  if (t.isWinner) ...[
                    const SizedBox(width: 3),
                    const Text('🏆', style: TextStyle(fontSize: 9))
                  ],
                ])),
            const SizedBox(width: 8),

            // Days completed
            Text('${t.daysCompleted ?? 0}/$totalD দিন',
                style: const TextStyle(color: _C.textHint, fontSize: 9.5)),
            const SizedBox(width: 8),

            // Progress bar + %
            Expanded(
                child: Row(children: [
              Expanded(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 4,
                          backgroundColor: _C.pageBg,
                          valueColor: AlwaysStoppedAnimation(color)))),
              const SizedBox(width: 6),
              Text('${(pct * 100).toInt()}%',
                  style: TextStyle(
                      color: color,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700)),
            ])),
            const SizedBox(width: 10),

            // Points
            Text(_fmt(t.totalPoints),
                style: TextStyle(
                    color: _C.textPri,
                    fontWeight: FontWeight.w800,
                    fontSize: 13)),
            const SizedBox(width: 2),
            Text('pts',
                style: TextStyle(
                    color: _C.textHint,
                    fontSize: 9,
                    fontWeight: FontWeight.w600)),
          ]),
        ).animate().fadeIn(delay: Duration(milliseconds: i * 50));
      })),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LEADERBOARD LIST
// ─────────────────────────────────────────────────────────────────────────────

class _LeaderList extends StatelessWidget {
  final List entries;
  final String? currentUserId;
  const _LeaderList({required this.entries, this.currentUserId});

  static const _emojis = ['🥇', '🥈', '🥉'];
  static const _rankColors = [_C.rankGold, _C.rankSilver, _C.rankBronze];
  static const _rowBg = [
    Color(0xFFFFFBF0),
    Color(0xFFF8FAFC),
    Color(0xFFFFF7ED)
  ];
  static const _avatarBg = [
    Color(0xFF0E3D22),
    Color(0xFF374151),
    Color(0xFF7C3AED)
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _C.border, width: 0.5)),
      child: Column(
          children: List.generate(entries.length, (i) {
        final e = entries[i];
        final isLast = i == entries.length - 1;
        final isMe =
            currentUserId != null && e.userId?.toString() == currentUserId;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: _rowBg[i],
            borderRadius: BorderRadius.vertical(
              top: i == 0 ? const Radius.circular(14) : Radius.zero,
              bottom: isLast ? const Radius.circular(14) : Radius.zero,
            ),
            border: isLast
                ? null
                : const Border(
                    bottom: BorderSide(color: _C.border, width: 0.5)),
          ),
          child: Row(children: [
            SizedBox(
                width: 22,
                child: Text(_emojis[i],
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center)),
            const SizedBox(width: 8),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: _avatarBg[i], borderRadius: BorderRadius.circular(8)),
              child: Center(
                  child: Text(
                (e.name?.isNotEmpty == true) ? e.name[0].toUpperCase() : 'U',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12),
              )),
            ),
            const SizedBox(width: 8),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Flexible(
                        child: Text(e.name?.split(' ').first ?? '',
                            style: const TextStyle(
                                color: _C.textPri,
                                fontWeight: FontWeight.w700,
                                fontSize: 12),
                            overflow: TextOverflow.ellipsis)),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                            color: _C.greenLight,
                            borderRadius: BorderRadius.circular(99)),
                        child: const Text('আপনি',
                            style: TextStyle(
                                color: _C.darkGreen,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ]),
                  if (e.id != null || e.district != null)
                    Text('ID: ${e.id ?? ''} · ${e.district ?? ''}',
                        style: const TextStyle(color: _C.textSec, fontSize: 9),
                        overflow: TextOverflow.ellipsis),
                ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: _rankColors[i].withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(children: [
                Text('${e.totalPoints}',
                    style: TextStyle(
                        color: _rankColors[i],
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        height: 1)),
                Text('pts',
                    style: TextStyle(
                        color: _rankColors[i].withOpacity(0.55),
                        fontSize: 7,
                        fontWeight: FontWeight.w600)),
              ]),
            ),
          ]),
        ).animate().fadeIn(delay: Duration(milliseconds: i * 50));
      })),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COMMUNITY ROW
// ─────────────────────────────────────────────────────────────────────────────

class _CommunityRow extends StatelessWidget {
  final VoidCallback onRate, onShare;
  const _CommunityRow({required this.onRate, required this.onShare});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Row(children: [
            Text('💬', style: TextStyle(fontSize: 13)),
            SizedBox(width: 6),
            Text('কমিউনিটি',
                style: TextStyle(
                    color: _C.textPri,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    letterSpacing: -0.1)),
          ])),
      Row(children: [
        Expanded(
            child: _CommCard(
                emoji: '⭐',
                title: 'রেটিং দিন',
                subtitle: 'Play Store এ রিভিউ',
                bg: const Color(0xFFFFFBF0),
                border: const Color(0xFFFFE082),
                accent: const Color(0xFF7A4500),
                iconBg: const Color(0xFFFFECB3),
                onTap: onRate)),
        const SizedBox(width: 10),
        Expanded(
            child: _CommCard(
                emoji: '📤',
                title: 'শেয়ার করুন',
                subtitle: 'বন্ধুদের জানান',
                bg: const Color(0xFFEFF6FF),
                border: const Color(0xFFBFDBFE),
                accent: const Color(0xFF1D4ED8),
                iconBg: const Color(0xFFDBEAFE),
                onTap: onShare)),
      ]),
    ]);
  }
}

class _CommCard extends StatelessWidget {
  final String emoji, title, subtitle;
  final Color bg, border, accent, iconBg;
  final VoidCallback onTap;
  const _CommCard(
      {required this.emoji,
      required this.title,
      required this.subtitle,
      required this.bg,
      required this.border,
      required this.accent,
      required this.iconBg,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: 0.8)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: iconBg, borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 17)))),
            const Spacer(),
            Icon(Icons.arrow_outward_rounded,
                size: 13, color: accent.withOpacity(0.45)),
          ]),
          const SizedBox(height: 9),
          Text(title,
              style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: -0.2)),
          const SizedBox(height: 2),
          Text(subtitle,
              style: TextStyle(
                  color: accent.withOpacity(0.55),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500)),
        ]),
      ));
}

// ─────────────────────────────────────────────────────────────────────────────
// HOW IT WORKS
// ─────────────────────────────────────────────────────────────────────────────

class _HowItWorks extends StatelessWidget {
  final VoidCallback onTap;
  const _HowItWorks({required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.border, width: 0.5)),
        child: Row(children: [
          Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                  color: _C.greenLight,
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.help_outline_rounded,
                  color: _C.darkGreen, size: 18)),
          const SizedBox(width: 10),
          const Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('এটি কীভাবে কাজ করে?',
                    style: TextStyle(
                        color: _C.textPri,
                        fontWeight: FontWeight.w700,
                        fontSize: 12)),
                SizedBox(height: 1),
                Text('পয়েন্ট, র‍্যাংকিং ও আমল সম্পর্কে জানুন',
                    style: TextStyle(color: _C.textSec, fontSize: 10.5)),
              ])),
          const Icon(Icons.chevron_right_rounded, color: _C.textHint, size: 18),
        ]),
      ));
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED
// ─────────────────────────────────────────────────────────────────────────────

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();
  @override
  Widget build(BuildContext context) => Container(
        height: 120,
        decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.border, width: 0.5)),
      ).animate(onPlay: (c) => c.repeat()).shimmer(
          duration: 1200.ms,
          colors: [_C.card, const Color(0xFFE8ECE8), _C.card]);
}

class _EmptyCard extends StatelessWidget {
  final String label;
  const _EmptyCard({required this.label});
  @override
  Widget build(BuildContext context) => Container(
      height: 80,
      decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _C.border, width: 0.5)),
      child: Center(
          child: Text(label,
              style: const TextStyle(
                  color: _C.textHint,
                  fontSize: 13,
                  fontWeight: FontWeight.w500))));
}

class SectionHeaderCompact extends StatelessWidget {
  final String title, action;
  final VoidCallback onAction;
  const SectionHeaderCompact(
      {required this.title,
      required this.action,
      required this.onAction,
      super.key});
  @override
  Widget build(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title,
            style: const TextStyle(
                color: _C.textPri, fontWeight: FontWeight.w700, fontSize: 11)),
        GestureDetector(
            onTap: onAction,
            child: Text(action,
                style: const TextStyle(
                    color: _C.darkGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.w600))),
      ]);
}
