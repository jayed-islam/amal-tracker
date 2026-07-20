// import 'package:amal_tracker/features/monthly_summary/widgets/monthly_amol_shared.dart';
// import 'package:amal_tracker/features/tracker/models/tracker_model.dart';
// import 'package:amal_tracker/features/tracker/providers/tracker_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../core/constants/app_constants.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // CATEGORY PROGRESS SCREEN — full page (was a bottom sheet before).
// // GET /tracker/category/:categoryId/progress?months=3 থেকে সরাসরি
// // all-time + monthly trend + weekly breakdown + streak — কোনো static
// // bucket নেই, যেকোনো category-তে কাজ করে।
// // ─────────────────────────────────────────────────────────────────────────────

// class CategoryProgressScreen extends ConsumerWidget {
//   final AmalCategory category;
//   const CategoryProgressScreen({super.key, required this.category});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final params = (categoryId: category.id, months: 3);
//     final progressAsync = ref.watch(categoryProgressProvider(params));

//     return Scaffold(
//       backgroundColor: AmolColors.pageBg,
//       appBar: AppBar(
//         backgroundColor: AmolColors.darkGreen,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         titleSpacing: 0,
//         title: Row(children: [
//           AmolIcon(
//             category: category,
//             size: 34,
//             background: Colors.white.withOpacity(0.14),
//             color: Colors.white,
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(category.nameBn,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                         fontSize: 15, fontWeight: FontWeight.w800)),
//                 Text(AmolSectionMeta.label(category.section),
//                     style: TextStyle(
//                         fontSize: 10.5, color: Colors.white.withOpacity(0.6))),
//               ],
//             ),
//           ),
//         ]),
//       ),
//       body: progressAsync.when(
//         loading: () => const _DetailSkeleton(),
//         error: (_, __) => Padding(
//           padding: const EdgeInsets.all(20),
//           child: AmolErrorCard(
//             onRetry: () => ref.invalidate(categoryProgressProvider(params)),
//           ),
//         ),
//         data: (data) =>
//             _CategoryProgressContent(category: category, data: data),
//       ),
//     );
//   }
// }

// class _CategoryProgressContent extends StatelessWidget {
//   final AmalCategory category;
//   final Map<String, dynamic> data;
//   const _CategoryProgressContent({required this.category, required this.data});

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
//     final unitBn = AmolUnit.bn(category.unit);

//     return ListView(
//       padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
//       children: [
//         // ── All-time summary cards ─────────────────────────────────────────
//         Row(children: [
//           Expanded(
//             child: _DetailStatCard(
//               icon: Icons.local_fire_department_rounded,
//               value: '$streak',
//               label: 'বর্তমান স্ট্রিক',
//               color: AmolColors.amber,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: _DetailStatCard(
//               icon: Icons.calendar_month_rounded,
//               value: '$daysActive',
//               label: 'মোট সক্রিয় দিন',
//               color: AmolColors.green,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: _DetailStatCard(
//               icon: isFardPrayer
//                   ? Icons.mosque_rounded
//                   : isCounter
//                       ? Icons.numbers_rounded
//                       : Icons.check_circle_rounded,
//               value: isFardPrayer
//                   ? '$congregation'
//                   : isCounter
//                       ? '$totalCount'
//                       : '$daysActive',
//               label: isFardPrayer
//                   ? 'জামাত দিন'
//                   : isCounter
//                       ? 'মোট ${unitBn.isNotEmpty ? unitBn : "সংখ্যা"}'
//                       : 'সম্পন্ন দিন',
//               color: AmolColors.purple,
//             ),
//           ),
//         ]),

//         if (isFardPrayer) ...[
//           const SizedBox(height: 10),
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: AmolColors.cardBg,
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(color: AmolColors.border, width: 0.5),
//             ),
//             child: Row(children: [
//               _MiniBreakdown(
//                   label: 'জামাত',
//                   value: congregation,
//                   color: AmolColors.purple),
//               const SizedBox(width: 8),
//               _MiniBreakdown(
//                   label: 'একাকী', value: solo, color: AmolColors.green),
//               const SizedBox(width: 8),
//               _MiniBreakdown(
//                   label: 'মিস', value: missed, color: AmolColors.red),
//             ]),
//           ),
//         ],

//         const SizedBox(height: 24),

//         // ── Monthly trend ────────────────────────────────────────────────
//         if (monthly.isNotEmpty) ...[
//           const Text('গত কয়েক মাসের ট্রেন্ড',
//               style: TextStyle(
//                   color: AmolColors.textPrimary,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 14)),
//           const SizedBox(height: 10),
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: AmolColors.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: AmolColors.border, width: 0.5),
//             ),
//             child: SizedBox(
//               height: 122,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: monthly.reversed.map<Widget>((m) {
//                   final rate = ((m['completionRate'] as num?)?.toInt() ?? 0)
//                       .clamp(0, 100);
//                   final year = m['year'];
//                   final month = (m['month'] as num).toInt();
//                   final now = DateTime.now();
//                   final isCurrent = year == now.year && month == now.month;
//                   final mName = AppConstants.bengaliMonths[month - 1];
//                   final mShort =
//                       mName.length > 3 ? mName.substring(0, 3) : mName;
//                   const chartH = 90.0;
//                   final fillH =
//                       rate > 0 ? (rate / 100 * chartH).clamp(4.0, chartH) : 4.0;

//                   return Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 6),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text('$rate%',
//                               style: TextStyle(
//                                   fontSize: 9,
//                                   color: isCurrent
//                                       ? AmolColors.darkGreen
//                                       : AmolColors.textHint,
//                                   fontWeight: isCurrent
//                                       ? FontWeight.w800
//                                       : FontWeight.w500)),
//                           const SizedBox(height: 4),
//                           AnimatedContainer(
//                             duration: 400.ms,
//                             height: fillH,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               color: isCurrent
//                                   ? AmolColors.darkGreen
//                                   : AmolColors.midGreen.withOpacity(0.5),
//                               borderRadius: const BorderRadius.vertical(
//                                   top: Radius.circular(6)),
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(mShort,
//                               style: TextStyle(
//                                   fontSize: 9.5,
//                                   color: isCurrent
//                                       ? AmolColors.darkGreen
//                                       : AmolColors.textSecondary,
//                                   fontWeight: isCurrent
//                                       ? FontWeight.w800
//                                       : FontWeight.w500)),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//           const SizedBox(height: 24),
//         ],

//         // ── Weekly comparison ────────────────────────────────────────────
//         if (curWeek.isNotEmpty) ...[
//           const Text('এই সপ্তাহ বনাম গত সপ্তাহ',
//               style: TextStyle(
//                   color: AmolColors.textPrimary,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 14)),
//           const SizedBox(height: 10),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
//             decoration: BoxDecoration(
//               color: AmolColors.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: AmolColors.border, width: 0.5),
//             ),
//             child: Wrap(
//               alignment: WrapAlignment.spaceEvenly,
//               runSpacing: 10,
//               spacing: 2,
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
//                 const dayLbls = ['র', 'সো', 'ম', 'বু', 'বৃ', 'শু', 'শ'];

//                 Color dotColor(int v, String? mode) {
//                   if (mode == 'congregation') return AmolColors.purple;
//                   if (mode == 'solo') return AmolColors.amber;
//                   if (mode == 'missed') return AmolColors.border;
//                   return v > 0 ? AmolColors.green : AmolColors.border;
//                 }

//                 return SizedBox(
//                   width: 40,
//                   child: Column(mainAxisSize: MainAxisSize.min, children: [
//                     Container(
//                       width: 9,
//                       height: 9,
//                       margin: const EdgeInsets.only(bottom: 4),
//                       decoration: BoxDecoration(
//                         color: dotColor(prevVal, prev['mode']?.toString())
//                             .withOpacity(0.4),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     Container(
//                       width: 22,
//                       height: 22,
//                       decoration: BoxDecoration(
//                         color: dotColor(curVal, cur['mode']?.toString()),
//                         shape: BoxShape.circle,
//                       ),
//                       child: curVal > 0 && isCounter
//                           ? Center(
//                               child: FittedBox(
//                                 child: Text('$curVal',
//                                     style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 8,
//                                         fontWeight: FontWeight.w800)),
//                               ),
//                             )
//                           : null,
//                     ),
//                     const SizedBox(height: 5),
//                     Text(d != null ? dayLbls[d.weekday % 7] : '-',
//                         style: const TextStyle(
//                             color: AmolColors.textHint,
//                             fontSize: 9,
//                             fontWeight: FontWeight.w500)),
//                   ]),
//                 );
//               }),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Row(children: [
//             AmolLegendDot(color: AmolColors.green, label: 'এই সপ্তাহ'),
//             const SizedBox(width: 12),
//             Row(mainAxisSize: MainAxisSize.min, children: [
//               Container(
//                   width: 9,
//                   height: 9,
//                   decoration: BoxDecoration(
//                       color: AmolColors.green.withOpacity(0.4),
//                       shape: BoxShape.circle)),
//               const SizedBox(width: 4),
//               const Text('গত সপ্তাহ',
//                   style: TextStyle(color: AmolColors.textHint, fontSize: 9.5)),
//             ]),
//           ]),
//         ],

//         if (monthly.isEmpty && curWeek.isEmpty)
//           const Padding(
//             padding: EdgeInsets.only(top: 40),
//             child: Center(
//               child: Text('এই আমলের জন্য এখনো কোনো ডেটা নেই',
//                   style: TextStyle(color: AmolColors.textHint, fontSize: 12.5)),
//             ),
//           ),
//       ],
//     );
//   }
// }

// class _DetailStatCard extends StatelessWidget {
//   final IconData icon;
//   final String value, label;
//   final Color color;
//   const _DetailStatCard(
//       {required this.icon,
//       required this.value,
//       required this.label,
//       required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//       decoration: BoxDecoration(
//         color: AmolColors.cardBg,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: AmolColors.border, width: 0.5),
//       ),
//       child: Column(children: [
//         Icon(icon, size: 18, color: color),
//         const SizedBox(height: 6),
//         FittedBox(
//           child: Text(value,
//               style: TextStyle(
//                   color: color, fontWeight: FontWeight.w800, fontSize: 17)),
//         ),
//         const SizedBox(height: 2),
//         Text(label,
//             textAlign: TextAlign.center,
//             style: const TextStyle(color: AmolColors.textHint, fontSize: 8.5)),
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
//             style: const TextStyle(color: AmolColors.textHint, fontSize: 9.5)),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // LOADING SKELETON
// // ─────────────────────────────────────────────────────────────────────────────

// class _DetailSkeleton extends StatelessWidget {
//   const _DetailSkeleton();

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
//       children: [
//         Row(children: [
//           const Expanded(child: AmolShimmerBox(height: 78, radius: 14)),
//           const SizedBox(width: 8),
//           const Expanded(child: AmolShimmerBox(height: 78, radius: 14)),
//           const SizedBox(width: 8),
//           const Expanded(child: AmolShimmerBox(height: 78, radius: 14)),
//         ]),
//         const SizedBox(height: 24),
//         const AmolShimmerBox(width: 160, height: 14, radius: 8),
//         const SizedBox(height: 10),
//         const AmolShimmerBox(height: 140, radius: 16),
//         const SizedBox(height: 24),
//         const AmolShimmerBox(width: 180, height: 14, radius: 8),
//         const SizedBox(height: 10),
//         const AmolShimmerBox(height: 100, radius: 16),
//       ],
//     );
//   }
// }
import 'package:amal_tracker/features/monthly_summary/widgets/monthly_amol_shared.dart';
import 'package:amal_tracker/features/tracker/models/tracker_model.dart';
import 'package:amal_tracker/features/tracker/providers/tracker_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CATEGORY PROGRESS SHEET — bottom sheet (not a full page — a category detail
// is a quick peek, not a navigation destination, so a sheet is the right UX,
// consistent with the day-detail sheet already in the app).
//
// GET /tracker/category/:categoryId/progress?months=3 থেকে সরাসরি
// all-time + monthly trend + weekly breakdown + streak — কোনো static
// bucket নেই, যেকোনো category-তে কাজ করে।
//
// USAGE:
//   showCategoryProgressSheet(context, category);
// ─────────────────────────────────────────────────────────────────────────────

void showCategoryProgressSheet(BuildContext context, AmalCategory category) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _CategoryProgressSheet(category: category),
  );
}

class _CategoryProgressSheet extends ConsumerWidget {
  final AmalCategory category;
  const _CategoryProgressSheet({required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = (categoryId: category.id, months: 3);
    final progressAsync = ref.watch(categoryProgressProvider(params));

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.4,
      maxChildSize: 0.95,
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
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              AmolIcon(category: category, size: 42),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(category.nameBn,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AmolColors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 15)),
                    Text(AmolSectionMeta.label(category.section),
                        style: const TextStyle(
                            color: AmolColors.textHint,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: AmolColors.pageBg, shape: BoxShape.circle),
                  child: const Icon(Icons.close_rounded,
                      size: 16, color: AmolColors.textSecondary),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: progressAsync.when(
              loading: () => const _DetailSkeleton(),
              error: (_, __) => Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: AmolErrorCard(
                    onRetry: () =>
                        ref.invalidate(categoryProgressProvider(params)),
                  ),
                ),
              ),
              data: (data) => _CategoryProgressContent(
                category: category,
                data: data,
                scrollController: scrollController,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _CategoryProgressContent extends StatelessWidget {
  final AmalCategory category;
  final Map<String, dynamic> data;
  final ScrollController scrollController;
  const _CategoryProgressContent(
      {required this.category,
      required this.data,
      required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final isFardPrayer = category.isFard && category.isPrayer;
    final isCounter = category.inputType == AmalInputType.counter ||
        category.inputType == AmalInputType.duration;

    final allTime = (data['allTime'] as Map?) ?? {};
    final streak = (data['streak'] as num?)?.toInt() ?? 0;
    final monthly = (data['monthlyBreakdown'] as List?) ?? [];
    final weekly = (data['weeklyBreakdown'] as Map?) ?? {};
    final curWeek = (weekly['currentWeek'] as List?) ?? [];
    final prevWeek = (weekly['previousWeek'] as List?) ?? [];

    final daysActive = (allTime['daysActive'] as num?)?.toInt() ?? 0;
    final totalCount = (allTime['totalCount'] as num?)?.toInt() ?? 0;
    final congregation = (allTime['congregation'] as num?)?.toInt() ?? 0;
    final solo = (allTime['solo'] as num?)?.toInt() ?? 0;
    final missed = (allTime['missed'] as num?)?.toInt() ?? 0;
    final unitBn = AmolUnit.bn(category.unit);

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        // ── All-time summary cards ─────────────────────────────────────────
        Row(children: [
          Expanded(
            child: _DetailStatCard(
              icon: Icons.local_fire_department_rounded,
              value: '$streak',
              label: 'বর্তমান স্ট্রিক',
              color: AmolColors.amber,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _DetailStatCard(
              icon: Icons.calendar_month_rounded,
              value: '$daysActive',
              label: 'মোট সক্রিয় দিন',
              color: AmolColors.green,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _DetailStatCard(
              icon: isFardPrayer
                  ? Icons.mosque_rounded
                  : isCounter
                      ? Icons.numbers_rounded
                      : Icons.check_circle_rounded,
              value: isFardPrayer
                  ? '$congregation'
                  : isCounter
                      ? '$totalCount'
                      : '$daysActive',
              label: isFardPrayer
                  ? 'জামাত দিন'
                  : isCounter
                      ? 'মোট ${unitBn.isNotEmpty ? unitBn : "সংখ্যা"}'
                      : 'সম্পন্ন দিন',
              color: AmolColors.purple,
            ),
          ),
        ]),

        if (isFardPrayer) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AmolColors.pageBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(children: [
              _MiniBreakdown(
                  label: 'জামাত',
                  value: congregation,
                  color: AmolColors.purple),
              const SizedBox(width: 8),
              _MiniBreakdown(
                  label: 'একাকী', value: solo, color: AmolColors.green),
              const SizedBox(width: 8),
              _MiniBreakdown(
                  label: 'মিস', value: missed, color: AmolColors.red),
            ]),
          ),
        ],

        const SizedBox(height: 22),

        // ── Monthly trend ────────────────────────────────────────────────
        if (monthly.isNotEmpty) ...[
          const Text('গত কয়েক মাসের ট্রেন্ড',
              style: TextStyle(
                  color: AmolColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13.5)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AmolColors.pageBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox(
              height: 118,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: monthly.reversed.map<Widget>((m) {
                  final rate = ((m['completionRate'] as num?)?.toInt() ?? 0)
                      .clamp(0, 100);
                  final year = m['year'];
                  final month = (m['month'] as num).toInt();
                  final now = DateTime.now();
                  final isCurrent = year == now.year && month == now.month;
                  final mName = AppConstants.bengaliMonths[month - 1];
                  final mShort =
                      mName.length > 3 ? mName.substring(0, 3) : mName;
                  const chartH = 86.0;
                  final fillH =
                      rate > 0 ? (rate / 100 * chartH).clamp(4.0, chartH) : 4.0;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('$rate%',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: isCurrent
                                      ? AmolColors.darkGreen
                                      : AmolColors.textHint,
                                  fontWeight: isCurrent
                                      ? FontWeight.w800
                                      : FontWeight.w500)),
                          const SizedBox(height: 4),
                          AnimatedContainer(
                            duration: 400.ms,
                            height: fillH,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? AmolColors.darkGreen
                                  : AmolColors.midGreen.withOpacity(0.5),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6)),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(mShort,
                              style: TextStyle(
                                  fontSize: 9.5,
                                  color: isCurrent
                                      ? AmolColors.darkGreen
                                      : AmolColors.textSecondary,
                                  fontWeight: isCurrent
                                      ? FontWeight.w800
                                      : FontWeight.w500)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 22),
        ],

        // ── Weekly comparison ────────────────────────────────────────────
        if (curWeek.isNotEmpty) ...[
          const Text('এই সপ্তাহ বনাম গত সপ্তাহ',
              style: TextStyle(
                  color: AmolColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13.5)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
            decoration: BoxDecoration(
              color: AmolColors.pageBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: List.generate(7, (i) {
                final cur = i < curWeek.length
                    ? curWeek[i] as Map
                    : {'value': 0, 'mode': null};
                final prev = i < prevWeek.length
                    ? prevWeek[i] as Map
                    : {'value': 0, 'mode': null};
                final curVal = (cur['value'] as num?)?.toInt() ?? 0;
                final prevVal = (prev['value'] as num?)?.toInt() ?? 0;
                final dateStr = cur['date']?.toString() ?? '';
                final d = DateTime.tryParse(dateStr);
                const dayLbls = ['র', 'সো', 'ম', 'বু', 'বৃ', 'শু', 'শ'];

                Color dotColor(int v, String? mode) {
                  if (mode == 'congregation') return AmolColors.purple;
                  if (mode == 'solo') return AmolColors.amber;
                  if (mode == 'missed') return AmolColors.border;
                  return v > 0 ? AmolColors.green : AmolColors.border;
                }

                return Expanded(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: dotColor(prevVal, prev['mode']?.toString())
                            .withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: dotColor(curVal, cur['mode']?.toString()),
                        shape: BoxShape.circle,
                      ),
                      child: curVal > 0 && isCounter
                          ? Center(
                              child: FittedBox(
                                child: Text('$curVal',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 7.5,
                                        fontWeight: FontWeight.w800)),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 5),
                    Text(d != null ? dayLbls[d.weekday % 7] : '-',
                        style: const TextStyle(
                            color: AmolColors.textHint,
                            fontSize: 9,
                            fontWeight: FontWeight.w500)),
                  ]),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          Row(children: [
            AmolLegendDot(color: AmolColors.green, label: 'এই সপ্তাহ'),
            const SizedBox(width: 12),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                      color: AmolColors.green.withOpacity(0.4),
                      shape: BoxShape.circle)),
              const SizedBox(width: 4),
              const Text('গত সপ্তাহ',
                  style: TextStyle(color: AmolColors.textHint, fontSize: 9.5)),
            ]),
          ]),
        ],

        if (monthly.isEmpty && curWeek.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Center(
              child: Text('এই আমলের জন্য এখনো কোনো ডেটা নেই',
                  style: TextStyle(color: AmolColors.textHint, fontSize: 12.5)),
            ),
          ),
      ],
    );
  }
}

class _DetailStatCard extends StatelessWidget {
  final IconData icon;
  final String value, label;
  final Color color;
  const _DetailStatCard(
      {required this.icon,
      required this.value,
      required this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AmolColors.pageBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 6),
        FittedBox(
          child: Text(value,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w800, fontSize: 17)),
        ),
        const SizedBox(height: 2),
        Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AmolColors.textHint, fontSize: 8.5)),
      ]),
    );
  }
}

class _MiniBreakdown extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _MiniBreakdown(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Text('$value',
            style: TextStyle(
                color: color, fontWeight: FontWeight.w800, fontSize: 16)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(color: AmolColors.textHint, fontSize: 9.5)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LOADING SKELETON
// ─────────────────────────────────────────────────────────────────────────────

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        Row(children: [
          const Expanded(child: AmolShimmerBox(height: 78, radius: 14)),
          const SizedBox(width: 8),
          const Expanded(child: AmolShimmerBox(height: 78, radius: 14)),
          const SizedBox(width: 8),
          const Expanded(child: AmolShimmerBox(height: 78, radius: 14)),
        ]),
        const SizedBox(height: 22),
        const AmolShimmerBox(width: 160, height: 14, radius: 8),
        const SizedBox(height: 10),
        const AmolShimmerBox(height: 130, radius: 16),
        const SizedBox(height: 22),
        const AmolShimmerBox(width: 180, height: 14, radius: 8),
        const SizedBox(height: 10),
        const AmolShimmerBox(height: 90, radius: 16),
      ],
    );
  }
}
