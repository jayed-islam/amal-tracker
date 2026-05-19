// import 'dart:convert';
// import 'package:amal_tracker/core/router/app_router.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/user_model.dart';
// import '../../../core/services/api_service.dart';
// import '../../../core/constants/app_constants.dart';

// // ─── Auth State ───────────────────────────────────────────────────────────────

// class AuthState {
//   final UserModel? user;
//   final bool isLoading;
//   final String? error;
//   final bool isAuthenticated;

//   const AuthState({
//     this.user,
//     this.isLoading = false,
//     this.error,
//     this.isAuthenticated = false,
//   });

//   AuthState copyWith({
//     UserModel? user,
//     bool? isLoading,
//     String? error,
//     bool? isAuthenticated,
//   }) =>
//       AuthState(
//         user: user ?? this.user,
//         isLoading: isLoading ?? this.isLoading,
//         error: error,
//         isAuthenticated: isAuthenticated ?? this.isAuthenticated,
//       );
// }

// // ─── Auth Notifier ────────────────────────────────────────────────────────────

// class AuthNotifier extends StateNotifier<AuthState> {
//   final ApiService _api;
//   final Ref _ref;

//   AuthNotifier(this._api, this._ref) : super(const AuthState()) {
//     _loadFromStorage();
//   }

//   Future<void> _loadFromStorage() async {
//     try {
//       final storage = _ref.read(secureStorageProvider);
//       final token = await storage.read(key: AppConstants.accessTokenKey);
//       final userJson = await storage.read(key: AppConstants.userKey);

//       if (token != null && userJson != null) {
//         final user = UserModel.fromJson(jsonDecode(userJson));
//         state = AuthState(user: user, isAuthenticated: true);
//       }
//     } catch (_) {
//       state = const AuthState();
//     }
//   }

//   Future<bool> login(String email, String password) async {
//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       final response = await _api.post<Map<String, dynamic>>(
//         '/auth/login',
//         data: {'email': email, 'password': password},
//       );

//       final authResponse = AuthResponse.fromJson(response['data']);
//       await _saveTokens(authResponse);

//       state = AuthState(user: authResponse.user, isAuthenticated: true);
//       return true;
//     } on ApiException catch (e) {
//       state = state.copyWith(isLoading: false, error: e.message);
//       return false;
//     }
//   }

//   Future<bool> register({
//     required String name,
//     required String email,
//     required String password,
//     String? department,
//     String? designation,
//   }) async {
//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       final response = await _api.post<Map<String, dynamic>>(
//         '/auth/register',
//         data: {
//           'name': name,
//           'email': email,
//           'password': password,
//           if (department != null) 'department': department,
//           if (designation != null) 'designation': designation,
//         },
//       );

//       final authResponse = AuthResponse.fromJson(response['data']);
//       await _saveTokens(authResponse);

//       state = AuthState(user: authResponse.user, isAuthenticated: true);
//       return true;
//     } on ApiException catch (e) {
//       state = state.copyWith(isLoading: false, error: e.message);
//       return false;
//     }
//   }

//   Future<void> logout() async {
//     try {
//       await _api.post('/auth/logout', data: {});
//     } catch (_) {
//     } finally {
//       final storage = _ref.read(secureStorageProvider);
//       await storage.deleteAll();
//       state = const AuthState();
//     }
//   }

//   Future<void> refreshProfile() async {
//     try {
//       final response = await _api.get<Map<String, dynamic>>('/auth/me');
//       final user = UserModel.fromJson(response['data']);
//       final storage = _ref.read(secureStorageProvider);
//       await storage.write(
//           key: AppConstants.userKey, value: jsonEncode(user.toJson()));
//       state = state.copyWith(user: user);
//     } catch (_) {}
//   }

//   Future<bool> changePassword(String current, String newPassword) async {
//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       await _api.post('/auth/change-password', data: {
//         'currentPassword': current,
//         'newPassword': newPassword,
//       });
//       state = state.copyWith(isLoading: false);
//       return true;
//     } on ApiException catch (e) {
//       state = state.copyWith(isLoading: false, error: e.message);
//       return false;
//     }
//   }

//   void clearError() => state = state.copyWith(error: null);

//   Future<void> _saveTokens(AuthResponse auth) async {
//     final storage = _ref.read(secureStorageProvider);
//     await Future.wait([
//       storage.write(key: AppConstants.accessTokenKey, value: auth.accessToken),
//       storage.write(
//           key: AppConstants.refreshTokenKey, value: auth.refreshToken),
//       storage.write(
//           key: AppConstants.userKey, value: jsonEncode(auth.user.toJson())),
//     ]);
//   }
// }

// // ─── Providers ────────────────────────────────────────────────────────────────

// final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
//   return AuthNotifier(ref.read(apiServiceProvider), ref);
// });

// final currentUserProvider = Provider<UserModel?>((ref) {
//   return ref.watch(authProvider).user;
// });

// final isAuthenticatedProvider = Provider<bool>((ref) {
//   return ref.watch(authProvider).isAuthenticated;
// });

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/app_constants.dart';

// ─── Auth State ───────────────────────────────────────────────────────────────

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) =>
      AuthState(
        user: user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      );
}

// ─── Auth Notifier ────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _api;
  final Ref _ref;

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
        state = AuthState(user: user, isAuthenticated: true);
      }
    } catch (_) {
      state = const AuthState();
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
      state = AuthState(user: authResponse.user, isAuthenticated: true);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    }
  }

  // Future<bool> register({
  //   required String name,
  //   required String email,
  //   required String password,
  //   String? department,
  //   String? designation,
  // }) async {
  //   state = state.copyWith(isLoading: true, error: null);
  //   try {
  //     final response = await _api.post<Map<String, dynamic>>(
  //       '/auth/register',
  //       data: {
  //         'name': name,
  //         'email': email,
  //         'password': password,
  //         if (department != null) 'department': department,
  //         if (designation != null) 'designation': designation,
  //       },
  //     );
  //     final authResponse = AuthResponse.fromJson(response['data']);
  //     await _saveTokens(authResponse);
  //     state = AuthState(user: authResponse.user, isAuthenticated: true);
  //     return true;
  //   } on ApiException catch (e) {
  //     state = state.copyWith(isLoading: false, error: e.message);
  //     return false;
  //   }
  // }
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String district, // Required field
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
          'district': district, // Required - always sent
          if (department != null && department.isNotEmpty)
            'department': department,
          if (designation != null && designation.isNotEmpty)
            'designation': designation,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
          if (photoUrl != null && photoUrl.isNotEmpty) 'photo_url': photoUrl,
          if (gender != null && gender.isNotEmpty) 'gender': gender,
        },
      );
      final authResponse = AuthResponse.fromJson(response['data']);
      await _saveTokens(authResponse);
      state = AuthState(user: authResponse.user, isAuthenticated: true);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    }
  }

  // ── THE FIX ──────────────────────────────────────────────────────────────
  //
  // BEFORE (slow — 1-2 sec delay):
  //   await _api.post('/auth/logout')  ← blocks here
  //   storage.deleteAll()
  //   state = const AuthState()        ← router only redirects NOW
  //
  // AFTER (instant):
  //   storage.deleteAll()              ─┐ these two run immediately
  //   state = const AuthState()        ─┘ router redirects to login at once
  //   _api.post('/auth/logout').ignore()  ← background, no await needed
  //
  // WHY it's safe to not await the API call:
  //   The access token is already gone from storage. Even if the server call
  //   fails, the token expires on its own. Local state is the source of truth.
  //
  // ALSO: never call _ref.invalidate() inside a notifier on providers that
  //   watch this notifier — that creates a CircularDependencyError.
  //   Invalidate downstream providers from the UI layer after logout() returns.
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    // 1. Wipe local storage synchronously
    final storage = _ref.read(secureStorageProvider);
    await storage.deleteAll();

    // 2. Clear state — isAuthenticated = false fires the router redirect INSTANTLY
    state = const AuthState();

    // 3. Notify server in background — fire & forget
    _api.post('/auth/logout', data: {}).ignore();
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

  void clearError() => state = state.copyWith(error: null);

  Future<void> _saveTokens(AuthResponse auth) async {
    final storage = _ref.read(secureStorageProvider);
    await Future.wait([
      storage.write(key: AppConstants.accessTokenKey, value: auth.accessToken),
      storage.write(
          key: AppConstants.refreshTokenKey, value: auth.refreshToken),
      storage.write(
          key: AppConstants.userKey, value: jsonEncode(auth.user.toJson())),
    ]);
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
  return ref.watch(authProvider).isAuthenticated;
});
