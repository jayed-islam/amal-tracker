import 'package:amal_tracker/core/router/app_router.dart';
import 'package:amal_tracker/features/notification/provider/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

// ColorT design tokens used to be defined here as a static const class,
// duplicating the same green/gold palette yet again. Removed — every
// reference now points at the single shared context.colors.xxx source.

class NotificationBellWidget extends ConsumerWidget {
  const NotificationBellWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadNotificationCountProvider);

    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.notifications);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: context.colors.bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.colors.border, width: 0.5),
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              color: context.colors.textMuted,
              size: 18,
            ),
          ),
          if (unread > 0)
            Positioned(
              top: -3,
              right: -3,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                    color: Color(0xFF2E7D5E), shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    unread > 99 ? '99+' : '$unread',
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 8.5,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// One-time permission request banner.
/// Show this on the home screen for first-time users.
class NotificationPermissionBanner extends ConsumerWidget {
  const NotificationPermissionBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permAsync = ref.watch(notificationPermissionProvider);

    return permAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (hasPermission) {
        if (hasPermission) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFFCC02).withOpacity(0.4)),
          ),
          child: Row(children: [
            const Icon(Icons.notifications_off_rounded,
                color: Color(0xFFE65100), size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('নোটিফিকেশন বন্ধ আছে',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Color(0xFFE65100))),
                    const Text('আমল রিমাইন্ডার পেতে অনুমতি দিন।',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Color(0xFF795548))),
                  ]),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => ref
                  .read(notificationPermissionProvider.notifier)
                  .requestPermission(),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFE65100),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('অনুমতি দিন',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
            ),
          ]),
        );
      },
    );
  }
}

class SettingsButtonWidget extends StatelessWidget {
  const SettingsButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.settings);
      },
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: context.colors.bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: context.colors.border,
            width: 0.5,
          ),
        ),
        child: Icon(
          Icons.settings_outlined,
          color: context.colors.textMuted,
          size: 18,
        ),
      ),
    );
  }
}
