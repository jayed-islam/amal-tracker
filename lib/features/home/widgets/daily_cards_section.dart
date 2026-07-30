import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:amal_tracker/core/theme/app_colors.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

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
  Color gradStart(BuildContext context) => switch (this) {
        _CardType.ayah => context.colors.midGreen,
        _CardType.hadith => context.colors.purple,
        _CardType.dua => context.colors.blue2,
        _CardType.amal => context.colors.amber3,
      };
  Color get gradEnd => switch (this) {
        _CardType.ayah => const Color(0xFF4ADE80),
        _CardType.hadith => const Color(0xFFA78BFA),
        _CardType.dua => const Color(0xFF38BDF8),
        _CardType.amal => const Color(0xFFFCD34D),
      };
  Color badgeBg(BuildContext context) => switch (this) {
        _CardType.ayah => context.colors.greenLight,
        _CardType.hadith => context.colors.purpleLight,
        _CardType.dua => context.colors.blueLight,
        _CardType.amal => context.colors.amberLight2,
      };
  Color accentColor(BuildContext context) => switch (this) {
        _CardType.ayah => context.colors.midGreen,
        _CardType.hadith => context.colors.purple,
        _CardType.dua => context.colors.blue2,
        _CardType.amal => context.colors.amber3,
      };
  Color accentBorder(BuildContext context) => switch (this) {
        _CardType.ayah => context.colors.greenBorder,
        _CardType.hadith => context.colors.purpleBorder,
        _CardType.dua => context.colors.blueBorder,
        _CardType.amal => context.colors.amberBorder,
      };
  String get badgeLabel => switch (this) {
        _CardType.ayah => '📖  আজকের আয়াত',
        _CardType.hadith => '📜  আজকের হাদিস',
        _CardType.dua => '🤲  মাসনুন দুআ',
        _CardType.amal => '✨  আজকের আমল',
      };
  String get loadingMessage => switch (this) {
        _CardType.ayah => 'আপনার জন্য একটা আয়াত আনা হচ্ছে...',
        _CardType.hadith => 'আপনার জন্য একটা হাদিস খোঁজা হচ্ছে...',
        _CardType.dua => 'মাসনুন দুআ লোড হচ্ছে...',
        _CardType.amal => 'আসন্ন আমল খোঁজা হচ্ছে...',
      };
  String get actionLabel => switch (this) {
        _CardType.ayah => 'তাফসির পড়ুন',
        _CardType.hadith => 'বিস্তারিত হাদিস',
        _CardType.dua => 'উচ্চারণ ও ফজিলত',
        _CardType.amal => 'আমলের ফজিলত',
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// DATA MODELS & POOLS
// ─────────────────────────────────────────────────────────────────────────────
class _AyahData {
  final String arabic, bengali, surahNameBn;
  final int surahNumber, ayahNumber, juzNumber;
  const _AyahData({
    required this.arabic,
    required this.bengali,
    required this.surahNameBn,
    required this.surahNumber,
    required this.ayahNumber,
    required this.juzNumber,
  });
}

class _HadithData {
  final String arabic, bengali, bookName, narratorBn, grade;
  final int hadithNumber;
  const _HadithData({
    required this.arabic,
    required this.bengali,
    required this.bookName,
    required this.narratorBn,
    required this.hadithNumber,
    required this.grade,
  });
}

class _DuaData {
  final String arabic, bengali, transliteration, occasion, fadhilah;
  const _DuaData({
    required this.arabic,
    required this.bengali,
    required this.transliteration,
    required this.occasion,
    required this.fadhilah,
  });
}

class _AmalData {
  final String title, paragraph, fadhilah;
  const _AmalData({
    required this.title,
    required this.paragraph,
    required this.fadhilah,
  });
}

const _ayahFallback = _AyahData(
  arabic: 'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
  bengali: 'নিশ্চয়ই আল্লাহ ধৈর্যশীলদের সাথে আছেন।',
  surahNameBn: 'আল-বাকারা',
  surahNumber: 2,
  ayahNumber: 153,
  juzNumber: 2,
);
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
  183,
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
  103: 'আল-আসর',
};

const _hadithFallbacks = [
  _HadithData(
    arabic: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
    bengali:
        'রাসুলুল্লাহ ﷺ বলেছেন: নিশ্চয়ই সকল আমল নিয়তের উপর নির্ভরশীল। প্রত্যেকের জন্য তাই রয়েছে যা সে নিয়ত করেছে।',
    bookName: 'সহিহ বুখারি',
    narratorBn: 'উমর ইবনুল খাত্তাব',
    hadithNumber: 1,
    grade: 'সহিহ',
  ),
  _HadithData(
    arabic: 'الدِّينُ النَّصِيحَةُ',
    bengali:
        'রাসুলুল্লাহ ﷺ বলেছেন: দ্বীন হলো কল্যাণকামিতা — আল্লাহর জন্য, তাঁর কিতাবের জন্য, তাঁর রাসুলের জন্য এবং সাধারণ মুসলমানদের জন্য।',
    bookName: 'সহিহ মুসলিম',
    narratorBn: 'তামিম আদ-দারি',
    hadithNumber: 55,
    grade: 'সহিহ',
  ),
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
        'সাইয়েদুল ইস্তিগফার। সকালে পড়লে সন্ধ্যার আগে মারা গেলে জান্নাত।',
  ),
];

const _amalPool = [
  _AmalData(
    title: 'তাহাজ্জুদ সালাত আদায়',
    paragraph:
        'রাতের শেষ তৃতীয়াংশে ঘুম থেকে উঠে অন্তত দুই রাকাত নফল সালাত আদায় করার চেষ্টা করুন। এটি মনকে প্রশান্ত করে এবং এই সময়ে করা আল্লাহর কাছে যেকোনো দুআ দ্রুত কবুল হয়।',
    fadhilah: 'ফরয সালাতের পর এটিই সর্বোত্তম নফল ইবাদত। (সহিহ মুসলিম)',
  ),
  _AmalData(
    title: 'সালাতুদ-দোহা বা চাশত',
    paragraph:
        'আজকের কর্মব্যস্ত দিনটি শুরু করার আগে বা সূর্য ওঠার ঠিক ৪৫ মিনিট পর ২ রাকাত চাশতের নামাজ আদায় করে নিন। এটি আপনার সারা দিনের সুরক্ষাকবচ হিসেবে কাজ করবে।',
    fadhilah: 'এটি মানবদেহের প্রতিটি জোড়ের সদকা হিসেবে যথেষ্ট। (সহিহ মুসলিম)',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// PROVIDERS
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
  final idx = ref.watch(_ayahIndexProvider);
  try {
    final r = await http
        .get(Uri.parse(
            'https://api.alquran.cloud/v1/ayah/$idx/editions/quran-uthmani,bn.bengali'))
        .timeout(const Duration(seconds: 8));
    if (r.statusCode != 200) return _ayahFallback;
    final data = (jsonDecode(r.body)['data'] as List);
    final ar = data[0] as Map<String, dynamic>;
    final bn = data[1] as Map<String, dynamic>;
    return _AyahData(
      arabic: ar['text'] ?? '',
      bengali: bn['text'] ?? '',
      surahNameBn: _bnSurahNames[ar['surah']?['number']] ?? 'সূরা',
      surahNumber: ar['surah']?['number'] ?? 0,
      ayahNumber: ar['numberInSurah'] ?? 0,
      juzNumber: ar['juz'] ?? 1,
    );
  } catch (_) {
    return _ayahFallback;
  }
});

final _hadithProvider = Provider<_HadithData>((ref) => _hadithFallbacks[
    ref.watch(_hadithIndexProvider) % _hadithFallbacks.length]);
final _duaProvider = Provider<_DuaData>(
    (ref) => _duas[ref.watch(_duaIndexProvider) % _duas.length]);
final _amalProvider = Provider<_AmalData>(
    (ref) => _amalPool[ref.watch(_amalIndexProvider) % _amalPool.length]);

// ─────────────────────────────────────────────────────────────────────────────
// MAIN HORIZONTAL SCROLL LIST SECTION
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
            Text(
              'দৈনিক ইলম',
              style: TextStyle(
                color: context.colors.textPri,
                fontWeight: FontWeight.w800,
                fontSize: 13,
                letterSpacing: -.1,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: context.colors.greenLight,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                'সব দেখুন →',
                style: TextStyle(
                  color: context.colors.darkGreen,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
          // crossAxisAlignment.start so cards don't stretch to the tallest sibling
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
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

// ─────────────────────────────────────────────────────────────────────────────
// CARD SHELL
// No static heights anywhere. AnimatedSize handles the smooth grow/shrink.
// ─────────────────────────────────────────────────────────────────────────────
class _CardShell extends StatelessWidget {
  final _CardType type;
  final String meta;
  final VoidCallback onRefresh;
  final Widget body;
  final Widget expandedExtra; // shown only when open
  final bool isOpen;
  final VoidCallback onToggle;

  const _CardShell({
    required this.type,
    required this.meta,
    required this.onRefresh,
    required this.body,
    required this.expandedExtra,
    required this.isOpen,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Container(
        width: 272,
        // No height constraint at all — content drives the size naturally
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.colors.border2, width: .5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.015),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize:
                MainAxisSize.min, // critical: never expand beyond content
            children: [
              // ── Top accent bar ──────────────────────────────────────────────
              Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [type.gradStart(context), type.gradEnd],
                  ),
                ),
              ),

              // ── Header + body ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Badge row
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: type.badgeBg(context),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: type.accentBorder(context), width: .5),
                        ),
                        child: Text(
                          type.badgeLabel,
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            color: type.accentColor(context),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(width: 1, height: 11, color: context.colors.borderLight),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          meta,
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w600,
                            color: context.colors.textHint2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: onRefresh,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: context.colors.chipBg,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: context.colors.border2, width: .5),
                          ),
                          child: Icon(
                            Icons.refresh_rounded,
                            size: 13,
                            color: context.colors.textMuted,
                          ),
                        ),
                      ),
                    ]),

                    const SizedBox(height: 8),

                    // Always-visible body (preview text)
                    body,

                    // Expanded extra — AnimatedSize already handles the outer
                    // container, but we still wrap in a Visibility so the widget
                    // tree stays lean when collapsed.
                    if (isOpen) ...[
                      const SizedBox(height: 8),
                      expandedExtra,
                    ],
                  ],
                ),
              ),

              // ── Divider ─────────────────────────────────────────────────────
              Container(height: .5, color: context.colors.border2.withOpacity(.5)),

              // ── Action bar ──────────────────────────────────────────────────
              Material(
                color: const Color(0xFFFAFBFA),
                child: InkWell(
                  onTap: onToggle,
                  child: SizedBox(
                    height: 25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isOpen ? 'সংক্ষেপ করুন' : type.actionLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: type.accentColor(context),
                          ),
                        ),
                        const SizedBox(width: 2),
                        AnimatedRotation(
                          turns: isOpen ? .5 : 0,
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeInOut,
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 16,
                            color: type.accentColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SKELETON LOADER
// ─────────────────────────────────────────────────────────────────────────────
class _CardSkeleton extends StatelessWidget {
  final _CardType type;
  const _CardSkeleton({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 272,
      height: 125,
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.border2, width: .5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [type.gradStart(context), type.gradEnd],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        type.loadingMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      backgroundColor: context.colors.borderLight,
                      color: context.colors.border2,
                      minHeight: 2,
                    ),
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
// PREVIEW BODY  (always visible — just text, no height constraints)
// ─────────────────────────────────────────────────────────────────────────────

/// Plain bengali text shown in collapsed state (3 lines max).
/// When open the shell inserts expandedExtra below, so this widget
/// never needs to know about open/closed state.
class _PreviewText extends StatelessWidget {
  final String title;
  final String text;
  final bool isOpen;

  const _PreviewText({
    this.title = '',
    required this.text,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: context.colors.textPri,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
        ],
        Text(
          text,
          // collapsed → 2-3 lines preview; open → full text
          maxLines: isOpen ? null : (title.isNotEmpty ? 2 : 3),
          overflow: isOpen ? TextOverflow.visible : TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: context.colors.textSec,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD IMPLEMENTATIONS
// ─────────────────────────────────────────────────────────────────────────────
class _AyahCardWidget extends ConsumerStatefulWidget {
  const _AyahCardWidget();
  @override
  ConsumerState<_AyahCardWidget> createState() => _AyahCardWidgetState();
}

class _AyahCardWidgetState extends ConsumerState<_AyahCardWidget> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return ref.watch(_ayahProvider).when(
          loading: () => const _CardSkeleton(type: _CardType.ayah),
          error: (_, __) => const SizedBox.shrink(),
          data: (d) => _CardShell(
            type: _CardType.ayah,
            isOpen: _open,
            onToggle: () => setState(() => _open = !_open),
            meta:
                '${d.surahNameBn} ${_bnNum(d.surahNumber)}:${_bnNum(d.ayahNumber)}',
            onRefresh: () => ref.read(_ayahIndexProvider.notifier).next(),
            body: _PreviewText(text: d.bengali, isOpen: _open),
            expandedExtra: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _ArabicBlock(text: d.arabic),
                const SizedBox(height: 6),
                Row(children: [
                  _MiniChip(label: 'সূরা', value: d.surahNameBn),
                  const SizedBox(width: 5),
                  _MiniChip(label: 'আয়াত', value: _bnNum(d.ayahNumber)),
                ]),
              ],
            ),
          ),
        );
  }
}

class _HadithCardWidget extends ConsumerStatefulWidget {
  const _HadithCardWidget();
  @override
  ConsumerState<_HadithCardWidget> createState() => _HadithCardWidgetState();
}

class _HadithCardWidgetState extends ConsumerState<_HadithCardWidget> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final d = ref.watch(_hadithProvider);
    return _CardShell(
      type: _CardType.hadith,
      isOpen: _open,
      onToggle: () => setState(() => _open = !_open),
      meta: '${d.bookName} · ${_bnNum(d.hadithNumber)}',
      onRefresh: () => ref.read(_hadithIndexProvider.notifier).next(),
      body: _PreviewText(text: d.bengali, isOpen: _open),
      expandedExtra: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (d.arabic.isNotEmpty) ...[
            _ArabicBlock(text: d.arabic),
            const SizedBox(height: 6),
          ],
          _NoteBlock(
            label: 'উৎস ও মান',
            text: '${d.bookName} (${d.grade})',
            color: context.colors.purple,
          ),
        ],
      ),
    );
  }
}

class _DuaCardWidget extends ConsumerStatefulWidget {
  const _DuaCardWidget();
  @override
  ConsumerState<_DuaCardWidget> createState() => _DuaCardWidgetState();
}

class _DuaCardWidgetState extends ConsumerState<_DuaCardWidget> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final d = ref.watch(_duaProvider);
    return _CardShell(
      type: _CardType.dua,
      isOpen: _open,
      onToggle: () => setState(() => _open = !_open),
      meta: d.occasion,
      onRefresh: () => ref.read(_duaIndexProvider.notifier).next(),
      body: _PreviewText(text: d.bengali, isOpen: _open),
      expandedExtra: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _ArabicBlock(text: d.arabic),
          const SizedBox(height: 6),
          _NoteBlock(label: 'উচ্চারণ', text: d.transliteration, color: context.colors.blue2),
          const SizedBox(height: 5),
          _NoteBlock(label: 'ফজিলত', text: d.fadhilah, color: context.colors.blue2),
        ],
      ),
    );
  }
}

class _AmalCardWidget extends ConsumerStatefulWidget {
  const _AmalCardWidget();
  @override
  ConsumerState<_AmalCardWidget> createState() => _AmalCardWidgetState();
}

class _AmalCardWidgetState extends ConsumerState<_AmalCardWidget> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final d = ref.watch(_amalProvider);
    return _CardShell(
      type: _CardType.amal,
      isOpen: _open,
      onToggle: () => setState(() => _open = !_open),
      meta: 'আসন্ন আমল',
      onRefresh: () => ref.read(_amalIndexProvider.notifier).next(),
      body: _PreviewText(title: d.title, text: d.paragraph, isOpen: _open),
      expandedExtra: _NoteBlock(
        label: 'আমলের ফজিলত',
        text: d.fadhilah,
        color: context.colors.amber3,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE CHIPS & BLOCKS
// ─────────────────────────────────────────────────────────────────────────────
class _ArabicBlock extends StatelessWidget {
  final String text;
  const _ArabicBlock({required this.text});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: context.colors.goldBg,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: context.colors.goldBorder, width: .5),
        ),
        child: Text(
          text,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 13,
            color: context.colors.goldText,
            height: 1.8,
            fontWeight: FontWeight.w500,
          ),
        ),
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
            color: context.colors.chipBg,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: context.colors.border2, width: .5),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(
              '$label: ',
              style: TextStyle(
                fontSize: 8,
                color: context.colors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 9,
                  color: context.colors.textPri,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
        ),
      );
}

class _NoteBlock extends StatelessWidget {
  final String label, text;
  final Color color;
  const _NoteBlock({
    required this.label,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(.05),
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: color, width: 2.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: .4,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(
                fontSize: 10.5,
                height: 1.5,
                color: context.colors.textSec,
              ),
            ),
          ],
        ),
      );
}
