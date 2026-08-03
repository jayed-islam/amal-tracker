// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:amal_tracker/core/theme/app_color_tokens.dart';

// class OfflineTasbih {
//   final String arabic;
//   final String banglaName;
//   final String meaning;
//   final String virtue;

//   const OfflineTasbih({
//     required this.arabic,
//     required this.banglaName,
//     required this.meaning,
//     required this.virtue,
//   });
// }

// const List<OfflineTasbih> offlineTasbihs = [
//   OfflineTasbih(
//     banglaName: 'সুবহানাল্লাহ',
//     arabic: 'سُبْحَانَ اللَّهِ',
//     meaning: 'আল্লাহ অতি পবিত্র।',
//     virtue: 'মিজানের পাল্লা নেকি দিয়ে পূর্ণ হয়ে যায় এবং এটি জান্নাতের একটি অন্যতম রত্ন।',
//   ),
//   OfflineTasbih(
//     banglaName: 'আলহামদুলিল্লাহ',
//     arabic: 'الْحَمْدُ لِلَّهِ',
//     meaning: 'সমস্ত প্রশংসা আল্লাহর জন্য।',
//     virtue: 'এটি সর্বোত্তম দোয়া এবং আল্লাহর নেয়ামতের কৃতজ্ঞতাস্বরূপ।',
//   ),
//   OfflineTasbih(
//     banglaName: 'আল্লাহু আকবার',
//     arabic: 'اللَّهُ أَكْبَرُ',
//     meaning: 'আল্লাহ মহান।',
//     virtue: 'আকাশ ও পৃথিবীর মধ্যবর্তী সমস্ত স্থান সওয়াব দিয়ে পূর্ণ হয়ে যায়।',
//   ),
//   OfflineTasbih(
//     banglaName: 'আস্তাগফিরুল্লাহ',
//     arabic: 'أَسْتَغْفِرُ اللَّهَ',
//     meaning: 'আমি আল্লাহর নিকট ক্ষমা প্রার্থনা করছি।',
//     virtue: 'সব দুঃখ-কষ্ট থেকে মুক্তির পথ এবং রিজিক বৃদ্ধির অন্যতম কারণ।',
//   ),
//   OfflineTasbih(
//     banglaName: 'সুবহানাল্লাহি ওয়া বিহামদিহি, সুবহানাল্লাহিল আজিম',
//     arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ، سُبْحَانَ اللَّهِ الْعَظِيمِ',
//     meaning: 'মহিমাময় আল্লাহ অতি পবিত্র এবং তাঁরই সব প্রশংসা।',
//     virtue: 'দয়াময় আল্লাহর কাছে দুটি অতি প্রিয় বাক্য, যা উচ্চারণে সহজ কিন্তু মিজানের পাল্লায় অত্যন্ত ভারী।',
//   ),
//   OfflineTasbih(
//     banglaName: 'কালেমা শাহাদাত / তাহলিল',
//     arabic: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
//     meaning: 'আল্লাহ ছাড়া কোনো উপাস্য নেই, তিনি একক এবং তাঁর কোনো শরিক নেই। রাজত্ব ও প্রশংসা একমাত্র তাঁরই এবং তিনি সবকিছুর ওপর ক্ষমতাবান।',
//     virtue: 'দশটি গোলাম আজাদ করার সমান সওয়াব মেলে, একশটি নেকি লেখা হয় এবং শয়তান থেকে সুরক্ষিত থাকা যায়।',
//   ),
// ];

// class OfflineTasbihSheet extends StatefulWidget {
//   const OfflineTasbihSheet({super.key});

//   @override
//   State<OfflineTasbihSheet> createState() => _OfflineTasbihSheetState();
// }

// class _OfflineTasbihSheetState extends State<OfflineTasbihSheet> {
//   int _currentIndex = 0;
//   int _count = 0;
//   bool _scaleTrigger = false;

//   void _increment() {
//     HapticFeedback.lightImpact();
//     setState(() {
//       _count++;
//       _scaleTrigger = !_scaleTrigger;
//     });
//   }

//   void _reset() {
//     HapticFeedback.mediumImpact();
//     setState(() {
//       _count = 0;
//     });
//   }

//   void _next() {
//     HapticFeedback.selectionClick();
//     setState(() {
//       _currentIndex = (_currentIndex + 1) % offlineTasbihs.length;
//       _count = 0;
//     });
//   }

//   void _select(int index) {
//     HapticFeedback.selectionClick();
//     setState(() {
//       _currentIndex = index;
//       _count = 0;
//     });
//   }

//   String _bnNum(int n) {
//     const d = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
//     return n.toString().split('').map((c) => d[int.parse(c)]).join();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = offlineTasbihs[_currentIndex];

//     return Container(
//       decoration: BoxDecoration(
//         color: context.colors.pageBg,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Center(
//             child: Container(
//               width: 40,
//               height: 5,
//               decoration: BoxDecoration(
//                 color: context.colors.border,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'ইন্টারনেট সংযোগ বিচ্ছিন্ন 📡',
//                       style: TextStyle(
//                         color: context.colors.red,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w800,
//                         letterSpacing: -0.3,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       'নেটি নেই তো কী হয়েছে? চলুন সওয়াব অর্জন করি! ✨',
//                       style: TextStyle(
//                         color: context.colors.textSec2,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               IconButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 icon: Icon(Icons.close_rounded, color: context.colors.textHint),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             height: 38,
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               itemCount: offlineTasbihs.length,
//               separatorBuilder: (_, __) => const SizedBox(width: 8),
//               itemBuilder: (_, index) {
//                 final item = offlineTasbihs[index];
//                 final isSelected = index == _currentIndex;
//                 return GestureDetector(
//                   onTap: () => _select(index),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: isSelected ? context.colors.darkGreen : context.colors.card,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: isSelected ? context.colors.darkGreen : context.colors.border,
//                         width: 0.5,
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         item.banglaName.split(' ').first,
//                         style: TextStyle(
//                           color: isSelected ? Colors.white : context.colors.textPri,
//                           fontSize: 12,
//                           fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 16),
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: context.colors.card,
//               borderRadius: BorderRadius.circular(18),
//               border: Border.all(color: context.colors.border, width: 0.5),
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   width: double.infinity,
//                   child: Text(
//                     t.arabic,
//                     textAlign: TextAlign.center,
//                     textDirection: TextDirection.rtl,
//                     style: TextStyle(
//                       color: context.colors.darkGreen,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       height: 1.6,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   t.meaning,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: context.colors.textPri,
//                     fontSize: 12.5,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: context.colors.goldLight2,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: context.colors.goldBorder2, width: 0.5),
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('✨ ', style: TextStyle(fontSize: 13)),
//                       Expanded(
//                         child: Text(
//                           t.virtue,
//                           style: const TextStyle(
//                             color: Color(0xFF854D0E),
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600,
//                             height: 1.45,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _ControlBtn(
//                 icon: Icons.refresh_rounded,
//                 label: 'রিসেট',
//                 onTap: _reset,
//               ),
//               GestureDetector(
//                 onTap: _increment,
//                 child: TweenAnimationBuilder<double>(
//                   key: ValueKey(_scaleTrigger),
//                   tween: Tween(begin: 1.0, end: 1.05),
//                   duration: const Duration(milliseconds: 80),
//                   curve: Curves.easeOut,
//                   builder: (context, scale, child) {
//                     return Transform.scale(
//                       scale: scale,
//                       child: child,
//                     );
//                   },
//                   child: Container(
//                     width: 140,
//                     height: 140,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: context.colors.greenLight,
//                       border: Border.all(
//                         color: context.colors.darkGreen,
//                         width: 5,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: context.colors.darkGreen.withOpacity(0.12),
//                           blurRadius: 20,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             _bnNum(_count),
//                             style: TextStyle(
//                               color: context.colors.darkGreen,
//                               fontSize: 38,
//                               fontWeight: FontWeight.w900,
//                               height: 1.1,
//                             ),
//                           ),
//                           const SizedBox(height: 2),
//                           Text(
//                             'জপ করুন',
//                             style: TextStyle(
//                               color: context.colors.darkGreen.withOpacity(0.7),
//                               fontSize: 10.5,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               _ControlBtn(
//                 icon: Icons.skip_next_rounded,
//                 label: 'পরবর্তী',
//                 onTap: _next,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ControlBtn extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;
//   const _ControlBtn({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Material(
//           color: context.colors.card,
//           shape: const CircleBorder(),
//           borderOnForeground: false,
//           child: InkWell(
//             onTap: onTap,
//             customBorder: const CircleBorder(),
//             child: Container(
//               width: 44,
//               height: 44,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: context.colors.border, width: 0.5),
//               ),
//               child: Icon(icon, color: context.colors.textPri, size: 20),
//             ),
//           ),
//         ),
//         const SizedBox(height: 6),
//         Text(
//           label,
//           style: TextStyle(
//             color: context.colors.textSec2,
//             fontSize: 10.5,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

class OfflineTasbih {
  final String arabic;
  final String banglaName;
  final String meaning;
  final String virtue;

  const OfflineTasbih({
    required this.arabic,
    required this.banglaName,
    required this.meaning,
    required this.virtue,
  });
}

const List<OfflineTasbih> offlineTasbihs = [
  OfflineTasbih(
    banglaName: 'সুবহানাল্লাহ',
    arabic: 'سُبْحَانَ اللَّهِ',
    meaning: 'আল্লাহ অতি পবিত্র।',
    virtue:
        'মিজানের পাল্লা নেকি দিয়ে পূর্ণ হয়ে যায় এবং এটি জান্নাতের একটি অন্যতম রত্ন।',
  ),
  OfflineTasbih(
    banglaName: 'আলহামদুলিল্লাহ',
    arabic: 'الْحَمْدُ لِلَّهِ',
    meaning: 'সমস্ত প্রশংসা আল্লাহর জন্য।',
    virtue: 'এটি সর্বোত্তম দোয়া এবং আল্লাহর নেয়ামতের কৃতজ্ঞতাস্বরূপ।',
  ),
  OfflineTasbih(
    banglaName: 'আল্লাহু আকবার',
    arabic: 'اللَّهُ أَكْبَرُ',
    meaning: 'আল্লাহ মহান।',
    virtue:
        'আকাশ ও পৃথিবীর মধ্যবর্তী সমস্ত স্থান সওয়াব দিয়ে পূর্ণ হয়ে যায়।',
  ),
  OfflineTasbih(
    banglaName: 'আস্তাগফিরুল্লাহ',
    arabic: 'أَسْتَغْفِرُ اللَّهَ',
    meaning: 'আমি আল্লাহর নিকট ক্ষমা প্রার্থনা করছি।',
    virtue: 'সব দুঃখ-কষ্ট থেকে মুক্তির পথ এবং রিজিক বৃদ্ধির অন্যতম কারণ।',
  ),
  OfflineTasbih(
    banglaName: 'সুবহানাল্লাহি ওয়া বিহামদিহি, সুবহানাল্লাহিল আজিম',
    arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ، سُبْحَانَ اللَّهِ الْعَظِيمِ',
    meaning: 'মহিমাময় আল্লাহ অতি পবিত্র এবং তাঁরই সব প্রশংসা।',
    virtue:
        'দয়াময় আল্লাহর কাছে দুটি অতি প্রিয় বাক্য, যা উচ্চারণে সহজ কিন্তু মিজানের পাল্লায় অত্যন্ত ভারী।',
  ),
  OfflineTasbih(
    banglaName: 'কালেমা শাহাদাত / তাহলিল',
    arabic:
        'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
    meaning:
        'আল্লাহ ছাড়া কোনো উপাস্য নেই, তিনি একক এবং তাঁর কোনো শরিক নেই। রাজত্ব ও প্রশংসা একমাত্র তাঁরই এবং তিনি সবকিছুর ওপর ক্ষমতাবান।',
    virtue:
        'দশটি গোলাম আজাদ করার সমান সওয়াব মেলে, একশটি নেকি লেখা হয় এবং শয়তান থেকে সুরক্ষিত থাকা যায়।',
  ),
];

class OfflineTasbihSheet extends StatefulWidget {
  const OfflineTasbihSheet({super.key});

  @override
  State<OfflineTasbihSheet> createState() => _OfflineTasbihSheetState();
}

class _OfflineTasbihSheetState extends State<OfflineTasbihSheet> {
  int _currentIndex = 0;

  // Each tasbih remembers its own count now — switching between them (to
  // compare virtues, or just browse) no longer wipes out progress on the
  // one you were counting.
  final List<int> _counts = List.filled(offlineTasbihs.length, 0);
  bool _scaleTrigger = false;

  int get _count => _counts[_currentIndex];

  // Common dhikr target — most tasbih is done in sets of 33. Used only to
  // drive the progress ring visually; counting past it just keeps going.
  static const int _ringTarget = 33;

  void _increment() {
    HapticFeedback.lightImpact();
    setState(() {
      _counts[_currentIndex]++;
      _scaleTrigger = !_scaleTrigger;
    });
  }

  void _reset() {
    HapticFeedback.mediumImpact();
    setState(() {
      _counts[_currentIndex] = 0;
    });
  }

  void _next() {
    HapticFeedback.selectionClick();
    setState(() {
      _currentIndex = (_currentIndex + 1) % offlineTasbihs.length;
    });
  }

  void _select(int index) {
    if (index == _currentIndex) return;
    HapticFeedback.selectionClick();
    setState(() {
      _currentIndex = index;
    });
  }

  String _bnNum(int n) {
    const d = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return n.toString().split('').map((c) => d[int.parse(c)]).join();
  }

  @override
  Widget build(BuildContext context) {
    final t = offlineTasbihs[_currentIndex];
    final ringProgress =
        _count == 0 ? 0.0 : (_count % _ringTarget) / _ringTarget;
    // When the count lands exactly on a multiple of the target, show a
    // full ring for a beat instead of snapping back to empty.
    final displayRingValue =
        (_count > 0 && _count % _ringTarget == 0) ? 1.0 : ringProgress;
    final roundsCompleted = _count ~/ _ringTarget;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.pageBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
            16, 12, 16, MediaQuery.of(context).padding.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Header — reframed as a warm "offline mode" moment rather
            // than an alarming connection-error banner, and a properly
            // styled close button matching the rest of the sheet's button
            // language (circular, bordered, tactile) instead of a bare
            // unstyled icon.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: context.colors.goldLight2,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: context.colors.goldBorder2, width: 0.5),
                  ),
                  child: Icon(Icons.wifi_off_rounded,
                      color: context.colors.darkGreen, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'অফলাইন জিকির',
                        style: TextStyle(
                          color: context.colors.textPri,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'নেট নেই তো কী হয়েছে? চলুন সওয়াব অর্জন করি! ✨',
                        style: TextStyle(
                          color: context.colors.textSec2,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: context.colors.card,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: context.colors.border, width: 0.5),
                      ),
                      child: Icon(Icons.close_rounded,
                          color: context.colors.textSec2, size: 17),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Tasbih selector — now shows a small count badge on any
            // tasbih that already has progress, since counts persist.
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: offlineTasbihs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, index) {
                  final item = offlineTasbihs[index];
                  final isSelected = index == _currentIndex;
                  final count = _counts[index];
                  return GestureDetector(
                    onTap: () => _select(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? context.colors.darkGreen
                            : context.colors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? context.colors.darkGreen
                              : context.colors.border,
                          width: 0.5,
                        ),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(
                          item.banglaName.split(' ').first,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : context.colors.textPri,
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w800 : FontWeight.w600,
                          ),
                        ),
                        if (count > 0) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withOpacity(0.22)
                                  : context.colors.greenLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _bnNum(count),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : context.colors.darkGreen,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ]),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // ── Content card ─────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colors.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: context.colors.border, width: 0.5),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    width: double.infinity,
                    child: Text(
                      t.arabic,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: context.colors.darkGreen,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.meaning,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.colors.textPri,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.colors.goldLight2,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: context.colors.goldBorder2, width: 0.5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('✨ ', style: TextStyle(fontSize: 13)),
                        Expanded(
                          child: Text(
                            t.virtue,
                            style: const TextStyle(
                              color: Color(0xFF854D0E),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Counter + controls ───────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ControlBtn(
                  icon: Icons.refresh_rounded,
                  label: 'রিসেট',
                  onTap: _reset,
                ),
                GestureDetector(
                  onTap: _increment,
                  child: TweenAnimationBuilder<double>(
                    key: ValueKey(_scaleTrigger),
                    tween: Tween(begin: 1.0, end: 1.05),
                    duration: const Duration(milliseconds: 80),
                    curve: Curves.easeOut,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: child,
                      );
                    },
                    child: SizedBox(
                      width: 140,
                      height: 140,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Progress ring — replaces the old static
                          // decorative border with one that actually
                          // reflects where you are in the current set of
                          // ৩৩, animating smoothly as you tap.
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: displayRingValue),
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOut,
                            builder: (context, value, _) => SizedBox(
                              width: 140,
                              height: 140,
                              child: CircularProgressIndicator(
                                value: value == 0 ? 1 : value,
                                strokeWidth: 5,
                                backgroundColor:
                                    context.colors.border.withOpacity(0.35),
                                valueColor: AlwaysStoppedAnimation(value == 0
                                    ? Colors.transparent
                                    : context.colors.darkGreen),
                              ),
                            ),
                          ),
                          Container(
                            width: 122,
                            height: 122,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.colors.greenLight,
                              boxShadow: [
                                BoxShadow(
                                  color: context.colors.darkGreen
                                      .withOpacity(0.12),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _bnNum(_count),
                                    style: TextStyle(
                                      color: context.colors.darkGreen,
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900,
                                      height: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    roundsCompleted > 0
                                        ? '${_bnNum(roundsCompleted)} রাউন্ড সম্পন্ন'
                                        : 'জপ করুন',
                                    style: TextStyle(
                                      color: context.colors.darkGreen
                                          .withOpacity(0.7),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _ControlBtn(
                  icon: Icons.skip_next_rounded,
                  label: 'পরবর্তী',
                  onTap: _next,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ControlBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: context.colors.card,
          shape: const CircleBorder(),
          borderOnForeground: false,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.colors.border, width: 0.5),
              ),
              child: Icon(icon, color: context.colors.textPri, size: 20),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: context.colors.textSec2,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
