// ─────────────────────────────────────────────────────────────────────────────
// JOIN COMMUNITY — Facebook Group + Page. Two distinctly different
// destinations, so each card explains what the person actually gets there
// instead of just "join us" — the group is public and anyone can post/
// discuss, the page is one-way official announcements.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

const String _groupUrl = 'https://www.facebook.com/share/g/1AdBe7txJX/';
const String _pageUrl = 'https://www.facebook.com/share/1FTFWXzjoc/';

class JoinCommunitySection extends StatelessWidget {
  const JoinCommunitySection();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('👥', style: TextStyle(fontSize: 13)),
        SizedBox(width: 6),
        Text('কমিউনিটিতে যুক্ত হন',
            style: TextStyle(
                color: context.colors.textPri,
                fontWeight: FontWeight.w800,
                fontSize: 13,
                letterSpacing: -0.1)),
      ]),
      const SizedBox(height: 10),
      _SocialCard(
        icon: Icons.groups_rounded,
        title: 'ফেসবুক গ্রুপ',
        badge: 'পাবলিক গ্রুপ',
        subtitle:
            'প্রশ্ন করুন, অভিজ্ঞতা শেয়ার করুন এবং অন্য ব্যবহারকারীদের সাথে যুক্ত থাকুন — '
            'এটি একটি পাবলিক গ্রুপ, এখানে যে কেউ পোস্ট করতে পারবেন',
        bg: context.colors.blueLight,
        accent: context.colors.blue,
        onTap: () => _openExternalLink(context, _groupUrl, 'গ্রুপ'),
      ),
      const SizedBox(height: 10),
      _SocialCard(
        icon: Icons.campaign_rounded,
        title: 'ফেসবুক পেজ',
        badge: 'অফিসিয়াল পেজ',
        subtitle:
            'অ্যাপের নতুন ফিচার, আপডেট ও ঘোষণা সবার আগে জানতে পেজটি ফলো করুন',
        bg: context.colors.purpleLight,
        accent: context.colors.purple,
        onTap: () => _openExternalLink(context, _pageUrl, 'পেজ'),
      ),
    ]);
  }
}

class _SocialCard extends StatelessWidget {
  final IconData icon;
  final String title, badge, subtitle;
  final Color bg, accent;
  final VoidCallback onTap;
  const _SocialCard({
    required this.icon,
    required this.title,
    required this.badge,
    required this.subtitle,
    required this.bg,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: accent.withOpacity(0.25), width: 0.8)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: accent, size: 19)),
          const SizedBox(width: 11),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(children: [
                  Flexible(
                      child: Text(title,
                          style: TextStyle(
                              color: accent,
                              fontWeight: FontWeight.w800,
                              fontSize: 12.5,
                              letterSpacing: -0.1))),
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        color: accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(badge,
                        style: TextStyle(
                            color: accent,
                            fontSize: 8,
                            fontWeight: FontWeight.w700)),
                  ),
                ]),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(
                        color: accent.withOpacity(0.7),
                        fontSize: 10.5,
                        height: 1.45,
                        fontWeight: FontWeight.w500)),
              ])),
          const SizedBox(width: 6),
          Icon(Icons.arrow_outward_rounded,
              size: 14, color: accent.withOpacity(0.45)),
        ]),
      ));
}

/// Opens an external link (Facebook group/page, etc.) with error handling —
/// used by the "Join Community" section so a broken link or offline device
/// shows a clear message instead of silently doing nothing.
Future<void> _openExternalLink(
    BuildContext context, String url, String label) async {
  try {
    final launched = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$label খোলা যায়নি।'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$label খোলা যায়নি। আবার চেষ্টা করুন।'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
