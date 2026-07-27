import 'package:amal_tracker/features/tracker/models/tracker_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS (shared across all tracker screens)
// ─────────────────────────────────────────────────────────────────────────────

class AmolColors {
  AmolColors._();
  static const pageBg = Color(0xFFF4F6F1);
  static const cardBg = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const midGreen = Color(0xFF1B7045);
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFFFF8E7);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const amber = Color(0xFFFF6B35);
  static const amberLight = Color(0xFFFFF3E0);
  static const purple = Color(0xFF7C3AED);
  static const purpleLight = Color(0xFFEDE9FE);
  static const purplePale = Color(0xFFF3F0FF);
  static const indigo = Color(0xFF4F46E5);
  static const indigoLight = Color(0xFFE0E7FF);
  static const red = Color(0xFFEF4444);
  static const redLight = Color(0xFFFEE2E2);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
  static const border = Color(0xFFE4EAE4);
  static const borderMid = Color(0xFFD0DAD2);
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION META — category.section এর জন্য বাংলা লেবেল + রঙ (UI-only, কোনো
// business/aggregation logic এর সাথে সম্পর্ক নেই, শুধু display grouping)
// ─────────────────────────────────────────────────────────────────────────────

// class AmolSectionMeta {
//   AmolSectionMeta._();

//   static const Map<String, String> _labels = {
//     'salat': 'নামাজ',
//     'quran': 'কুরআন',
//     'dhikr': 'যিকর',
//     'fasting': 'রোজা',
//     'akhlaq': 'আখলাক',
//   };

//   static const Map<String, Color> _colors = {
//     'salat': AmolColors.midGreen,
//     'quran': AmolColors.green,
//     'dhikr': AmolColors.amber,
//     'fasting': AmolColors.gold,
//     'akhlaq': AmolColors.indigo,
//   };

//   static String label(String key) => _labels[key] ?? key;
//   static Color color(String key) => _colors[key] ?? AmolColors.textSecondary;
// }
class AmolSectionMeta {
  AmolSectionMeta._();

  static const List<String> orderedSections = [
    'salat',
    'sunnah_nafl',
    'quran_dhikr',
    'akhlaq',
    'muamalat',
    'weekly_special',
    'fasting_nafl',
    'special_season',
  ];

  static const Map<String, String> _labels = {
    'salat': 'নামাজ',
    'sunnah_nafl': 'সুন্নাত ও নফল',
    'quran_dhikr': 'কুরআন ও যিকর',
    'akhlaq': 'আখলাক',
    'muamalat': 'মুয়ামালাত',
    'weekly_special': 'সাপ্তাহিক আমল',
    'fasting_nafl': 'নফল রোজা',
    'special_season': 'বিশেষ মরশুম',
  };

  static const Map<String, Color> _colors = {
    'salat': AmolColors.midGreen,
    'sunnah_nafl': AmolColors.green,
    'quran_dhikr': AmolColors.amber,
    'akhlaq': AmolColors.indigo,
    'muamalat': AmolColors.darkGreen,
    'weekly_special': AmolColors.purple,
    'fasting_nafl': AmolColors.gold,
    'special_season': AmolColors.red,
  };

  static String label(String key) => _labels[key] ?? key;
  static Color color(String key) => _colors[key] ?? AmolColors.textSecondary;
}

// ─────────────────────────────────────────────────────────────────────────────
// UNIT LABEL — backend enum-স্টাইল unit স্ট্রিং ("rakaat","ayah"...) কে বাংলায়
// অনুবাদ করে। এই ম্যাপে না থাকা যেকোনো নতুন unit ও raw string হিসেবে অন্তত
// readable ভাবে দেখাবে (crash/blank হবে না)।
// ─────────────────────────────────────────────────────────────────────────────

class AmolUnit {
  AmolUnit._();

  static const Map<String, String> _map = {
    'rakaat': 'রাকাত',
    'ayah': 'আয়াত',
    'day': 'দিন',
    'minute': 'মিনিট',
    'time': 'বার',
  };

  static String bn(String? unit) {
    if (unit == null || unit.trim().isEmpty) return '';
    return _map[unit] ?? unit;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AMOL ICON — Material IconData ভিত্তিক, emoji font-এর উপর নির্ভর করে না,
// তাই ডিভাইস/ফন্ট যাই হোক "icon না দেখানো" সমস্যা কখনো হবে না।
// category.section + fard status থেকে নির্ধারিত, তাই নতুন category-তেও
// (কোনো কোড পরিবর্তন ছাড়াই) সঠিক আইকন দেখাবে।
// ─────────────────────────────────────────────────────────────────────────────

class AmolIcon extends StatelessWidget {
  final AmalCategory category;
  final double size;
  final Color? color;
  final Color? background;

  const AmolIcon({
    super.key,
    required this.category,
    this.size = 34,
    this.color,
    this.background,
  });

  bool get _isFardPrayer => category.isFard && category.isPrayer;

  IconData get _icon {
    if (_isFardPrayer) return Icons.mosque_rounded;
    switch (category.section) {
      case 'salat':
        return Icons.nights_stay_rounded; // sunnah/nafl/witr প্রকৃতির নামাজ
      case 'quran':
        return Icons.menu_book_rounded;
      case 'dhikr':
        return Icons.blur_circular_rounded; // তসবিহ-জাতীয়
      case 'fasting':
        return Icons.wb_twilight_rounded;
      case 'akhlaq':
        return Icons.favorite_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  Color get _resolvedColor =>
      color ??
      (_isFardPrayer
          ? AmolColors.purple
          : AmolSectionMeta.color(category.section));

  @override
  Widget build(BuildContext context) {
    final c = _resolvedColor;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background ?? c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(_icon, size: size * 0.52, color: c),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────

class AmolSectionHeader extends StatelessWidget {
  final String title;
  final String emoji;
  final Widget? trailing;
  const AmolSectionHeader(
      {super.key, required this.title, required this.emoji, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 14)),
      const SizedBox(width: 7),
      Expanded(
          child: Text(title,
              style: const TextStyle(
                  color: AmolColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  letterSpacing: -0.2))),
      if (trailing != null) trailing!,
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FILTER CHIP
// ─────────────────────────────────────────────────────────────────────────────

class AmolFilterChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool selected;
  final VoidCallback onTap;
  const AmolFilterChip(
      {super.key,
      required this.label,
      required this.emoji,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AmolColors.darkGreen : AmolColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? AmolColors.darkGreen : AmolColors.border,
              width: 0.8),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(emoji, style: const TextStyle(fontSize: 11)),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  color: selected ? Colors.white : AmolColors.textSecondary,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LEGEND DOT
// ─────────────────────────────────────────────────────────────────────────────

class AmolLegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const AmolLegendDot({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 4),
      Text(label,
          style: const TextStyle(color: AmolColors.textHint, fontSize: 9.5)),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EMPTY / ERROR CARDS
// ─────────────────────────────────────────────────────────────────────────────

class AmolEmptyCard extends StatelessWidget {
  final String label;
  final String emoji;
  const AmolEmptyCard({super.key, required this.label, this.emoji = '📭'});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
          color: AmolColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AmolColors.border, width: 0.5)),
      child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AmolColors.textHint,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
        ),
      ])),
    );
  }
}

class AmolErrorCard extends StatelessWidget {
  final VoidCallback onRetry;
  const AmolErrorCard({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: AmolColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AmolColors.border, width: 0.5)),
      child: Column(children: [
        const Icon(Icons.error_outline_rounded,
            color: AmolColors.red, size: 30),
        const SizedBox(height: 8),
        const Text('ডেটা লোড ব্যর্থ হয়েছে',
            style: TextStyle(
                color: AmolColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14)),
        const SizedBox(height: 12),
        GestureDetector(
            onTap: onRetry,
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                decoration: BoxDecoration(
                    color: AmolColors.greenLight,
                    borderRadius: BorderRadius.circular(10)),
                child: const Text('পুনরায় চেষ্টা করুন',
                    style: TextStyle(
                        color: AmolColors.darkGreen,
                        fontWeight: FontWeight.w700,
                        fontSize: 12)))),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHIMMER BOX — লোডিং স্কেলিটনের জন্য reusable
// ─────────────────────────────────────────────────────────────────────────────

class AmolShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;
  const AmolShimmerBox(
      {super.key, this.width, required this.height, this.radius = 12});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: AmolColors.cardBg,
          borderRadius: BorderRadius.circular(radius)),
    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, colors: [
      AmolColors.cardBg,
      const Color(0xFFE8ECE8),
      AmolColors.cardBg
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NAV ENTRY CARD — মেইন স্ক্রিন থেকে আলাদা page এ যাওয়ার জন্য reusable card
// ─────────────────────────────────────────────────────────────────────────────

class AmolNavEntryCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const AmolNavEntryCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AmolColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AmolColors.border, width: 0.5),
        ),
        child: Row(children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AmolColors.greenLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 17))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AmolColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
                const SizedBox(height: 2),
                Text(subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AmolColors.textHint,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: AmolColors.textHint, size: 20),
        ]),
      ),
    );
  }
}
