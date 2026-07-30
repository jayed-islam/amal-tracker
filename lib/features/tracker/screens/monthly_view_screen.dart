import 'package:amal_tracker/features/monthly_summary/screens/category_list_screen.dart';
import 'package:amal_tracker/features/monthly_summary/widgets/monthly_amol_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tracker_provider.dart';
import '../models/tracker_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/cache_provider.dart';
import '../../../shared/widgets/delayed_progress_indicator.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

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
    ref.watch(cacheStatusProvider); // Watch to rebuild on lifecycle/app resume
    final params = (year: _year, month: _month);

    // Lazy check-and-refresh for Report Tab data
    final activeIndex = ref.watch(activeTabIndexProvider);
    if (activeIndex == 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          checkAndRefreshTab(ref, CacheTab.monthly, () {
            ref.refresh(monthlyEntriesProvider(params));
            ref.refresh(progressSummaryProvider(params));
          }, ttl: const Duration(minutes: 10));
        }
      });
    }

    final entriesAsync = ref.watch(monthlyEntriesProvider(params));
    final progressAsync = ref.watch(progressSummaryProvider(params));

    final monthName = AppConstants.bengaliMonths[_month - 1];

    final isBackgroundRefreshing =
        (progressAsync.isLoading && progressAsync.hasValue) ||
            (entriesAsync.isLoading && entriesAsync.hasValue);

    return Scaffold(
      backgroundColor: context.colors.pageBg,
      body: Stack(
        children: [
          RefreshIndicator(
            color: context.colors.darkGreen,
            onRefresh: () async {
              ref
                  .read(cacheStatusProvider.notifier)
                  .updateLastFetched(CacheTab.monthly);
              await Future.wait([
                ref.refresh(monthlyEntriesProvider(params).future),
                ref.refresh(progressSummaryProvider(params).future),
                ref.refresh(categoriesProvider.future),
              ]);
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 11, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.18),
                              width: 0.5),
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
                      if (p.userGender != 'female')
                        return const SizedBox.shrink();
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

                // ── Entry card → dedicated "সব আমল" full page ───────────────────
                SliverToBoxAdapter(
                  child: progressAsync.when(
                    loading: () => const _SectionSkeleton(height: 72),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (_) => Padding(
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
                          child: AmolEmptyCard(
                              label: 'মাসিক তুলনামূলক কোনো ডেটা নেই'),
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
                      if (p.currentMonth == null ||
                          p.currentMonth!.rank == null) {
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
                            onRetry: () => ref
                                .invalidate(monthlyEntriesProvider(params)))),
                    data: (entries) {
                      final userGender =
                          progressAsync.valueOrNull?.userGender ?? 'male';

                      // ২১ থেকে ১ উল্টো সিরিয়ালে সর্টিং
                      final sortedEntries = List<DailyEntry>.from(entries)
                        ..sort((a, b) => b.day.compareTo(a.day));

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
                          Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text('যেকোনো দিনে ট্যাপ করে বিস্তারিত দেখুন',
                                style: TextStyle(
                                    color: context.colors.textHint,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w500)),
                          ),
                          if (sortedEntries.isEmpty)
                            AmolEmptyCard(label: '$monthName মাসে কোনো আমল নেই')
                          else
                            Container(
                              decoration: BoxDecoration(
                                color: context.colors.cardBg,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: context.colors.border, width: 0.5),
                              ),
                              child: Column(
                                children: List.generate(
                                  sortedEntries.length,
                                  (i) => _DayRow(
                                    entry: sortedEntries[i],
                                    isLast: i == sortedEntries.length - 1,
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
          if (isBackgroundRefreshing)
            Positioned(
              top: MediaQuery.of(context).padding.top + 54,
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
      color: context.colors.darkGreen,
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
                              color: context.colors.gold,
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
                          style: TextStyle(
                              color: context.colors.gold,
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
        ? context.colors.green
        : percentage >= 50
            ? context.colors.gold
            : context.colors.amber2;

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
          decoration: BoxDecoration(
              color: context.colors.darkGreen, shape: BoxShape.circle),
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
        color: context.colors.purplePale,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: context.colors.purple.withOpacity(0.25), width: 0.5),
      ),
      child: Row(children: [
        Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: context.colors.purpleLight,
                borderRadius: BorderRadius.circular(8)),
            child: const Center(
                child: Text('🌸', style: TextStyle(fontSize: 15)))),
        const SizedBox(width: 10),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('মাহলির দিন চিহ্নিত',
              style: TextStyle(
                  color: context.colors.purple,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text('$exemptCount দিন মাফ — নামাজ ও রোজার হিসাব বাদ দেওয়া হয়েছে',
              style: TextStyle(
                  color: context.colors.purple.withOpacity(0.7),
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
                  emojiBg: context.colors.amberLight,
                  value: '$streak',
                  label: 'স্ট্রিক দিন',
                  valueColor: context.colors.amber2)),
          const SizedBox(width: 8),
          Expanded(
              child: _StatCard(
                  emoji: '📅',
                  emojiBg: context.colors.greenLight,
                  value: '$daysActive',
                  label: 'আমল করা দিন',
                  valueColor: context.colors.green)),
          const SizedBox(width: 8),
          Expanded(
              child: _StatCard(
                  emoji: '✅',
                  emojiBg: context.colors.greenLight,
                  value: '$farzDays',
                  label: 'পূর্ণ ফরজ দিন',
                  valueColor: context.colors.darkGreen)),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Row(children: [
          Expanded(
              child: _StatCard(
                  emoji: '🕌',
                  emojiBg: context.colors.purpleLight,
                  value: '$jamaat',
                  label: 'জামাত (ওয়াক্ত)',
                  valueColor: context.colors.purple)),
          const SizedBox(width: 8),
          Expanded(
              child: _StatCard(
                  emoji: '⏳',
                  emojiBg: context.colors.greenLight,
                  value: '$eligible',
                  label: 'হিসাবভুক্ত দিন',
                  valueColor: context.colors.green)),
          const SizedBox(width: 8),
          if (isFemale)
            Expanded(
                child: _StatCard(
                    emoji: '🌸',
                    emojiBg: context.colors.purplePale,
                    value: '$exemptDays',
                    label: 'মাহলির দিন',
                    valueColor: context.colors.purple))
          else
            Expanded(
                child: _StatCard(
                    emoji: '🏅',
                    emojiBg: context.colors.goldLight,
                    value: tracker?.rank != null ? '#${tracker!.rank}' : '---',
                    label: 'র‍্যাংক',
                    valueColor: context.colors.gold)),
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
          color: context.colors.cardBg,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: context.colors.border, width: 0.5)),
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
            style: TextStyle(
                color: context.colors.textSecondary,
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
      if (pct >= 90) return context.colors.green;
      if (pct >= 70) return context.colors.amber2;
      return context.colors.red;
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
            badgeColor: jamaat > 0 ? context.colors.purple : context.colors.textHint,
            barValue:
                eligible > 0 ? (jamaat / (eligible * 5)).clamp(0.0, 1.0) : 0,
            barColor: context.colors.purple,
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
          color: context.colors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.colors.border, width: 0.5)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Text(title,
                  style: TextStyle(
                      color: context.colors.textPrimary,
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
            style: TextStyle(color: context.colors.textHint, fontSize: 9.5)),
        const SizedBox(height: 8),
        ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
                value: barValue.clamp(0.0, 1.0),
                minHeight: 5,
                backgroundColor: context.colors.pageBg,
                valueColor: AlwaysStoppedAnimation(barColor))),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COMPARE METRIC
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
              color: context.colors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.colors.border, width: 0.5)),
          child: Column(children: [
            LayoutBuilder(builder: (ctx, constraints) {
              final chartH = (constraints.maxWidth * 0.36).clamp(90.0, 150.0);
              const valLblH = 14.0;
              const mthLblH = 12.0;
              const gapH = 8.0;
              final barAreaH =
                  (chartH - valLblH - mthLblH - gapH).clamp(16.0, chartH);

              final fillHeights = months.map((m) {
                final val = _metric.valueOf(m);
                return val > 0
                    ? ((val / safeMax) * barAreaH).clamp(4.0, barAreaH)
                    : 4.0;
              }).toList();

              final points = List.generate(months.length, (i) {
                final colW = constraints.maxWidth / months.length;
                final cx = colW * i + colW / 2;
                final topY = chartH - 16 - fillHeights[i];
                return Offset(cx, topY);
              });

              return SizedBox(
                height: chartH,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(constraints.maxWidth, chartH),
                      painter: _TrendLinePainter(
                          points: points, goldColor: context.colors.gold),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(months.length, (i) {
                        final m = months[i];
                        final isActive =
                            m.year == current.year && m.month == current.month;
                        final val = _metric.valueOf(m);
                        final fillH = fillHeights[i];
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
                                                ? context.colors.darkGreen
                                                : context.colors.textHint,
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
                                            ? context.colors.darkGreen
                                            : context.colors.midGreen
                                                .withOpacity(0.5))
                                        : context.colors.pageBg,
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(6)),
                                    border: val > 0
                                        ? null
                                        : Border.all(
                                            color: context.colors.border,
                                            width: 0.5),
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
                                                ? context.colors.darkGreen
                                                : context.colors.textSecondary,
                                            fontWeight: isActive
                                                ? FontWeight.w800
                                                : FontWeight.w500)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            }),
            if (months.length >= 2) ...[
              const SizedBox(height: 12),
              Divider(
                  height: 1, thickness: 0.5, color: context.colors.border),
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
            ? context.colors.textHint
            : (isUp ? context.colors.green : context.colors.red),
      ),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          isSame
              ? 'গত মাসের সমান'
              : '${metric.labelBn} গত মাসের তুলনায় ${isUp ? "বেড়েছে" : "কমেছে"} ${diff.abs().toInt()}${metric == _CompareMetric.completion ? "%" : ""}',
          style: TextStyle(
              color: isSame
                  ? context.colors.textHint
                  : (isUp ? context.colors.green : context.colors.red),
              fontSize: 11,
              fontWeight: FontWeight.w600),
        ),
      ),
    ]);
  }
}

class _TrendLinePainter extends CustomPainter {
  final List<Offset> points;
  final Color goldColor;
  const _TrendLinePainter({required this.points, required this.goldColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final linePaint = Paint()
      ..color = goldColor.withOpacity(0.6)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = goldColor;
    for (final p in points) {
      canvas.drawCircle(p, 2.6, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendLinePainter oldDelegate) => true;
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
              color: context.colors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.colors.border, width: 0.5)),
          child: Row(children: [
            Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: context.colors.greenLight,
                    borderRadius: BorderRadius.circular(14)),
                child: Center(
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text('#$rank',
                                style: TextStyle(
                                    color: context.colors.darkGreen,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900)))))),
            const SizedBox(width: 14),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(rankLabel(),
                      style: TextStyle(
                          color: context.colors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(
                      'সম্পন্ন ${pct.toInt()}% · $farzDays পূর্ণ ফরজ দিন · $jamaat জামাত',
                      style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                          value: pct / 100,
                          minHeight: 5,
                          backgroundColor: context.colors.pageBg,
                          valueColor: AlwaysStoppedAnimation(
                              context.colors.darkGreen))),
                ])),
            if (tracker.isWinner) ...[
              const SizedBox(width: 12),
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: context.colors.goldLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: context.colors.gold.withOpacity(0.3), width: 0.5)),
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
          color: context.colors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border, width: 0.5)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
            children: weekdays
                .map((d) => Expanded(
                    child: Center(
                        child: Text(d,
                            style: TextStyle(
                                color: context.colors.textHint,
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
              cellColor = context.colors.purplePale;
              numColor = context.colors.purple;
            } else if (isFuture) {
              cellColor = context.colors.pageBg;
              numColor = context.colors.textHint;
            } else if (!hasAct) {
              cellColor = context.colors.greenLight.withOpacity(0.4);
              numColor = context.colors.textHint;
            } else if (intensity < 0.25) {
              cellColor = context.colors.green.withOpacity(0.18);
              numColor = context.colors.green;
            } else if (intensity < 0.5) {
              cellColor = context.colors.green.withOpacity(0.38);
              numColor = context.colors.green;
            } else if (intensity < 0.75) {
              cellColor = context.colors.green.withOpacity(0.60);
              numColor = Colors.white;
            } else {
              cellColor = context.colors.green.withOpacity(0.85);
              numColor = Colors.white;
            }

            return Container(
              decoration: BoxDecoration(
                color: cellColor,
                borderRadius: BorderRadius.circular(5),
                border: isToday
                    ? Border.all(color: context.colors.gold, width: 1.5)
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
          Text('কম ',
              style: TextStyle(color: context.colors.textHint, fontSize: 9.5)),
          ...List.generate(
              5,
              (i) => Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(right: 3),
                    decoration: BoxDecoration(
                        color: i == 0
                            ? context.colors.greenLight.withOpacity(0.4)
                            : context.colors.green.withOpacity(0.15 + i * 0.18),
                        borderRadius: BorderRadius.circular(3)),
                  )),
          Text(' বেশি',
              style: TextStyle(color: context.colors.textHint, fontSize: 9.5)),
          if (isFemale) ...[
            const SizedBox(width: 8),
            Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(right: 3),
                decoration: BoxDecoration(
                    color: context.colors.purplePale,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                        color: context.colors.purple.withOpacity(0.3),
                        width: 0.5))),
            Text('মাহলি',
                style: TextStyle(color: context.colors.textHint, fontSize: 9.5)),
          ],
        ]),
      ]),
    );
  }
}

// // ─────────────────────────────────────────────────────────────────────────────
// // DAY ROW — instant sheet open
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

//   void _showDayDetail(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) => _DayDetailContainer(entry: entry, userGender: userGender),
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
//         ? context.colors.purple
//         : congregation >= 3
//             ? context.colors.green
//             : congregation >= 1
//                 ? context.colors.amber2
//                 : context.colors.border;

//     return InkWell(
//       onTap: () => _showDayDetail(context),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
//         decoration: BoxDecoration(
//           color: isExempt
//               ? context.colors.purplePale.withOpacity(0.4)
//               : hasActivity
//                   ? context.colors.greenLight.withOpacity(0.15)
//                   : Colors.transparent,
//           border: isLast
//               ? null
//               : const Border(
//                   bottom: BorderSide(color: context.colors.border, width: 0.5)),
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
//                       colors: [context.colors.purple, Color(0xFF9B6BE8)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight)
//                   : hasActivity
//                       ? const LinearGradient(
//                           colors: [context.colors.darkGreen, context.colors.midGreen],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight)
//                       : null,
//               color: isExempt || hasActivity ? null : context.colors.pageBg,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child:
//                 Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//               Text('${entry.day}',
//                   style: TextStyle(
//                       color: isExempt || hasActivity
//                           ? Colors.white
//                           : context.colors.textHint,
//                       fontWeight: FontWeight.w800,
//                       fontSize: 15,
//                       height: 1)),
//               Text(monthShort(entry.month - 1),
//                   style: TextStyle(
//                       color: isExempt || hasActivity
//                           ? Colors.white.withOpacity(0.6)
//                           : context.colors.textHint,
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
//                                   ? context.colors.purple
//                                   : hasActivity
//                                       ? context.colors.textPrimary
//                                       : context.colors.textSecondary,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 12),
//                           overflow: TextOverflow.ellipsis)),
//                   if (congregation > 0) ...[
//                     const SizedBox(width: 5),
//                     _Pill(
//                         text: '🕌 $congregation জামাত',
//                         bg: context.colors.purpleLight,
//                         fg: context.colors.purple),
//                   ] else if (solo > 0) ...[
//                     const SizedBox(width: 5),
//                     _Pill(
//                         text: '🤲 $solo একাকী',
//                         bg: context.colors.greenLight,
//                         fg: context.colors.green),
//                   ],
//                 ]),
//                 if (missed > 0) ...[
//                   const SizedBox(height: 3),
//                   _Pill(
//                       text: '⚠️ $missed মিস',
//                       bg: context.colors.redLight2,
//                       fg: context.colors.red),
//                 ],
//                 const SizedBox(height: 5),
//                 ClipRRect(
//                     borderRadius: BorderRadius.circular(99),
//                     child: LinearProgressIndicator(
//                         value: progressVal.clamp(0.0, 1.0),
//                         minHeight: 4,
//                         backgroundColor: context.colors.pageBg,
//                         valueColor: AlwaysStoppedAnimation(barColor))),
//               ])),
//           const SizedBox(width: 10),
//           Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
//             if (isExempt)
//               const Text('🌸', style: TextStyle(fontSize: 18))
//             else if (congregation >= 4)
//               const Icon(Icons.star_rounded, color: context.colors.gold, size: 22)
//             else if (congregation >= 1 || solo >= 1)
//               const Icon(Icons.check_circle_rounded,
//                   color: context.colors.green, size: 22)
//             else if (hasActivity)
//               const Icon(Icons.circle_outlined,
//                   color: context.colors.amber2, size: 22)
//             else
//               const Icon(Icons.remove_circle_outline_rounded,
//                   color: context.colors.border, size: 22),
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
//                     color: context.colors.textHint,
//                     fontSize: 8.5,
//                     fontWeight: FontWeight.w500)),
//             const SizedBox(height: 4),
//             const Icon(Icons.chevron_right_rounded,
//                 color: context.colors.textHint, size: 16),
//           ]),
//         ]),
//       ),
//     )
//         .animate(delay: Duration(milliseconds: delay))
//         .fadeIn(duration: 240.ms)
//         .slideX(begin: 0.04, curve: Curves.easeOut);
//   }
// }
class _DayRow extends ConsumerWidget {
  final DailyEntry entry;
  final bool isLast;
  final int delay;
  final String userGender;

  const _DayRow({
    required this.entry,
    required this.isLast,
    required this.delay,
    required this.userGender,
  });

  void _showDayDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _DayDetailContainer(entry: entry, userGender: userGender),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFemale = userGender == 'female';
    final isExempt = entry.isExemptDay && isFemale;
    final entries = entry.entries;

    // মোট অল-ওভার সক্রিয় ক্যাটাগরি সংখ্যা (যেমন: ১৫টি আমল)
    final allCategories = ref.watch(categoriesProvider).valueOrNull ?? [];
    final totalCategoriesCount =
        allCategories.isNotEmpty ? allCategories.length : 10; // সেফ ডিফল্ট ১০

    // ১. সম্পন্ন করা আমল হিসাব
    final congregation =
        entries.where((e) => e.prayerMode == PrayerMode.congregation).length;
    final solo = entries.where((e) => e.prayerMode == PrayerMode.solo).length;
    final missed =
        entries.where((e) => e.prayerMode == PrayerMode.missed).length;

    final otherCompleted = entries
        .where((e) => e.prayerMode == null && (e.completed || e.count > 0))
        .length;

    // মোট কয়টি আমল আজ ইউজার শেষ করেছে
    final totalCompleted = congregation + solo + otherCompleted;
    final hasActivity = entry.hasActivity || totalCompleted > 0;

    // ২. রিয়েল পার্সেন্টেজ হিসাব (মোট সম্পন্ন আমল ÷ অ্যাপের মোট আমল)
    final double completionRate =
        (totalCompleted / totalCategoriesCount).clamp(0.0, 1.0);

    // ৩. নিখুঁত কনসিসটেন্ট স্ট্যাটাস নির্ধারণ
    IconData statusIcon;
    String statusLabel;
    Color statusColor;

    if (isExempt) {
      statusIcon = Icons.spa_rounded;
      statusLabel = 'মাফ';
      statusColor = context.colors.purple;
    } else if (completionRate >= 0.80) {
      // মোট আমলের ৮০%+ করলে তবেই "পূর্ণ"
      statusIcon =
          (congregation >= 4) ? Icons.star_rounded : Icons.check_circle_rounded;
      statusLabel = 'পূর্ণ';
      statusColor = (congregation >= 4) ? context.colors.gold : context.colors.green;
    } else if (completionRate >= 0.35) {
      // ৩৫% থেকে ৭৯% আমল করলে "আংশিক"
      statusIcon = Icons.pie_chart_outline_rounded;
      statusLabel = 'আংশিক';
      statusColor = context.colors.amber2;
    } else if (totalCompleted > 0) {
      // খুব কম (১ বা ২টি) আমল করলে "কিছু"
      statusIcon = Icons.circle_outlined;
      statusLabel = 'কিছু';
      statusColor = context.colors.amber2;
    } else {
      // ০টি আমল
      statusIcon = Icons.remove_circle_outline_rounded;
      statusLabel = 'শূন্য';
      statusColor = context.colors.border;
    }

    String monthShort(int idx) {
      final s = AppConstants.bengaliMonths[idx];
      return s.length >= 3 ? s.substring(0, 3) : s;
    }

    return InkWell(
      onTap: () => _showDayDetail(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: isExempt
              ? context.colors.purplePale.withOpacity(0.4)
              : hasActivity
                  ? context.colors.greenLight.withOpacity(0.15)
                  : Colors.transparent,
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(color: context.colors.border, width: 0.5)),
          borderRadius: isLast
              ? const BorderRadius.vertical(bottom: Radius.circular(16))
              : null,
        ),
        child: Row(
          children: [
            // তারিখ ও মাস
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: isExempt
                    ? LinearGradient(
                        colors: [context.colors.purple, Color(0xFF9B6BE8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)
                    : hasActivity
                        ? LinearGradient(
                            colors: [context.colors.darkGreen, context.colors.midGreen],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight)
                        : null,
                color: isExempt || hasActivity ? null : context.colors.pageBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${entry.day}',
                    style: TextStyle(
                      color: isExempt || hasActivity
                          ? Colors.white
                          : context.colors.textHint,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      height: 1,
                    ),
                  ),
                  Text(
                    monthShort(entry.month - 1),
                    style: TextStyle(
                      color: isExempt || hasActivity
                          ? Colors.white.withOpacity(0.6)
                          : context.colors.textHint,
                      fontSize: 8.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // মূল অংশ
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          isExempt
                              ? 'মাহলির দিন'
                              : hasActivity
                                  ? '$totalCompleted/$totalCategoriesCount টি আমল সম্পন্ন'
                                  : 'কোনো আমল নেই',
                          style: TextStyle(
                            color: isExempt
                                ? context.colors.purple
                                : hasActivity
                                    ? context.colors.textPrimary
                                    : context.colors.textSecondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (congregation > 0) ...[
                        const SizedBox(width: 5),
                        _Pill(
                          text: '🕌 $congregation জামাত',
                          bg: context.colors.purpleLight,
                          fg: context.colors.purple,
                        ),
                      ] else if (solo > 0) ...[
                        const SizedBox(width: 5),
                        _Pill(
                          text: '🤲 $solo একাকী',
                          bg: context.colors.greenLight,
                          fg: context.colors.green,
                        ),
                      ],
                    ],
                  ),
                  if (missed > 0) ...[
                    const SizedBox(height: 3),
                    _Pill(
                      text: '⚠️ $missed মিস',
                      bg: context.colors.redLight2,
                      fg: context.colors.red,
                    ),
                  ],
                  const SizedBox(height: 5),
                  // আসল পার্সেন্টেজ অনুযায়ী প্রোগ্রেস বার
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: completionRate,
                      minHeight: 4,
                      backgroundColor: context.colors.pageBg,
                      valueColor: AlwaysStoppedAnimation(
                        hasActivity ? statusColor : context.colors.border,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // ডানপাশের স্ট্যাটাস আইকন ও টেক্সট
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isExempt)
                  const Text('🌸', style: TextStyle(fontSize: 18))
                else
                  Icon(
                    statusIcon,
                    color: statusColor == context.colors.border
                        ? context.colors.textHint
                        : statusColor,
                    size: 20,
                  ),
                const SizedBox(height: 2),
                Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor == context.colors.border
                        ? context.colors.textHint
                        : statusColor,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.colors.textHint,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
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
// DAY DETAIL CONTAINER (Fixed UX with Header + Close Button)
// ─────────────────────────────────────────────────────────────────────────────

class _DayDetailContainer extends ConsumerWidget {
  final DailyEntry entry;
  final String userGender;

  const _DayDetailContainer({
    required this.entry,
    required this.userGender,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final isFemale = userGender == 'female';
    final isExempt = entry.isExemptDay && isFemale;

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: context.colors.cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // ১. ড্রাইভার বার
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 12),

            // ২. স্থায়ী হেডার (তারিখ, টাইটেল ও ক্লোজ বাটন)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${entry.day} তারিখে যা করেছেন',
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        categoriesAsync.when(
                          data: (categories) {
                            final catMap = {
                              for (final c in categories) c.id: c
                            };
                            final count = entry.entries.where((e) {
                              if (e.prayerMode != null) {
                                return e.prayerMode ==
                                        PrayerMode.congregation ||
                                    e.prayerMode == PrayerMode.solo;
                              }
                              return e.completed || e.count > 0;
                            }).length;
                            return Text(
                              '$count টি আমল সম্পন্ন',
                              style: TextStyle(
                                color: context.colors.textHint,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                          loading: () => Text(
                            'ডেটা লোড হচ্ছে...',
                            style: TextStyle(
                              color: context.colors.textHint,
                              fontSize: 11,
                            ),
                          ),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                  if (isExempt)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: context.colors.purplePale,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text('🌸 মাহলি',
                          style: TextStyle(
                              color: context.colors.purple,
                              fontSize: 10,
                              fontWeight: FontWeight.w700)),
                    ),
                  // ক্লোজ বাটন
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: context.colors.pageBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Divider(height: 1, color: context.colors.border, thickness: 0.5),

            // ৩. বডি অংশ (Shimmer Skeleton অথবা Grouped Amol List)
            Expanded(
              child: categoriesAsync.when(
                loading: () => const _SheetSkeletonLoader(),
                error: (_, __) => _DayDetailSheet(
                  entry: entry,
                  catMap: const {},
                  userGender: userGender,
                  scrollController: scrollController,
                ),
                data: (categories) {
                  final catMap = {for (final c in categories) c.id: c};
                  return _DayDetailSheet(
                    entry: entry,
                    catMap: catMap,
                    userGender: userGender,
                    scrollController: scrollController,
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
// SKELETON LOADER FOR SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _SheetSkeletonLoader extends StatelessWidget {
  const _SheetSkeletonLoader();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const AmolShimmerBox(width: 80, height: 12, radius: 4),
        const SizedBox(height: 10),
        const AmolShimmerBox(height: 50, radius: 12),
        const SizedBox(height: 20),
        const AmolShimmerBox(width: 100, height: 12, radius: 4),
        const SizedBox(height: 10),
        const AmolShimmerBox(height: 90, radius: 12),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DAY DETAIL SHEET — Grouped by orderedSection
// ─────────────────────────────────────────────────────────────────────────────

class _DayDetailSheet extends StatelessWidget {
  final DailyEntry entry;
  final Map<String, AmalCategory> catMap;
  final String userGender;
  final ScrollController scrollController;

  const _DayDetailSheet({
    required this.entry,
    required this.catMap,
    required this.userGender,
    required this.scrollController,
  });

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

    // ১. সফলভাবে সম্পন্ন হওয়া আইটেমগুলো ধরা
    final accomplishedItems = entry.entries.where(_isAccomplished).toList();

    if (accomplishedItems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isExempt ? '🌸' : '📭',
                  style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 8),
              Text(
                isExempt
                    ? 'মাহলির দিন — নামাজ ও রোজা মাফ'
                    : 'এই দিনে কোনো আমল সম্পন্ন হয়নি',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: context.colors.textHint, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    // ২. সম্পন্ন আমলগুলোকে Category-র সাথে ম্যাপ করে Section অনুযায়ী গ্রুপ গঠন করা
    final Map<String, List<MapEntry<AmalCategory, DailyEntryItem>>> groupedMap =
        {};

    for (final e in accomplishedItems) {
      final cat = catMap[e.categoryId] ??
          AmalCategory(
            id: e.categoryId,
            key: '',
            nameBn: 'আমল',
            nameEn: 'Amal',
            section: 'general',
            type: 'daily',
            isPrayer: false,
            isFasting: false,
            isFard: false,
            order: 99,
            isActive: true,
          );

      groupedMap.putIfAbsent(cat.section, () => []).add(MapEntry(cat, e));
    }

    // ৩. Custom Ordered Sections ফিল্টারিং (ক্যাটাগরি লিস্টের সিকোয়েন্সের মত)
    final sections = AmolSectionMeta.orderedSections
        .where((s) => groupedMap.containsKey(s))
        .toList();

    // অন্য কোনো সেকশন ডাটাতে থাকলে সেগুলোকে শেষে রাখা
    for (final key in groupedMap.keys) {
      if (!sections.contains(key)) {
        sections.add(key);
      }
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      itemCount: sections.length,
      itemBuilder: (ctx, index) {
        final sec = sections[index];
        final items = groupedMap[sec]!
          ..sort((a, b) => a.key.order.compareTo(b.key.order));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 6),
              child: Text(
                AmolSectionMeta.label(sec),
                style: TextStyle(
                  color: AmolSectionMeta.color(sec, ctx),
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: context.colors.cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.colors.border, width: 0.6),
              ),
              child: Column(
                children: List.generate(items.length, (i) {
                  final isLastItem = i == items.length - 1;
                  return Container(
                    decoration: BoxDecoration(
                      border: isLastItem
                          ? null
                          : Border(
                              bottom: BorderSide(
                                color: context.colors.border,
                                width: 0.5,
                              ),
                            ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: _DayDetailRow(
                      category: items[i].key,
                      item: items[i].value,
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
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
      statusColor = isCongregation ? context.colors.purple : context.colors.amber2;
      statusIcon = isCongregation ? Icons.people_rounded : Icons.person_rounded;
    } else if (category.inputType == AmalInputType.counter ||
        category.inputType == AmalInputType.duration) {
      final unitBn = AmolUnit.bn(category.unit);
      statusText = '${item.count}${unitBn.isNotEmpty ? " $unitBn" : ""}';
      statusColor = context.colors.green;
      statusIcon = Icons.check_circle_rounded;
    } else {
      statusText = 'সম্পন্ন';
      statusColor = context.colors.green;
      statusIcon = Icons.check_circle_rounded;
    }

    return Row(children: [
      AmolIcon(category: category, size: 34),
      const SizedBox(width: 12),
      Expanded(
        child: Text(category.nameBn,
            style: TextStyle(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 13)),
      ),
      Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(statusIcon, size: 14, color: statusColor),
        const SizedBox(width: 4),
        Text(statusText,
            style: TextStyle(
                color: statusColor, fontWeight: FontWeight.w700, fontSize: 11)),
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
        const SizedBox(height: 22),
        Text('মাস বেছে নিন',
            style: TextStyle(
                color: context.colors.textPrimary,
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
                  color: context.colors.greenLight,
                  borderRadius: BorderRadius.circular(12)),
              child: Text('$_y',
                  style: TextStyle(
                      color: context.colors.darkGreen,
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
                  color: isSelected ? context.colors.darkGreen : context.colors.pageBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: isSelected
                          ? context.colors.darkGreen
                          : isFuture
                              ? context.colors.border.withOpacity(0.4)
                              : context.colors.border,
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
                                            ? context.colors.textHint
                                            : context.colors.textSecondary,
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
          color: enabled ? context.colors.greenLight : context.colors.pageBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: enabled ? context.colors.borderMid : context.colors.border,
              width: 0.5),
        ),
        child: Icon(icon,
            color: enabled ? context.colors.darkGreen : context.colors.textHint,
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
      color: context.colors.darkGreen,
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
            color: context.colors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colors.border, width: 0.5)),
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
