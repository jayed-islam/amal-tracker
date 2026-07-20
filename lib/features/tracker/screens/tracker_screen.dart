// import 'package:amal_tracker/features/auth/providers/provider_reset.dart';
// import 'package:amal_tracker/features/tracker/screens/daily_entry_sheet.dart'
//     show DailyEntrySheet;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../providers/tracker_provider.dart';
// import '../models/tracker_model.dart';
// import '../../../core/constants/app_constants.dart';
// import '../../../core/router/app_router.dart';

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
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const amber = Color(0xFFFF6B35);
//   static const amberLight = Color(0xFFFFF3E0);
//   static const purple = Color(0xFF7C3AED);
//   static const purpleLight = Color(0xFFEDE9FE);
//   static const red = Color(0xFFEF4444);
//   static const redLight = Color(0xFFFEE2E2);
//   static const goldPale = Color(0xFFFFFBF0);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
//   static const border = Color(0xFFE4EAE4);
//   static const borderMid = Color(0xFFD0DAD2);
//   static const maafBg = Color(0xFFE8F5EE);
//   static const maafText = Color(0xFF1B7045);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // HELPERS
// // ─────────────────────────────────────────────────────────────────────────────

// String _unitLabelBn(String? unit) {
//   switch (unit) {
//     case 'ayah':
//       return 'আয়াত';
//     case 'day':
//       return 'দিন';
//     case 'person':
//       return 'জন';
//     case 'minute':
//       return 'মিনিট';
//     case 'time':
//       return 'বার';
//     case 'rakaat':
//       return 'রাকাত';
//     default:
//       return unit ?? 'টি';
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// class TrackerScreen extends ConsumerStatefulWidget {
//   const TrackerScreen({super.key});

//   @override
//   ConsumerState<TrackerScreen> createState() => _TrackerScreenState();
// }

// class _TrackerScreenState extends ConsumerState<TrackerScreen> {
//   String _dateKey(DateTime d) =>
//       '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

//   bool _isFuture(DateTime d) {
//     final t = DateTime.now();
//     return DateTime(d.year, d.month, d.day)
//         .isAfter(DateTime(t.year, t.month, t.day));
//   }

//   bool _isToday(DateTime d) {
//     final t = DateTime.now();
//     return d.year == t.year && d.month == t.month && d.day == t.day;
//   }

//   void _changeDay(DateTime cur, int delta) {
//     final next = cur.add(Duration(days: delta));
//     if (_isFuture(next)) return;
//     ref.read(selectedDateProvider.notifier).state = next;
//   }

//   Future<void> _pickDate(DateTime cur) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: cur,
//       firstDate: DateTime(2024),
//       lastDate: DateTime.now(),
//       builder: (ctx, child) => Theme(
//         data: Theme.of(ctx).copyWith(
//           colorScheme: const ColorScheme.light(primary: _C.darkGreen),
//         ),
//         child: child!,
//       ),
//     );
//     if (picked != null) {
//       ref.read(selectedDateProvider.notifier).state = picked;
//     }
//   }

//   void _openForm(
//     BuildContext context,
//     String dateStr,
//     Map<String, List<AmalCategory>> catsBySection,
//     DailyEntryState state, {
//     required bool isNew,
//   }) {
//     HapticFeedback.mediumImpact();
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       enableDrag: true,
//       useSafeArea: true,
//       builder: (_) => DailyEntrySheet(
//         dateStr: dateStr,
//         catsBySection: catsBySection,
//         existingState: state,
//         isNew: isNew,
//       ),
//     );
//   }

//   Future<void> _confirmDelete(BuildContext context, String dateStr) async {
//     HapticFeedback.mediumImpact();

//     final parts = dateStr.split('-');
//     final year = int.parse(parts[0]);
//     final month = int.parse(parts[1]);

//     final result = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => _DeleteDialog(
//         onDelete: () =>
//             ref.read(dailyEntryProvider(dateStr).notifier).deleteEntry(),
//       ),
//     );

//     if (!mounted) return;

//     if (result == true) {
//       refreshAfterEntryUpdate(ref,
//           year: year, month: month, specificDateStr: dateStr);
//       ScaffoldMessenger.of(context).clearSnackBars();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Row(children: [
//             Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
//             SizedBox(width: 10),
//             Text('আমল মুছে ফেলা হয়েছে',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600)),
//           ]),
//           backgroundColor: _C.darkGreen,
//           margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
//           behavior: SnackBarBehavior.floating,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     } else if (result == false) {
//       ScaffoldMessenger.of(context).clearSnackBars();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Row(children: [
//             Icon(Icons.error_outline_rounded, color: Colors.white, size: 18),
//             SizedBox(width: 10),
//             Text('মুছতে সমস্যা হয়েছে। আবার চেষ্টা করুন।',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600)),
//           ]),
//           backgroundColor: _C.red,
//           margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
//           behavior: SnackBarBehavior.floating,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final selectedDate = ref.watch(selectedDateProvider);
//     final dateStr = _dateKey(selectedDate);
//     final isFuture = _isFuture(selectedDate);
//     final isToday_ = _isToday(selectedDate);
//     final entryAsync = ref.watch(dailyEntryProvider(dateStr));
//     final catsBySection = ref.watch(categoriesBySection);

//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;
//     final hPad = isTablet ? (size.width - 600) / 2 + 16.0 : 16.0;

//     final hasError = entryAsync.error != null;
//     final hasEntry = !hasError &&
//         entryAsync.entry != null &&
//         (entryAsync.entry!.totalPoints > 0 ||
//             entryAsync.entry!.entries.isNotEmpty);

//     final month = AppConstants.bengaliMonths[selectedDate.month - 1];
//     final appBarTitle = isToday_
//         ? 'আজ, ${selectedDate.day} $month'
//         : '${selectedDate.day} $month ${selectedDate.year}';

//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: _C.pageBg,
//         body: RefreshIndicator(
//           color: _C.darkGreen,
//           onRefresh: () async =>
//               ref.read(dailyEntryProvider(dateStr).notifier).loadEntry(),
//           child: CustomScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             slivers: [
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
//                 title: Row(children: [
//                   Container(
//                     width: 30,
//                     height: 30,
//                     decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                             color: Colors.white.withOpacity(0.15), width: 0.5)),
//                     child: const Icon(Icons.checklist_rounded,
//                         color: Colors.white, size: 15),
//                   ),
//                   const SizedBox(width: 10),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text('আমল ট্র্যাকার',
//                           style: TextStyle(
//                               color: Colors.white.withOpacity(0.55),
//                               fontSize: 10,
//                               fontWeight: FontWeight.w500)),
//                       Text(appBarTitle,
//                           style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w800,
//                               letterSpacing: -0.3,
//                               height: 1.1)),
//                     ],
//                   ),
//                 ]),
//                 actions: [
//                   GestureDetector(
//                     onTap: () => context.go(AppRoutes.monthlyView),
//                     child: Container(
//                       margin: const EdgeInsets.only(right: 16),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 6),
//                       decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(
//                               color: Colors.white.withOpacity(0.18),
//                               width: 0.5)),
//                       child: Row(mainAxisSize: MainAxisSize.min, children: [
//                         Icon(Icons.grid_view_rounded,
//                             size: 12, color: Colors.white.withOpacity(0.7)),
//                         const SizedBox(width: 5),
//                         const Text('মাসিক',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 12)),
//                         const SizedBox(width: 3),
//                         Icon(Icons.chevron_right_rounded,
//                             size: 13, color: Colors.white.withOpacity(0.5)),
//                       ]),
//                     ),
//                   ),
//                 ],
//               ),
//               SliverToBoxAdapter(
//                 child: _DateNavHero(
//                   selectedDate: selectedDate,
//                   isFuture: isFuture,
//                   isToday: isToday_,
//                   onPrev: () => _changeDay(selectedDate, -1),
//                   onNext: () => _changeDay(selectedDate, 1),
//                   onDateTap: () => _pickDate(selectedDate),
//                 ).animate().fadeIn(duration: 260.ms),
//               ),
//               SliverPadding(
//                 padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 100),
//                 sliver: SliverList(
//                   delegate: SliverChildListDelegate([
//                     if (isFuture) ...[
//                       _FutureLock(date: selectedDate)
//                           .animate()
//                           .fadeIn(duration: 300.ms),
//                     ] else ...[
//                       _DailySummaryCard(
//                         hasEntry: hasEntry,
//                         hasError: hasError,
//                         entryState: entryAsync,
//                         isLoading: entryAsync.isLoading,
//                       ).animate().fadeIn(delay: 80.ms).slideY(begin: 0.06),
//                       const SizedBox(height: 12),
//                       if (hasError && !entryAsync.isLoading) ...[
//                         _ErrorCard(
//                           message: entryAsync.error!,
//                           onRetry: () => ref
//                               .read(dailyEntryProvider(dateStr).notifier)
//                               .loadEntry(),
//                         ).animate().fadeIn(delay: 120.ms).slideY(begin: 0.06),
//                         const SizedBox(height: 12),
//                       ],
//                       if (!entryAsync.isLoading) ...[
//                         _ActionButtons(
//                           hasEntry: hasEntry,
//                           hasError: hasError,
//                           isToday: isToday_,
//                           isSaving: entryAsync.isSaving,
//                           onAdd: () => _openForm(
//                               context, dateStr, catsBySection, entryAsync,
//                               isNew: true),
//                           onEdit: () => _openForm(
//                               context, dateStr, catsBySection, entryAsync,
//                               isNew: false),
//                           onDelete: () => _confirmDelete(context, dateStr),
//                         ).animate().fadeIn(delay: 160.ms).slideY(begin: 0.06),
//                         const SizedBox(height: 20),
//                       ],
//                       if (hasEntry && !entryAsync.isLoading && !hasError) ...[
//                         _EntryReadView(
//                           entry: entryAsync.entry!,
//                           categories: catsBySection,
//                         ).animate().fadeIn(delay: 240.ms),
//                       ] else if (!entryAsync.isLoading &&
//                           !hasEntry &&
//                           !hasError) ...[
//                         _EmptyEntryHint(isToday: isToday_)
//                             .animate()
//                             .fadeIn(delay: 240.ms),
//                       ],
//                       if (entryAsync.isLoading) const _EntrySkeleton(),
//                     ],
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
// // DATE NAVIGATOR HERO
// // ─────────────────────────────────────────────────────────────────────────────

// class _DateNavHero extends StatelessWidget {
//   final DateTime selectedDate;
//   final bool isFuture, isToday;
//   final VoidCallback onPrev, onNext, onDateTap;

//   const _DateNavHero({
//     required this.selectedDate,
//     required this.isFuture,
//     required this.isToday,
//     required this.onPrev,
//     required this.onNext,
//     required this.onDateTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final month = AppConstants.bengaliMonths[selectedDate.month - 1];

//     return Container(
//       color: _C.darkGreen,
//       child: Stack(children: [
//         Positioned(
//             top: -40,
//             right: -40,
//             child: Container(
//                 width: 120,
//                 height: 120,
//                 decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white.withOpacity(0.04)))),
//         Positioned(
//             bottom: -20,
//             left: 16,
//             child: Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white.withOpacity(0.03)))),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text('$month ${selectedDate.year} · দিন অনুযায়ী আমল',
//                 style: TextStyle(
//                     color: Colors.white.withOpacity(0.35),
//                     fontSize: 11,
//                     fontWeight: FontWeight.w500)),
//             const SizedBox(height: 10),
//             Container(
//               padding: const EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.09),
//                   borderRadius: BorderRadius.circular(14)),
//               child: Row(children: [
//                 _NavArrow(icon: Icons.chevron_left_rounded, onTap: onPrev),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: onDateTap,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 11),
//                       decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.calendar_today_rounded,
//                               color: Colors.white.withOpacity(0.6), size: 13),
//                           const SizedBox(width: 7),
//                           Column(mainAxisSize: MainAxisSize.min, children: [
//                             Text(
//                                 isToday
//                                     ? 'আজ, ${selectedDate.day} $month ${selectedDate.year}'
//                                     : '${selectedDate.day} $month ${selectedDate.year}',
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w800,
//                                     fontSize: 15,
//                                     letterSpacing: -0.2)),
//                             if (isFuture)
//                               Text('ভবিষ্যৎ তারিখ',
//                                   style: TextStyle(
//                                       color: Colors.white.withOpacity(0.45),
//                                       fontSize: 9)),
//                           ]),
//                           const SizedBox(width: 5),
//                           Icon(Icons.expand_more_rounded,
//                               color: Colors.white.withOpacity(0.45), size: 16),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 _NavArrow(
//                     icon: Icons.chevron_right_rounded,
//                     onTap: isToday ? null : onNext),
//               ]),
//             ),
//           ]),
//         ),
//       ]),
//     );
//   }
// }

// class _NavArrow extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback? onTap;
//   const _NavArrow({required this.icon, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 42,
//         height: 42,
//         decoration: BoxDecoration(
//             color: onTap != null
//                 ? Colors.white.withOpacity(0.1)
//                 : Colors.transparent,
//             borderRadius: BorderRadius.circular(9)),
//         child: Icon(icon,
//             color: onTap != null ? Colors.white : Colors.white.withOpacity(0.2),
//             size: 22),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DAILY SUMMARY CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _DailySummaryCard extends StatelessWidget {
//   final bool hasEntry, isLoading, hasError;
//   final DailyEntryState entryState;

//   const _DailySummaryCard({
//     required this.hasEntry,
//     required this.isLoading,
//     required this.hasError,
//     required this.entryState,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) return const _SummaryCardSkeleton();

//     if (hasError) {
//       return Container(
//         decoration: BoxDecoration(
//           color: _C.redLight,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: _C.red.withOpacity(0.25), width: 0.5),
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Row(children: [
//           Container(
//             width: 52,
//             height: 52,
//             decoration: BoxDecoration(
//                 color: _C.red.withOpacity(0.12),
//                 borderRadius: BorderRadius.circular(14)),
//             child: const Icon(Icons.cloud_off_rounded, color: _C.red, size: 26),
//           ),
//           const SizedBox(width: 14),
//           const Expanded(
//               child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('ডেটা লোড হয়নি',
//                   style: TextStyle(
//                       color: _C.red,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 13)),
//               SizedBox(height: 4),
//               Text('নিচের "আবার চেষ্টা করুন" বাটনে ট্যাপ করুন',
//                   style: TextStyle(color: _C.textSecondary, fontSize: 11)),
//             ],
//           )),
//         ]),
//       );
//     }

//     final pts = entryState.entry?.totalPoints ?? 0;
//     final count =
//         entryState.entry?.entries.where((e) => e.completed).length ?? 0;

//     // নামাজ count: fard prayer (congregation/solo) + sunnah/nafl prayer (completed)
//     // counter prayer (witr/tahajjud/ishraq/duha) — count > 0 হলে completed
//     // final prayers = entryState.entry?.entries.where((e) {
//     //       if (!e.completed && (e.count ?? 0) <= 0) return false;
//     //       return true;
//     //     }).length ??
//     //     0;
//     // Simple fix — prayerMode present হলেই prayer
//     final prayers = entryState.entry?.entries.where((e) {
//           if (e.prayerMode != null) {
//             // fard prayer — congregation/solo হলে count করো
//             return e.prayerMode != PrayerMode.missed;
//           }
//           // counter prayer (witr/tahajjud/ishraq/duha) — count > 0
//           // এগুলো identify করতে category দরকার — তাই approximation:
//           // prayerMode null কিন্তু count > 0 এমন entries skip করি
//           // (counter prayer গুলো separate chip-এ দেখানো যায়)
//           return false;
//         }).length ??
//         0;

//     final isExemptDay = entryState.entry?.isExemptDay ?? false;

//     return Container(
//       decoration: BoxDecoration(
//         color: hasEntry ? null : _C.cardBg,
//         gradient: hasEntry
//             ? const LinearGradient(
//                 colors: [_C.darkGreen, _C.midGreen],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight)
//             : null,
//         borderRadius: BorderRadius.circular(16),
//         border: hasEntry ? null : Border.all(color: _C.border, width: 0.5),
//       ),
//       padding: const EdgeInsets.all(16),
//       child: hasEntry
//           ? _FilledSummary(
//               pts: pts,
//               count: count,
//               prayers: prayers,
//               isExemptDay: isExemptDay,
//             )
//           : _EmptySummary(),
//     );
//   }
// }

// class _FilledSummary extends StatelessWidget {
//   final int pts, count, prayers;
//   final bool isExemptDay;
//   const _FilledSummary({
//     required this.pts,
//     required this.count,
//     required this.prayers,
//     required this.isExemptDay,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(children: [
//       Container(
//         width: 52,
//         height: 52,
//         decoration: BoxDecoration(
//             color: _C.gold, borderRadius: BorderRadius.circular(14)),
//         child: const Icon(Icons.stars_rounded, color: Colors.white, size: 28),
//       ),
//       const SizedBox(width: 14),
//       Expanded(
//           child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(children: [
//             const Text('আজকের আমল সম্পন্ন ✓',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 13)),
//             if (isExemptDay) ...[
//               const SizedBox(width: 6),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
//                 decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.18),
//                     borderRadius: BorderRadius.circular(20)),
//                 child: const Text('🌸 মাহলি',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 9.5,
//                         fontWeight: FontWeight.w600)),
//               ),
//             ],
//           ]),
//           const SizedBox(height: 7),
//           Wrap(spacing: 6, runSpacing: 4, children: [
//             _SumChip('$pts pts', Icons.star_rounded),
//             _SumChip('$count আমল', Icons.check_circle_rounded),
//             _SumChip('$prayers নামাজ', Icons.mosque_rounded),
//           ]),
//         ],
//       )),
//     ]);
//   }
// }

// class _SumChip extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   const _SumChip(this.label, this.icon);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.15),
//           borderRadius: BorderRadius.circular(20)),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [
//         Icon(icon, color: Colors.white.withOpacity(0.7), size: 11),
//         const SizedBox(width: 4),
//         Text(label,
//             style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 11,
//                 fontWeight: FontWeight.w600)),
//       ]),
//     );
//   }
// }

// class _EmptySummary extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(children: [
//       Container(
//         width: 52,
//         height: 52,
//         decoration: BoxDecoration(
//             color: _C.greenLight, borderRadius: BorderRadius.circular(14)),
//         child:
//             const Icon(Icons.edit_note_rounded, color: _C.darkGreen, size: 28),
//       ),
//       const SizedBox(width: 14),
//       const Expanded(
//           child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('কোনো আমল রেকর্ড হয়নি',
//               style: TextStyle(
//                   color: _C.textPrimary,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 13)),
//           SizedBox(height: 4),
//           Text('নিচের বাটনে ট্যাপ করে আমল যোগ করুন',
//               style: TextStyle(color: _C.textSecondary, fontSize: 11)),
//         ],
//       )),
//     ]);
//   }
// }

// class _SummaryCardSkeleton extends StatelessWidget {
//   const _SummaryCardSkeleton();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 84,
//       decoration: BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: _C.border, width: 0.5)),
//     ).animate(onPlay: (c) => c.repeat()).shimmer(
//       duration: 1200.ms,
//       colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // ERROR CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _ErrorCard extends StatelessWidget {
//   final String message;
//   final VoidCallback onRetry;

//   const _ErrorCard({required this.message, required this.onRetry});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       decoration: BoxDecoration(
//         color: _C.redLight,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: _C.red.withOpacity(0.25), width: 0.5),
//       ),
//       child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const Padding(
//           padding: EdgeInsets.only(top: 1),
//           child: Icon(Icons.error_outline_rounded, color: _C.red, size: 18),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('সংযোগ সমস্যা হয়েছে',
//                   style: TextStyle(
//                       color: _C.red,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 13)),
//               const SizedBox(height: 3),
//               Text(
//                 message.length > 80 ? '${message.substring(0, 80)}…' : message,
//                 style: const TextStyle(
//                     color: _C.textSecondary, fontSize: 11, height: 1.4),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 10),
//         GestureDetector(
//           onTap: onRetry,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
//             decoration: BoxDecoration(
//                 color: _C.red, borderRadius: BorderRadius.circular(10)),
//             child: const Text('আবার চেষ্টা',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 11,
//                     fontWeight: FontWeight.w700)),
//           ),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // ACTION BUTTONS
// // ─────────────────────────────────────────────────────────────────────────────

// class _ActionButtons extends StatelessWidget {
//   final bool hasEntry, isToday, isSaving, hasError;
//   final VoidCallback onAdd, onEdit, onDelete;

//   const _ActionButtons({
//     required this.hasEntry,
//     required this.isToday,
//     required this.isSaving,
//     required this.hasError,
//     required this.onAdd,
//     required this.onEdit,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (hasError) {
//       return Container(
//         height: 52,
//         decoration: BoxDecoration(
//             color: _C.border, borderRadius: BorderRadius.circular(14)),
//         child:
//             const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           Icon(Icons.block_rounded, color: _C.textHint, size: 18),
//           SizedBox(width: 8),
//           Text('আমল যোগ/সম্পাদনা করা যাচ্ছে না',
//               style: TextStyle(
//                   color: _C.textHint,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 13)),
//         ]),
//       );
//     }

//     if (!hasEntry) {
//       return GestureDetector(
//         onTap: isSaving ? null : onAdd,
//         child: Container(
//           height: 52,
//           decoration: BoxDecoration(
//               color: _C.darkGreen, borderRadius: BorderRadius.circular(14)),
//           child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             if (isSaving)
//               const SizedBox(
//                   width: 18,
//                   height: 18,
//                   child: CircularProgressIndicator(
//                       color: Colors.white, strokeWidth: 2))
//             else ...[
//               const Icon(Icons.add_rounded, color: Colors.white, size: 20),
//               const SizedBox(width: 7),
//               const Text('আমল যোগ করুন',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 14)),
//             ],
//           ]),
//         ),
//       );
//     }

//     return Row(children: [
//       Expanded(
//           flex: 3,
//           child: GestureDetector(
//             onTap: onEdit,
//             child: Container(
//               height: 50,
//               decoration: BoxDecoration(
//                   color: _C.darkGreen, borderRadius: BorderRadius.circular(14)),
//               child: const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.edit_rounded, color: Colors.white, size: 16),
//                     SizedBox(width: 7),
//                     Text('সম্পাদনা করুন',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w700,
//                             fontSize: 13)),
//                   ]),
//             ),
//           )),
//       const SizedBox(width: 10),
//       GestureDetector(
//         onTap: onDelete,
//         child: Container(
//           height: 50,
//           width: 96,
//           decoration: BoxDecoration(
//               color: _C.redLight,
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(color: _C.red.withOpacity(0.2), width: 0.5)),
//           child:
//               const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Icon(Icons.delete_outline_rounded, color: _C.red, size: 16),
//             SizedBox(width: 5),
//             Text('মুছুন',
//                 style: TextStyle(
//                     color: _C.red, fontWeight: FontWeight.w700, fontSize: 13)),
//           ]),
//         ),
//       ),
//     ]);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // ENTRY READ VIEW
// // ─────────────────────────────────────────────────────────────────────────────

// class _EntryReadView extends StatelessWidget {
//   final DailyEntry entry;
//   final Map<String, List<AmalCategory>> categories;

//   const _EntryReadView({required this.entry, required this.categories});

//   @override
//   Widget build(BuildContext context) {
//     final entryMap = {for (final e in entry.entries) e.categoryId: e};
//     final isExemptDay = entry.isExemptDay;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(children: [
//           const Text('📋', style: TextStyle(fontSize: 14)),
//           const SizedBox(width: 7),
//           const Text('আজকের আমলের বিবরণ',
//               style: TextStyle(
//                   color: _C.textPrimary,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 15,
//                   letterSpacing: -0.2)),
//           if (isExemptDay) ...[
//             const SizedBox(width: 8),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//               decoration: BoxDecoration(
//                   color: _C.maafBg,
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                       color: _C.green.withOpacity(0.25), width: 0.5)),
//               child: const Text('🌸 মাহলির দিন',
//                   style: TextStyle(
//                       fontSize: 10,
//                       fontWeight: FontWeight.w600,
//                       color: _C.maafText)),
//             ),
//           ],
//         ]),
//         const SizedBox(height: 12),
//         ...AppConstants.sectionLabels.entries.map((sec) {
//           final cats = categories[sec.key] ?? [];
//           if (cats.isEmpty) return const SizedBox.shrink();

//           final visibleItems = cats.where((c) {
//             final item = entryMap[c.id];
//             // exempt day এ fard নামাজ দেখাও — "মাফ আছে" badge সহ
//             if (isExemptDay && c.isFard) return true;
//             if (item == null) return false;
//             // counter prayer (witr/tahajjud/ishraq/duha) — count > 0 হলে দেখাও
//             if (c.isPrayer && c.inputType == AmalInputType.counter) {
//               return (item.count ?? 0) > 0;
//             }
//             return item.completed;
//           }).toList();

//           if (visibleItems.isEmpty) return const SizedBox.shrink();

//           return _SectionReadCard(
//             sectionKey: sec.key,
//             label: sec.value['bn'] ?? '',
//             cats: visibleItems,
//             entryMap: entryMap,
//             isExemptDay: isExemptDay,
//           ).animate().fadeIn(delay: 100.ms);
//         }),
//       ],
//     );
//   }
// }

// class _SectionReadCard extends StatelessWidget {
//   final String sectionKey, label;
//   final List<AmalCategory> cats;
//   final Map<String, DailyEntryItem> entryMap;
//   final bool isExemptDay;

//   static const _icons = <String, IconData>{
//     'salat': Icons.mosque_rounded,
//     'sunnah_nafl': Icons.auto_awesome_rounded,
//     'dhikr_tilawat': Icons.menu_book_rounded,
//     'daily_habits': Icons.self_improvement_rounded,
//     'weekly': Icons.date_range_rounded,
//     'special_dhulhijja': Icons.star_rounded,
//     'social': Icons.people_rounded,
//   };

//   const _SectionReadCard({
//     required this.sectionKey,
//     required this.label,
//     required this.cats,
//     required this.entryMap,
//     required this.isExemptDay,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final completedCount = cats.where((c) {
//       final item = entryMap[c.id];
//       if (isExemptDay && c.isFard) return false; // exempt — not "completed"
//       if (c.isPrayer && c.inputType == AmalInputType.counter) {
//         return (item?.count ?? 0) > 0;
//       }
//       return item?.completed == true;
//     }).length;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: _C.cardBg,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
//           child: Row(children: [
//             Container(
//               width: 30,
//               height: 30,
//               decoration: BoxDecoration(
//                   color: _C.greenLight, borderRadius: BorderRadius.circular(8)),
//               child: Icon(_icons[sectionKey] ?? Icons.circle_rounded,
//                   color: _C.darkGreen, size: 16),
//             ),
//             const SizedBox(width: 9),
//             Expanded(
//                 child: Text(label,
//                     style: const TextStyle(
//                         color: _C.darkGreen,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 13))),
//             if (completedCount > 0)
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                 decoration: BoxDecoration(
//                     color: _C.greenLight,
//                     borderRadius: BorderRadius.circular(20)),
//                 child: Text('$completedCount টি',
//                     style: const TextStyle(
//                         color: _C.darkGreen,
//                         fontSize: 10,
//                         fontWeight: FontWeight.w700)),
//               ),
//           ]),
//         ),
//         const SizedBox(height: 8),
//         const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//         ...cats.asMap().entries.map((e) => _ReadItem(
//               cat: e.value,
//               item: entryMap[e.value.id],
//               isLast: e.key == cats.length - 1,
//               isExemptDay: isExemptDay,
//             )),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // READ ITEM  ← main fix is here
// //
// // নতুন JSON অনুযায়ী ৪ ধরনের prayer:
// //   1. Fard prayer       → isFard=true, inputType=binary → congregation/solo/missed
// //   2. Rakaat counter    → isPrayer=true, inputType=counter, unit=rakaat → "X রাকাত"
// //   3. Sunnah toggle     → isPrayer=true, isFard=false, inputType=binary → "সম্পন্ন"
// //   4. Non-prayer binary → isPrayer=false, inputType=binary → "সম্পন্ন"
// //   5. Non-prayer counter→ isPrayer=false, inputType=counter → "X আয়াত/বার"
// // ─────────────────────────────────────────────────────────────────────────────

// class _ReadItem extends StatelessWidget {
//   final AmalCategory cat;
//   final DailyEntryItem? item;
//   final bool isLast, isExemptDay;

//   const _ReadItem({
//     required this.cat,
//     required this.isLast,
//     required this.isExemptDay,
//     this.item,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final pts = item?.points ?? 0;

//     // ── Exempted (female period day + fard) ──────────────────────────────────
//     final isExempted = isExemptDay && cat.isFard;
//     if (isExempted) {
//       return _ItemRow(
//         isLast: isLast,
//         opacity: 0.6,
//         icon: Icons.favorite_border_rounded,
//         iconColor: _C.maafText,
//         nameBn: cat.nameBn,
//         strikethrough: true,
//         badgeLabel: 'মাফ আছে',
//         badgeColor: _C.maafText,
//         badgeBg: _C.maafBg,
//         pts: 0,
//       );
//     }

//     // ── Fard prayer — congregation/solo/missed ────────────────────────────────
//     if (cat.isPrayer && cat.isFard) {
//       final mode = item?.prayerMode;
//       if (mode == PrayerMode.congregation) {
//         return _ItemRow(
//           isLast: isLast,
//           icon: Icons.people_rounded,
//           iconColor: _C.green,
//           nameBn: cat.nameBn,
//           badgeLabel: 'জামাতে',
//           badgeColor: _C.green,
//           pts: pts,
//         );
//       } else if (mode == PrayerMode.solo) {
//         return _ItemRow(
//           isLast: isLast,
//           icon: Icons.person_rounded,
//           iconColor: _C.amber,
//           nameBn: cat.nameBn,
//           badgeLabel: 'একাকী',
//           badgeColor: _C.amber,
//           pts: pts,
//         );
//       } else {
//         // missed — show only if explicitly tracked
//         return _ItemRow(
//           isLast: isLast,
//           icon: Icons.close_rounded,
//           iconColor: _C.textHint,
//           nameBn: cat.nameBn,
//           opacity: 0.6,
//           badgeLabel: 'মিস',
//           badgeColor: _C.textHint,
//           pts: 0,
//         );
//       }
//     }

//     // ── Rakaat counter prayer (witr/tahajjud/ishraq/duha) ────────────────────
//     if (cat.isPrayer && cat.inputType == AmalInputType.counter) {
//       final count = item?.count ?? 0;
//       final unitBn = _unitLabelBn(cat.unit); // "রাকাত"
//       final isWitr = cat.key == 'witr';
//       return _ItemRow(
//         isLast: isLast,
//         icon: Icons.mosque_rounded,
//         iconColor: _C.darkGreen,
//         nameBn: cat.nameBn,
//         badgeLabel: '$count $unitBn',
//         badgeColor: _C.darkGreen,
//         pts: pts,
//         subLabel: isWitr ? 'বেজোড়' : null,
//       );
//     }

//     // ── Sunnah/Nafl fixed toggle (fajr_sunnah, sunnah_muakkadah, juma, travel) ──
//     if (cat.isPrayer && !cat.isFard) {
//       return _ItemRow(
//         isLast: isLast,
//         icon: Icons.check_circle_rounded,
//         iconColor: _C.green,
//         nameBn: cat.nameBn,
//         badgeLabel: 'সম্পন্ন',
//         badgeColor: _C.green,
//         pts: pts,
//       );
//     }

//     // ── Non-prayer counter (quran/dhikr/fasting) ─────────────────────────────
//     if (cat.inputType == AmalInputType.counter) {
//       final count = item?.count ?? 0;
//       final unitBn = _unitLabelBn(cat.unit);
//       return _ItemRow(
//         isLast: isLast,
//         icon: Icons.add_circle_outline_rounded,
//         iconColor: _C.darkGreen,
//         nameBn: cat.nameBn,
//         badgeLabel: '$count $unitBn',
//         badgeColor: _C.darkGreen,
//         pts: pts,
//       );
//     }

//     // ── Non-prayer binary (default) ──────────────────────────────────────────
//     return _ItemRow(
//       isLast: isLast,
//       icon: Icons.check_circle_rounded,
//       iconColor: _C.green,
//       nameBn: cat.nameBn,
//       badgeLabel: 'সম্পন্ন',
//       badgeColor: _C.green,
//       pts: pts,
//     );
//   }
// }

// // ─── Shared row widget ────────────────────────────────────────────────────────

// class _ItemRow extends StatelessWidget {
//   final bool isLast;
//   final double opacity;
//   final IconData icon;
//   final Color iconColor;
//   final String nameBn;
//   final bool strikethrough;
//   final String badgeLabel;
//   final Color badgeColor;
//   final Color? badgeBg;
//   final int pts;
//   final String? subLabel; // optional small tag below badge

//   const _ItemRow({
//     required this.isLast,
//     required this.icon,
//     required this.iconColor,
//     required this.nameBn,
//     required this.badgeLabel,
//     required this.badgeColor,
//     required this.pts,
//     this.opacity = 1.0,
//     this.strikethrough = false,
//     this.badgeBg,
//     this.subLabel,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final bg = badgeBg ?? badgeColor.withOpacity(0.1);

//     return Opacity(
//       opacity: opacity,
//       child: Container(
//         padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
//         decoration: BoxDecoration(
//           border: isLast
//               ? null
//               : const Border(bottom: BorderSide(color: _C.border, width: 0.5)),
//           borderRadius: isLast
//               ? const BorderRadius.vertical(bottom: Radius.circular(16))
//               : null,
//         ),
//         child: Row(children: [
//           Icon(icon, color: iconColor, size: 18),
//           const SizedBox(width: 10),
//           Expanded(
//               child: Text(
//             nameBn,
//             style: TextStyle(
//                 color: strikethrough ? _C.textHint : _C.textPrimary,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 13,
//                 decoration: strikethrough ? TextDecoration.lineThrough : null,
//                 decorationColor: _C.textHint),
//           )),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                 decoration: BoxDecoration(
//                     color: bg, borderRadius: BorderRadius.circular(20)),
//                 child: Row(mainAxisSize: MainAxisSize.min, children: [
//                   Text(badgeLabel,
//                       style: TextStyle(
//                           color: badgeColor,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600)),
//                   if (pts > 0) ...[
//                     const SizedBox(width: 4),
//                     Text('+$pts',
//                         style: TextStyle(
//                             color: badgeColor.withOpacity(0.65),
//                             fontSize: 9.5)),
//                   ],
//                 ]),
//               ),
//               if (subLabel != null) ...[
//                 const SizedBox(height: 2),
//                 Text(subLabel!,
//                     style: const TextStyle(
//                         color: _C.textHint,
//                         fontSize: 9,
//                         fontWeight: FontWeight.w500)),
//               ],
//             ],
//           ),
//         ]),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // EMPTY ENTRY HINT
// // ─────────────────────────────────────────────────────────────────────────────

// class _EmptyEntryHint extends StatelessWidget {
//   final bool isToday;
//   const _EmptyEntryHint({required this.isToday});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//           color: isToday ? _C.greenLight : _C.goldPale,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//               color: isToday
//                   ? _C.green.withOpacity(0.2)
//                   : _C.gold.withOpacity(0.3),
//               width: 0.5)),
//       child: Column(children: [
//         Text(isToday ? '💡' : '📅', style: const TextStyle(fontSize: 32)),
//         const SizedBox(height: 10),
//         Text(isToday ? 'আজকের আমল রেকর্ড করুন!' : 'এই দিনের আমল নেই',
//             style: TextStyle(
//                 color: isToday ? _C.darkGreen : _C.textPrimary,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 14)),
//         const SizedBox(height: 6),
//         Text(
//             isToday
//                 ? '"আমল যোগ করুন" বাটনে ট্যাপ করুন এবং প্রতিটি আমলের তথ্য পূরণ করুন।\nআল্লাহ আপনার আমল কবুল করুন।'
//                 : 'এই তারিখে কোনো আমল রেকর্ড করা হয়নি।\nচাইলে এখনো যোগ করতে পারবেন।',
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//                 color: _C.textSecondary, fontSize: 12, height: 1.6)),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // FUTURE LOCK
// // ─────────────────────────────────────────────────────────────────────────────

// class _FutureLock extends StatelessWidget {
//   final DateTime date;
//   const _FutureLock({required this.date});

//   @override
//   Widget build(BuildContext context) {
//     final month = AppConstants.bengaliMonths[date.month - 1];
//     return Padding(
//       padding: const EdgeInsets.only(top: 40),
//       child: Column(children: [
//         Container(
//           width: 88,
//           height: 88,
//           decoration: BoxDecoration(
//               color: _C.cardBg,
//               shape: BoxShape.circle,
//               border: Border.all(color: _C.border, width: 1.5)),
//           child: const Icon(Icons.lock_clock_rounded,
//               color: _C.textHint, size: 40),
//         ),
//         const SizedBox(height: 18),
//         const Text('ভবিষ্যৎ তারিখ!',
//             style: TextStyle(
//                 color: _C.textPrimary,
//                 fontWeight: FontWeight.w800,
//                 fontSize: 20,
//                 letterSpacing: -0.3)),
//         const SizedBox(height: 8),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 32),
//           child: Text(
//               '${date.day} $month ${date.year} তারিখে আমল রেকর্ড করা যাবে না।\nআগের বা আজকের তারিখ বেছে নিন।',
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                   color: _C.textSecondary, fontSize: 13, height: 1.6)),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DELETE DIALOG
// // ─────────────────────────────────────────────────────────────────────────────

// class _DeleteDialog extends StatefulWidget {
//   final Future<bool> Function() onDelete;
//   const _DeleteDialog({required this.onDelete});

//   @override
//   State<_DeleteDialog> createState() => _DeleteDialogState();
// }

// class _DeleteDialogState extends State<_DeleteDialog> {
//   bool _loading = false;

//   Future<void> _handleConfirm() async {
//     if (_loading) return;
//     setState(() => _loading = true);
//     HapticFeedback.mediumImpact();
//     try {
//       final ok = await widget.onDelete();
//       if (mounted) Navigator.of(context).pop(ok);
//     } catch (_) {
//       if (mounted) Navigator.of(context).pop(false);
//     }
//   }

//   void _handleCancel() {
//     if (_loading) return;
//     Navigator.of(context).pop(null);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: !_loading,
//       child: Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: const EdgeInsets.symmetric(horizontal: 24),
//         child: Container(
//           decoration: BoxDecoration(
//             color: _C.cardBg,
//             borderRadius: BorderRadius.circular(22),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.10),
//                 blurRadius: 32,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           clipBehavior: Clip.antiAlias,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: 44,
//                       height: 44,
//                       decoration: BoxDecoration(
//                         color: _C.redLight,
//                         borderRadius: BorderRadius.circular(13),
//                       ),
//                       child: const Icon(Icons.delete_outline_rounded,
//                           color: _C.red, size: 22),
//                     ),
//                     const SizedBox(width: 14),
//                     const Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('আমল মুছবেন?',
//                               style: TextStyle(
//                                   color: _C.textPrimary,
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w800,
//                                   letterSpacing: -0.2)),
//                           SizedBox(height: 8),
//                           Text(
//                             'এই দিনের সকল আমল তথ্য মুছে ফেলা হবে। এই কাজটি পূর্বাবস্থায় ফেরানো যাবে না।',
//                             style: TextStyle(
//                                 color: _C.textSecondary,
//                                 fontSize: 13,
//                                 height: 1.6),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//               SizedBox(
//                 height: 52,
//                 child: _loading
//                     ? Center(
//                         child: SizedBox(
//                           width: 22,
//                           height: 22,
//                           child: CircularProgressIndicator(
//                               strokeWidth: 2.2, color: _C.red),
//                         ),
//                       )
//                     : Row(children: [
//                         Expanded(
//                           child: _DialogBtn(
//                             label: 'বাতিল',
//                             color: _C.textSecondary,
//                             position: _BtnPos.left,
//                             onTap: _handleCancel,
//                           ),
//                         ),
//                         const VerticalDivider(
//                             width: 0.5, thickness: 0.5, color: _C.border),
//                         Expanded(
//                           child: _DialogBtn(
//                             label: 'হ্যাঁ, মুছুন',
//                             color: _C.red,
//                             bold: true,
//                             position: _BtnPos.right,
//                             onTap: _handleConfirm,
//                           ),
//                         ),
//                       ]),
//               ),
//             ],
//           ),
//         ),
//       )
//           .animate()
//           .scale(
//             begin: const Offset(0.92, 0.92),
//             duration: 200.ms,
//             curve: Curves.easeOutBack,
//           )
//           .fadeIn(duration: 160.ms),
//     );
//   }
// }

// enum _BtnPos { left, right, single }

// class _DialogBtn extends StatelessWidget {
//   final String label;
//   final Color color;
//   final bool bold;
//   final _BtnPos position;
//   final VoidCallback onTap;

//   const _DialogBtn({
//     required this.label,
//     required this.color,
//     required this.position,
//     required this.onTap,
//     this.bold = false,
//   });

//   BorderRadius get _radius {
//     switch (position) {
//       case _BtnPos.left:
//         return const BorderRadius.only(bottomLeft: Radius.circular(22));
//       case _BtnPos.right:
//         return const BorderRadius.only(bottomRight: Radius.circular(22));
//       case _BtnPos.single:
//         return const BorderRadius.only(
//           bottomLeft: Radius.circular(22),
//           bottomRight: Radius.circular(22),
//         );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: _radius,
//         splashColor: color.withOpacity(0.08),
//         highlightColor: color.withOpacity(0.05),
//         child: SizedBox.expand(
//           child: Center(
//             child: Text(label,
//                 style: TextStyle(
//                   color: color,
//                   fontSize: 13.5,
//                   fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
//                 )),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SKELETON
// // ─────────────────────────────────────────────────────────────────────────────

// class _EntrySkeleton extends StatelessWidget {
//   const _EntrySkeleton();

//   @override
//   Widget build(BuildContext context) {
//     shimmer(Widget w, {int delay = 0}) =>
//         w.animate(onPlay: (c) => c.repeat()).shimmer(
//             duration: 1200.ms,
//             delay: delay.ms,
//             colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg]);

//     return Column(children: [
//       shimmer(Container(
//           height: 84,
//           decoration: BoxDecoration(
//               color: _C.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: _C.border, width: 0.5)))),
//       const SizedBox(height: 12),
//       shimmer(
//           Container(
//               height: 50,
//               decoration: BoxDecoration(
//                   color: _C.cardBg,
//                   borderRadius: BorderRadius.circular(14),
//                   border: Border.all(color: _C.border, width: 0.5))),
//           delay: 80),
//       const SizedBox(height: 20),
//       ...List.generate(
//           3,
//           (i) => Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: shimmer(
//                     Container(
//                         height: 120,
//                         decoration: BoxDecoration(
//                             color: _C.cardBg,
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(color: _C.border, width: 0.5))),
//                     delay: 120 + i * 60),
//               )),
//     ]);
//   }
// }
import 'package:amal_tracker/features/auth/providers/provider_reset.dart';
import 'package:amal_tracker/features/tracker/screens/daily_entry_sheet.dart'
    show DailyEntrySheet;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/tracker_provider.dart';
import '../models/tracker_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────

class _C {
  static const pageBg = Color(0xFFF4F6F1);
  static const cardBg = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const midGreen = Color(0xFF1B7045);
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFFFF3E0);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const amber = Color(0xFFFF6B35);
  static const amberLight = Color(0xFFFFF3E0);
  static const purple = Color(0xFF7C3AED);
  static const purpleLight = Color(0xFFEDE9FE);
  static const red = Color(0xFFEF4444);
  static const redLight = Color(0xFFFEE2E2);
  static const goldPale = Color(0xFFFFFBF0);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
  static const border = Color(0xFFE4EAE4);
  static const borderMid = Color(0xFFD0DAD2);
  static const maafBg = Color(0xFFE8F5EE);
  static const maafText = Color(0xFF1B7045);
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────

String _unitLabelBn(String? unit) {
  switch (unit) {
    case 'ayah':
      return 'আয়াত';
    case 'day':
      return 'দিন';
    case 'person':
      return 'জন';
    case 'minute':
      return 'মিনিট';
    case 'time':
      return 'বার';
    case 'rakaat':
      return 'রাকাত';
    default:
      return unit ?? 'টি';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class TrackerScreen extends ConsumerStatefulWidget {
  const TrackerScreen({super.key});

  @override
  ConsumerState<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends ConsumerState<TrackerScreen> {
  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  bool _isFuture(DateTime d) {
    final t = DateTime.now();
    return DateTime(d.year, d.month, d.day)
        .isAfter(DateTime(t.year, t.month, t.day));
  }

  bool _isToday(DateTime d) {
    final t = DateTime.now();
    return d.year == t.year && d.month == t.month && d.day == t.day;
  }

  void _changeDay(DateTime cur, int delta) {
    final next = cur.add(Duration(days: delta));
    if (_isFuture(next)) return;
    ref.read(selectedDateProvider.notifier).state = next;
  }

  Future<void> _pickDate(DateTime cur) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: cur,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: _C.darkGreen),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      ref.read(selectedDateProvider.notifier).state = picked;
    }
  }

  void _openForm(
    BuildContext context,
    String dateStr,
    Map<String, List<AmalCategory>> catsBySection,
    DailyEntryState state, {
    required bool isNew,
  }) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      useSafeArea: true,
      builder: (_) => DailyEntrySheet(
        dateStr: dateStr,
        catsBySection: catsBySection,
        existingState: state,
        isNew: isNew,
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String dateStr) async {
    HapticFeedback.mediumImpact();
    final parts = dateStr.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _DeleteDialog(
        onDelete: () =>
            ref.read(dailyEntryProvider(dateStr).notifier).deleteEntry(),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      refreshAfterEntryUpdate(ref,
          year: year, month: month, specificDateStr: dateStr);
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(_snackBar(
          'আমল মুছে ফেলা হয়েছে',
          Icons.check_circle_rounded,
          _C.darkGreen,
        ));
    } else if (result == false) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(_snackBar(
          'মুছতে সমস্যা হয়েছে। আবার চেষ্টা করুন।',
          Icons.error_outline_rounded,
          _C.red,
        ));
    }
  }

  SnackBar _snackBar(String msg, IconData icon, Color color) => SnackBar(
        content: Row(children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Text(msg,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ]),
        backgroundColor: color,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 3),
      );

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final dateStr = _dateKey(selectedDate);
    final isFuture = _isFuture(selectedDate);
    final isToday_ = _isToday(selectedDate);
    final entryAsync = ref.watch(dailyEntryProvider(dateStr));
    final catsBySection = ref.watch(categoriesBySection);

    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final hPad = isTablet ? (size.width - 600) / 2 + 16.0 : 16.0;

    final hasError = entryAsync.error != null;
    // point নেই — entries আছে কিনা / hasActivity দেখো
    final hasEntry = !hasError &&
        entryAsync.entry != null &&
        (entryAsync.entry!.hasActivity || entryAsync.entry!.entries.isNotEmpty);

    final month = AppConstants.bengaliMonths[selectedDate.month - 1];
    final appBarTitle = isToday_
        ? 'আজ, ${selectedDate.day} $month'
        : '${selectedDate.day} $month ${selectedDate.year}';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _C.pageBg,
        body: RefreshIndicator(
          color: _C.darkGreen,
          onRefresh: () async =>
              ref.read(dailyEntryProvider(dateStr).notifier).loadEntry(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ── App Bar ─────────────────────────────────────────────────
              SliverAppBar(
                pinned: true,
                floating: false,
                expandedHeight: 0,
                toolbarHeight: 56,
                backgroundColor: _C.darkGreen,
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
                            color: Colors.white.withOpacity(0.15), width: 0.5)),
                    child: const Icon(Icons.checklist_rounded,
                        color: Colors.white, size: 15),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('আমল ট্র্যাকার',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.55),
                              fontSize: 10,
                              fontWeight: FontWeight.w500)),
                      Text(appBarTitle,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                              height: 1.1)),
                    ],
                  ),
                ]),
                actions: [
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.monthlyView),
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.18),
                              width: 0.5)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.grid_view_rounded,
                            size: 12, color: Colors.white.withOpacity(0.7)),
                        const SizedBox(width: 5),
                        const Text('মাসিক',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12)),
                        const SizedBox(width: 3),
                        Icon(Icons.chevron_right_rounded,
                            size: 13, color: Colors.white.withOpacity(0.5)),
                      ]),
                    ),
                  ),
                ],
              ),

              // ── Date Navigator ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: _DateNavHero(
                  selectedDate: selectedDate,
                  isFuture: isFuture,
                  isToday: isToday_,
                  onPrev: () => _changeDay(selectedDate, -1),
                  onNext: () => _changeDay(selectedDate, 1),
                  onDateTap: () => _pickDate(selectedDate),
                ).animate().fadeIn(duration: 260.ms),
              ),

              // ── Content ──────────────────────────────────────────────────
              SliverPadding(
                padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    if (isFuture) ...[
                      _FutureLock(date: selectedDate)
                          .animate()
                          .fadeIn(duration: 300.ms),
                    ] else ...[
                      // Daily summary card
                      _DailySummaryCard(
                        hasEntry: hasEntry,
                        hasError: hasError,
                        entryState: entryAsync,
                        isLoading: entryAsync.isLoading,
                      ).animate().fadeIn(delay: 80.ms).slideY(begin: 0.06),
                      const SizedBox(height: 12),

                      // Error card
                      if (hasError && !entryAsync.isLoading) ...[
                        _ErrorCard(
                          message: entryAsync.error!,
                          onRetry: () => ref
                              .read(dailyEntryProvider(dateStr).notifier)
                              .loadEntry(),
                        ).animate().fadeIn(delay: 120.ms).slideY(begin: 0.06),
                        const SizedBox(height: 12),
                      ],

                      // Action buttons
                      if (!entryAsync.isLoading) ...[
                        _ActionButtons(
                          hasEntry: hasEntry,
                          hasError: hasError,
                          isToday: isToday_,
                          isSaving: entryAsync.isSaving,
                          onAdd: () => _openForm(
                              context, dateStr, catsBySection, entryAsync,
                              isNew: true),
                          onEdit: () => _openForm(
                              context, dateStr, catsBySection, entryAsync,
                              isNew: false),
                          onDelete: () => _confirmDelete(context, dateStr),
                        ).animate().fadeIn(delay: 160.ms).slideY(begin: 0.06),
                        const SizedBox(height: 20),
                      ],

                      // Entry read view
                      if (hasEntry && !entryAsync.isLoading && !hasError) ...[
                        _EntryReadView(
                          entry: entryAsync.entry!,
                          categories: catsBySection,
                        ).animate().fadeIn(delay: 240.ms),
                      ] else if (!entryAsync.isLoading &&
                          !hasEntry &&
                          !hasError) ...[
                        _EmptyEntryHint(isToday: isToday_)
                            .animate()
                            .fadeIn(delay: 240.ms),
                      ],

                      if (entryAsync.isLoading) const _EntrySkeleton(),
                    ],
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
// DATE NAVIGATOR HERO
// ─────────────────────────────────────────────────────────────────────────────

class _DateNavHero extends StatelessWidget {
  final DateTime selectedDate;
  final bool isFuture, isToday;
  final VoidCallback onPrev, onNext, onDateTap;

  const _DateNavHero({
    required this.selectedDate,
    required this.isFuture,
    required this.isToday,
    required this.onPrev,
    required this.onNext,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    final month = AppConstants.bengaliMonths[selectedDate.month - 1];

    return Container(
      color: _C.darkGreen,
      child: Stack(children: [
        Positioned(
            top: -40,
            right: -40,
            child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.04)))),
        Positioned(
            bottom: -20,
            left: 16,
            child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.03)))),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$month ${selectedDate.year} · দিন অনুযায়ী আমল',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.35),
                    fontSize: 11,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(14)),
              child: Row(children: [
                _NavArrow(icon: Icons.chevron_left_rounded, onTap: onPrev),
                Expanded(
                  child: GestureDetector(
                    onTap: onDateTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              color: Colors.white.withOpacity(0.6), size: 13),
                          const SizedBox(width: 7),
                          Column(mainAxisSize: MainAxisSize.min, children: [
                            Text(
                                isToday
                                    ? 'আজ, ${selectedDate.day} $month ${selectedDate.year}'
                                    : '${selectedDate.day} $month ${selectedDate.year}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    letterSpacing: -0.2)),
                            if (isFuture)
                              Text('ভবিষ্যৎ তারিখ',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.45),
                                      fontSize: 9)),
                          ]),
                          const SizedBox(width: 5),
                          Icon(Icons.expand_more_rounded,
                              color: Colors.white.withOpacity(0.45), size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
                _NavArrow(
                    icon: Icons.chevron_right_rounded,
                    onTap: isToday ? null : onNext),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _NavArrow({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
            color: onTap != null
                ? Colors.white.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(9)),
        child: Icon(icon,
            color: onTap != null ? Colors.white : Colors.white.withOpacity(0.2),
            size: 22),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DAILY SUMMARY CARD
// ─────────────────────────────────────────────────────────────────────────────

class _DailySummaryCard extends StatelessWidget {
  final bool hasEntry, isLoading, hasError;
  final DailyEntryState entryState;

  const _DailySummaryCard({
    required this.hasEntry,
    required this.isLoading,
    required this.hasError,
    required this.entryState,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const _SummaryCardSkeleton();

    if (hasError) {
      return Container(
        decoration: BoxDecoration(
          color: _C.redLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.red.withOpacity(0.25), width: 0.5),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
                color: _C.red.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.cloud_off_rounded, color: _C.red, size: 26),
          ),
          const SizedBox(width: 14),
          const Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ডেটা লোড হয়নি',
                  style: TextStyle(
                      color: _C.red,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              SizedBox(height: 4),
              Text('নিচের "আবার চেষ্টা করুন" বাটনে ট্যাপ করুন',
                  style: TextStyle(color: _C.textSecondary, fontSize: 11)),
            ],
          )),
        ]),
      );
    }

    // ── Counts ────────────────────────────────────────────────────────────
    final entries = entryState.entry?.entries ?? [];
    final isExemptDay = entryState.entry?.isExemptDay ?? false;

    // সম্পন্ন আমল count (fard prayer congregation/solo, counter>0, binary completed)
    final completedCount = entries.where((e) {
      if (e.prayerMode != null) return e.prayerMode != PrayerMode.missed;
      if (e.count > 0) return true;
      return e.completed;
    }).length;

    // নামাজ — fard prayer congregation/solo count
    final prayerCount = entries
        .where((e) => e.prayerMode != null && e.prayerMode != PrayerMode.missed)
        .length;

    // জামাতে নামাজ count
    final jamaatCount =
        entries.where((e) => e.prayerMode == PrayerMode.congregation).length;

    return Container(
      decoration: BoxDecoration(
        color: hasEntry ? null : _C.cardBg,
        gradient: hasEntry
            ? const LinearGradient(
                colors: [_C.darkGreen, _C.midGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)
            : null,
        borderRadius: BorderRadius.circular(16),
        border: hasEntry ? null : Border.all(color: _C.border, width: 0.5),
      ),
      padding: const EdgeInsets.all(16),
      child: hasEntry
          ? _FilledSummary(
              completedCount: completedCount,
              prayerCount: prayerCount,
              jamaatCount: jamaatCount,
              isExemptDay: isExemptDay,
            )
          : const _EmptySummary(),
    );
  }
}

class _FilledSummary extends StatelessWidget {
  final int completedCount, prayerCount, jamaatCount;
  final bool isExemptDay;

  const _FilledSummary({
    required this.completedCount,
    required this.prayerCount,
    required this.jamaatCount,
    required this.isExemptDay,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
            color: _C.gold, borderRadius: BorderRadius.circular(14)),
        child: const Icon(Icons.check_circle_rounded,
            color: Colors.white, size: 28),
      ),
      const SizedBox(width: 14),
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('আজকের আমল সম্পন্ন ✓',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
            if (isExemptDay) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20)),
                child: const Text('🌸 মাহলি',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ]),
          const SizedBox(height: 7),
          Wrap(spacing: 6, runSpacing: 4, children: [
            _SumChip('$completedCount আমল', Icons.check_circle_rounded),
            _SumChip('$prayerCount নামাজ', Icons.mosque_rounded),
            if (jamaatCount > 0)
              _SumChip('$jamaatCount জামাত', Icons.people_rounded),
          ]),
        ],
      )),
    ]);
  }
}

class _SumChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SumChip(this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: Colors.white.withOpacity(0.7), size: 11),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _EmptySummary extends StatelessWidget {
  const _EmptySummary();

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
            color: _C.greenLight, borderRadius: BorderRadius.circular(14)),
        child:
            const Icon(Icons.edit_note_rounded, color: _C.darkGreen, size: 28),
      ),
      const SizedBox(width: 14),
      const Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('কোনো আমল রেকর্ড হয়নি',
              style: TextStyle(
                  color: _C.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13)),
          SizedBox(height: 4),
          Text('নিচের বাটনে ট্যাপ করে আমল যোগ করুন',
              style: TextStyle(color: _C.textSecondary, fontSize: 11)),
        ],
      )),
    ]);
  }
}

class _SummaryCardSkeleton extends StatelessWidget {
  const _SummaryCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      decoration: BoxDecoration(
          color: _C.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.border, width: 0.5)),
    ).animate(onPlay: (c) => c.repeat()).shimmer(
      duration: 1200.ms,
      colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ERROR CARD
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _C.redLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.red.withOpacity(0.25), width: 0.5),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
          padding: EdgeInsets.only(top: 1),
          child: Icon(Icons.error_outline_rounded, color: _C.red, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('সংযোগ সমস্যা হয়েছে',
                  style: TextStyle(
                      color: _C.red,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              const SizedBox(height: 3),
              Text(
                message.length > 80 ? '${message.substring(0, 80)}…' : message,
                style: const TextStyle(
                    color: _C.textSecondary, fontSize: 11, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onRetry,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                color: _C.red, borderRadius: BorderRadius.circular(10)),
            child: const Text('আবার চেষ্টা',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ACTION BUTTONS
// ─────────────────────────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final bool hasEntry, isToday, isSaving, hasError;
  final VoidCallback onAdd, onEdit, onDelete;

  const _ActionButtons({
    required this.hasEntry,
    required this.isToday,
    required this.isSaving,
    required this.hasError,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return Container(
        height: 52,
        decoration: BoxDecoration(
            color: _C.border, borderRadius: BorderRadius.circular(14)),
        child:
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.block_rounded, color: _C.textHint, size: 18),
          SizedBox(width: 8),
          Text('আমল যোগ/সম্পাদনা করা যাচ্ছে না',
              style: TextStyle(
                  color: _C.textHint,
                  fontWeight: FontWeight.w600,
                  fontSize: 13)),
        ]),
      );
    }

    if (!hasEntry) {
      return GestureDetector(
        onTap: isSaving ? null : onAdd,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
              color: _C.darkGreen, borderRadius: BorderRadius.circular(14)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (isSaving)
              const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
            else ...[
              const Icon(Icons.add_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 7),
              const Text('আমল যোগ করুন',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
            ],
          ]),
        ),
      );
    }

    return Row(children: [
      Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: onEdit,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: _C.darkGreen, borderRadius: BorderRadius.circular(14)),
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 7),
                    Text('সম্পাদনা করুন',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13)),
                  ]),
            ),
          )),
      const SizedBox(width: 10),
      GestureDetector(
        onTap: onDelete,
        child: Container(
          height: 50,
          width: 96,
          decoration: BoxDecoration(
              color: _C.redLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _C.red.withOpacity(0.2), width: 0.5)),
          child:
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.delete_outline_rounded, color: _C.red, size: 16),
            SizedBox(width: 5),
            Text('মুছুন',
                style: TextStyle(
                    color: _C.red, fontWeight: FontWeight.w700, fontSize: 13)),
          ]),
        ),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ENTRY READ VIEW
// ─────────────────────────────────────────────────────────────────────────────

class _EntryReadView extends StatelessWidget {
  final DailyEntry entry;
  final Map<String, List<AmalCategory>> categories;

  const _EntryReadView({required this.entry, required this.categories});

  @override
  Widget build(BuildContext context) {
    final entryMap = {for (final e in entry.entries) e.categoryId: e};
    final isExemptDay = entry.isExemptDay;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Text('📋', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 7),
          const Text('আজকের আমলের বিবরণ',
              style: TextStyle(
                  color: _C.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  letterSpacing: -0.2)),
          if (isExemptDay) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: _C.maafBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: _C.green.withOpacity(0.25), width: 0.5)),
              child: const Text('🌸 মাহলির দিন',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _C.maafText)),
            ),
          ],
        ]),
        const SizedBox(height: 12),
        ...AppConstants.sectionLabels.entries.map((sec) {
          final cats = categories[sec.key] ?? [];
          if (cats.isEmpty) return const SizedBox.shrink();

          final visibleItems = cats.where((c) {
            // exempt day এ fard নামাজ দেখাও — "মাফ আছে" badge সহ
            if (isExemptDay && c.isFard) return true;
            final item = entryMap[c.id];
            if (item == null) return false;
            // fard prayer — congregation/solo হলে দেখাও
            if (item.prayerMode != null) {
              return item.prayerMode != PrayerMode.missed;
            }
            // counter — count > 0
            if (item.count > 0) return true;
            // binary
            return item.completed;
          }).toList();

          if (visibleItems.isEmpty) return const SizedBox.shrink();

          return _SectionReadCard(
            sectionKey: sec.key,
            label: sec.value['bn'] ?? '',
            cats: visibleItems,
            entryMap: entryMap,
            isExemptDay: isExemptDay,
          ).animate().fadeIn(delay: 100.ms);
        }),
      ],
    );
  }
}

class _SectionReadCard extends StatelessWidget {
  final String sectionKey, label;
  final List<AmalCategory> cats;
  final Map<String, DailyEntryItem> entryMap;
  final bool isExemptDay;

  static const _icons = <String, IconData>{
    'salat': Icons.mosque_rounded,
    'sunnah_nafl': Icons.auto_awesome_rounded,
    'dhikr_tilawat': Icons.menu_book_rounded,
    'daily_habits': Icons.self_improvement_rounded,
    'weekly': Icons.date_range_rounded,
    'special_dhulhijja': Icons.star_rounded,
    'social': Icons.people_rounded,
  };

  const _SectionReadCard({
    required this.sectionKey,
    required this.label,
    required this.cats,
    required this.entryMap,
    required this.isExemptDay,
  });

  @override
  Widget build(BuildContext context) {
    final completedCount = cats.where((c) {
      if (isExemptDay && c.isFard) return false;
      final item = entryMap[c.id];
      if (item == null) return false;
      if (item.prayerMode != null) return item.prayerMode != PrayerMode.missed;
      if (item.count > 0) return true;
      return item.completed;
    }).length;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 0.5),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
          child: Row(children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: _C.greenLight, borderRadius: BorderRadius.circular(8)),
              child: Icon(_icons[sectionKey] ?? Icons.circle_rounded,
                  color: _C.darkGreen, size: 16),
            ),
            const SizedBox(width: 9),
            Expanded(
                child: Text(label,
                    style: const TextStyle(
                        color: _C.darkGreen,
                        fontWeight: FontWeight.w700,
                        fontSize: 13))),
            if (completedCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: _C.greenLight,
                    borderRadius: BorderRadius.circular(20)),
                child: Text('$completedCount টি',
                    style: const TextStyle(
                        color: _C.darkGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.w700)),
              ),
          ]),
        ),
        const SizedBox(height: 8),
        const Divider(height: 0.5, thickness: 0.5, color: _C.border),
        ...cats.asMap().entries.map((e) => _ReadItem(
              cat: e.value,
              item: entryMap[e.value.id],
              isLast: e.key == cats.length - 1,
              isExemptDay: isExemptDay,
            )),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// READ ITEM — points নেই, count/mode ভিত্তিক badge
// ─────────────────────────────────────────────────────────────────────────────

class _ReadItem extends StatelessWidget {
  final AmalCategory cat;
  final DailyEntryItem? item;
  final bool isLast, isExemptDay;

  const _ReadItem({
    required this.cat,
    required this.isLast,
    required this.isExemptDay,
    this.item,
  });

  @override
  Widget build(BuildContext context) {
    // ── Exempted ────────────────────────────────────────────────────────────
    if (isExemptDay && cat.isFard) {
      return _ItemRow(
        isLast: isLast,
        opacity: 0.6,
        icon: Icons.favorite_border_rounded,
        iconColor: _C.maafText,
        nameBn: cat.nameBn,
        strikethrough: true,
        badgeLabel: 'মাফ আছে',
        badgeColor: _C.maafText,
        badgeBg: _C.maafBg,
      );
    }

    // ── Fard prayer ─────────────────────────────────────────────────────────
    if (cat.isPrayer && cat.isFard) {
      final mode = item?.prayerMode;
      if (mode == PrayerMode.congregation) {
        return _ItemRow(
          isLast: isLast,
          icon: Icons.people_rounded,
          iconColor: _C.green,
          nameBn: cat.nameBn,
          badgeLabel: 'জামাতে',
          badgeColor: _C.green,
        );
      } else if (mode == PrayerMode.solo) {
        return _ItemRow(
          isLast: isLast,
          icon: Icons.person_rounded,
          iconColor: _C.amber,
          nameBn: cat.nameBn,
          badgeLabel: 'একাকী',
          badgeColor: _C.amber,
        );
      } else {
        return _ItemRow(
          isLast: isLast,
          icon: Icons.close_rounded,
          iconColor: _C.textHint,
          nameBn: cat.nameBn,
          opacity: 0.6,
          badgeLabel: 'মিস',
          badgeColor: _C.textHint,
        );
      }
    }

    // ── Rakaat counter prayer (witr/tahajjud/ishraq/duha) ───────────────────
    if (cat.isPrayer && cat.inputType == AmalInputType.counter) {
      final count = item?.count ?? 0;
      final unitBn = _unitLabelBn(cat.unit);
      return _ItemRow(
        isLast: isLast,
        icon: Icons.mosque_rounded,
        iconColor: _C.darkGreen,
        nameBn: cat.nameBn,
        badgeLabel: '$count $unitBn',
        badgeColor: _C.darkGreen,
        subLabel: cat.key == 'witr' ? 'বেজোড়' : null,
      );
    }

    // ── Sunnah/Nafl binary toggle ────────────────────────────────────────────
    if (cat.isPrayer && !cat.isFard) {
      return _ItemRow(
        isLast: isLast,
        icon: Icons.check_circle_rounded,
        iconColor: _C.green,
        nameBn: cat.nameBn,
        badgeLabel: 'সম্পন্ন',
        badgeColor: _C.green,
      );
    }

    // ── Counter (quran/dhikr/fasting) ────────────────────────────────────────
    if (cat.inputType == AmalInputType.counter ||
        cat.inputType == AmalInputType.duration) {
      final count = item?.count ?? 0;
      final unitBn = _unitLabelBn(cat.unit);
      return _ItemRow(
        isLast: isLast,
        icon: Icons.add_circle_outline_rounded,
        iconColor: _C.darkGreen,
        nameBn: cat.nameBn,
        badgeLabel: '$count $unitBn',
        badgeColor: _C.darkGreen,
      );
    }

    // ── Binary (default) ─────────────────────────────────────────────────────
    return _ItemRow(
      isLast: isLast,
      icon: Icons.check_circle_rounded,
      iconColor: _C.green,
      nameBn: cat.nameBn,
      badgeLabel: 'সম্পন্ন',
      badgeColor: _C.green,
    );
  }
}

// ── Shared row — points field সম্পূর্ণ বাদ ────────────────────────────────────

class _ItemRow extends StatelessWidget {
  final bool isLast;
  final double opacity;
  final IconData icon;
  final Color iconColor;
  final String nameBn;
  final bool strikethrough;
  final String badgeLabel;
  final Color badgeColor;
  final Color? badgeBg;
  final String? subLabel;

  const _ItemRow({
    required this.isLast,
    required this.icon,
    required this.iconColor,
    required this.nameBn,
    required this.badgeLabel,
    required this.badgeColor,
    this.opacity = 1.0,
    this.strikethrough = false,
    this.badgeBg,
    this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    final bg = badgeBg ?? badgeColor.withOpacity(0.1);

    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(bottom: BorderSide(color: _C.border, width: 0.5)),
          borderRadius: isLast
              ? const BorderRadius.vertical(bottom: Radius.circular(16))
              : null,
        ),
        child: Row(children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
              child: Text(
            nameBn,
            style: TextStyle(
                color: strikethrough ? _C.textHint : _C.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 13,
                decoration: strikethrough ? TextDecoration.lineThrough : null,
                decorationColor: _C.textHint),
          )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: bg, borderRadius: BorderRadius.circular(20)),
                child: Text(badgeLabel,
                    style: TextStyle(
                        color: badgeColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
              ),
              if (subLabel != null) ...[
                const SizedBox(height: 2),
                Text(subLabel!,
                    style: const TextStyle(
                        color: _C.textHint,
                        fontSize: 9,
                        fontWeight: FontWeight.w500)),
              ],
            ],
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EMPTY ENTRY HINT
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyEntryHint extends StatelessWidget {
  final bool isToday;
  const _EmptyEntryHint({required this.isToday});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: isToday ? _C.greenLight : _C.goldPale,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isToday
                  ? _C.green.withOpacity(0.2)
                  : _C.gold.withOpacity(0.3),
              width: 0.5)),
      child: Column(children: [
        Text(isToday ? '💡' : '📅', style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 10),
        Text(isToday ? 'আজকের আমল রেকর্ড করুন!' : 'এই দিনের আমল নেই',
            style: TextStyle(
                color: isToday ? _C.darkGreen : _C.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14)),
        const SizedBox(height: 6),
        Text(
            isToday
                ? '"আমল যোগ করুন" বাটনে ট্যাপ করুন এবং প্রতিটি আমলের তথ্য পূরণ করুন।\nআল্লাহ আপনার আমল কবুল করুন।'
                : 'এই তারিখে কোনো আমল রেকর্ড করা হয়নি।\nচাইলে এখনো যোগ করতে পারবেন।',
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: _C.textSecondary, fontSize: 12, height: 1.6)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FUTURE LOCK
// ─────────────────────────────────────────────────────────────────────────────

class _FutureLock extends StatelessWidget {
  final DateTime date;
  const _FutureLock({required this.date});

  @override
  Widget build(BuildContext context) {
    final month = AppConstants.bengaliMonths[date.month - 1];
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
              color: _C.cardBg,
              shape: BoxShape.circle,
              border: Border.all(color: _C.border, width: 1.5)),
          child: const Icon(Icons.lock_clock_rounded,
              color: _C.textHint, size: 40),
        ),
        const SizedBox(height: 18),
        const Text('ভবিষ্যৎ তারিখ!',
            style: TextStyle(
                color: _C.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: -0.3)),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
              '${date.day} $month ${date.year} তারিখে আমল রেকর্ড করা যাবে না।\nআগের বা আজকের তারিখ বেছে নিন।',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: _C.textSecondary, fontSize: 13, height: 1.6)),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DELETE DIALOG
// ─────────────────────────────────────────────────────────────────────────────

class _DeleteDialog extends StatefulWidget {
  final Future<bool> Function() onDelete;
  const _DeleteDialog({required this.onDelete});

  @override
  State<_DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<_DeleteDialog> {
  bool _loading = false;

  Future<void> _handleConfirm() async {
    if (_loading) return;
    setState(() => _loading = true);
    HapticFeedback.mediumImpact();
    try {
      final ok = await widget.onDelete();
      if (mounted) Navigator.of(context).pop(ok);
    } catch (_) {
      if (mounted) Navigator.of(context).pop(false);
    }
  }

  void _handleCancel() {
    if (_loading) return;
    Navigator.of(context).pop(null);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_loading,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          decoration: BoxDecoration(
            color: _C.cardBg,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 32,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          color: _C.redLight,
                          borderRadius: BorderRadius.circular(13)),
                      child: const Icon(Icons.delete_outline_rounded,
                          color: _C.red, size: 22),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('আমল মুছবেন?',
                              style: TextStyle(
                                  color: _C.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.2)),
                          SizedBox(height: 8),
                          Text(
                            'এই দিনের সকল আমল তথ্য মুছে ফেলা হবে। এই কাজটি পূর্বাবস্থায় ফেরানো যাবে না।',
                            style: TextStyle(
                                color: _C.textSecondary,
                                fontSize: 13,
                                height: 1.6),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0.5, thickness: 0.5, color: _C.border),
              SizedBox(
                height: 52,
                child: _loading
                    ? Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.2, color: _C.red),
                        ),
                      )
                    : Row(children: [
                        Expanded(
                          child: _DialogBtn(
                            label: 'বাতিল',
                            color: _C.textSecondary,
                            position: _BtnPos.left,
                            onTap: _handleCancel,
                          ),
                        ),
                        const VerticalDivider(
                            width: 0.5, thickness: 0.5, color: _C.border),
                        Expanded(
                          child: _DialogBtn(
                            label: 'হ্যাঁ, মুছুন',
                            color: _C.red,
                            bold: true,
                            position: _BtnPos.right,
                            onTap: _handleConfirm,
                          ),
                        ),
                      ]),
              ),
            ],
          ),
        ),
      )
          .animate()
          .scale(
            begin: const Offset(0.92, 0.92),
            duration: 200.ms,
            curve: Curves.easeOutBack,
          )
          .fadeIn(duration: 160.ms),
    );
  }
}

enum _BtnPos { left, right }

class _DialogBtn extends StatelessWidget {
  final String label;
  final Color color;
  final bool bold;
  final _BtnPos position;
  final VoidCallback onTap;

  const _DialogBtn({
    required this.label,
    required this.color,
    required this.position,
    required this.onTap,
    this.bold = false,
  });

  BorderRadius get _radius => position == _BtnPos.left
      ? const BorderRadius.only(bottomLeft: Radius.circular(22))
      : const BorderRadius.only(bottomRight: Radius.circular(22));

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: _radius,
        splashColor: color.withOpacity(0.08),
        highlightColor: color.withOpacity(0.05),
        child: SizedBox.expand(
          child: Center(
            child: Text(label,
                style: TextStyle(
                  color: color,
                  fontSize: 13.5,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                )),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SKELETON
// ─────────────────────────────────────────────────────────────────────────────

class _EntrySkeleton extends StatelessWidget {
  const _EntrySkeleton();

  @override
  Widget build(BuildContext context) {
    Widget shimmer(Widget w, {int delay = 0}) =>
        w.animate(onPlay: (c) => c.repeat()).shimmer(
            duration: 1200.ms,
            delay: delay.ms,
            colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg]);

    return Column(children: [
      shimmer(Container(
          height: 84,
          decoration: BoxDecoration(
              color: _C.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _C.border, width: 0.5)))),
      const SizedBox(height: 12),
      shimmer(
          Container(
              height: 50,
              decoration: BoxDecoration(
                  color: _C.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _C.border, width: 0.5))),
          delay: 80),
      const SizedBox(height: 20),
      ...List.generate(
          3,
          (i) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: shimmer(
                    Container(
                        height: 120,
                        decoration: BoxDecoration(
                            color: _C.cardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _C.border, width: 0.5))),
                    delay: 120 + i * 60),
              )),
    ]);
  }
}
