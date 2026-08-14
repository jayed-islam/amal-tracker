import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';
import 'package:amal_tracker/core/router/app_router.dart';
import 'package:amal_tracker/core/services/api_service.dart';
import '../providers/auth_provider.dart';
import '../widgets/otp_input_widget.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  int _step = 0; // 0: Request Email, 1: Verify OTP, 2: New Password
  String? _resetToken;

  final _emailCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  final _emailFocus = FocusNode();
  final _newPassFocus = FocusNode();
  final _confirmPassFocus = FocusNode();

  bool _isLoading = false;
  String? _errorMessage;

  // Step 1 OTP Cooldown Timer
  Timer? _cooldownTimer;
  int _cooldownSeconds = 60;
  bool _canResend = false;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _emailCtrl.dispose();
    _otpCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    _emailFocus.dispose();
    _newPassFocus.dispose();
    _confirmPassFocus.dispose();
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

  // ── Step 0: Request OTP ──────────────────────────────────────────────────
  Future<void> _requestOtp() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      setState(() => _errorMessage = 'সঠিক ইমেইল ঠিকানা দিন');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authProvider.notifier).forgotPassword(email);
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _step = 1;
      });
      _startCooldownTimer(60);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'ওটিপি পাঠাতে সমস্যা হয়েছে। ইমেইল চেক করুন।';
      });
    }
  }

  // ── Step 1: Verify OTP ───────────────────────────────────────────────────
  Future<void> _verifyOtpCode() async {
    final code = _otpCtrl.text.trim();
    if (code.length != 6 || _isLoading) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await ref
          .read(authProvider.notifier)
          .verifyResetOtp(_emailCtrl.text.trim(), code);
      if (!mounted) return;

      setState(() {
        _resetToken = token;
        _isLoading = false;
        _step = 2;
      });
      HapticFeedback.mediumImpact();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
      HapticFeedback.vibrate();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'ওটিপি যাচাই করতে সমস্যা হয়েছে। আবার চেষ্টা করুন।';
      });
    }
  }

  Future<void> _resendResetOtp() async {
    if (!_canResend || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(authProvider.notifier)
          .forgotPassword(_emailCtrl.text.trim());
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _otpCtrl.clear();
      });
      _startCooldownTimer(60);

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
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'কোড পাঠাতে ব্যর্থ হয়েছে। আবার চেষ্টা করুন।';
      });
    }
  }

  // ── Step 2: Reset Password ───────────────────────────────────────────────
  Future<void> _submitNewPassword() async {
    final newPass = _newPassCtrl.text;
    final confirmPass = _confirmPassCtrl.text;

    if (newPass.length < 6) {
      setState(() => _errorMessage = 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষর হতে হবে');
      return;
    }

    if (newPass != confirmPass) {
      setState(() => _errorMessage = 'পাসওয়ার্ড দুটি মিলছে না');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final ok = await ref.read(authProvider.notifier).resetPassword(
          email: _emailCtrl.text.trim(),
          otp: _otpCtrl.text.trim(),
          resetToken: _resetToken,
          newPassword: newPass,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (ok) {
      HapticFeedback.selectionClick();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('পাসওয়ার্ড সফলভাবে পরিবর্তন করা হয়েছে!'),
            ],
          ),
          backgroundColor: context.colors.darkGreen,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      context.go(AppRoutes.login);
    } else {
      setState(() {
        _errorMessage =
            ref.read(authProvider).error ?? 'পাসওয়ার্ড রিসেট করতে ব্যর্থ হয়েছে';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            // Header Gradient
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
                    // Top Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded,
                              color: Colors.white),
                          onPressed: () {
                            if (_step > 0) {
                              setState(() {
                                _step--;
                                _errorMessage = null;
                              });
                            } else {
                              context.pop();
                            }
                          },
                        ),
                        TextButton.icon(
                          onPressed: () => context.go(AppRoutes.login),
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

                    // Hero Area
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
                            child: Icon(
                              _step == 0
                                  ? Icons.lock_reset_rounded
                                  : _step == 1
                                      ? Icons.mark_email_read_rounded
                                      : Icons.password_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ).animate().scale(
                                duration: 500.ms,
                                curve: Curves.elasticOut,
                                begin: const Offset(0.6, 0.6),
                              ),
                          const SizedBox(height: 14),
                          Text(
                            _step == 0
                                ? 'পাসওয়ার্ড পুনরুদ্ধার'
                                : _step == 1
                                    ? 'ওটিপি কোড যাচাই'
                                    : 'নতুন পাসওয়ার্ড দিন',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                            ),
                          ).animate().fadeIn().slideY(begin: -0.1),
                          const SizedBox(height: 4),
                          Text(
                            _step == 0
                                ? 'আপনার অ্যাকাউন্টের ইমেইল ঠিকানা লিখুন'
                                : _step == 1
                                    ? '${_emailCtrl.text} এ পাঠানো কোড দিন'
                                    : 'শক্তিশালী নতুন পাসওয়ার্ড সেট করুন',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 13,
                            ),
                          ).animate().fadeIn(),
                        ],
                      ),
                    ),

                    // Form Card
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
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_errorMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
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
                                ],
                              ),
                            ).animate().fadeIn().slideY(begin: -0.1),
                            const SizedBox(height: 16),
                          ],

                          // ── STEP 0: Email Input ────────────────────────────
                          if (_step == 0) ...[
                            Text(
                              'ইমেইল ঠিকানা',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: context.colors.textPri,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _emailCtrl,
                              focusNode: _emailFocus,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (_) {
                                if (_errorMessage != null) {
                                  setState(() => _errorMessage = null);
                                }
                              },
                              style: TextStyle(
                                fontSize: 14,
                                color: context.colors.textPri,
                              ),
                              decoration: InputDecoration(
                                hintText: 'আপনার ইমেইল লিখুন',
                                hintStyle: TextStyle(
                                    color: context.colors.textHint,
                                    fontSize: 13.5),
                                prefixIcon: Icon(
                                  Icons.alternate_email_rounded,
                                  color: context.colors.darkGreen,
                                  size: 20,
                                ),
                                filled: true,
                                fillColor: context.colors.inputBg,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                      color: context.colors.border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                      color: context.colors.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                      color: context.colors.darkGreen,
                                      width: 1.5),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _requestOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: context.colors.darkGreen,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        'ওটিপি কোড পাঠান',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                          ],

                          // ── STEP 1: Verify OTP ─────────────────────────────
                          if (_step == 1) ...[
                            OtpInputWidget(
                              controller: _otpCtrl,
                              disabled: _isLoading,
                              hasError: _errorMessage != null,
                              onChanged: (_) {
                                if (_errorMessage != null) {
                                  setState(() => _errorMessage = null);
                                }
                              },
                              onCompleted: (_) => _verifyOtpCode(),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 50,
                              child: ValueListenableBuilder<TextEditingValue>(
                                valueListenable: _otpCtrl,
                                builder: (context, value, child) {
                                  final isFull = value.text.trim().length == 6;
                                  return ElevatedButton(
                                    onPressed: (isFull && !_isLoading)
                                        ? _verifyOtpCode
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: context.colors.darkGreen,
                                      foregroundColor: Colors.white,
                                      disabledBackgroundColor: context
                                          .colors.borderLight
                                          .withOpacity(0.6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                            ),
                                          )
                                        : const Text(
                                            'কোড নিশ্চিত করুন',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: _canResend
                                  ? TextButton.icon(
                                      onPressed: _resendResetOtp,
                                      icon: Icon(
                                        Icons.refresh_rounded,
                                        size: 16,
                                        color: context.colors.darkGreen,
                                      ),
                                      label: Text(
                                        'পুনরায় কোড পাঠান',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: context.colors.darkGreen,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      '০০:${_cooldownSeconds.toString().padLeft(2, '0')} সেকেন্ড পর পুনরায় চেষ্টা করুন',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: context.colors.textMuted,
                                      ),
                                    ),
                            ),
                          ],

                          // ── STEP 2: New Password ───────────────────────────
                          if (_step == 2) ...[
                            Text(
                              'নতুন পাসওয়ার্ড',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: context.colors.textPri,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _newPassCtrl,
                              focusNode: _newPassFocus,
                              obscureText: true,
                              onChanged: (_) => setState(() {}),
                              style: TextStyle(
                                fontSize: 14,
                                color: context.colors.textPri,
                              ),
                              decoration: InputDecoration(
                                hintText: 'নতুন পাসওয়ার্ড লিখুন',
                                hintStyle: TextStyle(
                                    color: context.colors.textHint,
                                    fontSize: 13.5),
                                prefixIcon: Icon(
                                  Icons.lock_outline_rounded,
                                  color: context.colors.darkGreen,
                                  size: 20,
                                ),
                                filled: true,
                                fillColor: context.colors.inputBg,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                      color: context.colors.border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                      color: context.colors.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                      color: context.colors.darkGreen,
                                      width: 1.5),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'পাসওয়ার্ড নিশ্চিত করুন',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: context.colors.textPri,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _confirmPassCtrl,
                              focusNode: _confirmPassFocus,
                              obscureText: true,
                              style: TextStyle(
                                fontSize: 14,
                                color: context.colors.textPri,
                              ),
                              decoration: InputDecoration(
                                hintText: 'পাসওয়ার্ড আবার লিখুন',
                                hintStyle: TextStyle(
                                    color: context.colors.textHint,
                                    fontSize: 13.5),
                                prefixIcon: Icon(
                                  Icons.lock_reset_rounded,
                                  color: context.colors.darkGreen,
                                  size: 20,
                                ),
                                filled: true,
                                fillColor: context.colors.inputBg,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                      color: context.colors.border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                      color: context.colors.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                      color: context.colors.darkGreen,
                                      width: 1.5),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed:
                                    _isLoading ? null : _submitNewPassword,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: context.colors.darkGreen,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        'পাসওয়ার্ড আপডেট করুন',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ).animate().fadeIn().slideY(begin: 0.1),

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
