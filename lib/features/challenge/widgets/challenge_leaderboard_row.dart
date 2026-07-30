import 'package:amal_tracker/features/challenge/model/challenge_model.dart';
import 'package:amal_tracker/features/challenge/widgets/challenge_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';
import 'package:amal_tracker/features/challenge/widgets/challenge_surah_data.dart';

class LeaderboardRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final String? currentUserId;
  final bool isTop3RowStyle;
  final int index;
  const LeaderboardRow({
    super.key,
    required this.entry,
    this.currentUserId,
    this.isTop3RowStyle = false,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = currentUserId != null && entry.userId == currentUserId;
    final top3 = entry.rank <= 3;
    final rc = rankColor(context, entry.rank);
    final rowBg = isMe
        ? context.colors.greenLight
        : top3 && isTop3RowStyle
            ? [
                const Color(0xFFFFFBF0),
                const Color(0xFFF8FAFC),
                const Color(0xFFFFF7ED)
              ][entry.rank - 1]
            : context.colors.card;

    return Container(
      margin: isTop3RowStyle ? const EdgeInsets.only(bottom: 8) : EdgeInsets.zero,
      padding: isTop3RowStyle
          ? const EdgeInsets.symmetric(horizontal: 14, vertical: 12)
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: rowBg,
        borderRadius: isTop3RowStyle ? BorderRadius.circular(12) : BorderRadius.zero,
        border: isTop3RowStyle
            ? Border.all(color: context.colors.border, width: 0.5)
            : Border(bottom: BorderSide(color: context.colors.border, width: 0.5)),
        boxShadow: isTop3RowStyle
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.015),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(children: [
        SizedBox(
          width: 26,
          child: top3
              ? Text(rankEmoji(entry.rank),
                  style: const TextStyle(fontSize: 16))
              : Text('${entry.rank}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: context.colors.textHint,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5)),
        ),
        const SizedBox(width: 8),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
              color: context.colors.darkGreen,
              borderRadius: BorderRadius.circular(9)),
          child: Center(
              child: Text(
            entry.name.isNotEmpty ? entry.name[0].toUpperCase() : 'U',
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12.5),
          )),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                Flexible(
                  child: Text(entry.name.split(' ').first,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: context.colors.textPri,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5)),
                ),
                if (isMe) ...[
                  const SizedBox(width: 5),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                        color: context.colors.midGreen.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(99)),
                    child: Text('আপনি',
                        style: TextStyle(
                            color: context.colors.darkGreen,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
                if (entry.isCompleted) ...[
                  const SizedBox(width: 5),
                  const Text('✅', style: TextStyle(fontSize: 10)),
                ],
              ]),
              if (entry.currentSurahNumber != null) ...[
                const SizedBox(height: 2),
                Text(
                    'সূরা ${surahByNumber(entry.currentSurahNumber!).name} · আয়াত ${_bnNum(entry.currentAyahInSurah ?? 0)}',
                    style: TextStyle(
                        color: context.colors.textSec2, fontSize: 9.5)),
              ] else if (entry.district != null &&
                  entry.district!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(entry.district!,
                    style: TextStyle(
                        color: context.colors.textSec2, fontSize: 9.5)),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: rc.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10)),
          child: Column(children: [
            Text('${entry.progressPercent}%',
                style: TextStyle(
                    color: rc,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    height: 1)),
            Text('${entry.currentValue}',
                style: TextStyle(
                    color: rc.withOpacity(0.6),
                    fontSize: 8,
                    fontWeight: FontWeight.w600)),
          ]),
        ),
      ]),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 30));
  }
}

class LeaderboardRowSkeleton extends StatelessWidget {
  final bool isCardStyle;
  const LeaderboardRowSkeleton({super.key, this.isCardStyle = false});
  @override
  Widget build(BuildContext context) {
    return ChShimmer(
      child: Container(
        margin: isCardStyle ? const EdgeInsets.only(bottom: 8) : EdgeInsets.zero,
        padding: isCardStyle
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 12)
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: isCardStyle ? BorderRadius.circular(12) : BorderRadius.zero,
            border: isCardStyle
                ? Border.all(color: context.colors.border, width: 0.5)
                : Border(
                    bottom: BorderSide(color: context.colors.border, width: 0.5))),
        child: Row(children: [
          const SizedBox(width: 26),
          const SizedBox(width: 8),
          ChBone(
              width: 32,
              height: 32,
              radius: 9,
              color: context.colors.skelBaseDark),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                ChBone(width: 70, height: 11),
                SizedBox(height: 5),
                ChBone(width: 90, height: 8),
              ],
            ),
          ),
          ChBone(
              width: 42,
              height: 34,
              radius: 10,
              color: context.colors.skelBaseDark),
        ]),
      ),
    );
  }
}

String _bnNum(int n) {
  const d = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
  return n.toString().split('').map((c) => d[int.parse(c)]).join();
}
