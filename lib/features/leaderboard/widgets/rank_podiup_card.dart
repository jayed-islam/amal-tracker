import 'package:amal_tracker/features/leaderboard/widgets/public_profile_sheet.dart';
import 'package:amal_tracker/features/tracker/models/tracker_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────
// PODIUM CARD — public widget, used from leaderboard_screen
// ─────────────────────────────────────────────────────────────────────────────

class PodiumCard extends StatelessWidget {
  final List<LeaderboardEntry> top3;
  final int year;
  final int month;
  final bool isMaleUser;

  const PodiumCard({
    super.key,
    required this.top3,
    required this.year,
    required this.month,
    required this.isMaleUser,
  });

  @override
  Widget build(BuildContext context) {
    final first = top3[0];
    final second = top3[1];
    final third = top3.length > 2 ? top3[2] : null;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colors.border, width: 0.5),
      ),
      child: Column(children: [
        // ── Header ──────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🌟', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 6),
              Text(
                  top3.length == 2
                      ? 'এই মাসের শীর্ষ দুইজন'
                      : 'এই মাসের শীর্ষ তিনজন',
                  style: TextStyle(
                      color: context.colors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2)),
              const SizedBox(width: 6),
              const Text('🌟', style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ── Pillars ──────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Row(
            mainAxisAlignment: top3.length == 2
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: top3.length == 2
                ? [
                    _PodiumPillar(
                        entry: second,
                        rank: 2,
                        year: year,
                        month: month,
                        isMaleUser: isMaleUser),
                    const SizedBox(width: 12),
                    _PodiumPillar(
                        entry: first,
                        rank: 1,
                        isFirst: true,
                        year: year,
                        month: month,
                        isMaleUser: isMaleUser),
                  ]
                : [
                    _PodiumPillar(
                        entry: second,
                        rank: 2,
                        year: year,
                        month: month,
                        isMaleUser: isMaleUser),
                    _PodiumPillar(
                        entry: first,
                        rank: 1,
                        isFirst: true,
                        year: year,
                        month: month,
                        isMaleUser: isMaleUser),
                    if (third != null)
                      _PodiumPillar(
                          entry: third,
                          rank: 3,
                          year: year,
                          month: month,
                          isMaleUser: isMaleUser)
                    else
                      const SizedBox(width: 88),
                  ],
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PILLAR
// ─────────────────────────────────────────────────────────────────────────────

class _PodiumPillar extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;
  final bool isFirst;
  final int year, month;
  final bool isMaleUser;

  const _PodiumPillar({
    required this.entry,
    required this.rank,
    required this.year,
    required this.month,
    required this.isMaleUser,
    this.isFirst = false,
  });

  Color _rankColor(BuildContext context) => rank == 1
      ? context.colors.rankGold
      : rank == 2
          ? context.colors.rankSilver
          : context.colors.rankBronze;

  String get _rankEmoji => rank == 1
      ? '🥇'
      : rank == 2
          ? '🥈'
          : '🥉';

  double get _avatarSize => isFirst
      ? 68.0
      : rank == 2
          ? 56.0
          : 50.0;
  double get _pillarWidth => isFirst
      ? 112.0
      : rank == 2
          ? 96.0
          : 88.0;
  EdgeInsets get _pillarPadding =>
      EdgeInsets.symmetric(vertical: isFirst ? 16 : 12, horizontal: 6);

  // Male user female profile দেখতে পাবে না
  bool get _canView {
    if (!entry.isProfilePublic) return false;
    if (isMaleUser && entry.gender?.toLowerCase() == 'female') return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final canView = _canView;
    final initial = entry.name.isNotEmpty ? entry.name[0].toUpperCase() : 'U';

    return GestureDetector(
      onTap: canView
          ? () {
              HapticFeedback.selectionClick();
              showPublicProfileSheet(context,
                  entry: entry,
                  year: year,
                  month: month,
                  isMaleUser: isMaleUser);
            }
          : null,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: _pillarWidth,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Medal
          Text(_rankEmoji, style: TextStyle(fontSize: isFirst ? 24 : 20))
              .animate()
              .scale(
                  delay: Duration(milliseconds: rank * 80),
                  duration: 380.ms,
                  curve: Curves.elasticOut),
          const SizedBox(height: 8),

          // Avatar
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
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
                          blurRadius: isFirst ? 14 : 8,
                          spreadRadius: 0)
                    ]),
                child: Center(
                    child: Text(initial,
                        style: TextStyle(
                            color: _rankColor(context),
                            fontSize: isFirst
                                ? 28
                                : rank == 2
                                    ? 22
                                    : 19,
                            fontWeight: FontWeight.w900,
                            height: 1))),
              ),
              // Public / Private dot
              Positioned(
                top: isFirst ? 0 : 1,
                right: isFirst ? 0 : 1,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                      color: canView
                          ? context.colors.avatar4
                          : context.colors.textHint,
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: context.colors.cardBg, width: 2)),
                  child: Icon(
                      canView ? Icons.visibility_rounded : Icons.lock_rounded,
                      size: 9,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Name
          Text(entry.name.split(' ').first,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: isFirst ? 13.5 : 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2)),
          const SizedBox(height: 3),

          // ID chip
          if (entry.id.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                  color: context.colors.serialBg,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: context.colors.border, width: 0.5)),
              child: Text(entry.id,
                  style: TextStyle(
                      color: context.colors.serialText,
                      fontSize: 9,
                      fontWeight: FontWeight.w600)),
            ),
          const SizedBox(height: 3),

          // District
          if (entry.district.isNotEmpty)
            Text(entry.district,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: context.colors.districtText,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),

          // Pillar bar
          _PillarBar(
            entry: entry,
            rank: rank,
            isFirst: isFirst,
            rankColor: _rankColor(context),
            pillarWidth: _pillarWidth,
            pillarPadding: _pillarPadding,
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PILLAR BAR — points বাদ, completion % + farz + jamaat + streak
// ─────────────────────────────────────────────────────────────────────────────

class _PillarBar extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;
  final bool isFirst;
  final Color rankColor;
  final double pillarWidth;
  final EdgeInsets pillarPadding;

  const _PillarBar({
    required this.entry,
    required this.rank,
    required this.isFirst,
    required this.rankColor,
    required this.pillarWidth,
    required this.pillarPadding,
  });

  @override
  Widget build(BuildContext context) {
    final pct = entry.completionPercentage.toInt();
    final farz = entry.farzCompletedDays;
    final jamaat = entry.congregationDaysTotal;
    final streak = entry.streakDays;

    return Container(
      width: pillarWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              rankColor.withOpacity(0.10),
              rankColor.withOpacity(0.04),
            ]),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(
          top: BorderSide(color: rankColor, width: 2.5),
          left: BorderSide(color: rankColor.withOpacity(0.25), width: 0.75),
          right: BorderSide(color: rankColor.withOpacity(0.25), width: 0.75),
        ),
      ),
      child: Padding(
        padding: pillarPadding,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Accent line
          Container(
            width: 28,
            height: 2,
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                color: rankColor.withOpacity(0.40),
                borderRadius: BorderRadius.circular(2)),
          ),

          // Completion % — primary metric
          Text('$pct%',
              style: TextStyle(
                  color: rankColor,
                  fontWeight: FontWeight.w900,
                  fontSize: isFirst
                      ? 22
                      : rank == 2
                          ? 18
                          : 15,
                  height: 1,
                  letterSpacing: -0.5)),
          const SizedBox(height: 2),
          Text('ফরজ',
              style: TextStyle(
                  color: rankColor.withOpacity(0.65),
                  fontSize: isFirst ? 9.5 : 8.5,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),

          // Farz days pill
          _PillarPill(
              icon: Icons.check_rounded,
              label: '$farz দিন',
              color: rankColor,
              isFirst: isFirst),
          const SizedBox(height: 5),

          // Jamaat pill
          _PillarPill(
              icon: Icons.people_rounded,
              label: '$jamaat জামাত',
              color: rankColor,
              isFirst: isFirst),

          // Streak
          if (streak > 0) ...[
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                  color: const Color(0xFFFF6B00).withOpacity(0.10),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFFFF6B00).withOpacity(0.25),
                      width: 0.75)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('🔥', style: TextStyle(fontSize: 9)),
                const SizedBox(width: 3),
                Text('$streak দিন',
                    style: TextStyle(
                        color: const Color(0xFFFF6B00).withOpacity(0.9),
                        fontSize: isFirst ? 9.5 : 8.5,
                        fontWeight: FontWeight.w700)),
              ]),
            ),
          ],
        ]),
      ),
    );
  }
}

class _PillarPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isFirst;

  const _PillarPill({
    required this.icon,
    required this.label,
    required this.color,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isFirst ? 9 : 7, vertical: isFirst ? 4 : 3),
      decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.25), width: 0.75)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: isFirst ? 9.5 : 8.5, color: color.withOpacity(0.85)),
        const SizedBox(width: 3),
        Text(label,
            style: TextStyle(
                color: color,
                fontSize: isFirst ? 9.5 : 8.5,
                fontWeight: FontWeight.w700)),
      ]),
    );
  }
}
