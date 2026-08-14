import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';
import 'package:amal_tracker/core/theme/app_colors.dart';
import 'package:amal_tracker/core/router/app_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/otp_verification_content.dart';

class OtpVerificationScreen extends ConsumerWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final hPad = isTablet ? (size.width - 480) / 2 : 24.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: context.colors.pageBg,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            // ── Decorative Top Gradient Header ──────────────────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: size.height * 0.36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [context.colors.darkGreen, context.colors.midGreen],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -40,
                      right: -30,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      left: -20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.colors.gold.withOpacity(0.09),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Main Scrollable Body ────────────────────────────────────────
            SafeArea(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(
                  hPad,
                  0,
                  hPad,
                  MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Column(
                  children: [
                    // Top Bar Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (Navigator.of(context).canPop())
                          IconButton(
                            icon: const Icon(Icons.arrow_back_rounded,
                                color: Colors.white),
                            onPressed: () => context.pop(),
                          )
                        else
                          const SizedBox(width: 48),
                        TextButton.icon(
                          onPressed: () {
                            context.go(AppRoutes.login);
                          },
                          icon: const Icon(Icons.close_rounded,
                              size: 16, color: Colors.white),
                          label: Text(
                            'বাতিল করুন',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ── Hero Section ─────────────────────────────────────────
                    SizedBox(
                      height: size.height * 0.22,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.25),
                              ),
                            ),
                            child: const Icon(
                              Icons.mark_email_read_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ).animate().scale(
                                duration: 500.ms,
                                curve: Curves.elasticOut,
                                begin: const Offset(0.6, 0.6),
                              ),
                          const SizedBox(height: 14),
                          const Text(
                            'ইমেইল যাচাইকরণ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                            ),
                          ).animate(delay: 100.ms).fadeIn().slideY(begin: -0.1),
                          const SizedBox(height: 4),
                          Text(
                            'নিরাপত্তার জন্য ওটিপি কোড নিশ্চিত করুন',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 13.5,
                            ),
                          ).animate(delay: 150.ms).fadeIn(),
                        ],
                      ),
                    ),

                    // ── Form Card ───────────────────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: context.colors.cardBg,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: OtpVerificationContent(
                        isBottomSheet: false,
                        onSuccess: () {
                          context.go(AppRoutes.home);
                        },
                      ),
                    ).animate(delay: 180.ms).fadeIn().slideY(begin: 0.1),

                    const SizedBox(height: 24),

                    // ── Bottom Link ──────────────────────────────────────────
                    GestureDetector(
                      onTap: () {
                        context.go(AppRoutes.login);
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'ভুল ইমেইল দিয়েছেন?  ',
                          style: TextStyle(
                            color: context.colors.textSecondary,
                            fontSize: 13.5,
                          ),
                          children: [
                            TextSpan(
                              text: 'লগইন বা রেজিস্টারে ফিরে যান',
                              style: TextStyle(
                                color: context.colors.darkGreen,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate(delay: 350.ms).fadeIn(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
