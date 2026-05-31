// import 'package:amal_tracker/features/user/widgets/app_silver_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../../auth/providers/auth_provider.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // DESIGN TOKENS
// // ─────────────────────────────────────────────────────────────────────────────

// class _C {
//   static const bg = Color(0xFFF4F6F1);
//   static const card = Color(0xFFFFFFFF);
//   static const darkGreen = Color(0xFF0E3D22);
//   static const midGreen = Color(0xFF1B7045);
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const gold = Color(0xFFD4A843);
//   static const goldLight = Color(0xFFFFF8E7);
//   static const amber = Color(0xFFF59E0B);
//   static const amberLight = Color(0xFFFFF3E0);
//   static const blue = Color(0xFF0891B2);
//   static const blueLight = Color(0xFFE0F2FE);
//   static const purple = Color(0xFF7C3AED);
//   static const purpleLight = Color(0xFFEDE9FE);
//   static const rose = Color(0xFFE11D48);
//   static const roseLight = Color(0xFFFFE4E6);
//   static const teal = Color(0xFF0D9488);
//   static const tealLight = Color(0xFFCCFBF1);
//   static const border = Color(0xFFE4EAE4);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF4E6357);
//   static const textHint = Color(0xFFABBAAE);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// class HowItWorksScreen extends ConsumerStatefulWidget {
//   const HowItWorksScreen({super.key});

//   @override
//   ConsumerState<HowItWorksScreen> createState() => _HowItWorksScreenState();
// }

// class _HowItWorksScreenState extends ConsumerState<HowItWorksScreen> {
//   late final ScrollController _scrollController;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = ref.watch(currentUserProvider);
//     final isFemale = user?.gender?.toLowerCase() == 'female';
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;
//     final hPad = isTablet ? (size.width - 600) / 2 + 20.0 : 20.0;

//     return Scaffold(
//       backgroundColor: _C.bg,
//       body: CustomScrollView(
//         controller: _scrollController,
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           // ── App bar ───────────────────────────────────────────────
//           AppSliverBar(
//             scrollController: _scrollController,
//             title: 'কীভাবে কাজ করে?',
//             subtitle: 'পয়েন্ট ও র‍্যাংকিং পদ্ধতি',
//             icon: Icons.trending_up_rounded,
//             color: _C.darkGreen,
//           ),

//           // ── Body ─────────────────────────────────────────────────
//           SliverPadding(
//             padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 60),
//             sliver: SliverList(
//               delegate: SliverChildListDelegate([
//                 // ①  AMAL TYPES ────────────────────────────────────
//                 _BlockHeader(
//                   emoji: '📖',
//                   title: 'আমলের ধরন',
//                   subtitle: 'তিন ধরনের আমল রেকর্ড করা যায়',
//                 ).animate().fadeIn(duration: 280.ms),

//                 const SizedBox(height: 10),

//                 _TypeCards().animate().fadeIn(delay: 60.ms),

//                 const SizedBox(height: 26),

//                 // ②  PRAYER MODES ──────────────────────────────────
//                 _BlockHeader(
//                   emoji: '🕌',
//                   title: 'নামাজের স্তর',
//                   subtitle: 'আদায়ের স্থান অনুযায়ী পয়েন্ট আলাদা',
//                 ).animate().fadeIn(delay: 100.ms),

//                 const SizedBox(height: 10),

//                 _PrayerModesCard().animate().fadeIn(delay: 140.ms),

//                 const SizedBox(height: 26),

//                 // ③  COUNTER LOGIC ─────────────────────────────────
//                 _BlockHeader(
//                   emoji: '🔢',
//                   title: 'গণনাযোগ্য আমল',
//                   subtitle: 'প্রতিটি একক আলাদাভাবে গণনা হয়',
//                 ).animate().fadeIn(delay: 160.ms),

//                 const SizedBox(height: 10),

//                 _CounterCard().animate().fadeIn(delay: 190.ms),

//                 const SizedBox(height: 26),

//                 // ④  DAILY SCORE LOGIC ─────────────────────────────
//                 _BlockHeader(
//                   emoji: '📅',
//                   title: 'দৈনিক সংগ্রহ',
//                   subtitle: 'প্রতিদিনের সব আমলের পয়েন্ট যোগ হয়',
//                 ).animate().fadeIn(delay: 200.ms),

//                 const SizedBox(height: 10),

//                 _DailyScoreCard().animate().fadeIn(delay: 220.ms),

//                 const SizedBox(height: 26),

//                 // ⑤  MONTHLY TOTAL ─────────────────────────────────
//                 _BlockHeader(
//                   emoji: '📊',
//                   title: 'মাসিক মোট পয়েন্ট',
//                   subtitle: 'সব দিনের পয়েন্ট যোগ করে মাসের স্কোর তৈরি হয়',
//                 ).animate().fadeIn(delay: 240.ms),

//                 const SizedBox(height: 10),

//                 _MonthlyCard().animate().fadeIn(delay: 260.ms),

//                 const SizedBox(height: 26),

//                 // ⑥  LEADERBOARD ───────────────────────────────────
//                 _BlockHeader(
//                   emoji: '🏆',
//                   title: 'লিডারবোর্ড',
//                   subtitle: 'মাসের শেষে সবার স্কোর তুলনা হয়',
//                 ).animate().fadeIn(delay: 280.ms),

//                 const SizedBox(height: 10),

//                 _LeaderboardCard().animate().fadeIn(delay: 300.ms),

//                 const SizedBox(height: 26),

//                 // ⑦  FEMALE EXEMPT — only for female users ─────────
//                 if (isFemale) ...[
//                   _BlockHeader(
//                     emoji: '🌸',
//                     title: 'মাহলির দিন',
//                     subtitle: 'শুধু আপনার জন্য বিশেষ সুবিধা',
//                     accentColor: const Color(0xFFDB2777),
//                   ).animate().fadeIn(delay: 320.ms),
//                   const SizedBox(height: 10),
//                   _FemaleExemptCard().animate().fadeIn(delay: 340.ms),
//                   const SizedBox(height: 26),
//                 ],

//                 // ⑧  TIPS ──────────────────────────────────────────
//                 _TipsCard().animate().fadeIn(delay: 360.ms),
//               ]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // BLOCK HEADER
// // ─────────────────────────────────────────────────────────────────────────────

// class _BlockHeader extends StatelessWidget {
//   final String emoji, title, subtitle;
//   final Color? accentColor;

//   const _BlockHeader({
//     required this.emoji,
//     required this.title,
//     required this.subtitle,
//     this.accentColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 38,
//           height: 38,
//           decoration: BoxDecoration(
//             color: (accentColor ?? _C.darkGreen).withOpacity(0.08),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child:
//               Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
//         ),
//         const SizedBox(width: 10),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 color: accentColor ?? _C.textPrimary,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w800,
//                 letterSpacing: -0.2,
//               ),
//             ),
//             Text(
//               subtitle,
//               style: const TextStyle(color: _C.textHint, fontSize: 11),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // TYPE CARDS — three amal types explained
// // ─────────────────────────────────────────────────────────────────────────────

// class _TypeCards extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     const types = [
//       _TypeInfo(
//         emoji: '✅',
//         title: 'হ্যাঁ / না',
//         desc: 'আমলটি করেছেন কি না — এতুকুই। যেমন কুরআন তিলাওয়াত, সদকা।',
//         bg: Color(0xFFE8F5EE),
//         border: Color(0xFF16A34A),
//         textColor: Color(0xFF0E3D22),
//       ),
//       _TypeInfo(
//         emoji: '🕌',
//         title: 'নামাজ',
//         desc: 'জামাতে, একাকী বা মিস — তিনটি স্তরে আলাদা পয়েন্ট।',
//         bg: Color(0xFFFFF8E7),
//         border: Color(0xFFD4A843),
//         textColor: Color(0xFF78350F),
//       ),
//       _TypeInfo(
//         emoji: '🔢',
//         title: 'গণনা',
//         desc: 'প্রতিটি একক গণনা করা হয়। যেমন আয়াত পড়া, তাসবিহ।',
//         bg: Color(0xFFE0F2FE),
//         border: Color(0xFF0891B2),
//         textColor: Color(0xFF0C4A6E),
//       ),
//     ];

//     return Column(
//       children: types.asMap().entries.map((e) {
//         final t = e.value;
//         return Container(
//           margin: const EdgeInsets.only(bottom: 8),
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: t.bg,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: t.border.withOpacity(0.4), width: 1),
//           ),
//           child: Row(
//             children: [
//               Text(t.emoji, style: const TextStyle(fontSize: 22)),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       t.title,
//                       style: TextStyle(
//                         color: t.textColor,
//                         fontSize: 13.5,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       t.desc,
//                       style: TextStyle(
//                         color: t.textColor.withOpacity(0.75),
//                         fontSize: 11.5,
//                         height: 1.45,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         )
//             .animate(delay: Duration(milliseconds: e.key * 60))
//             .fadeIn()
//             .slideX(begin: 0.04);
//       }).toList(),
//     );
//   }
// }

// class _TypeInfo {
//   final String emoji, title, desc;
//   final Color bg, border, textColor;
//   const _TypeInfo({
//     required this.emoji,
//     required this.title,
//     required this.desc,
//     required this.bg,
//     required this.border,
//     required this.textColor,
//   });
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PRAYER MODES CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _PrayerModesCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       child: Column(
//         children: [
//           _ModeRow(
//             emoji: '✔',
//             label: 'জামাতে আদায়',
//             desc: 'মসজিদে বা দলবদ্ধভাবে',
//             badge: 'সর্বোচ্চ পয়েন্ট',
//             badgeColor: _C.green,
//             badgeBg: _C.greenLight,
//             isFirst: true,
//           ),
//           const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//           _ModeRow(
//             emoji: '/',
//             label: 'একাকী আদায়',
//             desc: 'ঘরে বা একলা পড়েছেন',
//             badge: 'কম পয়েন্ট',
//             badgeColor: _C.amber,
//             badgeBg: _C.amberLight,
//           ),
//           const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//           _ModeRow(
//             emoji: '✗',
//             label: 'মিস হয়েছে',
//             desc: 'পড়া হয়নি',
//             badge: '০ পয়েন্ট',
//             badgeColor: _C.textHint,
//             badgeBg: _C.bg,
//             isLast: true,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ModeRow extends StatelessWidget {
//   final String emoji, label, desc, badge;
//   final Color badgeColor, badgeBg;
//   final bool isFirst, isLast;

//   const _ModeRow({
//     required this.emoji,
//     required this.label,
//     required this.desc,
//     required this.badge,
//     required this.badgeColor,
//     required this.badgeBg,
//     this.isFirst = false,
//     this.isLast = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.vertical(
//           top: isFirst ? const Radius.circular(16) : Radius.zero,
//           bottom: isLast ? const Radius.circular(16) : Radius.zero,
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 34,
//             height: 34,
//             decoration: BoxDecoration(
//               color: badgeBg,
//               borderRadius: BorderRadius.circular(9),
//             ),
//             child: Center(
//               child: Text(
//                 emoji,
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: badgeColor,
//                     fontWeight: FontWeight.w800),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(label,
//                     style: const TextStyle(
//                         color: _C.textPrimary,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700)),
//                 Text(desc,
//                     style:
//                         const TextStyle(color: _C.textSecondary, fontSize: 11)),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
//             decoration: BoxDecoration(
//               color: badgeBg,
//               borderRadius: BorderRadius.circular(20),
//               border:
//                   Border.all(color: badgeColor.withOpacity(0.25), width: 0.5),
//             ),
//             child: Text(
//               badge,
//               style: TextStyle(
//                 color: badgeColor,
//                 fontSize: 10.5,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // COUNTER CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _CounterCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _C.blueLight,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.blue.withOpacity(0.3), width: 1),
//       ),
//       child: Column(
//         children: [
//           // Visual example
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(5, (i) {
//               final filled = i < 3;
//               return Container(
//                 width: 40,
//                 height: 40,
//                 margin: const EdgeInsets.symmetric(horizontal: 3),
//                 decoration: BoxDecoration(
//                   color: filled ? _C.blue : Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   border:
//                       Border.all(color: _C.blue.withOpacity(0.3), width: 0.5),
//                 ),
//                 child: Center(
//                   child: Text(
//                     filled ? '✓' : '',
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w800),
//                   ),
//                 ),
//               );
//             }),
//           ),

//           const SizedBox(height: 12),

//           // Explanation
//           RichText(
//             textAlign: TextAlign.center,
//             text: const TextSpan(
//               style: TextStyle(
//                   color: Color(0xFF0C4A6E), fontSize: 12.5, height: 1.6),
//               children: [
//                 TextSpan(text: 'উদাহরণ: ৩ আয়াত তিলাওয়াত করলে\n'),
//                 TextSpan(
//                   text: 'প্রতি আয়াত × পয়েন্ট = মোট পয়েন্ট',
//                   style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 10),

//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Text(
//               'যত বেশি করবেন, তত বেশি পয়েন্ট পাবেন',
//               style: TextStyle(
//                 color: _C.blue,
//                 fontSize: 11.5,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DAILY SCORE CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _DailyScoreCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       child: Column(
//         children: [
//           // Flow diagram
//           _FlowRow(
//             items: const ['নামাজ', 'যিকর', 'তিলাওয়াত', 'অভ্যাস'],
//             icons: const ['🕌', '📿', '📖', '💪'],
//           ),

//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 28,
//                   height: 28,
//                   decoration: BoxDecoration(
//                     color: _C.greenLight,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(Icons.add_rounded,
//                       color: _C.darkGreen, size: 16),
//                 ),
//               ],
//             ),
//           ),

//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             decoration: BoxDecoration(
//               color: _C.darkGreen,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('⭐', style: TextStyle(fontSize: 18)),
//                 SizedBox(width: 8),
//                 Text(
//                   'দৈনিক মোট পয়েন্ট',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 12),
//           const _InfoNote(
//             text:
//                 'একটি দিনে সব আমলের পয়েন্ট যোগ হয়ে দৈনিক স্কোর তৈরি হয়। প্রতিদিন রেকর্ড করুন।',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _FlowRow extends StatelessWidget {
//   final List<String> items, icons;
//   const _FlowRow({required this.items, required this.icons});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: List.generate(items.length, (i) {
//         return Column(
//           children: [
//             Container(
//               width: 44,
//               height: 44,
//               decoration: BoxDecoration(
//                 color: _C.greenLight,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Center(
//                   child: Text(icons[i], style: const TextStyle(fontSize: 20))),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               items[i],
//               style: const TextStyle(
//                   color: _C.textSecondary,
//                   fontSize: 9.5,
//                   fontWeight: FontWeight.w500),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // MONTHLY CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _MonthlyCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _C.goldLight,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.gold.withOpacity(0.4), width: 1),
//       ),
//       child: Column(
//         children: [
//           // Mini calendar-style dots
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(7, (i) {
//               final filled = i < 5;
//               return Container(
//                 width: 32,
//                 height: 32,
//                 margin: const EdgeInsets.symmetric(horizontal: 2),
//                 decoration: BoxDecoration(
//                   color: filled ? _C.gold : Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border:
//                       Border.all(color: _C.gold.withOpacity(0.3), width: 0.5),
//                 ),
//                 child: Center(
//                   child: Text(
//                     filled ? '★' : '·',
//                     style: TextStyle(
//                       color: filled ? Colors.white : _C.textHint,
//                       fontSize: filled ? 14 : 18,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           ),

//           const SizedBox(height: 12),

//           const Text(
//             'দিন ১ + দিন ২ + দিন ৩ + ... = মাসিক স্কোর',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Color(0xFF78350F),
//               fontSize: 12.5,
//               fontWeight: FontWeight.w700,
//               height: 1.5,
//             ),
//           ),

//           const SizedBox(height: 10),

//           const _InfoNote(
//             text:
//                 'মাসের প্রতিটি দিনের পয়েন্ট যোগ হয়। বেশি দিন রেকর্ড করলে মাসের স্কোর বাড়বে।',
//             textColor: Color(0xFF92400E),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // LEADERBOARD CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _LeaderboardCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       child: Column(
//         children: [
//           // Mock leaderboard rows
//           _LeaderRow(
//               rank: 1,
//               emoji: '🥇',
//               name: 'সর্বোচ্চ পয়েন্ট',
//               desc: 'মাসে সবচেয়ে বেশি আমল করেছেন',
//               rankColor: const Color(0xFFD4A843),
//               rankBg: const Color(0xFFFFFBF0),
//               isFirst: true),
//           const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//           _LeaderRow(
//               rank: 2,
//               emoji: '🥈',
//               name: 'দ্বিতীয় স্থান',
//               desc: 'পয়েন্টে দ্বিতীয় সর্বোচ্চ',
//               rankColor: const Color(0xFF94A3B8),
//               rankBg: const Color(0xFFF8FAFC)),
//           const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//           _LeaderRow(
//               rank: 3,
//               emoji: '🥉',
//               name: 'তৃতীয় স্থান',
//               desc: 'পয়েন্টে তৃতীয় সর্বোচ্চ',
//               rankColor: const Color(0xFFCD7F32),
//               rankBg: const Color(0xFFFFF7ED),
//               isLast: true),

//           // Explanation note
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: const BoxDecoration(
//               border: Border(top: BorderSide(color: _C.border, width: 0.5)),
//             ),
//             child: Column(
//               children: const [
//                 _BulletPoint(
//                     text:
//                         'প্রতি মাসে আলাদা র‍্যাংকিং — আগের মাসের হিসাব নতুন মাসে নেই'),
//                 SizedBox(height: 6),
//                 _BulletPoint(
//                     text:
//                         'একই জেলা বা প্রতিষ্ঠানের মধ্যেও আলাদা র‍্যাংকিং দেখা যাবে'),
//                 SizedBox(height: 6),
//                 _BulletPoint(
//                     text:
//                         'লিডারবোর্ডে শুধু মাসিক স্কোর দেখা যায় — বিস্তারিত আমল গোপন থাকে'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _LeaderRow extends StatelessWidget {
//   final int rank;
//   final String emoji, name, desc;
//   final Color rankColor, rankBg;
//   final bool isFirst, isLast;

//   const _LeaderRow({
//     required this.rank,
//     required this.emoji,
//     required this.name,
//     required this.desc,
//     required this.rankColor,
//     required this.rankBg,
//     this.isFirst = false,
//     this.isLast = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
//       decoration: BoxDecoration(
//         color: rankBg,
//         borderRadius: BorderRadius.vertical(
//           top: isFirst ? const Radius.circular(16) : Radius.zero,
//           bottom: isLast ? const Radius.circular(16) : Radius.zero,
//         ),
//       ),
//       child: Row(
//         children: [
//           Text(emoji, style: const TextStyle(fontSize: 22)),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name,
//                     style: const TextStyle(
//                         color: _C.textPrimary,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700)),
//                 Text(desc,
//                     style:
//                         const TextStyle(color: _C.textSecondary, fontSize: 11)),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: rankColor.withOpacity(0.12),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(
//               '#$rank',
//               style: TextStyle(
//                 color: rankColor,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // FEMALE EXEMPT CARD  — only shown to female users
// // ─────────────────────────────────────────────────────────────────────────────

// class _FemaleExemptCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFFF0F5),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//             color: const Color(0xFFDB2777).withOpacity(0.3), width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 44,
//                 height: 44,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFDB2777).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Center(
//                   child: Text('🌸', style: TextStyle(fontSize: 22)),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'মাহলির দিন চালু করুন',
//                       style: TextStyle(
//                         color: Color(0xFF9D174D),
//                         fontSize: 14,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                     Text(
//                       'আমল রেকর্ড করার সময় সালাত বিভাগে পাবেন',
//                       style: TextStyle(
//                         color: Color(0xFFBE185D),
//                         fontSize: 11,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 14),

//           // Steps
//           _ExemptStep(
//             number: '১',
//             text: 'সালাত বিভাগে "আজ কি মাহলি আছেন?" টগল চালু করুন',
//           ),
//           const SizedBox(height: 8),
//           _ExemptStep(
//             number: '২',
//             text: 'ফরজ নামাজগুলো স্বয়ংক্রিয়ভাবে "মাফ আছে" হিসেবে চিহ্নিত হবে',
//           ),
//           const SizedBox(height: 8),
//           _ExemptStep(
//             number: '৩',
//             text: 'নফল ও সুন্নাহ আমল স্বাভাবিকভাবেই রেকর্ড করতে পারবেন',
//           ),

//           const SizedBox(height: 12),

//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                   color: const Color(0xFFDB2777).withOpacity(0.15), width: 0.5),
//             ),
//             child: const Row(
//               children: [
//                 Text('💡', style: TextStyle(fontSize: 14)),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'মাহলির দিনগুলো র‍্যাংকিং-এ কোনো নেতিবাচক প্রভাব ফেলে না। ফরজ আমল মাফ, বাকি আমলের পয়েন্ট স্বাভাবিক।',
//                     style: TextStyle(
//                       color: Color(0xFF9D174D),
//                       fontSize: 11,
//                       height: 1.5,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ExemptStep extends StatelessWidget {
//   final String number, text;
//   const _ExemptStep({required this.number, required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 22,
//           height: 22,
//           decoration: BoxDecoration(
//             color: const Color(0xFFDB2777).withOpacity(0.15),
//             shape: BoxShape.circle,
//           ),
//           child: Center(
//             child: Text(
//               number,
//               style: const TextStyle(
//                 color: Color(0xFF9D174D),
//                 fontSize: 11,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             text,
//             style: const TextStyle(
//               color: Color(0xFF9D174D),
//               fontSize: 12,
//               height: 1.5,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // TIPS CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _TipsCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     const tips = [
//       _Tip(
//           emoji: '📅',
//           text: 'প্রতিদিন রেকর্ড করুন — একদিন বাদ পড়লে পয়েন্ট যোগ হয় না'),
//       _Tip(
//           emoji: '🕌',
//           text: 'জামাতে নামাজ পড়লে একাকীর চেয়ে বেশি পয়েন্ট পাবেন'),
//       _Tip(
//           emoji: '🔢',
//           text:
//               'গণনার আমলে যত বেশি করবেন তত বেশি পয়েন্ট — কোনো ঊর্ধ্বসীমা নেই'),
//       _Tip(
//           emoji: '🏆',
//           text: 'মাসের শেষ দিন পর্যন্ত র‍্যাংকিং পরিবর্তন হতে পারে'),
//     ];

//     return Container(
//       decoration: BoxDecoration(
//         color: _C.purpleLight,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.purple.withOpacity(0.25), width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
//             child: Row(
//               children: const [
//                 Text('💡', style: TextStyle(fontSize: 16)),
//                 SizedBox(width: 8),
//                 Text(
//                   'দরকারি টিপস',
//                   style: TextStyle(
//                     color: _C.purple,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(height: 0.5, thickness: 0.5, color: Color(0xFFDDD6FE)),
//           ...tips.asMap().entries.map((e) {
//             final t = e.value;
//             final isLast = e.key == tips.length - 1;
//             return Column(
//               children: [
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(t.emoji, style: const TextStyle(fontSize: 15)),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Text(
//                           t.text,
//                           style: const TextStyle(
//                             color: _C.purple,
//                             fontSize: 12,
//                             height: 1.5,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (!isLast)
//                   const Divider(
//                       height: 0.5,
//                       thickness: 0.5,
//                       color: Color(0xFFDDD6FE),
//                       indent: 40),
//               ],
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }

// class _Tip {
//   final String emoji, text;
//   const _Tip({required this.emoji, required this.text});
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SHARED HELPERS
// // ─────────────────────────────────────────────────────────────────────────────

// class _InfoNote extends StatelessWidget {
//   final String text;
//   final Color? textColor;

//   const _InfoNote({required this.text, this.textColor});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.6),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Text(
//         text,
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: textColor ?? _C.textSecondary,
//           fontSize: 11.5,
//           height: 1.5,
//         ),
//       ),
//     );
//   }
// }

// class _BulletPoint extends StatelessWidget {
//   final String text;
//   const _BulletPoint({required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 5,
//           height: 5,
//           margin: const EdgeInsets.only(top: 5, right: 8),
//           decoration: const BoxDecoration(
//             color: _C.darkGreen,
//             shape: BoxShape.circle,
//           ),
//         ),
//         Expanded(
//           child: Text(
//             text,
//             style: const TextStyle(
//               color: _C.textSecondary,
//               fontSize: 11.5,
//               height: 1.5,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// // }
// import 'package:amal_tracker/features/user/widgets/app_silver_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../auth/providers/auth_provider.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // DESIGN TOKENS
// // ─────────────────────────────────────────────────────────────────────────────

// class _C {
//   static const bg = Color(0xFFF4F6F1);
//   static const card = Color(0xFFFFFFFF);
//   static const darkGreen = Color(0xFF0E3D22);
//   static const midGreen = Color(0xFF1B7045);
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const gold = Color(0xFFD4A843);
//   static const goldLight = Color(0xFFFFF8E7);
//   static const amber = Color(0xFFF59E0B);
//   static const amberLight = Color(0xFFFFF3E0);
//   static const blue = Color(0xFF0891B2);
//   static const blueLight = Color(0xFFE0F2FE);
//   static const purple = Color(0xFF7C3AED);
//   static const purpleLight = Color(0xFFEDE9FE);
//   static const rose = Color(0xFFE11D48);
//   static const roseLight = Color(0xFFFFE4E6);
//   static const teal = Color(0xFF0D9488);
//   static const tealLight = Color(0xFFCCFBF1);
//   static const indigo = Color(0xFF4338CA);
//   static const indigoLight = Color(0xFFE0E7FF);
//   static const pink = Color(0xFFDB2777);
//   static const pinkLight = Color(0xFFFFF0F5);
//   static const border = Color(0xFFE4EAE4);
//   static const textPrimary = Color(0xFF0A1A0F);
//   static const textSecondary = Color(0xFF4E6357);
//   static const textHint = Color(0xFFABBAAE);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// class HowItWorksScreen extends ConsumerStatefulWidget {
//   const HowItWorksScreen({super.key});

//   @override
//   ConsumerState<HowItWorksScreen> createState() => _HowItWorksScreenState();
// }

// class _HowItWorksScreenState extends ConsumerState<HowItWorksScreen> {
//   late final ScrollController _scrollController;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = ref.watch(currentUserProvider);
//     final isFemale = user?.gender?.toLowerCase() == 'female';
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;
//     final hPad = isTablet ? (size.width - 600) / 2 + 20.0 : 20.0;

//     return Scaffold(
//       backgroundColor: _C.bg,
//       body: CustomScrollView(
//         controller: _scrollController,
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           AppSliverBar(
//             scrollController: _scrollController,
//             title: 'কীভাবে কাজ করে?',
//             subtitle: 'পয়েন্ট, র‍্যাংকিং ও সব নিয়মকানুন',
//             icon: Icons.trending_up_rounded,
//             color: _C.darkGreen,
//           ),
//           SliverPadding(
//             padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 60),
//             sliver: SliverList(
//               delegate: SliverChildListDelegate([
//                 // ① Amal Types
//                 _BlockHeader(
//                   emoji: '📖',
//                   title: 'আমলের ধরন',
//                   subtitle: 'তিন ধরনের আমল রেকর্ড করা যায়',
//                 ).animate().fadeIn(duration: 280.ms),
//                 const SizedBox(height: 10),
//                 _TypeCards().animate().fadeIn(delay: 60.ms),
//                 const SizedBox(height: 26),

//                 // ② Prayer Modes
//                 _BlockHeader(
//                   emoji: '🕌',
//                   title: 'নামাজের স্তর',
//                   subtitle: 'আদায়ের স্থান অনুযায়ী পয়েন্ট আলাদা',
//                 ).animate().fadeIn(delay: 80.ms),
//                 const SizedBox(height: 10),
//                 _PrayerModesCard().animate().fadeIn(delay: 100.ms),
//                 const SizedBox(height: 26),

//                 // ③ Amal Category Types (Daily/Weekly/Monthly)
//                 _BlockHeader(
//                   emoji: '🗓️',
//                   title: 'আমলের সময়কাল',
//                   subtitle: 'দৈনিক / সাপ্তাহিক / মাসিক — পয়েন্ট আলাদা ট্র্যাক হয়',
//                 ).animate().fadeIn(delay: 100.ms),
//                 const SizedBox(height: 10),
//                 _AmalTypeCard().animate().fadeIn(delay: 120.ms),
//                 const SizedBox(height: 26),

//                 // ④ Daily Score
//                 _BlockHeader(
//                   emoji: '📅',
//                   title: 'দৈনিক স্কোর',
//                   subtitle: 'প্রতিদিনের সব আমলের পয়েন্ট যোগ হয়',
//                 ).animate().fadeIn(delay: 140.ms),
//                 const SizedBox(height: 10),
//                 _DailyScoreCard().animate().fadeIn(delay: 160.ms),
//                 const SizedBox(height: 26),

//                 // ⑤ Monthly Completion % — NEW MAIN SECTION
//                 _BlockHeader(
//                   emoji: '📊',
//                   title: 'মাসিক সম্পূর্ণতার হার',
//                   subtitle: 'র‍্যাংকিংয়ের প্রথম ও প্রধান মানদণ্ড',
//                   accentColor: _C.teal,
//                 ).animate().fadeIn(delay: 160.ms),
//                 const SizedBox(height: 10),
//                 _CompletionPercentageCard().animate().fadeIn(delay: 180.ms),
//                 const SizedBox(height: 26),

//                 // ⑥ Monthly Total Points
//                 _BlockHeader(
//                   emoji: '🏅',
//                   title: 'মাসিক মোট পয়েন্ট',
//                   subtitle: 'সব দিনের totalPoints যোগ হয়',
//                 ).animate().fadeIn(delay: 200.ms),
//                 const SizedBox(height: 10),
//                 _MonthlyCard().animate().fadeIn(delay: 220.ms),
//                 const SizedBox(height: 26),

//                 // ⑦ Streak — NEW
//                 _BlockHeader(
//                   emoji: '🔥',
//                   title: 'স্ট্রিক',
//                   subtitle: 'ধারাবাহিক দিন গণনা',
//                   accentColor: _C.rose,
//                 ).animate().fadeIn(delay: 220.ms),
//                 const SizedBox(height: 10),
//                 _StreakCard().animate().fadeIn(delay: 240.ms),
//                 const SizedBox(height: 26),

//                 // ⑧ Leaderboard Ranking — UPDATED
//                 _BlockHeader(
//                   emoji: '🏆',
//                   title: 'লিডারবোর্ড র‍্যাংকিং',
//                   subtitle: 'তিনটি মানদণ্ডে ক্রমানুসারে',
//                 ).animate().fadeIn(delay: 240.ms),
//                 const SizedBox(height: 10),
//                 _LeaderboardCard().animate().fadeIn(delay: 260.ms),
//                 const SizedBox(height: 26),

//                 // ⑨ Winners — NEW
//                 _BlockHeader(
//                   emoji: '🥇',
//                   title: 'মাসিক বিজয়ী',
//                   subtitle: 'তিনটি আলাদা পুরস্কার বিভাগ',
//                   accentColor: _C.gold,
//                 ).animate().fadeIn(delay: 260.ms),
//                 const SizedBox(height: 10),
//                 _WinnersCard().animate().fadeIn(delay: 280.ms),
//                 const SizedBox(height: 26),

//                 // ⑩ Privacy System — NEW
//                 _BlockHeader(
//                   emoji: '🔒',
//                   title: 'প্রাইভেসি ব্যবস্থা',
//                   subtitle: 'তিনটি আলাদা নিয়ন্ত্রণ',
//                   accentColor: _C.purple,
//                 ).animate().fadeIn(delay: 280.ms),
//                 const SizedBox(height: 10),
//                 _PrivacyCard().animate().fadeIn(delay: 300.ms),
//                 const SizedBox(height: 26),

//                 // ⑪ Profile Share — NEW
//                 _BlockHeader(
//                   emoji: '🔗',
//                   title: 'প্রোফাইল শেয়ার',
//                   subtitle: 'মাসিক বিস্তারিত প্রকাশ্যে শেয়ার',
//                   accentColor: _C.blue,
//                 ).animate().fadeIn(delay: 300.ms),
//                 const SizedBox(height: 10),
//                 _ProfileShareCard().animate().fadeIn(delay: 320.ms),
//                 const SizedBox(height: 26),

//                 // ⑫ Female Exempt — only for female users
//                 if (isFemale) ...[
//                   _BlockHeader(
//                     emoji: '🌸',
//                     title: 'মাহলির দিন',
//                     subtitle: 'শুধু আপনার জন্য বিশেষ সুবিধা',
//                     accentColor: _C.pink,
//                   ).animate().fadeIn(delay: 320.ms),
//                   const SizedBox(height: 10),
//                   _FemaleExemptCard().animate().fadeIn(delay: 340.ms),
//                   const SizedBox(height: 26),
//                 ],

//                 // ⑬ Tips
//                 _TipsCard().animate().fadeIn(delay: 360.ms),
//               ]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // BLOCK HEADER
// // ─────────────────────────────────────────────────────────────────────────────

// class _BlockHeader extends StatelessWidget {
//   final String emoji, title, subtitle;
//   final Color? accentColor;

//   const _BlockHeader({
//     required this.emoji,
//     required this.title,
//     required this.subtitle,
//     this.accentColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 38,
//           height: 38,
//           decoration: BoxDecoration(
//             color: (accentColor ?? _C.darkGreen).withOpacity(0.08),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
//         ),
//         const SizedBox(width: 10),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 color: accentColor ?? _C.textPrimary,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w800,
//                 letterSpacing: -0.2,
//               ),
//             ),
//             Text(
//               subtitle,
//               style: const TextStyle(color: _C.textHint, fontSize: 11),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // SHARED HELPERS
// // ─────────────────────────────────────────────────────────────────────────────

// class _InfoNote extends StatelessWidget {
//   final String text;
//   final Color? textColor;
//   final Color? bgColor;

//   const _InfoNote({required this.text, this.textColor, this.bgColor});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: bgColor ?? Colors.white.withOpacity(0.6),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Text(
//         text,
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: textColor ?? _C.textSecondary,
//           fontSize: 11.5,
//           height: 1.5,
//         ),
//       ),
//     );
//   }
// }

// class _BulletPoint extends StatelessWidget {
//   final String text;
//   final Color? dotColor;
//   final Color? textColor;

//   const _BulletPoint({required this.text, this.dotColor, this.textColor});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 5,
//           height: 5,
//           margin: const EdgeInsets.only(top: 5, right: 8),
//           decoration: BoxDecoration(
//             color: dotColor ?? _C.darkGreen,
//             shape: BoxShape.circle,
//           ),
//         ),
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(
//               color: textColor ?? _C.textSecondary,
//               fontSize: 11.5,
//               height: 1.5,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _FormulaBox extends StatelessWidget {
//   final String text;
//   final Color? bgColor;
//   final Color? textColor;

//   const _FormulaBox({required this.text, this.bgColor, this.textColor});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       decoration: BoxDecoration(
//         color: bgColor ?? _C.bg,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: textColor ?? _C.textSecondary,
//           fontSize: 12,
//           height: 1.6,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // TYPE CARDS — three input types
// // ─────────────────────────────────────────────────────────────────────────────

// class _TypeCards extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     const types = [
//       _TypeInfo(
//         emoji: '✅',
//         title: 'হ্যাঁ / না (Yes/No)',
//         desc: 'আমলটি করেছেন কি না। পয়েন্ট = নির্ধারিত basePoints। যেমন: কুরআন তিলাওয়াত, সদকা।',
//         bg: Color(0xFFE8F5EE),
//         border: Color(0xFF16A34A),
//         textColor: Color(0xFF0E3D22),
//       ),
//       _TypeInfo(
//         emoji: '🕌',
//         title: 'নামাজ (Prayer)',
//         desc: 'তিনটি স্তরে পয়েন্ট আলাদা — জামাত, একাকী, মিস। প্রতিটি স্তরের পয়েন্ট আলাদাভাবে নির্ধারিত।',
//         bg: Color(0xFFFFF8E7),
//         border: Color(0xFFD4A843),
//         textColor: Color(0xFF78350F),
//       ),
//       _TypeInfo(
//         emoji: '🔢',
//         title: 'গণনা (Counter)',
//         desc: 'প্রতিটি একক আলাদা গণনা হয়। count × basePoints = পয়েন্ট। কোনো ঊর্ধ্বসীমা নেই।',
//         bg: Color(0xFFE0F2FE),
//         border: Color(0xFF0891B2),
//         textColor: Color(0xFF0C4A6E),
//       ),
//     ];

//     return Column(
//       children: types.asMap().entries.map((e) {
//         final t = e.value;
//         return Container(
//           margin: const EdgeInsets.only(bottom: 8),
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: t.bg,
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: t.border.withOpacity(0.4), width: 1),
//           ),
//           child: Row(
//             children: [
//               Text(t.emoji, style: const TextStyle(fontSize: 22)),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       t.title,
//                       style: TextStyle(
//                         color: t.textColor,
//                         fontSize: 13.5,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       t.desc,
//                       style: TextStyle(
//                         color: t.textColor.withOpacity(0.75),
//                         fontSize: 11.5,
//                         height: 1.45,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         )
//             .animate(delay: Duration(milliseconds: e.key * 60))
//             .fadeIn()
//             .slideX(begin: 0.04);
//       }).toList(),
//     );
//   }
// }

// class _TypeInfo {
//   final String emoji, title, desc;
//   final Color bg, border, textColor;
//   const _TypeInfo({
//     required this.emoji,
//     required this.title,
//     required this.desc,
//     required this.bg,
//     required this.border,
//     required this.textColor,
//   });
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PRAYER MODES CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _PrayerModesCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: _C.card,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.border, width: 0.5),
//           ),
//           child: Column(
//             children: [
//               _ModeRow(
//                 emoji: '✔',
//                 label: 'জামাতে আদায়',
//                 desc: 'মসজিদে বা দলবদ্ধভাবে',
//                 badge: 'সর্বোচ্চ পয়েন্ট',
//                 badgeColor: _C.green,
//                 badgeBg: _C.greenLight,
//                 isFirst: true,
//               ),
//               const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//               _ModeRow(
//                 emoji: '/',
//                 label: 'একাকী আদায়',
//                 desc: 'ঘরে বা একলা পড়েছেন',
//                 badge: 'কম পয়েন্ট',
//                 badgeColor: _C.amber,
//                 badgeBg: _C.amberLight,
//               ),
//               const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//               _ModeRow(
//                 emoji: '✗',
//                 label: 'মিস হয়েছে',
//                 desc: 'পড়া হয়নি',
//                 badge: '০ পয়েন্ট',
//                 badgeColor: _C.textHint,
//                 badgeBg: _C.bg,
//                 isLast: true,
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         _FormulaBox(
//           text: 'জামাতে → congregationPoints  |  একাকী → basePoints  |  মিস → 0',
//         ),
//       ],
//     );
//   }
// }

// class _ModeRow extends StatelessWidget {
//   final String emoji, label, desc, badge;
//   final Color badgeColor, badgeBg;
//   final bool isFirst, isLast;

//   const _ModeRow({
//     required this.emoji,
//     required this.label,
//     required this.desc,
//     required this.badge,
//     required this.badgeColor,
//     required this.badgeBg,
//     this.isFirst = false,
//     this.isLast = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.vertical(
//           top: isFirst ? const Radius.circular(16) : Radius.zero,
//           bottom: isLast ? const Radius.circular(16) : Radius.zero,
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 34,
//             height: 34,
//             decoration: BoxDecoration(
//               color: badgeBg,
//               borderRadius: BorderRadius.circular(9),
//             ),
//             child: Center(
//               child: Text(
//                 emoji,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: badgeColor,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(label,
//                     style: const TextStyle(
//                         color: _C.textPrimary,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700)),
//                 Text(desc,
//                     style: const TextStyle(
//                         color: _C.textSecondary, fontSize: 11)),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
//             decoration: BoxDecoration(
//               color: badgeBg,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                   color: badgeColor.withOpacity(0.25), width: 0.5),
//             ),
//             child: Text(
//               badge,
//               style: TextStyle(
//                 color: badgeColor,
//                 fontSize: 10.5,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // AMAL CATEGORY TYPE CARD — Daily / Weekly / Monthly
// // ─────────────────────────────────────────────────────────────────────────────

// class _AmalTypeCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       child: Column(
//         children: [
//           _AmalTypeRow(
//             emoji: '📅',
//             label: 'দৈনিক আমল (Daily)',
//             desc: 'প্রতিদিন হিসাব হয়',
//             badge: 'dailyPoints',
//             badgeColor: _C.teal,
//             badgeBg: _C.tealLight,
//             isFirst: true,
//           ),
//           const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//           _AmalTypeRow(
//             emoji: '📆',
//             label: 'সাপ্তাহিক আমল (Weekly)',
//             desc: 'সপ্তাহে একবার গণনা হয়',
//             badge: 'weeklyPoints',
//             badgeColor: _C.purple,
//             badgeBg: _C.purpleLight,
//           ),
//           const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//           _AmalTypeRow(
//             emoji: '🗃️',
//             label: 'মাসিক / বিশেষ',
//             desc: 'Monthly বা Special ধরনের আমল',
//             badge: 'monthlyPoints',
//             badgeColor: _C.amber,
//             badgeBg: _C.amberLight,
//             isLast: true,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _AmalTypeRow extends StatelessWidget {
//   final String emoji, label, desc, badge;
//   final Color badgeColor, badgeBg;
//   final bool isFirst, isLast;

//   const _AmalTypeRow({
//     required this.emoji,
//     required this.label,
//     required this.desc,
//     required this.badge,
//     required this.badgeColor,
//     required this.badgeBg,
//     this.isFirst = false,
//     this.isLast = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.vertical(
//           top: isFirst ? const Radius.circular(16) : Radius.zero,
//           bottom: isLast ? const Radius.circular(16) : Radius.zero,
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 34,
//             height: 34,
//             decoration: BoxDecoration(
//               color: badgeBg,
//               borderRadius: BorderRadius.circular(9),
//             ),
//             child: Center(
//                 child: Text(emoji, style: const TextStyle(fontSize: 17))),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(label,
//                     style: const TextStyle(
//                         color: _C.textPrimary,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700)),
//                 Text(desc,
//                     style: const TextStyle(
//                         color: _C.textSecondary, fontSize: 11)),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: badgeBg,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                   color: badgeColor.withOpacity(0.3), width: 0.5),
//             ),
//             child: Text(
//               badge,
//               style: TextStyle(
//                 color: badgeColor,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DAILY SCORE CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _DailyScoreCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       child: Column(
//         children: [
//           _FlowRow(
//             items: const ['নামাজ', 'যিকর', 'তিলাওয়াত', 'অভ্যাস'],
//             icons: const ['🕌', '📿', '📖', '💪'],
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 28,
//                   height: 28,
//                   decoration: const BoxDecoration(
//                     color: _C.greenLight,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(Icons.add_rounded,
//                       color: _C.darkGreen, size: 16),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             decoration: BoxDecoration(
//               color: _C.darkGreen,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('⭐', style: TextStyle(fontSize: 18)),
//                 SizedBox(width: 8),
//                 Text(
//                   'দৈনিক মোট পয়েন্ট (totalPoints)',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           const _InfoNote(
//             text:
//                 'totalPoints > 0 হলেই সেই দিন "সম্পন্ন" (daysCompleted) ধরা হয়। প্রতিদিন রেকর্ড করুন।',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _FlowRow extends StatelessWidget {
//   final List<String> items, icons;
//   const _FlowRow({required this.items, required this.icons});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: List.generate(items.length, (i) {
//         return Column(
//           children: [
//             Container(
//               width: 44,
//               height: 44,
//               decoration: BoxDecoration(
//                 color: _C.greenLight,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Center(
//                   child:
//                       Text(icons[i], style: const TextStyle(fontSize: 20))),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               items[i],
//               style: const TextStyle(
//                   color: _C.textSecondary,
//                   fontSize: 9.5,
//                   fontWeight: FontWeight.w500),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // COMPLETION PERCENTAGE CARD — NEW
// // ─────────────────────────────────────────────────────────────────────────────

// class _CompletionPercentageCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Main formula card
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: _C.tealLight,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.teal.withOpacity(0.3), width: 1),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'সূত্র',
//                 style: TextStyle(
//                   color: _C.teal,
//                   fontSize: 11,
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Text(
//                   'completionPercentage\n= (farzCompletedDays ÷ eligibleDays) × 100',
//                   style: TextStyle(
//                     color: Color(0xFF085041),
//                     fontSize: 12.5,
//                     fontWeight: FontWeight.w700,
//                     height: 1.6,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 14),

//               // Example bar
//               Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text('উদাহরণ: ১৮ / ২২ দিন',
//                                 style: TextStyle(
//                                     color: Color(0xFF085041),
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.w600)),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 8, vertical: 3),
//                               decoration: BoxDecoration(
//                                 color: _C.teal,
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: const Text('82%',
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 11,
//                                       fontWeight: FontWeight.w800)),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(6),
//                           child: LinearProgressIndicator(
//                             value: 0.82,
//                             minHeight: 8,
//                             backgroundColor: Colors.white,
//                             valueColor:
//                                 const AlwaysStoppedAnimation<Color>(_C.teal),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),

//         const SizedBox(height: 8),

//         // eligibleDays breakdown
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: _C.card,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.border, width: 0.5),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'eligibleDays কীভাবে হিসাব হয়',
//                 style: TextStyle(
//                   color: _C.textPrimary,
//                   fontSize: 12.5,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//               const SizedBox(height: 10),
//               _CalcRow(
//                   label: 'মাসের অতিবাহিত দিন', value: 'daysElapsed'),
//               const SizedBox(height: 6),
//               _CalcRow(
//                   label: 'বাদ যায় (মাহলির দিন)',
//                   value: '− exemptDays',
//                   valueColor: _C.rose),
//               const SizedBox(height: 8),
//               const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//               const SizedBox(height: 8),
//               _CalcRow(
//                   label: 'eligibleDays',
//                   value: '= daysElapsed − exemptDays',
//                   isBold: true,
//                   valueColor: _C.teal),
//             ],
//           ),
//         ),

//         const SizedBox(height: 8),

//         // farzCompletedDays explanation
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: _C.card,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.border, width: 0.5),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'farzCompletedDays কখন বাড়ে?',
//                 style: TextStyle(
//                   color: _C.textPrimary,
//                   fontSize: 12.5,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const _BulletPoint(
//                 text:
//                     'সেই দিনের সব ফরজ আমল (isFard = true) completed = true হতে হবে',
//               ),
//               const SizedBox(height: 4),
//               const _BulletPoint(
//                 text:
//                     'একটি ফরজও মিস হলে সেই দিন count হবে না',
//               ),
//               const SizedBox(height: 4),
//               const _BulletPoint(
//                 text:
//                     'শুধু বেশি পয়েন্ট হলেই এই % বাড়ে না — ফরজ সম্পন্ন করতে হবে',
//               ),
//             ],
//           ),
//         ),

//         const SizedBox(height: 8),

//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: _C.tealLight,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: _C.teal.withOpacity(0.3)),
//           ),
//           child: const Row(
//             children: [
//               Text('⚠️', style: TextStyle(fontSize: 14)),
//               SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   'ফরজ আমল না থাকলে completionPercentage সর্বদা 0% দেখাবে। এটা ইচ্ছাকৃত — বিভ্রান্তিকর % এড়াতে।',
//                   style: TextStyle(
//                     color: Color(0xFF085041),
//                     fontSize: 11.5,
//                     height: 1.5,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _CalcRow extends StatelessWidget {
//   final String label, value;
//   final Color? valueColor;
//   final bool isBold;

//   const _CalcRow({
//     required this.label,
//     required this.value,
//     this.valueColor,
//     this.isBold = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             color: isBold ? _C.textPrimary : _C.textSecondary,
//             fontSize: 12,
//             fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
//           ),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             color: valueColor ?? _C.textPrimary,
//             fontSize: 12,
//             fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // MONTHLY CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _MonthlyCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _C.goldLight,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.gold.withOpacity(0.4), width: 1),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(7, (i) {
//               final filled = i < 5;
//               return Container(
//                 width: 32,
//                 height: 32,
//                 margin: const EdgeInsets.symmetric(horizontal: 2),
//                 decoration: BoxDecoration(
//                   color: filled ? _C.gold : Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                       color: _C.gold.withOpacity(0.3), width: 0.5),
//                 ),
//                 child: Center(
//                   child: Text(
//                     filled ? '★' : '·',
//                     style: TextStyle(
//                       color: filled ? Colors.white : _C.textHint,
//                       fontSize: filled ? 14 : 18,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           ),
//           const SizedBox(height: 12),
//           const Text(
//             'দিন ১ + দিন ২ + দিন ৩ + ... = মাসিক totalPoints',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Color(0xFF78350F),
//               fontSize: 12.5,
//               fontWeight: FontWeight.w700,
//               height: 1.5,
//             ),
//           ),
//           const SizedBox(height: 10),
//           const _InfoNote(
//             text:
//                 'completionPercentage সমান হলে বেশি totalPoints থাকা ব্যক্তি র‍্যাংকিংয়ে এগিয়ে থাকবেন।',
//             textColor: Color(0xFF92400E),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // STREAK CARD — NEW
// // ─────────────────────────────────────────────────────────────────────────────

// class _StreakCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _C.roseLight,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.rose.withOpacity(0.25), width: 1),
//       ),
//       child: Column(
//         children: [
//           // Visual streak dots
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(7, (i) {
//               final active = i < 4;
//               final broken = i == 5;
//               return Container(
//                 width: 36,
//                 height: 36,
//                 margin: const EdgeInsets.symmetric(horizontal: 2),
//                 decoration: BoxDecoration(
//                   color: active
//                       ? _C.rose
//                       : (broken ? _C.roseLight : const Color(0xFFFEE2E2)),
//                   borderRadius: BorderRadius.circular(9),
//                   border: Border.all(
//                     color: active
//                         ? _C.rose
//                         : _C.rose.withOpacity(0.2),
//                     width: active ? 0 : 0.5,
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     active ? '🔥' : (broken ? '✗' : ''),
//                     style: TextStyle(
//                       fontSize: active ? 16 : 13,
//                       color: broken ? _C.rose.withOpacity(0.4) : null,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           ),
//           const SizedBox(height: 12),
//           const Text(
//             'আজ থেকে পেছনে গণনা — প্রথম ফাঁকা দিনে বন্ধ\nউপরে streak = 4',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Color(0xFF9F1239),
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               height: 1.55,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Container(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Row(
//               children: [
//                 Text('🌸', style: TextStyle(fontSize: 14)),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'মাহলির দিন স্ট্রিক ভাঙে না — সক্রিয় দিন হিসেবে গণ্য হয়',
//                     style: TextStyle(
//                       color: Color(0xFF9F1239),
//                       fontSize: 11.5,
//                       height: 1.4,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//           const _InfoNote(
//             text:
//                 'completionPercentage ও totalPoints সমান হলে বেশি streakDays থাকা ব্যক্তি এগিয়ে থাকবেন।',
//             textColor: Color(0xFF9F1239),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // LEADERBOARD CARD — UPDATED with correct sort order
// // ─────────────────────────────────────────────────────────────────────────────

// class _LeaderboardCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       child: Column(
//         children: [
//           // Ranking criteria
//           _RankCriteriaRow(
//             number: '১ম',
//             numberColor: _C.teal,
//             numberBg: _C.tealLight,
//             label: 'completionPercentage',
//             desc: 'ফরজ সম্পন্ন দিনের হার — প্রধান মানদণ্ড',
//             badge: 'প্রধান',
//             badgeColor: _C.teal,
//             badgeBg: _C.tealLight,
//             isFirst: true,
//           ),
//           const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//           _RankCriteriaRow(
//             number: '২য়',
//             numberColor: _C.blue,
//             numberBg: _C.blueLight,
//             label: 'totalPoints',
//             desc: 'সমান % হলে বেশি পয়েন্টধারী এগিয়ে',
//             badge: 'টাই-ব্রেক',
//             badgeColor: _C.blue,
//             badgeBg: _C.blueLight,
//           ),
//           const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//           _RankCriteriaRow(
//             number: '৩য়',
//             numberColor: _C.rose,
//             numberBg: _C.roseLight,
//             label: 'streakDays',
//             desc: 'উপরের দুটো সমান হলে স্ট্রিক দেখা হয়',
//             badge: 'চূড়ান্ত',
//             badgeColor: _C.rose,
//             badgeBg: _C.roseLight,
//             isLast: false,
//           ),
//           const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//           // Notes
//           Container(
//             padding: const EdgeInsets.all(14),
//             child: Column(
//               children: const [
//                 _BulletPoint(
//                     text:
//                         'প্রতি মাসে আলাদা র‍্যাংকিং — আগের মাসের হিসাব নতুন মাসে নেই'),
//                 SizedBox(height: 6),
//                 _BulletPoint(
//                     text:
//                         'isActive = false বা isHidden = true ব্যবহারকারীরা লিডারবোর্ডে দেখা যাবেন না'),
//                 SizedBox(height: 6),
//                 _BulletPoint(
//                     text:
//                         'লিডারবোর্ডে শুধু মাসিক স্কোর দেখা যায় — বিস্তারিত আমল সর্বদা গোপন'),
//                 SizedBox(height: 6),
//                 _BulletPoint(
//                     text:
//                         'একই জেলা বা প্রতিষ্ঠানের মধ্যেও আলাদা ফিল্টার করে র‍্যাংকিং দেখা যাবে'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _RankCriteriaRow extends StatelessWidget {
//   final String number, label, desc, badge;
//   final Color numberColor, numberBg, badgeColor, badgeBg;
//   final bool isFirst, isLast;

//   const _RankCriteriaRow({
//     required this.number,
//     required this.numberColor,
//     required this.numberBg,
//     required this.label,
//     required this.desc,
//     required this.badge,
//     required this.badgeColor,
//     required this.badgeBg,
//     this.isFirst = false,
//     this.isLast = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.vertical(
//           top: isFirst ? const Radius.circular(16) : Radius.zero,
//           bottom: isLast ? const Radius.circular(16) : Radius.zero,
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 30,
//             height: 30,
//             decoration: BoxDecoration(
//               color: numberBg,
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Text(
//                 number,
//                 style: TextStyle(
//                   color: numberColor,
//                   fontSize: 10.5,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(label,
//                     style: const TextStyle(
//                         color: _C.textPrimary,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700)),
//                 Text(desc,
//                     style: const TextStyle(
//                         color: _C.textSecondary, fontSize: 11)),
//               ],
//             ),
//           ),
//           Container(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
//             decoration: BoxDecoration(
//               color: badgeBg,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                   color: badgeColor.withOpacity(0.3), width: 0.5),
//             ),
//             child: Text(
//               badge,
//               style: TextStyle(
//                 color: badgeColor,
//                 fontSize: 10.5,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // WINNERS CARD — NEW
// // ─────────────────────────────────────────────────────────────────────────────

// class _WinnersCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: _C.card,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.border, width: 0.5),
//           ),
//           child: Column(
//             children: [
//               _WinnerRow(
//                 emoji: '🥇',
//                 label: 'TOP_FARZ',
//                 desc: 'সর্বোচ্চ completionPercentage — ফরজে অগ্রগামী',
//                 badge: 'সর্বোচ্চ অগ্রাধিকার',
//                 badgeColor: _C.gold,
//                 badgeBg: _C.goldLight,
//                 isFirst: true,
//               ),
//               const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//               _WinnerRow(
//                 emoji: '💪',
//                 label: 'TOP_EFFORT',
//                 desc: 'সর্বোচ্চ totalPoints — সর্বাধিক পরিশ্রমী',
//                 badge: 'মধ্যম',
//                 badgeColor: _C.blue,
//                 badgeBg: _C.blueLight,
//               ),
//               const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//               _WinnerRow(
//                 emoji: '🔥',
//                 label: 'TOP_STREAK',
//                 desc: 'সর্বোচ্চ streakDays — সবচেয়ে ধারাবাহিক',
//                 badge: 'নিম্নতম',
//                 badgeColor: _C.rose,
//                 badgeBg: _C.roseLight,
//                 isLast: true,
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: _C.goldLight,
//             borderRadius: BorderRadius.circular(12),
//             border:
//                 Border.all(color: _C.gold.withOpacity(0.3), width: 0.5),
//           ),
//           child: const Row(
//             children: [
//               Text('💡', style: TextStyle(fontSize: 14)),
//               SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   'একজন একাধিক বিভাগে যোগ্য হলে সর্বোচ্চ অগ্রাধিকারের বিভাগটি দেওয়া হয়। isHidden ব্যবহারকারীরা বিজয়ী হবেন না।',
//                   style: TextStyle(
//                     color: Color(0xFF78350F),
//                     fontSize: 11.5,
//                     height: 1.5,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _WinnerRow extends StatelessWidget {
//   final String emoji, label, desc, badge;
//   final Color badgeColor, badgeBg;
//   final bool isFirst, isLast;

//   const _WinnerRow({
//     required this.emoji,
//     required this.label,
//     required this.desc,
//     required this.badge,
//     required this.badgeColor,
//     required this.badgeBg,
//     this.isFirst = false,
//     this.isLast = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.vertical(
//           top: isFirst ? const Radius.circular(16) : Radius.zero,
//           bottom: isLast ? const Radius.circular(16) : Radius.zero,
//         ),
//       ),
//       child: Row(
//         children: [
//           Text(emoji, style: const TextStyle(fontSize: 22)),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(label,
//                     style: const TextStyle(
//                         color: _C.textPrimary,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700)),
//                 Text(desc,
//                     style: const TextStyle(
//                         color: _C.textSecondary, fontSize: 11)),
//               ],
//             ),
//           ),
//           Container(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
//             decoration: BoxDecoration(
//               color: badgeBg,
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                   color: badgeColor.withOpacity(0.3), width: 0.5),
//             ),
//             child: Text(
//               badge,
//               style: TextStyle(
//                 color: badgeColor,
//                 fontSize: 10.5,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PRIVACY CARD — NEW
// // ─────────────────────────────────────────────────────────────────────────────

// class _PrivacyCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: _C.card,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.border, width: 0.5),
//           ),
//           child: Column(
//             children: [
//               _PrivacyRow(
//                 emoji: '🙈',
//                 label: 'isHidden — মাসিক লক',
//                 desc:
//                     'মাসে একবার লুকালে সেই মাসে আর ফিরে আসা যাবে না। পরের মাস থেকে visible হবে।',
//                 badge: 'মাসিক লক',
//                 badgeColor: _C.rose,
//                 badgeBg: _C.roseLight,
//                 isFirst: true,
//               ),
//               const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//               _PrivacyRow(
//                 emoji: '👤',
//                 label: 'showAnonymous — তাৎক্ষণিক',
//                 desc:
//                     'চালু করলে নাম "Anonymous" ও avatar লুকাবে। যেকোনো সময় পরিবর্তন করা যাবে।',
//                 badge: 'লক নেই',
//                 badgeColor: _C.purple,
//                 badgeBg: _C.purpleLight,
//               ),
//               const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//               _PrivacyRow(
//                 emoji: '🚫',
//                 label: 'isPermanent — স্থায়ী অপ্ট-আউট',
//                 desc:
//                     'সম্পূর্ণভাবে লিডারবোর্ড থেকে বের হওয়া। লক নেই, যেকোনো সময় toggle করা যাবে।',
//                 badge: 'লক নেই',
//                 badgeColor: _C.textSecondary,
//                 badgeBg: _C.bg,
//                 isLast: true,
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: _C.purpleLight,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//                 color: _C.purple.withOpacity(0.2), width: 0.5),
//           ),
//           child: const Row(
//             children: [
//               Text('📸', style: TextStyle(fontSize: 14)),
//               SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   'privacy snapshot মাসিকভাবে সংরক্ষিত হয়। পরে privacy পরিবর্তন করলে পূর্ববর্তী মাসের র‍্যাংকিং প্রভাবিত হয় না।',
//                   style: TextStyle(
//                     color: Color(0xFF4C1D95),
//                     fontSize: 11.5,
//                     height: 1.5,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _PrivacyRow extends StatelessWidget {
//   final String emoji, label, desc, badge;
//   final Color badgeColor, badgeBg;
//   final bool isFirst, isLast;

//   const _PrivacyRow({
//     required this.emoji,
//     required this.label,
//     required this.desc,
//     required this.badge,
//     required this.badgeColor,
//     required this.badgeBg,
//     this.isFirst = false,
//     this.isLast = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.vertical(
//           top: isFirst ? const Radius.circular(16) : Radius.zero,
//           bottom: isLast ? const Radius.circular(16) : Radius.zero,
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(emoji, style: const TextStyle(fontSize: 20)),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(label,
//                           style: const TextStyle(
//                               color: _C.textPrimary,
//                               fontSize: 13,
//                               fontWeight: FontWeight.w700)),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 3),
//                       decoration: BoxDecoration(
//                         color: badgeBg,
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(
//                             color: badgeColor.withOpacity(0.25),
//                             width: 0.5),
//                       ),
//                       child: Text(
//                         badge,
//                         style: TextStyle(
//                           color: badgeColor,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   desc,
//                   style: const TextStyle(
//                     color: _C.textSecondary,
//                     fontSize: 11.5,
//                     height: 1.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PROFILE SHARE CARD — NEW
// // ─────────────────────────────────────────────────────────────────────────────

// class _ProfileShareCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: _C.card,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: _C.border, width: 0.5),
//           ),
//           child: Column(
//             children: [
//               _ModeRow(
//                 emoji: '🔓',
//                 label: 'shareProfile.isPublic = true',
//                 desc: 'যে কেউ আপনার মাসিক বিস্তারিত আমল দেখতে পারবেন',
//                 badge: 'Public',
//                 badgeColor: _C.blue,
//                 badgeBg: _C.blueLight,
//                 isFirst: true,
//               ),
//               const Divider(height: 0.5, thickness: 0.5, color: _C.border),
//               _ModeRow(
//                 emoji: '🔒',
//                 label: 'shareProfile.isPublic = false',
//                 desc: 'শুধু নিজে দেখতে পাবেন',
//                 badge: 'Private',
//                 badgeColor: _C.textHint,
//                 badgeBg: _C.bg,
//                 isLast: true,
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         const _InfoNote(
//           text:
//               'লিডারবোর্ডে থাকলেও বিস্তারিত আমল সর্বদা গোপন। শুধু shareProfile চালু করলেই অন্যরা মাসিক এন্ট্রি দেখতে পারবেন।',
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // FEMALE EXEMPT CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _FemaleExemptCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFFF0F5),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//             color: _C.pink.withOpacity(0.3), width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 44,
//                 height: 44,
//                 decoration: BoxDecoration(
//                   color: _C.pink.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Center(
//                   child: Text('🌸', style: TextStyle(fontSize: 22)),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'মাহলির দিন চালু করুন',
//                       style: TextStyle(
//                         color: Color(0xFF9D174D),
//                         fontSize: 14,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                     Text(
//                       'আমল রেকর্ড করার সময় সালাত বিভাগে পাবেন',
//                       style: TextStyle(
//                         color: Color(0xFFBE185D),
//                         fontSize: 11,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 14),
//           _ExemptStep(
//               number: '১',
//               text: 'সালাত বিভাগে "আজ কি মাহলি আছেন?" টগল চালু করুন'),
//           const SizedBox(height: 8),
//           _ExemptStep(
//               number: '২',
//               text:
//                   'ফরজ আমলগুলো (isFard = true) স্বয়ংক্রিয়ভাবে completed = false হিসেবে সংরক্ষিত হবে'),
//           const SizedBox(height: 8),
//           _ExemptStep(
//               number: '৩',
//               text:
//                   'নফল ও সুন্নাহ আমল স্বাভাবিকভাবেই রেকর্ড ও পয়েন্ট পাবেন'),
//           const SizedBox(height: 8),
//           _ExemptStep(
//               number: '৪',
//               text:
//                   'এই দিনগুলো eligibleDays থেকে বাদ যাবে — completionPercentage-এ কোনো নেতিবাচক প্রভাব নেই'),
//           const SizedBox(height: 8),
//           _ExemptStep(
//               number: '৫',
//               text:
//                   'স্ট্রিক গণনায় মাহলির দিন ভাঙে না — সক্রিয় দিন হিসেবে গণ্য'),
//           const SizedBox(height: 12),
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                   color: _C.pink.withOpacity(0.15), width: 0.5),
//             ),
//             child: const Row(
//               children: [
//                 Text('💡', style: TextStyle(fontSize: 14)),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'মাহলির দিনগুলো র‍্যাংকিং-এ কোনো নেতিবাচক প্রভাব ফেলে না। ফরজ আমল মাফ, বাকি আমলের পয়েন্ট স্বাভাবিক।',
//                     style: TextStyle(
//                       color: Color(0xFF9D174D),
//                       fontSize: 11,
//                       height: 1.5,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ExemptStep extends StatelessWidget {
//   final String number, text;
//   const _ExemptStep({required this.number, required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 22,
//           height: 22,
//           decoration: BoxDecoration(
//             color: _C.pink.withOpacity(0.15),
//             shape: BoxShape.circle,
//           ),
//           child: Center(
//             child: Text(
//               number,
//               style: const TextStyle(
//                 color: Color(0xFF9D174D),
//                 fontSize: 11,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             text,
//             style: const TextStyle(
//               color: Color(0xFF9D174D),
//               fontSize: 12,
//               height: 1.5,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // TIPS CARD
// // ─────────────────────────────────────────────────────────────────────────────

// class _TipsCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     const tips = [
//       _Tip(
//           emoji: '📅',
//           text:
//               'প্রতিদিন রেকর্ড করুন — একদিন বাদ পড়লে সেই দিনের পয়েন্ট যোগ হয় না এবং স্ট্রিক ভাঙে'),
//       _Tip(
//           emoji: '🕌',
//           text:
//               'জামাতে নামাজ পড়লে একাকীর চেয়ে বেশি পয়েন্ট — র‍্যাংকিংয়ে বড় পার্থক্য হতে পারে'),
//       _Tip(
//           emoji: '✅',
//           text:
//               'completionPercentage বাড়াতে ফরজ আমলে মনোযোগ দিন — এটাই প্রধান র‍্যাংকিং মানদণ্ড'),
//       _Tip(
//           emoji: '🔢',
//           text:
//               'গণনার আমলে যত বেশি করবেন তত বেশি পয়েন্ট — totalPoints বাড়বে, টাই-ব্রেকে কাজে আসবে'),
//       _Tip(
//           emoji: '🏆',
//           text:
//               'মাসের শেষ দিন পর্যন্ত র‍্যাংকিং পরিবর্তন হতে পারে — হাল ছাড়বেন না'),
//     ];

//     return Container(
//       decoration: BoxDecoration(
//         color: _C.purpleLight,
//         borderRadius: BorderRadius.circular(16),
//         border:
//             Border.all(color: _C.purple.withOpacity(0.25), width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
//             child: Row(
//               children: const [
//                 Text('💡', style: TextStyle(fontSize: 16)),
//                 SizedBox(width: 8),
//                 Text(
//                   'দরকারি টিপস',
//                   style: TextStyle(
//                     color: _C.purple,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(
//               height: 0.5, thickness: 0.5, color: Color(0xFFDDD6FE)),
//           ...tips.asMap().entries.map((e) {
//             final t = e.value;
//             final isLast = e.key == tips.length - 1;
//             return Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 14, vertical: 11),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(t.emoji,
//                           style: const TextStyle(fontSize: 15)),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Text(
//                           t.text,
//                           style: const TextStyle(
//                             color: _C.purple,
//                             fontSize: 12,
//                             height: 1.5,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (!isLast)
//                   const Divider(
//                       height: 0.5,
//                       thickness: 0.5,
//                       color: Color(0xFFDDD6FE),
//                       indent: 40),
//               ],
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }

// class _Tip {
//   final String emoji, text;
//   const _Tip({required this.emoji, required this.text});
// }

import 'package:amal_tracker/features/user/widgets/app_silver_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────

class _C {
  static const bg = Color(0xFFF4F6F1);
  static const card = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFFFF8E7);
  static const amber = Color(0xFFF59E0B);
  static const amberLight = Color(0xFFFFF3E0);
  static const blue = Color(0xFF0891B2);
  static const blueLight = Color(0xFFE0F2FE);
  static const teal = Color(0xFF0D9488);
  static const tealLight = Color(0xFFCCFBF1);
  static const purple = Color(0xFF7C3AED);
  static const purpleLight = Color(0xFFEDE9FE);
  static const rose = Color(0xFFE11D48);
  static const roseLight = Color(0xFFFFE4E6);
  static const pink = Color(0xFFDB2777);
  static const border = Color(0xFFE4EAE4);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSec = Color(0xFF4E6357);
  static const textHint = Color(0xFFABBAAE);
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class HowItWorksScreen extends ConsumerStatefulWidget {
  const HowItWorksScreen({super.key});

  @override
  ConsumerState<HowItWorksScreen> createState() => _State();
}

class _State extends ConsumerState<HowItWorksScreen> {
  late final ScrollController _sc;

  @override
  void initState() {
    super.initState();
    _sc = ScrollController();
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isFemale = user?.gender?.toLowerCase() == 'female';
    final w = MediaQuery.of(context).size.width;
    final hPad = w > 600 ? (w - 600) / 2 + 20.0 : 20.0;

    return Scaffold(
      backgroundColor: _C.bg,
      body: CustomScrollView(
        controller: _sc,
        physics: const BouncingScrollPhysics(),
        slivers: [
          AppSliverBar(
            scrollController: _sc,
            title: 'কীভাবে কাজ করে?',
            subtitle: 'পয়েন্ট ও র‍্যাংকিং পদ্ধতি',
            icon: Icons.trending_up_rounded,
            color: _C.darkGreen,
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 60),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ① পয়েন্ট কীভাবে পাবেন
                _SectionHeader(emoji: '⭐', title: 'পয়েন্ট কীভাবে পাবেন')
                    .animate()
                    .fadeIn(duration: 260.ms),
                const SizedBox(height: 10),
                _PointsCard().animate().fadeIn(delay: 60.ms),
                const SizedBox(height: 24),

                // ② মাসিক সম্পূর্ণতা
                _SectionHeader(emoji: '📊', title: 'মাসিক সম্পূর্ণতার হার')
                    .animate()
                    .fadeIn(delay: 80.ms),
                const SizedBox(height: 10),
                _CompletionCard().animate().fadeIn(delay: 100.ms),
                const SizedBox(height: 24),

                // ③ র‍্যাংকিং কীভাবে হয়
                _SectionHeader(emoji: '🏆', title: 'র‍্যাংকিং কীভাবে হয়')
                    .animate()
                    .fadeIn(delay: 120.ms),
                const SizedBox(height: 10),
                _RankingCard().animate().fadeIn(delay: 140.ms),
                const SizedBox(height: 24),

                // ③.৫ নামাজ ও লিডারবোর্ড — নতুন section 👈
                _SectionHeader(
                  emoji: '🕌',
                  title: 'নামাজ ও লিডারবোর্ড',
                  accentColor: _C.teal,
                ).animate().fadeIn(delay: 155.ms),
                const SizedBox(height: 10),
                _PrayerFairnessCard(isFemale: isFemale)
                    .animate()
                    .fadeIn(delay: 165.ms),
                const SizedBox(height: 24),

                // মাহলির দিন — শুধু মহিলার জন্য
                if (isFemale) ...[
                  _SectionHeader(
                    emoji: '🌸',
                    title: 'মাহলির দিন',
                    accentColor: _C.pink,
                  ).animate().fadeIn(delay: 160.ms),
                  const SizedBox(height: 10),
                  _FemaleExemptCard().animate().fadeIn(delay: 180.ms),
                  const SizedBox(height: 24),
                ],

                // ⑤ এগিয়ে থাকার টিপস
                _TipsCard().animate().fadeIn(delay: 200.ms),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String emoji, title;
  final Color? accentColor;

  const _SectionHeader({
    required this.emoji,
    required this.title,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? _C.darkGreen;
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.09),
            borderRadius: BorderRadius.circular(10),
          ),
          child:
              Center(child: Text(emoji, style: const TextStyle(fontSize: 17))),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ① POINTS CARD
// ─────────────────────────────────────────────────────────────────────────────

class _PointsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Namaz row — special because has 3 levels
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _C.goldLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.gold.withOpacity(0.35), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text('🕌', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 8),
                  Text(
                    'নামাজ',
                    style: TextStyle(
                      color: Color(0xFF78350F),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NamazLevel(
                  label: 'জামাতে পড়লে',
                  badge: 'সর্বোচ্চ পয়েন্ট',
                  badgeColor: _C.green,
                  badgeBg: _C.greenLight),
              const SizedBox(height: 6),
              _NamazLevel(
                  label: 'একাকী পড়লে',
                  badge: 'কম পয়েন্ট',
                  badgeColor: _C.amber,
                  badgeBg: _C.amberLight),
              const SizedBox(height: 6),
              _NamazLevel(
                  label: 'পড়া না হলে',
                  badge: '০ পয়েন্ট',
                  badgeColor: _C.textHint,
                  badgeBg: _C.bg),
            ],
          ),
        ).animate(delay: 40.ms).fadeIn().slideY(begin: 0.04),

        const SizedBox(height: 8),

        // Other amal
        Row(
          children: [
            Expanded(
              child: _SimplePointBox(
                emoji: '✅',
                title: 'অন্য আমল',
                desc: 'করলে পয়েন্ট পাবেন\nনা করলে ০',
                bg: _C.greenLight,
                borderColor: _C.green,
                textColor: _C.darkGreen,
                delay: 80,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SimplePointBox(
                emoji: '🔢',
                title: 'গণনার আমল',
                desc: 'যত বেশি করবেন\nতত বেশি পয়েন্ট',
                bg: _C.blueLight,
                borderColor: _C.blue,
                textColor: const Color(0xFF0C4A6E),
                delay: 120,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NamazLevel extends StatelessWidget {
  final String label, badge;
  final Color badgeColor, badgeBg;
  const _NamazLevel({
    required this.label,
    required this.badge,
    required this.badgeColor,
    required this.badgeBg,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF92400E), fontSize: 12.5),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
            color: badgeBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: badgeColor.withOpacity(0.3), width: 0.5),
          ),
          child: Text(
            badge,
            style: TextStyle(
              color: badgeColor,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _SimplePointBox extends StatelessWidget {
  final String emoji, title, desc;
  final Color bg, borderColor, textColor;
  final int delay;

  const _SimplePointBox({
    required this.emoji,
    required this.title,
    required this.desc,
    required this.bg,
    required this.borderColor,
    required this.textColor,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(title,
              style: TextStyle(
                  color: textColor, fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(desc,
              style: TextStyle(
                  color: textColor.withOpacity(0.7),
                  fontSize: 11.5,
                  height: 1.45)),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn()
        .slideY(begin: 0.04);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ② MONTHLY COMPLETION CARD
// ─────────────────────────────────────────────────────────────────────────────

class _CompletionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main explanation
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _C.tealLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _C.teal.withOpacity(0.3), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'মাসের ফরজ আমলগুলো কতটা পালন করেছেন — সেই হিসাবে এই % তৈরি হয়',
                style: TextStyle(
                  color: Color(0xFF085041),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 14),

              // Example
              const Text(
                'উদাহরণ',
                style: TextStyle(
                  color: _C.teal,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _ExampleRow(
                        label: 'মাসে মোট দিন অতিবাহিত', value: '২২ দিন'),
                    const SizedBox(height: 6),
                    _ExampleRow(
                        label: 'সব ফরজ সম্পন্ন হয়েছে', value: '১৮ দিন'),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                          height: 0.5, thickness: 0.5, color: _C.border),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'সম্পূর্ণতার হার',
                          style: TextStyle(
                            color: Color(0xFF085041),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _C.teal,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '৮২%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: 0.82,
                        minHeight: 7,
                        backgroundColor: _C.tealLight,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(_C.teal),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Key rule box
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.border, width: 0.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('💡', style: TextStyle(fontSize: 15)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'একদিন সব ফরজ পালন করলেই সেই দিন গণনায় আসে। শুধু কিছু পড়লে হবে না — সব ফরজ লাগবে।',
                  style: TextStyle(
                    color: _C.textSec,
                    fontSize: 12,
                    height: 1.55,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExampleRow extends StatelessWidget {
  final String label, value;
  const _ExampleRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: _C.textSec, fontSize: 12)),
        Text(value,
            style: const TextStyle(
                color: _C.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ③ RANKING CARD
// ─────────────────────────────────────────────────────────────────────────────

class _RankingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // How rank is determined — 3 steps
        Container(
          decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _C.border, width: 0.5),
          ),
          child: Column(
            children: [
              _RankStepRow(
                step: '১',
                stepBg: _C.tealLight,
                stepColor: _C.teal,
                title: 'ফরজ সম্পূর্ণতার হার',
                desc: 'যার হার বেশি সে এগিয়ে — এটাই প্রধান মানদণ্ড',
                isFirst: true,
              ),
              const Divider(height: 0.5, thickness: 0.5, color: _C.border),
              _RankStepRow(
                step: '২',
                stepBg: _C.blueLight,
                stepColor: _C.blue,
                title: 'মোট পয়েন্ট',
                desc: 'হার সমান হলে যার পয়েন্ট বেশি সে এগিয়ে',
              ),
              const Divider(height: 0.5, thickness: 0.5, color: _C.border),
              _RankStepRow(
                step: '৩',
                stepBg: _C.roseLight,
                stepColor: _C.rose,
                title: 'ধারাবাহিকতা',
                desc:
                    'উপরের দুটো সমান হলে যে বেশি দিন ধারাবাহিকভাবে রেকর্ড করেছেন সে এগিয়ে',
                isLast: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Monthly winners
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _C.goldLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.gold.withOpacity(0.35), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text('🥇', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Text(
                    'মাসিক বিজয়ী — তিনটি বিভাগ',
                    style: TextStyle(
                      color: Color(0xFF78350F),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _WinnerLine(emoji: '🥇', text: 'সর্বোচ্চ ফরজ সম্পূর্ণতার হার'),
              const SizedBox(height: 6),
              _WinnerLine(emoji: '💪', text: 'সর্বোচ্চ মোট পয়েন্ট'),
              const SizedBox(height: 6),
              _WinnerLine(emoji: '🔥', text: 'সর্বোচ্চ ধারাবাহিকতা'),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Notes
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.border, width: 0.5),
          ),
          child: Column(
            children: const [
              _Note(
                  text:
                      'প্রতি মাসে আলাদা র‍্যাংকিং — আগের মাসের হিসাব নতুন মাসে নেই'),
              SizedBox(height: 6),
              _Note(
                  text:
                      'লিডারবোর্ডে শুধু মাসের সামগ্রিক স্কোর দেখা যায় — আপনার বিস্তারিত আমল গোপন থাকে'),
              SizedBox(height: 6),
              _Note(
                  text:
                      'চাইলে Settings থেকে নিজেকে লিডারবোর্ড থেকে লুকিয়ে রাখতে পারবেন'),
            ],
          ),
        ),
      ],
    );
  }
}

class _RankStepRow extends StatelessWidget {
  final String step, title, desc;
  final Color stepBg, stepColor;
  final bool isFirst, isLast;

  const _RankStepRow({
    required this.step,
    required this.stepBg,
    required this.stepColor,
    required this.title,
    required this.desc,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(16) : Radius.zero,
          bottom: isLast ? const Radius.circular(16) : Radius.zero,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: stepBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step,
                style: TextStyle(
                  color: stepColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: _C.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(desc,
                    style: const TextStyle(
                        color: _C.textSec, fontSize: 11.5, height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WinnerLine extends StatelessWidget {
  final String emoji, text;
  const _WinnerLine({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF92400E),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _Note extends StatelessWidget {
  final String text;
  const _Note({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.only(top: 6, right: 8),
          decoration: const BoxDecoration(
            color: _C.textHint,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style:
                const TextStyle(color: _C.textSec, fontSize: 12, height: 1.5),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ④ FEMALE EXEMPT CARD — only shown to female users
// ─────────────────────────────────────────────────────────────────────────────

class _FemaleExemptCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.pink.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🌸', style: TextStyle(fontSize: 22)),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'মাহলির দিন চালু করলে কী হয়?',
                      style: TextStyle(
                        color: Color(0xFF9D174D),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'আমল রেকর্ড করার সময় এই অপশন পাবেন',
                      style: TextStyle(color: Color(0xFFBE185D), fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _ExemptPoint(
              text: 'সেই দিনের ফরজ নামাজ মাফ হিসেবে চিহ্নিত হয়, পয়েন্ট ০'),
          const SizedBox(height: 7),
          _ExemptPoint(
              text: 'নফল ও সুন্নাহ আমল স্বাভাবিকভাবেই রেকর্ড ও পয়েন্ট পাবেন'),
          const SizedBox(height: 7),
          _ExemptPoint(
              text:
                  'মাসিক সম্পূর্ণতার হারে এই দিনগুলো বাদ দিয়ে হিসাব হয় — র‍্যাংকিংয়ে কোনো ক্ষতি নেই'),
          const SizedBox(height: 7),
          _ExemptPoint(text: 'ধারাবাহিকতার গণনায়ও এই দিন ভাঙে না'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _C.pink.withOpacity(0.15), width: 0.5),
            ),
            child: const Row(
              children: [
                Text('💡', style: TextStyle(fontSize: 14)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'মাহলির দিনগুলো র‍্যাংকিংয়ে কোনো নেতিবাচক প্রভাব ফেলে না।',
                    style: TextStyle(
                      color: Color(0xFF9D174D),
                      fontSize: 11.5,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExemptPoint extends StatelessWidget {
  final String text;
  const _ExemptPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.only(top: 5, right: 9),
          decoration: BoxDecoration(
            color: _C.pink.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF9D174D),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ⑤ TIPS CARD
// ─────────────────────────────────────────────────────────────────────────────

class _TipsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const tips = [
      _Tip(
          emoji: '✅',
          text: 'ফরজ আমলে মনোযোগ দিন — এটাই র‍্যাংকিংয়ের প্রধান মানদণ্ড'),
      _Tip(
          emoji: '🕌',
          text: 'জামাতে নামাজ পড়লে একাকীর চেয়ে বেশি পয়েন্ট পাবেন'),
      _Tip(
          emoji: '📅',
          text: 'প্রতিদিন রেকর্ড করুন — একদিন বাদ পড়লে ধারাবাহিকতা ভাঙে'),
      _Tip(
          emoji: '🔢',
          text: 'গণনার আমলে যত বেশি করবেন তত পয়েন্ট — কোনো সীমা নেই'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: _C.purpleLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.purple.withOpacity(0.25), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Row(
              children: const [
                Text('💡', style: TextStyle(fontSize: 15)),
                SizedBox(width: 8),
                Text(
                  'এগিয়ে থাকার টিপস',
                  style: TextStyle(
                    color: _C.purple,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0.5, thickness: 0.5, color: Color(0xFFDDD6FE)),
          ...tips.asMap().entries.map((e) {
            final isLast = e.key == tips.length - 1;
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.value.emoji, style: const TextStyle(fontSize: 15)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          e.value.text,
                          style: const TextStyle(
                            color: _C.purple,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  const Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: Color(0xFFDDD6FE),
                      indent: 40),
              ],
            );
          }),
        ],
      ),
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
// ③.৫ PRAYER FAIRNESS CARD
// ─────────────────────────────────────────────────────────────────────────────

class _PrayerFairnessCard extends StatelessWidget {
  final bool isFemale;
  const _PrayerFairnessCard({required this.isFemale});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main explanation box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _C.tealLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _C.teal.withOpacity(0.3), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'নামাজের পয়েন্ট দুটো কাজে ব্যবহার হয়',
                style: TextStyle(
                  color: Color(0xFF085041),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),

              // Personal points row
              _FairnessRow(
                emoji: '👤',
                label: 'ব্যক্তিগত পয়েন্ট',
                desc:
                    'জামাতে পড়লে বেশি পয়েন্ট, একাকী পড়লে কম — আসল সওয়াব অনুযায়ী',
                bg: _C.greenLight,
                borderColor: _C.green,
                textColor: _C.darkGreen,
              ),
              const SizedBox(height: 8),

              // Leaderboard points row
              _FairnessRow(
                emoji: '🏆',
                label: 'লিডারবোর্ড র‍্যাংকিং',
                desc: 'সবার নামাজ সমান গণনা হয় — জামাত বা একাকী যাই হোক',
                bg: _C.blueLight,
                borderColor: _C.blue,
                textColor: const Color(0xFF0C4A6E),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Gender specific explanation
        if (isFemale) _FemaleExplanationBox() else _MaleExplanationBox(),

        const SizedBox(height: 8),

        // Why box
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.border, width: 0.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('⚖️', style: TextStyle(fontSize: 15)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'ইসলামি বিধান অনুযায়ী পুরুষ ও নারীর নামাজের নিয়ম আলাদা। '
                  'তাই র‍্যাংকিংয়ে সবার জন্য সমান সুযোগ নিশ্চিত করা হয়েছে।',
                  style: TextStyle(
                    color: _C.textSec,
                    fontSize: 12,
                    height: 1.55,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FairnessRow extends StatelessWidget {
  final String emoji, label, desc;
  final Color bg, borderColor, textColor;

  const _FairnessRow({
    required this.emoji,
    required this.label,
    required this.desc,
    required this.bg,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: TextStyle(
                    color: textColor.withOpacity(0.75),
                    fontSize: 11.5,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MaleExplanationBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _C.goldLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.gold.withOpacity(0.35), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🕌', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text(
                'আপনার জন্য কীভাবে কাজ করে',
                style: TextStyle(
                  color: Color(0xFF78350F),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _CompareRow(
            label: 'জামাতে পড়লে',
            personal: 'বেশি পয়েন্ট ✅',
            leaderboard: 'সমান গণনা',
            personalColor: _C.green,
          ),
          const SizedBox(height: 6),
          _CompareRow(
            label: 'একাকী পড়লে',
            personal: 'কম পয়েন্ট',
            leaderboard: 'সমান গণনা',
            personalColor: _C.amber,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Row(
              children: [
                Text('💡', style: TextStyle(fontSize: 13)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'জামাতে পড়লে ব্যক্তিগত পয়েন্ট বেশি পাবেন, '
                    'কিন্তু র‍্যাংকিংয়ে সবার নামাজ সমান — তাই অন্য আমলেও মনোযোগ দিন।',
                    style: TextStyle(
                      color: Color(0xFF92400E),
                      fontSize: 11.5,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FemaleExplanationBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.pink.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🌸', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text(
                'আপনার জন্য কীভাবে কাজ করে',
                style: TextStyle(
                  color: Color(0xFF9D174D),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _ExemptPoint(
              text:
                  'ইসলামে নারীর জন্য ঘরে নামাজ পড়াই উত্তম — জামাত বাধ্যতামূলক নয়'),
          const SizedBox(height: 6),
          _ExemptPoint(
              text:
                  'তাই আপনার নামাজ র‍্যাংকিংয়ে পুরুষের জামাতের সমান পয়েন্ট পাবে'),
          const SizedBox(height: 6),
          _ExemptPoint(text: 'ব্যক্তিগত স্কোরে আপনার আসল পয়েন্টই দেখাবে'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Row(
              children: [
                Text('💡', style: TextStyle(fontSize: 13)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'আপনি ঘরে নামাজ পড়লেও র‍্যাংকিংয়ে কোনো অসুবিধা নেই — '
                    'সবার সাথে সমান প্রতিযোগিতা করতে পারবেন।',
                    style: TextStyle(
                      color: Color(0xFF9D174D),
                      fontSize: 11.5,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompareRow extends StatelessWidget {
  final String label, personal, leaderboard;
  final Color personalColor;

  const _CompareRow({
    required this.label,
    required this.personal,
    required this.leaderboard,
    required this.personalColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF92400E), fontSize: 12),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            personal,
            style: TextStyle(
              color: personalColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            leaderboard,
            style: const TextStyle(
              color: Color(0xFF92400E),
              fontSize: 11.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _Tip {
  final String emoji, text;
  const _Tip({required this.emoji, required this.text});
}
