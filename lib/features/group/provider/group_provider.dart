// lib/features/group/providers/group_provider.dart

import 'package:amal_tracker/features/group/models/group_mode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SUBSCRIPTION PROVIDERS
// ─────────────────────────────────────────────────────────────────────────────

// Plans — public, no auth, cached
final plansProvider = FutureProvider.autoDispose<PlansResponse>((ref) async {
  final api = ref.read(apiServiceProvider);
  final res = await api.get<Map<String, dynamic>>('/subscription/plans');
  return PlansResponse.fromJson(res['data'] ?? {});
});

// My subscription status
final subscriptionProvider =
    FutureProvider.autoDispose<SubscriptionStatus>((ref) async {
  final api = ref.read(apiServiceProvider);
  final res = await api.get<Map<String, dynamic>>('/subscription/me');
  return SubscriptionStatus.fromJson(res['data'] ?? {});
});

// Payment methods info (bKash number etc)
final paymentMethodsProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final api = ref.read(apiServiceProvider);
  final res =
      await api.get<Map<String, dynamic>>('/subscription/payment-methods');
  return res['data'] ?? {};
});

// ─────────────────────────────────────────────────────────────────────────────
// PAYMENT SUBMISSION STATE
// ─────────────────────────────────────────────────────────────────────────────

class PaymentSubmitState {
  final bool isLoading;
  final bool success;
  final String? error;
  final String? errorCode;
  final Map<String, dynamic>? result;

  const PaymentSubmitState({
    this.isLoading = false,
    this.success = false,
    this.error,
    this.errorCode,
    this.result,
  });

  PaymentSubmitState copyWith({
    bool? isLoading,
    bool? success,
    String? error,
    String? errorCode,
    Map<String, dynamic>? result,
  }) =>
      PaymentSubmitState(
        isLoading: isLoading ?? this.isLoading,
        success: success ?? this.success,
        error: error,
        errorCode: errorCode,
        result: result ?? this.result,
      );
}

class PaymentSubmitNotifier extends StateNotifier<PaymentSubmitState> {
  final ApiService _api;
  PaymentSubmitNotifier(this._api) : super(const PaymentSubmitState());

  Future<bool> submit({
    required SubscriptionPlan plan,
    required String duration,
    required String method,
    required String transactionId,
    String? mobileLast4,
    String? bankName,
    String? transferTime,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final body = <String, dynamic>{
        'plan': plan.value,
        'duration': duration,
        'method': method,
        'transactionId': transactionId.trim().toUpperCase(),
        if (mobileLast4 != null) 'mobileLast4': mobileLast4,
        if (bankName != null) 'bankName': bankName,
        if (transferTime != null) 'transferTime': transferTime,
      };
      final res = await _api.post<Map<String, dynamic>>(
          '/subscription/payment/submit',
          data: body);
      state = state.copyWith(
        isLoading: false,
        success: true,
        result: res['data'],
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
        // errorCode: e.code,
      );
      return false;
    }
  }

  Future<bool> cancelPending(String requestId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _api.delete<Map<String, dynamic>>(
          '/subscription/payment/$requestId/cancel');
      state = state.copyWith(isLoading: false, success: false, result: null);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    }
  }

  void reset() => state = const PaymentSubmitState();
}

final paymentSubmitProvider = StateNotifierProvider.autoDispose<
    PaymentSubmitNotifier, PaymentSubmitState>(
  (ref) => PaymentSubmitNotifier(ref.read(apiServiceProvider)),
);

// ─────────────────────────────────────────────────────────────────────────────
// GROUP LIST STATE
// ─────────────────────────────────────────────────────────────────────────────

class GroupListState {
  final List<Group> groups;
  final bool isLoading;
  final String? error;

  const GroupListState({
    this.groups = const [],
    this.isLoading = false,
    this.error,
  });

  GroupListState copyWith({
    List<Group>? groups,
    bool? isLoading,
    String? error,
  }) =>
      GroupListState(
        groups: groups ?? this.groups,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class GroupListNotifier extends StateNotifier<GroupListState> {
  final ApiService _api;
  GroupListNotifier(this._api) : super(const GroupListState()) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _api.get<Map<String, dynamic>>('/groups');
      final List data = res['data'] ?? [];
      state = state.copyWith(
        isLoading: false,
        groups: data.map((e) => Group.fromJson(e)).toList(),
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  // Create group — returns new group or null
  Future<Group?> createGroup({
    String? name,
    String? description,
    required GroupType type,
    String? avatar,
    bool isPrivate = true,
  }) async {
    try {
      final res = await _api.post<Map<String, dynamic>>('/groups', data: {
        if (name != null && name.isNotEmpty) 'name': name,
        if (description != null && description.isNotEmpty)
          'description': description,
        'type': type.value,
        if (avatar != null) 'avatar': avatar,
        'settings': {'isPrivate': isPrivate},
      });
      final group = Group.fromJson(res['data'] ?? {});
      state = state.copyWith(groups: [group, ...state.groups]);
      return group;
    } on ApiException {
      rethrow;
    }
  }

  // Join by invite code
  Future<Group?> joinByCode(String inviteCode) async {
    try {
      final res = await _api.post<Map<String, dynamic>>(
        '/groups/join/code',
        data: {'inviteCode': inviteCode.trim().toUpperCase()},
      );
      final group = Group.fromJson(res['data'] ?? {});
      state = state.copyWith(groups: [group, ...state.groups]);
      return group;
    } on ApiException {
      rethrow;
    }
  }

  // Request to join
  Future<bool> requestJoin(String groupId, {String? message}) async {
    try {
      await _api.post<Map<String, dynamic>>(
        '/groups/$groupId/request',
        data: {if (message != null && message.isNotEmpty) 'message': message},
      );
      return true;
    } on ApiException {
      rethrow;
    }
  }

  // Leave group
  Future<bool> leaveGroup(String groupId) async {
    try {
      await _api.post<Map<String, dynamic>>('/groups/$groupId/leave', data: {});
      state = state.copyWith(
        groups: state.groups.where((g) => g.id != groupId).toList(),
      );
      return true;
    } on ApiException {
      rethrow;
    }
  }

  // Remove group from local list (after delete)
  void removeGroup(String groupId) {
    state = state.copyWith(
      groups: state.groups.where((g) => g.id != groupId).toList(),
    );
  }

  // Update group in local list
  void updateGroup(Group updated) {
    state = state.copyWith(
      groups:
          state.groups.map((g) => g.id == updated.id ? updated : g).toList(),
    );
  }
}

final groupListProvider =
    StateNotifierProvider.autoDispose<GroupListNotifier, GroupListState>(
  (ref) => GroupListNotifier(ref.read(apiServiceProvider)),
);

// ─────────────────────────────────────────────────────────────────────────────
// GROUP DETAIL STATE
// ─────────────────────────────────────────────────────────────────────────────

class GroupDetailState {
  final Group? group;
  final bool isLoading;
  final bool isUpdating;
  final String? error;

  const GroupDetailState({
    this.group,
    this.isLoading = false,
    this.isUpdating = false,
    this.error,
  });

  GroupDetailState copyWith({
    Group? group,
    bool? isLoading,
    bool? isUpdating,
    String? error,
  }) =>
      GroupDetailState(
        group: group ?? this.group,
        isLoading: isLoading ?? this.isLoading,
        isUpdating: isUpdating ?? this.isUpdating,
        error: error,
      );
}

class GroupDetailNotifier extends StateNotifier<GroupDetailState> {
  final ApiService _api;
  final String _groupId;

  GroupDetailNotifier(this._api, this._groupId)
      : super(const GroupDetailState()) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _api.get<Map<String, dynamic>>('/groups/$_groupId');
      state = state.copyWith(
        isLoading: false,
        group: Group.fromJson(res['data'] ?? {}),
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  Future<bool> kickMember(String targetUserId, {String? reason}) async {
    state = state.copyWith(isUpdating: true, error: null);
    try {
      await _api.delete<Map<String, dynamic>>(
        '/groups/$_groupId/members/$targetUserId',
        // data: {if (reason != null) 'reason': reason},
      );
      await load();
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isUpdating: false, error: e.message);
      return false;
    }
  }

  Future<bool> updateMemberRole(String targetUserId, String role) async {
    state = state.copyWith(isUpdating: true, error: null);
    try {
      await _api.patch<Map<String, dynamic>>(
        '/groups/$_groupId/members/$targetUserId/role',
        data: {'role': role},
      );
      await load();
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isUpdating: false, error: e.message);
      return false;
    }
  }

  Future<bool> updateNickname(String nickname) async {
    try {
      await _api.patch<Map<String, dynamic>>(
        '/groups/$_groupId/nickname',
        data: {'nickname': nickname},
      );
      await load();
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return false;
    }
  }

  Future<String?> refreshInviteCode() async {
    try {
      final res = await _api.post<Map<String, dynamic>>(
        '/groups/$_groupId/refresh-invite',
        data: {},
      );
      final code = res['data']?['inviteCode'];
      await load();
      return code;
    } on ApiException {
      return null;
    }
  }

  Future<bool> deleteGroup() async {
    try {
      await _api.delete<Map<String, dynamic>>('/groups/$_groupId');
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return false;
    }
  }
}

final groupDetailProvider = StateNotifierProvider.autoDispose
    .family<GroupDetailNotifier, GroupDetailState, String>(
  (ref, groupId) => GroupDetailNotifier(ref.read(apiServiceProvider), groupId),
);

// ─────────────────────────────────────────────────────────────────────────────
// JOIN REQUESTS PROVIDER
// ─────────────────────────────────────────────────────────────────────────────

class JoinRequestsState {
  final List<GroupJoinRequest> requests;
  final bool isLoading;
  final bool isReviewing;
  final String? error;

  const JoinRequestsState({
    this.requests = const [],
    this.isLoading = false,
    this.isReviewing = false,
    this.error,
  });

  JoinRequestsState copyWith({
    List<GroupJoinRequest>? requests,
    bool? isLoading,
    bool? isReviewing,
    String? error,
  }) =>
      JoinRequestsState(
        requests: requests ?? this.requests,
        isLoading: isLoading ?? this.isLoading,
        isReviewing: isReviewing ?? this.isReviewing,
        error: error,
      );
}

class JoinRequestsNotifier extends StateNotifier<JoinRequestsState> {
  final ApiService _api;
  final String _groupId;

  JoinRequestsNotifier(this._api, this._groupId)
      : super(const JoinRequestsState()) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res =
          await _api.get<Map<String, dynamic>>('/groups/$_groupId/requests');
      final List data = res['data'] ?? [];
      state = state.copyWith(
        isLoading: false,
        requests: data.map((e) => GroupJoinRequest.fromJson(e)).toList(),
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  Future<bool> review(String requestId, String action) async {
    state = state.copyWith(isReviewing: true, error: null);
    try {
      await _api.patch<Map<String, dynamic>>(
        '/groups/$_groupId/requests/$requestId',
        data: {'action': action},
      );
      // Remove from local list
      state = state.copyWith(
        isReviewing: false,
        requests: state.requests.where((r) => r.id != requestId).toList(),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isReviewing: false, error: e.message);
      return false;
    }
  }
}

final joinRequestsProvider = StateNotifierProvider.autoDispose
    .family<JoinRequestsNotifier, JoinRequestsState, String>(
  (ref, groupId) => JoinRequestsNotifier(ref.read(apiServiceProvider), groupId),
);

// ─────────────────────────────────────────────────────────────────────────────
// GROUP LEADERBOARD PROVIDER
// ─────────────────────────────────────────────────────────────────────────────

final groupLeaderboardProvider = FutureProvider.autoDispose
    .family<GroupLeaderboardResponse, ({String groupId, int year, int month})>(
  (ref, p) async {
    final api = ref.read(apiServiceProvider);
    final res = await api.get<Map<String, dynamic>>(
      '/groups/${p.groupId}/leaderboard?year=${p.year}&month=${p.month}',
    );
    return GroupLeaderboardResponse.fromJson(res['data'] ?? {});
  },
);

// Group stats
final groupStatsProvider = FutureProvider.autoDispose
    .family<GroupStats, ({String groupId, int year, int month})>(
  (ref, p) async {
    final api = ref.read(apiServiceProvider);
    final res = await api.get<Map<String, dynamic>>(
      '/groups/${p.groupId}/stats?year=${p.year}&month=${p.month}',
    );
    return GroupStats.fromJson(res['data'] ?? {});
  },
);

// Group eligibility check
final groupEligibilityProvider =
    FutureProvider.autoDispose<GroupEligibility>((ref) async {
  final api = ref.read(apiServiceProvider);
  final res = await api.get<Map<String, dynamic>>('/groups/eligibility');
  return GroupEligibility.fromJson(res['data'] ?? {});
});

// Selected pricing duration toggle
final pricingDurationProvider = StateProvider<String>((ref) => 'monthly');

// Selected plan for payment flow
final selectedPlanProvider = StateProvider<SubscriptionPlan?>((ref) => null);

// Selected payment method
final selectedPaymentMethodProvider =
    StateProvider<PaymentMethod>((ref) => PaymentMethod.bkash);
