// import 'package:amal_tracker/features/auth/providers/provider_reset.dart';
// import 'package:amal_tracker/features/auth/providers/auth_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/tracker_provider.dart';
// import '../models/tracker_model.dart';
// import '../../../core/constants/app_constants.dart';

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
//   static const amber = Color(0xFFFF6B35);
//   static const amberLight = Color(0xFFFFF3E0);
//   static const red = Color(0xFFEF4444);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
//   static const border = Color(0xFFE4EAE4);
//   static const borderMid = Color(0xFFD0DAD2);
//   static const success = Color(0xFF16A34A);
//   static const maafBg = Color(0xFFE8F5EE);
//   static const maafText = Color(0xFF1B7045);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // HELPERS
// // ─────────────────────────────────────────────────────────────────────────────

// String _unitLabelBn(String? unit) {
//   switch (unit) {
//     case 'ayah':
//       return 'আয়াত';
//     case 'day':
//       return 'দিন';
//     case 'person':
//       return 'জন';
//     case 'minute':
//       return 'মিনিট';
//     case 'time':
//       return 'বার';
//     case 'rakaat':
//       return 'রাকাত';
//     default:
//       return unit ?? 'টি';
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // CARD TYPE RESOLVER
// //
// // This is the single source of truth for what card to show.
// // Uses isFard + inputType (both exist reliably in the model).
// //
// // Rules:
// //   isPrayer + isFard == true          → FardPrayerCard (congregation/solo/missed)
// //   isPrayer + isFard == false
// //     + inputType == counter           → RakaatCounterCard (witr/tahajjud/ishraq/duha)
// //     + inputType == binary            → SunnahToggleCard (fajr_sunnah / sunnah_muakkadah / juma / travel)
// //   !isPrayer + inputType == counter   → GenericCounterCard (quran/dhikr)
// //   !isPrayer + inputType == binary    → GenericToggleCard
// // ─────────────────────────────────────────────────────────────────────────────

// enum _CardType {
//   fardPrayer, // جماعة / فردى / مفقود
//   rakaatCounter, // witr (odd) / nafl (even)
//   sunnahToggle, // fixed sunnah binary
//   genericCounter, // quran ayah / dhikr count
//   genericToggle, // all other binary
// }

// _CardType _resolveCardType(AmalCategory cat) {
//   if (cat.isPrayer) {
//     if (cat.isFard) return _CardType.fardPrayer;
//     if (cat.inputType == AmalInputType.counter) return _CardType.rakaatCounter;
//     return _CardType.sunnahToggle;
//   }
//   if (cat.inputType == AmalInputType.counter) return _CardType.genericCounter;
//   return _CardType.genericToggle;
// }

// // Witr uses odd steps (1,3,5,7,9); other rakaat use even steps (2,4,6,8…)
// bool _isWitr(AmalCategory cat) => cat.key == 'witr';

// int _rakaatStep(AmalCategory cat) => 2; // both witr and nafl increment by 2

// int _rakaatMin(AmalCategory cat) =>
//     (cat.minValue ?? (_isWitr(cat) ? 1 : 2)).toInt();

// // ─────────────────────────────────────────────────────────────────────────────
// // SHEET ROOT
// // ─────────────────────────────────────────────────────────────────────────────

// class DailyEntrySheet extends ConsumerStatefulWidget {
//   final String dateStr;
//   final Map<String, List<AmalCategory>> catsBySection;
//   final DailyEntryState existingState;
//   final bool isNew;

//   const DailyEntrySheet({
//     super.key,
//     required this.dateStr,
//     required this.catsBySection,
//     required this.existingState,
//     required this.isNew,
//   });

//   @override
//   ConsumerState<DailyEntrySheet> createState() => _DailyEntrySheetState();
// }

// class _DailyEntrySheetState extends ConsumerState<DailyEntrySheet> {
//   late Map<String, _LocalItem> _items;
//   bool _saving = false;
//   int _activeSection = 0;
//   bool _isExemptDay = false;
//   bool _isFemale = false;

//   late DateTime _selectedDate; // ← late field, initState এ set হবে

//   // ── Active sections — getter, widget access safe ──────────────────────────
//   List<String> get _activeSections => AppConstants.sections
//       .map((s) => s.key)
//       .where((k) => (widget.catsBySection[k] ?? []).isNotEmpty)
//       .toList();

//   // ── Section icon — helper method ──────────────────────────────────────────
//   IconData _sectionIcon(String key) => AppConstants.sections
//       .firstWhere(
//         (s) => s.key == key,
//         orElse: () =>
//             SectionMeta(key: key, labelBn: key, labelEn: key, iconKey: ''),
//       )
//       .icon;

//   // static const _sectionOrder = [
//   //   'salat',
//   //   'sunnah_nafl',
//   //   'dhikr_tilawat',
//   //   'daily_habits',
//   //   'weekly',
//   //   'special_dhulhijja',
//   //   'social',
//   // ];

//   // static const _sectionIcons = <String, IconData>{
//   //   'salat': Icons.mosque_rounded,
//   //   'sunnah_nafl': Icons.auto_awesome_rounded,
//   //   'dhikr_tilawat': Icons.menu_book_rounded,
//   //   'daily_habits': Icons.self_improvement_rounded,
//   //   'weekly': Icons.date_range_rounded,
//   //   'special_dhulhijja': Icons.star_rounded,
//   //   'social': Icons.people_rounded,
//   // };

//   // List<String> get _activeSections => _sectionOrder
//   //     .where((s) => (widget.catsBySection[s] ?? []).isNotEmpty)
//   //     .toList();

// // // _SectionForm itemBuilder-এ applicable day dim যোগ করো
// //   final selectedDate = DateTime.tryParse(widget.dateStr
// //           .replaceFirst(RegExp(r'(\d{4})-(\d{2})-(\d{2})'), r'$1$2$3')) ??
// //       DateTime.now();

//   @override
//   void initState() {
//     super.initState();
//     final user = ref.read(currentUserProvider);
//     _isFemale = (user?.gender?.toLowerCase() == 'female');
//     _isExemptDay = widget.existingState.entry?.isExemptDay ?? false;

//     // dateStr থেকে DateTime parse — একবার করে রাখো
//     final parts = widget.dateStr.split('-');
//     _selectedDate = DateTime(
//       int.parse(parts[0]),
//       int.parse(parts[1]),
//       int.parse(parts[2]),
//     );

//     _buildItems();
//   }

//   void _buildItems() {
//     _items = {};
//     final existing = widget.existingState.effectiveEntries;
//     for (final cats in widget.catsBySection.values) {
//       for (final cat in cats) {
//         final prev = existing[cat.id];
//         final exempted = _isFemale && _isExemptDay && cat.isExemptDuringPeriod;
//         _items[cat.id] = _LocalItem(
//           cat: cat,
//           completed: exempted ? false : (prev?.completed ?? false),
//           prayerMode: exempted ? PrayerMode.missed : prev?.prayerMode,
//           count: exempted ? 0 : (prev?.count ?? 0),
//           isExempted: exempted,
//         );
//       }
//     }
//   }

//   // ── exempt day ─────────────────────────────────────────────────────────────

//   void _toggleExemptDay(bool val) {
//     setState(() {
//       _isExemptDay = val;
//       for (final item in _items.values) {
//         if (!item.cat.isExemptDuringPeriod) continue;
//         item.isExempted = val;
//         if (val) {
//           item.completed = false;
//           item.prayerMode = PrayerMode.missed;
//           item.count = 0;
//         }
//       }
//     });
//     HapticFeedback.mediumImpact();
//   }

//   // ── callbacks ──────────────────────────────────────────────────────────────

//   void _toggleBinary(String id, bool value) {
//     setState(() {
//       final item = _items[id]!;
//       if (item.isExempted) return;
//       item.completed = value;
//     });
//     HapticFeedback.selectionClick();
//   }

//   void _setPrayerMode(String id, PrayerMode mode) {
//     setState(() {
//       final item = _items[id]!;
//       if (item.isExempted) return;
//       item.prayerMode = mode;
//       item.completed = mode != PrayerMode.missed;
//     });
//     HapticFeedback.selectionClick();
//   }

//   /// rawCount is the desired new value (after +/- button press).
//   /// Snap logic applied here, not in the card.
//   void _setCount(String id, int rawCount) {
//     setState(() {
//       final item = _items[id]!;
//       if (item.isExempted) return;
//       final cat = item.cat;
//       final max = cat.maxValue?.toInt();

//       int value = rawCount;

//       // Rakaat snapping
//       if (cat.unit == 'rakaat' && value > 0) {
//         if (_isWitr(cat)) {
//           // Snap to odd: 1,3,5,7,9
//           if (value.isEven) value = value - 1;
//           value = value.clamp(1, max ?? 9);
//         } else {
//           // Snap to even: 2,4,6,8…
//           if (value.isOdd) value = value - 1;
//           final min = _rakaatMin(cat);
//           value = value.clamp(min, max ?? 9999);
//         }
//       }

//       item.count = max != null ? value.clamp(0, max) : value.clamp(0, 9999);
//       item.completed = item.count > 0;
//     });
//     HapticFeedback.lightImpact();
//   }

//   // ── totals ─────────────────────────────────────────────────────────────────

//   int get _totalPoints => _items.values.fold(0, (s, i) => s + i.points);

//   int get _completedCount =>
//       _items.values.where((i) => i.completed && !i.isExempted).length;

//   // ── save ───────────────────────────────────────────────────────────────────

//   Future<void> _save() async {
//     setState(() => _saving = true);

//     final updates = _items.values
//         .map((item) => EntryUpdate(
//               categoryId: item.cat.id,
//               completed: item.isExempted ? false : item.completed,
//               prayerMode: item.isExempted ? PrayerMode.missed : item.prayerMode,
//               count: item.isExempted ? 0 : item.count,
//             ))
//         .toList();

//     final ok = await ref
//         .read(dailyEntryProvider(widget.dateStr).notifier)
//         .saveEntryFromUpdates(updates, isExemptDay: _isExemptDay);

//     if (ok && mounted) {
//       final parts = widget.dateStr.split('-');
//       refreshAfterEntryUpdate(
//         ref,
//         year: int.parse(parts[0]),
//         month: int.parse(parts[1]),
//         specificDateStr: widget.dateStr,
//       );
//     }

//     setState(() => _saving = false);
//     if (!mounted) return;
//     Navigator.pop(context);

//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Row(children: [
//         Icon(ok ? Icons.check_circle_rounded : Icons.error_outline_rounded,
//             color: Colors.white),
//         const SizedBox(width: 10),
//         Text(ok
//             ? (widget.isNew
//                 ? 'আমল সফলভাবে সেভ হয়েছে! 🌟'
//                 : 'আমল আপডেট হয়েছে! ✨')
//             : 'সেভ করতে সমস্যা হয়েছে। আবার চেষ্টা করুন।'),
//       ]),
//       backgroundColor: ok ? _C.success : _C.red,
//       margin: const EdgeInsets.all(16),
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       duration: const Duration(seconds: 2),
//     ));
//   }

//   // ── build ──────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;
//     final sections = _activeSections;

//     return Container(
//       height: size.height * 0.96,
//       decoration: const BoxDecoration(
//         color: _C.pageBg,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//       ),
//       child: Column(children: [
//         _SheetHeader(
//           isNew: widget.isNew,
//           dateStr: widget.dateStr,
//           points: _totalPoints,
//           completed: _completedCount,
//           saving: _saving,
//           onClose: () => Navigator.pop(context),
//           onSave: _save,
//         ),
//         _SectionTabBar(
//           sections: sections,
//           sectionIcon: _sectionIcon,
//           activeIndex: _activeSection,
//           catsBySection: widget.catsBySection,
//           localItems: _items,
//           onTap: (i) => setState(() => _activeSection = i),
//         ),
//         Expanded(
//           child: AnimatedSwitcher(
//             duration: 220.ms,
//             transitionBuilder: (child, anim) => FadeTransition(
//               opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
//               child: child,
//             ),
//             child: _SectionForm(
//               key: ValueKey(_activeSection),
//               sectionKey: sections[_activeSection],
//               categories: widget.catsBySection[sections[_activeSection]] ?? [],
//               localItems: _items,
//               isTablet: isTablet,
//               isFemale: _isFemale,
//               isExemptDay: _isExemptDay,
//               onToggle: _toggleBinary,
//               onPrayerMode: _setPrayerMode,
//               selectedDate: _selectedDate,
//               onCount: _setCount,
//               onExemptToggle: _toggleExemptDay,
//             ),
//           ),
//         ),
//         _BottomSaveBar(
//           isNew: widget.isNew,
//           saving: _saving,
//           points: _totalPoints,
//           completed: _completedCount,
//           onSave: _save,
//           onCancel: () => Navigator.pop(context),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SHEET HEADER
// // ─────────────────────────────────────────────────────────────────────────────

// class _SheetHeader extends StatelessWidget {
//   final bool isNew, saving;
//   final String dateStr;
//   final int points, completed;
//   final VoidCallback onClose, onSave;

//   const _SheetHeader({
//     required this.isNew,
//     required this.saving,
//     required this.dateStr,
//     required this.points,
//     required this.completed,
//     required this.onClose,
//     required this.onSave,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final parts = dateStr.split('-');
//     final d = int.parse(parts[2]);
//     final m = int.parse(parts[1]);
//     final y = int.parse(parts[0]);
//     final month = AppConstants.bengaliMonths[m - 1];

//     return Container(
//       decoration: const BoxDecoration(
//         color: _C.darkGreen,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//       ),
//       child: Stack(children: [
//         Positioned(
//             top: -30,
//             right: -30,
//             child: Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white.withOpacity(0.04)))),
//         Positioned(
//             bottom: 0,
//             left: 10,
//             child: Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white.withOpacity(0.03)))),
//         Column(mainAxisSize: MainAxisSize.min, children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 12, bottom: 4),
//             child: Center(
//                 child: Container(
//                     width: 40,
//                     height: 4,
//                     decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.25),
//                         borderRadius: BorderRadius.circular(99)))),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
//             child: Row(children: [
//               Container(
//                 width: 38,
//                 height: 38,
//                 decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.12),
//                     borderRadius: BorderRadius.circular(11),
//                     border: Border.all(
//                         color: Colors.white.withOpacity(0.18), width: 0.5)),
//                 child: Icon(isNew ? Icons.add_rounded : Icons.edit_rounded,
//                     color: Colors.white, size: 18),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                     Text(isNew ? 'আমল যোগ করুন' : 'আমল সম্পাদনা করুন',
//                         style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w800,
//                             fontSize: 16,
//                             letterSpacing: -0.3)),
//                     Text('$d $month $y',
//                         style: TextStyle(
//                             color: Colors.white.withOpacity(0.5),
//                             fontSize: 11,
//                             fontWeight: FontWeight.w500)),
//                   ])),
//               GestureDetector(
//                 onTap: onClose,
//                 child: Container(
//                   width: 34,
//                   height: 34,
//                   decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                           color: Colors.white.withOpacity(0.15), width: 0.5)),
//                   child: Icon(Icons.close_rounded,
//                       color: Colors.white.withOpacity(0.7), size: 18),
//                 ),
//               ),
//             ]),
//           ),
//           const SizedBox(height: 12),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//             child: Container(
//               padding: const EdgeInsets.all(13),
//               decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.09),
//                   borderRadius: BorderRadius.circular(14),
//                   border: Border.all(
//                       color: Colors.white.withOpacity(0.18), width: 0.5)),
//               child: Row(children: [
//                 Container(
//                   width: 44,
//                   height: 44,
//                   decoration: BoxDecoration(
//                       color: _C.gold, borderRadius: BorderRadius.circular(12)),
//                   child: const Icon(Icons.stars_rounded,
//                       color: Colors.white, size: 24),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                       Text('লাইভ পয়েন্ট',
//                           style: TextStyle(
//                               color: Colors.white.withOpacity(0.5),
//                               fontSize: 10)),
//                       const SizedBox(height: 1),
//                       Row(children: [
//                         Text('$points',
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w900,
//                                 fontSize: 22,
//                                 letterSpacing: -0.4,
//                                 height: 1)),
//                         Text(' pts',
//                             style: TextStyle(
//                                 color: Colors.white.withOpacity(0.5),
//                                 fontSize: 12)),
//                       ]),
//                     ])),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                   decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.12),
//                       borderRadius: BorderRadius.circular(20)),
//                   child: Row(mainAxisSize: MainAxisSize.min, children: [
//                     Icon(Icons.check_circle_rounded,
//                         color: Colors.white.withOpacity(0.7), size: 12),
//                     const SizedBox(width: 4),
//                     Text('$completed টি সম্পন্ন',
//                         style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600)),
//                   ]),
//                 ),
//               ]),
//             ),
//           ),
//         ]),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION TAB BAR
// // ─────────────────────────────────────────────────────────────────────────────

// class _SectionTabBar extends StatelessWidget {
//   final List<String> sections;
//   final IconData Function(String) sectionIcon;
//   final int activeIndex;
//   final Map<String, List<AmalCategory>> catsBySection;
//   final Map<String, _LocalItem> localItems;
//   final ValueChanged<int> onTap;

//   const _SectionTabBar({
//     required this.sections,
//     required this.sectionIcon,
//     required this.activeIndex,
//     required this.catsBySection,
//     required this.localItems,
//     required this.onTap,
//   });

//   int _doneIn(String sec) {
//     return (catsBySection[sec] ?? [])
//         .where((c) =>
//             localItems[c.id]?.completed == true &&
//             localItems[c.id]?.isExempted == false)
//         .length;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: _C.cardBg,
//       child: Column(children: [
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
//           child: Row(
//             children: sections.asMap().entries.map((e) {
//               final i = e.key;
//               final sec = e.value;
//               final label = AppConstants.sectionLabels[sec]?['bn'] ?? sec;
//               final icon = sectionIcon(sec) ?? Icons.circle;
//               final done = _doneIn(sec);
//               final total = (catsBySection[sec] ?? []).length;
//               final active = i == activeIndex;
//               final allDone = done == total && total > 0;

//               return GestureDetector(
//                 onTap: () => onTap(i),
//                 child: AnimatedContainer(
//                   duration: 180.ms,
//                   margin: const EdgeInsets.only(right: 8),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: active ? _C.darkGreen : _C.pageBg,
//                     borderRadius: BorderRadius.circular(99),
//                     border: Border.all(
//                       color: active
//                           ? _C.darkGreen
//                           : allDone
//                               ? _C.green.withOpacity(0.4)
//                               : _C.border,
//                       width: 0.5,
//                     ),
//                   ),
//                   child: Row(mainAxisSize: MainAxisSize.min, children: [
//                     Icon(icon,
//                         size: 12,
//                         color: active
//                             ? Colors.white
//                             : allDone
//                                 ? _C.green
//                                 : _C.textSecondary),
//                     const SizedBox(width: 5),
//                     Text(label,
//                         style: TextStyle(
//                             fontSize: 11,
//                             fontWeight:
//                                 active ? FontWeight.w700 : FontWeight.w500,
//                             color: active
//                                 ? Colors.white
//                                 : allDone
//                                     ? _C.green
//                                     : _C.textSecondary)),
//                     if (done > 0) ...[
//                       const SizedBox(width: 6),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(
//                             color: active
//                                 ? Colors.white.withOpacity(0.2)
//                                 : allDone
//                                     ? _C.greenLight
//                                     : _C.pageBg,
//                             borderRadius: BorderRadius.circular(20)),
//                         child: Text('$done/$total',
//                             style: TextStyle(
//                                 fontSize: 9,
//                                 fontWeight: FontWeight.w700,
//                                 color: active
//                                     ? Colors.white
//                                     : allDone
//                                         ? _C.green
//                                         : _C.textHint)),
//                       ),
//                     ],
//                   ]),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//         const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // EXEMPT DAY BANNER  (female only, salat section)
// // ─────────────────────────────────────────────────────────────────────────────

// class _ExemptDayBanner extends StatelessWidget {
//   final bool isExemptDay;
//   final ValueChanged<bool> onToggle;
//   const _ExemptDayBanner({required this.isExemptDay, required this.onToggle});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => onToggle(!isExemptDay),
//       child: AnimatedContainer(
//         duration: 200.ms,
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         decoration: BoxDecoration(
//           color: isExemptDay
//               ? _C.midGreen.withOpacity(0.08)
//               : const Color(0xFFFFF8EE),
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: isExemptDay
//                 ? _C.midGreen.withOpacity(0.35)
//                 : _C.gold.withOpacity(0.5),
//             width: 1,
//           ),
//         ),
//         child: Row(children: [
//           AnimatedContainer(
//             duration: 200.ms,
//             width: 42,
//             height: 42,
//             decoration: BoxDecoration(
//               color: isExemptDay
//                   ? _C.midGreen.withOpacity(0.12)
//                   : _C.gold.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(11),
//             ),
//             child:
//                 const Center(child: Text('🌸', style: TextStyle(fontSize: 20))),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                 Text(
//                   isExemptDay ? 'আজ মাহলির দিন' : 'আজ কি মাহলি আছেন?',
//                   style: TextStyle(
//                       color: isExemptDay ? _C.darkGreen : _C.textPrimary,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 13),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   isExemptDay
//                       ? 'ফরজ আমলগুলো মাফ হিসেবে চিহ্নিত হয়েছে'
//                       : 'চালু করলে ফরজ আমলগুলো মাফ ধরা হবে',
//                   style: TextStyle(
//                       color: isExemptDay ? _C.midGreen : _C.textSecondary,
//                       fontSize: 11),
//                 ),
//               ])),
//           const SizedBox(width: 10),
//           _ToggleSwitch(
//               value: isExemptDay,
//               onChanged: onToggle,
//               activeColor: _C.midGreen),
//         ]),
//       ),
//     ).animate().fadeIn(duration: 220.ms).slideY(begin: -0.04);
//   }
// }

// class _ToggleSwitch extends StatelessWidget {
//   final bool value;
//   final ValueChanged<bool> onChanged;
//   final Color activeColor;
//   const _ToggleSwitch(
//       {required this.value,
//       required this.onChanged,
//       required this.activeColor});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => onChanged(!value),
//       child: AnimatedContainer(
//         duration: 200.ms,
//         curve: Curves.easeInOut,
//         width: 46,
//         height: 26,
//         padding: const EdgeInsets.all(3),
//         decoration: BoxDecoration(
//             color: value ? activeColor : _C.borderMid,
//             borderRadius: BorderRadius.circular(99)),
//         child: AnimatedAlign(
//           duration: 200.ms,
//           curve: Curves.easeInOut,
//           alignment: value ? Alignment.centerRight : Alignment.centerLeft,
//           child: Container(
//               width: 20,
//               height: 20,
//               decoration: const BoxDecoration(
//                   color: Colors.white, shape: BoxShape.circle)),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SECTION FORM  ← THE FIX IS HERE
// // ─────────────────────────────────────────────────────────────────────────────

// class _SectionForm extends StatelessWidget {
//   final String sectionKey;
//   final List<AmalCategory> categories;
//   final Map<String, _LocalItem> localItems;
//   final bool isTablet, isFemale, isExemptDay;
//   final void Function(String, bool) onToggle;
//   final void Function(String, PrayerMode) onPrayerMode;
//   final DateTime selectedDate;
//   final void Function(String, int) onCount;
//   final ValueChanged<bool> onExemptToggle;

//   const _SectionForm({
//     super.key,
//     required this.sectionKey,
//     required this.categories,
//     required this.localItems,
//     required this.isTablet,
//     required this.isFemale,
//     required this.isExemptDay,
//     required this.onToggle,
//     required this.onPrayerMode,
//     required this.selectedDate,
//     required this.onCount,
//     required this.onExemptToggle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (categories.isEmpty) {
//       return const Center(
//           child: Text('এই বিভাগে কোনো আমল নেই',
//               style: TextStyle(color: _C.textHint, fontSize: 13)));
//     }

//     final hPad =
//         isTablet ? (MediaQuery.of(context).size.width - 600) / 2 + 16.0 : 16.0;
//     final showBanner = isFemale && sectionKey == 'salat';
//     final itemCount = categories.length + (showBanner ? 1 : 0);

//     return ListView.separated(
//       padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 14),
//       itemCount: itemCount,
//       separatorBuilder: (_, __) => const SizedBox(height: 10),
//       itemBuilder: (ctx, i) {
//         // Banner is always first item in salat section for females
//         if (showBanner && i == 0) {
//           return _ExemptDayBanner(
//               isExemptDay: isExemptDay, onToggle: onExemptToggle);
//         }

//         final catIndex = showBanner ? i - 1 : i;
//         final cat = categories[catIndex];
//         final item = localItems[cat.id];
//         final isApplicable = cat.isApplicableOn(selectedDate);

//         // ── CARD ROUTING ─────────────────────────────────────────────────────
//         // _resolveCardType() uses isFard + inputType — both are reliable fields.
//         // congregationPoints is NOT used for routing because backend default: 2
//         // makes it unreliable (non-null even for non-congregation prayers).
//         // ─────────────────────────────────────────────────────────────────────

//         Widget card;

//         if (item?.isExempted == true) {
//           // Exempted items (female period day) — show muted "মাফ আছে" card
//           card = _ExemptedCard(cat: cat);
//         } else {
//           switch (_resolveCardType(cat)) {
//             case _CardType.fardPrayer:
//               // ফজর, যোহর, আসর, মাগরিব, এশা
//               // Shows: জামাতে (+8) / একাকী (+3) / মিস (+0)
//               card = _FardPrayerCard(
//                 cat: cat,
//                 item: item,
//                 onMode: (mode) => onPrayerMode(cat.id, mode),
//               );
//               break;

//             case _CardType.rakaatCounter:
//               // বিতর (বেজোড়: ১,৩,৫,৭,৯) — witr
//               // তাহাজ্জুদ, ইশরাক, চাশত (জোড়: ২,৪,৬,৮…)
//               // Shows: counter with step-2 +/- buttons
//               card = _RakaatCounterCard(
//                 cat: cat,
//                 item: item,
//                 onCount: (c) => onCount(cat.id, c),
//               );
//               break;

//             case _CardType.sunnahToggle:
//               // ফজরের সুন্নত, সুন্নতে মুয়াক্কাদাহ, জুমুআ, সফরের নামাজ
//               // Shows: simple done/not-done toggle (no congregation option)
//               card = _SunnahToggleCard(
//                 cat: cat,
//                 item: item,
//                 onToggle: (v) => onToggle(cat.id, v),
//               );
//               break;

//             case _CardType.genericCounter:
//               // কুরআন তিলাওয়াত, হিফজ, দরুদ, জিলহজের রোজা
//               card = _GenericCounterCard(
//                 cat: cat,
//                 item: item,
//                 onCount: (c) => onCount(cat.id, c),
//               );
//               break;

//             case _CardType.genericToggle:
//               // All other binary amals
//               card = _GenericToggleCard(
//                 cat: cat,
//                 item: item,
//                 onToggle: (v) => onToggle(cat.id, v),
//               );
//               break;
//           }
//         }

//         // applicable না হলে dim করো
//         if (!isApplicable) {
//           card = Stack(
//             children: [
//               Opacity(opacity: 0.45, child: card),
//               Positioned(
//                 top: 10,
//                 right: 10,
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF1F0EB),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: _C.border, width: 0.5),
//                   ),
//                   child: const Text(
//                     'আজ প্রযোজ্য নয়',
//                     style: TextStyle(
//                       fontSize: 9.5,
//                       color: _C.textHint,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         }

//         return card
//             .animate(delay: (catIndex * 35).ms)
//             .fadeIn(duration: 240.ms)
//             .slideX(begin: 0.05, curve: Curves.easeOut);
//       },
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // CARD 1 — EXEMPTED  (female period day)
// // ─────────────────────────────────────────────────────────────────────────────

// class _ExemptedCard extends StatelessWidget {
//   final AmalCategory cat;
//   const _ExemptedCard({required this.cat});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           color: _C.pageBg,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: _C.border, width: 0.5)),
//       child: Opacity(
//         opacity: 0.55,
//         child: Padding(
//           padding: const EdgeInsets.all(14),
//           child: Row(children: [
//             Container(
//               width: 38,
//               height: 38,
//               decoration: BoxDecoration(
//                   color: _C.pageBg,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: _C.border, width: 0.5)),
//               child: const Icon(Icons.mosque_rounded,
//                   color: _C.textHint, size: 18),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                   Text(cat.nameBn,
//                       style: const TextStyle(
//                           color: _C.textHint,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 13,
//                           decoration: TextDecoration.lineThrough,
//                           decorationColor: _C.textHint)),
//                   Text(cat.nameEn,
//                       style: const TextStyle(color: _C.textHint, fontSize: 11)),
//                 ])),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               decoration: BoxDecoration(
//                   color: _C.maafBg,
//                   borderRadius: BorderRadius.circular(20),
//                   border:
//                       Border.all(color: _C.green.withOpacity(0.3), width: 0.5)),
//               child: const Text('মাফ আছে',
//                   style: TextStyle(
//                       fontSize: 10.5,
//                       fontWeight: FontWeight.w700,
//                       color: _C.maafText)),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // CARD 2 — FARD PRAYER  (congregation / solo / missed)
// // ─────────────────────────────────────────────────────────────────────────────

// class _FardPrayerCard extends StatelessWidget {
//   final AmalCategory cat;
//   final _LocalItem? item;
//   final ValueChanged<PrayerMode> onMode;
//   const _FardPrayerCard(
//       {required this.cat, required this.item, required this.onMode});

//   @override
//   Widget build(BuildContext context) {
//     final mode = item?.prayerMode ?? PrayerMode.missed;
//     final pts = item?.points ?? 0;

//     final borderColor = mode == PrayerMode.congregation
//         ? _C.green.withOpacity(0.5)
//         : mode == PrayerMode.solo
//             ? _C.amber.withOpacity(0.5)
//             : _C.border;

//     return Container(
//       decoration: BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: borderColor, width: 1)),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(14, 13, 14, 11),
//           child: Row(children: [
//             _IconBadge(
//                 icon: Icons.mosque_rounded,
//                 active: mode != PrayerMode.missed,
//                 color: _C.green),
//             const SizedBox(width: 12),
//             Expanded(
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                   Text(cat.nameBn,
//                       style: const TextStyle(
//                           color: _C.textPrimary,
//                           fontWeight: FontWeight.w700,
//                           fontSize: 13)),
//                   Text(cat.nameEn,
//                       style: const TextStyle(
//                           color: _C.textSecondary, fontSize: 11)),
//                 ])),
//             _PtsTag(pts: pts, maxPts: cat.congregationPoints, active: pts > 0),
//           ]),
//         ),
//         const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//         const SizedBox(height: 10),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
//           child: Row(children: [
//             Expanded(
//                 child: _ModeBtn(
//                     label: 'জামাতে',
//                     subLabel: '+${cat.congregationPoints}',
//                     emoji: '✔',
//                     isSelected: mode == PrayerMode.congregation,
//                     activeColor: _C.green,
//                     activeBg: _C.greenLight,
//                     onTap: () => onMode(PrayerMode.congregation))),
//             const SizedBox(width: 8),
//             Expanded(
//                 child: _ModeBtn(
//                     label: 'একাকী',
//                     subLabel: '+${cat.basePoints}',
//                     emoji: '/',
//                     isSelected: mode == PrayerMode.solo,
//                     activeColor: _C.amber,
//                     activeBg: _C.amberLight,
//                     onTap: () => onMode(PrayerMode.solo))),
//             const SizedBox(width: 8),
//             Expanded(
//                 child: _ModeBtn(
//                     label: 'মিস',
//                     subLabel: '+০',
//                     emoji: '✗',
//                     isSelected: mode == PrayerMode.missed,
//                     activeColor: _C.textSecondary,
//                     activeBg: _C.pageBg,
//                     onTap: () => onMode(PrayerMode.missed))),
//           ]),
//         ),
//       ]),
//     );
//   }
// }

// class _ModeBtn extends StatelessWidget {
//   final String label, subLabel, emoji;
//   final bool isSelected;
//   final Color activeColor, activeBg;
//   final VoidCallback onTap;
//   const _ModeBtn({
//     required this.label,
//     required this.subLabel,
//     required this.emoji,
//     required this.isSelected,
//     required this.activeColor,
//     required this.activeBg,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: 160.ms,
//         padding: const EdgeInsets.symmetric(vertical: 11),
//         decoration: BoxDecoration(
//             color: isSelected ? activeBg : _C.pageBg,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//                 color: isSelected ? activeColor : _C.border,
//                 width: isSelected ? 1.5 : 0.5)),
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           Text(emoji,
//               style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w700,
//                   color: isSelected ? activeColor : _C.textHint)),
//           const SizedBox(height: 3),
//           Text(label,
//               style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w700,
//                   color: isSelected ? activeColor : _C.textSecondary)),
//           Text(subLabel,
//               style: TextStyle(
//                   fontSize: 9.5,
//                   color:
//                       isSelected ? activeColor.withOpacity(0.7) : _C.textHint)),
//         ]),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // CARD 3 — RAKAAT COUNTER  (witr odd / nafl even)
// // ─────────────────────────────────────────────────────────────────────────────

// class _RakaatCounterCard extends StatelessWidget {
//   final AmalCategory cat;
//   final _LocalItem? item;
//   final ValueChanged<int> onCount;
//   const _RakaatCounterCard(
//       {required this.cat, required this.item, required this.onCount});

//   @override
//   Widget build(BuildContext context) {
//     final count = item?.count ?? 0;
//     final pts = item?.points ?? 0;
//     final isWitr = _isWitr(cat);
//     final minVal = _rakaatMin(cat);
//     final maxVal = cat.maxValue?.toInt();
//     final ppu = cat.pointsPerUnit ?? 1.0;

//     final hint =
//         isWitr ? 'বেজোড় রাকাত — ১, ৩, ৫, ৭, ৯' : 'জোড় রাকাত — ২, ৪, ৬, ৮…';

//     final borderColor = count > 0 ? _C.green.withOpacity(0.4) : _C.border;

//     return Container(
//       decoration: BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: borderColor, width: count > 0 ? 1.5 : 0.5)),
//       child: Column(children: [
//         // Header
//         Padding(
//           padding: const EdgeInsets.fromLTRB(14, 13, 14, 0),
//           child: Row(children: [
//             _IconBadge(
//                 icon: Icons.mosque_rounded,
//                 active: count > 0,
//                 color: _C.darkGreen),
//             const SizedBox(width: 12),
//             Expanded(
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                   Text(cat.nameBn,
//                       style: const TextStyle(
//                           color: _C.textPrimary,
//                           fontWeight: FontWeight.w700,
//                           fontSize: 13)),
//                   if (cat.description != null)
//                     Text(cat.description!,
//                         style: const TextStyle(
//                             color: _C.textSecondary, fontSize: 11)),
//                 ])),
//             _CounterPtsTag(
//                 current: pts,
//                 max: maxVal != null ? (maxVal * ppu).round() : null,
//                 active: count > 0),
//           ]),
//         ),

//         // Hint
//         Padding(
//           padding: const EdgeInsets.only(top: 6, bottom: 2),
//           child: Text(hint,
//               style: const TextStyle(
//                   color: _C.textHint,
//                   fontSize: 10,
//                   fontWeight: FontWeight.w500)),
//         ),

//         const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//         const SizedBox(height: 20),

//         // Counter row
//         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           _StepBtn(
//             icon: Icons.remove_rounded,
//             enabled: count > 0,
//             onTap: () {
//               if (count <= 0) return;
//               final next = count - _rakaatStep(cat);
//               // If would go below minVal, reset to 0 (= not done)
//               onCount(next < minVal ? 0 : next);
//             },
//           ),
//           _CounterDisplay(
//               count: count, unit: 'রাকাত', max: maxVal, active: count > 0),
//           _StepBtn(
//             icon: Icons.add_rounded,
//             enabled: maxVal == null || count < maxVal,
//             onTap: () {
//               // First tap: jump straight to minVal
//               final next = count == 0 ? minVal : count + _rakaatStep(cat);
//               onCount(next);
//             },
//           ),
//         ]),

//         const SizedBox(height: 14),

//         // Progress
//         if (isWitr)
//           Padding(
//             padding: const EdgeInsets.only(bottom: 16),
//             child: _WitrDots(count: count),
//           )
//         else
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//             child: _UnboundedProgress(count: count, unitBn: 'রাকাত'),
//           ),

//         // Points per unit label
//         Padding(
//           padding: const EdgeInsets.only(bottom: 14),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//                 color: _C.pageBg,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: _C.border, width: 0.5)),
//             child: Text('প্রতি রাকাত = ${ppu.toInt()} পয়েন্ট',
//                 style: const TextStyle(
//                     color: _C.textSecondary,
//                     fontSize: 10.5,
//                     fontWeight: FontWeight.w500)),
//           ),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // CARD 4 — SUNNAH TOGGLE  (fixed rakaat sunnah — binary done/not-done)
// // No congregation option. No counter. Just a checkmark.
// // ─────────────────────────────────────────────────────────────────────────────

// class _SunnahToggleCard extends StatelessWidget {
//   final AmalCategory cat;
//   final _LocalItem? item;
//   final ValueChanged<bool> onToggle;
//   const _SunnahToggleCard(
//       {required this.cat, required this.item, required this.onToggle});

//   @override
//   Widget build(BuildContext context) {
//     final done = item?.completed ?? false;
//     final pts = item?.points ?? 0;

//     return GestureDetector(
//       onTap: () => onToggle(!done),
//       child: AnimatedContainer(
//         duration: 160.ms,
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//             color: done ? _C.greenLight : _C.cardBg,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//                 color: done ? _C.green.withOpacity(0.4) : _C.border,
//                 width: done ? 1.5 : 0.5)),
//         child: Row(children: [
//           // Mosque icon badge
//           _IconBadge(icon: Icons.mosque_rounded, active: done, color: _C.green),
//           const SizedBox(width: 13),
//           Expanded(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                 Text(cat.nameBn,
//                     style: TextStyle(
//                         color: done ? _C.darkGreen : _C.textPrimary,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 13)),
//                 if (cat.description != null) ...[
//                   const SizedBox(height: 2),
//                   Text(cat.description!,
//                       style: const TextStyle(
//                           color: _C.textSecondary, fontSize: 11)),
//                 ],
//               ])),
//           const SizedBox(width: 8),
//           // Check box
//           AnimatedContainer(
//             duration: 180.ms,
//             width: 30,
//             height: 30,
//             decoration: BoxDecoration(
//                 color: done ? _C.darkGreen : Colors.transparent,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                     color: done ? _C.darkGreen : _C.borderMid, width: 1.5)),
//             child: done
//                 ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
//                 : null,
//           ),
//           const SizedBox(width: 8),
//           _PtsTag(pts: pts, maxPts: cat.basePoints, active: done),
//         ]),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // CARD 5 — GENERIC COUNTER  (quran ayah, dhikr, fasting days, etc.)
// // ─────────────────────────────────────────────────────────────────────────────

// class _GenericCounterCard extends StatelessWidget {
//   final AmalCategory cat;
//   final _LocalItem? item;
//   final ValueChanged<int> onCount;
//   const _GenericCounterCard(
//       {required this.cat, required this.item, required this.onCount});

//   @override
//   Widget build(BuildContext context) {
//     final count = item?.count ?? 0;
//     final pts = item?.points ?? 0;
//     final unitBn = _unitLabelBn(cat.unit);
//     final maxVal = cat.maxValue?.toInt();
//     final ppu = cat.pointsPerUnit ?? cat.basePoints.toDouble();
//     final maxPts = maxVal != null ? (maxVal * ppu).round() : null;

//     return Container(
//       decoration: BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//               color: count > 0 ? _C.green.withOpacity(0.4) : _C.border,
//               width: count > 0 ? 1.5 : 0.5)),
//       child: Column(children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(14, 13, 14, 11),
//           child: Row(children: [
//             _IconBadge(
//                 icon: Icons.add_circle_outline_rounded,
//                 active: count > 0,
//                 color: _C.darkGreen),
//             const SizedBox(width: 12),
//             Expanded(
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                   Text(cat.nameBn,
//                       style: const TextStyle(
//                           color: _C.textPrimary,
//                           fontWeight: FontWeight.w700,
//                           fontSize: 13)),
//                   if (cat.description != null)
//                     Text(cat.description!,
//                         style: const TextStyle(
//                             color: _C.textSecondary, fontSize: 11)),
//                 ])),
//             _CounterPtsTag(current: pts, max: maxPts, active: count > 0),
//           ]),
//         ),
//         const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//         const SizedBox(height: 20),
//         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           _StepBtn(
//             icon: Icons.remove_rounded,
//             enabled: count > 0,
//             onTap: () => onCount(count - 1),
//           ),
//           _CounterDisplay(
//               count: count, unit: unitBn, max: maxVal, active: count > 0),
//           _StepBtn(
//             icon: Icons.add_rounded,
//             enabled: maxVal == null || count < maxVal,
//             onTap: () => onCount(count + 1),
//           ),
//         ]),
//         const SizedBox(height: 14),
//         if (maxVal != null)
//           Padding(
//               padding: const EdgeInsets.only(bottom: 16),
//               child: _BoundedProgress(count: count, max: maxVal))
//         else
//           Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//               child: _UnboundedProgress(count: count, unitBn: unitBn)),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 14),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//                 color: _C.pageBg,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: _C.border, width: 0.5)),
//             child: Text('প্রতি $unitBn = ${ppu.toInt()} পয়েন্ট',
//                 style: const TextStyle(
//                     color: _C.textSecondary,
//                     fontSize: 10.5,
//                     fontWeight: FontWeight.w500)),
//           ),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // CARD 6 — GENERIC TOGGLE  (all other binary amals)
// // ─────────────────────────────────────────────────────────────────────────────

// class _GenericToggleCard extends StatelessWidget {
//   final AmalCategory cat;
//   final _LocalItem? item;
//   final ValueChanged<bool> onToggle;
//   const _GenericToggleCard(
//       {required this.cat, required this.item, required this.onToggle});

//   @override
//   Widget build(BuildContext context) {
//     final done = item?.completed ?? false;
//     final pts = item?.points ?? 0;

//     return GestureDetector(
//       onTap: () => onToggle(!done),
//       child: AnimatedContainer(
//         duration: 160.ms,
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//             color: done ? _C.greenLight : _C.cardBg,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//                 color: done ? _C.green.withOpacity(0.4) : _C.border,
//                 width: done ? 1.5 : 0.5)),
//         child: Row(children: [
//           AnimatedContainer(
//             duration: 180.ms,
//             width: 30,
//             height: 30,
//             decoration: BoxDecoration(
//                 color: done ? _C.darkGreen : Colors.transparent,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                     color: done ? _C.darkGreen : _C.borderMid, width: 1.5)),
//             child: done
//                 ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
//                 : null,
//           ),
//           const SizedBox(width: 13),
//           Expanded(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                 Text(cat.nameBn,
//                     style: TextStyle(
//                         color: done ? _C.darkGreen : _C.textPrimary,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 13)),
//                 if (cat.description != null) ...[
//                   const SizedBox(height: 2),
//                   Text(cat.description!,
//                       style: const TextStyle(
//                           color: _C.textSecondary, fontSize: 11)),
//                 ],
//               ])),
//           const SizedBox(width: 8),
//           _PtsTag(pts: pts, maxPts: cat.basePoints, active: done),
//         ]),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // BOTTOM SAVE BAR
// // ─────────────────────────────────────────────────────────────────────────────

// class _BottomSaveBar extends StatelessWidget {
//   final bool isNew, saving;
//   final int points, completed;
//   final VoidCallback onSave, onCancel;
//   const _BottomSaveBar({
//     required this.isNew,
//     required this.saving,
//     required this.points,
//     required this.completed,
//     required this.onSave,
//     required this.onCancel,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(
//           16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
//       decoration: const BoxDecoration(
//           color: _C.cardBg,
//           border: Border(top: BorderSide(color: _C.border, width: 0.5))),
//       child: Row(children: [
//         GestureDetector(
//           onTap: onCancel,
//           child: Container(
//             width: 50,
//             height: 52,
//             decoration: BoxDecoration(
//                 color: _C.pageBg,
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(color: _C.border, width: 0.5)),
//             child: const Icon(Icons.close_rounded,
//                 color: _C.textSecondary, size: 20),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: GestureDetector(
//             onTap: saving ? null : onSave,
//             child: AnimatedContainer(
//               duration: 160.ms,
//               height: 52,
//               decoration: BoxDecoration(
//                   color: saving ? _C.darkGreen.withOpacity(0.7) : _C.darkGreen,
//                   borderRadius: BorderRadius.circular(14)),
//               child:
//                   Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                 if (saving)
//                   const SizedBox(
//                       width: 18,
//                       height: 18,
//                       child: CircularProgressIndicator(
//                           color: Colors.white, strokeWidth: 2))
//                 else ...[
//                   Icon(isNew ? Icons.save_rounded : Icons.check_rounded,
//                       color: Colors.white, size: 18),
//                   const SizedBox(width: 8),
//                   Text(
//                       isNew
//                           ? 'সেভ করুন  ($points pts)'
//                           : 'আপডেট করুন  ($points pts)',
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w700,
//                           fontSize: 14)),
//                 ],
//               ]),
//             ),
//           ),
//         ),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SHARED SMALL WIDGETS
// // ─────────────────────────────────────────────────────────────────────────────

// class _IconBadge extends StatelessWidget {
//   final IconData icon;
//   final bool active;
//   final Color color;
//   const _IconBadge(
//       {required this.icon, required this.active, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: 180.ms,
//       width: 38,
//       height: 38,
//       decoration: BoxDecoration(
//           color: active ? color.withOpacity(0.1) : _C.pageBg,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//               color: active ? color.withOpacity(0.25) : _C.border, width: 0.5)),
//       child: Icon(icon, size: 18, color: active ? color : _C.textHint),
//     );
//   }
// }

// class _PtsTag extends StatelessWidget {
//   final int pts;
//   final int? maxPts;
//   final bool active;
//   const _PtsTag(
//       {required this.pts, required this.maxPts, required this.active});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: 180.ms,
//       padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
//       decoration: BoxDecoration(
//           color: active ? _C.greenLight : _C.pageBg,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//               color: active ? _C.green.withOpacity(0.3) : _C.border,
//               width: 0.5)),
//       child: Text(active ? '+$pts pts' : '${maxPts ?? pts} pts',
//           style: TextStyle(
//               fontSize: 10.5,
//               fontWeight: FontWeight.w700,
//               color: active ? _C.darkGreen : _C.textHint)),
//     );
//   }
// }

// class _CounterPtsTag extends StatelessWidget {
//   final int current;
//   final int? max;
//   final bool active;
//   const _CounterPtsTag({required this.current, this.max, required this.active});

//   @override
//   Widget build(BuildContext context) {
//     final label = active
//         ? (max != null ? '+$current / $max pts' : '+$current pts')
//         : (max != null ? 'max $max pts' : '∞ pts');
//     return AnimatedContainer(
//       duration: 180.ms,
//       padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
//       decoration: BoxDecoration(
//           color: active ? _C.greenLight : _C.pageBg,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//               color: active ? _C.green.withOpacity(0.3) : _C.border,
//               width: 0.5)),
//       child: Text(label,
//           style: TextStyle(
//               fontSize: 10.5,
//               fontWeight: FontWeight.w700,
//               color: active ? _C.darkGreen : _C.textHint)),
//     );
//   }
// }

// class _CounterDisplay extends StatelessWidget {
//   final int count;
//   final String unit;
//   final int? max;
//   final bool active;
//   const _CounterDisplay(
//       {required this.count,
//       required this.unit,
//       this.max,
//       required this.active});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 96,
//       height: 78,
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//           color: active ? _C.greenLight : _C.pageBg,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//               color: active ? _C.green.withOpacity(0.3) : _C.border,
//               width: 0.5)),
//       child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//         Text('$count',
//             style: TextStyle(
//                 fontSize: 34,
//                 fontWeight: FontWeight.w900,
//                 height: 1,
//                 color: active ? _C.darkGreen : _C.textHint)),
//         const SizedBox(height: 3),
//         Text(max != null ? '/ $max $unit' : unit,
//             style: TextStyle(
//                 fontSize: 10, color: active ? _C.textSecondary : _C.textHint)),
//       ]),
//     );
//   }
// }

// class _StepBtn extends StatelessWidget {
//   final IconData icon;
//   final bool enabled;
//   final VoidCallback onTap;
//   const _StepBtn(
//       {required this.icon, required this.enabled, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: enabled ? onTap : null,
//       child: Container(
//         width: 52,
//         height: 52,
//         decoration: BoxDecoration(
//             color: enabled ? _C.greenLight : _C.pageBg,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(
//                 color: enabled ? _C.green.withOpacity(0.3) : _C.border,
//                 width: 0.5)),
//         child:
//             Icon(icon, color: enabled ? _C.darkGreen : _C.textHint, size: 24),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // WITR DOTS  (1, 3, 5, 7, 9)
// // ─────────────────────────────────────────────────────────────────────────────

// class _WitrDots extends StatelessWidget {
//   final int count;
//   const _WitrDots({required this.count});

//   @override
//   Widget build(BuildContext context) {
//     const oddValues = [1, 3, 5, 7, 9];
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: oddValues.map((val) {
//         final filled = count >= val;
//         return AnimatedContainer(
//           duration: 140.ms,
//           width: 36,
//           height: 8,
//           margin: const EdgeInsets.symmetric(horizontal: 3),
//           decoration: BoxDecoration(
//               color: filled ? _C.darkGreen : _C.border,
//               borderRadius: BorderRadius.circular(99)),
//           child: filled
//               ? Center(
//                   child: Text('$val',
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 6,
//                           fontWeight: FontWeight.w800)))
//               : null,
//         );
//       }).toList(),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // BOUNDED PROGRESS  (for counters with maxValue, e.g. fasting days)
// // ─────────────────────────────────────────────────────────────────────────────

// class _BoundedProgress extends StatelessWidget {
//   final int count, max;
//   const _BoundedProgress({required this.count, required this.max});

//   @override
//   Widget build(BuildContext context) {
//     if (max > 15) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(children: [
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//             Text('$count',
//                 style: const TextStyle(
//                     color: _C.darkGreen,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 11)),
//             Text('$max',
//                 style: const TextStyle(color: _C.textHint, fontSize: 11)),
//           ]),
//           const SizedBox(height: 6),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(99),
//             child: LinearProgressIndicator(
//               value: (count / max).clamp(0.0, 1.0),
//               backgroundColor: _C.border,
//               valueColor: const AlwaysStoppedAnimation(_C.darkGreen),
//               minHeight: 8,
//             ),
//           ),
//         ]),
//       );
//     }
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(
//           max,
//           (i) => AnimatedContainer(
//                 duration: 140.ms,
//                 width: max <= 7 ? 28 : 22,
//                 height: 7,
//                 margin: const EdgeInsets.symmetric(horizontal: 2),
//                 decoration: BoxDecoration(
//                     color: i < count ? _C.darkGreen : _C.border,
//                     borderRadius: BorderRadius.circular(99)),
//               )),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // UNBOUNDED PROGRESS
// // ─────────────────────────────────────────────────────────────────────────────

// class _UnboundedProgress extends StatelessWidget {
//   final int count;
//   final String unitBn;
//   const _UnboundedProgress({required this.count, required this.unitBn});

//   @override
//   Widget build(BuildContext context) {
//     return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//       Icon(Icons.trending_up_rounded,
//           color: count > 0 ? _C.darkGreen : _C.textHint, size: 16),
//       const SizedBox(width: 6),
//       Text(
//           count > 0
//               ? '$count $unitBn যোগ করা হয়েছে'
//               : 'যত বেশি, তত বেশি পয়েন্ট',
//           style: TextStyle(
//               color: count > 0 ? _C.darkGreen : _C.textHint,
//               fontSize: 11,
//               fontWeight: FontWeight.w500)),
//     ]);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // LOCAL ITEM MODEL
// // ─────────────────────────────────────────────────────────────────────────────

// class _LocalItem {
//   final AmalCategory cat;
//   bool completed;
//   bool isExempted;
//   PrayerMode? prayerMode;
//   int count;

//   _LocalItem({
//     required this.cat,
//     required this.completed,
//     this.prayerMode,
//     this.count = 0,
//     this.isExempted = false,
//   });

//   int get points {
//     if (isExempted) return 0;

//     switch (_resolveCardType(cat)) {
//       case _CardType.fardPrayer:
//         if (prayerMode == PrayerMode.congregation)
//           return cat.congregationPoints ?? cat.basePoints;
//         if (prayerMode == PrayerMode.solo) return cat.basePoints;
//         return 0;

//       case _CardType.rakaatCounter:
//       case _CardType.genericCounter:
//         return (count * (cat.pointsPerUnit ?? cat.basePoints.toDouble()))
//             .round();

//       case _CardType.sunnahToggle:
//       case _CardType.genericToggle:
//         return completed ? cat.basePoints : 0;
//     }
//   }
// }
import 'package:amal_tracker/features/auth/providers/provider_reset.dart';
import 'package:amal_tracker/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tracker_provider.dart';
import '../models/tracker_model.dart';
import '../../../core/constants/app_constants.dart';

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
  static const amber = Color(0xFFFF6B35);
  static const amberLight = Color(0xFFFFF3E0);
  static const red = Color(0xFFEF4444);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
  static const border = Color(0xFFE4EAE4);
  static const borderMid = Color(0xFFD0DAD2);
  static const success = Color(0xFF16A34A);
  static const maafBg = Color(0xFFE8F5EE);
  static const maafText = Color(0xFF1B7045);
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────

String _unitLabelBn(String? unit) {
  switch (unit) {
    case 'ayah':
      return 'আয়াত';
    case 'day':
      return 'দিন';
    case 'person':
      return 'জন';
    case 'minute':
      return 'মিনিট';
    case 'time':
      return 'বার';
    case 'rakaat':
      return 'রাকাত';
    default:
      return unit ?? 'টি';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD TYPE RESOLVER
// ─────────────────────────────────────────────────────────────────────────────

enum _CardType {
  fardPrayer,
  rakaatCounter,
  sunnahToggle,
  genericCounter,
  genericToggle,
}

_CardType _resolveCardType(AmalCategory cat) {
  if (cat.isPrayer) {
    if (cat.isFard) return _CardType.fardPrayer;
    if (cat.inputType == AmalInputType.counter) return _CardType.rakaatCounter;
    return _CardType.sunnahToggle;
  }
  if (cat.inputType == AmalInputType.counter) return _CardType.genericCounter;
  return _CardType.genericToggle;
}

bool _isWitr(AmalCategory cat) => cat.key == 'witr';
int _rakaatStep(AmalCategory cat) => 2;
int _rakaatMin(AmalCategory cat) =>
    (cat.minValue ?? (_isWitr(cat) ? 1 : 2)).toInt();

// ─────────────────────────────────────────────────────────────────────────────
// SHEET ROOT
// ─────────────────────────────────────────────────────────────────────────────

class DailyEntrySheet extends ConsumerStatefulWidget {
  final String dateStr;
  final Map<String, List<AmalCategory>> catsBySection;
  final DailyEntryState existingState;
  final bool isNew;

  const DailyEntrySheet({
    super.key,
    required this.dateStr,
    required this.catsBySection,
    required this.existingState,
    required this.isNew,
  });

  @override
  ConsumerState<DailyEntrySheet> createState() => _DailyEntrySheetState();
}

class _DailyEntrySheetState extends ConsumerState<DailyEntrySheet> {
  // ── State fields — সব plain declarations, কোনো widget access নেই ──────────
  late Map<String, _LocalItem> _items;
  late DateTime _selectedDate;
  bool _saving = false;
  int _activeSection = 0;
  bool _isExemptDay = false;
  bool _isFemale = false;

  // ── Active sections getter — widget access safe কারণ এটা getter ──────────
  // getter শুধু call হলে তখন widget access করে, class load হওয়ার সময় না
  List<String> get _activeSections => AppConstants.sections
      .map((s) => s.key)
      .where((k) => (widget.catsBySection[k] ?? []).isNotEmpty)
      .toList();

  // ── Section icon helper ───────────────────────────────────────────────────
  IconData _sectionIcon(String key) => AppConstants.sections
      .firstWhere(
        (s) => s.key == key,
        orElse: () =>
            SectionMeta(key: key, labelBn: key, labelEn: key, iconKey: ''),
      )
      .icon;

  // ── initState — এখানে widget access করা safe ─────────────────────────────
  @override
  void initState() {
    super.initState();

    // dateStr "2024-01-15" → DateTime parse
    final parts = widget.dateStr.split('-');
    _selectedDate = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );

    final user = ref.read(currentUserProvider);
    _isFemale = user?.gender?.toLowerCase() == 'female';
    _isExemptDay = widget.existingState.entry?.isExemptDay ?? false;
    _buildItems();
  }

  // ── Build local item map ──────────────────────────────────────────────────
  void _buildItems() {
    _items = {};
    final existing = widget.existingState.effectiveEntries;
    for (final cats in widget.catsBySection.values) {
      for (final cat in cats) {
        final prev = existing[cat.id];
        final exempted = _isFemale && _isExemptDay && cat.isExemptDuringPeriod;
        _items[cat.id] = _LocalItem(
          cat: cat,
          completed: exempted ? false : (prev?.completed ?? false),
          prayerMode: exempted ? PrayerMode.missed : prev?.prayerMode,
          count: exempted ? 0 : (prev?.count ?? 0),
          isExempted: exempted,
        );
      }
    }
  }

  // ── Exempt day toggle ─────────────────────────────────────────────────────
  void _toggleExemptDay(bool val) {
    setState(() {
      _isExemptDay = val;
      for (final item in _items.values) {
        if (!item.cat.isExemptDuringPeriod) continue;
        item.isExempted = val;
        if (val) {
          item.completed = false;
          item.prayerMode = PrayerMode.missed;
          item.count = 0;
        }
      }
    });
    HapticFeedback.mediumImpact();
  }

  // ── Callbacks ─────────────────────────────────────────────────────────────
  void _toggleBinary(String id, bool value) {
    setState(() {
      final item = _items[id]!;
      if (item.isExempted) return;
      item.completed = value;
    });
    HapticFeedback.selectionClick();
  }

  void _setPrayerMode(String id, PrayerMode mode) {
    setState(() {
      final item = _items[id]!;
      if (item.isExempted) return;
      item.prayerMode = mode;
      item.completed = mode != PrayerMode.missed;
    });
    HapticFeedback.selectionClick();
  }

  void _setCount(String id, int rawCount) {
    setState(() {
      final item = _items[id]!;
      if (item.isExempted) return;
      final cat = item.cat;
      final max = cat.maxValue?.toInt();
      int value = rawCount;

      if (cat.unit == 'rakaat' && value > 0) {
        if (_isWitr(cat)) {
          if (value.isEven) value = value - 1;
          value = value.clamp(1, max ?? 9);
        } else {
          if (value.isOdd) value = value - 1;
          final min = _rakaatMin(cat);
          value = value.clamp(min, max ?? 9999);
        }
      }

      item.count = max != null ? value.clamp(0, max) : value.clamp(0, 9999);
      item.completed = item.count > 0;
    });
    HapticFeedback.lightImpact();
  }

  // ── Totals ────────────────────────────────────────────────────────────────
  int get _totalPoints => _items.values.fold(0, (s, i) => s + i.points);
  int get _completedCount =>
      _items.values.where((i) => i.completed && !i.isExempted).length;

  // ── Save ──────────────────────────────────────────────────────────────────
  Future<void> _save() async {
    setState(() => _saving = true);

    final updates = _items.values
        .map((item) => EntryUpdate(
              categoryId: item.cat.id,
              completed: item.isExempted ? false : item.completed,
              prayerMode: item.isExempted ? PrayerMode.missed : item.prayerMode,
              count: item.isExempted ? 0 : item.count,
            ))
        .toList();

    final ok = await ref
        .read(dailyEntryProvider(widget.dateStr).notifier)
        .saveEntryFromUpdates(updates, isExemptDay: _isExemptDay);

    // debugPrint('Save result: $ok');
    if (ok && mounted) {
      final parts = widget.dateStr.split('-');

      // আমাদের সেই বুলেটপ্রুফ অন-ডিমান্ড ক্যাশ রিসেট মেথড
      refreshAfterEntryUpdate(
        ref,
        year: int.parse(parts[0]),
        month: int.parse(parts[1]),
        specificDateStr: widget.dateStr,
      );
    }

    setState(() => _saving = false);
    if (!mounted) return;
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(
          ok ? Icons.check_circle_rounded : Icons.error_outline_rounded,
          color: Colors.white,
        ),
        const SizedBox(width: 10),
        Text(ok
            ? (widget.isNew
                ? 'আমল সফলভাবে সেভ হয়েছে! 🌟'
                : 'আমল আপডেট হয়েছে! ✨')
            : 'সেভ করতে সমস্যা হয়েছে। আবার চেষ্টা করুন।'),
      ]),
      backgroundColor: ok ? _C.success : _C.red,
      margin: const EdgeInsets.all(16),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    ));
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final sections = _activeSections;

    return Container(
      height: size.height * 0.96,
      decoration: const BoxDecoration(
        color: _C.pageBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(children: [
        _SheetHeader(
          isNew: widget.isNew,
          dateStr: widget.dateStr,
          points: _totalPoints,
          completed: _completedCount,
          saving: _saving,
          onClose: () => Navigator.pop(context),
          onSave: _save,
        ),
        _SectionTabBar(
          sections: sections,
          activeIndex: _activeSection,
          catsBySection: widget.catsBySection,
          localItems: _items,
          sectionIcon: _sectionIcon,
          onTap: (i) => setState(() => _activeSection = i),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: 220.ms,
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
              child: child,
            ),
            child: _SectionForm(
              key: ValueKey(_activeSection),
              sectionKey: sections[_activeSection],
              categories: widget.catsBySection[sections[_activeSection]] ?? [],
              localItems: _items,
              isTablet: isTablet,
              isFemale: _isFemale,
              isExemptDay: _isExemptDay,
              selectedDate: _selectedDate,
              onToggle: _toggleBinary,
              onPrayerMode: _setPrayerMode,
              onCount: _setCount,
              onExemptToggle: _toggleExemptDay,
            ),
          ),
        ),
        _BottomSaveBar(
          isNew: widget.isNew,
          saving: _saving,
          points: _totalPoints,
          completed: _completedCount,
          onSave: _save,
          onCancel: () => Navigator.pop(context),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHEET HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _SheetHeader extends StatelessWidget {
  final bool isNew, saving;
  final String dateStr;
  final int points, completed;
  final VoidCallback onClose, onSave;

  const _SheetHeader({
    required this.isNew,
    required this.saving,
    required this.dateStr,
    required this.points,
    required this.completed,
    required this.onClose,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final parts = dateStr.split('-');
    final d = int.parse(parts[2]);
    final m = int.parse(parts[1]);
    final month = AppConstants.bengaliMonths[m - 1];
    final y = parts[0];

    return Container(
      decoration: const BoxDecoration(
        color: _C.darkGreen,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Stack(children: [
        Positioned(
            top: -30,
            right: -30,
            child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.04)))),
        Positioned(
            bottom: 0,
            left: 10,
            child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.03)))),
        Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(99)))),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.18), width: 0.5)),
                child: Icon(isNew ? Icons.add_rounded : Icons.edit_rounded,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(isNew ? 'আমল যোগ করুন' : 'আমল সম্পাদনা করুন',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            letterSpacing: -0.3)),
                    Text('$d $month $y',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 11,
                            fontWeight: FontWeight.w500)),
                  ])),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.15), width: 0.5)),
                  child: Icon(Icons.close_rounded,
                      color: Colors.white.withOpacity(0.7), size: 18),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.18), width: 0.5)),
              child: Row(children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                      color: _C.gold, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.stars_rounded,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('লাইভ পয়েন্ট',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 10)),
                      const SizedBox(height: 1),
                      Row(children: [
                        Text('$points',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                                letterSpacing: -0.4,
                                height: 1)),
                        Text(' pts',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 12)),
                      ]),
                    ])),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.check_circle_rounded,
                        color: Colors.white.withOpacity(0.7), size: 12),
                    const SizedBox(width: 4),
                    Text('$completed টি সম্পন্ন',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ]),
                ),
              ]),
            ),
          ),
        ]),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION TAB BAR
// ─────────────────────────────────────────────────────────────────────────────

class _SectionTabBar extends StatelessWidget {
  final List<String> sections;
  final IconData Function(String) sectionIcon; // Map এর বদলে function
  final int activeIndex;
  final Map<String, List<AmalCategory>> catsBySection;
  final Map<String, _LocalItem> localItems;
  final ValueChanged<int> onTap;

  const _SectionTabBar({
    required this.sections,
    required this.sectionIcon,
    required this.activeIndex,
    required this.catsBySection,
    required this.localItems,
    required this.onTap,
  });

  int _doneIn(String sec) {
    return (catsBySection[sec] ?? [])
        .where((c) =>
            localItems[c.id]?.completed == true &&
            localItems[c.id]?.isExempted == false)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _C.cardBg,
      child: Column(children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            children: sections.asMap().entries.map((e) {
              final i = e.key;
              final sec = e.value;
              final label = AppConstants.sectionLabels[sec]?['bn'] ?? sec;
              final icon = sectionIcon(sec); // ← function call
              final done = _doneIn(sec);
              final total = (catsBySection[sec] ?? []).length;
              final active = i == activeIndex;
              final allDone = done == total && total > 0;

              return GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: 180.ms,
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: active ? _C.darkGreen : _C.pageBg,
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(
                      color: active
                          ? _C.darkGreen
                          : allDone
                              ? _C.green.withOpacity(0.4)
                              : _C.border,
                      width: 0.5,
                    ),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(icon,
                        size: 12,
                        color: active
                            ? Colors.white
                            : allDone
                                ? _C.green
                                : _C.textSecondary),
                    const SizedBox(width: 5),
                    Text(label,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                active ? FontWeight.w700 : FontWeight.w500,
                            color: active
                                ? Colors.white
                                : allDone
                                    ? _C.green
                                    : _C.textSecondary)),
                    if (done > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: active
                                ? Colors.white.withOpacity(0.2)
                                : allDone
                                    ? _C.greenLight
                                    : _C.pageBg,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text('$done/$total',
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: active
                                    ? Colors.white
                                    : allDone
                                        ? _C.green
                                        : _C.textHint)),
                      ),
                    ],
                  ]),
                ),
              );
            }).toList(),
          ),
        ),
        const Divider(height: 0.5, thickness: 0.5, color: _C.border),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EXEMPT DAY BANNER
// ─────────────────────────────────────────────────────────────────────────────

class _ExemptDayBanner extends StatelessWidget {
  final bool isExemptDay;
  final ValueChanged<bool> onToggle;
  const _ExemptDayBanner({required this.isExemptDay, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(!isExemptDay),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isExemptDay
              ? _C.midGreen.withOpacity(0.08)
              : const Color(0xFFFFF8EE),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isExemptDay
                ? _C.midGreen.withOpacity(0.35)
                : _C.gold.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(children: [
          AnimatedContainer(
            duration: 200.ms,
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isExemptDay
                  ? _C.midGreen.withOpacity(0.12)
                  : _C.gold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(11),
            ),
            child:
                const Center(child: Text('🌸', style: TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                  isExemptDay ? 'আজ মাহলির দিন' : 'আজ কি মাহলি আছেন?',
                  style: TextStyle(
                      color: isExemptDay ? _C.darkGreen : _C.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  isExemptDay
                      ? 'ফরজ আমলগুলো মাফ হিসেবে চিহ্নিত হয়েছে'
                      : 'চালু করলে ফরজ আমলগুলো মাফ ধরা হবে',
                  style: TextStyle(
                      color: isExemptDay ? _C.midGreen : _C.textSecondary,
                      fontSize: 11),
                ),
              ])),
          const SizedBox(width: 10),
          _ToggleSwitch(
              value: isExemptDay,
              onChanged: onToggle,
              activeColor: _C.midGreen),
        ]),
      ),
    ).animate().fadeIn(duration: 220.ms).slideY(begin: -0.04);
  }
}

class _ToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  const _ToggleSwitch(
      {required this.value,
      required this.onChanged,
      required this.activeColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: 200.ms,
        curve: Curves.easeInOut,
        width: 46,
        height: 26,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: value ? activeColor : _C.borderMid,
            borderRadius: BorderRadius.circular(99)),
        child: AnimatedAlign(
          duration: 200.ms,
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle)),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION FORM
// ─────────────────────────────────────────────────────────────────────────────

class _SectionForm extends StatelessWidget {
  final String sectionKey;
  final List<AmalCategory> categories;
  final Map<String, _LocalItem> localItems;
  final bool isTablet, isFemale, isExemptDay;
  final DateTime selectedDate; // ← state থেকে pass হয়ে আসে
  final void Function(String, bool) onToggle;
  final void Function(String, PrayerMode) onPrayerMode;
  final void Function(String, int) onCount;
  final ValueChanged<bool> onExemptToggle;

  const _SectionForm({
    super.key,
    required this.sectionKey,
    required this.categories,
    required this.localItems,
    required this.isTablet,
    required this.isFemale,
    required this.isExemptDay,
    required this.selectedDate,
    required this.onToggle,
    required this.onPrayerMode,
    required this.onCount,
    required this.onExemptToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Center(
          child: Text('এই বিভাগে কোনো আমল নেই',
              style: TextStyle(color: _C.textHint, fontSize: 13)));
    }

    final hPad =
        isTablet ? (MediaQuery.of(context).size.width - 600) / 2 + 16.0 : 16.0;
    final showBanner = isFemale && sectionKey == 'salat';
    // final itemCount = categories.length + (showBanner ? 1 : 0);

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 14),
      // itemCount: itemCount,
      itemCount: categories.length + (showBanner ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, idx) {
        // Banner — female + salat section এর প্রথম item
        // if (showBanner && i == 0) {
        //   return _ExemptDayBanner(
        //       isExemptDay: isExemptDay, onToggle: onExemptToggle);
        // }
        if (showBanner && idx == 0) {
          return _ExemptDayBanner(
              isExemptDay: isExemptDay, onToggle: onExemptToggle);
        }

        final catIndex = showBanner ? idx - 1 : idx;
        final cat = categories[catIndex];
        final item = localItems[cat.id];

        // ── Juma / Zuhr gender + day logic ─────────────────────────────────
        //
        // Islamic ruling:
        //   Male + Friday   → জুমুআ ফরজ। যোহর পড়তে হয় না।
        //   Male + other    → যোহর ফরজ। জুমুআ নেই।
        //   Female + Friday → যোহর ফরজ। জুমুআ ঐচ্ছিক।
        //   Female + other  → যোহর ফরজ। জুমুআ নেই।
        //
        // Flutter weekday: Mon=1 ... Fri=5 ... Sun=7
        final isFriday = selectedDate.weekday == 5;
        final isMale = !isFemale;
        final isJuma = cat.key == 'juma_prayer';
        final isZuhr = cat.key == 'zuhr';

        String? extraBadge; // optional badge — "ঐচ্ছিক", "জুমুআর দিন" etc
        bool forceNotApplicable = false;
        String notApplicableLabel = 'আজ প্রযোজ্য নয়';

        if (isZuhr && isMale && isFriday) {
          // Male Friday: zuhr dim — জুমুআ পড়লে যোহর আলাদা নয়
          forceNotApplicable = true;
          notApplicableLabel = 'জুমুআর দিন যোহর নেই';
        } else if (isJuma) {
          if (!isFriday) {
            // Not Friday: juma dim for everyone
            forceNotApplicable = true;
            notApplicableLabel = 'শুধু শুক্রবার';
          } else if (isFemale) {
            // Female + Friday: juma optional — dim না, badge দাও
            extraBadge = 'ঐচ্ছিক';
          }
          // Male + Friday: juma normal দেখাও — fully clickable
        }

        // ── Card build ──────────────────────────────────────────────────────
        Widget card;

        if (item?.isExempted == true) {
          card = _ExemptedCard(cat: cat);
        } else {
          switch (_resolveCardType(cat)) {
            case _CardType.fardPrayer:
              card = _FardPrayerCard(
                cat: cat,
                item: item,
                onMode: (mode) => onPrayerMode(cat.id, mode),
              );
              break;
            case _CardType.rakaatCounter:
              card = _RakaatCounterCard(
                cat: cat,
                item: item,
                onCount: (c) => onCount(cat.id, c),
              );
              break;
            case _CardType.sunnahToggle:
              card = _SunnahToggleCard(
                cat: cat,
                item: item,
                badgeLabel: extraBadge,
                onToggle: (v) => onToggle(cat.id, v),
              );
              break;
            case _CardType.genericCounter:
              card = _GenericCounterCard(
                cat: cat,
                item: item,
                onCount: (c) => onCount(cat.id, c),
              );
              break;
            case _CardType.genericToggle:
              card = _GenericToggleCard(
                cat: cat,
                item: item,
                onToggle: (v) => onToggle(cat.id, v),
              );
              break;
          }
        }

        // ── Applicable day check ────────────────────────────────────────────
        // cat.isApplicableOn(): Flutter weekday % 7 = JS day (Sun=0, Fri=5)
        final isApplicable =
            !forceNotApplicable && cat.isApplicableOn(selectedDate);

        if (!isApplicable) {
          // IgnorePointer: touch সম্পূর্ণ block — click হবে না, point যোগ হবে না
          card = IgnorePointer(
            child: Stack(
              children: [
                Opacity(opacity: 0.38, child: card),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F0EB),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _C.border, width: 0.5),
                    ),
                    child: Text(
                      notApplicableLabel,
                      style: const TextStyle(
                        fontSize: 9.5,
                        color: _C.textHint,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return card
            .animate(delay: (catIndex * 35).ms)
            .fadeIn(duration: 240.ms)
            .slideX(begin: 0.05, curve: Curves.easeOut);
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD 1 — EXEMPTED
// ─────────────────────────────────────────────────────────────────────────────

class _ExemptedCard extends StatelessWidget {
  final AmalCategory cat;
  const _ExemptedCard({required this.cat});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: _C.pageBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.border, width: 0.5)),
      child: Opacity(
        opacity: 0.55,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: _C.pageBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _C.border, width: 0.5)),
              child: const Icon(Icons.mosque_rounded,
                  color: _C.textHint, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(cat.nameBn,
                      style: const TextStyle(
                          color: _C.textHint,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: _C.textHint)),
                  Text(cat.nameEn,
                      style: const TextStyle(color: _C.textHint, fontSize: 11)),
                ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: _C.maafBg,
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: _C.green.withOpacity(0.3), width: 0.5)),
              child: const Text('মাফ আছে',
                  style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: _C.maafText)),
            ),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD 2 — FARD PRAYER
// ─────────────────────────────────────────────────────────────────────────────

class _FardPrayerCard extends StatelessWidget {
  final AmalCategory cat;
  final _LocalItem? item;
  final ValueChanged<PrayerMode> onMode;
  const _FardPrayerCard(
      {required this.cat, required this.item, required this.onMode});

  @override
  Widget build(BuildContext context) {
    final mode = item?.prayerMode ?? PrayerMode.missed;
    final pts = item?.points ?? 0;

    final borderColor = mode == PrayerMode.congregation
        ? _C.green.withOpacity(0.5)
        : mode == PrayerMode.solo
            ? _C.amber.withOpacity(0.5)
            : _C.border;

    return Container(
      decoration: BoxDecoration(
          color: _C.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 13, 14, 11),
          child: Row(children: [
            _IconBadge(
                icon: Icons.mosque_rounded,
                active: mode != PrayerMode.missed,
                color: _C.green),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(cat.nameBn,
                      style: const TextStyle(
                          color: _C.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                  Text(cat.nameEn,
                      style: const TextStyle(
                          color: _C.textSecondary, fontSize: 11)),
                ])),
            _PtsTag(pts: pts, maxPts: cat.congregationPoints, active: pts > 0),
          ]),
        ),
        const Divider(height: 0.5, thickness: 0.5, color: _C.border),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Row(children: [
            Expanded(
                child: _ModeBtn(
                    label: 'জামাতে',
                    subLabel: '+${cat.congregationPoints}',
                    emoji: '✔',
                    isSelected: mode == PrayerMode.congregation,
                    activeColor: _C.green,
                    activeBg: _C.greenLight,
                    onTap: () => onMode(PrayerMode.congregation))),
            const SizedBox(width: 8),
            Expanded(
                child: _ModeBtn(
                    label: 'একাকী',
                    subLabel: '+${cat.basePoints}',
                    emoji: '/',
                    isSelected: mode == PrayerMode.solo,
                    activeColor: _C.amber,
                    activeBg: _C.amberLight,
                    onTap: () => onMode(PrayerMode.solo))),
            const SizedBox(width: 8),
            Expanded(
                child: _ModeBtn(
                    label: 'মিস',
                    subLabel: '+০',
                    emoji: '✗',
                    isSelected: mode == PrayerMode.missed,
                    activeColor: _C.textSecondary,
                    activeBg: _C.pageBg,
                    onTap: () => onMode(PrayerMode.missed))),
          ]),
        ),
      ]),
    );
  }
}

class _ModeBtn extends StatelessWidget {
  final String label, subLabel, emoji;
  final bool isSelected;
  final Color activeColor, activeBg;
  final VoidCallback onTap;
  const _ModeBtn({
    required this.label,
    required this.subLabel,
    required this.emoji,
    required this.isSelected,
    required this.activeColor,
    required this.activeBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 160.ms,
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
            color: isSelected ? activeBg : _C.pageBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isSelected ? activeColor : _C.border,
                width: isSelected ? 1.5 : 0.5)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(emoji,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? activeColor : _C.textHint)),
          const SizedBox(height: 3),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? activeColor : _C.textSecondary)),
          Text(subLabel,
              style: TextStyle(
                  fontSize: 9.5,
                  color:
                      isSelected ? activeColor.withOpacity(0.7) : _C.textHint)),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD 3 — RAKAAT COUNTER
// ─────────────────────────────────────────────────────────────────────────────

class _RakaatCounterCard extends StatelessWidget {
  final AmalCategory cat;
  final _LocalItem? item;
  final ValueChanged<int> onCount;
  const _RakaatCounterCard(
      {required this.cat, required this.item, required this.onCount});

  @override
  Widget build(BuildContext context) {
    final count = item?.count ?? 0;
    final pts = item?.points ?? 0;
    final isWitr = _isWitr(cat);
    final minVal = _rakaatMin(cat);
    final maxVal = cat.maxValue?.toInt();
    final ppu = cat.pointsPerUnit ?? 1.0;
    final hint =
        isWitr ? 'বেজোড় রাকাত — ১, ৩, ৫, ৭, ৯' : 'জোড় রাকাত — ২, ৪, ৬, ৮…';
    final borderColor = count > 0 ? _C.green.withOpacity(0.4) : _C.border;

    return Container(
      decoration: BoxDecoration(
          color: _C.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: count > 0 ? 1.5 : 0.5)),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 13, 14, 0),
          child: Row(children: [
            _IconBadge(
                icon: Icons.mosque_rounded,
                active: count > 0,
                color: _C.darkGreen),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(cat.nameBn,
                      style: const TextStyle(
                          color: _C.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                  if (cat.description != null)
                    Text(cat.description!,
                        style: const TextStyle(
                            color: _C.textSecondary, fontSize: 11)),
                ])),
            _CounterPtsTag(
                current: pts,
                max: maxVal != null ? (maxVal * ppu).round() : null,
                active: count > 0),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 2),
          child: Text(hint,
              style: const TextStyle(
                  color: _C.textHint,
                  fontSize: 10,
                  fontWeight: FontWeight.w500)),
        ),
        const Divider(height: 0.5, thickness: 0.5, color: _C.border),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _StepBtn(
            icon: Icons.remove_rounded,
            enabled: count > 0,
            onTap: () {
              if (count <= 0) return;
              final next = count - _rakaatStep(cat);
              onCount(next < minVal ? 0 : next);
            },
          ),
          _CounterDisplay(
              count: count, unit: 'রাকাত', max: maxVal, active: count > 0),
          _StepBtn(
            icon: Icons.add_rounded,
            enabled: maxVal == null || count < maxVal,
            onTap: () {
              final next = count == 0 ? minVal : count + _rakaatStep(cat);
              onCount(next);
            },
          ),
        ]),
        const SizedBox(height: 14),
        if (isWitr)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _WitrDots(count: count),
          )
        else
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _UnboundedProgress(count: count, unitBn: 'রাকাত'),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: _C.pageBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _C.border, width: 0.5)),
            child: Text('প্রতি রাকাত = ${ppu.toInt()} পয়েন্ট',
                style: const TextStyle(
                    color: _C.textSecondary,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500)),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD 4 — SUNNAH TOGGLE
// ─────────────────────────────────────────────────────────────────────────────

class _SunnahToggleCard extends StatelessWidget {
  final AmalCategory cat;
  final _LocalItem? item;
  final ValueChanged<bool> onToggle;
  final String? badgeLabel; // optional — juma optional badge for female
  const _SunnahToggleCard(
      {required this.cat,
      required this.item,
      required this.onToggle,
      this.badgeLabel});

  @override
  Widget build(BuildContext context) {
    final done = item?.completed ?? false;
    final pts = item?.points ?? 0;

    return GestureDetector(
      onTap: () => onToggle(!done),
      child: AnimatedContainer(
        duration: 160.ms,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: done ? _C.greenLight : _C.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: done ? _C.green.withOpacity(0.4) : _C.border,
                width: done ? 1.5 : 0.5)),
        child: Row(children: [
          _IconBadge(icon: Icons.mosque_rounded, active: done, color: _C.green),
          const SizedBox(width: 13),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(cat.nameBn,
                    style: TextStyle(
                        color: done ? _C.darkGreen : _C.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                if (cat.description != null) ...[
                  const SizedBox(height: 2),
                  Text(cat.description!,
                      style: const TextStyle(
                          color: _C.textSecondary, fontSize: 11)),
                ],
              ])),
          const SizedBox(width: 8),
          AnimatedContainer(
            duration: 180.ms,
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: done ? _C.darkGreen : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: done ? _C.darkGreen : _C.borderMid, width: 1.5)),
            child: done
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                : null,
          ),
          const SizedBox(width: 8),
          if (badgeLabel != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFF8EE),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: _C.gold.withOpacity(0.5), width: 0.5)),
              child: Text(badgeLabel!,
                  style: const TextStyle(
                      fontSize: 9.5,
                      color: _C.gold,
                      fontWeight: FontWeight.w600)),
            )
          else
            _PtsTag(pts: pts, maxPts: cat.basePoints, active: done),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD 5 — GENERIC COUNTER
// ─────────────────────────────────────────────────────────────────────────────

class _GenericCounterCard extends StatelessWidget {
  final AmalCategory cat;
  final _LocalItem? item;
  final ValueChanged<int> onCount;
  const _GenericCounterCard(
      {required this.cat, required this.item, required this.onCount});

  @override
  Widget build(BuildContext context) {
    final count = item?.count ?? 0;
    final pts = item?.points ?? 0;
    final unitBn = _unitLabelBn(cat.unit);
    final maxVal = cat.maxValue?.toInt();
    final ppu = cat.pointsPerUnit ?? cat.basePoints.toDouble();
    final maxPts = maxVal != null ? (maxVal * ppu).round() : null;

    return Container(
      decoration: BoxDecoration(
          color: _C.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: count > 0 ? _C.green.withOpacity(0.4) : _C.border,
              width: count > 0 ? 1.5 : 0.5)),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 13, 14, 11),
          child: Row(children: [
            _IconBadge(
                icon: Icons.add_circle_outline_rounded,
                active: count > 0,
                color: _C.darkGreen),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(cat.nameBn,
                      style: const TextStyle(
                          color: _C.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                  if (cat.description != null)
                    Text(cat.description!,
                        style: const TextStyle(
                            color: _C.textSecondary, fontSize: 11)),
                ])),
            _CounterPtsTag(current: pts, max: maxPts, active: count > 0),
          ]),
        ),
        const Divider(height: 0.5, thickness: 0.5, color: _C.border),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _StepBtn(
            icon: Icons.remove_rounded,
            enabled: count > 0,
            onTap: () => onCount(count - 1),
          ),
          _CounterDisplay(
              count: count, unit: unitBn, max: maxVal, active: count > 0),
          _StepBtn(
            icon: Icons.add_rounded,
            enabled: maxVal == null || count < maxVal,
            onTap: () => onCount(count + 1),
          ),
        ]),
        const SizedBox(height: 14),
        if (maxVal != null)
          Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _BoundedProgress(count: count, max: maxVal))
        else
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _UnboundedProgress(count: count, unitBn: unitBn)),
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: _C.pageBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _C.border, width: 0.5)),
            child: Text('প্রতি $unitBn = ${ppu.toInt()} পয়েন্ট',
                style: const TextStyle(
                    color: _C.textSecondary,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500)),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD 6 — GENERIC TOGGLE
// ─────────────────────────────────────────────────────────────────────────────

class _GenericToggleCard extends StatelessWidget {
  final AmalCategory cat;
  final _LocalItem? item;
  final ValueChanged<bool> onToggle;
  const _GenericToggleCard(
      {required this.cat, required this.item, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final done = item?.completed ?? false;
    final pts = item?.points ?? 0;

    return GestureDetector(
      onTap: () => onToggle(!done),
      child: AnimatedContainer(
        duration: 160.ms,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: done ? _C.greenLight : _C.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: done ? _C.green.withOpacity(0.4) : _C.border,
                width: done ? 1.5 : 0.5)),
        child: Row(children: [
          AnimatedContainer(
            duration: 180.ms,
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: done ? _C.darkGreen : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: done ? _C.darkGreen : _C.borderMid, width: 1.5)),
            child: done
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                : null,
          ),
          const SizedBox(width: 13),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(cat.nameBn,
                    style: TextStyle(
                        color: done ? _C.darkGreen : _C.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                if (cat.description != null) ...[
                  const SizedBox(height: 2),
                  Text(cat.description!,
                      style: const TextStyle(
                          color: _C.textSecondary, fontSize: 11)),
                ],
              ])),
          const SizedBox(width: 8),
          _PtsTag(pts: pts, maxPts: cat.basePoints, active: done),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM SAVE BAR
// ─────────────────────────────────────────────────────────────────────────────

class _BottomSaveBar extends StatelessWidget {
  final bool isNew, saving;
  final int points, completed;
  final VoidCallback onSave, onCancel;
  const _BottomSaveBar({
    required this.isNew,
    required this.saving,
    required this.points,
    required this.completed,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: const BoxDecoration(
          color: _C.cardBg,
          border: Border(top: BorderSide(color: _C.border, width: 0.5))),
      child: Row(children: [
        GestureDetector(
          onTap: onCancel,
          child: Container(
            width: 50,
            height: 52,
            decoration: BoxDecoration(
                color: _C.pageBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _C.border, width: 0.5)),
            child: const Icon(Icons.close_rounded,
                color: _C.textSecondary, size: 20),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: saving ? null : onSave,
            child: AnimatedContainer(
              duration: 160.ms,
              height: 52,
              decoration: BoxDecoration(
                  color: saving ? _C.darkGreen.withOpacity(0.7) : _C.darkGreen,
                  borderRadius: BorderRadius.circular(14)),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                if (saving)
                  const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                else ...[
                  Icon(isNew ? Icons.save_rounded : Icons.check_rounded,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                      isNew
                          ? 'সেভ করুন  ($points pts)'
                          : 'আপডেট করুন  ($points pts)',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14)),
                ],
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED SMALL WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final bool active;
  final Color color;
  const _IconBadge(
      {required this.icon, required this.active, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 180.ms,
      width: 38,
      height: 38,
      decoration: BoxDecoration(
          color: active ? color.withOpacity(0.1) : _C.pageBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: active ? color.withOpacity(0.25) : _C.border, width: 0.5)),
      child: Icon(icon, size: 18, color: active ? color : _C.textHint),
    );
  }
}

class _PtsTag extends StatelessWidget {
  final int pts;
  final int? maxPts;
  final bool active;
  const _PtsTag(
      {required this.pts, required this.maxPts, required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 180.ms,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
          color: active ? _C.greenLight : _C.pageBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: active ? _C.green.withOpacity(0.3) : _C.border,
              width: 0.5)),
      child: Text(active ? '+$pts pts' : '${maxPts ?? pts} pts',
          style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: active ? _C.darkGreen : _C.textHint)),
    );
  }
}

class _CounterPtsTag extends StatelessWidget {
  final int current;
  final int? max;
  final bool active;
  const _CounterPtsTag({required this.current, this.max, required this.active});

  @override
  Widget build(BuildContext context) {
    final label = active
        ? (max != null ? '+$current / $max pts' : '+$current pts')
        : (max != null ? 'max $max pts' : '∞ pts');
    return AnimatedContainer(
      duration: 180.ms,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
          color: active ? _C.greenLight : _C.pageBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: active ? _C.green.withOpacity(0.3) : _C.border,
              width: 0.5)),
      child: Text(label,
          style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: active ? _C.darkGreen : _C.textHint)),
    );
  }
}

class _CounterDisplay extends StatelessWidget {
  final int count;
  final String unit;
  final int? max;
  final bool active;
  const _CounterDisplay(
      {required this.count,
      required this.unit,
      this.max,
      required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 78,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: active ? _C.greenLight : _C.pageBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: active ? _C.green.withOpacity(0.3) : _C.border,
              width: 0.5)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('$count',
            style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                height: 1,
                color: active ? _C.darkGreen : _C.textHint)),
        const SizedBox(height: 3),
        Text(max != null ? '/ $max $unit' : unit,
            style: TextStyle(
                fontSize: 10, color: active ? _C.textSecondary : _C.textHint)),
      ]),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  const _StepBtn(
      {required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
            color: enabled ? _C.greenLight : _C.pageBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: enabled ? _C.green.withOpacity(0.3) : _C.border,
                width: 0.5)),
        child:
            Icon(icon, color: enabled ? _C.darkGreen : _C.textHint, size: 24),
      ),
    );
  }
}

class _WitrDots extends StatelessWidget {
  final int count;
  const _WitrDots({required this.count});

  @override
  Widget build(BuildContext context) {
    const oddValues = [1, 3, 5, 7, 9];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: oddValues.map((val) {
        final filled = count >= val;
        return AnimatedContainer(
          duration: 140.ms,
          width: 36,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
              color: filled ? _C.darkGreen : _C.border,
              borderRadius: BorderRadius.circular(99)),
          child: filled
              ? Center(
                  child: Text('$val',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 6,
                          fontWeight: FontWeight.w800)))
              : null,
        );
      }).toList(),
    );
  }
}

class _BoundedProgress extends StatelessWidget {
  final int count, max;
  const _BoundedProgress({required this.count, required this.max});

  @override
  Widget build(BuildContext context) {
    if (max > 15) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('$count',
                style: const TextStyle(
                    color: _C.darkGreen,
                    fontWeight: FontWeight.w700,
                    fontSize: 11)),
            Text('$max',
                style: const TextStyle(color: _C.textHint, fontSize: 11)),
          ]),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: (count / max).clamp(0.0, 1.0),
              backgroundColor: _C.border,
              valueColor: const AlwaysStoppedAnimation(_C.darkGreen),
              minHeight: 8,
            ),
          ),
        ]),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          max,
          (i) => AnimatedContainer(
                duration: 140.ms,
                width: max <= 7 ? 28 : 22,
                height: 7,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    color: i < count ? _C.darkGreen : _C.border,
                    borderRadius: BorderRadius.circular(99)),
              )),
    );
  }
}

class _UnboundedProgress extends StatelessWidget {
  final int count;
  final String unitBn;
  const _UnboundedProgress({required this.count, required this.unitBn});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.trending_up_rounded,
          color: count > 0 ? _C.darkGreen : _C.textHint, size: 16),
      const SizedBox(width: 6),
      Text(
          count > 0
              ? '$count $unitBn যোগ করা হয়েছে'
              : 'যত বেশি, তত বেশি পয়েন্ট',
          style: TextStyle(
              color: count > 0 ? _C.darkGreen : _C.textHint,
              fontSize: 11,
              fontWeight: FontWeight.w500)),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LOCAL ITEM MODEL
// ─────────────────────────────────────────────────────────────────────────────

class _LocalItem {
  final AmalCategory cat;
  bool completed;
  bool isExempted;
  PrayerMode? prayerMode;
  int count;

  _LocalItem({
    required this.cat,
    required this.completed,
    this.prayerMode,
    this.count = 0,
    this.isExempted = false,
  });

  int get points {
    if (isExempted) return 0;
    switch (_resolveCardType(cat)) {
      case _CardType.fardPrayer:
        if (prayerMode == PrayerMode.congregation)
          return cat.congregationPoints > 0
              ? cat.congregationPoints
              : cat.basePoints;
        if (prayerMode == PrayerMode.solo) return cat.basePoints;
        return 0;
      case _CardType.rakaatCounter:
      case _CardType.genericCounter:
        return (count * cat.effectivePointsPerUnit).round();
      case _CardType.sunnahToggle:
      case _CardType.genericToggle:
        return completed ? cat.basePoints : 0;
    }
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// PATCH NOTES — এই file এ যা fix হয়েছে
// ═════════════════════════════════════════════════════════════════════════════
//
// 1. SUNNAH POINTS FIX
//    _LocalItem.points getter এ sunnahToggle এবং rakaatCounter সঠিক।
//    Backend calculatePoints() তে isPrayer+!isFard → basePoints fix দেওয়া হয়েছে।
//
// 2. APPLICABLE DAYS BLOCK
//    isApplicable == false হলে IgnorePointer দিয়ে touch block করা হয়েছে।
//    Opacity + IgnorePointer একসাথে।
//
// 3. JUMA GENDER LOGIC
//    _SectionForm এ Friday + gender অনুযায়ী zuhr/juma handling।
//    Male Friday: zuhr dim, juma prominent।
//    Female Friday: zuhr normal, juma optional badge।
//    Other days: juma "আজ প্রযোজ্য নয়" dim।
//
// 4. LEADERBOARD SORT
//    completionPercentage → fardPoints → totalPoints → streakDays
//    Backend MonthlyTracker model এ fardPoints field যোগ।
// ═════════════════════════════════════════════════════════════════════════════
