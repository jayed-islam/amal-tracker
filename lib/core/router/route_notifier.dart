// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:amal_tracker/features/auth/providers/auth_provider.dart';

// final routerNotifierProvider = ChangeNotifierProvider<RouterNotifier>((ref) {
//   return RouterNotifier(ref);
// });

// // ── Router Notifier Class ──────────────────────────────────────────────────
// class RouterNotifier extends ChangeNotifier {
//   final Ref _ref;

//   RouterNotifier(this._ref) {
//     _ref.listen<AuthState>(
//       authProvider,
//       (previous, next) {
//         if (previous?.isAuthenticated != next.isAuthenticated ||
//             previous?.isInitializing != next.isInitializing) {
//           notifyListeners();
//         }
//       },
//     );
//   }
// }
