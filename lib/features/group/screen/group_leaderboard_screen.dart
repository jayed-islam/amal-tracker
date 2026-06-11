// lib/features/group/screens/group_leaderboard_screen.dart

import 'package:amal_tracker/features/group/models/group_mode.dart';
import 'package:amal_tracker/features/group/provider/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _C {
  static const pageBg = Color(0xFFF4F6F1);
  static const cardBg = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const midGreen = Color(0xFF1B7045);
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFFFF8EE);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const amber = Color(0xFFFF6B35);
  static const amberLight = Color(0xFFFFF3E0);
  static const silver = Color(0xFF8B92A8);
  static const silverLight = Color(0xFFF0F1F5);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
  static const border = Color(0xFFE4EAE4);
}

// ─────────────────────────────────────────────────────────────────────────────
// GROUP LEADERBOARD SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class GroupLeaderboardScreen extends ConsumerWidget {
  final String groupId;
  const GroupLeaderboardScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final params = (groupId: groupId, year: now.year, month: now.month);
    final lbAsync = ref.watch(groupLeaderboardProvider(params));

    // Current user id — replace with your auth provider
    const myUserId = '';

    return Scaffold(
      backgroundColor: _C.pageBg,
      body: SafeArea(
        child: lbAsync.when(
          loading: () => const Center(
              child: CircularProgressIndicator(color: _C.darkGreen)),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (lb) => CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: _LeaderboardHeader(lb: lb),
              ),

              // Group streak + goal progress
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(
                    children: [
                      if (lb.groupStreak > 0)
                        _StreakBanner(streak: lb.groupStreak),
                      if (lb.goalProgress != null) ...[
                        const SizedBox(height: 10),
                        _GoalProgressCard(goal: lb.goalProgress!),
                      ],
                    ],
                  ),
                ),
              ),

              // Podium (top 3)
              if (lb.data.length >= 3)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: _Podium(
                      entries: lb.data.take(3).toList(),
                      myUserId: myUserId,
                    ),
                  ),
                ),

              // Section label
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    children: [
                      const Text(
                        'সকল সদস্য',
                        style: TextStyle(
                          color: _C.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'মোট ${lb.total} জন',
                        style:
                            const TextStyle(color: _C.textHint, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),

              // Full list
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final entry = lb.data[i];
                      final isMe = entry.userId == myUserId;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _LeaderboardRow(
                          entry: entry,
                          isMe: isMe,
                        ),
                      )
                          .animate(delay: (i * 35).ms)
                          .fadeIn()
                          .slideX(begin: 0.03);
                    },
                    childCount: lb.data.length,
                  ),
                ),
              ),

              // Empty state
              if (lb.data.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bar_chart_rounded,
                            color: _C.textHint, size: 48),
                        SizedBox(height: 12),
                        Text(
                          'এই মাসে এখনো কোনো data নেই',
                          style: TextStyle(color: _C.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _LeaderboardHeader extends StatelessWidget {
  final GroupLeaderboardResponse lb;
  const _LeaderboardHeader({required this.lb});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthName = _bengaliMonth(now.month);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0E3D22), Color(0xFF1B7045)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lb.group.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'লিডারবোর্ড • $monthName ${now.year}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _bengaliMonth(int m) {
    const months = [
      '',
      'জানুয়ারি',
      'ফেব্রুয়ারি',
      'মার্চ',
      'এপ্রিল',
      'মে',
      'জুন',
      'জুলাই',
      'আগস্ট',
      'সেপ্টেম্বর',
      'অক্টোবর',
      'নভেম্বর',
      'ডিসেম্বর'
    ];
    return months[m];
  }
}

// ─── Streak Banner ────────────────────────────────────────────────────────────

class _StreakBanner extends StatelessWidget {
  final int streak;
  const _StreakBanner({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _C.amberLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.amber.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'গ্রুপ streak: $streak দিন — সবাই মিলে $streak দিন ধরে আমল করছেন!',
              style:
                  const TextStyle(color: _C.amber, fontSize: 12, height: 1.3),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms);
  }
}

// ─── Goal Progress ────────────────────────────────────────────────────────────

class _GoalProgressCard extends StatelessWidget {
  final GoalProgress goal;
  const _GoalProgressCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    final hasPoints = goal.targetPoints != null;
    final hasCompletion = goal.targetCompletionPct != null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.flag_rounded, color: _C.midGreen, size: 15),
              SizedBox(width: 6),
              Text(
                'মাসিক গ্রুপ গোল',
                style: TextStyle(
                  color: _C.midGreen,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (hasPoints) ...[
            _GoalProgressBar(
              label: 'মোট পয়েন্ট',
              current: goal.currentPoints,
              target: goal.targetPoints!,
              achieved: goal.pointsAchieved ?? false,
              suffix: ' pts',
            ),
            if (hasCompletion) const SizedBox(height: 8),
          ],
          if (hasCompletion)
            _GoalProgressBar(
              label: 'গড় completion',
              current: goal.currentCompletionPct,
              target: goal.targetCompletionPct!,
              achieved: goal.completionAchieved ?? false,
              suffix: '%',
            ),
        ],
      ),
    );
  }
}

class _GoalProgressBar extends StatelessWidget {
  final String label;
  final int current;
  final int target;
  final bool achieved;
  final String suffix;

  const _GoalProgressBar({
    required this.label,
    required this.current,
    required this.target,
    required this.achieved,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (current / target).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(color: _C.textSecondary, fontSize: 11)),
            Row(
              children: [
                Text(
                  '$current$suffix',
                  style: TextStyle(
                    color: achieved ? _C.green : _C.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
                Text(' / $target$suffix',
                    style: const TextStyle(color: _C.textHint, fontSize: 10)),
                if (achieved) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.check_circle_rounded,
                      color: _C.green, size: 13),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: _C.border,
            valueColor:
                AlwaysStoppedAnimation(achieved ? _C.green : _C.midGreen),
            minHeight: 7,
          ),
        ),
      ],
    );
  }
}

// ─── Podium ───────────────────────────────────────────────────────────────────

class _Podium extends StatelessWidget {
  final List<GroupLeaderboardEntry> entries;
  final String myUserId;

  const _Podium({required this.entries, required this.myUserId});

  @override
  Widget build(BuildContext context) {
    if (entries.length < 3) return const SizedBox();

    final first = entries[0];
    final second = entries[1];
    final third = entries[2];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 2nd
        Expanded(
          child: _PodiumSlot(
            entry: second,
            rank: 2,
            height: 90,
            color: _C.silver,
            bgColor: _C.silverLight,
            isMe: second.userId == myUserId,
          ),
        ),
        const SizedBox(width: 8),
        // 1st
        Expanded(
          child: _PodiumSlot(
            entry: first,
            rank: 1,
            height: 110,
            color: _C.gold,
            bgColor: _C.goldLight,
            isMe: first.userId == myUserId,
          ),
        ),
        const SizedBox(width: 8),
        // 3rd
        Expanded(
          child: _PodiumSlot(
            entry: third,
            rank: 3,
            height: 72,
            color: _C.amber,
            bgColor: _C.amberLight,
            isMe: third.userId == myUserId,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.06);
  }
}

class _PodiumSlot extends StatelessWidget {
  final GroupLeaderboardEntry entry;
  final int rank;
  final double height;
  final Color color;
  final Color bgColor;
  final bool isMe;

  const _PodiumSlot({
    required this.entry,
    required this.rank,
    required this.height,
    required this.color,
    required this.bgColor,
    required this.isMe,
  });

  String get _medal {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      default:
        return '🥉';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: isMe ? _C.darkGreen : color.withOpacity(0.4),
              width: isMe ? 2.5 : 1.5,
            ),
          ),
          child: Center(
            child: Text(
              entry.displayName.isNotEmpty
                  ? entry.displayName[0].toUpperCase()
                  : '?',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),

        Text(
          entry.displayName,
          style: TextStyle(
            color: isMe ? _C.darkGreen : _C.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 10,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),

        Text(
          '${entry.completionPercentage}%',
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 4),

        // Podium base
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(color: color.withOpacity(0.3), width: 0.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_medal, style: const TextStyle(fontSize: 20)),
              Text(
                '#$rank',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Leaderboard Row ──────────────────────────────────────────────────────────

class _LeaderboardRow extends StatelessWidget {
  final GroupLeaderboardEntry entry;
  final bool isMe;

  const _LeaderboardRow({required this.entry, required this.isMe});

  Color get _rankColor {
    switch (entry.rank) {
      case 1:
        return _C.gold;
      case 2:
        return _C.silver;
      case 3:
        return _C.amber;
      default:
        return _C.textHint;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isMe ? _C.greenLight : _C.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isMe ? _C.green.withOpacity(0.35) : _C.border,
          width: isMe ? 1.5 : 0.5,
        ),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 28,
            child: Text(
              '#${entry.rank}',
              style: TextStyle(
                color: _rankColor,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(width: 10),

          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: isMe ? _C.greenLight : _C.pageBg,
            backgroundImage: entry.userAvatar != null
                ? NetworkImage(entry.userAvatar!)
                : null,
            child: entry.userAvatar == null
                ? Text(
                    entry.displayName.isNotEmpty
                        ? entry.displayName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: isMe ? _C.darkGreen : _C.textSecondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  )
                : null,
          ),

          const SizedBox(width: 10),

          // Name + stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.displayName,
                        style: TextStyle(
                          color: isMe ? _C.darkGreen : _C.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isMe)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: _C.darkGreen,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          'আপনি',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    _MiniStat(icon: '🔥', value: '${entry.streakDays}d'),
                    const SizedBox(width: 8),
                    _MiniStat(icon: '⭐', value: '${entry.totalPoints}pts'),
                  ],
                ),
              ],
            ),
          ),

          // Completion %
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.completionPercentage}%',
                style: TextStyle(
                  color: isMe ? _C.darkGreen : _C.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const Text(
                'completion',
                style: TextStyle(color: _C.textHint, fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String icon;
  final String value;
  const _MiniStat({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 10)),
        const SizedBox(width: 2),
        Text(
          value,
          style: const TextStyle(color: _C.textSecondary, fontSize: 10),
        ),
      ],
    );
  }
}
