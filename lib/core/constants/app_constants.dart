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

  // ── Amal Sections ─────────────────────────────────────────────────────────
  static const String sectionSalat = 'salat';
  static const String sectionSunnahNafl = 'sunnah_nafl';
  static const String sectionDhikr = 'dhikr_tilawat';
  static const String sectionDailyHabits = 'daily_habits';
  static const String sectionWeekly = 'weekly';
  static const String sectionSpecial = 'special_dhulhijja';
  static const String sectionSocial = 'social';

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

  // ── Section Labels ────────────────────────────────────────────────────────
  static const Map<String, Map<String, String>> sectionLabels = {
    'salat': {'en': 'Salat', 'bn': 'সালাত ট্র্যাকার'},
    'sunnah_nafl': {'en': 'Sunnah & Nafl', 'bn': 'সুন্নাহ ও নফল সালাত'},
    'dhikr_tilawat': {'en': 'Dhikr & Tilawat', 'bn': 'জিকর ও তিলাওয়াত'},
    'daily_habits': {'en': 'Daily Habits', 'bn': 'দৈনিক অভ্যাস'},
    'weekly': {'en': 'Weekly Amal', 'bn': 'সাপ্তাহিক আমল'},
    'special_dhulhijja': {'en': 'Dhul Hijja Special', 'bn': 'জিলহজ মাসের আমল'},
    'social': {'en': 'Social Amal', 'bn': 'সামাজিক আমল'},
  };
}
