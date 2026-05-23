// // ============================================================
// // notification_settings_page.dart  — Bangla + Riverpod
// // ============================================================

// import 'package:amal_tracker/features/notification/model/notification_setting_model.dart';
// import 'package:amal_tracker/features/notification/provider/notification_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class NotificationSettingsPage extends ConsumerStatefulWidget {
//   const NotificationSettingsPage({super.key});

//   @override
//   ConsumerState<NotificationSettingsPage> createState() =>
//       _NotificationSettingsPageState();
// }

// class _NotificationSettingsPageState
//     extends ConsumerState<NotificationSettingsPage> {
//   // Working draft — uncommitted until Save pressed
//   NotificationSettings? _draft;
//   bool _isSaving = false;

//   NotificationSettings get _current =>
//       _draft ??
//       ref.read(notificationSettingsProvider).valueOrNull ??
//       const NotificationSettings();

//   void _patch(NotificationSettings updated) => setState(() => _draft = updated);

//   // ── Save ────────────────────────────────────────────────
//   Future<void> _save() async {
//     if (_draft == null) return;
//     setState(() => _isSaving = true);
//     await ref
//         .read(notificationSettingsProvider.notifier)
//         .updateSettings(_draft!);
//     setState(() {
//       _isSaving = false;
//       _draft = null;
//     });
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Row(children: [
//             Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
//             SizedBox(width: 8),
//             Text('সেটিংস সংরক্ষিত হয়েছে',
//                 style: TextStyle(fontFamily: 'Poppins')),
//           ]),
//           backgroundColor: const Color(0xFF2E7D5E),
//           behavior: SnackBarBehavior.floating,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           margin: const EdgeInsets.all(12),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   // ── Time Picker ─────────────────────────────────────────
//   Future<TimeOfDay?> _pickTime(TimeOfDay initial) => showTimePicker(
//         context: context,
//         initialTime: initial,
//         builder: (ctx, child) => Theme(
//           data: Theme.of(ctx).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF2E7D5E),
//               onPrimary: Colors.white,
//             ),
//           ),
//           child: child!,
//         ),
//       );

//   String _fmt(TimeOfDay t) {
//     final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
//     final m = t.minute.toString().padLeft(2, '0');
//     final p = t.period == DayPeriod.am ? 'AM' : 'PM';
//     return '$h:$m $p';
//   }

//   static const List<String> _weekdays = [
//     'সোমবার',
//     'মঙ্গলবার',
//     'বুধবার',
//     'বৃহস্পতিবার',
//     'শুক্রবার',
//     'শনিবার',
//     'রবিবার',
//   ];
//   static const List<String> _weekdaysShort = [
//     'সোম',
//     'মঙ্গল',
//     'বুধ',
//     'বৃহ',
//     'শুক্র',
//     'শনি',
//     'রবি',
//   ];

//   // ── Build ───────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     final settingsAsync = ref.watch(notificationSettingsProvider);
//     final permAsync = ref.watch(notificationPermissionProvider);

//     return settingsAsync.when(
//       loading: () => const Scaffold(
//         body:
//             Center(child: CircularProgressIndicator(color: Color(0xFF2E7D5E))),
//       ),
//       error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
//       data: (_) {
//         final s = _current;
//         final hasPermission = permAsync.valueOrNull ?? false;

//         return Scaffold(
//           backgroundColor: const Color(0xFFF7F9F8),
//           appBar: _buildAppBar(),
//           body: ListView(
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
//             children: [
//               // Permission banner
//               if (!hasPermission)
//                 _PermissionBanner(
//                   onAllow: () async {
//                     await ref
//                         .read(notificationPermissionProvider.notifier)
//                         .requestPermission();
//                   },
//                 ),

//               // ── পুশ নোটিফিকেশন ─────────────────────
//               _SectionLabel('📣  অ্যাপ নোটিফিকেশন', const Color(0xFF2196F3)),
//               _Card(children: [
//                 _SwitchRow(
//                   icon: Icons.notifications_rounded,
//                   iconBg: const Color(0xFFE3F2FD),
//                   iconColor: const Color(0xFF2196F3),
//                   title: 'পুশ নোটিফিকেশন',
//                   subtitle: 'অ্যাপের আপডেট ও ঘোষণা',
//                   value: s.pushNotificationsEnabled,
//                   onChanged: (v) =>
//                       _patch(s.copyWith(pushNotificationsEnabled: v)),
//                 ),
//                 _Div(),
//                 _SwitchRow(
//                   icon: Icons.volume_up_rounded,
//                   iconBg: const Color(0xFFE8F5EF),
//                   iconColor: const Color(0xFF2E7D5E),
//                   title: 'সাউন্ড',
//                   subtitle: 'নোটিফিকেশনে শব্দ চালু রাখুন',
//                   value: s.soundEnabled,
//                   onChanged: (v) => _patch(s.copyWith(soundEnabled: v)),
//                 ),
//                 _Div(),
//                 _SwitchRow(
//                   icon: Icons.vibration_rounded,
//                   iconBg: const Color(0xFFE8F5EF),
//                   iconColor: const Color(0xFF2E7D5E),
//                   title: 'ভাইব্রেশন',
//                   subtitle: 'নোটিফিকেশনে কম্পন চালু রাখুন',
//                   value: s.vibrationEnabled,
//                   onChanged: (v) => _patch(s.copyWith(vibrationEnabled: v)),
//                 ),
//               ]),

//               const SizedBox(height: 4),

//               // ── দৈনিক আমল রিমাইন্ডার ─────────────
//               _SectionLabel('✨  দৈনিক আমল রিমাইন্ডার', const Color(0xFF6C63FF)),
//               _Card(children: [
//                 _SwitchRow(
//                   icon: Icons.auto_awesome_rounded,
//                   iconBg: const Color(0xFFEEECFD),
//                   iconColor: const Color(0xFF6C63FF),
//                   title: 'রিমাইন্ডার চালু',
//                   subtitle: 'প্রতিদিন আমল লগ করার স্মরণ',
//                   value: s.dailyReminderEnabled,
//                   onChanged: (v) => _patch(s.copyWith(dailyReminderEnabled: v)),
//                 ),
//                 if (s.dailyReminderEnabled) ...[
//                   _Div(),
//                   _TimeTapRow(
//                     title: 'রিমাইন্ডারের সময়',
//                     time: _fmt(s.dailyReminderTime),
//                     onTap: () async {
//                       final t = await _pickTime(s.dailyReminderTime);
//                       if (t != null) _patch(s.copyWith(dailyReminderTime: t));
//                     },
//                   ),
//                   _Div(),
//                   _EditableRow(
//                     title: 'বার্তা কাস্টমাইজ',
//                     value: s.dailyReminderMessage,
//                     hint: 'আমল লগ করার বার্তা লিখুন...',
//                     onSaved: (v) => _patch(s.copyWith(dailyReminderMessage: v)),
//                   ),
//                 ],
//               ]),

//               const SizedBox(height: 4),

//               // ── স্ট্রিক অ্যালার্ট ─────────────────
//               _SectionLabel('🔥  স্ট্রিক অ্যালার্ট', const Color(0xFFFF6B35)),
//               _Card(children: [
//                 _SwitchRow(
//                   icon: Icons.local_fire_department_rounded,
//                   iconBg: const Color(0xFFFFF0EB),
//                   iconColor: const Color(0xFFFF6B35),
//                   title: 'স্ট্রিক অ্যালার্ট চালু',
//                   subtitle: 'দিন শেষের আগে সতর্ক করবে',
//                   value: s.streakAlertEnabled,
//                   onChanged: (v) => _patch(s.copyWith(streakAlertEnabled: v)),
//                 ),
//                 if (s.streakAlertEnabled) ...[
//                   _Div(),
//                   _TimeTapRow(
//                     title: 'অ্যালার্টের সময়',
//                     time: _fmt(s.streakAlertTime),
//                     onTap: () async {
//                       final t = await _pickTime(s.streakAlertTime);
//                       if (t != null) _patch(s.copyWith(streakAlertTime: t));
//                     },
//                   ),
//                   _Div(),
//                   _InfoRow(
//                     icon: Icons.local_fire_department_rounded,
//                     iconColor: const Color(0xFFFF6B35),
//                     title: 'বর্তমান স্ট্রিক',
//                     value: '${s.currentStreak} দিন',
//                     valueColor: const Color(0xFFFF6B35),
//                   ),
//                 ],
//               ]),

//               const SizedBox(height: 4),

//               // ── সাপ্তাহিক রিভিউ ───────────────────
//               _SectionLabel('📊  সাপ্তাহিক রিভিউ', const Color(0xFF00BFA5)),
//               _Card(children: [
//                 _SwitchRow(
//                   icon: Icons.bar_chart_rounded,
//                   iconBg: const Color(0xFFE0F7F4),
//                   iconColor: const Color(0xFF00BFA5),
//                   title: 'সাপ্তাহিক রিভিউ চালু',
//                   subtitle: 'সাপ্তাহিক আমলের সারসংক্ষেপ',
//                   value: s.weeklyReviewEnabled,
//                   onChanged: (v) => _patch(s.copyWith(weeklyReviewEnabled: v)),
//                 ),
//                 if (s.weeklyReviewEnabled) ...[
//                   _Div(),
//                   _DropdownRow(
//                     title: 'রিভিউর দিন',
//                     value: _weekdays[s.weeklyReviewWeekday - 1],
//                     items: _weekdays,
//                     onChanged: (v) {
//                       if (v == null) return;
//                       _patch(s.copyWith(
//                           weeklyReviewWeekday: _weekdays.indexOf(v) + 1));
//                     },
//                   ),
//                   _Div(),
//                   _TimeTapRow(
//                     title: 'রিভিউর সময়',
//                     time: _fmt(s.weeklyReviewTime),
//                     onTap: () async {
//                       final t = await _pickTime(s.weeklyReviewTime);
//                       if (t != null) _patch(s.copyWith(weeklyReviewTime: t));
//                     },
//                   ),
//                 ],
//               ]),

//               const SizedBox(height: 20),

//               // ── সক্রিয় সময়সূচী প্রিভিউ ──────────
//               _ActiveSchedulePreview(
//                   s: s, fmt: _fmt, weekdaysShort: _weekdaysShort),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   AppBar _buildAppBar() => AppBar(
//         title: const Text('নোটিফিকেশন সেটিংস',
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w600,
//               fontSize: 17,
//               color: Color(0xFF1A2E2A),
//             )),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         surfaceTintColor: Colors.transparent,
//         leading: const BackButton(color: Color(0xFF2E7D5E)),
//         actions: [
//           if (_draft != null)
//             _isSaving
//                 ? const Padding(
//                     padding: EdgeInsets.all(16),
//                     child: SizedBox(
//                       width: 18,
//                       height: 18,
//                       child: CircularProgressIndicator(
//                           strokeWidth: 2, color: Color(0xFF2E7D5E)),
//                     ),
//                   )
//                 : TextButton(
//                     onPressed: _save,
//                     child: const Text('সংরক্ষণ',
//                         style: TextStyle(
//                           color: Color(0xFF2E7D5E),
//                           fontWeight: FontWeight.w700,
//                           fontFamily: 'Poppins',
//                         )),
//                   ),
//         ],
//       );
// }

// // ─── Shared small widgets ─────────────────────────────────────

// class _SectionLabel extends StatelessWidget {
//   final String text;
//   final Color color;
//   const _SectionLabel(this.text, this.color);

//   @override
//   Widget build(BuildContext context) => Padding(
//         padding: const EdgeInsets.only(left: 4, top: 10, bottom: 6),
//         child: Text(
//           text,
//           style: TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w700,
//             color: color,
//             letterSpacing: 0.4,
//             fontFamily: 'Poppins',
//           ),
//         ),
//       );
// }

// class _Card extends StatelessWidget {
//   final List<Widget> children;
//   const _Card({required this.children});

//   @override
//   Widget build(BuildContext context) => Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black.withOpacity(0.04),
//                 blurRadius: 10,
//                 offset: const Offset(0, 2))
//           ],
//         ),
//         child: Column(children: children),
//       );
// }

// class _Div extends StatelessWidget {
//   @override
//   Widget build(BuildContext _) => const Divider(
//       height: 1, thickness: 0.5, indent: 60, color: Color(0xFFEEF2F0));
// }

// class _SwitchRow extends StatelessWidget {
//   final IconData icon;
//   final Color iconBg, iconColor;
//   final String title, subtitle;
//   final bool value;
//   final ValueChanged<bool> onChanged;

//   const _SwitchRow({
//     required this.icon,
//     required this.iconBg,
//     required this.iconColor,
//     required this.title,
//     required this.subtitle,
//     required this.value,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) => ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
//         leading: _IconBox(icon: icon, bg: iconBg, color: iconColor),
//         title: Text(title,
//             style: const TextStyle(
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//                 color: Color(0xFF1A2E2A))),
//         subtitle: Text(subtitle,
//             style: const TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 11.5,
//                 color: Color(0xFF6B8A82))),
//         trailing: Switch.adaptive(
//           value: value,
//           onChanged: onChanged,
//           activeColor: const Color(0xFF2E7D5E),
//           trackColor: WidgetStateProperty.resolveWith((s) =>
//               s.contains(WidgetState.selected)
//                   ? const Color(0xFF2E7D5E).withOpacity(0.28)
//                   : Colors.grey.shade200),
//         ),
//       );
// }

// class _TimeTapRow extends StatelessWidget {
//   final String title, time;
//   final VoidCallback onTap;
//   const _TimeTapRow(
//       {required this.title, required this.time, required this.onTap});

//   @override
//   Widget build(BuildContext context) => ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
//         leading: _IconBox(
//             icon: Icons.access_time_rounded,
//             bg: const Color(0xFFE8F5EF),
//             color: const Color(0xFF2E7D5E)),
//         title: Text(title,
//             style: const TextStyle(
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//                 color: Color(0xFF1A2E2A))),
//         trailing: GestureDetector(
//           onTap: onTap,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//             decoration: BoxDecoration(
//               color: const Color(0xFF2E7D5E).withOpacity(0.08),
//               borderRadius: BorderRadius.circular(8),
//               border:
//                   Border.all(color: const Color(0xFF2E7D5E).withOpacity(0.25)),
//             ),
//             child: Text(time,
//                 style: const TextStyle(
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w700,
//                     fontSize: 14,
//                     color: Color(0xFF2E7D5E))),
//           ),
//         ),
//       );
// }

// class _DropdownRow extends StatelessWidget {
//   final String title, value;
//   final List<String> items;
//   final ValueChanged<String?> onChanged;

//   const _DropdownRow({
//     required this.title,
//     required this.value,
//     required this.items,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) => ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
//         leading: _IconBox(
//             icon: Icons.calendar_month_rounded,
//             bg: const Color(0xFFE0F7F4),
//             color: const Color(0xFF00BFA5)),
//         title: Text(title,
//             style: const TextStyle(
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//                 color: Color(0xFF1A2E2A))),
//         trailing: DropdownButton<String>(
//           value: value,
//           underline: const SizedBox.shrink(),
//           borderRadius: BorderRadius.circular(12),
//           dropdownColor: Colors.white,
//           style: const TextStyle(
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w600,
//               fontSize: 14,
//               color: Color(0xFF2E7D5E)),
//           items: items
//               .map((d) => DropdownMenuItem(value: d, child: Text(d)))
//               .toList(),
//           onChanged: onChanged,
//         ),
//       );
// }

// class _EditableRow extends StatelessWidget {
//   final String title, value, hint;
//   final ValueChanged<String> onSaved;

//   const _EditableRow({
//     required this.title,
//     required this.value,
//     required this.hint,
//     required this.onSaved,
//   });

//   @override
//   Widget build(BuildContext context) => ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
//         leading: _IconBox(
//             icon: Icons.edit_rounded,
//             bg: const Color(0xFFEEECFD),
//             color: const Color(0xFF6C63FF)),
//         title: Text(title,
//             style: const TextStyle(
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//                 color: Color(0xFF1A2E2A))),
//         subtitle: Text(value,
//             style: const TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 11.5,
//                 color: Color(0xFF6B8A82)),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis),
//         trailing: IconButton(
//           icon:
//               const Icon(Icons.chevron_right_rounded, color: Color(0xFF9EB4AC)),
//           onPressed: () => _openDialog(context),
//         ),
//         onTap: () => _openDialog(context),
//       );

//   void _openDialog(BuildContext ctx) {
//     final ctrl = TextEditingController(text: value);
//     showDialog(
//       context: ctx,
//       builder: (d) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Text(title,
//             style: const TextStyle(
//                 fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
//         content: TextField(
//           controller: ctrl,
//           maxLines: 3,
//           maxLength: 120,
//           autofocus: true,
//           decoration: InputDecoration(
//             hintText: hint,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide:
//                   const BorderSide(color: Color(0xFF2E7D5E), width: 1.5),
//             ),
//           ),
//           style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(d),
//             child: const Text('বাতিল',
//                 style:
//                     TextStyle(fontFamily: 'Poppins', color: Color(0xFF6B8A82))),
//           ),
//           TextButton(
//             onPressed: () {
//               final v = ctrl.text.trim();
//               if (v.isNotEmpty) onSaved(v);
//               Navigator.pop(d);
//             },
//             child: const Text('সংরক্ষণ',
//                 style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF2E7D5E))),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _InfoRow extends StatelessWidget {
//   final IconData icon;
//   final Color iconColor;
//   final String title, value;
//   final Color valueColor;

//   const _InfoRow({
//     required this.icon,
//     required this.iconColor,
//     required this.title,
//     required this.value,
//     required this.valueColor,
//   });

//   @override
//   Widget build(BuildContext context) => ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
//         leading: _IconBox(
//             icon: icon, bg: iconColor.withOpacity(0.1), color: iconColor),
//         title: Text(title,
//             style: const TextStyle(
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//                 color: Color(0xFF1A2E2A))),
//         trailing: Text(value,
//             style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w700,
//                 fontSize: 14,
//                 color: valueColor)),
//       );
// }

// class _IconBox extends StatelessWidget {
//   final IconData icon;
//   final Color bg, color;
//   const _IconBox({required this.icon, required this.bg, required this.color});

//   @override
//   Widget build(BuildContext context) => Container(
//         width: 36,
//         height: 36,
//         decoration:
//             BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
//         child: Icon(icon, color: color, size: 18),
//       );
// }

// // ─── Active schedule summary card ─────────────────────────────
// class _ActiveSchedulePreview extends StatelessWidget {
//   final NotificationSettings s;
//   final String Function(TimeOfDay) fmt;
//   final List<String> weekdaysShort;

//   const _ActiveSchedulePreview({
//     required this.s,
//     required this.fmt,
//     required this.weekdaysShort,
//   });

//   @override
//   Widget build(BuildContext context) => Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF2E7D5E), Color(0xFF1A5242)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(children: [
//               Icon(Icons.schedule_rounded, color: Colors.white60, size: 14),
//               SizedBox(width: 5),
//               Text('সক্রিয় সময়সূচী',
//                   style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 11,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white60,
//                       letterSpacing: 0.5)),
//             ]),
//             const SizedBox(height: 12),
//             _SchedRow(
//               icon: Icons.auto_awesome_rounded,
//               label: 'দৈনিক আমল',
//               pill: s.dailyReminderEnabled ? fmt(s.dailyReminderTime) : 'বন্ধ',
//               on: s.dailyReminderEnabled,
//             ),
//             const SizedBox(height: 7),
//             _SchedRow(
//               icon: Icons.local_fire_department_rounded,
//               label: 'স্ট্রিক অ্যালার্ট',
//               pill: s.streakAlertEnabled ? fmt(s.streakAlertTime) : 'বন্ধ',
//               on: s.streakAlertEnabled,
//             ),
//             const SizedBox(height: 7),
//             _SchedRow(
//               icon: Icons.bar_chart_rounded,
//               label: 'সাপ্তাহিক রিভিউ',
//               pill: s.weeklyReviewEnabled
//                   ? '${weekdaysShort[s.weeklyReviewWeekday - 1]} · ${fmt(s.weeklyReviewTime)}'
//                   : 'বন্ধ',
//               on: s.weeklyReviewEnabled,
//             ),
//           ],
//         ),
//       );
// }

// class _SchedRow extends StatelessWidget {
//   final IconData icon;
//   final String label, pill;
//   final bool on;
//   const _SchedRow(
//       {required this.icon,
//       required this.label,
//       required this.pill,
//       required this.on});

//   @override
//   Widget build(BuildContext context) => Row(children: [
//         Icon(icon, color: Colors.white60, size: 13),
//         const SizedBox(width: 6),
//         Text(label,
//             style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 12.5,
//                 color: Colors.white.withOpacity(0.82))),
//         const Spacer(),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//           decoration: BoxDecoration(
//             color: on
//                 ? Colors.white.withOpacity(0.2)
//                 : Colors.white.withOpacity(0.07),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Text(pill,
//               style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w600,
//                   fontSize: 11.5,
//                   color: on ? Colors.white : Colors.white38)),
//         ),
//       ]);
// }
// ============================================================
// notification_settings_page.dart  — Bangla + Riverpod
// ============================================================

import 'package:amal_tracker/features/notification/model/notification_setting_model.dart';
import 'package:amal_tracker/features/notification/provider/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  ConsumerState<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState
    extends ConsumerState<NotificationSettingsPage> {
  // Working draft — uncommitted until Save pressed
  NotificationSettings? _draft;
  bool _isSaving = false;

  NotificationSettings get _current =>
      _draft ??
      ref.read(notificationSettingsProvider).valueOrNull ??
      const NotificationSettings();

  void _patch(NotificationSettings updated) => setState(() => _draft = updated);

  // ── Save ────────────────────────────────────────────────
  Future<void> _save() async {
    if (_draft == null) return;
    setState(() => _isSaving = true);
    await ref
        .read(notificationSettingsProvider.notifier)
        .updateSettings(_draft!);
    setState(() {
      _isSaving = false;
      _draft = null;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('সেটিংস সংরক্ষিত হয়েছে',
                style: TextStyle(fontFamily: 'Poppins')),
          ]),
          backgroundColor: const Color(0xFF2E7D5E),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // ── Time Picker ─────────────────────────────────────────
  Future<TimeOfDay?> _pickTime(TimeOfDay initial) => showTimePicker(
        context: context,
        initialTime: initial,
        builder: (ctx, child) => Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D5E),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        ),
      );

  String _fmt(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final p = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $p';
  }

  static const List<String> _weekdays = [
    'সোমবার',
    'মঙ্গলবার',
    'বুধবার',
    'বৃহস্পতিবার',
    'শুক্রবার',
    'শনিবার',
    'রবিবার',
  ];
  static const List<String> _weekdaysShort = [
    'সোম',
    'মঙ্গল',
    'বুধ',
    'বৃহ',
    'শুক্র',
    'শনি',
    'রবি',
  ];

  // ── Build ───────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(notificationSettingsProvider);
    final permAsync = ref.watch(notificationPermissionProvider);

    return settingsAsync.when(
      loading: () => const Scaffold(
        body:
            Center(child: CircularProgressIndicator(color: Color(0xFF2E7D5E))),
      ),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (_) {
        final s = _current;
        final hasPermission = permAsync.valueOrNull ?? false;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F9F8),
          appBar: _buildAppBar(),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: [
              // Permission banner
              if (!hasPermission)
                _PermissionBanner(
                  onAllow: () async {
                    await ref
                        .read(notificationPermissionProvider.notifier)
                        .requestPermission();
                  },
                ),

              // ── পুশ নোটিফিকেশন ─────────────────────
              _SectionLabel('📣  অ্যাপ নোটিফিকেশন', const Color(0xFF2196F3)),
              _Card(children: [
                _SwitchRow(
                  icon: Icons.notifications_rounded,
                  iconBg: const Color(0xFFE3F2FD),
                  iconColor: const Color(0xFF2196F3),
                  title: 'পুশ নোটিফিকেশন',
                  subtitle: 'অ্যাপের আপডেট ও ঘোষণা',
                  value: s.pushNotificationsEnabled,
                  onChanged: (v) =>
                      _patch(s.copyWith(pushNotificationsEnabled: v)),
                ),
                _Div(),
                _SwitchRow(
                  icon: Icons.volume_up_rounded,
                  iconBg: const Color(0xFFE8F5EF),
                  iconColor: const Color(0xFF2E7D5E),
                  title: 'সাউন্ড',
                  subtitle: 'নোটিফিকেশনে শব্দ চালু রাখুন',
                  value: s.soundEnabled,
                  onChanged: (v) => _patch(s.copyWith(soundEnabled: v)),
                ),
                _Div(),
                _SwitchRow(
                  icon: Icons.vibration_rounded,
                  iconBg: const Color(0xFFE8F5EF),
                  iconColor: const Color(0xFF2E7D5E),
                  title: 'ভাইব্রেশন',
                  subtitle: 'নোটিফিকেশনে কম্পন চালু রাখুন',
                  value: s.vibrationEnabled,
                  onChanged: (v) => _patch(s.copyWith(vibrationEnabled: v)),
                ),
              ]),

              const SizedBox(height: 4),

              // ── দৈনিক আমল রিমাইন্ডার ─────────────
              _SectionLabel('✨  দৈনিক আমল রিমাইন্ডার', const Color(0xFF6C63FF)),
              _Card(children: [
                _SwitchRow(
                  icon: Icons.auto_awesome_rounded,
                  iconBg: const Color(0xFFEEECFD),
                  iconColor: const Color(0xFF6C63FF),
                  title: 'রিমাইন্ডার চালু',
                  subtitle: 'প্রতিদিন আমল লগ করার স্মরণ',
                  value: s.dailyReminderEnabled,
                  onChanged: (v) => _patch(s.copyWith(dailyReminderEnabled: v)),
                ),
                if (s.dailyReminderEnabled) ...[
                  _Div(),
                  _TimeTapRow(
                    title: 'রিমাইন্ডারের সময়',
                    time: _fmt(s.dailyReminderTime),
                    onTap: () async {
                      final t = await _pickTime(s.dailyReminderTime);
                      if (t != null) _patch(s.copyWith(dailyReminderTime: t));
                    },
                  ),
                  _Div(),
                  _EditableRow(
                    title: 'বার্তা কাস্টমাইজ',
                    value: s.dailyReminderMessage,
                    hint: 'আমল লগ করার বার্তা লিখুন...',
                    onSaved: (v) => _patch(s.copyWith(dailyReminderMessage: v)),
                  ),
                ],
              ]),

              const SizedBox(height: 4),

              // ── স্ট্রিক অ্যালার্ট ─────────────────
              _SectionLabel('🔥  স্ট্রিক অ্যালার্ট', const Color(0xFFFF6B35)),
              _Card(children: [
                _SwitchRow(
                  icon: Icons.local_fire_department_rounded,
                  iconBg: const Color(0xFFFFF0EB),
                  iconColor: const Color(0xFFFF6B35),
                  title: 'স্ট্রিক অ্যালার্ট চালু',
                  subtitle: 'দিন শেষের আগে সতর্ক করবে',
                  value: s.streakAlertEnabled,
                  onChanged: (v) => _patch(s.copyWith(streakAlertEnabled: v)),
                ),
                if (s.streakAlertEnabled) ...[
                  _Div(),
                  _TimeTapRow(
                    title: 'অ্যালার্টের সময়',
                    time: _fmt(s.streakAlertTime),
                    onTap: () async {
                      final t = await _pickTime(s.streakAlertTime);
                      if (t != null) _patch(s.copyWith(streakAlertTime: t));
                    },
                  ),
                  _Div(),
                  _InfoRow(
                    icon: Icons.local_fire_department_rounded,
                    iconColor: const Color(0xFFFF6B35),
                    title: 'বর্তমান স্ট্রিক',
                    value: '${s.currentStreak} দিন',
                    valueColor: const Color(0xFFFF6B35),
                  ),
                ],
              ]),

              const SizedBox(height: 4),

              // ── সাপ্তাহিক রিভিউ ───────────────────
              _SectionLabel('📊  সাপ্তাহিক রিভিউ', const Color(0xFF00BFA5)),
              _Card(children: [
                _SwitchRow(
                  icon: Icons.bar_chart_rounded,
                  iconBg: const Color(0xFFE0F7F4),
                  iconColor: const Color(0xFF00BFA5),
                  title: 'সাপ্তাহিক রিভিউ চালু',
                  subtitle: 'সাপ্তাহিক আমলের সারসংক্ষেপ',
                  value: s.weeklyReviewEnabled,
                  onChanged: (v) => _patch(s.copyWith(weeklyReviewEnabled: v)),
                ),
                if (s.weeklyReviewEnabled) ...[
                  _Div(),
                  _DropdownRow(
                    title: 'রিভিউর দিন',
                    value: _weekdays[s.weeklyReviewWeekday - 1],
                    items: _weekdays,
                    onChanged: (v) {
                      if (v == null) return;
                      _patch(s.copyWith(
                          weeklyReviewWeekday: _weekdays.indexOf(v) + 1));
                    },
                  ),
                  _Div(),
                  _TimeTapRow(
                    title: 'রিভিউর সময়',
                    time: _fmt(s.weeklyReviewTime),
                    onTap: () async {
                      final t = await _pickTime(s.weeklyReviewTime);
                      if (t != null) _patch(s.copyWith(weeklyReviewTime: t));
                    },
                  ),
                ],
              ]),

              const SizedBox(height: 20),

              // ── সক্রিয় সময়সূচী প্রিভিউ ──────────
              _ActiveSchedulePreview(
                  s: s, fmt: _fmt, weekdaysShort: _weekdaysShort),
            ],
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() => AppBar(
        title: const Text('নোটিফিকেশন সেটিংস',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 17,
              color: Color(0xFF1A2E2A),
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: const BackButton(color: Color(0xFF2E7D5E)),
        actions: [
          if (_draft != null)
            _isSaving
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Color(0xFF2E7D5E)),
                    ),
                  )
                : TextButton(
                    onPressed: _save,
                    child: const Text('সংরক্ষণ',
                        style: TextStyle(
                          color: Color(0xFF2E7D5E),
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        )),
                  ),
        ],
      );
}

// ─── Shared small widgets ─────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _SectionLabel(this.text, this.color);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 4, top: 10, bottom: 6),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.4,
            fontFamily: 'Poppins',
          ),
        ),
      );
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(children: children),
      );
}

class _Div extends StatelessWidget {
  @override
  Widget build(BuildContext _) => const Divider(
      height: 1, thickness: 0.5, indent: 60, color: Color(0xFFEEF2F0));
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: _IconBox(icon: icon, bg: iconBg, color: iconColor),
        title: Text(title,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF1A2E2A))),
        subtitle: Text(subtitle,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11.5,
                color: Color(0xFF6B8A82))),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF2E7D5E),
          trackColor: WidgetStateProperty.resolveWith((s) =>
              s.contains(WidgetState.selected)
                  ? const Color(0xFF2E7D5E).withOpacity(0.28)
                  : Colors.grey.shade200),
        ),
      );
}

class _TimeTapRow extends StatelessWidget {
  final String title, time;
  final VoidCallback onTap;
  const _TimeTapRow(
      {required this.title, required this.time, required this.onTap});

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: _IconBox(
            icon: Icons.access_time_rounded,
            bg: const Color(0xFFE8F5EF),
            color: const Color(0xFF2E7D5E)),
        title: Text(title,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF1A2E2A))),
        trailing: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D5E).withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: const Color(0xFF2E7D5E).withOpacity(0.25)),
            ),
            child: Text(time,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF2E7D5E))),
          ),
        ),
      );
}

class _DropdownRow extends StatelessWidget {
  final String title, value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownRow({
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: _IconBox(
            icon: Icons.calendar_month_rounded,
            bg: const Color(0xFFE0F7F4),
            color: const Color(0xFF00BFA5)),
        title: Text(title,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF1A2E2A))),
        trailing: DropdownButton<String>(
          value: value,
          underline: const SizedBox.shrink(),
          borderRadius: BorderRadius.circular(12),
          dropdownColor: Colors.white,
          style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF2E7D5E)),
          items: items
              .map((d) => DropdownMenuItem(value: d, child: Text(d)))
              .toList(),
          onChanged: onChanged,
        ),
      );
}

class _EditableRow extends StatelessWidget {
  final String title, value, hint;
  final ValueChanged<String> onSaved;

  const _EditableRow({
    required this.title,
    required this.value,
    required this.hint,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: _IconBox(
            icon: Icons.edit_rounded,
            bg: const Color(0xFFEEECFD),
            color: const Color(0xFF6C63FF)),
        title: Text(title,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF1A2E2A))),
        subtitle: Text(value,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11.5,
                color: Color(0xFF6B8A82)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          icon:
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF9EB4AC)),
          onPressed: () => _openDialog(context),
        ),
        onTap: () => _openDialog(context),
      );

  void _openDialog(BuildContext ctx) {
    final ctrl = TextEditingController(text: value);
    showDialog(
      context: ctx,
      builder: (d) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title,
            style: const TextStyle(
                fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
        content: TextField(
          controller: ctrl,
          maxLines: 3,
          maxLength: 120,
          autofocus: true,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF2E7D5E), width: 1.5),
            ),
          ),
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d),
            child: const Text('বাতিল',
                style:
                    TextStyle(fontFamily: 'Poppins', color: Color(0xFF6B8A82))),
          ),
          TextButton(
            onPressed: () {
              final v = ctrl.text.trim();
              if (v.isNotEmpty) onSaved(v);
              Navigator.pop(d);
            },
            child: const Text('সংরক্ষণ',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E7D5E))),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title, value;
  final Color valueColor;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: _IconBox(
            icon: icon, bg: iconColor.withOpacity(0.1), color: iconColor),
        title: Text(title,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF1A2E2A))),
        trailing: Text(value,
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: valueColor)),
      );
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color bg, color;
  const _IconBox({required this.icon, required this.bg, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: 36,
        height: 36,
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 18),
      );
}

// ─── Active schedule summary card ─────────────────────────────
class _ActiveSchedulePreview extends StatelessWidget {
  final NotificationSettings s;
  final String Function(TimeOfDay) fmt;
  final List<String> weekdaysShort;

  const _ActiveSchedulePreview({
    required this.s,
    required this.fmt,
    required this.weekdaysShort,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2E7D5E), Color(0xFF1A5242)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(children: [
              Icon(Icons.schedule_rounded, color: Colors.white60, size: 14),
              SizedBox(width: 5),
              Text('সক্রিয় সময়সূচী',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white60,
                      letterSpacing: 0.5)),
            ]),
            const SizedBox(height: 12),
            _SchedRow(
              icon: Icons.auto_awesome_rounded,
              label: 'দৈনিক আমল',
              pill: s.dailyReminderEnabled ? fmt(s.dailyReminderTime) : 'বন্ধ',
              on: s.dailyReminderEnabled,
            ),
            const SizedBox(height: 7),
            _SchedRow(
              icon: Icons.local_fire_department_rounded,
              label: 'স্ট্রিক অ্যালার্ট',
              pill: s.streakAlertEnabled ? fmt(s.streakAlertTime) : 'বন্ধ',
              on: s.streakAlertEnabled,
            ),
            const SizedBox(height: 7),
            _SchedRow(
              icon: Icons.bar_chart_rounded,
              label: 'সাপ্তাহিক রিভিউ',
              pill: s.weeklyReviewEnabled
                  ? '${weekdaysShort[s.weeklyReviewWeekday - 1]} · ${fmt(s.weeklyReviewTime)}'
                  : 'বন্ধ',
              on: s.weeklyReviewEnabled,
            ),
          ],
        ),
      );
}

class _SchedRow extends StatelessWidget {
  final IconData icon;
  final String label, pill;
  final bool on;
  const _SchedRow(
      {required this.icon,
      required this.label,
      required this.pill,
      required this.on});

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, color: Colors.white60, size: 13),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.5,
                color: Colors.white.withOpacity(0.82))),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: on
                ? Colors.white.withOpacity(0.2)
                : Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(pill,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 11.5,
                  color: on ? Colors.white : Colors.white38)),
        ),
      ]);
}

// ─── Permission Banner ────────────────────────────────────────
class _PermissionBanner extends StatelessWidget {
  final VoidCallback onAllow;
  const _PermissionBanner({required this.onAllow});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFCC02).withOpacity(0.4)),
      ),
      child: Row(children: [
        const Icon(Icons.notifications_off_rounded,
            color: Color(0xFFE65100), size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'নোটিফিকেশন বন্ধ আছে',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0xFFE65100)),
              ),
              const Text(
                'আমল রিমাইন্ডার পেতে অনুমতি দিন।',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Color(0xFF795548)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: onAllow,
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFE65100),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('অনুমতি দিন',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 12)),
        ),
      ]),
    );
  }
}
