// lib/features/group/screens/pricing_screen.dart
// (overwrite the placeholder created earlier)

import 'package:amal_tracker/features/group/models/group_mode.dart';
import 'package:amal_tracker/features/group/provider/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'payment_flow_screen.dart';

class _C {
  static const pageBg = Color(0xFFF4F6F1);
  static const cardBg = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const midGreen = Color(0xFF1B7045);
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFFFF8EE);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const silver = Color(0xFF8B92A8);
  static const silverLight = Color(0xFFF0F1F5);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
  static const border = Color(0xFFE4EAE4);
}

class PricingScreen extends ConsumerWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(plansProvider);
    final subAsync = ref.watch(subscriptionProvider);
    final duration = ref.watch(pricingDurationProvider);

    return Scaffold(
      backgroundColor: _C.pageBg,
      body: SafeArea(
        child: plansAsync.when(
          loading: () => const Center(
              child: CircularProgressIndicator(color: _C.darkGreen)),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (plans) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _TopBar()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                  child: Column(
                    children: [
                      const Text(
                        'পরিকল্পনা বেছে নিন',
                        style: TextStyle(
                          color: _C.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'সব আমল ট্র্যাকিং বিনামূল্যে — শুধু গ্রুপ ফিচারে plan প্রযোজ্য',
                        style: TextStyle(
                            color: _C.textSecondary, fontSize: 12, height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      _DurationToggle(
                        current: duration,
                        onChanged: (d) => ref
                            .read(pricingDurationProvider.notifier)
                            .state = d,
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 250.ms),
              ),
              if (plans.comingSoon)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: _ComingSoonBanner(),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final plan = plans.plans[i];
                      final isYearly = duration == 'yearly';
                      final price =
                          isYearly ? plan.priceYearly : plan.priceMonthly;
                      final isCurrent = subAsync.value?.effectivePlan ==
                          SubscriptionPlanX.fromString(plan.id.value);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _PlanCard(
                          plan: plan,
                          price: price,
                          isYearly: isYearly,
                          isCurrent: isCurrent,
                          paymentEnabled: plans.paymentEnabled,
                          onSelect: plan.id == SubscriptionPlan.basic
                              ? null
                              : () {
                                  if (!plans.paymentEnabled) return;
                                  ref
                                      .read(selectedPlanProvider.notifier)
                                      .state = plan.id;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PaymentFlowScreen(
                                        plan: plan.id,
                                        duration: duration,
                                        price: price,
                                      ),
                                    ),
                                  );
                                },
                        ),
                      )
                          .animate(delay: (i * 80).ms)
                          .fadeIn()
                          .slideY(begin: 0.05);
                    },
                    childCount: plans.plans.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  child: _ComparisonTable(plans: plans.plans),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  child: _BottomNote(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DurationToggle extends StatelessWidget {
  final String current;
  final ValueChanged<String> onChanged;
  const _DurationToggle({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.border),
      ),
      child: Row(
        children: [
          _Opt(
              label: 'মাসিক',
              isActive: current == 'monthly',
              onTap: () => onChanged('monthly')),
          _Opt(
              label: 'বার্ষিক',
              isActive: current == 'yearly',
              onTap: () => onChanged('yearly'),
              badge: '২ মাস ফ্রি'),
        ],
      ),
    );
  }
}

class _Opt extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final String? badge;
  const _Opt(
      {required this.label,
      required this.isActive,
      required this.onTap,
      this.badge});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: 180.ms,
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isActive ? _C.darkGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                  style: TextStyle(
                    color: isActive ? Colors.white : _C.textSecondary,
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  )),
              if (badge != null && isActive) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                      color: _C.gold, borderRadius: BorderRadius.circular(6)),
                  child: Text(badge!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final PlanInfo plan;
  final int price;
  final bool isYearly, isCurrent, paymentEnabled;
  final VoidCallback? onSelect;
  const _PlanCard(
      {required this.plan,
      required this.price,
      required this.isYearly,
      required this.isCurrent,
      required this.paymentEnabled,
      this.onSelect});

  Color get _accent {
    switch (plan.id) {
      case SubscriptionPlan.gold:
        return _C.gold;
      case SubscriptionPlan.silver:
        return _C.silver;
      default:
        return _C.midGreen;
    }
  }

  Color get _accentBg {
    switch (plan.id) {
      case SubscriptionPlan.gold:
        return _C.goldLight;
      case SubscriptionPlan.silver:
        return _C.silverLight;
      default:
        return _C.greenLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGold = plan.id == SubscriptionPlan.gold;
    final isFree = plan.id == SubscriptionPlan.basic;

    return Stack(clipBehavior: Clip.none, children: [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _C.cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isGold
                ? _C.gold.withOpacity(0.5)
                : isCurrent
                    ? _accent.withOpacity(0.5)
                    : _C.border,
            width: isGold ? 2 : 1,
          ),
          boxShadow: isGold
              ? [
                  BoxShadow(
                      color: _C.gold.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4))
                ]
              : null,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(plan.badge, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(plan.nameBn,
                  style: TextStyle(
                      color: _accent,
                      fontWeight: FontWeight.w800,
                      fontSize: 16)),
              if (isCurrent)
                const Text('বর্তমান প্ল্যান',
                    style: TextStyle(
                        color: _C.green,
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
            ]),
            const Spacer(),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              if (isFree)
                const Text('বিনামূল্যে',
                    style: TextStyle(
                        color: _C.green,
                        fontWeight: FontWeight.w800,
                        fontSize: 16))
              else ...[
                Text('৳$price',
                    style: const TextStyle(
                        color: _C.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 20)),
                Text(isYearly ? '/বছর' : '/মাস',
                    style: const TextStyle(color: _C.textHint, fontSize: 10)),
              ],
            ]),
          ]),
          const SizedBox(height: 12),
          const Divider(height: 1, color: _C.border),
          const SizedBox(height: 12),
          ...plan.features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: _accent, size: 14),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(f,
                              style: const TextStyle(
                                  color: _C.textSecondary,
                                  fontSize: 12,
                                  height: 1.4))),
                    ]),
              )),
          if (!isFree) ...[
            const SizedBox(height: 12),
            _CTABtn(
                plan: plan,
                paymentEnabled: paymentEnabled,
                isCurrent: isCurrent,
                accent: _accent,
                onTap: onSelect),
          ],
        ]),
      ),
      if (isGold)
        Positioned(
            top: -10,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: _C.gold, borderRadius: BorderRadius.circular(20)),
              child: const Text('সেরা মূল্য',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700)),
            )),
    ]);
  }
}

class _CTABtn extends StatelessWidget {
  final PlanInfo plan;
  final bool paymentEnabled, isCurrent;
  final Color accent;
  final VoidCallback? onTap;
  const _CTABtn(
      {required this.plan,
      required this.paymentEnabled,
      required this.isCurrent,
      required this.accent,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    if (isCurrent) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
            color: _C.greenLight, borderRadius: BorderRadius.circular(12)),
        child:
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.check_rounded, color: _C.green, size: 16),
          SizedBox(width: 6),
          Text('বর্তমান প্ল্যান',
              style: TextStyle(
                  color: _C.green, fontWeight: FontWeight.w700, fontSize: 13)),
        ]),
      );
    }
    if (!paymentEnabled) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
            color: _C.pageBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _C.border)),
        child:
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.schedule_rounded, color: _C.textHint, size: 14),
          SizedBox(width: 6),
          Text('শীঘ্রই আসছে',
              style: TextStyle(
                  color: _C.textSecondary,
                  fontSize: 13,
                  fontStyle: FontStyle.italic)),
        ]),
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
            color: accent, borderRadius: BorderRadius.circular(12)),
        child: Text('${plan.nameBn} নিন',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
            textAlign: TextAlign.center),
      ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  final List<PlanInfo> plans;
  const _ComparisonTable({required this.plans});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ['আমল ট্র্যাকিং', true, true, true],
      ['গ্লোবাল লিডারবোর্ড', true, true, true],
      ['গ্রুপে member', '১টি', '২টি', '৩টি'],
      ['গ্রুপ তৈরি', false, '১টি', '২টি'],
      ['সর্বোচ্চ সদস্য', '৩', '৮', '১৫'],
      ['মাসিক গোল', false, true, true],
      ['Hidden অপশন', false, false, true],
      ['Analytics', false, false, true],
    ];

    return Container(
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border),
      ),
      child: Column(children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text('বিস্তারিত তুলনা',
                  style: TextStyle(
                      color: _C.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14))),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(
              color: _C.pageBg,
              border:
                  Border.symmetric(horizontal: BorderSide(color: _C.border))),
          child: const Row(children: [
            Expanded(flex: 3, child: SizedBox()),
            Expanded(
                child: Text('🆓',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14))),
            Expanded(
                child: Text('🥈',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14))),
            Expanded(
                child: Text('🥇',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14))),
          ]),
        ),
        ...rows.asMap().entries.map((e) {
          final i = e.key;
          final row = e.value;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
                border: i < rows.length - 1
                    ? const Border(
                        bottom: BorderSide(color: _C.border, width: 0.5))
                    : null),
            child: Row(children: [
              Expanded(
                  flex: 3,
                  child: Text(row[0] as String,
                      style: const TextStyle(
                          color: _C.textSecondary, fontSize: 12))),
              ...row.skip(1).map((v) => Expanded(child: _Cell(val: v))),
            ]),
          );
        }),
      ]),
    ).animate(delay: 200.ms).fadeIn(duration: 300.ms);
  }
}

class _Cell extends StatelessWidget {
  final dynamic val;
  const _Cell({required this.val});
  @override
  Widget build(BuildContext context) {
    if (val is bool) {
      return Icon(val ? Icons.check_rounded : Icons.remove_rounded,
          color: val ? _C.green : _C.textHint, size: 16);
    }
    return Text(val.toString(),
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: _C.textPrimary, fontSize: 11, fontWeight: FontWeight.w600));
  }
}

class _ComingSoonBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          const Color(0xFF0E3D22).withOpacity(0.08),
          const Color(0xFF1B7045).withOpacity(0.05),
        ]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0E3D22).withOpacity(0.2)),
      ),
      child: const Row(children: [
        Icon(Icons.schedule_rounded, color: Color(0xFF1B7045), size: 15),
        SizedBox(width: 8),
        Expanded(
            child: Text('গ্রুপ ফিচার শীঘ্রই আসছে। এখন পরিচয় পেতে থাকুন। 🌙',
                style: TextStyle(
                    color: Color(0xFF1B7045), fontSize: 12, height: 1.4))),
      ]),
    );
  }
}

class _BottomNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      Icon(Icons.lock_rounded, color: _C.textHint, size: 18),
      SizedBox(height: 6),
      Text(
        'Manual payment verification এর মাধ্যমে subscription সক্রিয় করা হয়।\nকোনো সমস্যায় support এ যোগাযোগ করুন।',
        style: TextStyle(color: _C.textHint, fontSize: 11, height: 1.5),
        textAlign: TextAlign.center,
      ),
    ]);
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: _C.cardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _C.border)),
            child: const Icon(Icons.arrow_back_rounded,
                color: _C.textSecondary, size: 18),
          ),
        ),
        const SizedBox(width: 12),
        const Text('পরিকল্পনা ও মূল্য',
            style: TextStyle(
                color: _C.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 18)),
      ]),
    );
  }
}
