import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/providers/provider_reset.dart';
import '../../tracker/providers/tracker_provider.dart';
import '../../../core/router/app_router.dart';

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
  static const border = Color(0xFFE4EAE4);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
}

// ─────────────────────────────────────────────────────────────────────────────
// PROFILE SHEET  — exported widget used in home_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

class ProfileSheet extends ConsumerWidget {
  final dynamic user;

  const ProfileSheet({super.key, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isFemale = user?.gender?.toLowerCase() == 'female';
    final progress = ref.watch(progressSummaryProvider);
    final totalPts =
        progress.whenOrNull(data: (s) => s.currentMonth?.totalPoints) ?? 0;
    final streak =
        progress.whenOrNull(data: (s) => s.currentMonth?.streakDays) ?? 0;

    return Container(
      height: size.height * 0.66,
      decoration: const BoxDecoration(
        color: _C.bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _C.border,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          ),

          // ── Hero header ───────────────────────────────────────────
          _ProfileHero(
            user: user,
            totalPts: totalPts,
            streak: streak,
          ).animate().fadeIn(duration: 260.ms).slideY(begin: 0.04),

          const SizedBox(height: 10),

          // ── Navigation list ───────────────────────────────────────
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Column(
                children: [
                  // Group 1 — Account
                  _NavGroup(
                    label: 'অ্যাকাউন্ট',
                    items: [
                      _NavTile(
                        icon: Icons.person_outline_rounded,
                        iconBg: _C.greenLight,
                        iconColor: _C.darkGreen,
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
                        iconBg: const Color(0xFFEDE9FE),
                        iconColor: const Color(0xFF7C3AED),
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
                      // _NavTile(
                      //   icon: Icons.emoji_events_rounded,
                      //   iconBg: _C.goldLight,
                      //   iconColor: _C.gold,
                      //   title: 'লিডারবোর্ড',
                      //   subtitle: 'শীর্ষ তালিকা দেখুন',
                      //   onTap: () {
                      //     Navigator.pop(context);
                      //     context.go(AppRoutes.leaderboard);
                      //   },
                      // ),
                      _NavTile(
                        icon: Icons.info_outline_rounded,
                        iconBg: const Color(0xFFE0F2FE),
                        iconColor: const Color(0xFF0891B2),
                        title: 'কীভাবে কাজ করে?',
                        subtitle: 'পয়েন্ট ও র‍্যাংকিং পদ্ধতি',
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
                        iconBg: _C.bg,
                        iconColor: _C.textSecondary,
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

                  // Logout
                  _LogoutButton(
                    onTap: () async {
                      HapticFeedback.mediumImpact();
                      Navigator.pop(context);
                      invalidateUserProviders(ref);
                      await ref.read(authProvider.notifier).logout();
                    },
                  ),

                  SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PROFILE HERO  — avatar + stats
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileHero extends StatelessWidget {
  final dynamic user;
  final int totalPts, streak;

  const _ProfileHero({
    required this.user,
    required this.totalPts,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final name = user?.name ?? 'ব্যবহারকারী';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    final email = user?.email ?? '';
    final serialId = user?.serialId;
    final district = user?.district;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_C.darkGreen, _C.midGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: 40,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.25), width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          initial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (email.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              email,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          if (serialId != null || district != null) ...[
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.15),
                                    width: 0.5),
                              ),
                              child: Text(
                                [
                                  if (serialId != null) 'ID: $serialId',
                                  if (district != null) district,
                                ].join(' • '),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),

                // const SizedBox(height: 16),

                // // Stats row
                // Row(
                //   children: [
                //     Expanded(
                //       child: _HeroStat(
                //         label: 'এই মাস',
                //         value: '$totalPts pts',
                //         icon: '⭐',
                //       ),
                //     ),
                //     Container(
                //       width: 0.5,
                //       height: 32,
                //       color: Colors.white.withOpacity(0.15),
                //     ),
                //     Expanded(
                //       child: _HeroStat(
                //         label: 'ধারাবাহিক',
                //         value: '$streak দিন',
                //         icon: '🔥',
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String label, value, icon;
  const _HeroStat(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 10,
          ),
        ),
      ],
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
            style: const TextStyle(
              color: _C.textHint,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _C.border, width: 0.5),
          ),
          child: Column(
            children: List.generate(items.length, (i) {
              return Column(
                children: [
                  items[i],
                  if (i < items.length - 1)
                    const Divider(
                        height: 0.5,
                        thickness: 0.5,
                        color: _C.border,
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
            // Icon badge
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

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: _C.textPrimary,
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
                    style: const TextStyle(
                      color: _C.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right_rounded,
                color: _C.textHint, size: 18),
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
          color: _C.redLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.red.withOpacity(0.15), width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout_rounded, color: _C.red, size: 18),
            SizedBox(width: 8),
            Text(
              'লগআউট',
              style: TextStyle(
                color: _C.red,
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
