// // lib/features/onboarding/onboarding_screen.dart

// import 'dart:math' as math;
// import 'package:amal_tracker/core/router/app_router.dart';
// import 'package:amal_tracker/features/onboarding/provider/onboarding_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// // ── Color palette matching your app ───────────────────────────────────────
// class _C {
//   static const darkGreen = Color(0xFF033019);
//   static const green = Color(0xFF1B6B3A);
//   static const greenMid = Color(0xFF2D8A52);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const greenAccent = Color(0xFF4CAF78);
//   static const gold = Color(0xFFF5C842);
//   static const goldLight = Color(0xFFFFF8DC);
//   static const white = Colors.white;
//   static const textPrimary = Color(0xFF0D2B1A);
//   static const textSecondary = Color(0xFF5A7A67);
//   static const bg = Color(0xFFF4FAF6);
// }

// // ── Page data ─────────────────────────────────────────────────────────────
// class _PageData {
//   final String arabicText;
//   final String arabicSource;
//   final String title;
//   final String subtitle;
//   final _IllustrationPainter Function(double) painterBuilder;
//   final Color bgFrom;
//   final Color bgTo;

//   const _PageData({
//     required this.arabicText,
//     required this.arabicSource,
//     required this.title,
//     required this.subtitle,
//     required this.painterBuilder,
//     required this.bgFrom,
//     required this.bgTo,
//   });
// }

// // ── Main Screen ────────────────────────────────────────────────────────────
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen>
//     with TickerProviderStateMixin {
//   final _pageController = PageController();
//   int _currentPage = 0;
//   bool _isLastPage = false;

//   late final AnimationController _fadeCtrl;
//   late final AnimationController _floatCtrl;
//   late final Animation<double> _fadeAnim;
//   late final Animation<double> _floatAnim;

//   static const _pages = [
//     _PageData(
//       arabicText: 'إِنَّ اللَّهَ لَا يُضِيعُ أَجْرَ الْمُحْسِنِينَ',
//       arabicSource: 'সূরা তাওবাহ ৯:১২০',
//       title: 'নেক আমলের\nহিসাব রাখো',
//       subtitle:
//           'Sabeq তোমার প্রতিদিনের আমল — নামাজ, কোরআন, যিকির সব কিছু সহজে ট্র্যাক করতে সাহায্য করে।',
//       painterBuilder: _MosquePainter.new,
//       bgFrom: Color(0xFF033019),
//       bgTo: Color(0xFF0D4A28),
//     ),
//     _PageData(
//       arabicText: 'وَذَكِّرْ فَإِنَّ الذِّكْرَى تَنفَعُ الْمُؤْمِنِينَ',
//       arabicSource: 'সূরা আয-যারিয়াত ৫১:৫৫',
//       title: 'প্রতিদিনের\nরুটিন গড়ো',
//       subtitle:
//           'ফরজ, সুন্নাহ, নফল — সব আমলের জন্য আলাদা ক্যাটাগরি। প্রতিটা দিন আরও ভালো হোক।',
//       painterBuilder: _TrackerPainter.new,
//       bgFrom: Color(0xFF0A3D22),
//       bgTo: Color(0xFF155230),
//     ),
//     _PageData(
//       arabicText: 'وَفِي ذَٰلِكَ فَلْيَتَنَافَسِ الْمُتَنَافِسُونَ',
//       arabicSource: 'সূরা আল-মুতাফফিফীন ৮৩:২৬',
//       title: 'নেক আমলে\nএগিয়ে থাকো',
//       subtitle:
//           'বন্ধু ও পরিবারের সাথে লিডারবোর্ডে প্রতিযোগিতা করো — দুনিয়ার সেরা প্রতিযোগিতায়।',
//       painterBuilder: _LeaderboardPainter.new,
//       bgFrom: Color(0xFF1B5E35),
//       bgTo: Color(0xFF267044),
//     ),
//     _PageData(
//       arabicText:
//           'وَبَشِّرِ الْمُؤْمِنِينَ بِأَنَّ لَهُم مِّنَ اللَّهِ فَضْلًا كَبِيرًا',
//       arabicSource: 'সূরা আল-আহযাব ৩৩:৪৭',
//       title: 'জান্নাতের বাগান\nসাজাও',
//       subtitle:
//           'আমলের পয়েন্ট দিয়ে তোমার জান্নাতের বাগান তৈরি করো। প্রতিটা আমল একটা বীজ।',
//       painterBuilder: _GardenPainter.new,
//       bgFrom: Color(0xFF0D4A28),
//       bgTo: Color(0xFF1A7040),
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _fadeCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//     _floatCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     )..repeat(reverse: true);

//     _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
//     _floatAnim = CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut);

//     _fadeCtrl.forward();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _fadeCtrl.dispose();
//     _floatCtrl.dispose();
//     super.dispose();
//   }

//   void _onPageChanged(int index) {
//     _fadeCtrl.reset();
//     _fadeCtrl.forward();
//     setState(() {
//       _currentPage = index;
//       _isLastPage = index == _pages.length - 1;
//     });
//   }

//   Future<void> _complete() async {
//     await markOnboardingSeen();
//     onboardingSeenNotifier.value = true;
//     if (mounted) context.go(AppRoutes.login);
//   }

//   void _nextPage() {
//     _pageController.nextPage(
//       duration: const Duration(milliseconds: 450),
//       curve: Curves.easeInOutCubic,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final page = _pages[_currentPage];

//     return Scaffold(
//       backgroundColor: page.bgFrom,
//       body: AnimatedContainer(
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [page.bgFrom, page.bgTo],
//           ),
//         ),
//         child: Stack(
//           children: [
//             // ── Decorative background pattern ──────────────────────────
//             Positioned.fill(child: _GeometricPattern()),

//             // ── Page content ───────────────────────────────────────────
//             PageView.builder(
//               controller: _pageController,
//               onPageChanged: _onPageChanged,
//               itemCount: _pages.length,
//               itemBuilder: (context, index) {
//                 return _OnboardingPage(
//                   data: _pages[index],
//                   floatAnim: _floatAnim,
//                   fadeAnim: _fadeAnim,
//                   size: size,
//                 );
//               },
//             ),

//             // ── Top: Skip button ───────────────────────────────────────
//             SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 8,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Logo mark
//                     Row(
//                       children: [
//                         Container(
//                           width: 32,
//                           height: 32,
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               'س',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         const Text(
//                           'Sabeq',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                       ],
//                     ),
//                     // Skip
//                     AnimatedOpacity(
//                       opacity: _isLastPage ? 0 : 1,
//                       duration: const Duration(milliseconds: 300),
//                       child: GestureDetector(
//                         onTap: _isLastPage ? null : _complete,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 14,
//                             vertical: 7,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                               color: Colors.white.withOpacity(0.3),
//                             ),
//                           ),
//                           child: const Text(
//                             'Skip',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // ── Bottom: Dots + CTA ─────────────────────────────────────
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               child: _BottomControls(
//                 currentPage: _currentPage,
//                 totalPages: _pages.length,
//                 isLastPage: _isLastPage,
//                 onNext: _nextPage,
//                 onComplete: _complete,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Single Onboarding Page ─────────────────────────────────────────────────
// class _OnboardingPage extends StatelessWidget {
//   final _PageData data;
//   final Animation<double> floatAnim;
//   final Animation<double> fadeAnim;
//   final Size size;

//   const _OnboardingPage({
//     required this.data,
//     required this.floatAnim,
//     required this.fadeAnim,
//     required this.size,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // ── Illustration area (top ~52%) ───────────────────────────────
//         Expanded(
//           flex: 52,
//           child: Padding(
//             padding: const EdgeInsets.only(top: 90),
//             child: AnimatedBuilder(
//               animation: floatAnim,
//               builder: (context, child) {
//                 final offset = (floatAnim.value - 0.5) * 14;
//                 return Transform.translate(
//                   offset: Offset(0, offset),
//                   child: child,
//                 );
//               },
//               child: CustomPaint(
//                 painter: data.painterBuilder(1.0),
//                 size: Size(size.width * 0.8, size.width * 0.8),
//               ),
//             ),
//           ),
//         ),

//         // ── Text area (bottom ~48%) ────────────────────────────────────
//         Expanded(
//           flex: 48,
//           child: FadeTransition(
//             opacity: fadeAnim,
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(28, 16, 28, 110),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Arabic ayat
//                   Container(
//                     padding: const EdgeInsets.all(14),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.08),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: _C.gold.withOpacity(0.4),
//                         width: 1,
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           data.arabicText,
//                           textAlign: TextAlign.right,
//                           style: const TextStyle(
//                             color: _C.gold,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                             height: 1.7,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           data.arabicSource,
//                           textAlign: TextAlign.right,
//                           style: TextStyle(
//                             color: _C.gold.withOpacity(0.7),
//                             fontSize: 11,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // Title
//                   Text(
//                     data.title,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 28,
//                       fontWeight: FontWeight.w800,
//                       height: 1.25,
//                       letterSpacing: -0.5,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   // Subtitle
//                   Text(
//                     data.subtitle,
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.75),
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       height: 1.65,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ── Bottom Controls ────────────────────────────────────────────────────────
// class _BottomControls extends StatelessWidget {
//   final int currentPage;
//   final int totalPages;
//   final bool isLastPage;
//   final VoidCallback onNext;
//   final VoidCallback onComplete;

//   const _BottomControls({
//     required this.currentPage,
//     required this.totalPages,
//     required this.isLastPage,
//     required this.onNext,
//     required this.onComplete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(
//         28,
//         20,
//         28,
//         MediaQuery.of(context).padding.bottom + 24,
//       ),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             Colors.transparent,
//             Colors.black.withOpacity(0.25),
//           ],
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Dots
//           Row(
//             children: List.generate(totalPages, (i) {
//               final active = i == currentPage;
//               return AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.easeInOut,
//                 margin: const EdgeInsets.only(right: 6),
//                 width: active ? 24 : 8,
//                 height: 8,
//                 decoration: BoxDecoration(
//                   color: active ? Colors.white : Colors.white.withOpacity(0.35),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               );
//             }),
//           ),

//           // Next / Complete button
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 300),
//             child: isLastPage
//                 ? _GetStartedButton(onTap: onComplete)
//                 : _NextButton(onTap: onNext),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _NextButton extends StatelessWidget {
//   final VoidCallback onTap;
//   const _NextButton({required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 56,
//         height: 56,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: const Icon(
//           Icons.arrow_forward_rounded,
//           color: _C.darkGreen,
//           size: 24,
//         ),
//       ),
//     );
//   }
// }

// class _GetStartedButton extends StatelessWidget {
//   final VoidCallback onTap;
//   const _GetStartedButton({required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//         decoration: BoxDecoration(
//           color: _C.gold,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: _C.gold.withOpacity(0.4),
//               blurRadius: 16,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: const Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'শুরু করি',
//               style: TextStyle(
//                 color: _C.darkGreen,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w800,
//                 letterSpacing: 0.3,
//               ),
//             ),
//             SizedBox(width: 8),
//             Icon(Icons.arrow_forward_rounded, color: _C.darkGreen, size: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Background geometric pattern ───────────────────────────────────────────
// class _GeometricPattern extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: _PatternPainter(),
//       size: Size.infinite,
//     );
//   }
// }

// class _PatternPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white.withOpacity(0.04)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1;

//     // Islamic geometric pattern — octagonal grid
//     const spacing = 80.0;
//     for (double x = -spacing; x < size.width + spacing; x += spacing) {
//       for (double y = -spacing; y < size.height + spacing; y += spacing) {
//         _drawOctagon(canvas, Offset(x, y), 28, paint);
//       }
//     }
//   }

//   void _drawOctagon(Canvas canvas, Offset center, double r, Paint paint) {
//     final path = Path();
//     for (int i = 0; i < 8; i++) {
//       final angle = (i * math.pi / 4) - math.pi / 8;
//       final x = center.dx + r * math.cos(angle);
//       final y = center.dy + r * math.sin(angle);
//       if (i == 0) {
//         path.moveTo(x, y);
//       } else {
//         path.lineTo(x, y);
//       }
//     }
//     path.close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(_PatternPainter old) => false;
// }

// // ── Illustration Painters ──────────────────────────────────────────────────

// abstract class _IllustrationPainter extends CustomPainter {
//   final double progress;
//   _IllustrationPainter(this.progress);
// }

// // Page 1: Mosque
// class _MosquePainter extends _IllustrationPainter {
//   _MosquePainter(super.progress);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;

//     final groundPaint = Paint()
//       ..color = Colors.white.withOpacity(0.08)
//       ..style = PaintingStyle.fill;

//     // Ground
//     canvas.drawEllipse(
//       Rect.fromCenter(
//         center: Offset(cx, cy + size.height * 0.32),
//         width: size.width * 0.85,
//         height: size.height * 0.12,
//       ),
//       groundPaint,
//     );

//     final bodyPaint = Paint()
//       ..color = Colors.white.withOpacity(0.92)
//       ..style = PaintingStyle.fill;

//     final accentPaint = Paint()
//       ..color = _C.gold.withOpacity(0.9)
//       ..style = PaintingStyle.fill;

//     final shadowPaint = Paint()
//       ..color = Colors.black.withOpacity(0.15)
//       ..style = PaintingStyle.fill;

//     // Main mosque body
//     final bodyRect = RRect.fromRectAndRadius(
//       Rect.fromLTWH(cx - size.width * 0.3, cy - size.height * 0.1,
//           size.width * 0.6, size.height * 0.42),
//       const Radius.circular(4),
//     );
//     canvas.drawRRect(
//         bodyRect, shadowPaint..color = Colors.black.withOpacity(0.12));
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromLTWH(cx - size.width * 0.29, cy - size.height * 0.09,
//             size.width * 0.58, size.height * 0.41),
//         const Radius.circular(4),
//       ),
//       bodyPaint,
//     );

//     // Main dome
//     _drawDome(canvas, Offset(cx, cy - size.height * 0.1), size.width * 0.22,
//         size.height * 0.2, accentPaint);

//     // Side domes
//     _drawDome(
//         canvas,
//         Offset(cx - size.width * 0.22, cy - size.height * 0.05),
//         size.width * 0.1,
//         size.height * 0.1,
//         bodyPaint..color = Colors.white.withOpacity(0.8));
//     _drawDome(
//         canvas,
//         Offset(cx + size.width * 0.22, cy - size.height * 0.05),
//         size.width * 0.1,
//         size.height * 0.1,
//         bodyPaint..color = Colors.white.withOpacity(0.8));

//     // Minarets
//     _drawMinaret(
//         canvas,
//         Offset(cx - size.width * 0.32, cy + size.height * 0.12),
//         size.width * 0.055,
//         size.height * 0.45,
//         accentPaint,
//         bodyPaint);
//     _drawMinaret(
//         canvas,
//         Offset(cx + size.width * 0.32, cy + size.height * 0.12),
//         size.width * 0.055,
//         size.height * 0.45,
//         accentPaint,
//         bodyPaint);

//     // Door arch
//     final doorPaint = Paint()
//       ..color = _C.greenMid.withOpacity(0.5)
//       ..style = PaintingStyle.fill;
//     final doorPath = Path()
//       ..addArc(
//         Rect.fromCenter(
//           center: Offset(cx, cy + size.height * 0.18),
//           width: size.width * 0.14,
//           height: size.width * 0.14,
//         ),
//         math.pi,
//         math.pi,
//       )
//       ..lineTo(cx + size.width * 0.07, cy + size.height * 0.32)
//       ..lineTo(cx - size.width * 0.07, cy + size.height * 0.32)
//       ..close();
//     canvas.drawPath(doorPath, doorPaint);

//     // Windows — arched
//     for (final dx in [-0.18, 0.18]) {
//       final wx = cx + size.width * dx;
//       final windowPaint = Paint()
//         ..color = _C.gold.withOpacity(0.6)
//         ..style = PaintingStyle.fill;
//       canvas.drawPath(
//         Path()
//           ..addArc(
//             Rect.fromCenter(
//               center: Offset(wx, cy + size.height * 0.12),
//               width: size.width * 0.09,
//               height: size.width * 0.09,
//             ),
//             math.pi,
//             math.pi,
//           )
//           ..lineTo(wx + size.width * 0.045, cy + size.height * 0.21)
//           ..lineTo(wx - size.width * 0.045, cy + size.height * 0.21)
//           ..close(),
//         windowPaint,
//       );
//     }

//     // Crescent on top
//     _drawCrescent(
//         canvas, Offset(cx, cy - size.height * 0.3), size.width * 0.06);

//     // Stars scattered
//     final starPaint = Paint()
//       ..color = _C.gold.withOpacity(0.7)
//       ..style = PaintingStyle.fill;
//     for (final pos in [
//       Offset(cx - size.width * 0.35, cy - size.height * 0.35),
//       Offset(cx + size.width * 0.38, cy - size.height * 0.28),
//       Offset(cx + size.width * 0.15, cy - size.height * 0.38),
//     ]) {
//       _drawStar(canvas, pos, size.width * 0.025, starPaint);
//     }
//   }

//   void _drawDome(
//       Canvas canvas, Offset center, double w, double h, Paint paint) {
//     final path = Path()
//       ..moveTo(center.dx - w, center.dy)
//       ..cubicTo(
//         center.dx - w,
//         center.dy - h * 1.3,
//         center.dx + w,
//         center.dy - h * 1.3,
//         center.dx + w,
//         center.dy,
//       )
//       ..close();
//     canvas.drawPath(path, paint);
//   }

//   void _drawMinaret(Canvas canvas, Offset center, double w, double h,
//       Paint accentPaint, Paint bodyPaint) {
//     // Main shaft
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(center: center, width: w, height: h),
//         const Radius.circular(3),
//       ),
//       bodyPaint..color = Colors.white.withOpacity(0.88),
//     );
//     // Balcony
//     canvas.drawRect(
//       Rect.fromCenter(
//         center: Offset(center.dx, center.dy - h * 0.25),
//         width: w * 1.7,
//         height: h * 0.04,
//       ),
//       accentPaint,
//     );
//     // Top small dome
//     _drawDome(canvas, Offset(center.dx, center.dy - h * 0.5 - w * 0.8), w * 0.7,
//         w * 1.2, accentPaint);
//     // Spire
//     canvas.drawLine(
//       Offset(center.dx, center.dy - h * 0.5 - w * 2),
//       Offset(center.dx, center.dy - h * 0.5 - w * 0.5),
//       accentPaint..strokeWidth = 2,
//     );
//   }

//   void _drawCrescent(Canvas canvas, Offset center, double r) {
//     final paint = Paint()
//       ..color = _C.gold
//       ..style = PaintingStyle.fill;
//     final path = Path()..addOval(Rect.fromCircle(center: center, radius: r));
//     final cutPath = Path()
//       ..addOval(Rect.fromCircle(
//           center: Offset(center.dx + r * 0.5, center.dy - r * 0.1),
//           radius: r * 0.75));
//     canvas.drawPath(
//       Path.combine(PathOperation.difference, path, cutPath),
//       paint,
//     );
//   }

//   void _drawStar(Canvas canvas, Offset center, double r, Paint paint) {
//     final path = Path();
//     for (int i = 0; i < 5; i++) {
//       final outer = Offset(
//         center.dx + r * math.cos((i * 4 * math.pi / 5) - math.pi / 2),
//         center.dy + r * math.sin((i * 4 * math.pi / 5) - math.pi / 2),
//       );
//       final inner = Offset(
//         center.dx +
//             r * 0.4 * math.cos(((i * 4 + 2) * math.pi / 5) - math.pi / 2),
//         center.dy +
//             r * 0.4 * math.sin(((i * 4 + 2) * math.pi / 5) - math.pi / 2),
//       );
//       if (i == 0)
//         path.moveTo(outer.dx, outer.dy);
//       else
//         path.lineTo(outer.dx, outer.dy);
//       path.lineTo(inner.dx, inner.dy);
//     }
//     path.close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(_MosquePainter old) => old.progress != progress;
// }

// // Page 2: Tracker / Checklist illustration
// class _TrackerPainter extends _IllustrationPainter {
//   _TrackerPainter(super.progress);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;

//     // Phone frame
//     final phoneW = size.width * 0.55;
//     final phoneH = size.height * 0.72;
//     final phoneRect = RRect.fromRectAndRadius(
//       Rect.fromCenter(center: Offset(cx, cy), width: phoneW, height: phoneH),
//       const Radius.circular(24),
//     );

//     canvas.drawRRect(
//       phoneRect,
//       Paint()
//         ..color = Colors.black.withOpacity(0.2)
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
//     );
//     canvas.drawRRect(
//       phoneRect,
//       Paint()..color = Colors.white.withOpacity(0.95),
//     );

//     // Status bar
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromLTWH(cx - phoneW / 2, cy - phoneH / 2, phoneW, phoneH * 0.1),
//         const Radius.circular(24),
//       ),
//       Paint()..color = _C.darkGreen,
//     );

//     // Header text placeholder
//     _drawRect(canvas, Offset(cx - phoneW * 0.25, cy - phoneH * 0.36),
//         phoneW * 0.5, 8, Colors.white.withOpacity(0.8), 4);

//     // Amal rows
//     final amals = [
//       ('ফজর নামাজ', true, _C.greenAccent),
//       ('যোহর নামাজ', true, _C.greenAccent),
//       ('আসর নামাজ', true, _C.greenAccent),
//       ('মাগরিব নামাজ', false, _C.gold),
//       ('এশা নামাজ', false, Colors.white.withOpacity(0.4)),
//       ('কোরআন তিলাওয়াত', true, _C.greenAccent),
//     ];

//     for (int i = 0; i < amals.length; i++) {
//       final (label, done, color) = amals[i];
//       final y = cy - phoneH * 0.2 + i * (phoneH * 0.11);
//       _drawAmalRow(canvas, cx, y, phoneW * 0.82, done, color, label);
//     }

//     // Progress bar at bottom
//     final pbY = cy + phoneH * 0.37;
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromLTWH(cx - phoneW * 0.36, pbY, phoneW * 0.72, 6),
//         const Radius.circular(3),
//       ),
//       Paint()..color = Colors.grey.withOpacity(0.2),
//     );
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromLTWH(cx - phoneW * 0.36, pbY, phoneW * 0.72 * 0.67, 6),
//         const Radius.circular(3),
//       ),
//       Paint()..color = _C.greenAccent,
//     );

//     // Floating badge
//     final badgeCenter = Offset(cx + phoneW * 0.42, cy - phoneH * 0.25);
//     canvas.drawCircle(
//       badgeCenter,
//       size.width * 0.1,
//       Paint()
//         ..color = _C.gold
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
//     );
//     canvas.drawCircle(
//       badgeCenter,
//       size.width * 0.09,
//       Paint()..color = _C.gold,
//     );
//     _drawRect(canvas, badgeCenter, size.width * 0.1, 4,
//         _C.darkGreen.withOpacity(0.8), 2);
//     _drawRect(canvas, Offset(badgeCenter.dx, badgeCenter.dy + 8),
//         size.width * 0.06, 4, _C.darkGreen.withOpacity(0.6), 2);
//   }

//   void _drawAmalRow(Canvas canvas, double cx, double y, double w, bool done,
//       Color color, String label) {
//     final rowH = 28.0;
//     // Row bg
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(center: Offset(cx, y), width: w, height: rowH),
//         const Radius.circular(8),
//       ),
//       Paint()
//         ..color =
//             done ? color.withOpacity(0.12) : Colors.grey.withOpacity(0.06),
//     );
//     // Checkbox
//     final cbCenter = Offset(cx - w / 2 + 18, y);
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(center: cbCenter, width: 16, height: 16),
//         const Radius.circular(4),
//       ),
//       Paint()..color = done ? color : Colors.grey.withOpacity(0.2),
//     );
//     if (done) {
//       final checkPaint = Paint()
//         ..color = Colors.white
//         ..strokeWidth = 2
//         ..style = PaintingStyle.stroke
//         ..strokeCap = StrokeCap.round;
//       canvas.drawLine(
//         Offset(cbCenter.dx - 4, cbCenter.dy),
//         Offset(cbCenter.dx - 1, cbCenter.dy + 3),
//         checkPaint,
//       );
//       canvas.drawLine(
//         Offset(cbCenter.dx - 1, cbCenter.dy + 3),
//         Offset(cbCenter.dx + 5, cbCenter.dy - 3),
//         checkPaint,
//       );
//     }
//     // Label placeholder
//     _drawRect(canvas, Offset(cx - w / 2 + 42, y), w * 0.45, 5,
//         done ? color.withOpacity(0.6) : Colors.grey.withOpacity(0.3), 2);
//   }

//   void _drawRect(
//       Canvas canvas, Offset center, double w, double h, Color color, double r) {
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(center: center, width: w, height: h),
//         Radius.circular(r),
//       ),
//       Paint()..color = color,
//     );
//   }

//   @override
//   bool shouldRepaint(_TrackerPainter old) => old.progress != progress;
// }

// // Page 3: Leaderboard
// class _LeaderboardPainter extends _IllustrationPainter {
//   _LeaderboardPainter(super.progress);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;

//     // Trophy
//     _drawTrophy(canvas, Offset(cx, cy - size.height * 0.28), size.width * 0.2);

//     // Podium
//     final podiumY = cy + size.height * 0.05;
//     final podiumW = size.width * 0.28;

//     // 2nd place
//     _drawPodiumBlock(
//         canvas,
//         Offset(cx - podiumW * 1.1, podiumY + size.height * 0.06),
//         podiumW * 0.9,
//         size.height * 0.22,
//         Colors.white.withOpacity(0.7),
//         '২',
//         _C.textSecondary);

//     // 1st place
//     _drawPodiumBlock(canvas, Offset(cx, podiumY), podiumW, size.height * 0.32,
//         _C.gold, '১', _C.darkGreen);

//     // 3rd place
//     _drawPodiumBlock(
//         canvas,
//         Offset(cx + podiumW * 1.1, podiumY + size.height * 0.12),
//         podiumW * 0.9,
//         size.height * 0.16,
//         _C.greenAccent.withOpacity(0.8),
//         '৩',
//         Colors.white);

//     // Avatar circles on top of podiums
//     _drawAvatar(
//         canvas,
//         Offset(cx - podiumW * 1.1,
//             podiumY + size.height * 0.06 - size.height * 0.11 - 26),
//         22,
//         Colors.white.withOpacity(0.8),
//         _C.textSecondary);

//     _drawAvatar(canvas, Offset(cx, podiumY - size.height * 0.16 - 26), 28,
//         _C.gold, _C.darkGreen);

//     _drawAvatar(
//         canvas,
//         Offset(cx + podiumW * 1.1,
//             podiumY + size.height * 0.12 - size.height * 0.08 - 22),
//         22,
//         _C.greenAccent,
//         Colors.white);

//     // Star burst around 1st place avatar
//     final starPaint = Paint()
//       ..color = _C.gold.withOpacity(0.5)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.5;
//     for (int i = 0; i < 8; i++) {
//       final angle = i * math.pi / 4;
//       final r1 = 36.0;
//       final r2 = 46.0;
//       canvas.drawLine(
//         Offset(cx + r1 * math.cos(angle),
//             podiumY - size.height * 0.16 - 26 + r1 * math.sin(angle)),
//         Offset(cx + r2 * math.cos(angle),
//             podiumY - size.height * 0.16 - 26 + r2 * math.sin(angle)),
//         starPaint,
//       );
//     }
//   }

//   void _drawPodiumBlock(Canvas canvas, Offset center, double w, double h,
//       Color color, String rank, Color textColor) {
//     canvas.drawRRect(
//       RRect.fromRectAndCorners(
//         Rect.fromCenter(
//             center: Offset(center.dx, center.dy + h / 2), width: w, height: h),
//         topLeft: const Radius.circular(10),
//         topRight: const Radius.circular(10),
//       ),
//       Paint()..color = color,
//     );
//   }

//   void _drawAvatar(
//       Canvas canvas, Offset center, double r, Color bgColor, Color iconColor) {
//     canvas.drawCircle(
//         center, r + 3, Paint()..color = Colors.white.withOpacity(0.3));
//     canvas.drawCircle(center, r, Paint()..color = bgColor);
//     // simple person icon
//     canvas.drawCircle(Offset(center.dx, center.dy - r * 0.25), r * 0.35,
//         Paint()..color = iconColor.withOpacity(0.8));
//     canvas.drawArc(
//       Rect.fromCenter(
//           center: Offset(center.dx, center.dy + r * 0.45),
//           width: r * 1.1,
//           height: r),
//       math.pi,
//       math.pi,
//       false,
//       Paint()
//         ..color = iconColor.withOpacity(0.8)
//         ..style = PaintingStyle.fill,
//     );
//   }

//   void _drawTrophy(Canvas canvas, Offset center, double r) {
//     final paint = Paint()..color = _C.gold;

//     // Cup body
//     final cupPath = Path()
//       ..moveTo(center.dx - r, center.dy - r * 0.3)
//       ..cubicTo(
//         center.dx - r * 1.2,
//         center.dy + r * 0.6,
//         center.dx + r * 1.2,
//         center.dy + r * 0.6,
//         center.dx + r,
//         center.dy - r * 0.3,
//       )
//       ..lineTo(center.dx + r * 0.6, center.dy - r)
//       ..lineTo(center.dx - r * 0.6, center.dy - r)
//       ..close();
//     canvas.drawPath(cupPath, paint);

//     // Handles
//     for (final side in [-1.0, 1.0]) {
//       canvas.drawArc(
//         Rect.fromCenter(
//           center: Offset(center.dx + side * r * 0.95, center.dy - r * 0.15),
//           width: r * 0.6,
//           height: r * 0.7,
//         ),
//         side > 0 ? -math.pi / 2 : math.pi / 2,
//         math.pi,
//         false,
//         Paint()
//           ..color = _C.gold
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = r * 0.15,
//       );
//     }

//     // Stem
//     canvas.drawRect(
//       Rect.fromCenter(
//         center: Offset(center.dx, center.dy + r * 0.85),
//         width: r * 0.25,
//         height: r * 0.5,
//       ),
//       paint,
//     );
//     // Base
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(
//           center: Offset(center.dx, center.dy + r * 1.2),
//           width: r * 0.9,
//           height: r * 0.2,
//         ),
//         const Radius.circular(4),
//       ),
//       paint,
//     );

//     // Star on trophy
//     final starPaint = Paint()
//       ..color = _C.darkGreen.withOpacity(0.7)
//       ..style = PaintingStyle.fill;
//     final starPath = Path();
//     final starR = r * 0.28;
//     for (int i = 0; i < 5; i++) {
//       final outer = Offset(
//         center.dx + starR * math.cos(i * 4 * math.pi / 5 - math.pi / 2),
//         center.dy -
//             r * 0.1 +
//             starR * math.sin(i * 4 * math.pi / 5 - math.pi / 2),
//       );
//       final inner = Offset(
//         center.dx +
//             starR * 0.4 * math.cos((i * 4 + 2) * math.pi / 5 - math.pi / 2),
//         center.dy -
//             r * 0.1 +
//             starR * 0.4 * math.sin((i * 4 + 2) * math.pi / 5 - math.pi / 2),
//       );
//       if (i == 0)
//         starPath.moveTo(outer.dx, outer.dy);
//       else
//         starPath.lineTo(outer.dx, outer.dy);
//       starPath.lineTo(inner.dx, inner.dy);
//     }
//     starPath.close();
//     canvas.drawPath(starPath, starPaint);
//   }

//   @override
//   bool shouldRepaint(_LeaderboardPainter old) => old.progress != progress;
// }

// // Page 4: Jannah Garden
// class _GardenPainter extends _IllustrationPainter {
//   _GardenPainter(super.progress);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;

//     // Ground
//     canvas.drawOval(
//       Rect.fromCenter(
//         center: Offset(cx, cy + size.height * 0.3),
//         width: size.width * 0.9,
//         height: size.height * 0.15,
//       ),
//       Paint()..color = _C.greenMid.withOpacity(0.3),
//     );

//     // Big tree (center)
//     _drawTree(canvas, Offset(cx, cy + size.height * 0.15), size.width * 0.12,
//         size.height * 0.42, _C.greenAccent, _C.gold);

//     // Side trees
//     _drawTree(
//         canvas,
//         Offset(cx - size.width * 0.28, cy + size.height * 0.2),
//         size.width * 0.08,
//         size.height * 0.3,
//         _C.greenAccent.withOpacity(0.8),
//         _C.goldLight);
//     _drawTree(
//         canvas,
//         Offset(cx + size.width * 0.28, cy + size.height * 0.2),
//         size.width * 0.08,
//         size.height * 0.3,
//         Colors.white.withOpacity(0.7),
//         _C.gold);

//     // Smaller trees
//     _drawTree(
//         canvas,
//         Offset(cx - size.width * 0.42, cy + size.height * 0.25),
//         size.width * 0.055,
//         size.height * 0.2,
//         Colors.white.withOpacity(0.5),
//         _C.greenLight);
//     _drawTree(
//         canvas,
//         Offset(cx + size.width * 0.42, cy + size.height * 0.25),
//         size.width * 0.055,
//         size.height * 0.2,
//         Colors.white.withOpacity(0.5),
//         _C.greenLight);

//     // River / stream
//     final riverPaint = Paint()
//       ..color = Colors.lightBlue.withOpacity(0.4)
//       ..style = PaintingStyle.fill;
//     final riverPath = Path()
//       ..moveTo(cx - size.width * 0.35, cy + size.height * 0.32)
//       ..cubicTo(
//         cx - size.width * 0.1,
//         cy + size.height * 0.28,
//         cx + size.width * 0.1,
//         cy + size.height * 0.34,
//         cx + size.width * 0.35,
//         cy + size.height * 0.3,
//       )
//       ..lineTo(cx + size.width * 0.35, cy + size.height * 0.35)
//       ..cubicTo(
//         cx + size.width * 0.1,
//         cy + size.height * 0.39,
//         cx - size.width * 0.1,
//         cy + size.height * 0.33,
//         cx - size.width * 0.35,
//         cy + size.height * 0.37,
//       )
//       ..close();
//     canvas.drawPath(riverPath, riverPaint);

//     // Gate / entrance
//     _drawGate(canvas, Offset(cx, cy - size.height * 0.28), size.width * 0.32);

//     // Stars and sparkles
//     final sparkPaint = Paint()
//       ..color = _C.gold.withOpacity(0.8)
//       ..style = PaintingStyle.fill;
//     for (final (x, y, r) in [
//       (cx - 0.4, cy - 0.38, 0.02),
//       (cx + 0.38, cy - 0.32, 0.025),
//       (cx + 0.18, cy - 0.42, 0.018),
//       (cx - 0.15, cy - 0.44, 0.015),
//     ]) {
//       canvas.drawCircle(
//         Offset(x * size.width, y * size.height),
//         r * size.width,
//         sparkPaint,
//       );
//     }
//   }

//   void _drawTree(Canvas canvas, Offset base, double w, double h,
//       Color leafColor, Color accentColor) {
//     // Trunk
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(
//           center: Offset(base.dx, base.dy - h * 0.15),
//           width: w * 0.35,
//           height: h * 0.3,
//         ),
//         const Radius.circular(3),
//       ),
//       Paint()..color = Colors.white.withOpacity(0.4),
//     );

//     // Canopy layers
//     for (int i = 0; i < 3; i++) {
//       final layerY = base.dy - h * (0.35 + i * 0.2);
//       final layerW = w * (1.4 - i * 0.25);
//       canvas.drawOval(
//         Rect.fromCenter(
//           center: Offset(base.dx, layerY),
//           width: layerW,
//           height: layerW * 0.85,
//         ),
//         Paint()..color = i == 1 ? leafColor : leafColor.withOpacity(0.75),
//       );
//     }

//     // Fruits / dots
//     final fruitPaint = Paint()..color = accentColor;
//     for (int i = 0; i < 5; i++) {
//       final angle = i * 2 * math.pi / 5;
//       canvas.drawCircle(
//         Offset(
//           base.dx + w * 0.5 * math.cos(angle),
//           base.dy - h * 0.4 + w * 0.5 * math.sin(angle),
//         ),
//         w * 0.1,
//         fruitPaint,
//       );
//     }
//   }

//   void _drawGate(Canvas canvas, Offset center, double w) {
//     final h = w * 1.1;
//     final gatePaint = Paint()
//       ..color = _C.gold.withOpacity(0.85)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3;

//     // Pillars
//     for (final side in [-1.0, 1.0]) {
//       canvas.drawRect(
//         Rect.fromCenter(
//           center: Offset(center.dx + side * w * 0.42, center.dy + h * 0.1),
//           width: w * 0.1,
//           height: h * 0.8,
//         ),
//         Paint()..color = _C.gold.withOpacity(0.7),
//       );
//     }

//     // Arch
//     canvas.drawArc(
//       Rect.fromCenter(
//         center: Offset(center.dx, center.dy + h * 0.05),
//         width: w * 0.85,
//         height: w * 0.85,
//       ),
//       math.pi,
//       math.pi,
//       false,
//       gatePaint,
//     );

//     // Gate doors
//     canvas.drawRect(
//       Rect.fromLTWH(
//           center.dx - w * 0.4, center.dy - h * 0.1, w * 0.37, h * 0.7),
//       Paint()..color = _C.gold.withOpacity(0.2),
//     );
//     canvas.drawRect(
//       Rect.fromLTWH(
//           center.dx + w * 0.03, center.dy - h * 0.1, w * 0.37, h * 0.7),
//       Paint()..color = _C.gold.withOpacity(0.2),
//     );

//     // Top crescent
//     final crescentC = Offset(center.dx, center.dy - h * 0.38);
//     final cr = w * 0.08;
//     canvas.drawCircle(crescentC, cr, Paint()..color = _C.gold);
//     canvas.drawCircle(
//       Offset(crescentC.dx + cr * 0.5, crescentC.dy - cr * 0.1),
//       cr * 0.75,
//       Paint()..color = _C.greenMid,
//     );
//   }

//   @override
//   bool shouldRepaint(_GardenPainter old) => old.progress != progress;
// }
// lib/features/onboarding/onboarding_screen.dart

// import 'dart:math' as math;
// import 'package:amal_tracker/core/router/app_router.dart';
// import 'package:amal_tracker/features/onboarding/provider/onboarding_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// // ── Color palette matching your app ───────────────────────────────────────
// class _C {
//   static const darkGreen = Color(0xFF033019);
//   static const green = Color(0xFF1B6B3A);
//   static const greenMid = Color(0xFF2D8A52);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const greenAccent = Color(0xFF4CAF78);
//   static const gold = Color(0xFFF5C842);
//   static const goldLight = Color(0xFFFFF8DC);
//   static const white = Colors.white;
//   static const textPrimary = Color(0xFF0D2B1A);
//   static const textSecondary = Color(0xFF5A7A67);
//   static const bg = Color(0xFFF4FAF6);
// }

// // ── Page data ─────────────────────────────────────────────────────────────
// class _PageData {
//   final String arabicText;
//   final String arabicSource;
//   final String title;
//   final String subtitle;
//   final _IllustrationPainter Function(double) painterBuilder;
//   final Color bgFrom;
//   final Color bgTo;

//   const _PageData({
//     required this.arabicText,
//     required this.arabicSource,
//     required this.title,
//     required this.subtitle,
//     required this.painterBuilder,
//     required this.bgFrom,
//     required this.bgTo,
//   });
// }

// // ── Main Screen ────────────────────────────────────────────────────────────
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen>
//     with TickerProviderStateMixin {
//   final _pageController = PageController();
//   int _currentPage = 0;
//   bool _isLastPage = false;

//   late final AnimationController _fadeCtrl;
//   late final AnimationController _floatCtrl;
//   late final Animation<double> _fadeAnim;
//   late final Animation<double> _floatAnim;

//   static const _pages = [
//     _PageData(
//       arabicText: 'إِنَّ اللَّهَ لَا يُضِيعُ أَجْرَ الْمُحْسِنِينَ',
//       arabicSource: 'সূরা তাওবাহ ৯:১২০',
//       title: 'নেক আমলের\nহিসাব রাখো',
//       subtitle:
//           'Sabeq তোমার প্রতিদিনের আমল — নামাজ, কোরআন, যিকির সব কিছু সহজে ট্র্যাক করতে সাহায্য করে।',
//       painterBuilder: _MosquePainter.new,
//       bgFrom: Color(0xFF033019),
//       bgTo: Color(0xFF0D4A28),
//     ),
//     _PageData(
//       arabicText: 'وَذَكِّرْ فَإِنَّ الذِّكْرَى تَنفَعُ الْمُؤْمِنِينَ',
//       arabicSource: 'সূরা আয-যারিয়াত ৫১:৫৫',
//       title: 'প্রতিদিনের\nরুটিন গড়ো',
//       subtitle:
//           'ফরজ, সুন্নাহ, নফল — সব আমলের জন্য আলাদা ক্যাটাগরি। প্রতিটা দিন আরও ভালো হোক।',
//       painterBuilder: _TrackerPainter.new,
//       bgFrom: Color(0xFF0A3D22),
//       bgTo: Color(0xFF155230),
//     ),
//     _PageData(
//       arabicText: 'وَفِي ذَٰلِكَ فَلْيَتَنَافَسِ الْمُتَنَافِسُونَ',
//       arabicSource: 'সূরা আল-মুতাফফিফীন ৮৩:২৬',
//       title: 'নেক আমলে\nএগিয়ে থাকো',
//       subtitle:
//           'বন্ধু ও পরিবারের সাথে লিডারবোর্ডে প্রতিযোগিতা করো — দুনিয়ার সেরা প্রতিযোগিতায়।',
//       painterBuilder: _LeaderboardPainter.new,
//       bgFrom: Color(0xFF1B5E35),
//       bgTo: Color(0xFF267044),
//     ),
//     _PageData(
//       arabicText:
//           'وَبَشِّرِ الْمُؤْمِنِينَ بِأَنَّ لَهُم مِّنَ اللَّهِ فَضْلًا كَبِيرًا',
//       arabicSource: 'সূরা আল-আহযাব ৩৩:৪৭',
//       title: 'জান্নাতের বাগান\nসাজাও',
//       subtitle:
//           'আমলের পয়েন্ট দিয়ে তোমার জান্নাতের বাগান তৈরি করো। প্রতিটা আমল একটা বীজ।',
//       painterBuilder: _GardenPainter.new,
//       bgFrom: Color(0xFF0D4A28),
//       bgTo: Color(0xFF1A7040),
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _fadeCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//     _floatCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     )..repeat(reverse: true);

//     _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
//     _floatAnim = CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut);

//     _fadeCtrl.forward();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _fadeCtrl.dispose();
//     _floatCtrl.dispose();
//     super.dispose();
//   }

//   void _onPageChanged(int index) {
//     _fadeCtrl.reset();
//     _fadeCtrl.forward();
//     setState(() {
//       _currentPage = index;
//       _isLastPage = index == _pages.length - 1;
//     });
//   }

//   Future<void> _complete() async {
//     await markOnboardingSeen();
//     onboardingSeenNotifier.value = true;
//     if (mounted) context.go(AppRoutes.login);
//   }

//   void _nextPage() {
//     _pageController.nextPage(
//       duration: const Duration(milliseconds: 450),
//       curve: Curves.easeInOutCubic,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final page = _pages[_currentPage];

//     return Scaffold(
//       backgroundColor: page.bgFrom,
//       body: AnimatedContainer(
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [page.bgFrom, page.bgTo],
//           ),
//         ),
//         child: Stack(
//           children: [
//             // ── Decorative background pattern ──────────────────────────
//             Positioned.fill(child: _GeometricPattern()),

//             // ── Page content ───────────────────────────────────────────
//             PageView.builder(
//               controller: _pageController,
//               onPageChanged: _onPageChanged,
//               itemCount: _pages.length,
//               itemBuilder: (context, index) {
//                 return _OnboardingPage(
//                   data: _pages[index],
//                   floatAnim: _floatAnim,
//                   fadeAnim: _fadeAnim,
//                   size: size,
//                 );
//               },
//             ),

//             // ── Top: Skip button ───────────────────────────────────────
//             SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 8,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Logo mark
//                     Row(
//                       children: [
//                         Container(
//                           width: 32,
//                           height: 32,
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               'س',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         const Text(
//                           'Sabeq',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                       ],
//                     ),
//                     // Skip
//                     AnimatedOpacity(
//                       opacity: _isLastPage ? 0 : 1,
//                       duration: const Duration(milliseconds: 300),
//                       child: GestureDetector(
//                         onTap: _isLastPage ? null : _complete,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 14,
//                             vertical: 7,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                               color: Colors.white.withOpacity(0.3),
//                             ),
//                           ),
//                           child: const Text(
//                             'Skip',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // ── Bottom: Dots + CTA ─────────────────────────────────────
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               child: _BottomControls(
//                 currentPage: _currentPage,
//                 totalPages: _pages.length,
//                 isLastPage: _isLastPage,
//                 onNext: _nextPage,
//                 onComplete: _complete,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Single Onboarding Page ─────────────────────────────────────────────────
// class _OnboardingPage extends StatelessWidget {
//   final _PageData data;
//   final Animation<double> floatAnim;
//   final Animation<double> fadeAnim;
//   final Size size;

//   const _OnboardingPage({
//     required this.data,
//     required this.floatAnim,
//     required this.fadeAnim,
//     required this.size,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // ── Illustration area (top ~52%) ───────────────────────────────
//         Expanded(
//           flex: 52,
//           child: Padding(
//             padding: const EdgeInsets.only(top: 90),
//             child: AnimatedBuilder(
//               animation: floatAnim,
//               builder: (context, child) {
//                 final offset = (floatAnim.value - 0.5) * 14;
//                 return Transform.translate(
//                   offset: Offset(0, offset),
//                   child: child,
//                 );
//               },
//               child: CustomPaint(
//                 painter: data.painterBuilder(1.0),
//                 size: Size(size.width * 0.8, size.width * 0.8),
//               ),
//             ),
//           ),
//         ),

//         // ── Text area (bottom ~48%) ────────────────────────────────────
//         Expanded(
//           flex: 48,
//           child: FadeTransition(
//             opacity: fadeAnim,
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(28, 16, 28, 110),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Arabic ayat
//                   Container(
//                     padding: const EdgeInsets.all(14),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.08),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: _C.gold.withOpacity(0.4),
//                         width: 1,
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           data.arabicText,
//                           textAlign: TextAlign.right,
//                           style: const TextStyle(
//                             color: _C.gold,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                             height: 1.7,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           data.arabicSource,
//                           textAlign: TextAlign.right,
//                           style: TextStyle(
//                             color: _C.gold.withOpacity(0.7),
//                             fontSize: 11,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // Title
//                   Text(
//                     data.title,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 28,
//                       fontWeight: FontWeight.w800,
//                       height: 1.25,
//                       letterSpacing: -0.5,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   // Subtitle
//                   Text(
//                     data.subtitle,
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.75),
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       height: 1.65,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ── Bottom Controls ────────────────────────────────────────────────────────
// class _BottomControls extends StatelessWidget {
//   final int currentPage;
//   final int totalPages;
//   final bool isLastPage;
//   final VoidCallback onNext;
//   final VoidCallback onComplete;

//   const _BottomControls({
//     required this.currentPage,
//     required this.totalPages,
//     required this.isLastPage,
//     required this.onNext,
//     required this.onComplete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(
//         28,
//         20,
//         28,
//         MediaQuery.of(context).padding.bottom + 24,
//       ),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             Colors.transparent,
//             Colors.black.withOpacity(0.25),
//           ],
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Dots
//           Row(
//             children: List.generate(totalPages, (i) {
//               final active = i == currentPage;
//               return AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.easeInOut,
//                 margin: const EdgeInsets.only(right: 6),
//                 width: active ? 24 : 8,
//                 height: 8,
//                 decoration: BoxDecoration(
//                   color: active ? Colors.white : Colors.white.withOpacity(0.35),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               );
//             }),
//           ),

//           // Next / Complete button
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 300),
//             child: isLastPage
//                 ? _GetStartedButton(onTap: onComplete)
//                 : _NextButton(onTap: onNext),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _NextButton extends StatelessWidget {
//   final VoidCallback onTap;
//   const _NextButton({required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 56,
//         height: 56,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: const Icon(
//           Icons.arrow_forward_rounded,
//           color: _C.darkGreen,
//           size: 24,
//         ),
//       ),
//     );
//   }
// }

// class _GetStartedButton extends StatelessWidget {
//   final VoidCallback onTap;
//   const _GetStartedButton({required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//         decoration: BoxDecoration(
//           color: _C.gold,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: _C.gold.withOpacity(0.4),
//               blurRadius: 16,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: const Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'শুরু করি',
//               style: TextStyle(
//                 color: _C.darkGreen,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w800,
//                 letterSpacing: 0.3,
//               ),
//             ),
//             SizedBox(width: 8),
//             Icon(Icons.arrow_forward_rounded, color: _C.darkGreen, size: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Background geometric pattern ───────────────────────────────────────────
// class _GeometricPattern extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: _PatternPainter(),
//       size: Size.infinite,
//     );
//   }
// }

// class _PatternPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white.withOpacity(0.04)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1;

//     // Islamic geometric pattern — octagonal grid
//     const spacing = 80.0;
//     for (double x = -spacing; x < size.width + spacing; x += spacing) {
//       for (double y = -spacing; y < size.height + spacing; y += spacing) {
//         _drawOctagon(canvas, Offset(x, y), 28, paint);
//       }
//     }
//   }

//   void _drawOctagon(Canvas canvas, Offset center, double r, Paint paint) {
//     final path = Path();
//     for (int i = 0; i < 8; i++) {
//       final angle = (i * math.pi / 4) - math.pi / 8;
//       final x = center.dx + r * math.cos(angle);
//       final y = center.dy + r * math.sin(angle);
//       if (i == 0) {
//         path.moveTo(x, y);
//       } else {
//         path.lineTo(x, y);
//       }
//     }
//     path.close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(_PatternPainter old) => false;
// }

// // ── Illustration Painters ──────────────────────────────────────────────────

// abstract class _IllustrationPainter extends CustomPainter {
//   final double progress;
//   _IllustrationPainter(this.progress);
// }

// // Page 1: Mosque
// class _MosquePainter extends _IllustrationPainter {
//   _MosquePainter(super.progress);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;

//     final groundPaint = Paint()
//       ..color = Colors.white.withOpacity(0.08)
//       ..style = PaintingStyle.fill;

//     // Ground
//     canvas.drawOval(
//       Rect.fromCenter(
//         center: Offset(cx, cy + size.height * 0.32),
//         width: size.width * 0.85,
//         height: size.height * 0.12,
//       ),
//       groundPaint,
//     );

//     final bodyPaint = Paint()
//       ..color = Colors.white.withOpacity(0.92)
//       ..style = PaintingStyle.fill;

//     final accentPaint = Paint()
//       ..color = _C.gold.withOpacity(0.9)
//       ..style = PaintingStyle.fill;

//     final shadowPaint = Paint()
//       ..color = Colors.black.withOpacity(0.15)
//       ..style = PaintingStyle.fill;

//     // Main mosque body
//     final bodyRect = RRect.fromRectAndRadius(
//       Rect.fromLTWH(cx - size.width * 0.3, cy - size.height * 0.1,
//           size.width * 0.6, size.height * 0.42),
//       const Radius.circular(4),
//     );
//     canvas.drawRRect(
//         bodyRect, shadowPaint..color = Colors.black.withOpacity(0.12));
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromLTWH(cx - size.width * 0.29, cy - size.height * 0.09,
//             size.width * 0.58, size.height * 0.41),
//         const Radius.circular(4),
//       ),
//       bodyPaint,
//     );

//     // Main dome
//     _drawDome(canvas, Offset(cx, cy - size.height * 0.1), size.width * 0.22,
//         size.height * 0.2, accentPaint);

//     // Side domes
//     _drawDome(
//         canvas,
//         Offset(cx - size.width * 0.22, cy - size.height * 0.05),
//         size.width * 0.1,
//         size.height * 0.1,
//         bodyPaint..color = Colors.white.withOpacity(0.8));
//     _drawDome(
//         canvas,
//         Offset(cx + size.width * 0.22, cy - size.height * 0.05),
//         size.width * 0.1,
//         size.height * 0.1,
//         bodyPaint..color = Colors.white.withOpacity(0.8));

//     // Minarets
//     _drawMinaret(
//         canvas,
//         Offset(cx - size.width * 0.32, cy + size.height * 0.12),
//         size.width * 0.055,
//         size.height * 0.45,
//         accentPaint,
//         bodyPaint);
//     _drawMinaret(
//         canvas,
//         Offset(cx + size.width * 0.32, cy + size.height * 0.12),
//         size.width * 0.055,
//         size.height * 0.45,
//         accentPaint,
//         bodyPaint);

//     // Door arch
//     final doorPaint = Paint()
//       ..color = _C.greenMid.withOpacity(0.5)
//       ..style = PaintingStyle.fill;
//     final doorPath = Path()
//       ..addArc(
//         Rect.fromCenter(
//           center: Offset(cx, cy + size.height * 0.18),
//           width: size.width * 0.14,
//           height: size.width * 0.14,
//         ),
//         math.pi,
//         math.pi,
//       )
//       ..lineTo(cx + size.width * 0.07, cy + size.height * 0.32)
//       ..lineTo(cx - size.width * 0.07, cy + size.height * 0.32)
//       ..close();
//     canvas.drawPath(doorPath, doorPaint);

//     // Windows — arched
//     for (final dx in [-0.18, 0.18]) {
//       final wx = cx + size.width * dx;
//       final windowPaint = Paint()
//         ..color = _C.gold.withOpacity(0.6)
//         ..style = PaintingStyle.fill;
//       canvas.drawPath(
//         Path()
//           ..addArc(
//             Rect.fromCenter(
//               center: Offset(wx, cy + size.height * 0.12),
//               width: size.width * 0.09,
//               height: size.width * 0.09,
//             ),
//             math.pi,
//             math.pi,
//           )
//           ..lineTo(wx + size.width * 0.045, cy + size.height * 0.21)
//           ..lineTo(wx - size.width * 0.045, cy + size.height * 0.21)
//           ..close(),
//         windowPaint,
//       );
//     }

//     // Crescent on top
//     _drawCrescent(
//         canvas, Offset(cx, cy - size.height * 0.3), size.width * 0.06);

//     // Stars scattered
//     final starPaint = Paint()
//       ..color = _C.gold.withOpacity(0.7)
//       ..style = PaintingStyle.fill;
//     for (final pos in [
//       Offset(cx - size.width * 0.35, cy - size.height * 0.35),
//       Offset(cx + size.width * 0.38, cy - size.height * 0.28),
//       Offset(cx + size.width * 0.15, cy - size.height * 0.38),
//     ]) {
//       _drawStar(canvas, pos, size.width * 0.025, starPaint);
//     }
//   }

//   void _drawDome(
//       Canvas canvas, Offset center, double w, double h, Paint paint) {
//     final path = Path()
//       ..moveTo(center.dx - w, center.dy)
//       ..cubicTo(
//         center.dx - w,
//         center.dy - h * 1.3,
//         center.dx + w,
//         center.dy - h * 1.3,
//         center.dx + w,
//         center.dy,
//       )
//       ..close();
//     canvas.drawPath(path, paint);
//   }

//   void _drawMinaret(Canvas canvas, Offset center, double w, double h,
//       Paint accentPaint, Paint bodyPaint) {
//     // Main shaft
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(center: center, width: w, height: h),
//         const Radius.circular(3),
//       ),
//       bodyPaint..color = Colors.white.withOpacity(0.88),
//     );
//     // Balcony
//     canvas.drawRect(
//       Rect.fromCenter(
//         center: Offset(center.dx, center.dy - h * 0.25),
//         width: w * 1.7,
//         height: h * 0.04,
//       ),
//       accentPaint,
//     );
//     // Top small dome
//     _drawDome(canvas, Offset(center.dx, center.dy - h * 0.5 - w * 0.8), w * 0.7,
//         w * 1.2, accentPaint);
//     // Spire
//     canvas.drawLine(
//       Offset(center.dx, center.dy - h * 0.5 - w * 2),
//       Offset(center.dx, center.dy - h * 0.5 - w * 0.5),
//       accentPaint..strokeWidth = 2,
//     );
//   }

//   void _drawCrescent(Canvas canvas, Offset center, double r) {
//     final paint = Paint()
//       ..color = _C.gold
//       ..style = PaintingStyle.fill;
//     final path = Path()..addOval(Rect.fromCircle(center: center, radius: r));
//     final cutPath = Path()
//       ..addOval(Rect.fromCircle(
//           center: Offset(center.dx + r * 0.5, center.dy - r * 0.1),
//           radius: r * 0.75));
//     canvas.drawPath(
//       Path.combine(PathOperation.difference, path, cutPath),
//       paint,
//     );
//   }

//   void _drawStar(Canvas canvas, Offset center, double r, Paint paint) {
//     final path = Path();
//     for (int i = 0; i < 5; i++) {
//       final outer = Offset(
//         center.dx + r * math.cos((i * 4 * math.pi / 5) - math.pi / 2),
//         center.dy + r * math.sin((i * 4 * math.pi / 5) - math.pi / 2),
//       );
//       final inner = Offset(
//         center.dx +
//             r * 0.4 * math.cos(((i * 4 + 2) * math.pi / 5) - math.pi / 2),
//         center.dy +
//             r * 0.4 * math.sin(((i * 4 + 2) * math.pi / 5) - math.pi / 2),
//       );
//       if (i == 0)
//         path.moveTo(outer.dx, outer.dy);
//       else
//         path.lineTo(outer.dx, outer.dy);
//       path.lineTo(inner.dx, inner.dy);
//     }
//     path.close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(_MosquePainter old) => old.progress != progress;
// }

// // Page 2: Tracker / Checklist illustration
// class _TrackerPainter extends _IllustrationPainter {
//   _TrackerPainter(super.progress);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;

//     // Phone frame
//     final phoneW = size.width * 0.55;
//     final phoneH = size.height * 0.72;
//     final phoneRect = RRect.fromRectAndRadius(
//       Rect.fromCenter(center: Offset(cx, cy), width: phoneW, height: phoneH),
//       const Radius.circular(24),
//     );

//     canvas.drawRRect(
//       phoneRect,
//       Paint()
//         ..color = Colors.black.withOpacity(0.2)
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
//     );
//     canvas.drawRRect(
//       phoneRect,
//       Paint()..color = Colors.white.withOpacity(0.95),
//     );

//     // Status bar
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromLTWH(cx - phoneW / 2, cy - phoneH / 2, phoneW, phoneH * 0.1),
//         const Radius.circular(24),
//       ),
//       Paint()..color = _C.darkGreen,
//     );

//     // Header text placeholder
//     _drawRect(canvas, Offset(cx - phoneW * 0.25, cy - phoneH * 0.36),
//         phoneW * 0.5, 8, Colors.white.withOpacity(0.8), 4);

//     // Amal rows
//     final amals = [
//       ('ফজর নামাজ', true, _C.greenAccent),
//       ('যোহর নামাজ', true, _C.greenAccent),
//       ('আসর নামাজ', true, _C.greenAccent),
//       ('মাগরিব নামাজ', false, _C.gold),
//       ('এশা নামাজ', false, Colors.white.withOpacity(0.4)),
//       ('কোরআন তিলাওয়াত', true, _C.greenAccent),
//     ];

//     for (int i = 0; i < amals.length; i++) {
//       final (label, done, color) = amals[i];
//       final y = cy - phoneH * 0.2 + i * (phoneH * 0.11);
//       _drawAmalRow(canvas, cx, y, phoneW * 0.82, done, color, label);
//     }

//     // Progress bar at bottom
//     final pbY = cy + phoneH * 0.37;
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromLTWH(cx - phoneW * 0.36, pbY, phoneW * 0.72, 6),
//         const Radius.circular(3),
//       ),
//       Paint()..color = Colors.grey.withOpacity(0.2),
//     );
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromLTWH(cx - phoneW * 0.36, pbY, phoneW * 0.72 * 0.67, 6),
//         const Radius.circular(3),
//       ),
//       Paint()..color = _C.greenAccent,
//     );

//     // Floating badge
//     final badgeCenter = Offset(cx + phoneW * 0.42, cy - phoneH * 0.25);
//     canvas.drawCircle(
//       badgeCenter,
//       size.width * 0.1,
//       Paint()
//         ..color = _C.gold
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
//     );
//     canvas.drawCircle(
//       badgeCenter,
//       size.width * 0.09,
//       Paint()..color = _C.gold,
//     );
//     _drawRect(canvas, badgeCenter, size.width * 0.1, 4,
//         _C.darkGreen.withOpacity(0.8), 2);
//     _drawRect(canvas, Offset(badgeCenter.dx, badgeCenter.dy + 8),
//         size.width * 0.06, 4, _C.darkGreen.withOpacity(0.6), 2);
//   }

//   void _drawAmalRow(Canvas canvas, double cx, double y, double w, bool done,
//       Color color, String label) {
//     final rowH = 28.0;
//     // Row bg
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(center: Offset(cx, y), width: w, height: rowH),
//         const Radius.circular(8),
//       ),
//       Paint()
//         ..color =
//             done ? color.withOpacity(0.12) : Colors.grey.withOpacity(0.06),
//     );
//     // Checkbox
//     final cbCenter = Offset(cx - w / 2 + 18, y);
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(center: cbCenter, width: 16, height: 16),
//         const Radius.circular(4),
//       ),
//       Paint()..color = done ? color : Colors.grey.withOpacity(0.2),
//     );
//     if (done) {
//       final checkPaint = Paint()
//         ..color = Colors.white
//         ..strokeWidth = 2
//         ..style = PaintingStyle.stroke
//         ..strokeCap = StrokeCap.round;
//       canvas.drawLine(
//         Offset(cbCenter.dx - 4, cbCenter.dy),
//         Offset(cbCenter.dx - 1, cbCenter.dy + 3),
//         checkPaint,
//       );
//       canvas.drawLine(
//         Offset(cbCenter.dx - 1, cbCenter.dy + 3),
//         Offset(cbCenter.dx + 5, cbCenter.dy - 3),
//         checkPaint,
//       );
//     }
//     // Label placeholder
//     _drawRect(canvas, Offset(cx - w / 2 + 42, y), w * 0.45, 5,
//         done ? color.withOpacity(0.6) : Colors.grey.withOpacity(0.3), 2);
//   }

//   void _drawRect(
//       Canvas canvas, Offset center, double w, double h, Color color, double r) {
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(center: center, width: w, height: h),
//         Radius.circular(r),
//       ),
//       Paint()..color = color,
//     );
//   }

//   @override
//   bool shouldRepaint(_TrackerPainter old) => old.progress != progress;
// }

// // Page 3: Leaderboard
// class _LeaderboardPainter extends _IllustrationPainter {
//   _LeaderboardPainter(super.progress);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;

//     // Trophy
//     _drawTrophy(canvas, Offset(cx, cy - size.height * 0.28), size.width * 0.2);

//     // Podium
//     final podiumY = cy + size.height * 0.05;
//     final podiumW = size.width * 0.28;

//     // 2nd place
//     _drawPodiumBlock(
//         canvas,
//         Offset(cx - podiumW * 1.1, podiumY + size.height * 0.06),
//         podiumW * 0.9,
//         size.height * 0.22,
//         Colors.white.withOpacity(0.7),
//         '২',
//         _C.textSecondary);

//     // 1st place
//     _drawPodiumBlock(canvas, Offset(cx, podiumY), podiumW, size.height * 0.32,
//         _C.gold, '১', _C.darkGreen);

//     // 3rd place
//     _drawPodiumBlock(
//         canvas,
//         Offset(cx + podiumW * 1.1, podiumY + size.height * 0.12),
//         podiumW * 0.9,
//         size.height * 0.16,
//         _C.greenAccent.withOpacity(0.8),
//         '৩',
//         Colors.white);

//     // Avatar circles on top of podiums
//     _drawAvatar(
//         canvas,
//         Offset(cx - podiumW * 1.1,
//             podiumY + size.height * 0.06 - size.height * 0.11 - 26),
//         22,
//         Colors.white.withOpacity(0.8),
//         _C.textSecondary);

//     _drawAvatar(canvas, Offset(cx, podiumY - size.height * 0.16 - 26), 28,
//         _C.gold, _C.darkGreen);

//     _drawAvatar(
//         canvas,
//         Offset(cx + podiumW * 1.1,
//             podiumY + size.height * 0.12 - size.height * 0.08 - 22),
//         22,
//         _C.greenAccent,
//         Colors.white);

//     // Star burst around 1st place avatar
//     final starPaint = Paint()
//       ..color = _C.gold.withOpacity(0.5)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.5;
//     for (int i = 0; i < 8; i++) {
//       final angle = i * math.pi / 4;
//       final r1 = 36.0;
//       final r2 = 46.0;
//       canvas.drawLine(
//         Offset(cx + r1 * math.cos(angle),
//             podiumY - size.height * 0.16 - 26 + r1 * math.sin(angle)),
//         Offset(cx + r2 * math.cos(angle),
//             podiumY - size.height * 0.16 - 26 + r2 * math.sin(angle)),
//         starPaint,
//       );
//     }
//   }

//   void _drawPodiumBlock(Canvas canvas, Offset center, double w, double h,
//       Color color, String rank, Color textColor) {
//     canvas.drawRRect(
//       RRect.fromRectAndCorners(
//         Rect.fromCenter(
//             center: Offset(center.dx, center.dy + h / 2), width: w, height: h),
//         topLeft: const Radius.circular(10),
//         topRight: const Radius.circular(10),
//       ),
//       Paint()..color = color,
//     );
//   }

//   void _drawAvatar(
//       Canvas canvas, Offset center, double r, Color bgColor, Color iconColor) {
//     canvas.drawCircle(
//         center, r + 3, Paint()..color = Colors.white.withOpacity(0.3));
//     canvas.drawCircle(center, r, Paint()..color = bgColor);
//     // simple person icon
//     canvas.drawCircle(Offset(center.dx, center.dy - r * 0.25), r * 0.35,
//         Paint()..color = iconColor.withOpacity(0.8));
//     canvas.drawArc(
//       Rect.fromCenter(
//           center: Offset(center.dx, center.dy + r * 0.45),
//           width: r * 1.1,
//           height: r),
//       math.pi,
//       math.pi,
//       false,
//       Paint()
//         ..color = iconColor.withOpacity(0.8)
//         ..style = PaintingStyle.fill,
//     );
//   }

//   void _drawTrophy(Canvas canvas, Offset center, double r) {
//     final paint = Paint()..color = _C.gold;

//     // Cup body
//     final cupPath = Path()
//       ..moveTo(center.dx - r, center.dy - r * 0.3)
//       ..cubicTo(
//         center.dx - r * 1.2,
//         center.dy + r * 0.6,
//         center.dx + r * 1.2,
//         center.dy + r * 0.6,
//         center.dx + r,
//         center.dy - r * 0.3,
//       )
//       ..lineTo(center.dx + r * 0.6, center.dy - r)
//       ..lineTo(center.dx - r * 0.6, center.dy - r)
//       ..close();
//     canvas.drawPath(cupPath, paint);

//     // Handles
//     for (final side in [-1.0, 1.0]) {
//       canvas.drawArc(
//         Rect.fromCenter(
//           center: Offset(center.dx + side * r * 0.95, center.dy - r * 0.15),
//           width: r * 0.6,
//           height: r * 0.7,
//         ),
//         side > 0 ? -math.pi / 2 : math.pi / 2,
//         math.pi,
//         false,
//         Paint()
//           ..color = _C.gold
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = r * 0.15,
//       );
//     }

//     // Stem
//     canvas.drawRect(
//       Rect.fromCenter(
//         center: Offset(center.dx, center.dy + r * 0.85),
//         width: r * 0.25,
//         height: r * 0.5,
//       ),
//       paint,
//     );
//     // Base
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(
//           center: Offset(center.dx, center.dy + r * 1.2),
//           width: r * 0.9,
//           height: r * 0.2,
//         ),
//         const Radius.circular(4),
//       ),
//       paint,
//     );

//     // Star on trophy
//     final starPaint = Paint()
//       ..color = _C.darkGreen.withOpacity(0.7)
//       ..style = PaintingStyle.fill;
//     final starPath = Path();
//     final starR = r * 0.28;
//     for (int i = 0; i < 5; i++) {
//       final outer = Offset(
//         center.dx + starR * math.cos(i * 4 * math.pi / 5 - math.pi / 2),
//         center.dy -
//             r * 0.1 +
//             starR * math.sin(i * 4 * math.pi / 5 - math.pi / 2),
//       );
//       final inner = Offset(
//         center.dx +
//             starR * 0.4 * math.cos((i * 4 + 2) * math.pi / 5 - math.pi / 2),
//         center.dy -
//             r * 0.1 +
//             starR * 0.4 * math.sin((i * 4 + 2) * math.pi / 5 - math.pi / 2),
//       );
//       if (i == 0)
//         starPath.moveTo(outer.dx, outer.dy);
//       else
//         starPath.lineTo(outer.dx, outer.dy);
//       starPath.lineTo(inner.dx, inner.dy);
//     }
//     starPath.close();
//     canvas.drawPath(starPath, starPaint);
//   }

//   @override
//   bool shouldRepaint(_LeaderboardPainter old) => old.progress != progress;
// }

// // Page 4: Jannah Garden
// class _GardenPainter extends _IllustrationPainter {
//   _GardenPainter(super.progress);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;

//     // Ground
//     canvas.drawOval(
//       Rect.fromCenter(
//         center: Offset(cx, cy + size.height * 0.3),
//         width: size.width * 0.9,
//         height: size.height * 0.15,
//       ),
//       Paint()..color = _C.greenMid.withOpacity(0.3),
//     );

//     // Big tree (center)
//     _drawTree(canvas, Offset(cx, cy + size.height * 0.15), size.width * 0.12,
//         size.height * 0.42, _C.greenAccent, _C.gold);

//     // Side trees
//     _drawTree(
//         canvas,
//         Offset(cx - size.width * 0.28, cy + size.height * 0.2),
//         size.width * 0.08,
//         size.height * 0.3,
//         _C.greenAccent.withOpacity(0.8),
//         _C.goldLight);
//     _drawTree(
//         canvas,
//         Offset(cx + size.width * 0.28, cy + size.height * 0.2),
//         size.width * 0.08,
//         size.height * 0.3,
//         Colors.white.withOpacity(0.7),
//         _C.gold);

//     // Smaller trees
//     _drawTree(
//         canvas,
//         Offset(cx - size.width * 0.42, cy + size.height * 0.25),
//         size.width * 0.055,
//         size.height * 0.2,
//         Colors.white.withOpacity(0.5),
//         _C.greenLight);
//     _drawTree(
//         canvas,
//         Offset(cx + size.width * 0.42, cy + size.height * 0.25),
//         size.width * 0.055,
//         size.height * 0.2,
//         Colors.white.withOpacity(0.5),
//         _C.greenLight);

//     // River / stream
//     final riverPaint = Paint()
//       ..color = Colors.lightBlue.withOpacity(0.4)
//       ..style = PaintingStyle.fill;
//     final riverPath = Path()
//       ..moveTo(cx - size.width * 0.35, cy + size.height * 0.32)
//       ..cubicTo(
//         cx - size.width * 0.1,
//         cy + size.height * 0.28,
//         cx + size.width * 0.1,
//         cy + size.height * 0.34,
//         cx + size.width * 0.35,
//         cy + size.height * 0.3,
//       )
//       ..lineTo(cx + size.width * 0.35, cy + size.height * 0.35)
//       ..cubicTo(
//         cx + size.width * 0.1,
//         cy + size.height * 0.39,
//         cx - size.width * 0.1,
//         cy + size.height * 0.33,
//         cx - size.width * 0.35,
//         cy + size.height * 0.37,
//       )
//       ..close();
//     canvas.drawPath(riverPath, riverPaint);

//     // Gate / entrance
//     _drawGate(canvas, Offset(cx, cy - size.height * 0.28), size.width * 0.32);

//     // Stars and sparkles
//     final sparkPaint = Paint()
//       ..color = _C.gold.withOpacity(0.8)
//       ..style = PaintingStyle.fill;
//     for (final (x, y, r) in [
//       (cx - 0.4, cy - 0.38, 0.02),
//       (cx + 0.38, cy - 0.32, 0.025),
//       (cx + 0.18, cy - 0.42, 0.018),
//       (cx - 0.15, cy - 0.44, 0.015),
//     ]) {
//       canvas.drawCircle(
//         Offset(x * size.width, y * size.height),
//         r * size.width,
//         sparkPaint,
//       );
//     }
//   }

//   void _drawTree(Canvas canvas, Offset base, double w, double h,
//       Color leafColor, Color accentColor) {
//     // Trunk
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(
//           center: Offset(base.dx, base.dy - h * 0.15),
//           width: w * 0.35,
//           height: h * 0.3,
//         ),
//         const Radius.circular(3),
//       ),
//       Paint()..color = Colors.white.withOpacity(0.4),
//     );

//     // Canopy layers
//     for (int i = 0; i < 3; i++) {
//       final layerY = base.dy - h * (0.35 + i * 0.2);
//       final layerW = w * (1.4 - i * 0.25);
//       canvas.drawOval(
//         Rect.fromCenter(
//           center: Offset(base.dx, layerY),
//           width: layerW,
//           height: layerW * 0.85,
//         ),
//         Paint()..color = i == 1 ? leafColor : leafColor.withOpacity(0.75),
//       );
//     }

//     // Fruits / dots
//     final fruitPaint = Paint()..color = accentColor;
//     for (int i = 0; i < 5; i++) {
//       final angle = i * 2 * math.pi / 5;
//       canvas.drawCircle(
//         Offset(
//           base.dx + w * 0.5 * math.cos(angle),
//           base.dy - h * 0.4 + w * 0.5 * math.sin(angle),
//         ),
//         w * 0.1,
//         fruitPaint,
//       );
//     }
//   }

//   void _drawGate(Canvas canvas, Offset center, double w) {
//     final h = w * 1.1;
//     final gatePaint = Paint()
//       ..color = _C.gold.withOpacity(0.85)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3;

//     // Pillars
//     for (final side in [-1.0, 1.0]) {
//       canvas.drawRect(
//         Rect.fromCenter(
//           center: Offset(center.dx + side * w * 0.42, center.dy + h * 0.1),
//           width: w * 0.1,
//           height: h * 0.8,
//         ),
//         Paint()..color = _C.gold.withOpacity(0.7),
//       );
//     }

//     // Arch
//     canvas.drawArc(
//       Rect.fromCenter(
//         center: Offset(center.dx, center.dy + h * 0.05),
//         width: w * 0.85,
//         height: w * 0.85,
//       ),
//       math.pi,
//       math.pi,
//       false,
//       gatePaint,
//     );

//     // Gate doors
//     canvas.drawRect(
//       Rect.fromLTWH(
//           center.dx - w * 0.4, center.dy - h * 0.1, w * 0.37, h * 0.7),
//       Paint()..color = _C.gold.withOpacity(0.2),
//     );
//     canvas.drawRect(
//       Rect.fromLTWH(
//           center.dx + w * 0.03, center.dy - h * 0.1, w * 0.37, h * 0.7),
//       Paint()..color = _C.gold.withOpacity(0.2),
//     );

//     // Top crescent
//     final crescentC = Offset(center.dx, center.dy - h * 0.38);
//     final cr = w * 0.08;
//     canvas.drawCircle(crescentC, cr, Paint()..color = _C.gold);
//     canvas.drawCircle(
//       Offset(crescentC.dx + cr * 0.5, crescentC.dy - cr * 0.1),
//       cr * 0.75,
//       Paint()..color = _C.greenMid,
//     );
//   }

//   @override
//   bool shouldRepaint(_GardenPainter old) => old.progress != progress;
// }
// lib/features/onboarding/onboarding_screen.dart

// import 'dart:math' as math;
// import 'package:amal_tracker/core/router/app_router.dart';
// import 'package:amal_tracker/features/onboarding/provider/onboarding_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// // ── Color palette ─────────────────────────────────────────────────────────
// class _C {
//   static const darkGreen = Color(0xFF033019);
//   static const green = Color(0xFF1B6B3A);
//   static const greenMid = Color(0xFF2D8A52);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const greenAccent = Color(0xFF4CAF78);
//   static const gold = Color(0xFFF5C842);
//   static const goldLight = Color(0xFFFFF8DC);
//   static const textSecondary = Color(0xFF5A7A67);
// }

// // ── Page model ────────────────────────────────────────────────────────────
// class _PageData {
//   final String arabicText;
//   final String arabicSource;
//   final String eyebrow; // small label above title
//   final String title;
//   final String subtitle;
//   final Widget Function(Animation<double> float) illustrationBuilder;
//   final Color bgFrom;
//   final Color bgTo;

//   const _PageData({
//     required this.arabicText,
//     required this.arabicSource,
//     required this.eyebrow,
//     required this.title,
//     required this.subtitle,
//     required this.illustrationBuilder,
//     required this.bgFrom,
//     required this.bgTo,
//   });
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // MAIN SCREEN
// // ═══════════════════════════════════════════════════════════════════════════
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen>
//     with TickerProviderStateMixin {
//   final _pageCtrl = PageController();
//   int _cur = 0;

//   late final AnimationController _fadeCtrl;
//   late final AnimationController _floatCtrl;
//   late final Animation<double> _fadeAnim;
//   late final Animation<double> _floatAnim;

//   // ── Pages ────────────────────────────────────────────────────────────────
//   late final List<_PageData> _pages = [
//     // ── Page 1: Welcome ─────────────────────────────────────────────────
//     _PageData(
//       arabicText: 'إِنَّ اللَّهَ لَا يُضِيعُ أَجْرَ الْمُحْسِنِينَ',
//       arabicSource: 'সূরা তাওবাহ · ৯:১২০',
//       eyebrow: 'স্বাগতম Sabeq-এ',
//       title: 'প্রতিটা আমলই\nহিসাবে আছে',
//       subtitle:
//           'আল্লাহ একটা নেক কাজও নষ্ট করেন না।\nSabeq তোমাকে সেই আমলগুলো মনে রাখতে সাহায্য করে — প্রতিদিন, অভ্যাস হিসেবে।',
//       illustrationBuilder: (f) => _MosqueIllustration(floatAnim: f),
//       bgFrom: const Color(0xFF021F10),
//       bgTo: const Color(0xFF0A3D22),
//     ),

//     // ── Page 2: Tracker ──────────────────────────────────────────────────
//     _PageData(
//       arabicText: 'وَذَكِّرْ فَإِنَّ الذِّكْرَى تَنفَعُ الْمُؤْمِنِينَ',
//       arabicSource: 'সূরা আয-যারিয়াত · ৫১:৫৫',
//       eyebrow: 'দৈনিক ট্র্যাকার',
//       title: 'ছোট ছোট আমল\nবড় পরিবর্তন আনে',
//       subtitle:
//           'ফজর থেকে এশা, কোরআন থেকে যিকির —\nসবকিছু এক জায়গায়। একদিন মিস হলেও হতাশ হওয়ার কিছু নেই, পরের দিন আবার শুরু করো।',
//       illustrationBuilder: (f) => _TrackerIllustration(floatAnim: f),
//       bgFrom: const Color(0xFF082E18),
//       bgTo: const Color(0xFF124A28),
//     ),

//     // ── Page 3: Leaderboard ──────────────────────────────────────────────
//     _PageData(
//       arabicText: 'وَفِي ذَٰلِكَ فَلْيَتَنَافَسِ الْمُتَنَافِسُونَ',
//       arabicSource: 'সূরা আল-মুতাফফিফীন · ৮৩:২৬',
//       eyebrow: 'লিডারবোর্ড',
//       title: 'নেক কাজে\nএগিয়ে থাকার\nপ্রতিযোগিতা',
//       subtitle:
//           'বন্ধু বা পরিবারের সাথে নেক আমলে এগিয়ে যাও।\nতুমি চাইলে নাম গোপন রেখেও থাকতে পারবে — শুধু আমলটাই আসল।',
//       illustrationBuilder: (f) => _LeaderboardIllustration(floatAnim: f),
//       bgFrom: const Color(0xFF0E3D20),
//       bgTo: const Color(0xFF1A5C30),
//     ),

//     // ── Page 4: Privacy ──────────────────────────────────────────────────
//     _PageData(
//       arabicText: 'وَاللَّهُ يَعْلَمُ مَا تُسِرُّونَ وَمَا تُعْلِنُونَ',
//       arabicSource: 'সূরা আন-নাহল · ১৬:১৯',
//       eyebrow: 'তোমার গোপনীয়তা',
//       title: 'আমল তোমার,\nশেয়ার করা\nতোমার ইচ্ছা',
//       subtitle:
//           'নিজের স্কোর লুকাতে পারবে, নাম Anonymous রাখতে পারবে।\nআল্লাহ তো সব জানেনই — তাঁর কাছে কিছুই লুকানো নেই।',
//       illustrationBuilder: (f) => _PrivacyIllustration(floatAnim: f),
//       bgFrom: const Color(0xFF052818),
//       bgTo: const Color(0xFF0D4425),
//     ),
//   ];

//   bool get _isLast => _cur == _pages.length - 1;

//   @override
//   void initState() {
//     super.initState();
//     _fadeCtrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 550));
//     _floatCtrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 2800))
//       ..repeat(reverse: true);

//     _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
//     _floatAnim = CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut);
//     _fadeCtrl.forward();
//   }

//   @override
//   void dispose() {
//     _pageCtrl.dispose();
//     _fadeCtrl.dispose();
//     _floatCtrl.dispose();
//     super.dispose();
//   }

//   void _onPageChanged(int i) {
//     _fadeCtrl.reset();
//     _fadeCtrl.forward();
//     setState(() => _cur = i);
//   }

//   Future<void> _complete() async {
//     await markOnboardingSeen();
//     onboardingSeenNotifier.value = true;
//     if (mounted) context.go(AppRoutes.login);
//   }

//   void _next() => _pageCtrl.nextPage(
//         duration: const Duration(milliseconds: 420),
//         curve: Curves.easeInOutCubic,
//       );

//   // ── Build ────────────────────────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     final page = _pages[_cur];

//     return Scaffold(
//       backgroundColor: page.bgFrom,
//       body: AnimatedContainer(
//         duration: const Duration(milliseconds: 480),
//         curve: Curves.easeInOut,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [page.bgFrom, page.bgTo],
//           ),
//         ),
//         child: Stack(
//           children: [
//             // Islamic geometric bg
//             const Positioned.fill(child: _BgPattern()),

//             // Pages
//             PageView.builder(
//               controller: _pageCtrl,
//               onPageChanged: _onPageChanged,
//               itemCount: _pages.length,
//               itemBuilder: (_, i) => _Page(
//                 data: _pages[i],
//                 floatAnim: _floatAnim,
//                 fadeAnim: _fadeAnim,
//               ),
//             ),

//             // ── Top bar ─────────────────────────────────────────────────
//             Positioned(
//               top: 0,
//               left: 0,
//               right: 0,
//               child: SafeArea(
//                 bottom: false,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // Brand
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           // Logo box — fixed 34×34
//                           Container(
//                             width: 34,
//                             height: 34,
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.13),
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(
//                                   color: Colors.white.withOpacity(0.25)),
//                             ),
//                             alignment: Alignment.center,
//                             child: const Text(
//                               'س',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 19,
//                                 fontWeight: FontWeight.w700,
//                                 height: 1,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 9),
//                           const Text(
//                             'Sabeq',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 17,
//                               fontWeight: FontWeight.w700,
//                               letterSpacing: 0.4,
//                             ),
//                           ),
//                         ],
//                       ),
//                       // Skip — intrinsic size, never stretches
//                       AnimatedOpacity(
//                         opacity: _isLast ? 0 : 1,
//                         duration: const Duration(milliseconds: 250),
//                         child: GestureDetector(
//                           onTap: _isLast ? null : _complete,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 14, vertical: 7),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.13),
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                   color: Colors.white.withOpacity(0.25)),
//                             ),
//                             child: const Text(
//                               'এড়িয়ে যাও',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // ── Bottom controls ──────────────────────────────────────────
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               child: _BottomBar(
//                 cur: _cur,
//                 total: _pages.length,
//                 isLast: _isLast,
//                 onNext: _next,
//                 onComplete: _complete,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // SINGLE PAGE
// // ═══════════════════════════════════════════════════════════════════════════
// class _Page extends StatelessWidget {
//   final _PageData data;
//   final Animation<double> floatAnim;
//   final Animation<double> fadeAnim;

//   const _Page({
//     required this.data,
//     required this.floatAnim,
//     required this.fadeAnim,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final topPad = MediaQuery.of(context).padding.top + 64;

//     return Column(
//       children: [
//         // ── Illustration (top 48%) ───────────────────────────────────────
//         SizedBox(
//           height: size.height * 0.48,
//           child: Padding(
//             padding: EdgeInsets.only(top: topPad),
//             child: AnimatedBuilder(
//               animation: floatAnim,
//               builder: (_, child) => Transform.translate(
//                 offset: Offset(0, (floatAnim.value - 0.5) * 16),
//                 child: child,
//               ),
//               child: data.illustrationBuilder(floatAnim),
//             ),
//           ),
//         ),

//         // ── Text content (bottom 52%) ────────────────────────────────────
//         Expanded(
//           child: FadeTransition(
//             opacity: fadeAnim,
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(26, 8, 26, 110),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Ayat card
//                   _AyatCard(
//                     arabic: data.arabicText,
//                     source: data.arabicSource,
//                   ),
//                   const SizedBox(height: 18),

//                   // Eyebrow
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: _C.gold.withOpacity(0.18),
//                       borderRadius: BorderRadius.circular(6),
//                       border: Border.all(
//                           color: _C.gold.withOpacity(0.35), width: 1),
//                     ),
//                     child: Text(
//                       data.eyebrow,
//                       style: TextStyle(
//                         color: _C.gold.withOpacity(0.9),
//                         fontSize: 11,
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: 0.8,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   // Title
//                   Text(
//                     data.title,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 26,
//                       fontWeight: FontWeight.w800,
//                       height: 1.28,
//                       letterSpacing: -0.4,
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   // Subtitle
//                   Text(
//                     data.subtitle,
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.72),
//                       fontSize: 13.5,
//                       fontWeight: FontWeight.w400,
//                       height: 1.7,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // AYAT CARD
// // ═══════════════════════════════════════════════════════════════════════════
// class _AyatCard extends StatelessWidget {
//   final String arabic;
//   final String source;
//   const _AyatCard({required this.arabic, required this.source});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.07),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: _C.gold.withOpacity(0.35), width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           // Gold left accent line + arabic
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Text(
//                   arabic,
//                   textAlign: TextAlign.right,
//                   style: const TextStyle(
//                     color: _C.gold,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                     height: 1.75,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Row(
//             children: [
//               Container(
//                 width: 3,
//                 height: 3,
//                 decoration: BoxDecoration(
//                   color: _C.gold.withOpacity(0.6),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               const SizedBox(width: 5),
//               Text(
//                 source,
//                 style: TextStyle(
//                   color: _C.gold.withOpacity(0.65),
//                   fontSize: 11,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // BOTTOM BAR
// // ═══════════════════════════════════════════════════════════════════════════
// class _BottomBar extends StatelessWidget {
//   final int cur;
//   final int total;
//   final bool isLast;
//   final VoidCallback onNext;
//   final VoidCallback onComplete;

//   const _BottomBar({
//     required this.cur,
//     required this.total,
//     required this.isLast,
//     required this.onNext,
//     required this.onComplete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(
//           26, 18, 26, MediaQuery.of(context).padding.bottom + 22),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.transparent, Colors.black.withOpacity(0.28)],
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Dots
//           Row(
//             children: List.generate(total, (i) {
//               final active = i == cur;
//               return AnimatedContainer(
//                 duration: const Duration(milliseconds: 280),
//                 curve: Curves.easeInOut,
//                 margin: const EdgeInsets.only(right: 6),
//                 width: active ? 22 : 7,
//                 height: 7,
//                 decoration: BoxDecoration(
//                   color: active ? Colors.white : Colors.white.withOpacity(0.3),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               );
//             }),
//           ),

//           // Button
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 280),
//             transitionBuilder: (child, anim) =>
//                 ScaleTransition(scale: anim, child: child),
//             child: isLast
//                 ? _StartButton(key: const ValueKey('start'), onTap: onComplete)
//                 : _NextBtn(key: const ValueKey('next'), onTap: onNext),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _NextBtn extends StatelessWidget {
//   final VoidCallback onTap;
//   const _NextBtn({super.key, required this.onTap});

//   @override
//   Widget build(BuildContext context) => GestureDetector(
//         onTap: onTap,
//         child: Container(
//           width: 54,
//           height: 54,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.black.withOpacity(0.22),
//                   blurRadius: 14,
//                   offset: const Offset(0, 5))
//             ],
//           ),
//           child: const Icon(Icons.arrow_forward_rounded,
//               color: _C.darkGreen, size: 23),
//         ),
//       );
// }

// class _StartButton extends StatelessWidget {
//   final VoidCallback onTap;
//   const _StartButton({super.key, required this.onTap});

//   @override
//   Widget build(BuildContext context) => GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
//           decoration: BoxDecoration(
//             color: _C.gold,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                   color: _C.gold.withOpacity(0.45),
//                   blurRadius: 18,
//                   offset: const Offset(0, 6))
//             ],
//           ),
//           child: const Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('শুরু করি',
//                   style: TextStyle(
//                       color: _C.darkGreen,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w800,
//                       letterSpacing: 0.3)),
//               SizedBox(width: 8),
//               Icon(Icons.arrow_forward_rounded, color: _C.darkGreen, size: 19),
//             ],
//           ),
//         ),
//       );
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // GLASS BOX helper
// // ═══════════════════════════════════════════════════════════════════════════
// class _GlassBox extends StatelessWidget {
//   final Widget child;
//   final double? size;
//   final double px;
//   final double py;
//   final double radius;

//   const _GlassBox({
//     required this.child,
//     this.size,
//     this.px = 0,
//     this.py = 0,
//     this.radius = 8,
//   });

//   @override
//   Widget build(BuildContext context) {
//     Widget inner = Container(
//       width: size,
//       height: size,
//       padding: EdgeInsets.symmetric(horizontal: px, vertical: py),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.13),
//         borderRadius: BorderRadius.circular(radius),
//         border: Border.all(color: Colors.white.withOpacity(0.25)),
//       ),
//       child: Center(child: child),
//     );
//     return inner;
//   }
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // BACKGROUND PATTERN
// // ═══════════════════════════════════════════════════════════════════════════
// class _BgPattern extends StatelessWidget {
//   const _BgPattern();

//   @override
//   Widget build(BuildContext context) =>
//       CustomPaint(painter: _PatternPainter(), size: Size.infinite);
// }

// class _PatternPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final p = Paint()
//       ..color = Colors.white.withOpacity(0.035)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1;

//     const s = 72.0;
//     for (double x = -s; x < size.width + s; x += s) {
//       for (double y = -s; y < size.height + s; y += s) {
//         _oct(canvas, Offset(x, y), 24, p);
//       }
//     }
//   }

//   void _oct(Canvas canvas, Offset c, double r, Paint p) {
//     final path = Path();
//     for (int i = 0; i < 8; i++) {
//       final a = (i * math.pi / 4) - math.pi / 8;
//       final pt = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
//       i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
//     }
//     path.close();
//     canvas.drawPath(path, p);
//   }

//   @override
//   bool shouldRepaint(_PatternPainter _) => false;
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // ILLUSTRATIONS
// // ═══════════════════════════════════════════════════════════════════════════

// // ── Page 1: Mosque ────────────────────────────────────────────────────────
// class _MosqueIllustration extends StatelessWidget {
//   final Animation<double> floatAnim;
//   const _MosqueIllustration({required this.floatAnim});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final s = size.width * 0.78;
//     return Center(
//       child: CustomPaint(
//         painter: _MosquePainter(),
//         size: Size(s, s),
//       ),
//     );
//   }
// }

// class _MosquePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;

//     // Shadow ground
//     canvas.drawOval(
//       Rect.fromCenter(
//           center: Offset(cx, cy + size.height * 0.35),
//           width: size.width * 0.82,
//           height: size.height * 0.1),
//       Paint()
//         ..color = Colors.black.withOpacity(0.2)
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
//     );

//     final white = Paint()..color = Colors.white.withOpacity(0.93);
//     final white2 = Paint()..color = Colors.white.withOpacity(0.78);
//     final gold = Paint()..color = _C.gold;
//     final goldFt = Paint()..color = _C.gold.withOpacity(0.85);

//     // ── Body ──────────────────────────────────────────────────────────────
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromLTWH(cx - size.width * 0.28, cy - size.height * 0.08,
//             size.width * 0.56, size.height * 0.43),
//         const Radius.circular(5),
//       ),
//       white,
//     );

//     // ── Main dome ─────────────────────────────────────────────────────────
//     _dome(canvas, Offset(cx, cy - size.height * 0.08), size.width * 0.21,
//         size.height * 0.22, goldFt);

//     // ── Side domes ────────────────────────────────────────────────────────
//     _dome(canvas, Offset(cx - size.width * 0.2, cy - size.height * 0.04),
//         size.width * 0.1, size.height * 0.11, white2);
//     _dome(canvas, Offset(cx + size.width * 0.2, cy - size.height * 0.04),
//         size.width * 0.1, size.height * 0.11, white2);

//     // ── Minarets ──────────────────────────────────────────────────────────
//     for (final sx in [-1.0, 1.0]) {
//       final mx = cx + sx * size.width * 0.31;
//       // shaft
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromCenter(
//               center: Offset(mx, cy + size.height * 0.04),
//               width: size.width * 0.055,
//               height: size.height * 0.5),
//           const Radius.circular(4),
//         ),
//         white2,
//       );
//       // balcony
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromCenter(
//               center: Offset(mx, cy - size.height * 0.1),
//               width: size.width * 0.1,
//               height: size.height * 0.025),
//           const Radius.circular(3),
//         ),
//         goldFt,
//       );
//       // mini dome
//       _dome(canvas, Offset(mx, cy - size.height * 0.22), size.width * 0.042,
//           size.height * 0.08, goldFt);
//       // spire
//       canvas.drawLine(
//         Offset(mx, cy - size.height * 0.3),
//         Offset(mx, cy - size.height * 0.22),
//         Paint()
//           ..color = _C.gold
//           ..strokeWidth = 2
//           ..strokeCap = StrokeCap.round,
//       );
//     }

//     // ── Arched door ───────────────────────────────────────────────────────
//     final doorW = size.width * 0.13;
//     final doorH = size.height * 0.17;
//     final doorT = cy + size.height * 0.08;
//     final doorPaint = Paint()..color = _C.greenMid.withOpacity(0.55);
//     final doorPath = Path()
//       ..moveTo(cx - doorW / 2, doorT + doorH)
//       ..lineTo(cx - doorW / 2, doorT + doorW / 2)
//       ..addArc(
//           Rect.fromCenter(
//               center: Offset(cx, doorT + doorW / 2),
//               width: doorW,
//               height: doorW),
//           math.pi,
//           math.pi)
//       ..lineTo(cx + doorW / 2, doorT + doorH)
//       ..close();
//     canvas.drawPath(doorPath, doorPaint);

//     // ── Arched windows ────────────────────────────────────────────────────
//     for (final sx in [-1.0, 1.0]) {
//       final wx = cx + sx * size.width * 0.17;
//       final wy = cy + size.height * 0.08;
//       final ww = size.width * 0.09;
//       final winPaint = Paint()..color = _C.gold.withOpacity(0.55);
//       final winPath = Path()
//         ..moveTo(wx - ww / 2, wy + ww * 0.85)
//         ..lineTo(wx - ww / 2, wy + ww / 2)
//         ..addArc(
//             Rect.fromCenter(
//                 center: Offset(wx, wy + ww / 2), width: ww, height: ww),
//             math.pi,
//             math.pi)
//         ..lineTo(wx + ww / 2, wy + ww * 0.85)
//         ..close();
//       canvas.drawPath(winPath, winPaint);
//     }

//     // ── Crescent on main dome ─────────────────────────────────────────────
//     _crescent(
//         canvas, Offset(cx, cy - size.height * 0.3), size.width * 0.055, gold);

//     // ── Stars ─────────────────────────────────────────────────────────────
//     final starP = Paint()..color = _C.gold.withOpacity(0.65);
//     for (final (ox, oy) in [
//       (-0.37, -0.37),
//       (0.38, -0.3),
//       (0.14, -0.41),
//     ]) {
//       _star(canvas, Offset(cx + ox * size.width, cy + oy * size.height),
//           size.width * 0.022, starP);
//     }
//   }

//   void _dome(Canvas canvas, Offset c, double w, double h, Paint p) {
//     canvas.drawPath(
//       Path()
//         ..moveTo(c.dx - w, c.dy)
//         ..cubicTo(c.dx - w, c.dy - h * 1.35, c.dx + w, c.dy - h * 1.35,
//             c.dx + w, c.dy)
//         ..close(),
//       p,
//     );
//   }

//   void _crescent(Canvas canvas, Offset c, double r, Paint p) {
//     canvas.drawPath(
//       Path.combine(
//         PathOperation.difference,
//         Path()..addOval(Rect.fromCircle(center: c, radius: r)),
//         Path()
//           ..addOval(Rect.fromCircle(
//               center: Offset(c.dx + r * 0.45, c.dy - r * 0.1),
//               radius: r * 0.75)),
//       ),
//       p,
//     );
//   }

//   void _star(Canvas canvas, Offset c, double r, Paint p) {
//     final path = Path();
//     for (int i = 0; i < 5; i++) {
//       final o = Offset(c.dx + r * math.cos(i * 4 * math.pi / 5 - math.pi / 2),
//           c.dy + r * math.sin(i * 4 * math.pi / 5 - math.pi / 2));
//       final inn = Offset(
//           c.dx + r * 0.4 * math.cos((i * 4 + 2) * math.pi / 5 - math.pi / 2),
//           c.dy + r * 0.4 * math.sin((i * 4 + 2) * math.pi / 5 - math.pi / 2));
//       i == 0 ? path.moveTo(o.dx, o.dy) : path.lineTo(o.dx, o.dy);
//       path.lineTo(inn.dx, inn.dy);
//     }
//     canvas.drawPath(path..close(), p);
//   }

//   @override
//   bool shouldRepaint(_MosquePainter _) => false;
// }

// // ── Page 2: Tracker phone mockup ─────────────────────────────────────────
// class _TrackerIllustration extends StatelessWidget {
//   final Animation<double> floatAnim;
//   const _TrackerIllustration({required this.floatAnim});

//   @override
//   Widget build(BuildContext context) {
//     final s = MediaQuery.of(context).size;
//     return Center(
//       child: CustomPaint(
//         painter: _TrackerPainter(),
//         size: Size(s.width * 0.62, s.height * 0.38),
//       ),
//     );
//   }
// }

// class _TrackerPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;
//     final pw = size.width;
//     final ph = size.height;

//     // Phone frame
//     final frame = RRect.fromRectAndRadius(
//       Rect.fromCenter(center: Offset(cx, cy), width: pw, height: ph),
//       const Radius.circular(22),
//     );
//     canvas.drawRRect(
//         frame,
//         Paint()
//           ..color = Colors.black.withOpacity(0.22)
//           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
//     canvas.drawRRect(frame, Paint()..color = Colors.white.withOpacity(0.96));

//     // Header bar
//     canvas.drawRRect(
//       RRect.fromRectAndCorners(
//         Rect.fromLTWH(cx - pw / 2, cy - ph / 2, pw, ph * 0.115),
//         topLeft: const Radius.circular(22),
//         topRight: const Radius.circular(22),
//       ),
//       Paint()..color = _C.darkGreen,
//     );
//     // header text blobs
//     _blob(canvas, Offset(cx - pw * 0.12, cy - ph * 0.43), pw * 0.22, 5,
//         Colors.white.withOpacity(0.7), 3);
//     _blob(canvas, Offset(cx + pw * 0.28, cy - ph * 0.43), pw * 0.1, 5,
//         _C.gold.withOpacity(0.8), 3);

//     // Date row
//     for (int d = 0; d < 7; d++) {
//       final dx = cx - pw * 0.38 + d * pw * 0.125;
//       final active = d == 3;
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromCenter(
//               center: Offset(dx, cy - ph * 0.31),
//               width: pw * 0.1,
//               height: ph * 0.1),
//           const Radius.circular(8),
//         ),
//         Paint()..color = active ? _C.gold : Colors.grey.withOpacity(0.12),
//       );
//       _blob(canvas, Offset(dx, cy - ph * 0.31), pw * 0.055, 4,
//           active ? _C.darkGreen : Colors.grey.withOpacity(0.4), 2);
//     }

//     // Amal rows
//     final rows = [
//       ('ফজর', true, _C.greenAccent),
//       ('যোহর', true, _C.greenAccent),
//       ('আসর', true, _C.greenAccent),
//       ('মাগরিব', false, _C.gold),
//       ('এশা', false, Colors.grey),
//       ('কোরআন', true, _C.greenAccent),
//     ];

//     for (int i = 0; i < rows.length; i++) {
//       final (_, done, color) = rows[i];
//       final ry = cy - ph * 0.15 + i * ph * 0.105;

//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromCenter(
//               center: Offset(cx, ry), width: pw * 0.85, height: ph * 0.085),
//           const Radius.circular(9),
//         ),
//         Paint()
//           ..color =
//               done ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
//       );

//       // Checkbox
//       final cbC = Offset(cx - pw * 0.36, ry);
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromCenter(center: cbC, width: 15, height: 15),
//           const Radius.circular(4),
//         ),
//         Paint()..color = done ? color : Colors.grey.withOpacity(0.2),
//       );
//       if (done) {
//         final ck = Paint()
//           ..color = Colors.white
//           ..strokeWidth = 2
//           ..style = PaintingStyle.stroke
//           ..strokeCap = StrokeCap.round;
//         canvas.drawLine(
//             Offset(cbC.dx - 4, cbC.dy), Offset(cbC.dx - 1, cbC.dy + 3), ck);
//         canvas.drawLine(
//             Offset(cbC.dx - 1, cbC.dy + 3), Offset(cbC.dx + 5, cbC.dy - 3), ck);
//       }

//       // label blob
//       _blob(canvas, Offset(cx - pw * 0.14, ry), pw * 0.32, 5,
//           done ? color.withOpacity(0.5) : Colors.grey.withOpacity(0.25), 3);
//       // points chip
//       _blob(canvas, Offset(cx + pw * 0.32, ry), pw * 0.1, 13,
//           done ? color.withOpacity(0.2) : Colors.transparent, 6);
//     }

//     // Progress bar
//     final pbY = cy + ph * 0.45;
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(Rect.fromLTWH(cx - pw * 0.38, pbY, pw * 0.76, 5),
//           const Radius.circular(3)),
//       Paint()..color = Colors.grey.withOpacity(0.15),
//     );
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//           Rect.fromLTWH(cx - pw * 0.38, pbY, pw * 0.76 * 0.67, 5),
//           const Radius.circular(3)),
//       Paint()..color = _C.greenAccent,
//     );
//     _blob(canvas, Offset(cx + pw * 0.2, pbY + 12), pw * 0.22, 5,
//         Colors.grey.withOpacity(0.3), 2);
//   }

//   void _blob(
//       Canvas canvas, Offset c, double w, double h, Color color, double r) {
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//           Rect.fromCenter(center: c, width: w, height: h), Radius.circular(r)),
//       Paint()..color = color,
//     );
//   }

//   @override
//   bool shouldRepaint(_TrackerPainter _) => false;
// }

// // ── Page 3: Leaderboard ───────────────────────────────────────────────────
// class _LeaderboardIllustration extends StatelessWidget {
//   final Animation<double> floatAnim;
//   const _LeaderboardIllustration({required this.floatAnim});

//   @override
//   Widget build(BuildContext context) {
//     final s = MediaQuery.of(context).size;
//     return Center(
//       child: CustomPaint(
//         painter: _LeaderboardPainter(),
//         size: Size(s.width * 0.78, s.height * 0.38),
//       ),
//     );
//   }
// }

// class _LeaderboardPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;

//     // ── Trophy ────────────────────────────────────────────────────────────
//     _trophy(canvas, Offset(cx, cy - size.height * 0.3), size.width * 0.18);

//     // ── Podium blocks ─────────────────────────────────────────────────────
//     final bw = size.width * 0.26;
//     final baseY = cy + size.height * 0.42;

//     // 2nd
//     _podium(canvas, Offset(cx - bw * 1.05, baseY), bw * 0.9, size.height * 0.28,
//         Colors.white.withOpacity(0.7), '২');
//     // 1st
//     _podium(canvas, Offset(cx, baseY), bw, size.height * 0.42, _C.gold, '১');
//     // 3rd
//     _podium(canvas, Offset(cx + bw * 1.05, baseY), bw * 0.9, size.height * 0.2,
//         _C.greenAccent.withOpacity(0.75), '৩');

//     // ── Avatars ───────────────────────────────────────────────────────────
//     _avatar(canvas, Offset(cx - bw * 1.05, baseY - size.height * 0.28 - 30), 22,
//         Colors.white.withOpacity(0.85), _C.textSecondary);

//     // 1st avatar with glow
//     canvas.drawCircle(
//         Offset(cx, baseY - size.height * 0.42 - 30),
//         32,
//         Paint()
//           ..color = _C.gold.withOpacity(0.3)
//           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
//     _avatar(canvas, Offset(cx, baseY - size.height * 0.42 - 30), 26, _C.gold,
//         _C.darkGreen);

//     _avatar(canvas, Offset(cx + bw * 1.05, baseY - size.height * 0.2 - 28), 20,
//         _C.greenAccent, Colors.white);

//     // ── Ray burst around 1st ──────────────────────────────────────────────
//     final rp = Paint()
//       ..color = _C.gold.withOpacity(0.4)
//       ..strokeWidth = 1.5;
//     for (int i = 0; i < 8; i++) {
//       final a = i * math.pi / 4;
//       final oc = Offset(cx, baseY - size.height * 0.42 - 30);
//       canvas.drawLine(
//         Offset(oc.dx + 38 * math.cos(a), oc.dy + 38 * math.sin(a)),
//         Offset(oc.dx + 50 * math.cos(a), oc.dy + 50 * math.sin(a)),
//         rp,
//       );
//     }

//     // ── Anonymous badge (privacy hint) ───────────────────────────────────
//     // small "?" avatar on a floating card — hints at the privacy feature
//     final badgeC = Offset(cx + size.width * 0.38, cy - size.height * 0.05);
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(center: badgeC, width: 54, height: 32),
//         const Radius.circular(10),
//       ),
//       Paint()
//         ..color = Colors.white.withOpacity(0.12)
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
//     );
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(center: badgeC, width: 54, height: 32),
//         const Radius.circular(10),
//       ),
//       Paint()..color = Colors.white.withOpacity(0.1),
//     );
//     // anon icon circle
//     canvas.drawCircle(Offset(badgeC.dx - 8, badgeC.dy), 10,
//         Paint()..color = Colors.white.withOpacity(0.25));
//     canvas.drawLine(
//       Offset(badgeC.dx - 12, badgeC.dy - 2),
//       Offset(badgeC.dx - 4, badgeC.dy - 2),
//       Paint()
//         ..color = Colors.white.withOpacity(0.6)
//         ..strokeWidth = 2
//         ..strokeCap = StrokeCap.round,
//     );
//     // "?" text
//     final qPainter = TextPainter(
//       text: TextSpan(
//         text: '?',
//         style: TextStyle(
//             color: Colors.white.withOpacity(0.7),
//             fontSize: 13,
//             fontWeight: FontWeight.w700),
//       ),
//       textDirection: TextDirection.ltr,
//     )..layout();
//     qPainter.paint(canvas, Offset(badgeC.dx + 10, badgeC.dy - 9));
//   }

//   void _podium(Canvas canvas, Offset base, double w, double h, Color color,
//       String rank) {
//     canvas.drawRRect(
//       RRect.fromRectAndCorners(
//         Rect.fromLTWH(base.dx - w / 2, base.dy - h, w, h),
//         topLeft: const Radius.circular(10),
//         topRight: const Radius.circular(10),
//       ),
//       Paint()..color = color,
//     );
//     // rank number
//     final tp = TextPainter(
//       text: TextSpan(
//         text: rank,
//         style: TextStyle(
//           color: rank == '১' ? _C.darkGreen : Colors.white.withOpacity(0.85),
//           fontSize: 16,
//           fontWeight: FontWeight.w800,
//         ),
//       ),
//       textDirection: TextDirection.ltr,
//     )..layout();
//     tp.paint(canvas, Offset(base.dx - tp.width / 2, base.dy - 24));
//   }

//   void _avatar(Canvas canvas, Offset c, double r, Color bg, Color fg) {
//     canvas.drawCircle(c, r + 3, Paint()..color = Colors.white.withOpacity(0.2));
//     canvas.drawCircle(c, r, Paint()..color = bg);
//     // head
//     canvas.drawCircle(Offset(c.dx, c.dy - r * 0.27), r * 0.33,
//         Paint()..color = fg.withOpacity(0.85));
//     // body arc
//     canvas.drawArc(
//       Rect.fromCenter(
//           center: Offset(c.dx, c.dy + r * 0.45), width: r * 1.1, height: r),
//       math.pi,
//       math.pi,
//       false,
//       Paint()
//         ..color = fg.withOpacity(0.85)
//         ..style = PaintingStyle.fill,
//     );
//   }

//   void _trophy(Canvas canvas, Offset c, double r) {
//     final p = Paint()..color = _C.gold;
//     // cup
//     canvas.drawPath(
//       Path()
//         ..moveTo(c.dx - r, c.dy - r * 0.3)
//         ..cubicTo(c.dx - r * 1.2, c.dy + r * 0.7, c.dx + r * 1.2,
//             c.dy + r * 0.7, c.dx + r, c.dy - r * 0.3)
//         ..lineTo(c.dx + r * 0.6, c.dy - r)
//         ..lineTo(c.dx - r * 0.6, c.dy - r)
//         ..close(),
//       p,
//     );
//     // handles
//     for (final sx in [-1.0, 1.0]) {
//       canvas.drawArc(
//         Rect.fromCenter(
//             center: Offset(c.dx + sx * r * 0.98, c.dy - r * 0.15),
//             width: r * 0.55,
//             height: r * 0.65),
//         sx > 0 ? -math.pi / 2 : math.pi / 2,
//         math.pi,
//         false,
//         Paint()
//           ..color = _C.gold
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = r * 0.14,
//       );
//     }
//     // stem + base
//     canvas.drawRect(
//         Rect.fromCenter(
//             center: Offset(c.dx, c.dy + r * 0.9),
//             width: r * 0.22,
//             height: r * 0.45),
//         p);
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(
//             center: Offset(c.dx, c.dy + r * 1.22),
//             width: r * 0.85,
//             height: r * 0.18),
//         const Radius.circular(4),
//       ),
//       p,
//     );
//   }

//   @override
//   bool shouldRepaint(_LeaderboardPainter _) => false;
// }

// // ── Page 4: Privacy illustration ─────────────────────────────────────────
// class _PrivacyIllustration extends StatelessWidget {
//   final Animation<double> floatAnim;
//   const _PrivacyIllustration({required this.floatAnim});

//   @override
//   Widget build(BuildContext context) {
//     final s = MediaQuery.of(context).size;
//     return Center(
//       child: AnimatedBuilder(
//         animation: floatAnim,
//         builder: (_, child) => child!,
//         child: CustomPaint(
//           painter: _PrivacyPainter(),
//           size: Size(s.width * 0.72, s.height * 0.36),
//         ),
//       ),
//     );
//   }
// }

// class _PrivacyPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;

//     // ── Central shield ────────────────────────────────────────────────────
//     final sr = size.width * 0.22;
//     final shieldPath = Path()
//       ..moveTo(cx, cy - sr * 1.2)
//       ..cubicTo(cx + sr * 1.2, cy - sr * 0.8, cx + sr * 1.2, cy + sr * 0.4, cx,
//           cy + sr * 1.2)
//       ..cubicTo(cx - sr * 1.2, cy + sr * 0.4, cx - sr * 1.2, cy - sr * 0.8, cx,
//           cy - sr * 1.2)
//       ..close();

//     // glow
//     canvas.drawPath(
//       shieldPath,
//       Paint()
//         ..color = _C.greenAccent.withOpacity(0.25)
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
//     );
//     // fill
//     canvas.drawPath(shieldPath, Paint()..color = _C.greenMid.withOpacity(0.7));
//     // border
//     canvas.drawPath(
//       shieldPath,
//       Paint()
//         ..color = Colors.white.withOpacity(0.4)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 2.5,
//     );

//     // ── Lock icon inside shield ───────────────────────────────────────────
//     final lw = sr * 0.55;
//     final lh = sr * 0.45;
//     final lbottomY = cy + sr * 0.2;
//     // body
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(center: Offset(cx, lbottomY), width: lw, height: lh),
//         const Radius.circular(7),
//       ),
//       Paint()..color = Colors.white.withOpacity(0.9),
//     );
//     // shackle
//     canvas.drawArc(
//       Rect.fromCenter(
//           center: Offset(cx, lbottomY - lh / 2),
//           width: lw * 0.6,
//           height: lw * 0.6),
//       math.pi,
//       math.pi,
//       false,
//       Paint()
//         ..color = Colors.white.withOpacity(0.9)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 4
//         ..strokeCap = StrokeCap.round,
//     );
//     // keyhole
//     canvas.drawCircle(
//         Offset(cx, lbottomY - 2), 5, Paint()..color = _C.greenMid);
//     canvas.drawRect(
//       Rect.fromCenter(center: Offset(cx, lbottomY + 7), width: 4, height: 9),
//       Paint()..color = _C.greenMid,
//     );

//     // ── Floating feature cards ────────────────────────────────────────────
//     final cards = [
//       (
//         cx - size.width * 0.38,
//         cy - size.height * 0.22,
//         Icons.visibility_off_rounded,
//         'আমল লুকাও'
//       ),
//       (
//         cx + size.width * 0.32,
//         cy - size.height * 0.22,
//         Icons.person_off_rounded,
//         'নাম গোপন'
//       ),
//       (
//         cx - size.width * 0.38,
//         cy + size.height * 0.22,
//         Icons.share_rounded,
//         'নিজে শেয়ার করো'
//       ),
//     ];

//     for (final (fx, fy, icon, label) in cards) {
//       _featureCard(canvas, Offset(fx, fy), icon, label, size);
//     }

//     // ── Connecting dashed lines from cards to shield ───────────────────
//     final dashP = Paint()
//       ..color = Colors.white.withOpacity(0.2)
//       ..strokeWidth = 1.5
//       ..style = PaintingStyle.stroke;

//     for (final (fx, fy, _, __) in cards) {
//       _dashedLine(canvas, Offset(fx, fy), Offset(cx, cy), dashP);
//     }
//   }

//   void _featureCard(
//       Canvas canvas, Offset c, IconData icon, String label, Size size) {
//     final w = size.width * 0.3;
//     final h = size.height * 0.22;

//     // card bg with glow
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(center: c, width: w + 6, height: h + 6),
//         const Radius.circular(14),
//       ),
//       Paint()
//         ..color = _C.greenAccent.withOpacity(0.12)
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
//     );
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(center: c, width: w, height: h),
//         const Radius.circular(12),
//       ),
//       Paint()..color = Colors.white.withOpacity(0.1),
//     );
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(center: c, width: w, height: h),
//         const Radius.circular(12),
//       ),
//       Paint()
//         ..color = Colors.white.withOpacity(0.25)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 1,
//     );

//     // icon circle
//     canvas.drawCircle(Offset(c.dx, c.dy - h * 0.14), h * 0.22,
//         Paint()..color = _C.gold.withOpacity(0.25));

//     // label blob
//     final lp = TextPainter(
//       text: TextSpan(
//         text: label,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 9.5,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       textDirection: TextDirection.ltr,
//       textAlign: TextAlign.center,
//     )..layout(maxWidth: w - 10);
//     lp.paint(canvas, Offset(c.dx - lp.width / 2, c.dy + h * 0.1));
//   }

//   void _dashedLine(Canvas canvas, Offset a, Offset b, Paint p) {
//     final dx = b.dx - a.dx;
//     final dy = b.dy - a.dy;
//     final dist = math.sqrt(dx * dx + dy * dy);
//     final nx = dx / dist;
//     final ny = dy / dist;
//     const dash = 5.0;
//     const gap = 4.0;
//     double t = 0;
//     while (t < dist - 40) {
//       canvas.drawLine(
//         Offset(a.dx + nx * t, a.dy + ny * t),
//         Offset(a.dx + nx * (t + dash), a.dy + ny * (t + dash)),
//         p,
//       );
//       t += dash + gap;
//     }
//   }

//   @override
//   bool shouldRepaint(_PrivacyPainter _) => false;
// }
// lib/features/onboarding/onboarding_screen.dart

// import 'dart:math' as math;
// import 'package:amal_tracker/core/router/app_router.dart';
// import 'package:amal_tracker/features/onboarding/provider/onboarding_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// // ══════════════════════════════════════════════════════════════════════════
// // COLORS
// // ══════════════════════════════════════════════════════════════════════════
// class _C {
//   static const darkGreen = Color(0xFF033019);
//   static const greenMid = Color(0xFF2D8A52);
//   static const greenAccent = Color(0xFF4CAF78);
//   static const gold = Color(0xFFF5C842);
//   static const goldLight = Color(0xFFFFF8DC);
//   static const textSec = Color(0xFF5A7A67);
// }

// // ══════════════════════════════════════════════════════════════════════════
// // RESPONSIVE HELPER  — call once per build, pass around
// // ══════════════════════════════════════════════════════════════════════════
// class _R {
//   final double sw; // screen width
//   final double sh; // screen height
//   final double top; // status bar height

//   const _R({required this.sw, required this.sh, required this.top});

//   factory _R.of(BuildContext ctx) {
//     final mq = MediaQuery.of(ctx);
//     return _R(sw: mq.size.width, sh: mq.size.height, top: mq.padding.top);
//   }

//   // ── Breakpoints ────────────────────────────────────────────────────────
//   // compact  : sh < 640  (small phones: SE, Moto G)
//   // normal   : 640 ≤ sh < 800  (most Android flagships, iPhone 14)
//   // large    : sh ≥ 800  (Pro Max, tablets, foldables)
//   bool get isCompact => sh < 640;
//   bool get isLarge => sh >= 800;

//   // ── Scaled values ──────────────────────────────────────────────────────
//   double get illustH => isCompact
//       ? sh * 0.40
//       : isLarge
//           ? sh * 0.46
//           : sh * 0.43;
//   double get topBarPad => top + (isCompact ? 8 : 10);
//   double get illustTopPad => top + (isCompact ? 52 : 62);
//   double get textPadH => isCompact ? 20.0 : 26.0;
//   double get textPadBot => isCompact ? 90.0 : 108.0;
//   double get arabicFs => isCompact ? 13.0 : 15.0;
//   double get titleFs => isCompact
//       ? 22.0
//       : isLarge
//           ? 28.0
//           : 25.0;
//   double get subtitleFs => isCompact ? 12.5 : 13.5;
//   double get meaningFs => isCompact ? 11.5 : 12.5;
//   double get eyebrowFs => isCompact ? 10.0 : 11.0;
//   double get gap1 => isCompact ? 10.0 : 16.0; // ayat → eyebrow
//   double get gap2 => isCompact ? 6.0 : 10.0; // eyebrow → title
//   double get gap3 => isCompact ? 6.0 : 10.0; // title → subtitle
//   double get gap4 => isCompact ? 6.0 : 8.0; // subtitle → meaning
// }

// // ══════════════════════════════════════════════════════════════════════════
// // PAGE MODEL
// // ══════════════════════════════════════════════════════════════════════════
// class _PageData {
//   final String arabic;
//   final String source;
//   final String meaning; // ← বাংলা অর্থ
//   final String eyebrow;
//   final String title;
//   final String subtitle;
//   final Widget Function(Animation<double>, _R) illustrationBuilder;
//   final Color bgFrom;
//   final Color bgTo;

//   const _PageData({
//     required this.arabic,
//     required this.source,
//     required this.meaning,
//     required this.eyebrow,
//     required this.title,
//     required this.subtitle,
//     required this.illustrationBuilder,
//     required this.bgFrom,
//     required this.bgTo,
//   });
// }

// // ══════════════════════════════════════════════════════════════════════════
// // MAIN SCREEN
// // ══════════════════════════════════════════════════════════════════════════
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});
//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen>
//     with TickerProviderStateMixin {
//   final _pageCtrl = PageController();
//   int _cur = 0;

//   late final AnimationController _fadeCtrl;
//   late final AnimationController _floatCtrl;
//   late final Animation<double> _fadeAnim;
//   late final Animation<double> _floatAnim;

//   late final List<_PageData> _pages = [
//     // ── 1. Welcome ────────────────────────────────────────────────────────
//     _PageData(
//       arabic: 'إِنَّ اللَّهَ لَا يُضِيعُ أَجْرَ الْمُحْسِنِينَ',
//       source: 'সূরা তাওবাহ · ৯:১২০',
//       meaning: '"নিশ্চয়ই আল্লাহ সৎকর্মশীলদের প্রতিদান নষ্ট করেন না।"',
//       eyebrow: 'স্বাগতম Sabeq-এ',
//       title: 'প্রতিটা আমলই\nহিসাবে আছে',
//       subtitle: 'আল্লাহ একটা নেক কাজও নষ্ট করেন না।\n'
//           'Sabeq তোমাকে সেই আমলগুলো মনে রাখতে সাহায্য করে — প্রতিদিন, অভ্যাস হিসেবে।',
//       illustrationBuilder: (f, r) => _MosqueIllustration(floatAnim: f, r: r),
//       bgFrom: const Color(0xFF021F10),
//       bgTo: const Color(0xFF0A3D22),
//     ),

//     // ── 2. Tracker ────────────────────────────────────────────────────────
//     _PageData(
//       arabic: 'وَذَكِّرْ فَإِنَّ الذِّكْرَى تَنفَعُ الْمُؤْمِنِينَ',
//       source: 'সূরা আয-যারিয়াত · ৫১:৫৫',
//       meaning:
//           '"স্মরণ করিয়ে দাও, কেননা স্মরণ করিয়ে দেওয়া মুমিনদের উপকার করে।"',
//       eyebrow: 'দৈনিক ট্র্যাকার',
//       title: 'ছোট ছোট আমল\nবড় পরিবর্তন আনে',
//       subtitle: 'ফজর থেকে এশা, কোরআন থেকে যিকির — সবকিছু এক জায়গায়।\n'
//           'একদিন মিস হলেও হতাশ হওয়ার কিছু নেই, পরের দিন আবার শুরু করো।',
//       illustrationBuilder: (f, r) => _TrackerIllustration(floatAnim: f, r: r),
//       bgFrom: const Color(0xFF082E18),
//       bgTo: const Color(0xFF124A28),
//     ),

//     // ── 3. Leaderboard ───────────────────────────────────────────────────
//     _PageData(
//       arabic: 'وَفِي ذَٰلِكَ فَلْيَتَنَافَسِ الْمُتَنَافِسُونَ',
//       source: 'সূরা আল-মুতাফফিফীন · ৮৩:২৬',
//       meaning: '"এটা পেতে প্রতিযোগীরা যেন প্রতিযোগিতা করে।"',
//       eyebrow: 'লিডারবোর্ড',
//       title: 'নেক কাজে\nএগিয়ে থাকার\nপ্রতিযোগিতা',
//       subtitle: 'বন্ধু বা পরিবারের সাথে নেক আমলে এগিয়ে যাও।\n'
//           'চাইলে নাম গোপন রেখেও থাকতে পারবে — শুধু আমলটাই আসল।',
//       illustrationBuilder: (f, r) =>
//           _LeaderboardIllustration(floatAnim: f, r: r),
//       bgFrom: const Color(0xFF0E3D20),
//       bgTo: const Color(0xFF1A5C30),
//     ),

//     // ── 4. Privacy ───────────────────────────────────────────────────────
//     _PageData(
//       arabic: 'وَاللَّهُ يَعْلَمُ مَا تُسِرُّونَ وَمَا تُعْلِنُونَ',
//       source: 'সূরা আন-নাহল · ১৬:১৯',
//       meaning: '"আল্লাহ জানেন যা তোমরা গোপন করো এবং যা তোমরা প্রকাশ করো।"',
//       eyebrow: 'তোমার গোপনীয়তা',
//       title: 'আমল তোমার,\nশেয়ার করা\nতোমার ইচ্ছা',
//       subtitle: 'নিজের স্কোর লুকাতে পারবে, নাম Anonymous রাখতে পারবে।\n'
//           'আল্লাহ তো সব জানেনই — তাঁর কাছে কিছুই লুকানো নেই।',
//       illustrationBuilder: (f, r) => _PrivacyIllustration(floatAnim: f, r: r),
//       bgFrom: const Color(0xFF052818),
//       bgTo: const Color(0xFF0D4425),
//     ),
//   ];

//   bool get _isLast => _cur == _pages.length - 1;

//   @override
//   void initState() {
//     super.initState();
//     _fadeCtrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 520));
//     _floatCtrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 2800))
//       ..repeat(reverse: true);
//     _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
//     _floatAnim = CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut);
//     _fadeCtrl.forward();
//   }

//   @override
//   void dispose() {
//     _pageCtrl.dispose();
//     _fadeCtrl.dispose();
//     _floatCtrl.dispose();
//     super.dispose();
//   }

//   void _onPageChanged(int i) {
//     _fadeCtrl.reset();
//     _fadeCtrl.forward();
//     setState(() => _cur = i);
//   }

//   Future<void> _complete() async {
//     await markOnboardingSeen();
//     onboardingSeenNotifier.value = true;
//     if (mounted) context.go(AppRoutes.login);
//   }

//   void _next() => _pageCtrl.nextPage(
//         duration: const Duration(milliseconds: 420),
//         curve: Curves.easeInOutCubic,
//       );

//   @override
//   Widget build(BuildContext context) {
//     final page = _pages[_cur];
//     final r = _R.of(context);

//     return Scaffold(
//       backgroundColor: page.bgFrom,
//       body: AnimatedContainer(
//         duration: const Duration(milliseconds: 460),
//         curve: Curves.easeInOut,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [page.bgFrom, page.bgTo],
//           ),
//         ),
//         child: Stack(
//           children: [
//             // ── Islamic geometric pattern ──────────────────────────────
//             const Positioned.fill(child: _BgPattern()),

//             // ── Pages (behind top bar & bottom bar) ───────────────────
//             PageView.builder(
//               controller: _pageCtrl,
//               onPageChanged: _onPageChanged,
//               itemCount: _pages.length,
//               itemBuilder: (_, i) => _Page(
//                 data: _pages[i],
//                 floatAnim: _floatAnim,
//                 fadeAnim: _fadeAnim,
//                 r: r,
//               ),
//             ),

//             // ── Top bar (logo + skip) — always pinned ─────────────────
//             Positioned(
//               top: 0,
//               left: 0,
//               right: 0,
//               child: SafeArea(
//                 bottom: false,
//                 child: Padding(
//                   padding: EdgeInsets.fromLTRB(20, r.isCompact ? 6 : 10, 20, 0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // Brand logo + name
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 34,
//                             height: 34,
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.13),
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(
//                                   color: Colors.white.withOpacity(0.25)),
//                             ),
//                             alignment: Alignment.center,
//                             child: const Text('س',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 19,
//                                     fontWeight: FontWeight.w700,
//                                     height: 1)),
//                           ),
//                           const SizedBox(width: 9),
//                           const Text('Sabeq',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.w700,
//                                   letterSpacing: 0.4)),
//                         ],
//                       ),
//                       // Skip button — intrinsic height only
//                       AnimatedOpacity(
//                         opacity: _isLast ? 0 : 1,
//                         duration: const Duration(milliseconds: 220),
//                         child: IgnorePointer(
//                           ignoring: _isLast,
//                           child: GestureDetector(
//                             onTap: _complete,
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 14, vertical: 7),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.13),
//                                 borderRadius: BorderRadius.circular(20),
//                                 border: Border.all(
//                                     color: Colors.white.withOpacity(0.25)),
//                               ),
//                               child: Text('এড়িয়ে যাও',
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: r.eyebrowFs,
//                                       fontWeight: FontWeight.w600)),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // ── Bottom bar (dots + next/start) ────────────────────────
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               child: _BottomBar(
//                 cur: _cur,
//                 total: _pages.length,
//                 isLast: _isLast,
//                 onNext: _next,
//                 onComplete: _complete,
//                 r: r,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ══════════════════════════════════════════════════════════════════════════
// // SINGLE PAGE
// // ══════════════════════════════════════════════════════════════════════════
// class _Page extends StatelessWidget {
//   final _PageData data;
//   final Animation<double> floatAnim;
//   final Animation<double> fadeAnim;
//   final _R r;

//   const _Page({
//     required this.data,
//     required this.floatAnim,
//     required this.fadeAnim,
//     required this.r,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         // ── Illustration ───────────────────────────────────────────────
//         SizedBox(
//           height: r.illustH,
//           child: Padding(
//             padding: EdgeInsets.only(top: r.illustTopPad),
//             child: AnimatedBuilder(
//               animation: floatAnim,
//               builder: (_, child) => Transform.translate(
//                 offset: Offset(0, (floatAnim.value - 0.5) * 14),
//                 child: child,
//               ),
//               child: data.illustrationBuilder(floatAnim, r),
//             ),
//           ),
//         ),

//         // ── Text content — scrollable so it never overflows ────────────
//         Expanded(
//           child: FadeTransition(
//             opacity: fadeAnim,
//             child: SingleChildScrollView(
//               physics: const NeverScrollableScrollPhysics(),
//               padding:
//                   EdgeInsets.fromLTRB(r.textPadH, 6, r.textPadH, r.textPadBot),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Ayat card (arabic + meaning + source)
//                   _AyatCard(
//                     arabic: data.arabic,
//                     source: data.source,
//                     meaning: data.meaning,
//                     r: r,
//                   ),
//                   SizedBox(height: r.gap1),

//                   // Eyebrow tag
//                   _EyebrowTag(label: data.eyebrow, r: r),
//                   SizedBox(height: r.gap2),

//                   // Title
//                   Text(
//                     data.title,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: r.titleFs,
//                       fontWeight: FontWeight.w800,
//                       height: 1.28,
//                       letterSpacing: -0.4,
//                     ),
//                   ),
//                   SizedBox(height: r.gap3),

//                   // Subtitle
//                   Text(
//                     data.subtitle,
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.72),
//                       fontSize: r.subtitleFs,
//                       fontWeight: FontWeight.w400,
//                       height: 1.65,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ══════════════════════════════════════════════════════════════════════════
// // AYAT CARD  — arabic + meaning + source, all in one card
// // ══════════════════════════════════════════════════════════════════════════
// class _AyatCard extends StatelessWidget {
//   final String arabic;
//   final String source;
//   final String meaning;
//   final _R r;

//   const _AyatCard({
//     required this.arabic,
//     required this.source,
//     required this.meaning,
//     required this.r,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(
//           horizontal: r.isCompact ? 12 : 14, vertical: r.isCompact ? 10 : 13),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.07),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: _C.gold.withOpacity(0.35)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // ── Arabic text (right-aligned) ───────────────────────────────
//           Text(
//             arabic,
//             textAlign: TextAlign.right,
//             style: TextStyle(
//               color: _C.gold,
//               fontSize: r.arabicFs,
//               fontWeight: FontWeight.w600,
//               height: 1.8,
//             ),
//           ),

//           // ── Divider ───────────────────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 7),
//             child: Container(
//               height: 1,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(colors: [
//                   Colors.transparent,
//                   _C.gold.withOpacity(0.3),
//                   Colors.transparent,
//                 ]),
//               ),
//             ),
//           ),

//           // ── Bangla meaning ────────────────────────────────────────────
//           Text(
//             meaning,
//             textAlign: TextAlign.left,
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.82),
//               fontSize: r.meaningFs,
//               fontWeight: FontWeight.w400,
//               fontStyle: FontStyle.italic,
//               height: 1.6,
//             ),
//           ),

//           const SizedBox(height: 6),

//           // ── Source (right-aligned, subtle) ────────────────────────────
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 width: 4,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: _C.gold.withOpacity(0.55),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               const SizedBox(width: 5),
//               Text(
//                 source,
//                 style: TextStyle(
//                   color: _C.gold.withOpacity(0.6),
//                   fontSize: r.isCompact ? 10.0 : 11.0,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ══════════════════════════════════════════════════════════════════════════
// // EYEBROW TAG
// // ══════════════════════════════════════════════════════════════════════════
// class _EyebrowTag extends StatelessWidget {
//   final String label;
//   final _R r;
//   const _EyebrowTag({required this.label, required this.r});

//   @override
//   Widget build(BuildContext context) => Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//         decoration: BoxDecoration(
//           color: _C.gold.withOpacity(0.15),
//           borderRadius: BorderRadius.circular(6),
//           border: Border.all(color: _C.gold.withOpacity(0.32)),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: _C.gold.withOpacity(0.9),
//             fontSize: r.eyebrowFs,
//             fontWeight: FontWeight.w700,
//             letterSpacing: 0.7,
//           ),
//         ),
//       );
// }

// // ══════════════════════════════════════════════════════════════════════════
// // BOTTOM BAR
// // ══════════════════════════════════════════════════════════════════════════
// class _BottomBar extends StatelessWidget {
//   final int cur;
//   final int total;
//   final bool isLast;
//   final VoidCallback onNext;
//   final VoidCallback onComplete;
//   final _R r;

//   const _BottomBar({
//     required this.cur,
//     required this.total,
//     required this.isLast,
//     required this.onNext,
//     required this.onComplete,
//     required this.r,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final bottomInset = MediaQuery.of(context).padding.bottom;

//     return Container(
//       padding: EdgeInsets.fromLTRB(
//           26, r.isCompact ? 12 : 16, 26, bottomInset + (r.isCompact ? 16 : 20)),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.transparent, Colors.black.withOpacity(0.26)],
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Dots
//           Row(
//             children: List.generate(total, (i) {
//               final active = i == cur;
//               return AnimatedContainer(
//                 duration: const Duration(milliseconds: 280),
//                 curve: Curves.easeInOut,
//                 margin: const EdgeInsets.only(right: 6),
//                 width: active ? 22 : 7,
//                 height: 7,
//                 decoration: BoxDecoration(
//                   color: active ? Colors.white : Colors.white.withOpacity(0.3),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               );
//             }),
//           ),

//           // Next / Start button
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 260),
//             transitionBuilder: (child, anim) =>
//                 ScaleTransition(scale: anim, child: child),
//             child: isLast
//                 ? _StartBtn(key: const ValueKey('s'), onTap: onComplete, r: r)
//                 : _NextBtn(key: const ValueKey('n'), onTap: onNext, r: r),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _NextBtn extends StatelessWidget {
//   final VoidCallback onTap;
//   final _R r;
//   const _NextBtn({super.key, required this.onTap, required this.r});

//   @override
//   Widget build(BuildContext context) {
//     final sz = r.isCompact ? 48.0 : 54.0;
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: sz,
//         height: sz,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black.withOpacity(0.22),
//                 blurRadius: 14,
//                 offset: const Offset(0, 5))
//           ],
//         ),
//         child: Icon(Icons.arrow_forward_rounded,
//             color: _C.darkGreen, size: r.isCompact ? 20 : 23),
//       ),
//     );
//   }
// }

// class _StartBtn extends StatelessWidget {
//   final VoidCallback onTap;
//   final _R r;
//   const _StartBtn({super.key, required this.onTap, required this.r});

//   @override
//   Widget build(BuildContext context) => GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: EdgeInsets.symmetric(
//               horizontal: r.isCompact ? 18 : 22,
//               vertical: r.isCompact ? 12 : 15),
//           decoration: BoxDecoration(
//             color: _C.gold,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                   color: _C.gold.withOpacity(0.42),
//                   blurRadius: 18,
//                   offset: const Offset(0, 6))
//             ],
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('শুরু করি',
//                   style: TextStyle(
//                       color: _C.darkGreen,
//                       fontSize: r.isCompact ? 14 : 15,
//                       fontWeight: FontWeight.w800,
//                       letterSpacing: 0.3)),
//               const SizedBox(width: 8),
//               Icon(Icons.arrow_forward_rounded,
//                   color: _C.darkGreen, size: r.isCompact ? 17 : 19),
//             ],
//           ),
//         ),
//       );
// }

// // ══════════════════════════════════════════════════════════════════════════
// // BACKGROUND PATTERN
// // ══════════════════════════════════════════════════════════════════════════
// class _BgPattern extends StatelessWidget {
//   const _BgPattern();
//   @override
//   Widget build(BuildContext context) =>
//       CustomPaint(painter: _PatternPainter(), size: Size.infinite);
// }

// class _PatternPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final p = Paint()
//       ..color = Colors.white.withOpacity(0.032)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1;
//     const s = 72.0;
//     for (double x = -s; x < size.width + s; x += s)
//       for (double y = -s; y < size.height + s; y += s)
//         _oct(canvas, Offset(x, y), 24, p);
//   }

//   void _oct(Canvas canvas, Offset c, double r, Paint p) {
//     final path = Path();
//     for (int i = 0; i < 8; i++) {
//       final a = (i * math.pi / 4) - math.pi / 8;
//       final pt = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
//       i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
//     }
//     canvas.drawPath(path..close(), p);
//   }

//   @override
//   bool shouldRepaint(_PatternPainter _) => false;
// }

// // ══════════════════════════════════════════════════════════════════════════
// // ILLUSTRATIONS  — all use _R for responsive sizing
// // ══════════════════════════════════════════════════════════════════════════

// // ── 1. Mosque ─────────────────────────────────────────────────────────────
// class _MosqueIllustration extends StatelessWidget {
//   final Animation<double> floatAnim;
//   final _R r;
//   const _MosqueIllustration({required this.floatAnim, required this.r});

//   @override
//   Widget build(BuildContext context) {
//     final s = r.sw * 0.76;
//     return Center(
//       child: CustomPaint(painter: _MosquePainter(), size: Size(s, s)),
//     );
//   }
// }

// class _MosquePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;

//     // Shadow
//     canvas.drawOval(
//       Rect.fromCenter(
//           center: Offset(cx, cy + size.height * 0.35),
//           width: size.width * 0.82,
//           height: size.height * 0.1),
//       Paint()
//         ..color = Colors.black.withOpacity(0.2)
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
//     );

//     final white = Paint()..color = Colors.white.withOpacity(0.93);
//     final white2 = Paint()..color = Colors.white.withOpacity(0.78);
//     final goldP = Paint()..color = _C.gold;
//     final goldF = Paint()..color = _C.gold.withOpacity(0.85);

//     // Body
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromLTWH(cx - size.width * 0.28, cy - size.height * 0.08,
//             size.width * 0.56, size.height * 0.43),
//         const Radius.circular(5),
//       ),
//       white,
//     );

//     // Main dome
//     _dome(canvas, Offset(cx, cy - size.height * 0.08), size.width * 0.21,
//         size.height * 0.22, goldF);

//     // Side domes
//     _dome(canvas, Offset(cx - size.width * 0.2, cy - size.height * 0.04),
//         size.width * 0.1, size.height * 0.11, white2);
//     _dome(canvas, Offset(cx + size.width * 0.2, cy - size.height * 0.04),
//         size.width * 0.1, size.height * 0.11, white2);

//     // Minarets
//     for (final sx in [-1.0, 1.0]) {
//       final mx = cx + sx * size.width * 0.31;
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromCenter(
//               center: Offset(mx, cy + size.height * 0.04),
//               width: size.width * 0.055,
//               height: size.height * 0.5),
//           const Radius.circular(4),
//         ),
//         white2,
//       );
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromCenter(
//               center: Offset(mx, cy - size.height * 0.1),
//               width: size.width * 0.1,
//               height: size.height * 0.025),
//           const Radius.circular(3),
//         ),
//         goldF,
//       );
//       _dome(canvas, Offset(mx, cy - size.height * 0.22), size.width * 0.042,
//           size.height * 0.08, goldF);
//       canvas.drawLine(
//         Offset(mx, cy - size.height * 0.3),
//         Offset(mx, cy - size.height * 0.22),
//         Paint()
//           ..color = _C.gold
//           ..strokeWidth = 2
//           ..strokeCap = StrokeCap.round,
//       );
//     }

//     // Door
//     final dw = size.width * 0.13;
//     final dh = size.height * 0.17;
//     final dt = cy + size.height * 0.08;
//     canvas.drawPath(
//       Path()
//         ..moveTo(cx - dw / 2, dt + dh)
//         ..lineTo(cx - dw / 2, dt + dw / 2)
//         ..addArc(
//             Rect.fromCenter(
//                 center: Offset(cx, dt + dw / 2), width: dw, height: dw),
//             math.pi,
//             math.pi)
//         ..lineTo(cx + dw / 2, dt + dh)
//         ..close(),
//       Paint()..color = _C.greenMid.withOpacity(0.55),
//     );

//     // Windows
//     for (final sx in [-1.0, 1.0]) {
//       final wx = cx + sx * size.width * 0.17;
//       final wy = cy + size.height * 0.08;
//       final ww = size.width * 0.09;
//       canvas.drawPath(
//         Path()
//           ..moveTo(wx - ww / 2, wy + ww * 0.85)
//           ..lineTo(wx - ww / 2, wy + ww / 2)
//           ..addArc(
//               Rect.fromCenter(
//                   center: Offset(wx, wy + ww / 2), width: ww, height: ww),
//               math.pi,
//               math.pi)
//           ..lineTo(wx + ww / 2, wy + ww * 0.85)
//           ..close(),
//         Paint()..color = _C.gold.withOpacity(0.55),
//       );
//     }

//     // Crescent
//     _crescent(
//         canvas, Offset(cx, cy - size.height * 0.3), size.width * 0.055, goldP);

//     // Stars
//     final sp = Paint()..color = _C.gold.withOpacity(0.65);
//     for (final (ox, oy) in [(-0.37, -0.37), (0.38, -0.3), (0.14, -0.41)])
//       _star(canvas, Offset(cx + ox * size.width, cy + oy * size.height),
//           size.width * 0.022, sp);
//   }

//   void _dome(Canvas canvas, Offset c, double w, double h, Paint p) =>
//       canvas.drawPath(
//         Path()
//           ..moveTo(c.dx - w, c.dy)
//           ..cubicTo(c.dx - w, c.dy - h * 1.35, c.dx + w, c.dy - h * 1.35,
//               c.dx + w, c.dy)
//           ..close(),
//         p,
//       );

//   void _crescent(Canvas canvas, Offset c, double r, Paint p) => canvas.drawPath(
//         Path.combine(
//           PathOperation.difference,
//           Path()..addOval(Rect.fromCircle(center: c, radius: r)),
//           Path()
//             ..addOval(Rect.fromCircle(
//                 center: Offset(c.dx + r * 0.45, c.dy - r * 0.1),
//                 radius: r * 0.75)),
//         ),
//         p,
//       );

//   void _star(Canvas canvas, Offset c, double r, Paint p) {
//     final path = Path();
//     for (int i = 0; i < 5; i++) {
//       final o = Offset(c.dx + r * math.cos(i * 4 * math.pi / 5 - math.pi / 2),
//           c.dy + r * math.sin(i * 4 * math.pi / 5 - math.pi / 2));
//       final inn = Offset(
//           c.dx + r * 0.4 * math.cos((i * 4 + 2) * math.pi / 5 - math.pi / 2),
//           c.dy + r * 0.4 * math.sin((i * 4 + 2) * math.pi / 5 - math.pi / 2));
//       i == 0 ? path.moveTo(o.dx, o.dy) : path.lineTo(o.dx, o.dy);
//       path.lineTo(inn.dx, inn.dy);
//     }
//     canvas.drawPath(path..close(), p);
//   }

//   @override
//   bool shouldRepaint(_MosquePainter _) => false;
// }

// // ── 2. Tracker phone ──────────────────────────────────────────────────────
// class _TrackerIllustration extends StatelessWidget {
//   final Animation<double> floatAnim;
//   final _R r;
//   const _TrackerIllustration({required this.floatAnim, required this.r});

//   @override
//   Widget build(BuildContext context) => Center(
//         child: CustomPaint(
//           painter: _TrackerPainter(),
//           size: Size(r.sw * 0.60, r.sh * 0.34),
//         ),
//       );
// }

// class _TrackerPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;
//     final pw = size.width;
//     final ph = size.height;

//     final frame = RRect.fromRectAndRadius(
//       Rect.fromCenter(center: Offset(cx, cy), width: pw, height: ph),
//       const Radius.circular(22),
//     );
//     canvas.drawRRect(
//         frame,
//         Paint()
//           ..color = Colors.black.withOpacity(0.2)
//           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
//     canvas.drawRRect(frame, Paint()..color = Colors.white.withOpacity(0.96));

//     // Header
//     canvas.drawRRect(
//       RRect.fromRectAndCorners(
//         Rect.fromLTWH(cx - pw / 2, cy - ph / 2, pw, ph * 0.115),
//         topLeft: const Radius.circular(22),
//         topRight: const Radius.circular(22),
//       ),
//       Paint()..color = _C.darkGreen,
//     );
//     _blob(canvas, Offset(cx - pw * 0.12, cy - ph * 0.43), pw * 0.22, 5,
//         Colors.white.withOpacity(0.7), 3);
//     _blob(canvas, Offset(cx + pw * 0.28, cy - ph * 0.43), pw * 0.1, 5,
//         _C.gold.withOpacity(0.8), 3);

//     // Date chips
//     for (int d = 0; d < 7; d++) {
//       final dx = cx - pw * 0.38 + d * pw * 0.125;
//       final active = d == 3;
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromCenter(
//               center: Offset(dx, cy - ph * 0.31),
//               width: pw * 0.1,
//               height: ph * 0.1),
//           const Radius.circular(8),
//         ),
//         Paint()..color = active ? _C.gold : Colors.grey.withOpacity(0.12),
//       );
//       _blob(canvas, Offset(dx, cy - ph * 0.31), pw * 0.055, 4,
//           active ? _C.darkGreen : Colors.grey.withOpacity(0.4), 2);
//     }

//     // Rows
//     const rows = [true, true, true, false, false, true];
//     final colors = [
//       _C.greenAccent,
//       _C.greenAccent,
//       _C.greenAccent,
//       _C.gold,
//       Colors.grey,
//       _C.greenAccent,
//     ];
//     for (int i = 0; i < rows.length; i++) {
//       final done = rows[i];
//       final color = colors[i];
//       final ry = cy - ph * 0.15 + i * ph * 0.105;

//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromCenter(
//               center: Offset(cx, ry), width: pw * 0.85, height: ph * 0.085),
//           const Radius.circular(9),
//         ),
//         Paint()
//           ..color =
//               done ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
//       );

//       final cbC = Offset(cx - pw * 0.36, ry);
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromCenter(center: cbC, width: 15, height: 15),
//           const Radius.circular(4),
//         ),
//         Paint()..color = done ? color : Colors.grey.withOpacity(0.2),
//       );
//       if (done) {
//         final ck = Paint()
//           ..color = Colors.white
//           ..strokeWidth = 2
//           ..style = PaintingStyle.stroke
//           ..strokeCap = StrokeCap.round;
//         canvas.drawLine(
//             Offset(cbC.dx - 4, cbC.dy), Offset(cbC.dx - 1, cbC.dy + 3), ck);
//         canvas.drawLine(
//             Offset(cbC.dx - 1, cbC.dy + 3), Offset(cbC.dx + 5, cbC.dy - 3), ck);
//       }
//       _blob(canvas, Offset(cx - pw * 0.14, ry), pw * 0.32, 5,
//           done ? color.withOpacity(0.5) : Colors.grey.withOpacity(0.25), 3);
//       _blob(canvas, Offset(cx + pw * 0.32, ry), pw * 0.1, 13,
//           done ? color.withOpacity(0.2) : Colors.transparent, 6);
//     }

//     // Progress bar
//     final pbY = cy + ph * 0.45;
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(Rect.fromLTWH(cx - pw * 0.38, pbY, pw * 0.76, 5),
//           const Radius.circular(3)),
//       Paint()..color = Colors.grey.withOpacity(0.15),
//     );
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//           Rect.fromLTWH(cx - pw * 0.38, pbY, pw * 0.76 * 0.67, 5),
//           const Radius.circular(3)),
//       Paint()..color = _C.greenAccent,
//     );
//   }

//   void _blob(
//           Canvas canvas, Offset c, double w, double h, Color color, double r) =>
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(Rect.fromCenter(center: c, width: w, height: h),
//             Radius.circular(r)),
//         Paint()..color = color,
//       );

//   @override
//   bool shouldRepaint(_TrackerPainter _) => false;
// }

// // ── 3. Leaderboard ───────────────────────────────────────────────────────
// class _LeaderboardIllustration extends StatelessWidget {
//   final Animation<double> floatAnim;
//   final _R r;
//   const _LeaderboardIllustration({required this.floatAnim, required this.r});

//   @override
//   Widget build(BuildContext context) => Center(
//         child: CustomPaint(
//           painter: _LeaderboardPainter(),
//           size: Size(r.sw * 0.76, r.sh * 0.34),
//         ),
//       );
// }

// class _LeaderboardPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;

//     _trophy(canvas, Offset(cx, cy - size.height * 0.3), size.width * 0.18);

//     final bw = size.width * 0.26;
//     final baseY = cy + size.height * 0.42;

//     _podium(canvas, Offset(cx - bw * 1.05, baseY), bw * 0.9, size.height * 0.28,
//         Colors.white.withOpacity(0.7), '২');
//     _podium(canvas, Offset(cx, baseY), bw, size.height * 0.42, _C.gold, '১');
//     _podium(canvas, Offset(cx + bw * 1.05, baseY), bw * 0.9, size.height * 0.2,
//         _C.greenAccent.withOpacity(0.75), '৩');

//     _avatar(canvas, Offset(cx - bw * 1.05, baseY - size.height * 0.28 - 30), 22,
//         Colors.white.withOpacity(0.85), _C.textSec);

//     canvas.drawCircle(
//         Offset(cx, baseY - size.height * 0.42 - 30),
//         32,
//         Paint()
//           ..color = _C.gold.withOpacity(0.28)
//           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
//     _avatar(canvas, Offset(cx, baseY - size.height * 0.42 - 30), 26, _C.gold,
//         _C.darkGreen);

//     _avatar(canvas, Offset(cx + bw * 1.05, baseY - size.height * 0.2 - 28), 20,
//         _C.greenAccent, Colors.white);

//     // Ray burst
//     final rp = Paint()
//       ..color = _C.gold.withOpacity(0.38)
//       ..strokeWidth = 1.5;
//     for (int i = 0; i < 8; i++) {
//       final a = i * math.pi / 4;
//       final oc = Offset(cx, baseY - size.height * 0.42 - 30);
//       canvas.drawLine(
//         Offset(oc.dx + 38 * math.cos(a), oc.dy + 38 * math.sin(a)),
//         Offset(oc.dx + 50 * math.cos(a), oc.dy + 50 * math.sin(a)),
//         rp,
//       );
//     }

//     // Anonymous badge hint
//     final bc = Offset(cx + size.width * 0.38, cy - size.height * 0.05);
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//           Rect.fromCenter(center: bc, width: 54, height: 30),
//           const Radius.circular(10)),
//       Paint()..color = Colors.white.withOpacity(0.1),
//     );
//     canvas.drawCircle(Offset(bc.dx - 9, bc.dy), 9,
//         Paint()..color = Colors.white.withOpacity(0.22));
//     final qp = TextPainter(
//       text: TextSpan(
//         text: '?',
//         style: TextStyle(
//             color: Colors.white.withOpacity(0.65),
//             fontSize: 13,
//             fontWeight: FontWeight.w700),
//       ),
//       textDirection: TextDirection.ltr,
//     )..layout();
//     qp.paint(canvas, Offset(bc.dx + 8, bc.dy - 9));
//   }

//   void _podium(Canvas canvas, Offset base, double w, double h, Color color,
//       String rank) {
//     canvas.drawRRect(
//       RRect.fromRectAndCorners(
//         Rect.fromLTWH(base.dx - w / 2, base.dy - h, w, h),
//         topLeft: const Radius.circular(10),
//         topRight: const Radius.circular(10),
//       ),
//       Paint()..color = color,
//     );
//     final tp = TextPainter(
//       text: TextSpan(
//         text: rank,
//         style: TextStyle(
//           color: rank == '১' ? _C.darkGreen : Colors.white.withOpacity(0.85),
//           fontSize: 16,
//           fontWeight: FontWeight.w800,
//         ),
//       ),
//       textDirection: TextDirection.ltr,
//     )..layout();
//     tp.paint(canvas, Offset(base.dx - tp.width / 2, base.dy - 24));
//   }

//   void _avatar(Canvas canvas, Offset c, double r, Color bg, Color fg) {
//     canvas.drawCircle(
//         c, r + 3, Paint()..color = Colors.white.withOpacity(0.18));
//     canvas.drawCircle(c, r, Paint()..color = bg);
//     canvas.drawCircle(Offset(c.dx, c.dy - r * 0.27), r * 0.33,
//         Paint()..color = fg.withOpacity(0.85));
//     canvas.drawArc(
//       Rect.fromCenter(
//           center: Offset(c.dx, c.dy + r * 0.45), width: r * 1.1, height: r),
//       math.pi,
//       math.pi,
//       false,
//       Paint()
//         ..color = fg.withOpacity(0.85)
//         ..style = PaintingStyle.fill,
//     );
//   }

//   void _trophy(Canvas canvas, Offset c, double r) {
//     final p = Paint()..color = _C.gold;
//     canvas.drawPath(
//       Path()
//         ..moveTo(c.dx - r, c.dy - r * 0.3)
//         ..cubicTo(c.dx - r * 1.2, c.dy + r * 0.7, c.dx + r * 1.2,
//             c.dy + r * 0.7, c.dx + r, c.dy - r * 0.3)
//         ..lineTo(c.dx + r * 0.6, c.dy - r)
//         ..lineTo(c.dx - r * 0.6, c.dy - r)
//         ..close(),
//       p,
//     );
//     for (final sx in [-1.0, 1.0]) {
//       canvas.drawArc(
//         Rect.fromCenter(
//             center: Offset(c.dx + sx * r * 0.98, c.dy - r * 0.15),
//             width: r * 0.55,
//             height: r * 0.65),
//         sx > 0 ? -math.pi / 2 : math.pi / 2,
//         math.pi,
//         false,
//         Paint()
//           ..color = _C.gold
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = r * 0.14,
//       );
//     }
//     canvas.drawRect(
//         Rect.fromCenter(
//             center: Offset(c.dx, c.dy + r * 0.9),
//             width: r * 0.22,
//             height: r * 0.45),
//         p);
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(
//             center: Offset(c.dx, c.dy + r * 1.22),
//             width: r * 0.85,
//             height: r * 0.18),
//         const Radius.circular(4),
//       ),
//       p,
//     );
//   }

//   @override
//   bool shouldRepaint(_LeaderboardPainter _) => false;
// }

// // ── 4. Privacy ────────────────────────────────────────────────────────────
// class _PrivacyIllustration extends StatelessWidget {
//   final Animation<double> floatAnim;
//   final _R r;
//   const _PrivacyIllustration({required this.floatAnim, required this.r});

//   @override
//   Widget build(BuildContext context) => Center(
//         child: CustomPaint(
//           painter: _PrivacyPainter(),
//           size: Size(r.sw * 0.70, r.sh * 0.32),
//         ),
//       );
// }

// class _PrivacyPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;
//     final sr = size.width * 0.22;

//     // Shield
//     final shield = Path()
//       ..moveTo(cx, cy - sr * 1.2)
//       ..cubicTo(cx + sr * 1.2, cy - sr * 0.8, cx + sr * 1.2, cy + sr * 0.4, cx,
//           cy + sr * 1.2)
//       ..cubicTo(cx - sr * 1.2, cy + sr * 0.4, cx - sr * 1.2, cy - sr * 0.8, cx,
//           cy - sr * 1.2)
//       ..close();

//     canvas.drawPath(
//         shield,
//         Paint()
//           ..color = _C.greenAccent.withOpacity(0.22)
//           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16));
//     canvas.drawPath(shield, Paint()..color = _C.greenMid.withOpacity(0.68));
//     canvas.drawPath(
//         shield,
//         Paint()
//           ..color = Colors.white.withOpacity(0.38)
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 2.5);

//     // Lock
//     final lw = sr * 0.55;
//     final lh = sr * 0.45;
//     final lcy = cy + sr * 0.2;
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//           Rect.fromCenter(center: Offset(cx, lcy), width: lw, height: lh),
//           const Radius.circular(7)),
//       Paint()..color = Colors.white.withOpacity(0.9),
//     );
//     canvas.drawArc(
//       Rect.fromCenter(
//           center: Offset(cx, lcy - lh / 2), width: lw * 0.6, height: lw * 0.6),
//       math.pi,
//       math.pi,
//       false,
//       Paint()
//         ..color = Colors.white.withOpacity(0.9)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 4
//         ..strokeCap = StrokeCap.round,
//     );
//     canvas.drawCircle(Offset(cx, lcy - 2), 5, Paint()..color = _C.greenMid);
//     canvas.drawRect(
//         Rect.fromCenter(center: Offset(cx, lcy + 7), width: 4, height: 9),
//         Paint()..color = _C.greenMid);

//     // Feature cards
//     final cards = [
//       (cx - size.width * 0.38, cy - size.height * 0.22, 'আমল\nলুকাও'),
//       (cx + size.width * 0.32, cy - size.height * 0.22, 'নাম\nগোপন'),
//       (cx - size.width * 0.38, cy + size.height * 0.22, 'নিজে\nশেয়ার করো'),
//     ];

//     for (final (fx, fy, label) in cards) {
//       _featureCard(canvas, Offset(fx, fy), label, size);
//     }

//     // Dashed connectors
//     final dashP = Paint()
//       ..color = Colors.white.withOpacity(0.18)
//       ..strokeWidth = 1.5;
//     for (final (fx, fy, _) in cards)
//       _dashedLine(canvas, Offset(fx, fy), Offset(cx, cy), dashP);
//   }

//   void _featureCard(Canvas canvas, Offset c, String label, Size size) {
//     final w = size.width * 0.28;
//     final h = size.height * 0.28;

//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//           Rect.fromCenter(center: c, width: w + 6, height: h + 6),
//           const Radius.circular(14)),
//       Paint()
//         ..color = _C.greenAccent.withOpacity(0.1)
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
//     );
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(Rect.fromCenter(center: c, width: w, height: h),
//           const Radius.circular(12)),
//       Paint()..color = Colors.white.withOpacity(0.09),
//     );
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(Rect.fromCenter(center: c, width: w, height: h),
//           const Radius.circular(12)),
//       Paint()
//         ..color = Colors.white.withOpacity(0.22)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 1,
//     );
//     // gold dot
//     canvas.drawCircle(Offset(c.dx, c.dy - h * 0.2), h * 0.14,
//         Paint()..color = _C.gold.withOpacity(0.5));

//     final tp = TextPainter(
//       text: TextSpan(
//         text: label,
//         style: const TextStyle(
//             color: Colors.white,
//             fontSize: 9.5,
//             fontWeight: FontWeight.w600,
//             height: 1.4),
//       ),
//       textDirection: TextDirection.ltr,
//       textAlign: TextAlign.center,
//     )..layout(maxWidth: w - 8);
//     tp.paint(canvas, Offset(c.dx - tp.width / 2, c.dy + h * 0.05));
//   }

//   void _dashedLine(Canvas canvas, Offset a, Offset b, Paint p) {
//     final dx = b.dx - a.dx;
//     final dy = b.dy - a.dy;
//     final dist = math.sqrt(dx * dx + dy * dy);
//     final nx = dx / dist;
//     final ny = dy / dist;
//     double t = 0;
//     while (t < dist - 40) {
//       canvas.drawLine(
//         Offset(a.dx + nx * t, a.dy + ny * t),
//         Offset(a.dx + nx * (t + 5), a.dy + ny * (t + 5)),
//         p,
//       );
//       t += 9;
//     }
//   }

//   @override
//   bool shouldRepaint(_PrivacyPainter _) => false;
// }
// lib/features/onboarding/onboarding_screen.dart

// import 'dart:math' as math;
// import 'package:amal_tracker/core/router/app_router.dart';
// import 'package:amal_tracker/features/onboarding/provider/onboarding_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// // ══════════════════════════════════════════════════════════════════════════
// // COLORS
// // ══════════════════════════════════════════════════════════════════════════
// class _C {
//   static const darkGreen = Color(0xFF033019);
//   static const greenMid = Color(0xFF2D8A52);
//   static const greenAccent = Color(0xFF4CAF78);
//   static const gold = Color(0xFFF5C842);
//   static const goldLight = Color(0xFFFFF8DC);
//   static const textSec = Color(0xFF5A7A67);
// }

// // ══════════════════════════════════════════════════════════════════════════
// // RESPONSIVE HELPER  — call once per build, pass around
// // ══════════════════════════════════════════════════════════════════════════
// class _R {
//   final double sw; // screen width
//   final double sh; // screen height
//   final double top; // status bar height

//   const _R({required this.sw, required this.sh, required this.top});

//   factory _R.of(BuildContext ctx) {
//     final mq = MediaQuery.of(ctx);
//     return _R(sw: mq.size.width, sh: mq.size.height, top: mq.padding.top);
//   }

//   // ── Breakpoints ────────────────────────────────────────────────────────
//   // compact  : sh < 640  (small phones: SE, Moto G)
//   // normal   : 640 ≤ sh < 800  (most Android flagships, iPhone 14)
//   // large    : sh ≥ 800  (Pro Max, tablets, foldables)
//   bool get isCompact => sh < 640;
//   bool get isLarge => sh >= 800;

//   // ── Scaled values ──────────────────────────────────────────────────────
//   // illustH: how tall the illustration SizedBox is.
//   // Top bar (~54px) + bottom bar (~80px) are in the Column, NOT overlapping.
//   // So we can safely give the illustration a fixed fraction of remaining space.
//   double get illustH => isCompact
//       ? sh * 0.36
//       : isLarge
//           ? sh * 0.40
//           : sh * 0.38;
//   double get textPadH => isCompact ? 20.0 : 26.0;
//   double get arabicFs => isCompact ? 13.0 : 15.0;
//   double get titleFs => isCompact
//       ? 22.0
//       : isLarge
//           ? 28.0
//           : 25.0;
//   double get subtitleFs => isCompact ? 12.5 : 13.5;
//   double get meaningFs => isCompact ? 11.5 : 12.5;
//   double get eyebrowFs => isCompact ? 10.0 : 11.0;
//   double get gap1 => isCompact ? 10.0 : 16.0; // ayat → eyebrow
//   double get gap2 => isCompact ? 6.0 : 10.0; // eyebrow → title
//   double get gap3 => isCompact ? 6.0 : 10.0; // title → subtitle
//   double get gap4 => isCompact ? 6.0 : 8.0; // subtitle → meaning
// }

// // ══════════════════════════════════════════════════════════════════════════
// // PAGE MODEL
// // ══════════════════════════════════════════════════════════════════════════
// class _PageData {
//   final String arabic;
//   final String source;
//   final String meaning; // ← বাংলা অর্থ
//   final String eyebrow;
//   final String title;
//   final String subtitle;
//   final Widget Function(Animation<double>, _R) illustrationBuilder;
//   final Color bgFrom;
//   final Color bgTo;

//   const _PageData({
//     required this.arabic,
//     required this.source,
//     required this.meaning,
//     required this.eyebrow,
//     required this.title,
//     required this.subtitle,
//     required this.illustrationBuilder,
//     required this.bgFrom,
//     required this.bgTo,
//   });
// }

// // ══════════════════════════════════════════════════════════════════════════
// // MAIN SCREEN
// // ══════════════════════════════════════════════════════════════════════════
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});
//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen>
//     with TickerProviderStateMixin {
//   final _pageCtrl = PageController();
//   int _cur = 0;

//   late final AnimationController _fadeCtrl;
//   late final AnimationController _floatCtrl;
//   late final Animation<double> _fadeAnim;
//   late final Animation<double> _floatAnim;

//   late final List<_PageData> _pages = [
//     // ── 1. Welcome ────────────────────────────────────────────────────────
//     _PageData(
//       arabic: 'إِنَّ اللَّهَ لَا يُضِيعُ أَجْرَ الْمُحْسِنِينَ',
//       source: 'সূরা তাওবাহ · ৯:১২০',
//       meaning: '"নিশ্চয়ই আল্লাহ সৎকর্মশীলদের প্রতিদান নষ্ট করেন না।"',
//       eyebrow: 'স্বাগতম Sabeq-এ',
//       title: 'প্রতিটা আমলই\nহিসাবে আছে',
//       subtitle: 'আল্লাহ একটা নেক কাজও নষ্ট করেন না।\n'
//           'Sabeq তোমাকে সেই আমলগুলো মনে রাখতে সাহায্য করে — প্রতিদিন, অভ্যাস হিসেবে।',
//       illustrationBuilder: (f, r) => _MosqueIllustration(floatAnim: f, r: r),
//       bgFrom: const Color(0xFF021F10),
//       bgTo: const Color(0xFF0A3D22),
//     ),

//     // ── 2. Tracker ────────────────────────────────────────────────────────
//     _PageData(
//       arabic: 'وَذَكِّرْ فَإِنَّ الذِّكْرَى تَنفَعُ الْمُؤْمِنِينَ',
//       source: 'সূরা আয-যারিয়াত · ৫১:৫৫',
//       meaning:
//           '"স্মরণ করিয়ে দাও, কেননা স্মরণ করিয়ে দেওয়া মুমিনদের উপকার করে।"',
//       eyebrow: 'দৈনিক ট্র্যাকার',
//       title: 'ছোট ছোট আমল\nবড় পরিবর্তন আনে',
//       subtitle: 'ফজর থেকে এশা, কোরআন থেকে যিকির — সবকিছু এক জায়গায়।\n'
//           'একদিন মিস হলেও হতাশ হওয়ার কিছু নেই, পরের দিন আবার শুরু করো।',
//       illustrationBuilder: (f, r) => _TrackerIllustration(floatAnim: f, r: r),
//       bgFrom: const Color(0xFF082E18),
//       bgTo: const Color(0xFF124A28),
//     ),

//     // ── 3. Leaderboard ───────────────────────────────────────────────────
//     _PageData(
//       arabic: 'وَفِي ذَٰلِكَ فَلْيَتَنَافَسِ الْمُتَنَافِسُونَ',
//       source: 'সূরা আল-মুতাফফিফীন · ৮৩:২৬',
//       meaning: '"এটা পেতে প্রতিযোগীরা যেন প্রতিযোগিতা করে।"',
//       eyebrow: 'লিডারবোর্ড',
//       title: 'নেক কাজে\nএগিয়ে থাকার\nপ্রতিযোগিতা',
//       subtitle: 'বন্ধু বা পরিবারের সাথে নেক আমলে এগিয়ে যাও।\n'
//           'চাইলে নাম গোপন রেখেও থাকতে পারবে — শুধু আমলটাই আসল।',
//       illustrationBuilder: (f, r) =>
//           _LeaderboardIllustration(floatAnim: f, r: r),
//       bgFrom: const Color(0xFF0E3D20),
//       bgTo: const Color(0xFF1A5C30),
//     ),

//     // ── 4. Privacy ───────────────────────────────────────────────────────
//     _PageData(
//       arabic: 'وَاللَّهُ يَعْلَمُ مَا تُسِرُّونَ وَمَا تُعْلِنُونَ',
//       source: 'সূরা আন-নাহল · ১৬:১৯',
//       meaning: '"আল্লাহ জানেন যা তোমরা গোপন করো এবং যা তোমরা প্রকাশ করো।"',
//       eyebrow: 'তোমার গোপনীয়তা',
//       title: 'আমল তোমার,\nশেয়ার করা\nতোমার ইচ্ছা',
//       subtitle: 'নিজের স্কোর লুকাতে পারবে, নাম Anonymous রাখতে পারবে।\n'
//           'আল্লাহ তো সব জানেনই — তাঁর কাছে কিছুই লুকানো নেই।',
//       illustrationBuilder: (f, r) => _PrivacyIllustration(floatAnim: f, r: r),
//       bgFrom: const Color(0xFF052818),
//       bgTo: const Color(0xFF0D4425),
//     ),
//   ];

//   bool get _isLast => _cur == _pages.length - 1;

//   @override
//   void initState() {
//     super.initState();
//     _fadeCtrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 520));
//     _floatCtrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 2800))
//       ..repeat(reverse: true);
//     _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
//     _floatAnim = CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut);
//     _fadeCtrl.forward();
//   }

//   @override
//   void dispose() {
//     _pageCtrl.dispose();
//     _fadeCtrl.dispose();
//     _floatCtrl.dispose();
//     super.dispose();
//   }

//   void _onPageChanged(int i) {
//     _fadeCtrl.reset();
//     _fadeCtrl.forward();
//     setState(() => _cur = i);
//   }

//   Future<void> _complete() async {
//     await markOnboardingSeen();
//     onboardingSeenNotifier.value = true;
//     if (mounted) context.go(AppRoutes.login);
//   }

//   void _next() => _pageCtrl.nextPage(
//         duration: const Duration(milliseconds: 420),
//         curve: Curves.easeInOutCubic,
//       );

//   @override
//   Widget build(BuildContext context) {
//     final page = _pages[_cur];
//     final r = _R.of(context);

//     return Scaffold(
//       backgroundColor: page.bgFrom,
//       body: AnimatedContainer(
//         duration: const Duration(milliseconds: 460),
//         curve: Curves.easeInOut,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [page.bgFrom, page.bgTo],
//           ),
//         ),
//         child: Stack(
//           children: [
//             // ── Islamic geometric pattern (full screen behind everything)
//             const Positioned.fill(child: _BgPattern()),

//             // ── Main layout: top-bar / pages / bottom-bar in a Column ──
//             // This ensures bottom bar NEVER overlaps page content.
//             SafeArea(
//               child: Column(
//                 children: [
//                   // ── Top bar ─────────────────────────────────────────
//                   Padding(
//                     padding:
//                         EdgeInsets.fromLTRB(20, r.isCompact ? 6 : 10, 20, 0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         // Brand logo + name
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               width: 34,
//                               height: 34,
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.13),
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(
//                                     color: Colors.white.withOpacity(0.25)),
//                               ),
//                               alignment: Alignment.center,
//                               child: const Text('س',
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 19,
//                                       fontWeight: FontWeight.w700,
//                                       height: 1)),
//                             ),
//                             const SizedBox(width: 9),
//                             const Text('Sabeq',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 17,
//                                     fontWeight: FontWeight.w700,
//                                     letterSpacing: 0.4)),
//                           ],
//                         ),
//                         // Skip button
//                         AnimatedOpacity(
//                           opacity: _isLast ? 0 : 1,
//                           duration: const Duration(milliseconds: 220),
//                           child: IgnorePointer(
//                             ignoring: _isLast,
//                             child: GestureDetector(
//                               onTap: _complete,
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 14, vertical: 7),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.13),
//                                   borderRadius: BorderRadius.circular(20),
//                                   border: Border.all(
//                                       color: Colors.white.withOpacity(0.25)),
//                                 ),
//                                 child: Text('এড়িয়ে যাও',
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: r.eyebrowFs,
//                                         fontWeight: FontWeight.w600)),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // ── Pages — takes all remaining space above bottom bar
//                   Expanded(
//                     child: PageView.builder(
//                       controller: _pageCtrl,
//                       onPageChanged: _onPageChanged,
//                       itemCount: _pages.length,
//                       itemBuilder: (_, i) => _Page(
//                         data: _pages[i],
//                         floatAnim: _floatAnim,
//                         fadeAnim: _fadeAnim,
//                         r: r,
//                       ),
//                     ),
//                   ),

//                   // ── Bottom bar — always below pages, never overlaps ──
//                   _BottomBar(
//                     cur: _cur,
//                     total: _pages.length,
//                     isLast: _isLast,
//                     onNext: _next,
//                     onComplete: _complete,
//                     r: r,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ══════════════════════════════════════════════════════════════════════════
// // SINGLE PAGE
// // ══════════════════════════════════════════════════════════════════════════
// class _Page extends StatelessWidget {
//   final _PageData data;
//   final Animation<double> floatAnim;
//   final Animation<double> fadeAnim;
//   final _R r;

//   const _Page({
//     required this.data,
//     required this.floatAnim,
//     required this.fadeAnim,
//     required this.r,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         // ── Illustration ───────────────────────────────────────────────
//         SizedBox(
//           height: r.illustH,
//           child: AnimatedBuilder(
//             animation: floatAnim,
//             builder: (_, child) => Transform.translate(
//               offset: Offset(0, (floatAnim.value - 0.5) * 14),
//               child: child,
//             ),
//             child: Center(child: data.illustrationBuilder(floatAnim, r)),
//           ),
//         ),

//         // ── Text content — scrollable so it never overflows ────────────
//         Expanded(
//           child: FadeTransition(
//             opacity: fadeAnim,
//             child: SingleChildScrollView(
//               physics: const ClampingScrollPhysics(),
//               padding: EdgeInsets.fromLTRB(r.textPadH, 6, r.textPadH, 12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Ayat card (arabic + meaning + source)
//                   _AyatCard(
//                     arabic: data.arabic,
//                     source: data.source,
//                     meaning: data.meaning,
//                     r: r,
//                   ),
//                   SizedBox(height: r.gap1),

//                   // Eyebrow tag
//                   _EyebrowTag(label: data.eyebrow, r: r),
//                   SizedBox(height: r.gap2),

//                   // Title
//                   Text(
//                     data.title,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: r.titleFs,
//                       fontWeight: FontWeight.w800,
//                       height: 1.28,
//                       letterSpacing: -0.4,
//                     ),
//                   ),
//                   SizedBox(height: r.gap3),

//                   // Subtitle
//                   Text(
//                     data.subtitle,
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.72),
//                       fontSize: r.subtitleFs,
//                       fontWeight: FontWeight.w400,
//                       height: 1.65,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ══════════════════════════════════════════════════════════════════════════
// // AYAT CARD  — arabic + meaning + source, all in one card
// // ══════════════════════════════════════════════════════════════════════════
// class _AyatCard extends StatelessWidget {
//   final String arabic;
//   final String source;
//   final String meaning;
//   final _R r;

//   const _AyatCard({
//     required this.arabic,
//     required this.source,
//     required this.meaning,
//     required this.r,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(
//           horizontal: r.isCompact ? 12 : 14, vertical: r.isCompact ? 10 : 13),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.07),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: _C.gold.withOpacity(0.35)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // ── Arabic text (right-aligned) ───────────────────────────────
//           Text(
//             arabic,
//             textAlign: TextAlign.right,
//             style: TextStyle(
//               color: _C.gold,
//               fontSize: r.arabicFs,
//               fontWeight: FontWeight.w600,
//               height: 1.8,
//             ),
//           ),

//           // ── Divider ───────────────────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 7),
//             child: Container(
//               height: 1,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(colors: [
//                   Colors.transparent,
//                   _C.gold.withOpacity(0.3),
//                   Colors.transparent,
//                 ]),
//               ),
//             ),
//           ),

//           // ── Bangla meaning ────────────────────────────────────────────
//           Text(
//             meaning,
//             textAlign: TextAlign.left,
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.82),
//               fontSize: r.meaningFs,
//               fontWeight: FontWeight.w400,
//               fontStyle: FontStyle.italic,
//               height: 1.6,
//             ),
//           ),

//           const SizedBox(height: 6),

//           // ── Source (right-aligned, subtle) ────────────────────────────
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 width: 4,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: _C.gold.withOpacity(0.55),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               const SizedBox(width: 5),
//               Text(
//                 source,
//                 style: TextStyle(
//                   color: _C.gold.withOpacity(0.6),
//                   fontSize: r.isCompact ? 10.0 : 11.0,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ══════════════════════════════════════════════════════════════════════════
// // EYEBROW TAG
// // ══════════════════════════════════════════════════════════════════════════
// class _EyebrowTag extends StatelessWidget {
//   final String label;
//   final _R r;
//   const _EyebrowTag({required this.label, required this.r});

//   @override
//   Widget build(BuildContext context) => Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//         decoration: BoxDecoration(
//           color: _C.gold.withOpacity(0.15),
//           borderRadius: BorderRadius.circular(6),
//           border: Border.all(color: _C.gold.withOpacity(0.32)),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: _C.gold.withOpacity(0.9),
//             fontSize: r.eyebrowFs,
//             fontWeight: FontWeight.w700,
//             letterSpacing: 0.7,
//           ),
//         ),
//       );
// }

// // ══════════════════════════════════════════════════════════════════════════
// // BOTTOM BAR
// // ══════════════════════════════════════════════════════════════════════════
// class _BottomBar extends StatelessWidget {
//   final int cur;
//   final int total;
//   final bool isLast;
//   final VoidCallback onNext;
//   final VoidCallback onComplete;
//   final _R r;

//   const _BottomBar({
//     required this.cur,
//     required this.total,
//     required this.isLast,
//     required this.onNext,
//     required this.onComplete,
//     required this.r,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // No manual bottom inset needed — we are inside SafeArea Column
//     return Container(
//       padding: EdgeInsets.fromLTRB(
//           26, r.isCompact ? 12 : 16, 26, r.isCompact ? 14 : 18),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.transparent, Colors.black.withOpacity(0.26)],
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Dots
//           Row(
//             children: List.generate(total, (i) {
//               final active = i == cur;
//               return AnimatedContainer(
//                 duration: const Duration(milliseconds: 280),
//                 curve: Curves.easeInOut,
//                 margin: const EdgeInsets.only(right: 6),
//                 width: active ? 22 : 7,
//                 height: 7,
//                 decoration: BoxDecoration(
//                   color: active ? Colors.white : Colors.white.withOpacity(0.3),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               );
//             }),
//           ),

//           // Next / Start button
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 260),
//             transitionBuilder: (child, anim) =>
//                 ScaleTransition(scale: anim, child: child),
//             child: isLast
//                 ? _StartBtn(key: const ValueKey('s'), onTap: onComplete, r: r)
//                 : _NextBtn(key: const ValueKey('n'), onTap: onNext, r: r),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _NextBtn extends StatelessWidget {
//   final VoidCallback onTap;
//   final _R r;
//   const _NextBtn({super.key, required this.onTap, required this.r});

//   @override
//   Widget build(BuildContext context) {
//     final sz = r.isCompact ? 48.0 : 54.0;
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: sz,
//         height: sz,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black.withOpacity(0.22),
//                 blurRadius: 14,
//                 offset: const Offset(0, 5))
//           ],
//         ),
//         child: Icon(Icons.arrow_forward_rounded,
//             color: _C.darkGreen, size: r.isCompact ? 20 : 23),
//       ),
//     );
//   }
// }

// class _StartBtn extends StatelessWidget {
//   final VoidCallback onTap;
//   final _R r;
//   const _StartBtn({super.key, required this.onTap, required this.r});

//   @override
//   Widget build(BuildContext context) => GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: EdgeInsets.symmetric(
//               horizontal: r.isCompact ? 18 : 22,
//               vertical: r.isCompact ? 12 : 15),
//           decoration: BoxDecoration(
//             color: _C.gold,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                   color: _C.gold.withOpacity(0.42),
//                   blurRadius: 18,
//                   offset: const Offset(0, 6))
//             ],
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('শুরু করি',
//                   style: TextStyle(
//                       color: _C.darkGreen,
//                       fontSize: r.isCompact ? 14 : 15,
//                       fontWeight: FontWeight.w800,
//                       letterSpacing: 0.3)),
//               const SizedBox(width: 8),
//               Icon(Icons.arrow_forward_rounded,
//                   color: _C.darkGreen, size: r.isCompact ? 17 : 19),
//             ],
//           ),
//         ),
//       );
// }

// // ══════════════════════════════════════════════════════════════════════════
// // BACKGROUND PATTERN
// // ══════════════════════════════════════════════════════════════════════════
// class _BgPattern extends StatelessWidget {
//   const _BgPattern();
//   @override
//   Widget build(BuildContext context) =>
//       CustomPaint(painter: _PatternPainter(), size: Size.infinite);
// }

// class _PatternPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final p = Paint()
//       ..color = Colors.white.withOpacity(0.032)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1;
//     const s = 72.0;
//     for (double x = -s; x < size.width + s; x += s)
//       for (double y = -s; y < size.height + s; y += s)
//         _oct(canvas, Offset(x, y), 24, p);
//   }

//   void _oct(Canvas canvas, Offset c, double r, Paint p) {
//     final path = Path();
//     for (int i = 0; i < 8; i++) {
//       final a = (i * math.pi / 4) - math.pi / 8;
//       final pt = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
//       i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
//     }
//     canvas.drawPath(path..close(), p);
//   }

//   @override
//   bool shouldRepaint(_PatternPainter _) => false;
// }

// // ══════════════════════════════════════════════════════════════════════════
// // ILLUSTRATIONS  — all use _R for responsive sizing
// // ══════════════════════════════════════════════════════════════════════════

// // ── 1. Mosque ─────────────────────────────────────────────────────────────
// class _MosqueIllustration extends StatelessWidget {
//   final Animation<double> floatAnim;
//   final _R r;
//   const _MosqueIllustration({required this.floatAnim, required this.r});

//   @override
//   Widget build(BuildContext context) {
//     final s = r.sw * 0.76;
//     return Center(
//       child: CustomPaint(painter: _MosquePainter(), size: Size(s, s)),
//     );
//   }
// }

// class _MosquePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;

//     // Shadow
//     canvas.drawOval(
//       Rect.fromCenter(
//           center: Offset(cx, cy + size.height * 0.35),
//           width: size.width * 0.82,
//           height: size.height * 0.1),
//       Paint()
//         ..color = Colors.black.withOpacity(0.2)
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
//     );

//     final white = Paint()..color = Colors.white.withOpacity(0.93);
//     final white2 = Paint()..color = Colors.white.withOpacity(0.78);
//     final goldP = Paint()..color = _C.gold;
//     final goldF = Paint()..color = _C.gold.withOpacity(0.85);

//     // Body
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromLTWH(cx - size.width * 0.28, cy - size.height * 0.08,
//             size.width * 0.56, size.height * 0.43),
//         const Radius.circular(5),
//       ),
//       white,
//     );

//     // Main dome
//     _dome(canvas, Offset(cx, cy - size.height * 0.08), size.width * 0.21,
//         size.height * 0.22, goldF);

//     // Side domes
//     _dome(canvas, Offset(cx - size.width * 0.2, cy - size.height * 0.04),
//         size.width * 0.1, size.height * 0.11, white2);
//     _dome(canvas, Offset(cx + size.width * 0.2, cy - size.height * 0.04),
//         size.width * 0.1, size.height * 0.11, white2);

//     // Minarets
//     for (final sx in [-1.0, 1.0]) {
//       final mx = cx + sx * size.width * 0.31;
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromCenter(
//               center: Offset(mx, cy + size.height * 0.04),
//               width: size.width * 0.055,
//               height: size.height * 0.5),
//           const Radius.circular(4),
//         ),
//         white2,
//       );
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromCenter(
//               center: Offset(mx, cy - size.height * 0.1),
//               width: size.width * 0.1,
//               height: size.height * 0.025),
//           const Radius.circular(3),
//         ),
//         goldF,
//       );
//       _dome(canvas, Offset(mx, cy - size.height * 0.22), size.width * 0.042,
//           size.height * 0.08, goldF);
//       canvas.drawLine(
//         Offset(mx, cy - size.height * 0.3),
//         Offset(mx, cy - size.height * 0.22),
//         Paint()
//           ..color = _C.gold
//           ..strokeWidth = 2
//           ..strokeCap = StrokeCap.round,
//       );
//     }

//     // Door
//     final dw = size.width * 0.13;
//     final dh = size.height * 0.17;
//     final dt = cy + size.height * 0.08;
//     canvas.drawPath(
//       Path()
//         ..moveTo(cx - dw / 2, dt + dh)
//         ..lineTo(cx - dw / 2, dt + dw / 2)
//         ..addArc(
//             Rect.fromCenter(
//                 center: Offset(cx, dt + dw / 2), width: dw, height: dw),
//             math.pi,
//             math.pi)
//         ..lineTo(cx + dw / 2, dt + dh)
//         ..close(),
//       Paint()..color = _C.greenMid.withOpacity(0.55),
//     );

//     // Windows
//     for (final sx in [-1.0, 1.0]) {
//       final wx = cx + sx * size.width * 0.17;
//       final wy = cy + size.height * 0.08;
//       final ww = size.width * 0.09;
//       canvas.drawPath(
//         Path()
//           ..moveTo(wx - ww / 2, wy + ww * 0.85)
//           ..lineTo(wx - ww / 2, wy + ww / 2)
//           ..addArc(
//               Rect.fromCenter(
//                   center: Offset(wx, wy + ww / 2), width: ww, height: ww),
//               math.pi,
//               math.pi)
//           ..lineTo(wx + ww / 2, wy + ww * 0.85)
//           ..close(),
//         Paint()..color = _C.gold.withOpacity(0.55),
//       );
//     }

//     // Crescent
//     _crescent(
//         canvas, Offset(cx, cy - size.height * 0.3), size.width * 0.055, goldP);

//     // Stars
//     final sp = Paint()..color = _C.gold.withOpacity(0.65);
//     for (final (ox, oy) in [(-0.37, -0.37), (0.38, -0.3), (0.14, -0.41)])
//       _star(canvas, Offset(cx + ox * size.width, cy + oy * size.height),
//           size.width * 0.022, sp);
//   }

//   void _dome(Canvas canvas, Offset c, double w, double h, Paint p) =>
//       canvas.drawPath(
//         Path()
//           ..moveTo(c.dx - w, c.dy)
//           ..cubicTo(c.dx - w, c.dy - h * 1.35, c.dx + w, c.dy - h * 1.35,
//               c.dx + w, c.dy)
//           ..close(),
//         p,
//       );

//   void _crescent(Canvas canvas, Offset c, double r, Paint p) => canvas.drawPath(
//         Path.combine(
//           PathOperation.difference,
//           Path()..addOval(Rect.fromCircle(center: c, radius: r)),
//           Path()
//             ..addOval(Rect.fromCircle(
//                 center: Offset(c.dx + r * 0.45, c.dy - r * 0.1),
//                 radius: r * 0.75)),
//         ),
//         p,
//       );

//   void _star(Canvas canvas, Offset c, double r, Paint p) {
//     final path = Path();
//     for (int i = 0; i < 5; i++) {
//       final o = Offset(c.dx + r * math.cos(i * 4 * math.pi / 5 - math.pi / 2),
//           c.dy + r * math.sin(i * 4 * math.pi / 5 - math.pi / 2));
//       final inn = Offset(
//           c.dx + r * 0.4 * math.cos((i * 4 + 2) * math.pi / 5 - math.pi / 2),
//           c.dy + r * 0.4 * math.sin((i * 4 + 2) * math.pi / 5 - math.pi / 2));
//       i == 0 ? path.moveTo(o.dx, o.dy) : path.lineTo(o.dx, o.dy);
//       path.lineTo(inn.dx, inn.dy);
//     }
//     canvas.drawPath(path..close(), p);
//   }

//   @override
//   bool shouldRepaint(_MosquePainter _) => false;
// }

// // ── 2. Tracker phone ──────────────────────────────────────────────────────
// class _TrackerIllustration extends StatelessWidget {
//   final Animation<double> floatAnim;
//   final _R r;
//   const _TrackerIllustration({required this.floatAnim, required this.r});

//   @override
//   Widget build(BuildContext context) => Center(
//         child: CustomPaint(
//           painter: _TrackerPainter(),
//           size: Size(r.sw * 0.60, r.sh * 0.34),
//         ),
//       );
// }

// class _TrackerPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;
//     final pw = size.width;
//     final ph = size.height;

//     final frame = RRect.fromRectAndRadius(
//       Rect.fromCenter(center: Offset(cx, cy), width: pw, height: ph),
//       const Radius.circular(22),
//     );
//     canvas.drawRRect(
//         frame,
//         Paint()
//           ..color = Colors.black.withOpacity(0.2)
//           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
//     canvas.drawRRect(frame, Paint()..color = Colors.white.withOpacity(0.96));

//     // Header
//     canvas.drawRRect(
//       RRect.fromRectAndCorners(
//         Rect.fromLTWH(cx - pw / 2, cy - ph / 2, pw, ph * 0.115),
//         topLeft: const Radius.circular(22),
//         topRight: const Radius.circular(22),
//       ),
//       Paint()..color = _C.darkGreen,
//     );
//     _blob(canvas, Offset(cx - pw * 0.12, cy - ph * 0.43), pw * 0.22, 5,
//         Colors.white.withOpacity(0.7), 3);
//     _blob(canvas, Offset(cx + pw * 0.28, cy - ph * 0.43), pw * 0.1, 5,
//         _C.gold.withOpacity(0.8), 3);

//     // Date chips
//     for (int d = 0; d < 7; d++) {
//       final dx = cx - pw * 0.38 + d * pw * 0.125;
//       final active = d == 3;
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromCenter(
//               center: Offset(dx, cy - ph * 0.31),
//               width: pw * 0.1,
//               height: ph * 0.1),
//           const Radius.circular(8),
//         ),
//         Paint()..color = active ? _C.gold : Colors.grey.withOpacity(0.12),
//       );
//       _blob(canvas, Offset(dx, cy - ph * 0.31), pw * 0.055, 4,
//           active ? _C.darkGreen : Colors.grey.withOpacity(0.4), 2);
//     }

//     // Rows
//     const rows = [true, true, true, false, false, true];
//     final colors = [
//       _C.greenAccent,
//       _C.greenAccent,
//       _C.greenAccent,
//       _C.gold,
//       Colors.grey,
//       _C.greenAccent,
//     ];
//     for (int i = 0; i < rows.length; i++) {
//       final done = rows[i];
//       final color = colors[i];
//       final ry = cy - ph * 0.15 + i * ph * 0.105;

//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromCenter(
//               center: Offset(cx, ry), width: pw * 0.85, height: ph * 0.085),
//           const Radius.circular(9),
//         ),
//         Paint()
//           ..color =
//               done ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
//       );

//       final cbC = Offset(cx - pw * 0.36, ry);
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromCenter(center: cbC, width: 15, height: 15),
//           const Radius.circular(4),
//         ),
//         Paint()..color = done ? color : Colors.grey.withOpacity(0.2),
//       );
//       if (done) {
//         final ck = Paint()
//           ..color = Colors.white
//           ..strokeWidth = 2
//           ..style = PaintingStyle.stroke
//           ..strokeCap = StrokeCap.round;
//         canvas.drawLine(
//             Offset(cbC.dx - 4, cbC.dy), Offset(cbC.dx - 1, cbC.dy + 3), ck);
//         canvas.drawLine(
//             Offset(cbC.dx - 1, cbC.dy + 3), Offset(cbC.dx + 5, cbC.dy - 3), ck);
//       }
//       _blob(canvas, Offset(cx - pw * 0.14, ry), pw * 0.32, 5,
//           done ? color.withOpacity(0.5) : Colors.grey.withOpacity(0.25), 3);
//       _blob(canvas, Offset(cx + pw * 0.32, ry), pw * 0.1, 13,
//           done ? color.withOpacity(0.2) : Colors.transparent, 6);
//     }

//     // Progress bar
//     final pbY = cy + ph * 0.45;
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(Rect.fromLTWH(cx - pw * 0.38, pbY, pw * 0.76, 5),
//           const Radius.circular(3)),
//       Paint()..color = Colors.grey.withOpacity(0.15),
//     );
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//           Rect.fromLTWH(cx - pw * 0.38, pbY, pw * 0.76 * 0.67, 5),
//           const Radius.circular(3)),
//       Paint()..color = _C.greenAccent,
//     );
//   }

//   void _blob(
//           Canvas canvas, Offset c, double w, double h, Color color, double r) =>
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(Rect.fromCenter(center: c, width: w, height: h),
//             Radius.circular(r)),
//         Paint()..color = color,
//       );

//   @override
//   bool shouldRepaint(_TrackerPainter _) => false;
// }

// // ── 3. Leaderboard ───────────────────────────────────────────────────────
// class _LeaderboardIllustration extends StatelessWidget {
//   final Animation<double> floatAnim;
//   final _R r;
//   const _LeaderboardIllustration({required this.floatAnim, required this.r});

//   @override
//   Widget build(BuildContext context) => Center(
//         child: CustomPaint(
//           painter: _LeaderboardPainter(),
//           size: Size(r.sw * 0.76, r.sh * 0.34),
//         ),
//       );
// }

// class _LeaderboardPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;

//     _trophy(canvas, Offset(cx, cy - size.height * 0.3), size.width * 0.18);

//     final bw = size.width * 0.26;
//     final baseY = cy + size.height * 0.42;

//     _podium(canvas, Offset(cx - bw * 1.05, baseY), bw * 0.9, size.height * 0.28,
//         Colors.white.withOpacity(0.7), '২');
//     _podium(canvas, Offset(cx, baseY), bw, size.height * 0.42, _C.gold, '১');
//     _podium(canvas, Offset(cx + bw * 1.05, baseY), bw * 0.9, size.height * 0.2,
//         _C.greenAccent.withOpacity(0.75), '৩');

//     _avatar(canvas, Offset(cx - bw * 1.05, baseY - size.height * 0.28 - 30), 22,
//         Colors.white.withOpacity(0.85), _C.textSec);

//     canvas.drawCircle(
//         Offset(cx, baseY - size.height * 0.42 - 30),
//         32,
//         Paint()
//           ..color = _C.gold.withOpacity(0.28)
//           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
//     _avatar(canvas, Offset(cx, baseY - size.height * 0.42 - 30), 26, _C.gold,
//         _C.darkGreen);

//     _avatar(canvas, Offset(cx + bw * 1.05, baseY - size.height * 0.2 - 28), 20,
//         _C.greenAccent, Colors.white);

//     // Ray burst
//     final rp = Paint()
//       ..color = _C.gold.withOpacity(0.38)
//       ..strokeWidth = 1.5;
//     for (int i = 0; i < 8; i++) {
//       final a = i * math.pi / 4;
//       final oc = Offset(cx, baseY - size.height * 0.42 - 30);
//       canvas.drawLine(
//         Offset(oc.dx + 38 * math.cos(a), oc.dy + 38 * math.sin(a)),
//         Offset(oc.dx + 50 * math.cos(a), oc.dy + 50 * math.sin(a)),
//         rp,
//       );
//     }

//     // Anonymous badge hint
//     final bc = Offset(cx + size.width * 0.38, cy - size.height * 0.05);
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//           Rect.fromCenter(center: bc, width: 54, height: 30),
//           const Radius.circular(10)),
//       Paint()..color = Colors.white.withOpacity(0.1),
//     );
//     canvas.drawCircle(Offset(bc.dx - 9, bc.dy), 9,
//         Paint()..color = Colors.white.withOpacity(0.22));
//     final qp = TextPainter(
//       text: TextSpan(
//         text: '?',
//         style: TextStyle(
//             color: Colors.white.withOpacity(0.65),
//             fontSize: 13,
//             fontWeight: FontWeight.w700),
//       ),
//       textDirection: TextDirection.ltr,
//     )..layout();
//     qp.paint(canvas, Offset(bc.dx + 8, bc.dy - 9));
//   }

//   void _podium(Canvas canvas, Offset base, double w, double h, Color color,
//       String rank) {
//     canvas.drawRRect(
//       RRect.fromRectAndCorners(
//         Rect.fromLTWH(base.dx - w / 2, base.dy - h, w, h),
//         topLeft: const Radius.circular(10),
//         topRight: const Radius.circular(10),
//       ),
//       Paint()..color = color,
//     );
//     final tp = TextPainter(
//       text: TextSpan(
//         text: rank,
//         style: TextStyle(
//           color: rank == '১' ? _C.darkGreen : Colors.white.withOpacity(0.85),
//           fontSize: 16,
//           fontWeight: FontWeight.w800,
//         ),
//       ),
//       textDirection: TextDirection.ltr,
//     )..layout();
//     tp.paint(canvas, Offset(base.dx - tp.width / 2, base.dy - 24));
//   }

//   void _avatar(Canvas canvas, Offset c, double r, Color bg, Color fg) {
//     canvas.drawCircle(
//         c, r + 3, Paint()..color = Colors.white.withOpacity(0.18));
//     canvas.drawCircle(c, r, Paint()..color = bg);
//     canvas.drawCircle(Offset(c.dx, c.dy - r * 0.27), r * 0.33,
//         Paint()..color = fg.withOpacity(0.85));
//     canvas.drawArc(
//       Rect.fromCenter(
//           center: Offset(c.dx, c.dy + r * 0.45), width: r * 1.1, height: r),
//       math.pi,
//       math.pi,
//       false,
//       Paint()
//         ..color = fg.withOpacity(0.85)
//         ..style = PaintingStyle.fill,
//     );
//   }

//   void _trophy(Canvas canvas, Offset c, double r) {
//     final p = Paint()..color = _C.gold;
//     canvas.drawPath(
//       Path()
//         ..moveTo(c.dx - r, c.dy - r * 0.3)
//         ..cubicTo(c.dx - r * 1.2, c.dy + r * 0.7, c.dx + r * 1.2,
//             c.dy + r * 0.7, c.dx + r, c.dy - r * 0.3)
//         ..lineTo(c.dx + r * 0.6, c.dy - r)
//         ..lineTo(c.dx - r * 0.6, c.dy - r)
//         ..close(),
//       p,
//     );
//     for (final sx in [-1.0, 1.0]) {
//       canvas.drawArc(
//         Rect.fromCenter(
//             center: Offset(c.dx + sx * r * 0.98, c.dy - r * 0.15),
//             width: r * 0.55,
//             height: r * 0.65),
//         sx > 0 ? -math.pi / 2 : math.pi / 2,
//         math.pi,
//         false,
//         Paint()
//           ..color = _C.gold
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = r * 0.14,
//       );
//     }
//     canvas.drawRect(
//         Rect.fromCenter(
//             center: Offset(c.dx, c.dy + r * 0.9),
//             width: r * 0.22,
//             height: r * 0.45),
//         p);
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromCenter(
//             center: Offset(c.dx, c.dy + r * 1.22),
//             width: r * 0.85,
//             height: r * 0.18),
//         const Radius.circular(4),
//       ),
//       p,
//     );
//   }

//   @override
//   bool shouldRepaint(_LeaderboardPainter _) => false;
// }

// // ── 4. Privacy ────────────────────────────────────────────────────────────
// class _PrivacyIllustration extends StatelessWidget {
//   final Animation<double> floatAnim;
//   final _R r;
//   const _PrivacyIllustration({required this.floatAnim, required this.r});

//   @override
//   Widget build(BuildContext context) => Center(
//         child: CustomPaint(
//           painter: _PrivacyPainter(),
//           size: Size(r.sw * 0.70, r.sh * 0.32),
//         ),
//       );
// }

// class _PrivacyPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;
//     final sr = size.width * 0.22;

//     // Shield
//     final shield = Path()
//       ..moveTo(cx, cy - sr * 1.2)
//       ..cubicTo(cx + sr * 1.2, cy - sr * 0.8, cx + sr * 1.2, cy + sr * 0.4, cx,
//           cy + sr * 1.2)
//       ..cubicTo(cx - sr * 1.2, cy + sr * 0.4, cx - sr * 1.2, cy - sr * 0.8, cx,
//           cy - sr * 1.2)
//       ..close();

//     canvas.drawPath(
//         shield,
//         Paint()
//           ..color = _C.greenAccent.withOpacity(0.22)
//           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16));
//     canvas.drawPath(shield, Paint()..color = _C.greenMid.withOpacity(0.68));
//     canvas.drawPath(
//         shield,
//         Paint()
//           ..color = Colors.white.withOpacity(0.38)
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 2.5);

//     // Lock
//     final lw = sr * 0.55;
//     final lh = sr * 0.45;
//     final lcy = cy + sr * 0.2;
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//           Rect.fromCenter(center: Offset(cx, lcy), width: lw, height: lh),
//           const Radius.circular(7)),
//       Paint()..color = Colors.white.withOpacity(0.9),
//     );
//     canvas.drawArc(
//       Rect.fromCenter(
//           center: Offset(cx, lcy - lh / 2), width: lw * 0.6, height: lw * 0.6),
//       math.pi,
//       math.pi,
//       false,
//       Paint()
//         ..color = Colors.white.withOpacity(0.9)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 4
//         ..strokeCap = StrokeCap.round,
//     );
//     canvas.drawCircle(Offset(cx, lcy - 2), 5, Paint()..color = _C.greenMid);
//     canvas.drawRect(
//         Rect.fromCenter(center: Offset(cx, lcy + 7), width: 4, height: 9),
//         Paint()..color = _C.greenMid);

//     // Feature cards
//     final cards = [
//       (cx - size.width * 0.38, cy - size.height * 0.22, 'আমল\nলুকাও'),
//       (cx + size.width * 0.32, cy - size.height * 0.22, 'নাম\nগোপন'),
//       (cx - size.width * 0.38, cy + size.height * 0.22, 'নিজে\nশেয়ার করো'),
//     ];

//     for (final (fx, fy, label) in cards) {
//       _featureCard(canvas, Offset(fx, fy), label, size);
//     }

//     // Dashed connectors
//     final dashP = Paint()
//       ..color = Colors.white.withOpacity(0.18)
//       ..strokeWidth = 1.5;
//     for (final (fx, fy, _) in cards)
//       _dashedLine(canvas, Offset(fx, fy), Offset(cx, cy), dashP);
//   }

//   void _featureCard(Canvas canvas, Offset c, String label, Size size) {
//     final w = size.width * 0.28;
//     final h = size.height * 0.28;

//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//           Rect.fromCenter(center: c, width: w + 6, height: h + 6),
//           const Radius.circular(14)),
//       Paint()
//         ..color = _C.greenAccent.withOpacity(0.1)
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
//     );
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(Rect.fromCenter(center: c, width: w, height: h),
//           const Radius.circular(12)),
//       Paint()..color = Colors.white.withOpacity(0.09),
//     );
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(Rect.fromCenter(center: c, width: w, height: h),
//           const Radius.circular(12)),
//       Paint()
//         ..color = Colors.white.withOpacity(0.22)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 1,
//     );
//     // gold dot
//     canvas.drawCircle(Offset(c.dx, c.dy - h * 0.2), h * 0.14,
//         Paint()..color = _C.gold.withOpacity(0.5));

//     final tp = TextPainter(
//       text: TextSpan(
//         text: label,
//         style: const TextStyle(
//             color: Colors.white,
//             fontSize: 9.5,
//             fontWeight: FontWeight.w600,
//             height: 1.4),
//       ),
//       textDirection: TextDirection.ltr,
//       textAlign: TextAlign.center,
//     )..layout(maxWidth: w - 8);
//     tp.paint(canvas, Offset(c.dx - tp.width / 2, c.dy + h * 0.05));
//   }

//   void _dashedLine(Canvas canvas, Offset a, Offset b, Paint p) {
//     final dx = b.dx - a.dx;
//     final dy = b.dy - a.dy;
//     final dist = math.sqrt(dx * dx + dy * dy);
//     final nx = dx / dist;
//     final ny = dy / dist;
//     double t = 0;
//     while (t < dist - 40) {
//       canvas.drawLine(
//         Offset(a.dx + nx * t, a.dy + ny * t),
//         Offset(a.dx + nx * (t + 5), a.dy + ny * (t + 5)),
//         p,
//       );
//       t += 9;
//     }
//   }

//   @override
//   bool shouldRepaint(_PrivacyPainter _) => false;
// }

// this is not appropriate, cause how user will understand its scrollable, and onboarding page if scorllable then its not be a good ux so think properly, text line gula max width komanor jonno hoito mulitple line hoa jsche, abr quran er arabic ayah ta ki asholei dorker!! only bangla hole hobe na!! top er image or emoji vview ta ki besthi boro hoa gace eta ki r aktu choto korle better hobe na!! think properly with best according to ux and ui design, and also think about the content of the onboarding page, like what are the key features or benefits of the app that you want to highlight to the users, and how can you present them in a visually appealing and easy to understand way. maybe you can use some icons or illustrations to represent each feature or benefit, and also use some catchy headlines or taglines to grab the users attention. also consider the flow of the onboarding process, like how many screens do you want to have, and what information do you want to show on each screen. remember that the goal of the onboarding process is to educate and engage the users, so make sure that it is informative, interactive, and enjoyable for them.

// lib/features/onboarding/onboarding_screen.dart

import 'dart:math' as math;
import 'package:amal_tracker/core/router/app_router.dart';
import 'package:amal_tracker/features/onboarding/provider/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ══════════════════════════════════════════════════════════════════════════
// COLORS
// ══════════════════════════════════════════════════════════════════════════
class _C {
  static const darkGreen = Color(0xFF033019);
  static const greenMid = Color(0xFF2D8A52);
  static const greenAccent = Color(0xFF4CAF78);
  static const gold = Color(0xFFF5C842);
  static const textSec = Color(0xFF5A7A67);
}

// ══════════════════════════════════════════════════════════════════════════
// RESPONSIVE — single source of truth
// sh < 640   → compact  (SE, Moto G)
// 640–799    → normal   (most flagships)
// ≥ 800      → large    (Pro Max, foldables)
// ══════════════════════════════════════════════════════════════════════════
class _R {
  final double sw;
  final double sh;
  const _R({required this.sw, required this.sh});
  factory _R.of(BuildContext ctx) {
    final s = MediaQuery.sizeOf(ctx);
    return _R(sw: s.width, sh: s.height);
  }

  bool get isCompact => sh < 640;
  bool get isLarge => sh >= 800;

  // Illustration: a clean fraction of screen — small enough to always
  // leave room for the text block below without any scroll.
  double get illustH => isCompact
      ? sh * 0.30
      : isLarge
          ? sh * 0.34
          : sh * 0.32;

  double get titleFs => isCompact
      ? 22.0
      : isLarge
          ? 27.0
          : 24.0;
  double get subtitleFs => isCompact ? 12.5 : 13.5;
  double get quoteFs => isCompact ? 12.0 : 13.0;
  double get eyebrowFs => isCompact ? 10.0 : 11.0;
  double get padH => isCompact ? 22.0 : 28.0;

  // Gaps between text elements
  double get gapQuoteTitle => isCompact ? 8.0 : 14.0;
  double get gapTitleSubtitle => isCompact ? 6.0 : 8.0;
  double get gapSubtitleBot => isCompact ? 6.0 : 8.0;
}

// ══════════════════════════════════════════════════════════════════════════
// PAGE DATA — no arabic field anymore
// ══════════════════════════════════════════════════════════════════════════
class _PageData {
  final String eyebrow;
  final String title;
  final String subtitle; // max 2 short lines
  final String quote; // bangla meaning only, 1 line ideally
  final String quoteSource;
  final Widget Function(Animation<double> float, _R r) painter;
  final Color bgFrom;
  final Color bgTo;

  const _PageData({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.quote,
    required this.quoteSource,
    required this.painter,
    required this.bgFrom,
    required this.bgTo,
  });
}

// ══════════════════════════════════════════════════════════════════════════
// SCREEN
// ══════════════════════════════════════════════════════════════════════════
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final _ctrl = PageController();
  int _cur = 0;

  late final AnimationController _fadeCtrl;
  late final AnimationController _floatCtrl;
  late final Animation<double> _fade;
  late final Animation<double> _float;

  static final _pages = [
    // 1 ─ Welcome
    _PageData(
      eyebrow: 'স্বাগতম Sabeq-এ',
      title: 'প্রতিটা আমলই\nহিসাবে আছে',
      subtitle:
          'নেক কাজ ছোট হলেও আল্লাহ তা নষ্ট করেন না —\nSabeq তোমাকে সেটা মনে রাখতে সাহায্য করে।',
      quote: '"আল্লাহ সৎকর্মশীলদের প্রতিদান নষ্ট করেন না।"',
      quoteSource: 'সূরা তাওবাহ · ৯:১২০',
      painter: (f, r) => _MosqueIllustration(float: f, r: r),
      bgFrom: const Color(0xFF021F10),
      bgTo: const Color(0xFF0A3D22),
    ),
    // 2 ─ Tracker
    _PageData(
      eyebrow: 'দৈনিক ট্র্যাকার',
      title: 'ছোট আমল,\nবড় পরিবর্তন',
      subtitle:
          'নামাজ, কোরআন, যিকির — সব এক জায়গায়।\nএকদিন মিস হলেও পরের দিন আবার শুরু করো।',
      quote: '"স্মরণ করিয়ে দাও — তা মুমিনদের উপকার করে।"',
      quoteSource: 'সূরা আয-যারিয়াত · ৫১:৫৫',
      painter: (f, r) => _TrackerIllustration(float: f, r: r),
      bgFrom: const Color(0xFF082E18),
      bgTo: const Color(0xFF124A28),
    ),
    // 3 ─ Leaderboard
    _PageData(
      eyebrow: 'লিডারবোর্ড',
      title: 'নেক কাজে\nএগিয়ে থাকো',
      subtitle:
          'বন্ধু-পরিবারের সাথে প্রতিযোগিতা করো।\nনাম গোপন রেখেও অংশ নেওয়া যাবে।',
      quote: '"এটা পেতে প্রতিযোগীরা যেন প্রতিযোগিতা করে।"',
      quoteSource: 'সূরা আল-মুতাফফিফীন · ৮৩:২৬',
      painter: (f, r) => _LeaderboardIllustration(float: f, r: r),
      bgFrom: const Color(0xFF0E3D20),
      bgTo: const Color(0xFF1A5C30),
    ),
    // 4 ─ Privacy
    _PageData(
      eyebrow: 'গোপনীয়তা',
      title: 'আমল তোমার,\nশেয়ার তোমার ইচ্ছা',
      subtitle:
          'স্কোর লুকাও, নাম Anonymous রাখো —\nআল্লাহর কাছে সব আমল পৌঁছে যায়।',
      quote: '"আল্লাহ জানেন যা তোমরা গোপন ও প্রকাশ করো।"',
      quoteSource: 'সূরা আন-নাহল · ১৬:১৯',
      painter: (f, r) => _PrivacyIllustration(float: f, r: r),
      bgFrom: const Color(0xFF052818),
      bgTo: const Color(0xFF0D4425),
    ),
  ];

  bool get _isLast => _cur == _pages.length - 1;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 480));
    _floatCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2800))
      ..repeat(reverse: true);
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _float = CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _fadeCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  void _onChanged(int i) {
    _fadeCtrl.reset();
    _fadeCtrl.forward();
    setState(() => _cur = i);
  }

  Future<void> _finish() async {
    await markOnboardingSeen();
    onboardingSeenNotifier.value = true;
    if (mounted) context.go(AppRoutes.login);
  }

  void _next() => _ctrl.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic);

  @override
  Widget build(BuildContext context) {
    final r = _R.of(context);
    final page = _pages[_cur];

    return Scaffold(
      backgroundColor: page.bgFrom,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [page.bgFrom, page.bgTo],
          ),
        ),
        child: Stack(
          children: [
            // Decorative pattern — purely visual, behind everything
            const Positioned.fill(child: _BgPattern()),

            // ── Main column — top-bar / pages / bottom-bar ─────────────
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Top bar ───────────────────────────────────────────
                  _TopBar(
                    isLast: _isLast,
                    onSkip: _finish,
                    r: r,
                  ),

                  // ── PageView — fills remaining space ──────────────────
                  Expanded(
                    child: PageView.builder(
                      controller: _ctrl,
                      onPageChanged: _onChanged,
                      itemCount: _pages.length,
                      itemBuilder: (_, i) => _Page(
                        data: _pages[i],
                        float: _float,
                        fade: _fade,
                        r: r,
                      ),
                    ),
                  ),

                  // ── Bottom bar — always below pages ───────────────────
                  _BottomBar(
                    cur: _cur,
                    total: _pages.length,
                    isLast: _isLast,
                    onNext: _next,
                    onFinish: _finish,
                    r: r,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// TOP BAR
// ══════════════════════════════════════════════════════════════════════════
class _TopBar extends StatelessWidget {
  final bool isLast;
  final VoidCallback onSkip;
  final _R r;
  const _TopBar({required this.isLast, required this.onSkip, required this.r});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, r.isCompact ? 6 : 10, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Brand
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withOpacity(0.22)),
                ),
                child: const Text('س',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1)),
              ),
              const SizedBox(width: 8),
              const Text('Sabeq',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3)),
            ],
          ),
          // Skip
          AnimatedOpacity(
            opacity: isLast ? 0 : 1,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: isLast,
              child: GestureDetector(
                onTap: onSkip,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  // larger hit area, visual pill smaller
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.22)),
                    ),
                    child: Text('এড়িয়ে যাও',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: r.eyebrowFs,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// PAGE — illustration + text, no scroll, everything fits
// ══════════════════════════════════════════════════════════════════════════
class _Page extends StatelessWidget {
  final _PageData data;
  final Animation<double> float;
  final Animation<double> fade;
  final _R r;
  const _Page({
    required this.data,
    required this.float,
    required this.fade,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Illustration ────────────────────────────────────────────────
        SizedBox(
          height: r.illustH,
          child: AnimatedBuilder(
            animation: float,
            builder: (_, child) => Transform.translate(
              offset: Offset(0, (float.value - 0.5) * 12),
              child: child,
            ),
            child: Center(child: data.painter(float, r)),
          ),
        ),

        // ── Text block — fixed, no scroll ───────────────────────────────
        Expanded(
          child: FadeTransition(
            opacity: fade,
            child: Padding(
              padding: EdgeInsets.fromLTRB(r.padH, 0, r.padH, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Eyebrow tag
                  _Tag(label: data.eyebrow, r: r),
                  SizedBox(height: r.gapQuoteTitle * 0.6),

                  // Title
                  Text(
                    data.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: r.titleFs,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: r.gapTitleSubtitle),

                  // Subtitle — max 2 lines, never wraps more
                  Text(
                    data.subtitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.68),
                      fontSize: r.subtitleFs,
                      fontWeight: FontWeight.w400,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: r.gapSubtitleBot),

                  // Quote strip — compact single line design
                  _QuoteStrip(
                    quote: data.quote,
                    source: data.quoteSource,
                    r: r,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// EYEBROW TAG
// ══════════════════════════════════════════════════════════════════════════
class _Tag extends StatelessWidget {
  final String label;
  final _R r;
  const _Tag({required this.label, required this.r});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _C.gold.withOpacity(0.14),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: _C.gold.withOpacity(0.30)),
        ),
        child: Text(label,
            style: TextStyle(
                color: _C.gold.withOpacity(0.9),
                fontSize: r.eyebrowFs,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6)),
      );
}

// ══════════════════════════════════════════════════════════════════════════
// QUOTE STRIP — compact horizontal layout, no arabic
// ══════════════════════════════════════════════════════════════════════════
class _QuoteStrip extends StatelessWidget {
  final String quote;
  final String source;
  final _R r;
  const _QuoteStrip(
      {required this.quote, required this.source, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.gold.withOpacity(0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gold left bar accent
          Container(
            width: 3,
            height: 36,
            margin: const EdgeInsets.only(right: 10, top: 1),
            decoration: BoxDecoration(
              color: _C.gold.withOpacity(0.7),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Quote + source stacked
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quote,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: r.quoteFs,
                    fontStyle: FontStyle.italic,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  source,
                  style: TextStyle(
                    color: _C.gold.withOpacity(0.6),
                    fontSize: r.isCompact ? 10.0 : 10.5,
                    fontWeight: FontWeight.w600,
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

// ══════════════════════════════════════════════════════════════════════════
// BOTTOM BAR — dots + next/finish
// ══════════════════════════════════════════════════════════════════════════
class _BottomBar extends StatelessWidget {
  final int cur;
  final int total;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onFinish;
  final _R r;
  const _BottomBar({
    required this.cur,
    required this.total,
    required this.isLast,
    required this.onNext,
    required this.onFinish,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          26, r.isCompact ? 10 : 14, 26, r.isCompact ? 14 : 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Dots
          Row(
            children: List.generate(total, (i) {
              final active = i == cur;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(right: 6),
                width: active ? 20.0 : 7.0,
                height: 7,
                decoration: BoxDecoration(
                  color: active ? Colors.white : Colors.white.withOpacity(0.28),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),

          // Button
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: isLast
                ? _FinishBtn(key: const ValueKey('f'), onTap: onFinish, r: r)
                : _NextBtn(key: const ValueKey('n'), onTap: onNext, r: r),
          ),
        ],
      ),
    );
  }
}

class _NextBtn extends StatelessWidget {
  final VoidCallback onTap;
  final _R r;
  const _NextBtn({super.key, required this.onTap, required this.r});
  @override
  Widget build(BuildContext context) {
    final sz = r.isCompact ? 46.0 : 52.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: sz,
        height: sz,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
        ),
        child: Icon(Icons.arrow_forward_rounded,
            color: _C.darkGreen, size: r.isCompact ? 20.0 : 22.0),
      ),
    );
  }
}

class _FinishBtn extends StatelessWidget {
  final VoidCallback onTap;
  final _R r;
  const _FinishBtn({super.key, required this.onTap, required this.r});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: r.isCompact ? 18 : 22,
              vertical: r.isCompact ? 12 : 14),
          decoration: BoxDecoration(
            color: _C.gold,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: _C.gold.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 5))
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('শুরু করি',
                  style: TextStyle(
                      color: _C.darkGreen,
                      fontSize: r.isCompact ? 14.0 : 15.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2)),
              const SizedBox(width: 7),
              Icon(Icons.arrow_forward_rounded,
                  color: _C.darkGreen, size: r.isCompact ? 17.0 : 18.0),
            ],
          ),
        ),
      );
}

// ══════════════════════════════════════════════════════════════════════════
// BACKGROUND PATTERN
// ══════════════════════════════════════════════════════════════════════════
class _BgPattern extends StatelessWidget {
  const _BgPattern();
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _PatternPainter(), size: Size.infinite);
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    const s = 72.0;
    for (double x = -s; x < size.width + s; x += s)
      for (double y = -s; y < size.height + s; y += s)
        _oct(canvas, Offset(x, y), 24, p);
  }

  void _oct(Canvas canvas, Offset c, double r, Paint p) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final a = (i * math.pi / 4) - math.pi / 8;
      final pt = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
      i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
    }
    canvas.drawPath(path..close(), p);
  }

  @override
  bool shouldRepaint(_PatternPainter _) => false;
}

// ══════════════════════════════════════════════════════════════════════════
// ILLUSTRATIONS
// ══════════════════════════════════════════════════════════════════════════

// ── 1. Mosque ─────────────────────────────────────────────────────────────
class _MosqueIllustration extends StatelessWidget {
  final Animation<double> float;
  final _R r;
  const _MosqueIllustration({required this.float, required this.r});
  @override
  Widget build(BuildContext context) {
    final s = r.sw * 0.72;
    return CustomPaint(painter: _MosquePainter(), size: Size(s, s));
  }
}

class _MosquePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // shadow
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, cy + size.height * 0.35),
          width: size.width * 0.82,
          height: size.height * 0.1),
      Paint()
        ..color = Colors.black.withOpacity(0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    final w = Paint()..color = Colors.white.withOpacity(0.93);
    final w2 = Paint()..color = Colors.white.withOpacity(0.78);
    final g = Paint()..color = _C.gold.withOpacity(0.88);

    // body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - size.width * 0.28, cy - size.height * 0.08,
            size.width * 0.56, size.height * 0.43),
        const Radius.circular(5),
      ),
      w,
    );
    // domes
    _dome(canvas, Offset(cx, cy - size.height * 0.08), size.width * 0.21,
        size.height * 0.22, g);
    _dome(canvas, Offset(cx - size.width * 0.2, cy - size.height * 0.04),
        size.width * 0.1, size.height * 0.11, w2);
    _dome(canvas, Offset(cx + size.width * 0.2, cy - size.height * 0.04),
        size.width * 0.1, size.height * 0.11, w2);

    // minarets
    for (final sx in [-1.0, 1.0]) {
      final mx = cx + sx * size.width * 0.31;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(mx, cy + size.height * 0.04),
              width: size.width * 0.055,
              height: size.height * 0.5),
          const Radius.circular(4),
        ),
        w2,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(mx, cy - size.height * 0.1),
              width: size.width * 0.1,
              height: size.height * 0.025),
          const Radius.circular(3),
        ),
        g,
      );
      _dome(canvas, Offset(mx, cy - size.height * 0.22), size.width * 0.042,
          size.height * 0.08, g);
      canvas.drawLine(
        Offset(mx, cy - size.height * 0.3),
        Offset(mx, cy - size.height * 0.22),
        Paint()
          ..color = _C.gold
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );
    }
    // door
    final dw = size.width * 0.13;
    final dt = cy + size.height * 0.08;
    canvas.drawPath(
      Path()
        ..moveTo(cx - dw / 2, dt + dw * 1.3)
        ..lineTo(cx - dw / 2, dt + dw / 2)
        ..addArc(
            Rect.fromCenter(
                center: Offset(cx, dt + dw / 2), width: dw, height: dw),
            math.pi,
            math.pi)
        ..lineTo(cx + dw / 2, dt + dw * 1.3)
        ..close(),
      Paint()..color = _C.greenMid.withOpacity(0.55),
    );
    // crescent
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()
          ..addOval(Rect.fromCircle(
              center: Offset(cx, cy - size.height * 0.3),
              radius: size.width * 0.055)),
        Path()
          ..addOval(Rect.fromCircle(
              center: Offset(cx + size.width * 0.025, cy - size.height * 0.305),
              radius: size.width * 0.042)),
      ),
      Paint()..color = _C.gold,
    );
    // stars
    final sp = Paint()..color = _C.gold.withOpacity(0.6);
    for (final (ox, oy) in [(-0.36, -0.36), (0.37, -0.29), (0.13, -0.40)])
      _star(canvas, Offset(cx + ox * size.width, cy + oy * size.height),
          size.width * 0.02, sp);
  }

  void _dome(Canvas canvas, Offset c, double w, double h, Paint p) =>
      canvas.drawPath(
        Path()
          ..moveTo(c.dx - w, c.dy)
          ..cubicTo(c.dx - w, c.dy - h * 1.35, c.dx + w, c.dy - h * 1.35,
              c.dx + w, c.dy)
          ..close(),
        p,
      );

  void _star(Canvas canvas, Offset c, double r, Paint p) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final o = Offset(c.dx + r * math.cos(i * 4 * math.pi / 5 - math.pi / 2),
          c.dy + r * math.sin(i * 4 * math.pi / 5 - math.pi / 2));
      final inn = Offset(
          c.dx + r * .4 * math.cos((i * 4 + 2) * math.pi / 5 - math.pi / 2),
          c.dy + r * .4 * math.sin((i * 4 + 2) * math.pi / 5 - math.pi / 2));
      i == 0 ? path.moveTo(o.dx, o.dy) : path.lineTo(o.dx, o.dy);
      path.lineTo(inn.dx, inn.dy);
    }
    canvas.drawPath(path..close(), p);
  }

  @override
  bool shouldRepaint(_MosquePainter _) => false;
}

// ── 2. Tracker phone ──────────────────────────────────────────────────────
class _TrackerIllustration extends StatelessWidget {
  final Animation<double> float;
  final _R r;
  const _TrackerIllustration({required this.float, required this.r});
  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _TrackerPainter(),
        size: Size(r.sw * 0.58, r.sh * 0.30),
      );
}

class _TrackerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final frame = RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(cx, cy), width: size.width, height: size.height),
        const Radius.circular(20));
    canvas.drawRRect(
        frame,
        Paint()
          ..color = Colors.black.withOpacity(0.18)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
    canvas.drawRRect(frame, Paint()..color = Colors.white.withOpacity(0.96));

    // Header
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(cx - size.width / 2, cy - size.height / 2, size.width,
            size.height * 0.12),
        topLeft: const Radius.circular(20),
        topRight: const Radius.circular(20),
      ),
      Paint()..color = _C.darkGreen,
    );
    _blob(canvas, Offset(cx - size.width * .1, cy - size.height * .44),
        size.width * .2, 5, Colors.white.withOpacity(0.7), 3);

    // Rows
    const done = [true, true, true, false, false, true];
    final colors = [
      _C.greenAccent,
      _C.greenAccent,
      _C.greenAccent,
      _C.gold,
      Colors.grey,
      _C.greenAccent,
    ];
    for (int i = 0; i < 6; i++) {
      final ry = cy - size.height * 0.26 + i * size.height * 0.115;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(cx, ry),
              width: size.width * 0.84,
              height: size.height * 0.09),
          const Radius.circular(8),
        ),
        Paint()
          ..color = done[i]
              ? colors[i].withOpacity(0.1)
              : Colors.grey.withOpacity(0.05),
      );
      final cb = Offset(cx - size.width * 0.35, ry);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: cb, width: 14, height: 14),
            const Radius.circular(4)),
        Paint()..color = done[i] ? colors[i] : Colors.grey.withOpacity(0.2),
      );
      if (done[i]) {
        final ck = Paint()
          ..color = Colors.white
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(
            Offset(cb.dx - 3.5, cb.dy), Offset(cb.dx - 1, cb.dy + 3), ck);
        canvas.drawLine(
            Offset(cb.dx - 1, cb.dy + 3), Offset(cb.dx + 4.5, cb.dy - 3), ck);
      }
      _blob(
          canvas,
          Offset(cx - size.width * .12, ry),
          size.width * .3,
          5,
          done[i] ? colors[i].withOpacity(0.45) : Colors.grey.withOpacity(0.2),
          3);
    }
    // progress bar
    final py = cy + size.height * 0.44;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - size.width * .36, py, size.width * .72, 5),
            const Radius.circular(3)),
        Paint()..color = Colors.grey.withOpacity(0.15));
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - size.width * .36, py, size.width * .72 * .67, 5),
            const Radius.circular(3)),
        Paint()..color = _C.greenAccent);
  }

  void _blob(
          Canvas canvas, Offset c, double w, double h, Color col, double r) =>
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: c, width: w, height: h),
            Radius.circular(r)),
        Paint()..color = col,
      );

  @override
  bool shouldRepaint(_TrackerPainter _) => false;
}

// ── 3. Leaderboard ────────────────────────────────────────────────────────
class _LeaderboardIllustration extends StatelessWidget {
  final Animation<double> float;
  final _R r;
  const _LeaderboardIllustration({required this.float, required this.r});
  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _LeaderboardPainter(),
        size: Size(r.sw * 0.74, r.sh * 0.30),
      );
}

class _LeaderboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    _trophy(canvas, Offset(cx, cy - size.height * 0.28), size.width * 0.17);

    final bw = size.width * 0.25;
    final baseY = cy + size.height * 0.44;

    _podium(canvas, Offset(cx - bw * 1.05, baseY), bw * 0.9, size.height * 0.28,
        Colors.white.withOpacity(0.68), '২');
    _podium(canvas, Offset(cx, baseY), bw, size.height * 0.44, _C.gold, '১');
    _podium(canvas, Offset(cx + bw * 1.05, baseY), bw * 0.9, size.height * 0.2,
        _C.greenAccent.withOpacity(0.72), '৩');

    _avatar(canvas, Offset(cx - bw * 1.05, baseY - size.height * .28 - 28), 20,
        Colors.white.withOpacity(0.82), _C.textSec);

    canvas.drawCircle(
        Offset(cx, baseY - size.height * .44 - 28),
        30,
        Paint()
          ..color = _C.gold.withOpacity(0.24)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
    _avatar(canvas, Offset(cx, baseY - size.height * .44 - 28), 25, _C.gold,
        _C.darkGreen);

    _avatar(canvas, Offset(cx + bw * 1.05, baseY - size.height * .2 - 26), 19,
        _C.greenAccent, Colors.white);

    // rays
    final rp = Paint()
      ..color = _C.gold.withOpacity(0.35)
      ..strokeWidth = 1.5;
    final oc = Offset(cx, baseY - size.height * .44 - 28);
    for (int i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      canvas.drawLine(
          Offset(oc.dx + 36 * math.cos(a), oc.dy + 36 * math.sin(a)),
          Offset(oc.dx + 48 * math.cos(a), oc.dy + 48 * math.sin(a)),
          rp);
    }
  }

  void _podium(Canvas canvas, Offset base, double w, double h, Color color,
      String rank) {
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(base.dx - w / 2, base.dy - h, w, h),
        topLeft: const Radius.circular(9),
        topRight: const Radius.circular(9),
      ),
      Paint()..color = color,
    );
    final tp = TextPainter(
      text: TextSpan(
          text: rank,
          style: TextStyle(
              color:
                  rank == '১' ? _C.darkGreen : Colors.white.withOpacity(0.85),
              fontSize: 15,
              fontWeight: FontWeight.w800)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(base.dx - tp.width / 2, base.dy - 22));
  }

  void _avatar(Canvas canvas, Offset c, double r, Color bg, Color fg) {
    canvas.drawCircle(
        c, r + 3, Paint()..color = Colors.white.withOpacity(0.16));
    canvas.drawCircle(c, r, Paint()..color = bg);
    canvas.drawCircle(Offset(c.dx, c.dy - r * .27), r * .33,
        Paint()..color = fg.withOpacity(0.85));
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(c.dx, c.dy + r * .45), width: r * 1.1, height: r),
      math.pi,
      math.pi,
      false,
      Paint()
        ..color = fg.withOpacity(0.85)
        ..style = PaintingStyle.fill,
    );
  }

  void _trophy(Canvas canvas, Offset c, double r) {
    final p = Paint()..color = _C.gold;
    canvas.drawPath(
      Path()
        ..moveTo(c.dx - r, c.dy - r * .3)
        ..cubicTo(c.dx - r * 1.2, c.dy + r * .7, c.dx + r * 1.2, c.dy + r * .7,
            c.dx + r, c.dy - r * .3)
        ..lineTo(c.dx + r * .6, c.dy - r)
        ..lineTo(c.dx - r * .6, c.dy - r)
        ..close(),
      p,
    );
    for (final sx in [-1.0, 1.0])
      canvas.drawArc(
        Rect.fromCenter(
            center: Offset(c.dx + sx * r * .98, c.dy - r * .15),
            width: r * .55,
            height: r * .65),
        sx > 0 ? -math.pi / 2 : math.pi / 2,
        math.pi,
        false,
        Paint()
          ..color = _C.gold
          ..style = PaintingStyle.stroke
          ..strokeWidth = r * .13,
      );
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(c.dx, c.dy + r * .9),
            width: r * .22,
            height: r * .45),
        p);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(c.dx, c.dy + r * 1.22),
            width: r * .85,
            height: r * .18),
        const Radius.circular(4),
      ),
      p,
    );
  }

  @override
  bool shouldRepaint(_LeaderboardPainter _) => false;
}

// ── 4. Privacy shield ────────────────────────────────────────────────────
class _PrivacyIllustration extends StatelessWidget {
  final Animation<double> float;
  final _R r;
  const _PrivacyIllustration({required this.float, required this.r});
  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _PrivacyPainter(),
        size: Size(r.sw * 0.68, r.sh * 0.29),
      );
}

class _PrivacyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final sr = size.width * 0.20;

    final shield = Path()
      ..moveTo(cx, cy - sr * 1.2)
      ..cubicTo(cx + sr * 1.2, cy - sr * .8, cx + sr * 1.2, cy + sr * .4, cx,
          cy + sr * 1.2)
      ..cubicTo(cx - sr * 1.2, cy + sr * .4, cx - sr * 1.2, cy - sr * .8, cx,
          cy - sr * 1.2)
      ..close();

    canvas.drawPath(
        shield,
        Paint()
          ..color = _C.greenAccent.withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14));
    canvas.drawPath(shield, Paint()..color = _C.greenMid.withOpacity(0.65));
    canvas.drawPath(
        shield,
        Paint()
          ..color = Colors.white.withOpacity(0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5);

    // lock body
    final lw = sr * .52;
    final lh = sr * .44;
    final lcy = cy + sr * .18;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx, lcy), width: lw, height: lh),
          const Radius.circular(7)),
      Paint()..color = Colors.white.withOpacity(0.9),
    );
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(cx, lcy - lh / 2), width: lw * .6, height: lw * .6),
      math.pi,
      math.pi,
      false,
      Paint()
        ..color = Colors.white.withOpacity(0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(Offset(cx, lcy - 2), 4.5, Paint()..color = _C.greenMid);
    canvas.drawRect(
        Rect.fromCenter(center: Offset(cx, lcy + 6), width: 3.5, height: 8),
        Paint()..color = _C.greenMid);

    // floating feature chips
    final chips = [
      (
        cx - size.width * .36,
        cy - size.height * .28,
        Icons.visibility_off_rounded,
        'আমল লুকাও'
      ),
      (
        cx + size.width * .30,
        cy - size.height * .2,
        Icons.person_off_rounded,
        'নাম গোপন'
      ),
      (
        cx - size.width * .32,
        cy + size.height * .28,
        Icons.share_rounded,
        'নিজে শেয়ার'
      ),
    ];

    for (final (fx, fy, _, label) in chips) {
      // dashed line to shield
      _dash(
          canvas,
          Offset(fx, fy),
          Offset(cx, cy),
          Paint()
            ..color = Colors.white.withOpacity(0.16)
            ..strokeWidth = 1.2);

      // chip
      final cw = size.width * .26;
      final ch = size.height * .22;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(fx, fy), width: cw, height: ch),
            const Radius.circular(11)),
        Paint()..color = Colors.white.withOpacity(0.08),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(fx, fy), width: cw, height: ch),
            const Radius.circular(11)),
        Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
      // gold dot
      canvas.drawCircle(Offset(fx, fy - ch * .2), ch * .12,
          Paint()..color = _C.gold.withOpacity(0.5));
      // label
      final tp = TextPainter(
        text: TextSpan(
            text: label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                height: 1.3)),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: cw - 8);
      tp.paint(canvas, Offset(fx - tp.width / 2, fy + ch * .06));
    }
  }

  void _dash(Canvas canvas, Offset a, Offset b, Paint p) {
    final dx = b.dx - a.dx, dy = b.dy - a.dy;
    final d = math.sqrt(dx * dx + dy * dy);
    final nx = dx / d, ny = dy / d;
    double t = 0;
    while (t < d - 38) {
      canvas.drawLine(
        Offset(a.dx + nx * t, a.dy + ny * t),
        Offset(a.dx + nx * (t + 4.5), a.dy + ny * (t + 4.5)),
        p,
      );
      t += 9;
    }
  }

  @override
  bool shouldRepaint(_PrivacyPainter _) => false;
}
