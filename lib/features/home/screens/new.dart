import 'dart:ui';

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

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _sc = ScrollController();

  // Header appears after scrolling past this offset
  static const double _stickyThreshold = 170.0;
  bool _headerVisible = false;

  @override
  void initState() {
    super.initState();
    _sc.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      ref.read(leaderboardProvider.notifier).load(
            LeaderboardFilter(year: now.year, month: now.month, limit: 3),
          );
    });
  }

  void _onScroll() {
    final show = _sc.offset > _stickyThreshold;
    if (show != _headerVisible) setState(() => _headerVisible = show);
  }

  @override
  void dispose() {
    _sc
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
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
        backgroundColor: const Color(0xFFF0F3F0),
        body: Stack(
          children: [
            // ── Main scrollable body ──────────────────────────────────
            RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _refresh,
              child: CustomScrollView(
                controller: _sc,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // ── Hero section ──────────────────────────────────
                  SliverToBoxAdapter(
                    child: progress.when(
                      loading: () => _HeroSection(
                        user: user,
                        summary: null,
                        onTrack: () => context.go(AppRoutes.tracker),
                        onProfile: () => _showProfile(context),
                      ),
                      error: (_, __) => _HeroSection(
                        user: user,
                        summary: null,
                        onTrack: () => context.go(AppRoutes.tracker),
                        onProfile: () => _showProfile(context),
                      ),
                      data: (s) => _HeroSection(
                        user: user,
                        summary: s,
                        onTrack: () => context.go(AppRoutes.tracker),
                        onProfile: () => _showProfile(context),
                      ),
                    ),
                  ),

                  // ── Scrollable content ────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Progress section ──────────────────────
                          _SectionLabel(
                            title: 'মাসিক অগ্রগতি',
                            emoji: '📊',
                            onSeeAll: () => context.go(AppRoutes.monthlyView),
                          ).animate().fadeIn(delay: 120.ms),

                          const SizedBox(height: 10),

                          progress
                              .when(
                                loading: () => const _CardListSkeleton(),
                                error: (_, __) => const SizedBox.shrink(),
                                data: (s) => s.recentMonths.isEmpty
                                    ? const _EmptyHint(label: 'কোনো রেকর্ড নেই')
                                    : _ProgressCardList(
                                        trackers: s.recentMonths),
                              )
                              .animate()
                              .fadeIn(delay: 160.ms),

                          const SizedBox(height: 24),

                          // ── Leaderboard section ───────────────────
                          _SectionLabel(
                            title: 'শীর্ষ তালিকা',
                            emoji: '🏆',
                            onSeeAll: () => context.go(AppRoutes.leaderboard),
                          ).animate().fadeIn(delay: 200.ms),

                          const SizedBox(height: 10),

                          (board.isLoading
                                  ? const _CardListSkeleton()
                                  : board.entries.isEmpty
                                      ? const _EmptyHint(label: 'ডেটা নেই')
                                      : _LeaderboardCardList(
                                          entries:
                                              board.entries.take(3).toList()))
                              .animate()
                              .fadeIn(delay: 240.ms),

                          const SizedBox(height: 110),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Sticky header — slides in after scroll threshold ──────
            AnimatedSlide(
              offset: _headerVisible ? Offset.zero : const Offset(0, -1),
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                opacity: _headerVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: _StickyHeader(
                  user: user,
                  onAvatarTap: () => _showProfile(context),
                ),
              ),
            ),
          ],
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

// ══════════════════════════════════════════════════════════════════════════════
// STICKY HEADER — frosted glass, slides down on scroll
// ══════════════════════════════════════════════════════════════════════════════

class _StickyHeader extends StatelessWidget {
  final dynamic user;
  final VoidCallback onAvatarTap;

  const _StickyHeader({this.user, required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.88),
            border: Border(
              bottom: BorderSide(
                color: Colors.black.withOpacity(0.07),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  // App identity
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F4A2E), Color(0xFF1B7045)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Center(
                      child: Text('🌿', style: TextStyle(fontSize: 15)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'আমাল ট্র্যাকার',
                    style: TextStyle(
                      color: const Color(0xFF0A2D1B),
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  // User avatar
                  GestureDetector(
                    onTap: onAvatarTap,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD4A843), Color(0xFFF0C96B)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          (user?.name?.isNotEmpty == true)
                              ? user!.name[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
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

// ══════════════════════════════════════════════════════════════════════════════
// HERO SECTION — dark gradient, dot-grid texture, bento grid layout
// ══════════════════════════════════════════════════════════════════════════════

class _HeroSection extends StatelessWidget {
  final dynamic user;
  final ProgressSummary? summary;
  final VoidCallback onTrack;
  final VoidCallback onProfile;

  const _HeroSection({
    this.user,
    this.summary,
    required this.onTrack,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final month = AppConstants.bengaliMonths[now.month - 1];

    final pct =
        (summary?.currentMonth?.completionPercentage ?? 0).clamp(0.0, 100.0);
    final todayPts = summary?.todayEntry?.totalPoints ?? 0;
    final streak = summary?.currentMonth?.streakDays ?? 0;
    final daysCompleted = summary?.currentMonth?.daysCompleted ?? 0;
    final totalPts = summary?.currentMonth?.totalPoints ?? 0;
    final hasToday = summary?.todayEntry != null && todayPts > 0;
    final isLoading = summary == null;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF071E12), Color(0xFF0E3D22), Color(0xFF1A5E35)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // ── Dot-grid texture ──────────────────────────────────────
          Positioned.fill(
            child: CustomPaint(painter: _DotGridPainter()),
          ),

          // ── Gold radial glow (top-right) ──────────────────────────
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFD4A843).withOpacity(0.14),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Green glow (bottom-left) ──────────────────────────────
          Positioned(
            bottom: -40,
            left: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF1A8C4E).withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Content ───────────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top bar: greeting + name + avatar ─────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Greeting pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.09),
                                borderRadius: BorderRadius.circular(99),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.14)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('🌙',
                                      style: TextStyle(fontSize: 10)),
                                  const SizedBox(width: 5),
                                  Text(
                                    'আস-সালামু আলাইকুম',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.65),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 7),
                            // Name — big, editorial
                            Text(
                              user?.name?.split(' ').first ?? 'বন্ধু',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 28,
                                height: 1.0,
                                letterSpacing: -0.8,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${now.day} $month ${now.year}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Avatar
                      GestureDetector(
                        onTap: onProfile,
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFD4A843), Color(0xFFF0C96B)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFD4A843).withOpacity(0.5),
                                blurRadius: 16,
                                offset: const Offset(0, 5),
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
                                fontSize: 19,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ── Bento grid ────────────────────────────────────
                  isLoading
                      ? _HeroBentoSkeleton()
                      : _HeroBento(
                          pct: pct,
                          todayPts: todayPts,
                          streak: streak,
                          hasToday: hasToday,
                          onTrack: onTrack,
                        ),

                  const SizedBox(height: 8),

                  // ── Bottom stat strip ─────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _HeroStripCell(
                          icon: Icons.check_circle_outline_rounded,
                          label: 'সম্পন্ন দিন',
                          value: isLoading ? '–' : '$daysCompleted',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _HeroStripCell(
                          icon: Icons.stars_rounded,
                          label: 'মোট পয়েন্ট',
                          value: isLoading ? '–' : '$totalPts pts',
                          valueColor: const Color(0xFFD4A843),
                        ),
                      ),
                    ],
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

// ─── Hero Bento Grid ───────────────────────────────────────────────────────────

class _HeroBento extends StatelessWidget {
  final double pct;
  final int todayPts, streak;
  final bool hasToday;
  final VoidCallback onTrack;

  const _HeroBento({
    required this.pct,
    required this.todayPts,
    required this.streak,
    required this.hasToday,
    required this.onTrack,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Left: Circular progress ring cell ─────────────────────
          Container(
            width: 118,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: Colors.white.withOpacity(0.12), width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularPercentIndicator(
                  radius: 42,
                  lineWidth: 5.5,
                  percent: pct / 100,
                  animation: true,
                  animationDuration: 1400,
                  backgroundColor: Colors.white.withOpacity(0.12),
                  progressColor: const Color(0xFFD4A843),
                  circularStrokeCap: CircularStrokeCap.round,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${pct.toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'মাসিক',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.45),
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ── Right: Stat cells + CTA ────────────────────────────────
          Expanded(
            child: Column(
              children: [
                // Today + Streak row
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _GlassStatCell(
                          topLabel: 'আজকের',
                          value: '$todayPts',
                          unit: 'pts',
                          icon: '☀️',
                          accentColor:
                              hasToday ? const Color(0xFFD4A843) : Colors.white,
                          highlight: hasToday,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _GlassStatCell(
                          topLabel: 'স্ট্রিক',
                          value: '$streak',
                          unit: 'দিন',
                          icon: '🔥',
                          accentColor: streak > 0
                              ? const Color(0xFFFF8C42)
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // CTA button
                GestureDetector(
                  onTap: onTrack,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      gradient: hasToday
                          ? null
                          : const LinearGradient(
                              colors: [Color(0xFFD4A843), Color(0xFFE8B84B)],
                            ),
                      color: hasToday ? Colors.white.withOpacity(0.1) : null,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: hasToday
                            ? Colors.white.withOpacity(0.18)
                            : Colors.transparent,
                        width: 1,
                      ),
                      boxShadow: hasToday
                          ? null
                          : [
                              BoxShadow(
                                color: const Color(0xFFD4A843).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          hasToday
                              ? Icons.edit_rounded
                              : Icons.add_circle_rounded,
                          color: Colors.white,
                          size: 15,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          hasToday ? 'আপডেট করুন' : 'আমল রেকর্ড করুন',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
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

// ─── Glass Stat Cell (inside hero bento) ──────────────────────────────────────

class _GlassStatCell extends StatelessWidget {
  final String topLabel, value, unit, icon;
  final Color accentColor;
  final bool highlight;

  const _GlassStatCell({
    required this.topLabel,
    required this.value,
    required this.unit,
    required this.icon,
    this.accentColor = Colors.white,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        color: highlight
            ? const Color(0xFFD4A843).withOpacity(0.12)
            : Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: highlight
              ? const Color(0xFFD4A843).withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                topLabel,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(icon, style: const TextStyle(fontSize: 11)),
            ],
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              text: value,
              style: TextStyle(
                color: accentColor,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
              children: [
                TextSpan(
                  text: '\n$unit',
                  style: TextStyle(
                    color: accentColor.withOpacity(0.55),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
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

// ─── Hero Strip Cell (bottom of hero) ─────────────────────────────────────────

class _HeroStripCell extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color valueColor;

  const _HeroStripCell({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.4), size: 14),
          const SizedBox(width: 7),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 8.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: valueColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Hero Bento Skeleton ───────────────────────────────────────────────────────

class _HeroBentoSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 118,
          height: 130,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
        )
            .animate(onPlay: (c) => c.repeat())
            .shimmer(duration: 1400.ms, colors: [
          Colors.white.withOpacity(0.05),
          Colors.white.withOpacity(0.14),
          Colors.white.withOpacity(0.05),
        ]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 76,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 76,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              )
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(duration: 1400.ms, delay: 100.ms, colors: [
                Colors.white.withOpacity(0.05),
                Colors.white.withOpacity(0.14),
                Colors.white.withOpacity(0.05),
              ]),
              const SizedBox(height: 8),
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(15),
                ),
              )
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(duration: 1400.ms, delay: 200.ms, colors: [
                Colors.white.withOpacity(0.05),
                Colors.white.withOpacity(0.14),
                Colors.white.withOpacity(0.05),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Dot Grid Painter ──────────────────────────────────────────────────────────

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.055)
      ..style = PaintingStyle.fill;
    const spacing = 22.0;
    for (double x = spacing / 2; x < size.width; x += spacing) {
      for (double y = spacing / 2; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ══════════════════════════════════════════════════════════════════════════════
// SECTION LABEL
// ══════════════════════════════════════════════════════════════════════════════

class _SectionLabel extends StatelessWidget {
  final String title, emoji;
  final VoidCallback onSeeAll;

  const _SectionLabel({
    required this.title,
    required this.emoji,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 7),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0A2D1B),
            fontWeight: FontWeight.w800,
            fontSize: 15,
            letterSpacing: -0.3,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onSeeAll,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryPale,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              'সব দেখুন →',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// PROGRESS CARDS — full-width, left accent bar
// ══════════════════════════════════════════════════════════════════════════════

class _ProgressCardList extends StatelessWidget {
  final List<MonthlyTracker> trackers;
  const _ProgressCardList({required this.trackers});

  @override
  Widget build(BuildContext context) {
    final items = trackers.take(3).toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(items.length, (i) {
        final t = items[i];
        final month = AppConstants.bengaliMonths[t.month - 1];
        final pct = (t.completionPercentage / 100).clamp(0.0, 1.0);
        final barColor = pct > 0.7
            ? const Color(0xFF16A34A)
            : pct > 0.4
                ? const Color(0xFFF59E0B)
                : const Color(0xFFEF4444);

        return Padding(
          padding: EdgeInsets.only(bottom: i < items.length - 1 ? 8.0 : 0),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Left accent bar
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        // Month + progress bar
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    month,
                                    style: TextStyle(
                                      color: const Color(0xFF0A2D1B),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  if (t.isWinner) ...[
                                    const SizedBox(width: 5),
                                    const Text('🏆',
                                        style: TextStyle(fontSize: 11)),
                                  ],
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(99),
                                    child: LinearProgressIndicator(
                                      value: pct,
                                      minHeight: 5,
                                      backgroundColor: const Color(0xFFEEF0EE),
                                      valueColor:
                                          AlwaysStoppedAnimation(barColor),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${(pct * 100).toInt()}% সম্পন্ন',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.38),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Points badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: barColor.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${t.totalPoints}',
                                style: TextStyle(
                                  color: barColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  height: 1,
                                ),
                              ),
                              Text(
                                'pts',
                                style: TextStyle(
                                  color: barColor.withOpacity(0.6),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
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
        ).animate().fadeIn(delay: Duration(milliseconds: i * 70));
      }),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// LEADERBOARD CARDS — full-width, rank-colored right badge
// ══════════════════════════════════════════════════════════════════════════════

class _LeaderboardCardList extends StatelessWidget {
  final List entries;
  const _LeaderboardCardList({required this.entries});

  @override
  Widget build(BuildContext context) {
    const rankColors = [
      Color(0xFFD4A843), // 🥇 gold
      Color(0xFF94A3B8), // 🥈 silver
      Color(0xFFCD7F32), // 🥉 bronze
    ];
    const emojis = ['🥇', '🥈', '🥉'];
    const rankBg = [
      Color(0xFFFFFBEB),
      Color(0xFFF8FAFC),
      Color(0xFFFFF7ED),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(entries.length, (i) {
        final entry = entries[i];
        return Padding(
          padding: EdgeInsets.only(bottom: i < entries.length - 1 ? 8.0 : 0),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: rankBg[i],
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: rankColors[i].withOpacity(0.18), width: 1),
              boxShadow: [
                BoxShadow(
                  color: rankColors[i].withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  // Rank emoji
                  Text(emojis[i], style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),

                  // Avatar
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F4A2E), Color(0xFF1B7045)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Center(
                      child: Text(
                        (entry.name?.isNotEmpty == true)
                            ? entry.name[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 11),

                  // Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          entry.name?.split(' ').first ?? '',
                          style: const TextStyle(
                            color: Color(0xFF0A2D1B),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          entry.department ?? entry.designation ?? '',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.35),
                            fontSize: 9.5,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Points badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                    decoration: BoxDecoration(
                      color: rankColors[i].withOpacity(0.14),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${entry.totalPoints}',
                          style: TextStyle(
                            color: rankColors[i],
                            fontWeight: FontWeight.w900,
                            fontSize: 17,
                            height: 1,
                          ),
                        ),
                        Text(
                          'pts',
                          style: TextStyle(
                            color: rankColors[i].withOpacity(0.6),
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: i * 70));
      }),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// HELPERS
// ══════════════════════════════════════════════════════════════════════════════

class _CardListSkeleton extends StatelessWidget {
  const _CardListSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Padding(
          padding: EdgeInsets.only(bottom: i < 2 ? 8.0 : 0),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ).animate(onPlay: (c) => c.repeat()).shimmer(
            duration: 1200.ms,
            delay: Duration(milliseconds: i * 80),
            colors: [Colors.white, const Color(0xFFE8ECE8), Colors.white],
          ),
        );
      }),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final String label;
  const _EmptyHint({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: Colors.black.withOpacity(0.3),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
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
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8E2),
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F4A2E), Color(0xFF1B7045)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
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
              color: AppColors.primaryPale,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              '${user?.designation ?? ''} • ${user?.department ?? ''}',
              style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
        const SizedBox(height: 20),
        Divider(color: const Color(0xFFEEF0EE)),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ]),
    );
  }
}

// Keep public alias for other screens that may reference it
class SectionHeaderCompact extends StatelessWidget {
  final String title, action;
  final VoidCallback onAction;
  const SectionHeaderCompact(
      {required this.title, required this.action, required this.onAction});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  )),
          GestureDetector(
            onTap: onAction,
            child: Text(action,
                style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      );
}
