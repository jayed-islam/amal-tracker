import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

const String _groupUrl = 'https://www.facebook.com/share/g/1AdBe7txJX/';
const String _pageUrl = 'https://www.facebook.com/share/1FTFWXzjoc/';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bg,
      appBar: AppBar(
        backgroundColor: context.colors.darkGreen,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
        title: const Text(
          'আমাদের সম্পর্কে',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App Header / Branding ─────────────────────────────────────────
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: context.colors.darkGreen,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: context.colors.darkGreen.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(
                        'assets/images/sabeq_logo.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.eco_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                    ),
                  ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 16),
                  Text(
                    'Sabeq',
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ).animate(delay: 100.ms).fadeIn(),
                  const SizedBox(height: 4),
                  Text(
                    'নেক আমলে এগিয়ে যাও',
                    style: TextStyle(
                      color: context.colors.darkGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ).animate(delay: 150.ms).fadeIn(),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── App Mission / Description ────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: context.colors.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: context.colors.border, width: 0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.01),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '✨',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'আমাদের লক্ষ্য',
                        style: TextStyle(
                          color: context.colors.textPrimary,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Sabeq (সাবেক) একটি আধুনিক নেক আমল ট্র্যাকার অ্যাপ, যা আপনাকে আপনার প্রতিদিনের ফরজ, সুন্নত ও নফল আমলসমূহ নিয়মিত ট্র্যাক করতে সহায়তা করবে। '
                    'এই অ্যাপের মাধ্যমে আপনি নিজের অগ্রগতির পরিসংখ্যান দেখতে পাবেন এবং লিডারবোর্ড ও বিভিন্ন চ্যালেঞ্জের মাধ্যমে অন্যদের সাথে পুণ্যকাজে এগিয়ে যাওয়ার সুস্থ প্রতিযোগিতায় অংশ নিতে পারবেন। '
                    'আমাদের মূল লক্ষ্য হলো প্রতিটি মুসলিমকে তার দ্বীনি জীবনে আরও সচেতন, যত্নবান এবং নিয়মিত আমল করার ব্যাপারে সাহায্য করা।',
                    style: TextStyle(
                      color: context.colors.textSecondary,
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ).animate(delay: 200.ms).fadeIn(duration: 300.ms).slideY(begin: 0.05),

            const SizedBox(height: 32),

            // ── Social Media / Community Header ──────────────────────────────
            Row(
              children: [
                Text(
                  '👥',
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(width: 8),
                Text(
                  'আমাদের সোশ্যাল মিডিয়া',
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ).animate(delay: 250.ms).fadeIn(),
            const SizedBox(height: 12),

            // ── Facebook Group ──────────────────────────────────────────────
            _SocialTile(
              icon: Icons.groups_rounded,
              title: 'ফেসবুক গ্রুপ',
              badge: 'পাবলিক গ্রুপ',
              subtitle: 'প্রশ্ন করুন, অভিজ্ঞতা শেয়ার করুন এবং অন্য ব্যবহারকারীদের সাথে যুক্ত থাকুন। এখানে যে কেউ পোস্ট করতে পারবেন।',
              bg: context.colors.blueLight,
              accent: context.colors.blue,
              onTap: () => _openExternalLink(context, _groupUrl, 'গ্রুপ'),
            ).animate(delay: 300.ms).fadeIn(duration: 300.ms).slideY(begin: 0.05),

            const SizedBox(height: 12),

            // ── Facebook Page ───────────────────────────────────────────────
            _SocialTile(
              icon: Icons.campaign_rounded,
              title: 'ফেসবুক পেজ',
              badge: 'অফিসিয়াল পেজ',
              subtitle: 'অ্যাপের নতুন ফিচার, গুরুত্বপূর্ণ আপডেট ও ঘোষণা সবার আগে জানতে আমাদের পেজটি লাইক ও ফলো করে রাখুন।',
              bg: context.colors.purpleLight,
              accent: context.colors.purple,
              onTap: () => _openExternalLink(context, _pageUrl, 'পেজ'),
            ).animate(delay: 350.ms).fadeIn(duration: 300.ms).slideY(begin: 0.05),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _openExternalLink(
      BuildContext context, String url, String label) async {
    HapticFeedback.selectionClick();
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
}

class _SocialTile extends StatelessWidget {
  final IconData icon;
  final String title, badge, subtitle;
  final Color bg, accent;
  final VoidCallback onTap;

  const _SocialTile({
    required this.icon,
    required this.title,
    required this.badge,
    required this.subtitle,
    required this.bg,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withOpacity(0.25), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accent, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: accent,
                            fontWeight: FontWeight.w800,
                            fontSize: 13.5,
                            letterSpacing: -0.1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            color: accent,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: accent.withOpacity(0.75),
                      fontSize: 11,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_outward_rounded,
              size: 16,
              color: accent.withOpacity(0.45),
            ),
          ],
        ),
      ),
    );
  }
}
