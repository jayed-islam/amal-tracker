import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:amal_tracker/core/theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────
String _bnNum(int n) {
  const d = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
  return n.toString().split('').map((c) => d[int.parse(c)]).join();
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD TYPE CONFIG
// ─────────────────────────────────────────────────────────────────────────────
enum _CardType { ayah, hadith, dua, amal }

extension _CardTypeExt on _CardType {
  Color get gradStart => switch (this) {
        _CardType.ayah => AmolColors.midGreen,
        _CardType.hadith => AmolColors.purple,
        _CardType.dua => AmolColors.blue2,
        _CardType.amal => AmolColors.amber3,
      };
  Color get gradEnd => switch (this) {
        _CardType.ayah => const Color(0xFF4ADE80),
        _CardType.hadith => const Color(0xFFA78BFA),
        _CardType.dua => const Color(0xFF38BDF8),
        _CardType.amal => const Color(0xFFFCD34D),
      };
  Color get badgeBg => switch (this) {
        _CardType.ayah => AmolColors.greenLight,
        _CardType.hadith => AmolColors.purpleLight,
        _CardType.dua => AmolColors.blueLight,
        _CardType.amal => AmolColors.amberLight2,
      };
  Color get accentColor => switch (this) {
        _CardType.ayah => AmolColors.midGreen,
        _CardType.hadith => AmolColors.purple,
        _CardType.dua => AmolColors.blue2,
        _CardType.amal => AmolColors.amber3,
      };
  Color get accentBorder => switch (this) {
        _CardType.ayah => AmolColors.greenBorder,
        _CardType.hadith => AmolColors.purpleBorder,
        _CardType.dua => AmolColors.blueBorder,
        _CardType.amal => AmolColors.amberBorder,
      };
  String get badgeLabel => switch (this) {
        _CardType.ayah => '📖  আজকের আয়াত',
        _CardType.hadith => '📜  আজকের হাদিস',
        _CardType.dua => '🤲  মাসনুন দুআ',
        _CardType.amal => '✨  আজকের আমল',
      };
  String get loadingMessage => switch (this) {
        _CardType.ayah => 'আপনার জন্য একটা আয়াত আনা হচ্ছে...',
        _CardType.hadith => 'আপনার জন্য একটা হাদিস খোঁজা হচ্ছে...',
        _CardType.dua => 'মাসনুন দুআ লোড হচ্ছে...',
        _CardType.amal => 'বিশেষ আমল খোঁজা হচ্ছে...',
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// DATA CLASS DEFINITIONS
// ─────────────────────────────────────────────────────────────────────────────
class _AyahData {
  final String arabic, bengali, surahNameBn;
  final int surahNumber, ayahNumber, juzNumber;
  const _AyahData(
      {required this.arabic,
      required this.bengali,
      required this.surahNameBn,
      required this.surahNumber,
      required this.ayahNumber,
      required this.juzNumber});
}

class _HadithData {
  final String arabic, bengali, bookName, narratorBn, grade;
  final int hadithNumber;
  const _HadithData(
      {required this.arabic,
      required this.bengali,
      required this.bookName,
      required this.narratorBn,
      required this.hadithNumber,
      required this.grade});
}

class _DuaData {
  final String arabic, bengali, transliteration, occasion, fadhilah;
  const _DuaData(
      {required this.arabic,
      required this.bengali,
      required this.transliteration,
      required this.occasion,
      required this.fadhilah});
}

class _AmalData {
  final String title, paragraph, fadhilah, contextInfo;
  const _AmalData(
      {required this.title,
      required this.paragraph,
      required this.fadhilah,
      required this.contextInfo});
}

// ─────────────────────────────────────────────────────────────────────────────
// DATA POOLS & FALLBACKS
// ─────────────────────────────────────────────────────────────────────────────
const _ayahFallback = _AyahData(
    arabic: 'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
    bengali: 'নিশ্চয়ই আল্লাহ ধৈর্যশীলদের সাথে আছেন।',
    surahNameBn: 'আল-বাকারা',
    surahNumber: 2,
    ayahNumber: 153,
    juzNumber: 2);
const _ayahPool = [
  45,
  153,
  177,
  255,
  261,
  274,
  286,
  102,
  200,
  2323,
  3996,
  4674,
  4847,
  4618,
  2788,
  5765,
  5766,
  6235,
  6236,
  1,
  7,
  5244,
  183
];
const _bnSurahNames = <int, String>{
  1: 'আল-ফাতিহা',
  2: 'আল-বাকারা',
  3: 'আলে-ইমরান',
  18: 'আল-কাহফ',
  22: 'আল-হাজ্জ',
  31: 'লোকমান',
  39: 'আয-যুমার',
  45: 'আল-জাছিয়া',
  49: 'আল-হুজুরাত',
  67: 'আল-মুলক',
  94: 'আশ-শারহ',
  103: 'আল-আসর'
};

const _hadithFallbacks = [
  _HadithData(
      arabic: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
      bengali:
          'রাসুলুল্লাহ ﷺ বলেছেন: নিশ্চয়ই সকল আমল নিয়তের উপর নির্ভরশীল। প্রত্যেকের জন্য তাই রয়েছে যা সে নিয়ত করেছে।',
      bookName: 'সহিহ বুখারি',
      narratorBn: 'উমর ইবনুল খাত্তাব',
      hadithNumber: 1,
      grade: 'সহিহ'),
  _HadithData(
      arabic:
          'مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلْইَقُلْ خَيْرًا أَوْ لِيَصْمُتْ',
      bengali:
          'রাসুলুল্লাহ ﷺ বলেছেন: যে ব্যক্তি আল্লাহ ও আখেরাতের দিনের প্রতি ঈমান রাখে, সে যেন ভালো কথা বলে অথবা চুপ থাকে।',
      bookName: 'সহিহ বুখারি',
      narratorBn: 'আবু হুরায়রা',
      hadithNumber: 6018,
      grade: 'সহিহ'),
];

const _duas = [
  _DuaData(
      arabic:
          'اللّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ',
      bengali:
          'হে আল্লাহ! তুমিই আমার রব। তুমি ছাড়া কোনো ইলাহ নেই। তুমি আমাকে সৃষ্টি করেছ এবং আমি তোমার বান্দা।',
      transliteration:
          'আল্লাহুম্মা আন্তা রাব্বি লা ইলাহা ইল্লা আন্তা খালাকতানি ওয়া আনা আবদুক',
      occasion: 'সকাল ও সন্ধ্যা',
      fadhilah:
          'সাইয়েদুল ইস্তিগফার। সকালে পড়লে সন্ধ্যার আগে মারা গেলে জান্নাত।'),
  _DuaData(
      arabic:
          'بِسْمِ اللَّهِ الَّذِي لاَ يَضُرُ  مَعَ اسْمِهِ شَيْءٌ فِي الأَرْضِ وَلاَ فِي السَّمَاءِ',
      bengali:
          'আল্লাহর নামে, যাঁর নামের সাথে আসমান ও জমিনে কোনো কিছু ক্ষতি করতে পারে না।',
      transliteration:
          'বিসমিল্লাহিল্লাযি লা ইয়াদুররু মাআসমিহি শাইউন ফিল আরদি ওয়ালা ফিস-সামা',
      occasion: 'সকাল ও সন্ধ্যা',
      fadhilah: 'তিনবার পড়লে হঠাৎ বিপদ থেকে হেফাজত। (আবু দাউদ)'),
];

// মডার্ন প্যারাগ্রাফ বেসড আমল পুল (ইউজার ফ্রেন্ডলি ও রিফ্রেশেবল)
const _amalPool = [
  _AmalData(
      title: 'তাহাজ্জুদ সালাত আদায়',
      paragraph:
          'রাতের শেষ তৃতীয়াংশে ঘুম থেকে উঠে অন্তত ২ রাকাত নফল সালাত আদায় করুন। এটি বান্দাকে আল্লাহর সবচেয়ে নিকটে নিয়ে যায় এবং দুআ কবুলের শ্রেষ্ঠ সময়।',
      fadhilah:
          'ফরয সালাতের পর এটিই আল্লাহর কাছে সর্বোত্তম সালাত। (সহিহ মুসলিম)',
      contextInfo: 'রাতের শেষভাগ'),
  _AmalData(
      title: 'সালাতুদ-দোহা (চাশতের নামায)',
      paragraph:
          'সূর্যোদয়ের আনুমানিক ৪৫ মিনিট পর থেকে যোহরের ওয়াক্ত শুরু হওয়ার পূর্ব পর্যন্ত সময়ের মধ্যে ২ বা ৪ রাকাত নফল সালাত আদায় করুন।',
      fadhilah:
          'এটি শরীরের প্রতিটি জোড়ের (Joints) দৈনিক সদকা হিসেবে গণ্য হয়। (সহিহ মুসলিম)',
      contextInfo: 'পূর্বাহ্ণ / সকাল'),
  _AmalData(
      title: '১০০ বার ইস্তিগফার পাঠ',
      paragraph:
          'আজকের দিনে অবসর সময়ে বা জিকিরের নিয়তে অন্তত ১০০ বার "আস্তাগফিরুল্লাহ" পাঠ করুন। এটি মানসিক প্রশান্তি আনে ও গুনাহ মাফ করে।',
      fadhilah:
          'রাসুলুল্লাহ ﷺ নিষ্পাপ হওয়া সত্ত্বেও দৈনিক ৭০ থেকে ১০০ বার তাওবা করতেন। (সহিহ বুখারি)',
      contextInfo: 'সারাদিন'),
  _AmalData(
      title: 'কুরআন তিলাওয়াত (কমপক্ষে ১ পৃষ্ঠা)',
      paragraph:
          'অর্থসহ অথবা শুধুমাত্র তিলাওয়াতের উদ্দেশ্যে আল্লাহর কিতাব থেকে অন্তত এক পৃষ্ঠা পাঠ করুন। প্রতিটি হরফে মিলবে অফুরন্ত সওয়াব।',
      fadhilah:
          'কুরআনের প্রতিটি হরফ পাঠের বিনিময়ে ১০টি করে নেকি দেওয়া হয়। (জামে তিরমিযি)',
      contextInfo: 'যেকোনো সময়'),
  _AmalData(
      title: 'দরুদ ইব্রাহিম পাঠ',
      paragraph:
          'নামাজে যে দরুদ পড়ি, সেটি অন্তত ১০ বার বা তার বেশি পাঠ করুন। এটি আপনার উপর আল্লাহর বিশেষ রহমত ও রাসুল ﷺ এর শাফায়াত নিশ্চিত করবে।',
      fadhilah:
          'যে ব্যক্তি নবীজির উপর ১ বার দরুদ পাঠাবে, আল্লাহ তার উপর ১০টি রহমত নাযিল করবেন। (সহিহ মুসলিম)',
      contextInfo: 'সারাদিন'),
];

// ─────────────────────────────────────────────────────────────────────────────
// STATE MANAGERS (RIVERPOD NOTIFIERS)
// ─────────────────────────────────────────────────────────────────────────────
class _IndexNotifier extends Notifier<int> {
  final int maxCount;
  _IndexNotifier(this.maxCount);
  @override
  int build() => _pick(-1);
  int _pick(int ex) {
    final r = Random(DateTime.now().microsecondsSinceEpoch);
    int v;
    do {
      v = r.nextInt(maxCount);
    } while (v == ex && maxCount > 1);
    return v;
  }

  void next() => state = _pick(state);
}

final _ayahIndexProvider = NotifierProvider<_IndexNotifier, int>(
    () => _IndexNotifier(_ayahPool.length));
final _hadithIndexProvider = NotifierProvider<_IndexNotifier, int>(
    () => _IndexNotifier(_hadithFallbacks.length));
final _duaIndexProvider =
    NotifierProvider<_IndexNotifier, int>(() => _IndexNotifier(_duas.length));
final _amalIndexProvider = NotifierProvider<_IndexNotifier, int>(
    () => _IndexNotifier(_amalPool.length));

final _ayahProvider = FutureProvider<_AyahData>((ref) async {
  final idx = _ayahPool[ref.watch(_ayahIndexProvider) % _ayahPool.length];
  try {
    final r = await http
        .get(Uri.parse(
            'https://api.alquran.cloud/v1/ayah/$idx/editions/quran-uthmani,bn.bengali'))
        .timeout(const Duration(seconds: 8));
    if (r.statusCode != 200) return _ayahFallback;
    final data = (jsonDecode(r.body)['data'] as List);
    final ar = data[0] as Map<String, dynamic>;
    final bn = data[1] as Map<String, dynamic>;
    final sn = (ar['surah']?['number'] as int?) ?? 0;
    return _AyahData(
        arabic: ar['text'] ?? '',
        bengali: bn['text'] ?? '',
        surahNameBn: _bnSurahNames[sn] ?? 'সূরা #$sn',
        surahNumber: sn,
        ayahNumber: (ar['numberInSurah'] as int?) ?? 0,
        juzNumber: (ar['juz'] as int?) ?? 1);
  } catch (_) {
    return _ayahFallback;
  }
});

final _hadithProvider = Provider<_HadithData>(
    (ref) => _hadithFallbacks[ref.watch(_hadithIndexProvider)]);
final _duaProvider =
    Provider<_DuaData>((ref) => _duas[ref.watch(_duaIndexProvider)]);
final _amalProvider =
    Provider<_AmalData>((ref) => _amalPool[ref.watch(_amalIndexProvider)]);

// ─────────────────────────────────────────────────────────────────────────────
// SHELL DESIGN (With Strict Border Edge Protection)
// ─────────────────────────────────────────────────────────────────────────────
class _CardShell extends StatelessWidget {
  final _CardType type;
  final String meta;
  final VoidCallback onRefresh;
  final Widget body;

  const _CardShell(
      {required this.type,
      required this.meta,
      required this.onRefresh,
      required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 272,
      decoration: BoxDecoration(
        color: AmolColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AmolColors.border2, width: .5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 3,
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [type.gradStart, type.gradEnd])),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                          color: type.badgeBg,
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: type.accentBorder, width: .5)),
                      child: Text(type.badgeLabel,
                          style: TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700,
                              color: type.accentColor)),
                    ),
                    const SizedBox(width: 6),
                    Container(width: 1, height: 11, color: AmolColors.borderLight),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(meta,
                          style: const TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w600,
                              color: AmolColors.textHint2),
                          overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: onRefresh,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                            color: AmolColors.chipBg,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: AmolColors.border2, width: .5)),
                        child: const Icon(Icons.refresh_rounded,
                            size: 13, color: AmolColors.textMuted),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  body,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// UNIVERSAL COMPACT LOADER (165px Locked Shape)
// ─────────────────────────────────────────────────────────────────────────────
class _CardSkeleton extends StatelessWidget {
  final _CardType type;
  const _CardSkeleton({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 272,
      height: 165,
      decoration: BoxDecoration(
          color: AmolColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AmolColors.border2, width: .5)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 3,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [type.gradStart, type.gradEnd]))),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(type.loadingMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AmolColors.textMuted))),
                    const SizedBox(height: 12),
                    const LinearProgressIndicator(
                        backgroundColor: AmolColors.borderLight,
                        color: AmolColors.border2,
                        minHeight: 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 500.ms);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DYNAMIC HEIGHT HANDLER CORE (165px Frame Enforcer)
// ─────────────────────────────────────────────────────────────────────────────
class _ExpandableBody extends StatefulWidget {
  final String titleText;
  final String mainText;
  final _CardType type;
  final Widget expandedContent;
  const _ExpandableBody(
      {this.titleText = '',
      required this.mainText,
      required this.type,
      required this.expandedContent});
  @override
  State<_ExpandableBody> createState() => _ExpandableBodyState();
}

class _ExpandableBodyState extends State<_ExpandableBody>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late final AnimationController _ctrl;
  late final Animation<double> _rot;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: 220.ms);
    _rot = Tween<double>(begin: 0, end: .5)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.titleText.isNotEmpty) ...[
          Text(widget.titleText,
              style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: AmolColors.textPri),
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
        ],
        Text(
          widget.mainText,
          maxLines: _open ? null : (widget.titleText.isNotEmpty ? 2 : 3),
          overflow: _open ? TextOverflow.visible : TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AmolColors.textSec,
              height: 1.6),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () {
            setState(() => _open = !_open);
            _open ? _ctrl.forward() : _ctrl.reverse();
          },
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_open ? 'কম দেখুন' : 'আরো জানুন',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: widget.type.accentColor)),
              const SizedBox(width: 2),
              RotationTransition(
                  turns: _rot,
                  child: Icon(Icons.keyboard_arrow_down_rounded,
                      size: 13, color: widget.type.accentColor)),
            ],
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: widget.expandedContent),
          crossFadeState:
              _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: 280.ms,
          sizeCurve: Curves.easeInOut,
        ),
      ],
    );

    if (!_open) {
      return SizedBox(
          height: 112, child: cardContent); // Locked standard inside 165px box
    }
    return cardContent;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD 1: AYAH
// ─────────────────────────────────────────────────────────────────────────────
class _AyahCardWidget extends ConsumerWidget {
  const _AyahCardWidget();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(_ayahProvider).when(
          loading: () => const _CardSkeleton(type: _CardType.ayah),
          error: (_, __) => _buildCard(ref, _ayahFallback, 0),
          data: (d) => _buildCard(ref, d, ref.read(_ayahIndexProvider)),
        );
  }

  Widget _buildCard(WidgetRef ref, _AyahData d, int idx) {
    return _CardShell(
      type: _CardType.ayah,
      meta: '${d.surahNameBn} ${_bnNum(d.surahNumber)}:${_bnNum(d.ayahNumber)}',
      onRefresh: () => ref.read(_ayahIndexProvider.notifier).next(),
      body: _ExpandableBody(
          type: _CardType.ayah,
          mainText: d.bengali,
          expandedContent:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _ArabicBlock(text: d.arabic),
            const SizedBox(height: 8),
            Row(children: [
              _MiniChip(label: 'সূরা', value: d.surahNameBn),
              const SizedBox(width: 5),
              _MiniChip(label: 'আয়াত', value: _bnNum(d.ayahNumber))
            ]),
          ])),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD 2: HADITH
// ─────────────────────────────────────────────────────────────────────────────
class _HadithCardWidget extends ConsumerWidget {
  const _HadithCardWidget();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.watch(_hadithProvider);
    return _CardShell(
      type: _CardType.hadith,
      meta: '${d.bookName} · ${_bnNum(d.hadithNumber)}',
      onRefresh: () => ref.read(_hadithIndexProvider.notifier).next(),
      body: _ExpandableBody(
          type: _CardType.hadith,
          mainText: d.bengali,
          expandedContent:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            if (d.arabic.isNotEmpty) ...[
              _ArabicBlock(text: d.arabic),
              const SizedBox(height: 8)
            ],
            _NoteBlock(
                label: 'উৎস ও মান',
                text:
                    '${d.bookName} - হাদিস নম্বর: ${_bnNum(d.hadithNumber)} (${d.grade})',
                color: AmolColors.purple),
          ])),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD 3: DUA
// ─────────────────────────────────────────────────────────────────────────────
class _DuaCardWidget extends ConsumerWidget {
  const _DuaCardWidget();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.watch(_duaProvider);
    return _CardShell(
      type: _CardType.dua,
      meta: d.occasion,
      onRefresh: () => ref.read(_duaIndexProvider.notifier).next(),
      body: _ExpandableBody(
          type: _CardType.dua,
          mainText: d.bengali,
          expandedContent:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _ArabicBlock(text: d.arabic),
            const SizedBox(height: 8),
            _NoteBlock(
                label: 'উচ্চারণ', text: d.transliteration, color: AmolColors.blue2),
            const SizedBox(height: 6),
            _NoteBlock(label: 'ফজিলত', text: d.fadhilah, color: AmolColors.blue2),
          ])),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD 4: AMAL (RE-IMAGINED CLEAN PARAGRAPH DESIGN)
// ─────────────────────────────────────────────────────────────────────────────
class _AmalCardWidget extends ConsumerWidget {
  const _AmalCardWidget();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.watch(_amalProvider);
    return _CardShell(
      type: _CardType.amal,
      meta: d.contextInfo,
      onRefresh: () => ref.read(_amalIndexProvider.notifier).next(),
      body: _ExpandableBody(
        titleText: d.title, // মেইন আমলের নাম বোল্ড আকারে শো করবে
        mainText: d.paragraph, // সহজ প্যারাগ্রাফ ফরম্যাট
        type: _CardType.amal,
        expandedContent: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _NoteBlock(label: 'আমলের ফজিলত', text: d.fadhilah, color: AmolColors.amber3),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COMMON SHARABLE CORE COMPONENTS
// ─────────────────────────────────────────────────────────────────────────────
class _ArabicBlock extends StatelessWidget {
  final String text;
  const _ArabicBlock({required this.text});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
            color: AmolColors.goldBg,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: AmolColors.goldBorder, width: .5)),
        child: Text(text,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: const TextStyle(
                fontSize: 13,
                color: AmolColors.goldText,
                height: 1.8,
                fontWeight: FontWeight.w500)),
      );
}

class _MiniChip extends StatelessWidget {
  final String label, value;
  const _MiniChip({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
              color: AmolColors.chipBg,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: AmolColors.border2, width: .5)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text('$label: ',
                style: const TextStyle(
                    fontSize: 8,
                    color: AmolColors.textMuted,
                    fontWeight: FontWeight.w600)),
            Flexible(
                child: Text(value,
                    style: const TextStyle(
                        fontSize: 9,
                        color: AmolColors.textPri,
                        fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis)),
          ]),
        ),
      );
}

class _NoteBlock extends StatelessWidget {
  final String label, text;
  final Color color;
  const _NoteBlock(
      {required this.label, required this.text, required this.color});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: color.withOpacity(.05),
            borderRadius: BorderRadius.circular(8),
            border: Border(left: BorderSide(color: color, width: 2.5))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: .4)),
          const SizedBox(height: 2),
          Text(text,
              style: const TextStyle(
                  fontSize: 10.5, height: 1.5, color: AmolColors.textSec)),
        ]),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN SECTION WIDGET
// ─────────────────────────────────────────────────────────────────────────────
class DailyCardsSection extends StatelessWidget {
  const DailyCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            const Text('🌿', style: TextStyle(fontSize: 13)),
            const SizedBox(width: 6),
            const Text(
              'দৈনিক ইলম',
              style: TextStyle(
                  color: AmolColors.textPri,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: -.1),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: AmolColors.greenLight,
                  borderRadius: BorderRadius.circular(99)),
              child: const Text('সব দেখুন →',
                  style: TextStyle(
                      color: AmolColors.darkGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.w700)),
            ),
          ]),
        ),
        const SizedBox(height: 10),
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AyahCardWidget(),
              SizedBox(width: 10),
              _HadithCardWidget(),
              SizedBox(width: 10),
              _DuaCardWidget(),
              SizedBox(width: 10),
              _AmalCardWidget(),
            ],
          ),
        ),
      ],
    );
  }
}
