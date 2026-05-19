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
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: NeverScrollableScrollPhysics(),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  // ── Unified Hero (Header + Today + Stats merged) ──────
                  progress
                      .when(
                        loading: () => _HeroSkeleton(user: user),
                        error: (_, __) => _HeroSkeleton(user: user),
                        data: (s) => _HeroSection(
                          user: user,
                          summary: s,
                          date: DateTime.now(),
                          onTrack: () => context.go(AppRoutes.tracker),
                          onProfile: () => _showProfile(context),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 200.ms),

                  // ── Bottom two-column section ─────────────────────────
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left: Recent months progress
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SectionHeader(
                                  title: 'অগ্রগতি',
                                  action: 'সব দেখুন →',
                                  onAction: () =>
                                      context.go(AppRoutes.monthlyView),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: progress
                                      .when(
                                        loading: () => const _ColumnSkeleton(),
                                        error: (_, __) =>
                                            const SizedBox.shrink(),
                                        data: (s) => s.recentMonths.isEmpty
                                            ? const _NoDataCard(
                                                icon: Icons.bar_chart_rounded,
                                                label: 'কোনো তথ্য নেই',
                                              )
                                            : _RecentMonthsColumn(
                                                trackers: s.recentMonths,
                                              ),
                                      )
                                      .animate()
                                      .fadeIn(delay: 120.ms),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          // Right: Leaderboard top 3
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SectionHeader(
                                  title: 'শীর্ষ তালিকা 🏆',
                                  action: 'সব দেখুন →',
                                  onAction: () =>
                                      context.go(AppRoutes.leaderboard),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: board.isLoading
                                      ? const _ColumnSkeleton()
                                      : board.entries.isEmpty
                                          ? const _NoDataCard(
                                              icon: Icons.emoji_events_rounded,
                                              label: 'ডেটা নেই',
                                            )
                                          : _LeaderboardColumn(
                                              entries: board.entries
                                                  .take(3)
                                                  .toList(),
                                            ).animate().fadeIn(delay: 180.ms),
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

  void _showProfile(BuildContext context) {
    final user = ref.read(currentUserProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ProfileSheet(user: user, ref: ref),
    );
  }
}

// ─── Unified Hero Section ─────────────────────────────────────────────────────
// Replaces: _HomeHeader + _TodayCard + _WeeklyStatsRow (no more duplicates)

class _HeroSection extends StatelessWidget {
  final dynamic user;
  final ProgressSummary summary;
  final DateTime date;
  final VoidCallback onTrack;
  final VoidCallback onProfile;

  const _HeroSection({
    this.user,
    required this.summary,
    required this.date,
    required this.onTrack,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    final month = AppConstants.bengaliMonths[date.month - 1];
    final pct =
        (summary.currentMonth?.completionPercentage ?? 0).clamp(0.0, 100.0);
    final todayPts = summary.todayEntry?.totalPoints ?? 0;
    final streak = summary.currentMonth?.streakDays ?? 0;
    final totalPts = summary.currentMonth?.totalPoints ?? 0;
    final daysCompleted = summary.currentMonth?.daysCompleted ?? 0;
    final hasToday = summary.todayEntry != null && todayPts > 0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A3D28), Color(0xFF145E3A), Color(0xFF1E7A4E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Subtle decorative rings
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withOpacity(0.05), width: 1.5),
              ),
            ),
          ),
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.03),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: Colors.white.withOpacity(0.04), width: 1),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Top bar: Greeting + Avatar ──────────────────────
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('🌙', style: TextStyle(fontSize: 11)),
                              const SizedBox(width: 5),
                              Text(
                                'আস-সালামু আলাইকুম',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.65),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.name?.split(' ').first ?? 'বন্ধু',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            '${date.day} $month ${date.year}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: onProfile,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFD4A843), Color(0xFFF0C96B)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFD4A843).withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              (user?.name?.isNotEmpty == true)
                                  ? user!.name[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ── Main content: Ring + Stats grid ────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Circular progress ring
                      CircularPercentIndicator(
                        radius: 52,
                        lineWidth: 6.5,
                        percent: pct / 100,
                        animation: true,
                        animationDuration: 1400,
                        backgroundColor: Colors.white.withOpacity(0.12),
                        progressColor: AppColors.gold,
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${pct.toInt()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 19,
                                height: 1,
                              ),
                            ),
                            Text(
                              'মাসিক',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.55),
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Stats grid — 2×2, all unique data
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _HeroStatTile(
                                    label: 'আজকের পয়েন্ট',
                                    value: '$todayPts',
                                    unit: 'pts',
                                    icon: Icons.wb_sunny_rounded,
                                    highlight: hasToday,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _HeroStatTile(
                                    label: 'ধারাবাহিক',
                                    value: '$streak',
                                    unit: 'দিন',
                                    icon: Icons.local_fire_department_rounded,
                                    isStreak: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _HeroStatTile(
                                    label: 'মাসে সম্পন্ন',
                                    value: '$daysCompleted',
                                    unit: 'দিন',
                                    icon: Icons.check_circle_rounded,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _HeroStatTile(
                                    label: 'মোট পয়েন্ট',
                                    value: '$totalPts',
                                    unit: 'pts',
                                    icon: Icons.stars_rounded,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── CTA Button ──────────────────────────────────────
                  GestureDetector(
                    onTap: onTrack,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: hasToday
                            ? Colors.white.withOpacity(0.12)
                            : Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color:
                              Colors.white.withOpacity(hasToday ? 0.15 : 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            hasToday
                                ? Icons.edit_rounded
                                : Icons.add_circle_rounded,
                            color: Colors.white,
                            size: 17,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            hasToday
                                ? 'আজকের আমল আপডেট করুন'
                                : 'আজকের আমল রেকর্ড করুন',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          if (!hasToday) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.gold.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '✦ নতুন',
                                style: TextStyle(
                                  color: AppColors.goldLight,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
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
}

// ─── Hero Stat Tile ────────────────────────────────────────────────────────────

class _HeroStatTile extends StatelessWidget {
  final String label, value, unit;
  final IconData icon;
  final bool highlight;
  final bool isStreak;

  const _HeroStatTile({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    this.highlight = false,
    this.isStreak = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color accentColor = isStreak
        ? const Color(0xFFFF8C42)
        : highlight
            ? AppColors.goldLight
            : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isStreak ? 0.1 : 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(isStreak ? 0.18 : 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 14),
          const SizedBox(height: 5),
          RichText(
            text: TextSpan(
              text: value,
              style: TextStyle(
                color: accentColor,
                fontSize: 17,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
              children: [
                TextSpan(
                  text: ' $unit',
                  style: TextStyle(
                    color: accentColor.withOpacity(0.6),
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.45),
              fontSize: 8.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Hero Skeleton ─────────────────────────────────────────────────────────────

class _HeroSkeleton extends StatelessWidget {
  final dynamic user;
  const _HeroSkeleton({this.user});

  @override
  Widget build(BuildContext context) {
    final month = AppConstants.bengaliMonths[DateTime.now().month - 1];
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A3D28), Color(0xFF145E3A), Color(0xFF1E7A4E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top bar (no skeleton, shows real user info)
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Text('🌙', style: TextStyle(fontSize: 11)),
                        const SizedBox(width: 5),
                        Text('আস-সালামু আলাইকুম',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.65),
                                fontSize: 11)),
                      ]),
                      const SizedBox(height: 2),
                      Text(user?.name?.split(' ').first ?? 'বন্ধু',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 22)),
                      Text(
                          '${DateTime.now().day} $month ${DateTime.now().year}',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 11)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Skeleton for stats
              Row(
                children: [
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        Row(children: [
                          Expanded(child: _SkeletonTile()),
                          const SizedBox(width: 8),
                          Expanded(child: _SkeletonTile()),
                        ]),
                        const SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: _SkeletonTile()),
                          const SizedBox(width: 8),
                          Expanded(child: _SkeletonTile()),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
              )
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(duration: 1200.ms, colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.1),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
      ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, colors: [
        Colors.white.withOpacity(0.08),
        Colors.white.withOpacity(0.18),
        Colors.white.withOpacity(0.08),
      ]);
}

// ─── Profile Sheet ─────────────────────────────────────────────────────────────

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

// ─── Section Header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title, action;
  final VoidCallback onAction;

  const _SectionHeader({
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
                  fontSize: 12,
                  color: AppColors.textPrimary,
                ),
          ),
          GestureDetector(
            onTap: onAction,
            child: Text(
              action,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
}

// ─── Recent Months Column ──────────────────────────────────────────────────────

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
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.lg_,
              border: Border.all(color: AppColors.border),
              boxShadow: shadowSm(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
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
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '${t.totalPoints}',
                          style: TextStyle(
                            color: barColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          ' pts',
                          style: TextStyle(
                            color: barColor.withOpacity(0.6),
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (t.isWinner)
                          const Padding(
                            padding: EdgeInsets.only(left: 3),
                            child: Text('🏆', style: TextStyle(fontSize: 9)),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: AppRadius.full,
                  child: LinearProgressIndicator(
                    value: pct,
                    minHeight: 5,
                    backgroundColor: AppColors.divider,
                    valueColor: AlwaysStoppedAnimation(barColor),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(pct * 100).toInt()}% সম্পন্ন',
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w500,
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

// ─── Leaderboard Column ────────────────────────────────────────────────────────

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
    final bgColors = [
      const Color(0xFFFFFBEB),
      const Color(0xFFF8FAFC),
      const Color(0xFFFFF7ED),
    ];

    return Column(
      children: entries.asMap().entries.map((e) {
        final entry = e.value;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: bgColors[e.key],
              borderRadius: AppRadius.lg_,
              border:
                  Border.all(color: colors[e.key].withOpacity(0.2), width: 1),
              boxShadow: shadowSm(),
            ),
            child: Row(
              children: [
                Text(emojis[e.key], style: const TextStyle(fontSize: 15)),
                const SizedBox(width: 7),
                Container(
                  width: 28,
                  height: 28,
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
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        entry.name?.split(' ').first ?? '',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              color: AppColors.textPrimary,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${entry.totalPoints}',
                      style: TextStyle(
                        color: colors[e.key],
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        height: 1,
                      ),
                    ),
                    Text(
                      'pts',
                      style: TextStyle(
                        color: colors[e.key].withOpacity(0.6),
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
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

// ─── Column Skeleton ───────────────────────────────────────────────────────────

class _ColumnSkeleton extends StatelessWidget {
  const _ColumnSkeleton();

  @override
  Widget build(BuildContext context) => Column(
        children: List.generate(
          3,
          (i) => Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: AppRadius.lg_,
              ),
            ).animate(onPlay: (c) => c.repeat()).shimmer(
                duration: 1200.ms,
                delay: Duration(milliseconds: i * 80),
                colors: [
                  AppColors.surfaceAlt,
                  AppColors.border,
                  AppColors.surfaceAlt,
                ]),
          ),
        ),
      );
}

// ─── No Data Card ──────────────────────────────────────────────────────────────

class _NoDataCard extends StatelessWidget {
  final IconData icon;
  final String label;
  const _NoDataCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textTertiary, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: AppColors.textTertiary),
            ),
          ],
        ),
      );
}
