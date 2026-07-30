import 'package:amal_tracker/core/theme/app_color_tokens.dart';
import 'package:amal_tracker/features/challenge/model/challenge_model.dart';
import 'package:amal_tracker/features/challenge/widgets/challenge_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─────────────────────────────────────────────────────────────────────────
// CHALLENGE CARD — list/detail স্ক্রিনে ব্যবহৃত মূল কার্ড। স্ট্যাটাস অনুযায়ী
// (যোগ দেওয়া/না দেওয়া, চলমান/শেষ/শুরু হয়নি, সম্পন্ন) ভিন্ন ভিন্ন visual
// treatment — ঠিক যেমন monthly screen এর status badge/color কনভেনশন।
// ─────────────────────────────────────────────────────────────────────────

class ChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final int index;
  final VoidCallback onTap;
  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.onTap,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final c = challenge;
    final pct = c.myProgress?.progressPercent ?? 0;
    final accent =
        c.isQuranChallenge ? context.colors.gold : context.colors.midGreen;
    final accentBg = c.isQuranChallenge
        ? context.colors.amberLight
        : context.colors.greenLight;

    final isCompleted = c.isJoined && c.isCompleted;
    final isEnded = c.hasEnded && !isCompleted;
    final isUpcoming = !c.hasStarted;
    final isUrgent = c.isJoined && !isCompleted && !isEnded && c.daysLeft <= 2;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: isCompleted
                      ? context.colors.green.withOpacity(0.3)
                      : context.colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          color: isEnded ? context.colors.skelBase : accentBg,
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(
                          c.isQuranChallenge
                              ? Icons.menu_book_rounded
                              : Icons.flag_rounded,
                          color: isEnded ? context.colors.textHint : accent,
                          size: 22),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(
                              child: Text(c.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: context.colors.textPri,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14)),
                            ),
                            if (c.isQuranChallenge) ...[
                              const SizedBox(width: 5),
                              const Text('📖', style: TextStyle(fontSize: 11)),
                            ],
                          ]),
                          const SizedBox(height: 3),
                          Text(_metaLine(c),
                              style: TextStyle(
                                  color: isUrgent
                                      ? context.colors.red
                                      : context.colors.textSec2,
                                  fontWeight: isUrgent
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  fontSize: 11.5)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusTag(
                      isCompleted: isCompleted,
                      isEnded: isEnded,
                      isUpcoming: isUpcoming,
                      isJoined: c.isJoined,
                      accent: accent,
                    ),
                  ],
                ),
                if (c.isJoined && !isCompleted) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: (pct / 100).clamp(0, 1).toDouble(),
                      minHeight: 7,
                      backgroundColor: context.colors.skelBase,
                      valueColor: AlwaysStoppedAnimation(
                          isEnded ? context.colors.textHint : accent),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$pct% সম্পন্ন',
                          style: TextStyle(
                              color: isEnded ? context.colors.textHint : accent,
                              fontWeight: FontWeight.w700,
                              fontSize: 11)),
                      Text(
                          isEnded
                              ? 'সময় শেষ হয়েছে'
                              : '${c.daysLeft} দিন বাকি',
                          style: TextStyle(
                              color: isUrgent
                                  ? context.colors.red
                                  : context.colors.textHint,
                              fontWeight:
                                  isUrgent ? FontWeight.w700 : FontWeight.w400,
                              fontSize: 11)),
                    ],
                  ),
                ] else if (isCompleted) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        color: context.colors.greenLight,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(children: [
                      Icon(Icons.check_circle_rounded,
                          color: context.colors.green, size: 13),
                      const SizedBox(width: 5),
                      Text('আলহামদুলিল্লাহ! লক্ষ্য সম্পন্ন হয়েছে',
                          style: TextStyle(
                              color: context.colors.green,
                              fontWeight: FontWeight.w700,
                              fontSize: 10.5)),
                    ]),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: index * 40))
        .slideY(begin: 0.04, end: 0, delay: Duration(milliseconds: index * 40));
  }

  String _metaLine(Challenge c) {
    final target = '${c.targetValue} ${c.unitBn}';
    final people = '${c.participantCount} জন';
    if (!c.hasStarted) return '$target · শীঘ্রই শুরু হবে';
    if (!c.isJoined) return '$target · $people অংশ নিয়েছেন';
    return '${c.myProgress?.currentValue ?? 0}/${c.targetValue} ${c.unitBn} · $people অংশ নিয়েছেন';
  }
}

class _StatusTag extends StatelessWidget {
  final bool isCompleted, isEnded, isUpcoming, isJoined;
  final Color accent;
  const _StatusTag({
    required this.isCompleted,
    required this.isEnded,
    required this.isUpcoming,
    required this.isJoined,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return const Text('✅', style: TextStyle(fontSize: 18));
    }
    if (isUpcoming) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
            color: context.colors.purpleLight,
            borderRadius: BorderRadius.circular(99)),
        child: Text('শীঘ্রই',
            style: TextStyle(
                color: context.colors.purple,
                fontSize: 10.5,
                fontWeight: FontWeight.w700)),
      );
    }
    if (isEnded) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
            color: context.colors.skelBase,
            borderRadius: BorderRadius.circular(99)),
        child: Text('শেষ হয়েছে',
            style: TextStyle(
                color: context.colors.textHint,
                fontSize: 10.5,
                fontWeight: FontWeight.w700)),
      );
    }
    if (!isJoined) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: accent, borderRadius: BorderRadius.circular(99)),
        child: const Text('যোগ দিন',
            style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700)),
      );
    }
    return const SizedBox.shrink();
  }
}

class ChallengeCardSkeleton extends StatelessWidget {
  const ChallengeCardSkeleton({super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: ChShimmer(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.colors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  ChBone(
                      width: 44,
                      height: 44,
                      radius: 12,
                      color: context.colors.skelBaseDark),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ChBone(
                            width: 140,
                            height: 13,
                            color: context.colors.skelBaseDark),
                        const SizedBox(height: 7),
                        ChBone(
                            width: 90,
                            height: 10,
                            color: context.colors.skelBaseDark),
                      ],
                    ),
                  ),
                  ChBone(
                      width: 58,
                      height: 22,
                      radius: 99,
                      color: context.colors.skelBaseDark),
                ]),
                const SizedBox(height: 12),
                ChBone(
                    width: double.infinity,
                    height: 7,
                    radius: 99,
                    color: context.colors.skelBaseDark),
              ],
            ),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────
// HOME-SCREEN TEASER — একটা compact ইনস্ট্যান্স home screen এর জন্য। সবচেয়ে
// প্রাসঙ্গিক চ্যালেঞ্জ দেখায় (যোগ দেওয়া থাকলে সেটার progress, নাহলে নতুন
// joinable চ্যালেঞ্জ)। ট্যাপ করলে পুরো তালিকায় নিয়ে যায়।
// ─────────────────────────────────────────────────────────────────────────

class ChallengeHomeTeaser extends StatelessWidget {
  final Challenge challenge;
  final int? totalActiveCount;
  final VoidCallback onTap;
  const ChallengeHomeTeaser({
    super.key,
    required this.challenge,
    required this.onTap,
    this.totalActiveCount,
  });

  @override
  Widget build(BuildContext context) {
    final c = challenge;
    final pct = c.myProgress?.progressPercent ?? 0;

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.colors.darkGreen,
              const Color(0xFF0C4D35),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: context.colors.darkGreen.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x06FFFFFF),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x04FFFFFF),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.12),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        c.isQuranChallenge
                            ? Icons.menu_book_rounded
                            : Icons.emoji_events_rounded,
                        color: context.colors.gold,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: c.isJoined
                                      ? context.colors.gold.withOpacity(0.15)
                                      : Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: c.isJoined
                                        ? context.colors.gold.withOpacity(0.3)
                                        : Colors.white.withOpacity(0.2),
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  c.isJoined ? 'চলমান চ্যালেঞ্জ' : 'নতুন চ্যালেঞ্জ',
                                  style: TextStyle(
                                    color: c.isJoined ? context.colors.gold : Colors.white.withOpacity(0.9),
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              if ((totalActiveCount ?? 0) > 1) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '+${_bnNum(totalActiveCount! - 1)} আরও',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            c.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14.5,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (c.isJoined) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'অগ্রগতি: ${_bnNum(c.myProgress?.currentValue ?? 0)}/${_bnNum(c.targetValue)} ${c.unitBn}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.65),
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${_bnNum(pct)}% সম্পন্ন',
                                  style: TextStyle(
                                    color: context.colors.gold,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: LinearProgressIndicator(
                                value: (pct / 100).clamp(0.0, 1.0),
                                minHeight: 6,
                                backgroundColor: Colors.white.withOpacity(0.14),
                                valueColor: AlwaysStoppedAnimation(context.colors.gold),
                              ),
                            ),
                          ] else ...[
                            Text(
                              !c.hasStarted
                                  ? 'শীঘ্রই শুরু হবে · ${_bnNum(c.participantCount)} জন প্রস্তুত'
                                  : '${_bnNum(c.participantCount)} জন অংশগ্রহণকারী · ${_bnNum(c.daysLeft)} দিন বাকি',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: c.isJoined ? context.colors.gold : Colors.white.withOpacity(0.8),
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 260.ms);
  }
}

class ChallengeHomeTeaserSkeleton extends StatelessWidget {
  const ChallengeHomeTeaserSkeleton({super.key});
  @override
  Widget build(BuildContext context) => ChShimmer(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: context.colors.skelBase,
              borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            ChBone(
                width: 40,
                height: 40,
                radius: 11,
                color: context.colors.skelBaseDark),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChBone(
                      width: 110,
                      height: 12,
                      color: context.colors.skelBaseDark),
                  const SizedBox(height: 8),
                  ChBone(
                      width: 160,
                      height: 8,
                      color: context.colors.skelBaseDark),
                ],
              ),
            ),
          ]),
        ),
      );
}

String _bnNum(int n) {
  const d = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
  return n.toString().split('').map((c) => d[int.parse(c)]).join();
}
