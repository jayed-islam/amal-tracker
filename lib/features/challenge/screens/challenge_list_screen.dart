import 'package:amal_tracker/features/challenge/provider/challenge_provider.dart';
import 'package:amal_tracker/features/challenge/model/challenge_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/challenge_card.dart';
import '../widgets/challenge_colors.dart';
import 'challenge_detail_screen.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';
import '../../../shared/widgets/delayed_progress_indicator.dart';

// ─────────────────────────────────────────────────────────────────────────
// CHALLENGE LIST SCREEN — এখন home/monthly এর মতোই একটা full main-tab
// screen: pinned SliverAppBar (monthly এর app bar chrome এর সাথে মেলানো),
// দার্ক-গ্রিন hero band এ overall stats (সক্রিয়/যোগ দেওয়া/সম্পন্ন), ফিল্টার
// চিপ সারি (AmolFilterChip এর ভিজ্যুয়াল ভাষায়), এবং real-shape skeleton +
// background-refresh progress bar (home/monthly এর isBackgroundRefreshing
// প্যাটার্ন হুবহু অনুসরণ করে)।
//
// NOTE FOR ABDULLAH: home/monthly এর মতো CacheTab-driven lazy-refresh
// (checkAndRefreshTab(ref, CacheTab.xxx, ...)) এখানে ইচ্ছাকৃতভাবে যোগ করা
// হয়নি — CacheTab enum এর ভেতর "challenges" ভ্যালু আছে কিনা আমি নিশ্চিত না
// (cache_provider.dart ফাইলটা আমাকে দেওয়া হয়নি), আর ভুল enum ভ্যালু ধরে
// নিলে কম্পাইল ভেঙে যেত। enum এ `challenges` যোগ করলে এখানে ঠিক home এর
// build() এর মতো এই ব্লক বসিয়ে দিন:
//
//   final activeIndex = ref.watch(activeTabIndexProvider);
//   if (activeIndex == <tab-index>) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         checkAndRefreshTab(ref, CacheTab.challenges,
//             () => ref.refresh(activeChallengesProvider), ttl: const Duration(minutes: 5));
//       }
//     });
//   }
//
// এখন pull-to-refresh + প্রথম-লোড FutureProvider দিয়েই ডেটা তাজা রাখা হচ্ছে।
// ─────────────────────────────────────────────────────────────────────────

enum _ChFilter { all, joined, completed, available }

class ChallengeListScreen extends ConsumerStatefulWidget {
  const ChallengeListScreen({super.key});

  @override
  ConsumerState<ChallengeListScreen> createState() =>
      _ChallengeListScreenState();
}

class _ChallengeListScreenState extends ConsumerState<ChallengeListScreen> {
  final _sc = ScrollController();
  _ChFilter _filter = _ChFilter.all;

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  Future<void> _refresh() => ref.refresh(activeChallengesProvider.future);

  void _openDetail(Challenge c) {
    HapticFeedback.selectionClick();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ChallengeDetailScreen(challengeId: c.id),
    ));
  }

  void _showInfoSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _HowChallengesWorkSheet(),
    );
  }

  List<Challenge> _applyFilter(List<Challenge> all) {
    switch (_filter) {
      case _ChFilter.joined:
        return all.where((c) => c.isJoined && !c.isCompleted).toList();
      case _ChFilter.completed:
        return all.where((c) => c.isJoined && c.isCompleted).toList();
      case _ChFilter.available:
        return all.where((c) => !c.isJoined).toList();
      case _ChFilter.all:
        final list = [...all];
        // যোগ দেওয়া (চলমান) আগে, তারপর নতুন/available, সবশেষে সম্পন্ন —
        // প্রতিটা গ্রুপের ভেতরে ডেডলাইন কাছে থাকা আগে।
        int rank(Challenge c) {
          if (c.isJoined && !c.isCompleted) return 0;
          if (!c.isJoined) return 1;
          return 2;
        }

        list.sort((a, b) {
          final r = rank(a).compareTo(rank(b));
          if (r != 0) return r;
          return a.daysLeft.compareTo(b.daysLeft);
        });
        return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<Challenge>>>(activeChallengesProvider, (prev, next) {
      if (next.hasError && !next.isLoading && next.hasValue) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('হালনাগাদ করা সম্ভব হয়নি। ইন্টারনেট সংযোগ পরীক্ষা করুন।',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          backgroundColor: context.colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
    });

    final challengesAsync = ref.watch(activeChallengesProvider);
    final isBackgroundRefreshing =
        challengesAsync.isLoading && challengesAsync.hasValue;
    final showSkeleton = challengesAsync.isLoading && !challengesAsync.hasValue;
    final showError = challengesAsync.hasError && !challengesAsync.hasValue;

    return Scaffold(
      backgroundColor: context.colors.pageBg,
      body: Stack(
        children: [
          RefreshIndicator(
            color: context.colors.darkGreen,
            onRefresh: _refresh,
            child: CustomScrollView(
              controller: _sc,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // ── App Bar ────────────────────────────────────────────────
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
                      child: const Icon(Icons.emoji_events_outlined,
                          color: Colors.white, size: 15),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('চ্যালেঞ্জ',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.55),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500)),
                          const Text('একসাথে এগিয়ে যাই',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                  height: 1.1)),
                        ],
                      ),
                    ),
                  ]),
                  actions: [
                    GestureDetector(
                      onTap: _showInfoSheet,
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.18),
                              width: 0.5),
                        ),
                        child: const Icon(Icons.info_outline_rounded,
                            size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                // ── Hero band — overall stats ─────────────────────────────
                SliverToBoxAdapter(
                  child: showSkeleton
                      ? const _HeroBandSkeleton()
                      : showError
                          ? const SizedBox.shrink()
                          : _HeroBand(challenges: challengesAsync.value!),
                ),

                // ── Filter chips ───────────────────────────────────────────
                SliverToBoxAdapter(
                  child: showSkeleton || showError
                      ? const SizedBox.shrink()
                      : challengesAsync.value!.isEmpty
                          ? const SizedBox.shrink()
                          : _FilterRow(
                              filter: _filter,
                              onChanged: (f) => setState(() => _filter = f),
                            ),
                ),

                // ── List ───────────────────────────────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(14, 6, 14, 30),
                  sliver: showSkeleton
                      ? SliverList(
                          delegate: SliverChildListDelegate(List.generate(
                              3, (_) => const ChallengeCardSkeleton())),
                        )
                      : showError
                          ? SliverToBoxAdapter(
                              child: ChErrorState(
                                  onRetry: () =>
                                      ref.invalidate(activeChallengesProvider)),
                            )
                          : _buildSliverList(challengesAsync.value!),
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

  Widget _buildSliverList(List<Challenge> list) {
    if (list.isEmpty) {
      return const SliverToBoxAdapter(
        child: ChEmptyState(
          emoji: '🏆',
          title: 'এই মুহূর্তে কোনো চ্যালেঞ্জ নেই',
          subtitle: 'শীঘ্রই নতুন চ্যালেঞ্জ যুক্ত হবে',
        ),
      );
    }
    final filtered = _applyFilter(list);
    if (filtered.isEmpty) {
      return SliverToBoxAdapter(
        child: ChEmptyState(
          emoji: _emptyEmojiFor(_filter),
          title: _emptyTitleFor(_filter),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, i) {
          final c = filtered[i];
          return ChallengeCard(
            challenge: c,
            index: i,
            onTap: () => _openDetail(c),
          );
        },
        childCount: filtered.length,
      ),
    );
  }

  String _emptyEmojiFor(_ChFilter f) {
    switch (f) {
      case _ChFilter.joined:
        return '🙌';
      case _ChFilter.completed:
        return '🎯';
      case _ChFilter.available:
        return '🔎';
      case _ChFilter.all:
        return '🏆';
    }
  }

  String _emptyTitleFor(_ChFilter f) {
    switch (f) {
      case _ChFilter.joined:
        return 'আপনি এখনো কোনো চলমান চ্যালেঞ্জে যোগ দেননি';
      case _ChFilter.completed:
        return 'এখনো কোনো চ্যালেঞ্জ সম্পন্ন হয়নি';
      case _ChFilter.available:
        return 'নতুন যোগ দেওয়ার মতো কোনো চ্যালেঞ্জ নেই';
      case _ChFilter.all:
        return 'কোনো চ্যালেঞ্জ পাওয়া যায়নি';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────
// HERO BAND — monthly এর _HeroBand এর ভিজ্যুয়াল ভাষায় (dark green,
// decorative circles) কিন্তু challenge-ভিত্তিক ৩টা agregate stat দেখায়।
// ─────────────────────────────────────────────────────────────────────────

class _HeroBand extends StatelessWidget {
  final List<Challenge> challenges;
  const _HeroBand({required this.challenges});

  @override
  Widget build(BuildContext context) {
    final active = challenges.where((c) => !c.hasEnded && c.hasStarted).length;
    final joined = challenges.where((c) => c.isJoined && !c.isCompleted).length;
    final completed =
        challenges.where((c) => c.isJoined && c.isCompleted).length;

    return Container(
      color: context.colors.darkGreen,
      child: Stack(children: [
        Positioned(
            top: -40,
            right: -35,
            child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Color(0x0AFFFFFF)))),
        Positioned(
            bottom: -20,
            left: 14,
            child: Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Color(0x07FFFFFF)))),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('আপনার অগ্রগতি',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0x17FFFFFF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0x2EFFFFFF), width: 0.5),
              ),
              child: Row(children: [
                ChHeroStat(value: '$active', label: 'সক্রিয় চ্যালেঞ্জ'),
                _vDivider(),
                ChHeroStat(value: '$joined', label: 'যোগ দিয়েছেন'),
                _vDivider(),
                ChHeroStat(value: '$completed', label: 'সম্পন্ন করেছেন'),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }

  static Widget _vDivider() => Container(
      width: 0.5,
      height: 34,
      color: Colors.white.withOpacity(0.14),
      margin: const EdgeInsets.symmetric(horizontal: 4));
}

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
              width: 110,
              height: 11,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 12),
          Container(
            height: 70,
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

// ─────────────────────────────────────────────────────────────────────────
// FILTER ROW
// ─────────────────────────────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  final _ChFilter filter;
  final ValueChanged<_ChFilter> onChanged;
  const _FilterRow({required this.filter, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = <(_ChFilter, String, String)>[
      (_ChFilter.all, '🗂️', 'সব'),
      (_ChFilter.joined, '🏃', 'চলমান'),
      (_ChFilter.available, '➕', 'নতুন'),
      (_ChFilter.completed, '✅', 'সম্পন্ন'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
      child: SizedBox(
        height: 34,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemBuilder: (_, i) {
            final (f, emoji, label) = items[i];
            return ChFilterChip(
              label: label,
              emoji: emoji,
              selected: filter == f,
              onTap: () => onChanged(f),
            );
          },
        ),
      ),
    ).animate().fadeIn(delay: 60.ms, duration: 240.ms);
  }
}

// ─────────────────────────────────────────────────────────────────────────
// HOW CHALLENGES WORK — info bottom sheet
// ─────────────────────────────────────────────────────────────────────────

class _HowChallengesWorkSheet extends StatelessWidget {
  const _HowChallengesWorkSheet();

  @override
  Widget build(BuildContext context) {
    final tips = [
      ('🎯', 'যোগ দিন', 'যেকোনো সক্রিয় চ্যালেঞ্জে ট্যাপ করে "যোগ দিন" চাপুন।'),
      ('✍️', 'অগ্রগতি লিখুন', 'প্রতিদিন কতটুকু করলেন তা যোগ করে আপডেট রাখুন।'),
      ('🏅', 'লিডারবোর্ড দেখুন', 'অন্যদের সাথে নিজের অবস্থান তুলনা করুন।'),
      (
        '🎉',
        'লক্ষ্য পূরণ করুন',
        'নির্ধারিত সময়ের মধ্যে টার্গেট শেষ করলে চ্যালেঞ্জ সম্পন্ন হবে।'
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: context.colors.pageBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                      color: context.colors.border,
                      borderRadius: BorderRadius.circular(99)),
                ),
              ),
              Text('চ্যালেঞ্জ কীভাবে কাজ করে',
                  style: TextStyle(
                      color: context.colors.textPri,
                      fontWeight: FontWeight.w800,
                      fontSize: 17)),
              const SizedBox(height: 16),
              ...List.generate(tips.length, (i) {
                final (emoji, title, desc) = tips[i];
                return Padding(
                  padding:
                      EdgeInsets.only(bottom: i == tips.length - 1 ? 0 : 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                            color: context.colors.greenLight,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(emoji,
                                style: const TextStyle(fontSize: 16))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: TextStyle(
                                    color: context.colors.textPri,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                            const SizedBox(height: 2),
                            Text(desc,
                                style: TextStyle(
                                    color: context.colors.textSec2,
                                    fontSize: 11.5,
                                    height: 1.3)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.darkGreen,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text('বুঝেছি',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
