import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../auth/providers/auth_provider.dart';
import '../../tracker/providers/tracker_provider.dart';
import '../../tracker/models/tracker_model.dart';
import '../../leaderboard/providers/leaderboard_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../core/constants/app_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HomeScreen
// ─────────────────────────────────────────────────────────────────────────────

class HomeScreenFinal extends ConsumerStatefulWidget {
  const HomeScreenFinal({super.key});

  @override
  ConsumerState<HomeScreenFinal> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreenFinal> {
  final _scrollController = ScrollController();
  bool _showStickyHeader = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      ref.read(leaderboardProvider.notifier).load(
            LeaderboardFilter(year: now.year, month: now.month, limit: 5),
          );
    });
  }

  void _onScroll() {
    final show = _scrollController.offset > 80;
    if (show != _showStickyHeader) {
      setState(() => _showStickyHeader = show);
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(progressSummaryProvider);
    final now = DateTime.now();
    await ref.read(leaderboardProvider.notifier).load(
          LeaderboardFilter(year: now.year, month: now.month, limit: 5),
          refresh: true,
        );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final progress = ref.watch(progressSummaryProvider);
    final board = ref.watch(leaderboardProvider);
    final mq = MediaQuery.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBodyBehindAppBar: true,

        // Sticky compact AppBar — shows only after user scrolls
        appBar: _showStickyHeader
            ? AppBar(
                backgroundColor: AppColors.primaryDark,
                elevation: 0,
                toolbarHeight: 56,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                title: _StickyTitle(
                  user: user,
                  onAvatarTap: () => _showProfileSheet(context, user),
                ),
              )
            : null,

        body: RefreshIndicator(
          color: AppColors.primary,
          displacement: mq.padding.top + 100,
          onRefresh: _refresh,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ── Hero Header ─────────────────────────────────
              SliverToBoxAdapter(
                child: _HeroHeader(
                  user: user,
                  date: DateTime.now(),
                  onAvatarTap: () => _showProfileSheet(context, user),
                ),
              ),

              // ── Page Body ───────────────────────────────────
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, mq.padding.bottom + 28),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Today Hero Card
                    progress
                        .when(
                          loading: () => const _Skeleton(height: 200),
                          error: (_, __) => const SizedBox.shrink(),
                          data: (s) => _TodayHeroCard(
                            summary: s,
                            onTrack: () => context.go(AppRoutes.tracker),
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 60.ms)
                        .slideY(begin: 0.05, curve: Curves.easeOut),

                    const SizedBox(height: 14),

                    // Stats 3-card row
                    progress
                        .when(
                          loading: () => const _StatsRowSkeleton(),
                          error: (_, __) => const SizedBox.shrink(),
                          data: (s) => _StatsRow(summary: s),
                        )
                        .animate()
                        .fadeIn(delay: 120.ms),

                    const SizedBox(height: 26),

                    // Monthly progress
                    _SectionHeader(
                      title: 'মাসিক অগ্রগতি',
                      action: 'সব দেখুন',
                      onAction: () => context.go(AppRoutes.monthlyView),
                    ),

                    const SizedBox(height: 12),

                    progress
                        .when(
                          loading: () => const _ListSkeleton(count: 3),
                          error: (_, __) => const SizedBox.shrink(),
                          data: (s) => s.recentMonths.isEmpty
                              ? const _EmptyState(
                                  icon: Icons.bar_chart_rounded,
                                  label: 'এখনো কোনো তথ্য নেই',
                                )
                              : _MonthlyList(trackers: s.recentMonths),
                        )
                        .animate()
                        .fadeIn(delay: 190.ms),

                    const SizedBox(height: 26),

                    // Leaderboard
                    _SectionHeader(
                      title: 'এই মাসের শীর্ষ',
                      action: 'সব দেখুন',
                      onAction: () => context.go(AppRoutes.leaderboard),
                    ),

                    const SizedBox(height: 12),

                    (board.isLoading
                            ? const _ListSkeleton(count: 3)
                            : board.entries.isEmpty
                                ? const _EmptyState(
                                    icon: Icons.emoji_events_rounded,
                                    label: 'কোনো তথ্য পাওয়া যায়নি',
                                  )
                                : _LeaderboardList(
                                    entries: board.entries.take(5).toList()))
                        .animate()
                        .fadeIn(delay: 250.ms),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProfileSheet(BuildContext ctx, dynamic user) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ProfileSheet(user: user, ref: ref),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sticky AppBar Title
// ─────────────────────────────────────────────────────────────────────────────

class _StickyTitle extends StatelessWidget {
  final dynamic user;
  final VoidCallback onAvatarTap;
  const _StickyTitle({this.user, required this.onAvatarTap});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user?.name?.split(' ').first ?? 'বন্ধু',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    height: 1.1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'আস-সালামু আলাইকুম 🌙',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          _Avatar(user: user, size: 36, onTap: onAvatarTap),
        ],
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero Header
// ─────────────────────────────────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  final dynamic user;
  final DateTime date;
  final VoidCallback onAvatarTap;
  const _HeroHeader({this.user, required this.date, required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    final month = AppConstants.bengaliMonths[date.month - 1];
    final h = date.hour;
    final timeGreeting = h < 12
        ? 'সুপ্রভাত'
        : h < 17
            ? 'শুভ দুপুর'
            : 'শুভ সন্ধ্যা';

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.brandGradient),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -50,
            right: -50,
            child: _Circle(size: 180, opacity: 0.05),
          ),
          Positioned(
            top: 30,
            right: 70,
            child: _Circle(size: 55, opacity: 0.07),
          ),
          Positioned(
            bottom: -40,
            left: -30,
            child: _Circle(size: 120, opacity: 0.04),
          ),

          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Greeting pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 11, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.13),
                            borderRadius: AppRadius.full,
                            border: Border.all(
                                color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🌙', style: TextStyle(fontSize: 13)),
                              const SizedBox(width: 6),
                              Text(
                                '$timeGreeting  •  আস-সালামু আলাইকুম',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.88),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Name
                        Text(
                          user?.name?.split(' ').first ?? 'বন্ধু',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 30,
                            height: 1.1,
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 5),

                        // Date
                        Text(
                          '${date.day} $month, ${date.year}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.55),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  _Avatar(
                      user: user, size: 54, onTap: onAvatarTap, fontSize: 22),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  final double size, opacity;
  const _Circle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(opacity),
        ),
      );
}

class _Avatar extends StatelessWidget {
  final dynamic user;
  final double size;
  final double fontSize;
  final VoidCallback onTap;
  const _Avatar({
    this.user,
    required this.size,
    this.fontSize = 18,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFD4A843), Color(0xFFF0C96B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: AppRadius.lg_,
            boxShadow: shadowGold(),
          ),
          child: Center(
            child: Text(
              (user?.name?.isNotEmpty == true)
                  ? user!.name[0].toUpperCase()
                  : 'U',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: fontSize,
              ),
            ),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Today Hero Card
// ─────────────────────────────────────────────────────────────────────────────

class _TodayHeroCard extends StatelessWidget {
  final ProgressSummary summary;
  final VoidCallback onTrack;
  const _TodayHeroCard({required this.summary, required this.onTrack});

  @override
  Widget build(BuildContext context) {
    final todayPts = summary.todayEntry?.totalPoints ?? 0;
    final streak = summary.currentMonth?.streakDays ?? 0;
    final pct =
        (summary.currentMonth?.completionPercentage ?? 0).clamp(0.0, 100.0);
    final totalPts = summary.currentMonth?.totalPoints ?? 0;
    final weekPts = summary.weeklyPoints;
    final hasToday = summary.todayEntry != null && todayPts > 0;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0A3D28),
            Color(0xFF155C3E),
            Color(0xFF237356),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.xl_,
        boxShadow: shadowGreen(),
      ),
      child: Stack(
        children: [
          // BG pattern
          Positioned.fill(
            child: ClipRRect(
              borderRadius: AppRadius.xl_,
              child: CustomPaint(painter: _BgPatternPainter()),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header row ──────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'আজকের আমল',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            hasToday
                                ? 'চমৎকার! চালিয়ে যান 💪'
                                : 'আজকের আমল যোগ করুন',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (streak > 0) ...[
                      const SizedBox(width: 10),
                      _StreakBadge(streak: streak),
                    ],
                  ],
                ),

                const SizedBox(height: 20),

                // ── Ring + Stats ─────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Progress ring
                    CircularPercentIndicator(
                      radius: 56,
                      lineWidth: 7,
                      percent: pct / 100,
                      animation: true,
                      animationDuration: 1400,
                      backgroundColor: Colors.white.withOpacity(0.12),
                      progressColor: AppColors.gold,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${pct.toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'মাসিক',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 20),

                    // Stats
                    Expanded(
                      child: Column(
                        children: [
                          _StatLine(
                            label: 'আজকের পয়েন্ট',
                            value: '$todayPts pts',
                            valueColor:
                                hasToday ? AppColors.goldLight : Colors.white54,
                          ),
                          const SizedBox(height: 12),
                          _StatLine(
                            label: 'এই সপ্তাহ',
                            value: '$weekPts pts',
                            valueColor: Colors.white.withOpacity(0.75),
                          ),
                          const SizedBox(height: 12),
                          _StatLine(
                            label: 'মাসের মোট',
                            value: '$totalPts pts',
                            valueColor: Colors.white,
                            bold: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ── CTA Button ────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: onTrack,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.13),
                        borderRadius: AppRadius.lg_,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.22),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            hasToday ? Icons.edit_rounded : Icons.add_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            hasToday ? 'আমল আপডেট করুন' : 'আজকের আমল যোগ করুন',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatLine extends StatelessWidget {
  final String label, value;
  final Color valueColor;
  final bool bold;
  const _StatLine({
    required this.label,
    required this.value,
    required this.valueColor,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: bold ? 15 : 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );
}

class _StreakBadge extends StatelessWidget {
  final int streak;
  const _StreakBadge({required this.streak});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFFD4A843), Color(0xFFF0C96B)]),
          borderRadius: AppRadius.full,
          boxShadow: shadowGold(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔥', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 5),
            Text(
              '$streak দিন',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
}

class _BgPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.035)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset(size.width + 20, -20), 110, p);
    canvas.drawCircle(Offset(-30, size.height + 30), 90, p);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats Row (3 cards)
// ─────────────────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final ProgressSummary summary;
  const _StatsRow({required this.summary});

  @override
  Widget build(BuildContext context) {
    final completed = summary.currentMonth?.daysCompleted ?? 0;
    final total = 30;
    final streak = summary.currentMonth?.streakDays ?? 0;
    final weekPts = summary.weeklyPoints;

    return Row(children: [
      Expanded(
        child: _StatCard(
          label: 'এই সপ্তাহ',
          value: '$weekPts',
          unit: 'pts',
          icon: Icons.bolt_rounded,
          color: const Color(0xFF2563EB),
          bgColor: const Color(0xFFEFF6FF),
          borderColor: const Color(0xFFBFDBFE),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _StatCard(
          label: 'সম্পন্ন',
          value: '$completed',
          unit: '/ $total দিন',
          icon: Icons.check_circle_outline_rounded,
          color: const Color(0xFF16A34A),
          bgColor: const Color(0xFFF0FDF4),
          borderColor: const Color(0xFFBBF7D0),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _StatCard(
          label: 'সেরা স্ট্রিক',
          value: '$streak',
          unit: 'দিন',
          icon: Icons.local_fire_department_rounded,
          color: const Color(0xFFEA580C),
          bgColor: const Color(0xFFFFF7ED),
          borderColor: const Color(0xFFFED7AA),
        ),
      ),
    ]);
  }
}

class _StatCard extends StatelessWidget {
  final String label, value, unit;
  final IconData icon;
  final Color color, bgColor, borderColor;
  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(13, 14, 13, 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppRadius.lg_,
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: AppRadius.md_,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              unit,
              style: TextStyle(
                color: color.withOpacity(0.7),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.55),
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Header
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title, action;
  final VoidCallback onAction;
  const _SectionHeader(
      {required this.title, required this.action, required this.onAction});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: onAction,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryPale,
                borderRadius: AppRadius.full,
              ),
              child: Text(
                action,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Monthly Progress List  — full width, naturally scrolls
// ─────────────────────────────────────────────────────────────────────────────

class _MonthlyList extends StatelessWidget {
  final List<MonthlyTracker> trackers;
  const _MonthlyList({required this.trackers});

  @override
  Widget build(BuildContext context) {
    final items = trackers.take(4).toList();
    return Column(
      children: items.indexed.map((rec) {
        final (i, t) = rec;
        final month = AppConstants.bengaliMonths[t.month - 1];
        final pct = (t.completionPercentage / 100).clamp(0.0, 1.0);
        final Color barColor;
        final Color bgColor;
        if (pct >= 0.7) {
          barColor = const Color(0xFF16A34A);
          bgColor = const Color(0xFFF0FDF4);
        } else if (pct >= 0.4) {
          barColor = const Color(0xFFD97706);
          bgColor = const Color(0xFFFFFBEB);
        } else {
          barColor = const Color(0xFFDC2626);
          bgColor = const Color(0xFFFFF1F2);
        }

        return Padding(
          padding: EdgeInsets.only(bottom: i < items.length - 1 ? 10.0 : 0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.lg_,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                // Month pill
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: AppRadius.md_,
                  ),
                  child: Center(
                    child: Text(
                      month.length > 4 ? month.substring(0, 4) : month,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: barColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // Bar + label
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            month,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${(pct * 100).toInt()}%',
                            style: TextStyle(
                              color: barColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: AppRadius.full,
                        child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 7,
                          backgroundColor: AppColors.divider,
                          valueColor: AlwaysStoppedAnimation(barColor),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 14),

                // Points
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${t.totalPoints}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        height: 1,
                      ),
                    ),
                    const Text(
                      'pts',
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 11,
                      ),
                    ),
                    if (t.isWinner)
                      const Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: Text('🏆', style: TextStyle(fontSize: 15)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Leaderboard List  — full width, naturally scrolls
// ─────────────────────────────────────────────────────────────────────────────

class _LeaderboardList extends StatelessWidget {
  final List entries;
  const _LeaderboardList({required this.entries});

  @override
  Widget build(BuildContext context) {
    const rankColors = [
      Color(0xFFF59E0B),
      Color(0xFF94A3B8),
      Color(0xFFCD7F32),
    ];
    const rankBgs = [
      Color(0xFFFFFBEB),
      Color(0xFFF8FAFC),
      Color(0xFFFDF6EE),
    ];
    const emojis = ['🥇', '🥈', '🥉'];

    return Column(
      children: entries.asMap().entries.map((e) {
        final i = e.key;
        final entry = e.value;
        final isTop3 = i < 3;
        final rankColor = isTop3 ? rankColors[i] : AppColors.textTertiary;
        final rankBg = isTop3 ? rankBgs[i] : AppColors.surfaceAlt;

        return Padding(
          padding: EdgeInsets.only(bottom: i < entries.length - 1 ? 10.0 : 0),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.lg_,
              border: Border.all(
                color: i == 0 ? rankColor.withOpacity(0.35) : AppColors.border,
                width: i == 0 ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                // Rank badge
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: rankBg,
                    borderRadius: AppRadius.md_,
                  ),
                  child: Center(
                    child: isTop3
                        ? Text(emojis[i], style: const TextStyle(fontSize: 20))
                        : Text(
                            '#${i + 1}',
                            style: TextStyle(
                              color: rankColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                  ),
                ),

                const SizedBox(width: 12),

                // Avatar
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primaryDark,
                        AppColors.primaryLight,
                      ],
                    ),
                    borderRadius: AppRadius.md_,
                  ),
                  child: Center(
                    child: Text(
                      (entry.name?.isNotEmpty == true)
                          ? entry.name[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Name & dept
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.name ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (entry.department?.isNotEmpty == true)
                        Text(
                          entry.department!,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),

                // Points
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${entry.totalPoints}',
                      style: TextStyle(
                        color: rankColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        height: 1,
                      ),
                    ),
                    const Text(
                      'pts',
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileSheet extends StatelessWidget {
  final dynamic user;
  final WidgetRef ref;
  const _ProfileSheet({this.user, required this.ref});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(24, 20, 24, mq.padding.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: AppRadius.full,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryDark,
                  AppColors.primaryLight,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: shadowGreen(),
            ),
            child: Center(
              child: Text(
                (user?.name?.isNotEmpty == true)
                    ? user!.name[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            user?.name ?? '',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          if (user?.email != null) ...[
            const SizedBox(height: 4),
            Text(
              user!.email,
              style:
                  const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
          if (user?.department != null || user?.designation != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryPale,
                borderRadius: AppRadius.full,
              ),
              child: Text(
                [
                  if (user?.designation != null) user!.designation,
                  if (user?.department != null) user!.department,
                ].join(' • '),
                style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          const SizedBox(height: 24),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await ref.read(authProvider.notifier).logout();
              },
              icon: const Icon(Icons.logout_rounded,
                  color: AppColors.error, size: 22),
              label: const Text(
                'লগআউট',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: AppColors.errorPale,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.lg_,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Skeletons & Empty State
// ─────────────────────────────────────────────────────────────────────────────

class _Skeleton extends StatelessWidget {
  final double height;
  const _Skeleton({required this.height});

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: AppRadius.xl_,
        ),
      ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, colors: [
        AppColors.surfaceAlt,
        AppColors.border,
        AppColors.surfaceAlt,
      ]);
}

class _StatsRowSkeleton extends StatelessWidget {
  const _StatsRowSkeleton();

  @override
  Widget build(BuildContext context) => Row(
        children: List.generate(3, (i) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < 2 ? 10.0 : 0),
              child: Container(
                height: 114,
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: AppRadius.lg_,
                ),
              )
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(duration: 1200.ms, colors: [
                AppColors.surfaceAlt,
                AppColors.border,
                AppColors.surfaceAlt,
              ]),
            ),
          );
        }),
      );
}

class _ListSkeleton extends StatelessWidget {
  final int count;
  const _ListSkeleton({required this.count});

  @override
  Widget build(BuildContext context) => Column(
        children: List.generate(count, (i) {
          return Padding(
            padding: EdgeInsets.only(bottom: i < count - 1 ? 10.0 : 0),
            child: Container(
              height: 82,
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: AppRadius.lg_,
              ),
            )
                .animate(onPlay: (c) => c.repeat())
                .shimmer(duration: 1200.ms, colors: [
              AppColors.surfaceAlt,
              AppColors.border,
              AppColors.surfaceAlt,
            ]),
          );
        }),
      );
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String label;
  const _EmptyState({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: AppRadius.lg_,
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.textTertiary, size: 38),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textTertiary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Compat export (used by other screens)
// ─────────────────────────────────────────────────────────────────────────────

class SectionHeaderCompact extends StatelessWidget {
  final String title, action;
  final VoidCallback onAction;
  const SectionHeaderCompact({
    required this.title,
    required this.action,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) =>
      _SectionHeader(title: title, action: action, onAction: onAction);
}
