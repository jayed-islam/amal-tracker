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
  static const red = Color(0xFFEF4444);
  static const redLight = Color(0xFFFEF2F2);
  static const border = Color(0xFFE4EAE4);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
}

// ─────────────────────────────────────────────────────────────────────────────
// SETTINGS PROVIDER  — local prefs (extend with shared_preferences later)
// ─────────────────────────────────────────────────────────────────────────────

class SettingsState {
  final bool prayerReminder;
  final bool dailyEntryReminder;
  final bool weeklyReport;
  final bool leaderboardUpdates;
  final String reminderTime; // "08:00"
  final bool vibration;
  final bool sound;

  const SettingsState({
    this.prayerReminder = true,
    this.dailyEntryReminder = true,
    this.weeklyReport = false,
    this.leaderboardUpdates = true,
    this.reminderTime = '08:00',
    this.vibration = true,
    this.sound = true,
  });

  SettingsState copyWith({
    bool? prayerReminder,
    bool? dailyEntryReminder,
    bool? weeklyReport,
    bool? leaderboardUpdates,
    String? reminderTime,
    bool? vibration,
    bool? sound,
  }) =>
      SettingsState(
        prayerReminder: prayerReminder ?? this.prayerReminder,
        dailyEntryReminder: dailyEntryReminder ?? this.dailyEntryReminder,
        weeklyReport: weeklyReport ?? this.weeklyReport,
        leaderboardUpdates: leaderboardUpdates ?? this.leaderboardUpdates,
        reminderTime: reminderTime ?? this.reminderTime,
        vibration: vibration ?? this.vibration,
        sound: sound ?? this.sound,
      );
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState());
  // TODO: load/save from shared_preferences

  void toggle(String key) {
    switch (key) {
      case 'prayerReminder':
        state = state.copyWith(prayerReminder: !state.prayerReminder);
        break;
      case 'dailyEntryReminder':
        state = state.copyWith(dailyEntryReminder: !state.dailyEntryReminder);
        break;
      case 'weeklyReport':
        state = state.copyWith(weeklyReport: !state.weeklyReport);
        break;
      case 'leaderboardUpdates':
        state = state.copyWith(leaderboardUpdates: !state.leaderboardUpdates);
        break;
      case 'vibration':
        state = state.copyWith(vibration: !state.vibration);
        break;
      case 'sound':
        state = state.copyWith(sound: !state.sound);
        break;
    }
    HapticFeedback.selectionClick();
  }

  void setReminderTime(String time) {
    state = state.copyWith(reminderTime: time);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (_) => SettingsNotifier(),
);

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final hPad = isTablet ? (size.width - 600) / 2 + 20.0 : 20.0;

    return Scaffold(
      backgroundColor: _C.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ───────────────────────────────────────────────
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
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                color: _C.darkGreen,
                child: Stack(
                  children: [
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
                      bottom: 16,
                      left: hPad,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'সেটিংস',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.4,
                            ),
                          ),
                          Text(
                            'নোটিফিকেশন ও পছন্দ',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Body ─────────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 60),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Notifications ──────────────────────────────────
                _GroupLabel(label: 'নোটিফিকেশন')
                    .animate()
                    .fadeIn(duration: 260.ms),
                const SizedBox(height: 8),
                _SettingsCard(
                  children: [
                    _ToggleTile(
                      icon: Icons.mosque_rounded,
                      iconBg: _C.greenLight,
                      iconColor: _C.darkGreen,
                      title: 'নামাজের রিমাইন্ডার',
                      subtitle: 'প্রতি ওয়াক্তে মনে করিয়ে দেবে',
                      value: settings.prayerReminder,
                      onChanged: (_) => notifier.toggle('prayerReminder'),
                    ),
                    _Divider(),
                    _ToggleTile(
                      icon: Icons.edit_note_rounded,
                      iconBg: _C.blueLight,
                      iconColor: _C.blue,
                      title: 'দৈনিক আমল রিমাইন্ডার',
                      subtitle: 'আমল রেকর্ড না করলে মনে করাবে',
                      value: settings.dailyEntryReminder,
                      onChanged: (_) => notifier.toggle('dailyEntryReminder'),
                    ),
                    _Divider(),
                    _ToggleTile(
                      icon: Icons.bar_chart_rounded,
                      iconBg: _C.purpleLight,
                      iconColor: _C.purple,
                      title: 'সাপ্তাহিক রিপোর্ট',
                      subtitle: 'প্রতি সপ্তাহে সারসংক্ষেপ পাঠাবে',
                      value: settings.weeklyReport,
                      onChanged: (_) => notifier.toggle('weeklyReport'),
                    ),
                    _Divider(),
                    _ToggleTile(
                      icon: Icons.emoji_events_rounded,
                      iconBg: _C.goldLight,
                      iconColor: _C.gold,
                      title: 'লিডারবোর্ড আপডেট',
                      subtitle: 'র‍্যাংক পরিবর্তন হলে জানাবে',
                      value: settings.leaderboardUpdates,
                      onChanged: (_) => notifier.toggle('leaderboardUpdates'),
                    ),
                  ],
                ).animate().fadeIn(delay: 60.ms),

                const SizedBox(height: 20),

                // ── Reminder time ──────────────────────────────────
                if (settings.dailyEntryReminder) ...[
                  _GroupLabel(label: 'রিমাইন্ডারের সময়')
                      .animate()
                      .fadeIn(delay: 100.ms),
                  const SizedBox(height: 8),
                  _TimePickerCard(
                    currentTime: settings.reminderTime,
                    onPick: (time) => notifier.setReminderTime(time),
                  ).animate().fadeIn(delay: 120.ms),
                  const SizedBox(height: 20),
                ],

                // ── Sound & Vibration ──────────────────────────────
                _GroupLabel(label: 'শব্দ ও কম্পন')
                    .animate()
                    .fadeIn(delay: 140.ms),
                const SizedBox(height: 8),
                _SettingsCard(
                  children: [
                    _ToggleTile(
                      icon: Icons.volume_up_rounded,
                      iconBg: _C.amberLight,
                      iconColor: _C.amber,
                      title: 'শব্দ',
                      subtitle: 'বিজ্ঞপ্তির জন্য শব্দ বাজবে',
                      value: settings.sound,
                      onChanged: (_) => notifier.toggle('sound'),
                    ),
                    _Divider(),
                    _ToggleTile(
                      icon: Icons.vibration_rounded,
                      iconBg: _C.bg,
                      iconColor: _C.textSecondary,
                      title: 'ভাইব্রেশন',
                      subtitle: 'বিজ্ঞপ্তির সময় কম্পন হবে',
                      value: settings.vibration,
                      onChanged: (_) => notifier.toggle('vibration'),
                    ),
                  ],
                ).animate().fadeIn(delay: 160.ms),

                const SizedBox(height: 20),

                // ── App info ───────────────────────────────────────
                _GroupLabel(label: 'অ্যাপ সম্পর্কে')
                    .animate()
                    .fadeIn(delay: 180.ms),
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
                      onTap: () {
                        // TODO: open privacy policy URL
                      },
                    ),
                    _Divider(),
                    _InfoTile(
                      icon: Icons.description_outlined,
                      iconBg: _C.purpleLight,
                      iconColor: _C.purple,
                      title: 'ব্যবহারের শর্তাবলী',
                      showArrow: true,
                      onTap: () {
                        // TODO: open terms URL
                      },
                    ),
                  ],
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 20),

                // ── Danger zone ────────────────────────────────────
                _GroupLabel(label: 'বিপজ্জনক অঞ্চল', danger: true)
                    .animate()
                    .fadeIn(delay: 220.ms),
                const SizedBox(height: 8),
                _DangerCard().animate().fadeIn(delay: 240.ms),

                SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COMPONENTS
// ─────────────────────────────────────────────────────────────────────────────

class _GroupLabel extends StatelessWidget {
  final String label;
  final bool danger;
  const _GroupLabel({required this.label, this.danger = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: danger ? _C.red.withOpacity(0.7) : _C.textHint,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.7,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border, width: 0.5),
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 54),
      child: Divider(height: 0.5, thickness: 0.5, color: _C.border),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOGGLE TILE
// ─────────────────────────────────────────────────────────────────────────────

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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
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
        ],
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Toggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
// INFO TILE
// ─────────────────────────────────────────────────────────────────────────────

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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
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
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TIME PICKER CARD
// ─────────────────────────────────────────────────────────────────────────────

class _TimePickerCard extends StatelessWidget {
  final String currentTime;
  final ValueChanged<String> onPick;

  const _TimePickerCard({required this.currentTime, required this.onPick});

  Future<void> _pick(BuildContext context) async {
    final parts = currentTime.split(':');
    final initial = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 8,
      minute: int.tryParse(parts[1]) ?? 0,
    );
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: _C.darkGreen),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      final h = picked.hour.toString().padLeft(2, '0');
      final m = picked.minute.toString().padLeft(2, '0');
      onPick('$h:$m');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pick(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.border, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _C.greenLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.access_time_rounded,
                  color: _C.darkGreen, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('রিমাইন্ডারের সময়',
                      style: TextStyle(
                          color: _C.textPrimary,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700)),
                  Text('ট্যাপ করে সময় বদলান',
                      style: const TextStyle(
                          color: _C.textSecondary, fontSize: 11)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _C.greenLight,
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: _C.green.withOpacity(0.3), width: 0.5),
              ),
              child: Text(
                currentTime,
                style: const TextStyle(
                  color: _C.darkGreen,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DANGER CARD
// ─────────────────────────────────────────────────────────────────────────────

class _DangerCard extends ConsumerWidget {
  const _DangerCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.red.withOpacity(0.2), width: 0.5),
      ),
      child: Column(
        children: [
          // Clear cache
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('ক্যাশ পরিষ্কার হয়েছে'),
                  backgroundColor: _C.darkGreen,
                  margin: const EdgeInsets.all(16),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _C.amberLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: _C.textHint, size: 18),
                ],
              ),
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
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _C.redLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _C.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration:
                const BoxDecoration(color: _C.redLight, shape: BoxShape.circle),
            child: const Icon(Icons.warning_amber_rounded,
                color: _C.red, size: 20),
          ),
          const SizedBox(width: 10),
          const Text('অ্যাকাউন্ট মুছবেন?',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: _C.textPrimary)),
        ]),
        content: const Text(
          'এই কাজটি পূর্বাবস্থায় ফেরানো যাবে না। আপনার সমস্ত আমল ডেটা, পয়েন্ট ও র‍্যাংকিং স্থায়ীভাবে মুছে যাবে।',
          style: TextStyle(color: _C.textSecondary, fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল',
                style: TextStyle(
                    color: _C.textSecondary, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: call delete account API
            },
            style: TextButton.styleFrom(
              backgroundColor: _C.redLight,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('হ্যাঁ, মুছুন',
                style: TextStyle(color: _C.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
