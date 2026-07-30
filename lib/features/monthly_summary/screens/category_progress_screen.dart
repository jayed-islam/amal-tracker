import 'package:amal_tracker/features/monthly_summary/widgets/monthly_amol_shared.dart';
import 'package:amal_tracker/features/tracker/models/tracker_model.dart';
import 'package:amal_tracker/features/tracker/providers/tracker_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

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
        decoration: BoxDecoration(
          color: context.colors.cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(children: [
          const SizedBox(height: 12),
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: context.colors.border,
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
                        style: TextStyle(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 15)),
                    Text(AmolSectionMeta.label(category.section),
                        style: TextStyle(
                            color: context.colors.textHint,
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
                      color: context.colors.pageBg, shape: BoxShape.circle),
                  child: Icon(Icons.close_rounded,
                      size: 16, color: context.colors.textSecondary),
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
              color: context.colors.amber2,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _DetailStatCard(
              icon: Icons.calendar_month_rounded,
              value: '$daysActive',
              label: 'মোট সক্রিয় দিন',
              color: context.colors.green,
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
              color: context.colors.purple,
            ),
          ),
        ]),

        if (isFardPrayer) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.colors.pageBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(children: [
              _MiniBreakdown(
                  label: 'জামাত',
                  value: congregation,
                  color: context.colors.purple),
              const SizedBox(width: 8),
              _MiniBreakdown(
                  label: 'একাকী', value: solo, color: context.colors.green),
              const SizedBox(width: 8),
              _MiniBreakdown(
                  label: 'মিস', value: missed, color: context.colors.red),
            ]),
          ),
        ],

        const SizedBox(height: 22),

        // ── Monthly trend ────────────────────────────────────────────────
        if (monthly.isNotEmpty) ...[
          Text('গত কয়েক মাসের ট্রেন্ড',
              style: TextStyle(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13.5)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.colors.pageBg,
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
                                      ? context.colors.darkGreen
                                      : context.colors.textHint,
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
                                  ? context.colors.darkGreen
                                  : context.colors.midGreen.withOpacity(0.5),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6)),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(mShort,
                              style: TextStyle(
                                  fontSize: 9.5,
                                  color: isCurrent
                                      ? context.colors.darkGreen
                                      : context.colors.textSecondary,
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
          Text('এই সপ্তাহ বনাম গত সপ্তাহ',
              style: TextStyle(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13.5)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
            decoration: BoxDecoration(
              color: context.colors.pageBg,
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
                  if (mode == 'congregation') return context.colors.purple;
                  if (mode == 'solo') return context.colors.amber2;
                  if (mode == 'missed') return context.colors.border;
                  return v > 0 ? context.colors.green : context.colors.border;
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
                        style: TextStyle(
                            color: context.colors.textHint,
                            fontSize: 9,
                            fontWeight: FontWeight.w500)),
                  ]),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          Row(children: [
            AmolLegendDot(color: context.colors.green, label: 'এই সপ্তাহ'),
            const SizedBox(width: 12),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                      color: context.colors.green.withOpacity(0.4),
                      shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Text('গত সপ্তাহ',
                  style: TextStyle(color: context.colors.textHint, fontSize: 9.5)),
            ]),
          ]),
        ],

        if (monthly.isEmpty && curWeek.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Center(
              child: Text('এই আমলের জন্য এখনো কোনো ডেটা নেই',
                  style: TextStyle(color: context.colors.textHint, fontSize: 12.5)),
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
        color: context.colors.pageBg,
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
            style: TextStyle(color: context.colors.textHint, fontSize: 8.5)),
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
            style: TextStyle(color: context.colors.textHint, fontSize: 9.5)),
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
