import 'package:amal_tracker/features/notification/model/notification_setting_model.dart';
import 'package:amal_tracker/features/notification/provider/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS — mirrors your SettingsScreen _C exactly
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
  static const red = Color(0xFFEF4444);
  static const redLight = Color(0xFFFEF2F2);
  static const orange = Color(0xFFEA580C);
  static const orangeLight = Color(0xFFFFF0EB);
  static const teal = Color(0xFF0D9488);
  static const tealLight = Color(0xFFCCFBF1);
  static const border = Color(0xFFE4EAE4);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  NotificationSettings? _draft;
  bool _isSaving = false;

  NotificationSettings get _current =>
      _draft ??
      ref.read(notificationSettingsProvider).valueOrNull ??
      const NotificationSettings();

  void _patch(NotificationSettings updated) {
    HapticFeedback.selectionClick();
    setState(() => _draft = updated);
  }

  Future<void> _save() async {
    if (_draft == null) return;
    HapticFeedback.mediumImpact();
    setState(() => _isSaving = true);
    await ref
        .read(notificationSettingsProvider.notifier)
        .updateSettings(_draft!);
    setState(() {
      _isSaving = false;
      _draft = null;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Row(children: [
          Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
          SizedBox(width: 8),
          Text('সেটিংস সংরক্ষিত হয়েছে'),
        ]),
        backgroundColor: _C.darkGreen,
        margin: const EdgeInsets.all(16),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  Future<TimeOfDay?> _pickTime(TimeOfDay initial) => showTimePicker(
        context: context,
        initialTime: initial,
        builder: (ctx, child) => Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(primary: _C.darkGreen),
          ),
          child: child!,
        ),
      );

  String _fmt(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m ${t.period == DayPeriod.am ? 'AM' : 'PM'}';
  }

  static const _weekdays = [
    'সোমবার',
    'মঙ্গলবার',
    'বুধবার',
    'বৃহস্পতিবার',
    'শুক্রবার',
    'শনিবার',
    'রবিবার',
  ];
  static const _weekdaysShort = [
    'সোম',
    'মঙ্গল',
    'বুধ',
    'বৃহ',
    'শুক্র',
    'শনি',
    'রবি',
  ];

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(notificationSettingsProvider);
    final permAsync = ref.watch(notificationPermissionProvider);

    return settingsAsync.when(
      loading: () => const Scaffold(
        backgroundColor: _C.bg,
        body: Center(child: CircularProgressIndicator(color: _C.darkGreen)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: _C.bg,
        body: Center(child: Text('ত্রুটি: $e')),
      ),
      // skipLoadingOnReload: subsequent saves never blank the screen
      // even if loading state is accidentally set elsewhere
      skipLoadingOnReload: true,
      data: (_) {
        final s = _current;
        final hasPermission = permAsync.valueOrNull ?? false;

        return Scaffold(
          backgroundColor: _C.bg,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── App Bar ─────────────────────────────────────────
              SliverAppBar(
                pinned: true,
                backgroundColor: _C.darkGreen,
                surfaceTintColor: Colors.transparent,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                expandedHeight: 110,
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
                // Save action — only visible when draft exists
                actions: [
                  if (_draft != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _isSaving
                          ? const Center(
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              ),
                            )
                          : GestureDetector(
                              onTap: _save,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.3)),
                                ),
                                child: const Text('সংরক্ষণ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                    ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Container(
                    color: _C.darkGreen,
                    child: Stack(children: [
                      Positioned(
                        top: -24,
                        right: -24,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 60,
                        right: 20,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.04),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('নোটিফিকেশন',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.4)),
                            Text('রিমাইন্ডার ও সময়সূচী',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ),

              // ── Body ────────────────────────────────────────────
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                    20, 20, 20, MediaQuery.of(context).padding.bottom + 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Permission banner
                    if (!hasPermission)
                      _PermissionBanner(
                        onAllow: () => ref
                            .read(notificationPermissionProvider.notifier)
                            .requestPermission(),
                      ).animate().fadeIn(duration: 260.ms),

                    // ── অ্যাপ নোটিফিকেশন ───────────────────────
                    _GroupLabel(label: 'অ্যাপ নোটিফিকেশন')
                        .animate()
                        .fadeIn(duration: 260.ms),
                    const SizedBox(height: 8),
                    _SettingsCard(children: [
                      _ToggleTile(
                        icon: Icons.notifications_rounded,
                        iconBg: _C.blueLight,
                        iconColor: _C.blue,
                        title: 'পুশ নোটিফিকেশন',
                        subtitle: 'অ্যাপের আপডেট ও ঘোষণা',
                        value: s.pushNotificationsEnabled,
                        onChanged: (_) => _patch(s.copyWith(
                            pushNotificationsEnabled:
                                !s.pushNotificationsEnabled)),
                      ),
                      _Divider(),
                      _ToggleTile(
                        icon: Icons.volume_up_rounded,
                        iconBg: _C.amberLight,
                        iconColor: _C.amber,
                        title: 'শব্দ',
                        subtitle: 'নোটিফিকেশনে শব্দ বাজবে',
                        value: s.soundEnabled,
                        onChanged: (_) =>
                            _patch(s.copyWith(soundEnabled: !s.soundEnabled)),
                      ),
                      _Divider(),
                      _ToggleTile(
                        icon: Icons.vibration_rounded,
                        iconBg: _C.bg,
                        iconColor: _C.textSecondary,
                        title: 'ভাইব্রেশন',
                        subtitle: 'বিজ্ঞপ্তির সময় কম্পন হবে',
                        value: s.vibrationEnabled,
                        onChanged: (_) => _patch(
                            s.copyWith(vibrationEnabled: !s.vibrationEnabled)),
                      ),
                    ]).animate().fadeIn(delay: 60.ms),

                    const SizedBox(height: 20),

                    // ── দৈনিক আমল রিমাইন্ডার ────────────────────
                    _GroupLabel(label: 'দৈনিক আমল রিমাইন্ডার')
                        .animate()
                        .fadeIn(delay: 80.ms),
                    const SizedBox(height: 8),
                    _SettingsCard(children: [
                      _ToggleTile(
                        icon: Icons.auto_awesome_rounded,
                        iconBg: _C.purpleLight,
                        iconColor: _C.purple,
                        title: 'রিমাইন্ডার চালু',
                        subtitle: 'প্রতিদিন আমল লগ করার স্মরণ',
                        value: s.dailyReminderEnabled,
                        onChanged: (_) => _patch(s.copyWith(
                            dailyReminderEnabled: !s.dailyReminderEnabled)),
                      ),
                      if (s.dailyReminderEnabled) ...[
                        _Divider(),
                        _TimeTile(
                          icon: Icons.access_time_rounded,
                          iconBg: _C.greenLight,
                          iconColor: _C.darkGreen,
                          title: 'রিমাইন্ডারের সময়',
                          time: _fmt(s.dailyReminderTime),
                          onTap: () async {
                            final t = await _pickTime(s.dailyReminderTime);
                            if (t != null)
                              _patch(s.copyWith(dailyReminderTime: t));
                          },
                        ),
                        _Divider(),
                        _EditTile(
                          icon: Icons.edit_note_rounded,
                          iconBg: _C.purpleLight,
                          iconColor: _C.purple,
                          title: 'বার্তা কাস্টমাইজ',
                          value: s.dailyReminderMessage,
                          hint: 'আমল লগ করার বার্তা লিখুন...',
                          onSaved: (v) =>
                              _patch(s.copyWith(dailyReminderMessage: v)),
                        ),
                      ],
                    ]).animate().fadeIn(delay: 100.ms),

                    const SizedBox(height: 20),

                    // ── স্ট্রিক অ্যালার্ট ────────────────────────
                    _GroupLabel(label: 'স্ট্রিক অ্যালার্ট')
                        .animate()
                        .fadeIn(delay: 120.ms),
                    const SizedBox(height: 8),
                    _SettingsCard(children: [
                      _ToggleTile(
                        icon: Icons.local_fire_department_rounded,
                        iconBg: _C.orangeLight,
                        iconColor: _C.orange,
                        title: 'স্ট্রিক অ্যালার্ট চালু',
                        subtitle: "দিন শেষের আগে মনে করাবে",
                        value: s.streakAlertEnabled,
                        onChanged: (_) => _patch(s.copyWith(
                            streakAlertEnabled: !s.streakAlertEnabled)),
                      ),
                      if (s.streakAlertEnabled) ...[
                        _Divider(),
                        _TimeTile(
                          icon: Icons.access_time_rounded,
                          iconBg: _C.greenLight,
                          iconColor: _C.darkGreen,
                          title: 'অ্যালার্টের সময়',
                          time: _fmt(s.streakAlertTime),
                          onTap: () async {
                            final t = await _pickTime(s.streakAlertTime);
                            if (t != null)
                              _patch(s.copyWith(streakAlertTime: t));
                          },
                        ),
                        _Divider(),
                        _InfoTile(
                          icon: Icons.local_fire_department_rounded,
                          iconBg: _C.orangeLight,
                          iconColor: _C.orange,
                          title: 'বর্তমান স্ট্রিক',
                          trailing: '${s.currentStreak} দিন',
                          trailingColor: _C.orange,
                        ),
                      ],
                    ]).animate().fadeIn(delay: 140.ms),

                    const SizedBox(height: 20),

                    // ── সাপ্তাহিক রিভিউ ──────────────────────────
                    _GroupLabel(label: 'সাপ্তাহিক রিভিউ')
                        .animate()
                        .fadeIn(delay: 160.ms),
                    const SizedBox(height: 8),
                    _SettingsCard(children: [
                      _ToggleTile(
                        icon: Icons.bar_chart_rounded,
                        iconBg: _C.tealLight,
                        iconColor: _C.teal,
                        title: 'সাপ্তাহিক রিভিউ চালু',
                        subtitle: 'সাপ্তাহিক আমলের সারসংক্ষেপ',
                        value: s.weeklyReviewEnabled,
                        onChanged: (_) => _patch(s.copyWith(
                            weeklyReviewEnabled: !s.weeklyReviewEnabled)),
                      ),
                      if (s.weeklyReviewEnabled) ...[
                        _Divider(),
                        _DropdownTile(
                          icon: Icons.calendar_month_rounded,
                          iconBg: _C.tealLight,
                          iconColor: _C.teal,
                          title: 'রিভিউর দিন',
                          value: _weekdays[s.weeklyReviewWeekday - 1],
                          items: _weekdays,
                          onChanged: (v) {
                            if (v == null) return;
                            _patch(s.copyWith(
                                weeklyReviewWeekday: _weekdays.indexOf(v) + 1));
                          },
                        ),
                        _Divider(),
                        _TimeTile(
                          icon: Icons.access_time_rounded,
                          iconBg: _C.greenLight,
                          iconColor: _C.darkGreen,
                          title: 'রিভিউর সময়',
                          time: _fmt(s.weeklyReviewTime),
                          onTap: () async {
                            final t = await _pickTime(s.weeklyReviewTime);
                            if (t != null)
                              _patch(s.copyWith(weeklyReviewTime: t));
                          },
                        ),
                      ],
                    ]).animate().fadeIn(delay: 180.ms),

                    const SizedBox(height: 20),

                    // ── সক্রিয় সময়সূচী কার্ড ────────────────────
                    _ActiveScheduleCard(
                      s: s,
                      fmt: _fmt,
                      weekdaysShort: _weekdaysShort,
                    ).animate().fadeIn(delay: 200.ms),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED COMPONENTS — same design language as SettingsScreen
// ─────────────────────────────────────────────────────────────────────────────

class _GroupLabel extends StatelessWidget {
  final String label;
  const _GroupLabel({required this.label});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: _C.textHint,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
          ),
        ),
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
          border: Border.all(color: _C.border, width: 0.5),
        ),
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

// ─── Toggle Tile — matches SettingsScreen _ToggleTile exactly ────────────────
class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: _C.textPrimary,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700)),
                Text(subtitle,
                    style:
                        const TextStyle(color: _C.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          _Toggle(value: value, onChanged: onChanged),
        ]),
      );
}

// ─── Custom Toggle — identical to SettingsScreen _Toggle ─────────────────────
class _Toggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Toggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: 200.ms,
          width: 46,
          height: 26,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: value ? _C.midGreen : _C.border,
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
                  color: Colors.white, shape: BoxShape.circle),
            ),
          ),
        ),
      );
}

// ─── Time Tile ────────────────────────────────────────────────────────────────
class _TimeTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String title, time;
  final VoidCallback onTap;

  const _TimeTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.time,
    required this.onTap,
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
                      fontWeight: FontWeight.w700)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _C.greenLight,
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: _C.green.withOpacity(0.3), width: 0.5),
              ),
              child: Text(time,
                  style: const TextStyle(
                      color: _C.darkGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3)),
            ),
          ]),
        ),
      );
}

// ─── Dropdown Tile ────────────────────────────────────────────────────────────
class _DropdownTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String title, value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                    fontWeight: FontWeight.w700)),
          ),
          DropdownButton<String>(
            value: value,
            underline: const SizedBox.shrink(),
            borderRadius: BorderRadius.circular(12),
            dropdownColor: _C.card,
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: _C.textHint, size: 18),
            style: const TextStyle(
                color: _C.darkGreen, fontSize: 13, fontWeight: FontWeight.w700),
            items: items
                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                .toList(),
            onChanged: onChanged,
          ),
        ]),
      );
}

// ─── Editable Tile ────────────────────────────────────────────────────────────
class _EditTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String title, value, hint;
  final ValueChanged<String> onSaved;

  const _EditTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.hint,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _openDialog(context),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: _C.textPrimary,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700)),
                  Text(value,
                      style: const TextStyle(
                          color: _C.textSecondary, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: _C.textHint, size: 18),
          ]),
        ),
      );

  void _openDialog(BuildContext ctx) {
    final ctrl = TextEditingController(text: value);
    showDialog(
      context: ctx,
      builder: (d) => AlertDialog(
        backgroundColor: _C.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: _C.textPrimary)),
        content: TextField(
          controller: ctrl,
          maxLines: 3,
          maxLength: 120,
          autofocus: true,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: _C.textHint),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _C.darkGreen, width: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d),
            child: const Text('বাতিল',
                style: TextStyle(
                    color: _C.textSecondary, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () {
              final v = ctrl.text.trim();
              if (v.isNotEmpty) onSaved(v);
              Navigator.pop(d);
            },
            style: TextButton.styleFrom(
              backgroundColor: _C.greenLight,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('সংরক্ষণ',
                style: TextStyle(
                    color: _C.darkGreen, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ─── Info Tile (read-only) ────────────────────────────────────────────────────
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String title;
  final String? trailing;
  final Color? trailingColor;

  const _InfoTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    this.trailing,
    this.trailingColor,
  });

  @override
  Widget build(BuildContext context) => Padding(
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
                style: TextStyle(
                    color: trailingColor ?? _C.textHint,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
        ]),
      );
}

// ─── Permission Banner ────────────────────────────────────────────────────────
class _PermissionBanner extends StatelessWidget {
  final VoidCallback onAllow;
  const _PermissionBanner({required this.onAllow});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _C.amber.withOpacity(0.35), width: 0.5),
        ),
        child: Row(children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: _C.amberLight, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.notifications_off_rounded,
                color: _C.amber, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('নোটিফিকেশন বন্ধ আছে',
                    style: TextStyle(
                        color: _C.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
                Text('আমল রিমাইন্ডার পেতে অনুমতি দিন।',
                    style: TextStyle(color: _C.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onAllow,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _C.darkGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('অনুমতি দিন',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
      );
}

// ─── Active Schedule Card ─────────────────────────────────────────────────────
class _ActiveScheduleCard extends StatelessWidget {
  final NotificationSettings s;
  final String Function(TimeOfDay) fmt;
  final List<String> weekdaysShort;

  const _ActiveScheduleCard({
    required this.s,
    required this.fmt,
    required this.weekdaysShort,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _C.darkGreen,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.schedule_rounded,
                    color: Colors.white70, size: 14),
              ),
              const SizedBox(width: 8),
              const Text('সক্রিয় সময়সূচী',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 14),
            _SchedRow(
              icon: Icons.auto_awesome_rounded,
              label: 'দৈনিক আমল',
              pill: s.dailyReminderEnabled ? fmt(s.dailyReminderTime) : 'বন্ধ',
              on: s.dailyReminderEnabled,
            ),
            const SizedBox(height: 8),
            _SchedRow(
              icon: Icons.local_fire_department_rounded,
              label: 'স্ট্রিক অ্যালার্ট',
              pill: s.streakAlertEnabled ? fmt(s.streakAlertTime) : 'বন্ধ',
              on: s.streakAlertEnabled,
            ),
            const SizedBox(height: 8),
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
  const _SchedRow({
    required this.icon,
    required this.label,
    required this.pill,
    required this.on,
  });

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, color: Colors.white54, size: 14),
        const SizedBox(width: 8),
        Text(label,
            style: TextStyle(
                fontSize: 12.5, color: Colors.white.withOpacity(0.8))),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: on
                ? Colors.white.withOpacity(0.15)
                : Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
            border:
                on ? Border.all(color: Colors.white.withOpacity(0.2)) : null,
          ),
          child: Text(pill,
              style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: on ? Colors.white : Colors.white38)),
        ),
      ]);
}
