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
import '../../../shared/widgets/app_widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      ref.read(leaderboardProvider.notifier).load(
            LeaderboardFilter(year: now.year, month: now.month, limit: 3),
          );
    });
  }

  Future<void> _refresh() async {
    ref.invalidate(progressSummaryProvider);
    final now = DateTime.now();
    await ref.read(leaderboardProvider.notifier).load(
          LeaderboardFilter(year: now.year, month: now.month, limit: 3),
          refresh: true,
        );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final progress = ref.watch(progressSummaryProvider);
    final board = ref.watch(leaderboardProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _refresh,
          // RefreshIndicator needs a scrollable child — wrap in SingleChildScrollView
          // with physics that only triggers pull-to-refresh but doesn't allow free scroll
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: NeverScrollableScrollPhysics(),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  // ── Header ────────────────────────────────────────────
                  _HomeHeader(user: user, date: DateTime.now()),

                  // ── Body: fills remaining VH ──────────────────────────
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                      child: Column(
                        children: [
                          // ── Today compact card ──────────────────────
                          progress
                              .when(
                                loading: () => const _TodayCardSkeleton(),
                                error: (_, __) => const SizedBox.shrink(),
                                data: (s) => _TodayCard(
                                  summary: s,
                                  onTrack: () => context.go(AppRoutes.tracker),
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 80.ms)
                              .slideY(begin: 0.1, curve: Curves.easeOut),

                          const SizedBox(height: 8),

                          // ── 3 mini stat cards ───────────────────────
                          progress
                              .when(
                                loading: () => const _StatsRowSkeleton(),
                                error: (_, __) => const SizedBox.shrink(),
                                data: (s) => _WeeklyStatsRow(summary: s),
                              )
                              .animate()
                              .fadeIn(delay: 160.ms),

                          const SizedBox(height: 10),

                          // ── Bottom two-column section ────────────────
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left: Recent months
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SectionHeaderCompact(
                                        title: 'অগ্রগতি',
                                        action: 'সব →',
                                        onAction: () =>
                                            context.go(AppRoutes.monthlyView),
                                      ),
                                      const SizedBox(height: 5),
                                      Expanded(
                                        child: progress
                                            .when(
                                              loading: () =>
                                                  const SizedBox.shrink(),
                                              error: (_, __) =>
                                                  const SizedBox.shrink(),
                                              data: (s) => s
                                                      .recentMonths.isEmpty
                                                  ? const SizedBox.shrink()
                                                  : _RecentMonthsColumn(
                                                      trackers: s.recentMonths,
                                                    ),
                                            )
                                            .animate()
                                            .fadeIn(delay: 240.ms),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8),

                                // Right: Leaderboard top 3
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SectionHeaderCompact(
                                        title: 'শীর্ষ 🏆',
                                        action: 'সব →',
                                        onAction: () =>
                                            context.go(AppRoutes.leaderboard),
                                      ),
                                      const SizedBox(height: 5),
                                      Expanded(
                                        child: board.isLoading
                                            ? const _LeaderboardSkeleton()
                                            : board.entries.isEmpty
                                                ? const _NoDataCard()
                                                : _LeaderboardColumn(
                                                    entries: board.entries
                                                        .take(3)
                                                        .toList(),
                                                  )
                                                    .animate()
                                                    .fadeIn(delay: 300.ms),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Home Header ──────────────────────────────────────────────────────────────

class _HomeHeader extends ConsumerWidget {
  final dynamic user;
  final DateTime date;
  const _HomeHeader({this.user, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = AppConstants.bengaliMonths[date.month - 1];
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.brandGradient),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -25,
            right: -25,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
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
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: AppRadius.full,
                            border: Border.all(
                                color: Colors.white.withOpacity(0.18)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🌙', style: TextStyle(fontSize: 10)),
                              const SizedBox(width: 4),
                              Text(
                                'আস-সালামু আলাইকুম',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: Colors.white.withOpacity(0.88),
                                      fontSize: 9,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          user?.name?.split(' ').first ?? 'বন্ধু',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                    height: 1.1,
                                  ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${date.day} $month ${date.year}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Avatar
                  GestureDetector(
                    onTap: () => _showProfile(context, ref),
                    child: Container(
                      width: 40,
                      height: 40,
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProfile(BuildContext ctx, WidgetRef ref) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ProfileSheet(user: user, ref: ref),
    );
  }
}

// ─── Profile Sheet (unchanged) ────────────────────────────────────────────────

class _ProfileSheet extends StatelessWidget {
  final dynamic user;
  final WidgetRef ref;
  const _ProfileSheet({this.user, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
              color: AppColors.border, borderRadius: AppRadius.full),
        ),
        const SizedBox(height: 24),
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primaryLight]),
            shape: BoxShape.circle,
            boxShadow: shadowGreen(),
          ),
          child: Center(
            child: Text(
              (user?.name?.isNotEmpty == true)
                  ? user!.name[0].toUpperCase()
                  : 'U',
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(user?.name ?? '',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w700)),
        if (user?.email != null)
          Text(user!.email,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: AppColors.textSecondary)),
        if (user?.department != null || user?.designation != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: AppColors.primaryPale, borderRadius: AppRadius.full),
            child: Text(
              '${user?.designation ?? ''} • ${user?.department ?? ''}',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: AppColors.primary),
            ),
          ),
        ],
        const SizedBox(height: 20),
        const Divider(color: AppColors.divider),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).logout();
            },
            icon: const Icon(Icons.logout_rounded,
                color: AppColors.error, size: 20),
            label: const Text('লগআউট',
                style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                    fontSize: 16)),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: AppColors.errorPale,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.md_),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ]),
    );
  }
}

// ─── Today Card (Compact) ─────────────────────────────────────────────────────

class _TodayCard extends StatelessWidget {
  final ProgressSummary summary;
  final VoidCallback onTrack;
  const _TodayCard({required this.summary, required this.onTrack});

  @override
  Widget build(BuildContext context) {
    final todayPts = summary.todayEntry?.totalPoints ?? 0;
    final streak = summary.currentMonth?.streakDays ?? 0;
    final pct =
        (summary.currentMonth?.completionPercentage ?? 0).clamp(0.0, 100.0);
    final totalPts = summary.currentMonth?.totalPoints ?? 0;
    final hasToday = summary.todayEntry != null && todayPts > 0;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D4530), Color(0xFF1A6B45), Color(0xFF2E8C5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.lg_,
        boxShadow: shadowGreen(),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: AppRadius.lg_,
              child: CustomPaint(painter: _CirclePatternPainter()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Ring
                CircularPercentIndicator(
                  radius: 38,
                  lineWidth: 5.5,
                  percent: pct / 100,
                  animation: true,
                  animationDuration: 1200,
                  backgroundColor: Colors.white.withOpacity(0.15),
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
                          fontSize: 13,
                          height: 1,
                        ),
                      ),
                      Text(
                        'মাস',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasToday
                            ? 'চমৎকার! চালিয়ে যান 💪'
                            : 'আজকের আমল রেকর্ড করুন',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _StatLine('আজ', '$todayPts pts',
                          hasToday ? AppColors.goldLight : Colors.white60),
                      const SizedBox(height: 3),
                      _StatLine('সপ্তাহ', '${summary.weeklyPoints} pts',
                          Colors.white70),
                      const SizedBox(height: 3),
                      _StatLine('মোট', '$totalPts pts', Colors.white),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Right: streak + CTA stacked
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (streak > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xFFD4A843), Color(0xFFF0C96B)]),
                          borderRadius: AppRadius.full,
                        ),
                        child: Text(
                          '🔥 $streak দিন',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: onTrack,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: AppRadius.md_,
                          border:
                              Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              hasToday ? Icons.edit_rounded : Icons.add_rounded,
                              color: Colors.white,
                              size: 13,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              hasToday ? 'আপডেট' : 'যোগ করুন',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
  final Color color;
  const _StatLine(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.55), fontSize: 10)),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 10, fontWeight: FontWeight.w700)),
        ],
      );
}

class _CirclePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(Offset(size.width + 15, -15), 90, p);
    canvas.drawCircle(Offset(-20, size.height + 20), 70, p);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── Weekly Stats Row (Compact) ───────────────────────────────────────────────

class _WeeklyStatsRow extends StatelessWidget {
  final ProgressSummary summary;
  const _WeeklyStatsRow({required this.summary});

  @override
  Widget build(BuildContext context) {
    final daysCompleted = summary.currentMonth?.daysCompleted ?? 0;
    final streak = summary.currentMonth?.streakDays ?? 0;
    final weekPts = summary.weeklyPoints;

    return Row(children: [
      Expanded(
        child: _MiniStatCard(
          label: 'এই সপ্তাহ',
          value: '$weekPts',
          unit: 'pts',
          icon: Icons.calendar_view_week_rounded,
          color: AppColors.info,
          bgColor: const Color(0xFFEFF6FF),
        ),
      ),
      const SizedBox(width: 7),
      Expanded(
        child: _MiniStatCard(
          label: 'সম্পন্ন',
          value: '$daysCompleted',
          unit: 'দিন',
          icon: Icons.check_circle_rounded,
          color: AppColors.success,
          bgColor: const Color(0xFFF0FDF4),
        ),
      ),
      const SizedBox(width: 7),
      Expanded(
        child: _MiniStatCard(
          label: 'স্ট্রিক',
          value: '$streak',
          unit: 'দিন',
          icon: Icons.local_fire_department_rounded,
          color: AppColors.warning,
          bgColor: const Color(0xFFFFFBEB),
        ),
      ),
    ]);
  }
}

class _MiniStatCard extends StatelessWidget {
  final String label, value, unit;
  final IconData icon;
  final Color color, bgColor;
  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppRadius.lg_,
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 5),
          RichText(
            text: TextSpan(
              text: value,
              style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1),
              children: [
                TextSpan(
                  text: ' $unit',
                  style: TextStyle(
                      color: color.withOpacity(0.65),
                      fontSize: 9,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 1),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: color.withOpacity(0.7), fontSize: 9)),
        ]),
      );
}

// ─── Recent Months Column (compact list) ─────────────────────────────────────

class _RecentMonthsColumn extends StatelessWidget {
  final List<MonthlyTracker> trackers;
  const _RecentMonthsColumn({required this.trackers});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: trackers.take(3).map((t) {
        final month = AppConstants.bengaliMonths[t.month - 1];
        final pct = (t.completionPercentage / 100).clamp(0.0, 1.0);
        final barColor = pct > 0.7
            ? AppColors.success
            : pct > 0.4
                ? AppColors.warning
                : AppColors.error;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.lg_,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: barColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  month,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 9,
                      ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ClipRRect(
                    borderRadius: AppRadius.full,
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 4,
                      backgroundColor: AppColors.divider,
                      valueColor: AlwaysStoppedAnimation(barColor),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${t.totalPoints}',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                ),
                if (t.isWinner)
                  const Padding(
                    padding: EdgeInsets.only(left: 3),
                    child: Text('🏆', style: TextStyle(fontSize: 9)),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Leaderboard Column (compact list) ───────────────────────────────────────

class _LeaderboardColumn extends StatelessWidget {
  final List entries;
  const _LeaderboardColumn({required this.entries});

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.rankGold,
      AppColors.rankSilver,
      AppColors.rankBronze,
    ];
    final emojis = ['🥇', '🥈', '🥉'];

    return Column(
      children: entries.asMap().entries.map((e) {
        final entry = e.value;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.lg_,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Text(emojis[e.key], style: const TextStyle(fontSize: 13)),
                const SizedBox(width: 6),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryDark, AppColors.primaryLight],
                    ),
                    borderRadius: AppRadius.sm_,
                  ),
                  child: Center(
                    child: Text(
                      (entry.name?.isNotEmpty == true)
                          ? entry.name[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    entry.name?.split(' ').first ?? '',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${entry.totalPoints}',
                  style: TextStyle(
                    color: colors[e.key],
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Section Header Compact ───────────────────────────────────────────────────

class SectionHeaderCompact extends StatelessWidget {
  final String title, action;
  final VoidCallback onAction;
  const SectionHeaderCompact({
    required this.title,
    required this.action,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
          ),
          GestureDetector(
            onTap: onAction,
            child: Text(
              action,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
}

// ─── Skeletons ────────────────────────────────────────────────────────────────

class _TodayCardSkeleton extends StatelessWidget {
  const _TodayCardSkeleton();
  @override
  Widget build(BuildContext context) => Container(
        height: 90,
        decoration: BoxDecoration(
            color: AppColors.surfaceAlt, borderRadius: AppRadius.lg_),
      ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, colors: [
        AppColors.surfaceAlt,
        AppColors.border,
        AppColors.surfaceAlt
      ]);
}

class _StatsRowSkeleton extends StatelessWidget {
  const _StatsRowSkeleton();
  @override
  Widget build(BuildContext context) => Row(
      children: List.generate(
          3,
          (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 2 ? 7 : 0),
                  child: Container(
                      height: 72,
                      decoration: BoxDecoration(
                          color: AppColors.surfaceAlt,
                          borderRadius: AppRadius.lg_)),
                ),
              )));
}

class _LeaderboardSkeleton extends StatelessWidget {
  const _LeaderboardSkeleton();
  @override
  Widget build(BuildContext context) => Column(
        children: List.generate(
          3,
          (i) => Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                  color: AppColors.surfaceAlt, borderRadius: AppRadius.lg_),
            ),
          ),
        ),
      );
}

class _NoDataCard extends StatelessWidget {
  const _NoDataCard();
  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          'ডেটা নেই',
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: AppColors.textTertiary),
        ),
      );
}
