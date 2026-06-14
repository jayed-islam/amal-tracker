// import 'package:amal_tracker/features/auth/providers/auth_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

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
