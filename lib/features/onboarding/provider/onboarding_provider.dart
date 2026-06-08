// lib/core/providers/onboarding_provider.dart

import 'package:shared_preferences/shared_preferences.dart';

const _kOnboardingKey = 'has_seen_onboarding';

/// Call this once in main() before runApp — reads from disk synchronously-ish
Future<bool> loadOnboardingSeen() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_kOnboardingKey) ?? false;
}

/// Call when user finishes or skips onboarding
Future<void> markOnboardingSeen() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_kOnboardingKey, true);
}
