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

  // Future<void> _loadFromStorage() async {
  //   try {
  //     final storage = _ref.read(secureStorageProvider);
  //     final userJson = await storage.read(key: AppConstants.userKey);

  //     if (userJson != null) {
  //       print('=== LOADING USER DATA ===');
  //       print('Raw JSON: $userJson');

  //       final Map<String, dynamic> jsonMap = jsonDecode(userJson);
  //       print('Parsed JSON: $jsonMap');
  //       print('Has "id" field? ${jsonMap.containsKey('id')}');
  //       print('Has "_id" field? ${jsonMap.containsKey('_id')}');
  //       print('Has "id" field? ${jsonMap.containsKey('id')}');

  //       final user = UserModel.fromJson(jsonMap);
  //       print(
  //           'Loaded id: ${user.id}'); // ← এখানে null আসছে কিনা দেখুন

  //       state = AuthState(user: user, isAuthenticated: true);
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  Future<void> _loadFromStorage() async {
    try {
      final storage = _ref.read(secureStorageProvider);
      final token = await storage.read(key: AppConstants.accessTokenKey);
      final userJson = await storage.read(key: AppConstants.userKey);
      if (token != null && userJson != null) {
        final user = UserModel.fromJson(jsonDecode(userJson));
        state = AuthState(user: user, isAuthenticated: true);
      }
    } catch (e) {
      print('[AUTH] _loadFromStorage error: $e');
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
        isAuthenticated: true,
        isLoading: false,
      );

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

  // Future<void> _saveTokens(AuthResponse auth) async {
  //   final storage = _ref.read(secureStorageProvider);
  //   final userJson = jsonEncode(auth.user.toJson());

  //   // ডিবাগ: দেখুন কি সেভ হচ্ছে
  //   print('=== SAVING USER DATA ===');
  //   print('User object: ${auth.user}');
  //   print('id: ${auth.user.id}');
  //   print('toJson output: $userJson');

  //   await Future.wait([
  //     storage.write(key: AppConstants.accessTokenKey, value: auth.accessToken),
  //     storage.write(
  //         key: AppConstants.refreshTokenKey, value: auth.refreshToken),
  //     storage.write(key: AppConstants.userKey, value: userJson),
  //   ]);
  // }

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
