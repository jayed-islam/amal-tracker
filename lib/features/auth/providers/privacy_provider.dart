// // features/tracker/providers/privacy_provider.dart

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../core/services/api_service.dart';

// class PrivacyState {
//   final bool isHidden;
//   final bool showAnonymous;
//   final bool isPermanent;
//   final bool isPublic;
//   final bool? canRejoinThisMonth;
//   final bool isLoading;

//   const PrivacyState({
//     this.isHidden = false,
//     this.showAnonymous = false,
//     this.isPermanent = false,
//     this.isPublic = false,
//     this.canRejoinThisMonth,
//     this.isLoading = false,
//   });

//   PrivacyState copyWith({
//     bool? isHidden,
//     bool? showAnonymous,
//     bool? isPermanent,
//     bool? isPublic,
//     bool? canRejoinThisMonth,
//     bool? isLoading,
//   }) =>
//       PrivacyState(
//         isHidden: isHidden ?? this.isHidden,
//         showAnonymous: showAnonymous ?? this.showAnonymous,
//         isPermanent: isPermanent ?? this.isPermanent,
//         isPublic: isPublic ?? this.isPublic,
//         canRejoinThisMonth: canRejoinThisMonth ?? this.canRejoinThisMonth,
//         isLoading: isLoading ?? this.isLoading,
//       );
// }

// class PrivacyNotifier extends StateNotifier<PrivacyState> {
//   final ApiService _api;

//   PrivacyNotifier(this._api) : super(const PrivacyState()) {
//     _load();
//   }

//   Future<void> _load() async {
//     try {
//       // user model এ privacy fields থাকলে সেখান থেকে নিতে পারো
//       // অথবা আলাদা endpoint থাকলে সেটা call করো
//       // এখন user model থেকে initialize করার জন্য
//       // authProvider থেকে pass করে দাও অথবা user model এ রাখো
//     } catch (_) {}
//   }

//   // User model থেকে initialize করো — authProvider এ call করো
//   void initFromUser(dynamic user) {
//     if (user == null) return;
//     state = PrivacyState(
//       isHidden: user.leaderboardPrivacy?.isHidden ?? false,
//       showAnonymous: user.leaderboardPrivacy?.showAnonymous ?? false,
//       isPermanent: user.leaderboardOptOut?.isPermanent ?? false,
//       isPublic: user.shareProfile?.isPublic ?? false,
//     );
//   }

//   Future<PrivacyState?> updatePrivacy({
//     required bool isPermanent,
//     required bool isHidden,
//     required bool showAnonymous,
//   }) async {
//     state = state.copyWith(isLoading: true);
//     try {
//       final response = await _api.patch<Map<String, dynamic>>(
//         '/tracker/privacy',
//         data: {
//           'isHidden': isHidden,
//           'showAnonymous': showAnonymous,
//           'isPermanent': isPermanent,
//         },
//       );

//       final data = response['data'] as Map<String, dynamic>;
//       final newState = state.copyWith(
//         isHidden: data['isHidden'] ?? isHidden,
//         showAnonymous: data['showAnonymous'] ?? showAnonymous,
//         isPermanent: data['isPermanent'] ?? isPermanent,
//         canRejoinThisMonth: data['canRejoinThisMonth'],
//         isLoading: false,
//       );
//       state = newState;
//       return newState;
//     } catch (_) {
//       state = state.copyWith(isLoading: false);
//       return null;
//     }
//   }

//   Future<void> toggleProfileShare(bool isPublic) async {
//     // Optimistic update
//     state = state.copyWith(isPublic: isPublic);
//     try {
//       await _api.patch<Map<String, dynamic>>(
//         '/tracker/profile/share',
//         data: {'isPublic': isPublic},
//       );
//     } catch (_) {
//       // Rollback on failure
//       state = state.copyWith(isPublic: !isPublic);
//     }
//   }
// }

// final privacyProvider =
//     StateNotifierProvider<PrivacyNotifier, PrivacyState>((ref) {
//   return PrivacyNotifier(ref.read(apiServiceProvider));
// });
// features/tracker/providers/privacy_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../auth/providers/auth_provider.dart';

class PrivacyState {
  final bool isHidden;
  final bool showAnonymous;
  final bool isPermanent;
  final bool isPublic;
  final bool? canRejoinThisMonth;
  final bool isLoading;

  const PrivacyState({
    this.isHidden = false,
    this.showAnonymous = false,
    this.isPermanent = false,
    this.isPublic = false,
    this.canRejoinThisMonth,
    this.isLoading = false,
  });

  PrivacyState copyWith({
    bool? isHidden,
    bool? showAnonymous,
    bool? isPermanent,
    bool? isPublic,
    bool? canRejoinThisMonth,
    bool? isLoading,
  }) =>
      PrivacyState(
        isHidden: isHidden ?? this.isHidden,
        showAnonymous: showAnonymous ?? this.showAnonymous,
        isPermanent: isPermanent ?? this.isPermanent,
        isPublic: isPublic ?? this.isPublic,
        canRejoinThisMonth: canRejoinThisMonth ?? this.canRejoinThisMonth,
        isLoading: isLoading ?? this.isLoading,
      );
}

class PrivacyNotifier extends StateNotifier<PrivacyState> {
  final ApiService _api;
  final Ref _ref;

  PrivacyNotifier(this._api, this._ref) : super(const PrivacyState()) {
    _loadFromUser();
  }

  // ── Auth provider থেকে user নিয়ে initialize ──────────────────────────────
  void _loadFromUser() {
    final user = _ref.read(currentUserProvider);
    if (user == null) return;

    state = PrivacyState(
      isHidden: user.leaderboardPrivacy?.isHidden ?? false,
      showAnonymous: user.leaderboardPrivacy?.showAnonymous ?? false,
      isPermanent: user.leaderboardOptOut?.isPermanent ?? false,
      isPublic: user.shareProfile?.isPublic ?? false,
    );
  }

  Future<PrivacyState?> updatePrivacy({
    required bool isPermanent,
    required bool isHidden,
    required bool showAnonymous,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _api.patch<Map<String, dynamic>>(
        '/tracker/privacy',
        data: {
          'isHidden': isHidden,
          'showAnonymous': showAnonymous,
          'isPermanent': isPermanent,
        },
      );

      final data = response['data'] as Map<String, dynamic>;

      final newState = state.copyWith(
        isHidden: data['isHidden'] ?? isHidden,
        showAnonymous: data['showAnonymous'] ?? showAnonymous,
        isPermanent: data['isPermanent'] ?? isPermanent,
        canRejoinThisMonth: data['canRejoinThisMonth'],
        isLoading: false,
      );

      state = newState;

      // ── User model ও refresh করো যাতে app restart এ state থাকে ──────────
      await _ref.read(authProvider.notifier).refreshProfile();

      return newState;
    } catch (_) {
      state = state.copyWith(isLoading: false);
      return null;
    }
  }

  Future<void> toggleProfileShare(bool isPublic) async {
    // Optimistic update — user কে instantly response দাও
    state = state.copyWith(isPublic: isPublic);
    try {
      await _api.patch<Map<String, dynamic>>(
        '/tracker/profile/share',
        data: {'isPublic': isPublic},
      );

      // User model refresh
      await _ref.read(authProvider.notifier).refreshProfile();
    } catch (_) {
      // Rollback
      state = state.copyWith(isPublic: !isPublic);
    }
  }
}

final privacyProvider =
    StateNotifierProvider<PrivacyNotifier, PrivacyState>((ref) {
  return PrivacyNotifier(ref.read(apiServiceProvider), ref);
});
