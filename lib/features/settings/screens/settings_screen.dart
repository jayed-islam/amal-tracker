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
//   static const midGreen = Color(0xFF1B7045);
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const gold = Color(0xFFD4A843);
//   static const goldLight = Color(0xFFFFF8E7);
//   static const amber = Color(0xFFF59E0B);
//   static const amberLight = Color(0xFFFFF3E0);
//   static const blue = Color(0xFF0891B2);
//   static const blueLight = Color(0xFFE0F2FE);
//   static const purple = Color(0xFF7C3AED);
//   static const purpleLight = Color(0xFFEDE9FE);
//   static const red = Color(0xFFEF4444);
//   static const redLight = Color(0xFFFEF2F2);
//   static const border = Color(0xFFE4EAE4);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SETTINGS PROVIDER  — local prefs (extend with shared_preferences later)
// // ─────────────────────────────────────────────────────────────────────────────

// class SettingsState {
//   final bool prayerReminder;
//   final bool dailyEntryReminder;
//   final bool weeklyReport;
//   final bool leaderboardUpdates;
//   final String reminderTime; // "08:00"
//   final bool vibration;
//   final bool sound;

//   const SettingsState({
//     this.prayerReminder = true,
//     this.dailyEntryReminder = true,
//     this.weeklyReport = false,
//     this.leaderboardUpdates = true,
//     this.reminderTime = '08:00',
//     this.vibration = true,
//     this.sound = true,
//   });

//   SettingsState copyWith({
//     bool? prayerReminder,
//     bool? dailyEntryReminder,
//     bool? weeklyReport,
//     bool? leaderboardUpdates,
//     String? reminderTime,
//     bool? vibration,
//     bool? sound,
//   }) =>
//       SettingsState(
//         prayerReminder: prayerReminder ?? this.prayerReminder,
//         dailyEntryReminder: dailyEntryReminder ?? this.dailyEntryReminder,
//         weeklyReport: weeklyReport ?? this.weeklyReport,
//         leaderboardUpdates: leaderboardUpdates ?? this.leaderboardUpdates,
//         reminderTime: reminderTime ?? this.reminderTime,
//         vibration: vibration ?? this.vibration,
//         sound: sound ?? this.sound,
//       );
// }

// class SettingsNotifier extends StateNotifier<SettingsState> {
//   SettingsNotifier() : super(const SettingsState());
//   // TODO: load/save from shared_preferences

//   void toggle(String key) {
//     switch (key) {
//       case 'prayerReminder':
//         state = state.copyWith(prayerReminder: !state.prayerReminder);
//         break;
//       case 'dailyEntryReminder':
//         state = state.copyWith(dailyEntryReminder: !state.dailyEntryReminder);
//         break;
//       case 'weeklyReport':
//         state = state.copyWith(weeklyReport: !state.weeklyReport);
//         break;
//       case 'leaderboardUpdates':
//         state = state.copyWith(leaderboardUpdates: !state.leaderboardUpdates);
//         break;
//       case 'vibration':
//         state = state.copyWith(vibration: !state.vibration);
//         break;
//       case 'sound':
//         state = state.copyWith(sound: !state.sound);
//         break;
//     }
//     HapticFeedback.selectionClick();
//   }

//   void setReminderTime(String time) {
//     state = state.copyWith(reminderTime: time);
//   }
// }

// final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
//   (_) => SettingsNotifier(),
// );

// // ─────────────────────────────────────────────────────────────────────────────
// // SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// class SettingsScreen extends ConsumerWidget {
//   const SettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final settings = ref.watch(settingsProvider);
//     final notifier = ref.read(settingsProvider.notifier);
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;
//     final hPad = isTablet ? (size.width - 600) / 2 + 20.0 : 20.0;

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
//                       bottom: 16,
//                       left: hPad,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Text(
//                             'সেটিংস',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 22,
//                               fontWeight: FontWeight.w900,
//                               letterSpacing: -0.4,
//                             ),
//                           ),
//                           Text(
//                             'নোটিফিকেশন ও পছন্দ',
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
//             padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 60),
//             sliver: SliverList(
//               delegate: SliverChildListDelegate([
//                 // ── Notifications ──────────────────────────────────
//                 _GroupLabel(label: 'নোটিফিকেশন')
//                     .animate()
//                     .fadeIn(duration: 260.ms),
//                 const SizedBox(height: 8),
//                 _SettingsCard(
//                   children: [
//                     _ToggleTile(
//                       icon: Icons.mosque_rounded,
//                       iconBg: _C.greenLight,
//                       iconColor: _C.darkGreen,
//                       title: 'নামাজের রিমাইন্ডার',
//                       subtitle: 'প্রতি ওয়াক্তে মনে করিয়ে দেবে',
//                       value: settings.prayerReminder,
//                       onChanged: (_) => notifier.toggle('prayerReminder'),
//                     ),
//                     _Divider(),
//                     _ToggleTile(
//                       icon: Icons.edit_note_rounded,
//                       iconBg: _C.blueLight,
//                       iconColor: _C.blue,
//                       title: 'দৈনিক আমল রিমাইন্ডার',
//                       subtitle: 'আমল রেকর্ড না করলে মনে করাবে',
//                       value: settings.dailyEntryReminder,
//                       onChanged: (_) => notifier.toggle('dailyEntryReminder'),
//                     ),
//                     _Divider(),
//                     _ToggleTile(
//                       icon: Icons.bar_chart_rounded,
//                       iconBg: _C.purpleLight,
//                       iconColor: _C.purple,
//                       title: 'সাপ্তাহিক রিপোর্ট',
//                       subtitle: 'প্রতি সপ্তাহে সারসংক্ষেপ পাঠাবে',
//                       value: settings.weeklyReport,
//                       onChanged: (_) => notifier.toggle('weeklyReport'),
//                     ),
//                     _Divider(),
//                     _ToggleTile(
//                       icon: Icons.emoji_events_rounded,
//                       iconBg: _C.goldLight,
//                       iconColor: _C.gold,
//                       title: 'লিডারবোর্ড আপডেট',
//                       subtitle: 'র‍্যাংক পরিবর্তন হলে জানাবে',
//                       value: settings.leaderboardUpdates,
//                       onChanged: (_) => notifier.toggle('leaderboardUpdates'),
//                     ),
//                   ],
//                 ).animate().fadeIn(delay: 60.ms),

//                 const SizedBox(height: 20),

//                 // ── Reminder time ──────────────────────────────────
//                 if (settings.dailyEntryReminder) ...[
//                   _GroupLabel(label: 'রিমাইন্ডারের সময়')
//                       .animate()
//                       .fadeIn(delay: 100.ms),
//                   const SizedBox(height: 8),
//                   _TimePickerCard(
//                     currentTime: settings.reminderTime,
//                     onPick: (time) => notifier.setReminderTime(time),
//                   ).animate().fadeIn(delay: 120.ms),
//                   const SizedBox(height: 20),
//                 ],

//                 // ── Sound & Vibration ──────────────────────────────
//                 _GroupLabel(label: 'শব্দ ও কম্পন')
//                     .animate()
//                     .fadeIn(delay: 140.ms),
//                 const SizedBox(height: 8),
//                 _SettingsCard(
//                   children: [
//                     _ToggleTile(
//                       icon: Icons.volume_up_rounded,
//                       iconBg: _C.amberLight,
//                       iconColor: _C.amber,
//                       title: 'শব্দ',
//                       subtitle: 'বিজ্ঞপ্তির জন্য শব্দ বাজবে',
//                       value: settings.sound,
//                       onChanged: (_) => notifier.toggle('sound'),
//                     ),
//                     _Divider(),
//                     _ToggleTile(
//                       icon: Icons.vibration_rounded,
//                       iconBg: _C.bg,
//                       iconColor: _C.textSecondary,
//                       title: 'ভাইব্রেশন',
//                       subtitle: 'বিজ্ঞপ্তির সময় কম্পন হবে',
//                       value: settings.vibration,
//                       onChanged: (_) => notifier.toggle('vibration'),
//                     ),
//                   ],
//                 ).animate().fadeIn(delay: 160.ms),

//                 const SizedBox(height: 20),

//                 // ── App info ───────────────────────────────────────
//                 _GroupLabel(label: 'অ্যাপ সম্পর্কে')
//                     .animate()
//                     .fadeIn(delay: 180.ms),
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
//                       icon: Icons.shield_outlined,
//                       iconBg: _C.greenLight,
//                       iconColor: _C.green,
//                       title: 'গোপনীয়তা নীতি',
//                       showArrow: true,
//                       onTap: () {
//                         // TODO: open privacy policy URL
//                       },
//                     ),
//                     _Divider(),
//                     _InfoTile(
//                       icon: Icons.description_outlined,
//                       iconBg: _C.purpleLight,
//                       iconColor: _C.purple,
//                       title: 'ব্যবহারের শর্তাবলী',
//                       showArrow: true,
//                       onTap: () {
//                         // TODO: open terms URL
//                       },
//                     ),
//                   ],
//                 ).animate().fadeIn(delay: 200.ms),

//                 const SizedBox(height: 20),

//                 // ── Danger zone ────────────────────────────────────
//                 _GroupLabel(label: 'বিপজ্জনক অঞ্চল', danger: true)
//                     .animate()
//                     .fadeIn(delay: 220.ms),
//                 const SizedBox(height: 8),
//                 _DangerCard().animate().fadeIn(delay: 240.ms),

//                 SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
//               ]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // COMPONENTS
// // ─────────────────────────────────────────────────────────────────────────────

// class _GroupLabel extends StatelessWidget {
//   final String label;
//   final bool danger;
//   const _GroupLabel({required this.label, this.danger = false});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 4),
//       child: Text(
//         label.toUpperCase(),
//         style: TextStyle(
//           color: danger ? _C.red.withOpacity(0.7) : _C.textHint,
//           fontSize: 10,
//           fontWeight: FontWeight.w700,
//           letterSpacing: 0.7,
//         ),
//       ),
//     );
//   }
// }

// class _SettingsCard extends StatelessWidget {
//   final List<Widget> children;
//   const _SettingsCard({required this.children});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       child: Column(children: children),
//     );
//   }
// }

// class _Divider extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.only(left: 54),
//       child: Divider(height: 0.5, thickness: 0.5, color: _C.border),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // TOGGLE TILE
// // ─────────────────────────────────────────────────────────────────────────────

// class _ToggleTile extends StatelessWidget {
//   final IconData icon;
//   final Color iconBg, iconColor;
//   final String title, subtitle;
//   final bool value;
//   final ValueChanged<bool> onChanged;

//   const _ToggleTile({
//     required this.icon,
//     required this.iconBg,
//     required this.iconColor,
//     required this.title,
//     required this.subtitle,
//     required this.value,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       child: Row(
//         children: [
//           Container(
//             width: 38,
//             height: 38,
//             decoration: BoxDecoration(
//               color: iconBg,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: iconColor, size: 18),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title,
//                     style: const TextStyle(
//                         color: _C.textPrimary,
//                         fontSize: 13.5,
//                         fontWeight: FontWeight.w700)),
//                 Text(subtitle,
//                     style:
//                         const TextStyle(color: _C.textSecondary, fontSize: 11)),
//               ],
//             ),
//           ),
//           _Toggle(value: value, onChanged: onChanged),
//         ],
//       ),
//     );
//   }
// }

// class _Toggle extends StatelessWidget {
//   final bool value;
//   final ValueChanged<bool> onChanged;
//   const _Toggle({required this.value, required this.onChanged});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => onChanged(!value),
//       child: AnimatedContainer(
//         duration: 200.ms,
//         width: 46,
//         height: 26,
//         padding: const EdgeInsets.all(3),
//         decoration: BoxDecoration(
//           color: value ? _C.midGreen : _C.border,
//           borderRadius: BorderRadius.circular(99),
//         ),
//         child: AnimatedAlign(
//           duration: 200.ms,
//           curve: Curves.easeInOut,
//           alignment: value ? Alignment.centerRight : Alignment.centerLeft,
//           child: Container(
//             width: 20,
//             height: 20,
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // INFO TILE
// // ─────────────────────────────────────────────────────────────────────────────

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
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       behavior: HitTestBehavior.opaque,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
//         child: Row(
//           children: [
//             Container(
//               width: 38,
//               height: 38,
//               decoration: BoxDecoration(
//                 color: iconBg,
//                 borderRadius: BorderRadius.circular(10),
//               ),
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
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // TIME PICKER CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _TimePickerCard extends StatelessWidget {
//   final String currentTime;
//   final ValueChanged<String> onPick;

//   const _TimePickerCard({required this.currentTime, required this.onPick});

//   Future<void> _pick(BuildContext context) async {
//     final parts = currentTime.split(':');
//     final initial = TimeOfDay(
//       hour: int.tryParse(parts[0]) ?? 8,
//       minute: int.tryParse(parts[1]) ?? 0,
//     );
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: initial,
//       builder: (ctx, child) => Theme(
//         data: Theme.of(ctx).copyWith(
//           colorScheme: const ColorScheme.light(primary: _C.darkGreen),
//         ),
//         child: child!,
//       ),
//     );
//     if (picked != null) {
//       final h = picked.hour.toString().padLeft(2, '0');
//       final m = picked.minute.toString().padLeft(2, '0');
//       onPick('$h:$m');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _pick(context),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//         decoration: BoxDecoration(
//           color: _C.card,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: _C.border, width: 0.5),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 38,
//               height: 38,
//               decoration: BoxDecoration(
//                 color: _C.greenLight,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Icon(Icons.access_time_rounded,
//                   color: _C.darkGreen, size: 18),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('রিমাইন্ডারের সময়',
//                       style: TextStyle(
//                           color: _C.textPrimary,
//                           fontSize: 13.5,
//                           fontWeight: FontWeight.w700)),
//                   Text('ট্যাপ করে সময় বদলান',
//                       style: const TextStyle(
//                           color: _C.textSecondary, fontSize: 11)),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: _C.greenLight,
//                 borderRadius: BorderRadius.circular(10),
//                 border:
//                     Border.all(color: _C.green.withOpacity(0.3), width: 0.5),
//               ),
//               child: Text(
//                 currentTime,
//                 style: const TextStyle(
//                   color: _C.darkGreen,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w800,
//                   letterSpacing: 0.5,
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
// // DANGER CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _DangerCard extends ConsumerWidget {
//   const _DangerCard();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.red.withOpacity(0.2), width: 0.5),
//       ),
//       child: Column(
//         children: [
//           // Clear cache
//           GestureDetector(
//             onTap: () {
//               HapticFeedback.mediumImpact();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: const Text('ক্যাশ পরিষ্কার হয়েছে'),
//                   backgroundColor: _C.darkGreen,
//                   margin: const EdgeInsets.all(16),
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   duration: const Duration(seconds: 2),
//                 ),
//               );
//             },
//             behavior: HitTestBehavior.opaque,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 38,
//                     height: 38,
//                     decoration: BoxDecoration(
//                       color: _C.amberLight,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(Icons.cleaning_services_rounded,
//                         color: _C.amber, size: 18),
//                   ),
//                   const SizedBox(width: 12),
//                   const Expanded(
//                     child: Column(
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
//                       ],
//                     ),
//                   ),
//                   const Icon(Icons.chevron_right_rounded,
//                       color: _C.textHint, size: 18),
//                 ],
//               ),
//             ),
//           ),

//           const Padding(
//             padding: EdgeInsets.only(left: 54),
//             child:
//                 Divider(height: 0.5, thickness: 0.5, color: Color(0xFFFEE2E2)),
//           ),

//           // Delete account
//           GestureDetector(
//             onTap: () => _confirmDelete(context),
//             behavior: HitTestBehavior.opaque,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 38,
//                     height: 38,
//                     decoration: BoxDecoration(
//                       color: _C.redLight,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(Icons.delete_forever_rounded,
//                         color: _C.red, size: 18),
//                   ),
//                   const SizedBox(width: 12),
//                   const Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('অ্যাকাউন্ট মুছুন',
//                             style: TextStyle(
//                                 color: _C.red,
//                                 fontSize: 13.5,
//                                 fontWeight: FontWeight.w700)),
//                         Text('সমস্ত ডেটা স্থায়ীভাবে মুছে যাবে',
//                             style: TextStyle(color: _C.red, fontSize: 11)),
//                       ],
//                     ),
//                   ),
//                   const Icon(Icons.chevron_right_rounded,
//                       color: _C.red, size: 18),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _confirmDelete(BuildContext context) {
//     HapticFeedback.heavyImpact();
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: _C.card,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration:
//                 const BoxDecoration(color: _C.redLight, shape: BoxShape.circle),
//             child: const Icon(Icons.warning_amber_rounded,
//                 color: _C.red, size: 20),
//           ),
//           const SizedBox(width: 10),
//           const Text('অ্যাকাউন্ট মুছবেন?',
//               style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 16,
//                   color: _C.textPrimary)),
//         ]),
//         content: const Text(
//           'এই কাজটি পূর্বাবস্থায় ফেরানো যাবে না। আপনার সমস্ত আমল ডেটা, পয়েন্ট ও র‍্যাংকিং স্থায়ীভাবে মুছে যাবে।',
//           style: TextStyle(color: _C.textSecondary, fontSize: 13, height: 1.5),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('বাতিল',
//                 style: TextStyle(
//                     color: _C.textSecondary, fontWeight: FontWeight.w600)),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // TODO: call delete account API
//             },
//             style: TextButton.styleFrom(
//               backgroundColor: _C.redLight,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10)),
//             ),
//             child: const Text('হ্যাঁ, মুছুন',
//                 style: TextStyle(color: _C.red, fontWeight: FontWeight.w700)),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:amal_tracker/features/notification/provider/notification_provider.dart';
// import 'package:amal_tracker/features/user/widgets/app_silver_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class _C {
//   static const bg = Color(0xFFF4F6F1);
//   static const card = Color(0xFFFFFFFF);
//   static const darkGreen = Color(0xFF0E3D22);
//   static const midGreen = Color(0xFF1B7045);
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const gold = Color(0xFFD4A843);
//   static const goldLight = Color(0xFFFFF8E7);
//   static const amber = Color(0xFFF59E0B);
//   static const amberLight = Color(0xFFFFF3E0);
//   static const blue = Color(0xFF0891B2);
//   static const blueLight = Color(0xFFE0F2FE);
//   static const purple = Color(0xFF7C3AED);
//   static const purpleLight = Color(0xFFEDE9FE);
//   static const red = Color(0xFFEF4444);
//   static const redLight = Color(0xFFFEF2F2);
//   static const border = Color(0xFFE4EAE4);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SETTINGS PROVIDER
// //   REMOVED: prayerReminder, dailyEntryReminder, weeklyReport,
// //              leaderboardUpdates, reminderTime, vibration, sound
// //    These now live in NotificationSettingsNotifier (notification_provider.dart)
// // ─────────────────────────────────────────────────────────────────────────────

// class SettingsState {
//   // Only non-notification prefs remain here
//   const SettingsState();
//   // Add future app prefs here (theme, language, etc.)
// }

// class SettingsNotifier extends StateNotifier<SettingsState> {
//   SettingsNotifier() : super(const SettingsState());
//   // TODO: load/save from shared_preferences
// }

// final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
//   (_) => SettingsNotifier(),
// );

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

//     return Scaffold(
//       backgroundColor: _C.bg,
//       body: CustomScrollView(
//         controller: _scrollController,
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           // ── App Bar (unchanged) ───────────────────────────────────
//           AppSliverBar(
//             scrollController: _scrollController,
//             title: 'সেটিংস',
//             subtitle: 'নোটিফিকেশন ও পছন্দ',
//             icon: Icons.settings_outlined,
//             color: _C.darkGreen,
//           ),

//           // ── Body ─────────────────────────────────────────────────
//           SliverPadding(
//             padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 60),
//             sliver: SliverList(
//               delegate: SliverChildListDelegate([
//                 const _GroupLabel(label: 'নোটিফিকেশন')
//                     .animate()
//                     .fadeIn(duration: 260.ms),
//                 const SizedBox(height: 8),
//                 _NotificationEntryRow(
//                   onTap: () => context.push('/notification-settings'),
//                 ).animate().fadeIn(delay: 60.ms),

//                 const SizedBox(height: 20),

//                 // ════════════════════════════════════════════════════
//                 // APP INFO  (unchanged)
//                 // ════════════════════════════════════════════════════
//                 _GroupLabel(label: 'অ্যাপ সম্পর্কে')
//                     .animate()
//                     .fadeIn(delay: 80.ms),
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
//                       icon: Icons.shield_outlined,
//                       iconBg: _C.greenLight,
//                       iconColor: _C.green,
//                       title: 'গোপনীয়তা নীতি',
//                       showArrow: true,
//                       onTap: () {/* TODO: open privacy policy URL */},
//                     ),
//                     _Divider(),
//                     _InfoTile(
//                       icon: Icons.description_outlined,
//                       iconBg: _C.purpleLight,
//                       iconColor: _C.purple,
//                       title: 'ব্যবহারের শর্তাবলী',
//                       showArrow: true,
//                       onTap: () {/* TODO: open terms URL */},
//                     ),
//                   ],
//                 ).animate().fadeIn(delay: 100.ms),

//                 const SizedBox(height: 20),

//                 // ════════════════════════════════════════════════════
//                 // DANGER ZONE  (unchanged)
//                 // ════════════════════════════════════════════════════
//                 _GroupLabel(label: 'বিপজ্জনক অঞ্চল', danger: true)
//                     .animate()
//                     .fadeIn(delay: 120.ms),
//                 const SizedBox(height: 8),
//                 _DangerCard().animate().fadeIn(delay: 140.ms),

//                 SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
//               ]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // NEW: NOTIFICATION ENTRY ROW
// // Replaces the old notification toggles block entirely.
// // Shows a summary of active notifications from Riverpod.
// // ─────────────────────────────────────────────────────────────────────────────
// class _NotificationEntryRow extends ConsumerWidget {
//   final VoidCallback onTap;
//   const _NotificationEntryRow({required this.onTap});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Live from Riverpod — no static fallback needed
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

//     final _s = settingsAsync.valueOrNull;
//     final isAllOff = _s == null
//         ? false
//         : !_s.dailyReminderEnabled &&
//             !_s.streakAlertEnabled &&
//             !_s.weeklyReviewEnabled;

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
//               color: _C.greenLight,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(Icons.notifications_rounded,
//                 color: _C.darkGreen, size: 18),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('নোটিফিকেশন সেটিংস',
//                     style: TextStyle(
//                         color: _C.textPrimary,
//                         fontSize: 13.5,
//                         fontWeight: FontWeight.w700)),
//                 Text(summary,
//                     style:
//                         const TextStyle(color: _C.textSecondary, fontSize: 11)),
//               ],
//             ),
//           ),
//           // Live pill — green when active, muted when all off
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
//             decoration: BoxDecoration(
//               color: isAllOff ? _C.bg : _C.greenLight,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: isAllOff ? _C.border : _C.green.withOpacity(0.25),
//                 width: 0.5,
//               ),
//             ),
//             child: Text(
//               summary,
//               style: TextStyle(
//                 color: isAllOff ? _C.textHint : _C.darkGreen,
//                 fontSize: 11,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//           const SizedBox(width: 4),
//           const Icon(Icons.chevron_right_rounded, color: _C.textHint, size: 18),
//         ]),
//       ),
//     );
//   }
// }
// // ─────────────────────────────────────────────────────────────────────────────
// // BELOW: All original components — completely unchanged
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

// class _DangerCard extends ConsumerWidget {
//   const _DangerCard();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) => Container(
//         decoration: BoxDecoration(
//             color: _C.card,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.red.withOpacity(0.2), width: 0.5)),
//         child: Column(children: [
//           // Clear cache
//           GestureDetector(
//             onTap: () {
//               HapticFeedback.mediumImpact();
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 content: const Text('ক্যাশ পরিষ্কার হয়েছে'),
//                 backgroundColor: _C.darkGreen,
//                 margin: const EdgeInsets.all(16),
//                 behavior: SnackBarBehavior.floating,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//                 duration: const Duration(seconds: 2),
//               ));
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
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('ক্যাশ পরিষ্কার করুন',
//                           style: TextStyle(
//                               color: _C.textPrimary,
//                               fontSize: 13.5,
//                               fontWeight: FontWeight.w700)),
//                       Text('সাময়িক ডেটা মুছে ফেলবে',
//                           style:
//                               TextStyle(color: _C.textSecondary, fontSize: 11)),
//                     ],
//                   ),
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

//           // Delete account
//           GestureDetector(
//             onTap: () => _confirmDelete(context),
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
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('অ্যাকাউন্ট মুছুন',
//                           style: TextStyle(
//                               color: _C.red,
//                               fontSize: 13.5,
//                               fontWeight: FontWeight.w700)),
//                       Text('সমস্ত ডেটা স্থায়ীভাবে মুছে যাবে',
//                           style: TextStyle(color: _C.red, fontSize: 11)),
//                     ],
//                   ),
//                 ),
//                 const Icon(Icons.chevron_right_rounded,
//                     color: _C.red, size: 18),
//               ]),
//             ),
//           ),
//         ]),
//       );

//   void _confirmDelete(BuildContext context) {
//     HapticFeedback.heavyImpact();
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: _C.card,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration:
//                 const BoxDecoration(color: _C.redLight, shape: BoxShape.circle),
//             child: const Icon(Icons.warning_amber_rounded,
//                 color: _C.red, size: 20),
//           ),
//           const SizedBox(width: 10),
//           const Text('অ্যাকাউন্ট মুছবেন?',
//               style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 16,
//                   color: _C.textPrimary)),
//         ]),
//         content: const Text(
//           'এই কাজটি পূর্বাবস্থায় ফেরানো যাবে না। আপনার সমস্ত আমল ডেটা, পয়েন্ট ও র‍্যাংকিং স্থায়ীভাবে মুছে যাবে।',
//           style: TextStyle(color: _C.textSecondary, fontSize: 13, height: 1.5),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('বাতিল',
//                 style: TextStyle(
//                     color: _C.textSecondary, fontWeight: FontWeight.w600)),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // TODO: call delete account API
//             },
//             style: TextButton.styleFrom(
//               backgroundColor: _C.redLight,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10)),
//             ),
//             child: const Text('হ্যাঁ, মুছুন',
//                 style: TextStyle(color: _C.red, fontWeight: FontWeight.w700)),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:amal_tracker/features/auth/providers/privacy_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../auth/providers/auth_provider.dart';

// class _C {
//   static const bg = Color(0xFFF4F6F1);
//   static const card = Color(0xFFFFFFFF);
//   static const darkGreen = Color(0xFF0E3D22);
//   static const midGreen = Color(0xFF1B7045);
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const gold = Color(0xFFD4A843);
//   static const goldLight = Color(0xFFFFF8E7);
//   static const amber = Color(0xFFF59E0B);
//   static const amberLight = Color(0xFFFFF3E0);
//   static const red = Color(0xFFDC2626);
//   static const redLight = Color(0xFFFEF2F2);
//   static const purple = Color(0xFF7C3AED);
//   static const purpleLight = Color(0xFFEDE9FE);
//   static const blue = Color(0xFF0891B2);
//   static const blueLight = Color(0xFFE0F2FE);
//   static const border = Color(0xFFE4EAE4);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
// }

// class SettingsScreen extends ConsumerStatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends ConsumerState<SettingsScreen> {
//   bool _saving = false;

//   @override
//   Widget build(BuildContext context) {
//     final privacy = ref.watch(privacyProvider);
//     final user = ref.watch(currentUserProvider);

//     return Scaffold(
//       backgroundColor: _C.bg,
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           // ── AppBar ───────────────────────────────────────────────
//           SliverAppBar(
//             pinned: true,
//             backgroundColor: _C.darkGreen,
//             surfaceTintColor: Colors.transparent,
//             systemOverlayStyle: SystemUiOverlayStyle.light,
//             leading: GestureDetector(
//               onTap: () => Navigator.pop(context),
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
//               'সেটিংস',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//           ),

//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ── Privacy Section ───────────────────────────────
//                   _SectionHeader(label: 'লিডারবোর্ড গোপনীয়তা'),
//                   const SizedBox(height: 8),

//                   // Info card
//                   _InfoCard(
//                     icon: Icons.info_outline_rounded,
//                     color: _C.blue,
//                     bgColor: _C.blueLight,
//                     text:
//                         'লিডারবোর্ড থেকে নিজেকে সরিয়ে রাখুন। ইসলামে রিয়া থেকে বাঁচতে আমল গোপন রাখা উত্তম।',
//                   ).animate().fadeIn(delay: 60.ms),

//                   const SizedBox(height: 10),

//                   // Privacy toggles card
//                   _ToggleCard(
//                     children: [
//                       // Permanent opt-out
//                       _PrivacyToggle(
//                         icon: Icons.visibility_off_rounded,
//                         iconColor: _C.purple,
//                         iconBg: _C.purpleLight,
//                         title: 'সব লিডারবোর্ড থেকে সরান',
//                         subtitle: 'আমার আমল শুধু আল্লাহর জন্য',
//                         value: privacy.isPermanent,
//                         onChanged: _saving
//                             ? null
//                             : (val) => _updatePrivacy(
//                                   isPermanent: val,
//                                   isHidden: privacy.isHidden,
//                                   showAnonymous: privacy.showAnonymous,
//                                 ),
//                       ),

//                       _Divider(),

//                       // Monthly hide — disabled if permanent
//                       _PrivacyToggle(
//                         icon: Icons.calendar_month_rounded,
//                         iconColor: _C.amber,
//                         iconBg: _C.amberLight,
//                         title: 'এই মাস লুকান',
//                         subtitle: privacy.canRejoinThisMonth == false
//                             ? '⚠️ এই মাসে আর ফিরতে পারবেন না'
//                             : 'শুধু এই মাসের জন্য',
//                         value: privacy.isHidden,
//                         disabled: privacy.isPermanent,
//                         warningText: privacy.canRejoinThisMonth == false
//                             ? 'পরের মাস থেকে স্বয়ংক্রিয় active হবে'
//                             : null,
//                         onChanged: (privacy.isPermanent || _saving)
//                             ? null
//                             : (val) => _updatePrivacy(
//                                   isPermanent: privacy.isPermanent,
//                                   isHidden: val,
//                                   showAnonymous: privacy.showAnonymous,
//                                 ),
//                       ),

//                       _Divider(),

//                       // Anonymous name — always toggleable
//                       _PrivacyToggle(
//                         icon: Icons.person_off_rounded,
//                         iconColor: _C.darkGreen,
//                         iconBg: _C.greenLight,
//                         title: 'নাম Anonymous রাখুন',
//                         subtitle: 'ID ও জেলা দেখাবে, নাম নয়',
//                         value: privacy.showAnonymous,
//                         onChanged: _saving
//                             ? null
//                             : (val) => _updatePrivacy(
//                                   isPermanent: privacy.isPermanent,
//                                   isHidden: privacy.isHidden,
//                                   showAnonymous: val,
//                                 ),
//                       ),
//                     ],
//                   ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.04),

//                   const SizedBox(height: 24),

//                   // ── Notification Section ───────────────────────────
//                   _SectionHeader(label: 'নোটিফিকেশন'),
//                   const SizedBox(height: 8),

//                   _ToggleCard(
//                     children: [
//                       _PrivacyToggle(
//                         icon: Icons.notifications_outlined,
//                         iconColor: _C.green,
//                         iconBg: _C.greenLight,
//                         title: 'দৈনিক রিমাইন্ডার',
//                         subtitle: 'আমল ট্র্যাক করতে মনে করিয়ে দেবে',
//                         value: false, // TODO: connect to notification provider
//                         onChanged: (_) {},
//                       ),
//                     ],
//                   ).animate().fadeIn(delay: 140.ms).slideY(begin: 0.04),

//                   const SizedBox(height: 32),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _updatePrivacy({
//     required bool isPermanent,
//     required bool isHidden,
//     required bool showAnonymous,
//   }) async {
//     HapticFeedback.selectionClick();
//     setState(() => _saving = true);

//     final result = await ref.read(privacyProvider.notifier).updatePrivacy(
//           isPermanent: isPermanent,
//           isHidden: isHidden,
//           showAnonymous: showAnonymous,
//         );

//     setState(() => _saving = false);

//     if (!mounted) return;

//     // যদি monthly lock এর কারণে rejoin না হয়
//     if (result?.canRejoinThisMonth == false && isHidden == false) {
//       _showLockedSnackbar();
//     }
//   }

//   void _showLockedSnackbar() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Row(
//           children: [
//             Icon(Icons.lock_clock_rounded, color: Colors.white, size: 18),
//             SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 'এই মাসে আর leaderboard এ ফিরতে পারবেন না',
//                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: _C.amber,
//         margin: const EdgeInsets.all(16),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION HEADER
// // ─────────────────────────────────────────────────────────────────────────────

// class _SectionHeader extends StatelessWidget {
//   final String label;
//   const _SectionHeader({required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 4, bottom: 2),
//       child: Text(
//         label.toUpperCase(),
//         style: const TextStyle(
//           color: _C.textHint,
//           fontSize: 10,
//           fontWeight: FontWeight.w700,
//           letterSpacing: 0.8,
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // INFO CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _InfoCard extends StatelessWidget {
//   final IconData icon;
//   final Color color, bgColor;
//   final String text;
//   const _InfoCard(
//       {required this.icon,
//       required this.color,
//       required this.bgColor,
//       required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: color.withOpacity(0.2)),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: color, size: 16),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 color: color,
//                 fontSize: 12,
//                 height: 1.5,
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
// // TOGGLE CARD WRAPPER
// // ─────────────────────────────────────────────────────────────────────────────

// class _ToggleCard extends StatelessWidget {
//   final List<Widget> children;
//   const _ToggleCard({required this.children});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       child: Column(children: children),
//     );
//   }
// }

// class _Divider extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const Divider(
//         height: 0.5, thickness: 0.5, color: _C.border, indent: 54);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PRIVACY TOGGLE TILE
// // ─────────────────────────────────────────────────────────────────────────────

// class _PrivacyToggle extends StatelessWidget {
//   final IconData icon;
//   final Color iconColor, iconBg;
//   final String title, subtitle;
//   final bool value;
//   final bool disabled;
//   final String? warningText;
//   final ValueChanged<bool>? onChanged;

//   const _PrivacyToggle({
//     required this.icon,
//     required this.iconColor,
//     required this.iconBg,
//     required this.title,
//     required this.subtitle,
//     required this.value,
//     this.disabled = false,
//     this.warningText,
//     this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Opacity(
//       opacity: disabled ? 0.45 : 1.0,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
//         child: Row(
//           children: [
//             Container(
//               width: 38,
//               height: 38,
//               decoration: BoxDecoration(
//                 color: iconBg,
//                 borderRadius: BorderRadius.circular(11),
//               ),
//               child: Icon(icon, color: iconColor, size: 18),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       color: _C.textPrimary,
//                       fontSize: 13.5,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     subtitle,
//                     style:
//                         const TextStyle(color: _C.textSecondary, fontSize: 11),
//                   ),
//                   if (warningText != null) ...[
//                     const SizedBox(height: 3),
//                     Text(
//                       warningText!,
//                       style: const TextStyle(
//                         color: _C.amber,
//                         fontSize: 10,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Switch.adaptive(
//               value: value,
//               onChanged: disabled ? null : onChanged,
//               activeColor: iconColor,
//               activeTrackColor: iconBg,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
  static const midGreen = Color(0xFF1B7045);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFFFF8E7);
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
// SETTINGS PROVIDER  (non-notification prefs only)
// ─────────────────────────────────────────────────────────────────────────────

class SettingsState {
  const SettingsState();
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState());
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (_) => SettingsNotifier(),
);

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
          // ── App Bar ───────────────────────────────────────────────
          AppSliverBar(
            scrollController: _scrollController,
            title: 'সেটিংস',
            subtitle: 'নোটিফিকেশন ও পছন্দ',
            icon: Icons.settings_outlined,
            color: _C.darkGreen,
          ),

          // ── Body ─────────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 60),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ════════════════════════════════════════════════════
                // NOTIFICATION
                // ════════════════════════════════════════════════════
                const _GroupLabel(label: 'নোটিফিকেশন')
                    .animate()
                    .fadeIn(duration: 260.ms),
                const SizedBox(height: 8),
                _NotificationEntryRow(
                  onTap: () => context.push('/notification-settings'),
                ).animate().fadeIn(delay: 60.ms),

                const SizedBox(height: 24),

                // ════════════════════════════════════════════════════
                // LEADERBOARD PRIVACY
                // ════════════════════════════════════════════════════
                const _GroupLabel(label: 'লিডারবোর্ড গোপনীয়তা')
                    .animate()
                    .fadeIn(delay: 80.ms),
                const SizedBox(height: 4),
                _SubLabel(label: 'আপনার তথ্য কে দেখতে পাবে তা নিয়ন্ত্রণ করুন')
                    .animate()
                    .fadeIn(delay: 90.ms),
                const SizedBox(height: 10),
                _SettingsCard(
                  children: [
                    // Hide from all leaderboards
                    _PrivacyToggleTile(
                      icon: Icons.self_improvement_rounded,
                      iconColor: _C.purple,
                      iconBg: _C.purpleLight,
                      title: 'আমল গোপন রাখুন',
                      subtitle: 'লিডারবোর্ডে আমার কোনো তথ্য দেখাবে না',
                      value: privacy.isPermanent,
                      activeColor: _C.purple,
                      activeTrackColor: _C.purpleLight,
                      onToggle: (val) =>
                          _onPermanentToggle(context, ref, privacy, val),
                    ),
                    _Divider(),
                    // Hide this month
                    _PrivacyToggleTile(
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
                      onToggle: (val) =>
                          _onMonthlyToggle(context, ref, privacy, val),
                    ),
                    _Divider(),
                    // Anonymous name
                    _PrivacyToggleTile(
                      icon: Icons.person_off_rounded,
                      iconColor: _C.teal,
                      iconBg: _C.tealLight,
                      title: 'নাম লুকান',
                      subtitle: 'লিডারবোর্ডে "Anonymous" দেখাবে',
                      value: privacy.showAnonymous,
                      disabled: privacy.isPermanent,
                      activeColor: _C.teal,
                      activeTrackColor: _C.tealLight,
                      onToggle: (val) =>
                          _onAnonymousToggle(context, ref, privacy, val),
                    ),
                  ],
                ).animate().fadeIn(delay: 100.ms),

                const SizedBox(height: 24),

                // ════════════════════════════════════════════════════
                // PROFILE SHARING
                // ════════════════════════════════════════════════════
                const _GroupLabel(label: 'প্রোফাইল শেয়ার')
                    .animate()
                    .fadeIn(delay: 120.ms),
                const SizedBox(height: 4),
                _SubLabel(label: 'অন্যরা আপনার আমলের বিবরণ দেখতে পারবে কিনা')
                    .animate()
                    .fadeIn(delay: 130.ms),
                const SizedBox(height: 10),
                _SettingsCard(
                  children: [
                    _PrivacyToggleTile(
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
                      onToggle: (val) =>
                          _onProfileShareToggle(context, ref, privacy, val),
                    ),
                  ],
                ).animate().fadeIn(delay: 140.ms),

                const SizedBox(height: 24),

                // ════════════════════════════════════════════════════
                // APP INFO
                // ════════════════════════════════════════════════════
                _GroupLabel(label: 'অ্যাপ সম্পর্কে')
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
                      icon: Icons.shield_outlined,
                      iconBg: _C.greenLight,
                      iconColor: _C.green,
                      title: 'গোপনীয়তা নীতি',
                      showArrow: true,
                      onTap: () {/* TODO: open privacy policy URL */},
                    ),
                    _Divider(),
                    _InfoTile(
                      icon: Icons.description_outlined,
                      iconBg: _C.purpleLight,
                      iconColor: _C.purple,
                      title: 'ব্যবহারের শর্তাবলী',
                      showArrow: true,
                      onTap: () {/* TODO: open terms URL */},
                    ),
                  ],
                ).animate().fadeIn(delay: 180.ms),

                const SizedBox(height: 24),

                // ════════════════════════════════════════════════════
                // DANGER ZONE
                // ════════════════════════════════════════════════════
                _GroupLabel(label: 'বিপজ্জনক অঞ্চল', danger: true)
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

  // ── Toggle handlers ───────────────────────────────────────────────────────

  void _onPermanentToggle(
    BuildContext context,
    WidgetRef ref,
    PrivacyState privacy,
    bool newVal,
  ) {
    HapticFeedback.selectionClick();
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        icon: Icons.self_improvement_rounded,
        iconColor: _C.purple,
        iconBg: _C.purpleLight,
        title: newVal ? 'আমল গোপন রাখবেন?' : 'লিডারবোর্ডে ফিরবেন?',
        body: newVal
            ? 'এই ফিচার চালু করলে আপনি কোনো মাসের লিডারবোর্ডে দেখা যাবেন না। '
                'যেকোনো সময় বন্ধ করে আবার অংশ নেওয়া যাবে।'
            : 'এই ফিচার বন্ধ করলে পরের মাস থেকে আপনি আবার লিডারবোর্ডে দেখা যাবেন। '
                'চলতি মাসে যদি আগে থেকে লুকানো থাকেন, তাহলে এই মাসে ফেরা যাবে না।',
        confirmText: newVal ? 'গোপন রাখব' : 'ফিরব',
        confirmColor: _C.purple,
        onConfirm: () {
          ref.read(privacyProvider.notifier).updatePrivacy(
                isPermanent: newVal,
                isHidden: privacy.isHidden,
                showAnonymous: privacy.showAnonymous,
              );
        },
      ),
    );
  }

  void _onMonthlyToggle(
    BuildContext context,
    WidgetRef ref,
    PrivacyState privacy,
    bool newVal,
  ) {
    HapticFeedback.selectionClick();

    if (!newVal && privacy.canRejoinThisMonth == false) {
      showDialog(
        context: context,
        builder: (_) => _ConfirmDialog(
          icon: Icons.lock_clock_rounded,
          iconColor: _C.amber,
          iconBg: _C.amberLight,
          title: 'এই মাসে সম্ভব নয়',
          body: 'আপনি এই মাসে লিডারবোর্ড থেকে বেরিয়ে গেছেন। '
              'মাসের মাঝে ফিরে আসা যায় না। '
              'পরের মাস শুরু হলে আপনি স্বয়ংক্রিয়ভাবে লিডারবোর্ডে ফিরে আসবেন।',
          confirmText: 'বুঝেছি',
          confirmColor: _C.amber,
          showCancel: false,
          onConfirm: () {},
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        icon: Icons.calendar_today_rounded,
        iconColor: _C.amber,
        iconBg: _C.amberLight,
        title: newVal ? 'এই মাস বাদ দেবেন?' : 'এই মাসে ফিরবেন?',
        body: newVal
            ? 'এই মাসের লিডারবোর্ড থেকে আপনার নাম সরিয়ে নেওয়া হবে।\n'
                '⚠️ একবার বাদ দিলে এই মাসে আর ফিরতে পারবেন না। '
                'পরের মাস শুরু হলে স্বয়ংক্রিয়ভাবে যোগ হবেন।'
            : 'এই মাসের লিডারবোর্ডে আবার অংশ নিতে চান?',
        confirmText: newVal ? 'বাদ দিন' : 'যোগ দিন',
        confirmColor: _C.amber,
        onConfirm: () {
          ref.read(privacyProvider.notifier).updatePrivacy(
                isPermanent: privacy.isPermanent,
                isHidden: newVal,
                showAnonymous: privacy.showAnonymous,
              );
        },
      ),
    );
  }

  void _onAnonymousToggle(
    BuildContext context,
    WidgetRef ref,
    PrivacyState privacy,
    bool newVal,
  ) {
    HapticFeedback.selectionClick();
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        icon: Icons.person_off_rounded,
        iconColor: _C.teal,
        iconBg: _C.tealLight,
        title: newVal ? 'নাম লুকাবেন?' : 'নাম দেখাবেন?',
        body: newVal
            ? 'লিডারবোর্ডে আপনার নামের জায়গায় "Anonymous" দেখাবে। '
                'তবে আপনার ID (যেমন: AT001) এবং জেলা দেখা যাবে। '
                'যেকোনো সময় আবার নাম দেখানো যাবে।'
            : 'লিডারবোর্ডে আপনার আসল নাম দেখানো হবে।',
        confirmText: newVal ? 'নাম লুকাই' : 'নাম দেখাই',
        confirmColor: _C.teal,
        onConfirm: () {
          ref.read(privacyProvider.notifier).updatePrivacy(
                isPermanent: privacy.isPermanent,
                isHidden: privacy.isHidden,
                showAnonymous: newVal,
              );
        },
      ),
    );
  }

  void _onProfileShareToggle(
    BuildContext context,
    WidgetRef ref,
    PrivacyState privacy,
    bool newVal,
  ) {
    HapticFeedback.selectionClick();
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        icon: Icons.share_rounded,
        iconColor: _C.blue,
        iconBg: _C.blueLight,
        title: newVal ? 'প্রোফাইল সবার জন্য খুলবেন?' : 'প্রোফাইল বন্ধ করবেন?',
        body: newVal
            ? 'যে কেউ আপনার যেকোনো মাসের আমলের বিস্তারিত দেখতে পারবে। '
                'যেকোনো সময় বন্ধ করা যাবে।'
            : 'প্রোফাইল বন্ধ করলে শুধু আপনি নিজে আপনার আমলের বিবরণ দেখতে পারবেন।',
        confirmText: newVal ? 'সবার জন্য খুলুন' : 'বন্ধ করুন',
        confirmColor: _C.blue,
        onConfirm: () {
          ref.read(privacyProvider.notifier).toggleProfileShare(newVal);
        },
      ),
    );
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

    final _s = settingsAsync.valueOrNull;
    final isAllOff = _s == null
        ? false
        : !_s.dailyReminderEnabled &&
            !_s.streakAlertEnabled &&
            !_s.weeklyReviewEnabled;

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
              color: _C.greenLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.notifications_rounded,
                color: _C.darkGreen, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('নোটিফিকেশন সেটিংস',
                    style: TextStyle(
                        color: _C.textPrimary,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700)),
                Text(summary,
                    style:
                        const TextStyle(color: _C.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: isAllOff ? _C.bg : _C.greenLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isAllOff ? _C.border : _C.green.withOpacity(0.25),
                width: 0.5,
              ),
            ),
            child: Text(
              summary,
              style: TextStyle(
                color: isAllOff ? _C.textHint : _C.darkGreen,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
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

class _PrivacyToggleTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String title, subtitle;
  final bool value;
  final bool disabled;
  final String? warningText;
  final Color activeColor, activeTrackColor;
  final ValueChanged<bool> onToggle;

  const _PrivacyToggleTile({
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
    this.warningText,
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
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: value ? iconBg : const Color(0xFFF4F6F1),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon,
                    color: value ? iconColor : _C.textHint, size: 18),
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
                          fontWeight: value ? FontWeight.w700 : FontWeight.w600,
                        )),
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
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ],
                ),
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
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONFIRM DIALOG  — clean, minimal, no icon header band
// ─────────────────────────────────────────────────────────────────────────────

class _ConfirmDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String title, body;
  final String confirmText;
  final Color confirmColor;
  final bool showCancel;
  final VoidCallback onConfirm;

  const _ConfirmDialog({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.body,
    required this.confirmText,
    required this.confirmColor,
    required this.onConfirm,
    this.showCancel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon + Title ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: _C.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
              child: Text(
                body,
                style: const TextStyle(
                  color: _C.textSecondary,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ),

            // ── Divider ───────────────────────────────────────────
            const Divider(height: 0.5, thickness: 0.5, color: _C.border),

            // ── Actions ───────────────────────────────────────────
            if (showCancel)
              IntrinsicHeight(
                child: Row(
                  children: [
                    // Cancel
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          height: 50,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'বাতিল',
                              style: TextStyle(
                                color: _C.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Vertical divider
                    const VerticalDivider(
                        width: 0.5, thickness: 0.5, color: _C.border),
                    // Confirm
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          onConfirm();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              confirmText,
                              style: TextStyle(
                                color: confirmColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              // Single confirm button (no cancel)
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  onConfirm();
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      confirmText,
                      style: TextStyle(
                        color: confirmColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ).animate().scale(
          begin: const Offset(0.94, 0.94),
          duration: 200.ms,
          curve: Curves.easeOutBack,
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
          // Clear cache
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('ক্যাশ পরিষ্কার হয়েছে'),
                backgroundColor: _C.darkGreen,
                margin: const EdgeInsets.all(16),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                duration: const Duration(seconds: 2),
              ));
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
                          style:
                              TextStyle(color: _C.textSecondary, fontSize: 11)),
                    ],
                  ),
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

          // Delete account
          GestureDetector(
            onTap: () => _confirmDelete(context),
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
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: _C.red, size: 18),
              ]),
            ),
          ),
        ]),
      );

  void _confirmDelete(BuildContext context) {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        icon: Icons.delete_forever_rounded,
        iconColor: _C.red,
        iconBg: _C.redLight,
        title: 'অ্যাকাউন্ট মুছবেন?',
        body: 'এই কাজটি পূর্বাবস্থায় ফেরানো যাবে না। '
            'আপনার সমস্ত আমল ডেটা, পয়েন্ট ও র‍্যাংকিং স্থায়ীভাবে মুছে যাবে।',
        confirmText: 'হ্যাঁ, মুছুন',
        confirmColor: _C.red,
        onConfirm: () {
          // TODO: call delete account API
        },
      ),
    );
  }
}
