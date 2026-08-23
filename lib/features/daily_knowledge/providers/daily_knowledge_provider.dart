import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

String bnNum(int n) {
  const d = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
  return n.toString().split('').map((c) => d[int.parse(c)]).join();
}

// ─────────────────────────────────────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────────────────────────────────────
class AyahData {
  final String arabic, bengali, surahNameBn;
  final int surahNumber, ayahNumber, juzNumber;
  const AyahData({
    required this.arabic,
    required this.bengali,
    required this.surahNameBn,
    required this.surahNumber,
    required this.ayahNumber,
    required this.juzNumber,
  });
}

class HadithData {
  final String arabic, bengali, bookName, narratorBn, grade;
  final int hadithNumber;
  const HadithData({
    required this.arabic,
    required this.bengali,
    required this.bookName,
    required this.narratorBn,
    required this.hadithNumber,
    required this.grade,
  });
}

class DuaData {
  final String arabic, bengali, transliteration, occasion, fadhilah;
  const DuaData({
    required this.arabic,
    required this.bengali,
    required this.transliteration,
    required this.occasion,
    required this.fadhilah,
  });
}

class AmalData {
  final String title, paragraph, fadhilah;
  const AmalData({
    required this.title,
    required this.paragraph,
    required this.fadhilah,
  });
}

// ── Ayah Fallback ─────────────────────────────────────────────────────────────
const ayahFallback = AyahData(
  arabic: 'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
  bengali: 'নিশ্চয়ই আল্লাহ ধৈর্যশীলদের সাথে আছেন।',
  surahNameBn: 'আল-বাকারা',
  surahNumber: 2,
  ayahNumber: 153,
  juzNumber: 2,
);

const int totalAyahCount = 6236;

const bnSurahNames = <int, String>{
  1: 'আল-ফাতিহা',
  2: 'আল-বাকারা',
  3: 'আলে-ইমরান',
  4: 'আন-নিসা',
  5: 'আল-মায়েদা',
  6: 'আল-আনআম',
  7: 'আল-আরাফ',
  8: 'আল-আনফাল',
  9: 'আত-তাওবা',
  10: 'ইউনুস',
  11: 'হুদ',
  12: 'ইউসুফ',
  13: 'আর-রাদ',
  14: 'ইব্রাহিম',
  15: 'আল-হিজর',
  16: 'আন-নাহল',
  17: 'আল-ইসরা',
  18: 'আল-কাহফ',
  19: 'মারইয়াম',
  20: 'ত্বা-হা',
  21: 'আল-আম্বিয়া',
  22: 'আল-হাজ্জ',
  23: 'আল-মুমিনূন',
  24: 'আন-নূর',
  25: 'আল-ফুরকান',
  26: 'আশ-শুআরা',
  27: 'আন-নামল',
  28: 'আল-কাসাস',
  29: 'আল-আনকাবুত',
  30: 'আর-রূম',
  31: 'লোকমান',
  32: 'আস-সাজদা',
  33: 'আল-আহযাব',
  34: 'সাবা',
  35: 'ফাতির',
  36: 'ইয়াসিন',
  37: 'আস-সাফফাত',
  38: 'সদ',
  39: 'আয-যুমার',
  40: 'গাফির',
  41: 'হা-মীম আস-সাজদা',
  42: 'আশ-শূরা',
  43: 'আয-যুখরুফ',
  44: 'আদ-দুখান',
  45: 'আল-জাছিয়া',
  46: 'আল-আহকাফ',
  47: 'মুহাম্মদ',
  48: 'আল-ফাতহ',
  49: 'আল-হুজুরাত',
  50: 'ক্বাফ',
  51: 'আয-যারিয়াত',
  52: 'আত-তূর',
  53: 'আন-নাজম',
  54: 'আল-কামার',
  55: 'আর-রাহমান',
  56: 'আল-ওয়াকিয়া',
  57: 'আল-হাদীদ',
  58: 'আল-মুজাদালা',
  59: 'আল-হাশর',
  60: 'আল-মুমতাহিনা',
  61: 'আস-সফ',
  62: 'আল-জুমুআ',
  63: 'আল-মুনাফিকুন',
  64: 'আত-তাগাবুন',
  65: 'আত-তালাক',
  66: 'আত-তাহরীম',
  67: 'আল-মুলক',
  68: 'আল-কলম',
  69: 'আল-হাক্কাহ',
  70: 'আল-মাআরিজ',
  71: 'নূহ',
  72: 'আল-জின்ன',
  73: 'আল-মুযযাম্মিল',
  74: 'আল-মুদ্দাসসির',
  75: 'আল-কিয়ামাহ',
  76: 'আদ-দাহর',
  77: 'আল-মুরসালাত',
  78: 'আন-নাবা',
  79: 'আন-নাযিআত',
  80: 'আবাসা',
  81: 'আত-তাকভীর',
  82: 'আল-ইনফিতার',
  83: 'আল-মুতাফফিফীন',
  84: 'আল-ইনশিকাক',
  85: 'আল-বুরূজ',
  86: 'আত-তারিক',
  87: 'আল-আ\'লা',
  88: 'আল-গাশিয়াহ',
  89: 'আল-ফজর',
  90: 'আল-বালাদ',
  91: 'আশ-শামস',
  92: 'আল-লাইল',
  93: 'আদ-দুহা',
  94: 'আশ-শারহ',
  95: 'আত-তীন',
  96: 'আল-আলাক',
  97: 'আল-কদর',
  98: 'আল-বাইয়্যিনাহ',
  99: 'আয-যিলযাল',
  100: 'আল-আদিয়াত',
  101: 'আল-কারিয়াহ',
  102: 'আত-তাকাসুর',
  103: 'আল-আসর',
  104: 'আল-হুমাযাহ',
  105: 'আল-ফীল',
  106: 'কুরাইশ',
  107: 'আল-মাউন',
  108: 'আল-কাওসার',
  109: 'আল-কাফিরুন',
  110: 'আন-নাসর',
  111: 'আল-লাহাব',
  112: 'আল-ইখলাস',
  113: 'আল-ফালাক',
  114: 'আন-নাস',
};

// ── Hadith Fallbacks ──────────────────────────────────────────────────────────
const hadithFallbacks = [
  HadithData(
    arabic: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
    bengali:
        'রাসুলুল্লাহ ﷺ বলেছেন: নিশ্চয়ই সকল আমল নিয়তের উপর নির্ভরশীল। প্রত্যেকের জন্য তাই রয়েছে যা সে নিয়ত করেছে।',
    bookName: 'সহিহ বুখারি',
    narratorBn: 'উমর ইবনুল খাত্তাব',
    hadithNumber: 1,
    grade: 'সহিহ',
  ),
  HadithData(
    arabic: 'الدِّينُ النَّصِيحَةُ',
    bengali:
        'রাসুলুল্লাহ ﷺ বলেছেন: দ্বীন হলো কল্যাণকামিতা — আল্লাহর জন্য, তাঁর কিতাবের জন্য, তাঁর রাসুলের জন্য এবং সাধারণ মুসলমানদের জন্য।',
    bookName: 'সহিহ মুসলিম',
    narratorBn: 'তামিম আদ-দারি',
    hadithNumber: 55,
    grade: 'সহিহ',
  ),
];

// ── Duas Pool ─────────────────────────────────────────────────────────────────
const duasPool = [
  DuaData(
    arabic:
        'اللّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ',
    bengali:
        'হে আল্লাহ! তুমিই আমার রব। তুমি ছাড়া কোনো ইলাহ নেই। তুমি আমাকে সৃষ্টি করেছ এবং আমি তোমার বান্দা।',
    transliteration:
        'আল্লাহুম্মা আন্তা রাব্বি লা ইলাহা ইল্লা আন্তা খালাকতানি ওয়া আনা আবদুক',
    occasion: 'সকাল ও সন্ধ্যা',
    fadhilah:
        'সাইয়েদুল ইস্তিগফার। সকালে পড়লে সন্ধ্যার আগে মারা গেলে জান্নাত।',
  ),
  DuaData(
    arabic:
        'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
    bengali:
        'হে আমাদের রব! আমাদের দুনিয়াতে কল্যাণ দান কর এবং আখিরাতেও কল্যাণ দান কর এবং আমাদেরকে জাহান্নামের আজাব থেকে রক্ষা কর।',
    transliteration:
        'রাব্বানা আতিনা ফিদ-দুনিয়া হাসসানাতাও ওয়া ফিল-আখিরাতি হাসসানাতাও ওয়া কিনা আজাবান-নার',
    occasion: 'সব সময় ও দোয়ার শেষে',
    fadhilah: 'কুরআনের সর্বাত্মক কল্যাণ কামনার সুপ্রসিদ্ধ দুআ। (সূরা বাকারা: ২০১)',
  ),
  DuaData(
    arabic: 'رَبِّ اشْرَحْ لِي صَدْرِي * وَيَسِّرْ لِي أَمْرِي',
    bengali:
        'হে আমার রব! আমার বক্ষ প্রশস্ত করে দিন এবং আমার কাজ সহজ করে দিন।',
    transliteration: 'রাব্বিশ-রাহলী সাদরী, ওয়ায়াসসির লী আমরী',
    occasion: 'যেকোনো কাজ বা কথা শুরুর পূর্বে',
    fadhilah:
        'মুসা (আ.) এর দুআ। ভয় দূর করা ও কাজ সহজ করার জন্য অনন্য। (সূরা ত্বাহা: ২৫-২৬)',
  ),
  DuaData(
    arabic: 'يَا مُقَلِّبَ الْقُلُوبِ ثَبِّتْ قَلْبِي عَلَى دِينِكَ',
    bengali:
        'হে অন্তরের পরিবর্তনকারী! আমার অন্তরকে তোমার দ্বীনের ওপর দৃঢ় রাখো।',
    transliteration: 'ইয়া মুকাল্লিবাল কুলূবি সাব্বিত কালবী আলা দ্বীিনিক',
    occasion: 'দৈনন্দিন প্রাত্যহিক দুআ',
    fadhilah: 'রাসুলুল্লাহ ﷺ এই দুআটি খুব বেশি পাঠ করতেন। (তিরমিজি)',
  ),
];

// ── Amal Pool ─────────────────────────────────────────────────────────────────
const amalPool = [
  AmalData(
    title: 'তাহাজ্জুদ সালাত আদায়',
    paragraph:
        'রাতের শেষ তৃতীয়াংশে ঘুম থেকে উঠে অন্তত দুই রাকাত নফল সালাত আদায় করার চেষ্টা করুন। এটি মনকে প্রশান্ত করে এবং এই সময়ে করা আল্লাহর কাছে যেকোনো দুআ দ্রুত কবুল হয়।',
    fadhilah: 'ফরয সালাতের পর এটিই সর্বোত্তম নফল ইবাদত। (সহিহ মুসলিম)',
  ),
  AmalData(
    title: 'সালাতুদ-দোহা বা চাশত',
    paragraph:
        'আজকের কর্মব্যস্ত দিনটি শুরু করার আগে বা সূর্য ওঠার ঠিক ৪৫ মিনিট পর ২ রাকাত চাশতের নামাজ আদায় করে নিন। এটি আপনার সারা দিনের সুরক্ষাকবচ হিসেবে কাজ করবে।',
    fadhilah: 'এটি মানবদেহের প্রতিটি জোড়ের সদকা হিসেবে যথেষ্ট। (সহিহ মুসলিম)',
  ),
  AmalData(
    title: 'দৈনিক ইস্তিগফার (১০০ বার)',
    paragraph:
        'প্রতিদিন অন্তত ১০০ বার "আস্তাগফিরুল্লাহ" পাঠ করুন। চলতে-ফিরতে, কাজের ফাঁকে বা অবসর সময়ে আল্লাহর কাছে ক্ষমা প্রার্থনা করার অভ্যাস গড়ে তুলুন।',
    fadhilah:
        'ইস্তিগফার দুশ্চিন্তা দূর করে, রিজিক বাড়ায় এবং বিপদ থেকে রক্ষা করে। (আবু দাউদ)',
  ),
  AmalData(
    title: 'দরূদ শরীফ পাঠ',
    paragraph:
        'নবী করীম ﷺ-এর ওপর বেশি বেশি দরূদ পাঠ করুন। বিশেষ করে জুমুআর দিনে ও রাতে দরূদ শরীফের গুরুত্ব আরও অনেক বেশি।',
    fadhilah: 'যে ব্যক্তি আমার ওপর একবার দরূদ পড়ে, আল্লাহ তার ওপর ১০টি রহমত নাজিল করেন। (সহিহ মুসলিম)',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// HADITH API CONFIG
// ─────────────────────────────────────────────────────────────────────────────
const List<String> hadithCollections = ['bukhari', 'muslim', 'abudawud'];
const Map<String, int> hadithMaxNumber = {
  'bukhari': 7000,
  'muslim': 7000,
  'abudawud': 5000,
};
const Map<String, String> hadithBookNameBn = {
  'bukhari': 'সহিহ বুখারি',
  'muslim': 'সহিহ মুসলিম',
  'abudawud': 'সুনানে আবু দাউদ',
};
const String hadithApiBase =
    'https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1/editions';

// ─────────────────────────────────────────────────────────────────────────────
// PROVIDERS
// ─────────────────────────────────────────────────────────────────────────────
class IndexNotifier extends Notifier<int> {
  final int maxCount;
  IndexNotifier(this.maxCount);
  @override
  int build() => pick(-1);
  int pick(int ex) {
    final r = Random(DateTime.now().microsecondsSinceEpoch);
    int v;
    do {
      v = r.nextInt(maxCount);
    } while (v == ex && maxCount > 1);
    return v;
  }

  void next() => state = pick(state);
}

final ayahIndexProvider = NotifierProvider<IndexNotifier, int>(
    () => IndexNotifier(totalAyahCount));
final duaIndexProvider =
    NotifierProvider<IndexNotifier, int>(() => IndexNotifier(duasPool.length));
final amalIndexProvider = NotifierProvider<IndexNotifier, int>(
    () => IndexNotifier(amalPool.length));

final ayahProvider = FutureProvider<AyahData>((ref) async {
  final ayahNumber = ref.watch(ayahIndexProvider) + 1; // 1..6236
  try {
    final r = await http
        .get(Uri.parse(
            'https://api.alquran.cloud/v1/ayah/$ayahNumber/editions/quran-uthmani,bn.bengali'))
        .timeout(const Duration(seconds: 8));
    if (r.statusCode != 200) return ayahFallback;
    final data = (jsonDecode(r.body)['data'] as List);
    final ar = data[0] as Map<String, dynamic>;
    final bn = data[1] as Map<String, dynamic>;
    final surahNo = ar['surah']?['number'] as int? ?? 0;
    return AyahData(
      arabic: ar['text'] ?? '',
      bengali: bn['text'] ?? '',
      surahNameBn: bnSurahNames[surahNo] ?? 'সূরা ${bnNum(surahNo)}',
      surahNumber: surahNo,
      ayahNumber: ar['numberInSurah'] ?? 0,
      juzNumber: ar['juz'] ?? 1,
    );
  } catch (_) {
    return ayahFallback;
  }
});

class HadithSeed {
  final String collection;
  final int number;
  const HadithSeed(this.collection, this.number);
}

class HadithSeedNotifier extends Notifier<HadithSeed> {
  @override
  HadithSeed build() => pick(null);

  HadithSeed pick(HadithSeed? previous) {
    final r = Random(DateTime.now().microsecondsSinceEpoch);
    HadithSeed seed;
    do {
      final collection =
          hadithCollections[r.nextInt(hadithCollections.length)];
      final number = r.nextInt(hadithMaxNumber[collection]!) + 1;
      seed = HadithSeed(collection, number);
    } while (previous != null &&
        seed.collection == previous.collection &&
        seed.number == previous.number);
    return seed;
  }

  void next() => state = pick(state);
}

final hadithSeedProvider =
    NotifierProvider<HadithSeedNotifier, HadithSeed>(HadithSeedNotifier.new);

Future<HadithData?> fetchHadithOnce(String collection, int number) async {
  final bnUri = Uri.parse('$hadithApiBase/ben-$collection/$number.json');
  final bnRes = await http.get(bnUri).timeout(const Duration(seconds: 8));

  if (bnRes.statusCode == 404) return null;
  if (bnRes.statusCode != 200) {
    throw Exception('hadith fetch failed: ${bnRes.statusCode}');
  }

  final decoded = jsonDecode(bnRes.body) as Map<String, dynamic>;
  final hadith = decoded['hadiths'] as Map<String, dynamic>?;
  final bnText = (hadith?['text'] as String?)?.trim();
  if (bnText == null || bnText.isEmpty) return null;

  String arabic = '';
  try {
    final arUri = Uri.parse('$hadithApiBase/ara-$collection/$number.json');
    final arRes = await http.get(arUri).timeout(const Duration(seconds: 8));
    if (arRes.statusCode == 200) {
      final arDecoded = jsonDecode(arRes.body) as Map<String, dynamic>;
      final arHadith = arDecoded['hadiths'] as Map<String, dynamic>?;
      arabic = (arHadith?['text'] as String?)?.trim() ?? '';
    }
  } catch (_) {}

  return HadithData(
    arabic: arabic,
    bengali: bnText,
    bookName: hadithBookNameBn[collection] ?? collection,
    narratorBn: '',
    hadithNumber: number,
    grade: 'সহিহ',
  );
}

final hadithProvider = FutureProvider<HadithData>((ref) async {
  final seed = ref.watch(hadithSeedProvider);
  var collection = seed.collection;
  var number = seed.number;
  final r = Random();

  for (var attempt = 0; attempt < 3; attempt++) {
    try {
      final data = await fetchHadithOnce(collection, number);
      if (data != null) return data;
    } catch (_) {
      break;
    }
    collection = hadithCollections[r.nextInt(hadithCollections.length)];
    number = r.nextInt(hadithMaxNumber[collection]!) + 1;
  }

  return hadithFallbacks[Random().nextInt(hadithFallbacks.length)];
});

final duaProvider = Provider<DuaData>(
    (ref) => duasPool[ref.watch(duaIndexProvider) % duasPool.length]);
final amalProvider = Provider<AmalData>(
    (ref) => amalPool[ref.watch(amalIndexProvider) % amalPool.length]);
