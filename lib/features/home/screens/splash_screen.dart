import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  bool _logoVisible = false;
  bool _textVisible = false;
  bool _taglineVisible = false;
  bool _dotsVisible = false;

  @override
  void initState() {
    super.initState();
    _pulseCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(200.ms);
    if (mounted) setState(() => _logoVisible = true);
    await Future.delayed(400.ms);
    if (mounted) setState(() => _textVisible = true);
    await Future.delayed(300.ms);
    if (mounted) setState(() => _taglineVisible = true);
    await Future.delayed(300.ms);
    if (mounted) setState(() => _dotsVisible = true);
    await Future.delayed(1400.ms);
    if (!mounted) return;
    final isAuth = ref.read(isAuthenticatedProvider);
    context.go(isAuth ? AppRoutes.home : AppRoutes.login);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final isTablet = size.width >= 600;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: Stack(
          clipBehavior: Clip.none, // Allow circles to overflow
          children: [
            // Decorative background circles - Fixed positioning
            Positioned(
              top: -size.width * 0.25,
              right: -size.width * 0.15,
              child: Container(
                width: size.width * 0.6,
                height: size.width * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.12),
                ),
              ),
            ),
            Positioned(
              bottom: -size.width * 0.2,
              left: -size.width * 0.1,
              child: Container(
                width: size.width * 0.5,
                height: size.width * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold.withOpacity(0.07),
                ),
              ),
            ),
            // Center decorative circle
            Positioned(
              top: size.height * 0.3,
              left: -size.width * 0.3,
              child: Container(
                width: size.width * 0.8,
                height: size.width * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),

            // Subtle grid pattern overlay
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _GridPainter()),
              ),
            ),

            // Main content with proper responsive layout
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(flex: 2),

                            // Logo container with responsive sizing
                            AnimatedOpacity(
                              opacity: _logoVisible ? 1 : 0,
                              duration: 700.ms,
                              curve: Curves.easeOut,
                              child: AnimatedScale(
                                scale: _logoVisible ? 1 : 0.5,
                                duration: 700.ms,
                                curve: Curves.elasticOut,
                                child: ScaleTransition(
                                  scale: _pulseAnim,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Outer glow ring
                                      Container(
                                        width: isSmallScreen
                                            ? 100
                                            : (isTablet ? 160 : 120),
                                        height: isSmallScreen
                                            ? 100
                                            : (isTablet ? 160 : 120),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primary
                                              .withOpacity(0.15),
                                          border: Border.all(
                                            color: AppColors.primaryLight
                                                .withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      // Inner bg
                                      Container(
                                        width: isSmallScreen
                                            ? 80
                                            : (isTablet ? 130 : 96),
                                        height: isSmallScreen
                                            ? 80
                                            : (isTablet ? 130 : 96),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF2E8C5F),
                                              Color(0xFF1A6B45)
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primary
                                                  .withOpacity(0.5),
                                              blurRadius:
                                                  isSmallScreen ? 24 : 32,
                                              spreadRadius: 4,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.mosque_rounded,
                                          color: Colors.white,
                                          size: isSmallScreen
                                              ? 40
                                              : (isTablet ? 60 : 48),
                                        ),
                                      ),
                                      // Gold badge top-right
                                      Positioned(
                                        top: isSmallScreen ? 4 : 8,
                                        right: isSmallScreen ? 4 : 8,
                                        child: Container(
                                          width: isSmallScreen ? 18 : 22,
                                          height: isSmallScreen ? 18 : 22,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFFD4A843),
                                                Color(0xFFF0C96B)
                                              ],
                                            ),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: AppColors.gold
                                                      .withOpacity(0.5),
                                                  blurRadius: 8)
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.star_rounded,
                                            color: Colors.white,
                                            size: isSmallScreen ? 10 : 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: isSmallScreen ? 24 : 36),

                            // App name - Responsive typography
                            AnimatedOpacity(
                              opacity: _textVisible ? 1 : 0,
                              duration: 600.ms,
                              curve: Curves.easeOut,
                              child: AnimatedSlide(
                                offset: _textVisible
                                    ? Offset.zero
                                    : const Offset(0, 0.3),
                                duration: 600.ms,
                                curve: Curves.easeOut,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isSmallScreen ? 16 : 24,
                                      ),
                                      child: Text(
                                        'আমল ট্র্যাকার',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: isSmallScreen
                                              ? 24
                                              : (isTablet ? 44 : 32),
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          letterSpacing: -0.5,
                                          shadows: [
                                            Shadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              blurRadius: 16,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Gold divider
                                    Container(
                                      width: isSmallScreen ? 40 : 48,
                                      height: 2,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFD4A843),
                                            Color(0xFFF0C96B)
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: isSmallScreen ? 8 : 12),

                            // Tagline
                            AnimatedOpacity(
                              opacity: _taglineVisible ? 1 : 0,
                              duration: 500.ms,
                              curve: Curves.easeOut,
                              child: AnimatedSlide(
                                offset: _taglineVisible
                                    ? Offset.zero
                                    : const Offset(0, 0.2),
                                duration: 500.ms,
                                curve: Curves.easeOut,
                                child: Text(
                                  'Monthly Amal Tracker',
                                  style: TextStyle(
                                    fontSize: isSmallScreen
                                        ? 11
                                        : (isTablet ? 16 : 14),
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withOpacity(0.6),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),

                            const Spacer(flex: 3),

                            // Loading dots with proper centering
                            AnimatedOpacity(
                              opacity: _dotsVisible ? 1 : 0,
                              duration: 400.ms,
                              child: const _LoadingDots(),
                            ),

                            SizedBox(height: isSmallScreen ? 32 : 48),

                            // Bottom branding - Fixed positioning
                            AnimatedOpacity(
                              opacity: _taglineVisible ? 0.7 : 0,
                              duration: 600.ms,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: isSmallScreen ? 16 : 32),
                                child: Text(
                                  'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 14 : 16,
                                    color: Colors.white.withOpacity(0.35),
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _ctrls;
  late List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(
        3,
        (i) => AnimationController(
            vsync: this, duration: const Duration(milliseconds: 500))
          ..repeat(reverse: true));
    _anims = _ctrls
        .map((c) => Tween<double>(begin: 0.3, end: 1.0)
            .animate(CurvedAnimation(parent: c, curve: Curves.easeInOut)))
        .toList();
    Future.delayed(150.ms, () => _ctrls[1].forward());
    Future.delayed(300.ms, () => _ctrls[2].forward());
  }

  @override
  void dispose() {
    for (final c in _ctrls) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          3,
          (i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AnimatedBuilder(
              animation: _anims[i],
              builder: (_, __) => Opacity(
                opacity: _anims[i].value,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        i == 1 ? AppColors.gold : Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
