import 'package:amal_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─────────────────────────────────────────────────────────────────────────
// SHARED UI ATOMS — challenge ফিচারের নিজস্ব ছোট shared widget সেট। প্রতিটা
// color context.colors (app-wide dark/light-aware token সোর্স) থেকে আসে।
// feature-based আর্কিটেকচার মেনে এগুলো monthly_summary এর AmolXxx widget
// থেকে import না করে এখানে আলাদাভাবে রাখা হয়েছে — কিন্তু visual language
// (shimmer timing, radius, spacing, section header shape, chip shape)
// ইচ্ছাকৃতভাবে home/monthly এর সাথে হুবহু মিলিয়ে বানানো।
// ─────────────────────────────────────────────────────────────────────────

class ChShimmer extends StatelessWidget {
  final Widget child;
  const ChShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child.animate(onPlay: (c) => c.repeat()).shimmer(
      duration: 1300.ms,
      colors: [
        Colors.transparent,
        Colors.white.withOpacity(0.55),
        Colors.transparent,
      ],
    );
  }
}

class ChBone extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color? color;
  const ChBone({
    super.key,
    required this.width,
    required this.height,
    this.radius = 6,
    this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: color ?? context.colors.skelBase,
            borderRadius: BorderRadius.circular(radius)),
      );
}

Color rankColor(BuildContext context, int rank) {
  switch (rank) {
    case 1:
      return context.colors.rankGold;
    case 2:
      return context.colors.rankSilver;
    case 3:
      return context.colors.rankBronze;
    default:
      return context.colors.midGreen;
  }
}

String rankEmoji(int rank) {
  switch (rank) {
    case 1:
      return '🥇';
    case 2:
      return '🥈';
    case 3:
      return '🥉';
    default:
      return '';
  }
}

// ─────────────────────────────────────────────────────────────────────────
// SECTION HEADER — home/monthly এর _SecHead / AmolSectionHeader এর সাথে
// মেলানো: emoji + title (+ ঐচ্ছিক trailing action chip)।
// ─────────────────────────────────────────────────────────────────────────

class ChSectionHeader extends StatelessWidget {
  final String title;
  final String emoji;
  final String? trailingLabel;
  final VoidCallback? onTrailingTap;
  const ChSectionHeader({
    super.key,
    required this.title,
    required this.emoji,
    this.trailingLabel,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) => Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 6),
        Text(title,
            style: TextStyle(
                color: context.colors.textPri,
                fontWeight: FontWeight.w800,
                fontSize: 13,
                letterSpacing: -0.1)),
        const Spacer(),
        if (trailingLabel != null)
          GestureDetector(
            onTap: onTrailingTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: context.colors.greenLight,
                  borderRadius: BorderRadius.circular(99)),
              child: Text(trailingLabel!,
                  style: TextStyle(
                      color: context.colors.darkGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.w700)),
            ),
          ),
      ]);
}

// ─────────────────────────────────────────────────────────────────────────
// FILTER CHIP — AmolFilterChip এর সাথে মেলানো pill-shaped selector।
// ─────────────────────────────────────────────────────────────────────────

class ChFilterChip extends StatelessWidget {
  final String label;
  final String? emoji;
  final bool selected;
  final VoidCallback onTap;
  const ChFilterChip({
    super.key,
    required this.label,
    this.emoji,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? context.colors.darkGreen : context.colors.card,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
              color:
                  selected ? context.colors.darkGreen : context.colors.border,
              width: 0.8),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (emoji != null) ...[
            Text(emoji!, style: const TextStyle(fontSize: 11)),
            const SizedBox(width: 4),
          ],
          Text(label,
              style: TextStyle(
                  color: selected ? Colors.white : context.colors.textSec2,
                  fontSize: 11.5,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600)),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// EMPTY / ERROR STATES — AmolEmptyCard / AmolErrorCard এর সাথে মেলানো।
// ─────────────────────────────────────────────────────────────────────────

class ChEmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String? subtitle;
  const ChEmptyState({
    super.key,
    this.emoji = '🏆',
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colors.border, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.textPri,
                fontWeight: FontWeight.w800,
                fontSize: 14.5,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.colors.textSec2,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: 260.ms);
  }
}

class ChErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  final String? message;
  const ChErrorState({super.key, required this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colors.border, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 36, color: context.colors.textHint),
            const SizedBox(height: 12),
            Text(
              'লোড করা যায়নি',
              style: TextStyle(
                color: context.colors.textPri,
                fontWeight: FontWeight.w800,
                fontSize: 14.5,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 4),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.colors.textHint,
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16, color: Colors.white),
              label: const Text(
                'আবার চেষ্টা করুন',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.darkGreen,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// STAT CHIP (dark hero band এর ভেতরে ব্যবহারের জন্য) — monthly এর
// _HeroChip এর সাথে মেলানো, সাদা টেক্সটের ওপর।
// ─────────────────────────────────────────────────────────────────────────

class ChHeroStat extends StatelessWidget {
  final String value;
  final String label;
  const ChHeroStat({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 21,
                  letterSpacing: -0.5,
                  height: 1)),
          const SizedBox(height: 3),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500)),
        ]),
      );
}
