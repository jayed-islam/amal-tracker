// lib/core/models/network_exception.dart
//
// ─── NetworkException ─────────────────────────────────────────────────────────
//
// A specialised ApiException for no-internet / connection-refused errors.
// Because it extends ApiException, every existing catch (e) on ApiException
// in your providers and notifiers automatically catches it too — zero changes
// needed to the catch blocks.
//
// The only change required is to *throw* this type instead of ApiException
// when the failure is connectivity-related (see api_service changes below).

import 'package:amal_tracker/core/services/api_service.dart'; // adjust path

class NetworkException extends ApiException {
  const NetworkException({
    super.message = 'ইন্টারনেট সংযোগ নেই। পরে আবার চেষ্টা করুন।',
    super.statusCode = 0,
  });

  // Convenience: check if any ApiException is network-related.
  static bool isNetPwork(Object e) => e is NetworkException;
}

// ─────────────────────────────────────────────────────────────────────────────
// HOW TO UPDATE YOUR EXISTING ApiService
// ─────────────────────────────────────────────────────────────────────────────
//
// Your ApiService likely uses Dio. Add the following to EVERY method that
// makes a network request (get, post, put, delete, etc.).
//
// ── 1. Add imports at the top of api_service.dart ──────────────────────────
//
//   import 'dart:io';
//   import 'package:amal_tracker/core/services/connectivity_service.dart';
//   import 'package:amal_tracker/core/models/network_exception.dart';
//
// ── 2. Add this private helper method to the class ─────────────────────────
//
//   /// Throws NetworkException if offline. Call at the start of every public
//   /// request method BEFORE hitting the network.
//   void _assertOnline() {
//     if (!ConnectivityService.instance.isOnline) {
//       throw const NetworkException();
//     }
//   }
//
// ── 3. In each request method, call _assertOnline() first and wrap the Dio
//       call in a catch that converts low-level errors to NetworkException ──
//
//   Future<T> get<T>(String path, {Map<String, dynamic>? queryParams}) async {
//     _assertOnline();                          // ← ADD THIS LINE
//     try {
//       final response = await _dio.get(path, queryParameters: queryParams);
//       return response.data as T;
//     } on DioException catch (e) {
//       // ─── ADD THIS BLOCK ────────────────────────────────────────────────
//       if (e.type == DioExceptionType.connectionError ||
//           e.type == DioExceptionType.sendTimeout    ||
//           e.type == DioExceptionType.receiveTimeout ||
//           e.error is SocketException) {
//         throw const NetworkException();
//       }
//       // ──────────────────────────────────────────────────────────────────
//       throw ApiException(
//         message: e.response?.data?['message'] ?? 'কিছু একটা ভুল হয়েছে',
//         statusCode: e.response?.statusCode ?? 500,
//       );
//     }
//   }
//
// ── Why _assertOnline() BEFORE the request? ────────────────────────────────
//
//   Dio doesn't always throw immediately on no-internet — it can hang for
//   several seconds waiting for a timeout. The upfront check gives the user
//   instant feedback ("no internet") instead of a spinner that eventually
//   turns into an error.
//
// ── Why also catch DioExceptionType.connectionError? ───────────────────────
//
//   The connectivity check is not atomic — the phone can lose internet between
//   the check and the actual request. The Dio catch converts that race-condition
//   failure into a NetworkException instead of a generic server error.
