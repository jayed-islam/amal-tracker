// lib/core/providers/connectivity_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/connectivity_service.dart';

// ─── connectivityStatusProvider ───────────────────────────────────────────────
//
// StreamProvider: rebuilds listeners on every status change (online ↔ offline).
// autoDispose is intentionally NOT set here — connectivity state must survive
// across all navigation events (including auth screens).
final connectivityStatusProvider = StreamProvider<ConnectivityStatus>((ref) {
  return ConnectivityService.instance.onStatusChange;
});

// ─── isOnlineProvider ─────────────────────────────────────────────────────────
//
// Convenient bool derived from the stream. Falls back to the service's known
// current state during the loading phase (before the first stream event).
// Any widget watching this rebuilds the instant the network changes.
final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityStatusProvider).when(
        data: (status) => status == ConnectivityStatus.online,
        // While the stream hasn't emitted yet, read the synchronous snapshot
        // set during ConnectivityService.initialize().
        loading: () => ConnectivityService.instance.isOnline,
        error: (_, __) => ConnectivityService.instance.isOnline,
      );
});
