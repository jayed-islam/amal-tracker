import 'package:amal_tracker/features/user/widgets/app_silver_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────

class _C {
  static const bg = Color(0xFFF4F6F1);
  static const card = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFFFF8E7);
  static const amber = Color(0xFFF59E0B);
  static const amberLight = Color(0xFFFFF3E0);
  static const blue = Color(0xFF0891B2);
  static const blueLight = Color(0xFFE0F2FE);
  static const teal = Color(0xFF0D9488);
  static const tealLight = Color(0xFFCCFBF1);
  static const purple = Color(0xFF7C3AED);
  static const purpleLight = Color(0xFFEDE9FE);
  static const rose = Color(0xFFE11D48);
  static const roseLight = Color(0xFFFFE4E6);
  static const pink = Color(0xFFDB2777);
  static const border = Color(0xFFE4EAE4);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSec = Color(0xFF4E6357);
  static const textHint = Color(0xFFABBAAE);
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class HowItWorksScreen extends ConsumerStatefulWidget {
  const HowItWorksScreen({super.key});

  @override
  ConsumerState<HowItWorksScreen> createState() => _State();
}

class _State extends ConsumerState<HowItWorksScreen> {
  late final ScrollController _sc;

  @override
  void initState() {
    super.initState();
    _sc = ScrollController();
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isFemale = user?.gender?.toLowerCase() == 'female';
    final w = MediaQuery.of(context).size.width;
    final hPad = w > 600 ? (w - 600) / 2 + 20.0 : 20.0;

    return Scaffold(
      backgroundColor: _C.bg,
      body: CustomScrollView(
        controller: _sc,
        physics: const BouncingScrollPhysics(),
        slivers: [
          AppSliverBar(
            scrollController: _sc,
            title: 'কীভাবে কাজ করে?',
            subtitle: 'পয়েন্ট ও র‍্যাংকিং পদ্ধতি',
            icon: Icons.trending_up_rounded,
            color: _C.darkGreen,
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 60),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ① পয়েন্ট কীভাবে পাবেন
                _SectionHeader(emoji: '⭐', title: 'পয়েন্ট কীভাবে পাবেন')
                    .animate()
                    .fadeIn(duration: 260.ms),
                const SizedBox(height: 10),
                _PointsCard().animate().fadeIn(delay: 60.ms),
                const SizedBox(height: 24),

                // ② মাসিক সম্পূর্ণতা
                _SectionHeader(emoji: '📊', title: 'মাসিক সম্পূর্ণতার হার')
                    .animate()
                    .fadeIn(delay: 80.ms),
                const SizedBox(height: 10),
                _CompletionCard().animate().fadeIn(delay: 100.ms),
                const SizedBox(height: 24),

                // ③ র‍্যাংকিং কীভাবে হয়
                _SectionHeader(emoji: '🏆', title: 'র‍্যাংকিং কীভাবে হয়')
                    .animate()
                    .fadeIn(delay: 120.ms),
                const SizedBox(height: 10),
                _RankingCard().animate().fadeIn(delay: 140.ms),
                const SizedBox(height: 24),

                // ③.৫ নামাজ ও লিডারবোর্ড — নতুন section 👈
                _SectionHeader(
                  emoji: '🕌',
                  title: 'নামাজ ও লিডারবোর্ড',
                  accentColor: _C.teal,
                ).animate().fadeIn(delay: 155.ms),
                const SizedBox(height: 10),
                _PrayerFairnessCard(isFemale: isFemale)
                    .animate()
                    .fadeIn(delay: 165.ms),
                const SizedBox(height: 24),

                // মাহলির দিন — শুধু মহিলার জন্য
                if (isFemale) ...[
                  _SectionHeader(
                    emoji: '🌸',
                    title: 'মাহলির দিন',
                    accentColor: _C.pink,
                  ).animate().fadeIn(delay: 160.ms),
                  const SizedBox(height: 10),
                  _FemaleExemptCard().animate().fadeIn(delay: 180.ms),
                  const SizedBox(height: 24),
                ],

                // ⑤ এগিয়ে থাকার টিপস
                _TipsCard().animate().fadeIn(delay: 200.ms),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String emoji, title;
  final Color? accentColor;

  const _SectionHeader({
    required this.emoji,
    required this.title,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? _C.darkGreen;
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.09),
            borderRadius: BorderRadius.circular(10),
          ),
          child:
              Center(child: Text(emoji, style: const TextStyle(fontSize: 17))),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ① POINTS CARD
// ─────────────────────────────────────────────────────────────────────────────

class _PointsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Namaz row — special because has 3 levels
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _C.goldLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.gold.withOpacity(0.35), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text('🕌', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 8),
                  Text(
                    'নামাজ',
                    style: TextStyle(
                      color: Color(0xFF78350F),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NamazLevel(
                  label: 'জামাতে পড়লে',
                  badge: 'সর্বোচ্চ পয়েন্ট',
                  badgeColor: _C.green,
                  badgeBg: _C.greenLight),
              const SizedBox(height: 6),
              _NamazLevel(
                  label: 'একাকী পড়লে',
                  badge: 'কম পয়েন্ট',
                  badgeColor: _C.amber,
                  badgeBg: _C.amberLight),
              const SizedBox(height: 6),
              _NamazLevel(
                  label: 'পড়া না হলে',
                  badge: '০ পয়েন্ট',
                  badgeColor: _C.textHint,
                  badgeBg: _C.bg),
            ],
          ),
        ).animate(delay: 40.ms).fadeIn().slideY(begin: 0.04),

        const SizedBox(height: 8),

        // Other amal
        Row(
          children: [
            Expanded(
              child: _SimplePointBox(
                emoji: '✅',
                title: 'অন্য আমল',
                desc: 'করলে পয়েন্ট পাবেন\nনা করলে ০',
                bg: _C.greenLight,
                borderColor: _C.green,
                textColor: _C.darkGreen,
                delay: 80,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SimplePointBox(
                emoji: '🔢',
                title: 'গণনার আমল',
                desc: 'যত বেশি করবেন\nতত বেশি পয়েন্ট',
                bg: _C.blueLight,
                borderColor: _C.blue,
                textColor: const Color(0xFF0C4A6E),
                delay: 120,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NamazLevel extends StatelessWidget {
  final String label, badge;
  final Color badgeColor, badgeBg;
  const _NamazLevel({
    required this.label,
    required this.badge,
    required this.badgeColor,
    required this.badgeBg,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF92400E), fontSize: 12.5),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
            color: badgeBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: badgeColor.withOpacity(0.3), width: 0.5),
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
    );
  }
}

class _SimplePointBox extends StatelessWidget {
  final String emoji, title, desc;
  final Color bg, borderColor, textColor;
  final int delay;

  const _SimplePointBox({
    required this.emoji,
    required this.title,
    required this.desc,
    required this.bg,
    required this.borderColor,
    required this.textColor,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(title,
              style: TextStyle(
                  color: textColor, fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(desc,
              style: TextStyle(
                  color: textColor.withOpacity(0.7),
                  fontSize: 11.5,
                  height: 1.45)),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn()
        .slideY(begin: 0.04);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ② MONTHLY COMPLETION CARD
// ─────────────────────────────────────────────────────────────────────────────

class _CompletionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main explanation
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _C.tealLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _C.teal.withOpacity(0.3), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'মাসের ফরজ আমলগুলো কতটা পালন করেছেন — সেই হিসাবে এই % তৈরি হয়',
                style: TextStyle(
                  color: Color(0xFF085041),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 14),

              // Example
              const Text(
                'উদাহরণ',
                style: TextStyle(
                  color: _C.teal,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _ExampleRow(
                        label: 'মাসে মোট দিন অতিবাহিত', value: '২২ দিন'),
                    const SizedBox(height: 6),
                    _ExampleRow(
                        label: 'সব ফরজ সম্পন্ন হয়েছে', value: '১৮ দিন'),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                          height: 0.5, thickness: 0.5, color: _C.border),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'সম্পূর্ণতার হার',
                          style: TextStyle(
                            color: Color(0xFF085041),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _C.teal,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '৮২%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: 0.82,
                        minHeight: 7,
                        backgroundColor: _C.tealLight,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(_C.teal),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Key rule box
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.border, width: 0.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('💡', style: TextStyle(fontSize: 15)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'একদিন সব ফরজ পালন করলেই সেই দিন গণনায় আসে। শুধু কিছু পড়লে হবে না — সব ফরজ লাগবে।',
                  style: TextStyle(
                    color: _C.textSec,
                    fontSize: 12,
                    height: 1.55,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExampleRow extends StatelessWidget {
  final String label, value;
  const _ExampleRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: _C.textSec, fontSize: 12)),
        Text(value,
            style: const TextStyle(
                color: _C.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ③ RANKING CARD
// ─────────────────────────────────────────────────────────────────────────────

class _RankingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // How rank is determined — 3 steps
        Container(
          decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _C.border, width: 0.5),
          ),
          child: Column(
            children: [
              _RankStepRow(
                step: '১',
                stepBg: _C.tealLight,
                stepColor: _C.teal,
                title: 'ফরজ সম্পূর্ণতার হার',
                desc: 'যার হার বেশি সে এগিয়ে — এটাই প্রধান মানদণ্ড',
                isFirst: true,
              ),
              const Divider(height: 0.5, thickness: 0.5, color: _C.border),
              _RankStepRow(
                step: '২',
                stepBg: _C.blueLight,
                stepColor: _C.blue,
                title: 'মোট পয়েন্ট',
                desc: 'হার সমান হলে যার পয়েন্ট বেশি সে এগিয়ে',
              ),
              const Divider(height: 0.5, thickness: 0.5, color: _C.border),
              _RankStepRow(
                step: '৩',
                stepBg: _C.roseLight,
                stepColor: _C.rose,
                title: 'ধারাবাহিকতা',
                desc:
                    'উপরের দুটো সমান হলে যে বেশি দিন ধারাবাহিকভাবে রেকর্ড করেছেন সে এগিয়ে',
                isLast: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Monthly winners
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _C.goldLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.gold.withOpacity(0.35), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text('🥇', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Text(
                    'মাসিক বিজয়ী — তিনটি বিভাগ',
                    style: TextStyle(
                      color: Color(0xFF78350F),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _WinnerLine(emoji: '🥇', text: 'সর্বোচ্চ ফরজ সম্পূর্ণতার হার'),
              const SizedBox(height: 6),
              _WinnerLine(emoji: '💪', text: 'সর্বোচ্চ মোট পয়েন্ট'),
              const SizedBox(height: 6),
              _WinnerLine(emoji: '🔥', text: 'সর্বোচ্চ ধারাবাহিকতা'),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Notes
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.border, width: 0.5),
          ),
          child: Column(
            children: const [
              _Note(
                  text:
                      'প্রতি মাসে আলাদা র‍্যাংকিং — আগের মাসের হিসাব নতুন মাসে নেই'),
              SizedBox(height: 6),
              _Note(
                  text:
                      'লিডারবোর্ডে শুধু মাসের সামগ্রিক স্কোর দেখা যায় — আপনার বিস্তারিত আমল গোপন থাকে'),
              SizedBox(height: 6),
              _Note(
                  text:
                      'চাইলে Settings থেকে নিজেকে লিডারবোর্ড থেকে লুকিয়ে রাখতে পারবেন'),
            ],
          ),
        ),
      ],
    );
  }
}

class _RankStepRow extends StatelessWidget {
  final String step, title, desc;
  final Color stepBg, stepColor;
  final bool isFirst, isLast;

  const _RankStepRow({
    required this.step,
    required this.stepBg,
    required this.stepColor,
    required this.title,
    required this.desc,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: stepBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step,
                style: TextStyle(
                  color: stepColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: _C.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(desc,
                    style: const TextStyle(
                        color: _C.textSec, fontSize: 11.5, height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WinnerLine extends StatelessWidget {
  final String emoji, text;
  const _WinnerLine({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF92400E),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _Note extends StatelessWidget {
  final String text;
  const _Note({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.only(top: 6, right: 8),
          decoration: const BoxDecoration(
            color: _C.textHint,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style:
                const TextStyle(color: _C.textSec, fontSize: 12, height: 1.5),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ④ FEMALE EXEMPT CARD — only shown to female users
// ─────────────────────────────────────────────────────────────────────────────

class _FemaleExemptCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.pink.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🌸', style: TextStyle(fontSize: 22)),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'মাহলির দিন চালু করলে কী হয়?',
                      style: TextStyle(
                        color: Color(0xFF9D174D),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'আমল রেকর্ড করার সময় এই অপশন পাবেন',
                      style: TextStyle(color: Color(0xFFBE185D), fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _ExemptPoint(
              text: 'সেই দিনের ফরজ নামাজ মাফ হিসেবে চিহ্নিত হয়, পয়েন্ট ০'),
          const SizedBox(height: 7),
          _ExemptPoint(
              text: 'নফল ও সুন্নাহ আমল স্বাভাবিকভাবেই রেকর্ড ও পয়েন্ট পাবেন'),
          const SizedBox(height: 7),
          _ExemptPoint(
              text:
                  'মাসিক সম্পূর্ণতার হারে এই দিনগুলো বাদ দিয়ে হিসাব হয় — র‍্যাংকিংয়ে কোনো ক্ষতি নেই'),
          const SizedBox(height: 7),
          _ExemptPoint(text: 'ধারাবাহিকতার গণনায়ও এই দিন ভাঙে না'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _C.pink.withOpacity(0.15), width: 0.5),
            ),
            child: const Row(
              children: [
                Text('💡', style: TextStyle(fontSize: 14)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'মাহলির দিনগুলো র‍্যাংকিংয়ে কোনো নেতিবাচক প্রভাব ফেলে না।',
                    style: TextStyle(
                      color: Color(0xFF9D174D),
                      fontSize: 11.5,
                      height: 1.45,
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

class _ExemptPoint extends StatelessWidget {
  final String text;
  const _ExemptPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.only(top: 5, right: 9),
          decoration: BoxDecoration(
            color: _C.pink.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
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
// ⑤ TIPS CARD
// ─────────────────────────────────────────────────────────────────────────────

class _TipsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const tips = [
      _Tip(
          emoji: '✅',
          text: 'ফরজ আমলে মনোযোগ দিন — এটাই র‍্যাংকিংয়ের প্রধান মানদণ্ড'),
      _Tip(
          emoji: '🕌',
          text: 'জামাতে নামাজ পড়লে একাকীর চেয়ে বেশি পয়েন্ট পাবেন'),
      _Tip(
          emoji: '📅',
          text: 'প্রতিদিন রেকর্ড করুন — একদিন বাদ পড়লে ধারাবাহিকতা ভাঙে'),
      _Tip(
          emoji: '🔢',
          text: 'গণনার আমলে যত বেশি করবেন তত পয়েন্ট — কোনো সীমা নেই'),
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
                Text('💡', style: TextStyle(fontSize: 15)),
                SizedBox(width: 8),
                Text(
                  'এগিয়ে থাকার টিপস',
                  style: TextStyle(
                    color: _C.purple,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0.5, thickness: 0.5, color: Color(0xFFDDD6FE)),
          ...tips.asMap().entries.map((e) {
            final isLast = e.key == tips.length - 1;
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.value.emoji, style: const TextStyle(fontSize: 15)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          e.value.text,
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
// ─────────────────────────────────────────────────────────────────────────────
// ③.৫ PRAYER FAIRNESS CARD
// ─────────────────────────────────────────────────────────────────────────────

class _PrayerFairnessCard extends StatelessWidget {
  final bool isFemale;
  const _PrayerFairnessCard({required this.isFemale});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main explanation box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _C.tealLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _C.teal.withOpacity(0.3), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'নামাজের পয়েন্ট দুটো কাজে ব্যবহার হয়',
                style: TextStyle(
                  color: Color(0xFF085041),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),

              // Personal points row
              _FairnessRow(
                emoji: '👤',
                label: 'ব্যক্তিগত পয়েন্ট',
                desc:
                    'জামাতে পড়লে বেশি পয়েন্ট, একাকী পড়লে কম — আসল সওয়াব অনুযায়ী',
                bg: _C.greenLight,
                borderColor: _C.green,
                textColor: _C.darkGreen,
              ),
              const SizedBox(height: 8),

              // Leaderboard points row
              _FairnessRow(
                emoji: '🏆',
                label: 'লিডারবোর্ড র‍্যাংকিং',
                desc: 'সবার নামাজ সমান গণনা হয় — জামাত বা একাকী যাই হোক',
                bg: _C.blueLight,
                borderColor: _C.blue,
                textColor: const Color(0xFF0C4A6E),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Gender specific explanation
        if (isFemale) _FemaleExplanationBox() else _MaleExplanationBox(),

        const SizedBox(height: 8),

        // Why box
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.border, width: 0.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('⚖️', style: TextStyle(fontSize: 15)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'ইসলামি বিধান অনুযায়ী পুরুষ ও নারীর নামাজের নিয়ম আলাদা। '
                  'তাই র‍্যাংকিংয়ে সবার জন্য সমান সুযোগ নিশ্চিত করা হয়েছে।',
                  style: TextStyle(
                    color: _C.textSec,
                    fontSize: 12,
                    height: 1.55,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FairnessRow extends StatelessWidget {
  final String emoji, label, desc;
  final Color bg, borderColor, textColor;

  const _FairnessRow({
    required this.emoji,
    required this.label,
    required this.desc,
    required this.bg,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: TextStyle(
                    color: textColor.withOpacity(0.75),
                    fontSize: 11.5,
                    height: 1.45,
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

class _MaleExplanationBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _C.goldLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.gold.withOpacity(0.35), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🕌', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text(
                'আপনার জন্য কীভাবে কাজ করে',
                style: TextStyle(
                  color: Color(0xFF78350F),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _CompareRow(
            label: 'জামাতে পড়লে',
            personal: 'বেশি পয়েন্ট ✅',
            leaderboard: 'সমান গণনা',
            personalColor: _C.green,
          ),
          const SizedBox(height: 6),
          _CompareRow(
            label: 'একাকী পড়লে',
            personal: 'কম পয়েন্ট',
            leaderboard: 'সমান গণনা',
            personalColor: _C.amber,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Row(
              children: [
                Text('💡', style: TextStyle(fontSize: 13)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'জামাতে পড়লে ব্যক্তিগত পয়েন্ট বেশি পাবেন, '
                    'কিন্তু র‍্যাংকিংয়ে সবার নামাজ সমান — তাই অন্য আমলেও মনোযোগ দিন।',
                    style: TextStyle(
                      color: Color(0xFF92400E),
                      fontSize: 11.5,
                      height: 1.45,
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

class _FemaleExplanationBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.pink.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🌸', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text(
                'আপনার জন্য কীভাবে কাজ করে',
                style: TextStyle(
                  color: Color(0xFF9D174D),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _ExemptPoint(
              text:
                  'ইসলামে নারীর জন্য ঘরে নামাজ পড়াই উত্তম — জামাত বাধ্যতামূলক নয়'),
          const SizedBox(height: 6),
          _ExemptPoint(
              text:
                  'তাই আপনার নামাজ র‍্যাংকিংয়ে পুরুষের জামাতের সমান পয়েন্ট পাবে'),
          const SizedBox(height: 6),
          _ExemptPoint(text: 'ব্যক্তিগত স্কোরে আপনার আসল পয়েন্টই দেখাবে'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Row(
              children: [
                Text('💡', style: TextStyle(fontSize: 13)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'আপনি ঘরে নামাজ পড়লেও র‍্যাংকিংয়ে কোনো অসুবিধা নেই — '
                    'সবার সাথে সমান প্রতিযোগিতা করতে পারবেন।',
                    style: TextStyle(
                      color: Color(0xFF9D174D),
                      fontSize: 11.5,
                      height: 1.45,
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

class _CompareRow extends StatelessWidget {
  final String label, personal, leaderboard;
  final Color personalColor;

  const _CompareRow({
    required this.label,
    required this.personal,
    required this.leaderboard,
    required this.personalColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF92400E), fontSize: 12),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            personal,
            style: TextStyle(
              color: personalColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            leaderboard,
            style: const TextStyle(
              color: Color(0xFF92400E),
              fontSize: 11.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _Tip {
  final String emoji, text;
  const _Tip({required this.emoji, required this.text});
}
