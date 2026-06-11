// lib/features/group/models/group_model.dart

// ─── Enums ────────────────────────────────────────────────────────────────────

enum GroupType { family, circle }

enum GroupMemberRole { admin, member }

enum GroupStatus { active, suspended, archived }

enum JoinRequestStatus { pending, accepted, rejected }

enum SubscriptionPlan { basic, silver, gold }

enum PaymentMethod { bkash, nagad, bank }

enum PaymentDuration { monthly, yearly }

enum PaymentStatus { pending, approved, rejected, duplicate }

// ─── Extensions ───────────────────────────────────────────────────────────────

extension SubscriptionPlanX on SubscriptionPlan {
  String get value => name;

  String get nameBn {
    switch (this) {
      case SubscriptionPlan.basic:
        return 'বেসিক';
      case SubscriptionPlan.silver:
        return 'সিলভার';
      case SubscriptionPlan.gold:
        return 'গোল্ড';
    }
  }

  String get badge {
    switch (this) {
      case SubscriptionPlan.basic:
        return '🆓';
      case SubscriptionPlan.silver:
        return '🥈';
      case SubscriptionPlan.gold:
        return '🥇';
    }
  }

  bool get canCreateGroup => this != SubscriptionPlan.basic;

  static SubscriptionPlan fromString(String s) {
    switch (s) {
      case 'silver':
        return SubscriptionPlan.silver;
      case 'gold':
        return SubscriptionPlan.gold;
      default:
        return SubscriptionPlan.basic;
    }
  }
}

extension PaymentMethodX on PaymentMethod {
  String get value => name;
  String get displayName {
    switch (this) {
      case PaymentMethod.bkash:
        return 'bKash';
      case PaymentMethod.nagad:
        return 'Nagad';
      case PaymentMethod.bank:
        return 'Bank Transfer';
    }
  }
}

extension GroupTypeX on GroupType {
  String get value => name;
  String get nameBn =>
      this == GroupType.family ? 'পারিবারিক' : 'বন্ধু / সার্কেল';
}

// ─── Plan Limits ──────────────────────────────────────────────────────────────

class PlanLimits {
  final bool canCreateGroup;
  final int maxGroupsAsAdmin;
  final int maxGroupsAsMember;
  final int maxMembersPerGroup;
  final bool canSetMonthlyGoal;
  final bool canHideGroup;
  final bool canSeeAnalytics;
  final bool canExport;

  const PlanLimits({
    required this.canCreateGroup,
    required this.maxGroupsAsAdmin,
    required this.maxGroupsAsMember,
    required this.maxMembersPerGroup,
    required this.canSetMonthlyGoal,
    required this.canHideGroup,
    required this.canSeeAnalytics,
    required this.canExport,
  });

  factory PlanLimits.fromJson(Map<String, dynamic> j) => PlanLimits(
        canCreateGroup: j['canCreateGroup'] ?? false,
        maxGroupsAsAdmin: j['maxGroupsAsAdmin'] ?? 0,
        maxGroupsAsMember: j['maxGroupsAsMember'] ?? 1,
        maxMembersPerGroup: j['maxMembersPerGroup'] ?? 3,
        canSetMonthlyGoal: j['canSetMonthlyGoal'] ?? false,
        canHideGroup: j['canHideGroup'] ?? false,
        canSeeAnalytics: j['canSeeAnalytics'] ?? false,
        canExport: j['canExport'] ?? false,
      );
}

// ─── Subscription ─────────────────────────────────────────────────────────────

class SubscriptionStatus {
  final SubscriptionPlan currentPlan;
  final SubscriptionPlan effectivePlan;
  final DateTime? expiresAt;
  final DateTime? gracePeriodEnds;
  final bool isExpired;
  final bool inGracePeriod;
  final bool isFoundingMember;
  final bool paymentEnabled;
  final PlanLimits limits;
  final PendingPaymentRequest? pendingRequest;
  final String? upgradeMessage;

  const SubscriptionStatus({
    required this.currentPlan,
    required this.effectivePlan,
    required this.expiresAt,
    required this.gracePeriodEnds,
    required this.isExpired,
    required this.inGracePeriod,
    required this.isFoundingMember,
    required this.paymentEnabled,
    required this.limits,
    this.pendingRequest,
    this.upgradeMessage,
  });

  factory SubscriptionStatus.fromJson(Map<String, dynamic> j) =>
      SubscriptionStatus(
        currentPlan: SubscriptionPlanX.fromString(j['currentPlan'] ?? 'basic'),
        effectivePlan:
            SubscriptionPlanX.fromString(j['effectivePlan'] ?? 'basic'),
        expiresAt:
            j['expiresAt'] != null ? DateTime.tryParse(j['expiresAt']) : null,
        gracePeriodEnds: j['gracePeriodEnds'] != null
            ? DateTime.tryParse(j['gracePeriodEnds'])
            : null,
        isExpired: j['isExpired'] ?? false,
        inGracePeriod: j['inGracePeriod'] ?? false,
        isFoundingMember: j['isFoundingMember'] ?? false,
        paymentEnabled: j['paymentEnabled'] ?? false,
        limits: PlanLimits.fromJson(j['limits'] ?? {}),
        pendingRequest: j['pendingRequest'] != null
            ? PendingPaymentRequest.fromJson(j['pendingRequest'])
            : null,
        upgradeMessage: j['upgradeMessage'],
      );

  bool get isBasic => effectivePlan == SubscriptionPlan.basic;
  bool get isSilver => effectivePlan == SubscriptionPlan.silver;
  bool get isGold => effectivePlan == SubscriptionPlan.gold;
}

// ─── Payment Models ───────────────────────────────────────────────────────────

class PendingPaymentRequest {
  final String id;
  final SubscriptionPlan plan;
  final String duration;
  final DateTime createdAt;

  const PendingPaymentRequest({
    required this.id,
    required this.plan,
    required this.duration,
    required this.createdAt,
  });

  factory PendingPaymentRequest.fromJson(Map<String, dynamic> j) =>
      PendingPaymentRequest(
        id: j['_id'] ?? '',
        plan: SubscriptionPlanX.fromString(j['plan'] ?? 'basic'),
        duration: j['duration'] ?? 'monthly',
        createdAt: DateTime.tryParse(j['createdAt'] ?? '') ?? DateTime.now(),
      );
}

class PlanInfo {
  final SubscriptionPlan id;
  final String name;
  final String nameBn;
  final String badge;
  final int priceMonthly;
  final int priceYearly;
  final List<String> features;
  final PlanLimits limits;

  const PlanInfo({
    required this.id,
    required this.name,
    required this.nameBn,
    required this.badge,
    required this.priceMonthly,
    required this.priceYearly,
    required this.features,
    required this.limits,
  });

  factory PlanInfo.fromJson(Map<String, dynamic> j) => PlanInfo(
        id: SubscriptionPlanX.fromString(j['id'] ?? 'basic'),
        name: j['name'] ?? '',
        nameBn: j['namebn'] ?? '',
        badge: j['badge'] ?? '',
        priceMonthly: (j['price']?['monthly'] ?? 0) as int,
        priceYearly: (j['price']?['yearly'] ?? 0) as int,
        features: List<String>.from(j['features'] ?? []),
        limits: PlanLimits.fromJson(j['limits'] ?? {}),
      );
}

class PlansResponse {
  final bool comingSoon;
  final bool paymentEnabled;
  final List<PlanInfo> plans;
  final Map<String, dynamic> paymentMethods;

  const PlansResponse({
    required this.comingSoon,
    required this.paymentEnabled,
    required this.plans,
    required this.paymentMethods,
  });

  factory PlansResponse.fromJson(Map<String, dynamic> j) => PlansResponse(
        comingSoon: j['comingSoon'] ?? true,
        paymentEnabled: j['paymentEnabled'] ?? false,
        plans: (j['plans'] as List? ?? [])
            .map((e) => PlanInfo.fromJson(e))
            .toList(),
        paymentMethods: j['paymentMethods'] ?? {},
      );
}

// ─── Group Models ─────────────────────────────────────────────────────────────

class GroupMember {
  final String userId;
  final String name;
  final String? avatar;
  final String? district;
  final GroupMemberRole role;
  final DateTime joinedAt;
  final String? nickname;

  const GroupMember({
    required this.userId,
    required this.name,
    this.avatar,
    this.district,
    required this.role,
    required this.joinedAt,
    this.nickname,
  });

  factory GroupMember.fromJson(Map<String, dynamic> j) {
    final userObj =
        j['userId'] is Map ? j['userId'] as Map<String, dynamic> : null;
    return GroupMember(
      userId: userObj?['_id'] ?? j['userId'] ?? '',
      name: userObj?['name'] ?? '',
      avatar: userObj?['avatar'],
      district: userObj?['district'],
      role:
          j['role'] == 'admin' ? GroupMemberRole.admin : GroupMemberRole.member,
      joinedAt: DateTime.tryParse(j['joinedAt'] ?? '') ?? DateTime.now(),
      nickname: j['nickname'],
    );
  }

  String get displayName => nickname?.isNotEmpty == true ? nickname! : name;
  bool get isAdmin => role == GroupMemberRole.admin;
}

class GroupMonthlyGoal {
  final int? targetPoints;
  final int? targetCompletionPct;

  const GroupMonthlyGoal({this.targetPoints, this.targetCompletionPct});

  factory GroupMonthlyGoal.fromJson(Map<String, dynamic> j) => GroupMonthlyGoal(
        targetPoints: j['targetPoints'],
        targetCompletionPct: j['targetCompletionPct'],
      );

  bool get hasGoal => targetPoints != null || targetCompletionPct != null;
}

class GroupSettings {
  final bool isPrivate;
  final bool showRealNames;
  final bool allowMemberInvite;
  final bool hideFromGroupLeaderboard;
  final bool anonymousInGroupLeaderboard;

  const GroupSettings({
    required this.isPrivate,
    required this.showRealNames,
    required this.allowMemberInvite,
    required this.hideFromGroupLeaderboard,
    required this.anonymousInGroupLeaderboard,
  });

  factory GroupSettings.fromJson(Map<String, dynamic> j) => GroupSettings(
        isPrivate: j['isPrivate'] ?? true,
        showRealNames: j['showRealNames'] ?? true,
        allowMemberInvite: j['allowMemberInvite'] ?? false,
        hideFromGroupLeaderboard: j['hideFromGroupLeaderboard'] ?? false,
        anonymousInGroupLeaderboard: j['anonymousInGroupLeaderboard'] ?? false,
      );
}

class Group {
  final String id;
  final String name;
  final String? description;
  final GroupType type;
  final String createdBy;
  final String? inviteCode; // শুধু admin দেখতে পাবে
  final List<GroupMember> members;
  final int maxMembers;
  final GroupStatus status;
  final GroupSettings settings;
  final GroupMonthlyGoal? monthlyGoal;
  final String? avatar;
  final DateTime createdAt;

  const Group({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.createdBy,
    this.inviteCode,
    required this.members,
    required this.maxMembers,
    required this.status,
    required this.settings,
    this.monthlyGoal,
    this.avatar,
    required this.createdAt,
  });

  factory Group.fromJson(Map<String, dynamic> j) => Group(
        id: j['_id'] ?? '',
        name: j['name'] ?? '',
        description: j['description'],
        type: j['type'] == 'family' ? GroupType.family : GroupType.circle,
        createdBy: j['createdBy'] is Map
            ? (j['createdBy'] as Map)['_id'] ?? ''
            : j['createdBy'] ?? '',
        inviteCode: j['inviteCode'],
        members: (j['members'] as List? ?? [])
            .map((e) => GroupMember.fromJson(e))
            .toList(),
        maxMembers: j['maxMembers'] ?? 8,
        status: _parseStatus(j['status']),
        settings: GroupSettings.fromJson(j['settings'] ?? {}),
        monthlyGoal: j['monthlyGoal'] != null
            ? GroupMonthlyGoal.fromJson(j['monthlyGoal'])
            : null,
        avatar: j['avatar'],
        createdAt: DateTime.tryParse(j['createdAt'] ?? '') ?? DateTime.now(),
      );

  static GroupStatus _parseStatus(String? s) {
    switch (s) {
      case 'suspended':
        return GroupStatus.suspended;
      case 'archived':
        return GroupStatus.archived;
      default:
        return GroupStatus.active;
    }
  }

  bool get isActive => status == GroupStatus.active;
  bool get isSuspended => status == GroupStatus.suspended;
  int get memberCount => members.length;
  bool get isFull => memberCount >= maxMembers;

  GroupMember? memberById(String userId) {
    try {
      return members.firstWhere((m) => m.userId == userId);
    } catch (_) {
      return null;
    }
  }
}

// ─── Join Request ─────────────────────────────────────────────────────────────

class GroupJoinRequest {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String? userDistrict;
  final String? message;
  final DateTime requestedAt;
  final JoinRequestStatus status;

  const GroupJoinRequest({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    this.userDistrict,
    this.message,
    required this.requestedAt,
    required this.status,
  });

  factory GroupJoinRequest.fromJson(Map<String, dynamic> j) {
    final userObj =
        j['userId'] is Map ? j['userId'] as Map<String, dynamic> : null;
    return GroupJoinRequest(
      id: j['_id'] ?? '',
      userId: userObj?['_id'] ?? j['userId'] ?? '',
      userName: userObj?['name'] ?? '',
      userAvatar: userObj?['avatar'],
      userDistrict: userObj?['district'],
      message: j['message'],
      requestedAt: DateTime.tryParse(j['requestedAt'] ?? '') ?? DateTime.now(),
      status: j['status'] == 'accepted'
          ? JoinRequestStatus.accepted
          : j['status'] == 'rejected'
              ? JoinRequestStatus.rejected
              : JoinRequestStatus.pending,
    );
  }
}

// ─── Leaderboard ──────────────────────────────────────────────────────────────

class GroupLeaderboardEntry {
  final String userId;
  final String userName;
  final String? userAvatar;
  final String? userDistrict;
  final String? gender;
  final String? nickname;
  final int rank;
  final int totalPoints;
  final int fardPoints;
  final int completionPercentage;
  final int streakDays;
  final int daysCompleted;
  final int farzCompletedDays;

  const GroupLeaderboardEntry({
    required this.userId,
    required this.userName,
    this.userAvatar,
    this.userDistrict,
    this.gender,
    this.nickname,
    required this.rank,
    required this.totalPoints,
    required this.fardPoints,
    required this.completionPercentage,
    required this.streakDays,
    required this.daysCompleted,
    required this.farzCompletedDays,
  });

  factory GroupLeaderboardEntry.fromJson(Map<String, dynamic> j) =>
      GroupLeaderboardEntry(
        userId: j['userId'] ?? '',
        userName: j['user']?['name'] ?? '',
        userAvatar: j['user']?['avatar'],
        userDistrict: j['user']?['district'],
        gender: j['user']?['gender'],
        nickname: j['nickname'],
        rank: j['rank'] ?? 0,
        totalPoints: j['totalPoints'] ?? 0,
        fardPoints: j['fardPoints'] ?? 0,
        completionPercentage: j['completionPercentage'] ?? 0,
        streakDays: j['streakDays'] ?? 0,
        daysCompleted: j['daysCompleted'] ?? 0,
        farzCompletedDays: j['farzCompletedDays'] ?? 0,
      );

  String get displayName => nickname?.isNotEmpty == true ? nickname! : userName;
}

class GroupLeaderboardResponse {
  final Group group;
  final List<GroupLeaderboardEntry> data;
  final int total;
  final int groupStreak;
  final GoalProgress? goalProgress;

  const GroupLeaderboardResponse({
    required this.group,
    required this.data,
    required this.total,
    required this.groupStreak,
    this.goalProgress,
  });

  factory GroupLeaderboardResponse.fromJson(Map<String, dynamic> j) =>
      GroupLeaderboardResponse(
        group: Group.fromJson(j['group'] ?? {}),
        data: (j['data'] as List? ?? [])
            .map((e) => GroupLeaderboardEntry.fromJson(e))
            .toList(),
        total: j['total'] ?? 0,
        groupStreak: j['groupStreak'] ?? 0,
        goalProgress: j['goalProgress'] != null
            ? GoalProgress.fromJson(j['goalProgress'])
            : null,
      );
}

class GoalProgress {
  final int? targetPoints;
  final int currentPoints;
  final bool? pointsAchieved;
  final int? targetCompletionPct;
  final int currentCompletionPct;
  final bool? completionAchieved;

  const GoalProgress({
    this.targetPoints,
    required this.currentPoints,
    this.pointsAchieved,
    this.targetCompletionPct,
    required this.currentCompletionPct,
    this.completionAchieved,
  });

  factory GoalProgress.fromJson(Map<String, dynamic> j) => GoalProgress(
        targetPoints: j['targetPoints'],
        currentPoints: j['currentPoints'] ?? 0,
        pointsAchieved: j['pointsAchieved'],
        targetCompletionPct: j['targetCompletionPct'],
        currentCompletionPct: j['currentCompletionPct'] ?? 0,
        completionAchieved: j['completionAchieved'],
      );
}

// ─── Group Stats ──────────────────────────────────────────────────────────────

class GroupStats {
  final int totalGroupPoints;
  final int avgPoints;
  final int avgCompletionPct;
  final int memberCount;
  final int activeMembers;
  final int groupStreak;
  final TopPerformer? topPerformer;

  const GroupStats({
    required this.totalGroupPoints,
    required this.avgPoints,
    required this.avgCompletionPct,
    required this.memberCount,
    required this.activeMembers,
    required this.groupStreak,
    this.topPerformer,
  });

  factory GroupStats.fromJson(Map<String, dynamic> j) => GroupStats(
        totalGroupPoints: j['totalGroupPoints'] ?? 0,
        avgPoints: j['avgPoints'] ?? 0,
        avgCompletionPct: j['avgCompletionPct'] ?? 0,
        memberCount: j['memberCount'] ?? 0,
        activeMembers: j['activeMembers'] ?? 0,
        groupStreak: j['groupStreak'] ?? 0,
        topPerformer: j['topPerformer'] != null
            ? TopPerformer.fromJson(j['topPerformer'])
            : null,
      );
}

class TopPerformer {
  final String name;
  final String? avatar;
  final int totalPoints;
  final int completionPercentage;

  const TopPerformer({
    required this.name,
    this.avatar,
    required this.totalPoints,
    required this.completionPercentage,
  });

  factory TopPerformer.fromJson(Map<String, dynamic> j) => TopPerformer(
        name: j['name'] ?? '',
        avatar: j['avatar'],
        totalPoints: j['totalPoints'] ?? 0,
        completionPercentage: j['completionPercentage'] ?? 0,
      );
}

// ─── Eligibility ──────────────────────────────────────────────────────────────

class GroupEligibility {
  final bool eligible;
  final String? reason;
  final String? currentPlan;
  final Map<String, dynamic>? stats;

  const GroupEligibility({
    required this.eligible,
    this.reason,
    this.currentPlan,
    this.stats,
  });

  factory GroupEligibility.fromJson(Map<String, dynamic> j) => GroupEligibility(
        eligible: j['eligible'] ?? false,
        reason: j['reason'],
        currentPlan: j['currentPlan'],
        stats: j['stats'],
      );
}
