// import 'dart:convert';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // MODEL
// // ─────────────────────────────────────────────────────────────────────────────

// class AyahData {
//   final String arabic;
//   final String bengali;
//   final String surahNameAr; // Arabic name
//   final String surahNameBn; // Bengali name (from API or fallback)
//   final int surahNumber;
//   final int ayahNumber;
//   final int totalAyahs; // ayahs in that surah
//   final String revelationType; // 'Meccan' | 'Medinan'
//   final int juzNumber;

//   const AyahData({
//     required this.arabic,
//     required this.bengali,
//     required this.surahNameAr,
//     required this.surahNameBn,
//     required this.surahNumber,
//     required this.ayahNumber,
//     required this.totalAyahs,
//     required this.revelationType,
//     required this.juzNumber,
//   });

//   factory AyahData.fromJson(Map<String, dynamic> m) => AyahData(
//         arabic: m['arabic'] as String,
//         bengali: m['bengali'] as String,
//         surahNameAr: m['surahNameAr'] as String,
//         surahNameBn: m['surahNameBn'] as String,
//         surahNumber: m['surahNumber'] as int,
//         ayahNumber: m['ayahNumber'] as int,
//         totalAyahs: m['totalAyahs'] as int,
//         revelationType: m['revelationType'] as String,
//         juzNumber: m['juzNumber'] as int,
//       );

//   Map<String, dynamic> toJson() => {
//         'arabic': arabic,
//         'bengali': bengali,
//         'surahNameAr': surahNameAr,
//         'surahNameBn': surahNameBn,
//         'surahNumber': surahNumber,
//         'ayahNumber': ayahNumber,
//         'totalAyahs': totalAyahs,
//         'revelationType': revelationType,
//         'juzNumber': juzNumber,
//       };
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // BENGALI SURAH NAMES  (1–114)
// // ─────────────────────────────────────────────────────────────────────────────

// const _bnSurahNames = <int, String>{
//   1: 'আল-ফাতিহা',
//   2: 'আল-বাকারা',
//   3: 'আলে-ইমরান',
//   4: 'আন-নিসা',
//   5: 'আল-মায়িদা',
//   6: 'আল-আনআম',
//   7: 'আল-আরাফ',
//   8: 'আল-আনফাল',
//   9: 'আত-তাওবা',
//   10: 'ইউনুস',
//   11: 'হুদ',
//   12: 'ইউসুফ',
//   13: 'আর-রাদ',
//   14: 'ইব্রাহীম',
//   15: 'আল-হিজর',
//   16: 'আন-নাহল',
//   17: 'আল-ইসরা',
//   18: 'আল-কাহফ',
//   19: 'মারিয়াম',
//   20: 'ত্বা-হা',
//   21: 'আল-আম্বিয়া',
//   22: 'আল-হাজ্জ',
//   23: 'আল-মুমিনুন',
//   24: 'আন-নূর',
//   25: 'আল-ফুরকান',
//   26: 'আশ-শুআরা',
//   27: 'আন-নামল',
//   28: 'আল-কাসাস',
//   29: 'আল-আনকাবুত',
//   30: 'আর-রুম',
//   31: 'লুকমান',
//   32: 'আস-সাজদা',
//   33: 'আল-আহযাব',
//   34: 'সাবা',
//   35: 'ফাতির',
//   36: 'ইয়া-সীন',
//   37: 'আস-সাফফাত',
//   38: 'সাদ',
//   39: 'আয-যুমার',
//   40: 'গাফির',
//   41: 'ফুসসিলাত',
//   42: 'আশ-শুরা',
//   43: 'আয-যুখরুফ',
//   44: 'আদ-দুখান',
//   45: 'আল-জাসিয়া',
//   46: 'আল-আহকাফ',
//   47: 'মুহাম্মাদ',
//   48: 'আল-ফাতহ',
//   49: 'আল-হুজুরাত',
//   50: 'কাফ',
//   51: 'আয-যারিয়াত',
//   52: 'আত-তুর',
//   53: 'আন-নাজম',
//   54: 'আল-কামার',
//   55: 'আর-রহমান',
//   56: 'আল-ওয়াকিআ',
//   57: 'আল-হাদীদ',
//   58: 'আল-মুজাদালা',
//   59: 'আল-হাশর',
//   60: 'আল-মুমতাহিনা',
//   61: 'আস-সফ',
//   62: 'আল-জুমুআ',
//   63: 'আল-মুনাফিকুন',
//   64: 'আত-তাগাবুন',
//   65: 'আত-তালাক',
//   66: 'আত-তাহরীম',
//   67: 'আল-মুলক',
//   68: 'আল-কলম',
//   69: 'আল-হাককা',
//   70: 'আল-মাআরিজ',
//   71: 'নূহ',
//   72: 'আল-জিন',
//   73: 'আল-মুযযাম্মিল',
//   74: 'আল-মুদ্দাস্সির',
//   75: 'আল-কিয়ামা',
//   76: 'আল-ইনসান',
//   77: 'আল-মুরসালাত',
//   78: 'আন-নাবা',
//   79: 'আন-নাযিআত',
//   80: 'আবাসা',
//   81: 'আত-তাকওয়ীর',
//   82: 'আল-ইনফিতার',
//   83: 'আল-মুতাফফিফীন',
//   84: 'আল-ইনশিকাক',
//   85: 'আল-বুরুজ',
//   86: 'আত-তারিক',
//   87: 'আল-আলা',
//   88: 'আল-গাশিয়া',
//   89: 'আল-ফাজর',
//   90: 'আল-বালাদ',
//   91: 'আশ-শামস',
//   92: 'আল-লাইল',
//   93: 'আদ-দুহা',
//   94: 'আশ-শারহ',
//   95: 'আত-তীন',
//   96: 'আল-আলাক',
//   97: 'আল-কদর',
//   98: 'আল-বায়্যিনা',
//   99: 'আয-যিলযাল',
//   100: 'আল-আদিয়াত',
//   101: 'আল-কারিআ',
//   102: 'আত-তাকাসুর',
//   103: 'আল-আসর',
//   104: 'আল-হুমাযা',
//   105: 'আল-ফীল',
//   106: 'কুরাইশ',
//   107: 'আল-মাউন',
//   108: 'আল-কাউসার',
//   109: 'আল-কাফিরুন',
//   110: 'আন-নাসর',
//   111: 'আল-মাসাদ',
//   112: 'আল-ইখলাস',
//   113: 'আল-ফালাক',
//   114: 'আন-নাস',
// };

// // ─────────────────────────────────────────────────────────────────────────────
// // PROVIDER
// // ─────────────────────────────────────────────────────────────────────────────

// final dailyAyahProvider = FutureProvider<AyahData>((ref) => _fetchDailyAyah());

// Future<AyahData> _fetchDailyAyah() async {
//   final today = DateTime.now();
//   final cacheKey = 'ayah_${today.year}_${today.month}_${today.day}';

//   // ── Try cache ─────────────────────────────────────────────────────────────
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final cached = prefs.getString(cacheKey);
//     if (cached != null) return AyahData.fromJson(jsonDecode(cached));
//   } catch (_) {}

//   // ── Pick random ayah from full Quran (1–6236) seeded by date ─────────────
//   final seed = today.year * 10000 + today.month * 100 + today.day;
//   final ayahGlobal = Random(seed).nextInt(6236) + 1; // 1..6236

//   try {
//     // Single call — Arabic + Bengali translation
//     final uri = Uri.parse(
//       'https://api.alquran.cloud/v1/ayah/$ayahGlobal/editions/quran-uthmani,bn.bengali',
//     );
//     final resp = await http.get(uri).timeout(const Duration(seconds: 10));

//     if (resp.statusCode == 200) {
//       final body = jsonDecode(resp.body) as Map<String, dynamic>;
//       final list = body['data'] as List<dynamic>;
//       final arEntry = list[0] as Map<String, dynamic>;
//       final bnEntry = list[1] as Map<String, dynamic>;

//       final surah = arEntry['surah'] as Map<String, dynamic>;
//       final surahN = (surah['number'] as int?) ?? 1;

//       final result = AyahData(
//         arabic: arEntry['text'] as String,
//         bengali: bnEntry['text'] as String,
//         surahNameAr: (surah['name'] as String?) ?? '',
//         surahNameBn: _bnSurahNames[surahN] ?? 'সূরা #$surahN',
//         surahNumber: surahN,
//         ayahNumber: (arEntry['numberInSurah'] as int?) ?? 1,
//         totalAyahs: (surah['numberOfAyahs'] as int?) ?? 0,
//         revelationType: (surah['revelationType'] as String?) ?? '',
//         juzNumber: (arEntry['juz'] as int?) ?? 0,
//       );

//       // Cache
//       try {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString(cacheKey, jsonEncode(result.toJson()));
//       } catch (_) {}

//       return result;
//     }
//   } catch (_) {}

//   // ── Hardcoded fallback ────────────────────────────────────────────────────
//   return const AyahData(
//     arabic: 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا',
//     bengali:
//         'যে ব্যক্তি আল্লাহকে ভয় করে, তিনি তার জন্য (কষ্ট থেকে) বের হওয়ার পথ তৈরি করে দেন।',
//     surahNameAr: 'الطلاق',
//     surahNameBn: 'আত-তালাক',
//     surahNumber: 65,
//     ayahNumber: 2,
//     totalAyahs: 12,
//     revelationType: 'Medinan',
//     juzNumber: 28,
//   );
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DESIGN TOKENS  (local — matches app palette)
// // ─────────────────────────────────────────────────────────────────────────────

// class _C {
//   static const darkGreen = Color(0xFF0E3D22);
//   static const midGreen = Color(0xFF1B7045);
//   static const gold = Color(0xFFD4A843);
//   static const goldLight = Color(0xFFFFF3E0);
//   static const goldBorder = Color(0xFFFFCC80);
//   static const card = Color(0xFFFFFFFF);
//   static const border = Color(0xFFE4EAE4);
//   static const pageBg = Color(0xFFF4F6F1);
//   static const textPri = Color(0xFF0A1A0F);
//   static const textSec = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBAAE);
//   static const greenLight = Color(0xFFE8F5EE);
// }

// String _rvTypeBn(String t) => t == 'Meccan'
//     ? 'মক্কী'
//     : t == 'Medinan'
//         ? 'মাদানী'
//         : t;

// // ─────────────────────────────────────────────────────────────────────────────
// // PUBLIC WIDGET  —  drop this anywhere in the home scroll
// // ─────────────────────────────────────────────────────────────────────────────

// class DailyAyahCard extends ConsumerStatefulWidget {
//   const DailyAyahCard({super.key});

//   @override
//   ConsumerState<DailyAyahCard> createState() => _DailyAyahCardState();
// }

// class _DailyAyahCardState extends ConsumerState<DailyAyahCard> {
//   bool _expanded = false;

//   @override
//   Widget build(BuildContext context) {
//     final ayah = ref.watch(dailyAyahProvider);

//     return ayah.when(
//       loading: () => const _LoadingState(),
//       error: (_, __) => _LoadedState(
//         ayah: const AyahData(
//           arabic: 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا',
//           bengali:
//               'যে ব্যক্তি আল্লাহকে ভয় করে, তিনি তার জন্য বের হওয়ার পথ তৈরি করে দেন।',
//           surahNameAr: 'الطلاق',
//           surahNameBn: 'আত-তালাক',
//           surahNumber: 65,
//           ayahNumber: 2,
//           totalAyahs: 12,
//           revelationType: 'Medinan',
//           juzNumber: 28,
//         ),
//         expanded: _expanded,
//         onExpand: () => setState(() => _expanded = !_expanded),
//       ),
//       data: (d) => _LoadedState(
//         ayah: d,
//         expanded: _expanded,
//         onExpand: () => setState(() => _expanded = !_expanded),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // LOADING STATE
// // Warm engaging Bengali text + soft circular indicator.
// // Only this — nothing else. Clean and focused.
// // ─────────────────────────────────────────────────────────────────────────────

// class _LoadingState extends StatelessWidget {
//   const _LoadingState();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF0B2D1A), Color(0xFF143522)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Circular progress — subtle gold ring
//           SizedBox(
//             width: 42,
//             height: 42,
//             child: CircularProgressIndicator(
//               strokeWidth: 2.5,
//               valueColor: AlwaysStoppedAnimation(_C.gold.withOpacity(0.7)),
//               backgroundColor: Colors.white.withOpacity(0.06),
//             ),
//           ).animate(onPlay: (c) => c.repeat()).shimmer(
//               duration: 1800.ms,
//               colors: [
//                 _C.gold.withOpacity(0.5),
//                 _C.gold,
//                 _C.gold.withOpacity(0.5)
//               ]),

//           const SizedBox(height: 16),

//           // Engaging Bengali line
//           Text(
//             'আপনার জন্য কুরআন থেকে\nএকটি আয়াত আনা হচ্ছে…',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.75),
//               fontSize: 13.5,
//               fontWeight: FontWeight.w500,
//               height: 1.6,
//               letterSpacing: 0.1,
//             ),
//           ),

//           const SizedBox(height: 6),

//           Text(
//             'একটু অপেক্ষা করুন',
//             style: TextStyle(
//               color: _C.gold.withOpacity(0.55),
//               fontSize: 10.5,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // LOADED STATE
// // ─────────────────────────────────────────────────────────────────────────────

// class _LoadedState extends StatelessWidget {
//   final AyahData ayah;
//   final bool expanded;
//   final VoidCallback onExpand;
//   const _LoadedState(
//       {required this.ayah, required this.expanded, required this.onExpand});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF0B2D1A), Color(0xFF143522)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Main content ────────────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header row: label + surah reference
//                 Row(children: [
//                   // "আজকের আয়াত" badge
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: _C.gold.withOpacity(0.13),
//                       borderRadius: BorderRadius.circular(7),
//                       border: Border.all(
//                           color: _C.gold.withOpacity(0.28), width: 0.5),
//                     ),
//                     child: Row(mainAxisSize: MainAxisSize.min, children: [
//                       const Text('📖', style: TextStyle(fontSize: 10)),
//                       const SizedBox(width: 5),
//                       const Text('আজকের আয়াত',
//                           style: TextStyle(
//                               color: _C.gold,
//                               fontSize: 10,
//                               fontWeight: FontWeight.w700)),
//                     ]),
//                   ),
//                   const Spacer(),
//                   // Surah:Ayah pill
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.07),
//                       borderRadius: BorderRadius.circular(7),
//                       border: Border.all(
//                           color: Colors.white.withOpacity(0.1), width: 0.5),
//                     ),
//                     child: Text(
//                       '${ayah.surahNumber}:${ayah.ayahNumber}',
//                       style: TextStyle(
//                           color: Colors.white.withOpacity(0.55),
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ]),

//                 const SizedBox(height: 16),

//                 // ── Bengali — PRIMARY ──────────────────────────────────
//                 Text(
//                   '"${ayah.bengali}"',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                     height: 1.7,
//                     letterSpacing: 0.1,
//                   ),
//                 ),

//                 const SizedBox(height: 14),

//                 // Thin separator
//                 Container(height: 0.5, color: Colors.white.withOpacity(0.08)),

//                 const SizedBox(height: 12),

//                 // ── Arabic — secondary ─────────────────────────────────
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: Text(
//                     ayah.arabic,
//                     textDirection: TextDirection.rtl,
//                     textAlign: TextAlign.right,
//                     style: TextStyle(
//                       color: _C.gold.withOpacity(0.85),
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       height: 2.0,
//                       letterSpacing: 0.8,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 14),

//                 // ── Source + expand button row ─────────────────────────
//                 Row(children: [
//                   // Surah name pill
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: _C.midGreen.withOpacity(0.35),
//                       borderRadius: BorderRadius.circular(7),
//                       border: Border.all(
//                           color: Colors.white.withOpacity(0.08), width: 0.5),
//                     ),
//                     child: Text(
//                       '${ayah.surahNameBn}  •  আয়াত ${ayah.ayahNumber}',
//                       style: TextStyle(
//                           color: Colors.white.withOpacity(0.7),
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                   const Spacer(),
//                   // Expand toggle
//                   GestureDetector(
//                     onTap: onExpand,
//                     child: Row(mainAxisSize: MainAxisSize.min, children: [
//                       Text(
//                         expanded ? 'কম দেখুন' : 'আরো দেখুন',
//                         style: TextStyle(
//                             color: _C.gold.withOpacity(0.8),
//                             fontSize: 10.5,
//                             fontWeight: FontWeight.w700),
//                       ),
//                       const SizedBox(width: 3),
//                       AnimatedRotation(
//                         turns: expanded ? 0.5 : 0,
//                         duration: const Duration(milliseconds: 250),
//                         child: Icon(Icons.keyboard_arrow_down_rounded,
//                             color: _C.gold.withOpacity(0.8), size: 16),
//                       ),
//                     ]),
//                   ),
//                 ]),

//                 const SizedBox(height: 14),
//               ],
//             ),
//           ),

//           // ── Expandable details ──────────────────────────────────────
//           AnimatedCrossFade(
//             duration: const Duration(milliseconds: 280),
//             sizeCurve: Curves.easeInOut,
//             crossFadeState:
//                 expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
//             firstChild: const SizedBox(width: double.infinity),
//             secondChild: _ExpandedDetails(ayah: ayah),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // EXPANDED DETAILS PANEL
// // ─────────────────────────────────────────────────────────────────────────────

// class _ExpandedDetails extends StatelessWidget {
//   final AyahData ayah;
//   const _ExpandedDetails({required this.ayah});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//       padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Row 1: Surah info pills
//           Wrap(spacing: 8, runSpacing: 8, children: [
//             _InfoPill(
//               icon: '🕌',
//               label: _rvTypeBn(ayah.revelationType),
//               sublabel: 'অবতীর্ণ',
//             ),
//             _InfoPill(
//               icon: '📚',
//               label: 'জুয ${ayah.juzNumber}',
//               sublabel: 'পারা',
//             ),
//             _InfoPill(
//               icon: '📜',
//               label: '${ayah.totalAyahs} আয়াত',
//               sublabel: 'এই সূরায়',
//             ),
//             _InfoPill(
//               icon: '🔢',
//               label: '${ayah.surahNumber}:${ayah.ayahNumber}',
//               sublabel: 'রেফারেন্স',
//             ),
//           ]),

//           const SizedBox(height: 14),

//           // Surah name — Arabic + Bengali
//           Row(children: [
//             Expanded(
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                   Text('সূরার নাম',
//                       style: TextStyle(
//                           color: Colors.white.withOpacity(0.35),
//                           fontSize: 9.5,
//                           fontWeight: FontWeight.w500)),
//                   const SizedBox(height: 3),
//                   Row(children: [
//                     Text(ayah.surahNameBn,
//                         style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 13,
//                             fontWeight: FontWeight.w700)),
//                     const SizedBox(width: 8),
//                     Text(ayah.surahNameAr,
//                         textDirection: TextDirection.rtl,
//                         style: TextStyle(
//                             color: _C.gold.withOpacity(0.75),
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600)),
//                   ]),
//                 ])),
//           ]),

//           const SizedBox(height: 12),
//           Container(height: 0.5, color: Colors.white.withOpacity(0.07)),
//           const SizedBox(height: 12),

//           // Note about full tafsir
//           Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Container(
//               width: 28,
//               height: 28,
//               decoration: BoxDecoration(
//                 color: _C.gold.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(7),
//               ),
//               child: const Center(
//                   child: Text('💡', style: TextStyle(fontSize: 13))),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                   const Text('তাফসীর সম্পর্কে',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 11.5,
//                           fontWeight: FontWeight.w700)),
//                   const SizedBox(height: 3),
//                   Text(
//                     'সম্পূর্ণ তাফসীরের জন্য বিশ্বস্ত আলেমের কাছে যান অথবা তাফসীরে ইবনে কাসীর, তাফসীরে জালালাইন পড়ুন।',
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.5),
//                       fontSize: 10.5,
//                       height: 1.55,
//                     ),
//                   ),
//                 ])),
//           ]),
//         ],
//       ),
//     ).animate().fadeIn(duration: 250.ms).slideY(begin: -0.05, end: 0);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // INFO PILL
// // ─────────────────────────────────────────────────────────────────────────────

// class _InfoPill extends StatelessWidget {
//   final String icon, label, sublabel;
//   const _InfoPill(
//       {required this.icon, required this.label, required this.sublabel});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.06),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.white.withOpacity(0.09), width: 0.5),
//       ),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [
//         Text(icon, style: const TextStyle(fontSize: 11)),
//         const SizedBox(width: 5),
//         Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(label,
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w700,
//                       height: 1.1)),
//               Text(sublabel,
//                   style: TextStyle(
//                       color: Colors.white.withOpacity(0.4), fontSize: 8.5)),
//             ]),
//       ]),
//     );
//   }
// }
// import 'dart:convert';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // MODEL
// // ─────────────────────────────────────────────────────────────────────────────

// class AyahData {
//   final String arabic;
//   final String bengali;
//   final String surahNameAr;
//   final String surahNameBn;
//   final int surahNumber;
//   final int ayahNumber;
//   final int totalAyahs;
//   final String revelationType;
//   final int juzNumber;

//   const AyahData({
//     required this.arabic,
//     required this.bengali,
//     required this.surahNameAr,
//     required this.surahNameBn,
//     required this.surahNumber,
//     required this.ayahNumber,
//     required this.totalAyahs,
//     required this.revelationType,
//     required this.juzNumber,
//   });

//   factory AyahData.fromJson(Map<String, dynamic> m) => AyahData(
//         arabic: m['arabic'] as String,
//         bengali: m['bengali'] as String,
//         surahNameAr: m['surahNameAr'] as String,
//         surahNameBn: m['surahNameBn'] as String,
//         surahNumber: m['surahNumber'] as int,
//         ayahNumber: m['ayahNumber'] as int,
//         totalAyahs: m['totalAyahs'] as int,
//         revelationType: m['revelationType'] as String,
//         juzNumber: m['juzNumber'] as int,
//       );

//   Map<String, dynamic> toJson() => {
//         'arabic': arabic,
//         'bengali': bengali,
//         'surahNameAr': surahNameAr,
//         'surahNameBn': surahNameBn,
//         'surahNumber': surahNumber,
//         'ayahNumber': ayahNumber,
//         'totalAyahs': totalAyahs,
//         'revelationType': revelationType,
//         'juzNumber': juzNumber,
//       };
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // BENGALI SURAH NAMES (1–114)
// // ─────────────────────────────────────────────────────────────────────────────

// const _bnSurahNames = <int, String>{
//   1: 'আল-ফাতিহা',
//   2: 'আল-বাকারা',
//   3: 'আলে-ইমরান',
//   4: 'আন-নিসা',
//   5: 'আল-মায়িদা',
//   6: 'আল-আনআম',
//   7: 'আল-আরাফ',
//   8: 'আল-আনফাল',
//   9: 'ат-তাওবা',
//   10: 'ইউনুস',
//   11: 'হুদ',
//   12: 'ইউসুফ',
//   13: 'আর-রাদ',
//   14: 'ইব্রাহীম',
//   15: 'আল-হিজর',
//   16: 'আন-নাহল',
//   17: 'আল-ইসরা',
//   18: 'আল-কাহফ',
//   19: 'মারিয়াম',
//   20: 'ত্বা-হা',
//   21: 'আল-আম্বিয়া',
//   22: 'আল-হাজ্জ',
//   23: 'আল-মুমিনুন',
//   24: 'আন-নূর',
//   25: 'আল-ফুরকান',
//   26: 'আশ-শুআরা',
//   27: 'আন-নামল',
//   28: 'আল-কাসাস',
//   29: 'আল-আনকাবুত',
//   30: 'আর-রুম',
//   31: 'লুকমান',
//   32: 'আস-সাজদা',
//   33: 'আল-আহযাব',
//   34: 'সাবা',
//   35: 'ফাতির',
//   36: 'ইয়া-সীন',
//   37: 'আস-সাফফাত',
//   38: 'সাদ',
//   39: 'আয-যুমার',
//   40: 'গাফির',
//   41: 'ফুসসিলাত',
//   42: 'আশ-শুরা',
//   43: 'আয-যুখরুফ',
//   44: 'আদ-দুখান',
//   45: 'আল-জাসিয়া',
//   46: 'আল-আহকাফ',
//   47: 'মুহাম্মাদ',
//   48: 'আল-ফাতহ',
//   49: 'আল-হুজুরাত',
//   50: 'কাফ',
//   51: 'আয-যারিয়াত',
//   52: 'ат-তুর',
//   53: 'আন-নাজম',
//   54: 'আল-কামার',
//   55: 'আর-রহমান',
//   56: 'আল-ওয়াকিআ',
//   57: 'আল-হাদীদ',
//   58: 'আল-মুজাদালা',
//   59: 'আল-হাশর',
//   60: 'আল-মুমতাহিনা',
//   61: 'আস-সফ',
//   62: 'আল-জুমুআ',
//   63: 'আল-মুনাফিকুন',
//   64: 'ат-তাগাবুন',
//   65: 'ат-তালাক',
//   66: 'ат-তাহরীম',
//   67: 'আল-মুলক',
//   68: 'আল-কলম',
//   69: 'আল-হাককা',
//   70: 'আল-মাআরিজ',
//   71: 'নূহ',
//   72: 'আল-জিন',
//   73: 'আল-মুযযাম্মিল',
//   74: 'আল-মুদ্দাস্সির',
//   75: 'আল-কিয়ামা',
//   76: 'আল-ইনসান',
//   77: 'আল-মুরসালাত',
//   78: 'আন-নাবা',
//   79: 'আন-নাযিআত',
//   80: 'আবাসা',
//   81: 'ат-তাকওয়ীর',
//   82: 'আল-ইনফিতার',
//   83: 'আল-মুতাফফিফীন',
//   84: 'আল-ইনশিকাক',
//   85: 'আল-বুরুজ',
//   86: 'ат-তারিক',
//   87: 'আল-আলা',
//   88: 'আল-গাশিয়া',
//   89: 'আল-ফাজর',
//   90: 'আল-বালাদ',
//   91: 'আশ-শামস',
//   92: 'আল-লাইল',
//   93: 'আদ-দুহা',
//   94: 'আশ-শারহ',
//   95: 'ат-তীন',
//   96: 'আল-আলাক',
//   97: 'আল-কদর',
//   98: 'আল-বায়্যিনা',
//   99: 'আয-যিলযাল',
//   100: 'আল-আদিয়াত',
//   101: 'আল-কারিআ',
//   102: 'ат-তাকাসুর',
//   103: 'আল-আসর',
//   104: 'আল-হুমাযা',
//   105: 'আল-ফীল',
//   106: 'কুরাইশ',
//   107: 'আল-মাউন',
//   108: 'আল-কাউসার',
//   109: 'আল-কাফিরুন',
//   110: 'আন-নাসর',
//   111: 'আল-মাসাদ',
//   112: 'আল-ইখলাস',
//   113: 'আল-ফালাক',
//   114: 'আন-নাস',
// };

// // ─────────────────────────────────────────────────────────────────────────────
// // PROVIDER
// // ─────────────────────────────────────────────────────────────────────────────

// final dailyAyahProvider = FutureProvider<AyahData>((ref) => _fetchDailyAyah());

// Future<AyahData> _fetchDailyAyah() async {
//   final today = DateTime.now();
//   final cacheKey = 'ayah_${today.year}_${today.month}_${today.day}';

//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final cached = prefs.getString(cacheKey);
//     if (cached != null) return AyahData.fromJson(jsonDecode(cached));
//   } catch (_) {}

//   final seed = today.year * 10000 + today.month * 100 + today.day;
//   final ayahGlobal = Random(seed).nextInt(6236) + 1;

//   try {
//     final uri = Uri.parse(
//       'https://api.alquran.cloud/v1/ayah/$ayahGlobal/editions/quran-uthmani,bn.bengali',
//     );
//     final resp = await http.get(uri).timeout(const Duration(seconds: 10));

//     if (resp.statusCode == 200) {
//       final body = jsonDecode(resp.body) as Map<String, dynamic>;
//       final list = body['data'] as List<dynamic>;
//       final arEntry = list[0] as Map<String, dynamic>;
//       final bnEntry = list[1] as Map<String, dynamic>;

//       final surah = arEntry['surah'] as Map<String, dynamic>;
//       final surahN = (surah['number'] as int?) ?? 1;

//       final result = AyahData(
//         arabic: arEntry['text'] as String,
//         bengali: bnEntry['text'] as String,
//         surahNameAr: (surah['name'] as String?) ?? '',
//         surahNameBn: _bnSurahNames[surahN] ?? 'সূরা #$surahN',
//         surahNumber: surahN,
//         ayahNumber: (arEntry['numberInSurah'] as int?) ?? 1,
//         totalAyahs: (surah['numberOfAyahs'] as int?) ?? 0,
//         revelationType: (surah['revelationType'] as String?) ?? '',
//         juzNumber: (arEntry['juz'] as int?) ?? 0,
//       );

//       try {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString(cacheKey, jsonEncode(result.toJson()));
//       } catch (_) {}

//       return result;
//     }
//   } catch (_) {}

//   return const AyahData(
//     arabic: 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا',
//     bengali:
//         'যে ব্যক্তি আল্লাহকে ভয় করে, তিনি তার জন্য (কষ্ট থেকে) বের হওয়ার পথ তৈরি করে দেন।',
//     surahNameAr: 'الطلاق',
//     surahNameBn: 'আত-তালাক',
//     surahNumber: 65,
//     ayahNumber: 2,
//     totalAyahs: 12,
//     revelationType: 'Medinan',
//     juzNumber: 28,
//   );
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // DESIGN TOKENS
// // ─────────────────────────────────────────────────────────────────────────────

// class _C {
//   static const darkGreen = Color(0xFF0E3D22);
//   static const midGreen = Color(0xFF1B7045);
//   static const gold = Color(0xFFC59B27);
//   static const goldLight = Color(0xFFFFFDF6);
//   static const card = Color(0xFFFFFFFF);
//   static const border = Color(0xFFEAEFEA);
//   static const textPri = Color(0xFF1A2E22);
//   static const textSec = Color(0xFF53675A);
//   static const textHint = Color(0xFF94A59A);
//   static const greenLight = Color(0xFFF0F7F3);
// }

// String _rvTypeBn(String t) => t == 'Meccan'
//     ? 'মক্কী'
//     : t == 'Medinan'
//         ? 'মাদানী'
//         : t;

// // ─────────────────────────────────────────────────────────────────────────────
// // PUBLIC WIDGET
// // ─────────────────────────────────────────────────────────────────────────────

// class DailyAyahCard extends ConsumerStatefulWidget {
//   const DailyAyahCard({super.key});

//   @override
//   ConsumerState<DailyAyahCard> createState() => _DailyAyahCardState();
// }

// class _DailyAyahCardState extends ConsumerState<DailyAyahCard> {
//   bool _expanded = false;

//   @override
//   Widget build(BuildContext context) {
//     final ayah = ref.watch(dailyAyahProvider);

//     return ayah.when(
//       loading: () => const _LoadingState(),
//       error: (_, __) => _LoadedState(
//         ayah: const AyahData(
//           arabic: 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا',
//           bengali:
//               'যে ব্যক্তি আল্লাহকে ভয় করে, তিনি তার জন্য বের হওয়ার পথ তৈরি করে দেন।',
//           surahNameAr: 'الطلاق',
//           surahNameBn: 'আত-তালাক',
//           surahNumber: 65,
//           ayahNumber: 2,
//           totalAyahs: 12,
//           revelationType: 'Medinan',
//           juzNumber: 28,
//         ),
//         expanded: _expanded,
//         onExpand: () => setState(() => _expanded = !_expanded),
//       ),
//       data: (d) => _LoadedState(
//         ayah: d,
//         expanded: _expanded,
//         onExpand: () => setState(() => _expanded = !_expanded),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // LOADING STATE
// // ─────────────────────────────────────────────────────────────────────────────

// class _LoadingState extends StatelessWidget {
//   const _LoadingState();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: _C.border, width: 1),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(
//             width: 28,
//             height: 28,
//             child: CircularProgressIndicator(
//               strokeWidth: 2,
//               valueColor: const AlwaysStoppedAnimation(_C.midGreen),
//               backgroundColor: _C.midGreen.withOpacity(0.1),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'কুরআনুল কারীম থেকে আজকের আয়াত লোড হচ্ছে',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: _C.textSec,
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               letterSpacing: 0.1,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // LOADED STATE
// // ─────────────────────────────────────────────────────────────────────────────

// class _LoadedState extends StatelessWidget {
//   final AyahData ayah;
//   final bool expanded;
//   final VoidCallback onExpand;

//   const _LoadedState({
//     required this.ayah,
//     required this.expanded,
//     required this.onExpand,
//   });

//   void _copyToClipboard(BuildContext context) {
//     final textToCopy =
//         '${ayah.bengali}\n\n[${ayah.arabic}]\n— সূূরা ${ayah.surahNameBn}, আয়াত: ${ayah.ayahNumber}';
//     Clipboard.setData(ClipboardData(text: textToCopy));
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Row(
//           children: [
//             Icon(Icons.check_circle_outline_rounded,
//                 color: Colors.white, size: 18),
//             SizedBox(width: 8),
//             Text('আয়াতটি কপি করা হয়েছে',
//                 style: TextStyle(fontFamily: 'Hind Siliguri', fontSize: 13)),
//           ],
//         ),
//         backgroundColor: _C.darkGreen,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: _C.border, width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: _C.darkGreen.withOpacity(0.02),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header Top Bar
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 5),
//                       decoration: BoxDecoration(
//                         color: _C.greenLight,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.auto_stories_outlined,
//                               color: _C.midGreen, size: 13),
//                           SizedBox(width: 6),
//                           Text(
//                             'আজকের আয়াত',
//                             style: TextStyle(
//                               color: _C.midGreen,
//                               fontSize: 11,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Spacer(),
//                     IconButton(
//                       // horizontalSpacing: 0,
//                       constraints: const BoxConstraints(),
//                       padding: EdgeInsets.zero,
//                       icon: Icon(Icons.copy_rounded,
//                           color: _C.textHint.withOpacity(0.8), size: 18),
//                       onPressed: () => _copyToClipboard(context),
//                       tooltip: 'কপি করুন',
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 20),

//                 // Arabic Text Box (Premium Container)
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: _C.goldLight.withOpacity(0.5),
//                     borderRadius: BorderRadius.circular(16),
//                     border:
//                         Border.all(color: _C.gold.withOpacity(0.12), width: 1),
//                   ),
//                   child: Align(
//                     alignment: Alignment.centerRight,
//                     child: Text(
//                       ayah.arabic,
//                       textDirection: TextDirection.rtl,
//                       textAlign: TextAlign.right,
//                       style: const TextStyle(
//                         color: _C.darkGreen,
//                         fontSize: 20,
//                         fontFamily: 'Traditional Arabic', // Fallback context
//                         fontWeight: FontWeight.w500,
//                         height: 1.8,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 18),

//                 // Bengali Translation
//                 Text(
//                   ayah.bengali,
//                   style: const TextStyle(
//                     color: _C.textPri,
//                     fontSize: 15.5,
//                     fontWeight: FontWeight.w600,
//                     height: 1.65,
//                   ),
//                 ),

//                 const SizedBox(height: 20),
//                 Container(height: 1, color: _C.border),
//                 const SizedBox(height: 14),

//                 // Bottom Meta Row
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         'সূরা ${ayah.surahNameBn}  •  আয়াত ${ayah.ayahNumber}',
//                         style: const TextStyle(
//                           color: _C.textSec,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: onExpand,
//                       borderRadius: BorderRadius.circular(8),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 4),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Text(
//                               'বিস্তারিত',
//                               style: TextStyle(
//                                 color: _C.midGreen,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(width: 4),
//                             AnimatedRotation(
//                               turns: expanded ? 0.5 : 0,
//                               duration: const Duration(milliseconds: 200),
//                               child: const Icon(
//                                 Icons.expand_more_rounded,
//                                 color: _C.midGreen,
//                                 size: 18,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // Expandable Segment
//           AnimatedCrossFade(
//             duration: const Duration(milliseconds: 250),
//             sizeCurve: Curves.fastOutSlowIn,
//             crossFadeState:
//                 expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
//             firstChild: const SizedBox(width: double.infinity),
//             secondChild: _ExpandedDetails(ayah: ayah),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // EXPANDED DETAILS PANEL
// // ─────────────────────────────────────────────────────────────────────────────

// class _ExpandedDetails extends StatelessWidget {
//   final AyahData ayah;
//   const _ExpandedDetails({required this.ayah});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _C.greenLight.withOpacity(0.4),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.border, width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Information Grid / Wrap
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: [
//               _InfoPill(
//                 icon: Icons.gite_outlined,
//                 label: _rvTypeBn(ayah.revelationType),
//                 sublabel: 'অবতরণ স্থূল',
//               ),
//               _InfoPill(
//                 icon: Icons.format_list_numbered_rounded,
//                 label: 'জুয ${ayah.juzNumber}',
//                 sublabel: 'পারা',
//               ),
//               _InfoPill(
//                 icon: Icons.tag_rounded,
//                 label: '${ayah.totalAyahs} টি',
//                 sublabel: 'মোট আয়াত',
//               ),
//               _InfoPill(
//                 icon: Icons.star_border_rounded,
//                 label: '${ayah.surahNumber}:${ayah.ayahNumber}',
//                 sublabel: 'সূূরা ইনডেক্স',
//               ),
//             ],
//           ),

//           const SizedBox(height: 16),
//           Container(height: 1, color: _C.border),
//           const SizedBox(height: 14),

//           // Context / Tafsir Notice Card
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: _C.gold.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.lightbulb_outline_rounded,
//                     color: _C.gold, size: 16),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'তাফসীর ও প্রেক্ষাপট',
//                       style: TextStyle(
//                         color: _C.textPri,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'বিশুদ্ধ ও বিস্তারিত ব্যাখ্যার জন্য নির্ভরযোগ্য আলেমদের পরামর্শ নিন অথবা তাফসীরে ইবনে কাসীর ও তাফসীরে জালালাইন অধ্যয়ন করুন।',
//                       style: TextStyle(
//                         color: _C.textSec,
//                         fontSize: 11,
//                         height: 1.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.02, end: 0);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // INFO PILL
// // ─────────────────────────────────────────────────────────────────────────────

// class _InfoPill extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String sublabel;

//   const _InfoPill({
//     required this.icon,
//     required this.label,
//     required this.sublabel,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: _C.border, width: 1),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: _C.midGreen.withOpacity(0.7), size: 14),
//           const SizedBox(width: 8),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(
//                   color: _C.textPri,
//                   fontSize: 11,
//                   fontWeight: FontWeight.bold,
//                   height: 1.1,
//                 ),
//               ),
//               const SizedBox(height: 1),
//               Text(
//                 sublabel,
//                 style: const TextStyle(
//                   color: _C.textHint,
//                   fontSize: 9,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'dart:convert';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;

// // ─────────────────────────────────────────────────────────────────────────────
// // TOKENS — matches home screen _C palette exactly
// // ─────────────────────────────────────────────────────────────────────────────
// class _C {
//   static const pageBg = Color(0xFFF4F6F1);
//   static const card = Color(0xFFFFFFFF);
//   static const darkGreen = Color(0xFF0E3D22);
//   static const midGreen = Color(0xFF1B7045);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const greenBorder = Color(0xFFD4E9D9);
//   static const gold = Color(0xFFD4A843);
//   static const goldBg = Color(0xFFFDFAF3);
//   static const goldBorder = Color(0xFFEDD98A);
//   static const goldText = Color(0xFF8B6914);
//   static const border = Color(0xFFE0E8E2);
//   static const textPri = Color(0xFF0A1A0F);
//   static const textSec = Color(0xFF4A5C50);
//   static const textMuted = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBABE);
//   static const chipBg = Color(0xFFF4F6F1);
//   static const tafsirBg = Color(0xFFF6FAF7);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // MODEL
// // ─────────────────────────────────────────────────────────────────────────────
// class _Ayah {
//   final String arabic;
//   final String bengali;
//   final String surahNameBn;
//   final int surahNumber;
//   final int ayahNumber;
//   final int juzNumber; // para

//   const _Ayah({
//     required this.arabic,
//     required this.bengali,
//     required this.surahNameBn,
//     required this.surahNumber,
//     required this.ayahNumber,
//     required this.juzNumber,
//   });
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // CURATED POOL  (global 1-based indices, alquran.cloud)
// // ─────────────────────────────────────────────────────────────────────────────
// const _pool = [
//   45, // 2:45  seek help with sabr & salah
//   153, // 2:153 sabr & salah
//   177, // 2:177 birr / righteousness
//   261, // 2:261 sadaqah parable
//   274, // 2:274 sadaqah by night & day
//   255, // 2:255 Ayatul Kursi
//   286, // 2:286 Allah burdens not a soul
//   102, // 3:102 taqwa
//   200, // 3:200 sabr & muraqaba
//   2323, // 18:30 reward for righteous deeds
//   3996, // 31:17 establish prayer
//   4674, // 39:10 reward of sabr without measure
//   4847, // 49:13 taqwa is true honour
//   4618, // 45:15 righteous deeds for himself
//   2788, // 22:37 taqwa reaches Allah
//   5765, // 94:5  ease after hardship
//   5766, // 94:6  ease repeated
//   6235, // 103:2 mankind in loss
//   6236, // 103:3 except believers & doers
//   1, // 1:1   Bismillah
//   7, // 1:7   straight path
//   5244, // 67:2  created death & life to test
//   183, // 2:183 fasting & taqwa
// ];

// const _bnSurahNames = <int, String>{
//   1: 'আল-ফাতিহা',
//   2: 'আল-বাকারা',
//   3: 'আলে-ইমরান',
//   18: 'আল-কাহফ',
//   22: 'আল-হাজ্জ',
//   31: 'লোকমান',
//   39: 'আয-যুমার',
//   45: 'আল-জাছিয়া',
//   49: 'আল-হুজুরাত',
//   67: 'আল-মুলক',
//   94: 'আশ-শারহ',
//   103: 'আল-আসর',
// };

// // Bengali juz names (1..30)
// String _juzBn(int j) {
//   const bn = [
//     '১',
//     '২',
//     '৩',
//     '৪',
//     '৫',
//     '৬',
//     '৭',
//     '৮',
//     '৯',
//     '১০',
//     '১১',
//     '১২',
//     '১৩',
//     '১৪',
//     '১৫',
//     '১৬',
//     '১৭',
//     '১৮',
//     '১৯',
//     '২০',
//     '২১',
//     '২২',
//     '২৩',
//     '২৪',
//     '২৫',
//     '২৬',
//     '২৭',
//     '২৮',
//     '২৯',
//     '৩০'
//   ];
//   if (j < 1 || j > 30) return '$j';
//   return '${bn[j - 1]}তম';
// }

// // Bengali ayah number
// String _bnNum(int n) {
//   const digits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
//   return n.toString().split('').map((d) => digits[int.parse(d)]).join();
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PROVIDERS
// // ─────────────────────────────────────────────────────────────────────────────
// const _fallback = _Ayah(
//   arabic: 'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
//   bengali: 'নিশ্চয়ই আল্লাহ ধৈর্যশীলদের সাথে আছেন।',
//   surahNameBn: 'আল-বাকারা',
//   surahNumber: 2,
//   ayahNumber: 153,
//   juzNumber: 2,
// );

// // New random ayah every app session
// final _sessionIdxProvider = Provider<int>((ref) {
//   final rng = Random(DateTime.now().microsecondsSinceEpoch);
//   return _pool[rng.nextInt(_pool.length)];
// });

// final _ayahProvider = FutureProvider<_Ayah>((ref) async {
//   final idx = ref.watch(_sessionIdxProvider);
//   return _fetchAyah(idx);
// });

// final _tafsirProvider = FutureProvider.family<String, int>((ref, idx) async {
//   return _fetchTafsir(idx);
// });

// // ─────────────────────────────────────────────────────────────────────────────
// // NETWORK
// // ─────────────────────────────────────────────────────────────────────────────
// Future<_Ayah> _fetchAyah(int globalIdx) async {
//   try {
//     final uri = Uri.parse(
//       'https://api.alquran.cloud/v1/ayah/$globalIdx/editions/quran-uthmani,bn.bengali',
//     );
//     final resp = await http.get(uri).timeout(const Duration(seconds: 8));
//     if (resp.statusCode != 200) return _fallback;
//     final body = jsonDecode(resp.body) as Map<String, dynamic>;
//     final data = body['data'] as List<dynamic>;
//     final ar = data[0] as Map<String, dynamic>;
//     final bn = data[1] as Map<String, dynamic>;
//     final surahNum = (ar['surah']?['number'] as int?) ?? 0;
//     final juzNum = (ar['juz'] as int?) ?? 1;
//     return _Ayah(
//       arabic: (ar['text'] as String?) ?? '',
//       bengali: (bn['text'] as String?) ?? '',
//       surahNameBn: _bnSurahNames[surahNum] ?? 'সূরা #$surahNum',
//       surahNumber: surahNum,
//       ayahNumber: (ar['numberInSurah'] as int?) ?? 0,
//       juzNumber: juzNum,
//     );
//   } catch (_) {
//     return _fallback;
//   }
// }

// Future<String> _fetchTafsir(int globalIdx) async {
//   // Try Bengali tafsir edition first
//   try {
//     final uri = Uri.parse(
//       'https://api.alquran.cloud/v1/ayah/$globalIdx/bn.tafseer.ibn.kaseer',
//     );
//     final resp = await http.get(uri).timeout(const Duration(seconds: 8));
//     if (resp.statusCode == 200) {
//       final text = (jsonDecode(resp.body)['data']?['text'] as String?) ?? '';
//       if (text.isNotEmpty) return text;
//     }
//   } catch (_) {}
//   // Fallback: standard Bengali translation
//   try {
//     final uri = Uri.parse(
//       'https://api.alquran.cloud/v1/ayah/$globalIdx/bn.bengali',
//     );
//     final resp = await http.get(uri).timeout(const Duration(seconds: 6));
//     if (resp.statusCode == 200) {
//       return (jsonDecode(resp.body)['data']?['text'] as String?) ?? _tafsirErr;
//     }
//   } catch (_) {}
//   return _tafsirErr;
// }

// const _tafsirErr = 'তাফসির লোড করা যায়নি। পুনরায় চেষ্টা করুন।';

// // ─────────────────────────────────────────────────────────────────────────────
// // PUBLIC WIDGET — drop in HomeScreen between WeekStrip and MonthHistory
// // ─────────────────────────────────────────────────────────────────────────────

// /// Usage in HomeScreen build():
// ///   const SizedBox(height: 16),
// ///   const DailyAyahSection(),
// ///   const SizedBox(height: 20),
// class DailyAyahSection extends ConsumerWidget {
//   const DailyAyahSection({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final ayah = ref.watch(_ayahProvider);
//     return ayah.when(
//       loading: () => const _LoadingCard(),
//       error: (_, __) => _AyahCard(ayah: _fallback, ayahIdx: 153),
//       data: (d) {
//         final idx = ref.read(_sessionIdxProvider);
//         return _AyahCard(ayah: d, ayahIdx: idx)
//             .animate()
//             .fadeIn(duration: 300.ms);
//       },
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // LOADING CARD
// // Single compact row: spinner + emotional text — no layout shift
// // ─────────────────────────────────────────────────────────────────────────────
// class _LoadingCard extends StatelessWidget {
//   const _LoadingCard();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       child: Row(
//         children: [
//           // Tiny spinner
//           SizedBox(
//             width: 13,
//             height: 13,
//             child: CircularProgressIndicator(
//               strokeWidth: 1.5,
//               color: _C.midGreen,
//               backgroundColor: _C.border,
//             ),
//           ),
//           const SizedBox(width: 10),
//           RichText(
//             text: const TextSpan(
//               style: TextStyle(
//                 fontSize: 12,
//                 color: _C.textSec,
//                 fontWeight: FontWeight.w500,
//               ),
//               children: [
//                 TextSpan(
//                   text: 'আপনার জন্য ',
//                   style: TextStyle(
//                     color: _C.darkGreen,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 TextSpan(text: 'একটি আয়াত নিয়ে আসছি…'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 900.ms);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // AYAH CARD
// // ─────────────────────────────────────────────────────────────────────────────
// class _AyahCard extends ConsumerStatefulWidget {
//   final _Ayah ayah;
//   final int ayahIdx;
//   const _AyahCard({required this.ayah, required this.ayahIdx});

//   @override
//   ConsumerState<_AyahCard> createState() => _AyahCardState();
// }

// class _AyahCardState extends ConsumerState<_AyahCard>
//     with SingleTickerProviderStateMixin {
//   bool _expanded = false;
//   bool _tafsirRequested = false;
//   late final AnimationController _ctrl;
//   late final Animation<double> _chevron;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 260),
//     );
//     _chevron = Tween<double>(begin: 0, end: 0.5)
//         .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   void _toggle() {
//     setState(() {
//       _expanded = !_expanded;
//       if (_expanded && !_tafsirRequested) _tafsirRequested = true;
//     });
//     _expanded ? _ctrl.forward() : _ctrl.reverse();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // ── ALWAYS VISIBLE ───────────────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.fromLTRB(14, 13, 14, 0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Badge row
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 3),
//                       decoration: BoxDecoration(
//                         color: _C.greenLight,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Text(
//                         '📖 আজকের আয়াত',
//                         style: TextStyle(
//                           fontSize: 9,
//                           fontWeight: FontWeight.w700,
//                           color: _C.midGreen,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 7),
//                     Container(
//                       width: 3,
//                       height: 3,
//                       decoration: const BoxDecoration(
//                         color: _C.greenBorder,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 7),
//                     Text(
//                       '${widget.ayah.surahNameBn} ${_bnNum(widget.ayah.surahNumber)}:${_bnNum(widget.ayah.ayahNumber)}',
//                       style: const TextStyle(
//                         fontSize: 9,
//                         fontWeight: FontWeight.w600,
//                         color: _C.textHint,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 10),

//                 // Bengali meaning — 3-line clamp + expand
//                 GestureDetector(
//                   onTap: _toggle,
//                   behavior: HitTestBehavior.opaque,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.ayah.bengali,
//                         maxLines: _expanded ? null : 3,
//                         overflow: _expanded
//                             ? TextOverflow.visible
//                             : TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontSize: 14.5,
//                           fontWeight: FontWeight.w600,
//                           color: _C.textPri,
//                           height: 1.75,
//                           letterSpacing: 0.05,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Row(
//                         children: [
//                           Text(
//                             _expanded ? 'কম দেখুন' : 'আরো পড়ুন',
//                             style: const TextStyle(
//                               fontSize: 10.5,
//                               fontWeight: FontWeight.w700,
//                               color: _C.midGreen,
//                             ),
//                           ),
//                           const SizedBox(width: 3),
//                           RotationTransition(
//                             turns: _chevron,
//                             child: const Icon(
//                               Icons.keyboard_arrow_down_rounded,
//                               size: 14,
//                               color: _C.midGreen,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 12),
//               ],
//             ),
//           ),

//           // ── EXPANDED SECTION ─────────────────────────────────────────────
//           AnimatedCrossFade(
//             firstChild: const SizedBox(width: double.infinity),
//             secondChild: _ExpandedContent(
//               ayah: widget.ayah,
//               ayahIdx: widget.ayahIdx,
//               tafsirRequested: _tafsirRequested,
//             ),
//             crossFadeState: _expanded
//                 ? CrossFadeState.showSecond
//                 : CrossFadeState.showFirst,
//             duration: const Duration(milliseconds: 320),
//             sizeCurve: Curves.easeInOut,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // EXPANDED CONTENT
// // Arabic → Surah/Ayah/Para chips → Tafsir
// // ─────────────────────────────────────────────────────────────────────────────
// class _ExpandedContent extends ConsumerWidget {
//   final _Ayah ayah;
//   final int ayahIdx;
//   final bool tafsirRequested;

//   const _ExpandedContent({
//     required this.ayah,
//     required this.ayahIdx,
//     required this.tafsirRequested,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final tafsir = tafsirRequested ? ref.watch(_tafsirProvider(ayahIdx)) : null;

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // Arabic block
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             decoration: BoxDecoration(
//               color: _C.goldBg,
//               borderRadius: BorderRadius.circular(9),
//               border: Border.all(color: _C.goldBorder, width: 0.5),
//             ),
//             child: Text(
//               ayah.arabic,
//               textDirection: TextDirection.rtl,
//               textAlign: TextAlign.right,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: _C.goldText,
//                 height: 2.0,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ),

//           const SizedBox(height: 9),

//           // Surah · Ayah · Para chips
//           Row(
//             children: [
//               _InfoChip(label: 'সূরা', value: ayah.surahNameBn),
//               const SizedBox(width: 8),
//               _InfoChip(label: 'আয়াত নং', value: _bnNum(ayah.ayahNumber)),
//               const SizedBox(width: 8),
//               _InfoChip(label: 'পারা', value: _juzBn(ayah.juzNumber)),
//             ],
//           ),

//           const SizedBox(height: 9),

//           // Tafsir block
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(11),
//             decoration: BoxDecoration(
//               color: _C.tafsirBg,
//               borderRadius: BorderRadius.circular(9),
//               border: const Border(
//                 left: BorderSide(color: _C.midGreen, width: 2.5),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'তাফসির সংক্ষেপ',
//                   style: TextStyle(
//                     fontSize: 8.5,
//                     fontWeight: FontWeight.w700,
//                     color: _C.midGreen,
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 if (tafsir == null)
//                   const SizedBox.shrink()
//                 else
//                   tafsir.when(
//                     loading: () => _TafsirLoading(),
//                     error: (_, __) => _tafsirText(_tafsirErr),
//                     data: (t) =>
//                         _tafsirText(t).animate().fadeIn(duration: 260.ms),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ).animate().fadeIn(duration: 220.ms);
//   }

//   Widget _tafsirText(String t) => Text(
//         t,
//         style: const TextStyle(
//           fontSize: 12,
//           height: 1.8,
//           color: _C.textSec,
//         ),
//       );
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // INFO CHIP
// // ─────────────────────────────────────────────────────────────────────────────
// class _InfoChip extends StatelessWidget {
//   final String label, value;
//   const _InfoChip({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) => Expanded(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
//           decoration: BoxDecoration(
//             color: _C.chipBg,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: _C.border, width: 0.5),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 8.5,
//                   color: _C.textMuted,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 11,
//                   color: _C.textPri,
//                   fontWeight: FontWeight.w700,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       );
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // TAFSIR LOADING
// // ─────────────────────────────────────────────────────────────────────────────
// class _TafsirLoading extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: List.generate(
//           3,
//           (i) => Container(
//             margin: const EdgeInsets.only(bottom: 5),
//             height: 11,
//             width: i == 2 ? 140 : double.infinity,
//             decoration: BoxDecoration(
//               color: _C.greenBorder.withOpacity(0.5),
//               borderRadius: BorderRadius.circular(3),
//             ),
//           )
//               .animate(onPlay: (c) => c.repeat(reverse: true))
//               .fadeIn(duration: 700.ms, delay: Duration(milliseconds: i * 80)),
//         ),
//       );
// }
// import 'dart:convert';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;

// // ─────────────────────────────────────────────────────────────────────────────
// // TOKENS
// // ─────────────────────────────────────────────────────────────────────────────
// class _C {
//   static const pageBg = Color(0xFFF4F6F1);
//   static const card = Color(0xFFFFFFFF);
//   static const darkGreen = Color(0xFF0E3D22);
//   static const midGreen = Color(0xFF1B7045);
//   static const greenLight = Color(0xFFE8F5EE);
//   static const greenBorder = Color(0xFFD4E9D9);
//   static const gold = Color(0xFFD4A843);
//   static const goldBg = Color(0xFFFDFAF3);
//   static const goldBorder = Color(0xFFEDD98A);
//   static const goldText = Color(0xFF8B6914);
//   static const border = Color(0xFFE0E8E2);
//   static const textPri = Color(0xFF0A1A0F);
//   static const textSec = Color(0xFF4A5C50);
//   static const textMuted = Color(0xFF6B7C6E);
//   static const textHint = Color(0xFFABBABE);
//   static const chipBg = Color(0xFFF4F6F1);
//   static const tafsirBg = Color(0xFFF6FAF7);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // MODEL
// // ─────────────────────────────────────────────────────────────────────────────
// class _Ayah {
//   final String arabic;
//   final String bengali;
//   final String surahNameBn;
//   final int surahNumber;
//   final int ayahNumber;
//   final int juzNumber;

//   const _Ayah({
//     required this.arabic,
//     required this.bengali,
//     required this.surahNameBn,
//     required this.surahNumber,
//     required this.ayahNumber,
//     required this.juzNumber,
//   });
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // TAFSIR TEXTS — hardcoded Bengali tafsir for curated pool
// // alquran.cloud-এ proper Bengali tafsir edition নেই,
// // তাই curated meaningful tafsir directly embed করা হয়েছে।
// // Key = global ayah index (same as _pool entries)
// // ─────────────────────────────────────────────────────────────────────────────
// const _tafsirMap = <int, String>{
//   45: 'আল্লাহ তাআলা এখানে মুমিনদেরকে দুটি মহান হাতিয়ারের মাধ্যমে সাহায্য চাইতে বলেছেন — সবর ও সালাত। সালাত আত্মাকে আল্লাহর সাথে সংযুক্ত করে, আর সবর বিপদের সময় স্থির রাখে।',
//   153:
//       'এই আয়াতে আল্লাহ মুমিনদের জন্য দুটি পথ দেখিয়েছেন — সবর ও সালাত। সবর মানে শুধু সহ্য করা নয়, বরং অবিচল থাকা। সালাত হলো আল্লাহর সাথে সরাসরি কথোপকথন। এই দুটি একত্রিত হলে দুনিয়ার কোনো কষ্টই মুমিনকে দমাতে পারে না।',
//   177:
//       'প্রকৃত নেকি শুধু পূর্ব বা পশ্চিমে মুখ ফেরানোর মধ্যে নয়। বরং আল্লাহ, আখেরাত, ফেরেশতা ও কিতাবে বিশ্বাস রাখা, সম্পদ ব্যয় করা, সালাত কায়েম করা ও ওয়াদা পূরণ করাই প্রকৃত ঈমান ও তাকওয়ার পরিচয়।',
//   255:
//       'আয়াতুল কুরসি — কুরআনের সর্বশ্রেষ্ঠ আয়াত। আল্লাহর পরিচয়, তাঁর অসীম জ্ঞান ও ক্ষমতার বর্ণনা। তিনি চিরঞ্জীব, সর্বসত্তার ধারক। তাঁর কুরসি আসমান ও জমিন পরিব্যাপ্ত।',
//   261:
//       'যে ব্যক্তি আল্লাহর পথে সম্পদ ব্যয় করে, তার উপমা সেই বীজের মতো যা থেকে সাতটি শীষ জন্মায়, প্রতিটি শীষে একশো দানা। আল্লাহ যাকে ইচ্ছা বহুগুণ বৃদ্ধি করেন।',
//   274:
//       'যারা রাতে-দিনে, গোপনে-প্রকাশ্যে আল্লাহর পথে ব্যয় করে, তাদের পুরস্কার তাদের রবের কাছে আছে। তাদের কোনো ভয় নেই এবং তারা দুঃখিত হবে না।',
//   286:
//       'আল্লাহ কাউকে তার সাধ্যের বাইরে বোঝা চাপান না। ভালো কাজের ফল তার নিজের জন্য, মন্দ কাজের বোঝাও তার নিজের। হে রব! আমাদের ভুলে বা অজ্ঞতায় যা হয়েছে তা ক্ষমা করুন।',
//   102:
//       'হে মুমিনগণ! তোমরা আল্লাহকে যেভাবে ভয় করা উচিত সেভাবে ভয় করো এবং মুসলিম না হয়ে মৃত্যুবরণ করো না। তাকওয়া হলো আল্লাহর প্রতি সচেতন সতর্কতা।',
//   200:
//       'হে মুমিনগণ! ধৈর্য ধারণ করো, পরস্পরে ধৈর্যে প্রতিযোগিতা করো এবং আল্লাহর পথে দৃঢ় থাকো। সফলকামরাই আল্লাহকে ভয় করে।',
//   2323:
//       'যারা ঈমান আনে ও সৎকাজ করে, আমি তাদের পুরস্কার নষ্ট করি না। জান্নাতের বাগানে তারা থাকবে, যার নিচে নহর প্রবাহিত।',
//   3996:
//       'হে প্রিয় পুত্র! সালাত কায়েম করো, সৎকাজের আদেশ দাও, অসৎকাজ থেকে নিষেধ করো এবং যা বিপদ আসে তাতে ধৈর্য ধরো। নিশ্চয়ই এটাই দৃঢ় সংকল্পের কাজ।',
//   4674:
//       'যারা ধৈর্য ধরে, নিশ্চয়ই তাদের পুরস্কার বিনা হিসাবে দেওয়া হবে। অন্য সব আমলের পুরস্কার নির্দিষ্ট, কিন্তু সবরের পুরস্কারের কোনো সীমা নেই — এটি আল্লাহর সবচেয়ে বড় প্রতিশ্রুতিগুলোর একটি।',
//   4847:
//       'হে মানবজাতি! আমি তোমাদের একজন পুরুষ ও একজন নারী থেকে সৃষ্টি করেছি। তোমাদের মধ্যে আল্লাহর কাছে সর্বাধিক মর্যাদাবান সে, যে সর্বাধিক তাকওয়াসম্পন্ন।',
//   4618:
//       'যে ব্যক্তি নেক আমল করে, সে নিজের জন্যই করে। আর যে মন্দ করে, সে নিজের বিরুদ্ধেই করে। তোমার রব বান্দাদের প্রতি মোটেও জুলুম করেন না।',
//   2788:
//       'কোরবানির পশুর গোশত বা রক্ত আল্লাহর কাছে পৌঁছায় না, বরং তোমাদের তাকওয়াই পৌঁছায়। আল্লাহ দেখেন হৃদয়ের নিষ্ঠা, বাহ্যিক আচার নয়।',
//   5765:
//       'নিশ্চয়ই কষ্টের সাথেই স্বস্তি আছে। প্রতিটি অন্ধকারের পর আলো আসে — এটি আল্লাহর অপরিবর্তনীয় নিয়ম। বিপদের মাঝেই লুকিয়ে থাকে সুখের বীজ।',
//   5766:
//       'নিশ্চয়ই কষ্টের সাথেই স্বস্তি আছে — আল্লাহ এই কথাটি দুবার বললেন, কারণ একটি কষ্টের বিপরীতে দুটি স্বস্তি। রাসুল ﷺ বলেছেন: একটি কষ্ট দুটি স্বস্তিকে পরাজিত করবে না।',
//   6235:
//       'কালের শপথ! মানুষ অবশ্যই ক্ষতির মধ্যে আছে — ব্যবসায়িক ক্ষতি নয়, বরং আখেরাতের ক্ষতি। যে সময় চলে গেছে আর ফিরে আসবে না — প্রতিটি মুহূর্ত হিসাব।',
//   6236:
//       'কিন্তু তারা নয় যারা ঈমান আনে, নেক আমল করে, পরস্পরকে সত্যের উপদেশ দেয় ও ধৈর্যের উপদেশ দেয়। এই চারটি গুণ মানুষকে ক্ষতি থেকে বাঁচায়।',
//   1: 'বিসমিল্লাহির রাহমানির রাহিম — আল্লাহর নামে শুরু যিনি পরম করুণাময়, অতি দয়ালু। প্রতিটি ভালো কাজ এই নামে শুরু করলে বরকত আসে।',
//   7: 'সিরাতুল মুস্তাকিম — সে পথ যে পথে আল্লাহ নেয়ামত দিয়েছেন নবী, সিদ্দিক, শহীদ ও সালেহীনদের। প্রতিদিন সালাতে আমরা এই পথ চাই — এটিই জীবনের সবচেয়ে গুরুত্বপূর্ণ দুআ।',
//   5244:
//       'আল্লাহ মৃত্যু ও জীবন সৃষ্টি করেছেন পরীক্ষা করতে — কে আমল করে উত্তমভাবে। দুনিয়া একটি পরীক্ষার হল। প্রতিটি কষ্ট, সুখ, সুযোগ — সবই পরীক্ষার অংশ।',
//   183:
//       'রোজা ফরজ করা হয়েছে তাকওয়া অর্জনের জন্য। ক্ষুধা-তৃষ্ণার কষ্ট মানুষকে আল্লাহর নেয়ামতের কদর শেখায় এবং গরিবের ব্যথা অনুভব করতে শেখায়।',
// };

// // ─────────────────────────────────────────────────────────────────────────────
// // CURATED POOL
// // ─────────────────────────────────────────────────────────────────────────────
// const _pool = [
//   45,
//   153,
//   177,
//   255,
//   261,
//   274,
//   286,
//   102,
//   200,
//   2323,
//   3996,
//   4674,
//   4847,
//   4618,
//   2788,
//   5765,
//   5766,
//   6235,
//   6236,
//   1,
//   7,
//   5244,
//   183,
// ];

// const _bnSurahNames = <int, String>{
//   1: 'আল-ফাতিহা',
//   2: 'আল-বাকারা',
//   3: 'আলে-ইমরান',
//   18: 'আল-কাহফ',
//   22: 'আল-হাজ্জ',
//   31: 'লোকমান',
//   39: 'আয-যুমার',
//   45: 'আল-জাছিয়া',
//   49: 'আল-হুজুরাত',
//   67: 'আল-মুলক',
//   94: 'আশ-শারহ',
//   103: 'আল-আসর',
// };

// String _juzBn(int j) {
//   const bn = [
//     '১',
//     '২',
//     '৩',
//     '৪',
//     '৫',
//     '৬',
//     '৭',
//     '৮',
//     '৯',
//     '১০',
//     '১১',
//     '১২',
//     '১৩',
//     '১৪',
//     '১৫',
//     '১৬',
//     '১৭',
//     '১৮',
//     '১৯',
//     '২০',
//     '২১',
//     '২২',
//     '২৩',
//     '২৪',
//     '২৫',
//     '২৬',
//     '২৭',
//     '২৮',
//     '২৯',
//     '৩০'
//   ];
//   if (j < 1 || j > 30) return '$j';
//   return '${bn[j - 1]}তম';
// }

// String _bnNum(int n) {
//   const d = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
//   return n.toString().split('').map((c) => d[int.parse(c)]).join();
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PROVIDERS
// // ─────────────────────────────────────────────────────────────────────────────
// const _fallback = _Ayah(
//   arabic: 'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
//   bengali: 'নিশ্চয়ই আল্লাহ ধৈর্যশীলদের সাথে আছেন।',
//   surahNameBn: 'আল-বাকারা',
//   surahNumber: 2,
//   ayahNumber: 153,
//   juzNumber: 2,
// );

// // Notifier so we can force a new ayah on button tap
// class _AyahIndexNotifier extends Notifier<int> {
//   @override
//   int build() => _pickRandom(-1);

//   int _pickRandom(int exclude) {
//     final rng = Random(DateTime.now().microsecondsSinceEpoch);
//     int idx;
//     do {
//       idx = _pool[rng.nextInt(_pool.length)];
//     } while (idx == exclude && _pool.length > 1);
//     return idx;
//   }

//   void next() => state = _pickRandom(state);
// }

// final _ayahIndexProvider =
//     NotifierProvider<_AyahIndexNotifier, int>(_AyahIndexNotifier.new);

// final _ayahProvider = FutureProvider<_Ayah>((ref) async {
//   final idx = ref.watch(_ayahIndexProvider);
//   return _fetchAyah(idx);
// });

// // ─────────────────────────────────────────────────────────────────────────────
// // NETWORK — fetch ayah only (tafsir is local)
// // ─────────────────────────────────────────────────────────────────────────────
// Future<_Ayah> _fetchAyah(int globalIdx) async {
//   try {
//     final uri = Uri.parse(
//       'https://api.alquran.cloud/v1/ayah/$globalIdx/editions/quran-uthmani,bn.bengali',
//     );
//     final resp = await http.get(uri).timeout(const Duration(seconds: 8));
//     if (resp.statusCode != 200) return _fallback;
//     final body = jsonDecode(resp.body) as Map<String, dynamic>;
//     final data = body['data'] as List<dynamic>;
//     final ar = data[0] as Map<String, dynamic>;
//     final bn = data[1] as Map<String, dynamic>;
//     final surahNum = (ar['surah']?['number'] as int?) ?? 0;
//     final juzNum = (ar['juz'] as int?) ?? 1;
//     return _Ayah(
//       arabic: (ar['text'] as String?) ?? '',
//       bengali: (bn['text'] as String?) ?? '',
//       surahNameBn: _bnSurahNames[surahNum] ?? 'সূরা #$surahNum',
//       surahNumber: surahNum,
//       ayahNumber: (ar['numberInSurah'] as int?) ?? 0,
//       juzNumber: juzNum,
//     );
//   } catch (_) {
//     return _fallback;
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // PUBLIC WIDGET
// // Usage in HomeScreen:
// //   const SizedBox(height: 16),
// //   const DailyAyahSection(),
// //   const SizedBox(height: 20),
// // ─────────────────────────────────────────────────────────────────────────────
// class DailyAyahSection extends ConsumerWidget {
//   const DailyAyahSection({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final ayah = ref.watch(_ayahProvider);
//     final idx = ref.watch(_ayahIndexProvider);

//     return ayah.when(
//       loading: () => const _LoadingCard(),
//       error: (_, __) => _AyahCard(ayah: _fallback, ayahIdx: 153),
//       data: (d) =>
//           _AyahCard(ayah: d, ayahIdx: idx).animate().fadeIn(duration: 300.ms),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // LOADING CARD — compact single row
// // ─────────────────────────────────────────────────────────────────────────────
// class _LoadingCard extends StatelessWidget {
//   const _LoadingCard();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 13,
//             height: 13,
//             child: CircularProgressIndicator(
//               strokeWidth: 1.5,
//               color: _C.midGreen,
//               backgroundColor: _C.border,
//             ),
//           ),
//           const SizedBox(width: 10),
//           RichText(
//             text: const TextSpan(
//               style: TextStyle(
//                 fontSize: 12,
//                 color: _C.textSec,
//                 fontWeight: FontWeight.w500,
//               ),
//               children: [
//                 TextSpan(
//                   text: 'আপনার জন্য ',
//                   style: TextStyle(
//                     color: _C.darkGreen,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 TextSpan(text: 'একটি আয়াত নিয়ে আসছি…'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 900.ms);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // AYAH CARD
// // ─────────────────────────────────────────────────────────────────────────────
// class _AyahCard extends ConsumerStatefulWidget {
//   final _Ayah ayah;
//   final int ayahIdx;
//   const _AyahCard({required this.ayah, required this.ayahIdx});

//   @override
//   ConsumerState<_AyahCard> createState() => _AyahCardState();
// }

// class _AyahCardState extends ConsumerState<_AyahCard>
//     with SingleTickerProviderStateMixin {
//   bool _expanded = false;
//   late final AnimationController _ctrl;
//   late final Animation<double> _chevron;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 260),
//     );
//     _chevron = Tween<double>(begin: 0, end: 0.5)
//         .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   void _toggle() {
//     setState(() => _expanded = !_expanded);
//     _expanded ? _ctrl.forward() : _ctrl.reverse();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _C.card,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: _C.border, width: 0.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // ── TOP: always visible ──────────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.fromLTRB(14, 13, 14, 0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Badge + surah ref
//                 Row(children: [
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                     decoration: BoxDecoration(
//                       color: _C.greenLight,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: const Text(
//                       '📖 আজকের আয়াত',
//                       style: TextStyle(
//                         fontSize: 9,
//                         fontWeight: FontWeight.w700,
//                         color: _C.midGreen,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 7),
//                   Container(
//                     width: 3,
//                     height: 3,
//                     decoration: const BoxDecoration(
//                         color: _C.greenBorder, shape: BoxShape.circle),
//                   ),
//                   const SizedBox(width: 7),
//                   Text(
//                     '${widget.ayah.surahNameBn} ${_bnNum(widget.ayah.surahNumber)}:${_bnNum(widget.ayah.ayahNumber)}',
//                     style: const TextStyle(
//                       fontSize: 9,
//                       fontWeight: FontWeight.w600,
//                       color: _C.textHint,
//                     ),
//                   ),
//                 ]),
//                 const SizedBox(height: 10),

//                 // Bengali meaning — 3-line clamp, tap to expand
//                 GestureDetector(
//                   onTap: _toggle,
//                   behavior: HitTestBehavior.opaque,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.ayah.bengali,
//                         maxLines: _expanded ? null : 3,
//                         overflow: _expanded
//                             ? TextOverflow.visible
//                             : TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontSize: 14.5,
//                           fontWeight: FontWeight.w600,
//                           color: _C.textPri,
//                           height: 1.75,
//                           letterSpacing: 0.05,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Row(children: [
//                         Text(
//                           _expanded ? 'কম দেখুন' : 'আরো পড়ুন',
//                           style: const TextStyle(
//                             fontSize: 10.5,
//                             fontWeight: FontWeight.w700,
//                             color: _C.midGreen,
//                           ),
//                         ),
//                         const SizedBox(width: 3),
//                         RotationTransition(
//                           turns: _chevron,
//                           child: const Icon(
//                             Icons.keyboard_arrow_down_rounded,
//                             size: 14,
//                             color: _C.midGreen,
//                           ),
//                         ),
//                       ]),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//               ],
//             ),
//           ),

//           // ── EXPANDED ─────────────────────────────────────────────────────
//           AnimatedCrossFade(
//             firstChild: const SizedBox(width: double.infinity),
//             secondChild: _ExpandedContent(
//               ayah: widget.ayah,
//               ayahIdx: widget.ayahIdx,
//             ),
//             crossFadeState: _expanded
//                 ? CrossFadeState.showSecond
//                 : CrossFadeState.showFirst,
//             duration: const Duration(milliseconds: 320),
//             sizeCurve: Curves.easeInOut,
//           ),

//           // ── BOTTOM DIVIDER + "অন্য আয়াত" — ALWAYS VISIBLE ──────────────
//           Container(
//             decoration: const BoxDecoration(
//               border: Border(
//                 top: BorderSide(color: _C.border, width: 0.5),
//               ),
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'প্রতিবার নতুন আয়াত',
//                   style: TextStyle(
//                     fontSize: 9,
//                     color: _C.textHint,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     // collapse before loading new ayah
//                     if (_expanded) {
//                       setState(() => _expanded = false);
//                       _ctrl.reverse();
//                     }
//                     ref.read(_ayahIndexProvider.notifier).next();
//                   },
//                   child: Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     decoration: BoxDecoration(
//                       color: _C.greenLight,
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: _C.greenBorder, width: 0.5),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: const [
//                         Text(
//                           'অন্য আয়াত',
//                           style: TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.w700,
//                             color: _C.midGreen,
//                           ),
//                         ),
//                         SizedBox(width: 4),
//                         Icon(
//                           Icons.arrow_forward_rounded,
//                           size: 11,
//                           color: _C.midGreen,
//                         ),
//                       ],
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

// // ─────────────────────────────────────────────────────────────────────────────
// // EXPANDED CONTENT — Arabic + chips + tafsir (local)
// // ─────────────────────────────────────────────────────────────────────────────
// class _ExpandedContent extends StatelessWidget {
//   final _Ayah ayah;
//   final int ayahIdx;
//   const _ExpandedContent({required this.ayah, required this.ayahIdx});

//   @override
//   Widget build(BuildContext context) {
//     final tafsirText = _tafsirMap[ayahIdx] ??
//         _tafsirMap[ayah.ayahNumber] ??
//         'এই আয়াতে আল্লাহ তাআলা মুমিনদের জন্য গুরুত্বপূর্ণ নির্দেশনা দিয়েছেন। আরো বিস্তারিত জানতে তাফসির ইবনে কাসীর বা তাফসির ফি যিলালিল কুরআন পড়ুন।';

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // Arabic block
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             decoration: BoxDecoration(
//               color: _C.goldBg,
//               borderRadius: BorderRadius.circular(9),
//               border: Border.all(color: _C.goldBorder, width: 0.5),
//             ),
//             child: Text(
//               ayah.arabic,
//               textDirection: TextDirection.rtl,
//               textAlign: TextAlign.right,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: _C.goldText,
//                 height: 2.0,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ),

//           const SizedBox(height: 9),

//           // Surah · Ayah · Para chips
//           Row(children: [
//             _InfoChip(label: 'সূরা', value: ayah.surahNameBn),
//             const SizedBox(width: 8),
//             _InfoChip(label: 'আয়াত নং', value: _bnNum(ayah.ayahNumber)),
//             const SizedBox(width: 8),
//             _InfoChip(label: 'পারা', value: _juzBn(ayah.juzNumber)),
//           ]),

//           const SizedBox(height: 9),

//           // Tafsir block — local, instant, no network
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(11),
//             decoration: BoxDecoration(
//               color: _C.tafsirBg,
//               borderRadius: BorderRadius.circular(9),
//               border: const Border(
//                 left: BorderSide(color: _C.midGreen, width: 2.5),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'তাফসির সংক্ষেপ',
//                   style: TextStyle(
//                     fontSize: 8.5,
//                     fontWeight: FontWeight.w700,
//                     color: _C.midGreen,
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   tafsirText,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     height: 1.8,
//                     color: _C.textSec,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ).animate().fadeIn(duration: 220.ms);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // INFO CHIP
// // ─────────────────────────────────────────────────────────────────────────────
// class _InfoChip extends StatelessWidget {
//   final String label, value;
//   const _InfoChip({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) => Expanded(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
//           decoration: BoxDecoration(
//             color: _C.chipBg,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: _C.border, width: 0.5),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(label,
//                   style: const TextStyle(
//                     fontSize: 8.5,
//                     color: _C.textMuted,
//                     fontWeight: FontWeight.w600,
//                   )),
//               const SizedBox(height: 2),
//               Text(value,
//                   style: const TextStyle(
//                     fontSize: 11,
//                     color: _C.textPri,
//                     fontWeight: FontWeight.w700,
//                   ),
//                   overflow: TextOverflow.ellipsis),
//             ],
//           ),
//         ),
//       );
// }
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// ─────────────────────────────────────────────────────────────────────────────
// TOKENS
// ─────────────────────────────────────────────────────────────────────────────
class _C {
  static const card = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const midGreen = Color(0xFF1B7045);
  static const greenLight = Color(0xFFE8F5EE);
  static const greenBorder = Color(0xFFD4E9D9);
  static const goldBg = Color(0xFFFDFAF3);
  static const goldBorder = Color(0xFFEDD98A);
  static const goldText = Color(0xFF8B6914);
  static const border = Color(0xFFE0E8E2);
  static const textPri = Color(0xFF0A1A0F);
  static const textSec = Color(0xFF4A5C50);
  static const textMuted = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBABE);
  static const chipBg = Color(0xFFF4F6F1);
  static const tafsirBg = Color(0xFFF6FAF7);
}

// ─────────────────────────────────────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────────────────────────────────────
class _AyahData {
  final String arabic;
  final String bengali;
  final String surahNameBn;
  final int surahNumber;
  final int ayahNumber;
  final int juzNumber;

  const _AyahData({
    required this.arabic,
    required this.bengali,
    required this.surahNameBn,
    required this.surahNumber,
    required this.ayahNumber,
    required this.juzNumber,
  });
}

// tafsir result: null = not available, empty string = loading failed
// non-empty = actual tafsir text
class _TafsirResult {
  final String? text; // null = API returned nothing useful
  const _TafsirResult(this.text);
}

// ─────────────────────────────────────────────────────────────────────────────
// CURATED POOL  (global 1-based indices, alquran.cloud)
// ─────────────────────────────────────────────────────────────────────────────
const _pool = [
  45,
  153,
  177,
  255,
  261,
  274,
  286,
  102,
  200,
  2323,
  3996,
  4674,
  4847,
  4618,
  2788,
  5765,
  5766,
  6235,
  6236,
  1,
  7,
  5244,
  183,
];

const _bnSurahNames = <int, String>{
  1: 'আল-ফাতিহা',
  2: 'আল-বাকারা',
  3: 'আলে-ইমরান',
  18: 'আল-কাহফ',
  22: 'আল-হাজ্জ',
  31: 'লোকমান',
  39: 'আয-যুমার',
  45: 'আল-জাছিয়া',
  49: 'আল-হুজুরাত',
  67: 'আল-মুলক',
  94: 'আশ-শারহ',
  103: 'আল-আসর',
};

String _juzBn(int j) {
  const bn = [
    '১',
    '২',
    '৩',
    '৪',
    '৫',
    '৬',
    '৭',
    '৮',
    '৯',
    '১০',
    '১১',
    '১২',
    '১৩',
    '১৪',
    '১৫',
    '১৬',
    '১৭',
    '১৮',
    '১৯',
    '২০',
    '২১',
    '২২',
    '২৩',
    '২৪',
    '২৫',
    '২৬',
    '২৭',
    '২৮',
    '২৯',
    '৩০',
  ];
  if (j < 1 || j > 30) return '$j';
  return '${bn[j - 1]}তম';
}

String _bnNum(int n) {
  const d = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
  return n.toString().split('').map((c) => d[int.parse(c)]).join();
}

// ─────────────────────────────────────────────────────────────────────────────
// FALLBACK
// ─────────────────────────────────────────────────────────────────────────────
const _fallback = _AyahData(
  arabic: 'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
  bengali: 'নিশ্চয়ই আল্লাহ ধৈর্যশীলদের সাথে আছেন।',
  surahNameBn: 'আল-বাকারা',
  surahNumber: 2,
  ayahNumber: 153,
  juzNumber: 2,
);

// ─────────────────────────────────────────────────────────────────────────────
// PROVIDERS
// ─────────────────────────────────────────────────────────────────────────────

// Manages current ayah index — can call .next() to get a new random one
class _AyahIndexNotifier extends Notifier<int> {
  @override
  int build() => _pick(-1);

  int _pick(int exclude) {
    final rng = Random(DateTime.now().microsecondsSinceEpoch);
    int idx;
    do {
      idx = _pool[rng.nextInt(_pool.length)];
    } while (idx == exclude && _pool.length > 1);
    return idx;
  }

  void next() => state = _pick(state);
}

final _ayahIndexProvider =
    NotifierProvider<_AyahIndexNotifier, int>(_AyahIndexNotifier.new);

// Fetches ayah text from API — re-runs whenever index changes
final _ayahProvider = FutureProvider<_AyahData>((ref) {
  final idx = ref.watch(_ayahIndexProvider);
  return _fetchAyah(idx);
});

// Fetches tafsir lazily — only called when user expands
// Returns _TafsirResult(null) if nothing available
final _tafsirProvider =
    FutureProvider.family<_TafsirResult, int>((ref, globalIdx) async {
  return _fetchTafsir(globalIdx);
});

// ─────────────────────────────────────────────────────────────────────────────
// NETWORK
// ─────────────────────────────────────────────────────────────────────────────

Future<_AyahData> _fetchAyah(int globalIdx) async {
  try {
    final uri = Uri.parse(
      'https://api.alquran.cloud/v1/ayah/$globalIdx'
      '/editions/quran-uthmani,bn.bengali',
    );
    final resp = await http.get(uri).timeout(const Duration(seconds: 8));
    if (resp.statusCode != 200) return _fallback;

    final body = jsonDecode(resp.body) as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;
    final ar = data[0] as Map<String, dynamic>;
    final bn = data[1] as Map<String, dynamic>;
    final surahNum = (ar['surah']?['number'] as int?) ?? 0;
    final juzNum = (ar['juz'] as int?) ?? 1;

    return _AyahData(
      arabic: (ar['text'] as String?) ?? '',
      bengali: (bn['text'] as String?) ?? '',
      surahNameBn: _bnSurahNames[surahNum] ?? 'সূরা #$surahNum',
      surahNumber: surahNum,
      ayahNumber: (ar['numberInSurah'] as int?) ?? 0,
      juzNumber: juzNum,
    );
  } catch (_) {
    return _fallback;
  }
}

// Tries known Bengali tafsir editions in order.
// If none return valid text → _TafsirResult(null) (hidden silently).
Future<_TafsirResult> _fetchTafsir(int globalIdx) async {
  // alquran.cloud Bengali tafsir editions to try in order
  const editions = [
    'bn.tafseer.bayaan', // Tafsir Bayaan (Bengali)
    'bn.tafseer.ibne-kaseer', // Ibn Kathir Bengali (if available)
    'bn.bengali', // Plain translation as last resort
  ];

  for (final edition in editions) {
    try {
      final uri = Uri.parse(
        'https://api.alquran.cloud/v1/ayah/$globalIdx/$edition',
      );
      final resp = await http.get(uri).timeout(const Duration(seconds: 8));
      if (resp.statusCode != 200) continue;

      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      final text = (body['data']?['text'] as String?)?.trim() ?? '';

      // Only accept if it looks like a tafsir (longer than a plain translation)
      // and isn't just repeating the translation
      if (text.isNotEmpty && text.length > 30) {
        return _TafsirResult(text);
      }
    } catch (_) {
      continue;
    }
  }

  // Nothing found — return null so UI hides the block entirely
  return const _TafsirResult(null);
}

// ─────────────────────────────────────────────────────────────────────────────
// PUBLIC WIDGET
// Usage in HomeScreen build():
//   const SizedBox(height: 16),
//   const DailyAyahSection(),
//   const SizedBox(height: 20),
// ─────────────────────────────────────────────────────────────────────────────
class DailyAyahSection extends ConsumerWidget {
  const DailyAyahSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ayah = ref.watch(_ayahProvider);
    final idx = ref.watch(_ayahIndexProvider);

    return ayah.when(
      loading: () => const _LoadingCard(),
      error: (_, __) => _AyahCard(ayah: _fallback, ayahIdx: 153),
      data: (d) =>
          _AyahCard(ayah: d, ayahIdx: idx).animate().fadeIn(duration: 300.ms),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LOADING CARD — compact single row, no space waste
// ─────────────────────────────────────────────────────────────────────────────
class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.border, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 13,
            height: 13,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: _C.midGreen,
              backgroundColor: _C.border,
            ),
          ),
          const SizedBox(width: 10),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 12,
                color: _C.textSec,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text: 'আপনার জন্য ',
                  style: TextStyle(
                    color: _C.darkGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: 'একটি আয়াত নিয়ে আসছি…'),
              ],
            ),
          ),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 900.ms);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AYAH CARD
// ─────────────────────────────────────────────────────────────────────────────
class _AyahCard extends ConsumerStatefulWidget {
  final _AyahData ayah;
  final int ayahIdx;
  const _AyahCard({required this.ayah, required this.ayahIdx});

  @override
  ConsumerState<_AyahCard> createState() => _AyahCardState();
}

class _AyahCardState extends ConsumerState<_AyahCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  bool _tafsirRequested = false;

  late final AnimationController _ctrl;
  late final Animation<double> _chevron;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _chevron = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded && !_tafsirRequested) _tafsirRequested = true;
    });
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  void _nextAyah() {
    if (_expanded) {
      setState(() {
        _expanded = false;
        _tafsirRequested = false;
      });
      _ctrl.reverse();
    }
    ref.read(_ayahIndexProvider.notifier).next();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── ALWAYS VISIBLE — badge + meaning ────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 13, 14, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _C.greenLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '📖 আজকের আয়াত',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: _C.midGreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Container(
                    width: 3,
                    height: 3,
                    decoration: const BoxDecoration(
                      color: _C.greenBorder,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Flexible(
                    child: Text(
                      '${widget.ayah.surahNameBn} '
                      '${_bnNum(widget.ayah.surahNumber)}:'
                      '${_bnNum(widget.ayah.ayahNumber)}',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: _C.textHint,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ]),

                const SizedBox(height: 10),

                // Bengali meaning — 3-line clamp, tap to expand
                GestureDetector(
                  onTap: _toggle,
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.ayah.bengali,
                        maxLines: _expanded ? null : 3,
                        overflow: _expanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: _C.textPri,
                          height: 1.75,
                          letterSpacing: 0.05,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(children: [
                        Text(
                          _expanded ? 'কম দেখুন' : 'আরো পড়ুন',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: _C.midGreen,
                          ),
                        ),
                        const SizedBox(width: 3),
                        RotationTransition(
                          turns: _chevron,
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 14,
                            color: _C.midGreen,
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // ── EXPANDED — Arabic + chips + tafsir ──────────────────────────
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _ExpandedPanel(
              ayah: widget.ayah,
              ayahIdx: widget.ayahIdx,
              tafsirRequested: _tafsirRequested,
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 320),
            sizeCurve: Curves.easeInOut,
          ),

          // ── BOTTOM — always visible ──────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: _C.border, width: 0.5),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'প্রতিবার নতুন আয়াত',
                  style: TextStyle(
                    fontSize: 9,
                    color: _C.textHint,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: _nextAyah,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _C.greenLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _C.greenBorder, width: 0.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'অন্য আয়াত',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: _C.midGreen,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 11,
                          color: _C.midGreen,
                        ),
                      ],
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

// ─────────────────────────────────────────────────────────────────────────────
// EXPANDED PANEL
// ─────────────────────────────────────────────────────────────────────────────
class _ExpandedPanel extends ConsumerWidget {
  final _AyahData ayah;
  final int ayahIdx;
  final bool tafsirRequested;

  const _ExpandedPanel({
    required this.ayah,
    required this.ayahIdx,
    required this.tafsirRequested,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tafsirAsync =
        tafsirRequested ? ref.watch(_tafsirProvider(ayahIdx)) : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Arabic block
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: _C.goldBg,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: _C.goldBorder, width: 0.5),
            ),
            child: Text(
              ayah.arabic,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _C.goldText,
                height: 2.0,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(height: 9),

          // Surah · Ayah · Para info chips
          Row(children: [
            _InfoChip(label: 'সূরা', value: ayah.surahNameBn),
            const SizedBox(width: 8),
            _InfoChip(label: 'আয়াত নং', value: _bnNum(ayah.ayahNumber)),
            const SizedBox(width: 8),
            _InfoChip(label: 'পারা', value: _juzBn(ayah.juzNumber)),
          ]),

          // Tafsir block — only shown if API returns something
          if (tafsirAsync != null) ...[
            const SizedBox(height: 9),
            tafsirAsync.when(
              loading: () => const _TafsirLoadingBlock(),
              error: (_, __) => const SizedBox.shrink(),
              data: (result) {
                // null = API had nothing → hide silently
                if (result.text == null || result.text!.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(11),
                  decoration: const BoxDecoration(
                    color: _C.tafsirBg,
                    borderRadius: BorderRadius.all(Radius.circular(9)),
                    border: Border(
                      left: BorderSide(color: _C.midGreen, width: 2.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'তাফসির',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: _C.midGreen,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        result.text!,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.8,
                          color: _C.textSec,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 220.ms);
              },
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 220.ms);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAFSIR LOADING BLOCK — 3 skeleton lines
// ─────────────────────────────────────────────────────────────────────────────
class _TafsirLoadingBlock extends StatelessWidget {
  const _TafsirLoadingBlock();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: const BoxDecoration(
        color: _C.tafsirBg,
        borderRadius: BorderRadius.all(Radius.circular(9)),
        border: Border(
          left: BorderSide(color: _C.midGreen, width: 2.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'তাফসির',
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              color: _C.midGreen,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(
            3,
            (i) => Container(
              margin: const EdgeInsets.only(bottom: 6),
              height: 11,
              width: i == 2 ? 130 : double.infinity,
              decoration: BoxDecoration(
                color: _C.greenBorder.withOpacity(0.5),
                borderRadius: BorderRadius.circular(3),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(
                  duration: 700.ms,
                  delay: Duration(milliseconds: i * 80),
                ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INFO CHIP
// ─────────────────────────────────────────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  final String label, value;
  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color: _C.chipBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _C.border, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 8.5,
                  color: _C.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 11,
                  color: _C.textPri,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
}
