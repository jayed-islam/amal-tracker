// // import 'package:amal_tracker/features/leaderboard/providers/leaderboard_provider.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import '../providers/tracker_provider.dart';
// // import '../models/tracker_model.dart';
// // import '../../../core/constants/app_constants.dart';

// // // ─────────────────────────────────────────────────────────────────────────────
// // // DESIGN TOKENS — same as home_screen.dart ColorT
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _C {
// //   static const pageBg = Color(0xFFF4F6F1);
// //   static const cardBg = Color(0xFFFFFFFF);
// //   static const darkGreen = Color(0xFF0E3D22);
// //   static const midGreen = Color(0xFF1B7045);
// //   static const gold = Color(0xFFD4A843);
// //   static const goldLight = Color(0xFFFFF3E0);
// //   static const goldBorder = Color(0xFFFFCC80);
// //   static const goldPale = Color(0xFFFFFBF0);
// //   static const green = Color(0xFF16A34A);
// //   static const greenLight = Color(0xFFE8F5EE);
// //   static const amber = Color(0xFFFF6B35);
// //   static const amberLight = Color(0xFFFFF3E0);
// //   static const purple = Color(0xFF7C3AED);
// //   static const purpleLight = Color(0xFFEDE9FE);
// //   static const red = Color(0xFFEF4444);
// //   static const textPrimary = Color(0xFF0A1A0F);
// //   static const textSecondary = Color(0xFF6B7C6E);
// //   static const textHint = Color(0xFFABBAAE);
// //   static const border = Color(0xFFE4EAE4);
// //   static const borderMid = Color(0xFFD0DAD2);
// //   static const goldLight2 = Color(0xFFFFF8E7); // for ⭐ card
// //   static const darkGreenLight =
// //       Color(0xFFE8F0EC); // for 🎯 card (lighter version of darkGreen)
// //   static const redLight = Color(0xFFFEE2E2);
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SCREEN
// // // ─────────────────────────────────────────────────────────────────────────────

// // class MonthlyViewScreen extends ConsumerStatefulWidget {
// //   const MonthlyViewScreen({super.key});

// //   @override
// //   ConsumerState<MonthlyViewScreen> createState() => _MonthlyViewScreenState();
// // }

// // class _MonthlyViewScreenState extends ConsumerState<MonthlyViewScreen> {
// //   late int _year;
// //   late int _month;
// //   final _sc = ScrollController();

// //   @override
// //   void initState() {
// //     super.initState();
// //     final now = DateTime.now();
// //     _year = now.year;
// //     _month = now.month;
// //   }

// //   @override
// //   void dispose() {
// //     _sc.dispose();
// //     super.dispose();
// //   }

// //   void _showPeriodPicker() {
// //     showModalBottomSheet(
// //       context: context,
// //       backgroundColor: Colors.transparent,
// //       isScrollControlled: true,
// //       builder: (_) => _PeriodPickerSheet(
// //         year: _year,
// //         month: _month,
// //         onPicked: (y, m) => setState(() {
// //           _year = y;
// //           _month = m;
// //         }),
// //       ),
// //     );
// //   }

// //   Future<void> _refreshTracker() async {
// //     final f = ref.read(leaderboardFilterProvider);
// //     // Invalidate both providers to force refresh
// //     ref.invalidate(monthlyTrackerProvider((year: f.year, month: f.month)));
// //     await Future.microtask(() {
// //       ref.refresh(monthlyTrackerProvider((year: f.year, month: f.month)));
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final params = (year: _year, month: _month);
// //     final entriesAsync = ref.watch(monthlyEntriesProvider(params));
// //     final trackerAsync = ref.watch(monthlyTrackerProvider(params));
// //     final monthName = AppConstants.bengaliMonths[_month - 1];

// //     return AnnotatedRegion<SystemUiOverlayStyle>(
// //       value:
// //           SystemUiOverlayStyle.light, // dark → light (dark green bar-এর জন্য)
// //       child: Scaffold(
// //         backgroundColor: _C.pageBg,
// //         // appBar সরিয়ে দাও — এখন SliverAppBar ব্যবহার হবে
// //         body: RefreshIndicator(
// //           color: _C.darkGreen,
// //           onRefresh: () async {
// //             ref.invalidate(monthlyEntriesProvider(params));
// //             ref.invalidate(monthlyTrackerProvider(params));
// //           },
// //           child: CustomScrollView(
// //             controller: _sc,
// //             physics: const AlwaysScrollableScrollPhysics(),
// //             slivers: [
// //               // ── Zone 1: STICKY APP BAR ───────────────────────────────────
// //               SliverAppBar(
// //                 pinned: true,
// //                 floating: false,
// //                 snap: false,
// //                 expandedHeight: 0,
// //                 toolbarHeight: 56,
// //                 backgroundColor: _C.darkGreen,
// //                 surfaceTintColor: Colors.transparent,
// //                 shadowColor: Colors.transparent,
// //                 automaticallyImplyLeading: false,
// //                 systemOverlayStyle: SystemUiOverlayStyle.light,
// //                 title: Row(
// //                   children: [
// //                     // Icon badge
// //                     Container(
// //                       width: 30,
// //                       height: 30,
// //                       decoration: BoxDecoration(
// //                         color: Colors.white.withOpacity(0.1),
// //                         borderRadius: BorderRadius.circular(8),
// //                         border: Border.all(
// //                           color: Colors.white.withOpacity(0.15),
// //                           width: 0.5,
// //                         ),
// //                       ),
// //                       child: const Icon(
// //                         Icons.calendar_month_outlined,
// //                         color: Colors.white,
// //                         size: 15,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10),
// //                     Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         Text(
// //                           'মাসিক রিপোর্ট',
// //                           style: TextStyle(
// //                             color: Colors.white.withOpacity(0.55),
// //                             fontSize: 10,
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                         Text(
// //                           '$monthName $_year',
// //                           style: const TextStyle(
// //                             color: Colors.white,
// //                             fontSize: 14,
// //                             fontWeight: FontWeight.w800,
// //                             letterSpacing: -0.3,
// //                             height: 1.1,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //                 actions: [
// //                   GestureDetector(
// //                     onTap: _showPeriodPicker,
// //                     child: Container(
// //                       margin: const EdgeInsets.only(right: 16),
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 11, vertical: 6),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white.withOpacity(0.1),
// //                         borderRadius: BorderRadius.circular(10),
// //                         border: Border.all(
// //                           color: Colors.white.withOpacity(0.18),
// //                           width: 0.5,
// //                         ),
// //                       ),
// //                       child: Row(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Icon(
// //                             Icons.swap_horiz_rounded,
// //                             size: 13,
// //                             color: Colors.white.withOpacity(0.7),
// //                           ),
// //                           const SizedBox(width: 5),
// //                           const Text(
// //                             'মাস বদলান',
// //                             style: TextStyle(
// //                               color: Colors.white,
// //                               fontWeight: FontWeight.w700,
// //                               fontSize: 12,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),

// //               // ── Zone 2: HERO BAND (scrolls away) ─────────────────────────
// //               SliverToBoxAdapter(
// //                 child: trackerAsync
// //                     .when(
// //                       loading: () => const _HeroBandSkeleton(),
// //                       error: (error, stackTrace) => _HeroBandErrorCard(
// //                         message: error.toString(),
// //                         onRetry: () => _refreshTracker(),
// //                       ),
// //                       data: (t) => _HeroBand(
// //                         year: _year,
// //                         month: _month,
// //                         tracker: t,
// //                       ),
// //                     )
// //                     .animate()
// //                     .fadeIn(duration: 280.ms),
// //               ),

// //               // ── Zone 3: STAT STRIP (scrolls with content) ─────────────────
// //               // SliverToBoxAdapter(
// //               //   child: trackerAsync
// //               //       .when(
// //               //         loading: () => const _StatStripSkeleton(),
// //               //         error: (_, __) => const _StatStrip(tracker: null),
// //               //         data: (t) => _StatStrip(
// //               //           tracker: t,
// //               //           entries: entriesAsync.valueOrNull,
// //               //         ),
// //               //       )
// //               //       .animate()
// //               //       .fadeIn(delay: 60.ms, duration: 260.ms),
// //               // ),
// //               SliverToBoxAdapter(
// //                 child: Consumer(
// //                   builder: (context, ref, _) {
// //                     final trackerAsync =
// //                         ref.watch(monthlyTrackerProvider(params));
// //                     final entriesAsync =
// //                         ref.watch(monthlyEntriesProvider(params));

// //                     return trackerAsync.when(
// //                       loading: () => const _StatStripSkeleton(),
// //                       error: (_, __) =>
// //                           const _StatStrip(tracker: null, entries: null),
// //                       data: (tracker) => _StatStrip(
// //                         tracker: tracker,
// //                         entries: entriesAsync.valueOrNull,
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),

// //               // ── Zone 4: CALENDAR + DAY LIST ───────────────────────────────
// //               SliverPadding(
// //                 padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
// //                 sliver: entriesAsync.when(
// //                   loading: () => SliverToBoxAdapter(
// //                     child: _EntriesSkeleton()
// //                         .animate()
// //                         .fadeIn(delay: 80.ms, duration: 260.ms),
// //                   ),
// //                   error: (_, __) => SliverToBoxAdapter(
// //                     child: _ErrorCard(
// //                       onRetry: () {
// //                         ref.invalidate(monthlyEntriesProvider(params));
// //                       },
// //                     ).animate().fadeIn(duration: 260.ms),
// //                   ),
// //                   data: (entries) => SliverList(
// //                     delegate: SliverChildListDelegate([
// //                       const SizedBox(height: 15),
// //                       _SectionHeader(title: 'দৈনিক ক্যালেন্ডার', emoji: '📅')
// //                           .animate()
// //                           .fadeIn(delay: 100.ms),
// //                       const SizedBox(height: 10),
// //                       _HeatmapCalendar(
// //                         year: _year,
// //                         month: _month,
// //                         entries: entries,
// //                       ).animate().fadeIn(delay: 120.ms, duration: 300.ms),
// //                       const SizedBox(height: 22),
// //                       _SectionHeader(title: 'দিন অনুযায়ী পয়েন্ট', emoji: '📋')
// //                           .animate()
// //                           .fadeIn(delay: 150.ms),
// //                       const SizedBox(height: 10),
// //                       if (entries.isEmpty)
// //                         _EmptyCard(
// //                           label:
// //                               '${AppConstants.bengaliMonths[_month - 1]} মাসে কোনো আমল নেই',
// //                         ).animate().fadeIn(delay: 160.ms)
// //                       else
// //                         Container(
// //                           decoration: BoxDecoration(
// //                             color: _C.cardBg,
// //                             borderRadius: BorderRadius.circular(16),
// //                             border: Border.all(color: _C.border, width: 0.5),
// //                           ),
// //                           child: Column(
// //                             children: List.generate(entries.length, (i) {
// //                               final e = entries[i];
// //                               final isLast = i == entries.length - 1;
// //                               return _DayRow(
// //                                 entry: e,
// //                                 isLast: isLast,
// //                                 delay: 160 + i * 30,
// //                               );
// //                             }),
// //                           ),
// //                         ).animate().fadeIn(delay: 160.ms, duration: 280.ms),
// //                     ]),
// //                   ),
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
// // // STICKY TOP BAR  (PreferredSizeWidget, same as home_screen.dart _TopBar)
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _TopBar extends StatelessWidget implements PreferredSizeWidget {
// //   final int year, month;
// //   final VoidCallback onBack;
// //   final VoidCallback onChangePeriod;

// //   const _TopBar({
// //     required this.year,
// //     required this.month,
// //     required this.onBack,
// //     required this.onChangePeriod,
// //   });

// //   @override
// //   Size get preferredSize => const Size.fromHeight(62);

// //   @override
// //   Widget build(BuildContext context) {
// //     final monthName = AppConstants.bengaliMonths[month - 1];

// //     return Container(
// //       color: _C.cardBg,
// //       child: SafeArea(
// //         bottom: false,
// //         child: Container(
// //           height: 62,
// //           padding: const EdgeInsets.symmetric(horizontal: 16),
// //           decoration: const BoxDecoration(
// //             color: _C.cardBg,
// //             border: Border(bottom: BorderSide(color: _C.border, width: 0.5)),
// //           ),
// //           child: Row(
// //             children: [
// //               // Back button
// //               Container(
// //                 width: 36,
// //                 height: 36,
// //                 decoration: BoxDecoration(
// //                   color: _C.pageBg,
// //                   borderRadius: BorderRadius.circular(10),
// //                   border: Border.all(color: _C.border, width: 0.5),
// //                 ),
// //                 child: const Icon(
// //                   Icons.calendar_month_outlined,
// //                   color: _C.darkGreen,
// //                   size: 16,
// //                 ),
// //               ),

// //               const SizedBox(width: 12),

// //               // Title block
// //               Expanded(
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const Text(
// //                       'মাসিক রিপোর্ট',
// //                       style: TextStyle(
// //                         color: _C.textSecondary,
// //                         fontSize: 10,
// //                         fontWeight: FontWeight.w500,
// //                       ),
// //                     ),
// //                     Text(
// //                       '$monthName $year',
// //                       style: const TextStyle(
// //                         color: _C.textPrimary,
// //                         fontWeight: FontWeight.w800,
// //                         fontSize: 15,
// //                         letterSpacing: -0.3,
// //                         height: 1.2,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               // Month switcher button
// //               GestureDetector(
// //                 onTap: onChangePeriod,
// //                 child: Container(
// //                   padding:
// //                       const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
// //                   decoration: BoxDecoration(
// //                     color: _C.greenLight,
// //                     borderRadius: BorderRadius.circular(10),
// //                     border: Border.all(color: _C.border, width: 0.5),
// //                   ),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: const [
// //                       Icon(
// //                         Icons.swap_horiz_rounded,
// //                         color: _C.darkGreen,
// //                         size: 15,
// //                       ),
// //                       SizedBox(width: 5),
// //                       Text(
// //                         'মাস বদলান',
// //                         style: TextStyle(
// //                           color: _C.darkGreen,
// //                           fontSize: 12,
// //                           fontWeight: FontWeight.w700,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
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
// // // HERO BAND  (dark-green, scrolls with content)
// // // ─────────────────────────────────────────────────────────────────────────────
// // class _HeroBand extends StatelessWidget {
// //   final int year, month;
// //   final MonthlyTracker? tracker;

// //   const _HeroBand({
// //     required this.year,
// //     required this.month,
// //     required this.tracker,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final screenWidth = MediaQuery.of(context).size.width;
// //     final isSmallScreen = screenWidth < 380;
// //     final isTablet = screenWidth >= 600;

// //     final totalPts = tracker?.totalPoints ?? 0;
// //     final pct = (tracker?.completionPercentage ?? 0).clamp(0.0, 100.0);
// //     final daysInMonth = DateUtils.getDaysInMonth(year, month);
// //     final daysCompleted = tracker?.daysCompleted ?? 0;
// //     final isWinner = tracker?.isWinner ?? false;
// //     final winnerCat = tracker?.winnerCategory;

// //     return Container(
// //       color: _C.darkGreen,
// //       child: Stack(
// //         children: [
// //           // Decorative circles - responsive positioning
// //           Positioned(
// //             top: -45,
// //             right: isSmallScreen ? -30 : -45,
// //             child: Container(
// //               width: isSmallScreen ? 100 : 140,
// //               height: isSmallScreen ? 100 : 140,
// //               decoration: const BoxDecoration(
// //                 shape: BoxShape.circle,
// //                 color: Color(0x0AFFFFFF),
// //               ),
// //             ),
// //           ),
// //           Positioned(
// //             bottom: -25,
// //             left: isSmallScreen ? 10 : 18,
// //             child: Container(
// //               width: isSmallScreen ? 60 : 88,
// //               height: isSmallScreen ? 60 : 88,
// //               decoration: const BoxDecoration(
// //                 shape: BoxShape.circle,
// //                 color: Color(0x07FFFFFF),
// //               ),
// //             ),
// //           ),

// //           Padding(
// //             padding: EdgeInsets.fromLTRB(
// //                 16, isSmallScreen ? 12 : 16, 16, isSmallScreen ? 16 : 20),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 // Tag pill
// //                 Text(
// //                   'মাসের আমলের সারসংক্ষেপ',
// //                   style: TextStyle(
// //                     color: Colors.white.withOpacity(0.4),
// //                     fontSize: isSmallScreen ? 10 : 11,
// //                     fontWeight: FontWeight.w500,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 5),

// //                 // Progress summary card
// //                 Container(
// //                   padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
// //                   decoration: BoxDecoration(
// //                     color: const Color(0x17FFFFFF),
// //                     borderRadius: BorderRadius.circular(14),
// //                     border:
// //                         Border.all(color: const Color(0x2EFFFFFF), width: 0.5),
// //                   ),
// //                   child: LayoutBuilder(
// //                     builder: (context, constraints) {
// //                       // Responsive layout based on available width
// //                       if (constraints.maxWidth < 400) {
// //                         return _buildCompactLayout(
// //                           pct: pct,
// //                           totalPts: totalPts,
// //                           daysCompleted: daysCompleted,
// //                           daysInMonth: daysInMonth,
// //                           isWinner: isWinner,
// //                           winnerCat: winnerCat,
// //                           isSmallScreen: isSmallScreen,
// //                         );
// //                       } else {
// //                         return _buildNormalLayout(
// //                           pct: pct,
// //                           totalPts: totalPts,
// //                           daysCompleted: daysCompleted,
// //                           daysInMonth: daysInMonth,
// //                           isWinner: isWinner,
// //                           winnerCat: winnerCat,
// //                           isSmallScreen: isSmallScreen,
// //                           isTablet: isTablet,
// //                         );
// //                       }
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildNormalLayout({
// //     required double pct,
// //     required int totalPts,
// //     required int daysCompleted,
// //     required int daysInMonth,
// //     required bool isWinner,
// //     required String? winnerCat,
// //     required bool isSmallScreen,
// //     required bool isTablet,
// //   }) {
// //     return Row(
// //       children: [
// //         // Circular progress ring
// //         _CircularProgressWidget(percentage: pct, size: isTablet ? 70 : 56),

// //         SizedBox(width: isSmallScreen ? 10 : 14),

// //         // Points block
// //         Expanded(
// //           flex: 2,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 _formatNumber(totalPts),
// //                 style: TextStyle(
// //                   color: Colors.white,
// //                   fontWeight: FontWeight.w900,
// //                   fontSize: isTablet ? 32 : (isSmallScreen ? 22 : 26),
// //                   letterSpacing: -0.5,
// //                   height: 1,
// //                 ),
// //                 maxLines: 1,
// //                 overflow: TextOverflow.ellipsis,
// //               ),
// //               const SizedBox(height: 4),
// //               Text(
// //                 'মোট পয়েন্ট',
// //                 style: TextStyle(
// //                   color: Colors.white.withOpacity(0.45),
// //                   fontSize: isSmallScreen ? 9 : 10,
// //                 ),
// //               ),
// //               if (isWinner) ...[
// //                 const SizedBox(height: 6),
// //                 Flexible(
// //                   child: Container(
// //                     padding:
// //                         const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
// //                     decoration: BoxDecoration(
// //                       color: _C.gold,
// //                       borderRadius: BorderRadius.circular(20),
// //                     ),
// //                     child: Row(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         const Text('🏆', style: TextStyle(fontSize: 10)),
// //                         const SizedBox(width: 4),
// //                         Flexible(
// //                           child: Text(
// //                             winnerCat ?? 'মাসিক বিজয়ী',
// //                             style: const TextStyle(
// //                               color: Colors.white,
// //                               fontSize: 10,
// //                               fontWeight: FontWeight.w700,
// //                             ),
// //                             overflow: TextOverflow.ellipsis,
// //                             maxLines: 1,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ],
// //           ),
// //         ),

// //         SizedBox(width: isSmallScreen ? 8 : 10),

// //         // Days completed
// //         Column(
// //           crossAxisAlignment: CrossAxisAlignment.end,
// //           children: [
// //             Text(
// //               '$daysCompleted/$daysInMonth',
// //               style: TextStyle(
// //                 color: Colors.white,
// //                 fontWeight: FontWeight.w800,
// //                 fontSize: isTablet ? 22 : (isSmallScreen ? 16 : 18),
// //                 letterSpacing: -0.4,
// //                 height: 1,
// //               ),
// //             ),
// //             const SizedBox(height: 4),
// //             Text(
// //               'সম্পন্ন দিন',
// //               style: TextStyle(
// //                 color: Colors.white.withOpacity(0.45),
// //                 fontSize: isSmallScreen ? 9 : 10,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildCompactLayout({
// //     required double pct,
// //     required int totalPts,
// //     required int daysCompleted,
// //     required int daysInMonth,
// //     required bool isWinner,
// //     required String? winnerCat,
// //     required bool isSmallScreen,
// //   }) {
// //     return Column(
// //       children: [
// //         // Top row with progress and points
// //         Row(
// //           children: [
// //             // Circular progress ring
// //             _CircularProgressWidget(percentage: pct, size: 50),

// //             const SizedBox(width: 12),

// //             // Points block
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     _formatNumber(totalPts),
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.w900,
// //                       fontSize: 22,
// //                       letterSpacing: -0.5,
// //                       height: 1,
// //                     ),
// //                     maxLines: 1,
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                   const SizedBox(height: 2),
// //                   Text(
// //                     'মোট পয়েন্ট',
// //                     style: TextStyle(
// //                       color: Colors.white.withOpacity(0.45),
// //                       fontSize: 9,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),

// //             // Days completed
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.end,
// //               children: [
// //                 Text(
// //                   '$daysCompleted/$daysInMonth',
// //                   style: TextStyle(
// //                     color: Colors.white,
// //                     fontWeight: FontWeight.w800,
// //                     fontSize: 16,
// //                     letterSpacing: -0.4,
// //                     height: 1,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 2),
// //                 Text(
// //                   'সম্পন্ন দিন',
// //                   style: TextStyle(
// //                     color: Colors.white.withOpacity(0.45),
// //                     fontSize: 9,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),

// //         // Winner badge in a new row for compact layout
// //         if (isWinner) ...[
// //           const SizedBox(height: 10),
// //           Align(
// //             alignment: Alignment.centerLeft,
// //             child: Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
// //               decoration: BoxDecoration(
// //                 color: _C.gold,
// //                 borderRadius: BorderRadius.circular(20),
// //               ),
// //               child: Row(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   const Text('🏆', style: TextStyle(fontSize: 10)),
// //                   const SizedBox(width: 4),
// //                   Flexible(
// //                     child: Text(
// //                       winnerCat ?? 'মাসিক বিজয়ী',
// //                       style: const TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 10,
// //                         fontWeight: FontWeight.w700,
// //                       ),
// //                       overflow: TextOverflow.ellipsis,
// //                       maxLines: 1,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ],
// //     );
// //   }

// //   String _formatNumber(int number) {
// //     if (number >= 1000) {
// //       return '${(number / 1000).toStringAsFixed(1)}K';
// //     }
// //     return number.toString();
// //   }
// // }

// // // Separate widget for circular progress to keep code clean
// // class _CircularProgressWidget extends StatelessWidget {
// //   final double percentage;
// //   final double size;

// //   const _CircularProgressWidget({
// //     required this.percentage,
// //     required this.size,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final percentageStr = '${percentage.toInt()}%';
// //     final digitCount = percentageStr.length;

// //     // Adjust font size based on number of digits and container size
// //     double fontSize;
// //     if (size <= 50) {
// //       fontSize = digitCount == 3 ? 9 : (digitCount == 2 ? 11 : 12);
// //     } else if (size <= 56) {
// //       fontSize = digitCount == 3 ? 10 : (digitCount == 2 ? 12 : 14);
// //     } else {
// //       fontSize = digitCount == 3 ? 12 : (digitCount == 2 ? 14 : 16);
// //     }

// //     final innerSize = size - (size * 0.18); // Inner circle size (82% of outer)

// //     return SizedBox(
// //       width: size,
// //       height: size,
// //       child: Stack(
// //         alignment: Alignment.center,
// //         children: [
// //           // Progress circle
// //           SizedBox.expand(
// //             child: CircularProgressIndicator(
// //               value: percentage / 100,
// //               backgroundColor: Colors.white.withOpacity(0.12),
// //               valueColor: const AlwaysStoppedAnimation(_C.gold),
// //               strokeWidth: size * 0.09, // Responsive stroke width
// //               strokeCap: StrokeCap.round,
// //             ),
// //           ),
// //           // Inner circle mask to prevent overlap
// //           Container(
// //             width: innerSize,
// //             height: innerSize,
// //             decoration: BoxDecoration(
// //               color: _C.darkGreen,
// //               shape: BoxShape.circle,
// //             ),
// //             child: Center(
// //               child: FittedBox(
// //                 fit: BoxFit.scaleDown,
// //                 child: Padding(
// //                   padding: EdgeInsets.all(size * 0.05),
// //                   child: Column(
// //                     mainAxisSize: MainAxisSize.min,
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Text(
// //                         percentageStr,
// //                         style: TextStyle(
// //                           color: Colors.white,
// //                           fontWeight: FontWeight.w900,
// //                           fontSize: fontSize,
// //                           height: 1,
// //                         ),
// //                         textAlign: TextAlign.center,
// //                       ),
// //                       SizedBox(height: size * 0.02),
// //                       Text(
// //                         'সম্পন্ন',
// //                         style: TextStyle(
// //                           color: Colors.white.withOpacity(0.45),
// //                           fontSize: size * 0.13,
// //                         ),
// //                         textAlign: TextAlign.center,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _HeroBandSkeleton extends StatelessWidget {
// //   const _HeroBandSkeleton();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: _C.darkGreen,
// //       child: Padding(
// //         padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // Tag pill skeleton with shimmer
// //             Container(
// //               width: 120,
// //               height: 11,
// //               decoration: BoxDecoration(
// //                 color: Colors.white.withOpacity(0.1),
// //                 borderRadius: BorderRadius.circular(4),
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             // Main card skeleton
// //             Container(
// //               height: 92,
// //               decoration: BoxDecoration(
// //                 color: Colors.white.withOpacity(0.08),
// //                 borderRadius: BorderRadius.circular(14),
// //               ),
// //               child: Row(
// //                 children: [
// //                   // Left side skeleton
// //                   Padding(
// //                     padding: const EdgeInsets.all(14),
// //                     child: Row(
// //                       children: [
// //                         // Circle progress placeholder
// //                         Container(
// //                           width: 56,
// //                           height: 56,
// //                           decoration: BoxDecoration(
// //                             color: Colors.white.withOpacity(0.05),
// //                             shape: BoxShape.circle,
// //                           ),
// //                         ),
// //                         const SizedBox(width: 14),
// //                         // Text placeholders
// //                         Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Container(
// //                               width: 60,
// //                               height: 20,
// //                               color: Colors.white.withOpacity(0.05),
// //                             ),
// //                             const SizedBox(height: 4),
// //                             Container(
// //                               width: 80,
// //                               height: 10,
// //                               color: Colors.white.withOpacity(0.03),
// //                             ),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ).animate(onPlay: (c) => c.repeat()).shimmer(
// //               duration: 1200.ms,
// //               colors: [
// //                 Colors.white.withOpacity(0.02),
// //                 Colors.white.withOpacity(0.08),
// //                 Colors.white.withOpacity(0.02),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // HeroBand Error Card - matches the error style from your app
// // class _HeroBandErrorCard extends StatelessWidget {
// //   final String message;
// //   final VoidCallback onRetry;

// //   const _HeroBandErrorCard({
// //     required this.message,
// //     required this.onRetry,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: _C.darkGreen,
// //       child: Padding(
// //         padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'মাসের আমলের সারসংক্ষেপ',
// //               style: TextStyle(
// //                 color: Colors.white.withOpacity(0.4),
// //                 fontSize: 11,
// //                 fontWeight: FontWeight.w500,
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             Container(
// //               padding: const EdgeInsets.all(14),
// //               decoration: BoxDecoration(
// //                 color: Colors.white.withOpacity(0.09),
// //                 borderRadius: BorderRadius.circular(14),
// //                 border: Border.all(
// //                   color: Colors.white.withOpacity(0.18),
// //                   width: 0.5,
// //                 ),
// //               ),
// //               child: Row(
// //                 children: [
// //                   // Error icon in circle
// //                   Container(
// //                     width: 56,
// //                     height: 56,
// //                     decoration: BoxDecoration(
// //                       color: _C.red.withOpacity(0.2),
// //                       shape: BoxShape.circle,
// //                     ),
// //                     child: const Icon(
// //                       Icons.error_outline_rounded,
// //                       color: Colors.white,
// //                       size: 28,
// //                     ),
// //                   ),
// //                   const SizedBox(width: 14),
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         const Text(
// //                           'লোড করতে পারেনি',
// //                           style: TextStyle(
// //                             color: Colors.white,
// //                             fontWeight: FontWeight.w800,
// //                             fontSize: 16,
// //                             letterSpacing: -0.3,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 4),
// //                         Text(
// //                           message.length > 40
// //                               ? '${message.substring(0, 40)}...'
// //                               : message,
// //                           style: TextStyle(
// //                             color: Colors.white.withOpacity(0.5),
// //                             fontSize: 10,
// //                           ),
// //                           maxLines: 2,
// //                           overflow: TextOverflow.ellipsis,
// //                         ),
// //                         const SizedBox(height: 8),
// //                         GestureDetector(
// //                           onTap: onRetry,
// //                           child: Container(
// //                             padding: const EdgeInsets.symmetric(
// //                               horizontal: 14,
// //                               vertical: 5,
// //                             ),
// //                             decoration: BoxDecoration(
// //                               color: Colors.white.withOpacity(0.15),
// //                               borderRadius: BorderRadius.circular(8),
// //                               border: Border.all(
// //                                 color: Colors.white.withOpacity(0.2),
// //                                 width: 0.5,
// //                               ),
// //                             ),
// //                             child: const Text(
// //                               'পুনরায় চেষ্টা করুন →',
// //                               style: TextStyle(
// //                                 color: Colors.white,
// //                                 fontWeight: FontWeight.w700,
// //                                 fontSize: 11,
// //                               ),
// //                             ),
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

// // // ─────────────────────────────────────────────────────────────────────────────
// // // STAT STRIP  (3 cards — streak, weekly, prayer)
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _StatStrip extends StatelessWidget {
// //   final MonthlyTracker? tracker;
// //   final List<DailyEntry>? entries;
// //   const _StatStrip({this.tracker, this.entries});

// //   int _getTotalAmalCount() {
// //     if (entries == null) return 0;
// //     int totalAmals = 0;
// //     for (var day in entries!) {
// //       for (var item in day.entries) {
// //         // Count ALL completed items (both prayer and non-prayer)
// //         if (item.completed) {
// //           totalAmals++;
// //         }
// //       }
// //     }
// //     return totalAmals;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final streak = tracker?.streakDays ?? 0;
// //     final weekly = tracker?.weeklyPoints ?? 0;
// //     final totalAmals = _getTotalAmalCount();
// //     // weeklyPrayer if available, else 0

// //     // replace with tracker?.prayerPoints if model has it

// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             child: _StatCard(
// //               emoji: '🔥',
// //               emojiBgColor: _C.amberLight,
// //               value: '$streak',
// //               label: 'স্ট্রিক দিন',
// //               valueColor: _C.amber,
// //             ),
// //           ),
// //           const SizedBox(width: 8),
// //           Expanded(
// //             child: _StatCard(
// //               emoji: '📿',
// //               emojiBgColor: _C.greenLight,
// //               value: '$weekly',
// //               label: 'সাপ্তাহিক',
// //               valueColor: _C.green,
// //             ),
// //           ),
// //           const SizedBox(width: 8),
// //           Expanded(
// //             child: _StatCard(
// //               emoji: '⭐', // Changed from 🕌
// //               emojiBgColor: _C.goldLight2,
// //               value: '$totalAmals',
// //               label: 'মোট আমল',
// //               valueColor: _C.gold,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _StatCard extends StatelessWidget {
// //   final String emoji;
// //   final String value;
// //   final String label;
// //   final Color emojiBgColor;
// //   final Color valueColor;

// //   const _StatCard({
// //     required this.emoji,
// //     required this.emojiBgColor,
// //     required this.value,
// //     required this.label,
// //     required this.valueColor,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         color: _C.cardBg,
// //         borderRadius: BorderRadius.circular(14),
// //         border: Border.all(color: _C.border, width: 0.5),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             width: 30,
// //             height: 30,
// //             decoration: BoxDecoration(
// //               color: emojiBgColor, // ✅ Now using the Color directly
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: Center(
// //               child: Text(emoji, style: const TextStyle(fontSize: 14)),
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             value,
// //             style: TextStyle(
// //               color: valueColor,
// //               fontWeight: FontWeight.w800,
// //               fontSize: 20,
// //               letterSpacing: -0.4,
// //               height: 1,
// //             ),
// //           ),
// //           const SizedBox(height: 2),
// //           Text(
// //             label,
// //             style: const TextStyle(
// //               color: _C.textSecondary,
// //               fontSize: 9.5,
// //               fontWeight: FontWeight.w500,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // class _StatStrip extends StatelessWidget {
// // //   final MonthlyTracker? tracker;
// // //   const _StatStrip({this.tracker});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final streak = tracker?.streakDays ?? 0;
// // //     final weekly = tracker?.weeklyPoints ?? 0;
// // //     // weeklyPrayer if available, else 0
// // //     final prayer = 0; // replace with tracker?.prayerPoints if model has it

// // //     return Padding(
// // //       padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
// // //       child: Row(
// // //         children: [
// // //           Expanded(
// // //             child: _StatCard(
// // //               emoji: '🔥',
// // //               emojiBg: _C.amberLight,
// // //               value: '$streak',
// // //               label: 'স্ট্রিক দিন',
// // //               valueColor: _C.amber,
// // //             ),
// // //           ),
// // //           const SizedBox(width: 8),
// // //           Expanded(
// // //             child: _StatCard(
// // //               emoji: '📿',
// // //               emojiBg: _C.greenLight,
// // //               value: '$weekly',
// // //               label: 'সাপ্তাহিক',
// // //               valueColor: _C.green,
// // //             ),
// // //           ),
// // //           const SizedBox(width: 8),
// // //           Expanded(
// // //             child: _StatCard(
// // //               emoji: '🕌',
// // //               emojiBg: _C.purpleLight,
// // //               value: '$prayer',
// // //               label: 'নামাজ pts',
// // //               valueColor: _C.purple,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _StatCard extends StatelessWidget {
// // //   final String emoji, emojiBg, value, label;
// // //   final Color emojiBgColor, valueColor;

// // //   const _StatCard({
// // //     required this.emoji,
// // //     required this.emojiBgColor, // Change to Color type
// // //     required this.value,
// // //     required this.label,
// // //     required this.valueColor,
// // //   });

// // //   // const _StatCard({
// // //   //   required this.emoji,
// // //   //   required this.emojiBgColor,
// // //   //   required this.value,
// // //   //   required this.label,
// // //   //   required this.valueColor,
// // //   // })  : emojiBgColor = const Color(0xFFE8F5EE), // unused, see below
// // //   //       super();

// // //   // Re-declare properly
// // //   // const _StatCard._({
// // //   //   required this.emoji,
// // //   //   required this.emojiBgColor,
// // //   //   required this.value,
// // //   //   required this.label,
// // //   //   required this.valueColor,
// // //   //   String emojiBg = '',
// // //   //   String label2 = '',
// // //   // });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       padding: const EdgeInsets.all(12),
// // //       decoration: BoxDecoration(
// // //         color: _C.cardBg,
// // //         borderRadius: BorderRadius.circular(14),
// // //         border: Border.all(color: _C.border, width: 0.5),
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Container(
// // //             width: 30,
// // //             height: 30,
// // //             decoration: BoxDecoration(
// // //               color: emojiBgColor,
// // //               borderRadius: BorderRadius.circular(8),
// // //             ),
// // //             child: Center(
// // //               child: Text(emoji, style: const TextStyle(fontSize: 14)),
// // //             ),
// // //           ),
// // //           const SizedBox(height: 8),
// // //           Text(
// // //             value,
// // //             style: TextStyle(
// // //               color: valueColor,
// // //               fontWeight: FontWeight.w800,
// // //               fontSize: 20,
// // //               letterSpacing: -0.4,
// // //               height: 1,
// // //             ),
// // //           ),
// // //           const SizedBox(height: 2),
// // //           Text(
// // //             label,
// // //             style: const TextStyle(
// // //               color: _C.textSecondary,
// // //               fontSize: 9.5,
// // //               fontWeight: FontWeight.w500,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // Fix: proper _StatCard with named emojiBg color parameter
// // // Re-written cleanly below as a standalone widget used by _StatStrip

// // class _SC extends StatelessWidget {
// //   final String emoji;
// //   final Color emojiBg;
// //   final String value, label;
// //   final Color valueColor;

// //   const _SC({
// //     required this.emoji,
// //     required this.emojiBg,
// //     required this.value,
// //     required this.label,
// //     required this.valueColor,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         color: _C.cardBg,
// //         borderRadius: BorderRadius.circular(14),
// //         border: Border.all(color: _C.border, width: 0.5),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             width: 30,
// //             height: 30,
// //             decoration: BoxDecoration(
// //               color: emojiBg,
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: Center(
// //               child: Text(emoji, style: const TextStyle(fontSize: 14)),
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             value,
// //             style: TextStyle(
// //               color: valueColor,
// //               fontWeight: FontWeight.w800,
// //               fontSize: 20,
// //               letterSpacing: -0.4,
// //               height: 1,
// //             ),
// //           ),
// //           const SizedBox(height: 2),
// //           Text(
// //             label,
// //             style: const TextStyle(
// //               color: _C.textSecondary,
// //               fontSize: 9.5,
// //               fontWeight: FontWeight.w500,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _StatStripSkeleton extends StatelessWidget {
// //   const _StatStripSkeleton();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
// //       child: Row(
// //         children: List.generate(3, (i) {
// //           return Expanded(
// //             child: Container(
// //               margin: EdgeInsets.only(left: i == 0 ? 0 : 8),
// //               height: 86,
// //               decoration: BoxDecoration(
// //                 color: _C.cardBg,
// //                 borderRadius: BorderRadius.circular(14),
// //               ),
// //             ).animate(onPlay: (c) => c.repeat()).shimmer(
// //               duration: 1200.ms,
// //               delay: Duration(milliseconds: i * 60),
// //               colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg],
// //             ),
// //           );
// //         }),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SECTION HEADER  (same as home_screen.dart)
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _SectionHeader extends StatelessWidget {
// //   final String title, emoji;

// //   const _SectionHeader({required this.title, required this.emoji});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       children: [
// //         Text(emoji, style: const TextStyle(fontSize: 14)),
// //         const SizedBox(width: 7),
// //         Text(
// //           title,
// //           style: const TextStyle(
// //             color: _C.textPrimary,
// //             fontWeight: FontWeight.w800,
// //             fontSize: 15,
// //             letterSpacing: -0.2,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // HEATMAP CALENDAR
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _HeatmapCalendar extends StatelessWidget {
// //   final int year, month;
// //   final List<DailyEntry> entries;

// //   const _HeatmapCalendar({
// //     required this.year,
// //     required this.month,
// //     required this.entries,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final daysInMonth = DateUtils.getDaysInMonth(year, month);
// //     final entryMap = {for (final e in entries) e.day: e};
// //     final maxPts = entries.isEmpty
// //         ? 1
// //         : entries
// //             .map((e) => e.totalPoints)
// //             .reduce((a, b) => a > b ? a : b)
// //             .clamp(1, 9999);
// //     final today = DateTime.now();
// //     final firstDay = DateTime(year, month, 1).weekday % 7;
// //     final totalCells = ((firstDay + daysInMonth) / 7).ceil() * 7;

// //     const weekdays = ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহঃ', 'শুক্র', 'শনি'];

// //     return Container(
// //       padding: const EdgeInsets.all(14),
// //       decoration: BoxDecoration(
// //         color: _C.cardBg,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: _C.border, width: 0.5),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Weekday labels
// //           Row(
// //             children: weekdays
// //                 .map(
// //                   (d) => Expanded(
// //                     child: Center(
// //                       child: Text(
// //                         d,
// //                         style: const TextStyle(
// //                           color: _C.textHint,
// //                           fontSize: 9.5,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 )
// //                 .toList(),
// //           ),

// //           const SizedBox(height: 6),

// //           // Day grid
// //           GridView.builder(
// //             shrinkWrap: true,
// //             physics: const NeverScrollableScrollPhysics(),
// //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //               crossAxisCount: 7,
// //               crossAxisSpacing: 3,
// //               mainAxisSpacing: 3,
// //               childAspectRatio: 1.1,
// //             ),
// //             itemCount: totalCells,
// //             itemBuilder: (ctx, index) {
// //               final dayNum = index - firstDay + 1;

// //               if (dayNum < 1 || dayNum > daysInMonth) {
// //                 return const SizedBox.shrink();
// //               }

// //               final pts = entryMap[dayNum]?.totalPoints ?? 0;
// //               final intensity = pts / maxPts;
// //               final isToday = today.year == year &&
// //                   today.month == month &&
// //                   today.day == dayNum;
// //               final isFuture = DateTime(year, month, dayNum).isAfter(today);

// //               // Colour based on intensity
// //               Color cellColor;
// //               Color numColor;
// //               if (isFuture) {
// //                 cellColor = _C.pageBg;
// //                 numColor = _C.textHint;
// //               } else if (pts == 0) {
// //                 cellColor = _C.greenLight.withOpacity(0.5);
// //                 numColor = _C.textHint;
// //               } else if (intensity < 0.25) {
// //                 cellColor = _C.green.withOpacity(0.18);
// //                 numColor = _C.green;
// //               } else if (intensity < 0.5) {
// //                 cellColor = _C.green.withOpacity(0.38);
// //                 numColor = _C.green;
// //               } else if (intensity < 0.75) {
// //                 cellColor = _C.green.withOpacity(0.60);
// //                 numColor = Colors.white;
// //               } else {
// //                 cellColor = _C.green.withOpacity(0.85);
// //                 numColor = Colors.white;
// //               }

// //               return Container(
// //                 decoration: BoxDecoration(
// //                   color: cellColor,
// //                   borderRadius: BorderRadius.circular(5),
// //                   border:
// //                       isToday ? Border.all(color: _C.gold, width: 1.5) : null,
// //                 ),
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Text(
// //                       '$dayNum',
// //                       style: TextStyle(
// //                         fontSize: 10,
// //                         fontWeight: FontWeight.w700,
// //                         color: numColor,
// //                         height: 1,
// //                       ),
// //                     ),
// //                     if (pts > 0 && !isFuture) ...[
// //                       Text(
// //                         '$pts',
// //                         style: TextStyle(
// //                           fontSize: 7.5,
// //                           color: numColor.withOpacity(0.7),
// //                           fontWeight: FontWeight.w600,
// //                           height: 1,
// //                         ),
// //                       ),
// //                     ],
// //                   ],
// //                 ),
// //               ).animate(delay: Duration(milliseconds: dayNum * 8)).scale(
// //                     begin: const Offset(0.7, 0.7),
// //                     duration: 200.ms,
// //                     curve: Curves.easeOut,
// //                   );
// //             },
// //           ),

// //           const SizedBox(height: 10),

// //           // Legend
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.end,
// //             children: [
// //               const Text(
// //                 'কম  ',
// //                 style: TextStyle(color: _C.textHint, fontSize: 9.5),
// //               ),
// //               ...List.generate(5, (i) {
// //                 return Container(
// //                   width: 12,
// //                   height: 12,
// //                   margin: const EdgeInsets.only(right: 3),
// //                   decoration: BoxDecoration(
// //                     color: i == 0
// //                         ? _C.greenLight
// //                         : _C.green.withOpacity(0.15 + i * 0.18),
// //                     borderRadius: BorderRadius.circular(3),
// //                   ),
// //                 );
// //               }),
// //               const Text(
// //                 '  বেশি',
// //                 style: TextStyle(color: _C.textHint, fontSize: 9.5),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // DAY ROW  (inside grouped card, same divider pattern as _MonthList in home)
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _DayRow extends StatelessWidget {
// //   final DailyEntry entry;
// //   final bool isLast;
// //   final int delay;

// //   const _DayRow({
// //     required this.entry,
// //     required this.isLast,
// //     required this.delay,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final completedCount = entry.entries.where((e) => e.completed).length;
// //     final prayerCount = entry.entries
// //         .where((e) =>
// //             e.completed &&
// //             e.prayerMode != null &&
// //             e.prayerMode != PrayerMode.missed)
// //         .length;
// //     final hasPoints = entry.totalPoints > 0;

// //     // Progress bar colour
// //     final barColor = completedCount > 15
// //         ? _C.green
// //         : completedCount > 8
// //             ? _C.amber
// //             : _C.darkGreen;

// //     String getMonthShortName(int monthIndex) {
// //       final fullMonthName = AppConstants.bengaliMonths[monthIndex];
// //       if (fullMonthName.length >= 3) {
// //         return fullMonthName.substring(0, 3);
// //       } else {
// //         return fullMonthName; // Return full name if shorter than 3 chars
// //       }
// //     }

// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
// //       decoration: BoxDecoration(
// //         color: hasPoints ? _C.greenLight.withOpacity(0.18) : Colors.transparent,
// //         border: isLast
// //             ? null
// //             : const Border(
// //                 bottom: BorderSide(color: _C.border, width: 0.5),
// //               ),
// //         borderRadius: isLast
// //             ? const BorderRadius.vertical(bottom: Radius.circular(16))
// //             : null,
// //       ),
// //       child: Row(
// //         children: [
// //           // Day number box
// //           Container(
// //             width: 42,
// //             height: 42,
// //             decoration: BoxDecoration(
// //               gradient: hasPoints
// //                   ? const LinearGradient(
// //                       colors: [_C.darkGreen, _C.midGreen],
// //                       begin: Alignment.topLeft,
// //                       end: Alignment.bottomRight,
// //                     )
// //                   : null,
// //               color: hasPoints ? null : _C.pageBg,
// //               borderRadius: BorderRadius.circular(12),
// //             ),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Text(
// //                   '${entry.day}',
// //                   style: TextStyle(
// //                     color: hasPoints ? Colors.white : _C.textHint,
// //                     fontWeight: FontWeight.w800,
// //                     fontSize: 16,
// //                     height: 1,
// //                   ),
// //                 ),
// //                 Text(
// //                   // ✅ Fixed: Use safe getMonthShortName function
// //                   getMonthShortName(entry.month - 1),
// //                   style: TextStyle(
// //                     color:
// //                         hasPoints ? Colors.white.withOpacity(0.6) : _C.textHint,
// //                     fontSize: 8.5,
// //                   ),
// //                 ),
// //                 // Text(
// //                 //   AppConstants.bengaliMonths[entry.month - 1].substring(0, 3),
// //                 //   style: TextStyle(
// //                 //     color:
// //                 //         hasPoints ? Colors.white.withOpacity(0.6) : _C.textHint,
// //                 //     fontSize: 8.5,
// //                 //   ),
// //                 // ),
// //               ],
// //             ),
// //           ),

// //           const SizedBox(width: 12),

// //           // Info block
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Row(
// //                   children: [
// //                     Text(
// //                       '$completedCount টি আমল',
// //                       style: TextStyle(
// //                         color: hasPoints ? _C.textPrimary : _C.textSecondary,
// //                         fontWeight: FontWeight.w700,
// //                         fontSize: 13,
// //                       ),
// //                     ),
// //                     if (prayerCount > 0) ...[
// //                       const SizedBox(width: 6),
// //                       Container(
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 7, vertical: 2),
// //                         decoration: BoxDecoration(
// //                           color: _C.greenLight,
// //                           borderRadius: BorderRadius.circular(99),
// //                         ),
// //                         child: Text(
// //                           '🕌 $prayerCount নামাজ',
// //                           style: const TextStyle(
// //                             color: _C.green,
// //                             fontSize: 9.5,
// //                             fontWeight: FontWeight.w700,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ],
// //                 ),
// //                 const SizedBox(height: 5),
// //                 ClipRRect(
// //                   borderRadius: BorderRadius.circular(99),
// //                   child: LinearProgressIndicator(
// //                     value: (completedCount / 20).clamp(0.0, 1.0),
// //                     minHeight: 4,
// //                     backgroundColor: _C.pageBg,
// //                     valueColor: AlwaysStoppedAnimation(
// //                         hasPoints ? barColor : _C.border),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),

// //           const SizedBox(width: 12),

// //           // Points
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.end,
// //             children: [
// //               Text(
// //                 '${entry.totalPoints}',
// //                 style: TextStyle(
// //                   color: hasPoints ? _C.darkGreen : _C.textHint,
// //                   fontWeight: FontWeight.w900,
// //                   fontSize: 18,
// //                   height: 1,
// //                 ),
// //               ),
// //               Text(
// //                 'pts',
// //                 style: TextStyle(
// //                   color: hasPoints ? _C.textSecondary : _C.textHint,
// //                   fontSize: 9.5,
// //                   fontWeight: FontWeight.w500,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     )
// //         .animate(delay: Duration(milliseconds: delay))
// //         .fadeIn(duration: 240.ms)
// //         .slideX(begin: 0.04, curve: Curves.easeOut);
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // PERIOD PICKER SHEET  (same handle + card style as home ProfileSheet)
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _PeriodPickerSheet extends StatefulWidget {
// //   final int year, month;
// //   final void Function(int, int) onPicked;

// //   const _PeriodPickerSheet({
// //     required this.year,
// //     required this.month,
// //     required this.onPicked,
// //   });

// //   @override
// //   State<_PeriodPickerSheet> createState() => _PeriodPickerSheetState();
// // }

// // class _PeriodPickerSheetState extends State<_PeriodPickerSheet> {
// //   late int _y, _m;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _y = widget.year;
// //     _m = widget.month;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final now = DateTime.now();

// //     return Container(
// //       decoration: const BoxDecoration(
// //         color: _C.cardBg,
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
// //       ),
// //       padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           // Handle
// //           Container(
// //             width: 40,
// //             height: 4,
// //             decoration: BoxDecoration(
// //               color: _C.border,
// //               borderRadius: BorderRadius.circular(99),
// //             ),
// //           ),

// //           const SizedBox(height: 22),

// //           const Text(
// //             'মাস বেছে নিন',
// //             style: TextStyle(
// //               color: _C.textPrimary,
// //               fontSize: 16,
// //               fontWeight: FontWeight.w700,
// //             ),
// //           ),

// //           const SizedBox(height: 18),

// //           // Year selector
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               _YearArrow(
// //                 icon: Icons.chevron_left_rounded,
// //                 onTap: () => setState(() => _y--),
// //                 enabled: true,
// //               ),
// //               Container(
// //                 padding:
// //                     const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
// //                 decoration: BoxDecoration(
// //                   color: _C.greenLight,
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: Text(
// //                   '$_y',
// //                   style: const TextStyle(
// //                     color: _C.darkGreen,
// //                     fontWeight: FontWeight.w800,
// //                     fontSize: 18,
// //                   ),
// //                 ),
// //               ),
// //               _YearArrow(
// //                 icon: Icons.chevron_right_rounded,
// //                 onTap: _y < now.year ? () => setState(() => _y++) : null,
// //                 enabled: _y < now.year,
// //               ),
// //             ],
// //           ),

// //           const SizedBox(height: 16),

// //           // Month grid
// //           GridView.builder(
// //             shrinkWrap: true,
// //             physics: const NeverScrollableScrollPhysics(),
// //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //               crossAxisCount: 4,
// //               crossAxisSpacing: 8,
// //               mainAxisSpacing: 8,
// //               childAspectRatio: 1.75,
// //             ),
// //             itemCount: 12,
// //             itemBuilder: (_, i) {
// //               final isSelected = i + 1 == _m;
// //               final isFuture = _y == now.year && i + 1 > now.month;

// //               return GestureDetector(
// //                 onTap: isFuture
// //                     ? null
// //                     : () {
// //                         widget.onPicked(_y, i + 1);
// //                         Navigator.pop(context);
// //                       },
// //                 child: AnimatedContainer(
// //                   duration: const Duration(milliseconds: 180),
// //                   decoration: BoxDecoration(
// //                     color: isSelected
// //                         ? _C.darkGreen
// //                         : isFuture
// //                             ? _C.pageBg
// //                             : _C.pageBg,
// //                     borderRadius: BorderRadius.circular(10),
// //                     border: Border.all(
// //                       color: isSelected
// //                           ? _C.darkGreen
// //                           : isFuture
// //                               ? _C.border.withOpacity(0.4)
// //                               : _C.border,
// //                       width: 0.5,
// //                     ),
// //                   ),
// //                   child: Center(
// //                     child: Text(
// //                       AppConstants.bengaliMonths[i],
// //                       style: TextStyle(
// //                         color: isSelected
// //                             ? Colors.white
// //                             : isFuture
// //                                 ? _C.textHint
// //                                 : _C.textSecondary,
// //                         fontSize: 12,
// //                         fontWeight:
// //                             isSelected ? FontWeight.w700 : FontWeight.w500,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               );
// //             },
// //           ),

// //           const SizedBox(height: 4),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _YearArrow extends StatelessWidget {
// //   final IconData icon;
// //   final VoidCallback? onTap;
// //   final bool enabled;

// //   const _YearArrow({
// //     required this.icon,
// //     required this.onTap,
// //     required this.enabled,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         width: 38,
// //         height: 38,
// //         margin: const EdgeInsets.symmetric(horizontal: 12),
// //         decoration: BoxDecoration(
// //           color: enabled ? _C.greenLight : _C.pageBg,
// //           borderRadius: BorderRadius.circular(10),
// //           border: Border.all(
// //             color: enabled ? _C.borderMid : _C.border,
// //             width: 0.5,
// //           ),
// //         ),
// //         child: Icon(
// //           icon,
// //           color: enabled ? _C.darkGreen : _C.textHint,
// //           size: 20,
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SKELETONS  (same shimmer pattern as home_screen.dart)
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _EntriesSkeleton extends StatelessWidget {
// //   const _EntriesSkeleton();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         const SizedBox(height: 22),
// //         // Section label
// //         _shimmerBar(width: 130, height: 14),
// //         const SizedBox(height: 12),
// //         // Calendar
// //         _shimmerBox(height: 240),
// //         const SizedBox(height: 22),
// //         // Section label
// //         _shimmerBar(width: 150, height: 14),
// //         const SizedBox(height: 12),
// //         // List
// //         Container(
// //           decoration: BoxDecoration(
// //             color: _C.cardBg,
// //             borderRadius: BorderRadius.circular(16),
// //             border: Border.all(color: _C.border, width: 0.5),
// //           ),
// //           child: Column(
// //             children: List.generate(5, (i) {
// //               final isLast = i == 4;
// //               return Container(
// //                 height: 64,
// //                 margin: const EdgeInsets.fromLTRB(14, 10, 14, 10),
// //                 decoration: BoxDecoration(
// //                   color: _C.pageBg,
// //                   borderRadius: BorderRadius.circular(10),
// //                   border: isLast
// //                       ? null
// //                       : const Border(
// //                           bottom: BorderSide(color: _C.border, width: 0.5),
// //                         ),
// //                 ),
// //               ).animate(onPlay: (c) => c.repeat()).shimmer(
// //                 duration: 1200.ms,
// //                 delay: Duration(milliseconds: i * 70),
// //                 colors: [_C.pageBg, const Color(0xFFE8ECE8), _C.pageBg],
// //               );
// //             }),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _shimmerBar({required double width, required double height}) {
// //     return Container(
// //       width: width,
// //       height: height,
// //       decoration: BoxDecoration(
// //         color: _C.cardBg,
// //         borderRadius: BorderRadius.circular(8),
// //       ),
// //     ).animate(onPlay: (c) => c.repeat()).shimmer(
// //       duration: 1200.ms,
// //       colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg],
// //     );
// //   }

// //   Widget _shimmerBox({required double height}) {
// //     return Container(
// //       width: double.infinity,
// //       height: height,
// //       decoration: BoxDecoration(
// //         color: _C.cardBg,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: _C.border, width: 0.5),
// //       ),
// //     ).animate(onPlay: (c) => c.repeat()).shimmer(
// //       duration: 1200.ms,
// //       colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg],
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // ERROR + EMPTY CARDS
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _ErrorCard extends StatelessWidget {
// //   final VoidCallback onRetry;
// //   const _ErrorCard({required this.onRetry});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.only(top: 24),
// //       padding: const EdgeInsets.all(24),
// //       decoration: BoxDecoration(
// //         color: _C.cardBg,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: _C.border, width: 0.5),
// //       ),
// //       child: Column(
// //         children: [
// //           const Icon(
// //             Icons.error_outline_rounded,
// //             color: Color(0xFFEF4444),
// //             size: 30,
// //           ),
// //           const SizedBox(height: 8),
// //           const Text(
// //             'ডেটা লোড ব্যর্থ হয়েছে',
// //             style: TextStyle(
// //               color: _C.textPrimary,
// //               fontWeight: FontWeight.w700,
// //               fontSize: 14,
// //             ),
// //           ),
// //           const SizedBox(height: 12),
// //           GestureDetector(
// //             onTap: onRetry,
// //             child: Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
// //               decoration: BoxDecoration(
// //                 color: _C.greenLight,
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //               child: const Text(
// //                 'পুনরায় চেষ্টা করুন',
// //                 style: TextStyle(
// //                   color: _C.darkGreen,
// //                   fontWeight: FontWeight.w700,
// //                   fontSize: 12,
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _EmptyCard extends StatelessWidget {
// //   final String label;
// //   const _EmptyCard({required this.label});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       height: 110,
// //       decoration: BoxDecoration(
// //         color: _C.cardBg,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: _C.border, width: 0.5),
// //       ),
// //       child: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             const Text('📭', style: TextStyle(fontSize: 22)),
// //             const SizedBox(height: 6),
// //             Text(
// //               label,
// //               textAlign: TextAlign.center,
// //               style: const TextStyle(
// //                 color: _C.textHint,
// //                 fontSize: 12,
// //                 fontWeight: FontWeight.w500,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import '../providers/tracker_provider.dart';
// // import '../models/tracker_model.dart';
// // import '../../../core/constants/app_constants.dart';

// // // ─────────────────────────────────────────────────────────────────────────────
// // // DESIGN TOKENS
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _C {
// //   static const pageBg = Color(0xFFF4F6F1);
// //   static const cardBg = Color(0xFFFFFFFF);
// //   static const darkGreen = Color(0xFF0E3D22);
// //   static const midGreen = Color(0xFF1B7045);
// //   static const gold = Color(0xFFD4A843);
// //   static const goldLight = Color(0xFFFFF3E0);
// //   static const goldLight2 = Color(0xFFFFF8E7);
// //   static const green = Color(0xFF16A34A);
// //   static const greenLight = Color(0xFFE8F5EE);
// //   static const amber = Color(0xFFFF6B35);
// //   static const amberLight = Color(0xFFFFF3E0);
// //   static const purple = Color(0xFF7C3AED);
// //   static const purpleLight = Color(0xFFEDE9FE);
// //   static const purplePale = Color(0xFFF3F0FF);
// //   static const red = Color(0xFFEF4444);
// //   static const redLight = Color(0xFFFEE2E2);
// //   static const textPrimary = Color(0xFF0A1A0F);
// //   static const textSecondary = Color(0xFF6B7C6E);
// //   static const textHint = Color(0xFFABBAAE);
// //   static const border = Color(0xFFE4EAE4);
// //   static const borderMid = Color(0xFFD0DAD2);
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // HELPERS – derived from real model data
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _Derived {
// //   // ── From List<DailyEntry> ─────────────────────────────────────────────────

// //   /// Total completed amal items across all days
// //   static int totalAmalCount(List<DailyEntry> entries) =>
// //       entries.fold(0, (s, d) => s + d.entries.where((e) => e.completed).length);

// //   /// Congregation prayer count (prayerMode == congregation AND completed)
// //   static int jamatCount(List<DailyEntry> entries) => entries.fold(
// //       0,
// //       (s, d) =>
// //           s +
// //           d.entries
// //               .where(
// //                 (e) => e.completed && e.prayerMode == PrayerMode.congregation,
// //               )
// //               .length);

// //   /// Missed prayer count
// //   static int missedPrayerCount(List<DailyEntry> entries) => entries.fold(
// //       0,
// //       (s, d) =>
// //           s +
// //           d.entries
// //               .where(
// //                 (e) => e.prayerMode == PrayerMode.missed,
// //               )
// //               .length);

// //   /// Solo prayer count
// //   static int soloPrayerCount(List<DailyEntry> entries) => entries.fold(
// //       0,
// //       (s, d) =>
// //           s +
// //           d.entries
// //               .where(
// //                 (e) => e.completed && e.prayerMode == PrayerMode.solo,
// //               )
// //               .length);

// //   /// Non-prayer completed amals (sunnah/nafl/dhikr etc.)
// //   static int nonPrayerCount(List<DailyEntry> entries) => entries.fold(
// //       0,
// //       (s, d) =>
// //           s +
// //           d.entries
// //               .where(
// //                 (e) => e.completed && e.prayerMode == null,
// //               )
// //               .length);

// //   /// Days with at least 1 completed amal
// //   static int activeDays(List<DailyEntry> entries) =>
// //       entries.where((d) => d.totalPoints > 0).length;

// //   /// Days with zero points (not future, not exempt)
// //   static int missDays(List<DailyEntry> entries) {
// //     final today = DateTime.now();
// //     return entries.where((d) {
// //       final date = DateTime(d.year, d.month, d.day);
// //       return !date.isAfter(today) && d.totalPoints == 0 && !d.isExemptDay;
// //     }).length;
// //   }

// //   /// Exempt days count
// //   static int exemptDayCount(List<DailyEntry> entries) =>
// //       entries.where((e) => e.isExemptDay).length;

// //   /// Average points per active day
// //   static int avgPointsPerDay(List<DailyEntry> entries) {
// //     final active = entries.where((d) => d.totalPoints > 0).toList();
// //     if (active.isEmpty) return 0;
// //     final total = active.fold(0, (s, d) => s + d.totalPoints);
// //     return (total / active.length).round();
// //   }

// //   /// Best single-day points
// //   static int bestDayPoints(List<DailyEntry> entries) => entries.isEmpty
// //       ? 0
// //       : entries.map((d) => d.totalPoints).reduce((a, b) => a > b ? a : b);

// //   // ── From MonthlyTracker ───────────────────────────────────────────────────

// //   /// Fard completion % derived from fardDone/totalFard in WeeklyBarData
// //   static double fardPct(List<WeeklyBarData> week) {
// //     final total = week.fold(0, (s, d) => s + d.totalFard);
// //     final done = week.fold(0, (s, d) => s + d.fardDone);
// //     if (total == 0) return 0;
// //     return (done / total * 100).clamp(0, 100);
// //   }

// //   static double jamatPct(List<WeeklyBarData> week) {
// //     final done = week.fold(0, (s, d) => s + d.jamatCount);
// //     final fard = week.fold(0, (s, d) => s + d.fardDone);
// //     if (fard == 0) return 0;
// //     return (done / fard * 100).clamp(0, 100);
// //   }

// //   static int weekSunnah(List<WeeklyBarData> week) =>
// //       week.fold(0, (s, d) => s + d.sunnahCount);
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SCREEN
// // // ─────────────────────────────────────────────────────────────────────────────

// // class MonthlyViewScreen extends ConsumerStatefulWidget {
// //   const MonthlyViewScreen({super.key});

// //   @override
// //   ConsumerState<MonthlyViewScreen> createState() => _MonthlyViewScreenState();
// // }

// // class _MonthlyViewScreenState extends ConsumerState<MonthlyViewScreen> {
// //   late int _year;
// //   late int _month;
// //   final _sc = ScrollController();

// //   @override
// //   void initState() {
// //     super.initState();
// //     final now = DateTime.now();
// //     _year = now.year;
// //     _month = now.month;
// //   }

// //   @override
// //   void dispose() {
// //     _sc.dispose();
// //     super.dispose();
// //   }

// //   void _showPeriodPicker() {
// //     showModalBottomSheet(
// //       context: context,
// //       backgroundColor: Colors.transparent,
// //       isScrollControlled: true,
// //       builder: (_) => _PeriodPickerSheet(
// //         year: _year,
// //         month: _month,
// //         onPicked: (y, m) => setState(() {
// //           _year = y;
// //           _month = m;
// //         }),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final params = (year: _year, month: _month);
// //     final entriesAsync = ref.watch(monthlyEntriesProvider(params));
// //     final trackerAsync = ref.watch(monthlyTrackerProvider(params));
// //     final progressAsync = ref.watch(progressSummaryProvider);
// //     final monthName = AppConstants.bengaliMonths[_month - 1];

// //     return AnnotatedRegion<SystemUiOverlayStyle>(
// //       value: SystemUiOverlayStyle.light,
// //       child: Scaffold(
// //         backgroundColor: _C.pageBg,
// //         body: RefreshIndicator(
// //           color: _C.darkGreen,
// //           onRefresh: () async {
// //             ref.invalidate(monthlyEntriesProvider(params));
// //             ref.invalidate(monthlyTrackerProvider(params));
// //             ref.invalidate(progressSummaryProvider);
// //           },
// //           child: CustomScrollView(
// //             controller: _sc,
// //             physics: const AlwaysScrollableScrollPhysics(),
// //             slivers: [
// //               // ── App Bar ───────────────────────────────────────────────────
// //               SliverAppBar(
// //                 pinned: true,
// //                 floating: false,
// //                 expandedHeight: 0,
// //                 toolbarHeight: 56,
// //                 backgroundColor: _C.darkGreen,
// //                 surfaceTintColor: Colors.transparent,
// //                 shadowColor: Colors.transparent,
// //                 automaticallyImplyLeading: false,
// //                 systemOverlayStyle: SystemUiOverlayStyle.light,
// //                 title: Row(
// //                   children: [
// //                     Container(
// //                       width: 30,
// //                       height: 30,
// //                       decoration: BoxDecoration(
// //                         color: Colors.white.withOpacity(0.1),
// //                         borderRadius: BorderRadius.circular(8),
// //                         border: Border.all(
// //                             color: Colors.white.withOpacity(0.15), width: 0.5),
// //                       ),
// //                       child: const Icon(Icons.calendar_month_outlined,
// //                           color: Colors.white, size: 15),
// //                     ),
// //                     const SizedBox(width: 10),
// //                     Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         Text('মাসিক রিপোর্ট',
// //                             style: TextStyle(
// //                                 color: Colors.white.withOpacity(0.55),
// //                                 fontSize: 10,
// //                                 fontWeight: FontWeight.w500)),
// //                         Text('$monthName $_year',
// //                             style: const TextStyle(
// //                                 color: Colors.white,
// //                                 fontSize: 14,
// //                                 fontWeight: FontWeight.w800,
// //                                 letterSpacing: -0.3,
// //                                 height: 1.1)),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //                 actions: [
// //                   GestureDetector(
// //                     onTap: _showPeriodPicker,
// //                     child: Container(
// //                       margin: const EdgeInsets.only(right: 16),
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 11, vertical: 6),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white.withOpacity(0.1),
// //                         borderRadius: BorderRadius.circular(10),
// //                         border: Border.all(
// //                             color: Colors.white.withOpacity(0.18), width: 0.5),
// //                       ),
// //                       child: Row(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Icon(Icons.swap_horiz_rounded,
// //                               size: 13, color: Colors.white.withOpacity(0.7)),
// //                           const SizedBox(width: 5),
// //                           const Text('মাস বদলান',
// //                               style: TextStyle(
// //                                   color: Colors.white,
// //                                   fontWeight: FontWeight.w700,
// //                                   fontSize: 12)),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),

// //               // ── Hero Band ─────────────────────────────────────────────────
// //               SliverToBoxAdapter(
// //                 child: trackerAsync
// //                     .when(
// //                       loading: () => const _HeroBandSkeleton(),
// //                       error: (_, __) => const _HeroBandSkeleton(),
// //                       data: (t) =>
// //                           _HeroBand(year: _year, month: _month, tracker: t),
// //                     )
// //                     .animate()
// //                     .fadeIn(duration: 280.ms),
// //               ),

// //               // ── Female Exempt Banner ──────────────────────────────────────
// //               SliverToBoxAdapter(
// //                 child: progressAsync.whenOrNull(
// //                       data: (p) {
// //                         final isF = p.userGender == 'female';
// //                         final count = entriesAsync.valueOrNull != null
// //                             ? _Derived.exemptDayCount(entriesAsync.valueOrNull!)
// //                             : 0;
// //                         if (!isF || count == 0) return const SizedBox.shrink();
// //                         return _ExemptBanner(exemptCount: count)
// //                             .animate()
// //                             .fadeIn(delay: 50.ms);
// //                       },
// //                     ) ??
// //                     const SizedBox.shrink(),
// //               ),

// //               // ── Stat Strip Row 1 ──────────────────────────────────────────
// //               SliverToBoxAdapter(
// //                 child: trackerAsync
// //                     .when(
// //                       loading: () => const _StatStripSkeleton(),
// //                       error: (_, __) => const _StatStripSkeleton(),
// //                       data: (t) => _StatStripRow1(
// //                         tracker: t,
// //                         entries: entriesAsync.valueOrNull ?? [],
// //                       ),
// //                     )
// //                     .animate()
// //                     .fadeIn(delay: 60.ms, duration: 260.ms),
// //               ),

// //               // ── Stat Strip Row 2 ──────────────────────────────────────────
// //               SliverToBoxAdapter(
// //                 child: entriesAsync
// //                     .when(
// //                       loading: () => const _StatStrip2Skeleton(),
// //                       error: (_, __) => const SizedBox.shrink(),
// //                       data: (entries) => _StatStripRow2(entries: entries),
// //                     )
// //                     .animate()
// //                     .fadeIn(delay: 80.ms, duration: 260.ms),
// //               ),

// //               // ── Weekly Chart ──────────────────────────────────────────────
// //               SliverToBoxAdapter(
// //                 child: progressAsync
// //                     .when(
// //                       loading: () => const _SectionSkeleton(height: 160),
// //                       error: (_, __) => const SizedBox.shrink(),
// //                       data: (p) => _WeeklyChartSection(
// //                         weekData: p.currentWeek,
// //                         userGender: p.userGender,
// //                       ),
// //                     )
// //                     .animate()
// //                     .fadeIn(delay: 100.ms, duration: 280.ms),
// //               ),

// //               // ── Fard & Jamat Cards ────────────────────────────────────────
// //               SliverToBoxAdapter(
// //                 child: progressAsync
// //                     .when(
// //                       loading: () => const _SectionSkeleton(height: 110),
// //                       error: (_, __) => const SizedBox.shrink(),
// //                       data: (p) => _FardJamatSection(weekData: p.currentWeek),
// //                     )
// //                     .animate()
// //                     .fadeIn(delay: 120.ms, duration: 280.ms),
// //               ),

// //               // ── Previous Months Chart ─────────────────────────────────────
// //               SliverToBoxAdapter(
// //                 child: progressAsync
// //                     .when(
// //                       loading: () => const _SectionSkeleton(height: 130),
// //                       error: (_, __) => const SizedBox.shrink(),
// //                       data: (p) {
// //                         final months = [
// //                           ...p.recentMonths,
// //                           if (p.currentMonth != null) p.currentMonth!,
// //                         ];
// //                         if (months.isEmpty) return const SizedBox.shrink();
// //                         return _PrevMonthsSection(months: months);
// //                       },
// //                     )
// //                     .animate()
// //                     .fadeIn(delay: 140.ms, duration: 280.ms),
// //               ),

// //               // ── Insights Grid ─────────────────────────────────────────────
// //               SliverToBoxAdapter(
// //                 child: entriesAsync
// //                     .when(
// //                       loading: () => const _SectionSkeleton(height: 110),
// //                       error: (_, __) => const SizedBox.shrink(),
// //                       data: (entries) => _InsightsSection(
// //                         entries: entries,
// //                         tracker: trackerAsync.valueOrNull,
// //                       ),
// //                     )
// //                     .animate()
// //                     .fadeIn(delay: 160.ms, duration: 280.ms),
// //               ),

// //               // ── Rank Card ─────────────────────────────────────────────────
// //               SliverToBoxAdapter(
// //                 child: trackerAsync.when(
// //                   loading: () => const SizedBox.shrink(),
// //                   error: (_, __) => const SizedBox.shrink(),
// //                   data: (t) {
// //                     if (t == null || t.rank == null)
// //                       return const SizedBox.shrink();
// //                     return _RankSection(tracker: t)
// //                         .animate()
// //                         .fadeIn(delay: 170.ms, duration: 280.ms);
// //                   },
// //                 ),
// //               ),

// //               // ── Calendar + Day List ───────────────────────────────────────
// //               SliverPadding(
// //                 padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
// //                 sliver: entriesAsync.when(
// //                   loading: () => SliverToBoxAdapter(
// //                       child: _EntriesSkeleton().animate().fadeIn(delay: 80.ms)),
// //                   error: (_, __) => SliverToBoxAdapter(
// //                     child: _ErrorCard(
// //                             onRetry: () =>
// //                                 ref.invalidate(monthlyEntriesProvider(params)))
// //                         .animate()
// //                         .fadeIn(),
// //                   ),
// //                   data: (entries) => SliverList(
// //                     delegate: SliverChildListDelegate([
// //                       const SizedBox(height: 15),
// //                       _SectionHeader(title: 'দৈনিক ক্যালেন্ডার', emoji: '📅')
// //                           .animate()
// //                           .fadeIn(delay: 180.ms),
// //                       const SizedBox(height: 10),
// //                       _HeatmapCalendar(
// //                               year: _year, month: _month, entries: entries)
// //                           .animate()
// //                           .fadeIn(delay: 200.ms, duration: 300.ms),
// //                       const SizedBox(height: 22),
// //                       _SectionHeader(
// //                               title: 'দিন অনুযায়ী বিস্তারিত', emoji: '📋')
// //                           .animate()
// //                           .fadeIn(delay: 210.ms),
// //                       const SizedBox(height: 10),
// //                       if (entries.isEmpty)
// //                         _EmptyCard(
// //                                 label:
// //                                     '${AppConstants.bengaliMonths[_month - 1]} মাসে কোনো আমল নেই')
// //                             .animate()
// //                             .fadeIn(delay: 220.ms)
// //                       else
// //                         Container(
// //                           decoration: BoxDecoration(
// //                             color: _C.cardBg,
// //                             borderRadius: BorderRadius.circular(16),
// //                             border: Border.all(color: _C.border, width: 0.5),
// //                           ),
// //                           child: Column(
// //                             children: List.generate(entries.length, (i) {
// //                               return _DayRow(
// //                                 entry: entries[i],
// //                                 isLast: i == entries.length - 1,
// //                                 delay: 220 + i * 25,
// //                               );
// //                             }),
// //                           ),
// //                         ).animate().fadeIn(delay: 220.ms, duration: 280.ms),
// //                     ]),
// //                   ),
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
// // // HERO BAND
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _HeroBand extends StatelessWidget {
// //   final int year, month;
// //   final MonthlyTracker? tracker;
// //   const _HeroBand(
// //       {required this.year, required this.month, required this.tracker});

// //   String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}K' : '$n';

// //   @override
// //   Widget build(BuildContext context) {
// //     final totalPts = tracker?.totalPoints ?? 0;
// //     final pct = (tracker?.completionPercentage ?? 0).clamp(0.0, 100.0);
// //     final daysInMonth = DateUtils.getDaysInMonth(year, month);
// //     final daysCompleted = tracker?.daysCompleted ?? 0;
// //     final isWinner = tracker?.isWinner ?? false;
// //     final winnerCat = tracker?.winnerCategory;
// //     final rank = tracker?.rank;

// //     return Container(
// //       color: _C.darkGreen,
// //       child: Stack(
// //         children: [
// //           // Decorative circles
// //           Positioned(
// //               top: -45,
// //               right: -40,
// //               child: Container(
// //                   width: 140,
// //                   height: 140,
// //                   decoration: const BoxDecoration(
// //                       shape: BoxShape.circle, color: Color(0x0AFFFFFF)))),
// //           Positioned(
// //               bottom: -25,
// //               left: 18,
// //               child: Container(
// //                   width: 88,
// //                   height: 88,
// //                   decoration: const BoxDecoration(
// //                       shape: BoxShape.circle, color: Color(0x07FFFFFF)))),

// //           Padding(
// //             padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text('মাসের আমলের সারসংক্ষেপ',
// //                     style: TextStyle(
// //                         color: Colors.white.withOpacity(0.4),
// //                         fontSize: 11,
// //                         fontWeight: FontWeight.w500)),
// //                 const SizedBox(height: 8),
// //                 Container(
// //                   padding: const EdgeInsets.all(14),
// //                   decoration: BoxDecoration(
// //                     color: const Color(0x17FFFFFF),
// //                     borderRadius: BorderRadius.circular(14),
// //                     border:
// //                         Border.all(color: const Color(0x2EFFFFFF), width: 0.5),
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       // Circular progress
// //                       _CircularProgressWidget(percentage: pct, size: 60),
// //                       const SizedBox(width: 14),

// //                       // Points + winner badge
// //                       Expanded(
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(_fmt(totalPts),
// //                                 style: const TextStyle(
// //                                     color: Colors.white,
// //                                     fontWeight: FontWeight.w900,
// //                                     fontSize: 28,
// //                                     letterSpacing: -0.5,
// //                                     height: 1),
// //                                 maxLines: 1,
// //                                 overflow: TextOverflow.ellipsis),
// //                             const SizedBox(height: 3),
// //                             Text('মোট পয়েন্ট',
// //                                 style: TextStyle(
// //                                     color: Colors.white.withOpacity(0.45),
// //                                     fontSize: 10)),
// //                             if (isWinner) ...[
// //                               const SizedBox(height: 6),
// //                               Container(
// //                                 padding: const EdgeInsets.symmetric(
// //                                     horizontal: 8, vertical: 3),
// //                                 decoration: BoxDecoration(
// //                                     color: _C.gold,
// //                                     borderRadius: BorderRadius.circular(20)),
// //                                 child: Row(
// //                                     mainAxisSize: MainAxisSize.min,
// //                                     children: [
// //                                       const Text('🏆',
// //                                           style: TextStyle(fontSize: 10)),
// //                                       const SizedBox(width: 4),
// //                                       Flexible(
// //                                           child: Text(
// //                                               winnerCat ?? 'মাসিক বিজয়ী',
// //                                               style: const TextStyle(
// //                                                   color: Colors.white,
// //                                                   fontSize: 10,
// //                                                   fontWeight: FontWeight.w700),
// //                                               overflow: TextOverflow.ellipsis,
// //                                               maxLines: 1)),
// //                                     ]),
// //                               ),
// //                             ],
// //                           ],
// //                         ),
// //                       ),

// //                       // Right column: days + rank
// //                       Column(
// //                         crossAxisAlignment: CrossAxisAlignment.end,
// //                         children: [
// //                           Text('$daysCompleted/$daysInMonth',
// //                               style: const TextStyle(
// //                                   color: Colors.white,
// //                                   fontWeight: FontWeight.w800,
// //                                   fontSize: 18,
// //                                   letterSpacing: -0.4,
// //                                   height: 1)),
// //                           const SizedBox(height: 3),
// //                           Text('সম্পন্ন দিন',
// //                               style: TextStyle(
// //                                   color: Colors.white.withOpacity(0.45),
// //                                   fontSize: 10)),
// //                           if (rank != null) ...[
// //                             const SizedBox(height: 8),
// //                             Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                   horizontal: 8, vertical: 3),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.white.withOpacity(0.08),
// //                                 borderRadius: BorderRadius.circular(8),
// //                                 border: Border.all(
// //                                     color: Colors.white.withOpacity(0.15),
// //                                     width: 0.5),
// //                               ),
// //                               child: Column(children: [
// //                                 Text('র‍্যাংক',
// //                                     style: TextStyle(
// //                                         color: Colors.white.withOpacity(0.45),
// //                                         fontSize: 8)),
// //                                 Text('#$rank',
// //                                     style: const TextStyle(
// //                                         color: _C.gold,
// //                                         fontSize: 14,
// //                                         fontWeight: FontWeight.w900,
// //                                         height: 1.1)),
// //                               ]),
// //                             ),
// //                           ],
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // CIRCULAR PROGRESS WIDGET
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _CircularProgressWidget extends StatelessWidget {
// //   final double percentage;
// //   final double size;
// //   const _CircularProgressWidget({required this.percentage, required this.size});

// //   @override
// //   Widget build(BuildContext context) {
// //     final str = '${percentage.toInt()}%';
// //     final digits = str.length;
// //     final fontSize = digits >= 4
// //         ? 9.0
// //         : digits == 3
// //             ? 10.0
// //             : 12.0;
// //     final innerSize = size * 0.82;

// //     return SizedBox(
// //       width: size,
// //       height: size,
// //       child: Stack(alignment: Alignment.center, children: [
// //         SizedBox.expand(
// //           child: CircularProgressIndicator(
// //             value: percentage / 100,
// //             backgroundColor: Colors.white.withOpacity(0.12),
// //             valueColor: const AlwaysStoppedAnimation(_C.gold),
// //             strokeWidth: size * 0.09,
// //             strokeCap: StrokeCap.round,
// //           ),
// //         ),
// //         Container(
// //           width: innerSize,
// //           height: innerSize,
// //           decoration:
// //               const BoxDecoration(color: _C.darkGreen, shape: BoxShape.circle),
// //           child: Center(
// //             child: FittedBox(
// //               fit: BoxFit.scaleDown,
// //               child: Padding(
// //                 padding: EdgeInsets.all(size * 0.05),
// //                 child: Column(mainAxisSize: MainAxisSize.min, children: [
// //                   Text(str,
// //                       style: TextStyle(
// //                           color: Colors.white,
// //                           fontWeight: FontWeight.w900,
// //                           fontSize: fontSize,
// //                           height: 1),
// //                       textAlign: TextAlign.center),
// //                   SizedBox(height: size * 0.02),
// //                   Text('সম্পন্ন',
// //                       style: TextStyle(
// //                           color: Colors.white.withOpacity(0.45),
// //                           fontSize: size * 0.13),
// //                       textAlign: TextAlign.center),
// //                 ]),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // FEMALE EXEMPT BANNER
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _ExemptBanner extends StatelessWidget {
// //   final int exemptCount;
// //   const _ExemptBanner({required this.exemptCount});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
// //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
// //       decoration: BoxDecoration(
// //         color: _C.purplePale,
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: _C.purple.withOpacity(0.25), width: 0.5),
// //       ),
// //       child: Row(children: [
// //         Container(
// //           width: 30,
// //           height: 30,
// //           decoration: BoxDecoration(
// //               color: _C.purpleLight, borderRadius: BorderRadius.circular(8)),
// //           child:
// //               const Center(child: Text('🌙', style: TextStyle(fontSize: 15))),
// //         ),
// //         const SizedBox(width: 10),
// //         Expanded(
// //           child:
// //               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //             const Text('মাফের দিন চিহ্নিত',
// //                 style: TextStyle(
// //                     color: _C.purple,
// //                     fontSize: 12,
// //                     fontWeight: FontWeight.w700)),
// //             const SizedBox(height: 2),
// //             Text(
// //                 '$exemptCount দিন মাফ — নামাজ ও রোজার ক্যাটাগরি বাদ দেওয়া হয়েছে',
// //                 style: TextStyle(
// //                     color: _C.purple.withOpacity(0.7),
// //                     fontSize: 10,
// //                     fontWeight: FontWeight.w500)),
// //           ]),
// //         ),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // STAT STRIP ROW 1  – streak, weeklyPoints, completionPct
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _StatStripRow1 extends StatelessWidget {
// //   final MonthlyTracker? tracker;
// //   final List<DailyEntry> entries;
// //   const _StatStripRow1({this.tracker, required this.entries});

// //   @override
// //   Widget build(BuildContext context) {
// //     final streak = tracker?.streakDays ?? 0;
// //     final weekly = tracker?.weeklyPoints ?? 0;
// //     final totalAmal = _Derived.totalAmalCount(entries);

// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
// //       child: Row(children: [
// //         Expanded(
// //             child: _StatCard(
// //                 emoji: '🔥',
// //                 emojiBg: _C.amberLight,
// //                 value: '$streak',
// //                 label: 'স্ট্রিক দিন',
// //                 valueColor: _C.amber)),
// //         const SizedBox(width: 8),
// //         Expanded(
// //             child: _StatCard(
// //                 emoji: '📿',
// //                 emojiBg: _C.greenLight,
// //                 value: '$weekly',
// //                 label: 'সাপ্তাহিক pts',
// //                 valueColor: _C.green)),
// //         const SizedBox(width: 8),
// //         Expanded(
// //             child: _StatCard(
// //                 emoji: '⭐',
// //                 emojiBg: _C.goldLight2,
// //                 value: '$totalAmal',
// //                 label: 'মোট আমল',
// //                 valueColor: _C.gold)),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // STAT STRIP ROW 2  – jamat, solo, missed prayers (from real prayerMode data)
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _StatStripRow2 extends StatelessWidget {
// //   final List<DailyEntry> entries;
// //   const _StatStripRow2({required this.entries});

// //   @override
// //   Widget build(BuildContext context) {
// //     final jamat = _Derived.jamatCount(entries);
// //     final sunnah = _Derived.nonPrayerCount(entries);
// //     final missed = _Derived.missedPrayerCount(entries);

// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
// //       child: Row(children: [
// //         Expanded(
// //             child: _StatCard(
// //                 emoji: '🕌',
// //                 emojiBg: _C.purpleLight,
// //                 value: '$jamat',
// //                 label: 'জামাত নামাজ',
// //                 valueColor: _C.purple)),
// //         const SizedBox(width: 8),
// //         Expanded(
// //             child: _StatCard(
// //                 emoji: '📖',
// //                 emojiBg: _C.greenLight,
// //                 value: '$sunnah',
// //                 label: 'অন্যান্য আমল',
// //                 valueColor: _C.green)),
// //         const SizedBox(width: 8),
// //         Expanded(
// //             child: _StatCard(
// //                 emoji: '⚠️',
// //                 emojiBg: _C.redLight,
// //                 value: '$missed',
// //                 label: 'মিস নামাজ',
// //                 valueColor: _C.red)),
// //       ]),
// //     );
// //   }
// // }

// // class _StatCard extends StatelessWidget {
// //   final String emoji, value, label;
// //   final Color emojiBg, valueColor;
// //   const _StatCard({
// //     required this.emoji,
// //     required this.emojiBg,
// //     required this.value,
// //     required this.label,
// //     required this.valueColor,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(11),
// //       decoration: BoxDecoration(
// //           color: _C.cardBg,
// //           borderRadius: BorderRadius.circular(13),
// //           border: Border.all(color: _C.border, width: 0.5)),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         Container(
// //             width: 28,
// //             height: 28,
// //             decoration: BoxDecoration(
// //                 color: emojiBg, borderRadius: BorderRadius.circular(7)),
// //             child: Center(
// //                 child: Text(emoji, style: const TextStyle(fontSize: 13)))),
// //         const SizedBox(height: 7),
// //         Text(value,
// //             style: TextStyle(
// //                 color: valueColor,
// //                 fontWeight: FontWeight.w800,
// //                 fontSize: 19,
// //                 letterSpacing: -0.4,
// //                 height: 1),
// //             maxLines: 1,
// //             overflow: TextOverflow.ellipsis),
// //         const SizedBox(height: 2),
// //         Text(label,
// //             style: const TextStyle(
// //                 color: _C.textSecondary,
// //                 fontSize: 9.5,
// //                 fontWeight: FontWeight.w500)),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // WEEKLY CHART  — from ProgressSummary.currentWeek (WeeklyBarData)
// // // Fields used: day, date, points, fardDone, totalFard, jamatCount, sunnahCount,
// // //              hasData, isExemptDay
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _WeeklyChartSection extends StatelessWidget {
// //   final List<WeeklyBarData> weekData;
// //   final String userGender;
// //   const _WeeklyChartSection({required this.weekData, required this.userGender});

// //   @override
// //   Widget build(BuildContext context) {
// //     if (weekData.isEmpty) return const SizedBox.shrink();

// //     final maxPts = weekData
// //         .map((d) => d.points)
// //         .reduce((a, b) => a > b ? a : b)
// //         .clamp(1, 99999);
// //     final today = DateTime.now();

// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         _SectionHeader(title: 'এই সপ্তাহের ব্রেকডাউন', emoji: '📊'),
// //         const SizedBox(height: 10),
// //         Container(
// //           padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
// //           decoration: BoxDecoration(
// //               color: _C.cardBg,
// //               borderRadius: BorderRadius.circular(16),
// //               border: Border.all(color: _C.border, width: 0.5)),
// //           child: Column(children: [
// //             // Bars
// //             SizedBox(
// //               height: 90,
// //               child: Row(
// //                 crossAxisAlignment: CrossAxisAlignment.end,
// //                 children: weekData.map((d) {
// //                   final barH = d.points > 0
// //                       ? ((d.points / maxPts) * 70).clamp(6.0, 70.0)
// //                       : 0.0;
// //                   final jamatH = d.jamatCount > 0
// //                       ? (barH *
// //                               (d.jamatCount / (d.fardDone > 0 ? d.fardDone : 1))
// //                                   .clamp(0.0, 1.0))
// //                           .clamp(2.0, barH)
// //                       : 0.0;
// //                   final dayDate = DateTime.tryParse(d.date);
// //                   final isToday = dayDate != null &&
// //                       dayDate.year == today.year &&
// //                       dayDate.month == today.month &&
// //                       dayDate.day == today.day;
// //                   final isFemEx = d.isExemptDay && userGender == 'female';

// //                   return Expanded(
// //                     child: Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 2),
// //                       child: Column(
// //                           mainAxisAlignment: MainAxisAlignment.end,
// //                           children: [
// //                             if (d.points > 0)
// //                               Text('${d.points}',
// //                                   style: TextStyle(
// //                                       fontSize: 7.5,
// //                                       color:
// //                                           isToday ? _C.darkGreen : _C.textHint,
// //                                       fontWeight: isToday
// //                                           ? FontWeight.w700
// //                                           : FontWeight.w500),
// //                                   maxLines: 1,
// //                                   overflow: TextOverflow.ellipsis),
// //                             const SizedBox(height: 2),

// //                             // Stacked bar: bottom = jamat (purple), top = rest (green)
// //                             if (isFemEx)
// //                               Container(
// //                                   height: 30,
// //                                   decoration: BoxDecoration(
// //                                     color: _C.purpleLight,
// //                                     borderRadius: BorderRadius.circular(4),
// //                                     border: Border.all(
// //                                         color: _C.purple.withOpacity(0.3),
// //                                         width: 0.5),
// //                                   ),
// //                                   child: const Center(
// //                                       child: Text('🌙',
// //                                           style: TextStyle(fontSize: 9))))
// //                             else if (d.points > 0)
// //                               Column(mainAxisSize: MainAxisSize.min, children: [
// //                                 // green top portion
// //                                 Container(
// //                                   height: barH - jamatH,
// //                                   decoration: BoxDecoration(
// //                                     color: isToday ? _C.darkGreen : _C.midGreen,
// //                                     borderRadius: const BorderRadius.vertical(
// //                                         top: Radius.circular(4)),
// //                                   ),
// //                                 ),
// //                                 if (jamatH > 0)
// //                                   Container(
// //                                     height: jamatH,
// //                                     decoration: BoxDecoration(
// //                                       color: _C.purple.withOpacity(0.7),
// //                                       borderRadius: const BorderRadius.vertical(
// //                                           bottom: Radius.circular(4)),
// //                                     ),
// //                                   ),
// //                               ])
// //                             else
// //                               Container(
// //                                 height: 8,
// //                                 decoration: BoxDecoration(
// //                                   color: _C.pageBg,
// //                                   borderRadius: BorderRadius.circular(4),
// //                                   border:
// //                                       Border.all(color: _C.border, width: 0.5),
// //                                 ),
// //                               ),

// //                             const SizedBox(height: 5),
// //                             Text(d.day,
// //                                 style: TextStyle(
// //                                     fontSize: 8.5,
// //                                     color: isToday
// //                                         ? _C.darkGreen
// //                                         : _C.textSecondary,
// //                                     fontWeight: isToday
// //                                         ? FontWeight.w800
// //                                         : FontWeight.w500),
// //                                 textAlign: TextAlign.center),
// //                           ]),
// //                     ),
// //                   );
// //                 }).toList(),
// //               ),
// //             ),

// //             const SizedBox(height: 10),
// //             const Divider(height: 1, thickness: 0.5, color: _C.border),
// //             const SizedBox(height: 10),

// //             // Stats row from weekData
// //             Row(children: [
// //               _WeekStat(
// //                   label: 'ফরজ সম্পন্ন',
// //                   value:
// //                       '${weekData.fold(0, (s, d) => s + d.fardDone)}/${weekData.fold(0, (s, d) => s + d.totalFard)}',
// //                   color: _C.green),
// //               const SizedBox(width: 10),
// //               _WeekStat(
// //                   label: 'জামাত',
// //                   value: '${weekData.fold(0, (s, d) => s + d.jamatCount)}',
// //                   color: _C.purple),
// //               const SizedBox(width: 10),
// //               _WeekStat(
// //                   label: 'সুন্নত',
// //                   value: '${weekData.fold(0, (s, d) => s + d.sunnahCount)}',
// //                   color: _C.amber),
// //             ]),

// //             const SizedBox(height: 10),

// //             // Legend
// //             Row(children: [
// //               _LegendDot(color: _C.midGreen, label: 'আমল pts'),
// //               const SizedBox(width: 12),
// //               _LegendDot(color: _C.purple.withOpacity(0.7), label: 'জামাত অংশ'),
// //               const SizedBox(width: 12),
// //               _LegendDot(color: _C.purpleLight, label: 'মাফ দিন'),
// //             ]),
// //           ]),
// //         ),
// //       ]),
// //     );
// //   }
// // }

// // class _WeekStat extends StatelessWidget {
// //   final String label, value;
// //   final Color color;
// //   const _WeekStat(
// //       {required this.label, required this.value, required this.color});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Expanded(
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
// //         decoration: BoxDecoration(
// //             color: _C.pageBg, borderRadius: BorderRadius.circular(8)),
// //         child: Column(children: [
// //           Text(value,
// //               style: TextStyle(
// //                   color: color,
// //                   fontSize: 14,
// //                   fontWeight: FontWeight.w800,
// //                   height: 1)),
// //           const SizedBox(height: 2),
// //           Text(label,
// //               style: const TextStyle(color: _C.textHint, fontSize: 8.5),
// //               textAlign: TextAlign.center),
// //         ]),
// //       ),
// //     );
// //   }
// // }

// // class _LegendDot extends StatelessWidget {
// //   final Color color;
// //   final String label;
// //   const _LegendDot({required this.color, required this.label});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(mainAxisSize: MainAxisSize.min, children: [
// //       Container(
// //           width: 9,
// //           height: 9,
// //           decoration: BoxDecoration(
// //               color: color, borderRadius: BorderRadius.circular(2))),
// //       const SizedBox(width: 4),
// //       Text(label, style: const TextStyle(color: _C.textHint, fontSize: 9.5)),
// //     ]);
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // FARD & JAMAT SECTION  — from ProgressSummary.currentWeek
// // // Uses: fardDone, totalFard, jamatCount
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _FardJamatSection extends StatelessWidget {
// //   final List<WeeklyBarData> weekData;
// //   const _FardJamatSection({required this.weekData});

// //   @override
// //   Widget build(BuildContext context) {
// //     if (weekData.isEmpty) return const SizedBox.shrink();

// //     final fardDone = weekData.fold(0, (s, d) => s + d.fardDone);
// //     final totalFard = weekData.fold(0, (s, d) => s + d.totalFard);
// //     final jamatDone = weekData.fold(0, (s, d) => s + d.jamatCount);
// //     final fardPct =
// //         totalFard > 0 ? (fardDone / totalFard).clamp(0.0, 1.0) : 0.0;
// //     final jamatPct =
// //         fardDone > 0 ? (jamatDone / fardDone).clamp(0.0, 1.0) : 0.0;

// //     String fardStatus() {
// //       if (fardPct >= 0.9) return 'চমৎকার';
// //       if (fardPct >= 0.7) return 'ভালো';
// //       if (fardPct >= 0.5) return 'মাঝামাঝি';
// //       return 'উন্নতি দরকার';
// //     }

// //     Color fardColor() {
// //       if (fardPct >= 0.9) return _C.green;
// //       if (fardPct >= 0.7) return _C.amber;
// //       return _C.red;
// //     }

// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         _SectionHeader(title: 'ফরজ ও জামাত বিশ্লেষণ', emoji: '🕌'),
// //         const SizedBox(height: 10),
// //         Row(children: [
// //           Expanded(
// //               child: _FardCard(
// //             title: 'ফরজ আদায়',
// //             value: '$fardDone/$totalFard ওয়াক্ত',
// //             pct: fardPct,
// //             status: fardStatus(),
// //             statusColor: fardColor(),
// //             barColor: fardColor(),
// //           )),
// //           const SizedBox(width: 10),
// //           Expanded(
// //               child: _FardCard(
// //             title: 'জামাতে নামাজ',
// //             value: '$jamatDone/$fardDone ওয়াক্ত',
// //             pct: jamatPct,
// //             status: '${(jamatPct * 100).toInt()}%',
// //             statusColor: _C.purple,
// //             barColor: _C.purple,
// //           )),
// //         ]),
// //       ]),
// //     );
// //   }
// // }

// // class _FardCard extends StatelessWidget {
// //   final String title, value, status;
// //   final double pct;
// //   final Color statusColor, barColor;
// //   const _FardCard({
// //     required this.title,
// //     required this.value,
// //     required this.pct,
// //     required this.status,
// //     required this.statusColor,
// //     required this.barColor,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //           color: _C.cardBg,
// //           borderRadius: BorderRadius.circular(14),
// //           border: Border.all(color: _C.border, width: 0.5)),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
// //           Expanded(
// //               child: Text(title,
// //                   style: const TextStyle(
// //                       color: _C.textPrimary,
// //                       fontSize: 11,
// //                       fontWeight: FontWeight.w700))),
// //           Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
// //               decoration: BoxDecoration(
// //                 color: statusColor.withOpacity(0.1),
// //                 borderRadius: BorderRadius.circular(20),
// //               ),
// //               child: Text(status,
// //                   style: TextStyle(
// //                       color: statusColor,
// //                       fontSize: 9.5,
// //                       fontWeight: FontWeight.w700))),
// //         ]),
// //         const SizedBox(height: 8),
// //         Text('${(pct * 100).toInt()}%',
// //             style: TextStyle(
// //                 color: statusColor,
// //                 fontSize: 22,
// //                 fontWeight: FontWeight.w900,
// //                 height: 1)),
// //         const SizedBox(height: 2),
// //         Text(value, style: const TextStyle(color: _C.textHint, fontSize: 9.5)),
// //         const SizedBox(height: 8),
// //         ClipRRect(
// //             borderRadius: BorderRadius.circular(99),
// //             child: LinearProgressIndicator(
// //               value: pct,
// //               minHeight: 5,
// //               backgroundColor: _C.pageBg,
// //               valueColor: AlwaysStoppedAnimation(barColor),
// //             )),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // PREVIOUS MONTHS CHART  — from ProgressSummary.recentMonths + currentMonth
// // // Uses: MonthlyTracker.year, month, totalPoints, completionPercentage
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _PrevMonthsSection extends StatelessWidget {
// //   final List<MonthlyTracker> months;
// //   const _PrevMonthsSection({required this.months});

// //   String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}K' : '$n';

// //   @override
// //   Widget build(BuildContext context) {
// //     if (months.isEmpty) return const SizedBox.shrink();

// //     final maxPts = months
// //         .map((m) => m.totalPoints)
// //         .reduce((a, b) => a > b ? a : b)
// //         .clamp(1, 999999);
// //     final lastMonth = months.last;

// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         _SectionHeader(title: 'মাসিক তুলনা', emoji: '📈'),
// //         const SizedBox(height: 10),
// //         Container(
// //           padding: const EdgeInsets.all(14),
// //           decoration: BoxDecoration(
// //               color: _C.cardBg,
// //               borderRadius: BorderRadius.circular(16),
// //               border: Border.all(color: _C.border, width: 0.5)),
// //           child: Column(children: [
// //             SizedBox(
// //               height: 90,
// //               child: Row(
// //                 crossAxisAlignment: CrossAxisAlignment.end,
// //                 children: months.map((m) {
// //                   final isActive =
// //                       m.year == lastMonth.year && m.month == lastMonth.month;
// //                   final barH = m.totalPoints > 0
// //                       ? ((m.totalPoints / maxPts) * 70).clamp(6.0, 70.0)
// //                       : 6.0;
// //                   return Expanded(
// //                     child: Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 3),
// //                       child: Column(
// //                           mainAxisAlignment: MainAxisAlignment.end,
// //                           children: [
// //                             Text(_fmt(m.totalPoints),
// //                                 style: TextStyle(
// //                                     fontSize: 7.5,
// //                                     color:
// //                                         isActive ? _C.darkGreen : _C.textHint,
// //                                     fontWeight: isActive
// //                                         ? FontWeight.w800
// //                                         : FontWeight.w500),
// //                                 maxLines: 1,
// //                                 overflow: TextOverflow.ellipsis),
// //                             const SizedBox(height: 2),
// //                             Container(
// //                               height: barH,
// //                               decoration: BoxDecoration(
// //                                 color: isActive
// //                                     ? _C.darkGreen
// //                                     : _C.midGreen.withOpacity(0.5),
// //                                 borderRadius: const BorderRadius.vertical(
// //                                     top: Radius.circular(5)),
// //                               ),
// //                             ),
// //                             const SizedBox(height: 5),
// //                             Text(
// //                                 AppConstants.bengaliMonths[m.month - 1]
// //                                     .substring(0, 3),
// //                                 style: TextStyle(
// //                                     fontSize: 9,
// //                                     color: isActive
// //                                         ? _C.darkGreen
// //                                         : _C.textSecondary,
// //                                     fontWeight: isActive
// //                                         ? FontWeight.w800
// //                                         : FontWeight.w500),
// //                                 textAlign: TextAlign.center),
// //                             // Completion %
// //                             Text('${m.completionPercentage.toInt()}%',
// //                                 style: TextStyle(
// //                                     fontSize: 8,
// //                                     color: isActive ? _C.gold : _C.textHint),
// //                                 textAlign: TextAlign.center),
// //                           ]),
// //                     ),
// //                   );
// //                 }).toList(),
// //               ),
// //             ),

// //             const SizedBox(height: 12),
// //             const Divider(height: 1, thickness: 0.5, color: _C.border),
// //             const SizedBox(height: 10),

// //             // Summary row
// //             Row(children: [
// //               _MonthStatChip(
// //                 label: 'এ মাস',
// //                 value: _fmt(lastMonth.totalPoints),
// //                 color: _C.darkGreen,
// //               ),
// //               const SizedBox(width: 8),
// //               if (months.length >= 2) ...[
// //                 _MonthStatChip(
// //                   label: 'গত মাস',
// //                   value: _fmt(months[months.length - 2].totalPoints),
// //                   color: _C.textSecondary,
// //                 ),
// //                 const SizedBox(width: 8),
// //               ],
// //               _MonthStatChip(
// //                 label: 'সম্পন্ন %',
// //                 value: '${lastMonth.completionPercentage.toInt()}%',
// //                 color: _C.gold,
// //               ),
// //             ]),
// //           ]),
// //         ),
// //       ]),
// //     );
// //   }
// // }

// // class _MonthStatChip extends StatelessWidget {
// //   final String label, value;
// //   final Color color;
// //   const _MonthStatChip(
// //       {required this.label, required this.value, required this.color});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Expanded(
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
// //         decoration: BoxDecoration(
// //             color: _C.pageBg, borderRadius: BorderRadius.circular(8)),
// //         child: Column(children: [
// //           Text(value,
// //               style: TextStyle(
// //                   color: color,
// //                   fontSize: 13,
// //                   fontWeight: FontWeight.w800,
// //                   height: 1)),
// //           const SizedBox(height: 2),
// //           Text(label,
// //               style: const TextStyle(color: _C.textHint, fontSize: 8.5),
// //               textAlign: TextAlign.center),
// //         ]),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // INSIGHTS GRID  — computed from entries + tracker
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _InsightsSection extends StatelessWidget {
// //   final List<DailyEntry> entries;
// //   final MonthlyTracker? tracker;
// //   const _InsightsSection({required this.entries, this.tracker});

// //   @override
// //   Widget build(BuildContext context) {
// //     final activeDays = _Derived.activeDays(entries);
// //     final missDays = _Derived.missDays(entries);
// //     final avgPts = _Derived.avgPointsPerDay(entries);
// //     final bestDay = _Derived.bestDayPoints(entries);
// //     final exemptDays = _Derived.exemptDayCount(entries);
// //     final solo = _Derived.soloPrayerCount(entries);

// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         _SectionHeader(title: 'বিস্তারিত অন্তর্দৃষ্টি', emoji: '🎯'),
// //         const SizedBox(height: 10),
// //         Row(children: [
// //           Expanded(
// //               child: _InsightCard(
// //                   emoji: '📅',
// //                   bg: _C.greenLight,
// //                   value: '$activeDays',
// //                   label: 'সক্রিয় দিন',
// //                   color: _C.green)),
// //           const SizedBox(width: 8),
// //           Expanded(
// //               child: _InsightCard(
// //                   emoji: '😴',
// //                   bg: _C.redLight,
// //                   value: '$missDays',
// //                   label: 'মিস দিন',
// //                   color: _C.red)),
// //         ]),
// //         const SizedBox(height: 8),
// //         Row(children: [
// //           Expanded(
// //               child: _InsightCard(
// //                   emoji: '📊',
// //                   bg: _C.goldLight2,
// //                   value: '$avgPts',
// //                   label: 'গড় pts/দিন',
// //                   color: _C.gold)),
// //           const SizedBox(width: 8),
// //           Expanded(
// //               child: _InsightCard(
// //                   emoji: '🌟',
// //                   bg: _C.amberLight,
// //                   value: '$bestDay',
// //                   label: 'সেরা দিন pts',
// //                   color: _C.amber)),
// //         ]),
// //         const SizedBox(height: 8),
// //         Row(children: [
// //           Expanded(
// //               child: _InsightCard(
// //                   emoji: '🌙',
// //                   bg: _C.purplePale,
// //                   value: '$exemptDays',
// //                   label: 'মাফের দিন',
// //                   color: _C.purple)),
// //           const SizedBox(width: 8),
// //           Expanded(
// //               child: _InsightCard(
// //                   emoji: '🤲',
// //                   bg: _C.greenLight,
// //                   value: '$solo',
// //                   label: 'একাকী নামাজ',
// //                   color: _C.midGreen)),
// //         ]),
// //       ]),
// //     );
// //   }
// // }

// // class _InsightCard extends StatelessWidget {
// //   final String emoji, value, label;
// //   final Color bg, color;
// //   const _InsightCard({
// //     required this.emoji,
// //     required this.bg,
// //     required this.value,
// //     required this.label,
// //     required this.color,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //           color: _C.cardBg,
// //           borderRadius: BorderRadius.circular(13),
// //           border: Border.all(color: _C.border, width: 0.5)),
// //       child: Row(children: [
// //         Container(
// //             width: 34,
// //             height: 34,
// //             decoration: BoxDecoration(
// //                 color: bg, borderRadius: BorderRadius.circular(9)),
// //             child: Center(
// //                 child: Text(emoji, style: const TextStyle(fontSize: 16)))),
// //         const SizedBox(width: 10),
// //         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //           Text(value,
// //               style: TextStyle(
// //                   color: color,
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.w800,
// //                   height: 1)),
// //           const SizedBox(height: 2),
// //           Text(label,
// //               style: const TextStyle(
// //                   color: _C.textSecondary,
// //                   fontSize: 9.5,
// //                   fontWeight: FontWeight.w500)),
// //         ]),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // RANK SECTION  — from MonthlyTracker.rank, totalPoints
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _RankSection extends StatelessWidget {
// //   final MonthlyTracker tracker;
// //   const _RankSection({required this.tracker});

// //   @override
// //   Widget build(BuildContext context) {
// //     final rank = tracker.rank!;
// //     final pct = tracker.completionPercentage.clamp(0.0, 100.0);

// //     // Approximate percentile label
// //     String rankLabel() {
// //       if (rank <= 1) return 'সর্বোচ্চ অবস্থানে আছেন!';
// //       if (rank <= 3) return 'শীর্ষ ৩ জনের মধ্যে!';
// //       if (rank <= 10) return 'শীর্ষ ১০ জনের মধ্যে';
// //       return 'র‍্যাংক #$rank এ আছেন';
// //     }

// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         _SectionHeader(title: 'লিডারবোর্ড অবস্থান', emoji: '🏅'),
// //         const SizedBox(height: 10),
// //         Container(
// //           padding: const EdgeInsets.all(14),
// //           decoration: BoxDecoration(
// //             color: _C.cardBg,
// //             borderRadius: BorderRadius.circular(16),
// //             border: Border.all(color: _C.border, width: 0.5),
// //           ),
// //           child: Row(children: [
// //             Container(
// //               width: 60,
// //               height: 60,
// //               decoration: BoxDecoration(
// //                   color: _C.greenLight,
// //                   borderRadius: BorderRadius.circular(14)),
// //               child: Center(
// //                   child: Text('#$rank',
// //                       style: const TextStyle(
// //                           color: _C.darkGreen,
// //                           fontSize: 22,
// //                           fontWeight: FontWeight.w900))),
// //             ),
// //             const SizedBox(width: 14),
// //             Expanded(
// //                 child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                   Text(rankLabel(),
// //                       style: const TextStyle(
// //                           color: _C.textPrimary,
// //                           fontSize: 13,
// //                           fontWeight: FontWeight.w700)),
// //                   const SizedBox(height: 3),
// //                   Text(
// //                       'সম্পন্ন ${pct.toInt()}% · ${tracker.totalPoints} পয়েন্ট',
// //                       style: const TextStyle(
// //                           color: _C.textSecondary,
// //                           fontSize: 10,
// //                           fontWeight: FontWeight.w500)),
// //                   const SizedBox(height: 8),
// //                   ClipRRect(
// //                       borderRadius: BorderRadius.circular(99),
// //                       child: LinearProgressIndicator(
// //                         value: pct / 100,
// //                         minHeight: 5,
// //                         backgroundColor: _C.pageBg,
// //                         valueColor: const AlwaysStoppedAnimation(_C.darkGreen),
// //                       )),
// //                 ])),
// //             if (tracker.isWinner) ...[
// //               const SizedBox(width: 12),
// //               Container(
// //                 padding: const EdgeInsets.all(8),
// //                 decoration: BoxDecoration(
// //                     color: _C.goldLight2,
// //                     borderRadius: BorderRadius.circular(10),
// //                     border: Border.all(
// //                         color: _C.gold.withOpacity(0.3), width: 0.5)),
// //                 child: const Text('🏆', style: TextStyle(fontSize: 22)),
// //               ),
// //             ],
// //           ]),
// //         ),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // HEATMAP CALENDAR
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _HeatmapCalendar extends StatelessWidget {
// //   final int year, month;
// //   final List<DailyEntry> entries;
// //   const _HeatmapCalendar(
// //       {required this.year, required this.month, required this.entries});

// //   @override
// //   Widget build(BuildContext context) {
// //     final daysInMonth = DateUtils.getDaysInMonth(year, month);
// //     final entryMap = {for (final e in entries) e.day: e};
// //     final maxPts = entries.isEmpty
// //         ? 1
// //         : entries
// //             .map((e) => e.totalPoints)
// //             .reduce((a, b) => a > b ? a : b)
// //             .clamp(1, 9999);
// //     final today = DateTime.now();
// //     final firstDay = DateTime(year, month, 1).weekday % 7;
// //     final totalCells = ((firstDay + daysInMonth) / 7).ceil() * 7;
// //     const weekdays = ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহঃ', 'শুক্র', 'শনি'];

// //     return Container(
// //       padding: const EdgeInsets.all(14),
// //       decoration: BoxDecoration(
// //           color: _C.cardBg,
// //           borderRadius: BorderRadius.circular(16),
// //           border: Border.all(color: _C.border, width: 0.5)),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         // Weekday headers
// //         Row(
// //             children: weekdays
// //                 .map((d) => Expanded(
// //                       child: Center(
// //                           child: Text(d,
// //                               style: const TextStyle(
// //                                   color: _C.textHint,
// //                                   fontSize: 9.5,
// //                                   fontWeight: FontWeight.w500))),
// //                     ))
// //                 .toList()),
// //         const SizedBox(height: 6),

// //         // Day grid
// //         GridView.builder(
// //           shrinkWrap: true,
// //           physics: const NeverScrollableScrollPhysics(),
// //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //               crossAxisCount: 7,
// //               crossAxisSpacing: 3,
// //               mainAxisSpacing: 3,
// //               childAspectRatio: 1.1),
// //           itemCount: totalCells,
// //           itemBuilder: (ctx, index) {
// //             final dayNum = index - firstDay + 1;
// //             if (dayNum < 1 || dayNum > daysInMonth)
// //               return const SizedBox.shrink();

// //             final entry = entryMap[dayNum];
// //             final pts = entry?.totalPoints ?? 0;
// //             final isExempt = entry?.isExemptDay ?? false;
// //             final intensity = pts / maxPts;
// //             final isToday = today.year == year &&
// //                 today.month == month &&
// //                 today.day == dayNum;
// //             final isFuture = DateTime(year, month, dayNum).isAfter(today);

// //             Color cellColor;
// //             Color numColor;

// //             if (isExempt) {
// //               cellColor = _C.purplePale;
// //               numColor = _C.purple;
// //             } else if (isFuture) {
// //               cellColor = _C.pageBg;
// //               numColor = _C.textHint;
// //             } else if (pts == 0) {
// //               cellColor = _C.greenLight.withOpacity(0.5);
// //               numColor = _C.textHint;
// //             } else if (intensity < 0.25) {
// //               cellColor = _C.green.withOpacity(0.18);
// //               numColor = _C.green;
// //             } else if (intensity < 0.5) {
// //               cellColor = _C.green.withOpacity(0.38);
// //               numColor = _C.green;
// //             } else if (intensity < 0.75) {
// //               cellColor = _C.green.withOpacity(0.60);
// //               numColor = Colors.white;
// //             } else {
// //               cellColor = _C.green.withOpacity(0.85);
// //               numColor = Colors.white;
// //             }

// //             return Container(
// //               decoration: BoxDecoration(
// //                 color: cellColor,
// //                 borderRadius: BorderRadius.circular(5),
// //                 border: isToday ? Border.all(color: _C.gold, width: 1.5) : null,
// //               ),
// //               child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Text('$dayNum',
// //                         style: TextStyle(
// //                             fontSize: 10,
// //                             fontWeight: FontWeight.w700,
// //                             color: numColor,
// //                             height: 1)),
// //                     if (isExempt)
// //                       Text('🌙', style: TextStyle(fontSize: 6.5, height: 1))
// //                     else if (pts > 0 && !isFuture)
// //                       Text('$pts',
// //                           style: TextStyle(
// //                               fontSize: 7.5,
// //                               color: numColor.withOpacity(0.7),
// //                               fontWeight: FontWeight.w600,
// //                               height: 1)),
// //                   ]),
// //             ).animate(delay: Duration(milliseconds: dayNum * 8)).scale(
// //                 begin: const Offset(0.7, 0.7),
// //                 duration: 200.ms,
// //                 curve: Curves.easeOut);
// //           },
// //         ),

// //         const SizedBox(height: 10),

// //         // Legend
// //         Row(mainAxisAlignment: MainAxisAlignment.end, children: [
// //           const Text('কম  ',
// //               style: TextStyle(color: _C.textHint, fontSize: 9.5)),
// //           ...List.generate(
// //               5,
// //               (i) => Container(
// //                     width: 12,
// //                     height: 12,
// //                     margin: const EdgeInsets.only(right: 3),
// //                     decoration: BoxDecoration(
// //                       color: i == 0
// //                           ? _C.greenLight
// //                           : _C.green.withOpacity(0.15 + i * 0.18),
// //                       borderRadius: BorderRadius.circular(3),
// //                     ),
// //                   )),
// //           const Text('  বেশি',
// //               style: TextStyle(color: _C.textHint, fontSize: 9.5)),
// //           const SizedBox(width: 10),
// //           Container(
// //               width: 12,
// //               height: 12,
// //               margin: const EdgeInsets.only(right: 3),
// //               decoration: BoxDecoration(
// //                   color: _C.purplePale,
// //                   borderRadius: BorderRadius.circular(3),
// //                   border: Border.all(
// //                       color: _C.purple.withOpacity(0.3), width: 0.5))),
// //           const Text('মাফ',
// //               style: TextStyle(color: _C.textHint, fontSize: 9.5)),
// //         ]),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // DAY ROW  — enhanced with prayerMode, isExemptDay, count
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _DayRow extends StatelessWidget {
// //   final DailyEntry entry;
// //   final bool isLast;
// //   final int delay;
// //   const _DayRow(
// //       {required this.entry, required this.isLast, required this.delay});

// //   @override
// //   Widget build(BuildContext context) {
// //     final completedCount = entry.entries.where((e) => e.completed).length;
// //     final jamatCount = entry.entries
// //         .where((e) => e.prayerMode == PrayerMode.congregation && e.completed)
// //         .length;
// //     final soloCount = entry.entries
// //         .where((e) => e.prayerMode == PrayerMode.solo && e.completed)
// //         .length;
// //     final missedCount =
// //         entry.entries.where((e) => e.prayerMode == PrayerMode.missed).length;
// //     final hasPoints = entry.totalPoints > 0;
// //     final isExempt = entry.isExemptDay;

// //     // Progress bar color
// //     Color barColor = completedCount > 15
// //         ? _C.green
// //         : completedCount > 8
// //             ? _C.amber
// //             : _C.darkGreen;
// //     if (isExempt) barColor = _C.purple;

// //     String getMonthShort(int idx) {
// //       final full = AppConstants.bengaliMonths[idx];
// //       return full.length >= 3 ? full.substring(0, 3) : full;
// //     }

// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
// //       decoration: BoxDecoration(
// //         color: isExempt
// //             ? _C.purplePale.withOpacity(0.4)
// //             : hasPoints
// //                 ? _C.greenLight.withOpacity(0.18)
// //                 : Colors.transparent,
// //         border: isLast
// //             ? null
// //             : const Border(bottom: BorderSide(color: _C.border, width: 0.5)),
// //         borderRadius: isLast
// //             ? const BorderRadius.vertical(bottom: Radius.circular(16))
// //             : null,
// //       ),
// //       child: Row(children: [
// //         // Day number box
// //         Container(
// //           width: 44,
// //           height: 44,
// //           decoration: BoxDecoration(
// //             gradient: isExempt
// //                 ? const LinearGradient(
// //                     colors: [_C.purple, Color(0xFF9B6BE8)],
// //                     begin: Alignment.topLeft,
// //                     end: Alignment.bottomRight)
// //                 : hasPoints
// //                     ? const LinearGradient(
// //                         colors: [_C.darkGreen, _C.midGreen],
// //                         begin: Alignment.topLeft,
// //                         end: Alignment.bottomRight)
// //                     : null,
// //             color: isExempt || hasPoints ? null : _C.pageBg,
// //             borderRadius: BorderRadius.circular(12),
// //           ),
// //           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
// //             Text('${entry.day}',
// //                 style: TextStyle(
// //                     color: isExempt || hasPoints ? Colors.white : _C.textHint,
// //                     fontWeight: FontWeight.w800,
// //                     fontSize: 15,
// //                     height: 1)),
// //             Text(getMonthShort(entry.month - 1),
// //                 style: TextStyle(
// //                     color: isExempt || hasPoints
// //                         ? Colors.white.withOpacity(0.6)
// //                         : _C.textHint,
// //                     fontSize: 8.5)),
// //           ]),
// //         ),

// //         const SizedBox(width: 12),

// //         // Info block
// //         Expanded(
// //             child:
// //                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //           // Top row: count + prayer pills
// //           Row(children: [
// //             Flexible(
// //               child: Text(isExempt ? 'মাফের দিন' : '$completedCount টি আমল',
// //                   style: TextStyle(
// //                       color: isExempt
// //                           ? _C.purple
// //                           : hasPoints
// //                               ? _C.textPrimary
// //                               : _C.textSecondary,
// //                       fontWeight: FontWeight.w700,
// //                       fontSize: 12),
// //                   overflow: TextOverflow.ellipsis),
// //             ),
// //             if (jamatCount > 0) ...[
// //               const SizedBox(width: 5),
// //               _Pill(
// //                   text: '🕌 $jamatCount জামাত',
// //                   bg: _C.purpleLight,
// //                   fg: _C.purple),
// //             ],
// //             if (soloCount > 0 && jamatCount == 0) ...[
// //               const SizedBox(width: 5),
// //               _Pill(
// //                   text: '🤲 $soloCount একাকী', bg: _C.greenLight, fg: _C.green),
// //             ],
// //           ]),

// //           const SizedBox(height: 4),

// //           // Second row: missed prayer warning
// //           if (missedCount > 0) ...[
// //             _Pill(text: '⚠️ $missedCount মিস', bg: _C.redLight, fg: _C.red),
// //             const SizedBox(height: 4),
// //           ],

// //           // Progress bar
// //           ClipRRect(
// //               borderRadius: BorderRadius.circular(99),
// //               child: LinearProgressIndicator(
// //                 value: (completedCount / 20).clamp(0.0, 1.0),
// //                 minHeight: 4,
// //                 backgroundColor: _C.pageBg,
// //                 valueColor:
// //                     AlwaysStoppedAnimation(hasPoints ? barColor : _C.border),
// //               )),
// //         ])),

// //         const SizedBox(width: 10),

// //         // Points
// //         Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
// //           Text('${entry.totalPoints}',
// //               style: TextStyle(
// //                   color: isExempt
// //                       ? _C.purple
// //                       : hasPoints
// //                           ? _C.darkGreen
// //                           : _C.textHint,
// //                   fontWeight: FontWeight.w900,
// //                   fontSize: 18,
// //                   height: 1)),
// //           const Text('pts',
// //               style: TextStyle(
// //                   color: _C.textSecondary,
// //                   fontSize: 9.5,
// //                   fontWeight: FontWeight.w500)),
// //         ]),
// //       ]),
// //     )
// //         .animate(delay: Duration(milliseconds: delay))
// //         .fadeIn(duration: 240.ms)
// //         .slideX(begin: 0.04, curve: Curves.easeOut);
// //   }
// // }

// // class _Pill extends StatelessWidget {
// //   final String text;
// //   final Color bg, fg;
// //   const _Pill({required this.text, required this.bg, required this.fg});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// //       decoration:
// //           BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
// //       child: Text(text,
// //           style:
// //               TextStyle(color: fg, fontSize: 9, fontWeight: FontWeight.w700)),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SECTION HEADER
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _SectionHeader extends StatelessWidget {
// //   final String title, emoji;
// //   const _SectionHeader({required this.title, required this.emoji});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(children: [
// //       Text(emoji, style: const TextStyle(fontSize: 14)),
// //       const SizedBox(width: 7),
// //       Text(title,
// //           style: const TextStyle(
// //               color: _C.textPrimary,
// //               fontWeight: FontWeight.w800,
// //               fontSize: 15,
// //               letterSpacing: -0.2)),
// //     ]);
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // PERIOD PICKER SHEET
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _PeriodPickerSheet extends StatefulWidget {
// //   final int year, month;
// //   final void Function(int, int) onPicked;
// //   const _PeriodPickerSheet(
// //       {required this.year, required this.month, required this.onPicked});

// //   @override
// //   State<_PeriodPickerSheet> createState() => _PeriodPickerSheetState();
// // }

// // class _PeriodPickerSheetState extends State<_PeriodPickerSheet> {
// //   late int _y, _m;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _y = widget.year;
// //     _m = widget.month;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final now = DateTime.now();
// //     return Container(
// //       decoration: const BoxDecoration(
// //           color: _C.cardBg,
// //           borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
// //       padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
// //       child: Column(mainAxisSize: MainAxisSize.min, children: [
// //         Container(
// //             width: 40,
// //             height: 4,
// //             decoration: BoxDecoration(
// //                 color: _C.border, borderRadius: BorderRadius.circular(99))),
// //         const SizedBox(height: 22),
// //         const Text('মাস বেছে নিন',
// //             style: TextStyle(
// //                 color: _C.textPrimary,
// //                 fontSize: 16,
// //                 fontWeight: FontWeight.w700)),
// //         const SizedBox(height: 18),
// //         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
// //           _YearArrow(
// //               icon: Icons.chevron_left_rounded,
// //               onTap: () => setState(() => _y--),
// //               enabled: true),
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
// //             decoration: BoxDecoration(
// //                 color: _C.greenLight, borderRadius: BorderRadius.circular(12)),
// //             child: Text('$_y',
// //                 style: const TextStyle(
// //                     color: _C.darkGreen,
// //                     fontWeight: FontWeight.w800,
// //                     fontSize: 18)),
// //           ),
// //           _YearArrow(
// //               icon: Icons.chevron_right_rounded,
// //               onTap: _y < now.year ? () => setState(() => _y++) : null,
// //               enabled: _y < now.year),
// //         ]),
// //         const SizedBox(height: 16),
// //         GridView.builder(
// //           shrinkWrap: true,
// //           physics: const NeverScrollableScrollPhysics(),
// //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //               crossAxisCount: 4,
// //               crossAxisSpacing: 8,
// //               mainAxisSpacing: 8,
// //               childAspectRatio: 1.75),
// //           itemCount: 12,
// //           itemBuilder: (_, i) {
// //             final isSelected = i + 1 == _m;
// //             final isFuture = _y == now.year && i + 1 > now.month;
// //             return GestureDetector(
// //               onTap: isFuture
// //                   ? null
// //                   : () {
// //                       widget.onPicked(_y, i + 1);
// //                       Navigator.pop(context);
// //                     },
// //               child: AnimatedContainer(
// //                 duration: const Duration(milliseconds: 180),
// //                 decoration: BoxDecoration(
// //                   color: isSelected ? _C.darkGreen : _C.pageBg,
// //                   borderRadius: BorderRadius.circular(10),
// //                   border: Border.all(
// //                       color: isSelected
// //                           ? _C.darkGreen
// //                           : isFuture
// //                               ? _C.border.withOpacity(0.4)
// //                               : _C.border,
// //                       width: 0.5),
// //                 ),
// //                 child: Center(
// //                     child: Text(AppConstants.bengaliMonths[i],
// //                         style: TextStyle(
// //                             color: isSelected
// //                                 ? Colors.white
// //                                 : isFuture
// //                                     ? _C.textHint
// //                                     : _C.textSecondary,
// //                             fontSize: 12,
// //                             fontWeight: isSelected
// //                                 ? FontWeight.w700
// //                                 : FontWeight.w500))),
// //               ),
// //             );
// //           },
// //         ),
// //         const SizedBox(height: 4),
// //       ]),
// //     );
// //   }
// // }

// // class _YearArrow extends StatelessWidget {
// //   final IconData icon;
// //   final VoidCallback? onTap;
// //   final bool enabled;
// //   const _YearArrow(
// //       {required this.icon, required this.onTap, required this.enabled});

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         width: 38,
// //         height: 38,
// //         margin: const EdgeInsets.symmetric(horizontal: 12),
// //         decoration: BoxDecoration(
// //           color: enabled ? _C.greenLight : _C.pageBg,
// //           borderRadius: BorderRadius.circular(10),
// //           border:
// //               Border.all(color: enabled ? _C.borderMid : _C.border, width: 0.5),
// //         ),
// //         child:
// //             Icon(icon, color: enabled ? _C.darkGreen : _C.textHint, size: 20),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // HERO BAND SKELETON
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _HeroBandSkeleton extends StatelessWidget {
// //   const _HeroBandSkeleton();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: _C.darkGreen,
// //       child: Padding(
// //         padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
// //         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //           Container(
// //               width: 130,
// //               height: 11,
// //               decoration: BoxDecoration(
// //                   color: Colors.white.withOpacity(0.1),
// //                   borderRadius: BorderRadius.circular(4))),
// //           const SizedBox(height: 12),
// //           Container(
// //             height: 92,
// //             decoration: BoxDecoration(
// //                 color: Colors.white.withOpacity(0.08),
// //                 borderRadius: BorderRadius.circular(14)),
// //           )
// //               .animate(onPlay: (c) => c.repeat())
// //               .shimmer(duration: 1200.ms, colors: [
// //             Colors.white.withOpacity(0.02),
// //             Colors.white.withOpacity(0.08),
// //             Colors.white.withOpacity(0.02)
// //           ]),
// //         ]),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // STAT STRIP SKELETONS
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _StatStripSkeleton extends StatelessWidget {
// //   const _StatStripSkeleton();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
// //       child: Row(
// //           children: List.generate(
// //               3,
// //               (i) => Expanded(
// //                     child: Container(
// //                       margin: EdgeInsets.only(left: i == 0 ? 0 : 8),
// //                       height: 86,
// //                       decoration: BoxDecoration(
// //                           color: _C.cardBg,
// //                           borderRadius: BorderRadius.circular(13)),
// //                     ).animate(onPlay: (c) => c.repeat()).shimmer(
// //                         duration: 1200.ms,
// //                         delay: Duration(milliseconds: i * 60),
// //                         colors: [
// //                           _C.cardBg,
// //                           const Color(0xFFE8ECE8),
// //                           _C.cardBg
// //                         ]),
// //                   ))),
// //     );
// //   }
// // }

// // class _StatStrip2Skeleton extends StatelessWidget {
// //   const _StatStrip2Skeleton();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
// //       child: Row(
// //           children: List.generate(
// //               3,
// //               (i) => Expanded(
// //                     child: Container(
// //                       margin: EdgeInsets.only(left: i == 0 ? 0 : 8),
// //                       height: 86,
// //                       decoration: BoxDecoration(
// //                           color: _C.cardBg,
// //                           borderRadius: BorderRadius.circular(13)),
// //                     ).animate(onPlay: (c) => c.repeat()).shimmer(
// //                         duration: 1200.ms,
// //                         delay: Duration(milliseconds: i * 60),
// //                         colors: [
// //                           _C.cardBg,
// //                           const Color(0xFFE8ECE8),
// //                           _C.cardBg
// //                         ]),
// //                   ))),
// //     );
// //   }
// // }

// // class _SectionSkeleton extends StatelessWidget {
// //   final double height;
// //   const _SectionSkeleton({required this.height});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
// //       child: Container(
// //         height: height,
// //         decoration: BoxDecoration(
// //             color: _C.cardBg,
// //             borderRadius: BorderRadius.circular(16),
// //             border: Border.all(color: _C.border, width: 0.5)),
// //       ).animate(onPlay: (c) => c.repeat()).shimmer(
// //           duration: 1200.ms,
// //           colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // ENTRIES SKELETON
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _EntriesSkeleton extends StatelessWidget {
// //   const _EntriesSkeleton();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //       const SizedBox(height: 22),
// //       _shimmerBar(width: 130, height: 14),
// //       const SizedBox(height: 12),
// //       _shimmerBox(height: 240),
// //       const SizedBox(height: 22),
// //       _shimmerBar(width: 150, height: 14),
// //       const SizedBox(height: 12),
// //       Container(
// //         decoration: BoxDecoration(
// //             color: _C.cardBg,
// //             borderRadius: BorderRadius.circular(16),
// //             border: Border.all(color: _C.border, width: 0.5)),
// //         child: Column(
// //             children: List.generate(5, (i) {
// //           return Container(
// //             height: 64,
// //             margin: const EdgeInsets.fromLTRB(14, 10, 14, 10),
// //             decoration: BoxDecoration(
// //                 color: _C.pageBg, borderRadius: BorderRadius.circular(10)),
// //           ).animate(onPlay: (c) => c.repeat()).shimmer(
// //               duration: 1200.ms,
// //               delay: Duration(milliseconds: i * 70),
// //               colors: [_C.pageBg, const Color(0xFFE8ECE8), _C.pageBg]);
// //         })),
// //       ),
// //     ]);
// //   }

// //   static Widget _shimmerBar({required double width, required double height}) =>
// //       Container(
// //         width: width,
// //         height: height,
// //         decoration: BoxDecoration(
// //             color: _C.cardBg, borderRadius: BorderRadius.circular(8)),
// //       ).animate(onPlay: (c) => c.repeat()).shimmer(
// //           duration: 1200.ms,
// //           colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg]);

// //   static Widget _shimmerBox({required double height}) => Container(
// //         width: double.infinity,
// //         height: height,
// //         decoration: BoxDecoration(
// //             color: _C.cardBg,
// //             borderRadius: BorderRadius.circular(16),
// //             border: Border.all(color: _C.border, width: 0.5)),
// //       ).animate(onPlay: (c) => c.repeat()).shimmer(
// //           duration: 1200.ms,
// //           colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg]);
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // ERROR + EMPTY CARDS
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _ErrorCard extends StatelessWidget {
// //   final VoidCallback onRetry;
// //   const _ErrorCard({required this.onRetry});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.only(top: 24),
// //       padding: const EdgeInsets.all(24),
// //       decoration: BoxDecoration(
// //           color: _C.cardBg,
// //           borderRadius: BorderRadius.circular(16),
// //           border: Border.all(color: _C.border, width: 0.5)),
// //       child: Column(children: [
// //         const Icon(Icons.error_outline_rounded, color: _C.red, size: 30),
// //         const SizedBox(height: 8),
// //         const Text('ডেটা লোড ব্যর্থ হয়েছে',
// //             style: TextStyle(
// //                 color: _C.textPrimary,
// //                 fontWeight: FontWeight.w700,
// //                 fontSize: 14)),
// //         const SizedBox(height: 12),
// //         GestureDetector(
// //             onTap: onRetry,
// //             child: Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
// //               decoration: BoxDecoration(
// //                   color: _C.greenLight,
// //                   borderRadius: BorderRadius.circular(10)),
// //               child: const Text('পুনরায় চেষ্টা করুন',
// //                   style: TextStyle(
// //                       color: _C.darkGreen,
// //                       fontWeight: FontWeight.w700,
// //                       fontSize: 12)),
// //             )),
// //       ]),
// //     );
// //   }
// // }

// // class _EmptyCard extends StatelessWidget {
// //   final String label;
// //   const _EmptyCard({required this.label});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       height: 110,
// //       decoration: BoxDecoration(
// //           color: _C.cardBg,
// //           borderRadius: BorderRadius.circular(16),
// //           border: Border.all(color: _C.border, width: 0.5)),
// //       child: Center(
// //           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
// //         const Text('📭', style: TextStyle(fontSize: 22)),
// //         const SizedBox(height: 6),
// //         Text(label,
// //             textAlign: TextAlign.center,
// //             style: const TextStyle(
// //                 color: _C.textHint, fontSize: 12, fontWeight: FontWeight.w500)),
// //       ])),
// //     );
// //   }
// // }
// // import 'package:amal_tracker/features/leaderboard/providers/leaderboard_provider.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import '../providers/tracker_provider.dart';
// // import '../models/tracker_model.dart';
// // import '../../../core/constants/app_constants.dart';

// // // ─────────────────────────────────────────────────────────────────────────────
// // // DESIGN TOKENS
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _C {
// //   static const pageBg = Color(0xFFF4F6F1);
// //   static const cardBg = Color(0xFFFFFFFF);
// //   static const darkGreen = Color(0xFF0E3D22);
// //   static const midGreen = Color(0xFF1B7045);
// //   static const gold = Color(0xFFD4A843);
// //   static const goldLight = Color(0xFFFFF3E0);
// //   static const goldLight2 = Color(0xFFFFF8E7);
// //   static const green = Color(0xFF16A34A);
// //   static const greenLight = Color(0xFFE8F5EE);
// //   static const amber = Color(0xFFFF6B35);
// //   static const amberLight = Color(0xFFFFF3E0);
// //   static const purple = Color(0xFF7C3AED);
// //   static const purpleLight = Color(0xFFEDE9FE);
// //   static const purplePale = Color(0xFFF3F0FF);
// //   static const red = Color(0xFFEF4444);
// //   static const redLight = Color(0xFFFEE2E2);
// //   static const textPrimary = Color(0xFF0A1A0F);
// //   static const textSecondary = Color(0xFF6B7C6E);
// //   static const textHint = Color(0xFFABBAAE);
// //   static const border = Color(0xFFE4EAE4);
// //   static const borderMid = Color(0xFFD0DAD2);
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // HELPERS – derived from real model data
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _Derived {
// //   // ── From List<DailyEntry> ─────────────────────────────────────────────────

// //   /// Total completed amal items across all days
// //   static int totalAmalCount(List<DailyEntry> entries) =>
// //       entries.fold(0, (s, d) => s + d.entries.where((e) => e.completed).length);

// //   /// Congregation prayer count (prayerMode == congregation AND completed)
// //   static int jamatCount(List<DailyEntry> entries) => entries.fold(
// //       0,
// //       (s, d) =>
// //           s +
// //           d.entries
// //               .where(
// //                 (e) => e.completed && e.prayerMode == PrayerMode.congregation,
// //               )
// //               .length);

// //   /// Missed prayer count
// //   static int missedPrayerCount(List<DailyEntry> entries) => entries.fold(
// //       0,
// //       (s, d) =>
// //           s +
// //           d.entries
// //               .where(
// //                 (e) => e.prayerMode == PrayerMode.missed,
// //               )
// //               .length);

// //   /// Solo prayer count
// //   static int soloPrayerCount(List<DailyEntry> entries) => entries.fold(
// //       0,
// //       (s, d) =>
// //           s +
// //           d.entries
// //               .where(
// //                 (e) => e.completed && e.prayerMode == PrayerMode.solo,
// //               )
// //               .length);

// //   /// Non-prayer completed amals (sunnah/nafl/dhikr etc.)
// //   static int nonPrayerCount(List<DailyEntry> entries) => entries.fold(
// //       0,
// //       (s, d) =>
// //           s +
// //           d.entries
// //               .where(
// //                 (e) => e.completed && e.prayerMode == null,
// //               )
// //               .length);

// //   /// Days with at least 1 completed amal
// //   static int activeDays(List<DailyEntry> entries) =>
// //       entries.where((d) => d.totalPoints > 0).length;

// //   /// Days with zero points (not future, not exempt)
// //   static int missDays(List<DailyEntry> entries) {
// //     final today = DateTime.now();
// //     return entries.where((d) {
// //       final date = DateTime(d.year, d.month, d.day);
// //       return !date.isAfter(today) && d.totalPoints == 0 && !d.isExemptDay;
// //     }).length;
// //   }

// //   /// Exempt days count
// //   static int exemptDayCount(List<DailyEntry> entries) =>
// //       entries.where((e) => e.isExemptDay).length;

// //   /// Average points per active day
// //   static int avgPointsPerDay(List<DailyEntry> entries) {
// //     final active = entries.where((d) => d.totalPoints > 0).toList();
// //     if (active.isEmpty) return 0;
// //     final total = active.fold(0, (s, d) => s + d.totalPoints);
// //     return (total / active.length).round();
// //   }

// //   /// Best single-day points
// //   static int bestDayPoints(List<DailyEntry> entries) => entries.isEmpty
// //       ? 0
// //       : entries.map((d) => d.totalPoints).reduce((a, b) => a > b ? a : b);

// //   // ── From MonthlyTracker ───────────────────────────────────────────────────

// //   /// Fard completion % derived from fardDone/totalFard in WeeklyBarData
// //   static double fardPct(List<WeeklyBarData> week) {
// //     final total = week.fold(0, (s, d) => s + d.totalFard);
// //     final done = week.fold(0, (s, d) => s + d.fardDone);
// //     if (total == 0) return 0;
// //     return (done / total * 100).clamp(0, 100);
// //   }

// //   static double jamatPct(List<WeeklyBarData> week) {
// //     final done = week.fold(0, (s, d) => s + d.jamatCount);
// //     final fard = week.fold(0, (s, d) => s + d.fardDone);
// //     if (fard == 0) return 0;
// //     return (done / fard * 100).clamp(0, 100);
// //   }

// //   static int weekSunnah(List<WeeklyBarData> week) =>
// //       week.fold(0, (s, d) => s + d.sunnahCount);
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SCREEN
// // // ─────────────────────────────────────────────────────────────────────────────

// // class MonthlyViewScreen extends ConsumerStatefulWidget {
// //   const MonthlyViewScreen({super.key});

// //   @override
// //   ConsumerState<MonthlyViewScreen> createState() => _MonthlyViewScreenState();
// // }

// // class _MonthlyViewScreenState extends ConsumerState<MonthlyViewScreen> {
// //   late int _year;
// //   late int _month;
// //   final _sc = ScrollController();

// //   @override
// //   void initState() {
// //     super.initState();
// //     final now = DateTime.now();
// //     _year = now.year;
// //     _month = now.month;
// //   }

// //   @override
// //   void dispose() {
// //     _sc.dispose();
// //     super.dispose();
// //   }

// //   void _showPeriodPicker() {
// //     showModalBottomSheet(
// //       context: context,
// //       backgroundColor: Colors.transparent,
// //       isScrollControlled: true,
// //       builder: (_) => _PeriodPickerSheet(
// //         year: _year,
// //         month: _month,
// //         onPicked: (y, m) => setState(() {
// //           _year = y;
// //           _month = m;
// //         }),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final params = (year: _year, month: _month);
// //     final entriesAsync = ref.watch(monthlyEntriesProvider(params));
// //     final trackerAsync = ref.watch(monthlyTrackerProvider(params));
// //     final progressAsync = ref.watch(progressSummaryProvider);
// //     final monthName = AppConstants.bengaliMonths[_month - 1];

// //     return AnnotatedRegion<SystemUiOverlayStyle>(
// //       value: SystemUiOverlayStyle.light,
// //       child: Scaffold(
// //         backgroundColor: _C.pageBg,
// //         body: RefreshIndicator(
// //           color: _C.darkGreen,
// //           onRefresh: () async {
// //             ref.invalidate(monthlyEntriesProvider(params));
// //             ref.invalidate(monthlyTrackerProvider(params));
// //             ref.invalidate(progressSummaryProvider);
// //           },
// //           child: CustomScrollView(
// //             controller: _sc,
// //             physics: const AlwaysScrollableScrollPhysics(),
// //             slivers: [
// //               // ── App Bar ───────────────────────────────────────────────────
// //               SliverAppBar(
// //                 pinned: true,
// //                 floating: false,
// //                 expandedHeight: 0,
// //                 toolbarHeight: 56,
// //                 backgroundColor: _C.darkGreen,
// //                 surfaceTintColor: Colors.transparent,
// //                 shadowColor: Colors.transparent,
// //                 automaticallyImplyLeading: false,
// //                 systemOverlayStyle: SystemUiOverlayStyle.light,
// //                 title: Row(
// //                   children: [
// //                     Container(
// //                       width: 30,
// //                       height: 30,
// //                       decoration: BoxDecoration(
// //                         color: Colors.white.withOpacity(0.1),
// //                         borderRadius: BorderRadius.circular(8),
// //                         border: Border.all(
// //                             color: Colors.white.withOpacity(0.15), width: 0.5),
// //                       ),
// //                       child: const Icon(Icons.calendar_month_outlined,
// //                           color: Colors.white, size: 15),
// //                     ),
// //                     const SizedBox(width: 10),
// //                     Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         Text('মাসিক রিপোর্ট',
// //                             style: TextStyle(
// //                                 color: Colors.white.withOpacity(0.55),
// //                                 fontSize: 10,
// //                                 fontWeight: FontWeight.w500)),
// //                         Text('$monthName $_year',
// //                             style: const TextStyle(
// //                                 color: Colors.white,
// //                                 fontSize: 14,
// //                                 fontWeight: FontWeight.w800,
// //                                 letterSpacing: -0.3,
// //                                 height: 1.1)),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //                 actions: [
// //                   GestureDetector(
// //                     onTap: _showPeriodPicker,
// //                     child: Container(
// //                       margin: const EdgeInsets.only(right: 16),
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 11, vertical: 6),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white.withOpacity(0.1),
// //                         borderRadius: BorderRadius.circular(10),
// //                         border: Border.all(
// //                             color: Colors.white.withOpacity(0.18), width: 0.5),
// //                       ),
// //                       child: Row(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Icon(Icons.swap_horiz_rounded,
// //                               size: 13, color: Colors.white.withOpacity(0.7)),
// //                           const SizedBox(width: 5),
// //                           const Text('মাস বদলান',
// //                               style: TextStyle(
// //                                   color: Colors.white,
// //                                   fontWeight: FontWeight.w700,
// //                                   fontSize: 12)),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),

// //               // ── Hero Band ─────────────────────────────────────────────────
// //               SliverToBoxAdapter(
// //                 child: trackerAsync
// //                     .when(
// //                       loading: () => const _HeroBandSkeleton(),
// //                       error: (_, __) => const _HeroBandSkeleton(),
// //                       data: (t) =>
// //                           _HeroBand(year: _year, month: _month, tracker: t),
// //                     )
// //                     .animate()
// //                     .fadeIn(duration: 280.ms),
// //               ),

// //               // ── Female Exempt Banner ──────────────────────────────────────
// //               SliverToBoxAdapter(
// //                 child: progressAsync.whenOrNull(
// //                       data: (p) {
// //                         final isF = p.userGender == 'female';
// //                         final count = entriesAsync.valueOrNull != null
// //                             ? _Derived.exemptDayCount(entriesAsync.valueOrNull!)
// //                             : 0;
// //                         if (!isF || count == 0) return const SizedBox.shrink();
// //                         return _ExemptBanner(exemptCount: count)
// //                             .animate()
// //                             .fadeIn(delay: 50.ms);
// //                       },
// //                     ) ??
// //                     const SizedBox.shrink(),
// //               ),

// //               // ── Stat Strip Row 1 ──────────────────────────────────────────
// //               SliverToBoxAdapter(
// //                 child: trackerAsync
// //                     .when(
// //                       loading: () => const _StatStripSkeleton(),
// //                       error: (_, __) => const _StatStripSkeleton(),
// //                       data: (t) => _StatStripRow1(
// //                         tracker: t,
// //                         entries: entriesAsync.valueOrNull ?? [],
// //                       ),
// //                     )
// //                     .animate()
// //                     .fadeIn(delay: 60.ms, duration: 260.ms),
// //               ),

// //               // ── Stat Strip Row 2 ──────────────────────────────────────────
// //               SliverToBoxAdapter(
// //                 child: entriesAsync
// //                     .when(
// //                       loading: () => const _StatStrip2Skeleton(),
// //                       error: (_, __) => const SizedBox.shrink(),
// //                       data: (entries) => _StatStripRow2(entries: entries),
// //                     )
// //                     .animate()
// //                     .fadeIn(delay: 80.ms, duration: 260.ms),
// //               ),

// //               // ── Weekly Chart ──────────────────────────────────────────────
// //               SliverToBoxAdapter(
// //                 child: progressAsync
// //                     .when(
// //                       loading: () => const _SectionSkeleton(height: 160),
// //                       error: (_, __) => const SizedBox.shrink(),
// //                       data: (p) => _WeeklyChartSection(
// //                         weekData: p.currentWeek,
// //                         userGender: p.userGender,
// //                       ),
// //                     )
// //                     .animate()
// //                     .fadeIn(delay: 100.ms, duration: 280.ms),
// //               ),

// //               // ── Fard & Jamat Cards ────────────────────────────────────────
// //               SliverToBoxAdapter(
// //                 child: progressAsync
// //                     .when(
// //                       loading: () => const _SectionSkeleton(height: 110),
// //                       error: (_, __) => const SizedBox.shrink(),
// //                       data: (p) => _FardJamatSection(weekData: p.currentWeek),
// //                     )
// //                     .animate()
// //                     .fadeIn(delay: 120.ms, duration: 280.ms),
// //               ),

// //               // ── Previous Months Chart ─────────────────────────────────────
// //               SliverToBoxAdapter(
// //                 child: progressAsync
// //                     .when(
// //                       loading: () => const _SectionSkeleton(height: 130),
// //                       error: (_, __) => const SizedBox.shrink(),
// //                       data: (p) {
// //                         final months = [
// //                           ...p.recentMonths,
// //                           if (p.currentMonth != null) p.currentMonth!,
// //                         ];
// //                         if (months.isEmpty) return const SizedBox.shrink();
// //                         return _PrevMonthsSection(months: months);
// //                       },
// //                     )
// //                     .animate()
// //                     .fadeIn(delay: 140.ms, duration: 280.ms),
// //               ),

// //               // ── Insights Grid ─────────────────────────────────────────────
// //               SliverToBoxAdapter(
// //                 child: entriesAsync
// //                     .when(
// //                       loading: () => const _SectionSkeleton(height: 110),
// //                       error: (_, __) => const SizedBox.shrink(),
// //                       data: (entries) => _InsightsSection(
// //                         entries: entries,
// //                         tracker: trackerAsync.valueOrNull,
// //                       ),
// //                     )
// //                     .animate()
// //                     .fadeIn(delay: 160.ms, duration: 280.ms),
// //               ),

// //               // ── Rank Card ─────────────────────────────────────────────────
// //               SliverToBoxAdapter(
// //                 child: trackerAsync.when(
// //                   loading: () => const SizedBox.shrink(),
// //                   error: (_, __) => const SizedBox.shrink(),
// //                   data: (t) {
// //                     if (t == null || t.rank == null)
// //                       return const SizedBox.shrink();
// //                     return _RankSection(tracker: t)
// //                         .animate()
// //                         .fadeIn(delay: 170.ms, duration: 280.ms);
// //                   },
// //                 ),
// //               ),

// //               // ── Calendar + Day List ───────────────────────────────────────
// //               SliverPadding(
// //                 padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
// //                 sliver: entriesAsync.when(
// //                   loading: () => SliverToBoxAdapter(
// //                       child: _EntriesSkeleton().animate().fadeIn(delay: 80.ms)),
// //                   error: (_, __) => SliverToBoxAdapter(
// //                     child: _ErrorCard(
// //                             onRetry: () =>
// //                                 ref.invalidate(monthlyEntriesProvider(params)))
// //                         .animate()
// //                         .fadeIn(),
// //                   ),
// //                   data: (entries) => SliverList(
// //                     delegate: SliverChildListDelegate([
// //                       const SizedBox(height: 15),
// //                       _SectionHeader(title: 'দৈনিক ক্যালেন্ডার', emoji: '📅')
// //                           .animate()
// //                           .fadeIn(delay: 180.ms),
// //                       const SizedBox(height: 10),
// //                       _HeatmapCalendar(
// //                               year: _year, month: _month, entries: entries)
// //                           .animate()
// //                           .fadeIn(delay: 200.ms, duration: 300.ms),
// //                       const SizedBox(height: 22),
// //                       _SectionHeader(
// //                               title: 'দিন অনুযায়ী বিস্তারিত', emoji: '📋')
// //                           .animate()
// //                           .fadeIn(delay: 210.ms),
// //                       const SizedBox(height: 10),
// //                       if (entries.isEmpty)
// //                         _EmptyCard(
// //                                 label:
// //                                     '${AppConstants.bengaliMonths[_month - 1]} মাসে কোনো আমল নেই')
// //                             .animate()
// //                             .fadeIn(delay: 220.ms)
// //                       else
// //                         Container(
// //                           decoration: BoxDecoration(
// //                             color: _C.cardBg,
// //                             borderRadius: BorderRadius.circular(16),
// //                             border: Border.all(color: _C.border, width: 0.5),
// //                           ),
// //                           child: Column(
// //                             children: List.generate(entries.length, (i) {
// //                               return _DayRow(
// //                                 entry: entries[i],
// //                                 isLast: i == entries.length - 1,
// //                                 delay: 220 + i * 25,
// //                               );
// //                             }),
// //                           ),
// //                         ).animate().fadeIn(delay: 220.ms, duration: 280.ms),
// //                     ]),
// //                   ),
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
// // // HERO BAND
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _HeroBand extends StatelessWidget {
// //   final int year, month;
// //   final MonthlyTracker? tracker;
// //   const _HeroBand(
// //       {required this.year, required this.month, required this.tracker});

// //   String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}K' : '$n';

// //   @override
// //   Widget build(BuildContext context) {
// //     final totalPts = tracker?.totalPoints ?? 0;
// //     final pct = (tracker?.completionPercentage ?? 0).clamp(0.0, 100.0);
// //     final daysInMonth = DateUtils.getDaysInMonth(year, month);
// //     final daysCompleted = tracker?.daysCompleted ?? 0;
// //     final isWinner = tracker?.isWinner ?? false;
// //     final winnerCat = tracker?.winnerCategory;
// //     final rank = tracker?.rank;

// //     return Container(
// //       color: _C.darkGreen,
// //       child: Stack(
// //         children: [
// //           // Decorative circles
// //           Positioned(
// //               top: -45,
// //               right: -40,
// //               child: Container(
// //                   width: 140,
// //                   height: 140,
// //                   decoration: const BoxDecoration(
// //                       shape: BoxShape.circle, color: Color(0x0AFFFFFF)))),
// //           Positioned(
// //               bottom: -25,
// //               left: 18,
// //               child: Container(
// //                   width: 88,
// //                   height: 88,
// //                   decoration: const BoxDecoration(
// //                       shape: BoxShape.circle, color: Color(0x07FFFFFF)))),

// //           Padding(
// //             padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text('মাসের আমলের সারসংক্ষেপ',
// //                     style: TextStyle(
// //                         color: Colors.white.withOpacity(0.4),
// //                         fontSize: 11,
// //                         fontWeight: FontWeight.w500)),
// //                 const SizedBox(height: 8),
// //                 Container(
// //                   padding: const EdgeInsets.all(14),
// //                   decoration: BoxDecoration(
// //                     color: const Color(0x17FFFFFF),
// //                     borderRadius: BorderRadius.circular(14),
// //                     border:
// //                         Border.all(color: const Color(0x2EFFFFFF), width: 0.5),
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       // Circular progress
// //                       _CircularProgressWidget(percentage: pct, size: 60),
// //                       const SizedBox(width: 14),

// //                       // Points + winner badge
// //                       Expanded(
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(_fmt(totalPts),
// //                                 style: const TextStyle(
// //                                     color: Colors.white,
// //                                     fontWeight: FontWeight.w900,
// //                                     fontSize: 28,
// //                                     letterSpacing: -0.5,
// //                                     height: 1),
// //                                 maxLines: 1,
// //                                 overflow: TextOverflow.ellipsis),
// //                             const SizedBox(height: 3),
// //                             Text('মোট পয়েন্ট',
// //                                 style: TextStyle(
// //                                     color: Colors.white.withOpacity(0.45),
// //                                     fontSize: 10)),
// //                             if (isWinner) ...[
// //                               const SizedBox(height: 6),
// //                               Container(
// //                                 padding: const EdgeInsets.symmetric(
// //                                     horizontal: 8, vertical: 3),
// //                                 decoration: BoxDecoration(
// //                                     color: _C.gold,
// //                                     borderRadius: BorderRadius.circular(20)),
// //                                 child: Row(
// //                                     mainAxisSize: MainAxisSize.min,
// //                                     children: [
// //                                       const Text('🏆',
// //                                           style: TextStyle(fontSize: 10)),
// //                                       const SizedBox(width: 4),
// //                                       Flexible(
// //                                           child: Text(
// //                                               winnerCat ?? 'মাসিক বিজয়ী',
// //                                               style: const TextStyle(
// //                                                   color: Colors.white,
// //                                                   fontSize: 10,
// //                                                   fontWeight: FontWeight.w700),
// //                                               overflow: TextOverflow.ellipsis,
// //                                               maxLines: 1)),
// //                                     ]),
// //                               ),
// //                             ],
// //                           ],
// //                         ),
// //                       ),

// //                       // Right column: days + rank
// //                       Column(
// //                         crossAxisAlignment: CrossAxisAlignment.end,
// //                         children: [
// //                           Text('$daysCompleted/$daysInMonth',
// //                               style: const TextStyle(
// //                                   color: Colors.white,
// //                                   fontWeight: FontWeight.w800,
// //                                   fontSize: 18,
// //                                   letterSpacing: -0.4,
// //                                   height: 1)),
// //                           const SizedBox(height: 3),
// //                           Text('সম্পন্ন দিন',
// //                               style: TextStyle(
// //                                   color: Colors.white.withOpacity(0.45),
// //                                   fontSize: 10)),
// //                           if (rank != null) ...[
// //                             const SizedBox(height: 8),
// //                             Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                   horizontal: 8, vertical: 3),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.white.withOpacity(0.08),
// //                                 borderRadius: BorderRadius.circular(8),
// //                                 border: Border.all(
// //                                     color: Colors.white.withOpacity(0.15),
// //                                     width: 0.5),
// //                               ),
// //                               child: Column(children: [
// //                                 Text('র‍্যাংক',
// //                                     style: TextStyle(
// //                                         color: Colors.white.withOpacity(0.45),
// //                                         fontSize: 8)),
// //                                 Text('#$rank',
// //                                     style: const TextStyle(
// //                                         color: _C.gold,
// //                                         fontSize: 14,
// //                                         fontWeight: FontWeight.w900,
// //                                         height: 1.1)),
// //                               ]),
// //                             ),
// //                           ],
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // CIRCULAR PROGRESS WIDGET
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _CircularProgressWidget extends StatelessWidget {
// //   final double percentage;
// //   final double size;
// //   const _CircularProgressWidget({required this.percentage, required this.size});

// //   @override
// //   Widget build(BuildContext context) {
// //     final str = '${percentage.toInt()}%';
// //     final digits = str.length;
// //     final fontSize = digits >= 4
// //         ? 9.0
// //         : digits == 3
// //             ? 10.0
// //             : 12.0;
// //     final innerSize = size * 0.82;

// //     return SizedBox(
// //       width: size,
// //       height: size,
// //       child: Stack(alignment: Alignment.center, children: [
// //         SizedBox.expand(
// //           child: CircularProgressIndicator(
// //             value: percentage / 100,
// //             backgroundColor: Colors.white.withOpacity(0.12),
// //             valueColor: const AlwaysStoppedAnimation(_C.gold),
// //             strokeWidth: size * 0.09,
// //             strokeCap: StrokeCap.round,
// //           ),
// //         ),
// //         Container(
// //           width: innerSize,
// //           height: innerSize,
// //           decoration:
// //               const BoxDecoration(color: _C.darkGreen, shape: BoxShape.circle),
// //           child: Center(
// //             child: FittedBox(
// //               fit: BoxFit.scaleDown,
// //               child: Padding(
// //                 padding: EdgeInsets.all(size * 0.05),
// //                 child: Column(mainAxisSize: MainAxisSize.min, children: [
// //                   Text(str,
// //                       style: TextStyle(
// //                           color: Colors.white,
// //                           fontWeight: FontWeight.w900,
// //                           fontSize: fontSize,
// //                           height: 1),
// //                       textAlign: TextAlign.center),
// //                   SizedBox(height: size * 0.02),
// //                   Text('সম্পন্ন',
// //                       style: TextStyle(
// //                           color: Colors.white.withOpacity(0.45),
// //                           fontSize: size * 0.13),
// //                       textAlign: TextAlign.center),
// //                 ]),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // FEMALE EXEMPT BANNER
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _ExemptBanner extends StatelessWidget {
// //   final int exemptCount;
// //   const _ExemptBanner({required this.exemptCount});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
// //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
// //       decoration: BoxDecoration(
// //         color: _C.purplePale,
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: _C.purple.withOpacity(0.25), width: 0.5),
// //       ),
// //       child: Row(children: [
// //         Container(
// //           width: 30,
// //           height: 30,
// //           decoration: BoxDecoration(
// //               color: _C.purpleLight, borderRadius: BorderRadius.circular(8)),
// //           child:
// //               const Center(child: Text('🌙', style: TextStyle(fontSize: 15))),
// //         ),
// //         const SizedBox(width: 10),
// //         Expanded(
// //           child:
// //               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //             const Text('মাফের দিন চিহ্নিত',
// //                 style: TextStyle(
// //                     color: _C.purple,
// //                     fontSize: 12,
// //                     fontWeight: FontWeight.w700)),
// //             const SizedBox(height: 2),
// //             Text(
// //                 '$exemptCount দিন মাফ — নামাজ ও রোজার ক্যাটাগরি বাদ দেওয়া হয়েছে',
// //                 style: TextStyle(
// //                     color: _C.purple.withOpacity(0.7),
// //                     fontSize: 10,
// //                     fontWeight: FontWeight.w500)),
// //           ]),
// //         ),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // STAT STRIP ROW 1  – streak, weeklyPoints, completionPct
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _StatStripRow1 extends StatelessWidget {
// //   final MonthlyTracker? tracker;
// //   final List<DailyEntry> entries;
// //   const _StatStripRow1({this.tracker, required this.entries});

// //   @override
// //   Widget build(BuildContext context) {
// //     final streak = tracker?.streakDays ?? 0;
// //     final weekly = tracker?.weeklyPoints ?? 0;
// //     final totalAmal = _Derived.totalAmalCount(entries);

// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
// //       child: Row(children: [
// //         Expanded(
// //             child: _StatCard(
// //                 emoji: '🔥',
// //                 emojiBg: _C.amberLight,
// //                 value: '$streak',
// //                 label: 'স্ট্রিক দিন',
// //                 valueColor: _C.amber)),
// //         const SizedBox(width: 8),
// //         Expanded(
// //             child: _StatCard(
// //                 emoji: '📿',
// //                 emojiBg: _C.greenLight,
// //                 value: '$weekly',
// //                 label: 'সাপ্তাহিক pts',
// //                 valueColor: _C.green)),
// //         const SizedBox(width: 8),
// //         Expanded(
// //             child: _StatCard(
// //                 emoji: '⭐',
// //                 emojiBg: _C.goldLight2,
// //                 value: '$totalAmal',
// //                 label: 'মোট আমল',
// //                 valueColor: _C.gold)),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // STAT STRIP ROW 2  – jamat, solo, missed prayers (from real prayerMode data)
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _StatStripRow2 extends StatelessWidget {
// //   final List<DailyEntry> entries;
// //   const _StatStripRow2({required this.entries});

// //   @override
// //   Widget build(BuildContext context) {
// //     final jamat = _Derived.jamatCount(entries);
// //     final sunnah = _Derived.nonPrayerCount(entries);
// //     final missed = _Derived.missedPrayerCount(entries);

// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
// //       child: Row(children: [
// //         Expanded(
// //             child: _StatCard(
// //                 emoji: '🕌',
// //                 emojiBg: _C.purpleLight,
// //                 value: '$jamat',
// //                 label: 'জামাত নামাজ',
// //                 valueColor: _C.purple)),
// //         const SizedBox(width: 8),
// //         Expanded(
// //             child: _StatCard(
// //                 emoji: '📖',
// //                 emojiBg: _C.greenLight,
// //                 value: '$sunnah',
// //                 label: 'অন্যান্য আমল',
// //                 valueColor: _C.green)),
// //         const SizedBox(width: 8),
// //         Expanded(
// //             child: _StatCard(
// //                 emoji: '⚠️',
// //                 emojiBg: _C.redLight,
// //                 value: '$missed',
// //                 label: 'মিস নামাজ',
// //                 valueColor: _C.red)),
// //       ]),
// //     );
// //   }
// // }

// // class _StatCard extends StatelessWidget {
// //   final String emoji, value, label;
// //   final Color emojiBg, valueColor;
// //   const _StatCard({
// //     required this.emoji,
// //     required this.emojiBg,
// //     required this.value,
// //     required this.label,
// //     required this.valueColor,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(11),
// //       decoration: BoxDecoration(
// //           color: _C.cardBg,
// //           borderRadius: BorderRadius.circular(13),
// //           border: Border.all(color: _C.border, width: 0.5)),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         Container(
// //             width: 28,
// //             height: 28,
// //             decoration: BoxDecoration(
// //                 color: emojiBg, borderRadius: BorderRadius.circular(7)),
// //             child: Center(
// //                 child: Text(emoji, style: const TextStyle(fontSize: 13)))),
// //         const SizedBox(height: 7),
// //         Text(value,
// //             style: TextStyle(
// //                 color: valueColor,
// //                 fontWeight: FontWeight.w800,
// //                 fontSize: 19,
// //                 letterSpacing: -0.4,
// //                 height: 1),
// //             maxLines: 1,
// //             overflow: TextOverflow.ellipsis),
// //         const SizedBox(height: 2),
// //         Text(label,
// //             style: const TextStyle(
// //                 color: _C.textSecondary,
// //                 fontSize: 9.5,
// //                 fontWeight: FontWeight.w500)),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // WEEKLY CHART  — from ProgressSummary.currentWeek (WeeklyBarData)
// // // Fields used: day, date, points, fardDone, totalFard, jamatCount, sunnahCount,
// // //              hasData, isExemptDay
// // // Fully responsive — uses LayoutBuilder, no fixed pixel heights anywhere.
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _WeeklyChartSection extends StatelessWidget {
// //   final List<WeeklyBarData> weekData;
// //   final String userGender;
// //   const _WeeklyChartSection({required this.weekData, required this.userGender});

// //   @override
// //   Widget build(BuildContext context) {
// //     if (weekData.isEmpty) return const SizedBox.shrink();

// //     final maxPts =
// //         weekData.map((d) => d.points).fold(0, (a, b) => a > b ? a : b);
// //     final safePts = maxPts < 1 ? 1 : maxPts;
// //     final today = DateTime.now();

// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         _SectionHeader(title: 'এই সপ্তাহের অগ্রগতি', emoji: '📊'),
// //         const SizedBox(height: 10),
// //         Container(
// //           padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
// //           decoration: BoxDecoration(
// //             color: _C.cardBg,
// //             borderRadius: BorderRadius.circular(16),
// //             border: Border.all(color: _C.border, width: 0.5),
// //           ),
// //           child: Column(
// //             children: [
// //               // Bar chart
// //               LayoutBuilder(builder: (context, constraints) {
// //                 final chartH = (constraints.maxWidth * 0.40).clamp(80.0, 160.0);
// //                 const labelRowH = 30.0;
// //                 final barAreaH = chartH - labelRowH;

// //                 return SizedBox(
// //                   height: chartH,
// //                   child: Row(
// //                     crossAxisAlignment: CrossAxisAlignment.end,
// //                     children: weekData.map((d) {
// //                       final dayDate = DateTime.tryParse(d.date);
// //                       final isToday = dayDate != null &&
// //                           dayDate.year == today.year &&
// //                           dayDate.month == today.month &&
// //                           dayDate.day == today.day;
// //                       final isExempt = d.isExemptDay && userGender == 'female';

// //                       final fillFrac = d.points > 0
// //                           ? (d.points / safePts).clamp(0.0, 1.0)
// //                           : 0.0;
// //                       final fillH = fillFrac > 0
// //                           ? (fillFrac * barAreaH).clamp(4.0, barAreaH)
// //                           : 0.0;

// //                       return Expanded(
// //                         child: Padding(
// //                           padding: const EdgeInsets.symmetric(horizontal: 2),
// //                           child: Column(
// //                             mainAxisAlignment: MainAxisAlignment.end,
// //                             children: [
// //                               // Points label
// //                               SizedBox(
// //                                 height: 14,
// //                                 child: d.points > 0
// //                                     ? FittedBox(
// //                                         child: Text(
// //                                           '${d.points}',
// //                                           style: TextStyle(
// //                                             fontSize: 8,
// //                                             color: isToday
// //                                                 ? _C.darkGreen
// //                                                 : _C.textHint,
// //                                             fontWeight: isToday
// //                                                 ? FontWeight.w700
// //                                                 : FontWeight.w500,
// //                                           ),
// //                                         ),
// //                                       )
// //                                     : const SizedBox.shrink(),
// //                               ),
// //                               const SizedBox(height: 2),

// //                               // Bar
// //                               if (isExempt)
// //                                 Container(
// //                                   height:
// //                                       (barAreaH * 0.45).clamp(20.0, barAreaH),
// //                                   decoration: BoxDecoration(
// //                                     color: _C.purpleLight,
// //                                     borderRadius: BorderRadius.circular(4),
// //                                   ),
// //                                   child: const Center(
// //                                       child: Text('🌙',
// //                                           style: TextStyle(fontSize: 8))),
// //                                 )
// //                               else if (fillH > 0)
// //                                 Container(
// //                                   height: fillH,
// //                                   width: double.infinity,
// //                                   decoration: BoxDecoration(
// //                                     color: isToday ? _C.darkGreen : _C.midGreen,
// //                                     borderRadius: BorderRadius.circular(4),
// //                                   ),
// //                                 )
// //                               else
// //                                 Container(
// //                                   height: 4,
// //                                   decoration: BoxDecoration(
// //                                     color: _C.pageBg,
// //                                     borderRadius: BorderRadius.circular(3),
// //                                     border: Border.all(
// //                                         color: _C.border, width: 0.5),
// //                                   ),
// //                                 ),

// //                               const SizedBox(height: 4),
// //                               // Day label
// //                               FittedBox(
// //                                 child: Text(
// //                                   d.day,
// //                                   style: TextStyle(
// //                                     fontSize: 9,
// //                                     color: isToday
// //                                         ? _C.darkGreen
// //                                         : _C.textSecondary,
// //                                     fontWeight: isToday
// //                                         ? FontWeight.w800
// //                                         : FontWeight.w500,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       );
// //                     }).toList(),
// //                   ),
// //                 );
// //               }),

// //               const SizedBox(height: 10),
// //               const Divider(height: 1, thickness: 0.5, color: _C.border),
// //               const SizedBox(height: 10),

// //               // Stats - এখন শুধু total points দেখানো যাবে
// //               Row(children: [
// //                 _WeekStat(
// //                   label: 'সাপ্তাহিক পয়েন্ট',
// //                   value: '${weekData.fold(0, (s, d) => s + d.points)}',
// //                   color: _C.green,
// //                 ),
// //                 const SizedBox(width: 8),
// //                 _WeekStat(
// //                   label: 'সক্রিয় দিন',
// //                   value: '${weekData.where((d) => d.hasData).length}',
// //                   color: _C.purple,
// //                 ),
// //                 const SizedBox(width: 8),
// //                 _WeekStat(
// //                   label: 'মাফের দিন',
// //                   value: '${weekData.where((d) => d.isExemptDay).length}',
// //                   color: _C.amber,
// //                 ),
// //               ]),
// //             ],
// //           ),
// //         ),
// //       ]),
// //     );
// //   }
// // }

// // class _WeekStat extends StatelessWidget {
// //   final String label, value;
// //   final Color color;
// //   const _WeekStat(
// //       {required this.label, required this.value, required this.color});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Expanded(
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
// //         decoration: BoxDecoration(
// //             color: _C.pageBg, borderRadius: BorderRadius.circular(8)),
// //         child: Column(children: [
// //           Text(value,
// //               style: TextStyle(
// //                   color: color,
// //                   fontSize: 14,
// //                   fontWeight: FontWeight.w800,
// //                   height: 1)),
// //           const SizedBox(height: 2),
// //           Text(label,
// //               style: const TextStyle(color: _C.textHint, fontSize: 8.5),
// //               textAlign: TextAlign.center),
// //         ]),
// //       ),
// //     );
// //   }
// // }

// // class _LegendDot extends StatelessWidget {
// //   final Color color;
// //   final String label;
// //   const _LegendDot({required this.color, required this.label});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(mainAxisSize: MainAxisSize.min, children: [
// //       Container(
// //           width: 9,
// //           height: 9,
// //           decoration: BoxDecoration(
// //               color: color, borderRadius: BorderRadius.circular(2))),
// //       const SizedBox(width: 4),
// //       Text(label, style: const TextStyle(color: _C.textHint, fontSize: 9.5)),
// //     ]);
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // FARD & JAMAT SECTION  — from ProgressSummary.currentWeek
// // // Uses: fardDone, totalFard, jamatCount
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _FardJamatSection extends StatelessWidget {
// //   final List<WeeklyBarData> weekData;
// //   const _FardJamatSection({required this.weekData});

// //   @override
// //   Widget build(BuildContext context) {
// //     if (weekData.isEmpty) return const SizedBox.shrink();

// //     final fardDone = weekData.fold(0, (s, d) => s + d.fardDone);
// //     final totalFard = weekData.fold(0, (s, d) => s + d.totalFard);
// //     final jamatDone = weekData.fold(0, (s, d) => s + d.jamatCount);
// //     final fardPct =
// //         totalFard > 0 ? (fardDone / totalFard).clamp(0.0, 1.0) : 0.0;
// //     final jamatPct =
// //         fardDone > 0 ? (jamatDone / fardDone).clamp(0.0, 1.0) : 0.0;

// //     String fardStatus() {
// //       if (fardPct >= 0.9) return 'চমৎকার';
// //       if (fardPct >= 0.7) return 'ভালো';
// //       if (fardPct >= 0.5) return 'মাঝামাঝি';
// //       return 'উন্নতি দরকার';
// //     }

// //     Color fardColor() {
// //       if (fardPct >= 0.9) return _C.green;
// //       if (fardPct >= 0.7) return _C.amber;
// //       return _C.red;
// //     }

// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         _SectionHeader(title: 'ফরজ ও জামাত বিশ্লেষণ', emoji: '🕌'),
// //         const SizedBox(height: 10),
// //         Row(children: [
// //           Expanded(
// //               child: _FardCard(
// //             title: 'ফরজ আদায়',
// //             value: '$fardDone/$totalFard ওয়াক্ত',
// //             pct: fardPct,
// //             status: fardStatus(),
// //             statusColor: fardColor(),
// //             barColor: fardColor(),
// //           )),
// //           const SizedBox(width: 10),
// //           Expanded(
// //               child: _FardCard(
// //             title: 'জামাতে নামাজ',
// //             value: '$jamatDone/$fardDone ওয়াক্ত',
// //             pct: jamatPct,
// //             status: '${(jamatPct * 100).toInt()}%',
// //             statusColor: _C.purple,
// //             barColor: _C.purple,
// //           )),
// //         ]),
// //       ]),
// //     );
// //   }
// // }

// // class _FardCard extends StatelessWidget {
// //   final String title, value, status;
// //   final double pct;
// //   final Color statusColor, barColor;
// //   const _FardCard({
// //     required this.title,
// //     required this.value,
// //     required this.pct,
// //     required this.status,
// //     required this.statusColor,
// //     required this.barColor,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //           color: _C.cardBg,
// //           borderRadius: BorderRadius.circular(14),
// //           border: Border.all(color: _C.border, width: 0.5)),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
// //           Expanded(
// //               child: Text(title,
// //                   style: const TextStyle(
// //                       color: _C.textPrimary,
// //                       fontSize: 11,
// //                       fontWeight: FontWeight.w700))),
// //           Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
// //               decoration: BoxDecoration(
// //                 color: statusColor.withOpacity(0.1),
// //                 borderRadius: BorderRadius.circular(20),
// //               ),
// //               child: Text(status,
// //                   style: TextStyle(
// //                       color: statusColor,
// //                       fontSize: 9.5,
// //                       fontWeight: FontWeight.w700))),
// //         ]),
// //         const SizedBox(height: 8),
// //         Text('${(pct * 100).toInt()}%',
// //             style: TextStyle(
// //                 color: statusColor,
// //                 fontSize: 22,
// //                 fontWeight: FontWeight.w900,
// //                 height: 1)),
// //         const SizedBox(height: 2),
// //         Text(value, style: const TextStyle(color: _C.textHint, fontSize: 9.5)),
// //         const SizedBox(height: 8),
// //         ClipRRect(
// //             borderRadius: BorderRadius.circular(99),
// //             child: LinearProgressIndicator(
// //               value: pct,
// //               minHeight: 5,
// //               backgroundColor: _C.pageBg,
// //               valueColor: AlwaysStoppedAnimation(barColor),
// //             )),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // PREVIOUS MONTHS CHART  — from ProgressSummary.recentMonths + currentMonth
// // // Uses: MonthlyTracker.year, month, totalPoints, completionPercentage, fardPoints
// // // Fix: deduplicates by (year,month) key so currentMonth never appears twice.
// // // Fix: summary chips are conditional on actual unique list length.
// // // Fix: fully responsive LayoutBuilder bars — no fixed pixel heights.
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _PrevMonthsSection extends StatelessWidget {
// //   final List<MonthlyTracker> months;
// //   const _PrevMonthsSection({required this.months});

// //   String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}K' : '$n';

// //   /// Deduplicate by (year, month) — keeps last occurrence so currentMonth wins.
// //   List<MonthlyTracker> _dedup(List<MonthlyTracker> raw) {
// //     final seen = <String>{};
// //     final result = <MonthlyTracker>[];
// //     // Iterate reversed so last occurrence (most recent) is kept.
// //     for (final m in raw.reversed) {
// //       final key = '${m.year}-${m.month}';
// //       if (seen.add(key)) result.add(m);
// //     }
// //     return result.reversed.toList();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final unique = _dedup(months);
// //     if (unique.isEmpty) return const SizedBox.shrink();

// //     final maxPts =
// //         unique.map((m) => m.totalPoints).fold(0, (a, b) => a > b ? a : b);
// //     final safePts = maxPts < 1 ? 1 : maxPts;
// //     final current = unique.last;
// //     final prev = unique.length >= 2 ? unique[unique.length - 2] : null;

// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         _SectionHeader(title: 'মাসিক তুলনা', emoji: '📈'),
// //         const SizedBox(height: 10),
// //         Container(
// //           padding: const EdgeInsets.all(14),
// //           decoration: BoxDecoration(
// //             color: _C.cardBg,
// //             borderRadius: BorderRadius.circular(16),
// //             border: Border.all(color: _C.border, width: 0.5),
// //           ),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               // ── Bars — LayoutBuilder driven, no fixed SizedBox ────────────
// //               LayoutBuilder(builder: (context, constraints) {
// //                 final chartH = (constraints.maxWidth * 0.38).clamp(80.0, 150.0);
// //                 // Labels below bar: month name (~12px) + pct (~11px) + gaps (~8px) = ~31
// //                 const labelH = 32.0;
// //                 // Label above bar: pts value (~12px) + gap (2px)
// //                 const topLblH = 14.0;
// //                 final barAreaH =
// //                     (chartH - labelH - topLblH).clamp(20.0, chartH);

// //                 return SizedBox(
// //                   height: chartH,
// //                   child: Row(
// //                     crossAxisAlignment: CrossAxisAlignment.end,
// //                     children: unique.map((m) {
// //                       final isActive =
// //                           m.year == current.year && m.month == current.month;
// //                       final fillFrac = m.totalPoints > 0
// //                           ? (m.totalPoints / safePts).clamp(0.0, 1.0)
// //                           : 0.0;
// //                       // fardPoints share of bar — stacked segment
// //                       final fardFrac = (m.totalPoints > 0 && m.fardPoints > 0)
// //                           ? (m.fardPoints / m.totalPoints).clamp(0.0, 1.0)
// //                           : 0.0;
// //                       final fillH = fillFrac > 0
// //                           ? (fillFrac * barAreaH).clamp(4.0, barAreaH)
// //                           : 4.0;
// //                       final fardH = fardFrac > 0
// //                           ? (fardFrac * fillH).clamp(2.0, fillH)
// //                           : 0.0;
// //                       final restH = fillH - fardH;

// //                       // Month name — safe substring
// //                       final mName = AppConstants.bengaliMonths[m.month - 1];
// //                       final mShort =
// //                           mName.length > 3 ? mName.substring(0, 3) : mName;

// //                       return Expanded(
// //                         child: Padding(
// //                           padding: const EdgeInsets.symmetric(horizontal: 3),
// //                           child: Column(
// //                             mainAxisAlignment: MainAxisAlignment.end,
// //                             mainAxisSize: MainAxisSize.min,
// //                             children: [
// //                               // Points label
// //                               SizedBox(
// //                                 height: topLblH,
// //                                 child: FittedBox(
// //                                   fit: BoxFit.scaleDown,
// //                                   child: Text(
// //                                     _fmt(m.totalPoints),
// //                                     style: TextStyle(
// //                                       fontSize: 8,
// //                                       color:
// //                                           isActive ? _C.darkGreen : _C.textHint,
// //                                       fontWeight: isActive
// //                                           ? FontWeight.w800
// //                                           : FontWeight.w500,
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ),
// //                               const SizedBox(height: 2),

// //                               // Stacked bar: green (rest) on top, gold (fard) on bottom
// //                               ClipRRect(
// //                                 borderRadius: const BorderRadius.vertical(
// //                                     top: Radius.circular(5)),
// //                                 child: Column(
// //                                   mainAxisSize: MainAxisSize.min,
// //                                   children: [
// //                                     if (restH > 0)
// //                                       Container(
// //                                         height: restH,
// //                                         width: double.infinity,
// //                                         color: isActive
// //                                             ? _C.darkGreen
// //                                             : _C.midGreen.withOpacity(0.5),
// //                                       ),
// //                                     if (fardH > 0)
// //                                       Container(
// //                                         height: fardH,
// //                                         width: double.infinity,
// //                                         color: isActive
// //                                             ? _C.gold.withOpacity(0.85)
// //                                             : _C.gold.withOpacity(0.4),
// //                                       ),
// //                                     // Always show at least a stub
// //                                     if (fillFrac == 0)
// //                                       Container(
// //                                         height: 4,
// //                                         width: double.infinity,
// //                                         decoration: BoxDecoration(
// //                                           color: _C.pageBg,
// //                                           border: Border.all(
// //                                               color: _C.border, width: 0.5),
// //                                         ),
// //                                       ),
// //                                   ],
// //                                 ),
// //                               ),

// //                               const SizedBox(height: 4),
// //                               // Month name
// //                               FittedBox(
// //                                 fit: BoxFit.scaleDown,
// //                                 child: Text(
// //                                   mShort,
// //                                   style: TextStyle(
// //                                     fontSize: 9,
// //                                     color: isActive
// //                                         ? _C.darkGreen
// //                                         : _C.textSecondary,
// //                                     fontWeight: isActive
// //                                         ? FontWeight.w800
// //                                         : FontWeight.w500,
// //                                   ),
// //                                   textAlign: TextAlign.center,
// //                                 ),
// //                               ),
// //                               // Completion %
// //                               FittedBox(
// //                                 fit: BoxFit.scaleDown,
// //                                 child: Text(
// //                                   '${m.completionPercentage.toInt()}%',
// //                                   style: TextStyle(
// //                                     fontSize: 8,
// //                                     color: isActive ? _C.gold : _C.textHint,
// //                                   ),
// //                                   textAlign: TextAlign.center,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       );
// //                     }).toList(),
// //                   ),
// //                 );
// //               }),

// //               const SizedBox(height: 12),
// //               const Divider(height: 1, thickness: 0.5, color: _C.border),
// //               const SizedBox(height: 10),

// //               // ── Summary chips — only shown when data actually differs ──────
// //               Row(children: [
// //                 _MonthStatChip(
// //                   label: 'এ মাস',
// //                   value: _fmt(current.totalPoints),
// //                   color: _C.darkGreen,
// //                 ),
// //                 if (prev != null) ...[
// //                   const SizedBox(width: 8),
// //                   _MonthStatChip(
// //                     label: 'গত মাস',
// //                     value: _fmt(prev.totalPoints),
// //                     color: _C.textSecondary,
// //                   ),
// //                 ],
// //                 const SizedBox(width: 8),
// //                 _MonthStatChip(
// //                   label: 'সম্পন্ন %',
// //                   value: '${current.completionPercentage.toInt()}%',
// //                   color: _C.gold,
// //                 ),
// //                 const SizedBox(width: 8),
// //                 _MonthStatChip(
// //                   label: 'ফরজ pts',
// //                   value: _fmt(current.fardPoints),
// //                   color: _C.amber,
// //                 ),
// //               ]),

// //               // Legend for stacked bars
// //               const SizedBox(height: 10),
// //               Wrap(
// //                 spacing: 12,
// //                 runSpacing: 4,
// //                 children: [
// //                   _LegendDot(color: _C.midGreen, label: 'অন্যান্য pts'),
// //                   _LegendDot(color: _C.gold, label: 'ফরজ pts'),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ]),
// //     );
// //   }
// // }

// // class _MonthStatChip extends StatelessWidget {
// //   final String label, value;
// //   final Color color;
// //   const _MonthStatChip(
// //       {required this.label, required this.value, required this.color});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Expanded(
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 6),
// //         decoration: BoxDecoration(
// //             color: _C.pageBg, borderRadius: BorderRadius.circular(8)),
// //         child: Column(children: [
// //           FittedBox(
// //             fit: BoxFit.scaleDown,
// //             child: Text(value,
// //                 style: TextStyle(
// //                     color: color,
// //                     fontSize: 13,
// //                     fontWeight: FontWeight.w800,
// //                     height: 1)),
// //           ),
// //           const SizedBox(height: 2),
// //           FittedBox(
// //             fit: BoxFit.scaleDown,
// //             child: Text(label,
// //                 style: const TextStyle(color: _C.textHint, fontSize: 8.5),
// //                 textAlign: TextAlign.center),
// //           ),
// //         ]),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // INSIGHTS GRID  — computed from entries + tracker
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _InsightsSection extends StatelessWidget {
// //   final List<DailyEntry> entries;
// //   final MonthlyTracker? tracker;
// //   const _InsightsSection({required this.entries, this.tracker});

// //   @override
// //   Widget build(BuildContext context) {
// //     final totalDays = entries.length;
// //     final activeDays = entries.where((e) => e.totalPoints > 0).length;
// //     final exemptDays = entries.where((e) => e.isExemptDay).length;
// //     final totalPoints =
// //         tracker?.totalPoints ?? entries.fold(0, (s, e) => s + e.totalPoints);
// //     final avgPoints = activeDays > 0 ? (totalPoints / activeDays).round() : 0;

// //     final bestDay =
// //         entries.map((e) => e.totalPoints).fold(0, (a, b) => a > b ? a : b);

// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         _SectionHeader(title: 'বিস্তারিত অন্তর্দৃষ্টি', emoji: '🎯'),
// //         const SizedBox(height: 10),
// //         Row(children: [
// //           Expanded(
// //             child: _InsightCard(
// //               emoji: '✅',
// //               bg: _C.greenLight,
// //               value: '$activeDays/$totalDays',
// //               label: 'সক্রিয় দিন',
// //               color: _C.green,
// //             ),
// //           ),
// //           const SizedBox(width: 8),
// //           Expanded(
// //             child: _InsightCard(
// //               emoji: '📊',
// //               bg: _C.goldLight2,
// //               value: '$avgPoints',
// //               label: 'গড় পয়েন্ট/দিন',
// //               color: _C.gold,
// //             ),
// //           ),
// //         ]),
// //         const SizedBox(height: 8),
// //         Row(children: [
// //           Expanded(
// //               child: _InsightCard(
// //                   emoji: '📊',
// //                   bg: _C.goldLight2,
// //                   value: '$avgPts',
// //                   label: 'গড় pts/দিন',
// //                   color: _C.gold)),
// //           const SizedBox(width: 8),
// //           Expanded(
// //               child: _InsightCard(
// //                   emoji: '🌟',
// //                   bg: _C.amberLight,
// //                   value: '$bestDay',
// //                   label: 'সেরা দিন pts',
// //                   color: _C.amber)),
// //         ]),
// //         const SizedBox(height: 8),
// //         Row(children: [
// //           Expanded(
// //               child: _InsightCard(
// //                   emoji: '🌙',
// //                   bg: _C.purplePale,
// //                   value: '$exemptDays',
// //                   label: 'মাফের দিন',
// //                   color: _C.purple)),
// //           const SizedBox(width: 8),
// //           Expanded(
// //               child: _InsightCard(
// //                   emoji: '🤲',
// //                   bg: _C.greenLight,
// //                   value: '$solo',
// //                   label: 'একাকী নামাজ',
// //                   color: _C.midGreen)),
// //         ]),
// //       ]),
// //     );
// //   }
// // }

// // class _InsightCard extends StatelessWidget {
// //   final String emoji, value, label;
// //   final Color bg, color;
// //   const _InsightCard({
// //     required this.emoji,
// //     required this.bg,
// //     required this.value,
// //     required this.label,
// //     required this.color,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //           color: _C.cardBg,
// //           borderRadius: BorderRadius.circular(13),
// //           border: Border.all(color: _C.border, width: 0.5)),
// //       child: Row(children: [
// //         Container(
// //             width: 34,
// //             height: 34,
// //             decoration: BoxDecoration(
// //                 color: bg, borderRadius: BorderRadius.circular(9)),
// //             child: Center(
// //                 child: Text(emoji, style: const TextStyle(fontSize: 16)))),
// //         const SizedBox(width: 10),
// //         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //           Text(value,
// //               style: TextStyle(
// //                   color: color,
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.w800,
// //                   height: 1)),
// //           const SizedBox(height: 2),
// //           Text(label,
// //               style: const TextStyle(
// //                   color: _C.textSecondary,
// //                   fontSize: 9.5,
// //                   fontWeight: FontWeight.w500)),
// //         ]),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // RANK SECTION  — from MonthlyTracker.rank, totalPoints
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _RankSection extends StatelessWidget {
// //   final MonthlyTracker tracker;
// //   const _RankSection({required this.tracker});

// //   @override
// //   Widget build(BuildContext context) {
// //     final rank = tracker.rank!;
// //     final pct = tracker.completionPercentage.clamp(0.0, 100.0);

// //     // Approximate percentile label
// //     String rankLabel() {
// //       if (rank <= 1) return 'সর্বোচ্চ অবস্থানে আছেন!';
// //       if (rank <= 3) return 'শীর্ষ ৩ জনের মধ্যে!';
// //       if (rank <= 10) return 'শীর্ষ ১০ জনের মধ্যে';
// //       return 'র‍্যাংক #$rank এ আছেন';
// //     }

// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         _SectionHeader(title: 'লিডারবোর্ড অবস্থান', emoji: '🏅'),
// //         const SizedBox(height: 10),
// //         Container(
// //           padding: const EdgeInsets.all(14),
// //           decoration: BoxDecoration(
// //             color: _C.cardBg,
// //             borderRadius: BorderRadius.circular(16),
// //             border: Border.all(color: _C.border, width: 0.5),
// //           ),
// //           child: Row(children: [
// //             Container(
// //               width: 60,
// //               height: 60,
// //               decoration: BoxDecoration(
// //                   color: _C.greenLight,
// //                   borderRadius: BorderRadius.circular(14)),
// //               child: Center(
// //                   child: Text('#$rank',
// //                       style: const TextStyle(
// //                           color: _C.darkGreen,
// //                           fontSize: 22,
// //                           fontWeight: FontWeight.w900))),
// //             ),
// //             const SizedBox(width: 14),
// //             Expanded(
// //                 child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                   Text(rankLabel(),
// //                       style: const TextStyle(
// //                           color: _C.textPrimary,
// //                           fontSize: 13,
// //                           fontWeight: FontWeight.w700)),
// //                   const SizedBox(height: 3),
// //                   Text(
// //                       'সম্পন্ন ${pct.toInt()}% · ${tracker.totalPoints} পয়েন্ট',
// //                       style: const TextStyle(
// //                           color: _C.textSecondary,
// //                           fontSize: 10,
// //                           fontWeight: FontWeight.w500)),
// //                   const SizedBox(height: 8),
// //                   ClipRRect(
// //                       borderRadius: BorderRadius.circular(99),
// //                       child: LinearProgressIndicator(
// //                         value: pct / 100,
// //                         minHeight: 5,
// //                         backgroundColor: _C.pageBg,
// //                         valueColor: const AlwaysStoppedAnimation(_C.darkGreen),
// //                       )),
// //                 ])),
// //             if (tracker.isWinner) ...[
// //               const SizedBox(width: 12),
// //               Container(
// //                 padding: const EdgeInsets.all(8),
// //                 decoration: BoxDecoration(
// //                     color: _C.goldLight2,
// //                     borderRadius: BorderRadius.circular(10),
// //                     border: Border.all(
// //                         color: _C.gold.withOpacity(0.3), width: 0.5)),
// //                 child: const Text('🏆', style: TextStyle(fontSize: 22)),
// //               ),
// //             ],
// //           ]),
// //         ),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // HEATMAP CALENDAR
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _HeatmapCalendar extends StatelessWidget {
// //   final int year, month;
// //   final List<DailyEntry> entries;
// //   const _HeatmapCalendar(
// //       {required this.year, required this.month, required this.entries});

// //   @override
// //   Widget build(BuildContext context) {
// //     final daysInMonth = DateUtils.getDaysInMonth(year, month);
// //     final entryMap = {for (final e in entries) e.day: e};
// //     final maxPts = entries.isEmpty
// //         ? 1
// //         : entries
// //             .map((e) => e.totalPoints)
// //             .reduce((a, b) => a > b ? a : b)
// //             .clamp(1, 9999);
// //     final today = DateTime.now();
// //     final firstDay = DateTime(year, month, 1).weekday % 7;
// //     final totalCells = ((firstDay + daysInMonth) / 7).ceil() * 7;
// //     const weekdays = ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহঃ', 'শুক্র', 'শনি'];

// //     return Container(
// //       padding: const EdgeInsets.all(14),
// //       decoration: BoxDecoration(
// //           color: _C.cardBg,
// //           borderRadius: BorderRadius.circular(16),
// //           border: Border.all(color: _C.border, width: 0.5)),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         // Weekday headers
// //         Row(
// //             children: weekdays
// //                 .map((d) => Expanded(
// //                       child: Center(
// //                           child: Text(d,
// //                               style: const TextStyle(
// //                                   color: _C.textHint,
// //                                   fontSize: 9.5,
// //                                   fontWeight: FontWeight.w500))),
// //                     ))
// //                 .toList()),
// //         const SizedBox(height: 6),

// //         // Day grid
// //         GridView.builder(
// //           shrinkWrap: true,
// //           physics: const NeverScrollableScrollPhysics(),
// //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //               crossAxisCount: 7,
// //               crossAxisSpacing: 3,
// //               mainAxisSpacing: 3,
// //               childAspectRatio: 1.1),
// //           itemCount: totalCells,
// //           itemBuilder: (ctx, index) {
// //             final dayNum = index - firstDay + 1;
// //             if (dayNum < 1 || dayNum > daysInMonth)
// //               return const SizedBox.shrink();

// //             final entry = entryMap[dayNum];
// //             final pts = entry?.totalPoints ?? 0;
// //             final isExempt = entry?.isExemptDay ?? false;
// //             final intensity = pts / maxPts;
// //             final isToday = today.year == year &&
// //                 today.month == month &&
// //                 today.day == dayNum;
// //             final isFuture = DateTime(year, month, dayNum).isAfter(today);

// //             Color cellColor;
// //             Color numColor;

// //             if (isExempt) {
// //               cellColor = _C.purplePale;
// //               numColor = _C.purple;
// //             } else if (isFuture) {
// //               cellColor = _C.pageBg;
// //               numColor = _C.textHint;
// //             } else if (pts == 0) {
// //               cellColor = _C.greenLight.withOpacity(0.5);
// //               numColor = _C.textHint;
// //             } else if (intensity < 0.25) {
// //               cellColor = _C.green.withOpacity(0.18);
// //               numColor = _C.green;
// //             } else if (intensity < 0.5) {
// //               cellColor = _C.green.withOpacity(0.38);
// //               numColor = _C.green;
// //             } else if (intensity < 0.75) {
// //               cellColor = _C.green.withOpacity(0.60);
// //               numColor = Colors.white;
// //             } else {
// //               cellColor = _C.green.withOpacity(0.85);
// //               numColor = Colors.white;
// //             }

// //             return Container(
// //               decoration: BoxDecoration(
// //                 color: cellColor,
// //                 borderRadius: BorderRadius.circular(5),
// //                 border: isToday ? Border.all(color: _C.gold, width: 1.5) : null,
// //               ),
// //               child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Text('$dayNum',
// //                         style: TextStyle(
// //                             fontSize: 10,
// //                             fontWeight: FontWeight.w700,
// //                             color: numColor,
// //                             height: 1)),
// //                     if (isExempt)
// //                       Text('🌙', style: TextStyle(fontSize: 6.5, height: 1))
// //                     else if (pts > 0 && !isFuture)
// //                       Text('$pts',
// //                           style: TextStyle(
// //                               fontSize: 7.5,
// //                               color: numColor.withOpacity(0.7),
// //                               fontWeight: FontWeight.w600,
// //                               height: 1)),
// //                   ]),
// //             ).animate(delay: Duration(milliseconds: dayNum * 8)).scale(
// //                 begin: const Offset(0.7, 0.7),
// //                 duration: 200.ms,
// //                 curve: Curves.easeOut);
// //           },
// //         ),

// //         const SizedBox(height: 10),

// //         // Legend
// //         Row(mainAxisAlignment: MainAxisAlignment.end, children: [
// //           const Text('কম  ',
// //               style: TextStyle(color: _C.textHint, fontSize: 9.5)),
// //           ...List.generate(
// //               5,
// //               (i) => Container(
// //                     width: 12,
// //                     height: 12,
// //                     margin: const EdgeInsets.only(right: 3),
// //                     decoration: BoxDecoration(
// //                       color: i == 0
// //                           ? _C.greenLight
// //                           : _C.green.withOpacity(0.15 + i * 0.18),
// //                       borderRadius: BorderRadius.circular(3),
// //                     ),
// //                   )),
// //           const Text('  বেশি',
// //               style: TextStyle(color: _C.textHint, fontSize: 9.5)),
// //           const SizedBox(width: 10),
// //           Container(
// //               width: 12,
// //               height: 12,
// //               margin: const EdgeInsets.only(right: 3),
// //               decoration: BoxDecoration(
// //                   color: _C.purplePale,
// //                   borderRadius: BorderRadius.circular(3),
// //                   border: Border.all(
// //                       color: _C.purple.withOpacity(0.3), width: 0.5))),
// //           const Text('মাফ',
// //               style: TextStyle(color: _C.textHint, fontSize: 9.5)),
// //         ]),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // DAY ROW  — enhanced with prayerMode, isExemptDay, count
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _DayRow extends StatelessWidget {
// //   final DailyEntry entry;
// //   final bool isLast;
// //   final int delay;
// //   const _DayRow(
// //       {required this.entry, required this.isLast, required this.delay});

// //   @override
// //   Widget build(BuildContext context) {
// //     final completedCount = entry.entries.where((e) => e.completed).length;
// //     final jamatCount = entry.entries
// //         .where((e) => e.prayerMode == PrayerMode.congregation && e.completed)
// //         .length;
// //     final soloCount = entry.entries
// //         .where((e) => e.prayerMode == PrayerMode.solo && e.completed)
// //         .length;
// //     final missedCount =
// //         entry.entries.where((e) => e.prayerMode == PrayerMode.missed).length;
// //     final hasPoints = entry.totalPoints > 0;
// //     final isExempt = entry.isExemptDay;

// //     // Progress bar color
// //     Color barColor = completedCount > 15
// //         ? _C.green
// //         : completedCount > 8
// //             ? _C.amber
// //             : _C.darkGreen;
// //     if (isExempt) barColor = _C.purple;

// //     String getMonthShort(int idx) {
// //       final full = AppConstants.bengaliMonths[idx];
// //       return full.length >= 3 ? full.substring(0, 3) : full;
// //     }

// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
// //       decoration: BoxDecoration(
// //         color: isExempt
// //             ? _C.purplePale.withOpacity(0.4)
// //             : hasPoints
// //                 ? _C.greenLight.withOpacity(0.18)
// //                 : Colors.transparent,
// //         border: isLast
// //             ? null
// //             : const Border(bottom: BorderSide(color: _C.border, width: 0.5)),
// //         borderRadius: isLast
// //             ? const BorderRadius.vertical(bottom: Radius.circular(16))
// //             : null,
// //       ),
// //       child: Row(children: [
// //         // Day number box
// //         Container(
// //           width: 44,
// //           height: 44,
// //           decoration: BoxDecoration(
// //             gradient: isExempt
// //                 ? const LinearGradient(
// //                     colors: [_C.purple, Color(0xFF9B6BE8)],
// //                     begin: Alignment.topLeft,
// //                     end: Alignment.bottomRight)
// //                 : hasPoints
// //                     ? const LinearGradient(
// //                         colors: [_C.darkGreen, _C.midGreen],
// //                         begin: Alignment.topLeft,
// //                         end: Alignment.bottomRight)
// //                     : null,
// //             color: isExempt || hasPoints ? null : _C.pageBg,
// //             borderRadius: BorderRadius.circular(12),
// //           ),
// //           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
// //             Text('${entry.day}',
// //                 style: TextStyle(
// //                     color: isExempt || hasPoints ? Colors.white : _C.textHint,
// //                     fontWeight: FontWeight.w800,
// //                     fontSize: 15,
// //                     height: 1)),
// //             Text(getMonthShort(entry.month - 1),
// //                 style: TextStyle(
// //                     color: isExempt || hasPoints
// //                         ? Colors.white.withOpacity(0.6)
// //                         : _C.textHint,
// //                     fontSize: 8.5)),
// //           ]),
// //         ),

// //         const SizedBox(width: 12),

// //         // Info block
// //         Expanded(
// //             child:
// //                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //           // Top row: count + prayer pills
// //           Row(children: [
// //             Flexible(
// //               child: Text(isExempt ? 'মাফের দিন' : '$completedCount টি আমল',
// //                   style: TextStyle(
// //                       color: isExempt
// //                           ? _C.purple
// //                           : hasPoints
// //                               ? _C.textPrimary
// //                               : _C.textSecondary,
// //                       fontWeight: FontWeight.w700,
// //                       fontSize: 12),
// //                   overflow: TextOverflow.ellipsis),
// //             ),
// //             if (jamatCount > 0) ...[
// //               const SizedBox(width: 5),
// //               _Pill(
// //                   text: '🕌 $jamatCount জামাত',
// //                   bg: _C.purpleLight,
// //                   fg: _C.purple),
// //             ],
// //             if (soloCount > 0 && jamatCount == 0) ...[
// //               const SizedBox(width: 5),
// //               _Pill(
// //                   text: '🤲 $soloCount একাকী', bg: _C.greenLight, fg: _C.green),
// //             ],
// //           ]),

// //           const SizedBox(height: 4),

// //           // Second row: missed prayer warning
// //           if (missedCount > 0) ...[
// //             _Pill(text: '⚠️ $missedCount মিস', bg: _C.redLight, fg: _C.red),
// //             const SizedBox(height: 4),
// //           ],

// //           // Progress bar
// //           ClipRRect(
// //               borderRadius: BorderRadius.circular(99),
// //               child: LinearProgressIndicator(
// //                 value: (completedCount / 20).clamp(0.0, 1.0),
// //                 minHeight: 4,
// //                 backgroundColor: _C.pageBg,
// //                 valueColor:
// //                     AlwaysStoppedAnimation(hasPoints ? barColor : _C.border),
// //               )),
// //         ])),

// //         const SizedBox(width: 10),

// //         // Points
// //         Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
// //           Text('${entry.totalPoints}',
// //               style: TextStyle(
// //                   color: isExempt
// //                       ? _C.purple
// //                       : hasPoints
// //                           ? _C.darkGreen
// //                           : _C.textHint,
// //                   fontWeight: FontWeight.w900,
// //                   fontSize: 18,
// //                   height: 1)),
// //           const Text('pts',
// //               style: TextStyle(
// //                   color: _C.textSecondary,
// //                   fontSize: 9.5,
// //                   fontWeight: FontWeight.w500)),
// //         ]),
// //       ]),
// //     )
// //         .animate(delay: Duration(milliseconds: delay))
// //         .fadeIn(duration: 240.ms)
// //         .slideX(begin: 0.04, curve: Curves.easeOut);
// //   }
// // }

// // class _Pill extends StatelessWidget {
// //   final String text;
// //   final Color bg, fg;
// //   const _Pill({required this.text, required this.bg, required this.fg});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// //       decoration:
// //           BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
// //       child: Text(text,
// //           style:
// //               TextStyle(color: fg, fontSize: 9, fontWeight: FontWeight.w700)),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SECTION HEADER
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _SectionHeader extends StatelessWidget {
// //   final String title, emoji;
// //   const _SectionHeader({required this.title, required this.emoji});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(children: [
// //       Text(emoji, style: const TextStyle(fontSize: 14)),
// //       const SizedBox(width: 7),
// //       Text(title,
// //           style: const TextStyle(
// //               color: _C.textPrimary,
// //               fontWeight: FontWeight.w800,
// //               fontSize: 15,
// //               letterSpacing: -0.2)),
// //     ]);
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // PERIOD PICKER SHEET
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _PeriodPickerSheet extends StatefulWidget {
// //   final int year, month;
// //   final void Function(int, int) onPicked;
// //   const _PeriodPickerSheet(
// //       {required this.year, required this.month, required this.onPicked});

// //   @override
// //   State<_PeriodPickerSheet> createState() => _PeriodPickerSheetState();
// // }

// // class _PeriodPickerSheetState extends State<_PeriodPickerSheet> {
// //   late int _y, _m;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _y = widget.year;
// //     _m = widget.month;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final now = DateTime.now();
// //     return Container(
// //       decoration: const BoxDecoration(
// //           color: _C.cardBg,
// //           borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
// //       padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
// //       child: Column(mainAxisSize: MainAxisSize.min, children: [
// //         Container(
// //             width: 40,
// //             height: 4,
// //             decoration: BoxDecoration(
// //                 color: _C.border, borderRadius: BorderRadius.circular(99))),
// //         const SizedBox(height: 22),
// //         const Text('মাস বেছে নিন',
// //             style: TextStyle(
// //                 color: _C.textPrimary,
// //                 fontSize: 16,
// //                 fontWeight: FontWeight.w700)),
// //         const SizedBox(height: 18),
// //         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
// //           _YearArrow(
// //               icon: Icons.chevron_left_rounded,
// //               onTap: () => setState(() => _y--),
// //               enabled: true),
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
// //             decoration: BoxDecoration(
// //                 color: _C.greenLight, borderRadius: BorderRadius.circular(12)),
// //             child: Text('$_y',
// //                 style: const TextStyle(
// //                     color: _C.darkGreen,
// //                     fontWeight: FontWeight.w800,
// //                     fontSize: 18)),
// //           ),
// //           _YearArrow(
// //               icon: Icons.chevron_right_rounded,
// //               onTap: _y < now.year ? () => setState(() => _y++) : null,
// //               enabled: _y < now.year),
// //         ]),
// //         const SizedBox(height: 16),
// //         GridView.builder(
// //           shrinkWrap: true,
// //           physics: const NeverScrollableScrollPhysics(),
// //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //               crossAxisCount: 4,
// //               crossAxisSpacing: 8,
// //               mainAxisSpacing: 8,
// //               childAspectRatio: 1.75),
// //           itemCount: 12,
// //           itemBuilder: (_, i) {
// //             final isSelected = i + 1 == _m;
// //             final isFuture = _y == now.year && i + 1 > now.month;
// //             return GestureDetector(
// //               onTap: isFuture
// //                   ? null
// //                   : () {
// //                       widget.onPicked(_y, i + 1);
// //                       Navigator.pop(context);
// //                     },
// //               child: AnimatedContainer(
// //                 duration: const Duration(milliseconds: 180),
// //                 decoration: BoxDecoration(
// //                   color: isSelected ? _C.darkGreen : _C.pageBg,
// //                   borderRadius: BorderRadius.circular(10),
// //                   border: Border.all(
// //                       color: isSelected
// //                           ? _C.darkGreen
// //                           : isFuture
// //                               ? _C.border.withOpacity(0.4)
// //                               : _C.border,
// //                       width: 0.5),
// //                 ),
// //                 child: Center(
// //                     child: Text(AppConstants.bengaliMonths[i],
// //                         style: TextStyle(
// //                             color: isSelected
// //                                 ? Colors.white
// //                                 : isFuture
// //                                     ? _C.textHint
// //                                     : _C.textSecondary,
// //                             fontSize: 12,
// //                             fontWeight: isSelected
// //                                 ? FontWeight.w700
// //                                 : FontWeight.w500))),
// //               ),
// //             );
// //           },
// //         ),
// //         const SizedBox(height: 4),
// //       ]),
// //     );
// //   }
// // }

// // class _YearArrow extends StatelessWidget {
// //   final IconData icon;
// //   final VoidCallback? onTap;
// //   final bool enabled;
// //   const _YearArrow(
// //       {required this.icon, required this.onTap, required this.enabled});

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         width: 38,
// //         height: 38,
// //         margin: const EdgeInsets.symmetric(horizontal: 12),
// //         decoration: BoxDecoration(
// //           color: enabled ? _C.greenLight : _C.pageBg,
// //           borderRadius: BorderRadius.circular(10),
// //           border:
// //               Border.all(color: enabled ? _C.borderMid : _C.border, width: 0.5),
// //         ),
// //         child:
// //             Icon(icon, color: enabled ? _C.darkGreen : _C.textHint, size: 20),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // HERO BAND SKELETON
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _HeroBandSkeleton extends StatelessWidget {
// //   const _HeroBandSkeleton();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: _C.darkGreen,
// //       child: Padding(
// //         padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
// //         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //           Container(
// //               width: 130,
// //               height: 11,
// //               decoration: BoxDecoration(
// //                   color: Colors.white.withOpacity(0.1),
// //                   borderRadius: BorderRadius.circular(4))),
// //           const SizedBox(height: 12),
// //           Container(
// //             height: 92,
// //             decoration: BoxDecoration(
// //                 color: Colors.white.withOpacity(0.08),
// //                 borderRadius: BorderRadius.circular(14)),
// //           )
// //               .animate(onPlay: (c) => c.repeat())
// //               .shimmer(duration: 1200.ms, colors: [
// //             Colors.white.withOpacity(0.02),
// //             Colors.white.withOpacity(0.08),
// //             Colors.white.withOpacity(0.02)
// //           ]),
// //         ]),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // STAT STRIP SKELETONS
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _StatStripSkeleton extends StatelessWidget {
// //   const _StatStripSkeleton();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
// //       child: Row(
// //           children: List.generate(
// //               3,
// //               (i) => Expanded(
// //                     child: Container(
// //                       margin: EdgeInsets.only(left: i == 0 ? 0 : 8),
// //                       height: 86,
// //                       decoration: BoxDecoration(
// //                           color: _C.cardBg,
// //                           borderRadius: BorderRadius.circular(13)),
// //                     ).animate(onPlay: (c) => c.repeat()).shimmer(
// //                         duration: 1200.ms,
// //                         delay: Duration(milliseconds: i * 60),
// //                         colors: [
// //                           _C.cardBg,
// //                           const Color(0xFFE8ECE8),
// //                           _C.cardBg
// //                         ]),
// //                   ))),
// //     );
// //   }
// // }

// // class _StatStrip2Skeleton extends StatelessWidget {
// //   const _StatStrip2Skeleton();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
// //       child: Row(
// //           children: List.generate(
// //               3,
// //               (i) => Expanded(
// //                     child: Container(
// //                       margin: EdgeInsets.only(left: i == 0 ? 0 : 8),
// //                       height: 86,
// //                       decoration: BoxDecoration(
// //                           color: _C.cardBg,
// //                           borderRadius: BorderRadius.circular(13)),
// //                     ).animate(onPlay: (c) => c.repeat()).shimmer(
// //                         duration: 1200.ms,
// //                         delay: Duration(milliseconds: i * 60),
// //                         colors: [
// //                           _C.cardBg,
// //                           const Color(0xFFE8ECE8),
// //                           _C.cardBg
// //                         ]),
// //                   ))),
// //     );
// //   }
// // }

// // class _SectionSkeleton extends StatelessWidget {
// //   final double height;
// //   const _SectionSkeleton({required this.height});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
// //       child: Container(
// //         height: height,
// //         decoration: BoxDecoration(
// //             color: _C.cardBg,
// //             borderRadius: BorderRadius.circular(16),
// //             border: Border.all(color: _C.border, width: 0.5)),
// //       ).animate(onPlay: (c) => c.repeat()).shimmer(
// //           duration: 1200.ms,
// //           colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // ENTRIES SKELETON
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _EntriesSkeleton extends StatelessWidget {
// //   const _EntriesSkeleton();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //       const SizedBox(height: 22),
// //       _shimmerBar(width: 130, height: 14),
// //       const SizedBox(height: 12),
// //       _shimmerBox(height: 240),
// //       const SizedBox(height: 22),
// //       _shimmerBar(width: 150, height: 14),
// //       const SizedBox(height: 12),
// //       Container(
// //         decoration: BoxDecoration(
// //             color: _C.cardBg,
// //             borderRadius: BorderRadius.circular(16),
// //             border: Border.all(color: _C.border, width: 0.5)),
// //         child: Column(
// //             children: List.generate(5, (i) {
// //           return Container(
// //             height: 64,
// //             margin: const EdgeInsets.fromLTRB(14, 10, 14, 10),
// //             decoration: BoxDecoration(
// //                 color: _C.pageBg, borderRadius: BorderRadius.circular(10)),
// //           ).animate(onPlay: (c) => c.repeat()).shimmer(
// //               duration: 1200.ms,
// //               delay: Duration(milliseconds: i * 70),
// //               colors: [_C.pageBg, const Color(0xFFE8ECE8), _C.pageBg]);
// //         })),
// //       ),
// //     ]);
// //   }

// //   static Widget _shimmerBar({required double width, required double height}) =>
// //       Container(
// //         width: width,
// //         height: height,
// //         decoration: BoxDecoration(
// //             color: _C.cardBg, borderRadius: BorderRadius.circular(8)),
// //       ).animate(onPlay: (c) => c.repeat()).shimmer(
// //           duration: 1200.ms,
// //           colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg]);

// //   static Widget _shimmerBox({required double height}) => Container(
// //         width: double.infinity,
// //         height: height,
// //         decoration: BoxDecoration(
// //             color: _C.cardBg,
// //             borderRadius: BorderRadius.circular(16),
// //             border: Border.all(color: _C.border, width: 0.5)),
// //       ).animate(onPlay: (c) => c.repeat()).shimmer(
// //           duration: 1200.ms,
// //           colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg]);
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // ERROR + EMPTY CARDS
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _ErrorCard extends StatelessWidget {
// //   final VoidCallback onRetry;
// //   const _ErrorCard({required this.onRetry});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.only(top: 24),
// //       padding: const EdgeInsets.all(24),
// //       decoration: BoxDecoration(
// //           color: _C.cardBg,
// //           borderRadius: BorderRadius.circular(16),
// //           border: Border.all(color: _C.border, width: 0.5)),
// //       child: Column(children: [
// //         const Icon(Icons.error_outline_rounded, color: _C.red, size: 30),
// //         const SizedBox(height: 8),
// //         const Text('ডেটা লোড ব্যর্থ হয়েছে',
// //             style: TextStyle(
// //                 color: _C.textPrimary,
// //                 fontWeight: FontWeight.w700,
// //                 fontSize: 14)),
// //         const SizedBox(height: 12),
// //         GestureDetector(
// //             onTap: onRetry,
// //             child: Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
// //               decoration: BoxDecoration(
// //                   color: _C.greenLight,
// //                   borderRadius: BorderRadius.circular(10)),
// //               child: const Text('পুনরায় চেষ্টা করুন',
// //                   style: TextStyle(
// //                       color: _C.darkGreen,
// //                       fontWeight: FontWeight.w700,
// //                       fontSize: 12)),
// //             )),
// //       ]),
// //     );
// //   }
// // }

// // class _EmptyCard extends StatelessWidget {
// //   final String label;
// //   const _EmptyCard({required this.label});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       height: 110,
// //       decoration: BoxDecoration(
// //           color: _C.cardBg,
// //           borderRadius: BorderRadius.circular(16),
// //           border: Border.all(color: _C.border, width: 0.5)),
// //       child: Center(
// //           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
// //         const Text('📭', style: TextStyle(fontSize: 22)),
// //         const SizedBox(height: 6),
// //         Text(label,
// //             textAlign: TextAlign.center,
// //             style: const TextStyle(
// //                 color: _C.textHint, fontSize: 12, fontWeight: FontWeight.w500)),
// //       ])),
// //     );
// //   }
// // }
// import 'package:amal_tracker/features/leaderboard/providers/leaderboard_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/tracker_provider.dart';
// import '../models/tracker_model.dart';
// import '../../../core/constants/app_constants.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // DESIGN TOKENS
// // ─────────────────────────────────────────────────────────────────────────────

// class _C {
//   static const pageBg = Color(0xFFF4F6F1);
//   static const cardBg = Color(0xFFFFFFFF);
//   static const darkGreen = Color(0xFF0E3D22);
//   static const midGreen = Color(0xFF1B7045);
//   static const gold = Color(0xFFD4A843);
//   static const goldLight = Color(0xFFFFF3E0);
//   static const goldLight2 = Color(0xFFFFF8E7);
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const amber = Color(0xFFFF6B35);
//   static const amberLight = Color(0xFFFFF3E0);
//   static const purple = Color(0xFF7C3AED);
//   static const purpleLight = Color(0xFFEDE9FE);
//   static const purplePale = Color(0xFFF3F0FF);
//   static const red = Color(0xFFEF4444);
//   static const redLight = Color(0xFFFEE2E2);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
//   static const border = Color(0xFFE4EAE4);
//   static const borderMid = Color(0xFFD0DAD2);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// class MonthlyViewScreen extends ConsumerStatefulWidget {
//   const MonthlyViewScreen({super.key});

//   @override
//   ConsumerState<MonthlyViewScreen> createState() => _MonthlyViewScreenState();
// }

// class _MonthlyViewScreenState extends ConsumerState<MonthlyViewScreen> {
//   late int _year;
//   late int _month;
//   final _sc = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     final now = DateTime.now();
//     _year = now.year;
//     _month = now.month;
//   }

//   @override
//   void dispose() {
//     _sc.dispose();
//     super.dispose();
//   }

//   void _showPeriodPicker() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) => _PeriodPickerSheet(
//         year: _year,
//         month: _month,
//         onPicked: (y, m) => setState(() {
//           _year = y;
//           _month = m;
//         }),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final params = (year: _year, month: _month);
//     final entriesAsync = ref.watch(monthlyEntriesProvider(params));
//     final trackerAsync = ref.watch(monthlyTrackerProvider(params));
//     final progressAsync = ref.watch(progressSummaryProvider);
//     final monthName = AppConstants.bengaliMonths[_month - 1];

//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: _C.pageBg,
//         body: RefreshIndicator(
//           color: _C.darkGreen,
//           onRefresh: () async {
//             ref.invalidate(monthlyEntriesProvider(params));
//             ref.invalidate(monthlyTrackerProvider(params));
//             ref.invalidate(progressSummaryProvider);
//           },
//           child: CustomScrollView(
//             controller: _sc,
//             physics: const AlwaysScrollableScrollPhysics(),
//             slivers: [
//               // ── App Bar ───────────────────────────────────────────────────
//               SliverAppBar(
//                 pinned: true,
//                 floating: false,
//                 expandedHeight: 0,
//                 toolbarHeight: 56,
//                 backgroundColor: _C.darkGreen,
//                 surfaceTintColor: Colors.transparent,
//                 shadowColor: Colors.transparent,
//                 automaticallyImplyLeading: false,
//                 systemOverlayStyle: SystemUiOverlayStyle.light,
//                 title: Row(
//                   children: [
//                     Container(
//                       width: 30,
//                       height: 30,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                             color: Colors.white.withOpacity(0.15), width: 0.5),
//                       ),
//                       child: const Icon(Icons.calendar_month_outlined,
//                           color: Colors.white, size: 15),
//                     ),
//                     const SizedBox(width: 10),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text('মাসিক রিপোর্ট',
//                             style: TextStyle(
//                                 color: Colors.white.withOpacity(0.55),
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w500)),
//                         Text('$monthName $_year',
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w800,
//                                 letterSpacing: -0.3,
//                                 height: 1.1)),
//                       ],
//                     ),
//                   ],
//                 ),
//                 actions: [
//                   GestureDetector(
//                     onTap: _showPeriodPicker,
//                     child: Container(
//                       margin: const EdgeInsets.only(right: 16),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 11, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                             color: Colors.white.withOpacity(0.18), width: 0.5),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.swap_horiz_rounded,
//                               size: 13, color: Colors.white.withOpacity(0.7)),
//                           const SizedBox(width: 5),
//                           const Text('মাস বদলান',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 12)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               // ── Hero Band ─────────────────────────────────────────────────
//               SliverToBoxAdapter(
//                 child: trackerAsync
//                     .when(
//                       loading: () => const _HeroBandSkeleton(),
//                       error: (_, __) => const _HeroBandSkeleton(),
//                       data: (t) =>
//                           _HeroBand(year: _year, month: _month, tracker: t),
//                     )
//                     .animate()
//                     .fadeIn(duration: 280.ms),
//               ),

//               // ── Female Exempt Banner (শুধু female দেখাবে) ──────────────────
//               SliverToBoxAdapter(
//                 child: progressAsync.when(
//                   data: (p) {
//                     // শুধু female user এবং exempt days থাকলে দেখাবে
//                     if (p.userGender != 'female')
//                       return const SizedBox.shrink();

//                     final exemptCount =
//                         trackerAsync.valueOrNull?.exemptDays ?? 0;
//                     if (exemptCount == 0) return const SizedBox.shrink();

//                     return _ExemptBanner(exemptCount: exemptCount)
//                         .animate()
//                         .fadeIn(delay: 50.ms);
//                   },
//                   loading: () => const SizedBox.shrink(),
//                   error: (_, __) => const SizedBox.shrink(),
//                 ),
//               ),

//               // ── Stat Strip Row 1 ──────────────────────────────────────────
//               SliverToBoxAdapter(
//                 child: trackerAsync
//                     .when(
//                       loading: () => const _StatStripSkeleton(),
//                       error: (_, __) => const _StatStripSkeleton(),
//                       data: (t) => _StatStripRow1(tracker: t),
//                     )
//                     .animate()
//                     .fadeIn(delay: 60.ms, duration: 260.ms),
//               ),

//               // ── Stat Strip Row 2 ──────────────────────────────────────────
//               SliverToBoxAdapter(
//                 child: entriesAsync
//                     .when(
//                       loading: () => const _StatStrip2Skeleton(),
//                       error: (_, __) => const SizedBox.shrink(),
//                       data: (entries) => _StatStripRow2(entries: entries),
//                     )
//                     .animate()
//                     .fadeIn(delay: 80.ms, duration: 260.ms),
//               ),

//               // ── Weekly Chart (সরলীকৃত - শুধু points দেখাবে) ─────────────────
//               SliverToBoxAdapter(
//                 child: progressAsync
//                     .when(
//                       loading: () => const _SectionSkeleton(height: 160),
//                       error: (_, __) => const SizedBox.shrink(),
//                       data: (p) => _WeeklyChartSection(
//                         weekData: p.currentWeek,
//                         userGender: p.userGender,
//                       ),
//                     )
//                     .animate()
//                     .fadeIn(delay: 100.ms, duration: 280.ms),
//               ),

//               // ── Insights Grid (সরলীকৃত) ────────────────────────────────────
//               // SliverToBoxAdapter(
//               //   child: FutureBuilder(
//               //     future: Future.wait([
//               //       entriesAsync.future,
//               //       trackerAsync.future,
//               //     ]),
//               //     builder: (context, snapshot) {
//               //       if (!snapshot.hasData) {
//               //         return const _SectionSkeleton(height: 110);
//               //       }
//               //       final entries = snapshot.data![0] as List<DailyEntry>;
//               //       final tracker = snapshot.data![1] as MonthlyTracker?;
//               //       return _InsightsSection(entries: entries, tracker: tracker)
//               //           .animate()
//               //           .fadeIn(delay: 120.ms, duration: 280.ms);
//               //     },
//               //   ),
//               // ),
//               SliverToBoxAdapter(
//                 child: entriesAsync.when(
//                   loading: () => const _SectionSkeleton(height: 110),
//                   error: (_, __) => const SizedBox.shrink(),
//                   data: (entries) {
//                     final tracker = trackerAsync.valueOrNull;
//                     return _InsightsSection(entries: entries, tracker: tracker)
//                         .animate()
//                         .fadeIn(delay: 120.ms, duration: 280.ms);
//                   },
//                 ),
//               ),

//               // ── Previous Months Chart ─────────────────────────────────────
//               SliverToBoxAdapter(
//                 child: progressAsync
//                     .when(
//                       loading: () => const _SectionSkeleton(height: 130),
//                       error: (_, __) => const SizedBox.shrink(),
//                       data: (p) {
//                         final months = [
//                           ...p.recentMonths,
//                           if (p.currentMonth != null) p.currentMonth!,
//                         ];
//                         if (months.isEmpty) return const SizedBox.shrink();
//                         return _PrevMonthsSection(months: months);
//                       },
//                     )
//                     .animate()
//                     .fadeIn(delay: 140.ms, duration: 280.ms),
//               ),

//               // ── Rank Card ─────────────────────────────────────────────────
//               SliverToBoxAdapter(
//                 child: trackerAsync.when(
//                   loading: () => const SizedBox.shrink(),
//                   error: (_, __) => const SizedBox.shrink(),
//                   data: (t) {
//                     if (t == null || t.rank == null)
//                       return const SizedBox.shrink();
//                     return _RankSection(tracker: t)
//                         .animate()
//                         .fadeIn(delay: 160.ms, duration: 280.ms);
//                   },
//                 ),
//               ),

//               // ── Calendar + Day List ───────────────────────────────────────
//               SliverPadding(
//                 padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
//                 sliver: entriesAsync.when(
//                   loading: () => SliverToBoxAdapter(
//                       child: _EntriesSkeleton().animate().fadeIn(delay: 80.ms)),
//                   error: (_, __) => SliverToBoxAdapter(
//                     child: _ErrorCard(
//                             onRetry: () =>
//                                 ref.invalidate(monthlyEntriesProvider(params)))
//                         .animate()
//                         .fadeIn(),
//                   ),
//                   data: (entries) => SliverList(
//                     delegate: SliverChildListDelegate([
//                       const SizedBox(height: 15),
//                       _SectionHeader(title: 'দৈনিক ক্যালেন্ডার', emoji: '📅')
//                           .animate()
//                           .fadeIn(delay: 180.ms),
//                       const SizedBox(height: 10),
//                       _HeatmapCalendar(
//                               year: _year, month: _month, entries: entries)
//                           .animate()
//                           .fadeIn(delay: 200.ms, duration: 300.ms),
//                       const SizedBox(height: 22),
//                       _SectionHeader(
//                               title: 'দিন অনুযায়ী বিস্তারিত', emoji: '📋')
//                           .animate()
//                           .fadeIn(delay: 210.ms),
//                       const SizedBox(height: 10),
//                       if (entries.isEmpty)
//                         _EmptyCard(
//                                 label:
//                                     '${AppConstants.bengaliMonths[_month - 1]} মাসে কোনো আমল নেই')
//                             .animate()
//                             .fadeIn(delay: 220.ms)
//                       else
//                         Container(
//                           decoration: BoxDecoration(
//                             color: _C.cardBg,
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(color: _C.border, width: 0.5),
//                           ),
//                           child: Column(
//                             children: List.generate(entries.length, (i) {
//                               return _DayRow(
//                                 entry: entries[i],
//                                 isLast: i == entries.length - 1,
//                                 delay: 220 + i * 25,
//                               );
//                             }),
//                           ),
//                         ).animate().fadeIn(delay: 220.ms, duration: 280.ms),
//                     ]),
//                   ),
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
// // HERO BAND
// // ─────────────────────────────────────────────────────────────────────────────

// class _HeroBand extends StatelessWidget {
//   final int year, month;
//   final MonthlyTracker? tracker;
//   const _HeroBand(
//       {required this.year, required this.month, required this.tracker});

//   String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}K' : '$n';

//   @override
//   Widget build(BuildContext context) {
//     final totalPts = tracker?.totalPoints ?? 0;
//     final pct = (tracker?.completionPercentage ?? 0).clamp(0.0, 100.0);
//     final daysInMonth = DateUtils.getDaysInMonth(year, month);
//     final daysCompleted = tracker?.daysCompleted ?? 0;
//     final isWinner = tracker?.isWinner ?? false;
//     final winnerCat = tracker?.winnerCategory;
//     final rank = tracker?.rank;

//     return Container(
//       color: _C.darkGreen,
//       child: Stack(
//         children: [
//           Positioned(
//               top: -45,
//               right: -40,
//               child: Container(
//                   width: 140,
//                   height: 140,
//                   decoration: const BoxDecoration(
//                       shape: BoxShape.circle, color: Color(0x0AFFFFFF)))),
//           Positioned(
//               bottom: -25,
//               left: 18,
//               child: Container(
//                   width: 88,
//                   height: 88,
//                   decoration: const BoxDecoration(
//                       shape: BoxShape.circle, color: Color(0x07FFFFFF)))),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('মাসের আমলের সারসংক্ষেপ',
//                     style: TextStyle(
//                         color: Colors.white.withOpacity(0.4),
//                         fontSize: 11,
//                         fontWeight: FontWeight.w500)),
//                 const SizedBox(height: 8),
//                 Container(
//                   padding: const EdgeInsets.all(14),
//                   decoration: BoxDecoration(
//                     color: const Color(0x17FFFFFF),
//                     borderRadius: BorderRadius.circular(14),
//                     border:
//                         Border.all(color: const Color(0x2EFFFFFF), width: 0.5),
//                   ),
//                   child: Row(
//                     children: [
//                       _CircularProgressWidget(percentage: pct, size: 60),
//                       const SizedBox(width: 14),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(_fmt(totalPts),
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w900,
//                                     fontSize: 28,
//                                     letterSpacing: -0.5,
//                                     height: 1),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis),
//                             const SizedBox(height: 3),
//                             Text('মোট পয়েন্ট',
//                                 style: TextStyle(
//                                     color: Colors.white.withOpacity(0.45),
//                                     fontSize: 10)),
//                             if (isWinner) ...[
//                               const SizedBox(height: 6),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 8, vertical: 3),
//                                 decoration: BoxDecoration(
//                                     color: _C.gold,
//                                     borderRadius: BorderRadius.circular(20)),
//                                 child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       const Text('🏆',
//                                           style: TextStyle(fontSize: 10)),
//                                       const SizedBox(width: 4),
//                                       Flexible(
//                                           child: Text(
//                                               winnerCat == 'TOP_FARZ'
//                                                   ? 'সর্বোচ্চ ফরজ'
//                                                   : winnerCat == 'TOP_EFFORT'
//                                                       ? 'সর্বোচ্চ আমল'
//                                                       : 'সর্বোচ্চ স্ট্রিক',
//                                               style: const TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 10,
//                                                   fontWeight: FontWeight.w700),
//                                               overflow: TextOverflow.ellipsis,
//                                               maxLines: 1)),
//                                     ]),
//                               ),
//                             ],
//                           ],
//                         ),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text('$daysCompleted/$daysInMonth',
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w800,
//                                   fontSize: 18,
//                                   letterSpacing: -0.4,
//                                   height: 1)),
//                           const SizedBox(height: 3),
//                           Text('সম্পন্ন দিন',
//                               style: TextStyle(
//                                   color: Colors.white.withOpacity(0.45),
//                                   fontSize: 10)),
//                           if (rank != null) ...[
//                             const SizedBox(height: 8),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 8, vertical: 3),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.08),
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(
//                                     color: Colors.white.withOpacity(0.15),
//                                     width: 0.5),
//                               ),
//                               child: Column(children: [
//                                 Text('র‍্যাংক',
//                                     style: TextStyle(
//                                         color: Colors.white.withOpacity(0.45),
//                                         fontSize: 8)),
//                                 Text('#$rank',
//                                     style: const TextStyle(
//                                         color: _C.gold,
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w900,
//                                         height: 1.1)),
//                               ]),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // CIRCULAR PROGRESS WIDGET
// // ─────────────────────────────────────────────────────────────────────────────

// class _CircularProgressWidget extends StatelessWidget {
//   final double percentage;
//   final double size;
//   const _CircularProgressWidget({required this.percentage, required this.size});

//   @override
//   Widget build(BuildContext context) {
//     final str = '${percentage.toInt()}%';
//     final digits = str.length;
//     final fontSize = digits >= 4
//         ? 9.0
//         : digits == 3
//             ? 10.0
//             : 12.0;
//     final innerSize = size * 0.82;

//     return SizedBox(
//       width: size,
//       height: size,
//       child: Stack(alignment: Alignment.center, children: [
//         SizedBox.expand(
//           child: CircularProgressIndicator(
//             value: percentage / 100,
//             backgroundColor: Colors.white.withOpacity(0.12),
//             valueColor: const AlwaysStoppedAnimation(_C.gold),
//             strokeWidth: size * 0.09,
//             strokeCap: StrokeCap.round,
//           ),
//         ),
//         Container(
//           width: innerSize,
//           height: innerSize,
//           decoration:
//               const BoxDecoration(color: _C.darkGreen, shape: BoxShape.circle),
//           child: Center(
//             child: FittedBox(
//               fit: BoxFit.scaleDown,
//               child: Padding(
//                 padding: EdgeInsets.all(size * 0.05),
//                 child: Column(mainAxisSize: MainAxisSize.min, children: [
//                   Text(str,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w900,
//                           fontSize: fontSize,
//                           height: 1),
//                       textAlign: TextAlign.center),
//                   SizedBox(height: size * 0.02),
//                   Text('সম্পন্ন',
//                       style: TextStyle(
//                           color: Colors.white.withOpacity(0.45),
//                           fontSize: size * 0.13),
//                       textAlign: TextAlign.center),
//                 ]),
//               ),
//             ),
//           ),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // FEMALE EXEMPT BANNER
// // ─────────────────────────────────────────────────────────────────────────────

// class _ExemptBanner extends StatelessWidget {
//   final int exemptCount;
//   const _ExemptBanner({required this.exemptCount});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       decoration: BoxDecoration(
//         color: _C.purplePale,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: _C.purple.withOpacity(0.25), width: 0.5),
//       ),
//       child: Row(children: [
//         Container(
//           width: 30,
//           height: 30,
//           decoration: BoxDecoration(
//               color: _C.purpleLight, borderRadius: BorderRadius.circular(8)),
//           child:
//               const Center(child: Text('🌙', style: TextStyle(fontSize: 15))),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             const Text('মাহে রমজান উপলক্ষে মাফের দিন চিহ্নিত',
//                 style: TextStyle(
//                     color: _C.purple,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w700)),
//             const SizedBox(height: 2),
//             Text(
//                 '$exemptCount দিন মাফ — নামাজ ও রোজার ক্যাটাগরি বাদ দেওয়া হয়েছে',
//                 style: TextStyle(
//                     color: _C.purple.withOpacity(0.7),
//                     fontSize: 10,
//                     fontWeight: FontWeight.w500)),
//           ]),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // STAT STRIP ROW 1
// // ─────────────────────────────────────────────────────────────────────────────

// class _StatStripRow1 extends StatelessWidget {
//   final MonthlyTracker? tracker;
//   const _StatStripRow1({this.tracker});

//   @override
//   Widget build(BuildContext context) {
//     final streak = tracker?.streakDays ?? 0;
//     final weekly = tracker?.weeklyPoints ?? 0;
//     final daily = tracker?.dailyPoints ?? 0;

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//       child: Row(children: [
//         Expanded(
//             child: _StatCard(
//                 emoji: '🔥',
//                 emojiBg: _C.amberLight,
//                 value: '$streak',
//                 label: 'স্ট্রিক দিন',
//                 valueColor: _C.amber)),
//         const SizedBox(width: 8),
//         Expanded(
//             child: _StatCard(
//                 emoji: '📿',
//                 emojiBg: _C.greenLight,
//                 value: '$weekly',
//                 label: 'সাপ্তাহিক pts',
//                 valueColor: _C.green)),
//         const SizedBox(width: 8),
//         Expanded(
//             child: _StatCard(
//                 emoji: '⭐',
//                 emojiBg: _C.goldLight2,
//                 value: '$daily',
//                 label: 'দৈনিক pts',
//                 valueColor: _C.gold)),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // STAT STRIP ROW 2
// // ─────────────────────────────────────────────────────────────────────────────

// class _StatStripRow2 extends StatelessWidget {
//   final List<DailyEntry> entries;
//   const _StatStripRow2({required this.entries});

//   @override
//   Widget build(BuildContext context) {
//     // সরাসরি API থেকে আসা data ব্যবহার
//     final totalPoints = entries.fold(0, (s, e) => s + e.totalPoints);
//     final activeDays = entries.where((e) => e.totalPoints > 0).length;
//     final exemptDays = entries.where((e) => e.isExemptDay).length;

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
//       child: Row(children: [
//         Expanded(
//             child: _StatCard(
//                 emoji: '📊',
//                 emojiBg: _C.purpleLight,
//                 value: '$totalPoints',
//                 label: 'মোট পয়েন্ট',
//                 valueColor: _C.purple)),
//         const SizedBox(width: 8),
//         Expanded(
//             child: _StatCard(
//                 emoji: '✅',
//                 emojiBg: _C.greenLight,
//                 value: '$activeDays',
//                 label: 'সক্রিয় দিন',
//                 valueColor: _C.green)),
//         const SizedBox(width: 8),
//         Expanded(
//             child: _StatCard(
//                 emoji: '🌙',
//                 emojiBg: _C.redLight,
//                 value: '$exemptDays',
//                 label: 'মাফের দিন',
//                 valueColor: _C.red)),
//       ]),
//     );
//   }
// }

// class _StatCard extends StatelessWidget {
//   final String emoji, value, label;
//   final Color emojiBg, valueColor;
//   const _StatCard({
//     required this.emoji,
//     required this.emojiBg,
//     required this.value,
//     required this.label,
//     required this.valueColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(11),
//       decoration: BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.circular(13),
//           border: Border.all(color: _C.border, width: 0.5)),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Container(
//             width: 28,
//             height: 28,
//             decoration: BoxDecoration(
//                 color: emojiBg, borderRadius: BorderRadius.circular(7)),
//             child: Center(
//                 child: Text(emoji, style: const TextStyle(fontSize: 13)))),
//         const SizedBox(height: 7),
//         Text(value,
//             style: TextStyle(
//                 color: valueColor,
//                 fontWeight: FontWeight.w800,
//                 fontSize: 19,
//                 letterSpacing: -0.4,
//                 height: 1),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis),
//         const SizedBox(height: 2),
//         Text(label,
//             style: const TextStyle(
//                 color: _C.textSecondary,
//                 fontSize: 9.5,
//                 fontWeight: FontWeight.w500)),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // WEEKLY CHART SECTION (সরলীকৃত)
// // ─────────────────────────────────────────────────────────────────────────────

// class _WeeklyChartSection extends StatelessWidget {
//   final List<WeeklyBarData> weekData;
//   final String userGender;
//   const _WeeklyChartSection({required this.weekData, required this.userGender});

//   @override
//   Widget build(BuildContext context) {
//     if (weekData.isEmpty) return const SizedBox.shrink();

//     final maxPts =
//         weekData.map((d) => d.points).fold(0, (a, b) => a > b ? a : b);
//     final safePts = maxPts < 1 ? 1 : maxPts;
//     final today = DateTime.now();

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         _SectionHeader(title: 'এই সপ্তাহের অগ্রগতি', emoji: '📊'),
//         const SizedBox(height: 10),
//         Container(
//           padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
//           decoration: BoxDecoration(
//             color: _C.cardBg,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.border, width: 0.5),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               LayoutBuilder(builder: (context, constraints) {
//                 final chartH = (constraints.maxWidth * 0.40).clamp(80.0, 160.0);
//                 const labelRowH = 30.0;
//                 final barAreaH = chartH - labelRowH;

//                 return SizedBox(
//                   height: chartH,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: weekData.map((d) {
//                       final dayDate = DateTime.tryParse(d.date);
//                       final isToday = dayDate != null &&
//                           dayDate.year == today.year &&
//                           dayDate.month == today.month &&
//                           dayDate.day == today.day;
//                       final isExempt = d.isExemptDay && userGender == 'female';

//                       final fillFrac = d.points > 0
//                           ? (d.points / safePts).clamp(0.0, 1.0)
//                           : 0.0;
//                       final fillH = fillFrac > 0
//                           ? (fillFrac * barAreaH).clamp(4.0, barAreaH)
//                           : 0.0;

//                       return Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 2),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               SizedBox(
//                                 height: 14,
//                                 child: d.points > 0
//                                     ? FittedBox(
//                                         fit: BoxFit.scaleDown,
//                                         child: Text(
//                                           '${d.points}',
//                                           style: TextStyle(
//                                             fontSize: 8,
//                                             color: isToday
//                                                 ? _C.darkGreen
//                                                 : _C.textHint,
//                                             fontWeight: isToday
//                                                 ? FontWeight.w700
//                                                 : FontWeight.w500,
//                                           ),
//                                         ),
//                                       )
//                                     : const SizedBox.shrink(),
//                               ),
//                               const SizedBox(height: 2),
//                               if (isExempt)
//                                 Container(
//                                   height:
//                                       (barAreaH * 0.45).clamp(20.0, barAreaH),
//                                   decoration: BoxDecoration(
//                                     color: _C.purpleLight,
//                                     borderRadius: BorderRadius.circular(4),
//                                     border: Border.all(
//                                         color: _C.purple.withOpacity(0.3),
//                                         width: 0.5),
//                                   ),
//                                   child: const Center(
//                                       child: Text('🌙',
//                                           style: TextStyle(fontSize: 8))),
//                                 )
//                               else if (fillH > 0)
//                                 Container(
//                                   height: fillH,
//                                   width: double.infinity,
//                                   decoration: BoxDecoration(
//                                     color: isToday ? _C.darkGreen : _C.midGreen,
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                 )
//                               else
//                                 Container(
//                                   height: 4,
//                                   decoration: BoxDecoration(
//                                     color: _C.pageBg,
//                                     borderRadius: BorderRadius.circular(3),
//                                     border: Border.all(
//                                         color: _C.border, width: 0.5),
//                                   ),
//                                 ),
//                               const SizedBox(height: 4),
//                               FittedBox(
//                                 fit: BoxFit.scaleDown,
//                                 child: Text(
//                                   d.day,
//                                   style: TextStyle(
//                                     fontSize: 9,
//                                     color: isToday
//                                         ? _C.darkGreen
//                                         : _C.textSecondary,
//                                     fontWeight: isToday
//                                         ? FontWeight.w800
//                                         : FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 );
//               }),
//               const SizedBox(height: 10),
//               const Divider(height: 1, thickness: 0.5, color: _C.border),
//               const SizedBox(height: 10),
//               Row(children: [
//                 _WeekStat(
//                   label: 'সাপ্তাহিক পয়েন্ট',
//                   value: '${weekData.fold(0, (s, d) => s + d.points)}',
//                   color: _C.green,
//                 ),
//                 const SizedBox(width: 8),
//                 _WeekStat(
//                   label: 'সক্রিয় দিন',
//                   value: '${weekData.where((d) => d.hasData).length}',
//                   color: _C.purple,
//                 ),
//                 const SizedBox(width: 8),
//                 _WeekStat(
//                   label: 'মাফের দিন',
//                   value: '${weekData.where((d) => d.isExemptDay).length}',
//                   color: _C.amber,
//                 ),
//               ]),
//             ],
//           ),
//         ),
//       ]),
//     );
//   }
// }

// class _WeekStat extends StatelessWidget {
//   final String label, value;
//   final Color color;
//   const _WeekStat(
//       {required this.label, required this.value, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
//         decoration: BoxDecoration(
//             color: _C.pageBg, borderRadius: BorderRadius.circular(8)),
//         child: Column(children: [
//           Text(value,
//               style: TextStyle(
//                   color: color,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w800,
//                   height: 1)),
//           const SizedBox(height: 2),
//           Text(label,
//               style: const TextStyle(color: _C.textHint, fontSize: 8.5),
//               textAlign: TextAlign.center),
//         ]),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // INSIGHTS SECTION (সরলীকৃত)
// // ─────────────────────────────────────────────────────────────────────────────

// class _InsightsSection extends StatelessWidget {
//   final List<DailyEntry> entries;
//   final MonthlyTracker? tracker;
//   const _InsightsSection({required this.entries, this.tracker});

//   @override
//   Widget build(BuildContext context) {
//     final totalDays = entries.length;
//     final activeDays = entries.where((e) => e.totalPoints > 0).length;
//     final exemptDays = entries.where((e) => e.isExemptDay).length;
//     final totalPoints = tracker?.totalPoints ??
//         entries.fold<int>(0, (s, e) => s + (e.totalPoints ?? 0));

//     // Null safety সহ avgPoints calculation
//     final avgPoints = activeDays > 0 ? (totalPoints / activeDays).round() : 0;

//     final completionPercentage = tracker?.completionPercentage ?? 0;
//     final streakDays = tracker?.streakDays ?? 0;
//     final fardPoints = tracker?.fardPoints ?? 0;

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const _SectionHeader(title: 'মাসিক সারাংশ', emoji: '📊'),
//         const SizedBox(height: 10),
//         Row(children: [
//           Expanded(
//             child: _InsightCard(
//               emoji: '✅',
//               bg: _C.greenLight,
//               value: '$activeDays/$totalDays',
//               label: 'সক্রিয় দিন',
//               color: _C.green,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: _InsightCard(
//               emoji: '📊',
//               bg: _C.goldLight2,
//               value: '$avgPoints',
//               label: 'গড় পয়েন্ট/দিন',
//               color: _C.gold,
//             ),
//           ),
//         ]),
//         const SizedBox(height: 8),
//         Row(children: [
//           Expanded(
//             child: _InsightCard(
//               emoji: '⭐',
//               bg: _C.purplePale,
//               value: '${completionPercentage.toInt()}%',
//               label: 'ফরজ সম্পন্ন',
//               color: _C.purple,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: _InsightCard(
//               emoji: '🏆',
//               bg: _C.amberLight,
//               value: '$streakDays',
//               label: 'স্ট্রিক দিন',
//               color: _C.amber,
//             ),
//           ),
//         ]),
//         const SizedBox(height: 8),
//         Row(children: [
//           Expanded(
//             child: _InsightCard(
//               emoji: '🌙',
//               bg: _C.redLight,
//               value: '$exemptDays',
//               label: 'মাফের দিন',
//               color: _C.red,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: _InsightCard(
//               emoji: '🎯',
//               bg: _C.greenLight,
//               value: '$fardPoints',
//               label: 'ফরজ পয়েন্ট',
//               color: _C.midGreen,
//             ),
//           ),
//         ]),
//       ]),
//     );

//     // Padding(
//     //   padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//     //   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//     //     _SectionHeader(title: 'মাসিক সারাংশ', emoji: '📊'),
//     //     const SizedBox(height: 10),
//     //     Row(children: [
//     //       Expanded(
//     //         child: _InsightCard(
//     //           emoji: '✅',
//     //           bg: _C.greenLight,
//     //           value: '$activeDays/$totalDays',
//     //           label: 'সক্রিয় দিন',
//     //           color: _C.green,
//     //         ),
//     //       ),
//     //       const SizedBox(width: 8),
//     //       Expanded(
//     //         child: _InsightCard(
//     //           emoji: '📊',
//     //           bg: _C.goldLight2,
//     //           value: '$avgPoints',
//     //           label: 'গড় পয়েন্ট/দিন',
//     //           color: _C.gold,
//     //         ),
//     //       ),
//     //     ]),
//     //     const SizedBox(height: 8),
//     //     Row(children: [
//     //       Expanded(
//     //         child: _InsightCard(
//     //           emoji: '⭐',
//     //           bg: _C.purplePale,
//     //           value: '${tracker?.completionPercentage ?? 0}%',
//     //           label: 'ফরজ সম্পন্ন',
//     //           color: _C.purple,
//     //         ),
//     //       ),
//     //       const SizedBox(width: 8),
//     //       Expanded(
//     //         child: _InsightCard(
//     //           emoji: '🏆',
//     //           bg: _C.amberLight,
//     //           value: '${tracker?.streakDays ?? 0}',
//     //           label: 'স্ট্রিক দিন',
//     //           color: _C.amber,
//     //         ),
//     //       ),
//     //     ]),
//     //     const SizedBox(height: 8),
//     //     Row(children: [
//     //       Expanded(
//     //         child: _InsightCard(
//     //           emoji: '🌙',
//     //           bg: _C.redLight,
//     //           value: '$exemptDays',
//     //           label: 'মাফের দিন',
//     //           color: _C.red,
//     //         ),
//     //       ),
//     //       const SizedBox(width: 8),
//     //       Expanded(
//     //         child: _InsightCard(
//     //           emoji: '🎯',
//     //           bg: _C.greenLight,
//     //           value: '${tracker?.fardPoints ?? 0}',
//     //           label: 'ফরজ পয়েন্ট',
//     //           color: _C.midGreen,
//     //         ),
//     //       ),
//     //     ]),
//     //   ]),
//     // );
//   }
// }

// class _InsightCard extends StatelessWidget {
//   final String emoji, value, label;
//   final Color bg, color;
//   const _InsightCard({
//     required this.emoji,
//     required this.bg,
//     required this.value,
//     required this.label,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.circular(13),
//           border: Border.all(color: _C.border, width: 0.5)),
//       child: Row(children: [
//         Container(
//             width: 34,
//             height: 34,
//             decoration: BoxDecoration(
//                 color: bg, borderRadius: BorderRadius.circular(9)),
//             child: Center(
//                 child: Text(emoji, style: const TextStyle(fontSize: 16)))),
//         const SizedBox(width: 10),
//         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text(value,
//               style: TextStyle(
//                   color: color,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   height: 1)),
//           const SizedBox(height: 2),
//           Text(label,
//               style: const TextStyle(
//                   color: _C.textSecondary,
//                   fontSize: 9.5,
//                   fontWeight: FontWeight.w500)),
//         ]),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PREVIOUS MONTHS CHART
// // ─────────────────────────────────────────────────────────────────────────────

// class _PrevMonthsSection extends StatelessWidget {
//   final List<MonthlyTracker> months;
//   const _PrevMonthsSection({required this.months});

//   String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}K' : '$n';

//   List<MonthlyTracker> _dedup(List<MonthlyTracker> raw) {
//     final seen = <String>{};
//     final result = <MonthlyTracker>[];
//     for (final m in raw.reversed) {
//       final key = '${m.year}-${m.month}';
//       if (seen.add(key)) result.add(m);
//     }
//     return result.reversed.toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final unique = _dedup(months);
//     if (unique.isEmpty) return const SizedBox.shrink();

//     final maxPts =
//         unique.map((m) => m.totalPoints).fold(0, (a, b) => a > b ? a : b);
//     final safePts = maxPts < 1 ? 1 : maxPts;
//     final current = unique.last;

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         _SectionHeader(title: 'মাসিক তুলনা', emoji: '📈'),
//         const SizedBox(height: 10),
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: _C.cardBg,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.border, width: 0.5),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               LayoutBuilder(builder: (context, constraints) {
//                 final chartH = (constraints.maxWidth * 0.38).clamp(80.0, 150.0);
//                 const labelH = 32.0;
//                 const topLblH = 14.0;
//                 final barAreaH =
//                     (chartH - labelH - topLblH).clamp(20.0, chartH);

//                 return SizedBox(
//                   height: chartH,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: unique.map((m) {
//                       final isActive =
//                           m.year == current.year && m.month == current.month;
//                       final fillFrac = m.totalPoints > 0
//                           ? (m.totalPoints / safePts).clamp(0.0, 1.0)
//                           : 0.0;
//                       final fillH = fillFrac > 0
//                           ? (fillFrac * barAreaH).clamp(4.0, barAreaH)
//                           : 4.0;

//                       final mName = AppConstants.bengaliMonths[m.month - 1];
//                       final mShort =
//                           mName.length > 3 ? mName.substring(0, 3) : mName;

//                       return Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 3),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               SizedBox(
//                                 height: topLblH,
//                                 child: FittedBox(
//                                   fit: BoxFit.scaleDown,
//                                   child: Text(
//                                     _fmt(m.totalPoints),
//                                     style: TextStyle(
//                                       fontSize: 8,
//                                       color:
//                                           isActive ? _C.darkGreen : _C.textHint,
//                                       fontWeight: isActive
//                                           ? FontWeight.w800
//                                           : FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 2),
//                               ClipRRect(
//                                 borderRadius: const BorderRadius.vertical(
//                                     top: Radius.circular(5)),
//                                 child: Container(
//                                   height: fillH,
//                                   width: double.infinity,
//                                   color: isActive
//                                       ? _C.darkGreen
//                                       : _C.midGreen.withOpacity(0.5),
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               FittedBox(
//                                 fit: BoxFit.scaleDown,
//                                 child: Text(
//                                   mShort,
//                                   style: TextStyle(
//                                     fontSize: 9,
//                                     color: isActive
//                                         ? _C.darkGreen
//                                         : _C.textSecondary,
//                                     fontWeight: isActive
//                                         ? FontWeight.w800
//                                         : FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                               FittedBox(
//                                 fit: BoxFit.scaleDown,
//                                 child: Text(
//                                   '${m.completionPercentage.toInt()}%',
//                                   style: TextStyle(
//                                     fontSize: 8,
//                                     color: isActive ? _C.gold : _C.textHint,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 );
//               }),
//             ],
//           ),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // RANK SECTION
// // ─────────────────────────────────────────────────────────────────────────────

// class _RankSection extends StatelessWidget {
//   final MonthlyTracker tracker;
//   const _RankSection({required this.tracker});

//   @override
//   Widget build(BuildContext context) {
//     final rank = tracker.rank!;
//     final pct = tracker.completionPercentage.clamp(0.0, 100.0);

//     String rankLabel() {
//       if (rank <= 1) return 'সর্বোচ্চ অবস্থানে আছেন!';
//       if (rank <= 3) return 'শীর্ষ ৩ জনের মধ্যে!';
//       if (rank <= 10) return 'শীর্ষ ১০ জনের মধ্যে';
//       return 'র‍্যাংক #$rank এ আছেন';
//     }

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         _SectionHeader(title: 'লিডারবোর্ড অবস্থান', emoji: '🏅'),
//         const SizedBox(height: 10),
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: _C.cardBg,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.border, width: 0.5),
//           ),
//           child: Row(children: [
//             Container(
//               width: 60,
//               height: 60,
//               decoration: BoxDecoration(
//                   color: _C.greenLight,
//                   borderRadius: BorderRadius.circular(14)),
//               child: Center(
//                   child: Text('#$rank',
//                       style: const TextStyle(
//                           color: _C.darkGreen,
//                           fontSize: 22,
//                           fontWeight: FontWeight.w900))),
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                   Text(rankLabel(),
//                       style: const TextStyle(
//                           color: _C.textPrimary,
//                           fontSize: 13,
//                           fontWeight: FontWeight.w700)),
//                   const SizedBox(height: 3),
//                   Text(
//                       'সম্পন্ন ${pct.toInt()}% · ${tracker.totalPoints} পয়েন্ট',
//                       style: const TextStyle(
//                           color: _C.textSecondary,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w500)),
//                   const SizedBox(height: 8),
//                   ClipRRect(
//                       borderRadius: BorderRadius.circular(99),
//                       child: LinearProgressIndicator(
//                         value: pct / 100,
//                         minHeight: 5,
//                         backgroundColor: _C.pageBg,
//                         valueColor: const AlwaysStoppedAnimation(_C.darkGreen),
//                       )),
//                 ])),
//             if (tracker.isWinner) ...[
//               const SizedBox(width: 12),
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                     color: _C.goldLight2,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                         color: _C.gold.withOpacity(0.3), width: 0.5)),
//                 child: const Text('🏆', style: TextStyle(fontSize: 22)),
//               ),
//             ],
//           ]),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // HEATMAP CALENDAR
// // ─────────────────────────────────────────────────────────────────────────────

// class _HeatmapCalendar extends StatelessWidget {
//   final int year, month;
//   final List<DailyEntry> entries;
//   const _HeatmapCalendar(
//       {required this.year, required this.month, required this.entries});

//   @override
//   Widget build(BuildContext context) {
//     final daysInMonth = DateUtils.getDaysInMonth(year, month);
//     final entryMap = {for (final e in entries) e.day: e};
//     final maxPts = entries.isEmpty
//         ? 1
//         : entries
//             .map((e) => e.totalPoints)
//             .reduce((a, b) => a > b ? a : b)
//             .clamp(1, 9999);
//     final today = DateTime.now();
//     final firstDay = DateTime(year, month, 1).weekday % 7;
//     final totalCells = ((firstDay + daysInMonth) / 7).ceil() * 7;
//     const weekdays = ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহঃ', 'শুক্র', 'শনি'];

//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: _C.border, width: 0.5)),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(
//             children: weekdays
//                 .map((d) => Expanded(
//                       child: Center(
//                           child: Text(d,
//                               style: const TextStyle(
//                                   color: _C.textHint,
//                                   fontSize: 9.5,
//                                   fontWeight: FontWeight.w500))),
//                     ))
//                 .toList()),
//         const SizedBox(height: 6),
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 7,
//               crossAxisSpacing: 3,
//               mainAxisSpacing: 3,
//               childAspectRatio: 1.1),
//           itemCount: totalCells,
//           itemBuilder: (ctx, index) {
//             final dayNum = index - firstDay + 1;
//             if (dayNum < 1 || dayNum > daysInMonth)
//               return const SizedBox.shrink();

//             final entry = entryMap[dayNum];
//             final pts = entry?.totalPoints ?? 0;
//             final isExempt = entry?.isExemptDay ?? false;
//             final intensity = pts / maxPts;
//             final isToday = today.year == year &&
//                 today.month == month &&
//                 today.day == dayNum;
//             final isFuture = DateTime(year, month, dayNum).isAfter(today);

//             Color cellColor;
//             Color numColor;

//             if (isExempt) {
//               cellColor = _C.purplePale;
//               numColor = _C.purple;
//             } else if (isFuture) {
//               cellColor = _C.pageBg;
//               numColor = _C.textHint;
//             } else if (pts == 0) {
//               cellColor = _C.greenLight.withOpacity(0.5);
//               numColor = _C.textHint;
//             } else if (intensity < 0.25) {
//               cellColor = _C.green.withOpacity(0.18);
//               numColor = _C.green;
//             } else if (intensity < 0.5) {
//               cellColor = _C.green.withOpacity(0.38);
//               numColor = _C.green;
//             } else if (intensity < 0.75) {
//               cellColor = _C.green.withOpacity(0.60);
//               numColor = Colors.white;
//             } else {
//               cellColor = _C.green.withOpacity(0.85);
//               numColor = Colors.white;
//             }

//             return Container(
//               decoration: BoxDecoration(
//                 color: cellColor,
//                 borderRadius: BorderRadius.circular(5),
//                 border: isToday ? Border.all(color: _C.gold, width: 1.5) : null,
//               ),
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('$dayNum',
//                         style: TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.w700,
//                             color: numColor,
//                             height: 1)),
//                     if (isExempt)
//                       Text('🌙', style: TextStyle(fontSize: 6.5, height: 1))
//                     else if (pts > 0 && !isFuture)
//                       Text('$pts',
//                           style: TextStyle(
//                               fontSize: 7.5,
//                               color: numColor.withOpacity(0.7),
//                               fontWeight: FontWeight.w600,
//                               height: 1)),
//                   ]),
//             ).animate(delay: Duration(milliseconds: dayNum * 8)).scale(
//                 begin: const Offset(0.7, 0.7),
//                 duration: 200.ms,
//                 curve: Curves.easeOut);
//           },
//         ),
//         const SizedBox(height: 10),
//         Row(mainAxisAlignment: MainAxisAlignment.end, children: [
//           const Text('কম  ',
//               style: TextStyle(color: _C.textHint, fontSize: 9.5)),
//           ...List.generate(
//               5,
//               (i) => Container(
//                     width: 12,
//                     height: 12,
//                     margin: const EdgeInsets.only(right: 3),
//                     decoration: BoxDecoration(
//                       color: i == 0
//                           ? _C.greenLight
//                           : _C.green.withOpacity(0.15 + i * 0.18),
//                       borderRadius: BorderRadius.circular(3),
//                     ),
//                   )),
//           const Text('  বেশি',
//               style: TextStyle(color: _C.textHint, fontSize: 9.5)),
//           const SizedBox(width: 10),
//           Container(
//               width: 12,
//               height: 12,
//               margin: const EdgeInsets.only(right: 3),
//               decoration: BoxDecoration(
//                   color: _C.purplePale,
//                   borderRadius: BorderRadius.circular(3),
//                   border: Border.all(
//                       color: _C.purple.withOpacity(0.3), width: 0.5))),
//           const Text('মাফ',
//               style: TextStyle(color: _C.textHint, fontSize: 9.5)),
//         ]),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DAY ROW
// // ─────────────────────────────────────────────────────────────────────────────

// class _DayRow extends StatelessWidget {
//   final DailyEntry entry;
//   final bool isLast;
//   final int delay;
//   const _DayRow(
//       {required this.entry, required this.isLast, required this.delay});

//   @override
//   Widget build(BuildContext context) {
//     final completedCount = entry.entries.where((e) => e.completed).length;
//     final totalPoints = entry.totalPoints;
//     final isExempt = entry.isExemptDay;

//     String getMonthShort(int idx) {
//       final full = AppConstants.bengaliMonths[idx];
//       return full.length >= 3 ? full.substring(0, 3) : full;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
//       decoration: BoxDecoration(
//         color: isExempt
//             ? _C.purplePale.withOpacity(0.4)
//             : totalPoints > 0
//                 ? _C.greenLight.withOpacity(0.18)
//                 : Colors.transparent,
//         border: isLast
//             ? null
//             : const Border(bottom: BorderSide(color: _C.border, width: 0.5)),
//         borderRadius: isLast
//             ? const BorderRadius.vertical(bottom: Radius.circular(16))
//             : null,
//       ),
//       child: Row(children: [
//         Container(
//           width: 44,
//           height: 44,
//           decoration: BoxDecoration(
//             gradient: isExempt
//                 ? const LinearGradient(
//                     colors: [_C.purple, Color(0xFF9B6BE8)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight)
//                 : totalPoints > 0
//                     ? const LinearGradient(
//                         colors: [_C.darkGreen, _C.midGreen],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight)
//                     : null,
//             color: isExempt || totalPoints > 0 ? null : _C.pageBg,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Text('${entry.day}',
//                 style: TextStyle(
//                     color: isExempt || totalPoints > 0
//                         ? Colors.white
//                         : _C.textHint,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 15,
//                     height: 1)),
//             Text(getMonthShort(entry.month - 1),
//                 style: TextStyle(
//                     color: isExempt || totalPoints > 0
//                         ? Colors.white.withOpacity(0.6)
//                         : _C.textHint,
//                     fontSize: 8.5)),
//           ]),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text(isExempt ? 'মাফের দিন' : '$completedCount টি আমল',
//               style: TextStyle(
//                   color: isExempt
//                       ? _C.purple
//                       : totalPoints > 0
//                           ? _C.textPrimary
//                           : _C.textSecondary,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 12),
//               overflow: TextOverflow.ellipsis),
//           const SizedBox(height: 4),
//           ClipRRect(
//               borderRadius: BorderRadius.circular(99),
//               child: LinearProgressIndicator(
//                 value: (completedCount / 20).clamp(0.0, 1.0),
//                 minHeight: 4,
//                 backgroundColor: _C.pageBg,
//                 valueColor: AlwaysStoppedAnimation(totalPoints > 0
//                     ? (completedCount > 15
//                         ? _C.green
//                         : completedCount > 8
//                             ? _C.amber
//                             : _C.darkGreen)
//                     : _C.border),
//               )),
//         ])),
//         const SizedBox(width: 10),
//         Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
//           Text('${entry.totalPoints}',
//               style: TextStyle(
//                   color: isExempt
//                       ? _C.purple
//                       : totalPoints > 0
//                           ? _C.darkGreen
//                           : _C.textHint,
//                   fontWeight: FontWeight.w900,
//                   fontSize: 18,
//                   height: 1)),
//           const Text('pts',
//               style: TextStyle(
//                   color: _C.textSecondary,
//                   fontSize: 9.5,
//                   fontWeight: FontWeight.w500)),
//         ]),
//       ]),
//     )
//         .animate(delay: Duration(milliseconds: delay))
//         .fadeIn(duration: 240.ms)
//         .slideX(begin: 0.04, curve: Curves.easeOut);
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
//           style: const TextStyle(
//               color: _C.textPrimary,
//               fontWeight: FontWeight.w800,
//               fontSize: 15,
//               letterSpacing: -0.2)),
//     ]);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PERIOD PICKER SHEET
// // ─────────────────────────────────────────────────────────────────────────────

// class _PeriodPickerSheet extends StatefulWidget {
//   final int year, month;
//   final void Function(int, int) onPicked;
//   const _PeriodPickerSheet(
//       {required this.year, required this.month, required this.onPicked});

//   @override
//   State<_PeriodPickerSheet> createState() => _PeriodPickerSheetState();
// }

// class _PeriodPickerSheetState extends State<_PeriodPickerSheet> {
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
//       decoration: const BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
//       padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         Container(
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//                 color: _C.border, borderRadius: BorderRadius.circular(99))),
//         const SizedBox(height: 22),
//         const Text('মাস বেছে নিন',
//             style: TextStyle(
//                 color: _C.textPrimary,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700)),
//         const SizedBox(height: 18),
//         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           _YearArrow(
//               icon: Icons.chevron_left_rounded,
//               onTap: () => setState(() => _y--),
//               enabled: true),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//             decoration: BoxDecoration(
//                 color: _C.greenLight, borderRadius: BorderRadius.circular(12)),
//             child: Text('$_y',
//                 style: const TextStyle(
//                     color: _C.darkGreen,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 18)),
//           ),
//           _YearArrow(
//               icon: Icons.chevron_right_rounded,
//               onTap: _y < now.year ? () => setState(() => _y++) : null,
//               enabled: _y < now.year),
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
//                   color: isSelected ? _C.darkGreen : _C.pageBg,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(
//                       color: isSelected
//                           ? _C.darkGreen
//                           : isFuture
//                               ? _C.border.withOpacity(0.4)
//                               : _C.border,
//                       width: 0.5),
//                 ),
//                 child: Center(
//                     child: Text(AppConstants.bengaliMonths[i],
//                         style: TextStyle(
//                             color: isSelected
//                                 ? Colors.white
//                                 : isFuture
//                                     ? _C.textHint
//                                     : _C.textSecondary,
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

// class _YearArrow extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback? onTap;
//   final bool enabled;
//   const _YearArrow(
//       {required this.icon, required this.onTap, required this.enabled});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 38,
//         height: 38,
//         margin: const EdgeInsets.symmetric(horizontal: 12),
//         decoration: BoxDecoration(
//           color: enabled ? _C.greenLight : _C.pageBg,
//           borderRadius: BorderRadius.circular(10),
//           border:
//               Border.all(color: enabled ? _C.borderMid : _C.border, width: 0.5),
//         ),
//         child:
//             Icon(icon, color: enabled ? _C.darkGreen : _C.textHint, size: 20),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SKELETON WIDGETS
// // ─────────────────────────────────────────────────────────────────────────────

// class _HeroBandSkeleton extends StatelessWidget {
//   const _HeroBandSkeleton();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: _C.darkGreen,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Container(
//               width: 130,
//               height: 11,
//               decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(4))),
//           const SizedBox(height: 12),
//           Container(
//             height: 92,
//             decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.08),
//                 borderRadius: BorderRadius.circular(14)),
//           )
//               .animate(onPlay: (c) => c.repeat())
//               .shimmer(duration: 1200.ms, colors: [
//             Colors.white.withOpacity(0.02),
//             Colors.white.withOpacity(0.08),
//             Colors.white.withOpacity(0.02)
//           ]),
//         ]),
//       ),
//     );
//   }
// }

// class _StatStripSkeleton extends StatelessWidget {
//   const _StatStripSkeleton();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//       child: Row(
//           children: List.generate(
//               3,
//               (i) => Expanded(
//                     child: Container(
//                       margin: EdgeInsets.only(left: i == 0 ? 0 : 8),
//                       height: 86,
//                       decoration: BoxDecoration(
//                           color: _C.cardBg,
//                           borderRadius: BorderRadius.circular(13)),
//                     ).animate(onPlay: (c) => c.repeat()).shimmer(
//                         duration: 1200.ms,
//                         delay: Duration(milliseconds: i * 60),
//                         colors: [
//                           _C.cardBg,
//                           const Color(0xFFE8ECE8),
//                           _C.cardBg
//                         ]),
//                   ))),
//     );
//   }
// }

// class _StatStrip2Skeleton extends StatelessWidget {
//   const _StatStrip2Skeleton();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
//       child: Row(
//           children: List.generate(
//               3,
//               (i) => Expanded(
//                     child: Container(
//                       margin: EdgeInsets.only(left: i == 0 ? 0 : 8),
//                       height: 86,
//                       decoration: BoxDecoration(
//                           color: _C.cardBg,
//                           borderRadius: BorderRadius.circular(13)),
//                     ).animate(onPlay: (c) => c.repeat()).shimmer(
//                         duration: 1200.ms,
//                         delay: Duration(milliseconds: i * 60),
//                         colors: [
//                           _C.cardBg,
//                           const Color(0xFFE8ECE8),
//                           _C.cardBg
//                         ]),
//                   ))),
//     );
//   }
// }

// class _SectionSkeleton extends StatelessWidget {
//   final double height;
//   const _SectionSkeleton({required this.height});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Container(
//         height: height,
//         decoration: BoxDecoration(
//             color: _C.cardBg,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.border, width: 0.5)),
//       ).animate(onPlay: (c) => c.repeat()).shimmer(
//           duration: 1200.ms,
//           colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg]),
//     );
//   }
// }

// class _EntriesSkeleton extends StatelessWidget {
//   const _EntriesSkeleton();

//   @override
//   Widget build(BuildContext context) {
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       const SizedBox(height: 22),
//       _shimmerBar(width: 130, height: 14),
//       const SizedBox(height: 12),
//       _shimmerBox(height: 240),
//       const SizedBox(height: 22),
//       _shimmerBar(width: 150, height: 14),
//       const SizedBox(height: 12),
//       Container(
//         decoration: BoxDecoration(
//             color: _C.cardBg,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.border, width: 0.5)),
//         child: Column(
//             children: List.generate(5, (i) {
//           return Container(
//             height: 64,
//             margin: const EdgeInsets.fromLTRB(14, 10, 14, 10),
//             decoration: BoxDecoration(
//                 color: _C.pageBg, borderRadius: BorderRadius.circular(10)),
//           ).animate(onPlay: (c) => c.repeat()).shimmer(
//               duration: 1200.ms,
//               delay: Duration(milliseconds: i * 70),
//               colors: [_C.pageBg, const Color(0xFFE8ECE8), _C.pageBg]);
//         })),
//       ),
//     ]);
//   }

//   static Widget _shimmerBar({required double width, required double height}) =>
//       Container(
//         width: width,
//         height: height,
//         decoration: BoxDecoration(
//             color: _C.cardBg, borderRadius: BorderRadius.circular(8)),
//       ).animate(onPlay: (c) => c.repeat()).shimmer(
//           duration: 1200.ms,
//           colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg]);

//   static Widget _shimmerBox({required double height}) => Container(
//         width: double.infinity,
//         height: height,
//         decoration: BoxDecoration(
//             color: _C.cardBg,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.border, width: 0.5)),
//       ).animate(onPlay: (c) => c.repeat()).shimmer(
//           duration: 1200.ms,
//           colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg]);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // ERROR + EMPTY CARDS
// // ─────────────────────────────────────────────────────────────────────────────

// class _ErrorCard extends StatelessWidget {
//   final VoidCallback onRetry;
//   const _ErrorCard({required this.onRetry});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(top: 24),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: _C.border, width: 0.5)),
//       child: Column(children: [
//         const Icon(Icons.error_outline_rounded, color: _C.red, size: 30),
//         const SizedBox(height: 8),
//         const Text('ডেটা লোড ব্যর্থ হয়েছে',
//             style: TextStyle(
//                 color: _C.textPrimary,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 14)),
//         const SizedBox(height: 12),
//         GestureDetector(
//             onTap: onRetry,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
//               decoration: BoxDecoration(
//                   color: _C.greenLight,
//                   borderRadius: BorderRadius.circular(10)),
//               child: const Text('পুনরায় চেষ্টা করুন',
//                   style: TextStyle(
//                       color: _C.darkGreen,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 12)),
//             )),
//       ]),
//     );
//   }
// }

// class _EmptyCard extends StatelessWidget {
//   final String label;
//   const _EmptyCard({required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 110,
//       decoration: BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: _C.border, width: 0.5)),
//       child: Center(
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//         const Text('📭', style: TextStyle(fontSize: 22)),
//         const SizedBox(height: 6),
//         Text(label,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//                 color: _C.textHint, fontSize: 12, fontWeight: FontWeight.w500)),
//       ])),
//     );
//   }
// }
