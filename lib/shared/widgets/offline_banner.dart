import 'package:amal_tracker/core/exceptions/network_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amal_tracker/core/providers/connectivity_provider.dart';
import 'package:amal_tracker/core/services/connectivity_service.dart';
import 'package:amal_tracker/core/services/api_service.dart';
import 'package:amal_tracker/features/home/screens/home_screen.dart'
    show ColorT;

// ─── OfflineBanner ────────────────────────────────────────────────────────────
//
// Lives inside the bottomNavigationBar Column in MainShell.
// Animates its own height: 0 when online, 42px when offline.
// Uses dark charcoal (#1f2937) — NOT red.
//
// Why not red?
//   Red = danger/error. "No internet" is an informational status, not an
//   error the user caused. Gmail, WhatsApp, Slack all use dark neutral tones
//   for persistent offline indicators. Red is reserved for destructive actions
//   and ApiErrorWidget (when content actually fails to load).

class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
      height: isOnline ? 0 : 42,
      // Dark charcoal — informational, not alarming.
      color: const Color(0xFF1f2937),
      // ClipRect prevents the child from rendering outside the 0-height box
      // during the collapse animation.
      child: ClipRect(
        child: isOnline
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      color:
                          Color(0xFF9CA3AF), // gray-400 — subtle, not alarming
                      size: 15,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'ইন্টারনেট সংযোগ নেই',
                        style: TextStyle(
                          color: Color(0xFFD1D5DB), // gray-300
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          ConnectivityService.instance.forceCheck(),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF9CA3AF),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        backgroundColor: Colors.white.withOpacity(0.08),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'রিট্রাই',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFD1D5DB),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

// ─── NoInternetWidget ─────────────────────────────────────────────────────────
//
// Full-screen placeholder used inside individual screens when a provider
// fails because there is no internet. This is where red is appropriate —
// the user's specific action failed.
//
// Usage:
//   ref.watch(someProvider).when(
//     loading: () => const CircularProgressIndicator(),
//     error: (e, _) => ApiErrorWidget(
//       error: e,
//       onRetry: () => ref.invalidate(someProvider),
//     ),
//     data: (d) => MyContent(d),
//   )

class NoInternetWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 32,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'ইন্টারনেট সংযোগ নেই',
              style: TextStyle(
                color: ColorT.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'আপনার ইন্টারনেট সংযোগ পরীক্ষা করুন\nএবং আবার চেষ্টা করুন।',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorT.textSecondary,
                fontSize: 13,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('আবার চেষ্টা করুন'),
              style: FilledButton.styleFrom(
                backgroundColor: ColorT.darkGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── ApiErrorWidget ───────────────────────────────────────────────────────────
//
// Drop this into every .when(error: ...) callback.
// Automatically picks the right UI based on what type of error occurred.

class ApiErrorWidget extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const ApiErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // NetworkException = no internet → show wifi-off UI
    if (error is NetworkException) {
      return NoInternetWidget(onRetry: onRetry);
    }

    // Any other ApiException = server responded with an error
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: ColorT.amberLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 32,
                color: ColorT.amber,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'কিছু একটা ভুল হয়েছে',
              style: TextStyle(
                color: ColorT.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              error is ApiException
                  ? (error as ApiException).message
                  : 'অনুগ্রহ করে পরে আবার চেষ্টা করুন।',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ColorT.textSecondary,
                fontSize: 13,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('আবার চেষ্টা করুন'),
              style: FilledButton.styleFrom(
                backgroundColor: ColorT.darkGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
