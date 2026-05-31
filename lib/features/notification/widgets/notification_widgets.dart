import 'package:amal_tracker/core/router/app_router.dart';
import 'package:amal_tracker/features/home/screens/home_screen.dart';
import 'package:amal_tracker/features/notification/provider/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Drop this in your AppBar actions or anywhere in the nav bar.
/// Shows live unread badge. Taps open the notification center.
// class NotificationBellWidget extends ConsumerWidget {
//   const NotificationBellWidget({super.key});

// Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 color: ColorT.pageBg,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: ColorT.border, width: 0.5),
//               ),
//               child: const Icon(
//                 Icons.notifications_none_rounded,
//                 color: ColorT.textSecondary,
//                 size: 18,
//               ),
//             ),

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final unread = ref.watch(unreadNotificationCountProvider);

//     return IconButton(
//       tooltip: 'নোটিফিকেশন',
//       onPressed: () {
//         context.push(AppRoutes.notifications);
//         // Or if you want to replace instead of push:
//         // context.go(AppRoutes.notifications);
//       },
//       icon: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           const Icon(Icons.notifications_outlined,
//               color: Color(0xFF1A2E2A), size: 24),
//           if (unread > 0)
//             Positioned(
//               top: -3,
//               right: -3,
//               child: Container(
//                 width: 16,
//                 height: 16,
//                 decoration: const BoxDecoration(
//                     color: Color(0xFF2E7D5E), shape: BoxShape.circle),
//                 child: Center(
//                   child: Text(
//                     unread > 99 ? '99+' : '$unread',
//                     style: const TextStyle(
//                         fontFamily: 'Poppins',
//                         fontWeight: FontWeight.w700,
//                         fontSize: 8.5,
//                         color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
//
class ColorT {
  // Backgrounds
  static const pageBg = Color(0xFFF4F6F1);
  static const cardBg = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const midGreen = Color(0xFF1B7045);

  // Accents
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFFFF3E0);
  static const goldBorder = Color(0xFFFFCC80);

  // Status
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const amber = Color(0xFFF59E0B);
  static const amberLight = Color(0xFFFFF3E0);
  static const red = Color(0xFFEF4444);

  // Text
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);

  // Borders
  static const border = Color(0xFFE4EAE4);
  static const borderMid = Color(0xFFD0DAD2);

  // Rank colours
  static const rankGold = Color(0xFFD4A843);
  static const rankSilver = Color(0xFF94A3B8);
  static const rankBronze = Color(0xFFCD7F32);
}

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
              color: ColorT.pageBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColorT.border, width: 0.5),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: ColorT.textSecondary,
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

    // IconButton(
    //   tooltip: 'নোটিফিকেশন',
    //   onPressed: () {
    //     context.push(AppRoutes.notifications); // Now this will work
    //   },
    //   icon: Stack(
    //     clipBehavior: Clip.none,
    //     children: [
    //       const Icon(Icons.notifications_outlined,
    //           color: Color(0xFF1A2E2A), size: 24),
    //       if (unread > 0)
    //         Positioned(
    //           top: -3,
    //           right: -3,
    //           child: Container(
    //             width: 16,
    //             height: 16,
    //             decoration: const BoxDecoration(
    //                 color: Color(0xFF2E7D5E), shape: BoxShape.circle),
    //             child: Center(
    //               child: Text(
    //                 unread > 99 ? '99+' : '$unread',
    //                 style: const TextStyle(
    //                     fontFamily: 'Poppins',
    //                     fontWeight: FontWeight.w700,
    //                     fontSize: 8.5,
    //                     color: Colors.white),
    //               ),
    //             ),
    //           ),
    //         ),
    //     ],
    //   ),
    // );
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
          color: ColorT.pageBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: ColorT.border,
            width: 0.5,
          ),
        ),
        child: const Icon(
          Icons.settings_outlined,
          color: ColorT.textSecondary,
          size: 18,
        ),
      ),
    );
  }
}
