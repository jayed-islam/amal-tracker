import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/providers/provider_reset.dart';
import '../../../core/router/app_router.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────
// PROFILE SHEET — exported widget used in home_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

class ProfileSheet extends ConsumerWidget {
  final dynamic user;

  const ProfileSheet({super.key, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFemale = user?.gender?.toLowerCase() == 'female';

    return Container(
        decoration: BoxDecoration(
          color: context.colors.bg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.colors.border,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),

              // ── Hero header ───────────────────────────────────────────
              _ProfileHero(
                user: user,
              ).animate().fadeIn(duration: 260.ms).slideY(begin: 0.04),

              const SizedBox(height: 12),

              // ── Navigation list ───────────────────────────────────────
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Group 1 — Account
                      _NavGroup(
                        label: 'অ্যাকাউন্ট',
                        items: [
                          _NavTile(
                            icon: Icons.person_outline_rounded,
                            iconBg: context.colors.greenLight,
                            iconColor: context.colors.darkGreen,
                            title: 'প্রোফাইল সম্পাদনা',
                            subtitle: 'নাম, ফোন, পরিচয় আপডেট করুন',
                            onTap: () {
                              Navigator.pop(context);
                              if (context.mounted) {
                                context.push(AppRoutes.profileEdit);
                              }
                            },
                          ),
                          _NavTile(
                            icon: Icons.lock_outline_rounded,
                            iconBg: context.colors.purpleLight,
                            iconColor: context.colors.avatar3,
                            title: 'পাসওয়ার্ড পরিবর্তন',
                            subtitle: 'নিরাপদ রাখুন অ্যাকাউন্ট',
                            onTap: () {
                              Navigator.pop(context);
                              if (context.mounted) {
                                context.push(AppRoutes.changePassword);
                              }
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Group 2 — App
                      _NavGroup(
                        label: 'অ্যাপ',
                        items: [
                          _NavTile(
                            icon: Icons.info_outline_rounded,
                            iconBg: context.colors.blueLight,
                            iconColor: context.colors.avatar4,
                            title: 'কীভাবে কাজ করে?',
                            subtitle: 'আমল ট্র্যাকিং ও র‍্যাংকিং পদ্ধতি',
                            badge: isFemale ? '🌸' : null,
                            onTap: () {
                              Navigator.pop(context);
                              if (context.mounted) {
                                context.push(AppRoutes.howItWorks);
                              }
                            },
                          ),
                          _NavTile(
                            icon: Icons.settings_outlined,
                            iconBg: context.colors.bg,
                            iconColor: context.colors.textSecondary,
                            title: 'সেটিংস',
                            subtitle: 'নোটিফিকেশন ও অন্যান্য',
                            onTap: () {
                              Navigator.pop(context);
                              if (context.mounted) {
                                context.push(AppRoutes.settings);
                              }
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _LogoutButton(
                        onTap: () async {
                          HapticFeedback.mediumImpact();
                          await ref.read(authProvider.notifier).logout();
                          invalidateUserProviders(ref);
                          if (context.mounted) Navigator.pop(context);
                        },
                      ),

                      SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PROFILE HERO — avatar + completion % + streak
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileHero extends StatelessWidget {
  final dynamic user;

  const _ProfileHero({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final name = user?.name ?? 'ব্যবহারকারী';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    final id = user?.id;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colors.darkGreen, context.colors.midGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (id != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    'ID: $id',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NAV GROUP
// ─────────────────────────────────────────────────────────────────────────────

class _NavGroup extends StatelessWidget {
  final String label;
  final List<_NavTile> items;

  const _NavGroup({required this.label, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: context.colors.textHint,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colors.border, width: 0.5),
          ),
          child: Column(
            children: List.generate(items.length, (i) {
              return Column(
                children: [
                  items[i],
                  if (i < items.length - 1)
                    Divider(
                        height: 0.5,
                        thickness: 0.5,
                        color: context.colors.border,
                        indent: 54),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NAV TILE
// ─────────────────────────────────────────────────────────────────────────────

class _NavTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String title, subtitle;
  final String? badge;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: context.colors.textPrimary,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 6),
                        Text(badge!, style: const TextStyle(fontSize: 12)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: context.colors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: context.colors.textHint, size: 18),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LOGOUT BUTTON
// ─────────────────────────────────────────────────────────────────────────────

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: context.colors.redLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: context.colors.red2.withOpacity(0.15), width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: context.colors.red2, size: 18),
            SizedBox(width: 8),
            Text(
              'লগআউট',
              style: TextStyle(
                color: context.colors.red2,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
