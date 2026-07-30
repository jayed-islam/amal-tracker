// import 'package:amal_tracker/features/auth/providers/auth_provider.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class _C {
//   static const pageBg = context.colors.bg;
//   static const cardBg = context.colors.card;
//   static const darkGreen = context.colors.avatar1;
//   static const midGreen = context.colors.maafText;
//   static const gold = context.colors.gold;
//   static const green = context.colors.green;
//   static const greenLight = context.colors.greenLight;
//   static const amber = context.colors.amber;
//   static const amberLight = context.colors.amberLight;
//   static const red = context.colors.red;
//   static const redLight = context.colors.redLight;
//   static const textPrimary = context.colors.textPri;
//   static const textSecondary = context.colors.textMuted;
//   static const textHint = context.colors.textHint;
//   static const border = context.colors.border;
//   static const borderMid = context.colors.borderMid;
//   static const surfaceAlt = context.colors.inputBg;
// }

// class RecoveryBanner extends ConsumerStatefulWidget {
//   final PendingDeletionInfo info;
//   const RecoveryBanner({required this.info});

//   @override
//   ConsumerState<RecoveryBanner> createState() => RecoveryBannerState();
// }

// class RecoveryBannerState extends ConsumerState<RecoveryBanner> {
//   final _emailCtrl = TextEditingController();
//   final _passCtrl = TextEditingController();
//   bool _expanded = false;
//   bool _loading = false;

//   @override
//   void dispose() {
//     _emailCtrl.dispose();
//     _passCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _recover() async {
//     if (_emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) return;
//     setState(() => _loading = true);
//     HapticFeedback.selectionClick();

//     final success = await ref
//         .read(authProvider.notifier)
//         .cancelDeletion(_emailCtrl.text.trim(), _passCtrl.text);

//     if (!mounted) return;
//     setState(() => _loading = false);

//     if (success) {
//       // authProvider is now authenticated → GoRouter redirects automatically
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('অ্যাকাউন্ট সফলভাবে ফিরিয়ে আনা হয়েছে ✓')),
//       );
//     } else {
//       final error = ref.read(authProvider).error ?? 'ব্যর্থ হয়েছে';
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(error), backgroundColor: Colors.red),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 280),
//       curve: Curves.easeInOut,
//       margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: _C.amberLight,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: _C.amber.withOpacity(0.4)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Header row ──────────────────────────────────────────────
//           Row(children: [
//             const Icon(Icons.hourglass_top_rounded, color: _C.amber, size: 16),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 'অ্যাকাউন্ট মুছে ফেলার প্রক্রিয়ায় (${widget.info.daysLeft} দিন বাকি)',
//                 style: const TextStyle(
//                   color: _C.amber,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ]),
//           const SizedBox(height: 10),

//           // ── Toggle expand ────────────────────────────────────────────
//           if (!_expanded)
//             SizedBox(
//               width: double.infinity,
//               child: TextButton(
//                 onPressed: () => setState(() => _expanded = true),
//                 style: TextButton.styleFrom(
//                   backgroundColor: _C.amber,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                 ),
//                 child: const Text('অ্যাকাউন্ট ফিরিয়ে আনুন',
//                     style:
//                         TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
//               ),
//             ),

//           // ── Credential fields (expanded) ─────────────────────────────
//           if (_expanded) ...[
//             const SizedBox(height: 4),
//             TextField(
//               controller: _emailCtrl,
//               decoration: const InputDecoration(
//                 hintText: 'ইমেইল',
//                 isDense: true,
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _passCtrl,
//               decoration: const InputDecoration(
//                 hintText: 'পাসওয়ার্ড',
//                 isDense: true,
//                 border: OutlineInputBorder(),
//               ),
//               obscureText: true,
//             ),
//             const SizedBox(height: 10),
//             Row(children: [
//               Expanded(
//                 child: TextButton(
//                   onPressed:
//                       _loading ? null : () => setState(() => _expanded = false),
//                   child: const Text('বাতিল'),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 flex: 2,
//                 child: ElevatedButton(
//                   onPressed: _loading ? null : _recover,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _C.amber,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                   ),
//                   child: _loading
//                       ? const SizedBox(
//                           width: 16,
//                           height: 16,
//                           child: CircularProgressIndicator(
//                               strokeWidth: 2, color: Colors.white),
//                         )
//                       : const Text('নিশ্চিত করুন',
//                           style: TextStyle(fontWeight: FontWeight.w700)),
//                 ),
//               ),
//             ]),
//           ],
//         ],
//       ),
//     );
//   }
// }
