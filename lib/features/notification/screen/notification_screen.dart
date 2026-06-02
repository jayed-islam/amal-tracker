import 'package:amal_tracker/features/notification/model/notification_model.dart';
import 'package:amal_tracker/features/notification/provider/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(notificationHistoryProvider);
    final grouped = ref.watch(groupedNotificationsProvider);
    final unread = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F8),
      appBar: _buildAppBar(
          context, ref, unread, historyAsync.valueOrNull?.isNotEmpty ?? false),
      body: historyAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF2E7D5E))),
        error: (e, _) => Center(child: Text('ত্রুটি: $e')),
        data: (list) {
          if (list.isEmpty) return const _EmptyState();
          return _NotificationList(grouped: grouped, ref: ref);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    int unread,
    bool hasItems,
  ) {
    return AppBar(
      title: Row(children: [
        const Text('নোটিফিকেশন',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color(0xFF1A2E2A))),
        if (unread > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
                color: const Color(0xFF2E7D5E),
                borderRadius: BorderRadius.circular(10)),
            child: Text('$unread',
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: Colors.white)),
          ),
        ],
      ]),
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: const BackButton(color: Color(0xFF2E7D5E)),
      actions: [
        if (hasItems)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF1A2E2A)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.white,
            onSelected: (v) {
              if (v == 'read_all') {
                ref.read(notificationHistoryProvider.notifier).markAllAsRead();
              } else if (v == 'clear_all') {
                _showClearDialog(context, ref);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'read_all',
                child: Row(children: [
                  Icon(Icons.done_all_rounded,
                      size: 18, color: Color(0xFF2E7D5E)),
                  SizedBox(width: 10),
                  Text('সব পড়া হয়েছে চিহ্নিত করুন',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 13)),
                ]),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(children: [
                  Icon(Icons.delete_sweep_rounded,
                      size: 18, color: Color(0xFFE53935)),
                  SizedBox(width: 10),
                  Text('সব মুছুন',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: Color(0xFFE53935))),
                ]),
              ),
            ],
          ),
      ],
    );
  }

  void _showClearDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('সব নোটিফিকেশন মুছবেন?',
            style:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
        content: const Text(
          'সমস্ত নোটিফিকেশন স্থায়ীভাবে মুছে যাবে।',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('বাতিল',
                style:
                    TextStyle(fontFamily: 'Poppins', color: Color(0xFF6B8A82))),
          ),
          TextButton(
            onPressed: () {
              ref.read(notificationHistoryProvider.notifier).clearAll();
              Navigator.pop(ctx);
            },
            child: const Text('মুছুন',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFE53935))),
          ),
        ],
      ),
    );
  }
}

// ─── Notification List (grouped by date) ─────────────────────
class _NotificationList extends StatelessWidget {
  final Map<String, List<AppNotification>> grouped;
  final WidgetRef ref;

  const _NotificationList({required this.grouped, required this.ref});

  @override
  Widget build(BuildContext context) {
    final keys = grouped.keys.toList();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: keys.length,
      itemBuilder: (context, i) {
        final key = keys[i];
        final items = grouped[key]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
              child: Text(key,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF6B8A82))),
            ),
            ...items.map((n) => _NotifTile(
                  notif: n,
                  onTap: () {
                    ref
                        .read(notificationHistoryProvider.notifier)
                        .markAsRead(n.id);
                    if (n.route != null && n.route!.isNotEmpty) {
                      Navigator.pushNamed(context, n.route!);
                    }
                  },
                  onDismiss: () => ref
                      .read(notificationHistoryProvider.notifier)
                      .delete(n.id),
                )),
          ],
        );
      },
    );
  }
}

// ─── Single tile ──────────────────────────────────────────────
class _NotifTile extends StatelessWidget {
  final AppNotification notif;
  final VoidCallback onTap, onDismiss;

  const _NotifTile({
    required this.notif,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notif.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: const Color(0xFFFFEBEE),
        child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete_outline_rounded,
                  color: Color(0xFFE53935), size: 22),
              SizedBox(height: 2),
              Text('মুছুন',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      color: Color(0xFFE53935))),
            ]),
      ),
      onDismissed: (_) => onDismiss(),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          decoration: BoxDecoration(
            color: notif.isRead ? Colors.white : const Color(0xFFF0FAF5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: notif.isRead
                  ? const Color(0xFFEEF2F0)
                  : const Color(0xFF2E7D5E).withOpacity(0.22),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.035),
                  blurRadius: 6,
                  offset: const Offset(0, 1))
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(11),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Icon bubble
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: notif.type.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(notif.type.icon, color: notif.type.color, size: 20),
              ),
              const SizedBox(width: 11),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row: badge + time + dot
                    Row(children: [
                      _TypeBadge(notif.type),
                      const Spacer(),
                      Text(_timeAgo(notif.receivedAt),
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10.5,
                              color: Color(0xFF9EB4AC))),
                      if (!notif.isRead) ...[
                        const SizedBox(width: 5),
                        Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                                color: Color(0xFF2E7D5E),
                                shape: BoxShape.circle)),
                      ],
                    ]),
                    const SizedBox(height: 4),

                    // Title
                    Text(notif.title,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: notif.isRead
                                ? FontWeight.w500
                                : FontWeight.w600,
                            fontSize: 13.5,
                            color: const Color(0xFF1A2E2A))),
                    const SizedBox(height: 2),

                    // Body
                    Text(notif.body,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Color(0xFF6B8A82),
                            height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),

                    // CTA hint
                    if (notif.route != null && notif.route!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(children: [
                          const Icon(Icons.arrow_forward_rounded,
                              size: 11, color: Color(0xFF2E7D5E)),
                          const SizedBox(width: 3),
                          Text(_routeLabel(notif.route!),
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color: Color(0xFF2E7D5E),
                                  fontWeight: FontWeight.w500)),
                        ]),
                      ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'এইমাত্র';
    if (diff.inMinutes < 60) return '${diff.inMinutes}মি আগে';
    if (diff.inHours < 24) return DateFormat('h:mm a').format(dt);
    return DateFormat('d MMM').format(dt);
  }

  String _routeLabel(String route) {
    const Map<String, String> labels = {
      '/log-amal': 'আমল লগ করুন',
      '/weekly-review': 'রিভিউ দেখুন',
      '/': 'খুলুন',
    };
    return labels[route] ?? 'খুলুন';
  }
}

class _TypeBadge extends StatelessWidget {
  final NotificationType type;
  const _TypeBadge(this.type);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
            color: type.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6)),
        child: Text(type.label,
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: type.color)),
      );
}

// ─── Empty state ──────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
                color: const Color(0xFF2E7D5E).withOpacity(0.08),
                shape: BoxShape.circle),
            child: const Icon(Icons.notifications_none_rounded,
                size: 40, color: Color(0xFF2E7D5E)),
          ),
          const SizedBox(height: 20),
          const Text('কোনো নোটিফিকেশন নেই',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color(0xFF1A2E2A))),
          const SizedBox(height: 8),
          const Text('আপনার আমল রিমাইন্ডার ও আপডেটগুলো\nএখানে দেখা যাবে।',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Color(0xFF6B8A82),
                  height: 1.5)),
        ]),
      );
}
