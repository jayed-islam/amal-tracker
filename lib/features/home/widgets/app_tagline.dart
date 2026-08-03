// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // TAGLINES — short enough to fit under the app name (max ~30 chars)
// // ─────────────────────────────────────────────────────────────────────────────

// const _taglines = [
//   'নেক আমলে এগিয়ে যাও',
//   // Quran
//   'আল্লাহ ধৈর্যশীলদের সাথে আছেন', // 2:153
//   'আমাকে স্মরণ করো, আমি করব', // 2:152
//   'আল্লাহর রহমত থেকে নিরাশ হয়ো না', // 39:53
//   'কষ্টের সাথেই স্বস্তি আছে', // 94:6
//   'সৎকাজে প্রতিযোগিতা করো', // 2:148
//   'আল্লাহ তাওবাকারীদের ভালোবাসেন', // 2:222

//   // Hadith
//   'নিয়মিত আমলই সর্বোত্তম', // Bukhari
//   'নিয়তই আমলের ভিত্তি', // Bukhari
//   'হাসিমুখে সাক্ষাৎ করাও সদকা', // Tirmizi
//   'উত্তম চরিত্রই উত্তম আমল', // Abu Dawud
// ];

// const _kTaglineIndexKey = 'sabeq_tagline_index';

// // ─────────────────────────────────────────────────────────────────────────────
// // WIDGET
// // ─────────────────────────────────────────────────────────────────────────────

// class AppTagline extends StatefulWidget {
//   final TextStyle? style;
//   const AppTagline({super.key, this.style});

//   @override
//   State<AppTagline> createState() => _AppTaglineState();
// }

// class _AppTaglineState extends State<AppTagline> {
//   late final Future<String> _taglineFuture;

//   @override
//   void initState() {
//     super.initState();
//     _taglineFuture = _resolveTagline();
//   }

//   static Future<String> _resolveTagline() async {
//     final prefs = await SharedPreferences.getInstance();
//     final index = prefs.getInt(_kTaglineIndexKey) ?? 0;
//     final tagline = _taglines[index % _taglines.length];
//     unawaited(prefs.setInt(_kTaglineIndexKey, index + 1));
//     return tagline;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<String>(
//       future: _taglineFuture,
//       initialData: _taglines[0],
//       builder: (context, snap) {
//         return AnimatedSwitcher(
//           duration: const Duration(milliseconds: 350),
//           child: Text(
//             snap.data ?? _taglines[0],
//             key: ValueKey(snap.data),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: widget.style ??
//                 const TextStyle(
//                   color: Color(0xFF8A9E8D),
//                   fontSize: 9,
//                   fontWeight: FontWeight.w500,
//                   letterSpacing: 0.2,
//                 ),
//           ),
//         );
//       },
//     );
//   }
// }

// // ignore: prefer_void_to_null
// void unawaited(Future<dynamic> future) {}
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TAGLINES — short enough to fit under the app name (max ~30 chars)
// ─────────────────────────────────────────────────────────────────────────────

const _taglines = [
  'নেক আমলে এগিয়ে যাও',
  // Quran
  'আল্লাহ ধৈর্যশীলদের সাথে আছেন', // 2:153
  'আমাকে স্মরণ করো, আমি করব', // 2:152
  'আল্লাহর রহমত থেকে নিরাশ হয়ো না', // 39:53
  'কষ্টের সাথেই স্বস্তি আছে', // 94:6
  'সৎকাজে প্রতিযোগিতা করো', // 2:148
  'আল্লাহ তাওবাকারীদের ভালোবাসেন', // 2:222

  // Hadith
  'নিয়মিত আমলই সর্বোত্তম', // Bukhari
  'নিয়তই আমলের ভিত্তি', // Bukhari
  'হাসিমুখে সাক্ষাৎ করাও সদকা', // Tirmizi
  'উত্তম চরিত্রই উত্তম আমল', // Abu Dawud
];

const _kLastTaglineIndexKey = 'sabeq_last_tagline_index';

// ─────────────────────────────────────────────────────────────────────────────
// WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class AppTagline extends StatefulWidget {
  final TextStyle? style;
  const AppTagline({super.key, this.style});

  @override
  State<AppTagline> createState() => _AppTaglineState();
}

class _AppTaglineState extends State<AppTagline> {
  late final Future<String> _taglineFuture;

  @override
  void initState() {
    super.initState();
    _taglineFuture = _resolveTagline();
  }

  /// Picks a random tagline that is guaranteed to be different from the
  /// last one shown (across app opens too, since the last index is
  /// persisted to disk). The write is awaited so it is guaranteed to be
  /// committed before this future resolves — no race with app kill.
  static Future<String> _resolveTagline() async {
    final prefs = await SharedPreferences.getInstance();
    final lastIndex = prefs.getInt(_kLastTaglineIndexKey);

    final random = Random();
    int newIndex;
    if (_taglines.length <= 1) {
      newIndex = 0;
    } else {
      do {
        newIndex = random.nextInt(_taglines.length);
      } while (newIndex == lastIndex);
    }

    await prefs.setInt(_kLastTaglineIndexKey, newIndex);
    return _taglines[newIndex];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _taglineFuture,
      builder: (context, snap) {
        final text = snap.data ?? '';
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: Text(
            text,
            key: ValueKey(text),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: widget.style ??
                const TextStyle(
                  color: Color(0xFF8A9E8D),
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
          ),
        );
      },
    );
  }
}
