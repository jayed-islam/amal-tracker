import 'package:flutter/material.dart';

class SectionMeta {
  final String key;
  final String labelBn;
  final String labelEn;
  final String iconKey;

  const SectionMeta({
    required this.key,
    required this.labelBn,
    required this.labelEn,
    required this.iconKey,
  });

  IconData get icon {
    switch (iconKey) {
      case 'mosque':
        return Icons.mosque_rounded;
      case 'star':
        return Icons.auto_awesome_rounded;
      case 'book':
        return Icons.menu_book_rounded;
      case 'self_improvement':
        return Icons.self_improvement_rounded;
      case 'people':
        return Icons.people_rounded;
      case 'date_range':
        return Icons.date_range_rounded;
      case 'no_food':
        return Icons.no_food_rounded;
      case 'celebration':
        return Icons.celebration_rounded;
      default:
        return Icons.circle_rounded;
    }
  }
}

class AppConstants {
  AppConstants._();

  // ── API ───────────────────────────────────────────────────────────────────
  static const String baseUrl = 'https://amal-tracker-backend.vercel.app/api';
  // static const String baseUrl = 'http://10.0.2.2:5000/api'; // Android emulator
  // static const String baseUrl = 'http://localhost:5000/api'; // iOS simulator

  // ── Storage Keys ──────────────────────────────────────────────────────────
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';

  // ── App ───────────────────────────────────────────────────────────────────
  static const String appName = 'আমল ট্র্যাকার';
  static const String appNameEn = 'Amal Tracker';

  // ── Pagination ────────────────────────────────────────────────────────────
  static const int defaultPageSize = 20;

  // ── Prayer Modes ──────────────────────────────────────────────────────────
  static const String congregationMode = 'congregation';
  static const String soloMode = 'solo';
  static const String missedMode = 'missed';

  // ── Section keys ────────────────────────────────────────────────────────
  static const String sectionSalat = 'salat';
  static const String sectionSunnahNafl = 'sunnah_nafl';
  static const String sectionQuranDhikr = 'quran_dhikr';
  static const String sectionAkhlaq = 'akhlaq';
  static const String sectionMuamalat = 'muamalat';
  static const String sectionWeekly = 'weekly_special';
  static const String sectionFasting = 'fasting_nafl';
  static const String sectionSpecial = 'special_season';

  // ── Durations ─────────────────────────────────────────────────────────────
  static const Duration animationFast = Duration(milliseconds: 250);
  static const Duration animationNormal = Duration(milliseconds: 400);
  static const Duration animationSlow = Duration(milliseconds: 600);
  static const Duration apiTimeout = Duration(seconds: 30);

  // ── Bengali Month Names ───────────────────────────────────────────────────
  static const List<String> bengaliMonths = [
    'জানুয়ারি',
    'ফেব্রুয়ারি',
    'মার্চ',
    'এপ্রিল',
    'মে',
    'জুন',
    'জুলাই',
    'আগস্ট',
    'সেপ্টেম্বর',
    'অক্টোবর',
    'নভেম্বর',
    'ডিসেম্বর',
  ];

  // ── Section metadata list — order matters, UI এই order এ দেখাবে ─────────
  static const List<SectionMeta> sections = [
    SectionMeta(
        key: 'salat',
        labelBn: 'ফরজ নামাজ',
        labelEn: 'Fard Salat',
        iconKey: 'mosque'),
    SectionMeta(
        key: 'sunnah_nafl',
        labelBn: 'সুন্নত ও নফল',
        labelEn: 'Sunnah & Nafl',
        iconKey: 'star'),
    SectionMeta(
        key: 'quran_dhikr',
        labelBn: 'কুরআন ও যিকর',
        labelEn: 'Quran & Dhikr',
        iconKey: 'book'),
    SectionMeta(
        key: 'akhlaq',
        labelBn: 'আখলাক',
        labelEn: 'Akhlaq',
        iconKey: 'self_improvement'),
    SectionMeta(
        key: 'muamalat',
        labelBn: 'মুয়ামালাত',
        labelEn: 'Muamalat',
        iconKey: 'people'),
    SectionMeta(
        key: 'weekly_special',
        labelBn: 'সাপ্তাহিক আমল',
        labelEn: 'Weekly Amal',
        iconKey: 'date_range'),
    SectionMeta(
        key: 'fasting_nafl',
        labelBn: 'নফল রোজা',
        labelEn: 'Nafl Fasting',
        iconKey: 'no_food'),
    SectionMeta(
        key: 'special_season',
        labelBn: 'বিশেষ মৌসুম',
        labelEn: 'Special Season',
        iconKey: 'celebration'),
  ];

  static Map<String, Map<String, String>> get sectionLabels => {
        for (final s in sections) s.key: {'en': s.labelEn, 'bn': s.labelBn}
      };

  // ── Section Labels ────────────────────────────────────────────────────────
  // static const Map<String, Map<String, String>> sectionLabels = {
  //   'salat': {'en': 'Salat', 'bn': 'সালাত ট্র্যাকার'},
  //   'sunnah_nafl': {'en': 'Sunnah & Nafl', 'bn': 'সুন্নাহ ও নফল সালাত'},
  //   'dhikr_tilawat': {'en': 'Dhikr & Tilawat', 'bn': 'জিকর ও তিলাওয়াত'},
  //   'daily_habits': {'en': 'Daily Habits', 'bn': 'দৈনিক অভ্যাস'},
  //   'weekly': {'en': 'Weekly Amal', 'bn': 'সাপ্তাহিক আমল'},
  //   'special_dhulhijja': {'en': 'Dhul Hijja Special', 'bn': 'জিলহজ মাসের আমল'},
  //   'social': {'en': 'Social Amal', 'bn': 'সামাজিক আমল'},
  // };
}
