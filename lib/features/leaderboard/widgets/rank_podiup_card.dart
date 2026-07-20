// import 'package:amal_tracker/features/leaderboard/widgets/public_profile_sheet.dart';
// import 'package:amal_tracker/features/tracker/models/tracker_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';

// class _C {
//   static const pageBg = Color(0xFFF4F6F1);
//   static const cardBg = Color(0xFFFFFFFF);
//   static const darkGreen = Color(0xFF0E3D22);
//   static const midGreen = Color(0xFF1B7045);
//   static const gold = Color(0xFFD4A843);
//   static const goldLight = Color(0xFFFFF3E0);
//   static const goldBorder = Color(0xFFFFCC80);
//   static const goldPale = Color(0xFFFFFBF0);
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const amber = Color(0xFFFF6B35);
//   static const red = Color(0xFFEF4444);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
//   static const border = Color(0xFFE4EAE4);
//   static const borderMid = Color(0xFFC8D4C8);
//   static const rankGold = Color(0xFFD4A843);
//   static const rankSilver = Color(0xFF94A3B8);
//   static const rankBronze = Color(0xFFCD7F32);
//   static const avatar1 = Color(0xFF0E3D22);
//   static const avatar2 = Color(0xFF374151);
//   static const avatar3 = Color(0xFF7C3AED);
//   static const avatar4 = Color(0xFF0891B2);
//   static const avatar5 = Color(0xFF9D174D);
//   // New: district pill background
//   static const districtBg = Color(0xFFEDF2ED);
//   static const districtText = Color(0xFF2D5A3D);
//   static const serialBg = Color(0xFFF0F4F0);
//   static const serialText = Color(0xFF8FA98F);
// }

// class PodiumCard extends StatelessWidget {
//   final List<LeaderboardEntry> top3;
//   final int year;
//   final int month;

//   const PodiumCard({
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
//                 const Text('🌟', style: TextStyle(fontSize: 13)),
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
//                 const Text('🌟', style: TextStyle(fontSize: 13)),
//               ],
//             ),
//           ),

//           const SizedBox(height: 20),

//           // ── Podium pillars ───────────────────────────────────────────
//           // crossAxisAlignment.end aligns pillar bases at the bottom
//           Padding(
//             padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
//             child: Row(
//               mainAxisAlignment: top3.length == 2
//                   ? MainAxisAlignment.center
//                   : MainAxisAlignment.spaceEvenly,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: top3.length == 2
//                   ? [
//                       _PodiumPillar(
//                         entry: second,
//                         rank: 2,
//                         year: year,
//                         month: month,
//                       ),
//                       const SizedBox(width: 12),
//                       _PodiumPillar(
//                         entry: first,
//                         rank: 1,
//                         isFirst: true,
//                         year: year,
//                         month: month,
//                       ),
//                     ]
//                   : [
//                       _PodiumPillar(
//                         entry: second,
//                         rank: 2,
//                         year: year,
//                         month: month,
//                       ),
//                       _PodiumPillar(
//                         entry: first,
//                         rank: 1,
//                         isFirst: true,
//                         year: year,
//                         month: month,
//                       ),
//                       if (third != null)
//                         _PodiumPillar(
//                           entry: third,
//                           rank: 3,
//                           year: year,
//                           month: month,
//                         )
//                       else
//                         const SizedBox(width: 88),
//                     ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _PodiumPillar extends StatelessWidget {
//   final LeaderboardEntry entry;
//   final int rank;
//   final bool isFirst;
//   final int year;
//   final int month;

//   const _PodiumPillar({
//     required this.entry,
//     required this.rank,
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
//       ? 68.0
//       : rank == 2
//           ? 56.0
//           : 50.0;

//   double get _pillarWidth => isFirst
//       ? 112.0
//       : rank == 2
//           ? 96.0
//           : 88.0;

//   // Pillar vertical padding — rank 1 gets more breathing room
//   EdgeInsets get _pillarPadding => EdgeInsets.symmetric(
//         vertical: isFirst ? 16 : 12,
//         horizontal: 6,
//       );

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
//             // ── Medal emoji ────────────────────────────────────────────
//             Text(
//               _rankEmoji,
//               style: TextStyle(fontSize: isFirst ? 24 : 20),
//             ).animate().scale(
//                   delay: Duration(milliseconds: rank * 80),
//                   duration: 380.ms,
//                   curve: Curves.elasticOut,
//                 ),

//             const SizedBox(height: 8),

//             // ── Avatar with glow ring for rank 1 ─────────────────────
//             Stack(
//               clipBehavior: Clip.none,
//               alignment: Alignment.center,
//               children: [
//                 if (isFirst)
//                   Container(
//                     width: _avatarSize + 12,
//                     height: _avatarSize + 12,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: RadialGradient(
//                         colors: [
//                           _rankColor.withOpacity(0.20),
//                           _rankColor.withOpacity(0.0),
//                         ],
//                       ),
//                     ),
//                   ),
//                 Container(
//                   width: _avatarSize,
//                   height: _avatarSize,
//                   decoration: BoxDecoration(
//                     color: _rankColor.withOpacity(0.10),
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: _rankColor,
//                       width: isFirst ? 2.5 : 2.0,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: _rankColor.withOpacity(isFirst ? 0.30 : 0.15),
//                         blurRadius: isFirst ? 14 : 8,
//                         spreadRadius: 0,
//                       ),
//                     ],
//                   ),
//                   child: Center(
//                     child: Text(
//                       initial,
//                       style: TextStyle(
//                         color: _rankColor,
//                         fontSize: isFirst
//                             ? 28
//                             : rank == 2
//                                 ? 22
//                                 : 19,
//                         fontWeight: FontWeight.w900,
//                         height: 1,
//                       ),
//                     ),
//                   ),
//                 ),
//                 // ── Public / Private indicator dot ──────────────────
//                 Positioned(
//                   top: isFirst ? 0 : 1,
//                   right: isFirst ? 0 : 1,
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

//             // ── Name ──────────────────────────────────────────────────
//             Text(
//               firstName,
//               textAlign: TextAlign.center,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 color: _C.textPrimary,
//                 fontSize: isFirst ? 13.5 : 11.5,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: -0.2,
//               ),
//             ),

//             const SizedBox(height: 3),

//             // ── User ID chip ──────────────────────────────────────────
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

//             // ── District ─────────────────────────────────────────────
//             Text(
//               entry.district,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: _C.districtText,
//                 fontSize: 9.5,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),

//             const SizedBox(height: 10),

//             // ══════════════════════════════════════════════════════════
//             // ── PILLAR BAR — fully intrinsic, never clips content ────
//             // ══════════════════════════════════════════════════════════
//             _PillarBar(
//               entry: entry,
//               rank: rank,
//               isFirst: isFirst,
//               rankColor: _rankColor,
//               pillarWidth: _pillarWidth,
//               pillarPadding: _pillarPadding,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Extracted pillar bar widget — keeps _PodiumPillar readable
// // ─────────────────────────────────────────────────────────────────────────────
// class _PillarBar extends StatelessWidget {
//   final LeaderboardEntry entry;
//   final int rank;
//   final bool isFirst;
//   final Color rankColor;
//   final double pillarWidth;
//   final EdgeInsets pillarPadding;

//   const _PillarBar({
//     required this.entry,
//     required this.rank,
//     required this.isFirst,
//     required this.rankColor,
//     required this.pillarWidth,
//     required this.pillarPadding,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: pillarWidth,
//       // ── No fixed height — expands with content ───────────────────
//       decoration: BoxDecoration(
//         // Subtle gradient fill
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             rankColor.withOpacity(0.10),
//             rankColor.withOpacity(0.04),
//           ],
//         ),
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//         border: Border(
//           top: BorderSide(color: rankColor, width: 2.5),
//           left: BorderSide(color: rankColor.withOpacity(0.25), width: 0.75),
//           right: BorderSide(color: rankColor.withOpacity(0.25), width: 0.75),
//         ),
//       ),
//       child: Padding(
//         padding: pillarPadding,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // ── Points block ─────────────────────────────────────
//             _PointsBlock(
//               points: entry.totalPoints,
//               isFirst: isFirst,
//               rank: rank,
//               rankColor: rankColor,
//             ),

//             const SizedBox(height: 8),

//             // ── Completion % pill ────────────────────────────────
//             _CompletionPill(
//               percentage: entry.completionPercentage,
//               rankColor: rankColor,
//               isFirst: isFirst,
//             ),

//             // ── Streak row ───────────────────────────────────────
//             if (entry.streakDays > 0) ...[
//               const SizedBox(height: 6),
//               _StreakRow(
//                 days: entry.streakDays,
//                 rankColor: rankColor,
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Points block ──────────────────────────────────────────────────────────────
// class _PointsBlock extends StatelessWidget {
//   final int points;
//   final bool isFirst;
//   final int rank;
//   final Color rankColor;

//   const _PointsBlock({
//     required this.points,
//     required this.isFirst,
//     required this.rank,
//     required this.rankColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Divider accent line
//         Container(
//           width: 28,
//           height: 2,
//           margin: const EdgeInsets.only(bottom: 6),
//           decoration: BoxDecoration(
//             color: rankColor.withOpacity(0.40),
//             borderRadius: BorderRadius.circular(2),
//           ),
//         ),
//         Text(
//           '${points}',
//           style: TextStyle(
//             color: rankColor,
//             fontWeight: FontWeight.w900,
//             fontSize: isFirst
//                 ? 22
//                 : rank == 2
//                     ? 18
//                     : 15,
//             height: 1,
//             letterSpacing: -0.5,
//           ),
//         ),
//         const SizedBox(height: 2),
//         Text(
//           'পয়েন্ট',
//           style: TextStyle(
//             color: rankColor.withOpacity(0.65),
//             fontSize: isFirst ? 9.5 : 8.5,
//             fontWeight: FontWeight.w600,
//             letterSpacing: 0.3,
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ── Completion % pill ─────────────────────────────────────────────────────────
// class _CompletionPill extends StatelessWidget {
//   final double percentage;
//   final Color rankColor;
//   final bool isFirst;

//   const _CompletionPill({
//     required this.percentage,
//     required this.rankColor,
//     required this.isFirst,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: isFirst ? 10 : 8,
//         vertical: isFirst ? 4 : 3,
//       ),
//       decoration: BoxDecoration(
//         color: rankColor.withOpacity(0.13),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: rankColor.withOpacity(0.25),
//           width: 0.75,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             Icons.check_circle_rounded,
//             size: isFirst ? 9.5 : 8.5,
//             color: rankColor.withOpacity(0.85),
//           ),
//           const SizedBox(width: 3),
//           Text(
//             '${percentage.toInt()}% ফরজ',
//             style: TextStyle(
//               color: rankColor,
//               fontSize: isFirst ? 9.5 : 8.5,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ── Streak row ────────────────────────────────────────────────────────────────
// class _StreakRow extends StatelessWidget {
//   final int days;
//   final Color rankColor;

//   const _StreakRow({required this.days, required this.rankColor});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFF6B00).withOpacity(0.10),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: const Color(0xFFFF6B00).withOpacity(0.25),
//           width: 0.75,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Text('🔥', style: TextStyle(fontSize: 9)),
//           const SizedBox(width: 3),
//           Text(
//             '$days দিন',
//             style: TextStyle(
//               color: const Color(0xFFFF6B00).withOpacity(0.90),
//               fontSize: 9,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:amal_tracker/features/leaderboard/widgets/public_profile_sheet.dart';
import 'package:amal_tracker/features/tracker/models/tracker_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────

class _C {
  static const pageBg = Color(0xFFF4F6F1);
  static const cardBg = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const midGreen = Color(0xFF1B7045);
  static const gold = Color(0xFFD4A843);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const amber = Color(0xFFFF6B35);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
  static const border = Color(0xFFE4EAE4);
  static const rankGold = Color(0xFFD4A843);
  static const rankSilver = Color(0xFF94A3B8);
  static const rankBronze = Color(0xFFCD7F32);
  static const serialBg = Color(0xFFF0F4F0);
  static const serialText = Color(0xFF8FA98F);
  static const districtText = Color(0xFF2D5A3D);
}

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
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _C.border, width: 0.5),
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
                  style: const TextStyle(
                      color: _C.textSecondary,
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

  Color get _rankColor => rank == 1
      ? _C.rankGold
      : rank == 2
          ? _C.rankSilver
          : _C.rankBronze;

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
                        _rankColor.withOpacity(0.20),
                        _rankColor.withOpacity(0.0),
                      ])),
                ),
              Container(
                width: _avatarSize,
                height: _avatarSize,
                decoration: BoxDecoration(
                    color: _rankColor.withOpacity(0.10),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: _rankColor, width: isFirst ? 2.5 : 2.0),
                    boxShadow: [
                      BoxShadow(
                          color: _rankColor.withOpacity(isFirst ? 0.30 : 0.15),
                          blurRadius: isFirst ? 14 : 8,
                          spreadRadius: 0)
                    ]),
                child: Center(
                    child: Text(initial,
                        style: TextStyle(
                            color: _rankColor,
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
                      color: canView ? const Color(0xFF0891B2) : _C.textHint,
                      shape: BoxShape.circle,
                      border: Border.all(color: _C.cardBg, width: 2)),
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
                  color: _C.textPrimary,
                  fontSize: isFirst ? 13.5 : 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2)),
          const SizedBox(height: 3),

          // ID chip
          if (entry.id.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                  color: _C.serialBg,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: _C.border, width: 0.5)),
              child: Text(entry.id,
                  style: const TextStyle(
                      color: _C.serialText,
                      fontSize: 9,
                      fontWeight: FontWeight.w600)),
            ),
          const SizedBox(height: 3),

          // District
          if (entry.district.isNotEmpty)
            Text(entry.district,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: _C.districtText,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),

          // Pillar bar
          _PillarBar(
            entry: entry,
            rank: rank,
            isFirst: isFirst,
            rankColor: _rankColor,
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
