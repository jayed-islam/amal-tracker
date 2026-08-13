import 'package:amal_tracker/core/router/app_router.dart';
import 'package:amal_tracker/features/auth/providers/auth_provider.dart';
import 'package:amal_tracker/features/auth/providers/privacy_provider.dart';
import 'package:amal_tracker/features/feedback/provider/feedback_provider.dart';
import 'package:amal_tracker/features/feedback/widget/feedback_sheet.dart';
import 'package:amal_tracker/features/notification/provider/notification_provider.dart';
import 'package:amal_tracker/features/user/widgets/app_silver_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';
import 'package:amal_tracker/core/providers/theme_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────
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
      await widget.apiCall();
      if (!mounted) return;
      widget.onSuccess();
      Navigator.of(context).pop(const _DialogResult.ok());
    } catch (e) {
      if (!mounted) return;
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
            color: context.colors.card,
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
                              style: TextStyle(
                                color: context.colors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.2,
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(widget.body,
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: 13,
                          height: 1.65,
                        )),
                  ],
                ),
              ),
              Divider(
                  height: 0.5, thickness: 0.5, color: context.colors.border),
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
          color: context.colors.textSecondary,
          position: _BtnPos.left,
          onTap: _handleCancel,
        ),
      ),
      VerticalDivider(width: 0.5, thickness: 0.5, color: context.colors.border),
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
      backgroundColor: success ? context.colors.darkGreen : context.colors.red,
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
      backgroundColor: context.colors.bg,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          AppSliverBar(
            scrollController: _scrollController,
            title: 'সেটিংস',
            subtitle: 'নোটিফিকেশন ও পছন্দ',
            icon: Icons.settings_outlined,
            color: context.colors.darkGreen,
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 60),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Notification ────────────────────────────────────────────
                const _GroupLabel(label: 'নোটিফিকেশন')
                    .animate()
                    .fadeIn(duration: 260.ms),
                const SizedBox(height: 8),
                _NotificationEntryRow(
                  onTap: () => context.push('/notification-settings'),
                ).animate().fadeIn(delay: 60.ms),

                const SizedBox(height: 24),

                // ── Theme ─────────────────────────────────────────────────────
                const _GroupLabel(label: 'থিম').animate().fadeIn(delay: 70.ms),
                const SizedBox(height: 4),
                const _SubLabel(label: 'অ্যাপের রঙ কেমন দেখাবে বেছে নিন')
                    .animate()
                    .fadeIn(delay: 75.ms),
                const SizedBox(height: 10),
                const _ThemeModeSelector().animate().fadeIn(delay: 80.ms),

                const SizedBox(height: 24),

                // ── Leaderboard Privacy ──────────────────────────────────────
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
                      iconColor: context.colors.purple,
                      iconBg: context.colors.purpleLight,
                      title: 'আমল গোপন রাখুন',
                      subtitle: 'লিডারবোর্ডে আমার কোনো তথ্য দেখাবে না',
                      value: privacy.isPermanent,
                      activeColor: context.colors.purple,
                      activeTrackColor: context.colors.purpleLight,
                      onToggle: (val) => _onPermanentToggle(privacy, val),
                    ),
                    _Divider(),
                    _PrivacyTile(
                      icon: Icons.calendar_today_rounded,
                      iconColor: context.colors.amber,
                      iconBg: context.colors.amberLight,
                      title: 'এই মাস অংশ নেব না',
                      subtitle: privacy.canRejoinThisMonth == false
                          ? 'পরের মাস থেকে স্বয়ংক্রিয় active হবে'
                          : 'শুধু এই মাসের লিডারবোর্ড থেকে বাদ',
                      value: privacy.isHidden,
                      disabled: privacy.isPermanent,
                      activeColor: context.colors.amber,
                      activeTrackColor: context.colors.amberLight,
                      warningText: privacy.canRejoinThisMonth == false
                          ? '⚠️ এই মাসে আর ফিরতে পারবেন না'
                          : null,
                      onToggle: (val) => _onMonthlyToggle(privacy, val),
                    ),
                    _Divider(),
                    _PrivacyTile(
                      icon: Icons.person_off_rounded,
                      iconColor: context.colors.teal,
                      iconBg: context.colors.tealLight,
                      title: 'নাম লুকান',
                      subtitle: 'লিডারবোর্ডে "Anonymous" দেখাবে',
                      value: privacy.showAnonymous,
                      disabled: privacy.isPermanent,
                      activeColor: context.colors.teal,
                      activeTrackColor: context.colors.tealLight,
                      onToggle: (val) => _onAnonymousToggle(privacy, val),
                    ),
                  ],
                ).animate().fadeIn(delay: 100.ms),

                const SizedBox(height: 24),

                // ── Profile Share ────────────────────────────────────────────
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
                      iconColor: context.colors.blue,
                      iconBg: context.colors.blueLight,
                      title: 'প্রোফাইল সবার জন্য খুলুন',
                      subtitle: privacy.isPublic
                          ? 'যে কেউ আপনার মাসিক আমল দেখতে পারবে'
                          : 'শুধু আপনি নিজে দেখতে পারবেন',
                      value: privacy.isPublic,
                      activeColor: context.colors.blue,
                      activeTrackColor: context.colors.blueLight,
                      onToggle: (val) => _onProfileShareToggle(privacy, val),
                    ),
                  ],
                ).animate().fadeIn(delay: 140.ms),

                const SizedBox(height: 24),

// ── Feedback ─────────────────────────────────────────────────
                const _GroupLabel(label: 'মতামত')
                    .animate()
                    .fadeIn(delay: 150.ms),
                const SizedBox(height: 4),
                const _SubLabel(
                        label:
                            'অ্যাপ নিয়ে আপনার মতামত জানান — শুধু আমাদের টিম দেখবে')
                    .animate()
                    .fadeIn(delay: 155.ms),
                const SizedBox(height: 10),
                _SettingsCard(
                  children: [
                    _InfoTile(
                      icon: Icons.rate_review_rounded,
                      iconBg: context.colors.greenLight,
                      iconColor: context.colors.darkGreen,
                      title: 'মতামত পাঠান',
                      showArrow: true,
                      onTap: () => _openFeedbackSheet(context, ref),
                    ),
                  ],
                ).animate().fadeIn(delay: 160.ms),

                const SizedBox(height: 24),

                // ── App Info ─────────────────────────────────────────────────
                const _GroupLabel(label: 'অ্যাপ সম্পর্কে')
                    .animate()
                    .fadeIn(delay: 160.ms),
                const SizedBox(height: 8),
                _SettingsCard(
                  children: [
                    _InfoTile(
                      icon: Icons.info_outline_rounded,
                      iconBg: context.colors.blueLight,
                      iconColor: context.colors.blue,
                      title: 'আমাদের সম্পর্কে',
                      showArrow: true,
                      onTap: () => context.push(AppRoutes.aboutUs),
                    ),
                    _Divider(),
                    _InfoTile(
                      icon: Icons.security_rounded,
                      iconBg: context.colors.greenLight,
                      iconColor: context.colors.green,
                      title: 'গোপনীয়তা নীতি ও ব্যবহারের শর্তাবলী',
                      showArrow: true,
                      onTap: () => context.push(AppRoutes.legal),
                    ),
                    _Divider(),
                    _InfoTile(
                      icon: Icons.device_hub_rounded,
                      iconBg: context.colors.amberLight,
                      iconColor: context.colors.amber,
                      title: 'সংস্করণ',
                      trailing: 'v1.0.0',
                    ),
                  ],
                ).animate().fadeIn(delay: 180.ms),

                const SizedBox(height: 24),

                // ── Danger Zone ──────────────────────────────────────────────
                const _GroupLabel(label: 'বিপজ্জনক অঞ্চল', danger: true)
                    .animate()
                    .fadeIn(delay: 200.ms),
                const SizedBox(height: 8),
                const _DangerCard().animate().fadeIn(delay: 220.ms),

                SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openFeedbackSheet(BuildContext context, WidgetRef ref) async {
    ref.read(feedbackProvider.notifier).reset();
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FeedbackSheet(),
    );
    if (!context.mounted) return;
    if (result == true) {
      _showSnack(context, 'মতামতের জন্য ধন্যবাদ! 🤍');
    }
  }

  // ── Privacy handlers (unchanged from existing) ──────────────────────────────

  Future<void> _onPermanentToggle(PrivacyState privacy, bool newVal) async {
    final result = await _showConfirm(
      context,
      icon: Icons.self_improvement_rounded,
      iconColor: context.colors.purple,
      iconBg: context.colors.purpleLight,
      title: newVal ? 'আমল গোপন রাখবেন?' : 'লিডারবোর্ডে ফিরবেন?',
      body: newVal
          ? 'এই ফিচার চালু করলে আপনি কোনো মাসের লিডারবোর্ডে দেখা যাবেন না। যেকোনো সময় বন্ধ করে আবার অংশ নেওয়া যাবে।'
          : 'এই ফিচার বন্ধ করলে পরের মাস থেকে আপনি আবার লিডারবোর্ডে দেখা যাবেন।',
      confirmText: newVal ? 'গোপন রাখব' : 'ফিরব',
      confirmColor: context.colors.purple,
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
    if (!newVal && privacy.canRejoinThisMonth == false) {
      await _showConfirm(
        context,
        icon: Icons.lock_clock_rounded,
        iconColor: context.colors.amber,
        iconBg: context.colors.amberLight,
        title: 'এই মাসে সম্ভব নয়',
        body:
            'আপনি এই মাসে লিডারবোর্ড থেকে বেরিয়ে গেছেন। পরের মাস শুরু হলে স্বয়ংক্রিয়ভাবে ফিরে আসবেন।',
        confirmText: 'বুঝেছি',
        confirmColor: context.colors.amber,
        showCancel: false,
        apiCall: () async {},
        onSuccess: () {},
      );
      return;
    }
    final result = await _showConfirm(
      context,
      icon: Icons.calendar_today_rounded,
      iconColor: context.colors.amber,
      iconBg: context.colors.amberLight,
      title: newVal ? 'এই মাস বাদ দেবেন?' : 'এই মাসে ফিরবেন?',
      body: newVal
          ? 'এই মাসের লিডারবোর্ড থেকে আপনার নাম সরিয়ে নেওয়া হবে।\n⚠️ একবার বাদ দিলে এই মাসে আর ফিরতে পারবেন না।'
          : 'এই মাসের লিডারবোর্ডে আবার অংশ নিতে চান?',
      confirmText: newVal ? 'বাদ দিন' : 'যোগ দিন',
      confirmColor: context.colors.amber,
      apiCall: () => ref.read(privacyProvider.notifier).updatePrivacy(
            isPermanent: privacy.isPermanent,
            isHidden: newVal,
            showAnonymous: privacy.showAnonymous,
          ),
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
      iconColor: context.colors.teal,
      iconBg: context.colors.tealLight,
      title: newVal ? 'নাম লুকাবেন?' : 'নাম দেখাবেন?',
      body: newVal
          ? 'লিডারবোর্ডে আপনার নামের জায়গায় "Anonymous" দেখাবে। ID ও জেলা দেখা যাবে। যেকোনো সময় পরিবর্তন করা যাবে।'
          : 'লিডারবোর্ডে আপনার আসল নাম দেখানো হবে।',
      confirmText: newVal ? 'নাম লুকাই' : 'নাম দেখাই',
      confirmColor: context.colors.teal,
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
      iconColor: context.colors.blue,
      iconBg: context.colors.blueLight,
      title: newVal ? 'প্রোফাইল সবার জন্য খুলবেন?' : 'প্রোফাইল বন্ধ করবেন?',
      body: newVal
          ? 'যে কেউ আপনার যেকোনো মাসের আমলের বিস্তারিত দেখতে পারবে। যেকোনো সময় বন্ধ করা যাবে।'
          : 'প্রোফাইল বন্ধ করলে শুধু আপনি নিজে আমলের বিবরণ দেখতে পারবেন।',
      confirmText: newVal ? 'সবার জন্য খুলুন' : 'বন্ধ করুন',
      confirmColor: context.colors.blue,
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
        return count == 0 ? 'সব বন্ধ' : '$countটি সক্রিয়';
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
          color: context.colors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border, width: 0.5),
        ),
        child: Row(children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: context.colors.greenLight,
                borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.notifications_rounded,
                color: context.colors.darkGreen, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('নোটিফিকেশন সেটিংস',
                  style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700)),
              Text(summary,
                  style: TextStyle(
                      color: context.colors.textSecondary, fontSize: 11)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: isAllOff ? context.colors.bg : context.colors.greenLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: isAllOff
                      ? context.colors.border
                      : context.colors.green.withOpacity(0.25),
                  width: 0.5),
            ),
            child: Text(summary,
                style: TextStyle(
                    color: isAllOff
                        ? context.colors.textHint
                        : context.colors.darkGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded,
              color: context.colors.textHint, size: 18),
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
                color: value ? iconBg : context.colors.bg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon,
                  color: value ? iconColor : context.colors.textHint, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: value
                                ? context.colors.textPrimary
                                : context.colors.textSecondary,
                            fontSize: 13.5,
                            fontWeight:
                                value ? FontWeight.w700 : FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: TextStyle(
                            color: context.colors.textSecondary, fontSize: 11)),
                    if (warningText != null) ...[
                      const SizedBox(height: 3),
                      Text(warningText!,
                          style: TextStyle(
                              color: context.colors.amber,
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
                inactiveThumbColor: context.colors.textHint,
                inactiveTrackColor: context.colors.border,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DANGER CARD  ← full account deletion flow lives here
// ─────────────────────────────────────────────────────────────────────────────

class _DangerCard extends ConsumerWidget {
  const _DangerCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: context.colors.red.withOpacity(0.2), width: 0.5)),
      child: Column(children: [
        // ── Clear cache ───────────────────────────────────────────────────
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
                    color: context.colors.amberLight,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.cleaning_services_rounded,
                    color: context.colors.amber, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ক্যাশ পরিষ্কার করুন',
                          style: TextStyle(
                              color: context.colors.textPrimary,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700)),
                      Text('সাময়িক ডেটা মুছে ফেলবে',
                          style: TextStyle(
                              color: context.colors.textSecondary,
                              fontSize: 11)),
                    ]),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: context.colors.textHint, size: 18),
            ]),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(left: 54),
          child: Divider(
              height: 0.5, thickness: 0.5, color: context.colors.redLight2),
        ),

        // ── Delete account ────────────────────────────────────────────────
        GestureDetector(
          onTap: () => _startDeletionFlow(context, ref),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                    color: context.colors.redLight,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.delete_forever_rounded,
                    color: context.colors.red, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('অ্যাকাউন্ট মুছুন',
                          style: TextStyle(
                              color: context.colors.red,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700)),
                      Text('সমস্ত ডেটা স্থায়ীভাবে মুছে যাবে',
                          style: TextStyle(
                              color: context.colors.red, fontSize: 11)),
                    ]),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: context.colors.red, size: 18),
            ]),
          ),
        ),
      ]),
    );
  }

  // ── Step 1 → Step 2 → Goodbye sheet ────────────────────────────────────────
  //
  //  Step 1: Inform about grace period — no API call yet
  //  Step 2: Final double-confirm — actual requestDeletion() API call
  //  Goodbye: Bottom sheet showing daysLeft, then go to onboarding
  //
  Future<void> _startDeletionFlow(BuildContext context, WidgetRef ref) async {
    HapticFeedback.heavyImpact();

    // ── Step 1: Grace period info ───────────────────────────────────────────
    final step1 = await _showConfirm(
      context,
      icon: Icons.delete_forever_rounded,
      iconColor: context.colors.red,
      iconBg: context.colors.redLight,
      title: 'অ্যাকাউন্ট মুছবেন?',
      body: 'আপনার অ্যাকাউন্ট এখনই স্থায়ীভাবে মুছবে না।\n\n'
          '৪৫ দিনের গ্রেস পিরিয়ড থাকবে — এই সময়ে লগইন করে '
          '"অ্যাকাউন্ট ফিরিয়ে আনুন" বাটনে ক্লিক করলে সব ডেটা ফিরে পাবেন। '
          '৪৫ দিন পর সমস্ত তথ্য চিরতরে মুছে যাবে।',
      confirmText: 'পরবর্তী',
      confirmColor: context.colors.red,
      apiCall: () async {}, // no API — just informational
      onSuccess: () {},
    );
    if (!context.mounted || !step1.confirmed) return;

    // ── Step 2: Final confirmation + API ───────────────────────────────────
    final step2 = await _showConfirm(
      context,
      icon: Icons.warning_amber_rounded,
      iconColor: context.colors.red,
      iconBg: context.colors.redLight,
      title: 'শেষবারের মতো নিশ্চিত করুন',
      body: 'এখন থেকে ৪৫ দিন গণনা শুরু হবে।\n\n'
          'এই সময়ের মধ্যে:\n'
          '• লিডারবোর্ড থেকে আপনাকে সরিয়ে নেওয়া হবে\n'
          '• প্রোফাইল অন্যদের কাছে অদৃশ্য হবে\n'
          '• গ্রুপ থেকে বাদ পড়বেন\n\n'
          '৪৫ দিন পর আমল, পয়েন্ট, র‍্যাংকিং সব স্থায়ীভাবে মুছে যাবে।',
      confirmText: 'হ্যাঁ, মুছুন',
      confirmColor: context.colors.red,
      // throws on failure → _ConfirmDialog.catch → step2.success = false
      apiCall: () async {
        final info = await ref.read(authProvider.notifier).requestDeletion();
        if (info == null) {
          throw Exception('অ্যাকাউন্ট মুছতে ব্যর্থ হয়েছে। আবার চেষ্টা করুন।');
        }
      },
      onSuccess: () {}, // AuthState already updated inside requestDeletion()
    );

    if (!context.mounted) return;

    if (step2.success) {
      // pendingDeletion is now set in AuthState
      final info = ref.read(pendingDeletionProvider);
      final daysLeft = info?.daysLeft ?? 45;

      await _showGoodbyeSheet(context, daysLeft);

      if (context.mounted) {
        context.go(AppRoutes.onboarding); // or '/onboarding'
      }
    } else if (step2.confirmed) {
      _showSnack(
        context,
        step2.error.isNotEmpty
            ? step2.error
            : 'অ্যাকাউন্ট মুছতে সমস্যা হয়েছে। আবার চেষ্টা করুন।',
        success: false,
      );
    }
  }

  // ── Goodbye bottom sheet ────────────────────────────────────────────────────
  //
  //  Shows daysLeft, reminds user how to recover.
  //  isDismissible: false — user must tap "বুঝেছি" to proceed to onboarding.
  //
  Future<void> _showGoodbyeSheet(BuildContext context, int daysLeft) {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        // Pushes sheet above keyboard if somehow open
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Icon ──────────────────────────────────────────────────
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: context.colors.amberLight,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(Icons.hourglass_top_rounded,
                    color: context.colors.amber, size: 32),
              ).animate().scale(
                    duration: 400.ms,
                    curve: Curves.elasticOut,
                    begin: const Offset(0.7, 0.7),
                  ),

              const SizedBox(height: 20),

              // ── Title ─────────────────────────────────────────────────
              Text(
                'অ্যাকাউন্ট মুছে ফেলার প্রক্রিয়া শুরু হয়েছে',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.15),

              const SizedBox(height: 14),

              // ── Grace period pill ──────────────────────────────────────
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: context.colors.amberLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: context.colors.amber.withOpacity(0.35),
                      width: 0.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined,
                        color: context.colors.amber, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '$daysLeft দিনের মধ্যে ফিরে আসতে পারবেন',
                      style: TextStyle(
                        color: context.colors.amber,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ).animate(delay: 180.ms).fadeIn(),

              const SizedBox(height: 18),

              // ── Body ──────────────────────────────────────────────────
              Text(
                'লগইন পেজে গিয়ে আপনার ইমেইল ও পাসওয়ার্ড দিলে '
                '"অ্যাকাউন্ট ফিরিয়ে আনুন" বাটন দেখতে পাবেন। '
                'সেখান থেকে যেকোনো সময় বাতিল করা যাবে।\n\n'
                '$daysLeft দিন পর সমস্ত ডেটা স্থায়ীভাবে মুছে যাবে।',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.colors.textSecondary,
                  fontSize: 13,
                  height: 1.65,
                ),
              ).animate(delay: 220.ms).fadeIn(),

              const SizedBox(height: 28),

              // ── CTA ───────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.darkGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'বুঝেছি',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ).animate(delay: 280.ms).fadeIn().slideY(begin: 0.2),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED COMPONENTS (unchanged)
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// THEME SELECTOR — System / Light / Dark, persisted via themeModeProvider
// ─────────────────────────────────────────────────────────────────────────────
class _ThemeModeSelector extends ConsumerWidget {
  const _ThemeModeSelector();

  static const _options = [
    (
      mode: ThemeMode.system,
      icon: Icons.brightness_auto_rounded,
      label: 'সিস্টেম'
    ),
    (mode: ThemeMode.light, icon: Icons.light_mode_rounded, label: 'লাইট'),
    (mode: ThemeMode.dark, icon: Icons.dark_mode_rounded, label: 'ডার্ক'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(themeModeProvider);
    return _SettingsCard(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: _options.map((opt) {
              final selected = current == opt.mode;
              return Expanded(
                child: GestureDetector(
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(opt.mode),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: 180.ms,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selected
                          ? context.colors.darkGreen
                          : context.colors.bg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: selected
                              ? context.colors.darkGreen
                              : context.colors.border),
                    ),
                    child: Column(
                      children: [
                        Icon(opt.icon,
                            size: 20,
                            color: selected
                                ? Colors.white
                                : context.colors.textSecondary),
                        const SizedBox(height: 5),
                        Text(opt.label,
                            style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? Colors.white
                                    : context.colors.textSecondary)),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _GroupLabel extends StatelessWidget {
  final String label;
  final bool danger;
  const _GroupLabel({required this.label, this.danger = false});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(label.toUpperCase(),
            style: TextStyle(
                color: danger
                    ? context.colors.red.withOpacity(0.7)
                    : context.colors.textHint,
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
            style:
                TextStyle(color: context.colors.textSecondary, fontSize: 11.5)),
      );
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colors.border, width: 0.5)),
        child: Column(children: children),
      );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(left: 54),
        child:
            Divider(height: 0.5, thickness: 0.5, color: context.colors.border),
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
                  style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600)),
            ),
            if (trailing != null)
              Text(trailing!,
                  style: TextStyle(
                      color: context.colors.textHint,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            if (showArrow)
              Icon(Icons.chevron_right_rounded,
                  color: context.colors.textHint, size: 18),
          ]),
        ),
      );
}
