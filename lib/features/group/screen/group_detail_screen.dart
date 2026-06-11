// lib/features/group/screens/group_detail_screen.dart

import 'package:amal_tracker/features/group/models/group_mode.dart';
import 'package:amal_tracker/features/group/provider/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'group_leaderboard_screen.dart';

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
}

// ─────────────────────────────────────────────────────────────────────────────
// GROUP DETAIL SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class GroupDetailScreen extends ConsumerWidget {
  final String groupId;
  const GroupDetailScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(groupDetailProvider(groupId));

    return Scaffold(
      backgroundColor: _C.pageBg,
      body: SafeArea(
        child: state.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: _C.darkGreen))
            : state.error != null
                ? Center(child: Text(state.error!))
                : state.group == null
                    ? const Center(child: Text('Group not found'))
                    : _DetailBody(group: state.group!, groupId: groupId),
      ),
    );
  }
}

class _DetailBody extends ConsumerStatefulWidget {
  final Group group;
  final String groupId;
  const _DetailBody({required this.group, required this.groupId});

  @override
  ConsumerState<_DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends ConsumerState<_DetailBody> {
  // Get current user id from auth provider
  String get _myUserId {
    // Replace with your actual auth provider
    // e.g. ref.read(currentUserProvider)?.id ?? ''
    return '';
  }

  bool get _isAdmin {
    final me = widget.group.memberById(_myUserId);
    return me?.isAdmin == true;
  }

  bool get _isCreator => widget.group.createdBy == _myUserId;

  Future<void> _copyInviteCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invite code copied!'),
          backgroundColor: _C.darkGreen,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _refreshInviteCode() async {
    final code = await ref
        .read(groupDetailProvider(widget.groupId).notifier)
        .refreshInviteCode();
    if (code != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('নতুন code: $code'),
          backgroundColor: _C.darkGreen,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Future<void> _leaveGroup() async {
    final confirm = await _showConfirmDialog(
      context,
      title: 'গ্রুপ ছাড়বেন?',
      message: 'আপনি এই group ছেড়ে দিতে চান?',
      confirmLabel: 'হ্যাঁ, ছেড়ে দিন',
      isDanger: true,
    );
    if (confirm != true) return;

    final ok =
        await ref.read(groupListProvider.notifier).leaveGroup(widget.groupId);
    if (ok && mounted) Navigator.pop(context);
  }

  Future<void> _deleteGroup() async {
    final confirm = await _showConfirmDialog(
      context,
      title: 'গ্রুপ delete করবেন?',
      message: 'এই group permanently delete হয়ে যাবে। সব member হারিয়ে যাবে।',
      confirmLabel: 'Delete করুন',
      isDanger: true,
    );
    if (confirm != true) return;

    final ok = await ref
        .read(groupDetailProvider(widget.groupId).notifier)
        .deleteGroup();
    if (ok && mounted) {
      ref.read(groupListProvider.notifier).removeGroup(widget.groupId);
      Navigator.pop(context);
    }
  }

  Future<void> _kickMember(GroupMember member) async {
    final confirm = await _showConfirmDialog(
      context,
      title: '${member.displayName} কে remove করবেন?',
      message: '${KICK_RESTRICTION_DAYS} দিন পুনরায় join করতে পারবে না।',
      confirmLabel: 'Remove করুন',
      isDanger: true,
    );
    if (confirm != true) return;

    await ref
        .read(groupDetailProvider(widget.groupId).notifier)
        .kickMember(member.userId);
  }

  static const KICK_RESTRICTION_DAYS = 30;

  @override
  Widget build(BuildContext context) {
    final group = widget.group;

    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: _GroupHeader(
            group: group,
            isAdmin: _isAdmin,
            onLeave: _leaveGroup,
            onDelete: _isCreator ? _deleteGroup : null,
          ),
        ),

        // Suspended warning
        if (group.isSuspended)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: _SuspendedBanner(),
            ),
          ),

        // Quick stats
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: _QuickStatsRow(group: group),
          ),
        ),

        // Leaderboard button
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: _LeaderboardBtn(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      GroupLeaderboardScreen(groupId: widget.groupId),
                ),
              ),
            ),
          ).animate(delay: 50.ms).fadeIn().slideY(begin: 0.04),
        ),

        // Invite code (admin only)
        if (_isAdmin && group.inviteCode != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: _InviteCodeCard(
                code: group.inviteCode!,
                onCopy: () => _copyInviteCode(group.inviteCode!),
                onRefresh: _refreshInviteCode,
              ),
            ).animate(delay: 80.ms).fadeIn(),
          ),

        // Join requests (admin only)
        if (_isAdmin)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: _JoinRequestsCard(groupId: widget.groupId),
            ),
          ),

        // Members section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'সদস্যরা (${group.memberCount}/${group.maxMembers})',
                  style: const TextStyle(
                    color: _C.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) {
                final member = group.members[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _MemberCard(
                    member: member,
                    isMe: member.userId == _myUserId,
                    isAdmin: _isAdmin,
                    isCreator: _isCreator,
                    onKick: _isAdmin && member.userId != _myUserId
                        ? () => _kickMember(member)
                        : null,
                    onPromote: _isCreator &&
                            member.userId != _myUserId &&
                            member.role == GroupMemberRole.member
                        ? () => ref
                            .read(groupDetailProvider(widget.groupId).notifier)
                            .updateMemberRole(member.userId, 'admin')
                        : null,
                    onDemote: _isCreator &&
                            member.userId != _myUserId &&
                            member.role == GroupMemberRole.admin
                        ? () => ref
                            .read(groupDetailProvider(widget.groupId).notifier)
                            .updateMemberRole(member.userId, 'member')
                        : null,
                  ),
                ).animate(delay: (i * 40).ms).fadeIn().slideX(begin: 0.03);
              },
              childCount: group.members.length,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

// ─── Group Header ─────────────────────────────────────────────────────────────

class _GroupHeader extends StatelessWidget {
  final Group group;
  final bool isAdmin;
  final VoidCallback onLeave;
  final VoidCallback? onDelete;

  const _GroupHeader({
    required this.group,
    required this.isAdmin,
    required this.onLeave,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0E3D22), Color(0xFF1B7045)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Top row
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
              const Spacer(),
              // More options
              PopupMenuButton<String>(
                icon: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.more_vert_rounded,
                      color: Colors.white, size: 18),
                ),
                color: _C.cardBg,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onSelected: (val) {
                  if (val == 'leave') onLeave();
                  if (val == 'delete' && onDelete != null) onDelete!();
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'leave',
                    child: Row(
                      children: [
                        Icon(Icons.logout_rounded, color: _C.amber, size: 16),
                        SizedBox(width: 8),
                        Text('Group ছেড়ে দিন',
                            style: TextStyle(color: _C.amber, fontSize: 13)),
                      ],
                    ),
                  ),
                  if (onDelete != null)
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded,
                              color: _C.red, size: 16),
                          SizedBox(width: 8),
                          Text('Group delete করুন',
                              style: TextStyle(color: _C.red, fontSize: 13)),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Group info
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    group.avatar ??
                        (group.type == GroupType.family ? '👨‍👩‍👧‍👦' : '🤝'),
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            group.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isAdmin)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: _C.gold.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: _C.gold.withOpacity(0.4)),
                            ),
                            child: const Text(
                              'Admin',
                              style: TextStyle(
                                color: _C.gold,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${group.type.nameBn} • ${group.memberCount}/${group.maxMembers} সদস্য',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                    if (group.description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        group.description!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Quick Stats ──────────────────────────────────────────────────────────────

class _QuickStatsRow extends StatelessWidget {
  final Group group;
  const _QuickStatsRow({required this.group});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.people_rounded,
            label: 'সদস্য',
            value: '${group.memberCount}',
            color: _C.midGreen,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.lock_rounded,
            label: group.settings.isPrivate ? 'Private' : 'Public',
            value: group.settings.isPrivate ? '🔒' : '🔓',
            color: _C.amber,
            isEmoji: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.flag_rounded,
            label: 'গ্রুপ গোল',
            value: group.monthlyGoal?.hasGoal == true ? 'আছে' : 'নেই',
            color: _C.gold,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.05);
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isEmoji;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.isEmoji = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.border, width: 0.5),
      ),
      child: Column(
        children: [
          if (isEmoji)
            Text(value, style: const TextStyle(fontSize: 20))
          else
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(color: _C.textHint, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

// ─── Leaderboard Button ───────────────────────────────────────────────────────

class _LeaderboardBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _LeaderboardBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0E3D22), Color(0xFF1B7045)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.leaderboard_rounded,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'গ্রুপ লিডারবোর্ড',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'এই মাসের ranking দেখুন',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: Colors.white60, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── Invite Code Card ─────────────────────────────────────────────────────────

class _InviteCodeCard extends StatelessWidget {
  final String code;
  final VoidCallback onCopy;
  final VoidCallback onRefresh;

  const _InviteCodeCard({
    required this.code,
    required this.onCopy,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Invite Code',
            style: TextStyle(
              color: _C.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: _C.pageBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _C.border),
                  ),
                  child: Text(
                    code,
                    style: const TextStyle(
                      color: _C.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      letterSpacing: 5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onCopy,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _C.greenLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.copy_rounded,
                      color: _C.midGreen, size: 18),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onRefresh,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _C.amberLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.refresh_rounded,
                      color: _C.amber, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'এই code share করুন। Refresh করলে পুরনো code invalid হবে।',
            style: TextStyle(color: _C.textHint, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

// ─── Join Requests Card ───────────────────────────────────────────────────────

class _JoinRequestsCard extends ConsumerWidget {
  final String groupId;
  const _JoinRequestsCard({required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(joinRequestsProvider(groupId));

    if (state.isLoading || state.requests.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_add_rounded, color: _C.amber, size: 16),
              const SizedBox(width: 6),
              Text(
                'Join Request (${state.requests.length})',
                style: const TextStyle(
                  color: _C.amber,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...state.requests.map(
            (req) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _RequestRow(
                request: req,
                isReviewing: state.isReviewing,
                onAccept: () => ref
                    .read(joinRequestsProvider(groupId).notifier)
                    .review(req.id, 'accept'),
                onReject: () => ref
                    .read(joinRequestsProvider(groupId).notifier)
                    .review(req.id, 'reject'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestRow extends StatelessWidget {
  final GroupJoinRequest request;
  final bool isReviewing;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _RequestRow({
    required this.request,
    required this.isReviewing,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: _C.pageBg,
          child: Text(
            request.userName.isNotEmpty
                ? request.userName[0].toUpperCase()
                : '?',
            style: const TextStyle(
                color: _C.textPrimary, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request.userName,
                style: const TextStyle(
                    color: _C.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
              ),
              if (request.message != null && request.message!.isNotEmpty)
                Text(
                  request.message!,
                  style: const TextStyle(color: _C.textSecondary, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: isReviewing ? null : onReject,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.close_rounded, color: _C.red, size: 16),
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: isReviewing ? null : onAccept,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _C.greenLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.check_rounded, color: _C.green, size: 16),
          ),
        ),
      ],
    );
  }
}

// ─── Member Card ──────────────────────────────────────────────────────────────

class _MemberCard extends StatelessWidget {
  final GroupMember member;
  final bool isMe;
  final bool isAdmin;
  final bool isCreator;
  final VoidCallback? onKick;
  final VoidCallback? onPromote;
  final VoidCallback? onDemote;

  const _MemberCard({
    required this.member,
    required this.isMe,
    required this.isAdmin,
    required this.isCreator,
    this.onKick,
    this.onPromote,
    this.onDemote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isMe ? _C.greenLight : _C.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isMe ? _C.green.withOpacity(0.3) : _C.border,
          width: isMe ? 1.5 : 0.5,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: _C.pageBg,
            backgroundImage:
                member.avatar != null ? NetworkImage(member.avatar!) : null,
            child: member.avatar == null
                ? Text(
                    member.displayName.isNotEmpty
                        ? member.displayName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                        color: _C.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                  )
                : null,
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.displayName,
                      style: TextStyle(
                        color: isMe ? _C.darkGreen : _C.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _C.darkGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'আপনি',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ],
                ),
                if (member.district != null)
                  Text(
                    member.district!,
                    style: const TextStyle(color: _C.textHint, fontSize: 11),
                  ),
              ],
            ),
          ),

          // Role badge
          if (member.isAdmin)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: _C.gold.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _C.gold.withOpacity(0.3)),
              ),
              child: const Text(
                'Admin',
                style: TextStyle(
                    color: _C.gold, fontSize: 9, fontWeight: FontWeight.w700),
              ),
            ),

          // Admin actions
          if ((onKick != null || onPromote != null || onDemote != null) &&
              !isMe)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded,
                  color: _C.textHint, size: 18),
              color: _C.cardBg,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onSelected: (val) {
                if (val == 'kick' && onKick != null) onKick!();
                if (val == 'promote' && onPromote != null) onPromote!();
                if (val == 'demote' && onDemote != null) onDemote!();
              },
              itemBuilder: (_) => [
                if (onKick != null)
                  const PopupMenuItem(
                    value: 'kick',
                    child: Row(
                      children: [
                        Icon(Icons.person_remove_rounded,
                            color: _C.red, size: 15),
                        SizedBox(width: 8),
                        Text('Remove করুন',
                            style: TextStyle(color: _C.red, fontSize: 13)),
                      ],
                    ),
                  ),
                if (onPromote != null)
                  const PopupMenuItem(
                    value: 'promote',
                    child: Row(
                      children: [
                        Icon(Icons.arrow_upward_rounded,
                            color: _C.midGreen, size: 15),
                        SizedBox(width: 8),
                        Text('Admin করুন',
                            style: TextStyle(color: _C.midGreen, fontSize: 13)),
                      ],
                    ),
                  ),
                if (onDemote != null)
                  const PopupMenuItem(
                    value: 'demote',
                    child: Row(
                      children: [
                        Icon(Icons.arrow_downward_rounded,
                            color: _C.amber, size: 15),
                        SizedBox(width: 8),
                        Text('Member করুন',
                            style: TextStyle(color: _C.amber, fontSize: 13)),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

// ─── Suspended Banner ─────────────────────────────────────────────────────────

class _SuspendedBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _C.amberLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.amber.withOpacity(0.4)),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: _C.amber, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'এই group টি suspended। Admin এর subscription renew হলে চালু হবে।',
              style: TextStyle(color: _C.amber, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Confirm Dialog ───────────────────────────────────────────────────────────

Future<bool?> _showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool isDanger = false,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: _C.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        title,
        style: const TextStyle(
            color: _C.textPrimary, fontWeight: FontWeight.w700, fontSize: 16),
      ),
      content: Text(
        message,
        style:
            const TextStyle(color: _C.textSecondary, fontSize: 13, height: 1.4),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('বাতিল', style: TextStyle(color: _C.textSecondary)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(
            confirmLabel,
            style: TextStyle(
              color: isDanger ? _C.red : _C.midGreen,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}
