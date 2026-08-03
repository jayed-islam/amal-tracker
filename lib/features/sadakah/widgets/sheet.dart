import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';
import '../screens/sadakah_screen.dart';

class SadakahButtonWidget extends StatefulWidget {
  const SadakahButtonWidget({super.key});

  @override
  State<SadakahButtonWidget> createState() => _SadakahButtonWidgetState();
}

class _SadakahButtonWidgetState extends State<SadakahButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _loopController;

  @override
  void initState() {
    super.initState();
    // Every stage below has its own dwell time in _SadakahPhase — this
    // duration must match _SadakahPhase.totalSeconds exactly.
    _loopController = AnimationController(
      vsync: this,
      duration:
          Duration(milliseconds: (_SadakahPhase.totalSeconds * 1000).round()),
    );
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _loopController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _loopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showSadaqahSheet(context),
      child: Animate(
        effects: [
          FadeEffect(duration: 500.ms, curve: Curves.easeOut),
          ScaleEffect(
            begin: const Offset(0.7, 0.7),
            end: const Offset(1.0, 1.0),
            duration: 500.ms,
            curve: Curves.easeOutCubic,
          ),
        ],
        child: Container(
          width: 35,
          height: 35,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.colors.goldLight.withOpacity(0.12),
                context.colors.goldLight2.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: context.colors.goldBorder2.withOpacity(0.8),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: context.colors.gold.withOpacity(0.08),
                blurRadius: 4,
                spreadRadius: 0.5,
              ),
            ],
          ),
          child: AnimatedBuilder(
            animation: _loopController,
            builder: (context, _) {
              final seconds =
                  _loopController.value * _SadakahPhase.totalSeconds;
              final phase = _SadakahPhase.at(seconds);
              return Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(35, 35),
                    painter: _SadakahGrowthPainter(phase: phase),
                  ),
                  Opacity(
                    opacity: phase.iconAlpha,
                    child: _ShimmeringIcon(
                      shimmerT: phase.shimmerT,
                      color: phase.iconColor(context.colors.gold),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// A single slow diagonal light sweep across the icon, plays once during
// the calm gold hold. Driven purely by shimmerT (0 = none, 0..1 = sweep).
class _ShimmeringIcon extends StatelessWidget {
  final double shimmerT;
  final Color color;
  const _ShimmeringIcon({required this.shimmerT, required this.color});

  @override
  Widget build(BuildContext context) {
    final icon = Icon(Icons.volunteer_activism_rounded, color: color, size: 17);
    if (shimmerT <= 0 || shimmerT >= 1) return icon;

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        final pos = (shimmerT * 2.6) - 0.8;
        return LinearGradient(
          begin: Alignment(-1.4 + pos, -1.4),
          end: Alignment(-0.6 + pos, -0.6),
          colors: [color, Colors.white, color],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(bounds);
      },
      child: icon,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PHASE — a storyboard driven by real SECONDS elapsed (not raw 0..1
// fractions), so every beat's duration is explicit and easy to feel out
// and retune. Each stage has its own dwell time; movement and stillness
// are kept deliberately separate so the eye can register each beat.
// ─────────────────────────────────────────────────────────────────────────────

class _SadakahPhase {
  // ── Story beats, in seconds from the start of the loop ────────────────
  static const double idleEnd = 6.0; // long rest — nothing happens
  static const double iconFadeStart = idleEnd - 1.0; // 5.0
  static const double dropAppearEnd =
      idleEnd + 0.6; // 6.6 — drop fades/scales in
  static const double dropHoldEnd =
      dropAppearEnd + 1.0; // 7.6 — sits still (anticipation)
  static const double fallEnd = dropHoldEnd + 3.0; // 10.6 — slow real fall
  static const double impactFreezeEnd =
      fallEnd + 0.3; // 10.9 — tiny freeze on contact
  static const double splashEnd = impactFreezeEnd + 2.0; // 12.9
  static const double settleEnd =
      splashEnd + 1.0; // 13.9 — ripples die down, quiet
  static const double sproutEnd = settleEnd + 0.5; // 14.4 — seed pops open
  static const double growEnd = sproutEnd + 4.0; // 18.4 — stem climbs steadily
  static const double growPauseEnd =
      growEnd + 0.5; // 18.9 — reaches height, holds
  static const double leaf1End = growPauseEnd + 1.0; // 19.9 — left leaf unfurls
  static const double leafPauseEnd = leaf1End + 0.2; // 20.1
  static const double leaf2End =
      leafPauseEnd + 1.0; // 21.1 — right leaf unfurls
  static const double bloomEnd =
      leaf2End + 1.0; // 22.1 — canopy blooms, admire the tree
  static const double transformEnd =
      bloomEnd + 1.5; // 23.6 — tree becomes the gold icon
  static const double shimmerEnd =
      transformEnd + 1.0; // 24.6 — one shimmer sweep
  static const double holdEnd = shimmerEnd + 1.0; // 25.6 — quiet gold hold
  static const double totalSeconds = holdEnd + 0.7; // 26.3 — fade back to gray

  final bool dropVisible;
  final double dropAppear; // 0..1 fade/scale-in of the drop
  final double dropY;
  final double dropStretch;
  final double dropSquash;
  final double dropShadow;

  final bool splashVisible;
  final double splashT;
  final double satelliteT;

  final double soilScale;
  final double sproutScale;
  final double trunkGrowth; // 0..1 of full height
  final double leaf1Scale;
  final double leaf1Angle;
  final double leaf2Scale;
  final double leaf2Angle;
  final double canopyScale;

  final double sceneAlpha;
  final double iconAlpha;
  final double shimmerT;
  final double _iconColorT;

  _SadakahPhase({
    required this.dropVisible,
    required this.dropAppear,
    required this.dropY,
    required this.dropStretch,
    required this.dropSquash,
    required this.dropShadow,
    required this.splashVisible,
    required this.splashT,
    required this.satelliteT,
    required this.soilScale,
    required this.sproutScale,
    required this.trunkGrowth,
    required this.leaf1Scale,
    required this.leaf1Angle,
    required this.leaf2Scale,
    required this.leaf2Angle,
    required this.canopyScale,
    required this.sceneAlpha,
    required this.iconAlpha,
    required this.shimmerT,
    required double iconColorT,
  }) : _iconColorT = iconColorT;

  Color iconColor(Color gold) {
    const gray = Color(0xFFB9BFBA);
    return Color.lerp(gray, gold, _iconColorT) ?? gray;
  }

  static double _clamp01(double v) => v.clamp(0.0, 1.0);
  static double _seg(double s, double start, double end) =>
      _clamp01((s - start) / (end - start));

  static const double landingY = 27;
  static const double dropTravelStartY = 4;

  factory _SadakahPhase.at(double s) {
    // ── Drop: materialize → hold → fall → freeze ───────────────────────
    final dropVisible = s >= idleEnd && s < impactFreezeEnd;
    final dropAppear =
        Curves.easeOut.transform(_seg(s, idleEnd, dropAppearEnd));

    double dropY = dropTravelStartY;
    double dropStretch = 0, dropSquash = 0, dropShadow = 0;
    if (s < dropAppearEnd) {
      dropY = dropTravelStartY;
    } else if (s < dropHoldEnd) {
      dropY = dropTravelStartY; // anticipation — sits still
    } else if (s < fallEnd) {
      final fallT = _seg(s, dropHoldEnd, fallEnd);
      final fall = fallT * fallT; // gravity
      dropY = dropTravelStartY + (landingY - dropTravelStartY) * fall;
      dropStretch =
          fallT < 0.8 ? Curves.easeIn.transform(_seg(fallT, 0.0, 0.8)) : 0.0;
      dropSquash = fallT >= 0.8 ? _seg(fallT, 0.8, 1.0) : 0.0;
      dropShadow = fallT;
    } else if (s < impactFreezeEnd) {
      dropY = landingY;
      dropSquash = 1.0;
      dropShadow = 1.0;
    }

    // ── Splash ───────────────────────────────────────────────────────
    final splashVisible = s >= impactFreezeEnd && s < splashEnd;
    final splashT = _seg(s, impactFreezeEnd, splashEnd);
    final satelliteT = _seg(s, impactFreezeEnd + 0.15, impactFreezeEnd + 0.7);

    // ── Soil, sprout, stem, leaves, canopy ─────────────────────────────
    final soilScale =
        Curves.easeOut.transform(_seg(s, splashEnd, splashEnd + 0.6));
    final sproutRaw = _seg(s, settleEnd, sproutEnd);
    final sproutScale =
        Curves.easeOutBack.transform(sproutRaw).clamp(0.0, 1.15);

    double trunkGrowth;
    if (s < sproutEnd) {
      trunkGrowth = 0.14 * sproutScale.clamp(0.0, 1.0);
    } else if (s < growEnd) {
      final g = Curves.easeInOutSine.transform(_seg(s, sproutEnd, growEnd));
      trunkGrowth = 0.14 + (0.86 * g);
    } else {
      trunkGrowth = 1.0;
    }

    final leaf1T = Curves.easeOutBack
        .transform(_seg(s, growPauseEnd, leaf1End))
        .clamp(0.0, 1.1);
    final leaf2T = Curves.easeOutBack
        .transform(_seg(s, leafPauseEnd, leaf2End))
        .clamp(0.0, 1.1);
    final leaf1Angle =
        -1.1 + (0.35 * (1 - leaf1T).clamp(0.0, 1.0)); // unfurl rotation
    final leaf2Angle = 1.1 - (0.35 * (1 - leaf2T).clamp(0.0, 1.0));

    final canopyScale = Curves.easeOutBack
        .transform(_seg(s, leaf2End, bloomEnd))
        .clamp(0.0, 1.1);

    // ── Scene vs icon crossfade + reset ─────────────────────────────────
    double sceneAlpha, iconAlpha, iconColorT, shimmerT;

    if (s < iconFadeStart) {
      sceneAlpha = 0;
      iconAlpha = 1;
      iconColorT = 0;
    } else if (s < idleEnd) {
      final f = _seg(s, iconFadeStart, idleEnd);
      sceneAlpha = f;
      iconAlpha = 1 - f;
      iconColorT = 0;
    } else if (s < bloomEnd) {
      sceneAlpha = 1;
      iconAlpha = 0;
      iconColorT = 0;
    } else if (s < transformEnd) {
      final f = _seg(s, bloomEnd, transformEnd);
      sceneAlpha = 1 - f;
      iconAlpha = f;
      iconColorT = f;
    } else if (s < holdEnd) {
      sceneAlpha = 0;
      iconAlpha = 1;
      iconColorT = 1;
    } else {
      final f = _seg(s, holdEnd, totalSeconds);
      sceneAlpha = 0;
      iconAlpha = 1;
      iconColorT = 1 - f;
    }

    if (s >= transformEnd + 0.3 && s < shimmerEnd) {
      shimmerT = _seg(s, transformEnd + 0.3, shimmerEnd);
    } else {
      shimmerT = 0;
    }

    return _SadakahPhase(
      dropVisible: dropVisible,
      dropAppear: dropAppear,
      dropY: dropY,
      dropStretch: dropStretch,
      dropSquash: dropSquash,
      dropShadow: dropShadow,
      splashVisible: splashVisible,
      splashT: splashT,
      satelliteT: satelliteT,
      soilScale: soilScale,
      sproutScale: sproutScale,
      trunkGrowth: trunkGrowth,
      leaf1Scale: leaf1T,
      leaf1Angle: leaf1Angle,
      leaf2Scale: leaf2T,
      leaf2Angle: leaf2Angle,
      canopyScale: canopyScale,
      sceneAlpha: sceneAlpha,
      iconAlpha: iconAlpha,
      shimmerT: shimmerT,
      iconColorT: iconColorT,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PAINTER
// ─────────────────────────────────────────────────────────────────────────────

class _SadakahGrowthPainter extends CustomPainter {
  final _SadakahPhase phase;
  _SadakahGrowthPainter({required this.phase});

  static const double landingX = 17.5;

  @override
  void paint(Canvas canvas, Size size) {
    if (phase.sceneAlpha <= 0) return;
    canvas.saveLayer(Offset.zero & size,
        Paint()..color = Colors.white.withOpacity(phase.sceneAlpha));
    _paintSoil(canvas);
    _paintTree(canvas);
    _paintSplash(canvas);
    _paintDropShadow(canvas);
    _paintDrop(canvas);
    canvas.restore();
  }

  void _paintDropShadow(Canvas canvas) {
    if (!phase.dropVisible || phase.dropShadow <= 0) return;
    final width = 2.5 + (4 * phase.dropShadow);
    final opacity = 0.25 * phase.dropShadow * phase.dropAppear;
    canvas.drawOval(
      Rect.fromCenter(
          center: const Offset(landingX, _SadakahPhase.landingY + 1),
          width: width,
          height: width * 0.35),
      Paint()..color = const Color(0xFF3A3A3A).withOpacity(opacity),
    );
  }

  void _paintDrop(Canvas canvas) {
    if (!phase.dropVisible) return;
    final y = phase.dropY;
    final baseScale = phase.dropAppear;

    final scaleY = baseScale *
        (1.0 + (0.55 * phase.dropStretch) - (0.35 * phase.dropSquash));
    final scaleX = baseScale *
        (1.0 - (0.20 * phase.dropStretch) + (0.35 * phase.dropSquash));

    canvas.save();
    canvas.translate(landingX, y);
    canvas.scale(scaleX, scaleY);
    canvas.translate(-landingX, -y);

    final path = _teardropPath(Offset(landingX, y), 3.2);
    final gradient = ui.Gradient.radial(
      Offset(landingX - 1, y - 1),
      5,
      const [Color(0xFFE3F4FB), Color(0xFF7FBEDD), Color(0xFF4E93B8)],
      const [0.0, 0.6, 1.0],
    );
    canvas.drawPath(path, Paint()..shader = gradient);
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF4E93B8).withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );
    canvas.drawCircle(Offset(landingX - 1.1, y - 1.4), 0.7,
        Paint()..color = Colors.white.withOpacity(0.9));
    canvas.restore();
  }

  Path _teardropPath(Offset c, double r) {
    final path = Path();
    path.moveTo(c.dx, c.dy - r * 2);
    path.quadraticBezierTo(c.dx + r * 1.3, c.dy - r * 0.2, c.dx, c.dy + r);
    path.quadraticBezierTo(c.dx - r * 1.3, c.dy - r * 0.2, c.dx, c.dy - r * 2);
    path.close();
    return path;
  }

  void _paintSplash(Canvas canvas) {
    if (!phase.splashVisible) return;
    const landing = Offset(landingX, _SadakahPhase.landingY);
    final s = phase.splashT;

    for (final delay in [0.0, 0.25, 0.45]) {
      final local = ((s - delay) / (1 - delay)).clamp(0.0, 1.0);
      if (local <= 0) continue;
      final radius = 1.5 + (8.5 * Curves.easeOut.transform(local));
      final opacity = (1 - local) * 0.5;
      canvas.drawOval(
        Rect.fromCenter(
            center: landing, width: radius * 2.3, height: radius * 1.0),
        Paint()
          ..color = const Color(0xFF7FC2E0).withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8,
      );
    }

    if (phase.satelliteT > 0 && phase.satelliteT < 1) {
      final hop = (phase.satelliteT * (1 - phase.satelliteT)) * 4;
      final y = landing.dy - (hop * 3);
      canvas.drawCircle(
        Offset(landing.dx + 3, y),
        0.9 * (1 - phase.satelliteT) + 0.3,
        Paint()..color = const Color(0xFF9AD4EF).withOpacity(0.8),
      );
    }
  }

  void _paintSoil(Canvas canvas) {
    if (phase.soilScale <= 0) return;
    canvas.save();
    canvas.translate(landingX, _SadakahPhase.landingY);
    canvas.scale(phase.soilScale, phase.soilScale * 0.7);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 9, height: 3.4),
      Paint()..color = const Color(0xFF6B5138).withOpacity(0.5),
    );
    canvas.restore();
  }

  void _paintTree(Canvas canvas) {
    if (phase.trunkGrowth <= 0) return;

    const maxTrunkHeight = 12.0;
    const landing = Offset(landingX, _SadakahPhase.landingY);
    final tipY = landing.dy - (maxTrunkHeight * phase.trunkGrowth);

    final baseHalfWidth = 1.5;
    final tipHalfWidth = 0.5;
    final trunkPath = Path()
      ..moveTo(landing.dx - baseHalfWidth, landing.dy)
      ..quadraticBezierTo(
          landing.dx - baseHalfWidth * 0.6,
          landing.dy - (landing.dy - tipY) * 0.5,
          landing.dx - tipHalfWidth,
          tipY)
      ..lineTo(landing.dx + tipHalfWidth, tipY)
      ..quadraticBezierTo(
          landing.dx + baseHalfWidth * 0.6,
          landing.dy - (landing.dy - tipY) * 0.5,
          landing.dx + baseHalfWidth,
          landing.dy)
      ..close();
    canvas.drawPath(trunkPath, Paint()..color = const Color(0xFF8A6A4A));

    _paintLeaf(canvas, Offset(landingX, tipY + 3.5), phase.leaf1Scale,
        phase.leaf1Angle, -1);
    _paintLeaf(canvas, Offset(landingX, tipY + 3.5), phase.leaf2Scale,
        phase.leaf2Angle, 1);

    if (phase.canopyScale > 0) {
      canvas.save();
      canvas.translate(landingX, tipY);
      canvas.scale(phase.canopyScale, phase.canopyScale);
      canvas.drawCircle(
          const Offset(0, -3.0), 3.4, Paint()..color = const Color(0xFF6FAE5C));
      canvas.drawCircle(const Offset(-1.0, -3.8), 1.2,
          Paint()..color = const Color(0xFF8FC97D).withOpacity(0.8));
      canvas.restore();
    }
  }

  void _paintLeaf(
      Canvas canvas, Offset anchor, double scale, double angle, int side) {
    if (scale <= 0) return;
    canvas.save();
    canvas.translate(anchor.dx, anchor.dy);
    canvas.rotate(angle);
    canvas.scale(scale * side.sign.toDouble().abs(), scale);

    final leafPath = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(side * 3.2, -1.6, side * 5.2, 0)
      ..quadraticBezierTo(side * 3.2, 1.6, 0, 0)
      ..close();
    canvas.drawPath(
        leafPath, Paint()..color = const Color(0xFF5C9A4B).withOpacity(0.95));

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SadakahGrowthPainter oldDelegate) => true;
}
