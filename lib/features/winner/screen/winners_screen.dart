import 'package:amal_tracker/features/winner/provider/winner_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

// ─────────────────────────────────────────────────────────────────────────────
// WINNERS SCREEN — LeaderboardScreen এর design token/animation/copy অনুসরণ করে,
// leaderboard এর মতোই live না — frozen monthly snapshot দেখায়।
// Gender-gated: পুরুষ শুধু male tab দেখে, নারী combined/male/female সব দেখে।
// ─────────────────────────────────────────────────────────────────────────────

class WinnersScreen extends ConsumerWidget {
  const WinnersScreen({super.key});

  void _pickMonth(BuildContext context, WidgetRef ref) {
    final f = ref.read(winnersFilterProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _WinnersMonthPickerSheet(
        year: f.year,
        month: f.month,
        onPicked: (y, m) {
          ref.read(winnersFilterProvider.notifier).state = (year: y, month: m);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(winnersFilterProvider);
    final tab = ref.watch(winnerTabProvider);
    final availableTabs = ref.watch(availableWinnerTabsProvider);
    final winnersAsync = ref.watch(
      monthlyWinnersProvider((year: filter.year, month: filter.month)),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: context.colors.pageBg,
        body: RefreshIndicator(
          color: context.colors.darkGreen,
          onRefresh: () => ref.refresh(
            monthlyWinnersProvider((year: filter.year, month: filter.month))
                .future,
          ),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ── App Bar ─────────────────────────────────────────────────
              SliverAppBar(
                pinned: true,
                expandedHeight: 0,
                toolbarHeight: 56,
                backgroundColor: context.colors.darkGreen,
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                iconTheme: const IconThemeData(color: Colors.white),
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
                    child: const Icon(Icons.emoji_events_rounded,
                        color: Colors.white, size: 15),
                  ),
                  const SizedBox(width: 10),
                  const Text('মাসিক বিজয়ীরা',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2)),
                ]),
                actions: [
                  GestureDetector(
                    onTap: () => _pickMonth(context, ref),
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.18), width: 0.5),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.calendar_month_rounded,
                            size: 13, color: Colors.white.withOpacity(0.75)),
                        const SizedBox(width: 5),
                        Text(
                            '${AppConstants.bengaliMonths[filter.month - 1]} ${filter.year}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 11.5)),
                        const SizedBox(width: 2),
                        Icon(Icons.keyboard_arrow_down_rounded,
                            size: 14, color: Colors.white.withOpacity(0.6)),
                      ]),
                    ),
                  ),
                ],
              ),

              // ── Hero subtitle band ─────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  color: context.colors.darkGreen,
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
                  child: Text(
                    '${AppConstants.bengaliMonths[filter.month - 1]} মাসের সেরা আমলকারীরা',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                  ),
                ).animate().fadeIn(duration: 260.ms),
              ),

              // ── Body ─────────────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                sliver: winnersAsync.when(
                  loading: () => SliverToBoxAdapter(
                      child: const _WinnersSkeleton()
                          .animate()
                          .fadeIn(delay: 80.ms, duration: 260.ms)),
                  error: (e, _) => SliverToBoxAdapter(
                    child: _ErrorCard(
                      message: e.toString(),
                      onRetry: () => ref.invalidate(monthlyWinnersProvider(
                          (year: filter.year, month: filter.month))),
                    ).animate().fadeIn(duration: 260.ms),
                  ),
                  data: (data) {
                    if (!data.finalized) {
                      return SliverToBoxAdapter(
                          child: const _NotFinalizedCard()
                              .animate()
                              .fadeIn(duration: 260.ms));
                    }
                    return _buildContent(
                        context, ref, data, tab, availableTabs);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    MonthlyWinnersData data,
    WinnerTab tab,
    List<WinnerTab> availableTabs,
  ) {
    // পুরুষ user এর জন্য availableTabs = [male] হলেও, safety net হিসেবে
    // এখানেও নিশ্চিত করা হচ্ছে selected tab আসলে available কিনা —
    // provider state কোনোভাবে stale থাকলেও female/combined data leak হবে না।
    final effectiveTab =
        availableTabs.contains(tab) ? tab : availableTabs.first;

    final list = switch (effectiveTab) {
      WinnerTab.combined => data.combinedTop,
      WinnerTab.male => data.maleTop,
      WinnerTab.female => data.femaleTop,
    };

    final top3 = list.take(3).toList();
    final rest = list.length > 3 ? list.sublist(3) : <WinnerEntry>[];

    // ক্যাটাগরি অ্যাওয়ার্ড থেকেও gender অনুযায়ী বাদ দেওয়া — পুরুষ user
    // TOP_QURAN (নারীদের ক্যাটাগরি) দেখবে না।
    final visibleAwards = Map<String, CategoryAward>.fromEntries(
      data.categoryAwards.entries.where((e) {
        if (availableTabs.length > 1) return true; // নারী — সব দেখবে
        // পুরুষ — শুধু male-relevant category (TOP_JAMAAT, TOP_STREAK)
        return e.key != 'TOP_QURAN';
      }),
    );

    return SliverList(
      delegate: SliverChildListDelegate([
        // একাধিক tab থাকলেই selector দেখানো — পুরুষ user এর জন্য এক তা
        // থাকায় selector আর দেখানো হয় না (দেখানোর কোনো মানে নেই)
        if (availableTabs.length > 1) ...[
          _TabSelector(
            tabs: availableTabs,
            selected: effectiveTab,
            onChanged: (t) => ref.read(winnerTabProvider.notifier).state = t,
          ).animate().fadeIn(delay: 80.ms),
          const SizedBox(height: 20),
        ],

        if (top3.isEmpty)
          const _EmptyCard(label: 'এই তালিকায় এখনো কেউ নেই')
        else ...[
          _WinnersPodium(top3: top3)
              .animate()
              .fadeIn(delay: 120.ms, duration: 320.ms)
              .slideY(begin: 0.08, curve: Curves.easeOut),
          if (rest.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: context.colors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.colors.border, width: 0.5),
              ),
              child: Column(
                children: List.generate(
                  rest.length,
                  (i) => _WinnerTile(
                    entry: rest[i],
                    isLast: i == rest.length - 1,
                    delay: 160 + i * 40,
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 160.ms, duration: 280.ms),
          ],
        ],

        // ── Category Awards ────────────────────────────────────────────────
        if (visibleAwards.isNotEmpty) ...[
          const SizedBox(height: 28),
          Row(children: [
            const Text('🏅', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 7),
            Text('বিশেষ ক্যাটাগরি সেরা',
                style: TextStyle(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    letterSpacing: -0.2)),
          ]).animate().fadeIn(delay: 220.ms),
          const SizedBox(height: 12),
          ...visibleAwards.entries.toList().asMap().entries.map((e) {
            final i = e.key;
            final entry = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child:
                  _CategoryAwardCard(categoryKey: entry.key, award: entry.value)
                      .animate()
                      .fadeIn(delay: Duration(milliseconds: 240 + i * 60))
                      .slideX(begin: 0.04, curve: Curves.easeOut),
            );
          }),
        ],
        const SizedBox(height: 8),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB SELECTOR — এখন গতিশীল, availableTabs অনুযায়ী শুধু প্রাসঙ্গিক tab দেখায়
// ─────────────────────────────────────────────────────────────────────────────

class _TabSelector extends StatelessWidget {
  final List<WinnerTab> tabs;
  final WinnerTab selected;
  final void Function(WinnerTab) onChanged;
  const _TabSelector({
    required this.tabs,
    required this.selected,
    required this.onChanged,
  });

  (String label, IconData icon) _meta(WinnerTab t) => switch (t) {
        WinnerTab.combined => ('সবাই', Icons.groups_rounded),
        WinnerTab.male => ('পুরুষ', Icons.male_rounded),
        WinnerTab.female => ('মহিলা', Icons.female_rounded),
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.colors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.border, width: 0.5),
      ),
      child: Row(
        children: tabs.map((t) {
          final (label, icon) = _meta(t);
          final isSelected = t == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onChanged(t);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colors.darkGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(icon,
                      size: 14,
                      color: isSelected
                          ? Colors.white
                          : context.colors.textSecondary),
                  const SizedBox(width: 5),
                  Text(label,
                      style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : context.colors.textSecondary,
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w600)),
                ]),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WINNERS PODIUM
// ─────────────────────────────────────────────────────────────────────────────

class _WinnersPodium extends StatelessWidget {
  final List<WinnerEntry> top3;
  const _WinnersPodium({required this.top3});

  @override
  Widget build(BuildContext context) {
    final first = top3[0];
    final second = top3.length > 1 ? top3[1] : null;
    final third = top3.length > 2 ? top3[2] : null;

    final title = top3.length == 1
        ? 'এই মাসের বিজয়ী'
        : (top3.length == 2 ? 'এই মাসের শীর্ষ দুইজন' : 'এই মাসের শীর্ষ তিনজন');

    return Container(
      decoration: BoxDecoration(
        color: context.colors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colors.border, width: 0.5),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('🏆', style: TextStyle(fontSize: 13)),
            const SizedBox(width: 6),
            Text(title,
                style: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
            const SizedBox(width: 6),
            const Text('🏆', style: TextStyle(fontSize: 13)),
          ]),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (second != null) ...[
                _WinnerPillar(entry: second, rank: 2),
                const SizedBox(width: 12),
              ],
              _WinnerPillar(entry: first, rank: 1, isFirst: true),
              if (third != null) ...[
                const SizedBox(width: 12),
                _WinnerPillar(entry: third, rank: 3),
              ],
            ],
          ),
        ),
      ]),
    );
  }
}

class _WinnerPillar extends StatelessWidget {
  final WinnerEntry entry;
  final int rank;
  final bool isFirst;
  const _WinnerPillar(
      {required this.entry, required this.rank, this.isFirst = false});

  Color _rankColor(BuildContext context) => rank == 1
      ? context.colors.rankGold
      : rank == 2
          ? context.colors.rankSilver
          : context.colors.rankBronze;

  String get _rankEmoji => rank == 1 ? '🥇' : (rank == 2 ? '🥈' : '🥉');
  double get _avatarSize => isFirst ? 60.0 : (rank == 2 ? 48.0 : 44.0);
  double get _pillarWidth => isFirst ? 100.0 : (rank == 2 ? 88.0 : 80.0);
  double get _pillarHeight => isFirst ? 100.0 : (rank == 2 ? 84.0 : 72.0);

  @override
  Widget build(BuildContext context) {
    final initial = entry.name.isNotEmpty ? entry.name[0].toUpperCase() : 'U';

    return SizedBox(
      width: _pillarWidth,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(_rankEmoji, style: TextStyle(fontSize: isFirst ? 24 : 20))
            .animate()
            .scale(
                delay: Duration(milliseconds: rank * 80),
                duration: 380.ms,
                curve: Curves.elasticOut),
        const SizedBox(height: 4),
        Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
          if (isFirst)
            Container(
              width: _avatarSize + 12,
              height: _avatarSize + 12,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    _rankColor(context).withOpacity(0.20),
                    _rankColor(context).withOpacity(0.0),
                  ])),
            ),
          Container(
            width: _avatarSize,
            height: _avatarSize,
            decoration: BoxDecoration(
                color: _rankColor(context).withOpacity(0.10),
                shape: BoxShape.circle,
                border: Border.all(
                    color: _rankColor(context), width: isFirst ? 2.5 : 2.0),
                boxShadow: [
                  BoxShadow(
                      color: _rankColor(context)
                          .withOpacity(isFirst ? 0.30 : 0.15),
                      blurRadius: isFirst ? 14 : 8)
                ]),
            child: Center(
                child: Text(initial,
                    style: TextStyle(
                        color: _rankColor(context),
                        fontSize: isFirst ? 24 : (rank == 2 ? 18 : 16),
                        fontWeight: FontWeight.w900,
                        height: 1))),
          ),
        ]),
        const SizedBox(height: 5),
        Text(entry.name.split(' ').first,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: context.colors.textPrimary,
                fontSize: isFirst ? 13.5 : 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2)),
        const SizedBox(height: 6),
        Container(
          width: _pillarWidth,
          height: _pillarHeight,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _rankColor(context).withOpacity(0.9),
                  _rankColor(context).withOpacity(0.55),
                ]),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            border:
                Border.all(color: Colors.white.withOpacity(0.2), width: 0.75),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('${entry.completionPercentage.toInt()}%',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: isFirst ? 16 : 13,
                          height: 1)),
                  Text('সম্পন্ন',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: isFirst ? 8.0 : 7.0,
                          fontWeight: FontWeight.w700)),
                ]),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded,
                            size: 8, color: Colors.white.withOpacity(0.85)),
                        const SizedBox(width: 1),
                        Text('${entry.farzCompletedDays}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w800)),
                        if (entry.congregationDaysSum != null) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.people_rounded,
                              size: 8, color: Colors.white.withOpacity(0.85)),
                          const SizedBox(width: 1),
                          Text('${entry.congregationDaysSum}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800)),
                        ],
                        if (entry.streakDays > 0) ...[
                          const SizedBox(width: 4),
                          const Text('🔥', style: TextStyle(fontSize: 8)),
                          Text('${entry.streakDays}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ]),
                ),
                Text('#$rank',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w900,
                        fontSize: isFirst ? 14 : 12,
                        height: 1)),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WINNER TILE
// ─────────────────────────────────────────────────────────────────────────────

class _WinnerTile extends StatelessWidget {
  final WinnerEntry entry;
  final bool isLast;
  final int delay;
  const _WinnerTile(
      {required this.entry, required this.isLast, required this.delay});

  List<Color> _avatarColors(BuildContext context) => [
        context.colors.avatar1,
        context.colors.avatar2,
        context.colors.avatar3,
        context.colors.avatar4,
        context.colors.avatar5,
      ];

  @override
  Widget build(BuildContext context) {
    final colors = _avatarColors(context);
    final avatarColor =
        colors[(entry.rank - 1).clamp(0, colors.length - 1) % colors.length];
    final pct = entry.completionPercentage.toInt();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        borderRadius: isLast
            ? const BorderRadius.vertical(bottom: Radius.circular(16))
            : null,
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: context.colors.border, width: 0.5)),
      ),
      child: Row(children: [
        SizedBox(
          width: 30,
          child: Text('#${entry.rank}',
              style: TextStyle(
                  color: context.colors.darkGreen,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  height: 1)),
        ),
        const SizedBox(width: 6),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: avatarColor, borderRadius: BorderRadius.circular(11)),
          child: Center(
              child: Text(
                  entry.name.isNotEmpty ? entry.name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16))),
        ),
        const SizedBox(width: 10),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(entry.name,
                style: TextStyle(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13),
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 3),
            Text(
                entry.congregationDaysSum != null
                    ? '${entry.farzCompletedDays} ফরজ · ${entry.congregationDaysSum} জামাত'
                    : '${entry.farzCompletedDays} ফরজ · ${entry.quranAyahTotal} আয়াত',
                style: TextStyle(
                    color: context.colors.textHint,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w500)),
          ]),
        ),
        Text('$pct%',
            style: TextStyle(
                color: context.colors.darkGreen,
                fontWeight: FontWeight.w900,
                fontSize: 15,
                height: 1)),
      ]),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 260.ms)
        .slideX(begin: 0.04, curve: Curves.easeOut);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CATEGORY AWARD CARD
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryAwardCard extends StatelessWidget {
  final String categoryKey;
  final CategoryAward award;
  const _CategoryAwardCard({required this.categoryKey, required this.award});

  (String label, IconData icon, String unit) get _meta => switch (categoryKey) {
        'TOP_JAMAAT' => ('সর্বোচ্চ জামাত', Icons.mosque_rounded, 'দিন জামাতে'),
        'TOP_QURAN' => ('সর্বোচ্চ তিলাওয়াত', Icons.menu_book_rounded, 'আয়াত'),
        'TOP_STREAK' => (
            'সর্বোচ্চ ধারাবাহিকতা',
            Icons.local_fire_department_rounded,
            'দিনের ধারা'
          ),
        _ => (categoryKey, Icons.emoji_events_rounded, ''),
      };

  @override
  Widget build(BuildContext context) {
    final (label, icon, unit) = _meta;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border, width: 0.5),
      ),
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
              color: context.colors.gold.withOpacity(0.14),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: context.colors.gold, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: TextStyle(
                    color: context.colors.textHint,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(award.name,
                style: TextStyle(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14)),
          ]),
        ),
        Text('${award.value} $unit',
            textAlign: TextAlign.right,
            style: TextStyle(
                color: context.colors.gold,
                fontWeight: FontWeight.w800,
                fontSize: 12)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NOT FINALIZED
// ─────────────────────────────────────────────────────────────────────────────

class _NotFinalizedCard extends StatelessWidget {
  const _NotFinalizedCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
          color: context.colors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border, width: 0.5)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('⏳', style: TextStyle(fontSize: 28)),
        const SizedBox(height: 10),
        Text('এই মাসের বিজয়ী এখনো নির্ধারণ হয়নি',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 13.5)),
        const SizedBox(height: 6),
        Text('প্রতি মাসের ৬ তারিখে ফলাফল প্রকাশিত হয়',
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.textHint, fontSize: 11.5)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EMPTY / ERROR
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyCard extends StatelessWidget {
  final String label;
  const _EmptyCard({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
          color: context.colors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border, width: 0.5)),
      child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('📭', style: TextStyle(fontSize: 24)),
        const SizedBox(height: 8),
        Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: context.colors.textHint,
                fontSize: 12,
                fontWeight: FontWeight.w500)),
      ])),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: context.colors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border, width: 0.5)),
      child: Column(children: [
        Icon(Icons.error_outline_rounded, color: context.colors.red, size: 28),
        const SizedBox(height: 10),
        Text('ত্রুটি হয়েছে',
            style: TextStyle(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14)),
        const SizedBox(height: 6),
        Text(message,
            textAlign: TextAlign.center,
            style:
                TextStyle(color: context.colors.textSecondary, fontSize: 12)),
        const SizedBox(height: 16),
        GestureDetector(
            onTap: onRetry,
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                decoration: BoxDecoration(
                    color: context.colors.greenLight,
                    borderRadius: BorderRadius.circular(10)),
                child: Text('পুনরায় চেষ্টা করুন',
                    style: TextStyle(
                        color: context.colors.darkGreen,
                        fontWeight: FontWeight.w700,
                        fontSize: 12)))),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SKELETON
// ─────────────────────────────────────────────────────────────────────────────

class _WinnersSkeleton extends StatelessWidget {
  const _WinnersSkeleton();

  Widget _bone(BuildContext context,
      {required double width, required double height, double radius = 10}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: context.colors.pageBg,
          borderRadius: BorderRadius.circular(radius)),
    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, colors: [
      context.colors.cardBg,
      context.colors.shimmerHighlight,
      context.colors.cardBg,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _bone(context, width: double.infinity, height: 44, radius: 14),
      const SizedBox(height: 20),
      Container(
        height: 190,
        decoration: BoxDecoration(
            color: context.colors.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: context.colors.border, width: 0.5)),
      ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, colors: [
        context.colors.cardBg,
        context.colors.shimmerHighlight,
        context.colors.cardBg,
      ]),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MONTH PICKER SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _WinnersMonthPickerSheet extends StatefulWidget {
  final int year, month;
  final void Function(int, int) onPicked;
  const _WinnersMonthPickerSheet(
      {required this.year, required this.month, required this.onPicked});

  @override
  State<_WinnersMonthPickerSheet> createState() =>
      _WinnersMonthPickerSheetState();
}

class _WinnersMonthPickerSheetState extends State<_WinnersMonthPickerSheet> {
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
    final maxYear = now.year;
    final maxMonthThisYear = now.month == 1 ? 12 : now.month - 1;

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
        const SizedBox(height: 20),
        Text('মাস বেছে নিন',
            style: TextStyle(
                color: context.colors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 18),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          GestureDetector(
            onTap: () => setState(() => _y--),
            child: Container(
              width: 38,
              height: 38,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: context.colors.greenLight,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: context.colors.borderMid2, width: 0.5)),
              child: Icon(Icons.chevron_left_rounded,
                  color: context.colors.darkGreen, size: 20),
            ),
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              decoration: BoxDecoration(
                  color: context.colors.greenLight,
                  borderRadius: BorderRadius.circular(12)),
              child: Text('$_y',
                  style: TextStyle(
                      color: context.colors.darkGreen,
                      fontWeight: FontWeight.w800,
                      fontSize: 18))),
          GestureDetector(
            onTap: _y < maxYear ? () => setState(() => _y++) : null,
            child: Container(
              width: 38,
              height: 38,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: _y < maxYear
                      ? context.colors.greenLight
                      : context.colors.pageBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: _y < maxYear
                          ? context.colors.borderMid2
                          : context.colors.border,
                      width: 0.5)),
              child: Icon(Icons.chevron_right_rounded,
                  color: _y < maxYear
                      ? context.colors.darkGreen
                      : context.colors.textHint,
                  size: 20),
            ),
          ),
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
            final isFuture = _y == maxYear && i + 1 > maxMonthThisYear;
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
                        ? context.colors.darkGreen
                        : context.colors.pageBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: isSelected
                            ? context.colors.darkGreen
                            : isFuture
                                ? context.colors.border.withOpacity(0.4)
                                : context.colors.border,
                        width: 0.5)),
                child: Center(
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
                                : FontWeight.w500))),
              ),
            );
          },
        ),
        const SizedBox(height: 4),
      ]),
    );
  }
}
