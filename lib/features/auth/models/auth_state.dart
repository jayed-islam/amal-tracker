import 'dart:convert';
import 'package:amal_tracker/core/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final bool isInitializing;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.isInitializing = true, // অ্যাপ চালু হওয়া মাত্র এটি ট্রু থাকবে
    this.error,
  });

  AuthState copyWith(
      {bool? isLoading,
      bool? isAuthenticated,
      bool? isInitializing,
      String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isInitializing: isInitializing ?? this.isInitializing,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;
  AuthNotifier(this._ref) : super(const AuthState()) {
    _loadSession();
  }

  Future<void> _loadSession() async {
    try {
      final storage = _ref.read(secureStorageProvider);
      final token = await storage.read(key: 'access_token');

      if (token != null) {
        state = const AuthState(isAuthenticated: true, isInitializing: false);
      } else {
        state = const AuthState(isAuthenticated: false, isInitializing: false);
      }
    } catch (_) {
      state = const AuthState(isAuthenticated: false, isInitializing: false);
    }
  }

  Future<void> logout() async {
    final storage = _ref.read(secureStorageProvider);
    await storage.deleteAll();
    state = const AuthState(
        isAuthenticated: false,
        isInitializing: false); // ইনস্ট্যান্ট রাউটার ট্রিগার করবে
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier(ref));
