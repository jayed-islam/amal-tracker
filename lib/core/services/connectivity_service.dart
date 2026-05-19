// lib/core/services/connectivity_service.dart

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// ─── Status enum ──────────────────────────────────────────────────────────────

enum ConnectivityStatus { online, offline }

// ─── ConnectivityService ──────────────────────────────────────────────────────
//
// Singleton. Wraps two libraries:
//   • connectivity_plus  — detects adapter changes (WiFi / mobile / none)
//   • internet_connection_checker_plus — TCP-pings real servers to confirm
//     actual internet access, not just a connected adapter.
//
// Usage:
//   await ConnectivityService.instance.initialize(); // once in main()
//   ConnectivityService.instance.isOnline            // sync read
//   ConnectivityService.instance.onStatusChange      // stream

class ConnectivityService {
  ConnectivityService._();
  static final instance = ConnectivityService._();

  final _connectivity = Connectivity();
  final _checker = InternetConnection();

  // Broadcast so multiple listeners (providers, widgets) can all subscribe.
  final _controller = StreamController<ConnectivityStatus>.broadcast();
  Stream<ConnectivityStatus> get onStatusChange => _controller.stream;

  ConnectivityStatus _current = ConnectivityStatus.online;
  ConnectivityStatus get current => _current;
  bool get isOnline => _current == ConnectivityStatus.online;

  StreamSubscription<List<ConnectivityResult>>? _adapterSub;

  // ── initialize ─────────────────────────────────────────────────────────────
  //
  // Call once in main() before runApp().
  // Sets the initial status synchronously (well, awaited) and starts listening.
  Future<void> initialize() async {
    // 1. Snapshot current status before any stream events arrive.
    _current = await _check();

    // 2. connectivity_plus fires whenever the network adapter changes.
    //    We re-verify actual internet access each time.
    _adapterSub = _connectivity.onConnectivityChanged.listen(
      (_) async => _evaluate(),
    );
  }

  // ── _evaluate ──────────────────────────────────────────────────────────────
  //
  // Runs the real-internet check and emits on the stream only when status
  // actually changes — prevents noisy duplicate events.
  Future<void> _evaluate() async {
    final next = await _check();
    if (next != _current) {
      _current = next;
      _controller.add(_current);
    }
  }

  // ── _check ─────────────────────────────────────────────────────────────────
  //
  // Two-stage verification:
  //   1. Fast adapter check — if the adapter says "none", return offline
  //      immediately without doing a network round-trip.
  //   2. TCP ping via internet_connection_checker_plus — confirms real access.
  Future<ConnectivityStatus> _check() async {
    final results = await _connectivity.checkConnectivity();
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return ConnectivityStatus.offline;
    }
    final hasInternet = await _checker.hasInternetAccess;
    return hasInternet ? ConnectivityStatus.online : ConnectivityStatus.offline;
  }

  // ── forceCheck ─────────────────────────────────────────────────────────────
  //
  // Called by the "Retry" button in the offline banner.
  // Re-runs the full check and emits on the stream if status changed.
  Future<void> forceCheck() => _evaluate();

  void dispose() {
    _adapterSub?.cancel();
    _controller.close();
  }
}
