// import 'package:amal_tracker/core/router/app_router.dart';
// import 'package:amal_tracker/features/auth/providers/privacy_provider.dart';
// import 'package:amal_tracker/features/notification/provider/notification_provider.dart';
// import 'package:amal_tracker/features/user/widgets/app_silver_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // DESIGN TOKENS
// // ─────────────────────────────────────────────────────────────────────────────

// class _C {
//   static const bg = Color(0xFFF4F6F1);
//   static const card = Color(0xFFFFFFFF);
//   static const darkGreen = Color(0xFF0E3D22);
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const amber = Color(0xFFF59E0B);
//   static const amberLight = Color(0xFFFFF3E0);
//   static const blue = Color(0xFF0891B2);
//   static const blueLight = Color(0xFFE0F2FE);
//   static const purple = Color(0xFF7C3AED);
//   static const purpleLight = Color(0xFFEDE9FE);
//   static const teal = Color(0xFF0D9488);
//   static const tealLight = Color(0xFFCCFBF1);
//   static const red = Color(0xFFEF4444);
//   static const redLight = Color(0xFFFEF2F2);
//   static const border = Color(0xFFE4EAE4);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DIALOG RESULT
// // ─────────────────────────────────────────────────────────────────────────────

// class _DialogResult {
//   final bool confirmed;
//   final bool success;
//   final String error;

//   const _DialogResult.cancelled()
//       : confirmed = false,
//         success = false,
//         error = '';
//   const _DialogResult.ok()
//       : confirmed = true,
//         success = true,
//         error = '';
//   const _DialogResult.fail(this.error)
//       : confirmed = true,
//         success = false;
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // CONFIRM DIALOG
// // ─────────────────────────────────────────────────────────────────────────────
// //
// //  Order of execution on confirm:
// //    1. apiCall()    — network only, throws on failure
// //    2. onSuccess()  — setLocalState() here → switch flips INSTANTLY
// //    3. pop(ok)      — dialog closes
// //    4. snackbar     — shown by caller
// //
// // ─────────────────────────────────────────────────────────────────────────────

// class _ConfirmDialog extends StatefulWidget {
//   final IconData icon;
//   final Color iconColor, iconBg;
//   final String title, body, confirmText;
//   final Color confirmColor;
//   final bool showCancel;
//   final Future<void> Function() apiCall;
//   final VoidCallback onSuccess; // ← sync local state update only

//   const _ConfirmDialog({
//     required this.icon,
//     required this.iconColor,
//     required this.iconBg,
//     required this.title,
//     required this.body,
//     required this.confirmText,
//     required this.confirmColor,
//     required this.apiCall,
//     required this.onSuccess,
//     this.showCancel = true,
//   });

//   @override
//   State<_ConfirmDialog> createState() => _ConfirmDialogState();
// }

// class _ConfirmDialogState extends State<_ConfirmDialog> {
//   bool _loading = false;

//   Future<void> _handleConfirm() async {
//     if (_loading) return;
//     setState(() => _loading = true);
//     HapticFeedback.selectionClick();

//     try {
//       await widget.apiCall(); // network round-trip
//       if (!mounted) return;
//       widget.onSuccess(); // sync local state → switch flips NOW
//       Navigator.of(context).pop(const _DialogResult.ok());
//     } catch (e) {
//       if (!mounted) return;
//       // onSuccess NOT called → provider stays unchanged → switch stays
//       Navigator.of(context).pop(_DialogResult.fail(e.toString()));
//     }
//   }

//   void _handleCancel() {
//     if (_loading) return;
//     Navigator.of(context).pop(const _DialogResult.cancelled());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: !_loading,
//       child: Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: const EdgeInsets.symmetric(horizontal: 24),
//         child: Container(
//           decoration: BoxDecoration(
//             color: _C.card,
//             borderRadius: BorderRadius.circular(22),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.10),
//                 blurRadius: 32,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           clipBehavior: Clip.antiAlias,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 44,
//                           height: 44,
//                           decoration: BoxDecoration(
//                             color: widget.iconBg,
//                             borderRadius: BorderRadius.circular(13),
//                           ),
//                           child: Icon(widget.icon,
//                               color: widget.iconColor, size: 20),
//                         ),
//                         const SizedBox(width: 14),
//                         Expanded(
//                           child: Text(widget.title,
//                               style: const TextStyle(
//                                 color: _C.textPrimary,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w800,
//                                 letterSpacing: -0.2,
//                               )),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 14),
//                     Text(widget.body,
//                         style: const TextStyle(
//                           color: _C.textSecondary,
//                           fontSize: 13,
//                           height: 1.65,
//                         )),
//                   ],
//                 ),
//               ),
//               const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//               SizedBox(
//                 height: 52,
//                 child: _loading
//                     ? Center(
//                         child: SizedBox(
//                           width: 22,
//                           height: 22,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2.2,
//                             color: widget.confirmColor,
//                           ),
//                         ),
//                       )
//                     : _buildButtons(),
//               ),
//             ],
//           ),
//         ),
//       )
//           .animate()
//           .scale(
//             begin: const Offset(0.92, 0.92),
//             duration: 200.ms,
//             curve: Curves.easeOutBack,
//           )
//           .fadeIn(duration: 160.ms),
//     );
//   }

//   Widget _buildButtons() {
//     if (!widget.showCancel) {
//       return _DialogBtn(
//         label: widget.confirmText,
//         color: widget.confirmColor,
//         bold: true,
//         position: _BtnPos.single,
//         onTap: _handleConfirm,
//       );
//     }
//     return Row(children: [
//       Expanded(
//         child: _DialogBtn(
//           label: 'বাতিল',
//           color: _C.textSecondary,
//           position: _BtnPos.left,
//           onTap: _handleCancel,
//         ),
//       ),
//       const VerticalDivider(width: 0.5, thickness: 0.5, color: _C.border),
//       Expanded(
//         child: _DialogBtn(
//           label: widget.confirmText,
//           color: widget.confirmColor,
//           bold: true,
//           position: _BtnPos.right,
//           onTap: _handleConfirm,
//         ),
//       ),
//     ]);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DIALOG BUTTON
// // ─────────────────────────────────────────────────────────────────────────────

// enum _BtnPos { left, right, single }

// class _DialogBtn extends StatelessWidget {
//   final String label;
//   final Color color;
//   final bool bold;
//   final _BtnPos position;
//   final VoidCallback onTap;

//   const _DialogBtn({
//     required this.label,
//     required this.color,
//     required this.position,
//     required this.onTap,
//     this.bold = false,
//   });

//   BorderRadius get _radius {
//     switch (position) {
//       case _BtnPos.left:
//         return const BorderRadius.only(bottomLeft: Radius.circular(22));
//       case _BtnPos.right:
//         return const BorderRadius.only(bottomRight: Radius.circular(22));
//       case _BtnPos.single:
//         return const BorderRadius.only(
//           bottomLeft: Radius.circular(22),
//           bottomRight: Radius.circular(22),
//         );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: _radius,
//         splashColor: color.withOpacity(0.08),
//         highlightColor: color.withOpacity(0.05),
//         child: SizedBox.expand(
//           child: Center(
//             child: Text(label,
//                 style: TextStyle(
//                   color: color,
//                   fontSize: 13.5,
//                   fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
//                 )),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SHOW DIALOG HELPER
// // ─────────────────────────────────────────────────────────────────────────────

// Future<_DialogResult> _showConfirm(
//   BuildContext context, {
//   required IconData icon,
//   required Color iconColor,
//   required Color iconBg,
//   required String title,
//   required String body,
//   required String confirmText,
//   required Color confirmColor,
//   required Future<void> Function() apiCall,
//   required VoidCallback onSuccess,
//   bool showCancel = true,
// }) async {
//   final result = await showDialog<_DialogResult>(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) => _ConfirmDialog(
//       icon: icon,
//       iconColor: iconColor,
//       iconBg: iconBg,
//       title: title,
//       body: body,
//       confirmText: confirmText,
//       confirmColor: confirmColor,
//       apiCall: apiCall,
//       onSuccess: onSuccess,
//       showCancel: showCancel,
//     ),
//   );
//   return result ?? const _DialogResult.cancelled();
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SNACKBAR HELPER
// // ─────────────────────────────────────────────────────────────────────────────

// void _showSnack(BuildContext context, String message, {bool success = true}) {
//   ScaffoldMessenger.of(context).clearSnackBars();
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Row(children: [
//         Icon(
//           success ? Icons.check_circle_rounded : Icons.error_outline_rounded,
//           color: Colors.white,
//           size: 18,
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(message,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//               )),
//         ),
//       ]),
//       backgroundColor: success ? _C.darkGreen : _C.red,
//       margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       duration: const Duration(seconds: 3),
//     ),
//   );
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SETTINGS PROVIDER
// // ─────────────────────────────────────────────────────────────────────────────

// class SettingsState {
//   const SettingsState();
// }

// class SettingsNotifier extends StateNotifier<SettingsState> {
//   SettingsNotifier() : super(const SettingsState());
// }

// final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
//     (_) => SettingsNotifier());

// // ─────────────────────────────────────────────────────────────────────────────
// // SETTINGS SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// class SettingsScreen extends ConsumerStatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends ConsumerState<SettingsScreen> {
//   late final ScrollController _scrollController;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;
//     final hPad = isTablet ? (size.width - 600) / 2 + 20.0 : 20.0;
//     final privacy = ref.watch(privacyProvider);

//     return Scaffold(
//       backgroundColor: _C.bg,
//       body: CustomScrollView(
//         controller: _scrollController,
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           AppSliverBar(
//             scrollController: _scrollController,
//             title: 'সেটিংস',
//             subtitle: 'নোটিফিকেশন ও পছন্দ',
//             icon: Icons.settings_outlined,
//             color: _C.darkGreen,
//           ),
//           SliverPadding(
//             padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 60),
//             sliver: SliverList(
//               delegate: SliverChildListDelegate([
//                 // ── Notification ──────────────────────────────────
//                 const _GroupLabel(label: 'নোটিফিকেশন')
//                     .animate()
//                     .fadeIn(duration: 260.ms),
//                 const SizedBox(height: 8),
//                 _NotificationEntryRow(
//                   onTap: () => context.push('/notification-settings'),
//                 ).animate().fadeIn(delay: 60.ms),

//                 const SizedBox(height: 24),

//                 // ── Leaderboard Privacy ───────────────────────────
//                 const _GroupLabel(label: 'লিডারবোর্ড গোপনীয়তা')
//                     .animate()
//                     .fadeIn(delay: 80.ms),
//                 const SizedBox(height: 4),
//                 const _SubLabel(
//                         label: 'আপনার তথ্য কে দেখতে পাবে তা নিয়ন্ত্রণ করুন')
//                     .animate()
//                     .fadeIn(delay: 90.ms),
//                 const SizedBox(height: 10),
//                 _SettingsCard(
//                   children: [
//                     _PrivacyTile(
//                       icon: Icons.self_improvement_rounded,
//                       iconColor: _C.purple,
//                       iconBg: _C.purpleLight,
//                       title: 'আমল গোপন রাখুন',
//                       subtitle: 'লিডারবোর্ডে আমার কোনো তথ্য দেখাবে না',
//                       value: privacy.isPermanent,
//                       activeColor: _C.purple,
//                       activeTrackColor: _C.purpleLight,
//                       onToggle: (val) => _onPermanentToggle(privacy, val),
//                     ),
//                     _Divider(),
//                     _PrivacyTile(
//                       icon: Icons.calendar_today_rounded,
//                       iconColor: _C.amber,
//                       iconBg: _C.amberLight,
//                       title: 'এই মাস অংশ নেব না',
//                       subtitle: privacy.canRejoinThisMonth == false
//                           ? 'পরের মাস থেকে স্বয়ংক্রিয় active হবে'
//                           : 'শুধু এই মাসের লিডারবোর্ড থেকে বাদ',
//                       value: privacy.isHidden,
//                       disabled: privacy.isPermanent,
//                       activeColor: _C.amber,
//                       activeTrackColor: _C.amberLight,
//                       warningText: privacy.canRejoinThisMonth == false
//                           ? '⚠️ এই মাসে আর ফিরতে পারবেন না'
//                           : null,
//                       onToggle: (val) => _onMonthlyToggle(privacy, val),
//                     ),
//                     _Divider(),
//                     _PrivacyTile(
//                       icon: Icons.person_off_rounded,
//                       iconColor: _C.teal,
//                       iconBg: _C.tealLight,
//                       title: 'নাম লুকান',
//                       subtitle: 'লিডারবোর্ডে "Anonymous" দেখাবে',
//                       value: privacy.showAnonymous,
//                       disabled: privacy.isPermanent,
//                       activeColor: _C.teal,
//                       activeTrackColor: _C.tealLight,
//                       onToggle: (val) => _onAnonymousToggle(privacy, val),
//                     ),
//                   ],
//                 ).animate().fadeIn(delay: 100.ms),

//                 const SizedBox(height: 24),

//                 // ── Profile Share ─────────────────────────────────
//                 const _GroupLabel(label: 'প্রোফাইল শেয়ার')
//                     .animate()
//                     .fadeIn(delay: 120.ms),
//                 const SizedBox(height: 4),
//                 const _SubLabel(
//                         label: 'অন্যরা আপনার আমলের বিবরণ দেখতে পারবে কিনা')
//                     .animate()
//                     .fadeIn(delay: 130.ms),
//                 const SizedBox(height: 10),
//                 _SettingsCard(
//                   children: [
//                     _PrivacyTile(
//                       icon: Icons.share_rounded,
//                       iconColor: _C.blue,
//                       iconBg: _C.blueLight,
//                       title: 'প্রোফাইল সবার জন্য খুলুন',
//                       subtitle: privacy.isPublic
//                           ? 'যে কেউ আপনার মাসিক আমল দেখতে পারবে'
//                           : 'শুধু আপনি নিজে দেখতে পারবেন',
//                       value: privacy.isPublic,
//                       activeColor: _C.blue,
//                       activeTrackColor: _C.blueLight,
//                       onToggle: (val) => _onProfileShareToggle(privacy, val),
//                     ),
//                   ],
//                 ).animate().fadeIn(delay: 140.ms),

//                 const SizedBox(height: 24),

//                 // ── App Info ──────────────────────────────────────
//                 const _GroupLabel(label: 'অ্যাপ সম্পর্কে')
//                     .animate()
//                     .fadeIn(delay: 160.ms),
//                 const SizedBox(height: 8),
//                 _SettingsCard(
//                   children: [
//                     _InfoTile(
//                       icon: Icons.info_outline_rounded,
//                       iconBg: _C.blueLight,
//                       iconColor: _C.blue,
//                       title: 'সংস্করণ',
//                       trailing: 'v1.0.0',
//                     ),
//                     _Divider(),
//                     _InfoTile(
//                       icon: Icons.security_rounded,
//                       iconBg: _C.greenLight,
//                       iconColor: _C.green,
//                       title: 'গোপনীয়তা নীতি ও ব্যবহারের শর্তাবলী',
//                       showArrow: true,
//                       onTap: () {
//                         context.push(AppRoutes.legal);
//                       },
//                     ),
//                   ],
//                 ).animate().fadeIn(delay: 180.ms),

//                 const SizedBox(height: 24),

//                 // ── Danger Zone ───────────────────────────────────
//                 const _GroupLabel(label: 'বিপজ্জনক অঞ্চল', danger: true)
//                     .animate()
//                     .fadeIn(delay: 200.ms),
//                 const SizedBox(height: 8),
//                 _DangerCard().animate().fadeIn(delay: 220.ms),

//                 SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
//               ]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ──────────────────────────────────────────────────────────────────────────
//   // HANDLERS
//   //
//   //  apiCall    = raw network call, throws on failure
//   //  onSuccess  = notifier.setLocalState(...)  ← sync, zero delay
//   //               setLocalState does NOT make any API call — local only
//   //
//   //  Why this works:
//   //    updatePrivacy() inside the notifier calls the API again → delay
//   //    setLocalState() just does `state = state.copyWith(...)` → instant
//   // ──────────────────────────────────────────────────────────────────────────

//   Future<void> _onPermanentToggle(PrivacyState privacy, bool newVal) async {
//     final result = await _showConfirm(
//       context,
//       icon: Icons.self_improvement_rounded,
//       iconColor: _C.purple,
//       iconBg: _C.purpleLight,
//       title: newVal ? 'আমল গোপন রাখবেন?' : 'লিডারবোর্ডে ফিরবেন?',
//       body: newVal
//           ? 'এই ফিচার চালু করলে আপনি কোনো মাসের লিডারবোর্ডে দেখা যাবেন না। '
//               'যেকোনো সময় বন্ধ করে আবার অংশ নেওয়া যাবে।'
//           : 'এই ফিচার বন্ধ করলে পরের মাস থেকে আপনি আবার লিডারবোর্ডে দেখা যাবেন।',
//       confirmText: newVal ? 'গোপন রাখব' : 'ফিরব',
//       confirmColor: _C.purple,
//       // apiCall: () => PrivacyApi.updatePermanent(newVal),
//       apiCall: () async {
//         final notifier = ref.read(privacyProvider.notifier);
//         await notifier.updatePrivacy(
//           isPermanent: newVal,
//           isHidden: privacy.isHidden,
//           showAnonymous: privacy.showAnonymous,
//         );
//       },
//       // ↓ setLocalState = sync copyWith only, no network call
//       onSuccess: () =>
//           ref.read(privacyProvider.notifier).setLocalState(isPermanent: newVal),
//     );

//     if (!mounted) return;
//     if (result.success) {
//       _showSnack(
//           context,
//           newVal
//               ? 'আমল গোপন রাখা হয়েছে'
//               : 'পরের মাস থেকে লিডারবোর্ডে দেখা যাবে');
//     } else if (result.confirmed) {
//       _showSnack(
//           context,
//           result.error.isNotEmpty
//               ? result.error
//               : 'আপডেট করা যায়নি। আবার চেষ্টা করুন।',
//           success: false);
//     }
//   }

//   Future<void> _onMonthlyToggle(PrivacyState privacy, bool newVal) async {
//     if (!newVal && privacy.canRejoinThisMonth == false) {
//       await _showConfirm(
//         context,
//         icon: Icons.lock_clock_rounded,
//         iconColor: _C.amber,
//         iconBg: _C.amberLight,
//         title: 'এই মাসে সম্ভব নয়',
//         body: 'আপনি এই মাসে লিডারবোর্ড থেকে বেরিয়ে গেছেন। '
//             'পরের মাস শুরু হলে স্বয়ংক্রিয়ভাবে ফিরে আসবেন।',
//         confirmText: 'বুঝেছি',
//         confirmColor: _C.amber,
//         showCancel: false,
//         apiCall: () async {},
//         onSuccess: () {},
//       );
//       return;
//     }
//     final notifier = ref.read(privacyProvider.notifier);

//     final result = await _showConfirm(
//       context,
//       icon: Icons.calendar_today_rounded,
//       iconColor: _C.amber,
//       iconBg: _C.amberLight,
//       title: newVal ? 'এই মাস বাদ দেবেন?' : 'এই মাসে ফিরবেন?',
//       body: newVal
//           ? 'এই মাসের লিডারবোর্ড থেকে আপনার নাম সরিয়ে নেওয়া হবে।\n'
//               '⚠️ একবার বাদ দিলে এই মাসে আর ফিরতে পারবেন না।'
//           : 'এই মাসের লিডারবোর্ডে আবার অংশ নিতে চান?',
//       confirmText: newVal ? 'বাদ দিন' : 'যোগ দিন',
//       confirmColor: _C.amber,
//       // apiCall: () => PrivacyApi.updateHidden(newVal),
//       apiCall: () async {
//         // ✅ CORRECT: Call the actual API method from privacyProvider
//         print('🔵 Calling updatePrivacy with isHidden=$newVal');
//         await notifier.updatePrivacy(
//           isPermanent: privacy.isPermanent,
//           isHidden: newVal,
//           showAnonymous: privacy.showAnonymous,
//         );
//         print('🔵 updatePrivacy completed');
//       },
//       onSuccess: () =>
//           ref.read(privacyProvider.notifier).setLocalState(isHidden: newVal),
//     );

//     if (!mounted) return;
//     if (result.success) {
//       _showSnack(
//           context,
//           newVal
//               ? 'এই মাস থেকে বাদ দেওয়া হয়েছে'
//               : 'এই মাসে যোগ দেওয়া হয়েছে');
//     } else if (result.confirmed) {
//       _showSnack(
//           context,
//           result.error.isNotEmpty
//               ? result.error
//               : 'আপডেট করা যায়নি। আবার চেষ্টা করুন।',
//           success: false);
//     }
//   }

//   Future<void> _onAnonymousToggle(PrivacyState privacy, bool newVal) async {
//     final notifier = ref.read(privacyProvider.notifier);
//     final result = await _showConfirm(
//       context,
//       icon: Icons.person_off_rounded,
//       iconColor: _C.teal,
//       iconBg: _C.tealLight,
//       title: newVal ? 'নাম লুকাবেন?' : 'নাম দেখাবেন?',
//       body: newVal
//           ? 'লিডারবোর্ডে আপনার নামের জায়গায় "Anonymous" দেখাবে। '
//               'ID ও জেলা দেখা যাবে। যেকোনো সময় পরিবর্তন করা যাবে।'
//           : 'লিডারবোর্ডে আপনার আসল নাম দেখানো হবে।',
//       confirmText: newVal ? 'নাম লুকাই' : 'নাম দেখাই',
//       confirmColor: _C.teal,
//       // apiCall: () => PrivacyApi.updateAnonymous(newVal),
//       apiCall: () async {
//         // ✅ CORRECT: Call the actual API method from privacyProvider
//         print('🔵 Calling updatePrivacy with showAnonymous=$newVal');
//         await notifier.updatePrivacy(
//           isPermanent: privacy.isPermanent,
//           isHidden: privacy.isHidden,
//           showAnonymous: newVal,
//         );
//         print('🔵 updatePrivacy completed');
//       },
//       onSuccess: () => ref
//           .read(privacyProvider.notifier)
//           .setLocalState(showAnonymous: newVal),
//     );

//     if (!mounted) return;
//     if (result.success) {
//       _showSnack(context, newVal ? 'নাম লুকানো হয়েছে' : 'নাম দেখানো হচ্ছে');
//     } else if (result.confirmed) {
//       _showSnack(
//           context,
//           result.error.isNotEmpty
//               ? result.error
//               : 'আপডেট করা যায়নি। আবার চেষ্টা করুন।',
//           success: false);
//     }
//   }

//   Future<void> _onProfileShareToggle(PrivacyState privacy, bool newVal) async {
//     final notifier = ref.read(privacyProvider.notifier);
//     final result = await _showConfirm(
//       context,
//       icon: Icons.share_rounded,
//       iconColor: _C.blue,
//       iconBg: _C.blueLight,
//       title: newVal ? 'প্রোফাইল সবার জন্য খুলবেন?' : 'প্রোফাইল বন্ধ করবেন?',
//       body: newVal
//           ? 'যে কেউ আপনার যেকোনো মাসের আমলের বিস্তারিত দেখতে পারবে। '
//               'যেকোনো সময় বন্ধ করা যাবে।'
//           : 'প্রোফাইল বন্ধ করলে শুধু আপনি নিজে আমলের বিবরণ দেখতে পারবেন।',
//       confirmText: newVal ? 'সবার জন্য খুলুন' : 'বন্ধ করুন',
//       confirmColor: _C.blue,
//       // apiCall: () => PrivacyApi.updateProfileShare(newVal),

//       apiCall: () async {
//         // ✅ CORRECT: Call the actual API method from privacyProvider
//         print('🔵 Calling toggleProfileShare with isPublic=$newVal');
//         await notifier.toggleProfileShare(newVal);
//         print('🔵 toggleProfileShare completed');
//       },
//       // toggleProfileShare was already sync — keep it the same
//       onSuccess: () =>
//           ref.read(privacyProvider.notifier).setLocalState(isPublic: newVal),
//     );

//     if (!mounted) return;
//     if (result.success) {
//       _showSnack(
//           context,
//           newVal
//               ? 'প্রোফাইল সবার জন্য খোলা হয়েছে'
//               : 'প্রোফাইল বন্ধ করা হয়েছে');
//     } else if (result.confirmed) {
//       _showSnack(
//           context,
//           result.error.isNotEmpty
//               ? result.error
//               : 'আপডেট করা যায়নি। আবার চেষ্টা করুন।',
//           success: false);
//     }
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // NOTIFICATION ENTRY ROW
// // ─────────────────────────────────────────────────────────────────────────────

// class _NotificationEntryRow extends ConsumerWidget {
//   final VoidCallback onTap;
//   const _NotificationEntryRow({required this.onTap});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final settingsAsync = ref.watch(notificationSettingsProvider);
//     final summary = settingsAsync.when(
//       loading: () => 'লোড হচ্ছে...',
//       error: (_, __) => 'সেটিংস অনুপলব্ধ',
//       data: (s) {
//         final count = [
//           s.dailyReminderEnabled,
//           s.streakAlertEnabled,
//           s.weeklyReviewEnabled,
//         ].where((v) => v).length;
//         if (count == 0) return 'সব বন্ধ';
//         return '$countটি সক্রিয়';
//       },
//     );
//     final s = settingsAsync.valueOrNull;
//     final isAllOff = s != null &&
//         !s.dailyReminderEnabled &&
//         !s.streakAlertEnabled &&
//         !s.weeklyReviewEnabled;

//     return GestureDetector(
//       onTap: () {
//         HapticFeedback.selectionClick();
//         onTap();
//       },
//       behavior: HitTestBehavior.opaque,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//         decoration: BoxDecoration(
//           color: _C.card,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: _C.border, width: 0.5),
//         ),
//         child: Row(children: [
//           Container(
//             width: 38,
//             height: 38,
//             decoration: BoxDecoration(
//                 color: _C.greenLight, borderRadius: BorderRadius.circular(10)),
//             child: const Icon(Icons.notifications_rounded,
//                 color: _C.darkGreen, size: 18),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               const Text('নোটিফিকেশন সেটিংস',
//                   style: TextStyle(
//                       color: _C.textPrimary,
//                       fontSize: 13.5,
//                       fontWeight: FontWeight.w700)),
//               Text(summary,
//                   style:
//                       const TextStyle(color: _C.textSecondary, fontSize: 11)),
//             ]),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
//             decoration: BoxDecoration(
//               color: isAllOff ? _C.bg : _C.greenLight,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                   color: isAllOff ? _C.border : _C.green.withOpacity(0.25),
//                   width: 0.5),
//             ),
//             child: Text(summary,
//                 style: TextStyle(
//                     color: isAllOff ? _C.textHint : _C.darkGreen,
//                     fontSize: 11,
//                     fontWeight: FontWeight.w700)),
//           ),
//           const SizedBox(width: 4),
//           const Icon(Icons.chevron_right_rounded, color: _C.textHint, size: 18),
//         ]),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PRIVACY TOGGLE TILE
// // ─────────────────────────────────────────────────────────────────────────────

// class _PrivacyTile extends StatelessWidget {
//   final IconData icon;
//   final Color iconColor, iconBg;
//   final String title, subtitle;
//   final bool value, disabled;
//   final String? warningText;
//   final Color activeColor, activeTrackColor;
//   final void Function(bool) onToggle;

//   const _PrivacyTile({
//     required this.icon,
//     required this.iconColor,
//     required this.iconBg,
//     required this.title,
//     required this.subtitle,
//     required this.value,
//     required this.activeColor,
//     required this.activeTrackColor,
//     required this.onToggle,
//     this.disabled = false,
//     this.warningText = null,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Opacity(
//       opacity: disabled ? 0.4 : 1.0,
//       child: GestureDetector(
//         onTap: disabled ? null : () => onToggle(!value),
//         behavior: HitTestBehavior.opaque,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
//           child: Row(children: [
//             Container(
//               width: 38,
//               height: 38,
//               decoration: BoxDecoration(
//                 color: value ? iconBg : const Color(0xFFF4F6F1),
//                 borderRadius: BorderRadius.circular(11),
//               ),
//               child:
//                   Icon(icon, color: value ? iconColor : _C.textHint, size: 18),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(title,
//                         style: TextStyle(
//                             color: value ? _C.textPrimary : _C.textSecondary,
//                             fontSize: 13.5,
//                             fontWeight:
//                                 value ? FontWeight.w700 : FontWeight.w600)),
//                     const SizedBox(height: 2),
//                     Text(subtitle,
//                         style: const TextStyle(
//                             color: _C.textSecondary, fontSize: 11)),
//                     if (warningText != null) ...[
//                       const SizedBox(height: 3),
//                       Text(warningText!,
//                           style: const TextStyle(
//                               color: _C.amber,
//                               fontSize: 10.5,
//                               fontWeight: FontWeight.w600)),
//                     ],
//                   ]),
//             ),
//             const SizedBox(width: 8),
//             IgnorePointer(
//               child: Switch.adaptive(
//                 value: value,
//                 onChanged: disabled ? null : (_) {},
//                 activeColor: activeColor,
//                 activeTrackColor: activeTrackColor,
//                 inactiveThumbColor: _C.textHint,
//                 inactiveTrackColor: _C.border,
//               ),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SHARED COMPONENTS
// // ─────────────────────────────────────────────────────────────────────────────

// class _GroupLabel extends StatelessWidget {
//   final String label;
//   final bool danger;
//   const _GroupLabel({required this.label, this.danger = false});

//   @override
//   Widget build(BuildContext context) => Padding(
//         padding: const EdgeInsets.only(left: 4),
//         child: Text(label.toUpperCase(),
//             style: TextStyle(
//                 color: danger ? _C.red.withOpacity(0.7) : _C.textHint,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 0.7)),
//       );
// }

// class _SubLabel extends StatelessWidget {
//   final String label;
//   const _SubLabel({required this.label});

//   @override
//   Widget build(BuildContext context) => Padding(
//         padding: const EdgeInsets.only(left: 4),
//         child: Text(label,
//             style: const TextStyle(color: _C.textSecondary, fontSize: 11.5)),
//       );
// }

// class _SettingsCard extends StatelessWidget {
//   final List<Widget> children;
//   const _SettingsCard({required this.children});

//   @override
//   Widget build(BuildContext context) => Container(
//         decoration: BoxDecoration(
//             color: _C.card,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.border, width: 0.5)),
//         child: Column(children: children),
//       );
// }

// class _Divider extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => const Padding(
//         padding: EdgeInsets.only(left: 54),
//         child: Divider(height: 0.5, thickness: 0.5, color: _C.border),
//       );
// }

// class _InfoTile extends StatelessWidget {
//   final IconData icon;
//   final Color iconBg, iconColor;
//   final String title;
//   final String? trailing;
//   final bool showArrow;
//   final VoidCallback? onTap;

//   const _InfoTile({
//     required this.icon,
//     required this.iconBg,
//     required this.iconColor,
//     required this.title,
//     this.trailing,
//     this.showArrow = false,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) => GestureDetector(
//         onTap: onTap,
//         behavior: HitTestBehavior.opaque,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
//           child: Row(children: [
//             Container(
//               width: 38,
//               height: 38,
//               decoration: BoxDecoration(
//                   color: iconBg, borderRadius: BorderRadius.circular(10)),
//               child: Icon(icon, color: iconColor, size: 18),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(title,
//                   style: const TextStyle(
//                       color: _C.textPrimary,
//                       fontSize: 13.5,
//                       fontWeight: FontWeight.w600)),
//             ),
//             if (trailing != null)
//               Text(trailing!,
//                   style: const TextStyle(
//                       color: _C.textHint,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500)),
//             if (showArrow)
//               const Icon(Icons.chevron_right_rounded,
//                   color: _C.textHint, size: 18),
//           ]),
//         ),
//       );
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DANGER CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _DangerCard extends ConsumerWidget {
//   const _DangerCard();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) => Container(
//         decoration: BoxDecoration(
//             color: _C.card,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.red.withOpacity(0.2), width: 0.5)),
//         child: Column(children: [
//           GestureDetector(
//             onTap: () {
//               HapticFeedback.mediumImpact();
//               _showSnack(context, 'ক্যাশ পরিষ্কার হয়েছে');
//             },
//             behavior: HitTestBehavior.opaque,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
//               child: Row(children: [
//                 Container(
//                   width: 38,
//                   height: 38,
//                   decoration: BoxDecoration(
//                       color: _C.amberLight,
//                       borderRadius: BorderRadius.circular(10)),
//                   child: const Icon(Icons.cleaning_services_rounded,
//                       color: _C.amber, size: 18),
//                 ),
//                 const SizedBox(width: 12),
//                 const Expanded(
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('ক্যাশ পরিষ্কার করুন',
//                             style: TextStyle(
//                                 color: _C.textPrimary,
//                                 fontSize: 13.5,
//                                 fontWeight: FontWeight.w700)),
//                         Text('সাময়িক ডেটা মুছে ফেলবে',
//                             style: TextStyle(
//                                 color: _C.textSecondary, fontSize: 11)),
//                       ]),
//                 ),
//                 const Icon(Icons.chevron_right_rounded,
//                     color: _C.textHint, size: 18),
//               ]),
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.only(left: 54),
//             child:
//                 Divider(height: 0.5, thickness: 0.5, color: Color(0xFFFEE2E2)),
//           ),
//           GestureDetector(
//             onTap: () => _confirmDelete(context, ref),
//             behavior: HitTestBehavior.opaque,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
//               child: Row(children: [
//                 Container(
//                   width: 38,
//                   height: 38,
//                   decoration: BoxDecoration(
//                       color: _C.redLight,
//                       borderRadius: BorderRadius.circular(10)),
//                   child: const Icon(Icons.delete_forever_rounded,
//                       color: _C.red, size: 18),
//                 ),
//                 const SizedBox(width: 12),
//                 const Expanded(
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('অ্যাকাউন্ট মুছুন',
//                             style: TextStyle(
//                                 color: _C.red,
//                                 fontSize: 13.5,
//                                 fontWeight: FontWeight.w700)),
//                         Text('সমস্ত ডেটা স্থায়ীভাবে মুছে যাবে',
//                             style: TextStyle(color: _C.red, fontSize: 11)),
//                       ]),
//                 ),
//                 const Icon(Icons.chevron_right_rounded,
//                     color: _C.red, size: 18),
//               ]),
//             ),
//           ),
//         ]),
//       );

//   Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
//     HapticFeedback.heavyImpact();
//     final result = await _showConfirm(
//       context,
//       icon: Icons.delete_forever_rounded,
//       iconColor: _C.red,
//       iconBg: _C.redLight,
//       title: 'অ্যাকাউন্ট মুছবেন?',
//       body: 'এই কাজটি পূর্বাবস্থায় ফেরানো যাবে না। '
//           'আপনার সমস্ত আমল ডেটা, পয়েন্ট ও র‍্যাংকিং স্থায়ীভাবে মুছে যাবে।',
//       confirmText: 'হ্যাঁ, মুছুন',
//       confirmColor: _C.red,
//       apiCall: () =>
//           Future.delayed(const Duration(seconds: 2)), // TODO: call delete API
//       onSuccess: () {}, // TODO: clear local session state here
//     );

//     if (!context.mounted) return;
//     if (result.success) {
//       _showSnack(context, 'অ্যাকাউন্ট মুছে ফেলা হয়েছে');
//       // TODO: context.go('/onboarding');
//     } else if (result.confirmed) {
//       _showSnack(
//           context,
//           result.error.isNotEmpty
//               ? result.error
//               : 'অ্যাকাউন্ট মুছতে সমস্যা হয়েছে। আবার চেষ্টা করুন।',
//           success: false);
//     }
//   }
// }
import 'package:amal_tracker/core/router/app_router.dart';
import 'package:amal_tracker/features/auth/providers/privacy_provider.dart';
import 'package:amal_tracker/features/notification/provider/notification_provider.dart';
import 'package:amal_tracker/features/user/widgets/app_silver_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────

class _C {
  static const bg = Color(0xFFF4F6F1);
  static const card = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const amber = Color(0xFFF59E0B);
  static const amberLight = Color(0xFFFFF3E0);
  static const blue = Color(0xFF0891B2);
  static const blueLight = Color(0xFFE0F2FE);
  static const purple = Color(0xFF7C3AED);
  static const purpleLight = Color(0xFFEDE9FE);
  static const teal = Color(0xFF0D9488);
  static const tealLight = Color(0xFFCCFBF1);
  static const red = Color(0xFFEF4444);
  static const redLight = Color(0xFFFEF2F2);
  static const border = Color(0xFFE4EAE4);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
}

// ─────────────────────────────────────────────────────────────────────────────
// DIALOG RESULT
// ─────────────────────────────────────────────────────────────────────────────

class _DialogResult {
  final bool confirmed;
  final bool success;
  final String error;

  const _DialogResult.cancelled()
      : confirmed = false,
        success = false,
        error = '';
  const _DialogResult.ok()
      : confirmed = true,
        success = true,
        error = '';
  const _DialogResult.fail(this.error)
      : confirmed = true,
        success = false;
}

// ─────────────────────────────────────────────────────────────────────────────
// CONFIRM DIALOG
// ─────────────────────────────────────────────────────────────────────────────
//
//  Order of execution on confirm:
//    1. apiCall()    — network only, THROWS on failure
//    2. onSuccess()  — setLocalState() here → switch flips INSTANTLY
//    3. pop(ok)      — dialog closes
//    4. snackbar     — shown by caller
//
//  On failure:
//    1. apiCall()    — throws
//    2. catch(e)     — onSuccess NOT called → state unchanged → switch stays
//    3. pop(fail)    — dialog closes with error message
//    4. snackbar     — caller shows error
//
// ─────────────────────────────────────────────────────────────────────────────

class _ConfirmDialog extends StatefulWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String title, body, confirmText;
  final Color confirmColor;
  final bool showCancel;
  final Future<void> Function() apiCall;
  final VoidCallback onSuccess;

  const _ConfirmDialog({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.body,
    required this.confirmText,
    required this.confirmColor,
    required this.apiCall,
    required this.onSuccess,
    this.showCancel = true,
  });

  @override
  State<_ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<_ConfirmDialog> {
  bool _loading = false;

  Future<void> _handleConfirm() async {
    if (_loading) return;
    setState(() => _loading = true);
    HapticFeedback.selectionClick();

    try {
      await widget.apiCall(); // throws on failure
      if (!mounted) return;
      widget.onSuccess(); // only reached if apiCall succeeded
      Navigator.of(context).pop(const _DialogResult.ok());
    } catch (e) {
      if (!mounted) return;
      // onSuccess NOT called — state stays unchanged — switch reverts
      Navigator.of(context).pop(_DialogResult.fail(e.toString()));
    }
  }

  void _handleCancel() {
    if (_loading) return;
    Navigator.of(context).pop(const _DialogResult.cancelled());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_loading,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 32,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: widget.iconBg,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(widget.icon,
                              color: widget.iconColor, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(widget.title,
                              style: const TextStyle(
                                color: _C.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.2,
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(widget.body,
                        style: const TextStyle(
                          color: _C.textSecondary,
                          fontSize: 13,
                          height: 1.65,
                        )),
                  ],
                ),
              ),
              const Divider(height: 0.5, thickness: 0.5, color: _C.border),
              SizedBox(
                height: 52,
                child: _loading
                    ? Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: widget.confirmColor,
                          ),
                        ),
                      )
                    : _buildButtons(),
              ),
            ],
          ),
        ),
      )
          .animate()
          .scale(
            begin: const Offset(0.92, 0.92),
            duration: 200.ms,
            curve: Curves.easeOutBack,
          )
          .fadeIn(duration: 160.ms),
    );
  }

  Widget _buildButtons() {
    if (!widget.showCancel) {
      return _DialogBtn(
        label: widget.confirmText,
        color: widget.confirmColor,
        bold: true,
        position: _BtnPos.single,
        onTap: _handleConfirm,
      );
    }
    return Row(children: [
      Expanded(
        child: _DialogBtn(
          label: 'বাতিল',
          color: _C.textSecondary,
          position: _BtnPos.left,
          onTap: _handleCancel,
        ),
      ),
      const VerticalDivider(width: 0.5, thickness: 0.5, color: _C.border),
      Expanded(
        child: _DialogBtn(
          label: widget.confirmText,
          color: widget.confirmColor,
          bold: true,
          position: _BtnPos.right,
          onTap: _handleConfirm,
        ),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DIALOG BUTTON
// ─────────────────────────────────────────────────────────────────────────────

enum _BtnPos { left, right, single }

class _DialogBtn extends StatelessWidget {
  final String label;
  final Color color;
  final bool bold;
  final _BtnPos position;
  final VoidCallback onTap;

  const _DialogBtn({
    required this.label,
    required this.color,
    required this.position,
    required this.onTap,
    this.bold = false,
  });

  BorderRadius get _radius {
    switch (position) {
      case _BtnPos.left:
        return const BorderRadius.only(bottomLeft: Radius.circular(22));
      case _BtnPos.right:
        return const BorderRadius.only(bottomRight: Radius.circular(22));
      case _BtnPos.single:
        return const BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: _radius,
        splashColor: color.withOpacity(0.08),
        highlightColor: color.withOpacity(0.05),
        child: SizedBox.expand(
          child: Center(
            child: Text(label,
                style: TextStyle(
                  color: color,
                  fontSize: 13.5,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                )),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHOW DIALOG HELPER
// ─────────────────────────────────────────────────────────────────────────────

Future<_DialogResult> _showConfirm(
  BuildContext context, {
  required IconData icon,
  required Color iconColor,
  required Color iconBg,
  required String title,
  required String body,
  required String confirmText,
  required Color confirmColor,
  required Future<void> Function() apiCall,
  required VoidCallback onSuccess,
  bool showCancel = true,
}) async {
  final result = await showDialog<_DialogResult>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _ConfirmDialog(
      icon: icon,
      iconColor: iconColor,
      iconBg: iconBg,
      title: title,
      body: body,
      confirmText: confirmText,
      confirmColor: confirmColor,
      apiCall: apiCall,
      onSuccess: onSuccess,
      showCancel: showCancel,
    ),
  );
  return result ?? const _DialogResult.cancelled();
}

// ─────────────────────────────────────────────────────────────────────────────
// SNACKBAR HELPER
// ─────────────────────────────────────────────────────────────────────────────

void _showSnack(BuildContext context, String message, {bool success = true}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(children: [
        Icon(
          success ? Icons.check_circle_rounded : Icons.error_outline_rounded,
          color: Colors.white,
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              )),
        ),
      ]),
      backgroundColor: success ? _C.darkGreen : _C.red,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      duration: const Duration(seconds: 3),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// SETTINGS PROVIDER
// ─────────────────────────────────────────────────────────────────────────────

class SettingsState {
  const SettingsState();
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState());
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
    (_) => SettingsNotifier());

// ─────────────────────────────────────────────────────────────────────────────
// SETTINGS SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final hPad = isTablet ? (size.width - 600) / 2 + 20.0 : 20.0;
    final privacy = ref.watch(privacyProvider);

    return Scaffold(
      backgroundColor: _C.bg,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          AppSliverBar(
            scrollController: _scrollController,
            title: 'সেটিংস',
            subtitle: 'নোটিফিকেশন ও পছন্দ',
            icon: Icons.settings_outlined,
            color: _C.darkGreen,
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 60),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Notification ──────────────────────────────────
                const _GroupLabel(label: 'নোটিফিকেশন')
                    .animate()
                    .fadeIn(duration: 260.ms),
                const SizedBox(height: 8),
                _NotificationEntryRow(
                  onTap: () => context.push('/notification-settings'),
                ).animate().fadeIn(delay: 60.ms),

                const SizedBox(height: 24),

                // ── Leaderboard Privacy ───────────────────────────
                const _GroupLabel(label: 'লিডারবোর্ড গোপনীয়তা')
                    .animate()
                    .fadeIn(delay: 80.ms),
                const SizedBox(height: 4),
                const _SubLabel(
                        label: 'আপনার তথ্য কে দেখতে পাবে তা নিয়ন্ত্রণ করুন')
                    .animate()
                    .fadeIn(delay: 90.ms),
                const SizedBox(height: 10),
                _SettingsCard(
                  children: [
                    _PrivacyTile(
                      icon: Icons.self_improvement_rounded,
                      iconColor: _C.purple,
                      iconBg: _C.purpleLight,
                      title: 'আমল গোপন রাখুন',
                      subtitle: 'লিডারবোর্ডে আমার কোনো তথ্য দেখাবে না',
                      value: privacy.isPermanent,
                      activeColor: _C.purple,
                      activeTrackColor: _C.purpleLight,
                      onToggle: (val) => _onPermanentToggle(privacy, val),
                    ),
                    _Divider(),
                    _PrivacyTile(
                      icon: Icons.calendar_today_rounded,
                      iconColor: _C.amber,
                      iconBg: _C.amberLight,
                      title: 'এই মাস অংশ নেব না',
                      subtitle: privacy.canRejoinThisMonth == false
                          ? 'পরের মাস থেকে স্বয়ংক্রিয় active হবে'
                          : 'শুধু এই মাসের লিডারবোর্ড থেকে বাদ',
                      value: privacy.isHidden,
                      disabled: privacy.isPermanent,
                      activeColor: _C.amber,
                      activeTrackColor: _C.amberLight,
                      warningText: privacy.canRejoinThisMonth == false
                          ? '⚠️ এই মাসে আর ফিরতে পারবেন না'
                          : null,
                      onToggle: (val) => _onMonthlyToggle(privacy, val),
                    ),
                    _Divider(),
                    _PrivacyTile(
                      icon: Icons.person_off_rounded,
                      iconColor: _C.teal,
                      iconBg: _C.tealLight,
                      title: 'নাম লুকান',
                      subtitle: 'লিডারবোর্ডে "Anonymous" দেখাবে',
                      value: privacy.showAnonymous,
                      disabled: privacy.isPermanent,
                      activeColor: _C.teal,
                      activeTrackColor: _C.tealLight,
                      onToggle: (val) => _onAnonymousToggle(privacy, val),
                    ),
                  ],
                ).animate().fadeIn(delay: 100.ms),

                const SizedBox(height: 24),

                // ── Profile Share ─────────────────────────────────
                const _GroupLabel(label: 'প্রোফাইল শেয়ার')
                    .animate()
                    .fadeIn(delay: 120.ms),
                const SizedBox(height: 4),
                const _SubLabel(
                        label: 'অন্যরা আপনার আমলের বিবরণ দেখতে পারবে কিনা')
                    .animate()
                    .fadeIn(delay: 130.ms),
                const SizedBox(height: 10),
                _SettingsCard(
                  children: [
                    _PrivacyTile(
                      icon: Icons.share_rounded,
                      iconColor: _C.blue,
                      iconBg: _C.blueLight,
                      title: 'প্রোফাইল সবার জন্য খুলুন',
                      subtitle: privacy.isPublic
                          ? 'যে কেউ আপনার মাসিক আমল দেখতে পারবে'
                          : 'শুধু আপনি নিজে দেখতে পারবেন',
                      value: privacy.isPublic,
                      activeColor: _C.blue,
                      activeTrackColor: _C.blueLight,
                      onToggle: (val) => _onProfileShareToggle(privacy, val),
                    ),
                  ],
                ).animate().fadeIn(delay: 140.ms),

                const SizedBox(height: 24),

                // ── App Info ──────────────────────────────────────
                const _GroupLabel(label: 'অ্যাপ সম্পর্কে')
                    .animate()
                    .fadeIn(delay: 160.ms),
                const SizedBox(height: 8),
                _SettingsCard(
                  children: [
                    _InfoTile(
                      icon: Icons.info_outline_rounded,
                      iconBg: _C.blueLight,
                      iconColor: _C.blue,
                      title: 'সংস্করণ',
                      trailing: 'v1.0.0',
                    ),
                    _Divider(),
                    _InfoTile(
                      icon: Icons.security_rounded,
                      iconBg: _C.greenLight,
                      iconColor: _C.green,
                      title: 'গোপনীয়তা নীতি ও ব্যবহারের শর্তাবলী',
                      showArrow: true,
                      onTap: () {
                        context.push(AppRoutes.legal);
                      },
                    ),
                  ],
                ).animate().fadeIn(delay: 180.ms),

                const SizedBox(height: 24),

                // ── Danger Zone ───────────────────────────────────
                const _GroupLabel(label: 'বিপজ্জনক অঞ্চল', danger: true)
                    .animate()
                    .fadeIn(delay: 200.ms),
                const SizedBox(height: 8),
                _DangerCard().animate().fadeIn(delay: 220.ms),

                SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // HANDLERS
  //
  //  apiCall    = raw network call — MUST THROW on failure
  //               updatePrivacy / toggleProfileShare now rethrow,
  //               so any exception propagates to _ConfirmDialogState.catch
  //
  //  onSuccess  = notifier.setLocalState(...)  ← sync, zero delay
  //               called ONLY if apiCall completes without throwing
  //
  //  canRejoinThisMonth: the provider updates this field from the server
  //  response inside updatePrivacy before returning, so after onSuccess
  //  fires, the UI subtitle/warning reflects the new server value.
  // ──────────────────────────────────────────────────────────────────────────

  Future<void> _onPermanentToggle(PrivacyState privacy, bool newVal) async {
    final result = await _showConfirm(
      context,
      icon: Icons.self_improvement_rounded,
      iconColor: _C.purple,
      iconBg: _C.purpleLight,
      title: newVal ? 'আমল গোপন রাখবেন?' : 'লিডারবোর্ডে ফিরবেন?',
      body: newVal
          ? 'এই ফিচার চালু করলে আপনি কোনো মাসের লিডারবোর্ডে দেখা যাবেন না। '
              'যেকোনো সময় বন্ধ করে আবার অংশ নেওয়া যাবে।'
          : 'এই ফিচার বন্ধ করলে পরের মাস থেকে আপনি আবার লিডারবোর্ডে দেখা যাবেন।',
      confirmText: newVal ? 'গোপন রাখব' : 'ফিরব',
      confirmColor: _C.purple,
      // FIX: updatePrivacy now throws on failure — no try/catch here
      apiCall: () => ref.read(privacyProvider.notifier).updatePrivacy(
            isPermanent: newVal,
            isHidden: privacy.isHidden,
            showAnonymous: privacy.showAnonymous,
          ),
      onSuccess: () =>
          ref.read(privacyProvider.notifier).setLocalState(isPermanent: newVal),
    );

    if (!mounted) return;
    if (result.success) {
      _showSnack(
          context,
          newVal
              ? 'আমল গোপন রাখা হয়েছে'
              : 'পরের মাস থেকে লিডারবোর্ডে দেখা যাবে');
    } else if (result.confirmed) {
      _showSnack(
          context,
          result.error.isNotEmpty
              ? result.error
              : 'আপডেট করা যায়নি। আবার চেষ্টা করুন।',
          success: false);
    }
  }

  Future<void> _onMonthlyToggle(PrivacyState privacy, bool newVal) async {
    // Guard: already locked out of this month — show info dialog only
    if (!newVal && privacy.canRejoinThisMonth == false) {
      await _showConfirm(
        context,
        icon: Icons.lock_clock_rounded,
        iconColor: _C.amber,
        iconBg: _C.amberLight,
        title: 'এই মাসে সম্ভব নয়',
        body: 'আপনি এই মাসে লিডারবোর্ড থেকে বেরিয়ে গেছেন। '
            'পরের মাস শুরু হলে স্বয়ংক্রিয়ভাবে ফিরে আসবেন।',
        confirmText: 'বুঝেছি',
        confirmColor: _C.amber,
        showCancel: false,
        apiCall: () async {},
        onSuccess: () {},
      );
      return;
    }

    final result = await _showConfirm(
      context,
      icon: Icons.calendar_today_rounded,
      iconColor: _C.amber,
      iconBg: _C.amberLight,
      title: newVal ? 'এই মাস বাদ দেবেন?' : 'এই মাসে ফিরবেন?',
      body: newVal
          ? 'এই মাসের লিডারবোর্ড থেকে আপনার নাম সরিয়ে নেওয়া হবে।\n'
              '⚠️ একবার বাদ দিলে এই মাসে আর ফিরতে পারবেন না।'
          : 'এই মাসের লিডারবোর্ডে আবার অংশ নিতে চান?',
      confirmText: newVal ? 'বাদ দিন' : 'যোগ দিন',
      confirmColor: _C.amber,
      // FIX: updatePrivacy throws on failure
      apiCall: () => ref.read(privacyProvider.notifier).updatePrivacy(
            isPermanent: privacy.isPermanent,
            isHidden: newVal,
            showAnonymous: privacy.showAnonymous,
          ),
      // FIX: provider already updated canRejoinThisMonth from server response
      // inside updatePrivacy before this fires, so the warning text is correct.
      onSuccess: () =>
          ref.read(privacyProvider.notifier).setLocalState(isHidden: newVal),
    );

    if (!mounted) return;
    if (result.success) {
      _showSnack(
          context,
          newVal
              ? 'এই মাস থেকে বাদ দেওয়া হয়েছে'
              : 'এই মাসে যোগ দেওয়া হয়েছে');
    } else if (result.confirmed) {
      _showSnack(
          context,
          result.error.isNotEmpty
              ? result.error
              : 'আপডেট করা যায়নি। আবার চেষ্টা করুন।',
          success: false);
    }
  }

  Future<void> _onAnonymousToggle(PrivacyState privacy, bool newVal) async {
    final result = await _showConfirm(
      context,
      icon: Icons.person_off_rounded,
      iconColor: _C.teal,
      iconBg: _C.tealLight,
      title: newVal ? 'নাম লুকাবেন?' : 'নাম দেখাবেন?',
      body: newVal
          ? 'লিডারবোর্ডে আপনার নামের জায়গায় "Anonymous" দেখাবে। '
              'ID ও জেলা দেখা যাবে। যেকোনো সময় পরিবর্তন করা যাবে।'
          : 'লিডারবোর্ডে আপনার আসল নাম দেখানো হবে।',
      confirmText: newVal ? 'নাম লুকাই' : 'নাম দেখাই',
      confirmColor: _C.teal,
      // FIX: updatePrivacy throws on failure
      apiCall: () => ref.read(privacyProvider.notifier).updatePrivacy(
            isPermanent: privacy.isPermanent,
            isHidden: privacy.isHidden,
            showAnonymous: newVal,
          ),
      onSuccess: () => ref
          .read(privacyProvider.notifier)
          .setLocalState(showAnonymous: newVal),
    );

    if (!mounted) return;
    if (result.success) {
      _showSnack(context, newVal ? 'নাম লুকানো হয়েছে' : 'নাম দেখানো হচ্ছে');
    } else if (result.confirmed) {
      _showSnack(
          context,
          result.error.isNotEmpty
              ? result.error
              : 'আপডেট করা যায়নি। আবার চেষ্টা করুন।',
          success: false);
    }
  }

  Future<void> _onProfileShareToggle(PrivacyState privacy, bool newVal) async {
    final result = await _showConfirm(
      context,
      icon: Icons.share_rounded,
      iconColor: _C.blue,
      iconBg: _C.blueLight,
      title: newVal ? 'প্রোফাইল সবার জন্য খুলবেন?' : 'প্রোফাইল বন্ধ করবেন?',
      body: newVal
          ? 'যে কেউ আপনার যেকোনো মাসের আমলের বিস্তারিত দেখতে পারবে। '
              'যেকোনো সময় বন্ধ করা যাবে।'
          : 'প্রোফাইল বন্ধ করলে শুধু আপনি নিজে আমলের বিবরণ দেখতে পারবেন।',
      confirmText: newVal ? 'সবার জন্য খুলুন' : 'বন্ধ করুন',
      confirmColor: _C.blue,
      // FIX: toggleProfileShare now throws on failure (no optimistic update)
      apiCall: () =>
          ref.read(privacyProvider.notifier).toggleProfileShare(newVal),
      onSuccess: () =>
          ref.read(privacyProvider.notifier).setLocalState(isPublic: newVal),
    );

    if (!mounted) return;
    if (result.success) {
      _showSnack(
          context,
          newVal
              ? 'প্রোফাইল সবার জন্য খোলা হয়েছে'
              : 'প্রোফাইল বন্ধ করা হয়েছে');
    } else if (result.confirmed) {
      _showSnack(
          context,
          result.error.isNotEmpty
              ? result.error
              : 'আপডেট করা যায়নি। আবার চেষ্টা করুন।',
          success: false);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NOTIFICATION ENTRY ROW
// ─────────────────────────────────────────────────────────────────────────────

class _NotificationEntryRow extends ConsumerWidget {
  final VoidCallback onTap;
  const _NotificationEntryRow({required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(notificationSettingsProvider);
    final summary = settingsAsync.when(
      loading: () => 'লোড হচ্ছে...',
      error: (_, __) => 'সেটিংস অনুপলব্ধ',
      data: (s) {
        final count = [
          s.dailyReminderEnabled,
          s.streakAlertEnabled,
          s.weeklyReviewEnabled,
        ].where((v) => v).length;
        if (count == 0) return 'সব বন্ধ';
        return '$countটি সক্রিয়';
      },
    );
    final s = settingsAsync.valueOrNull;
    final isAllOff = s != null &&
        !s.dailyReminderEnabled &&
        !s.streakAlertEnabled &&
        !s.weeklyReviewEnabled;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.border, width: 0.5),
        ),
        child: Row(children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: _C.greenLight, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.notifications_rounded,
                color: _C.darkGreen, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('নোটিফিকেশন সেটিংস',
                  style: TextStyle(
                      color: _C.textPrimary,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700)),
              Text(summary,
                  style:
                      const TextStyle(color: _C.textSecondary, fontSize: 11)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: isAllOff ? _C.bg : _C.greenLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: isAllOff ? _C.border : _C.green.withOpacity(0.25),
                  width: 0.5),
            ),
            child: Text(summary,
                style: TextStyle(
                    color: isAllOff ? _C.textHint : _C.darkGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded, color: _C.textHint, size: 18),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRIVACY TOGGLE TILE
// ─────────────────────────────────────────────────────────────────────────────

class _PrivacyTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String title, subtitle;
  final bool value, disabled;
  final String? warningText;
  final Color activeColor, activeTrackColor;
  final void Function(bool) onToggle;

  const _PrivacyTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.activeColor,
    required this.activeTrackColor,
    required this.onToggle,
    this.disabled = false,
    this.warningText = null,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.4 : 1.0,
      child: GestureDetector(
        onTap: disabled ? null : () => onToggle(!value),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: value ? iconBg : const Color(0xFFF4F6F1),
                borderRadius: BorderRadius.circular(11),
              ),
              child:
                  Icon(icon, color: value ? iconColor : _C.textHint, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: value ? _C.textPrimary : _C.textSecondary,
                            fontSize: 13.5,
                            fontWeight:
                                value ? FontWeight.w700 : FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(
                            color: _C.textSecondary, fontSize: 11)),
                    if (warningText != null) ...[
                      const SizedBox(height: 3),
                      Text(warningText!,
                          style: const TextStyle(
                              color: _C.amber,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600)),
                    ],
                  ]),
            ),
            const SizedBox(width: 8),
            IgnorePointer(
              child: Switch.adaptive(
                value: value,
                onChanged: disabled ? null : (_) {},
                activeColor: activeColor,
                activeTrackColor: activeTrackColor,
                inactiveThumbColor: _C.textHint,
                inactiveTrackColor: _C.border,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED COMPONENTS
// ─────────────────────────────────────────────────────────────────────────────

class _GroupLabel extends StatelessWidget {
  final String label;
  final bool danger;
  const _GroupLabel({required this.label, this.danger = false});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(label.toUpperCase(),
            style: TextStyle(
                color: danger ? _C.red.withOpacity(0.7) : _C.textHint,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.7)),
      );
}

class _SubLabel extends StatelessWidget {
  final String label;
  const _SubLabel({required this.label});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(label,
            style: const TextStyle(color: _C.textSecondary, fontSize: 11.5)),
      );
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _C.border, width: 0.5)),
        child: Column(children: children),
      );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.only(left: 54),
        child: Divider(height: 0.5, thickness: 0.5, color: _C.border),
      );
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String title;
  final String? trailing;
  final bool showArrow;
  final VoidCallback? onTap;

  const _InfoTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    this.trailing,
    this.showArrow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: iconBg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      color: _C.textPrimary,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600)),
            ),
            if (trailing != null)
              Text(trailing!,
                  style: const TextStyle(
                      color: _C.textHint,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            if (showArrow)
              const Icon(Icons.chevron_right_rounded,
                  color: _C.textHint, size: 18),
          ]),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// DANGER CARD
// ─────────────────────────────────────────────────────────────────────────────

class _DangerCard extends ConsumerWidget {
  const _DangerCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _C.red.withOpacity(0.2), width: 0.5)),
        child: Column(children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              _showSnack(context, 'ক্যাশ পরিষ্কার হয়েছে');
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                      color: _C.amberLight,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.cleaning_services_rounded,
                      color: _C.amber, size: 18),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ক্যাশ পরিষ্কার করুন',
                            style: TextStyle(
                                color: _C.textPrimary,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700)),
                        Text('সাময়িক ডেটা মুছে ফেলবে',
                            style: TextStyle(
                                color: _C.textSecondary, fontSize: 11)),
                      ]),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: _C.textHint, size: 18),
              ]),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 54),
            child:
                Divider(height: 0.5, thickness: 0.5, color: Color(0xFFFEE2E2)),
          ),
          GestureDetector(
            onTap: () => _confirmDelete(context, ref),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                      color: _C.redLight,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.delete_forever_rounded,
                      color: _C.red, size: 18),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('অ্যাকাউন্ট মুছুন',
                            style: TextStyle(
                                color: _C.red,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700)),
                        Text('সমস্ত ডেটা স্থায়ীভাবে মুছে যাবে',
                            style: TextStyle(color: _C.red, fontSize: 11)),
                      ]),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: _C.red, size: 18),
              ]),
            ),
          ),
        ]),
      );

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    HapticFeedback.heavyImpact();
    final result = await _showConfirm(
      context,
      icon: Icons.delete_forever_rounded,
      iconColor: _C.red,
      iconBg: _C.redLight,
      title: 'অ্যাকাউন্ট মুছবেন?',
      body: 'এই কাজটি পূর্বাবস্থায় ফেরানো যাবে না। '
          'আপনার সমস্ত আমল ডেটা, পয়েন্ট ও র‍্যাংকিং স্থায়ীভাবে মুছে যাবে।',
      confirmText: 'হ্যাঁ, মুছুন',
      confirmColor: _C.red,
      apiCall: () =>
          Future.delayed(const Duration(seconds: 2)), // TODO: call delete API
      onSuccess: () {}, // TODO: clear local session state here
    );

    if (!context.mounted) return;
    if (result.success) {
      _showSnack(context, 'অ্যাকাউন্ট মুছে ফেলা হয়েছে');
      // TODO: context.go('/onboarding');
    } else if (result.confirmed) {
      _showSnack(
          context,
          result.error.isNotEmpty
              ? result.error
              : 'অ্যাকাউন্ট মুছতে সমস্যা হয়েছে। আবার চেষ্টা করুন।',
          success: false);
    }
  }
}
