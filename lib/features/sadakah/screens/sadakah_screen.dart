import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';
import 'package:amal_tracker/core/router/app_router.dart';
import 'package:amal_tracker/features/user/widgets/app_silver_bar.dart';

// ── Re-use the same design tokens from home_screen.dart ──────────────────────
// (copy _C and _fmt into this file if you extract it; otherwise keep inline)
// ─────────────────────────────────────────────────────────────────────────────
// SADAQAH BANNER
// Draws the eye and invites curiosity rather than sitting as a flat static
// card:
//  - the icon badge has a slow, gentle "breathing" pulse
//  - the trailing chevron gives a small periodic nudge (a common, tasteful
//    "tap me" cue)
//  - a faint, infrequent shine sweeps across the gradient
//  - copy references the well-known "up to 700x" multiplier for sadaqah
//    (Surah Al-Baqarah's grain parable, paraphrased — not a verbatim
//    quotation) as a small pill; the full page's hero card picks up this
//    same hook so the banner reads as a teaser for what's on the page
//  - a light press-down scale on tap for tactile feedback
// ─────────────────────────────────────────────────────────────────────────────

class SadaqahBanner extends StatefulWidget {
  const SadaqahBanner({super.key});

  @override
  State<SadaqahBanner> createState() => _SadaqahBannerState();
}

class _SadaqahBannerState extends State<SadaqahBanner> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: () {
        HapticFeedback.selectionClick();
        context.push(AppRoutes.sadaqah);
      },
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [context.colors.goldLight, context.colors.goldLight2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.colors.goldBorder2, width: 0.8),
            boxShadow: [
              BoxShadow(
                color: context.colors.gold.withOpacity(0.10),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(children: [
            Positioned(
              top: -22,
              right: -18,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.gold.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -26,
              left: 40,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.gold.withOpacity(0.06),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              child: Row(children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: context.colors.gold.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: context.colors.gold.withOpacity(0.35),
                        width: 0.5),
                  ),
                  child: const Center(
                    child: Text('🤲', style: TextStyle(fontSize: 16)),
                  ),
                ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                      duration: 1400.ms,
                      curve: Curves.easeInOut,
                      begin: const Offset(1, 1),
                      end: const Offset(1.08, 1.08),
                    ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(
                          'সদকাহ করুন',
                          style: TextStyle(
                            color: context.colors.goldText,
                            fontWeight: FontWeight.w800,
                            fontSize: 12.5,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: context.colors.gold.withOpacity(0.22),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'একসাথে কল্যাণে',
                            style: TextStyle(
                              color: context.colors.goldText,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 2),
                      Text(
                        'একটি ছোট উদ্যোগও ইতিবাচক পরিবর্তনের সূচনা করতে পারে।',
                        style: TextStyle(
                          color: context.colors.ambalText,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.colors.gold,
                  size: 20,
                ).animate(onPlay: (c) => c.repeat(reverse: true)).moveX(
                    duration: 700.ms,
                    curve: Curves.easeInOut,
                    begin: 0,
                    end: 3),
              ]),
            ),
          ]),
        ),
      ),
    ).animate(onPlay: (c) => c.repeat()).shimmer(
          duration: 2200.ms,
          delay: 3200.ms,
          color: Colors.white.withOpacity(0.30),
        );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHOW SADAQAH SHEET
// ─────────────────────────────────────────────────────────────────────────────

// Public alias so HomeScreen or widgets can open the page
void showSadaqahSheet(BuildContext context) {
  context.push(AppRoutes.sadaqah);
}

// ─────────────────────────────────────────────────────────────────────────────
// SADAQAH SCREEN PAGE
// ─────────────────────────────────────────────────────────────────────────────

class SadaqahScreen extends StatefulWidget {
  const SadaqahScreen({super.key});

  @override
  State<SadaqahScreen> createState() => _SadaqahScreenState();
}

class _SadaqahScreenState extends State<SadaqahScreen> {
  final ScrollController _scrollController = ScrollController();
  String? _copiedKey;
  bool _isBankExpanded = false;

  void _copy(String key, String value) {
    Clipboard.setData(ClipboardData(text: value));
    setState(() => _copiedKey = key);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copiedKey = null);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final hPad = isTablet ? (size.width - 600) / 2 + 20.0 : 20.0;

    return Scaffold(
      backgroundColor: context.colors.bg,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          AppSliverBar(
            scrollController: _scrollController,
            title: 'সদকাহ করুন',
            subtitle: 'Sabeq অ্যাপের জন্য স্বেচ্ছামূলক সহায়তা',
            icon: Icons.volunteer_activism_rounded,
            color: context.colors.gold,
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 60),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Hero card ────────────────────────────────────────────
                // Every other detail page in the app opens with a strong
                // gradient "hero" moment (leaderboard's hero band, the
                // profile sheet's header, home's hero card) before getting
                // into the details below. This page used to skip straight
                // to a small green info box with no visual anchor at all —
                // this hero also carries the same "৭০০ গুণ" hook the
                // banner teased, so tapping the banner feels like it leads
                // somewhere, not a topic change.
                // const _SadaqahHero().animate().fadeIn(duration: 280.ms),

                // const SizedBox(height: 20),

                // ── Info notice ──────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  decoration: BoxDecoration(
                    color: context.colors.greenLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: context.colors.green.withOpacity(0.25),
                        width: 0.8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('✅', style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 8),
                          Text(
                            'কিছু জানা দরকার',
                            style: TextStyle(
                              color: context.colors.darkGreen,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const _InfoPoint(
                        emoji: '🕌',
                        text:
                            'শুধুমাত্র হালাল উপায়ে অর্জিত সম্পদ থেকে সদকাহ করুন',
                      ),
                      const SizedBox(height: 6),
                      const _InfoPoint(
                        emoji: '📄',
                        text: 'কোনো রসিদ বা ডকুমেন্ট প্রদান করা হয় না',
                      ),
                      const SizedBox(height: 6),
                      const _InfoPoint(
                        emoji: '🔄',
                        text: 'পাঠানো সম্পদ ফেরত যোগ্য নহে',
                      ),
                      const SizedBox(height: 6),
                      const _InfoPoint(
                        emoji: '💡',
                        text:
                            'এটি দান নয় — আপনার ইচ্ছামতো সদকাহ, কোনো বাধ্যবাধকতা নেই',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Section label — sized/weighted to match section
                // headers used elsewhere in the app (e.g. home screen's
                // "সব দেখুন" section headers), instead of a smaller/lighter
                // one-off style.
                Row(children: [
                  const Text('💳', style: TextStyle(fontSize: 13)),
                  const SizedBox(width: 7),
                  Text(
                    'পাঠানোর মাধ্যম',
                    style: TextStyle(
                      color: context.colors.textPri,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.1,
                    ),
                  ),
                ]),

                const SizedBox(height: 10),

                // ── Payment rows ──────────────────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    color: context.colors.pageBg,
                    borderRadius: BorderRadius.circular(14),
                    border:
                        Border.all(color: context.colors.border, width: 0.5),
                  ),
                  child: Column(children: [
                    _PayRow(
                      icon: '🏦',
                      label: 'ইসলামী ব্যাংক',
                      sublabel: 'ট্যাপ করুন',
                      value: '2070168010100', // ← আপনার আসল নম্বর দিন
                      copiedKey: _copiedKey,
                      copyKey: 'islamic',
                      onCopy: _copy,
                      isFirst: true,
                      showExpandIcon: true,
                      isExpanded: _isBankExpanded,
                      onTap: () {
                        setState(() {
                          _isBankExpanded = !_isBankExpanded;
                        });
                      },
                    ),
                    if (_isBankExpanded)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        color: context.colors.card,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(height: 8),
                            _BankDetailItem(
                              label: 'হিসাবধারীর নাম / Account Name',
                              value: 'Sabeq App Support',
                              copiedKey: _copiedKey,
                              copyKey: 'bank_holder',
                              onCopy: _copy,
                            ),
                            const Divider(height: 8),
                            _BankDetailItem(
                              label: 'ব্যাংক / Bank Name',
                              value: 'ইসলামী ব্যাংক বাংলাদেশ পিএলসি',
                              copiedKey: _copiedKey,
                              copyKey: 'bank_name',
                              onCopy: _copy,
                            ),
                            const Divider(height: 8),
                            _BankDetailItem(
                              label: 'শাখা / Branch',
                              value: 'Corporate Branch, Dhaka',
                              copiedKey: _copiedKey,
                              copyKey: 'bank_branch',
                              onCopy: _copy,
                            ),
                            const Divider(height: 8),
                            _BankDetailItem(
                              label: 'রাউটিং নম্বর / Routing Number',
                              value: '125XXXXXXXX',
                              copiedKey: _copiedKey,
                              copyKey: 'bank_routing',
                              onCopy: _copy,
                            ),
                            const Divider(height: 8),
                            _BankDetailItem(
                              label: 'সুইফট কোড / SWIFT Code',
                              value: 'IBBLBDDHXXX',
                              copiedKey: _copiedKey,
                              copyKey: 'bank_swift',
                              onCopy: _copy,
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () {
                                final allDetails = '''
ব্যাংক: ইসলামী ব্যাংক বাংলাদেশ পিএলসি
হিসাবধারীর নাম: Sabeq App Support
হিসাব নম্বর: 2070168010100
শাখা: Corporate Branch, Dhaka
রাউটিং নম্বর: 125XXXXXXXX
সুইফট কোড: IBBLBDDHXXX
'''
                                    .trim();
                                _copy('bank_all', allDetails);
                              },
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: _copiedKey == 'bank_all'
                                      ? context.colors.darkGreen
                                      : context.colors.greenLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _copiedKey == 'bank_all'
                                          ? Icons.check_rounded
                                          : Icons.copy_all_rounded,
                                      size: 14,
                                      color: _copiedKey == 'bank_all'
                                          ? Colors.white
                                          : context.colors.darkGreen,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _copiedKey == 'bank_all'
                                          ? 'সব তথ্য কপি হয়েছে'
                                          : 'সব তথ্য একসাথে কপি করুন',
                                      style: TextStyle(
                                        color: _copiedKey == 'bank_all'
                                            ? Colors.white
                                            : context.colors.darkGreen,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 180.ms)
                          .slideY(begin: -0.02, end: 0),
                    // Divider(
                    //     height: 1,
                    //     color: context.colors.border,
                    //     indent: 14,
                    //     endIndent: 14),
                    // _PayRow(
                    //   icon: '🩷',
                    //   label: 'bKash',
                    //   sublabel: 'Send Money',
                    //   value: '01XXXXXXXXX',
                    //   copiedKey: _copiedKey,
                    //   copyKey: 'bkash',
                    //   onCopy: _copy,
                    // ),
                    // Divider(
                    //     height: 1,
                    //     color: context.colors.border,
                    //     indent: 14,
                    //     endIndent: 14),
                    // _PayRow(
                    //   icon: '🟠',
                    //   label: 'Nagad',
                    //   sublabel: 'Send Money',
                    //   value: '01XXXXXXXXX',
                    //   copiedKey: _copiedKey,
                    //   copyKey: 'nagad',
                    //   onCopy: _copy,
                    //   isLast: true,
                    // ),
                  ]),
                ),

                const SizedBox(height: 24),

                // ── Dua card — wrapped in the same "inspiration card"
                // pattern used elsewhere (gold-tinted card with a border)
                // instead of plain text floating on the page background.
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colors.goldLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: context.colors.gold.withOpacity(0.25),
                        width: 0.5),
                  ),
                  child: Column(children: [
                    Text(
                      '«مَنْ ذَا الَّذِي يُقْرِضُ اللَّهَ قَرْضًا حَسَنًا»',
                      style: TextStyle(
                        color: context.colors.goldText,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.3,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'আল্লাহকে উত্তম ঋণ দেওয়ার জন্য কে আছ?  — সূরা বাকারা ২:২৪৫',
                      style: TextStyle(
                        color: context.colors.ambalText,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ]),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SADAQAH HERO CARD
// Same visual grammar as the app's other hero cards: saturated gradient,
// soft decorative circles, icon badge + headline. Gold rather than green
// deliberately — the app already uses gold specifically for
// spiritual/inspirational content (Arabic verse blocks, virtue boxes, the
// tasbih counter), so this keeps that color meaning consistent rather than
// reusing the green that means "tracking/achievement" elsewhere.
// ─────────────────────────────────────────────────────────────────────────────

class _SadaqahHero extends StatelessWidget {
  const _SadaqahHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colors.gold, context.colors.gold.withOpacity(0.78)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: context.colors.gold.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(children: [
        Positioned(
          top: -40,
          right: -40,
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
        ),
        Positioned(
          bottom: -22,
          left: 16,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.06),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.3), width: 1.5),
                ),
                child: const Center(
                    child: Text('🤲', style: TextStyle(fontSize: 24))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'আল্লাহর রাস্তায় ব্যয় করুন',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '৭০০ গুণ পর্যন্ত সওয়াব',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 14),
            Text(
              'সদকাহ কখনো সম্পদ কমায় না, বরং তা বৃদ্ধি করে। ছোট হোক বা বড়, প্রতিটি দান আল্লাহর কাছে মূল্যবান।',
              style: TextStyle(
                color: Colors.white.withOpacity(0.92),
                fontSize: 12.5,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SUB-WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _InfoPoint extends StatelessWidget {
  final String emoji, text;
  const _InfoPoint({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 10)),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            color: context.colors.darkGreen,
            fontSize: 10.5,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ]);
  }
}

class _PayRow extends StatelessWidget {
  final String icon, label, sublabel, value, copyKey;
  final String? copiedKey;
  final void Function(String key, String value) onCopy;
  final bool isFirst, isLast;
  final bool showExpandIcon;
  final bool isExpanded;
  final VoidCallback? onTap;

  const _PayRow({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.value,
    required this.copyKey,
    required this.copiedKey,
    required this.onCopy,
    this.isFirst = false,
    this.isLast = false,
    this.showExpandIcon = false,
    this.isExpanded = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCopied = copiedKey == copyKey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(14) : Radius.zero,
          bottom: isLast ? const Radius.circular(14) : Radius.zero,
        ),
      ),
      child: Row(children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: context.colors.card,
                    borderRadius: BorderRadius.circular(9),
                    border:
                        Border.all(color: context.colors.border, width: 0.5),
                  ),
                  child: Center(
                      child: Text(icon, style: const TextStyle(fontSize: 16))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(
                            label,
                            style: TextStyle(
                              color: context.colors.textPri,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: context.colors.greenLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              sublabel,
                              style: TextStyle(
                                color: context.colors.darkGreen,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (showExpandIcon) ...[
                            const SizedBox(width: 4),
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              size: 14,
                              color: context.colors.textMuted,
                            ),
                          ],
                        ]),
                        const SizedBox(height: 2),
                        Text(
                          value,
                          style: TextStyle(
                            color: context.colors.textSec2,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => onCopy(copyKey, value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isCopied
                  ? context.colors.darkGreen
                  : context.colors.greenLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(
                isCopied ? Icons.check_rounded : Icons.copy_rounded,
                size: 11,
                color: isCopied ? Colors.white : context.colors.darkGreen,
              ),
              const SizedBox(width: 3),
              Text(
                isCopied ? 'কপি হয়েছে' : 'কপি করুন',
                style: TextStyle(
                  color: isCopied ? Colors.white : context.colors.darkGreen,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _BankDetailItem extends StatelessWidget {
  final String label, value, copyKey;
  final String? copiedKey;
  final void Function(String key, String value) onCopy;

  const _BankDetailItem({
    required this.label,
    required this.value,
    required this.copyKey,
    required this.copiedKey,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final isCopied = copiedKey == copyKey;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: context.colors.textSec2,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: context.colors.textPri,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onCopy(copyKey, value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isCopied
                    ? context.colors.darkGreen
                    : context.colors.greenLight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                isCopied ? Icons.check_rounded : Icons.copy_rounded,
                size: 10,
                color: isCopied ? Colors.white : context.colors.darkGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
