import 'package:amal_tracker/features/auth/providers/provider_reset.dart';
import 'package:amal_tracker/features/home/widgets/profile_sheet.dart';
import 'package:amal_tracker/features/notification/widgets/notification_widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../tracker/providers/tracker_provider.dart';
import '../../tracker/models/tracker_model.dart';
import '../../leaderboard/providers/leaderboard_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/constants/app_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────

class ColorT {
  // Backgrounds
  static const pageBg = Color(0xFFF4F6F1);
  static const cardBg = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const midGreen = Color(0xFF1B7045);

  // Accents
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFFFF3E0);
  static const goldBorder = Color(0xFFFFCC80);

  // Status
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const amber = Color(0xFFF59E0B);
  static const amberLight = Color(0xFFFFF3E0);
  static const red = Color(0xFFEF4444);

  // Text
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);

  // Borders
  static const border = Color(0xFFE4EAE4);
  static const borderMid = Color(0xFFD0DAD2);

  // Rank colours
  static const rankGold = Color(0xFFD4A843);
  static const rankSilver = Color(0xFF94A3B8);
  static const rankBronze = Color(0xFFCD7F32);
}

// ─────────────────────────────────────────────────────────────────────────────
// HOME SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _sc = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLeaderboardData();
    });
  }

  void _loadLeaderboardData() {
    final now = DateTime.now();
    ref.read(leaderboardPreviewProvider.notifier).load(
          // ← preview
          LeaderboardFilter(year: now.year, month: now.month, limit: 3),
          refresh: true,
        );
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(progressSummaryProvider);
    final now = DateTime.now();
    // invalidate first so the listen above fires and loads fresh data,
    // OR call load directly here — do one, not both, to avoid double fetch:
    await ref.read(leaderboardProvider.notifier).load(
          LeaderboardFilter(year: now.year, month: now.month, limit: 3),
          refresh: true,
        );
  }

  void _showProfile() {
    final user = ref.read(currentUserProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ProfileSheet(
        user: user,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final progress = ref.watch(progressSummaryProvider);
    // final board = ref.watch(leaderboardProvider);

    // ref.listen<LeaderboardState>(leaderboardProvider, (prev, next) {
    //   if (!next.isLoading && next.entries.isEmpty) {
    //     _loadLeaderboardData();
    //   }
    // });
    final board = ref.watch(leaderboardPreviewProvider); // ← preview

// in ref.listen (from previous fix):
    ref.listen<LeaderboardState>(leaderboardPreviewProvider, (prev, next) {
      if (!next.isLoading && next.entries.isEmpty) _loadLeaderboardData();
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: ColorT.pageBg,
        // ── Persistent top bar ──────────────────────────────────────────────
        appBar: _TopBar(
          user: user,
          onAvatarTap: _showProfile,
        ),
        body: RefreshIndicator(
          color: ColorT.darkGreen,
          onRefresh: _refresh,
          child: CustomScrollView(
            controller: _sc,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Greeting ──────────────────────────────────────────
                    _GreetingRow(user: user, progress: progress)
                        .animate()
                        .fadeIn(duration: 300.ms),

                    const SizedBox(height: 16),

                    // ── CTA card ─────────────────────────────────────────
                    progress
                        .when(
                          loading: () => const _CtaCardSkeleton(),
                          error: (_, __) => _CtaCard(
                            summary: null,
                            onTap: () => context.go(AppRoutes.tracker),
                          ),
                          data: (s) => _CtaCard(
                            summary: s,
                            onTap: () => context.go(AppRoutes.tracker),
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 60.ms, duration: 320.ms),

                    const SizedBox(height: 12),

                    // ── Stat strip ────────────────────────────────────────
                    progress
                        .when(
                          loading: () => const _StatStripSkeleton(),
                          error: (_, __) => const _StatStrip(summary: null),
                          data: (s) => _StatStrip(summary: s),
                        )
                        .animate()
                        .fadeIn(delay: 100.ms, duration: 300.ms),

                    const SizedBox(height: 22),

                    // ── Monthly progress ──────────────────────────────────
                    _SectionHeader(
                      title: 'মাসিক অগ্রগতি',
                      emoji: '📊',
                      onSeeAll: () => context.go(AppRoutes.monthlyView),
                    ).animate().fadeIn(delay: 140.ms),

                    const SizedBox(height: 10),

                    progress
                        .when(
                          loading: () => const _ListSkeleton(),
                          error: (_, __) =>
                              const _EmptyCard(label: 'ডেটা লোড ব্যর্থ'),
                          data: (s) => s.recentMonths.isEmpty
                              ? const _EmptyCard(label: 'কোনো রেকর্ড নেই')
                              : _MonthList(trackers: s.recentMonths),
                        )
                        .animate()
                        .fadeIn(delay: 170.ms),

                    const SizedBox(height: 22),

                    // ── Leaderboard ───────────────────────────────────────
                    _SectionHeader(
                      title: 'শীর্ষ তালিকা',
                      emoji: '🏆',
                      onSeeAll: () => context.go(AppRoutes.leaderboard),
                    ).animate().fadeIn(delay: 200.ms),

                    const SizedBox(height: 10),

                    (board.isLoading
                            ? const _ListSkeleton()
                            : board.entries.isEmpty
                                ? const _EmptyCard(label: 'ডেটা নেই')
                                : _LeaderboardList(
                                    entries: board.entries.take(3).toList()))
                        .animate()
                        .fadeIn(delay: 230.ms),
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
// TOP BAR
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic user;
  final VoidCallback onAvatarTap;

  const _TopBar({this.user, required this.onAvatarTap});

  @override
  Size get preferredSize => const Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorT.cardBg,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 62,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: ColorT.cardBg,
            border: Border(
              bottom: BorderSide(color: ColorT.border, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              // Logo + name
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: ColorT.darkGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10), // ইমেজের কর্নারও কাটবে
                  child: Image.asset(
                    'assets/images/sabeq_logo.png', // আপনার ইমেজ পাথ
                    width: 34,
                    height: 34,
                    fit: BoxFit.cover, // ইমেজ পুরো কন্টেইনার কভার করবে
                  ),
                ),
              ),
              // // Logo + name
              // Container(
              //   width: 34,
              //   height: 34,
              //   decoration: BoxDecoration(
              //     color: ColorT.darkGreen,
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: const Center(
              //     child: Text('🌿', style: TextStyle(fontSize: 16)),
              //   ),
              // ),
              const SizedBox(width: 10),
              const Text(
                'Sabeq',
                style: TextStyle(
                  color: ColorT.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  letterSpacing: -0.3,
                ),
              ),

              const Spacer(),

              // Notification bell
              const NotificationBellWidget(),
              // Container(
              //   width: 36,
              //   height: 36,
              //   decoration: BoxDecoration(
              //     color: ColorT.pageBg,
              //     borderRadius: BorderRadius.circular(10),
              //     border: Border.all(color: ColorT.border, width: 0.5),
              //   ),
              //   child: const Icon(
              //     Icons.notifications_none_rounded,
              //     color: ColorT.textSecondary,
              //     size: 18,
              //   ),
              // ),
              const SizedBox(width: 8),

              // Avatar
              GestureDetector(
                onTap: onAvatarTap,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [ColorT.darkGreen, ColorT.midGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
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
                        fontWeight: FontWeight.w800,
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GREETING ROW
// ─────────────────────────────────────────────────────────────────────────────

class _GreetingRow extends StatelessWidget {
  final dynamic user;
  final AsyncValue<ProgressSummary> progress;

  const _GreetingRow({this.user, required this.progress});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final month = AppConstants.bengaliMonths[now.month - 1];
    final streak =
        progress.whenOrNull(data: (s) => s.currentMonth?.streakDays) ?? 0;

    // Bengali weekday
    const days = [
      'রবিবার',
      'সোমবার',
      'মঙ্গলবার',
      'বুধবার',
      'বৃহস্পতিবার',
      'শুক্রবার',
      'শনিবার'
    ];
    final weekday = days[now.weekday % 7];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text block
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('🌙', style: TextStyle(fontSize: 11)),
                  const SizedBox(width: 4),
                  Text(
                    'আস-সালামু আলাইকুম',
                    style: const TextStyle(
                      color: ColorT.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                user?.name?.split(' ').first ?? 'বন্ধু',
                style: const TextStyle(
                  color: ColorT.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 26,
                  height: 1.1,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$weekday, ${now.day} $month ${now.year}',
                style: const TextStyle(
                  color: ColorT.textSecondary,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),

        // Streak pill
        if (streak > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: ColorT.goldLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: ColorT.goldBorder, width: 0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🔥', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 5),
                Text(
                  '$streak দিন',
                  style: const TextStyle(
                    color: Color(0xFFE65100),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CTA CARD — primary action card (dark green)
// ─────────────────────────────────────────────────────────────────────────────

class _CtaCard extends StatelessWidget {
  final ProgressSummary? summary;
  final VoidCallback onTap;

  const _CtaCard({this.summary, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasToday = summary?.todayEntry != null &&
        (summary?.todayEntry?.totalPoints ?? 0) > 0;
    final pct =
        (summary?.currentMonth?.completionPercentage ?? 0).clamp(0.0, 100.0);
    final now = DateTime.now();
    final month = AppConstants.bengaliMonths[now.month - 1];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorT.darkGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              left: 30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.15), width: 0.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 10,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'আজকের আমল',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.65),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Title
                  Text(
                    hasToday
                        ? 'আজকের আমল\nরেকর্ড করা হয়েছে ✓'
                        : 'আজ কোনো আমল\nরেকর্ড করা হয়নি',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                      letterSpacing: -0.3,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    hasToday
                        ? 'আপডেট করতে ট্যাপ করুন'
                        : 'প্রতিদিনের ট্র্যাক শুরু করুন',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Action button
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: hasToday
                          ? Colors.white.withOpacity(0.12)
                          : ColorT.gold,
                      borderRadius: BorderRadius.circular(12),
                      border: hasToday
                          ? Border.all(
                              color: Colors.white.withOpacity(0.2), width: 0.5)
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Progress bar row
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.only(top: 14),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0x1AFFFFFF), width: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '$month মাস',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: pct / 100,
                              minHeight: 5,
                              backgroundColor: Colors.white.withOpacity(0.12),
                              valueColor:
                                  const AlwaysStoppedAnimation(ColorT.gold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${pct.toInt()}%',
                          style: const TextStyle(
                            color: ColorT.gold,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
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

class _CtaCardSkeleton extends StatelessWidget {
  const _CtaCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        color: ColorT.darkGreen.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
    ).animate(onPlay: (c) => c.repeat()).shimmer(
      duration: 1400.ms,
      colors: [
        Colors.white.withOpacity(0.04),
        Colors.white.withOpacity(0.1),
        Colors.white.withOpacity(0.04),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STAT STRIP — 2-column grid
// ─────────────────────────────────────────────────────────────────────────────

class _StatStrip extends StatelessWidget {
  final ProgressSummary? summary;

  const _StatStrip({this.summary});

  @override
  Widget build(BuildContext context) {
    final totalPts = summary?.currentMonth?.totalPoints ?? 0;
    final daysCompleted = summary?.currentMonth?.daysCompleted ?? 0;
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.stars_rounded,
            iconBg: ColorT.greenLight,
            iconColor: ColorT.green,
            value: '$totalPts',
            label: 'এই মাসের পয়েন্ট',
            badge: '+১২%',
            badgeGreen: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle_outline_rounded,
            iconBg: ColorT.amberLight,
            iconColor: ColorT.amber,
            value: '$daysCompleted',
            label: 'সম্পন্ন দিন',
            badge: '$daysCompleted/$daysInMonth',
            badgeGreen: false,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String value, label, badge;
  final bool badgeGreen;

  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.badge,
    required this.badgeGreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorT.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorT.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeGreen ? ColorT.greenLight : ColorT.pageBg,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: badgeGreen ? ColorT.green : ColorT.textSecondary,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: ColorT.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: ColorT.textSecondary,
              fontSize: 10,
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
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 96,
            decoration: BoxDecoration(
              color: ColorT.cardBg,
              borderRadius: BorderRadius.circular(16),
            ),
          ).animate(onPlay: (c) => c.repeat()).shimmer(
            duration: 1200.ms,
            colors: [ColorT.cardBg, const Color(0xFFE8ECE8), ColorT.cardBg],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 96,
            decoration: BoxDecoration(
              color: ColorT.cardBg,
              borderRadius: BorderRadius.circular(16),
            ),
          ).animate(onPlay: (c) => c.repeat()).shimmer(
            duration: 1200.ms,
            delay: 80.ms,
            colors: [ColorT.cardBg, const Color(0xFFE8ECE8), ColorT.cardBg],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title, emoji;
  final VoidCallback onSeeAll;

  const _SectionHeader({
    required this.title,
    required this.emoji,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 7),
        Text(
          title,
          style: const TextStyle(
            color: ColorT.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 15,
            letterSpacing: -0.2,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onSeeAll,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: ColorT.greenLight,
              borderRadius: BorderRadius.circular(99),
            ),
            child: const Text(
              'সব দেখুন →',
              style: TextStyle(
                color: ColorT.darkGreen,
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

// ─────────────────────────────────────────────────────────────────────────────
// MONTHLY PROGRESS LIST
// ─────────────────────────────────────────────────────────────────────────────

class _MonthList extends StatelessWidget {
  final List<MonthlyTracker> trackers;

  const _MonthList({required this.trackers});

  @override
  Widget build(BuildContext context) {
    final items = trackers.take(3).toList();

    return Container(
      decoration: BoxDecoration(
        color: ColorT.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorT.border, width: 0.5),
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final t = items[i];
          final month = AppConstants.bengaliMonths[t.month - 1];
          final pct = (t.completionPercentage / 100).clamp(0.0, 1.0);
          final barColor = pct > 0.7
              ? ColorT.green
              : pct > 0.4
                  ? ColorT.amber
                  : ColorT.red;
          final isLast = i == items.length - 1;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(
                      bottom: BorderSide(color: ColorT.border, width: 0.5),
                    ),
            ),
            child: Row(
              children: [
                // Color dot
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: barColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),

                // Month name
                SizedBox(
                  width: 48,
                  child: Row(
                    children: [
                      Text(
                        month,
                        style: const TextStyle(
                          color: ColorT.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      if (t.isWinner) ...[
                        const SizedBox(width: 4),
                        const Text('🏆', style: TextStyle(fontSize: 10)),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Progress bar
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 5,
                          backgroundColor: ColorT.pageBg,
                          valueColor: AlwaysStoppedAnimation(barColor),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${(pct * 100).toInt()}% সম্পন্ন',
                        style: const TextStyle(
                          color: ColorT.textHint,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
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
                      '${t.totalPoints}',
                      style: TextStyle(
                        color: barColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        height: 1,
                      ),
                    ),
                    Text(
                      'pts',
                      style: TextStyle(
                        color: barColor.withOpacity(0.55),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: i * 60));
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LEADERBOARD LIST
// ─────────────────────────────────────────────────────────────────────────────

class _LeaderboardList extends StatelessWidget {
  final List entries;

  const _LeaderboardList({required this.entries});

  static const _emojis = ['🥇', '🥈', '🥉'];
  static const _rankColors = [
    ColorT.rankGold,
    ColorT.rankSilver,
    ColorT.rankBronze
  ];
  static const _rankBg = [
    Color(0xFFFFFBF0),
    Color(0xFFF8FAFC),
    Color(0xFFFFF7ED),
  ];
  static const _avatarColors = [
    Color(0xFF0E3D22),
    Color(0xFF374151),
    Color(0xFF7C3AED),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorT.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorT.border, width: 0.5),
      ),
      child: Column(
        children: List.generate(entries.length, (i) {
          final entry = entries[i];
          final isLast = i == entries.length - 1;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: _rankBg[i],
              borderRadius: BorderRadius.vertical(
                top: i == 0 ? const Radius.circular(16) : Radius.zero,
                bottom: isLast ? const Radius.circular(16) : Radius.zero,
              ),
              border: isLast
                  ? null
                  : const Border(
                      bottom: BorderSide(color: ColorT.border, width: 0.5),
                    ),
            ),
            child: Row(
              children: [
                // Rank emoji
                SizedBox(
                  width: 28,
                  child: Text(
                    _emojis[i],
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 8),

                // Avatar
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _avatarColors[i],
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
                const SizedBox(width: 10),

                // Name + department
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.name?.split(' ').first ?? '',
                        style: const TextStyle(
                          color: ColorT.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (entry?.id != null || entry?.district != null) ...[
                        Text(
                          'ID: ${entry?.id ?? ''} • ${entry?.district ?? ''}',
                          style: const TextStyle(
                            color: ColorT.textSecondary,
                            fontSize: 9.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // Points badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _rankColors[i].withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${entry.totalPoints}',
                        style: TextStyle(
                          color: _rankColors[i],
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          height: 1,
                        ),
                      ),
                      Text(
                        'pts',
                        style: TextStyle(
                          color: _rankColors[i].withOpacity(0.55),
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: i * 60));
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        color: ColorT.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorT.border, width: 0.5),
      ),
    ).animate(onPlay: (c) => c.repeat()).shimmer(
      duration: 1200.ms,
      colors: [ColorT.cardBg, const Color(0xFFE8ECE8), ColorT.cardBg],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String label;

  const _EmptyCard({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: ColorT.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorT.border, width: 0.5),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: ColorT.textHint,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM NAVIGATION BAR
// ─────────────────────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int currentIndex;

  const _BottomNav({required this.currentIndex});

  static const _items = [
    _NavItem(icon: Icons.home_rounded, label: 'হোম'),
    _NavItem(icon: Icons.list_alt_rounded, label: 'ট্র্যাকার'),
    _NavItem(icon: Icons.bar_chart_rounded, label: 'রিপোর্ট'),
    _NavItem(icon: Icons.emoji_events_rounded, label: 'র‍্যাংকিং'),
  ];

  static const _routes = [
    AppRoutes.home,
    AppRoutes.tracker,
    AppRoutes.monthlyView,
    AppRoutes.leaderboard,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorT.cardBg,
        border: Border(
          top: BorderSide(color: ColorT.border, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final active = i == currentIndex;
              return GestureDetector(
                onTap: () {
                  if (!active) context.go(_routes[i]);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: active ? ColorT.greenLight : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _items[i].icon,
                        size: 22,
                        color: active ? ColorT.darkGreen : ColorT.textSecondary,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _items[i].label,
                        style: TextStyle(
                          color:
                              active ? ColorT.darkGreen : ColorT.textSecondary,
                          fontSize: 9,
                          fontWeight:
                              active ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

// ─────────────────────────────────────────────────────────────────────────────
// PROFILE SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileSheet2 extends ConsumerWidget {
  // ← was StatelessWidget
  final dynamic user;

  const _ProfileSheet2({this.user}); // ← no 'ref' param

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ← ref from framework
    return Container(
      decoration: const BoxDecoration(
        color: ColorT.cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: ColorT.border,
              borderRadius: BorderRadius.circular(99),
            ),
          ),

          const SizedBox(height: 24),

          // Avatar
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              color: ColorT.darkGreen,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                (user?.name?.isNotEmpty == true)
                    ? user!.name[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            user?.name ?? '',
            style: const TextStyle(
              color: ColorT.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          if (user?.email != null) ...[
            const SizedBox(height: 2),
            Text(
              user!.email,
              style: const TextStyle(
                color: ColorT.textSecondary,
                fontSize: 12,
              ),
            ),
          ],

          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.all(12),
          //   margin: const EdgeInsets.symmetric(vertical: 8),
          //   decoration: BoxDecoration(
          //     color: ColorT.greenLight,
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Column(
          //     children: [
          //       // User ID Row
          //       Row(
          //         children: [
          //           const Icon(
          //             Icons.badge_outlined,
          //             size: 16,
          //             color: ColorT.darkGreen,
          //           ),
          //           const SizedBox(width: 8),
          //           const Text(
          //             'ইউজার আইডি:',
          //             style: TextStyle(
          //               fontSize: 13,
          //               fontWeight: FontWeight.w600,
          //               color: ColorT.darkGreen,
          //             ),
          //           ),
          //           const SizedBox(width: 8),
          //           Expanded(
          //             child: Text(
          //               user?.id?.toString() ?? 'N/A',
          //               style: const TextStyle(
          //                 fontSize: 13,
          //                 color: ColorT.darkGreen,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //       const SizedBox(height: 8),
          //       // District Row
          //       Row(
          //         children: [
          //           const Icon(
          //             Icons.location_on_outlined,
          //             size: 16,
          //             color: ColorT.darkGreen,
          //           ),
          //           const SizedBox(width: 8),
          //           const Text(
          //             'জেলা:',
          //             style: TextStyle(
          //               fontSize: 13,
          //               fontWeight: FontWeight.w600,
          //               color: ColorT.darkGreen,
          //             ),
          //           ),
          //           const SizedBox(width: 8),
          //           Expanded(
          //             child: Text(
          //               user?.district ?? 'N/A',
          //               style: const TextStyle(
          //                 fontSize: 13,
          //                 color: ColorT.darkGreen,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),

          if (user?.id != null || user?.district != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ColorT.greenLight,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                'ID: ${user?.id ?? ''} • ${user?.district ?? ''}',
                style: const TextStyle(
                  color: ColorT.darkGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],

          const SizedBox(height: 20),
          const Divider(color: ColorT.border, height: 1),
          const SizedBox(height: 14),

          // Logout button
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                invalidateUserProviders(ref);
                await ref.read(authProvider.notifier).logout();
              },
              // onPressed: () async {
              //   // 1. Close the sheet immediately — snappy UX
              //   Navigator.pop(context);

              //   // 2. logout() now:
              //   //    a) deletes storage
              //   //    b) sets state = AuthState()  → isAuthenticated = false
              //   //    c) fires API call in background (no await)
              //   //    The router's redirect() sees isAuthenticated = false
              //   //    and navigates to login INSTANTLY — no manual context.go() needed.
              //   await ref.read(authProvider.notifier).logout();
              // },
              icon: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFDC2626),
                size: 18,
              ),
              label: const Text(
                'লগআউট',
                style: TextStyle(
                  color: Color(0xFFDC2626),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: const Color(0xFFFEF2F2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
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
// PUBLIC ALIAS (kept for compatibility)
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
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: ColorT.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
        GestureDetector(
          onTap: onAction,
          child: Text(
            action,
            style: const TextStyle(
              color: ColorT.darkGreen,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
