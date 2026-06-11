// lib/features/group/screens/group_home_screen.dart

import 'package:amal_tracker/features/group/models/group_mode.dart';
import 'package:amal_tracker/features/group/provider/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pricing_screen.dart';
import 'group_detail_screen.dart';
import 'create_join_group_screen.dart';

// ─── Design Tokens (same as your app) ────────────────────────────────────────
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
  static const silver = Color(0xFF8B92A8);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
  static const border = Color(0xFFE4EAE4);
  static const borderMid = Color(0xFFD0DAD2);
}

// ─────────────────────────────────────────────────────────────────────────────
// GROUP HOME SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class GroupHomeScreen extends ConsumerWidget {
  const GroupHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subAsync = ref.watch(subscriptionProvider);
    final groupsAsync = ref.watch(groupListProvider);

    return Scaffold(
      backgroundColor: _C.pageBg,
      body: SafeArea(
          // child: _ComingSoonBody(sub: sub)
          child: _ComingSoonBody()
          // subAsync.when(
          //   loading: () => const _LoadingBody(),
          //   error: (e, _) => _ErrorBody(message: e.toString()),
          //   data: (sub) {
          //     // Coming soon — payment not enabled yet
          //     if (!sub.paymentEnabled && sub.isBasic) {
          //       return _ComingSoonBody(sub: sub);
          //     }
          //     // Has subscription or payment enabled
          //     return _GroupsBody(sub: sub, groupsAsync: groupsAsync);
          //   },
          // ),
          ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COMING SOON BODY
// ─────────────────────────────────────────────────────────────────────────────

class _ComingSoonBody extends StatelessWidget {
  // final SubscriptionStatus sub;
  // const _ComingSoonBody({required this.sub});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // App bar
        SliverToBoxAdapter(
          child: _TopBar(title: 'গ্রুপ ফিচার', showBack: false),
        ),

        // Hero
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: _HeroCard(),
          ),
        ),

        // Plan previews
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text(
              'পরিকল্পনা সমূহ',
              style: TextStyle(
                color: _C.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _PlanPreviewCard(
                plan: SubscriptionPlan.basic,
                subtitle: '১টি গ্রুপে join, সর্বোচ্চ ৩ সদস্য',
                price: 'বিনামূল্যে',
                isPriceFree: true,
                delay: 0,
              ),
              const SizedBox(height: 10),
              _PlanPreviewCard(
                plan: SubscriptionPlan.silver,
                subtitle: '১টি গ্রুপ তৈরি, ৮ সদস্য',
                price: '৳৯৯/মাস',
                isPriceFree: false,
                delay: 60,
              ),
              const SizedBox(height: 10),
              _PlanPreviewCard(
                plan: SubscriptionPlan.gold,
                subtitle: '২টি গ্রুপ, ১৫ সদস্য + analytics',
                price: '৳১৯৯/মাস',
                isPriceFree: false,
                delay: 120,
              ),
            ]),
          ),
        ),

        // Detail button
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: _OutlineBtn(
              label: 'বিস্তারিত দেখুন',
              icon: Icons.arrow_forward_rounded,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PricingScreen()),
              ),
            ),
          ).animate(delay: 180.ms).fadeIn(duration: 240.ms).slideY(begin: 0.05),
        ),

        // Amal free note
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: _AmalFreeNote(),
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0E3D22), Color(0xFF1B7045)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child:
                const Icon(Icons.groups_rounded, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Sabeq Group',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4ADE80),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'শীঘ্রই',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'পরিবার ও বন্ধুদের সাথে একসাথে আমল করুন',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.04);
  }
}

class _PlanPreviewCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final String subtitle;
  final String price;
  final bool isPriceFree;
  final int delay;

  const _PlanPreviewCard({
    required this.plan,
    required this.subtitle,
    required this.price,
    required this.isPriceFree,
    required this.delay,
  });

  Color get _borderColor {
    switch (plan) {
      case SubscriptionPlan.silver:
        return _C.silver.withOpacity(0.4);
      case SubscriptionPlan.gold:
        return _C.gold.withOpacity(0.4);
      default:
        return _C.border;
    }
  }

  Color get _nameColor {
    switch (plan) {
      case SubscriptionPlan.silver:
        return _C.silver;
      case SubscriptionPlan.gold:
        return _C.gold;
      default:
        return _C.midGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Row(
        children: [
          Text(plan.badge, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.nameBn,
                  style: TextStyle(
                    color: _nameColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: _C.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: TextStyle(
              color: isPriceFree ? _C.green : _C.textSecondary,
              fontSize: 12,
              fontWeight: isPriceFree ? FontWeight.w700 : FontWeight.w400,
              fontStyle: isPriceFree ? FontStyle.normal : FontStyle.italic,
            ),
          ),
        ],
      ),
    ).animate(delay: delay.ms).fadeIn(duration: 240.ms).slideX(begin: 0.04);
  }
}

class _AmalFreeNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _C.greenLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.green.withOpacity(0.25), width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_rounded, color: _C.midGreen, size: 18),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'সব আমল ট্র্যাকিং সবসময় বিনামূল্যে থাকবে। শুধুমাত্র গ্রুপ ফিচারে পরিকল্পনা প্রযোজ্য।',
              style: TextStyle(color: _C.midGreen, fontSize: 11, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GROUPS BODY — when feature is live
// ─────────────────────────────────────────────────────────────────────────────

class _GroupsBody extends ConsumerWidget {
  final SubscriptionStatus sub;
  final GroupListState groupsAsync;

  const _GroupsBody({required this.sub, required this.groupsAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _TopBar(
            title: 'আমার গ্রুপ',
            showBack: false,
            action: _PlanBadge(plan: sub.effectivePlan),
          ),
        ),

        // Subscription warning if in grace period
        if (sub.inGracePeriod)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: _GracePeriodBanner(sub: sub),
            ),
          ),

        // Group suspended warning
        if (sub.isExpired && !sub.inGracePeriod && sub.isBasic)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: _ExpiredBanner(),
            ),
          ),

        // Loading
        if (groupsAsync.isLoading)
          const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator())),

        // Error
        if (groupsAsync.error != null)
          SliverFillRemaining(
            child: _ErrorBody(message: groupsAsync.error!),
          ),

        // Empty state
        if (!groupsAsync.isLoading &&
            groupsAsync.error == null &&
            groupsAsync.groups.isEmpty)
          SliverFillRemaining(
            child: _EmptyGroupsState(sub: sub),
          ),

        // Group cards
        if (groupsAsync.groups.isNotEmpty) ...[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  final g = groupsAsync.groups[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _GroupCard(
                      group: g,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GroupDetailScreen(groupId: g.id),
                        ),
                      ).then((_) => ref.invalidate(groupListProvider)),
                    ),
                  ).animate(delay: (i * 50).ms).fadeIn().slideY(begin: 0.04);
                },
                childCount: groupsAsync.groups.length,
              ),
            ),
          ),
        ],

        // Bottom padding
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;

  const _GroupCard({required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSuspended = group.isSuspended;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _C.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSuspended ? _C.amber.withOpacity(0.4) : _C.border,
            width: isSuspended ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: group.type == GroupType.family
                    ? _C.greenLight
                    : _C.amberLight,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Center(
                child: Text(
                  group.avatar ??
                      (group.type == GroupType.family ? '👨‍👩‍👧‍👦' : '🤝'),
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          group.name,
                          style: TextStyle(
                            color:
                                isSuspended ? _C.textSecondary : _C.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isSuspended)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: _C.amberLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Suspended',
                            style: TextStyle(
                                color: _C.amber,
                                fontSize: 9,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.people_rounded, size: 12, color: _C.textHint),
                      const SizedBox(width: 4),
                      Text(
                        '${group.memberCount}/${group.maxMembers} সদস্য',
                        style: const TextStyle(
                            color: _C.textSecondary, fontSize: 11),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: _C.textHint,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        group.type.nameBn,
                        style:
                            const TextStyle(color: _C.textHint, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: _C.textHint, size: 20),
          ],
        ),
      ),
    );
  }
}

class _EmptyGroupsState extends StatelessWidget {
  final SubscriptionStatus sub;
  const _EmptyGroupsState({required this.sub});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: _C.greenLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.groups_rounded,
                  color: _C.midGreen, size: 36),
            ),
            const SizedBox(height: 16),
            const Text(
              'কোনো গ্রুপ নেই',
              style: TextStyle(
                color: _C.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'একটি গ্রুপে যোগ দিন বা নতুন গ্রুপ তৈরি করুন',
              style: TextStyle(color: _C.textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _PrimaryBtn(
              label: 'গ্রুপ তৈরি / যোগ দিন',
              icon: Icons.add_rounded,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const CreateJoinGroupScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Banners ──────────────────────────────────────────────────────────────────

class _GracePeriodBanner extends StatelessWidget {
  final SubscriptionStatus sub;
  const _GracePeriodBanner({required this.sub});

  @override
  Widget build(BuildContext context) {
    final days = sub.gracePeriodEnds != null
        ? sub.gracePeriodEnds!.difference(DateTime.now()).inDays
        : 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _C.amberLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.amber.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: _C.amber, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Subscription মেয়াদ শেষ! আরও $days দিন grace period আছে। এর মধ্যে renew করুন।',
              style:
                  const TextStyle(color: _C.amber, fontSize: 11, height: 1.4),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PricingScreen())),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _C.amber,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Renew',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpiredBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_rounded, color: _C.red, size: 18),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Subscription শেষ। গ্রুপগুলো suspended আছে।',
              style: TextStyle(color: _C.red, fontSize: 11),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PricingScreen())),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _C.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Upgrade',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String title;
  final bool showBack;
  final Widget? action;

  const _TopBar({
    required this.title,
    required this.showBack,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          if (showBack)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: _C.cardBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _C.border),
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: _C.textSecondary, size: 18),
              ),
            ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: _C.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

class _PlanBadge extends StatelessWidget {
  final SubscriptionPlan plan;
  const _PlanBadge({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: plan == SubscriptionPlan.gold
            ? _C.gold.withOpacity(0.12)
            : plan == SubscriptionPlan.silver
                ? _C.silver.withOpacity(0.12)
                : _C.greenLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: plan == SubscriptionPlan.gold
              ? _C.gold.withOpacity(0.4)
              : plan == SubscriptionPlan.silver
                  ? _C.silver.withOpacity(0.4)
                  : _C.green.withOpacity(0.3),
        ),
      ),
      child: Text(
        '${plan.badge} ${plan.nameBn}',
        style: TextStyle(
          color: plan == SubscriptionPlan.gold
              ? _C.gold
              : plan == SubscriptionPlan.silver
                  ? _C.silver
                  : _C.midGreen,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PrimaryBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLoading;

  const _PrimaryBtn({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _C.darkGreen,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            else ...[
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OutlineBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _OutlineBtn(
      {required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _C.midGreen.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: _C.midGreen,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 6),
            Icon(icon, color: _C.midGreen, size: 16),
          ],
        ),
      ),
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: _C.darkGreen),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;
  const _ErrorBody({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: _C.textHint, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(color: _C.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
