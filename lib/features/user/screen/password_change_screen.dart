// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../../auth/providers/auth_provider.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // DESIGN TOKENS
// // ─────────────────────────────────────────────────────────────────────────────

// class _C {
//   static const bg = Color(0xFFF4F6F1);
//   static const card = Color(0xFFFFFFFF);
//   static const darkGreen = Color(0xFF0E3D22);
//   static const midGreen = Color(0xFF1B7045);
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const gold = Color(0xFFD4A843);
//   static const red = Color(0xFFEF4444);
//   static const redLight = Color(0xFFFEF2F2);
//   static const amber = Color(0xFFF59E0B);
//   static const amberLight = Color(0xFFFFF3E0);
//   static const border = Color(0xFFE4EAE4);
//   static const borderFocus = Color(0xFF0E3D22);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// class ChangePasswordScreen extends ConsumerStatefulWidget {
//   const ChangePasswordScreen({super.key});

//   @override
//   ConsumerState<ChangePasswordScreen> createState() =>
//       _ChangePasswordScreenState();
// }

// class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final _currentCtrl = TextEditingController();
//   final _newCtrl = TextEditingController();
//   final _confirmCtrl = TextEditingController();

//   bool _showCurrent = false;
//   bool _showNew = false;
//   bool _showConfirm = false;
//   bool _saving = false;

//   // Strength tracking
//   int _strengthScore = 0; // 0–4
//   String _strengthLabel = '';
//   Color _strengthColor = _C.textHint;

//   @override
//   void initState() {
//     super.initState();
//     _newCtrl.addListener(_evaluateStrength);
//   }

//   @override
//   void dispose() {
//     _currentCtrl.dispose();
//     _newCtrl.dispose();
//     _confirmCtrl.dispose();
//     super.dispose();
//   }

//   // ── Password strength evaluator ────────────────────────────────────────────

//   void _evaluateStrength() {
//     final p = _newCtrl.text;
//     int score = 0;
//     if (p.length >= 8) score++;
//     if (RegExp(r'[A-Z]').hasMatch(p)) score++;
//     if (RegExp(r'[0-9]').hasMatch(p)) score++;
//     if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(p)) score++;

//     String label;
//     Color color;
//     switch (score) {
//       case 0:
//       case 1:
//         label = 'দুর্বল';
//         color = _C.red;
//         break;
//       case 2:
//         label = 'মধ্যম';
//         color = _C.amber;
//         break;
//       case 3:
//         label = 'ভালো';
//         color = _C.green;
//         break;
//       default:
//         label = 'শক্তিশালী';
//         color = _C.darkGreen;
//     }

//     setState(() {
//       _strengthScore = score;
//       _strengthLabel = p.isEmpty ? '' : label;
//       _strengthColor = color;
//     });
//   }

//   // ── Save ──────────────────────────────────────────────────────────────────

//   Future<void> _save() async {
//     if (!(_formKey.currentState?.validate() ?? false)) return;

//     setState(() => _saving = true);
//     HapticFeedback.mediumImpact();

//     final ok = await ref.read(authProvider.notifier).changePassword(
//           _currentCtrl.text.trim(),
//           _newCtrl.text.trim(),
//         );

//     setState(() => _saving = false);

//     if (!mounted) return;

//     if (ok) {
//       HapticFeedback.selectionClick();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Row(children: [
//             Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
//             SizedBox(width: 8),
//             Text('পাসওয়ার্ড সফলভাবে পরিবর্তন হয়েছে!'),
//           ]),
//           backgroundColor: _C.darkGreen,
//           margin: const EdgeInsets.all(16),
//           behavior: SnackBarBehavior.floating,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//       context.pop();
//     } else {
//       final error =
//           ref.read(authProvider).error ?? 'পাসওয়ার্ড পরিবর্তন ব্যর্থ হয়েছে';
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(children: [
//             const Icon(Icons.error_outline_rounded,
//                 color: Colors.white, size: 16),
//             const SizedBox(width: 8),
//             Expanded(child: Text(error)),
//           ]),
//           backgroundColor: _C.red,
//           margin: const EdgeInsets.all(16),
//           behavior: SnackBarBehavior.floating,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     }
//   }

//   // ── Build ─────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;
//     final hPad = isTablet ? (size.width - 600) / 2 + 20.0 : 20.0;
//     final hasNew = _newCtrl.text.isNotEmpty;

//     return Scaffold(
//       backgroundColor: _C.bg,
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           // ── App Bar ───────────────────────────────────────────────
//           SliverAppBar(
//             pinned: true,
//             backgroundColor: _C.darkGreen,
//             surfaceTintColor: Colors.transparent,
//             systemOverlayStyle: SystemUiOverlayStyle.light,
//             expandedHeight: 110,
//             leading: GestureDetector(
//               onTap: () => context.pop(),
//               child: Container(
//                 margin: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(Icons.arrow_back_ios_rounded,
//                     color: Colors.white, size: 16),
//               ),
//             ),
//             flexibleSpace: FlexibleSpaceBar(
//               collapseMode: CollapseMode.pin,
//               background: Container(
//                 color: _C.darkGreen,
//                 child: Stack(
//                   children: [
//                     Positioned(
//                       top: -24,
//                       right: -24,
//                       child: Container(
//                         width: 100,
//                         height: 100,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.white.withOpacity(0.05),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: -20,
//                       left: 40,
//                       child: Container(
//                         width: 70,
//                         height: 70,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.white.withOpacity(0.04),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 16,
//                       left: hPad,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Text(
//                             'পাসওয়ার্ড পরিবর্তন',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 22,
//                               fontWeight: FontWeight.w900,
//                               letterSpacing: -0.4,
//                             ),
//                           ),
//                           Text(
//                             'নিরাপদ রাখুন আপনার অ্যাকাউন্ট',
//                             style: TextStyle(
//                               color: Colors.white.withOpacity(0.5),
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // ── Body ─────────────────────────────────────────────────
//           SliverPadding(
//             padding: EdgeInsets.fromLTRB(hPad, 24, hPad, 40),
//             sliver: SliverToBoxAdapter(
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Security badge
//                     _SecurityBadge()
//                         .animate()
//                         .fadeIn(duration: 260.ms)
//                         .slideY(begin: 0.05),

//                     const SizedBox(height: 24),

//                     // ── Fields ───────────────────────────────────────
//                     _SectionLabel(label: 'বর্তমান পাসওয়ার্ড'),
//                     const SizedBox(height: 8),
//                     _PasswordField(
//                       controller: _currentCtrl,
//                       hint: 'বর্তমান পাসওয়ার্ড লিখুন',
//                       icon: Icons.lock_outline_rounded,
//                       showPassword: _showCurrent,
//                       onToggleVisibility: () =>
//                           setState(() => _showCurrent = !_showCurrent),
//                       validator: (v) => (v?.isEmpty ?? true)
//                           ? 'বর্তমান পাসওয়ার্ড দিন'
//                           : null,
//                       animDelay: 60,
//                     ),

//                     const SizedBox(height: 20),

//                     _SectionLabel(label: 'নতুন পাসওয়ার্ড'),
//                     const SizedBox(height: 8),
//                     _PasswordField(
//                       controller: _newCtrl,
//                       hint: 'নতুন পাসওয়ার্ড লিখুন',
//                       icon: Icons.lock_reset_rounded,
//                       showPassword: _showNew,
//                       onToggleVisibility: () =>
//                           setState(() => _showNew = !_showNew),
//                       validator: (v) {
//                         if (v == null || v.isEmpty)
//                           return 'নতুন পাসওয়ার্ড দিন';
//                         if (v.length < 8) return 'কমপক্ষে ৮ অক্ষর হতে হবে';
//                         if (v == _currentCtrl.text) {
//                           return 'নতুন পাসওয়ার্ড পুরানোটির মতো হতে পারবে না';
//                         }
//                         return null;
//                       },
//                       animDelay: 100,
//                     ),

//                     // Strength indicator
//                     if (hasNew) ...[
//                       const SizedBox(height: 10),
//                       _StrengthIndicator(
//                         score: _strengthScore,
//                         label: _strengthLabel,
//                         color: _strengthColor,
//                         password: _newCtrl.text,
//                       ).animate().fadeIn(duration: 200.ms),
//                     ],

//                     const SizedBox(height: 20),

//                     _SectionLabel(label: 'নতুন পাসওয়ার্ড নিশ্চিত করুন'),
//                     const SizedBox(height: 8),
//                     _PasswordField(
//                       controller: _confirmCtrl,
//                       hint: 'আবার লিখুন',
//                       icon: Icons.check_circle_outline_rounded,
//                       showPassword: _showConfirm,
//                       onToggleVisibility: () =>
//                           setState(() => _showConfirm = !_showConfirm),
//                       validator: (v) {
//                         if (v == null || v.isEmpty)
//                           return 'পাসওয়ার্ড নিশ্চিত করুন';
//                         if (v != _newCtrl.text) return 'পাসওয়ার্ড মিলছে না';
//                         return null;
//                       },
//                       animDelay: 140,
//                     ),

//                     const SizedBox(height: 28),

//                     // ── Tips ────────────────────────────────────────
//                     _PasswordTips().animate().fadeIn(delay: 180.ms),

//                     const SizedBox(height: 28),

//                     // ── Save button ──────────────────────────────────
//                     _SaveButton(
//                       saving: _saving,
//                       onTap: _save,
//                     ).animate().fadeIn(delay: 220.ms).slideY(begin: 0.08),

//                     SizedBox(
//                         height: MediaQuery.of(context).padding.bottom + 20),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECURITY BADGE
// // ─────────────────────────────────────────────────────────────────────────────

// class _SecurityBadge extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: _C.greenLight,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.green.withOpacity(0.3), width: 1),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               color: _C.darkGreen,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(Icons.security_rounded,
//                 color: Colors.white, size: 22),
//           ),
//           const SizedBox(width: 12),
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'অ্যাকাউন্ট সুরক্ষিত রাখুন',
//                   style: TextStyle(
//                     color: _C.darkGreen,
//                     fontSize: 13.5,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//                 SizedBox(height: 2),
//                 Text(
//                   'শক্তিশালী পাসওয়ার্ড ব্যবহার করুন এবং কারো সাথে শেয়ার করবেন না',
//                   style: TextStyle(
//                     color: _C.midGreen,
//                     fontSize: 11,
//                     height: 1.45,
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

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION LABEL
// // ─────────────────────────────────────────────────────────────────────────────

// class _SectionLabel extends StatelessWidget {
//   final String label;
//   const _SectionLabel({required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 2),
//       child: Text(
//         label,
//         style: const TextStyle(
//           color: _C.textSecondary,
//           fontSize: 12,
//           fontWeight: FontWeight.w700,
//           letterSpacing: 0.1,
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PASSWORD FIELD
// // ─────────────────────────────────────────────────────────────────────────────

// class _PasswordField extends StatefulWidget {
//   final TextEditingController controller;
//   final String hint;
//   final IconData icon;
//   final bool showPassword;
//   final VoidCallback onToggleVisibility;
//   final String? Function(String?)? validator;
//   final int animDelay;

//   const _PasswordField({
//     required this.controller,
//     required this.hint,
//     required this.icon,
//     required this.showPassword,
//     required this.onToggleVisibility,
//     this.validator,
//     this.animDelay = 0,
//   });

//   @override
//   State<_PasswordField> createState() => _PasswordFieldState();
// }

// class _PasswordFieldState extends State<_PasswordField> {
//   bool _focused = false;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: 180.ms,
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(
//           color: _focused ? _C.borderFocus : _C.border,
//           width: _focused ? 1.5 : 0.5,
//         ),
//         boxShadow: _focused
//             ? [
//                 BoxShadow(
//                   color: _C.darkGreen.withOpacity(0.08),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ]
//             : [],
//       ),
//       child: Focus(
//         onFocusChange: (f) => setState(() => _focused = f),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
//           child: Row(
//             children: [
//               AnimatedContainer(
//                 duration: 180.ms,
//                 width: 36,
//                 height: 36,
//                 decoration: BoxDecoration(
//                   color: _focused ? _C.greenLight : _C.bg,
//                   borderRadius: BorderRadius.circular(9),
//                 ),
//                 child: Icon(
//                   widget.icon,
//                   size: 17,
//                   color: _focused ? _C.darkGreen : _C.textHint,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: TextFormField(
//                   controller: widget.controller,
//                   obscureText: !widget.showPassword,
//                   validator: widget.validator,
//                   style: const TextStyle(
//                     color: _C.textPrimary,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 0.5,
//                   ),
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     // enabledBorder: InputBorder,
//                     // focusedBorder: InputBorder.none,
//                     // enabledBorder: InputBorder.none,
//                     // errorBorder: InputBorder.none,
//                     // disabledBorder: InputBorder.none,
//                     hintText: widget.hint,
//                     hintStyle: const TextStyle(
//                       color: _C.textHint,
//                       fontSize: 13,
//                       fontWeight: FontWeight.w400,
//                       letterSpacing: 0,
//                     ),
//                     errorStyle: const TextStyle(
//                       color: _C.red,
//                       fontSize: 11,
//                     ),
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: widget.onToggleVisibility,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8),
//                   child: Icon(
//                     widget.showPassword
//                         ? Icons.visibility_off_outlined
//                         : Icons.visibility_outlined,
//                     size: 18,
//                     color: _C.textHint,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     )
//         .animate(delay: Duration(milliseconds: widget.animDelay))
//         .fadeIn(duration: 240.ms)
//         .slideX(begin: 0.04, curve: Curves.easeOut);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // STRENGTH INDICATOR
// // ─────────────────────────────────────────────────────────────────────────────

// class _StrengthIndicator extends StatelessWidget {
//   final int score;
//   final String label;
//   final Color color;
//   final String password; // receive raw password to compute criteria

//   const _StrengthIndicator({
//     required this.score,
//     required this.label,
//     required this.color,
//     required this.password,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Bar row
//         Row(
//           children: List.generate(4, (i) {
//             final filled = i < score;
//             return Expanded(
//               child: AnimatedContainer(
//                 duration: 200.ms,
//                 height: 5,
//                 margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
//                 decoration: BoxDecoration(
//                   color: filled ? color : _C.border,
//                   borderRadius: BorderRadius.circular(99),
//                 ),
//               ),
//             );
//           }),
//         ),
//         const SizedBox(height: 6),
//         Row(
//           children: [
//             Container(
//               width: 8,
//               height: 8,
//               decoration: BoxDecoration(
//                 color: color,
//                 shape: BoxShape.circle,
//               ),
//             ),
//             const SizedBox(width: 6),
//             Text(
//               'পাসওয়ার্ড শক্তি: $label',
//               style: TextStyle(
//                 color: color,
//                 fontSize: 11,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),

//         // Criteria chips
//         const SizedBox(height: 8),
//         Wrap(
//           spacing: 6,
//           runSpacing: 6,
//           children: [
//             _CriteriaChip(
//               label: '৮+ অক্ষর',
//               met: password.length >= 8,
//             ),
//             _CriteriaChip(
//               label: 'বড় হাতের অক্ষর',
//               met: RegExp(r'[A-Z]').hasMatch(password),
//             ),
//             _CriteriaChip(
//               label: 'সংখ্যা',
//               met: RegExp(r'[0-9]').hasMatch(password),
//             ),
//             _CriteriaChip(
//               label: 'বিশেষ চিহ্ন',
//               met: RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class _CriteriaChip extends StatelessWidget {
//   final String label;
//   final bool met;

//   const _CriteriaChip({required this.label, required this.met});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: 200.ms,
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: met ? _C.greenLight : _C.bg,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: met ? _C.green.withOpacity(0.35) : _C.border,
//           width: 0.5,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             met ? Icons.check_rounded : Icons.remove_rounded,
//             size: 11,
//             color: met ? _C.green : _C.textHint,
//           ),
//           const SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(
//               color: met ? _C.darkGreen : _C.textHint,
//               fontSize: 10.5,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PASSWORD TIPS
// // ─────────────────────────────────────────────────────────────────────────────

// class _PasswordTips extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     const tips = [
//       'কমপক্ষে ৮টি অক্ষর ব্যবহার করুন',
//       'বড় হাতের ও ছোট হাতের অক্ষর মিলিয়ে লিখুন',
//       'সংখ্যা ও বিশেষ চিহ্ন (!@#\$) যোগ করুন',
//       'নিজের নাম, জন্মতারিখ বা সহজ শব্দ ব্যবহার করবেন না',
//     ];

//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFFF8E7),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: _C.gold.withOpacity(0.35), width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: const [
//               Text('💡', style: TextStyle(fontSize: 14)),
//               SizedBox(width: 7),
//               Text(
//                 'শক্তিশালী পাসওয়ার্ডের নিয়ম',
//                 style: TextStyle(
//                   color: Color(0xFF78350F),
//                   fontSize: 12.5,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           ...tips.map(
//             (t) => Padding(
//               padding: const EdgeInsets.only(bottom: 6),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 5,
//                     height: 5,
//                     margin: const EdgeInsets.only(top: 5, right: 8),
//                     decoration: BoxDecoration(
//                       color: _C.gold,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   Expanded(
//                     child: Text(
//                       t,
//                       style: const TextStyle(
//                         color: Color(0xFF92400E),
//                         fontSize: 11.5,
//                         height: 1.45,
//                       ),
//                     ),
//                   ),
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
// // SAVE BUTTON
// // ─────────────────────────────────────────────────────────────────────────────

// class _SaveButton extends StatelessWidget {
//   final bool saving;
//   final VoidCallback onTap;

//   const _SaveButton({required this.saving, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: saving ? null : onTap,
//       child: AnimatedContainer(
//         duration: 160.ms,
//         width: double.infinity,
//         height: 54,
//         decoration: BoxDecoration(
//           color: saving ? _C.darkGreen.withOpacity(0.7) : _C.darkGreen,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: saving
//               ? []
//               : [
//                   BoxShadow(
//                     color: _C.darkGreen.withOpacity(0.25),
//                     blurRadius: 16,
//                     offset: const Offset(0, 6),
//                   ),
//                 ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (saving)
//               const SizedBox(
//                 width: 18,
//                 height: 18,
//                 child: CircularProgressIndicator(
//                     color: Colors.white, strokeWidth: 2),
//               )
//             else ...[
//               const Icon(Icons.lock_rounded, color: Colors.white, size: 18),
//               const SizedBox(width: 8),
//               const Text(
//                 'পাসওয়ার্ড পরিবর্তন করুন',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 15,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../../auth/providers/auth_provider.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // DESIGN TOKENS
// // ─────────────────────────────────────────────────────────────────────────────

// class _C {
//   static const bg = Color(0xFFF4F6F1);
//   static const card = Color(0xFFFFFFFF);
//   static const darkGreen = Color(0xFF0E3D22);
//   static const midGreen = Color(0xFF1B7045);
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const gold = Color(0xFFD4A843);
//   static const red = Color(0xFFE53935);
//   static const redLight = Color(0xFFFDECEC);
//   static const amber = Color(0xFFF59E0B);
//   static const border = Color(0xFFE2E8E2);
//   static const borderFocus = Color(0xFF0E3D22);
//   static const borderError = Color(0xFFE53935);
//   static const inputBg = Color(0xFFF8FAF8);
//   static const inputBgFocus = Color(0xFFFFFFFF);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFB0BDB2);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// class ChangePasswordScreen extends ConsumerStatefulWidget {
//   const ChangePasswordScreen({super.key});

//   @override
//   ConsumerState<ChangePasswordScreen> createState() =>
//       _ChangePasswordScreenState();
// }

// class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
//   final _currentCtrl = TextEditingController();
//   final _newCtrl = TextEditingController();
//   final _confirmCtrl = TextEditingController();

//   final _currentFocus = FocusNode();
//   final _newFocus = FocusNode();
//   final _confirmFocus = FocusNode();

//   String? _currentError;
//   String? _newError;
//   String? _confirmError;

//   bool _showCurrent = false;
//   bool _showNew = false;
//   bool _showConfirm = false;
//   bool _saving = false;

//   // strength
//   int _score = 0;
//   String _strengthLabel = '';
//   Color _strengthColor = _C.textHint;

//   @override
//   void initState() {
//     super.initState();
//     _newCtrl.addListener(_onNewChanged);
//     // repaint on focus changes
//     for (final f in [_currentFocus, _newFocus, _confirmFocus]) {
//       f.addListener(() => setState(() {}));
//     }
//   }

//   @override
//   void dispose() {
//     _currentCtrl.dispose();
//     _newCtrl.dispose();
//     _confirmCtrl.dispose();
//     _currentFocus.dispose();
//     _newFocus.dispose();
//     _confirmFocus.dispose();
//     super.dispose();
//   }

//   // ── Strength ──────────────────────────────────────────────────────────────

//   void _onNewChanged() {
//     final p = _newCtrl.text;
//     int s = 0;
//     if (p.length >= 8) s++;
//     if (RegExp(r'[A-Z]').hasMatch(p)) s++;
//     if (RegExp(r'[0-9]').hasMatch(p)) s++;
//     if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(p)) s++;

//     final (lbl, col) = switch (s) {
//       0 || 1 => ('দুর্বল', _C.red),
//       2 => ('মধ্যম', _C.amber),
//       3 => ('ভালো', _C.green),
//       _ => ('শক্তিশালী', _C.darkGreen),
//     };

//     // clear new-password error as user types
//     if (_newError != null) _validateNew(p);

//     setState(() {
//       _score = s;
//       _strengthLabel = p.isEmpty ? '' : lbl;
//       _strengthColor = col;
//     });
//   }

//   // ── Validators ────────────────────────────────────────────────────────────

//   void _validateCurrent(String v) => setState(() {
//         _currentError = v.trim().isEmpty ? 'বর্তমান পাসওয়ার্ড দিন' : null;
//       });

//   void _validateNew(String v) => setState(() {
//         if (v.isEmpty)
//           _newError = 'নতুন পাসওয়ার্ড দিন';
//         else if (v.length < 8)
//           _newError = 'কমপক্ষে ৮ অক্ষর হতে হবে';
//         else if (v == _currentCtrl.text && v.isNotEmpty)
//           _newError = 'পুরানো পাসওয়ার্ডের মতো হতে পারবে না';
//         else
//           _newError = null;

//         // live cross-validate confirm
//         if (_confirmCtrl.text.isNotEmpty) {
//           _confirmError = _confirmCtrl.text != v ? 'পাসওয়ার্ড মিলছে না' : null;
//         }
//       });

//   void _validateConfirm(String v) => setState(() {
//         _confirmError = v != _newCtrl.text ? 'পাসওয়ার্ড মিলছে না' : null;
//       });

//   bool _validateAll() {
//     _validateCurrent(_currentCtrl.text);
//     _validateNew(_newCtrl.text);
//     _validateConfirm(_confirmCtrl.text);
//     // read fresh state after setState
//     final c = _currentCtrl.text.trim().isEmpty;
//     final n = _newCtrl.text.isEmpty ||
//         _newCtrl.text.length < 8 ||
//         _newCtrl.text == _currentCtrl.text;
//     final cf = _confirmCtrl.text != _newCtrl.text;
//     return !c && !n && !cf;
//   }

//   // ── Save ──────────────────────────────────────────────────────────────────

//   Future<void> _save() async {
//     FocusScope.of(context).unfocus();
//     if (!_validateAll()) {
//       HapticFeedback.vibrate();
//       return;
//     }

//     setState(() => _saving = true);
//     HapticFeedback.mediumImpact();

//     final ok = await ref.read(authProvider.notifier).changePassword(
//           _currentCtrl.text.trim(),
//           _newCtrl.text.trim(),
//         );

//     setState(() => _saving = false);
//     if (!mounted) return;

//     if (ok) {
//       HapticFeedback.selectionClick();
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: const Row(children: [
//           Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
//           SizedBox(width: 8),
//           Text('পাসওয়ার্ড সফলভাবে পরিবর্তন হয়েছে!'),
//         ]),
//         backgroundColor: _C.darkGreen,
//         margin: const EdgeInsets.all(16),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         duration: const Duration(seconds: 2),
//       ));
//       context.pop();
//     } else {
//       setState(() {
//         _currentError =
//             ref.read(authProvider).error ?? 'বর্তমান পাসওয়ার্ড ভুল হয়েছে';
//       });
//     }
//   }

//   // ── Build ─────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context);
//     final isTablet = mq.size.width > 600;
//     final hPad = isTablet ? (mq.size.width - 600) / 2 + 24.0 : 24.0;
//     final hasNew = _newCtrl.text.isNotEmpty;

//     return Scaffold(
//       backgroundColor: _C.bg,
//       bottomNavigationBar: _SubmitBar(saving: _saving, onTap: _save),
//       body: CustomScrollView(
//         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           // ── Minimal app bar ───────────────────────────────────────
//           SliverAppBar(
//             pinned: true,
//             backgroundColor: _C.darkGreen,
//             surfaceTintColor: Colors.transparent,
//             systemOverlayStyle: SystemUiOverlayStyle.light,
//             toolbarHeight: 56,
//             leading: GestureDetector(
//               onTap: () => context.pop(),
//               child: Container(
//                 margin: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(Icons.arrow_back_ios_rounded,
//                     color: Colors.white, size: 16),
//               ),
//             ),
//             title: const Text('পাসওয়ার্ড পরিবর্তন',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w800,
//                   letterSpacing: -0.3,
//                 )),
//           ),

//           // ── Body ─────────────────────────────────────────────────
//           SliverPadding(
//             padding: EdgeInsets.fromLTRB(hPad, 28, hPad, 32),
//             sliver: SliverToBoxAdapter(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Page intro
//                   _PageIntro().animate().fadeIn(duration: 260.ms),

//                   const SizedBox(height: 32),

//                   // ── Section: Current ───────────────────────────
//                   _SectionLabel(label: 'বর্তমান পাসওয়ার্ড'),
//                   const SizedBox(height: 8),
//                   _PasswordInput(
//                     controller: _currentCtrl,
//                     focusNode: _currentFocus,
//                     nextFocus: _newFocus,
//                     hint: 'বর্তমান পাসওয়ার্ড লিখুন',
//                     showText: _showCurrent,
//                     error: _currentError,
//                     onToggle: () =>
//                         setState(() => _showCurrent = !_showCurrent),
//                     onChanged: _validateCurrent,
//                   ).animate().fadeIn(delay: 60.ms, duration: 260.ms),

//                   const SizedBox(height: 24),

//                   // ── Section: New ───────────────────────────────
//                   _SectionLabel(label: 'নতুন পাসওয়ার্ড'),
//                   const SizedBox(height: 8),
//                   _PasswordInput(
//                     controller: _newCtrl,
//                     focusNode: _newFocus,
//                     nextFocus: _confirmFocus,
//                     hint: 'নতুন পাসওয়ার্ড লিখুন',
//                     showText: _showNew,
//                     error: _newError,
//                     onToggle: () => setState(() => _showNew = !_showNew),
//                     onChanged: _validateNew,
//                   ).animate().fadeIn(delay: 100.ms, duration: 260.ms),

//                   // Strength — slides in below new-password field
//                   AnimatedSize(
//                     duration: 220.ms,
//                     curve: Curves.easeOut,
//                     alignment: Alignment.topCenter,
//                     child: hasNew
//                         ? Padding(
//                             padding: const EdgeInsets.only(top: 10),
//                             child: _StrengthRow(
//                               score: _score,
//                               label: _strengthLabel,
//                               color: _strengthColor,
//                               password: _newCtrl.text,
//                             ).animate().fadeIn(duration: 200.ms),
//                           )
//                         : const SizedBox.shrink(),
//                   ),

//                   const SizedBox(height: 24),

//                   // ── Section: Confirm ───────────────────────────
//                   _SectionLabel(label: 'নতুন পাসওয়ার্ড নিশ্চিত করুন'),
//                   const SizedBox(height: 8),
//                   _PasswordInput(
//                     controller: _confirmCtrl,
//                     focusNode: _confirmFocus,
//                     hint: 'আবার লিখুন',
//                     showText: _showConfirm,
//                     error: _confirmError,
//                     onToggle: () =>
//                         setState(() => _showConfirm = !_showConfirm),
//                     onChanged: _validateConfirm,
//                     textInputAction: TextInputAction.done,
//                     onSubmitted: (_) => _save(),
//                   ).animate().fadeIn(delay: 140.ms, duration: 260.ms),

//                   const SizedBox(height: 32),

//                   // ── Tips ──────────────────────────────────────
//                   _PasswordTips()
//                       .animate()
//                       .fadeIn(delay: 180.ms, duration: 260.ms),
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
// // PAGE INTRO
// // ─────────────────────────────────────────────────────────────────────────────

// class _PageIntro extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(children: [
//       Container(
//         width: 48,
//         height: 48,
//         decoration: BoxDecoration(
//           color: _C.greenLight,
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child:
//             const Icon(Icons.lock_reset_rounded, color: _C.darkGreen, size: 24),
//       ),
//       const SizedBox(width: 14),
//       const Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('পাসওয়ার্ড বদলান',
//                 style: TextStyle(
//                   color: _C.textPrimary,
//                   fontSize: 17,
//                   fontWeight: FontWeight.w800,
//                   letterSpacing: -0.3,
//                 )),
//             SizedBox(height: 2),
//             Text('নিরাপদ থাকতে নিয়মিত পাসওয়ার্ড পরিবর্তন করুন',
//                 style: TextStyle(
//                   color: _C.textSecondary,
//                   fontSize: 12,
//                   height: 1.4,
//                 )),
//           ],
//         ),
//       ),
//     ]);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION LABEL
// // ─────────────────────────────────────────────────────────────────────────────

// class _SectionLabel extends StatelessWidget {
//   final String label;
//   const _SectionLabel({required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Text(label,
//         style: const TextStyle(
//           color: _C.textSecondary,
//           fontSize: 12.5,
//           fontWeight: FontWeight.w700,
//         ));
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PASSWORD INPUT
// //
// // Design rationale
// // ────────────────
// // • Each field is a standalone, fully rounded card — no grouping card on top.
// //   This is how iOS Settings, 1Password, Google etc. handle password inputs.
// // • Single border on the card that changes color: default → focus → error.
// //   No inner border, no left-accent, no double-layer.
// // • Floating label is replaced by an external _SectionLabel above the card
// //   so the card itself stays clean and the label never overlaps content.
// // • Error message sits *outside* the card below it — uses AnimatedSize so
// //   the card shape NEVER changes. The error slides in smoothly.
// // • onChanged triggers inline validation → error clears immediately as user
// //   types a valid value.
// // ─────────────────────────────────────────────────────────────────────────────

// class _PasswordInput extends StatefulWidget {
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final FocusNode? nextFocus;
//   final String hint;
//   final bool showText;
//   final String? error;
//   final VoidCallback onToggle;
//   final ValueChanged<String> onChanged;
//   final TextInputAction textInputAction;
//   final ValueChanged<String>? onSubmitted;

//   const _PasswordInput({
//     required this.controller,
//     required this.focusNode,
//     required this.hint,
//     required this.showText,
//     required this.error,
//     required this.onToggle,
//     required this.onChanged,
//     this.nextFocus,
//     this.textInputAction = TextInputAction.next,
//     this.onSubmitted,
//   });

//   @override
//   State<_PasswordInput> createState() => _PasswordInputState();
// }

// class _PasswordInputState extends State<_PasswordInput> {
//   bool get _focused => widget.focusNode.hasFocus;
//   bool get _hasError => widget.error != null;
//   bool get _isDone =>
//       !_hasError && widget.controller.text.isNotEmpty && !_focused;

//   Color get _borderColor {
//     if (_hasError) return _C.borderError;
//     if (_focused) return _C.borderFocus;
//     return _C.border;
//   }

//   double get _borderWidth {
//     if (_hasError) return 1.5;
//     if (_focused) return 1.5;
//     return 1.0;
//   }

//   Color get _bgColor {
//     if (_hasError) return _C.redLight.withOpacity(0.35);
//     if (_focused) return _C.inputBgFocus;
//     return _C.inputBg;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // ── The input card ────────────────────────────────────────
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 180),
//           curve: Curves.easeOut,
//           decoration: BoxDecoration(
//             color: _bgColor,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(
//               color: _borderColor,
//               width: _borderWidth,
//             ),
//             boxShadow: _focused && !_hasError
//                 ? [
//                     BoxShadow(
//                       color: _C.darkGreen.withOpacity(0.08),
//                       blurRadius: 0,
//                       spreadRadius: 3,
//                       offset: Offset.zero,
//                     ),
//                   ]
//                 : [],
//           ),
//           child: Row(children: [
//             // ── Text field ──────────────────────────────────────
//             Expanded(
//               child: TextField(
//                 controller: widget.controller,
//                 focusNode: widget.focusNode,
//                 obscureText: !widget.showText,
//                 onChanged: widget.onChanged,
//                 textInputAction: widget.textInputAction,
//                 onSubmitted: widget.onSubmitted ??
//                     (_) {
//                       widget.nextFocus?.requestFocus();
//                     },
//                 style: const TextStyle(
//                   color: _C.textPrimary,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                   letterSpacing: 0.2,
//                   height: 1.0,
//                 ),
//                 decoration: InputDecoration(
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 16,
//                   ),
//                   border: InputBorder.none,
//                   hintText: widget.hint,
//                   hintStyle: const TextStyle(
//                     color: _C.textHint,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                     letterSpacing: 0,
//                   ),
//                 ),
//               ),
//             ),

//             // ── Right side: status icon + visibility toggle ─────
//             Row(mainAxisSize: MainAxisSize.min, children: [
//               // Status icon — only when not focused and has content
//               AnimatedSwitcher(
//                 duration: 160.ms,
//                 child: _isDone
//                     ? Padding(
//                         key: const ValueKey('done'),
//                         padding: const EdgeInsets.only(right: 4),
//                         child: const Icon(Icons.check_circle_rounded,
//                             color: _C.green, size: 18),
//                       )
//                     : _hasError
//                         ? Padding(
//                             key: const ValueKey('err'),
//                             padding: const EdgeInsets.only(right: 4),
//                             child: const Icon(Icons.error_outline_rounded,
//                                 color: _C.red, size: 18),
//                           )
//                         : const SizedBox.shrink(key: ValueKey('none')),
//               ),

//               // Visibility toggle
//               GestureDetector(
//                 onTap: widget.onToggle,
//                 behavior: HitTestBehavior.opaque,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(4, 14, 14, 14),
//                   child: AnimatedSwitcher(
//                     duration: 160.ms,
//                     child: Icon(
//                       widget.showText
//                           ? Icons.visibility_off_outlined
//                           : Icons.visibility_outlined,
//                       key: ValueKey(widget.showText),
//                       size: 20,
//                       color: _focused ? _C.darkGreen : _C.textHint,
//                     ),
//                   ),
//                 ),
//               ),
//             ]),
//           ]),
//         ),

//         // ── Error message — outside the card ─────────────────────
//         AnimatedSize(
//           duration: 200.ms,
//           curve: Curves.easeOut,
//           alignment: Alignment.topLeft,
//           child: widget.error != null
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 6, left: 4),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Icon(Icons.info_outline_rounded,
//                           color: _C.red, size: 13),
//                       const SizedBox(width: 5),
//                       Expanded(
//                         child: Text(widget.error!,
//                             style: const TextStyle(
//                               color: _C.red,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               height: 1.3,
//                             )),
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
// // STRENGTH ROW
// // ─────────────────────────────────────────────────────────────────────────────

// class _StrengthRow extends StatelessWidget {
//   final int score;
//   final String label, password;
//   final Color color;

//   const _StrengthRow({
//     required this.score,
//     required this.label,
//     required this.color,
//     required this.password,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Bar + label
//         Row(children: [
//           Expanded(
//             child: Row(
//               children: List.generate(
//                   4,
//                   (i) => Expanded(
//                         child: AnimatedContainer(
//                           duration: 180.ms,
//                           height: 4,
//                           margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
//                           decoration: BoxDecoration(
//                             color: i < score ? color : _C.border,
//                             borderRadius: BorderRadius.circular(99),
//                           ),
//                         ),
//                       )),
//             ),
//           ),
//           const SizedBox(width: 10),
//           AnimatedDefaultTextStyle(
//             duration: 200.ms,
//             style: TextStyle(
//               color: color,
//               fontSize: 11.5,
//               fontWeight: FontWeight.w700,
//             ),
//             child: Text(label),
//           ),
//         ]),

//         const SizedBox(height: 10),

//         // Criteria chips
//         Wrap(
//           spacing: 6,
//           runSpacing: 6,
//           children: [
//             _Chip(label: '৮+ অক্ষর', met: password.length >= 8),
//             _Chip(
//                 label: 'বড় হাতের অক্ষর',
//                 met: RegExp(r'[A-Z]').hasMatch(password)),
//             _Chip(label: 'সংখ্যা', met: RegExp(r'[0-9]').hasMatch(password)),
//             _Chip(
//                 label: 'বিশেষ চিহ্ন',
//                 met: RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class _Chip extends StatelessWidget {
//   final String label;
//   final bool met;
//   const _Chip({required this.label, required this.met});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: 200.ms,
//       padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
//       decoration: BoxDecoration(
//         color: met ? _C.greenLight : _C.card,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: met ? _C.green.withOpacity(0.4) : _C.border,
//         ),
//       ),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [
//         AnimatedSwitcher(
//           duration: 160.ms,
//           child: Icon(
//             met ? Icons.check_rounded : Icons.remove_rounded,
//             key: ValueKey(met),
//             size: 12,
//             color: met ? _C.green : _C.textHint,
//           ),
//         ),
//         const SizedBox(width: 5),
//         Text(label,
//             style: TextStyle(
//               color: met ? _C.darkGreen : _C.textHint,
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//             )),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PASSWORD TIPS
// // ─────────────────────────────────────────────────────────────────────────────

// class _PasswordTips extends StatelessWidget {
//   const _PasswordTips();

//   @override
//   Widget build(BuildContext context) {
//     const tips = [
//       'কমপক্ষে ৮টি অক্ষর ব্যবহার করুন',
//       'বড় হাতের ও ছোট হাতের অক্ষর মিলিয়ে লিখুন',
//       r'সংখ্যা ও বিশেষ চিহ্ন (!@#$) যোগ করুন',
//       'নিজের নাম বা জন্মতারিখ ব্যবহার করবেন না',
//     ];
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFFF8E7),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: _C.gold.withOpacity(0.4)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(children: [
//             Text('💡', style: TextStyle(fontSize: 14)),
//             SizedBox(width: 7),
//             Text('শক্তিশালী পাসওয়ার্ডের নিয়ম',
//                 style: TextStyle(
//                   color: Color(0xFF78350F),
//                   fontSize: 12.5,
//                   fontWeight: FontWeight.w700,
//                 )),
//           ]),
//           const SizedBox(height: 10),
//           ...tips.map((t) => Padding(
//                 padding: const EdgeInsets.only(bottom: 5),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: 4,
//                       height: 4,
//                       margin: const EdgeInsets.only(top: 6, right: 8),
//                       decoration: const BoxDecoration(
//                         color: _C.gold,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     Expanded(
//                       child: Text(t,
//                           style: const TextStyle(
//                             color: Color(0xFF92400E),
//                             fontSize: 12,
//                             height: 1.45,
//                           )),
//                     ),
//                   ],
//                 ),
//               )),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // BOTTOM SUBMIT BAR
// // ─────────────────────────────────────────────────────────────────────────────

// class _SubmitBar extends StatelessWidget {
//   final bool saving;
//   final VoidCallback onTap;
//   const _SubmitBar({required this.saving, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: _C.card,
//         border: Border(top: BorderSide(color: _C.border, width: 0.5)),
//       ),
//       padding: EdgeInsets.fromLTRB(
//         20,
//         12,
//         20,
//         MediaQuery.of(context).padding.bottom + 12,
//       ),
//       child: GestureDetector(
//         onTap: saving ? null : onTap,
//         child: AnimatedContainer(
//           duration: 160.ms,
//           height: 54,
//           decoration: BoxDecoration(
//             color: saving ? _C.darkGreen.withOpacity(0.65) : _C.darkGreen,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: saving
//                 ? []
//                 : [
//                     BoxShadow(
//                       color: _C.darkGreen.withOpacity(0.2),
//                       blurRadius: 16,
//                       offset: const Offset(0, 6),
//                     ),
//                   ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: saving
//                 ? const [
//                     SizedBox(
//                       width: 18,
//                       height: 18,
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                         strokeWidth: 2,
//                       ),
//                     ),
//                   ]
//                 : const [
//                     Icon(Icons.lock_rounded, color: Colors.white, size: 18),
//                     SizedBox(width: 8),
//                     Text('পাসওয়ার্ড পরিবর্তন করুন',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w800,
//                           fontSize: 15,
//                         )),
//                   ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────

class _C {
  static const bg = Color(0xFFF4F6F1);
  static const card = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const midGreen = Color(0xFF1B7045);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const gold = Color(0xFFD4A843);
  static const red = Color(0xFFE53935);
  static const redLight = Color(0xFFFDECEC);
  static const amber = Color(0xFFF59E0B);
  static const border = Color(0xFFE2E8E2);
  static const borderFocus = Color(0xFF0E3D22);
  static const borderError = Color(0xFFE53935);
  static const inputBg = Color(0xFFF8FAF8);
  static const inputBgFocus = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFB0BDB2);
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  final _currentFocus = FocusNode();
  final _newFocus = FocusNode();
  final _confirmFocus = FocusNode();

  String? _currentError;
  String? _newError;
  String? _confirmError;

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _saving = false;

  // strength
  int _score = 0;
  String _strengthLabel = '';
  Color _strengthColor = _C.textHint;

  @override
  void initState() {
    super.initState();
    _newCtrl.addListener(_onNewChanged);
    // repaint on focus changes
    for (final f in [_currentFocus, _newFocus, _confirmFocus]) {
      f.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    _currentFocus.dispose();
    _newFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  // ── Strength ──────────────────────────────────────────────────────────────

  void _onNewChanged() {
    final p = _newCtrl.text;
    int s = 0;
    if (p.length >= 8) s++;
    if (RegExp(r'[A-Z]').hasMatch(p)) s++;
    if (RegExp(r'[0-9]').hasMatch(p)) s++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(p)) s++;

    final (lbl, col) = switch (s) {
      0 || 1 => ('দুর্বল', _C.red),
      2 => ('মধ্যম', _C.amber),
      3 => ('ভালো', _C.green),
      _ => ('শক্তিশালী', _C.darkGreen),
    };

    // clear new-password error as user types
    if (_newError != null) _validateNew(p);

    setState(() {
      _score = s;
      _strengthLabel = p.isEmpty ? '' : lbl;
      _strengthColor = col;
    });
  }

  // ── Validators ────────────────────────────────────────────────────────────

  void _validateCurrent(String v) => setState(() {
        _currentError = v.trim().isEmpty ? 'বর্তমান পাসওয়ার্ড দিন' : null;
      });

  void _validateNew(String v) => setState(() {
        if (v.isEmpty)
          _newError = 'নতুন পাসওয়ার্ড দিন';
        else if (v.length < 8)
          _newError = 'কমপক্ষে ৮ অক্ষর হতে হবে';
        else if (v == _currentCtrl.text && v.isNotEmpty)
          _newError = 'পুরানো পাসওয়ার্ডের মতো হতে পারবে না';
        else
          _newError = null;

        // live cross-validate confirm
        if (_confirmCtrl.text.isNotEmpty) {
          _confirmError = _confirmCtrl.text != v ? 'পাসওয়ার্ড মিলছে না' : null;
        }
      });

  void _validateConfirm(String v) => setState(() {
        _confirmError = v != _newCtrl.text ? 'পাসওয়ার্ড মিলছে না' : null;
      });

  bool _validateAll() {
    _validateCurrent(_currentCtrl.text);
    _validateNew(_newCtrl.text);
    _validateConfirm(_confirmCtrl.text);
    // read fresh state after setState
    final c = _currentCtrl.text.trim().isEmpty;
    final n = _newCtrl.text.isEmpty ||
        _newCtrl.text.length < 8 ||
        _newCtrl.text == _currentCtrl.text;
    final cf = _confirmCtrl.text != _newCtrl.text;
    return !c && !n && !cf;
  }

  // ── Save ──────────────────────────────────────────────────────────────────

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_validateAll()) {
      HapticFeedback.vibrate();
      return;
    }

    setState(() => _saving = true);
    HapticFeedback.mediumImpact();

    final ok = await ref.read(authProvider.notifier).changePassword(
          _currentCtrl.text.trim(),
          _newCtrl.text.trim(),
        );

    setState(() => _saving = false);
    if (!mounted) return;

    if (ok) {
      HapticFeedback.selectionClick();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Row(children: [
          Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
          SizedBox(width: 8),
          Text('পাসওয়ার্ড সফলভাবে পরিবর্তন হয়েছে!'),
        ]),
        backgroundColor: _C.darkGreen,
        margin: const EdgeInsets.all(16),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ));
      context.pop();
    } else {
      setState(() {
        _currentError =
            ref.read(authProvider).error ?? 'বর্তমান পাসওয়ার্ড ভুল হয়েছে';
      });
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isTablet = mq.size.width > 600;
    final hPad = isTablet ? (mq.size.width - 600) / 2 + 24.0 : 24.0;
    final hasNew = _newCtrl.text.isNotEmpty;

    return Scaffold(
      backgroundColor: _C.bg,
      bottomNavigationBar: _SubmitBar(saving: _saving, onTap: _save),
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Minimal app bar ───────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: _C.darkGreen,
            surfaceTintColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            toolbarHeight: 56,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_ios_rounded,
                    color: Colors.white, size: 16),
              ),
            ),
            title: const Text('পাসওয়ার্ড পরিবর্তন',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                )),
          ),

          // ── Body ─────────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.fromLTRB(hPad, 28, hPad, 32),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page intro
                  _PageIntro().animate().fadeIn(duration: 260.ms),

                  const SizedBox(height: 32),

                  // ── Section: Current ───────────────────────────
                  _SectionLabel(label: 'বর্তমান পাসওয়ার্ড'),
                  const SizedBox(height: 8),
                  _PasswordInput(
                    controller: _currentCtrl,
                    focusNode: _currentFocus,
                    nextFocus: _newFocus,
                    hint: 'বর্তমান পাসওয়ার্ড লিখুন',
                    showText: _showCurrent,
                    error: _currentError,
                    onToggle: () =>
                        setState(() => _showCurrent = !_showCurrent),
                    onChanged: _validateCurrent,
                  ).animate().fadeIn(delay: 60.ms, duration: 260.ms),

                  const SizedBox(height: 24),

                  // ── Section: New ───────────────────────────────
                  _SectionLabel(label: 'নতুন পাসওয়ার্ড'),
                  const SizedBox(height: 8),
                  _PasswordInput(
                    controller: _newCtrl,
                    focusNode: _newFocus,
                    nextFocus: _confirmFocus,
                    hint: 'নতুন পাসওয়ার্ড লিখুন',
                    showText: _showNew,
                    error: _newError,
                    onToggle: () => setState(() => _showNew = !_showNew),
                    onChanged: _validateNew,
                  ).animate().fadeIn(delay: 100.ms, duration: 260.ms),

                  // Strength — slides in below new-password field
                  AnimatedSize(
                    duration: 220.ms,
                    curve: Curves.easeOut,
                    alignment: Alignment.topCenter,
                    child: hasNew
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: _StrengthRow(
                              score: _score,
                              label: _strengthLabel,
                              color: _strengthColor,
                              password: _newCtrl.text,
                            ).animate().fadeIn(duration: 200.ms),
                          )
                        : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 24),

                  // ── Section: Confirm ───────────────────────────
                  _SectionLabel(label: 'নতুন পাসওয়ার্ড নিশ্চিত করুন'),
                  const SizedBox(height: 8),
                  _PasswordInput(
                    controller: _confirmCtrl,
                    focusNode: _confirmFocus,
                    hint: 'আবার লিখুন',
                    showText: _showConfirm,
                    error: _confirmError,
                    onToggle: () =>
                        setState(() => _showConfirm = !_showConfirm),
                    onChanged: _validateConfirm,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _save(),
                  ).animate().fadeIn(delay: 140.ms, duration: 260.ms),

                  const SizedBox(height: 32),

                  // ── Tips ──────────────────────────────────────
                  _PasswordTips()
                      .animate()
                      .fadeIn(delay: 180.ms, duration: 260.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PAGE INTRO
// ─────────────────────────────────────────────────────────────────────────────

class _PageIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: _C.greenLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child:
            const Icon(Icons.lock_reset_rounded, color: _C.darkGreen, size: 24),
      ),
      const SizedBox(width: 14),
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('পাসওয়ার্ড বদলান',
                style: TextStyle(
                  color: _C.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                )),
            SizedBox(height: 2),
            Text('নিরাপদ থাকতে নিয়মিত পাসওয়ার্ড পরিবর্তন করুন',
                style: TextStyle(
                  color: _C.textSecondary,
                  fontSize: 12,
                  height: 1.4,
                )),
          ],
        ),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION LABEL
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: const TextStyle(
          color: _C.textSecondary,
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
        ));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PASSWORD INPUT
//
// Design rationale
// ────────────────
// • Each field is a standalone, fully rounded card — no grouping card on top.
//   This is how iOS Settings, 1Password, Google etc. handle password inputs.
// • Single border on the card that changes color: default → focus → error.
//   No inner border, no left-accent, no double-layer.
// • Floating label is replaced by an external _SectionLabel above the card
//   so the card itself stays clean and the label never overlaps content.
// • Error message sits *outside* the card below it — uses AnimatedSize so
//   the card shape NEVER changes. The error slides in smoothly.
// • onChanged triggers inline validation → error clears immediately as user
//   types a valid value.
// ─────────────────────────────────────────────────────────────────────────────

class _PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final String hint;
  final bool showText;
  final String? error;
  final VoidCallback onToggle;
  final ValueChanged<String> onChanged;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  const _PasswordInput({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.showText,
    required this.error,
    required this.onToggle,
    required this.onChanged,
    this.nextFocus,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  });

  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool get _focused => widget.focusNode.hasFocus;
  bool get _hasError => widget.error != null;
  bool get _isDone =>
      !_hasError && widget.controller.text.isNotEmpty && !_focused;

  Color get _borderColor {
    if (_hasError) return _C.borderError;
    if (_focused) return _C.borderFocus;
    return _C.border;
  }

  double get _borderWidth {
    if (_hasError) return 1.5;
    if (_focused) return 1.5;
    return 1.0;
  }

  Color get _bgColor {
    if (_hasError) return _C.redLight.withOpacity(0.35);
    if (_focused) return _C.inputBgFocus;
    return _C.inputBg;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── The input card ────────────────────────────────────────
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _borderColor,
              width: _borderWidth,
            ),
            boxShadow: _focused && !_hasError
                ? [
                    BoxShadow(
                      color: _C.darkGreen.withOpacity(0.08),
                      blurRadius: 0,
                      spreadRadius: 3,
                      offset: Offset.zero,
                    ),
                  ]
                : [],
          ),
          child: Row(children: [
            // ── Text field ──────────────────────────────────────
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                obscureText: !widget.showText,
                onChanged: widget.onChanged,
                textInputAction: widget.textInputAction,
                onSubmitted: widget.onSubmitted ??
                    (_) {
                      widget.nextFocus?.requestFocus();
                    },
                style: const TextStyle(
                  color: _C.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                  height: 1.0,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: InputBorder.none,
                  hintText: widget.hint,
                  hintStyle: const TextStyle(
                    color: _C.textHint,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),

            // ── Right side: status icon + visibility toggle ─────
            Row(mainAxisSize: MainAxisSize.min, children: [
              // Status icon — only when not focused and has content
              AnimatedSwitcher(
                duration: 160.ms,
                child: _isDone
                    ? Padding(
                        key: const ValueKey('done'),
                        padding: const EdgeInsets.only(right: 4),
                        child: const Icon(Icons.check_circle_rounded,
                            color: _C.green, size: 18),
                      )
                    : _hasError
                        ? Padding(
                            key: const ValueKey('err'),
                            padding: const EdgeInsets.only(right: 4),
                            child: const Icon(Icons.error_outline_rounded,
                                color: _C.red, size: 18),
                          )
                        : const SizedBox.shrink(key: ValueKey('none')),
              ),

              // Visibility toggle
              GestureDetector(
                onTap: widget.onToggle,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 14, 14, 14),
                  child: AnimatedSwitcher(
                    duration: 160.ms,
                    child: Icon(
                      widget.showText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      key: ValueKey(widget.showText),
                      size: 20,
                      color: _focused ? _C.darkGreen : _C.textHint,
                    ),
                  ),
                ),
              ),
            ]),
          ]),
        ),

        // ── Error message — outside the card ─────────────────────
        AnimatedSize(
          duration: 200.ms,
          curve: Curves.easeOut,
          alignment: Alignment.topLeft,
          child: widget.error != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: _C.red, size: 13),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(widget.error!,
                            style: const TextStyle(
                              color: _C.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            )),
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
// STRENGTH ROW
// ─────────────────────────────────────────────────────────────────────────────

class _StrengthRow extends StatelessWidget {
  final int score;
  final String label, password;
  final Color color;

  const _StrengthRow({
    required this.score,
    required this.label,
    required this.color,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bar + label
        Row(children: [
          Expanded(
            child: Row(
              children: List.generate(
                  4,
                  (i) => Expanded(
                        child: AnimatedContainer(
                          duration: 180.ms,
                          height: 4,
                          margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                          decoration: BoxDecoration(
                            color: i < score ? color : _C.border,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      )),
            ),
          ),
          const SizedBox(width: 10),
          AnimatedDefaultTextStyle(
            duration: 200.ms,
            style: TextStyle(
              color: color,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
            child: Text(label),
          ),
        ]),

        const SizedBox(height: 10),

        // Criteria chips
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _Chip(label: '৮+ অক্ষর', met: password.length >= 8),
            _Chip(
                label: 'বড় হাতের অক্ষর',
                met: RegExp(r'[A-Z]').hasMatch(password)),
            _Chip(label: 'সংখ্যা', met: RegExp(r'[0-9]').hasMatch(password)),
            _Chip(
                label: 'বিশেষ চিহ্ন',
                met: RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)),
          ],
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool met;
  const _Chip({required this.label, required this.met});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 200.ms,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: met ? _C.greenLight : _C.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: met ? _C.green.withOpacity(0.4) : _C.border,
        ),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        AnimatedSwitcher(
          duration: 160.ms,
          child: Icon(
            met ? Icons.check_rounded : Icons.remove_rounded,
            key: ValueKey(met),
            size: 12,
            color: met ? _C.green : _C.textHint,
          ),
        ),
        const SizedBox(width: 5),
        Text(label,
            style: TextStyle(
              color: met ? _C.darkGreen : _C.textHint,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            )),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PASSWORD TIPS
// ─────────────────────────────────────────────────────────────────────────────

class _PasswordTips extends StatelessWidget {
  const _PasswordTips();

  @override
  Widget build(BuildContext context) {
    const tips = [
      'কমপক্ষে ৮টি অক্ষর ব্যবহার করুন',
      'বড় হাতের ও ছোট হাতের অক্ষর মিলিয়ে লিখুন',
      r'সংখ্যা ও বিশেষ চিহ্ন (!@#$) যোগ করুন',
      'নিজের নাম বা জন্মতারিখ ব্যবহার করবেন না',
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.gold.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Text('💡', style: TextStyle(fontSize: 14)),
            SizedBox(width: 7),
            Text('শক্তিশালী পাসওয়ার্ডের নিয়ম',
                style: TextStyle(
                  color: Color(0xFF78350F),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                )),
          ]),
          const SizedBox(height: 10),
          ...tips.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(top: 6, right: 8),
                      decoration: const BoxDecoration(
                        color: _C.gold,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(t,
                          style: const TextStyle(
                            color: Color(0xFF92400E),
                            fontSize: 12,
                            height: 1.45,
                          )),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM SUBMIT BAR
// ─────────────────────────────────────────────────────────────────────────────

class _SubmitBar extends StatelessWidget {
  final bool saving;
  final VoidCallback onTap;
  const _SubmitBar({required this.saving, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _C.card,
        border: Border(top: BorderSide(color: _C.border, width: 0.5)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      child: GestureDetector(
        onTap: saving ? null : onTap,
        child: AnimatedContainer(
          duration: 160.ms,
          height: 54,
          decoration: BoxDecoration(
            color: saving ? _C.darkGreen.withOpacity(0.65) : _C.darkGreen,
            borderRadius: BorderRadius.circular(16),
            boxShadow: saving
                ? []
                : [
                    BoxShadow(
                      color: _C.darkGreen.withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: saving
                ? const [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ]
                : const [
                    Icon(Icons.lock_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('পাসওয়ার্ড পরিবর্তন করুন',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        )),
                  ],
          ),
        ),
      ),
    );
  }
}
