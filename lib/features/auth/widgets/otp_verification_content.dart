import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';
import 'package:amal_tracker/core/services/api_service.dart';
import '../providers/auth_provider.dart';
import 'otp_input_widget.dart';

class OtpVerificationContent extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;
  final bool isBottomSheet;

  const OtpVerificationContent({
    super.key,
    this.onSuccess,
    this.isBottomSheet = false,
  });

  @override
  ConsumerState<OtpVerificationContent> createState() =>
      _OtpVerificationContentState();
}

class _OtpVerificationContentState
    extends ConsumerState<OtpVerificationContent> {
  final TextEditingController _otpCtrl = TextEditingController();
  Timer? _cooldownTimer;
  int _cooldownSeconds = 60;
  bool _canResend = false;
  bool _isVerifying = false;
  bool _isResending = false;
  bool _isSuccess = false;
  bool _isLockedOut = false;
  bool _rateLimitExceeded = false;

  String? _errorMessage;
  int? _attemptsRemaining;

  @override
  void initState() {
    super.initState();
    _startCooldownTimer();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _otpCtrl.dispose();
    super.dispose();
  }

  void _startCooldownTimer([int seconds = 60]) {
    _cooldownTimer?.cancel();
    setState(() {
      _cooldownSeconds = seconds;
      _canResend = false;
    });

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_cooldownSeconds <= 1) {
        timer.cancel();
        setState(() {
          _cooldownSeconds = 0;
          _canResend = true;
        });
      } else {
        setState(() {
          _cooldownSeconds--;
        });
      }
    });
  }

  Future<void> _verify() async {
    final code = _otpCtrl.text.trim();
    if (code.length != 6 || _isVerifying || _isLockedOut) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      final success =
          await ref.read(authProvider.notifier).verifyOtp(code);
      if (!mounted) return;

      if (success) {
        setState(() {
          _isVerifying = false;
          _isSuccess = true;
        });
        HapticFeedback.mediumImpact();
        Future.delayed(const Duration(milliseconds: 900), () {
          if (!mounted) return;
          if (widget.onSuccess != null) {
            widget.onSuccess!();
          }
        });
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      final remaining = e.attemptsRemaining;
      final isMaxAttempts = e.code == 'MAX_ATTEMPTS_EXCEEDED' ||
          e.message.toLowerCase().contains('maximum') ||
          (remaining != null && remaining <= 0);

      final isExpired = e.code == 'OTP_EXPIRED' ||
          e.message.toLowerCase().contains('expired') ||
          e.message.contains('মেয়াদ');

      String msg = e.message;
      if (isMaxAttempts) {
        msg = 'সর্বোচ্চ চেষ্টার সীমা অতিক্রম হয়েছে। নতুন ওটিপি কোড পাঠান।';
      } else if (isExpired) {
        msg = 'ওটিপি-র মেয়াদ শেষ হয়ে গেছে। দয়া করে নতুন কোড পাঠান।';
      } else if (remaining != null && remaining > 0) {
        msg = 'ভুল ওটিপি কোড। আর $remaining বার চেষ্টা করতে পারবেন।';
      }

      setState(() {
        _isVerifying = false;
        _errorMessage = msg;
        _attemptsRemaining = remaining;
        _isLockedOut = isMaxAttempts;
      });
      HapticFeedback.vibrate();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isVerifying = false;
        _errorMessage = 'ওটিপি যাচাই করতে সমস্যা হয়েছে। আবার চেষ্টা করুন।';
      });
    }
  }

  Future<void> _resendCode() async {
    if ((!_canResend && !_isLockedOut) || _isResending) return;

    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    try {
      final cooldown = await ref.read(authProvider.notifier).resendOtp();
      if (!mounted) return;

      setState(() {
        _isResending = false;
        _isLockedOut = false;
        _attemptsRemaining = null;
        _rateLimitExceeded = false;
        _otpCtrl.clear();
      });

      _startCooldownTimer(cooldown > 0 ? cooldown : 60);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('নতুন ওটিপি কোড পাঠানো হয়েছে'),
          backgroundColor: context.colors.green,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      final cooldown = e.cooldownSeconds;
      final isRateLimit = e.code == 'RATE_LIMIT_EXCEEDED' ||
          e.statusCode == 429 ||
          e.message.toLowerCase().contains('limit');

      String msg = e.message;
      if (cooldown != null && cooldown > 0) {
        _startCooldownTimer(cooldown);
        msg = 'দয়া করে ০০:$cooldown সেকেন্ড অপেক্ষা করুন।';
      } else if (isRateLimit) {
        msg = 'আজকের মতো কোড পাঠানোর সীমা শেষ হয়েছে। পরবর্তীতে চেষ্টা করুন।';
      }

      setState(() {
        _isResending = false;
        _errorMessage = msg;
        _rateLimitExceeded = isRateLimit;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isResending = false;
        _errorMessage = 'কোড পুনরায় পাঠাতে ব্যর্থ হয়েছে। আবার চেষ্টা করুন।';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final email = user?.email ?? '';

    if (_isSuccess) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: context.colors.greenLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: context.colors.darkGreen,
                size: 48,
              ),
            ).animate().scale(
                  duration: 400.ms,
                  curve: Curves.elasticOut,
                ),
            const SizedBox(height: 18),
            Text(
              'ইমেইল যাচাই সফল হয়েছে!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: context.colors.textPri,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'আপনার ইমেইলটি সফলভাবে যাচাই করা হয়েছে।',
              style: TextStyle(
                fontSize: 13,
                color: context.colors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Subtitle with email highlight
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 13.5,
                  color: context.colors.textMuted,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: 'আপনার '),
                  TextSpan(
                    text: email.isNotEmpty ? email : 'ইমেইল',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: context.colors.darkGreen,
                    ),
                  ),
                  const TextSpan(
                    text: ' ঠিকানায় ৬ ডিজিটের ওটিপি কোডটি পাঠানো হয়েছে।',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // OTP Input boxes
            OtpInputWidget(
              controller: _otpCtrl,
              disabled: _isVerifying || _isLockedOut,
              hasError: _errorMessage != null,
              onChanged: (_) {
                if (_errorMessage != null) {
                  setState(() => _errorMessage = null);
                }
              },
              onCompleted: (code) {
                if (!_isVerifying && !_isLockedOut) {
                  _verify();
                }
              },
            ),
            const SizedBox(height: 12),

            // Error display if any
            if (_errorMessage != null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: context.colors.redLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: context.colors.red.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: context.colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: context.colors.red,
                        ),
                      ),
                    ),
                    if (_attemptsRemaining != null && _attemptsRemaining! > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: context.colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'বাকি: $_attemptsRemaining',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: context.colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
              ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.1, end: 0),
              const SizedBox(height: 12),
            ],

            // Verify button
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _otpCtrl,
              builder: (context, value, child) {
                final isFullCode = value.text.trim().length == 6;
                final canClick =
                    isFullCode && !_isVerifying && !_isLockedOut;

                return SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: canClick ? _verify : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.darkGreen,
                      disabledBackgroundColor:
                          context.colors.borderLight.withOpacity(0.6),
                      foregroundColor: Colors.white,
                      disabledForegroundColor: context.colors.textMuted,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isVerifying
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'ইমেইল যাচাই করুন',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Resend timer and action link
            Center(
              child: _isResending
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              context.colors.darkGreen,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ওটিপি পাঠানো হচ্ছে...',
                          style: TextStyle(
                            fontSize: 13,
                            color: context.colors.textMuted,
                          ),
                        ),
                      ],
                    )
                  : (_canResend || _isLockedOut)
                      ? TextButton.icon(
                          onPressed: _rateLimitExceeded ? null : _resendCode,
                          icon: Icon(
                            Icons.refresh_rounded,
                            size: 16,
                            color: _rateLimitExceeded
                                ? context.colors.textMuted
                                : context.colors.darkGreen,
                          ),
                          label: Text(
                            'কোড পাননি? পুনরায় কোড পাঠান',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _rateLimitExceeded
                                  ? context.colors.textMuted
                                  : context.colors.darkGreen,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                          ),
                        )
                      : Text(
                          '০০:${_cooldownSeconds.toString().padLeft(2, '0')} সেকেন্ড পর পুনরায় চেষ্টা করুন',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: context.colors.textMuted,
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
