import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Executes a protected action. All users logged into the application
/// are guaranteed to be email-verified by the app router.
Future<T?> executeProtectedAction<T>(
  BuildContext context,
  WidgetRef ref, {
  required Future<T> Function() action,
  VoidCallback? onVerifiedSuccess,
}) async {
  final result = await action();
  if (onVerifiedSuccess != null) onVerifiedSuccess();
  return result;
}
