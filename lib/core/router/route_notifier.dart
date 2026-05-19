import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amal_tracker/features/auth/providers/auth_provider.dart';
import 'app_router.dart';

/// Implements both Riverpod [Notifier] and Flutter [Listenable] so GoRouter
/// can react to auth state changes automatically — the official recommended
/// pattern from GoRouter + Riverpod docs.
class RouterNotifier extends Notifier<void> implements Listenable {
  VoidCallback? _routerListener;

  @override
  void build() {
    // Watches auth state — when it changes, Notifier rebuilds
    // which triggers listenSelf → notifies GoRouter to re-run redirect
    ref.watch(isAuthenticatedProvider);
    ref.listenSelf((_, __) => _routerListener?.call());
  }

  // ── Listenable implementation ──────────────────────────────────────────
  @override
  void addListener(VoidCallback listener) => _routerListener = listener;

  @override
  void removeListener(VoidCallback listener) => _routerListener = null;

  // ── Redirect logic lives here, not inside GoRouter ─────────────────────
  String? redirect(BuildContext context, GoRouterState state) {
    final isAuth = ref.read(isAuthenticatedProvider);
    final loc = state.matchedLocation;

    // Always allow splash to render (it handles its own redirect after init)
    if (loc == AppRoutes.splash) return null;

    final isAuthPage = loc == AppRoutes.login || loc == AppRoutes.register;

    if (!isAuth && !isAuthPage) return AppRoutes.login;
    if (isAuth && isAuthPage) return AppRoutes.home;
    return null;
  }
}

final routerNotifierProvider =
    NotifierProvider<RouterNotifier, void>(RouterNotifier.new);
