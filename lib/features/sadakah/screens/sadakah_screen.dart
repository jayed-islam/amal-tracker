// ─────────────────────────────────────────────────────────────────────────────
// SADAQAH BANNER + BOTTOM SHEET
// Place _SadaqahBanner in the SliverChildListDelegate, just before _HowItWorks
// ─────────────────────────────────────────────────────────────────────────────
//
// Usage in HomeScreen build():
//
//   const SizedBox(height: 10),
//   _SadaqahBanner().animate().fadeIn(delay: 190.ms),
//   const SizedBox(height: 20),
//   _HowItWorks(...),
//
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amal_tracker/core/theme/app_colors.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

// ── Re-use the same design tokens from home_screen.dart ──────────────────────
// (copy _C and _fmt into this file if you extract it; otherwise keep inline)
// ─────────────────────────────────────────────────────────────────────────────
// SADAQAH BANNER  (subtle, non-intrusive)
// ─────────────────────────────────────────────────────────────────────────────

class SadaqahBanner extends StatelessWidget {
  const SadaqahBanner();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSadaqahSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          // Warm gold gradient — distinct from the green hero, softer feel
          gradient: LinearGradient(
            colors: [context.colors.goldLight, Color(0xFFFFF3D0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.colors.goldBorder2, width: 0.8),
        ),
        child: Row(children: [
          // Icon container — small, warm
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: context.colors.gold.withOpacity(0.18),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.colors.gold.withOpacity(0.35), width: 0.5),
            ),
            child: const Center(
              child: Text('🤲', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 10),

          // Text
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'সদকাহ করুন',
                  style: TextStyle(
                    color: Color(0xFF7A4500),
                    fontWeight: FontWeight.w800,
                    fontSize: 12.5,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'আল্লাহর রাস্তায় ব্যয় করুন — কোনো শর্ত নেই',
                  style: TextStyle(
                    color: Color(0xFFB07020),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Chevron
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: context.colors.gold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.volunteer_activism_rounded,
              color: Color(0xFFB07020),
              size: 14,
            ),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHOW SADAQAH SHEET
// ─────────────────────────────────────────────────────────────────────────────

void _showSadaqahSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _SadaqahSheet(),
  );
}

// Public alias so HomeScreen can call it
void showSadaqahSheet(BuildContext context) => _showSadaqahSheet(context);

// ─────────────────────────────────────────────────────────────────────────────
// SADAQAH BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _SadaqahSheet extends StatefulWidget {
  const _SadaqahSheet();

  @override
  State<_SadaqahSheet> createState() => _SadaqahSheetState();
}

class _SadaqahSheetState extends State<_SadaqahSheet> {
  String? _copiedKey;

  void _copy(String key, String value) {
    Clipboard.setData(ClipboardData(text: value));
    setState(() => _copiedKey = key);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copiedKey = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ───────────────────────────────────────────────
          const SizedBox(height: 10),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: context.colors.border,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 16),

          // ── Header ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF3D0), Color(0xFFFFF0C0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: context.colors.goldBorder2, width: 0.8),
                  ),
                  child: const Center(
                      child: Text('🤲', style: TextStyle(fontSize: 20))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'সদকাহ করুন',
                        style: TextStyle(
                          color: context.colors.textPri,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          letterSpacing: -0.4,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Sabeq অ্যাপের জন্য স্বেচ্ছামূলক সহায়তা',
                        style: TextStyle(
                          color: context.colors.textSec2,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Info notice ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBBF7D0), width: 0.8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('✅', style: TextStyle(fontSize: 11)),
                      SizedBox(width: 6),
                      Text(
                        'কিছু জানা দরকার',
                        style: TextStyle(
                          color: Color(0xFF166534),
                          fontWeight: FontWeight.w700,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  _InfoPoint(
                    emoji: '🕌',
                    text: 'শুধুমাত্র হালাল উপায়ে অর্জিত সম্পদ থেকে সদকাহ করুন',
                  ),
                  SizedBox(height: 5),
                  _InfoPoint(
                    emoji: '📄',
                    text: 'কোনো রসিদ বা ডকুমেন্ট প্রদান করা হয় না',
                  ),
                  SizedBox(height: 5),
                  _InfoPoint(
                    emoji: '🔄',
                    text: 'পাঠানো টাকা ফেরত দেওয়া সম্ভব নয়',
                  ),
                  SizedBox(height: 5),
                  _InfoPoint(
                    emoji: '💡',
                    text:
                        'এটি দান নয় — আপনার ইচ্ছামতো সদকাহ, কোনো বাধ্যবাধকতা নেই',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ── Section label ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              const Text('💳', style: TextStyle(fontSize: 11)),
              const SizedBox(width: 6),
              Text(
                'পাঠানোর মাধ্যম',
                style: TextStyle(
                  color: context.colors.textSec2,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ]),
          ),

          const SizedBox(height: 8),

          // ── Payment rows ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: context.colors.pageBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.colors.border, width: 0.5),
              ),
              child: Column(children: [
                _PayRow(
                  icon: '🏦',
                  label: 'ইসলামী ব্যাংক',
                  sublabel: 'অ্যাকাউন্ট নম্বর',
                  value: '2070168010100', // ← আপনার আসল নম্বর দিন
                  copiedKey: _copiedKey,
                  copyKey: 'islamic',
                  onCopy: _copy,
                  isFirst: true,
                ),
                Divider(
                    height: 1, color: context.colors.border, indent: 14, endIndent: 14),
                _PayRow(
                  icon: '🩷',
                  label: 'bKash',
                  sublabel: 'Send Money',
                  value: '01XXXXXXXXX', // ← আপনার bKash নম্বর
                  copiedKey: _copiedKey,
                  copyKey: 'bkash',
                  onCopy: _copy,
                ),
                Divider(
                    height: 1, color: context.colors.border, indent: 14, endIndent: 14),
                _PayRow(
                  icon: '🟠',
                  label: 'Nagad',
                  sublabel: 'Send Money',
                  value: '01XXXXXXXXX', // ← আপনার Nagad নম্বর
                  copiedKey: _copiedKey,
                  copyKey: 'nagad',
                  onCopy: _copy,
                  isLast: true,
                ),
              ]),
            ),
          ),

          // ── Dua line ──────────────────────────────────────────────────
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                '«مَنْ ذَا الَّذِي يُقْرِضُ اللَّهَ قَرْضًا حَسَنًا»',
                style: TextStyle(
                  color: context.colors.textHint,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                'আল্লাহকে উত্তম ঋণ দেওয়ার জন্য কে আছ?  — সূরা বাকারা ২:২৪৫',
                style: TextStyle(
                  color: context.colors.textHint.withOpacity(0.75),
                  fontSize: 9.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          SizedBox(height: 16 + bottom),
        ],
      ),
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
          style: const TextStyle(
            color: Color(0xFF166534),
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
        // Icon badge
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: context.colors.border, width: 0.5),
          ),
          child:
              Center(child: Text(icon, style: const TextStyle(fontSize: 16))),
        ),
        const SizedBox(width: 10),

        // Label + value
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
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

        // Copy button
        GestureDetector(
          onTap: () => onCopy(copyKey, value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isCopied ? context.colors.darkGreen : context.colors.greenLight,
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
