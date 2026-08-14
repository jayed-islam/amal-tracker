import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/app_constants.dart';

enum AuthStatus {
  unknown, // অ্যাপ সবে বুট হচ্ছে, টোকেন চেক চলছে
  authenticated, // সফলভাবে লগইন আছে
  unauthenticated, // লগইন নেই
}

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final AuthStatus status;
  final PendingDeletionInfo? pendingDeletion; // ← ADD

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.status = AuthStatus.unknown,
    this.pendingDeletion,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    AuthStatus? status,
    PendingDeletionInfo? pendingDeletion,
    bool clearPendingDeletion = false,
  }) =>
      AuthState(
        user: user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        status: status ?? this.status,
        pendingDeletion: clearPendingDeletion
            ? null
            : (pendingDeletion ?? this.pendingDeletion),
      );
}

class PendingDeletionInfo {
  final int daysLeft;
  final DateTime scheduledAt;

  const PendingDeletionInfo(
      {required this.daysLeft, required this.scheduledAt});

  factory PendingDeletionInfo.fromJson(Map<String, dynamic> json) =>
      PendingDeletionInfo(
        daysLeft: json['daysLeft'] ?? 45,
        scheduledAt: DateTime.parse(json['scheduledAt']),
      );
}

// ─── Auth Notifier ────────────────────────────────────────────────────────────
class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _api;
  final Ref _ref;
  AuthResponse? _pendingAuthResponse;

  AuthNotifier(this._api, this._ref) : super(const AuthState()) {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    try {
      final storage = _ref.read(secureStorageProvider);
      final token = await storage.read(key: AppConstants.accessTokenKey);
      final userJson = await storage.read(key: AppConstants.userKey);

      if (token != null && userJson != null) {
        final user = UserModel.fromJson(jsonDecode(userJson));
        state = AuthState(user: user, status: AuthStatus.authenticated);
        refreshProfile().ignore();
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _api.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final authResponse = AuthResponse.fromJson(response['data']);
      await _saveTokens(authResponse);
      _pendingAuthResponse = null;
      state = AuthState(
        user: authResponse.user,
        status: AuthStatus.authenticated,
        isLoading: false,
      );
      return true;
    } on ApiException catch (e) {
      if (e.statusCode == 403) {
        try {
          final parsed = jsonDecode(e.message) as Map<String, dynamic>;
          if (parsed['code'] == 'ACCOUNT_PENDING_DELETION') {
            // Not an error — show recovery UI
            state = state.copyWith(
              isLoading: false,
              status: AuthStatus.unauthenticated,
              pendingDeletion: PendingDeletionInfo.fromJson(parsed),
            );
            return false;
          }
        } catch (_) {}
      }
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    }
  }

  Future<void> logout() async {
    if (state.status == AuthStatus.unauthenticated) return;

    _pendingAuthResponse = null;

    // Send logout request to backend while tokens are still present
    try {
      await _api.post('/auth/logout', data: {});
    } catch (_) {}

    try {
      final storage = _ref.read(secureStorageProvider);
      await storage.deleteAll();
    } catch (_) {}

    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void clearLocalSessionOnly() async {
    _pendingAuthResponse = null;
    try {
      final storage = _ref.read(secureStorageProvider);
      await storage.deleteAll();
    } catch (_) {}
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String district,
    String? fullLocation,
    String? department,
    String? designation,
    String? phone,
    String? photoUrl,
    String? gender,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _api.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'district': district,
          if (department != null && department.isNotEmpty)
            'department': department,
          if (fullLocation != null && fullLocation.isNotEmpty)
            'fullLocation': fullLocation,
          if (designation != null && designation.isNotEmpty)
            'designation': designation,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
          if (photoUrl != null && photoUrl.isNotEmpty) 'photo_url': photoUrl,
          if (gender != null && gender.isNotEmpty) 'gender': gender,
        },
      );
      
      final responseData = response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : <String, dynamic>{};
      final returnedEmail = responseData['email']?.toString() ?? email;

      final draftUser = UserModel(
        id: '',
        name: name,
        email: returnedEmail,
        district: district,
        department: department,
        designation: designation,
        phone: phone,
        photoUrl: photoUrl,
        gender: gender,
        role: 'user',
        isActive: true,
        isVerified: false,
        isEmailVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _pendingAuthResponse = null;
      state = AuthState(
        user: draftUser,
        isLoading: false,
        status: AuthStatus.unauthenticated,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    }
  }

  Future<void> refreshProfile() async {
    try {
      final response = await _api.get<Map<String, dynamic>>('/auth/me');
      final user = UserModel.fromJson(response['data']);
      final storage = _ref.read(secureStorageProvider);
      await storage.write(
        key: AppConstants.userKey,
        value: jsonEncode(user.toJson()),
      );
      state = state.copyWith(user: user);
    } catch (_) {}
  }

  Future<void> markEmailAsVerified() async {
    final currentUser = state.user;
    if (currentUser == null) return;

    final updatedUser = currentUser.copyWith(
      isEmailVerified: true,
      isVerified: true,
    );

    if (_pendingAuthResponse != null) {
      final fullAuth = AuthResponse(
        accessToken: _pendingAuthResponse!.accessToken,
        refreshToken: _pendingAuthResponse!.refreshToken,
        user: updatedUser,
      );
      await _saveTokens(fullAuth);
      _pendingAuthResponse = null;
    } else {
      try {
        final storage = _ref.read(secureStorageProvider);
        await storage.write(
          key: AppConstants.userKey,
          value: jsonEncode(updatedUser.toJson()),
        );
      } catch (_) {}
    }

    state = state.copyWith(user: updatedUser);
  }

  Future<bool> verifyOtp(String otp) async {
    final email = state.user?.email ?? '';
    if (email.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'ইমেইল এড্রেস পাওয়া যায়নি',
      );
      throw const ApiException(message: 'ইমেইল এড্রেস পাওয়া যায়নি');
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _api.post<Map<String, dynamic>>(
        '/auth/verify-otp',
        data: {
          'email': email,
          'otp': otp,
        },
      );

      final data = response['data'] as Map<String, dynamic>;
      final authResponse = AuthResponse.fromJson(data);

      await _saveTokens(authResponse);
      _pendingAuthResponse = null;

      state = AuthState(
        user: authResponse.user,
        status: AuthStatus.authenticated,
        isLoading: false,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'ওটিপি যাচাই করতে ব্যর্থ হয়েছে',
      );
      throw const ApiException(
        message: 'ওটিপি যাচাই করতে ব্যর্থ হয়েছে',
      );
    }
  }

  Future<int> resendOtp() async {
    final email = state.user?.email ?? '';
    if (email.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'ইমেইল এড্রেস পাওয়া যায়নি',
      );
      throw const ApiException(message: 'ইমেইল এড্রেস পাওয়া যায়নি');
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _api.post<Map<String, dynamic>>(
        '/auth/resend-otp',
        data: {
          'email': email,
        },
      );

      int cooldown = 60;
      if (response['cooldownSeconds'] is num) {
        cooldown = (response['cooldownSeconds'] as num).toInt();
      } else if (response['data'] != null &&
          response['data']['cooldownSeconds'] is num) {
        cooldown = (response['data']['cooldownSeconds'] as num).toInt();
      }

      state = state.copyWith(isLoading: false);
      return cooldown;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'ওটিপি কোড পুনরায় পাঠাতে সমস্যা হয়েছে',
      );
      throw const ApiException(
        message: 'ওটিপি কোড পুনরায় পাঠাতে সমস্যা হয়েছে',
      );
    }
  }

  Future<bool> changePassword(String current, String newPassword) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _api.post('/auth/change-password', data: {
        'currentPassword': current,
        'newPassword': newPassword,
      });
      state = state.copyWith(isLoading: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _api.post('/auth/forgot-password', data: {'email': email});
      state = state.copyWith(isLoading: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'ওটিপি পাঠাতে ব্যর্থ হয়েছে। ইমেইল চেক করুন।',
      );
      throw const ApiException(
        message: 'ওটিপি পাঠাতে ব্যর্থ হয়েছে। ইমেইল চেক করুন।',
      );
    }
  }

  Future<String?> verifyResetOtp(String email, String otp) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _api.post<Map<String, dynamic>>(
        '/auth/verify-reset-otp',
        data: {
          'email': email,
          'otp': otp,
        },
      );
      state = state.copyWith(isLoading: false);
      final data = response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : null;
      return data?['resetToken']?.toString();
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'ওটিপি কোড যাচাই করা যায়নি',
      );
      throw const ApiException(
        message: 'ওটিপি কোড যাচাই করা যায়নি',
      );
    }
  }

  Future<bool> resetPassword({
    String? email,
    String? otp,
    String? resetToken,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _api.post('/auth/reset-password', data: {
        if (email != null && email.isNotEmpty) 'email': email,
        if (otp != null && otp.isNotEmpty) 'otp': otp,
        if (resetToken != null && resetToken.isNotEmpty)
          'resetToken': resetToken,
        'newPassword': newPassword,
      });
      state = state.copyWith(isLoading: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'পাসওয়ার্ড পরিবর্তন ব্যর্থ হয়েছে',
      );
      return false;
    }
  }

  // ─── Account Deletion ─────────────────────────────────────────────────────────
// ─── Account Deletion ─────────────────────────────────────────────────────────

  Future<PendingDeletionInfo?> requestDeletion() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _api.post<Map<String, dynamic>>(
        '/api/account-deletion/request',
      );
      final info = PendingDeletionInfo.fromJson(response['data']);

      // Clear session — user is logged out immediately
      try {
        final storage = _ref.read(secureStorageProvider);
        await storage.deleteAll();
      } catch (_) {}

      state = AuthState(
        status: AuthStatus.unauthenticated,
        pendingDeletion: info,
      );
      return info;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return null;
    }
  }

// Called from login screen — no token needed
  Future<bool> cancelDeletionWithCredentials(
      String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _api.post<Map<String, dynamic>>(
        '/api/account-deletion/cancel-with-credentials',
        data: {'email': email, 'password': password},
      );
      final authResponse = AuthResponse.fromJson(response['data']);
      await _saveTokens(authResponse);
      state = AuthState(
        user: authResponse.user,
        status: AuthStatus.authenticated,
        // pendingDeletion intentionally not set → null
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    }
  }

  void clearPendingDeletion() =>
      state = state.copyWith(clearPendingDeletion: true);

  Future<bool> updateProfile(Map<String, dynamic> changes) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _api.patch<Map<String, dynamic>>(
        '/auth/profile',
        data: changes,
      );
      final updatedUser = UserModel.fromJson(response['data']);
      final storage = _ref.read(secureStorageProvider);
      await storage.write(
        key: AppConstants.userKey,
        value: jsonEncode(updatedUser.toJson()),
      );
      state = AuthState(
          user: updatedUser,
          status: AuthStatus.authenticated,
          isLoading: false);
      // state =
      //     AuthState(user: updatedUser, isAuthenticated: true, isLoading: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: 'প্রোফাইল আপডেট করতে ব্যর্থ হয়েছে');
      return false;
    }
  }

  void clearError() => state = state.copyWith(error: null);

  Future<void> _saveTokens(AuthResponse auth) async {
    final storage = _ref.read(secureStorageProvider);
    try {
      await Future.wait([
        storage.write(key: AppConstants.accessTokenKey, value: auth.accessToken),
        storage.write(
            key: AppConstants.refreshTokenKey, value: auth.refreshToken),
        storage.write(
            key: AppConstants.userKey, value: jsonEncode(auth.user.toJson())),
      ]);
    } catch (e) {
      // If saving fails due to encryption key corruption, try resetting storage and retrying once
      try {
        await storage.deleteAll();
        await Future.wait([
          storage.write(key: AppConstants.accessTokenKey, value: auth.accessToken),
          storage.write(
              key: AppConstants.refreshTokenKey, value: auth.refreshToken),
          storage.write(
              key: AppConstants.userKey, value: jsonEncode(auth.user.toJson())),
        ]);
      } catch (_) {
        rethrow;
      }
    }
  }
}

// ─── Providers ────────────────────────────────────────────────────────────────
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(apiServiceProvider), ref);
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).status == AuthStatus.authenticated;
});

// At the bottom of auth_provider.dart, alongside existing providers:

final pendingDeletionProvider = Provider<PendingDeletionInfo?>(
    (ref) => ref.watch(authProvider).pendingDeletion);

final hasPendingDeletionProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).pendingDeletion != null;
});

final isEmailVerifiedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.isEmailVerified ?? false;
});
