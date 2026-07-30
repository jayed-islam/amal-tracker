import 'dart:math' as math;
import 'package:amal_tracker/core/router/app_router.dart';
import 'package:amal_tracker/features/onboarding/provider/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:amal_tracker/core/theme/app_colors.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

// ══════════════════════════════════════════════════════════════════════════
// COLORS
// ══════════════════════════════════════════════════════════════════════════
// ══════════════════════════════════════════════════════════════════════════
// RESPONSIVE — single source of truth
// sh < 640   → compact  (SE, Moto G)
// 640–799    → normal   (most flagships)
// ≥ 800      → large    (Pro Max, foldables)
// ══════════════════════════════════════════════════════════════════════════
class _R {
  final double sw;
  final double sh;
  const _R({required this.sw, required this.sh});
  factory _R.of(BuildContext ctx) {
    final s = MediaQuery.sizeOf(ctx);
    return _R(sw: s.width, sh: s.height);
  }

  bool get isCompact => sh < 640;
  bool get isLarge => sh >= 800;

  // Illustration: a clean fraction of screen — small enough to always
  // leave room for the text block below without any scroll.
  double get illustH => isCompact
      ? sh * 0.30
      : isLarge
          ? sh * 0.34
          : sh * 0.32;

  double get titleFs => isCompact
      ? 22.0
      : isLarge
          ? 27.0
          : 24.0;
  double get subtitleFs => isCompact ? 12.5 : 13.5;
  double get quoteFs => isCompact ? 12.0 : 13.0;
  double get eyebrowFs => isCompact ? 10.0 : 11.0;
  double get padH => isCompact ? 22.0 : 28.0;

  // Gaps between text elements
  double get gapQuoteTitle => isCompact ? 8.0 : 14.0;
  double get gapTitleSubtitle => isCompact ? 6.0 : 8.0;
  double get gapSubtitleBot => isCompact ? 6.0 : 8.0;
}

// ══════════════════════════════════════════════════════════════════════════
// PAGE DATA — no arabic field anymore
// ══════════════════════════════════════════════════════════════════════════
class _PageData {
  final String eyebrow;
  final String title;
  final String subtitle; // max 2 short lines
  final String quote; // bangla meaning only, 1 line ideally
  final String quoteSource;
  final Widget Function(Animation<double> float, _R r) painter;
  final Color bgFrom;
  final Color bgTo;

  const _PageData({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.quote,
    required this.quoteSource,
    required this.painter,
    required this.bgFrom,
    required this.bgTo,
  });
}

// ══════════════════════════════════════════════════════════════════════════
// SCREEN
// ══════════════════════════════════════════════════════════════════════════
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final _ctrl = PageController();
  int _cur = 0;

  late final AnimationController _fadeCtrl;
  late final AnimationController _floatCtrl;
  late final Animation<double> _fade;
  late final Animation<double> _float;

  static final _pages = [
    // 1 ─ Welcome
    _PageData(
      eyebrow: 'স্বাগতম Sabeq-এ',
      title: 'প্রতিটা আমলই\nহিসাবে আছে',
      subtitle:
          'নেক কাজ ছোট হলেও আল্লাহ তা নষ্ট করেন না —\nSabeq তোমাকে সেটা মনে রাখতে সাহায্য করে।',
      quote: '"আল্লাহ সৎকর্মশীলদের প্রতিদান নষ্ট করেন না।"',
      quoteSource: 'সূরা তাওবাহ · ৯:১২০',
      painter: (f, r) => _MosqueIllustration(float: f, r: r),
      bgFrom: const Color(0xFF021F10),
      bgTo: const Color(0xFF0A3D22),
    ),
    // 2 ─ Tracker
    _PageData(
      eyebrow: 'দৈনিক ট্র্যাকার',
      title: 'ছোট আমল,\nবড় পরিবর্তন',
      subtitle:
          'নামাজ, কোরআন, যিকির — সব এক জায়গায়।\nএকদিন মিস হলেও পরের দিন আবার শুরু করো।',
      quote: '"স্মরণ করিয়ে দাও — তা মুমিনদের উপকার করে।"',
      quoteSource: 'সূরা আয-যারিয়াত · ৫১:৫৫',
      painter: (f, r) => _TrackerIllustration(float: f, r: r),
      bgFrom: const Color(0xFF082E18),
      bgTo: const Color(0xFF124A28),
    ),
    // 3 ─ Leaderboard
    _PageData(
      eyebrow: 'লিডারবোর্ড',
      title: 'নেক কাজে\nএগিয়ে থাকো',
      subtitle:
          'বন্ধু-পরিবারের সাথে প্রতিযোগিতা করো।\nনাম গোপন রেখেও অংশ নেওয়া যাবে।',
      quote: '"এটা পেতে প্রতিযোগীরা যেন প্রতিযোগিতা করে।"',
      quoteSource: 'সূরা আল-মুতাফফিফীন · ৮৩:২৬',
      painter: (f, r) => _LeaderboardIllustration(float: f, r: r),
      bgFrom: const Color(0xFF0E3D20),
      bgTo: const Color(0xFF1A5C30),
    ),
    // 4 ─ Privacy
    _PageData(
      eyebrow: 'গোপনীয়তা',
      title: 'আমল তোমার,\nশেয়ার তোমার ইচ্ছা',
      subtitle:
          'স্কোর লুকাও, নাম Anonymous রাখো —\nআল্লাহর কাছে সব আমল পৌঁছে যায়।',
      quote: '"আল্লাহ জানেন যা তোমরা গোপন ও প্রকাশ করো।"',
      quoteSource: 'সূরা আন-নাহল · ১৬:১৯',
      painter: (f, r) => _PrivacyIllustration(float: f, r: r),
      bgFrom: const Color(0xFF052818),
      bgTo: const Color(0xFF0D4425),
    ),
  ];

  bool get _isLast => _cur == _pages.length - 1;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 480));
    _floatCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2800))
      ..repeat(reverse: true);
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _float = CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _fadeCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  void _onChanged(int i) {
    _fadeCtrl.reset();
    _fadeCtrl.forward();
    setState(() => _cur = i);
  }

  Future<void> _finish() async {
    await markOnboardingSeen();
    onboardingSeenNotifier.value = true;
    if (mounted) context.go(AppRoutes.login);
  }

  void _next() => _ctrl.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic);

  @override
  Widget build(BuildContext context) {
    final r = _R.of(context);
    final page = _pages[_cur];

    return Scaffold(
      backgroundColor: page.bgFrom,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [page.bgFrom, page.bgTo],
          ),
        ),
        child: Stack(
          children: [
            // Decorative pattern — purely visual, behind everything
            const Positioned.fill(child: _BgPattern()),

            // ── Main column — top-bar / pages / bottom-bar ─────────────
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Top bar ───────────────────────────────────────────
                  _TopBar(
                    isLast: _isLast,
                    onSkip: _finish,
                    r: r,
                  ),

                  // ── PageView — fills remaining space ──────────────────
                  Expanded(
                    child: PageView.builder(
                      controller: _ctrl,
                      onPageChanged: _onChanged,
                      itemCount: _pages.length,
                      itemBuilder: (_, i) => _Page(
                        data: _pages[i],
                        float: _float,
                        fade: _fade,
                        r: r,
                      ),
                    ),
                  ),

                  // ── Bottom bar — always below pages ───────────────────
                  _BottomBar(
                    cur: _cur,
                    total: _pages.length,
                    isLast: _isLast,
                    onNext: _next,
                    onFinish: _finish,
                    r: r,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// TOP BAR
// ══════════════════════════════════════════════════════════════════════════
class _TopBar extends StatelessWidget {
  final bool isLast;
  final VoidCallback onSkip;
  final _R r;
  const _TopBar({required this.isLast, required this.onSkip, required this.r});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, r.isCompact ? 6 : 10, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Brand
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withOpacity(0.22)),
                ),
                child: const Text('س',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1)),
              ),
              const SizedBox(width: 8),
              const Text('Sabeq',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3)),
            ],
          ),
          // Skip
          AnimatedOpacity(
            opacity: isLast ? 0 : 1,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: isLast,
              child: GestureDetector(
                onTap: onSkip,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  // larger hit area, visual pill smaller
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.22)),
                    ),
                    child: Text('এড়িয়ে যাও',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: r.eyebrowFs,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// PAGE — illustration + text, no scroll, everything fits
// ══════════════════════════════════════════════════════════════════════════
class _Page extends StatelessWidget {
  final _PageData data;
  final Animation<double> float;
  final Animation<double> fade;
  final _R r;
  const _Page({
    required this.data,
    required this.float,
    required this.fade,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Illustration ────────────────────────────────────────────────
        SizedBox(
          height: r.illustH,
          child: AnimatedBuilder(
            animation: float,
            builder: (_, child) => Transform.translate(
              offset: Offset(0, (float.value - 0.5) * 12),
              child: child,
            ),
            child: Center(child: data.painter(float, r)),
          ),
        ),

        // ── Text block — fixed, no scroll ───────────────────────────────
        Expanded(
          child: FadeTransition(
            opacity: fade,
            child: Padding(
              padding: EdgeInsets.fromLTRB(r.padH, 0, r.padH, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Eyebrow tag
                  _Tag(label: data.eyebrow, r: r),
                  SizedBox(height: r.gapQuoteTitle * 0.6),

                  // Title
                  Text(
                    data.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: r.titleFs,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: r.gapTitleSubtitle),

                  // Subtitle — max 2 lines, never wraps more
                  Text(
                    data.subtitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.68),
                      fontSize: r.subtitleFs,
                      fontWeight: FontWeight.w400,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: r.gapSubtitleBot),

                  // Quote strip — compact single line design
                  _QuoteStrip(
                    quote: data.quote,
                    source: data.quoteSource,
                    r: r,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// EYEBROW TAG
// ══════════════════════════════════════════════════════════════════════════
class _Tag extends StatelessWidget {
  final String label;
  final _R r;
  const _Tag({required this.label, required this.r});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: context.colors.gold2.withOpacity(0.14),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: context.colors.gold2.withOpacity(0.30)),
        ),
        child: Text(label,
            style: TextStyle(
                color: context.colors.gold2.withOpacity(0.9),
                fontSize: r.eyebrowFs,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6)),
      );
}

// ══════════════════════════════════════════════════════════════════════════
// QUOTE STRIP — compact horizontal layout, no arabic
// ══════════════════════════════════════════════════════════════════════════
class _QuoteStrip extends StatelessWidget {
  final String quote;
  final String source;
  final _R r;
  const _QuoteStrip(
      {required this.quote, required this.source, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.gold2.withOpacity(0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gold left bar accent
          Container(
            width: 3,
            height: 36,
            margin: const EdgeInsets.only(right: 10, top: 1),
            decoration: BoxDecoration(
              color: context.colors.gold2.withOpacity(0.7),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Quote + source stacked
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quote,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: r.quoteFs,
                    fontStyle: FontStyle.italic,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  source,
                  style: TextStyle(
                    color: context.colors.gold2.withOpacity(0.6),
                    fontSize: r.isCompact ? 10.0 : 10.5,
                    fontWeight: FontWeight.w600,
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

// ══════════════════════════════════════════════════════════════════════════
// BOTTOM BAR — dots + next/finish
// ══════════════════════════════════════════════════════════════════════════
class _BottomBar extends StatelessWidget {
  final int cur;
  final int total;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onFinish;
  final _R r;
  const _BottomBar({
    required this.cur,
    required this.total,
    required this.isLast,
    required this.onNext,
    required this.onFinish,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          26, r.isCompact ? 10 : 14, 26, r.isCompact ? 14 : 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Dots
          Row(
            children: List.generate(total, (i) {
              final active = i == cur;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(right: 6),
                width: active ? 20.0 : 7.0,
                height: 7,
                decoration: BoxDecoration(
                  color: active ? Colors.white : Colors.white.withOpacity(0.28),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),

          // Button
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: isLast
                ? _FinishBtn(key: const ValueKey('f'), onTap: onFinish, r: r)
                : _NextBtn(key: const ValueKey('n'), onTap: onNext, r: r),
          ),
        ],
      ),
    );
  }
}

class _NextBtn extends StatelessWidget {
  final VoidCallback onTap;
  final _R r;
  const _NextBtn({super.key, required this.onTap, required this.r});
  @override
  Widget build(BuildContext context) {
    final sz = r.isCompact ? 46.0 : 52.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: sz,
        height: sz,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
        ),
        child: Icon(Icons.arrow_forward_rounded,
            color: context.colors.darkGreen2, size: r.isCompact ? 20.0 : 22.0),
      ),
    );
  }
}

class _FinishBtn extends StatelessWidget {
  final VoidCallback onTap;
  final _R r;
  const _FinishBtn({super.key, required this.onTap, required this.r});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: r.isCompact ? 18 : 22,
              vertical: r.isCompact ? 12 : 14),
          decoration: BoxDecoration(
            color: context.colors.gold2,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: context.colors.gold2.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 5))
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('শুরু করি',
                  style: TextStyle(
                      color: context.colors.darkGreen2,
                      fontSize: r.isCompact ? 14.0 : 15.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2)),
              const SizedBox(width: 7),
              Icon(Icons.arrow_forward_rounded,
                  color: context.colors.darkGreen2,
                  size: r.isCompact ? 17.0 : 18.0),
            ],
          ),
        ),
      );
}

// ══════════════════════════════════════════════════════════════════════════
// BACKGROUND PATTERN
// ══════════════════════════════════════════════════════════════════════════
class _BgPattern extends StatelessWidget {
  const _BgPattern();
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _PatternPainter(), size: Size.infinite);
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    const s = 72.0;
    for (double x = -s; x < size.width + s; x += s)
      for (double y = -s; y < size.height + s; y += s)
        _oct(canvas, Offset(x, y), 24, p);
  }

  void _oct(Canvas canvas, Offset c, double r, Paint p) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final a = (i * math.pi / 4) - math.pi / 8;
      final pt = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
      i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
    }
    canvas.drawPath(path..close(), p);
  }

  @override
  bool shouldRepaint(_PatternPainter _) => false;
}

// ══════════════════════════════════════════════════════════════════════════
// ILLUSTRATIONS
// ══════════════════════════════════════════════════════════════════════════

// ── 1. Mosque ─────────────────────────────────────────────────────────────
class _MosqueIllustration extends StatelessWidget {
  final Animation<double> float;
  final _R r;
  const _MosqueIllustration({required this.float, required this.r});
  @override
  Widget build(BuildContext context) {
    final s = r.sw * 0.72;
    return CustomPaint(
        painter: _MosquePainter(colors: context.colors), size: Size(s, s));
  }
}

class _MosquePainter extends CustomPainter {
  final AppColorTokens colors;
  const _MosquePainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // shadow
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, cy + size.height * 0.35),
          width: size.width * 0.82,
          height: size.height * 0.1),
      Paint()
        ..color = Colors.black.withOpacity(0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    final w = Paint()..color = Colors.white.withOpacity(0.93);
    final w2 = Paint()..color = Colors.white.withOpacity(0.78);
    final g = Paint()..color = colors.gold2.withOpacity(0.88);

    // body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - size.width * 0.28, cy - size.height * 0.08,
            size.width * 0.56, size.height * 0.43),
        const Radius.circular(5),
      ),
      w,
    );
    // domes
    _dome(canvas, Offset(cx, cy - size.height * 0.08), size.width * 0.21,
        size.height * 0.22, g);
    _dome(canvas, Offset(cx - size.width * 0.2, cy - size.height * 0.04),
        size.width * 0.1, size.height * 0.11, w2);
    _dome(canvas, Offset(cx + size.width * 0.2, cy - size.height * 0.04),
        size.width * 0.1, size.height * 0.11, w2);

    // minarets
    for (final sx in [-1.0, 1.0]) {
      final mx = cx + sx * size.width * 0.31;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(mx, cy + size.height * 0.04),
              width: size.width * 0.055,
              height: size.height * 0.5),
          const Radius.circular(4),
        ),
        w2,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(mx, cy - size.height * 0.1),
              width: size.width * 0.1,
              height: size.height * 0.025),
          const Radius.circular(3),
        ),
        g,
      );
      _dome(canvas, Offset(mx, cy - size.height * 0.22), size.width * 0.042,
          size.height * 0.08, g);
      canvas.drawLine(
        Offset(mx, cy - size.height * 0.3),
        Offset(mx, cy - size.height * 0.22),
        Paint()
          ..color = colors.gold2
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );
    }
    // door
    final dw = size.width * 0.13;
    final dt = cy + size.height * 0.08;
    canvas.drawPath(
      Path()
        ..moveTo(cx - dw / 2, dt + dw * 1.3)
        ..lineTo(cx - dw / 2, dt + dw / 2)
        ..addArc(
            Rect.fromCenter(
                center: Offset(cx, dt + dw / 2), width: dw, height: dw),
            math.pi,
            math.pi)
        ..lineTo(cx + dw / 2, dt + dw * 1.3)
        ..close(),
      Paint()..color = colors.greenMid.withOpacity(0.55),
    );
    // crescent
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()
          ..addOval(Rect.fromCircle(
              center: Offset(cx, cy - size.height * 0.3),
              radius: size.width * 0.055)),
        Path()
          ..addOval(Rect.fromCircle(
              center: Offset(cx + size.width * 0.025, cy - size.height * 0.305),
              radius: size.width * 0.042)),
      ),
      Paint()..color = colors.gold2,
    );
    // stars
    final sp = Paint()..color = colors.gold2.withOpacity(0.6);
    for (final (ox, oy) in [(-0.36, -0.36), (0.37, -0.29), (0.13, -0.40)])
      _star(canvas, Offset(cx + ox * size.width, cy + oy * size.height),
          size.width * 0.02, sp);
  }

  void _dome(Canvas canvas, Offset c, double w, double h, Paint p) =>
      canvas.drawPath(
        Path()
          ..moveTo(c.dx - w, c.dy)
          ..cubicTo(c.dx - w, c.dy - h * 1.35, c.dx + w, c.dy - h * 1.35,
              c.dx + w, c.dy)
          ..close(),
        p,
      );

  void _star(Canvas canvas, Offset c, double r, Paint p) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final o = Offset(c.dx + r * math.cos(i * 4 * math.pi / 5 - math.pi / 2),
          c.dy + r * math.sin(i * 4 * math.pi / 5 - math.pi / 2));
      final inn = Offset(
          c.dx + r * .4 * math.cos((i * 4 + 2) * math.pi / 5 - math.pi / 2),
          c.dy + r * .4 * math.sin((i * 4 + 2) * math.pi / 5 - math.pi / 2));
      i == 0 ? path.moveTo(o.dx, o.dy) : path.lineTo(o.dx, o.dy);
      path.lineTo(inn.dx, inn.dy);
    }
    canvas.drawPath(path..close(), p);
  }

  @override
  bool shouldRepaint(_MosquePainter _) => false;
}

// ── 2. Tracker phone ──────────────────────────────────────────────────────
class _TrackerIllustration extends StatelessWidget {
  final Animation<double> float;
  final _R r;
  const _TrackerIllustration({required this.float, required this.r});
  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _TrackerPainter(colors: context.colors),
        size: Size(r.sw * 0.58, r.sh * 0.30),
      );
}

class _TrackerPainter extends CustomPainter {
  final AppColorTokens colors;
  const _TrackerPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final frame = RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(cx, cy), width: size.width, height: size.height),
        const Radius.circular(20));
    canvas.drawRRect(
        frame,
        Paint()
          ..color = Colors.black.withOpacity(0.18)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
    canvas.drawRRect(frame, Paint()..color = Colors.white.withOpacity(0.96));

    // Header
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(cx - size.width / 2, cy - size.height / 2, size.width,
            size.height * 0.12),
        topLeft: const Radius.circular(20),
        topRight: const Radius.circular(20),
      ),
      Paint()..color = colors.darkGreen2,
    );
    _blob(canvas, Offset(cx - size.width * .1, cy - size.height * .44),
        size.width * .2, 5, Colors.white.withOpacity(0.7), 3);

    // Rows
    const done = [true, true, true, false, false, true];
    final rowColors = [
      colors.greenAccent,
      colors.greenAccent,
      colors.greenAccent,
      colors.gold2,
      Colors.grey,
      colors.greenAccent,
    ];
    for (int i = 0; i < 6; i++) {
      final ry = cy - size.height * 0.26 + i * size.height * 0.115;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(cx, ry),
              width: size.width * 0.84,
              height: size.height * 0.09),
          const Radius.circular(8),
        ),
        Paint()
          ..color = done[i]
              ? rowColors[i].withOpacity(0.1)
              : Colors.grey.withOpacity(0.05),
      );
      final cb = Offset(cx - size.width * 0.35, ry);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: cb, width: 14, height: 14),
            const Radius.circular(4)),
        Paint()..color = done[i] ? rowColors[i] : Colors.grey.withOpacity(0.2),
      );
      if (done[i]) {
        final ck = Paint()
          ..color = Colors.white
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(
            Offset(cb.dx - 3.5, cb.dy), Offset(cb.dx - 1, cb.dy + 3), ck);
        canvas.drawLine(
            Offset(cb.dx - 1, cb.dy + 3), Offset(cb.dx + 4.5, cb.dy - 3), ck);
      }
      _blob(
          canvas,
          Offset(cx - size.width * .12, ry),
          size.width * .3,
          5,
          done[i]
              ? rowColors[i].withOpacity(0.45)
              : Colors.grey.withOpacity(0.2),
          3);
    }
    // progress bar
    final py = cy + size.height * 0.44;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - size.width * .36, py, size.width * .72, 5),
            const Radius.circular(3)),
        Paint()..color = Colors.grey.withOpacity(0.15));
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - size.width * .36, py, size.width * .72 * .67, 5),
            const Radius.circular(3)),
        Paint()..color = colors.greenAccent);
  }

  void _blob(
          Canvas canvas, Offset c, double w, double h, Color col, double r) =>
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: c, width: w, height: h),
            Radius.circular(r)),
        Paint()..color = col,
      );

  @override
  bool shouldRepaint(_TrackerPainter _) => false;
}

// ── 3. Leaderboard ────────────────────────────────────────────────────────
class _LeaderboardIllustration extends StatelessWidget {
  final Animation<double> float;
  final _R r;
  const _LeaderboardIllustration({required this.float, required this.r});
  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _LeaderboardPainter(colors: context.colors),
        size: Size(r.sw * 0.74, r.sh * 0.30),
      );
}

class _LeaderboardPainter extends CustomPainter {
  final AppColorTokens colors;
  const _LeaderboardPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    _trophy(canvas, Offset(cx, cy - size.height * 0.28), size.width * 0.17);

    final bw = size.width * 0.25;
    final baseY = cy + size.height * 0.44;

    _podium(canvas, Offset(cx - bw * 1.05, baseY), bw * 0.9, size.height * 0.28,
        Colors.white.withOpacity(0.68), '২');
    _podium(
        canvas, Offset(cx, baseY), bw, size.height * 0.44, colors.gold2, '১');
    _podium(canvas, Offset(cx + bw * 1.05, baseY), bw * 0.9, size.height * 0.2,
        colors.greenAccent.withOpacity(0.72), '৩');

    _avatar(canvas, Offset(cx - bw * 1.05, baseY - size.height * .28 - 28), 20,
        Colors.white.withOpacity(0.82), colors.textSec4);

    canvas.drawCircle(
        Offset(cx, baseY - size.height * .44 - 28),
        30,
        Paint()
          ..color = colors.gold2.withOpacity(0.24)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
    _avatar(canvas, Offset(cx, baseY - size.height * .44 - 28), 25,
        colors.gold2, colors.darkGreen2);

    _avatar(canvas, Offset(cx + bw * 1.05, baseY - size.height * .2 - 26), 19,
        colors.greenAccent, Colors.white);

    // rays
    final rp = Paint()
      ..color = colors.gold2.withOpacity(0.35)
      ..strokeWidth = 1.5;
    final oc = Offset(cx, baseY - size.height * .44 - 28);
    for (int i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      canvas.drawLine(
          Offset(oc.dx + 36 * math.cos(a), oc.dy + 36 * math.sin(a)),
          Offset(oc.dx + 48 * math.cos(a), oc.dy + 48 * math.sin(a)),
          rp);
    }
  }

  void _podium(Canvas canvas, Offset base, double w, double h, Color color,
      String rank) {
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(base.dx - w / 2, base.dy - h, w, h),
        topLeft: const Radius.circular(9),
        topRight: const Radius.circular(9),
      ),
      Paint()..color = color,
    );
    final tp = TextPainter(
      text: TextSpan(
          text: rank,
          style: TextStyle(
              color: rank == '১'
                  ? colors.darkGreen2
                  : Colors.white.withOpacity(0.85),
              fontSize: 15,
              fontWeight: FontWeight.w800)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(base.dx - tp.width / 2, base.dy - 22));
  }

  void _avatar(Canvas canvas, Offset c, double r, Color bg, Color fg) {
    canvas.drawCircle(
        c, r + 3, Paint()..color = Colors.white.withOpacity(0.16));
    canvas.drawCircle(c, r, Paint()..color = bg);
    canvas.drawCircle(Offset(c.dx, c.dy - r * .27), r * .33,
        Paint()..color = fg.withOpacity(0.85));
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(c.dx, c.dy + r * .45), width: r * 1.1, height: r),
      math.pi,
      math.pi,
      false,
      Paint()
        ..color = fg.withOpacity(0.85)
        ..style = PaintingStyle.fill,
    );
  }

  void _trophy(Canvas canvas, Offset c, double r) {
    final p = Paint()..color = colors.gold2;
    canvas.drawPath(
      Path()
        ..moveTo(c.dx - r, c.dy - r * .3)
        ..cubicTo(c.dx - r * 1.2, c.dy + r * .7, c.dx + r * 1.2, c.dy + r * .7,
            c.dx + r, c.dy - r * .3)
        ..lineTo(c.dx + r * .6, c.dy - r)
        ..lineTo(c.dx - r * .6, c.dy - r)
        ..close(),
      p,
    );
    for (final sx in [-1.0, 1.0])
      canvas.drawArc(
        Rect.fromCenter(
            center: Offset(c.dx + sx * r * .98, c.dy - r * .15),
            width: r * .55,
            height: r * .65),
        sx > 0 ? -math.pi / 2 : math.pi / 2,
        math.pi,
        false,
        Paint()
          ..color = colors.gold2
          ..style = PaintingStyle.stroke
          ..strokeWidth = r * .13,
      );
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(c.dx, c.dy + r * .9),
            width: r * .22,
            height: r * .45),
        p);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(c.dx, c.dy + r * 1.22),
            width: r * .85,
            height: r * .18),
        const Radius.circular(4),
      ),
      p,
    );
  }

  @override
  bool shouldRepaint(_LeaderboardPainter _) => false;
}

// ── 4. Privacy shield ────────────────────────────────────────────────────
class _PrivacyIllustration extends StatelessWidget {
  final Animation<double> float;
  final _R r;
  const _PrivacyIllustration({required this.float, required this.r});
  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _PrivacyPainter(colors: context.colors),
        size: Size(r.sw * 0.68, r.sh * 0.29),
      );
}

class _PrivacyPainter extends CustomPainter {
  final AppColorTokens colors;
  const _PrivacyPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final sr = size.width * 0.20;

    final shield = Path()
      ..moveTo(cx, cy - sr * 1.2)
      ..cubicTo(cx + sr * 1.2, cy - sr * .8, cx + sr * 1.2, cy + sr * .4, cx,
          cy + sr * 1.2)
      ..cubicTo(cx - sr * 1.2, cy + sr * .4, cx - sr * 1.2, cy - sr * .8, cx,
          cy - sr * 1.2)
      ..close();

    canvas.drawPath(
        shield,
        Paint()
          ..color = colors.greenAccent.withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14));
    canvas.drawPath(shield, Paint()..color = colors.greenMid.withOpacity(0.65));
    canvas.drawPath(
        shield,
        Paint()
          ..color = Colors.white.withOpacity(0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5);

    // lock body
    final lw = sr * .52;
    final lh = sr * .44;
    final lcy = cy + sr * .18;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx, lcy), width: lw, height: lh),
          const Radius.circular(7)),
      Paint()..color = Colors.white.withOpacity(0.9),
    );
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(cx, lcy - lh / 2), width: lw * .6, height: lw * .6),
      math.pi,
      math.pi,
      false,
      Paint()
        ..color = Colors.white.withOpacity(0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
        Offset(cx, lcy - 2), 4.5, Paint()..color = colors.greenMid);
    canvas.drawRect(
        Rect.fromCenter(center: Offset(cx, lcy + 6), width: 3.5, height: 8),
        Paint()..color = colors.greenMid);

    // floating feature chips
    final chips = [
      (
        cx - size.width * .36,
        cy - size.height * .28,
        Icons.visibility_off_rounded,
        'আমল লুকাও'
      ),
      (
        cx + size.width * .30,
        cy - size.height * .2,
        Icons.person_off_rounded,
        'নাম গোপন'
      ),
      (
        cx - size.width * .32,
        cy + size.height * .28,
        Icons.share_rounded,
        'নিজে শেয়ার'
      ),
    ];

    for (final (fx, fy, _, label) in chips) {
      // dashed line to shield
      _dash(
          canvas,
          Offset(fx, fy),
          Offset(cx, cy),
          Paint()
            ..color = Colors.white.withOpacity(0.16)
            ..strokeWidth = 1.2);

      // chip
      final cw = size.width * .26;
      final ch = size.height * .22;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(fx, fy), width: cw, height: ch),
            const Radius.circular(11)),
        Paint()..color = Colors.white.withOpacity(0.08),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(fx, fy), width: cw, height: ch),
            const Radius.circular(11)),
        Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
      // gold dot
      canvas.drawCircle(Offset(fx, fy - ch * .2), ch * .12,
          Paint()..color = colors.gold2.withOpacity(0.5));
      // label
      final tp = TextPainter(
        text: TextSpan(
            text: label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                height: 1.3)),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: cw - 8);
      tp.paint(canvas, Offset(fx - tp.width / 2, fy + ch * .06));
    }
  }

  void _dash(Canvas canvas, Offset a, Offset b, Paint p) {
    final dx = b.dx - a.dx, dy = b.dy - a.dy;
    final d = math.sqrt(dx * dx + dy * dy);
    final nx = dx / d, ny = dy / d;
    double t = 0;
    while (t < d - 38) {
      canvas.drawLine(
        Offset(a.dx + nx * t, a.dy + ny * t),
        Offset(a.dx + nx * (t + 4.5), a.dy + ny * (t + 4.5)),
        p,
      );
      t += 9;
    }
  }

  @override
  bool shouldRepaint(_PrivacyPainter _) => false;
}
