// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:go_router/go_router.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// // import '../providers/auth_provider.dart';
// // import '../../../core/theme/app_theme.dart';
// // import '../../../core/router/app_router.dart';
// // import '../../../shared/widgets/custom_text_field.dart';
// // import '../../../shared/widgets/primary_button.dart';

// // class RegisterScreen extends ConsumerStatefulWidget {
// //   const RegisterScreen({super.key});
// //   @override
// //   ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
// // }

// // class _RegisterScreenState extends ConsumerState<RegisterScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final _nameCtrl = TextEditingController();
// //   final _emailCtrl = TextEditingController();
// //   final _passCtrl = TextEditingController();
// //   final _confirmCtrl = TextEditingController();
// //   final _deptCtrl = TextEditingController();
// //   final _desigCtrl = TextEditingController();
// //   bool _obscure = true;
// //   bool _obscureConfirm = true;

// //   @override
// //   void dispose() {
// //     for (final c in [_nameCtrl, _emailCtrl, _passCtrl, _confirmCtrl, _deptCtrl, _desigCtrl]) {
// //       c.dispose();
// //     }
// //     super.dispose();
// //   }

// //   Future<void> _register() async {
// //     if (!_formKey.currentState!.validate()) return;
// //     final ok = await ref.read(authProvider.notifier).register(
// //           name: _nameCtrl.text.trim(),
// //           email: _emailCtrl.text.trim(),
// //           password: _passCtrl.text,
// //           department: _deptCtrl.text.trim().isEmpty ? null : _deptCtrl.text.trim(),
// //           designation: _desigCtrl.text.trim().isEmpty ? null : _desigCtrl.text.trim(),
// //         );
// //     if (ok && mounted) context.go(AppRoutes.home);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final auth = ref.watch(authProvider);
// //     final size = MediaQuery.of(context).size;
// //     final isTablet = size.width > 600;

// //     return Scaffold(
// //       body: Stack(
// //         children: [
// //           Container(
// //             height: 200,
// //             decoration: const BoxDecoration(gradient: AppColors.headerGradient),
// //           ),
// //           SafeArea(
// //             child: Column(
// //               children: [
// //                 // AppBar area
// //                 Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //                   child: Row(
// //                     children: [
// //                       IconButton(
// //                         onPressed: () => context.pop(),
// //                         icon: const Icon(Icons.arrow_back_ios_new_rounded,
// //                             color: Colors.white),
// //                       ),
// //                       Text('নতুন অ্যাকাউন্ট',
// //                           style: Theme.of(context)
// //                               .textTheme
// //                               .titleLarge!
// //                               .copyWith(color: Colors.white)),
// //                     ],
// //                   ),
// //                 ),

// //                 Expanded(
// //                   child: SingleChildScrollView(
// //                     padding: EdgeInsets.symmetric(
// //                         horizontal: isTablet ? (size.width - 480) / 2 : 20,
// //                         vertical: 8),
// //                     child: Container(
// //                       decoration: BoxDecoration(
// //                         color: AppColors.surface,
// //                         borderRadius: BorderRadius.circular(24),
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Colors.black.withOpacity(0.08),
// //                             blurRadius: 24,
// //                             offset: const Offset(0, 8),
// //                           ),
// //                         ],
// //                       ),
// //                       padding: const EdgeInsets.all(24),
// //                       child: Form(
// //                         key: _formKey,
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             if (auth.error != null) ...[
// //                               _ErrorBanner(message: auth.error!),
// //                               const SizedBox(height: 16),
// //                             ],

// //                             _SectionLabel('ব্যক্তিগত তথ্য'),
// //                             const SizedBox(height: 12),

// //                             CustomTextField(
// //                               controller: _nameCtrl,
// //                               label: 'পূর্ণ নাম *',
// //                               hint: 'আপনার নাম লিখুন',
// //                               prefixIcon: Icons.person_outline_rounded,
// //                               validator: (v) => v == null || v.isEmpty ? 'নাম দিন' : null,
// //                             ),
// //                             const SizedBox(height: 12),

// //                             CustomTextField(
// //                               controller: _deptCtrl,
// //                               label: 'বিভাগ',
// //                               hint: 'যেমন: IT, Finance',
// //                               prefixIcon: Icons.business_outlined,
// //                             ),
// //                             const SizedBox(height: 12),

// //                             CustomTextField(
// //                               controller: _desigCtrl,
// //                               label: 'পদবী',
// //                               hint: 'যেমন: Developer, Manager',
// //                               prefixIcon: Icons.badge_outlined,
// //                             ),
// //                             const SizedBox(height: 20),

// //                             _SectionLabel('লগইন তথ্য'),
// //                             const SizedBox(height: 12),

// //                             CustomTextField(
// //                               controller: _emailCtrl,
// //                               label: 'ইমেইল *',
// //                               hint: 'example@email.com',
// //                               prefixIcon: Icons.email_outlined,
// //                               keyboardType: TextInputType.emailAddress,
// //                               validator: (v) {
// //                                 if (v == null || v.isEmpty) return 'ইমেইল দিন';
// //                                 if (!v.contains('@')) return 'সঠিক ইমেইল দিন';
// //                                 return null;
// //                               },
// //                             ),
// //                             const SizedBox(height: 12),

// //                             CustomTextField(
// //                               controller: _passCtrl,
// //                               label: 'পাসওয়ার্ড *',
// //                               hint: '••••••••',
// //                               prefixIcon: Icons.lock_outline,
// //                               obscureText: _obscure,
// //                               suffixIcon: IconButton(
// //                                 onPressed: () => setState(() => _obscure = !_obscure),
// //                                 icon: Icon(_obscure
// //                                     ? Icons.visibility_outlined
// //                                     : Icons.visibility_off_outlined,
// //                                     color: AppColors.textSecondary),
// //                               ),
// //                               validator: (v) {
// //                                 if (v == null || v.isEmpty) return 'পাসওয়ার্ড দিন';
// //                                 if (v.length < 6) return 'কমপক্ষে ৬ অক্ষর';
// //                                 return null;
// //                               },
// //                             ),
// //                             const SizedBox(height: 12),

// //                             CustomTextField(
// //                               controller: _confirmCtrl,
// //                               label: 'পাসওয়ার্ড নিশ্চিত করুন *',
// //                               hint: '••••••••',
// //                               prefixIcon: Icons.lock_outline,
// //                               obscureText: _obscureConfirm,
// //                               suffixIcon: IconButton(
// //                                 onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
// //                                 icon: Icon(_obscureConfirm
// //                                     ? Icons.visibility_outlined
// //                                     : Icons.visibility_off_outlined,
// //                                     color: AppColors.textSecondary),
// //                               ),
// //                               validator: (v) {
// //                                 if (v == null || v.isEmpty) return 'পাসওয়ার্ড নিশ্চিত করুন';
// //                                 if (v != _passCtrl.text) return 'পাসওয়ার্ড মিলছে না';
// //                                 return null;
// //                               },
// //                             ),
// //                             const SizedBox(height: 28),

// //                             PrimaryButton(
// //                               onPressed: _register,
// //                               isLoading: auth.isLoading,
// //                               label: 'রেজিস্ট্রেশন করুন',
// //                               icon: Icons.person_add_rounded,
// //                             ),
// //                             const SizedBox(height: 16),
// //                             Center(
// //                               child: GestureDetector(
// //                                 onTap: () => context.pop(),
// //                                 child: RichText(
// //                                   text: TextSpan(
// //                                     text: 'ইতিমধ্যে অ্যাকাউন্ট আছে? ',
// //                                     style: Theme.of(context)
// //                                         .textTheme
// //                                         .bodyMedium!
// //                                         .copyWith(color: AppColors.textSecondary),
// //                                     children: [
// //                                       TextSpan(
// //                                         text: 'লগইন করুন',
// //                                         style: const TextStyle(
// //                                             color: AppColors.primary,
// //                                             fontWeight: FontWeight.w700),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                             const SizedBox(height: 8),
// //                           ],
// //                         ),
// //                       ),
// //                     ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.15),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _SectionLabel extends StatelessWidget {
// //   final String label;
// //   const _SectionLabel(this.label);

// //   @override
// //   Widget build(BuildContext context) => Row(
// //         children: [
// //           Container(width: 3, height: 16, decoration: BoxDecoration(
// //               color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
// //           const SizedBox(width: 8),
// //           Text(label,
// //               style: Theme.of(context).textTheme.labelLarge!.copyWith(
// //                   color: AppColors.primary, fontWeight: FontWeight.w700)),
// //         ],
// //       );
// // }

// // class _ErrorBanner extends StatelessWidget {
// //   final String message;
// //   const _ErrorBanner({required this.message});
// //   @override
// //   Widget build(BuildContext context) => Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
// //         decoration: BoxDecoration(
// //           color: AppColors.error.withOpacity(0.08),
// //           borderRadius: BorderRadius.circular(12),
// //           border: Border.all(color: AppColors.error.withOpacity(0.3)),
// //         ),
// //         child: Row(children: [
// //           const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 18),
// //           const SizedBox(width: 10),
// //           Expanded(
// //               child: Text(message,
// //                   style: Theme.of(context)
// //                       .textTheme
// //                       .bodySmall!
// //                       .copyWith(color: AppColors.error))),
// //         ]),
// //       );
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../providers/auth_provider.dart';
// import '../../../core/router/app_router.dart';
// import '../../../core/theme/app_theme.dart';

// class RegisterScreen extends ConsumerStatefulWidget {
//   const RegisterScreen({super.key});
//   @override
//   ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends ConsumerState<RegisterScreen>
//     with SingleTickerProviderStateMixin {
//   final _nameCtrl = TextEditingController();
//   final _emailCtrl = TextEditingController();
//   final _passCtrl = TextEditingController();
//   final _cfPassCtrl = TextEditingController();
//   final _deptCtrl = TextEditingController();
//   final _desigCtrl = TextEditingController();

//   final _nameFocus = FocusNode();
//   final _emailFocus = FocusNode();
//   final _passFocus = FocusNode();
//   final _cfPassFocus = FocusNode();
//   final _deptFocus = FocusNode();
//   final _desigFocus = FocusNode();

//   int _step = 0; // 0 = personal info, 1 = credentials
//   bool _submitted = false;

//   String? _nameErr, _emailErr, _passErr, _cfPassErr;

//   @override
//   void dispose() {
//     for (final c in [
//       _nameCtrl,
//       _emailCtrl,
//       _passCtrl,
//       _cfPassCtrl,
//       _deptCtrl,
//       _desigCtrl
//     ]) c.dispose();
//     for (final f in [
//       _nameFocus,
//       _emailFocus,
//       _passFocus,
//       _cfPassFocus,
//       _deptFocus,
//       _desigFocus
//     ]) f.dispose();
//     super.dispose();
//   }

//   // ── Validators ────────────────────────────────────────────────────────────

//   void _onNameChange(String v) {
//     if (!_submitted) return;
//     setState(() =>
//         _nameErr = v.trim().length < 2 ? 'নাম কমপক্ষে ২ অক্ষর হতে হবে' : null);
//   }

//   void _onEmailChange(String v) {
//     if (!_submitted) return;
//     setState(() {
//       if (v.isEmpty)
//         _emailErr = 'ইমেইল দিন';
//       else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim()))
//         _emailErr = 'সঠিক ইমেইল ঠিকানা দিন';
//       else
//         _emailErr = null;
//     });
//   }

//   void _onPassChange(String v) {
//     if (!_submitted) return;
//     setState(() {
//       if (v.isEmpty)
//         _passErr = 'পাসওয়ার্ড দিন';
//       else if (v.length < 6)
//         _passErr = 'কমপক্ষে ৬ অক্ষর হতে হবে';
//       else
//         _passErr = null;
//       if (_cfPassCtrl.text.isNotEmpty) {
//         _cfPassErr = _cfPassCtrl.text != v ? 'পাসওয়ার্ড মিলছে না' : null;
//       }
//     });
//   }

//   void _onCfPassChange(String v) {
//     if (!_submitted) return;
//     setState(
//         () => _cfPassErr = v != _passCtrl.text ? 'পাসওয়ার্ড মিলছে না' : null);
//   }

//   bool _validateStep0() {
//     setState(() {
//       _submitted = true;
//       _nameErr = _nameCtrl.text.trim().length < 2
//           ? 'নাম কমপক্ষে ২ অক্ষর হতে হবে'
//           : null;
//     });
//     return _nameErr == null;
//   }

//   bool _validateStep1() {
//     setState(() {
//       _submitted = true;
//       final email = _emailCtrl.text.trim();
//       final pass = _passCtrl.text;
//       final cf = _cfPassCtrl.text;
//       _emailErr = email.isEmpty
//           ? 'ইমেইল দিন'
//           : !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
//               ? 'সঠিক ইমেইল ঠিকানা দিন'
//               : null;
//       _passErr = pass.isEmpty
//           ? 'পাসওয়ার্ড দিন'
//           : pass.length < 6
//               ? 'কমপক্ষে ৬ অক্ষর হতে হবে'
//               : null;
//       _cfPassErr = cf != pass ? 'পাসওয়ার্ড মিলছে না' : null;
//     });
//     return _emailErr == null && _passErr == null && _cfPassErr == null;
//   }

//   void _nextStep() {
//     if (_step == 0 && _validateStep0()) {
//       setState(() {
//         _step = 1;
//         _submitted = false;
//       });
//     }
//   }

//   Future<void> _register() async {
//     if (!_validateStep1()) return;
//     ref.read(authProvider.notifier).clearError();
//     final ok = await ref.read(authProvider.notifier).register(
//           name: _nameCtrl.text.trim(),
//           email: _emailCtrl.text.trim(),
//           password: _passCtrl.text,
//           department:
//               _deptCtrl.text.trim().isEmpty ? null : _deptCtrl.text.trim(),
//           designation:
//               _desigCtrl.text.trim().isEmpty ? null : _desigCtrl.text.trim(),
//         );
//     if (ok && mounted) context.go(AppRoutes.home);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = ref.watch(authProvider);
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;
//     final hPad = isTablet ? ((size.width - 480) / 2) : 24.0;

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: Stack(
//         children: [
//           // Top gradient area
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: SizedBox(
//               height: size.height * 0.28,
//               child: Stack(children: [
//                 Container(
//                   decoration: const BoxDecoration(
//                     gradient: AppColors.brandGradient,
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(40),
//                       bottomRight: Radius.circular(40),
//                     ),
//                   ),
//                 ),
//                 Positioned.fill(
//                     child: ClipRRect(
//                         borderRadius: const BorderRadius.only(
//                             bottomLeft: Radius.circular(40),
//                             bottomRight: Radius.circular(40)),
//                         child: CustomPaint(painter: _DiagPainter()))),
//               ]),
//             ),
//           ),

//           SafeArea(
//             child: Column(
//               children: [
//                 // Top bar
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 4),
//                   child: Row(children: [
//                     if (_step == 1)
//                       IconButton(
//                         onPressed: () => setState(() {
//                           _step = 0;
//                           _submitted = false;
//                         }),
//                         icon: const Icon(Icons.arrow_back_ios_new_rounded,
//                             color: Colors.white, size: 20),
//                         style: IconButton.styleFrom(
//                           backgroundColor: Colors.white.withOpacity(0.15),
//                           padding: const EdgeInsets.all(8),
//                         ),
//                       )
//                     else
//                       IconButton(
//                         onPressed: () => context.go(AppRoutes.login),
//                         icon: const Icon(Icons.close_rounded,
//                             color: Colors.white, size: 22),
//                         style: IconButton.styleFrom(
//                           backgroundColor: Colors.white.withOpacity(0.15),
//                           padding: const EdgeInsets.all(8),
//                         ),
//                       ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(_step == 0 ? 'নতুন অ্যাকাউন্ট' : 'লগইন তথ্য',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleLarge!
//                                     .copyWith(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w700)),
//                             Text('ধাপ ${_step + 1} / 2',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodySmall!
//                                     .copyWith(
//                                         color: Colors.white.withOpacity(0.65))),
//                           ]),
//                     ),
//                   ]),
//                 ),

//                 // Step indicator
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 12),
//                   child: _StepIndicator(step: _step),
//                 ),

//                 const SizedBox(height: 4),

//                 // Form
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: EdgeInsets.symmetric(horizontal: hPad),
//                     child: AnimatedSwitcher(
//                       duration: 350.ms,
//                       transitionBuilder: (child, anim) => FadeTransition(
//                         opacity: anim,
//                         child: SlideTransition(
//                           position: Tween<Offset>(
//                             begin: const Offset(0.05, 0),
//                             end: Offset.zero,
//                           ).animate(anim),
//                           child: child,
//                         ),
//                       ),
//                       child: _step == 0
//                           ? _Step0(
//                               key: const ValueKey(0),
//                               nameCtrl: _nameCtrl,
//                               nameFocus: _nameFocus,
//                               deptCtrl: _deptCtrl,
//                               deptFocus: _deptFocus,
//                               desigCtrl: _desigCtrl,
//                               desigFocus: _desigFocus,
//                               nameError: _nameErr,
//                               onNameChanged: _onNameChange,
//                               onNext: _nextStep,
//                             )
//                           : _Step1(
//                               key: const ValueKey(1),
//                               emailCtrl: _emailCtrl,
//                               emailFocus: _emailFocus,
//                               passCtrl: _passCtrl,
//                               passFocus: _passFocus,
//                               cfPassCtrl: _cfPassCtrl,
//                               cfPassFocus: _cfPassFocus,
//                               emailError: _emailErr,
//                               passError: _passErr,
//                               cfPassError: _cfPassErr,
//                               onEmailChanged: _onEmailChange,
//                               onPassChanged: _onPassChange,
//                               onCfPassChanged: _onCfPassChange,
//                               isLoading: auth.isLoading,
//                               apiError: auth.error,
//                               onRegister: _register,
//                             ),
//                     ),
//                   ),
//                 ),

//                 // Login link
//                 Padding(
//                   padding: const EdgeInsets.all(24),
//                   child: GestureDetector(
//                     onTap: () => context.go(AppRoutes.login),
//                     child: RichText(
//                       text: TextSpan(
//                         text: 'ইতিমধ্যে অ্যাকাউন্ট আছে? ',
//                         style: Theme.of(context)
//                             .textTheme
//                             .bodyMedium!
//                             .copyWith(color: AppColors.textSecondary),
//                         children: [
//                           TextSpan(
//                               text: 'লগইন করুন',
//                               style: const TextStyle(
//                                   color: AppColors.primary,
//                                   fontWeight: FontWeight.w700)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Step 0 Widget ────────────────────────────────────────────────────────────

// class _Step0 extends StatelessWidget {
//   final TextEditingController nameCtrl, deptCtrl, desigCtrl;
//   final FocusNode nameFocus, deptFocus, desigFocus;
//   final String? nameError;
//   final void Function(String) onNameChanged;
//   final VoidCallback onNext;

//   const _Step0({
//     super.key,
//     required this.nameCtrl,
//     required this.nameFocus,
//     required this.deptCtrl,
//     required this.deptFocus,
//     required this.desigCtrl,
//     required this.desigFocus,
//     this.nameError,
//     required this.onNameChanged,
//     required this.onNext,
//   });

//   @override
//   Widget build(BuildContext context) => Container(
//         decoration: BoxDecoration(
//             color: AppColors.surface,
//             borderRadius: AppRadius.xxl_,
//             boxShadow: shadowLg()),
//         padding: const EdgeInsets.all(28),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text('ব্যক্তিগত তথ্য',
//               style: Theme.of(context)
//                   .textTheme
//                   .titleLarge!
//                   .copyWith(fontWeight: FontWeight.w800)),
//           const SizedBox(height: 4),
//           Text('আপনার পরিচয় তথ্য দিন',
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyMedium!
//                   .copyWith(color: AppColors.textSecondary)),
//           const SizedBox(height: 24),
//           _InlineField(
//               label: 'পূর্ণ নাম *',
//               icon: Icons.person_outline_rounded,
//               controller: nameCtrl,
//               focusNode: nameFocus,
//               hint: 'আপনার পূর্ণ নাম লিখুন',
//               error: nameError,
//               onChanged: onNameChanged,
//               onSubmit: () => deptFocus.requestFocus()),
//           const SizedBox(height: 18),
//           _InlineField(
//               label: 'বিভাগ (ঐচ্ছিক)',
//               icon: Icons.business_outlined,
//               controller: deptCtrl,
//               focusNode: deptFocus,
//               hint: 'যেমন: IT, Finance, HR',
//               onSubmit: () => desigFocus.requestFocus()),
//           const SizedBox(height: 18),
//           _InlineField(
//               label: 'পদবী (ঐচ্ছিক)',
//               icon: Icons.badge_outlined,
//               controller: desigCtrl,
//               focusNode: desigFocus,
//               hint: 'যেমন: Developer, Manager',
//               onSubmit: onNext),
//           const SizedBox(height: 28),
//           _GradButton(
//               label: 'পরবর্তী ধাপ',
//               icon: Icons.arrow_forward_rounded,
//               onTap: onNext),
//         ]),
//       );
// }

// // ─── Step 1 Widget ────────────────────────────────────────────────────────────

// class _Step1 extends StatelessWidget {
//   final TextEditingController emailCtrl, passCtrl, cfPassCtrl;
//   final FocusNode emailFocus, passFocus, cfPassFocus;
//   final String? emailError, passError, cfPassError, apiError;
//   final void Function(String) onEmailChanged, onPassChanged, onCfPassChanged;
//   final bool isLoading;
//   final VoidCallback onRegister;

//   const _Step1({
//     super.key,
//     required this.emailCtrl,
//     required this.emailFocus,
//     required this.passCtrl,
//     required this.passFocus,
//     required this.cfPassCtrl,
//     required this.cfPassFocus,
//     this.emailError,
//     this.passError,
//     this.cfPassError,
//     this.apiError,
//     required this.onEmailChanged,
//     required this.onPassChanged,
//     required this.onCfPassChanged,
//     required this.isLoading,
//     required this.onRegister,
//   });

//   @override
//   Widget build(BuildContext context) => Container(
//         decoration: BoxDecoration(
//             color: AppColors.surface,
//             borderRadius: AppRadius.xxl_,
//             boxShadow: shadowLg()),
//         padding: const EdgeInsets.all(28),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text('লগইন তথ্য',
//               style: Theme.of(context)
//                   .textTheme
//                   .titleLarge!
//                   .copyWith(fontWeight: FontWeight.w800)),
//           const SizedBox(height: 4),
//           Text('অ্যাকাউন্টের জন্য ইমেইল ও পাসওয়ার্ড তৈরি করুন',
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyMedium!
//                   .copyWith(color: AppColors.textSecondary)),
//           const SizedBox(height: 24),

//           if (apiError != null) ...[
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//               decoration: BoxDecoration(
//                   color: AppColors.errorPale,
//                   borderRadius: AppRadius.md_,
//                   border: Border.all(color: AppColors.error.withOpacity(0.25))),
//               child: Row(children: [
//                 const Icon(Icons.error_outline_rounded,
//                     color: AppColors.error, size: 18),
//                 const SizedBox(width: 10),
//                 Expanded(
//                     child: Text(apiError!,
//                         style: const TextStyle(
//                             color: AppColors.error,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500))),
//               ]),
//             ),
//             const SizedBox(height: 20),
//           ],

//           _InlineField(
//               label: 'ইমেইল ঠিকানা *',
//               icon: Icons.alternate_email_rounded,
//               controller: emailCtrl,
//               focusNode: emailFocus,
//               hint: 'example@email.com',
//               keyboardType: TextInputType.emailAddress,
//               error: emailError,
//               onChanged: onEmailChanged,
//               onSubmit: () => passFocus.requestFocus()),

//           const SizedBox(height: 18),

//           _InlinePasswordField(
//               label: 'পাসওয়ার্ড *',
//               controller: passCtrl,
//               focusNode: passFocus,
//               hint: '••••••••',
//               error: passError,
//               onChanged: onPassChanged,
//               onSubmit: () => cfPassFocus.requestFocus()),

//           const SizedBox(height: 18),

//           _InlinePasswordField(
//               label: 'পাসওয়ার্ড নিশ্চিত করুন *',
//               controller: cfPassCtrl,
//               focusNode: cfPassFocus,
//               hint: '••••••••',
//               error: cfPassError,
//               onChanged: onCfPassChanged,
//               onSubmit: onRegister),

//           // Password strength
//           if (passCtrl.text.isNotEmpty) ...[
//             const SizedBox(height: 12),
//             _PasswordStrength(password: passCtrl.text),
//           ],

//           const SizedBox(height: 28),

//           _GradButton(
//               label: isLoading ? 'তৈরি হচ্ছে...' : 'অ্যাকাউন্ট তৈরি করুন',
//               icon: isLoading ? null : Icons.check_circle_rounded,
//               onTap: isLoading ? null : onRegister,
//               isLoading: isLoading),
//         ]),
//       );
// }

// // ─── Password Strength ────────────────────────────────────────────────────────

// class _PasswordStrength extends StatelessWidget {
//   final String password;
//   const _PasswordStrength({required this.password});

//   int get strength {
//     int s = 0;
//     if (password.length >= 6) s++;
//     if (password.length >= 10) s++;
//     if (password.contains(RegExp(r'[A-Z]'))) s++;
//     if (password.contains(RegExp(r'[0-9]'))) s++;
//     if (password.contains(RegExp(r'[^A-Za-z0-9]'))) s++;
//     return s;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final s = strength;
//     final color = s <= 1
//         ? AppColors.error
//         : s <= 3
//             ? AppColors.warning
//             : AppColors.success;
//     final label = s <= 1
//         ? 'দুর্বল'
//         : s <= 3
//             ? 'মাঝারি'
//             : 'শক্তিশালী';
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Row(children: [
//         Expanded(
//             child: ClipRRect(
//           borderRadius: AppRadius.full,
//           child: LinearProgressIndicator(
//             value: s / 5,
//             backgroundColor: AppColors.divider,
//             valueColor: AlwaysStoppedAnimation(color),
//             minHeight: 4,
//           ),
//         )),
//         const SizedBox(width: 10),
//         Text(label,
//             style: TextStyle(
//                 fontSize: 11, fontWeight: FontWeight.w600, color: color)),
//       ]),
//     ]);
//   }
// }

// // ─── Step Indicator ───────────────────────────────────────────────────────────

// class _StepIndicator extends StatelessWidget {
//   final int step;
//   const _StepIndicator({required this.step});

//   @override
//   Widget build(BuildContext context) => Row(children: [
//         _Dot(active: step == 0, done: step > 0, label: '১'),
//         Expanded(
//             child: Container(
//                 height: 2,
//                 color: step >= 1 ? AppColors.primary : AppColors.border)),
//         _Dot(active: step == 1, done: false, label: '২'),
//       ]);
// }

// class _Dot extends StatelessWidget {
//   final bool active, done;
//   final String label;
//   const _Dot({required this.active, required this.done, required this.label});

//   @override
//   Widget build(BuildContext context) => AnimatedContainer(
//         duration: 300.ms,
//         width: 32,
//         height: 32,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: (active || done) ? AppColors.primary : AppColors.border,
//           boxShadow: (active || done) ? shadowGreen() : [],
//         ),
//         child: Center(
//             child: done
//                 ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
//                 : Text(label,
//                     style: TextStyle(
//                         color: (active || done)
//                             ? Colors.white
//                             : AppColors.textTertiary,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 13))),
//       );
// }

// // ─── Inline field helpers ─────────────────────────────────────────────────────

// class _InlineField extends StatefulWidget {
//   final String label;
//   final IconData icon;
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final String hint;
//   final String? error;
//   final TextInputType keyboardType;
//   final void Function(String)? onChanged;
//   final VoidCallback onSubmit;

//   const _InlineField(
//       {required this.label,
//       required this.icon,
//       required this.controller,
//       required this.focusNode,
//       required this.hint,
//       this.error,
//       this.keyboardType = TextInputType.text,
//       this.onChanged,
//       required this.onSubmit});

//   @override
//   State<_InlineField> createState() => _InlineFieldState();
// }

// class _InlineFieldState extends State<_InlineField> {
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
//               color: hasErr
//                   ? AppColors.error
//                   : (_focused ? AppColors.primary : AppColors.textPrimary),
//               fontWeight: FontWeight.w600)),
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
//                         offset: const Offset(0, 4))
//                   ]
//                 : []),
//         child: TextField(
//             controller: widget.controller,
//             focusNode: widget.focusNode,
//             keyboardType: widget.keyboardType,
//             textInputAction: TextInputAction.next,
//             onEditingComplete: widget.onSubmit,
//             onChanged: widget.onChanged,
//             style: const TextStyle(
//                 color: AppColors.textPrimary,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 15),
//             decoration: InputDecoration(
//               hintText: widget.hint,
//               hintStyle:
//                   const TextStyle(color: AppColors.textHint, fontSize: 14),
//               prefixIcon: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 14),
//                   child: Icon(widget.icon,
//                       size: 20,
//                       color: hasErr
//                           ? AppColors.error
//                           : (_focused
//                               ? AppColors.primary
//                               : AppColors.textSecondary))),
//               prefixIconConstraints: const BoxConstraints(minWidth: 52),
//               filled: true,
//               fillColor: hasErr
//                   ? AppColors.error.withOpacity(0.04)
//                   : (_focused ? AppColors.surface : AppColors.surfaceAlt),
//               border: OutlineInputBorder(
//                   borderRadius: AppRadius.md_,
//                   borderSide: const BorderSide(color: AppColors.border)),
//               enabledBorder: OutlineInputBorder(
//                   borderRadius: AppRadius.md_,
//                   borderSide: BorderSide(
//                       color: hasErr
//                           ? AppColors.error.withOpacity(0.5)
//                           : AppColors.border)),
//               focusedBorder: OutlineInputBorder(
//                   borderRadius: AppRadius.md_,
//                   borderSide: BorderSide(
//                       color: hasErr ? AppColors.error : AppColors.primary,
//                       width: 2)),
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//             )),
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
//                   ]))
//               : const SizedBox.shrink()),
//     ]);
//   }
// }

// class _InlinePasswordField extends StatefulWidget {
//   final String label;
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final String hint;
//   final String? error;
//   final void Function(String) onChanged;
//   final VoidCallback onSubmit;
//   const _InlinePasswordField(
//       {required this.label,
//       required this.controller,
//       required this.focusNode,
//       required this.hint,
//       this.error,
//       required this.onChanged,
//       required this.onSubmit});
//   @override
//   State<_InlinePasswordField> createState() => _InlinePasswordFieldState();
// }

// class _InlinePasswordFieldState extends State<_InlinePasswordField> {
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
//               color: hasErr
//                   ? AppColors.error
//                   : (_focused ? AppColors.primary : AppColors.textPrimary),
//               fontWeight: FontWeight.w600)),
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
//                         offset: const Offset(0, 4))
//                   ]
//                 : []),
//         child: TextField(
//             controller: widget.controller,
//             focusNode: widget.focusNode,
//             obscureText: _obscure,
//             textInputAction: TextInputAction.done,
//             onEditingComplete: widget.onSubmit,
//             onChanged: widget.onChanged,
//             style: const TextStyle(
//                 color: AppColors.textPrimary,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 15),
//             decoration: InputDecoration(
//               hintText: widget.hint,
//               hintStyle:
//                   const TextStyle(color: AppColors.textHint, fontSize: 14),
//               prefixIcon: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 14),
//                   child: Icon(Icons.lock_outline_rounded,
//                       size: 20,
//                       color: hasErr
//                           ? AppColors.error
//                           : (_focused
//                               ? AppColors.primary
//                               : AppColors.textSecondary))),
//               prefixIconConstraints: const BoxConstraints(minWidth: 52),
//               suffixIcon: IconButton(
//                   onPressed: () => setState(() => _obscure = !_obscure),
//                   icon: Icon(
//                       _obscure
//                           ? Icons.visibility_outlined
//                           : Icons.visibility_off_outlined,
//                       size: 20,
//                       color: _focused
//                           ? AppColors.primary
//                           : AppColors.textSecondary)),
//               filled: true,
//               fillColor: hasErr
//                   ? AppColors.error.withOpacity(0.04)
//                   : (_focused ? AppColors.surface : AppColors.surfaceAlt),
//               border: OutlineInputBorder(
//                   borderRadius: AppRadius.md_,
//                   borderSide: const BorderSide(color: AppColors.border)),
//               enabledBorder: OutlineInputBorder(
//                   borderRadius: AppRadius.md_,
//                   borderSide: BorderSide(
//                       color: hasErr
//                           ? AppColors.error.withOpacity(0.5)
//                           : AppColors.border)),
//               focusedBorder: OutlineInputBorder(
//                   borderRadius: AppRadius.md_,
//                   borderSide: BorderSide(
//                       color: hasErr ? AppColors.error : AppColors.primary,
//                       width: 2)),
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//             )),
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
//                   ]))
//               : const SizedBox.shrink()),
//     ]);
//   }
// }

// class _GradButton extends StatelessWidget {
//   final String label;
//   final IconData? icon;
//   final VoidCallback? onTap;
//   final bool isLoading;
//   const _GradButton(
//       {required this.label, this.icon, this.onTap, this.isLoading = false});

//   @override
//   Widget build(BuildContext context) => Container(
//         height: 54,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: onTap == null
//               ? null
//               : const LinearGradient(
//                   colors: [AppColors.primaryDark, AppColors.primaryLight]),
//           color: onTap == null ? AppColors.border : null,
//           borderRadius: AppRadius.md_,
//           boxShadow: onTap != null ? shadowGreen() : [],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           borderRadius: AppRadius.md_,
//           child: InkWell(
//               onTap: onTap,
//               borderRadius: AppRadius.md_,
//               child: Center(
//                 child: isLoading
//                     ? const SizedBox(
//                         width: 22,
//                         height: 22,
//                         child: CircularProgressIndicator(
//                             strokeWidth: 2.5, color: Colors.white))
//                     : Row(mainAxisSize: MainAxisSize.min, children: [
//                         if (icon != null) ...[
//                           Icon(icon, color: Colors.white, size: 20),
//                           const SizedBox(width: 8)
//                         ],
//                         Text(label,
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 16)),
//                       ]),
//               )),
//         ),
//       );
// }

// class _DiagPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final p = Paint()
//       ..color = Colors.white.withOpacity(0.04)
//       ..strokeWidth = 1
//       ..style = PaintingStyle.stroke;
//     for (double i = 0; i < size.width + size.height; i += 30) {
//       canvas.drawLine(Offset(i, 0), Offset(0, i), p);
//     }
//   }

//   @override
//   bool shouldRepaint(_) => false;
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../providers/auth_provider.dart';
// import '../../../core/router/app_router.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // DESIGN TOKENS — same as home_screen.dart ColorT
// // ─────────────────────────────────────────────────────────────────────────────

// class _C {
//   static const pageBg = Color(0xFFF4F6F1);
//   static const cardBg = Color(0xFFFFFFFF);
//   static const darkGreen = Color(0xFF0E3D22);
//   static const midGreen = Color(0xFF1B7045);
//   static const gold = Color(0xFFD4A843);
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const amber = Color(0xFFF59E0B);
//   static const amberLight = Color(0xFFFFF3E0);
//   static const red = Color(0xFFEF4444);
//   static const redLight = Color(0xFFFEF2F2);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
//   static const border = Color(0xFFE4EAE4);
//   static const borderMid = Color(0xFFD0DAD2);
//   static const surfaceAlt = Color(0xFFF8FAF8);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// class RegisterScreen extends ConsumerStatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends ConsumerState<RegisterScreen> {
//   // Controllers
//   final _nameCtrl = TextEditingController();
//   final _emailCtrl = TextEditingController();
//   final _passCtrl = TextEditingController();
//   final _cfPassCtrl = TextEditingController();
//   final _deptCtrl = TextEditingController();
//   final _desigCtrl = TextEditingController();

//   // Focus nodes
//   final _nameFocus = FocusNode();
//   final _emailFocus = FocusNode();
//   final _passFocus = FocusNode();
//   final _cfPassFocus = FocusNode();
//   final _deptFocus = FocusNode();
//   final _desigFocus = FocusNode();

//   int _step = 0; // 0 = personal info, 1 = credentials
//   bool _submitted = false;

//   // Inline errors
//   String? _nameErr, _emailErr, _passErr, _cfPassErr;

//   @override
//   void dispose() {
//     // Controllers
//     for (final c in [
//       _nameCtrl,
//       _emailCtrl,
//       _passCtrl,
//       _cfPassCtrl,
//       _deptCtrl,
//       _desigCtrl,
//     ]) c.dispose();
//     // Focus nodes — dispose() automatically calls removeListener internally
//     for (final f in [
//       _nameFocus,
//       _emailFocus,
//       _passFocus,
//       _cfPassFocus,
//       _deptFocus,
//       _desigFocus,
//     ]) f.dispose();
//     super.dispose();
//   }

//   // ── Live validators (only run after first submit attempt) ─────────────────

//   void _onNameChange(String v) {
//     if (!_submitted) return;
//     setState(() =>
//         _nameErr = v.trim().length < 2 ? 'নাম কমপক্ষে ২ অক্ষর হতে হবে' : null);
//   }

//   void _onEmailChange(String v) {
//     if (!_submitted) return;
//     setState(() {
//       if (v.trim().isEmpty)
//         _emailErr = 'ইমেইল দিন';
//       else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim()))
//         _emailErr = 'সঠিক ইমেইল ঠিকানা দিন';
//       else
//         _emailErr = null;
//     });
//   }

//   void _onPassChange(String v) {
//     if (!_submitted) return;
//     setState(() {
//       if (v.isEmpty)
//         _passErr = 'পাসওয়ার্ড দিন';
//       else if (v.length < 6)
//         _passErr = 'কমপক্ষে ৬ অক্ষর হতে হবে';
//       else
//         _passErr = null;
//       if (_cfPassCtrl.text.isNotEmpty) {
//         _cfPassErr = _cfPassCtrl.text != v ? 'পাসওয়ার্ড মিলছে না' : null;
//       }
//     });
//   }

//   void _onCfPassChange(String v) {
//     if (!_submitted) return;
//     setState(
//         () => _cfPassErr = v != _passCtrl.text ? 'পাসওয়ার্ড মিলছে না' : null);
//   }

//   // ── Step validators ───────────────────────────────────────────────────────

//   bool _validateStep0() {
//     setState(() {
//       _submitted = true;
//       _nameErr = _nameCtrl.text.trim().length < 2
//           ? 'নাম কমপক্ষে ২ অক্ষর হতে হবে'
//           : null;
//     });
//     return _nameErr == null;
//   }

//   bool _validateStep1() {
//     setState(() {
//       _submitted = true;
//       final email = _emailCtrl.text.trim();
//       final pass = _passCtrl.text;
//       final cf = _cfPassCtrl.text;
//       _emailErr = email.isEmpty
//           ? 'ইমেইল দিন'
//           : !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
//               ? 'সঠিক ইমেইল ঠিকানা দিন'
//               : null;
//       _passErr = pass.isEmpty
//           ? 'পাসওয়ার্ড দিন'
//           : pass.length < 6
//               ? 'কমপক্ষে ৬ অক্ষর হতে হবে'
//               : null;
//       _cfPassErr = cf != pass ? 'পাসওয়ার্ড মিলছে না' : null;
//     });
//     return _emailErr == null && _passErr == null && _cfPassErr == null;
//   }

//   // ── Step navigation ───────────────────────────────────────────────────────

//   void _nextStep() {
//     if (!_validateStep0()) return;
//     setState(() {
//       _step = 1;
//       _submitted = false;
//       // FIX 3: clear all errors when moving forward so step 1 starts clean
//       _emailErr = null;
//       _passErr = null;
//       _cfPassErr = null;
//     });
//   }

//   void _prevStep() {
//     setState(() {
//       _step = 0;
//       _submitted = false;
//       // FIX 3: clear step 0 errors so back nav feels clean
//       _nameErr = null;
//     });
//   }

//   // ── Register ──────────────────────────────────────────────────────────────

//   Future<void> _register() async {
//     if (!_validateStep1()) return;

//     // FIX 4: always clear stale API error before each attempt
//     ref.read(authProvider.notifier).clearError();

//     final ok = await ref.read(authProvider.notifier).register(
//           name: _nameCtrl.text.trim(),
//           email: _emailCtrl.text.trim(),
//           password: _passCtrl.text,
//           department:
//               _deptCtrl.text.trim().isEmpty ? null : _deptCtrl.text.trim(),
//           designation:
//               _desigCtrl.text.trim().isEmpty ? null : _desigCtrl.text.trim(),
//         );

//     if (ok && mounted) {
//       context.go(AppRoutes.home);
//     }
//   }

//   // ── Build ─────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     final auth = ref.watch(authProvider);

//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: _C.pageBg,
//         body: Column(
//           children: [
//             // ── Dark green sticky header ─────────────────────────────────
//             _Header(
//               step: _step,
//               onBack: _step == 1 ? _prevStep : null,
//               onClose: _step == 0 ? () => context.go(AppRoutes.login) : null,
//             ),

//             // ── Scrollable form body ─────────────────────────────────────
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//                 child: AnimatedSwitcher(
//                   duration: 320.ms,
//                   transitionBuilder: (child, anim) => FadeTransition(
//                     opacity: anim,
//                     child: SlideTransition(
//                       position: Tween<Offset>(
//                         begin: const Offset(0.04, 0),
//                         end: Offset.zero,
//                       ).animate(anim),
//                       child: child,
//                     ),
//                   ),
//                   child: _step == 0
//                       ? _Step0(
//                           key: const ValueKey(0),
//                           nameCtrl: _nameCtrl,
//                           nameFocus: _nameFocus,
//                           deptCtrl: _deptCtrl,
//                           deptFocus: _deptFocus,
//                           desigCtrl: _desigCtrl,
//                           desigFocus: _desigFocus,
//                           nameError: _nameErr,
//                           onNameChange: _onNameChange,
//                           onNext: _nextStep,
//                         )
//                       : _Step1(
//                           key: const ValueKey(1),
//                           emailCtrl: _emailCtrl,
//                           emailFocus: _emailFocus,
//                           passCtrl: _passCtrl,
//                           passFocus: _passFocus,
//                           cfPassCtrl: _cfPassCtrl,
//                           cfPassFocus: _cfPassFocus,
//                           emailError: _emailErr,
//                           passError: _passErr,
//                           cfPassError: _cfPassErr,
//                           onEmailChange: _onEmailChange,
//                           onPassChange: _onPassChange,
//                           onCfPassChange: _onCfPassChange,
//                           isLoading: auth.isLoading,
//                           apiError: auth.error,
//                           onRegister: _register,
//                         ),
//                 ),
//               ),
//             ),

//             // ── Bottom login link ────────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
//               child: SafeArea(
//                 top: false,
//                 child: GestureDetector(
//                   onTap: () => context.go(AppRoutes.login),
//                   child: RichText(
//                     text: TextSpan(
//                       text: 'ইতিমধ্যে অ্যাকাউন্ট আছে?  ',
//                       style: const TextStyle(
//                         color: _C.textSecondary,
//                         fontSize: 13,
//                       ),
//                       children: const [
//                         TextSpan(
//                           text: 'লগইন করুন →',
//                           style: TextStyle(
//                             color: _C.darkGreen,
//                             fontWeight: FontWeight.w700,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // HEADER  (dark green, same language as home/leaderboard hero bands)
// // ─────────────────────────────────────────────────────────────────────────────

// class _Header extends StatelessWidget {
//   final int step;
//   final VoidCallback? onBack;
//   final VoidCallback? onClose;

//   const _Header({required this.step, this.onBack, this.onClose});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: _C.darkGreen,
//       child: Stack(
//         children: [
//           // Decorative circles
//           Positioned(
//             top: -35,
//             right: -35,
//             child: Container(
//               width: 120,
//               height: 120,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Color(0x0AFFFFFF),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: -20,
//             left: 30,
//             child: Container(
//               width: 72,
//               height: 72,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Color(0x07FFFFFF),
//               ),
//             ),
//           ),

//           SafeArea(
//             bottom: false,
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Top row: back/close + title
//                   Row(
//                     children: [
//                       // Back / Close button
//                       GestureDetector(
//                         onTap: onBack ?? onClose,
//                         child: Container(
//                           width: 36,
//                           height: 36,
//                           decoration: BoxDecoration(
//                             color: const Color(0x1AFFFFFF),
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(
//                               color: const Color(0x26FFFFFF),
//                               width: 0.5,
//                             ),
//                           ),
//                           child: Icon(
//                             onBack != null
//                                 ? Icons.arrow_back_ios_new_rounded
//                                 : Icons.close_rounded,
//                             color: Colors.white,
//                             size: 17,
//                           ),
//                         ),
//                       ),

//                       const SizedBox(width: 12),

//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             step == 0 ? 'নতুন অ্যাকাউন্ট' : 'লগইন তথ্য',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 19,
//                               fontWeight: FontWeight.w800,
//                               letterSpacing: -0.3,
//                               height: 1.1,
//                             ),
//                           ),
//                           Text(
//                             'ধাপ ${step + 1} / ২',
//                             style: TextStyle(
//                               color: Colors.white.withOpacity(0.5),
//                               fontSize: 11,
//                             ),
//                           ),
//                         ],
//                       ),

//                       const Spacer(),

//                       // App logo pill
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 9, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: const Color(0x1AFFFFFF),
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(
//                             color: const Color(0x26FFFFFF),
//                             width: 0.5,
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: const [
//                             Text('🌿', style: TextStyle(fontSize: 11)),
//                             SizedBox(width: 5),
//                             Text(
//                               'আমাল ট্র্যাকার',
//                               style: TextStyle(
//                                 color: Color(0xAAFFFFFF),
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 18),

//                   // Step indicator bar
//                   _StepBar(step: step),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // STEP BAR  (inside the green header)
// // ─────────────────────────────────────────────────────────────────────────────

// class _StepBar extends StatelessWidget {
//   final int step;
//   const _StepBar({required this.step});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         _StepDot(index: 0, currentStep: step, label: '১'),
//         Expanded(
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             height: 2,
//             decoration: BoxDecoration(
//               color: step >= 1 ? _C.gold : Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(99),
//             ),
//           ),
//         ),
//         _StepDot(index: 1, currentStep: step, label: '২'),
//       ],
//     );
//   }
// }

// class _StepDot extends StatelessWidget {
//   final int index, currentStep;
//   final String label;

//   const _StepDot({
//     required this.index,
//     required this.currentStep,
//     required this.label,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDone = index < currentStep;
//     final isActive = index == currentStep;

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 280),
//       width: 30,
//       height: 30,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: isDone
//             ? _C.gold
//             : isActive
//                 ? Colors.white
//                 : Colors.white.withOpacity(0.18),
//         border: Border.all(
//           color: isDone || isActive
//               ? Colors.transparent
//               : Colors.white.withOpacity(0.3),
//           width: 1.5,
//         ),
//       ),
//       child: Center(
//         child: isDone
//             ? Icon(Icons.check_rounded, color: _C.darkGreen, size: 15)
//             : Text(
//                 label,
//                 style: TextStyle(
//                   color:
//                       isActive ? _C.darkGreen : Colors.white.withOpacity(0.5),
//                   fontWeight: FontWeight.w800,
//                   fontSize: 12,
//                 ),
//               ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // STEP 0 — Personal info  (StatelessWidget is fine — no live text needed)
// // ─────────────────────────────────────────────────────────────────────────────

// class _Step0 extends StatelessWidget {
//   final TextEditingController nameCtrl, deptCtrl, desigCtrl;
//   final FocusNode nameFocus, deptFocus, desigFocus;
//   final String? nameError;
//   final void Function(String) onNameChange;
//   final VoidCallback onNext;

//   const _Step0({
//     super.key,
//     required this.nameCtrl,
//     required this.nameFocus,
//     required this.deptCtrl,
//     required this.deptFocus,
//     required this.desigCtrl,
//     required this.desigFocus,
//     this.nameError,
//     required this.onNameChange,
//     required this.onNext,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _FormCard(
//           title: 'ব্যক্তিগত তথ্য',
//           subtitle: 'আপনার পরিচয় তথ্য দিন',
//           emoji: '👤',
//           children: [
//             _Field(
//               label: 'পূর্ণ নাম *',
//               icon: Icons.person_outline_rounded,
//               controller: nameCtrl,
//               focusNode: nameFocus,
//               hint: 'আপনার পূর্ণ নাম লিখুন',
//               error: nameError,
//               onChanged: onNameChange,
//               onSubmit: () => deptFocus.requestFocus(),
//             ),
//             const SizedBox(height: 16),
//             _Field(
//               label: 'বিভাগ (ঐচ্ছিক)',
//               icon: Icons.business_outlined,
//               controller: deptCtrl,
//               focusNode: deptFocus,
//               hint: 'যেমন: IT, Finance, HR',
//               onSubmit: () => desigFocus.requestFocus(),
//             ),
//             const SizedBox(height: 16),
//             _Field(
//               label: 'পদবী (ঐচ্ছিক)',
//               icon: Icons.badge_outlined,
//               controller: desigCtrl,
//               focusNode: desigFocus,
//               hint: 'যেমন: Developer, Manager',
//               onSubmit: onNext,
//               textInputAction: TextInputAction.done,
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         _PrimaryButton(
//           label: 'পরবর্তী ধাপ',
//           icon: Icons.arrow_forward_rounded,
//           onTap: onNext,
//         ),
//         const SizedBox(height: 8),
//       ],
//     ).animate().fadeIn(duration: 280.ms).slideY(begin: 0.06);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // STEP 1 — Credentials
// // FIX 1: Must be StatefulWidget so password strength re-renders on each keystroke
// // ─────────────────────────────────────────────────────────────────────────────

// class _Step1 extends StatefulWidget {
//   final TextEditingController emailCtrl, passCtrl, cfPassCtrl;
//   final FocusNode emailFocus, passFocus, cfPassFocus;
//   final String? emailError, passError, cfPassError, apiError;
//   final void Function(String) onEmailChange, onPassChange, onCfPassChange;
//   final bool isLoading;
//   final VoidCallback onRegister;

//   const _Step1({
//     super.key,
//     required this.emailCtrl,
//     required this.emailFocus,
//     required this.passCtrl,
//     required this.passFocus,
//     required this.cfPassCtrl,
//     required this.cfPassFocus,
//     this.emailError,
//     this.passError,
//     this.cfPassError,
//     this.apiError,
//     required this.onEmailChange,
//     required this.onPassChange,
//     required this.onCfPassChange,
//     required this.isLoading,
//     required this.onRegister,
//   });

//   @override
//   State<_Step1> createState() => _Step1State();
// }

// class _Step1State extends State<_Step1> {
//   // FIX 1: local listener so password strength bar rebuilds on every keystroke
//   @override
//   void initState() {
//     super.initState();
//     widget.passCtrl.addListener(_onPassTyped);
//   }

//   @override
//   void dispose() {
//     // FIX 2: always remove listeners in dispose
//     widget.passCtrl.removeListener(_onPassTyped);
//     super.dispose();
//   }

//   void _onPassTyped() => setState(() {}); // triggers rebuild → strength updates

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // API error banner
//         if (widget.apiError != null) ...[
//           _ErrorBanner(message: widget.apiError!)
//               .animate()
//               .fadeIn(duration: 200.ms)
//               .slideY(begin: -0.1),
//           const SizedBox(height: 12),
//         ],

//         _FormCard(
//           title: 'লগইন তথ্য',
//           subtitle: 'ইমেইল ও পাসওয়ার্ড তৈরি করুন',
//           emoji: '🔐',
//           children: [
//             _Field(
//               label: 'ইমেইল ঠিকানা *',
//               icon: Icons.alternate_email_rounded,
//               controller: widget.emailCtrl,
//               focusNode: widget.emailFocus,
//               hint: 'example@email.com',
//               keyboardType: TextInputType.emailAddress,
//               error: widget.emailError,
//               onChanged: widget.onEmailChange,
//               onSubmit: () => widget.passFocus.requestFocus(),
//             ),
//             const SizedBox(height: 16),
//             _PasswordField(
//               label: 'পাসওয়ার্ড *',
//               controller: widget.passCtrl,
//               focusNode: widget.passFocus,
//               hint: '••••••••',
//               error: widget.passError,
//               onChanged: widget.onPassChange,
//               onSubmit: () => widget.cfPassFocus.requestFocus(),
//             ),

//             // FIX 1: strength bar now rebuilds because _Step1State has a listener
//             if (widget.passCtrl.text.isNotEmpty) ...[
//               const SizedBox(height: 10),
//               _PasswordStrengthBar(password: widget.passCtrl.text),
//             ],

//             const SizedBox(height: 16),
//             _PasswordField(
//               label: 'পাসওয়ার্ড নিশ্চিত করুন *',
//               controller: widget.cfPassCtrl,
//               focusNode: widget.cfPassFocus,
//               hint: '••••••••',
//               error: widget.cfPassError,
//               onChanged: widget.onCfPassChange,
//               // FIX 6: both onSubmit AND onSubmitted covered
//               onSubmit: widget.onRegister,
//               textInputAction: TextInputAction.done,
//             ),
//           ],
//         ),

//         const SizedBox(height: 16),

//         _PrimaryButton(
//           label: widget.isLoading ? 'তৈরি হচ্ছে...' : 'অ্যাকাউন্ট তৈরি করুন',
//           icon: widget.isLoading ? null : Icons.check_circle_rounded,
//           onTap: widget.isLoading ? null : widget.onRegister,
//           isLoading: widget.isLoading,
//         ),

//         const SizedBox(height: 8),
//       ],
//     ).animate().fadeIn(duration: 280.ms).slideY(begin: 0.06);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // FORM CARD  (white card with title, same border/radius as home cards)
// // ─────────────────────────────────────────────────────────────────────────────

// class _FormCard extends StatelessWidget {
//   final String title, subtitle, emoji;
//   final List<Widget> children;

//   const _FormCard({
//     required this.title,
//     required this.subtitle,
//     required this.emoji,
//     required this.children,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: _C.cardBg,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 36,
//                 height: 36,
//                 decoration: BoxDecoration(
//                   color: _C.greenLight,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Center(
//                   child: Text(emoji, style: const TextStyle(fontSize: 18)),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       color: _C.textPrimary,
//                       fontWeight: FontWeight.w800,
//                       fontSize: 16,
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                   Text(
//                     subtitle,
//                     style: const TextStyle(
//                       color: _C.textSecondary,
//                       fontSize: 11,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           const Divider(color: _C.border, height: 0.5, thickness: 0.5),
//           const SizedBox(height: 20),
//           ...children,
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // ERROR BANNER
// // ─────────────────────────────────────────────────────────────────────────────

// class _ErrorBanner extends StatelessWidget {
//   final String message;
//   const _ErrorBanner({required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         color: _C.redLight,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: _C.red.withOpacity(0.25), width: 0.5),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.error_outline_rounded, color: _C.red, size: 18),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               message,
//               style: const TextStyle(
//                 color: _C.red,
//                 fontSize: 12.5,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PASSWORD STRENGTH BAR
// // ─────────────────────────────────────────────────────────────────────────────

// class _PasswordStrengthBar extends StatelessWidget {
//   final String password;
//   const _PasswordStrengthBar({required this.password});

//   int get _score {
//     int s = 0;
//     if (password.length >= 6) s++;
//     if (password.length >= 10) s++;
//     if (password.contains(RegExp(r'[A-Z]'))) s++;
//     if (password.contains(RegExp(r'[0-9]'))) s++;
//     if (password.contains(RegExp(r'[^A-Za-z0-9]'))) s++;
//     return s;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final s = _score;
//     final color = s <= 1
//         ? _C.red
//         : s <= 3
//             ? _C.amber
//             : _C.green;
//     final label = s <= 1
//         ? 'দুর্বল'
//         : s <= 3
//             ? 'মাঝারি'
//             : 'শক্তিশালী';

//     return Row(
//       children: [
//         Expanded(
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(99),
//             child: LinearProgressIndicator(
//               value: s / 5,
//               minHeight: 4,
//               backgroundColor: _C.border,
//               valueColor: AlwaysStoppedAnimation(color),
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w700,
//             color: color,
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // TEXT FIELD  (FIX 2: listener leak fixed — listener is managed by parent)
// // ─────────────────────────────────────────────────────────────────────────────

// class _Field extends StatefulWidget {
//   final String label;
//   final IconData icon;
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final String hint;
//   final String? error;
//   final TextInputType keyboardType;
//   final TextInputAction textInputAction;
//   final void Function(String)? onChanged;
//   final VoidCallback onSubmit;

//   const _Field({
//     required this.label,
//     required this.icon,
//     required this.controller,
//     required this.focusNode,
//     required this.hint,
//     this.error,
//     this.keyboardType = TextInputType.text,
//     this.textInputAction = TextInputAction.next,
//     this.onChanged,
//     required this.onSubmit,
//   });

//   @override
//   State<_Field> createState() => _FieldState();
// }

// class _FieldState extends State<_Field> {
//   bool _focused = false;

//   // FIX 2: store a reference to the listener so we can remove it
//   late final VoidCallback _focusListener;

//   @override
//   void initState() {
//     super.initState();
//     _focusListener = () {
//       if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
//     };
//     widget.focusNode.addListener(_focusListener);
//   }

//   @override
//   void dispose() {
//     // FIX 2: properly remove the listener
//     widget.focusNode.removeListener(_focusListener);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hasErr = widget.error != null && widget.error!.isNotEmpty;
//     final iconColor = hasErr
//         ? _C.red
//         : _focused
//             ? _C.darkGreen
//             : _C.textSecondary;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.label,
//           style: TextStyle(
//             color: hasErr
//                 ? _C.red
//                 : _focused
//                     ? _C.darkGreen
//                     : _C.textPrimary,
//             fontWeight: FontWeight.w600,
//             fontSize: 12.5,
//           ),
//         ),
//         const SizedBox(height: 6),
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 180),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: _focused
//                 ? [
//                     BoxShadow(
//                       color: (hasErr ? _C.red : _C.darkGreen).withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: const Offset(0, 3),
//                     )
//                   ]
//                 : [],
//           ),
//           child: TextField(
//             controller: widget.controller,
//             focusNode: widget.focusNode,
//             keyboardType: widget.keyboardType,
//             textInputAction: widget.textInputAction,
//             onChanged: widget.onChanged,
//             // FIX 6: both callbacks for maximum device compatibility
//             onEditingComplete: widget.onSubmit,
//             onSubmitted: (_) => widget.onSubmit(),
//             style: const TextStyle(
//               color: _C.textPrimary,
//               fontWeight: FontWeight.w500,
//               fontSize: 14.5,
//             ),
//             decoration: InputDecoration(
//               hintText: widget.hint,
//               hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
//               prefixIcon: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 14),
//                 child: Icon(widget.icon, size: 19, color: iconColor),
//               ),
//               prefixIconConstraints: const BoxConstraints(minWidth: 50),
//               filled: true,
//               fillColor: hasErr
//                   ? _C.red.withOpacity(0.04)
//                   : _focused
//                       ? _C.cardBg
//                       : _C.surfaceAlt,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(color: _C.border),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(
//                   color: hasErr ? _C.red.withOpacity(0.5) : _C.border,
//                   width: 0.5,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(
//                   color: hasErr ? _C.red : _C.darkGreen,
//                   width: 1.5,
//                 ),
//               ),
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
//             ),
//           ),
//         ),
//         // Inline error message
//         AnimatedSize(
//           duration: const Duration(milliseconds: 180),
//           child: hasErr
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 5, left: 2),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.error_rounded, size: 12, color: _C.red),
//                       const SizedBox(width: 5),
//                       Text(
//                         widget.error!,
//                         style: const TextStyle(
//                           color: _C.red,
//                           fontSize: 11.5,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : const SizedBox.shrink(),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PASSWORD FIELD  (same FIX 2 applied)
// // ─────────────────────────────────────────────────────────────────────────────

// class _PasswordField extends StatefulWidget {
//   final String label;
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final String hint;
//   final String? error;
//   final TextInputAction textInputAction;
//   final void Function(String) onChanged;
//   final VoidCallback onSubmit;

//   const _PasswordField({
//     required this.label,
//     required this.controller,
//     required this.focusNode,
//     required this.hint,
//     this.error,
//     this.textInputAction = TextInputAction.next,
//     required this.onChanged,
//     required this.onSubmit,
//   });

//   @override
//   State<_PasswordField> createState() => _PasswordFieldState();
// }

// class _PasswordFieldState extends State<_PasswordField> {
//   bool _focused = false;
//   bool _obscure = true;
//   late final VoidCallback _focusListener;

//   @override
//   void initState() {
//     super.initState();
//     _focusListener = () {
//       if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
//     };
//     widget.focusNode.addListener(_focusListener); // FIX 2
//   }

//   @override
//   void dispose() {
//     widget.focusNode.removeListener(_focusListener); // FIX 2
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hasErr = widget.error != null && widget.error!.isNotEmpty;
//     final iconColor = hasErr
//         ? _C.red
//         : _focused
//             ? _C.darkGreen
//             : _C.textSecondary;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.label,
//           style: TextStyle(
//             color: hasErr
//                 ? _C.red
//                 : _focused
//                     ? _C.darkGreen
//                     : _C.textPrimary,
//             fontWeight: FontWeight.w600,
//             fontSize: 12.5,
//           ),
//         ),
//         const SizedBox(height: 6),
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 180),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: _focused
//                 ? [
//                     BoxShadow(
//                       color: (hasErr ? _C.red : _C.darkGreen).withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: const Offset(0, 3),
//                     )
//                   ]
//                 : [],
//           ),
//           child: TextField(
//             controller: widget.controller,
//             focusNode: widget.focusNode,
//             obscureText: _obscure,
//             textInputAction: widget.textInputAction,
//             onChanged: widget.onChanged,
//             onEditingComplete: widget.onSubmit, // FIX 6
//             onSubmitted: (_) => widget.onSubmit(), // FIX 6
//             style: const TextStyle(
//               color: _C.textPrimary,
//               fontWeight: FontWeight.w500,
//               fontSize: 14.5,
//             ),
//             decoration: InputDecoration(
//               hintText: widget.hint,
//               hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
//               prefixIcon: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 14),
//                 child: Icon(Icons.lock_outline_rounded,
//                     size: 19, color: iconColor),
//               ),
//               prefixIconConstraints: const BoxConstraints(minWidth: 50),
//               suffixIcon: GestureDetector(
//                 onTap: () => setState(() => _obscure = !_obscure),
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 14),
//                   child: Icon(
//                     _obscure
//                         ? Icons.visibility_outlined
//                         : Icons.visibility_off_outlined,
//                     size: 19,
//                     color: _focused ? _C.darkGreen : _C.textSecondary,
//                   ),
//                 ),
//               ),
//               suffixIconConstraints: const BoxConstraints(minWidth: 46),
//               filled: true,
//               fillColor: hasErr
//                   ? _C.red.withOpacity(0.04)
//                   : _focused
//                       ? _C.cardBg
//                       : _C.surfaceAlt,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(color: _C.border),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(
//                   color: hasErr ? _C.red.withOpacity(0.5) : _C.border,
//                   width: 0.5,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(
//                   color: hasErr ? _C.red : _C.darkGreen,
//                   width: 1.5,
//                 ),
//               ),
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
//             ),
//           ),
//         ),
//         AnimatedSize(
//           duration: const Duration(milliseconds: 180),
//           child: hasErr
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 5, left: 2),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.error_rounded, size: 12, color: _C.red),
//                       const SizedBox(width: 5),
//                       Text(
//                         widget.error!,
//                         style: const TextStyle(
//                           color: _C.red,
//                           fontSize: 11.5,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : const SizedBox.shrink(),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PRIMARY BUTTON  (dark green, matches home CTA style)
// // ─────────────────────────────────────────────────────────────────────────────

// class _PrimaryButton extends StatelessWidget {
//   final String label;
//   final IconData? icon;
//   final VoidCallback? onTap;
//   final bool isLoading;

//   const _PrimaryButton({
//     required this.label,
//     this.icon,
//     this.onTap,
//     this.isLoading = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final enabled = onTap != null && !isLoading;

//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 180),
//         height: 52,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: enabled ? _C.darkGreen : _C.borderMid,
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: enabled
//               ? [
//                   BoxShadow(
//                     color: _C.darkGreen.withOpacity(0.28),
//                     blurRadius: 12,
//                     offset: const Offset(0, 5),
//                   )
//                 ]
//               : [],
//         ),
//         child: Center(
//           child: isLoading
//               ? const SizedBox(
//                   width: 22,
//                   height: 22,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2.5,
//                     color: Colors.white,
//                   ),
//                 )
//               : Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (icon != null) ...[
//                       Icon(icon, color: Colors.white, size: 18),
//                       const SizedBox(width: 8),
//                     ],
//                     Text(
//                       label,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 15,
//                         letterSpacing: -0.2,
//                       ),
//                     ),
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../providers/auth_provider.dart';
// import '../../../core/router/app_router.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // DESIGN TOKENS
// // ─────────────────────────────────────────────────────────────────────────────

// class _C {
//   static const pageBg = Color(0xFFF4F6F1);
//   static const cardBg = Color(0xFFFFFFFF);
//   static const darkGreen = Color(0xFF0E3D22);
//   static const midGreen = Color(0xFF1B7045);
//   static const gold = Color(0xFFD4A843);
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const amber = Color(0xFFF59E0B);
//   static const amberLight = Color(0xFFFFF3E0);
//   static const red = Color(0xFFEF4444);
//   static const redLight = Color(0xFFFEF2F2);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
//   static const border = Color(0xFFE4EAE4);
//   static const borderMid = Color(0xFFD0DAD2);
//   static const surfaceAlt = Color(0xFFF8FAF8);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // REGISTER SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// class RegisterScreen extends ConsumerStatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends ConsumerState<RegisterScreen> {
//   final _nameCtrl = TextEditingController();
//   final _emailCtrl = TextEditingController();
//   final _passCtrl = TextEditingController();
//   final _cfPassCtrl = TextEditingController();

//   final _nameFocus = FocusNode();
//   final _emailFocus = FocusNode();
//   final _passFocus = FocusNode();
//   final _cfPassFocus = FocusNode();

//   bool _submitted = false;
//   bool _isRegistering = false;

//   String? _nameErr, _emailErr, _passErr, _cfPassErr;

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _emailCtrl.dispose();
//     _passCtrl.dispose();
//     _cfPassCtrl.dispose();
//     _nameFocus.dispose();
//     _emailFocus.dispose();
//     _passFocus.dispose();
//     _cfPassFocus.dispose();
//     super.dispose();
//   }

//   void _onNameChange(String v) {
//     if (!_submitted) return;
//     setState(() {
//       _nameErr = v.trim().length < 2 ? 'নাম কমপক্ষে ২ অক্ষর হতে হবে' : null;
//     });
//   }

//   void _onEmailChange(String v) {
//     if (!_submitted) return;
//     setState(() {
//       if (v.trim().isEmpty) {
//         _emailErr = 'ইমেইল দিন';
//       } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) {
//         _emailErr = 'সঠিক ইমেইল ঠিকানা দিন';
//       } else {
//         _emailErr = null;
//       }
//     });
//   }

//   void _onPassChange(String v) {
//     if (!_submitted) return;
//     setState(() {
//       if (v.isEmpty) {
//         _passErr = 'পাসওয়ার্ড দিন';
//       } else if (v.length < 6) {
//         _passErr = 'কমপক্ষে ৬ অক্ষর হতে হবে';
//       } else {
//         _passErr = null;
//       }

//       if (_cfPassCtrl.text.isNotEmpty) {
//         _cfPassErr = _cfPassCtrl.text != v ? 'পাসওয়ার্ড মিলছে না' : null;
//       }
//     });
//   }

//   void _onCfPassChange(String v) {
//     if (!_submitted) return;
//     setState(() {
//       _cfPassErr = v != _passCtrl.text ? 'পাসওয়ার্ড মিলছে না' : null;
//     });
//   }

//   bool _validate() {
//     setState(() {
//       _submitted = true;

//       final name = _nameCtrl.text.trim();
//       final email = _emailCtrl.text.trim();
//       final pass = _passCtrl.text;
//       final cf = _cfPassCtrl.text;

//       _nameErr = name.length < 2 ? 'নাম কমপক্ষে ২ অক্ষর হতে হবে' : null;

//       _emailErr = email.isEmpty
//           ? 'ইমেইল দিন'
//           : !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
//               ? 'সঠিক ইমেইল ঠিকানা দিন'
//               : null;

//       _passErr = pass.isEmpty
//           ? 'পাসওয়ার্ড দিন'
//           : pass.length < 6
//               ? 'কমপক্ষে ৬ অক্ষর হতে হবে'
//               : null;

//       _cfPassErr = cf != pass ? 'পাসওয়ার্ড মিলছে না' : null;
//     });

//     return _nameErr == null &&
//         _emailErr == null &&
//         _passErr == null &&
//         _cfPassErr == null;
//   }

//   Future<void> _register() async {
//     if (_isRegistering) return;
//     if (!_validate()) return;

//     setState(() {
//       _isRegistering = true;
//     });

//     ref.read(authProvider.notifier).clearError();

//     final ok = await ref.read(authProvider.notifier).register(
//           name: _nameCtrl.text.trim(),
//           email: _emailCtrl.text.trim(),
//           password: _passCtrl.text,
//           department: null,
//           designation: null,
//         );

//     setState(() {
//       _isRegistering = false;
//     });

//     if (ok && mounted) {
//       context.go(AppRoutes.home);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = ref.watch(authProvider);
//     final isLoading = auth.isLoading || _isRegistering;
//     final size = MediaQuery.of(context).size;

//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: _C.pageBg,
//         body: Stack(
//           children: [
//             // Header Gradient
//             Positioned(
//               top: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 height: size.height * 0.35,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [_C.darkGreen, _C.midGreen],
//                   ),
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(32),
//                     bottomRight: Radius.circular(32),
//                   ),
//                 ),
//                 child: Stack(
//                   children: [
//                     Positioned(
//                       top: -40,
//                       right: -40,
//                       child: Container(
//                         width: 150,
//                         height: 150,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.white.withOpacity(0.05),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: -30,
//                       left: -30,
//                       child: Container(
//                         width: 100,
//                         height: 100,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: _C.gold.withOpacity(0.08),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Main Content
//             SafeArea(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 40),

//                     // Header Content
//                     Column(
//                       children: [
//                         Container(
//                           width: 70,
//                           height: 70,
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                               color: Colors.white.withOpacity(0.25),
//                             ),
//                           ),
//                           child: const Icon(
//                             Icons.person_add_rounded,
//                             color: Colors.white,
//                             size: 35,
//                           ),
//                         ).animate().scale(
//                               duration: 500.ms,
//                               curve: Curves.elasticOut,
//                               begin: const Offset(0.5, 0.5),
//                             ),
//                         const SizedBox(height: 20),
//                         Text(
//                           'নতুন অ্যাকাউন্ট',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 28,
//                             fontWeight: FontWeight.w800,
//                             letterSpacing: -0.5,
//                           ),
//                         ).animate(delay: 100.ms).fadeIn().slideY(begin: -0.1),
//                         const SizedBox(height: 8),
//                         Text(
//                           'নিবন্ধন করে শুরু করুন',
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.8),
//                             fontSize: 14,
//                           ),
//                         ).animate(delay: 150.ms).fadeIn(),
//                       ],
//                     ),

//                     const SizedBox(height: 32),

//                     // Form Card
//                     IgnorePointer(
//                       ignoring: isLoading,
//                       child: Opacity(
//                         opacity: isLoading ? 0.6 : 1.0,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: _C.cardBg,
//                             borderRadius: BorderRadius.circular(24),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 20,
//                                 offset: const Offset(0, 8),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               // Form Fields
//                               Padding(
//                                 padding: const EdgeInsets.all(24),
//                                 child: Column(
//                                   children: [
//                                     // API Error
//                                     if (auth.error != null) ...[
//                                       _ErrorBanner(auth.error!),
//                                       const SizedBox(height: 20),
//                                     ],

//                                     // Name Field
//                                     _Field(
//                                       label: 'পূর্ণ নাম',
//                                       icon: Icons.person_outline_rounded,
//                                       controller: _nameCtrl,
//                                       focusNode: _nameFocus,
//                                       hint: 'আপনার পূর্ণ নাম লিখুন',
//                                       error: _nameErr,
//                                       onChanged: _onNameChange,
//                                       onSubmit: () =>
//                                           _emailFocus.requestFocus(),
//                                     )
//                                         .animate(delay: 200.ms)
//                                         .fadeIn()
//                                         .slideY(begin: 0.05),

//                                     const SizedBox(height: 18),

//                                     // Email Field
//                                     _Field(
//                                       label: 'ইমেইল ঠিকানা',
//                                       icon: Icons.alternate_email_rounded,
//                                       controller: _emailCtrl,
//                                       focusNode: _emailFocus,
//                                       hint: 'example@email.com',
//                                       keyboardType: TextInputType.emailAddress,
//                                       error: _emailErr,
//                                       onChanged: _onEmailChange,
//                                       onSubmit: () => _passFocus.requestFocus(),
//                                     )
//                                         .animate(delay: 250.ms)
//                                         .fadeIn()
//                                         .slideY(begin: 0.05),

//                                     const SizedBox(height: 18),

//                                     // Password Field
//                                     _PasswordField(
//                                       label: 'পাসওয়ার্ড',
//                                       controller: _passCtrl,
//                                       focusNode: _passFocus,
//                                       hint: 'কমপক্ষে ৬ অক্ষর',
//                                       error: _passErr,
//                                       onChanged: _onPassChange,
//                                       onSubmit: () =>
//                                           _cfPassFocus.requestFocus(),
//                                     )
//                                         .animate(delay: 300.ms)
//                                         .fadeIn()
//                                         .slideY(begin: 0.05),

//                                     // Password Strength
//                                     if (_passCtrl.text.isNotEmpty &&
//                                         _passErr == null) ...[
//                                       const SizedBox(height: 12),
//                                       _PasswordStrengthBar(
//                                           password: _passCtrl.text),
//                                     ],

//                                     const SizedBox(height: 18),

//                                     // Confirm Password Field
//                                     _PasswordField(
//                                       label: 'পাসওয়ার্ড নিশ্চিত করুন',
//                                       controller: _cfPassCtrl,
//                                       focusNode: _cfPassFocus,
//                                       hint: 'পাসওয়ার্ড আবার লিখুন',
//                                       error: _cfPassErr,
//                                       onChanged: _onCfPassChange,
//                                       onSubmit: _register,
//                                       textInputAction: TextInputAction.done,
//                                     )
//                                         .animate(delay: 350.ms)
//                                         .fadeIn()
//                                         .slideY(begin: 0.05),
//                                   ],
//                                 ),
//                               ),

//                               // Register Button
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(24, 0, 24, 24),
//                                 child: _PrimaryButton(
//                                   label: isLoading
//                                       ? 'নিবন্ধন হচ্ছে...'
//                                       : 'নিবন্ধন করুন',
//                                   icon: isLoading
//                                       ? null
//                                       : Icons.check_circle_rounded,
//                                   onTap: isLoading ? null : _register,
//                                   isLoading: isLoading,
//                                 )
//                                     .animate(delay: 400.ms)
//                                     .fadeIn()
//                                     .slideY(begin: 0.05),
//                               ),
//                             ],
//                           ),
//                         ).animate(delay: 180.ms).fadeIn().slideY(begin: 0.1),
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     // Login Link
//                     GestureDetector(
//                       onTap:
//                           isLoading ? null : () => context.go(AppRoutes.login),
//                       child: Opacity(
//                         opacity: isLoading ? 0.4 : 1.0,
//                         child: RichText(
//                           text: TextSpan(
//                             text: 'ইতিমধ্যে অ্যাকাউন্ট আছে? ',
//                             style: const TextStyle(
//                               color: _C.textSecondary,
//                               fontSize: 14,
//                             ),
//                             children: const [
//                               TextSpan(
//                                 text: 'লগইন করুন',
//                                 style: TextStyle(
//                                   color: _C.darkGreen,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ).animate(delay: 450.ms).fadeIn(),

//                     const SizedBox(height: 32),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // TEXT FIELD
// // ─────────────────────────────────────────────────────────────────────────────

// class _Field extends StatefulWidget {
//   final String label;
//   final IconData icon;
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final String hint;
//   final String? error;
//   final TextInputType keyboardType;
//   final TextInputAction textInputAction;
//   final void Function(String)? onChanged;
//   final VoidCallback onSubmit;

//   const _Field({
//     required this.label,
//     required this.icon,
//     required this.controller,
//     required this.focusNode,
//     required this.hint,
//     this.error,
//     this.keyboardType = TextInputType.text,
//     this.textInputAction = TextInputAction.next,
//     this.onChanged,
//     required this.onSubmit,
//   });

//   @override
//   State<_Field> createState() => _FieldState();
// }

// class _FieldState extends State<_Field> {
//   bool _focused = false;
//   late final VoidCallback _focusListener;

//   @override
//   void initState() {
//     super.initState();
//     _focusListener = () {
//       if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
//     };
//     widget.focusNode.addListener(_focusListener);
//   }

//   @override
//   void dispose() {
//     widget.focusNode.removeListener(_focusListener);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hasErr = widget.error != null && widget.error!.isNotEmpty;
//     final iconColor = hasErr
//         ? _C.red
//         : _focused
//             ? _C.darkGreen
//             : _C.textSecondary;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.label,
//           style: TextStyle(
//             color: hasErr
//                 ? _C.red
//                 : _focused
//                     ? _C.darkGreen
//                     : _C.textPrimary,
//             fontWeight: FontWeight.w600,
//             fontSize: 13,
//           ),
//         ),
//         const SizedBox(height: 8),
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 180),
//           curve: Curves.easeOutCubic,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             boxShadow: _focused && !hasErr
//                 ? [
//                     BoxShadow(
//                       color: _C.darkGreen.withOpacity(0.08),
//                       blurRadius: 12,
//                       offset: const Offset(0, 4),
//                     )
//                   ]
//                 : [],
//           ),
//           child: TextField(
//             controller: widget.controller,
//             focusNode: widget.focusNode,
//             keyboardType: widget.keyboardType,
//             textInputAction: widget.textInputAction,
//             onChanged: widget.onChanged,
//             onEditingComplete: widget.onSubmit,
//             onSubmitted: (_) => widget.onSubmit(),
//             style: const TextStyle(
//               color: _C.textPrimary,
//               fontWeight: FontWeight.w500,
//               fontSize: 15,
//             ),
//             decoration: InputDecoration(
//               hintText: widget.hint,
//               hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
//               prefixIcon: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Icon(widget.icon, size: 20, color: iconColor),
//               ),
//               prefixIconConstraints: const BoxConstraints(minWidth: 54),
//               filled: true,
//               fillColor: hasErr
//                   ? _C.red.withOpacity(0.04)
//                   : _focused
//                       ? _C.cardBg
//                       : _C.surfaceAlt,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: const BorderSide(color: _C.border),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                   color: hasErr ? _C.red.withOpacity(0.5) : _C.border,
//                   width: 1,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                   color: hasErr ? _C.red : _C.darkGreen,
//                   width: 1.5,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//             ),
//           ),
//         ),
//         AnimatedSize(
//           duration: const Duration(milliseconds: 180),
//           curve: Curves.easeOutCubic,
//           child: hasErr
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 6, left: 4),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.error_rounded, size: 13, color: _C.red),
//                       const SizedBox(width: 6),
//                       Text(
//                         widget.error!,
//                         style: const TextStyle(
//                           color: _C.red,
//                           fontSize: 11.5,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : const SizedBox.shrink(),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PASSWORD FIELD
// // ─────────────────────────────────────────────────────────────────────────────

// class _PasswordField extends StatefulWidget {
//   final String label;
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final String hint;
//   final String? error;
//   final TextInputAction textInputAction;
//   final void Function(String) onChanged;
//   final VoidCallback onSubmit;

//   const _PasswordField({
//     required this.label,
//     required this.controller,
//     required this.focusNode,
//     required this.hint,
//     this.error,
//     this.textInputAction = TextInputAction.next,
//     required this.onChanged,
//     required this.onSubmit,
//   });

//   @override
//   State<_PasswordField> createState() => _PasswordFieldState();
// }

// class _PasswordFieldState extends State<_PasswordField> {
//   bool _focused = false;
//   bool _obscure = true;
//   late final VoidCallback _focusListener;

//   @override
//   void initState() {
//     super.initState();
//     _focusListener = () {
//       if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
//     };
//     widget.focusNode.addListener(_focusListener);
//   }

//   @override
//   void dispose() {
//     widget.focusNode.removeListener(_focusListener);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hasErr = widget.error != null && widget.error!.isNotEmpty;
//     final iconColor = hasErr
//         ? _C.red
//         : _focused
//             ? _C.darkGreen
//             : _C.textSecondary;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.label,
//           style: TextStyle(
//             color: hasErr
//                 ? _C.red
//                 : _focused
//                     ? _C.darkGreen
//                     : _C.textPrimary,
//             fontWeight: FontWeight.w600,
//             fontSize: 13,
//           ),
//         ),
//         const SizedBox(height: 8),
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 180),
//           curve: Curves.easeOutCubic,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             boxShadow: _focused && !hasErr
//                 ? [
//                     BoxShadow(
//                       color: _C.darkGreen.withOpacity(0.08),
//                       blurRadius: 12,
//                       offset: const Offset(0, 4),
//                     )
//                   ]
//                 : [],
//           ),
//           child: TextField(
//             controller: widget.controller,
//             focusNode: widget.focusNode,
//             obscureText: _obscure,
//             textInputAction: widget.textInputAction,
//             onChanged: widget.onChanged,
//             onEditingComplete: widget.onSubmit,
//             onSubmitted: (_) => widget.onSubmit(),
//             style: const TextStyle(
//               color: _C.textPrimary,
//               fontWeight: FontWeight.w500,
//               fontSize: 15,
//             ),
//             decoration: InputDecoration(
//               hintText: widget.hint,
//               hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
//               prefixIcon: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Icon(Icons.lock_outline_rounded,
//                     size: 20, color: iconColor),
//               ),
//               prefixIconConstraints: const BoxConstraints(minWidth: 54),
//               suffixIcon: GestureDetector(
//                 onTap: () => setState(() => _obscure = !_obscure),
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 16),
//                   child: Icon(
//                     _obscure
//                         ? Icons.visibility_outlined
//                         : Icons.visibility_off_outlined,
//                     size: 20,
//                     color: _focused ? _C.darkGreen : _C.textSecondary,
//                   ),
//                 ),
//               ),
//               suffixIconConstraints: const BoxConstraints(minWidth: 50),
//               filled: true,
//               fillColor: hasErr
//                   ? _C.red.withOpacity(0.04)
//                   : _focused
//                       ? _C.cardBg
//                       : _C.surfaceAlt,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: const BorderSide(color: _C.border),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                   color: hasErr ? _C.red.withOpacity(0.5) : _C.border,
//                   width: 1,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                   color: hasErr ? _C.red : _C.darkGreen,
//                   width: 1.5,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//             ),
//           ),
//         ),
//         AnimatedSize(
//           duration: const Duration(milliseconds: 180),
//           curve: Curves.easeOutCubic,
//           child: hasErr
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 6, left: 4),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.error_rounded, size: 13, color: _C.red),
//                       const SizedBox(width: 6),
//                       Text(
//                         widget.error!,
//                         style: const TextStyle(
//                           color: _C.red,
//                           fontSize: 11.5,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : const SizedBox.shrink(),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PASSWORD STRENGTH BAR
// // ─────────────────────────────────────────────────────────────────────────────

// class _PasswordStrengthBar extends StatelessWidget {
//   final String password;
//   const _PasswordStrengthBar({required this.password});

//   int get _score {
//     int s = 0;
//     if (password.length >= 6) s++;
//     if (password.length >= 10) s++;
//     if (password.contains(RegExp(r'[A-Z]'))) s++;
//     if (password.contains(RegExp(r'[0-9]'))) s++;
//     if (password.contains(RegExp(r'[^A-Za-z0-9]'))) s++;
//     return s;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final s = _score;
//     final color = s <= 1
//         ? _C.red
//         : s <= 3
//             ? _C.amber
//             : _C.green;
//     final label = s <= 1
//         ? 'দুর্বল'
//         : s <= 3
//             ? 'মাঝারি'
//             : 'শক্তিশালী';

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       curve: Curves.easeOutCubic,
//       child: Row(
//         children: [
//           Expanded(
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(99),
//               child: LinearProgressIndicator(
//                 value: s / 5,
//                 minHeight: 4,
//                 backgroundColor: _C.border,
//                 valueColor: AlwaysStoppedAnimation(color),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w700,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // ERROR BANNER
// // ─────────────────────────────────────────────────────────────────────────────

// class _ErrorBanner extends StatelessWidget {
//   final String message;
//   const _ErrorBanner(this.message);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         color: _C.redLight,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: _C.red.withOpacity(0.25)),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.error_outline_rounded, color: _C.red, size: 18),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               message,
//               style: const TextStyle(
//                 color: _C.red,
//                 fontSize: 12.5,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PRIMARY BUTTON
// // ─────────────────────────────────────────────────────────────────────────────

// class _PrimaryButton extends StatelessWidget {
//   final String label;
//   final IconData? icon;
//   final VoidCallback? onTap;
//   final bool isLoading;

//   const _PrimaryButton({
//     required this.label,
//     this.icon,
//     this.onTap,
//     this.isLoading = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final enabled = onTap != null && !isLoading;

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 180),
//       curve: Curves.easeOutCubic,
//       height: 54,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: enabled ? _C.darkGreen : _C.borderMid,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: enabled
//             ? [
//                 BoxShadow(
//                   color: _C.darkGreen.withOpacity(0.3),
//                   blurRadius: 12,
//                   offset: const Offset(0, 6),
//                 )
//               ]
//             : [],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: Center(
//             child: isLoading
//                 ? const SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2.5,
//                       color: Colors.white,
//                     ),
//                   )
//                 : Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       if (icon != null) ...[
//                         Icon(icon, color: Colors.white, size: 20),
//                         const SizedBox(width: 10),
//                       ],
//                       Text(
//                         label,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w700,
//                           fontSize: 16,
//                           letterSpacing: -0.2,
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// // }
// import 'package:amal_tracker/features/auth/providers/provider_reset.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../providers/auth_provider.dart';
// import '../../../core/router/app_router.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // DESIGN TOKENS
// // ─────────────────────────────────────────────────────────────────────────────

// class _C {
//   static const pageBg = Color(0xFFF4F6F1);
//   static const cardBg = Color(0xFFFFFFFF);
//   static const darkGreen = Color(0xFF0E3D22);
//   static const midGreen = Color(0xFF1B7045);
//   static const gold = Color(0xFFD4A843);
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const amber = Color(0xFFF59E0B);
//   static const amberLight = Color(0xFFFFF3E0);
//   static const red = Color(0xFFEF4444);
//   static const redLight = Color(0xFFFEF2F2);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
//   static const border = Color(0xFFE4EAE4);
//   static const borderMid = Color(0xFFD0DAD2);
//   static const surfaceAlt = Color(0xFFF8FAF8);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // REGISTER SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// class RegisterScreen extends ConsumerStatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends ConsumerState<RegisterScreen> {
//   final _nameCtrl = TextEditingController();
//   final _emailCtrl = TextEditingController();
//   final _passCtrl = TextEditingController();
//   final _cfPassCtrl = TextEditingController();

//   final _nameFocus = FocusNode();
//   final _emailFocus = FocusNode();
//   final _passFocus = FocusNode();
//   final _cfPassFocus = FocusNode();

//   bool _submitted = false;
//   bool _isRegistering = false;

//   String? _nameErr, _emailErr, _passErr, _cfPassErr;

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _emailCtrl.dispose();
//     _passCtrl.dispose();
//     _cfPassCtrl.dispose();
//     _nameFocus.dispose();
//     _emailFocus.dispose();
//     _passFocus.dispose();
//     _cfPassFocus.dispose();
//     super.dispose();
//   }

//   void _onNameChange(String v) {
//     if (!_submitted) return;
//     setState(() {
//       _nameErr = v.trim().length < 2 ? 'নাম কমপক্ষে ২ অক্ষর হতে হবে' : null;
//     });
//   }

//   void _onEmailChange(String v) {
//     if (!_submitted) return;
//     setState(() {
//       if (v.trim().isEmpty) {
//         _emailErr = 'ইমেইল দিন';
//       } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) {
//         _emailErr = 'সঠিক ইমেইল ঠিকানা দিন';
//       } else {
//         _emailErr = null;
//       }
//     });
//   }

//   void _onPassChange(String v) {
//     if (!_submitted) return;
//     setState(() {
//       if (v.isEmpty) {
//         _passErr = 'পাসওয়ার্ড দিন';
//       } else if (v.length < 6) {
//         _passErr = 'কমপক্ষে ৬ অক্ষর হতে হবে';
//       } else {
//         _passErr = null;
//       }

//       if (_cfPassCtrl.text.isNotEmpty) {
//         _cfPassErr = _cfPassCtrl.text != v ? 'পাসওয়ার্ড মিলছে না' : null;
//       }
//     });
//   }

//   void _onCfPassChange(String v) {
//     if (!_submitted) return;
//     setState(() {
//       _cfPassErr = v != _passCtrl.text ? 'পাসওয়ার্ড মিলছে না' : null;
//     });
//   }

//   bool _validate() {
//     setState(() {
//       _submitted = true;

//       final name = _nameCtrl.text.trim();
//       final email = _emailCtrl.text.trim();
//       final pass = _passCtrl.text;
//       final cf = _cfPassCtrl.text;

//       _nameErr = name.length < 2 ? 'নাম কমপক্ষে ২ অক্ষর হতে হবে' : null;

//       _emailErr = email.isEmpty
//           ? 'ইমেইল দিন'
//           : !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
//               ? 'সঠিক ইমেইল ঠিকানা দিন'
//               : null;

//       _passErr = pass.isEmpty
//           ? 'পাসওয়ার্ড দিন'
//           : pass.length < 6
//               ? 'কমপক্ষে ৬ অক্ষর হতে হবে'
//               : null;

//       _cfPassErr = cf != pass ? 'পাসওয়ার্ড মিলছে না' : null;
//     });

//     return _nameErr == null &&
//         _emailErr == null &&
//         _passErr == null &&
//         _cfPassErr == null;
//   }

//   // Show confirmation dialog before registration
//   Future<bool> _showConfirmationDialog() async {
//     return await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: [
//             Icon(Icons.info_outline_rounded, color: _C.gold, size: 28),
//             const SizedBox(width: 12),
//             const Text(
//               'নিবন্ধনের পূর্বে জেনে রাখুন',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: _C.amberLight,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: _C.amber.withOpacity(0.3)),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.password_rounded, color: _C.amber, size: 22),
//                   const SizedBox(width: 12),
//                   const Expanded(
//                     child: Text(
//                       'পাসওয়ার্ড রিসেট অপশন এখনো নেই',
//                       style:
//                           TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: _C.greenLight,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: _C.green.withOpacity(0.3)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.warning_amber_rounded,
//                           color: _C.green, size: 22),
//                       const SizedBox(width: 12),
//                       const Expanded(
//                         child: Text(
//                           'গুরুত্বপূর্ণ নির্দেশনা',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 14),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   const Text(
//                     '• আপনার পাসওয়ার্ড নিরাপদ স্থানে লিখে রাখুন\n'
//                     '• পাসওয়ার্ড মনে রাখার ব্যবস্থা করুন\n'
//                     '• অন্য কাউকে পাসওয়ার্ড জানাবেন না\n'
//                     '• ভবিষ্যতে লগইনের জন্য পাসওয়ার্ড প্রয়োজন হবে',
//                     style: TextStyle(fontSize: 13, height: 1.5),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: _C.redLight,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: _C.red.withOpacity(0.3)),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.email_rounded, color: _C.red, size: 22),
//                   const SizedBox(width: 12),
//                   const Expanded(
//                     child: Text(
//                       'বাস্তব ইমেইল দিন - ভবিষ্যতে লগইনের জন্য বৈধ ইমেইল প্রয়োজন হবে',
//                       style:
//                           TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             style: TextButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             ),
//             child: const Text('বাতিল', style: TextStyle(fontSize: 14)),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: _C.darkGreen,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//             ),
//             child: const Text('নিবন্ধন করুন', style: TextStyle(fontSize: 14)),
//           ),
//         ],
//       ),
//     ).then((value) => value ?? false);
//   }

//   Future<void> _register() async {
//     if (_isRegistering) return;
//     if (!_validate()) return;

//     // Show confirmation dialog before proceeding
//     final confirmed = await _showConfirmationDialog();
//     if (!confirmed) return;

//     setState(() {
//       _isRegistering = true;
//     });

//     ref.read(authProvider.notifier).clearError();

//     final ok = await ref.read(authProvider.notifier).register(
//           name: _nameCtrl.text.trim(),
//           email: _emailCtrl.text.trim(),
//           password: _passCtrl.text,
//           department: null,
//           designation: null,
//         );

//     if (ok) invalidateUserProviders(ref);

//     setState(() {
//       _isRegistering = false;
//     });

//     if (ok && mounted) {
//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('নিবন্ধন সফল হয়েছে!'),
//           backgroundColor: _C.green,
//           behavior: SnackBarBehavior.floating,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//       context.go(AppRoutes.home);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = ref.watch(authProvider);
//     final isLoading = auth.isLoading || _isRegistering;
//     final size = MediaQuery.of(context).size;

//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: _C.pageBg,
//         body: Stack(
//           children: [
//             // Header Gradient
//             Positioned(
//               top: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 height: size.height * 0.35,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [_C.darkGreen, _C.midGreen],
//                   ),
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(32),
//                     bottomRight: Radius.circular(32),
//                   ),
//                 ),
//                 child: Stack(
//                   children: [
//                     Positioned(
//                       top: -40,
//                       right: -40,
//                       child: Container(
//                         width: 150,
//                         height: 150,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.white.withOpacity(0.05),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: -30,
//                       left: -30,
//                       child: Container(
//                         width: 100,
//                         height: 100,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: _C.gold.withOpacity(0.08),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Main Content
//             SafeArea(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 40),

//                     // Header Content
//                     Column(
//                       children: [
//                         Container(
//                           width: 70,
//                           height: 70,
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                               color: Colors.white.withOpacity(0.25),
//                             ),
//                           ),
//                           child: const Icon(
//                             Icons.person_add_rounded,
//                             color: Colors.white,
//                             size: 35,
//                           ),
//                         ).animate().scale(
//                               duration: 500.ms,
//                               curve: Curves.elasticOut,
//                               begin: const Offset(0.5, 0.5),
//                             ),
//                         const SizedBox(height: 20),
//                         Text(
//                           'নতুন অ্যাকাউন্ট',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 28,
//                             fontWeight: FontWeight.w800,
//                             letterSpacing: -0.5,
//                           ),
//                         ).animate(delay: 100.ms).fadeIn().slideY(begin: -0.1),
//                         const SizedBox(height: 8),
//                         Text(
//                           'নিবন্ধন করে শুরু করুন',
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.8),
//                             fontSize: 14,
//                           ),
//                         ).animate(delay: 150.ms).fadeIn(),
//                       ],
//                     ),

//                     const SizedBox(height: 32),

//                     // Form Card
//                     IgnorePointer(
//                       ignoring: isLoading,
//                       child: Opacity(
//                         opacity: isLoading ? 0.6 : 1.0,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: _C.cardBg,
//                             borderRadius: BorderRadius.circular(24),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 20,
//                                 offset: const Offset(0, 8),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               // Form Fields
//                               Padding(
//                                 padding: const EdgeInsets.all(24),
//                                 child: Column(
//                                   children: [
//                                     // API Error
//                                     if (auth.error != null) ...[
//                                       _ErrorBanner(auth.error!),
//                                       const SizedBox(height: 20),
//                                     ],

//                                     // Name Field
//                                     _Field(
//                                       label: 'পূর্ণ নাম',
//                                       icon: Icons.person_outline_rounded,
//                                       controller: _nameCtrl,
//                                       focusNode: _nameFocus,
//                                       hint: 'আপনার পূর্ণ নাম লিখুন',
//                                       error: _nameErr,
//                                       onChanged: _onNameChange,
//                                       onSubmit: () =>
//                                           _emailFocus.requestFocus(),
//                                     )
//                                         .animate(delay: 200.ms)
//                                         .fadeIn()
//                                         .slideY(begin: 0.05),

//                                     const SizedBox(height: 18),

//                                     // Email Field
//                                     _Field(
//                                       label: 'ইমেইল ঠিকানা',
//                                       icon: Icons.alternate_email_rounded,
//                                       controller: _emailCtrl,
//                                       focusNode: _emailFocus,
//                                       hint: 'example@email.com',
//                                       keyboardType: TextInputType.emailAddress,
//                                       error: _emailErr,
//                                       onChanged: _onEmailChange,
//                                       onSubmit: () => _passFocus.requestFocus(),
//                                     )
//                                         .animate(delay: 250.ms)
//                                         .fadeIn()
//                                         .slideY(begin: 0.05),

//                                     const SizedBox(height: 18),

//                                     // Password Field
//                                     _PasswordField(
//                                       label: 'পাসওয়ার্ড',
//                                       controller: _passCtrl,
//                                       focusNode: _passFocus,
//                                       hint: 'কমপক্ষে ৬ অক্ষর',
//                                       error: _passErr,
//                                       onChanged: _onPassChange,
//                                       onSubmit: () =>
//                                           _cfPassFocus.requestFocus(),
//                                     )
//                                         .animate(delay: 300.ms)
//                                         .fadeIn()
//                                         .slideY(begin: 0.05),

//                                     // Password Strength
//                                     if (_passCtrl.text.isNotEmpty &&
//                                         _passErr == null) ...[
//                                       const SizedBox(height: 12),
//                                       _PasswordStrengthBar(
//                                           password: _passCtrl.text),
//                                     ],

//                                     const SizedBox(height: 18),

//                                     // Confirm Password Field
//                                     _PasswordField(
//                                       label: 'পাসওয়ার্ড নিশ্চিত করুন',
//                                       controller: _cfPassCtrl,
//                                       focusNode: _cfPassFocus,
//                                       hint: 'পাসওয়ার্ড আবার লিখুন',
//                                       error: _cfPassErr,
//                                       onChanged: _onCfPassChange,
//                                       onSubmit: _register,
//                                       textInputAction: TextInputAction.done,
//                                     )
//                                         .animate(delay: 350.ms)
//                                         .fadeIn()
//                                         .slideY(begin: 0.05),
//                                   ],
//                                 ),
//                               ),

//                               // Register Button
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(24, 0, 24, 24),
//                                 child: _PrimaryButton(
//                                   label: isLoading
//                                       ? 'নিবন্ধন হচ্ছে...'
//                                       : 'নিবন্ধন করুন',
//                                   icon: isLoading
//                                       ? null
//                                       : Icons.check_circle_rounded,
//                                   onTap: isLoading ? null : _register,
//                                   isLoading: isLoading,
//                                 )
//                                     .animate(delay: 400.ms)
//                                     .fadeIn()
//                                     .slideY(begin: 0.05),
//                               ),
//                             ],
//                           ),
//                         ).animate(delay: 180.ms).fadeIn().slideY(begin: 0.1),
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     // Login Link
//                     GestureDetector(
//                       onTap:
//                           isLoading ? null : () => context.go(AppRoutes.login),
//                       child: Opacity(
//                         opacity: isLoading ? 0.4 : 1.0,
//                         child: RichText(
//                           text: TextSpan(
//                             text: 'ইতিমধ্যে অ্যাকাউন্ট আছে? ',
//                             style: const TextStyle(
//                               color: _C.textSecondary,
//                               fontSize: 14,
//                             ),
//                             children: const [
//                               TextSpan(
//                                 text: 'লগইন করুন',
//                                 style: TextStyle(
//                                   color: _C.darkGreen,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ).animate(delay: 450.ms).fadeIn(),

//                     const SizedBox(height: 32),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // TEXT FIELD
// // ─────────────────────────────────────────────────────────────────────────────

// class _Field extends StatefulWidget {
//   final String label;
//   final IconData icon;
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final String hint;
//   final String? error;
//   final TextInputType keyboardType;
//   final TextInputAction textInputAction;
//   final void Function(String)? onChanged;
//   final VoidCallback onSubmit;

//   const _Field({
//     required this.label,
//     required this.icon,
//     required this.controller,
//     required this.focusNode,
//     required this.hint,
//     this.error,
//     this.keyboardType = TextInputType.text,
//     this.textInputAction = TextInputAction.next,
//     this.onChanged,
//     required this.onSubmit,
//   });

//   @override
//   State<_Field> createState() => _FieldState();
// }

// class _FieldState extends State<_Field> {
//   bool _focused = false;
//   late final VoidCallback _focusListener;

//   @override
//   void initState() {
//     super.initState();
//     _focusListener = () {
//       if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
//     };
//     widget.focusNode.addListener(_focusListener);
//   }

//   @override
//   void dispose() {
//     widget.focusNode.removeListener(_focusListener);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hasErr = widget.error != null && widget.error!.isNotEmpty;
//     final iconColor = hasErr
//         ? _C.red
//         : _focused
//             ? _C.darkGreen
//             : _C.textSecondary;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.label,
//           style: TextStyle(
//             color: hasErr
//                 ? _C.red
//                 : _focused
//                     ? _C.darkGreen
//                     : _C.textPrimary,
//             fontWeight: FontWeight.w600,
//             fontSize: 13,
//           ),
//         ),
//         const SizedBox(height: 8),
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 180),
//           curve: Curves.easeOutCubic,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             boxShadow: _focused && !hasErr
//                 ? [
//                     BoxShadow(
//                       color: _C.darkGreen.withOpacity(0.08),
//                       blurRadius: 12,
//                       offset: const Offset(0, 4),
//                     )
//                   ]
//                 : [],
//           ),
//           child: TextField(
//             controller: widget.controller,
//             focusNode: widget.focusNode,
//             keyboardType: widget.keyboardType,
//             textInputAction: widget.textInputAction,
//             onChanged: widget.onChanged,
//             onEditingComplete: widget.onSubmit,
//             onSubmitted: (_) => widget.onSubmit(),
//             style: const TextStyle(
//               color: _C.textPrimary,
//               fontWeight: FontWeight.w500,
//               fontSize: 15,
//             ),
//             decoration: InputDecoration(
//               hintText: widget.hint,
//               hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
//               prefixIcon: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Icon(widget.icon, size: 20, color: iconColor),
//               ),
//               prefixIconConstraints: const BoxConstraints(minWidth: 54),
//               filled: true,
//               fillColor: hasErr
//                   ? _C.red.withOpacity(0.04)
//                   : _focused
//                       ? _C.cardBg
//                       : _C.surfaceAlt,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: const BorderSide(color: _C.border),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                   color: hasErr ? _C.red.withOpacity(0.5) : _C.border,
//                   width: 1,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                   color: hasErr ? _C.red : _C.darkGreen,
//                   width: 1.5,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//             ),
//           ),
//         ),
//         AnimatedSize(
//           duration: const Duration(milliseconds: 180),
//           curve: Curves.easeOutCubic,
//           child: hasErr
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 6, left: 4),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.error_rounded, size: 13, color: _C.red),
//                       const SizedBox(width: 6),
//                       Text(
//                         widget.error!,
//                         style: const TextStyle(
//                           color: _C.red,
//                           fontSize: 11.5,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : const SizedBox.shrink(),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PASSWORD FIELD
// // ─────────────────────────────────────────────────────────────────────────────

// class _PasswordField extends StatefulWidget {
//   final String label;
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final String hint;
//   final String? error;
//   final TextInputAction textInputAction;
//   final void Function(String) onChanged;
//   final VoidCallback onSubmit;

//   const _PasswordField({
//     required this.label,
//     required this.controller,
//     required this.focusNode,
//     required this.hint,
//     this.error,
//     this.textInputAction = TextInputAction.next,
//     required this.onChanged,
//     required this.onSubmit,
//   });

//   @override
//   State<_PasswordField> createState() => _PasswordFieldState();
// }

// class _PasswordFieldState extends State<_PasswordField> {
//   bool _focused = false;
//   bool _obscure = true;
//   late final VoidCallback _focusListener;

//   @override
//   void initState() {
//     super.initState();
//     _focusListener = () {
//       if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
//     };
//     widget.focusNode.addListener(_focusListener);
//   }

//   @override
//   void dispose() {
//     widget.focusNode.removeListener(_focusListener);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hasErr = widget.error != null && widget.error!.isNotEmpty;
//     final iconColor = hasErr
//         ? _C.red
//         : _focused
//             ? _C.darkGreen
//             : _C.textSecondary;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.label,
//           style: TextStyle(
//             color: hasErr
//                 ? _C.red
//                 : _focused
//                     ? _C.darkGreen
//                     : _C.textPrimary,
//             fontWeight: FontWeight.w600,
//             fontSize: 13,
//           ),
//         ),
//         const SizedBox(height: 8),
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 180),
//           curve: Curves.easeOutCubic,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             boxShadow: _focused && !hasErr
//                 ? [
//                     BoxShadow(
//                       color: _C.darkGreen.withOpacity(0.08),
//                       blurRadius: 12,
//                       offset: const Offset(0, 4),
//                     )
//                   ]
//                 : [],
//           ),
//           child: TextField(
//             controller: widget.controller,
//             focusNode: widget.focusNode,
//             obscureText: _obscure,
//             textInputAction: widget.textInputAction,
//             onChanged: widget.onChanged,
//             onEditingComplete: widget.onSubmit,
//             onSubmitted: (_) => widget.onSubmit(),
//             style: const TextStyle(
//               color: _C.textPrimary,
//               fontWeight: FontWeight.w500,
//               fontSize: 15,
//             ),
//             decoration: InputDecoration(
//               hintText: widget.hint,
//               hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
//               prefixIcon: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Icon(Icons.lock_outline_rounded,
//                     size: 20, color: iconColor),
//               ),
//               prefixIconConstraints: const BoxConstraints(minWidth: 54),
//               suffixIcon: GestureDetector(
//                 onTap: () => setState(() => _obscure = !_obscure),
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 16),
//                   child: Icon(
//                     _obscure
//                         ? Icons.visibility_outlined
//                         : Icons.visibility_off_outlined,
//                     size: 20,
//                     color: _focused ? _C.darkGreen : _C.textSecondary,
//                   ),
//                 ),
//               ),
//               suffixIconConstraints: const BoxConstraints(minWidth: 50),
//               filled: true,
//               fillColor: hasErr
//                   ? _C.red.withOpacity(0.04)
//                   : _focused
//                       ? _C.cardBg
//                       : _C.surfaceAlt,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: const BorderSide(color: _C.border),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                   color: hasErr ? _C.red.withOpacity(0.5) : _C.border,
//                   width: 1,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                   color: hasErr ? _C.red : _C.darkGreen,
//                   width: 1.5,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//             ),
//           ),
//         ),
//         AnimatedSize(
//           duration: const Duration(milliseconds: 180),
//           curve: Curves.easeOutCubic,
//           child: hasErr
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 6, left: 4),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.error_rounded, size: 13, color: _C.red),
//                       const SizedBox(width: 6),
//                       Text(
//                         widget.error!,
//                         style: const TextStyle(
//                           color: _C.red,
//                           fontSize: 11.5,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : const SizedBox.shrink(),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PASSWORD STRENGTH BAR
// // ─────────────────────────────────────────────────────────────────────────────

// class _PasswordStrengthBar extends StatelessWidget {
//   final String password;
//   const _PasswordStrengthBar({required this.password});

//   int get _score {
//     int s = 0;
//     if (password.length >= 6) s++;
//     if (password.length >= 10) s++;
//     if (password.contains(RegExp(r'[A-Z]'))) s++;
//     if (password.contains(RegExp(r'[0-9]'))) s++;
//     if (password.contains(RegExp(r'[^A-Za-z0-9]'))) s++;
//     return s;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final s = _score;
//     final color = s <= 1
//         ? _C.red
//         : s <= 3
//             ? _C.amber
//             : _C.green;
//     final label = s <= 1
//         ? 'দুর্বল'
//         : s <= 3
//             ? 'মাঝারি'
//             : 'শক্তিশালী';

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       curve: Curves.easeOutCubic,
//       child: Row(
//         children: [
//           Expanded(
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(99),
//               child: LinearProgressIndicator(
//                 value: s / 5,
//                 minHeight: 4,
//                 backgroundColor: _C.border,
//                 valueColor: AlwaysStoppedAnimation(color),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w700,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // ERROR BANNER
// // ─────────────────────────────────────────────────────────────────────────────

// class _ErrorBanner extends StatelessWidget {
//   final String message;
//   const _ErrorBanner(this.message);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         color: _C.redLight,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: _C.red.withOpacity(0.25)),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.error_outline_rounded, color: _C.red, size: 18),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               message,
//               style: const TextStyle(
//                 color: _C.red,
//                 fontSize: 12.5,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PRIMARY BUTTON
// // ─────────────────────────────────────────────────────────────────────────────

// class _PrimaryButton extends StatelessWidget {
//   final String label;
//   final IconData? icon;
//   final VoidCallback? onTap;
//   final bool isLoading;

//   const _PrimaryButton({
//     required this.label,
//     this.icon,
//     this.onTap,
//     this.isLoading = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final enabled = onTap != null && !isLoading;

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 180),
//       curve: Curves.easeOutCubic,
//       height: 54,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: enabled ? _C.darkGreen : _C.borderMid,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: enabled
//             ? [
//                 BoxShadow(
//                   color: _C.darkGreen.withOpacity(0.3),
//                   blurRadius: 12,
//                   offset: const Offset(0, 6),
//                 )
//               ]
//             : [],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: Center(
//             child: isLoading
//                 ? const SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2.5,
//                       color: Colors.white,
//                     ),
//                   )
//                 : Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       if (icon != null) ...[
//                         Icon(icon, color: Colors.white, size: 20),
//                         const SizedBox(width: 10),
//                       ],
//                       Text(
//                         label,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w700,
//                           fontSize: 16,
//                           letterSpacing: -0.2,
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:amal_tracker/features/auth/providers/provider_reset.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../providers/auth_provider.dart';
// import '../../../core/router/app_router.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // DESIGN TOKENS
// // ─────────────────────────────────────────────────────────────────────────────

// class _C {
//   static const pageBg = Color(0xFFF4F6F1);
//   static const cardBg = Color(0xFFFFFFFF);
//   static const darkGreen = Color(0xFF0E3D22);
//   static const midGreen = Color(0xFF1B7045);
//   static const gold = Color(0xFFD4A843);
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const amber = Color(0xFFF59E0B);
//   static const amberLight = Color(0xFFFFF3E0);
//   static const red = Color(0xFFEF4444);
//   static const redLight = Color(0xFFFEF2F2);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
//   static const border = Color(0xFFE4EAE4);
//   static const borderMid = Color(0xFFD0DAD2);
//   static const surfaceAlt = Color(0xFFF8FAF8);
// }

// // Common districts of Bangladesh (you can modify as needed)
// const List<String> _bangladeshDistricts = [
//   'ঢাকা',
//   'চট্টগ্রাম',
//   'রাজশাহী',
//   'খুলনা',
//   'বরিশাল',
//   'সিলেট',
//   'রংপুর',
//   'ময়মনসিংহ',
//   'ফরিদপুর',
//   'গাজীপুর',
//   'নারায়ণগঞ্জ',
//   'কুমিল্লা',
//   'ব্রাহ্মণবাড়িয়া',
//   'চাঁদপুর',
//   'লক্ষ্মীপুর',
//   'নোয়াখালী',
//   'ফেনী',
//   'কক্সবাজার',
//   'বান্দরবান',
//   'রাঙ্গামাটি',
//   'খাগড়াছড়ি',
//   'মৌলভীবাজার',
//   'হবিগঞ্জ',
//   'সুনামগঞ্জ',
//   'নেত্রকোণা',
//   'কিশোরগঞ্জ',
//   'মানিকগঞ্জ',
//   'মুন্সীগঞ্জ',
//   'টাঙ্গাইল',
//   'নরসিংদী',
//   'শরীয়তপুর',
//   'মাদারীপুর',
//   'গোপালগঞ্জ',
//   'ঝালকাঠি',
//   'পিরোজপুর',
//   'বরগুনা',
//   'পটুয়াখালী',
//   'ভোলা',
//   'নাটোর',
//   'পাবনা',
//   'সিরাজগঞ্জ',
//   'বগুড়া',
//   'জয়পুরহাট',
//   'চাঁপাইনবাবগঞ্জ',
//   'নওগাঁ',
//   'দিনাজপুর',
//   'লালমনিরহাট',
//   'নীলফামারী',
//   'পঞ্চগড়',
//   'ঠাকুরগাঁও',
//   'কুড়িগ্রাম',
//   'গাইবান্ধা',
//   'যশোর',
//   'ঝিনাইদহ',
//   'মাগুরা',
//   'নড়াইল',
//   'বাগেরহাট',
//   'সাতক্ষীরা',
//   'কুষ্টিয়া',
//   'মেহেরপুর',
//   'চুয়াডাঙ্গা'
// ];

// // ─────────────────────────────────────────────────────────────────────────────
// // REGISTER SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// class RegisterScreen extends ConsumerStatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends ConsumerState<RegisterScreen> {
//   final _nameCtrl = TextEditingController();
//   final _emailCtrl = TextEditingController();
//   final _passCtrl = TextEditingController();
//   final _cfPassCtrl = TextEditingController();
//   final _districtCtrl = TextEditingController();

//   final _nameFocus = FocusNode();
//   final _emailFocus = FocusNode();
//   final _passFocus = FocusNode();
//   final _cfPassFocus = FocusNode();
//   final _districtFocus = FocusNode();

//   bool _submitted = false;
//   bool _isRegistering = false;
//   String? _selectedDistrict;

//   String? _nameErr, _emailErr, _passErr, _cfPassErr, _districtErr;

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _emailCtrl.dispose();
//     _passCtrl.dispose();
//     _cfPassCtrl.dispose();
//     _districtCtrl.dispose();
//     _nameFocus.dispose();
//     _emailFocus.dispose();
//     _passFocus.dispose();
//     _cfPassFocus.dispose();
//     _districtFocus.dispose();
//     super.dispose();
//   }

//   void _onNameChange(String v) {
//     if (!_submitted) return;
//     setState(() {
//       _nameErr = v.trim().length < 2 ? 'নাম কমপক্ষে ২ অক্ষর হতে হবে' : null;
//     });
//   }

//   void _onEmailChange(String v) {
//     if (!_submitted) return;
//     setState(() {
//       if (v.trim().isEmpty) {
//         _emailErr = 'ইমেইল দিন';
//       } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) {
//         _emailErr = 'সঠিক ইমেইল ঠিকানা দিন';
//       } else {
//         _emailErr = null;
//       }
//     });
//   }

//   void _onPassChange(String v) {
//     if (!_submitted) return;
//     setState(() {
//       if (v.isEmpty) {
//         _passErr = 'পাসওয়ার্ড দিন';
//       } else if (v.length < 6) {
//         _passErr = 'কমপক্ষে ৬ অক্ষর হতে হবে';
//       } else {
//         _passErr = null;
//       }

//       if (_cfPassCtrl.text.isNotEmpty) {
//         _cfPassErr = _cfPassCtrl.text != v ? 'পাসওয়ার্ড মিলছে না' : null;
//       }
//     });
//   }

//   void _onCfPassChange(String v) {
//     if (!_submitted) return;
//     setState(() {
//       _cfPassErr = v != _passCtrl.text ? 'পাসওয়ার্ড মিলছে না' : null;
//     });
//   }

//   void _onDistrictChanged(String? district) {
//     if (!_submitted) return;
//     setState(() {
//       _selectedDistrict = district;
//       _districtErr =
//           district == null || district.isEmpty ? 'জেলা নির্বাচন করুন' : null;
//     });
//   }

//   bool _validate() {
//     setState(() {
//       _submitted = true;

//       final name = _nameCtrl.text.trim();
//       final email = _emailCtrl.text.trim();
//       final pass = _passCtrl.text;
//       final cf = _cfPassCtrl.text;

//       _nameErr = name.length < 2 ? 'নাম কমপক্ষে ২ অক্ষর হতে হবে' : null;

//       _emailErr = email.isEmpty
//           ? 'ইমেইল দিন'
//           : !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
//               ? 'সঠিক ইমেইল ঠিকানা দিন'
//               : null;

//       _passErr = pass.isEmpty
//           ? 'পাসওয়ার্ড দিন'
//           : pass.length < 6
//               ? 'কমপক্ষে ৬ অক্ষর হতে হবে'
//               : null;

//       _cfPassErr = cf != pass ? 'পাসওয়ার্ড মিলছে না' : null;

//       _districtErr = _selectedDistrict == null || _selectedDistrict!.isEmpty
//           ? 'জেলা নির্বাচন করুন'
//           : null;
//     });

//     return _nameErr == null &&
//         _emailErr == null &&
//         _passErr == null &&
//         _cfPassErr == null &&
//         _districtErr == null;
//   }

//   // Show confirmation dialog before registration
//   Future<bool> _showConfirmationDialog() async {
//     return await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: [
//             Icon(Icons.info_outline_rounded, color: _C.gold, size: 28),
//             const SizedBox(width: 12),
//             const Text(
//               'নিবন্ধনের পূর্বে জেনে রাখুন',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: _C.amberLight,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: _C.amber.withOpacity(0.3)),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.password_rounded, color: _C.amber, size: 22),
//                   const SizedBox(width: 12),
//                   const Expanded(
//                     child: Text(
//                       'পাসওয়ার্ড রিসেট অপশন এখনো নেই',
//                       style:
//                           TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: _C.greenLight,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: _C.green.withOpacity(0.3)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.warning_amber_rounded,
//                           color: _C.green, size: 22),
//                       const SizedBox(width: 12),
//                       const Expanded(
//                         child: Text(
//                           'গুরুত্বপূর্ণ নির্দেশনা',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 14),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   const Text(
//                     '• আপনার পাসওয়ার্ড নিরাপদ স্থানে লিখে রাখুন\n'
//                     '• পাসওয়ার্ড মনে রাখার ব্যবস্থা করুন\n'
//                     '• অন্য কাউকে পাসওয়ার্ড জানাবেন না\n'
//                     '• ভবিষ্যতে লগইনের জন্য পাসওয়ার্ড প্রয়োজন হবে',
//                     style: TextStyle(fontSize: 13, height: 1.5),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: _C.redLight,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: _C.red.withOpacity(0.3)),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.email_rounded, color: _C.red, size: 22),
//                   const SizedBox(width: 12),
//                   const Expanded(
//                     child: Text(
//                       'বাস্তব ইমেইল দিন - ভবিষ্যতে লগইনের জন্য বৈধ ইমেইল প্রয়োজন হবে',
//                       style:
//                           TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             style: TextButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             ),
//             child: const Text('বাতিল', style: TextStyle(fontSize: 14)),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: _C.darkGreen,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//             ),
//             child: const Text('নিবন্ধন করুন', style: TextStyle(fontSize: 14)),
//           ),
//         ],
//       ),
//     ).then((value) => value ?? false);
//   }

//   Future<void> _register() async {
//     if (_isRegistering) return;
//     if (!_validate()) return;

//     // Show confirmation dialog before proceeding
//     final confirmed = await _showConfirmationDialog();
//     if (!confirmed) return;

//     setState(() {
//       _isRegistering = true;
//     });

//     ref.read(authProvider.notifier).clearError();

//     final ok = await ref.read(authProvider.notifier).register(
//           name: _nameCtrl.text.trim(),
//           email: _emailCtrl.text.trim(),
//           password: _passCtrl.text,
//           district: _selectedDistrict!, // Required field
//           department: null,
//           designation: null,
//           phone: null,
//           photoUrl: null,
//           gender: null,
//         );

//     if (ok) invalidateUserProviders(ref);

//     setState(() {
//       _isRegistering = false;
//     });

//     if (ok && mounted) {
//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('নিবন্ধন সফল হয়েছে!'),
//           backgroundColor: _C.green,
//           behavior: SnackBarBehavior.floating,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//       context.go(AppRoutes.home);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = ref.watch(authProvider);
//     final isLoading = auth.isLoading || _isRegistering;
//     final size = MediaQuery.of(context).size;

//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: _C.pageBg,
//         body: Stack(
//           children: [
//             // Header Gradient
//             Positioned(
//               top: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 height: size.height * 0.35,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [_C.darkGreen, _C.midGreen],
//                   ),
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(32),
//                     bottomRight: Radius.circular(32),
//                   ),
//                 ),
//                 child: Stack(
//                   children: [
//                     Positioned(
//                       top: -40,
//                       right: -40,
//                       child: Container(
//                         width: 150,
//                         height: 150,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.white.withOpacity(0.05),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: -30,
//                       left: -30,
//                       child: Container(
//                         width: 100,
//                         height: 100,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: _C.gold.withOpacity(0.08),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Main Content
//             SafeArea(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 40),

//                     // Header Content
//                     Column(
//                       children: [
//                         Container(
//                           width: 70,
//                           height: 70,
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                               color: Colors.white.withOpacity(0.25),
//                             ),
//                           ),
//                           child: const Icon(
//                             Icons.person_add_rounded,
//                             color: Colors.white,
//                             size: 35,
//                           ),
//                         ).animate().scale(
//                               duration: 500.ms,
//                               curve: Curves.elasticOut,
//                               begin: const Offset(0.5, 0.5),
//                             ),
//                         const SizedBox(height: 20),
//                         Text(
//                           'নতুন অ্যাকাউন্ট',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 28,
//                             fontWeight: FontWeight.w800,
//                             letterSpacing: -0.5,
//                           ),
//                         ).animate(delay: 100.ms).fadeIn().slideY(begin: -0.1),
//                         const SizedBox(height: 8),
//                         Text(
//                           'নিবন্ধন করে শুরু করুন',
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.8),
//                             fontSize: 14,
//                           ),
//                         ).animate(delay: 150.ms).fadeIn(),
//                       ],
//                     ),

//                     const SizedBox(height: 32),

//                     // Form Card
//                     IgnorePointer(
//                       ignoring: isLoading,
//                       child: Opacity(
//                         opacity: isLoading ? 0.6 : 1.0,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: _C.cardBg,
//                             borderRadius: BorderRadius.circular(24),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 20,
//                                 offset: const Offset(0, 8),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               // Form Fields
//                               Padding(
//                                 padding: const EdgeInsets.all(24),
//                                 child: Column(
//                                   children: [
//                                     // API Error
//                                     if (auth.error != null) ...[
//                                       _ErrorBanner(auth.error!),
//                                       const SizedBox(height: 20),
//                                     ],

//                                     // Name Field
//                                     _Field(
//                                       label: 'পূর্ণ নাম',
//                                       icon: Icons.person_outline_rounded,
//                                       controller: _nameCtrl,
//                                       focusNode: _nameFocus,
//                                       hint: 'আপনার পূর্ণ নাম লিখুন',
//                                       error: _nameErr,
//                                       onChanged: _onNameChange,
//                                       onSubmit: () =>
//                                           _emailFocus.requestFocus(),
//                                     )
//                                         .animate(delay: 200.ms)
//                                         .fadeIn()
//                                         .slideY(begin: 0.05),

//                                     const SizedBox(height: 18),

//                                     // Email Field
//                                     _Field(
//                                       label: 'ইমেইল ঠিকানা',
//                                       icon: Icons.alternate_email_rounded,
//                                       controller: _emailCtrl,
//                                       focusNode: _emailFocus,
//                                       hint: 'example@email.com',
//                                       keyboardType: TextInputType.emailAddress,
//                                       error: _emailErr,
//                                       onChanged: _onEmailChange,
//                                       onSubmit: () =>
//                                           _districtFocus.requestFocus(),
//                                     )
//                                         .animate(delay: 250.ms)
//                                         .fadeIn()
//                                         .slideY(begin: 0.05),

//                                     const SizedBox(height: 18),

//                                     // District Field (Dropdown)
//                                     _DistrictDropdownField(
//                                       label: 'জেলা',
//                                       icon: Icons.location_city_rounded,
//                                       focusNode: _districtFocus,
//                                       selectedDistrict: _selectedDistrict,
//                                       districts: _bangladeshDistricts,
//                                       onChanged: _onDistrictChanged,
//                                       error: _districtErr,
//                                       onSubmit: () => _passFocus.requestFocus(),
//                                     )
//                                         .animate(delay: 275.ms)
//                                         .fadeIn()
//                                         .slideY(begin: 0.05),

//                                     const SizedBox(height: 18),

//                                     // Password Field
//                                     _PasswordField(
//                                       label: 'পাসওয়ার্ড',
//                                       controller: _passCtrl,
//                                       focusNode: _passFocus,
//                                       hint: 'কমপক্ষে ৬ অক্ষর',
//                                       error: _passErr,
//                                       onChanged: _onPassChange,
//                                       onSubmit: () =>
//                                           _cfPassFocus.requestFocus(),
//                                     )
//                                         .animate(delay: 300.ms)
//                                         .fadeIn()
//                                         .slideY(begin: 0.05),

//                                     // Password Strength
//                                     if (_passCtrl.text.isNotEmpty &&
//                                         _passErr == null) ...[
//                                       const SizedBox(height: 12),
//                                       _PasswordStrengthBar(
//                                           password: _passCtrl.text),
//                                     ],

//                                     const SizedBox(height: 18),

//                                     // Confirm Password Field
//                                     _PasswordField(
//                                       label: 'পাসওয়ার্ড নিশ্চিত করুন',
//                                       controller: _cfPassCtrl,
//                                       focusNode: _cfPassFocus,
//                                       hint: 'পাসওয়ার্ড আবার লিখুন',
//                                       error: _cfPassErr,
//                                       onChanged: _onCfPassChange,
//                                       onSubmit: _register,
//                                       textInputAction: TextInputAction.done,
//                                     )
//                                         .animate(delay: 350.ms)
//                                         .fadeIn()
//                                         .slideY(begin: 0.05),
//                                   ],
//                                 ),
//                               ),

//                               // Register Button
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(24, 0, 24, 24),
//                                 child: _PrimaryButton(
//                                   label: isLoading
//                                       ? 'নিবন্ধন হচ্ছে...'
//                                       : 'নিবন্ধন করুন',
//                                   icon: isLoading
//                                       ? null
//                                       : Icons.check_circle_rounded,
//                                   onTap: isLoading ? null : _register,
//                                   isLoading: isLoading,
//                                 )
//                                     .animate(delay: 400.ms)
//                                     .fadeIn()
//                                     .slideY(begin: 0.05),
//                               ),
//                             ],
//                           ),
//                         ).animate(delay: 180.ms).fadeIn().slideY(begin: 0.1),
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     // Login Link
//                     GestureDetector(
//                       onTap:
//                           isLoading ? null : () => context.go(AppRoutes.login),
//                       child: Opacity(
//                         opacity: isLoading ? 0.4 : 1.0,
//                         child: RichText(
//                           text: TextSpan(
//                             text: 'ইতিমধ্যে অ্যাকাউন্ট আছে? ',
//                             style: const TextStyle(
//                               color: _C.textSecondary,
//                               fontSize: 14,
//                             ),
//                             children: const [
//                               TextSpan(
//                                 text: 'লগইন করুন',
//                                 style: TextStyle(
//                                   color: _C.darkGreen,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ).animate(delay: 450.ms).fadeIn(),

//                     const SizedBox(height: 32),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DISTRICT DROPDOWN FIELD
// // ─────────────────────────────────────────────────────────────────────────────
// // ─────────────────────────────────────────────────────────────────────────────
// // DISTRICT SELECTION DIALOG (Full-featured with search)
// // ─────────────────────────────────────────────────────────────────────────────
// // ─────────────────────────────────────────────────────────────────────────────
// // DISTRICT DROPDOWN FIELD (SIMPLE WORKING VERSION)
// // ─────────────────────────────────────────────────────────────────────────────

// class _DistrictDropdownField extends StatefulWidget {
//   final String label;
//   final IconData icon;
//   final FocusNode focusNode;
//   final String? selectedDistrict;
//   final List<String> districts;
//   final void Function(String?)? onChanged;
//   final String? error;
//   final VoidCallback onSubmit;

//   const _DistrictDropdownField({
//     required this.label,
//     required this.icon,
//     required this.focusNode,
//     required this.selectedDistrict,
//     required this.districts,
//     this.onChanged,
//     this.error,
//     required this.onSubmit,
//   });

//   @override
//   State<_DistrictDropdownField> createState() => _DistrictDropdownFieldState();
// }

// class _DistrictDropdownFieldState extends State<_DistrictDropdownField> {
//   @override
//   Widget build(BuildContext context) {
//     final hasErr = widget.error != null && widget.error!.isNotEmpty;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           widget.label,
//           style: TextStyle(
//             color: hasErr ? _C.red : _C.textPrimary,
//             fontWeight: FontWeight.w600,
//             fontSize: 13,
//           ),
//         ),
//         const SizedBox(height: 8),

//         // Dropdown Button
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(
//               color: hasErr ? _C.red : _C.border,
//               width: 1,
//             ),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButtonFormField<String>(
//               value: widget.selectedDistrict,
//               isExpanded: true,
//               isDense: true,
//               hint: const Text('জেলা নির্বাচন করুন'),
//               decoration: InputDecoration(
//                 prefixIcon:
//                     Icon(widget.icon, size: 20, color: _C.textSecondary),
//                 border: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 focusedErrorBorder: InputBorder.none,
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 14,
//                 ),
//               ),
//               dropdownColor: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               items: widget.districts.map((district) {
//                 return DropdownMenuItem<String>(
//                   value: district,
//                   child: Text(
//                     district,
//                     style: const TextStyle(fontSize: 14),
//                   ),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 widget.onChanged?.call(value);
//                 widget.onSubmit();
//               },
//               icon: Icon(
//                 Icons.arrow_drop_down,
//                 color: hasErr ? _C.red : _C.textSecondary,
//               ),
//             ),
//           ),
//         ),

//         // Error message
//         if (hasErr)
//           Padding(
//             padding: const EdgeInsets.only(top: 6, left: 4),
//             child: Row(
//               children: [
//                 Icon(Icons.error_rounded, size: 13, color: _C.red),
//                 const SizedBox(width: 6),
//                 Expanded(
//                   child: Text(
//                     widget.error!,
//                     style: TextStyle(
//                       color: _C.red,
//                       fontSize: 11.5,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // TEXT FIELD (Keep existing code)
// // ─────────────────────────────────────────────────────────────────────────────

// class _Field extends StatefulWidget {
//   final String label;
//   final IconData icon;
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final String hint;
//   final String? error;
//   final TextInputType keyboardType;
//   final TextInputAction textInputAction;
//   final void Function(String)? onChanged;
//   final VoidCallback onSubmit;

//   const _Field({
//     required this.label,
//     required this.icon,
//     required this.controller,
//     required this.focusNode,
//     required this.hint,
//     this.error,
//     this.keyboardType = TextInputType.text,
//     this.textInputAction = TextInputAction.next,
//     this.onChanged,
//     required this.onSubmit,
//   });

//   @override
//   State<_Field> createState() => _FieldState();
// }

// class _FieldState extends State<_Field> {
//   bool _focused = false;
//   late final VoidCallback _focusListener;

//   @override
//   void initState() {
//     super.initState();
//     _focusListener = () {
//       if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
//     };
//     widget.focusNode.addListener(_focusListener);
//   }

//   @override
//   void dispose() {
//     widget.focusNode.removeListener(_focusListener);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hasErr = widget.error != null && widget.error!.isNotEmpty;
//     final iconColor = hasErr
//         ? _C.red
//         : _focused
//             ? _C.darkGreen
//             : _C.textSecondary;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.label,
//           style: TextStyle(
//             color: hasErr
//                 ? _C.red
//                 : _focused
//                     ? _C.darkGreen
//                     : _C.textPrimary,
//             fontWeight: FontWeight.w600,
//             fontSize: 13,
//           ),
//         ),
//         const SizedBox(height: 8),
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 180),
//           curve: Curves.easeOutCubic,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             boxShadow: _focused && !hasErr
//                 ? [
//                     BoxShadow(
//                       color: _C.darkGreen.withOpacity(0.08),
//                       blurRadius: 12,
//                       offset: const Offset(0, 4),
//                     )
//                   ]
//                 : [],
//           ),
//           child: TextField(
//             controller: widget.controller,
//             focusNode: widget.focusNode,
//             keyboardType: widget.keyboardType,
//             textInputAction: widget.textInputAction,
//             onChanged: widget.onChanged,
//             onEditingComplete: widget.onSubmit,
//             onSubmitted: (_) => widget.onSubmit(),
//             style: const TextStyle(
//               color: _C.textPrimary,
//               fontWeight: FontWeight.w500,
//               fontSize: 15,
//             ),
//             decoration: InputDecoration(
//               hintText: widget.hint,
//               hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
//               prefixIcon: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Icon(widget.icon, size: 20, color: iconColor),
//               ),
//               prefixIconConstraints: const BoxConstraints(minWidth: 54),
//               filled: true,
//               fillColor: hasErr
//                   ? _C.red.withOpacity(0.04)
//                   : _focused
//                       ? _C.cardBg
//                       : _C.surfaceAlt,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: const BorderSide(color: _C.border),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                   color: hasErr ? _C.red.withOpacity(0.5) : _C.border,
//                   width: 1,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                   color: hasErr ? _C.red : _C.darkGreen,
//                   width: 1.5,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//             ),
//           ),
//         ),
//         AnimatedSize(
//           duration: const Duration(milliseconds: 180),
//           curve: Curves.easeOutCubic,
//           child: hasErr
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 6, left: 4),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.error_rounded, size: 13, color: _C.red),
//                       const SizedBox(width: 6),
//                       Text(
//                         widget.error!,
//                         style: const TextStyle(
//                           color: _C.red,
//                           fontSize: 11.5,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : const SizedBox.shrink(),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PASSWORD FIELD (Keep existing code)
// // ─────────────────────────────────────────────────────────────────────────────

// class _PasswordField extends StatefulWidget {
//   final String label;
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final String hint;
//   final String? error;
//   final TextInputAction textInputAction;
//   final void Function(String) onChanged;
//   final VoidCallback onSubmit;

//   const _PasswordField({
//     required this.label,
//     required this.controller,
//     required this.focusNode,
//     required this.hint,
//     this.error,
//     this.textInputAction = TextInputAction.next,
//     required this.onChanged,
//     required this.onSubmit,
//   });

//   @override
//   State<_PasswordField> createState() => _PasswordFieldState();
// }

// class _PasswordFieldState extends State<_PasswordField> {
//   bool _focused = false;
//   bool _obscure = true;
//   late final VoidCallback _focusListener;

//   @override
//   void initState() {
//     super.initState();
//     _focusListener = () {
//       if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
//     };
//     widget.focusNode.addListener(_focusListener);
//   }

//   @override
//   void dispose() {
//     widget.focusNode.removeListener(_focusListener);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hasErr = widget.error != null && widget.error!.isNotEmpty;
//     final iconColor = hasErr
//         ? _C.red
//         : _focused
//             ? _C.darkGreen
//             : _C.textSecondary;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.label,
//           style: TextStyle(
//             color: hasErr
//                 ? _C.red
//                 : _focused
//                     ? _C.darkGreen
//                     : _C.textPrimary,
//             fontWeight: FontWeight.w600,
//             fontSize: 13,
//           ),
//         ),
//         const SizedBox(height: 8),
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 180),
//           curve: Curves.easeOutCubic,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             boxShadow: _focused && !hasErr
//                 ? [
//                     BoxShadow(
//                       color: _C.darkGreen.withOpacity(0.08),
//                       blurRadius: 12,
//                       offset: const Offset(0, 4),
//                     )
//                   ]
//                 : [],
//           ),
//           child: TextField(
//             controller: widget.controller,
//             focusNode: widget.focusNode,
//             obscureText: _obscure,
//             textInputAction: widget.textInputAction,
//             onChanged: widget.onChanged,
//             onEditingComplete: widget.onSubmit,
//             onSubmitted: (_) => widget.onSubmit(),
//             style: const TextStyle(
//               color: _C.textPrimary,
//               fontWeight: FontWeight.w500,
//               fontSize: 15,
//             ),
//             decoration: InputDecoration(
//               hintText: widget.hint,
//               hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
//               prefixIcon: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Icon(Icons.lock_outline_rounded,
//                     size: 20, color: iconColor),
//               ),
//               prefixIconConstraints: const BoxConstraints(minWidth: 54),
//               suffixIcon: GestureDetector(
//                 onTap: () => setState(() => _obscure = !_obscure),
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 16),
//                   child: Icon(
//                     _obscure
//                         ? Icons.visibility_outlined
//                         : Icons.visibility_off_outlined,
//                     size: 20,
//                     color: _focused ? _C.darkGreen : _C.textSecondary,
//                   ),
//                 ),
//               ),
//               suffixIconConstraints: const BoxConstraints(minWidth: 50),
//               filled: true,
//               fillColor: hasErr
//                   ? _C.red.withOpacity(0.04)
//                   : _focused
//                       ? _C.cardBg
//                       : _C.surfaceAlt,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: const BorderSide(color: _C.border),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                   color: hasErr ? _C.red.withOpacity(0.5) : _C.border,
//                   width: 1,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                   color: hasErr ? _C.red : _C.darkGreen,
//                   width: 1.5,
//                 ),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//             ),
//           ),
//         ),
//         AnimatedSize(
//           duration: const Duration(milliseconds: 180),
//           curve: Curves.easeOutCubic,
//           child: hasErr
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 6, left: 4),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.error_rounded, size: 13, color: _C.red),
//                       const SizedBox(width: 6),
//                       Text(
//                         widget.error!,
//                         style: const TextStyle(
//                           color: _C.red,
//                           fontSize: 11.5,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : const SizedBox.shrink(),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PASSWORD STRENGTH BAR (Keep existing code)
// // ─────────────────────────────────────────────────────────────────────────────

// class _PasswordStrengthBar extends StatelessWidget {
//   final String password;
//   const _PasswordStrengthBar({required this.password});

//   int get _score {
//     int s = 0;
//     if (password.length >= 6) s++;
//     if (password.length >= 10) s++;
//     if (password.contains(RegExp(r'[A-Z]'))) s++;
//     if (password.contains(RegExp(r'[0-9]'))) s++;
//     if (password.contains(RegExp(r'[^A-Za-z0-9]'))) s++;
//     return s;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final s = _score;
//     final color = s <= 1
//         ? _C.red
//         : s <= 3
//             ? _C.amber
//             : _C.green;
//     final label = s <= 1
//         ? 'দুর্বল'
//         : s <= 3
//             ? 'মাঝারি'
//             : 'শক্তিশালী';

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       curve: Curves.easeOutCubic,
//       child: Row(
//         children: [
//           Expanded(
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(99),
//               child: LinearProgressIndicator(
//                 value: s / 5,
//                 minHeight: 4,
//                 backgroundColor: _C.border,
//                 valueColor: AlwaysStoppedAnimation(color),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w700,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // ERROR BANNER (Keep existing code)
// // ─────────────────────────────────────────────────────────────────────────────

// class _ErrorBanner extends StatelessWidget {
//   final String message;
//   const _ErrorBanner(this.message);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         color: _C.redLight,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: _C.red.withOpacity(0.25)),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.error_outline_rounded, color: _C.red, size: 18),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               message,
//               style: const TextStyle(
//                 color: _C.red,
//                 fontSize: 12.5,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PRIMARY BUTTON (Keep existing code)
// // ─────────────────────────────────────────────────────────────────────────────

// class _PrimaryButton extends StatelessWidget {
//   final String label;
//   final IconData? icon;
//   final VoidCallback? onTap;
//   final bool isLoading;

//   const _PrimaryButton({
//     required this.label,
//     this.icon,
//     this.onTap,
//     this.isLoading = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final enabled = onTap != null && !isLoading;

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 180),
//       curve: Curves.easeOutCubic,
//       height: 54,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: enabled ? _C.darkGreen : _C.borderMid,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: enabled
//             ? [
//                 BoxShadow(
//                   color: _C.darkGreen.withOpacity(0.3),
//                   blurRadius: 12,
//                   offset: const Offset(0, 6),
//                 )
//               ]
//             : [],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: Center(
//             child: isLoading
//                 ? const SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2.5,
//                       color: Colors.white,
//                     ),
//                   )
//                 : Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       if (icon != null) ...[
//                         Icon(icon, color: Colors.white, size: 20),
//                         const SizedBox(width: 10),
//                       ],
//                       Text(
//                         label,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w700,
//                           fontSize: 16,
//                           letterSpacing: -0.2,
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:amal_tracker/features/auth/providers/provider_reset.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../core/router/app_router.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────

class _C {
  static const pageBg = Color(0xFFF4F6F1);
  static const cardBg = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const midGreen = Color(0xFF1B7045);
  static const gold = Color(0xFFD4A843);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const amber = Color(0xFFF59E0B);
  static const amberLight = Color(0xFFFFF3E0);
  static const red = Color(0xFFEF4444);
  static const redLight = Color(0xFFFEF2F2);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
  static const border = Color(0xFFE4EAE4);
  static const borderMid = Color(0xFFD0DAD2);
  static const surfaceAlt = Color(0xFFF8FAF8);
}

// ─────────────────────────────────────────────────────────────────────────────
// DISTRICTS LIST
// ─────────────────────────────────────────────────────────────────────────────

const List<String> _bangladeshDistricts = [
  'ঢাকা',
  'চট্টগ্রাম',
  'রাজশাহী',
  'খুলনা',
  'বরিশাল',
  'সিলেট',
  'রংপুর',
  'ময়মনসিংহ',
  'ফরিদপুর',
  'গাজীপুর',
  'নারায়ণগঞ্জ',
  'কুমিল্লা',
  'ব্রাহ্মণবাড়িয়া',
  'চাঁদপুর',
  'লক্ষ্মীপুর',
  'নোয়াখালী',
  'ফেনী',
  'কক্সবাজার',
  'বান্দরবান',
  'রাঙ্গামাটি',
  'খাগড়াছড়ি',
  'মৌলভীবাজার',
  'হবিগঞ্জ',
  'সুনামগঞ্জ',
  'নেত্রকোণা',
  'কিশোরগঞ্জ',
  'মানিকগঞ্জ',
  'মুন্সীগঞ্জ',
  'টাঙ্গাইল',
  'নরসিংদী',
  'শরীয়তপুর',
  'মাদারীপুর',
  'গোপালগঞ্জ',
  'ঝালকাঠি',
  'পিরোজপুর',
  'বরগুনা',
  'পটুয়াখালী',
  'ভোলা',
  'নাটোর',
  'পাবনা',
  'সিরাজগঞ্জ',
  'বগুড়া',
  'জয়পুরহাট',
  'চাঁপাইনবাবগঞ্জ',
  'নওগাঁ',
  'দিনাজপুর',
  'লালমনিরহাট',
  'নীলফামারী',
  'পঞ্চগড়',
  'ঠাকুরগাঁও',
  'কুড়িগ্রাম',
  'গাইবান্ধা',
  'যশোর',
  'ঝিনাইদহ',
  'মাগুরা',
  'নড়াইল',
  'বাগেরহাট',
  'সাতক্ষীরা',
  'কুষ্টিয়া',
  'মেহেরপুর',
  'চুয়াডাঙ্গা',
];

// ─────────────────────────────────────────────────────────────────────────────
// REGISTER SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _cfPassCtrl = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  final _cfPassFocus = FocusNode();

  bool _submitted = false;
  bool _isRegistering = false;
  String? _selectedDistrict;

  String? _nameErr, _emailErr, _passErr, _cfPassErr, _districtErr;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _cfPassCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    _cfPassFocus.dispose();
    super.dispose();
  }

  // ── Live validators ────────────────────────────────────────────────────────

  void _onNameChange(String v) {
    if (!_submitted) return;
    setState(() {
      _nameErr = v.trim().length < 2 ? 'নাম কমপক্ষে ২ অক্ষর হতে হবে' : null;
    });
  }

  void _onEmailChange(String v) {
    if (!_submitted) return;
    setState(() {
      if (v.trim().isEmpty) {
        _emailErr = 'ইমেইল দিন';
      } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) {
        _emailErr = 'সঠিক ইমেইল ঠিকানা দিন';
      } else {
        _emailErr = null;
      }
    });
  }

  void _onPassChange(String v) {
    if (!_submitted) return;
    setState(() {
      if (v.isEmpty) {
        _passErr = 'পাসওয়ার্ড দিন';
      } else if (v.length < 6) {
        _passErr = 'কমপক্ষে ৬ অক্ষর হতে হবে';
      } else {
        _passErr = null;
      }
      if (_cfPassCtrl.text.isNotEmpty) {
        _cfPassErr = _cfPassCtrl.text != v ? 'পাসওয়ার্ড মিলছে না' : null;
      }
    });
  }

  void _onCfPassChange(String v) {
    if (!_submitted) return;
    setState(() {
      _cfPassErr = v != _passCtrl.text ? 'পাসওয়ার্ড মিলছে না' : null;
    });
  }

  void _onDistrictSelected(String? district) {
    setState(() {
      _selectedDistrict = district;
      if (_submitted) {
        _districtErr =
            district == null || district.isEmpty ? 'জেলা নির্বাচন করুন' : null;
      }
    });
  }

  // ── Open district picker bottom sheet ─────────────────────────────────────

  Future<void> _openDistrictPicker() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _DistrictPickerSheet(
        selectedDistrict: _selectedDistrict,
        districts: _bangladeshDistricts,
      ),
    );
    if (result != null) {
      _onDistrictSelected(result);
    }
  }

  // ── Full validate ──────────────────────────────────────────────────────────

  bool _validate() {
    setState(() {
      _submitted = true;
      final name = _nameCtrl.text.trim();
      final email = _emailCtrl.text.trim();
      final pass = _passCtrl.text;
      final cf = _cfPassCtrl.text;

      _nameErr = name.length < 2 ? 'নাম কমপক্ষে ২ অক্ষর হতে হবে' : null;
      _emailErr = email.isEmpty
          ? 'ইমেইল দিন'
          : !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
              ? 'সঠিক ইমেইল ঠিকানা দিন'
              : null;
      _passErr = pass.isEmpty
          ? 'পাসওয়ার্ড দিন'
          : pass.length < 6
              ? 'কমপক্ষে ৬ অক্ষর হতে হবে'
              : null;
      _cfPassErr = cf != pass ? 'পাসওয়ার্ড মিলছে না' : null;
      _districtErr = _selectedDistrict == null || _selectedDistrict!.isEmpty
          ? 'জেলা নির্বাচন করুন'
          : null;
    });

    return _nameErr == null &&
        _emailErr == null &&
        _passErr == null &&
        _cfPassErr == null &&
        _districtErr == null;
  }

  // ── Confirmation dialog ────────────────────────────────────────────────────

  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      // elevation: 0 on the Dialog kills the drop-shadow that bleeds
      // onto the form during the close animation.
      builder: (ctx) => Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Container(
          decoration: BoxDecoration(
            color: _C.cardBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: _C.amberLight,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(Icons.info_outline_rounded,
                          color: _C.amber, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'নিবন্ধনের আগে জানুন',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: _C.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: _C.border),

              // ── Three compact rows ───────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
                child: Column(
                  children: const [
                    _DialogRow(
                      icon: Icons.lock_reset_rounded,
                      iconColor: _C.amber,
                      bg: _C.amberLight,
                      text: 'পাসওয়ার্ড রিসেট এখনো নেই — লিখে রাখুন',
                    ),
                    SizedBox(height: 8),
                    _DialogRow(
                      icon: Icons.shield_outlined,
                      iconColor: _C.green,
                      bg: _C.greenLight,
                      text: 'পাসওয়ার্ড শুধু আপনার — কাউকে জানাবেন না',
                    ),
                    SizedBox(height: 8),
                    _DialogRow(
                      icon: Icons.alternate_email_rounded,
                      iconColor: _C.red,
                      bg: _C.redLight,
                      text: 'সঠিক ইমেইল দিন — লগইনে দরকার হবে',
                    ),
                  ],
                ),
              ),

              // ── Actions ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _C.textSecondary,
                          side: const BorderSide(color: _C.border),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('বাতিল',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _C.darkGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('নিবন্ধন করুন',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((v) => v ?? false);
  }

  // ── Register ───────────────────────────────────────────────────────────────

  Future<void> _register() async {
    if (_isRegistering) return;
    if (!_validate()) return;

    final confirmed = await _showConfirmationDialog();
    if (!confirmed) return;

    setState(() => _isRegistering = true);
    ref.read(authProvider.notifier).clearError();

    final ok = await ref.read(authProvider.notifier).register(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
          district: _selectedDistrict!,
          department: null,
          designation: null,
          phone: null,
          photoUrl: null,
          gender: null,
        );

    if (ok) invalidateUserProviders(ref);
    setState(() => _isRegistering = false);

    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('নিবন্ধন সফল হয়েছে!'),
          backgroundColor: _C.green,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      context.go(AppRoutes.home);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final isLoading = auth.isLoading || _isRegistering;
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _C.pageBg,
        body: Stack(
          children: [
            // ── Header gradient ──────────────────────────────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: size.height * 0.35,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_C.darkGreen, _C.midGreen],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -40,
                      right: -40,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      left: -30,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _C.gold.withOpacity(0.08),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Scrollable content ───────────────────────────────────────
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Header hero
                    Column(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.25)),
                          ),
                          child: const Icon(Icons.person_add_rounded,
                              color: Colors.white, size: 35),
                        ).animate().scale(
                              duration: 500.ms,
                              curve: Curves.elasticOut,
                              begin: const Offset(0.5, 0.5),
                            ),
                        const SizedBox(height: 20),
                        Text(
                          'নতুন অ্যাকাউন্ট',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ).animate(delay: 100.ms).fadeIn().slideY(begin: -0.1),
                        const SizedBox(height: 6),
                        Text(
                          'নিবন্ধন করে শুরু করুন',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 14,
                          ),
                        ).animate(delay: 150.ms).fadeIn(),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Form card
                    IgnorePointer(
                      ignoring: isLoading,
                      child: Opacity(
                        opacity: isLoading ? 0.6 : 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _C.cardBg,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  children: [
                                    // API error banner
                                    if (auth.error != null) ...[
                                      _ErrorBanner(auth.error!),
                                      const SizedBox(height: 20),
                                    ],

                                    // Name
                                    _Field(
                                      label: 'পূর্ণ নাম',
                                      icon: Icons.person_outline_rounded,
                                      controller: _nameCtrl,
                                      focusNode: _nameFocus,
                                      hint: 'আপনার পূর্ণ নাম লিখুন',
                                      error: _nameErr,
                                      onChanged: _onNameChange,
                                      onSubmit: () =>
                                          _emailFocus.requestFocus(),
                                    )
                                        .animate(delay: 200.ms)
                                        .fadeIn()
                                        .slideY(begin: 0.05),

                                    const SizedBox(height: 18),

                                    // Email
                                    _Field(
                                      label: 'ইমেইল ঠিকানা',
                                      icon: Icons.alternate_email_rounded,
                                      controller: _emailCtrl,
                                      focusNode: _emailFocus,
                                      hint: 'example@email.com',
                                      keyboardType: TextInputType.emailAddress,
                                      error: _emailErr,
                                      onChanged: _onEmailChange,
                                      onSubmit: () =>
                                          FocusScope.of(context).unfocus(),
                                    )
                                        .animate(delay: 250.ms)
                                        .fadeIn()
                                        .slideY(begin: 0.05),

                                    const SizedBox(height: 18),

                                    // District picker
                                    _DistrictTapField(
                                      selectedDistrict: _selectedDistrict,
                                      error: _districtErr,
                                      onTap: _openDistrictPicker,
                                      onClear: () => _onDistrictSelected(null),
                                    )
                                        .animate(delay: 280.ms)
                                        .fadeIn()
                                        .slideY(begin: 0.05),

                                    const SizedBox(height: 18),

                                    // Password
                                    _PasswordField(
                                      label: 'পাসওয়ার্ড',
                                      controller: _passCtrl,
                                      focusNode: _passFocus,
                                      hint: 'কমপক্ষে ৬ অক্ষর',
                                      error: _passErr,
                                      onChanged: _onPassChange,
                                      onSubmit: () =>
                                          _cfPassFocus.requestFocus(),
                                    )
                                        .animate(delay: 310.ms)
                                        .fadeIn()
                                        .slideY(begin: 0.05),

                                    // Strength bar
                                    if (_passCtrl.text.isNotEmpty &&
                                        _passErr == null) ...[
                                      const SizedBox(height: 12),
                                      _PasswordStrengthBar(
                                          password: _passCtrl.text),
                                    ],

                                    const SizedBox(height: 18),

                                    // Confirm password
                                    _PasswordField(
                                      label: 'পাসওয়ার্ড নিশ্চিত করুন',
                                      controller: _cfPassCtrl,
                                      focusNode: _cfPassFocus,
                                      hint: 'পাসওয়ার্ড আবার লিখুন',
                                      error: _cfPassErr,
                                      onChanged: _onCfPassChange,
                                      onSubmit: _register,
                                      textInputAction: TextInputAction.done,
                                    )
                                        .animate(delay: 350.ms)
                                        .fadeIn()
                                        .slideY(begin: 0.05),
                                  ],
                                ),
                              ),

                              // Register button
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(24, 0, 24, 24),
                                child: _PrimaryButton(
                                  label: isLoading
                                      ? 'নিবন্ধন হচ্ছে...'
                                      : 'নিবন্ধন করুন',
                                  icon: isLoading
                                      ? null
                                      : Icons.check_circle_rounded,
                                  onTap: isLoading ? null : _register,
                                  isLoading: isLoading,
                                )
                                    .animate(delay: 400.ms)
                                    .fadeIn()
                                    .slideY(begin: 0.05),
                              ),
                            ],
                          ),
                        ).animate(delay: 180.ms).fadeIn().slideY(begin: 0.1),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Login link
                    GestureDetector(
                      onTap:
                          isLoading ? null : () => context.go(AppRoutes.login),
                      child: Opacity(
                        opacity: isLoading ? 0.4 : 1.0,
                        child: RichText(
                          text: const TextSpan(
                            text: 'ইতিমধ্যে অ্যাকাউন্ট আছে?  ',
                            style: TextStyle(
                                color: _C.textSecondary, fontSize: 14),
                            children: [
                              TextSpan(
                                text: 'লগইন করুন',
                                style: TextStyle(
                                  color: _C.darkGreen,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate(delay: 450.ms).fadeIn(),

                    const SizedBox(height: 32),
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

// ─────────────────────────────────────────────────────────────────────────────
// DISTRICT TAP FIELD  — tap to open picker sheet
// ─────────────────────────────────────────────────────────────────────────────

class _DistrictTapField extends StatelessWidget {
  final String? selectedDistrict;
  final String? error;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _DistrictTapField({
    required this.selectedDistrict,
    required this.error,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasErr = error != null && error!.isNotEmpty;
    final hasValue = selectedDistrict != null && selectedDistrict!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'জেলা',
          style: TextStyle(
            color: hasErr ? _C.red : _C.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              color: hasErr
                  ? _C.red.withOpacity(0.04)
                  : hasValue
                      ? _C.cardBg
                      : _C.surfaceAlt,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasErr
                    ? _C.red.withOpacity(0.6)
                    : hasValue
                        ? _C.darkGreen
                        : _C.border,
                width: hasValue ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(
                  Icons.location_city_rounded,
                  size: 20,
                  color: hasErr
                      ? _C.red
                      : hasValue
                          ? _C.darkGreen
                          : _C.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hasValue ? selectedDistrict! : 'জেলা নির্বাচন করুন',
                    style: TextStyle(
                      color: hasValue ? _C.textPrimary : _C.textHint,
                      fontSize: hasValue ? 15 : 14,
                      fontWeight:
                          hasValue ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
                if (hasValue)
                  GestureDetector(
                    onTap: onClear,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.close_rounded,
                          size: 18, color: _C.textSecondary),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        size: 22, color: _C.textSecondary),
                  ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: hasErr
              ? Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.error_rounded, size: 13, color: _C.red),
                      const SizedBox(width: 6),
                      Text(
                        error!,
                        style: const TextStyle(
                          color: _C.red,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DISTRICT PICKER BOTTOM SHEET  — searchable list
// ─────────────────────────────────────────────────────────────────────────────

class _DistrictPickerSheet extends StatefulWidget {
  final String? selectedDistrict;
  final List<String> districts;

  const _DistrictPickerSheet({
    required this.selectedDistrict,
    required this.districts,
  });

  @override
  State<_DistrictPickerSheet> createState() => _DistrictPickerSheetState();
}

class _DistrictPickerSheetState extends State<_DistrictPickerSheet> {
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();
  List<String> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = List.from(widget.districts);
    _searchCtrl.addListener(_onSearch);
    // auto-focus search after sheet fully opens
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchFocus.requestFocus());
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearch);
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _searchCtrl.text.trim();
    setState(() {
      _filtered = q.isEmpty
          ? List.from(widget.districts)
          : widget.districts.where((d) => d.contains(q)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: _C.borderMid,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 16),

          // Title row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: _C.greenLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.location_city_rounded,
                      color: _C.darkGreen, size: 18),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'জেলা নির্বাচন করুন',
                    style: TextStyle(
                      color: _C.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _C.surfaceAlt,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _C.border),
                    ),
                    child: const Icon(Icons.close_rounded,
                        size: 16, color: _C.textSecondary),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Search box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchCtrl,
              focusNode: _searchFocus,
              style: const TextStyle(
                  color: _C.textPrimary,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: 'জেলার নাম লিখুন...',
                hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
                prefixIcon: const Icon(Icons.search_rounded,
                    size: 20, color: _C.textSecondary),
                filled: true,
                fillColor: _C.surfaceAlt,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _C.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _C.border, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _C.darkGreen, width: 1.5),
                ),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchCtrl.clear();
                          _searchFocus.requestFocus();
                        },
                        child: const Icon(Icons.close_rounded,
                            size: 18, color: _C.textSecondary),
                      )
                    : null,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Divider
          const Divider(height: 1, thickness: 0.5, color: _C.border),

          // District list
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(context).size.height * 0.45 - bottomInset,
            ),
            child: _filtered.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 40, color: _C.textHint),
                        const SizedBox(height: 10),
                        const Text(
                          'কোনো জেলা পাওয়া যায়নি',
                          style:
                              TextStyle(color: _C.textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(top: 4, bottom: 16 + bottomInset),
                    itemCount: _filtered.length,
                    itemBuilder: (ctx, i) {
                      final district = _filtered[i];
                      final isSelected = district == widget.selectedDistrict;

                      return InkWell(
                        onTap: () => Navigator.of(context).pop(district),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 13),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? _C.greenLight : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              if (isSelected)
                                const Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(Icons.check_circle_rounded,
                                      size: 18, color: _C.darkGreen),
                                )
                              else
                                const Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(
                                      Icons.radio_button_unchecked_rounded,
                                      size: 18,
                                      color: _C.borderMid),
                                ),
                              Expanded(
                                child: Text(
                                  district,
                                  style: TextStyle(
                                    color: isSelected
                                        ? _C.darkGreen
                                        : _C.textPrimary,
                                    fontSize: 14.5,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DIALOG ROW  — compact single-line info row inside confirmation dialog
// ─────────────────────────────────────────────────────────────────────────────

class _DialogRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bg;
  final String text;

  const _DialogRow({
    required this.icon,
    required this.iconColor,
    required this.bg,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: _C.textPrimary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TEXT FIELD
// ─────────────────────────────────────────────────────────────────────────────

class _Field extends StatefulWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final String? error;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(String)? onChanged;
  final VoidCallback onSubmit;

  const _Field({
    required this.label,
    required this.icon,
    required this.controller,
    required this.focusNode,
    required this.hint,
    this.error,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    required this.onSubmit,
  });

  @override
  State<_Field> createState() => _FieldState();
}

class _FieldState extends State<_Field> {
  bool _focused = false;
  late final VoidCallback _focusListener;

  @override
  void initState() {
    super.initState();
    _focusListener = () {
      if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
    };
    widget.focusNode.addListener(_focusListener);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasErr = widget.error != null && widget.error!.isNotEmpty;
    final iconColor = hasErr
        ? _C.red
        : _focused
            ? _C.darkGreen
            : _C.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: hasErr
                ? _C.red
                : _focused
                    ? _C.darkGreen
                    : _C.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: _focused && !hasErr
                ? [
                    BoxShadow(
                      color: _C.darkGreen.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onChanged: widget.onChanged,
            onEditingComplete: widget.onSubmit,
            onSubmitted: (_) => widget.onSubmit(),
            style: const TextStyle(
              color: _C.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(widget.icon, size: 20, color: iconColor),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 54),
              filled: true,
              fillColor: hasErr
                  ? _C.red.withOpacity(0.04)
                  : _focused
                      ? _C.cardBg
                      : _C.surfaceAlt,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: _C.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: hasErr ? _C.red.withOpacity(0.5) : _C.border,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: hasErr ? _C.red : _C.darkGreen,
                  width: 1.5,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: hasErr
              ? Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.error_rounded, size: 13, color: _C.red),
                      const SizedBox(width: 6),
                      Text(
                        widget.error!,
                        style: const TextStyle(
                          color: _C.red,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
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
  final TextInputAction textInputAction;
  final void Function(String) onChanged;
  final VoidCallback onSubmit;

  const _PasswordField({
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.hint,
    this.error,
    this.textInputAction = TextInputAction.next,
    required this.onChanged,
    required this.onSubmit,
  });

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _focused = false;
  bool _obscure = true;
  late final VoidCallback _focusListener;

  @override
  void initState() {
    super.initState();
    _focusListener = () {
      if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
    };
    widget.focusNode.addListener(_focusListener);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasErr = widget.error != null && widget.error!.isNotEmpty;
    final iconColor = hasErr
        ? _C.red
        : _focused
            ? _C.darkGreen
            : _C.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: hasErr
                ? _C.red
                : _focused
                    ? _C.darkGreen
                    : _C.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: _focused && !hasErr
                ? [
                    BoxShadow(
                      color: _C.darkGreen.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            obscureText: _obscure,
            textInputAction: widget.textInputAction,
            onChanged: widget.onChanged,
            onEditingComplete: widget.onSubmit,
            onSubmitted: (_) => widget.onSubmit(),
            style: const TextStyle(
              color: _C.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.lock_outline_rounded,
                    size: 20, color: iconColor),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 54),
              suffixIcon: GestureDetector(
                onTap: () => setState(() => _obscure = !_obscure),
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                    color: _focused ? _C.darkGreen : _C.textSecondary,
                  ),
                ),
              ),
              suffixIconConstraints: const BoxConstraints(minWidth: 50),
              filled: true,
              fillColor: hasErr
                  ? _C.red.withOpacity(0.04)
                  : _focused
                      ? _C.cardBg
                      : _C.surfaceAlt,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: _C.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: hasErr ? _C.red.withOpacity(0.5) : _C.border,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: hasErr ? _C.red : _C.darkGreen,
                  width: 1.5,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: hasErr
              ? Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.error_rounded, size: 13, color: _C.red),
                      const SizedBox(width: 6),
                      Text(
                        widget.error!,
                        style: const TextStyle(
                          color: _C.red,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PASSWORD STRENGTH BAR
// ─────────────────────────────────────────────────────────────────────────────

class _PasswordStrengthBar extends StatelessWidget {
  final String password;
  const _PasswordStrengthBar({required this.password});

  int get _score {
    int s = 0;
    if (password.length >= 6) s++;
    if (password.length >= 10) s++;
    if (password.contains(RegExp(r'[A-Z]'))) s++;
    if (password.contains(RegExp(r'[0-9]'))) s++;
    if (password.contains(RegExp(r'[^A-Za-z0-9]'))) s++;
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final s = _score;
    final color = s <= 1
        ? _C.red
        : s <= 3
            ? _C.amber
            : _C.green;
    final label = s <= 1
        ? 'দুর্বল'
        : s <= 3
            ? 'মাঝারি'
            : 'শক্তিশালী';

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: s / 5,
              minHeight: 4,
              backgroundColor: _C.border,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ERROR BANNER
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _C.redLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.red.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: _C.red, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: _C.red,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRIMARY BUTTON
// ─────────────────────────────────────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isLoading;

  const _PrimaryButton({
    required this.label,
    this.icon,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null && !isLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        color: enabled ? _C.darkGreen : _C.borderMid,
        borderRadius: BorderRadius.circular(16),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: _C.darkGreen.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                      ],
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
