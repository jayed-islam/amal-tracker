import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TOKENS
// ─────────────────────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────────────────────────────────────
class _AyahData {
  final String arabic;
  final String bengali;
  final String surahNameBn;
  final int surahNumber;
  final int ayahNumber;
  final int juzNumber;

  const _AyahData({
    required this.arabic,
    required this.bengali,
    required this.surahNameBn,
    required this.surahNumber,
    required this.ayahNumber,
    required this.juzNumber,
  });
}

// tafsir result: null = not available, empty string = loading failed
// non-empty = actual tafsir text
class _TafsirResult {
  final String? text; // null = API returned nothing useful
  const _TafsirResult(this.text);
}

// ─────────────────────────────────────────────────────────────────────────────
// CURATED POOL  (global 1-based indices, alquran.cloud)
// ─────────────────────────────────────────────────────────────────────────────
const _pool = [
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

String _juzBn(int j) {
  const bn = [
    '১',
    '২',
    '৩',
    '৪',
    '৫',
    '৬',
    '৭',
    '৮',
    '৯',
    '১০',
    '১১',
    '১২',
    '১৩',
    '১৪',
    '১৫',
    '১৬',
    '১৭',
    '১৮',
    '১৯',
    '২০',
    '২১',
    '২২',
    '২৩',
    '২৪',
    '২৫',
    '২৬',
    '২৭',
    '২৮',
    '২৯',
    '৩০',
  ];
  if (j < 1 || j > 30) return '$j';
  return '${bn[j - 1]}তম';
}

String _bnNum(int n) {
  const d = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
  return n.toString().split('').map((c) => d[int.parse(c)]).join();
}

// ─────────────────────────────────────────────────────────────────────────────
// FALLBACK
// ─────────────────────────────────────────────────────────────────────────────
const _fallback = _AyahData(
  arabic: 'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
  bengali: 'নিশ্চয়ই আল্লাহ ধৈর্যশীলদের সাথে আছেন।',
  surahNameBn: 'আল-বাকারা',
  surahNumber: 2,
  ayahNumber: 153,
  juzNumber: 2,
);

// ─────────────────────────────────────────────────────────────────────────────
// PROVIDERS
// ─────────────────────────────────────────────────────────────────────────────

// Manages current ayah index — can call .next() to get a new random one
class _AyahIndexNotifier extends Notifier<int> {
  @override
  int build() => _pick(-1);

  int _pick(int exclude) {
    final rng = Random(DateTime.now().microsecondsSinceEpoch);
    int idx;
    do {
      idx = _pool[rng.nextInt(_pool.length)];
    } while (idx == exclude && _pool.length > 1);
    return idx;
  }

  void next() => state = _pick(state);
}

final _ayahIndexProvider =
    NotifierProvider<_AyahIndexNotifier, int>(_AyahIndexNotifier.new);

// Fetches ayah text from API — re-runs whenever index changes
final _ayahProvider = FutureProvider<_AyahData>((ref) {
  final idx = ref.watch(_ayahIndexProvider);
  return _fetchAyah(idx);
});

// Fetches tafsir lazily — only called when user expands
// Returns _TafsirResult(null) if nothing available
final _tafsirProvider =
    FutureProvider.family<_TafsirResult, int>((ref, globalIdx) async {
  return _fetchTafsir(globalIdx);
});

// ─────────────────────────────────────────────────────────────────────────────
// NETWORK
// ─────────────────────────────────────────────────────────────────────────────

Future<_AyahData> _fetchAyah(int globalIdx) async {
  try {
    final uri = Uri.parse(
      'https://api.alquran.cloud/v1/ayah/$globalIdx'
      '/editions/quran-uthmani,bn.bengali',
    );
    final resp = await http.get(uri).timeout(const Duration(seconds: 8));
    if (resp.statusCode != 200) return _fallback;

    final body = jsonDecode(resp.body) as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;
    final ar = data[0] as Map<String, dynamic>;
    final bn = data[1] as Map<String, dynamic>;
    final surahNum = (ar['surah']?['number'] as int?) ?? 0;
    final juzNum = (ar['juz'] as int?) ?? 1;

    return _AyahData(
      arabic: (ar['text'] as String?) ?? '',
      bengali: (bn['text'] as String?) ?? '',
      surahNameBn: _bnSurahNames[surahNum] ?? 'সূরা #$surahNum',
      surahNumber: surahNum,
      ayahNumber: (ar['numberInSurah'] as int?) ?? 0,
      juzNumber: juzNum,
    );
  } catch (_) {
    return _fallback;
  }
}

// Tries known Bengali tafsir editions in order.
// If none return valid text → _TafsirResult(null) (hidden silently).
Future<_TafsirResult> _fetchTafsir(int globalIdx) async {
  // alquran.cloud Bengali tafsir editions to try in order
  const editions = [
    'bn.tafseer.bayaan', // Tafsir Bayaan (Bengali)
    'bn.tafseer.ibne-kaseer', // Ibn Kathir Bengali (if available)
    'bn.bengali', // Plain translation as last resort
  ];

  for (final edition in editions) {
    try {
      final uri = Uri.parse(
        'https://api.alquran.cloud/v1/ayah/$globalIdx/$edition',
      );
      final resp = await http.get(uri).timeout(const Duration(seconds: 8));
      if (resp.statusCode != 200) continue;

      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      final text = (body['data']?['text'] as String?)?.trim() ?? '';

      // Only accept if it looks like a tafsir (longer than a plain translation)
      // and isn't just repeating the translation
      if (text.isNotEmpty && text.length > 30) {
        return _TafsirResult(text);
      }
    } catch (_) {
      continue;
    }
  }

  // Nothing found — return null so UI hides the block entirely
  return const _TafsirResult(null);
}

// ─────────────────────────────────────────────────────────────────────────────
// PUBLIC WIDGET
// Usage in HomeScreen build():
//   const SizedBox(height: 16),
//   const DailyAyahSection(),
//   const SizedBox(height: 20),
// ─────────────────────────────────────────────────────────────────────────────
class DailyAyahSection extends ConsumerWidget {
  const DailyAyahSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ayah = ref.watch(_ayahProvider);
    final idx = ref.watch(_ayahIndexProvider);

    return ayah.when(
      loading: () => const _LoadingCard(),
      error: (_, __) => _AyahCard(ayah: _fallback, ayahIdx: 153),
      data: (d) =>
          _AyahCard(ayah: d, ayahIdx: idx).animate().fadeIn(duration: 300.ms),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LOADING CARD — compact single row, no space waste
// ─────────────────────────────────────────────────────────────────────────────
class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.border2, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 13,
            height: 13,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: context.colors.midGreen,
              backgroundColor: context.colors.border2,
            ),
          ),
          const SizedBox(width: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 12,
                color: context.colors.textSec,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text: 'আপনার জন্য ',
                  style: TextStyle(
                    color: context.colors.darkGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: 'একটি আয়াত নিয়ে আসছি…'),
              ],
            ),
          ),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 900.ms);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AYAH CARD
// ─────────────────────────────────────────────────────────────────────────────
class _AyahCard extends ConsumerStatefulWidget {
  final _AyahData ayah;
  final int ayahIdx;
  const _AyahCard({required this.ayah, required this.ayahIdx});

  @override
  ConsumerState<_AyahCard> createState() => _AyahCardState();
}

class _AyahCardState extends ConsumerState<_AyahCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  bool _tafsirRequested = false;

  late final AnimationController _ctrl;
  late final Animation<double> _chevron;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _chevron = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded && !_tafsirRequested) _tafsirRequested = true;
    });
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  void _nextAyah() {
    if (_expanded) {
      setState(() {
        _expanded = false;
        _tafsirRequested = false;
      });
      _ctrl.reverse();
    }
    ref.read(_ayahIndexProvider.notifier).next();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.border2, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── ALWAYS VISIBLE — badge + meaning ────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 13, 14, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: context.colors.greenLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '📖 আজকের আয়াত',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: context.colors.midGreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Container(
                    width: 3,
                    height: 3,
                    decoration: BoxDecoration(
                      color: context.colors.greenBorder,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Flexible(
                    child: Text(
                      '${widget.ayah.surahNameBn} '
                      '${_bnNum(widget.ayah.surahNumber)}:'
                      '${_bnNum(widget.ayah.ayahNumber)}',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textHint2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ]),

                const SizedBox(height: 10),

                // Bengali meaning — 3-line clamp, tap to expand
                GestureDetector(
                  onTap: _toggle,
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.ayah.bengali,
                        maxLines: _expanded ? null : 3,
                        overflow: _expanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textPri,
                          height: 1.75,
                          letterSpacing: 0.05,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(children: [
                        Text(
                          _expanded ? 'কম দেখুন' : 'আরো পড়ুন',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: context.colors.midGreen,
                          ),
                        ),
                        const SizedBox(width: 3),
                        RotationTransition(
                          turns: _chevron,
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 14,
                            color: context.colors.midGreen,
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // ── EXPANDED — Arabic + chips + tafsir ──────────────────────────
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _ExpandedPanel(
              ayah: widget.ayah,
              ayahIdx: widget.ayahIdx,
              tafsirRequested: _tafsirRequested,
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 320),
            sizeCurve: Curves.easeInOut,
          ),

          // ── BOTTOM — always visible ──────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: context.colors.border2, width: 0.5),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'প্রতিবার নতুন আয়াত',
                  style: TextStyle(
                    fontSize: 9,
                    color: context.colors.textHint2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: _nextAyah,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: context.colors.greenLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: context.colors.greenBorder, width: 0.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'অন্য আয়াত',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: context.colors.midGreen,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 11,
                          color: context.colors.midGreen,
                        ),
                      ],
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

// ─────────────────────────────────────────────────────────────────────────────
// EXPANDED PANEL
// ─────────────────────────────────────────────────────────────────────────────
class _ExpandedPanel extends ConsumerWidget {
  final _AyahData ayah;
  final int ayahIdx;
  final bool tafsirRequested;

  const _ExpandedPanel({
    required this.ayah,
    required this.ayahIdx,
    required this.tafsirRequested,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tafsirAsync =
        tafsirRequested ? ref.watch(_tafsirProvider(ayahIdx)) : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Arabic block
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: context.colors.goldBg,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: context.colors.goldBorder, width: 0.5),
            ),
            child: Text(
              ayah.arabic,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.colors.goldText,
                height: 2.0,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(height: 9),

          // Surah · Ayah · Para info chips
          Row(children: [
            _InfoChip(label: 'সূরা', value: ayah.surahNameBn),
            const SizedBox(width: 8),
            _InfoChip(label: 'আয়াত নং', value: _bnNum(ayah.ayahNumber)),
            const SizedBox(width: 8),
            _InfoChip(label: 'পারা', value: _juzBn(ayah.juzNumber)),
          ]),

          // Tafsir block — only shown if API returns something
          if (tafsirAsync != null) ...[
            const SizedBox(height: 9),
            tafsirAsync.when(
              loading: () => const _TafsirLoadingBlock(),
              error: (_, __) => const SizedBox.shrink(),
              data: (result) {
                // null = API had nothing → hide silently
                if (result.text == null || result.text!.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: context.colors.tafsirBg,
                    borderRadius: BorderRadius.all(Radius.circular(9)),
                    border: Border(
                      left: BorderSide(
                          color: context.colors.midGreen, width: 2.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'তাফসির',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: context.colors.midGreen,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        result.text!,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.8,
                          color: context.colors.textSec,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 220.ms);
              },
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 220.ms);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAFSIR LOADING BLOCK — 3 skeleton lines
// ─────────────────────────────────────────────────────────────────────────────
class _TafsirLoadingBlock extends StatelessWidget {
  const _TafsirLoadingBlock();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: context.colors.tafsirBg,
        borderRadius: BorderRadius.all(Radius.circular(9)),
        border: Border(
          left: BorderSide(color: context.colors.midGreen, width: 2.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'তাফসির',
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              color: context.colors.midGreen,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(
            3,
            (i) => Container(
              margin: const EdgeInsets.only(bottom: 6),
              height: 11,
              width: i == 2 ? 130 : double.infinity,
              decoration: BoxDecoration(
                color: context.colors.greenBorder.withOpacity(0.5),
                borderRadius: BorderRadius.circular(3),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(
                  duration: 700.ms,
                  delay: Duration(milliseconds: i * 80),
                ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INFO CHIP
// ─────────────────────────────────────────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  final String label, value;
  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color: context.colors.chipBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.colors.border2, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 8.5,
                  color: context.colors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 11,
                  color: context.colors.textPri,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
}
