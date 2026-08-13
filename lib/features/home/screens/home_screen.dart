import 'package:amal_tracker/features/challenge/provider/challenge_provider.dart';
import 'package:amal_tracker/features/challenge/widgets/challenge_card.dart';
import 'package:amal_tracker/features/home/widgets/daily_cards_section.dart';
import 'package:amal_tracker/features/home/widgets/join_community_section.dart';
import 'package:amal_tracker/features/monthly_summary/screens/category_progress_screen.dart';
import 'package:amal_tracker/features/sadakah/screens/sadakah_screen.dart';
import 'package:amal_tracker/features/sadakah/widgets/sadakah_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../auth/providers/auth_provider.dart';
import '../../tracker/providers/tracker_provider.dart';
import '../../tracker/models/tracker_model.dart';
import '../../leaderboard/providers/leaderboard_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../notification/widgets/notification_widgets.dart';
import '../../home/widgets/profile_sheet.dart';
import '../../../core/providers/cache_provider.dart';
import '../../../shared/widgets/delayed_progress_indicator.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP-WIDE CONSTANTS
// ─────────────────────────────────────────────────────────────────────────────
// NOTE: replace with the real published package id before release. Kept as a
// single constant (instead of being hardcoded in two places) so there's only
// one spot to update.
const String _kPlayStorePackageId = 'com.yourcompany.sabeq';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────
// SKELETON SHIMMER HELPER — একটাই shared shimmer wrapper, সব placeholder
// widget এই দিয়েই animate হয় যাতে shimmer timing সব জায়গায় sync থাকে।
// ─────────────────────────────────────────────────────────────────────────────

class _Shimmer extends StatelessWidget {
  final Widget child;
  const _Shimmer({required this.child});

  @override
  Widget build(BuildContext context) {
    return child
        .animate(onPlay: (c) => c.repeat())
        .shimmer(duration: 1300.ms, colors: [
      Colors.transparent,
      Colors.white.withOpacity(0.55),
      Colors.transparent,
    ]);
  }
}

class _Bone extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color? color;
  const _Bone({
    required this.width,
    required this.height,
    this.radius = 6,
    this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: color ?? context.colors.skelBase,
            borderRadius: BorderRadius.circular(radius)),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED HELPERS
// ─────────────────────────────────────────────────────────────────────────────

/// Single-letter avatar fallback used by both the top bar and the leaderboard
/// list, so the "first letter or U" rule only lives in one place.
String _avatarInitial(String? name) =>
    (name != null && name.isNotEmpty) ? name[0].toUpperCase() : 'U';

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
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    // Update last fetched timestamp for Home tab cache domain
    ref.read(cacheStatusProvider.notifier).updateLastFetched(CacheTab.home);
    try {
      await Future.wait([
        ref.refresh(homeSummaryProvider.future),
        ref.read(leaderboardPreviewProvider.notifier).refresh(),
      ]);
    } catch (_) {
      if (!mounted) return;
      _showSnack(
        'রিফ্রেশ করা যায়নি। আবার চেষ্টা করুন।',
        actionLabel: 'আবার',
        onAction: _refresh,
      );
    }
  }

  void _showSnack(String message,
      {String? actionLabel, VoidCallback? onAction}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          action: (actionLabel != null && onAction != null)
              ? SnackBarAction(
                  label: actionLabel,
                  textColor: Colors.white,
                  onPressed: onAction,
                )
              : null,
        ),
      );
  }

  void _showProfile() => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => ProfileSheet(user: ref.read(currentUserProvider)),
      );

  Future<void> _handleRateApp() async {
    try {
      final review = InAppReview.instance;
      if (await review.isAvailable()) {
        await review.requestReview();
        return;
      }
      final uri = Uri.parse(
          'https://play.google.com/store/apps/details?id=$_kPlayStorePackageId');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (mounted) {
        _showSnack('Play Store খোলা যায়নি।');
      }
    } catch (_) {
      if (mounted) _showSnack('রেটিং পেজ খোলা যায়নি। আবার চেষ্টা করুন।');
    }
  }

  Future<void> _handleShareApp() async {
    try {
      await Share.share(
        'Sabeq — নেক আমল ট্র্যাক করুন, নিজের অগ্রগতি দেখুন!\n\n'
        '📲 ডাউনলোড করুন:\nhttps://play.google.com/store/apps/details?id=$_kPlayStorePackageId',
        subject: 'Sabeq অ্যাপ — নেক আমলে এগিয়ে যাও',
      );
    } catch (_) {
      if (mounted) _showSnack('শেয়ার করা যায়নি। আবার চেষ্টা করুন।');
    }
  }

  // ── Section builders ────────────────────────────────────────────────────
  // Each builder follows the same "stale-first" rule: if we already have any
  // data (even while a background refresh is in flight or the refresh
  // failed), we keep showing that data instead of dropping back to a
  // skeleton or an error card. This is the home tab — the very first thing
  // people see — so it should feel stable, not flickery.

  Widget _buildHeroSection(AsyncValue<HomeSummary> summary) {
    if (summary.hasValue) {
      return _HeroCard(
          summary: summary.value, onTap: () => context.go(AppRoutes.tracker));
    }
    if (summary.isLoading) {
      return const _HeroSkeleton();
    }
    // No data has ever loaded and the last attempt failed — still render the
    // real card in its "no record yet" shape rather than a separate error
    // card, since the hero is the main visual anchor of the page.
    return _HeroCard(summary: null, onTap: () => context.go(AppRoutes.tracker));
  }

  Widget _buildWeeklySection(AsyncValue<HomeSummary> summary) {
    if (summary.hasValue) {
      return _WeeklyHabitsSnapshot(summary: summary.value);
    }
    if (summary.isLoading) {
      return const _WeekSkeleton();
    }
    return _SectionErrorCard(
      label: 'সাপ্তাহিক অভ্যাস লোড করা সম্ভব হয়নি',
      onRetry: () => ref.refresh(homeSummaryProvider),
    );
  }

  Widget _buildMonthlySection(AsyncValue<HomeSummary> summary) {
    if (summary.hasValue) {
      final recentMonths = summary.value!.recentMonths;
      if (recentMonths.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SecHead(
              title: 'মাসিক অগ্রগতি',
              emoji: '📅',
              onSeeAll: () => context.go(AppRoutes.monthlyView),
            ),
            const SizedBox(height: 10),
            const _EmptyCard(label: 'কোনো মাসিক অগ্রগতির তথ্য নেই'),
            const SizedBox(height: 20),
          ],
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SecHead(
            title: 'মাসিক অগ্রগতি',
            emoji: '📅',
            onSeeAll: () => context.go(AppRoutes.monthlyView),
          ).animate().fadeIn(delay: 135.ms),
          const SizedBox(height: 10),
          _MonthHistoryList(months: recentMonths)
              .animate()
              .fadeIn(delay: 148.ms),
          const SizedBox(height: 20),
        ],
      );
    }

    if (summary.isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SecHeadSkeleton(emoji: '📅', title: 'মাসিক অগ্রগতি'),
          const SizedBox(height: 10),
          const _MonthHistorySkeleton(),
          const SizedBox(height: 20),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SecHead(
          title: 'মাসিক অগ্রগতি',
          emoji: '📅',
          onSeeAll: () => context.go(AppRoutes.monthlyView),
        ),
        const SizedBox(height: 10),
        _SectionErrorCard(
          label: 'মাসিক অগ্রগতি লোড করা যায়নি',
          onRetry: () => ref.refresh(homeSummaryProvider),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLeaderboardSection(dynamic board) {
    if (board.entries.isNotEmpty) {
      return _LeaderList(
        entries: board.entries.take(3).toList(),
        currentUserId: ref.read(currentUserProvider)?.id,
      );
    }
    if (board.isLoading) {
      return const _LeaderboardSkeleton();
    }
    if (board.error != null) {
      return _SectionErrorCard(
        label: 'শীর্ষ তালিকা লোড করা যায়নি',
        onRetry: () => ref.read(leaderboardPreviewProvider.notifier).refresh(),
      );
    }
    return const _EmptyCard(label: 'কোনো শীর্ষ তালিকার তথ্য নেই');
  }

  @override
  Widget build(BuildContext context) {
    // Clamp system text scaling so a very large accessibility font setting
    // can't break the compact card layouts on this screen, while still
    // letting people scale text up/down within a reasonable range.
    final mq = MediaQuery.of(context);
    return MediaQuery(
      data: mq.copyWith(
        textScaler:
            mq.textScaler.clamp(minScaleFactor: 0.9, maxScaleFactor: 1.25),
      ),
      child: _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    ref.watch(cacheStatusProvider); // Watch to rebuild on lifecycle/app resume
    // Lazy check-and-refresh for Home Tab data
    final activeIndex = ref.watch(activeTabIndexProvider);
    if (activeIndex == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          checkAndRefreshTab(ref, CacheTab.home, () {
            ref.refresh(homeSummaryProvider);
            ref.read(leaderboardPreviewProvider.notifier).refresh();
          }, ttl: const Duration(minutes: 5));
        }
      });
    }

    final user = ref.watch(currentUserProvider);
    // আগে progressSummaryProvider(year, month) — মাসিক স্ক্রিনের ভারী endpoint
    // ব্যবহার হতো শুধু home এর জন্য। এখন homeSummaryProvider — কোনো
    // category catalog, categoryStats, recentMonths ছাড়া হালকা payload।
    final summary = ref.watch(homeSummaryProvider);
    final board = ref.watch(leaderboardPreviewProvider);

    final isBackgroundRefreshing = (summary.isLoading && summary.hasValue) ||
        (board.isLoading && board.entries.isNotEmpty);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: context.colors.pageBg,
        appBar: _TopBar(user: user, onAvatarTap: _showProfile),
        body: Stack(
          children: [
            RefreshIndicator(
              color: context.colors.darkGreen,
              onRefresh: _refresh,
              child: CustomScrollView(
                controller: _sc,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 90),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // ── 1. Greeting ──────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: _Greeting(user: user, summary: summary)
                              .animate()
                              .fadeIn(duration: 280.ms),
                        ),
                        const SizedBox(height: 12),

                        // ── 2. Hero Card ─────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: _buildHeroSection(summary)
                              .animate()
                              .fadeIn(delay: 50.ms, duration: 300.ms),
                        ),

                        const SizedBox(height: 10),

                        // ── 3. Weekly Strip ───────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: _buildWeeklySection(summary)
                              .animate()
                              .fadeIn(delay: 90.ms, duration: 280.ms),
                        ),

                        const SizedBox(height: 11),
                        const DailyCardsSection(),

                        const SizedBox(height: 11),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Column(children: [
                            // ── 5. Monthly History ──────────────────────────────
                            _buildMonthlySection(summary),

                            // ── 6. Leaderboard teaser ───────────────────────────
                            _SecHead(
                              title: 'শীর্ষ তালিকা',
                              emoji: '🏆',
                              onSeeAll: () => context.go(AppRoutes.leaderboard),
                            ).animate().fadeIn(delay: 165.ms),
                            const SizedBox(height: 10),
                            _buildLeaderboardSection(board)
                                .animate()
                                .fadeIn(delay: 178.ms),
                            const SizedBox(height: 20),

                            // ── 6.5 চ্যালেঞ্জ teaser ───────────────────────────
                            Consumer(
                              builder: (context, ref, _) {
                                final challenges =
                                    ref.watch(activeChallengesProvider);

                                if (challenges.hasValue) {
                                  final list = challenges.value!;
                                  final activeChallenges = list
                                      .where((c) => !c.isCompleted)
                                      .toList();

                                  if (activeChallenges.isEmpty) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _SecHead(
                                          title: 'চ্যালেঞ্জসমূহ',
                                          emoji: '⚔️',
                                          onSeeAll: () =>
                                              context.go(AppRoutes.challenges),
                                        ),
                                        const SizedBox(height: 10),
                                        const _EmptyCard(
                                            label: 'কোনো চলমান চ্যালেঞ্জ নেই'),
                                      ],
                                    );
                                  }

                                  final sorted = [...activeChallenges]
                                    ..sort((a, b) {
                                      if (a.isJoined != b.isJoined) {
                                        return a.isJoined ? -1 : 1;
                                      }
                                      return a.endDate.compareTo(b.endDate);
                                    });
                                  final top = sorted.first;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _SecHead(
                                        title: 'চ্যালেঞ্জসমূহ',
                                        emoji: '⚔️',
                                        onSeeAll: () =>
                                            context.go(AppRoutes.challenges),
                                      ),
                                      const SizedBox(height: 10),
                                      ChallengeHomeTeaser(
                                        challenge: top,
                                        totalActiveCount: sorted.length,
                                        onTap: () =>
                                            context.go(AppRoutes.challenges),
                                      ),
                                    ],
                                  );
                                }

                                if (challenges.isLoading) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _SecHead(
                                        title: 'চ্যালেঞ্জসমূহ',
                                        emoji: '⚔️',
                                        onSeeAll: () =>
                                            context.go(AppRoutes.challenges),
                                      ),
                                      const SizedBox(height: 10),
                                      const ChallengeHomeTeaserSkeleton(),
                                    ],
                                  );
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _SecHead(
                                      title: 'চ্যালেঞ্জসমূহ',
                                      emoji: '⚔️',
                                      onSeeAll: () =>
                                          context.go(AppRoutes.challenges),
                                    ),
                                    const SizedBox(height: 10),
                                    _SectionErrorCard(
                                      label: 'চ্যালেঞ্জসমূহ লোড করা যায়নি',
                                      onRetry: () =>
                                          ref.refresh(activeChallengesProvider),
                                    ),
                                  ],
                                );
                              },
                            ).animate().fadeIn(delay: 185.ms),

                            const SizedBox(height: 20),

                            SadaqahBanner(),

                            // ── 7.5 কমিউনিটিতে যুক্ত হন
                            //
                            // ──────────────────────────

                            const SizedBox(height: 20),

                            JoinCommunitySection()
                                .animate()
                                .fadeIn(delay: 196.ms),

                            const SizedBox(height: 20),

                            // ── 7. Community ───────────────────────────────────
                            _CommunityRow(
                                    onRate: _handleRateApp,
                                    onShare: _handleShareApp)
                                .animate()
                                .fadeIn(delay: 192.ms),
                            const SizedBox(height: 20),

                            // ── 8. How it works ─────────────────────────────────
                            // Note: uses context.push (vs. context.go elsewhere)
                            // intentionally — this is a stacked detail page, not
                            // a bottom-tab destination, so it should be poppable
                            // back to Home rather than replacing the tab route.
                            _HowItWorks(
                                    onTap: () =>
                                        context.push(AppRoutes.howItWorks))
                                .animate()
                                .fadeIn(delay: 200.ms),
                          ]),
                        )
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            if (isBackgroundRefreshing)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 2,
                  child: DelayedLinearProgressIndicator(
                    color: context.colors.darkGreen,
                    backgroundColor: Colors.transparent,
                    delay: Duration(milliseconds: 400),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOP BAR — অপরিবর্তিত
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic user;
  final VoidCallback onAvatarTap;
  const _TopBar({this.user, required this.onAvatarTap});

  @override
  Size get preferredSize => const Size.fromHeight(54);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.card,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 54,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: context.colors.darkGreen,
                    borderRadius: BorderRadius.circular(8)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset('assets/images/sabeq_logo.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.eco_rounded,
                          color: Colors.white,
                          size: 15)),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sabeq',
                        style: TextStyle(
                            color: context.colors.textPri,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            letterSpacing: -0.3)),
                    Text('নেক আমলে এগিয়ে যাও',
                        style: TextStyle(
                            color: context.colors.textSec2,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2)),
                  ]),
              const Spacer(),
              const NotificationBellWidget(),
              const SizedBox(width: 8),
              // const SettingsButtonWidget(),
              const SadakahButtonWidget(),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onAvatarTap,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                      color: context.colors.darkGreen,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    _avatarInitial(user?.name),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 12),
                  )),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GREETING — streak এখন সরাসরি HomeSummary.streakDays থেকে (আগে
// summary.currentMonth?.streakDays দিয়ে ProgressSummary থেকে বের করতে হতো)
// ─────────────────────────────────────────────────────────────────────────────

class _Greeting extends StatelessWidget {
  final dynamic user;
  final AsyncValue<HomeSummary> summary;
  const _Greeting({this.user, required this.summary});

  @override
  Widget build(BuildContext context) {
    final streak = summary.whenOrNull(data: (s) => s.streakDays) ?? 0;
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('আস-সালামু আলাইকুম',
            style: TextStyle(
                color: context.colors.textHint,
                fontSize: 10.5,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 1),
        Text(user?.name?.split(' ').first ?? 'বন্ধু',
            style: TextStyle(
                color: context.colors.textPri,
                fontWeight: FontWeight.w800,
                fontSize: 22,
                height: 1.1,
                letterSpacing: -0.5)),
      ])),
      if (streak > 0)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: context.colors.goldLight2,
              borderRadius: BorderRadius.circular(99),
              border:
                  Border.all(color: context.colors.goldBorder2, width: 0.5)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Text('🔥', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Text('$streak দিন',
                style: const TextStyle(
                    color: Color(0xFFE65100),
                    fontSize: 12,
                    fontWeight: FontWeight.w700)),
          ]),
        ),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HERO CARD — এখন HomeSummary থেকে সরাসরি। আগে todayEntry.entries[] ক্লায়েন্ট
// সাইডে filter করে completedCount বের করতে হতো (PrayerMode চেক করে) — এখন
// backend already summary.today.completedCount হিসেব করে পাঠায়, তাই এখানে
// আর কোনো entries লজিক নেই। জামাত চিপ বাদ দেওয়া হয়েছে — আগে hardcoded
// `final jamaat = 0;` ছিল (সবসময় ০ দেখাতো, home-summary তে congregation
// count নেই — সেটা মাসিক স্ক্রিনের Fard section এর বিষয়, এখানে দরকার নেই)।
// ─────────────────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  final HomeSummary? summary;
  final VoidCallback onTap;
  const _HeroCard({this.summary, required this.onTap});

  String _winnerLabel(String? cat) => switch (cat) {
        'TOP_FARZ' => 'ফরজ চ্যাম্পিয়ন',
        'TOP_JAMAAT' => 'জামাত চ্যাম্পিয়ন',
        'TOP_QURAN' => 'কুরআন চ্যাম্পিয়ন',
        'TOP_STREAK' => 'সেরা ধারাবাহিকতা',
        _ => 'মাসিক বিজয়ী',
      };

  @override
  Widget build(BuildContext context) {
    final today = summary?.today;
    final glance = summary?.monthGlance;
    final isFemale = summary?.userGender == 'female';

    final todayCompleted = today?.completedCount ?? 0;
    final isExempt = (today?.isExemptDay ?? false) && isFemale;
    final hasToday = todayCompleted > 0 || isExempt;

    final pct = (glance?.completionPercentage ?? 0).clamp(0.0, 100.0);
    final daysActive = glance?.daysActive ?? 0;
    final rank = glance?.rank;
    final isWinner = glance?.isWinner ?? false;
    final farzDays = glance?.farzCompletedDays ?? 0;
    final eligDays = glance?.eligibleDays ?? 0;
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final monthName = AppConstants.bengaliMonths[now.month - 1];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: context.colors.darkGreen,
            borderRadius: BorderRadius.circular(16)),
        child: Stack(children: [
          Positioned(
              top: -30,
              right: -30,
              child: Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0x08FFFFFF)))),
          Positioned(
              bottom: -15,
              left: -8,
              child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0x05FFFFFF)))),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isWinner) ...[
                    Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: context.colors.gold.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: context.colors.gold.withOpacity(0.3),
                                width: 0.5)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Text('🏆', style: TextStyle(fontSize: 10)),
                          const SizedBox(width: 5),
                          Text(_winnerLabel(glance?.winnerCategory),
                              style: TextStyle(
                                  color: context.colors.gold,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700)),
                        ])),
                  ],
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                          Row(children: [
                            Icon(Icons.wb_sunny_rounded,
                                size: 9, color: Colors.white.withOpacity(0.35)),
                            const SizedBox(width: 3),
                            Text(isExempt ? 'আজ মাহলির দিন 🌸' : 'আজকের আমল',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.4),
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w500)),
                          ]),
                          const SizedBox(height: 4),
                          if (todayCompleted > 0)
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: '$todayCompleted',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                      height: 1,
                                      letterSpacing: -1)),
                              const TextSpan(
                                  text: ' টি আমল',
                                  style: TextStyle(
                                      color: Color(0x80FFFFFF),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500)),
                            ]))
                          else if (isExempt)
                            const Text('মাহলির দিন',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    height: 1.1))
                          else
                            const Text('এখনো রেকর্ড\nহয়নি',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    height: 1.2,
                                    letterSpacing: -0.2)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: hasToday
                                  ? Colors.white.withOpacity(0.1)
                                  : context.colors.gold,
                              borderRadius: BorderRadius.circular(8),
                              border: hasToday
                                  ? Border.all(
                                      color: Colors.white.withOpacity(0.18),
                                      width: 0.5)
                                  : null,
                            ),
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(
                                  hasToday
                                      ? Icons.edit_rounded
                                      : Icons.add_rounded,
                                  color: Colors.white,
                                  size: 11),
                              const SizedBox(width: 4),
                              Text(hasToday ? 'আপডেট করুন' : 'রেকর্ড করুন',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700)),
                            ]),
                          ),
                        ])),
                    Container(
                        width: 0.5,
                        height: 72,
                        color: Colors.white.withOpacity(0.12),
                        margin: const EdgeInsets.symmetric(horizontal: 12)),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${pct.toInt()}%',
                              style: TextStyle(
                                  color: context.colors.gold,
                                  fontSize: pct >= 100 ? 22 : 24,
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                  letterSpacing: -1)),
                          const SizedBox(height: 2),
                          Text('ফরজ সম্পন্ন',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.35),
                                  fontSize: 8.5)),
                          const SizedBox(height: 6),
                          if (rank != null)
                            _RightChip(
                                top: '#$rank', bottom: 'র‍্যাংক', isRank: true),
                        ]),
                  ]),
                  const SizedBox(height: 10),
                  const Divider(
                      height: 1, thickness: 0.5, color: Color(0x1AFFFFFF)),
                  const SizedBox(height: 8),
                  Row(children: [
                    _HeroChip(
                        value: '$daysActive/$daysInMonth',
                        label: 'সক্রিয় দিন'),
                    _heroDivider(),
                    _HeroChip(
                        value: '$farzDays${eligDays > 0 ? '/$eligDays' : ''}',
                        label: 'পূর্ণ ফরজ'),
                    _heroDivider(),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(monthName,
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.35),
                                        fontSize: 8.5)),
                                const SizedBox(width: 4),
                                Text('${pct.toInt()}%',
                                    style: TextStyle(
                                        color: context.colors.gold,
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w700)),
                              ]),
                          const SizedBox(height: 3),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: LinearProgressIndicator(
                                  value: pct / 100,
                                  minHeight: 3.5,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.1),
                                  valueColor: AlwaysStoppedAnimation(
                                      context.colors.gold))),
                        ])),
                  ]),
                ]),
          ),
        ]),
      ),
    );
  }

  static Widget _heroDivider() => Container(
      width: 1,
      height: 12,
      color: Colors.white.withOpacity(0.12),
      margin: const EdgeInsets.symmetric(horizontal: 10));
}

class _RightChip extends StatelessWidget {
  final String top, bottom;
  final bool isRank;
  const _RightChip(
      {required this.top, required this.bottom, this.isRank = false});
  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(minWidth: 51),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
            color: isRank
                ? const Color(0xFF4ADE80).withOpacity(0.12)
                : Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
                color: isRank
                    ? const Color(0xFF4ADE80).withOpacity(0.25)
                    : Colors.white.withOpacity(0.1),
                width: 0.5)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(top,
              style: TextStyle(
                  color: isRank ? const Color(0xFF4ADE80) : context.colors.gold,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  height: 1)),
          const SizedBox(height: 2),
          Text(bottom,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.35), fontSize: 8)),
        ]),
      );
}

class _HeroChip extends StatelessWidget {
  final String value, label;
  const _HeroChip({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 8.5, color: Colors.white.withOpacity(0.35))),
          ]);
}

// ── real-shape hero skeleton ────────────────────────────────────────────────
// This mirrors _HeroCard's exact layout (left number block + CTA button,
// divider, right percentage + rank chip, bottom stat row + progress bar)
// instead of a single shimmering block. The hero is the main visual anchor
// of the home page, so its loading state should read as "the same card,
// still filling in" rather than a generic placeholder that jumps into a
// completely different layout once data lands.
// ─────────────────────────────────────────────────────────────────────────────

class _HeroSkeleton extends StatelessWidget {
  const _HeroSkeleton();

  static const Color _bone = Color(0x1FFFFFFF);
  static const Color _boneStrong = Color(0x33FFFFFF);

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.darkGreen,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      _Bone(width: 70, height: 9, color: _bone), // "আজকের আমল"
                      SizedBox(height: 8),
                      _Bone(
                          width: 108, height: 26, color: _boneStrong), // count
                      SizedBox(height: 10),
                      _Bone(
                          width: 96,
                          height: 26,
                          radius: 8,
                          color: _bone), // CTA button
                    ],
                  ),
                ),
                Container(
                  width: 0.5,
                  height: 72,
                  color: Colors.white.withOpacity(0.12),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    _Bone(width: 46, height: 22, color: _boneStrong), // %
                    SizedBox(height: 6),
                    _Bone(width: 56, height: 8, color: _bone), // "ফরজ সম্পন্ন"
                    SizedBox(height: 8),
                    _Bone(
                        width: 42, height: 22, radius: 7, color: _bone), // rank
                  ],
                ),
              ]),
              const SizedBox(height: 10),
              const Divider(
                  height: 1, thickness: 0.5, color: Color(0x1AFFFFFF)),
              const SizedBox(height: 8),
              Row(children: [
                _heroChipBone(),
                _dividerBone(),
                _heroChipBone(),
                _dividerBone(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _Bone(width: 60, height: 9, color: _bone),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: const _Bone(
                            width: double.infinity, height: 3.5, color: _bone),
                      ),
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _heroChipBone() => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _Bone(width: 34, height: 11, color: _boneStrong),
          SizedBox(height: 4),
          _Bone(width: 44, height: 8, color: _bone),
        ],
      );

  static Widget _dividerBone() => Container(
      width: 1,
      height: 12,
      color: Colors.white.withOpacity(0.12),
      margin: const EdgeInsets.symmetric(horizontal: 10));
}

// ─────────────────────────────────────────────────────────────────────────────
// WEEKLY HABITS SNAPSHOT — home এর জন্য সবচেয়ে হালকা ও দ্রুত-বোধগম্য ডিজাইন।
// (ব্যাখ্যা অপরিবর্তিত — নিচে দেখুন)
// ─────────────────────────────────────────────────────────────────────────────

// ── real-shape skeleton: আসল কার্ড এর chrome (header + horizontal tile
//    row) হুবহু কপি করে বসানো, ভেতরের সংখ্যা/গ্রিড bone placeholder দিয়ে।
//    এতে data আসার পর layout shift/jump হয় না — শুধু bone গুলো real
//    content দিয়ে replace হয়।
class _WeekSkeleton extends StatelessWidget {
  const _WeekSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 11, 13, 12),
      decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: context.colors.border, width: 0.5)),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text('সাপ্তাহিক অভ্যাস',
                  style: TextStyle(
                      color: context.colors.textPri,
                      fontWeight: FontWeight.w700,
                      fontSize: 11)),
              const Spacer(),
              Text('বিস্তারিত দেখতে ট্যাপ করুন',
                  style: TextStyle(
                      color: context.colors.textHint.withOpacity(0.5),
                      fontSize: 8.5,
                      fontWeight: FontWeight.w500)),
            ]),
            const SizedBox(height: 10),
            SizedBox(
              height: 148,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  _WeekTileSkeleton(width: 168, rows: 5), // fard shape
                  SizedBox(width: 8),
                  _WeekTileSkeleton(width: 168, rows: 2), // dhikr shape
                  SizedBox(width: 8),
                  _WeekTileSkeleton(width: 140, rows: 0), // numeric/bar shape
                ],
              ),
            ),
          ]),
    );
  }
}

class _WeekTileSkeleton extends StatelessWidget {
  final double width;
  final int rows; // 5=fard grid, 2=dhikr grid, 0=bar chart shape
  const _WeekTileSkeleton({required this.width, required this.rows});

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: Container(
        width: width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.colors.pageBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.border, width: 0.6),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                const _Bone(width: 14, height: 14, radius: 4),
                const SizedBox(width: 5),
                const _Bone(width: 60, height: 9),
                const Spacer(),
                const _Bone(width: 10, height: 10, radius: 3),
              ]),
              const SizedBox(height: 6),
              const _Bone(width: 90, height: 10),
              const SizedBox(height: 8),
              if (rows > 0)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(rows, (r) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                              7,
                              (c) => _Bone(
                                  width: rows == 2 ? 14 : 12,
                                  height: rows == 2 ? 14 : 12,
                                  radius: rows == 2 ? 7 : 3,
                                  color: context.colors.skelBaseDark)));
                    }),
                  ),
                )
              else
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (i) {
                      final h = 14.0 + ((i * 37) % 50);
                      return _Bone(
                          width: 11,
                          height: h,
                          radius: 3,
                          color: context.colors.skelBaseDark);
                    }),
                  ),
                ),
            ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION HEADER — অপরিবর্তিত, প্লাস একটা skeleton ভ্যারিয়েন্ট (see-all
// chip এখনো clickable নয় তাই bone দিয়ে replace করা)
// ─────────────────────────────────────────────────────────────────────────────

class _SecHead extends StatelessWidget {
  final String title, emoji;
  final VoidCallback onSeeAll;
  const _SecHead(
      {required this.title, required this.emoji, required this.onSeeAll});

  @override
  Widget build(BuildContext context) => Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 6),
        Text(title,
            style: TextStyle(
                color: context.colors.textPri,
                fontWeight: FontWeight.w800,
                fontSize: 13,
                letterSpacing: -0.1)),
        const Spacer(),
        GestureDetector(
            onTap: onSeeAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: context.colors.greenLight,
                  borderRadius: BorderRadius.circular(99)),
              child: Text('সব দেখুন →',
                  style: TextStyle(
                      color: context.colors.darkGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.w700)),
            )),
      ]);
}

class _SecHeadSkeleton extends StatelessWidget {
  final String title, emoji;
  const _SecHeadSkeleton({required this.title, required this.emoji});

  @override
  Widget build(BuildContext context) => Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 6),
        Text(title,
            style: TextStyle(
                color: context.colors.textPri,
                fontWeight: FontWeight.w800,
                fontSize: 13,
                letterSpacing: -0.1)),
        const Spacer(),
        _Shimmer(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
                color: context.colors.skelBase,
                borderRadius: BorderRadius.circular(99)),
            child: _Bone(
                width: 46, height: 10, color: context.colors.skelBaseDark),
          ),
        ),
      ]);
}

// ─────────────────────────────────────────────────────────────────────────────
// MONTH HISTORY LIST — recentMonths (RecentMonthSummary) থেকে ৩ মাসের serial
// progress list। (ব্যাখ্যা অপরিবর্তিত)
// ─────────────────────────────────────────────────────────────────────────────

class _MonthHistoryList extends StatelessWidget {
  final List<RecentMonthSummary> months;
  const _MonthHistoryList({required this.months});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.colors.border, width: 0.5)),
      child: Column(
          children: List.generate(months.length, (i) {
        final t = months[i];
        final monthName = AppConstants.bengaliMonths[t.month - 1];
        final pct = (t.completionPercentage / 100).clamp(0.0, 1.0);
        final color = pct > 0.7
            ? context.colors.green
            : pct > 0.4
                ? context.colors.amber
                : context.colors.red;
        final isLast = i == months.length - 1;
        final now = DateTime.now();
        final totalD = DateUtils.getDaysInMonth(now.year, t.month);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
              border: isLast
                  ? null
                  : Border(
                      bottom: BorderSide(
                          color: context.colors.border, width: 0.5))),
          child: Row(children: [
            Container(
                width: 7,
                height: 7,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 10),
            SizedBox(
                width: 52,
                child: Row(children: [
                  Flexible(
                      child: Text(monthName,
                          style: TextStyle(
                              color: context.colors.textPri,
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                          overflow: TextOverflow.ellipsis)),
                  if (t.isWinner) ...[
                    const SizedBox(width: 3),
                    const Text('🏆', style: TextStyle(fontSize: 9))
                  ],
                ])),
            const SizedBox(width: 8),
            Text('${t.daysActive}/$totalD দিন',
                style:
                    TextStyle(color: context.colors.textHint, fontSize: 9.5)),
            const SizedBox(width: 8),
            Expanded(
                child: Row(children: [
              Expanded(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 4,
                          backgroundColor: context.colors.pageBg,
                          valueColor: AlwaysStoppedAnimation(color)))),
              const SizedBox(width: 6),
              Text('${(pct * 100).toInt()}%',
                  style: TextStyle(
                      color: color,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700)),
            ])),
            const SizedBox(width: 10),
            Text('${t.farzCompletedDays}',
                style: TextStyle(
                    color: context.colors.textPri,
                    fontWeight: FontWeight.w800,
                    fontSize: 13)),
            const SizedBox(width: 2),
            Text('ফরজ',
                style: TextStyle(
                    color: context.colors.textHint,
                    fontSize: 9,
                    fontWeight: FontWeight.w600)),
          ]),
        ).animate().fadeIn(delay: Duration(milliseconds: i * 50));
      })),
    );
  }
}

// ── real-shape skeleton: প্রতিটা row হুবহু _MonthHistoryList এর row shape
//    (dot + month label + "X/Y দিন" + progress bar + % + ফরজ সংখ্যা) কপি
//    করে bone দিয়ে বসানো, যাতে ডেটা লোড হওয়ার পর layout একই থাকে।
class _MonthHistorySkeleton extends StatelessWidget {
  const _MonthHistorySkeleton();

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: Container(
        decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.colors.border, width: 0.5)),
        child: Column(
          children: List.generate(3, (i) {
            final isLast = i == 2;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                  border: isLast
                      ? null
                      : Border(
                          bottom: BorderSide(
                              color: context.colors.border, width: 0.5))),
              child: Row(children: [
                _Bone(
                    width: 7,
                    height: 7,
                    radius: 99,
                    color: context.colors.skelBaseDark),
                const SizedBox(width: 10),
                const SizedBox(width: 52, child: _Bone(width: 40, height: 12)),
                const SizedBox(width: 8),
                const _Bone(width: 44, height: 9),
                const SizedBox(width: 8),
                Expanded(
                    child: Row(children: [
                  Expanded(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: _Bone(
                              width: double.infinity,
                              height: 4,
                              color: context.colors.skelBaseDark))),
                  const SizedBox(width: 6),
                  const _Bone(width: 26, height: 9),
                ])),
                const SizedBox(width: 10),
                const _Bone(width: 16, height: 13),
                const SizedBox(width: 2),
                const _Bone(width: 20, height: 9),
              ]),
            );
          }),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LEADERBOARD LIST — সম্পূর্ণ আলাদা concept, কোনো পরিবর্তন হয়নি
// ─────────────────────────────────────────────────────────────────────────────

class _LeaderList extends StatelessWidget {
  final List entries;
  final String? currentUserId;
  const _LeaderList({required this.entries, this.currentUserId});

  static const _emojis = ['🥇', '🥈', '🥉'];
  List<Color> _rankColors(BuildContext context) => [
        context.colors.rankGold,
        context.colors.rankSilver,
        context.colors.rankBronze
      ];
  List<Color> _rowBg(BuildContext context) => [
        context.colors.goldPale,
        const Color(0xFFF8FAFC),
        const Color(0xFFFFF7ED)
      ];
  List<Color> _avatarBg(BuildContext context) =>
      [context.colors.avatar1, context.colors.avatar2, context.colors.avatar3];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.colors.border, width: 0.5)),
      child: Column(
          children: List.generate(entries.length, (i) {
        final e = entries[i];
        final isLast = i == entries.length - 1;
        final isMe =
            currentUserId != null && e.userId?.toString() == currentUserId;
        final pct = (e.completionPercentage as num?)?.toInt() ?? 0;
        final farz = (e.farzCompletedDays as num?)?.toInt() ?? 0;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: _rowBg(context)[i],
            borderRadius: BorderRadius.vertical(
              top: i == 0 ? const Radius.circular(14) : Radius.zero,
              bottom: isLast ? const Radius.circular(14) : Radius.zero,
            ),
            border: isLast
                ? null
                : Border(
                    bottom:
                        BorderSide(color: context.colors.border, width: 0.5)),
          ),
          child: Row(children: [
            SizedBox(
                width: 22,
                child: Text(_emojis[i],
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center)),
            const SizedBox(width: 8),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: _avatarBg(context)[i],
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                  child: Text(
                _avatarInitial(e.name as String?),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12),
              )),
            ),
            const SizedBox(width: 8),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Flexible(
                        child: Text(e.name?.split(' ').first ?? '',
                            style: TextStyle(
                                color: context.colors.textPri,
                                fontWeight: FontWeight.w700,
                                fontSize: 12),
                            overflow: TextOverflow.ellipsis)),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                            color: context.colors.greenLight,
                            borderRadius: BorderRadius.circular(99)),
                        child: Text('আপনি',
                            style: TextStyle(
                                color: context.colors.darkGreen,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ]),
                  if ((e.id ?? '').toString().isNotEmpty ||
                      (e.district ?? '').toString().isNotEmpty)
                    Text('ID: ${e.id ?? ''} · ${e.district ?? ''}',
                        style: TextStyle(
                            color: context.colors.textSec2, fontSize: 9),
                        overflow: TextOverflow.ellipsis),
                ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: _rankColors(context)[i].withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(children: [
                Text('$pct%',
                    style: TextStyle(
                        color: _rankColors(context)[i],
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        height: 1)),
                Text('$farz ফরজ',
                    style: TextStyle(
                        color: _rankColors(context)[i].withOpacity(0.55),
                        fontSize: 7,
                        fontWeight: FontWeight.w600)),
              ]),
            ),
          ]),
        ).animate().fadeIn(delay: Duration(milliseconds: i * 50));
      })),
    );
  }
}

// ── real-shape skeleton: _LeaderList এর row chrome হুবহু কপি (rank slot +
//    avatar square + name bar + right badge) — আগের generic ধূসর বক্সের
//    বদলে, যাতে top-3 লোড হওয়ার পর কোনো layout jump না হয়।
class _LeaderboardSkeleton extends StatelessWidget {
  const _LeaderboardSkeleton();

  static const _emojis = ['🥇', '🥈', '🥉'];

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: Container(
        decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.colors.border, width: 0.5)),
        child: Column(
          children: List.generate(3, (i) {
            final isLast = i == 2;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: i == 0 ? const Radius.circular(14) : Radius.zero,
                  bottom: isLast ? const Radius.circular(14) : Radius.zero,
                ),
                border: isLast
                    ? null
                    : Border(
                        bottom: BorderSide(
                            color: context.colors.border, width: 0.5)),
              ),
              child: Row(children: [
                SizedBox(
                    width: 22,
                    child: Text(_emojis[i],
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.15)),
                        textAlign: TextAlign.center)),
                const SizedBox(width: 8),
                _Bone(
                    width: 30,
                    height: 30,
                    radius: 8,
                    color: context.colors.skelBaseDark),
                const SizedBox(width: 8),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                      _Bone(width: 70 - (i * 6), height: 11),
                      const SizedBox(height: 5),
                      const _Bone(width: 90, height: 8),
                    ])),
                const SizedBox(width: 8),
                _Bone(
                    width: 42,
                    height: 34,
                    radius: 10,
                    color: context.colors.skelBaseDark),
              ]),
            );
          }),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COMMUNITY ROW — অপরিবর্তিত
// ─────────────────────────────────────────────────────────────────────────────

class _CommunityRow extends StatelessWidget {
  final VoidCallback onRate, onShare;
  const _CommunityRow({required this.onRate, required this.onShare});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Row(children: [
            Text('💬', style: TextStyle(fontSize: 13)),
            SizedBox(width: 6),
            Text('কমিউনিটি',
                style: TextStyle(
                    color: context.colors.textPri,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    letterSpacing: -0.1)),
          ])),
      Row(children: [
        Expanded(
            child: _CommCard(
                emoji: '⭐',
                title: 'রেটিং দিন',
                subtitle: 'Play Store এ রিভিউ',
                bg: context.colors.goldPale,
                border: const Color(0xFFFFE082),
                accent: const Color(0xFF7A4500),
                iconBg: const Color(0xFFFFECB3),
                onTap: onRate)),
        const SizedBox(width: 10),
        Expanded(
            child: _CommCard(
                emoji: '📤',
                title: 'শেয়ার করুন',
                subtitle: 'বন্ধুদের জানান',
                bg: const Color(0xFFEFF6FF),
                border: const Color(0xFFBFDBFE),
                accent: const Color(0xFF1D4ED8),
                iconBg: const Color(0xFFDBEAFE),
                onTap: onShare)),
      ]),
    ]);
  }
}

class _CommCard extends StatelessWidget {
  final String emoji, title, subtitle;
  final Color bg, border, accent, iconBg;
  final VoidCallback onTap;
  const _CommCard(
      {required this.emoji,
      required this.title,
      required this.subtitle,
      required this.bg,
      required this.border,
      required this.accent,
      required this.iconBg,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: 0.8)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: iconBg, borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 17)))),
            const Spacer(),
            Icon(Icons.arrow_outward_rounded,
                size: 13, color: accent.withOpacity(0.45)),
          ]),
          const SizedBox(height: 9),
          Text(title,
              style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: -0.2)),
          const SizedBox(height: 2),
          Text(subtitle,
              style: TextStyle(
                  color: accent.withOpacity(0.55),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500)),
        ]),
      ));
}

// ─────────────────────────────────────────────────────────────────────────────
// HOW IT WORKS — অপরিবর্তিত
// ─────────────────────────────────────────────────────────────────────────────

class _HowItWorks extends StatelessWidget {
  final VoidCallback onTap;
  const _HowItWorks({required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.colors.border, width: 0.5)),
        child: Row(children: [
          Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                  color: context.colors.greenLight,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.help_outline_rounded,
                  color: context.colors.darkGreen, size: 18)),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('এটি কীভাবে কাজ করে?',
                    style: TextStyle(
                        color: context.colors.textPri,
                        fontWeight: FontWeight.w700,
                        fontSize: 12)),
                SizedBox(height: 1),
                Text('আমল ট্র্যাকিং ও র‍্যাংকিং সম্পর্কে জানুন',
                    style: TextStyle(
                        color: context.colors.textSec2, fontSize: 10.5)),
              ])),
          Icon(Icons.chevron_right_rounded,
              color: context.colors.textHint, size: 18),
        ]),
      ));
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED — _EmptyCard অপরিবর্তিত। পুরনো generic _ListSkeleton আর ব্যবহার
// হচ্ছে না — leaderboard এখন _LeaderboardSkeleton (real shape) ব্যবহার করে।
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyCard extends StatelessWidget {
  final String label;
  const _EmptyCard({required this.label});
  @override
  Widget build(BuildContext context) => Container(
      height: 80,
      decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.colors.border, width: 0.5)),
      child: Center(
          child: Text(label,
              style: TextStyle(
                  color: context.colors.textHint,
                  fontSize: 13,
                  fontWeight: FontWeight.w500))));
}

class _SectionErrorCard extends StatelessWidget {
  final String label;
  final VoidCallback onRetry;
  const _SectionErrorCard({required this.label, required this.onRetry});

  @override
  Widget build(BuildContext context) => Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.colors.border, width: 0.5)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label,
                  style: TextStyle(
                      color: context.colors.textHint,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                      color: context.colors.greenLight,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text('আবার চেষ্টা করুন',
                      style: TextStyle(
                          color: context.colors.darkGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      );
}

class SectionHeaderCompact extends StatelessWidget {
  final String title, action;
  final VoidCallback onAction;
  const SectionHeaderCompact(
      {required this.title,
      required this.action,
      required this.onAction,
      super.key});
  @override
  Widget build(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title,
            style: TextStyle(
                color: context.colors.textPri,
                fontWeight: FontWeight.w700,
                fontSize: 11)),
        GestureDetector(
            onTap: onAction,
            child: Text(action,
                style: TextStyle(
                    color: context.colors.darkGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.w600))),
      ]);
}

// ─────────────────────────────────────────────────────────────────────────
// WEEKLY HABITS SNAPSHOT — প্রতিটা habit এর ডেটা shape অনুযায়ী আলাদা visual।
// আগে সবগুলোকে একই "৭-ডট" এ চেপে দেওয়া হতো — সেখানে fard এর কোন ওয়াক্ত
// কীভাবে পড়া হলো, quran/witr/sunnah এ আসল সংখ্যা, dhikr এ সকাল/সন্ধ্যা আলাদা
// — এই তথ্যগুলো হারিয়ে যেত। এখন habit.key ও habit.isGrid অনুযায়ী তিনটা
// আলাদা tile builder: fard → 5×7 mini heatmap, dhikr → 2×7 mini grid,
// quran/witr/sunnah → per-day bar chart + সংখ্যা লেবেল।
// ─────────────────────────────────────────────────────────────────────────

class _WeeklyHabitsSnapshot extends ConsumerWidget {
  final HomeSummary? summary;
  const _WeeklyHabitsSnapshot({this.summary});

  IconData _iconFor(String key) {
    switch (key) {
      case 'mosque':
        return Icons.mosque_rounded;
      case 'menu_book':
        return Icons.menu_book_rounded;
      case 'spa':
        return Icons.spa_rounded;
      case 'self_improvement':
        return Icons.self_improvement_rounded;
      case 'nights_stay':
        return Icons.nights_stay_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  Future<void> _onTap(
      BuildContext context, WidgetRef ref, WeeklyHabit habit) async {
    final catId = habit.categoryId;
    if (catId == null || catId.isEmpty) {
      context.go(AppRoutes.monthlyView);
      return;
    }
    try {
      final cats = await ref.read(categoriesProvider.future);
      AmalCategory? cat;
      for (final c in cats) {
        if (c.id == catId) {
          cat = c;
          break;
        }
      }
      if (!context.mounted) return;
      if (cat != null) {
        showCategoryProgressSheet(context, cat);
      } else {
        context.go(AppRoutes.monthlyView);
      }
    } catch (_) {
      if (context.mounted) context.go(AppRoutes.monthlyView);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = summary?.weeklyHabits ?? [];

    // NOTE: this widget is only ever built from the `data:`/hasValue branch
    // of homeSummaryProvider (see _HomeScreenState._buildWeeklySection), so
    // an empty list here means "the request succeeded but there's genuinely
    // no weekly habit data yet" — NOT "still loading". Showing the loading
    // skeleton in this case used to hide that distinction and could shimmer
    // forever for a new user with no activity. Show a real empty state
    // instead, in the same card chrome as the loaded/loading states so
    // there's no layout jump.
    if (habits.isEmpty) {
      return Container(
        padding: const EdgeInsets.fromLTRB(13, 11, 13, 12),
        decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: context.colors.border, width: 0.5)),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('সাপ্তাহিক অভ্যাস',
                  style: TextStyle(
                      color: context.colors.textPri,
                      fontWeight: FontWeight.w700,
                      fontSize: 11)),
              const SizedBox(height: 10),
              SizedBox(
                height: 148,
                child: Center(
                  child: Text('এই সপ্তাহে কোনো অভ্যাসের তথ্য নেই',
                      style: TextStyle(
                          color: context.colors.textHint,
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ]),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(13, 11, 13, 12),
      decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: context.colors.border, width: 0.5)),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text('সাপ্তাহিক অভ্যাস',
                  style: TextStyle(
                      color: context.colors.textPri,
                      fontWeight: FontWeight.w700,
                      fontSize: 11)),
              const Spacer(),
              Text('বিস্তারিত দেখতে ট্যাপ করুন',
                  style: TextStyle(
                      color: context.colors.textHint,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w500)),
            ]),
            const SizedBox(height: 10),
            SizedBox(
              height: 148,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: habits.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final h = habits[i];
                  final icon = _iconFor(h.icon);
                  final onTap = () => _onTap(context, ref, h);

                  if (h.key == 'fard') {
                    return _FardWeeklyTile(habit: h, icon: icon, onTap: onTap);
                  }
                  if (h.key == 'dhikr') {
                    return _DhikrWeeklyTile(habit: h, icon: icon, onTap: onTap);
                  }
                  return _NumericWeeklyTile(habit: h, icon: icon, onTap: onTap);
                },
              ),
            ),
          ]),
    );
  }
}

// ─── shared header used by all 3 tile types ─────────────────────────────────

class _TileHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TileHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, size: 14, color: context.colors.darkGreen),
        const SizedBox(width: 5),
        Expanded(
          child: Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: context.colors.textPri,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700)),
        ),
        Icon(Icons.chevron_right_rounded,
            size: 13, color: context.colors.textHint),
      ]);
}

bool _isToday(String dateStr) {
  final dd = DateTime.tryParse(dateStr);
  final t = DateTime.now();
  return dd != null &&
      dd.year == t.year &&
      dd.month == t.month &&
      dd.day == t.day;
}

String _weekdayShort(String dateStr) {
  const labels = ['র', 'সো', 'ম', 'বু', 'বৃ', 'শু', 'শ'];
  final dd = DateTime.tryParse(dateStr);
  if (dd == null) return '';
  // Dart weekday: Mon=1..Sun=7 → আমাদের সপ্তাহ শুরু রবিবার থেকে
  final idx = dd.weekday % 7; // Sun(7)->0, Mon(1)->1 ...
  return labels[idx];
}

// ─────────────────────────────────────────────────────────────────────────
// FARD TILE — 5×7 mini heatmap: row = ওয়াক্ত (ফ/যো/আ/মা/এ), column = দিন।
// প্রতিটা সেল রঙে বলে দেয় জামাত/একা/মিস/মাফ — ঠিক যেটা আগে dot এ বোঝা
// যেত না। রো-লেবেল বাম পাশে single letter এ, ৫টা রো-ই ধরে।
// ─────────────────────────────────────────────────────────────────────────

class _FardWeeklyTile extends StatelessWidget {
  final WeeklyHabit habit;
  final IconData icon;
  final VoidCallback onTap;
  const _FardWeeklyTile(
      {required this.habit, required this.icon, required this.onTap});

  Color _cellColor(String status, BuildContext context) {
    switch (status) {
      case 'congregation':
        return context.colors.green;
      case 'solo':
        return context.colors.amber;
      case 'exempt':
        return context.colors.purple.withOpacity(0.45);
      case 'missed':
      default:
        return context.colors.red.withOpacity(0.55);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = habit.items ?? const <HabitItem>[];
    final rowLabels = items
        .map((it) => it.label.isNotEmpty ? it.label.characters.first : '?')
        .toList();
    final days = habit.days;
    int done = 0, total = 0;
    for (final d in days) {
      if (d.isExemptDay) continue;
      for (final s in d.statuses ?? const <String>[]) {
        total++;
        if (s == 'congregation' || s == 'solo') done++;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 168,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.colors.pageBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.border, width: 0.6),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _TileHeader(icon: icon, label: habit.label),
              const SizedBox(height: 3),
              Text('$done/$total ওয়াক্ত এ সপ্তাহে',
                  style: TextStyle(
                      color: context.colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              // ── header row: day letters ─────────────────────────────────
              Row(children: [
                const SizedBox(width: 16),
                ...List.generate(days.length, (c) {
                  final today = _isToday(days[c].date);
                  return Expanded(
                    child: Center(
                      child: Text(_weekdayShort(days[c].date),
                          style: TextStyle(
                              fontSize: 7,
                              fontWeight:
                                  today ? FontWeight.w800 : FontWeight.w500,
                              color: today
                                  ? context.colors.gold
                                  : context.colors.textHint)),
                    ),
                  );
                }),
              ]),
              const SizedBox(height: 2),
              // ── grid rows: one per waqt ──────────────────────────────────
              ...List.generate(rowLabels.length, (r) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(children: [
                    SizedBox(
                        width: 16,
                        child: Text(rowLabels[r],
                            style: TextStyle(
                                fontSize: 7.5,
                                fontWeight: FontWeight.w700,
                                color: context.colors.textSec2))),
                    ...List.generate(days.length, (c) {
                      final statuses = days[c].statuses ?? const <String>[];
                      final status =
                          r < statuses.length ? statuses[r] : 'missed';
                      final today = _isToday(days[c].date);
                      return Expanded(
                        child: Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: _cellColor(status, context),
                              borderRadius: BorderRadius.circular(3),
                              border: today
                                  ? Border.all(
                                      color: context.colors.gold, width: 1)
                                  : null,
                            ),
                          ),
                        ),
                      );
                    }),
                  ]),
                );
              }),
            ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// DHIKR TILE — 2×7 grid, row label পুরো লেখা "সকাল"/"সন্ধ্যা" (মাত্র ২টা
// রো বলে জায়গা আছে) — fard থেকে আলাদা দেখতে, নিজের identity সহ।
// ─────────────────────────────────────────────────────────────────────────

class _DhikrWeeklyTile extends StatelessWidget {
  final WeeklyHabit habit;
  final IconData icon;
  final VoidCallback onTap;
  const _DhikrWeeklyTile(
      {required this.habit, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = habit.items ?? const <HabitItem>[];
    final days = habit.days;
    int done = 0, total = 0;
    for (final d in days) {
      for (final s in d.statuses ?? const <String>[]) {
        total++;
        if (s == 'done') done++;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 168,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.colors.pageBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.border, width: 0.6),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _TileHeader(icon: icon, label: habit.label),
              const SizedBox(height: 3),
              Text('$done/$total বার এ সপ্তাহে',
                  style: TextStyle(
                      color: context.colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Row(children: [
                const SizedBox(width: 34),
                ...List.generate(days.length, (c) {
                  final today = _isToday(days[c].date);
                  return Expanded(
                    child: Center(
                      child: Text(_weekdayShort(days[c].date),
                          style: TextStyle(
                              fontSize: 7,
                              fontWeight:
                                  today ? FontWeight.w800 : FontWeight.w500,
                              color: today
                                  ? context.colors.gold
                                  : context.colors.textHint)),
                    ),
                  );
                }),
              ]),
              const SizedBox(height: 3),
              ...List.generate(items.length, (r) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(children: [
                    SizedBox(
                        width: 34,
                        child: Text(items[r].label,
                            style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: context.colors.textSec2))),
                    ...List.generate(days.length, (c) {
                      final statuses = days[c].statuses ?? const <String>[];
                      final isDone =
                          r < statuses.length && statuses[r] == 'done';
                      final today = _isToday(days[c].date);
                      return Expanded(
                        child: Center(
                          child: Container(
                            width: 14,
                            height: 14,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: isDone
                                  ? context.colors.green
                                  : context.colors.border,
                              shape: BoxShape.circle,
                              border: today
                                  ? Border.all(
                                      color: context.colors.gold, width: 1)
                                  : null,
                            ),
                            child: isDone
                                ? const Icon(Icons.check_rounded,
                                    size: 9, color: Colors.white)
                                : null,
                          ),
                        ),
                      );
                    }),
                  ]),
                );
              }),
            ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// NUMERIC TILE (কুরআন/বিতর/সুন্নাত) — fl_chart এর BarChart দিয়ে পলিশড
// রেন্ডারিং। সেম্যান্টিক আগের মতোই: ডিসক্রিট প্রতিদিনের সংখ্যা, তাই bar —
// শুধু rendering engine এখন কাস্টম Container এর বদলে fl_chart, tooltip
// showingTooltipIndicators দিয়ে সবসময় দেখানো হচ্ছে (touch ছাড়াই)।
// ─────────────────────────────────────────────────────────────────────────

class _NumericWeeklyTile extends StatelessWidget {
  final WeeklyHabit habit;
  final IconData icon;
  final VoidCallback onTap;
  const _NumericWeeklyTile(
      {required this.habit, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final days = habit.days;
    final total = days.fold(0.0, (a, d) => a + (d.value ?? 0));
    final maxVal =
        days.fold(0.0, (a, d) => (d.value ?? 0) > a ? (d.value ?? 0) : a);
    // ── headroom: টুলটিপ bar এর উপরে বসে, তাই y-axis max এ ২৫% extra
    // জায়গা রাখা হলো — নাহলে সর্বোচ্চ bar এর tooltip চার্টের বাইরে কাটা
    // পড়ে যেত।
    final chartMaxY = (maxVal <= 0 ? 1.0 : maxVal) * 1.35;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.colors.pageBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.border, width: 0.6),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _TileHeader(icon: icon, label: habit.label),
              const SizedBox(height: 3),
              Text('${total.toInt()} ${habit.unit ?? ""} এ সপ্তাহে',
                  style: TextStyle(
                      color: context.colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              SizedBox(
                height: 78,
                child: Stack(
                  children: [
                    // ── "আজ" এর কলাম হাইলাইট — bar এর রঙ ছোঁয়া হচ্ছে না, শুধু পেছনে
                    // নরম gold tint ব্যান্ড। magnitude (bar এর রঙ) আর identity (এই
                    // ব্যাকগ্রাউন্ড) সম্পূর্ণ আলাদা লেয়ারে, একে অপরকে নষ্ট করছে না।
                    Row(
                      children: List.generate(days.length, (i) {
                        final today = _isToday(days[i].date);
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: today
                                  ? context.colors.gold.withOpacity(0.10)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }),
                    ),
                    BarChart(
                      BarChartData(
                        maxY: chartMaxY,
                        minY: 0,
                        alignment: BarChartAlignment.spaceAround,
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barTouchData: BarTouchData(
                          enabled: false,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipPadding: EdgeInsets.zero,
                            tooltipMargin: 2,
                            getTooltipColor: (_) => Colors.transparent,
                            getTooltipItem: (group, gi, rod, ri) {
                              final v = rod.toY;
                              if (v <= 0) return null;
                              final today =
                                  _isToday(days[group.x.toInt()].date);
                              return BarTooltipItem(
                                v.toInt().toString(),
                                TextStyle(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w800,
                                    color: today
                                        ? context.colors.darkGreen
                                        : context.colors.green),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 14,
                              getTitlesWidget: (value, meta) {
                                final i = value.toInt();
                                if (i < 0 || i >= days.length)
                                  return const SizedBox.shrink();
                                final today = _isToday(days[i].date);
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(_weekdayShort(days[i].date),
                                      style: TextStyle(
                                          fontSize: 7,
                                          fontWeight: today
                                              ? FontWeight.w800
                                              : FontWeight.w500,
                                          color: today
                                              ? context.colors.gold
                                              : context.colors.textHint)),
                                );
                              },
                            ),
                          ),
                        ),
                        barGroups: List.generate(days.length, (i) {
                          final d = days[i];
                          final v = d.value ?? 0;
                          final ratio =
                              maxVal > 0 ? (v / maxVal).clamp(0.0, 1.0) : 0.0;

                          // ── রঙ শুধুই magnitude — "আজ" এখানে কোনো ভূমিকা রাখছে না
                          final Color barColor = d.isExemptDay
                              ? context.colors.purple.withOpacity(0.4)
                              : v > 0
                                  ? context.colors.green
                                      .withOpacity(0.3 + ratio * 0.7)
                                  : context.colors.border;

                          return BarChartGroupData(
                            x: i,
                            showingTooltipIndicators: v > 0 ? [0] : [],
                            barRods: [
                              BarChartRodData(
                                toY: v > 0 ? v : 0.06,
                                width: 11,
                                color: barColor,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(3)),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
