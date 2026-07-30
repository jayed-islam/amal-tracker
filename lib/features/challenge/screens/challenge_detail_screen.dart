import 'package:amal_tracker/features/challenge/model/challenge_model.dart';
import 'package:amal_tracker/features/challenge/provider/challenge_provider.dart';
import 'package:amal_tracker/features/challenge/widgets/challenge_leaderboard_row.dart';
import 'package:amal_tracker/features/challenge/widgets/challenge_update_progress_sheet.dart';
import 'package:amal_tracker/features/challenge/widgets/challenge_colors.dart';
import 'package:amal_tracker/features/challenge/widgets/challenge_surah_data.dart';
import 'package:amal_tracker/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'challenge_leaderboard_screen.dart';
import '../../../shared/widgets/delayed_progress_indicator.dart';

import 'package:amal_tracker/core/theme/app_color_tokens.dart';

class ChallengeDetailScreen extends ConsumerWidget {
  final String challengeId;
  const ChallengeDetailScreen({super.key, required this.challengeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<Challenge>>(challengeDetailProvider(challengeId),
        (prev, next) {
      if (next.hasError && !next.isLoading && next.hasValue) {
        _showBackgroundRefreshErrorSnackBar(context);
      }
    });
    final challengeAsync = ref.watch(challengeDetailProvider(challengeId));
    final isJoined = challengeAsync.valueOrNull?.isJoined ?? false;

    if (isJoined) {
      ref.listen<AsyncValue<MyProgressDetail>>(myProgressProvider(challengeId),
          (prev, next) {
        if (next.hasError && !next.isLoading && next.hasValue) {
          _showBackgroundRefreshErrorSnackBar(context);
        }
      });
    }

    ref.listen<AsyncValue<List<LeaderboardEntry>>>(
        leaderboardPreviewForChallengeProvider(challengeId), (prev, next) {
      if (next.hasError && !next.isLoading && next.hasValue) {
        _showBackgroundRefreshErrorSnackBar(context);
      }
    });

    final myProgressAsync =
        isJoined ? ref.watch(myProgressProvider(challengeId)) : null;
    final previewAsync =
        ref.watch(leaderboardPreviewForChallengeProvider(challengeId));

    final hasInitialError = challengeAsync.hasError && !challengeAsync.hasValue;

    final showMainSkeleton =
        !hasInitialError && challengeAsync.valueOrNull == null;

    final isBackgroundRefreshing =
        (challengeAsync.isLoading && challengeAsync.hasValue) ||
            (myProgressAsync != null &&
                myProgressAsync.isLoading &&
                myProgressAsync.hasValue) ||
            (previewAsync.isLoading && previewAsync.hasValue);

    return Scaffold(
      backgroundColor: context.colors.pageBg,
      appBar: AppBar(
        backgroundColor: context.colors.card,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: BackButton(color: context.colors.darkGreen),
        title: challengeAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          loading: () => Text('চ্যালেঞ্জ বিস্তারিত',
              style: TextStyle(
                  color: context.colors.textPri,
                  fontWeight: FontWeight.w800,
                  fontSize: 16)),
          error: (_, __) => Text('চ্যালেঞ্জ',
              style: TextStyle(
                  color: context.colors.textPri,
                  fontWeight: FontWeight.w800,
                  fontSize: 16)),
          data: (c) => Text(c.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: context.colors.textPri,
                  fontWeight: FontWeight.w800,
                  fontSize: 16)),
        ),
        actions: [
          challengeAsync.whenOrNull(
                skipLoadingOnReload: true,
                skipLoadingOnRefresh: true,
                data: (c) => c.isJoined && !c.isCompleted
                    ? PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert_rounded,
                            color: context.colors.textPri),
                        onSelected: (v) {
                          if (v == 'leave') _confirmLeave(context, ref, c);
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(
                              value: 'leave',
                              child: Text('চ্যালেঞ্জ ছেড়ে দিন',
                                  style: TextStyle(color: context.colors.red))),
                        ],
                      )
                    : const SizedBox.shrink(),
              ) ??
              const SizedBox.shrink(),
          const SizedBox(width: 6),
        ],
      ),
      body: Stack(
        children: [
          if (showMainSkeleton)
            const _DetailSkeleton()
          else if (hasInitialError)
            Center(
              child: ChErrorState(
                onRetry: () {
                  ref.invalidate(challengeDetailProvider(challengeId));
                  if (isJoined) ref.invalidate(myProgressProvider(challengeId));
                  ref.invalidate(
                      leaderboardPreviewForChallengeProvider(challengeId));
                },
              ),
            )
          else
            RefreshIndicator(
              color: context.colors.darkGreen,
              onRefresh: () async {
                await Future.wait([
                  ref.refresh(challengeDetailProvider(challengeId).future),
                  if (isJoined)
                    ref.refresh(myProgressProvider(challengeId).future),
                  ref.refresh(
                      leaderboardPreviewForChallengeProvider(challengeId)
                          .future),
                ]);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 6, 14, 30),
                children: [
                  _HeroSection(challenge: challengeAsync.value!)
                      .animate()
                      .fadeIn(duration: 260.ms),
                  const SizedBox(height: 14),
                  if (challengeAsync.value!.isJoined) ...[
                    _MyStatsSection(challengeId: challengeId)
                        .animate()
                        .fadeIn(delay: 60.ms, duration: 260.ms),
                    const SizedBox(height: 14),
                  ],
                  _LeaderboardPreviewSection(
                          challengeId: challengeId,
                          challenge: challengeAsync.value!)
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 260.ms),
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
                  delay: const Duration(milliseconds: 200),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showBackgroundRefreshErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text(
          'হালনাগাদ করা সম্ভব হয়নি। ইন্টারনেট সংযোগ পরীক্ষা করুন।',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      backgroundColor: context.colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  void _confirmLeave(BuildContext context, WidgetRef ref, Challenge c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => _LeaveConfirmDialog(challenge: c, ref: ref),
    );
    if (context.mounted && ok == true) {
      Navigator.of(context).maybePop();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────
// HERO SECTION
// ─────────────────────────────────────────────────────────────────────────

class _HeroSection extends ConsumerWidget {
  final Challenge challenge;
  const _HeroSection({required this.challenge});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = challenge;
    final actionState = ref.watch(challengeActionProvider(c.id));
    final acting = actionState.isLoading;
    final pct = c.myProgress?.progressPercent ?? 0;

    return Container(
      decoration: BoxDecoration(
          color: context.colors.darkGreen,
          borderRadius: BorderRadius.circular(18)),
      child: Stack(children: [
        Positioned(
            top: -30,
            right: -30,
            child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Color(0x08FFFFFF)))),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(
                      c.isQuranChallenge
                          ? Icons.menu_book_rounded
                          : Icons.emoji_events_rounded,
                      color: context.colors.gold,
                      size: 21),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              letterSpacing: -0.3)),
                      const SizedBox(height: 2),
                      Row(children: [
                        Icon(Icons.people_alt_rounded,
                            size: 11, color: Colors.white.withOpacity(0.5)),
                        const SizedBox(width: 4),
                        Text('${c.participantCount} জন অংশগ্রহণকারী',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.55),
                                fontSize: 10.5)),
                      ]),
                    ],
                  ),
                ),
              ]),
              if (c.description != null && c.description!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(c.description!,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12.5,
                        height: 1.45)),
              ],
              const SizedBox(height: 14),
              Row(children: [
                _statChip('${c.targetValue}', 'লক্ষ্য (${c.unitBn})'),
                const SizedBox(width: 10),
                _statChip(c.hasEnded ? 'শেষ' : '${c.daysLeft}',
                    c.hasEnded ? '' : 'দিন বাকি'),
                if (c.isJoined) ...[
                  const SizedBox(width: 10),
                  _statChip('$pct%', 'সম্পন্ন'),
                ],
              ]),
              const SizedBox(height: 14),
              if (c.isJoined) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: (pct / 100).clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: Colors.white.withOpacity(0.12),
                    valueColor: AlwaysStoppedAnimation(c.isCompleted
                        ? context.colors.gold
                        : context.colors.green),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                    '${c.myProgress?.currentValue ?? 0}/${c.targetValue} ${c.unitBn}',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.55), fontSize: 10.5)),
                const SizedBox(height: 12),
                if (c.isCompleted)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        color: context.colors.gold.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                            color: context.colors.gold.withOpacity(0.4))),
                    child: Center(
                        child: Text('🎉 চ্যালেঞ্জ সম্পন্ন হয়েছে',
                            style: TextStyle(
                                color: context.colors.gold,
                                fontWeight: FontWeight.w800,
                                fontSize: 13))),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: acting || c.hasEnded
                          ? null
                          : () {
                              HapticFeedback.selectionClick();
                              showUpdateProgressSheet(context, c);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.gold,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11)),
                      ),
                      child: Text(c.hasEnded ? 'সময়সীমা শেষ' : 'আপডেট করুন',
                          style: TextStyle(
                              color: context.colors.darkGreen,
                              fontWeight: FontWeight.w800,
                              fontSize: 14)),
                    ),
                  ),
              ] else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (!c.isJoinable || acting)
                        ? null
                        : () async {
                            HapticFeedback.selectionClick();
                            final ok = await showDialog<bool>(
                              context: context,
                              builder: (_) =>
                                  _JoinConfirmDialog(challenge: c, ref: ref),
                            );
                            if (context.mounted && ok == true) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text(
                                    'মাশাআল্লাহ, আপনি সফলভাবে চ্যালেঞ্জে যোগ দিয়েছেন!',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13)),
                                backgroundColor: context.colors.darkGreen,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ));
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.gold,
                      disabledBackgroundColor: Colors.white.withOpacity(0.15),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11)),
                    ),
                    child: acting
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: context.colors.darkGreen))
                        : Text(
                            c.hasEnded
                                ? 'সময়সীমা শেষ হয়েছে'
                                : !c.hasStarted
                                    ? 'শীঘ্রই শুরু হবে'
                                    : 'চ্যালেঞ্জে যোগ দিন',
                            style: TextStyle(
                                color: context.colors.darkGreen,
                                fontWeight: FontWeight.w800,
                                fontSize: 14),
                          ),
                  ),
                ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _statChip(String value, String label) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10)),
          child: Column(children: [
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15)),
            if (label.isNotEmpty) ...[
              const SizedBox(height: 1),
              Text(label,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5), fontSize: 8.5)),
            ],
          ]),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────
// MY STATS SECTION — rank, daily needed, current pace
// ─────────────────────────────────────────────────────────────────────────

class _MyStatsSection extends ConsumerWidget {
  final String challengeId;
  const _MyStatsSection({required this.challengeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myProgress = ref.watch(myProgressProvider(challengeId));

    return myProgress.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      loading: () => const _StatsSkeleton(),
      error: (_, __) => const SizedBox.shrink(),
      data: (p) {
        if (p.isCompleted) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: context.colors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.colors.border, width: 0.5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Text('📊', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 6),
                Text('আপনার অগ্রগতি',
                    style: TextStyle(
                        color: context.colors.textPri,
                        fontWeight: FontWeight.w800,
                        fontSize: 13)),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: context.colors.greenLight,
                      borderRadius: BorderRadius.circular(99)),
                  child: Text('র‍্যাংক #${p.rank}',
                      style: TextStyle(
                          color: context.colors.darkGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.w700)),
                ),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                _miniStat('${p.dailyNeeded}', 'দৈনিক প্রয়োজন', context),
                _divider(context),
                _miniStat('${p.currentDailyAvg}', 'বর্তমান গড়/দিন', context),
                _divider(context),
                _miniStat('${p.remaining}', 'বাকি আছে', context),
              ]),
              if (p.currentSurahNumber != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                      color: context.colors.purpleLight,
                      borderRadius: BorderRadius.circular(9)),
                  child: Row(children: [
                    Icon(Icons.bookmark_rounded,
                        size: 14, color: context.colors.purple),
                    const SizedBox(width: 6),
                    Text(
                        'বর্তমান অবস্থান: সূরা ${surahByNumber(p.currentSurahNumber!).name}, আয়াত ${_bnNum(p.currentAyahInSurah ?? 0)}',
                        style: TextStyle(
                            color: context.colors.purple,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600)),
                  ]),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _divider(BuildContext context) => Container(
      width: 1,
      height: 32,
      color: context.colors.border,
      margin: const EdgeInsets.symmetric(horizontal: 6));

  Widget _miniStat(String value, String label, BuildContext context) =>
      Expanded(
        child: Column(children: [
          Text(value,
              style: TextStyle(
                  color: context.colors.textPri,
                  fontWeight: FontWeight.w800,
                  fontSize: 16)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.textHint, fontSize: 9)),
        ]),
      );
}

class _StatsSkeleton extends StatelessWidget {
  const _StatsSkeleton();
  @override
  Widget build(BuildContext context) {
    return ChShimmer(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.colors.border, width: 0.5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Text('📊', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 6),
              ChBone(width: 80, height: 13, color: context.colors.skelBaseDark),
              const Spacer(),
              ChBone(
                  width: 50,
                  height: 16,
                  radius: 99,
                  color: context.colors.skelBaseDark),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(
                child: Column(children: [
                  ChBone(
                      width: 30,
                      height: 16,
                      color: context.colors.skelBaseDark),
                  const SizedBox(height: 5),
                  ChBone(width: 60, height: 9, color: context.colors.skelBase),
                ]),
              ),
              Container(
                  width: 1,
                  height: 32,
                  color: context.colors.border,
                  margin: const EdgeInsets.symmetric(horizontal: 6)),
              Expanded(
                child: Column(children: [
                  ChBone(
                      width: 30,
                      height: 16,
                      color: context.colors.skelBaseDark),
                  const SizedBox(height: 5),
                  ChBone(width: 70, height: 9, color: context.colors.skelBase),
                ]),
              ),
              Container(
                  width: 1,
                  height: 32,
                  color: context.colors.border,
                  margin: const EdgeInsets.symmetric(horizontal: 6)),
              Expanded(
                child: Column(children: [
                  ChBone(
                      width: 30,
                      height: 16,
                      color: context.colors.skelBaseDark),
                  const SizedBox(height: 5),
                  ChBone(width: 50, height: 9, color: context.colors.skelBase),
                ]),
              ),
            ]),
            const SizedBox(height: 12),
            ChBone(
                width: double.infinity,
                height: 28,
                radius: 9,
                color: context.colors.skelBase),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// LEADERBOARD PREVIEW
// ─────────────────────────────────────────────────────────────────────────

class _LeaderboardPreviewSection extends ConsumerWidget {
  final String challengeId;
  final Challenge challenge;
  const _LeaderboardPreviewSection(
      {required this.challengeId, required this.challenge});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preview =
        ref.watch(leaderboardPreviewForChallengeProvider(challengeId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Text('🏆', style: TextStyle(fontSize: 13)),
          const SizedBox(width: 6),
          Text('শীর্ষ তালিকা',
              style: TextStyle(
                  color: context.colors.textPri,
                  fontWeight: FontWeight.w800,
                  fontSize: 13)),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ChallengeLeaderboardScreen(
                challenge: challenge,
                currentUserId: ref.read(currentUserProvider)?.id,
              ),
            )),
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
            ),
          ),
        ]),
        const SizedBox(height: 10),
        preview.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          loading: () => Container(
            decoration: BoxDecoration(
                color: context.colors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.colors.border, width: 0.5)),
            child: const Column(children: [
              LeaderboardRowSkeleton(),
              LeaderboardRowSkeleton(),
              LeaderboardRowSkeleton(),
            ]),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (entries) {
            if (entries.isEmpty) {
              return Container(
                decoration: BoxDecoration(
                    color: context.colors.card,
                    borderRadius: BorderRadius.circular(14),
                    border:
                        Border.all(color: context.colors.border, width: 0.5)),
                child: const ChEmptyState(
                    emoji: '🏁', title: 'এখনো কেউ অংশ নেননি'),
              );
            }
            return ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                decoration: BoxDecoration(
                    color: context.colors.card,
                    border:
                        Border.all(color: context.colors.border, width: 0.5)),
                child: Column(
                  children: entries
                      .asMap()
                      .entries
                      .map((e) => LeaderboardRow(
                            entry: e.value,
                            index: e.key,
                            currentUserId: ref.watch(currentUserProvider)?.id,
                          ))
                      .toList(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _HeroSectionSkeleton extends StatelessWidget {
  const _HeroSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    return ChShimmer(
      child: Container(
        decoration: BoxDecoration(
            color: context.colors.darkGreen.withOpacity(0.85),
            borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140,
                        height: 16,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 90,
                        height: 10,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(3)),
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                height: 12,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(3)),
              ),
              const SizedBox(height: 6),
              Container(
                width: 180,
                height: 12,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(3)),
              ),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 8,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(99)),
              ),
              const SizedBox(height: 6),
              Container(
                width: 60,
                height: 10,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(3)),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                height: 42,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(11)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 30),
      children: [
        const _HeroSectionSkeleton(),
        const SizedBox(height: 14),
        const _StatsSkeleton(),
        const SizedBox(height: 14),
        // Leaderboard Preview Section Skeleton
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('🏆', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 6),
                Text('শীর্ষ তালিকা',
                    style: TextStyle(
                        color: context.colors.textPri,
                        fontWeight: FontWeight.w800,
                        fontSize: 13)),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                  color: context.colors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.colors.border, width: 0.5)),
              child: const Column(
                children: [
                  LeaderboardRowSkeleton(),
                  LeaderboardRowSkeleton(),
                  LeaderboardRowSkeleton(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

String _bnNum(int n) {
  const d = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
  return n.toString().split('').map((c) => d[int.parse(c)]).join();
}

class _JoinConfirmDialog extends StatefulWidget {
  final Challenge challenge;
  final WidgetRef ref;

  const _JoinConfirmDialog({
    required this.challenge,
    required this.ref,
  });

  @override
  State<_JoinConfirmDialog> createState() => _JoinConfirmDialogState();
}

class _JoinConfirmDialogState extends State<_JoinConfirmDialog> {
  bool _loading = false;
  String? _error;

  Future<void> _handleConfirm() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    HapticFeedback.selectionClick();

    final ok = await widget.ref
        .read(challengeActionProvider(widget.challenge.id).notifier)
        .join();

    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      final actionState =
          widget.ref.read(challengeActionProvider(widget.challenge.id));
      setState(() {
        _error = actionState.error?.toString() ?? 'যোগদান ব্যর্থ হয়েছে।';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.challenge;
    return PopScope(
      canPop: !_loading,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 32,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: context.colors.greenLight,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(
                            c.isQuranChallenge
                                ? Icons.menu_book_rounded
                                : Icons.emoji_events_rounded,
                            color: context.colors.darkGreen,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'চ্যালেঞ্জে যোগ দিন',
                            style: TextStyle(
                              color: context.colors.textPri,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'আপনি কি "${c.title}" চ্যালেঞ্জ টিতে যোগ দিতে চান?',
                      style: TextStyle(
                        color: context.colors.textSec2,
                        fontSize: 13,
                        height: 1.65,
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: context.colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Divider(
                  height: 0.5, thickness: 0.5, color: context.colors.border),
              SizedBox(
                height: 52,
                child: _loading
                    ? Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: context.colors.darkGreen,
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: _DialogBtn(
                              label: 'বাতিল',
                              color: context.colors.textSec2,
                              isLeft: true,
                              onTap: () => Navigator.of(context).pop(false),
                            ),
                          ),
                          VerticalDivider(
                            width: 0.5,
                            thickness: 0.5,
                            color: context.colors.border,
                          ),
                          Expanded(
                            child: _DialogBtn(
                              label: 'যোগ দিন',
                              color: context.colors.darkGreen,
                              isRight: true,
                              bold: true,
                              onTap: _handleConfirm,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.92, 0.92),
          duration: 200.ms,
          curve: Curves.easeOutBack,
        )
        .fadeIn(duration: 160.ms);
  }
}

class _LeaveConfirmDialog extends StatefulWidget {
  final Challenge challenge;
  final WidgetRef ref;

  const _LeaveConfirmDialog({
    required this.challenge,
    required this.ref,
  });

  @override
  State<_LeaveConfirmDialog> createState() => _LeaveConfirmDialogState();
}

class _LeaveConfirmDialogState extends State<_LeaveConfirmDialog> {
  bool _loading = false;
  String? _error;

  Future<void> _handleConfirm() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    HapticFeedback.selectionClick();

    final ok = await widget.ref
        .read(challengeActionProvider(widget.challenge.id).notifier)
        .leave();

    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      final actionState =
          widget.ref.read(challengeActionProvider(widget.challenge.id));
      setState(() {
        _error = actionState.error?.toString() ?? 'ছেড়ে দেওয়া ব্যর্থ হয়েছে।';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.challenge;
    final currentValue = c.myProgress?.currentValue ?? 0;
    return PopScope(
      canPop: !_loading,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 32,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: context.colors.red.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(
                            Icons.warning_amber_rounded,
                            color: context.colors.red,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'চ্যালেঞ্জ ছাড়বেন?',
                            style: TextStyle(
                              color: context.colors.textPri,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'আপনার এখন পর্যন্ত ${currentValue} ${c.unitBn} অগ্রগতি মুছে যাবে। এটি ফিরিয়ে আনা যাবে না।',
                      style: TextStyle(
                        color: context.colors.textSec2,
                        fontSize: 13,
                        height: 1.65,
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: context.colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Divider(
                  height: 0.5, thickness: 0.5, color: context.colors.border),
              SizedBox(
                height: 52,
                child: _loading
                    ? Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: context.colors.red,
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: _DialogBtn(
                              label: 'বাতিল',
                              color: context.colors.textSec2,
                              isLeft: true,
                              onTap: () => Navigator.of(context).pop(false),
                            ),
                          ),
                          VerticalDivider(
                            width: 0.5,
                            thickness: 0.5,
                            color: context.colors.border,
                          ),
                          Expanded(
                            child: _DialogBtn(
                              label: 'ছেড়ে দিন',
                              color: context.colors.red,
                              isRight: true,
                              bold: true,
                              onTap: _handleConfirm,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.92, 0.92),
          duration: 200.ms,
          curve: Curves.easeOutBack,
        )
        .fadeIn(duration: 160.ms);
  }
}

class _DialogBtn extends StatelessWidget {
  final String label;
  final Color color;
  final bool bold;
  final bool isLeft;
  final bool isRight;
  final VoidCallback onTap;

  const _DialogBtn({
    required this.label,
    required this.color,
    this.bold = false,
    this.isLeft = false,
    this.isRight = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.only(
        bottomLeft: isLeft ? const Radius.circular(22) : Radius.zero,
        bottomRight: isRight ? const Radius.circular(22) : Radius.zero,
      ),
      child: Container(
        height: double.infinity,
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
