import 'package:amal_tracker/features/leaderboard/providers/leaderboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tracker_provider.dart';
import '../models/tracker_model.dart';
import '../../../core/constants/app_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS — same as home_screen.dart ColorT
// ─────────────────────────────────────────────────────────────────────────────

class _C {
  static const pageBg = Color(0xFFF4F6F1);
  static const cardBg = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const midGreen = Color(0xFF1B7045);
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFFFF3E0);
  static const goldBorder = Color(0xFFFFCC80);
  static const goldPale = Color(0xFFFFFBF0);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const amber = Color(0xFFFF6B35);
  static const amberLight = Color(0xFFFFF3E0);
  static const purple = Color(0xFF7C3AED);
  static const purpleLight = Color(0xFFEDE9FE);
  static const red = Color(0xFFEF4444);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
  static const border = Color(0xFFE4EAE4);
  static const borderMid = Color(0xFFD0DAD2);
  static const goldLight2 = Color(0xFFFFF8E7); // for ⭐ card
  static const darkGreenLight =
      Color(0xFFE8F0EC); // for 🎯 card (lighter version of darkGreen)
  static const redLight = Color(0xFFFEE2E2);
}

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

  Future<void> _refreshTracker() async {
    final f = ref.read(leaderboardFilterProvider);
    // Invalidate both providers to force refresh
    ref.invalidate(monthlyTrackerProvider((year: f.year, month: f.month)));
    await Future.microtask(() {
      ref.refresh(monthlyTrackerProvider((year: f.year, month: f.month)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final params = (year: _year, month: _month);
    final entriesAsync = ref.watch(monthlyEntriesProvider(params));
    final trackerAsync = ref.watch(monthlyTrackerProvider(params));
    final monthName = AppConstants.bengaliMonths[_month - 1];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          SystemUiOverlayStyle.light, // dark → light (dark green bar-এর জন্য)
      child: Scaffold(
        backgroundColor: _C.pageBg,
        // appBar সরিয়ে দাও — এখন SliverAppBar ব্যবহার হবে
        body: RefreshIndicator(
          color: _C.darkGreen,
          onRefresh: () async {
            ref.invalidate(monthlyEntriesProvider(params));
            ref.invalidate(monthlyTrackerProvider(params));
          },
          child: CustomScrollView(
            controller: _sc,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ── Zone 1: STICKY APP BAR ───────────────────────────────────
              SliverAppBar(
                pinned: true,
                floating: false,
                snap: false,
                expandedHeight: 0,
                toolbarHeight: 56,
                backgroundColor: _C.darkGreen,
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
                automaticallyImplyLeading: false,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                title: Row(
                  children: [
                    // Icon badge
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 0.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'মাসিক রিপোর্ট',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.55),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '$monthName $_year',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.swap_horiz_rounded,
                            size: 13,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'মাস বদলান',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ── Zone 2: HERO BAND (scrolls away) ─────────────────────────
              SliverToBoxAdapter(
                child: trackerAsync
                    .when(
                      loading: () => const _HeroBandSkeleton(),
                      error: (error, stackTrace) => _HeroBandErrorCard(
                        message: error.toString(),
                        onRetry: () => _refreshTracker(),
                      ),
                      data: (t) => _HeroBand(
                        year: _year,
                        month: _month,
                        tracker: t,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 280.ms),
              ),

              // ── Zone 3: STAT STRIP (scrolls with content) ─────────────────
              // SliverToBoxAdapter(
              //   child: trackerAsync
              //       .when(
              //         loading: () => const _StatStripSkeleton(),
              //         error: (_, __) => const _StatStrip(tracker: null),
              //         data: (t) => _StatStrip(
              //           tracker: t,
              //           entries: entriesAsync.valueOrNull,
              //         ),
              //       )
              //       .animate()
              //       .fadeIn(delay: 60.ms, duration: 260.ms),
              // ),
              SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, ref, _) {
                    final trackerAsync =
                        ref.watch(monthlyTrackerProvider(params));
                    final entriesAsync =
                        ref.watch(monthlyEntriesProvider(params));

                    return trackerAsync.when(
                      loading: () => const _StatStripSkeleton(),
                      error: (_, __) =>
                          const _StatStrip(tracker: null, entries: null),
                      data: (tracker) => _StatStrip(
                        tracker: tracker,
                        entries: entriesAsync.valueOrNull,
                      ),
                    );
                  },
                ),
              ),

              // ── Zone 4: CALENDAR + DAY LIST ───────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: entriesAsync.when(
                  loading: () => SliverToBoxAdapter(
                    child: _EntriesSkeleton()
                        .animate()
                        .fadeIn(delay: 80.ms, duration: 260.ms),
                  ),
                  error: (_, __) => SliverToBoxAdapter(
                    child: _ErrorCard(
                      onRetry: () {
                        ref.invalidate(monthlyEntriesProvider(params));
                      },
                    ).animate().fadeIn(duration: 260.ms),
                  ),
                  data: (entries) => SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 15),
                      _SectionHeader(title: 'দৈনিক ক্যালেন্ডার', emoji: '📅')
                          .animate()
                          .fadeIn(delay: 100.ms),
                      const SizedBox(height: 10),
                      _HeatmapCalendar(
                        year: _year,
                        month: _month,
                        entries: entries,
                      ).animate().fadeIn(delay: 120.ms, duration: 300.ms),
                      const SizedBox(height: 22),
                      _SectionHeader(title: 'দিন অনুযায়ী পয়েন্ট', emoji: '📋')
                          .animate()
                          .fadeIn(delay: 150.ms),
                      const SizedBox(height: 10),
                      if (entries.isEmpty)
                        _EmptyCard(
                          label:
                              '${AppConstants.bengaliMonths[_month - 1]} মাসে কোনো আমল নেই',
                        ).animate().fadeIn(delay: 160.ms)
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: _C.cardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _C.border, width: 0.5),
                          ),
                          child: Column(
                            children: List.generate(entries.length, (i) {
                              final e = entries[i];
                              final isLast = i == entries.length - 1;
                              return _DayRow(
                                entry: e,
                                isLast: isLast,
                                delay: 160 + i * 30,
                              );
                            }),
                          ),
                        ).animate().fadeIn(delay: 160.ms, duration: 280.ms),
                    ]),
                  ),
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
// STICKY TOP BAR  (PreferredSizeWidget, same as home_screen.dart _TopBar)
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget implements PreferredSizeWidget {
  final int year, month;
  final VoidCallback onBack;
  final VoidCallback onChangePeriod;

  const _TopBar({
    required this.year,
    required this.month,
    required this.onBack,
    required this.onChangePeriod,
  });

  @override
  Size get preferredSize => const Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    final monthName = AppConstants.bengaliMonths[month - 1];

    return Container(
      color: _C.cardBg,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 62,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: _C.cardBg,
            border: Border(bottom: BorderSide(color: _C.border, width: 0.5)),
          ),
          child: Row(
            children: [
              // Back button
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _C.pageBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _C.border, width: 0.5),
                ),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  color: _C.darkGreen,
                  size: 16,
                ),
              ),

              const SizedBox(width: 12),

              // Title block
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'মাসিক রিপোর্ট',
                      style: TextStyle(
                        color: _C.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$monthName $year',
                      style: const TextStyle(
                        color: _C.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        letterSpacing: -0.3,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              // Month switcher button
              GestureDetector(
                onTap: onChangePeriod,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                  decoration: BoxDecoration(
                    color: _C.greenLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _C.border, width: 0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.swap_horiz_rounded,
                        color: _C.darkGreen,
                        size: 15,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'মাস বদলান',
                        style: TextStyle(
                          color: _C.darkGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
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
// HERO BAND  (dark-green, scrolls with content)
// ─────────────────────────────────────────────────────────────────────────────
class _HeroBand extends StatelessWidget {
  final int year, month;
  final MonthlyTracker? tracker;

  const _HeroBand({
    required this.year,
    required this.month,
    required this.tracker,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 380;
    final isTablet = screenWidth >= 600;

    final totalPts = tracker?.totalPoints ?? 0;
    final pct = (tracker?.completionPercentage ?? 0).clamp(0.0, 100.0);
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final daysCompleted = tracker?.daysCompleted ?? 0;
    final isWinner = tracker?.isWinner ?? false;
    final winnerCat = tracker?.winnerCategory;

    return Container(
      color: _C.darkGreen,
      child: Stack(
        children: [
          // Decorative circles - responsive positioning
          Positioned(
            top: -45,
            right: isSmallScreen ? -30 : -45,
            child: Container(
              width: isSmallScreen ? 100 : 140,
              height: isSmallScreen ? 100 : 140,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x0AFFFFFF),
              ),
            ),
          ),
          Positioned(
            bottom: -25,
            left: isSmallScreen ? 10 : 18,
            child: Container(
              width: isSmallScreen ? 60 : 88,
              height: isSmallScreen ? 60 : 88,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x07FFFFFF),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(
                16, isSmallScreen ? 12 : 16, 16, isSmallScreen ? 16 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag pill
                Text(
                  'মাসের আমলের সারসংক্ষেপ',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: isSmallScreen ? 10 : 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),

                // Progress summary card
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
                  decoration: BoxDecoration(
                    color: const Color(0x17FFFFFF),
                    borderRadius: BorderRadius.circular(14),
                    border:
                        Border.all(color: const Color(0x2EFFFFFF), width: 0.5),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Responsive layout based on available width
                      if (constraints.maxWidth < 400) {
                        return _buildCompactLayout(
                          pct: pct,
                          totalPts: totalPts,
                          daysCompleted: daysCompleted,
                          daysInMonth: daysInMonth,
                          isWinner: isWinner,
                          winnerCat: winnerCat,
                          isSmallScreen: isSmallScreen,
                        );
                      } else {
                        return _buildNormalLayout(
                          pct: pct,
                          totalPts: totalPts,
                          daysCompleted: daysCompleted,
                          daysInMonth: daysInMonth,
                          isWinner: isWinner,
                          winnerCat: winnerCat,
                          isSmallScreen: isSmallScreen,
                          isTablet: isTablet,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalLayout({
    required double pct,
    required int totalPts,
    required int daysCompleted,
    required int daysInMonth,
    required bool isWinner,
    required String? winnerCat,
    required bool isSmallScreen,
    required bool isTablet,
  }) {
    return Row(
      children: [
        // Circular progress ring
        _CircularProgressWidget(percentage: pct, size: isTablet ? 70 : 56),

        SizedBox(width: isSmallScreen ? 10 : 14),

        // Points block
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatNumber(totalPts),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: isTablet ? 32 : (isSmallScreen ? 22 : 26),
                  letterSpacing: -0.5,
                  height: 1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'মোট পয়েন্ট',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: isSmallScreen ? 9 : 10,
                ),
              ),
              if (isWinner) ...[
                const SizedBox(height: 6),
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _C.gold,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🏆', style: TextStyle(fontSize: 10)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            winnerCat ?? 'মাসিক বিজয়ী',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        SizedBox(width: isSmallScreen ? 8 : 10),

        // Days completed
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$daysCompleted/$daysInMonth',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: isTablet ? 22 : (isSmallScreen ? 16 : 18),
                letterSpacing: -0.4,
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'সম্পন্ন দিন',
              style: TextStyle(
                color: Colors.white.withOpacity(0.45),
                fontSize: isSmallScreen ? 9 : 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompactLayout({
    required double pct,
    required int totalPts,
    required int daysCompleted,
    required int daysInMonth,
    required bool isWinner,
    required String? winnerCat,
    required bool isSmallScreen,
  }) {
    return Column(
      children: [
        // Top row with progress and points
        Row(
          children: [
            // Circular progress ring
            _CircularProgressWidget(percentage: pct, size: 50),

            const SizedBox(width: 12),

            // Points block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatNumber(totalPts),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      letterSpacing: -0.5,
                      height: 1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'মোট পয়েন্ট',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),

            // Days completed
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$daysCompleted/$daysInMonth',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    letterSpacing: -0.4,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'সম্পন্ন দিন',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.45),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Winner badge in a new row for compact layout
        if (isWinner) ...[
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _C.gold,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🏆', style: TextStyle(fontSize: 10)),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      winnerCat ?? 'মাসিক বিজয়ী',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

// Separate widget for circular progress to keep code clean
class _CircularProgressWidget extends StatelessWidget {
  final double percentage;
  final double size;

  const _CircularProgressWidget({
    required this.percentage,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final percentageStr = '${percentage.toInt()}%';
    final digitCount = percentageStr.length;

    // Adjust font size based on number of digits and container size
    double fontSize;
    if (size <= 50) {
      fontSize = digitCount == 3 ? 9 : (digitCount == 2 ? 11 : 12);
    } else if (size <= 56) {
      fontSize = digitCount == 3 ? 10 : (digitCount == 2 ? 12 : 14);
    } else {
      fontSize = digitCount == 3 ? 12 : (digitCount == 2 ? 14 : 16);
    }

    final innerSize = size - (size * 0.18); // Inner circle size (82% of outer)

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Progress circle
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.white.withOpacity(0.12),
              valueColor: const AlwaysStoppedAnimation(_C.gold),
              strokeWidth: size * 0.09, // Responsive stroke width
              strokeCap: StrokeCap.round,
            ),
          ),
          // Inner circle mask to prevent overlap
          Container(
            width: innerSize,
            height: innerSize,
            decoration: BoxDecoration(
              color: _C.darkGreen,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: EdgeInsets.all(size * 0.05),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        percentageStr,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: fontSize,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: size * 0.02),
                      Text(
                        'সম্পন্ন',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.45),
                          fontSize: size * 0.13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBandSkeleton extends StatelessWidget {
  const _HeroBandSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _C.darkGreen,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tag pill skeleton with shimmer
            Container(
              width: 120,
              height: 11,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            // Main card skeleton
            Container(
              height: 92,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  // Left side skeleton
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        // Circle progress placeholder
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Text placeholders
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 20,
                              color: Colors.white.withOpacity(0.05),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 80,
                              height: 10,
                              color: Colors.white.withOpacity(0.03),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate(onPlay: (c) => c.repeat()).shimmer(
              duration: 1200.ms,
              colors: [
                Colors.white.withOpacity(0.02),
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.02),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// HeroBand Error Card - matches the error style from your app
class _HeroBandErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _HeroBandErrorCard({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _C.darkGreen,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'মাসের আমলের সারসংক্ষেপ',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.09),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.18),
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  // Error icon in circle
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _C.red.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'লোড করতে পারেনি',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message.length > 40
                              ? '${message.substring(0, 40)}...'
                              : message,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 10,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: onRetry,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 0.5,
                              ),
                            ),
                            child: const Text(
                              'পুনরায় চেষ্টা করুন →',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STAT STRIP  (3 cards — streak, weekly, prayer)
// ─────────────────────────────────────────────────────────────────────────────

class _StatStrip extends StatelessWidget {
  final MonthlyTracker? tracker;
  final List<DailyEntry>? entries;
  const _StatStrip({this.tracker, this.entries});

  int _getTotalAmalCount() {
    if (entries == null) return 0;
    int totalAmals = 0;
    for (var day in entries!) {
      for (var item in day.entries) {
        // Count ALL completed items (both prayer and non-prayer)
        if (item.completed) {
          totalAmals++;
        }
      }
    }
    return totalAmals;
  }

  @override
  Widget build(BuildContext context) {
    final streak = tracker?.streakDays ?? 0;
    final weekly = tracker?.weeklyPoints ?? 0;
    final totalAmals = _getTotalAmalCount();
    // weeklyPrayer if available, else 0

    // replace with tracker?.prayerPoints if model has it

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              emoji: '🔥',
              emojiBgColor: _C.amberLight,
              value: '$streak',
              label: 'স্ট্রিক দিন',
              valueColor: _C.amber,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatCard(
              emoji: '📿',
              emojiBgColor: _C.greenLight,
              value: '$weekly',
              label: 'সাপ্তাহিক',
              valueColor: _C.green,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatCard(
              emoji: '⭐', // Changed from 🕌
              emojiBgColor: _C.goldLight2,
              value: '$totalAmals',
              label: 'মোট আমল',
              valueColor: _C.gold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color emojiBgColor;
  final Color valueColor;

  const _StatCard({
    required this.emoji,
    required this.emojiBgColor,
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: emojiBgColor, // ✅ Now using the Color directly
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 14)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.w800,
              fontSize: 20,
              letterSpacing: -0.4,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: _C.textSecondary,
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// class _StatStrip extends StatelessWidget {
//   final MonthlyTracker? tracker;
//   const _StatStrip({this.tracker});

//   @override
//   Widget build(BuildContext context) {
//     final streak = tracker?.streakDays ?? 0;
//     final weekly = tracker?.weeklyPoints ?? 0;
//     // weeklyPrayer if available, else 0
//     final prayer = 0; // replace with tracker?.prayerPoints if model has it

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//       child: Row(
//         children: [
//           Expanded(
//             child: _StatCard(
//               emoji: '🔥',
//               emojiBg: _C.amberLight,
//               value: '$streak',
//               label: 'স্ট্রিক দিন',
//               valueColor: _C.amber,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: _StatCard(
//               emoji: '📿',
//               emojiBg: _C.greenLight,
//               value: '$weekly',
//               label: 'সাপ্তাহিক',
//               valueColor: _C.green,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: _StatCard(
//               emoji: '🕌',
//               emojiBg: _C.purpleLight,
//               value: '$prayer',
//               label: 'নামাজ pts',
//               valueColor: _C.purple,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _StatCard extends StatelessWidget {
//   final String emoji, emojiBg, value, label;
//   final Color emojiBgColor, valueColor;

//   const _StatCard({
//     required this.emoji,
//     required this.emojiBgColor, // Change to Color type
//     required this.value,
//     required this.label,
//     required this.valueColor,
//   });

//   // const _StatCard({
//   //   required this.emoji,
//   //   required this.emojiBgColor,
//   //   required this.value,
//   //   required this.label,
//   //   required this.valueColor,
//   // })  : emojiBgColor = const Color(0xFFE8F5EE), // unused, see below
//   //       super();

//   // Re-declare properly
//   // const _StatCard._({
//   //   required this.emoji,
//   //   required this.emojiBgColor,
//   //   required this.value,
//   //   required this.label,
//   //   required this.valueColor,
//   //   String emojiBg = '',
//   //   String label2 = '',
//   // });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: _C.cardBg,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 30,
//             height: 30,
//             decoration: BoxDecoration(
//               color: emojiBgColor,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Center(
//               child: Text(emoji, style: const TextStyle(fontSize: 14)),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               color: valueColor,
//               fontWeight: FontWeight.w800,
//               fontSize: 20,
//               letterSpacing: -0.4,
//               height: 1,
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             label,
//             style: const TextStyle(
//               color: _C.textSecondary,
//               fontSize: 9.5,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Fix: proper _StatCard with named emojiBg color parameter
// Re-written cleanly below as a standalone widget used by _StatStrip

class _SC extends StatelessWidget {
  final String emoji;
  final Color emojiBg;
  final String value, label;
  final Color valueColor;

  const _SC({
    required this.emoji,
    required this.emojiBg,
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: emojiBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 14)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.w800,
              fontSize: 20,
              letterSpacing: -0.4,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: _C.textSecondary,
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatStripSkeleton extends StatelessWidget {
  const _StatStripSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: List.generate(3, (i) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(left: i == 0 ? 0 : 8),
              height: 86,
              decoration: BoxDecoration(
                color: _C.cardBg,
                borderRadius: BorderRadius.circular(14),
              ),
            ).animate(onPlay: (c) => c.repeat()).shimmer(
              duration: 1200.ms,
              delay: Duration(milliseconds: i * 60),
              colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg],
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION HEADER  (same as home_screen.dart)
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title, emoji;

  const _SectionHeader({required this.title, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 7),
        Text(
          title,
          style: const TextStyle(
            color: _C.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 15,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HEATMAP CALENDAR
// ─────────────────────────────────────────────────────────────────────────────

class _HeatmapCalendar extends StatelessWidget {
  final int year, month;
  final List<DailyEntry> entries;

  const _HeatmapCalendar({
    required this.year,
    required this.month,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final entryMap = {for (final e in entries) e.day: e};
    final maxPts = entries.isEmpty
        ? 1
        : entries
            .map((e) => e.totalPoints)
            .reduce((a, b) => a > b ? a : b)
            .clamp(1, 9999);
    final today = DateTime.now();
    final firstDay = DateTime(year, month, 1).weekday % 7;
    final totalCells = ((firstDay + daysInMonth) / 7).ceil() * 7;

    const weekdays = ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহঃ', 'শুক্র', 'শনি'];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weekday labels
          Row(
            children: weekdays
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: const TextStyle(
                          color: _C.textHint,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 6),

          // Day grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              childAspectRatio: 1.1,
            ),
            itemCount: totalCells,
            itemBuilder: (ctx, index) {
              final dayNum = index - firstDay + 1;

              if (dayNum < 1 || dayNum > daysInMonth) {
                return const SizedBox.shrink();
              }

              final pts = entryMap[dayNum]?.totalPoints ?? 0;
              final intensity = pts / maxPts;
              final isToday = today.year == year &&
                  today.month == month &&
                  today.day == dayNum;
              final isFuture = DateTime(year, month, dayNum).isAfter(today);

              // Colour based on intensity
              Color cellColor;
              Color numColor;
              if (isFuture) {
                cellColor = _C.pageBg;
                numColor = _C.textHint;
              } else if (pts == 0) {
                cellColor = _C.greenLight.withOpacity(0.5);
                numColor = _C.textHint;
              } else if (intensity < 0.25) {
                cellColor = _C.green.withOpacity(0.18);
                numColor = _C.green;
              } else if (intensity < 0.5) {
                cellColor = _C.green.withOpacity(0.38);
                numColor = _C.green;
              } else if (intensity < 0.75) {
                cellColor = _C.green.withOpacity(0.60);
                numColor = Colors.white;
              } else {
                cellColor = _C.green.withOpacity(0.85);
                numColor = Colors.white;
              }

              return Container(
                decoration: BoxDecoration(
                  color: cellColor,
                  borderRadius: BorderRadius.circular(5),
                  border:
                      isToday ? Border.all(color: _C.gold, width: 1.5) : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$dayNum',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: numColor,
                        height: 1,
                      ),
                    ),
                    if (pts > 0 && !isFuture) ...[
                      Text(
                        '$pts',
                        style: TextStyle(
                          fontSize: 7.5,
                          color: numColor.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                      ),
                    ],
                  ],
                ),
              ).animate(delay: Duration(milliseconds: dayNum * 8)).scale(
                    begin: const Offset(0.7, 0.7),
                    duration: 200.ms,
                    curve: Curves.easeOut,
                  );
            },
          ),

          const SizedBox(height: 10),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'কম  ',
                style: TextStyle(color: _C.textHint, fontSize: 9.5),
              ),
              ...List.generate(5, (i) {
                return Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    color: i == 0
                        ? _C.greenLight
                        : _C.green.withOpacity(0.15 + i * 0.18),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
              const Text(
                '  বেশি',
                style: TextStyle(color: _C.textHint, fontSize: 9.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DAY ROW  (inside grouped card, same divider pattern as _MonthList in home)
// ─────────────────────────────────────────────────────────────────────────────

class _DayRow extends StatelessWidget {
  final DailyEntry entry;
  final bool isLast;
  final int delay;

  const _DayRow({
    required this.entry,
    required this.isLast,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final completedCount = entry.entries.where((e) => e.completed).length;
    final prayerCount = entry.entries
        .where((e) =>
            e.completed &&
            e.prayerMode != null &&
            e.prayerMode != PrayerMode.missed)
        .length;
    final hasPoints = entry.totalPoints > 0;

    // Progress bar colour
    final barColor = completedCount > 15
        ? _C.green
        : completedCount > 8
            ? _C.amber
            : _C.darkGreen;

    String getMonthShortName(int monthIndex) {
      final fullMonthName = AppConstants.bengaliMonths[monthIndex];
      if (fullMonthName.length >= 3) {
        return fullMonthName.substring(0, 3);
      } else {
        return fullMonthName; // Return full name if shorter than 3 chars
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: hasPoints ? _C.greenLight.withOpacity(0.18) : Colors.transparent,
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: _C.border, width: 0.5),
              ),
        borderRadius: isLast
            ? const BorderRadius.vertical(bottom: Radius.circular(16))
            : null,
      ),
      child: Row(
        children: [
          // Day number box
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: hasPoints
                  ? const LinearGradient(
                      colors: [_C.darkGreen, _C.midGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: hasPoints ? null : _C.pageBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${entry.day}',
                  style: TextStyle(
                    color: hasPoints ? Colors.white : _C.textHint,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    height: 1,
                  ),
                ),
                Text(
                  // ✅ Fixed: Use safe getMonthShortName function
                  getMonthShortName(entry.month - 1),
                  style: TextStyle(
                    color:
                        hasPoints ? Colors.white.withOpacity(0.6) : _C.textHint,
                    fontSize: 8.5,
                  ),
                ),
                // Text(
                //   AppConstants.bengaliMonths[entry.month - 1].substring(0, 3),
                //   style: TextStyle(
                //     color:
                //         hasPoints ? Colors.white.withOpacity(0.6) : _C.textHint,
                //     fontSize: 8.5,
                //   ),
                // ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Info block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$completedCount টি আমল',
                      style: TextStyle(
                        color: hasPoints ? _C.textPrimary : _C.textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    if (prayerCount > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: _C.greenLight,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          '🕌 $prayerCount নামাজ',
                          style: const TextStyle(
                            color: _C.green,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: (completedCount / 20).clamp(0.0, 1.0),
                    minHeight: 4,
                    backgroundColor: _C.pageBg,
                    valueColor: AlwaysStoppedAnimation(
                        hasPoints ? barColor : _C.border),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Points
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.totalPoints}',
                style: TextStyle(
                  color: hasPoints ? _C.darkGreen : _C.textHint,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  height: 1,
                ),
              ),
              Text(
                'pts',
                style: TextStyle(
                  color: hasPoints ? _C.textSecondary : _C.textHint,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 240.ms)
        .slideX(begin: 0.04, curve: Curves.easeOut);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PERIOD PICKER SHEET  (same handle + card style as home ProfileSheet)
// ─────────────────────────────────────────────────────────────────────────────

class _PeriodPickerSheet extends StatefulWidget {
  final int year, month;
  final void Function(int, int) onPicked;

  const _PeriodPickerSheet({
    required this.year,
    required this.month,
    required this.onPicked,
  });

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
        color: _C.cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: _C.border,
              borderRadius: BorderRadius.circular(99),
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'মাস বেছে নিন',
            style: TextStyle(
              color: _C.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 18),

          // Year selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _YearArrow(
                icon: Icons.chevron_left_rounded,
                onTap: () => setState(() => _y--),
                enabled: true,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: _C.greenLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_y',
                  style: const TextStyle(
                    color: _C.darkGreen,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
              _YearArrow(
                icon: Icons.chevron_right_rounded,
                onTap: _y < now.year ? () => setState(() => _y++) : null,
                enabled: _y < now.year,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Month grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.75,
            ),
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
                    color: isSelected
                        ? _C.darkGreen
                        : isFuture
                            ? _C.pageBg
                            : _C.pageBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? _C.darkGreen
                          : isFuture
                              ? _C.border.withOpacity(0.4)
                              : _C.border,
                      width: 0.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      AppConstants.bengaliMonths[i],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : isFuture
                                ? _C.textHint
                                : _C.textSecondary,
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _YearArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;

  const _YearArrow({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: enabled ? _C.greenLight : _C.pageBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled ? _C.borderMid : _C.border,
            width: 0.5,
          ),
        ),
        child: Icon(
          icon,
          color: enabled ? _C.darkGreen : _C.textHint,
          size: 20,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SKELETONS  (same shimmer pattern as home_screen.dart)
// ─────────────────────────────────────────────────────────────────────────────

class _EntriesSkeleton extends StatelessWidget {
  const _EntriesSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),
        // Section label
        _shimmerBar(width: 130, height: 14),
        const SizedBox(height: 12),
        // Calendar
        _shimmerBox(height: 240),
        const SizedBox(height: 22),
        // Section label
        _shimmerBar(width: 150, height: 14),
        const SizedBox(height: 12),
        // List
        Container(
          decoration: BoxDecoration(
            color: _C.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _C.border, width: 0.5),
          ),
          child: Column(
            children: List.generate(5, (i) {
              final isLast = i == 4;
              return Container(
                height: 64,
                margin: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                decoration: BoxDecoration(
                  color: _C.pageBg,
                  borderRadius: BorderRadius.circular(10),
                  border: isLast
                      ? null
                      : const Border(
                          bottom: BorderSide(color: _C.border, width: 0.5),
                        ),
                ),
              ).animate(onPlay: (c) => c.repeat()).shimmer(
                duration: 1200.ms,
                delay: Duration(milliseconds: i * 70),
                colors: [_C.pageBg, const Color(0xFFE8ECE8), _C.pageBg],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _shimmerBar({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(8),
      ),
    ).animate(onPlay: (c) => c.repeat()).shimmer(
      duration: 1200.ms,
      colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg],
    );
  }

  Widget _shimmerBox({required double height}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 0.5),
      ),
    ).animate(onPlay: (c) => c.repeat()).shimmer(
      duration: 1200.ms,
      colors: [_C.cardBg, const Color(0xFFE8ECE8), _C.cardBg],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ERROR + EMPTY CARDS
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorCard extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorCard({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 0.5),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFEF4444),
            size: 30,
          ),
          const SizedBox(height: 8),
          const Text(
            'ডেটা লোড ব্যর্থ হয়েছে',
            style: TextStyle(
              color: _C.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              decoration: BoxDecoration(
                color: _C.greenLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'পুনরায় চেষ্টা করুন',
                style: TextStyle(
                  color: _C.darkGreen,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String label;
  const _EmptyCard({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 0.5),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📭', style: TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _C.textHint,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
