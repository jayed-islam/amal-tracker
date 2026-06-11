// lib/features/group/screens/create_join_group_screen.dart

import 'package:amal_tracker/core/services/api_service.dart';
import 'package:amal_tracker/features/group/models/group_mode.dart';
import 'package:amal_tracker/features/group/provider/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'group_detail_screen.dart';
import 'pricing_screen.dart';

class _C {
  static const pageBg = Color(0xFFF4F6F1);
  static const cardBg = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const midGreen = Color(0xFF1B7045);
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFFFF8EE);
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
// CREATE / JOIN SCREEN — tab switcher
// ─────────────────────────────────────────────────────────────────────────────

class CreateJoinGroupScreen extends ConsumerStatefulWidget {
  const CreateJoinGroupScreen({super.key});

  @override
  ConsumerState<CreateJoinGroupScreen> createState() =>
      _CreateJoinGroupScreenState();
}

class _CreateJoinGroupScreenState extends ConsumerState<CreateJoinGroupScreen> {
  int _tab = 0; // 0 = join, 1 = create

  @override
  Widget build(BuildContext context) {
    final subAsync = ref.watch(subscriptionProvider);
    final eligibilityAsync = ref.watch(groupEligibilityAsync);

    return Scaffold(
      backgroundColor: _C.pageBg,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(),
            _TabBar(
              current: _tab,
              onChanged: (t) => setState(() => _tab = t),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: 200.ms,
                child: _tab == 0
                    ? _JoinTab(key: const ValueKey(0))
                    : _CreateTab(
                        key: const ValueKey(1),
                        subAsync: subAsync,
                        eligibilityAsync: eligibilityAsync,
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
// JOIN TAB — invite code or request
// ─────────────────────────────────────────────────────────────────────────────

class _JoinTab extends ConsumerStatefulWidget {
  const _JoinTab({super.key});

  @override
  ConsumerState<_JoinTab> createState() => _JoinTabState();
}

class _JoinTabState extends ConsumerState<_JoinTab> {
  final _codeCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _codeCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _joinByCode() async {
    final code = _codeCtrl.text.trim().toUpperCase();
    if (code.length != 6) {
      setState(() => _error = '৬ সংখ্যার invite code দিন');
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final group = await ref.read(groupListProvider.notifier).joinByCode(code);
      if (group != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => GroupDetailScreen(groupId: group.id)),
        );
      }
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Invite code section
          _SectionLabel('Invite Code দিয়ে যোগ দিন'),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _C.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _C.border),
            ),
            child: Column(
              children: [
                // Code input
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _codeCtrl,
                        textCapitalization: TextCapitalization.characters,
                        maxLength: 6,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[A-Z0-9a-z]')),
                        ],
                        style: const TextStyle(
                          color: _C.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 4,
                        ),
                        decoration: InputDecoration(
                          hintText: 'AB12CD',
                          hintStyle: const TextStyle(
                            color: _C.textHint,
                            letterSpacing: 4,
                            fontSize: 20,
                          ),
                          counterText: '',
                          filled: true,
                          fillColor: _C.pageBg,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 13),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: _C.border, width: 0.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: _C.border, width: 0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: _C.darkGreen, width: 1.5),
                          ),
                        ),
                        onChanged: (_) => setState(() => _error = null),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _isLoading ? null : _joinByCode,
                      child: AnimatedContainer(
                        duration: 160.ms,
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: _C.darkGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _isLoading
                            ? const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                ),
                              )
                            : const Icon(Icons.arrow_forward_rounded,
                                color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),

                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: _C.red, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(color: _C.red, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ).animate().fadeIn(duration: 240.ms),

          const SizedBox(height: 24),

          // Divider
          Row(
            children: [
              const Expanded(child: Divider(color: _C.border, height: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'অথবা',
                  style: const TextStyle(color: _C.textHint, fontSize: 12),
                ),
              ),
              const Expanded(child: Divider(color: _C.border, height: 1)),
            ],
          ),

          const SizedBox(height: 24),

          // Request section
          _SectionLabel('Group এ Request পাঠান'),
          const SizedBox(height: 6),
          Text(
            'Group ID বা link জানলে request পাঠাতে পারেন। Admin accept করলে যোগ হবেন।',
            style: const TextStyle(
                color: _C.textSecondary, fontSize: 12, height: 1.5),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _C.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _C.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _C.greenLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.person_add_rounded,
                      color: _C.midGreen, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Group খোঁজার ফিচার শীঘ্রই আসছে।\nএখন invite code দিয়ে join করুন।',
                    style: TextStyle(
                        color: _C.textSecondary, fontSize: 12, height: 1.4),
                  ),
                ),
              ],
            ),
          ).animate(delay: 80.ms).fadeIn(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CREATE TAB
// ─────────────────────────────────────────────────────────────────────────────

class _CreateTab extends ConsumerStatefulWidget {
  final AsyncValue<SubscriptionStatus> subAsync;
  final AsyncValue<GroupEligibility> eligibilityAsync;

  const _CreateTab({
    super.key,
    required this.subAsync,
    required this.eligibilityAsync,
  });

  @override
  ConsumerState<_CreateTab> createState() => _CreateTabState();
}

class _CreateTabState extends ConsumerState<_CreateTab> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  GroupType _type = GroupType.circle;
  bool _isPrivate = true;
  String _avatar = '🤝';
  bool _isLoading = false;
  String? _error;

  final _avatarOptions = [
    '🤝',
    '👨‍👩‍👧‍👦',
    '🌙',
    '📿',
    '🕌',
    '📖',
    '⭐',
    '🌿',
    '🤲',
    '💚'
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final group = await ref.read(groupListProvider.notifier).createGroup(
            name: _nameCtrl.text.trim(),
            description: _descCtrl.text.trim(),
            type: _type,
            avatar: _avatar,
            isPrivate: _isPrivate,
          );
      if (group != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => GroupDetailScreen(groupId: group.id)),
        );
      }
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.subAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: _C.darkGreen)),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (sub) {
        // Basic plan — cannot create
        if (!sub.limits.canCreateGroup) {
          return _UpgradeToCreate(sub: sub);
        }

        return widget.eligibilityAsync.when(
          loading: () => const Center(
              child: CircularProgressIndicator(color: _C.darkGreen)),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (eligibility) {
            if (!eligibility.eligible) {
              return _AmalRequirementGate(eligibility: eligibility);
            }
            return _CreateForm(
              nameCtrl: _nameCtrl,
              descCtrl: _descCtrl,
              type: _type,
              isPrivate: _isPrivate,
              avatar: _avatar,
              avatarOptions: _avatarOptions,
              isLoading: _isLoading,
              error: _error,
              onTypeChanged: (t) => setState(() => _type = t),
              onPrivacyChanged: (v) => setState(() => _isPrivate = v),
              onAvatarChanged: (a) => setState(() => _avatar = a),
              onCreate: _create,
            );
          },
        );
      },
    );
  }
}

// ─── Upgrade Gate ─────────────────────────────────────────────────────────────

class _UpgradeToCreate extends StatelessWidget {
  final SubscriptionStatus sub;
  const _UpgradeToCreate({required this.sub});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _C.goldLight,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.lock_rounded, color: _C.gold, size: 30),
          ).animate().scale(
              begin: const Offset(0.7, 0.7),
              duration: 350.ms,
              curve: Curves.elasticOut),

          const SizedBox(height: 16),
          const Text(
            'Silver বা Gold প্ল্যান দরকার',
            style: TextStyle(
              color: _C.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Group তৈরি করতে Silver বা Gold plan নিতে হবে। Basic plan এ শুধু group এ join করা যায়।',
            style:
                TextStyle(color: _C.textSecondary, fontSize: 13, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Plan comparison quick view
          _QuickPlanRow(
            emoji: '🥈',
            name: 'Silver',
            desc: '১টি group, ৮ সদস্য',
            price: '৳৯৯/মাস',
            color: _C.silver,
          ),
          const SizedBox(height: 10),
          _QuickPlanRow(
            emoji: '🥇',
            name: 'Gold',
            desc: '২টি group, ১৫ সদস্য',
            price: '৳১৯৯/মাস',
            color: _C.gold,
          ),

          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PricingScreen()),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _C.darkGreen,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upgrade_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'প্ল্যান দেখুন',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickPlanRow extends StatelessWidget {
  final String emoji, name, desc, price;
  final Color color;
  const _QuickPlanRow({
    required this.emoji,
    required this.name,
    required this.desc,
    required this.price,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
                Text(desc,
                    style:
                        const TextStyle(color: _C.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Text(price,
              style: const TextStyle(
                  color: _C.textHint,
                  fontSize: 12,
                  fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}

// ─── Amal Requirement Gate ────────────────────────────────────────────────────

class _AmalRequirementGate extends StatelessWidget {
  final GroupEligibility eligibility;
  const _AmalRequirementGate({required this.eligibility});

  @override
  Widget build(BuildContext context) {
    final stats = eligibility.stats;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _C.amberLight,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.trending_up_rounded,
                color: _C.amber, size: 30),
          ).animate().scale(
              begin: const Offset(0.7, 0.7),
              duration: 350.ms,
              curve: Curves.elasticOut),

          const SizedBox(height: 16),
          const Text(
            'আরও আমল করতে হবে',
            style: TextStyle(
              color: _C.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            eligibility.reason ??
                'Group তৈরি করতে নির্দিষ্ট পরিমাণ আমল করতে হবে।',
            style: const TextStyle(
                color: _C.textSecondary, fontSize: 13, height: 1.5),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Requirements
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _C.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _C.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'প্রয়োজনীয় শর্ত',
                  style: TextStyle(
                    color: _C.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                _ReqRow(
                  label: 'গত মাসে completion',
                  required: '≥ ৬০%',
                  current: stats != null
                      ? '${stats['completionPercentage'] ?? 0}%'
                      : null,
                  met: stats != null &&
                      (stats['completionPercentage'] ?? 0) >= 60,
                ),
                const SizedBox(height: 8),
                _ReqRow(
                  label: 'বর্তমান streak',
                  required: '≥ ৭ দিন',
                  current:
                      stats != null ? '${stats['streakDays'] ?? 0} দিন' : null,
                  met: stats != null && (stats['streakDays'] ?? 0) >= 7,
                ),
                const SizedBox(height: 8),
                _ReqRow(
                  label: 'Account বয়স',
                  required: '≥ ১৪ দিন',
                  current: stats != null
                      ? '${stats['accountAgeDays'] ?? 0} দিন'
                      : null,
                  met: stats != null && (stats['accountAgeDays'] ?? 0) >= 14,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: _C.greenLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _C.green.withOpacity(0.25)),
            ),
            child: Row(
              children: const [
                Icon(Icons.lightbulb_outline_rounded,
                    color: _C.midGreen, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'প্রতিদিন আমল করতে থাকুন। শর্ত পূরণ হলে group তৈরি করতে পারবেন।',
                    style: TextStyle(
                        color: _C.midGreen, fontSize: 11, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReqRow extends StatelessWidget {
  final String label;
  final String required;
  final String? current;
  final bool met;

  const _ReqRow({
    required this.label,
    required this.required,
    this.current,
    required this.met,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          met
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          color: met ? _C.green : _C.textHint,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: _C.textSecondary, fontSize: 12),
          ),
        ),
        Text(
          required,
          style: TextStyle(
            color: met ? _C.green : _C.textHint,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (current != null) ...[
          const SizedBox(width: 6),
          Text(
            '($current)',
            style: TextStyle(
              color: met ? _C.green : _C.amber,
              fontSize: 10,
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Create Form ──────────────────────────────────────────────────────────────

class _CreateForm extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController descCtrl;
  final GroupType type;
  final bool isPrivate;
  final String avatar;
  final List<String> avatarOptions;
  final bool isLoading;
  final String? error;
  final ValueChanged<GroupType> onTypeChanged;
  final ValueChanged<bool> onPrivacyChanged;
  final ValueChanged<String> onAvatarChanged;
  final VoidCallback onCreate;

  const _CreateForm({
    required this.nameCtrl,
    required this.descCtrl,
    required this.type,
    required this.isPrivate,
    required this.avatar,
    required this.avatarOptions,
    required this.isLoading,
    this.error,
    required this.onTypeChanged,
    required this.onPrivacyChanged,
    required this.onAvatarChanged,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar picker
          _SectionLabel('Group Avatar'),
          const SizedBox(height: 10),
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: avatarOptions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final opt = avatarOptions[i];
                final isSelected = opt == avatar;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onAvatarChanged(opt);
                  },
                  child: AnimatedContainer(
                    duration: 160.ms,
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected ? _C.darkGreen : _C.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? _C.darkGreen : _C.border,
                        width: isSelected ? 2 : 0.5,
                      ),
                    ),
                    child: Center(
                      child: Text(opt, style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 18),

          // Group type
          _SectionLabel('গ্রুপের ধরন'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _TypeCard(
                  type: GroupType.circle,
                  isSelected: type == GroupType.circle,
                  onTap: () => onTypeChanged(GroupType.circle),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TypeCard(
                  type: GroupType.family,
                  isSelected: type == GroupType.family,
                  onTap: () => onTypeChanged(GroupType.family),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Name field
          _SectionLabel('গ্রুপের নাম (ঐচ্ছিক)'),
          const SizedBox(height: 6),
          TextField(
            controller: nameCtrl,
            maxLength: 50,
            style: const TextStyle(color: _C.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'না দিলে Islamic নাম auto দেওয়া হবে',
              hintStyle: const TextStyle(color: _C.textHint, fontSize: 12),
              counterText: '',
              filled: true,
              fillColor: _C.cardBg,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _C.border, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _C.border, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _C.darkGreen, width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Description
          _SectionLabel('বিবরণ (ঐচ্ছিক)'),
          const SizedBox(height: 6),
          TextField(
            controller: descCtrl,
            maxLength: 200,
            maxLines: 2,
            style: const TextStyle(color: _C.textPrimary, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'গ্রুপ সম্পর্কে কিছু লিখুন...',
              hintStyle: const TextStyle(color: _C.textHint, fontSize: 12),
              counterText: '',
              filled: true,
              fillColor: _C.cardBg,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _C.border, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _C.border, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _C.darkGreen, width: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Privacy toggle
          GestureDetector(
            onTap: () => onPrivacyChanged(!isPrivate),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _C.cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _C.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isPrivate ? _C.greenLight : _C.amberLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isPrivate ? Icons.lock_rounded : Icons.lock_open_rounded,
                      color: isPrivate ? _C.midGreen : _C.amber,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isPrivate ? 'Private Group' : 'Public Group',
                          style: const TextStyle(
                            color: _C.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          isPrivate
                              ? 'Request অনুমোদন করতে হবে'
                              : 'Invite code দিয়ে সরাসরি join',
                          style: const TextStyle(
                              color: _C.textSecondary, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  _ToggleSwitch(value: isPrivate, onChanged: onPrivacyChanged),
                ],
              ),
            ),
          ),

          if (error != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _C.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded,
                      color: _C.red, size: 14),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(error!,
                        style: const TextStyle(color: _C.red, fontSize: 11)),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          GestureDetector(
            onTap: isLoading ? null : onCreate,
            child: AnimatedContainer(
              duration: 160.ms,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isLoading ? _C.darkGreen.withOpacity(0.7) : _C.darkGreen,
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
                    const Icon(Icons.group_add_rounded,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    const Text(
                      'গ্রুপ তৈরি করুন',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final GroupType type;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final emoji = type == GroupType.family ? '👨‍👩‍👧‍👦' : '🤝';
    final label = type == GroupType.family ? 'পারিবারিক' : 'বন্ধু / সার্কেল';
    final sublabel =
        type == GroupType.family ? 'পরিবারের সাথে' : 'বন্ধু বা সহকর্মী';

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: 160.ms,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? _C.greenLight : _C.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? _C.darkGreen : _C.border,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? _C.darkGreen : _C.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              sublabel,
              style: const TextStyle(color: _C.textHint, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED SMALL WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _C.cardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _C.border),
              ),
              child: const Icon(Icons.arrow_back_rounded,
                  color: _C.textSecondary, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'গ্রুপে যোগ দিন',
            style: TextStyle(
              color: _C.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final int current;
  final ValueChanged<int> onChanged;

  const _TabBar({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _C.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _C.border),
        ),
        child: Row(
          children: [
            _Tab(
              label: 'যোগ দিন',
              icon: Icons.login_rounded,
              isActive: current == 0,
              onTap: () => onChanged(0),
            ),
            _Tab(
              label: 'তৈরি করুন',
              icon: Icons.add_rounded,
              isActive: current == 1,
              onTap: () => onChanged(1),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _Tab({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

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
              Icon(
                icon,
                size: 15,
                color: isActive ? Colors.white : _C.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : _C.textSecondary,
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: _C.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: 200.ms,
        width: 44,
        height: 24,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? _C.midGreen : _C.borderMid,
          borderRadius: BorderRadius.circular(99),
        ),
        child: AnimatedAlign(
          duration: 200.ms,
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 18,
            height: 18,
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

// Provider for eligibility — autoDispose family with refresh
final groupEligibilityAsync =
    FutureProvider.autoDispose<GroupEligibility>((ref) async {
  final api = ref.read(apiServiceProvider);
  final res = await api.get<Map<String, dynamic>>('/groups/eligibility');
  return GroupEligibility.fromJson(res['data'] ?? {});
});

// ApiException placeholder — use your existing one
class ApiException implements Exception {
  final String message;
  final String? code;
  const ApiException(this.message, {this.code});
}
