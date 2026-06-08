import 'package:amal_tracker/features/auth/providers/provider_reset.dart';
import 'package:amal_tracker/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();

  String? _emailError;
  String? _passError;
  bool _submitted = false;
  bool _isLoggingIn = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  void _validateEmail(String v) {
    if (!_submitted) return;
    setState(() {
      if (v.isEmpty)
        _emailError = 'ইমেইল দিন';
      else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v))
        _emailError = 'সঠিক ইমেইল ঠিকানা দিন';
      else
        _emailError = null;
    });
  }

  void _validatePass(String v) {
    if (!_submitted) return;
    setState(() {
      if (v.isEmpty)
        _passError = 'পাসওয়ার্ড দিন';
      else if (v.length < 6)
        _passError = 'কমপক্ষে ৬ অক্ষর হতে হবে';
      else
        _passError = null;
    });
  }

  bool _validate() {
    setState(() {
      _submitted = true;
      final email = _emailCtrl.text.trim();
      final pass = _passCtrl.text;
      if (email.isEmpty)
        _emailError = 'ইমেইল দিন';
      else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email))
        _emailError = 'সঠিক ইমেইল ঠিকানা দিন';
      else
        _emailError = null;
      if (pass.isEmpty)
        _passError = 'পাসওয়ার্ড দিন';
      else if (pass.length < 6)
        _passError = 'কমপক্ষে ৬ অক্ষর হতে হবে';
      else
        _passError = null;
    });
    return _emailError == null && _passError == null;
  }

  Future<void> _login() async {
    if (_isLoggingIn) return;
    if (!_validate()) return;

    setState(() {
      _isLoggingIn = true;
    });

    ref.read(authProvider.notifier).clearError();
    final ok = await ref
        .read(authProvider.notifier)
        .login(_emailCtrl.text.trim(), _passCtrl.text);

    setState(() {
      _isLoggingIn = false;
    });

    if (ok) invalidateUserProviders(ref);

    if (ok && mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final isLoading = auth.isLoading || _isLoggingIn;

    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final hPad = isTablet ? ((size.width - 480) / 2) : 24.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: size.height * 0.38,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      child: CustomPaint(painter: _PatternPainter()),
                    ),
                  ),
                  Positioned(
                      top: 20,
                      right: -30,
                      child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.05)))),
                  Positioned(
                      bottom: 30,
                      left: -20,
                      child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.gold.withOpacity(0.08)))),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.28,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: hPad),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: AppRadius.lg_,
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.25)),
                            ),
                            child: const Icon(Icons.mosque_rounded,
                                color: Colors.white, size: 30),
                          ).animate().scale(
                              duration: 500.ms,
                              curve: Curves.elasticOut,
                              begin: const Offset(0.6, 0.6)),
                          const SizedBox(height: 16),
                          Text(
                            'স্বাগতম!',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ).animate(delay: 150.ms).fadeIn().slideX(begin: -0.2),
                          const SizedBox(height: 4),
                          Text(
                            'আপনার অ্যাকাউন্টে লগইন করুন',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.white.withOpacity(0.75),
                                ),
                          ).animate(delay: 250.ms).fadeIn().slideX(begin: -0.2),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPad),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.xxl_,
                        boxShadow: shadowLg(),
                      ),
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (auth.error != null) ...[
                            _ErrorBanner(auth.error!),
                            const SizedBox(height: 20),
                          ],
                          IgnorePointer(
                            ignoring: isLoading,
                            child: Opacity(
                              opacity: isLoading ? 0.6 : 1.0,
                              child: Column(
                                children: [
                                  _FieldWithError(
                                    label: 'ইমেইল ঠিকানা',
                                    icon: Icons.alternate_email_rounded,
                                    controller: _emailCtrl,
                                    focusNode: _emailFocus,
                                    hint: 'example@email.com',
                                    keyboardType: TextInputType.emailAddress,
                                    error: _emailError,
                                    onChanged: _validateEmail,
                                    onSubmit: () => _passFocus.requestFocus(),
                                  ),
                                  const SizedBox(height: 18),
                                  _PasswordFieldWithError(
                                    label: 'পাসওয়ার্ড',
                                    controller: _passCtrl,
                                    focusNode: _passFocus,
                                    hint: '••••••••',
                                    error: _passError,
                                    onChanged: _validatePass,
                                    onSubmit: _login,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          PrimaryButton(
                            onPressed: isLoading ? null : _login,
                            isLoading: isLoading,
                            label: 'লগইন করুন',
                            icon: Icons.login_rounded,
                          ).animate(delay: 450.ms).fadeIn().slideY(begin: 0.2),
                          const SizedBox(height: 24),
                          Center(
                            child: GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () {
                                      ref
                                          .read(authProvider.notifier)
                                          .clearError();
                                      context.go(AppRoutes.register);
                                    },
                              child: Opacity(
                                opacity: isLoading ? 0.5 : 1.0,
                                child: RichText(
                                  text: TextSpan(
                                    text: 'নতুন অ্যাকাউন্ট? ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: AppColors.textSecondary),
                                    children: [
                                      TextSpan(
                                        text: 'রেজিস্ট্রেশন করুন',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ).animate(delay: 500.ms).fadeIn(),
                        ],
                      ),
                    )
                        .animate(delay: 200.ms)
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: 0.15),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldWithError extends StatefulWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final TextInputType keyboardType;
  final String? error;
  final void Function(String) onChanged;
  final VoidCallback onSubmit;

  const _FieldWithError({
    required this.label,
    required this.icon,
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.keyboardType,
    this.error,
    required this.onChanged,
    required this.onSubmit,
  });

  @override
  State<_FieldWithError> createState() => _FieldWithErrorState();
}

class _FieldWithErrorState extends State<_FieldWithError> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(
        () => setState(() => _focused = widget.focusNode.hasFocus));
  }

  @override
  Widget build(BuildContext context) {
    final hasErr = widget.error != null && widget.error!.isNotEmpty;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.label,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: hasErr
                    ? AppColors.error
                    : (_focused ? AppColors.primary : AppColors.textPrimary),
                fontWeight: FontWeight.w600,
              )),
      const SizedBox(height: 6),
      AnimatedContainer(
        duration: 200.ms,
        decoration: BoxDecoration(
            borderRadius: AppRadius.md_,
            boxShadow: _focused
                ? [
                    BoxShadow(
                        color: (hasErr ? AppColors.error : AppColors.primary)
                            .withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4)),
                  ]
                : []),
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: TextInputAction.next,
          onEditingComplete: widget.onSubmit,
          onChanged: widget.onChanged,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
            prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Icon(widget.icon,
                    size: 20,
                    color: hasErr
                        ? AppColors.error
                        : (_focused
                            ? AppColors.primary
                            : AppColors.textSecondary))),
            prefixIconConstraints: const BoxConstraints(minWidth: 52),
            filled: true,
            fillColor: hasErr
                ? AppColors.error.withOpacity(0.04)
                : (_focused ? AppColors.surface : AppColors.surfaceAlt),
            border: OutlineInputBorder(
                borderRadius: AppRadius.md_,
                borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.md_,
                borderSide: BorderSide(
                    color: hasErr
                        ? AppColors.error.withOpacity(0.5)
                        : AppColors.border)),
            focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.md_,
                borderSide: BorderSide(
                    color: hasErr ? AppColors.error : AppColors.primary,
                    width: 2)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ),
      AnimatedSize(
          duration: 200.ms,
          child: hasErr
              ? Padding(
                  padding: const EdgeInsets.only(top: 6, left: 2),
                  child: Row(children: [
                    const Icon(Icons.error_rounded,
                        size: 13, color: AppColors.error),
                    const SizedBox(width: 5),
                    Text(widget.error!,
                        style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                  ]),
                )
              : const SizedBox.shrink()),
    ]);
  }
}

class _PasswordFieldWithError extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final String? error;
  final void Function(String) onChanged;
  final VoidCallback onSubmit;

  const _PasswordFieldWithError({
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.hint,
    this.error,
    required this.onChanged,
    required this.onSubmit,
  });

  @override
  State<_PasswordFieldWithError> createState() =>
      _PasswordFieldWithErrorState();
}

class _PasswordFieldWithErrorState extends State<_PasswordFieldWithError> {
  bool _focused = false, _obscure = true;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(
        () => setState(() => _focused = widget.focusNode.hasFocus));
  }

  @override
  Widget build(BuildContext context) {
    final hasErr = widget.error != null && widget.error!.isNotEmpty;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.label,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: hasErr
                    ? AppColors.error
                    : (_focused ? AppColors.primary : AppColors.textPrimary),
                fontWeight: FontWeight.w600,
              )),
      const SizedBox(height: 6),
      AnimatedContainer(
        duration: 200.ms,
        decoration: BoxDecoration(
            borderRadius: AppRadius.md_,
            boxShadow: _focused
                ? [
                    BoxShadow(
                        color: (hasErr ? AppColors.error : AppColors.primary)
                            .withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4)),
                  ]
                : []),
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: _obscure,
          textInputAction: TextInputAction.done,
          onEditingComplete: widget.onSubmit,
          onChanged: widget.onChanged,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
            prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Icon(Icons.lock_outline_rounded,
                    size: 20,
                    color: hasErr
                        ? AppColors.error
                        : (_focused
                            ? AppColors.primary
                            : AppColors.textSecondary))),
            prefixIconConstraints: const BoxConstraints(minWidth: 52),
            suffixIcon: IconButton(
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color:
                      _focused ? AppColors.primary : AppColors.textSecondary),
            ),
            filled: true,
            fillColor: hasErr
                ? AppColors.error.withOpacity(0.04)
                : (_focused ? AppColors.surface : AppColors.surfaceAlt),
            border: OutlineInputBorder(
                borderRadius: AppRadius.md_,
                borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.md_,
                borderSide: BorderSide(
                    color: hasErr
                        ? AppColors.error.withOpacity(0.5)
                        : AppColors.border)),
            focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.md_,
                borderSide: BorderSide(
                    color: hasErr ? AppColors.error : AppColors.primary,
                    width: 2)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ),
      AnimatedSize(
          duration: 200.ms,
          child: hasErr
              ? Padding(
                  padding: const EdgeInsets.only(top: 6, left: 2),
                  child: Row(children: [
                    const Icon(Icons.error_rounded,
                        size: 13, color: AppColors.error),
                    const SizedBox(width: 5),
                    Text(widget.error!,
                        style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                  ]),
                )
              : const SizedBox.shrink()),
    ]);
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner(this.message);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.errorPale,
          borderRadius: AppRadius.md_,
          border: Border.all(color: AppColors.error.withOpacity(0.25)),
        ),
        child: Row(children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.error, size: 18),
          const SizedBox(width: 10),
          Expanded(
              child: Text(message,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.error, fontWeight: FontWeight.w500))),
        ]),
      ).animate().shake(hz: 2, rotation: 0.008);
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    for (double i = 0; i < size.width + size.height; i += 32) {
      canvas.drawLine(Offset(i, 0), Offset(0, i), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
