// // import 'package:amal_tracker/features/home/widgets/app_tagline.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:go_router/go_router.dart';

// // import '../../auth/providers/auth_provider.dart';
// // import '../../tracker/providers/tracker_provider.dart';
// // import '../../tracker/models/tracker_model.dart';
// // import '../../leaderboard/providers/leaderboard_provider.dart';
// // import '../../../core/router/app_router.dart';
// // import '../../../core/constants/app_constants.dart';
// // import '../../notification/widgets/notification_widgets.dart';
// // import '../../home/widgets/profile_sheet.dart';

// // // ─────────────────────────────────────────────────────────────────────────────
// // // DESIGN TOKENS
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _C {
// //   static const pageBg = Color(0xFFF4F6F1);
// //   static const card = Color(0xFFFFFFFF);
// //   static const darkGreen = Color(0xFF0E3D22);
// //   static const midGreen = Color(0xFF1B7045);
// //   static const gold = Color(0xFFD4A843);
// //   static const goldLight = Color(0xFFFFF3E0);
// //   static const goldBorder = Color(0xFFFFCC80);
// //   static const green = Color(0xFF16A34A);
// //   static const greenLight = Color(0xFFE8F5EE);
// //   static const amber = Color(0xFFF59E0B);
// //   static const red = Color(0xFFEF4444);
// //   static const textPri = Color(0xFF0A1A0F);
// //   static const textSec = Color(0xFF6B7C6E);
// //   static const textHint = Color(0xFFABBAAE);
// //   static const border = Color(0xFFE4EAE4);
// //   static const rankGold = Color(0xFFD4A843);
// //   static const rankSilver = Color(0xFF94A3B8);
// //   static const rankBronze = Color(0xFFCD7F32);
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // HOME SCREEN
// // // ─────────────────────────────────────────────────────────────────────────────

// // class HomeScreen extends ConsumerStatefulWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends ConsumerState<HomeScreen> {
// //   final _sc = ScrollController();

// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) => _loadLeaderboard());
// //   }

// //   void _loadLeaderboard() {
// //     final now = DateTime.now();
// //     final user = ref.read(currentUserProvider);
// //     ref.read(leaderboardPreviewProvider.notifier).load(
// //           LeaderboardFilter(
// //             year: now.year,
// //             month: now.month,
// //             limit: 3,
// //             gender: user?.gender,
// //           ),
// //           refresh: true,
// //         );
// //   }

// //   @override
// //   void dispose() {
// //     _sc.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _refresh() async {
// //     ref.invalidate(progressSummaryProvider);
// //     final now = DateTime.now();
// //     await ref.read(leaderboardProvider.notifier).load(
// //           LeaderboardFilter(year: now.year, month: now.month, limit: 3),
// //           refresh: true,
// //         );
// //   }

// //   void _showProfile() {
// //     showModalBottomSheet(
// //       context: context,
// //       backgroundColor: Colors.transparent,
// //       isScrollControlled: true,
// //       builder: (_) => ProfileSheet(user: ref.read(currentUserProvider)),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final user = ref.watch(currentUserProvider);
// //     // final progress = ref.watch(progressSummaryProvider);
// //     final now = DateTime.now();

// // // হোম স্ক্রিন বা ড্যাশবোর্ডে এইভাবে কল করবেন
// //     final progress = ref.watch(
// //       progressSummaryProvider((year: now.year, month: now.month)),
// //     );
// //     final board = ref.watch(leaderboardPreviewProvider);

// //     // ref.listen<LeaderboardState>(leaderboardPreviewProvider, (_, next) {
// //     //   if (!next.isLoading && next.entries.isEmpty) _loadLeaderboard();
// //     // });

// //     return AnnotatedRegion<SystemUiOverlayStyle>(
// //       value: SystemUiOverlayStyle.dark,
// //       child: Scaffold(
// //         backgroundColor: _C.pageBg,
// //         appBar: _TopBar(user: user, onAvatarTap: _showProfile),
// //         body: RefreshIndicator(
// //           color: _C.darkGreen,
// //           onRefresh: _refresh,
// //           child: CustomScrollView(
// //             controller: _sc,
// //             physics: const AlwaysScrollableScrollPhysics(),
// //             slivers: [
// //               SliverPadding(
// //                 padding: const EdgeInsets.fromLTRB(14, 12, 14, 90),
// //                 sliver: SliverList(
// //                   delegate: SliverChildListDelegate([
// //                     // ── Greeting ──────────────────────────────────────────
// //                     _Greeting(user: user, progress: progress)
// //                         .animate()
// //                         .fadeIn(duration: 280.ms),

// //                     const SizedBox(height: 12),

// //                     // ── Hero card ─────────────────────────────────────────
// //                     progress
// //                         .when(
// //                           loading: () => const _HeroSkeleton(),
// //                           error: (_, __) => _HeroCard(
// //                               summary: null,
// //                               onTap: () => context.go(AppRoutes.tracker)),
// //                           data: (s) => _HeroCard(
// //                               summary: s,
// //                               onTap: () => context.push(AppRoutes.tracker)),
// //                         )
// //                         .animate()
// //                         .fadeIn(delay: 50.ms, duration: 300.ms),

// //                     const SizedBox(height: 12),

// //                     // ── Weekly bar chart ───────────────────────────────────
// //                     progress
// //                         .when(
// //                           loading: () => const _WeekSkeleton(),
// //                           error: (_, __) => const _WeekChart(summary: null),
// //                           data: (s) => _WeekChart(summary: s),
// //                         )
// //                         .animate()
// //                         .fadeIn(delay: 90.ms, duration: 280.ms),

// //                     const SizedBox(height: 20),

// //                     // ── Monthly progress ──────────────────────────────────
// //                     _SecHead(
// //                       title: 'মাসিক অগ্রগতি',
// //                       emoji: '📊',
// //                       onSeeAll: () => context.go(AppRoutes.monthlyView),
// //                     ).animate().fadeIn(delay: 120.ms),

// //                     const SizedBox(height: 8),

// //                     progress
// //                         .when(
// //                           loading: () => const _ListSkeleton(),
// //                           error: (_, __) =>
// //                               const _EmptyCard(label: 'ডেটা লোড ব্যর্থ'),
// //                           data: (s) => s.recentMonths.isEmpty
// //                               ? const _EmptyCard(label: 'কোনো রেকর্ড নেই')
// //                               : _MonthList(trackers: s.recentMonths),
// //                         )
// //                         .animate()
// //                         .fadeIn(delay: 140.ms),

// //                     const SizedBox(height: 20),

// //                     // ── Leaderboard ───────────────────────────────────────
// //                     _SecHead(
// //                       title: 'শীর্ষ তালিকা',
// //                       emoji: '🏆',
// //                       onSeeAll: () => context.push(AppRoutes.leaderboard),
// //                     ).animate().fadeIn(delay: 160.ms),

// //                     const SizedBox(height: 8),

// //                     (board.isLoading
// //                             ? const _ListSkeleton()
// //                             : board.entries.isEmpty
// //                                 ? const _EmptyCard(label: 'ডেটা নেই')
// //                                 : _LeaderList(
// //                                     entries: board.entries.take(3).toList(),
// //                                     currentUserId:
// //                                         ref.read(currentUserProvider)?.id,
// //                                   ))
// //                         .animate()
// //                         .fadeIn(delay: 180.ms),

// //                     const SizedBox(height: 20),

// //                     // ── How it works ──────────────────────────────────────
// //                     _HowItWorks(onTap: () => context.push(AppRoutes.howItWorks))
// //                         .animate()
// //                         .fadeIn(delay: 200.ms),
// //                   ]),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // TOP BAR
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _TopBar extends StatelessWidget implements PreferredSizeWidget {
// //   final dynamic user;
// //   final VoidCallback onAvatarTap;

// //   const _TopBar({this.user, required this.onAvatarTap});

// //   @override
// //   Size get preferredSize => const Size.fromHeight(54);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: _C.card,
// //       child: SafeArea(
// //         bottom: false,
// //         child: SizedBox(
// //           height: 54,
// //           child: Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 16),
// //             child: Row(
// //               children: [
// //                 // Logo
// //                 Container(
// //                   width: 30,
// //                   height: 30,
// //                   decoration: BoxDecoration(
// //                     color: _C.darkGreen,
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                   child: ClipRRect(
// //                     borderRadius: BorderRadius.circular(8),
// //                     child: Image.asset(
// //                       'assets/images/sabeq_logo.png',
// //                       width: 30,
// //                       height: 30,
// //                       fit: BoxFit.cover,
// //                       errorBuilder: (_, __, ___) => const Icon(
// //                         Icons.eco_rounded,
// //                         color: Colors.white,
// //                         size: 15,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 // Logo এর পাশে name + subtitle column
// //                 const SizedBox(width: 10),
// //                 Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const Text(
// //                       'Sabeq',
// //                       style: TextStyle(
// //                         color: _C.textPri,
// //                         fontWeight: FontWeight.w800,
// //                         fontSize: 15,
// //                         letterSpacing: -0.3,
// //                       ),
// //                     ),
// //                     const AppTagline()
// //                   ],
// //                 ),
// //                 // const SizedBox(width: 10),
// //                 // const Text(
// //                 //   'Sabeq',
// //                 //   style: TextStyle(
// //                 //     color: _C.textPri,
// //                 //     fontWeight: FontWeight.w800,
// //                 //     fontSize: 15,
// //                 //     letterSpacing: -0.3,
// //                 //   ),
// //                 // ),
// //                 const Spacer(),
// //                 const NotificationBellWidget(),
// //                 const SizedBox(width: 8),
// //                 const SettingsButtonWidget(),
// //                 const SizedBox(width: 8),
// //                 GestureDetector(
// //                   onTap: onAvatarTap,
// //                   child: Container(
// //                     width: 35,
// //                     height: 35,
// //                     decoration: BoxDecoration(
// //                       color: _C.darkGreen,
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     child: Center(
// //                       child: Text(
// //                         (user?.name?.isNotEmpty == true)
// //                             ? user!.name[0].toUpperCase()
// //                             : 'U',
// //                         style: const TextStyle(
// //                           color: Colors.white,
// //                           fontWeight: FontWeight.w800,
// //                           fontSize: 12,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // GREETING ROW
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _Greeting extends StatelessWidget {
// //   final dynamic user;
// //   final AsyncValue<ProgressSummary> progress;

// //   const _Greeting({this.user, required this.progress});

// //   @override
// //   Widget build(BuildContext context) {
// //     final streak =
// //         progress.whenOrNull(data: (s) => s.currentMonth?.streakDays) ?? 0;
// //     const days = [
// //       'রবিবার',
// //       'সোমবার',
// //       'মঙ্গলবার',
// //       'বুধবার',
// //       'বৃহস্পতিবার',
// //       'শুক্রবার',
// //       'শনিবার'
// //     ];
// //     final now = DateTime.now();
// //     final weekday = days[now.weekday % 7];
// //     final month = AppConstants.bengaliMonths[now.month - 1];

// //     return Row(
// //       crossAxisAlignment: CrossAxisAlignment.center,
// //       children: [
// //         Expanded(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 'আস-সালামু আলাইকুম',
// //                 style: const TextStyle(
// //                   color: _C.textHint,
// //                   fontSize: 10.5,
// //                   fontWeight: FontWeight.w500,
// //                 ),
// //               ),
// //               const SizedBox(height: 1),
// //               Text(
// //                 user?.name?.split(' ').first ?? 'বন্ধু',
// //                 style: const TextStyle(
// //                   color: _C.textPri,
// //                   fontWeight: FontWeight.w800,
// //                   fontSize: 22,
// //                   height: 1.1,
// //                   letterSpacing: -0.5,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //         if (streak > 0)
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //             decoration: BoxDecoration(
// //               color: _C.goldLight,
// //               borderRadius: BorderRadius.circular(99),
// //               border: Border.all(color: _C.goldBorder, width: 0.5),
// //             ),
// //             child: Row(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 const Text('🔥', style: TextStyle(fontSize: 12)),
// //                 const SizedBox(width: 4),
// //                 Text(
// //                   '$streak দিন',
// //                   style: const TextStyle(
// //                     color: Color(0xFFE65100),
// //                     fontSize: 12,
// //                     fontWeight: FontWeight.w700,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //       ],
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // HERO CARD
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _HeroCard extends StatelessWidget {
// //   final ProgressSummary? summary;
// //   final VoidCallback onTap;

// //   const _HeroCard({this.summary, required this.onTap});

// //   @override
// //   Widget build(BuildContext context) {
// //     final hasToday = (summary?.todayEntry?.totalPoints ?? 0) > 0;
// //     final pct =
// //         (summary?.currentMonth?.completionPercentage ?? 0).clamp(0.0, 100.0);
// //     final pts = summary?.currentMonth?.totalPoints ?? 0;
// //     final rank = summary?.currentMonth?.rank;
// //     final completed = summary?.currentMonth?.daysCompleted ?? 0;
// //     final now = DateTime.now();
// //     final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
// //     final month = AppConstants.bengaliMonths[now.month - 1];
// //     final district =
// //         summary?.todayEntry?.userId != null ? null : null; // pulled from user

// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         decoration: BoxDecoration(
// //           color: _C.darkGreen,
// //           borderRadius: BorderRadius.circular(16),
// //         ),
// //         child: Stack(
// //           children: [
// //             // Decorative circle
// //             Positioned(
// //               top: -30,
// //               right: -30,
// //               child: Container(
// //                 width: 100,
// //                 height: 100,
// //                 decoration: BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   color: Colors.white.withOpacity(0.04),
// //                 ),
// //               ),
// //             ),

// //             Padding(
// //               padding: const EdgeInsets.all(16),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   // ── Top row: left content + right stats ──────────────
// //                   Row(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       // Left
// //                       Expanded(
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             // Tag
// //                             Row(
// //                               children: [
// //                                 Icon(
// //                                   Icons.calendar_today_rounded,
// //                                   size: 10,
// //                                   color: Colors.white.withOpacity(0.35),
// //                                 ),
// //                                 const SizedBox(width: 4),
// //                                 Text(
// //                                   'আজকের আমল',
// //                                   style: TextStyle(
// //                                     color: Colors.white.withOpacity(0.4),
// //                                     fontSize: 10,
// //                                     fontWeight: FontWeight.w500,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                             const SizedBox(height: 6),
// //                             // Title
// //                             Text(
// //                               hasToday
// //                                   ? 'আজকের আমল\nরেকর্ড করা হয়েছে ✓'
// //                                   : 'আজ কোনো আমল\nরেকর্ড করা হয়নি',
// //                               style: const TextStyle(
// //                                 color: Colors.white,
// //                                 fontSize: 17,
// //                                 fontWeight: FontWeight.w800,
// //                                 height: 1.25,
// //                                 letterSpacing: -0.2,
// //                               ),
// //                             ),
// //                             const SizedBox(height: 10),
// //                             // CTA button
// //                             Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                   horizontal: 12, vertical: 8),
// //                               decoration: BoxDecoration(
// //                                 color: hasToday
// //                                     ? Colors.white.withOpacity(0.1)
// //                                     : _C.gold,
// //                                 borderRadius: BorderRadius.circular(9),
// //                                 border: hasToday
// //                                     ? Border.all(
// //                                         color: Colors.white.withOpacity(0.2),
// //                                         width: 0.5)
// //                                     : null,
// //                               ),
// //                               child: Row(
// //                                 mainAxisSize: MainAxisSize.min,
// //                                 children: [
// //                                   Icon(
// //                                     hasToday
// //                                         ? Icons.edit_rounded
// //                                         : Icons.add_rounded,
// //                                     color: Colors.white,
// //                                     size: 13,
// //                                   ),
// //                                   const SizedBox(width: 6),
// //                                   Text(
// //                                     hasToday ? 'আপডেট করুন' : 'রেকর্ড করুন',
// //                                     style: const TextStyle(
// //                                       color: Colors.white,
// //                                       fontSize: 12,
// //                                       fontWeight: FontWeight.w700,
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),

// //                       const SizedBox(width: 12),

// //                       // Right: points + rank
// //                       Column(
// //                         crossAxisAlignment: CrossAxisAlignment.end,
// //                         children: [
// //                           // Points
// //                           Text(
// //                             '$pts',
// //                             style: const TextStyle(
// //                               color: _C.gold,
// //                               fontSize: 26,
// //                               fontWeight: FontWeight.w800,
// //                               height: 1,
// //                               letterSpacing: -1,
// //                             ),
// //                           ),
// //                           Text(
// //                             'মাসের পয়েন্ট',
// //                             style: TextStyle(
// //                               color: Colors.white.withOpacity(0.35),
// //                               fontSize: 9,
// //                             ),
// //                           ),
// //                           const SizedBox(height: 6),
// //                           // Rank chip
// //                           if (rank != null)
// //                             Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                   horizontal: 8, vertical: 5),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.white.withOpacity(0.08),
// //                                 borderRadius: BorderRadius.circular(8),
// //                                 border: Border.all(
// //                                   color: Colors.white.withOpacity(0.12),
// //                                   width: 0.5,
// //                                 ),
// //                               ),
// //                               child: Column(
// //                                 children: [
// //                                   Text(
// //                                     '#$rank',
// //                                     style: const TextStyle(
// //                                       color: _C.gold,
// //                                       fontSize: 12,
// //                                       fontWeight: FontWeight.w700,
// //                                       height: 1,
// //                                     ),
// //                                   ),
// //                                   const SizedBox(height: 2),
// //                                   Text(
// //                                     'র‍্যাংক',
// //                                     style: TextStyle(
// //                                       color: Colors.white.withOpacity(0.35),
// //                                       fontSize: 8.5,
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),

// //                   const SizedBox(height: 8),

// //                   // ── Meta row: days + district ─────────────────────────
// //                   _HeroMetaRow(
// //                     completed: completed,
// //                     daysInMonth: daysInMonth,
// //                   ),

// //                   // ── Progress bar ──────────────────────────────────────
// //                   Container(
// //                     margin: const EdgeInsets.only(top: 12),
// //                     padding: const EdgeInsets.only(top: 12),
// //                     decoration: const BoxDecoration(
// //                       border: Border(
// //                         top: BorderSide(color: Color(0x1AFFFFFF), width: 0.5),
// //                       ),
// //                     ),
// //                     child: Row(
// //                       children: [
// //                         Text(
// //                           '$month মাস',
// //                           style: TextStyle(
// //                             color: Colors.white.withOpacity(0.35),
// //                             fontSize: 9.5,
// //                           ),
// //                         ),
// //                         const SizedBox(width: 8),
// //                         Expanded(
// //                           child: ClipRRect(
// //                             borderRadius: BorderRadius.circular(99),
// //                             child: LinearProgressIndicator(
// //                               value: pct / 100,
// //                               minHeight: 3,
// //                               backgroundColor: Colors.white.withOpacity(0.1),
// //                               valueColor: const AlwaysStoppedAnimation(_C.gold),
// //                             ),
// //                           ),
// //                         ),
// //                         const SizedBox(width: 8),
// //                         Text(
// //                           '${pct.toInt()}%',
// //                           style: const TextStyle(
// //                             color: _C.gold,
// //                             fontSize: 10,
// //                             fontWeight: FontWeight.w700,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _HeroMetaRow extends StatelessWidget {
// //   final int completed;
// //   final int daysInMonth;

// //   const _HeroMetaRow({
// //     required this.completed,
// //     required this.daysInMonth,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       children: [
// //         _HeroMeta(value: '$completed', label: 'দিন সম্পন্ন'),
// //         _heroDivider(),
// //         _HeroMeta(value: '$daysInMonth', label: 'মোট দিন'),
// //       ],
// //     );
// //   }

// //   Widget _heroDivider() => Container(
// //         width: 1,
// //         height: 12,
// //         color: Colors.white.withOpacity(0.12),
// //         margin: const EdgeInsets.symmetric(horizontal: 12),
// //       );
// // }

// // class _HeroMeta extends StatelessWidget {
// //   final String value, label;

// //   const _HeroMeta({required this.value, required this.label});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         Text(
// //           value,
// //           style: TextStyle(
// //             fontSize: 11,
// //             fontWeight: FontWeight.w700,
// //             color: Colors.white.withOpacity(0.8),
// //           ),
// //         ),
// //         const SizedBox(width: 4),
// //         Text(
// //           label,
// //           style: TextStyle(
// //             fontSize: 9.5,
// //             color: Colors.white.withOpacity(0.35),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // class _HeroSkeleton extends StatelessWidget {
// //   const _HeroSkeleton();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       height: 185,
// //       decoration: BoxDecoration(
// //         color: _C.darkGreen.withOpacity(0.7),
// //         borderRadius: BorderRadius.circular(16),
// //       ),
// //     ).animate(onPlay: (c) => c.repeat()).shimmer(
// //       duration: 1400.ms,
// //       colors: [
// //         Colors.white.withOpacity(0.03),
// //         Colors.white.withOpacity(0.08),
// //         Colors.white.withOpacity(0.03),
// //       ],
// //     );
// //   }
// // }

// // class _WeekChart extends StatelessWidget {
// //   final ProgressSummary? summary;

// //   const _WeekChart({this.summary});

// //   @override
// //   Widget build(BuildContext context) {
// //     // ১. ব্যাকএন্ডের ডাইনামিক ৭ দিনের লিস্ট নিয়ে আসা
// //     final weekData = summary?.currentWeek ?? [];
// //     final weekTotal = summary?.weeklyPoints ?? 0;

// //     // আজকের বারের নাম বের করা (Sun, Mon...) ব্যাকএন্ডের সাথে ডাইনামিকালি ম্যাচ করার জন্য
// //     final String todayName = DateTime.now().weekday == 7
// //         ? 'Sun'
// //         : [
// //             'Mon',
// //             'Tue',
// //             'Wed',
// //             'Thu',
// //             'Fri',
// //             'Sat'
// //           ][DateTime.now().weekday - 1];

// //     // ২. কালার অপাসিটি বা ব্রাইটনেস রেশিওর জন্য সর্বোচ্চ পয়েন্ট বের করা
// //     int maxVal = 1;
// //     for (var data in weekData) {
// //       if (data.points > maxVal) maxVal = data.points;
// //     }

// //     return Container(
// //       padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
// //       decoration: BoxDecoration(
// //         color: _C.card,
// //         borderRadius: BorderRadius.circular(14),
// //         border: Border.all(color: _C.border, width: 0.5),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // ── টপ হেডার সামারি ──
// //           Row(
// //             children: [
// //               const Text(
// //                 'এই সপ্তাহ',
// //                 style: TextStyle(
// //                   color: _C.textPri,
// //                   fontWeight: FontWeight.w700,
// //                   fontSize: 12,
// //                 ),
// //               ),
// //               const Spacer(),
// //               Text(
// //                 '$weekTotal pts',
// //                 style: const TextStyle(
// //                   color: _C.green,
// //                   fontWeight: FontWeight.w700,
// //                   fontSize: 11,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 14),

// //           // ── ডাইনামিক স্কয়ার বক্স চার্ট লেআউট ──
// //           if (weekData.isEmpty)
// //             const Center(
// //               child: Padding(
// //                 padding: EdgeInsets.symmetric(vertical: 10),
// //                 child: Text('কোনো রেকর্ড নেই',
// //                     style: TextStyle(color: _C.textSec, fontSize: 11)),
// //               ),
// //             )
// //           else
// //             Row(
// //               crossAxisAlignment: CrossAxisAlignment.end,
// //               children: weekData.map((data) {
// //                 final isToday = data.day == todayName;

// //                 // ৩. ডাইনামিক ব্রাইটনেস/অপাসিটি ক্যালকুলেশন (পয়েন্ট যত বেশি, কালার তত গাঢ়)
// //                 // মিনিমাম ০.১৫ দেওয়া হয়েছে যেন একদম কম পয়েন্ট হলেও বক্সটি হালকা দৃশ্যমান থাকে
// //                 final double opacityFactor =
// //                     maxVal > 0 ? (data.points / maxVal).clamp(0.15, 1.0) : 0.15;

// //                 // বেস কালার সিলেকশন (এক্সেম্পট ডে হলে অ্যাম্বার, সাধারণ দিনে সবুজ)
// //                 Color baseColor = data.isExemptDay ? _C.amber : _C.green;

// //                 // ৪. ফাইনাল ডাইনামিক ফিল কালার (পয়েন্ট ০ হলে গ্রে বর্ডার কালার শো করবে)
// //                 Color finalBoxColor = data.points > 0
// //                     ? baseColor.withOpacity(opacityFactor)
// //                     : _C.pageBg;

// //                 // টেক্সট কালার মেইনটেইন (গাঢ় বক্সে সাদা লেখা, হালকা বক্সে কালো লেখা যেন রিডেবল হয়)
// //                 Color textAndDayColor = data.points > 0
// //                     ? (opacityFactor > 0.5 && !data.isExemptDay
// //                         ? Colors.white
// //                         : _C.textPri)
// //                     : _C.textHint;

// //                 return Expanded(
// //                   child: Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 2.5),
// //                     child: Column(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         // 🔳 রিয়াল স্কয়ার বক্স লেআউট (AspectRatio ব্যবহার করে নিখুঁত Square বা ৪ কোনাকার করা হয়েছে)
// //                         AspectRatio(
// //                           aspectRatio:
// //                               1.0, // ১.০ মানে উইথ এবং হাইট একদম সমান (Square)
// //                           child: Container(
// //                             alignment: Alignment.center,
// //                             decoration: BoxDecoration(
// //                               color: finalBoxColor,
// //                               borderRadius: BorderRadius.circular(
// //                                   6), // সামান্য রাউন্ডেড স্কয়ার কর্নার
// //                               border: isToday
// //                                   ? Border.all(
// //                                       color: _C.gold,
// //                                       width: 1.8) // আজকের দিনে গোল্ডেন বর্ডার
// //                                   : (data.points == 0
// //                                       ? Border.all(color: _C.border, width: 0.8)
// //                                       : null),
// //                             ),
// //                             child: Text(
// //                               '${data.points}',
// //                               style: TextStyle(
// //                                 color: textAndDayColor,
// //                                 fontSize: 10,
// //                                 fontWeight: FontWeight.w900,
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                         const SizedBox(height: 6),

// //                         // ডাইনামিক বারের নাম (বাংলায়)
// //                         Text(
// //                           _getBengaliDayName(data.day),
// //                           style: TextStyle(
// //                             fontSize: 9.5,
// //                             color: isToday ? _C.gold : _C.textSec,
// //                             fontWeight:
// //                                 isToday ? FontWeight.w900 : FontWeight.w500,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 );
// //               }).toList(),
// //             ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ইংলিশ 'Sun', 'Mon' কে বাংলায় 'র', 'সো' কনভার্ট করার মেথড
// //   String _getBengaliDayName(String englishDay) {
// //     switch (englishDay) {
// //       case 'Sun':
// //         return 'র';
// //       case 'Mon':
// //         return 'সো';
// //       case 'Tue':
// //         return 'ম';
// //       case 'Wed':
// //         return 'বু';
// //       case 'Thu':
// //         return 'বৃ';
// //       case 'Fri':
// //         return 'শু';
// //       case 'Sat':
// //         return 'শ';
// //       default:
// //         return englishDay;
// //     }
// //   }
// // }

// // class _WeekSkeleton extends StatelessWidget {
// //   const _WeekSkeleton();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       height: 80,
// //       decoration: BoxDecoration(
// //         color: _C.card,
// //         borderRadius: BorderRadius.circular(14),
// //         border: Border.all(color: _C.border, width: 0.5),
// //       ),
// //     ).animate(onPlay: (c) => c.repeat()).shimmer(
// //       duration: 1200.ms,
// //       colors: [_C.card, const Color(0xFFE8ECE8), _C.card],
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SECTION HEADER
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _SecHead extends StatelessWidget {
// //   final String title, emoji;
// //   final VoidCallback onSeeAll;

// //   const _SecHead({
// //     required this.title,
// //     required this.emoji,
// //     required this.onSeeAll,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       children: [
// //         Text(emoji, style: const TextStyle(fontSize: 13)),
// //         const SizedBox(width: 6),
// //         Text(
// //           title,
// //           style: const TextStyle(
// //             color: _C.textPri,
// //             fontWeight: FontWeight.w800,
// //             fontSize: 13,
// //             letterSpacing: -0.1,
// //           ),
// //         ),
// //         const Spacer(),
// //         GestureDetector(
// //           onTap: onSeeAll,
// //           child: Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
// //             decoration: BoxDecoration(
// //               color: _C.greenLight,
// //               borderRadius: BorderRadius.circular(99),
// //             ),
// //             child: const Text(
// //               'সব দেখুন →',
// //               style: TextStyle(
// //                 color: _C.darkGreen,
// //                 fontSize: 10,
// //                 fontWeight: FontWeight.w700,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // MONTHLY LIST
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _MonthList extends StatelessWidget {
// //   final List<MonthlyTracker> trackers;

// //   const _MonthList({required this.trackers});

// //   @override
// //   Widget build(BuildContext context) {
// //     final items = trackers.take(3).toList();

// //     return Container(
// //       decoration: BoxDecoration(
// //         color: _C.card,
// //         borderRadius: BorderRadius.circular(14),
// //         border: Border.all(color: _C.border, width: 0.5),
// //       ),
// //       child: Column(
// //         children: List.generate(items.length, (i) {
// //           final t = items[i];
// //           final month = AppConstants.bengaliMonths[t.month - 1];
// //           final pct = (t.completionPercentage / 100).clamp(0.0, 1.0);
// //           final barColor = pct > 0.7
// //               ? _C.green
// //               : pct > 0.4
// //                   ? _C.amber
// //                   : _C.red;
// //           final isLast = i == items.length - 1;

// //           return Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// //             decoration: BoxDecoration(
// //               border: isLast
// //                   ? null
// //                   : const Border(
// //                       bottom: BorderSide(color: _C.border, width: 0.5)),
// //             ),
// //             child: Row(
// //               children: [
// //                 // Dot
// //                 Container(
// //                   width: 7,
// //                   height: 7,
// //                   decoration:
// //                       BoxDecoration(color: barColor, shape: BoxShape.circle),
// //                 ),
// //                 const SizedBox(width: 10),

// //                 // Month
// //                 SizedBox(
// //                   width: 45,
// //                   child: Row(
// //                     children: [
// //                       Text(
// //                         month,
// //                         style: const TextStyle(
// //                           color: _C.textPri,
// //                           fontWeight: FontWeight.w700,
// //                           fontSize: 12,
// //                         ),
// //                       ),
// //                       if (t.isWinner) ...[
// //                         const SizedBox(width: 3),
// //                         const Text('🏆', style: TextStyle(fontSize: 9)),
// //                       ],
// //                     ],
// //                   ),
// //                 ),

// //                 const SizedBox(width: 8),

// //                 // Bar
// //                 Expanded(
// //                   child: Row(
// //                     crossAxisAlignment: CrossAxisAlignment.center,
// //                     children: [
// //                       Text(
// //                         '${(pct * 100).toInt()}%',
// //                         style: const TextStyle(
// //                           color: ColorT.textHint,
// //                           fontSize: 9,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                       const SizedBox(width: 3),
// //                       Expanded(
// //                         child: ClipRRect(
// //                           borderRadius: BorderRadius.circular(99),
// //                           child: LinearProgressIndicator(
// //                             value: pct,
// //                             minHeight: 3,
// //                             backgroundColor: _C.pageBg,
// //                             valueColor: AlwaysStoppedAnimation(barColor),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),

// //                 const SizedBox(width: 10),

// //                 // Points
// //                 Row(
// //                   children: [
// //                     Text(
// //                       '${t.totalPoints}',
// //                       style: TextStyle(
// //                         color: barColor,
// //                         fontWeight: FontWeight.w800,
// //                         fontSize: 13,
// //                       ),
// //                     ),
// //                     const SizedBox(
// //                       width: 3,
// //                     ),
// //                     Text(
// //                       'pts',
// //                       style: TextStyle(
// //                         color: barColor.withOpacity(0.55),
// //                         fontSize: 9,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ).animate().fadeIn(delay: Duration(milliseconds: i * 50));
// //         }),
// //       ),
// //     );
// //   }
// // }

// // class MonthList extends StatelessWidget {
// //   final List<MonthlyTracker> trackers;

// //   const MonthList({required this.trackers});

// //   @override
// //   Widget build(BuildContext context) {
// //     final items = trackers.take(3).toList();

// //     return Container(
// //       decoration: BoxDecoration(
// //         color: ColorT.cardBg,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: ColorT.border, width: 0.5),
// //       ),
// //       child: Column(
// //         children: List.generate(items.length, (i) {
// //           final t = items[i];
// //           final month = AppConstants.bengaliMonths[t.month - 1];
// //           final pct = (t.completionPercentage / 100).clamp(0.0, 1.0);
// //           final barColor = pct > 0.7
// //               ? ColorT.green
// //               : pct > 0.4
// //                   ? ColorT.amber
// //                   : ColorT.red;
// //           final isLast = i == items.length - 1;

// //           return Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
// //             decoration: BoxDecoration(
// //               border: isLast
// //                   ? null
// //                   : const Border(
// //                       bottom: BorderSide(color: ColorT.border, width: 0.5),
// //                     ),
// //             ),
// //             child: Row(
// //               children: [
// //                 // Color dot
// //                 Container(
// //                   width: 9,
// //                   height: 9,
// //                   decoration: BoxDecoration(
// //                     color: barColor,
// //                     shape: BoxShape.circle,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 10),

// //                 // Month name
// //                 SizedBox(
// //                   width: 48,
// //                   child: Row(
// //                     children: [
// //                       Text(
// //                         month,
// //                         style: const TextStyle(
// //                           color: ColorT.textPrimary,
// //                           fontWeight: FontWeight.w700,
// //                           fontSize: 13,
// //                         ),
// //                       ),
// //                       if (t.isWinner) ...[
// //                         const SizedBox(width: 4),
// //                         const Text('🏆', style: TextStyle(fontSize: 10)),
// //                       ],
// //                     ],
// //                   ),
// //                 ),

// //                 const SizedBox(width: 10),

// //                 // Progress bar
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       ClipRRect(
// //                         borderRadius: BorderRadius.circular(99),
// //                         child: LinearProgressIndicator(
// //                           value: pct,
// //                           minHeight: 5,
// //                           backgroundColor: ColorT.pageBg,
// //                           valueColor: AlwaysStoppedAnimation(barColor),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 3),
// //                       Text(
// //                         '${(pct * 100).toInt()}% সম্পন্ন',
// //                         style: const TextStyle(
// //                           color: ColorT.textHint,
// //                           fontSize: 9,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),

// //                 const SizedBox(width: 12),

// //                 // Points
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.end,
// //                   children: [
// //                     Text(
// //                       '${t.totalPoints}',
// //                       style: TextStyle(
// //                         color: barColor,
// //                         fontWeight: FontWeight.w800,
// //                         fontSize: 15,
// //                         height: 1,
// //                       ),
// //                     ),
// //                     Text(
// //                       'pts',
// //                       style: TextStyle(
// //                         color: barColor.withOpacity(0.55),
// //                         fontSize: 9,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ).animate().fadeIn(delay: Duration(milliseconds: i * 60));
// //         }),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // LEADERBOARD LIST
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _LeaderboardList extends StatelessWidget {
// //   final List entries;

// //   const _LeaderboardList({required this.entries});

// //   static const _emojis = ['🥇', '🥈', '🥉'];
// //   static const _rankColors = [
// //     ColorT.rankGold,
// //     ColorT.rankSilver,
// //     ColorT.rankBronze
// //   ];
// //   static const _rankBg = [
// //     Color(0xFFFFFBF0),
// //     Color(0xFFF8FAFC),
// //     Color(0xFFFFF7ED),
// //   ];
// //   static const _avatarColors = [
// //     Color(0xFF0E3D22),
// //     Color(0xFF374151),
// //     Color(0xFF7C3AED),
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: ColorT.cardBg,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: ColorT.border, width: 0.5),
// //       ),
// //       child: Column(
// //         children: List.generate(entries.length, (i) {
// //           final entry = entries[i];
// //           final isLast = i == entries.length - 1;

// //           return Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
// //             decoration: BoxDecoration(
// //               color: _rankBg[i],
// //               borderRadius: BorderRadius.vertical(
// //                 top: i == 0 ? const Radius.circular(16) : Radius.zero,
// //                 bottom: isLast ? const Radius.circular(16) : Radius.zero,
// //               ),
// //               border: isLast
// //                   ? null
// //                   : const Border(
// //                       bottom: BorderSide(color: ColorT.border, width: 0.5),
// //                     ),
// //             ),
// //             child: Row(
// //               children: [
// //                 // Rank emoji
// //                 SizedBox(
// //                   width: 28,
// //                   child: Text(
// //                     _emojis[i],
// //                     style: const TextStyle(fontSize: 20),
// //                     textAlign: TextAlign.center,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 8),

// //                 // Avatar
// //                 Container(
// //                   width: 36,
// //                   height: 36,
// //                   decoration: BoxDecoration(
// //                     color: _avatarColors[i],
// //                     borderRadius: BorderRadius.circular(11),
// //                   ),
// //                   child: Center(
// //                     child: Text(
// //                       (entry.name?.isNotEmpty == true)
// //                           ? entry.name[0].toUpperCase()
// //                           : 'U',
// //                       style: const TextStyle(
// //                         color: Colors.white,
// //                         fontWeight: FontWeight.w800,
// //                         fontSize: 15,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 10),

// //                 // Name + department
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         entry.name?.split(' ').first ?? '',
// //                         style: const TextStyle(
// //                           color: ColorT.textPrimary,
// //                           fontWeight: FontWeight.w700,
// //                           fontSize: 13,
// //                         ),
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                       if (entry?.id != null || entry?.district != null) ...[
// //                         Text(
// //                           'ID: ${entry?.id ?? ''} • ${entry?.district ?? ''}',
// //                           style: const TextStyle(
// //                             color: ColorT.textSecondary,
// //                             fontSize: 9.5,
// //                           ),
// //                           overflow: TextOverflow.ellipsis,
// //                         ),
// //                       ],
// //                     ],
// //                   ),
// //                 ),

// //                 // Points badge
// //                 Container(
// //                   padding:
// //                       const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
// //                   decoration: BoxDecoration(
// //                     color: _rankColors[i].withOpacity(0.12),
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                   child: Column(
// //                     children: [
// //                       Text(
// //                         '${entry.totalPoints}',
// //                         style: TextStyle(
// //                           color: _rankColors[i],
// //                           fontWeight: FontWeight.w900,
// //                           fontSize: 16,
// //                           height: 1,
// //                         ),
// //                       ),
// //                       Text(
// //                         'pts',
// //                         style: TextStyle(
// //                           color: _rankColors[i].withOpacity(0.55),
// //                           fontSize: 8,
// //                           fontWeight: FontWeight.w600,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ).animate().fadeIn(delay: Duration(milliseconds: i * 60));
// //         }),
// //       ),
// //     );
// //   }
// // }

// // class _LeaderList extends StatelessWidget {
// //   final List entries;
// //   final String? currentUserId;

// //   const _LeaderList({required this.entries, this.currentUserId});

// //   static const _emojis = ['🥇', '🥈', '🥉'];
// //   static const _ptsColors = [_C.rankGold, _C.rankSilver, _C.rankBronze];
// //   static const _rowBg = [
// //     Color(0xFFFFFBF0),
// //     Color(0xFFF8FAFC),
// //     Color(0xFFFFF7ED),
// //   ];
// //   static const _avatarBg = [
// //     Color(0xFF0E3D22),
// //     Color(0xFF374151),
// //     Color(0xFF7C3AED),
// //   ];

// //   static const _rankColors = [
// //     ColorT.rankGold,
// //     ColorT.rankSilver,
// //     ColorT.rankBronze
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: _C.card,
// //         borderRadius: BorderRadius.circular(14),
// //         border: Border.all(color: _C.border, width: 0.5),
// //       ),
// //       child: Column(
// //         children: List.generate(entries.length, (i) {
// //           final e = entries[i];
// //           final isLast = i == entries.length - 1;
// //           final isMe =
// //               currentUserId != null && e.userId?.toString() == currentUserId;

// //           return Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
// //             decoration: BoxDecoration(
// //               color: _rowBg[i],
// //               borderRadius: BorderRadius.vertical(
// //                 top: i == 0 ? const Radius.circular(14) : Radius.zero,
// //                 bottom: isLast ? const Radius.circular(14) : Radius.zero,
// //               ),
// //               border: isLast
// //                   ? null
// //                   : const Border(
// //                       bottom: BorderSide(color: _C.border, width: 0.5)),
// //             ),
// //             child: Row(
// //               children: [
// //                 // Rank emoji
// //                 SizedBox(
// //                   width: 22,
// //                   child: Text(
// //                     _emojis[i],
// //                     style: const TextStyle(fontSize: 16),
// //                     textAlign: TextAlign.center,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 8),

// //                 // Avatar
// //                 Container(
// //                   width: 30,
// //                   height: 30,
// //                   decoration: BoxDecoration(
// //                     color: _avatarBg[i],
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                   child: Center(
// //                     child: Text(
// //                       (e.name?.isNotEmpty == true)
// //                           ? e.name[0].toUpperCase()
// //                           : 'U',
// //                       style: const TextStyle(
// //                         color: Colors.white,
// //                         fontWeight: FontWeight.w800,
// //                         fontSize: 12,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 8),

// //                 // Name + meta
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         children: [
// //                           Flexible(
// //                             child: Text(
// //                               e.name?.split(' ').first ?? '',
// //                               style: const TextStyle(
// //                                 color: _C.textPri,
// //                                 fontWeight: FontWeight.w700,
// //                                 fontSize: 12,
// //                               ),
// //                               overflow: TextOverflow.ellipsis,
// //                             ),
// //                           ),
// //                           if (isMe) ...[
// //                             const SizedBox(width: 4),
// //                             Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                   horizontal: 5, vertical: 1),
// //                               decoration: BoxDecoration(
// //                                 color: _C.greenLight,
// //                                 borderRadius: BorderRadius.circular(99),
// //                               ),
// //                               child: const Text(
// //                                 'আপনি',
// //                                 style: TextStyle(
// //                                   color: _C.darkGreen,
// //                                   fontSize: 8.5,
// //                                   fontWeight: FontWeight.w700,
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ],
// //                       ),
// //                       if (e.id != null || e.district != null)
// //                         Text(
// //                           'ID: ${e.id ?? ''} · ${e.district ?? ''}',
// //                           style: const TextStyle(
// //                             color: _C.textSec,
// //                             fontSize: 9,
// //                           ),
// //                           overflow: TextOverflow.ellipsis,
// //                         ),
// //                     ],
// //                   ),
// //                 ),

// //                 // Points
// //                 Container(
// //                   padding:
// //                       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //                   decoration: BoxDecoration(
// //                     color: _rankColors[i].withOpacity(0.12),
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                   child: Column(
// //                     children: [
// //                       Text(
// //                         '${e.totalPoints}',
// //                         style: TextStyle(
// //                           color: _rankColors[i],
// //                           fontWeight: FontWeight.w900,
// //                           fontSize: 13,
// //                           height: 1,
// //                         ),
// //                       ),
// //                       Text(
// //                         'pts',
// //                         style: TextStyle(
// //                           color: _rankColors[i].withOpacity(0.55),
// //                           fontSize: 7,
// //                           fontWeight: FontWeight.w600,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 // Text(
// //                 //   '${e.totalPoints}',
// //                 //   style: TextStyle(
// //                 //     color: _ptsColors[i],
// //                 //     fontWeight: FontWeight.w800,
// //                 //     fontSize: 13,
// //                 //   ),
// //                 // ),
// //               ],
// //             ),
// //           ).animate().fadeIn(delay: Duration(milliseconds: i * 50));
// //         }),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // HOW IT WORKS
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _HowItWorks extends StatelessWidget {
// //   final VoidCallback onTap;

// //   const _HowItWorks({required this.onTap});

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
// //         decoration: BoxDecoration(
// //           color: _C.card,
// //           borderRadius: BorderRadius.circular(14),
// //           border: Border.all(color: _C.border, width: 0.5),
// //         ),
// //         child: Row(
// //           children: [
// //             Container(
// //               width: 34,
// //               height: 34,
// //               decoration: BoxDecoration(
// //                 color: _C.greenLight,
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //               child: const Icon(
// //                 Icons.help_outline_rounded,
// //                 color: _C.darkGreen,
// //                 size: 18,
// //               ),
// //             ),
// //             const SizedBox(width: 10),
// //             const Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     'এটি কীভাবে কাজ করে?',
// //                     style: TextStyle(
// //                       color: _C.textPri,
// //                       fontWeight: FontWeight.w700,
// //                       fontSize: 12,
// //                     ),
// //                   ),
// //                   SizedBox(height: 1),
// //                   Text(
// //                     'পয়েন্ট, র‍্যাংকিং ও আমল সম্পর্কে জানুন',
// //                     style: TextStyle(
// //                       color: _C.textSec,
// //                       fontSize: 10.5,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             const Icon(
// //               Icons.chevron_right_rounded,
// //               color: _C.textHint,
// //               size: 18,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SHARED HELPERS
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _ListSkeleton extends StatelessWidget {
// //   const _ListSkeleton();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       height: 120,
// //       decoration: BoxDecoration(
// //         color: _C.card,
// //         borderRadius: BorderRadius.circular(14),
// //         border: Border.all(color: _C.border, width: 0.5),
// //       ),
// //     ).animate(onPlay: (c) => c.repeat()).shimmer(
// //       duration: 1200.ms,
// //       colors: [_C.card, const Color(0xFFE8ECE8), _C.card],
// //     );
// //   }
// // }

// // class _EmptyCard extends StatelessWidget {
// //   final String label;

// //   const _EmptyCard({required this.label});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       height: 80,
// //       decoration: BoxDecoration(
// //         color: _C.card,
// //         borderRadius: BorderRadius.circular(14),
// //         border: Border.all(color: _C.border, width: 0.5),
// //       ),
// //       child: Center(
// //         child: Text(
// //           label,
// //           style: const TextStyle(
// //             color: _C.textHint,
// //             fontSize: 13,
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // PUBLIC ALIAS (kept for compatibility)
// // // ─────────────────────────────────────────────────────────────────────────────

// // class SectionHeaderCompact extends StatelessWidget {
// //   final String title, action;
// //   final VoidCallback onAction;

// //   const SectionHeaderCompact({
// //     required this.title,
// //     required this.action,
// //     required this.onAction,
// //     super.key,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Text(title,
// //             style: const TextStyle(
// //                 color: _C.textPri, fontWeight: FontWeight.w700, fontSize: 11)),
// //         GestureDetector(
// //           onTap: onAction,
// //           child: Text(action,
// //               style: const TextStyle(
// //                   color: _C.darkGreen,
// //                   fontSize: 10,
// //                   fontWeight: FontWeight.w600)),
// //         ),
// //       ],
// //     );
// //   }
// // }
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

// // // compact right-side chip
// // class _RightChip extends StatelessWidget {
// //   final String top, bottom;
// //   const _RightChip({required this.top, required this.bottom});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withOpacity(0.08),
// //         borderRadius: BorderRadius.circular(7),
// //         border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
// //       ),
// //       child: Column(mainAxisSize: MainAxisSize.min, children: [
// //         Text(top,
// //             style: const TextStyle(
// //                 color: _C.gold,
// //                 fontSize: 11,
// //                 fontWeight: FontWeight.w700,
// //                 height: 1)),
// //         const SizedBox(height: 2),
// //         Text(bottom,
// //             style:
// //                 TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 8)),
// //       ]),
// //     );
// //   }
// // }

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

// // class _HeroCard extends StatelessWidget {
// //   final ProgressSummary? summary;
// //   final VoidCallback onTap;
// //   const _HeroCard({this.summary, required this.onTap});

// //   String _winnerLabel(String? cat) {
// //     switch (cat) {
// //       case 'TOP_FARZ':
// //         return 'ফরজ চ্যাম্পিয়ন';
// //       case 'TOP_EFFORT':
// //         return 'সর্বোচ্চ পয়েন্ট';
// //       case 'TOP_STREAK':
// //         return 'সেরা স্ট্রিক';
// //       default:
// //         return 'মাসিক বিজয়ী';
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final today = summary?.todayEntry;
// //     final month = summary?.currentMonth;
// //     final isFemale = summary?.userGender == 'female';

// //     final todayPts = today?.totalPoints ?? 0;
// //     final isExempt = (today?.isExemptDay ?? false) && isFemale;
// //     final hasToday = todayPts > 0 || isExempt;

// //     final monthPts = month?.totalPoints ?? 0;
// //     final pct = (month?.completionPercentage ?? 0).clamp(0.0, 100.0);
// //     final daysComp = month?.daysCompleted ?? 0;
// //     final rank = month?.rank;
// //     final isWinner = month?.isWinner ?? false;
// //     final farzDays = month?.farzCompletedDays ?? 0;
// //     final eligDays = month?.eligibleDays ?? 0;
// //     final fardPts = month?.fardPoints ?? 0;

// //     final now = DateTime.now();
// //     final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
// //     final monthName = AppConstants.bengaliMonths[now.month - 1];

// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         decoration: BoxDecoration(
// //           color: _C.darkGreen,
// //           borderRadius: BorderRadius.circular(16),
// //         ),
// //         child: Stack(children: [
// //           // Decorative circles
// //           Positioned(
// //               top: -40,
// //               right: -40,
// //               child: Container(
// //                   width: 120,
// //                   height: 120,
// //                   decoration: const BoxDecoration(
// //                       shape: BoxShape.circle, color: Color(0x07FFFFFF)))),
// //           Positioned(
// //               bottom: -20,
// //               left: -10,
// //               child: Container(
// //                   width: 80,
// //                   height: 80,
// //                   decoration: const BoxDecoration(
// //                       shape: BoxShape.circle, color: Color(0x05FFFFFF)))),

// //           Padding(
// //             padding: const EdgeInsets.all(16),
// //             child:
// //                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //               // ── Winner banner (if applicable) ─────────────────────────
// //               if (isWinner) ...[
// //                 Container(
// //                   margin: const EdgeInsets.only(bottom: 10),
// //                   padding:
// //                       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //                   decoration: BoxDecoration(
// //                     color: _C.gold.withOpacity(0.18),
// //                     borderRadius: BorderRadius.circular(8),
// //                     border: Border.all(
// //                         color: _C.gold.withOpacity(0.35), width: 0.5),
// //                   ),
// //                   child: Row(mainAxisSize: MainAxisSize.min, children: [
// //                     const Text('🏆', style: TextStyle(fontSize: 11)),
// //                     const SizedBox(width: 6),
// //                     Text(_winnerLabel(month?.winnerCategory),
// //                         style: const TextStyle(
// //                             color: _C.gold,
// //                             fontSize: 11,
// //                             fontWeight: FontWeight.w700)),
// //                   ]),
// //                 ),
// //               ],

// //               // ── Main row ──────────────────────────────────────────────
// //               Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //                 // Left: today status + CTA
// //                 Expanded(
// //                     child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                       // Today label
// //                       Row(children: [
// //                         Icon(Icons.wb_sunny_rounded,
// //                             size: 10, color: Colors.white.withOpacity(0.35)),
// //                         const SizedBox(width: 4),
// //                         Text(isExempt ? 'আজ মাফের দিন 🌙' : 'আজকের আমল',
// //                             style: TextStyle(
// //                                 color: Colors.white.withOpacity(0.4),
// //                                 fontSize: 10,
// //                                 fontWeight: FontWeight.w500)),
// //                       ]),
// //                       const SizedBox(height: 5),

// //                       // Today points big
// //                       if (todayPts > 0) ...[
// //                         RichText(
// //                             text: TextSpan(children: [
// //                           TextSpan(
// //                               text: '$todayPts',
// //                               style: const TextStyle(
// //                                   color: Colors.white,
// //                                   fontSize: 28,
// //                                   fontWeight: FontWeight.w900,
// //                                   height: 1,
// //                                   letterSpacing: -1)),
// //                           const TextSpan(
// //                               text: ' pts',
// //                               style: TextStyle(
// //                                   color: Color(0x80FFFFFF),
// //                                   fontSize: 12,
// //                                   fontWeight: FontWeight.w500)),
// //                         ])),
// //                         const SizedBox(height: 2),
// //                         Text('আজকের পয়েন্ট',
// //                             style: TextStyle(
// //                                 color: Colors.white.withOpacity(0.35),
// //                                 fontSize: 9.5)),
// //                       ] else if (isExempt) ...[
// //                         const Text('মাফের দিন',
// //                             style: TextStyle(
// //                                 color: Colors.white,
// //                                 fontSize: 18,
// //                                 fontWeight: FontWeight.w800,
// //                                 height: 1.2)),
// //                         const SizedBox(height: 2),
// //                         Text('নামাজ/রোজা বাদ',
// //                             style: TextStyle(
// //                                 color: Colors.white.withOpacity(0.35),
// //                                 fontSize: 9.5)),
// //                       ] else ...[
// //                         const Text('এখনো রেকর্ড\nহয়নি',
// //                             style: TextStyle(
// //                                 color: Colors.white,
// //                                 fontSize: 17,
// //                                 fontWeight: FontWeight.w800,
// //                                 height: 1.25,
// //                                 letterSpacing: -0.2)),
// //                       ],

// //                       const SizedBox(height: 10),

// //                       // CTA button
// //                       Container(
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 12, vertical: 7),
// //                         decoration: BoxDecoration(
// //                           color: hasToday
// //                               ? Colors.white.withOpacity(0.1)
// //                               : _C.gold,
// //                           borderRadius: BorderRadius.circular(9),
// //                           border: hasToday
// //                               ? Border.all(
// //                                   color: Colors.white.withOpacity(0.2),
// //                                   width: 0.5)
// //                               : null,
// //                         ),
// //                         child: Row(mainAxisSize: MainAxisSize.min, children: [
// //                           Icon(
// //                               hasToday ? Icons.edit_rounded : Icons.add_rounded,
// //                               color: Colors.white,
// //                               size: 12),
// //                           const SizedBox(width: 5),
// //                           Text(hasToday ? 'আপডেট করুন' : 'রেকর্ড করুন',
// //                               style: const TextStyle(
// //                                   color: Colors.white,
// //                                   fontSize: 11,
// //                                   fontWeight: FontWeight.w700)),
// //                         ]),
// //                       ),
// //                     ])),

// //                 const SizedBox(width: 12),

// //                 // Right: month pts + rank
// //                 Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
// //                   Text(_fmt(monthPts),
// //                       style: TextStyle(
// //                           color: _C.gold,
// //                           fontSize: monthPts >= 10000 ? 22 : 26,
// //                           fontWeight: FontWeight.w800,
// //                           height: 1,
// //                           letterSpacing: -1)),
// //                   Text('মাসের পয়েন্ট',
// //                       style: TextStyle(
// //                           color: Colors.white.withOpacity(0.35), fontSize: 9)),
// //                   const SizedBox(height: 6),
// //                   if (rank != null)
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 8, vertical: 5),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white.withOpacity(0.08),
// //                         borderRadius: BorderRadius.circular(8),
// //                         border: Border.all(
// //                             color: Colors.white.withOpacity(0.12), width: 0.5),
// //                       ),
// //                       child: Column(children: [
// //                         Text('#$rank',
// //                             style: const TextStyle(
// //                                 color: _C.gold,
// //                                 fontSize: 12,
// //                                 fontWeight: FontWeight.w700,
// //                                 height: 1)),
// //                         const SizedBox(height: 2),
// //                         Text('র‍্যাংক',
// //                             style: TextStyle(
// //                                 color: Colors.white.withOpacity(0.35),
// //                                 fontSize: 8.5)),
// //                       ]),
// //                     ),
// //                 ]),
// //               ]),

// //               const SizedBox(height: 12),

// //               // ── 3 mini stat chips ─────────────────────────────────────
// //               Row(children: [
// //                 _HeroChip(
// //                     value: '$daysComp/$daysInMonth', label: 'সম্পন্ন দিন'),
// //                 _heroDivider(),
// //                 _HeroChip(
// //                     value: '$farzDays${eligDays > 0 ? '/$eligDays' : ''}',
// //                     label: 'পূর্ণ ফরজ'),
// //                 _heroDivider(),
// //                 _HeroChip(value: _fmt(fardPts), label: 'ফরজ pts'),
// //               ]),

// //               const SizedBox(height: 10),

// //               // ── Fard completion bar ───────────────────────────────────
// //               // completionPercentage = backend formula: (farzDays + exemptDays) / eligibleDays * 100
// //               Container(
// //                 padding: const EdgeInsets.only(top: 10),
// //                 decoration: const BoxDecoration(
// //                     border: Border(
// //                         top: BorderSide(color: Color(0x1AFFFFFF), width: 0.5))),
// //                 child: Row(children: [
// //                   Text('$monthName মাস',
// //                       style: TextStyle(
// //                           color: Colors.white.withOpacity(0.35),
// //                           fontSize: 9.5)),
// //                   const SizedBox(width: 8),
// //                   Expanded(
// //                       child: ClipRRect(
// //                     borderRadius: BorderRadius.circular(99),
// //                     child: LinearProgressIndicator(
// //                         value: pct / 100,
// //                         minHeight: 4,
// //                         backgroundColor: Colors.white.withOpacity(0.1),
// //                         valueColor: const AlwaysStoppedAnimation(_C.gold)),
// //                   )),
// //                   const SizedBox(width: 8),
// //                   Text('${pct.toInt()}%',
// //                       style: const TextStyle(
// //                           color: _C.gold,
// //                           fontSize: 10,
// //                           fontWeight: FontWeight.w700)),
// //                 ]),
// //               ),
// //             ]),
// //           ),
// //         ]),
// //       ),
// //     );
// //   }

// //   static Widget _heroDivider() => Container(
// //       width: 1,
// //       height: 14,
// //       color: Colors.white.withOpacity(0.12),
// //       margin: const EdgeInsets.symmetric(horizontal: 10));
// // }

// // class _HeroChip extends StatelessWidget {
// //   final String value, label;
// //   const _HeroChip({required this.value, required this.label});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //       Text(value,
// //           style: const TextStyle(
// //               fontSize: 12,
// //               fontWeight: FontWeight.w700,
// //               color: Colors.white,
// //               height: 1)),
// //       const SizedBox(height: 2),
// //       Text(label,
// //           style: TextStyle(fontSize: 9, color: Colors.white.withOpacity(0.35))),
// //     ]);
// //   }
// // }

// // class _HeroSkeleton extends StatelessWidget {
// //   const _HeroSkeleton();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       height: 195,
// //       decoration: BoxDecoration(
// //           color: _C.darkGreen.withOpacity(0.7),
// //           borderRadius: BorderRadius.circular(16)),
// //     ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1400.ms, colors: [
// //       Colors.white.withOpacity(0.03),
// //       Colors.white.withOpacity(0.08),
// //       Colors.white.withOpacity(0.03)
// //     ]);
// //   }
// // }

// // class _WeekStrip extends StatelessWidget {
// //   final ProgressSummary? summary;
// //   const _WeekStrip({this.summary});

// //   static const _bnDay = {
// //     'Sun': 'র',
// //     'Mon': 'সো',
// //     'Tue': 'ম',
// //     'Wed': 'বু',
// //     'Thu': 'বৃ',
// //     'Fri': 'শু',
// //     'Sat': 'শ',
// //   };

// //   @override
// //   Widget build(BuildContext context) {
// //     final weekData = summary?.currentWeek ?? [];
// //     final weekTotal = summary?.weeklyPoints ?? 0;
// //     final isFemale = summary?.userGender == 'female';

// //     final today = DateTime.now();
// //     final maxPts =
// //         weekData.map((d) => d.points).fold(0, (a, b) => a > b ? a : b);
// //     final safePts = maxPts < 1 ? 1 : maxPts;

// //     return Container(
// //       padding: const EdgeInsets.fromLTRB(13, 10, 13, 10),
// //       decoration: BoxDecoration(
// //           color: _C.card,
// //           borderRadius: BorderRadius.circular(13),
// //           border: Border.all(color: _C.border, width: 0.5)),
// //       child: Column(mainAxisSize: MainAxisSize.min, children: [
// //         // Header
// //         Row(children: [
// //           const Text('এই সপ্তাহ',
// //               style: TextStyle(
// //                   color: _C.textPri,
// //                   fontWeight: FontWeight.w700,
// //                   fontSize: 11)),
// //           const Spacer(),
// //           if (weekTotal > 0) ...[
// //             Text('$weekTotal',
// //                 style: const TextStyle(
// //                     color: _C.green,
// //                     fontWeight: FontWeight.w800,
// //                     fontSize: 11)),
// //             const Text(' pts',
// //                 style: TextStyle(
// //                     color: _C.textHint,
// //                     fontSize: 10,
// //                     fontWeight: FontWeight.w500)),
// //           ],
// //         ]),

// //         const SizedBox(height: 8),

// //         if (weekData.isEmpty)
// //           Padding(
// //             padding: const EdgeInsets.symmetric(vertical: 4),
// //             child: Row(
// //               children: List.generate(
// //                   7,
// //                   (i) => Expanded(
// //                           child: Container(
// //                         margin: const EdgeInsets.symmetric(horizontal: 2),
// //                         height: 28,
// //                         decoration: BoxDecoration(
// //                             color: _C.pageBg,
// //                             borderRadius: BorderRadius.circular(4),
// //                             border: Border.all(color: _C.border, width: 0.5)),
// //                       ))),
// //             ),
// //           )
// //         else
// //           LayoutBuilder(builder: (ctx, constraints) {
// //             final barAreaH = (constraints.maxWidth * 0.26).clamp(28.0, 52.0);
// //             const dayLblH = 12.0;
// //             const ptsLblH = 12.0;
// //             const gap = 2.0;
// //             // total height = pts label + gap + bars + gap + day label
// //             final totalH = ptsLblH + gap + barAreaH + gap + dayLblH;

// //             return SizedBox(
// //               height: totalH,
// //               child: Row(
// //                 crossAxisAlignment: CrossAxisAlignment.end,
// //                 children: weekData.map((d) {
// //                   final dayDate = DateTime.tryParse(d.date);
// //                   final isToday = dayDate != null &&
// //                       dayDate.year == today.year &&
// //                       dayDate.month == today.month &&
// //                       dayDate.day == today.day;
// //                   final isFuture = dayDate != null && dayDate.isAfter(today);
// //                   final showExempt = d.isExemptDay && isFemale;
// //                   final fillFrac =
// //                       d.points > 0 ? (d.points / safePts).clamp(0.0, 1.0) : 0.0;
// //                   final barH = fillFrac > 0
// //                       ? (fillFrac * barAreaH).clamp(4.0, barAreaH)
// //                       : 0.0;

// //                   // opacity: 0.35 (কম pts) → 1.0 (বেশি pts)
// //                   final colorOpacity = fillFrac > 0
// //                       ? (0.35 + fillFrac * 0.65).clamp(0.35, 1.0)
// //                       : 0.0;

// //                   return Expanded(
// //                     child: Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 2),
// //                       child: Column(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           // pts label — bar এর উপরে
// //                           SizedBox(
// //                             height: ptsLblH,
// //                             child: Center(
// //                               child: d.points > 0
// //                                   ? FittedBox(
// //                                       fit: BoxFit.scaleDown,
// //                                       child: Text(
// //                                         '${d.points}',
// //                                         style: TextStyle(
// //                                           fontSize: 7.5,
// //                                           color: isToday
// //                                               ? _C.darkGreen
// //                                               : _C.textHint.withOpacity(
// //                                                   colorOpacity + 0.2),
// //                                           fontWeight: isToday
// //                                               ? FontWeight.w800
// //                                               : FontWeight.w600,
// //                                         ),
// //                                       ),
// //                                     )
// //                                   : const SizedBox.shrink(),
// //                             ),
// //                           ),

// //                           const SizedBox(height: gap),

// //                           // bar area — bottom aligned
// //                           Expanded(
// //                             child: Align(
// //                               alignment: Alignment.bottomCenter,
// //                               child: showExempt
// //                                   ? Container(
// //                                       height: (barAreaH * 0.6)
// //                                           .clamp(16.0, barAreaH),
// //                                       width: double.infinity,
// //                                       decoration: BoxDecoration(
// //                                         color: const Color(0xFFEDE9FE),
// //                                         borderRadius: BorderRadius.circular(5),
// //                                       ),
// //                                       child: const Center(
// //                                           child: Text('🌙',
// //                                               style: TextStyle(fontSize: 7))),
// //                                     )
// //                                   : barH > 0
// //                                       ? Container(
// //                                           height: barH,
// //                                           width: double.infinity,
// //                                           decoration: BoxDecoration(
// //                                             gradient: LinearGradient(
// //                                               begin: Alignment.bottomCenter,
// //                                               end: Alignment.topCenter,
// //                                               colors: isToday
// //                                                   ? [_C.darkGreen, _C.midGreen]
// //                                                   : [
// //                                                       _C.midGreen.withOpacity(
// //                                                           colorOpacity * 0.7),
// //                                                       _C.midGreen.withOpacity(
// //                                                           colorOpacity),
// //                                                     ],
// //                                             ),
// //                                             borderRadius:
// //                                                 BorderRadius.circular(5),
// //                                             boxShadow: isToday
// //                                                 ? [
// //                                                     BoxShadow(
// //                                                       color: _C.darkGreen
// //                                                           .withOpacity(0.3),
// //                                                       blurRadius: 5,
// //                                                       offset:
// //                                                           const Offset(0, 2),
// //                                                     )
// //                                                   ]
// //                                                 : null,
// //                                           ),
// //                                         )
// //                                       : Align(
// //                                           alignment: Alignment.bottomCenter,
// //                                           child: Container(
// //                                             height: 3,
// //                                             width: double.infinity,
// //                                             decoration: BoxDecoration(
// //                                               color: isFuture
// //                                                   ? Colors.transparent
// //                                                   : _C.pageBg,
// //                                               borderRadius:
// //                                                   BorderRadius.circular(2),
// //                                               border: Border.all(
// //                                                   color: isFuture
// //                                                       ? Colors.transparent
// //                                                       : _C.border,
// //                                                   width: 0.5),
// //                                             ),
// //                                           ),
// //                                         ),
// //                             ),
// //                           ),

// //                           const SizedBox(height: gap),

// //                           // day label
// //                           SizedBox(
// //                             height: dayLblH,
// //                             child: Center(
// //                               child: Text(
// //                                 _bnDay[d.day] ?? d.day,
// //                                 style: TextStyle(
// //                                   fontSize: 8.5,
// //                                   color: isToday ? _C.darkGreen : _C.textHint,
// //                                   fontWeight: isToday
// //                                       ? FontWeight.w800
// //                                       : FontWeight.w500,
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   );
// //                 }).toList(),
// //               ),
// //             );
// //           }),
// //       ]),
// //     );
// //   }
// // }

// // Color _weekBarColor(double fillFrac) {
// //   if (fillFrac >= 0.6) return _C.midGreen;
// //   if (fillFrac >= 0.3) return const Color(0xFFFFA726);
// //   return const Color(0xFFE57373);
// // }

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
