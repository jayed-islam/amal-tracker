// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import '../providers/tracker_provider.dart';
// // import '../models/tracker_model.dart';
// // import '../../../core/theme/app_theme.dart';
// // import '../../../core/constants/app_constants.dart';
// // import '../../../shared/widgets/app_widgets.dart';

// // /// Full-screen scrollable bottom sheet form for entering / editing daily amal
// // class DailyEntrySheet extends ConsumerStatefulWidget {
// //   final String dateStr;
// //   final Map<String, List<AmalCategory>> catsBySection;
// //   final DailyEntryState existingState;
// //   final bool isNew;

// //   const DailyEntrySheet({
// //     super.key,
// //     required this.dateStr,
// //     required this.catsBySection,
// //     required this.existingState,
// //     required this.isNew,
// //   });

// //   @override
// //   ConsumerState<DailyEntrySheet> createState() => _DailyEntrySheetState();
// // }

// // class _DailyEntrySheetState extends ConsumerState<DailyEntrySheet>
// //     with TickerProviderStateMixin {
// //   // Local form state — a flat map of categoryId → entry item
// //   late Map<String, _LocalItem> _localItems;
// //   bool _saving = false;
// //   int _activeSection = 0;

// //   static const _sectionOrder = [
// //     'salat',
// //     'sunnah_nafl',
// //     'dhikr_tilawat',
// //     'daily_habits',
// //     'weekly',
// //     'special_dhulhijja',
// //     'social',
// //   ];

// //   static const _sectionIcons = {
// //     'salat': Icons.mosque_rounded,
// //     'sunnah_nafl': Icons.auto_awesome_rounded,
// //     'dhikr_tilawat': Icons.menu_book_rounded,
// //     'daily_habits': Icons.self_improvement_rounded,
// //     'weekly': Icons.date_range_rounded,
// //     'special_dhulhijja': Icons.star_rounded,
// //     'social': Icons.people_rounded,
// //   };

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initLocalItems();
// //   }

// //   void _initLocalItems() {
// //     _localItems = {};
// //     final existing = widget.existingState.effectiveEntries;

// //     for (final cats in widget.catsBySection.values) {
// //       for (final cat in cats) {
// //         final prev = existing[cat.id];
// //         _localItems[cat.id] = _LocalItem(
// //           categoryId: cat.id,
// //           completed: prev?.completed ?? false,
// //           prayerMode: prev?.prayerMode,
// //           count: prev?.count ?? 0,
// //           basePoints: cat.basePoints,
// //           congPoints: cat.congregationPoints,
// //           isPrayer: cat.isPrayer,
// //           isCount: cat.key == 'first_nine_days_fast',
// //         );
// //       }
// //     }
// //   }

// //   // ── Computed points ────────────────────────────────────────────────────────

// //   int get _totalPoints =>
// //       _localItems.values.fold(0, (sum, item) => sum + item.points);

// //   int get _completedCount =>
// //       _localItems.values.where((i) => i.completed).length;

// //   // ── Update helpers ─────────────────────────────────────────────────────────

// //   void _toggleItem(String id, bool value) {
// //     setState(() {
// //       final item = _localItems[id]!;
// //       item.completed = value;
// //       if (!value) {
// //         item.prayerMode = item.isPrayer ? PrayerMode.missed : null;
// //         item.count = 0;
// //       } else if (item.isPrayer && item.prayerMode == null) {
// //         item.prayerMode = PrayerMode.congregation;
// //       }
// //     });
// //     HapticFeedback.selectionClick();
// //   }

// //   void _setPrayerMode(String id, PrayerMode mode) {
// //     setState(() {
// //       final item = _localItems[id]!;
// //       item.prayerMode = mode;
// //       item.completed = mode != PrayerMode.missed;
// //     });
// //     HapticFeedback.selectionClick();
// //   }

// //   void _setCount(String id, int count) {
// //     setState(() {
// //       final item = _localItems[id]!;
// //       item.count = count.clamp(0, 9);
// //       item.completed = count > 0;
// //     });
// //     HapticFeedback.lightImpact();
// //   }

// //   // ── Save ──────────────────────────────────────────────────────────────────

// //   Future<void> _save() async {
// //     setState(() => _saving = true);

// //     final updates = _localItems.values
// //         .map((item) => EntryUpdate(
// //               categoryId: item.categoryId,
// //               completed: item.completed,
// //               prayerMode: item.prayerMode,
// //               count: item.count,
// //             ))
// //         .toList();

// //     final ok = await ref
// //         .read(dailyEntryProvider(widget.dateStr).notifier)
// //         .saveEntryFromUpdates(updates);

// //     setState(() => _saving = false);

// //     if (ok && mounted) {
// //       Navigator.pop(context);
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //         content: Row(children: [
// //           const Icon(Icons.check_circle_rounded, color: Colors.white),
// //           const SizedBox(width: 10),
// //           Text(widget.isNew
// //               ? 'আমল সফলভাবে সেভ হয়েছে! 🌟'
// //               : 'আমল আপডেট হয়েছে! ✨'),
// //         ]),
// //         backgroundColor: AppColors.success,
// //         margin: const EdgeInsets.all(16),
// //         duration: const Duration(seconds: 2),
// //       ));
// //     } else if (!ok && mounted) {
// //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
// //         content: Row(children: [
// //           Icon(Icons.error_outline_rounded, color: Colors.white),
// //           SizedBox(width: 10),
// //           Text('সেভ করতে সমস্যা হয়েছে। আবার চেষ্টা করুন।'),
// //         ]),
// //         backgroundColor: AppColors.error,
// //         margin: EdgeInsets.all(16),
// //       ));
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final size = MediaQuery.of(context).size;
// //     final isTablet = size.width > 600;

// //     return Container(
// //       height: size.height * 0.96,
// //       decoration: const BoxDecoration(
// //         color: AppColors.background,
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
// //       ),
// //       child: Column(children: [
// //         // ── Drag handle + header ────────────────────────────────────────
// //         _SheetHeader(
// //           isNew: widget.isNew,
// //           dateStr: widget.dateStr,
// //           points: _totalPoints,
// //           completed: _completedCount,
// //           saving: _saving,
// //           onClose: () => Navigator.pop(context),
// //           onSave: _save,
// //         ),

// //         // ── Section tab bar ─────────────────────────────────────────────
// //         _SectionTabBar(
// //           sections: _sectionOrder,
// //           icons: _sectionIcons,
// //           activeIndex: _activeSection,
// //           catsBySection: widget.catsBySection,
// //           localItems: _localItems,
// //           onTap: (i) => setState(() => _activeSection = i),
// //         ),

// //         // ── Form body ───────────────────────────────────────────────────
// //         Expanded(
// //           child: AnimatedSwitcher(
// //             duration: 250.ms,
// //             transitionBuilder: (child, anim) => FadeTransition(
// //               opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
// //               child: child,
// //             ),
// //             child: _SectionForm(
// //               key: ValueKey(_activeSection),
// //               sectionKey: _sectionOrder[_activeSection],
// //               categories:
// //                   widget.catsBySection[_sectionOrder[_activeSection]] ?? [],
// //               localItems: _localItems,
// //               isTablet: isTablet,
// //               onToggle: _toggleItem,
// //               onPrayerMode: _setPrayerMode,
// //               onCount: _setCount,
// //             ),
// //           ),
// //         ),

// //         // ── Save bar ────────────────────────────────────────────────────
// //         _BottomSaveBar(
// //           isNew: widget.isNew,
// //           saving: _saving,
// //           points: _totalPoints,
// //           completed: _completedCount,
// //           onSave: _save,
// //           onCancel: () => Navigator.pop(context),
// //         ),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // Sheet Header
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _SheetHeader extends StatelessWidget {
// //   final bool isNew, saving;
// //   final String dateStr;
// //   final int points, completed;
// //   final VoidCallback onClose, onSave;

// //   const _SheetHeader({
// //     required this.isNew,
// //     required this.saving,
// //     required this.dateStr,
// //     required this.points,
// //     required this.completed,
// //     required this.onClose,
// //     required this.onSave,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     // Parse dateStr for display
// //     final parts = dateStr.split('-');
// //     final d = int.parse(parts[2]);
// //     final m = int.parse(parts[1]);
// //     final y = int.parse(parts[0]);
// //     final month = AppConstants.bengaliMonths[m - 1];

// //     return Container(
// //       decoration: const BoxDecoration(
// //         color: AppColors.surface,
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
// //         border: Border(bottom: BorderSide(color: AppColors.divider)),
// //       ),
// //       padding: const EdgeInsets.fromLTRB(20, 12, 16, 0),
// //       child: Column(children: [
// //         // Drag handle
// //         Center(
// //             child: Container(
// //           width: 44,
// //           height: 4,
// //           margin: const EdgeInsets.only(bottom: 16),
// //           decoration: BoxDecoration(
// //               color: AppColors.border, borderRadius: AppRadius.full),
// //         )),

// //         // Title row
// //         Row(children: [
// //           // Icon
// //           Container(
// //             width: 44,
// //             height: 44,
// //             decoration: BoxDecoration(
// //               gradient: const LinearGradient(
// //                   colors: [AppColors.primaryDark, AppColors.primaryLight]),
// //               borderRadius: AppRadius.md_,
// //               boxShadow: shadowGreen(),
// //             ),
// //             child: Icon(isNew ? Icons.add_rounded : Icons.edit_rounded,
// //                 color: Colors.white, size: 22),
// //           ),
// //           const SizedBox(width: 12),

// //           Expanded(
// //               child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                 Text(isNew ? 'আমল যোগ করুন' : 'আমল সম্পাদনা করুন',
// //                     style: Theme.of(context)
// //                         .textTheme
// //                         .titleLarge!
// //                         .copyWith(fontWeight: FontWeight.w800)),
// //                 Text('$d $month $y',
// //                     style: Theme.of(context)
// //                         .textTheme
// //                         .bodySmall!
// //                         .copyWith(color: AppColors.textSecondary)),
// //               ])),

// //           // Close button
// //           GestureDetector(
// //             onTap: onClose,
// //             child: Container(
// //               width: 36,
// //               height: 36,
// //               decoration: BoxDecoration(
// //                 color: AppColors.surfaceAlt,
// //                 borderRadius: AppRadius.full,
// //               ),
// //               child: const Icon(Icons.close_rounded,
// //                   color: AppColors.textSecondary, size: 20),
// //             ),
// //           ),
// //         ]),

// //         const SizedBox(height: 14),

// //         // Live points bar
// //         Container(
// //           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
// //           decoration: BoxDecoration(
// //             gradient: const LinearGradient(
// //               colors: [AppColors.primaryDark, AppColors.primaryLight],
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //             ),
// //             borderRadius: AppRadius.md_,
// //           ),
// //           child: Row(children: [
// //             const Icon(Icons.stars_rounded, color: AppColors.gold, size: 18),
// //             const SizedBox(width: 8),
// //             Text('লাইভ পয়েন্ট:',
// //                 style: const TextStyle(color: Colors.white70, fontSize: 13)),
// //             const SizedBox(width: 6),
// //             Text('$points',
// //                 style: const TextStyle(
// //                     color: Colors.white,
// //                     fontWeight: FontWeight.w900,
// //                     fontSize: 20,
// //                     height: 1)),
// //             const Text(' pts',
// //                 style: TextStyle(color: Colors.white70, fontSize: 12)),
// //             const Spacer(),
// //             Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //               decoration: BoxDecoration(
// //                 color: Colors.white.withOpacity(0.15),
// //                 borderRadius: AppRadius.full,
// //               ),
// //               child: Text('$completed টি সম্পন্ন',
// //                   style: const TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 12,
// //                       fontWeight: FontWeight.w600)),
// //             ),
// //           ]),
// //         ),
// //         const SizedBox(height: 12),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // Section Tab Bar (horizontal pill tabs)
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _SectionTabBar extends StatelessWidget {
// //   final List<String> sections;
// //   final Map<String, IconData> icons;
// //   final int activeIndex;
// //   final Map<String, List<AmalCategory>> catsBySection;
// //   final Map<String, _LocalItem> localItems;
// //   final ValueChanged<int> onTap;

// //   const _SectionTabBar({
// //     required this.sections,
// //     required this.icons,
// //     required this.activeIndex,
// //     required this.catsBySection,
// //     required this.localItems,
// //     required this.onTap,
// //   });

// //   int _completedInSection(String sec) {
// //     final cats = catsBySection[sec] ?? [];
// //     return cats.where((c) => localItems[c.id]?.completed == true).length;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: AppColors.surface,
// //       padding: const EdgeInsets.symmetric(vertical: 10),
// //       child: SingleChildScrollView(
// //         scrollDirection: Axis.horizontal,
// //         padding: const EdgeInsets.symmetric(horizontal: 12),
// //         child: Row(
// //           children: sections.asMap().entries.map((e) {
// //             final i = e.key;
// //             final sec = e.value;
// //             final label = AppConstants.sectionLabels[sec]?['bn'] ?? sec;
// //             final icon = icons[sec] ?? Icons.circle;
// //             final done = _completedInSection(sec);
// //             final total = (catsBySection[sec] ?? []).length;
// //             final isActive = i == activeIndex;

// //             return GestureDetector(
// //               onTap: () => onTap(i),
// //               child: AnimatedContainer(
// //                 duration: 200.ms,
// //                 margin: const EdgeInsets.only(right: 8),
// //                 padding:
// //                     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //                 decoration: BoxDecoration(
// //                   gradient: isActive
// //                       ? const LinearGradient(colors: [
// //                           AppColors.primaryDark,
// //                           AppColors.primaryLight
// //                         ])
// //                       : null,
// //                   color: isActive ? null : AppColors.surfaceAlt,
// //                   borderRadius: AppRadius.full,
// //                   border: Border.all(
// //                     color: isActive ? Colors.transparent : AppColors.border,
// //                     width: 1,
// //                   ),
// //                   boxShadow: isActive ? shadowGreen() : [],
// //                 ),
// //                 child: Row(mainAxisSize: MainAxisSize.min, children: [
// //                   Icon(icon,
// //                       size: 13,
// //                       color: isActive ? Colors.white : AppColors.textSecondary),
// //                   const SizedBox(width: 5),
// //                   Text(label,
// //                       style: TextStyle(
// //                         fontSize: 12,
// //                         fontWeight:
// //                             isActive ? FontWeight.w700 : FontWeight.w500,
// //                         color:
// //                             isActive ? Colors.white : AppColors.textSecondary,
// //                       )),
// //                   if (done > 0) ...[
// //                     const SizedBox(width: 6),
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 6, vertical: 2),
// //                       decoration: BoxDecoration(
// //                         color: isActive
// //                             ? Colors.white.withOpacity(0.25)
// //                             : AppColors.primaryPale,
// //                         borderRadius: AppRadius.full,
// //                       ),
// //                       child: Text('$done/$total',
// //                           style: TextStyle(
// //                             fontSize: 10,
// //                             fontWeight: FontWeight.w700,
// //                             color: isActive ? Colors.white : AppColors.primary,
// //                           )),
// //                     ),
// //                   ],
// //                 ]),
// //               ),
// //             );
// //           }).toList(),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // Section Form
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _SectionForm extends StatelessWidget {
// //   final String sectionKey;
// //   final List<AmalCategory> categories;
// //   final Map<String, _LocalItem> localItems;
// //   final bool isTablet;
// //   final void Function(String, bool) onToggle;
// //   final void Function(String, PrayerMode) onPrayerMode;
// //   final void Function(String, int) onCount;

// //   const _SectionForm({
// //     super.key,
// //     required this.sectionKey,
// //     required this.categories,
// //     required this.localItems,
// //     required this.isTablet,
// //     required this.onToggle,
// //     required this.onPrayerMode,
// //     required this.onCount,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     if (categories.isEmpty) {
// //       return const Center(
// //           child: Text('এই বিভাগে কোনো আমল নেই',
// //               style: TextStyle(color: AppColors.textSecondary)));
// //     }

// //     return ListView.separated(
// //       padding: EdgeInsets.symmetric(
// //         horizontal:
// //             isTablet ? (MediaQuery.of(context).size.width - 600) / 2 + 16 : 16,
// //         vertical: 16,
// //       ),
// //       itemCount: categories.length,
// //       separatorBuilder: (_, __) => const SizedBox(height: 10),
// //       itemBuilder: (ctx, i) {
// //         final cat = categories[i];
// //         final item = localItems[cat.id];

// //         Widget card;
// //         if (cat.isPrayer) {
// //           card = _PrayerFormCard(
// //             cat: cat,
// //             item: item,
// //             onMode: (mode) => onPrayerMode(cat.id, mode),
// //           );
// //         } else if (item?.isCount == true) {
// //           card = _CountFormCard(
// //             cat: cat,
// //             item: item,
// //             onCount: (c) => onCount(cat.id, c),
// //           );
// //         } else {
// //           card = _ToggleFormCard(
// //             cat: cat,
// //             item: item,
// //             onToggle: (v) => onToggle(cat.id, v),
// //           );
// //         }

// //         return card
// //             .animate(delay: (i * 35).ms)
// //             .fadeIn(duration: 260.ms)
// //             .slideX(begin: 0.06, curve: Curves.easeOut);
// //       },
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // Prayer Form Card — congregation / solo / missed selector
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _PrayerFormCard extends StatelessWidget {
// //   final AmalCategory cat;
// //   final _LocalItem? item;
// //   final ValueChanged<PrayerMode> onMode;

// //   const _PrayerFormCard({required this.cat, this.item, required this.onMode});

// //   @override
// //   Widget build(BuildContext context) {
// //     final mode = item?.prayerMode ?? PrayerMode.missed;
// //     final pts = item?.points ?? 0;

// //     return Container(
// //       decoration: BoxDecoration(
// //         color: AppColors.surface,
// //         borderRadius: AppRadius.lg_,
// //         border: Border.all(
// //           color: mode == PrayerMode.missed
// //               ? AppColors.border
// //               : AppColors.primary.withOpacity(0.4),
// //           width: mode == PrayerMode.missed ? 1 : 1.5,
// //         ),
// //         boxShadow: mode != PrayerMode.missed ? shadowSm() : [],
// //       ),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         // Card header
// //         Padding(
// //           padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
// //           child: Row(children: [
// //             _AmalIcon(
// //               icon: Icons.mosque_rounded,
// //               active: mode != PrayerMode.missed,
// //             ),
// //             const SizedBox(width: 12),
// //             Expanded(
// //                 child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                   Text(cat.nameBn,
// //                       style: Theme.of(context)
// //                           .textTheme
// //                           .titleSmall!
// //                           .copyWith(fontWeight: FontWeight.w700)),
// //                   Text(cat.nameEn,
// //                       style: Theme.of(context)
// //                           .textTheme
// //                           .bodySmall!
// //                           .copyWith(color: AppColors.textSecondary)),
// //                 ])),
// //             _PtsTag(pts: pts, maxPts: cat.congregationPoints, active: pts > 0),
// //           ]),
// //         ),

// //         const Divider(
// //             height: 1, color: AppColors.divider, indent: 14, endIndent: 14),
// //         const SizedBox(height: 10),

// //         // Mode buttons row
// //         Padding(
// //           padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
// //           child: Row(children: [
// //             Expanded(
// //                 child: _ModeBtn(
// //               label: 'জামাতে',
// //               subLabel: '${cat.congregationPoints} পয়েন্ট',
// //               icon: Icons.people_rounded,
// //               emoji: '✔',
// //               isSelected: mode == PrayerMode.congregation,
// //               activeColor: AppColors.congregation,
// //               onTap: () => onMode(PrayerMode.congregation),
// //             )),
// //             const SizedBox(width: 8),
// //             Expanded(
// //                 child: _ModeBtn(
// //               label: 'একাকী',
// //               subLabel: '${cat.basePoints} পয়েন্ট',
// //               icon: Icons.person_rounded,
// //               emoji: '/',
// //               isSelected: mode == PrayerMode.solo,
// //               activeColor: AppColors.solo,
// //               onTap: () => onMode(PrayerMode.solo),
// //             )),
// //             const SizedBox(width: 8),
// //             Expanded(
// //                 child: _ModeBtn(
// //               label: 'মিস',
// //               subLabel: '০ পয়েন্ট',
// //               icon: Icons.close_rounded,
// //               emoji: '✗',
// //               isSelected: mode == PrayerMode.missed,
// //               activeColor: AppColors.textTertiary,
// //               onTap: () => onMode(PrayerMode.missed),
// //             )),
// //           ]),
// //         ),
// //       ]),
// //     );
// //   }
// // }

// // class _ModeBtn extends StatelessWidget {
// //   final String label, subLabel, emoji;
// //   final IconData icon;
// //   final bool isSelected;
// //   final Color activeColor;
// //   final VoidCallback onTap;

// //   const _ModeBtn({
// //     required this.label,
// //     required this.subLabel,
// //     required this.emoji,
// //     required this.icon,
// //     required this.isSelected,
// //     required this.activeColor,
// //     required this.onTap,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: AnimatedContainer(
// //         duration: 180.ms,
// //         padding: const EdgeInsets.symmetric(vertical: 12),
// //         decoration: BoxDecoration(
// //           color:
// //               isSelected ? activeColor.withOpacity(0.1) : AppColors.surfaceAlt,
// //           borderRadius: AppRadius.sm_,
// //           border: Border.all(
// //             color: isSelected ? activeColor : AppColors.border,
// //             width: isSelected ? 2 : 1,
// //           ),
// //           boxShadow: isSelected
// //               ? [
// //                   BoxShadow(
// //                       color: activeColor.withOpacity(0.18),
// //                       blurRadius: 8,
// //                       offset: const Offset(0, 3)),
// //                 ]
// //               : [],
// //         ),
// //         child: Column(mainAxisSize: MainAxisSize.min, children: [
// //           Text(emoji,
// //               style: TextStyle(
// //                   fontSize: 16,
// //                   color: isSelected ? activeColor : AppColors.textTertiary,
// //                   fontWeight: FontWeight.w700)),
// //           const SizedBox(height: 3),
// //           Text(label,
// //               style: TextStyle(
// //                   fontSize: 12,
// //                   fontWeight: FontWeight.w700,
// //                   color: isSelected ? activeColor : AppColors.textSecondary)),
// //           Text(subLabel,
// //               style: TextStyle(
// //                   fontSize: 10,
// //                   color: isSelected
// //                       ? activeColor.withOpacity(0.75)
// //                       : AppColors.textTertiary)),
// //         ]),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // Toggle Form Card — simple yes/no checkbox
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _ToggleFormCard extends StatelessWidget {
// //   final AmalCategory cat;
// //   final _LocalItem? item;
// //   final ValueChanged<bool> onToggle;

// //   const _ToggleFormCard({required this.cat, this.item, required this.onToggle});

// //   @override
// //   Widget build(BuildContext context) {
// //     final done = item?.completed ?? false;
// //     final pts = item?.points ?? 0;

// //     return GestureDetector(
// //       onTap: () => onToggle(!done),
// //       child: AnimatedContainer(
// //         duration: 180.ms,
// //         padding: const EdgeInsets.all(14),
// //         decoration: BoxDecoration(
// //           color: done ? AppColors.primaryPale : AppColors.surface,
// //           borderRadius: AppRadius.lg_,
// //           border: Border.all(
// //             color:
// //                 done ? AppColors.primary.withOpacity(0.45) : AppColors.border,
// //             width: done ? 1.5 : 1,
// //           ),
// //           boxShadow: done ? shadowSm() : [],
// //         ),
// //         child: Row(children: [
// //           // Big tap-friendly checkbox
// //           AnimatedContainer(
// //             duration: 200.ms,
// //             width: 32,
// //             height: 32,
// //             decoration: BoxDecoration(
// //               color: done ? AppColors.primary : Colors.transparent,
// //               borderRadius: AppRadius.xs_,
// //               border: Border.all(
// //                   color: done ? AppColors.primary : AppColors.border, width: 2),
// //               boxShadow: done ? shadowGreen() : [],
// //             ),
// //             child: done
// //                 ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
// //                 : null,
// //           ),
// //           const SizedBox(width: 14),

// //           Expanded(
// //               child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                 Text(cat.nameBn,
// //                     style: Theme.of(context).textTheme.bodyMedium!.copyWith(
// //                           fontWeight: FontWeight.w600,
// //                           color: done
// //                               ? AppColors.primaryDark
// //                               : AppColors.textPrimary,
// //                         )),
// //                 if (cat.description != null)
// //                   Padding(
// //                     padding: const EdgeInsets.only(top: 2),
// //                     child: Text(cat.description!,
// //                         style: Theme.of(context)
// //                             .textTheme
// //                             .bodySmall!
// //                             .copyWith(color: AppColors.textSecondary)),
// //                   ),
// //               ])),

// //           const SizedBox(width: 8),
// //           _PtsTag(pts: pts, maxPts: cat.basePoints, active: done),
// //         ]),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // Count Form Card — numeric stepper (e.g. "first 9 days fasting")
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _CountFormCard extends StatelessWidget {
// //   final AmalCategory cat;
// //   final _LocalItem? item;
// //   final ValueChanged<int> onCount;

// //   const _CountFormCard({required this.cat, this.item, required this.onCount});

// //   @override
// //   Widget build(BuildContext context) {
// //     final count = item?.count ?? 0;
// //     final pts = item?.points ?? 0;

// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: AppColors.surface,
// //         borderRadius: AppRadius.lg_,
// //         border: Border.all(
// //           color:
// //               count > 0 ? AppColors.primary.withOpacity(0.4) : AppColors.border,
// //           width: count > 0 ? 1.5 : 1,
// //         ),
// //         boxShadow: count > 0 ? shadowSm() : [],
// //       ),
// //       child: Column(children: [
// //         Row(children: [
// //           _AmalIcon(icon: Icons.calendar_month_rounded, active: count > 0),
// //           const SizedBox(width: 12),
// //           Expanded(
// //               child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                 Text(cat.nameBn,
// //                     style: Theme.of(context)
// //                         .textTheme
// //                         .titleSmall!
// //                         .copyWith(fontWeight: FontWeight.w700)),
// //                 if (cat.description != null)
// //                   Text(cat.description!,
// //                       style: Theme.of(context)
// //                           .textTheme
// //                           .bodySmall!
// //                           .copyWith(color: AppColors.textSecondary)),
// //               ])),
// //           _PtsTag(pts: pts, maxPts: cat.basePoints * 9, active: count > 0),
// //         ]),

// //         const SizedBox(height: 16),
// //         const Divider(height: 1, color: AppColors.divider),
// //         const SizedBox(height: 14),

// //         // Stepper
// //         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
// //           _StepBtn(
// //             icon: Icons.remove_rounded,
// //             onTap: count > 0 ? () => onCount(count - 1) : null,
// //           ),
// //           Container(
// //             width: 80,
// //             height: 64,
// //             margin: const EdgeInsets.symmetric(horizontal: 16),
// //             decoration: BoxDecoration(
// //               color: count > 0 ? AppColors.primaryPale : AppColors.surfaceAlt,
// //               borderRadius: AppRadius.md_,
// //               border: Border.all(
// //                   color: count > 0 ? AppColors.primarySoft : AppColors.border),
// //             ),
// //             child:
// //                 Column(mainAxisAlignment: MainAxisAlignment.center, children: [
// //               Text('$count',
// //                   style: TextStyle(
// //                     fontSize: 30,
// //                     fontWeight: FontWeight.w900,
// //                     height: 1,
// //                     color:
// //                         count > 0 ? AppColors.primary : AppColors.textTertiary,
// //                   )),
// //               Text('/ ৯ দিন',
// //                   style: TextStyle(
// //                     fontSize: 11,
// //                     color: count > 0
// //                         ? AppColors.primaryLight
// //                         : AppColors.textTertiary,
// //                   )),
// //             ]),
// //           ),
// //           _StepBtn(
// //             icon: Icons.add_rounded,
// //             onTap: count < 9 ? () => onCount(count + 1) : null,
// //           ),
// //         ]),

// //         const SizedBox(height: 12),

// //         // Dot progress indicator
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: List.generate(
// //               9,
// //               (i) => AnimatedContainer(
// //                     duration: 150.ms,
// //                     width: 24,
// //                     height: 8,
// //                     margin: const EdgeInsets.symmetric(horizontal: 2),
// //                     decoration: BoxDecoration(
// //                       color: i < count ? AppColors.primary : AppColors.divider,
// //                       borderRadius: AppRadius.full,
// //                     ),
// //                   )),
// //         ),
// //       ]),
// //     );
// //   }
// // }

// // class _StepBtn extends StatelessWidget {
// //   final IconData icon;
// //   final VoidCallback? onTap;
// //   const _StepBtn({required this.icon, this.onTap});

// //   @override
// //   Widget build(BuildContext context) => GestureDetector(
// //         onTap: onTap,
// //         child: Container(
// //           width: 48,
// //           height: 48,
// //           decoration: BoxDecoration(
// //             color: onTap != null ? AppColors.primarySoft : AppColors.divider,
// //             borderRadius: AppRadius.md_,
// //           ),
// //           child: Icon(icon,
// //               color: onTap != null ? AppColors.primary : AppColors.textTertiary,
// //               size: 24),
// //         ),
// //       );
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // Bottom Save Bar
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _BottomSaveBar extends StatelessWidget {
// //   final bool isNew, saving;
// //   final int points, completed;
// //   final VoidCallback onSave, onCancel;

// //   const _BottomSaveBar({
// //     required this.isNew,
// //     required this.saving,
// //     required this.points,
// //     required this.completed,
// //     required this.onSave,
// //     required this.onCancel,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: EdgeInsets.fromLTRB(
// //           16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
// //       decoration: const BoxDecoration(
// //         color: AppColors.surface,
// //         border: Border(top: BorderSide(color: AppColors.divider)),
// //       ),
// //       child: Row(children: [
// //         // Cancel
// //         GestureDetector(
// //           onTap: onCancel,
// //           child: Container(
// //             width: 52,
// //             height: 54,
// //             decoration: BoxDecoration(
// //               color: AppColors.surfaceAlt,
// //               borderRadius: AppRadius.md_,
// //               border: Border.all(color: AppColors.border),
// //             ),
// //             child: const Icon(Icons.close_rounded,
// //                 color: AppColors.textSecondary, size: 22),
// //           ),
// //         ),
// //         const SizedBox(width: 12),

// //         // Save button
// //         Expanded(
// //           child: AppButton(
// //             onPressed: saving ? null : onSave,
// //             isLoading: saving,
// //             label:
// //                 isNew ? 'সেভ করুন  ($points pts)' : 'আপডেট করুন  ($points pts)',
// //             icon: saving
// //                 ? null
// //                 : (isNew ? Icons.save_rounded : Icons.check_rounded),
// //             height: 54,
// //           ),
// //         ),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // Shared small widgets inside sheet
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _AmalIcon extends StatelessWidget {
// //   final IconData icon;
// //   final bool active;
// //   const _AmalIcon({required this.icon, required this.active});

// //   @override
// //   Widget build(BuildContext context) => AnimatedContainer(
// //         duration: 200.ms,
// //         width: 40,
// //         height: 40,
// //         decoration: BoxDecoration(
// //           color: active ? AppColors.primaryPale : AppColors.surfaceAlt,
// //           borderRadius: AppRadius.sm_,
// //         ),
// //         child: Icon(icon,
// //             size: 20,
// //             color: active ? AppColors.primary : AppColors.textTertiary),
// //       );
// // }

// // class _PtsTag extends StatelessWidget {
// //   final int pts, maxPts;
// //   final bool active;
// //   const _PtsTag(
// //       {required this.pts, required this.maxPts, required this.active});

// //   @override
// //   Widget build(BuildContext context) => AnimatedContainer(
// //         duration: 200.ms,
// //         padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
// //         decoration: BoxDecoration(
// //           color: active
// //               ? AppColors.primary.withOpacity(0.1)
// //               : AppColors.surfaceAlt,
// //           borderRadius: AppRadius.full,
// //           border: Border.all(
// //               color: active
// //                   ? AppColors.primary.withOpacity(0.3)
// //                   : AppColors.border),
// //         ),
// //         child: Text(
// //           active ? '+$pts pts' : '$maxPts pts',
// //           style: TextStyle(
// //             fontSize: 11,
// //             fontWeight: FontWeight.w700,
// //             color: active ? AppColors.primary : AppColors.textTertiary,
// //           ),
// //         ),
// //       );
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // Local item model (in-memory form state)
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _LocalItem {
// //   final String categoryId;
// //   final int basePoints, congPoints;
// //   final bool isPrayer, isCount;
// //   bool completed;
// //   PrayerMode? prayerMode;
// //   int count;

// //   _LocalItem({
// //     required this.categoryId,
// //     required this.basePoints,
// //     required this.congPoints,
// //     required this.isPrayer,
// //     required this.isCount,
// //     required this.completed,
// //     this.prayerMode,
// //     this.count = 0,
// //   });

// //   int get points {
// //     if (!completed) return 0;
// //     if (isPrayer) {
// //       if (prayerMode == PrayerMode.congregation) return congPoints;
// //       if (prayerMode == PrayerMode.solo) return basePoints;
// //       return 0;
// //     }
// //     if (isCount) return count * basePoints;
// //     return basePoints;
// //   }
// // }
// // import 'package:amal_tracker/features/auth/providers/provider_reset.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import '../providers/tracker_provider.dart';
// // import '../models/tracker_model.dart';
// // import '../../../core/constants/app_constants.dart';

// // // ─────────────────────────────────────────────────────────────────────────────
// // // DESIGN TOKENS — identical to tracker/leaderboard/monthly screens
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _C {
// //   static const pageBg = Color(0xFFF4F6F1);
// //   static const cardBg = Color(0xFFFFFFFF);
// //   static const darkGreen = Color(0xFF0E3D22);
// //   static const midGreen = Color(0xFF1B7045);
// //   static const gold = Color(0xFFD4A843);
// //   static const goldLight = Color(0xFFFFF3E0);
// //   static const green = Color(0xFF16A34A);
// //   static const greenLight = Color(0xFFE8F5EE);
// //   static const amber = Color(0xFFFF6B35);
// //   static const amberLight = Color(0xFFFFF3E0);
// //   static const purple = Color(0xFF7C3AED);
// //   static const purpleLight = Color(0xFFEDE9FE);
// //   static const red = Color(0xFFEF4444);
// //   static const redLight = Color(0xFFFEE2E2);
// //   static const blue = Color(0xFF0891B2);
// //   static const blueLight = Color(0xFFE0F2FE);
// //   static const textPrimary = Color(0xFF0A1A0F);
// //   static const textSecondary = Color(0xFF6B7C6E);
// //   static const textHint = Color(0xFFABBAAE);
// //   static const border = Color(0xFFE4EAE4);
// //   static const borderMid = Color(0xFFD0DAD2);
// //   static const success = Color(0xFF16A34A);
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SHEET ROOT
// // // ─────────────────────────────────────────────────────────────────────────────

// // class DailyEntrySheet extends ConsumerStatefulWidget {
// //   final String dateStr;
// //   final Map<String, List<AmalCategory>> catsBySection;
// //   final DailyEntryState existingState;
// //   final bool isNew;

// //   const DailyEntrySheet({
// //     super.key,
// //     required this.dateStr,
// //     required this.catsBySection,
// //     required this.existingState,
// //     required this.isNew,
// //   });

// //   @override
// //   ConsumerState<DailyEntrySheet> createState() => _DailyEntrySheetState();
// // }

// // class _DailyEntrySheetState extends ConsumerState<DailyEntrySheet> {
// //   late Map<String, _LocalItem> _localItems;
// //   bool _saving = false;
// //   int _activeSection = 0;

// //   static const _sectionOrder = [
// //     'salat',
// //     'sunnah_nafl',
// //     'dhikr_tilawat',
// //     'daily_habits',
// //     'weekly',
// //     'special_dhulhijja',
// //     'social',
// //   ];

// //   static const _sectionIcons = {
// //     'salat': Icons.mosque_rounded,
// //     'sunnah_nafl': Icons.auto_awesome_rounded,
// //     'dhikr_tilawat': Icons.menu_book_rounded,
// //     'daily_habits': Icons.self_improvement_rounded,
// //     'weekly': Icons.date_range_rounded,
// //     'special_dhulhijja': Icons.star_rounded,
// //     'social': Icons.people_rounded,
// //   };

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initLocalItems();
// //   }

// //   void _initLocalItems() {
// //     _localItems = {};
// //     final existing = widget.existingState.effectiveEntries;
// //     for (final cats in widget.catsBySection.values) {
// //       for (final cat in cats) {
// //         final prev = existing[cat.id];
// //         _localItems[cat.id] = _LocalItem(
// //           categoryId: cat.id,
// //           completed: prev?.completed ?? false,
// //           prayerMode: prev?.prayerMode,
// //           count: prev?.count ?? 0,
// //           basePoints: cat.basePoints,
// //           congPoints: cat.congregationPoints,
// //           isPrayer: cat.isPrayer,
// //           isCount: cat.key == 'first_nine_days_fast',
// //         );
// //       }
// //     }
// //   }

// //   int get _totalPoints => _localItems.values.fold(0, (s, i) => s + i.points);

// //   int get _completedCount =>
// //       _localItems.values.where((i) => i.completed).length;

// //   void _toggleItem(String id, bool value) {
// //     setState(() {
// //       final item = _localItems[id]!;
// //       item.completed = value;
// //       if (!value) {
// //         item.prayerMode = item.isPrayer ? PrayerMode.missed : null;
// //         item.count = 0;
// //       } else if (item.isPrayer && item.prayerMode == null) {
// //         item.prayerMode = PrayerMode.congregation;
// //       }
// //     });
// //     HapticFeedback.selectionClick();
// //   }

// //   void _setPrayerMode(String id, PrayerMode mode) {
// //     setState(() {
// //       final item = _localItems[id]!;
// //       item.prayerMode = mode;
// //       item.completed = mode != PrayerMode.missed;
// //     });
// //     HapticFeedback.selectionClick();
// //   }

// //   void _setCount(String id, int count) {
// //     setState(() {
// //       final item = _localItems[id]!;
// //       item.count = count.clamp(0, 9);
// //       item.completed = count > 0;
// //     });
// //     HapticFeedback.lightImpact();
// //   }

// //   Future<void> _save() async {
// //     setState(() => _saving = true);
// //     final updates = _localItems.values
// //         .map((item) => EntryUpdate(
// //               categoryId: item.categoryId,
// //               completed: item.completed,
// //               prayerMode: item.prayerMode,
// //               count: item.count,
// //             ))
// //         .toList();

// //     final ok = await ref
// //         .read(dailyEntryProvider(widget.dateStr).notifier)
// //         .saveEntryFromUpdates(updates);

// //     if (ok && mounted) {
// //       // Parse the date
// //       final parts = widget.dateStr.split('-');
// //       final year = int.parse(parts[0]);
// //       final month = int.parse(parts[1]);

// //       // Use the targeted refresh function
// //       refreshAfterEntryUpdate(
// //         ref,
// //         year: year,
// //         month: month,
// //         specificDateStr: widget.dateStr,
// //       );
// //     }

// //     setState(() => _saving = false);

// //     if (!mounted) return;
// //     Navigator.pop(context);

// //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //       content: Row(children: [
// //         Icon(
// //           ok ? Icons.check_circle_rounded : Icons.error_outline_rounded,
// //           color: Colors.white,
// //         ),
// //         const SizedBox(width: 10),
// //         Text(ok
// //             ? (widget.isNew
// //                 ? 'আমল সফলভাবে সেভ হয়েছে! 🌟'
// //                 : 'আমল আপডেট হয়েছে! ✨')
// //             : 'সেভ করতে সমস্যা হয়েছে। আবার চেষ্টা করুন।'),
// //       ]),
// //       backgroundColor: ok ? _C.success : _C.red,
// //       margin: const EdgeInsets.all(16),
// //       behavior: SnackBarBehavior.floating,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       duration: const Duration(seconds: 2),
// //     ));
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final size = MediaQuery.of(context).size;
// //     final isTablet = size.width > 600;

// //     return Container(
// //       height: size.height * 0.96,
// //       decoration: const BoxDecoration(
// //         color: _C.pageBg,
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
// //       ),
// //       child: Column(children: [
// //         // ── Sheet header ──────────────────────────────────────────────
// //         _SheetHeader(
// //           isNew: widget.isNew,
// //           dateStr: widget.dateStr,
// //           points: _totalPoints,
// //           completed: _completedCount,
// //           saving: _saving,
// //           onClose: () => Navigator.pop(context),
// //           onSave: _save,
// //         ),

// //         // ── Section tab bar ───────────────────────────────────────────
// //         _SectionTabBar(
// //           sections: _sectionOrder,
// //           icons: _sectionIcons,
// //           activeIndex: _activeSection,
// //           catsBySection: widget.catsBySection,
// //           localItems: _localItems,
// //           onTap: (i) => setState(() => _activeSection = i),
// //         ),

// //         // ── Form body ─────────────────────────────────────────────────
// //         Expanded(
// //           child: AnimatedSwitcher(
// //             duration: 220.ms,
// //             transitionBuilder: (child, anim) => FadeTransition(
// //               opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
// //               child: child,
// //             ),
// //             child: _SectionForm(
// //               key: ValueKey(_activeSection),
// //               sectionKey: _sectionOrder[_activeSection],
// //               categories:
// //                   widget.catsBySection[_sectionOrder[_activeSection]] ?? [],
// //               localItems: _localItems,
// //               isTablet: isTablet,
// //               onToggle: _toggleItem,
// //               onPrayerMode: _setPrayerMode,
// //               onCount: _setCount,
// //             ),
// //           ),
// //         ),

// //         // ── Bottom save bar ───────────────────────────────────────────
// //         _BottomSaveBar(
// //           isNew: widget.isNew,
// //           saving: _saving,
// //           points: _totalPoints,
// //           completed: _completedCount,
// //           onSave: _save,
// //           onCancel: () => Navigator.pop(context),
// //         ),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SHEET HEADER
// // // dark-green band — same language as SliverAppBar across all screens
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _SheetHeader extends StatelessWidget {
// //   final bool isNew, saving;
// //   final String dateStr;
// //   final int points, completed;
// //   final VoidCallback onClose, onSave;

// //   const _SheetHeader({
// //     required this.isNew,
// //     required this.saving,
// //     required this.dateStr,
// //     required this.points,
// //     required this.completed,
// //     required this.onClose,
// //     required this.onSave,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final parts = dateStr.split('-');
// //     final d = int.parse(parts[2]);
// //     final m = int.parse(parts[1]);
// //     final y = int.parse(parts[0]);
// //     final month = AppConstants.bengaliMonths[m - 1];

// //     return Container(
// //       decoration: const BoxDecoration(
// //         color: _C.darkGreen,
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
// //       ),
// //       child: Stack(
// //         children: [
// //           // Decorative circles — same as hero bands
// //           Positioned(
// //             top: -30,
// //             right: -30,
// //             child: Container(
// //               width: 100,
// //               height: 100,
// //               decoration: BoxDecoration(
// //                 shape: BoxShape.circle,
// //                 color: Colors.white.withOpacity(0.04),
// //               ),
// //             ),
// //           ),
// //           Positioned(
// //             bottom: 0,
// //             left: 10,
// //             child: Container(
// //               width: 60,
// //               height: 60,
// //               decoration: BoxDecoration(
// //                 shape: BoxShape.circle,
// //                 color: Colors.white.withOpacity(0.03),
// //               ),
// //             ),
// //           ),

// //           Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               // Drag handle
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 12, bottom: 4),
// //                 child: Center(
// //                   child: Container(
// //                     width: 40,
// //                     height: 4,
// //                     decoration: BoxDecoration(
// //                       color: Colors.white.withOpacity(0.25),
// //                       borderRadius: BorderRadius.circular(99),
// //                     ),
// //                   ),
// //                 ),
// //               ),

// //               // Title row
// //               Padding(
// //                 padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
// //                 child: Row(children: [
// //                   // Icon badge
// //                   Container(
// //                     width: 38,
// //                     height: 38,
// //                     decoration: BoxDecoration(
// //                       color: Colors.white.withOpacity(0.12),
// //                       borderRadius: BorderRadius.circular(11),
// //                       border: Border.all(
// //                         color: Colors.white.withOpacity(0.18),
// //                         width: 0.5,
// //                       ),
// //                     ),
// //                     child: Icon(
// //                       isNew ? Icons.add_rounded : Icons.edit_rounded,
// //                       color: Colors.white,
// //                       size: 18,
// //                     ),
// //                   ),
// //                   const SizedBox(width: 10),

// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(
// //                           isNew ? 'আমল যোগ করুন' : 'আমল সম্পাদনা করুন',
// //                           style: const TextStyle(
// //                             color: Colors.white,
// //                             fontWeight: FontWeight.w800,
// //                             fontSize: 16,
// //                             letterSpacing: -0.3,
// //                           ),
// //                         ),
// //                         Text(
// //                           '$d $month $y',
// //                           style: TextStyle(
// //                             color: Colors.white.withOpacity(0.5),
// //                             fontSize: 11,
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),

// //                   // Close button
// //                   GestureDetector(
// //                     onTap: onClose,
// //                     child: Container(
// //                       width: 34,
// //                       height: 34,
// //                       decoration: BoxDecoration(
// //                         color: Colors.white.withOpacity(0.1),
// //                         borderRadius: BorderRadius.circular(10),
// //                         border: Border.all(
// //                           color: Colors.white.withOpacity(0.15),
// //                           width: 0.5,
// //                         ),
// //                       ),
// //                       child: Icon(
// //                         Icons.close_rounded,
// //                         color: Colors.white.withOpacity(0.7),
// //                         size: 18,
// //                       ),
// //                     ),
// //                   ),
// //                 ]),
// //               ),

// //               const SizedBox(height: 12),

// //               // Live points card — same style as rank/progress cards in hero bands
// //               Padding(
// //                 padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
// //                 child: Container(
// //                   padding: const EdgeInsets.all(13),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white.withOpacity(0.09),
// //                     borderRadius: BorderRadius.circular(14),
// //                     border: Border.all(
// //                       color: Colors.white.withOpacity(0.18),
// //                       width: 0.5,
// //                     ),
// //                   ),
// //                   child: Row(children: [
// //                     // Gold star badge
// //                     Container(
// //                       width: 44,
// //                       height: 44,
// //                       decoration: BoxDecoration(
// //                         color: _C.gold,
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       child: const Icon(
// //                         Icons.stars_rounded,
// //                         color: Colors.white,
// //                         size: 24,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),

// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             'লাইভ পয়েন্ট',
// //                             style: TextStyle(
// //                               color: Colors.white.withOpacity(0.5),
// //                               fontSize: 10,
// //                             ),
// //                           ),
// //                           const SizedBox(height: 1),
// //                           Row(children: [
// //                             Text(
// //                               '$points',
// //                               style: const TextStyle(
// //                                 color: Colors.white,
// //                                 fontWeight: FontWeight.w900,
// //                                 fontSize: 22,
// //                                 letterSpacing: -0.4,
// //                                 height: 1,
// //                               ),
// //                             ),
// //                             Text(
// //                               ' pts',
// //                               style: TextStyle(
// //                                 color: Colors.white.withOpacity(0.5),
// //                                 fontSize: 12,
// //                               ),
// //                             ),
// //                           ]),
// //                         ],
// //                       ),
// //                     ),

// //                     // Completed count pill
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 10, vertical: 6),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white.withOpacity(0.12),
// //                         borderRadius: BorderRadius.circular(20),
// //                       ),
// //                       child: Row(mainAxisSize: MainAxisSize.min, children: [
// //                         Icon(
// //                           Icons.check_circle_rounded,
// //                           color: Colors.white.withOpacity(0.7),
// //                           size: 12,
// //                         ),
// //                         const SizedBox(width: 4),
// //                         Text(
// //                           '$completed টি সম্পন্ন',
// //                           style: const TextStyle(
// //                             color: Colors.white,
// //                             fontSize: 11,
// //                             fontWeight: FontWeight.w600,
// //                           ),
// //                         ),
// //                       ]),
// //                     ),
// //                   ]),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SECTION TAB BAR  (horizontal scroll, same chip style as month chips)
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _SectionTabBar extends StatelessWidget {
// //   final List<String> sections;
// //   final Map<String, IconData> icons;
// //   final int activeIndex;
// //   final Map<String, List<AmalCategory>> catsBySection;
// //   final Map<String, _LocalItem> localItems;
// //   final ValueChanged<int> onTap;

// //   const _SectionTabBar({
// //     required this.sections,
// //     required this.icons,
// //     required this.activeIndex,
// //     required this.catsBySection,
// //     required this.localItems,
// //     required this.onTap,
// //   });

// //   int _completedInSection(String sec) {
// //     final cats = catsBySection[sec] ?? [];
// //     return cats.where((c) => localItems[c.id]?.completed == true).length;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: _C.cardBg,
// //       child: Column(
// //         children: [
// //           SingleChildScrollView(
// //             scrollDirection: Axis.horizontal,
// //             padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
// //             child: Row(
// //               children: sections.asMap().entries.map((e) {
// //                 final i = e.key;
// //                 final sec = e.value;
// //                 final label = AppConstants.sectionLabels[sec]?['bn'] ?? sec;
// //                 final icon = icons[sec] ?? Icons.circle;
// //                 final done = _completedInSection(sec);
// //                 final total = (catsBySection[sec] ?? []).length;
// //                 final isActive = i == activeIndex;
// //                 final allDone = done == total && total > 0;

// //                 return GestureDetector(
// //                   onTap: () => onTap(i),
// //                   child: AnimatedContainer(
// //                     duration: 180.ms,
// //                     margin: const EdgeInsets.only(right: 8),
// //                     padding:
// //                         const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //                     decoration: BoxDecoration(
// //                       color: isActive ? _C.darkGreen : _C.pageBg,
// //                       borderRadius: BorderRadius.circular(99),
// //                       border: Border.all(
// //                         color: isActive
// //                             ? _C.darkGreen
// //                             : allDone
// //                                 ? _C.green.withOpacity(0.4)
// //                                 : _C.border,
// //                         width: 0.5,
// //                       ),
// //                     ),
// //                     child: Row(mainAxisSize: MainAxisSize.min, children: [
// //                       Icon(
// //                         icon,
// //                         size: 12,
// //                         color: isActive
// //                             ? Colors.white
// //                             : allDone
// //                                 ? _C.green
// //                                 : _C.textSecondary,
// //                       ),
// //                       const SizedBox(width: 5),
// //                       Text(
// //                         label,
// //                         style: TextStyle(
// //                           fontSize: 11,
// //                           fontWeight:
// //                               isActive ? FontWeight.w700 : FontWeight.w500,
// //                           color: isActive
// //                               ? Colors.white
// //                               : allDone
// //                                   ? _C.green
// //                                   : _C.textSecondary,
// //                         ),
// //                       ),
// //                       if (done > 0) ...[
// //                         const SizedBox(width: 6),
// //                         Container(
// //                           padding: const EdgeInsets.symmetric(
// //                               horizontal: 6, vertical: 2),
// //                           decoration: BoxDecoration(
// //                             color: isActive
// //                                 ? Colors.white.withOpacity(0.2)
// //                                 : allDone
// //                                     ? _C.greenLight
// //                                     : _C.pageBg,
// //                             borderRadius: BorderRadius.circular(20),
// //                           ),
// //                           child: Text(
// //                             '$done/$total',
// //                             style: TextStyle(
// //                               fontSize: 9,
// //                               fontWeight: FontWeight.w700,
// //                               color: isActive
// //                                   ? Colors.white
// //                                   : allDone
// //                                       ? _C.green
// //                                       : _C.textHint,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ]),
// //                   ),
// //                 );
// //               }).toList(),
// //             ),
// //           ),
// //           const Divider(height: 0.5, thickness: 0.5, color: _C.border),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SECTION FORM
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _SectionForm extends StatelessWidget {
// //   final String sectionKey;
// //   final List<AmalCategory> categories;
// //   final Map<String, _LocalItem> localItems;
// //   final bool isTablet;
// //   final void Function(String, bool) onToggle;
// //   final void Function(String, PrayerMode) onPrayerMode;
// //   final void Function(String, int) onCount;

// //   const _SectionForm({
// //     super.key,
// //     required this.sectionKey,
// //     required this.categories,
// //     required this.localItems,
// //     required this.isTablet,
// //     required this.onToggle,
// //     required this.onPrayerMode,
// //     required this.onCount,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     if (categories.isEmpty) {
// //       return const Center(
// //         child: Text(
// //           'এই বিভাগে কোনো আমল নেই',
// //           style: TextStyle(color: _C.textHint, fontSize: 13),
// //         ),
// //       );
// //     }

// //     final hPad =
// //         isTablet ? (MediaQuery.of(context).size.width - 600) / 2 + 16.0 : 16.0;

// //     return ListView.separated(
// //       padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 14),
// //       itemCount: categories.length,
// //       separatorBuilder: (_, __) => const SizedBox(height: 10),
// //       itemBuilder: (ctx, i) {
// //         final cat = categories[i];
// //         final item = localItems[cat.id];

// //         late Widget card;
// //         if (cat.isPrayer) {
// //           card = _PrayerFormCard(
// //             cat: cat,
// //             item: item,
// //             onMode: (mode) => onPrayerMode(cat.id, mode),
// //           );
// //         } else if (item?.isCount == true) {
// //           card = _CountFormCard(
// //             cat: cat,
// //             item: item,
// //             onCount: (c) => onCount(cat.id, c),
// //           );
// //         } else {
// //           card = _ToggleFormCard(
// //             cat: cat,
// //             item: item,
// //             onToggle: (v) => onToggle(cat.id, v),
// //           );
// //         }

// //         return card
// //             .animate(delay: (i * 35).ms)
// //             .fadeIn(duration: 240.ms)
// //             .slideX(begin: 0.05, curve: Curves.easeOut);
// //       },
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // PRAYER FORM CARD
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _PrayerFormCard extends StatelessWidget {
// //   final AmalCategory cat;
// //   final _LocalItem? item;
// //   final ValueChanged<PrayerMode> onMode;

// //   const _PrayerFormCard({
// //     required this.cat,
// //     required this.item,
// //     required this.onMode,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final mode = item?.prayerMode ?? PrayerMode.missed;
// //     final pts = item?.points ?? 0;

// //     final borderColor = mode == PrayerMode.congregation
// //         ? _C.green.withOpacity(0.5)
// //         : mode == PrayerMode.solo
// //             ? _C.amber.withOpacity(0.5)
// //             : _C.border;

// //     return Container(
// //       decoration: BoxDecoration(
// //         color: _C.cardBg,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: borderColor, width: 1),
// //       ),
// //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //         // Card header
// //         Padding(
// //           padding: const EdgeInsets.fromLTRB(14, 13, 14, 11),
// //           child: Row(children: [
// //             _AmalIconBadge(
// //               icon: Icons.mosque_rounded,
// //               active: mode != PrayerMode.missed,
// //               activeColor: _C.green,
// //             ),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     cat.nameBn,
// //                     style: const TextStyle(
// //                       color: _C.textPrimary,
// //                       fontWeight: FontWeight.w700,
// //                       fontSize: 13,
// //                     ),
// //                   ),
// //                   Text(
// //                     cat.nameEn,
// //                     style: const TextStyle(
// //                       color: _C.textSecondary,
// //                       fontSize: 11,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             _PtsTag(
// //               pts: pts,
// //               maxPts: cat.congregationPoints,
// //               active: pts > 0,
// //             ),
// //           ]),
// //         ),

// //         const Divider(height: 0.5, thickness: 0.5, color: _C.border),
// //         const SizedBox(height: 10),

// //         // Mode buttons
// //         Padding(
// //           padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
// //           child: Row(children: [
// //             Expanded(
// //               child: _ModeBtn(
// //                 label: 'জামাতে',
// //                 subLabel: '+${cat.congregationPoints}',
// //                 emoji: '✔',
// //                 isSelected: mode == PrayerMode.congregation,
// //                 activeColor: _C.green,
// //                 activeBg: _C.greenLight,
// //                 onTap: () => onMode(PrayerMode.congregation),
// //               ),
// //             ),
// //             const SizedBox(width: 8),
// //             Expanded(
// //               child: _ModeBtn(
// //                 label: 'একাকী',
// //                 subLabel: '+${cat.basePoints}',
// //                 emoji: '/',
// //                 isSelected: mode == PrayerMode.solo,
// //                 activeColor: _C.amber,
// //                 activeBg: _C.amberLight,
// //                 onTap: () => onMode(PrayerMode.solo),
// //               ),
// //             ),
// //             const SizedBox(width: 8),
// //             Expanded(
// //               child: _ModeBtn(
// //                 label: 'মিস',
// //                 subLabel: '+০',
// //                 emoji: '✗',
// //                 isSelected: mode == PrayerMode.missed,
// //                 activeColor: _C.textSecondary,
// //                 activeBg: _C.pageBg,
// //                 onTap: () => onMode(PrayerMode.missed),
// //               ),
// //             ),
// //           ]),
// //         ),
// //       ]),
// //     );
// //   }
// // }

// // class _ModeBtn extends StatelessWidget {
// //   final String label, subLabel, emoji;
// //   final bool isSelected;
// //   final Color activeColor, activeBg;
// //   final VoidCallback onTap;

// //   const _ModeBtn({
// //     required this.label,
// //     required this.subLabel,
// //     required this.emoji,
// //     required this.isSelected,
// //     required this.activeColor,
// //     required this.activeBg,
// //     required this.onTap,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: AnimatedContainer(
// //         duration: 160.ms,
// //         padding: const EdgeInsets.symmetric(vertical: 11),
// //         decoration: BoxDecoration(
// //           color: isSelected ? activeBg : _C.pageBg,
// //           borderRadius: BorderRadius.circular(12),
// //           border: Border.all(
// //             color: isSelected ? activeColor : _C.border,
// //             width: isSelected ? 1.5 : 0.5,
// //           ),
// //         ),
// //         child: Column(mainAxisSize: MainAxisSize.min, children: [
// //           Text(
// //             emoji,
// //             style: TextStyle(
// //               fontSize: 15,
// //               fontWeight: FontWeight.w700,
// //               color: isSelected ? activeColor : _C.textHint,
// //             ),
// //           ),
// //           const SizedBox(height: 3),
// //           Text(
// //             label,
// //             style: TextStyle(
// //               fontSize: 11,
// //               fontWeight: FontWeight.w700,
// //               color: isSelected ? activeColor : _C.textSecondary,
// //             ),
// //           ),
// //           Text(
// //             subLabel,
// //             style: TextStyle(
// //               fontSize: 9.5,
// //               color: isSelected ? activeColor.withOpacity(0.7) : _C.textHint,
// //             ),
// //           ),
// //         ]),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // TOGGLE FORM CARD
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _ToggleFormCard extends StatelessWidget {
// //   final AmalCategory cat;
// //   final _LocalItem? item;
// //   final ValueChanged<bool> onToggle;

// //   const _ToggleFormCard({
// //     required this.cat,
// //     required this.item,
// //     required this.onToggle,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final done = item?.completed ?? false;
// //     final pts = item?.points ?? 0;

// //     return GestureDetector(
// //       onTap: () => onToggle(!done),
// //       child: AnimatedContainer(
// //         duration: 160.ms,
// //         padding: const EdgeInsets.all(14),
// //         decoration: BoxDecoration(
// //           color: done ? _C.greenLight : _C.cardBg,
// //           borderRadius: BorderRadius.circular(16),
// //           border: Border.all(
// //             color: done ? _C.green.withOpacity(0.4) : _C.border,
// //             width: done ? 1.5 : 0.5,
// //           ),
// //         ),
// //         child: Row(children: [
// //           // Checkbox
// //           AnimatedContainer(
// //             duration: 180.ms,
// //             width: 30,
// //             height: 30,
// //             decoration: BoxDecoration(
// //               color: done ? _C.darkGreen : Colors.transparent,
// //               borderRadius: BorderRadius.circular(8),
// //               border: Border.all(
// //                 color: done ? _C.darkGreen : _C.borderMid,
// //                 width: 1.5,
// //               ),
// //             ),
// //             child: done
// //                 ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
// //                 : null,
// //           ),
// //           const SizedBox(width: 13),

// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   cat.nameBn,
// //                   style: TextStyle(
// //                     color: done ? _C.darkGreen : _C.textPrimary,
// //                     fontWeight: FontWeight.w600,
// //                     fontSize: 13,
// //                   ),
// //                 ),
// //                 if (cat.description != null) ...[
// //                   const SizedBox(height: 2),
// //                   Text(
// //                     cat.description!,
// //                     style: const TextStyle(
// //                       color: _C.textSecondary,
// //                       fontSize: 11,
// //                     ),
// //                   ),
// //                 ],
// //               ],
// //             ),
// //           ),

// //           const SizedBox(width: 8),
// //           _PtsTag(pts: pts, maxPts: cat.basePoints, active: done),
// //         ]),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // COUNT FORM CARD
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _CountFormCard extends StatelessWidget {
// //   final AmalCategory cat;
// //   final _LocalItem? item;
// //   final ValueChanged<int> onCount;

// //   const _CountFormCard({
// //     required this.cat,
// //     required this.item,
// //     required this.onCount,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final count = item?.count ?? 0;
// //     final pts = item?.points ?? 0;

// //     return Container(
// //       decoration: BoxDecoration(
// //         color: _C.cardBg,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(
// //           color: count > 0 ? _C.green.withOpacity(0.4) : _C.border,
// //           width: count > 0 ? 1.5 : 0.5,
// //         ),
// //       ),
// //       child: Column(children: [
// //         // Header
// //         Padding(
// //           padding: const EdgeInsets.fromLTRB(14, 13, 14, 11),
// //           child: Row(children: [
// //             _AmalIconBadge(
// //               icon: Icons.calendar_month_rounded,
// //               active: count > 0,
// //               activeColor: _C.darkGreen,
// //             ),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     cat.nameBn,
// //                     style: const TextStyle(
// //                       color: _C.textPrimary,
// //                       fontWeight: FontWeight.w700,
// //                       fontSize: 13,
// //                     ),
// //                   ),
// //                   if (cat.description != null)
// //                     Text(
// //                       cat.description!,
// //                       style: const TextStyle(
// //                         color: _C.textSecondary,
// //                         fontSize: 11,
// //                       ),
// //                     ),
// //                 ],
// //               ),
// //             ),
// //             _PtsTag(pts: pts, maxPts: cat.basePoints * 9, active: count > 0),
// //           ]),
// //         ),

// //         const Divider(height: 0.5, thickness: 0.5, color: _C.border),
// //         const SizedBox(height: 16),

// //         // Stepper
// //         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
// //           _StepBtn(
// //             icon: Icons.remove_rounded,
// //             onTap: count > 0 ? () => onCount(count - 1) : null,
// //           ),
// //           Container(
// //             width: 88,
// //             height: 70,
// //             margin: const EdgeInsets.symmetric(horizontal: 16),
// //             decoration: BoxDecoration(
// //               color: count > 0 ? _C.greenLight : _C.pageBg,
// //               borderRadius: BorderRadius.circular(14),
// //               border: Border.all(
// //                 color: count > 0 ? _C.green.withOpacity(0.3) : _C.border,
// //                 width: 0.5,
// //               ),
// //             ),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Text(
// //                   '$count',
// //                   style: TextStyle(
// //                     fontSize: 32,
// //                     fontWeight: FontWeight.w900,
// //                     height: 1,
// //                     color: count > 0 ? _C.darkGreen : _C.textHint,
// //                   ),
// //                 ),
// //                 Text(
// //                   '/ ৯ দিন',
// //                   style: TextStyle(
// //                     fontSize: 10,
// //                     color: count > 0 ? _C.textSecondary : _C.textHint,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           _StepBtn(
// //             icon: Icons.add_rounded,
// //             onTap: count < 9 ? () => onCount(count + 1) : null,
// //           ),
// //         ]),

// //         const SizedBox(height: 14),

// //         // Dot progress
// //         Padding(
// //           padding: const EdgeInsets.only(bottom: 16),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: List.generate(9, (i) {
// //               return AnimatedContainer(
// //                 duration: 140.ms,
// //                 width: 22,
// //                 height: 7,
// //                 margin: const EdgeInsets.symmetric(horizontal: 2),
// //                 decoration: BoxDecoration(
// //                   color: i < count ? _C.darkGreen : _C.border,
// //                   borderRadius: BorderRadius.circular(99),
// //                 ),
// //               );
// //             }),
// //           ),
// //         ),
// //       ]),
// //     );
// //   }
// // }

// // class _StepBtn extends StatelessWidget {
// //   final IconData icon;
// //   final VoidCallback? onTap;
// //   const _StepBtn({required this.icon, this.onTap});

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         width: 48,
// //         height: 48,
// //         decoration: BoxDecoration(
// //           color: onTap != null ? _C.greenLight : _C.pageBg,
// //           borderRadius: BorderRadius.circular(13),
// //           border: Border.all(
// //             color: onTap != null ? _C.green.withOpacity(0.3) : _C.border,
// //             width: 0.5,
// //           ),
// //         ),
// //         child: Icon(
// //           icon,
// //           color: onTap != null ? _C.darkGreen : _C.textHint,
// //           size: 22,
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // BOTTOM SAVE BAR
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _BottomSaveBar extends StatelessWidget {
// //   final bool isNew, saving;
// //   final int points, completed;
// //   final VoidCallback onSave, onCancel;

// //   const _BottomSaveBar({
// //     required this.isNew,
// //     required this.saving,
// //     required this.points,
// //     required this.completed,
// //     required this.onSave,
// //     required this.onCancel,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: EdgeInsets.fromLTRB(
// //         16,
// //         12,
// //         16,
// //         MediaQuery.of(context).padding.bottom + 12,
// //       ),
// //       decoration: const BoxDecoration(
// //         color: _C.cardBg,
// //         border: Border(top: BorderSide(color: _C.border, width: 0.5)),
// //       ),
// //       child: Row(children: [
// //         // Cancel
// //         GestureDetector(
// //           onTap: onCancel,
// //           child: Container(
// //             width: 50,
// //             height: 52,
// //             decoration: BoxDecoration(
// //               color: _C.pageBg,
// //               borderRadius: BorderRadius.circular(14),
// //               border: Border.all(color: _C.border, width: 0.5),
// //             ),
// //             child: const Icon(
// //               Icons.close_rounded,
// //               color: _C.textSecondary,
// //               size: 20,
// //             ),
// //           ),
// //         ),
// //         const SizedBox(width: 10),

// //         // Save / Update button
// //         Expanded(
// //           child: GestureDetector(
// //             onTap: saving ? null : onSave,
// //             child: AnimatedContainer(
// //               duration: 160.ms,
// //               height: 52,
// //               decoration: BoxDecoration(
// //                 color: saving ? _C.darkGreen.withOpacity(0.7) : _C.darkGreen,
// //                 borderRadius: BorderRadius.circular(14),
// //               ),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   if (saving)
// //                     const SizedBox(
// //                       width: 18,
// //                       height: 18,
// //                       child: CircularProgressIndicator(
// //                         color: Colors.white,
// //                         strokeWidth: 2,
// //                       ),
// //                     )
// //                   else ...[
// //                     Icon(
// //                       isNew ? Icons.save_rounded : Icons.check_rounded,
// //                       color: Colors.white,
// //                       size: 18,
// //                     ),
// //                     const SizedBox(width: 8),
// //                     Text(
// //                       isNew
// //                           ? 'সেভ করুন  ($points pts)'
// //                           : 'আপডেট করুন  ($points pts)',
// //                       style: const TextStyle(
// //                         color: Colors.white,
// //                         fontWeight: FontWeight.w700,
// //                         fontSize: 14,
// //                       ),
// //                     ),
// //                   ],
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ]),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // SHARED SMALL WIDGETS
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _AmalIconBadge extends StatelessWidget {
// //   final IconData icon;
// //   final bool active;
// //   final Color activeColor;

// //   const _AmalIconBadge({
// //     required this.icon,
// //     required this.active,
// //     required this.activeColor,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return AnimatedContainer(
// //       duration: 180.ms,
// //       width: 38,
// //       height: 38,
// //       decoration: BoxDecoration(
// //         color: active ? activeColor.withOpacity(0.1) : _C.pageBg,
// //         borderRadius: BorderRadius.circular(10),
// //         border: Border.all(
// //           color: active ? activeColor.withOpacity(0.25) : _C.border,
// //           width: 0.5,
// //         ),
// //       ),
// //       child: Icon(
// //         icon,
// //         size: 18,
// //         color: active ? activeColor : _C.textHint,
// //       ),
// //     );
// //   }
// // }

// // class _PtsTag extends StatelessWidget {
// //   final int pts, maxPts;
// //   final bool active;
// //   const _PtsTag(
// //       {required this.pts, required this.maxPts, required this.active});

// //   @override
// //   Widget build(BuildContext context) {
// //     return AnimatedContainer(
// //       duration: 180.ms,
// //       padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
// //       decoration: BoxDecoration(
// //         color: active ? _C.greenLight : _C.pageBg,
// //         borderRadius: BorderRadius.circular(20),
// //         border: Border.all(
// //           color: active ? _C.green.withOpacity(0.3) : _C.border,
// //           width: 0.5,
// //         ),
// //       ),
// //       child: Text(
// //         active ? '+$pts pts' : '$maxPts pts',
// //         style: TextStyle(
// //           fontSize: 10.5,
// //           fontWeight: FontWeight.w700,
// //           color: active ? _C.darkGreen : _C.textHint,
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ─────────────────────────────────────────────────────────────────────────────
// // // LOCAL ITEM MODEL
// // // ─────────────────────────────────────────────────────────────────────────────

// // class _LocalItem {
// //   final String categoryId;
// //   final int basePoints, congPoints;
// //   final bool isPrayer, isCount;
// //   bool completed;
// //   PrayerMode? prayerMode;
// //   int count;

// //   _LocalItem({
// //     required this.categoryId,
// //     required this.basePoints,
// //     required this.congPoints,
// //     required this.isPrayer,
// //     required this.isCount,
// //     required this.completed,
// //     this.prayerMode,
// //     this.count = 0,
// //   });

// //   int get points {
// //     if (!completed) return 0;
// //     if (isPrayer) {
// //       if (prayerMode == PrayerMode.congregation) return congPoints;
// //       if (prayerMode == PrayerMode.solo) return basePoints;
// //       return 0;
// //     }
// //     if (isCount) return count * basePoints;
// //     return basePoints;
// //   }
// // }
// import 'package:amal_tracker/features/auth/providers/provider_reset.dart';
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
//   static const goldLight = Color(0xFFFFF3E0);
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const amber = Color(0xFFFF6B35);
//   static const amberLight = Color(0xFFFFF3E0);
//   static const purple = Color(0xFF7C3AED);
//   static const purpleLight = Color(0xFFEDE9FE);
//   static const red = Color(0xFFEF4444);
//   static const redLight = Color(0xFFFEE2E2);
//   static const blue = Color(0xFF0891B2);
//   static const blueLight = Color(0xFFE0F2FE);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
//   static const border = Color(0xFFE4EAE4);
//   static const borderMid = Color(0xFFD0DAD2);
//   static const success = Color(0xFF16A34A);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // HELPERS — driven by backend unit strings
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
//     default:
//       return unit ?? 'টি';
//   }
// }

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
//   late Map<String, _LocalItem> _localItems;
//   bool _saving = false;
//   bool _isExemptDay = false;
//   int _activeSection = 0;

//   // Section order & icons are purely cosmetic — actual sections come from catsBySection keys
//   static const _sectionOrder = [
//     'salat',
//     'sunnah_nafl',
//     'dhikr_tilawat',
//     'daily_habits',
//     'weekly',
//     'special_dhulhijja',
//     'social',
//   ];

//   static const _sectionIcons = <String, IconData>{
//     'salat': Icons.mosque_rounded,
//     'sunnah_nafl': Icons.auto_awesome_rounded,
//     'dhikr_tilawat': Icons.menu_book_rounded,
//     'daily_habits': Icons.self_improvement_rounded,
//     'weekly': Icons.date_range_rounded,
//     'special_dhulhijja': Icons.star_rounded,
//     'social': Icons.people_rounded,
//   };

//   // Only include sections that have backend-returned categories
//   List<String> get _activeSections => _sectionOrder
//       .where((s) => (widget.catsBySection[s] ?? []).isNotEmpty)
//       .toList();

//   @override
//   void initState() {
//     super.initState();
//     _isExemptDay = widget.existingState.entry?.isExemptDay ?? false;
//     _initLocalItems();
//   }

//   void _applyExemptDay() {
//     if (!_isExemptDay) return;
//     for (final item in _localItems.values) {
//       if (item.isFard) {
//         item.completed = false;
//         item.prayerMode = PrayerMode.missed;
//         item.isExempted = true;
//       }
//     }
//   }

//   // void _initLocalItems() {
//   //   _localItems = {};
//   //   final existing = widget.existingState.effectiveEntries;
//   //   for (final cats in widget.catsBySection.values) {
//   //     for (final cat in cats) {
//   //       final prev = existing[cat.id];
//   //       _localItems[cat.id] = _LocalItem(
//   //         categoryId: cat.id,
//   //         isPrayer: cat.isPrayer,
//   //         inputType: cat.inputType, // ← from backend
//   //         basePoints: cat.basePoints,
//   //         congPoints: cat.congregationPoints,
//   //         pointsPerUnit: cat.pointsPerUnit, // ← from backend
//   //         maxValue: cat.maxValue, // ← from backend
//   //         completed: prev?.completed ?? false,
//   //         prayerMode: prev?.prayerMode,
//   //         count: prev?.count ?? 0,
//   //       );
//   //     }
//   //   }
//   // }

//   void _initLocalItems() {
//     _localItems = {};
//     final existing = widget.existingState.effectiveEntries;
//     for (final cats in widget.catsBySection.values) {
//       for (final cat in cats) {
//         final prev = existing[cat.id];
//         _localItems[cat.id] = _LocalItem(
//           categoryId: cat.id,
//           isPrayer: cat.isPrayer,
//           isFard: cat.isFard, // ← new
//           inputType: cat.inputType,
//           basePoints: cat.basePoints,
//           congPoints: cat.congregationPoints,
//           pointsPerUnit: cat.pointsPerUnit,
//           maxValue: cat.maxValue,
//           completed: prev?.completed ?? false,
//           prayerMode: prev?.prayerMode,
//           count: prev?.count ?? 0,
//           isExempted: _isExemptDay && cat.isFard, // ← new
//         );
//       }
//     }
//   }

//   void _toggleExemptDay(bool val) {
//     setState(() {
//       _isExemptDay = val;
//       for (final item in _localItems.values) {
//         if (item.isFard) {
//           item.isExempted = val;
//           if (val) {
//             item.completed = false;
//             item.prayerMode = PrayerMode.missed;
//             item.count = 0;
//           } else {
//             // restore to "missed" so user picks fresh
//             item.isExempted = false;
//           }
//         }
//       }
//     });
//     HapticFeedback.mediumImpact();
//   }

//   int get _totalPoints => _localItems.values.fold(0, (s, i) => s + i.points);
//   int get _completedCount =>
//       _localItems.values.where((i) => i.completed).length;

//   // ── Interaction callbacks ──────────────────────────────────────────────────

//   void _toggleItem(String id, bool value) {
//     setState(() {
//       final item = _localItems[id]!;
//       item.completed = value;
//       if (!value) {
//         item.prayerMode = item.isPrayer ? PrayerMode.missed : null;
//         item.count = 0;
//       } else if (item.isPrayer && item.prayerMode == null) {
//         item.prayerMode = PrayerMode.congregation;
//       }
//     });
//     HapticFeedback.selectionClick();
//   }

//   void _setPrayerMode(String id, PrayerMode mode) {
//     setState(() {
//       final item = _localItems[id]!;
//       item.prayerMode = mode;
//       item.completed = mode != PrayerMode.missed;
//     });
//     HapticFeedback.selectionClick();
//   }

//   /// Generic counter setter — respects backend maxValue
//   void _setCount(String id, int count) {
//     setState(() {
//       final item = _localItems[id]!;
//       final max = item.maxValue?.toInt();
//       item.count = max != null ? count.clamp(0, max) : count.clamp(0, 9999);
//       item.completed = item.count > 0;
//     });
//     HapticFeedback.lightImpact();
//   }

//   // ── Save ──────────────────────────────────────────────────────────────────

//   Future<void> _save() async {
//     setState(() => _saving = true);

//     final updates = _localItems.values
//         .map((item) => EntryUpdate(
//               categoryId: item.categoryId,
//               completed: item.completed,
//               prayerMode: item.prayerMode,
//               count: item.count,
//             ))
//         .toList();

//     final ok = await ref
//         .read(dailyEntryProvider(widget.dateStr).notifier)
//         .saveEntryFromUpdates(updates);

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
//         Icon(
//           ok ? Icons.check_circle_rounded : Icons.error_outline_rounded,
//           color: Colors.white,
//         ),
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

//   // ── Build ─────────────────────────────────────────────────────────────────

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
//           icons: _sectionIcons,
//           activeIndex: _activeSection,
//           catsBySection: widget.catsBySection,
//           localItems: _localItems,
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
//               localItems: _localItems,
//               isTablet: isTablet,
//               onToggle: _toggleItem,
//               onPrayerMode: _setPrayerMode,
//               onCount: _setCount,
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
//           // Drag handle
//           Padding(
//             padding: const EdgeInsets.only(top: 12, bottom: 4),
//             child: Center(
//               child: Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.25),
//                       borderRadius: BorderRadius.circular(99))),
//             ),
//           ),

//           // Title row
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
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(isNew ? 'আমল যোগ করুন' : 'আমল সম্পাদনা করুন',
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w800,
//                           fontSize: 16,
//                           letterSpacing: -0.3)),
//                   Text('$d $month $y',
//                       style: TextStyle(
//                           color: Colors.white.withOpacity(0.5),
//                           fontSize: 11,
//                           fontWeight: FontWeight.w500)),
//                 ],
//               )),
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

//           // Live points card
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
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('লাইভ পয়েন্ট',
//                         style: TextStyle(
//                             color: Colors.white.withOpacity(0.5),
//                             fontSize: 10)),
//                     const SizedBox(height: 1),
//                     Row(children: [
//                       Text('$points',
//                           style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w900,
//                               fontSize: 22,
//                               letterSpacing: -0.4,
//                               height: 1)),
//                       Text(' pts',
//                           style: TextStyle(
//                               color: Colors.white.withOpacity(0.5),
//                               fontSize: 12)),
//                     ]),
//                   ],
//                 )),
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
//   final Map<String, IconData> icons;
//   final int activeIndex;
//   final Map<String, List<AmalCategory>> catsBySection;
//   final Map<String, _LocalItem> localItems;
//   final ValueChanged<int> onTap;

//   const _SectionTabBar({
//     required this.sections,
//     required this.icons,
//     required this.activeIndex,
//     required this.catsBySection,
//     required this.localItems,
//     required this.onTap,
//   });

//   int _completedInSection(String sec) {
//     final cats = catsBySection[sec] ?? [];
//     return cats.where((c) => localItems[c.id]?.completed == true).length;
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
//               final icon = icons[sec] ?? Icons.circle;
//               final done = _completedInSection(sec);
//               final total = (catsBySection[sec] ?? []).length;
//               final isActive = i == activeIndex;
//               final allDone = done == total && total > 0;

//               return GestureDetector(
//                 onTap: () => onTap(i),
//                 child: AnimatedContainer(
//                   duration: 180.ms,
//                   margin: const EdgeInsets.only(right: 8),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: isActive ? _C.darkGreen : _C.pageBg,
//                     borderRadius: BorderRadius.circular(99),
//                     border: Border.all(
//                       color: isActive
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
//                         color: isActive
//                             ? Colors.white
//                             : allDone
//                                 ? _C.green
//                                 : _C.textSecondary),
//                     const SizedBox(width: 5),
//                     Text(label,
//                         style: TextStyle(
//                             fontSize: 11,
//                             fontWeight:
//                                 isActive ? FontWeight.w700 : FontWeight.w500,
//                             color: isActive
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
//                             color: isActive
//                                 ? Colors.white.withOpacity(0.2)
//                                 : allDone
//                                     ? _C.greenLight
//                                     : _C.pageBg,
//                             borderRadius: BorderRadius.circular(20)),
//                         child: Text('$done/$total',
//                             style: TextStyle(
//                                 fontSize: 9,
//                                 fontWeight: FontWeight.w700,
//                                 color: isActive
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
// // SECTION FORM  — routing logic fully driven by cat.inputType from backend
// // ─────────────────────────────────────────────────────────────────────────────

// class _SectionForm extends StatelessWidget {
//   final String sectionKey;
//   final List<AmalCategory> categories;
//   final Map<String, _LocalItem> localItems;
//   final bool isTablet;
//   final void Function(String, bool) onToggle;
//   final void Function(String, PrayerMode) onPrayerMode;
//   final void Function(String, int) onCount;

//   const _SectionForm({
//     super.key,
//     required this.sectionKey,
//     required this.categories,
//     required this.localItems,
//     required this.isTablet,
//     required this.onToggle,
//     required this.onPrayerMode,
//     required this.onCount,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (categories.isEmpty) {
//       return const Center(
//         child: Text('এই বিভাগে কোনো আমল নেই',
//             style: TextStyle(color: _C.textHint, fontSize: 13)),
//       );
//     }

//     final hPad =
//         isTablet ? (MediaQuery.of(context).size.width - 600) / 2 + 16.0 : 16.0;

//     return ListView.separated(
//       padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 14),
//       itemCount: categories.length,
//       separatorBuilder: (_, __) => const SizedBox(height: 10),
//       itemBuilder: (ctx, i) {
//         final cat = categories[i];
//         final item = localItems[cat.id];

//         // ── Route card type purely from backend inputType ──────────
//         late Widget card;
//         if (cat.isPrayer) {
//           card = _PrayerFormCard(
//             cat: cat,
//             item: item,
//             onMode: (mode) => onPrayerMode(cat.id, mode),
//           );
//         } else if (cat.inputType == AmalInputType.counter) {
//           card = _CounterFormCard(
//             cat: cat,
//             item: item,
//             onCount: (c) => onCount(cat.id, c),
//           );
//         } else {
//           // binary (and duration treated as binary for now — extend later)
//           card = _ToggleFormCard(
//             cat: cat,
//             item: item,
//             onToggle: (v) => onToggle(cat.id, v),
//           );
//         }

//         return card
//             .animate(delay: (i * 35).ms)
//             .fadeIn(duration: 240.ms)
//             .slideX(begin: 0.05, curve: Curves.easeOut);
//       },
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PRAYER FORM CARD  (unchanged logic)
// // ─────────────────────────────────────────────────────────────────────────────

// class _PrayerFormCard extends StatelessWidget {
//   final AmalCategory cat;
//   final _LocalItem? item;
//   final ValueChanged<PrayerMode> onMode;

//   const _PrayerFormCard({
//     required this.cat,
//     required this.item,
//     required this.onMode,
//   });

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
//         color: _C.cardBg,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: borderColor, width: 1),
//       ),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(14, 13, 14, 11),
//           child: Row(children: [
//             _AmalIconBadge(
//                 icon: Icons.mosque_rounded,
//                 active: mode != PrayerMode.missed,
//                 activeColor: _C.green),
//             const SizedBox(width: 12),
//             Expanded(
//                 child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(cat.nameBn,
//                     style: const TextStyle(
//                         color: _C.textPrimary,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 13)),
//                 Text(cat.nameEn,
//                     style:
//                         const TextStyle(color: _C.textSecondary, fontSize: 11)),
//               ],
//             )),
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
// // TOGGLE FORM CARD  (binary)
// // ─────────────────────────────────────────────────────────────────────────────

// class _ToggleFormCard extends StatelessWidget {
//   final AmalCategory cat;
//   final _LocalItem? item;
//   final ValueChanged<bool> onToggle;

//   const _ToggleFormCard({
//     required this.cat,
//     required this.item,
//     required this.onToggle,
//   });

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
//           // Checkbox
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
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(cat.nameBn,
//                   style: TextStyle(
//                       color: done ? _C.darkGreen : _C.textPrimary,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 13)),
//               if (cat.description != null) ...[
//                 const SizedBox(height: 2),
//                 Text(cat.description!,
//                     style:
//                         const TextStyle(color: _C.textSecondary, fontSize: 11)),
//               ],
//             ],
//           )),

//           const SizedBox(width: 8),
//           _PtsTag(pts: pts, maxPts: cat.basePoints, active: done),
//         ]),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // COUNTER FORM CARD  — fully generic, driven by backend fields
// // ─────────────────────────────────────────────────────────────────────────────

// class _CounterFormCard extends StatelessWidget {
//   final AmalCategory cat;
//   final _LocalItem? item;
//   final ValueChanged<int> onCount;

//   const _CounterFormCard({
//     required this.cat,
//     required this.item,
//     required this.onCount,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final count = item?.count ?? 0;
//     final pts = item?.points ?? 0;
//     final unitBn = _unitLabelBn(cat.unit);
//     final maxVal = cat.maxValue?.toInt(); // null = unlimited
//     final ppu = cat.pointsPerUnit ?? cat.basePoints.toDouble();
//     final maxPts = maxVal != null ? (maxVal * ppu).round() : null;
//     final hasMax = maxVal != null;

//     return Container(
//       decoration: BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//               color: count > 0 ? _C.green.withOpacity(0.4) : _C.border,
//               width: count > 0 ? 1.5 : 0.5)),
//       child: Column(children: [
//         // ── Header ─────────────────────────────────────────────────
//         Padding(
//           padding: const EdgeInsets.fromLTRB(14, 13, 14, 11),
//           child: Row(children: [
//             _AmalIconBadge(
//                 icon: Icons.add_circle_outline_rounded,
//                 active: count > 0,
//                 activeColor: _C.darkGreen),
//             const SizedBox(width: 12),
//             Expanded(
//                 child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(cat.nameBn,
//                     style: const TextStyle(
//                         color: _C.textPrimary,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 13)),
//                 if (cat.description != null)
//                   Text(cat.description!,
//                       style: const TextStyle(
//                           color: _C.textSecondary, fontSize: 11)),
//               ],
//             )),
//             // Points tag: show "X / maxPts pts" or just current pts if unlimited
//             _CounterPtsTag(
//               current: pts,
//               max: maxPts,
//               active: count > 0,
//             ),
//           ]),
//         ),

//         const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//         const SizedBox(height: 20),

//         // ── Stepper ────────────────────────────────────────────────
//         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           _StepBtn(
//             icon: Icons.remove_rounded,
//             onTap: count > 0 ? () => onCount(count - 1) : null,
//           ),

//           // Value display
//           Container(
//             width: 96,
//             height: 78,
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             decoration: BoxDecoration(
//                 color: count > 0 ? _C.greenLight : _C.pageBg,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                     color: count > 0 ? _C.green.withOpacity(0.3) : _C.border,
//                     width: 0.5)),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('$count',
//                     style: TextStyle(
//                         fontSize: 34,
//                         fontWeight: FontWeight.w900,
//                         height: 1,
//                         color: count > 0 ? _C.darkGreen : _C.textHint)),
//                 const SizedBox(height: 3),
//                 Text(hasMax ? '/ $maxVal $unitBn' : unitBn,
//                     style: TextStyle(
//                         fontSize: 10,
//                         color: count > 0 ? _C.textSecondary : _C.textHint)),
//               ],
//             ),
//           ),

//           _StepBtn(
//             icon: Icons.add_rounded,
//             onTap:
//                 (hasMax && count >= maxVal!) ? null : () => onCount(count + 1),
//           ),
//         ]),

//         const SizedBox(height: 14),

//         // ── Progress indicator ─────────────────────────────────────
//         // Bounded: show dot bars | Unlimited: show linear progress bar
//         if (hasMax) ...[
//           Padding(
//             padding: const EdgeInsets.only(bottom: 16),
//             child: _BoundedProgress(count: count, max: maxVal!),
//           ),
//         ] else ...[
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//             child: _UnboundedProgress(count: count, unitBn: unitBn),
//           ),
//         ],

//         // ── Points-per-unit hint ───────────────────────────────────
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

// // Bounded progress (dot bars, max known)
// class _BoundedProgress extends StatelessWidget {
//   final int count, max;
//   const _BoundedProgress({required this.count, required this.max});

//   @override
//   Widget build(BuildContext context) {
//     // Cap dot count at 15 for visual clarity; use fraction fill if max > 15
//     final dotCount = max.clamp(1, 15);
//     final fillRatio = max > 15 ? count / max : null;

//     if (fillRatio != null) {
//       // Wide linear bar for large maxValues
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
//               value: fillRatio.clamp(0.0, 1.0),
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
//       children: List.generate(dotCount, (i) {
//         return AnimatedContainer(
//           duration: 140.ms,
//           width: max <= 7 ? 28 : 22,
//           height: 7,
//           margin: const EdgeInsets.symmetric(horizontal: 2),
//           decoration: BoxDecoration(
//               color: i < count ? _C.darkGreen : _C.border,
//               borderRadius: BorderRadius.circular(99)),
//         );
//       }),
//     );
//   }
// }

// // Unbounded progress — shows a subtle infinite-style indicator
// class _UnboundedProgress extends StatelessWidget {
//   final int count;
//   final String unitBn;
//   const _UnboundedProgress({required this.count, required this.unitBn});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(Icons.trending_up_rounded,
//             color: count > 0 ? _C.darkGreen : _C.textHint, size: 16),
//         const SizedBox(width: 6),
//         Text(
//             count > 0
//                 ? '$count $unitBn যোগ করা হয়েছে'
//                 : 'যত বেশি, তত বেশি পয়েন্ট',
//             style: TextStyle(
//                 color: count > 0 ? _C.darkGreen : _C.textHint,
//                 fontSize: 11,
//                 fontWeight: FontWeight.w500)),
//       ],
//     );
//   }
// }

// class _StepBtn extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback? onTap;
//   const _StepBtn({required this.icon, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 52,
//         height: 52,
//         decoration: BoxDecoration(
//             color: onTap != null ? _C.greenLight : _C.pageBg,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(
//                 color: onTap != null ? _C.green.withOpacity(0.3) : _C.border,
//                 width: 0.5)),
//         child: Icon(icon,
//             color: onTap != null ? _C.darkGreen : _C.textHint, size: 24),
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
//         color: _C.cardBg,
//         border: Border(top: BorderSide(color: _C.border, width: 0.5)),
//       ),
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
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (saving)
//                     const SizedBox(
//                         width: 18,
//                         height: 18,
//                         child: CircularProgressIndicator(
//                             color: Colors.white, strokeWidth: 2))
//                   else ...[
//                     Icon(isNew ? Icons.save_rounded : Icons.check_rounded,
//                         color: Colors.white, size: 18),
//                     const SizedBox(width: 8),
//                     Text(
//                         isNew
//                             ? 'সেভ করুন  ($points pts)'
//                             : 'আপডেট করুন  ($points pts)',
//                         style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w700,
//                             fontSize: 14)),
//                   ],
//                 ],
//               ),
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

// class _AmalIconBadge extends StatelessWidget {
//   final IconData icon;
//   final bool active;
//   final Color activeColor;
//   const _AmalIconBadge(
//       {required this.icon, required this.active, required this.activeColor});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: 180.ms,
//       width: 38,
//       height: 38,
//       decoration: BoxDecoration(
//           color: active ? activeColor.withOpacity(0.1) : _C.pageBg,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//               color: active ? activeColor.withOpacity(0.25) : _C.border,
//               width: 0.5)),
//       child: Icon(icon, size: 18, color: active ? activeColor : _C.textHint),
//     );
//   }
// }

// class _PtsTag extends StatelessWidget {
//   final int pts, maxPts;
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
//       child: Text(active ? '+$pts pts' : '$maxPts pts',
//           style: TextStyle(
//               fontSize: 10.5,
//               fontWeight: FontWeight.w700,
//               color: active ? _C.darkGreen : _C.textHint)),
//     );
//   }
// }

// /// Points tag for counter items — shows "Xpts / maxPts pts" or just "Xpts"
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

// // ─────────────────────────────────────────────────────────────────────────────
// // LOCAL ITEM MODEL  — inputType & counter fields from backend, no hardcoding
// // ─────────────────────────────────────────────────────────────────────────────

// class _LocalItem {
//   final String categoryId;
//   final int basePoints, congPoints;
//   final bool isPrayer;
//   final AmalInputType inputType; // from backend
//   final double? pointsPerUnit; // from backend
//   final num? maxValue; // from backend
//   bool completed;
//   PrayerMode? prayerMode;
//   int count;

//   _LocalItem({
//     required this.categoryId,
//     required this.isPrayer,
//     required this.inputType,
//     required this.basePoints,
//     required this.congPoints,
//     required this.completed,
//     this.pointsPerUnit,
//     this.maxValue,
//     this.prayerMode,
//     this.count = 0,
//   });

//   int get points {
//     if (isPrayer) {
//       if (prayerMode == PrayerMode.congregation) return congPoints;
//       if (prayerMode == PrayerMode.solo) return basePoints;
//       return 0;
//     }
//     // Counter: points = count × pointsPerUnit (backend-driven)
//     if (inputType == AmalInputType.counter) {
//       return (count * (pointsPerUnit ?? basePoints.toDouble())).round();
//     }
//     if (!completed) return 0;
//     return basePoints;
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
  static const goldLight = Color(0xFFFFF3E0);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const amber = Color(0xFFFF6B35);
  static const amberLight = Color(0xFFFFF3E0);
  static const purple = Color(0xFF7C3AED);
  static const purpleLight = Color(0xFFEDE9FE);
  static const red = Color(0xFFEF4444);
  static const redLight = Color(0xFFFEE2E2);
  static const blue = Color(0xFF0891B2);
  static const blueLight = Color(0xFFE0F2FE);
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
// HELPERS — driven by backend unit strings
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
    default:
      return unit ?? 'টি';
  }
}

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
  late Map<String, _LocalItem> _localItems;
  bool _saving = false;
  int _activeSection = 0;
  bool _isExemptDay = false;
  bool _isFemale = false;

  static const _sectionOrder = [
    'salat',
    'sunnah_nafl',
    'dhikr_tilawat',
    'daily_habits',
    'weekly',
    'special_dhulhijja',
    'social',
  ];

  static const _sectionIcons = <String, IconData>{
    'salat': Icons.mosque_rounded,
    'sunnah_nafl': Icons.auto_awesome_rounded,
    'dhikr_tilawat': Icons.menu_book_rounded,
    'daily_habits': Icons.self_improvement_rounded,
    'weekly': Icons.date_range_rounded,
    'special_dhulhijja': Icons.star_rounded,
    'social': Icons.people_rounded,
  };

  List<String> get _activeSections => _sectionOrder
      .where((s) => (widget.catsBySection[s] ?? []).isNotEmpty)
      .toList();

  @override
  void initState() {
    super.initState();
    // Determine gender from current user
    final user = ref.read(currentUserProvider);

    _isFemale = (user?.gender?.toLowerCase() == 'female');

    // Load existing exempt day state
    _isExemptDay = widget.existingState.entry?.isExemptDay ?? false;

    _initLocalItems();
  }

  void _initLocalItems() {
    _localItems = {};
    final existing = widget.existingState.effectiveEntries;

    for (final cats in widget.catsBySection.values) {
      for (final cat in cats) {
        final prev = existing[cat.id];
        // final exempted = _isFemale && _isExemptDay && cat.isFard;
        final exempted = _isFemale && _isExemptDay && cat.isExemptDuringPeriod;
        _localItems[cat.id] = _LocalItem(
          categoryId: cat.id,
          isPrayer: cat.isPrayer,
          isFard: cat.isFard,
          isExemptDuringPeriod: cat.isExemptDuringPeriod,
          inputType: cat.inputType,
          basePoints: cat.basePoints,
          congPoints: cat.congregationPoints,
          pointsPerUnit: cat.pointsPerUnit,
          maxValue: cat.maxValue,
          completed: exempted ? false : (prev?.completed ?? false),
          prayerMode: exempted ? PrayerMode.missed : prev?.prayerMode,
          count: exempted ? 0 : (prev?.count ?? 0),
          isExempted: exempted,
        );
      }
    }
  }

  // ── Exempt day toggle ──────────────────────────────────────────────────────

  void _toggleExemptDay(bool val) {
    setState(() {
      _isExemptDay = val;
      for (final item in _localItems.values) {
        if (item.isExemptDuringPeriod) {
          item.isExempted = val;
          if (val) {
            item.completed = false;
            item.prayerMode = PrayerMode.missed;
            item.count = 0;
          } else {
            item.isExempted = false;
          }
        }
      }
      // for (final item in _localItems.values) {
      //   if (item.isFard) {
      //     item.isExempted = val;
      //     if (val) {
      //       // Auto-clear fard items when exempt day is ON
      //       item.completed = false;
      //       item.prayerMode = PrayerMode.missed;
      //       item.count = 0;
      //     } else {
      //       // When turning OFF, just un-exempt — user picks fresh
      //       item.isExempted = false;
      //     }
      //   }
      // }
    });
    HapticFeedback.mediumImpact();
  }

  // ── Item interaction callbacks ─────────────────────────────────────────────

  void _toggleItem(String id, bool value) {
    setState(() {
      final item = _localItems[id]!;
      if (item.isExempted) return; // block interaction on exempted items
      item.completed = value;
      if (!value) {
        item.prayerMode = item.isPrayer ? PrayerMode.missed : null;
        item.count = 0;
      } else if (item.isPrayer && item.prayerMode == null) {
        item.prayerMode = PrayerMode.congregation;
      }
    });
    HapticFeedback.selectionClick();
  }

  void _setPrayerMode(String id, PrayerMode mode) {
    setState(() {
      final item = _localItems[id]!;
      if (item.isExempted) return; // block interaction on exempted items
      item.prayerMode = mode;
      item.completed = mode != PrayerMode.missed;
    });
    HapticFeedback.selectionClick();
  }

  void _setCount(String id, int count) {
    setState(() {
      final item = _localItems[id]!;
      if (item.isExempted) return;
      final max = item.maxValue?.toInt();
      item.count = max != null ? count.clamp(0, max) : count.clamp(0, 9999);
      item.completed = item.count > 0;
    });
    HapticFeedback.lightImpact();
  }

  // ── Points / count (excluding exempted) ───────────────────────────────────

  int get _totalPoints => _localItems.values.fold(0, (s, i) => s + i.points);

  int get _completedCount =>
      _localItems.values.where((i) => i.completed && !i.isExempted).length;

  // ── Save ──────────────────────────────────────────────────────────────────

  Future<void> _save() async {
    setState(() => _saving = true);

    final updates = _localItems.values
        .map((item) => EntryUpdate(
              categoryId: item.categoryId,
              completed: item.isExempted ? false : item.completed,
              prayerMode: item.isExempted ? PrayerMode.missed : item.prayerMode,
              count: item.isExempted ? 0 : item.count,
            ))
        .toList();

    final ok = await ref
        .read(dailyEntryProvider(widget.dateStr).notifier)
        .saveEntryFromUpdates(updates, isExemptDay: _isExemptDay);

    if (ok && mounted) {
      final parts = widget.dateStr.split('-');
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

    print(
      'gender $_isFemale',
    );

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
          icons: _sectionIcons,
          activeIndex: _activeSection,
          catsBySection: widget.catsBySection,
          localItems: _localItems,
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
              localItems: _localItems,
              isTablet: isTablet,
              isFemale: _isFemale,
              isExemptDay: _isExemptDay,
              onToggle: _toggleItem,
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
    final y = int.parse(parts[0]);
    final month = AppConstants.bengaliMonths[m - 1];

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
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Center(
              child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(99))),
            ),
          ),

          // Title row
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
                ],
              )),
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

          // Live points card
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
                  ],
                )),
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
  final Map<String, IconData> icons;
  final int activeIndex;
  final Map<String, List<AmalCategory>> catsBySection;
  final Map<String, _LocalItem> localItems;
  final ValueChanged<int> onTap;

  const _SectionTabBar({
    required this.sections,
    required this.icons,
    required this.activeIndex,
    required this.catsBySection,
    required this.localItems,
    required this.onTap,
  });

  int _completedInSection(String sec) {
    final cats = catsBySection[sec] ?? [];
    return cats
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
              final icon = icons[sec] ?? Icons.circle;
              final done = _completedInSection(sec);
              final total = (catsBySection[sec] ?? []).length;
              final isActive = i == activeIndex;
              final allDone = done == total && total > 0;

              return GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: 180.ms,
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? _C.darkGreen : _C.pageBg,
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(
                      color: isActive
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
                        color: isActive
                            ? Colors.white
                            : allDone
                                ? _C.green
                                : _C.textSecondary),
                    const SizedBox(width: 5),
                    Text(label,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                isActive ? FontWeight.w700 : FontWeight.w500,
                            color: isActive
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
                            color: isActive
                                ? Colors.white.withOpacity(0.2)
                                : allDone
                                    ? _C.greenLight
                                    : _C.pageBg,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text('$done/$total',
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: isActive
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
// EXEMPT DAY BANNER  — only shown for female users in salat section
// ─────────────────────────────────────────────────────────────────────────────

class _ExemptDayBanner extends StatelessWidget {
  final bool isExemptDay;
  final ValueChanged<bool> onToggle;

  const _ExemptDayBanner({
    required this.isExemptDay,
    required this.onToggle,
  });

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
          // Icon badge
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
            child: const Center(
              child: Text('🌸', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isExemptDay ? 'আজ মাহলির দিন' : 'আজ কি মাহলি আছেন?',
                  style: TextStyle(
                    color: isExemptDay ? _C.darkGreen : _C.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isExemptDay
                      ? 'ফরজ আমলগুলো মাফ হিসেবে চিহ্নিত হয়েছে'
                      : 'চালু করলে ফরজ আমলগুলো মাফ ধরা হবে',
                  style: TextStyle(
                    color: isExemptDay ? _C.midGreen : _C.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Animated toggle switch
          _ToggleSwitch(
            value: isExemptDay,
            onChanged: onToggle,
            activeColor: _C.midGreen,
          ),
        ]),
      ),
    ).animate().fadeIn(duration: 220.ms).slideY(begin: -0.04);
  }
}

// Smooth animated toggle switch
class _ToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;

  const _ToggleSwitch({
    required this.value,
    required this.onChanged,
    required this.activeColor,
  });

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
          borderRadius: BorderRadius.circular(99),
        ),
        child: AnimatedAlign(
          duration: 200.ms,
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
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
  final bool isTablet;
  final bool isFemale;
  final bool isExemptDay;
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
            style: TextStyle(color: _C.textHint, fontSize: 13)),
      );
    }

    final hPad =
        isTablet ? (MediaQuery.of(context).size.width - 600) / 2 + 16.0 : 16.0;

    // Show exempt banner only in salat section for female users
    final showBanner = isFemale && sectionKey == 'salat';

    // Total list items = banner (if shown) + categories
    final itemCount = categories.length + (showBanner ? 1 : 0);

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 14),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) {
        // First item = banner when applicable
        if (showBanner && i == 0) {
          return _ExemptDayBanner(
            isExemptDay: isExemptDay,
            onToggle: onExemptToggle,
          );
        }

        final catIndex = showBanner ? i - 1 : i;
        final cat = categories[catIndex];
        final item = localItems[cat.id];
        final isExempted = item?.isExempted ?? false;

        // ── Route card type ──────────────────────────────────────
        late Widget card;

        if (cat.isPrayer) {
          if (isExempted) {
            // Show exempted card — no interaction
            card = _ExemptedPrayerCard(cat: cat);
          } else {
            card = _PrayerFormCard(
              cat: cat,
              item: item,
              onMode: (mode) => onPrayerMode(cat.id, mode),
            );
          }
        } else if (cat.inputType == AmalInputType.counter) {
          card = _CounterFormCard(
            cat: cat,
            item: item,
            onCount: (c) => onCount(cat.id, c),
          );
        } else {
          card = _ToggleFormCard(
            cat: cat,
            item: item,
            onToggle: (v) => onToggle(cat.id, v),
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
// EXEMPTED PRAYER CARD  — shown instead of normal prayer card on exempt day
// ─────────────────────────────────────────────────────────────────────────────

class _ExemptedPrayerCard extends StatelessWidget {
  final AmalCategory cat;

  const _ExemptedPrayerCard({required this.cat});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.pageBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 0.5),
      ),
      child: Opacity(
        opacity: 0.55,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            // Icon badge — muted
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

            // Name with strikethrough
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cat.nameBn,
                    style: const TextStyle(
                      color: _C.textHint,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: _C.textHint,
                    ),
                  ),
                  Text(cat.nameEn,
                      style: const TextStyle(color: _C.textHint, fontSize: 11)),
                ],
              ),
            ),

            // Maaf badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _C.maafBg,
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: _C.green.withOpacity(0.3), width: 0.5),
              ),
              child: const Text(
                'মাফ আছে',
                style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: _C.maafText),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRAYER FORM CARD
// ─────────────────────────────────────────────────────────────────────────────

class _PrayerFormCard extends StatelessWidget {
  final AmalCategory cat;
  final _LocalItem? item;
  final ValueChanged<PrayerMode> onMode;

  const _PrayerFormCard({
    required this.cat,
    required this.item,
    required this.onMode,
  });

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
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 13, 14, 11),
          child: Row(children: [
            _AmalIconBadge(
                icon: Icons.mosque_rounded,
                active: mode != PrayerMode.missed,
                activeColor: _C.green),
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
                    style:
                        const TextStyle(color: _C.textSecondary, fontSize: 11)),
              ],
            )),
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
// TOGGLE FORM CARD  (binary)
// ─────────────────────────────────────────────────────────────────────────────

class _ToggleFormCard extends StatelessWidget {
  final AmalCategory cat;
  final _LocalItem? item;
  final ValueChanged<bool> onToggle;

  const _ToggleFormCard({
    required this.cat,
    required this.item,
    required this.onToggle,
  });

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
                    style:
                        const TextStyle(color: _C.textSecondary, fontSize: 11)),
              ],
            ],
          )),
          const SizedBox(width: 8),
          _PtsTag(pts: pts, maxPts: cat.basePoints, active: done),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COUNTER FORM CARD
// ─────────────────────────────────────────────────────────────────────────────

class _CounterFormCard extends StatelessWidget {
  final AmalCategory cat;
  final _LocalItem? item;
  final ValueChanged<int> onCount;

  const _CounterFormCard({
    required this.cat,
    required this.item,
    required this.onCount,
  });

  @override
  Widget build(BuildContext context) {
    final count = item?.count ?? 0;
    final pts = item?.points ?? 0;
    final unitBn = _unitLabelBn(cat.unit);
    final maxVal = cat.maxValue?.toInt();
    final ppu = cat.pointsPerUnit ?? cat.basePoints.toDouble();
    final maxPts = maxVal != null ? (maxVal * ppu).round() : null;
    final hasMax = maxVal != null;

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
            _AmalIconBadge(
                icon: Icons.add_circle_outline_rounded,
                active: count > 0,
                activeColor: _C.darkGreen),
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
              ],
            )),
            _CounterPtsTag(
              current: pts,
              max: maxPts,
              active: count > 0,
            ),
          ]),
        ),
        const Divider(height: 0.5, thickness: 0.5, color: _C.border),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _StepBtn(
            icon: Icons.remove_rounded,
            onTap: count > 0 ? () => onCount(count - 1) : null,
          ),
          Container(
            width: 96,
            height: 78,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                color: count > 0 ? _C.greenLight : _C.pageBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: count > 0 ? _C.green.withOpacity(0.3) : _C.border,
                    width: 0.5)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$count',
                    style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        color: count > 0 ? _C.darkGreen : _C.textHint)),
                const SizedBox(height: 3),
                Text(hasMax ? '/ $maxVal $unitBn' : unitBn,
                    style: TextStyle(
                        fontSize: 10,
                        color: count > 0 ? _C.textSecondary : _C.textHint)),
              ],
            ),
          ),
          _StepBtn(
            icon: Icons.add_rounded,
            onTap:
                (hasMax && count >= maxVal!) ? null : () => onCount(count + 1),
          ),
        ]),
        const SizedBox(height: 14),
        if (hasMax) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _BoundedProgress(count: count, max: maxVal!),
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _UnboundedProgress(count: count, unitBn: unitBn),
          ),
        ],
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

class _BoundedProgress extends StatelessWidget {
  final int count, max;
  const _BoundedProgress({required this.count, required this.max});

  @override
  Widget build(BuildContext context) {
    final dotCount = max.clamp(1, 15);
    final fillRatio = max > 15 ? count / max : null;

    if (fillRatio != null) {
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
              value: fillRatio.clamp(0.0, 1.0),
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
      children: List.generate(dotCount, (i) {
        return AnimatedContainer(
          duration: 140.ms,
          width: max <= 7 ? 28 : 22,
          height: 7,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
              color: i < count ? _C.darkGreen : _C.border,
              borderRadius: BorderRadius.circular(99)),
        );
      }),
    );
  }
}

class _UnboundedProgress extends StatelessWidget {
  final int count;
  final String unitBn;
  const _UnboundedProgress({required this.count, required this.unitBn});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
      ],
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _StepBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
            color: onTap != null ? _C.greenLight : _C.pageBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: onTap != null ? _C.green.withOpacity(0.3) : _C.border,
                width: 0.5)),
        child: Icon(icon,
            color: onTap != null ? _C.darkGreen : _C.textHint, size: 24),
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
        border: Border(top: BorderSide(color: _C.border, width: 0.5)),
      ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                ],
              ),
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

class _AmalIconBadge extends StatelessWidget {
  final IconData icon;
  final bool active;
  final Color activeColor;
  const _AmalIconBadge(
      {required this.icon, required this.active, required this.activeColor});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 180.ms,
      width: 38,
      height: 38,
      decoration: BoxDecoration(
          color: active ? activeColor.withOpacity(0.1) : _C.pageBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: active ? activeColor.withOpacity(0.25) : _C.border,
              width: 0.5)),
      child: Icon(icon, size: 18, color: active ? activeColor : _C.textHint),
    );
  }
}

class _PtsTag extends StatelessWidget {
  final int pts, maxPts;
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
      child: Text(active ? '+$pts pts' : '$maxPts pts',
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

// ─────────────────────────────────────────────────────────────────────────────
// LOCAL ITEM MODEL
// ─────────────────────────────────────────────────────────────────────────────

class _LocalItem {
  final String categoryId;
  final int basePoints, congPoints;
  final bool isExemptDuringPeriod;
  final bool isPrayer;
  final bool isFard; // ← from backend
  final AmalInputType inputType;
  final double? pointsPerUnit;
  final num? maxValue;
  bool completed;
  bool isExempted; // ← true when female + exemptDay + isFard
  PrayerMode? prayerMode;
  int count;

  _LocalItem({
    required this.categoryId,
    required this.isPrayer,
    required this.isFard,
    required this.isExemptDuringPeriod,
    required this.inputType,
    required this.basePoints,
    required this.congPoints,
    required this.completed,
    this.pointsPerUnit,
    this.maxValue,
    this.prayerMode,
    this.count = 0,
    this.isExempted = false,
  });

  int get points {
    // Exempted items always return 0 points
    if (isExempted) return 0;

    if (isPrayer) {
      if (prayerMode == PrayerMode.congregation) return congPoints;
      if (prayerMode == PrayerMode.solo) return basePoints;
      return 0;
    }
    if (inputType == AmalInputType.counter) {
      return (count * (pointsPerUnit ?? basePoints.toDouble())).round();
    }
    if (!completed) return 0;
    return basePoints;
  }
}
