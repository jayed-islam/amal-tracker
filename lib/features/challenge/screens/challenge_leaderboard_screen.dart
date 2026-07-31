import 'package:amal_tracker/core/theme/app_color_tokens.dart';
import 'package:amal_tracker/features/challenge/widgets/challenge_colors.dart';
import '../../../shared/widgets/delayed_progress_indicator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:amal_tracker/features/challenge/model/challenge_model.dart';
import 'package:amal_tracker/features/challenge/provider/challenge_provider.dart';
import 'package:amal_tracker/features/challenge/widgets/challenge_leaderboard_row.dart';
import 'package:amal_tracker/features/challenge/widgets/challenge_surah_data.dart';

class ChallengeLeaderboardScreen extends ConsumerStatefulWidget {
  final Challenge challenge;
  final String? currentUserId;
  const ChallengeLeaderboardScreen({
    super.key,
    required this.challenge,
    this.currentUserId,
  });

  @override
  ConsumerState<ChallengeLeaderboardScreen> createState() =>
      _ChallengeLeaderboardScreenState();
}

class _ChallengeLeaderboardScreenState
    extends ConsumerState<ChallengeLeaderboardScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(leaderboardProvider(widget.challenge.id).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LeaderboardState>(leaderboardProvider(widget.challenge.id), (prev, next) {
      if (next.error != null && !next.isLoading && next.entries.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('হালনাগাদ করা সম্ভব হয়নি। ইন্টারনেট সংযোগ পরীক্ষা করুন।',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          backgroundColor: context.colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
    });

    final state = ref.watch(leaderboardProvider(widget.challenge.id));
    final isBackgroundRefreshing = state.isLoading && state.entries.isNotEmpty;

    return Scaffold(
      backgroundColor: context.colors.pageBg,
      appBar: AppBar(
        backgroundColor: context.colors.card,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: BackButton(color: context.colors.darkGreen),
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('লিডারবোর্ড',
                style: TextStyle(
                    color: context.colors.textPri,
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),
            Text(widget.challenge.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(color: context.colors.textSec2, fontSize: 11.5)),
          ],
        ),
      ),
      body: Stack(
        children: [
          _buildBody(state),
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

  Widget _buildBody(LeaderboardState state) {
    if (state.isLoading && state.entries.isEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
        children: [
          const _PodiumSkeleton(),
          const SizedBox(height: 12),
          ...List.generate(5, (_) => const LeaderboardRowSkeleton(isCardStyle: true)),
        ],
      );
    }

    if (state.error != null && state.entries.isEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
        children: [
          const _PodiumSkeleton(),
          const SizedBox(height: 24),
          ChErrorState(
            onRetry: () => ref
                .read(leaderboardProvider(widget.challenge.id).notifier)
                .refresh(),
          ),
        ],
      );
    }

    if (state.entries.isEmpty) {
      return Center(
        child: ChEmptyState(emoji: '🏁', title: 'এখনো কেউ অংশ নেননি'),
      );
    }

    final entries = state.entries;
    final top3 = entries.take(3).toList();
    final rest = entries.length > 3 ? entries.sublist(3) : <LeaderboardEntry>[];

    LeaderboardEntry? myEntry;
    if (widget.currentUserId != null) {
      try {
        myEntry = entries.firstWhere((e) => e.userId == widget.currentUserId);
      } catch (_) {}
    }

    final hasMyCard = myEntry != null;
    final headerCount = (hasMyCard ? 1 : 0) + 1; // 1 for myCard (if exists), 1 for podium card

    return RefreshIndicator(
      color: context.colors.darkGreen,
      onRefresh: () =>
          ref.read(leaderboardProvider(widget.challenge.id).notifier).refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
        itemCount: headerCount + rest.length + (state.hasMore ? 1 : 0),
        itemBuilder: (_, i) {
          if (i == 0 && hasMyCard) {
            return _CurrentUserCard(entry: myEntry!);
          }
          if (i == (hasMyCard ? 1 : 0)) {
            return _ChallengePodiumCard(
              top3: top3,
              currentUserId: widget.currentUserId,
              challenge: widget.challenge,
            );
          }

          final restIndex = i - headerCount;
          if (restIndex >= rest.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Center(
                  child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4))),
            );
          }

          final entry = rest[restIndex];
          return LeaderboardRow(
            entry: entry,
            index: restIndex + 3,
            currentUserId: widget.currentUserId,
            isTop3RowStyle: true,
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CURRENT USER CARD
// ─────────────────────────────────────────────────────────────────────────────
class _CurrentUserCard extends StatelessWidget {
  final LeaderboardEntry entry;
  const _CurrentUserCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: context.colors.greenLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.darkGreen.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: context.colors.darkGreen.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank Badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: context.colors.darkGreen,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _bnNum(entry.rank),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // User Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'আপনার অবস্থান (${entry.name})',
                  style: TextStyle(
                    color: context.colors.darkGreen,
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 2),
                if (entry.currentSurahNumber != null)
                  Text(
                    'সূরা ${surahByNumber(entry.currentSurahNumber!).name} · আয়াত ${_bnNum(entry.currentAyahInSurah ?? 0)}',
                    style: TextStyle(
                      color: context.colors.textSec2,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  Text(
                    'মোট অগ্রগতি: ${_bnNum(entry.currentValue)}',
                    style: TextStyle(
                      color: context.colors.textSec2,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Progress Percentage Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: context.colors.darkGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_bnNum(entry.progressPercent)}%',
                  style: TextStyle(
                    color: context.colors.darkGreen,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _bnNum(entry.currentValue),
                  style: TextStyle(
                    color: context.colors.darkGreen.withOpacity(0.7),
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
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

// ─────────────────────────────────────────────────────────────────────────────
// PODIUM CARD
// ─────────────────────────────────────────────────────────────────────────────
class _ChallengePodiumCard extends StatelessWidget {
  final List<LeaderboardEntry> top3;
  final String? currentUserId;
  final Challenge challenge;

  const _ChallengePodiumCard({
    required this.top3,
    this.currentUserId,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    if (top3.isEmpty) return const SizedBox.shrink();
    final first = top3[0];
    final second = top3.length > 1 ? top3[1] : null;
    final third = top3.length > 2 ? top3[2] : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 14),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colors.border, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('✨', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 6),
              Text(
                'শীর্ষ তিন অবস্থান',
                style: TextStyle(
                  color: context.colors.textPri,
                  fontWeight: FontWeight.w800,
                  fontSize: 13.5,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 6),
              const Text('✨', style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 2nd Place Column
              if (second != null)
                Expanded(
                  child: _ChallengePodiumPillar(
                    entry: second,
                    rank: 2,
                    pillarHeight: 70,
                    color: const Color(0xFF94A3B8), // slate silver
                    currentUserId: currentUserId,
                    challenge: challenge,
                  ),
                )
              else
                const Spacer(),

              // 1st Place Column
              Expanded(
                child: _ChallengePodiumPillar(
                  entry: first,
                  rank: 1,
                  pillarHeight: 100,
                  color: const Color(0xFFF59E0B), // gold
                  isFirst: true,
                  currentUserId: currentUserId,
                  challenge: challenge,
                ),
              ),

              // 3rd Place Column
              if (third != null)
                Expanded(
                  child: _ChallengePodiumPillar(
                    entry: third,
                    rank: 3,
                    pillarHeight: 52,
                    color: const Color(0xFFB45309), // bronze/amber
                    currentUserId: currentUserId,
                    challenge: challenge,
                  ),
                )
              else
                const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChallengePodiumPillar extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;
  final double pillarHeight;
  final Color color;
  final bool isFirst;
  final String? currentUserId;
  final Challenge challenge;

  const _ChallengePodiumPillar({
    required this.entry,
    required this.rank,
    required this.pillarHeight,
    required this.color,
    this.isFirst = false,
    this.currentUserId,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = currentUserId != null && entry.userId == currentUserId;
    final displayName = entry.name.split(' ').first;
    
    final String progressValueLabel;
    if (challenge.isQuranChallenge) {
      if (entry.currentSurahNumber != null) {
        progressValueLabel = 'সূরা ${surahByNumber(entry.currentSurahNumber!).name}\nআয়াত ${_bnNum(entry.currentAyahInSurah ?? 0)}';
      } else {
        progressValueLabel = '${_bnNum(entry.currentValue)} ${challenge.unitBn}';
      }
    } else {
      progressValueLabel = '${_bnNum(entry.currentValue)} ${challenge.unitBn}';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isFirst ? 46 : 38,
          height: isFirst ? 46 : 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isMe ? context.colors.darkGreen : color, 
              width: isMe ? 3 : 2
            ),
            color: isMe ? context.colors.greenLight : context.colors.pageBg,
          ),
          child: Center(
            child: Text(
              entry.name.isNotEmpty ? entry.name[0].toUpperCase() : 'U',
              style: TextStyle(
                color: isMe ? context.colors.darkGreen : context.colors.textPri,
                fontWeight: FontWeight.w900,
                fontSize: isFirst ? 16 : 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                displayName,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isMe ? context.colors.darkGreen : context.colors.textPri,
                  fontWeight: isMe ? FontWeight.w900 : FontWeight.w700,
                  fontSize: isFirst ? 12 : 11,
                ),
              ),
            ),
            if (isMe) ...[
              const SizedBox(width: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: context.colors.darkGreen,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'আপনি',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 7.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (entry.district != null && entry.district!.isNotEmpty) ...[
          const SizedBox(height: 1),
          Text(
            entry.district!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.colors.textSec2,
              fontSize: 9.5,
            ),
          ),
        ],
        const SizedBox(height: 2),
        Text(
          progressValueLabel,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            color: isFirst ? context.colors.darkGreen : context.colors.textSec2,
            fontWeight: FontWeight.w800,
            fontSize: isFirst ? 10 : 9,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          '${_bnNum(entry.progressPercent)}% সম্পন্ন',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.colors.midGreen,
            fontWeight: FontWeight.w700,
            fontSize: isFirst ? 9.5 : 8.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: pillarHeight,
          width: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withOpacity(0.85),
                color.withOpacity(0.35),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              _bnNum(rank),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PODIUM SKELETON
// ─────────────────────────────────────────────────────────────────────────────
class _PodiumSkeleton extends StatelessWidget {
  const _PodiumSkeleton();

  @override
  Widget build(BuildContext context) {
    return ChShimmer(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 14),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.colors.border, width: 0.5),
        ),
        child: Column(
          children: [
            Center(child: ChBone(width: 80, height: 12, radius: 4)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 2nd
                Column(
                  children: [
                    ChBone(width: 38, height: 38, radius: 99, color: context.colors.skelBaseDark),
                    const SizedBox(height: 8),
                    ChBone(width: 45, height: 10, radius: 4),
                    const SizedBox(height: 4),
                    ChBone(width: 35, height: 8, radius: 4),
                    const SizedBox(height: 8),
                    Container(
                      height: 70,
                      width: 64,
                      decoration: BoxDecoration(
                        color: context.colors.skelBaseDark,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                    ),
                  ],
                ),
                // 1st
                Column(
                  children: [
                    ChBone(width: 46, height: 46, radius: 99, color: context.colors.skelBaseDark),
                    const SizedBox(height: 8),
                    ChBone(width: 55, height: 10, radius: 4),
                    const SizedBox(height: 4),
                    ChBone(width: 40, height: 8, radius: 4),
                    const SizedBox(height: 8),
                    Container(
                      height: 100,
                      width: 64,
                      decoration: BoxDecoration(
                        color: context.colors.skelBaseDark,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                    ),
                  ],
                ),
                // 3rd
                Column(
                  children: [
                    ChBone(width: 38, height: 38, radius: 99, color: context.colors.skelBaseDark),
                    const SizedBox(height: 8),
                    ChBone(width: 45, height: 10, radius: 4),
                    const SizedBox(height: 4),
                    ChBone(width: 35, height: 8, radius: 4),
                    const SizedBox(height: 8),
                    Container(
                      height: 52,
                      width: 64,
                      decoration: BoxDecoration(
                        color: context.colors.skelBaseDark,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _bnNum(int n) {
  const d = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
  return n.toString().split('').map((c) => d[int.parse(c)]).join();
}
