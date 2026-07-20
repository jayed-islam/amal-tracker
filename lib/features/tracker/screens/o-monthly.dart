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
//   static const pageBg        = Color(0xFFF4F6F1);
//   static const cardBg        = Color(0xFFFFFFFF);
//   static const darkGreen     = Color(0xFF0E3D22);
//   static const midGreen      = Color(0xFF1B7045);
//   static const gold          = Color(0xFFD4A843);
//   static const goldLight     = Color(0xFFFFF8E7);
//   static const green         = Color(0xFF16A34A);
//   static const greenLight    = Color(0xFFE8F5EE);
//   static const amber         = Color(0xFFFF6B35);
//   static const amberLight    = Color(0xFFFFF3E0);
//   static const purple        = Color(0xFF7C3AED);
//   static const purpleLight   = Color(0xFFEDE9FE);
//   static const purplePale    = Color(0xFFF3F0FF);
//   static const indigo        = Color(0xFF4F46E5);
//   static const red           = Color(0xFFEF4444);
//   static const redLight      = Color(0xFFFEE2E2);
//   static const textPrimary   = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint      = Color(0xFFABBAAE);
//   static const border        = Color(0xFFE4EAE4);
//   static const borderMid     = Color(0xFFD0DAD2);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION META — category.section key থেকে বাংলা লেবেল/ইমোজি (UI-only mapping,
// // backend স্ট্যাটিক বাকেটের সাথে কোনো সম্পর্ক নেই — শুধু display grouping)
// // ─────────────────────────────────────────────────────────────────────────────

// class _SectionMeta {
//   static const Map<String, String> _labels = {
//     'salat': 'নামাজ',
//     'quran': 'কুরআন',
//     'dhikr': 'যিকর',
//     'fasting': 'রোজা',
//     'akhlaq': 'আখলাক',
//   };
//   static const Map<String, String> _emojis = {
//     'salat': '🕌',
//     'quran': '📖',
//     'dhikr': '📿',
//     'fasting': '🌙',
//     'akhlaq': '🤲',
//   };
//   static String label(String key) => _labels[key] ?? key;
//   static String emoji(String key) => _emojis[key] ?? '✨';
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
//     _year  = now.year;
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
//           _year  = y;
//           _month = m;
//         }),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final params        = (year: _year, month: _month);
//     final entriesAsync  = ref.watch(monthlyEntriesProvider(params));
//     final progressAsync = ref.watch(progressSummaryProvider(params));

//     final monthName      = AppConstants.bengaliMonths[_month - 1];
//     final now            = DateTime.now();
//     final isCurrentMonth = _year == now.year && _month == now.month;

//     return Scaffold(
//       backgroundColor: _C.pageBg,
//       body: RefreshIndicator(
//         color: _C.darkGreen,
//         onRefresh: () async {
//           ref.invalidate(monthlyEntriesProvider(params));
//           ref.invalidate(progressSummaryProvider(params));
//           ref.invalidate(categoriesProvider);
//         },
//         child: CustomScrollView(
//           controller: _sc,
//           physics: const AlwaysScrollableScrollPhysics(),
//           slivers: [
//             // ── App Bar ────────────────────────────────────────────────────
//             SliverAppBar(
//               pinned: true,
//               expandedHeight: 0,
//               toolbarHeight: 56,
//               backgroundColor: _C.darkGreen,
//               surfaceTintColor: Colors.transparent,
//               shadowColor: Colors.transparent,
//               automaticallyImplyLeading: false,
//               systemOverlayStyle: SystemUiOverlayStyle.light,
//               title: Row(children: [
//                 Container(
//                   width: 30, height: 30,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(
//                         color: Colors.white.withOpacity(0.15), width: 0.5),
//                   ),
//                   child: const Icon(Icons.calendar_month_outlined,
//                       color: Colors.white, size: 15),
//                 ),
//                 const SizedBox(width: 10),
//                 Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text('মাসিক রিপোর্ট',
//                           style: TextStyle(
//                               color: Colors.white.withOpacity(0.55),
//                               fontSize: 10,
//                               fontWeight: FontWeight.w500)),
//                       Text('$monthName $_year',
//                           style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w800,
//                               letterSpacing: -0.3,
//                               height: 1.1)),
//                     ]),
//               ]),
//               actions: [
//                 GestureDetector(
//                   onTap: _showPeriodPicker,
//                   child: Container(
//                     margin: const EdgeInsets.only(right: 16),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 11, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                           color: Colors.white.withOpacity(0.18), width: 0.5),
//                     ),
//                     child: Row(mainAxisSize: MainAxisSize.min, children: [
//                       Icon(Icons.swap_horiz_rounded,
//                           size: 13, color: Colors.white.withOpacity(0.7)),
//                       const SizedBox(width: 5),
//                       const Text('মাস বদলান',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 12)),
//                     ]),
//                   ),
//                 ),
//               ],
//             ),

//             // ── Hero Band ──────────────────────────────────────────────────
//             SliverToBoxAdapter(
//               child: progressAsync.when(
//                 loading: () => const _HeroBandSkeleton(),
//                 error: (_, __) => const _HeroBandSkeleton(),
//                 data: (p) => _HeroBand(
//                   year: _year,
//                   month: _month,
//                   tracker: p.currentMonth,
//                 ),
//               ),
//             ),

//             // ── Female Exempt Banner ───────────────────────────────────────
//             SliverToBoxAdapter(
//               child: progressAsync.whenOrNull(
//                 data: (p) {
//                   if (p.userGender != 'female') return const SizedBox.shrink();
//                   final n = p.currentMonth?.exemptDays ?? 0;
//                   if (n == 0) return const SizedBox.shrink();
//                   return _ExemptBanner(exemptCount: n);
//                 },
//               ),
//             ),

//             // ── Stat Strip ─────────────────────────────────────────────────
//             SliverToBoxAdapter(
//               child: progressAsync.when(
//                 loading: () => const _StatStripSkeleton(),
//                 error: (_, __) => const _StatStripSkeleton(),
//                 data: (p) => _StatStrip(
//                   tracker: p.currentMonth,
//                   userGender: p.userGender,
//                 ),
//               ),
//             ),

//             // ── Category Progress Explorer — যেকোনো আমল সার্চ করে real
//             //    per-category progress দেখার entry point (static bucket নেই)
//             const SliverToBoxAdapter(
//               child: _CategoryProgressExplorer(),
//             ),

//             // ── Fard Performance ───────────────────────────────────────────
//             SliverToBoxAdapter(
//               child: progressAsync.when(
//                 loading: () => const _SectionSkeleton(height: 120),
//                 error: (_, __) => const SizedBox.shrink(),
//                 data: (p) {
//                   if (p.currentMonth == null ||
//                       p.currentMonth!.eligibleDays == 0) {
//                     return const SizedBox.shrink();
//                   }
//                   return _FardSection(tracker: p.currentMonth!);
//                 },
//               ),
//             ),

//             // ── Category Breakdown (filter by section — API driven) ────────
//             SliverToBoxAdapter(
//               child: progressAsync.whenOrNull(
//                     data: (p) =>
//                         _CategoryBreakdownSection(tracker: p.currentMonth),
//                   ) ??
//                   const SizedBox.shrink(),
//             ),

//             // ── Weekly Chart (current month only) ──────────────────────────
//             if (isCurrentMonth)
//               SliverToBoxAdapter(
//                 child: progressAsync.when(
//                   loading: () => const _SectionSkeleton(height: 160),
//                   error: (_, __) => const SizedBox.shrink(),
//                   data: (p) => _WeeklyChartSection(
//                     weekData: p.currentWeekProgress,
//                     userGender: p.userGender,
//                   ),
//                 ),
//               ),

//             // ── Prayer Today Breakdown (current month only) ────────────────
//             if (isCurrentMonth)
//               SliverToBoxAdapter(
//                 child: progressAsync.when(
//                   loading: () => const _SectionSkeleton(height: 100),
//                   error: (_, __) => const SizedBox.shrink(),
//                   data: (p) {
//                     if (p.todayPrayerBreakdown.isEmpty) {
//                       return const SizedBox.shrink();
//                     }
//                     return _TodayPrayerSection(
//                         prayers: p.todayPrayerBreakdown);
//                   },
//                 ),
//               ),

//             // ── Previous Months Comparison (multi-metric, backend-driven) ──
//             SliverToBoxAdapter(
//               child: progressAsync.when(
//                 loading: () => const _SectionSkeleton(height: 140),
//                 error: (_, __) => const SizedBox.shrink(),
//                 data: (p) {
//                   final allMonths = p.recentMonths;
//                   if (allMonths.isEmpty) {
//                     return const _EmptyCard(label: 'মাসিক তুলনামূলক কোনো ডেটা নেই');
//                   }
//                   return _PrevMonthsSection(
//                       months: allMonths.reversed.toList());
//                 },
//               ),
//             ),

//             // ── Rank Card ──────────────────────────────────────────────────
//             SliverToBoxAdapter(
//               child: progressAsync.when(
//                 loading: () => const SizedBox.shrink(),
//                 error: (_, __) => const SizedBox.shrink(),
//                 data: (p) {
//                   if (p.currentMonth == null ||
//                       p.currentMonth!.rank == null) {
//                     return const SizedBox.shrink();
//                   }
//                   return _RankSection(tracker: p.currentMonth!);
//                 },
//               ),
//             ),

//             // ── Heatmap + Day List ─────────────────────────────────────────
//             SliverPadding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
//               sliver: entriesAsync.when(
//                 loading: () => const SliverToBoxAdapter(
//                     child: _EntriesSkeleton()),
//                 error: (_, __) => SliverToBoxAdapter(
//                     child: _ErrorCard(
//                         onRetry: () =>
//                             ref.invalidate(monthlyEntriesProvider(params)))),
//                 data: (entries) {
//                   final userGender =
//                       progressAsync.valueOrNull?.userGender ?? 'male';
//                   return SliverList(
//                     delegate: SliverChildListDelegate([
//                       const SizedBox(height: 15),
//                       _SectionHeader(title: 'দৈনিক ক্যালেন্ডার', emoji: '📅'),
//                       const SizedBox(height: 10),
//                       _HeatmapCalendar(
//                           year: _year,
//                           month: _month,
//                           entries: entries,
//                           userGender: userGender),
//                       const SizedBox(height: 22),
//                       _SectionHeader(
//                           title: 'দিন অনুযায়ী বিস্তারিত', emoji: '📋'),
//                       const SizedBox(height: 3),
//                       const Padding(
//                         padding: EdgeInsets.only(bottom: 8),
//                         child: Text('যেকোনো দিনে ট্যাপ করে বিস্তারিত দেখুন',
//                             style: TextStyle(
//                                 color: _C.textHint,
//                                 fontSize: 10.5,
//                                 fontWeight: FontWeight.w500)),
//                       ),
//                       if (entries.isEmpty)
//                         _EmptyCard(label: '$monthName মাসে কোনো আমল নেই')
//                       else
//                         Container(
//                           decoration: BoxDecoration(
//                             color: _C.cardBg,
//                             borderRadius: BorderRadius.circular(16),
//                             border:
//                                 Border.all(color: _C.border, width: 0.5),
//                           ),
//                           child: Column(
//                             children: List.generate(
//                               entries.length,
//                               (i) => _DayRow(
//                                 entry: entries[i],
//                                 isLast: i == entries.length - 1,
//                                 delay: 220 + i * 25,
//                                 userGender: userGender,
//                               ),
//                             ),
//                           ),
//                         ),
//                     ]),
//                   );
//                 },
//               ),
//             ),
//           ],
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

//   String _winnerLabel(String? cat) {
//     switch (cat) {
//       case 'TOP_FARZ':   return 'ফরজ চ্যাম্পিয়ন 🕌';
//       case 'TOP_JAMAAT': return 'জামাত চ্যাম্পিয়ন 🤝';
//       case 'TOP_QURAN':  return 'কুরআন চ্যাম্পিয়ন 📖';
//       case 'TOP_STREAK': return 'সেরা ধারাবাহিকতা 🔥';
//       default:           return 'মাসিক বিজয়ী 🏆';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pct          = (tracker?.completionPercentage ?? 0).clamp(0.0, 100.0);
//     final farzDays     = tracker?.farzCompletedDays ?? 0;
//     final eligibleDays = tracker?.eligibleDays ?? 0;
//     final jamaat       = tracker?.congregationDaysSum ?? 0;
//     final streak       = tracker?.streakDays ?? 0;
//     final isWinner     = tracker?.isWinner ?? false;
//     final rank         = tracker?.rank;

//     return Container(
//       color: _C.darkGreen,
//       child: Stack(children: [
//         Positioned(
//             top: -45, right: -40,
//             child: Container(
//                 width: 140, height: 140,
//                 decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Color(0x0AFFFFFF)))),
//         Positioned(
//             bottom: -25, left: 18,
//             child: Container(
//                 width: 88, height: 88,
//                 decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Color(0x07FFFFFF)))),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
//           child: Column(
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
//                     border: Border.all(
//                         color: const Color(0x2EFFFFFF), width: 0.5),
//                   ),
//                   child: Row(children: [
//                     _CircularProgress(percentage: pct, size: 66),
//                     const SizedBox(width: 14),
//                     Expanded(
//                         child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                           FittedBox(
//                             fit: BoxFit.scaleDown,
//                             alignment: Alignment.centerLeft,
//                             child: Text(
//                                 eligibleDays > 0
//                                     ? '$farzDays/$eligibleDays দিন'
//                                     : '$farzDays দিন',
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w900,
//                                     fontSize: 24,
//                                     letterSpacing: -0.5,
//                                     height: 1)),
//                           ),
//                           const SizedBox(height: 2),
//                           Text('সব ফরজ পূর্ণ',
//                               style: TextStyle(
//                                   color: Colors.white.withOpacity(0.45),
//                                   fontSize: 10)),
//                           const SizedBox(height: 7),
//                           Wrap(spacing: 6, runSpacing: 4, children: [
//                             _HeroChip(
//                                 icon: Icons.people_rounded,
//                                 label: '$jamaat জামাত'),
//                             _HeroChip(
//                                 icon: Icons.local_fire_department_rounded,
//                                 label: '$streak দিন ধারা'),
//                           ]),
//                           if (isWinner) ...[
//                             const SizedBox(height: 6),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 8, vertical: 3),
//                               decoration: BoxDecoration(
//                                   color: _C.gold,
//                                   borderRadius: BorderRadius.circular(20)),
//                               child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     const Text('🏆',
//                                         style: TextStyle(fontSize: 10)),
//                                     const SizedBox(width: 4),
//                                     Flexible(
//                                         child: Text(
//                                             _winnerLabel(
//                                                 tracker?.winnerCategory),
//                                             style: const TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 10,
//                                                 fontWeight: FontWeight.w700),
//                                             overflow: TextOverflow.ellipsis,
//                                             maxLines: 1)),
//                                   ]),
//                             ),
//                           ],
//                         ])),
//                     const SizedBox(width: 12),
//                     if (rank != null)
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 8),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.08),
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(
//                               color: Colors.white.withOpacity(0.15),
//                               width: 0.5),
//                         ),
//                         child: Column(children: [
//                           Text('র‍্যাংক',
//                               style: TextStyle(
//                                   color: Colors.white.withOpacity(0.45),
//                                   fontSize: 8.5)),
//                           Text('#$rank',
//                               style: const TextStyle(
//                                   color: _C.gold,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w900,
//                                   height: 1.1)),
//                         ]),
//                       ),
//                   ]),
//                 ),
//               ]),
//         ),
//       ]),
//     );
//   }
// }

// class _HeroChip extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   const _HeroChip({required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.12),
//           borderRadius: BorderRadius.circular(20)),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [
//         Icon(icon, color: Colors.white.withOpacity(0.7), size: 11),
//         const SizedBox(width: 4),
//         Text(label,
//             style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 10.5,
//                 fontWeight: FontWeight.w600)),
//       ]),
//     );
//   }
// }

// class _CircularProgress extends StatelessWidget {
//   final double percentage;
//   final double size;
//   const _CircularProgress({required this.percentage, required this.size});

//   @override
//   Widget build(BuildContext context) {
//     final str       = '${percentage.toInt()}%';
//     final innerSize = size * 0.80;

//     final Color barColor = percentage >= 80
//         ? _C.green
//         : percentage >= 50
//             ? _C.gold
//             : _C.amber;

//     return SizedBox(
//       width: size, height: size,
//       child: Stack(alignment: Alignment.center, children: [
//         SizedBox.expand(
//             child: CircularProgressIndicator(
//           value: percentage / 100,
//           backgroundColor: Colors.white.withOpacity(0.12),
//           valueColor: AlwaysStoppedAnimation(barColor),
//           strokeWidth: size * 0.09,
//           strokeCap: StrokeCap.round,
//         )),
//         Container(
//           width: innerSize, height: innerSize,
//           decoration: const BoxDecoration(
//               color: _C.darkGreen, shape: BoxShape.circle),
//           child: Center(
//               child: FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Padding(
//               padding: EdgeInsets.all(size * 0.05),
//               child: Column(mainAxisSize: MainAxisSize.min, children: [
//                 Text(str,
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w900,
//                         fontSize: size * 0.165,
//                         height: 1),
//                     textAlign: TextAlign.center),
//                 SizedBox(height: size * 0.02),
//                 Text('সম্পন্ন',
//                     style: TextStyle(
//                         color: Colors.white.withOpacity(0.45),
//                         fontSize: size * 0.12),
//                     textAlign: TextAlign.center),
//               ]),
//             ),
//           )),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // EXEMPT BANNER
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
//             width: 30, height: 30,
//             decoration: BoxDecoration(
//                 color: _C.purpleLight,
//                 borderRadius: BorderRadius.circular(8)),
//             child: const Center(
//                 child: Text('🌸', style: TextStyle(fontSize: 15)))),
//         const SizedBox(width: 10),
//         Expanded(
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//               const Text('মাহলির দিন চিহ্নিত',
//                   style: TextStyle(
//                       color: _C.purple,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w700)),
//               const SizedBox(height: 2),
//               Text(
//                   '$exemptCount দিন মাফ — নামাজ ও রোজার হিসাব বাদ দেওয়া হয়েছে',
//                   style: TextStyle(
//                       color: _C.purple.withOpacity(0.7),
//                       fontSize: 10,
//                       fontWeight: FontWeight.w500)),
//             ])),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // STAT STRIP
// // ─────────────────────────────────────────────────────────────────────────────

// class _StatStrip extends StatelessWidget {
//   final MonthlyTracker? tracker;
//   final String userGender;
//   const _StatStrip({this.tracker, required this.userGender});

//   @override
//   Widget build(BuildContext context) {
//     final streak       = tracker?.streakDays ?? 0;
//     final daysActive   = tracker?.daysActive ?? 0;
//     final farzDays     = tracker?.farzCompletedDays ?? 0;
//     final jamaat       = tracker?.congregationDaysSum ?? 0;
//     final eligible     = tracker?.eligibleDays ?? 0;
//     final exemptDays   = tracker?.exemptDays ?? 0;
//     final isFemale     = userGender == 'female';

//     return Column(children: [
//       Padding(
//         padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//         child: Row(children: [
//           Expanded(
//               child: _StatCard(
//                   emoji: '🔥',
//                   emojiBg: _C.amberLight,
//                   value: '$streak',
//                   label: 'স্ট্রিক দিন',
//                   valueColor: _C.amber)),
//           const SizedBox(width: 8),
//           Expanded(
//               child: _StatCard(
//                   emoji: '📅',
//                   emojiBg: _C.greenLight,
//                   value: '$daysActive',
//                   label: 'আমল করা দিন',
//                   valueColor: _C.green)),
//           const SizedBox(width: 8),
//           Expanded(
//               child: _StatCard(
//                   emoji: '✅',
//                   emojiBg: _C.greenLight,
//                   value: '$farzDays',
//                   label: 'পূর্ণ ফরজ দিন',
//                   valueColor: _C.darkGreen)),
//         ]),
//       ),
//       Padding(
//         padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
//         child: Row(children: [
//           Expanded(
//               child: _StatCard(
//                   emoji: '🕌',
//                   emojiBg: _C.purpleLight,
//                   value: '$jamaat',
//                   label: 'জামাত দিন',
//                   valueColor: _C.purple)),
//           const SizedBox(width: 8),
//           Expanded(
//               child: _StatCard(
//                   emoji: '⏳',
//                   emojiBg: _C.greenLight,
//                   value: '$eligible',
//                   label: 'হিসাবের দিন',
//                   valueColor: _C.green)),
//           const SizedBox(width: 8),
//           if (isFemale)
//             Expanded(
//                 child: _StatCard(
//                     emoji: '🌸',
//                     emojiBg: _C.purplePale,
//                     value: '$exemptDays',
//                     label: 'মাহলির দিন',
//                     valueColor: _C.purple))
//           else
//             Expanded(
//                 child: _StatCard(
//                     emoji: '🏅',
//                     emojiBg: _C.goldLight,
//                     value: tracker?.rank != null
//                         ? '#${tracker!.rank}'
//                         : '---',
//                     label: 'র‍্যাংক',
//                     valueColor: _C.gold)),
//         ]),
//       ),
//     ]);
//   }
// }

// class _StatCard extends StatelessWidget {
//   final String emoji, value, label;
//   final Color emojiBg, valueColor;
//   const _StatCard(
//       {required this.emoji,
//       required this.emojiBg,
//       required this.value,
//       required this.label,
//       required this.valueColor});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(11),
//       decoration: BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.circular(13),
//           border: Border.all(color: _C.border, width: 0.5)),
//       child:
//           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Container(
//             width: 28, height: 28,
//             decoration: BoxDecoration(
//                 color: emojiBg, borderRadius: BorderRadius.circular(7)),
//             child: Center(
//                 child: Text(emoji, style: const TextStyle(fontSize: 13)))),
//         const SizedBox(height: 7),
//         FittedBox(
//             fit: BoxFit.scaleDown,
//             alignment: Alignment.centerLeft,
//             child: Text(value,
//                 style: TextStyle(
//                     color: valueColor,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 19,
//                     letterSpacing: -0.4,
//                     height: 1))),
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
// // CATEGORY PROGRESS EXPLORER — entry point, কোনো static bucket নেই
// // user যেকোনো amol সার্চ করে তার real /category/:id/progress দেখতে পারবে
// // ─────────────────────────────────────────────────────────────────────────────

// class _CategoryProgressExplorer extends ConsumerWidget {
//   const _CategoryProgressExplorer();

//   void _openPicker(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       useSafeArea: true,
//       builder: (_) => const _CategoryPickerSheet(),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final catsAsync = ref.watch(categoriesProvider);
//     final totalCount = catsAsync.value?.length ?? 0;

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         _SectionHeader(title: 'যেকোনো আমলের অগ্রগতি', emoji: '🔍'),
//         const SizedBox(height: 10),
//         GestureDetector(
//           onTap: () => _openPicker(context),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             decoration: BoxDecoration(
//               color: _C.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: _C.border, width: 0.5),
//             ),
//             child: Row(children: [
//               Container(
//                 width: 38, height: 38,
//                 decoration: BoxDecoration(
//                   color: _C.greenLight,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(Icons.search_rounded,
//                     color: _C.darkGreen, size: 19),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text('যেকোনো আমল সার্চ করুন',
//                         style: TextStyle(
//                             color: _C.textPrimary,
//                             fontWeight: FontWeight.w700,
//                             fontSize: 13)),
//                     const SizedBox(height: 2),
//                     Text(
//                         totalCount > 0
//                             ? '$totalCount টি আমল থেকে বেছে নিন — all-time, মাসিক ট্রেন্ড, স্ট্রিক'
//                             : 'লোড হচ্ছে...',
//                         style: const TextStyle(
//                             color: _C.textHint,
//                             fontSize: 10.5,
//                             fontWeight: FontWeight.w500)),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.chevron_right_rounded,
//                   color: _C.textHint, size: 20),
//             ]),
//           ),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // CATEGORY PICKER SHEET — categoriesProvider থেকে সব category, live search
// // ─────────────────────────────────────────────────────────────────────────────

// class _CategoryPickerSheet extends ConsumerStatefulWidget {
//   const _CategoryPickerSheet();

//   @override
//   ConsumerState<_CategoryPickerSheet> createState() =>
//       _CategoryPickerSheetState();
// }

// class _CategoryPickerSheetState extends ConsumerState<_CategoryPickerSheet> {
//   final _searchCtrl = TextEditingController();
//   String _query = '';

//   @override
//   void dispose() {
//     _searchCtrl.dispose();
//     super.dispose();
//   }

//   void _openDetail(AmalCategory cat) {
//     Navigator.pop(context); // picker বন্ধ
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       useSafeArea: true,
//       builder: (_) => _CategoryProgressDetailSheet(category: cat),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final catsBySection = ref.watch(categoriesBySection);
//     final q = _query.trim().toLowerCase();

//     // filtered + grouped — কোনো static bucket নয়, categoriesProvider এর
//     // real section (salat/quran/dhikr/fasting/akhlaq) অনুযায়ী group
//     final sections = catsBySection.keys.toList();
//     final filteredMap = <String, List<AmalCategory>>{};
//     for (final s in sections) {
//       final list = catsBySection[s]!
//           .where((c) =>
//               q.isEmpty ||
//               c.nameBn.toLowerCase().contains(q) ||
//               c.nameEn.toLowerCase().contains(q))
//           .toList();
//       if (list.isNotEmpty) filteredMap[s] = list;
//     }

//     return DraggableScrollableSheet(
//       initialChildSize: 0.85,
//       minChildSize: 0.5,
//       maxChildSize: 0.95,
//       expand: false,
//       builder: (context, scrollController) => Container(
//         decoration: const BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//         ),
//         child: Column(children: [
//           const SizedBox(height: 12),
//           Container(
//               width: 40, height: 4,
//               decoration: BoxDecoration(
//                   color: _C.border, borderRadius: BorderRadius.circular(99))),
//           const SizedBox(height: 16),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(children: [
//               const Text('আমল বেছে নিন',
//                   style: TextStyle(
//                       color: _C.textPrimary,
//                       fontWeight: FontWeight.w800,
//                       fontSize: 16)),
//               const Spacer(),
//               GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   padding: const EdgeInsets.all(6),
//                   decoration: BoxDecoration(
//                       color: _C.pageBg, shape: BoxShape.circle),
//                   child: const Icon(Icons.close_rounded,
//                       size: 16, color: _C.textSecondary),
//                 ),
//               ),
//             ]),
//           ),
//           const SizedBox(height: 12),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: _C.pageBg,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: _C.border, width: 0.5),
//               ),
//               child: TextField(
//                 controller: _searchCtrl,
//                 autofocus: false,
//                 onChanged: (v) => setState(() => _query = v),
//                 style: const TextStyle(fontSize: 13.5, color: _C.textPrimary),
//                 decoration: InputDecoration(
//                   hintText: 'আমলের নাম লিখুন (যেমন: তাহাজ্জুদ, ইস্তিগফার...)',
//                   hintStyle: const TextStyle(
//                       color: _C.textHint,
//                       fontSize: 12.5,
//                       fontWeight: FontWeight.w500),
//                   prefixIcon: const Icon(Icons.search_rounded,
//                       size: 18, color: _C.textHint),
//                   suffixIcon: _query.isNotEmpty
//                       ? GestureDetector(
//                           onTap: () {
//                             _searchCtrl.clear();
//                             setState(() => _query = '');
//                           },
//                           child: const Icon(Icons.close_rounded,
//                               size: 16, color: _C.textHint),
//                         )
//                       : null,
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Expanded(
//             child: filteredMap.isEmpty
//                 ? const Center(
//                     child: Padding(
//                       padding: EdgeInsets.only(top: 40),
//                       child: Column(mainAxisSize: MainAxisSize.min, children: [
//                         Text('🔍', style: TextStyle(fontSize: 26)),
//                         SizedBox(height: 8),
//                         Text('কোনো আমল পাওয়া যায়নি',
//                             style: TextStyle(
//                                 color: _C.textHint, fontSize: 12.5)),
//                       ]),
//                     ),
//                   )
//                 : ListView(
//                     controller: scrollController,
//                     padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
//                     children: [
//                       for (final section in filteredMap.keys) ...[
//                         Padding(
//                           padding: const EdgeInsets.only(top: 14, bottom: 6),
//                           child: Row(children: [
//                             Text(_SectionMeta.emoji(section),
//                                 style: const TextStyle(fontSize: 12)),
//                             const SizedBox(width: 6),
//                             Text(_SectionMeta.label(section),
//                                 style: const TextStyle(
//                                     color: _C.textSecondary,
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: 11.5)),
//                           ]),
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: _C.pageBg,
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: Column(
//                             children: List.generate(
//                               filteredMap[section]!.length,
//                               (i) {
//                                 final cat = filteredMap[section]![i];
//                                 final isLast =
//                                     i == filteredMap[section]!.length - 1;
//                                 return InkWell(
//                                   onTap: () => _openDetail(cat),
//                                   borderRadius: BorderRadius.vertical(
//                                     top: i == 0
//                                         ? const Radius.circular(14)
//                                         : Radius.zero,
//                                     bottom: isLast
//                                         ? const Radius.circular(14)
//                                         : Radius.zero,
//                                   ),
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 12, vertical: 11),
//                                     decoration: BoxDecoration(
//                                       border: isLast
//                                           ? null
//                                           : const Border(
//                                               bottom: BorderSide(
//                                                   color: _C.border,
//                                                   width: 0.5)),
//                                     ),
//                                     child: Row(children: [
//                                       Text(cat.icon ?? '✨',
//                                           style: const TextStyle(fontSize: 16)),
//                                       const SizedBox(width: 10),
//                                       Expanded(
//                                         child: Text(cat.nameBn,
//                                             style: const TextStyle(
//                                                 color: _C.textPrimary,
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 12.5)),
//                                       ),
//                                       if (cat.isFard)
//                                         Container(
//                                           margin:
//                                               const EdgeInsets.only(right: 6),
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 6, vertical: 2),
//                                           decoration: BoxDecoration(
//                                               color: _C.purpleLight,
//                                               borderRadius:
//                                                   BorderRadius.circular(20)),
//                                           child: const Text('ফরজ',
//                                               style: TextStyle(
//                                                   color: _C.purple,
//                                                   fontSize: 8.5,
//                                                   fontWeight:
//                                                       FontWeight.w700)),
//                                         ),
//                                       const Icon(Icons.chevron_right_rounded,
//                                           size: 16, color: _C.textHint),
//                                     ]),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//           ),
//         ]),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // CATEGORY PROGRESS DETAIL SHEET
// // GET /tracker/category/:categoryId/progress?months=3 থেকে সরাসরি
// // all-time + monthly trend + weekly breakdown + streak — কোনো bucket নেই
// // ─────────────────────────────────────────────────────────────────────────────

// class _CategoryProgressDetailSheet extends ConsumerWidget {
//   final AmalCategory category;
//   const _CategoryProgressDetailSheet({required this.category});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final params = (categoryId: category.id, months: 3);
//     final progressAsync = ref.watch(categoryProgressProvider(params));

//     return DraggableScrollableSheet(
//       initialChildSize: 0.75,
//       minChildSize: 0.4,
//       maxChildSize: 0.95,
//       expand: false,
//       builder: (context, scrollController) => Container(
//         decoration: const BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//         ),
//         child: Column(children: [
//           const SizedBox(height: 12),
//           Container(
//               width: 40, height: 4,
//               decoration: BoxDecoration(
//                   color: _C.border, borderRadius: BorderRadius.circular(99))),
//           const SizedBox(height: 14),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(children: [
//               Container(
//                 width: 42, height: 42,
//                 decoration: BoxDecoration(
//                   color: _C.greenLight,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Center(
//                     child: Text(category.icon ?? '✨',
//                         style: const TextStyle(fontSize: 19))),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(category.nameBn,
//                         style: const TextStyle(
//                             color: _C.textPrimary,
//                             fontWeight: FontWeight.w800,
//                             fontSize: 15)),
//                     Text(_SectionMeta.label(category.section),
//                         style: const TextStyle(
//                             color: _C.textHint,
//                             fontSize: 10.5,
//                             fontWeight: FontWeight.w500)),
//                   ],
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   padding: const EdgeInsets.all(6),
//                   decoration: BoxDecoration(
//                       color: _C.pageBg, shape: BoxShape.circle),
//                   child: const Icon(Icons.close_rounded,
//                       size: 16, color: _C.textSecondary),
//                 ),
//               ),
//             ]),
//           ),
//           const SizedBox(height: 4),
//           Expanded(
//             child: progressAsync.when(
//               loading: () => const Center(
//                   child: Padding(
//                 padding: EdgeInsets.only(top: 40),
//                 child: CircularProgressIndicator(
//                     color: _C.darkGreen, strokeWidth: 2.4),
//               )),
//               error: (_, __) => const Center(
//                   child: Padding(
//                 padding: EdgeInsets.only(top: 40),
//                 child: Text('ডেটা লোড ব্যর্থ হয়েছে',
//                     style: TextStyle(color: _C.textHint, fontSize: 12.5)),
//               )),
//               data: (data) => _CategoryProgressContent(
//                   category: category,
//                   data: data,
//                   scrollController: scrollController),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }

// class _CategoryProgressContent extends StatelessWidget {
//   final AmalCategory category;
//   final Map<String, dynamic> data;
//   final ScrollController scrollController;
//   const _CategoryProgressContent(
//       {required this.category,
//       required this.data,
//       required this.scrollController});

//   @override
//   Widget build(BuildContext context) {
//     final isFardPrayer = category.isFard && category.isPrayer;
//     final isCounter = category.inputType == AmalInputType.counter ||
//         category.inputType == AmalInputType.duration;

//     final allTime = (data['allTime'] as Map?) ?? {};
//     final streak = (data['streak'] as num?)?.toInt() ?? 0;
//     final monthly = (data['monthlyBreakdown'] as List?) ?? [];
//     final weekly = (data['weeklyBreakdown'] as Map?) ?? {};
//     final curWeek = (weekly['currentWeek'] as List?) ?? [];
//     final prevWeek = (weekly['previousWeek'] as List?) ?? [];

//     final daysActive = (allTime['daysActive'] as num?)?.toInt() ?? 0;
//     final totalCount = (allTime['totalCount'] as num?)?.toInt() ?? 0;
//     final congregation = (allTime['congregation'] as num?)?.toInt() ?? 0;
//     final solo = (allTime['solo'] as num?)?.toInt() ?? 0;
//     final missed = (allTime['missed'] as num?)?.toInt() ?? 0;

//     return ListView(
//       controller: scrollController,
//       padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
//       children: [
//         // ── All-time summary cards ─────────────────────────────────────────
//         Row(children: [
//           Expanded(
//             child: _DetailStatCard(
//               emoji: '🔥',
//               value: '$streak',
//               label: 'বর্তমান স্ট্রিক',
//               color: _C.amber,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: _DetailStatCard(
//               emoji: '📅',
//               value: '$daysActive',
//               label: 'মোট সক্রিয় দিন',
//               color: _C.green,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: _DetailStatCard(
//               emoji: isFardPrayer ? '🕌' : (isCounter ? '🔢' : '✅'),
//               value: isFardPrayer
//                   ? '$congregation'
//                   : isCounter
//                       ? '$totalCount'
//                       : '$daysActive',
//               label: isFardPrayer
//                   ? 'জামাত দিন'
//                   : isCounter
//                       ? 'মোট ${category.unit ?? "সংখ্যা"}'
//                       : 'সম্পন্ন দিন',
//               color: _C.purple,
//             ),
//           ),
//         ]),

//         if (isFardPrayer) ...[
//           const SizedBox(height: 10),
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: _C.cardBg,
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(color: _C.border, width: 0.5),
//             ),
//             child: Row(children: [
//               _MiniBreakdown(
//                   label: 'জামাত', value: congregation, color: _C.purple),
//               const SizedBox(width: 8),
//               _MiniBreakdown(label: 'একাকী', value: solo, color: _C.green),
//               const SizedBox(width: 8),
//               _MiniBreakdown(label: 'মিস', value: missed, color: _C.red),
//             ]),
//           ),
//         ],

//         const SizedBox(height: 22),

//         // ── Monthly trend (from backend monthlyBreakdown — real data) ──────
//         if (monthly.isNotEmpty) ...[
//           const Text('গত কয়েক মাসের ট্রেন্ড',
//               style: TextStyle(
//                   color: _C.textPrimary,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 13.5)),
//           const SizedBox(height: 10),
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: _C.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: _C.border, width: 0.5),
//             ),
//             child: LayoutBuilder(builder: (ctx, constraints) {
//               const chartH = 90.0;
//               return SizedBox(
//                 height: chartH + 32,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: monthly.reversed.map<Widget>((m) {
//                     final rate = ((m['completionRate'] as num?)?.toInt() ?? 0)
//                         .clamp(0, 100);
//                     final year = m['year'];
//                     final month = (m['month'] as num).toInt();
//                     final now = DateTime.now();
//                     final isCurrent =
//                         year == now.year && month == now.month;
//                     final mName = AppConstants.bengaliMonths[month - 1];
//                     final mShort =
//                         mName.length > 3 ? mName.substring(0, 3) : mName;
//                     final fillH = rate > 0
//                         ? (rate / 100 * chartH).clamp(4.0, chartH)
//                         : 4.0;

//                     return Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 6),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text('$rate%',
//                                 style: TextStyle(
//                                     fontSize: 9,
//                                     color:
//                                         isCurrent ? _C.darkGreen : _C.textHint,
//                                     fontWeight: isCurrent
//                                         ? FontWeight.w800
//                                         : FontWeight.w500)),
//                             const SizedBox(height: 4),
//                             AnimatedContainer(
//                               duration: 400.ms,
//                               height: fillH,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 color: isCurrent
//                                     ? _C.darkGreen
//                                     : _C.midGreen.withOpacity(0.5),
//                                 borderRadius: const BorderRadius.vertical(
//                                     top: Radius.circular(6)),
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(mShort,
//                                 style: TextStyle(
//                                     fontSize: 9.5,
//                                     color: isCurrent
//                                         ? _C.darkGreen
//                                         : _C.textSecondary,
//                                     fontWeight: isCurrent
//                                         ? FontWeight.w800
//                                         : FontWeight.w500)),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               );
//             }),
//           ),
//           const SizedBox(height: 22),
//         ],

//         // ── Weekly comparison (real day-level value + mode) ─────────────────
//         if (curWeek.isNotEmpty) ...[
//           const Text('এই সপ্তাহ বনাম গত সপ্তাহ',
//               style: TextStyle(
//                   color: _C.textPrimary,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 13.5)),
//           const SizedBox(height: 10),
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: _C.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: _C.border, width: 0.5),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: List.generate(7, (i) {
//                 final cur = i < curWeek.length
//                     ? curWeek[i] as Map
//                     : {'value': 0, 'mode': null};
//                 final prev = i < prevWeek.length
//                     ? prevWeek[i] as Map
//                     : {'value': 0, 'mode': null};
//                 final curVal = (cur['value'] as num?)?.toInt() ?? 0;
//                 final prevVal = (prev['value'] as num?)?.toInt() ?? 0;
//                 final dateStr = cur['date']?.toString() ?? '';
//                 final d = DateTime.tryParse(dateStr);
//                 const dayLbls = ['র','সো','ম','বু','বৃ','শু','শ'];

//                 Color dotColor(int v, String? mode) {
//                   if (mode == 'congregation') return _C.purple;
//                   if (mode == 'solo') return _C.amber;
//                   if (mode == 'missed') return _C.border;
//                   return v > 0 ? _C.green : _C.border;
//                 }

//                 return Column(mainAxisSize: MainAxisSize.min, children: [
//                   Container(
//                     width: 9, height: 9,
//                     margin: const EdgeInsets.only(bottom: 4),
//                     decoration: BoxDecoration(
//                       color: dotColor(prevVal, prev['mode']?.toString())
//                           .withOpacity(0.4),
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   Container(
//                     width: 20, height: 20,
//                     decoration: BoxDecoration(
//                       color: dotColor(curVal, cur['mode']?.toString()),
//                       shape: BoxShape.circle,
//                     ),
//                     child: curVal > 0 && isCounter
//                         ? Center(
//                             child: Text('$curVal',
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 8,
//                                     fontWeight: FontWeight.w800)))
//                         : null,
//                   ),
//                   const SizedBox(height: 5),
//                   Text(d != null ? dayLbls[d.weekday % 7] : '-',
//                       style: const TextStyle(
//                           color: _C.textHint,
//                           fontSize: 9,
//                           fontWeight: FontWeight.w500)),
//                 ]);
//               }),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Row(children: [
//             _LegendDot(color: _C.green, label: 'এই সপ্তাহ'),
//             const SizedBox(width: 12),
//             Row(mainAxisSize: MainAxisSize.min, children: [
//               Container(
//                   width: 9, height: 9,
//                   decoration: BoxDecoration(
//                       color: _C.green.withOpacity(0.4),
//                       shape: BoxShape.circle)),
//               const SizedBox(width: 4),
//               const Text('গত সপ্তাহ',
//                   style: TextStyle(color: _C.textHint, fontSize: 9.5)),
//             ]),
//           ]),
//         ],

//         if (monthly.isEmpty && curWeek.isEmpty)
//           const Padding(
//             padding: EdgeInsets.only(top: 30),
//             child: Center(
//               child: Text('এই আমলের জন্য এখনো কোনো ডেটা নেই',
//                   style: TextStyle(color: _C.textHint, fontSize: 12.5)),
//             ),
//           ),
//       ],
//     );
//   }
// }

// class _DetailStatCard extends StatelessWidget {
//   final String emoji, value, label;
//   final Color color;
//   const _DetailStatCard(
//       {required this.emoji,
//       required this.value,
//       required this.label,
//       required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//       decoration: BoxDecoration(
//         color: _C.cardBg,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       child: Column(children: [
//         Text(emoji, style: const TextStyle(fontSize: 16)),
//         const SizedBox(height: 6),
//         FittedBox(
//           child: Text(value,
//               style: TextStyle(
//                   color: color, fontWeight: FontWeight.w800, fontSize: 17)),
//         ),
//         const SizedBox(height: 2),
//         Text(label,
//             textAlign: TextAlign.center,
//             style: const TextStyle(color: _C.textHint, fontSize: 8.5)),
//       ]),
//     );
//   }
// }

// class _MiniBreakdown extends StatelessWidget {
//   final String label;
//   final int value;
//   final Color color;
//   const _MiniBreakdown(
//       {required this.label, required this.value, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Column(children: [
//         Text('$value',
//             style: TextStyle(
//                 color: color, fontWeight: FontWeight.w800, fontSize: 16)),
//         const SizedBox(height: 2),
//         Text(label,
//             style: const TextStyle(color: _C.textHint, fontSize: 9.5)),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // FARD PERFORMANCE
// // ─────────────────────────────────────────────────────────────────────────────

// class _FardSection extends StatelessWidget {
//   final MonthlyTracker tracker;
//   const _FardSection({required this.tracker});

//   @override
//   Widget build(BuildContext context) {
//     final pct      = tracker.completionPercentage.clamp(0.0, 100.0);
//     final farzDays = tracker.farzCompletedDays;
//     final eligible = tracker.eligibleDays;
//     final jamaat   = tracker.congregationDaysSum;

//     Color statusColor() {
//       if (pct >= 90) return _C.green;
//       if (pct >= 70) return _C.amber;
//       return _C.red;
//     }

//     String statusLabel() {
//       if (pct >= 90) return 'চমৎকার';
//       if (pct >= 70) return 'ভালো';
//       if (pct >= 50) return 'মাঝামাঝি';
//       return 'উন্নতি দরকার';
//     }

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         _SectionHeader(title: 'ফরজ পারফরম্যান্স', emoji: '🕌'),
//         const SizedBox(height: 10),
//         Row(children: [
//           Expanded(
//               child: _FardCard(
//             title: 'পূর্ণ ফরজ দিন',
//             bigValue: '${pct.toInt()}%',
//             subValue: '$farzDays/$eligible দিন',
//             badgeLabel: statusLabel(),
//             badgeColor: statusColor(),
//             barValue: pct / 100,
//             barColor: statusColor(),
//           )),
//           const SizedBox(width: 10),
//           Expanded(
//               child: _FardCard(
//             title: 'মোট জামাত',
//             bigValue: '$jamaat',
//             subValue: '৫ ওয়াক্ত × দিন মিলিয়ে',
//             badgeLabel: jamaat > 0 ? 'জামাতে পড়া হয়েছে' : 'কোনো জামাত নেই',
//             badgeColor: jamaat > 0 ? _C.purple : _C.textHint,
//             barValue: eligible > 0
//                 ? (jamaat / (eligible * 5)).clamp(0.0, 1.0)
//                 : 0,
//             barColor: _C.purple,
//           )),
//         ]),
//       ]),
//     );
//   }
// }

// class _FardCard extends StatelessWidget {
//   final String title, bigValue, subValue, badgeLabel;
//   final Color badgeColor, barColor;
//   final double barValue;
//   const _FardCard(
//       {required this.title,
//       required this.bigValue,
//       required this.subValue,
//       required this.badgeLabel,
//       required this.badgeColor,
//       required this.barColor,
//       required this.barValue});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: _C.border, width: 0.5)),
//       child:
//           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//           Expanded(
//               child: Text(title,
//                   style: const TextStyle(
//                       color: _C.textPrimary,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w700))),
//           Container(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//             decoration: BoxDecoration(
//                 color: badgeColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(20)),
//             child: Text(badgeLabel,
//                 style: TextStyle(
//                     color: badgeColor,
//                     fontSize: 8.5,
//                     fontWeight: FontWeight.w700)),
//           ),
//         ]),
//         const SizedBox(height: 8),
//         FittedBox(
//             fit: BoxFit.scaleDown,
//             alignment: Alignment.centerLeft,
//             child: Text(bigValue,
//                 style: TextStyle(
//                     color: badgeColor,
//                     fontSize: 22,
//                     fontWeight: FontWeight.w900,
//                     height: 1))),
//         const SizedBox(height: 2),
//         Text(subValue,
//             style: const TextStyle(color: _C.textHint, fontSize: 9.5)),
//         const SizedBox(height: 8),
//         ClipRRect(
//             borderRadius: BorderRadius.circular(99),
//             child: LinearProgressIndicator(
//                 value: barValue.clamp(0.0, 1.0),
//                 minHeight: 5,
//                 backgroundColor: _C.pageBg,
//                 valueColor: AlwaysStoppedAnimation(barColor))),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // CATEGORY BREAKDOWN — categoryStats + categories API → filter by section
// // প্রতিটা row ট্যাপ করলে সরাসরি real category progress detail sheet খোলে
// // ─────────────────────────────────────────────────────────────────────────────

// class _CategoryBreakdownSection extends ConsumerStatefulWidget {
//   final MonthlyTracker? tracker;
//   const _CategoryBreakdownSection({required this.tracker});

//   @override
//   ConsumerState<_CategoryBreakdownSection> createState() =>
//       _CategoryBreakdownSectionState();
// }

// class _CategoryBreakdownSectionState
//     extends ConsumerState<_CategoryBreakdownSection> {
//   String _selectedSection = 'all';

//   void _openDetail(AmalCategory cat) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       useSafeArea: true,
//       builder: (_) => _CategoryProgressDetailSheet(category: cat),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final catsBySectionAsync = ref.watch(categoriesProvider);
//     final catsBySection = ref.watch(categoriesBySection);
//     final tracker = widget.tracker;

//     return catsBySectionAsync.when(
//       loading: () => const Padding(
//         padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
//         child: _SectionSkeleton(height: 160),
//       ),
//       error: (_, __) => const SizedBox.shrink(),
//       data: (_) {
//         if (catsBySection.isEmpty || tracker == null) {
//           return const SizedBox.shrink();
//         }

//         final stats       = tracker.categoryStats;
//         final daysElapsed = tracker.eligibleDays + tracker.exemptDays;
//         final sections    = catsBySection.keys.toList();
//         final visible = _selectedSection == 'all'
//             ? sections
//             : [_selectedSection];

//         return Padding(
//           padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//             _SectionHeader(title: 'আমল অনুযায়ী বিস্তারিত', emoji: '🗂️'),
//             const SizedBox(height: 10),
//             SizedBox(
//               height: 34,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 children: [
//                   _FilterChip(
//                     label: 'সব',
//                     emoji: '✨',
//                     selected: _selectedSection == 'all',
//                     onTap: () => setState(() => _selectedSection = 'all'),
//                   ),
//                   ...sections.map((s) => Padding(
//                         padding: const EdgeInsets.only(left: 6),
//                         child: _FilterChip(
//                           label: _SectionMeta.label(s),
//                           emoji: _SectionMeta.emoji(s),
//                           selected: _selectedSection == s,
//                           onTap: () => setState(() => _selectedSection = s),
//                         ),
//                       )),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10),
//             Container(
//               decoration: BoxDecoration(
//                 color: _C.cardBg,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: _C.border, width: 0.5),
//               ),
//               child: Column(children: [
//                 for (final section in visible)
//                   ...List.generate(catsBySection[section]!.length, (i) {
//                     final cat  = catsBySection[section]![i];
//                     final stat = stats[cat.id] ?? CategoryStat.empty;
//                     final isLastInSection =
//                         i == catsBySection[section]!.length - 1;
//                     final isLastOverall =
//                         section == visible.last && isLastInSection;
//                     return InkWell(
//                       onTap: () => _openDetail(cat),
//                       borderRadius: BorderRadius.vertical(
//                         bottom: isLastOverall
//                             ? const Radius.circular(16)
//                             : Radius.zero,
//                       ),
//                       child: _CategoryStatRow(
//                         category: cat,
//                         stat: stat,
//                         daysElapsed: daysElapsed,
//                         eligibleDays: tracker.eligibleDays,
//                         isLast: isLastOverall,
//                       ),
//                     );
//                   }),
//               ]),
//             ),
//           ]),
//         );
//       },
//     );
//   }
// }

// class _FilterChip extends StatelessWidget {
//   final String label, emoji;
//   final bool selected;
//   final VoidCallback onTap;
//   const _FilterChip(
//       {required this.label,
//       required this.emoji,
//       required this.selected,
//       required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 150),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
//         decoration: BoxDecoration(
//           color: selected ? _C.darkGreen : _C.cardBg,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//               color: selected ? _C.darkGreen : _C.border, width: 0.8),
//         ),
//         child: Row(mainAxisSize: MainAxisSize.min, children: [
//           Text(emoji, style: const TextStyle(fontSize: 11)),
//           const SizedBox(width: 5),
//           Text(label,
//               style: TextStyle(
//                   color: selected ? Colors.white : _C.textSecondary,
//                   fontSize: 11.5,
//                   fontWeight: FontWeight.w700)),
//         ]),
//       ),
//     );
//   }
// }

// class _CategoryStatRow extends StatelessWidget {
//   final AmalCategory category;
//   final CategoryStat stat;
//   final int daysElapsed;
//   final int eligibleDays;
//   final bool isLast;
//   const _CategoryStatRow({
//     required this.category,
//     required this.stat,
//     required this.daysElapsed,
//     required this.eligibleDays,
//     required this.isLast,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isFardPrayer = category.isFard && category.isPrayer;
//     final isCounter = category.inputType == AmalInputType.counter ||
//         category.inputType == AmalInputType.duration;

//     String valueText;
//     String subText;
//     double rate;
//     Color barColor;

//     if (isFardPrayer) {
//       final total = stat.congregationDays + stat.soloDays;
//       final denom = eligibleDays > 0 ? eligibleDays : 1;
//       valueText = '$total/$denom';
//       subText =
//           'জামাত ${stat.congregationDays} · একা ${stat.soloDays} · মিস ${stat.missedDays}';
//       rate = (total / denom).clamp(0.0, 1.0);
//       barColor = stat.congregationDays >= stat.soloDays ? _C.purple : _C.green;
//     } else if (isCounter) {
//       valueText = '${stat.totalCount}${category.unit != null ? " ${category.unit}" : ""}';
//       subText = '${stat.daysActive} দিন সক্রিয়';
//       rate = daysElapsed > 0 ? (stat.daysActive / daysElapsed).clamp(0.0, 1.0) : 0;
//       barColor = _C.green;
//     } else {
//       valueText = '${stat.daysActive} দিন';
//       subText = daysElapsed > 0
//           ? '${((stat.daysActive / daysElapsed) * 100).toInt()}% মাস জুড়ে'
//           : 'কোনো ডেটা নেই';
//       rate = daysElapsed > 0 ? (stat.daysActive / daysElapsed).clamp(0.0, 1.0) : 0;
//       barColor = _C.amber;
//     }

//     final hasAny = stat.daysActive > 0 ||
//         stat.totalCount > 0 ||
//         stat.congregationDays > 0 ||
//         stat.soloDays > 0;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
//       decoration: BoxDecoration(
//         border: isLast
//             ? null
//             : const Border(bottom: BorderSide(color: _C.border, width: 0.5)),
//       ),
//       child: Row(children: [
//         Container(
//           width: 34, height: 34,
//           decoration: BoxDecoration(
//             color: hasAny ? barColor.withOpacity(0.1) : _C.pageBg,
//             borderRadius: BorderRadius.circular(9),
//           ),
//           child: Center(
//             child: Text(category.icon ?? _SectionMeta.emoji(category.section),
//                 style: const TextStyle(fontSize: 15)),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text(category.nameBn,
//                 style: const TextStyle(
//                     color: _C.textPrimary,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 12.5)),
//             const SizedBox(height: 2),
//             Text(subText,
//                 style: const TextStyle(color: _C.textHint, fontSize: 9.5)),
//             const SizedBox(height: 5),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(99),
//               child: LinearProgressIndicator(
//                 value: rate,
//                 minHeight: 4,
//                 backgroundColor: _C.pageBg,
//                 valueColor: AlwaysStoppedAnimation(hasAny ? barColor : _C.border),
//               ),
//             ),
//           ]),
//         ),
//         const SizedBox(width: 10),
//         Text(valueText,
//             style: TextStyle(
//                 color: hasAny ? _C.textPrimary : _C.textHint,
//                 fontWeight: FontWeight.w800,
//                 fontSize: 13)),
//         const SizedBox(width: 4),
//         const Icon(Icons.chevron_right_rounded, size: 15, color: _C.textHint),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // WEEKLY CHART
// // ─────────────────────────────────────────────────────────────────────────────

// class _WeeklyChartSection extends StatelessWidget {
//   final List<WeeklyDayProgress> weekData;
//   final String userGender;
//   const _WeeklyChartSection(
//       {required this.weekData, required this.userGender});

//   @override
//   Widget build(BuildContext context) {
//     if (weekData.isEmpty) return const SizedBox.shrink();

//     final isFemale   = userGender == 'female';
//     final today      = DateTime.now();
//     final activeDays = weekData.where((d) => d.hasActivity).length;
//     final exemptCnt  = weekData.where((d) => d.isExemptDay).length;

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         _SectionHeader(title: 'এই সপ্তাহের অগ্রগতি', emoji: '📊'),
//         const SizedBox(height: 10),
//         Container(
//           padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
//           decoration: BoxDecoration(
//               color: _C.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: _C.border, width: 0.5)),
//           child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 LayoutBuilder(builder: (ctx, constraints) {
//                   final chartH =
//                       (constraints.maxWidth * 0.36).clamp(80.0, 140.0);
//                   const dayLblH = 14.0;
//                   const gapH    = 8.0;
//                   final barAreaH =
//                       (chartH - dayLblH - gapH).clamp(20.0, chartH);

//                   return SizedBox(
//                     height: chartH,
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: weekData.map((d) {
//                         final dayDate = DateTime.tryParse(d.date);
//                         final isToday = dayDate != null &&
//                             dayDate.year == today.year &&
//                             dayDate.month == today.month &&
//                             dayDate.day == today.day;
//                         final showExempt = d.isExemptDay && isFemale;

//                         Color barColor;
//                         double barH;
//                         if (showExempt) {
//                           barColor = _C.purple;
//                           barH = barAreaH * 0.5;
//                         } else if (d.hasActivity) {
//                           barColor = isToday ? _C.darkGreen : _C.green;
//                           barH = barAreaH;
//                         } else {
//                           barColor = _C.border;
//                           barH = barAreaH * 0.12;
//                         }

//                         return Expanded(
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 3),
//                             child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   if (d.hasActivity && !showExempt)
//                                     Container(
//                                       width: 5, height: 5,
//                                       margin:
//                                           const EdgeInsets.only(bottom: 3),
//                                       decoration: BoxDecoration(
//                                           color: isToday
//                                               ? _C.darkGreen
//                                               : _C.green,
//                                           shape: BoxShape.circle),
//                                     )
//                                   else
//                                     const SizedBox(height: 8),
//                                   if (showExempt)
//                                     Container(
//                                       height: barH,
//                                       decoration: BoxDecoration(
//                                         color: _C.purpleLight,
//                                         borderRadius:
//                                             BorderRadius.circular(4),
//                                         border: Border.all(
//                                             color: _C.purple.withOpacity(0.3),
//                                             width: 0.5),
//                                       ),
//                                       child: const Center(
//                                           child: Text('🌸',
//                                               style:
//                                                   TextStyle(fontSize: 8))),
//                                     )
//                                   else
//                                     AnimatedContainer(
//                                       duration: 400.ms,
//                                       height: barH,
//                                       decoration: BoxDecoration(
//                                         color: barColor,
//                                         borderRadius: const BorderRadius
//                                             .vertical(
//                                             top: Radius.circular(4)),
//                                       ),
//                                     ),
//                                   const SizedBox(height: 5),
//                                   SizedBox(
//                                       height: dayLblH,
//                                       child: FittedBox(
//                                           fit: BoxFit.scaleDown,
//                                           child: Text(d.day,
//                                               style: TextStyle(
//                                                   fontSize: 9,
//                                                   color: isToday
//                                                       ? _C.darkGreen
//                                                       : _C.textSecondary,
//                                                   fontWeight: isToday
//                                                       ? FontWeight.w800
//                                                       : FontWeight.w500)))),
//                                 ]),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   );
//                 }),
//                 const SizedBox(height: 10),
//                 const Divider(height: 1, thickness: 0.5, color: _C.border),
//                 const SizedBox(height: 10),
//                 Row(children: [
//                   _WeekChip(
//                       label: 'সক্রিয় দিন',
//                       value: '$activeDays/7',
//                       color: _C.green),
//                   const SizedBox(width: 8),
//                   _WeekChip(
//                       label: 'বাকি দিন',
//                       value: '${7 - activeDays - exemptCnt}',
//                       color: _C.textSecondary),
//                   if (isFemale && exemptCnt > 0) ...[
//                     const SizedBox(width: 8),
//                     _WeekChip(
//                         label: 'মাহলি',
//                         value: '$exemptCnt',
//                         color: _C.purple),
//                   ],
//                 ]),
//                 const SizedBox(height: 10),
//                 Wrap(spacing: 12, runSpacing: 4, children: [
//                   _LegendDot(color: _C.green, label: 'আমল করা হয়েছে'),
//                   _LegendDot(color: _C.border, label: 'কোনো আমল নেই'),
//                   if (isFemale)
//                     _LegendDot(color: _C.purpleLight, label: 'মাহলির দিন'),
//                 ]),
//               ]),
//         ),
//       ]),
//     );
//   }
// }

// class _WeekChip extends StatelessWidget {
//   final String label, value;
//   final Color color;
//   const _WeekChip(
//       {required this.label, required this.value, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
//         decoration: BoxDecoration(
//             color: _C.pageBg, borderRadius: BorderRadius.circular(8)),
//         child: Column(children: [
//           FittedBox(
//               fit: BoxFit.scaleDown,
//               child: Text(value,
//                   style: TextStyle(
//                       color: color,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w800,
//                       height: 1))),
//           const SizedBox(height: 2),
//           FittedBox(
//               fit: BoxFit.scaleDown,
//               child: Text(label,
//                   style:
//                       const TextStyle(color: _C.textHint, fontSize: 8.5),
//                   textAlign: TextAlign.center)),
//         ]),
//       ),
//     );
//   }
// }

// class _LegendDot extends StatelessWidget {
//   final Color color;
//   final String label;
//   const _LegendDot({required this.color, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Row(mainAxisSize: MainAxisSize.min, children: [
//       Container(
//           width: 9, height: 9,
//           decoration: BoxDecoration(
//               color: color, borderRadius: BorderRadius.circular(2))),
//       const SizedBox(width: 4),
//       Text(label,
//           style: const TextStyle(color: _C.textHint, fontSize: 9.5)),
//     ]);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // TODAY PRAYER BREAKDOWN
// // ─────────────────────────────────────────────────────────────────────────────

// class _TodayPrayerSection extends StatelessWidget {
//   final List<PrayerBreakdownItem> prayers;
//   const _TodayPrayerSection({required this.prayers});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         _SectionHeader(title: 'আজকের নামাজের অবস্থা', emoji: '🕌'),
//         const SizedBox(height: 10),
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//               color: _C.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: _C.border, width: 0.5)),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: prayers.map((p) {
//               Color color;
//               IconData icon;
//               String label;

//               if (p.mode == null) {
//                 color = _C.textHint;
//                 icon  = Icons.radio_button_unchecked_rounded;
//                 label = 'বাকি';
//               } else if (p.mode == PrayerMode.congregation) {
//                 color = _C.green;
//                 icon  = Icons.people_rounded;
//                 label = 'জামাত';
//               } else if (p.mode == PrayerMode.solo) {
//                 color = _C.amber;
//                 icon  = Icons.person_rounded;
//                 label = 'একাকী';
//               } else {
//                 color = _C.red;
//                 icon  = Icons.close_rounded;
//                 label = 'মিস';
//               }

//               return Column(mainAxisSize: MainAxisSize.min, children: [
//                 Container(
//                   width: 40, height: 40,
//                   decoration: BoxDecoration(
//                       color: color.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                           color: color.withOpacity(0.3), width: 0.5)),
//                   child: Icon(icon, color: color, size: 20),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(p.nameBn,
//                     style: const TextStyle(
//                         color: _C.textPrimary,
//                         fontSize: 9.5,
//                         fontWeight: FontWeight.w700)),
//                 const SizedBox(height: 2),
//                 Text(label,
//                     style: TextStyle(
//                         color: color,
//                         fontSize: 8.5,
//                         fontWeight: FontWeight.w600)),
//               ]);
//             }).toList(),
//           ),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // COMPARE METRIC — recentMonths (backend) থেকে multi-metric compare
// // ─────────────────────────────────────────────────────────────────────────────

// enum _CompareMetric { completion, farz, congregation, quran, dhikr, fasting, akhlaq, streak }

// extension _CompareMetricX on _CompareMetric {
//   String get labelBn {
//     switch (this) {
//       case _CompareMetric.completion:   return 'সম্পন্ন %';
//       case _CompareMetric.farz:         return 'পূর্ণ ফরজ দিন';
//       case _CompareMetric.congregation: return 'জামাত দিন';
//       case _CompareMetric.quran:        return 'কুরআন আয়াত';
//       case _CompareMetric.dhikr:        return 'যিকর স্কোর';
//       case _CompareMetric.fasting:      return 'নফল রোজা';
//       case _CompareMetric.akhlaq:       return 'আখলাক দিন';
//       case _CompareMetric.streak:       return 'স্ট্রিক দিন';
//     }
//   }

//   String get emoji {
//     switch (this) {
//       case _CompareMetric.completion:   return '✅';
//       case _CompareMetric.farz:         return '🕌';
//       case _CompareMetric.congregation: return '🤝';
//       case _CompareMetric.quran:        return '📖';
//       case _CompareMetric.dhikr:        return '📿';
//       case _CompareMetric.fasting:      return '🌙';
//       case _CompareMetric.akhlaq:       return '🤲';
//       case _CompareMetric.streak:       return '🔥';
//     }
//   }

//   double valueOf(MonthlyTracker t) {
//     switch (this) {
//       case _CompareMetric.completion:   return t.completionPercentage;
//       case _CompareMetric.farz:         return t.farzCompletedDays.toDouble();
//       case _CompareMetric.congregation: return t.congregationDaysSum.toDouble();
//       case _CompareMetric.quran:        return t.quranAyahTotal.toDouble();
//       case _CompareMetric.dhikr:        return t.dhikrScore.toDouble();
//       case _CompareMetric.fasting:      return t.fastingDays.toDouble();
//       case _CompareMetric.akhlaq:       return t.akhlaqDays.toDouble();
//       case _CompareMetric.streak:       return t.streakDays.toDouble();
//     }
//   }

//   String display(MonthlyTracker t) =>
//       this == _CompareMetric.completion ? '${valueOf(t).toInt()}%' : '${valueOf(t).toInt()}';
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PREVIOUS MONTHS — metric selector + bar chart + trend line
// // ─────────────────────────────────────────────────────────────────────────────

// class _PrevMonthsSection extends StatefulWidget {
//   final List<MonthlyTracker> months;
//   const _PrevMonthsSection({required this.months});

//   @override
//   State<_PrevMonthsSection> createState() => _PrevMonthsSectionState();
// }

// class _PrevMonthsSectionState extends State<_PrevMonthsSection> {
//   _CompareMetric _metric = _CompareMetric.completion;

//   @override
//   Widget build(BuildContext context) {
//     final months = widget.months;
//     if (months.isEmpty) return const SizedBox.shrink();
//     final current = months.last;

//     final maxVal = months
//         .map((m) => _metric.valueOf(m))
//         .fold<double>(0, (a, b) => b > a ? b : a);
//     final safeMax = maxVal <= 0 ? 1.0 : maxVal;

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         _SectionHeader(title: 'মাসিক তুলনা', emoji: '📈'),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: 34,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             children: _CompareMetric.values
//                 .map((m) => Padding(
//                       padding: const EdgeInsets.only(right: 6),
//                       child: _FilterChip(
//                         label: m.labelBn,
//                         emoji: m.emoji,
//                         selected: _metric == m,
//                         onTap: () => setState(() => _metric = m),
//                       ),
//                     ))
//                 .toList(),
//           ),
//         ),
//         const SizedBox(height: 10),
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//               color: _C.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: _C.border, width: 0.5)),
//           child: Column(children: [
//             LayoutBuilder(builder: (ctx, constraints) {
//               final chartH  = (constraints.maxWidth * 0.36).clamp(90.0, 150.0);
//               const valLblH = 14.0;
//               const mthLblH = 12.0;
//               const gapH    = 8.0;
//               final barAreaH =
//                   (chartH - valLblH - mthLblH - gapH).clamp(16.0, chartH);

//               return SizedBox(
//                 height: chartH,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: months.map((m) {
//                     final isActive =
//                         m.year == current.year && m.month == current.month;
//                     final val   = _metric.valueOf(m);
//                     final fillH = val > 0
//                         ? ((val / safeMax) * barAreaH).clamp(4.0, barAreaH)
//                         : 4.0;
//                     final mName  = AppConstants.bengaliMonths[m.month - 1];
//                     final mShort = mName.length > 3 ? mName.substring(0, 3) : mName;

//                     return Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 5),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             SizedBox(
//                               height: valLblH,
//                               child: FittedBox(
//                                 fit: BoxFit.scaleDown,
//                                 child: Text(_metric.display(m),
//                                     style: TextStyle(
//                                         fontSize: 9,
//                                         color: isActive ? _C.darkGreen : _C.textHint,
//                                         fontWeight: isActive
//                                             ? FontWeight.w800
//                                             : FontWeight.w500)),
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             AnimatedContainer(
//                               duration: 400.ms,
//                               height: fillH,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 color: val > 0
//                                     ? (isActive ? _C.darkGreen : _C.midGreen.withOpacity(0.5))
//                                     : _C.pageBg,
//                                 borderRadius:
//                                     const BorderRadius.vertical(top: Radius.circular(6)),
//                                 border: val > 0
//                                     ? null
//                                     : Border.all(color: _C.border, width: 0.5),
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             SizedBox(
//                               height: mthLblH,
//                               child: FittedBox(
//                                 fit: BoxFit.scaleDown,
//                                 child: Text(mShort,
//                                     style: TextStyle(
//                                         fontSize: 9,
//                                         color: isActive ? _C.darkGreen : _C.textSecondary,
//                                         fontWeight: isActive
//                                             ? FontWeight.w800
//                                             : FontWeight.w500)),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               );
//             }),
//             if (months.length >= 2) ...[
//               const SizedBox(height: 12),
//               const Divider(height: 1, thickness: 0.5, color: _C.border),
//               const SizedBox(height: 10),
//               _TrendLine(months: months, metric: _metric),
//             ],
//           ]),
//         ),
//       ]),
//     );
//   }
// }

// class _TrendLine extends StatelessWidget {
//   final List<MonthlyTracker> months;
//   final _CompareMetric metric;
//   const _TrendLine({required this.months, required this.metric});

//   @override
//   Widget build(BuildContext context) {
//     final current  = months.last;
//     final prev     = months[months.length - 2];
//     final curVal   = metric.valueOf(current);
//     final prevVal  = metric.valueOf(prev);
//     final diff     = curVal - prevVal;
//     final isUp     = diff > 0;
//     final isSame   = diff == 0;

//     return Row(children: [
//       Icon(
//         isSame
//             ? Icons.remove_rounded
//             : (isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded),
//         size: 16,
//         color: isSame ? _C.textHint : (isUp ? _C.green : _C.red),
//       ),
//       const SizedBox(width: 6),
//       Expanded(
//         child: Text(
//           isSame
//               ? 'গত মাসের সমান'
//               : '${metric.labelBn} গত মাসের তুলনায় ${isUp ? "বেড়েছে" : "কমেছে"} ${diff.abs().toInt()}${metric == _CompareMetric.completion ? "%" : ""}',
//           style: TextStyle(
//               color: isSame ? _C.textHint : (isUp ? _C.green : _C.red),
//               fontSize: 11,
//               fontWeight: FontWeight.w600),
//         ),
//       ),
//     ]);
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
//     final rank     = tracker.rank!;
//     final pct      = tracker.completionPercentage.clamp(0.0, 100.0);
//     final farzDays = tracker.farzCompletedDays;
//     final jamaat   = tracker.congregationDaysSum;

//     String rankLabel() {
//       if (rank <= 1)  return 'সর্বোচ্চ অবস্থানে আছেন!';
//       if (rank <= 3)  return 'শীর্ষ ৩ জনের মধ্যে!';
//       if (rank <= 10) return 'শীর্ষ ১০ জনের মধ্যে';
//       return 'র‍্যাংক #$rank তে আছেন';
//     }

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         _SectionHeader(title: 'লিডারবোর্ড অবস্থান', emoji: '🏅'),
//         const SizedBox(height: 10),
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//               color: _C.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: _C.border, width: 0.5)),
//           child: Row(children: [
//             Container(
//                 width: 60, height: 60,
//                 decoration: BoxDecoration(
//                     color: _C.greenLight,
//                     borderRadius: BorderRadius.circular(14)),
//                 child: Center(
//                     child: FittedBox(
//                         fit: BoxFit.scaleDown,
//                         child: Padding(
//                             padding: const EdgeInsets.all(4),
//                             child: Text('#$rank',
//                                 style: const TextStyle(
//                                     color: _C.darkGreen,
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.w900)))))),
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
//                       'সম্পন্ন ${pct.toInt()}% · $farzDays পূর্ণ ফরজ দিন · $jamaat জামাত',
//                       style: const TextStyle(
//                           color: _C.textSecondary,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w500)),
//                   const SizedBox(height: 8),
//                   ClipRRect(
//                       borderRadius: BorderRadius.circular(99),
//                       child: LinearProgressIndicator(
//                           value: pct / 100,
//                           minHeight: 5,
//                           backgroundColor: _C.pageBg,
//                           valueColor: const AlwaysStoppedAnimation(
//                               _C.darkGreen))),
//                 ])),
//             if (tracker.isWinner) ...[
//               const SizedBox(width: 12),
//               Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                       color: _C.goldLight,
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                           color: _C.gold.withOpacity(0.3), width: 0.5)),
//                   child: const Text('🏆',
//                       style: TextStyle(fontSize: 22))),
//             ],
//           ]),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // HEATMAP
// // ─────────────────────────────────────────────────────────────────────────────

// class _HeatmapCalendar extends StatelessWidget {
//   final int year, month;
//   final List<DailyEntry> entries;
//   final String userGender;
//   const _HeatmapCalendar(
//       {required this.year,
//       required this.month,
//       required this.entries,
//       required this.userGender});

//   @override
//   Widget build(BuildContext context) {
//     final daysInMonth = DateUtils.getDaysInMonth(year, month);
//     final entryMap   = {for (final e in entries) e.day: e};
//     final today      = DateTime.now();
//     final firstDay   = DateTime(year, month, 1).weekday % 7;
//     final totalCells = ((firstDay + daysInMonth) / 7).ceil() * 7;
//     final isFemale   = userGender == 'female';

//     int _intensity(DailyEntry e) {
//       int score = 0;
//       for (final item in e.entries) {
//         if (item.prayerMode == PrayerMode.congregation) {
//           score += 2;
//         } else if (item.prayerMode == PrayerMode.solo) {
//           score += 1;
//         } else if (item.completed || item.count > 0) {
//           score += 1;
//         }
//       }
//       return score;
//     }

//     final maxScore = entries.isEmpty
//         ? 1
//         : entries.map(_intensity).fold(0, (a, b) => a > b ? a : b).clamp(1, 999);

//     const weekdays = ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহঃ', 'শুক্র', 'শনি'];

//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: _C.border, width: 0.5)),
//       child:
//           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(
//             children: weekdays
//                 .map((d) => Expanded(
//                     child: Center(
//                         child: Text(d,
//                             style: const TextStyle(
//                                 color: _C.textHint,
//                                 fontSize: 9.5,
//                                 fontWeight: FontWeight.w500)))))
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
//             if (dayNum < 1 || dayNum > daysInMonth) {
//               return const SizedBox.shrink();
//             }

//             final entry    = entryMap[dayNum];
//             final isExempt = (entry?.isExemptDay ?? false) && isFemale;
//             final hasAct   = entry?.hasActivity ?? false;
//             final score    = entry != null ? _intensity(entry) : 0;
//             final intensity= score / maxScore;
//             final isToday  = today.year == year &&
//                 today.month == month &&
//                 today.day == dayNum;
//             final isFuture =
//                 DateTime(year, month, dayNum).isAfter(today);

//             Color cellColor;
//             Color numColor;

//             if (isExempt) {
//               cellColor = _C.purplePale;
//               numColor  = _C.purple;
//             } else if (isFuture) {
//               cellColor = _C.pageBg;
//               numColor  = _C.textHint;
//             } else if (!hasAct) {
//               cellColor = _C.greenLight.withOpacity(0.4);
//               numColor  = _C.textHint;
//             } else if (intensity < 0.25) {
//               cellColor = _C.green.withOpacity(0.18);
//               numColor  = _C.green;
//             } else if (intensity < 0.5) {
//               cellColor = _C.green.withOpacity(0.38);
//               numColor  = _C.green;
//             } else if (intensity < 0.75) {
//               cellColor = _C.green.withOpacity(0.60);
//               numColor  = Colors.white;
//             } else {
//               cellColor = _C.green.withOpacity(0.85);
//               numColor  = Colors.white;
//             }

//             return Container(
//               decoration: BoxDecoration(
//                 color: cellColor,
//                 borderRadius: BorderRadius.circular(5),
//                 border: isToday
//                     ? Border.all(color: _C.gold, width: 1.5)
//                     : null,
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
//                       const Text('🌸',
//                           style: TextStyle(fontSize: 6.5, height: 1))
//                     else if (hasAct && !isFuture)
//                       Container(
//                         width: 4, height: 4,
//                         margin: const EdgeInsets.only(top: 1),
//                         decoration: BoxDecoration(
//                             color: numColor.withOpacity(0.6),
//                             shape: BoxShape.circle),
//                       ),
//                   ]),
//             ).animate(
//                 delay: Duration(milliseconds: dayNum * 8)).scale(
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
//                     width: 12, height: 12,
//                     margin: const EdgeInsets.only(right: 3),
//                     decoration: BoxDecoration(
//                         color: i == 0
//                             ? _C.greenLight.withOpacity(0.4)
//                             : _C.green.withOpacity(0.15 + i * 0.18),
//                         borderRadius: BorderRadius.circular(3)),
//                   )),
//           const Text('  বেশি',
//               style: TextStyle(color: _C.textHint, fontSize: 9.5)),
//           if (isFemale) ...[
//             const SizedBox(width: 8),
//             Container(
//                 width: 12, height: 12,
//                 margin: const EdgeInsets.only(right: 3),
//                 decoration: BoxDecoration(
//                     color: _C.purplePale,
//                     borderRadius: BorderRadius.circular(3),
//                     border: Border.all(
//                         color: _C.purple.withOpacity(0.3), width: 0.5))),
//             const Text('মাহলি',
//                 style: TextStyle(color: _C.textHint, fontSize: 9.5)),
//           ],
//         ]),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DAY ROW — tap করলে category-wise breakdown দেখাবে
// // ─────────────────────────────────────────────────────────────────────────────

// class _DayRow extends ConsumerWidget {
//   final DailyEntry entry;
//   final bool isLast;
//   final int delay;
//   final String userGender;
//   const _DayRow(
//       {required this.entry,
//       required this.isLast,
//       required this.delay,
//       required this.userGender});

//   void _showDayDetail(BuildContext context, WidgetRef ref) {
//     final categories = ref.read(categoriesProvider).value ?? [];
//     final catMap = {for (final c in categories) c.id: c};
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) => _DayDetailSheet(
//           entry: entry, catMap: catMap, userGender: userGender),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isFemale = userGender == 'female';
//     final isExempt = entry.isExemptDay && isFemale;
//     final entries  = entry.entries;

//     final congregation = entries
//         .where((e) => e.prayerMode == PrayerMode.congregation)
//         .length;
//     final solo   = entries
//         .where((e) => e.prayerMode == PrayerMode.solo)
//         .length;
//     final missed = entries
//         .where((e) => e.prayerMode == PrayerMode.missed)
//         .length;

//     final otherCompleted = entries
//         .where((e) =>
//             e.prayerMode == null && (e.completed || e.count > 0))
//         .length;

//     final totalCompleted = congregation + solo + otherCompleted;
//     final hasActivity    = entry.hasActivity;

//     String monthShort(int idx) {
//       final s = AppConstants.bengaliMonths[idx];
//       return s.length >= 3 ? s.substring(0, 3) : s;
//     }

//     final prayerTotal = congregation + solo + missed;
//     final progressVal = prayerTotal > 0
//         ? congregation / prayerTotal
//         : hasActivity
//             ? 0.5
//             : 0.0;

//     Color barColor = isExempt
//         ? _C.purple
//         : congregation >= 3
//             ? _C.green
//             : congregation >= 1
//                 ? _C.amber
//                 : _C.border;

//     return InkWell(
//       onTap: () => _showDayDetail(context, ref),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
//         decoration: BoxDecoration(
//           color: isExempt
//               ? _C.purplePale.withOpacity(0.4)
//               : hasActivity
//                   ? _C.greenLight.withOpacity(0.15)
//                   : Colors.transparent,
//           border: isLast
//               ? null
//               : const Border(
//                   bottom: BorderSide(color: _C.border, width: 0.5)),
//           borderRadius: isLast
//               ? const BorderRadius.vertical(bottom: Radius.circular(16))
//               : null,
//         ),
//         child: Row(children: [
//           Container(
//             width: 44, height: 44,
//             decoration: BoxDecoration(
//               gradient: isExempt
//                   ? const LinearGradient(
//                       colors: [_C.purple, Color(0xFF9B6BE8)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight)
//                   : hasActivity
//                       ? const LinearGradient(
//                           colors: [_C.darkGreen, _C.midGreen],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight)
//                       : null,
//               color: isExempt || hasActivity ? null : _C.pageBg,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('${entry.day}',
//                       style: TextStyle(
//                           color: isExempt || hasActivity
//                               ? Colors.white
//                               : _C.textHint,
//                           fontWeight: FontWeight.w800,
//                           fontSize: 15,
//                           height: 1)),
//                   Text(monthShort(entry.month - 1),
//                       style: TextStyle(
//                           color: isExempt || hasActivity
//                               ? Colors.white.withOpacity(0.6)
//                               : _C.textHint,
//                           fontSize: 8.5)),
//                 ]),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                 Row(children: [
//                   Flexible(
//                       child: Text(
//                           isExempt
//                               ? 'মাহলির দিন'
//                               : hasActivity
//                                   ? '$totalCompleted টি আমল সম্পন্ন'
//                                   : 'কোনো আমল নেই',
//                           style: TextStyle(
//                               color: isExempt
//                                   ? _C.purple
//                                   : hasActivity
//                                       ? _C.textPrimary
//                                       : _C.textSecondary,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 12),
//                           overflow: TextOverflow.ellipsis)),
//                   if (congregation > 0) ...[
//                     const SizedBox(width: 5),
//                     _Pill(
//                         text: '🕌 $congregation জামাত',
//                         bg: _C.purpleLight,
//                         fg: _C.purple),
//                   ] else if (solo > 0) ...[
//                     const SizedBox(width: 5),
//                     _Pill(
//                         text: '🤲 $solo একাকী',
//                         bg: _C.greenLight,
//                         fg: _C.green),
//                   ],
//                 ]),
//                 if (missed > 0) ...[
//                   const SizedBox(height: 3),
//                   _Pill(
//                       text: '⚠️ $missed মিস',
//                       bg: _C.redLight,
//                       fg: _C.red),
//                 ],
//                 const SizedBox(height: 5),
//                 ClipRRect(
//                     borderRadius: BorderRadius.circular(99),
//                     child: LinearProgressIndicator(
//                         value: progressVal.clamp(0.0, 1.0),
//                         minHeight: 4,
//                         backgroundColor: _C.pageBg,
//                         valueColor: AlwaysStoppedAnimation(barColor))),
//               ])),
//           const SizedBox(width: 10),
//           Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
//             if (isExempt)
//               const Text('🌸', style: TextStyle(fontSize: 18))
//             else if (congregation >= 4)
//               const Icon(Icons.star_rounded, color: _C.gold, size: 22)
//             else if (congregation >= 1 || solo >= 1)
//               const Icon(Icons.check_circle_rounded,
//                   color: _C.green, size: 22)
//             else if (hasActivity)
//               const Icon(Icons.circle_outlined,
//                   color: _C.amber, size: 22)
//             else
//               const Icon(Icons.remove_circle_outline_rounded,
//                   color: _C.border, size: 22),
//             const SizedBox(height: 2),
//             Text(
//                 isExempt
//                     ? 'মাফ'
//                     : congregation >= 4
//                         ? 'পূর্ণ'
//                         : congregation >= 1
//                             ? 'আংশিক'
//                             : hasActivity
//                                 ? 'কিছু'
//                                 : 'শূন্য',
//                 style: const TextStyle(
//                     color: _C.textHint,
//                     fontSize: 8.5,
//                     fontWeight: FontWeight.w500)),
//             const SizedBox(height: 4),
//             const Icon(Icons.chevron_right_rounded,
//                 color: _C.textHint, size: 16),
//           ]),
//         ]),
//       ),
//     )
//         .animate(delay: Duration(milliseconds: delay))
//         .fadeIn(duration: 240.ms)
//         .slideX(begin: 0.04, curve: Curves.easeOut);
//   }
// }

// class _Pill extends StatelessWidget {
//   final String text;
//   final Color bg, fg;
//   const _Pill({required this.text, required this.bg, required this.fg});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//       decoration:
//           BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
//       child: Text(text,
//           style: TextStyle(
//               color: fg, fontSize: 9, fontWeight: FontWeight.w700)),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DAY DETAIL SHEET — category wise real breakdown (categories API + entry)
// // ─────────────────────────────────────────────────────────────────────────────

// class _DayDetailSheet extends StatelessWidget {
//   final DailyEntry entry;
//   final Map<String, AmalCategory> catMap;
//   final String userGender;
//   const _DayDetailSheet(
//       {required this.entry, required this.catMap, required this.userGender});

//   @override
//   Widget build(BuildContext context) {
//     final isFemale = userGender == 'female';
//     final isExempt = entry.isExemptDay && isFemale;
//     final items = entry.entries
//         .where((e) => catMap.containsKey(e.categoryId))
//         .map((e) => MapEntry(catMap[e.categoryId]!, e))
//         .toList()
//       ..sort((a, b) => a.key.order.compareTo(b.key.order));

//     return DraggableScrollableSheet(
//       initialChildSize: 0.6,
//       minChildSize: 0.35,
//       maxChildSize: 0.9,
//       expand: false,
//       builder: (context, scrollController) => Container(
//         decoration: const BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//         ),
//         child: Column(children: [
//           const SizedBox(height: 12),
//           Container(
//               width: 40, height: 4,
//               decoration: BoxDecoration(
//                   color: _C.border, borderRadius: BorderRadius.circular(99))),
//           const SizedBox(height: 16),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(children: [
//               Expanded(
//                 child: Text('${entry.day} তারিখের বিস্তারিত',
//                     style: const TextStyle(
//                         color: _C.textPrimary,
//                         fontWeight: FontWeight.w800,
//                         fontSize: 15)),
//               ),
//               if (isExempt)
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                       color: _C.purplePale,
//                       borderRadius: BorderRadius.circular(20)),
//                   child: const Text('🌸 মাহলি',
//                       style: TextStyle(
//                           color: _C.purple,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w700)),
//                 ),
//             ]),
//           ),
//           const SizedBox(height: 14),
//           Expanded(
//             child: items.isEmpty
//                 ? const Center(
//                     child: Text('এই দিনে কোনো আমল লগ করা হয়নি',
//                         style: TextStyle(color: _C.textHint, fontSize: 12)))
//                 : ListView.separated(
//                     controller: scrollController,
//                     padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
//                     itemCount: items.length,
//                     separatorBuilder: (_, __) =>
//                         const Divider(height: 18, color: _C.border, thickness: 0.5),
//                     itemBuilder: (ctx, i) => _DayDetailRow(
//                         category: items[i].key, item: items[i].value),
//                   ),
//           ),
//         ]),
//       ),
//     );
//   }
// }

// class _DayDetailRow extends StatelessWidget {
//   final AmalCategory category;
//   final DailyEntryItem item;
//   const _DayDetailRow({required this.category, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     final isFardPrayer = category.isFard && category.isPrayer;
//     String statusText;
//     Color statusColor;
//     IconData statusIcon;

//     if (isFardPrayer) {
//       switch (item.prayerMode) {
//         case PrayerMode.congregation:
//           statusText = 'জামাতে আদায়';
//           statusColor = _C.purple;
//           statusIcon = Icons.people_rounded;
//           break;
//         case PrayerMode.solo:
//           statusText = 'একাকী আদায়';
//           statusColor = _C.amber;
//           statusIcon = Icons.person_rounded;
//           break;
//         case PrayerMode.missed:
//         default:
//           statusText = 'মিস করেছেন';
//           statusColor = _C.red;
//           statusIcon = Icons.close_rounded;
//       }
//     } else if (category.inputType == AmalInputType.counter ||
//         category.inputType == AmalInputType.duration) {
//       final hasVal = item.count > 0;
//       statusText = hasVal ? '${item.count} ${category.unit ?? ""}' : 'করা হয়নি';
//       statusColor = hasVal ? _C.green : _C.textHint;
//       statusIcon =
//           hasVal ? Icons.check_circle_rounded : Icons.remove_circle_outline_rounded;
//     } else {
//       statusText = item.completed ? 'সম্পন্ন' : 'করা হয়নি';
//       statusColor = item.completed ? _C.green : _C.textHint;
//       statusIcon = item.completed
//           ? Icons.check_circle_rounded
//           : Icons.remove_circle_outline_rounded;
//     }

//     return Row(children: [
//       Container(
//         width: 36, height: 36,
//         decoration: BoxDecoration(
//             color: statusColor.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10)),
//         child: Center(
//             child: Text(category.icon ?? _SectionMeta.emoji(category.section),
//                 style: const TextStyle(fontSize: 16))),
//       ),
//       const SizedBox(width: 12),
//       Expanded(
//         child: Text(category.nameBn,
//             style: const TextStyle(
//                 color: _C.textPrimary, fontWeight: FontWeight.w700, fontSize: 13)),
//       ),
//       Row(mainAxisSize: MainAxisSize.min, children: [
//         Icon(statusIcon, size: 15, color: statusColor),
//         const SizedBox(width: 5),
//         Text(statusText,
//             style: TextStyle(
//                 color: statusColor, fontWeight: FontWeight.w700, fontSize: 11.5)),
//       ]),
//     ]);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SHARED SECTION HEADER
// // ─────────────────────────────────────────────────────────────────────────────

// class _SectionHeader extends StatelessWidget {
//   final String title, emoji;
//   const _SectionHeader({required this.title, required this.emoji});

//   @override
//   Widget build(BuildContext context) {
//     return Row(children: [
//       Text(emoji, style: const TextStyle(fontSize: 14)),
//       const SizedBox(width: 7),
//       Flexible(
//           child: Text(title,
//               style: const TextStyle(
//                   color: _C.textPrimary,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 15,
//                   letterSpacing: -0.2))),
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
//             width: 40, height: 4,
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
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 24, vertical: 8),
//               decoration: BoxDecoration(
//                   color: _C.greenLight,
//                   borderRadius: BorderRadius.circular(12)),
//               child: Text('$_y',
//                   style: const TextStyle(
//                       color: _C.darkGreen,
//                       fontWeight: FontWeight.w800,
//                       fontSize: 18))),
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
//             final isFuture   = _y == now.year && i + 1 > now.month;
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
//                     child: FittedBox(
//                         fit: BoxFit.scaleDown,
//                         child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 4),
//                             child: Text(AppConstants.bengaliMonths[i],
//                                 style: TextStyle(
//                                     color: isSelected
//                                         ? Colors.white
//                                         : isFuture
//                                             ? _C.textHint
//                                             : _C.textSecondary,
//                                     fontSize: 12,
//                                     fontWeight: isSelected
//                                         ? FontWeight.w700
//                                         : FontWeight.w500))))),
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
//         width: 38, height: 38,
//         margin: const EdgeInsets.symmetric(horizontal: 12),
//         decoration: BoxDecoration(
//           color: enabled ? _C.greenLight : _C.pageBg,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//               color: enabled ? _C.borderMid : _C.border, width: 0.5),
//         ),
//         child: Icon(icon,
//             color: enabled ? _C.darkGreen : _C.textHint, size: 20),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SKELETONS
// // ─────────────────────────────────────────────────────────────────────────────

// class _HeroBandSkeleton extends StatelessWidget {
//   const _HeroBandSkeleton();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: _C.darkGreen,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
//         child:
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Container(
//               width: 130, height: 11,
//               decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(4))),
//           const SizedBox(height: 12),
//           Container(
//             height: 92,
//             decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.08),
//                 borderRadius: BorderRadius.circular(14)),
//           ).animate(onPlay: (c) => c.repeat()).shimmer(
//               duration: 1200.ms,
//               colors: [
//                 Colors.white.withOpacity(0.02),
//                 Colors.white.withOpacity(0.08),
//                 Colors.white.withOpacity(0.02)
//               ]),
//         ]),
//       ),
//     );
//   }
// }

// class _StatStripSkeleton extends StatelessWidget {
//   const _StatStripSkeleton();

//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//       _row(top: 12),
//       _row(top: 8),
//     ]);
//   }

//   static Widget _row({required double top}) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(16, top, 16, 0),
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
//       _shimBar(width: 130, height: 14),
//       const SizedBox(height: 12),
//       _shimBox(height: 240),
//       const SizedBox(height: 22),
//       _shimBar(width: 150, height: 14),
//       const SizedBox(height: 12),
//       Container(
//         decoration: BoxDecoration(
//             color: _C.cardBg,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.border, width: 0.5)),
//         child: Column(
//             children: List.generate(
//                 5,
//                 (i) => Container(
//                       height: 64,
//                       margin:
//                           const EdgeInsets.fromLTRB(14, 10, 14, 10),
//                       decoration: BoxDecoration(
//                           color: _C.pageBg,
//                           borderRadius: BorderRadius.circular(10)),
//                     ).animate(onPlay: (c) => c.repeat()).shimmer(
//                         duration: 1200.ms,
//                         delay: Duration(milliseconds: i * 70),
//                         colors: [
//                           _C.pageBg,
//                           const Color(0xFFE8ECE8),
//                           _C.pageBg
//                         ]))),
//       ),
//     ]);
//   }

//   static Widget _shimBar({required double width, required double height}) =>
//       Container(
//         width: width, height: height,
//         decoration: BoxDecoration(
//             color: _C.cardBg, borderRadius: BorderRadius.circular(8)),
//       ).animate(onPlay: (c) => c.repeat()).shimmer(
//           duration: 1200.ms,
//           colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg]);

//   static Widget _shimBox({required double height}) => Container(
//         width: double.infinity, height: height,
//         decoration: BoxDecoration(
//             color: _C.cardBg,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.border, width: 0.5)),
//       ).animate(onPlay: (c) => c.repeat()).shimmer(
//           duration: 1200.ms,
//           colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg]);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // ERROR + EMPTY
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
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 20, vertical: 9),
//                 decoration: BoxDecoration(
//                     color: _C.greenLight,
//                     borderRadius: BorderRadius.circular(10)),
//                 child: const Text('পুনরায় চেষ্টা করুন',
//                     style: TextStyle(
//                         color: _C.darkGreen,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 12)))),
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
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//             const Text('📭', style: TextStyle(fontSize: 22)),
//             const SizedBox(height: 6),
//             Text(label,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                     color: _C.textHint,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500)),
//           ])),
//     );
//   }
// }

// import 'package:amal_tracker/features/monthly_summary/screens/category_list_screen.dart';
// import 'package:amal_tracker/features/monthly_summary/widgets/monthly_amol_shared.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/tracker_provider.dart';
// import '../models/tracker_model.dart';
// import '../../../core/constants/app_constants.dart';

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

//   void _openCategoryList() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => CategoryListScreen(year: _year, month: _month),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final params = (year: _year, month: _month);
//     final entriesAsync = ref.watch(monthlyEntriesProvider(params));
//     final progressAsync = ref.watch(progressSummaryProvider(params));

//     final monthName = AppConstants.bengaliMonths[_month - 1];
//     final now = DateTime.now();
//     final isCurrentMonth = _year == now.year && _month == now.month;

//     return Scaffold(
//       backgroundColor: AmolColors.pageBg,
//       body: RefreshIndicator(
//         color: AmolColors.darkGreen,
//         onRefresh: () async {
//           ref.invalidate(monthlyEntriesProvider(params));
//           ref.invalidate(progressSummaryProvider(params));
//           ref.invalidate(categoriesProvider);
//         },
//         child: CustomScrollView(
//           controller: _sc,
//           physics: const AlwaysScrollableScrollPhysics(),
//           slivers: [
//             // ── App Bar ────────────────────────────────────────────────────
//             SliverAppBar(
//               pinned: true,
//               expandedHeight: 0,
//               toolbarHeight: 56,
//               backgroundColor: AmolColors.darkGreen,
//               surfaceTintColor: Colors.transparent,
//               shadowColor: Colors.transparent,
//               automaticallyImplyLeading: false,
//               systemOverlayStyle: SystemUiOverlayStyle.light,
//               title: Row(children: [
//                 Container(
//                   width: 30,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(
//                         color: Colors.white.withOpacity(0.15), width: 0.5),
//                   ),
//                   child: const Icon(Icons.calendar_month_outlined,
//                       color: Colors.white, size: 15),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text('মাসিক রিপোর্ট',
//                             style: TextStyle(
//                                 color: Colors.white.withOpacity(0.55),
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w500)),
//                         Text('$monthName $_year',
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w800,
//                                 letterSpacing: -0.3,
//                                 height: 1.1)),
//                       ]),
//                 ),
//               ]),
//               actions: [
//                 GestureDetector(
//                   onTap: _showPeriodPicker,
//                   child: Container(
//                     margin: const EdgeInsets.only(right: 16),
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                           color: Colors.white.withOpacity(0.18), width: 0.5),
//                     ),
//                     child: Row(mainAxisSize: MainAxisSize.min, children: [
//                       Icon(Icons.swap_horiz_rounded,
//                           size: 13, color: Colors.white.withOpacity(0.7)),
//                       const SizedBox(width: 5),
//                       const Text('মাস বদলান',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 12)),
//                     ]),
//                   ),
//                 ),
//               ],
//             ),

//             // ── Hero Band ──────────────────────────────────────────────────
//             SliverToBoxAdapter(
//               child: progressAsync.when(
//                 loading: () => const _HeroBandSkeleton(),
//                 error: (_, __) => const _HeroBandSkeleton(),
//                 data: (p) => _HeroBand(tracker: p.currentMonth),
//               ),
//             ),

//             // ── Female Exempt Banner ───────────────────────────────────────
//             SliverToBoxAdapter(
//               child: progressAsync.whenOrNull(
//                 data: (p) {
//                   if (p.userGender != 'female') return const SizedBox.shrink();
//                   final n = p.currentMonth?.exemptDays ?? 0;
//                   if (n == 0) return const SizedBox.shrink();
//                   return _ExemptBanner(exemptCount: n);
//                 },
//               ),
//             ),

//             // ── Stat Strip ─────────────────────────────────────────────────
//             SliverToBoxAdapter(
//               child: progressAsync.when(
//                 loading: () => const _StatStripSkeleton(),
//                 error: (_, __) => const _StatStripSkeleton(),
//                 data: (p) => _StatStrip(
//                   tracker: p.currentMonth,
//                   userGender: p.userGender,
//                 ),
//               ),
//             ),

//             // ── Entry card → dedicated "সব আমল" full page (search + filter +
//             //    per-category monthly stat + tap-in detail page) ───────────
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//                 child: AmolNavEntryCard(
//                   emoji: '🗂️',
//                   title: 'সব আমল দেখুন',
//                   subtitle:
//                       '$monthName মাসের প্রতিটা আমলের বিস্তারিত ও প্রগ্রেস',
//                   onTap: _openCategoryList,
//                 ),
//               ),
//             ),

//             // ── Fard Performance ───────────────────────────────────────────
//             SliverToBoxAdapter(
//               child: progressAsync.when(
//                 loading: () => const _SectionSkeleton(height: 120),
//                 error: (_, __) => const SizedBox.shrink(),
//                 data: (p) {
//                   if (p.currentMonth == null ||
//                       p.currentMonth!.eligibleDays == 0) {
//                     return const SizedBox.shrink();
//                   }
//                   return _FardSection(tracker: p.currentMonth!);
//                 },
//               ),
//             ),

//             // ── Weekly Chart (current month only) ──────────────────────────
//             if (isCurrentMonth)
//               SliverToBoxAdapter(
//                 child: progressAsync.when(
//                   loading: () => const _SectionSkeleton(height: 160),
//                   error: (_, __) => const SizedBox.shrink(),
//                   data: (p) => _WeeklyChartSection(
//                     weekData: p.currentWeekProgress,
//                     userGender: p.userGender,
//                   ),
//                 ),
//               ),

//             // ── Prayer Today Breakdown (current month only, fixed responsive) ─
//             if (isCurrentMonth)
//               SliverToBoxAdapter(
//                 child: progressAsync.when(
//                   loading: () => const _SectionSkeleton(height: 100),
//                   error: (_, __) => const SizedBox.shrink(),
//                   data: (p) {
//                     if (p.todayPrayerBreakdown.isEmpty)
//                       return const SizedBox.shrink();
//                     return _TodayPrayerSection(prayers: p.todayPrayerBreakdown);
//                   },
//                 ),
//               ),

//             // ── Previous Months Comparison ──────────────────────────────────
//             SliverToBoxAdapter(
//               child: progressAsync.when(
//                 loading: () => const _SectionSkeleton(height: 140),
//                 error: (_, __) => const SizedBox.shrink(),
//                 data: (p) {
//                   final allMonths = p.recentMonths;
//                   if (allMonths.isEmpty) {
//                     return const Padding(
//                       padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
//                       child:
//                           AmolEmptyCard(label: 'মাসিক তুলনামূলক কোনো ডেটা নেই'),
//                     );
//                   }
//                   return _PrevMonthsSection(
//                       months: allMonths.reversed.toList());
//                 },
//               ),
//             ),

//             // ── Rank Card ──────────────────────────────────────────────────
//             SliverToBoxAdapter(
//               child: progressAsync.when(
//                 loading: () => const SizedBox.shrink(),
//                 error: (_, __) => const SizedBox.shrink(),
//                 data: (p) {
//                   if (p.currentMonth == null || p.currentMonth!.rank == null) {
//                     return const SizedBox.shrink();
//                   }
//                   return _RankSection(tracker: p.currentMonth!);
//                 },
//               ),
//             ),

//             // ── Heatmap + Day List ─────────────────────────────────────────
//             SliverPadding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
//               sliver: entriesAsync.when(
//                 loading: () =>
//                     const SliverToBoxAdapter(child: _EntriesSkeleton()),
//                 error: (_, __) => SliverToBoxAdapter(
//                     child: AmolErrorCard(
//                         onRetry: () =>
//                             ref.invalidate(monthlyEntriesProvider(params)))),
//                 data: (entries) {
//                   final userGender =
//                       progressAsync.valueOrNull?.userGender ?? 'male';
//                   return SliverList(
//                     delegate: SliverChildListDelegate([
//                       const SizedBox(height: 15),
//                       const AmolSectionHeader(
//                           title: 'দৈনিক ক্যালেন্ডার', emoji: '📅'),
//                       const SizedBox(height: 10),
//                       _HeatmapCalendar(
//                           year: _year,
//                           month: _month,
//                           entries: entries,
//                           userGender: userGender),
//                       const SizedBox(height: 22),
//                       const AmolSectionHeader(
//                           title: 'দিন অনুযায়ী বিস্তারিত', emoji: '📋'),
//                       const SizedBox(height: 3),
//                       const Padding(
//                         padding: EdgeInsets.only(bottom: 8),
//                         child: Text('যেকোনো দিনে ট্যাপ করে বিস্তারিত দেখুন',
//                             style: TextStyle(
//                                 color: AmolColors.textHint,
//                                 fontSize: 10.5,
//                                 fontWeight: FontWeight.w500)),
//                       ),
//                       if (entries.isEmpty)
//                         AmolEmptyCard(label: '$monthName মাসে কোনো আমল নেই')
//                       else
//                         Container(
//                           decoration: BoxDecoration(
//                             color: AmolColors.cardBg,
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(
//                                 color: AmolColors.border, width: 0.5),
//                           ),
//                           child: Column(
//                             children: List.generate(
//                               entries.length,
//                               (i) => _DayRow(
//                                 entry: entries[i],
//                                 isLast: i == entries.length - 1,
//                                 delay: 220 + i * 25,
//                                 userGender: userGender,
//                               ),
//                             ),
//                           ),
//                         ),
//                     ]),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // HERO BAND
// // ─────────────────────────────────────────────────────────────────────────────

// class _HeroBand extends StatelessWidget {
//   final MonthlyTracker? tracker;
//   const _HeroBand({required this.tracker});

//   String _winnerLabel(String? cat) {
//     switch (cat) {
//       case 'TOP_FARZ':
//         return 'ফরজ চ্যাম্পিয়ন 🕌';
//       case 'TOP_JAMAAT':
//         return 'জামাত চ্যাম্পিয়ন 🤝';
//       case 'TOP_QURAN':
//         return 'কুরআন চ্যাম্পিয়ন 📖';
//       case 'TOP_STREAK':
//         return 'সেরা ধারাবাহিকতা 🔥';
//       default:
//         return 'মাসিক বিজয়ী 🏆';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pct = (tracker?.completionPercentage ?? 0).clamp(0.0, 100.0);
//     final farzDays = tracker?.farzCompletedDays ?? 0;
//     final eligibleDays = tracker?.eligibleDays ?? 0;
//     final jamaat = tracker?.congregationDaysSum ?? 0;
//     final streak = tracker?.streakDays ?? 0;
//     final isWinner = tracker?.isWinner ?? false;
//     final rank = tracker?.rank;

//     return Container(
//       color: AmolColors.darkGreen,
//       child: Stack(children: [
//         Positioned(
//             top: -45,
//             right: -40,
//             child: Container(
//                 width: 140,
//                 height: 140,
//                 decoration: const BoxDecoration(
//                     shape: BoxShape.circle, color: Color(0x0AFFFFFF)))),
//         Positioned(
//             bottom: -25,
//             left: 18,
//             child: Container(
//                 width: 88,
//                 height: 88,
//                 decoration: const BoxDecoration(
//                     shape: BoxShape.circle, color: Color(0x07FFFFFF)))),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text('মাসের আমলের সারসংক্ষেপ',
//                 style: TextStyle(
//                     color: Colors.white.withOpacity(0.4),
//                     fontSize: 11,
//                     fontWeight: FontWeight.w500)),
//             const SizedBox(height: 8),
//             Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: const Color(0x17FFFFFF),
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(color: const Color(0x2EFFFFFF), width: 0.5),
//               ),
//               child: Row(children: [
//                 _CircularProgress(percentage: pct, size: 66),
//                 const SizedBox(width: 14),
//                 Expanded(
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                       FittedBox(
//                         fit: BoxFit.scaleDown,
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                             eligibleDays > 0
//                                 ? '$farzDays/$eligibleDays দিন'
//                                 : '$farzDays দিন',
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w900,
//                                 fontSize: 24,
//                                 letterSpacing: -0.5,
//                                 height: 1)),
//                       ),
//                       const SizedBox(height: 2),
//                       Text('সব ফরজ পূর্ণ',
//                           style: TextStyle(
//                               color: Colors.white.withOpacity(0.45),
//                               fontSize: 10)),
//                       const SizedBox(height: 7),
//                       Wrap(spacing: 6, runSpacing: 4, children: [
//                         _HeroChip(
//                             icon: Icons.people_rounded, label: '$jamaat জামাত'),
//                         _HeroChip(
//                             icon: Icons.local_fire_department_rounded,
//                             label: '$streak দিন ধারা'),
//                       ]),
//                       if (isWinner) ...[
//                         const SizedBox(height: 6),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 3),
//                           decoration: BoxDecoration(
//                               color: AmolColors.gold,
//                               borderRadius: BorderRadius.circular(20)),
//                           child: Row(mainAxisSize: MainAxisSize.min, children: [
//                             const Text('🏆', style: TextStyle(fontSize: 10)),
//                             const SizedBox(width: 4),
//                             Flexible(
//                                 child: Text(
//                                     _winnerLabel(tracker?.winnerCategory),
//                                     style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.w700),
//                                     overflow: TextOverflow.ellipsis,
//                                     maxLines: 1)),
//                           ]),
//                         ),
//                       ],
//                     ])),
//                 const SizedBox(width: 12),
//                 if (rank != null)
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.08),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                           color: Colors.white.withOpacity(0.15), width: 0.5),
//                     ),
//                     child: Column(children: [
//                       Text('র‍্যাংক',
//                           style: TextStyle(
//                               color: Colors.white.withOpacity(0.45),
//                               fontSize: 8.5)),
//                       Text('#$rank',
//                           style: const TextStyle(
//                               color: AmolColors.gold,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w900,
//                               height: 1.1)),
//                     ]),
//                   ),
//               ]),
//             ),
//           ]),
//         ),
//       ]),
//     );
//   }
// }

// class _HeroChip extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   const _HeroChip({required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.12),
//           borderRadius: BorderRadius.circular(20)),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [
//         Icon(icon, color: Colors.white.withOpacity(0.7), size: 11),
//         const SizedBox(width: 4),
//         Text(label,
//             style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 10.5,
//                 fontWeight: FontWeight.w600)),
//       ]),
//     );
//   }
// }

// class _CircularProgress extends StatelessWidget {
//   final double percentage;
//   final double size;
//   const _CircularProgress({required this.percentage, required this.size});

//   @override
//   Widget build(BuildContext context) {
//     final str = '${percentage.toInt()}%';
//     final innerSize = size * 0.80;
//     final Color barColor = percentage >= 80
//         ? AmolColors.green
//         : percentage >= 50
//             ? AmolColors.gold
//             : AmolColors.amber;

//     return SizedBox(
//       width: size,
//       height: size,
//       child: Stack(alignment: Alignment.center, children: [
//         SizedBox.expand(
//             child: CircularProgressIndicator(
//           value: percentage / 100,
//           backgroundColor: Colors.white.withOpacity(0.12),
//           valueColor: AlwaysStoppedAnimation(barColor),
//           strokeWidth: size * 0.09,
//           strokeCap: StrokeCap.round,
//         )),
//         Container(
//           width: innerSize,
//           height: innerSize,
//           decoration: const BoxDecoration(
//               color: AmolColors.darkGreen, shape: BoxShape.circle),
//           child: Center(
//               child: FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Padding(
//               padding: EdgeInsets.all(size * 0.05),
//               child: Column(mainAxisSize: MainAxisSize.min, children: [
//                 Text(str,
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w900,
//                         fontSize: size * 0.165,
//                         height: 1),
//                     textAlign: TextAlign.center),
//                 SizedBox(height: size * 0.02),
//                 Text('সম্পন্ন',
//                     style: TextStyle(
//                         color: Colors.white.withOpacity(0.45),
//                         fontSize: size * 0.12),
//                     textAlign: TextAlign.center),
//               ]),
//             ),
//           )),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // EXEMPT BANNER
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
//         color: AmolColors.purplePale,
//         borderRadius: BorderRadius.circular(12),
//         border:
//             Border.all(color: AmolColors.purple.withOpacity(0.25), width: 0.5),
//       ),
//       child: Row(children: [
//         Container(
//             width: 30,
//             height: 30,
//             decoration: BoxDecoration(
//                 color: AmolColors.purpleLight,
//                 borderRadius: BorderRadius.circular(8)),
//             child: const Center(
//                 child: Text('🌸', style: TextStyle(fontSize: 15)))),
//         const SizedBox(width: 10),
//         Expanded(
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           const Text('মাহলির দিন চিহ্নিত',
//               style: TextStyle(
//                   color: AmolColors.purple,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w700)),
//           const SizedBox(height: 2),
//           Text('$exemptCount দিন মাফ — নামাজ ও রোজার হিসাব বাদ দেওয়া হয়েছে',
//               style: TextStyle(
//                   color: AmolColors.purple.withOpacity(0.7),
//                   fontSize: 10,
//                   fontWeight: FontWeight.w500)),
//         ])),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // STAT STRIP
// // ─────────────────────────────────────────────────────────────────────────────

// class _StatStrip extends StatelessWidget {
//   final MonthlyTracker? tracker;
//   final String userGender;
//   const _StatStrip({this.tracker, required this.userGender});

//   @override
//   Widget build(BuildContext context) {
//     final streak = tracker?.streakDays ?? 0;
//     final daysActive = tracker?.daysActive ?? 0;
//     final farzDays = tracker?.farzCompletedDays ?? 0;
//     final jamaat = tracker?.congregationDaysSum ?? 0;
//     final eligible = tracker?.eligibleDays ?? 0;
//     final exemptDays = tracker?.exemptDays ?? 0;
//     final isFemale = userGender == 'female';

//     return Column(children: [
//       Padding(
//         padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//         child: Row(children: [
//           Expanded(
//               child: _StatCard(
//                   emoji: '🔥',
//                   emojiBg: AmolColors.amberLight,
//                   value: '$streak',
//                   label: 'স্ট্রিক দিন',
//                   valueColor: AmolColors.amber)),
//           const SizedBox(width: 8),
//           Expanded(
//               child: _StatCard(
//                   emoji: '📅',
//                   emojiBg: AmolColors.greenLight,
//                   value: '$daysActive',
//                   label: 'আমল করা দিন',
//                   valueColor: AmolColors.green)),
//           const SizedBox(width: 8),
//           Expanded(
//               child: _StatCard(
//                   emoji: '✅',
//                   emojiBg: AmolColors.greenLight,
//                   value: '$farzDays',
//                   label: 'পূর্ণ ফরজ দিন',
//                   valueColor: AmolColors.darkGreen)),
//         ]),
//       ),
//       Padding(
//         padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
//         child: Row(children: [
//           Expanded(
//               child: _StatCard(
//                   emoji: '🕌',
//                   emojiBg: AmolColors.purpleLight,
//                   value: '$jamaat',
//                   label: 'জামাত দিন',
//                   valueColor: AmolColors.purple)),
//           const SizedBox(width: 8),
//           Expanded(
//               child: _StatCard(
//                   emoji: '⏳',
//                   emojiBg: AmolColors.greenLight,
//                   value: '$eligible',
//                   label: 'হিসাবের দিন',
//                   valueColor: AmolColors.green)),
//           const SizedBox(width: 8),
//           if (isFemale)
//             Expanded(
//                 child: _StatCard(
//                     emoji: '🌸',
//                     emojiBg: AmolColors.purplePale,
//                     value: '$exemptDays',
//                     label: 'মাহলির দিন',
//                     valueColor: AmolColors.purple))
//           else
//             Expanded(
//                 child: _StatCard(
//                     emoji: '🏅',
//                     emojiBg: AmolColors.goldLight,
//                     value: tracker?.rank != null ? '#${tracker!.rank}' : '---',
//                     label: 'র‍্যাংক',
//                     valueColor: AmolColors.gold)),
//         ]),
//       ),
//     ]);
//   }
// }

// class _StatCard extends StatelessWidget {
//   final String emoji, value, label;
//   final Color emojiBg, valueColor;
//   const _StatCard(
//       {required this.emoji,
//       required this.emojiBg,
//       required this.value,
//       required this.label,
//       required this.valueColor});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(11),
//       decoration: BoxDecoration(
//           color: AmolColors.cardBg,
//           borderRadius: BorderRadius.circular(13),
//           border: Border.all(color: AmolColors.border, width: 0.5)),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Container(
//             width: 28,
//             height: 28,
//             decoration: BoxDecoration(
//                 color: emojiBg, borderRadius: BorderRadius.circular(7)),
//             child: Center(
//                 child: Text(emoji, style: const TextStyle(fontSize: 13)))),
//         const SizedBox(height: 7),
//         FittedBox(
//             fit: BoxFit.scaleDown,
//             alignment: Alignment.centerLeft,
//             child: Text(value,
//                 style: TextStyle(
//                     color: valueColor,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 19,
//                     letterSpacing: -0.4,
//                     height: 1))),
//         const SizedBox(height: 2),
//         Text(label,
//             style: const TextStyle(
//                 color: AmolColors.textSecondary,
//                 fontSize: 9.5,
//                 fontWeight: FontWeight.w500)),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // FARD PERFORMANCE
// // ─────────────────────────────────────────────────────────────────────────────

// class _FardSection extends StatelessWidget {
//   final MonthlyTracker tracker;
//   const _FardSection({required this.tracker});

//   @override
//   Widget build(BuildContext context) {
//     final pct = tracker.completionPercentage.clamp(0.0, 100.0);
//     final farzDays = tracker.farzCompletedDays;
//     final eligible = tracker.eligibleDays;
//     final jamaat = tracker.congregationDaysSum;

//     Color statusColor() {
//       if (pct >= 90) return AmolColors.green;
//       if (pct >= 70) return AmolColors.amber;
//       return AmolColors.red;
//     }

//     String statusLabel() {
//       if (pct >= 90) return 'চমৎকার';
//       if (pct >= 70) return 'ভালো';
//       if (pct >= 50) return 'মাঝামাঝি';
//       return 'উন্নতি দরকার';
//     }

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const AmolSectionHeader(title: 'ফরজ পারফরম্যান্স', emoji: '🕌'),
//         const SizedBox(height: 10),
//         Row(children: [
//           Expanded(
//               child: _FardCard(
//             title: 'পূর্ণ ফরজ দিন',
//             bigValue: '${pct.toInt()}%',
//             subValue: '$farzDays/$eligible দিন',
//             badgeLabel: statusLabel(),
//             badgeColor: statusColor(),
//             barValue: pct / 100,
//             barColor: statusColor(),
//           )),
//           const SizedBox(width: 10),
//           Expanded(
//               child: _FardCard(
//             title: 'মোট জামাত',
//             bigValue: '$jamaat',
//             subValue: '৫ ওয়াক্ত × দিন মিলিয়ে',
//             badgeLabel: jamaat > 0 ? 'জামাতে পড়া হয়েছে' : 'কোনো জামাত নেই',
//             badgeColor: jamaat > 0 ? AmolColors.purple : AmolColors.textHint,
//             barValue:
//                 eligible > 0 ? (jamaat / (eligible * 5)).clamp(0.0, 1.0) : 0,
//             barColor: AmolColors.purple,
//           )),
//         ]),
//       ]),
//     );
//   }
// }

// class _FardCard extends StatelessWidget {
//   final String title, bigValue, subValue, badgeLabel;
//   final Color badgeColor, barColor;
//   final double barValue;
//   const _FardCard(
//       {required this.title,
//       required this.bigValue,
//       required this.subValue,
//       required this.badgeLabel,
//       required this.badgeColor,
//       required this.barColor,
//       required this.barValue});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//           color: AmolColors.cardBg,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: AmolColors.border, width: 0.5)),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Expanded(
//               child: Text(title,
//                   style: const TextStyle(
//                       color: AmolColors.textPrimary,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w700))),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//             decoration: BoxDecoration(
//                 color: badgeColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(20)),
//             child: Text(badgeLabel,
//                 style: TextStyle(
//                     color: badgeColor,
//                     fontSize: 8.5,
//                     fontWeight: FontWeight.w700)),
//           ),
//         ]),
//         const SizedBox(height: 8),
//         FittedBox(
//             fit: BoxFit.scaleDown,
//             alignment: Alignment.centerLeft,
//             child: Text(bigValue,
//                 style: TextStyle(
//                     color: badgeColor,
//                     fontSize: 22,
//                     fontWeight: FontWeight.w900,
//                     height: 1))),
//         const SizedBox(height: 2),
//         Text(subValue,
//             style: const TextStyle(color: AmolColors.textHint, fontSize: 9.5)),
//         const SizedBox(height: 8),
//         ClipRRect(
//             borderRadius: BorderRadius.circular(99),
//             child: LinearProgressIndicator(
//                 value: barValue.clamp(0.0, 1.0),
//                 minHeight: 5,
//                 backgroundColor: AmolColors.pageBg,
//                 valueColor: AlwaysStoppedAnimation(barColor))),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // WEEKLY CHART
// // ─────────────────────────────────────────────────────────────────────────────

// class _WeeklyChartSection extends StatelessWidget {
//   final List<WeeklyDayProgress> weekData;
//   final String userGender;
//   const _WeeklyChartSection({required this.weekData, required this.userGender});

//   @override
//   Widget build(BuildContext context) {
//     if (weekData.isEmpty) return const SizedBox.shrink();

//     final isFemale = userGender == 'female';
//     final today = DateTime.now();
//     final activeDays = weekData.where((d) => d.hasActivity).length;
//     final exemptCnt = weekData.where((d) => d.isExemptDay).length;

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const AmolSectionHeader(title: 'এই সপ্তাহের অগ্রগতি', emoji: '📊'),
//         const SizedBox(height: 10),
//         Container(
//           padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
//           decoration: BoxDecoration(
//               color: AmolColors.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: AmolColors.border, width: 0.5)),
//           child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 LayoutBuilder(builder: (ctx, constraints) {
//                   final chartH =
//                       (constraints.maxWidth * 0.36).clamp(80.0, 140.0);
//                   const dayLblH = 14.0;
//                   const gapH = 8.0;
//                   final barAreaH =
//                       (chartH - dayLblH - gapH).clamp(20.0, chartH);

//                   return SizedBox(
//                     height: chartH,
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: weekData.map((d) {
//                         final dayDate = DateTime.tryParse(d.date);
//                         final isToday = dayDate != null &&
//                             dayDate.year == today.year &&
//                             dayDate.month == today.month &&
//                             dayDate.day == today.day;
//                         final showExempt = d.isExemptDay && isFemale;

//                         Color barColor;
//                         double barH;
//                         if (showExempt) {
//                           barColor = AmolColors.purple;
//                           barH = barAreaH * 0.5;
//                         } else if (d.hasActivity) {
//                           barColor =
//                               isToday ? AmolColors.darkGreen : AmolColors.green;
//                           barH = barAreaH;
//                         } else {
//                           barColor = AmolColors.border;
//                           barH = barAreaH * 0.12;
//                         }

//                         return Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 3),
//                             child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   if (d.hasActivity && !showExempt)
//                                     Container(
//                                       width: 5,
//                                       height: 5,
//                                       margin: const EdgeInsets.only(bottom: 3),
//                                       decoration: BoxDecoration(
//                                           color: isToday
//                                               ? AmolColors.darkGreen
//                                               : AmolColors.green,
//                                           shape: BoxShape.circle),
//                                     )
//                                   else
//                                     const SizedBox(height: 8),
//                                   if (showExempt)
//                                     Container(
//                                       height: barH,
//                                       decoration: BoxDecoration(
//                                         color: AmolColors.purpleLight,
//                                         borderRadius: BorderRadius.circular(4),
//                                         border: Border.all(
//                                             color: AmolColors.purple
//                                                 .withOpacity(0.3),
//                                             width: 0.5),
//                                       ),
//                                       child: const Center(
//                                           child: Text('🌸',
//                                               style: TextStyle(fontSize: 8))),
//                                     )
//                                   else
//                                     AnimatedContainer(
//                                       duration: 400.ms,
//                                       height: barH,
//                                       decoration: BoxDecoration(
//                                         color: barColor,
//                                         borderRadius:
//                                             const BorderRadius.vertical(
//                                                 top: Radius.circular(4)),
//                                       ),
//                                     ),
//                                   const SizedBox(height: 5),
//                                   SizedBox(
//                                       height: dayLblH,
//                                       child: FittedBox(
//                                           fit: BoxFit.scaleDown,
//                                           child: Text(d.day,
//                                               style: TextStyle(
//                                                   fontSize: 9,
//                                                   color: isToday
//                                                       ? AmolColors.darkGreen
//                                                       : AmolColors
//                                                           .textSecondary,
//                                                   fontWeight: isToday
//                                                       ? FontWeight.w800
//                                                       : FontWeight.w500)))),
//                                 ]),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   );
//                 }),
//                 const SizedBox(height: 10),
//                 const Divider(
//                     height: 1, thickness: 0.5, color: AmolColors.border),
//                 const SizedBox(height: 10),
//                 Row(children: [
//                   _WeekChip(
//                       label: 'সক্রিয় দিন',
//                       value: '$activeDays/7',
//                       color: AmolColors.green),
//                   const SizedBox(width: 8),
//                   _WeekChip(
//                       label: 'বাকি দিন',
//                       value: '${7 - activeDays - exemptCnt}',
//                       color: AmolColors.textSecondary),
//                   if (isFemale && exemptCnt > 0) ...[
//                     const SizedBox(width: 8),
//                     _WeekChip(
//                         label: 'মাহলি',
//                         value: '$exemptCnt',
//                         color: AmolColors.purple),
//                   ],
//                 ]),
//                 const SizedBox(height: 10),
//                 Wrap(spacing: 12, runSpacing: 4, children: [
//                   AmolLegendDot(
//                       color: AmolColors.green, label: 'আমল করা হয়েছে'),
//                   AmolLegendDot(
//                       color: AmolColors.border, label: 'কোনো আমল নেই'),
//                   if (isFemale)
//                     AmolLegendDot(
//                         color: AmolColors.purpleLight, label: 'মাহলির দিন'),
//                 ]),
//               ]),
//         ),
//       ]),
//     );
//   }
// }

// class _WeekChip extends StatelessWidget {
//   final String label, value;
//   final Color color;
//   const _WeekChip(
//       {required this.label, required this.value, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
//         decoration: BoxDecoration(
//             color: AmolColors.pageBg, borderRadius: BorderRadius.circular(8)),
//         child: Column(children: [
//           FittedBox(
//               fit: BoxFit.scaleDown,
//               child: Text(value,
//                   style: TextStyle(
//                       color: color,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w800,
//                       height: 1))),
//           const SizedBox(height: 2),
//           FittedBox(
//               fit: BoxFit.scaleDown,
//               child: Text(label,
//                   style: const TextStyle(
//                       color: AmolColors.textHint, fontSize: 8.5),
//                   textAlign: TextAlign.center)),
//         ]),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // TODAY PRAYER BREAKDOWN — Wrap ব্যবহার করে ফিক্স, প্রতিটা আইটেম fixed-width
// // SizedBox এ থাকে, তাই ছোট স্ক্রিনে স্বয়ংক্রিয়ভাবে পরের লাইনে চলে যায়,
// // লেবেল কখনো একটার সাথে আরেকটা মিশে যাবে না।
// // ─────────────────────────────────────────────────────────────────────────────

// class _TodayPrayerSection extends StatelessWidget {
//   final List<PrayerBreakdownItem> prayers;
//   const _TodayPrayerSection({required this.prayers});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const AmolSectionHeader(title: 'আজকের নামাজের অবস্থা', emoji: '🕌'),
//         const SizedBox(height: 10),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
//           decoration: BoxDecoration(
//               color: AmolColors.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: AmolColors.border, width: 0.5)),
//           child: Wrap(
//             alignment: WrapAlignment.spaceEvenly,
//             runSpacing: 14,
//             spacing: 4,
//             children: prayers.map((p) {
//               Color color;
//               IconData icon;
//               String label;

//               if (p.mode == null) {
//                 color = AmolColors.textHint;
//                 icon = Icons.radio_button_unchecked_rounded;
//                 label = 'বাকি';
//               } else if (p.mode == PrayerMode.congregation) {
//                 color = AmolColors.green;
//                 icon = Icons.people_rounded;
//                 label = 'জামাত';
//               } else if (p.mode == PrayerMode.solo) {
//                 color = AmolColors.amber;
//                 icon = Icons.person_rounded;
//                 label = 'একাকী';
//               } else {
//                 color = AmolColors.red;
//                 icon = Icons.close_rounded;
//                 label = 'মিস';
//               }

//               return SizedBox(
//                 width: 60,
//                 child: Column(mainAxisSize: MainAxisSize.min, children: [
//                   Container(
//                     width: 38,
//                     height: 38,
//                     decoration: BoxDecoration(
//                         color: color.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                             color: color.withOpacity(0.3), width: 0.5)),
//                     child: Icon(icon, color: color, size: 18),
//                   ),
//                   const SizedBox(height: 5),
//                   FittedBox(
//                     fit: BoxFit.scaleDown,
//                     child: Text(p.nameBn,
//                         maxLines: 1,
//                         style: const TextStyle(
//                             color: AmolColors.textPrimary,
//                             fontSize: 10,
//                             fontWeight: FontWeight.w700)),
//                   ),
//                   const SizedBox(height: 2),
//                   FittedBox(
//                     fit: BoxFit.scaleDown,
//                     child: Text(label,
//                         maxLines: 1,
//                         style: TextStyle(
//                             color: color,
//                             fontSize: 8.5,
//                             fontWeight: FontWeight.w600)),
//                   ),
//                 ]),
//               );
//             }).toList(),
//           ),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // COMPARE METRIC — multi-metric monthly comparison
// // ─────────────────────────────────────────────────────────────────────────────

// enum _CompareMetric {
//   completion,
//   farz,
//   congregation,
//   quran,
//   dhikr,
//   fasting,
//   akhlaq,
//   streak
// }

// extension _CompareMetricX on _CompareMetric {
//   String get labelBn {
//     switch (this) {
//       case _CompareMetric.completion:
//         return 'সম্পন্ন %';
//       case _CompareMetric.farz:
//         return 'পূর্ণ ফরজ দিন';
//       case _CompareMetric.congregation:
//         return 'জামাত দিন';
//       case _CompareMetric.quran:
//         return 'কুরআন আয়াত';
//       case _CompareMetric.dhikr:
//         return 'যিকর স্কোর';
//       case _CompareMetric.fasting:
//         return 'নফল রোজা';
//       case _CompareMetric.akhlaq:
//         return 'আখলাক দিন';
//       case _CompareMetric.streak:
//         return 'স্ট্রিক দিন';
//     }
//   }

//   String get emoji {
//     switch (this) {
//       case _CompareMetric.completion:
//         return '✅';
//       case _CompareMetric.farz:
//         return '🕌';
//       case _CompareMetric.congregation:
//         return '🤝';
//       case _CompareMetric.quran:
//         return '📖';
//       case _CompareMetric.dhikr:
//         return '📿';
//       case _CompareMetric.fasting:
//         return '🌙';
//       case _CompareMetric.akhlaq:
//         return '🤲';
//       case _CompareMetric.streak:
//         return '🔥';
//     }
//   }

//   double valueOf(MonthlyTracker t) {
//     switch (this) {
//       case _CompareMetric.completion:
//         return t.completionPercentage;
//       case _CompareMetric.farz:
//         return t.farzCompletedDays.toDouble();
//       case _CompareMetric.congregation:
//         return t.congregationDaysSum.toDouble();
//       case _CompareMetric.quran:
//         return t.quranAyahTotal.toDouble();
//       case _CompareMetric.dhikr:
//         return t.dhikrScore.toDouble();
//       case _CompareMetric.fasting:
//         return t.fastingDays.toDouble();
//       case _CompareMetric.akhlaq:
//         return t.akhlaqDays.toDouble();
//       case _CompareMetric.streak:
//         return t.streakDays.toDouble();
//     }
//   }

//   String display(MonthlyTracker t) => this == _CompareMetric.completion
//       ? '${valueOf(t).toInt()}%'
//       : '${valueOf(t).toInt()}';
// }

// class _PrevMonthsSection extends StatefulWidget {
//   final List<MonthlyTracker> months;
//   const _PrevMonthsSection({required this.months});

//   @override
//   State<_PrevMonthsSection> createState() => _PrevMonthsSectionState();
// }

// class _PrevMonthsSectionState extends State<_PrevMonthsSection> {
//   _CompareMetric _metric = _CompareMetric.completion;

//   @override
//   Widget build(BuildContext context) {
//     final months = widget.months;
//     if (months.isEmpty) return const SizedBox.shrink();
//     final current = months.last;

//     final maxVal = months
//         .map((m) => _metric.valueOf(m))
//         .fold<double>(0, (a, b) => b > a ? b : a);
//     final safeMax = maxVal <= 0 ? 1.0 : maxVal;

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const AmolSectionHeader(title: 'মাসিক তুলনা', emoji: '📈'),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: 34,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             children: _CompareMetric.values
//                 .map((m) => Padding(
//                       padding: const EdgeInsets.only(right: 6),
//                       child: AmolFilterChip(
//                         label: m.labelBn,
//                         emoji: m.emoji,
//                         selected: _metric == m,
//                         onTap: () => setState(() => _metric = m),
//                       ),
//                     ))
//                 .toList(),
//           ),
//         ),
//         const SizedBox(height: 10),
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//               color: AmolColors.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: AmolColors.border, width: 0.5)),
//           child: Column(children: [
//             LayoutBuilder(builder: (ctx, constraints) {
//               final chartH = (constraints.maxWidth * 0.36).clamp(90.0, 150.0);
//               const valLblH = 14.0;
//               const mthLblH = 12.0;
//               const gapH = 8.0;
//               final barAreaH =
//                   (chartH - valLblH - mthLblH - gapH).clamp(16.0, chartH);

//               return SizedBox(
//                 height: chartH,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: months.map((m) {
//                     final isActive =
//                         m.year == current.year && m.month == current.month;
//                     final val = _metric.valueOf(m);
//                     final fillH = val > 0
//                         ? ((val / safeMax) * barAreaH).clamp(4.0, barAreaH)
//                         : 4.0;
//                     final mName = AppConstants.bengaliMonths[m.month - 1];
//                     final mShort =
//                         mName.length > 3 ? mName.substring(0, 3) : mName;

//                     return Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 5),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             SizedBox(
//                               height: valLblH,
//                               child: FittedBox(
//                                 fit: BoxFit.scaleDown,
//                                 child: Text(_metric.display(m),
//                                     style: TextStyle(
//                                         fontSize: 9,
//                                         color: isActive
//                                             ? AmolColors.darkGreen
//                                             : AmolColors.textHint,
//                                         fontWeight: isActive
//                                             ? FontWeight.w800
//                                             : FontWeight.w500)),
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             AnimatedContainer(
//                               duration: 400.ms,
//                               height: fillH,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 color: val > 0
//                                     ? (isActive
//                                         ? AmolColors.darkGreen
//                                         : AmolColors.midGreen.withOpacity(0.5))
//                                     : AmolColors.pageBg,
//                                 borderRadius: const BorderRadius.vertical(
//                                     top: Radius.circular(6)),
//                                 border: val > 0
//                                     ? null
//                                     : Border.all(
//                                         color: AmolColors.border, width: 0.5),
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             SizedBox(
//                               height: mthLblH,
//                               child: FittedBox(
//                                 fit: BoxFit.scaleDown,
//                                 child: Text(mShort,
//                                     style: TextStyle(
//                                         fontSize: 9,
//                                         color: isActive
//                                             ? AmolColors.darkGreen
//                                             : AmolColors.textSecondary,
//                                         fontWeight: isActive
//                                             ? FontWeight.w800
//                                             : FontWeight.w500)),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               );
//             }),
//             if (months.length >= 2) ...[
//               const SizedBox(height: 12),
//               const Divider(
//                   height: 1, thickness: 0.5, color: AmolColors.border),
//               const SizedBox(height: 10),
//               _TrendLine(months: months, metric: _metric),
//             ],
//           ]),
//         ),
//       ]),
//     );
//   }
// }

// class _TrendLine extends StatelessWidget {
//   final List<MonthlyTracker> months;
//   final _CompareMetric metric;
//   const _TrendLine({required this.months, required this.metric});

//   @override
//   Widget build(BuildContext context) {
//     final current = months.last;
//     final prev = months[months.length - 2];
//     final curVal = metric.valueOf(current);
//     final prevVal = metric.valueOf(prev);
//     final diff = curVal - prevVal;
//     final isUp = diff > 0;
//     final isSame = diff == 0;

//     return Row(children: [
//       Icon(
//         isSame
//             ? Icons.remove_rounded
//             : (isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded),
//         size: 16,
//         color: isSame
//             ? AmolColors.textHint
//             : (isUp ? AmolColors.green : AmolColors.red),
//       ),
//       const SizedBox(width: 6),
//       Expanded(
//         child: Text(
//           isSame
//               ? 'গত মাসের সমান'
//               : '${metric.labelBn} গত মাসের তুলনায় ${isUp ? "বেড়েছে" : "কমেছে"} ${diff.abs().toInt()}${metric == _CompareMetric.completion ? "%" : ""}',
//           style: TextStyle(
//               color: isSame
//                   ? AmolColors.textHint
//                   : (isUp ? AmolColors.green : AmolColors.red),
//               fontSize: 11,
//               fontWeight: FontWeight.w600),
//         ),
//       ),
//     ]);
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
//     final farzDays = tracker.farzCompletedDays;
//     final jamaat = tracker.congregationDaysSum;

//     String rankLabel() {
//       if (rank <= 1) return 'সর্বোচ্চ অবস্থানে আছেন!';
//       if (rank <= 3) return 'শীর্ষ ৩ জনের মধ্যে!';
//       if (rank <= 10) return 'শীর্ষ ১০ জনের মধ্যে';
//       return 'র‍্যাংক #$rank তে আছেন';
//     }

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const AmolSectionHeader(title: 'লিডারবোর্ড অবস্থান', emoji: '🏅'),
//         const SizedBox(height: 10),
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//               color: AmolColors.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: AmolColors.border, width: 0.5)),
//           child: Row(children: [
//             Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                     color: AmolColors.greenLight,
//                     borderRadius: BorderRadius.circular(14)),
//                 child: Center(
//                     child: FittedBox(
//                         fit: BoxFit.scaleDown,
//                         child: Padding(
//                             padding: const EdgeInsets.all(4),
//                             child: Text('#$rank',
//                                 style: const TextStyle(
//                                     color: AmolColors.darkGreen,
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.w900)))))),
//             const SizedBox(width: 14),
//             Expanded(
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                   Text(rankLabel(),
//                       style: const TextStyle(
//                           color: AmolColors.textPrimary,
//                           fontSize: 13,
//                           fontWeight: FontWeight.w700)),
//                   const SizedBox(height: 3),
//                   Text(
//                       'সম্পন্ন ${pct.toInt()}% · $farzDays পূর্ণ ফরজ দিন · $jamaat জামাত',
//                       style: const TextStyle(
//                           color: AmolColors.textSecondary,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w500)),
//                   const SizedBox(height: 8),
//                   ClipRRect(
//                       borderRadius: BorderRadius.circular(99),
//                       child: LinearProgressIndicator(
//                           value: pct / 100,
//                           minHeight: 5,
//                           backgroundColor: AmolColors.pageBg,
//                           valueColor: const AlwaysStoppedAnimation(
//                               AmolColors.darkGreen))),
//                 ])),
//             if (tracker.isWinner) ...[
//               const SizedBox(width: 12),
//               Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                       color: AmolColors.goldLight,
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                           color: AmolColors.gold.withOpacity(0.3), width: 0.5)),
//                   child: const Text('🏆', style: TextStyle(fontSize: 22))),
//             ],
//           ]),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // HEATMAP
// // ─────────────────────────────────────────────────────────────────────────────

// class _HeatmapCalendar extends StatelessWidget {
//   final int year, month;
//   final List<DailyEntry> entries;
//   final String userGender;
//   const _HeatmapCalendar(
//       {required this.year,
//       required this.month,
//       required this.entries,
//       required this.userGender});

//   @override
//   Widget build(BuildContext context) {
//     final daysInMonth = DateUtils.getDaysInMonth(year, month);
//     final entryMap = {for (final e in entries) e.day: e};
//     final today = DateTime.now();
//     final firstDay = DateTime(year, month, 1).weekday % 7;
//     final totalCells = ((firstDay + daysInMonth) / 7).ceil() * 7;
//     final isFemale = userGender == 'female';

//     int _intensity(DailyEntry e) {
//       int score = 0;
//       for (final item in e.entries) {
//         if (item.prayerMode == PrayerMode.congregation) {
//           score += 2;
//         } else if (item.prayerMode == PrayerMode.solo) {
//           score += 1;
//         } else if (item.completed || item.count > 0) {
//           score += 1;
//         }
//       }
//       return score;
//     }

//     final maxScore = entries.isEmpty
//         ? 1
//         : entries
//             .map(_intensity)
//             .fold(0, (a, b) => a > b ? a : b)
//             .clamp(1, 999);

//     const weekdays = ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহঃ', 'শুক্র', 'শনি'];

//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//           color: AmolColors.cardBg,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: AmolColors.border, width: 0.5)),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(
//             children: weekdays
//                 .map((d) => Expanded(
//                     child: Center(
//                         child: Text(d,
//                             style: const TextStyle(
//                                 color: AmolColors.textHint,
//                                 fontSize: 9.5,
//                                 fontWeight: FontWeight.w500)))))
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
//             final isExempt = (entry?.isExemptDay ?? false) && isFemale;
//             final hasAct = entry?.hasActivity ?? false;
//             final score = entry != null ? _intensity(entry) : 0;
//             final intensity = score / maxScore;
//             final isToday = today.year == year &&
//                 today.month == month &&
//                 today.day == dayNum;
//             final isFuture = DateTime(year, month, dayNum).isAfter(today);

//             Color cellColor;
//             Color numColor;

//             if (isExempt) {
//               cellColor = AmolColors.purplePale;
//               numColor = AmolColors.purple;
//             } else if (isFuture) {
//               cellColor = AmolColors.pageBg;
//               numColor = AmolColors.textHint;
//             } else if (!hasAct) {
//               cellColor = AmolColors.greenLight.withOpacity(0.4);
//               numColor = AmolColors.textHint;
//             } else if (intensity < 0.25) {
//               cellColor = AmolColors.green.withOpacity(0.18);
//               numColor = AmolColors.green;
//             } else if (intensity < 0.5) {
//               cellColor = AmolColors.green.withOpacity(0.38);
//               numColor = AmolColors.green;
//             } else if (intensity < 0.75) {
//               cellColor = AmolColors.green.withOpacity(0.60);
//               numColor = Colors.white;
//             } else {
//               cellColor = AmolColors.green.withOpacity(0.85);
//               numColor = Colors.white;
//             }

//             return Container(
//               decoration: BoxDecoration(
//                 color: cellColor,
//                 borderRadius: BorderRadius.circular(5),
//                 border: isToday
//                     ? Border.all(color: AmolColors.gold, width: 1.5)
//                     : null,
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
//                       const Text('🌸',
//                           style: TextStyle(fontSize: 6.5, height: 1))
//                     else if (hasAct && !isFuture)
//                       Container(
//                         width: 4,
//                         height: 4,
//                         margin: const EdgeInsets.only(top: 1),
//                         decoration: BoxDecoration(
//                             color: numColor.withOpacity(0.6),
//                             shape: BoxShape.circle),
//                       ),
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
//               style: TextStyle(color: AmolColors.textHint, fontSize: 9.5)),
//           ...List.generate(
//               5,
//               (i) => Container(
//                     width: 12,
//                     height: 12,
//                     margin: const EdgeInsets.only(right: 3),
//                     decoration: BoxDecoration(
//                         color: i == 0
//                             ? AmolColors.greenLight.withOpacity(0.4)
//                             : AmolColors.green.withOpacity(0.15 + i * 0.18),
//                         borderRadius: BorderRadius.circular(3)),
//                   )),
//           const Text('  বেশি',
//               style: TextStyle(color: AmolColors.textHint, fontSize: 9.5)),
//           if (isFemale) ...[
//             const SizedBox(width: 8),
//             Container(
//                 width: 12,
//                 height: 12,
//                 margin: const EdgeInsets.only(right: 3),
//                 decoration: BoxDecoration(
//                     color: AmolColors.purplePale,
//                     borderRadius: BorderRadius.circular(3),
//                     border: Border.all(
//                         color: AmolColors.purple.withOpacity(0.3),
//                         width: 0.5))),
//             const Text('মাহলি',
//                 style: TextStyle(color: AmolColors.textHint, fontSize: 9.5)),
//           ],
//         ]),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DAY ROW — tap করলে category-wise breakdown bottom sheet খোলে
// // ─────────────────────────────────────────────────────────────────────────────

// class _DayRow extends ConsumerWidget {
//   final DailyEntry entry;
//   final bool isLast;
//   final int delay;
//   final String userGender;
//   const _DayRow(
//       {required this.entry,
//       required this.isLast,
//       required this.delay,
//       required this.userGender});

//   void _showDayDetail(BuildContext context, WidgetRef ref) {
//     final categories = ref.read(categoriesProvider).value ?? [];
//     final catMap = {for (final c in categories) c.id: c};
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) =>
//           _DayDetailSheet(entry: entry, catMap: catMap, userGender: userGender),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isFemale = userGender == 'female';
//     final isExempt = entry.isExemptDay && isFemale;
//     final entries = entry.entries;

//     final congregation =
//         entries.where((e) => e.prayerMode == PrayerMode.congregation).length;
//     final solo = entries.where((e) => e.prayerMode == PrayerMode.solo).length;
//     final missed =
//         entries.where((e) => e.prayerMode == PrayerMode.missed).length;

//     final otherCompleted = entries
//         .where((e) => e.prayerMode == null && (e.completed || e.count > 0))
//         .length;

//     final totalCompleted = congregation + solo + otherCompleted;
//     final hasActivity = entry.hasActivity;

//     String monthShort(int idx) {
//       final s = AppConstants.bengaliMonths[idx];
//       return s.length >= 3 ? s.substring(0, 3) : s;
//     }

//     final prayerTotal = congregation + solo + missed;
//     final progressVal = prayerTotal > 0
//         ? congregation / prayerTotal
//         : hasActivity
//             ? 0.5
//             : 0.0;

//     Color barColor = isExempt
//         ? AmolColors.purple
//         : congregation >= 3
//             ? AmolColors.green
//             : congregation >= 1
//                 ? AmolColors.amber
//                 : AmolColors.border;

//     return InkWell(
//       onTap: () => _showDayDetail(context, ref),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
//         decoration: BoxDecoration(
//           color: isExempt
//               ? AmolColors.purplePale.withOpacity(0.4)
//               : hasActivity
//                   ? AmolColors.greenLight.withOpacity(0.15)
//                   : Colors.transparent,
//           border: isLast
//               ? null
//               : const Border(
//                   bottom: BorderSide(color: AmolColors.border, width: 0.5)),
//           borderRadius: isLast
//               ? const BorderRadius.vertical(bottom: Radius.circular(16))
//               : null,
//         ),
//         child: Row(children: [
//           Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               gradient: isExempt
//                   ? const LinearGradient(
//                       colors: [AmolColors.purple, Color(0xFF9B6BE8)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight)
//                   : hasActivity
//                       ? const LinearGradient(
//                           colors: [AmolColors.darkGreen, AmolColors.midGreen],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight)
//                       : null,
//               color: isExempt || hasActivity ? null : AmolColors.pageBg,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child:
//                 Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//               Text('${entry.day}',
//                   style: TextStyle(
//                       color: isExempt || hasActivity
//                           ? Colors.white
//                           : AmolColors.textHint,
//                       fontWeight: FontWeight.w800,
//                       fontSize: 15,
//                       height: 1)),
//               Text(monthShort(entry.month - 1),
//                   style: TextStyle(
//                       color: isExempt || hasActivity
//                           ? Colors.white.withOpacity(0.6)
//                           : AmolColors.textHint,
//                       fontSize: 8.5)),
//             ]),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                 Row(children: [
//                   Flexible(
//                       child: Text(
//                           isExempt
//                               ? 'মাহলির দিন'
//                               : hasActivity
//                                   ? '$totalCompleted টি আমল সম্পন্ন'
//                                   : 'কোনো আমল নেই',
//                           style: TextStyle(
//                               color: isExempt
//                                   ? AmolColors.purple
//                                   : hasActivity
//                                       ? AmolColors.textPrimary
//                                       : AmolColors.textSecondary,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 12),
//                           overflow: TextOverflow.ellipsis)),
//                   if (congregation > 0) ...[
//                     const SizedBox(width: 5),
//                     _Pill(
//                         text: '🕌 $congregation জামাত',
//                         bg: AmolColors.purpleLight,
//                         fg: AmolColors.purple),
//                   ] else if (solo > 0) ...[
//                     const SizedBox(width: 5),
//                     _Pill(
//                         text: '🤲 $solo একাকী',
//                         bg: AmolColors.greenLight,
//                         fg: AmolColors.green),
//                   ],
//                 ]),
//                 if (missed > 0) ...[
//                   const SizedBox(height: 3),
//                   _Pill(
//                       text: '⚠️ $missed মিস',
//                       bg: AmolColors.redLight,
//                       fg: AmolColors.red),
//                 ],
//                 const SizedBox(height: 5),
//                 ClipRRect(
//                     borderRadius: BorderRadius.circular(99),
//                     child: LinearProgressIndicator(
//                         value: progressVal.clamp(0.0, 1.0),
//                         minHeight: 4,
//                         backgroundColor: AmolColors.pageBg,
//                         valueColor: AlwaysStoppedAnimation(barColor))),
//               ])),
//           const SizedBox(width: 10),
//           Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
//             if (isExempt)
//               const Text('🌸', style: TextStyle(fontSize: 18))
//             else if (congregation >= 4)
//               const Icon(Icons.star_rounded, color: AmolColors.gold, size: 22)
//             else if (congregation >= 1 || solo >= 1)
//               const Icon(Icons.check_circle_rounded,
//                   color: AmolColors.green, size: 22)
//             else if (hasActivity)
//               const Icon(Icons.circle_outlined,
//                   color: AmolColors.amber, size: 22)
//             else
//               const Icon(Icons.remove_circle_outline_rounded,
//                   color: AmolColors.border, size: 22),
//             const SizedBox(height: 2),
//             Text(
//                 isExempt
//                     ? 'মাফ'
//                     : congregation >= 4
//                         ? 'পূর্ণ'
//                         : congregation >= 1
//                             ? 'আংশিক'
//                             : hasActivity
//                                 ? 'কিছু'
//                                 : 'শূন্য',
//                 style: const TextStyle(
//                     color: AmolColors.textHint,
//                     fontSize: 8.5,
//                     fontWeight: FontWeight.w500)),
//             const SizedBox(height: 4),
//             const Icon(Icons.chevron_right_rounded,
//                 color: AmolColors.textHint, size: 16),
//           ]),
//         ]),
//       ),
//     )
//         .animate(delay: Duration(milliseconds: delay))
//         .fadeIn(duration: 240.ms)
//         .slideX(begin: 0.04, curve: Curves.easeOut);
//   }
// }

// class _Pill extends StatelessWidget {
//   final String text;
//   final Color bg, fg;
//   const _Pill({required this.text, required this.bg, required this.fg});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//       decoration:
//           BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
//       child: Text(text,
//           style:
//               TextStyle(color: fg, fontSize: 9, fontWeight: FontWeight.w700)),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DAY DETAIL SHEET — category wise real breakdown, AmolIcon ব্যবহার করে
// // ─────────────────────────────────────────────────────────────────────────────

// class _DayDetailSheet extends StatelessWidget {
//   final DailyEntry entry;
//   final Map<String, AmalCategory> catMap;
//   final String userGender;
//   const _DayDetailSheet(
//       {required this.entry, required this.catMap, required this.userGender});

//   @override
//   Widget build(BuildContext context) {
//     final isFemale = userGender == 'female';
//     final isExempt = entry.isExemptDay && isFemale;
//     final items = entry.entries
//         .where((e) => catMap.containsKey(e.categoryId))
//         .map((e) => MapEntry(catMap[e.categoryId]!, e))
//         .toList()
//       ..sort((a, b) => a.key.order.compareTo(b.key.order));

//     return DraggableScrollableSheet(
//       initialChildSize: 0.6,
//       minChildSize: 0.35,
//       maxChildSize: 0.9,
//       expand: false,
//       builder: (context, scrollController) => Container(
//         decoration: const BoxDecoration(
//           color: AmolColors.cardBg,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//         ),
//         child: Column(children: [
//           const SizedBox(height: 12),
//           Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                   color: AmolColors.border,
//                   borderRadius: BorderRadius.circular(99))),
//           const SizedBox(height: 16),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(children: [
//               Expanded(
//                 child: Text('${entry.day} তারিখের বিস্তারিত',
//                     style: const TextStyle(
//                         color: AmolColors.textPrimary,
//                         fontWeight: FontWeight.w800,
//                         fontSize: 15)),
//               ),
//               if (isExempt)
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                       color: AmolColors.purplePale,
//                       borderRadius: BorderRadius.circular(20)),
//                   child: const Text('🌸 মাহলি',
//                       style: TextStyle(
//                           color: AmolColors.purple,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w700)),
//                 ),
//             ]),
//           ),
//           const SizedBox(height: 14),
//           Expanded(
//             child: items.isEmpty
//                 ? const Center(
//                     child: Text('এই দিনে কোনো আমল লগ করা হয়নি',
//                         style: TextStyle(
//                             color: AmolColors.textHint, fontSize: 12)))
//                 : ListView.separated(
//                     controller: scrollController,
//                     padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
//                     itemCount: items.length,
//                     separatorBuilder: (_, __) => const Divider(
//                         height: 18, color: AmolColors.border, thickness: 0.5),
//                     itemBuilder: (ctx, i) => _DayDetailRow(
//                         category: items[i].key, item: items[i].value),
//                   ),
//           ),
//         ]),
//       ),
//     );
//   }
// }

// class _DayDetailRow extends StatelessWidget {
//   final AmalCategory category;
//   final DailyEntryItem item;
//   const _DayDetailRow({required this.category, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     final isFardPrayer = category.isFard && category.isPrayer;
//     String statusText;
//     Color statusColor;
//     IconData statusIcon;

//     if (isFardPrayer) {
//       switch (item.prayerMode) {
//         case PrayerMode.congregation:
//           statusText = 'জামাতে আদায়';
//           statusColor = AmolColors.purple;
//           statusIcon = Icons.people_rounded;
//           break;
//         case PrayerMode.solo:
//           statusText = 'একাকী আদায়';
//           statusColor = AmolColors.amber;
//           statusIcon = Icons.person_rounded;
//           break;
//         case PrayerMode.missed:
//         default:
//           statusText = 'মিস করেছেন';
//           statusColor = AmolColors.red;
//           statusIcon = Icons.close_rounded;
//       }
//     } else if (category.inputType == AmalInputType.counter ||
//         category.inputType == AmalInputType.duration) {
//       final hasVal = item.count > 0;
//       final unitBn = AmolUnit.bn(category.unit);
//       statusText = hasVal
//           ? '${item.count}${unitBn.isNotEmpty ? " $unitBn" : ""}'
//           : 'করা হয়নি';
//       statusColor = hasVal ? AmolColors.green : AmolColors.textHint;
//       statusIcon = hasVal
//           ? Icons.check_circle_rounded
//           : Icons.remove_circle_outline_rounded;
//     } else {
//       statusText = item.completed ? 'সম্পন্ন' : 'করা হয়নি';
//       statusColor = item.completed ? AmolColors.green : AmolColors.textHint;
//       statusIcon = item.completed
//           ? Icons.check_circle_rounded
//           : Icons.remove_circle_outline_rounded;
//     }

//     return Row(children: [
//       AmolIcon(category: category, size: 36),
//       const SizedBox(width: 12),
//       Expanded(
//         child: Text(category.nameBn,
//             style: const TextStyle(
//                 color: AmolColors.textPrimary,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 13)),
//       ),
//       Row(mainAxisSize: MainAxisSize.min, children: [
//         Icon(statusIcon, size: 15, color: statusColor),
//         const SizedBox(width: 5),
//         Text(statusText,
//             style: TextStyle(
//                 color: statusColor,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 11.5)),
//       ]),
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
//           color: AmolColors.cardBg,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
//       padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         Container(
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//                 color: AmolColors.border,
//                 borderRadius: BorderRadius.circular(99))),
//         const SizedBox(height: 22),
//         const Text('মাস বেছে নিন',
//             style: TextStyle(
//                 color: AmolColors.textPrimary,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700)),
//         const SizedBox(height: 18),
//         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           _YearArrow(
//               icon: Icons.chevron_left_rounded,
//               onTap: () => setState(() => _y--),
//               enabled: true),
//           Container(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//               decoration: BoxDecoration(
//                   color: AmolColors.greenLight,
//                   borderRadius: BorderRadius.circular(12)),
//               child: Text('$_y',
//                   style: const TextStyle(
//                       color: AmolColors.darkGreen,
//                       fontWeight: FontWeight.w800,
//                       fontSize: 18))),
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
//                   color: isSelected ? AmolColors.darkGreen : AmolColors.pageBg,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(
//                       color: isSelected
//                           ? AmolColors.darkGreen
//                           : isFuture
//                               ? AmolColors.border.withOpacity(0.4)
//                               : AmolColors.border,
//                       width: 0.5),
//                 ),
//                 child: Center(
//                     child: FittedBox(
//                         fit: BoxFit.scaleDown,
//                         child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 4),
//                             child: Text(AppConstants.bengaliMonths[i],
//                                 style: TextStyle(
//                                     color: isSelected
//                                         ? Colors.white
//                                         : isFuture
//                                             ? AmolColors.textHint
//                                             : AmolColors.textSecondary,
//                                     fontSize: 12,
//                                     fontWeight: isSelected
//                                         ? FontWeight.w700
//                                         : FontWeight.w500))))),
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
//           color: enabled ? AmolColors.greenLight : AmolColors.pageBg,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//               color: enabled ? AmolColors.borderMid : AmolColors.border,
//               width: 0.5),
//         ),
//         child: Icon(icon,
//             color: enabled ? AmolColors.darkGreen : AmolColors.textHint,
//             size: 20),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SKELETONS
// // ─────────────────────────────────────────────────────────────────────────────

// class _HeroBandSkeleton extends StatelessWidget {
//   const _HeroBandSkeleton();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AmolColors.darkGreen,
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
//     return Column(children: [_row(top: 12), _row(top: 8)]);
//   }

//   static Widget _row({required double top}) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(16, top, 16, 0),
//       child: Row(
//           children: List.generate(
//               3,
//               (i) => Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
//                       child: const AmolShimmerBox(height: 86, radius: 13),
//                     ),
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
//       child: AmolShimmerBox(height: height, radius: 16),
//     );
//   }
// }

// class _EntriesSkeleton extends StatelessWidget {
//   const _EntriesSkeleton();

//   @override
//   Widget build(BuildContext context) {
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       const SizedBox(height: 22),
//       const AmolShimmerBox(width: 130, height: 14, radius: 8),
//       const SizedBox(height: 12),
//       const AmolShimmerBox(height: 240, radius: 16),
//       const SizedBox(height: 22),
//       const AmolShimmerBox(width: 150, height: 14, radius: 8),
//       const SizedBox(height: 12),
//       Container(
//         decoration: BoxDecoration(
//             color: AmolColors.cardBg,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: AmolColors.border, width: 0.5)),
//         child: Column(
//             children: List.generate(
//                 5,
//                 (i) => Padding(
//                       padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
//                       child: const AmolShimmerBox(height: 64, radius: 10),
//                     ))),
//       ),
//     ]);
//   }
// // }
// import 'package:amal_tracker/features/monthly_summary/screens/category_list_screen.dart';
// import 'package:amal_tracker/features/monthly_summary/widgets/monthly_amol_shared.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/tracker_provider.dart';
// import '../models/tracker_model.dart';
// import '../../../core/constants/app_constants.dart';

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

//   void _openCategoryList() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => CategoryListScreen(year: _year, month: _month),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final params = (year: _year, month: _month);
//     final entriesAsync = ref.watch(monthlyEntriesProvider(params));
//     final progressAsync = ref.watch(progressSummaryProvider(params));

//     final monthName = AppConstants.bengaliMonths[_month - 1];
//     final now = DateTime.now();
//     final isCurrentMonth = _year == now.year && _month == now.month;

//     return Scaffold(
//       backgroundColor: AmolColors.pageBg,
//       body: RefreshIndicator(
//         color: AmolColors.darkGreen,
//         onRefresh: () async {
//           ref.invalidate(monthlyEntriesProvider(params));
//           ref.invalidate(progressSummaryProvider(params));
//           ref.invalidate(categoriesProvider);
//         },
//         child: CustomScrollView(
//           controller: _sc,
//           physics: const AlwaysScrollableScrollPhysics(),
//           slivers: [
//             // ── App Bar ────────────────────────────────────────────────────
//             SliverAppBar(
//               pinned: true,
//               expandedHeight: 0,
//               toolbarHeight: 56,
//               backgroundColor: AmolColors.darkGreen,
//               surfaceTintColor: Colors.transparent,
//               shadowColor: Colors.transparent,
//               automaticallyImplyLeading: false,
//               systemOverlayStyle: SystemUiOverlayStyle.light,
//               title: Row(children: [
//                 Container(
//                   width: 30,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(
//                         color: Colors.white.withOpacity(0.15), width: 0.5),
//                   ),
//                   child: const Icon(Icons.calendar_month_outlined,
//                       color: Colors.white, size: 15),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text('মাসিক রিপোর্ট',
//                             style: TextStyle(
//                                 color: Colors.white.withOpacity(0.55),
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w500)),
//                         Text('$monthName $_year',
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w800,
//                                 letterSpacing: -0.3,
//                                 height: 1.1)),
//                       ]),
//                 ),
//               ]),
//               actions: [
//                 GestureDetector(
//                   onTap: _showPeriodPicker,
//                   child: Container(
//                     margin: const EdgeInsets.only(right: 16),
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                           color: Colors.white.withOpacity(0.18), width: 0.5),
//                     ),
//                     child: Row(mainAxisSize: MainAxisSize.min, children: [
//                       Icon(Icons.swap_horiz_rounded,
//                           size: 13, color: Colors.white.withOpacity(0.7)),
//                       const SizedBox(width: 5),
//                       const Text('মাস বদলান',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 12)),
//                     ]),
//                   ),
//                 ),
//               ],
//             ),

//             // ── Hero Band ──────────────────────────────────────────────────
//             SliverToBoxAdapter(
//               child: progressAsync.when(
//                 loading: () => const _HeroBandSkeleton(),
//                 error: (_, __) => const _HeroBandSkeleton(),
//                 data: (p) => _HeroBand(tracker: p.currentMonth),
//               ),
//             ),

//             // ── Female Exempt Banner ───────────────────────────────────────
//             SliverToBoxAdapter(
//               child: progressAsync.whenOrNull(
//                 data: (p) {
//                   if (p.userGender != 'female') return const SizedBox.shrink();
//                   final n = p.currentMonth?.exemptDays ?? 0;
//                   if (n == 0) return const SizedBox.shrink();
//                   return _ExemptBanner(exemptCount: n);
//                 },
//               ),
//             ),

//             // ── Stat Strip ─────────────────────────────────────────────────
//             SliverToBoxAdapter(
//               child: progressAsync.when(
//                 loading: () => const _StatStripSkeleton(),
//                 error: (_, __) => const _StatStripSkeleton(),
//                 data: (p) => _StatStrip(
//                   tracker: p.currentMonth,
//                   userGender: p.userGender,
//                 ),
//               ),
//             ),

//             // ── Entry card → dedicated "সব আমল" full page (search + filter +
//             //    per-category monthly stat + tap-in detail page) ───────────
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//                 child: AmolNavEntryCard(
//                   emoji: '🗂️',
//                   title: 'সব আমল দেখুন',
//                   subtitle:
//                       '$monthName মাসের প্রতিটা আমলের বিস্তারিত ও প্রগ্রেস',
//                   onTap: _openCategoryList,
//                 ),
//               ),
//             ),

//             // ── Fard Performance ───────────────────────────────────────────
//             SliverToBoxAdapter(
//               child: progressAsync.when(
//                 loading: () => const _SectionSkeleton(height: 120),
//                 error: (_, __) => const SizedBox.shrink(),
//                 data: (p) {
//                   if (p.currentMonth == null ||
//                       p.currentMonth!.eligibleDays == 0) {
//                     return const SizedBox.shrink();
//                   }
//                   return _FardSection(tracker: p.currentMonth!);
//                 },
//               ),
//             ),

//             // ── Weekly Chart (current month only) ──────────────────────────
//             if (isCurrentMonth)
//               SliverToBoxAdapter(
//                 child: progressAsync.when(
//                   loading: () => const _SectionSkeleton(height: 160),
//                   error: (_, __) => const SizedBox.shrink(),
//                   data: (p) => _WeeklyChartSection(
//                     weekData: p.currentWeekProgress,
//                     userGender: p.userGender,
//                   ),
//                 ),
//               ),

//             // ── Prayer Today Breakdown (current month only, fixed responsive) ─
//             if (isCurrentMonth)
//               SliverToBoxAdapter(
//                 child: progressAsync.when(
//                   loading: () => const _SectionSkeleton(height: 100),
//                   error: (_, __) => const SizedBox.shrink(),
//                   data: (p) {
//                     if (p.todayPrayerBreakdown.isEmpty)
//                       return const SizedBox.shrink();
//                     return _TodayPrayerSection(prayers: p.todayPrayerBreakdown);
//                   },
//                 ),
//               ),

//             // ── Previous Months Comparison ──────────────────────────────────
//             SliverToBoxAdapter(
//               child: progressAsync.when(
//                 loading: () => const _SectionSkeleton(height: 140),
//                 error: (_, __) => const SizedBox.shrink(),
//                 data: (p) {
//                   final allMonths = p.recentMonths;
//                   if (allMonths.isEmpty) {
//                     return const Padding(
//                       padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
//                       child:
//                           AmolEmptyCard(label: 'মাসিক তুলনামূলক কোনো ডেটা নেই'),
//                     );
//                   }
//                   return _PrevMonthsSection(
//                       months: allMonths.reversed.toList());
//                 },
//               ),
//             ),

//             // ── Rank Card ──────────────────────────────────────────────────
//             SliverToBoxAdapter(
//               child: progressAsync.when(
//                 loading: () => const SizedBox.shrink(),
//                 error: (_, __) => const SizedBox.shrink(),
//                 data: (p) {
//                   if (p.currentMonth == null || p.currentMonth!.rank == null) {
//                     return const SizedBox.shrink();
//                   }
//                   return _RankSection(tracker: p.currentMonth!);
//                 },
//               ),
//             ),

//             // ── Heatmap + Day List ─────────────────────────────────────────
//             SliverPadding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
//               sliver: entriesAsync.when(
//                 loading: () =>
//                     const SliverToBoxAdapter(child: _EntriesSkeleton()),
//                 error: (_, __) => SliverToBoxAdapter(
//                     child: AmolErrorCard(
//                         onRetry: () =>
//                             ref.invalidate(monthlyEntriesProvider(params)))),
//                 data: (entries) {
//                   final userGender =
//                       progressAsync.valueOrNull?.userGender ?? 'male';
//                   return SliverList(
//                     delegate: SliverChildListDelegate([
//                       const SizedBox(height: 15),
//                       const AmolSectionHeader(
//                           title: 'দৈনিক ক্যালেন্ডার', emoji: '📅'),
//                       const SizedBox(height: 10),
//                       _HeatmapCalendar(
//                           year: _year,
//                           month: _month,
//                           entries: entries,
//                           userGender: userGender),
//                       const SizedBox(height: 22),
//                       const AmolSectionHeader(
//                           title: 'দিন অনুযায়ী বিস্তারিত', emoji: '📋'),
//                       const SizedBox(height: 3),
//                       const Padding(
//                         padding: EdgeInsets.only(bottom: 8),
//                         child: Text('যেকোনো দিনে ট্যাপ করে বিস্তারিত দেখুন',
//                             style: TextStyle(
//                                 color: AmolColors.textHint,
//                                 fontSize: 10.5,
//                                 fontWeight: FontWeight.w500)),
//                       ),
//                       if (entries.isEmpty)
//                         AmolEmptyCard(label: '$monthName মাসে কোনো আমল নেই')
//                       else
//                         Container(
//                           decoration: BoxDecoration(
//                             color: AmolColors.cardBg,
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(
//                                 color: AmolColors.border, width: 0.5),
//                           ),
//                           child: Column(
//                             children: List.generate(
//                               entries.length,
//                               (i) => _DayRow(
//                                 entry: entries[i],
//                                 isLast: i == entries.length - 1,
//                                 delay: 220 + i * 25,
//                                 userGender: userGender,
//                               ),
//                             ),
//                           ),
//                         ),
//                     ]),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // HERO BAND
// // ─────────────────────────────────────────────────────────────────────────────

// class _HeroBand extends StatelessWidget {
//   final MonthlyTracker? tracker;
//   const _HeroBand({required this.tracker});

//   String _winnerLabel(String? cat) {
//     switch (cat) {
//       case 'TOP_FARZ':
//         return 'ফরজ চ্যাম্পিয়ন 🕌';
//       case 'TOP_JAMAAT':
//         return 'জামাত চ্যাম্পিয়ন 🤝';
//       case 'TOP_QURAN':
//         return 'কুরআন চ্যাম্পিয়ন 📖';
//       case 'TOP_STREAK':
//         return 'সেরা ধারাবাহিকতা 🔥';
//       default:
//         return 'মাসিক বিজয়ী 🏆';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pct = (tracker?.completionPercentage ?? 0).clamp(0.0, 100.0);
//     final farzDays = tracker?.farzCompletedDays ?? 0;
//     final eligibleDays = tracker?.eligibleDays ?? 0;
//     final jamaat = tracker?.congregationDaysSum ?? 0;
//     final streak = tracker?.streakDays ?? 0;
//     final isWinner = tracker?.isWinner ?? false;
//     final rank = tracker?.rank;

//     return Container(
//       color: AmolColors.darkGreen,
//       child: Stack(children: [
//         Positioned(
//             top: -45,
//             right: -40,
//             child: Container(
//                 width: 140,
//                 height: 140,
//                 decoration: const BoxDecoration(
//                     shape: BoxShape.circle, color: Color(0x0AFFFFFF)))),
//         Positioned(
//             bottom: -25,
//             left: 18,
//             child: Container(
//                 width: 88,
//                 height: 88,
//                 decoration: const BoxDecoration(
//                     shape: BoxShape.circle, color: Color(0x07FFFFFF)))),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text('মাসের আমলের সারসংক্ষেপ',
//                 style: TextStyle(
//                     color: Colors.white.withOpacity(0.4),
//                     fontSize: 11,
//                     fontWeight: FontWeight.w500)),
//             const SizedBox(height: 8),
//             Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: const Color(0x17FFFFFF),
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(color: const Color(0x2EFFFFFF), width: 0.5),
//               ),
//               child: Row(children: [
//                 _CircularProgress(percentage: pct, size: 66),
//                 const SizedBox(width: 14),
//                 Expanded(
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                       FittedBox(
//                         fit: BoxFit.scaleDown,
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                             eligibleDays > 0
//                                 ? '$farzDays/$eligibleDays দিন'
//                                 : '$farzDays দিন',
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w900,
//                                 fontSize: 24,
//                                 letterSpacing: -0.5,
//                                 height: 1)),
//                       ),
//                       const SizedBox(height: 2),
//                       Text('সব ফরজ পূর্ণ',
//                           style: TextStyle(
//                               color: Colors.white.withOpacity(0.45),
//                               fontSize: 10)),
//                       const SizedBox(height: 7),
//                       Wrap(spacing: 6, runSpacing: 4, children: [
//                         _HeroChip(
//                             icon: Icons.people_rounded, label: '$jamaat জামাত'),
//                         _HeroChip(
//                             icon: Icons.local_fire_department_rounded,
//                             label: '$streak দিন ধারা'),
//                       ]),
//                       if (isWinner) ...[
//                         const SizedBox(height: 6),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 3),
//                           decoration: BoxDecoration(
//                               color: AmolColors.gold,
//                               borderRadius: BorderRadius.circular(20)),
//                           child: Row(mainAxisSize: MainAxisSize.min, children: [
//                             const Text('🏆', style: TextStyle(fontSize: 10)),
//                             const SizedBox(width: 4),
//                             Flexible(
//                                 child: Text(
//                                     _winnerLabel(tracker?.winnerCategory),
//                                     style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.w700),
//                                     overflow: TextOverflow.ellipsis,
//                                     maxLines: 1)),
//                           ]),
//                         ),
//                       ],
//                     ])),
//                 const SizedBox(width: 12),
//                 if (rank != null)
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.08),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                           color: Colors.white.withOpacity(0.15), width: 0.5),
//                     ),
//                     child: Column(children: [
//                       Text('র‍্যাংক',
//                           style: TextStyle(
//                               color: Colors.white.withOpacity(0.45),
//                               fontSize: 8.5)),
//                       Text('#$rank',
//                           style: const TextStyle(
//                               color: AmolColors.gold,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w900,
//                               height: 1.1)),
//                     ]),
//                   ),
//               ]),
//             ),
//           ]),
//         ),
//       ]),
//     );
//   }
// }

// class _HeroChip extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   const _HeroChip({required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.12),
//           borderRadius: BorderRadius.circular(20)),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [
//         Icon(icon, color: Colors.white.withOpacity(0.7), size: 11),
//         const SizedBox(width: 4),
//         Text(label,
//             style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 10.5,
//                 fontWeight: FontWeight.w600)),
//       ]),
//     );
//   }
// }

// class _CircularProgress extends StatelessWidget {
//   final double percentage;
//   final double size;
//   const _CircularProgress({required this.percentage, required this.size});

//   @override
//   Widget build(BuildContext context) {
//     final str = '${percentage.toInt()}%';
//     final innerSize = size * 0.80;
//     final Color barColor = percentage >= 80
//         ? AmolColors.green
//         : percentage >= 50
//             ? AmolColors.gold
//             : AmolColors.amber;

//     return SizedBox(
//       width: size,
//       height: size,
//       child: Stack(alignment: Alignment.center, children: [
//         SizedBox.expand(
//             child: CircularProgressIndicator(
//           value: percentage / 100,
//           backgroundColor: Colors.white.withOpacity(0.12),
//           valueColor: AlwaysStoppedAnimation(barColor),
//           strokeWidth: size * 0.09,
//           strokeCap: StrokeCap.round,
//         )),
//         Container(
//           width: innerSize,
//           height: innerSize,
//           decoration: const BoxDecoration(
//               color: AmolColors.darkGreen, shape: BoxShape.circle),
//           child: Center(
//               child: FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Padding(
//               padding: EdgeInsets.all(size * 0.05),
//               child: Column(mainAxisSize: MainAxisSize.min, children: [
//                 Text(str,
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w900,
//                         fontSize: size * 0.165,
//                         height: 1),
//                     textAlign: TextAlign.center),
//                 SizedBox(height: size * 0.02),
//                 Text('সম্পন্ন',
//                     style: TextStyle(
//                         color: Colors.white.withOpacity(0.45),
//                         fontSize: size * 0.12),
//                     textAlign: TextAlign.center),
//               ]),
//             ),
//           )),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // EXEMPT BANNER
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
//         color: AmolColors.purplePale,
//         borderRadius: BorderRadius.circular(12),
//         border:
//             Border.all(color: AmolColors.purple.withOpacity(0.25), width: 0.5),
//       ),
//       child: Row(children: [
//         Container(
//             width: 30,
//             height: 30,
//             decoration: BoxDecoration(
//                 color: AmolColors.purpleLight,
//                 borderRadius: BorderRadius.circular(8)),
//             child: const Center(
//                 child: Text('🌸', style: TextStyle(fontSize: 15)))),
//         const SizedBox(width: 10),
//         Expanded(
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           const Text('মাহলির দিন চিহ্নিত',
//               style: TextStyle(
//                   color: AmolColors.purple,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w700)),
//           const SizedBox(height: 2),
//           Text('$exemptCount দিন মাফ — নামাজ ও রোজার হিসাব বাদ দেওয়া হয়েছে',
//               style: TextStyle(
//                   color: AmolColors.purple.withOpacity(0.7),
//                   fontSize: 10,
//                   fontWeight: FontWeight.w500)),
//         ])),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // STAT STRIP
// // ─────────────────────────────────────────────────────────────────────────────

// class _StatStrip extends StatelessWidget {
//   final MonthlyTracker? tracker;
//   final String userGender;
//   const _StatStrip({this.tracker, required this.userGender});

//   @override
//   Widget build(BuildContext context) {
//     final streak = tracker?.streakDays ?? 0;
//     final daysActive = tracker?.daysActive ?? 0;
//     final farzDays = tracker?.farzCompletedDays ?? 0;
//     final jamaat = tracker?.congregationDaysSum ?? 0;
//     final eligible = tracker?.eligibleDays ?? 0;
//     final exemptDays = tracker?.exemptDays ?? 0;
//     final isFemale = userGender == 'female';

//     return Column(children: [
//       Padding(
//         padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//         child: Row(children: [
//           Expanded(
//               child: _StatCard(
//                   emoji: '🔥',
//                   emojiBg: AmolColors.amberLight,
//                   value: '$streak',
//                   label: 'স্ট্রিক দিন',
//                   valueColor: AmolColors.amber)),
//           const SizedBox(width: 8),
//           Expanded(
//               child: _StatCard(
//                   emoji: '📅',
//                   emojiBg: AmolColors.greenLight,
//                   value: '$daysActive',
//                   label: 'আমল করা দিন',
//                   valueColor: AmolColors.green)),
//           const SizedBox(width: 8),
//           Expanded(
//               child: _StatCard(
//                   emoji: '✅',
//                   emojiBg: AmolColors.greenLight,
//                   value: '$farzDays',
//                   label: 'পূর্ণ ফরজ দিন',
//                   valueColor: AmolColors.darkGreen)),
//         ]),
//       ),
//       Padding(
//         padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
//         child: Row(children: [
//           Expanded(
//               child: _StatCard(
//                   emoji: '🕌',
//                   emojiBg: AmolColors.purpleLight,
//                   value: '$jamaat',
//                   label: 'জামাত দিন',
//                   valueColor: AmolColors.purple)),
//           const SizedBox(width: 8),
//           Expanded(
//               child: _StatCard(
//                   emoji: '⏳',
//                   emojiBg: AmolColors.greenLight,
//                   value: '$eligible',
//                   label: 'হিসাবের দিন',
//                   valueColor: AmolColors.green)),
//           const SizedBox(width: 8),
//           if (isFemale)
//             Expanded(
//                 child: _StatCard(
//                     emoji: '🌸',
//                     emojiBg: AmolColors.purplePale,
//                     value: '$exemptDays',
//                     label: 'মাহলির দিন',
//                     valueColor: AmolColors.purple))
//           else
//             Expanded(
//                 child: _StatCard(
//                     emoji: '🏅',
//                     emojiBg: AmolColors.goldLight,
//                     value: tracker?.rank != null ? '#${tracker!.rank}' : '---',
//                     label: 'র‍্যাংক',
//                     valueColor: AmolColors.gold)),
//         ]),
//       ),
//     ]);
//   }
// }

// class _StatCard extends StatelessWidget {
//   final String emoji, value, label;
//   final Color emojiBg, valueColor;
//   const _StatCard(
//       {required this.emoji,
//       required this.emojiBg,
//       required this.value,
//       required this.label,
//       required this.valueColor});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(11),
//       decoration: BoxDecoration(
//           color: AmolColors.cardBg,
//           borderRadius: BorderRadius.circular(13),
//           border: Border.all(color: AmolColors.border, width: 0.5)),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Container(
//             width: 28,
//             height: 28,
//             decoration: BoxDecoration(
//                 color: emojiBg, borderRadius: BorderRadius.circular(7)),
//             child: Center(
//                 child: Text(emoji, style: const TextStyle(fontSize: 13)))),
//         const SizedBox(height: 7),
//         FittedBox(
//             fit: BoxFit.scaleDown,
//             alignment: Alignment.centerLeft,
//             child: Text(value,
//                 style: TextStyle(
//                     color: valueColor,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 19,
//                     letterSpacing: -0.4,
//                     height: 1))),
//         const SizedBox(height: 2),
//         Text(label,
//             style: const TextStyle(
//                 color: AmolColors.textSecondary,
//                 fontSize: 9.5,
//                 fontWeight: FontWeight.w500)),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // FARD PERFORMANCE
// // ─────────────────────────────────────────────────────────────────────────────

// class _FardSection extends StatelessWidget {
//   final MonthlyTracker tracker;
//   const _FardSection({required this.tracker});

//   @override
//   Widget build(BuildContext context) {
//     final pct = tracker.completionPercentage.clamp(0.0, 100.0);
//     final farzDays = tracker.farzCompletedDays;
//     final eligible = tracker.eligibleDays;
//     final jamaat = tracker.congregationDaysSum;

//     Color statusColor() {
//       if (pct >= 90) return AmolColors.green;
//       if (pct >= 70) return AmolColors.amber;
//       return AmolColors.red;
//     }

//     String statusLabel() {
//       if (pct >= 90) return 'চমৎকার';
//       if (pct >= 70) return 'ভালো';
//       if (pct >= 50) return 'মাঝামাঝি';
//       return 'উন্নতি দরকার';
//     }

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const AmolSectionHeader(title: 'ফরজ পারফরম্যান্স', emoji: '🕌'),
//         const SizedBox(height: 10),
//         Row(children: [
//           Expanded(
//               child: _FardCard(
//             title: 'পূর্ণ ফরজ দিন',
//             bigValue: '${pct.toInt()}%',
//             subValue: '$farzDays/$eligible দিন',
//             badgeLabel: statusLabel(),
//             badgeColor: statusColor(),
//             barValue: pct / 100,
//             barColor: statusColor(),
//           )),
//           const SizedBox(width: 10),
//           Expanded(
//               child: _FardCard(
//             title: 'মোট জামাত',
//             bigValue: '$jamaat',
//             subValue: '৫ ওয়াক্ত × দিন মিলিয়ে',
//             badgeLabel: jamaat > 0 ? 'জামাতে পড়া হয়েছে' : 'কোনো জামাত নেই',
//             badgeColor: jamaat > 0 ? AmolColors.purple : AmolColors.textHint,
//             barValue:
//                 eligible > 0 ? (jamaat / (eligible * 5)).clamp(0.0, 1.0) : 0,
//             barColor: AmolColors.purple,
//           )),
//         ]),
//       ]),
//     );
//   }
// }

// class _FardCard extends StatelessWidget {
//   final String title, bigValue, subValue, badgeLabel;
//   final Color badgeColor, barColor;
//   final double barValue;
//   const _FardCard(
//       {required this.title,
//       required this.bigValue,
//       required this.subValue,
//       required this.badgeLabel,
//       required this.badgeColor,
//       required this.barColor,
//       required this.barValue});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//           color: AmolColors.cardBg,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: AmolColors.border, width: 0.5)),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Expanded(
//               child: Text(title,
//                   style: const TextStyle(
//                       color: AmolColors.textPrimary,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w700))),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//             decoration: BoxDecoration(
//                 color: badgeColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(20)),
//             child: Text(badgeLabel,
//                 style: TextStyle(
//                     color: badgeColor,
//                     fontSize: 8.5,
//                     fontWeight: FontWeight.w700)),
//           ),
//         ]),
//         const SizedBox(height: 8),
//         FittedBox(
//             fit: BoxFit.scaleDown,
//             alignment: Alignment.centerLeft,
//             child: Text(bigValue,
//                 style: TextStyle(
//                     color: badgeColor,
//                     fontSize: 22,
//                     fontWeight: FontWeight.w900,
//                     height: 1))),
//         const SizedBox(height: 2),
//         Text(subValue,
//             style: const TextStyle(color: AmolColors.textHint, fontSize: 9.5)),
//         const SizedBox(height: 8),
//         ClipRRect(
//             borderRadius: BorderRadius.circular(99),
//             child: LinearProgressIndicator(
//                 value: barValue.clamp(0.0, 1.0),
//                 minHeight: 5,
//                 backgroundColor: AmolColors.pageBg,
//                 valueColor: AlwaysStoppedAnimation(barColor))),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // WEEKLY CHART
// // ─────────────────────────────────────────────────────────────────────────────

// class _WeeklyChartSection extends StatelessWidget {
//   final List<WeeklyDayProgress> weekData;
//   final String userGender;
//   const _WeeklyChartSection({required this.weekData, required this.userGender});

//   @override
//   Widget build(BuildContext context) {
//     if (weekData.isEmpty) return const SizedBox.shrink();

//     final isFemale = userGender == 'female';
//     final today = DateTime.now();
//     final activeDays = weekData.where((d) => d.hasActivity).length;
//     final exemptCnt = weekData.where((d) => d.isExemptDay).length;

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const AmolSectionHeader(title: 'এই সপ্তাহের অগ্রগতি', emoji: '📊'),
//         const SizedBox(height: 10),
//         Container(
//           padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
//           decoration: BoxDecoration(
//               color: AmolColors.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: AmolColors.border, width: 0.5)),
//           child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 LayoutBuilder(builder: (ctx, constraints) {
//                   final chartH =
//                       (constraints.maxWidth * 0.36).clamp(80.0, 140.0);
//                   const dayLblH = 14.0;
//                   const gapH = 8.0;
//                   final barAreaH =
//                       (chartH - dayLblH - gapH).clamp(20.0, chartH);

//                   return SizedBox(
//                     height: chartH,
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: weekData.map((d) {
//                         final dayDate = DateTime.tryParse(d.date);
//                         final isToday = dayDate != null &&
//                             dayDate.year == today.year &&
//                             dayDate.month == today.month &&
//                             dayDate.day == today.day;
//                         final showExempt = d.isExemptDay && isFemale;

//                         Color barColor;
//                         double barH;
//                         if (showExempt) {
//                           barColor = AmolColors.purple;
//                           barH = barAreaH * 0.5;
//                         } else if (d.hasActivity) {
//                           barColor =
//                               isToday ? AmolColors.darkGreen : AmolColors.green;
//                           barH = barAreaH;
//                         } else {
//                           barColor = AmolColors.border;
//                           barH = barAreaH * 0.12;
//                         }

//                         return Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 3),
//                             child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   if (d.hasActivity && !showExempt)
//                                     Container(
//                                       width: 5,
//                                       height: 5,
//                                       margin: const EdgeInsets.only(bottom: 3),
//                                       decoration: BoxDecoration(
//                                           color: isToday
//                                               ? AmolColors.darkGreen
//                                               : AmolColors.green,
//                                           shape: BoxShape.circle),
//                                     )
//                                   else
//                                     const SizedBox(height: 8),
//                                   if (showExempt)
//                                     Container(
//                                       height: barH,
//                                       decoration: BoxDecoration(
//                                         color: AmolColors.purpleLight,
//                                         borderRadius: BorderRadius.circular(4),
//                                         border: Border.all(
//                                             color: AmolColors.purple
//                                                 .withOpacity(0.3),
//                                             width: 0.5),
//                                       ),
//                                       child: const Center(
//                                           child: Text('🌸',
//                                               style: TextStyle(fontSize: 8))),
//                                     )
//                                   else
//                                     AnimatedContainer(
//                                       duration: 400.ms,
//                                       height: barH,
//                                       decoration: BoxDecoration(
//                                         color: barColor,
//                                         borderRadius:
//                                             const BorderRadius.vertical(
//                                                 top: Radius.circular(4)),
//                                       ),
//                                     ),
//                                   const SizedBox(height: 5),
//                                   SizedBox(
//                                       height: dayLblH,
//                                       child: FittedBox(
//                                           fit: BoxFit.scaleDown,
//                                           child: Text(d.day,
//                                               style: TextStyle(
//                                                   fontSize: 9,
//                                                   color: isToday
//                                                       ? AmolColors.darkGreen
//                                                       : AmolColors
//                                                           .textSecondary,
//                                                   fontWeight: isToday
//                                                       ? FontWeight.w800
//                                                       : FontWeight.w500)))),
//                                 ]),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   );
//                 }),
//                 const SizedBox(height: 10),
//                 const Divider(
//                     height: 1, thickness: 0.5, color: AmolColors.border),
//                 const SizedBox(height: 10),
//                 Row(children: [
//                   _WeekChip(
//                       label: 'সক্রিয় দিন',
//                       value: '$activeDays/7',
//                       color: AmolColors.green),
//                   const SizedBox(width: 8),
//                   _WeekChip(
//                       label: 'বাকি দিন',
//                       value: '${7 - activeDays - exemptCnt}',
//                       color: AmolColors.textSecondary),
//                   if (isFemale && exemptCnt > 0) ...[
//                     const SizedBox(width: 8),
//                     _WeekChip(
//                         label: 'মাহলি',
//                         value: '$exemptCnt',
//                         color: AmolColors.purple),
//                   ],
//                 ]),
//                 const SizedBox(height: 10),
//                 Wrap(spacing: 12, runSpacing: 4, children: [
//                   AmolLegendDot(
//                       color: AmolColors.green, label: 'আমল করা হয়েছে'),
//                   AmolLegendDot(
//                       color: AmolColors.border, label: 'কোনো আমল নেই'),
//                   if (isFemale)
//                     AmolLegendDot(
//                         color: AmolColors.purpleLight, label: 'মাহলির দিন'),
//                 ]),
//               ]),
//         ),
//       ]),
//     );
//   }
// }

// class _WeekChip extends StatelessWidget {
//   final String label, value;
//   final Color color;
//   const _WeekChip(
//       {required this.label, required this.value, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
//         decoration: BoxDecoration(
//             color: AmolColors.pageBg, borderRadius: BorderRadius.circular(8)),
//         child: Column(children: [
//           FittedBox(
//               fit: BoxFit.scaleDown,
//               child: Text(value,
//                   style: TextStyle(
//                       color: color,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w800,
//                       height: 1))),
//           const SizedBox(height: 2),
//           FittedBox(
//               fit: BoxFit.scaleDown,
//               child: Text(label,
//                   style: const TextStyle(
//                       color: AmolColors.textHint, fontSize: 8.5),
//                   textAlign: TextAlign.center)),
//         ]),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // TODAY PRAYER BREAKDOWN — Row + Expanded দিয়ে ৫টা সমান কলাম। Expanded ব্যবহার
// // করায় Flutter constraint অনুযায়ী প্রতিটা কলামের width গাণিতিকভাবে নির্দিষ্ট
// // (মোট width ÷ ৫) — তাই দুইটা আইটেম কখনো একে অপরের উপর/মধ্যে বসতে পারে না,
// // এবং পুরো card width সমান ভাগে ব্যবহার হয় (কোনো ফাঁকা জায়গা অপচয় হয় না)।
// // প্রতিটা কলামের ভেতরে FittedBox থাকায় লম্বা লেবেল ("মাগরিব") ছোট স্ক্রিনেও
// // নিজের bounded width এর মধ্যেই scale-down হয়ে বসে যায়, overflow হয় না।
// // ─────────────────────────────────────────────────────────────────────────────

// class _TodayPrayerSection extends StatelessWidget {
//   final List<PrayerBreakdownItem> prayers;
//   const _TodayPrayerSection({required this.prayers});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const AmolSectionHeader(title: 'আজকের নামাজের অবস্থা', emoji: '🕌'),
//         const SizedBox(height: 10),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
//           decoration: BoxDecoration(
//               color: AmolColors.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: AmolColors.border, width: 0.5)),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: prayers.map((p) {
//               Color color;
//               IconData icon;
//               String label;

//               if (p.mode == null) {
//                 color = AmolColors.textHint;
//                 icon = Icons.radio_button_unchecked_rounded;
//                 label = 'বাকি';
//               } else if (p.mode == PrayerMode.congregation) {
//                 color = AmolColors.green;
//                 icon = Icons.people_rounded;
//                 label = 'জামাত';
//               } else if (p.mode == PrayerMode.solo) {
//                 color = AmolColors.amber;
//                 icon = Icons.person_rounded;
//                 label = 'একাকী';
//               } else {
//                 color = AmolColors.red;
//                 icon = Icons.close_rounded;
//                 label = 'মিস';
//               }

//               return Expanded(
//                 child: Column(mainAxisSize: MainAxisSize.min, children: [
//                   Container(
//                     width: 36,
//                     height: 36,
//                     decoration: BoxDecoration(
//                         color: color.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                             color: color.withOpacity(0.3), width: 0.5)),
//                     child: Icon(icon, color: color, size: 17),
//                   ),
//                   const SizedBox(height: 6),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 2),
//                     child: FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: Text(p.nameBn,
//                           maxLines: 1,
//                           softWrap: false,
//                           style: const TextStyle(
//                               color: AmolColors.textPrimary,
//                               fontSize: 10.5,
//                               fontWeight: FontWeight.w700)),
//                     ),
//                   ),
//                   const SizedBox(height: 3),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 2),
//                     child: FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: Text(label,
//                           maxLines: 1,
//                           softWrap: false,
//                           style: TextStyle(
//                               color: color,
//                               fontSize: 9,
//                               fontWeight: FontWeight.w600)),
//                     ),
//                   ),
//                 ]),
//               );
//             }).toList(),
//           ),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // COMPARE METRIC — multi-metric monthly comparison
// // ─────────────────────────────────────────────────────────────────────────────

// enum _CompareMetric {
//   completion,
//   farz,
//   congregation,
//   quran,
//   dhikr,
//   fasting,
//   akhlaq,
//   streak
// }

// extension _CompareMetricX on _CompareMetric {
//   String get labelBn {
//     switch (this) {
//       case _CompareMetric.completion:
//         return 'সম্পন্ন %';
//       case _CompareMetric.farz:
//         return 'পূর্ণ ফরজ দিন';
//       case _CompareMetric.congregation:
//         return 'জামাত দিন';
//       case _CompareMetric.quran:
//         return 'কুরআন আয়াত';
//       case _CompareMetric.dhikr:
//         return 'যিকর স্কোর';
//       case _CompareMetric.fasting:
//         return 'নফল রোজা';
//       case _CompareMetric.akhlaq:
//         return 'আখলাক দিন';
//       case _CompareMetric.streak:
//         return 'স্ট্রিক দিন';
//     }
//   }

//   String get emoji {
//     switch (this) {
//       case _CompareMetric.completion:
//         return '✅';
//       case _CompareMetric.farz:
//         return '🕌';
//       case _CompareMetric.congregation:
//         return '🤝';
//       case _CompareMetric.quran:
//         return '📖';
//       case _CompareMetric.dhikr:
//         return '📿';
//       case _CompareMetric.fasting:
//         return '🌙';
//       case _CompareMetric.akhlaq:
//         return '🤲';
//       case _CompareMetric.streak:
//         return '🔥';
//     }
//   }

//   double valueOf(MonthlyTracker t) {
//     switch (this) {
//       case _CompareMetric.completion:
//         return t.completionPercentage;
//       case _CompareMetric.farz:
//         return t.farzCompletedDays.toDouble();
//       case _CompareMetric.congregation:
//         return t.congregationDaysSum.toDouble();
//       case _CompareMetric.quran:
//         return t.quranAyahTotal.toDouble();
//       case _CompareMetric.dhikr:
//         return t.dhikrScore.toDouble();
//       case _CompareMetric.fasting:
//         return t.fastingDays.toDouble();
//       case _CompareMetric.akhlaq:
//         return t.akhlaqDays.toDouble();
//       case _CompareMetric.streak:
//         return t.streakDays.toDouble();
//     }
//   }

//   String display(MonthlyTracker t) => this == _CompareMetric.completion
//       ? '${valueOf(t).toInt()}%'
//       : '${valueOf(t).toInt()}';
// }

// class _PrevMonthsSection extends StatefulWidget {
//   final List<MonthlyTracker> months;
//   const _PrevMonthsSection({required this.months});

//   @override
//   State<_PrevMonthsSection> createState() => _PrevMonthsSectionState();
// }

// class _PrevMonthsSectionState extends State<_PrevMonthsSection> {
//   _CompareMetric _metric = _CompareMetric.completion;

//   @override
//   Widget build(BuildContext context) {
//     final months = widget.months;
//     if (months.isEmpty) return const SizedBox.shrink();
//     final current = months.last;

//     final maxVal = months
//         .map((m) => _metric.valueOf(m))
//         .fold<double>(0, (a, b) => b > a ? b : a);
//     final safeMax = maxVal <= 0 ? 1.0 : maxVal;

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const AmolSectionHeader(title: 'মাসিক তুলনা', emoji: '📈'),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: 34,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             children: _CompareMetric.values
//                 .map((m) => Padding(
//                       padding: const EdgeInsets.only(right: 6),
//                       child: AmolFilterChip(
//                         label: m.labelBn,
//                         emoji: m.emoji,
//                         selected: _metric == m,
//                         onTap: () => setState(() => _metric = m),
//                       ),
//                     ))
//                 .toList(),
//           ),
//         ),
//         const SizedBox(height: 10),
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//               color: AmolColors.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: AmolColors.border, width: 0.5)),
//           child: Column(children: [
//             LayoutBuilder(builder: (ctx, constraints) {
//               final chartH = (constraints.maxWidth * 0.36).clamp(90.0, 150.0);
//               const valLblH = 14.0;
//               const mthLblH = 12.0;
//               const gapH = 8.0;
//               final barAreaH =
//                   (chartH - valLblH - mthLblH - gapH).clamp(16.0, chartH);

//               return SizedBox(
//                 height: chartH,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: months.map((m) {
//                     final isActive =
//                         m.year == current.year && m.month == current.month;
//                     final val = _metric.valueOf(m);
//                     final fillH = val > 0
//                         ? ((val / safeMax) * barAreaH).clamp(4.0, barAreaH)
//                         : 4.0;
//                     final mName = AppConstants.bengaliMonths[m.month - 1];
//                     final mShort =
//                         mName.length > 3 ? mName.substring(0, 3) : mName;

//                     return Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 5),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             SizedBox(
//                               height: valLblH,
//                               child: FittedBox(
//                                 fit: BoxFit.scaleDown,
//                                 child: Text(_metric.display(m),
//                                     style: TextStyle(
//                                         fontSize: 9,
//                                         color: isActive
//                                             ? AmolColors.darkGreen
//                                             : AmolColors.textHint,
//                                         fontWeight: isActive
//                                             ? FontWeight.w800
//                                             : FontWeight.w500)),
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             AnimatedContainer(
//                               duration: 400.ms,
//                               height: fillH,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 color: val > 0
//                                     ? (isActive
//                                         ? AmolColors.darkGreen
//                                         : AmolColors.midGreen.withOpacity(0.5))
//                                     : AmolColors.pageBg,
//                                 borderRadius: const BorderRadius.vertical(
//                                     top: Radius.circular(6)),
//                                 border: val > 0
//                                     ? null
//                                     : Border.all(
//                                         color: AmolColors.border, width: 0.5),
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             SizedBox(
//                               height: mthLblH,
//                               child: FittedBox(
//                                 fit: BoxFit.scaleDown,
//                                 child: Text(mShort,
//                                     style: TextStyle(
//                                         fontSize: 9,
//                                         color: isActive
//                                             ? AmolColors.darkGreen
//                                             : AmolColors.textSecondary,
//                                         fontWeight: isActive
//                                             ? FontWeight.w800
//                                             : FontWeight.w500)),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               );
//             }),
//             if (months.length >= 2) ...[
//               const SizedBox(height: 12),
//               const Divider(
//                   height: 1, thickness: 0.5, color: AmolColors.border),
//               const SizedBox(height: 10),
//               _TrendLine(months: months, metric: _metric),
//             ],
//           ]),
//         ),
//       ]),
//     );
//   }
// }

// class _TrendLine extends StatelessWidget {
//   final List<MonthlyTracker> months;
//   final _CompareMetric metric;
//   const _TrendLine({required this.months, required this.metric});

//   @override
//   Widget build(BuildContext context) {
//     final current = months.last;
//     final prev = months[months.length - 2];
//     final curVal = metric.valueOf(current);
//     final prevVal = metric.valueOf(prev);
//     final diff = curVal - prevVal;
//     final isUp = diff > 0;
//     final isSame = diff == 0;

//     return Row(children: [
//       Icon(
//         isSame
//             ? Icons.remove_rounded
//             : (isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded),
//         size: 16,
//         color: isSame
//             ? AmolColors.textHint
//             : (isUp ? AmolColors.green : AmolColors.red),
//       ),
//       const SizedBox(width: 6),
//       Expanded(
//         child: Text(
//           isSame
//               ? 'গত মাসের সমান'
//               : '${metric.labelBn} গত মাসের তুলনায় ${isUp ? "বেড়েছে" : "কমেছে"} ${diff.abs().toInt()}${metric == _CompareMetric.completion ? "%" : ""}',
//           style: TextStyle(
//               color: isSame
//                   ? AmolColors.textHint
//                   : (isUp ? AmolColors.green : AmolColors.red),
//               fontSize: 11,
//               fontWeight: FontWeight.w600),
//         ),
//       ),
//     ]);
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
//     final farzDays = tracker.farzCompletedDays;
//     final jamaat = tracker.congregationDaysSum;

//     String rankLabel() {
//       if (rank <= 1) return 'সর্বোচ্চ অবস্থানে আছেন!';
//       if (rank <= 3) return 'শীর্ষ ৩ জনের মধ্যে!';
//       if (rank <= 10) return 'শীর্ষ ১০ জনের মধ্যে';
//       return 'র‍্যাংক #$rank তে আছেন';
//     }

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const AmolSectionHeader(title: 'লিডারবোর্ড অবস্থান', emoji: '🏅'),
//         const SizedBox(height: 10),
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//               color: AmolColors.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: AmolColors.border, width: 0.5)),
//           child: Row(children: [
//             Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                     color: AmolColors.greenLight,
//                     borderRadius: BorderRadius.circular(14)),
//                 child: Center(
//                     child: FittedBox(
//                         fit: BoxFit.scaleDown,
//                         child: Padding(
//                             padding: const EdgeInsets.all(4),
//                             child: Text('#$rank',
//                                 style: const TextStyle(
//                                     color: AmolColors.darkGreen,
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.w900)))))),
//             const SizedBox(width: 14),
//             Expanded(
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                   Text(rankLabel(),
//                       style: const TextStyle(
//                           color: AmolColors.textPrimary,
//                           fontSize: 13,
//                           fontWeight: FontWeight.w700)),
//                   const SizedBox(height: 3),
//                   Text(
//                       'সম্পন্ন ${pct.toInt()}% · $farzDays পূর্ণ ফরজ দিন · $jamaat জামাত',
//                       style: const TextStyle(
//                           color: AmolColors.textSecondary,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w500)),
//                   const SizedBox(height: 8),
//                   ClipRRect(
//                       borderRadius: BorderRadius.circular(99),
//                       child: LinearProgressIndicator(
//                           value: pct / 100,
//                           minHeight: 5,
//                           backgroundColor: AmolColors.pageBg,
//                           valueColor: const AlwaysStoppedAnimation(
//                               AmolColors.darkGreen))),
//                 ])),
//             if (tracker.isWinner) ...[
//               const SizedBox(width: 12),
//               Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                       color: AmolColors.goldLight,
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                           color: AmolColors.gold.withOpacity(0.3), width: 0.5)),
//                   child: const Text('🏆', style: TextStyle(fontSize: 22))),
//             ],
//           ]),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // HEATMAP
// // ─────────────────────────────────────────────────────────────────────────────

// class _HeatmapCalendar extends StatelessWidget {
//   final int year, month;
//   final List<DailyEntry> entries;
//   final String userGender;
//   const _HeatmapCalendar(
//       {required this.year,
//       required this.month,
//       required this.entries,
//       required this.userGender});

//   @override
//   Widget build(BuildContext context) {
//     final daysInMonth = DateUtils.getDaysInMonth(year, month);
//     final entryMap = {for (final e in entries) e.day: e};
//     final today = DateTime.now();
//     final firstDay = DateTime(year, month, 1).weekday % 7;
//     final totalCells = ((firstDay + daysInMonth) / 7).ceil() * 7;
//     final isFemale = userGender == 'female';

//     // entry.hasActivity flag এর বদলে actual entries থেকে হিসাব — day row এর
//     // মতো এখানেও stale backend flag এর কারণে ভুল রঙ দেখানো এড়াতে
//     bool _dayHasActivity(DailyEntry e) {
//       if (e.hasActivity) return true;
//       for (final item in e.entries) {
//         if (item.prayerMode == PrayerMode.congregation ||
//             item.prayerMode == PrayerMode.solo) return true;
//         if (item.prayerMode == null && (item.completed || item.count > 0))
//           return true;
//       }
//       return false;
//     }

//     int _intensity(DailyEntry e) {
//       int score = 0;
//       for (final item in e.entries) {
//         if (item.prayerMode == PrayerMode.congregation) {
//           score += 2;
//         } else if (item.prayerMode == PrayerMode.solo) {
//           score += 1;
//         } else if (item.completed || item.count > 0) {
//           score += 1;
//         }
//       }
//       return score;
//     }

//     final maxScore = entries.isEmpty
//         ? 1
//         : entries
//             .map(_intensity)
//             .fold(0, (a, b) => a > b ? a : b)
//             .clamp(1, 999);

//     const weekdays = ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহঃ', 'শুক্র', 'শনি'];

//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//           color: AmolColors.cardBg,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: AmolColors.border, width: 0.5)),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(
//             children: weekdays
//                 .map((d) => Expanded(
//                     child: Center(
//                         child: Text(d,
//                             style: const TextStyle(
//                                 color: AmolColors.textHint,
//                                 fontSize: 9.5,
//                                 fontWeight: FontWeight.w500)))))
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
//             final isExempt = (entry?.isExemptDay ?? false) && isFemale;
//             final hasAct = entry != null && _dayHasActivity(entry);
//             final score = entry != null ? _intensity(entry) : 0;
//             final intensity = score / maxScore;
//             final isToday = today.year == year &&
//                 today.month == month &&
//                 today.day == dayNum;
//             final isFuture = DateTime(year, month, dayNum).isAfter(today);

//             Color cellColor;
//             Color numColor;

//             if (isExempt) {
//               cellColor = AmolColors.purplePale;
//               numColor = AmolColors.purple;
//             } else if (isFuture) {
//               cellColor = AmolColors.pageBg;
//               numColor = AmolColors.textHint;
//             } else if (!hasAct) {
//               cellColor = AmolColors.greenLight.withOpacity(0.4);
//               numColor = AmolColors.textHint;
//             } else if (intensity < 0.25) {
//               cellColor = AmolColors.green.withOpacity(0.18);
//               numColor = AmolColors.green;
//             } else if (intensity < 0.5) {
//               cellColor = AmolColors.green.withOpacity(0.38);
//               numColor = AmolColors.green;
//             } else if (intensity < 0.75) {
//               cellColor = AmolColors.green.withOpacity(0.60);
//               numColor = Colors.white;
//             } else {
//               cellColor = AmolColors.green.withOpacity(0.85);
//               numColor = Colors.white;
//             }

//             return Container(
//               decoration: BoxDecoration(
//                 color: cellColor,
//                 borderRadius: BorderRadius.circular(5),
//                 border: isToday
//                     ? Border.all(color: AmolColors.gold, width: 1.5)
//                     : null,
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
//                       const Text('🌸',
//                           style: TextStyle(fontSize: 6.5, height: 1))
//                     else if (hasAct && !isFuture)
//                       Container(
//                         width: 4,
//                         height: 4,
//                         margin: const EdgeInsets.only(top: 1),
//                         decoration: BoxDecoration(
//                             color: numColor.withOpacity(0.6),
//                             shape: BoxShape.circle),
//                       ),
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
//               style: TextStyle(color: AmolColors.textHint, fontSize: 9.5)),
//           ...List.generate(
//               5,
//               (i) => Container(
//                     width: 12,
//                     height: 12,
//                     margin: const EdgeInsets.only(right: 3),
//                     decoration: BoxDecoration(
//                         color: i == 0
//                             ? AmolColors.greenLight.withOpacity(0.4)
//                             : AmolColors.green.withOpacity(0.15 + i * 0.18),
//                         borderRadius: BorderRadius.circular(3)),
//                   )),
//           const Text('  বেশি',
//               style: TextStyle(color: AmolColors.textHint, fontSize: 9.5)),
//           if (isFemale) ...[
//             const SizedBox(width: 8),
//             Container(
//                 width: 12,
//                 height: 12,
//                 margin: const EdgeInsets.only(right: 3),
//                 decoration: BoxDecoration(
//                     color: AmolColors.purplePale,
//                     borderRadius: BorderRadius.circular(3),
//                     border: Border.all(
//                         color: AmolColors.purple.withOpacity(0.3),
//                         width: 0.5))),
//             const Text('মাহলি',
//                 style: TextStyle(color: AmolColors.textHint, fontSize: 9.5)),
//           ],
//         ]),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DAY ROW — tap করলে category-wise breakdown bottom sheet খোলে
// // ─────────────────────────────────────────────────────────────────────────────

// class _DayRow extends ConsumerWidget {
//   final DailyEntry entry;
//   final bool isLast;
//   final int delay;
//   final String userGender;
//   const _DayRow(
//       {required this.entry,
//       required this.isLast,
//       required this.delay,
//       required this.userGender});

//   void _showDayDetail(BuildContext context, WidgetRef ref) {
//     final categories = ref.read(categoriesProvider).value ?? [];
//     final catMap = {for (final c in categories) c.id: c};
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) =>
//           _DayDetailSheet(entry: entry, catMap: catMap, userGender: userGender),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isFemale = userGender == 'female';
//     final isExempt = entry.isExemptDay && isFemale;
//     final entries = entry.entries;

//     final congregation =
//         entries.where((e) => e.prayerMode == PrayerMode.congregation).length;
//     final solo = entries.where((e) => e.prayerMode == PrayerMode.solo).length;
//     final missed =
//         entries.where((e) => e.prayerMode == PrayerMode.missed).length;

//     final otherCompleted = entries
//         .where((e) => e.prayerMode == null && (e.completed || e.count > 0))
//         .length;

//     final totalCompleted = congregation + solo + otherCompleted;
//     // backend এর entry.hasActivity flag কে সরাসরি বিশ্বাস না করে, actual
//     // entries থেকেই client-side এ হিসাব করা — flag stale/ভুল হলেও UI সঠিক
//     // থাকবে (যেমন: ৩ জামাত করা সত্ত্বেও ভুলভাবে "কোনো আমল নেই" দেখানো বাগ)
//     final hasActivity = entry.hasActivity || totalCompleted > 0;

//     String monthShort(int idx) {
//       final s = AppConstants.bengaliMonths[idx];
//       return s.length >= 3 ? s.substring(0, 3) : s;
//     }

//     final prayerTotal = congregation + solo + missed;
//     final progressVal = prayerTotal > 0
//         ? congregation / prayerTotal
//         : hasActivity
//             ? 0.5
//             : 0.0;

//     Color barColor = isExempt
//         ? AmolColors.purple
//         : congregation >= 3
//             ? AmolColors.green
//             : congregation >= 1
//                 ? AmolColors.amber
//                 : AmolColors.border;

//     return InkWell(
//       onTap: () => _showDayDetail(context, ref),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
//         decoration: BoxDecoration(
//           color: isExempt
//               ? AmolColors.purplePale.withOpacity(0.4)
//               : hasActivity
//                   ? AmolColors.greenLight.withOpacity(0.15)
//                   : Colors.transparent,
//           border: isLast
//               ? null
//               : const Border(
//                   bottom: BorderSide(color: AmolColors.border, width: 0.5)),
//           borderRadius: isLast
//               ? const BorderRadius.vertical(bottom: Radius.circular(16))
//               : null,
//         ),
//         child: Row(children: [
//           Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               gradient: isExempt
//                   ? const LinearGradient(
//                       colors: [AmolColors.purple, Color(0xFF9B6BE8)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight)
//                   : hasActivity
//                       ? const LinearGradient(
//                           colors: [AmolColors.darkGreen, AmolColors.midGreen],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight)
//                       : null,
//               color: isExempt || hasActivity ? null : AmolColors.pageBg,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child:
//                 Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//               Text('${entry.day}',
//                   style: TextStyle(
//                       color: isExempt || hasActivity
//                           ? Colors.white
//                           : AmolColors.textHint,
//                       fontWeight: FontWeight.w800,
//                       fontSize: 15,
//                       height: 1)),
//               Text(monthShort(entry.month - 1),
//                   style: TextStyle(
//                       color: isExempt || hasActivity
//                           ? Colors.white.withOpacity(0.6)
//                           : AmolColors.textHint,
//                       fontSize: 8.5)),
//             ]),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                 Row(children: [
//                   Flexible(
//                       child: Text(
//                           isExempt
//                               ? 'মাহলির দিন'
//                               : hasActivity
//                                   ? '$totalCompleted টি আমল সম্পন্ন'
//                                   : 'কোনো আমল নেই',
//                           style: TextStyle(
//                               color: isExempt
//                                   ? AmolColors.purple
//                                   : hasActivity
//                                       ? AmolColors.textPrimary
//                                       : AmolColors.textSecondary,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 12),
//                           overflow: TextOverflow.ellipsis)),
//                   if (congregation > 0) ...[
//                     const SizedBox(width: 5),
//                     _Pill(
//                         text: '🕌 $congregation জামাত',
//                         bg: AmolColors.purpleLight,
//                         fg: AmolColors.purple),
//                   ] else if (solo > 0) ...[
//                     const SizedBox(width: 5),
//                     _Pill(
//                         text: '🤲 $solo একাকী',
//                         bg: AmolColors.greenLight,
//                         fg: AmolColors.green),
//                   ],
//                 ]),
//                 if (missed > 0) ...[
//                   const SizedBox(height: 3),
//                   _Pill(
//                       text: '⚠️ $missed মিস',
//                       bg: AmolColors.redLight,
//                       fg: AmolColors.red),
//                 ],
//                 const SizedBox(height: 5),
//                 ClipRRect(
//                     borderRadius: BorderRadius.circular(99),
//                     child: LinearProgressIndicator(
//                         value: progressVal.clamp(0.0, 1.0),
//                         minHeight: 4,
//                         backgroundColor: AmolColors.pageBg,
//                         valueColor: AlwaysStoppedAnimation(barColor))),
//               ])),
//           const SizedBox(width: 10),
//           Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
//             if (isExempt)
//               const Text('🌸', style: TextStyle(fontSize: 18))
//             else if (congregation >= 4)
//               const Icon(Icons.star_rounded, color: AmolColors.gold, size: 22)
//             else if (congregation >= 1 || solo >= 1)
//               const Icon(Icons.check_circle_rounded,
//                   color: AmolColors.green, size: 22)
//             else if (hasActivity)
//               const Icon(Icons.circle_outlined,
//                   color: AmolColors.amber, size: 22)
//             else
//               const Icon(Icons.remove_circle_outline_rounded,
//                   color: AmolColors.border, size: 22),
//             const SizedBox(height: 2),
//             Text(
//                 isExempt
//                     ? 'মাফ'
//                     : congregation >= 4
//                         ? 'পূর্ণ'
//                         : congregation >= 1
//                             ? 'আংশিক'
//                             : hasActivity
//                                 ? 'কিছু'
//                                 : 'শূন্য',
//                 style: const TextStyle(
//                     color: AmolColors.textHint,
//                     fontSize: 8.5,
//                     fontWeight: FontWeight.w500)),
//             const SizedBox(height: 4),
//             const Icon(Icons.chevron_right_rounded,
//                 color: AmolColors.textHint, size: 16),
//           ]),
//         ]),
//       ),
//     )
//         .animate(delay: Duration(milliseconds: delay))
//         .fadeIn(duration: 240.ms)
//         .slideX(begin: 0.04, curve: Curves.easeOut);
//   }
// }

// class _Pill extends StatelessWidget {
//   final String text;
//   final Color bg, fg;
//   const _Pill({required this.text, required this.bg, required this.fg});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//       decoration:
//           BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
//       child: Text(text,
//           style:
//               TextStyle(color: fg, fontSize: 9, fontWeight: FontWeight.w700)),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DAY DETAIL SHEET — শুধু "যা করেছেন" দেখায় (positive accomplishments)।
// // মিস করা ফরজ বা না-করা আমল এখানে দেখানো হয় না — এই কুইক-পিক শিটের উদ্দেশ্য
// // অর্জন দেখানো, ঘাটতি নয় (মাসিক Fard section এ এমনিতেই মিস কাউন্ট আছে)।
// // ─────────────────────────────────────────────────────────────────────────────

// class _DayDetailSheet extends StatelessWidget {
//   final DailyEntry entry;
//   final Map<String, AmalCategory> catMap;
//   final String userGender;
//   const _DayDetailSheet(
//       {required this.entry, required this.catMap, required this.userGender});

//   bool _isAccomplished(DailyEntryItem item) {
//     if (item.prayerMode != null) {
//       return item.prayerMode == PrayerMode.congregation ||
//           item.prayerMode == PrayerMode.solo;
//     }
//     return item.completed || item.count > 0;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isFemale = userGender == 'female';
//     final isExempt = entry.isExemptDay && isFemale;
//     final items = entry.entries
//         .where((e) => catMap.containsKey(e.categoryId) && _isAccomplished(e))
//         .map((e) => MapEntry(catMap[e.categoryId]!, e))
//         .toList()
//       ..sort((a, b) => a.key.order.compareTo(b.key.order));

//     return DraggableScrollableSheet(
//       initialChildSize: 0.6,
//       minChildSize: 0.35,
//       maxChildSize: 0.9,
//       expand: false,
//       builder: (context, scrollController) => Container(
//         decoration: const BoxDecoration(
//           color: AmolColors.cardBg,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//         ),
//         child: Column(children: [
//           const SizedBox(height: 12),
//           Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                   color: AmolColors.border,
//                   borderRadius: BorderRadius.circular(99))),
//           const SizedBox(height: 16),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text('${entry.day} তারিখে যা করেছেন',
//                         style: const TextStyle(
//                             color: AmolColors.textPrimary,
//                             fontWeight: FontWeight.w800,
//                             fontSize: 15)),
//                     if (items.isNotEmpty) ...[
//                       const SizedBox(height: 2),
//                       Text('${items.length} টি আমল সম্পন্ন',
//                           style: const TextStyle(
//                               color: AmolColors.textHint,
//                               fontSize: 10.5,
//                               fontWeight: FontWeight.w500)),
//                     ],
//                   ],
//                 ),
//               ),
//               if (isExempt)
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                       color: AmolColors.purplePale,
//                       borderRadius: BorderRadius.circular(20)),
//                   child: const Text('🌸 মাহলি',
//                       style: TextStyle(
//                           color: AmolColors.purple,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w700)),
//                 ),
//             ]),
//           ),
//           const SizedBox(height: 14),
//           Expanded(
//             child: items.isEmpty
//                 ? Center(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 30),
//                       child: Column(mainAxisSize: MainAxisSize.min, children: [
//                         Text(isExempt ? '🌸' : '📭',
//                             style: const TextStyle(fontSize: 26)),
//                         const SizedBox(height: 8),
//                         Text(
//                             isExempt
//                                 ? 'মাহলির দিন — নামাজ ও রোজা মাফ'
//                                 : 'এই দিনে কোনো আমল সম্পন্ন হয়নি',
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                                 color: AmolColors.textHint, fontSize: 12.5)),
//                       ]),
//                     ),
//                   )
//                 : ListView.separated(
//                     controller: scrollController,
//                     padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
//                     itemCount: items.length,
//                     separatorBuilder: (_, __) => const Divider(
//                         height: 18, color: AmolColors.border, thickness: 0.5),
//                     itemBuilder: (ctx, i) => _DayDetailRow(
//                         category: items[i].key, item: items[i].value),
//                   ),
//           ),
//         ]),
//       ),
//     );
//   }
// }

// class _DayDetailRow extends StatelessWidget {
//   final AmalCategory category;
//   final DailyEntryItem item;
//   const _DayDetailRow({required this.category, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     final isFardPrayer = category.isFard && category.isPrayer;
//     String statusText;
//     Color statusColor;
//     IconData statusIcon;

//     if (isFardPrayer) {
//       final isCongregation = item.prayerMode == PrayerMode.congregation;
//       statusText = isCongregation ? 'জামাতে আদায়' : 'একাকী আদায়';
//       statusColor = isCongregation ? AmolColors.purple : AmolColors.amber;
//       statusIcon = isCongregation ? Icons.people_rounded : Icons.person_rounded;
//     } else if (category.inputType == AmalInputType.counter ||
//         category.inputType == AmalInputType.duration) {
//       final unitBn = AmolUnit.bn(category.unit);
//       statusText = '${item.count}${unitBn.isNotEmpty ? " $unitBn" : ""}';
//       statusColor = AmolColors.green;
//       statusIcon = Icons.check_circle_rounded;
//     } else {
//       statusText = 'সম্পন্ন';
//       statusColor = AmolColors.green;
//       statusIcon = Icons.check_circle_rounded;
//     }

//     return Row(children: [
//       AmolIcon(category: category, size: 36),
//       const SizedBox(width: 12),
//       Expanded(
//         child: Text(category.nameBn,
//             style: const TextStyle(
//                 color: AmolColors.textPrimary,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 13)),
//       ),
//       Row(mainAxisSize: MainAxisSize.min, children: [
//         Icon(statusIcon, size: 15, color: statusColor),
//         const SizedBox(width: 5),
//         Text(statusText,
//             style: TextStyle(
//                 color: statusColor,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 11.5)),
//       ]),
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
//           color: AmolColors.cardBg,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
//       padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         Container(
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//                 color: AmolColors.border,
//                 borderRadius: BorderRadius.circular(99))),
//         const SizedBox(height: 22),
//         const Text('মাস বেছে নিন',
//             style: TextStyle(
//                 color: AmolColors.textPrimary,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700)),
//         const SizedBox(height: 18),
//         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           _YearArrow(
//               icon: Icons.chevron_left_rounded,
//               onTap: () => setState(() => _y--),
//               enabled: true),
//           Container(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//               decoration: BoxDecoration(
//                   color: AmolColors.greenLight,
//                   borderRadius: BorderRadius.circular(12)),
//               child: Text('$_y',
//                   style: const TextStyle(
//                       color: AmolColors.darkGreen,
//                       fontWeight: FontWeight.w800,
//                       fontSize: 18))),
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
//                   color: isSelected ? AmolColors.darkGreen : AmolColors.pageBg,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(
//                       color: isSelected
//                           ? AmolColors.darkGreen
//                           : isFuture
//                               ? AmolColors.border.withOpacity(0.4)
//                               : AmolColors.border,
//                       width: 0.5),
//                 ),
//                 child: Center(
//                     child: FittedBox(
//                         fit: BoxFit.scaleDown,
//                         child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 4),
//                             child: Text(AppConstants.bengaliMonths[i],
//                                 style: TextStyle(
//                                     color: isSelected
//                                         ? Colors.white
//                                         : isFuture
//                                             ? AmolColors.textHint
//                                             : AmolColors.textSecondary,
//                                     fontSize: 12,
//                                     fontWeight: isSelected
//                                         ? FontWeight.w700
//                                         : FontWeight.w500))))),
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
//           color: enabled ? AmolColors.greenLight : AmolColors.pageBg,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//               color: enabled ? AmolColors.borderMid : AmolColors.border,
//               width: 0.5),
//         ),
//         child: Icon(icon,
//             color: enabled ? AmolColors.darkGreen : AmolColors.textHint,
//             size: 20),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SKELETONS
// // ─────────────────────────────────────────────────────────────────────────────

// class _HeroBandSkeleton extends StatelessWidget {
//   const _HeroBandSkeleton();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AmolColors.darkGreen,
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
//     return Column(children: [_row(top: 12), _row(top: 8)]);
//   }

//   static Widget _row({required double top}) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(16, top, 16, 0),
//       child: Row(
//           children: List.generate(
//               3,
//               (i) => Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
//                       child: const AmolShimmerBox(height: 86, radius: 13),
//                     ),
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
//       child: AmolShimmerBox(height: height, radius: 16),
//     );
//   }
// }

// class _EntriesSkeleton extends StatelessWidget {
//   const _EntriesSkeleton();

//   @override
//   Widget build(BuildContext context) {
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       const SizedBox(height: 22),
//       const AmolShimmerBox(width: 130, height: 14, radius: 8),
//       const SizedBox(height: 12),
//       const AmolShimmerBox(height: 240, radius: 16),
//       const SizedBox(height: 22),
//       const AmolShimmerBox(width: 150, height: 14, radius: 8),
//       const SizedBox(height: 12),
//       Container(
//         decoration: BoxDecoration(
//             color: AmolColors.cardBg,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: AmolColors.border, width: 0.5)),
//         child: Column(
//             children: List.generate(
//                 5,
//                 (i) => Padding(
//                       padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
//                       child: const AmolShimmerBox(height: 64, radius: 10),
//                     ))),
//       ),
//     ]);
//   }
// }
import 'package:amal_tracker/features/monthly_summary/screens/category_list_screen.dart';
import 'package:amal_tracker/features/monthly_summary/widgets/monthly_amol_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tracker_provider.dart';
import '../models/tracker_model.dart';
import '../../../core/constants/app_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class MonthlyViewScreen extends ConsumerStatefulWidget {
  const MonthlyViewScreen({super.key});

  @override
  ConsumerState<MonthlyViewScreen> createState() => _MonthlyViewScreenState();
}

class _MonthlyViewScreenState extends ConsumerState<MonthlyViewScreen> {
  late int _year;
  late int _month;
  final _sc = ScrollController();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  void _showPeriodPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _PeriodPickerSheet(
        year: _year,
        month: _month,
        onPicked: (y, m) => setState(() {
          _year = y;
          _month = m;
        }),
      ),
    );
  }

  void _openCategoryList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryListScreen(year: _year, month: _month),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final params = (year: _year, month: _month);
    final entriesAsync = ref.watch(monthlyEntriesProvider(params));
    final progressAsync = ref.watch(progressSummaryProvider(params));

    final monthName = AppConstants.bengaliMonths[_month - 1];
    final now = DateTime.now();
    final isCurrentMonth = _year == now.year && _month == now.month;

    return Scaffold(
      backgroundColor: AmolColors.pageBg,
      body: RefreshIndicator(
        color: AmolColors.darkGreen,
        onRefresh: () async {
          ref.invalidate(monthlyEntriesProvider(params));
          ref.invalidate(progressSummaryProvider(params));
          ref.invalidate(categoriesProvider);
        },
        child: CustomScrollView(
          controller: _sc,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // ── App Bar ────────────────────────────────────────────────────
            SliverAppBar(
              pinned: true,
              expandedHeight: 0,
              toolbarHeight: 56,
              backgroundColor: AmolColors.darkGreen,
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
                        color: Colors.white.withOpacity(0.15), width: 0.5),
                  ),
                  child: const Icon(Icons.calendar_month_outlined,
                      color: Colors.white, size: 15),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('মাসিক রিপোর্ট',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.55),
                                fontSize: 10,
                                fontWeight: FontWeight.w500)),
                        Text('$monthName $_year',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                                height: 1.1)),
                      ]),
                ),
              ]),
              actions: [
                GestureDetector(
                  onTap: _showPeriodPicker,
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.18), width: 0.5),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.swap_horiz_rounded,
                          size: 13, color: Colors.white.withOpacity(0.7)),
                      const SizedBox(width: 5),
                      const Text('মাস বদলান',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12)),
                    ]),
                  ),
                ),
              ],
            ),

            // ── Hero Band ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: progressAsync.when(
                loading: () => const _HeroBandSkeleton(),
                error: (_, __) => const _HeroBandSkeleton(),
                data: (p) => _HeroBand(tracker: p.currentMonth),
              ),
            ),

            // ── Female Exempt Banner ───────────────────────────────────────
            SliverToBoxAdapter(
              child: progressAsync.whenOrNull(
                data: (p) {
                  if (p.userGender != 'female') return const SizedBox.shrink();
                  final n = p.currentMonth?.exemptDays ?? 0;
                  if (n == 0) return const SizedBox.shrink();
                  return _ExemptBanner(exemptCount: n);
                },
              ),
            ),

            // ── Stat Strip ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: progressAsync.when(
                loading: () => const _StatStripSkeleton(),
                error: (_, __) => const _StatStripSkeleton(),
                data: (p) => _StatStrip(
                  tracker: p.currentMonth,
                  userGender: p.userGender,
                ),
              ),
            ),

            // ── Entry card → dedicated "সব আমল" full page (search + filter +
            //    per-category monthly stat + tap-in detail page) ───────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: AmolNavEntryCard(
                  emoji: '🗂️',
                  title: 'সব আমল দেখুন',
                  subtitle:
                      '$monthName মাসের প্রতিটা আমলের বিস্তারিত ও প্রগ্রেস',
                  onTap: _openCategoryList,
                ),
              ),
            ),

            // ── Fard Performance ───────────────────────────────────────────
            SliverToBoxAdapter(
              child: progressAsync.when(
                loading: () => const _SectionSkeleton(height: 120),
                error: (_, __) => const SizedBox.shrink(),
                data: (p) {
                  if (p.currentMonth == null ||
                      p.currentMonth!.eligibleDays == 0) {
                    return const SizedBox.shrink();
                  }
                  return _FardSection(tracker: p.currentMonth!);
                },
              ),
            ),

            // ── Weekly Chart (current month only) ──────────────────────────
            if (isCurrentMonth)
              SliverToBoxAdapter(
                child: progressAsync.when(
                  loading: () => const _SectionSkeleton(height: 160),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (p) => _WeeklyChartSection(
                    weekData: p.currentWeekProgress,
                    userGender: p.userGender,
                  ),
                ),
              ),

            // ── Prayer Today Breakdown (current month only, fixed responsive) ─
            if (isCurrentMonth)
              SliverToBoxAdapter(
                child: progressAsync.when(
                  loading: () => const _SectionSkeleton(height: 100),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (p) {
                    if (p.todayPrayerBreakdown.isEmpty)
                      return const SizedBox.shrink();
                    return _TodayPrayerSection(prayers: p.todayPrayerBreakdown);
                  },
                ),
              ),

            // ── Previous Months Comparison ──────────────────────────────────
            SliverToBoxAdapter(
              child: progressAsync.when(
                loading: () => const _SectionSkeleton(height: 140),
                error: (_, __) => const SizedBox.shrink(),
                data: (p) {
                  final allMonths = p.recentMonths;
                  if (allMonths.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child:
                          AmolEmptyCard(label: 'মাসিক তুলনামূলক কোনো ডেটা নেই'),
                    );
                  }
                  return _PrevMonthsSection(
                      months: allMonths.reversed.toList());
                },
              ),
            ),

            // ── Rank Card ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: progressAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (p) {
                  if (p.currentMonth == null || p.currentMonth!.rank == null) {
                    return const SizedBox.shrink();
                  }
                  return _RankSection(tracker: p.currentMonth!);
                },
              ),
            ),

            // ── Heatmap + Day List ─────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: entriesAsync.when(
                loading: () =>
                    const SliverToBoxAdapter(child: _EntriesSkeleton()),
                error: (_, __) => SliverToBoxAdapter(
                    child: AmolErrorCard(
                        onRetry: () =>
                            ref.invalidate(monthlyEntriesProvider(params)))),
                data: (entries) {
                  final userGender =
                      progressAsync.valueOrNull?.userGender ?? 'male';
                  return SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 15),
                      const AmolSectionHeader(
                          title: 'দৈনিক ক্যালেন্ডার', emoji: '📅'),
                      const SizedBox(height: 10),
                      _HeatmapCalendar(
                          year: _year,
                          month: _month,
                          entries: entries,
                          userGender: userGender),
                      const SizedBox(height: 22),
                      const AmolSectionHeader(
                          title: 'দিন অনুযায়ী বিস্তারিত', emoji: '📋'),
                      const SizedBox(height: 3),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text('যেকোনো দিনে ট্যাপ করে বিস্তারিত দেখুন',
                            style: TextStyle(
                                color: AmolColors.textHint,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500)),
                      ),
                      if (entries.isEmpty)
                        AmolEmptyCard(label: '$monthName মাসে কোনো আমল নেই')
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: AmolColors.cardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AmolColors.border, width: 0.5),
                          ),
                          child: Column(
                            children: List.generate(
                              entries.length,
                              (i) => _DayRow(
                                entry: entries[i],
                                isLast: i == entries.length - 1,
                                delay: 220 + i * 25,
                                userGender: userGender,
                              ),
                            ),
                          ),
                        ),
                    ]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HERO BAND
// ─────────────────────────────────────────────────────────────────────────────

class _HeroBand extends StatelessWidget {
  final MonthlyTracker? tracker;
  const _HeroBand({required this.tracker});

  String _winnerLabel(String? cat) {
    switch (cat) {
      case 'TOP_FARZ':
        return 'ফরজ চ্যাম্পিয়ন 🕌';
      case 'TOP_JAMAAT':
        return 'জামাত চ্যাম্পিয়ন 🤝';
      case 'TOP_QURAN':
        return 'কুরআন চ্যাম্পিয়ন 📖';
      case 'TOP_STREAK':
        return 'সেরা ধারাবাহিকতা 🔥';
      default:
        return 'মাসিক বিজয়ী 🏆';
    }
  }

  @override
  Widget build(BuildContext context) {
    final pct = (tracker?.completionPercentage ?? 0).clamp(0.0, 100.0);
    final farzDays = tracker?.farzCompletedDays ?? 0;
    final eligibleDays = tracker?.eligibleDays ?? 0;
    final jamaat = tracker?.congregationDaysSum ?? 0;
    final streak = tracker?.streakDays ?? 0;
    final isWinner = tracker?.isWinner ?? false;
    final rank = tracker?.rank;

    return Container(
      color: AmolColors.darkGreen,
      child: Stack(children: [
        Positioned(
            top: -45,
            right: -40,
            child: Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Color(0x0AFFFFFF)))),
        Positioned(
            bottom: -25,
            left: 18,
            child: Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Color(0x07FFFFFF)))),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('মাসের আমলের সারসংক্ষেপ',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0x17FFFFFF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0x2EFFFFFF), width: 0.5),
              ),
              child: Row(children: [
                _CircularProgress(percentage: pct, size: 66),
                const SizedBox(width: 14),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                            eligibleDays > 0
                                ? '$farzDays/$eligibleDays দিন'
                                : '$farzDays দিন',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 24,
                                letterSpacing: -0.5,
                                height: 1)),
                      ),
                      const SizedBox(height: 2),
                      Text('সব ফরজ পূর্ণ',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.45),
                              fontSize: 10)),
                      const SizedBox(height: 7),
                      Wrap(spacing: 6, runSpacing: 4, children: [
                        _HeroChip(
                            icon: Icons.people_rounded, label: '$jamaat জামাত'),
                        _HeroChip(
                            icon: Icons.local_fire_department_rounded,
                            label: '$streak দিন ধারা'),
                      ]),
                      if (isWinner) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: AmolColors.gold,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Text('🏆', style: TextStyle(fontSize: 10)),
                            const SizedBox(width: 4),
                            Flexible(
                                child: Text(
                                    _winnerLabel(tracker?.winnerCategory),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1)),
                          ]),
                        ),
                      ],
                    ])),
                const SizedBox(width: 12),
                if (rank != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.15), width: 0.5),
                    ),
                    child: Column(children: [
                      Text('র‍্যাংক',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.45),
                              fontSize: 8.5)),
                      Text('#$rank',
                          style: const TextStyle(
                              color: AmolColors.gold,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              height: 1.1)),
                    ]),
                  ),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HeroChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: Colors.white.withOpacity(0.7), size: 11),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 10.5,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _CircularProgress extends StatelessWidget {
  final double percentage;
  final double size;
  const _CircularProgress({required this.percentage, required this.size});

  @override
  Widget build(BuildContext context) {
    final str = '${percentage.toInt()}%';
    final innerSize = size * 0.80;
    final Color barColor = percentage >= 80
        ? AmolColors.green
        : percentage >= 50
            ? AmolColors.gold
            : AmolColors.amber;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(alignment: Alignment.center, children: [
        SizedBox.expand(
            child: CircularProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.white.withOpacity(0.12),
          valueColor: AlwaysStoppedAnimation(barColor),
          strokeWidth: size * 0.09,
          strokeCap: StrokeCap.round,
        )),
        Container(
          width: innerSize,
          height: innerSize,
          decoration: const BoxDecoration(
              color: AmolColors.darkGreen, shape: BoxShape.circle),
          child: Center(
              child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: EdgeInsets.all(size * 0.05),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(str,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: size * 0.165,
                        height: 1),
                    textAlign: TextAlign.center),
                SizedBox(height: size * 0.02),
                Text('সম্পন্ন',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.45),
                        fontSize: size * 0.12),
                    textAlign: TextAlign.center),
              ]),
            ),
          )),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EXEMPT BANNER
// ─────────────────────────────────────────────────────────────────────────────

class _ExemptBanner extends StatelessWidget {
  final int exemptCount;
  const _ExemptBanner({required this.exemptCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AmolColors.purplePale,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AmolColors.purple.withOpacity(0.25), width: 0.5),
      ),
      child: Row(children: [
        Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: AmolColors.purpleLight,
                borderRadius: BorderRadius.circular(8)),
            child: const Center(
                child: Text('🌸', style: TextStyle(fontSize: 15)))),
        const SizedBox(width: 10),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('মাহলির দিন চিহ্নিত',
              style: TextStyle(
                  color: AmolColors.purple,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text('$exemptCount দিন মাফ — নামাজ ও রোজার হিসাব বাদ দেওয়া হয়েছে',
              style: TextStyle(
                  color: AmolColors.purple.withOpacity(0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.w500)),
        ])),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STAT STRIP
// ─────────────────────────────────────────────────────────────────────────────

class _StatStrip extends StatelessWidget {
  final MonthlyTracker? tracker;
  final String userGender;
  const _StatStrip({this.tracker, required this.userGender});

  @override
  Widget build(BuildContext context) {
    final streak = tracker?.streakDays ?? 0;
    final daysActive = tracker?.daysActive ?? 0;
    final farzDays = tracker?.farzCompletedDays ?? 0;
    final jamaat = tracker?.congregationDaysSum ?? 0;
    final eligible = tracker?.eligibleDays ?? 0;
    final exemptDays = tracker?.exemptDays ?? 0;
    final isFemale = userGender == 'female';

    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Row(children: [
          Expanded(
              child: _StatCard(
                  emoji: '🔥',
                  emojiBg: AmolColors.amberLight,
                  value: '$streak',
                  label: 'স্ট্রিক দিন',
                  valueColor: AmolColors.amber)),
          const SizedBox(width: 8),
          Expanded(
              child: _StatCard(
                  emoji: '📅',
                  emojiBg: AmolColors.greenLight,
                  value: '$daysActive',
                  label: 'আমল করা দিন',
                  valueColor: AmolColors.green)),
          const SizedBox(width: 8),
          Expanded(
              child: _StatCard(
                  emoji: '✅',
                  emojiBg: AmolColors.greenLight,
                  value: '$farzDays',
                  label: 'পূর্ণ ফরজ দিন',
                  valueColor: AmolColors.darkGreen)),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Row(children: [
          Expanded(
              child: _StatCard(
                  emoji: '🕌',
                  emojiBg: AmolColors.purpleLight,
                  value: '$jamaat',
                  label: 'জামাত দিন',
                  valueColor: AmolColors.purple)),
          const SizedBox(width: 8),
          Expanded(
              child: _StatCard(
                  emoji: '⏳',
                  emojiBg: AmolColors.greenLight,
                  value: '$eligible',
                  label: 'হিসাবের দিন',
                  valueColor: AmolColors.green)),
          const SizedBox(width: 8),
          if (isFemale)
            Expanded(
                child: _StatCard(
                    emoji: '🌸',
                    emojiBg: AmolColors.purplePale,
                    value: '$exemptDays',
                    label: 'মাহলির দিন',
                    valueColor: AmolColors.purple))
          else
            Expanded(
                child: _StatCard(
                    emoji: '🏅',
                    emojiBg: AmolColors.goldLight,
                    value: tracker?.rank != null ? '#${tracker!.rank}' : '---',
                    label: 'র‍্যাংক',
                    valueColor: AmolColors.gold)),
        ]),
      ),
    ]);
  }
}

class _StatCard extends StatelessWidget {
  final String emoji, value, label;
  final Color emojiBg, valueColor;
  const _StatCard(
      {required this.emoji,
      required this.emojiBg,
      required this.value,
      required this.label,
      required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
          color: AmolColors.cardBg,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AmolColors.border, width: 0.5)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
                color: emojiBg, borderRadius: BorderRadius.circular(7)),
            child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 13)))),
        const SizedBox(height: 7),
        FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value,
                style: TextStyle(
                    color: valueColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 19,
                    letterSpacing: -0.4,
                    height: 1))),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(
                color: AmolColors.textSecondary,
                fontSize: 9.5,
                fontWeight: FontWeight.w500)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FARD PERFORMANCE
// ─────────────────────────────────────────────────────────────────────────────

class _FardSection extends StatelessWidget {
  final MonthlyTracker tracker;
  const _FardSection({required this.tracker});

  @override
  Widget build(BuildContext context) {
    final pct = tracker.completionPercentage.clamp(0.0, 100.0);
    final farzDays = tracker.farzCompletedDays;
    final eligible = tracker.eligibleDays;
    final jamaat = tracker.congregationDaysSum;

    Color statusColor() {
      if (pct >= 90) return AmolColors.green;
      if (pct >= 70) return AmolColors.amber;
      return AmolColors.red;
    }

    String statusLabel() {
      if (pct >= 90) return 'চমৎকার';
      if (pct >= 70) return 'ভালো';
      if (pct >= 50) return 'মাঝামাঝি';
      return 'উন্নতি দরকার';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const AmolSectionHeader(title: 'ফরজ পারফরম্যান্স', emoji: '🕌'),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
              child: _FardCard(
            title: 'পূর্ণ ফরজ দিন',
            bigValue: '${pct.toInt()}%',
            subValue: '$farzDays/$eligible দিন',
            badgeLabel: statusLabel(),
            badgeColor: statusColor(),
            barValue: pct / 100,
            barColor: statusColor(),
          )),
          const SizedBox(width: 10),
          Expanded(
              child: _FardCard(
            title: 'মোট জামাত',
            bigValue: '$jamaat',
            subValue: '৫ ওয়াক্ত × দিন মিলিয়ে',
            badgeLabel: jamaat > 0 ? 'জামাতে পড়া হয়েছে' : 'কোনো জামাত নেই',
            badgeColor: jamaat > 0 ? AmolColors.purple : AmolColors.textHint,
            barValue:
                eligible > 0 ? (jamaat / (eligible * 5)).clamp(0.0, 1.0) : 0,
            barColor: AmolColors.purple,
          )),
        ]),
      ]),
    );
  }
}

class _FardCard extends StatelessWidget {
  final String title, bigValue, subValue, badgeLabel;
  final Color badgeColor, barColor;
  final double barValue;
  const _FardCard(
      {required this.title,
      required this.bigValue,
      required this.subValue,
      required this.badgeLabel,
      required this.badgeColor,
      required this.barColor,
      required this.barValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AmolColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AmolColors.border, width: 0.5)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Text(title,
                  style: const TextStyle(
                      color: AmolColors.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20)),
            child: Text(badgeLabel,
                style: TextStyle(
                    color: badgeColor,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 8),
        FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(bigValue,
                style: TextStyle(
                    color: badgeColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1))),
        const SizedBox(height: 2),
        Text(subValue,
            style: const TextStyle(color: AmolColors.textHint, fontSize: 9.5)),
        const SizedBox(height: 8),
        ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
                value: barValue.clamp(0.0, 1.0),
                minHeight: 5,
                backgroundColor: AmolColors.pageBg,
                valueColor: AlwaysStoppedAnimation(barColor))),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WEEKLY CHART
// ─────────────────────────────────────────────────────────────────────────────

class _WeeklyChartSection extends StatelessWidget {
  final List<WeeklyDayProgress> weekData;
  final String userGender;
  const _WeeklyChartSection({required this.weekData, required this.userGender});

  @override
  Widget build(BuildContext context) {
    if (weekData.isEmpty) return const SizedBox.shrink();

    final isFemale = userGender == 'female';
    final today = DateTime.now();
    final activeDays = weekData.where((d) => d.hasActivity).length;
    final exemptCnt = weekData.where((d) => d.isExemptDay).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const AmolSectionHeader(title: 'এই সপ্তাহের অগ্রগতি', emoji: '📊'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          decoration: BoxDecoration(
              color: AmolColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AmolColors.border, width: 0.5)),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(builder: (ctx, constraints) {
                  final chartH =
                      (constraints.maxWidth * 0.36).clamp(80.0, 140.0);
                  const dayLblH = 14.0;
                  const gapH = 8.0;
                  final barAreaH =
                      (chartH - dayLblH - gapH).clamp(20.0, chartH);

                  return SizedBox(
                    height: chartH,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: weekData.map((d) {
                        final dayDate = DateTime.tryParse(d.date);
                        final isToday = dayDate != null &&
                            dayDate.year == today.year &&
                            dayDate.month == today.month &&
                            dayDate.day == today.day;
                        final showExempt = d.isExemptDay && isFemale;

                        Color barColor;
                        double barH;
                        if (showExempt) {
                          barColor = AmolColors.purple;
                          barH = barAreaH * 0.5;
                        } else if (d.hasActivity) {
                          barColor =
                              isToday ? AmolColors.darkGreen : AmolColors.green;
                          barH = barAreaH;
                        } else {
                          barColor = AmolColors.border;
                          barH = barAreaH * 0.12;
                        }

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (d.hasActivity && !showExempt)
                                    Container(
                                      width: 5,
                                      height: 5,
                                      margin: const EdgeInsets.only(bottom: 3),
                                      decoration: BoxDecoration(
                                          color: isToday
                                              ? AmolColors.darkGreen
                                              : AmolColors.green,
                                          shape: BoxShape.circle),
                                    )
                                  else
                                    const SizedBox(height: 8),
                                  if (showExempt)
                                    Container(
                                      height: barH,
                                      decoration: BoxDecoration(
                                        color: AmolColors.purpleLight,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                            color: AmolColors.purple
                                                .withOpacity(0.3),
                                            width: 0.5),
                                      ),
                                      child: const Center(
                                          child: Text('🌸',
                                              style: TextStyle(fontSize: 8))),
                                    )
                                  else
                                    AnimatedContainer(
                                      duration: 400.ms,
                                      height: barH,
                                      decoration: BoxDecoration(
                                        color: barColor,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(4)),
                                      ),
                                    ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                      height: dayLblH,
                                      child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(d.day,
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  color: isToday
                                                      ? AmolColors.darkGreen
                                                      : AmolColors
                                                          .textSecondary,
                                                  fontWeight: isToday
                                                      ? FontWeight.w800
                                                      : FontWeight.w500)))),
                                ]),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
                const SizedBox(height: 10),
                const Divider(
                    height: 1, thickness: 0.5, color: AmolColors.border),
                const SizedBox(height: 10),
                Row(children: [
                  _WeekChip(
                      label: 'সক্রিয় দিন',
                      value: '$activeDays/7',
                      color: AmolColors.green),
                  const SizedBox(width: 8),
                  _WeekChip(
                      label: 'বাকি দিন',
                      value: '${7 - activeDays - exemptCnt}',
                      color: AmolColors.textSecondary),
                  if (isFemale && exemptCnt > 0) ...[
                    const SizedBox(width: 8),
                    _WeekChip(
                        label: 'মাহলি',
                        value: '$exemptCnt',
                        color: AmolColors.purple),
                  ],
                ]),
                const SizedBox(height: 10),
                Wrap(spacing: 12, runSpacing: 4, children: [
                  AmolLegendDot(
                      color: AmolColors.green, label: 'আমল করা হয়েছে'),
                  AmolLegendDot(
                      color: AmolColors.border, label: 'কোনো আমল নেই'),
                  if (isFemale)
                    AmolLegendDot(
                        color: AmolColors.purpleLight, label: 'মাহলির দিন'),
                ]),
              ]),
        ),
      ]),
    );
  }
}

class _WeekChip extends StatelessWidget {
  final String label, value;
  final Color color;
  const _WeekChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
            color: AmolColors.pageBg, borderRadius: BorderRadius.circular(8)),
        child: Column(children: [
          FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value,
                  style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      height: 1))),
          const SizedBox(height: 2),
          FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label,
                  style: const TextStyle(
                      color: AmolColors.textHint, fontSize: 8.5),
                  textAlign: TextAlign.center)),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TODAY PRAYER BREAKDOWN — Row + Expanded দিয়ে ৫টা সমান কলাম। Expanded ব্যবহার
// করায় Flutter constraint অনুযায়ী প্রতিটা কলামের width গাণিতিকভাবে নির্দিষ্ট
// (মোট width ÷ ৫) — তাই দুইটা আইটেম কখনো একে অপরের উপর/মধ্যে বসতে পারে না,
// এবং পুরো card width সমান ভাগে ব্যবহার হয় (কোনো ফাঁকা জায়গা অপচয় হয় না)।
// প্রতিটা কলামের ভেতরে FittedBox থাকায় লম্বা লেবেল ("মাগরিব") ছোট স্ক্রিনেও
// নিজের bounded width এর মধ্যেই scale-down হয়ে বসে যায়, overflow হয় না।
// ─────────────────────────────────────────────────────────────────────────────

class _TodayPrayerSection extends StatelessWidget {
  final List<PrayerBreakdownItem> prayers;
  const _TodayPrayerSection({required this.prayers});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const AmolSectionHeader(title: 'আজকের নামাজের অবস্থা', emoji: '🕌'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
          decoration: BoxDecoration(
              color: AmolColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AmolColors.border, width: 0.5)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: prayers.map((p) {
              Color color;
              IconData icon;
              String label;

              if (p.mode == null) {
                color = AmolColors.textHint;
                icon = Icons.radio_button_unchecked_rounded;
                label = 'বাকি';
              } else if (p.mode == PrayerMode.congregation) {
                color = AmolColors.green;
                icon = Icons.people_rounded;
                label = 'জামাত';
              } else if (p.mode == PrayerMode.solo) {
                color = AmolColors.amber;
                icon = Icons.person_rounded;
                label = 'একাকী';
              } else {
                color = AmolColors.red;
                icon = Icons.close_rounded;
                label = 'মিস';
              }

              return Expanded(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: color.withOpacity(0.3), width: 0.5)),
                    child: Icon(icon, color: color, size: 17),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(p.nameBn,
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(
                              color: AmolColors.textPrimary,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(label,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                              color: color,
                              fontSize: 9,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ]),
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COMPARE METRIC — multi-metric monthly comparison
// ─────────────────────────────────────────────────────────────────────────────

enum _CompareMetric {
  completion,
  farz,
  congregation,
  quran,
  dhikr,
  fasting,
  akhlaq,
  streak
}

extension _CompareMetricX on _CompareMetric {
  String get labelBn {
    switch (this) {
      case _CompareMetric.completion:
        return 'সম্পন্ন %';
      case _CompareMetric.farz:
        return 'পূর্ণ ফরজ দিন';
      case _CompareMetric.congregation:
        return 'জামাত দিন';
      case _CompareMetric.quran:
        return 'কুরআন আয়াত';
      case _CompareMetric.dhikr:
        return 'যিকর স্কোর';
      case _CompareMetric.fasting:
        return 'নফল রোজা';
      case _CompareMetric.akhlaq:
        return 'আখলাক দিন';
      case _CompareMetric.streak:
        return 'স্ট্রিক দিন';
    }
  }

  String get emoji {
    switch (this) {
      case _CompareMetric.completion:
        return '✅';
      case _CompareMetric.farz:
        return '🕌';
      case _CompareMetric.congregation:
        return '🤝';
      case _CompareMetric.quran:
        return '📖';
      case _CompareMetric.dhikr:
        return '📿';
      case _CompareMetric.fasting:
        return '🌙';
      case _CompareMetric.akhlaq:
        return '🤲';
      case _CompareMetric.streak:
        return '🔥';
    }
  }

  // RecentMonthSummary — backend এখন recentMonths এ পূর্ণ MonthlyTracker না
  // পাঠিয়ে trimmed object পাঠায় (শুধু compare chart এ লাগে এমন ৮টা scalar
  // field), তাই এই টাইপ RecentMonthSummary — MonthlyTracker না।
  double valueOf(RecentMonthSummary t) {
    switch (this) {
      case _CompareMetric.completion:
        return t.completionPercentage;
      case _CompareMetric.farz:
        return t.farzCompletedDays.toDouble();
      case _CompareMetric.congregation:
        return t.congregationDaysSum.toDouble();
      case _CompareMetric.quran:
        return t.quranAyahTotal.toDouble();
      case _CompareMetric.dhikr:
        return t.dhikrScore.toDouble();
      case _CompareMetric.fasting:
        return t.fastingDays.toDouble();
      case _CompareMetric.akhlaq:
        return t.akhlaqDays.toDouble();
      case _CompareMetric.streak:
        return t.streakDays.toDouble();
    }
  }

  String display(RecentMonthSummary t) => this == _CompareMetric.completion
      ? '${valueOf(t).toInt()}%'
      : '${valueOf(t).toInt()}';
}

class _PrevMonthsSection extends StatefulWidget {
  final List<RecentMonthSummary> months;
  const _PrevMonthsSection({required this.months});

  @override
  State<_PrevMonthsSection> createState() => _PrevMonthsSectionState();
}

class _PrevMonthsSectionState extends State<_PrevMonthsSection> {
  _CompareMetric _metric = _CompareMetric.completion;

  @override
  Widget build(BuildContext context) {
    final months = widget.months;
    if (months.isEmpty) return const SizedBox.shrink();
    final current = months.last;

    final maxVal = months
        .map((m) => _metric.valueOf(m))
        .fold<double>(0, (a, b) => b > a ? b : a);
    final safeMax = maxVal <= 0 ? 1.0 : maxVal;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const AmolSectionHeader(title: 'মাসিক তুলনা', emoji: '📈'),
        const SizedBox(height: 10),
        SizedBox(
          height: 34,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _CompareMetric.values
                .map((m) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: AmolFilterChip(
                        label: m.labelBn,
                        emoji: m.emoji,
                        selected: _metric == m,
                        onTap: () => setState(() => _metric = m),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: AmolColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AmolColors.border, width: 0.5)),
          child: Column(children: [
            LayoutBuilder(builder: (ctx, constraints) {
              final chartH = (constraints.maxWidth * 0.36).clamp(90.0, 150.0);
              const valLblH = 14.0;
              const mthLblH = 12.0;
              const gapH = 8.0;
              final barAreaH =
                  (chartH - valLblH - mthLblH - gapH).clamp(16.0, chartH);

              return SizedBox(
                height: chartH,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: months.map((m) {
                    final isActive =
                        m.year == current.year && m.month == current.month;
                    final val = _metric.valueOf(m);
                    final fillH = val > 0
                        ? ((val / safeMax) * barAreaH).clamp(4.0, barAreaH)
                        : 4.0;
                    final mName = AppConstants.bengaliMonths[m.month - 1];
                    final mShort =
                        mName.length > 3 ? mName.substring(0, 3) : mName;

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: valLblH,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(_metric.display(m),
                                    style: TextStyle(
                                        fontSize: 9,
                                        color: isActive
                                            ? AmolColors.darkGreen
                                            : AmolColors.textHint,
                                        fontWeight: isActive
                                            ? FontWeight.w800
                                            : FontWeight.w500)),
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedContainer(
                              duration: 400.ms,
                              height: fillH,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: val > 0
                                    ? (isActive
                                        ? AmolColors.darkGreen
                                        : AmolColors.midGreen.withOpacity(0.5))
                                    : AmolColors.pageBg,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(6)),
                                border: val > 0
                                    ? null
                                    : Border.all(
                                        color: AmolColors.border, width: 0.5),
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              height: mthLblH,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(mShort,
                                    style: TextStyle(
                                        fontSize: 9,
                                        color: isActive
                                            ? AmolColors.darkGreen
                                            : AmolColors.textSecondary,
                                        fontWeight: isActive
                                            ? FontWeight.w800
                                            : FontWeight.w500)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
            if (months.length >= 2) ...[
              const SizedBox(height: 12),
              const Divider(
                  height: 1, thickness: 0.5, color: AmolColors.border),
              const SizedBox(height: 10),
              _TrendLine(months: months, metric: _metric),
            ],
          ]),
        ),
      ]),
    );
  }
}

class _TrendLine extends StatelessWidget {
  final List<RecentMonthSummary> months;
  final _CompareMetric metric;
  const _TrendLine({required this.months, required this.metric});

  @override
  Widget build(BuildContext context) {
    final current = months.last;
    final prev = months[months.length - 2];
    final curVal = metric.valueOf(current);
    final prevVal = metric.valueOf(prev);
    final diff = curVal - prevVal;
    final isUp = diff > 0;
    final isSame = diff == 0;

    return Row(children: [
      Icon(
        isSame
            ? Icons.remove_rounded
            : (isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded),
        size: 16,
        color: isSame
            ? AmolColors.textHint
            : (isUp ? AmolColors.green : AmolColors.red),
      ),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          isSame
              ? 'গত মাসের সমান'
              : '${metric.labelBn} গত মাসের তুলনায় ${isUp ? "বেড়েছে" : "কমেছে"} ${diff.abs().toInt()}${metric == _CompareMetric.completion ? "%" : ""}',
          style: TextStyle(
              color: isSame
                  ? AmolColors.textHint
                  : (isUp ? AmolColors.green : AmolColors.red),
              fontSize: 11,
              fontWeight: FontWeight.w600),
        ),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RANK SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _RankSection extends StatelessWidget {
  final MonthlyTracker tracker;
  const _RankSection({required this.tracker});

  @override
  Widget build(BuildContext context) {
    final rank = tracker.rank!;
    final pct = tracker.completionPercentage.clamp(0.0, 100.0);
    final farzDays = tracker.farzCompletedDays;
    final jamaat = tracker.congregationDaysSum;

    String rankLabel() {
      if (rank <= 1) return 'সর্বোচ্চ অবস্থানে আছেন!';
      if (rank <= 3) return 'শীর্ষ ৩ জনের মধ্যে!';
      if (rank <= 10) return 'শীর্ষ ১০ জনের মধ্যে';
      return 'র‍্যাংক #$rank তে আছেন';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const AmolSectionHeader(title: 'লিডারবোর্ড অবস্থান', emoji: '🏅'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: AmolColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AmolColors.border, width: 0.5)),
          child: Row(children: [
            Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: AmolColors.greenLight,
                    borderRadius: BorderRadius.circular(14)),
                child: Center(
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text('#$rank',
                                style: const TextStyle(
                                    color: AmolColors.darkGreen,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900)))))),
            const SizedBox(width: 14),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(rankLabel(),
                      style: const TextStyle(
                          color: AmolColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(
                      'সম্পন্ন ${pct.toInt()}% · $farzDays পূর্ণ ফরজ দিন · $jamaat জামাত',
                      style: const TextStyle(
                          color: AmolColors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                          value: pct / 100,
                          minHeight: 5,
                          backgroundColor: AmolColors.pageBg,
                          valueColor: const AlwaysStoppedAnimation(
                              AmolColors.darkGreen))),
                ])),
            if (tracker.isWinner) ...[
              const SizedBox(width: 12),
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: AmolColors.goldLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AmolColors.gold.withOpacity(0.3), width: 0.5)),
                  child: const Text('🏆', style: TextStyle(fontSize: 22))),
            ],
          ]),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HEATMAP
// ─────────────────────────────────────────────────────────────────────────────

class _HeatmapCalendar extends StatelessWidget {
  final int year, month;
  final List<DailyEntry> entries;
  final String userGender;
  const _HeatmapCalendar(
      {required this.year,
      required this.month,
      required this.entries,
      required this.userGender});

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final entryMap = {for (final e in entries) e.day: e};
    final today = DateTime.now();
    final firstDay = DateTime(year, month, 1).weekday % 7;
    final totalCells = ((firstDay + daysInMonth) / 7).ceil() * 7;
    final isFemale = userGender == 'female';

    // entry.hasActivity flag এর বদলে actual entries থেকে হিসাব — day row এর
    // মতো এখানেও stale backend flag এর কারণে ভুল রঙ দেখানো এড়াতে
    bool _dayHasActivity(DailyEntry e) {
      if (e.hasActivity) return true;
      for (final item in e.entries) {
        if (item.prayerMode == PrayerMode.congregation ||
            item.prayerMode == PrayerMode.solo) return true;
        if (item.prayerMode == null && (item.completed || item.count > 0))
          return true;
      }
      return false;
    }

    int _intensity(DailyEntry e) {
      int score = 0;
      for (final item in e.entries) {
        if (item.prayerMode == PrayerMode.congregation) {
          score += 2;
        } else if (item.prayerMode == PrayerMode.solo) {
          score += 1;
        } else if (item.completed || item.count > 0) {
          score += 1;
        }
      }
      return score;
    }

    final maxScore = entries.isEmpty
        ? 1
        : entries
            .map(_intensity)
            .fold(0, (a, b) => a > b ? a : b)
            .clamp(1, 999);

    const weekdays = ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহঃ', 'শুক্র', 'শনি'];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: AmolColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AmolColors.border, width: 0.5)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
            children: weekdays
                .map((d) => Expanded(
                    child: Center(
                        child: Text(d,
                            style: const TextStyle(
                                color: AmolColors.textHint,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w500)))))
                .toList()),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              childAspectRatio: 1.1),
          itemCount: totalCells,
          itemBuilder: (ctx, index) {
            final dayNum = index - firstDay + 1;
            if (dayNum < 1 || dayNum > daysInMonth)
              return const SizedBox.shrink();

            final entry = entryMap[dayNum];
            final isExempt = (entry?.isExemptDay ?? false) && isFemale;
            final hasAct = entry != null && _dayHasActivity(entry);
            final score = entry != null ? _intensity(entry) : 0;
            final intensity = score / maxScore;
            final isToday = today.year == year &&
                today.month == month &&
                today.day == dayNum;
            final isFuture = DateTime(year, month, dayNum).isAfter(today);

            Color cellColor;
            Color numColor;

            if (isExempt) {
              cellColor = AmolColors.purplePale;
              numColor = AmolColors.purple;
            } else if (isFuture) {
              cellColor = AmolColors.pageBg;
              numColor = AmolColors.textHint;
            } else if (!hasAct) {
              cellColor = AmolColors.greenLight.withOpacity(0.4);
              numColor = AmolColors.textHint;
            } else if (intensity < 0.25) {
              cellColor = AmolColors.green.withOpacity(0.18);
              numColor = AmolColors.green;
            } else if (intensity < 0.5) {
              cellColor = AmolColors.green.withOpacity(0.38);
              numColor = AmolColors.green;
            } else if (intensity < 0.75) {
              cellColor = AmolColors.green.withOpacity(0.60);
              numColor = Colors.white;
            } else {
              cellColor = AmolColors.green.withOpacity(0.85);
              numColor = Colors.white;
            }

            return Container(
              decoration: BoxDecoration(
                color: cellColor,
                borderRadius: BorderRadius.circular(5),
                border: isToday
                    ? Border.all(color: AmolColors.gold, width: 1.5)
                    : null,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$dayNum',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: numColor,
                            height: 1)),
                    if (isExempt)
                      const Text('🌸',
                          style: TextStyle(fontSize: 6.5, height: 1))
                    else if (hasAct && !isFuture)
                      Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.only(top: 1),
                        decoration: BoxDecoration(
                            color: numColor.withOpacity(0.6),
                            shape: BoxShape.circle),
                      ),
                  ]),
            ).animate(delay: Duration(milliseconds: dayNum * 8)).scale(
                begin: const Offset(0.7, 0.7),
                duration: 200.ms,
                curve: Curves.easeOut);
          },
        ),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          const Text('কম  ',
              style: TextStyle(color: AmolColors.textHint, fontSize: 9.5)),
          ...List.generate(
              5,
              (i) => Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(right: 3),
                    decoration: BoxDecoration(
                        color: i == 0
                            ? AmolColors.greenLight.withOpacity(0.4)
                            : AmolColors.green.withOpacity(0.15 + i * 0.18),
                        borderRadius: BorderRadius.circular(3)),
                  )),
          const Text('  বেশি',
              style: TextStyle(color: AmolColors.textHint, fontSize: 9.5)),
          if (isFemale) ...[
            const SizedBox(width: 8),
            Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(right: 3),
                decoration: BoxDecoration(
                    color: AmolColors.purplePale,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                        color: AmolColors.purple.withOpacity(0.3),
                        width: 0.5))),
            const Text('মাহলি',
                style: TextStyle(color: AmolColors.textHint, fontSize: 9.5)),
          ],
        ]),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DAY ROW — tap করলে category-wise breakdown bottom sheet খোলে
// ─────────────────────────────────────────────────────────────────────────────

class _DayRow extends ConsumerWidget {
  final DailyEntry entry;
  final bool isLast;
  final int delay;
  final String userGender;
  const _DayRow(
      {required this.entry,
      required this.isLast,
      required this.delay,
      required this.userGender});

  void _showDayDetail(BuildContext context, WidgetRef ref) {
    final categories = ref.read(categoriesProvider).value ?? [];
    final catMap = {for (final c in categories) c.id: c};
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) =>
          _DayDetailSheet(entry: entry, catMap: catMap, userGender: userGender),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFemale = userGender == 'female';
    final isExempt = entry.isExemptDay && isFemale;
    final entries = entry.entries;

    final congregation =
        entries.where((e) => e.prayerMode == PrayerMode.congregation).length;
    final solo = entries.where((e) => e.prayerMode == PrayerMode.solo).length;
    final missed =
        entries.where((e) => e.prayerMode == PrayerMode.missed).length;

    final otherCompleted = entries
        .where((e) => e.prayerMode == null && (e.completed || e.count > 0))
        .length;

    final totalCompleted = congregation + solo + otherCompleted;
    // backend এর entry.hasActivity flag কে সরাসরি বিশ্বাস না করে, actual
    // entries থেকেই client-side এ হিসাব করা — flag stale/ভুল হলেও UI সঠিক
    // থাকবে (যেমন: ৩ জামাত করা সত্ত্বেও ভুলভাবে "কোনো আমল নেই" দেখানো বাগ)
    final hasActivity = entry.hasActivity || totalCompleted > 0;

    String monthShort(int idx) {
      final s = AppConstants.bengaliMonths[idx];
      return s.length >= 3 ? s.substring(0, 3) : s;
    }

    final prayerTotal = congregation + solo + missed;
    final progressVal = prayerTotal > 0
        ? congregation / prayerTotal
        : hasActivity
            ? 0.5
            : 0.0;

    Color barColor = isExempt
        ? AmolColors.purple
        : congregation >= 3
            ? AmolColors.green
            : congregation >= 1
                ? AmolColors.amber
                : AmolColors.border;

    return InkWell(
      onTap: () => _showDayDetail(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: isExempt
              ? AmolColors.purplePale.withOpacity(0.4)
              : hasActivity
                  ? AmolColors.greenLight.withOpacity(0.15)
                  : Colors.transparent,
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: AmolColors.border, width: 0.5)),
          borderRadius: isLast
              ? const BorderRadius.vertical(bottom: Radius.circular(16))
              : null,
        ),
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: isExempt
                  ? const LinearGradient(
                      colors: [AmolColors.purple, Color(0xFF9B6BE8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)
                  : hasActivity
                      ? const LinearGradient(
                          colors: [AmolColors.darkGreen, AmolColors.midGreen],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight)
                      : null,
              color: isExempt || hasActivity ? null : AmolColors.pageBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${entry.day}',
                  style: TextStyle(
                      color: isExempt || hasActivity
                          ? Colors.white
                          : AmolColors.textHint,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      height: 1)),
              Text(monthShort(entry.month - 1),
                  style: TextStyle(
                      color: isExempt || hasActivity
                          ? Colors.white.withOpacity(0.6)
                          : AmolColors.textHint,
                      fontSize: 8.5)),
            ]),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(children: [
                  Flexible(
                      child: Text(
                          isExempt
                              ? 'মাহলির দিন'
                              : hasActivity
                                  ? '$totalCompleted টি আমল সম্পন্ন'
                                  : 'কোনো আমল নেই',
                          style: TextStyle(
                              color: isExempt
                                  ? AmolColors.purple
                                  : hasActivity
                                      ? AmolColors.textPrimary
                                      : AmolColors.textSecondary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                          overflow: TextOverflow.ellipsis)),
                  if (congregation > 0) ...[
                    const SizedBox(width: 5),
                    _Pill(
                        text: '🕌 $congregation জামাত',
                        bg: AmolColors.purpleLight,
                        fg: AmolColors.purple),
                  ] else if (solo > 0) ...[
                    const SizedBox(width: 5),
                    _Pill(
                        text: '🤲 $solo একাকী',
                        bg: AmolColors.greenLight,
                        fg: AmolColors.green),
                  ],
                ]),
                if (missed > 0) ...[
                  const SizedBox(height: 3),
                  _Pill(
                      text: '⚠️ $missed মিস',
                      bg: AmolColors.redLight,
                      fg: AmolColors.red),
                ],
                const SizedBox(height: 5),
                ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                        value: progressVal.clamp(0.0, 1.0),
                        minHeight: 4,
                        backgroundColor: AmolColors.pageBg,
                        valueColor: AlwaysStoppedAnimation(barColor))),
              ])),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            if (isExempt)
              const Text('🌸', style: TextStyle(fontSize: 18))
            else if (congregation >= 4)
              const Icon(Icons.star_rounded, color: AmolColors.gold, size: 22)
            else if (congregation >= 1 || solo >= 1)
              const Icon(Icons.check_circle_rounded,
                  color: AmolColors.green, size: 22)
            else if (hasActivity)
              const Icon(Icons.circle_outlined,
                  color: AmolColors.amber, size: 22)
            else
              const Icon(Icons.remove_circle_outline_rounded,
                  color: AmolColors.border, size: 22),
            const SizedBox(height: 2),
            Text(
                isExempt
                    ? 'মাফ'
                    : congregation >= 4
                        ? 'পূর্ণ'
                        : congregation >= 1
                            ? 'আংশিক'
                            : hasActivity
                                ? 'কিছু'
                                : 'শূন্য',
                style: const TextStyle(
                    color: AmolColors.textHint,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            const Icon(Icons.chevron_right_rounded,
                color: AmolColors.textHint, size: 16),
          ]),
        ]),
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 240.ms)
        .slideX(begin: 0.04, curve: Curves.easeOut);
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color bg, fg;
  const _Pill({required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
      child: Text(text,
          style:
              TextStyle(color: fg, fontSize: 9, fontWeight: FontWeight.w700)),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DAY DETAIL SHEET — শুধু "যা করেছেন" দেখায় (positive accomplishments)।
// মিস করা ফরজ বা না-করা আমল এখানে দেখানো হয় না — এই কুইক-পিক শিটের উদ্দেশ্য
// অর্জন দেখানো, ঘাটতি নয় (মাসিক Fard section এ এমনিতেই মিস কাউন্ট আছে)।
// ─────────────────────────────────────────────────────────────────────────────

class _DayDetailSheet extends StatelessWidget {
  final DailyEntry entry;
  final Map<String, AmalCategory> catMap;
  final String userGender;
  const _DayDetailSheet(
      {required this.entry, required this.catMap, required this.userGender});

  bool _isAccomplished(DailyEntryItem item) {
    if (item.prayerMode != null) {
      return item.prayerMode == PrayerMode.congregation ||
          item.prayerMode == PrayerMode.solo;
    }
    return item.completed || item.count > 0;
  }

  @override
  Widget build(BuildContext context) {
    final isFemale = userGender == 'female';
    final isExempt = entry.isExemptDay && isFemale;
    final items = entry.entries
        .where((e) => catMap.containsKey(e.categoryId) && _isAccomplished(e))
        .map((e) => MapEntry(catMap[e.categoryId]!, e))
        .toList()
      ..sort((a, b) => a.key.order.compareTo(b.key.order));

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AmolColors.cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(children: [
          const SizedBox(height: 12),
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: AmolColors.border,
                  borderRadius: BorderRadius.circular(99))),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${entry.day} তারিখে যা করেছেন',
                        style: const TextStyle(
                            color: AmolColors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 15)),
                    if (items.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text('${items.length} টি আমল সম্পন্ন',
                          style: const TextStyle(
                              color: AmolColors.textHint,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500)),
                    ],
                  ],
                ),
              ),
              if (isExempt)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: AmolColors.purplePale,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text('🌸 মাহলি',
                      style: TextStyle(
                          color: AmolColors.purple,
                          fontSize: 10,
                          fontWeight: FontWeight.w700)),
                ),
            ]),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(isExempt ? '🌸' : '📭',
                            style: const TextStyle(fontSize: 26)),
                        const SizedBox(height: 8),
                        Text(
                            isExempt
                                ? 'মাহলির দিন — নামাজ ও রোজা মাফ'
                                : 'এই দিনে কোনো আমল সম্পন্ন হয়নি',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: AmolColors.textHint, fontSize: 12.5)),
                      ]),
                    ),
                  )
                : ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(
                        height: 18, color: AmolColors.border, thickness: 0.5),
                    itemBuilder: (ctx, i) => _DayDetailRow(
                        category: items[i].key, item: items[i].value),
                  ),
          ),
        ]),
      ),
    );
  }
}

class _DayDetailRow extends StatelessWidget {
  final AmalCategory category;
  final DailyEntryItem item;
  const _DayDetailRow({required this.category, required this.item});

  @override
  Widget build(BuildContext context) {
    final isFardPrayer = category.isFard && category.isPrayer;
    String statusText;
    Color statusColor;
    IconData statusIcon;

    if (isFardPrayer) {
      final isCongregation = item.prayerMode == PrayerMode.congregation;
      statusText = isCongregation ? 'জামাতে আদায়' : 'একাকী আদায়';
      statusColor = isCongregation ? AmolColors.purple : AmolColors.amber;
      statusIcon = isCongregation ? Icons.people_rounded : Icons.person_rounded;
    } else if (category.inputType == AmalInputType.counter ||
        category.inputType == AmalInputType.duration) {
      final unitBn = AmolUnit.bn(category.unit);
      statusText = '${item.count}${unitBn.isNotEmpty ? " $unitBn" : ""}';
      statusColor = AmolColors.green;
      statusIcon = Icons.check_circle_rounded;
    } else {
      statusText = 'সম্পন্ন';
      statusColor = AmolColors.green;
      statusIcon = Icons.check_circle_rounded;
    }

    return Row(children: [
      AmolIcon(category: category, size: 36),
      const SizedBox(width: 12),
      Expanded(
        child: Text(category.nameBn,
            style: const TextStyle(
                color: AmolColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 13)),
      ),
      Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(statusIcon, size: 15, color: statusColor),
        const SizedBox(width: 5),
        Text(statusText,
            style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w700,
                fontSize: 11.5)),
      ]),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PERIOD PICKER SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _PeriodPickerSheet extends StatefulWidget {
  final int year, month;
  final void Function(int, int) onPicked;
  const _PeriodPickerSheet(
      {required this.year, required this.month, required this.onPicked});

  @override
  State<_PeriodPickerSheet> createState() => _PeriodPickerSheetState();
}

class _PeriodPickerSheetState extends State<_PeriodPickerSheet> {
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
      decoration: const BoxDecoration(
          color: AmolColors.cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: AmolColors.border,
                borderRadius: BorderRadius.circular(99))),
        const SizedBox(height: 22),
        const Text('মাস বেছে নিন',
            style: TextStyle(
                color: AmolColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 18),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _YearArrow(
              icon: Icons.chevron_left_rounded,
              onTap: () => setState(() => _y--),
              enabled: true),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                  color: AmolColors.greenLight,
                  borderRadius: BorderRadius.circular(12)),
              child: Text('$_y',
                  style: const TextStyle(
                      color: AmolColors.darkGreen,
                      fontWeight: FontWeight.w800,
                      fontSize: 18))),
          _YearArrow(
              icon: Icons.chevron_right_rounded,
              onTap: _y < now.year ? () => setState(() => _y++) : null,
              enabled: _y < now.year),
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
                  color: isSelected ? AmolColors.darkGreen : AmolColors.pageBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: isSelected
                          ? AmolColors.darkGreen
                          : isFuture
                              ? AmolColors.border.withOpacity(0.4)
                              : AmolColors.border,
                      width: 0.5),
                ),
                child: Center(
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(AppConstants.bengaliMonths[i],
                                style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : isFuture
                                            ? AmolColors.textHint
                                            : AmolColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500))))),
              ),
            );
          },
        ),
        const SizedBox(height: 4),
      ]),
    );
  }
}

class _YearArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;
  const _YearArrow(
      {required this.icon, required this.onTap, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: enabled ? AmolColors.greenLight : AmolColors.pageBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: enabled ? AmolColors.borderMid : AmolColors.border,
              width: 0.5),
        ),
        child: Icon(icon,
            color: enabled ? AmolColors.darkGreen : AmolColors.textHint,
            size: 20),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SKELETONS
// ─────────────────────────────────────────────────────────────────────────────

class _HeroBandSkeleton extends StatelessWidget {
  const _HeroBandSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AmolColors.darkGreen,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              width: 130,
              height: 11,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 12),
          Container(
            height: 92,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14)),
          )
              .animate(onPlay: (c) => c.repeat())
              .shimmer(duration: 1200.ms, colors: [
            Colors.white.withOpacity(0.02),
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.02)
          ]),
        ]),
      ),
    );
  }
}

class _StatStripSkeleton extends StatelessWidget {
  const _StatStripSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(children: [_row(top: 12), _row(top: 8)]);
  }

  static Widget _row({required double top}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, top, 16, 0),
      child: Row(
          children: List.generate(
              3,
              (i) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
                      child: const AmolShimmerBox(height: 86, radius: 13),
                    ),
                  ))),
    );
  }
}

class _SectionSkeleton extends StatelessWidget {
  final double height;
  const _SectionSkeleton({required this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: AmolShimmerBox(height: height, radius: 16),
    );
  }
}

class _EntriesSkeleton extends StatelessWidget {
  const _EntriesSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 22),
      const AmolShimmerBox(width: 130, height: 14, radius: 8),
      const SizedBox(height: 12),
      const AmolShimmerBox(height: 240, radius: 16),
      const SizedBox(height: 22),
      const AmolShimmerBox(width: 150, height: 14, radius: 8),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(
            color: AmolColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AmolColors.border, width: 0.5)),
        child: Column(
            children: List.generate(
                5,
                (i) => Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                      child: const AmolShimmerBox(height: 64, radius: 10),
                    ))),
      ),
    ]);
  }
}
