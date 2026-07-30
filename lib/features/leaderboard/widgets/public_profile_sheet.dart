import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/leaderboard_provider.dart';
import '../../tracker/models/tracker_model.dart';
import '../../../core/constants/app_constants.dart';
import 'package:amal_tracker/core/theme/app_colors.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────
// ENTRY POINT
// isMaleUser: male user female profile দেখতে পাবে না — caller এ check হয়
// তবুও double-check করা হচ্ছে এখানেও
// ─────────────────────────────────────────────────────────────────────────────

void showPublicProfileSheet(
  BuildContext context, {
  required LeaderboardEntry entry,
  required int year,
  required int month,
  required bool isMaleUser,
}) {
  // Male user → female profile দেখানো যাবে না
  if (isMaleUser && entry.gender?.toLowerCase() == 'female') {
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(children: [
          Icon(Icons.lock_rounded, color: Colors.white, size: 16),
          SizedBox(width: 8),
          Text('এই প্রোফাইল দেখার অনুমতি নেই',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ]),
        backgroundColor: context.colors.avatar1,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 2),
      ),
    );
    return;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: false,
    builder: (_) => PublicProfileSheet(
      entry: entry,
      year: year,
      month: month,
      isMaleUser: isMaleUser,
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// PUBLIC PROFILE SHEET
// ─────────────────────────────────────────────────────────────────────────────

class PublicProfileSheet extends ConsumerWidget {
  final LeaderboardEntry entry;
  final int year, month;
  final bool isMaleUser;

  const PublicProfileSheet({
    super.key,
    required this.entry,
    required this.year,
    required this.month,
    required this.isMaleUser,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenH = MediaQuery.of(context).size.height;

    final detail = ref.watch(publicProfileProvider((
      userId: entry.userId,
      year: year,
      month: month,
    )));

    return Container(
      constraints: BoxConstraints(maxHeight: screenH * 0.82),
      decoration: BoxDecoration(
        color: context.colors.bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const _DragHandle(),
        _StickyHeader(entry: entry, year: year, month: month),
        Flexible(
          child: detail.when(
            loading: () => const _SheetSkeleton(),
            error: (e, _) => _SheetError(
              onRetry: () => ref.invalidate(publicProfileProvider((
                userId: entry.userId,
                year: year,
                month: month,
              ))),
            ),
            data: (d) => _SheetBody(
              detail: d,
              entry: entry,
              year: year,
              month: month,
            ),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DRAG HANDLE
// ─────────────────────────────────────────────────────────────────────────────

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
              color: context.colors.border,
              borderRadius: BorderRadius.circular(99)),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STICKY HEADER — points বাদ, completion % + farz + jamaat + streak
// ─────────────────────────────────────────────────────────────────────────────

class _StickyHeader extends StatelessWidget {
  final LeaderboardEntry entry;
  final int year, month;

  const _StickyHeader(
      {required this.entry, required this.year, required this.month});

  @override
  Widget build(BuildContext context) {
    final initial = entry.name.isNotEmpty ? entry.name[0].toUpperCase() : 'U';
    final monthLabel = AppConstants.bengaliMonths[month - 1];
    final rankColor = entry.rank == 1
        ? context.colors.rankGold
        : entry.rank == 2
            ? context.colors.rankSilver
            : entry.rank == 3
                ? context.colors.rankBronze
                : context.colors.gold;

    final pct = entry.completionPercentage.toInt();
    final farz = entry.farzCompletedDays;
    final jamaat = entry.congregationDaysTotal;
    final streak = entry.streakDays;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [context.colors.darkGreen, context.colors.midGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.all(Radius.circular(24))),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: Colors.white.withOpacity(0.3), width: 1.5)),
            child: Center(
                child: Text(initial,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900))),
          ),
          const SizedBox(width: 14),

          // Name + chips
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(children: [
                  Flexible(
                      child: Text(entry.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3),
                          overflow: TextOverflow.ellipsis)),
                  if (entry.gender?.toLowerCase() == 'female') ...[
                    const SizedBox(width: 5),
                    const Text('🌸', style: TextStyle(fontSize: 12)),
                  ],
                  if (entry.isWinner) ...[
                    const SizedBox(width: 5),
                    const Text('🏆', style: TextStyle(fontSize: 12)),
                  ],
                ]),
                const SizedBox(height: 6),
                Wrap(spacing: 5, runSpacing: 4, children: [
                  _HeaderChip(icon: Icons.tag_rounded, label: entry.id),
                  _HeaderChip(
                      icon: Icons.location_on_rounded, label: entry.district),
                ]),
              ])),

          const SizedBox(width: 10),

          // Rank pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
                color: rankColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: rankColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ]),
            child: Column(children: [
              Text('#${entry.rank}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      height: 1)),
              Text('র‍্যাংক',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 8,
                      fontWeight: FontWeight.w600)),
            ]),
          ),
        ]),

        const SizedBox(height: 14),

        // Metrics row — points বাদ
        Row(children: [
          // Month
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.15))),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.calendar_month_rounded,
                  size: 12, color: Colors.white.withOpacity(0.6)),
              const SizedBox(width: 5),
              Text('$monthLabel $year',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ]),
          )),
          const SizedBox(width: 6),
          // Completion %
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
                color: rankColor, borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              const Icon(Icons.check_circle_rounded,
                  size: 12, color: Colors.white),
              const SizedBox(width: 5),
              Text('$pct% ফরজ',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 12)),
            ]),
          ),
          const SizedBox(width: 6),
          // Farz days
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.2))),
            child: Text('$farz দিন',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11)),
          ),
        ]),

        const SizedBox(height: 8),

        // Jamaat + streak row
        Row(children: [
          _MetricChip(
              icon: Icons.people_rounded,
              label: '$jamaat জামাত',
              color: Colors.white),
          const SizedBox(width: 6),
          if (streak > 0)
            _MetricChip(
                icon: Icons.local_fire_department_rounded,
                label: '$streak দিন ধারা',
                color: Colors.white),
        ]),
      ]),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HeaderChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: Colors.white.withOpacity(0.18), width: 0.5)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 9, color: Colors.white.withOpacity(0.6)),
        const SizedBox(width: 3),
        Text(label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 10,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MetricChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: Colors.white.withOpacity(0.18), width: 0.5)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: color.withOpacity(0.75)),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                color: color, fontSize: 10.5, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHEET BODY
// ─────────────────────────────────────────────────────────────────────────────

class _SheetBody extends StatelessWidget {
  final PublicMonthlyDetail detail;
  final LeaderboardEntry entry;
  final int year, month;

  const _SheetBody({
    required this.detail,
    required this.entry,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final tracker = detail.tracker;
    final isFemale = detail.gender?.toLowerCase() == 'female';
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPad + 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Stats ────────────────────────────────────────────────────
        if (tracker != null) ...[
          _StatsGrid(tracker: tracker, isFemale: isFemale)
              .animate()
              .fadeIn(delay: 60.ms)
              .slideY(begin: 0.04),
          const SizedBox(height: 16),
        ],

        // ── Fard performance bar ──────────────────────────────────────
        if (tracker != null) ...[
          _FardPerformanceCard(tracker: tracker).animate().fadeIn(delay: 80.ms),
          const SizedBox(height: 16),
        ],

        // ── Daily calendar ────────────────────────────────────────────
        _SectionLabel(label: 'দৈনিক আমল — $month/$year'),
        const SizedBox(height: 8),
        _DailyCalendar(
          entries: detail.entries,
          year: year,
          month: month,
          isFemale: isFemale,
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.04),

        const SizedBox(height: 16),

        // ── Day list ──────────────────────────────────────────────────
        if (detail.entries.isNotEmpty) ...[
          _SectionLabel(label: 'প্রতিদিনের বিবরণ'),
          const SizedBox(height: 8),
          _DayList(entries: detail.entries, isFemale: isFemale)
              .animate()
              .fadeIn(delay: 120.ms),
          const SizedBox(height: 16),
        ],

        // ── Inspiration ───────────────────────────────────────────────
        _InspirationCard(name: detail.name).animate().fadeIn(delay: 140.ms),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATS GRID — points বাদ, completion + farz + jamaat + streak + daysActive
// ─────────────────────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  final MonthlyTracker tracker;
  final bool isFemale;

  const _StatsGrid({required this.tracker, required this.isFemale});

  @override
  Widget build(BuildContext context) {
    final pct = tracker.completionPercentage.toInt();
    final farz = tracker.farzCompletedDays;
    // final jamaat = tracker.congregationDaysTotal;
    final streak = tracker.streakDays;
    final active = tracker.daysActive;
    final exempt = tracker.exemptDays;

    return Column(children: [
      Row(children: [
        Expanded(
            child: _StatCard(
                emoji: '✅',
                value: '$pct%',
                label: 'ফরজ সম্পন্ন',
                color: context.colors.darkGreen,
                bgColor: context.colors.greenLight)),
        const SizedBox(width: 8),
        Expanded(
            child: _StatCard(
                emoji: '🕌',
                value: '$farz দিন',
                label: 'পূর্ণ ফরজ দিন',
                color: context.colors.green,
                bgColor: context.colors.greenLight)),
      ]),
      const SizedBox(height: 8),
      // Row(children: [
      //   Expanded(
      //       child: _StatCard(
      //           emoji: '🤝',
      //           value: '$jamaat',
      //           label: 'জামাত',
      //           color: context.colors.purple,
      //           bgColor: context.colors.purpleLight)),
      //   const SizedBox(width: 8),
      //   Expanded(
      //       child: _StatCard(
      //           emoji: '🔥',
      //           value: '$streak দিন',
      //           label: 'ধারাবাহিক',
      //           color: context.colors.amber,
      //           bgColor: context.colors.amberLight)),
      // ]),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(
            child: _StatCard(
                emoji: '📅',
                value: '$active দিন',
                label: 'আমল করা দিন',
                color: context.colors.blue,
                bgColor: context.colors.blueLight)),
        const SizedBox(width: 8),
        if (isFemale && exempt > 0)
          Expanded(
              child: _StatCard(
                  emoji: '🌸',
                  value: '$exempt দিন',
                  label: 'মাহলির দিন',
                  color: context.colors.pink,
                  bgColor: context.colors.pinkLight))
        else
          Expanded(
              child: _StatCard(
                  emoji: '⏳',
                  value: '${tracker.eligibleDays} দিন',
                  label: 'হিসাবভুক্ত দিন',
                  color: context.colors.textSecondary,
                  bgColor: context.colors.bg)),
      ]),
    ]);
  }
}

class _StatCard extends StatelessWidget {
  final String emoji, value, label;
  final Color color, bgColor;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.15))),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  height: 1)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  color: context.colors.textSecondary, fontSize: 10.5)),
        ]),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FARD PERFORMANCE CARD
// ─────────────────────────────────────────────────────────────────────────────

class _FardPerformanceCard extends StatelessWidget {
  final MonthlyTracker tracker;
  const _FardPerformanceCard({required this.tracker});

  @override
  Widget build(BuildContext context) {
    final pct = tracker.completionPercentage.clamp(0.0, 100.0);
    final farz = tracker.farzCompletedDays;
    final eligible = tracker.eligibleDays;
    // final jamaat = tracker.congregationDaysTotal;

    Color barColor() {
      if (pct >= 90) return context.colors.green;
      if (pct >= 70) return context.colors.amber;
      return context.colors.red2;
    }

    String statusLabel() {
      if (pct >= 90) return 'চমৎকার';
      if (pct >= 70) return 'ভালো';
      if (pct >= 50) return 'মাঝামাঝি';
      return 'উন্নতি দরকার';
    }

    // jamaat fraction: out of eligible * 5 prayers
    final jamaatFrac =
        eligible > 0 ? (0 / (eligible * 5)).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border, width: 0.5)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('🕌', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 7),
          Text('ফরজ পারফরম্যান্স',
              style: TextStyle(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
                color: barColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(20)),
            child: Text(statusLabel(),
                style: TextStyle(
                    color: barColor(),
                    fontSize: 10,
                    fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 12),

        // Completion % bar
        Row(children: [
          Text('${pct.toInt()}% ফরজ পূর্ণ',
              style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const Spacer(),
          Text('$farz/$eligible দিন',
              style: TextStyle(color: context.colors.textHint, fontSize: 11)),
        ]),
        const SizedBox(height: 6),
        ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
                value: pct / 100,
                minHeight: 8,
                backgroundColor: context.colors.bg,
                valueColor: AlwaysStoppedAnimation(barColor()))),

        const SizedBox(height: 12),

        // Jamaat bar
        Row(children: [
          Text('জামাতে নামাজ',
              style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const Spacer(),
          // Text('$jamaat বার',
          //     style: const TextStyle(color: context.colors.textHint, fontSize: 11)),
        ]),
        const SizedBox(height: 6),
        ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
                value: jamaatFrac,
                minHeight: 8,
                backgroundColor: context.colors.bg,
                valueColor: AlwaysStoppedAnimation(context.colors.purple))),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DAILY CALENDAR — hasActivity intensity, no points
// ─────────────────────────────────────────────────────────────────────────────

class _DailyCalendar extends StatelessWidget {
  final List<DailyEntry> entries;
  final int year, month;
  final bool isFemale;

  const _DailyCalendar({
    required this.entries,
    required this.year,
    required this.month,
    required this.isFemale,
  });

  // Intensity score: congregation=2, solo=1, other=1
  int _score(DailyEntry e) {
    int s = 0;
    for (final item in e.entries) {
      if (item.prayerMode == PrayerMode.congregation)
        s += 2;
      else if (item.prayerMode == PrayerMode.solo)
        s += 1;
      else if (item.completed || item.count > 0) s += 1;
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final entryMap = <int, DailyEntry>{};
    for (final e in entries) entryMap[e.day] = e;

    final maxScore = entries.isEmpty
        ? 1
        : entries.map(_score).fold(1, (a, b) => a > b ? a : b).clamp(1, 999);

    return Container(
      decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border, width: 0.5)),
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Legend
        Wrap(spacing: 10, runSpacing: 4, children: [
          _LegendItem(color: context.colors.darkGreen, label: 'বেশি আমল'),
          _LegendItem(color: const Color(0xFFBBF7D0), label: 'কম আমল'),
          if (isFemale)
            _LegendItem(
                color: context.colors.pinkLight,
                label: 'মাহলি',
                bordered: true),
          _LegendItem(color: context.colors.bg, label: 'নেই', bordered: true),
        ]),
        const SizedBox(height: 12),

        // Day headers
        Row(
            children: ['রবি', 'সোম', 'মঙ্গ', 'বুধ', 'বৃহ', 'শুক্র', 'শনি']
                .map((d) => Expanded(
                    child: Center(
                        child: Text(d,
                            style: TextStyle(
                                color: context.colors.textHint,
                                fontSize: 9,
                                fontWeight: FontWeight.w600)))))
                .toList()),
        const SizedBox(height: 6),

        // Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 1),
          itemCount: daysInMonth,
          itemBuilder: (_, i) {
            final day = i + 1;
            final e = entryMap[day];
            final isExempt = e != null && e.isExemptDay && isFemale;
            final hasAct = e?.hasActivity ?? false;
            final score = e != null ? _score(e) : 0;
            final ratio = score / maxScore;

            Color bg;
            Color fg;

            if (isExempt) {
              bg = context.colors.pinkLight;
              fg = context.colors.pink;
            } else if (!hasAct || score == 0) {
              bg = context.colors.bg;
              fg = context.colors.textHint;
            } else if (ratio < 0.25) {
              bg = const Color(0xFFDCFCE7);
              fg = context.colors.green;
            } else if (ratio < 0.5) {
              bg = Color.lerp(
                  const Color(0xFFDCFCE7), context.colors.green, 0.4)!;
              fg = context.colors.green;
            } else if (ratio < 0.75) {
              bg = Color.lerp(
                  context.colors.green, context.colors.darkGreen, 0.3)!;
              fg = Colors.white;
            } else {
              bg = context.colors.darkGreen;
              fg = Colors.white;
            }

            return Container(
              decoration: BoxDecoration(
                  color: bg, borderRadius: BorderRadius.circular(6)),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text('$day',
                        style: TextStyle(
                            color: fg,
                            fontSize: 10.5,
                            fontWeight: hasAct || isExempt
                                ? FontWeight.w700
                                : FontWeight.w400)),
                    if (isExempt)
                      const Text('🌸',
                          style: TextStyle(fontSize: 6, height: 1)),
                  ])),
            );
          },
        ),
      ]),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool bordered;
  const _LegendItem(
      {required this.color, required this.label, this.bordered = false});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: bordered ? Border.all(color: context.colors.border) : null),
      ),
      const SizedBox(width: 4),
      Text(label,
          style: TextStyle(color: context.colors.textSecondary, fontSize: 10)),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DAY LIST
// ─────────────────────────────────────────────────────────────────────────────

class _DayList extends StatelessWidget {
  final List<DailyEntry> entries;
  final bool isFemale;
  const _DayList({required this.entries, required this.isFemale});

  @override
  Widget build(BuildContext context) {
    final sorted = [...entries]..sort((a, b) => a.day.compareTo(b.day));
    return Container(
      decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border, width: 0.5)),
      child: Column(
          children: List.generate(
              sorted.length,
              (i) => _DayTile(
                    entry: sorted[i],
                    isLast: i == sorted.length - 1,
                    isFemale: isFemale,
                    delay: 100 + i * 30,
                  ))),
    );
  }
}

class _DayTile extends StatelessWidget {
  final DailyEntry entry;
  final bool isLast, isFemale;
  final int delay;

  const _DayTile({
    required this.entry,
    required this.isLast,
    required this.isFemale,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final isExempt = entry.isExemptDay && isFemale;
    final entries = entry.entries;

    final congregation =
        entries.where((e) => e.prayerMode == PrayerMode.congregation).length;
    final solo = entries.where((e) => e.prayerMode == PrayerMode.solo).length;
    final missed =
        entries.where((e) => e.prayerMode == PrayerMode.missed).length;
    final other = entries
        .where((e) => e.prayerMode == null && (e.completed || e.count > 0))
        .length;
    final total = congregation + solo + other;
    final hasAct = entry.hasActivity;

    // Progress: congregation fraction of all prayers
    final prayerTotal = congregation + solo + missed;
    final progress = prayerTotal > 0
        ? congregation / prayerTotal
        : hasAct
            ? 0.5
            : 0.0;

    Color dayBg = isExempt
        ? context.colors.pinkLight
        : hasAct
            ? context.colors.greenLight
            : context.colors.bg;
    Color dayFg = isExempt
        ? context.colors.pink
        : hasAct
            ? context.colors.darkGreen
            : context.colors.textHint;

    Color barColor = isExempt
        ? context.colors.pink
        : congregation >= 3
            ? context.colors.green
            : congregation >= 1
                ? context.colors.amber
                : context.colors.border;

    String statusText = isExempt
        ? 'মাহলির দিন'
        : !hasAct
            ? 'কোনো আমল নেই'
            : '$total টি আমল সম্পন্ন';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: context.colors.border, width: 0.5)),
      ),
      child: Row(children: [
        // Day box
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: dayBg, borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text('${entry.day}',
                  style: TextStyle(
                      color: dayFg,
                      fontWeight: FontWeight.w800,
                      fontSize: 14))),
        ),
        const SizedBox(width: 12),

        // Status
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Flexible(
                child: Text(statusText,
                    style: TextStyle(
                        color: isExempt
                            ? context.colors.pink
                            : context.colors.textPrimary,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis)),
            if (congregation > 0) ...[
              const SizedBox(width: 5),
              _Pill(
                  text: '🕌 $congregation জামাত',
                  bg: context.colors.purpleLight,
                  fg: context.colors.purple),
            ] else if (solo > 0) ...[
              const SizedBox(width: 5),
              _Pill(
                  text: '🤲 $solo একাকী',
                  bg: context.colors.greenLight,
                  fg: context.colors.green),
            ],
          ]),
          if (missed > 0) ...[
            const SizedBox(height: 3),
            _Pill(
                text: '⚠️ $missed মিস',
                bg: context.colors.redLight,
                fg: context.colors.red2),
          ],
          if (!isExempt) ...[
            const SizedBox(height: 5),
            ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 4,
                    backgroundColor: context.colors.bg,
                    valueColor: AlwaysStoppedAnimation(barColor))),
          ],
        ])),

        const SizedBox(width: 10),

        // Status icon — points বাদ
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          if (isExempt)
            const Text('🌸', style: TextStyle(fontSize: 18))
          else if (congregation >= 4)
            Icon(Icons.star_rounded, color: context.colors.gold, size: 22)
          else if (congregation >= 1 || solo >= 1)
            Icon(Icons.check_circle_rounded,
                color: context.colors.green, size: 22)
          else if (hasAct)
            Icon(Icons.circle_outlined, color: context.colors.amber, size: 22)
          else
            Icon(Icons.remove_circle_outline_rounded,
                color: context.colors.border, size: 22),
          const SizedBox(height: 2),
          Text(
              isExempt
                  ? 'মাফ'
                  : congregation >= 4
                      ? 'পূর্ণ'
                      : congregation >= 1
                          ? 'আংশিক'
                          : hasAct
                              ? 'কিছু'
                              : 'শূন্য',
              style: TextStyle(
                  color: context.colors.textHint,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w500)),
        ]),
      ]),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 220.ms)
        .slideX(begin: 0.03, curve: Curves.easeOut);
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color bg, fg;
  const _Pill({required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
      child: Text(text,
          style:
              TextStyle(color: fg, fontSize: 9, fontWeight: FontWeight.w700)),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INSPIRATION CARD
// ─────────────────────────────────────────────────────────────────────────────

class _InspirationCard extends StatelessWidget {
  final String name;
  const _InspirationCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: context.colors.goldLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: context.colors.gold.withOpacity(0.25), width: 0.5)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('💡', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(
            child: Text(
                '${name.split(' ').first} তাঁর আমলের তথ্য শেয়ার করেছেন যাতে অন্যরা অনুপ্রাণিত হতে পারেন। আল্লাহ তাঁর আমল কবুল করুন। আমিন।',
                style: TextStyle(
                    color: context.colors.ambalText,
                    fontSize: 12,
                    height: 1.6))),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION LABEL
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label.toUpperCase(),
        style: TextStyle(
            color: context.colors.textHint,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SKELETON
// ─────────────────────────────────────────────────────────────────────────────

class _SheetSkeleton extends StatelessWidget {
  const _SheetSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(children: [
        _shimmer(height: 120, context: context),
        const SizedBox(
          height: 16,
        ),
        _shimmer(height: 100, context: context),
        const SizedBox(
          height: 16,
        ),
        _shimmer(height: 220, context: context),
        const SizedBox(
          height: 16,
        ),
        _shimmer(height: 280, context: context),
      ]),
    );
  }

  Widget _shimmer({required double height, required BuildContext context}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border, width: 0.5)),
    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, colors: [
      context.colors.card,
      context.colors.shimmerHighlight,
      context.colors.card
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ERROR
// ─────────────────────────────────────────────────────────────────────────────

class _SheetError extends StatelessWidget {
  final VoidCallback onRetry;
  const _SheetError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
                color: context.colors.redLight,
                borderRadius: BorderRadius.circular(18)),
            child: Icon(Icons.lock_outline_rounded,
                color: context.colors.red2, size: 28),
          ),
          const SizedBox(height: 16),
          Text('প্রোফাইল দেখা যাচ্ছে না',
              style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('এই ব্যবহারকারী তাঁর প্রোফাইল বন্ধ করে দিয়েছেন',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: context.colors.textSecondary, fontSize: 13)),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: context.colors.greenLight,
                  borderRadius: BorderRadius.circular(10)),
              child: Text('আবার চেষ্টা করুন',
                  style: TextStyle(
                      color: context.colors.darkGreen,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
            ),
          ),
        ]),
      ),
    );
  }
}
