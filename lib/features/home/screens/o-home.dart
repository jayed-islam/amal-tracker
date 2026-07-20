// // import 'package:amal_tracker/features/home/widgets/daily_cards_section.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:go_router/go_router.dart';
// // import 'package:in_app_review/in_app_review.dart';
// // import 'package:share_plus/share_plus.dart';
// // import 'package:url_launcher/url_launcher.dart';

// // import '../../auth/providers/auth_provider.dart';
// // import '../../tracker/providers/tracker_provider.dart';
// // import '../../tracker/models/tracker_model.dart';
// // import '../../leaderboard/providers/leaderboard_provider.dart';
// // import '../../../core/router/app_router.dart';
// // import '../../../core/constants/app_constants.dart';
// // import '../../notification/widgets/notification_widgets.dart';
// // import '../../home/widgets/profile_sheet.dart';
// // // import '../widgets/new.dart';

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

// // String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}K' : '$n';

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
// //     // জাস্ট ডেটা ফ্রেশ রাখার জন্য ইনভ্যালিডেট করে দাও, কোনো এপিআই কল এখানে পুশ হবে না
// //     ref.invalidate(leaderboardProvider);
// //   }

// //   @override
// //   void dispose() {
// //     _sc.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _refresh() async {
// //     final now = DateTime.now();

// //     ref.invalidate(progressSummaryProvider((year: now.year, month: now.month)));
// //     ref.invalidate(leaderboardProvider);

// //     await Future.delayed(const Duration(milliseconds: 500));
// //   }

// //   void _showProfile() => showModalBottomSheet(
// //         context: context,
// //         backgroundColor: Colors.transparent,
// //         isScrollControlled: true,
// //         builder: (_) => ProfileSheet(user: ref.read(currentUserProvider)),
// //       );

// //   Future<void> _handleRateApp() async {
// //     final review = InAppReview.instance;
// //     if (await review.isAvailable()) {
// //       await review.requestReview();
// //     } else {
// //       final uri = Uri.parse(
// //           'https://play.google.com/store/apps/details?id=com.yourcompany.sabeq');
// //       if (await canLaunchUrl(uri))
// //         launchUrl(uri, mode: LaunchMode.externalApplication);
// //     }
// //   }

// //   Future<void> _handleShareApp() async {
// //     await Share.share(
// //       'Sabeq — নেক আমল ট্র্যাক করুন, র‍্যাংকিং এ এগিয়ে যান!\n\n'
// //       '📲 ডাউনলোড করুন:\nhttps://play.google.com/store/apps/details?id=com.yourcompany.sabeq',
// //       subject: 'Sabeq অ্যাপ — নেক আমলে এগিয়ে যাও',
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final user = ref.watch(currentUserProvider);
// //     final now = DateTime.now();
// //     final progress =
// //         ref.watch(progressSummaryProvider((year: now.year, month: now.month)));
// //     final board = ref.watch(leaderboardPreviewProvider);

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
// //                 padding: const EdgeInsets.fromLTRB(0, 12, 0, 90),
// //                 sliver: SliverList(
// //                   delegate: SliverChildListDelegate([
// //                     // ── 1. Greeting ──────────────────────────────────────
// //                     Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 14.0),
// //                       child: _Greeting(user: user, progress: progress)
// //                           .animate()
// //                           .fadeIn(duration: 280.ms),
// //                     ),
// //                     const SizedBox(height: 12),

// //                     // ── 2. Hero Card ─────────────────────────────────────
// //                     Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 14.0),
// //                       child: progress
// //                           .when(
// //                             loading: () => const _HeroSkeleton(),
// //                             error: (_, __) => _HeroCard(
// //                                 summary: null,
// //                                 onTap: () => context.go(AppRoutes.tracker)),
// //                             data: (s) => _HeroCard(
// //                                 summary: s,
// //                                 onTap: () => context.go(AppRoutes.tracker)),
// //                           )
// //                           .animate()
// //                           .fadeIn(delay: 50.ms, duration: 300.ms),
// //                     ),
// //                     const SizedBox(height: 10),

// //                     // ── 3. Weekly Chart ───────────────────────────────────
// //                     Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 14.0),
// //                       child: progress
// //                           .when(
// //                             loading: () => const _WeekSkeleton(),
// //                             error: (_, __) => const _WeekStrip(summary: null),
// //                             data: (s) => _WeekStrip(summary: s),
// //                           )
// //                           .animate()
// //                           .fadeIn(delay: 90.ms, duration: 280.ms),
// //                     ),

// //                     const SizedBox(height: 11),
// //                     const DailyCardsSection(),

// //                     const SizedBox(height: 11),
// //                     // const SizedBox(height: 20),

// //                     Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 14.0),
// //                       child: Column(children: [
// //                         progress.when(
// //                           loading: () => const SizedBox.shrink(),
// //                           error: (_, __) => const SizedBox.shrink(),
// //                           data: (s) {
// //                             // skip current month (index 0) — already in hero card
// //                             final recentMonths = s.recentMonths;
// //                             if (recentMonths.isEmpty)
// //                               return const SizedBox.shrink();
// //                             return Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 _SecHead(
// //                                   title: 'মাসিক অগ্রগতি',
// //                                   emoji: '📅',
// //                                   onSeeAll: () =>
// //                                       context.go(AppRoutes.monthlyView),
// //                                 ).animate().fadeIn(delay: 135.ms),
// //                                 const SizedBox(height: 10),
// //                                 _MonthHistoryList(trackers: recentMonths)
// //                                     .animate()
// //                                     .fadeIn(delay: 148.ms),
// //                                 const SizedBox(height: 20),
// //                               ],
// //                             );
// //                           },
// //                         ),

// //                         // ── 6. Leaderboard teaser ─────────────────────────────
// //                         _SecHead(
// //                           title: 'শীর্ষ তালিকা',
// //                           emoji: '🏆',
// //                           onSeeAll: () => context.go(AppRoutes.leaderboard),
// //                         ).animate().fadeIn(delay: 165.ms),
// //                         const SizedBox(height: 10),
// //                         (board.isLoading
// //                                 ? const _ListSkeleton()
// //                                 : board.entries.isEmpty
// //                                     ? const _EmptyCard(label: 'ডেটা নেই')
// //                                     : _LeaderList(
// //                                         entries: board.entries.take(3).toList(),
// //                                         currentUserId:
// //                                             ref.read(currentUserProvider)?.id,
// //                                       ))
// //                             .animate()
// //                             .fadeIn(delay: 178.ms),
// //                         const SizedBox(height: 20),

// //                         // ── 7. Community: Rate + Share ────────────────────────
// //                         _CommunityRow(
// //                                 onRate: _handleRateApp,
// //                                 onShare: _handleShareApp)
// //                             .animate()
// //                             .fadeIn(delay: 192.ms),
// //                         const SizedBox(height: 20),

// //                         // ── 8. How it works ───────────────────────────────────
// //                         _HowItWorks(
// //                                 onTap: () => context.push(AppRoutes.howItWorks))
// //                             .animate()
// //                             .fadeIn(delay: 200.ms),
// //                       ]),
// //                     )
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
// //             child: Row(children: [
// //               Container(
// //                 width: 30,
// //                 height: 30,
// //                 decoration: BoxDecoration(
// //                     color: _C.darkGreen,
// //                     borderRadius: BorderRadius.circular(8)),
// //                 child: ClipRRect(
// //                   borderRadius: BorderRadius.circular(8),
// //                   child: Image.asset('assets/images/sabeq_logo.png',
// //                       width: 30,
// //                       height: 30,
// //                       fit: BoxFit.cover,
// //                       errorBuilder: (_, __, ___) => const Icon(
// //                           Icons.eco_rounded,
// //                           color: Colors.white,
// //                           size: 15)),
// //                 ),
// //               ),
// //               const SizedBox(width: 10),
// //               Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: const [
// //                     Text('Sabeq',
// //                         style: TextStyle(
// //                             color: _C.textPri,
// //                             fontWeight: FontWeight.w800,
// //                             fontSize: 15,
// //                             letterSpacing: -0.3)),
// //                     Text('নেক আমলে এগিয়ে যাও',
// //                         style: TextStyle(
// //                             color: _C.textSec,
// //                             fontSize: 9,
// //                             fontWeight: FontWeight.w500,
// //                             letterSpacing: 0.2)),
// //                   ]),
// //               const Spacer(),
// //               const NotificationBellWidget(),
// //               const SizedBox(width: 8),
// //               const SettingsButtonWidget(),
// //               const SizedBox(width: 8),
// //               GestureDetector(
// //                 onTap: onAvatarTap,
// //                 child: Container(
// //                   width: 35,
// //                   height: 35,
// //                   decoration: BoxDecoration(
// //                       color: _C.darkGreen,
// //                       borderRadius: BorderRadius.circular(10)),
// //                   child: Center(
// //                       child: Text(
// //                     (user?.name?.isNotEmpty == true)
// //                         ? user!.name[0].toUpperCase()
// //                         : 'U',
// //                     style: const TextStyle(
// //                         color: Colors.white,
// //                         fontWeight: FontWeight.w800,
// //                         fontSize: 12),
// //                   )),
// //                 ),
// //               ),
// //             ]),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // GREETING
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _Greeting extends StatelessWidget {
// //   final dynamic user;
// //   final AsyncValue<ProgressSummary> progress;
// //   const _Greeting({this.user, required this.progress});

// //   @override
// //   Widget build(BuildContext context) {
// //     final streak =
// //         progress.whenOrNull(data: (s) => s.currentMonth?.streakDays) ?? 0;
// //     return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
// //       Expanded(
// //           child:
// //               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         const Text('আস-সালামু আলাইকুম',
// //             style: TextStyle(
// //                 color: _C.textHint,
// //                 fontSize: 10.5,
// //                 fontWeight: FontWeight.w500)),
// //         const SizedBox(height: 1),
// //         Text(user?.name?.split(' ').first ?? 'বন্ধু',
// //             style: const TextStyle(
// //                 color: _C.textPri,
// //                 fontWeight: FontWeight.w800,
// //                 fontSize: 22,
// //                 height: 1.1,
// //                 letterSpacing: -0.5)),
// //       ])),
// //       if (streak > 0)
// //         Container(
// //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //           decoration: BoxDecoration(
// //               color: _C.goldLight,
// //               borderRadius: BorderRadius.circular(99),
// //               border: Border.all(color: _C.goldBorder, width: 0.5)),
// //           child: Row(mainAxisSize: MainAxisSize.min, children: [
// //             const Text('🔥', style: TextStyle(fontSize: 12)),
// //             const SizedBox(width: 4),
// //             Text('$streak দিন',
// //                 style: const TextStyle(
// //                     color: Color(0xFFE65100),
// //                     fontSize: 12,
// //                     fontWeight: FontWeight.w700)),
// //           ]),
// //         ),
// //     ]);
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // HERO CARD
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _HeroCard extends StatelessWidget {
// //   final ProgressSummary? summary;
// //   final VoidCallback onTap;
// //   const _HeroCard({this.summary, required this.onTap});

// //   String _winnerLabel(String? cat) => switch (cat) {
// //         'TOP_FARZ' => 'ফরজ চ্যাম্পিয়ন',
// //         'TOP_EFFORT' => 'সর্বোচ্চ পয়েন্ট',
// //         'TOP_STREAK' => 'সেরা স্ট্রিক',
// //         _ => 'মাসিক বিজয়ী',
// //       };

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
// //             color: _C.darkGreen, borderRadius: BorderRadius.circular(16)),
// //         child: Stack(children: [
// //           Positioned(
// //               top: -30,
// //               right: -30,
// //               child: Container(
// //                   width: 90,
// //                   height: 90,
// //                   decoration: const BoxDecoration(
// //                       shape: BoxShape.circle, color: Color(0x08FFFFFF)))),
// //           Positioned(
// //               bottom: -15,
// //               left: -8,
// //               child: Container(
// //                   width: 60,
// //                   height: 60,
// //                   decoration: const BoxDecoration(
// //                       shape: BoxShape.circle, color: Color(0x05FFFFFF)))),
// //           Padding(
// //             padding: const EdgeInsets.all(14),
// //             child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   if (isWinner) ...[
// //                     Container(
// //                         margin: const EdgeInsets.only(bottom: 8),
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 8, vertical: 4),
// //                         decoration: BoxDecoration(
// //                             color: _C.gold.withOpacity(0.15),
// //                             borderRadius: BorderRadius.circular(6),
// //                             border: Border.all(
// //                                 color: _C.gold.withOpacity(0.3), width: 0.5)),
// //                         child: Row(mainAxisSize: MainAxisSize.min, children: [
// //                           const Text('🏆', style: TextStyle(fontSize: 10)),
// //                           const SizedBox(width: 5),
// //                           Text(_winnerLabel(month?.winnerCategory),
// //                               style: const TextStyle(
// //                                   color: _C.gold,
// //                                   fontSize: 10,
// //                                   fontWeight: FontWeight.w700)),
// //                         ])),
// //                   ],
// //                   Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
// //                     Expanded(
// //                         child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             mainAxisSize: MainAxisSize.min,
// //                             children: [
// //                           Row(children: [
// //                             Icon(Icons.wb_sunny_rounded,
// //                                 size: 9, color: Colors.white.withOpacity(0.35)),
// //                             const SizedBox(width: 3),
// //                             Text(isExempt ? 'আজ মাফের দিন 🌙' : 'আজকের আমল',
// //                                 style: TextStyle(
// //                                     color: Colors.white.withOpacity(0.4),
// //                                     fontSize: 9.5,
// //                                     fontWeight: FontWeight.w500)),
// //                           ]),
// //                           const SizedBox(height: 4),
// //                           if (todayPts > 0)
// //                             RichText(
// //                                 text: TextSpan(children: [
// //                               TextSpan(
// //                                   text: '$todayPts',
// //                                   style: const TextStyle(
// //                                       color: Colors.white,
// //                                       fontSize: 26,
// //                                       fontWeight: FontWeight.w900,
// //                                       height: 1,
// //                                       letterSpacing: -1)),
// //                               const TextSpan(
// //                                   text: ' pts',
// //                                   style: TextStyle(
// //                                       color: Color(0x80FFFFFF),
// //                                       fontSize: 11,
// //                                       fontWeight: FontWeight.w500)),
// //                             ]))
// //                           else if (isExempt)
// //                             const Text('মাফের দিন',
// //                                 style: TextStyle(
// //                                     color: Colors.white,
// //                                     fontSize: 16,
// //                                     fontWeight: FontWeight.w800,
// //                                     height: 1.1))
// //                           else
// //                             const Text('এখনো রেকর্ড\nহয়নি',
// //                                 style: TextStyle(
// //                                     color: Colors.white,
// //                                     fontSize: 15,
// //                                     fontWeight: FontWeight.w800,
// //                                     height: 1.2,
// //                                     letterSpacing: -0.2)),
// //                           const SizedBox(height: 8),
// //                           Container(
// //                             padding: const EdgeInsets.symmetric(
// //                                 horizontal: 10, vertical: 6),
// //                             decoration: BoxDecoration(
// //                               color: hasToday
// //                                   ? Colors.white.withOpacity(0.1)
// //                                   : _C.gold,
// //                               borderRadius: BorderRadius.circular(8),
// //                               border: hasToday
// //                                   ? Border.all(
// //                                       color: Colors.white.withOpacity(0.18),
// //                                       width: 0.5)
// //                                   : null,
// //                             ),
// //                             child:
// //                                 Row(mainAxisSize: MainAxisSize.min, children: [
// //                               Icon(
// //                                   hasToday
// //                                       ? Icons.edit_rounded
// //                                       : Icons.add_rounded,
// //                                   color: Colors.white,
// //                                   size: 11),
// //                               const SizedBox(width: 4),
// //                               Text(hasToday ? 'আপডেট করুন' : 'রেকর্ড করুন',
// //                                   style: const TextStyle(
// //                                       color: Colors.white,
// //                                       fontSize: 10.5,
// //                                       fontWeight: FontWeight.w700)),
// //                             ]),
// //                           ),
// //                         ])),
// //                     Container(
// //                         width: 0.5,
// //                         height: 72,
// //                         color: Colors.white.withOpacity(0.12),
// //                         margin: const EdgeInsets.symmetric(horizontal: 12)),
// //                     Column(
// //                         crossAxisAlignment: CrossAxisAlignment.end,
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Text(_fmt(monthPts),
// //                               style: TextStyle(
// //                                   color: _C.gold,
// //                                   fontSize: monthPts >= 10000 ? 20 : 24,
// //                                   fontWeight: FontWeight.w800,
// //                                   height: 1,
// //                                   letterSpacing: -1)),
// //                           const SizedBox(height: 2),
// //                           Text('মাসের পয়েন্ট',
// //                               style: TextStyle(
// //                                   color: Colors.white.withOpacity(0.35),
// //                                   fontSize: 8.5)),
// //                           const SizedBox(height: 6),
// //                           Row(mainAxisSize: MainAxisSize.min, children: [
// //                             if (rank != null) ...[
// //                               _RightChip(
// //                                   top: '#$rank',
// //                                   bottom: 'র‍্যাংক',
// //                                   isRank: true),
// //                               const SizedBox(width: 6),
// //                             ],
// //                             _RightChip(top: _fmt(fardPts), bottom: 'ফরজ pts'),
// //                           ]),
// //                         ]),
// //                   ]),
// //                   const SizedBox(height: 10),
// //                   const Divider(
// //                       height: 1, thickness: 0.5, color: Color(0x1AFFFFFF)),
// //                   const SizedBox(height: 8),
// //                   Row(children: [
// //                     _HeroChip(
// //                         value: '$daysComp/$daysInMonth', label: 'সম্পন্ন দিন'),
// //                     _heroDivider(),
// //                     _HeroChip(
// //                         value: '$farzDays${eligDays > 0 ? '/$eligDays' : ''}',
// //                         label: 'পূর্ণ ফরজ'),
// //                     _heroDivider(),
// //                     Expanded(
// //                         child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.end,
// //                             mainAxisSize: MainAxisSize.min,
// //                             children: [
// //                           Row(
// //                               mainAxisAlignment: MainAxisAlignment.end,
// //                               children: [
// //                                 Text(monthName,
// //                                     style: TextStyle(
// //                                         color: Colors.white.withOpacity(0.35),
// //                                         fontSize: 8.5)),
// //                                 const SizedBox(width: 4),
// //                                 Text('${pct.toInt()}%',
// //                                     style: const TextStyle(
// //                                         color: _C.gold,
// //                                         fontSize: 9.5,
// //                                         fontWeight: FontWeight.w700)),
// //                               ]),
// //                           const SizedBox(height: 3),
// //                           ClipRRect(
// //                               borderRadius: BorderRadius.circular(99),
// //                               child: LinearProgressIndicator(
// //                                   value: pct / 100,
// //                                   minHeight: 3.5,
// //                                   backgroundColor:
// //                                       Colors.white.withOpacity(0.1),
// //                                   valueColor:
// //                                       const AlwaysStoppedAnimation(_C.gold))),
// //                         ])),
// //                   ]),
// //                 ]),
// //           ),
// //         ]),
// //       ),
// //     );
// //   }

// //   static Widget _heroDivider() => Container(
// //       width: 1,
// //       height: 12,
// //       color: Colors.white.withOpacity(0.12),
// //       margin: const EdgeInsets.symmetric(horizontal: 10));
// // }

// // class _RightChip extends StatelessWidget {
// //   final String top, bottom;
// //   final bool isRank;
// //   const _RightChip(
// //       {required this.top, required this.bottom, this.isRank = false});
// //   @override
// //   Widget build(BuildContext context) => Container(
// //         constraints: const BoxConstraints(minWidth: 51),
// //         padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
// //         decoration: BoxDecoration(
// //             color: isRank
// //                 ? const Color(0xFF4ADE80).withOpacity(0.12)
// //                 : Colors.white.withOpacity(0.08),
// //             borderRadius: BorderRadius.circular(7),
// //             border: Border.all(
// //                 color: isRank
// //                     ? const Color(0xFF4ADE80).withOpacity(0.25)
// //                     : Colors.white.withOpacity(0.1),
// //                 width: 0.5)),
// //         child: Column(mainAxisSize: MainAxisSize.min, children: [
// //           Text(top,
// //               style: TextStyle(
// //                   color: isRank ? const Color(0xFF4ADE80) : _C.gold,
// //                   fontSize: 11,
// //                   fontWeight: FontWeight.w700,
// //                   height: 1)),
// //           const SizedBox(height: 2),
// //           Text(bottom,
// //               style: TextStyle(
// //                   color: Colors.white.withOpacity(0.35), fontSize: 8)),
// //         ]),
// //       );
// // }

// // class _HeroChip extends StatelessWidget {
// //   final String value, label;
// //   const _HeroChip({required this.value, required this.label});
// //   @override
// //   Widget build(BuildContext context) => Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Text(value,
// //                 style: const TextStyle(
// //                     fontSize: 11,
// //                     fontWeight: FontWeight.w700,
// //                     color: Colors.white,
// //                     height: 1)),
// //             const SizedBox(height: 2),
// //             Text(label,
// //                 style: TextStyle(
// //                     fontSize: 8.5, color: Colors.white.withOpacity(0.35))),
// //           ]);
// // }

// // class _HeroSkeleton extends StatelessWidget {
// //   const _HeroSkeleton();
// //   @override
// //   Widget build(BuildContext context) => Container(
// //         height: 160,
// //         decoration: BoxDecoration(
// //             color: _C.darkGreen.withOpacity(0.7),
// //             borderRadius: BorderRadius.circular(16)),
// //       ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1400.ms, colors: [
// //         Colors.white.withOpacity(0.03),
// //         Colors.white.withOpacity(0.08),
// //         Colors.white.withOpacity(0.03)
// //       ]);
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // WEEKLY STRIP
// // // ─────────────────────────────────────────────────────────────────────────────

// // Color _weekBarColor(double f) => f >= 0.7
// //     ? _C.midGreen
// //     : f >= 0.4
// //         ? const Color(0xFFFFA726)
// //         : const Color(0xFFE57373);

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
// //     final safePts = (maxPts < 1 ? 1 : maxPts).toDouble();

// //     return Container(
// //       padding: const EdgeInsets.fromLTRB(13, 10, 13, 10),
// //       decoration: BoxDecoration(
// //           color: _C.card,
// //           borderRadius: BorderRadius.circular(13),
// //           border: Border.all(color: _C.border, width: 0.5)),
// //       child: Column(mainAxisSize: MainAxisSize.min, children: [
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
// //           Row(
// //               children: List.generate(
// //                   7,
// //                   (_) => Expanded(
// //                       child: Container(
// //                           margin: const EdgeInsets.symmetric(horizontal: 2),
// //                           height: 28,
// //                           decoration: BoxDecoration(
// //                               color: _C.pageBg,
// //                               borderRadius: BorderRadius.circular(4),
// //                               border:
// //                                   Border.all(color: _C.border, width: 0.5))))))
// //         else
// //           LayoutBuilder(builder: (_, c) {
// //             final bH = (c.maxWidth * 0.26).clamp(28.0, 52.0);
// //             const lH = 12.0, g = 2.0;
// //             return SizedBox(
// //                 height: lH + g + bH + g + lH,
// //                 child: Row(
// //                   crossAxisAlignment: CrossAxisAlignment.end,
// //                   children: weekData.map((d) {
// //                     final dd = DateTime.tryParse(d.date);
// //                     final isTdy = dd != null &&
// //                         dd.year == today.year &&
// //                         dd.month == today.month &&
// //                         dd.day == today.day;
// //                     final exempt = d.isExemptDay && isFemale;
// //                     final pts = d.points.toDouble();
// //                     final fill =
// //                         pts > 0 ? (pts / safePts).clamp(0.0, 1.0) : 0.0;
// //                     final bh = fill > 0 ? (fill * bH).clamp(4.0, bH) : 0.0;

// //                     return Expanded(
// //                         child: Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 2),
// //                       child: Column(mainAxisSize: MainAxisSize.min, children: [
// //                         SizedBox(
// //                             height: lH,
// //                             child: Center(
// //                                 child: d.points > 0
// //                                     ? FittedBox(
// //                                         fit: BoxFit.scaleDown,
// //                                         child: Text('${d.points}',
// //                                             style: TextStyle(
// //                                                 fontSize: 7.5,
// //                                                 color: isTdy
// //                                                     ? _C.darkGreen
// //                                                     : _weekBarColor(fill),
// //                                                 fontWeight: isTdy
// //                                                     ? FontWeight.w800
// //                                                     : FontWeight.w600)))
// //                                     : const SizedBox.shrink())),
// //                         const SizedBox(height: g),
// //                         SizedBox(
// //                             height: bH,
// //                             child: Align(
// //                                 alignment: Alignment.bottomCenter,
// //                                 child: exempt
// //                                     ? Container(
// //                                         height: (bH * 0.6).clamp(16.0, bH),
// //                                         width: double.infinity,
// //                                         decoration: BoxDecoration(
// //                                             color: const Color(0xFFEDE9FE),
// //                                             borderRadius:
// //                                                 BorderRadius.circular(5)),
// //                                         child: const Center(
// //                                             child: Text('🌙',
// //                                                 style: TextStyle(fontSize: 7))))
// //                                     : bh > 0
// //                                         ? Container(
// //                                             height: bh,
// //                                             width: double.infinity,
// //                                             decoration: BoxDecoration(
// //                                                 gradient: LinearGradient(
// //                                                     begin:
// //                                                         Alignment.bottomCenter,
// //                                                     end: Alignment.topCenter,
// //                                                     colors: isTdy
// //                                                         ? [
// //                                                             _C.darkGreen,
// //                                                             _C.midGreen
// //                                                           ]
// //                                                         : [
// //                                                             _weekBarColor(fill)
// //                                                                 .withOpacity(
// //                                                                     0.6),
// //                                                             _weekBarColor(fill)
// //                                                           ]),
// //                                                 borderRadius:
// //                                                     BorderRadius.circular(5),
// //                                                 boxShadow: isTdy
// //                                                     ? [
// //                                                         BoxShadow(
// //                                                             color: _C.darkGreen
// //                                                                 .withOpacity(
// //                                                                     0.3),
// //                                                             blurRadius: 5,
// //                                                             offset:
// //                                                                 const Offset(
// //                                                                     0, 2))
// //                                                       ]
// //                                                     : null))
// //                                         : Container(
// //                                             height: 3,
// //                                             width: double.infinity,
// //                                             decoration: BoxDecoration(
// //                                                 color: _C.pageBg,
// //                                                 borderRadius:
// //                                                     BorderRadius.circular(2),
// //                                                 border: Border.all(
// //                                                     color: _C.border,
// //                                                     width: 0.5))))),
// //                         const SizedBox(height: g),
// //                         SizedBox(
// //                             height: lH,
// //                             child: Center(
// //                                 child: Text(_bnDay[d.day] ?? d.day,
// //                                     style: TextStyle(
// //                                         fontSize: 8.5,
// //                                         color:
// //                                             isTdy ? _C.darkGreen : _C.textHint,
// //                                         fontWeight: isTdy
// //                                             ? FontWeight.w800
// //                                             : FontWeight.w500)))),
// //                       ]),
// //                     ));
// //                   }).toList(),
// //                 ));
// //           }),
// //       ]),
// //     );
// //   }
// // }

// // class _WeekSkeleton extends StatelessWidget {
// //   const _WeekSkeleton();
// //   @override
// //   Widget build(BuildContext context) => Container(
// //         height: 100,
// //         decoration: BoxDecoration(
// //             color: _C.card,
// //             borderRadius: BorderRadius.circular(14),
// //             border: Border.all(color: _C.border, width: 0.5)),
// //       ).animate(onPlay: (c) => c.repeat()).shimmer(
// //           duration: 1200.ms,
// //           colors: [_C.card, const Color(0xFFE8ECE8), _C.card]);
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SECTION HEADER
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _SecHead extends StatelessWidget {
// //   final String title, emoji;
// //   final VoidCallback onSeeAll;
// //   const _SecHead(
// //       {required this.title, required this.emoji, required this.onSeeAll});

// //   @override
// //   Widget build(BuildContext context) => Row(children: [
// //         Text(emoji, style: const TextStyle(fontSize: 13)),
// //         const SizedBox(width: 6),
// //         Text(title,
// //             style: const TextStyle(
// //                 color: _C.textPri,
// //                 fontWeight: FontWeight.w800,
// //                 fontSize: 13,
// //                 letterSpacing: -0.1)),
// //         const Spacer(),
// //         GestureDetector(
// //             onTap: onSeeAll,
// //             child: Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
// //               decoration: BoxDecoration(
// //                   color: _C.greenLight,
// //                   borderRadius: BorderRadius.circular(99)),
// //               child: const Text('সব দেখুন →',
// //                   style: TextStyle(
// //                       color: _C.darkGreen,
// //                       fontSize: 10,
// //                       fontWeight: FontWeight.w700)),
// //             )),
// //       ]);
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // MONTHLY HISTORY LIST
// // // Shows previous months only (current month is in the hero card).
// // // Clean, consistent rows. No duplication of current month data.
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _MonthHistoryList extends StatelessWidget {
// //   final List<MonthlyTracker> trackers;
// //   const _MonthHistoryList({required this.trackers});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //           color: _C.card,
// //           borderRadius: BorderRadius.circular(14),
// //           border: Border.all(color: _C.border, width: 0.5)),
// //       child: Column(
// //           children: List.generate(trackers.length, (i) {
// //         final t = trackers[i];
// //         final month = AppConstants.bengaliMonths[t.month - 1];
// //         final pct = (t.completionPercentage / 100).clamp(0.0, 1.0);
// //         final color = pct > 0.7
// //             ? _C.green
// //             : pct > 0.4
// //                 ? _C.amber
// //                 : _C.red;
// //         final isLast = i == trackers.length - 1;
// //         final now = DateTime.now();
// //         final totalD = DateUtils.getDaysInMonth(now.year, t.month);

// //         return Container(
// //           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
// //           decoration: BoxDecoration(
// //               border: isLast
// //                   ? null
// //                   : const Border(
// //                       bottom: BorderSide(color: _C.border, width: 0.5))),
// //           child: Row(children: [
// //             // Color dot
// //             Container(
// //                 width: 7,
// //                 height: 7,
// //                 decoration:
// //                     BoxDecoration(color: color, shape: BoxShape.circle)),
// //             const SizedBox(width: 10),

// //             // Month + winner
// //             SizedBox(
// //                 width: 52,
// //                 child: Row(children: [
// //                   Flexible(
// //                       child: Text(month,
// //                           style: const TextStyle(
// //                               color: _C.textPri,
// //                               fontWeight: FontWeight.w700,
// //                               fontSize: 12),
// //                           overflow: TextOverflow.ellipsis)),
// //                   if (t.isWinner) ...[
// //                     const SizedBox(width: 3),
// //                     const Text('🏆', style: TextStyle(fontSize: 9))
// //                   ],
// //                 ])),
// //             const SizedBox(width: 8),

// //             // Days completed
// //             Text('${t.daysCompleted ?? 0}/$totalD দিন',
// //                 style: const TextStyle(color: _C.textHint, fontSize: 9.5)),
// //             const SizedBox(width: 8),

// //             // Progress bar + %
// //             Expanded(
// //                 child: Row(children: [
// //               Expanded(
// //                   child: ClipRRect(
// //                       borderRadius: BorderRadius.circular(99),
// //                       child: LinearProgressIndicator(
// //                           value: pct,
// //                           minHeight: 4,
// //                           backgroundColor: _C.pageBg,
// //                           valueColor: AlwaysStoppedAnimation(color)))),
// //               const SizedBox(width: 6),
// //               Text('${(pct * 100).toInt()}%',
// //                   style: TextStyle(
// //                       color: color,
// //                       fontSize: 9.5,
// //                       fontWeight: FontWeight.w700)),
// //             ])),
// //             const SizedBox(width: 10),

// //             // Points
// //             Text(_fmt(t.totalPoints),
// //                 style: TextStyle(
// //                     color: _C.textPri,
// //                     fontWeight: FontWeight.w800,
// //                     fontSize: 13)),
// //             const SizedBox(width: 2),
// //             Text('pts',
// //                 style: TextStyle(
// //                     color: _C.textHint,
// //                     fontSize: 9,
// //                     fontWeight: FontWeight.w600)),
// //           ]),
// //         ).animate().fadeIn(delay: Duration(milliseconds: i * 50));
// //       })),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // LEADERBOARD LIST
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _LeaderList extends StatelessWidget {
// //   final List entries;
// //   final String? currentUserId;
// //   const _LeaderList({required this.entries, this.currentUserId});

// //   static const _emojis = ['🥇', '🥈', '🥉'];
// //   static const _rankColors = [_C.rankGold, _C.rankSilver, _C.rankBronze];
// //   static const _rowBg = [
// //     Color(0xFFFFFBF0),
// //     Color(0xFFF8FAFC),
// //     Color(0xFFFFF7ED)
// //   ];
// //   static const _avatarBg = [
// //     Color(0xFF0E3D22),
// //     Color(0xFF374151),
// //     Color(0xFF7C3AED)
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //           color: _C.card,
// //           borderRadius: BorderRadius.circular(14),
// //           border: Border.all(color: _C.border, width: 0.5)),
// //       child: Column(
// //           children: List.generate(entries.length, (i) {
// //         final e = entries[i];
// //         final isLast = i == entries.length - 1;
// //         final isMe = currentUserId != null && e.id?.toString() == currentUserId;

// //         return Container(
// //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
// //           decoration: BoxDecoration(
// //             color: _rowBg[i],
// //             borderRadius: BorderRadius.vertical(
// //               top: i == 0 ? const Radius.circular(14) : Radius.zero,
// //               bottom: isLast ? const Radius.circular(14) : Radius.zero,
// //             ),
// //             border: isLast
// //                 ? null
// //                 : const Border(
// //                     bottom: BorderSide(color: _C.border, width: 0.5)),
// //           ),
// //           child: Row(children: [
// //             SizedBox(
// //                 width: 22,
// //                 child: Text(_emojis[i],
// //                     style: const TextStyle(fontSize: 16),
// //                     textAlign: TextAlign.center)),
// //             const SizedBox(width: 8),
// //             Container(
// //               width: 30,
// //               height: 30,
// //               decoration: BoxDecoration(
// //                   color: _avatarBg[i], borderRadius: BorderRadius.circular(8)),
// //               child: Center(
// //                   child: Text(
// //                 (e.name?.isNotEmpty == true) ? e.name[0].toUpperCase() : 'U',
// //                 style: const TextStyle(
// //                     color: Colors.white,
// //                     fontWeight: FontWeight.w800,
// //                     fontSize: 12),
// //               )),
// //             ),
// //             const SizedBox(width: 8),
// //             Expanded(
// //                 child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                   Row(children: [
// //                     Flexible(
// //                         child: Text(e.name?.split(' ').first ?? '',
// //                             style: const TextStyle(
// //                                 color: _C.textPri,
// //                                 fontWeight: FontWeight.w700,
// //                                 fontSize: 12),
// //                             overflow: TextOverflow.ellipsis)),
// //                     if (isMe) ...[
// //                       const SizedBox(width: 4),
// //                       Container(
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 5, vertical: 1),
// //                         decoration: BoxDecoration(
// //                             color: _C.greenLight,
// //                             borderRadius: BorderRadius.circular(99)),
// //                         child: const Text('আপনি',
// //                             style: TextStyle(
// //                                 color: _C.darkGreen,
// //                                 fontSize: 8.5,
// //                                 fontWeight: FontWeight.w700)),
// //                       ),
// //                     ],
// //                   ]),
// //                   if (e.id != null || e.district != null)
// //                     Text('ID: ${e.id ?? ''} · ${e.district ?? ''}',
// //                         style: const TextStyle(color: _C.textSec, fontSize: 9),
// //                         overflow: TextOverflow.ellipsis),
// //                 ])),
// //             Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //               decoration: BoxDecoration(
// //                   color: _rankColors[i].withOpacity(0.12),
// //                   borderRadius: BorderRadius.circular(10)),
// //               child: Column(children: [
// //                 Text('${e.totalPoints}',
// //                     style: TextStyle(
// //                         color: _rankColors[i],
// //                         fontWeight: FontWeight.w900,
// //                         fontSize: 13,
// //                         height: 1)),
// //                 Text('pts',
// //                     style: TextStyle(
// //                         color: _rankColors[i].withOpacity(0.55),
// //                         fontSize: 7,
// //                         fontWeight: FontWeight.w600)),
// //               ]),
// //             ),
// //           ]),
// //         ).animate().fadeIn(delay: Duration(milliseconds: i * 50));
// //       })),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // COMMUNITY ROW
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _CommunityRow extends StatelessWidget {
// //   final VoidCallback onRate, onShare;
// //   const _CommunityRow({required this.onRate, required this.onShare});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //       const Padding(
// //           padding: EdgeInsets.only(bottom: 10),
// //           child: Row(children: [
// //             Text('💬', style: TextStyle(fontSize: 13)),
// //             SizedBox(width: 6),
// //             Text('কমিউনিটি',
// //                 style: TextStyle(
// //                     color: _C.textPri,
// //                     fontWeight: FontWeight.w800,
// //                     fontSize: 13,
// //                     letterSpacing: -0.1)),
// //           ])),
// //       Row(children: [
// //         Expanded(
// //             child: _CommCard(
// //                 emoji: '⭐',
// //                 title: 'রেটিং দিন',
// //                 subtitle: 'Play Store এ রিভিউ',
// //                 bg: const Color(0xFFFFFBF0),
// //                 border: const Color(0xFFFFE082),
// //                 accent: const Color(0xFF7A4500),
// //                 iconBg: const Color(0xFFFFECB3),
// //                 onTap: onRate)),
// //         const SizedBox(width: 10),
// //         Expanded(
// //             child: _CommCard(
// //                 emoji: '📤',
// //                 title: 'শেয়ার করুন',
// //                 subtitle: 'বন্ধুদের জানান',
// //                 bg: const Color(0xFFEFF6FF),
// //                 border: const Color(0xFFBFDBFE),
// //                 accent: const Color(0xFF1D4ED8),
// //                 iconBg: const Color(0xFFDBEAFE),
// //                 onTap: onShare)),
// //       ]),
// //     ]);
// //   }
// // }

// // class _CommCard extends StatelessWidget {
// //   final String emoji, title, subtitle;
// //   final Color bg, border, accent, iconBg;
// //   final VoidCallback onTap;
// //   const _CommCard(
// //       {required this.emoji,
// //       required this.title,
// //       required this.subtitle,
// //       required this.bg,
// //       required this.border,
// //       required this.accent,
// //       required this.iconBg,
// //       required this.onTap});

// //   @override
// //   Widget build(BuildContext context) => GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         padding: const EdgeInsets.all(13),
// //         decoration: BoxDecoration(
// //             color: bg,
// //             borderRadius: BorderRadius.circular(14),
// //             border: Border.all(color: border, width: 0.8)),
// //         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //           Row(children: [
// //             Container(
// //                 width: 36,
// //                 height: 36,
// //                 decoration: BoxDecoration(
// //                     color: iconBg, borderRadius: BorderRadius.circular(10)),
// //                 child: Center(
// //                     child: Text(emoji, style: const TextStyle(fontSize: 17)))),
// //             const Spacer(),
// //             Icon(Icons.arrow_outward_rounded,
// //                 size: 13, color: accent.withOpacity(0.45)),
// //           ]),
// //           const SizedBox(height: 9),
// //           Text(title,
// //               style: TextStyle(
// //                   color: accent,
// //                   fontWeight: FontWeight.w800,
// //                   fontSize: 13,
// //                   letterSpacing: -0.2)),
// //           const SizedBox(height: 2),
// //           Text(subtitle,
// //               style: TextStyle(
// //                   color: accent.withOpacity(0.55),
// //                   fontSize: 9.5,
// //                   fontWeight: FontWeight.w500)),
// //         ]),
// //       ));
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // HOW IT WORKS
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _HowItWorks extends StatelessWidget {
// //   final VoidCallback onTap;
// //   const _HowItWorks({required this.onTap});

// //   @override
// //   Widget build(BuildContext context) => GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
// //         decoration: BoxDecoration(
// //             color: _C.card,
// //             borderRadius: BorderRadius.circular(14),
// //             border: Border.all(color: _C.border, width: 0.5)),
// //         child: Row(children: [
// //           Container(
// //               width: 34,
// //               height: 34,
// //               decoration: BoxDecoration(
// //                   color: _C.greenLight,
// //                   borderRadius: BorderRadius.circular(10)),
// //               child: const Icon(Icons.help_outline_rounded,
// //                   color: _C.darkGreen, size: 18)),
// //           const SizedBox(width: 10),
// //           const Expanded(
// //               child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                 Text('এটি কীভাবে কাজ করে?',
// //                     style: TextStyle(
// //                         color: _C.textPri,
// //                         fontWeight: FontWeight.w700,
// //                         fontSize: 12)),
// //                 SizedBox(height: 1),
// //                 Text('পয়েন্ট, র‍্যাংকিং ও আমল সম্পর্কে জানুন',
// //                     style: TextStyle(color: _C.textSec, fontSize: 10.5)),
// //               ])),
// //           const Icon(Icons.chevron_right_rounded, color: _C.textHint, size: 18),
// //         ]),
// //       ));
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SHARED
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _ListSkeleton extends StatelessWidget {
// //   const _ListSkeleton();
// //   @override
// //   Widget build(BuildContext context) => Container(
// //         height: 120,
// //         decoration: BoxDecoration(
// //             color: _C.card,
// //             borderRadius: BorderRadius.circular(14),
// //             border: Border.all(color: _C.border, width: 0.5)),
// //       ).animate(onPlay: (c) => c.repeat()).shimmer(
// //           duration: 1200.ms,
// //           colors: [_C.card, const Color(0xFFE8ECE8), _C.card]);
// // }

// // class _EmptyCard extends StatelessWidget {
// //   final String label;
// //   const _EmptyCard({required this.label});
// //   @override
// //   Widget build(BuildContext context) => Container(
// //       height: 80,
// //       decoration: BoxDecoration(
// //           color: _C.card,
// //           borderRadius: BorderRadius.circular(14),
// //           border: Border.all(color: _C.border, width: 0.5)),
// //       child: Center(
// //           child: Text(label,
// //               style: const TextStyle(
// //                   color: _C.textHint,
// //                   fontSize: 13,
// //                   fontWeight: FontWeight.w500))));
// // }

// // class SectionHeaderCompact extends StatelessWidget {
// //   final String title, action;
// //   final VoidCallback onAction;
// //   const SectionHeaderCompact(
// //       {required this.title,
// //       required this.action,
// //       required this.onAction,
// //       super.key});
// //   @override
// //   Widget build(BuildContext context) =>
// //       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
// //         Text(title,
// //             style: const TextStyle(
// //                 color: _C.textPri, fontWeight: FontWeight.w700, fontSize: 11)),
// //         GestureDetector(
// //             onTap: onAction,
// //             child: Text(action,
// //                 style: const TextStyle(
// //                     color: _C.darkGreen,
// //                     fontSize: 10,
// //                     fontWeight: FontWeight.w600))),
// //       ]);
// // }
// import 'package:amal_tracker/features/home/widgets/daily_cards_section.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:in_app_review/in_app_review.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

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
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const purple = Color(0xFF7C3AED);
//   static const purpleLight = Color(0xFFEDE9FE);
//   static const amber = Color(0xFFF59E0B);
//   static const red = Color(0xFFEF4444);
//   static const textPri = Color(0xFF0A1A0F);
//   static const textSec = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
//   static const border = Color(0xFFE4EAE4);
//   static const rankGold = Color(0xFFD4A843);
//   static const rankSilver = Color(0xFF94A3B8);
//   static const rankBronze = Color(0xFFCD7F32);
// }

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
//     ref.invalidate(leaderboardProvider);
//   }

//   @override
//   void dispose() {
//     _sc.dispose();
//     super.dispose();
//   }

//   Future<void> _refresh() async {
//     final now = DateTime.now();
//     ref.invalidate(progressSummaryProvider((year: now.year, month: now.month)));
//     ref.invalidate(leaderboardProvider);
//     await Future.delayed(const Duration(milliseconds: 500));
//   }

//   void _showProfile() => showModalBottomSheet(
//         context: context,
//         backgroundColor: Colors.transparent,
//         isScrollControlled: true,
//         builder: (_) => ProfileSheet(user: ref.read(currentUserProvider)),
//       );

//   Future<void> _handleRateApp() async {
//     final review = InAppReview.instance;
//     if (await review.isAvailable()) {
//       await review.requestReview();
//     } else {
//       final uri = Uri.parse(
//           'https://play.google.com/store/apps/details?id=com.yourcompany.sabeq');
//       if (await canLaunchUrl(uri)) {
//         launchUrl(uri, mode: LaunchMode.externalApplication);
//       }
//     }
//   }

//   Future<void> _handleShareApp() async {
//     await Share.share(
//       'Sabeq — নেক আমল ট্র্যাক করুন, নিজের অগ্রগতি দেখুন!\n\n'
//       '📲 ডাউনলোড করুন:\nhttps://play.google.com/store/apps/details?id=com.yourcompany.sabeq',
//       subject: 'Sabeq অ্যাপ — নেক আমলে এগিয়ে যাও',
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
//                 padding: const EdgeInsets.fromLTRB(0, 12, 0, 90),
//                 sliver: SliverList(
//                   delegate: SliverChildListDelegate([
//                     // ── 1. Greeting ──────────────────────────────────────
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 14.0),
//                       child: _Greeting(user: user, progress: progress)
//                           .animate()
//                           .fadeIn(duration: 280.ms),
//                     ),
//                     const SizedBox(height: 12),

//                     // ── 2. Hero Card ─────────────────────────────────────
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 14.0),
//                       child: progress
//                           .when(
//                             loading: () => const _HeroSkeleton(),
//                             error: (_, __) => _HeroCard(
//                                 summary: null,
//                                 onTap: () => context.go(AppRoutes.tracker)),
//                             data: (s) => _HeroCard(
//                                 summary: s,
//                                 onTap: () => context.go(AppRoutes.tracker)),
//                           )
//                           .animate()
//                           .fadeIn(delay: 50.ms, duration: 300.ms),
//                     ),
//                     const SizedBox(height: 10),

//                     // ── 3. Weekly Strip ───────────────────────────────────
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 14.0),
//                       child: progress
//                           .when(
//                             loading: () => const _WeekSkeleton(),
//                             error: (_, __) => const _WeekStrip(summary: null),
//                             data: (s) => _WeekStrip(summary: s),
//                           )
//                           .animate()
//                           .fadeIn(delay: 90.ms, duration: 280.ms),
//                     ),

//                     const SizedBox(height: 11),
//                     const DailyCardsSection(),

//                     const SizedBox(height: 11),

//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 14.0),
//                       child: Column(children: [
//                         progress.when(
//                           loading: () => const SizedBox.shrink(),
//                           error: (_, __) => const SizedBox.shrink(),
//                           data: (s) {
//                             final recentMonths = s.recentMonths;
//                             if (recentMonths.isEmpty) {
//                               return const SizedBox.shrink();
//                             }
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 _SecHead(
//                                   title: 'মাসিক অগ্রগতি',
//                                   emoji: '📅',
//                                   onSeeAll: () =>
//                                       context.go(AppRoutes.monthlyView),
//                                 ).animate().fadeIn(delay: 135.ms),
//                                 const SizedBox(height: 10),
//                                 _MonthHistoryList(trackers: recentMonths)
//                                     .animate()
//                                     .fadeIn(delay: 148.ms),
//                                 const SizedBox(height: 20),
//                               ],
//                             );
//                           },
//                         ),

//                         // ── 6. Leaderboard teaser ─────────────────────────
//                         _SecHead(
//                           title: 'শীর্ষ তালিকা',
//                           emoji: '🏆',
//                           onSeeAll: () => context.go(AppRoutes.leaderboard),
//                         ).animate().fadeIn(delay: 165.ms),
//                         const SizedBox(height: 10),
//                         (board.isLoading
//                                 ? const _ListSkeleton()
//                                 : board.entries.isEmpty
//                                     ? const _EmptyCard(label: 'ডেটা নেই')
//                                     : _LeaderList(
//                                         entries: board.entries.take(3).toList(),
//                                         currentUserId:
//                                             ref.read(currentUserProvider)?.id,
//                                       ))
//                             .animate()
//                             .fadeIn(delay: 178.ms),
//                         const SizedBox(height: 20),

//                         // ── 7. Community ───────────────────────────────────
//                         _CommunityRow(
//                                 onRate: _handleRateApp,
//                                 onShare: _handleShareApp)
//                             .animate()
//                             .fadeIn(delay: 192.ms),
//                         const SizedBox(height: 20),

//                         // ── 8. How it works ─────────────────────────────────
//                         _HowItWorks(
//                                 onTap: () => context.push(AppRoutes.howItWorks))
//                             .animate()
//                             .fadeIn(delay: 200.ms),
//                       ]),
//                     )
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
//                     (user?.name?.isNotEmpty == true)
//                         ? user!.name[0].toUpperCase()
//                         : 'U',
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w800,
//                         fontSize: 12),
//                   )),
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
//               color: _C.goldLight,
//               borderRadius: BorderRadius.circular(99),
//               border: Border.all(color: _C.goldBorder, width: 0.5)),
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
// // HERO CARD — points বাদ, completion % + farz + jamaat + today's count
// // ─────────────────────────────────────────────────────────────────────────────

// class _HeroCard extends StatelessWidget {
//   final ProgressSummary? summary;
//   final VoidCallback onTap;
//   const _HeroCard({this.summary, required this.onTap});

//   String _winnerLabel(String? cat) => switch (cat) {
//         'TOP_FARZ' => 'ফরজ চ্যাম্পিয়ন',
//         'TOP_JAMAAT' => 'জামাত চ্যাম্পিয়ন',
//         'TOP_STREAK' => 'সেরা ধারাবাহিকতা',
//         _ => 'মাসিক বিজয়ী',
//       };

//   @override
//   Widget build(BuildContext context) {
//     final today = summary?.todayEntry;
//     final month = summary?.currentMonth;
//     final isFemale = summary?.userGender == 'female';

//     // আজকের সম্পন্ন আমল count — points নেই, entries থেকে গণনা
//     final todayItems = today?.entries ?? [];
//     final todayCompleted = todayItems.where((e) {
//       if (e.prayerMode != null) return e.prayerMode != PrayerMode.missed;
//       if (e.count > 0) return true;
//       return e.completed;
//     }).length;
//     final isExempt = (today?.isExemptDay ?? false) && isFemale;
//     final hasToday = todayCompleted > 0 || isExempt;

//     final pct = (month?.completionPercentage ?? 0).clamp(0.0, 100.0);
//     final daysActive = month?.daysActive ?? 0;
//     final rank = month?.rank;
//     final isWinner = month?.isWinner ?? false;
//     final farzDays = month?.farzCompletedDays ?? 0;
//     final eligDays = month?.eligibleDays ?? 0;
//     final jamaat = 0;
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
//                         margin: const EdgeInsets.only(bottom: 8),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                             color: _C.gold.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(6),
//                             border: Border.all(
//                                 color: _C.gold.withOpacity(0.3), width: 0.5)),
//                         child: Row(mainAxisSize: MainAxisSize.min, children: [
//                           const Text('🏆', style: TextStyle(fontSize: 10)),
//                           const SizedBox(width: 5),
//                           Text(_winnerLabel(month?.winnerCategory),
//                               style: const TextStyle(
//                                   color: _C.gold,
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w700)),
//                         ])),
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
//                             Text(isExempt ? 'আজ মাহলির দিন 🌸' : 'আজকের আমল',
//                                 style: TextStyle(
//                                     color: Colors.white.withOpacity(0.4),
//                                     fontSize: 9.5,
//                                     fontWeight: FontWeight.w500)),
//                           ]),
//                           const SizedBox(height: 4),
//                           if (todayCompleted > 0)
//                             RichText(
//                                 text: TextSpan(children: [
//                               TextSpan(
//                                   text: '$todayCompleted',
//                                   style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 26,
//                                       fontWeight: FontWeight.w900,
//                                       height: 1,
//                                       letterSpacing: -1)),
//                               const TextSpan(
//                                   text: ' টি আমল',
//                                   style: TextStyle(
//                                       color: Color(0x80FFFFFF),
//                                       fontSize: 11,
//                                       fontWeight: FontWeight.w500)),
//                             ]))
//                           else if (isExempt)
//                             const Text('মাহলির দিন',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w800,
//                                     height: 1.1))
//                           else
//                             const Text('এখনো রেকর্ড\nহয়নি',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w800,
//                                     height: 1.2,
//                                     letterSpacing: -0.2)),
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
//                           Text('${pct.toInt()}%',
//                               style: TextStyle(
//                                   color: _C.gold,
//                                   fontSize: pct >= 100 ? 22 : 24,
//                                   fontWeight: FontWeight.w800,
//                                   height: 1,
//                                   letterSpacing: -1)),
//                           const SizedBox(height: 2),
//                           Text('ফরজ সম্পন্ন',
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
//                             _RightChip(top: '$jamaat', bottom: 'জামাত'),
//                           ]),
//                         ]),
//                   ]),
//                   const SizedBox(height: 10),
//                   const Divider(
//                       height: 1, thickness: 0.5, color: Color(0x1AFFFFFF)),
//                   const SizedBox(height: 8),
//                   Row(children: [
//                     _HeroChip(
//                         value: '$daysActive/$daysInMonth',
//                         label: 'সক্রিয় দিন'),
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
//                               borderRadius: BorderRadius.circular(99),
//                               child: LinearProgressIndicator(
//                                   value: pct / 100,
//                                   minHeight: 3.5,
//                                   backgroundColor:
//                                       Colors.white.withOpacity(0.1),
//                                   valueColor:
//                                       const AlwaysStoppedAnimation(_C.gold))),
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
//   Widget build(BuildContext context) => Container(
//         constraints: const BoxConstraints(minWidth: 51),
//         padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
//         decoration: BoxDecoration(
//             color: isRank
//                 ? const Color(0xFF4ADE80).withOpacity(0.12)
//                 : Colors.white.withOpacity(0.08),
//             borderRadius: BorderRadius.circular(7),
//             border: Border.all(
//                 color: isRank
//                     ? const Color(0xFF4ADE80).withOpacity(0.25)
//                     : Colors.white.withOpacity(0.1),
//                 width: 0.5)),
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           Text(top,
//               style: TextStyle(
//                   color: isRank ? const Color(0xFF4ADE80) : _C.gold,
//                   fontSize: 11,
//                   fontWeight: FontWeight.w700,
//                   height: 1)),
//           const SizedBox(height: 2),
//           Text(bottom,
//               style: TextStyle(
//                   color: Colors.white.withOpacity(0.35), fontSize: 8)),
//         ]),
//       );
// }

// class _HeroChip extends StatelessWidget {
//   final String value, label;
//   const _HeroChip({required this.value, required this.label});
//   @override
//   Widget build(BuildContext context) => Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(value,
//                 style: const TextStyle(
//                     fontSize: 11,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white,
//                     height: 1)),
//             const SizedBox(height: 2),
//             Text(label,
//                 style: TextStyle(
//                     fontSize: 8.5, color: Colors.white.withOpacity(0.35))),
//           ]);
// }

// class _HeroSkeleton extends StatelessWidget {
//   const _HeroSkeleton();
//   @override
//   Widget build(BuildContext context) => Container(
//         height: 160,
//         decoration: BoxDecoration(
//             color: _C.darkGreen.withOpacity(0.7),
//             borderRadius: BorderRadius.circular(16)),
//       ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1400.ms, colors: [
//         Colors.white.withOpacity(0.03),
//         Colors.white.withOpacity(0.08),
//         Colors.white.withOpacity(0.03)
//       ]);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // WEEKLY STRIP — hasActivity ভিত্তিক traffic-light bars
// // ─────────────────────────────────────────────────────────────────────────────

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
//     final weekData = summary?.currentWeekProgress ?? [];
//     final isFemale = summary?.userGender == 'female';
//     final today = DateTime.now();
//     final activeDays = weekData.where((d) => d.hasActivity).length;

//     return Container(
//       padding: const EdgeInsets.fromLTRB(13, 10, 13, 10),
//       decoration: BoxDecoration(
//           color: _C.card,
//           borderRadius: BorderRadius.circular(13),
//           border: Border.all(color: _C.border, width: 0.5)),
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         Row(children: [
//           const Text('এই সপ্তাহ',
//               style: TextStyle(
//                   color: _C.textPri,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 11)),
//           const Spacer(),
//           if (activeDays > 0) ...[
//             Text('$activeDays',
//                 style: const TextStyle(
//                     color: _C.green,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 11)),
//             const Text(' সক্রিয় দিন',
//                 style: TextStyle(
//                     color: _C.textHint,
//                     fontSize: 10,
//                     fontWeight: FontWeight.w500)),
//           ],
//         ]),
//         const SizedBox(height: 8),
//         if (weekData.isEmpty)
//           Row(
//               children: List.generate(
//                   7,
//                   (_) => Expanded(
//                       child: Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 2),
//                           height: 28,
//                           decoration: BoxDecoration(
//                               color: _C.pageBg,
//                               borderRadius: BorderRadius.circular(4),
//                               border:
//                                   Border.all(color: _C.border, width: 0.5))))))
//         else
//           LayoutBuilder(builder: (_, c) {
//             final bH = (c.maxWidth * 0.26).clamp(28.0, 52.0);
//             const lH = 12.0, g = 2.0;
//             return SizedBox(
//                 height: lH + g + bH + g + lH,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: weekData.map((d) {
//                     final dd = DateTime.tryParse(d.date);
//                     final isTdy = dd != null &&
//                         dd.year == today.year &&
//                         dd.month == today.month &&
//                         dd.day == today.day;
//                     final exempt = d.isExemptDay && isFemale;

//                     Color barColor = isTdy ? _C.darkGreen : _C.midGreen;
//                     final barH = d.hasActivity ? bH : (bH * 0.12);

//                     return Expanded(
//                         child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 2),
//                       child: Column(mainAxisSize: MainAxisSize.min, children: [
//                         SizedBox(
//                             height: lH,
//                             child: Center(
//                                 child: d.hasActivity
//                                     ? Icon(Icons.check_circle_rounded,
//                                         size: 9,
//                                         color: isTdy ? _C.darkGreen : _C.green)
//                                     : const SizedBox.shrink())),
//                         const SizedBox(height: g),
//                         SizedBox(
//                             height: bH,
//                             child: Align(
//                                 alignment: Alignment.bottomCenter,
//                                 child: exempt
//                                     ? Container(
//                                         height: (bH * 0.6).clamp(16.0, bH),
//                                         width: double.infinity,
//                                         decoration: BoxDecoration(
//                                             color: const Color(0xFFEDE9FE),
//                                             borderRadius:
//                                                 BorderRadius.circular(5)),
//                                         child: const Center(
//                                             child: Text('🌸',
//                                                 style: TextStyle(fontSize: 7))))
//                                     : d.hasActivity
//                                         ? Container(
//                                             height: barH,
//                                             width: double.infinity,
//                                             decoration: BoxDecoration(
//                                                 gradient: LinearGradient(
//                                                     begin:
//                                                         Alignment.bottomCenter,
//                                                     end: Alignment.topCenter,
//                                                     colors: isTdy
//                                                         ? [
//                                                             _C.darkGreen,
//                                                             _C.midGreen
//                                                           ]
//                                                         : [
//                                                             _C.midGreen
//                                                                 .withOpacity(
//                                                                     0.6),
//                                                             _C.midGreen
//                                                           ]),
//                                                 borderRadius:
//                                                     BorderRadius.circular(5),
//                                                 boxShadow: isTdy
//                                                     ? [
//                                                         BoxShadow(
//                                                             color: _C.darkGreen
//                                                                 .withOpacity(
//                                                                     0.3),
//                                                             blurRadius: 5,
//                                                             offset:
//                                                                 const Offset(
//                                                                     0, 2))
//                                                       ]
//                                                     : null))
//                                         : Container(
//                                             height: 3,
//                                             width: double.infinity,
//                                             decoration: BoxDecoration(
//                                                 color: _C.pageBg,
//                                                 borderRadius:
//                                                     BorderRadius.circular(2),
//                                                 border: Border.all(
//                                                     color: _C.border,
//                                                     width: 0.5))))),
//                         const SizedBox(height: g),
//                         SizedBox(
//                             height: lH,
//                             child: Center(
//                                 child: Text(_bnDay[d.day] ?? d.day,
//                                     style: TextStyle(
//                                         fontSize: 8.5,
//                                         color:
//                                             isTdy ? _C.darkGreen : _C.textHint,
//                                         fontWeight: isTdy
//                                             ? FontWeight.w800
//                                             : FontWeight.w500)))),
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
//   Widget build(BuildContext context) => Container(
//         height: 100,
//         decoration: BoxDecoration(
//             color: _C.card,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: _C.border, width: 0.5)),
//       ).animate(onPlay: (c) => c.repeat()).shimmer(
//           duration: 1200.ms,
//           colors: [_C.card, const Color(0xFFE8ECE8), _C.card]);
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
//   Widget build(BuildContext context) => Row(children: [
//         Text(emoji, style: const TextStyle(fontSize: 13)),
//         const SizedBox(width: 6),
//         Text(title,
//             style: const TextStyle(
//                 color: _C.textPri,
//                 fontWeight: FontWeight.w800,
//                 fontSize: 13,
//                 letterSpacing: -0.1)),
//         const Spacer(),
//         GestureDetector(
//             onTap: onSeeAll,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//               decoration: BoxDecoration(
//                   color: _C.greenLight,
//                   borderRadius: BorderRadius.circular(99)),
//               child: const Text('সব দেখুন →',
//                   style: TextStyle(
//                       color: _C.darkGreen,
//                       fontSize: 10,
//                       fontWeight: FontWeight.w700)),
//             )),
//       ]);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // MONTHLY HISTORY LIST — points বাদ, completion % + farz + jamaat
// // ─────────────────────────────────────────────────────────────────────────────

// class _MonthHistoryList extends StatelessWidget {
//   final List<MonthlyTracker> trackers;
//   const _MonthHistoryList({required this.trackers});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           color: _C.card,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: _C.border, width: 0.5)),
//       child: Column(
//           children: List.generate(trackers.length, (i) {
//         final t = trackers[i];
//         final month = AppConstants.bengaliMonths[t.month - 1];
//         final pct = (t.completionPercentage / 100).clamp(0.0, 1.0);
//         final color = pct > 0.7
//             ? _C.green
//             : pct > 0.4
//                 ? _C.amber
//                 : _C.red;
//         final isLast = i == trackers.length - 1;
//         final now = DateTime.now();
//         final totalD = DateUtils.getDaysInMonth(now.year, t.month);

//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
//           decoration: BoxDecoration(
//               border: isLast
//                   ? null
//                   : const Border(
//                       bottom: BorderSide(color: _C.border, width: 0.5))),
//           child: Row(children: [
//             Container(
//                 width: 7,
//                 height: 7,
//                 decoration:
//                     BoxDecoration(color: color, shape: BoxShape.circle)),
//             const SizedBox(width: 10),

//             SizedBox(
//                 width: 52,
//                 child: Row(children: [
//                   Flexible(
//                       child: Text(month,
//                           style: const TextStyle(
//                               color: _C.textPri,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 12),
//                           overflow: TextOverflow.ellipsis)),
//                   if (t.isWinner) ...[
//                     const SizedBox(width: 3),
//                     const Text('🏆', style: TextStyle(fontSize: 9))
//                   ],
//                 ])),
//             const SizedBox(width: 8),

//             // আমল করা দিন
//             Text('${t.daysActive}/$totalD দিন',
//                 style: const TextStyle(color: _C.textHint, fontSize: 9.5)),
//             const SizedBox(width: 8),

//             // Progress bar + %
//             Expanded(
//                 child: Row(children: [
//               Expanded(
//                   child: ClipRRect(
//                       borderRadius: BorderRadius.circular(99),
//                       child: LinearProgressIndicator(
//                           value: pct,
//                           minHeight: 4,
//                           backgroundColor: _C.pageBg,
//                           valueColor: AlwaysStoppedAnimation(color)))),
//               const SizedBox(width: 6),
//               Text('${(pct * 100).toInt()}%',
//                   style: TextStyle(
//                       color: color,
//                       fontSize: 9.5,
//                       fontWeight: FontWeight.w700)),
//             ])),
//             const SizedBox(width: 10),

//             // ফরজ পূর্ণ দিন
//             Text('${t.farzCompletedDays}',
//                 style: const TextStyle(
//                     color: _C.textPri,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 13)),
//             const SizedBox(width: 2),
//             Text('ফরজ',
//                 style: TextStyle(
//                     color: _C.textHint,
//                     fontSize: 9,
//                     fontWeight: FontWeight.w600)),
//           ]),
//         ).animate().fadeIn(delay: Duration(milliseconds: i * 50));
//       })),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // LEADERBOARD LIST — points বাদ, completion % + farz days
// // dynamic entries (LeaderboardEntry from leaderboardPreviewProvider)
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
//         // points বাদ — completion % primary metric
//         final pct = (e.completionPercentage as num?)?.toInt() ?? 0;
//         final farz = (e.farzCompletedDays as num?)?.toInt() ?? 0;

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
//                   if ((e.id ?? '').toString().isNotEmpty ||
//                       (e.district ?? '').toString().isNotEmpty)
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
//                 Text('$pct%',
//                     style: TextStyle(
//                         color: _rankColors[i],
//                         fontWeight: FontWeight.w900,
//                         fontSize: 13,
//                         height: 1)),
//                 Text('$farz ফরজ',
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
// // COMMUNITY ROW
// // ─────────────────────────────────────────────────────────────────────────────

// class _CommunityRow extends StatelessWidget {
//   final VoidCallback onRate, onShare;
//   const _CommunityRow({required this.onRate, required this.onShare});

//   @override
//   Widget build(BuildContext context) {
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       const Padding(
//           padding: EdgeInsets.only(bottom: 10),
//           child: Row(children: [
//             Text('💬', style: TextStyle(fontSize: 13)),
//             SizedBox(width: 6),
//             Text('কমিউনিটি',
//                 style: TextStyle(
//                     color: _C.textPri,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 13,
//                     letterSpacing: -0.1)),
//           ])),
//       Row(children: [
//         Expanded(
//             child: _CommCard(
//                 emoji: '⭐',
//                 title: 'রেটিং দিন',
//                 subtitle: 'Play Store এ রিভিউ',
//                 bg: const Color(0xFFFFFBF0),
//                 border: const Color(0xFFFFE082),
//                 accent: const Color(0xFF7A4500),
//                 iconBg: const Color(0xFFFFECB3),
//                 onTap: onRate)),
//         const SizedBox(width: 10),
//         Expanded(
//             child: _CommCard(
//                 emoji: '📤',
//                 title: 'শেয়ার করুন',
//                 subtitle: 'বন্ধুদের জানান',
//                 bg: const Color(0xFFEFF6FF),
//                 border: const Color(0xFFBFDBFE),
//                 accent: const Color(0xFF1D4ED8),
//                 iconBg: const Color(0xFFDBEAFE),
//                 onTap: onShare)),
//       ]),
//     ]);
//   }
// }

// class _CommCard extends StatelessWidget {
//   final String emoji, title, subtitle;
//   final Color bg, border, accent, iconBg;
//   final VoidCallback onTap;
//   const _CommCard(
//       {required this.emoji,
//       required this.title,
//       required this.subtitle,
//       required this.bg,
//       required this.border,
//       required this.accent,
//       required this.iconBg,
//       required this.onTap});

//   @override
//   Widget build(BuildContext context) => GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(13),
//         decoration: BoxDecoration(
//             color: bg,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: border, width: 0.8)),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Row(children: [
//             Container(
//                 width: 36,
//                 height: 36,
//                 decoration: BoxDecoration(
//                     color: iconBg, borderRadius: BorderRadius.circular(10)),
//                 child: Center(
//                     child: Text(emoji, style: const TextStyle(fontSize: 17)))),
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
//       ));
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // HOW IT WORKS
// // ─────────────────────────────────────────────────────────────────────────────

// class _HowItWorks extends StatelessWidget {
//   final VoidCallback onTap;
//   const _HowItWorks({required this.onTap});

//   @override
//   Widget build(BuildContext context) => GestureDetector(
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
//                 Text('আমল ট্র্যাকিং ও র‍্যাংকিং সম্পর্কে জানুন',
//                     style: TextStyle(color: _C.textSec, fontSize: 10.5)),
//               ])),
//           const Icon(Icons.chevron_right_rounded, color: _C.textHint, size: 18),
//         ]),
//       ));
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SHARED
// // ─────────────────────────────────────────────────────────────────────────────

// class _ListSkeleton extends StatelessWidget {
//   const _ListSkeleton();
//   @override
//   Widget build(BuildContext context) => Container(
//         height: 120,
//         decoration: BoxDecoration(
//             color: _C.card,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: _C.border, width: 0.5)),
//       ).animate(onPlay: (c) => c.repeat()).shimmer(
//           duration: 1200.ms,
//           colors: [_C.card, const Color(0xFFE8ECE8), _C.card]);
// }

// class _EmptyCard extends StatelessWidget {
//   final String label;
//   const _EmptyCard({required this.label});
//   @override
//   Widget build(BuildContext context) => Container(
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
//                   fontWeight: FontWeight.w500))));
// }

// class SectionHeaderCompact extends StatelessWidget {
//   final String title, action;
//   final VoidCallback onAction;
//   const SectionHeaderCompact(
//       {required this.title,
//       required this.action,
//       required this.onAction,
//       super.key});
//   @override
//   Widget build(BuildContext context) =>
//       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         Text(title,
//             style: const TextStyle(
//                 color: _C.textPri, fontWeight: FontWeight.w700, fontSize: 11)),
//         GestureDetector(
//             onTap: onAction,
//             child: Text(action,
//                 style: const TextStyle(
//                     color: _C.darkGreen,
//                     fontSize: 10,
//                     fontWeight: FontWeight.w600))),
//       ]);
// }
import 'package:amal_tracker/features/home/widgets/daily_cards_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
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
  static const purple = Color(0xFF7C3AED);
  static const purpleLight = Color(0xFFEDE9FE);
  static const amber = Color(0xFFF59E0B);
  static const red = Color(0xFFEF4444);
  static const textPri = Color(0xFF0A1A0F);
  static const textSec = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
  static const border = Color(0xFFE4EAE4);
  static const rankGold = Color(0xFFD4A843);
  static const rankSilver = Color(0xFF94A3B8);
  static const rankBronze = Color(0xFFCD7F32);
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
    ref.invalidate(leaderboardProvider);
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    // এখন home শুধু নিজের lightweight endpoint invalidate করে —
    // আগে পুরো monthly-progress (ভারী payload) invalidate হতো এখানে
    ref.invalidate(homeSummaryProvider);
    ref.invalidate(leaderboardProvider);
    await Future.delayed(const Duration(milliseconds: 500));
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
      if (await canLaunchUrl(uri)) {
        launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  Future<void> _handleShareApp() async {
    await Share.share(
      'Sabeq — নেক আমল ট্র্যাক করুন, নিজের অগ্রগতি দেখুন!\n\n'
      '📲 ডাউনলোড করুন:\nhttps://play.google.com/store/apps/details?id=com.yourcompany.sabeq',
      subject: 'Sabeq অ্যাপ — নেক আমলে এগিয়ে যাও',
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    // আগে progressSummaryProvider(year, month) — মাসিক স্ক্রিনের ভারী endpoint
    // ব্যবহার হতো শুধু home এর জন্য। এখন homeSummaryProvider — কোনো
    // category catalog, categoryStats, recentMonths ছাড়া হালকা payload।
    final summary = ref.watch(homeSummaryProvider);
    final board = ref.watch(leaderboardPreviewProvider);

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
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 90),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── 1. Greeting ──────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: _Greeting(user: user, summary: summary)
                          .animate()
                          .fadeIn(duration: 280.ms),
                    ),
                    const SizedBox(height: 12),

                    // ── 2. Hero Card ─────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: summary
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
                    ),
                    const SizedBox(height: 10),

                    // ── 3. Weekly Strip ───────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: summary
                          .when(
                            loading: () => const _WeekSkeleton(),
                            error: (_, __) => const _WeekStrip(summary: null),
                            data: (s) => _WeekStrip(summary: s),
                          )
                          .animate()
                          .fadeIn(delay: 90.ms, duration: 280.ms),
                    ),

                    const SizedBox(height: 11),
                    const DailyCardsSection(),

                    const SizedBox(height: 11),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Column(children: [
                        // ── 5. Month Glance — এক-লাইন সারাংশ + মাসিক স্ক্রিনে
                        //    যাওয়ার শর্টকাট। আগে এখানে recentMonths এর পূর্ণ
                        //    তালিকা (৩ মাসের ডেটা) দেখানো হতো, যেটার জন্য
                        //    ভারী monthly-progress endpoint লাগতো — এখন শুধু
                        //    বর্তমান মাসের glance (homeSummary তেই আছে),
                        //    বিস্তারিত compare করতে চাইলে "সব দেখুন" থেকে
                        //    মাসিক স্ক্রিনে যাবে।
                        summary.when(
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                          data: (s) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SecHead(
                                  title: 'এই মাসের অগ্রগতি',
                                  emoji: '📅',
                                  onSeeAll: () =>
                                      context.go(AppRoutes.monthlyView),
                                ).animate().fadeIn(delay: 135.ms),
                                const SizedBox(height: 10),
                                _MonthGlanceCard(glance: s.monthGlance)
                                    .animate()
                                    .fadeIn(delay: 148.ms),
                                const SizedBox(height: 20),
                              ],
                            );
                          },
                        ),

                        // ── 6. Leaderboard teaser — সম্পূর্ণ আলাদা concept,
                        //    এখানে কোনো পরিবর্তন হয়নি, নিজের আলাদা provider
                        //    থেকেই ডেটা আসে ─────────────────────────────────
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

                        // ── 7. Community ───────────────────────────────────
                        _CommunityRow(
                                onRate: _handleRateApp,
                                onShare: _handleShareApp)
                            .animate()
                            .fadeIn(delay: 192.ms),
                        const SizedBox(height: 20),

                        // ── 8. How it works ─────────────────────────────────
                        _HowItWorks(
                                onTap: () => context.push(AppRoutes.howItWorks))
                            .animate()
                            .fadeIn(delay: 200.ms),
                      ]),
                    )
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
// TOP BAR — অপরিবর্তিত
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
// GREETING — streak এখন সরাসরি HomeSummary.streakDays থেকে (আগে
// summary.currentMonth?.streakDays দিয়ে ProgressSummary থেকে বের করতে হতো)
// ─────────────────────────────────────────────────────────────────────────────

class _Greeting extends StatelessWidget {
  final dynamic user;
  final AsyncValue<HomeSummary> summary;
  const _Greeting({this.user, required this.summary});

  @override
  Widget build(BuildContext context) {
    final streak = summary.whenOrNull(data: (s) => s.streakDays) ?? 0;
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
// HERO CARD — এখন HomeSummary থেকে সরাসরি। আগে todayEntry.entries[] ক্লায়েন্ট
// সাইডে filter করে completedCount বের করতে হতো (PrayerMode চেক করে) — এখন
// backend already summary.today.completedCount হিসেব করে পাঠায়, তাই এখানে
// আর কোনো entries লজিক নেই। জামাত চিপ বাদ দেওয়া হয়েছে — আগে hardcoded
// `final jamaat = 0;` ছিল (সবসময় ০ দেখাতো, home-summary তে congregation
// count নেই — সেটা মাসিক স্ক্রিনের Fard section এর বিষয়, এখানে দরকার নেই)।
// ─────────────────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  final HomeSummary? summary;
  final VoidCallback onTap;
  const _HeroCard({this.summary, required this.onTap});

  String _winnerLabel(String? cat) => switch (cat) {
        'TOP_FARZ' => 'ফরজ চ্যাম্পিয়ন',
        'TOP_JAMAAT' => 'জামাত চ্যাম্পিয়ন',
        'TOP_QURAN' => 'কুরআন চ্যাম্পিয়ন',
        'TOP_STREAK' => 'সেরা ধারাবাহিকতা',
        _ => 'মাসিক বিজয়ী',
      };

  @override
  Widget build(BuildContext context) {
    final today = summary?.today;
    final glance = summary?.monthGlance;
    final isFemale = summary?.userGender == 'female';

    final todayCompleted = today?.completedCount ?? 0;
    final isExempt = (today?.isExemptDay ?? false) && isFemale;
    final hasToday = todayCompleted > 0 || isExempt;

    final pct = (glance?.completionPercentage ?? 0).clamp(0.0, 100.0);
    final daysActive = glance?.daysActive ?? 0;
    final rank = glance?.rank;
    final isWinner = glance?.isWinner ?? false;
    final farzDays = glance?.farzCompletedDays ?? 0;
    final eligDays = glance?.eligibleDays ?? 0;
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
                          Text(_winnerLabel(glance?.winnerCategory),
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
                            Text(isExempt ? 'আজ মাহলির দিন 🌸' : 'আজকের আমল',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.4),
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w500)),
                          ]),
                          const SizedBox(height: 4),
                          if (todayCompleted > 0)
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: '$todayCompleted',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                      height: 1,
                                      letterSpacing: -1)),
                              const TextSpan(
                                  text: ' টি আমল',
                                  style: TextStyle(
                                      color: Color(0x80FFFFFF),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500)),
                            ]))
                          else if (isExempt)
                            const Text('মাহলির দিন',
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
                          Text('${pct.toInt()}%',
                              style: TextStyle(
                                  color: _C.gold,
                                  fontSize: pct >= 100 ? 22 : 24,
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                  letterSpacing: -1)),
                          const SizedBox(height: 2),
                          Text('ফরজ সম্পন্ন',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.35),
                                  fontSize: 8.5)),
                          const SizedBox(height: 6),
                          if (rank != null)
                            _RightChip(
                                top: '#$rank', bottom: 'র‍্যাংক', isRank: true),
                        ]),
                  ]),
                  const SizedBox(height: 10),
                  const Divider(
                      height: 1, thickness: 0.5, color: Color(0x1AFFFFFF)),
                  const SizedBox(height: 8),
                  Row(children: [
                    _HeroChip(
                        value: '$daysActive/$daysInMonth',
                        label: 'সক্রিয় দিন'),
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
// WEEKLY STRIP — এখন summary.weekProgress (HomeSummary) থেকে, যেটার প্রতিটা
// দিনে completedCount আছে। আগে শুধু hasActivity (boolean) দিয়ে bar height
// বাইনারি ছিল (হয় পূর্ণ বার, না হয় প্রায় ফ্ল্যাট) — এখন completedCount
// অনুপাতে bar height গ্র্যাজুয়েটেড, তাই সপ্তাহের কোন দিন কতটা active ছিল
// সেটা visual gradation দিয়ে বোঝা যায়, কোনো point/score ছাড়াই।
// ─────────────────────────────────────────────────────────────────────────────

class _WeekStrip extends StatelessWidget {
  final HomeSummary? summary;
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
    final weekData = summary?.weekProgress ?? [];
    final isFemale = summary?.userGender == 'female';
    final today = DateTime.now();
    final activeDays = weekData.where((d) => d.hasActivity).length;
    final maxCount = weekData.isEmpty
        ? 1
        : weekData
            .map((d) => d.completedCount)
            .fold(0, (a, b) => b > a ? b : a)
            .clamp(1, 999);

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
          if (activeDays > 0) ...[
            Text('$activeDays',
                style: const TextStyle(
                    color: _C.green,
                    fontWeight: FontWeight.w800,
                    fontSize: 11)),
            const Text(' সক্রিয় দিন',
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

                    // completedCount অনুপাতে graduated height — সর্বনিম্ন
                    // দৃশ্যমান height থাকে যাতে ০ থাকলেও bar পুরো অদৃশ্য না হয়
                    final ratio = d.completedCount / maxCount;
                    final barH = d.hasActivity
                        ? (bH * ratio).clamp(bH * 0.28, bH)
                        : (bH * 0.12);

                    return Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        SizedBox(
                            height: lH,
                            child: Center(
                                child: d.hasActivity
                                    ? Icon(Icons.check_circle_rounded,
                                        size: 9,
                                        color: isTdy ? _C.darkGreen : _C.green)
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
                                            child: Text('🌸',
                                                style: TextStyle(fontSize: 7))))
                                    : d.hasActivity
                                        ? Container(
                                            height: barH,
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
                                                            _C.midGreen
                                                                .withOpacity(
                                                                    0.6),
                                                            _C.midGreen
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
// SECTION HEADER — অপরিবর্তিত
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
// MONTH GLANCE CARD — নতুন, _MonthHistoryList এর প্রতিস্থাপক।
//
// আগে এখানে recentMonths (৩ মাসের পূর্ণ তালিকা) স্ক্রলযোগ্য লিস্ট আকারে
// দেখানো হতো, যেটার জন্য পূর্ণ monthly-progress endpoint call করা লাগতো
// শুধু home এ। কিন্তু "প্রথম glance এ" ৩ মাসের compare দরকার নেই — সেটা
// সম্পূর্ণভাবে monthly screen এর কাজ (এবং সেখানে metric-selector সহ ভালোভাবে
// আছে)। home এ শুধু বর্তমান মাসের এক-লাইন সারাংশ দরকার, homeSummary এর
// monthGlance (৪টা scalar) দিয়েই এটা তৈরি — কোনো অতিরিক্ত endpoint call
// ছাড়াই (একই homeSummaryProvider এর ডেটা reuse)।
// ─────────────────────────────────────────────────────────────────────────────

class _MonthGlanceCard extends StatelessWidget {
  final MonthGlance glance;
  const _MonthGlanceCard({required this.glance});

  @override
  Widget build(BuildContext context) {
    final pct = (glance.completionPercentage / 100).clamp(0.0, 1.0);
    final color = pct > 0.7
        ? _C.green
        : pct > 0.4
            ? _C.amber
            : _C.red;
    final now = DateTime.now();
    final monthName = AppConstants.bengaliMonths[now.month - 1];
    final totalD = DateUtils.getDaysInMonth(now.year, now.month);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _C.border, width: 0.5)),
      child: Row(children: [
        Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        SizedBox(
            width: 56,
            child: Row(children: [
              Flexible(
                  child: Text(monthName,
                      style: const TextStyle(
                          color: _C.textPri,
                          fontWeight: FontWeight.w700,
                          fontSize: 12),
                      overflow: TextOverflow.ellipsis)),
              if (glance.isWinner) ...[
                const SizedBox(width: 3),
                const Text('🏆', style: TextStyle(fontSize: 9))
              ],
            ])),
        const SizedBox(width: 8),
        Text('${glance.daysActive}/$totalD দিন',
            style: const TextStyle(color: _C.textHint, fontSize: 9.5)),
        const SizedBox(width: 8),
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
                  color: color, fontSize: 9.5, fontWeight: FontWeight.w700)),
        ])),
        const SizedBox(width: 10),
        Text('${glance.farzCompletedDays}',
            style: const TextStyle(
                color: _C.textPri, fontWeight: FontWeight.w800, fontSize: 13)),
        const SizedBox(width: 2),
        Text('ফরজ',
            style: TextStyle(
                color: _C.textHint, fontSize: 9, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LEADERBOARD LIST — সম্পূর্ণ আলাদা concept, কোনো পরিবর্তন হয়নি
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
        final pct = (e.completionPercentage as num?)?.toInt() ?? 0;
        final farz = (e.farzCompletedDays as num?)?.toInt() ?? 0;

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
                  if ((e.id ?? '').toString().isNotEmpty ||
                      (e.district ?? '').toString().isNotEmpty)
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
                Text('$pct%',
                    style: TextStyle(
                        color: _rankColors[i],
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        height: 1)),
                Text('$farz ফরজ',
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
// COMMUNITY ROW — অপরিবর্তিত
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
// HOW IT WORKS — অপরিবর্তিত
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
                Text('আমল ট্র্যাকিং ও র‍্যাংকিং সম্পর্কে জানুন',
                    style: TextStyle(color: _C.textSec, fontSize: 10.5)),
              ])),
          const Icon(Icons.chevron_right_rounded, color: _C.textHint, size: 18),
        ]),
      ));
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED — অপরিবর্তিত
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
