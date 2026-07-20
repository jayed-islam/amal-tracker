// // public_profile_sheet.dart

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/leaderboard_provider.dart';
// import '../../tracker/models/tracker_model.dart';
// import '../../../core/constants/app_constants.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // DESIGN TOKENS
// // ─────────────────────────────────────────────────────────────────────────────

// class _C {
//   static const bg = Color(0xFFF4F6F1);
//   static const card = Color(0xFFFFFFFF);
//   static const darkGreen = Color(0xFF0E3D22);
//   static const midGreen = Color(0xFF1B7045);
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const gold = Color(0xFFD4A843);
//   static const goldLight = Color(0xFFFFF8E7);
//   static const amber = Color(0xFFF59E0B);
//   static const amberLight = Color(0xFFFFF3E0);
//   static const red = Color(0xFFDC2626);
//   static const redLight = Color(0xFFFEF2F2);
//   static const pink = Color(0xFFEC4899);
//   static const pinkLight = Color(0xFFFCE7F3);
//   static const blue = Color(0xFF0891B2);
//   static const blueLight = Color(0xFFE0F2FE);
//   static const border = Color(0xFFE4EAE4);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
//   static const rankGold = Color(0xFFD4A843);
//   static const rankSilver = Color(0xFF94A3B8);
//   static const rankBronze = Color(0xFFCD7F32);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // ENTRY POINT — call this from _RankTile
// // ─────────────────────────────────────────────────────────────────────────────

// void showPublicProfileSheet(
//   BuildContext context, {
//   required LeaderboardEntry entry,
//   required int year,
//   required int month,
// }) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     useSafeArea: false,
//     builder: (_) => PublicProfileSheet(
//       entry: entry,
//       year: year,
//       month: month,
//     ),
//   );
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PUBLIC PROFILE SHEET
// // ─────────────────────────────────────────────────────────────────────────────

// class PublicProfileSheet extends ConsumerWidget {
//   final LeaderboardEntry entry;
//   final int year, month;

//   const PublicProfileSheet({
//     super.key,
//     required this.entry,
//     required this.year,
//     required this.month,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final screenH = MediaQuery.of(context).size.height;
//     final topPad = MediaQuery.of(context).padding.top;

//     final detail = ref.watch(publicProfileProvider((
//       userId: entry.userId,
//       year: year,
//       month: month,
//     )));

//     return Container(
//       // Max height: 88% of screen — leaves a peek of page behind
//       constraints: BoxConstraints(maxHeight: screenH * 0.75),
//       decoration: const BoxDecoration(
//         color: _C.bg,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // ── Drag handle ─────────────────────────────────────────────
//           const _DragHandle(),

//           // ── Sticky header — always visible ──────────────────────────
//           _StickyHeader(entry: entry, year: year, month: month),

//           // ── Scrollable body ─────────────────────────────────────────
//           Flexible(
//             child: detail.when(
//               loading: () => const _SheetSkeleton(),
//               error: (e, _) => _SheetError(
//                 onRetry: () => ref.invalidate(publicProfileProvider((
//                   userId: entry.userId,
//                   year: year,
//                   month: month,
//                 ))),
//               ),
//               data: (d) => _SheetBody(
//                 detail: d,
//                 entry: entry,
//                 year: year,
//                 month: month,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DRAG HANDLE
// // ─────────────────────────────────────────────────────────────────────────────

// class _DragHandle extends StatelessWidget {
//   const _DragHandle();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 12, bottom: 4),
//       child: Center(
//         child: Container(
//           width: 40,
//           height: 4,
//           decoration: BoxDecoration(
//             color: _C.border,
//             borderRadius: BorderRadius.circular(99),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // STICKY HEADER — gradient hero, always visible while scrolling
// // ─────────────────────────────────────────────────────────────────────────────

// class _StickyHeader extends StatelessWidget {
//   final LeaderboardEntry entry;
//   final int year, month;

//   const _StickyHeader({
//     required this.entry,
//     required this.year,
//     required this.month,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final initial = entry.name.isNotEmpty ? entry.name[0].toUpperCase() : 'U';
//     final monthLabel = AppConstants.bengaliMonths[month - 1];
//     final rankColor = entry.rank == 1
//         ? _C.rankGold
//         : entry.rank == 2
//             ? _C.rankSilver
//             : entry.rank == 3
//                 ? _C.rankBronze
//                 : _C.gold;

//     return Container(
//       decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [_C.darkGreen, _C.midGreen],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.all(Radius.circular(28))
//           // borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//           ),
//       padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
//       margin: EdgeInsets.symmetric(horizontal: 15),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Avatar
//               Container(
//                 width: 56,
//                 height: 56,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(
//                     color: Colors.white.withOpacity(0.3),
//                     width: 1.5,
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     initial,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 14),

//               // Name + meta
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Name row
//                     Row(
//                       children: [
//                         Flexible(
//                           child: Text(
//                             entry.name,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w800,
//                               letterSpacing: -0.3,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         if (entry.gender?.toLowerCase() == 'female') ...[
//                           const SizedBox(width: 5),
//                           const Text('🌸', style: TextStyle(fontSize: 12)),
//                         ],
//                         if (entry.isWinner) ...[
//                           const SizedBox(width: 5),
//                           const Text('🏆', style: TextStyle(fontSize: 12)),
//                         ],
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     // ID + District chips
//                     Wrap(
//                       spacing: 5,
//                       runSpacing: 4,
//                       children: [
//                         _HeaderChip(icon: Icons.tag_rounded, label: entry.id),
//                         _HeaderChip(
//                           icon: Icons.location_on_rounded,
//                           label: entry.district,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 10),

//               // Rank pill
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
//                 decoration: BoxDecoration(
//                   color: rankColor,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: rankColor.withOpacity(0.3),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       '#${entry.rank}',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w900,
//                         fontSize: 15,
//                         height: 1,
//                       ),
//                     ),
//                     Text(
//                       'র‍্যাংক',
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.75),
//                         fontSize: 8,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 14),

//           // Month + points row
//           Row(
//             children: [
//               // Month label
//               Expanded(
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.white.withOpacity(0.15)),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.calendar_month_rounded,
//                           size: 12, color: Colors.white.withOpacity(0.6)),
//                       const SizedBox(width: 6),
//                       Text(
//                         '$monthLabel $year',
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.85),
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               // Points
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
//                 decoration: BoxDecoration(
//                   color: _C.gold,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Row(
//                   children: [
//                     const Text('⭐', style: TextStyle(fontSize: 12)),
//                     const SizedBox(width: 5),
//                     Text(
//                       '${entry.totalPoints} pts',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w800,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 8),
//               // Completion
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.12),
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.white.withOpacity(0.2)),
//                 ),
//                 child: Text(
//                   '${entry.completionPercentage.toInt()}% ফরজ',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _HeaderChip extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   const _HeaderChip({required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.12),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.18), width: 0.5),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 9, color: Colors.white.withOpacity(0.6)),
//           const SizedBox(width: 3),
//           Text(
//             label,
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.85),
//               fontSize: 10,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SHEET BODY — full scrollable content
// // ─────────────────────────────────────────────────────────────────────────────

// class _SheetBody extends StatelessWidget {
//   final PublicMonthlyDetail detail;
//   final LeaderboardEntry entry;
//   final int year, month;

//   const _SheetBody({
//     required this.detail,
//     required this.entry,
//     required this.year,
//     required this.month,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final tracker = detail.tracker;
//     final isFemale = detail.gender?.toLowerCase() == 'female';
//     final bottomPad = MediaQuery.of(context).padding.bottom;

//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPad + 24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Stats row ──────────────────────────────────────────────
//           if (tracker != null) ...[
//             _StatsRow(tracker: tracker, isFemale: isFemale)
//                 .animate()
//                 .fadeIn(delay: 60.ms)
//                 .slideY(begin: 0.04),
//             const SizedBox(height: 16),
//           ],

//           // ── Daily breakdown calendar ───────────────────────────────
//           _SectionLabel(label: 'দৈনিক আমল — $month/${year}'),
//           const SizedBox(height: 8),
//           _DailyCalendar(
//             entries: detail.entries,
//             year: year,
//             month: month,
//             isFemale: isFemale,
//           ).animate().fadeIn(delay: 80.ms).slideY(begin: 0.04),

//           const SizedBox(height: 16),

//           // ── Day-by-day list ────────────────────────────────────────
//           if (detail.entries.isNotEmpty) ...[
//             _SectionLabel(label: 'প্রতিদিনের বিবরণ'),
//             const SizedBox(height: 8),
//             _DayList(entries: detail.entries, isFemale: isFemale)
//                 .animate()
//                 .fadeIn(delay: 100.ms),
//             const SizedBox(height: 16),
//           ],

//           // ── Inspiration ────────────────────────────────────────────
//           _InspirationCard(name: detail.name).animate().fadeIn(delay: 120.ms),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // STATS ROW — 4 key metrics
// // ─────────────────────────────────────────────────────────────────────────────

// class _StatsRow extends StatelessWidget {
//   final MonthlyTracker tracker;
//   final bool isFemale;

//   const _StatsRow({required this.tracker, required this.isFemale});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Row 1
//         Row(
//           children: [
//             Expanded(
//               child: _StatCard(
//                 emoji: '✅',
//                 value: '${tracker.completionPercentage.toInt()}%',
//                 label: 'ফরজ আদায়',
//                 color: _C.darkGreen,
//                 bgColor: _C.greenLight,
//               ),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: _StatCard(
//                 emoji: '⭐',
//                 value: '${tracker.totalPoints}',
//                 label: 'মোট পয়েন্ট',
//                 color: const Color(0xFF92400E),
//                 bgColor: _C.goldLight,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         // Row 2
//         Row(
//           children: [
//             Expanded(
//               child: _StatCard(
//                 emoji: '🔥',
//                 value: '${tracker.streakDays} দিন',
//                 label: 'ধারাবাহিক',
//                 color: const Color(0xFFB45309),
//                 bgColor: _C.amberLight,
//               ),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: _StatCard(
//                 emoji: '📅',
//                 value: '${tracker.daysCompleted}',
//                 label: 'সম্পন্ন দিন',
//                 color: _C.blue,
//                 bgColor: _C.blueLight,
//               ),
//             ),
//           ],
//         ),
//         // // Female exempt days
//         // if (isFemale && tracker.exemptDays > 0) ...[
//         //   const SizedBox(height: 8),
//         //   _StatCard(
//         //     emoji: '🌸',
//         //     value: '${tracker.exemptDays} দিন',
//         //     label: 'মাফ দিন (হায়েজ)',
//         //     color: _C.pink,
//         //     bgColor: _C.pinkLight,
//         //     fullWidth: true,
//         //   ),
//         // ],
//       ],
//     );
//   }
// }

// class _StatCard extends StatelessWidget {
//   final String emoji, value, label;
//   final Color color, bgColor;
//   final bool fullWidth;

//   const _StatCard({
//     required this.emoji,
//     required this.value,
//     required this.label,
//     required this.color,
//     required this.bgColor,
//     this.fullWidth = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: fullWidth ? double.infinity : null,
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: color.withOpacity(0.15)),
//       ),
//       child: Row(
//         children: [
//           Text(emoji, style: const TextStyle(fontSize: 20)),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 value,
//                 style: TextStyle(
//                   color: color,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w800,
//                   height: 1,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 label,
//                 style: const TextStyle(
//                   color: _C.textSecondary,
//                   fontSize: 10.5,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DAILY CALENDAR — month grid with color coding
// // ─────────────────────────────────────────────────────────────────────────────

// class _DailyCalendar extends StatelessWidget {
//   final List<DailyEntry> entries;
//   final int year, month;
//   final bool isFemale;

//   const _DailyCalendar({
//     required this.entries,
//     required this.year,
//     required this.month,
//     required this.isFemale,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final daysInMonth = DateTime(year, month + 1, 0).day;
//     final entryMap = <int, DailyEntry>{};
//     for (final e in entries) {
//       entryMap[e.day] = e;
//     }

//     return Container(
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       padding: const EdgeInsets.all(14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Legend
//           Row(
//             children: [
//               _LegendItem(color: _C.darkGreen, label: 'আমল হয়েছে'),
//               const SizedBox(width: 10),
//               if (isFemale) ...[
//                 _LegendItem(color: _C.pink, label: 'মাফ দিন'),
//                 const SizedBox(width: 10),
//               ],
//               _LegendItem(
//                   color: const Color(0xFFF4F6F1), label: 'নেই', bordered: true),
//             ],
//           ),
//           const SizedBox(height: 12),

//           // Day name headers
//           Row(
//             children: ['রবি', 'সোম', 'মঙ্গ', 'বুধ', 'বৃহ', 'শুক্র', 'শনি']
//                 .map(
//                   (d) => Expanded(
//                     child: Center(
//                       child: Text(
//                         d,
//                         style: const TextStyle(
//                           color: _C.textHint,
//                           fontSize: 9,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//                 .toList(),
//           ),
//           const SizedBox(height: 6),

//           // Grid
//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 7,
//               crossAxisSpacing: 4,
//               mainAxisSpacing: 4,
//               childAspectRatio: 1,
//             ),
//             itemCount: daysInMonth,
//             itemBuilder: (_, i) {
//               final day = i + 1;
//               final e = entryMap[day];
//               final hasPoints = e != null && e.totalPoints > 0;
//               final isExempt = e != null && e.isExemptDay;

//               Color bg;
//               Color fg;

//               if (isExempt) {
//                 bg = _C.pinkLight;
//                 fg = _C.pink;
//               } else if (hasPoints) {
//                 // Intensity based on points
//                 final maxPts = entries
//                     .map((x) => x.totalPoints)
//                     .fold(1, (a, b) => a > b ? a : b);
//                 final ratio = e.totalPoints / maxPts;
//                 bg = Color.lerp(const Color(0xFFBBF7D0), _C.darkGreen, ratio)!;
//                 fg = ratio > 0.5 ? Colors.white : _C.darkGreen;
//               } else {
//                 bg = const Color(0xFFF4F6F1);
//                 fg = _C.textHint;
//               }

//               return Container(
//                 decoration: BoxDecoration(
//                   color: bg,
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Center(
//                   child: Text(
//                     '$day',
//                     style: TextStyle(
//                       color: fg,
//                       fontSize: 10.5,
//                       fontWeight: hasPoints || isExempt
//                           ? FontWeight.w700
//                           : FontWeight.w400,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _LegendItem extends StatelessWidget {
//   final Color color;
//   final String label;
//   final bool bordered;

//   const _LegendItem({
//     required this.color,
//     required this.label,
//     this.bordered = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 10,
//           height: 10,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(3),
//             border: bordered ? Border.all(color: _C.border) : null,
//           ),
//         ),
//         const SizedBox(width: 4),
//         Text(
//           label,
//           style: const TextStyle(
//             color: _C.textSecondary,
//             fontSize: 10,
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DAY LIST — প্রতিটা দিনের বিবরণ
// // ─────────────────────────────────────────────────────────────────────────────

// class _DayList extends StatelessWidget {
//   final List<DailyEntry> entries;
//   final bool isFemale;

//   const _DayList({required this.entries, required this.isFemale});

//   @override
//   Widget build(BuildContext context) {
//     // Sort by day
//     final sorted = [...entries]..sort((a, b) => a.day.compareTo(b.day));

//     return Container(
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       child: Column(
//         children: List.generate(sorted.length, (i) {
//           final e = sorted[i];
//           final isLast = i == sorted.length - 1;
//           return _DayTile(
//             entry: e,
//             isLast: isLast,
//             isFemale: isFemale,
//             delay: 100 + i * 30,
//           );
//         }),
//       ),
//     );
//   }
// }

// class _DayTile extends StatelessWidget {
//   final DailyEntry entry;
//   final bool isLast, isFemale;
//   final int delay;

//   const _DayTile({
//     required this.entry,
//     required this.isLast,
//     required this.isFemale,
//     required this.delay,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isExempt = entry.isExemptDay;
//     final completedCount = entry.entries.where((e) => e.completed).length;
//     final totalCount = entry.entries.length;

//     // Progress ratio
//     final ratio = totalCount > 0 ? completedCount / totalCount : 0.0;

//     Color dotColor;
//     String dayStatus;

//     if (isExempt) {
//       dotColor = _C.pink;
//       dayStatus = 'মাফ দিন 🌸';
//     } else if (entry.totalPoints == 0) {
//       dotColor = _C.border;
//       dayStatus = 'আমল নেই';
//     } else if (ratio >= 1.0) {
//       dotColor = _C.green;
//       dayStatus = 'সম্পূর্ণ ✅';
//     } else if (ratio >= 0.5) {
//       dotColor = _C.amber;
//       dayStatus = 'আংশিক';
//     } else {
//       dotColor = const Color(0xFFEF4444);
//       dayStatus = 'কম আমল';
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
//       decoration: BoxDecoration(
//         border: isLast
//             ? null
//             : const Border(
//                 bottom: BorderSide(color: _C.border, width: 0.5),
//               ),
//       ),
//       child: Row(
//         children: [
//           // Day number
//           Container(
//             width: 38,
//             height: 38,
//             decoration: BoxDecoration(
//               color: isExempt
//                   ? _C.pinkLight
//                   : entry.totalPoints > 0
//                       ? _C.greenLight
//                       : const Color(0xFFF4F6F1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Center(
//               child: Text(
//                 '${entry.day}',
//                 style: TextStyle(
//                   color: isExempt
//                       ? _C.pink
//                       : entry.totalPoints > 0
//                           ? _C.darkGreen
//                           : _C.textHint,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),

//           // Status + progress
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       width: 6,
//                       height: 6,
//                       decoration: BoxDecoration(
//                         color: dotColor,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       dayStatus,
//                       style: TextStyle(
//                         color: isExempt ? _C.pink : _C.textPrimary,
//                         fontSize: 12.5,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     if (!isExempt && totalCount > 0) ...[
//                       const Spacer(),
//                       Text(
//                         '$completedCount/$totalCount আমল',
//                         style: const TextStyle(
//                           color: _C.textSecondary,
//                           fontSize: 10.5,
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),

//                 // Progress bar
//                 if (!isExempt && totalCount > 0) ...[
//                   const SizedBox(height: 6),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(99),
//                     child: LinearProgressIndicator(
//                       value: ratio,
//                       minHeight: 4,
//                       backgroundColor: _C.border,
//                       valueColor: AlwaysStoppedAnimation(
//                         ratio >= 1.0
//                             ? _C.green
//                             : ratio >= 0.5
//                                 ? _C.amber
//                                 : const Color(0xFFEF4444),
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),

//           const SizedBox(width: 10),

//           // Points
//           if (!isExempt && entry.totalPoints > 0)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   '${entry.totalPoints}',
//                   style: const TextStyle(
//                     color: _C.darkGreen,
//                     fontWeight: FontWeight.w900,
//                     fontSize: 15,
//                     height: 1,
//                   ),
//                 ),
//                 const Text(
//                   'pts',
//                   style: TextStyle(
//                     color: _C.textHint,
//                     fontSize: 9,
//                   ),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     )
//         .animate(delay: Duration(milliseconds: delay))
//         .fadeIn(duration: 220.ms)
//         .slideX(begin: 0.03, curve: Curves.easeOut);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // INSPIRATION CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _InspirationCard extends StatelessWidget {
//   final String name;
//   const _InspirationCard({required this.name});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _C.goldLight,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: _C.gold.withOpacity(0.25), width: 0.5),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('💡', style: TextStyle(fontSize: 16)),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               '${name.split(' ').first} তাঁর আমলের তথ্য শেয়ার করেছেন যাতে অন্যরা অনুপ্রাণিত হতে পারেন। আল্লাহ তাঁর আমল কবুল করুন। আমিন।',
//               style: const TextStyle(
//                 color: Color(0xFF92400E),
//                 fontSize: 12,
//                 height: 1.6,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION LABEL
// // ─────────────────────────────────────────────────────────────────────────────

// class _SectionLabel extends StatelessWidget {
//   final String label;
//   const _SectionLabel({required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       label.toUpperCase(),
//       style: const TextStyle(
//         color: _C.textHint,
//         fontSize: 10,
//         fontWeight: FontWeight.w700,
//         letterSpacing: 0.8,
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SKELETON
// // ─────────────────────────────────────────────────────────────────────────────

// class _SheetSkeleton extends StatelessWidget {
//   const _SheetSkeleton();

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
//       child: Column(
//         children: [
//           _shimmer(height: 96),
//           const SizedBox(height: 16),
//           _shimmer(height: 200),
//           const SizedBox(height: 16),
//           _shimmer(height: 300),
//         ],
//       ),
//     );
//   }

//   Widget _shimmer({required double height}) {
//     return Container(
//       width: double.infinity,
//       height: height,
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//     ).animate(onPlay: (c) => c.repeat()).shimmer(
//       duration: 1200.ms,
//       colors: const [_C.card, Color(0xFFE8ECE8), _C.card],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // ERROR
// // ─────────────────────────────────────────────────────────────────────────────

// class _SheetError extends StatelessWidget {
//   final VoidCallback onRetry;
//   const _SheetError({required this.onRetry});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 64,
//               height: 64,
//               decoration: BoxDecoration(
//                 color: _C.redLight,
//                 borderRadius: BorderRadius.circular(18),
//               ),
//               child: const Icon(Icons.lock_outline_rounded,
//                   color: _C.red, size: 28),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'প্রোফাইল দেখা যাচ্ছে না',
//               style: TextStyle(
//                 color: _C.textPrimary,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'এই ব্যবহারকারী তাঁর প্রোফাইল বন্ধ করে দিয়েছেন',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: _C.textSecondary, fontSize: 13),
//             ),
//             const SizedBox(height: 20),
//             GestureDetector(
//               onTap: onRetry,
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: _C.greenLight,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Text(
//                   'আবার চেষ্টা করুন',
//                   style: TextStyle(
//                     color: _C.darkGreen,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 13,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// public_profile_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/leaderboard_provider.dart';
import '../../tracker/models/tracker_model.dart';
import '../../../core/constants/app_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────

class _C {
  static const bg = Color(0xFFF4F6F1);
  static const card = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const midGreen = Color(0xFF1B7045);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFFFF8E7);
  static const amber = Color(0xFFF59E0B);
  static const amberLight = Color(0xFFFFF3E0);
  static const purple = Color(0xFF7C3AED);
  static const purpleLight = Color(0xFFEDE9FE);
  static const red = Color(0xFFDC2626);
  static const redLight = Color(0xFFFEF2F2);
  static const pink = Color(0xFFEC4899);
  static const pinkLight = Color(0xFFFCE7F3);
  static const blue = Color(0xFF0891B2);
  static const blueLight = Color(0xFFE0F2FE);
  static const border = Color(0xFFE4EAE4);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
  static const rankGold = Color(0xFFD4A843);
  static const rankSilver = Color(0xFF94A3B8);
  static const rankBronze = Color(0xFFCD7F32);
}

// ─────────────────────────────────────────────────────────────────────────────
// ENTRY POINT
// isMaleUser: male user female profile দেখতে পাবে না — caller এ check হয়
// তবুও double-check করা হচ্ছে এখানেও
// ─────────────────────────────────────────────────────────────────────────────

void showPublicProfileSheet(
  BuildContext context, {
  required LeaderboardEntry entry,
  required int year,
  required int month,
  required bool isMaleUser,
}) {
  // Male user → female profile দেখানো যাবে না
  if (isMaleUser && entry.gender?.toLowerCase() == 'female') {
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(children: [
          Icon(Icons.lock_rounded, color: Colors.white, size: 16),
          SizedBox(width: 8),
          Text('এই প্রোফাইল দেখার অনুমতি নেই',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ]),
        backgroundColor: const Color(0xFF0E3D22),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 2),
      ),
    );
    return;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: false,
    builder: (_) => PublicProfileSheet(
      entry: entry,
      year: year,
      month: month,
      isMaleUser: isMaleUser,
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// PUBLIC PROFILE SHEET
// ─────────────────────────────────────────────────────────────────────────────

class PublicProfileSheet extends ConsumerWidget {
  final LeaderboardEntry entry;
  final int year, month;
  final bool isMaleUser;

  const PublicProfileSheet({
    super.key,
    required this.entry,
    required this.year,
    required this.month,
    required this.isMaleUser,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenH = MediaQuery.of(context).size.height;

    final detail = ref.watch(publicProfileProvider((
      userId: entry.userId,
      year: year,
      month: month,
    )));

    return Container(
      constraints: BoxConstraints(maxHeight: screenH * 0.82),
      decoration: const BoxDecoration(
        color: _C.bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const _DragHandle(),
        _StickyHeader(entry: entry, year: year, month: month),
        Flexible(
          child: detail.when(
            loading: () => const _SheetSkeleton(),
            error: (e, _) => _SheetError(
              onRetry: () => ref.invalidate(publicProfileProvider((
                userId: entry.userId,
                year: year,
                month: month,
              ))),
            ),
            data: (d) => _SheetBody(
              detail: d,
              entry: entry,
              year: year,
              month: month,
            ),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DRAG HANDLE
// ─────────────────────────────────────────────────────────────────────────────

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
              color: _C.border, borderRadius: BorderRadius.circular(99)),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STICKY HEADER — points বাদ, completion % + farz + jamaat + streak
// ─────────────────────────────────────────────────────────────────────────────

class _StickyHeader extends StatelessWidget {
  final LeaderboardEntry entry;
  final int year, month;

  const _StickyHeader(
      {required this.entry, required this.year, required this.month});

  @override
  Widget build(BuildContext context) {
    final initial = entry.name.isNotEmpty ? entry.name[0].toUpperCase() : 'U';
    final monthLabel = AppConstants.bengaliMonths[month - 1];
    final rankColor = entry.rank == 1
        ? _C.rankGold
        : entry.rank == 2
            ? _C.rankSilver
            : entry.rank == 3
                ? _C.rankBronze
                : _C.gold;

    final pct = entry.completionPercentage.toInt();
    final farz = entry.farzCompletedDays;
    final jamaat = entry.congregationDaysTotal;
    final streak = entry.streakDays;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [_C.darkGreen, _C.midGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.all(Radius.circular(24))),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: Colors.white.withOpacity(0.3), width: 1.5)),
            child: Center(
                child: Text(initial,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900))),
          ),
          const SizedBox(width: 14),

          // Name + chips
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(children: [
                  Flexible(
                      child: Text(entry.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3),
                          overflow: TextOverflow.ellipsis)),
                  if (entry.gender?.toLowerCase() == 'female') ...[
                    const SizedBox(width: 5),
                    const Text('🌸', style: TextStyle(fontSize: 12)),
                  ],
                  if (entry.isWinner) ...[
                    const SizedBox(width: 5),
                    const Text('🏆', style: TextStyle(fontSize: 12)),
                  ],
                ]),
                const SizedBox(height: 6),
                Wrap(spacing: 5, runSpacing: 4, children: [
                  _HeaderChip(icon: Icons.tag_rounded, label: entry.id),
                  _HeaderChip(
                      icon: Icons.location_on_rounded, label: entry.district),
                ]),
              ])),

          const SizedBox(width: 10),

          // Rank pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
                color: rankColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: rankColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ]),
            child: Column(children: [
              Text('#${entry.rank}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      height: 1)),
              Text('র‍্যাংক',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 8,
                      fontWeight: FontWeight.w600)),
            ]),
          ),
        ]),

        const SizedBox(height: 14),

        // Metrics row — points বাদ
        Row(children: [
          // Month
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.15))),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.calendar_month_rounded,
                  size: 12, color: Colors.white.withOpacity(0.6)),
              const SizedBox(width: 5),
              Text('$monthLabel $year',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ]),
          )),
          const SizedBox(width: 6),
          // Completion %
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
                color: rankColor, borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              const Icon(Icons.check_circle_rounded,
                  size: 12, color: Colors.white),
              const SizedBox(width: 5),
              Text('$pct% ফরজ',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 12)),
            ]),
          ),
          const SizedBox(width: 6),
          // Farz days
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.2))),
            child: Text('$farz দিন',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11)),
          ),
        ]),

        const SizedBox(height: 8),

        // Jamaat + streak row
        Row(children: [
          _MetricChip(
              icon: Icons.people_rounded,
              label: '$jamaat জামাত',
              color: Colors.white),
          const SizedBox(width: 6),
          if (streak > 0)
            _MetricChip(
                icon: Icons.local_fire_department_rounded,
                label: '$streak দিন ধারা',
                color: Colors.white),
        ]),
      ]),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HeaderChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: Colors.white.withOpacity(0.18), width: 0.5)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 9, color: Colors.white.withOpacity(0.6)),
        const SizedBox(width: 3),
        Text(label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 10,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MetricChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: Colors.white.withOpacity(0.18), width: 0.5)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: color.withOpacity(0.75)),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                color: color, fontSize: 10.5, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHEET BODY
// ─────────────────────────────────────────────────────────────────────────────

class _SheetBody extends StatelessWidget {
  final PublicMonthlyDetail detail;
  final LeaderboardEntry entry;
  final int year, month;

  const _SheetBody({
    required this.detail,
    required this.entry,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final tracker = detail.tracker;
    final isFemale = detail.gender?.toLowerCase() == 'female';
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPad + 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Stats ────────────────────────────────────────────────────
        if (tracker != null) ...[
          _StatsGrid(tracker: tracker, isFemale: isFemale)
              .animate()
              .fadeIn(delay: 60.ms)
              .slideY(begin: 0.04),
          const SizedBox(height: 16),
        ],

        // ── Fard performance bar ──────────────────────────────────────
        if (tracker != null) ...[
          _FardPerformanceCard(tracker: tracker).animate().fadeIn(delay: 80.ms),
          const SizedBox(height: 16),
        ],

        // ── Daily calendar ────────────────────────────────────────────
        _SectionLabel(label: 'দৈনিক আমল — $month/$year'),
        const SizedBox(height: 8),
        _DailyCalendar(
          entries: detail.entries,
          year: year,
          month: month,
          isFemale: isFemale,
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.04),

        const SizedBox(height: 16),

        // ── Day list ──────────────────────────────────────────────────
        if (detail.entries.isNotEmpty) ...[
          _SectionLabel(label: 'প্রতিদিনের বিবরণ'),
          const SizedBox(height: 8),
          _DayList(entries: detail.entries, isFemale: isFemale)
              .animate()
              .fadeIn(delay: 120.ms),
          const SizedBox(height: 16),
        ],

        // ── Inspiration ───────────────────────────────────────────────
        _InspirationCard(name: detail.name).animate().fadeIn(delay: 140.ms),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATS GRID — points বাদ, completion + farz + jamaat + streak + daysActive
// ─────────────────────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  final MonthlyTracker tracker;
  final bool isFemale;

  const _StatsGrid({required this.tracker, required this.isFemale});

  @override
  Widget build(BuildContext context) {
    final pct = tracker.completionPercentage.toInt();
    final farz = tracker.farzCompletedDays;
    // final jamaat = tracker.congregationDaysTotal;
    final streak = tracker.streakDays;
    final active = tracker.daysActive;
    final exempt = tracker.exemptDays;

    return Column(children: [
      Row(children: [
        Expanded(
            child: _StatCard(
                emoji: '✅',
                value: '$pct%',
                label: 'ফরজ সম্পন্ন',
                color: _C.darkGreen,
                bgColor: _C.greenLight)),
        const SizedBox(width: 8),
        Expanded(
            child: _StatCard(
                emoji: '🕌',
                value: '$farz দিন',
                label: 'পূর্ণ ফরজ দিন',
                color: _C.green,
                bgColor: _C.greenLight)),
      ]),
      const SizedBox(height: 8),
      // Row(children: [
      //   Expanded(
      //       child: _StatCard(
      //           emoji: '🤝',
      //           value: '$jamaat',
      //           label: 'জামাত',
      //           color: _C.purple,
      //           bgColor: _C.purpleLight)),
      //   const SizedBox(width: 8),
      //   Expanded(
      //       child: _StatCard(
      //           emoji: '🔥',
      //           value: '$streak দিন',
      //           label: 'ধারাবাহিক',
      //           color: _C.amber,
      //           bgColor: _C.amberLight)),
      // ]),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(
            child: _StatCard(
                emoji: '📅',
                value: '$active দিন',
                label: 'আমল করা দিন',
                color: _C.blue,
                bgColor: _C.blueLight)),
        const SizedBox(width: 8),
        if (isFemale && exempt > 0)
          Expanded(
              child: _StatCard(
                  emoji: '🌸',
                  value: '$exempt দিন',
                  label: 'মাহলির দিন',
                  color: _C.pink,
                  bgColor: _C.pinkLight))
        else
          Expanded(
              child: _StatCard(
                  emoji: '⏳',
                  value: '${tracker.eligibleDays} দিন',
                  label: 'হিসাবের দিন',
                  color: _C.textSecondary,
                  bgColor: const Color(0xFFF4F6F1))),
      ]),
    ]);
  }
}

class _StatCard extends StatelessWidget {
  final String emoji, value, label;
  final Color color, bgColor;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.15))),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  height: 1)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(color: _C.textSecondary, fontSize: 10.5)),
        ]),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FARD PERFORMANCE CARD
// ─────────────────────────────────────────────────────────────────────────────

class _FardPerformanceCard extends StatelessWidget {
  final MonthlyTracker tracker;
  const _FardPerformanceCard({required this.tracker});

  @override
  Widget build(BuildContext context) {
    final pct = tracker.completionPercentage.clamp(0.0, 100.0);
    final farz = tracker.farzCompletedDays;
    final eligible = tracker.eligibleDays;
    // final jamaat = tracker.congregationDaysTotal;

    Color barColor() {
      if (pct >= 90) return _C.green;
      if (pct >= 70) return _C.amber;
      return _C.red;
    }

    String statusLabel() {
      if (pct >= 90) return 'চমৎকার';
      if (pct >= 70) return 'ভালো';
      if (pct >= 50) return 'মাঝামাঝি';
      return 'উন্নতি দরকার';
    }

    // jamaat fraction: out of eligible * 5 prayers
    final jamaatFrac =
        eligible > 0 ? (0 / (eligible * 5)).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.border, width: 0.5)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('🕌', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 7),
          const Text('ফরজ পারফরম্যান্স',
              style: TextStyle(
                  color: _C.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
                color: barColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(20)),
            child: Text(statusLabel(),
                style: TextStyle(
                    color: barColor(),
                    fontSize: 10,
                    fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 12),

        // Completion % bar
        Row(children: [
          Text('${pct.toInt()}% ফরজ পূর্ণ',
              style: const TextStyle(
                  color: _C.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const Spacer(),
          Text('$farz/$eligible দিন',
              style: const TextStyle(color: _C.textHint, fontSize: 11)),
        ]),
        const SizedBox(height: 6),
        ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
                value: pct / 100,
                minHeight: 8,
                backgroundColor: const Color(0xFFF4F6F1),
                valueColor: AlwaysStoppedAnimation(barColor()))),

        const SizedBox(height: 12),

        // Jamaat bar
        Row(children: [
          const Text('জামাতে নামাজ',
              style: TextStyle(
                  color: _C.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const Spacer(),
          // Text('$jamaat বার',
          //     style: const TextStyle(color: _C.textHint, fontSize: 11)),
        ]),
        const SizedBox(height: 6),
        ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
                value: jamaatFrac,
                minHeight: 8,
                backgroundColor: const Color(0xFFF4F6F1),
                valueColor: const AlwaysStoppedAnimation(_C.purple))),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DAILY CALENDAR — hasActivity intensity, no points
// ─────────────────────────────────────────────────────────────────────────────

class _DailyCalendar extends StatelessWidget {
  final List<DailyEntry> entries;
  final int year, month;
  final bool isFemale;

  const _DailyCalendar({
    required this.entries,
    required this.year,
    required this.month,
    required this.isFemale,
  });

  // Intensity score: congregation=2, solo=1, other=1
  int _score(DailyEntry e) {
    int s = 0;
    for (final item in e.entries) {
      if (item.prayerMode == PrayerMode.congregation)
        s += 2;
      else if (item.prayerMode == PrayerMode.solo)
        s += 1;
      else if (item.completed || item.count > 0) s += 1;
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final entryMap = <int, DailyEntry>{};
    for (final e in entries) entryMap[e.day] = e;

    final maxScore = entries.isEmpty
        ? 1
        : entries.map(_score).fold(1, (a, b) => a > b ? a : b).clamp(1, 999);

    return Container(
      decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.border, width: 0.5)),
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Legend
        Wrap(spacing: 10, runSpacing: 4, children: [
          _LegendItem(color: _C.darkGreen, label: 'বেশি আমল'),
          _LegendItem(color: const Color(0xFFBBF7D0), label: 'কম আমল'),
          if (isFemale)
            _LegendItem(color: _C.pinkLight, label: 'মাহলি', bordered: true),
          _LegendItem(
              color: const Color(0xFFF4F6F1), label: 'নেই', bordered: true),
        ]),
        const SizedBox(height: 12),

        // Day headers
        Row(
            children: ['রবি', 'সোম', 'মঙ্গ', 'বুধ', 'বৃহ', 'শুক্র', 'শনি']
                .map((d) => Expanded(
                    child: Center(
                        child: Text(d,
                            style: const TextStyle(
                                color: _C.textHint,
                                fontSize: 9,
                                fontWeight: FontWeight.w600)))))
                .toList()),
        const SizedBox(height: 6),

        // Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 1),
          itemCount: daysInMonth,
          itemBuilder: (_, i) {
            final day = i + 1;
            final e = entryMap[day];
            final isExempt = e != null && e.isExemptDay && isFemale;
            final hasAct = e?.hasActivity ?? false;
            final score = e != null ? _score(e) : 0;
            final ratio = score / maxScore;

            Color bg;
            Color fg;

            if (isExempt) {
              bg = _C.pinkLight;
              fg = _C.pink;
            } else if (!hasAct || score == 0) {
              bg = const Color(0xFFF4F6F1);
              fg = _C.textHint;
            } else if (ratio < 0.25) {
              bg = const Color(0xFFDCFCE7);
              fg = _C.green;
            } else if (ratio < 0.5) {
              bg = Color.lerp(const Color(0xFFDCFCE7), _C.green, 0.4)!;
              fg = _C.green;
            } else if (ratio < 0.75) {
              bg = Color.lerp(_C.green, _C.darkGreen, 0.3)!;
              fg = Colors.white;
            } else {
              bg = _C.darkGreen;
              fg = Colors.white;
            }

            return Container(
              decoration: BoxDecoration(
                  color: bg, borderRadius: BorderRadius.circular(6)),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text('$day',
                        style: TextStyle(
                            color: fg,
                            fontSize: 10.5,
                            fontWeight: hasAct || isExempt
                                ? FontWeight.w700
                                : FontWeight.w400)),
                    if (isExempt)
                      const Text('🌸',
                          style: TextStyle(fontSize: 6, height: 1)),
                  ])),
            );
          },
        ),
      ]),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool bordered;
  const _LegendItem(
      {required this.color, required this.label, this.bordered = false});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: bordered ? Border.all(color: _C.border) : null),
      ),
      const SizedBox(width: 4),
      Text(label,
          style: const TextStyle(color: _C.textSecondary, fontSize: 10)),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DAY LIST
// ─────────────────────────────────────────────────────────────────────────────

class _DayList extends StatelessWidget {
  final List<DailyEntry> entries;
  final bool isFemale;
  const _DayList({required this.entries, required this.isFemale});

  @override
  Widget build(BuildContext context) {
    final sorted = [...entries]..sort((a, b) => a.day.compareTo(b.day));
    return Container(
      decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.border, width: 0.5)),
      child: Column(
          children: List.generate(
              sorted.length,
              (i) => _DayTile(
                    entry: sorted[i],
                    isLast: i == sorted.length - 1,
                    isFemale: isFemale,
                    delay: 100 + i * 30,
                  ))),
    );
  }
}

class _DayTile extends StatelessWidget {
  final DailyEntry entry;
  final bool isLast, isFemale;
  final int delay;

  const _DayTile({
    required this.entry,
    required this.isLast,
    required this.isFemale,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final isExempt = entry.isExemptDay && isFemale;
    final entries = entry.entries;

    final congregation =
        entries.where((e) => e.prayerMode == PrayerMode.congregation).length;
    final solo = entries.where((e) => e.prayerMode == PrayerMode.solo).length;
    final missed =
        entries.where((e) => e.prayerMode == PrayerMode.missed).length;
    final other = entries
        .where((e) => e.prayerMode == null && (e.completed || e.count > 0))
        .length;
    final total = congregation + solo + other;
    final hasAct = entry.hasActivity;

    // Progress: congregation fraction of all prayers
    final prayerTotal = congregation + solo + missed;
    final progress = prayerTotal > 0
        ? congregation / prayerTotal
        : hasAct
            ? 0.5
            : 0.0;

    Color dayBg = isExempt
        ? _C.pinkLight
        : hasAct
            ? _C.greenLight
            : const Color(0xFFF4F6F1);
    Color dayFg = isExempt
        ? _C.pink
        : hasAct
            ? _C.darkGreen
            : _C.textHint;

    Color barColor = isExempt
        ? _C.pink
        : congregation >= 3
            ? _C.green
            : congregation >= 1
                ? _C.amber
                : _C.border;

    String statusText = isExempt
        ? 'মাহলির দিন'
        : !hasAct
            ? 'কোনো আমল নেই'
            : '$total টি আমল সম্পন্ন';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: _C.border, width: 0.5)),
      ),
      child: Row(children: [
        // Day box
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: dayBg, borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text('${entry.day}',
                  style: TextStyle(
                      color: dayFg,
                      fontWeight: FontWeight.w800,
                      fontSize: 14))),
        ),
        const SizedBox(width: 12),

        // Status
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Flexible(
                child: Text(statusText,
                    style: TextStyle(
                        color: isExempt ? _C.pink : _C.textPrimary,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis)),
            if (congregation > 0) ...[
              const SizedBox(width: 5),
              _Pill(
                  text: '🕌 $congregation জামাত',
                  bg: _C.purpleLight,
                  fg: _C.purple),
            ] else if (solo > 0) ...[
              const SizedBox(width: 5),
              _Pill(text: '🤲 $solo একাকী', bg: _C.greenLight, fg: _C.green),
            ],
          ]),
          if (missed > 0) ...[
            const SizedBox(height: 3),
            _Pill(text: '⚠️ $missed মিস', bg: _C.redLight, fg: _C.red),
          ],
          if (!isExempt) ...[
            const SizedBox(height: 5),
            ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 4,
                    backgroundColor: const Color(0xFFF4F6F1),
                    valueColor: AlwaysStoppedAnimation(barColor))),
          ],
        ])),

        const SizedBox(width: 10),

        // Status icon — points বাদ
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          if (isExempt)
            const Text('🌸', style: TextStyle(fontSize: 18))
          else if (congregation >= 4)
            const Icon(Icons.star_rounded, color: _C.gold, size: 22)
          else if (congregation >= 1 || solo >= 1)
            const Icon(Icons.check_circle_rounded, color: _C.green, size: 22)
          else if (hasAct)
            const Icon(Icons.circle_outlined, color: _C.amber, size: 22)
          else
            const Icon(Icons.remove_circle_outline_rounded,
                color: _C.border, size: 22),
          const SizedBox(height: 2),
          Text(
              isExempt
                  ? 'মাফ'
                  : congregation >= 4
                      ? 'পূর্ণ'
                      : congregation >= 1
                          ? 'আংশিক'
                          : hasAct
                              ? 'কিছু'
                              : 'শূন্য',
              style: const TextStyle(
                  color: _C.textHint,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w500)),
        ]),
      ]),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 220.ms)
        .slideX(begin: 0.03, curve: Curves.easeOut);
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
// INSPIRATION CARD
// ─────────────────────────────────────────────────────────────────────────────

class _InspirationCard extends StatelessWidget {
  final String name;
  const _InspirationCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: _C.goldLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _C.gold.withOpacity(0.25), width: 0.5)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('💡', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(
            child: Text(
                '${name.split(' ').first} তাঁর আমলের তথ্য শেয়ার করেছেন যাতে অন্যরা অনুপ্রাণিত হতে পারেন। আল্লাহ তাঁর আমল কবুল করুন। আমিন।',
                style: const TextStyle(
                    color: Color(0xFF92400E), fontSize: 12, height: 1.6))),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION LABEL
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label.toUpperCase(),
        style: const TextStyle(
            color: _C.textHint,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SKELETON
// ─────────────────────────────────────────────────────────────────────────────

class _SheetSkeleton extends StatelessWidget {
  const _SheetSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(children: [
        _shimmer(height: 120),
        const SizedBox(height: 16),
        _shimmer(height: 100),
        const SizedBox(height: 16),
        _shimmer(height: 220),
        const SizedBox(height: 16),
        _shimmer(height: 280),
      ]),
    );
  }

  Widget _shimmer({required double height}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.border, width: 0.5)),
    ).animate(onPlay: (c) => c.repeat()).shimmer(
        duration: 1200.ms, colors: const [_C.card, Color(0xFFE8ECE8), _C.card]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ERROR
// ─────────────────────────────────────────────────────────────────────────────

class _SheetError extends StatelessWidget {
  final VoidCallback onRetry;
  const _SheetError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
                color: _C.redLight, borderRadius: BorderRadius.circular(18)),
            child:
                const Icon(Icons.lock_outline_rounded, color: _C.red, size: 28),
          ),
          const SizedBox(height: 16),
          const Text('প্রোফাইল দেখা যাচ্ছে না',
              style: TextStyle(
                  color: _C.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text('এই ব্যবহারকারী তাঁর প্রোফাইল বন্ধ করে দিয়েছেন',
              textAlign: TextAlign.center,
              style: TextStyle(color: _C.textSecondary, fontSize: 13)),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: _C.greenLight,
                  borderRadius: BorderRadius.circular(10)),
              child: const Text('আবার চেষ্টা করুন',
                  style: TextStyle(
                      color: _C.darkGreen,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
            ),
          ),
        ]),
      ),
    );
  }
}
