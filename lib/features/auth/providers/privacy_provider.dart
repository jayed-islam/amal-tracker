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

  /// Sync local-only state update — called by screen's onSuccess AFTER
  /// apiCall succeeds. No network call here, just a copyWith.
  void setLocalState({
    bool? isPermanent,
    bool? isHidden,
    bool? showAnonymous,
    bool? isPublic,
    bool? canRejoinThisMonth,
  }) {
    state = state.copyWith(
      isPermanent: isPermanent,
      isHidden: isHidden,
      showAnonymous: showAnonymous,
      isPublic: isPublic,
      canRejoinThisMonth: canRejoinThisMonth,
    );
  }

  /// FIX: Now THROWS on failure instead of swallowing the error and returning
  /// null. The dialog's apiCall lambda awaits this — if it throws, the dialog
  /// catches it, pops with _DialogResult.fail(...), and onSuccess never fires.
  Future<void> updatePrivacy({
    required bool isPermanent,
    required bool isHidden,
    required bool showAnonymous,
  }) async {
    // Note: do NOT set isLoading here — the dialog shows its own spinner.
    // isLoading in state is only for full-screen loading indicators elsewhere.
    final response = await _api.patch<Map<String, dynamic>>(
      '/tracker/privacy',
      data: {
        'isHidden': isHidden,
        'showAnonymous': showAnonymous,
        'isPermanent': isPermanent,
      },
    );
    // ^ Throws on network/server error — let it propagate up to the dialog.

    final data = response['data'] as Map<String, dynamic>;

    // Persist canRejoinThisMonth from server response so the warning text
    // and "locked out" guard in _onMonthlyToggle stay accurate.
    state = state.copyWith(
      canRejoinThisMonth: data['canRejoinThisMonth'] as bool?,
    );
    // The actual isHidden / isPermanent / showAnonymous flip is done by
    // setLocalState() inside onSuccess — keeping a single source of truth.

    // Refresh the cached user model so state survives app restarts.
    await _ref.read(authProvider.notifier).refreshProfile();
  }

  /// FIX: Removed optimistic update. The screen's onSuccess calls
  /// setLocalState(isPublic: newVal) synchronously after apiCall succeeds,
  /// which is already optimistic enough. Doing it here too caused the switch
  /// to flip even when the API later failed (rollback came too late).
  Future<void> toggleProfileShare(bool isPublic) async {
    await _api.patch<Map<String, dynamic>>(
      '/tracker/profile/share',
      data: {'isPublic': isPublic},
    );
    // ^ Throws on failure — dialog catches it, pops fail, onSuccess skipped.

    await _ref.read(authProvider.notifier).refreshProfile();
  }
}

final privacyProvider =
    StateNotifierProvider<PrivacyNotifier, PrivacyState>((ref) {
  return PrivacyNotifier(ref.read(apiServiceProvider), ref);
});
