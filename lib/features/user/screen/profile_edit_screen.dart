// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../../auth/providers/auth_provider.dart';
// import '../../tracker/providers/tracker_provider.dart';

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
//   static const goldLight = Color(0xFFFFF8E7);
//   static const red = Color(0xFFEF4444);
//   static const redLight = Color(0xFFFEF2F2);
//   static const border = Color(0xFFE4EAE4);
//   static const borderFocus = Color(0xFF0E3D22);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
//   static const inputBg = Color(0xFFF8FAF8);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// class ProfileEditScreen extends ConsumerStatefulWidget {
//   const ProfileEditScreen({super.key});

//   @override
//   ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
// }

// class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
//   final _formKey = GlobalKey<FormState>();

//   late final TextEditingController _nameCtrl;
//   late final TextEditingController _phoneCtrl;
//   late final TextEditingController _departmentCtrl;
//   late final TextEditingController _designationCtrl;

//   bool _saving = false;
//   bool _hasChanges = false;

//   @override
//   void initState() {
//     super.initState();
//     final user = ref.read(currentUserProvider);
//     _nameCtrl = TextEditingController(text: user?.name ?? '');
//     _phoneCtrl = TextEditingController(text: user?.phone ?? '');
//     _departmentCtrl = TextEditingController(text: user?.department ?? '');
//     _designationCtrl = TextEditingController(text: user?.designation ?? '');

//     // Track changes
//     for (final c in [
//       _nameCtrl,
//       _phoneCtrl,
//       _departmentCtrl,
//       _designationCtrl
//     ]) {
//       c.addListener(() => setState(() => _hasChanges = true));
//     }
//   }

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _phoneCtrl.dispose();
//     _departmentCtrl.dispose();
//     _designationCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _save() async {
//     if (!(_formKey.currentState?.validate() ?? false)) return;
//     if (!_hasChanges) {
//       context.pop();
//       return;
//     }

//     setState(() => _saving = true);
//     HapticFeedback.mediumImpact();

//     // Call your profile update API here
//     // final ok = await ref.read(authProvider.notifier).updateProfile(...);
//     await Future.delayed(const Duration(milliseconds: 800)); // placeholder
//     final ok = true;

//     setState(() => _saving = false);

//     if (ok && mounted) {
//       HapticFeedback.selectionClick();
//       await ref.read(authProvider.notifier).refreshProfile();
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Row(children: [
//               Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
//               SizedBox(width: 8),
//               Text('প্রোফাইল আপডেট হয়েছে!'),
//             ]),
//             backgroundColor: _C.darkGreen,
//             margin: const EdgeInsets.all(16),
//             behavior: SnackBarBehavior.floating,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//         context.pop();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = ref.watch(currentUserProvider);
//     final progress = ref.watch(progressSummaryProvider);
//     final totalPts =
//         progress.whenOrNull(data: (s) => s.currentMonth?.totalPoints) ?? 0;
//     final daysCompleted =
//         progress.whenOrNull(data: (s) => s.currentMonth?.daysCompleted) ?? 0;
//     final isFemale = user?.gender?.toLowerCase() == 'female';
//     final name = user?.name ?? 'ব্যবহারকারী';
//     final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

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
//             title: const Text(
//               'প্রোফাইল সম্পাদনা',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w800,
//                 letterSpacing: -0.3,
//               ),
//             ),
//             actions: [
//               if (_hasChanges)
//                 GestureDetector(
//                   onTap: _saving ? null : _save,
//                   child: Container(
//                     margin: const EdgeInsets.fromLTRB(0, 10, 14, 10),
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: _C.gold,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: _saving
//                         ? const SizedBox(
//                             width: 14,
//                             height: 14,
//                             child: CircularProgressIndicator(
//                                 color: Colors.white, strokeWidth: 2))
//                         : const Text(
//                             'সেভ',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 13,
//                             ),
//                           ),
//                   ),
//                 ).animate().fadeIn(duration: 200.ms).slideX(begin: 0.2),
//             ],
//           ),

//           SliverToBoxAdapter(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   // ── Avatar hero ───────────────────────────────────
//                   _AvatarHero(
//                     initial: initial,
//                     name: name,
//                     email: user?.email,
//                     serialId: user?.serialId,
//                     district: user?.district,
//                     gender: user?.gender,
//                   ),

//                   // ── Stats ribbon ──────────────────────────────────
//                   _StatsRibbon(
//                     totalPts: totalPts,
//                     daysCompleted: daysCompleted,
//                     isFemale: isFemale,
//                   ),

//                   // ── Form fields ───────────────────────────────────
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _FormSection(
//                           label: 'ব্যক্তিগত তথ্য',
//                           children: [
//                             _FieldItem(
//                               label: 'পুরো নাম',
//                               hint: 'আপনার নাম লিখুন',
//                               controller: _nameCtrl,
//                               icon: Icons.person_outline_rounded,
//                               required: true,
//                               validator: (v) => (v?.trim().isEmpty ?? true)
//                                   ? 'নাম আবশ্যক'
//                                   : null,
//                             ),
//                             _FieldItem(
//                               label: 'ফোন নম্বর',
//                               hint: '০১XXXXXXXXX',
//                               controller: _phoneCtrl,
//                               icon: Icons.phone_outlined,
//                               keyboardType: TextInputType.phone,
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 14),

//                         _FormSection(
//                           label: 'পেশাদার তথ্য',
//                           children: [
//                             _FieldItem(
//                               label: 'বিভাগ / দল',
//                               hint: 'যেমন: IT, Finance, Admin',
//                               controller: _departmentCtrl,
//                               icon: Icons.business_outlined,
//                             ),
//                             _FieldItem(
//                               label: 'পদবী',
//                               hint: 'যেমন: Manager, Officer',
//                               controller: _designationCtrl,
//                               icon: Icons.badge_outlined,
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 14),

//                         // Read-only info
//                         _FormSection(
//                           label: 'স্থায়ী তথ্য (পরিবর্তনযোগ্য নয়)',
//                           children: [
//                             _ReadonlyField(
//                               label: 'ইমেইল',
//                               value: user?.email ?? '-',
//                               icon: Icons.email_outlined,
//                             ),
//                             _ReadonlyField(
//                               label: 'জেলা',
//                               value: user?.district ?? '-',
//                               icon: Icons.location_on_outlined,
//                             ),
//                             if (user?.serialId != null)
//                               _ReadonlyField(
//                                 label: 'সিরিয়াল আইডি',
//                                 value: user!.serialId.toString(),
//                                 icon: Icons.tag_rounded,
//                               ),
//                             _ReadonlyField(
//                               label: 'লিঙ্গ',
//                               value: isFemale
//                                   ? 'মহিলা 🌸'
//                                   : user?.gender == 'male'
//                                       ? 'পুরুষ'
//                                       : user?.gender ?? '-',
//                               icon: Icons.person_pin_outlined,
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 24),

//                         // Save button (bottom)
//                         if (_hasChanges)
//                           _SaveButton(
//                             saving: _saving,
//                             onTap: _save,
//                           )
//                               .animate()
//                               .fadeIn(duration: 220.ms)
//                               .slideY(begin: 0.1),

//                         SizedBox(
//                             height: MediaQuery.of(context).padding.bottom + 32),
//                       ],
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
// // AVATAR HERO
// // ─────────────────────────────────────────────────────────────────────────────

// class _AvatarHero extends StatelessWidget {
//   final String initial, name;
//   final String? email, serialId, district, gender;

//   const _AvatarHero({
//     required this.initial,
//     required this.name,
//     this.email,
//     this.serialId,
//     this.district,
//     this.gender,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       color: _C.darkGreen,
//       padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
//       child: Column(
//         children: [
//           // Avatar with edit ring
//           Stack(
//             alignment: Alignment.bottomRight,
//             children: [
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(22),
//                   border: Border.all(
//                       color: Colors.white.withOpacity(0.3), width: 2),
//                 ),
//                 child: Center(
//                   child: Text(
//                     initial,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 32,
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                 ),
//               ),
//               // Camera icon badge
//               Container(
//                 width: 26,
//                 height: 26,
//                 decoration: BoxDecoration(
//                   color: _C.gold,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: _C.darkGreen, width: 2),
//                 ),
//                 child: const Icon(Icons.camera_alt_rounded,
//                     color: Colors.white, size: 12),
//               ),
//             ],
//           ),

//           const SizedBox(height: 12),

//           Text(
//             name,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.w800,
//               letterSpacing: -0.4,
//             ),
//           ),

//           if (email != null) ...[
//             const SizedBox(height: 2),
//             Text(
//               email!,
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.5),
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // STATS RIBBON  — quick at-a-glance amal stats
// // ─────────────────────────────────────────────────────────────────────────────

// class _StatsRibbon extends StatelessWidget {
//   final int totalPts, daysCompleted;
//   final bool isFemale;

//   const _StatsRibbon({
//     required this.totalPts,
//     required this.daysCompleted,
//     required this.isFemale,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 16, 16, 2),
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: _RibbonStat(
//               emoji: '⭐',
//               value: '$totalPts',
//               label: 'মাসের পয়েন্ট',
//             ),
//           ),
//           Container(width: 0.5, height: 36, color: _C.border),
//           Expanded(
//             child: _RibbonStat(
//               emoji: '📅',
//               value: '$daysCompleted',
//               label: 'সম্পন্ন দিন',
//             ),
//           ),
//           if (isFemale) ...[
//             Container(width: 0.5, height: 36, color: _C.border),
//             Expanded(
//               child: _RibbonStat(
//                 emoji: '🌸',
//                 value: 'সক্রিয়',
//                 label: 'মাহলি মোড',
//                 valueColor: _C.midGreen,
//               ),
//             ),
//           ],
//         ],
//       ),
//     ).animate().fadeIn(delay: 80.ms).slideY(begin: 0.06);
//   }
// }

// class _RibbonStat extends StatelessWidget {
//   final String emoji, value, label;
//   final Color? valueColor;

//   const _RibbonStat({
//     required this.emoji,
//     required this.value,
//     required this.label,
//     this.valueColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(emoji, style: const TextStyle(fontSize: 18)),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             color: valueColor ?? _C.textPrimary,
//             fontSize: 16,
//             fontWeight: FontWeight.w800,
//             letterSpacing: -0.3,
//           ),
//         ),
//         Text(
//           label,
//           style: const TextStyle(color: _C.textHint, fontSize: 10),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // FORM SECTION
// // ─────────────────────────────────────────────────────────────────────────────

// class _FormSection extends StatelessWidget {
//   final String label;
//   final List<Widget> children;

//   const _FormSection({required this.label, required this.children});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 2, bottom: 8),
//           child: Text(
//             label.toUpperCase(),
//             style: const TextStyle(
//               color: _C.textHint,
//               fontSize: 10,
//               fontWeight: FontWeight.w700,
//               letterSpacing: 0.7,
//             ),
//           ),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             color: _C.card,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.border, width: 0.5),
//           ),
//           child: Column(
//             children: List.generate(children.length, (i) {
//               return Column(
//                 children: [
//                   children[i],
//                   if (i < children.length - 1)
//                     const Divider(
//                         height: 0.5,
//                         thickness: 0.5,
//                         color: _C.border,
//                         indent: 52),
//                 ],
//               );
//             }),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // FIELD ITEM  — editable text field
// // ─────────────────────────────────────────────────────────────────────────────

// class _FieldItem extends StatefulWidget {
//   final String label, hint;
//   final TextEditingController controller;
//   final IconData icon;
//   final bool required;
//   final TextInputType keyboardType;
//   final String? Function(String?)? validator;

//   const _FieldItem({
//     required this.label,
//     required this.hint,
//     required this.controller,
//     required this.icon,
//     this.required = false,
//     this.keyboardType = TextInputType.text,
//     this.validator,
//   });

//   @override
//   State<_FieldItem> createState() => _FieldItemState();
// }

// class _FieldItemState extends State<_FieldItem> {
//   bool _focused = false;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Icon
//           Container(
//             width: 34,
//             height: 34,
//             decoration: BoxDecoration(
//               color: _focused ? _C.greenLight : _C.bg,
//               borderRadius: BorderRadius.circular(9),
//             ),
//             child: Icon(
//               widget.icon,
//               size: 17,
//               color: _focused ? _C.darkGreen : _C.textHint,
//             ),
//           ),
//           const SizedBox(width: 12),

//           // Label + field stacked
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       widget.label,
//                       style: const TextStyle(
//                         color: _C.textSecondary,
//                         fontSize: 10.5,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     if (widget.required)
//                       const Text(' *',
//                           style: TextStyle(color: _C.red, fontSize: 10)),
//                   ],
//                 ),
//                 Focus(
//                   onFocusChange: (f) => setState(() => _focused = f),
//                   child: TextFormField(
//                     controller: widget.controller,
//                     keyboardType: widget.keyboardType,
//                     validator: widget.validator,
//                     style: const TextStyle(
//                       color: _C.textPrimary,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     decoration: InputDecoration(
//                       isDense: true,
//                       contentPadding:
//                           const EdgeInsets.only(top: 15, bottom: 15, left: 9),
//                       border: InputBorder.none,
//                       hintText: widget.hint,
//                       hintStyle: const TextStyle(
//                         color: _C.textHint,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w400,
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

// // ─────────────────────────────────────────────────────────────────────────────
// // READONLY FIELD
// // ─────────────────────────────────────────────────────────────────────────────

// class _ReadonlyField extends StatelessWidget {
//   final String label, value;
//   final IconData icon;

//   const _ReadonlyField({
//     required this.label,
//     required this.value,
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       child: Row(
//         children: [
//           Container(
//             width: 34,
//             height: 34,
//             decoration: BoxDecoration(
//               color: _C.bg,
//               borderRadius: BorderRadius.circular(9),
//             ),
//             child: Icon(icon, size: 17, color: _C.textHint),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: const TextStyle(
//                     color: _C.textHint,
//                     fontSize: 10.5,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 1),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     color: _C.textSecondary,
//                     fontSize: 13.5,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
//             decoration: BoxDecoration(
//               color: _C.bg,
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: const Text(
//               'লক',
//               style: TextStyle(
//                 color: _C.textHint,
//                 fontSize: 9,
//                 fontWeight: FontWeight.w600,
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
//               const Icon(Icons.check_rounded, color: Colors.white, size: 18),
//               const SizedBox(width: 8),
//               const Text(
//                 'পরিবর্তন সেভ করুন',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 15,
//                 ),
//               ),
//             ],
//           ],
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
// import '../../auth/providers/auth_provider.dart';
// import '../../tracker/providers/tracker_provider.dart';

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
//   static const goldLight = Color(0xFFFFF8E7);
//   static const red = Color(0xFFEF4444);
//   static const redLight = Color(0xFFFEF2F2);
//   static const border = Color(0xFFE4EAE4);
//   static const borderMid = Color(0xFFD0DAD2);
//   static const borderFocus = Color(0xFF0E3D22);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
//   static const inputBg = Color(0xFFF8FAF8);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DISTRICTS
// // ─────────────────────────────────────────────────────────────────────────────

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
//   'চুয়াডাঙ্গা',
// ];

// // ─────────────────────────────────────────────────────────────────────────────
// // SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// class ProfileEditScreen extends ConsumerStatefulWidget {
//   const ProfileEditScreen({super.key});

//   @override
//   ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
// }

// class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
//   final _formKey = GlobalKey<FormState>();

//   late final TextEditingController _nameCtrl;
//   late final TextEditingController _phoneCtrl;

//   bool _saving = false;
//   bool _hasChanges = false;

//   String? _selectedDistrict;
//   String? _originalDistrict;

//   @override
//   void initState() {
//     super.initState();
//     final user = ref.read(currentUserProvider);

//     _nameCtrl = TextEditingController(text: user?.name ?? '');
//     _phoneCtrl = TextEditingController(text: user?.phone ?? '');

//     _selectedDistrict = user?.district;
//     _originalDistrict = user?.district;

//     // Track text-field changes
//     for (final c in [_nameCtrl, _phoneCtrl]) {
//       c.addListener(() => setState(() => _hasChanges = true));
//     }
//   }

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _phoneCtrl.dispose();
//     super.dispose();
//   }

//   // ── District picker ────────────────────────────────────────────────────────

//   Future<void> _openDistrictPicker() async {
//     final result = await showModalBottomSheet<String>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _DistrictPickerSheet(
//         selectedDistrict: _selectedDistrict,
//         districts: _bangladeshDistricts,
//       ),
//     );
//     if (result != null && result != _selectedDistrict) {
//       setState(() {
//         _selectedDistrict = result;
//         _hasChanges = true;
//       });
//     }
//   }

//   void _clearDistrict() {
//     setState(() {
//       _selectedDistrict = null;
//       _hasChanges = _selectedDistrict != _originalDistrict ||
//           _nameCtrl.text != ref.read(currentUserProvider)?.name ||
//           _phoneCtrl.text != ref.read(currentUserProvider)?.phone;
//     });
//   }

//   // ── Save ───────────────────────────────────────────────────────────────────

//   Future<void> _save() async {
//     // Validate form
//     if (!(_formKey.currentState?.validate() ?? false)) return;

//     // If no changes, just close
//     if (!_hasChanges) {
//       if (mounted) context.pop();
//       return;
//     }

//     setState(() => _saving = true);
//     HapticFeedback.mediumImpact();

//     try {
//       // Call update profile API
//       final success = await ref.read(authProvider.notifier).updateProfile({
//         'name': _nameCtrl.text.trim(),
//         'phone': _phoneCtrl.text.trim(),
//         'district': _selectedDistrict,
//       });

//       if (!mounted) return;

//       if (success) {
//         // Success - haptic feedback
//         HapticFeedback.selectionClick();

//         // Refresh profile data from server
//         await ref.read(authProvider.notifier).refreshProfile();

//         if (!mounted) return;

//         // Show success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Row(
//               children: [
//                 Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     'প্রোফাইল সফলভাবে আপডেট হয়েছে',
//                     style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
//                   ),
//                 ),
//               ],
//             ),
//             backgroundColor: _C.darkGreen,
//             margin: const EdgeInsets.all(16),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             duration: const Duration(seconds: 2),
//           ),
//         );

//         // Close the page after a short delay for smooth animation
//         await Future.delayed(const Duration(milliseconds: 300));
//         if (mounted) {
//           context.pop(true); // Return true to indicate success
//         }
//       } else {
//         // API failed but didn't throw exception
//         if (mounted) {
//           _showErrorSnackBar('প্রোফাইল আপডেট করতে ব্যর্থ হয়েছে');
//         }
//       }
//     } catch (e) {
//       // Handle any unexpected errors
//       if (mounted) {
//         _showErrorSnackBar('একটি সমস্যা হয়েছে। আবার চেষ্টা করুন');
//         print('Profile update error: $e');
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _saving = false);
//       }
//     }
//   }

// // Helper method to show error message
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.error_outline_rounded,
//                 color: Colors.white, size: 18),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 message,
//                 style:
//                     const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: _C.red,
//         margin: const EdgeInsets.all(16),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   // ── Build ──────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     final user = ref.watch(currentUserProvider);
//     final progress = ref.watch(progressSummaryProvider);
//     final totalPts =
//         progress.whenOrNull(data: (s) => s.currentMonth?.totalPoints) ?? 0;
//     final daysCompleted =
//         progress.whenOrNull(data: (s) => s.currentMonth?.daysCompleted) ?? 0;
//     final isFemale = user?.gender?.toLowerCase() == 'female';
//     final name = user?.name ?? 'ব্যবহারকারী';
//     final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

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
//             title: const Text(
//               'প্রোফাইল সম্পাদনা',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w800,
//                 letterSpacing: -0.3,
//               ),
//             ),
//             actions: [
//               GestureDetector(
//                 onTap:
//                     (_saving || !_hasChanges) ? null : _save, // 👈 main change
//                 child: Container(
//                   margin: const EdgeInsets.fromLTRB(0, 10, 14, 10),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: (_saving || !_hasChanges)
//                         ? _C.gold.withOpacity(0.4) // 👈 disabled: transparent
//                         : _C.gold, // 👈 enabled: full color
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: _saving
//                       ? const SizedBox(
//                           width: 14,
//                           height: 14,
//                           child: CircularProgressIndicator(
//                               color: Colors.white, strokeWidth: 2),
//                         )
//                       : !_hasChanges // 👈 new condition
//                           ? const Icon(
//                               Icons.check_rounded,
//                               color: Colors.white70,
//                               size: 16,
//                             )
//                           : const Text(
//                               'সেভ',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 13,
//                               ),
//                             ),
//                 ),
//               ).animate().fadeIn(duration: 200.ms).slideX(begin: 0.2),
//             ],
//           ),

//           SliverToBoxAdapter(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   // ── Avatar hero ────────────────────────────────────
//                   _AvatarHero(
//                     initial: initial,
//                     name: name,
//                     email: user?.email,
//                     serialId: user?.serialId,
//                   ),

//                   // ── Stats ribbon ───────────────────────────────────
//                   _StatsRibbon(
//                     totalPts: totalPts,
//                     daysCompleted: daysCompleted,
//                     isFemale: isFemale,
//                   ),

//                   // ── Form fields ────────────────────────────────────
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // ── Personal info ──────────────────────────
//                         _FormSection(
//                           label: 'ব্যক্তিগত তথ্য',
//                           children: [
//                             _FieldItem(
//                               label: 'পুরো নাম',
//                               hint: 'আপনার নাম লিখুন',
//                               controller: _nameCtrl,
//                               icon: Icons.person_outline_rounded,
//                               required: true,
//                               validator: (v) => (v?.trim().isEmpty ?? true)
//                                   ? 'নাম আবশ্যক'
//                                   : null,
//                             ),
//                             _FieldItem(
//                               label: 'ফোন নম্বর',
//                               hint: '০১XXXXXXXXX',
//                               controller: _phoneCtrl,
//                               icon: Icons.phone_outlined,
//                               keyboardType: TextInputType.phone,
//                             ),
//                             // ── District picker row ──────────────
//                             _DistrictFieldItem(
//                               selectedDistrict: _selectedDistrict,
//                               onTap: _openDistrictPicker,
//                               onClear: _clearDistrict,
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 14),

//                         // ── Read-only info ─────────────────────────
//                         _FormSection(
//                           label: 'স্থায়ী তথ্য (পরিবর্তনযোগ্য নয়)',
//                           children: [
//                             _ReadonlyField(
//                               label: 'ইমেইল',
//                               value: user?.email ?? '-',
//                               icon: Icons.email_outlined,
//                             ),
//                             _ReadonlyField(
//                               label: 'লিঙ্গ',
//                               value: isFemale
//                                   ? 'মহিলা 🌸'
//                                   : user?.gender == 'male'
//                                       ? 'পুরুষ'
//                                       : user?.gender ?? '-',
//                               icon: Icons.person_pin_outlined,
//                             ),
//                             if (user?.serialId != null)
//                               _ReadonlyField(
//                                 label: 'সিরিয়াল আইডি',
//                                 value: '#${user!.serialId}',
//                                 icon: Icons.tag_rounded,
//                               ),
//                           ],
//                         ),

//                         const SizedBox(height: 24),

//                         // ── Save button (bottom) ───────────────────

//                         _SaveButton(
//                           saving: _saving,
//                           onTap: _save,
//                           hasChanges: _hasChanges,
//                         ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.1),

//                         SizedBox(
//                           height: MediaQuery.of(context).padding.bottom + 32,
//                         ),
//                       ],
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
// // AVATAR HERO  — serial ID shown below name
// // ─────────────────────────────────────────────────────────────────────────────

// class _AvatarHero extends StatelessWidget {
//   final String initial, name;
//   final String? email;
//   final dynamic serialId; // int or String

//   const _AvatarHero({
//     required this.initial,
//     required this.name,
//     this.email,
//     this.serialId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       color: _C.darkGreen,
//       padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
//       child: Column(
//         children: [
//           // Avatar with camera badge
//           Stack(
//             alignment: Alignment.bottomRight,
//             children: [
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(22),
//                   border: Border.all(
//                       color: Colors.white.withOpacity(0.3), width: 2),
//                 ),
//                 child: Center(
//                   child: Text(
//                     initial,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 32,
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 26,
//                 height: 26,
//                 decoration: BoxDecoration(
//                   color: _C.gold,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: _C.darkGreen, width: 2),
//                 ),
//                 child: const Icon(Icons.camera_alt_rounded,
//                     color: Colors.white, size: 12),
//               ),
//             ],
//           ),

//           const SizedBox(height: 12),

//           // Name
//           Text(
//             name,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.w800,
//               letterSpacing: -0.4,
//             ),
//           ),

//           // Serial ID — shown directly under name
//           if (serialId != null) ...[
//             const SizedBox(height: 4),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.12),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                     color: Colors.white.withOpacity(0.2), width: 0.5),
//               ),
//               child: Text(
//                 '#$serialId',
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.75),
//                   fontSize: 11,
//                   fontWeight: FontWeight.w600,
//                   letterSpacing: 0.3,
//                 ),
//               ),
//             ),
//           ],

//           // Email — below ID
//           if (email != null) ...[
//             const SizedBox(height: 5),
//             Text(
//               email!,
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.45),
//                 fontSize: 11.5,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DISTRICT FIELD ITEM  — tap-to-open, styled to match _FieldItem card rows
// // ─────────────────────────────────────────────────────────────────────────────

// class _DistrictFieldItem extends StatelessWidget {
//   final String? selectedDistrict;
//   final VoidCallback onTap;
//   final VoidCallback onClear;

//   const _DistrictFieldItem({
//     required this.selectedDistrict,
//     required this.onTap,
//     required this.onClear,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final hasValue = selectedDistrict != null && selectedDistrict!.isNotEmpty;

//     return GestureDetector(
//       onTap: onTap,
//       behavior: HitTestBehavior.opaque,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//         child: Row(
//           children: [
//             // Icon box — mirrors _FieldItem style
//             Container(
//               width: 34,
//               height: 34,
//               decoration: BoxDecoration(
//                 color: hasValue ? _C.greenLight : _C.bg,
//                 borderRadius: BorderRadius.circular(9),
//               ),
//               child: Icon(
//                 Icons.location_city_rounded,
//                 size: 17,
//                 color: hasValue ? _C.darkGreen : _C.textHint,
//               ),
//             ),
//             const SizedBox(width: 12),

//             // Label + value
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'জেলা',
//                     style: TextStyle(
//                       color: _C.textSecondary,
//                       fontSize: 10.5,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     hasValue ? selectedDistrict! : 'জেলা নির্বাচন করুন',
//                     style: TextStyle(
//                       color: hasValue ? _C.textPrimary : _C.textHint,
//                       fontSize: hasValue ? 14 : 13,
//                       fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Clear or chevron
//             if (hasValue)
//               GestureDetector(
//                 onTap: onClear,
//                 child: Container(
//                   width: 26,
//                   height: 26,
//                   decoration: BoxDecoration(
//                     color: _C.bg,
//                     borderRadius: BorderRadius.circular(7),
//                   ),
//                   child: const Icon(Icons.close_rounded,
//                       size: 14, color: _C.textHint),
//                 ),
//               )
//             else
//               const Icon(Icons.keyboard_arrow_down_rounded,
//                   size: 20, color: _C.textHint),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DISTRICT PICKER BOTTOM SHEET  — searchable list
// // ─────────────────────────────────────────────────────────────────────────────

// class _DistrictPickerSheet extends StatefulWidget {
//   final String? selectedDistrict;
//   final List<String> districts;

//   const _DistrictPickerSheet({
//     required this.selectedDistrict,
//     required this.districts,
//   });

//   @override
//   State<_DistrictPickerSheet> createState() => _DistrictPickerSheetState();
// }

// class _DistrictPickerSheetState extends State<_DistrictPickerSheet> {
//   final _searchCtrl = TextEditingController();
//   final _searchFocus = FocusNode();
//   List<String> _filtered = [];

//   @override
//   void initState() {
//     super.initState();
//     _filtered = List.from(widget.districts);
//     _searchCtrl.addListener(_onSearch);
//     WidgetsBinding.instance
//         .addPostFrameCallback((_) => _searchFocus.requestFocus());
//   }

//   @override
//   void dispose() {
//     _searchCtrl.removeListener(_onSearch);
//     _searchCtrl.dispose();
//     _searchFocus.dispose();
//     super.dispose();
//   }

//   void _onSearch() {
//     final q = _searchCtrl.text.trim();
//     setState(() {
//       _filtered = q.isEmpty
//           ? List.from(widget.districts)
//           : widget.districts.where((d) => d.contains(q)).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bottomInset = MediaQuery.of(context).viewInsets.bottom;

//     return Container(
//       margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Handle
//           const SizedBox(height: 12),
//           Container(
//             width: 36,
//             height: 4,
//             decoration: BoxDecoration(
//               color: _C.borderMid,
//               borderRadius: BorderRadius.circular(99),
//             ),
//           ),
//           const SizedBox(height: 16),

//           // Title row
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               children: [
//                 Container(
//                   width: 34,
//                   height: 34,
//                   decoration: BoxDecoration(
//                     color: _C.greenLight,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Icon(Icons.location_city_rounded,
//                       color: _C.darkGreen, size: 18),
//                 ),
//                 const SizedBox(width: 10),
//                 const Expanded(
//                   child: Text(
//                     'জেলা নির্বাচন করুন',
//                     style: TextStyle(
//                       color: _C.textPrimary,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () => Navigator.of(context).pop(),
//                   child: Container(
//                     width: 32,
//                     height: 32,
//                     decoration: BoxDecoration(
//                       color: _C.inputBg,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: _C.border),
//                     ),
//                     child: const Icon(Icons.close_rounded,
//                         size: 16, color: _C.textSecondary),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 14),

//           // Search box
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: TextField(
//               controller: _searchCtrl,
//               focusNode: _searchFocus,
//               style: const TextStyle(
//                   color: _C.textPrimary,
//                   fontSize: 14.5,
//                   fontWeight: FontWeight.w500),
//               decoration: InputDecoration(
//                 hintText: 'জেলার নাম লিখুন...',
//                 hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
//                 prefixIcon: const Icon(Icons.search_rounded,
//                     size: 20, color: _C.textSecondary),
//                 filled: true,
//                 fillColor: _C.inputBg,
//                 contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: _C.border),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: _C.border, width: 1),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: _C.darkGreen, width: 1.5),
//                 ),
//                 suffixIcon: _searchCtrl.text.isNotEmpty
//                     ? GestureDetector(
//                         onTap: () {
//                           _searchCtrl.clear();
//                           _searchFocus.requestFocus();
//                         },
//                         child: const Icon(Icons.close_rounded,
//                             size: 18, color: _C.textSecondary),
//                       )
//                     : null,
//               ),
//             ),
//           ),

//           const SizedBox(height: 8),
//           const Divider(height: 1, thickness: 0.5, color: _C.border),

//           // District list
//           ConstrainedBox(
//             constraints: BoxConstraints(
//               maxHeight:
//                   MediaQuery.of(context).size.height * 0.45 - bottomInset,
//             ),
//             child: _filtered.isEmpty
//                 ? Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 32),
//                     child: Column(
//                       children: const [
//                         Icon(Icons.search_off_rounded,
//                             size: 40, color: _C.textHint),
//                         SizedBox(height: 10),
//                         Text(
//                           'কোনো জেলা পাওয়া যায়নি',
//                           style:
//                               TextStyle(color: _C.textSecondary, fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   )
//                 : ListView.builder(
//                     padding: EdgeInsets.only(top: 4, bottom: 16 + bottomInset),
//                     itemCount: _filtered.length,
//                     itemBuilder: (ctx, i) {
//                       final district = _filtered[i];
//                       final isSelected = district == widget.selectedDistrict;

//                       return InkWell(
//                         onTap: () => Navigator.of(context).pop(district),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 13),
//                           color:
//                               isSelected ? _C.greenLight : Colors.transparent,
//                           child: Row(
//                             children: [
//                               isSelected
//                                   ? const Icon(Icons.check_circle_rounded,
//                                       size: 18, color: _C.darkGreen)
//                                   : const Icon(
//                                       Icons.radio_button_unchecked_rounded,
//                                       size: 18,
//                                       color: _C.borderMid),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Text(
//                                   district,
//                                   style: TextStyle(
//                                     color: isSelected
//                                         ? _C.darkGreen
//                                         : _C.textPrimary,
//                                     fontSize: 14.5,
//                                     fontWeight: isSelected
//                                         ? FontWeight.w700
//                                         : FontWeight.w400,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // STATS RIBBON
// // ─────────────────────────────────────────────────────────────────────────────

// class _StatsRibbon extends StatelessWidget {
//   final int totalPts, daysCompleted;
//   final bool isFemale;

//   const _StatsRibbon({
//     required this.totalPts,
//     required this.daysCompleted,
//     required this.isFemale,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 16, 16, 2),
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: _RibbonStat(
//               emoji: '⭐',
//               value: '$totalPts',
//               label: 'মাসের পয়েন্ট',
//             ),
//           ),
//           Container(width: 0.5, height: 36, color: _C.border),
//           Expanded(
//             child: _RibbonStat(
//               emoji: '📅',
//               value: '$daysCompleted',
//               label: 'সম্পন্ন দিন',
//             ),
//           ),
//           // if (isFemale) ...[
//           //   Container(width: 0.5, height: 36, color: _C.border),
//           //   Expanded(
//           //     child: _RibbonStat(
//           //       emoji: '🌸',
//           //       value: 'সক্রিয়',
//           //       label: 'মাহলি মোড',
//           //       valueColor: _C.midGreen,
//           //     ),
//           //   ),
//           // ],
//         ],
//       ),
//     ).animate().fadeIn(delay: 80.ms).slideY(begin: 0.06);
//   }
// }

// class _RibbonStat extends StatelessWidget {
//   final String emoji, value, label;
//   final Color? valueColor;

//   const _RibbonStat({
//     required this.emoji,
//     required this.value,
//     required this.label,
//     this.valueColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(emoji, style: const TextStyle(fontSize: 18)),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             color: valueColor ?? _C.textPrimary,
//             fontSize: 16,
//             fontWeight: FontWeight.w800,
//             letterSpacing: -0.3,
//           ),
//         ),
//         Text(label, style: const TextStyle(color: _C.textHint, fontSize: 10)),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // FORM SECTION
// // ─────────────────────────────────────────────────────────────────────────────

// class _FormSection extends StatelessWidget {
//   final String label;
//   final List<Widget> children;

//   const _FormSection({required this.label, required this.children});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 2, bottom: 8),
//           child: Text(
//             label.toUpperCase(),
//             style: const TextStyle(
//               color: _C.textHint,
//               fontSize: 10,
//               fontWeight: FontWeight.w700,
//               letterSpacing: 0.7,
//             ),
//           ),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             color: _C.card,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.border, width: 0.5),
//           ),
//           child: Column(
//             children: List.generate(children.length, (i) {
//               return Column(
//                 children: [
//                   children[i],
//                   if (i < children.length - 1)
//                     const Divider(
//                         height: 0.5,
//                         thickness: 0.5,
//                         color: _C.border,
//                         indent: 52),
//                 ],
//               );
//             }),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // FIELD ITEM  — editable text field row
// // ─────────────────────────────────────────────────────────────────────────────

// class _FieldItem extends StatefulWidget {
//   final String label, hint;
//   final TextEditingController controller;
//   final IconData icon;
//   final bool required;
//   final TextInputType keyboardType;
//   final String? Function(String?)? validator;

//   const _FieldItem({
//     required this.label,
//     required this.hint,
//     required this.controller,
//     required this.icon,
//     this.required = false,
//     this.keyboardType = TextInputType.text,
//     this.validator,
//   });

//   @override
//   State<_FieldItem> createState() => _FieldItemState();
// }

// class _FieldItemState extends State<_FieldItem> {
//   bool _focused = false;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             width: 34,
//             height: 34,
//             decoration: BoxDecoration(
//               color: _focused ? _C.greenLight : _C.bg,
//               borderRadius: BorderRadius.circular(9),
//             ),
//             child: Icon(widget.icon,
//                 size: 17, color: _focused ? _C.darkGreen : _C.textHint),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       widget.label,
//                       style: const TextStyle(
//                         color: _C.textSecondary,
//                         fontSize: 10.5,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     if (widget.required)
//                       const Text(' *',
//                           style: TextStyle(color: _C.red, fontSize: 10)),
//                   ],
//                 ),
//                 Focus(
//                   onFocusChange: (f) => setState(() => _focused = f),
//                   child: TextFormField(
//                     controller: widget.controller,
//                     keyboardType: widget.keyboardType,
//                     validator: widget.validator,
//                     style: const TextStyle(
//                       color: _C.textPrimary,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     decoration: InputDecoration(
//                       isDense: true,
//                       contentPadding:
//                           const EdgeInsets.only(top: 15, bottom: 15, left: 9),
//                       border: InputBorder.none,
//                       hintText: widget.hint,
//                       hintStyle: const TextStyle(
//                         color: _C.textHint,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w400,
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

// // ─────────────────────────────────────────────────────────────────────────────
// // READONLY FIELD
// // ─────────────────────────────────────────────────────────────────────────────

// class _ReadonlyField extends StatelessWidget {
//   final String label, value;
//   final IconData icon;

//   const _ReadonlyField({
//     required this.label,
//     required this.value,
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       child: Row(
//         children: [
//           Container(
//             width: 34,
//             height: 34,
//             decoration: BoxDecoration(
//               color: _C.bg,
//               borderRadius: BorderRadius.circular(9),
//             ),
//             child: Icon(icon, size: 17, color: _C.textHint),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: const TextStyle(
//                     color: _C.textHint,
//                     fontSize: 10.5,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 1),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     color: _C.textSecondary,
//                     fontSize: 13.5,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
//             decoration: BoxDecoration(
//               color: _C.bg,
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: const Text(
//               'লক',
//               style: TextStyle(
//                 color: _C.textHint,
//                 fontSize: 9,
//                 fontWeight: FontWeight.w600,
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
//   final bool hasChanges;
//   const _SaveButton(
//       {required this.saving, required this.onTap, required this.hasChanges});

//   @override
//   Widget build(BuildContext context) {
//     // Determine if button should be interactive
//     final bool isEnabled = hasChanges && !saving;

//     return GestureDetector(
//       onTap: isEnabled ? onTap : null,
//       child: AnimatedContainer(
//         duration: 200.ms,
//         width: double.infinity,
//         height: 54,
//         decoration: BoxDecoration(
//           color: _getBackgroundColor(isEnabled),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: isEnabled && !saving
//               ? [
//                   BoxShadow(
//                     color: _C.darkGreen.withOpacity(0.3),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ]
//               : [],
//         ),
//         child: AnimatedSwitcher(
//           duration: 200.ms,
//           switchInCurve: Curves.easeOutCubic,
//           switchOutCurve: Curves.easeInCubic,
//           child: _buildButtonContent(isEnabled),
//         ),
//       ),
//     );
//   }

//   Color _getBackgroundColor(bool isEnabled) {
//     if (saving) return _C.darkGreen.withOpacity(0.7);
//     if (!isEnabled) return _C.darkGreen.withOpacity(0.4);
//     return _C.darkGreen;
//   }

//   Widget _buildButtonContent(bool isEnabled) {
//     if (saving) {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(
//             width: 20,
//             height: 20,
//             child: CircularProgressIndicator(
//               color: Colors.white,
//               strokeWidth: 2.5,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Text(
//             'সেভ হচ্ছে...',
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//               fontSize: 15,
//             ),
//           ),
//         ],
//       );
//     }

//     if (!isEnabled) {
//       // Disabled state - no changes to save
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.check_circle_outline_rounded,
//             color: Colors.white.withOpacity(0.7),
//             size: 18,
//           ),
//           const SizedBox(width: 8),
//           Text(
//             'কোনো পরিবর্তন নেই',
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.7),
//               fontWeight: FontWeight.w600,
//               fontSize: 14,
//             ),
//           ),
//         ],
//       );
//     }

//     // Enabled state - has changes
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         TweenAnimationBuilder(
//           tween: Tween<double>(begin: 0.8, end: 1.0),
//           duration: 300.ms,
//           curve: Curves.elasticOut,
//           builder: (context, scale, child) {
//             return Transform.scale(
//               scale: scale,
//               child: const Icon(
//                 Icons.save_rounded,
//                 color: Colors.white,
//                 size: 18,
//               ),
//             );
//           },
//         ),
//         const SizedBox(width: 8),
//         const Text(
//           'পরিবর্তন সেভ করুন',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w700,
//             fontSize: 15,
//             letterSpacing: 0.3,
//           ),
//         ),
//       ],
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../../auth/providers/auth_provider.dart';
// import '../../tracker/providers/tracker_provider.dart';

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
//   static const goldLight = Color(0xFFFFF8E7);
//   static const red = Color(0xFFEF4444);
//   static const redLight = Color(0xFFFEF2F2);
//   static const border = Color(0xFFE4EAE4);
//   static const borderMid = Color(0xFFD0DAD2);
//   static const borderFocus = Color(0xFF0E3D22);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
//   static const inputBg = Color(0xFFF8FAF8);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DISTRICTS
// // ─────────────────────────────────────────────────────────────────────────────

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
//   'চুয়াডাঙ্গা',
// ];

// // ─────────────────────────────────────────────────────────────────────────────
// // SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// class ProfileEditScreen extends ConsumerStatefulWidget {
//   const ProfileEditScreen({super.key});

//   @override
//   ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
// }

// class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
//   final _formKey = GlobalKey<FormState>();

//   late final TextEditingController _nameCtrl;
//   late final TextEditingController _phoneCtrl;

//   bool _saving = false;
//   bool _hasChanges = false;

//   String? _selectedDistrict;
//   String? _originalDistrict;

//   @override
//   void initState() {
//     super.initState();
//     final user = ref.read(currentUserProvider);

//     _nameCtrl = TextEditingController(text: user?.name ?? '');
//     _phoneCtrl = TextEditingController(text: user?.phone ?? '');

//     _selectedDistrict = user?.district;
//     _originalDistrict = user?.district;

//     // Track text-field changes
//     _nameCtrl.addListener(_checkForChanges);
//     _phoneCtrl.addListener(_checkForChanges);
//   }

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _phoneCtrl.dispose();
//     super.dispose();
//   }

//   void _checkForChanges() {
//     final user = ref.read(currentUserProvider);
//     final hasNameChange = _nameCtrl.text != (user?.name ?? '');
//     final hasPhoneChange = _phoneCtrl.text != (user?.phone ?? '');
//     final hasDistrictChange = _selectedDistrict != _originalDistrict;

//     setState(() {
//       _hasChanges = hasNameChange || hasPhoneChange || hasDistrictChange;
//     });
//   }

//   // ── District picker ────────────────────────────────────────────────────────

//   Future<void> _openDistrictPicker() async {
//     final result = await showModalBottomSheet<String>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _DistrictPickerSheet(
//         selectedDistrict: _selectedDistrict,
//         districts: _bangladeshDistricts,
//       ),
//     );
//     if (result != null && result != _selectedDistrict) {
//       setState(() {
//         _selectedDistrict = result;
//       });
//       _checkForChanges();
//     }
//   }

//   void _clearDistrict() {
//     setState(() {
//       _selectedDistrict = null;
//     });
//     _checkForChanges();
//   }

//   // ── Save ───────────────────────────────────────────────────────────────────

//   Future<void> _save() async {
//     // Validate form
//     if (!(_formKey.currentState?.validate() ?? false)) return;

//     // If no changes, just close
//     if (!_hasChanges) {
//       if (mounted) context.pop();
//       return;
//     }

//     setState(() => _saving = true);
//     HapticFeedback.mediumImpact();

//     try {
//       // Call update profile API
//       final success = await ref.read(authProvider.notifier).updateProfile({
//         'name': _nameCtrl.text.trim(),
//         'phone': _phoneCtrl.text.trim(),
//         'district': _selectedDistrict,
//       });

//       if (!mounted) return;

//       if (success) {
//         // Success - haptic feedback
//         HapticFeedback.selectionClick();

//         // Refresh profile data from server
//         await ref.read(authProvider.notifier).refreshProfile();

//         if (!mounted) return;

//         // Show success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Row(
//               children: [
//                 Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     'প্রোফাইল সফলভাবে আপডেট হয়েছে',
//                     style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
//                   ),
//                 ),
//               ],
//             ),
//             backgroundColor: _C.darkGreen,
//             margin: const EdgeInsets.all(16),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             duration: const Duration(seconds: 2),
//           ),
//         );

//         // Close the page after a short delay for smooth animation
//         await Future.delayed(const Duration(milliseconds: 300));
//         if (mounted) {
//           context.pop(true); // Return true to indicate success
//         }
//       } else {
//         // API failed but didn't throw exception
//         if (mounted) {
//           _showErrorSnackBar('প্রোফাইল আপডেট করতে ব্যর্থ হয়েছে');
//         }
//       }
//     } catch (e) {
//       // Handle any unexpected errors
//       if (mounted) {
//         _showErrorSnackBar('একটি সমস্যা হয়েছে। আবার চেষ্টা করুন');
//         print('Profile update error: $e');
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _saving = false);
//       }
//     }
//   }

// // Helper method to show error message
//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.error_outline_rounded,
//                 color: Colors.white, size: 18),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 message,
//                 style:
//                     const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: _C.red,
//         margin: const EdgeInsets.all(16),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   // ── Build ──────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     final user = ref.watch(currentUserProvider);
//     final progress = ref.watch(progressSummaryProvider);
//     final totalPts =
//         progress.whenOrNull(data: (s) => s.currentMonth?.totalPoints) ?? 0;
//     final daysCompleted =
//         progress.whenOrNull(data: (s) => s.currentMonth?.daysCompleted) ?? 0;
//     final isFemale = user?.gender?.toLowerCase() == 'female';
//     final name = user?.name ?? 'ব্যবহারকারী';
//     final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

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
//             title: const Text(
//               'প্রোফাইল সম্পাদনা',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w800,
//                 letterSpacing: -0.3,
//               ),
//             ),
//             actions: [
//               GestureDetector(
//                 onTap: (_saving || !_hasChanges) ? null : _save,
//                 child: Container(
//                   margin: const EdgeInsets.fromLTRB(0, 10, 14, 10),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: (_saving || !_hasChanges)
//                         ? _C.gold.withOpacity(0.4)
//                         : _C.gold,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: _saving
//                       ? const SizedBox(
//                           width: 14,
//                           height: 14,
//                           child: CircularProgressIndicator(
//                               color: Colors.white, strokeWidth: 2),
//                         )
//                       : !_hasChanges
//                           ? const Icon(
//                               Icons.check_rounded,
//                               color: Colors.white70,
//                               size: 16,
//                             )
//                           : const Text(
//                               'সেভ',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 13,
//                               ),
//                             ),
//                 ),
//               ).animate().fadeIn(duration: 200.ms).slideX(begin: 0.2),
//             ],
//           ),

//           SliverToBoxAdapter(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   // ── Avatar hero ────────────────────────────────────
//                   _AvatarHero(
//                     initial: initial,
//                     name: name,
//                     email: user?.email,
//                     serialId: user?.serialId,
//                   ),

//                   // ── Stats ribbon ───────────────────────────────────
//                   _StatsRibbon(
//                     totalPts: totalPts,
//                     daysCompleted: daysCompleted,
//                     isFemale: isFemale,
//                   ),

//                   // ── Form fields ────────────────────────────────────
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // ── Personal info ──────────────────────────
//                         _FormSection(
//                           label: 'ব্যক্তিগত তথ্য',
//                           children: [
//                             _FieldItem(
//                               label: 'পুরো নাম',
//                               hint: 'আপনার নাম লিখুন',
//                               controller: _nameCtrl,
//                               icon: Icons.person_outline_rounded,
//                               required: true,
//                               validator: (v) => (v?.trim().isEmpty ?? true)
//                                   ? 'নাম আবশ্যক'
//                                   : null,
//                             ),
//                             _FieldItem(
//                               label: 'ফোন নম্বর',
//                               hint: '০১XXXXXXXXX',
//                               controller: _phoneCtrl,
//                               icon: Icons.phone_outlined,
//                               keyboardType: TextInputType.phone,
//                               isPhoneField: true, // Phone field with validation
//                             ),
//                             // ── District picker row ──────────────
//                             _DistrictFieldItem(
//                               selectedDistrict: _selectedDistrict,
//                               onTap: _openDistrictPicker,
//                               onClear: _clearDistrict,
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 14),

//                         // ── Read-only info ─────────────────────────
//                         _FormSection(
//                           label: 'স্থায়ী তথ্য (পরিবর্তনযোগ্য নয়)',
//                           children: [
//                             _ReadonlyField(
//                               label: 'ইমেইল',
//                               value: user?.email ?? '-',
//                               icon: Icons.email_outlined,
//                             ),
//                             _ReadonlyField(
//                               label: 'লিঙ্গ',
//                               value: isFemale
//                                   ? 'মহিলা 🌸'
//                                   : user?.gender == 'male'
//                                       ? 'পুরুষ'
//                                       : user?.gender ?? '-',
//                               icon: Icons.person_pin_outlined,
//                             ),
//                             if (user?.serialId != null)
//                               _ReadonlyField(
//                                 label: 'সিরিয়াল আইডি',
//                                 value: '#${user!.serialId}',
//                                 icon: Icons.tag_rounded,
//                               ),
//                           ],
//                         ),

//                         const SizedBox(height: 24),

//                         // ── Save button (bottom) ───────────────────

//                         _SaveButton(
//                           saving: _saving,
//                           onTap: _save,
//                           hasChanges: _hasChanges,
//                         ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.1),

//                         SizedBox(
//                           height: MediaQuery.of(context).padding.bottom + 32,
//                         ),
//                       ],
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
// // AVATAR HERO  — serial ID shown below name
// // ─────────────────────────────────────────────────────────────────────────────

// class _AvatarHero extends StatelessWidget {
//   final String initial, name;
//   final String? email;
//   final dynamic serialId; // int or String

//   const _AvatarHero({
//     required this.initial,
//     required this.name,
//     this.email,
//     this.serialId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       color: _C.darkGreen,
//       padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
//       child: Column(
//         children: [
//           // Avatar with camera badge
//           Stack(
//             alignment: Alignment.bottomRight,
//             children: [
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(22),
//                   border: Border.all(
//                       color: Colors.white.withOpacity(0.3), width: 2),
//                 ),
//                 child: Center(
//                   child: Text(
//                     initial,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 32,
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 26,
//                 height: 26,
//                 decoration: BoxDecoration(
//                   color: _C.gold,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: _C.darkGreen, width: 2),
//                 ),
//                 child: const Icon(Icons.camera_alt_rounded,
//                     color: Colors.white, size: 12),
//               ),
//             ],
//           ),

//           const SizedBox(height: 12),

//           // Name
//           Text(
//             name,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.w800,
//               letterSpacing: -0.4,
//             ),
//           ),

//           // Serial ID — shown directly under name
//           if (serialId != null) ...[
//             const SizedBox(height: 4),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.12),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                     color: Colors.white.withOpacity(0.2), width: 0.5),
//               ),
//               child: Text(
//                 '#$serialId',
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.75),
//                   fontSize: 11,
//                   fontWeight: FontWeight.w600,
//                   letterSpacing: 0.3,
//                 ),
//               ),
//             ),
//           ],

//           // Email — below ID
//           if (email != null) ...[
//             const SizedBox(height: 5),
//             Text(
//               email!,
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.45),
//                 fontSize: 11.5,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DISTRICT FIELD ITEM  — tap-to-open, styled to match _FieldItem card rows
// // ─────────────────────────────────────────────────────────────────────────────

// class _DistrictFieldItem extends StatelessWidget {
//   final String? selectedDistrict;
//   final VoidCallback onTap;
//   final VoidCallback onClear;

//   const _DistrictFieldItem({
//     required this.selectedDistrict,
//     required this.onTap,
//     required this.onClear,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final hasValue = selectedDistrict != null && selectedDistrict!.isNotEmpty;

//     return GestureDetector(
//       onTap: onTap,
//       behavior: HitTestBehavior.opaque,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//         child: Row(
//           children: [
//             // Icon box — mirrors _FieldItem style
//             Container(
//               width: 34,
//               height: 34,
//               decoration: BoxDecoration(
//                 color: hasValue ? _C.greenLight : _C.bg,
//                 borderRadius: BorderRadius.circular(9),
//               ),
//               child: Icon(
//                 Icons.location_city_rounded,
//                 size: 17,
//                 color: hasValue ? _C.darkGreen : _C.textHint,
//               ),
//             ),
//             const SizedBox(width: 12),

//             // Label + value
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'জেলা',
//                     style: TextStyle(
//                       color: _C.textSecondary,
//                       fontSize: 10.5,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     hasValue ? selectedDistrict! : 'জেলা নির্বাচন করুন',
//                     style: TextStyle(
//                       color: hasValue ? _C.textPrimary : _C.textHint,
//                       fontSize: hasValue ? 14 : 13,
//                       fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Clear or chevron
//             if (hasValue)
//               GestureDetector(
//                 onTap: onClear,
//                 child: Container(
//                   width: 26,
//                   height: 26,
//                   decoration: BoxDecoration(
//                     color: _C.bg,
//                     borderRadius: BorderRadius.circular(7),
//                   ),
//                   child: const Icon(Icons.close_rounded,
//                       size: 14, color: _C.textHint),
//                 ),
//               )
//             else
//               const Icon(Icons.keyboard_arrow_down_rounded,
//                   size: 20, color: _C.textHint),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DISTRICT PICKER BOTTOM SHEET  — searchable list
// // ─────────────────────────────────────────────────────────────────────────────

// class _DistrictPickerSheet extends StatefulWidget {
//   final String? selectedDistrict;
//   final List<String> districts;

//   const _DistrictPickerSheet({
//     required this.selectedDistrict,
//     required this.districts,
//   });

//   @override
//   State<_DistrictPickerSheet> createState() => _DistrictPickerSheetState();
// }

// class _DistrictPickerSheetState extends State<_DistrictPickerSheet> {
//   final _searchCtrl = TextEditingController();
//   final _searchFocus = FocusNode();
//   List<String> _filtered = [];

//   @override
//   void initState() {
//     super.initState();
//     _filtered = List.from(widget.districts);
//     _searchCtrl.addListener(_onSearch);
//     WidgetsBinding.instance
//         .addPostFrameCallback((_) => _searchFocus.requestFocus());
//   }

//   @override
//   void dispose() {
//     _searchCtrl.removeListener(_onSearch);
//     _searchCtrl.dispose();
//     _searchFocus.dispose();
//     super.dispose();
//   }

//   void _onSearch() {
//     final q = _searchCtrl.text.trim();
//     setState(() {
//       _filtered = q.isEmpty
//           ? List.from(widget.districts)
//           : widget.districts.where((d) => d.contains(q)).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bottomInset = MediaQuery.of(context).viewInsets.bottom;

//     return Container(
//       margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Handle
//           const SizedBox(height: 12),
//           Container(
//             width: 36,
//             height: 4,
//             decoration: BoxDecoration(
//               color: _C.borderMid,
//               borderRadius: BorderRadius.circular(99),
//             ),
//           ),
//           const SizedBox(height: 16),

//           // Title row
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               children: [
//                 Container(
//                   width: 34,
//                   height: 34,
//                   decoration: BoxDecoration(
//                     color: _C.greenLight,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Icon(Icons.location_city_rounded,
//                       color: _C.darkGreen, size: 18),
//                 ),
//                 const SizedBox(width: 10),
//                 const Expanded(
//                   child: Text(
//                     'জেলা নির্বাচন করুন',
//                     style: TextStyle(
//                       color: _C.textPrimary,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () => Navigator.of(context).pop(),
//                   child: Container(
//                     width: 32,
//                     height: 32,
//                     decoration: BoxDecoration(
//                       color: _C.inputBg,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: _C.border),
//                     ),
//                     child: const Icon(Icons.close_rounded,
//                         size: 16, color: _C.textSecondary),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 14),

//           // Search box
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: TextField(
//               controller: _searchCtrl,
//               focusNode: _searchFocus,
//               style: const TextStyle(
//                   color: _C.textPrimary,
//                   fontSize: 14.5,
//                   fontWeight: FontWeight.w500),
//               decoration: InputDecoration(
//                 hintText: 'জেলার নাম লিখুন...',
//                 hintStyle: const TextStyle(color: _C.textHint, fontSize: 14),
//                 prefixIcon: const Icon(Icons.search_rounded,
//                     size: 20, color: _C.textSecondary),
//                 filled: true,
//                 fillColor: _C.inputBg,
//                 contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: _C.border),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: _C.border, width: 1),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: _C.darkGreen, width: 1.5),
//                 ),
//                 suffixIcon: _searchCtrl.text.isNotEmpty
//                     ? GestureDetector(
//                         onTap: () {
//                           _searchCtrl.clear();
//                           _searchFocus.requestFocus();
//                         },
//                         child: const Icon(Icons.close_rounded,
//                             size: 18, color: _C.textSecondary),
//                       )
//                     : null,
//               ),
//             ),
//           ),

//           const SizedBox(height: 8),
//           const Divider(height: 1, thickness: 0.5, color: _C.border),

//           // District list
//           ConstrainedBox(
//             constraints: BoxConstraints(
//               maxHeight:
//                   MediaQuery.of(context).size.height * 0.45 - bottomInset,
//             ),
//             child: _filtered.isEmpty
//                 ? Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 32),
//                     child: Column(
//                       children: const [
//                         Icon(Icons.search_off_rounded,
//                             size: 40, color: _C.textHint),
//                         SizedBox(height: 10),
//                         Text(
//                           'কোনো জেলা পাওয়া যায়নি',
//                           style:
//                               TextStyle(color: _C.textSecondary, fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   )
//                 : ListView.builder(
//                     padding: EdgeInsets.only(top: 4, bottom: 16 + bottomInset),
//                     itemCount: _filtered.length,
//                     itemBuilder: (ctx, i) {
//                       final district = _filtered[i];
//                       final isSelected = district == widget.selectedDistrict;

//                       return InkWell(
//                         onTap: () => Navigator.of(context).pop(district),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 13),
//                           color:
//                               isSelected ? _C.greenLight : Colors.transparent,
//                           child: Row(
//                             children: [
//                               isSelected
//                                   ? const Icon(Icons.check_circle_rounded,
//                                       size: 18, color: _C.darkGreen)
//                                   : const Icon(
//                                       Icons.radio_button_unchecked_rounded,
//                                       size: 18,
//                                       color: _C.borderMid),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Text(
//                                   district,
//                                   style: TextStyle(
//                                     color: isSelected
//                                         ? _C.darkGreen
//                                         : _C.textPrimary,
//                                     fontSize: 14.5,
//                                     fontWeight: isSelected
//                                         ? FontWeight.w700
//                                         : FontWeight.w400,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // STATS RIBBON
// // ─────────────────────────────────────────────────────────────────────────────

// class _StatsRibbon extends StatelessWidget {
//   final int totalPts, daysCompleted;
//   final bool isFemale;

//   const _StatsRibbon({
//     required this.totalPts,
//     required this.daysCompleted,
//     required this.isFemale,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 16, 16, 2),
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: _RibbonStat(
//               emoji: '⭐',
//               value: '$totalPts',
//               label: 'মাসের পয়েন্ট',
//             ),
//           ),
//           Container(width: 0.5, height: 36, color: _C.border),
//           Expanded(
//             child: _RibbonStat(
//               emoji: '📅',
//               value: '$daysCompleted',
//               label: 'সম্পন্ন দিন',
//             ),
//           ),
//         ],
//       ),
//     ).animate().fadeIn(delay: 80.ms).slideY(begin: 0.06);
//   }
// }

// class _RibbonStat extends StatelessWidget {
//   final String emoji, value, label;
//   final Color? valueColor;

//   const _RibbonStat({
//     required this.emoji,
//     required this.value,
//     required this.label,
//     this.valueColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(emoji, style: const TextStyle(fontSize: 18)),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             color: valueColor ?? _C.textPrimary,
//             fontSize: 16,
//             fontWeight: FontWeight.w800,
//             letterSpacing: -0.3,
//           ),
//         ),
//         Text(label, style: const TextStyle(color: _C.textHint, fontSize: 10)),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // FORM SECTION
// // ─────────────────────────────────────────────────────────────────────────────

// class _FormSection extends StatelessWidget {
//   final String label;
//   final List<Widget> children;

//   const _FormSection({required this.label, required this.children});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 2, bottom: 8),
//           child: Text(
//             label.toUpperCase(),
//             style: const TextStyle(
//               color: _C.textHint,
//               fontSize: 10,
//               fontWeight: FontWeight.w700,
//               letterSpacing: 0.7,
//             ),
//           ),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             color: _C.card,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.border, width: 0.5),
//           ),
//           child: Column(
//             children: List.generate(children.length, (i) {
//               return Column(
//                 children: [
//                   children[i],
//                   if (i < children.length - 1)
//                     const Divider(
//                         height: 0.5,
//                         thickness: 0.5,
//                         color: _C.border,
//                         indent: 52),
//                 ],
//               );
//             }),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // FIELD ITEM  — editable text field row with phone validation
// // ─────────────────────────────────────────────────────────────────────────────

// class _FieldItem extends StatefulWidget {
//   final String label, hint;
//   final TextEditingController controller;
//   final IconData icon;
//   final bool required;
//   final TextInputType keyboardType;
//   final String? Function(String?)? validator;
//   final bool isPhoneField; // Flag for phone field with special validation

//   const _FieldItem({
//     required this.label,
//     required this.hint,
//     required this.controller,
//     required this.icon,
//     this.required = false,
//     this.keyboardType = TextInputType.text,
//     this.validator,
//     this.isPhoneField = false, // Default to false
//   });

//   @override
//   State<_FieldItem> createState() => _FieldItemState();
// }

// class _FieldItemState extends State<_FieldItem> {
//   bool _focused = false;
//   String? _errorText;

//   // Bangladesh phone number validation
//   String? _validateBangladeshPhone(String? value) {
//     // Allow empty value
//     if (value == null || value.trim().isEmpty) {
//       return null; // Empty is allowed for phone
//     }

//     // Remove any whitespace, dashes, or plus signs
//     String cleaned = value.trim().replaceAll(RegExp(r'[\s\-+]'), '');

//     // Check if it's a valid Bangladesh phone number
//     // Format: 01XXXXXXXXX (11 digits starting with 01 followed by 3-9 and then 8 digits)
//     final bangladeshPhoneRegex = RegExp(r'^01[3-9]\d{8}$');

//     if (!bangladeshPhoneRegex.hasMatch(cleaned)) {
//       return 'বাংলাদেশের বৈধ ফোন নম্বর দিন (01XXXXXXXXX)';
//     }

//     return null;
//   }

//   void _onChanged(String value) {
//     // Only validate phone field on change
//     if (widget.isPhoneField) {
//       setState(() {
//         _errorText = _validateBangladeshPhone(value);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             width: 34,
//             height: 34,
//             decoration: BoxDecoration(
//               color: _focused ? _C.greenLight : _C.bg,
//               borderRadius: BorderRadius.circular(9),
//             ),
//             child: Icon(widget.icon,
//                 size: 17, color: _focused ? _C.darkGreen : _C.textHint),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       widget.label,
//                       style: const TextStyle(
//                         color: _C.textSecondary,
//                         fontSize: 10.5,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     if (widget.required && !widget.isPhoneField)
//                       const Text(' *',
//                           style: TextStyle(color: _C.red, fontSize: 10)),
//                     if (widget.isPhoneField)
//                       const Text(' (ঐচ্ছিক)',
//                           style: TextStyle(color: _C.textHint, fontSize: 9)),
//                   ],
//                 ),
//                 Focus(
//                   onFocusChange: (f) => setState(() => _focused = f),
//                   child: TextFormField(
//                     controller: widget.controller,
//                     keyboardType: widget.keyboardType,
//                     validator: widget.isPhoneField
//                         ? (value) {
//                             final error = _validateBangladeshPhone(value);
//                             // Update error text state
//                             WidgetsBinding.instance.addPostFrameCallback((_) {
//                               if (mounted) {
//                                 setState(() => _errorText = error);
//                               }
//                             });
//                             return error;
//                           }
//                         : widget.validator,
//                     onChanged: widget.isPhoneField ? _onChanged : null,
//                     style: const TextStyle(
//                       color: _C.textPrimary,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     decoration: InputDecoration(
//                       isDense: true,
//                       contentPadding:
//                           const EdgeInsets.only(top: 15, bottom: 15, left: 9),
//                       border: InputBorder.none,
//                       hintText: widget.hint,
//                       hintStyle: const TextStyle(
//                         color: _C.textHint,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       errorText: _errorText,
//                       errorStyle: const TextStyle(
//                         fontSize: 10,
//                         color: _C.red,
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

// // ─────────────────────────────────────────────────────────────────────────────
// // READONLY FIELD
// // ─────────────────────────────────────────────────────────────────────────────

// class _ReadonlyField extends StatelessWidget {
//   final String label, value;
//   final IconData icon;

//   const _ReadonlyField({
//     required this.label,
//     required this.value,
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       child: Row(
//         children: [
//           Container(
//             width: 34,
//             height: 34,
//             decoration: BoxDecoration(
//               color: _C.bg,
//               borderRadius: BorderRadius.circular(9),
//             ),
//             child: Icon(icon, size: 17, color: _C.textHint),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: const TextStyle(
//                     color: _C.textHint,
//                     fontSize: 10.5,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 1),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     color: _C.textSecondary,
//                     fontSize: 13.5,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
//             decoration: BoxDecoration(
//               color: _C.bg,
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: const Text(
//               'লক',
//               style: TextStyle(
//                 color: _C.textHint,
//                 fontSize: 9,
//                 fontWeight: FontWeight.w600,
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
//   final bool hasChanges;
//   const _SaveButton(
//       {required this.saving, required this.onTap, required this.hasChanges});

//   @override
//   Widget build(BuildContext context) {
//     // Determine if button should be interactive
//     final bool isEnabled = hasChanges && !saving;

//     return GestureDetector(
//       onTap: isEnabled ? onTap : null,
//       child: AnimatedContainer(
//         duration: 200.ms,
//         width: double.infinity,
//         height: 54,
//         decoration: BoxDecoration(
//           color: _getBackgroundColor(isEnabled),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: isEnabled && !saving
//               ? [
//                   BoxShadow(
//                     color: _C.darkGreen.withOpacity(0.3),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ]
//               : [],
//         ),
//         child: AnimatedSwitcher(
//           duration: 200.ms,
//           switchInCurve: Curves.easeOutCubic,
//           switchOutCurve: Curves.easeInCubic,
//           child: _buildButtonContent(isEnabled),
//         ),
//       ),
//     );
//   }

//   Color _getBackgroundColor(bool isEnabled) {
//     if (saving) return _C.darkGreen.withOpacity(0.7);
//     if (!isEnabled) return _C.darkGreen.withOpacity(0.4);
//     return _C.darkGreen;
//   }

//   Widget _buildButtonContent(bool isEnabled) {
//     if (saving) {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(
//             width: 20,
//             height: 20,
//             child: CircularProgressIndicator(
//               color: Colors.white,
//               strokeWidth: 2.5,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Text(
//             'সেভ হচ্ছে...',
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//               fontSize: 15,
//             ),
//           ),
//         ],
//       );
//     }

//     if (!isEnabled) {
//       // Disabled state - no changes to save
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.check_circle_outline_rounded,
//             color: Colors.white.withOpacity(0.7),
//             size: 18,
//           ),
//           const SizedBox(width: 8),
//           Text(
//             'কোনো পরিবর্তন নেই',
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.7),
//               fontWeight: FontWeight.w600,
//               fontSize: 14,
//             ),
//           ),
//         ],
//       );
//     }

//     // Enabled state - has changes
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         TweenAnimationBuilder(
//           tween: Tween<double>(begin: 0.8, end: 1.0),
//           duration: 300.ms,
//           curve: Curves.elasticOut,
//           builder: (context, scale, child) {
//             return Transform.scale(
//               scale: scale,
//               child: const Icon(
//                 Icons.save_rounded,
//                 color: Colors.white,
//                 size: 18,
//               ),
//             );
//           },
//         ),
//         const SizedBox(width: 8),
//         const Text(
//           'পরিবর্তন সেভ করুন',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w700,
//             fontSize: 15,
//             letterSpacing: 0.3,
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../tracker/providers/tracker_provider.dart';

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
  static const goldLight = Color(0xFFFFF8E7);
  static const red = Color(0xFFEF4444);
  static const redLight = Color(0xFFFEF2F2);
  static const border = Color(0xFFE4EAE4);
  static const borderMid = Color(0xFFD0DAD2);
  static const borderFocus = Color(0xFF0E3D22);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
  static const inputBg = Color(0xFFF8FAF8);
}

// ─────────────────────────────────────────────────────────────────────────────
// DISTRICTS
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
// SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;

  bool _saving = false;
  bool _hasChanges = false;

  String? _selectedDistrict;
  String? _originalDistrict;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);

    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');

    _selectedDistrict = user?.district;
    _originalDistrict = user?.district;

    // Track text-field changes
    _nameCtrl.addListener(_checkForChanges);
    _phoneCtrl.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    final user = ref.read(currentUserProvider);
    final hasNameChange = _nameCtrl.text != (user?.name ?? '');
    final hasPhoneChange = _phoneCtrl.text != (user?.phone ?? '');

    // Normalize null and empty string for district comparison
    final currentDistrict = _selectedDistrict ?? '';
    final originalDistrict = _originalDistrict ?? '';
    final hasDistrictChange = currentDistrict != originalDistrict;

    setState(() {
      _hasChanges = hasNameChange || hasPhoneChange || hasDistrictChange;
    });
  }

  // ── District picker ────────────────────────────────────────────────────────

  Future<void> _openDistrictPicker() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DistrictPickerSheet(
        selectedDistrict: _selectedDistrict,
        districts: _bangladeshDistricts,
      ),
    );
    if (result != null && result != _selectedDistrict) {
      setState(() {
        _selectedDistrict = result;
      });
      _checkForChanges();
      // Trigger form validation for district
      _formKey.currentState?.validate();
    }
  }

  void _clearDistrict() {
    setState(() {
      _selectedDistrict = null;
    });
    _checkForChanges();
    // Trigger form validation for district
    _formKey.currentState?.validate();
  }

  // ── Save ───────────────────────────────────────────────────────────────────

  // Future<void> _save() async {
  //   // Manual validation for district (required field)
  //   if (_selectedDistrict == null || _selectedDistrict!.isEmpty) {
  //     _showErrorSnackBar('জেলা নির্বাচন আবশ্যক');
  //     return;
  //   }

  //   // Validate form fields
  //   if (!(_formKey.currentState?.validate() ?? false)) return;

  //   // If no changes, just close
  //   if (!_hasChanges) {
  //     if (mounted) context.pop();
  //     return;
  //   }

  //   setState(() => _saving = true);
  //   HapticFeedback.mediumImpact();

  //   try {
  //     // Call update profile API
  //     final success = await ref.read(authProvider.notifier).updateProfile({
  //       'name': _nameCtrl.text.trim(),
  //       'phone': _phoneCtrl.text.trim(),
  //       'district': _selectedDistrict,
  //     });

  //     if (!mounted) return;

  //     if (success) {
  //       // Success - haptic feedback
  //       HapticFeedback.selectionClick();

  //       // Refresh profile data from server
  //       await ref.read(authProvider.notifier).refreshProfile();

  //       if (!mounted) return;

  //       // Show success message
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: const Row(
  //             children: [
  //               Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
  //               SizedBox(width: 10),
  //               Expanded(
  //                 child: Text(
  //                   'প্রোফাইল সফলভাবে আপডেট হয়েছে',
  //                   style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           backgroundColor: _C.darkGreen,
  //           margin: const EdgeInsets.all(16),
  //           behavior: SnackBarBehavior.floating,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           duration: const Duration(seconds: 2),
  //         ),
  //       );

  //       // Close the page after a short delay for smooth animation
  //       await Future.delayed(const Duration(milliseconds: 300));
  //       if (mounted) {
  //         context.pop(true); // Return true to indicate success
  //       }
  //     } else {
  //       // API failed but didn't throw exception
  //       if (mounted) {
  //         _showErrorSnackBar('প্রোফাইল আপডেট করতে ব্যর্থ হয়েছে');
  //       }
  //     }
  //   } catch (e) {
  //     // Handle any unexpected errors
  //     if (mounted) {
  //       _showErrorSnackBar('একটি সমস্যা হয়েছে। আবার চেষ্টা করুন');
  //       print('Profile update error: $e');
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() => _saving = false);
  //     }
  //   }
  // }

  Future<void> _save() async {
    // Manual validation for district (required field)
    if (_selectedDistrict == null || _selectedDistrict!.isEmpty) {
      _showErrorSnackBar('জেলা নির্বাচন আবশ্যক');
      return;
    }

    // Validate form fields
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // If no changes, just close
    if (!_hasChanges) {
      if (mounted) context.pop();
      return;
    }

    setState(() => _saving = true);
    HapticFeedback.mediumImpact();

    try {
      // Prepare update data - only include phone if it has value
      final Map<String, dynamic> updateData = {
        'name': _nameCtrl.text.trim(),
        'district': _selectedDistrict,
      };

      // Only add phone to request if it's not empty (optional field)
      final phoneValue = _phoneCtrl.text.trim();
      if (phoneValue.isNotEmpty) {
        updateData['phone'] = phoneValue;
      }
      // If phone is empty, don't include it in the request at all

      // Call update profile API
      final success =
          await ref.read(authProvider.notifier).updateProfile(updateData);

      if (!mounted) return;

      if (success) {
        // Success - haptic feedback
        HapticFeedback.selectionClick();

        // Refresh profile data from server
        await ref.read(authProvider.notifier).refreshProfile();

        if (!mounted) return;

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'প্রোফাইল সফলভাবে আপডেট হয়েছে',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: _C.darkGreen,
            margin: const EdgeInsets.all(16),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        // Close the page after a short delay for smooth animation
        await Future.delayed(const Duration(milliseconds: 300));
        // if (mounted) {
        //   context.pop(true); // Return true to indicate success
        // }
      } else {
        // API failed but didn't throw exception
        if (mounted) {
          _showErrorSnackBar('প্রোফাইল আপডেট করতে ব্যর্থ হয়েছে');
        }
      }
    } catch (e) {
      // Handle any unexpected errors
      if (mounted) {
        _showErrorSnackBar('একটি সমস্যা হয়েছে। আবার চেষ্টা করুন');
        print('Profile update error: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  // Helper method to show error message
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: _C.red,
        margin: const EdgeInsets.all(16),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final progress = ref.watch(progressSummaryProvider);
    final totalPts =
        progress.whenOrNull(data: (s) => s.currentMonth?.totalPoints) ?? 0;
    final daysCompleted =
        progress.whenOrNull(data: (s) => s.currentMonth?.daysCompleted) ?? 0;
    final isFemale = user?.gender?.toLowerCase() == 'female';
    final name = user?.name ?? 'ব্যবহারকারী';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: _C.bg,
      bottomNavigationBar: _SubmitBar(
        saving: _saving,
        onTap: _save,
        hasChanges: _hasChanges,
      ),
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ───────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: _C.darkGreen,
            surfaceTintColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.light,
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
            title: const Text(
              'প্রোফাইল সম্পাদনা',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: (_saving || !_hasChanges) ? null : _save,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 14, 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: (_saving || !_hasChanges)
                        ? _C.gold.withOpacity(0.4)
                        : _C.gold,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : !_hasChanges
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.white70,
                              size: 16,
                            )
                          : const Text(
                              'সেভ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                ),
              ).animate().fadeIn(duration: 200.ms).slideX(begin: 0.2),
            ],
          ),

          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // ── Avatar hero ────────────────────────────────────
                  _ProfileHero(
                    user: user,
                    totalPts: totalPts,
                    streak: daysCompleted,
                  ).animate().fadeIn(duration: 260.ms).slideY(begin: 0.04),
                  // _AvatarHero(
                  //   initial: initial,
                  //   name: name,
                  //   email: user?.email,
                  //   serialId: user?.serialId,
                  // ),

                  // ── Stats ribbon ───────────────────────────────────
                  // _StatsRibbon(
                  //   totalPts: totalPts,
                  //   daysCompleted: daysCompleted,
                  //   isFemale: isFemale,
                  // ),

                  // ── Form fields ────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Personal info ──────────────────────────
                        _FormSection(
                          label: 'ব্যক্তিগত তথ্য',
                          children: [
                            _FieldItem(
                              label: 'পুরো নাম',
                              hint: 'আপনার নাম লিখুন',
                              controller: _nameCtrl,
                              icon: Icons.person_outline_rounded,
                              required: true,
                            ),
                            _FieldItem(
                              label: 'ফোন নম্বর',
                              hint: '০১XXXXXXXXX',
                              controller: _phoneCtrl,
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              isPhoneField: true,
                            ),
                            // ── District picker row ──────────────
                            _DistrictFieldItem(
                              selectedDistrict: _selectedDistrict,
                              onTap: _openDistrictPicker,
                              onClear: _clearDistrict,
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // ── Read-only info ─────────────────────────
                        _FormSection(
                          label: 'স্থায়ী তথ্য (পরিবর্তনযোগ্য নয়)',
                          children: [
                            _ReadonlyField(
                              label: 'ইমেইল',
                              value: user?.email ?? '-',
                              icon: Icons.email_outlined,
                            ),
                            _ReadonlyField(
                              label: 'লিঙ্গ',
                              value: isFemale
                                  ? 'মহিলা 🌸'
                                  : user?.gender == 'male'
                                      ? 'পুরুষ'
                                      : user?.gender ?? '-',
                              icon: Icons.person_pin_outlined,
                            ),
                            if (user?.serialId != null)
                              _ReadonlyField(
                                label: 'সিরিয়াল আইডি',
                                value: '#${user!.serialId}',
                                icon: Icons.tag_rounded,
                              ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ── Save button (bottom) ───────────────────
                        // _SaveButton(
                        //   saving: _saving,
                        //   onTap: _save,
                        //   hasChanges: _hasChanges,
                        // ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.1),

                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 32,
                        ),
                      ],
                    ),
                  ),
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
// AVATAR HERO  — serial ID shown below name
// ─────────────────────────────────────────────────────────────────────────────

class _AvatarHero extends StatelessWidget {
  final String initial, name;
  final String? email;
  final dynamic serialId;

  const _AvatarHero({
    required this.initial,
    required this.name,
    this.email,
    this.serialId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _C.darkGreen,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.3), width: 2),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: _C.gold,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _C.darkGreen, width: 2),
                ),
                child: const Icon(Icons.camera_alt_rounded,
                    color: Colors.white, size: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          if (serialId != null) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Colors.white.withOpacity(0.2), width: 0.5),
              ),
              child: Text(
                '#$serialId',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
          if (email != null) ...[
            const SizedBox(height: 5),
            Text(
              email!,
              style: TextStyle(
                color: Colors.white.withOpacity(0.45),
                fontSize: 11.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DISTRICT FIELD ITEM  — Required field with validation
// ─────────────────────────────────────────────────────────────────────────────

class _DistrictFieldItem extends StatefulWidget {
  final String? selectedDistrict;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _DistrictFieldItem({
    required this.selectedDistrict,
    required this.onTap,
    required this.onClear,
  });

  @override
  State<_DistrictFieldItem> createState() => _DistrictFieldItemState();
}

class _DistrictFieldItemState extends State<_DistrictFieldItem> {
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _validateDistrict();
  }

  @override
  void didUpdateWidget(covariant _DistrictFieldItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _validateDistrict();
  }

  void _validateDistrict() {
    setState(() {
      final hasValue = widget.selectedDistrict != null &&
          widget.selectedDistrict!.isNotEmpty;
      _errorText = hasValue ? null : 'জেলা নির্বাচন আবশ্যক';
    });
  }

  void _handleClear() {
    widget.onClear();
    _validateDistrict();
  }

  @override
  Widget build(BuildContext context) {
    final hasValue =
        widget.selectedDistrict != null && widget.selectedDistrict!.isNotEmpty;

    return GestureDetector(
      onTap: () {
        widget.onTap();
        _validateDistrict();
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: hasValue ? _C.greenLight : _C.bg,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                Icons.location_city_rounded,
                size: 17,
                color: hasValue ? _C.darkGreen : _C.textHint,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'জেলা',
                        style: TextStyle(
                          color: _C.textSecondary,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(' *',
                          style: TextStyle(color: _C.red, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasValue ? widget.selectedDistrict! : 'জেলা নির্বাচন করুন',
                    style: TextStyle(
                      color: hasValue
                          ? _C.textPrimary
                          : (_errorText != null ? _C.red : _C.textHint),
                      fontSize: hasValue ? 14 : 13,
                      fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  if (_errorText != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _errorText!,
                      style: const TextStyle(
                        fontSize: 10,
                        color: _C.red,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (hasValue)
              GestureDetector(
                onTap: _handleClear,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: _C.bg,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(Icons.close_rounded,
                      size: 14, color: _C.textHint),
                ),
              )
            else
              const Icon(Icons.keyboard_arrow_down_rounded,
                  size: 20, color: _C.textHint),
          ],
        ),
      ),
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
        color: _C.card,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                      color: _C.inputBg,
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
                fillColor: _C.inputBg,
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
          const Divider(height: 1, thickness: 0.5, color: _C.border),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(context).size.height * 0.45 - bottomInset,
            ),
            child: _filtered.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: const [
                        Icon(Icons.search_off_rounded,
                            size: 40, color: _C.textHint),
                        SizedBox(height: 10),
                        Text(
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
                          color:
                              isSelected ? _C.greenLight : Colors.transparent,
                          child: Row(
                            children: [
                              isSelected
                                  ? const Icon(Icons.check_circle_rounded,
                                      size: 18, color: _C.darkGreen)
                                  : const Icon(
                                      Icons.radio_button_unchecked_rounded,
                                      size: 18,
                                      color: _C.borderMid),
                              const SizedBox(width: 12),
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
// STATS RIBBON
// ─────────────────────────────────────────────────────────────────────────────

class _StatsRibbon extends StatelessWidget {
  final int totalPts, daysCompleted;
  final bool isFemale;

  const _StatsRibbon({
    required this.totalPts,
    required this.daysCompleted,
    required this.isFemale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 2),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: _RibbonStat(
              emoji: '⭐',
              value: '$totalPts',
              label: 'মাসের পয়েন্ট',
            ),
          ),
          Container(width: 0.5, height: 36, color: _C.border),
          Expanded(
            child: _RibbonStat(
              emoji: '📅',
              value: '$daysCompleted',
              label: 'সম্পন্ন দিন',
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 80.ms).slideY(begin: 0.06);
  }
}

class _RibbonStat extends StatelessWidget {
  final String emoji, value, label;
  final Color? valueColor;

  const _RibbonStat({
    required this.emoji,
    required this.value,
    required this.label,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? _C.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        Text(label, style: const TextStyle(color: _C.textHint, fontSize: 10)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FORM SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _FormSection extends StatelessWidget {
  final String label;
  final List<Widget> children;

  const _FormSection({required this.label, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 8),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: _C.textHint,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _C.border, width: 0.5),
          ),
          child: Column(
            children: List.generate(children.length, (i) {
              return Column(
                children: [
                  children[i],
                  if (i < children.length - 1)
                    const Divider(
                        height: 0.5,
                        thickness: 0.5,
                        color: _C.border,
                        indent: 52),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FIELD ITEM  — with proper optional field behavior
// ─────────────────────────────────────────────────────────────────────────────

class _FieldItem extends StatefulWidget {
  final String label, hint;
  final TextEditingController controller;
  final IconData icon;
  final bool required;
  final TextInputType keyboardType;
  final bool isPhoneField;

  const _FieldItem({
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.required = false,
    this.keyboardType = TextInputType.text,
    this.isPhoneField = false,
  });

  @override
  State<_FieldItem> createState() => _FieldItemState();
}

class _FieldItemState extends State<_FieldItem> {
  bool _focused = false;
  String? _errorText;

  String? _validateBangladeshPhone(String? value) {
    // EMPTY IS VALID for optional field
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    String cleaned = value.trim().replaceAll(RegExp(r'[\s\-+]'), '');
    final bangladeshPhoneRegex = RegExp(r'^01[3-9]\d{8}$');

    if (!bangladeshPhoneRegex.hasMatch(cleaned)) {
      return 'বাংলাদেশের বৈধ ফোন নম্বর দিন (01XXXXXXXXX)';
    }

    return null;
  }

  String? _validateRequired(String? value) {
    if (widget.required && (value?.trim().isEmpty ?? true)) {
      return '${widget.label} আবশ্যক';
    }
    return null;
  }

  void _onChanged(String value) {
    if (widget.isPhoneField) {
      setState(() {
        _errorText = _validateBangladeshPhone(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _focused ? _C.greenLight : _C.bg,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(widget.icon,
                size: 17, color: _focused ? _C.darkGreen : _C.textHint),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.label,
                      style: const TextStyle(
                        color: _C.textSecondary,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.required)
                      const Text(' *',
                          style: TextStyle(color: _C.red, fontSize: 10)),
                    if (widget.isPhoneField)
                      const Text(' (ঐচ্ছিক)',
                          style: TextStyle(color: _C.textHint, fontSize: 9)),
                  ],
                ),
                Focus(
                  onFocusChange: (f) => setState(() => _focused = f),
                  child: TextFormField(
                    controller: widget.controller,
                    keyboardType: widget.keyboardType,
                    validator: widget.isPhoneField
                        ? (value) {
                            final error = _validateBangladeshPhone(value);
                            setState(() => _errorText = error);
                            return error;
                          }
                        : (value) {
                            final error = _validateRequired(value);
                            setState(() => _errorText = error);
                            return error;
                          },
                    onChanged: widget.isPhoneField ? _onChanged : null,
                    style: const TextStyle(
                      color: _C.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding:
                          const EdgeInsets.only(top: 15, bottom: 15, left: 9),
                      border: InputBorder.none,
                      hintText: widget.hint,
                      hintStyle: const TextStyle(
                        color: _C.textHint,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      errorText: _errorText,
                      errorStyle: const TextStyle(
                        fontSize: 10,
                        color: _C.red,
                      ),
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
// READONLY FIELD
// ─────────────────────────────────────────────────────────────────────────────

class _ReadonlyField extends StatelessWidget {
  final String label, value;
  final IconData icon;

  const _ReadonlyField({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _C.bg,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 17, color: _C.textHint),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: _C.textHint,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: const TextStyle(
                    color: _C.textSecondary,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: _C.bg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'লক',
              style: TextStyle(
                color: _C.textHint,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SAVE BUTTON
// ─────────────────────────────────────────────────────────────────────────────

class _SaveButton extends StatelessWidget {
  final bool saving;
  final VoidCallback onTap;
  final bool hasChanges;

  const _SaveButton({
    required this.saving,
    required this.onTap,
    required this.hasChanges,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = hasChanges && !saving;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: 200.ms,
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: _getBackgroundColor(isEnabled),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isEnabled && !saving
              ? [
                  BoxShadow(
                    color: _C.darkGreen.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: AnimatedSwitcher(
          duration: 200.ms,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _buildButtonContent(isEnabled),
        ),
      ),
    );
  }

  Color _getBackgroundColor(bool isEnabled) {
    if (saving) return _C.darkGreen.withOpacity(0.7);
    if (!isEnabled) return _C.darkGreen.withOpacity(0.4);
    return _C.darkGreen;
  }

  Widget _buildButtonContent(bool isEnabled) {
    if (saving) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'সেভ হচ্ছে...',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ],
      );
    }

    if (!isEnabled) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: Colors.white.withOpacity(0.7),
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'কোনো পরিবর্তন নেই',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.8, end: 1.0),
          duration: 300.ms,
          curve: Curves.elasticOut,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: const Icon(
                Icons.save_rounded,
                color: Colors.white,
                size: 18,
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        const Text(
          'পরিবর্তন সেভ করুন',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _ProfileHero extends StatelessWidget {
  final dynamic user;
  final int totalPts, streak;

  const _ProfileHero({
    required this.user,
    required this.totalPts,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final name = user?.name ?? 'ব্যবহারকারী';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    final email = user?.email ?? '';
    final serialId = user?.serialId;
    final district = user?.district;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_C.darkGreen, _C.midGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: 40,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.25), width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          initial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (email.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              email,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          if (serialId != null || district != null) ...[
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.15),
                                    width: 0.5),
                              ),
                              child: Text(
                                [
                                  if (serialId != null) 'ID: $serialId',
                                  if (district != null) district,
                                ].join(' • '),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: _HeroStat(
                        label: 'এই মাস',
                        value: '$totalPts pts',
                        icon: '⭐',
                      ),
                    ),
                    Container(
                      width: 0.5,
                      height: 32,
                      color: Colors.white.withOpacity(0.15),
                    ),
                    Expanded(
                      child: _HeroStat(
                        label: 'ধারাবাহিক',
                        value: '$streak দিন',
                        icon: '🔥',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String label, value, icon;
  const _HeroStat(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _SubmitBar extends StatelessWidget {
  final bool saving;
  final VoidCallback onTap;
  final bool hasChanges;
  const _SubmitBar(
      {required this.saving, required this.onTap, required this.hasChanges});

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
        child: _SaveButton(
          saving: saving,
          onTap: onTap,
          hasChanges: hasChanges,
        )

        // GestureDetector(
        //   onTap: saving ? null : onTap,
        //   child: AnimatedContainer(
        //     duration: 160.ms,
        //     height: 54,
        //     decoration: BoxDecoration(
        //       color: saving ? _C.darkGreen.withOpacity(0.65) : _C.darkGreen,
        //       borderRadius: BorderRadius.circular(16),
        //       boxShadow: saving
        //           ? []
        //           : [
        //               BoxShadow(
        //                 color: _C.darkGreen.withOpacity(0.2),
        //                 blurRadius: 16,
        //                 offset: const Offset(0, 6),
        //               ),
        //             ],
        //     ),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: saving
        //           ? const [
        //               SizedBox(
        //                 width: 18,
        //                 height: 18,
        //                 child: CircularProgressIndicator(
        //                   color: Colors.white,
        //                   strokeWidth: 2,
        //                 ),
        //               ),
        //             ]
        //           : const [
        //               Icon(Icons.lock_rounded, color: Colors.white, size: 18),
        //               SizedBox(width: 8),
        //               Text('পাসওয়ার্ড পরিবর্তন করুন',
        //                   style: TextStyle(
        //                     color: Colors.white,
        //                     fontWeight: FontWeight.w800,
        //                     fontSize: 15,
        //                   )),
        //             ],
        //     ),
        //   ),
        // ),
        );
  }
}
