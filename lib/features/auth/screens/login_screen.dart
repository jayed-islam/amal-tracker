// import 'package:amal_tracker/features/auth/providers/provider_reset.dart';
// import 'package:amal_tracker/features/auth/widgets/recovery_banner.dart';
// import 'package:amal_tracker/shared/widgets/primary_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../providers/auth_provider.dart';
// import '../../../core/router/app_router.dart';
// import '../../../core/theme/app_theme.dart';

// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({super.key});
//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   final _emailCtrl = TextEditingController();
//   final _passCtrl = TextEditingController();
//   final _emailFocus = FocusNode();
//   final _passFocus = FocusNode();

//   String? _emailError;
//   String? _passError;
//   bool _submitted = false;
//   bool _isLoggingIn = false;

//   @override
//   void dispose() {
//     _emailCtrl.dispose();
//     _passCtrl.dispose();
//     _emailFocus.dispose();
//     _passFocus.dispose();
//     super.dispose();
//   }

//   void _validateEmail(String v) {
//     if (!_submitted) return;
//     setState(() {
//       if (v.isEmpty)
//         _emailError = 'ইমেইল দিন';
//       else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v))
//         _emailError = 'সঠিক ইমেইল ঠিকানা দিন';
//       else
//         _emailError = null;
//     });
//   }

//   void _validatePass(String v) {
//     if (!_submitted) return;
//     setState(() {
//       if (v.isEmpty)
//         _passError = 'পাসওয়ার্ড দিন';
//       else if (v.length < 6)
//         _passError = 'কমপক্ষে ৬ অক্ষর হতে হবে';
//       else
//         _passError = null;
//     });
//   }

//   bool _validate() {
//     setState(() {
//       _submitted = true;
//       final email = _emailCtrl.text.trim();
//       final pass = _passCtrl.text;
//       if (email.isEmpty)
//         _emailError = 'ইমেইল দিন';
//       else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email))
//         _emailError = 'সঠিক ইমেইল ঠিকানা দিন';
//       else
//         _emailError = null;
//       if (pass.isEmpty)
//         _passError = 'পাসওয়ার্ড দিন';
//       else if (pass.length < 6)
//         _passError = 'কমপক্ষে ৬ অক্ষর হতে হবে';
//       else
//         _passError = null;
//     });
//     return _emailError == null && _passError == null;
//   }

//   Future<void> _login() async {
//     if (_isLoggingIn) return;
//     if (!_validate()) return;

//     setState(() {
//       _isLoggingIn = true;
//     });

//     ref.read(authProvider.notifier).clearError();
//     final ok = await ref
//         .read(authProvider.notifier)
//         .login(_emailCtrl.text.trim(), _passCtrl.text);

//     setState(() {
//       _isLoggingIn = false;
//     });

//     if (ok) invalidateUserProviders(ref);

//     if (ok && mounted) context.go(AppRoutes.home);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = ref.watch(authProvider);
//     final isLoading = auth.isLoading || _isLoggingIn;

//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;
//     final hPad = isTablet ? ((size.width - 480) / 2) : 24.0;

//     final pendingDeletion = ref.watch(pendingDeletionProvider);

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: Stack(
//         children: [
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: SizedBox(
//               height: size.height * 0.38,
//               child: Stack(
//                 children: [
//                   Container(
//                     decoration: const BoxDecoration(
//                       gradient: AppColors.brandGradient,
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(40),
//                         bottomRight: Radius.circular(40),
//                       ),
//                     ),
//                   ),
//                   Positioned.fill(
//                     child: ClipRRect(
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(40),
//                         bottomRight: Radius.circular(40),
//                       ),
//                       child: CustomPaint(painter: _PatternPainter()),
//                     ),
//                   ),
//                   Positioned(
//                       top: 20,
//                       right: -30,
//                       child: Container(
//                           width: 120,
//                           height: 120,
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.white.withOpacity(0.05)))),
//                   Positioned(
//                       bottom: 30,
//                       left: -20,
//                       child: Container(
//                           width: 80,
//                           height: 80,
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: AppColors.gold.withOpacity(0.08)))),
//                 ],
//               ),
//             ),
//           ),
//           SafeArea(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: size.height * 0.28,
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: hPad),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             width: 56,
//                             height: 56,
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.15),
//                               borderRadius: AppRadius.lg_,
//                               border: Border.all(
//                                   color: Colors.white.withOpacity(0.25)),
//                             ),
//                             child: const Icon(Icons.mosque_rounded,
//                                 color: Colors.white, size: 30),
//                           ).animate().scale(
//                               duration: 500.ms,
//                               curve: Curves.elasticOut,
//                               begin: const Offset(0.6, 0.6)),
//                           const SizedBox(height: 16),
//                           Text(
//                             'স্বাগতম!',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .headlineMedium!
//                                 .copyWith(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w800,
//                                 ),
//                           ).animate(delay: 150.ms).fadeIn().slideX(begin: -0.2),
//                           const SizedBox(height: 4),
//                           Text(
//                             'আপনার অ্যাকাউন্টে লগইন করুন',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyMedium!
//                                 .copyWith(
//                                   color: Colors.white.withOpacity(0.75),
//                                 ),
//                           ).animate(delay: 250.ms).fadeIn().slideX(begin: -0.2),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: hPad),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: AppColors.surface,
//                         borderRadius: AppRadius.xxl_,
//                         boxShadow: shadowLg(),
//                       ),
//                       padding: const EdgeInsets.all(28),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (auth.error != null) ...[
//                             _ErrorBanner(auth.error!),
//                             const SizedBox(height: 20),
//                           ],
//                           // Place this above your login form:
//                           if (pendingDeletion != null)
//                             RecoveryBanner(info: pendingDeletion),
//                           IgnorePointer(
//                             ignoring: isLoading,
//                             child: Opacity(
//                               opacity: isLoading ? 0.6 : 1.0,
//                               child: Column(
//                                 children: [
//                                   _FieldWithError(
//                                     label: 'ইমেইল ঠিকানা',
//                                     icon: Icons.alternate_email_rounded,
//                                     controller: _emailCtrl,
//                                     focusNode: _emailFocus,
//                                     hint: 'example@email.com',
//                                     keyboardType: TextInputType.emailAddress,
//                                     error: _emailError,
//                                     onChanged: _validateEmail,
//                                     onSubmit: () => _passFocus.requestFocus(),
//                                   ),
//                                   const SizedBox(height: 18),
//                                   _PasswordFieldWithError(
//                                     label: 'পাসওয়ার্ড',
//                                     controller: _passCtrl,
//                                     focusNode: _passFocus,
//                                     hint: '••••••••',
//                                     error: _passError,
//                                     onChanged: _validatePass,
//                                     onSubmit: _login,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 28),
//                           PrimaryButton(
//                             onPressed: isLoading ? null : _login,
//                             isLoading: isLoading,
//                             label: 'লগইন করুন',
//                             icon: Icons.login_rounded,
//                           ).animate(delay: 450.ms).fadeIn().slideY(begin: 0.2),
//                           const SizedBox(height: 24),
//                           Center(
//                             child: GestureDetector(
//                               onTap: isLoading
//                                   ? null
//                                   : () {
//                                       ref
//                                           .read(authProvider.notifier)
//                                           .clearError();
//                                       context.go(AppRoutes.register);
//                                     },
//                               child: Opacity(
//                                 opacity: isLoading ? 0.5 : 1.0,
//                                 child: RichText(
//                                   text: TextSpan(
//                                     text: 'নতুন অ্যাকাউন্ট? ',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodyMedium!
//                                         .copyWith(
//                                             color: AppColors.textSecondary),
//                                     children: [
//                                       TextSpan(
//                                         text: 'রেজিস্ট্রেশন করুন',
//                                         style: TextStyle(
//                                           color: AppColors.primary,
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ).animate(delay: 500.ms).fadeIn(),
//                         ],
//                       ),
//                     )
//                         .animate(delay: 200.ms)
//                         .fadeIn(duration: 500.ms)
//                         .slideY(begin: 0.15),
//                   ),
//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _FieldWithError extends StatefulWidget {
//   final String label;
//   final IconData icon;
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final String hint;
//   final TextInputType keyboardType;
//   final String? error;
//   final void Function(String) onChanged;
//   final VoidCallback onSubmit;

//   const _FieldWithError({
//     required this.label,
//     required this.icon,
//     required this.controller,
//     required this.focusNode,
//     required this.hint,
//     required this.keyboardType,
//     this.error,
//     required this.onChanged,
//     required this.onSubmit,
//   });

//   @override
//   State<_FieldWithError> createState() => _FieldWithErrorState();
// }

// class _FieldWithErrorState extends State<_FieldWithError> {
//   bool _focused = false;

//   @override
//   void initState() {
//     super.initState();
//     widget.focusNode.addListener(
//         () => setState(() => _focused = widget.focusNode.hasFocus));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hasErr = widget.error != null && widget.error!.isNotEmpty;
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Text(widget.label,
//           style: Theme.of(context).textTheme.labelLarge!.copyWith(
//                 color: hasErr
//                     ? AppColors.error
//                     : (_focused ? AppColors.primary : AppColors.textPrimary),
//                 fontWeight: FontWeight.w600,
//               )),
//       const SizedBox(height: 6),
//       AnimatedContainer(
//         duration: 200.ms,
//         decoration: BoxDecoration(
//             borderRadius: AppRadius.md_,
//             boxShadow: _focused
//                 ? [
//                     BoxShadow(
//                         color: (hasErr ? AppColors.error : AppColors.primary)
//                             .withOpacity(0.12),
//                         blurRadius: 12,
//                         offset: const Offset(0, 4)),
//                   ]
//                 : []),
//         child: TextField(
//           controller: widget.controller,
//           focusNode: widget.focusNode,
//           keyboardType: widget.keyboardType,
//           textInputAction: TextInputAction.next,
//           onEditingComplete: widget.onSubmit,
//           onChanged: widget.onChanged,
//           style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//               color: AppColors.textPrimary, fontWeight: FontWeight.w500),
//           decoration: InputDecoration(
//             hintText: widget.hint,
//             hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
//             prefixIcon: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 14),
//                 child: Icon(widget.icon,
//                     size: 20,
//                     color: hasErr
//                         ? AppColors.error
//                         : (_focused
//                             ? AppColors.primary
//                             : AppColors.textSecondary))),
//             prefixIconConstraints: const BoxConstraints(minWidth: 52),
//             filled: true,
//             fillColor: hasErr
//                 ? AppColors.error.withOpacity(0.04)
//                 : (_focused ? AppColors.surface : AppColors.surfaceAlt),
//             border: OutlineInputBorder(
//                 borderRadius: AppRadius.md_,
//                 borderSide: const BorderSide(color: AppColors.border)),
//             enabledBorder: OutlineInputBorder(
//                 borderRadius: AppRadius.md_,
//                 borderSide: BorderSide(
//                     color: hasErr
//                         ? AppColors.error.withOpacity(0.5)
//                         : AppColors.border)),
//             focusedBorder: OutlineInputBorder(
//                 borderRadius: AppRadius.md_,
//                 borderSide: BorderSide(
//                     color: hasErr ? AppColors.error : AppColors.primary,
//                     width: 2)),
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           ),
//         ),
//       ),
//       AnimatedSize(
//           duration: 200.ms,
//           child: hasErr
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 6, left: 2),
//                   child: Row(children: [
//                     const Icon(Icons.error_rounded,
//                         size: 13, color: AppColors.error),
//                     const SizedBox(width: 5),
//                     Text(widget.error!,
//                         style: const TextStyle(
//                             color: AppColors.error,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500)),
//                   ]),
//                 )
//               : const SizedBox.shrink()),
//     ]);
//   }
// }

// class _PasswordFieldWithError extends StatefulWidget {
//   final String label;
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final String hint;
//   final String? error;
//   final void Function(String) onChanged;
//   final VoidCallback onSubmit;

//   const _PasswordFieldWithError({
//     required this.label,
//     required this.controller,
//     required this.focusNode,
//     required this.hint,
//     this.error,
//     required this.onChanged,
//     required this.onSubmit,
//   });

//   @override
//   State<_PasswordFieldWithError> createState() =>
//       _PasswordFieldWithErrorState();
// }

// class _PasswordFieldWithErrorState extends State<_PasswordFieldWithError> {
//   bool _focused = false, _obscure = true;

//   @override
//   void initState() {
//     super.initState();
//     widget.focusNode.addListener(
//         () => setState(() => _focused = widget.focusNode.hasFocus));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hasErr = widget.error != null && widget.error!.isNotEmpty;
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Text(widget.label,
//           style: Theme.of(context).textTheme.labelLarge!.copyWith(
//                 color: hasErr
//                     ? AppColors.error
//                     : (_focused ? AppColors.primary : AppColors.textPrimary),
//                 fontWeight: FontWeight.w600,
//               )),
//       const SizedBox(height: 6),
//       AnimatedContainer(
//         duration: 200.ms,
//         decoration: BoxDecoration(
//             borderRadius: AppRadius.md_,
//             boxShadow: _focused
//                 ? [
//                     BoxShadow(
//                         color: (hasErr ? AppColors.error : AppColors.primary)
//                             .withOpacity(0.12),
//                         blurRadius: 12,
//                         offset: const Offset(0, 4)),
//                   ]
//                 : []),
//         child: TextField(
//           controller: widget.controller,
//           focusNode: widget.focusNode,
//           obscureText: _obscure,
//           textInputAction: TextInputAction.done,
//           onEditingComplete: widget.onSubmit,
//           onChanged: widget.onChanged,
//           style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//               color: AppColors.textPrimary, fontWeight: FontWeight.w500),
//           decoration: InputDecoration(
//             hintText: widget.hint,
//             hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
//             prefixIcon: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 14),
//                 child: Icon(Icons.lock_outline_rounded,
//                     size: 20,
//                     color: hasErr
//                         ? AppColors.error
//                         : (_focused
//                             ? AppColors.primary
//                             : AppColors.textSecondary))),
//             prefixIconConstraints: const BoxConstraints(minWidth: 52),
//             suffixIcon: IconButton(
//               onPressed: () => setState(() => _obscure = !_obscure),
//               icon: Icon(
//                   _obscure
//                       ? Icons.visibility_outlined
//                       : Icons.visibility_off_outlined,
//                   size: 20,
//                   color:
//                       _focused ? AppColors.primary : AppColors.textSecondary),
//             ),
//             filled: true,
//             fillColor: hasErr
//                 ? AppColors.error.withOpacity(0.04)
//                 : (_focused ? AppColors.surface : AppColors.surfaceAlt),
//             border: OutlineInputBorder(
//                 borderRadius: AppRadius.md_,
//                 borderSide: const BorderSide(color: AppColors.border)),
//             enabledBorder: OutlineInputBorder(
//                 borderRadius: AppRadius.md_,
//                 borderSide: BorderSide(
//                     color: hasErr
//                         ? AppColors.error.withOpacity(0.5)
//                         : AppColors.border)),
//             focusedBorder: OutlineInputBorder(
//                 borderRadius: AppRadius.md_,
//                 borderSide: BorderSide(
//                     color: hasErr ? AppColors.error : AppColors.primary,
//                     width: 2)),
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           ),
//         ),
//       ),
//       AnimatedSize(
//           duration: 200.ms,
//           child: hasErr
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 6, left: 2),
//                   child: Row(children: [
//                     const Icon(Icons.error_rounded,
//                         size: 13, color: AppColors.error),
//                     const SizedBox(width: 5),
//                     Text(widget.error!,
//                         style: const TextStyle(
//                             color: AppColors.error,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500)),
//                   ]),
//                 )
//               : const SizedBox.shrink()),
//     ]);
//   }
// }

// class _ErrorBanner extends StatelessWidget {
//   final String message;
//   const _ErrorBanner(this.message);

//   @override
//   Widget build(BuildContext context) => Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         decoration: BoxDecoration(
//           color: AppColors.errorPale,
//           borderRadius: AppRadius.md_,
//           border: Border.all(color: AppColors.error.withOpacity(0.25)),
//         ),
//         child: Row(children: [
//           const Icon(Icons.error_outline_rounded,
//               color: AppColors.error, size: 18),
//           const SizedBox(width: 10),
//           Expanded(
//               child: Text(message,
//                   style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                       color: AppColors.error, fontWeight: FontWeight.w500))),
//         ]),
//       ).animate().shake(hz: 2, rotation: 0.008);
// }

// class _PatternPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white.withOpacity(0.04)
//       ..strokeWidth = 1
//       ..style = PaintingStyle.stroke;
//     for (double i = 0; i < size.width + size.height; i += 32) {
//       canvas.drawLine(Offset(i, 0), Offset(0, i), paint);
//     }
//   }

//   @override
//   bool shouldRepaint(_) => false;
// }
import 'package:amal_tracker/features/auth/providers/provider_reset.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/primary_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LOGIN SCREEN
// ─────────────────────────────────────────────────────────────────────────────

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
  final _scrollCtrl = ScrollController();

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
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Validation ──────────────────────────────────────────────────────────────

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
      _emailError = email.isEmpty
          ? 'ইমেইল দিন'
          : !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
              ? 'সঠিক ইমেইল ঠিকানা দিন'
              : null;
      _passError = pass.isEmpty
          ? 'পাসওয়ার্ড দিন'
          : pass.length < 6
              ? 'কমপক্ষে ৬ অক্ষর হতে হবে'
              : null;
    });
    return _emailError == null && _passError == null;
  }

  // ── Login ───────────────────────────────────────────────────────────────────

  Future<void> _login() async {
    if (_isLoggingIn) return;
    // Dismiss keyboard first so layout settles
    FocusScope.of(context).unfocus();

    if (!_validate()) return;

    setState(() => _isLoggingIn = true);
    ref.read(authProvider.notifier).clearError();

    final ok = await ref
        .read(authProvider.notifier)
        .login(_emailCtrl.text.trim(), _passCtrl.text);

    if (!mounted) return;
    setState(() => _isLoggingIn = false);

    if (ok) {
      invalidateUserProviders(ref);
      context.go(AppRoutes.home);
    }
    // error & pendingDeletion are in AuthState — UI rebuilds automatically
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final pendingDeletion = ref.watch(pendingDeletionProvider);
    final isLoading = auth.isLoading || _isLoggingIn;

    final mq = MediaQuery.of(context);
    final size = mq.size;
    final isTablet = size.width > 600;
    final hPad = isTablet ? (size.width - 480) / 2 : 24.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      // ↓ CRITICAL: lets the scaffold shrink when keyboard opens
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ── Decorative header gradient ────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: size.height * 0.38,
              child: Stack(children: [
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
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gold.withOpacity(0.08),
                    ),
                  ),
                ),
              ]),
            ),
          ),

          // ── Scrollable body — grows to push button above keyboard ─────────
          SafeArea(
            child: Column(
              children: [
                // Hero area — fixed height, shrinks with keyboard via SafeArea
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
                              begin: const Offset(0.6, 0.6),
                            ),
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
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.white.withOpacity(0.75),
                                  ),
                        ).animate(delay: 250.ms).fadeIn().slideX(begin: -0.2),
                      ],
                    ),
                  ),
                ),

                // ── Form card — scrollable so button stays visible ────────────
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollCtrl,
                    // Smooth scroll that doesn't fight keyboard animation
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      hPad,
                      0,
                      hPad,
                      // Extra bottom padding = keyboard height + safe area
                      mq.viewInsets.bottom + mq.padding.bottom + 24,
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: AppRadius.xxl_,
                            boxShadow: shadowLg(),
                          ),
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Recovery banner (grace period) ─────────────
                              if (pendingDeletion != null) ...[
                                RecoveryBanner(info: pendingDeletion),
                                const SizedBox(height: 20),
                              ],

                              // ── Fields ──────────────────────────────────────
                              IgnorePointer(
                                ignoring: isLoading,
                                child: Opacity(
                                  opacity: isLoading ? 0.6 : 1.0,
                                  child: Column(children: [
                                    _LoginField(
                                      label: 'ইমেইল ঠিকানা',
                                      icon: Icons.alternate_email_rounded,
                                      controller: _emailCtrl,
                                      focusNode: _emailFocus,
                                      hint: 'example@email.com',
                                      keyboardType: TextInputType.emailAddress,
                                      error: _emailError,
                                      // API-level error shown inline under email
                                      apiError: (pendingDeletion == null)
                                          ? auth.error
                                          : null,
                                      onChanged: _validateEmail,
                                      onSubmit: () => _passFocus.requestFocus(),
                                    ),
                                    const SizedBox(height: 18),
                                    _PasswordField(
                                      label: 'পাসওয়ার্ড',
                                      controller: _passCtrl,
                                      focusNode: _passFocus,
                                      hint: '••••••••',
                                      error: _passError,
                                      onChanged: _validatePass,
                                      onSubmit: _login,
                                    ),
                                  ]),
                                ),
                              ),

                              const SizedBox(height: 28),

                              // ── Login button ────────────────────────────────
                              PrimaryButton(
                                onPressed: isLoading ? null : _login,
                                isLoading: isLoading,
                                label: 'লগইন করুন',
                                icon: Icons.login_rounded,
                              )
                                  .animate(delay: 450.ms)
                                  .fadeIn()
                                  .slideY(begin: 0.2),

                              const SizedBox(height: 24),

                              // ── Register link ───────────────────────────────
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
                        const SizedBox(height: 16),
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
// RECOVERY BANNER  (grace period — same _C amber style as settings screen)
// ─────────────────────────────────────────────────────────────────────────────

class RecoveryBanner extends ConsumerStatefulWidget {
  final PendingDeletionInfo info;
  const RecoveryBanner({super.key, required this.info});

  @override
  ConsumerState<RecoveryBanner> createState() => _RecoveryBannerState();
}

class _RecoveryBannerState extends ConsumerState<RecoveryBanner> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _expanded = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _recover() async {
    if (_emailCtrl.text.trim().isEmpty || _passCtrl.text.isEmpty) return;
    HapticFeedback.selectionClick();

    final ok =
        await ref.read(authProvider.notifier).cancelDeletionWithCredentials(
              _emailCtrl.text.trim(),
              _passCtrl.text,
            );

    if (!mounted) return;
    if (!ok) {
      // error is already in auth.error — field shows it inline
      setState(() {}); // trigger rebuild so _LoginField shows apiError
    }
    // success → GoRouter redirects automatically (authProvider = authenticated)
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final isLoading = auth.isLoading;

    return AnimatedSize(
      duration: 280.ms,
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: Row(children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.hourglass_top_rounded,
                      color: Color(0xFFF59E0B), size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'অ্যাকাউন্ট মুছে ফেলার প্রক্রিয়ায়',
                        style: TextStyle(
                          color: Color(0xFF92400E),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${widget.info.daysLeft} দিন বাকি আছে',
                        style: const TextStyle(
                          color: Color(0xFFF59E0B),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),

            // ── Collapsed: single recover button ────────────────────────────
            if (!_expanded) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => _expanded = true),
                    icon: const Icon(Icons.restore_rounded, size: 16),
                    label: const Text('অ্যাকাউন্ট ফিরিয়ে আনুন'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11)),
                      textStyle: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],

            // ── Expanded: credential fields ──────────────────────────────────
            if (_expanded) ...[
              const Padding(
                padding: EdgeInsets.fromLTRB(14, 10, 14, 0),
                child: Text(
                  'আপনার ইমেইল ও পাসওয়ার্ড দিয়ে নিশ্চিত করুন',
                  style: TextStyle(
                    color: Color(0xFF92400E),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: _RecoveryField(
                  controller: _emailCtrl,
                  hint: 'ইমেইল',
                  icon: Icons.alternate_email_rounded,
                  keyboardType: TextInputType.emailAddress,
                  // Show API error under email field
                  errorText: auth.error,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: _RecoveryField(
                  controller: _passCtrl,
                  hint: 'পাসওয়ার্ড',
                  icon: Icons.lock_outline_rounded,
                  obscure: _obscure,
                  onToggleObscure: () => setState(() => _obscure = !_obscure),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Row(children: [
                  // Cancel
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        onPressed: isLoading
                            ? null
                            : () => setState(() => _expanded = false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF92400E),
                          side: BorderSide(
                              color: const Color(0xFFF59E0B).withOpacity(0.4)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11)),
                        ),
                        child: const Text('বাতিল',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Confirm
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _recover,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF59E0B),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11)),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('নিশ্চিত করুন',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Small amber-tinted field used inside RecoveryBanner
class _RecoveryField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final TextInputType keyboardType;
  final String? errorText;

  const _RecoveryField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.onToggleObscure,
    this.keyboardType = TextInputType.text,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 13.5, color: Color(0xFF0A1A0F)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFABBAAE), fontSize: 13),
            isDense: true,
            filled: true,
            fillColor: const Color(0xFFFFFBF0),
            prefixIcon: Icon(icon, size: 17, color: const Color(0xFFF59E0B)),
            suffixIcon: onToggleObscure != null
                ? IconButton(
                    onPressed: onToggleObscure,
                    icon: Icon(
                      obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 17,
                      color: const Color(0xFFF59E0B),
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: const Color(0xFFF59E0B).withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: const Color(0xFFF59E0B).withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color(0xFFF59E0B), width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        // Inline error under the field
        if (errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 2),
            child: Row(children: [
              const Icon(Icons.error_rounded,
                  size: 12, color: Color(0xFFEF4444)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(errorText!,
                    style: const TextStyle(
                        color: Color(0xFFEF4444),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500)),
              ),
            ]),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LOGIN FIELD  (email / generic)
// Shows both inline validation error AND api-level error under the field
// so the user never has to scroll to find what went wrong
// ─────────────────────────────────────────────────────────────────────────────

class _LoginField extends StatefulWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final TextInputType keyboardType;
  final String? error;
  final String? apiError; // shown when no validation error present
  final void Function(String) onChanged;
  final VoidCallback onSubmit;

  const _LoginField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.keyboardType,
    this.error,
    this.apiError,
    required this.onChanged,
    required this.onSubmit,
  });

  @override
  State<_LoginField> createState() => _LoginFieldState();
}

class _LoginFieldState extends State<_LoginField> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(
        () => setState(() => _focused = widget.focusNode.hasFocus));
  }

  @override
  Widget build(BuildContext context) {
    // Validation error takes priority; fall back to API error
    final displayError = (widget.error != null && widget.error!.isNotEmpty)
        ? widget.error
        : (widget.apiError != null && widget.apiError!.isNotEmpty)
            ? widget.apiError
            : null;
    final hasErr = displayError != null;

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
                      offset: const Offset(0, 4))
                ]
              : [],
        ),
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
                          : AppColors.textSecondary)),
            ),
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
                  Icon(Icons.error_rounded,
                      size: 13,
                      color: displayError == widget.apiError
                          ? AppColors.error
                          : AppColors.error),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(displayError!,
                        style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                  ),
                ]),
              )
            : const SizedBox.shrink(),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PASSWORD FIELD
// ─────────────────────────────────────────────────────────────────────────────

class _PasswordField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final String? error;
  final void Function(String) onChanged;
  final VoidCallback onSubmit;

  const _PasswordField({
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.hint,
    this.error,
    required this.onChanged,
    required this.onSubmit,
  });

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _focused = false;
  bool _obscure = true;

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
                      offset: const Offset(0, 4))
                ]
              : [],
        ),
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
                          : AppColors.textSecondary)),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 52),
            suffixIcon: IconButton(
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(
                _obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
                color: _focused ? AppColors.primary : AppColors.textSecondary,
              ),
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
            : const SizedBox.shrink(),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PATTERN PAINTER
// ─────────────────────────────────────────────────────────────────────────────

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
