// // import 'package:amal_tracker/features/auth/providers/provider_reset.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:go_router/go_router.dart';
// // import '../providers/auth_provider.dart';
// // import '../../../core/router/app_router.dart';

// // // ─────────────────────────────────────────────────────────────────────────────
// // // DESIGN TOKENS
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _C {
// //   static const pageBg = Color(0xFFF4F6F1);
// //   static const cardBg = Color(0xFFFFFFFF);
// //   static const darkGreen = Color(0xFF0E3D22);
// //   static const midGreen = Color(0xFF1B7045);
// //   static const gold = Color(0xFFD4A843);
// //   static const green = Color(0xFF16A34A);
// //   static const greenLight = Color(0xFFE8F5EE);
// //   static const amber = Color(0xFFF59E0B);
// //   static const amberLight = Color(0xFFFFF3E0);
// //   static const red = Color(0xFFEF4444);
// //   static const redLight = Color(0xFFFEF2F2);
// //   static const textPrimary = Color(0xFF0A1A0F);
// //   static const textSecondary = Color(0xFF6B7C6E);
// //   static const textHint = Color(0xFFABBAAE);
// //   static const border = Color(0xFFE4EAE4);
// //   static const borderMid = Color(0xFFD0DAD2);
// //   static const surfaceAlt = Color(0xFFF8FAF8);
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // DISTRICTS
// // // ─────────────────────────────────────────────────────────────────────────────

// // const List<String> _bangladeshDistricts = [
// //   'ঢাকা',
// //   'চট্টগ্রাম',
// //   'রাজশাহী',
// //   'খুলনা',
// //   'বরিশাল',
// //   'সিলেট',
// //   'রংপুর',
// //   'ময়মনসিংহ',
// //   'ফরিদপুর',
// //   'গাজীপুর',
// //   'নারায়ণগঞ্জ',
// //   'কুমিল্লা',
// //   'ব্রাহ্মণবাড়িয়া',
// //   'চাঁদপুর',
// //   'লক্ষ্মীপুর',
// //   'নোয়াখালী',
// //   'ফেনী',
// //   'কক্সবাজার',
// //   'বান্দরবান',
// //   'রাঙ্গামাটি',
// //   'খাগড়াছড়ি',
// //   'মৌলভীবাজার',
// //   'হবিগঞ্জ',
// //   'সুনামগঞ্জ',
// //   'নেত্রকোণা',
// //   'কিশোরগঞ্জ',
// //   'মানিকগঞ্জ',
// //   'মুন্সীগঞ্জ',
// //   'টাঙ্গাইল',
// //   'নরসিংদী',
// //   'শরীয়তপুর',
// //   'মাদারীপুর',
// //   'গোপালগঞ্জ',
// //   'ঝালকাঠি',
// //   'পিরোজপুর',
// //   'বরগুনা',
// //   'পটুয়াখালী',
// //   'ভোলা',
// //   'নাটোর',
// //   'পাবনা',
// //   'সিরাজগঞ্জ',
// //   'বগুড়া',
// //   'জয়পুরহাট',
// //   'চাঁপাইনবাবগঞ্জ',
// //   'নওগাঁ',
// //   'দিনাজপুর',
// //   'লালমনিরহাট',
// //   'নীলফামারী',
// //   'পঞ্চগড়',
// //   'ঠাকুরগাঁও',
// //   'কুড়িগ্রাম',
// //   'গাইবান্ধা',
// //   'যশোর',
// //   'ঝিনাইদহ',
// //   'মাগুরা',
// //   'নড়াইল',
// //   'বাগেরহাট',
// //   'সাতক্ষীরা',
// //   'কুষ্টিয়া',
// //   'মেহেরপুর',
// //   'চুয়াডাঙ্গা',
// // ];

// // // ─────────────────────────────────────────────────────────────────────────────
// // // GENDER OPTIONS
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _GenderOption {
// //   final String value;
// //   final String label;
// //   final IconData icon;
// //   const _GenderOption(this.value, this.label, this.icon);
// // }

// // const _genderOptions = [
// //   _GenderOption('male', 'পুরুষ', Icons.man_rounded),
// //   _GenderOption('female', 'মহিলা', Icons.woman_rounded),
// //   _GenderOption('other', 'অন্যান্য', Icons.people_alt_rounded),
// // ];

// // // ─────────────────────────────────────────────────────────────────────────────
// // // REGISTER SCREEN
// // // ─────────────────────────────────────────────────────────────────────────────

// // class RegisterScreen extends ConsumerStatefulWidget {
// //   const RegisterScreen({super.key});

// //   @override
// //   ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
// // }

// // class _RegisterScreenState extends ConsumerState<RegisterScreen> {
// //   final _nameCtrl = TextEditingController();
// //   final _emailCtrl = TextEditingController();
// //   final _passCtrl = TextEditingController();
// //   final _cfPassCtrl = TextEditingController();

// //   final _nameFocus = FocusNode();
// //   final _emailFocus = FocusNode();
// //   final _passFocus = FocusNode();
// //   final _cfPassFocus = FocusNode();

// //   bool _submitted = false;
// //   bool _isRegistering = false;
// //   String? _selectedDistrict;
// //   String? _selectedGender;

// //   String? _nameErr, _emailErr, _passErr, _cfPassErr, _districtErr, _genderErr;

// //   @override
// //   void dispose() {
// //     _nameCtrl.dispose();
// //     _emailCtrl.dispose();
// //     _passCtrl.dispose();
// //     _cfPassCtrl.dispose();
// //     _nameFocus.dispose();
// //     _emailFocus.dispose();
// //     _passFocus.dispose();
// //     _cfPassFocus.dispose();
// //     super.dispose();
// //   }

// //   // ── live validators ────────────────────────────────────────────────────────

// //   void _onNameChange(String v) {
// //     if (!_submitted) return;
// //     setState(() =>
// //         _nameErr = v.trim().length < 2 ? 'নাম কমপক্ষে ২ অক্ষর হতে হবে' : null);
// //   }

// //   void _onEmailChange(String v) {
// //     if (!_submitted) return;
// //     setState(() {
// //       if (v.trim().isEmpty) {
// //         _emailErr = 'ইমেইল দিন';
// //       } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) {
// //         _emailErr = 'সঠিক ইমেইল ঠিকানা দিন';
// //       } else {
// //         _emailErr = null;
// //       }
// //     });
// //   }

// //   void _onPassChange(String v) {
// //     if (!_submitted) return;
// //     setState(() {
// //       if (v.isEmpty) {
// //         _passErr = 'পাসওয়ার্ড দিন';
// //       } else if (v.length < 6) {
// //         _passErr = 'কমপক্ষে ৬ অক্ষর হতে হবে';
// //       } else {
// //         _passErr = null;
// //       }
// //       if (_cfPassCtrl.text.isNotEmpty) {
// //         _cfPassErr = _cfPassCtrl.text != v ? 'পাসওয়ার্ড মিলছে না' : null;
// //       }
// //     });
// //   }

// //   void _onCfPassChange(String v) {
// //     if (!_submitted) return;
// //     setState(
// //         () => _cfPassErr = v != _passCtrl.text ? 'পাসওয়ার্ড মিলছে না' : null);
// //   }

// //   void _onDistrictSelected(String? d) {
// //     setState(() {
// //       _selectedDistrict = d;
// //       if (_submitted)
// //         _districtErr = (d == null || d.isEmpty) ? 'জেলা নির্বাচন করুন' : null;
// //     });
// //   }

// //   void _onGenderSelected(String? g) {
// //     setState(() {
// //       _selectedGender = g;
// //       if (_submitted)
// //         _genderErr = (g == null || g.isEmpty) ? 'লিঙ্গ নির্বাচন করুন' : null;
// //     });
// //   }

// //   // ── district picker ────────────────────────────────────────────────────────

// //   Future<void> _openDistrictPicker() async {
// //     final result = await showModalBottomSheet<String>(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: Colors.transparent,
// //       builder: (ctx) => _DistrictPickerSheet(
// //         selectedDistrict: _selectedDistrict,
// //         districts: _bangladeshDistricts,
// //       ),
// //     );
// //     if (result != null) _onDistrictSelected(result);
// //   }

// //   // ── validate ───────────────────────────────────────────────────────────────

// //   bool _validate() {
// //     setState(() {
// //       _submitted = true;
// //       final name = _nameCtrl.text.trim();
// //       final email = _emailCtrl.text.trim();
// //       final pass = _passCtrl.text;
// //       final cf = _cfPassCtrl.text;

// //       _nameErr = name.length < 2 ? 'নাম কমপক্ষে ২ অক্ষর হতে হবে' : null;
// //       _emailErr = email.isEmpty
// //           ? 'ইমেইল দিন'
// //           : !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
// //               ? 'সঠিক ইমেইল ঠিকানা দিন'
// //               : null;
// //       _passErr = pass.isEmpty
// //           ? 'পাসওয়ার্ড দিন'
// //           : pass.length < 6
// //               ? 'কমপক্ষে ৬ অক্ষর হতে হবে'
// //               : null;
// //       _cfPassErr = cf != pass ? 'পাসওয়ার্ড মিলছে না' : null;
// //       _districtErr = (_selectedDistrict == null || _selectedDistrict!.isEmpty)
// //           ? 'জেলা নির্বাচন করুন'
// //           : null;
// //       _genderErr = (_selectedGender == null || _selectedGender!.isEmpty)
// //           ? 'লিঙ্গ নির্বাচন করুন'
// //           : null;
// //     });
// //     return _nameErr == null &&
// //         _emailErr == null &&
// //         _passErr == null &&
// //         _cfPassErr == null &&
// //         _districtErr == null &&
// //         _genderErr == null;
// //   }

// //   // ── confirmation dialog ────────────────────────────────────────────────────

// //   Future<bool> _showConfirmationDialog() async {
// //     return await showDialog<bool>(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (ctx) => Dialog(
// //         elevation: 0,
// //         backgroundColor: Colors.transparent,
// //         insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
// //         child: Container(
// //           decoration: BoxDecoration(
// //             color: _C.cardBg,
// //             borderRadius: BorderRadius.circular(20),
// //           ),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Padding(
// //                 padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
// //                 child: Row(
// //                   children: [
// //                     Container(
// //                       width: 34,
// //                       height: 34,
// //                       decoration: BoxDecoration(
// //                           color: _C.amberLight,
// //                           borderRadius: BorderRadius.circular(9)),
// //                       child: const Icon(Icons.info_outline_rounded,
// //                           color: _C.amber, size: 18),
// //                     ),
// //                     const SizedBox(width: 10),
// //                     const Expanded(
// //                       child: Text('নিবন্ধনের আগে জানুন',
// //                           style: TextStyle(
// //                               fontSize: 15,
// //                               fontWeight: FontWeight.w800,
// //                               color: _C.textPrimary)),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const Divider(height: 1, color: _C.border),
// //               Padding(
// //                 padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
// //                 child: Column(
// //                   children: const [
// //                     _DialogRow(
// //                         icon: Icons.lock_reset_rounded,
// //                         iconColor: _C.amber,
// //                         bg: _C.amberLight,
// //                         text: 'পাসওয়ার্ড রিসেট এখনো নেই — লিখে রাখুন'),
// //                     SizedBox(height: 8),
// //                     _DialogRow(
// //                         icon: Icons.shield_outlined,
// //                         iconColor: _C.green,
// //                         bg: _C.greenLight,
// //                         text: 'পাসওয়ার্ড শুধু আপনার — কাউকে জানাবেন না'),
// //                     SizedBox(height: 8),
// //                     _DialogRow(
// //                         icon: Icons.alternate_email_rounded,
// //                         iconColor: _C.red,
// //                         bg: _C.redLight,
// //                         text: 'সঠিক ইমেইল দিন — লগইনে দরকার হবে'),
// //                   ],
// //                 ),
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
// //                 child: Row(
// //                   children: [
// //                     Expanded(
// //                       child: OutlinedButton(
// //                         onPressed: () => Navigator.of(ctx).pop(false),
// //                         style: OutlinedButton.styleFrom(
// //                           foregroundColor: _C.textSecondary,
// //                           side: const BorderSide(color: _C.border),
// //                           padding: const EdgeInsets.symmetric(vertical: 12),
// //                           shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(12)),
// //                         ),
// //                         child: const Text('বাতিল',
// //                             style: TextStyle(
// //                                 fontSize: 13, fontWeight: FontWeight.w600)),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10),
// //                     Expanded(
// //                       child: ElevatedButton(
// //                         onPressed: () => Navigator.of(ctx).pop(true),
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: _C.darkGreen,
// //                           foregroundColor: Colors.white,
// //                           elevation: 0,
// //                           padding: const EdgeInsets.symmetric(vertical: 12),
// //                           shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(12)),
// //                         ),
// //                         child: const Text('নিবন্ধন করুন',
// //                             style: TextStyle(
// //                                 fontSize: 13, fontWeight: FontWeight.w700)),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     ).then((v) => v ?? false);
// //   }

// //   // ── register ───────────────────────────────────────────────────────────────

// //   Future<void> _register() async {
// //     if (_isRegistering) return;
// //     if (!_validate()) return;

// //     final confirmed = await _showConfirmationDialog();
// //     if (!confirmed) return;

// //     setState(() => _isRegistering = true);
// //     ref.read(authProvider.notifier).clearError();

// //     final ok = await ref.read(authProvider.notifier).register(
// //           name: _nameCtrl.text.trim(),
// //           email: _emailCtrl.text.trim(),
// //           password: _passCtrl.text,
// //           district: _selectedDistrict!,
// //           department: null,
// //           designation: null,
// //           phone: null,
// //           photoUrl: null,
// //           gender: _selectedGender,
// //         );

// //     if (ok) invalidateUserProviders(ref);
// //     setState(() => _isRegistering = false);

// //     if (ok && mounted) {
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //         content: const Text('নিবন্ধন সফল হয়েছে!'),
// //         backgroundColor: _C.green,
// //         behavior: SnackBarBehavior.floating,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       ));
// //       context.go(AppRoutes.home);
// //     }
// //   }

// //   // ── build ──────────────────────────────────────────────────────────────────

// //   @override
// //   Widget build(BuildContext context) {
// //     final authError = ref.watch(authProvider.select((state) => state.error));

// //     // লোকাল রানিং স্টেট চেক
// //     final isLoading = _isRegistering;
// //     final auth = ref.watch(authProvider);
// //     // final isLoading = auth.isLoading || _isRegistering;
// //     final size = MediaQuery.of(context).size;

// //     return AnnotatedRegion<SystemUiOverlayStyle>(
// //       value: SystemUiOverlayStyle.light,
// //       child: Scaffold(
// //         backgroundColor: _C.pageBg,
// //         body: Stack(
// //           children: [
// //             // ── [1] Header gradient — painted first (sits behind scroll content)
// //             Positioned(
// //               top: 0,
// //               left: 0,
// //               right: 0,
// //               child: Container(
// //                 height: size.height * 0.35,
// //                 decoration: const BoxDecoration(
// //                   gradient: LinearGradient(
// //                     begin: Alignment.topLeft,
// //                     end: Alignment.bottomRight,
// //                     colors: [_C.darkGreen, _C.midGreen],
// //                   ),
// //                   borderRadius: BorderRadius.only(
// //                     bottomLeft: Radius.circular(32),
// //                     bottomRight: Radius.circular(32),
// //                   ),
// //                 ),
// //                 child: Stack(children: [
// //                   Positioned(
// //                     top: -40,
// //                     right: -40,
// //                     child: Container(
// //                       width: 150,
// //                       height: 150,
// //                       decoration: BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         color: Colors.white.withOpacity(0.05),
// //                       ),
// //                     ),
// //                   ),
// //                   Positioned(
// //                     bottom: -30,
// //                     left: -30,
// //                     child: Container(
// //                       width: 100,
// //                       height: 100,
// //                       decoration: BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         color: _C.gold.withOpacity(0.08),
// //                       ),
// //                     ),
// //                   ),
// //                 ]),
// //               ),
// //             ),

// //             // ── [2] Scroll content — painted second (sits on top of header)
// //             //
// //             //  THE FIX: we removed the outer `Opacity` widget entirely.
// //             //  `Opacity` forces a `saveLayer` GPU compositing pass which
// //             //  caused the header's rounded-bottom clipping edge to bleed
// //             //  through as a visible shadow/overlay during the loading state.
// //             //  `IgnorePointer` alone is enough to block input — the button
// //             //  already shows the spinner and turns grey to signal loading.
// //             //
// //             SafeArea(
// //               child: SingleChildScrollView(
// //                 padding: const EdgeInsets.symmetric(horizontal: 24),
// //                 child: Column(
// //                   children: [
// //                     const SizedBox(height: 40),

// //                     // ── Hero ────────────────────────────────────────────────
// //                     Column(
// //                       children: [
// //                         Container(
// //                           width: 70,
// //                           height: 70,
// //                           decoration: BoxDecoration(
// //                             color: Colors.white.withOpacity(0.15),
// //                             borderRadius: BorderRadius.circular(20),
// //                             border: Border.all(
// //                                 color: Colors.white.withOpacity(0.25)),
// //                           ),
// //                           child: const Icon(Icons.person_add_rounded,
// //                               color: Colors.white, size: 35),
// //                         ).animate().scale(
// //                             duration: 500.ms,
// //                             curve: Curves.elasticOut,
// //                             begin: const Offset(0.5, 0.5)),
// //                         const SizedBox(height: 20),
// //                         const Text(
// //                           'নতুন অ্যাকাউন্ট',
// //                           style: TextStyle(
// //                               color: Colors.white,
// //                               fontSize: 28,
// //                               fontWeight: FontWeight.w800,
// //                               letterSpacing: -0.5),
// //                         ).animate(delay: 100.ms).fadeIn().slideY(begin: -0.1),
// //                         const SizedBox(height: 6),
// //                         Text(
// //                           'নিবন্ধন করে শুরু করুন',
// //                           style: TextStyle(
// //                               color: Colors.white.withOpacity(0.75),
// //                               fontSize: 14),
// //                         ).animate(delay: 150.ms).fadeIn(),
// //                       ],
// //                     ),

// //                     const SizedBox(height: 32),

// //                     // ── Form card ───────────────────────────────────────────
// //                     IgnorePointer(
// //                       ignoring: isLoading,
// //                       child: Container(
// //                         decoration: BoxDecoration(
// //                           color: _C.cardBg,
// //                           borderRadius: BorderRadius.circular(24),
// //                           boxShadow: [
// //                             BoxShadow(
// //                               color: Colors.black.withOpacity(0.05),
// //                               blurRadius: 20,
// //                               offset: const Offset(0, 8),
// //                             ),
// //                           ],
// //                         ),
// //                         child: Column(
// //                           children: [
// //                             Padding(
// //                               padding: const EdgeInsets.all(24),
// //                               child: Column(
// //                                 children: [
// //                                   // API error banner
// //                                   if (auth.error != null) ...[
// //                                     _ErrorBanner(authError!),
// //                                     const SizedBox(height: 20),
// //                                   ],

// //                                   // Name
// //                                   _Field(
// //                                     label: 'পূর্ণ নাম',
// //                                     icon: Icons.person_outline_rounded,
// //                                     controller: _nameCtrl,
// //                                     focusNode: _nameFocus,
// //                                     hint: 'আপনার পূর্ণ নাম লিখুন',
// //                                     error: _nameErr,
// //                                     onChanged: _onNameChange,
// //                                     onSubmit: () => _emailFocus.requestFocus(),
// //                                   )
// //                                       .animate(delay: 200.ms)
// //                                       .fadeIn()
// //                                       .slideY(begin: 0.05),

// //                                   const SizedBox(height: 18),

// //                                   // Email
// //                                   _Field(
// //                                     label: 'ইমেইল ঠিকানা',
// //                                     icon: Icons.alternate_email_rounded,
// //                                     controller: _emailCtrl,
// //                                     focusNode: _emailFocus,
// //                                     hint: 'example@email.com',
// //                                     keyboardType: TextInputType.emailAddress,
// //                                     error: _emailErr,
// //                                     onChanged: _onEmailChange,
// //                                     onSubmit: () =>
// //                                         FocusScope.of(context).unfocus(),
// //                                   )
// //                                       .animate(delay: 250.ms)
// //                                       .fadeIn()
// //                                       .slideY(begin: 0.05),

// //                                   const SizedBox(height: 18),

// //                                   // District
// //                                   _DistrictTapField(
// //                                     selectedDistrict: _selectedDistrict,
// //                                     error: _districtErr,
// //                                     onTap: _openDistrictPicker,
// //                                     onClear: () => _onDistrictSelected(null),
// //                                   )
// //                                       .animate(delay: 280.ms)
// //                                       .fadeIn()
// //                                       .slideY(begin: 0.05),

// //                                   const SizedBox(height: 18),

// //                                   // Gender  ← NEW
// //                                   _GenderSelector(
// //                                     selected: _selectedGender,
// //                                     error: _genderErr,
// //                                     onSelected: _onGenderSelected,
// //                                   )
// //                                       .animate(delay: 300.ms)
// //                                       .fadeIn()
// //                                       .slideY(begin: 0.05),

// //                                   const SizedBox(height: 18),

// //                                   // Password
// //                                   _PasswordField(
// //                                     label: 'পাসওয়ার্ড',
// //                                     controller: _passCtrl,
// //                                     focusNode: _passFocus,
// //                                     hint: 'কমপক্ষে ৬ অক্ষর',
// //                                     error: _passErr,
// //                                     onChanged: _onPassChange,
// //                                     onSubmit: () => _cfPassFocus.requestFocus(),
// //                                     showStrengthBar: true,
// //                                   )
// //                                       .animate(delay: 310.ms)
// //                                       .fadeIn()
// //                                       .slideY(begin: 0.05),

// //                                   // if (_passCtrl.text.isNotEmpty &&
// //                                   //     _passErr == null) ...[
// //                                   //   const SizedBox(height: 12),
// //                                   //   _PasswordStrengthBar(
// //                                   //       password: _passCtrl.text),
// //                                   // ],

// //                                   const SizedBox(height: 18),

// //                                   // Confirm password
// //                                   _PasswordField(
// //                                     label: 'পাসওয়ার্ড নিশ্চিত করুন',
// //                                     controller: _cfPassCtrl,
// //                                     focusNode: _cfPassFocus,
// //                                     hint: 'পাসওয়ার্ড আবার লিখুন',
// //                                     error: _cfPassErr,
// //                                     onChanged: _onCfPassChange,
// //                                     onSubmit: _register,
// //                                     textInputAction: TextInputAction.done,
// //                                   )
// //                                       .animate(delay: 350.ms)
// //                                       .fadeIn()
// //                                       .slideY(begin: 0.05),
// //                                 ],
// //                               ),
// //                             ),

// //                             // Register button
// //                             Padding(
// //                               padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
// //                               child: _PrimaryButton(
// //                                 label: isLoading
// //                                     ? 'নিবন্ধন হচ্ছে...'
// //                                     : 'নিবন্ধন করুন',
// //                                 icon: isLoading
// //                                     ? null
// //                                     : Icons.check_circle_rounded,
// //                                 onTap: isLoading ? null : _register,
// //                                 isLoading: isLoading,
// //                               )
// //                                   .animate(delay: 400.ms)
// //                                   .fadeIn()
// //                                   .slideY(begin: 0.05),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ).animate(delay: 180.ms).fadeIn().slideY(begin: 0.1),

// //                     const SizedBox(height: 24),

// //                     // Login link
// //                     GestureDetector(
// //                       onTap:
// //                           isLoading ? null : () => context.go(AppRoutes.login),
// //                       child: Opacity(
// //                         opacity: isLoading ? 0.4 : 1.0,
// //                         child: RichText(
// //                           text: const TextSpan(
// //                             text: 'ইতিমধ্যে অ্যাকাউন্ট আছে?  ',
// //                             style: TextStyle(
// //                                 color: _C.textSecondary, fontSize: 14),
// //                             children: [
// //                               TextSpan(
// //                                 text: 'লগইন করুন',
// //                                 style: TextStyle(
// //                                     color: _C.darkGreen,
// //                                     fontWeight: FontWeight.w700),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ).animate(delay: 450.ms).fadeIn(),

// //                     const SizedBox(height: 32),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // GENDER SELECTOR  — 3-chip segmented row
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _GenderSelector extends StatelessWidget {
// //   final String? selected;
// //   final String? error;
// //   final void Function(String?) onSelected;

// //   const _GenderSelector({
// //     required this.selected,
// //     required this.error,
// //     required this.onSelected,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final hasErr = error != null && error!.isNotEmpty;

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           'লিঙ্গ',
// //           style: TextStyle(
// //             color: hasErr ? _C.red : _C.textPrimary,
// //             fontWeight: FontWeight.w600,
// //             fontSize: 13,
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         Row(
// //           children: List.generate(_genderOptions.length, (i) {
// //             final opt = _genderOptions[i];
// //             final isSelected = selected == opt.value;

// //             return Expanded(
// //               child: Padding(
// //                 padding: EdgeInsets.only(
// //                     right: i < _genderOptions.length - 1 ? 8 : 0),
// //                 child: GestureDetector(
// //                   onTap: () => onSelected(isSelected ? null : opt.value),
// //                   child: AnimatedContainer(
// //                     duration: const Duration(milliseconds: 180),
// //                     curve: Curves.easeOutCubic,
// //                     height: 54,
// //                     decoration: BoxDecoration(
// //                       color: isSelected
// //                           ? _C.greenLight
// //                           : hasErr
// //                               ? _C.red.withOpacity(0.04)
// //                               : _C.surfaceAlt,
// //                       borderRadius: BorderRadius.circular(14),
// //                       border: Border.all(
// //                         color: isSelected
// //                             ? _C.darkGreen
// //                             : hasErr
// //                                 ? _C.red.withOpacity(0.5)
// //                                 : _C.border,
// //                         width: isSelected ? 1.5 : 1.0,
// //                       ),
// //                       boxShadow: isSelected
// //                           ? [
// //                               BoxShadow(
// //                                   color: _C.darkGreen.withOpacity(0.08),
// //                                   blurRadius: 8,
// //                                   offset: const Offset(0, 3))
// //                             ]
// //                           : [],
// //                     ),
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         Icon(
// //                           opt.icon,
// //                           size: 20,
// //                           color: isSelected
// //                               ? _C.darkGreen
// //                               : hasErr
// //                                   ? _C.red
// //                                   : _C.textSecondary,
// //                         ),
// //                         const SizedBox(height: 3),
// //                         Text(
// //                           opt.label,
// //                           style: TextStyle(
// //                             fontSize: 11.5,
// //                             fontWeight:
// //                                 isSelected ? FontWeight.w700 : FontWeight.w500,
// //                             color: isSelected
// //                                 ? _C.darkGreen
// //                                 : hasErr
// //                                     ? _C.red
// //                                     : _C.textSecondary,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             );
// //           }),
// //         ),
// //         AnimatedSize(
// //           duration: const Duration(milliseconds: 180),
// //           curve: Curves.easeOutCubic,
// //           child: hasErr
// //               ? Padding(
// //                   padding: const EdgeInsets.only(top: 6, left: 4),
// //                   child: Row(
// //                     children: [
// //                       const Icon(Icons.error_rounded, size: 13, color: _C.red),
// //                       const SizedBox(width: 6),
// //                       Text(error!,
// //                           style: const TextStyle(
// //                               color: _C.red,
// //                               fontSize: 11.5,
// //                               fontWeight: FontWeight.w500)),
// //                     ],
// //                   ),
// //                 )
// //               : const SizedBox.shrink(),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // DISTRICT TAP FIELD
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _DistrictTapField extends StatelessWidget {
// //   final String? selectedDistrict;
// //   final String? error;
// //   final VoidCallback onTap;
// //   final VoidCallback onClear;

// //   const _DistrictTapField({
// //     required this.selectedDistrict,
// //     required this.error,
// //     required this.onTap,
// //     required this.onClear,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final hasErr = error != null && error!.isNotEmpty;
// //     final hasValue = selectedDistrict != null && selectedDistrict!.isNotEmpty;

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text('জেলা',
// //             style: TextStyle(
// //                 color: hasErr ? _C.red : _C.textPrimary,
// //                 fontWeight: FontWeight.w600,
// //                 fontSize: 13)),
// //         const SizedBox(height: 8),
// //         GestureDetector(
// //           onTap: onTap,
// //           child: Container(
// //             height: 54,
// //             decoration: BoxDecoration(
// //               color: hasErr
// //                   ? _C.red.withOpacity(0.04)
// //                   : hasValue
// //                       ? _C.cardBg
// //                       : _C.surfaceAlt,
// //               borderRadius: BorderRadius.circular(14),
// //               border: Border.all(
// //                 color: hasErr
// //                     ? _C.red.withOpacity(0.6)
// //                     : hasValue
// //                         ? _C.darkGreen
// //                         : _C.border,
// //                 width: hasValue ? 1.5 : 1.0,
// //               ),
// //             ),
// //             child: Row(
// //               children: [
// //                 const SizedBox(width: 16),
// //                 Icon(Icons.location_city_rounded,
// //                     size: 20,
// //                     color: hasErr
// //                         ? _C.red
// //                         : hasValue
// //                             ? _C.darkGreen
// //                             : _C.textSecondary),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   child: Text(
// //                     hasValue ? selectedDistrict! : 'জেলা নির্বাচন করুন',
// //                     style: TextStyle(
// //                       color: hasValue ? _C.textPrimary : _C.textHint,
// //                       fontSize: hasValue ? 15 : 14,
// //                       fontWeight:
// //                           hasValue ? FontWeight.w500 : FontWeight.normal,
// //                     ),
// //                   ),
// //                 ),
// //                 if (hasValue)
// //                   GestureDetector(
// //                     onTap: onClear,
// //                     child: Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 12),
// //                       child: Icon(Icons.close_rounded,
// //                           size: 18, color: _C.textSecondary),
// //                     ),
// //                   )
// //                 else
// //                   const Padding(
// //                     padding: EdgeInsets.symmetric(horizontal: 12),
// //                     child: Icon(Icons.keyboard_arrow_down_rounded,
// //                         size: 22, color: _C.textSecondary),
// //                   ),
// //               ],
// //             ),
// //           ),
// //         ),
// //         AnimatedSize(
// //           duration: const Duration(milliseconds: 180),
// //           curve: Curves.easeOutCubic,
// //           child: hasErr
// //               ? Padding(
// //                   padding: const EdgeInsets.only(top: 6, left: 4),
// //                   child: Row(children: [
// //                     const Icon(Icons.error_rounded, size: 13, color: _C.red),
// //                     const SizedBox(width: 6),
// //                     Text(error!,
// //                         style: const TextStyle(
// //                             color: _C.red,
// //                             fontSize: 11.5,
// //                             fontWeight: FontWeight.w500)),
// //                   ]),
// //                 )
// //               : const SizedBox.shrink(),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // DISTRICT PICKER SHEET
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _DistrictPickerSheet extends StatefulWidget {
// //   final String? selectedDistrict;
// //   final List<String> districts;
// //   const _DistrictPickerSheet(
// //       {required this.selectedDistrict, required this.districts});

// //   @override
// //   State<_DistrictPickerSheet> createState() => _DistrictPickerSheetState();
// // }

// // class _DistrictPickerSheetState extends State<_DistrictPickerSheet> {
// //   final _searchCtrl = TextEditingController();
// //   final _searchFocus = FocusNode();
// //   List<String> _filtered = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _filtered = List.from(widget.districts);
// //     _searchCtrl.addListener(_onSearch);
// //     WidgetsBinding.instance
// //         .addPostFrameCallback((_) => _searchFocus.requestFocus());
// //   }

// //   @override
// //   void dispose() {
// //     _searchCtrl.removeListener(_onSearch);
// //     _searchCtrl.dispose();
// //     _searchFocus.dispose();
// //     super.dispose();
// //   }

// //   void _onSearch() {
// //     final q = _searchCtrl.text.trim();
// //     setState(() {
// //       _filtered = q.isEmpty
// //           ? List.from(widget.districts)
// //           : widget.districts.where((d) => d.contains(q)).toList();
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final bottomInset = MediaQuery.of(context).viewInsets.bottom;
// //     return Container(
// //       margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
// //       decoration: BoxDecoration(
// //           color: _C.cardBg, borderRadius: BorderRadius.circular(24)),
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           const SizedBox(height: 12),
// //           Container(
// //               width: 36,
// //               height: 4,
// //               decoration: BoxDecoration(
// //                   color: _C.borderMid,
// //                   borderRadius: BorderRadius.circular(99))),
// //           const SizedBox(height: 16),
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 20),
// //             child: Row(
// //               children: [
// //                 Container(
// //                   width: 34,
// //                   height: 34,
// //                   decoration: BoxDecoration(
// //                       color: _C.greenLight,
// //                       borderRadius: BorderRadius.circular(10)),
// //                   child: const Icon(Icons.location_city_rounded,
// //                       color: _C.darkGreen, size: 18),
// //                 ),
// //                 const SizedBox(width: 10),
// //                 const Expanded(
// //                     child: Text('জেলা নির্বাচন করুন',
// //                         style: TextStyle(
// //                             color: _C.textPrimary,
// //                             fontSize: 16,
// //                             fontWeight: FontWeight.w800))),
// //                 GestureDetector(
// //                   onTap: () => Navigator.of(context).pop(),
// //                   child: Container(
// //                     width: 32,
// //                     height: 32,
// //                     decoration: BoxDecoration(
// //                         color: _C.surfaceAlt,
// //                         borderRadius: BorderRadius.circular(8),
// //                         border: Border.all(color: _C.border)),
// //                     child: const Icon(Icons.close_rounded,
// //                         size: 16, color: _C.textSecondary),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 14),
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 20),
// //             child: TextField(
// //               controller: _searchCtrl,
// //               focusNode: _searchFocus,
// //               style: const TextStyle(
// //                   color: _C.textPrimary,
// //                   fontSize: 14.5,
// //                   fontWeight: FontWeight.w500),
// //               decoration: InputDecoration(
// //                 hintText: 'জেলার নাম লিখুন...',
// //                 hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
// //                 prefixIcon: const Icon(Icons.search_rounded,
// //                     size: 20, color: _C.textSecondary),
// //                 filled: true,
// //                 fillColor: _C.surfaceAlt,
// //                 contentPadding:
// //                     const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
// //                 border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                     borderSide: const BorderSide(color: _C.border)),
// //                 enabledBorder: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                     borderSide: const BorderSide(color: _C.border, width: 1)),
// //                 focusedBorder: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                     borderSide:
// //                         const BorderSide(color: _C.darkGreen, width: 1.5)),
// //                 suffixIcon: _searchCtrl.text.isNotEmpty
// //                     ? GestureDetector(
// //                         onTap: () {
// //                           _searchCtrl.clear();
// //                           _searchFocus.requestFocus();
// //                         },
// //                         child: const Icon(Icons.close_rounded,
// //                             size: 18, color: _C.textSecondary),
// //                       )
// //                     : null,
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           const Divider(height: 1, thickness: 0.5, color: _C.border),
// //           ConstrainedBox(
// //             constraints: BoxConstraints(
// //                 maxHeight:
// //                     MediaQuery.of(context).size.height * 0.45 - bottomInset),
// //             child: _filtered.isEmpty
// //                 ? Padding(
// //                     padding: const EdgeInsets.symmetric(vertical: 32),
// //                     child: Column(children: [
// //                       Icon(Icons.search_off_rounded,
// //                           size: 40, color: _C.textHint),
// //                       const SizedBox(height: 10),
// //                       const Text('কোনো জেলা পাওয়া যায়নি',
// //                           style:
// //                               TextStyle(color: _C.textSecondary, fontSize: 14)),
// //                     ]),
// //                   )
// //                 : ListView.builder(
// //                     padding: EdgeInsets.only(top: 4, bottom: 16 + bottomInset),
// //                     itemCount: _filtered.length,
// //                     itemBuilder: (ctx, i) {
// //                       final d = _filtered[i];
// //                       final isSelected = d == widget.selectedDistrict;
// //                       return InkWell(
// //                         onTap: () => Navigator.of(context).pop(d),
// //                         child: Container(
// //                           padding: const EdgeInsets.symmetric(
// //                               horizontal: 20, vertical: 13),
// //                           color:
// //                               isSelected ? _C.greenLight : Colors.transparent,
// //                           child: Row(
// //                             children: [
// //                               Padding(
// //                                 padding: const EdgeInsets.only(right: 10),
// //                                 child: Icon(
// //                                   isSelected
// //                                       ? Icons.check_circle_rounded
// //                                       : Icons.radio_button_unchecked_rounded,
// //                                   size: 18,
// //                                   color:
// //                                       isSelected ? _C.darkGreen : _C.borderMid,
// //                                 ),
// //                               ),
// //                               Expanded(
// //                                 child: Text(
// //                                   d,
// //                                   style: TextStyle(
// //                                     color: isSelected
// //                                         ? _C.darkGreen
// //                                         : _C.textPrimary,
// //                                     fontSize: 14.5,
// //                                     fontWeight: isSelected
// //                                         ? FontWeight.w700
// //                                         : FontWeight.w400,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       );
// //                     },
// //                   ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // DIALOG ROW
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _DialogRow extends StatelessWidget {
// //   final IconData icon;
// //   final Color iconColor;
// //   final Color bg;
// //   final String text;
// //   const _DialogRow(
// //       {required this.icon,
// //       required this.iconColor,
// //       required this.bg,
// //       required this.text});

// //   @override
// //   Widget build(BuildContext context) => Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
// //         decoration:
// //             BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
// //         child: Row(
// //           children: [
// //             Icon(icon, size: 16, color: iconColor),
// //             const SizedBox(width: 9),
// //             Expanded(
// //                 child: Text(text,
// //                     style: const TextStyle(
// //                         fontSize: 12.5,
// //                         fontWeight: FontWeight.w500,
// //                         color: _C.textPrimary,
// //                         height: 1.35))),
// //           ],
// //         ),
// //       );
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // TEXT FIELD
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _Field extends StatefulWidget {
// //   final String label;
// //   final IconData icon;
// //   final TextEditingController controller;
// //   final FocusNode focusNode;
// //   final String hint;
// //   final String? error;
// //   final TextInputType keyboardType;
// //   final TextInputAction textInputAction;
// //   final void Function(String)? onChanged;
// //   final VoidCallback onSubmit;

// //   const _Field({
// //     required this.label,
// //     required this.icon,
// //     required this.controller,
// //     required this.focusNode,
// //     required this.hint,
// //     this.error,
// //     this.keyboardType = TextInputType.text,
// //     this.textInputAction = TextInputAction.next,
// //     this.onChanged,
// //     required this.onSubmit,
// //   });

// //   @override
// //   State<_Field> createState() => _FieldState();
// // }

// // class _FieldState extends State<_Field> {
// //   bool _focused = false;
// //   late final VoidCallback _fl;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _fl = () {
// //       if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
// //     };
// //     widget.focusNode.addListener(_fl);
// //   }

// //   @override
// //   void dispose() {
// //     widget.focusNode.removeListener(_fl);
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final hasErr = widget.error != null && widget.error!.isNotEmpty;
// //     final iconColor = hasErr
// //         ? _C.red
// //         : _focused
// //             ? _C.darkGreen
// //             : _C.textSecondary;

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           widget.label,
// //           style: TextStyle(
// //             color: hasErr
// //                 ? _C.red
// //                 : _focused
// //                     ? _C.darkGreen
// //                     : _C.textPrimary,
// //             fontWeight: FontWeight.w600,
// //             fontSize: 13,
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         AnimatedContainer(
// //           duration: const Duration(milliseconds: 180),
// //           curve: Curves.easeOutCubic,
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(14),
// //             boxShadow: _focused && !hasErr
// //                 ? [
// //                     BoxShadow(
// //                         color: _C.darkGreen.withOpacity(0.08),
// //                         blurRadius: 12,
// //                         offset: const Offset(0, 4))
// //                   ]
// //                 : [],
// //           ),
// //           child: TextField(
// //             controller: widget.controller,
// //             focusNode: widget.focusNode,
// //             keyboardType: widget.keyboardType,
// //             textInputAction: widget.textInputAction,
// //             onChanged: widget.onChanged,
// //             onEditingComplete: widget.onSubmit,
// //             onSubmitted: (_) => widget.onSubmit(),
// //             style: const TextStyle(
// //                 color: _C.textPrimary,
// //                 fontWeight: FontWeight.w500,
// //                 fontSize: 15),
// //             decoration: InputDecoration(
// //               hintText: widget.hint,
// //               hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
// //               prefixIcon: Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 16),
// //                   child: Icon(widget.icon, size: 20, color: iconColor)),
// //               prefixIconConstraints: const BoxConstraints(minWidth: 54),
// //               filled: true,
// //               fillColor: hasErr
// //                   ? _C.red.withOpacity(0.04)
// //                   : _focused
// //                       ? _C.cardBg
// //                       : _C.surfaceAlt,
// //               border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(14),
// //                   borderSide: const BorderSide(color: _C.border)),
// //               enabledBorder: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(14),
// //                   borderSide: BorderSide(
// //                       color: hasErr ? _C.red.withOpacity(0.5) : _C.border,
// //                       width: 1)),
// //               focusedBorder: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(14),
// //                   borderSide: BorderSide(
// //                       color: hasErr ? _C.red : _C.darkGreen, width: 1.5)),
// //               contentPadding:
// //                   const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
// //             ),
// //           ),
// //         ),
// //         AnimatedSize(
// //           duration: const Duration(milliseconds: 180),
// //           curve: Curves.easeOutCubic,
// //           child: hasErr
// //               ? Padding(
// //                   padding: const EdgeInsets.only(top: 6, left: 4),
// //                   child: Row(children: [
// //                     const Icon(Icons.error_rounded, size: 13, color: _C.red),
// //                     const SizedBox(width: 6),
// //                     Text(widget.error!,
// //                         style: const TextStyle(
// //                             color: _C.red,
// //                             fontSize: 11.5,
// //                             fontWeight: FontWeight.w500)),
// //                   ]),
// //                 )
// //               : const SizedBox.shrink(),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // PASSWORD FIELD
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _PasswordField extends StatefulWidget {
// //   final String label;
// //   final TextEditingController controller;
// //   final FocusNode focusNode;
// //   final String hint;
// //   final String? error;
// //   final TextInputAction textInputAction;
// //   final void Function(String) onChanged;
// //   final VoidCallback onSubmit;
// //   final bool showStrengthBar;

// //   const _PasswordField({
// //     required this.label,
// //     required this.controller,
// //     required this.focusNode,
// //     required this.hint,
// //     this.error,
// //     this.textInputAction = TextInputAction.next,
// //     required this.onChanged,
// //     required this.onSubmit,
// //     this.showStrengthBar = false,
// //   });

// //   @override
// //   State<_PasswordField> createState() => _PasswordFieldState();
// // }

// // class _PasswordFieldState extends State<_PasswordField> {
// //   bool _focused = false, _obscure = true;
// //   late final VoidCallback _fl;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _fl = () {
// //       if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
// //     };
// //     widget.focusNode.addListener(_fl);
// //   }

// //   @override
// //   void dispose() {
// //     widget.focusNode.removeListener(_fl);
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final hasErr = widget.error != null && widget.error!.isNotEmpty;
// //     final iconColor = hasErr
// //         ? _C.red
// //         : _focused
// //             ? _C.darkGreen
// //             : _C.textSecondary;

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(widget.label,
// //             style: TextStyle(
// //                 color: hasErr
// //                     ? _C.red
// //                     : _focused
// //                         ? _C.darkGreen
// //                         : _C.textPrimary,
// //                 fontWeight: FontWeight.w600,
// //                 fontSize: 13)),
// //         const SizedBox(height: 8),
// //         AnimatedContainer(
// //           duration: const Duration(milliseconds: 180),
// //           curve: Curves.easeOutCubic,
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(14),
// //             boxShadow: _focused && !hasErr
// //                 ? [
// //                     BoxShadow(
// //                         color: _C.darkGreen.withOpacity(0.08),
// //                         blurRadius: 12,
// //                         offset: const Offset(0, 4))
// //                   ]
// //                 : [],
// //           ),
// //           child: TextField(
// //             controller: widget.controller,
// //             focusNode: widget.focusNode,
// //             obscureText: _obscure,
// //             textInputAction: widget.textInputAction,
// //             onChanged: widget.onChanged,
// //             onEditingComplete: widget.onSubmit,
// //             onSubmitted: (_) => widget.onSubmit(),
// //             style: const TextStyle(
// //                 color: _C.textPrimary,
// //                 fontWeight: FontWeight.w500,
// //                 fontSize: 15),
// //             decoration: InputDecoration(
// //               hintText: widget.hint,
// //               hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
// //               prefixIcon: Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 16),
// //                   child: Icon(Icons.lock_outline_rounded,
// //                       size: 20, color: iconColor)),
// //               prefixIconConstraints: const BoxConstraints(minWidth: 54),
// //               suffixIcon: GestureDetector(
// //                 onTap: () => setState(() => _obscure = !_obscure),
// //                 child: Padding(
// //                   padding: const EdgeInsets.only(right: 16),
// //                   child: Icon(
// //                       _obscure
// //                           ? Icons.visibility_outlined
// //                           : Icons.visibility_off_outlined,
// //                       size: 20,
// //                       color: _focused ? _C.darkGreen : _C.textSecondary),
// //                 ),
// //               ),
// //               suffixIconConstraints: const BoxConstraints(minWidth: 50),
// //               filled: true,
// //               fillColor: hasErr
// //                   ? _C.red.withOpacity(0.04)
// //                   : _focused
// //                       ? _C.cardBg
// //                       : _C.surfaceAlt,
// //               border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(14),
// //                   borderSide: const BorderSide(color: _C.border)),
// //               enabledBorder: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(14),
// //                   borderSide: BorderSide(
// //                       color: hasErr ? _C.red.withOpacity(0.5) : _C.border,
// //                       width: 1)),
// //               focusedBorder: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(14),
// //                   borderSide: BorderSide(
// //                       color: hasErr ? _C.red : _C.darkGreen, width: 1.5)),
// //               contentPadding:
// //                   const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
// //             ),
// //           ),
// //         ),
// //         AnimatedSize(
// //           duration: const Duration(milliseconds: 180),
// //           curve: Curves.easeOutCubic,
// //           child: hasErr
// //               ? Padding(
// //                   padding: const EdgeInsets.only(top: 6, left: 4),
// //                   child: Row(children: [
// //                     const Icon(Icons.error_rounded, size: 13, color: _C.red),
// //                     const SizedBox(width: 6),
// //                     Text(widget.error!,
// //                         style: const TextStyle(
// //                             color: _C.red,
// //                             fontSize: 11.5,
// //                             fontWeight: FontWeight.w500)),
// //                   ]),
// //                 )
// //               : const SizedBox.shrink(),
// //         ),
// //         if (widget.showStrengthBar && widget.controller.text.isNotEmpty) ...[
// //           const SizedBox(height: 10),
// //           _PasswordStrengthBar(password: widget.controller.text),
// //         ],
// //       ],
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // PASSWORD STRENGTH BAR
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _PasswordStrengthBar extends StatelessWidget {
// //   final String password;
// //   const _PasswordStrengthBar({required this.password});

// //   int get _score {
// //     int s = 0;
// //     if (password.length >= 6) s++;
// //     if (password.length >= 10) s++;
// //     if (password.contains(RegExp(r'[A-Z]'))) s++;
// //     if (password.contains(RegExp(r'[0-9]'))) s++;
// //     if (password.contains(RegExp(r'[^A-Za-z0-9]'))) s++;
// //     return s;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final s = _score;
// //     final color = s <= 1
// //         ? _C.red
// //         : s <= 3
// //             ? _C.amber
// //             : _C.green;
// //     final label = s <= 1
// //         ? 'দুর্বল'
// //         : s <= 3
// //             ? 'মাঝারি'
// //             : 'শক্তিশালী';
// //     return Row(
// //       children: [
// //         Expanded(
// //           child: ClipRRect(
// //             borderRadius: BorderRadius.circular(99),
// //             child: LinearProgressIndicator(
// //                 value: s / 5,
// //                 minHeight: 4,
// //                 backgroundColor: _C.border,
// //                 valueColor: AlwaysStoppedAnimation(color)),
// //           ),
// //         ),
// //         const SizedBox(width: 12),
// //         Text(label,
// //             style: TextStyle(
// //                 fontSize: 11, fontWeight: FontWeight.w700, color: color)),
// //       ],
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // ERROR BANNER
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _ErrorBanner extends StatelessWidget {
// //   final String message;
// //   const _ErrorBanner(this.message);

// //   @override
// //   Widget build(BuildContext context) => Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
// //         decoration: BoxDecoration(
// //           color: _C.redLight,
// //           borderRadius: BorderRadius.circular(12),
// //           border: Border.all(color: _C.red.withOpacity(0.25)),
// //         ),
// //         child: Row(
// //           children: [
// //             const Icon(Icons.error_outline_rounded, color: _C.red, size: 18),
// //             const SizedBox(width: 10),
// //             Expanded(
// //                 child: Text(message,
// //                     style: const TextStyle(
// //                         color: _C.red,
// //                         fontSize: 12.5,
// //                         fontWeight: FontWeight.w500))),
// //           ],
// //         ),
// //       );
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // PRIMARY BUTTON
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _PrimaryButton extends StatelessWidget {
// //   final String label;
// //   final IconData? icon;
// //   final VoidCallback? onTap;
// //   final bool isLoading;

// //   const _PrimaryButton(
// //       {required this.label, this.icon, this.onTap, this.isLoading = false});

// //   @override
// //   Widget build(BuildContext context) {
// //     final enabled = onTap != null && !isLoading;
// //     return AnimatedContainer(
// //       duration: const Duration(milliseconds: 180),
// //       curve: Curves.easeOutCubic,
// //       height: 54,
// //       width: double.infinity,
// //       decoration: BoxDecoration(
// //         color: enabled ? _C.darkGreen : _C.borderMid,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: enabled
// //             ? [
// //                 BoxShadow(
// //                     color: _C.darkGreen.withOpacity(0.3),
// //                     blurRadius: 12,
// //                     offset: const Offset(0, 6))
// //               ]
// //             : [],
// //       ),
// //       child: Material(
// //         color: Colors.transparent,
// //         child: InkWell(
// //           onTap: onTap,
// //           borderRadius: BorderRadius.circular(16),
// //           child: Center(
// //             child: isLoading
// //                 ? const SizedBox(
// //                     width: 24,
// //                     height: 24,
// //                     child: CircularProgressIndicator(
// //                         strokeWidth: 2.5, color: Colors.white))
// //                 : Row(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       if (icon != null) ...[
// //                         Icon(icon, color: Colors.white, size: 20),
// //                         const SizedBox(width: 10)
// //                       ],
// //                       Text(label,
// //                           style: const TextStyle(
// //                               color: Colors.white,
// //                               fontWeight: FontWeight.w700,
// //                               fontSize: 16,
// //                               letterSpacing: -0.2)),
// //                     ],
// //                   ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:amal_tracker/features/auth/providers/provider_reset.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
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
// // DISTRICT MAPPING  (English → Bangla)
// // ─────────────────────────────────────────────────────────────────────────────

// const Map<String, String> _englishToBanglaDistrict = {
//   'dhaka': 'ঢাকা',
//   'chittagong': 'চট্টগ্রাম',
//   'chattogram': 'চট্টগ্রাম',
//   'rajshahi': 'রাজশাহী',
//   'khulna': 'খুলনা',
//   'barisal': 'বরিশাল',
//   'barishal': 'বরিশাল',
//   'sylhet': 'সিলেট',
//   'rangpur': 'রংপুর',
//   'mymensingh': 'ময়মনসিংহ',
//   'faridpur': 'ফরিদপুর',
//   'gazipur': 'গাজীপুর',
//   'narayanganj': 'নারায়ণগঞ্জ',
//   'comilla': 'কুমিল্লা',
//   'cumilla': 'কুমিল্লা',
//   'brahmanbaria': 'ব্রাহ্মণবাড়িয়া',
//   'chandpur': 'চাঁদপুর',
//   'lakshmipur': 'লক্ষ্মীপুর',
//   'noakhali': 'নোয়াখালী',
//   'feni': 'ফেনী',
//   "cox's bazar": 'কক্সবাজার',
//   'coxs bazar': 'কক্সবাজার',
//   'cox bazar': 'কক্সবাজার',
//   'bandarban': 'বান্দরবান',
//   'rangamati': 'রাঙ্গামাটি',
//   'khagrachhari': 'খাগড়াছড়ি',
//   'moulvibazar': 'মৌলভীবাজার',
//   'habiganj': 'হবিগঞ্জ',
//   'sunamganj': 'সুনামগঞ্জ',
//   'netrokona': 'নেত্রকোণা',
//   'kishoreganj': 'কিশোরগঞ্জ',
//   'manikganj': 'মানিকগঞ্জ',
//   'munshiganj': 'মুন্সীগঞ্জ',
//   'tangail': 'টাঙ্গাইল',
//   'narsingdi': 'নরসিংদী',
//   'shariatpur': 'শরীয়তপুর',
//   'madaripur': 'মাদারীপুর',
//   'gopalganj': 'গোপালগঞ্জ',
//   'jhalokati': 'ঝালকাঠি',
//   'pirojpur': 'পিরোজপুর',
//   'barguna': 'বরগুনা',
//   'patuakhali': 'পটুয়াখালী',
//   'bhola': 'ভোলা',
//   'natore': 'নাটোর',
//   'pabna': 'পাবনা',
//   'sirajganj': 'সিরাজগঞ্জ',
//   'bogura': 'বগুড়া',
//   'bogra': 'বগুড়া',
//   'joypurhat': 'জয়পুরহাট',
//   'chapainawabganj': 'চাঁপাইনবাবগঞ্জ',
//   'naogaon': 'নওগাঁ',
//   'dinajpur': 'দিনাজপুর',
//   'lalmonirhat': 'লালমনিরহাট',
//   'nilphamari': 'নীলফামারী',
//   'panchagarh': 'পঞ্চগড়',
//   'thakurgaon': 'ঠাকুরগাঁও',
//   'kurigram': 'কুড়িগ্রাম',
//   'gaibandha': 'গাইবান্ধা',
//   'jashore': 'যশোর',
//   'jessore': 'যশোর',
//   'jhenaidah': 'ঝিনাইদহ',
//   'magura': 'মাগুরা',
//   'narail': 'নড়াইল',
//   'bagerhat': 'বাগেরহাট',
//   'satkhira': 'সাতক্ষীরা',
//   'kushtia': 'কুষ্টিয়া',
//   'meherpur': 'মেহেরপুর',
//   'chuadanga': 'চুয়াডাঙ্গা',
// };

// /// Returns Bangla district name if matched, null otherwise
// String? _matchBanglaDistrict(String candidate) {
//   final n = candidate.toLowerCase().trim();
//   if (n.isEmpty) return null;
//   // Exact
//   if (_englishToBanglaDistrict.containsKey(n)) {
//     return _englishToBanglaDistrict[n];
//   }
//   // Partial — key inside candidate
//   for (final entry in _englishToBanglaDistrict.entries) {
//     if (n.contains(entry.key)) return entry.value;
//   }
//   return null;
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // GENDER OPTIONS
// // ─────────────────────────────────────────────────────────────────────────────

// class _GenderOption {
//   final String value;
//   final String label;
//   final IconData icon;
//   const _GenderOption(this.value, this.label, this.icon);
// }

// const _genderOptions = [
//   _GenderOption('male', 'পুরুষ', Icons.man_rounded),
//   _GenderOption('female', 'মহিলা', Icons.woman_rounded),
//   _GenderOption('other', 'অন্যান্য', Icons.people_alt_rounded),
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
//   // controllers
//   final _nameCtrl = TextEditingController();
//   final _emailCtrl = TextEditingController();
//   final _passCtrl = TextEditingController();
//   final _cfPassCtrl = TextEditingController();

//   // focus nodes
//   final _nameFocus = FocusNode();
//   final _emailFocus = FocusNode();
//   final _passFocus = FocusNode();
//   final _cfPassFocus = FocusNode();

//   // scroll
//   final _scrollCtrl = ScrollController();

//   // form state
//   bool _submitted = false;
//   bool _isRegistering = false;

//   // location state
//   String? _detectedDistrict; // district value that goes to backend
//   String? _fullLocationAddress; // full GPS address (editable)
//   bool _isLocating = false;
//   bool _locationFromGps = false; // GPS দিয়ে set হয়েছে কিনা

//   // gender
//   String? _selectedGender;

//   // validation errors
//   String? _nameErr, _emailErr, _passErr, _cfPassErr, _districtErr, _genderErr;

//   // ── lifecycle ──────────────────────────────────────────────────────────────

//   @override
//   void initState() {
//     super.initState();
//     _addScrollOnFocus(_nameFocus);
//     _addScrollOnFocus(_emailFocus);
//     _addScrollOnFocus(_passFocus);
//     _addScrollOnFocus(_cfPassFocus);
//   }

//   void _addScrollOnFocus(FocusNode node) {
//     node.addListener(() {
//       if (node.hasFocus) _scrollToFocused(node);
//     });
//   }

//   void _scrollToFocused(FocusNode node) {
//     // keyboard আসার পর scroll করো — 300ms delay দরকার
//     Future.delayed(const Duration(milliseconds: 300), () {
//       if (!mounted) return;
//       final ctx = node.context;
//       if (ctx == null) return;
//       Scrollable.ensureVisible(
//         ctx,
//         duration: const Duration(milliseconds: 350),
//         curve: Curves.easeOutCubic,
//         alignment: 0.25, // field টা screen এর উপরের দিকে রাখবে
//       );
//     });
//   }

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
//     _scrollCtrl.dispose();
//     super.dispose();
//   }

//   // ── GPS location ───────────────────────────────────────────────────────────

//   Future<void> _pickCurrentLocation() async {
//     if (_isLocating) return;
//     setState(() => _isLocating = true);

//     try {
//       // Permission
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//       if (permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever) {
//         _showToast('লোকেশন অনুমতি দিন', isError: true);
//         return;
//       }

//       // Position
//       final position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//         timeLimit: const Duration(seconds: 12),
//       );

//       // Reverse geocode
//       final placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );

//       if (placemarks.isEmpty) {
//         _showToast('লোকেশন চিহ্নিত করা যায়নি', isError: true);
//         return;
//       }

//       final p = placemarks.first;

//       // ── Full address compose ──────────────────────────────────────────────
//       final addressParts = [
//         p.street,
//         p.subLocality,
//         p.locality,
//         p.subAdministrativeArea,
//         p.administrativeArea,
//         p.country,
//       ]
//           .where((s) => s != null && s.trim().isNotEmpty)
//           .map((s) => s!.trim())
//           .toList();

//       final fullAddress = addressParts.join(', ');

//       // ── District detection ────────────────────────────────────────────────
//       final isBangladesh =
//           (p.country ?? '').toLowerCase().contains('bangladesh') ||
//               (p.isoCountryCode ?? '').toUpperCase() == 'BD';

//       String? districtValue;

//       if (isBangladesh) {
//         // Try subAdministrativeArea first (usually = district), then others
//         final candidates = [
//           p.subAdministrativeArea ?? '',
//           p.locality ?? '',
//           p.administrativeArea ?? '',
//           fullAddress,
//         ];
//         for (final c in candidates) {
//           districtValue = _matchBanglaDistrict(c);
//           if (districtValue != null) break;
//         }

//         if (districtValue == null) {
//           // BD but couldn't match — show picker hint
//           _showToast('জেলা স্বয়ংক্রিয়ভাবে পাওয়া যায়নি — নিচে টাইপ করুন');
//         }
//       } else {
//         // Different country — use raw subAdministrativeArea / locality
//         districtValue = (p.subAdministrativeArea?.trim().isNotEmpty == true)
//             ? p.subAdministrativeArea!.trim()
//             : (p.locality?.trim().isNotEmpty == true)
//                 ? p.locality!.trim()
//                 : (p.administrativeArea?.trim().isNotEmpty == true)
//                     ? p.administrativeArea!.trim()
//                     : null;

//         if (districtValue != null) {
//           _showToast('বিদেশি লোকেশন — এলাকার নাম সেট হয়েছে');
//         }
//       }

//       setState(() {
//         _fullLocationAddress = fullAddress;
//         _locationFromGps = true;
//         if (districtValue != null) {
//           _detectedDistrict = districtValue;
//           if (_submitted) _districtErr = null;
//         }
//       });
//     } catch (e) {
//       _showToast('লোকেশন নিতে সমস্যা হয়েছে', isError: true);
//     } finally {
//       if (mounted) setState(() => _isLocating = false);
//     }
//   }

//   void _showToast(String msg, {bool isError = false}) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(msg),
//       backgroundColor: isError ? _C.red : _C.amber,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       duration: const Duration(seconds: 3),
//     ));
//   }

//   // ── live validators ────────────────────────────────────────────────────────

//   void _onNameChange(String v) {
//     if (!_submitted) return;
//     setState(() =>
//         _nameErr = v.trim().length < 2 ? 'নাম কমপক্ষে ২ অক্ষর হতে হবে' : null);
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
//     setState(
//         () => _cfPassErr = v != _passCtrl.text ? 'পাসওয়ার্ড মিলছে না' : null);
//   }

//   void _onGenderSelected(String? g) {
//     setState(() {
//       _selectedGender = g;
//       if (_submitted)
//         _genderErr = (g == null || g.isEmpty) ? 'লিঙ্গ নির্বাচন করুন' : null;
//     });
//   }

//   void _onLocationAddressChanged(String v) {
//     setState(() => _fullLocationAddress = v);
//   }

//   void _onDistrictTextChanged(String v) {
//     setState(() {
//       _detectedDistrict = v.trim().isEmpty ? null : v.trim();
//       _locationFromGps = false;
//       if (_submitted) {
//         _districtErr = (v.trim().isEmpty) ? 'জেলা / এলাকা দিন' : null;
//       }
//     });
//   }

//   // ── validate ───────────────────────────────────────────────────────────────

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
//       _districtErr = (_detectedDistrict == null || _detectedDistrict!.isEmpty)
//           ? 'GPS বা ম্যানুয়ালি জেলা দিন'
//           : null;
//       _genderErr = (_selectedGender == null || _selectedGender!.isEmpty)
//           ? 'লিঙ্গ নির্বাচন করুন'
//           : null;
//     });
//     return _nameErr == null &&
//         _emailErr == null &&
//         _passErr == null &&
//         _cfPassErr == null &&
//         _districtErr == null &&
//         _genderErr == null;
//   }

//   // ── confirmation dialog ────────────────────────────────────────────────────

//   Future<bool> _showConfirmationDialog() async {
//     return await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (ctx) => Dialog(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//         child: Container(
//           decoration: BoxDecoration(
//             color: _C.cardBg,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 34,
//                       height: 34,
//                       decoration: BoxDecoration(
//                           color: _C.amberLight,
//                           borderRadius: BorderRadius.circular(9)),
//                       child: const Icon(Icons.info_outline_rounded,
//                           color: _C.amber, size: 18),
//                     ),
//                     const SizedBox(width: 10),
//                     const Expanded(
//                       child: Text('নিবন্ধনের আগে জানুন',
//                           style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w800,
//                               color: _C.textPrimary)),
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(height: 1, color: _C.border),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
//                 child: Column(
//                   children: const [
//                     _DialogRow(
//                         icon: Icons.lock_reset_rounded,
//                         iconColor: _C.amber,
//                         bg: _C.amberLight,
//                         text: 'পাসওয়ার্ড রিসেট এখনো নেই — লিখে রাখুন'),
//                     SizedBox(height: 8),
//                     _DialogRow(
//                         icon: Icons.shield_outlined,
//                         iconColor: _C.green,
//                         bg: _C.greenLight,
//                         text: 'পাসওয়ার্ড শুধু আপনার — কাউকে জানাবেন না'),
//                     SizedBox(height: 8),
//                     _DialogRow(
//                         icon: Icons.alternate_email_rounded,
//                         iconColor: _C.red,
//                         bg: _C.redLight,
//                         text: 'সঠিক ইমেইল দিন — লগইনে দরকার হবে'),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () => Navigator.of(ctx).pop(false),
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: _C.textSecondary,
//                           side: const BorderSide(color: _C.border),
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                         ),
//                         child: const Text('বাতিল',
//                             style: TextStyle(
//                                 fontSize: 13, fontWeight: FontWeight.w600)),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () => Navigator.of(ctx).pop(true),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: _C.darkGreen,
//                           foregroundColor: Colors.white,
//                           elevation: 0,
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                         ),
//                         child: const Text('নিবন্ধন করুন',
//                             style: TextStyle(
//                                 fontSize: 13, fontWeight: FontWeight.w700)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ).then((v) => v ?? false);
//   }

//   // ── register ───────────────────────────────────────────────────────────────

//   Future<void> _register() async {
//     if (_isRegistering) return;
//     if (!_validate()) return;

//     final confirmed = await _showConfirmationDialog();
//     if (!confirmed) return;

//     setState(() => _isRegistering = true);
//     ref.read(authProvider.notifier).clearError();

//     final ok = await ref.read(authProvider.notifier).register(
//           name: _nameCtrl.text.trim(),
//           email: _emailCtrl.text.trim(),
//           password: _passCtrl.text,
//           district: _detectedDistrict!,
//           fullLocation: _fullLocationAddress,
//           department: null,
//           designation: null,
//           phone: null,
//           photoUrl: null,
//           gender: _selectedGender,
//         );

//     if (ok) invalidateUserProviders(ref);
//     setState(() => _isRegistering = false);

//     if (ok && mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: const Text('নিবন্ধন সফল হয়েছে!'),
//         backgroundColor: _C.green,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ));
//       context.go(AppRoutes.home);
//     }
//   }

//   // ── build ──────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     final auth = ref.watch(authProvider);
//     final authError = auth.error;
//     final isLoading = _isRegistering;
//     final size = MediaQuery.of(context).size;

//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: _C.pageBg,
//         // resizeToAvoidBottomInset true (default) — keyboard এলে Scaffold shrink করবে
//         // SingleChildScrollView বাকিটা handle করবে
//         body: Stack(
//           children: [
//             // ── [1] Header gradient
//             Positioned(
//               top: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 height: size.height * 0.35,
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [_C.darkGreen, _C.midGreen],
//                   ),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(32),
//                     bottomRight: Radius.circular(32),
//                   ),
//                 ),
//                 child: Stack(children: [
//                   Positioned(
//                     top: -40,
//                     right: -40,
//                     child: Container(
//                       width: 150,
//                       height: 150,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.white.withOpacity(0.05),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: -30,
//                     left: -30,
//                     child: Container(
//                       width: 100,
//                       height: 100,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: _C.gold.withOpacity(0.08),
//                       ),
//                     ),
//                   ),
//                 ]),
//               ),
//             ),

//             // ── [2] Scroll content
//             SafeArea(
//               child: SingleChildScrollView(
//                 controller: _scrollCtrl,
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 // keyboard এলে bottom inset automatically handle হয়
//                 keyboardDismissBehavior:
//                     ScrollViewKeyboardDismissBehavior.onDrag,
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 40),

//                     // ── Hero
//                     Column(
//                       children: [
//                         Container(
//                           width: 70,
//                           height: 70,
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                                 color: Colors.white.withOpacity(0.25)),
//                           ),
//                           child: const Icon(Icons.person_add_rounded,
//                               color: Colors.white, size: 35),
//                         ).animate().scale(
//                             duration: 500.ms,
//                             curve: Curves.elasticOut,
//                             begin: const Offset(0.5, 0.5)),
//                         const SizedBox(height: 20),
//                         const Text(
//                           'নতুন অ্যাকাউন্ট',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 28,
//                               fontWeight: FontWeight.w800,
//                               letterSpacing: -0.5),
//                         ).animate(delay: 100.ms).fadeIn().slideY(begin: -0.1),
//                         const SizedBox(height: 6),
//                         Text(
//                           'নিবন্ধন করে শুরু করুন',
//                           style: TextStyle(
//                               color: Colors.white.withOpacity(0.75),
//                               fontSize: 14),
//                         ).animate(delay: 150.ms).fadeIn(),
//                       ],
//                     ),

//                     const SizedBox(height: 32),

//                     // ── Form card
//                     IgnorePointer(
//                       ignoring: isLoading,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: _C.cardBg,
//                           borderRadius: BorderRadius.circular(24),
//                           boxShadow: [
//                             BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 20,
//                                 offset: const Offset(0, 8)),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(24),
//                               child: Column(
//                                 children: [
//                                   // API error banner
//                                   if (authError != null) ...[
//                                     _ErrorBanner(authError),
//                                     const SizedBox(height: 20),
//                                   ],

//                                   // Name
//                                   _Field(
//                                     label: 'পূর্ণ নাম',
//                                     icon: Icons.person_outline_rounded,
//                                     controller: _nameCtrl,
//                                     focusNode: _nameFocus,
//                                     hint: 'আপনার পূর্ণ নাম লিখুন',
//                                     error: _nameErr,
//                                     onChanged: _onNameChange,
//                                     onSubmit: () => _emailFocus.requestFocus(),
//                                   )
//                                       .animate(delay: 200.ms)
//                                       .fadeIn()
//                                       .slideY(begin: 0.05),

//                                   const SizedBox(height: 18),

//                                   // Email
//                                   _Field(
//                                     label: 'ইমেইল ঠিকানা',
//                                     icon: Icons.alternate_email_rounded,
//                                     controller: _emailCtrl,
//                                     focusNode: _emailFocus,
//                                     hint: 'example@email.com',
//                                     keyboardType: TextInputType.emailAddress,
//                                     error: _emailErr,
//                                     onChanged: _onEmailChange,
//                                     onSubmit: () =>
//                                         FocusScope.of(context).unfocus(),
//                                   )
//                                       .animate(delay: 250.ms)
//                                       .fadeIn()
//                                       .slideY(begin: 0.05),

//                                   const SizedBox(height: 18),

//                                   // ── GPS Location Field (replaces district picker)
//                                   _LocationField(
//                                     district: _detectedDistrict,
//                                     fullAddress: _fullLocationAddress,
//                                     districtError: _districtErr,
//                                     isLocating: _isLocating,
//                                     locationFromGps: _locationFromGps,
//                                     onGpsTap: _pickCurrentLocation,
//                                     onDistrictChanged: _onDistrictTextChanged,
//                                     onAddressChanged: _onLocationAddressChanged,
//                                     onClearLocation: () => setState(() {
//                                       _detectedDistrict = null;
//                                       _fullLocationAddress = null;
//                                       _locationFromGps = false;
//                                     }),
//                                   )
//                                       .animate(delay: 280.ms)
//                                       .fadeIn()
//                                       .slideY(begin: 0.05),

//                                   const SizedBox(height: 18),

//                                   // Gender
//                                   _GenderSelector(
//                                     selected: _selectedGender,
//                                     error: _genderErr,
//                                     onSelected: _onGenderSelected,
//                                   )
//                                       .animate(delay: 300.ms)
//                                       .fadeIn()
//                                       .slideY(begin: 0.05),

//                                   const SizedBox(height: 18),

//                                   // Password
//                                   _PasswordField(
//                                     label: 'পাসওয়ার্ড',
//                                     controller: _passCtrl,
//                                     focusNode: _passFocus,
//                                     hint: 'কমপক্ষে ৬ অক্ষর',
//                                     error: _passErr,
//                                     onChanged: _onPassChange,
//                                     onSubmit: () => _cfPassFocus.requestFocus(),
//                                     showStrengthBar: true,
//                                   )
//                                       .animate(delay: 310.ms)
//                                       .fadeIn()
//                                       .slideY(begin: 0.05),

//                                   const SizedBox(height: 18),

//                                   // Confirm password
//                                   _PasswordField(
//                                     label: 'পাসওয়ার্ড নিশ্চিত করুন',
//                                     controller: _cfPassCtrl,
//                                     focusNode: _cfPassFocus,
//                                     hint: 'পাসওয়ার্ড আবার লিখুন',
//                                     error: _cfPassErr,
//                                     onChanged: _onCfPassChange,
//                                     onSubmit: _register,
//                                     textInputAction: TextInputAction.done,
//                                   )
//                                       .animate(delay: 350.ms)
//                                       .fadeIn()
//                                       .slideY(begin: 0.05),
//                                 ],
//                               ),
//                             ),

//                             // Register button
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
//                               child: _PrimaryButton(
//                                 label: isLoading
//                                     ? 'নিবন্ধন হচ্ছে...'
//                                     : 'নিবন্ধন করুন',
//                                 icon: isLoading
//                                     ? null
//                                     : Icons.check_circle_rounded,
//                                 onTap: isLoading ? null : _register,
//                                 isLoading: isLoading,
//                               )
//                                   .animate(delay: 400.ms)
//                                   .fadeIn()
//                                   .slideY(begin: 0.05),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ).animate(delay: 180.ms).fadeIn().slideY(begin: 0.1),

//                     const SizedBox(height: 24),

//                     // Login link
//                     GestureDetector(
//                       onTap:
//                           isLoading ? null : () => context.go(AppRoutes.login),
//                       child: Opacity(
//                         opacity: isLoading ? 0.4 : 1.0,
//                         child: RichText(
//                           text: const TextSpan(
//                             text: 'ইতিমধ্যে অ্যাকাউন্ট আছে?  ',
//                             style: TextStyle(
//                                 color: _C.textSecondary, fontSize: 14),
//                             children: [
//                               TextSpan(
//                                 text: 'লগইন করুন',
//                                 style: TextStyle(
//                                     color: _C.darkGreen,
//                                     fontWeight: FontWeight.w700),
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
// // LOCATION FIELD  — GPS button + district text + full address textarea
// // ─────────────────────────────────────────────────────────────────────────────

// class _LocationField extends StatefulWidget {
//   final String? district;
//   final String? fullAddress;
//   final String? districtError;
//   final bool isLocating;
//   final bool locationFromGps;
//   final VoidCallback onGpsTap;
//   final ValueChanged<String> onDistrictChanged;
//   final ValueChanged<String> onAddressChanged;
//   final VoidCallback onClearLocation;

//   const _LocationField({
//     required this.district,
//     required this.fullAddress,
//     required this.districtError,
//     required this.isLocating,
//     required this.locationFromGps,
//     required this.onGpsTap,
//     required this.onDistrictChanged,
//     required this.onAddressChanged,
//     required this.onClearLocation,
//   });

//   @override
//   State<_LocationField> createState() => _LocationFieldState();
// }

// class _LocationFieldState extends State<_LocationField> {
//   late final TextEditingController _districtCtrl;
//   late final TextEditingController _addressCtrl;
//   final _districtFocus = FocusNode();
//   final _addressFocus = FocusNode();
//   bool _districtFocused = false;
//   bool _addressFocused = false;

//   @override
//   void initState() {
//     super.initState();
//     _districtCtrl = TextEditingController(text: widget.district ?? '');
//     _addressCtrl = TextEditingController(text: widget.fullAddress ?? '');

//     _districtFocus.addListener(() {
//       if (mounted) setState(() => _districtFocused = _districtFocus.hasFocus);
//       if (_districtFocus.hasFocus) _scrollSelf();
//     });
//     _addressFocus.addListener(() {
//       if (mounted) setState(() => _addressFocused = _addressFocus.hasFocus);
//       if (_addressFocus.hasFocus) _scrollSelf();
//     });
//   }

//   void _scrollSelf() {
//     Future.delayed(const Duration(milliseconds: 300), () {
//       if (!mounted) return;
//       final ctx = context;
//       Scrollable.ensureVisible(
//         ctx,
//         duration: const Duration(milliseconds: 350),
//         curve: Curves.easeOutCubic,
//         alignment: 0.2,
//       );
//     });
//   }

//   @override
//   void didUpdateWidget(_LocationField old) {
//     super.didUpdateWidget(old);
//     // GPS থেকে district আসলে controller sync করো
//     if (widget.district != old.district) {
//       final newVal = widget.district ?? '';
//       if (_districtCtrl.text != newVal) {
//         _districtCtrl.text = newVal;
//         _districtCtrl.selection = TextSelection.fromPosition(
//           TextPosition(offset: newVal.length),
//         );
//       }
//     }
//     // GPS থেকে address আসলে
//     if (widget.fullAddress != old.fullAddress) {
//       final newVal = widget.fullAddress ?? '';
//       if (_addressCtrl.text != newVal) {
//         _addressCtrl.text = newVal;
//         _addressCtrl.selection = TextSelection.fromPosition(
//           TextPosition(offset: newVal.length),
//         );
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _districtCtrl.dispose();
//     _addressCtrl.dispose();
//     _districtFocus.dispose();
//     _addressFocus.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hasDistrictErr =
//         widget.districtError != null && widget.districtError!.isNotEmpty;
//     final hasDistrict = widget.district != null && widget.district!.isNotEmpty;
//     final hasAddress =
//         widget.fullAddress != null && widget.fullAddress!.isNotEmpty;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // ── Section header row ──────────────────────────────────────────────
//         Row(
//           children: [
//             Container(
//               width: 28,
//               height: 28,
//               decoration: BoxDecoration(
//                 color: _C.greenLight,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(Icons.location_on_rounded,
//                   color: _C.darkGreen, size: 15),
//             ),
//             const SizedBox(width: 8),
//             const Text(
//               'লোকেশন',
//               style: TextStyle(
//                   color: _C.textPrimary,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 14),
//             ),
//             const Spacer(),
//             // GPS button
//             GestureDetector(
//               onTap: widget.isLocating ? null : widget.onGpsTap,
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
//                 decoration: BoxDecoration(
//                   color: widget.isLocating ? _C.greenLight : _C.darkGreen,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: widget.isLocating
//                       ? []
//                       : [
//                           BoxShadow(
//                               color: _C.darkGreen.withOpacity(0.3),
//                               blurRadius: 8,
//                               offset: const Offset(0, 3))
//                         ],
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     widget.isLocating
//                         ? const SizedBox(
//                             width: 13,
//                             height: 13,
//                             child: CircularProgressIndicator(
//                                 strokeWidth: 2, color: _C.darkGreen))
//                         : const Icon(Icons.my_location_rounded,
//                             size: 14, color: Colors.white),
//                     const SizedBox(width: 6),
//                     Text(
//                       widget.isLocating ? 'খুঁজছে...' : 'GPS দিয়ে নিন',
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w700,
//                         color: widget.isLocating ? _C.darkGreen : Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),

//         const SizedBox(height: 12),

//         // ── District field ──────────────────────────────────────────────────
//         Text(
//           'জেলা / এলাকা',
//           style: TextStyle(
//             color: hasDistrictErr
//                 ? _C.red
//                 : _districtFocused
//                     ? _C.darkGreen
//                     : _C.textPrimary,
//             fontWeight: FontWeight.w600,
//             fontSize: 13,
//           ),
//         ),
//         const SizedBox(height: 8),

//         AnimatedContainer(
//           duration: const Duration(milliseconds: 180),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             boxShadow: _districtFocused && !hasDistrictErr
//                 ? [
//                     BoxShadow(
//                         color: _C.darkGreen.withOpacity(0.08),
//                         blurRadius: 12,
//                         offset: const Offset(0, 4))
//                   ]
//                 : [],
//           ),
//           child: TextField(
//             controller: _districtCtrl,
//             focusNode: _districtFocus,
//             onChanged: widget.onDistrictChanged,
//             textInputAction: TextInputAction.next,
//             onSubmitted: (_) => _addressFocus.requestFocus(),
//             style: const TextStyle(
//                 color: _C.textPrimary,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 15),
//             decoration: InputDecoration(
//               hintText: 'GPS বাটন চাপুন বা নিজে লিখুন',
//               hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
//               prefixIcon: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Icon(
//                   widget.locationFromGps
//                       ? Icons.gps_fixed_rounded
//                       : Icons.location_city_rounded,
//                   size: 20,
//                   color: hasDistrictErr
//                       ? _C.red
//                       : _districtFocused
//                           ? _C.darkGreen
//                           : hasDistrict && widget.locationFromGps
//                               ? _C.green
//                               : _C.textSecondary,
//                 ),
//               ),
//               prefixIconConstraints: const BoxConstraints(minWidth: 54),
//               suffixIcon: hasDistrict
//                   ? GestureDetector(
//                       onTap: widget.onClearLocation,
//                       child: const Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 14),
//                         child: Icon(Icons.close_rounded,
//                             size: 18, color: _C.textSecondary),
//                       ),
//                     )
//                   : null,
//               suffixIconConstraints: const BoxConstraints(minWidth: 50),
//               filled: true,
//               fillColor: hasDistrictErr
//                   ? _C.red.withOpacity(0.04)
//                   : _districtFocused
//                       ? _C.cardBg
//                       : hasDistrict && widget.locationFromGps
//                           ? _C.greenLight
//                           : _C.surfaceAlt,
//               border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: const BorderSide(color: _C.border)),
//               enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: BorderSide(
//                     color: hasDistrictErr
//                         ? _C.red.withOpacity(0.5)
//                         : hasDistrict && widget.locationFromGps
//                             ? _C.darkGreen.withOpacity(0.4)
//                             : _C.border,
//                     width: hasDistrict && widget.locationFromGps ? 1.5 : 1.0,
//                   )),
//               focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: BorderSide(
//                       color: hasDistrictErr ? _C.red : _C.darkGreen,
//                       width: 1.5)),
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//             ),
//           ),
//         ),

//         // GPS badge — জেলা GPS থেকে এসেছে
//         if (widget.locationFromGps && hasDistrict) ...[
//           const SizedBox(height: 6),
//           Row(
//             children: [
//               const Icon(Icons.gps_fixed_rounded, size: 12, color: _C.green),
//               const SizedBox(width: 5),
//               Text(
//                 'GPS থেকে স্বয়ংক্রিয়ভাবে নির্ধারিত',
//                 style: const TextStyle(
//                     color: _C.green, fontSize: 11, fontWeight: FontWeight.w600),
//               ),
//             ],
//           ),
//         ],

//         // error
//         AnimatedSize(
//           duration: const Duration(milliseconds: 180),
//           curve: Curves.easeOutCubic,
//           child: hasDistrictErr
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 6, left: 4),
//                   child: Row(children: [
//                     const Icon(Icons.error_rounded, size: 13, color: _C.red),
//                     const SizedBox(width: 6),
//                     Text(widget.districtError!,
//                         style: const TextStyle(
//                             color: _C.red,
//                             fontSize: 11.5,
//                             fontWeight: FontWeight.w500)),
//                   ]),
//                 )
//               : const SizedBox.shrink(),
//         ),

//         const SizedBox(height: 14),

//         // ── Full address field ──────────────────────────────────────────────
//         Text(
//           'পূর্ণ ঠিকানা',
//           style: TextStyle(
//             color: _addressFocused ? _C.darkGreen : _C.textSecondary,
//             fontWeight: FontWeight.w600,
//             fontSize: 13,
//           ),
//         ),
//         const SizedBox(height: 8),

//         AnimatedContainer(
//           duration: const Duration(milliseconds: 180),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             boxShadow: _addressFocused
//                 ? [
//                     BoxShadow(
//                         color: _C.darkGreen.withOpacity(0.08),
//                         blurRadius: 12,
//                         offset: const Offset(0, 4))
//                   ]
//                 : [],
//           ),
//           child: TextField(
//             controller: _addressCtrl,
//             focusNode: _addressFocus,
//             onChanged: widget.onAddressChanged,
//             maxLines: 3,
//             minLines: 2,
//             textInputAction: TextInputAction.newline,
//             style: const TextStyle(
//               color: _C.textPrimary,
//               fontWeight: FontWeight.w400,
//               fontSize: 13.5,
//               height: 1.55,
//             ),
//             decoration: InputDecoration(
//               hintText:
//                   'GPS বাটন চাপলে এখানে স্বয়ংক্রিয়ভাবে আসবে\nঅথবা নিজে লিখুন...',
//               hintStyle: const TextStyle(
//                   color: _C.textHint, fontSize: 12.5, height: 1.5),
//               prefixIcon: Padding(
//                 padding: const EdgeInsets.only(left: 16, right: 12, top: 16),
//                 child: Icon(
//                   Icons.location_on_outlined,
//                   size: 19,
//                   color: _addressFocused ? _C.darkGreen : _C.textSecondary,
//                 ),
//               ),
//               prefixIconConstraints: const BoxConstraints(minWidth: 54),
//               suffixIcon: hasAddress
//                   ? GestureDetector(
//                       onTap: () {
//                         _addressCtrl.clear();
//                         widget.onAddressChanged('');
//                       },
//                       child: const Padding(
//                         padding: EdgeInsets.only(right: 14, top: 12),
//                         child: Icon(Icons.close_rounded,
//                             size: 16, color: _C.textSecondary),
//                       ),
//                     )
//                   : null,
//               suffixIconConstraints: const BoxConstraints(minWidth: 46),
//               filled: true,
//               fillColor: _addressFocused ? _C.cardBg : _C.surfaceAlt,
//               border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: const BorderSide(color: _C.border)),
//               enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: BorderSide(
//                     color: hasAddress && widget.locationFromGps
//                         ? _C.darkGreen.withOpacity(0.3)
//                         : _C.border,
//                     width: hasAddress && widget.locationFromGps ? 1.5 : 1.0,
//                   )),
//               focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide:
//                       const BorderSide(color: _C.darkGreen, width: 1.5)),
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//               alignLabelWithHint: true,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // GENDER SELECTOR
// // ─────────────────────────────────────────────────────────────────────────────

// class _GenderSelector extends StatelessWidget {
//   final String? selected;
//   final String? error;
//   final void Function(String?) onSelected;

//   const _GenderSelector(
//       {required this.selected, required this.error, required this.onSelected});

//   @override
//   Widget build(BuildContext context) {
//     final hasErr = error != null && error!.isNotEmpty;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('লিঙ্গ',
//             style: TextStyle(
//                 color: hasErr ? _C.red : _C.textPrimary,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 13)),
//         const SizedBox(height: 8),
//         Row(
//           children: List.generate(_genderOptions.length, (i) {
//             final opt = _genderOptions[i];
//             final isSelected = selected == opt.value;
//             return Expanded(
//               child: Padding(
//                 padding: EdgeInsets.only(
//                     right: i < _genderOptions.length - 1 ? 8 : 0),
//                 child: GestureDetector(
//                   onTap: () => onSelected(isSelected ? null : opt.value),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 180),
//                     curve: Curves.easeOutCubic,
//                     height: 54,
//                     decoration: BoxDecoration(
//                       color: isSelected
//                           ? _C.greenLight
//                           : hasErr
//                               ? _C.red.withOpacity(0.04)
//                               : _C.surfaceAlt,
//                       borderRadius: BorderRadius.circular(14),
//                       border: Border.all(
//                         color: isSelected
//                             ? _C.darkGreen
//                             : hasErr
//                                 ? _C.red.withOpacity(0.5)
//                                 : _C.border,
//                         width: isSelected ? 1.5 : 1.0,
//                       ),
//                       boxShadow: isSelected
//                           ? [
//                               BoxShadow(
//                                   color: _C.darkGreen.withOpacity(0.08),
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 3))
//                             ]
//                           : [],
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(opt.icon,
//                             size: 20,
//                             color: isSelected
//                                 ? _C.darkGreen
//                                 : hasErr
//                                     ? _C.red
//                                     : _C.textSecondary),
//                         const SizedBox(height: 3),
//                         Text(opt.label,
//                             style: TextStyle(
//                                 fontSize: 11.5,
//                                 fontWeight: isSelected
//                                     ? FontWeight.w700
//                                     : FontWeight.w500,
//                                 color: isSelected
//                                     ? _C.darkGreen
//                                     : hasErr
//                                         ? _C.red
//                                         : _C.textSecondary)),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ),
//         AnimatedSize(
//           duration: const Duration(milliseconds: 180),
//           curve: Curves.easeOutCubic,
//           child: hasErr
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 6, left: 4),
//                   child: Row(children: [
//                     const Icon(Icons.error_rounded, size: 13, color: _C.red),
//                     const SizedBox(width: 6),
//                     Text(error!,
//                         style: const TextStyle(
//                             color: _C.red,
//                             fontSize: 11.5,
//                             fontWeight: FontWeight.w500)),
//                   ]),
//                 )
//               : const SizedBox.shrink(),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DIALOG ROW
// // ─────────────────────────────────────────────────────────────────────────────

// class _DialogRow extends StatelessWidget {
//   final IconData icon;
//   final Color iconColor;
//   final Color bg;
//   final String text;
//   const _DialogRow(
//       {required this.icon,
//       required this.iconColor,
//       required this.bg,
//       required this.text});

//   @override
//   Widget build(BuildContext context) => Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
//         decoration:
//             BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
//         child: Row(
//           children: [
//             Icon(icon, size: 16, color: iconColor),
//             const SizedBox(width: 9),
//             Expanded(
//                 child: Text(text,
//                     style: const TextStyle(
//                         fontSize: 12.5,
//                         fontWeight: FontWeight.w500,
//                         color: _C.textPrimary,
//                         height: 1.35))),
//           ],
//         ),
//       );
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
//   late final VoidCallback _fl;

//   @override
//   void initState() {
//     super.initState();
//     _fl = () {
//       if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
//     };
//     widget.focusNode.addListener(_fl);
//   }

//   @override
//   void dispose() {
//     widget.focusNode.removeListener(_fl);
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
//         Text(widget.label,
//             style: TextStyle(
//                 color: hasErr
//                     ? _C.red
//                     : _focused
//                         ? _C.darkGreen
//                         : _C.textPrimary,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 13)),
//         const SizedBox(height: 8),
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 180),
//           curve: Curves.easeOutCubic,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             boxShadow: _focused && !hasErr
//                 ? [
//                     BoxShadow(
//                         color: _C.darkGreen.withOpacity(0.08),
//                         blurRadius: 12,
//                         offset: const Offset(0, 4))
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
//                 color: _C.textPrimary,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 15),
//             decoration: InputDecoration(
//               hintText: widget.hint,
//               hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
//               prefixIcon: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Icon(widget.icon, size: 20, color: iconColor)),
//               prefixIconConstraints: const BoxConstraints(minWidth: 54),
//               filled: true,
//               fillColor: hasErr
//                   ? _C.red.withOpacity(0.04)
//                   : _focused
//                       ? _C.cardBg
//                       : _C.surfaceAlt,
//               border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: const BorderSide(color: _C.border)),
//               enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: BorderSide(
//                       color: hasErr ? _C.red.withOpacity(0.5) : _C.border,
//                       width: 1)),
//               focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: BorderSide(
//                       color: hasErr ? _C.red : _C.darkGreen, width: 1.5)),
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//             ),
//           ),
//         ),
//         AnimatedSize(
//           duration: const Duration(milliseconds: 180),
//           curve: Curves.easeOutCubic,
//           child: hasErr
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 6, left: 4),
//                   child: Row(children: [
//                     const Icon(Icons.error_rounded, size: 13, color: _C.red),
//                     const SizedBox(width: 6),
//                     Text(widget.error!,
//                         style: const TextStyle(
//                             color: _C.red,
//                             fontSize: 11.5,
//                             fontWeight: FontWeight.w500)),
//                   ]),
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
//   final bool showStrengthBar;

//   const _PasswordField({
//     required this.label,
//     required this.controller,
//     required this.focusNode,
//     required this.hint,
//     this.error,
//     this.textInputAction = TextInputAction.next,
//     required this.onChanged,
//     required this.onSubmit,
//     this.showStrengthBar = false,
//   });

//   @override
//   State<_PasswordField> createState() => _PasswordFieldState();
// }

// class _PasswordFieldState extends State<_PasswordField> {
//   bool _focused = false, _obscure = true;
//   late final VoidCallback _fl;

//   @override
//   void initState() {
//     super.initState();
//     _fl = () {
//       if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
//     };
//     widget.focusNode.addListener(_fl);
//   }

//   @override
//   void dispose() {
//     widget.focusNode.removeListener(_fl);
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
//         Text(widget.label,
//             style: TextStyle(
//                 color: hasErr
//                     ? _C.red
//                     : _focused
//                         ? _C.darkGreen
//                         : _C.textPrimary,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 13)),
//         const SizedBox(height: 8),
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 180),
//           curve: Curves.easeOutCubic,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             boxShadow: _focused && !hasErr
//                 ? [
//                     BoxShadow(
//                         color: _C.darkGreen.withOpacity(0.08),
//                         blurRadius: 12,
//                         offset: const Offset(0, 4))
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
//                 color: _C.textPrimary,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 15),
//             decoration: InputDecoration(
//               hintText: widget.hint,
//               hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
//               prefixIcon: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Icon(Icons.lock_outline_rounded,
//                       size: 20, color: iconColor)),
//               prefixIconConstraints: const BoxConstraints(minWidth: 54),
//               suffixIcon: GestureDetector(
//                 onTap: () => setState(() => _obscure = !_obscure),
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 16),
//                   child: Icon(
//                       _obscure
//                           ? Icons.visibility_outlined
//                           : Icons.visibility_off_outlined,
//                       size: 20,
//                       color: _focused ? _C.darkGreen : _C.textSecondary),
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
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: const BorderSide(color: _C.border)),
//               enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: BorderSide(
//                       color: hasErr ? _C.red.withOpacity(0.5) : _C.border,
//                       width: 1)),
//               focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: BorderSide(
//                       color: hasErr ? _C.red : _C.darkGreen, width: 1.5)),
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//             ),
//           ),
//         ),
//         AnimatedSize(
//           duration: const Duration(milliseconds: 180),
//           curve: Curves.easeOutCubic,
//           child: hasErr
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 6, left: 4),
//                   child: Row(children: [
//                     const Icon(Icons.error_rounded, size: 13, color: _C.red),
//                     const SizedBox(width: 6),
//                     Text(widget.error!,
//                         style: const TextStyle(
//                             color: _C.red,
//                             fontSize: 11.5,
//                             fontWeight: FontWeight.w500)),
//                   ]),
//                 )
//               : const SizedBox.shrink(),
//         ),
//         if (widget.showStrengthBar && widget.controller.text.isNotEmpty) ...[
//           const SizedBox(height: 10),
//           _PasswordStrengthBar(password: widget.controller.text),
//         ],
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
//     return Row(
//       children: [
//         Expanded(
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(99),
//             child: LinearProgressIndicator(
//                 value: s / 5,
//                 minHeight: 4,
//                 backgroundColor: _C.border,
//                 valueColor: AlwaysStoppedAnimation(color)),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Text(label,
//             style: TextStyle(
//                 fontSize: 11, fontWeight: FontWeight.w700, color: color)),
//       ],
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
//   Widget build(BuildContext context) => Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         decoration: BoxDecoration(
//           color: _C.redLight,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: _C.red.withOpacity(0.25)),
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.error_outline_rounded, color: _C.red, size: 18),
//             const SizedBox(width: 10),
//             Expanded(
//                 child: Text(message,
//                     style: const TextStyle(
//                         color: _C.red,
//                         fontSize: 12.5,
//                         fontWeight: FontWeight.w500))),
//           ],
//         ),
//       );
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PRIMARY BUTTON
// // ─────────────────────────────────────────────────────────────────────────────

// class _PrimaryButton extends StatelessWidget {
//   final String label;
//   final IconData? icon;
//   final VoidCallback? onTap;
//   final bool isLoading;

//   const _PrimaryButton(
//       {required this.label, this.icon, this.onTap, this.isLoading = false});

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
//                     color: _C.darkGreen.withOpacity(0.3),
//                     blurRadius: 12,
//                     offset: const Offset(0, 6))
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
//                         strokeWidth: 2.5, color: Colors.white))
//                 : Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       if (icon != null) ...[
//                         Icon(icon, color: Colors.white, size: 20),
//                         const SizedBox(width: 10),
//                       ],
//                       Text(label,
//                           style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 16,
//                               letterSpacing: -0.2)),
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
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
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
// // DISTRICT MAPPING
// // ─────────────────────────────────────────────────────────────────────────────

// const Map<String, String> _englishToBangla = {
//   'dhaka': 'ঢাকা',
//   'chittagong': 'চট্টগ্রাম',
//   'chattogram': 'চট্টগ্রাম',
//   'rajshahi': 'রাজশাহী',
//   'khulna': 'খুলনা',
//   'barisal': 'বরিশাল',
//   'barishal': 'বরিশাল',
//   'sylhet': 'সিলেট',
//   'rangpur': 'রংপুর',
//   'mymensingh': 'ময়মনসিংহ',
//   'faridpur': 'ফরিদপুর',
//   'gazipur': 'গাজীপুর',
//   'narayanganj': 'নারায়ণগঞ্জ',
//   'comilla': 'কুমিল্লা',
//   'cumilla': 'কুমিল্লা',
//   'brahmanbaria': 'ব্রাহ্মণবাড়িয়া',
//   'chandpur': 'চাঁদপুর',
//   'lakshmipur': 'লক্ষ্মীপুর',
//   'noakhali': 'নোয়াখালী',
//   'feni': 'ফেনী',
//   "cox's bazar": 'কক্সবাজার',
//   'coxs bazar': 'কক্সবাজার',
//   'cox bazar': 'কক্সবাজার',
//   'bandarban': 'বান্দরবান',
//   'rangamati': 'রাঙ্গামাটি',
//   'khagrachhari': 'খাগড়াছড়ি',
//   'moulvibazar': 'মৌলভীবাজার',
//   'habiganj': 'হবিগঞ্জ',
//   'sunamganj': 'সুনামগঞ্জ',
//   'netrokona': 'নেত্রকোণা',
//   'kishoreganj': 'কিশোরগঞ্জ',
//   'manikganj': 'মানিকগঞ্জ',
//   'munshiganj': 'মুন্সীগঞ্জ',
//   'tangail': 'টাঙ্গাইল',
//   'narsingdi': 'নরসিংদী',
//   'shariatpur': 'শরীয়তপুর',
//   'madaripur': 'মাদারীপুর',
//   'gopalganj': 'গোপালগঞ্জ',
//   'jhalokati': 'ঝালকাঠি',
//   'pirojpur': 'পিরোজপুর',
//   'barguna': 'বরগুনা',
//   'patuakhali': 'পটুয়াখালী',
//   'bhola': 'ভোলা',
//   'natore': 'নাটোর',
//   'pabna': 'পাবনা',
//   'sirajganj': 'সিরাজগঞ্জ',
//   'bogura': 'বগুড়া',
//   'bogra': 'বগুড়া',
//   'joypurhat': 'জয়পুরহাট',
//   'chapainawabganj': 'চাঁপাইনবাবগঞ্জ',
//   'naogaon': 'নওগাঁ',
//   'dinajpur': 'দিনাজপুর',
//   'lalmonirhat': 'লালমনিরহাট',
//   'nilphamari': 'নীলফামারী',
//   'panchagarh': 'পঞ্চগড়',
//   'thakurgaon': 'ঠাকুরগাঁও',
//   'kurigram': 'কুড়িগ্রাম',
//   'gaibandha': 'গাইবান্ধা',
//   'jashore': 'যশোর',
//   'jessore': 'যশোর',
//   'jhenaidah': 'ঝিনাইদহ',
//   'magura': 'মাগুরা',
//   'narail': 'নড়াইল',
//   'bagerhat': 'বাগেরহাট',
//   'satkhira': 'সাতক্ষীরা',
//   'kushtia': 'কুষ্টিয়া',
//   'meherpur': 'মেহেরপুর',
//   'chuadanga': 'চুয়াডাঙ্গা',
// };

// String? _matchBangla(String candidate) {
//   final n = candidate.toLowerCase().trim();
//   if (n.isEmpty) return null;
//   if (_englishToBangla.containsKey(n)) return _englishToBangla[n];
//   for (final e in _englishToBangla.entries) {
//     if (n.contains(e.key)) return e.value;
//   }
//   return null;
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // GENDER
// // ─────────────────────────────────────────────────────────────────────────────

// class _G {
//   final String value, label;
//   final IconData icon;
//   const _G(this.value, this.label, this.icon);
// }

// const _genders = [
//   _G('male', 'পুরুষ', Icons.man_rounded),
//   _G('female', 'মহিলা', Icons.woman_rounded),
//   _G('other', 'অন্যান্য', Icons.people_alt_rounded),
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
//   final _nameFocus = FocusNode();
//   final _emailFocus = FocusNode();
//   final _passFocus = FocusNode();
//   final _cfPassFocus = FocusNode();
//   final _scrollCtrl = ScrollController();

//   bool _submitted = false;
//   bool _isRegistering = false;
//   bool _isLocating = false;

//   // GPS — only these two matter now
//   String? _district; // value sent to backend (Bangla or raw foreign)
//   String? _fullAddress; // stored internally, NOT shown to user

//   String? _selectedGender;
//   String? _nameErr, _emailErr, _passErr, _cfPassErr, _districtErr, _genderErr;

//   // ── init ───────────────────────────────────────────────────────────────────

//   @override
//   void initState() {
//     super.initState();
//     for (final n in [_nameFocus, _emailFocus, _passFocus, _cfPassFocus]) {
//       n.addListener(() {
//         if (n.hasFocus) _ensureVisible(n);
//       });
//     }
//   }

//   void _ensureVisible(FocusNode node) {
//     Future.delayed(const Duration(milliseconds: 300), () {
//       if (!mounted) return;
//       final ctx = node.context;
//       if (ctx == null) return;
//       Scrollable.ensureVisible(ctx,
//           duration: const Duration(milliseconds: 350),
//           curve: Curves.easeOutCubic,
//           alignment: 0.25);
//     });
//   }

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
//     _scrollCtrl.dispose();
//     super.dispose();
//   }

//   // ── GPS ────────────────────────────────────────────────────────────────────

//   Future<void> _pickLocation() async {
//     if (_isLocating) return;
//     setState(() => _isLocating = true);
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         _toast('ডিভাইসের লোকেশন সার্ভিস চালু করুন', err: true);
//         return;
//       }
//       LocationPermission perm = await Geolocator.checkPermission();
//       if (perm == LocationPermission.denied) {
//         perm = await Geolocator.requestPermission();
//       }
//       if (perm == LocationPermission.denied ||
//           perm == LocationPermission.deniedForever) {
//         _toast('লোকেশন অনুমতি দিন', err: true);
//         return;
//       }

//       final pos = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//         timeLimit: const Duration(seconds: 12),
//       );

//       final marks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
//       if (marks.isEmpty) {
//         _toast('লোকেশন পাওয়া যায়নি', err: true);
//         return;
//       }

//       final p = marks.first;
//       final isBD = (p.country ?? '').toLowerCase().contains('bangladesh') ||
//           (p.isoCountryCode ?? '').toUpperCase() == 'BD';

//       // Full address — stored internally only
//       final full = [
//         p.street,
//         p.subLocality,
//         p.locality,
//         p.subAdministrativeArea,
//         p.administrativeArea,
//         p.country
//       ]
//           .where((s) => s != null && s.trim().isNotEmpty)
//           .map((s) => s!.trim())
//           .join(', ');

//       String? district;

//       if (isBD) {
//         for (final c in [
//           p.subAdministrativeArea ?? '',
//           p.locality ?? '',
//           p.administrativeArea ?? '',
//         ]) {
//           district = _matchBangla(c);
//           if (district != null) break;
//         }
//         if (district == null)
//           _toast('জেলা চেনা যায়নি, আবার চেষ্টা করুন', err: true);
//       } else {
//         // foreign — use raw name
//         district = p.subAdministrativeArea?.trim().isNotEmpty == true
//             ? p.subAdministrativeArea!.trim()
//             : p.locality?.trim().isNotEmpty == true
//                 ? p.locality!.trim()
//                 : p.administrativeArea?.trim();
//         if (district != null) _toast('বিদেশি লোকেশন সেট হয়েছে');
//       }

//       setState(() {
//         _fullAddress = full;
//         if (district != null) {
//           _district = district;
//           if (_submitted) _districtErr = null;
//         }
//       });
//     } catch (_) {
//       _toast('লোকেশন নিতে সমস্যা হয়েছে', err: true);
//     } finally {
//       if (mounted) setState(() => _isLocating = false);
//     }
//   }

//   void _toast(String msg, {bool err = false}) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(msg),
//       backgroundColor: err ? _C.red : _C.amber,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       duration: const Duration(seconds: 3),
//     ));
//   }

//   // ── validators ─────────────────────────────────────────────────────────────

//   void _onNameChange(String v) {
//     if (!_submitted) return;
//     setState(() =>
//         _nameErr = v.trim().length < 2 ? 'নাম কমপক্ষে ২ অক্ষর হতে হবে' : null);
//   }

//   void _onEmailChange(String v) {
//     if (!_submitted) return;
//     setState(() {
//       _emailErr = v.trim().isEmpty
//           ? 'ইমেইল দিন'
//           : !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())
//               ? 'সঠিক ইমেইল ঠিকানা দিন'
//               : null;
//     });
//   }

//   void _onPassChange(String v) {
//     if (!_submitted) return;
//     setState(() {
//       _passErr = v.isEmpty
//           ? 'পাসওয়ার্ড দিন'
//           : v.length < 6
//               ? 'কমপক্ষে ৬ অক্ষর হতে হবে'
//               : null;
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

//   void _onGenderSelected(String? g) {
//     setState(() {
//       _selectedGender = g;
//       if (_submitted)
//         _genderErr = (g == null || g.isEmpty) ? 'লিঙ্গ নির্বাচন করুন' : null;
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
//       _districtErr = (_district == null || _district!.isEmpty)
//           ? 'GPS বাটন চেপে জেলা নির্ধারণ করুন'
//           : null;
//       _genderErr = (_selectedGender == null || _selectedGender!.isEmpty)
//           ? 'লিঙ্গ নির্বাচন করুন'
//           : null;
//     });
//     return _nameErr == null &&
//         _emailErr == null &&
//         _passErr == null &&
//         _cfPassErr == null &&
//         _districtErr == null &&
//         _genderErr == null;
//   }

//   // ── confirmation dialog ────────────────────────────────────────────────────

//   Future<bool> _showConfirmDialog() async {
//     return await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (ctx) => Dialog(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//         child: Container(
//           decoration: BoxDecoration(
//               color: _C.cardBg, borderRadius: BorderRadius.circular(20)),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
//                 child: Row(children: [
//                   Container(
//                       width: 34,
//                       height: 34,
//                       decoration: BoxDecoration(
//                           color: _C.amberLight,
//                           borderRadius: BorderRadius.circular(9)),
//                       child: const Icon(Icons.info_outline_rounded,
//                           color: _C.amber, size: 18)),
//                   const SizedBox(width: 10),
//                   const Expanded(
//                       child: Text('নিবন্ধনের আগে জানুন',
//                           style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w800,
//                               color: _C.textPrimary))),
//                 ]),
//               ),
//               const Divider(height: 1, color: _C.border),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
//                 child: Column(children: const [
//                   _DRow(
//                       icon: Icons.lock_reset_rounded,
//                       iconColor: _C.amber,
//                       bg: _C.amberLight,
//                       text: 'পাসওয়ার্ড রিসেট এখনো নেই — লিখে রাখুন'),
//                   SizedBox(height: 8),
//                   _DRow(
//                       icon: Icons.shield_outlined,
//                       iconColor: _C.green,
//                       bg: _C.greenLight,
//                       text: 'পাসওয়ার্ড শুধু আপনার — কাউকে জানাবেন না'),
//                   SizedBox(height: 8),
//                   _DRow(
//                       icon: Icons.alternate_email_rounded,
//                       iconColor: _C.red,
//                       bg: _C.redLight,
//                       text: 'সঠিক ইমেইল দিন — লগইনে দরকার হবে'),
//                 ]),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
//                 child: Row(children: [
//                   Expanded(
//                       child: OutlinedButton(
//                     onPressed: () => Navigator.of(ctx).pop(false),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: _C.textSecondary,
//                       side: const BorderSide(color: _C.border),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                     child: const Text('বাতিল',
//                         style: TextStyle(
//                             fontSize: 13, fontWeight: FontWeight.w600)),
//                   )),
//                   const SizedBox(width: 10),
//                   Expanded(
//                       child: ElevatedButton(
//                     onPressed: () => Navigator.of(ctx).pop(true),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: _C.darkGreen,
//                       foregroundColor: Colors.white,
//                       elevation: 0,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                     child: const Text('নিবন্ধন করুন',
//                         style: TextStyle(
//                             fontSize: 13, fontWeight: FontWeight.w700)),
//                   )),
//                 ]),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ).then((v) => v ?? false);
//   }

//   // ── register ───────────────────────────────────────────────────────────────

//   Future<void> _register() async {
//     if (_isRegistering) return;
//     if (!_validate()) return;
//     final confirmed = await _showConfirmDialog();
//     if (!confirmed) return;

//     setState(() => _isRegistering = true);
//     ref.read(authProvider.notifier).clearError();

//     final ok = await ref.read(authProvider.notifier).register(
//           name: _nameCtrl.text.trim(),
//           email: _emailCtrl.text.trim(),
//           password: _passCtrl.text,
//           district: _district!,
//           fullLocation: _fullAddress,
//           department: null,
//           designation: null,
//           phone: null,
//           photoUrl: null,
//           gender: _selectedGender,
//         );

//     if (ok) invalidateUserProviders(ref);
//     setState(() => _isRegistering = false);

//     if (ok && mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: const Text('নিবন্ধন সফল হয়েছে!'),
//         backgroundColor: _C.green,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ));
//       context.go(AppRoutes.home);
//     }
//   }

//   // ── build ──────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     final auth = ref.watch(authProvider);
//     final isLoading = _isRegistering;
//     final size = MediaQuery.of(context).size;

//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: _C.pageBg,
//         body: Stack(
//           children: [
//             // Header gradient
//             Positioned(
//               top: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 height: size.height * 0.35,
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [_C.darkGreen, _C.midGreen],
//                   ),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(32),
//                     bottomRight: Radius.circular(32),
//                   ),
//                 ),
//                 child: Stack(children: [
//                   Positioned(
//                       top: -40,
//                       right: -40,
//                       child: Container(
//                           width: 150,
//                           height: 150,
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.white.withOpacity(0.05)))),
//                   Positioned(
//                       bottom: -30,
//                       left: -30,
//                       child: Container(
//                           width: 100,
//                           height: 100,
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: _C.gold.withOpacity(0.08)))),
//                 ]),
//               ),
//             ),

//             SafeArea(
//               child: SingleChildScrollView(
//                 controller: _scrollCtrl,
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 keyboardDismissBehavior:
//                     ScrollViewKeyboardDismissBehavior.onDrag,
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 40),

//                     // Hero
//                     Column(children: [
//                       Container(
//                         width: 70,
//                         height: 70,
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(20),
//                           border:
//                               Border.all(color: Colors.white.withOpacity(0.25)),
//                         ),
//                         child: const Icon(Icons.person_add_rounded,
//                             color: Colors.white, size: 35),
//                       ).animate().scale(
//                           duration: 500.ms,
//                           curve: Curves.elasticOut,
//                           begin: const Offset(0.5, 0.5)),
//                       const SizedBox(height: 20),
//                       const Text('নতুন অ্যাকাউন্ট',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 28,
//                                   fontWeight: FontWeight.w800,
//                                   letterSpacing: -0.5))
//                           .animate(delay: 100.ms)
//                           .fadeIn()
//                           .slideY(begin: -0.1),
//                       const SizedBox(height: 6),
//                       Text('নিবন্ধন করে শুরু করুন',
//                               style: TextStyle(
//                                   color: Colors.white.withOpacity(0.75),
//                                   fontSize: 14))
//                           .animate(delay: 150.ms)
//                           .fadeIn(),
//                     ]),

//                     const SizedBox(height: 32),

//                     // Form card
//                     IgnorePointer(
//                       ignoring: isLoading,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: _C.cardBg,
//                           borderRadius: BorderRadius.circular(24),
//                           boxShadow: [
//                             BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 20,
//                                 offset: const Offset(0, 8))
//                           ],
//                         ),
//                         child: Column(children: [
//                           Padding(
//                             padding: const EdgeInsets.all(24),
//                             child: Column(children: [
//                               if (auth.error != null) ...[
//                                 _ErrorBanner(auth.error!),
//                                 const SizedBox(height: 20),
//                               ],

//                               // Name
//                               _Field(
//                                 label: 'পূর্ণ নাম',
//                                 icon: Icons.person_outline_rounded,
//                                 controller: _nameCtrl,
//                                 focusNode: _nameFocus,
//                                 hint: 'আপনার পূর্ণ নাম লিখুন',
//                                 error: _nameErr,
//                                 onChanged: _onNameChange,
//                                 onSubmit: () => _emailFocus.requestFocus(),
//                               )
//                                   .animate(delay: 200.ms)
//                                   .fadeIn()
//                                   .slideY(begin: 0.05),

//                               const SizedBox(height: 18),

//                               // Email
//                               _Field(
//                                 label: 'ইমেইল ঠিকানা',
//                                 icon: Icons.alternate_email_rounded,
//                                 controller: _emailCtrl,
//                                 focusNode: _emailFocus,
//                                 hint: 'example@email.com',
//                                 keyboardType: TextInputType.emailAddress,
//                                 error: _emailErr,
//                                 onChanged: _onEmailChange,
//                                 onSubmit: () =>
//                                     FocusScope.of(context).unfocus(),
//                               )
//                                   .animate(delay: 250.ms)
//                                   .fadeIn()
//                                   .slideY(begin: 0.05),

//                               const SizedBox(height: 18),

//                               // GPS District field
//                               _GpsDistrictField(
//                                 district: _district,
//                                 error: _districtErr,
//                                 isLocating: _isLocating,
//                                 onTap: _pickLocation,
//                                 onClear: () => setState(() {
//                                   _district = null;
//                                   _fullAddress = null;
//                                   if (_submitted)
//                                     _districtErr =
//                                         'GPS বাটন চেপে জেলা নির্ধারণ করুন';
//                                 }),
//                               )
//                                   .animate(delay: 280.ms)
//                                   .fadeIn()
//                                   .slideY(begin: 0.05),

//                               const SizedBox(height: 18),

//                               // Gender
//                               _GenderSelector(
//                                 selected: _selectedGender,
//                                 error: _genderErr,
//                                 onSelected: _onGenderSelected,
//                               )
//                                   .animate(delay: 300.ms)
//                                   .fadeIn()
//                                   .slideY(begin: 0.05),

//                               const SizedBox(height: 18),

//                               // Password
//                               _PasswordField(
//                                 label: 'পাসওয়ার্ড',
//                                 controller: _passCtrl,
//                                 focusNode: _passFocus,
//                                 hint: 'কমপক্ষে ৬ অক্ষর',
//                                 error: _passErr,
//                                 onChanged: _onPassChange,
//                                 onSubmit: () => _cfPassFocus.requestFocus(),
//                                 showStrengthBar: true,
//                               )
//                                   .animate(delay: 310.ms)
//                                   .fadeIn()
//                                   .slideY(begin: 0.05),

//                               const SizedBox(height: 18),

//                               // Confirm password
//                               _PasswordField(
//                                 label: 'পাসওয়ার্ড নিশ্চিত করুন',
//                                 controller: _cfPassCtrl,
//                                 focusNode: _cfPassFocus,
//                                 hint: 'পাসওয়ার্ড আবার লিখুন',
//                                 error: _cfPassErr,
//                                 onChanged: _onCfPassChange,
//                                 onSubmit: _register,
//                                 textInputAction: TextInputAction.done,
//                               )
//                                   .animate(delay: 350.ms)
//                                   .fadeIn()
//                                   .slideY(begin: 0.05),
//                             ]),
//                           ),

//                           // Register button
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
//                             child: _PrimaryButton(
//                               label: isLoading
//                                   ? 'নিবন্ধন হচ্ছে...'
//                                   : 'নিবন্ধন করুন',
//                               icon:
//                                   isLoading ? null : Icons.check_circle_rounded,
//                               onTap: isLoading ? null : _register,
//                               isLoading: isLoading,
//                             )
//                                 .animate(delay: 400.ms)
//                                 .fadeIn()
//                                 .slideY(begin: 0.05),
//                           ),
//                         ]),
//                       ),
//                     ).animate(delay: 180.ms).fadeIn().slideY(begin: 0.1),

//                     const SizedBox(height: 24),

//                     // Login link
//                     GestureDetector(
//                       onTap:
//                           isLoading ? null : () => context.go(AppRoutes.login),
//                       child: Opacity(
//                         opacity: isLoading ? 0.4 : 1.0,
//                         child: RichText(
//                             text: const TextSpan(
//                           text: 'ইতিমধ্যে অ্যাকাউন্ট আছে?  ',
//                           style:
//                               TextStyle(color: _C.textSecondary, fontSize: 14),
//                           children: [
//                             TextSpan(
//                                 text: 'লগইন করুন',
//                                 style: TextStyle(
//                                     color: _C.darkGreen,
//                                     fontWeight: FontWeight.w700))
//                           ],
//                         )),
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
// // GPS DISTRICT FIELD  — read-only, tap to detect, shows matched district
// // ─────────────────────────────────────────────────────────────────────────────

// class _GpsDistrictField extends StatelessWidget {
//   final String? district;
//   final String? error;
//   final bool isLocating;
//   final VoidCallback onTap;
//   final VoidCallback onClear;

//   const _GpsDistrictField({
//     required this.district,
//     required this.error,
//     required this.isLocating,
//     required this.onTap,
//     required this.onClear,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final hasErr = error != null && error!.isNotEmpty;
//     final hasDist = district != null && district!.isNotEmpty;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Label
//         Row(children: [
//           Text('জেলা',
//               style: TextStyle(
//                 color: hasErr ? _C.red : _C.textPrimary,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 13,
//               )),
//           const SizedBox(width: 3),
//           const Text('*',
//               style: TextStyle(
//                   color: _C.red, fontSize: 13, fontWeight: FontWeight.w800)),
//         ]),
//         const SizedBox(height: 8),

//         // Tap tile
//         GestureDetector(
//           onTap: isLocating ? null : onTap,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 220),
//             curve: Curves.easeOutCubic,
//             height: 58,
//             decoration: BoxDecoration(
//               color: hasErr
//                   ? _C.red.withOpacity(0.04)
//                   : hasDist
//                       ? _C.greenLight
//                       : _C.surfaceAlt,
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(
//                 color: hasErr
//                     ? _C.red.withOpacity(0.6)
//                     : hasDist
//                         ? _C.darkGreen
//                         : _C.border,
//                 width: hasDist ? 1.5 : 1.0,
//               ),
//               boxShadow: hasDist && !hasErr
//                   ? [
//                       BoxShadow(
//                           color: _C.darkGreen.withOpacity(0.10),
//                           blurRadius: 10,
//                           offset: const Offset(0, 3))
//                     ]
//                   : [],
//             ),
//             child: Row(children: [
//               const SizedBox(width: 16),

//               // Left icon / spinner
//               AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 250),
//                 child: isLocating
//                     ? const SizedBox(
//                         key: ValueKey('spin'),
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                             strokeWidth: 2.2, color: _C.darkGreen))
//                     : Icon(
//                         key: ValueKey(hasDist),
//                         hasDist
//                             ? Icons.gps_fixed_rounded
//                             : Icons.my_location_rounded,
//                         size: 20,
//                         color: hasErr
//                             ? _C.red
//                             : hasDist
//                                 ? _C.darkGreen
//                                 : _C.textSecondary),
//               ),

//               const SizedBox(width: 12),

//               // Text
//               Expanded(
//                 child: AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 200),
//                   child: isLocating
//                       ? Text(
//                           key: const ValueKey('locating'),
//                           'লোকেশন খোঁজা হচ্ছে...',
//                           style: TextStyle(
//                               color: _C.darkGreen.withOpacity(0.7),
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500))
//                       : hasDist
//                           ? Text(
//                               key: ValueKey(district),
//                               district!,
//                               style: const TextStyle(
//                                   color: _C.darkGreen,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w700))
//                           : Text(
//                               key: const ValueKey('hint'),
//                               'GPS দিয়ে জেলা নির্ধারণ করুন',
//                               style: TextStyle(
//                                   color: hasErr
//                                       ? _C.red.withOpacity(0.8)
//                                       : _C.textHint,
//                                   fontSize: 14)),
//                 ),
//               ),

//               // Right action
//               if (!isLocating)
//                 hasDist
//                     // পরিবর্তন button — re-detect
//                     ? GestureDetector(
//                         onTap: onClear,
//                         behavior: HitTestBehavior.opaque,
//                         child: Padding(
//                           padding: const EdgeInsets.only(right: 12),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: _C.darkGreen.withOpacity(0.10),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child:
//                                 Row(mainAxisSize: MainAxisSize.min, children: [
//                               Icon(Icons.refresh_rounded,
//                                   size: 12,
//                                   color: _C.darkGreen.withOpacity(0.75)),
//                               const SizedBox(width: 4),
//                               Text('পরিবর্তন',
//                                   style: TextStyle(
//                                       fontSize: 11,
//                                       fontWeight: FontWeight.w700,
//                                       color: _C.darkGreen.withOpacity(0.85))),
//                             ]),
//                           ),
//                         ),
//                       )
//                     // GPS pill badge
//                     : Padding(
//                         padding: const EdgeInsets.only(right: 14),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 5),
//                           decoration: BoxDecoration(
//                             color: hasErr ? _C.red : _C.darkGreen,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: const Text('GPS',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w800,
//                                   letterSpacing: 0.5)),
//                         ),
//                       )
//               else
//                 const SizedBox(width: 14),
//             ]),
//           ),
//         ),

//         // Sub-hint / error
//         AnimatedSize(
//           duration: const Duration(milliseconds: 200),
//           curve: Curves.easeOutCubic,
//           child: hasErr
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 6, left: 4),
//                   child: Row(children: [
//                     const Icon(Icons.error_rounded, size: 13, color: _C.red),
//                     const SizedBox(width: 6),
//                     Expanded(
//                         child: Text(error!,
//                             style: const TextStyle(
//                                 color: _C.red,
//                                 fontSize: 11.5,
//                                 fontWeight: FontWeight.w500))),
//                   ]),
//                 )
//               : hasDist
//                   ? Padding(
//                       padding: const EdgeInsets.only(top: 6, left: 4),
//                       child: Row(children: [
//                         const Icon(Icons.gps_fixed_rounded,
//                             size: 11, color: _C.green),
//                         const SizedBox(width: 5),
//                         const Text('GPS থেকে নির্ধারিত — পরিবর্তন করতে ↺ চাপুন',
//                             style: TextStyle(
//                                 color: _C.green,
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w500)),
//                       ]),
//                     )
//                   : const SizedBox.shrink(),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // GENDER SELECTOR
// // ─────────────────────────────────────────────────────────────────────────────

// class _GenderSelector extends StatelessWidget {
//   final String? selected;
//   final String? error;
//   final void Function(String?) onSelected;
//   const _GenderSelector(
//       {required this.selected, required this.error, required this.onSelected});

//   @override
//   Widget build(BuildContext context) {
//     final hasErr = error != null && error!.isNotEmpty;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('লিঙ্গ',
//             style: TextStyle(
//                 color: hasErr ? _C.red : _C.textPrimary,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 13)),
//         const SizedBox(height: 8),
//         Row(
//             children: List.generate(_genders.length, (i) {
//           final opt = _genders[i];
//           final sel = selected == opt.value;
//           return Expanded(
//             child: Padding(
//               padding: EdgeInsets.only(right: i < _genders.length - 1 ? 8 : 0),
//               child: GestureDetector(
//                 onTap: () => onSelected(sel ? null : opt.value),
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 180),
//                   height: 54,
//                   decoration: BoxDecoration(
//                     color: sel
//                         ? _C.greenLight
//                         : hasErr
//                             ? _C.red.withOpacity(0.04)
//                             : _C.surfaceAlt,
//                     borderRadius: BorderRadius.circular(14),
//                     border: Border.all(
//                       color: sel
//                           ? _C.darkGreen
//                           : hasErr
//                               ? _C.red.withOpacity(0.5)
//                               : _C.border,
//                       width: sel ? 1.5 : 1.0,
//                     ),
//                     boxShadow: sel
//                         ? [
//                             BoxShadow(
//                                 color: _C.darkGreen.withOpacity(0.08),
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 3))
//                           ]
//                         : [],
//                   ),
//                   child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(opt.icon,
//                             size: 20,
//                             color: sel
//                                 ? _C.darkGreen
//                                 : hasErr
//                                     ? _C.red
//                                     : _C.textSecondary),
//                         const SizedBox(height: 3),
//                         Text(opt.label,
//                             style: TextStyle(
//                                 fontSize: 11.5,
//                                 fontWeight:
//                                     sel ? FontWeight.w700 : FontWeight.w500,
//                                 color: sel
//                                     ? _C.darkGreen
//                                     : hasErr
//                                         ? _C.red
//                                         : _C.textSecondary)),
//                       ]),
//                 ),
//               ),
//             ),
//           );
//         })),
//         AnimatedSize(
//           duration: const Duration(milliseconds: 180),
//           child: hasErr
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 6, left: 4),
//                   child: Row(children: [
//                     const Icon(Icons.error_rounded, size: 13, color: _C.red),
//                     const SizedBox(width: 6),
//                     Text(error!,
//                         style: const TextStyle(
//                             color: _C.red,
//                             fontSize: 11.5,
//                             fontWeight: FontWeight.w500)),
//                   ]))
//               : const SizedBox.shrink(),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DIALOG ROW
// // ─────────────────────────────────────────────────────────────────────────────

// class _DRow extends StatelessWidget {
//   final IconData icon;
//   final Color iconColor, bg;
//   final String text;
//   const _DRow(
//       {required this.icon,
//       required this.iconColor,
//       required this.bg,
//       required this.text});
//   @override
//   Widget build(BuildContext context) => Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
//         decoration:
//             BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
//         child: Row(children: [
//           Icon(icon, size: 16, color: iconColor),
//           const SizedBox(width: 9),
//           Expanded(
//               child: Text(text,
//                   style: const TextStyle(
//                       fontSize: 12.5,
//                       fontWeight: FontWeight.w500,
//                       color: _C.textPrimary,
//                       height: 1.35))),
//         ]),
//       );
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
//   late final VoidCallback _fl;
//   @override
//   void initState() {
//     super.initState();
//     _fl = () {
//       if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
//     };
//     widget.focusNode.addListener(_fl);
//   }

//   @override
//   void dispose() {
//     widget.focusNode.removeListener(_fl);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hasErr = widget.error != null && widget.error!.isNotEmpty;
//     final ic = hasErr
//         ? _C.red
//         : _focused
//             ? _C.darkGreen
//             : _C.textSecondary;
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Text(widget.label,
//           style: TextStyle(
//               color: hasErr
//                   ? _C.red
//                   : _focused
//                       ? _C.darkGreen
//                       : _C.textPrimary,
//               fontWeight: FontWeight.w600,
//               fontSize: 13)),
//       const SizedBox(height: 8),
//       AnimatedContainer(
//         duration: const Duration(milliseconds: 180),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: _focused && !hasErr
//               ? [
//                   BoxShadow(
//                       color: _C.darkGreen.withOpacity(0.08),
//                       blurRadius: 12,
//                       offset: const Offset(0, 4))
//                 ]
//               : [],
//         ),
//         child: TextField(
//           controller: widget.controller,
//           focusNode: widget.focusNode,
//           keyboardType: widget.keyboardType,
//           textInputAction: widget.textInputAction,
//           onChanged: widget.onChanged,
//           onEditingComplete: widget.onSubmit,
//           onSubmitted: (_) => widget.onSubmit(),
//           style: const TextStyle(
//               color: _C.textPrimary, fontWeight: FontWeight.w500, fontSize: 15),
//           decoration: InputDecoration(
//             hintText: widget.hint,
//             hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
//             prefixIcon: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Icon(widget.icon, size: 20, color: ic)),
//             prefixIconConstraints: const BoxConstraints(minWidth: 54),
//             filled: true,
//             fillColor: hasErr
//                 ? _C.red.withOpacity(0.04)
//                 : _focused
//                     ? _C.cardBg
//                     : _C.surfaceAlt,
//             border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: const BorderSide(color: _C.border)),
//             enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                     color: hasErr ? _C.red.withOpacity(0.5) : _C.border)),
//             focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                     color: hasErr ? _C.red : _C.darkGreen, width: 1.5)),
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           ),
//         ),
//       ),
//       AnimatedSize(
//         duration: const Duration(milliseconds: 180),
//         child: hasErr
//             ? Padding(
//                 padding: const EdgeInsets.only(top: 6, left: 4),
//                 child: Row(children: [
//                   const Icon(Icons.error_rounded, size: 13, color: _C.red),
//                   const SizedBox(width: 6),
//                   Text(widget.error!,
//                       style: const TextStyle(
//                           color: _C.red,
//                           fontSize: 11.5,
//                           fontWeight: FontWeight.w500)),
//                 ]))
//             : const SizedBox.shrink(),
//       ),
//     ]);
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
//   final bool showStrengthBar;

//   const _PasswordField({
//     required this.label,
//     required this.controller,
//     required this.focusNode,
//     required this.hint,
//     this.error,
//     this.textInputAction = TextInputAction.next,
//     required this.onChanged,
//     required this.onSubmit,
//     this.showStrengthBar = false,
//   });
//   @override
//   State<_PasswordField> createState() => _PasswordFieldState();
// }

// class _PasswordFieldState extends State<_PasswordField> {
//   bool _focused = false, _obscure = true;
//   late final VoidCallback _fl;
//   @override
//   void initState() {
//     super.initState();
//     _fl = () {
//       if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
//     };
//     widget.focusNode.addListener(_fl);
//   }

//   @override
//   void dispose() {
//     widget.focusNode.removeListener(_fl);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hasErr = widget.error != null && widget.error!.isNotEmpty;
//     final ic = hasErr
//         ? _C.red
//         : _focused
//             ? _C.darkGreen
//             : _C.textSecondary;
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Text(widget.label,
//           style: TextStyle(
//               color: hasErr
//                   ? _C.red
//                   : _focused
//                       ? _C.darkGreen
//                       : _C.textPrimary,
//               fontWeight: FontWeight.w600,
//               fontSize: 13)),
//       const SizedBox(height: 8),
//       AnimatedContainer(
//         duration: const Duration(milliseconds: 180),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: _focused && !hasErr
//               ? [
//                   BoxShadow(
//                       color: _C.darkGreen.withOpacity(0.08),
//                       blurRadius: 12,
//                       offset: const Offset(0, 4))
//                 ]
//               : [],
//         ),
//         child: TextField(
//           controller: widget.controller,
//           focusNode: widget.focusNode,
//           obscureText: _obscure,
//           textInputAction: widget.textInputAction,
//           onChanged: widget.onChanged,
//           onEditingComplete: widget.onSubmit,
//           onSubmitted: (_) => widget.onSubmit(),
//           style: const TextStyle(
//               color: _C.textPrimary, fontWeight: FontWeight.w500, fontSize: 15),
//           decoration: InputDecoration(
//             hintText: widget.hint,
//             hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
//             prefixIcon: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Icon(Icons.lock_outline_rounded, size: 20, color: ic)),
//             prefixIconConstraints: const BoxConstraints(minWidth: 54),
//             suffixIcon: GestureDetector(
//               onTap: () => setState(() => _obscure = !_obscure),
//               child: Padding(
//                   padding: const EdgeInsets.only(right: 16),
//                   child: Icon(
//                       _obscure
//                           ? Icons.visibility_outlined
//                           : Icons.visibility_off_outlined,
//                       size: 20,
//                       color: _focused ? _C.darkGreen : _C.textSecondary)),
//             ),
//             suffixIconConstraints: const BoxConstraints(minWidth: 50),
//             filled: true,
//             fillColor: hasErr
//                 ? _C.red.withOpacity(0.04)
//                 : _focused
//                     ? _C.cardBg
//                     : _C.surfaceAlt,
//             border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: const BorderSide(color: _C.border)),
//             enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                     color: hasErr ? _C.red.withOpacity(0.5) : _C.border)),
//             focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide(
//                     color: hasErr ? _C.red : _C.darkGreen, width: 1.5)),
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           ),
//         ),
//       ),
//       AnimatedSize(
//         duration: const Duration(milliseconds: 180),
//         child: hasErr
//             ? Padding(
//                 padding: const EdgeInsets.only(top: 6, left: 4),
//                 child: Row(children: [
//                   const Icon(Icons.error_rounded, size: 13, color: _C.red),
//                   const SizedBox(width: 6),
//                   Text(widget.error!,
//                       style: const TextStyle(
//                           color: _C.red,
//                           fontSize: 11.5,
//                           fontWeight: FontWeight.w500)),
//                 ]))
//             : const SizedBox.shrink(),
//       ),
//       if (widget.showStrengthBar && widget.controller.text.isNotEmpty) ...[
//         const SizedBox(height: 10),
//         _StrengthBar(password: widget.controller.text),
//       ],
//     ]);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // STRENGTH BAR
// // ─────────────────────────────────────────────────────────────────────────────

// class _StrengthBar extends StatelessWidget {
//   final String password;
//   const _StrengthBar({required this.password});
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
//     return Row(children: [
//       Expanded(
//           child: ClipRRect(
//               borderRadius: BorderRadius.circular(99),
//               child: LinearProgressIndicator(
//                   value: s / 5,
//                   minHeight: 4,
//                   backgroundColor: _C.border,
//                   valueColor: AlwaysStoppedAnimation(color)))),
//       const SizedBox(width: 12),
//       Text(label,
//           style: TextStyle(
//               fontSize: 11, fontWeight: FontWeight.w700, color: color)),
//     ]);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // ERROR BANNER
// // ─────────────────────────────────────────────────────────────────────────────

// class _ErrorBanner extends StatelessWidget {
//   final String message;
//   const _ErrorBanner(this.message);
//   @override
//   Widget build(BuildContext context) => Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         decoration: BoxDecoration(
//             color: _C.redLight,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: _C.red.withOpacity(0.25))),
//         child: Row(children: [
//           const Icon(Icons.error_outline_rounded, color: _C.red, size: 18),
//           const SizedBox(width: 10),
//           Expanded(
//               child: Text(message,
//                   style: const TextStyle(
//                       color: _C.red,
//                       fontSize: 12.5,
//                       fontWeight: FontWeight.w500))),
//         ]),
//       );
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PRIMARY BUTTON
// // ─────────────────────────────────────────────────────────────────────────────

// class _PrimaryButton extends StatelessWidget {
//   final String label;
//   final IconData? icon;
//   final VoidCallback? onTap;
//   final bool isLoading;
//   const _PrimaryButton(
//       {required this.label, this.icon, this.onTap, this.isLoading = false});

//   @override
//   Widget build(BuildContext context) {
//     final enabled = onTap != null && !isLoading;
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 180),
//       height: 54,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: enabled ? _C.darkGreen : _C.borderMid,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: enabled
//             ? [
//                 BoxShadow(
//                     color: _C.darkGreen.withOpacity(0.3),
//                     blurRadius: 12,
//                     offset: const Offset(0, 6))
//               ]
//             : [],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: Center(
//               child: isLoading
//                   ? const SizedBox(
//                       width: 24,
//                       height: 24,
//                       child: CircularProgressIndicator(
//                           strokeWidth: 2.5, color: Colors.white))
//                   : Row(mainAxisSize: MainAxisSize.min, children: [
//                       if (icon != null) ...[
//                         Icon(icon, color: Colors.white, size: 20),
//                         const SizedBox(width: 10)
//                       ],
//                       Text(label,
//                           style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 16,
//                               letterSpacing: -0.2)),
//                     ])),
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
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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
// DISTRICT MAPPING
// ─────────────────────────────────────────────────────────────────────────────

const Map<String, String> _englishToBangla = {
  'dhaka': 'ঢাকা',
  'chittagong': 'চট্টগ্রাম',
  'chattogram': 'চট্টগ্রাম',
  'rajshahi': 'রাজশাহী',
  'khulna': 'খুলনা',
  'barisal': 'বরিশাল',
  'barishal': 'বরিশাল',
  'sylhet': 'সিলেট',
  'rangpur': 'রংপুর',
  'mymensingh': 'ময়মনসিংহ',
  'faridpur': 'ফরিদপুর',
  'gazipur': 'গাজীপুর',
  'narayanganj': 'নারায়ণগঞ্জ',
  'comilla': 'কুমিল্লা',
  'cumilla': 'কুমিল্লা',
  'brahmanbaria': 'ব্রাহ্মণবাড়িয়া',
  'chandpur': 'চাঁদপুর',
  'lakshmipur': 'লক্ষ্মীপুর',
  'noakhali': 'নোয়াখালী',
  'feni': 'ফেনী',
  "cox's bazar": 'কক্সবাজার',
  'coxs bazar': 'কক্সবাজার',
  'cox bazar': 'কক্সবাজার',
  'bandarban': 'বান্দরবান',
  'rangamati': 'রাঙ্গামাটি',
  'khagrachhari': 'খাগড়াছড়ি',
  'moulvibazar': 'মৌলভীবাজার',
  'habiganj': 'হবিগঞ্জ',
  'sunamganj': 'সুনামগঞ্জ',
  'netrokona': 'নেত্রকোণা',
  'kishoreganj': 'কিশোরগঞ্জ',
  'manikganj': 'মানিকগঞ্জ',
  'munshiganj': 'মুন্সীগঞ্জ',
  'tangail': 'টাঙ্গাইল',
  'narsingdi': 'নরসিংদী',
  'shariatpur': 'শরীয়তপুর',
  'madaripur': 'মাদারীপুর',
  'gopalganj': 'গোপালগঞ্জ',
  'jhalokati': 'ঝালকাঠি',
  'pirojpur': 'পিরোজপুর',
  'barguna': 'বরগুনা',
  'patuakhali': 'পটুয়াখালী',
  'bhola': 'ভোলা',
  'natore': 'নাটোর',
  'pabna': 'পাবনা',
  'sirajganj': 'সিরাজগঞ্জ',
  'bogura': 'বগুড়া',
  'bogra': 'বগুড়া',
  'joypurhat': 'জয়পুরহাট',
  'chapainawabganj': 'চাঁপাইনবাবগঞ্জ',
  'naogaon': 'নওগাঁ',
  'dinajpur': 'দিনাজপুর',
  'lalmonirhat': 'লালমনিরহাট',
  'nilphamari': 'নীলফামারী',
  'panchagarh': 'পঞ্চগড়',
  'thakurgaon': 'ঠাকুরগাঁও',
  'kurigram': 'কুড়িগ্রাম',
  'gaibandha': 'গাইবান্ধা',
  'jashore': 'যশোর',
  'jessore': 'যশোর',
  'jhenaidah': 'ঝিনাইদহ',
  'magura': 'মাগুরা',
  'narail': 'নড়াইল',
  'bagerhat': 'বাগেরহাট',
  'satkhira': 'সাতক্ষীরা',
  'kushtia': 'কুষ্টিয়া',
  'meherpur': 'মেহেরপুর',
  'chuadanga': 'চুয়াডাঙ্গা',
};

String? _matchBangla(String candidate) {
  final n = candidate.toLowerCase().trim();
  if (n.isEmpty) return null;
  if (_englishToBangla.containsKey(n)) return _englishToBangla[n];
  for (final e in _englishToBangla.entries) {
    if (n.contains(e.key)) return e.value;
  }
  return null;
}

// ─────────────────────────────────────────────────────────────────────────────
// GENDER
// ─────────────────────────────────────────────────────────────────────────────

class _G {
  final String value, label;
  final IconData icon;
  const _G(this.value, this.label, this.icon);
}

const _genders = [
  _G('male', 'পুরুষ', Icons.man_rounded),
  _G('female', 'মহিলা', Icons.woman_rounded),
  _G('other', 'অন্যান্য', Icons.people_alt_rounded),
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
  final _scrollCtrl = ScrollController();

  bool _submitted = false;
  bool _isRegistering = false;
  bool _isLocating = false;

  // GPS — only these two matter now
  String? _district; // value sent to backend (Bangla or raw foreign)
  String? _fullAddress; // stored internally, NOT shown to user

  String? _selectedGender;
  String? _nameErr, _emailErr, _passErr, _cfPassErr, _districtErr, _genderErr;

  // ── init ───────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    for (final n in [_nameFocus, _emailFocus, _passFocus, _cfPassFocus]) {
      n.addListener(() {
        if (n.hasFocus) _ensureVisible(n);
      });
    }
  }

  void _ensureVisible(FocusNode node) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      final ctx = node.context;
      if (ctx == null) return;
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          alignment: 0.25);
    });
  }

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
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── GPS ────────────────────────────────────────────────────────────────────

  Future<void> _pickLocation() async {
    if (_isLocating) return;
    setState(() => _isLocating = true);
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        _toast('লোকেশন অনুমতি দিন', err: true);
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 12),
      );

      final marks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (marks.isEmpty) {
        _toast('লোকেশন পাওয়া যায়নি', err: true);
        return;
      }

      final p = marks.first;
      final isBD = (p.country ?? '').toLowerCase().contains('bangladesh') ||
          (p.isoCountryCode ?? '').toUpperCase() == 'BD';

      // Full address — stored internally only
      final full = [
        p.street,
        p.subLocality,
        p.locality,
        p.subAdministrativeArea,
        p.administrativeArea,
        p.country
      ]
          .where((s) => s != null && s.trim().isNotEmpty)
          .map((s) => s!.trim())
          .join(', ');

      String? district;

      if (isBD) {
        for (final c in [
          p.subAdministrativeArea ?? '',
          p.locality ?? '',
          p.administrativeArea ?? '',
        ]) {
          district = _matchBangla(c);
          if (district != null) break;
        }
        if (district == null)
          _toast('জেলা চেনা যায়নি, আবার চেষ্টা করুন', err: true);
      } else {
        // foreign — use raw name
        district = p.subAdministrativeArea?.trim().isNotEmpty == true
            ? p.subAdministrativeArea!.trim()
            : p.locality?.trim().isNotEmpty == true
                ? p.locality!.trim()
                : p.administrativeArea?.trim();
        if (district != null) _toast('বিদেশি লোকেশন সেট হয়েছে');
      }

      setState(() {
        _fullAddress = full;
        if (district != null) {
          _district = district;
          if (_submitted) _districtErr = null;
        }
      });
    } catch (_) {
      _toast('লোকেশন নিতে সমস্যা হয়েছে', err: true);
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _toast(String msg, {bool err = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: err ? _C.red : _C.amber,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    ));
  }

  // ── validators ─────────────────────────────────────────────────────────────

  void _onNameChange(String v) {
    if (!_submitted) return;
    setState(() =>
        _nameErr = v.trim().length < 2 ? 'নাম কমপক্ষে ২ অক্ষর হতে হবে' : null);
  }

  void _onEmailChange(String v) {
    if (!_submitted) return;
    setState(() {
      _emailErr = v.trim().isEmpty
          ? 'ইমেইল দিন'
          : !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())
              ? 'সঠিক ইমেইল ঠিকানা দিন'
              : null;
    });
  }

  void _onPassChange(String v) {
    if (!_submitted) return;
    setState(() {
      _passErr = v.isEmpty
          ? 'পাসওয়ার্ড দিন'
          : v.length < 6
              ? 'কমপক্ষে ৬ অক্ষর হতে হবে'
              : null;
      if (_cfPassCtrl.text.isNotEmpty) {
        _cfPassErr = _cfPassCtrl.text != v ? 'পাসওয়ার্ড মিলছে না' : null;
      }
    });
  }

  void _onCfPassChange(String v) {
    if (!_submitted) return;
    setState(
        () => _cfPassErr = v != _passCtrl.text ? 'পাসওয়ার্ড মিলছে না' : null);
  }

  void _onGenderSelected(String? g) {
    setState(() {
      _selectedGender = g;
      if (_submitted)
        _genderErr = (g == null || g.isEmpty) ? 'লিঙ্গ নির্বাচন করুন' : null;
    });
  }

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
      _districtErr = (_district == null || _district!.isEmpty)
          ? 'GPS বাটন চেপে জেলা নির্ধারণ করুন'
          : null;
      _genderErr = (_selectedGender == null || _selectedGender!.isEmpty)
          ? 'লিঙ্গ নির্বাচন করুন'
          : null;
    });
    return _nameErr == null &&
        _emailErr == null &&
        _passErr == null &&
        _cfPassErr == null &&
        _districtErr == null &&
        _genderErr == null;
  }

  // ── confirmation dialog ────────────────────────────────────────────────────

  Future<bool> _showConfirmDialog() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Container(
          decoration: BoxDecoration(
              color: _C.cardBg, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                child: Row(children: [
                  Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                          color: _C.amberLight,
                          borderRadius: BorderRadius.circular(9)),
                      child: const Icon(Icons.info_outline_rounded,
                          color: _C.amber, size: 18)),
                  const SizedBox(width: 10),
                  const Expanded(
                      child: Text('নিবন্ধনের আগে জানুন',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: _C.textPrimary))),
                ]),
              ),
              const Divider(height: 1, color: _C.border),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
                child: Column(children: const [
                  _DRow(
                      icon: Icons.lock_reset_rounded,
                      iconColor: _C.amber,
                      bg: _C.amberLight,
                      text: 'পাসওয়ার্ড রিসেট এখনো নেই — লিখে রাখুন'),
                  SizedBox(height: 8),
                  _DRow(
                      icon: Icons.shield_outlined,
                      iconColor: _C.green,
                      bg: _C.greenLight,
                      text: 'পাসওয়ার্ড শুধু আপনার — কাউকে জানাবেন না'),
                  SizedBox(height: 8),
                  _DRow(
                      icon: Icons.alternate_email_rounded,
                      iconColor: _C.red,
                      bg: _C.redLight,
                      text: 'সঠিক ইমেইল দিন — লগইনে দরকার হবে'),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                child: Row(children: [
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
                  )),
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
                  )),
                ]),
              ),
            ],
          ),
        ),
      ),
    ).then((v) => v ?? false);
  }

  // ── register ───────────────────────────────────────────────────────────────

  Future<void> _register() async {
    if (_isRegistering) return;
    if (!_validate()) return;
    final confirmed = await _showConfirmDialog();
    if (!confirmed) return;

    setState(() => _isRegistering = true);
    ref.read(authProvider.notifier).clearError();

    final ok = await ref.read(authProvider.notifier).register(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
          district: _district!,
          fullLocation: _fullAddress,
          department: null,
          designation: null,
          phone: null,
          photoUrl: null,
          gender: _selectedGender,
        );

    if (ok) invalidateUserProviders(ref);
    setState(() => _isRegistering = false);

    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('নিবন্ধন সফল হয়েছে!'),
        backgroundColor: _C.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      context.go(AppRoutes.home);
    }
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final isLoading = _isRegistering;
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _C.pageBg,
        body: Stack(
          children: [
            // Header gradient
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
                child: Stack(children: [
                  Positioned(
                      top: -40,
                      right: -40,
                      child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.05)))),
                  Positioned(
                      bottom: -30,
                      left: -30,
                      child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _C.gold.withOpacity(0.08)))),
                ]),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                controller: _scrollCtrl,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Hero
                    Column(children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: const Icon(Icons.person_add_rounded,
                            color: Colors.white, size: 35),
                      ).animate().scale(
                          duration: 500.ms,
                          curve: Curves.elasticOut,
                          begin: const Offset(0.5, 0.5)),
                      const SizedBox(height: 20),
                      const Text('নতুন অ্যাকাউন্ট',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5))
                          .animate(delay: 100.ms)
                          .fadeIn()
                          .slideY(begin: -0.1),
                      const SizedBox(height: 6),
                      Text('নিবন্ধন করে শুরু করুন',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.75),
                                  fontSize: 14))
                          .animate(delay: 150.ms)
                          .fadeIn(),
                    ]),

                    const SizedBox(height: 32),

                    // Form card
                    IgnorePointer(
                      ignoring: isLoading,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _C.cardBg,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 8))
                          ],
                        ),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(children: [
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
                                onSubmit: () => _emailFocus.requestFocus(),
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

                              // GPS District field
                              _GpsDistrictField(
                                district: _district,
                                error: _districtErr,
                                isLocating: _isLocating,
                                onTap: _pickLocation,
                                onClear: () => setState(() {
                                  _district = null;
                                  _fullAddress = null;
                                  if (_submitted)
                                    _districtErr =
                                        'GPS বাটন চেপে জেলা নির্ধারণ করুন';
                                }),
                              )
                                  .animate(delay: 280.ms)
                                  .fadeIn()
                                  .slideY(begin: 0.05),

                              const SizedBox(height: 18),

                              // Gender
                              _GenderSelector(
                                selected: _selectedGender,
                                error: _genderErr,
                                onSelected: _onGenderSelected,
                              )
                                  .animate(delay: 300.ms)
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
                                onSubmit: () => _cfPassFocus.requestFocus(),
                                showStrengthBar: true,
                              )
                                  .animate(delay: 310.ms)
                                  .fadeIn()
                                  .slideY(begin: 0.05),

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
                            ]),
                          ),

                          // Register button
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: _PrimaryButton(
                              label: isLoading
                                  ? 'নিবন্ধন হচ্ছে...'
                                  : 'নিবন্ধন করুন',
                              icon:
                                  isLoading ? null : Icons.check_circle_rounded,
                              onTap: isLoading ? null : _register,
                              isLoading: isLoading,
                            )
                                .animate(delay: 400.ms)
                                .fadeIn()
                                .slideY(begin: 0.05),
                          ),
                        ]),
                      ),
                    ).animate(delay: 180.ms).fadeIn().slideY(begin: 0.1),

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
                          style:
                              TextStyle(color: _C.textSecondary, fontSize: 14),
                          children: [
                            TextSpan(
                                text: 'লগইন করুন',
                                style: TextStyle(
                                    color: _C.darkGreen,
                                    fontWeight: FontWeight.w700))
                          ],
                        )),
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
// GPS DISTRICT FIELD  — read-only, tap to detect, shows matched district
// ─────────────────────────────────────────────────────────────────────────────

class _GpsDistrictField extends StatelessWidget {
  final String? district;
  final String? error;
  final bool isLocating;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _GpsDistrictField({
    required this.district,
    required this.error,
    required this.isLocating,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasErr = error != null && error!.isNotEmpty;
    final hasDist = district != null && district!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(children: [
          Text('লোকেশন',
              style: TextStyle(
                color: hasErr ? _C.red : _C.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              )),
          const SizedBox(width: 3),
          const Text('*',
              style: TextStyle(
                  color: _C.red, fontSize: 13, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 8),

        // Tap tile
        GestureDetector(
          onTap: isLocating ? null : onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            height: 54,
            decoration: BoxDecoration(
              color: hasErr
                  ? _C.red.withOpacity(0.04)
                  : hasDist
                      ? _C.greenLight
                      : _C.surfaceAlt,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasErr
                    ? _C.red.withOpacity(0.6)
                    : hasDist
                        ? _C.darkGreen
                        : _C.border,
                width: hasDist ? 1.5 : 1.0,
              ),
              boxShadow: hasDist && !hasErr
                  ? [
                      BoxShadow(
                          color: _C.darkGreen.withOpacity(0.10),
                          blurRadius: 10,
                          offset: const Offset(0, 3))
                    ]
                  : [],
            ),
            child: Row(children: [
              const SizedBox(width: 16),

              // Left icon / spinner
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                // alignment: Alignment.centerLeft,

                child: isLocating
                    ? const SizedBox(
                        key: ValueKey('spin'),
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.2, color: _C.darkGreen))
                    : Icon(
                        key: ValueKey(hasDist),
                        hasDist
                            ? Icons.gps_fixed_rounded
                            : Icons.my_location_rounded,
                        size: 20,
                        color: hasErr
                            ? _C.red
                            : hasDist
                                ? _C.darkGreen
                                : _C.textSecondary),
              ),

              const SizedBox(width: 12),

              // Text
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  // alignment: Alignment.centerLeft,
                  child: isLocating
                      ? SizedBox(
                          key: const ValueKey('locating'),
                          width: double.infinity,
                          child: Text('লোকেশন খোঁজা হচ্ছে...',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: _C.darkGreen.withOpacity(0.7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)))
                      : hasDist
                          ? SizedBox(
                              key: const ValueKey('dist'),
                              width: double.infinity,
                              child: Text(district!,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: _C.darkGreen,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)))
                          : SizedBox(
                              key: const ValueKey('hint'),
                              width: double.infinity,
                              child: Text('GPS দিয়ে জেলা নির্ধারণ করুন',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: hasErr
                                          ? _C.red.withOpacity(0.8)
                                          : _C.textHint,
                                      fontSize: 14))),
                ),
              ),

              // Right action
              if (!isLocating)
                hasDist
                    // পরিবর্তন button — re-detect
                    ? GestureDetector(
                        onTap: onClear,
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: _C.darkGreen.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(Icons.refresh_rounded,
                                  size: 12,
                                  color: _C.darkGreen.withOpacity(0.75)),
                              const SizedBox(width: 4),
                              Text('পরিবর্তন',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: _C.darkGreen.withOpacity(0.85))),
                            ]),
                          ),
                        ),
                      )
                    // GPS pill badge
                    : Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: hasErr ? _C.red : _C.darkGreen,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('GPS',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5)),
                        ),
                      )
              else
                const SizedBox(width: 14),
            ]),
          ),
        ),

        // Sub-hint / error
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: hasErr
              ? Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Row(children: [
                    const Icon(Icons.error_rounded, size: 13, color: _C.red),
                    const SizedBox(width: 6),
                    Expanded(
                        child: Text(error!,
                            style: const TextStyle(
                                color: _C.red,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500))),
                  ]),
                )
              : hasDist
                  ? Padding(
                      padding: const EdgeInsets.only(top: 6, left: 4),
                      child: Row(children: [
                        const Icon(Icons.gps_fixed_rounded,
                            size: 11, color: _C.green),
                        const SizedBox(width: 5),
                        const Text('GPS থেকে নির্ধারিত — পরিবর্তন করতে ↺ চাপুন',
                            style: TextStyle(
                                color: _C.green,
                                fontSize: 11,
                                fontWeight: FontWeight.w500)),
                      ]),
                    )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GENDER SELECTOR
// ─────────────────────────────────────────────────────────────────────────────

class _GenderSelector extends StatelessWidget {
  final String? selected;
  final String? error;
  final void Function(String?) onSelected;
  const _GenderSelector(
      {required this.selected, required this.error, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final hasErr = error != null && error!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('লিঙ্গ',
            style: TextStyle(
                color: hasErr ? _C.red : _C.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13)),
        const SizedBox(height: 8),
        Row(
            children: List.generate(_genders.length, (i) {
          final opt = _genders[i];
          final sel = selected == opt.value;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < _genders.length - 1 ? 8 : 0),
              child: GestureDetector(
                onTap: () => onSelected(sel ? null : opt.value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 54,
                  decoration: BoxDecoration(
                    color: sel
                        ? _C.greenLight
                        : hasErr
                            ? _C.red.withOpacity(0.04)
                            : _C.surfaceAlt,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: sel
                          ? _C.darkGreen
                          : hasErr
                              ? _C.red.withOpacity(0.5)
                              : _C.border,
                      width: sel ? 1.5 : 1.0,
                    ),
                    boxShadow: sel
                        ? [
                            BoxShadow(
                                color: _C.darkGreen.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 3))
                          ]
                        : [],
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(opt.icon,
                            size: 20,
                            color: sel
                                ? _C.darkGreen
                                : hasErr
                                    ? _C.red
                                    : _C.textSecondary),
                        const SizedBox(height: 3),
                        Text(opt.label,
                            style: TextStyle(
                                fontSize: 11.5,
                                fontWeight:
                                    sel ? FontWeight.w700 : FontWeight.w500,
                                color: sel
                                    ? _C.darkGreen
                                    : hasErr
                                        ? _C.red
                                        : _C.textSecondary)),
                      ]),
                ),
              ),
            ),
          );
        })),
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          child: hasErr
              ? Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Row(children: [
                    const Icon(Icons.error_rounded, size: 13, color: _C.red),
                    const SizedBox(width: 6),
                    Text(error!,
                        style: const TextStyle(
                            color: _C.red,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500)),
                  ]))
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DIALOG ROW
// ─────────────────────────────────────────────────────────────────────────────

class _DRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor, bg;
  final String text;
  const _DRow(
      {required this.icon,
      required this.iconColor,
      required this.bg,
      required this.text});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 9),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: _C.textPrimary,
                      height: 1.35))),
        ]),
      );
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
  late final VoidCallback _fl;
  @override
  void initState() {
    super.initState();
    _fl = () {
      if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
    };
    widget.focusNode.addListener(_fl);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_fl);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasErr = widget.error != null && widget.error!.isNotEmpty;
    final ic = hasErr
        ? _C.red
        : _focused
            ? _C.darkGreen
            : _C.textSecondary;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.label,
          style: TextStyle(
              color: hasErr
                  ? _C.red
                  : _focused
                      ? _C.darkGreen
                      : _C.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13)),
      const SizedBox(height: 8),
      AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: _focused && !hasErr
              ? [
                  BoxShadow(
                      color: _C.darkGreen.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
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
              color: _C.textPrimary, fontWeight: FontWeight.w500, fontSize: 15),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
            prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(widget.icon, size: 20, color: ic)),
            prefixIconConstraints: const BoxConstraints(minWidth: 54),
            filled: true,
            fillColor: hasErr
                ? _C.red.withOpacity(0.04)
                : _focused
                    ? _C.cardBg
                    : _C.surfaceAlt,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: _C.border)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                    color: hasErr ? _C.red.withOpacity(0.5) : _C.border)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                    color: hasErr ? _C.red : _C.darkGreen, width: 1.5)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ),
      AnimatedSize(
        duration: const Duration(milliseconds: 180),
        child: hasErr
            ? Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Row(children: [
                  const Icon(Icons.error_rounded, size: 13, color: _C.red),
                  const SizedBox(width: 6),
                  Text(widget.error!,
                      style: const TextStyle(
                          color: _C.red,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500)),
                ]))
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
  final TextInputAction textInputAction;
  final void Function(String) onChanged;
  final VoidCallback onSubmit;
  final bool showStrengthBar;

  const _PasswordField({
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.hint,
    this.error,
    this.textInputAction = TextInputAction.next,
    required this.onChanged,
    required this.onSubmit,
    this.showStrengthBar = false,
  });
  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _focused = false, _obscure = true;
  late final VoidCallback _fl;
  @override
  void initState() {
    super.initState();
    _fl = () {
      if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
    };
    widget.focusNode.addListener(_fl);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_fl);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasErr = widget.error != null && widget.error!.isNotEmpty;
    final ic = hasErr
        ? _C.red
        : _focused
            ? _C.darkGreen
            : _C.textSecondary;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.label,
          style: TextStyle(
              color: hasErr
                  ? _C.red
                  : _focused
                      ? _C.darkGreen
                      : _C.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13)),
      const SizedBox(height: 8),
      AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: _focused && !hasErr
              ? [
                  BoxShadow(
                      color: _C.darkGreen.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
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
              color: _C.textPrimary, fontWeight: FontWeight.w500, fontSize: 15),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
            prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.lock_outline_rounded, size: 20, color: ic)),
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
                      color: _focused ? _C.darkGreen : _C.textSecondary)),
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
                borderSide: const BorderSide(color: _C.border)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                    color: hasErr ? _C.red.withOpacity(0.5) : _C.border)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                    color: hasErr ? _C.red : _C.darkGreen, width: 1.5)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ),
      AnimatedSize(
        duration: const Duration(milliseconds: 180),
        child: hasErr
            ? Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Row(children: [
                  const Icon(Icons.error_rounded, size: 13, color: _C.red),
                  const SizedBox(width: 6),
                  Text(widget.error!,
                      style: const TextStyle(
                          color: _C.red,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500)),
                ]))
            : const SizedBox.shrink(),
      ),
      if (widget.showStrengthBar && widget.controller.text.isNotEmpty) ...[
        const SizedBox(height: 10),
        _StrengthBar(password: widget.controller.text),
      ],
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STRENGTH BAR
// ─────────────────────────────────────────────────────────────────────────────

class _StrengthBar extends StatelessWidget {
  final String password;
  const _StrengthBar({required this.password});
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
    return Row(children: [
      Expanded(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                  value: s / 5,
                  minHeight: 4,
                  backgroundColor: _C.border,
                  valueColor: AlwaysStoppedAnimation(color)))),
      const SizedBox(width: 12),
      Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ERROR BANNER
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner(this.message);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
            color: _C.redLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _C.red.withOpacity(0.25))),
        child: Row(children: [
          const Icon(Icons.error_outline_rounded, color: _C.red, size: 18),
          const SizedBox(width: 10),
          Expanded(
              child: Text(message,
                  style: const TextStyle(
                      color: _C.red,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500))),
        ]),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// PRIMARY BUTTON
// ─────────────────────────────────────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isLoading;
  const _PrimaryButton(
      {required this.label, this.icon, this.onTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null && !isLoading;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
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
                    offset: const Offset(0, 6))
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
                          strokeWidth: 2.5, color: Colors.white))
                  : Row(mainAxisSize: MainAxisSize.min, children: [
                      if (icon != null) ...[
                        Icon(icon, color: Colors.white, size: 20),
                        const SizedBox(width: 10)
                      ],
                      Text(label,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              letterSpacing: -0.2)),
                    ])),
        ),
      ),
    );
  }
}
