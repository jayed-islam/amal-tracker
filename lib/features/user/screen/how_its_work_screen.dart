import 'package:amal_tracker/features/user/widgets/app_silver_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────

class _C {
  static const bg = Color(0xFFF4F6F1);
  static const card = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const midGreen = Color(0xFF1B7045);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFFFF8E7);
  static const amber = Color(0xFFF59E0B);
  static const amberLight = Color(0xFFFFF3E0);
  static const blue = Color(0xFF0891B2);
  static const blueLight = Color(0xFFE0F2FE);
  static const purple = Color(0xFF7C3AED);
  static const purpleLight = Color(0xFFEDE9FE);
  static const rose = Color(0xFFE11D48);
  static const roseLight = Color(0xFFFFE4E6);
  static const teal = Color(0xFF0D9488);
  static const tealLight = Color(0xFFCCFBF1);
  static const border = Color(0xFFE4EAE4);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF4E6357);
  static const textHint = Color(0xFFABBAAE);
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class HowItWorksScreen extends ConsumerStatefulWidget {
  const HowItWorksScreen({super.key});

  @override
  ConsumerState<HowItWorksScreen> createState() => _HowItWorksScreenState();
}

class _HowItWorksScreenState extends ConsumerState<HowItWorksScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isFemale = user?.gender?.toLowerCase() == 'female';
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final hPad = isTablet ? (size.width - 600) / 2 + 20.0 : 20.0;

    return Scaffold(
      backgroundColor: _C.bg,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App bar ───────────────────────────────────────────────
          AppSliverBar(
            scrollController: _scrollController,
            title: 'কীভাবে কাজ করে?',
            subtitle: 'পয়েন্ট ও র‍্যাংকিং পদ্ধতি',
            icon: Icons.trending_up_rounded,
            color: _C.darkGreen,
          ),

          // ── Body ─────────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 60),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ①  AMAL TYPES ────────────────────────────────────
                _BlockHeader(
                  emoji: '📖',
                  title: 'আমলের ধরন',
                  subtitle: 'তিন ধরনের আমল রেকর্ড করা যায়',
                ).animate().fadeIn(duration: 280.ms),

                const SizedBox(height: 10),

                _TypeCards().animate().fadeIn(delay: 60.ms),

                const SizedBox(height: 26),

                // ②  PRAYER MODES ──────────────────────────────────
                _BlockHeader(
                  emoji: '🕌',
                  title: 'নামাজের স্তর',
                  subtitle: 'আদায়ের স্থান অনুযায়ী পয়েন্ট আলাদা',
                ).animate().fadeIn(delay: 100.ms),

                const SizedBox(height: 10),

                _PrayerModesCard().animate().fadeIn(delay: 140.ms),

                const SizedBox(height: 26),

                // ③  COUNTER LOGIC ─────────────────────────────────
                _BlockHeader(
                  emoji: '🔢',
                  title: 'গণনাযোগ্য আমল',
                  subtitle: 'প্রতিটি একক আলাদাভাবে গণনা হয়',
                ).animate().fadeIn(delay: 160.ms),

                const SizedBox(height: 10),

                _CounterCard().animate().fadeIn(delay: 190.ms),

                const SizedBox(height: 26),

                // ④  DAILY SCORE LOGIC ─────────────────────────────
                _BlockHeader(
                  emoji: '📅',
                  title: 'দৈনিক সংগ্রহ',
                  subtitle: 'প্রতিদিনের সব আমলের পয়েন্ট যোগ হয়',
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 10),

                _DailyScoreCard().animate().fadeIn(delay: 220.ms),

                const SizedBox(height: 26),

                // ⑤  MONTHLY TOTAL ─────────────────────────────────
                _BlockHeader(
                  emoji: '📊',
                  title: 'মাসিক মোট পয়েন্ট',
                  subtitle: 'সব দিনের পয়েন্ট যোগ করে মাসের স্কোর তৈরি হয়',
                ).animate().fadeIn(delay: 240.ms),

                const SizedBox(height: 10),

                _MonthlyCard().animate().fadeIn(delay: 260.ms),

                const SizedBox(height: 26),

                // ⑥  LEADERBOARD ───────────────────────────────────
                _BlockHeader(
                  emoji: '🏆',
                  title: 'লিডারবোর্ড',
                  subtitle: 'মাসের শেষে সবার স্কোর তুলনা হয়',
                ).animate().fadeIn(delay: 280.ms),

                const SizedBox(height: 10),

                _LeaderboardCard().animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 26),

                // ⑦  FEMALE EXEMPT — only for female users ─────────
                if (isFemale) ...[
                  _BlockHeader(
                    emoji: '🌸',
                    title: 'মাহলির দিন',
                    subtitle: 'শুধু আপনার জন্য বিশেষ সুবিধা',
                    accentColor: const Color(0xFFDB2777),
                  ).animate().fadeIn(delay: 320.ms),
                  const SizedBox(height: 10),
                  _FemaleExemptCard().animate().fadeIn(delay: 340.ms),
                  const SizedBox(height: 26),
                ],

                // ⑧  TIPS ──────────────────────────────────────────
                _TipsCard().animate().fadeIn(delay: 360.ms),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BLOCK HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _BlockHeader extends StatelessWidget {
  final String emoji, title, subtitle;
  final Color? accentColor;

  const _BlockHeader({
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: (accentColor ?? _C.darkGreen).withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child:
              Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: accentColor ?? _C.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: _C.textHint, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TYPE CARDS — three amal types explained
// ─────────────────────────────────────────────────────────────────────────────

class _TypeCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const types = [
      _TypeInfo(
        emoji: '✅',
        title: 'হ্যাঁ / না',
        desc: 'আমলটি করেছেন কি না — এতুকুই। যেমন কুরআন তিলাওয়াত, সদকা।',
        bg: Color(0xFFE8F5EE),
        border: Color(0xFF16A34A),
        textColor: Color(0xFF0E3D22),
      ),
      _TypeInfo(
        emoji: '🕌',
        title: 'নামাজ',
        desc: 'জামাতে, একাকী বা মিস — তিনটি স্তরে আলাদা পয়েন্ট।',
        bg: Color(0xFFFFF8E7),
        border: Color(0xFFD4A843),
        textColor: Color(0xFF78350F),
      ),
      _TypeInfo(
        emoji: '🔢',
        title: 'গণনা',
        desc: 'প্রতিটি একক গণনা করা হয়। যেমন আয়াত পড়া, তাসবিহ।',
        bg: Color(0xFFE0F2FE),
        border: Color(0xFF0891B2),
        textColor: Color(0xFF0C4A6E),
      ),
    ];

    return Column(
      children: types.asMap().entries.map((e) {
        final t = e.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: t.bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: t.border.withOpacity(0.4), width: 1),
          ),
          child: Row(
            children: [
              Text(t.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.title,
                      style: TextStyle(
                        color: t.textColor,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.desc,
                      style: TextStyle(
                        color: t.textColor.withOpacity(0.75),
                        fontSize: 11.5,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
            .animate(delay: Duration(milliseconds: e.key * 60))
            .fadeIn()
            .slideX(begin: 0.04);
      }).toList(),
    );
  }
}

class _TypeInfo {
  final String emoji, title, desc;
  final Color bg, border, textColor;
  const _TypeInfo({
    required this.emoji,
    required this.title,
    required this.desc,
    required this.bg,
    required this.border,
    required this.textColor,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// PRAYER MODES CARD
// ─────────────────────────────────────────────────────────────────────────────

class _PrayerModesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 0.5),
      ),
      child: Column(
        children: [
          _ModeRow(
            emoji: '✔',
            label: 'জামাতে আদায়',
            desc: 'মসজিদে বা দলবদ্ধভাবে',
            badge: 'সর্বোচ্চ পয়েন্ট',
            badgeColor: _C.green,
            badgeBg: _C.greenLight,
            isFirst: true,
          ),
          const Divider(height: 0.5, thickness: 0.5, color: _C.border),
          _ModeRow(
            emoji: '/',
            label: 'একাকী আদায়',
            desc: 'ঘরে বা একলা পড়েছেন',
            badge: 'কম পয়েন্ট',
            badgeColor: _C.amber,
            badgeBg: _C.amberLight,
          ),
          const Divider(height: 0.5, thickness: 0.5, color: _C.border),
          _ModeRow(
            emoji: '✗',
            label: 'মিস হয়েছে',
            desc: 'পড়া হয়নি',
            badge: '০ পয়েন্ট',
            badgeColor: _C.textHint,
            badgeBg: _C.bg,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _ModeRow extends StatelessWidget {
  final String emoji, label, desc, badge;
  final Color badgeColor, badgeBg;
  final bool isFirst, isLast;

  const _ModeRow({
    required this.emoji,
    required this.label,
    required this.desc,
    required this.badge,
    required this.badgeColor,
    required this.badgeBg,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(16) : Radius.zero,
          bottom: isLast ? const Radius.circular(16) : Radius.zero,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Center(
              child: Text(
                emoji,
                style: TextStyle(
                    fontSize: 16,
                    color: badgeColor,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: _C.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
                Text(desc,
                    style:
                        const TextStyle(color: _C.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: badgeColor.withOpacity(0.25), width: 0.5),
            ),
            child: Text(
              badge,
              style: TextStyle(
                color: badgeColor,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COUNTER CARD
// ─────────────────────────────────────────────────────────────────────────────

class _CounterCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _C.blueLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.blue.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          // Visual example
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final filled = i < 3;
              return Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: filled ? _C.blue : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: _C.blue.withOpacity(0.3), width: 0.5),
                ),
                child: Center(
                  child: Text(
                    filled ? '✓' : '',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 12),

          // Explanation
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                  color: Color(0xFF0C4A6E), fontSize: 12.5, height: 1.6),
              children: [
                TextSpan(text: 'উদাহরণ: ৩ আয়াত তিলাওয়াত করলে\n'),
                TextSpan(
                  text: 'প্রতি আয়াত × পয়েন্ট = মোট পয়েন্ট',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'যত বেশি করবেন, তত বেশি পয়েন্ট পাবেন',
              style: TextStyle(
                color: _C.blue,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DAILY SCORE CARD
// ─────────────────────────────────────────────────────────────────────────────

class _DailyScoreCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 0.5),
      ),
      child: Column(
        children: [
          // Flow diagram
          _FlowRow(
            items: const ['নামাজ', 'যিকর', 'তিলাওয়াত', 'অভ্যাস'],
            icons: const ['🕌', '📿', '📖', '💪'],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _C.greenLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_rounded,
                      color: _C.darkGreen, size: 16),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: _C.darkGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('⭐', style: TextStyle(fontSize: 18)),
                SizedBox(width: 8),
                Text(
                  'দৈনিক মোট পয়েন্ট',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const _InfoNote(
            text:
                'একটি দিনে সব আমলের পয়েন্ট যোগ হয়ে দৈনিক স্কোর তৈরি হয়। প্রতিদিন রেকর্ড করুন।',
          ),
        ],
      ),
    );
  }
}

class _FlowRow extends StatelessWidget {
  final List<String> items, icons;
  const _FlowRow({required this.items, required this.icons});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(items.length, (i) {
        return Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _C.greenLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                  child: Text(icons[i], style: const TextStyle(fontSize: 20))),
            ),
            const SizedBox(height: 4),
            Text(
              items[i],
              style: const TextStyle(
                  color: _C.textSecondary,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500),
            ),
          ],
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MONTHLY CARD
// ─────────────────────────────────────────────────────────────────────────────

class _MonthlyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _C.goldLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.gold.withOpacity(0.4), width: 1),
      ),
      child: Column(
        children: [
          // Mini calendar-style dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (i) {
              final filled = i < 5;
              return Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: filled ? _C.gold : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: _C.gold.withOpacity(0.3), width: 0.5),
                ),
                child: Center(
                  child: Text(
                    filled ? '★' : '·',
                    style: TextStyle(
                      color: filled ? Colors.white : _C.textHint,
                      fontSize: filled ? 14 : 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 12),

          const Text(
            'দিন ১ + দিন ২ + দিন ৩ + ... = মাসিক স্কোর',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF78350F),
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 10),

          const _InfoNote(
            text:
                'মাসের প্রতিটি দিনের পয়েন্ট যোগ হয়। বেশি দিন রেকর্ড করলে মাসের স্কোর বাড়বে।',
            textColor: Color(0xFF92400E),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LEADERBOARD CARD
// ─────────────────────────────────────────────────────────────────────────────

class _LeaderboardCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 0.5),
      ),
      child: Column(
        children: [
          // Mock leaderboard rows
          _LeaderRow(
              rank: 1,
              emoji: '🥇',
              name: 'সর্বোচ্চ পয়েন্ট',
              desc: 'মাসে সবচেয়ে বেশি আমল করেছেন',
              rankColor: const Color(0xFFD4A843),
              rankBg: const Color(0xFFFFFBF0),
              isFirst: true),
          const Divider(height: 0.5, thickness: 0.5, color: _C.border),
          _LeaderRow(
              rank: 2,
              emoji: '🥈',
              name: 'দ্বিতীয় স্থান',
              desc: 'পয়েন্টে দ্বিতীয় সর্বোচ্চ',
              rankColor: const Color(0xFF94A3B8),
              rankBg: const Color(0xFFF8FAFC)),
          const Divider(height: 0.5, thickness: 0.5, color: _C.border),
          _LeaderRow(
              rank: 3,
              emoji: '🥉',
              name: 'তৃতীয় স্থান',
              desc: 'পয়েন্টে তৃতীয় সর্বোচ্চ',
              rankColor: const Color(0xFFCD7F32),
              rankBg: const Color(0xFFFFF7ED),
              isLast: true),

          // Explanation note
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: _C.border, width: 0.5)),
            ),
            child: Column(
              children: const [
                _BulletPoint(
                    text:
                        'প্রতি মাসে আলাদা র‍্যাংকিং — আগের মাসের হিসাব নতুন মাসে নেই'),
                SizedBox(height: 6),
                _BulletPoint(
                    text:
                        'একই জেলা বা প্রতিষ্ঠানের মধ্যেও আলাদা র‍্যাংকিং দেখা যাবে'),
                SizedBox(height: 6),
                _BulletPoint(
                    text:
                        'লিডারবোর্ডে শুধু মাসিক স্কোর দেখা যায় — বিস্তারিত আমল গোপন থাকে'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderRow extends StatelessWidget {
  final int rank;
  final String emoji, name, desc;
  final Color rankColor, rankBg;
  final bool isFirst, isLast;

  const _LeaderRow({
    required this.rank,
    required this.emoji,
    required this.name,
    required this.desc,
    required this.rankColor,
    required this.rankBg,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: rankBg,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(16) : Radius.zero,
          bottom: isLast ? const Radius.circular(16) : Radius.zero,
        ),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        color: _C.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
                Text(desc,
                    style:
                        const TextStyle(color: _C.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: rankColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '#$rank',
              style: TextStyle(
                color: rankColor,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FEMALE EXEMPT CARD  — only shown to female users
// ─────────────────────────────────────────────────────────────────────────────

class _FemaleExemptCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFDB2777).withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFDB2777).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('🌸', style: TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'মাহলির দিন চালু করুন',
                      style: TextStyle(
                        color: Color(0xFF9D174D),
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'আমল রেকর্ড করার সময় সালাত বিভাগে পাবেন',
                      style: TextStyle(
                        color: Color(0xFFBE185D),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Steps
          _ExemptStep(
            number: '১',
            text: 'সালাত বিভাগে "আজ কি মাহলি আছেন?" টগল চালু করুন',
          ),
          const SizedBox(height: 8),
          _ExemptStep(
            number: '২',
            text: 'ফরজ নামাজগুলো স্বয়ংক্রিয়ভাবে "মাফ আছে" হিসেবে চিহ্নিত হবে',
          ),
          const SizedBox(height: 8),
          _ExemptStep(
            number: '৩',
            text: 'নফল ও সুন্নাহ আমল স্বাভাবিকভাবেই রেকর্ড করতে পারবেন',
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: const Color(0xFFDB2777).withOpacity(0.15), width: 0.5),
            ),
            child: const Row(
              children: [
                Text('💡', style: TextStyle(fontSize: 14)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'মাহলির দিনগুলো র‍্যাংকিং-এ কোনো নেতিবাচক প্রভাব ফেলে না। ফরজ আমল মাফ, বাকি আমলের পয়েন্ট স্বাভাবিক।',
                    style: TextStyle(
                      color: Color(0xFF9D174D),
                      fontSize: 11,
                      height: 1.5,
                    ),
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

class _ExemptStep extends StatelessWidget {
  final String number, text;
  const _ExemptStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: const Color(0xFFDB2777).withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Color(0xFF9D174D),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF9D174D),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TIPS CARD
// ─────────────────────────────────────────────────────────────────────────────

class _TipsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const tips = [
      _Tip(
          emoji: '📅',
          text: 'প্রতিদিন রেকর্ড করুন — একদিন বাদ পড়লে পয়েন্ট যোগ হয় না'),
      _Tip(
          emoji: '🕌',
          text: 'জামাতে নামাজ পড়লে একাকীর চেয়ে বেশি পয়েন্ট পাবেন'),
      _Tip(
          emoji: '🔢',
          text:
              'গণনার আমলে যত বেশি করবেন তত বেশি পয়েন্ট — কোনো ঊর্ধ্বসীমা নেই'),
      _Tip(
          emoji: '🏆',
          text: 'মাসের শেষ দিন পর্যন্ত র‍্যাংকিং পরিবর্তন হতে পারে'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: _C.purpleLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.purple.withOpacity(0.25), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Row(
              children: const [
                Text('💡', style: TextStyle(fontSize: 16)),
                SizedBox(width: 8),
                Text(
                  'দরকারি টিপস',
                  style: TextStyle(
                    color: _C.purple,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0.5, thickness: 0.5, color: Color(0xFFDDD6FE)),
          ...tips.asMap().entries.map((e) {
            final t = e.value;
            final isLast = e.key == tips.length - 1;
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.emoji, style: const TextStyle(fontSize: 15)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          t.text,
                          style: const TextStyle(
                            color: _C.purple,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  const Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: Color(0xFFDDD6FE),
                      indent: 40),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _Tip {
  final String emoji, text;
  const _Tip({required this.emoji, required this.text});
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED HELPERS
// ─────────────────────────────────────────────────────────────────────────────

class _InfoNote extends StatelessWidget {
  final String text;
  final Color? textColor;

  const _InfoNote({required this.text, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor ?? _C.textSecondary,
          fontSize: 11.5,
          height: 1.5,
        ),
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.only(top: 5, right: 8),
          decoration: const BoxDecoration(
            color: _C.darkGreen,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _C.textSecondary,
              fontSize: 11.5,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
