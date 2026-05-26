import 'package:amal_tracker/features/auth/providers/privacy_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  static const red = Color(0xFFDC2626);
  static const redLight = Color(0xFFFEF2F2);
  static const purple = Color(0xFF7C3AED);
  static const purpleLight = Color(0xFFEDE9FE);
  static const blue = Color(0xFF0891B2);
  static const blueLight = Color(0xFFE0F2FE);
  static const teal = Color(0xFF0D9488);
  static const tealLight = Color(0xFFCCFBF1);
  static const border = Color(0xFFE4EAE4);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
}

// ─────────────────────────────────────────────────────────────────────────────
// SETTINGS SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacy = ref.watch(privacyProvider);

    return Scaffold(
      backgroundColor: _C.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── AppBar ─────────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: _C.darkGreen,
            surfaceTintColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
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
            title: const Text(
              'সেটিংস',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Section 1: লিডারবোর্ড গোপনীয়তা ───────────────────────
                  _SectionHeader(
                    label: 'লিডারবোর্ড গোপনীয়তা',
                    description: 'আপনার তথ্য কে দেখতে পাবে তা নিয়ন্ত্রণ করুন',
                  ),
                  const SizedBox(height: 10),

                  _SettingsCard(
                    children: [
                      // Toggle 1 — সব লিডারবোর্ড থেকে সরান
                      _SettingsTile(
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

                      _TileDivider(),

                      // Toggle 2 — এই মাস লুকান
                      _SettingsTile(
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

                      _TileDivider(),

                      // Toggle 3 — Anonymous নাম
                      _SettingsTile(
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
                  ).animate().fadeIn(delay: 80.ms).slideY(begin: 0.04),

                  const SizedBox(height: 24),

                  // ── Section 2: প্রোফাইল শেয়ার ────────────────────────────
                  _SectionHeader(
                    label: 'প্রোফাইল শেয়ার',
                    description: 'অন্যরা আপনার আমলের বিবরণ দেখতে পারবে কিনা',
                  ),
                  const SizedBox(height: 10),

                  _SettingsCard(
                    children: [
                      _SettingsTile(
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
                  ).animate().fadeIn(delay: 120.ms).slideY(begin: 0.04),

                  const SizedBox(height: 24),

                  // ── Section 3: নোটিফিকেশন ─────────────────────────────────
                  _SectionHeader(
                    label: 'নোটিফিকেশন',
                    description: 'রিমাইন্ডার ও আপডেট সেটিংস',
                  ),
                  const SizedBox(height: 10),

                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: Icons.notifications_outlined,
                        iconColor: _C.green,
                        iconBg: _C.greenLight,
                        title: 'দৈনিক রিমাইন্ডার',
                        subtitle: 'প্রতিদিন আমল ট্র্যাক করতে মনে করিয়ে দেবে',
                        value: false,
                        activeColor: _C.green,
                        activeTrackColor: _C.greenLight,
                        onToggle: (_) {},
                      ),
                    ],
                  ).animate().fadeIn(delay: 160.ms).slideY(begin: 0.04),

                  SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Toggle Handlers — প্রতিটা আলাদা dialog ──────────────────────────────

  void _onPermanentToggle(
    BuildContext context,
    WidgetRef ref,
    PrivacyState privacy,
    bool newVal,
  ) {
    HapticFeedback.selectionClick();
    showDialog(
      context: context,
      builder: (_) => _PrivacyDialog(
        icon: Icons.self_improvement_rounded,
        iconColor: _C.purple,
        iconBg: _C.purpleLight,
        title: newVal ? 'আমল গোপন রাখবেন?' : 'লিডারবোর্ডে ফিরবেন?',
        body: newVal
            ? 'এই সেটিং চালু করলে আপনি কোনো মাসের লিডারবোর্ডে দেখা যাবেন না।\n\n'
                'ইসলামে আমল গোপন রাখা রিয়া থেকে বাঁচার উত্তম পন্থা। যে ব্যক্তি শুধু আল্লাহর সন্তুষ্টির জন্য আমল করে, সে এই অপশন ব্যবহার করতে পারেন।\n\n'
                'যেকোনো সময় বন্ধ করে আবার অংশ নেওয়া যাবে।'
            : 'আমল গোপন রাখার সেটিং বন্ধ করলে পরের মাস থেকে আপনি লিডারবোর্ডে দেখা যাবেন।\n\n'
                'চলতি মাসে যদি আগে থেকে লুকানো থাকেন, তাহলে এই মাসে আর ফিরতে পারবেন না।',
        confirmText: newVal ? 'হ্যাঁ, গোপন রাখব' : 'হ্যাঁ, ফিরব',
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

    // যদি এই মাসে lock থাকে এবং on করতে চাইছে
    if (!newVal && privacy.canRejoinThisMonth == false) {
      showDialog(
        context: context,
        builder: (_) => _PrivacyDialog(
          icon: Icons.lock_clock_rounded,
          iconColor: _C.amber,
          iconBg: _C.amberLight,
          title: 'এই মাসে সম্ভব নয়',
          body: 'আপনি এই মাসে লিডারবোর্ড থেকে বেরিয়ে গেছেন।\n\n'
              'মাসের মাঝে ফিরে আসা ন্যায়সঙ্গত নয় কারণ অন্যরা পুরো মাস '
              'অংশ নিয়েছে। পরের মাস শুরু হলে আপনি স্বয়ংক্রিয়ভাবে '
              'লিডারবোর্ডে ফিরে আসবেন।',
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
      builder: (_) => _PrivacyDialog(
        icon: Icons.calendar_today_rounded,
        iconColor: _C.amber,
        iconBg: _C.amberLight,
        title: newVal ? 'এই মাস বাদ দেবেন?' : 'এই মাসে ফিরবেন?',
        body: newVal
            ? 'এই মাসের লিডারবোর্ড থেকে আপনার নাম সরিয়ে নেওয়া হবে।\n\n'
                '⚠️ সতর্কতা: একবার বাদ দিলে এই মাসে আর ফিরতে পারবেন না। '
                'পরের মাস শুরু হলে স্বয়ংক্রিয়ভাবে যোগ হবেন।'
            : 'এই মাসের লিডারবোর্ডে আবার অংশ নিতে চান?',
        confirmText: newVal ? 'হ্যাঁ, বাদ দিন' : 'হ্যাঁ, যোগ দিন',
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
      builder: (_) => _PrivacyDialog(
        icon: Icons.person_off_rounded,
        iconColor: _C.teal,
        iconBg: _C.tealLight,
        title: newVal ? 'নাম লুকাবেন?' : 'নাম দেখাবেন?',
        body: newVal
            ? 'লিডারবোর্ডে আপনার নামের জায়গায় "Anonymous" দেখাবে।\n\n'
                'তবে আপনার ID (যেমন: AT001) এবং জেলা দেখা যাবে। '
                'যেকোনো সময় আবার নাম দেখানো যাবে।'
            : 'লিডারবোর্ডে আপনার আসল নাম দেখানো হবে।',
        confirmText: newVal ? 'হ্যাঁ, লুকাই' : 'হ্যাঁ, দেখাই',
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
      builder: (_) => _PrivacyDialog(
        icon: Icons.share_rounded,
        iconColor: _C.blue,
        iconBg: _C.blueLight,
        title: newVal ? 'প্রোফাইল সবার জন্য খুলবেন?' : 'প্রোফাইল বন্ধ করবেন?',
        body: newVal
            ? 'এই সেটিং চালু করলে যে কেউ আপনার যেকোনো মাসের আমলের বিস্তারিত দেখতে পারবে।\n\n'
                'এটি অভিজ্ঞতা শেয়ার করার জন্য — কেউ আপনার আমল দেখে অনুপ্রাণিত হতে পারে। '
                'যেকোনো সময় বন্ধ করা যাবে।'
            : 'প্রোফাইল বন্ধ করলে শুধু আপনি নিজে আপনার আমলের বিবরণ দেখতে পারবেন।',
        confirmText: newVal ? 'হ্যাঁ, সবার জন্য খুলুন' : 'হ্যাঁ, বন্ধ করুন',
        confirmColor: _C.blue,
        onConfirm: () {
          ref.read(privacyProvider.notifier).toggleProfileShare(newVal);
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final String description;

  const _SectionHeader({
    required this.label,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: _C.textHint,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          description,
          style: const TextStyle(
            color: _C.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SETTINGS CARD WRAPPER
// ─────────────────────────────────────────────────────────────────────────────

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

class _TileDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
        height: 0.5, thickness: 0.5, color: _C.border, indent: 54);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SETTINGS TILE  — toggle intercept করে dialog দেখায়
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String title, subtitle;
  final bool value;
  final bool disabled;
  final String? warningText;
  final Color activeColor, activeTrackColor;
  final ValueChanged<bool> onToggle;

  const _SettingsTile({
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
        // Entire row tap করলেও toggle হবে
        onTap: disabled ? null : () => onToggle(!value),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              // Icon
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: value ? iconBg : const Color(0xFFF4F6F1),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  color: value ? iconColor : _C.textHint,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: value ? _C.textPrimary : _C.textSecondary,
                        fontSize: 13.5,
                        fontWeight: value ? FontWeight.w700 : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                          color: _C.textSecondary, fontSize: 11),
                    ),
                    if (warningText != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        warningText!,
                        style: const TextStyle(
                          color: _C.amber,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Switch — intercept করে না, parent GestureDetector handle করে
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
// PRIVACY DIALOG  — reusable confirmation dialog
// ─────────────────────────────────────────────────────────────────────────────

class _PrivacyDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String title, body;
  final String confirmText;
  final Color confirmColor;
  final bool showCancel;
  final VoidCallback onConfirm;

  const _PrivacyDialog({
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ──────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              decoration: BoxDecoration(
                color: iconBg.withOpacity(0.4),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: iconColor.withOpacity(0.2), width: 1.5),
                    ),
                    child: Icon(icon, color: iconColor, size: 26),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _C.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Text(
                body,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _C.textSecondary,
                  fontSize: 13,
                  height: 1.65,
                ),
              ),
            ),

            // ── Actions ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Column(
                children: [
                  // Confirm button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: confirmColor,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: confirmColor.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          confirmText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (showCancel) ...[
                    const SizedBox(height: 10),
                    // Cancel button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: double.infinity,
                        height: 46,
                        decoration: BoxDecoration(
                          color: _C.bg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: _C.border),
                        ),
                        child: const Center(
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
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().scale(
          begin: const Offset(0.92, 0.92),
          duration: 220.ms,
          curve: Curves.easeOutBack,
        );
  }
}
