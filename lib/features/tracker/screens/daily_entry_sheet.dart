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
  fardPrayer, // ফজর/যোহর/আসর/মাগরিব/এশা — congregation/solo/missed
  rakaatCounter, // বিতর/তাহাজ্জুদ/ইশরাক/চাশত — রাকাত counter
  sunnahToggle, // সুন্নত নামাজ — binary done/not-done
  genericCounter, // কুরআন তিলাওয়াত/দরুদ/রোজা — count
  genericToggle, // সব binary আমল
}

_CardType _resolveCardType(AmalCategory cat) {
  if (cat.isPrayer) {
    if (cat.isFard) return _CardType.fardPrayer;
    if (cat.inputType == AmalInputType.counter) return _CardType.rakaatCounter;
    return _CardType.sunnahToggle;
  }
  if (cat.inputType == AmalInputType.counter ||
      cat.inputType == AmalInputType.duration) {
    return _CardType.genericCounter;
  }
  return _CardType.genericToggle;
}

bool _isWitr(AmalCategory cat) => cat.key == 'witr';
int _rakaatStep(AmalCategory cat) => 2;
int _rakaatMin(AmalCategory cat) =>
    (cat.minValue ?? (_isWitr(cat) ? 1.0 : 2.0)).toInt();

// ─────────────────────────────────────────────────────────────────────────────
// LOCAL ITEM  — points নেই, শুধু input state
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

  // সম্পন্ন হয়েছে কিনা তার একটা একক indicator
  bool get isDone {
    if (isExempted) return false;
    switch (_resolveCardType(cat)) {
      case _CardType.fardPrayer:
        return prayerMode == PrayerMode.congregation ||
            prayerMode == PrayerMode.solo;
      case _CardType.rakaatCounter:
      case _CardType.genericCounter:
        return count > 0;
      case _CardType.sunnahToggle:
      case _CardType.genericToggle:
        return completed;
    }
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
  late Map<String, _LocalItem> _items;
  late DateTime _selectedDate;
  bool _saving = false;
  int _activeSection = 0;
  bool _isExemptDay = false;
  bool _isFemale = false;

  List<String> get _activeSections => AppConstants.sections
      .map((s) => s.key)
      .where((k) => (widget.catsBySection[k] ?? []).isNotEmpty)
      .toList();

  IconData _sectionIcon(String key) => AppConstants.sections
      .firstWhere(
        (s) => s.key == key,
        orElse: () =>
            SectionMeta(key: key, labelBn: key, labelEn: key, iconKey: ''),
      )
      .icon;

  @override
  void initState() {
    super.initState();
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

  // ── Completed count — points এর বদলে এটাই header এ দেখাবে ───────────────
  int get _completedCount => _items.values.where((i) => i.isDone).length;

  // ── Fard prayer summary for header ───────────────────────────────────────
  // কতটা fard prayer করা হয়েছে এই session এ
  ({int done, int total, int jamaat}) get _fardSummary {
    final fardItems =
        _items.values.where((i) => i.cat.isPrayer && i.cat.isFard).toList();
    final done = fardItems.where((i) => i.isDone).length;
    final jamaat =
        fardItems.where((i) => i.prayerMode == PrayerMode.congregation).length;
    return (done: done, total: fardItems.length, jamaat: jamaat);
  }

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final sections = _activeSections;
    final fard = _fardSummary;

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
          completedCount: _completedCount,
          fardDone: fard.done,
          fardTotal: fard.total,
          jamaatCount: fard.jamaat,
          saving: _saving,
          onClose: () => Navigator.pop(context),
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
          completedCount: _completedCount,
          onSave: _save,
          onCancel: () => Navigator.pop(context),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHEET HEADER — points বাদ, completion summary দেখাচ্ছে
// ─────────────────────────────────────────────────────────────────────────────

class _SheetHeader extends StatelessWidget {
  final bool isNew, saving;
  final String dateStr;
  final int completedCount, fardDone, fardTotal, jamaatCount;
  final VoidCallback onClose;

  const _SheetHeader({
    required this.isNew,
    required this.saving,
    required this.dateStr,
    required this.completedCount,
    required this.fardDone,
    required this.fardTotal,
    required this.jamaatCount,
    required this.onClose,
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
          // drag handle
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
          // title row
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
          // live summary row — points এর বদলে completion stats
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.18), width: 0.5)),
              child: Row(children: [
                // completed icon
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(11)),
                  child: const Icon(Icons.checklist_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                // completed count
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('সম্পন্ন আমল',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 10)),
                      const SizedBox(height: 1),
                      Text('$completedCount টি',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              letterSpacing: -0.3,
                              height: 1)),
                    ])),
                // fard prayer chip
                if (fardTotal > 0) ...[
                  _HeaderChip(
                    icon: Icons.mosque_rounded,
                    label: '$fardDone/$fardTotal ফরজ',
                    active: fardDone > 0,
                  ),
                  const SizedBox(width: 6),
                ],
                // jamaat chip
                if (jamaatCount > 0)
                  _HeaderChip(
                    icon: Icons.people_rounded,
                    label: '$jamaatCount জামাত',
                    active: true,
                  ),
              ]),
            ),
          ),
        ]),
      ]),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  const _HeaderChip(
      {required this.icon, required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
          color: active
              ? Colors.white.withOpacity(0.15)
              : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: Colors.white.withOpacity(0.7), size: 11),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 10.5,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION TAB BAR
// ─────────────────────────────────────────────────────────────────────────────

class _SectionTabBar extends StatelessWidget {
  final List<String> sections;
  final IconData Function(String) sectionIcon;
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

  int _doneIn(String sec) => (catsBySection[sec] ?? [])
      .where((c) => localItems[c.id]?.isDone == true)
      .length;

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
              final icon = sectionIcon(sec);
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
                : const Color(0xFFD4A843).withOpacity(0.5),
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
                  : const Color(0xFFD4A843).withOpacity(0.15),
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
  final DateTime selectedDate;
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

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(hPad, 14, hPad, 14),
      itemCount: categories.length + (showBanner ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, idx) {
        // Banner — female + salat
        if (showBanner && idx == 0) {
          return _ExemptDayBanner(
              isExemptDay: isExemptDay, onToggle: onExemptToggle);
        }

        final catIndex = showBanner ? idx - 1 : idx;
        final cat = categories[catIndex];
        final item = localItems[cat.id];

        // ── Juma / Zuhr day+gender logic ─────────────────────────────────
        final isFriday = selectedDate.weekday == 5; // Flutter: Mon=1…Sun=7
        final isMale = !isFemale;
        final isJuma = cat.key == 'juma_prayer';
        final isZuhr = cat.key == 'zuhr';

        String? extraBadge;
        bool forceNotApplicable = false;
        String notApplicableLabel = 'আজ প্রযোজ্য নয়';

        if (isZuhr && isMale && isFriday) {
          forceNotApplicable = true;
          notApplicableLabel = 'জুমুআর দিন যোহর নেই';
        } else if (isJuma) {
          if (!isFriday) {
            forceNotApplicable = true;
            notApplicableLabel = 'শুধু শুক্রবার';
          } else if (isFemale) {
            extraBadge = 'ঐচ্ছিক';
          }
        }

        // ── Card ─────────────────────────────────────────────────────────
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

        // ── Applicable day check ──────────────────────────────────────────
        final isApplicable =
            !forceNotApplicable && cat.isApplicableOn(selectedDate);

        if (!isApplicable) {
          card = IgnorePointer(
            child: Stack(children: [
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
                  child: Text(notApplicableLabel,
                      style: const TextStyle(
                          fontSize: 9.5,
                          color: _C.textHint,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ]),
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
// CARD 1 — EXEMPTED (female hayez day)
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
// CARD 2 — FARD PRAYER  (congregation / solo / missed)
// points badge নেই — mode badge মাত্র
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
            // mode badge
            _ModeBadge(mode: mode),
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
                    icon: Icons.people_rounded,
                    isSelected: mode == PrayerMode.congregation,
                    activeColor: _C.green,
                    activeBg: _C.greenLight,
                    onTap: () => onMode(PrayerMode.congregation))),
            const SizedBox(width: 8),
            Expanded(
                child: _ModeBtn(
                    label: 'একাকী',
                    icon: Icons.person_rounded,
                    isSelected: mode == PrayerMode.solo,
                    activeColor: _C.amber,
                    activeBg: _C.amberLight,
                    onTap: () => onMode(PrayerMode.solo))),
            const SizedBox(width: 8),
            Expanded(
                child: _ModeBtn(
                    label: 'মিস',
                    icon: Icons.close_rounded,
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

class _ModeBadge extends StatelessWidget {
  final PrayerMode mode;
  const _ModeBadge({required this.mode});

  @override
  Widget build(BuildContext context) {
    if (mode == PrayerMode.missed) return const SizedBox.shrink();
    final color = mode == PrayerMode.congregation ? _C.green : _C.amber;
    final bg = color.withOpacity(0.1);
    final label = mode == PrayerMode.congregation ? 'জামাতে ✓' : 'একাকী ✓';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 10.5, fontWeight: FontWeight.w700)),
    );
  }
}

class _ModeBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color activeColor, activeBg;
  final VoidCallback onTap;
  const _ModeBtn({
    required this.label,
    required this.icon,
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: isSelected ? activeBg : _C.pageBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isSelected ? activeColor : _C.border,
                width: isSelected ? 1.5 : 0.5)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 18, color: isSelected ? activeColor : _C.textHint),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? activeColor : _C.textSecondary)),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD 3 — RAKAAT COUNTER (witr odd / nafl even)
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
    final isWitr = _isWitr(cat);
    final minVal = _rakaatMin(cat);
    final maxVal = cat.maxValue?.toInt();
    final hint =
        isWitr ? 'বেজোড় রাকাত — ১, ৩, ৫, ৭, ৯' : 'জোড় রাকাত — ২, ৪, ৬, ৮…';

    return Container(
      decoration: BoxDecoration(
          color: _C.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: count > 0 ? _C.green.withOpacity(0.4) : _C.border,
              width: count > 0 ? 1.5 : 0.5)),
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
            // count badge
            if (count > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                    color: _C.greenLight,
                    borderRadius: BorderRadius.circular(20)),
                child: Text('$count রাকাত',
                    style: const TextStyle(
                        color: _C.darkGreen,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700)),
              ),
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
          _CounterDisplay(count: count, unit: 'রাকাত', max: maxVal),
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
              child: _WitrDots(count: count))
        else
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _UnboundedProgress(count: count, unitBn: 'রাকাত')),
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
  final String? badgeLabel;
  const _SunnahToggleCard(
      {required this.cat,
      required this.item,
      required this.onToggle,
      this.badgeLabel});

  @override
  Widget build(BuildContext context) {
    final done = item?.completed ?? false;

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
          if (badgeLabel != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFF8EE),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFFD4A843).withOpacity(0.5),
                      width: 0.5)),
              child: Text(badgeLabel!,
                  style: const TextStyle(
                      fontSize: 9.5,
                      color: Color(0xFFD4A843),
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD 5 — GENERIC COUNTER (quran/dhikr/fasting)
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
    final unitBn = _unitLabelBn(cat.unit);
    final maxVal = cat.maxValue?.toInt();

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
            // count badge — মোট count দেখাও
            if (count > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                    color: _C.greenLight,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                    maxVal != null
                        ? '$count / $maxVal $unitBn'
                        : '$count $unitBn',
                    style: const TextStyle(
                        color: _C.darkGreen,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700)),
              ),
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
          _CounterDisplay(count: count, unit: unitBn, max: maxVal),
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
          // done badge
          if (done) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: _C.greenLight,
                  borderRadius: BorderRadius.circular(20)),
              child: const Text('সম্পন্ন',
                  style: TextStyle(
                      color: _C.darkGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM SAVE BAR — points বাদ, completed count দেখাচ্ছে
// ─────────────────────────────────────────────────────────────────────────────

class _BottomSaveBar extends StatelessWidget {
  final bool isNew, saving;
  final int completedCount;
  final VoidCallback onSave, onCancel;

  const _BottomSaveBar({
    required this.isNew,
    required this.saving,
    required this.completedCount,
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
                          ? 'সেভ করুন  ($completedCount টি সম্পন্ন)'
                          : 'আপডেট করুন  ($completedCount টি সম্পন্ন)',
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

class _CounterDisplay extends StatelessWidget {
  final int count;
  final String unit;
  final int? max;
  const _CounterDisplay({required this.count, required this.unit, this.max});

  @override
  Widget build(BuildContext context) {
    final active = count > 0;
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
          count > 0 ? '$count $unitBn যোগ করা হয়েছে' : 'যত বেশি, তত বেশি বরকত',
          style: TextStyle(
              color: count > 0 ? _C.darkGreen : _C.textHint,
              fontSize: 11,
              fontWeight: FontWeight.w500)),
    ]);
  }
}
