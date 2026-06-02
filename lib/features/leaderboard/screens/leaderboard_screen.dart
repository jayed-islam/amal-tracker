import 'package:amal_tracker/features/leaderboard/widgets/gender_filter.dart';
import 'package:amal_tracker/features/leaderboard/widgets/public_profile_sheet.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/leaderboard_provider.dart';
import '../../tracker/models/tracker_model.dart';
import '../../../core/constants/app_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS — identical to home_screen.dart ColorT
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
  static const red = Color(0xFFEF4444);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
  static const border = Color(0xFFE4EAE4);
  static const borderMid = Color(0xFFC8D4C8);
  static const rankGold = Color(0xFFD4A843);
  static const rankSilver = Color(0xFF94A3B8);
  static const rankBronze = Color(0xFFCD7F32);
  static const avatar1 = Color(0xFF0E3D22);
  static const avatar2 = Color(0xFF374151);
  static const avatar3 = Color(0xFF7C3AED);
  static const avatar4 = Color(0xFF0891B2);
  static const avatar5 = Color(0xFF9D174D);
  // New: district pill background
  static const districtBg = Color(0xFFEDF2ED);
  static const districtText = Color(0xFF2D5A3D);
  static const serialBg = Color(0xFFF0F4F0);
  static const serialText = Color(0xFF8FA98F);
}

// ─────────────────────────────────────────────────────────────────────────────
// LEADERBOARD SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  final _sc = ScrollController();

  @override
  void initState() {
    super.initState();
    _sc.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    final f = ref.read(leaderboardFilterProvider);
    ref.read(leaderboardProvider.notifier).load(f, refresh: true);
  }

  void _onScroll() {
    if (_sc.position.pixels >= _sc.position.maxScrollExtent - 200) {
      final state = ref.read(leaderboardProvider);
      if (!state.isLoadingMore && state.hasMore) {
        final f = ref.read(leaderboardFilterProvider);
        ref
            .read(leaderboardProvider.notifier)
            .load(f.copyWith(page: state.currentPage + 1));
      }
    }
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final f = ref.read(leaderboardFilterProvider);
    await ref.read(leaderboardProvider.notifier).load(f, refresh: true);
    ref.invalidate(myRankProvider((year: f.year, month: f.month)));
  }

  void _pickMonth() {
    final f = ref.read(leaderboardFilterProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _MonthPickerSheet(
        year: f.year,
        month: f.month,
        onPicked: (y, m) {
          final next = f.copyWith(year: y, month: m, page: 1);
          ref.read(leaderboardFilterProvider.notifier).state = next;
          ref.read(leaderboardProvider.notifier).load(next, refresh: true);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(leaderboardProvider);
    final filter = ref.watch(leaderboardFilterProvider);
    final myRank = ref.watch(
      myRankProvider((year: filter.year, month: filter.month)),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _C.pageBg,
        body: RefreshIndicator(
          color: _C.darkGreen,
          onRefresh: _refresh,
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
                title: Row(
                  children: [
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
                          'লিডারবোর্ড',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.55),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${AppConstants.bengaliMonths[filter.month - 1]} ${filter.year}',
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
                centerTitle: false,
                actions: [
                  GestureDetector(
                    onTap: _pickMonth,
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
                systemOverlayStyle: SystemUiOverlayStyle.light,
              ),

              // ── Zone 2: HERO BAND ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: _HeroBand(
                  filter: filter,
                  myRankAsync: myRank,
                  showTitle: true,
                  ref: ref,
                ).animate().fadeIn(duration: 280.ms),
              ),

              // ── Zone 3: MONTH CHIPS (sticky) ──────────────────────────────
              SliverPersistentHeader(
                pinned: true,
                delegate: _MonthChipDelegate(
                  filter: filter,
                  onPick: _pickMonth,
                ),
              ),

              SliverToBoxAdapter(
                child: GenderFilterChips(
                  selected: filter.gender,
                  onChanged: (g) {
                    final next = ref
                        .read(leaderboardFilterProvider.notifier)
                        .state
                        .copyWith(
                          gender: g,
                          clearGender: g == null,
                          page: 1,
                        );
                    ref.read(leaderboardFilterProvider.notifier).state = next;
                    ref
                        .read(leaderboardProvider.notifier)
                        .load(next, refresh: true);
                  },
                ),
              ),

              // ── Zone 4: BODY ──────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: _buildBody(state, filter),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(LeaderboardState state, LeaderboardFilter filter) {
    if (state.isLoading) {
      return SliverToBoxAdapter(
        child: _LeaderboardSkeleton()
            .animate()
            .fadeIn(delay: 80.ms, duration: 260.ms),
      );
    }

    if (state.error != null) {
      return SliverToBoxAdapter(
        child: _ErrorCard(message: state.error!, onRetry: _load)
            .animate()
            .fadeIn(duration: 260.ms),
      );
    }

    if (state.entries.isEmpty) {
      return SliverToBoxAdapter(
        child: const _EmptyCard(label: 'এই মাসে এখনো কেউ আমল রেকর্ড করেননি')
            .animate()
            .fadeIn(duration: 260.ms),
      );
    }

    final top3 = state.entries.take(3).toList();
    final rest = state.entries.length > 3
        ? state.entries.sublist(3)
        : <LeaderboardEntry>[];

    return SliverList(
      delegate: SliverChildListDelegate([
        const SizedBox(height: 8),
        _SectionHeader(
          title: 'শীর্ষ তিনজন',
          emoji: '🥇',
          onSeeAll: null,
        ).animate().fadeIn(delay: 100.ms),
        const SizedBox(height: 12),
        if (top3.length >= 2)
          _PodiumCard(
            top3: top3, year: filter.year, // ← add
            month: filter.month,
          ) // ← add)
              .animate()
              .fadeIn(delay: 120.ms, duration: 320.ms)
              .slideY(begin: 0.08, curve: Curves.easeOut),
        if (top3.length == 1)
          _SingleEntryCard(entry: top3[0])
              .animate()
              .fadeIn(delay: 120.ms, duration: 320.ms),
        const SizedBox(height: 24),
        if (rest.isNotEmpty) ...[
          _SectionHeader(
            title: 'সম্পূর্ণ তালিকা',
            emoji: '📋',
            onSeeAll: null,
          ).animate().fadeIn(delay: 160.ms),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: _C.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _C.border, width: 0.5),
            ),
            child: Column(
              children: List.generate(rest.length, (i) {
                final entry = rest[i];
                final isLast = i == rest.length - 1;
                return _RankTile(
                  entry: entry,
                  isLast: isLast,
                  delay: 180 + i * 40,
                  year: filter.year, // ← filter এখানে আছেই
                  month: filter.month,
                );
              }),
            ),
          ).animate().fadeIn(delay: 180.ms, duration: 280.ms),
        ],
        if (state.entries.length <= 3 && state.entries.isNotEmpty)
          _NoMoreEntriesCard(count: state.entries.length)
              .animate()
              .fadeIn(delay: 160.ms, duration: 280.ms),
        if (state.isLoadingMore) ...[
          const SizedBox(height: 20),
          const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: _C.darkGreen,
                strokeWidth: 2,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ] else
          const SizedBox(height: 8),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED WIDGETS: Serial ID badge & District pill
// ─────────────────────────────────────────────────────────────────────────────

/// Small serial ID tag — e.g. "BD-001"
/// Used inside rank tiles on a dark or light background.
class _SerialBadge extends StatelessWidget {
  final String id;
  final bool onDark;

  const _SerialBadge({required this.id, this.onDark = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: onDark ? Colors.white.withOpacity(0.12) : _C.serialBg,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: onDark ? Colors.white.withOpacity(0.18) : _C.border,
          width: 0.5,
        ),
      ),
      child: Text(
        id,
        style: TextStyle(
          color: onDark ? Colors.white.withOpacity(0.55) : _C.serialText,
          fontSize: 8.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

/// District location pill — e.g. "ঢাকা"
/// Shown with a pin icon for context.
class _DistrictPill extends StatelessWidget {
  final String district;
  final bool onDark;
  final bool compact; // smaller for podium

  const _DistrictPill({
    required this.district,
    this.onDark = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 5 : 6,
        vertical: compact ? 2 : 2.5,
      ),
      decoration: BoxDecoration(
        color: onDark ? Colors.white.withOpacity(0.12) : _C.districtBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: onDark ? Colors.white.withOpacity(0.18) : _C.border,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_rounded,
            size: compact ? 7.5 : 8.5,
            color: onDark ? Colors.white.withOpacity(0.55) : _C.districtText,
          ),
          const SizedBox(width: 2),
          Text(
            district,
            style: TextStyle(
              color: onDark ? Colors.white.withOpacity(0.7) : _C.districtText,
              fontSize: compact ? 8.5 : 9.5,
              fontWeight: FontWeight.w600,
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
  final LeaderboardFilter filter;
  final AsyncValue<MyRankData> myRankAsync;
  final bool showTitle;
  final WidgetRef ref;

  const _HeroBand({
    required this.filter,
    required this.myRankAsync,
    this.showTitle = true,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _C.darkGreen,
      child: Stack(
        children: [
          Positioned(
            top: -45,
            right: -45,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Positioned(
            bottom: -25,
            left: 20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.03),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppConstants.bengaliMonths[filter.month - 1]} ${filter.year} · শীর্ষ আমলকারীরা',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                myRankAsync.when(
                  loading: () => const _MyRankSkeleton(),
                  error: (error, stackTrace) => _MyRankErrorCard(
                    message: error.toString(),
                    onRetry: () {
                      final f = ref.read(leaderboardFilterProvider);
                      ref.invalidate(
                          myRankProvider((year: f.year, month: f.month)));
                    },
                  ),
                  data: (d) => _MyRankCard(data: d),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MY RANK CARD  — now shows id + district
// ─────────────────────────────────────────────────────────────────────────────

class _MyRankCard extends StatelessWidget {
  final MyRankData data;
  const _MyRankCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Rank badge
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: _C.gold,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.rank != null ? '#${data.rank}' : '—',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    height: 1,
                  ),
                ),
                Text(
                  'আমার',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'আমার অবস্থান',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      '${data.totalPoints} পয়েন্ট',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (data.isWinner) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: _C.gold,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🏆', style: TextStyle(fontSize: 9)),
                            const SizedBox(width: 3),
                            Text(
                              data.winnerCategory ?? 'বিজয়ী',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                // ── NEW: id + district row ───────────────────────────
                // const SizedBox(height: 5),
                // Wrap(
                //   spacing: 5,
                //   runSpacing: 4,
                //   children: [
                //     if (data.id != null)
                //       _SerialBadge(id: data.id!, onDark: true),
                //     if (data.district != null)
                //       _DistrictPill(district: data.district!, onDark: true),
                //   ],
                // ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${data.completionPercentage.toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  letterSpacing: -0.4,
                  height: 1,
                ),
              ),
              Text(
                'সম্পন্ন',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MyRankSkeleton extends StatelessWidget {
  const _MyRankSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // slightly taller to account for new row
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
    ).animate(onPlay: (c) => c.repeat()).shimmer(
      duration: 1200.ms,
      colors: [
        Colors.white.withOpacity(0.04),
        Colors.white.withOpacity(0.12),
        Colors.white.withOpacity(0.04),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MONTH CHIP ROW
// ─────────────────────────────────────────────────────────────────────────────

class _MonthChipRow extends StatelessWidget {
  final LeaderboardFilter filter;
  final VoidCallback onPick;

  const _MonthChipRow({required this.filter, required this.onPick});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = List.generate(6, (i) {
      final dt = DateTime(now.year, now.month - i);
      return (year: dt.year, month: dt.month);
    });

    return Container(
      color: _C.cardBg,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: months.map((m) {
                final isActive =
                    m.month == filter.month && m.year == filter.year;
                final label = AppConstants.bengaliMonths[m.month - 1];
                return GestureDetector(
                  onTap: onPick,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive ? _C.darkGreen : _C.pageBg,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(
                        color: isActive ? _C.darkGreen : _C.border,
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      m.year == now.year ? label : '$label ${m.year}',
                      style: TextStyle(
                        color: isActive ? Colors.white : _C.textSecondary,
                        fontSize: 11,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(color: _C.border, height: 0.5, thickness: 0.5),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title, emoji;
  final VoidCallback? onSeeAll;

  const _SectionHeader({
    required this.title,
    required this.emoji,
    this.onSeeAll,
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
            color: _C.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 15,
            letterSpacing: -0.2,
          ),
        ),
        const Spacer(),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _C.greenLight,
                borderRadius: BorderRadius.circular(99),
              ),
              child: const Text(
                'সব দেখুন →',
                style: TextStyle(
                  color: _C.darkGreen,
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
// PODIUM CARD  — district shown under name in each pillar
// ─────────────────────────────────────────────────────────────────────────────

class _PodiumCard extends StatelessWidget {
  final List<LeaderboardEntry> top3;
  final int year; // নতুন
  final int month;

  const _PodiumCard({
    required this.top3,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final first = top3[0];
    final second = top3[1];
    final third = top3.length > 2 ? top3[2] : null;

    return Container(
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 0.5),
      ),
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
      child: Column(
        children: [
          Text(
            top3.length == 2 ? 'এই মাসের শীর্ষ দুইজন' : 'এই মাসের শীর্ষ তিনজন',
            style: const TextStyle(
              color: _C.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            '🌟 সম্মান ও অভিনন্দন 🌟',
            style: TextStyle(
              color: _C.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          if (top3.length == 2)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _PodiumPillar(
                  entry: second,
                  rank: 2,
                  color: _C.rankSilver,
                  emoji: '🥈',
                  barHeight: 100,
                  avatarSize: 52,
                  fontSize: 20,
                  barWidth: 90,
                  rankFontSize: 18,
                  year: year,
                  month: month,
                ),
                const SizedBox(width: 20),
                _PodiumPillar(
                  entry: first,
                  rank: 1,
                  color: _C.rankGold,
                  emoji: '🥇',
                  barHeight: 130,
                  avatarSize: 62,
                  fontSize: 24,
                  barWidth: 100,
                  rankFontSize: 22,
                  isFirst: true,
                  year: year,
                  month: month,
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _PodiumPillar(
                  entry: second,
                  rank: 2,
                  color: _C.rankSilver,
                  emoji: '🥈',
                  barHeight: 88,
                  avatarSize: 46,
                  fontSize: 18,
                  barWidth: 68,
                  rankFontSize: 17,
                  year: year,
                  month: month,
                ),
                _PodiumPillar(
                  entry: first,
                  rank: 1,
                  color: _C.rankGold,
                  emoji: '🥇',
                  barHeight: 120,
                  avatarSize: 56,
                  fontSize: 22,
                  barWidth: 80,
                  rankFontSize: 20,
                  isFirst: true,
                  year: year,
                  month: month,
                ),
                if (third != null)
                  _PodiumPillar(
                    entry: third,
                    rank: 3,
                    color: _C.rankBronze,
                    emoji: '🥉',
                    barHeight: 68,
                    avatarSize: 42,
                    fontSize: 16,
                    barWidth: 64,
                    rankFontSize: 15,
                    year: year,
                    month: month,
                  )
                else
                  const SizedBox(width: 64),
              ],
            ),
        ],
      ),
    );
  }
}

class _PodiumPillar extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;
  final Color color;
  final String emoji;
  final double barHeight, avatarSize, fontSize, barWidth, rankFontSize;
  final bool isFirst;
  final int year; // নতুন
  final int month;

  const _PodiumPillar({
    required this.entry,
    required this.rank,
    required this.color,
    required this.emoji,
    required this.barHeight,
    required this.avatarSize,
    required this.fontSize,
    required this.barWidth,
    required this.rankFontSize,
    required this.year,
    required this.month,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    final canView = entry.isProfilePublic;
    return GestureDetector(
      onTap: canView
          ? () {
              HapticFeedback.selectionClick();
              showPublicProfileSheet(
                context,
                entry: entry,
                year: year,
                month: month,
              );
            }
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: TextStyle(fontSize: fontSize)).animate().scale(
                delay: Duration(milliseconds: rank * 100),
                duration: 400.ms,
                curve: Curves.elasticOut,
              ),

          const SizedBox(height: 6),

          // Avatar circle
          // Container(
          //   width: avatarSize,
          //   height: avatarSize,
          //   decoration: BoxDecoration(
          //     color: color.withOpacity(0.12),
          //     shape: BoxShape.circle,
          //     border: Border.all(color: color, width: 2.5),
          //   ),
          //   child: Center(
          //     child: Text(
          //       entry.name.isNotEmpty ? entry.name[0].toUpperCase() : 'U',
          //       style: TextStyle(
          //         fontWeight: FontWeight.w900,
          //         color: color,
          //         fontSize: isFirst ? 24 : 18,
          //       ),
          //     ),
          //   ),
          // ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: canView ? color : color.withOpacity(0.35),
                    width: canView ? 2.5 : 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    entry.name.isNotEmpty ? entry.name[0].toUpperCase() : 'U',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: color,
                      fontSize: isFirst ? 24 : 18,
                    ),
                  ),
                ),
              ),

              // Public/Private indicator — avatar এর bottom-right এ
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: canView
                        ? const Color(0xFF0891B2)
                        : const Color(0xFFABBAAE),
                    shape: BoxShape.circle,
                    border: Border.all(color: _C.cardBg, width: 1.5),
                  ),
                  child: Icon(
                    canView ? Icons.visibility_rounded : Icons.lock_rounded,
                    size: 8,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          // First name
          SizedBox(
            width: barWidth,
            child: Text(
              entry.name.split(' ').first,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _C.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 10.5,
              ),
            ),
          ),

          // ── NEW: district pill under name ──────────────────────────────────
          if (entry.district != null) ...[
            const SizedBox(height: 3),
            _DistrictPill(district: entry.district!, compact: true),
          ],

          if (entry.id != null) ...[
            const SizedBox(height: 3),
            _SerialBadge(
              id: entry.id!,
            ),
          ],

          // "দেখুন" বা "Private" label
          // const SizedBox(height: 4),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          //   decoration: BoxDecoration(
          //     color:
          //         canView ? const Color(0xFFE0F2FE) : const Color(0xFFF4F6F1),
          //     borderRadius: BorderRadius.circular(4),
          //     border: Border.all(
          //       color: canView
          //           ? const Color(0xFF0891B2).withOpacity(0.3)
          //           : _C.border,
          //       width: 0.5,
          //     ),
          //   ),
          //   child: Text(
          //     canView ? 'দেখুন →' : '🔒 Private',
          //     style: TextStyle(
          //       color: canView ? const Color(0xFF0891B2) : _C.textHint,
          //       fontSize: 8,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),

          const SizedBox(height: 4),

          // Podium bar
          Container(
            width: barWidth,
            height: barHeight,
            decoration: BoxDecoration(
              color: color.withOpacity(0.07),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              border: Border(
                top: BorderSide(color: color, width: 2),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '#$rank',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: rankFontSize,
                  ),
                ),
                Text(
                  '${entry.totalPoints}',
                  style: TextStyle(
                    color: color.withOpacity(0.8),
                    fontWeight: FontWeight.w700,
                    fontSize: isFirst ? 13 : 11,
                  ),
                ),
                const Text(
                  'pts',
                  style: TextStyle(
                    color: _C.textHint,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
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

// leaderboard_screen.dart
// শুধু _PodiumCard এবং _PodiumPillar replace করো

// ─────────────────────────────────────────────────────────────────────────────
// PODIUM CARD  — premium redesign
// ─────────────────────────────────────────────────────────────────────────────

// class _PodiumCard extends StatelessWidget {
//   final List<LeaderboardEntry> top3;
//   final int year;
//   final int month;

//   const _PodiumCard({
//     required this.top3,
//     required this.year,
//     required this.month,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final first = top3[0];
//     final second = top3[1];
//     final third = top3.length > 2 ? top3[2] : null;

//     return Container(
//       decoration: BoxDecoration(
//         color: _C.cardBg,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       child: Column(
//         children: [
//           // ── Header ──────────────────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   '🌟',
//                   style: const TextStyle(fontSize: 13),
//                 ),
//                 const SizedBox(width: 6),
//                 Text(
//                   top3.length == 2
//                       ? 'এই মাসের শীর্ষ দুইজন'
//                       : 'এই মাসের শীর্ষ তিনজন',
//                   style: const TextStyle(
//                     color: _C.textSecondary,
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 0.2,
//                   ),
//                 ),
//                 const SizedBox(width: 6),
//                 Text(
//                   '🌟',
//                   style: const TextStyle(fontSize: 13),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 20),

//           // ── Podium pillars ───────────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: top3.length == 2
//                 ? Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       _PodiumPillar(
//                         entry: second,
//                         rank: 2,
//                         barHeight: 90,
//                         year: year,
//                         month: month,
//                       ),
//                       const SizedBox(width: 12),
//                       _PodiumPillar(
//                         entry: first,
//                         rank: 1,
//                         barHeight: 124,
//                         isFirst: true,
//                         year: year,
//                         month: month,
//                       ),
//                     ],
//                   )
//                 : Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       _PodiumPillar(
//                         entry: second,
//                         rank: 2,
//                         barHeight: 84,
//                         year: year,
//                         month: month,
//                       ),
//                       _PodiumPillar(
//                         entry: first,
//                         rank: 1,
//                         barHeight: 116,
//                         isFirst: true,
//                         year: year,
//                         month: month,
//                       ),
//                       if (third != null)
//                         _PodiumPillar(
//                           entry: third,
//                           rank: 3,
//                           barHeight: 64,
//                           year: year,
//                           month: month,
//                         )
//                       else
//                         const SizedBox(width: 80),
//                     ],
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ─────────────────────────────────────────────────────────────────────────────
// PODIUM PILLAR  — premium compact design
// ─────────────────────────────────────────────────────────────────────────────

// class _PodiumPillar extends StatelessWidget {
//   final LeaderboardEntry entry;
//   final int rank;
//   final double barHeight;
//   final bool isFirst;
//   final int year;
//   final int month;

//   const _PodiumPillar({
//     required this.entry,
//     required this.rank,
//     required this.barHeight,
//     required this.year,
//     required this.month,
//     this.isFirst = false,
//   });

//   Color get _rankColor => rank == 1
//       ? _C.rankGold
//       : rank == 2
//           ? _C.rankSilver
//           : _C.rankBronze;

//   String get _rankEmoji => rank == 1
//       ? '🥇'
//       : rank == 2
//           ? '🥈'
//           : '🥉';

//   // avatar size
//   double get _avatarSize => isFirst
//       ? 64.0
//       : rank == 2
//           ? 54.0
//           : 48.0;

//   // pillar width
//   double get _pillarWidth => isFirst
//       ? 88.0
//       : rank == 2
//           ? 78.0
//           : 70.0;

//   @override
//   Widget build(BuildContext context) {
//     final canView = entry.isProfilePublic;
//     final initial = entry.name.isNotEmpty ? entry.name[0].toUpperCase() : 'U';
//     final firstName = entry.name.split(' ').first;

//     return GestureDetector(
//       onTap: canView
//           ? () {
//               HapticFeedback.selectionClick();
//               showPublicProfileSheet(
//                 context,
//                 entry: entry,
//                 year: year,
//                 month: month,
//               );
//             }
//           : null,
//       behavior: HitTestBehavior.opaque,
//       child: SizedBox(
//         width: _pillarWidth,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // ── Medal emoji ────────────────────────────────────────
//             Text(
//               _rankEmoji,
//               style: TextStyle(fontSize: isFirst ? 22 : 18),
//             ).animate().scale(
//                   delay: Duration(milliseconds: rank * 80),
//                   duration: 380.ms,
//                   curve: Curves.elasticOut,
//                 ),

//             const SizedBox(height: 8),

//             // ── Avatar with overlays ───────────────────────────────
//             Stack(
//               clipBehavior: Clip.none,
//               alignment: Alignment.center,
//               children: [
//                 // Glow ring — only for rank 1
//                 if (isFirst)
//                   Container(
//                     width: _avatarSize + 8,
//                     height: _avatarSize + 8,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: _rankColor.withOpacity(0.25),
//                         width: 3,
//                       ),
//                     ),
//                   ),

//                 // Avatar circle
//                 Container(
//                   width: _avatarSize,
//                   height: _avatarSize,
//                   decoration: BoxDecoration(
//                     color: _rankColor.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: _rankColor,
//                       width: isFirst ? 2.5 : 2,
//                     ),
//                   ),
//                   child: Center(
//                     child: Text(
//                       initial,
//                       style: TextStyle(
//                         color: _rankColor,
//                         fontSize: isFirst
//                             ? 26
//                             : rank == 2
//                                 ? 20
//                                 : 18,
//                         fontWeight: FontWeight.w900,
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Public/Private dot — top right
//                 Positioned(
//                   top: isFirst ? -2 : -1,
//                   right: isFirst ? -2 : -1,
//                   child: Container(
//                     width: 18,
//                     height: 18,
//                     decoration: BoxDecoration(
//                       color: canView ? const Color(0xFF0891B2) : _C.textHint,
//                       shape: BoxShape.circle,
//                       border: Border.all(color: _C.cardBg, width: 2),
//                     ),
//                     child: Icon(
//                       canView ? Icons.visibility_rounded : Icons.lock_rounded,
//                       size: 9,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 10),

//             // ── Name ───────────────────────────────────────────────
//             Text(
//               firstName,
//               textAlign: TextAlign.center,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 color: _C.textPrimary,
//                 fontSize: isFirst ? 13 : 11.5,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: -0.2,
//               ),
//             ),

//             const SizedBox(height: 4),

//             // ── Compact info chip — ID • District merged ────────────
//             _CompactInfoChip(entry: entry),

//             const SizedBox(height: 10),

//             // ── Podium bar ─────────────────────────────────────────
//             Container(
//               width: _pillarWidth,
//               height: barHeight,
//               decoration: BoxDecoration(
//                 color: _rankColor.withOpacity(0.06),
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(10),
//                 ),
//                 border: Border(
//                   top: BorderSide(color: _rankColor, width: 2),
//                   left: BorderSide(
//                       color: _rankColor.withOpacity(0.2), width: 0.5),
//                   right: BorderSide(
//                       color: _rankColor.withOpacity(0.2), width: 0.5),
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Points
//                   Text(
//                     '${entry.totalPoints}',
//                     style: TextStyle(
//                       color: _rankColor,
//                       fontWeight: FontWeight.w900,
//                       fontSize: isFirst
//                           ? 18
//                           : rank == 2
//                               ? 15
//                               : 13,
//                       height: 1,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     'pts',
//                     style: TextStyle(
//                       color: _rankColor.withOpacity(0.6),
//                       fontSize: 9,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   // Completion %
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                     decoration: BoxDecoration(
//                       color: _rankColor.withOpacity(0.12),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       '${entry.completionPercentage.toInt()}%',
//                       style: TextStyle(
//                         color: _rankColor,
//                         fontSize: 9,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                   // Streak — only if space (rank 1 or 2)
//                   if (entry.streakDays > 0 && rank <= 2) ...[
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Text('🔥', style: TextStyle(fontSize: 9)),
//                         const SizedBox(width: 2),
//                         Text(
//                           '${entry.streakDays}',
//                           style: TextStyle(
//                             color: _rankColor.withOpacity(0.7),
//                             fontSize: 9,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ─────────────────────────────────────────────────────────────────────────────
// PODIUM PILLAR — fixed
// ─────────────────────────────────────────────────────────────────────────────

// class _PodiumPillar extends StatelessWidget {
//   final LeaderboardEntry entry;
//   final int rank;
//   final double barHeight;
//   final bool isFirst;
//   final int year;
//   final int month;

//   const _PodiumPillar({
//     required this.entry,
//     required this.rank,
//     required this.barHeight,
//     required this.year,
//     required this.month,
//     this.isFirst = false,
//   });

//   Color get _rankColor => rank == 1
//       ? _C.rankGold
//       : rank == 2
//           ? _C.rankSilver
//           : _C.rankBronze;

//   String get _rankEmoji => rank == 1
//       ? '🥇'
//       : rank == 2
//           ? '🥈'
//           : '🥉';

//   double get _avatarSize => isFirst
//       ? 64.0
//       : rank == 2
//           ? 54.0
//           : 48.0;

//   // ── Pillar width বাড়ানো হয়েছে — content fit হবে ──────────────────────────
//   double get _pillarWidth => isFirst
//       ? 100.0
//       : rank == 2
//           ? 88.0
//           : 80.0;

//   @override
//   Widget build(BuildContext context) {
//     final canView = entry.isProfilePublic;
//     final initial = entry.name.isNotEmpty ? entry.name[0].toUpperCase() : 'U';
//     final firstName = entry.name.split(' ').first;

//     return GestureDetector(
//       onTap: canView
//           ? () {
//               HapticFeedback.selectionClick();
//               showPublicProfileSheet(
//                 context,
//                 entry: entry,
//                 year: year,
//                 month: month,
//               );
//             }
//           : null,
//       behavior: HitTestBehavior.opaque,
//       child: SizedBox(
//         width: _pillarWidth,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // ── Medal emoji ──────────────────────────────────────────
//             Text(
//               _rankEmoji,
//               style: TextStyle(fontSize: isFirst ? 22 : 18),
//             ).animate().scale(
//                   delay: Duration(milliseconds: rank * 80),
//                   duration: 380.ms,
//                   curve: Curves.elasticOut,
//                 ),

//             const SizedBox(height: 8),

//             // ── Avatar ───────────────────────────────────────────────
//             Stack(
//               clipBehavior: Clip.none,
//               alignment: Alignment.center,
//               children: [
//                 if (isFirst)
//                   Container(
//                     width: _avatarSize + 8,
//                     height: _avatarSize + 8,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: _rankColor.withOpacity(0.25),
//                         width: 3,
//                       ),
//                     ),
//                   ),
//                 Container(
//                   width: _avatarSize,
//                   height: _avatarSize,
//                   decoration: BoxDecoration(
//                     color: _rankColor.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: _rankColor,
//                       width: isFirst ? 2.5 : 2,
//                     ),
//                   ),
//                   child: Center(
//                     child: Text(
//                       initial,
//                       style: TextStyle(
//                         color: _rankColor,
//                         fontSize: isFirst
//                             ? 26
//                             : rank == 2
//                                 ? 20
//                                 : 18,
//                         fontWeight: FontWeight.w900,
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Public/Private dot
//                 Positioned(
//                   top: isFirst ? -2 : -1,
//                   right: isFirst ? -2 : -1,
//                   child: Container(
//                     width: 18,
//                     height: 18,
//                     decoration: BoxDecoration(
//                       color: canView ? const Color(0xFF0891B2) : _C.textHint,
//                       shape: BoxShape.circle,
//                       border: Border.all(color: _C.cardBg, width: 2),
//                     ),
//                     child: Icon(
//                       canView ? Icons.visibility_rounded : Icons.lock_rounded,
//                       size: 9,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 10),

//             // ── Name ─────────────────────────────────────────────────
//             SizedBox(
//               width: _pillarWidth,
//               child: Text(
//                 firstName,
//                 textAlign: TextAlign.center,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   color: _C.textPrimary,
//                   fontSize: isFirst ? 13 : 11.5,
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: -0.2,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 4),

//             // ── ID chip ──────────────────────────────────────────────
//             if (entry.id.isNotEmpty)
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: _C.serialBg,
//                   borderRadius: BorderRadius.circular(5),
//                   border: Border.all(color: _C.border, width: 0.5),
//                 ),
//                 child: Text(
//                   entry.id,
//                   style: const TextStyle(
//                     color: _C.serialText,
//                     fontSize: 9,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),

//             const SizedBox(height: 3),

//             // ── District — full text, wrap allowed ───────────────────
//             // maxLines নেই — পুরো district দেখাবে, wrap হলেও সমস্যা নেই
//             SizedBox(
//               width: _pillarWidth,
//               child: Text(
//                 entry.district,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   color: _C.districtText,
//                   fontSize: 9.5,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 10),

//             // ── Podium bar — content intrinsic height ────────────────
//             // barHeight fixed দিলে content clip হয়
//             // তাই Container এ minHeight দিয়ে content বাড়লে সাথে বাড়বে
//             Container(
//               width: _pillarWidth,
//               constraints: BoxConstraints(minHeight: barHeight),
//               decoration: BoxDecoration(
//                 color: _rankColor.withOpacity(0.06),
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(10),
//                 ),
//                 border: Border(
//                   top: BorderSide(color: _rankColor, width: 2),
//                   left: BorderSide(
//                       color: _rankColor.withOpacity(0.2), width: 0.5),
//                   right: BorderSide(
//                       color: _rankColor.withOpacity(0.2), width: 0.5),
//                 ),
//               ),
//               // ── ClipRect সরানো হয়েছে — overflow visible থাকবে ────
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Points — বড় করে
//                     Text(
//                       '${entry.totalPoints}',
//                       style: TextStyle(
//                         color: _rankColor,
//                         fontWeight: FontWeight.w900,
//                         fontSize: isFirst
//                             ? 20
//                             : rank == 2
//                                 ? 17
//                                 : 15,
//                         height: 1,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       'পয়েন্ট',
//                       style: TextStyle(
//                         color: _rankColor.withOpacity(0.6),
//                         fontSize: 9,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     // Completion % pill
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 3),
//                       decoration: BoxDecoration(
//                         color: _rankColor.withOpacity(0.12),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         '${entry.completionPercentage.toInt()}% ফরজ',
//                         style: TextStyle(
//                           color: _rankColor,
//                           fontSize: 9,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                     // Streak
//                     if (entry.streakDays > 0) ...[
//                       const SizedBox(height: 6),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Text('🔥', style: TextStyle(fontSize: 10)),
//                           const SizedBox(width: 2),
//                           Text(
//                             '${entry.streakDays} দিন',
//                             style: TextStyle(
//                               color: _rankColor.withOpacity(0.75),
//                               fontSize: 9.5,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ─────────────────────────────────────────────────────────────────────────────
// COMPACT INFO CHIP  — ID • District একটা chip এ
// ─────────────────────────────────────────────────────────────────────────────

class _CompactInfoChip extends StatelessWidget {
  final LeaderboardEntry entry;
  const _CompactInfoChip({required this.entry});

  @override
  Widget build(BuildContext context) {
    final parts = <String>[];
    if (entry.id.isNotEmpty) parts.add(entry.id);
    if (entry.district.isNotEmpty) parts.add(entry.district);
    if (parts.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: _C.districtBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _C.border, width: 0.5),
      ),
      child: Text(
        parts.join(' · '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: _C.districtText,
          fontSize: 9,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RANK TILE  — id badge left of rank, district in subtitle row
// ─────────────────────────────────────────────────────────────────────────────

class _RankTile extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool isLast;
  final int delay;
  final int year; // নতুন
  final int month;

  const _RankTile({
    required this.entry,
    required this.isLast,
    required this.delay,
    required this.year,
    required this.month,
  });

  static const _avatarColors = [
    _C.avatar1,
    _C.avatar2,
    _C.avatar3,
    _C.avatar4,
    _C.avatar5,
  ];

  Color get _avatarColor =>
      _avatarColors[(entry.rank - 4).clamp(0, _avatarColors.length - 1) %
          _avatarColors.length];

  @override
  Widget build(BuildContext context) {
    final isTop10 = entry.rank <= 10;
    final isWinner = entry.isWinner;
    final canView = entry.isProfilePublic;

    return GestureDetector(
      // _RankTile এর onTap এ
      onTap: canView
          ? () {
              HapticFeedback.selectionClick();
              showPublicProfileSheet(
                context,
                entry: entry,
                year: year, // leaderboard filter থেকে pass করো
                month: month,
              );
            }
          : null,
      // onTap: canView
      //     ? () {
      //         HapticFeedback.selectionClick();
      //         _openProfile(context);
      //       }
      //     : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: isWinner ? _C.goldPale : Colors.transparent,
          borderRadius: isLast
              ? const BorderRadius.vertical(bottom: Radius.circular(16))
              : null,
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: _C.border, width: 0.5),
                ),
        ),
        child: Row(
          children: [
            // ── Rank + optional id stacked ──────────────────────────────
            SizedBox(
              width: 36,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '#${entry.rank}',
                    style: TextStyle(
                      color: isTop10 ? _C.darkGreen : _C.textHint,
                      fontWeight: FontWeight.w800,
                      fontSize: isTop10 ? 14 : 12,
                      height: 1,
                    ),
                  ),
                  // if (entry.id != null) ...[
                  //   const SizedBox(height: 3),
                  //   _SerialBadge(id: entry.id!),
                  // ],
                ],
              ),
            ),

            const SizedBox(width: 6),

            // Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isTop10 ? _avatarColor : _C.textHint.withOpacity(0.4),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Center(
                child: Text(
                  entry.name.isNotEmpty ? entry.name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Name + meta row (dept · district · streak)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name row
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          entry.name,
                          style: const TextStyle(
                            color: _C.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isWinner) ...[
                        const SizedBox(width: 4),
                        const Text('🏆', style: TextStyle(fontSize: 11)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  // ── NEW: dept · district · streak ─────────────────────────
                  _MetaRow(entry: entry),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Points + completion %
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${entry.totalPoints}',
                  style: TextStyle(
                    color: isWinner
                        ? _C.gold
                        : isTop10
                            ? _C.darkGreen
                            : _C.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${entry.completionPercentage.toInt()}%',
                  style: const TextStyle(
                    color: _C.textHint,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),
                // ── Profile view indicator ──────────────────────────
                _ProfileBadge(isPublic: canView),
              ],
            ),
          ],
        ),
      )
          .animate(delay: Duration(milliseconds: delay))
          .fadeIn(duration: 260.ms)
          .slideX(begin: 0.04, curve: Curves.easeOut),
    );
  }
}

class _ProfileBadge extends StatelessWidget {
  final bool isPublic;
  const _ProfileBadge({required this.isPublic});

  @override
  Widget build(BuildContext context) {
    if (!isPublic) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F6F1),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: _C.border, width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.lock_outline_rounded, size: 8, color: _C.textHint),
            SizedBox(width: 2),
            Text(
              'Private',
              style: TextStyle(
                color: _C.textHint,
                fontSize: 8,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color(0xFF0891B2).withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.visibility_outlined, size: 8, color: Color(0xFF0891B2)),
          SizedBox(width: 2),
          Text(
            'দেখুন',
            style: TextStyle(
              color: Color(0xFF0891B2),
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// META ROW  — shared subtitle: department · district pill · streak
// ─────────────────────────────────────────────────────────────────────────────

class _MetaRow extends StatelessWidget {
  final LeaderboardEntry entry;
  const _MetaRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final hasid = entry.id != null;
    final hasDistrict = entry.district != null;
    final hasStreak = entry.streakDays > 0;

    return Wrap(
      spacing: 4,
      runSpacing: 3,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Department text
        if (hasid)
          Text(
            'ID: ${entry.id!}',
            style: const TextStyle(
              color: _C.textSecondary,
              fontSize: 10,
            ),
          ),

        // Dot separator before district (only if dept exists)
        if (hasid && hasDistrict)
          const Text(
            '·',
            style: TextStyle(color: _C.textHint, fontSize: 10),
          ),

        // District pill (new)
        if (hasDistrict) _DistrictPill(district: entry.district!),

        // Dot separator before streak
        if ((hasid || hasDistrict) && hasStreak)
          const Text(
            '·',
            style: TextStyle(color: _C.textHint, fontSize: 10),
          ),

        // Streak flame
        if (hasStreak)
          Text(
            '🔥 ${entry.streakDays}',
            style: const TextStyle(
              color: _C.amber,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MONTH PICKER SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _MonthPickerSheet extends StatefulWidget {
  final int year, month;
  final void Function(int, int) onPicked;

  const _MonthPickerSheet({
    required this.year,
    required this.month,
    required this.onPicked,
  });

  @override
  State<_MonthPickerSheet> createState() => _MonthPickerSheetState();
}

class _MonthPickerSheetState extends State<_MonthPickerSheet> {
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
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: _C.border,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'মাস বেছে নিন',
            style: TextStyle(
              color: _C.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _YearBtn(
                icon: Icons.chevron_left_rounded,
                onTap: () => setState(() => _y--),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
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
              _YearBtn(
                icon: Icons.chevron_right_rounded,
                onTap: _y < now.year ? () => setState(() => _y++) : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
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
              return GestureDetector(
                onTap: () {
                  widget.onPicked(_y, i + 1);
                  Navigator.pop(context);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: isSelected ? _C.darkGreen : _C.pageBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? _C.darkGreen : _C.border,
                      width: 0.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      AppConstants.bengaliMonths[i],
                      style: TextStyle(
                        color: isSelected ? Colors.white : _C.textSecondary,
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

class _YearBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _YearBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: onTap != null ? _C.greenLight : _C.pageBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: onTap != null ? _C.borderMid : _C.border,
            width: 0.5,
          ),
        ),
        child: Icon(
          icon,
          color: onTap != null ? _C.darkGreen : _C.textHint,
          size: 20,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SKELETONS
// ─────────────────────────────────────────────────────────────────────────────

class _LeaderboardSkeleton extends StatelessWidget {
  const _LeaderboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(width: 100, height: 14),
          const SizedBox(height: 12),
          _shimmerBox(width: double.infinity, height: 290, radius: 16),
          const SizedBox(height: 24),
          _shimmerBox(width: 100, height: 14),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: _C.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _C.border, width: 0.5),
            ),
            child: Column(
              children: List.generate(5, (i) {
                return Container(
                  height: 68, // slightly taller for new meta row
                  margin:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: _C.pageBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ).animate(onPlay: (c) => c.repeat()).shimmer(
                  duration: 1200.ms,
                  delay: Duration(milliseconds: i * 70),
                  colors: [
                    _C.pageBg,
                    const Color(0xFFE8ECE8),
                    _C.pageBg,
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    double radius = 10,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(radius),
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
  final String message;
  final VoidCallback onRetry;
  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _C.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.border, width: 0.5),
        ),
        child: Column(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Color(0xFFEF4444), size: 28),
            const SizedBox(height: 10),
            const Text(
              'ত্রুটি হয়েছে',
              style: TextStyle(
                  color: _C.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _C.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                decoration: BoxDecoration(
                  color: _C.greenLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'পুনরায় চেষ্টা করুন',
                  style: TextStyle(
                      color: _C.darkGreen,
                      fontWeight: FontWeight.w700,
                      fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String label;
  const _EmptyCard({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: _C.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.border, width: 0.5),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('📭', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: _C.textHint,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
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
// SINGLE ENTRY CARD  — shows district + id below department
// ─────────────────────────────────────────────────────────────────────────────

class _SingleEntryCard extends StatelessWidget {
  final LeaderboardEntry entry;
  const _SingleEntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            '🏆 একমাত্র আমলকারী 🏆',
            style: TextStyle(
                color: _C.gold, fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _C.rankGold.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: _C.rankGold, width: 3),
            ),
            child: Center(
              child: Text(
                entry.name.isNotEmpty ? entry.name[0].toUpperCase() : 'U',
                style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: _C.rankGold,
                    fontSize: 32),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            entry.name,
            style: const TextStyle(
                color: _C.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 18),
          ),

          // Department
          if (entry.department != null) ...[
            const SizedBox(height: 4),
            Text(
              entry.department!,
              style: const TextStyle(color: _C.textSecondary, fontSize: 12),
            ),
          ],

          // ── NEW: id + district ───────────────────────────────────
          if (entry.id != null || entry.district != null) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 5,
              alignment: WrapAlignment.center,
              children: [
                if (entry.id != null) _SerialBadge(id: entry.id!),
                if (entry.district != null)
                  _DistrictPill(district: entry.district!),
              ],
            ),
          ],

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _C.goldLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '${entry.totalPoints}',
                  style: const TextStyle(
                      color: _C.gold,
                      fontWeight: FontWeight.w900,
                      fontSize: 28),
                ),
                const Text(
                  'মোট পয়েন্ট',
                  style: TextStyle(color: _C.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _C.greenLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: _C.green, size: 14),
                const SizedBox(width: 4),
                Text(
                  'সম্পন্ন: ${entry.completionPercentage.toInt()}%',
                  style: const TextStyle(
                      color: _C.darkGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                ),
              ],
            ),
          ),
          if (entry.streakDays > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _C.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 4),
                  Text(
                    '${entry.streakDays} দিন ধারাবাহিক',
                    style: const TextStyle(
                        color: _C.amber,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NO MORE ENTRIES CARD
// ─────────────────────────────────────────────────────────────────────────────

class _NoMoreEntriesCard extends StatelessWidget {
  final int count;
  const _NoMoreEntriesCard({required this.count});

  @override
  Widget build(BuildContext context) {
    final String message;
    if (count == 1) {
      message = 'এই মাসে শুধুমাত্র একজন আমলকারী আছেন';
    } else if (count == 2) {
      message = 'এই মাসে মোট ২ জন আমলকারী আছেন';
    } else {
      message = 'এই মাসে মোট ৩ জন আমলকারী আছেন';
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 0.5),
      ),
      child: Column(
        children: [
          Text(
            count == 1 ? '👤' : '📊',
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
                color: _C.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            count == 1
                ? 'উপরের তালিকায় সকল তথ্য দেখানো হয়েছে'
                : 'তালিকায় আর কোনো আমলকারী নেই',
            textAlign: TextAlign.center,
            style: const TextStyle(color: _C.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MONTH CHIP DELEGATE (sticky sliver)
// ─────────────────────────────────────────────────────────────────────────────

class _MonthChipDelegate extends SliverPersistentHeaderDelegate {
  final LeaderboardFilter filter;
  final VoidCallback onPick;

  const _MonthChipDelegate({
    required this.filter,
    required this.onPick,
  });

  static const _height = 53.0;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  bool shouldRebuild(_MonthChipDelegate old) => old.filter != filter;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final now = DateTime.now();
    final months = List.generate(6, (i) {
      final dt = DateTime(now.year, now.month - i);
      return (year: dt.year, month: dt.month);
    });

    return Container(
      color: _C.cardBg,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 11, 16, 11),
              child: Row(
                children: months.map((m) {
                  final isActive =
                      m.month == filter.month && m.year == filter.year;
                  final label = AppConstants.bengaliMonths[m.month - 1];
                  return GestureDetector(
                    onTap: onPick,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: isActive ? _C.darkGreen : _C.pageBg,
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(
                          color: isActive ? _C.darkGreen : _C.border,
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        m.year == now.year ? label : '$label ${m.year}',
                        style: TextStyle(
                          color: isActive ? Colors.white : _C.textSecondary,
                          fontSize: 11,
                          fontWeight:
                              isActive ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(color: _C.border, height: 0.5, thickness: 0.5),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MY RANK ERROR CARD
// ─────────────────────────────────────────────────────────────────────────────

class _MyRankErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _MyRankErrorCard({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: _C.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.error_outline_rounded,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'আমার অবস্থান লোড করতে পারেনি',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  message.length > 50
                      ? '${message.substring(0, 50)}...'
                      : message,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5), fontSize: 9),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.white.withOpacity(0.2), width: 0.5),
              ),
              child: const Text(
                'রিট্রাই',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
