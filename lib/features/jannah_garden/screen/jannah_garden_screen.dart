// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // HOW TO WIRE THIS INTO YOUR APP
// // ─────────────────────────────────────────────────────────────────────────────
// //
// // 1. Add to pubspec.yaml:
// //      flutter_animate: ^4.5.0   (already in your project)
// //
// // 2. In your tab bar / bottom nav, add a new tab:
// //      NavigationDestination(icon: Icon(Icons.landscape_rounded), label: 'জান্নাত')
// //
// // 3. In your router / shell, show JannahGardenScreen() for that tab.
// //
// // 4. Wire the real providers at the bottom of this file — replace the
// //    _mockProgressProvider with your real progressSummaryProvider data.
// //    The JannahEngine reads: totalPoints, streakDays, completionPercentage,
// //    and per-category completion from MonthlyTracker / DailyEntry.
// //
// // ─────────────────────────────────────────────────────────────────────────────

// // ─── DESIGN TOKENS ───────────────────────────────────────────────────────────

// class _C {
//   static const skyNight = Color(0xFF061018);
//   static const skyDawn = Color(0xFF0D2137);
//   static const groundDark = Color(0xFF0A2010);
//   static const groundMid = Color(0xFF0F3318);
//   static const groundLight = Color(0xFF1A5C2A);
//   static const grassTop = Color(0xFF22803A);
//   static const gold = Color(0xFFD4A843);
//   static const goldGlow = Color(0xFFFFF3CD);
//   static const riverBlue = Color(0xFF38BDF8);
//   static const riverDeep = Color(0xFF0369A1);
//   static const lightText = Color(0xFFE2F0E8);
//   static const mutedText = Color(0xFF6B9E78);
//   static const cardBg = Color(0xFF0F2318);
//   static const cardBorder = Color(0xFF1E4A2A);
//   static const unlockGold = Color(0xFFD4A843);
//   static const lockedGray = Color(0xFF2A3A2E);
//   static const white = Colors.white;
// }

// // ─── JANNAH ITEM MODEL ───────────────────────────────────────────────────────

// enum JannahItemType { tree, building, river, flower, light, bridge, palace }

// class JannahItem {
//   final String id;
//   final String nameBn;
//   final String description; // why it's here (amal connection)
//   final JannahItemType type;
//   final int requiredPoints; // auto-unlock when totalPoints >= this
//   final String? requiredAmalKey; // optional: specific amal category key
//   final String emoji;
//   final double isoX; // isometric grid position
//   final double isoY;
//   final double scale;
//   final bool isManuallyPlaceable; // user can choose WHERE to place

//   const JannahItem({
//     required this.id,
//     required this.nameBn,
//     required this.description,
//     required this.type,
//     required this.requiredPoints,
//     required this.emoji,
//     required this.isoX,
//     required this.isoY,
//     this.scale = 1.0,
//     this.requiredAmalKey,
//     this.isManuallyPlaceable = false,
//   });
// }

// // ─── ALL JANNAH ITEMS (amal-mapped) ──────────────────────────────────────────

// const List<JannahItem> kAllJannahItems = [
//   // TIER 1 — first amal
//   JannahItem(
//     id: 'seedling',
//     nameBn: 'প্রথম চারা',
//     description: 'প্রথম আমল রেকর্ড করলেই জন্ম নেয়',
//     type: JannahItemType.tree,
//     requiredPoints: 1,
//     emoji: '🌱',
//     isoX: 0.5,
//     isoY: 0.5,
//     scale: 0.9,
//   ),
//   JannahItem(
//     id: 'fajr_tree',
//     nameBn: 'ফজরের গাছ',
//     description: 'ফজর নামাজ আদায় করলে জন্মায়',
//     type: JannahItemType.tree,
//     requiredPoints: 5,
//     requiredAmalKey: 'fajr',
//     emoji: '🌳',
//     isoX: 0.25,
//     isoY: 0.4,
//     scale: 1.1,
//   ),
//   JannahItem(
//     id: 'rose_bed',
//     nameBn: 'গোলাপ বাগান',
//     description: 'সুন্নত নামাজের পুরস্কার',
//     type: JannahItemType.flower,
//     requiredPoints: 10,
//     requiredAmalKey: 'sunnah',
//     emoji: '🌹',
//     isoX: 0.75,
//     isoY: 0.4,
//     scale: 0.85,
//   ),

//   // TIER 2 — consistent practice
//   JannahItem(
//     id: 'stream',
//     nameBn: 'ঝর্ণাধারা',
//     description: 'সপ্তাহে ৫ দিন নামাজ পড়লে প্রবাহিত হয়',
//     type: JannahItemType.river,
//     requiredPoints: 20,
//     emoji: '💧',
//     isoX: 0.5,
//     isoY: 0.65,
//     scale: 1.0,
//   ),
//   JannahItem(
//     id: 'date_palm',
//     nameBn: 'খেজুর গাছ',
//     description: 'কুরআন তিলাওয়াতের পুরস্কার',
//     type: JannahItemType.tree,
//     requiredPoints: 30,
//     requiredAmalKey: 'tilawat',
//     emoji: '🌴',
//     isoX: 0.15,
//     isoY: 0.6,
//     scale: 1.2,
//   ),
//   JannahItem(
//     id: 'lantern',
//     nameBn: 'নূরের আলো',
//     description: 'জিকির ও তাসবীহের নূর',
//     type: JannahItemType.light,
//     requiredPoints: 40,
//     requiredAmalKey: 'dhikr',
//     emoji: '🪔',
//     isoX: 0.85,
//     isoY: 0.55,
//     scale: 0.9,
//   ),

//   // TIER 3 — deeper commitment
//   JannahItem(
//     id: 'cottage',
//     nameBn: 'ছোট্ট ঘর',
//     description: '১৫ দিন ধারাবাহিক আমলের পুরস্কার',
//     type: JannahItemType.building,
//     requiredPoints: 60,
//     emoji: '🏡',
//     isoX: 0.5,
//     isoY: 0.35,
//     scale: 1.15,
//     isManuallyPlaceable: true,
//   ),
//   JannahItem(
//     id: 'jasmine',
//     nameBn: 'জুঁই ফুলের বন',
//     description: 'দরুদ পাঠের সুবাস',
//     type: JannahItemType.flower,
//     requiredPoints: 70,
//     requiredAmalKey: 'darud',
//     emoji: '🌺',
//     isoX: 0.3,
//     isoY: 0.25,
//     scale: 0.9,
//   ),
//   JannahItem(
//     id: 'stone_bridge',
//     nameBn: 'পাথরের সেতু',
//     description: 'রোজার মাসের পুরস্কার',
//     type: JannahItemType.bridge,
//     requiredPoints: 80,
//     requiredAmalKey: 'siyam',
//     emoji: '🌉',
//     isoX: 0.5,
//     isoY: 0.75,
//     scale: 1.0,
//   ),

//   // TIER 4 — advanced
//   JannahItem(
//     id: 'golden_tree',
//     nameBn: 'সোনালি গাছ',
//     description: 'মাসে ৯০% আমল সম্পন্নের পুরস্কার',
//     type: JannahItemType.tree,
//     requiredPoints: 100,
//     emoji: '✨',
//     isoX: 0.7,
//     isoY: 0.25,
//     scale: 1.2,
//     isManuallyPlaceable: true,
//   ),
//   JannahItem(
//     id: 'river_full',
//     nameBn: 'স্বচ্ছ নদী',
//     description: 'কাউসারের নহর — ৩০ দিন ধারাবাহিক',
//     type: JannahItemType.river,
//     requiredPoints: 120,
//     emoji: '🌊',
//     isoX: 0.5,
//     isoY: 0.7,
//     scale: 1.3,
//   ),

//   // TIER 5 — palace
//   JannahItem(
//     id: 'palace',
//     nameBn: 'জান্নাতের মহল',
//     description: 'আপনার চূড়ান্ত পুরস্কার — ২০০ pts',
//     type: JannahItemType.palace,
//     requiredPoints: 200,
//     emoji: '🕌',
//     isoX: 0.5,
//     isoY: 0.2,
//     scale: 1.5,
//     isManuallyPlaceable: true,
//   ),
// ];

// // ─── JANNAH ENGINE (state) ────────────────────────────────────────────────────

// class JannahState {
//   final int totalPoints;
//   final int streakDays;
//   final double completionPct;
//   final Set<String> unlockedIds;
//   final Set<String> completedAmalKeys;
//   final JannahItem? selectedItem;
//   final bool showUnlockAnimation;
//   final String? newlyUnlockedId;

//   const JannahState({
//     this.totalPoints = 0,
//     this.streakDays = 0,
//     this.completionPct = 0,
//     this.unlockedIds = const {},
//     this.completedAmalKeys = const {},
//     this.selectedItem,
//     this.showUnlockAnimation = false,
//     this.newlyUnlockedId,
//   });

//   JannahState copyWith({
//     int? totalPoints,
//     int? streakDays,
//     double? completionPct,
//     Set<String>? unlockedIds,
//     Set<String>? completedAmalKeys,
//     JannahItem? selectedItem,
//     bool? showUnlockAnimation,
//     String? newlyUnlockedId,
//     bool clearSelected = false,
//     bool clearUnlock = false,
//   }) =>
//       JannahState(
//         totalPoints: totalPoints ?? this.totalPoints,
//         streakDays: streakDays ?? this.streakDays,
//         completionPct: completionPct ?? this.completionPct,
//         unlockedIds: unlockedIds ?? this.unlockedIds,
//         completedAmalKeys: completedAmalKeys ?? this.completedAmalKeys,
//         selectedItem:
//             clearSelected ? null : (selectedItem ?? this.selectedItem),
//         showUnlockAnimation: clearUnlock
//             ? false
//             : (showUnlockAnimation ?? this.showUnlockAnimation),
//         newlyUnlockedId:
//             clearUnlock ? null : (newlyUnlockedId ?? this.newlyUnlockedId),
//       );

//   List<JannahItem> get unlockedItems =>
//       kAllJannahItems.where((i) => unlockedIds.contains(i.id)).toList();

//   List<JannahItem> get nextUnlockable {
//     return kAllJannahItems
//         .where((i) =>
//             !unlockedIds.contains(i.id) &&
//             (i.requiredPoints <= totalPoints + 50))
//         .take(3)
//         .toList();
//   }

//   JannahItem? get nextItem {
//     final locked = kAllJannahItems
//         .where((i) => !unlockedIds.contains(i.id))
//         .toList()
//       ..sort((a, b) => a.requiredPoints.compareTo(b.requiredPoints));
//     return locked.isEmpty ? null : locked.first;
//   }

//   int get nextRequiredPoints => nextItem?.requiredPoints ?? 999;
//   int get pointsToNext => math.max(0, nextRequiredPoints - totalPoints);
//   double get progressToNext {
//     final next = nextItem;
//     if (next == null) return 1.0;
//     final prev = kAllJannahItems
//         .where((i) =>
//             i.requiredPoints < next.requiredPoints &&
//             unlockedIds.contains(i.id))
//         .fold<int>(0, (m, i) => math.max(m, i.requiredPoints));
//     final range = next.requiredPoints - prev;
//     if (range <= 0) return 1.0;
//     return ((totalPoints - prev) / range).clamp(0.0, 1.0);
//   }
// }

// class JannahNotifier extends StateNotifier<JannahState> {
//   JannahNotifier() : super(const JannahState()) {
//     // Demo data — replace with real provider data
//     _loadFromProgress(
//       totalPoints: 62,
//       streakDays: 8,
//       completionPct: 0.72,
//       completedAmalKeys: {
//         'fajr',
//         'zuhr',
//         'asr',
//         'maghrib',
//         'isha',
//         'tilawat',
//         'dhikr'
//       },
//     );
//   }

//   // ── Call this from your progressSummaryProvider watcher ──────────────────
//   // Example in your screen:
//   //   ref.listen(progressSummaryProvider, (_, next) {
//   //     next.whenData((summary) {
//   //       ref.read(jannahProvider.notifier).syncFromProgress(
//   //         totalPoints: summary.currentMonth?.totalPoints ?? 0,
//   //         streakDays: summary.currentMonth?.streakDays ?? 0,
//   //         completionPct: (summary.currentMonth?.completionPercentage ?? 0) / 100,
//   //         completedAmalKeys: _extractAmalKeys(summary.todayEntry),
//   //       );
//   //     });
//   //   });
//   void syncFromProgress({
//     required int totalPoints,
//     required int streakDays,
//     required double completionPct,
//     required Set<String> completedAmalKeys,
//   }) {
//     _loadFromProgress(
//       totalPoints: totalPoints,
//       streakDays: streakDays,
//       completionPct: completionPct,
//       completedAmalKeys: completedAmalKeys,
//     );
//   }

//   void _loadFromProgress({
//     required int totalPoints,
//     required int streakDays,
//     required double completionPct,
//     required Set<String> completedAmalKeys,
//   }) {
//     final previousUnlocked = state.unlockedIds;
//     final newUnlocked = <String>{};

//     for (final item in kAllJannahItems) {
//       final pointsOk = totalPoints >= item.requiredPoints;
//       final amalOk = item.requiredAmalKey == null ||
//           completedAmalKeys.contains(item.requiredAmalKey);
//       if (pointsOk && amalOk) newUnlocked.add(item.id);
//     }

//     final brandNew = newUnlocked.difference(previousUnlocked);

//     state = state.copyWith(
//       totalPoints: totalPoints,
//       streakDays: streakDays,
//       completionPct: completionPct,
//       unlockedIds: newUnlocked,
//       completedAmalKeys: completedAmalKeys,
//       showUnlockAnimation: brandNew.isNotEmpty,
//       newlyUnlockedId: brandNew.isNotEmpty ? brandNew.first : null,
//     );
//   }

//   void selectItem(JannahItem item) =>
//       state = state.copyWith(selectedItem: item);

//   void clearSelection() => state = state.copyWith(clearSelected: true);

//   void clearUnlock() => state = state.copyWith(clearUnlock: true);
// }

// final jannahProvider =
//     StateNotifierProvider<JannahNotifier, JannahState>((ref) {
//   return JannahNotifier();
//   // Wire real data:
//   // final notifier = JannahNotifier();
//   // ref.listen(progressSummaryProvider, (_, next) {
//   //   next.whenData((s) => notifier.syncFromProgress(...));
//   // });
//   // return notifier;
// });

// // ─── MAIN SCREEN ─────────────────────────────────────────────────────────────

// class JannahGardenScreen extends ConsumerStatefulWidget {
//   const JannahGardenScreen({super.key});

//   @override
//   ConsumerState<JannahGardenScreen> createState() => _JannahGardenScreenState();
// }

// class _JannahGardenScreenState extends ConsumerState<JannahGardenScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _ambientCtrl; // slow floating of stars
//   late AnimationController _riverCtrl; // river shimmer
//   late AnimationController _unlockCtrl; // unlock burst

//   double _scale = 1.0;
//   Offset _pan = Offset.zero;
//   double _baseScale = 1.0;
//   Offset _basePan = Offset.zero;

//   @override
//   void initState() {
//     super.initState();
//     _ambientCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 6),
//     )..repeat(reverse: true);
//     _riverCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     )..repeat();
//     _unlockCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );
//   }

//   @override
//   void dispose() {
//     _ambientCtrl.dispose();
//     _riverCtrl.dispose();
//     _unlockCtrl.dispose();
//     super.dispose();
//   }

//   void _onItemTap(JannahItem item, JannahState state) {
//     if (!state.unlockedIds.contains(item.id)) {
//       _showLockedSheet(item);
//       return;
//     }
//     ref.read(jannahProvider.notifier).selectItem(item);
//     _showItemSheet(item);
//     HapticFeedback.mediumImpact();
//   }

//   void _showLockedSheet(JannahItem item) {
//     HapticFeedback.selectionClick();
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _LockedItemSheet(item: item),
//     );
//   }

//   void _showItemSheet(JannahItem item) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _UnlockedItemSheet(item: item),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(jannahProvider);
//     final size = MediaQuery.of(context).size;

//     // Trigger unlock animation
//     if (state.showUnlockAnimation) {
//       _unlockCtrl.forward(from: 0);
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ref.read(jannahProvider.notifier).clearUnlock();
//         if (state.newlyUnlockedId != null) {
//           final item = kAllJannahItems.firstWhere(
//               (i) => i.id == state.newlyUnlockedId,
//               orElse: () => kAllJannahItems.first);
//           _showNewUnlockDialog(item);
//         }
//       });
//     }

//     return Scaffold(
//       backgroundColor: _C.skyNight,
//       body: Stack(children: [
//         // ── Sky + Stars background ──────────────────────────────────────
//         _SkyBackground(controller: _ambientCtrl),

//         // ── Garden canvas — pinch/pan ───────────────────────────────────
//         GestureDetector(
//           onScaleStart: (d) {
//             _baseScale = _scale;
//             _basePan = _pan;
//           },
//           onScaleUpdate: (d) {
//             setState(() {
//               _scale = (_baseScale * d.scale).clamp(0.7, 2.5);
//               _pan = _basePan + d.focalPointDelta;
//             });
//           },
//           child: Transform(
//             transform: Matrix4.identity()
//               ..translate(_pan.dx, _pan.dy)
//               ..scale(_scale),
//             alignment: Alignment.center,
//             child: SizedBox(
//               width: size.width,
//               height: size.height,
//               child: _IsoGardenCanvas(
//                 state: state,
//                 riverCtrl: _riverCtrl,
//                 ambientCtrl: _ambientCtrl,
//                 onItemTap: (item) => _onItemTap(item, state),
//               ),
//             ),
//           ),
//         ),

//         // ── Top HUD ─────────────────────────────────────────────────────
//         SafeArea(child: _TopHUD(state: state)),

//         // ── Bottom progress bar ──────────────────────────────────────────
//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           child: _BottomProgressBar(state: state),
//         ),

//         // ── Unlock burst overlay ─────────────────────────────────────────
//         if (state.showUnlockAnimation) _UnlockBurst(controller: _unlockCtrl),
//       ]),
//     );
//   }

//   void _showNewUnlockDialog(JannahItem item) {
//     showDialog(
//       context: context,
//       barrierColor: Colors.black87,
//       builder: (_) => _UnlockDialog(item: item),
//     );
//   }
// }

// // ─── SKY BACKGROUND ──────────────────────────────────────────────────────────

// class _SkyBackground extends StatelessWidget {
//   final AnimationController controller;
//   const _SkyBackground({required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: controller,
//       builder: (_, __) {
//         return Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 _C.skyNight,
//                 Color.lerp(_C.skyNight, _C.skyDawn, controller.value * 0.3)!,
//                 _C.groundDark,
//               ],
//               stops: const [0, 0.5, 1],
//             ),
//           ),
//           child: CustomPaint(painter: _StarsPainter(controller.value)),
//         );
//       },
//     );
//   }
// }

// class _StarsPainter extends CustomPainter {
//   final double t;
//   _StarsPainter(this.t);

//   static final _rng = math.Random(42);
//   static final _stars = List.generate(
//       60,
//       (i) => [
//             _rng.nextDouble(), // x
//             _rng.nextDouble() * 0.45, // y (upper half)
//             _rng.nextDouble() * 1.8 + 0.4, // radius
//             _rng.nextDouble() * math.pi * 2, // phase
//           ]);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = Colors.white;
//     for (final s in _stars) {
//       final opacity = 0.3 + 0.5 * math.sin(s[3] + t * math.pi);
//       paint.color = Colors.white.withOpacity(opacity.clamp(0.1, 0.9));
//       canvas.drawCircle(
//         Offset(s[0] * size.width, s[1] * size.height),
//         s[2],
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(_StarsPainter old) => old.t != t;
// }

// // ─── ISOMETRIC GARDEN CANVAS ─────────────────────────────────────────────────

// class _IsoGardenCanvas extends StatelessWidget {
//   final JannahState state;
//   final AnimationController riverCtrl;
//   final AnimationController ambientCtrl;
//   final void Function(JannahItem) onItemTap;

//   const _IsoGardenCanvas({
//     required this.state,
//     required this.riverCtrl,
//     required this.ambientCtrl,
//     required this.onItemTap,
//   });

//   // Convert logical iso coords (0..1) to screen position
//   Offset _toScreen(double isoX, double isoY, Size size) {
//     // Ground occupies middle 60% of screen height
//     final gTop = size.height * 0.28;
//     final gBottom = size.height * 0.82;
//     final gHeight = gBottom - gTop;

//     final sx = size.width * 0.1 + isoX * size.width * 0.8;
//     final sy = gTop + isoY * gHeight;
//     return Offset(sx, sy);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Stack(children: [
//       // Ground plane
//       Positioned(
//         top: size.height * 0.35,
//         left: 0,
//         right: 0,
//         bottom: 0,
//         child: _GroundPlane(),
//       ),

//       // River (always visible once unlocked, animated)
//       if (state.unlockedIds.contains('stream') ||
//           state.unlockedIds.contains('river_full'))
//         AnimatedBuilder(
//           animation: riverCtrl,
//           builder: (_, __) => Positioned(
//             top: size.height * 0.52,
//             left: size.width * 0.15,
//             right: size.width * 0.15,
//             child: _RiverWidget(
//                 t: riverCtrl.value,
//                 isFullRiver: state.unlockedIds.contains('river_full')),
//           ),
//         ),

//       // All garden items
//       ...kAllJannahItems.map((item) {
//         final pos = _toScreen(item.isoX, item.isoY, size);
//         final isUnlocked = state.unlockedIds.contains(item.id);
//         return Positioned(
//           left: pos.dx - 30 * item.scale,
//           top: pos.dy - 45 * item.scale,
//           child: GestureDetector(
//             onTap: () => onItemTap(item),
//             child: _GardenItemWidget(
//               item: item,
//               isUnlocked: isUnlocked,
//               ambientCtrl: ambientCtrl,
//               pointsNeeded: item.requiredPoints - state.totalPoints,
//             ),
//           ),
//         );
//       }),
//     ]);
//   }
// }

// // ─── GROUND PLANE ────────────────────────────────────────────────────────────

// class _GroundPlane extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [_C.grassTop, _C.groundMid, _C.groundDark],
//           stops: const [0, 0.4, 1],
//         ),
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
//       ),
//     );
//   }
// }

// // ─── RIVER WIDGET ────────────────────────────────────────────────────────────

// class _RiverWidget extends StatelessWidget {
//   final double t;
//   final bool isFullRiver;

//   const _RiverWidget({required this.t, required this.isFullRiver});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: isFullRiver ? 22 : 12,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(99),
//         gradient: LinearGradient(
//           colors: [
//             _C.riverBlue.withOpacity(0.3),
//             _C.riverBlue.withOpacity(0.7 + 0.2 * math.sin(t * math.pi * 2)),
//             _C.riverBlue.withOpacity(0.3),
//           ],
//         ),
//         border: Border.all(
//           color: _C.riverBlue.withOpacity(0.5),
//           width: 0.5,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: _C.riverBlue.withOpacity(0.3),
//             blurRadius: 8 + 4 * math.sin(t * math.pi * 2),
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── GARDEN ITEM WIDGET ───────────────────────────────────────────────────────

// class _GardenItemWidget extends StatelessWidget {
//   final JannahItem item;
//   final bool isUnlocked;
//   final AnimationController ambientCtrl;
//   final int pointsNeeded;

//   const _GardenItemWidget({
//     required this.item,
//     required this.isUnlocked,
//     required this.ambientCtrl,
//     required this.pointsNeeded,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (!isUnlocked) {
//       // Locked: silhouette + lock badge
//       return Opacity(
//         opacity: pointsNeeded <= 30 ? 0.4 : 0.15, // nearly there = more visible
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Text(
//               item.emoji,
//               style: TextStyle(
//                 fontSize: 32 * item.scale,
//                 color: const Color(0xFF1A3A22),
//               ),
//             ),
//             if (pointsNeeded <= 30)
//               Positioned(
//                 top: -8,
//                 right: -12,
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: _C.gold.withOpacity(0.9),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     '+$pointsNeeded',
//                     style: const TextStyle(
//                       color: Colors.black,
//                       fontSize: 8,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       );
//     }

//     // Unlocked: glowing, floating
//     return AnimatedBuilder(
//       animation: ambientCtrl,
//       builder: (_, __) {
//         final float = math.sin(ambientCtrl.value * math.pi) * 3.0;
//         final isSpecial = item.type == JannahItemType.palace ||
//             item.type == JannahItemType.building;

//         return Transform.translate(
//           offset: Offset(0, float * (item.scale - 0.5)),
//           child: Stack(
//             clipBehavior: Clip.none,
//             alignment: Alignment.center,
//             children: [
//               // Glow halo for palace/buildings
//               if (isSpecial)
//                 Container(
//                   width: 50 * item.scale,
//                   height: 20 * item.scale,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.circular(99),
//                     color: _C.gold.withOpacity(
//                         0.15 + 0.08 * math.sin(ambientCtrl.value * math.pi)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: _C.gold.withOpacity(0.2),
//                         blurRadius: 12,
//                         spreadRadius: 4,
//                       ),
//                     ],
//                   ),
//                 ),
//               Text(
//                 item.emoji,
//                 style: TextStyle(
//                   fontSize: 32 * item.scale,
//                   shadows: isSpecial
//                       ? [
//                           Shadow(
//                             color: _C.gold.withOpacity(0.6),
//                             blurRadius: 16,
//                           ),
//                         ]
//                       : null,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// // ─── TOP HUD ─────────────────────────────────────────────────────────────────

// class _TopHUD extends StatelessWidget {
//   final JannahState state;
//   const _TopHUD({required this.state});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
//       child: Row(
//         children: [
//           // Title
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'আমার জান্নাত',
//                   style: const TextStyle(
//                     color: _C.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: -0.3,
//                   ),
//                 ),
//                 Text(
//                   '${state.unlockedIds.length} / ${kAllJannahItems.length} টি উন্মুক্ত',
//                   style: const TextStyle(color: _C.mutedText, fontSize: 11),
//                 ),
//               ],
//             ),
//           ),

//           // Streak pill
//           _HUDPill(
//             emoji: '🔥',
//             value: '${state.streakDays}',
//             label: 'দিন',
//             color: const Color(0xFFFF6B35),
//           ),
//           const SizedBox(width: 8),

//           // Points pill
//           _HUDPill(
//             emoji: '✦',
//             value: '${state.totalPoints}',
//             label: 'pts',
//             color: _C.gold,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _HUDPill extends StatelessWidget {
//   final String emoji, value, label;
//   final Color color;

//   const _HUDPill({
//     required this.emoji,
//     required this.value,
//     required this.label,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: _C.cardBg.withOpacity(0.9),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color.withOpacity(0.4), width: 0.5),
//       ),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [
//         Text(emoji, style: const TextStyle(fontSize: 12)),
//         const SizedBox(width: 4),
//         Text(
//           value,
//           style: TextStyle(
//               color: color, fontSize: 13, fontWeight: FontWeight.w700),
//         ),
//         Text(
//           ' $label',
//           style: const TextStyle(color: _C.mutedText, fontSize: 10),
//         ),
//       ]),
//     );
//   }
// }

// // ─── BOTTOM PROGRESS BAR ─────────────────────────────────────────────────────

// class _BottomProgressBar extends ConsumerWidget {
//   final JannahState state;
//   const _BottomProgressBar({required this.state});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final next = state.nextItem;
//     final progress = state.progressToNext;
//     final bottomPad = MediaQuery.of(context).padding.bottom;

//     return Container(
//       padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPad + 12),
//       decoration: BoxDecoration(
//         color: _C.cardBg.withOpacity(0.95),
//         border: Border(top: BorderSide(color: _C.cardBorder, width: 0.5)),
//       ),
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         if (next != null) ...[
//           Row(children: [
//             Text(next.emoji, style: const TextStyle(fontSize: 20)),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         next.nameBn,
//                         style: const TextStyle(
//                           color: _C.lightText,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Text(
//                         'আরও ${state.pointsToNext} pts',
//                         style: const TextStyle(
//                           color: _C.gold,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 5),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(99),
//                     child: LinearProgressIndicator(
//                       value: progress,
//                       minHeight: 5,
//                       backgroundColor: _C.cardBorder,
//                       valueColor: const AlwaysStoppedAnimation<Color>(_C.gold),
//                     ),
//                   ),
//                   const SizedBox(height: 3),
//                   Text(
//                     next.description,
//                     style: const TextStyle(color: _C.mutedText, fontSize: 10),
//                   ),
//                 ],
//               ),
//             ),
//           ]),
//         ] else ...[
//           const Text(
//             'মাশাআল্লাহ! সব উন্মুক্ত হয়ে গেছে 🌟',
//             style: TextStyle(color: _C.gold, fontSize: 13),
//           ),
//         ],
//       ]),
//     );
//   }
// }

// // ─── LOCKED ITEM SHEET ────────────────────────────────────────────────────────

// class _LockedItemSheet extends StatelessWidget {
//   final JannahItem item;
//   const _LockedItemSheet({required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _C.cardBg,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: _C.cardBorder, width: 0.5),
//       ),
//       padding: const EdgeInsets.all(20),
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         Container(
//           width: 70,
//           height: 70,
//           decoration: BoxDecoration(
//             color: _C.lockedGray,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Center(
//             child: Text(
//               item.emoji,
//               style: const TextStyle(fontSize: 32),
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),
//         Text(
//           item.nameBn,
//           style: const TextStyle(
//             color: _C.lightText,
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         const SizedBox(height: 6),
//         Text(
//           item.description,
//           textAlign: TextAlign.center,
//           style: const TextStyle(color: _C.mutedText, fontSize: 13),
//         ),
//         const SizedBox(height: 16),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           decoration: BoxDecoration(
//             color: _C.gold.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: _C.gold.withOpacity(0.3), width: 0.5),
//           ),
//           child: Row(mainAxisSize: MainAxisSize.min, children: [
//             const Icon(Icons.lock_outline_rounded, color: _C.gold, size: 16),
//             const SizedBox(width: 8),
//             Text(
//               '${item.requiredPoints} pts হলে আনলক হবে',
//               style: const TextStyle(
//                 color: _C.gold,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ]),
//         ),
//         if (item.requiredAmalKey != null) ...[
//           const SizedBox(height: 8),
//           Text(
//             'এবং "${item.requiredAmalKey}" আমল সম্পন্ন করতে হবে',
//             style: const TextStyle(color: _C.mutedText, fontSize: 11),
//           ),
//         ],
//         const SizedBox(height: 8),
//       ]),
//     );
//   }
// }

// // ─── UNLOCKED ITEM SHEET ──────────────────────────────────────────────────────

// class _UnlockedItemSheet extends StatelessWidget {
//   final JannahItem item;
//   const _UnlockedItemSheet({required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _C.cardBg,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: _C.cardBorder, width: 0.5),
//       ),
//       padding: const EdgeInsets.all(20),
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         Text(item.emoji, style: const TextStyle(fontSize: 52))
//             .animate()
//             .scale(begin: const Offset(0.5, 0.5), curve: Curves.elasticOut)
//             .fadeIn(),
//         const SizedBox(height: 12),
//         Text(
//           item.nameBn,
//           style: const TextStyle(
//             color: _C.white,
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         const SizedBox(height: 6),
//         Text(
//           item.description,
//           textAlign: TextAlign.center,
//           style: const TextStyle(color: _C.mutedText, fontSize: 13),
//         ),
//         const SizedBox(height: 16),
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: const Color(0xFF0A2010),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: _C.cardBorder),
//           ),
//           child: Row(children: [
//             const Icon(Icons.check_circle_rounded,
//                 color: Color(0xFF16A34A), size: 18),
//             const SizedBox(width: 8),
//             Text(
//               'আপনি এই আমল করে এটি অর্জন করেছেন',
//               style: TextStyle(
//                 color: const Color(0xFF16A34A).withOpacity(0.9),
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ]),
//         ),
//         const SizedBox(height: 8),
//       ]),
//     );
//   }
// }

// // ─── UNLOCK DIALOG ────────────────────────────────────────────────────────────

// class _UnlockDialog extends StatelessWidget {
//   final JannahItem item;
//   const _UnlockDialog({required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: Container(
//         decoration: BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.circular(24),
//           border: Border.all(color: _C.gold.withOpacity(0.4), width: 1),
//         ),
//         padding: const EdgeInsets.all(24),
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           Text(item.emoji, style: const TextStyle(fontSize: 60))
//               .animate()
//               .scale(
//                   begin: const Offset(0, 0),
//                   curve: Curves.elasticOut,
//                   duration: 600.ms)
//               .fadeIn(),
//           const SizedBox(height: 8),
//           const Text(
//             'নতুন উন্মোচন!',
//             style: TextStyle(color: _C.gold, fontSize: 13, letterSpacing: 1),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             item.nameBn,
//             style: const TextStyle(
//               color: _C.white,
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             item.description,
//             textAlign: TextAlign.center,
//             style: const TextStyle(color: _C.mutedText, fontSize: 13),
//           ),
//           const SizedBox(height: 20),
//           GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 13),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF0E3D22),
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: const Center(
//                 child: Text(
//                   'আলহামদুলিল্লাহ 🌟',
//                   style: TextStyle(
//                     color: _C.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }

// // ─── UNLOCK BURST (particle overlay) ─────────────────────────────────────────

// class _UnlockBurst extends StatelessWidget {
//   final AnimationController controller;
//   const _UnlockBurst({required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: controller,
//       builder: (_, __) {
//         if (controller.value == 0 || controller.value == 1) {
//           return const SizedBox.shrink();
//         }
//         return IgnorePointer(
//           child: CustomPaint(
//             size: MediaQuery.of(context).size,
//             painter: _BurstPainter(controller.value),
//           ),
//         );
//       },
//     );
//   }
// }

// class _BurstPainter extends CustomPainter {
//   final double t;
//   _BurstPainter(this.t);

//   static final _rng = math.Random(7);
//   static final _particles = List.generate(
//       20,
//       (i) => [
//             (_rng.nextDouble() - 0.5) * 2, // dx direction
//             (_rng.nextDouble() - 0.5) * 2, // dy direction
//             _rng.nextDouble(), // hue offset
//           ]);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final paint = Paint();
//     for (final p in _particles) {
//       final dist = t * 200;
//       final opacity = (1 - t).clamp(0.0, 1.0);
//       final pos = center + Offset(p[0] * dist, p[1] * dist);
//       paint.color = _C.gold.withOpacity(opacity * 0.8);
//       canvas.drawCircle(pos, 4 * (1 - t * 0.5), paint);
//     }
//   }

//   @override
//   bool shouldRepaint(_BurstPainter old) => old.t != t;
// }
// ═══════════════════════════════════════════════════════════════════════════
// jannah_garden_screen.dart
//
// SETUP:
//   1. Drop this file into lib/features/jannah/ (or wherever you prefer)
//   2. Add the tab to your shell's NavigationDestination list:
//        NavigationDestination(icon: Icon(Icons.landscape_rounded), label: 'জান্নাত')
//   3. Show JannahGardenScreen() for that tab index in your shell body.
//   4. No extra packages needed — flutter_animate + flutter_riverpod already in project.
//
// DATA FLOW (fully real — zero mock/static data):
//   progressSummaryProvider  ──▶ totalPoints, streakDays, completionPct, todayEntry
//   categoriesProvider       ──▶ category keys (fajr, tilawat, dhikr …)
//   todayEntry.entries       ──▶ which amal keys were actually completed today
//
//   JannahEngine reads all of the above and auto-unlocks garden items.
//   Nothing is hardcoded — add/remove items from kAllJannahItems at will.
// ═══════════════════════════════════════════════════════════════════════════

// import 'dart:math' as math;
// import 'package:amal_tracker/features/tracker/models/tracker_model.dart';
// import 'package:amal_tracker/features/tracker/providers/tracker_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // ─── DESIGN TOKENS ────────────────────────────────────────────────────────────

// class _C {
//   static const skyNight = Color(0xFF040E0A);
//   static const skyDawn = Color(0xFF091A10);
//   static const groundDark = Color(0xFF061209);
//   static const groundMid = Color(0xFF0D2E14);
//   static const grassTop = Color(0xFF1A5C2A);
//   static const gold = Color(0xFFD4A843);
//   static const goldDim = Color(0xFF6B5220);
//   static const riverBlue = Color(0xFF38BDF8);
//   static const lightText = Color(0xFFD4EAD8);
//   static const mutedText = Color(0xFF4A7A56);
//   static const cardBg = Color(0xFF0A1E0E);
//   static const cardBorder = Color(0xFF163320);
//   static const white = Colors.white;
//   static const green = Color(0xFF16A34A);
// }

// // ─── JANNAH ITEM DEFINITION ───────────────────────────────────────────────────
// //
// // Each item maps to REAL amal data:
// //   requiredPoints   → MonthlyTracker.totalPoints (cumulative this month)
// //   requiredAmalKey  → AmalCategory.key (must appear in today's completed entries)
// //   requiredStreak   → MonthlyTracker.streakDays
// //   requiredPct      → MonthlyTracker.completionPercentage (0–100)
// //
// // All conditions are AND-ed. Leave a field null to skip that check.

// enum _ItemTier { one, two, three, four, five }

// class JannahItem {
//   final String id;
//   final String nameBn;
//   final String descriptionBn; // shown in detail sheet
//   final String amalConnectionBn; // "কীভাবে পাবেন" label
//   final String emoji;
//   final _ItemTier tier;

//   // Unlock conditions — ALL non-null conditions must be true
//   final int? requiredPoints;
//   final String? requiredAmalKey; // category.key from backend
//   final int? requiredStreak;
//   final double? requiredPct; // 0–100

//   // Canvas placement (0.0 – 1.0 of ground area)
//   final double gx; // x within ground (0=left, 1=right)
//   final double gy; // y within ground (0=top, 1=bottom)
//   final double scale;

//   const JannahItem({
//     required this.id,
//     required this.nameBn,
//     required this.descriptionBn,
//     required this.amalConnectionBn,
//     required this.emoji,
//     required this.tier,
//     this.requiredPoints,
//     this.requiredAmalKey,
//     this.requiredStreak,
//     this.requiredPct,
//     required this.gx,
//     required this.gy,
//     this.scale = 1.0,
//   });
// }

// // ─── ALL GARDEN ITEMS ─────────────────────────────────────────────────────────
// // Edit this list freely — the engine handles everything automatically.

// const List<JannahItem> kJannahItems = [
//   // ── TIER 1 : first steps (pts 1–15) ─────────────────────────────────────
//   JannahItem(
//     id: 'seedling',
//     nameBn: 'প্রথম চারা',
//     descriptionBn: 'আপনার প্রথম আমল রেকর্ড হওয়ার সাথে সাথে এই চারা জন্ম নেয়।',
//     amalConnectionBn: 'যেকোনো ১ টি আমল সম্পন্ন করুন',
//     emoji: '🌱',
//     tier: _ItemTier.one,
//     requiredPoints: 1,
//     gx: 0.50,
//     gy: 0.55,
//     scale: 0.85,
//   ),
//   JannahItem(
//     id: 'fajr_tree',
//     nameBn: 'ফজরের গাছ',
//     descriptionBn:
//         'ফজরের নামাজের নূর এই গাছকে বাঁচিয়ে রাখে। প্রতিদিন ফজর পড়লে গাছটি বড় হয়।',
//     amalConnectionBn: 'ফজর নামাজ আদায় করুন',
//     emoji: '🌳',
//     tier: _ItemTier.one,
//     requiredPoints: 5,
//     requiredAmalKey: 'fajr',
//     gx: 0.20,
//     gy: 0.40,
//     scale: 1.1,
//   ),
//   JannahItem(
//     id: 'rose_bed',
//     nameBn: 'সুন্নতের গোলাপ',
//     descriptionBn: 'সুন্নত নামাজের সৌরভ এই গোলাপে ধরা আছে।',
//     amalConnectionBn: 'যেকোনো সুন্নত নামাজ আদায় করুন',
//     emoji: '🌹',
//     tier: _ItemTier.one,
//     requiredPoints: 8,
//     requiredAmalKey: 'sunnah_fajr',
//     gx: 0.80,
//     gy: 0.42,
//     scale: 0.85,
//   ),

//   // ── TIER 2 : consistent practice (pts 15–50) ─────────────────────────────
//   JannahItem(
//     id: 'stream',
//     nameBn: 'ঝর্ণাধারা',
//     descriptionBn:
//         'পাঁচ ওয়াক্ত নামাজ ধারাবাহিকভাবে পড়লে জান্নাতে নহর প্রবাহিত হয়।',
//     amalConnectionBn: '১৫ pts অর্জন করুন',
//     emoji: '💧',
//     tier: _ItemTier.two,
//     requiredPoints: 15,
//     gx: 0.50,
//     gy: 0.68,
//     scale: 1.0,
//   ),
//   JannahItem(
//     id: 'date_palm',
//     nameBn: 'তিলাওয়াতের খেজুর গাছ',
//     descriptionBn: 'প্রতিটি আয়াত তিলাওয়াতে এই গাছে একটি ফল যোগ হয়।',
//     amalConnectionBn: 'কুরআন তিলাওয়াত করুন',
//     emoji: '🌴',
//     tier: _ItemTier.two,
//     requiredPoints: 20,
//     requiredAmalKey: 'tilawat',
//     gx: 0.12,
//     gy: 0.58,
//     scale: 1.15,
//   ),
//   JannahItem(
//     id: 'lantern',
//     nameBn: 'জিকিরের আলো',
//     descriptionBn: 'প্রতিটি তাসবীহ-জিকির এই প্রদীপকে জ্বালিয়ে রাখে।',
//     amalConnectionBn: 'জিকির ও তাসবীহ করুন',
//     emoji: '🪔',
//     tier: _ItemTier.two,
//     requiredPoints: 28,
//     requiredAmalKey: 'tasbih',
//     gx: 0.88,
//     gy: 0.50,
//     scale: 0.90,
//   ),
//   JannahItem(
//     id: 'jasmine',
//     nameBn: 'দরুদের জুঁই',
//     descriptionBn: 'নবীজির উপর দরুদ পড়লে জান্নাতে সুবাস ছড়িয়ে পড়ে।',
//     amalConnectionBn: 'দরুদ পড়ুন',
//     emoji: '🌸',
//     tier: _ItemTier.two,
//     requiredPoints: 35,
//     requiredAmalKey: 'darud',
//     gx: 0.70,
//     gy: 0.35,
//     scale: 0.90,
//   ),

//   // ── TIER 3 : deepening (pts 50–100) ──────────────────────────────────────
//   JannahItem(
//     id: 'cottage',
//     nameBn: 'আমলের ঘর',
//     descriptionBn: '১০ দিন ধারাবাহিক আমল করলে এই ঘর তৈরি হয়।',
//     amalConnectionBn: '১০ দিনের streak ধরে রাখুন',
//     emoji: '🏡',
//     tier: _ItemTier.three,
//     requiredPoints: 50,
//     requiredStreak: 10,
//     gx: 0.50,
//     gy: 0.32,
//     scale: 1.15,
//   ),
//   JannahItem(
//     id: 'stone_bridge',
//     nameBn: 'সবরের সেতু',
//     descriptionBn: 'রোজা ও সংযমের পুরস্কার — পুলসিরাতের প্রস্তুতি।',
//     amalConnectionBn: 'রোজা রাখুন',
//     emoji: '🌉',
//     tier: _ItemTier.three,
//     requiredPoints: 65,
//     requiredAmalKey: 'siyam',
//     gx: 0.50,
//     gy: 0.75,
//     scale: 1.0,
//   ),
//   JannahItem(
//     id: 'river_full',
//     nameBn: 'কাউসারের নহর',
//     descriptionBn: 'মাসে ৭০% আমল সম্পন্ন করলে কাউসার নদী প্রবাহিত হয়।',
//     amalConnectionBn: 'মাসে ৭০%+ আমল করুন',
//     emoji: '🌊',
//     tier: _ItemTier.three,
//     requiredPoints: 80,
//     requiredPct: 70,
//     gx: 0.50,
//     gy: 0.72,
//     scale: 1.3,
//   ),

//   // ── TIER 4 : excellence (pts 100–180) ────────────────────────────────────
//   JannahItem(
//     id: 'golden_tree',
//     nameBn: 'সোনালি গাছ (তুবা)',
//     descriptionBn: 'মাসে ৯০% আমল সম্পন্ন করলে তুবা গাছের একটি শাখা জন্মায়।',
//     amalConnectionBn: 'মাসে ৯০%+ আমল সম্পন্ন করুন',
//     emoji: '✨',
//     tier: _ItemTier.four,
//     requiredPoints: 110,
//     requiredPct: 90,
//     gx: 0.72,
//     gy: 0.28,
//     scale: 1.2,
//   ),
//   JannahItem(
//     id: 'night_pray',
//     nameBn: 'তাহাজ্জুদের চাঁদ',
//     descriptionBn: 'তাহাজ্জুদ নামাজ পড়লে আকাশে এই চাঁদ উদিত হয়।',
//     amalConnectionBn: 'তাহাজ্জুদ নামাজ আদায় করুন',
//     emoji: '🌙',
//     tier: _ItemTier.four,
//     requiredPoints: 130,
//     requiredAmalKey: 'tahajjud',
//     gx: 0.30,
//     gy: 0.18,
//     scale: 1.0,
//   ),
//   JannahItem(
//     id: 'charity_fountain',
//     nameBn: 'সদকার ফোয়ারা',
//     descriptionBn: 'দান-সদকা করলে জান্নাতে এই ফোয়ারা প্রবাহিত হয়।',
//     amalConnectionBn: 'সদকা করুন',
//     emoji: '⛲',
//     tier: _ItemTier.four,
//     requiredPoints: 150,
//     requiredAmalKey: 'sadaqah',
//     gx: 0.20,
//     gy: 0.25,
//     scale: 1.0,
//   ),

//   // ── TIER 5 : palace (pts 180+) ───────────────────────────────────────────
//   JannahItem(
//     id: 'palace',
//     nameBn: 'জান্নাতের মহল',
//     descriptionBn:
//         'আপনার সমস্ত আমলের পুরস্কার — আল্লাহর রহমতে নির্মিত আপনার মহল।',
//     amalConnectionBn: '২০০ pts + ১৫ দিনের streak',
//     emoji: '🕌',
//     tier: _ItemTier.five,
//     requiredPoints: 200,
//     requiredStreak: 15,
//     gx: 0.50,
//     gy: 0.20,
//     scale: 1.5,
//   ),
// ];

// // ─── JANNAH STATE ──────────────────────────────────────────────────────────────

// class JannahState {
//   final bool isLoading;
//   final int totalPoints;
//   final int streakDays;
//   final double completionPct; // 0–100
//   final Set<String> completedKeys; // AmalCategory.key values done today
//   final Set<String> unlockedIds;
//   final String? newlyUnlockedId;

//   const JannahState({
//     this.isLoading = true,
//     this.totalPoints = 0,
//     this.streakDays = 0,
//     this.completionPct = 0,
//     this.completedKeys = const {},
//     this.unlockedIds = const {},
//     this.newlyUnlockedId,
//   });

//   JannahState copyWith({
//     bool? isLoading,
//     int? totalPoints,
//     int? streakDays,
//     double? completionPct,
//     Set<String>? completedKeys,
//     Set<String>? unlockedIds,
//     String? newlyUnlockedId,
//     bool clearNewUnlock = false,
//   }) =>
//       JannahState(
//         isLoading: isLoading ?? this.isLoading,
//         totalPoints: totalPoints ?? this.totalPoints,
//         streakDays: streakDays ?? this.streakDays,
//         completionPct: completionPct ?? this.completionPct,
//         completedKeys: completedKeys ?? this.completedKeys,
//         unlockedIds: unlockedIds ?? this.unlockedIds,
//         newlyUnlockedId:
//             clearNewUnlock ? null : (newlyUnlockedId ?? this.newlyUnlockedId),
//       );

//   // ── Derived helpers ────────────────────────────────────────────────────────

//   bool isUnlocked(JannahItem item) => unlockedIds.contains(item.id);

//   JannahItem? get nextItem {
//     final locked = kJannahItems
//         .where((i) => !unlockedIds.contains(i.id))
//         .toList()
//       ..sort(
//           (a, b) => (a.requiredPoints ?? 0).compareTo(b.requiredPoints ?? 0));
//     return locked.isEmpty ? null : locked.first;
//   }

//   int get pointsToNext {
//     final n = nextItem;
//     if (n == null) return 0;
//     return math.max(0, (n.requiredPoints ?? 0) - totalPoints);
//   }

//   double get progressToNext {
//     final n = nextItem;
//     if (n == null) return 1.0;
//     final needed = n.requiredPoints ?? 1;
//     // find highest unlocked pts as "base"
//     final base = unlockedIds.isEmpty
//         ? 0
//         : kJannahItems
//             .where((i) => unlockedIds.contains(i.id))
//             .map((i) => i.requiredPoints ?? 0)
//             .fold<int>(0, math.max);
//     final range = needed - base;
//     if (range <= 0) return 1.0;
//     return ((totalPoints - base) / range).clamp(0.0, 1.0);
//   }

//   String _unlockConditionText(JannahItem item) {
//     final parts = <String>[];
//     if (item.requiredPoints != null) parts.add('${item.requiredPoints} pts');
//     if (item.requiredStreak != null)
//       parts.add('${item.requiredStreak} দিনের streak');
//     if (item.requiredPct != null)
//       parts.add('${item.requiredPct!.toInt()}% completion');
//     if (item.requiredAmalKey != null)
//       parts.add('"${item.requiredAmalKey}" আমল');
//     return parts.join(' + ');
//   }
// }

// // ─── JANNAH NOTIFIER ──────────────────────────────────────────────────────────

// class JannahNotifier extends StateNotifier<JannahState> {
//   JannahNotifier() : super(const JannahState());

//   /// Called from the screen whenever progressSummaryProvider emits new data.
//   /// Pass the raw ProgressSummary + list of all AmalCategory keys.
//   void syncFromProgress({
//     required ProgressSummary summary,
//     required List<AmalCategory> categories,
//   }) {
//     final tracker = summary.currentMonth;
//     final todayEntry = summary.todayEntry;

//     final totalPoints = tracker?.totalPoints ?? 0;
//     final streakDays = tracker?.streakDays ?? 0;
//     final completionPct = tracker?.completionPercentage ?? 0.0;

//     // Build a map of categoryId → key from the categories list
//     final idToKey = {for (final c in categories) c.id: c.key};

//     // Collect keys of all amal completed today
//     final completedKeys = <String>{};
//     if (todayEntry != null) {
//       for (final entry in todayEntry.entries) {
//         if (entry.completed) {
//           final key = idToKey[entry.categoryId];
//           if (key != null) completedKeys.add(key);
//         }
//       }
//     }

//     // Evaluate unlocks
//     final prevUnlocked = state.unlockedIds;
//     final nowUnlocked = <String>{};

//     for (final item in kJannahItems) {
//       final ptsOk =
//           item.requiredPoints == null || totalPoints >= item.requiredPoints!;
//       final streakOk =
//           item.requiredStreak == null || streakDays >= item.requiredStreak!;
//       final pctOk =
//           item.requiredPct == null || completionPct >= item.requiredPct!;
//       final amalOk = item.requiredAmalKey == null ||
//           completedKeys.contains(item.requiredAmalKey);

//       if (ptsOk && streakOk && pctOk && amalOk) nowUnlocked.add(item.id);
//     }

//     final brandNew = nowUnlocked.difference(prevUnlocked);

//     state = state.copyWith(
//       isLoading: false,
//       totalPoints: totalPoints,
//       streakDays: streakDays,
//       completionPct: completionPct,
//       completedKeys: completedKeys,
//       unlockedIds: nowUnlocked,
//       newlyUnlockedId: brandNew.isNotEmpty ? brandNew.first : null,
//     );
//   }

//   void clearNewUnlock() => state = state.copyWith(clearNewUnlock: true);
// }

// final jannahProvider =
//     StateNotifierProvider.autoDispose<JannahNotifier, JannahState>(
//   (ref) => JannahNotifier(),
// );

// // ─── MAIN SCREEN ──────────────────────────────────────────────────────────────

// class JannahGardenScreen extends ConsumerStatefulWidget {
//   const JannahGardenScreen({super.key});

//   @override
//   ConsumerState<JannahGardenScreen> createState() => _JannahGardenScreenState();
// }

// class _JannahGardenScreenState extends ConsumerState<JannahGardenScreen>
//     with TickerProviderStateMixin {
//   late final AnimationController _starCtrl =
//       AnimationController(vsync: this, duration: const Duration(seconds: 8))
//         ..repeat(reverse: true);
//   late final AnimationController _riverCtrl =
//       AnimationController(vsync: this, duration: const Duration(seconds: 3))
//         ..repeat();
//   late final AnimationController _floatCtrl =
//       AnimationController(vsync: this, duration: const Duration(seconds: 5))
//         ..repeat(reverse: true);
//   late final AnimationController _unlockCtrl = AnimationController(
//       vsync: this, duration: const Duration(milliseconds: 1400));

//   // Pan/zoom
//   double _scale = 1.0, _baseScale = 1.0;
//   Offset _pan = Offset.zero, _basePan = Offset.zero;

//   @override
//   void dispose() {
//     _starCtrl.dispose();
//     _riverCtrl.dispose();
//     _floatCtrl.dispose();
//     _unlockCtrl.dispose();
//     super.dispose();
//   }

//   // ── Wire real providers ────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     // Watch both providers and sync whenever either changes
//     final progressAsync = ref.watch(progressSummaryProvider);
//     final categoriesAsync = ref.watch(categoriesProvider);
//     final jannahState = ref.watch(jannahProvider);

//     // Sync when both are loaded
//     if (progressAsync.hasValue && categoriesAsync.hasValue) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ref.read(jannahProvider.notifier).syncFromProgress(
//               summary: progressAsync.value!,
//               categories: categoriesAsync.value!,
//             );
//       });
//     }

//     // Trigger unlock animation + dialog for newly unlocked item
//     if (jannahState.newlyUnlockedId != null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _unlockCtrl.forward(from: 0);
//         final item = kJannahItems.firstWhere(
//           (i) => i.id == jannahState.newlyUnlockedId,
//           orElse: () => kJannahItems.first,
//         );
//         _showUnlockDialog(item);
//         ref.read(jannahProvider.notifier).clearNewUnlock();
//       });
//     }

//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: _C.skyNight,
//       body: Stack(children: [
//         // Stars + sky
//         AnimatedBuilder(
//           animation: _starCtrl,
//           builder: (_, __) => CustomPaint(
//             size: size,
//             painter: _SkyPainter(_starCtrl.value),
//           ),
//         ),

//         // Pinch/pan garden
//         GestureDetector(
//           onScaleStart: (d) {
//             _baseScale = _scale;
//             _basePan = _pan;
//           },
//           onScaleUpdate: (d) => setState(() {
//             _scale = (_baseScale * d.scale).clamp(0.6, 2.8);
//             _pan = _basePan + d.focalPointDelta;
//           }),
//           child: Transform(
//             transform: Matrix4.identity()
//               ..translate(_pan.dx, _pan.dy)
//               ..scale(_scale),
//             alignment: Alignment.center,
//             child: _GardenCanvas(
//               state: jannahState,
//               size: size,
//               riverCtrl: _riverCtrl,
//               floatCtrl: _floatCtrl,
//               onTap: _onItemTap,
//             ),
//           ),
//         ),

//         // Top HUD
//         SafeArea(
//           child: _TopHUD(
//             state: jannahState,
//             isLoading: progressAsync.isLoading || categoriesAsync.isLoading,
//           ),
//         ),

//         // Bottom next-unlock bar
//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           child: _BottomBar(state: jannahState),
//         ),

//         // Unlock particle burst
//         IgnorePointer(
//           child: AnimatedBuilder(
//             animation: _unlockCtrl,
//             builder: (_, __) => _unlockCtrl.value > 0 && _unlockCtrl.value < 1
//                 ? CustomPaint(
//                     size: size,
//                     painter: _BurstPainter(_unlockCtrl.value),
//                   )
//                 : const SizedBox.shrink(),
//           ),
//         ),
//       ]),
//     );
//   }

//   void _onItemTap(JannahItem item) {
//     HapticFeedback.mediumImpact();
//     final unlocked = ref.read(jannahProvider).isUnlocked(item);
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) => unlocked
//           ? _UnlockedSheet(item: item)
//           : _LockedSheet(
//               item: item,
//               currentPoints: ref.read(jannahProvider).totalPoints,
//               currentStreak: ref.read(jannahProvider).streakDays,
//               currentPct: ref.read(jannahProvider).completionPct,
//             ),
//     );
//   }

//   void _showUnlockDialog(JannahItem item) {
//     showDialog(
//       context: context,
//       barrierColor: Colors.black87,
//       builder: (_) => _UnlockDialog(item: item),
//     );
//   }
// }

// // ─── SKY PAINTER ──────────────────────────────────────────────────────────────

// class _SkyPainter extends CustomPainter {
//   final double t;
//   _SkyPainter(this.t);

//   static final _rng = math.Random(99);
//   static final _stars = List.generate(
//       70,
//       (_) => [
//             _rng.nextDouble(),
//             _rng.nextDouble() * 0.50,
//             _rng.nextDouble() * 1.6 + 0.5,
//             _rng.nextDouble() * math.pi * 2,
//           ]);

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Sky gradient
//     final rect = Offset.zero & size;
//     canvas.drawRect(
//       rect,
//       Paint()
//         ..shader = LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [_C.skyNight, _C.skyDawn, _C.groundDark],
//           stops: const [0, 0.55, 1],
//         ).createShader(rect),
//     );
//     // Stars
//     final p = Paint();
//     for (final s in _stars) {
//       final opacity = 0.25 + 0.55 * math.sin(s[3] + t * math.pi);
//       p.color = Colors.white.withOpacity(opacity.clamp(0.05, 0.9));
//       canvas.drawCircle(Offset(s[0] * size.width, s[1] * size.height), s[2], p);
//     }
//   }

//   @override
//   bool shouldRepaint(_SkyPainter o) => o.t != t;
// }

// // ─── GARDEN CANVAS ────────────────────────────────────────────────────────────

// class _GardenCanvas extends StatelessWidget {
//   final JannahState state;
//   final Size size;
//   final AnimationController riverCtrl, floatCtrl;
//   final void Function(JannahItem) onTap;

//   const _GardenCanvas({
//     required this.state,
//     required this.size,
//     required this.riverCtrl,
//     required this.floatCtrl,
//     required this.onTap,
//   });

//   // Convert garden-relative coords to screen offset
//   Offset _pos(double gx, double gy) {
//     final top = size.height * 0.32;
//     final bottom = size.height * 0.80;
//     final left = size.width * 0.06;
//     final right = size.width * 0.94;
//     return Offset(
//       left + gx * (right - left),
//       top + gy * (bottom - top),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(children: [
//       // Ground
//       Positioned(
//         top: size.height * 0.38,
//         left: 0,
//         right: 0,
//         bottom: 0,
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [_C.grassTop, _C.groundMid, _C.groundDark],
//               stops: [0, 0.35, 1],
//             ),
//             borderRadius: BorderRadius.circular(32),
//           ),
//         ),
//       ),

//       // River (when stream or river_full is unlocked)
//       if (state.isUnlocked(kJannahItems.firstWhere((i) => i.id == 'stream',
//               orElse: () => kJannahItems[0])) ||
//           state.isUnlocked(kJannahItems.firstWhere((i) => i.id == 'river_full',
//               orElse: () => kJannahItems[0])))
//         Positioned(
//           top: size.height * 0.62,
//           left: size.width * 0.12,
//           right: size.width * 0.12,
//           child: AnimatedBuilder(
//             animation: riverCtrl,
//             builder: (_, __) => _RiverPainterWidget(
//               t: riverCtrl.value,
//               wide: state.isUnlocked(kJannahItems.firstWhere(
//                   (i) => i.id == 'river_full',
//                   orElse: () => kJannahItems[0])),
//             ),
//           ),
//         ),

//       // All items
//       ...kJannahItems.map((item) {
//         final pos = _pos(item.gx, item.gy);
//         return Positioned(
//           left: pos.dx - 28 * item.scale,
//           top: pos.dy - 42 * item.scale,
//           child: GestureDetector(
//             onTap: () => onTap(item),
//             child: _ItemWidget(
//               item: item,
//               unlocked: state.isUnlocked(item),
//               floatCtrl: floatCtrl,
//               pointsNeeded:
//                   math.max(0, (item.requiredPoints ?? 0) - state.totalPoints),
//             ),
//           ),
//         );
//       }),
//     ]);
//   }
// }

// // ─── RIVER WIDGET ─────────────────────────────────────────────────────────────

// class _RiverPainterWidget extends StatelessWidget {
//   final double t;
//   final bool wide;
//   const _RiverPainterWidget({required this.t, required this.wide});

//   @override
//   Widget build(BuildContext context) {
//     final h = wide ? 20.0 : 10.0;
//     final glow = 0.3 + 0.15 * math.sin(t * math.pi * 2);
//     return Container(
//       height: h,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(99),
//         gradient: LinearGradient(colors: [
//           _C.riverBlue.withOpacity(0.2),
//           _C.riverBlue.withOpacity(0.65 + 0.2 * math.sin(t * math.pi * 2)),
//           _C.riverBlue.withOpacity(0.2),
//         ]),
//         border: Border.all(color: _C.riverBlue.withOpacity(0.5), width: 0.5),
//         boxShadow: [
//           BoxShadow(
//             color: _C.riverBlue.withOpacity(glow),
//             blurRadius: 10,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── ITEM WIDGET ──────────────────────────────────────────────────────────────

// class _ItemWidget extends StatelessWidget {
//   final JannahItem item;
//   final bool unlocked;
//   final AnimationController floatCtrl;
//   final int pointsNeeded;

//   const _ItemWidget({
//     required this.item,
//     required this.unlocked,
//     required this.floatCtrl,
//     required this.pointsNeeded,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isNearby = pointsNeeded > 0 && pointsNeeded <= 25;

//     if (!unlocked) {
//       return Opacity(
//         opacity: isNearby ? 0.38 : 0.12,
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Text(item.emoji,
//                 style: TextStyle(
//                   fontSize: 30 * item.scale,
//                   color: const Color(0xFF0D2A14),
//                 )),
//             if (isNearby)
//               Positioned(
//                 top: -10,
//                 right: -14,
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: _C.gold,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     '+$pointsNeeded',
//                     style: const TextStyle(
//                       color: Color(0xFF1A0A00),
//                       fontSize: 8,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       );
//     }

//     // Unlocked — floating + glow for higher tiers
//     return AnimatedBuilder(
//       animation: floatCtrl,
//       builder: (_, __) {
//         final float = math.sin(floatCtrl.value * math.pi) * 3.5 * item.scale;
//         final isElite =
//             item.tier == _ItemTier.four || item.tier == _ItemTier.five;
//         final glowOpacity =
//             isElite ? 0.15 + 0.12 * math.sin(floatCtrl.value * math.pi) : 0.0;

//         return Transform.translate(
//           offset: Offset(0, -float),
//           child: Stack(
//             alignment: Alignment.center,
//             clipBehavior: Clip.none,
//             children: [
//               if (isElite)
//                 Container(
//                   width: 48 * item.scale,
//                   height: 18 * item.scale,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(99),
//                     boxShadow: [
//                       BoxShadow(
//                         color: _C.gold.withOpacity(glowOpacity * 2),
//                         blurRadius: 20,
//                         spreadRadius: 6,
//                       ),
//                     ],
//                   ),
//                 ),
//               Text(
//                 item.emoji,
//                 style: TextStyle(
//                   fontSize: 30 * item.scale,
//                   shadows: isElite
//                       ? [
//                           Shadow(
//                               color: _C.gold.withOpacity(0.7), blurRadius: 18)
//                         ]
//                       : null,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// // ─── TOP HUD ──────────────────────────────────────────────────────────────────

// class _TopHUD extends StatelessWidget {
//   final JannahState state;
//   final bool isLoading;
//   const _TopHUD({required this.state, required this.isLoading});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
//       child: Row(children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text('আমার জান্নাত',
//                   style: TextStyle(
//                     color: _C.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: -0.3,
//                   )),
//               if (isLoading)
//                 const Text('লোড হচ্ছে...',
//                     style: TextStyle(color: _C.mutedText, fontSize: 11))
//               else
//                 Text(
//                     '${state.unlockedIds.length} / ${kJannahItems.length} উন্মুক্ত',
//                     style: const TextStyle(color: _C.mutedText, fontSize: 11)),
//             ],
//           ),
//         ),
//         _Pill(
//             emoji: '🔥',
//             value: '${state.streakDays}',
//             label: 'দিন',
//             color: const Color(0xFFFF6B35)),
//         const SizedBox(width: 8),
//         _Pill(
//             emoji: '✦',
//             value: '${state.totalPoints}',
//             label: 'pts',
//             color: _C.gold),
//       ]),
//     );
//   }
// }

// class _Pill extends StatelessWidget {
//   final String emoji, value, label;
//   final Color color;
//   const _Pill(
//       {required this.emoji,
//       required this.value,
//       required this.label,
//       required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: _C.cardBg.withOpacity(0.92),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color.withOpacity(0.35), width: 0.5),
//       ),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [
//         Text(emoji, style: const TextStyle(fontSize: 12)),
//         const SizedBox(width: 4),
//         Text(value,
//             style: TextStyle(
//                 color: color, fontSize: 13, fontWeight: FontWeight.w700)),
//         Text(' $label',
//             style: const TextStyle(color: _C.mutedText, fontSize: 10)),
//       ]),
//     );
//   }
// }

// // ─── BOTTOM BAR ───────────────────────────────────────────────────────────────

// class _BottomBar extends StatelessWidget {
//   final JannahState state;
//   const _BottomBar({required this.state});

//   @override
//   Widget build(BuildContext context) {
//     final next = state.nextItem;
//     final pad = MediaQuery.of(context).padding.bottom;

//     return Container(
//       padding: EdgeInsets.fromLTRB(16, 12, 16, pad + 12),
//       decoration: BoxDecoration(
//         color: _C.cardBg.withOpacity(0.96),
//         border: Border(top: BorderSide(color: _C.cardBorder, width: 0.5)),
//       ),
//       child: next == null
//           ? const Center(
//               child: Text('মাশাআল্লাহ! সব উন্মুক্ত হয়েছে 🌟',
//                   style: TextStyle(color: _C.gold, fontSize: 13)),
//             )
//           : Row(children: [
//               Text(next.emoji, style: const TextStyle(fontSize: 22)),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(next.nameBn,
//                             style: const TextStyle(
//                                 color: _C.lightText,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w600)),
//                         Text(
//                           state.pointsToNext > 0
//                               ? 'আরও ${state.pointsToNext} pts'
//                               : 'প্রায় হয়ে গেছে!',
//                           style: const TextStyle(
//                               color: _C.gold,
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 5),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(99),
//                       child: LinearProgressIndicator(
//                         value: state.progressToNext,
//                         minHeight: 5,
//                         backgroundColor: _C.cardBorder,
//                         valueColor: const AlwaysStoppedAnimation(_C.gold),
//                       ),
//                     ),
//                     const SizedBox(height: 3),
//                     Text(next.amalConnectionBn,
//                         style:
//                             const TextStyle(color: _C.mutedText, fontSize: 10)),
//                   ],
//                 ),
//               ),
//             ]),
//     );
//   }
// }

// // ─── LOCKED SHEET ─────────────────────────────────────────────────────────────

// class _LockedSheet extends StatelessWidget {
//   final JannahItem item;
//   final int currentPoints, currentStreak;
//   final double currentPct;

//   const _LockedSheet({
//     required this.item,
//     required this.currentPoints,
//     required this.currentStreak,
//     required this.currentPct,
//   });

//   Widget _conditionRow(
//       IconData icon, String label, String current, String needed, bool done) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5),
//       child: Row(children: [
//         Icon(icon, size: 14, color: done ? _C.green : _C.mutedText),
//         const SizedBox(width: 8),
//         Expanded(
//             child: Text(label,
//                 style: const TextStyle(color: _C.lightText, fontSize: 12))),
//         Text('$current / $needed',
//             style: TextStyle(
//                 color: done ? _C.green : _C.gold,
//                 fontSize: 11,
//                 fontWeight: FontWeight.w600)),
//       ]),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _C.cardBg,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: _C.cardBorder, width: 0.5),
//       ),
//       padding: const EdgeInsets.all(20),
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         // Handle
//         Container(
//           width: 36,
//           height: 4,
//           decoration: BoxDecoration(
//             color: _C.cardBorder,
//             borderRadius: BorderRadius.circular(99),
//           ),
//         ),
//         const SizedBox(height: 16),

//         Opacity(
//           opacity: 0.5,
//           child: Container(
//             width: 64,
//             height: 64,
//             decoration: BoxDecoration(
//               color: _C.cardBorder,
//               borderRadius: BorderRadius.circular(18),
//             ),
//             child: Center(
//               child: Text(item.emoji, style: const TextStyle(fontSize: 30)),
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),

//         Text(item.nameBn,
//             style: const TextStyle(
//                 color: _C.lightText,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700)),
//         const SizedBox(height: 4),
//         Text(item.descriptionBn,
//             textAlign: TextAlign.center,
//             style: const TextStyle(color: _C.mutedText, fontSize: 12)),
//         const SizedBox(height: 16),

//         // Conditions
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: const Color(0xFF061209),
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: _C.cardBorder),
//           ),
//           child: Column(children: [
//             if (item.requiredPoints != null)
//               _conditionRow(
//                 Icons.stars_rounded,
//                 'মোট পয়েন্ট',
//                 '$currentPoints',
//                 '${item.requiredPoints}',
//                 currentPoints >= item.requiredPoints!,
//               ),
//             if (item.requiredStreak != null)
//               _conditionRow(
//                 Icons.local_fire_department_rounded,
//                 'ধারাবাহিক দিন',
//                 '$currentStreak',
//                 '${item.requiredStreak}',
//                 currentStreak >= item.requiredStreak!,
//               ),
//             if (item.requiredPct != null)
//               _conditionRow(
//                 Icons.percent_rounded,
//                 'সমাপ্তি হার',
//                 '${currentPct.toInt()}%',
//                 '${item.requiredPct!.toInt()}%',
//                 currentPct >= item.requiredPct!,
//               ),
//             if (item.requiredAmalKey != null)
//               _conditionRow(
//                 Icons.task_alt_rounded,
//                 'আমল: ${item.requiredAmalKey}',
//                 '—',
//                 'সম্পন্ন',
//                 false,
//               ),
//           ]),
//         ),
//         const SizedBox(height: 8),
//       ]),
//     );
//   }
// }

// // ─── UNLOCKED SHEET ───────────────────────────────────────────────────────────

// class _UnlockedSheet extends StatelessWidget {
//   final JannahItem item;
//   const _UnlockedSheet({required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _C.cardBg,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: _C.cardBorder, width: 0.5),
//       ),
//       padding: const EdgeInsets.all(24),
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         Container(
//           width: 36,
//           height: 4,
//           decoration: BoxDecoration(
//               color: _C.cardBorder, borderRadius: BorderRadius.circular(99)),
//         ),
//         const SizedBox(height: 16),
//         Text(item.emoji, style: const TextStyle(fontSize: 56))
//             .animate()
//             .scale(
//                 begin: const Offset(0.4, 0.4),
//                 curve: Curves.elasticOut,
//                 duration: 700.ms)
//             .fadeIn(),
//         const SizedBox(height: 10),
//         Text(item.nameBn,
//             style: const TextStyle(
//                 color: _C.white, fontSize: 18, fontWeight: FontWeight.w700)),
//         const SizedBox(height: 6),
//         Text(item.descriptionBn,
//             textAlign: TextAlign.center,
//             style: const TextStyle(color: _C.mutedText, fontSize: 13)),
//         const SizedBox(height: 16),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//           decoration: BoxDecoration(
//             color: _C.green.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: _C.green.withOpacity(0.3), width: 0.5),
//           ),
//           child: Row(mainAxisSize: MainAxisSize.min, children: [
//             const Icon(Icons.check_circle_rounded, color: _C.green, size: 16),
//             const SizedBox(width: 8),
//             Text(item.amalConnectionBn,
//                 style: const TextStyle(
//                     color: _C.green,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600)),
//           ]),
//         ),
//         const SizedBox(height: 8),
//       ]),
//     );
//   }
// }

// // ─── UNLOCK DIALOG ────────────────────────────────────────────────────────────

// class _UnlockDialog extends StatelessWidget {
//   final JannahItem item;
//   const _UnlockDialog({required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: Container(
//         decoration: BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.circular(24),
//           border: Border.all(color: _C.gold.withOpacity(0.5), width: 1),
//         ),
//         padding: const EdgeInsets.all(28),
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           Text(item.emoji, style: const TextStyle(fontSize: 64))
//               .animate()
//               .scale(
//                   begin: const Offset(0, 0),
//                   curve: Curves.elasticOut,
//                   duration: 700.ms)
//               .fadeIn(),
//           const SizedBox(height: 6),
//           const Text('নতুন উন্মোচন!',
//               style: TextStyle(
//                   color: _C.gold,
//                   fontSize: 12,
//                   letterSpacing: 1.5,
//                   fontWeight: FontWeight.w600)),
//           const SizedBox(height: 6),
//           Text(item.nameBn,
//               style: const TextStyle(
//                   color: _C.white, fontSize: 20, fontWeight: FontWeight.w700)),
//           const SizedBox(height: 8),
//           Text(item.descriptionBn,
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: _C.mutedText, fontSize: 13)),
//           const SizedBox(height: 24),
//           GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF0E3D22),
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(color: _C.gold.withOpacity(0.3), width: 0.5),
//               ),
//               child: const Center(
//                 child: Text('আলহামদুলিল্লাহ 🌟',
//                     style: TextStyle(
//                         color: _C.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700)),
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }

// // ─── BURST PAINTER ────────────────────────────────────────────────────────────

// class _BurstPainter extends CustomPainter {
//   final double t;
//   _BurstPainter(this.t);

//   static final _rng = math.Random(77);
//   static final _pts = List.generate(
//       28,
//       (_) => [
//             (_rng.nextDouble() - 0.5) * 2.5,
//             (_rng.nextDouble() - 0.5) * 2.5,
//             _rng.nextDouble(),
//           ]);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = size.center(Offset.zero);
//     final p = Paint();
//     for (final pt in _pts) {
//       final d = t * 220.0;
//       final o = (1 - t).clamp(0.0, 1.0);
//       final r = 3.5 * (1 - t * 0.6);
//       p.color = _C.gold.withOpacity(o * 0.85);
//       canvas.drawCircle(center + Offset(pt[0] * d, pt[1] * d), r, p);
//       // secondary white sparkle
//       p.color = Colors.white.withOpacity(o * 0.4);
//       canvas.drawCircle(
//           center + Offset(pt[0] * d * 0.6, pt[1] * d * 0.6), r * 0.5, p);
//     }
//   }

//   @override
//   bool shouldRepaint(_BurstPainter o) => o.t != t;
// }
// ═══════════════════════════════════════════════════════════════════════════
// jannah_world_screen.dart
//
// A fully custom-rendered isometric world. Zero emojis — every asset is
// drawn with Flutter's Canvas API (paths, arcs, bezier curves, gradients).
//
// SETUP:
//   1. Place in lib/features/jannah/jannah_world_screen.dart
//   2. Adjust the two imports at the top to match your project paths.
//   3. Add JannahGardenScreen() as a tab in your shell.
//
// DATA: 100% from your real providers — progressSummaryProvider + categoriesProvider.
//       Month separation intentionally absent — this is a cumulative lifetime journey.
// ═══════════════════════════════════════════════════════════════════════════

// import 'dart:math' as math;
// import 'package:amal_tracker/features/tracker/models/tracker_model.dart';
// import 'package:amal_tracker/features/tracker/providers/tracker_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // ═══════════════════════════════════════════════════════════════════════════
// // SECTION 1 — WORLD DEFINITION
// // ═══════════════════════════════════════════════════════════════════════════

// // Every JannahBuilding is drawn by its own Painter method — no assets/emojis.
// enum BuildingType {
//   sprout, // first life — tiny green mound
//   mosque, // fajr — minaret + dome
//   quranPavilion, // tilawat — open arch pavilion
//   fountain, // dhikr/tasbih — circular basin with water arc
//   dateTree, // tilawat milestone — tall palm shape
//   bridge, // siyam — arched stone bridge
//   lanternPost, // darud — glowing post
//   cottage, // streak — walls + roof + chimney
//   goldenTree, // 90% completion — radiating tree
//   palace, // final — multi-tier with domes
// }

// enum TileType { grass, grassDark, stonePath, water, waterDeep, sand }

// class JannahBuilding {
//   final String id;
//   final String nameBn;
//   final String descBn;
//   final String howBn; // how to unlock — shown in sheet
//   final BuildingType type;
//   final int gridCol, gridRow; // position in 9×9 iso grid
//   // unlock conditions (all non-null must be satisfied)
//   final int? reqPoints;
//   final int? reqStreak;
//   final double? reqPct; // 0–100
//   final String? reqAmalKey;

//   const JannahBuilding({
//     required this.id,
//     required this.nameBn,
//     required this.descBn,
//     required this.howBn,
//     required this.type,
//     required this.gridCol,
//     required this.gridRow,
//     this.reqPoints,
//     this.reqStreak,
//     this.reqPct,
//     this.reqAmalKey,
//   });
// }

// const kBuildings = <JannahBuilding>[
//   JannahBuilding(
//     id: 'sprout',
//     nameBn: 'প্রথম চারা',
//     descBn:
//         'আপনার প্রথম আমল রেকর্ড হওয়ার সাথে সাথে এই চারা জন্ম নেয়। প্রতিটি আমল এটিকে বড় করে।',
//     howBn: 'যেকোনো ১ টি আমল করুন',
//     type: BuildingType.sprout,
//     gridCol: 4,
//     gridRow: 4,
//     reqPoints: 1,
//   ),
//   JannahBuilding(
//     id: 'mosque',
//     nameBn: 'ফজরের মসজিদ',
//     descBn:
//         'ফজরের নামাজের নূর দিয়ে এই মসজিদ আলোকিত। প্রতিদিন ফজর পড়লে মিনারে আলো জ্বলে।',
//     howBn: 'ফজর নামাজ আদায় করুন + ১০ pts',
//     type: BuildingType.mosque,
//     gridCol: 3,
//     gridRow: 3,
//     reqPoints: 10,
//     reqAmalKey: 'fajr',
//   ),
//   JannahBuilding(
//     id: 'pavilion',
//     nameBn: 'তিলাওয়াতের চত্বর',
//     descBn: 'এখানে বসে কুরআন পড়া হয়। প্রতিটি আয়াতের শব্দ বাতাসে ভাসে।',
//     howBn: 'কুরআন তিলাওয়াত করুন + ২০ pts',
//     type: BuildingType.quranPavilion,
//     gridCol: 6,
//     gridRow: 3,
//     reqPoints: 20,
//     reqAmalKey: 'tilawat',
//   ),
//   JannahBuilding(
//     id: 'fountain',
//     nameBn: 'জিকিরের ফোয়ারা',
//     descBn:
//         'তাসবীহ-জিকিরের শব্দে এই ফোয়ারার পানি নাচে। যত জিকির, তত উঁচুতে ওঠে পানি।',
//     howBn: 'তাসবীহ/জিকির করুন + ৩০ pts',
//     type: BuildingType.fountain,
//     gridCol: 4,
//     gridRow: 6,
//     reqPoints: 30,
//     reqAmalKey: 'tasbih',
//   ),
//   JannahBuilding(
//     id: 'date_tree',
//     nameBn: 'কাউসারের খেজুর',
//     descBn: 'জান্নাতের বিশেষ খেজুর গাছ। ৭ দিন ধারাবাহিক আমলের পুরস্কার।',
//     howBn: '৭ দিনের streak ধরুন',
//     type: BuildingType.dateTree,
//     gridCol: 2,
//     gridRow: 5,
//     reqPoints: 35,
//     reqStreak: 7,
//   ),
//   JannahBuilding(
//     id: 'lantern',
//     nameBn: 'দরুদের আলোকস্তম্ভ',
//     descBn: 'নবীজির উপর দরুদ পড়লে এই স্তম্ভ থেকে নূর বের হয়।',
//     howBn: 'দরুদ পড়ুন + ৪৫ pts',
//     type: BuildingType.lanternPost,
//     gridCol: 6,
//     gridRow: 6,
//     reqPoints: 45,
//     reqAmalKey: 'darud',
//   ),
//   JannahBuilding(
//     id: 'bridge',
//     nameBn: 'সবরের সেতু',
//     descBn: 'রোজার কষ্ট সহ্যের পুরস্কার। এই সেতু দুই তীরকে যুক্ত করে।',
//     howBn: 'রোজা রাখুন + ৫৫ pts',
//     type: BuildingType.bridge,
//     gridCol: 4,
//     gridRow: 7,
//     reqPoints: 55,
//     reqAmalKey: 'siyam',
//   ),
//   JannahBuilding(
//     id: 'cottage',
//     nameBn: 'আমলের ঘর',
//     descBn: '১০ দিন ধারাবাহিক আমলের পুরস্কার। এখানে বিশ্রাম নেওয়া যায়।',
//     howBn: '১০ দিনের streak + ৭০ pts',
//     type: BuildingType.cottage,
//     gridCol: 2,
//     gridRow: 2,
//     reqPoints: 70,
//     reqStreak: 10,
//   ),
//   JannahBuilding(
//     id: 'golden_tree',
//     nameBn: 'তুবা গাছ',
//     descBn: 'মাসে ৯০% আমল সম্পন্ন করলে তুবা গাছের শাখা জন্মায়।',
//     howBn: 'মাসে ৯০%+ completion + ১২০ pts',
//     type: BuildingType.goldenTree,
//     gridCol: 7,
//     gridRow: 2,
//     reqPoints: 120,
//     reqPct: 90,
//   ),
//   JannahBuilding(
//     id: 'palace',
//     nameBn: 'জান্নাতের মহল',
//     descBn:
//         'আপনার সমস্ত আমলের চূড়ান্ত পুরস্কার। আল্লাহর রহমতে নির্মিত আপনার চিরস্থায়ী আবাস।',
//     howBn: '২০০ pts + ১৫ দিনের streak',
//     type: BuildingType.palace,
//     gridCol: 4,
//     gridRow: 1,
//     reqPoints: 200,
//     reqStreak: 15,
//   ),
// ];

// // ═══════════════════════════════════════════════════════════════════════════
// // SECTION 2 — STATE & PROVIDER
// // ═══════════════════════════════════════════════════════════════════════════

// class JannahWorldState {
//   final bool isLoading;
//   final int totalPoints;
//   final int streakDays;
//   final double completionPct;
//   final Set<String> completedAmalKeys;
//   final Set<String> unlockedIds;
//   final String? newlyUnlockedId;
//   final JannahBuilding? focusedBuilding;

//   const JannahWorldState({
//     this.isLoading = true,
//     this.totalPoints = 0,
//     this.streakDays = 0,
//     this.completionPct = 0,
//     this.completedAmalKeys = const {},
//     this.unlockedIds = const {},
//     this.newlyUnlockedId,
//     this.focusedBuilding,
//   });

//   JannahWorldState copyWith({
//     bool? isLoading,
//     int? totalPoints,
//     int? streakDays,
//     double? completionPct,
//     Set<String>? completedAmalKeys,
//     Set<String>? unlockedIds,
//     String? newlyUnlockedId,
//     JannahBuilding? focusedBuilding,
//     bool clearUnlock = false,
//     bool clearFocus = false,
//   }) =>
//       JannahWorldState(
//         isLoading: isLoading ?? this.isLoading,
//         totalPoints: totalPoints ?? this.totalPoints,
//         streakDays: streakDays ?? this.streakDays,
//         completionPct: completionPct ?? this.completionPct,
//         completedAmalKeys: completedAmalKeys ?? this.completedAmalKeys,
//         unlockedIds: unlockedIds ?? this.unlockedIds,
//         newlyUnlockedId:
//             clearUnlock ? null : (newlyUnlockedId ?? this.newlyUnlockedId),
//         focusedBuilding:
//             clearFocus ? null : (focusedBuilding ?? this.focusedBuilding),
//       );

//   bool isUnlocked(String id) => unlockedIds.contains(id);

//   JannahBuilding? get nextBuilding {
//     final locked = kBuildings.where((b) => !unlockedIds.contains(b.id)).toList()
//       ..sort((a, b) => (a.reqPoints ?? 0).compareTo(b.reqPoints ?? 0));
//     return locked.isEmpty ? null : locked.first;
//   }

//   int get pointsToNext {
//     final n = nextBuilding;
//     return n == null ? 0 : math.max(0, (n.reqPoints ?? 0) - totalPoints);
//   }

//   double get progressToNext {
//     final n = nextBuilding;
//     if (n == null) return 1.0;
//     final needed = n.reqPoints ?? 1;
//     final base = unlockedIds.isEmpty
//         ? 0
//         : kBuildings
//             .where((b) => unlockedIds.contains(b.id))
//             .map((b) => b.reqPoints ?? 0)
//             .fold<int>(0, math.max);
//     final range = needed - base;
//     if (range <= 0) return 1.0;
//     return ((totalPoints - base) / range).clamp(0.0, 1.0);
//   }
// }

// class JannahWorldNotifier extends StateNotifier<JannahWorldState> {
//   JannahWorldNotifier() : super(const JannahWorldState());

//   void sync({
//     required ProgressSummary summary,
//     required List<AmalCategory> categories,
//   }) {
//     final tracker = summary.currentMonth;
//     final pts = tracker?.totalPoints ?? 0;
//     final streak = tracker?.streakDays ?? 0;
//     final pct = tracker?.completionPercentage ?? 0.0;

//     final idToKey = {for (final c in categories) c.id: c.key};
//     final doneKeys = <String>{};
//     if (summary.todayEntry != null) {
//       for (final e in summary.todayEntry!.entries) {
//         if (e.completed) {
//           final k = idToKey[e.categoryId];
//           if (k != null) doneKeys.add(k);
//         }
//       }
//     }

//     final prev = state.unlockedIds;
//     final now = <String>{};
//     for (final b in kBuildings) {
//       if ((b.reqPoints == null || pts >= b.reqPoints!) &&
//           (b.reqStreak == null || streak >= b.reqStreak!) &&
//           (b.reqPct == null || pct >= b.reqPct!) &&
//           (b.reqAmalKey == null || doneKeys.contains(b.reqAmalKey))) {
//         now.add(b.id);
//       }
//     }
//     final brandNew = now.difference(prev);

//     state = state.copyWith(
//       isLoading: false,
//       totalPoints: pts,
//       streakDays: streak,
//       completionPct: pct,
//       completedAmalKeys: doneKeys,
//       unlockedIds: now,
//       newlyUnlockedId: brandNew.isNotEmpty ? brandNew.first : null,
//     );
//   }

//   void focus(JannahBuilding b) => state = state.copyWith(focusedBuilding: b);
//   void clearFocus() => state = state.copyWith(clearFocus: true);
//   void clearUnlock() => state = state.copyWith(clearUnlock: true);
// }

// final jannahWorldProvider =
//     StateNotifierProvider.autoDispose<JannahWorldNotifier, JannahWorldState>(
//   (_) => JannahWorldNotifier(),
// );

// // ═══════════════════════════════════════════════════════════════════════════
// // SECTION 3 — MAIN SCREEN
// // ═══════════════════════════════════════════════════════════════════════════

// class JannahWorldScreen2 extends ConsumerStatefulWidget {
//   const JannahWorldScreen2({super.key});

//   @override
//   ConsumerState<JannahWorldScreen2> createState() => _JannahWorldScreen2State();
// }

// class _JannahWorldScreen2State extends ConsumerState<JannahWorldScreen2>
//     with TickerProviderStateMixin {
//   // Animation controllers
//   late final AnimationController _skyCtrl // stars twinkle
//       = AnimationController(vsync: this, duration: const Duration(seconds: 10))
//         ..repeat();
//   late final AnimationController _waterCtrl // river shimmer
//       = AnimationController(vsync: this, duration: const Duration(seconds: 2))
//         ..repeat();
//   late final AnimationController _floatCtrl // building float / tree sway
//       = AnimationController(vsync: this, duration: const Duration(seconds: 6))
//         ..repeat(reverse: true);
//   late final AnimationController _unlockCtrl = AnimationController(
//       vsync: this, duration: const Duration(milliseconds: 1600));
//   late final AnimationController _pulseCtrl // locked areas pulse
//       = AnimationController(vsync: this, duration: const Duration(seconds: 3))
//         ..repeat(reverse: true);

//   // Pan/zoom via InteractiveViewer
//   final TransformationController _transformCtrl = TransformationController();

//   @override
//   void dispose() {
//     _skyCtrl.dispose();
//     _waterCtrl.dispose();
//     _floatCtrl.dispose();
//     _unlockCtrl.dispose();
//     _pulseCtrl.dispose();
//     _transformCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final progressAsync = ref.watch(progressSummaryProvider);
//     final categoriesAsync = ref.watch(categoriesProvider);
//     final ws = ref.watch(jannahWorldProvider);

//     // Sync real data
//     if (progressAsync.hasValue && categoriesAsync.hasValue) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           ref.read(jannahWorldProvider.notifier).sync(
//                 summary: progressAsync.value!,
//                 categories: categoriesAsync.value!,
//               );
//         }
//       });
//     }

//     // Trigger unlock animation
//     if (ws.newlyUnlockedId != null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (!mounted) return;
//         _unlockCtrl.forward(from: 0);
//         final b = kBuildings.firstWhere(
//           (b) => b.id == ws.newlyUnlockedId,
//           orElse: () => kBuildings.first,
//         );
//         ref.read(jannahWorldProvider.notifier).clearUnlock();
//         _showUnlockCelebration(b);
//       });
//     }

//     final size = MediaQuery.of(context).size;
//     final isLoading = progressAsync.isLoading || categoriesAsync.isLoading;

//     return Scaffold(
//       backgroundColor: const Color(0xFF020C06),
//       body: Stack(children: [
//         // ── Animated sky layer ─────────────────────────────────────────────
//         AnimatedBuilder(
//           animation: _skyCtrl,
//           builder: (_, __) => CustomPaint(
//             size: size,
//             painter: _SkyPainter(t: _skyCtrl.value),
//           ),
//         ),

//         // ── Pinch/zoom/pan interactive world ──────────────────────────────
//         InteractiveViewer(
//           transformationController: _transformCtrl,
//           minScale: 0.5,
//           maxScale: 3.0,
//           boundaryMargin: EdgeInsets.all(size.width * 0.5),
//           child: SizedBox(
//             width: size.width,
//             height: size.height,
//             child: AnimatedBuilder(
//               animation: Listenable.merge([_waterCtrl, _floatCtrl, _pulseCtrl]),
//               builder: (_, __) => CustomPaint(
//                 painter: _JannahWorldPainter(
//                   state: ws,
//                   size: size,
//                   waterT: _waterCtrl.value,
//                   floatT: _floatCtrl.value,
//                   pulseT: _pulseCtrl.value,
//                   onBuildingTap: _onBuildingTap,
//                 ),
//                 child: _TapLayer(
//                   state: ws,
//                   size: size,
//                   onTap: _onBuildingTap,
//                 ),
//               ),
//             ),
//           ),
//         ),

//         // ── Top HUD ────────────────────────────────────────────────────────
//         SafeArea(child: _TopHUD(state: ws, isLoading: isLoading)),

//         // ── Bottom bar: next unlock progress ──────────────────────────────
//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           child: _BottomProgressBar(state: ws),
//         ),

//         // ── Unlock burst particles ─────────────────────────────────────────
//         AnimatedBuilder(
//           animation: _unlockCtrl,
//           builder: (_, __) {
//             if (_unlockCtrl.value <= 0 || _unlockCtrl.value >= 1) {
//               return const SizedBox.shrink();
//             }
//             return IgnorePointer(
//               child: CustomPaint(
//                 size: size,
//                 painter: _ParticleBurstPainter(t: _unlockCtrl.value),
//               ),
//             );
//           },
//         ),

//         // ── Loading overlay ────────────────────────────────────────────────
//         if (isLoading)
//           Container(
//             color: const Color(0x88020C06),
//             child: const Center(
//               child: CircularProgressIndicator(color: Color(0xFFD4A843)),
//             ),
//           ),
//       ]),
//     );
//   }

//   void _onBuildingTap(JannahBuilding b) {
//     HapticFeedback.mediumImpact();
//     final unlocked = ref.read(jannahWorldProvider).isUnlocked(b.id);
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) => unlocked
//           ? _UnlockedBuildingSheet(building: b)
//           : _LockedBuildingSheet(
//               building: b,
//               state: ref.read(jannahWorldProvider),
//             ),
//     );
//   }

//   void _showUnlockCelebration(JannahBuilding b) {
//     showDialog(
//       context: context,
//       barrierColor: Colors.black87,
//       builder: (_) => _UnlockCelebrationDialog(building: b),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // SECTION 4 — WORLD PAINTER (the heart of the feature)
// // ═══════════════════════════════════════════════════════════════════════════

// class _JannahWorldPainter extends CustomPainter {
//   final JannahWorldState state;
//   final Size size;
//   final double waterT, floatT, pulseT;
//   final void Function(JannahBuilding) onBuildingTap;

//   _JannahWorldPainter({
//     required this.state,
//     required this.size,
//     required this.waterT,
//     required this.floatT,
//     required this.pulseT,
//     required this.onBuildingTap,
//   });

//   static const int kCols = 9;
//   static const int kRows = 9;
//   static const double kTW = 72.0; // tile width
//   static const double kTH = 36.0; // tile height (half of width for iso)

//   // ── Isometric projection ────────────────────────────────────────────────
//   Offset _isoToScreen(double col, double row, Size s) {
//     final ox = s.width / 2;
//     final oy = s.height * 0.38;
//     return Offset(
//       ox + (col - row) * (kTW / 2),
//       oy + (col + row) * (kTH / 2),
//     );
//   }

//   // ── Tile type for grid position ──────────────────────────────────────────
//   TileType _tileAt(int c, int r) {
//     // River flows diagonally
//     if ((c == 4 && r >= 5) || (c == 5 && r == 6) || (c == 6 && r == 7)) {
//       return TileType.waterDeep;
//     }
//     if ((c == 3 && r >= 5) || (c == 4 && r == 4 && r >= 4)) {
//       // path tiles
//     }
//     // Stone path between buildings
//     final pathTiles = {
//       const (4, 3),
//       const (4, 4),
//       const (4, 5),
//       const (3, 4),
//       const (5, 4),
//       const (3, 3),
//       const (5, 3),
//       const (2, 3),
//       const (6, 3),
//       const (4, 6),
//       const (4, 7),
//       const (3, 6),
//       const (5, 6),
//     };
//     if (pathTiles.contains((c, r))) return TileType.stonePath;
//     // Alternating grass
//     return (c + r) % 2 == 0 ? TileType.grass : TileType.grassDark;
//   }

//   // ── Draw an iso tile ─────────────────────────────────────────────────────
//   void _drawTile(Canvas canvas, int c, int r, TileType type) {
//     final p = _isoToScreen(c.toDouble(), r.toDouble(), size);
//     final hw = kTW / 2;
//     final hh = kTH / 2;

//     final path = Path()
//       ..moveTo(p.dx, p.dy - hh)
//       ..lineTo(p.dx + hw, p.dy)
//       ..lineTo(p.dx, p.dy + hh)
//       ..lineTo(p.dx - hw, p.dy)
//       ..close();

//     Color top, shadow, border;
//     switch (type) {
//       case TileType.grass:
//         top = const Color(0xFF1E7A35);
//         shadow = const Color(0xFF185C28);
//         border = const Color(0xFF16522A);
//         break;
//       case TileType.grassDark:
//         top = const Color(0xFF1A6A2E);
//         shadow = const Color(0xFF144E22);
//         border = const Color(0xFF124420);
//         break;
//       case TileType.stonePath:
//         top = const Color(0xFF4A5E4A);
//         shadow = const Color(0xFF3A4E3A);
//         border = const Color(0xFF2E3E2E);
//         break;
//       case TileType.water:
//         final wv = 0.5 + 0.5 * math.sin(waterT * math.pi * 2 + c * 0.8);
//         top = Color.lerp(const Color(0xFF1E6A8A), const Color(0xFF2A88AA), wv)!;
//         shadow = const Color(0xFF154E6A);
//         border = const Color(0xFF0E3A50);
//         break;
//       case TileType.waterDeep:
//         final wv = 0.5 + 0.5 * math.sin(waterT * math.pi * 2 + r * 0.6);
//         top = Color.lerp(const Color(0xFF1A5A7A), const Color(0xFF2A7A9A), wv)!;
//         shadow = const Color(0xFF104055);
//         border = const Color(0xFF0A2A3A);
//         break;
//       case TileType.sand:
//         top = const Color(0xFF8A7A4A);
//         shadow = const Color(0xFF6A5A3A);
//         border = const Color(0xFF5A4A2A);
//         break;
//     }

//     // Top face
//     canvas.drawPath(
//         path,
//         Paint()
//           ..color = top
//           ..style = PaintingStyle.fill);
//     // Left face (depth illusion)
//     final leftFace = Path()
//       ..moveTo(p.dx - hw, p.dy)
//       ..lineTo(p.dx, p.dy + hh)
//       ..lineTo(p.dx, p.dy + hh + 6)
//       ..lineTo(p.dx - hw, p.dy + 6)
//       ..close();
//     canvas.drawPath(leftFace, Paint()..color = shadow);
//     // Right face
//     final rightFace = Path()
//       ..moveTo(p.dx + hw, p.dy)
//       ..lineTo(p.dx, p.dy + hh)
//       ..lineTo(p.dx, p.dy + hh + 6)
//       ..lineTo(p.dx + hw, p.dy + 6)
//       ..close();
//     canvas.drawPath(rightFace,
//         Paint()..color = shadow.withGreen((shadow.green * 0.9).toInt()));
//     // Border
//     canvas.drawPath(
//         path,
//         Paint()
//           ..color = border
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 0.5);

//     // Water shimmer line
//     if (type == TileType.waterDeep || type == TileType.water) {
//       final shimmerY = p.dy - hh * 0.3 + math.sin(waterT * math.pi * 2 + c) * 2;
//       canvas.drawLine(
//         Offset(p.dx - hw * 0.5, shimmerY),
//         Offset(p.dx + hw * 0.5, shimmerY),
//         Paint()
//           ..color = Colors.white.withOpacity(0.15)
//           ..strokeWidth = 1.2
//           ..strokeCap = StrokeCap.round,
//       );
//     }
//   }

//   // ── Draw all buildings ────────────────────────────────────────────────────
//   void _drawBuilding(Canvas canvas, JannahBuilding b) {
//     final p = _isoToScreen(b.gridCol.toDouble(), b.gridRow.toDouble(), size);
//     final unlocked = state.isUnlocked(b.id);
//     final float = math.sin(floatT * math.pi) * 2.0;

//     final center = p.translate(0, -float);
//     canvas.save();

//     if (!unlocked) {
//       // Dim locked buildings
//       canvas.saveLayer(null, Paint()..color = Colors.black.withOpacity(0.0));
//     }

//     switch (b.type) {
//       case BuildingType.sprout:
//         _drawSprout(canvas, center, unlocked);
//         break;
//       case BuildingType.mosque:
//         _drawMosque(canvas, center, unlocked);
//         break;
//       case BuildingType.quranPavilion:
//         _drawPavilion(canvas, center, unlocked);
//         break;
//       case BuildingType.fountain:
//         _drawFountain(canvas, center, unlocked, waterT);
//         break;
//       case BuildingType.dateTree:
//         _drawDateTree(canvas, center, unlocked, floatT);
//         break;
//       case BuildingType.lanternPost:
//         _drawLantern(canvas, center, unlocked, floatT);
//         break;
//       case BuildingType.bridge:
//         _drawBridge(canvas, center, unlocked);
//         break;
//       case BuildingType.cottage:
//         _drawCottage(canvas, center, unlocked);
//         break;
//       case BuildingType.goldenTree:
//         _drawGoldenTree(canvas, center, unlocked, floatT);
//         break;
//       case BuildingType.palace:
//         _drawPalace(canvas, center, unlocked, floatT);
//         break;
//     }

//     if (!unlocked) {
//       // Locked fog overlay
//       final fogOpacity = 0.55 + 0.2 * math.sin(pulseT * math.pi);
//       canvas.restore();
//       _drawLockedFog(canvas, center, fogOpacity);
//     }

//     canvas.restore();
//   }

//   // ─── Individual building drawers ──────────────────────────────────────────

//   void _drawSprout(Canvas canvas, Offset c, bool unlocked) {
//     final color = unlocked ? const Color(0xFF2ECC5A) : const Color(0xFF1A4A1A);
//     // Mound
//     canvas.drawOval(
//       Rect.fromCenter(center: c.translate(0, 4), width: 28, height: 12),
//       Paint()..color = const Color(0xFF1A5C2A),
//     );
//     if (!unlocked) return;
//     // Stem
//     canvas.drawLine(
//       c.translate(0, 4),
//       c.translate(0, -8),
//       Paint()
//         ..color = color
//         ..strokeWidth = 2.5
//         ..strokeCap = StrokeCap.round,
//     );
//     // Left leaf
//     final leafPath = Path()
//       ..moveTo(c.dx, c.dy - 4)
//       ..quadraticBezierTo(c.dx - 12, c.dy - 14, c.dx - 6, c.dy - 18)
//       ..quadraticBezierTo(c.dx - 2, c.dy - 10, c.dx, c.dy - 4);
//     canvas.drawPath(leafPath, Paint()..color = color);
//     // Right leaf
//     final leafPath2 = Path()
//       ..moveTo(c.dx, c.dy - 6)
//       ..quadraticBezierTo(c.dx + 10, c.dy - 14, c.dx + 5, c.dy - 20)
//       ..quadraticBezierTo(c.dx + 1, c.dy - 10, c.dx, c.dy - 6);
//     canvas.drawPath(leafPath2, Paint()..color = color.withGreen(180));
//   }

//   void _drawMosque(Canvas canvas, Offset c, bool unlocked) {
//     final wallC = unlocked ? const Color(0xFFE8D5B0) : const Color(0xFF2A2A1A);
//     final domeC = unlocked ? const Color(0xFF2EA868) : const Color(0xFF1A3A1A);
//     final accentC =
//         unlocked ? const Color(0xFFD4A843) : const Color(0xFF2A2A1A);

//     // Base platform
//     final platform = Path()
//       ..moveTo(c.dx, c.dy - 6)
//       ..lineTo(c.dx + 22, c.dy + 5)
//       ..lineTo(c.dx + 22, c.dy + 10)
//       ..lineTo(c.dx, c.dy + 4)
//       ..lineTo(c.dx - 22, c.dy + 10)
//       ..lineTo(c.dx - 22, c.dy + 5)
//       ..close();
//     canvas.drawPath(platform, Paint()..color = const Color(0xFF3A4A3A));

//     // Main building body (iso box)
//     _drawIsoBox(canvas, c.translate(0, -4), 38, 28, wallC,
//         const Color(0xFFB8A880), const Color(0xFFD0BC90));

//     // Central dome
//     final domeRect =
//         Rect.fromCenter(center: c.translate(0, -28), width: 24, height: 22);
//     canvas.drawArc(
//         domeRect,
//         math.pi,
//         math.pi,
//         false,
//         Paint()
//           ..color = domeC
//           ..style = PaintingStyle.fill);
//     canvas.drawArc(
//         domeRect,
//         math.pi,
//         math.pi,
//         false,
//         Paint()
//           ..color = accentC
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 1.5);

//     // Minaret left
//     _drawIsoBox(canvas, c.translate(-16, -8), 8, 40, wallC,
//         const Color(0xFFB8A880), const Color(0xFFD0BC90));
//     // Minaret tip
//     canvas.drawCircle(c.translate(-16, -30), 3, Paint()..color = accentC);

//     // Minaret right
//     _drawIsoBox(canvas, c.translate(16, -8), 8, 40, wallC,
//         const Color(0xFFB8A880), const Color(0xFFD0BC90));
//     canvas.drawCircle(c.translate(16, -30), 3, Paint()..color = accentC);

//     // Glow if unlocked
//     if (unlocked) {
//       canvas.drawCircle(
//         c.translate(0, -25),
//         18,
//         Paint()
//           ..color = accentC.withOpacity(0.12)
//           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
//       );
//     }
//   }

//   void _drawPavilion(Canvas canvas, Offset c, bool unlocked) {
//     final postC = unlocked ? const Color(0xFFD4B870) : const Color(0xFF2A2A1A);
//     final roofC = unlocked ? const Color(0xFF4A9A6A) : const Color(0xFF1A2A1A);
//     final roofC2 = unlocked ? const Color(0xFF2A7A4A) : const Color(0xFF141E14);

//     // 4 columns
//     for (final dx in [-12.0, -4.0, 4.0, 12.0]) {
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromCenter(center: c.translate(dx, -14), width: 4, height: 28),
//           const Radius.circular(2),
//         ),
//         Paint()..color = postC,
//       );
//     }
//     // Roof — pagoda style
//     final roof1 = Path()
//       ..moveTo(c.dx, c.dy - 40)
//       ..lineTo(c.dx + 22, c.dy - 26)
//       ..lineTo(c.dx - 22, c.dy - 26)
//       ..close();
//     canvas.drawPath(roof1, Paint()..color = roofC);
//     final roof2 = Path()
//       ..moveTo(c.dx, c.dy - 32)
//       ..lineTo(c.dx + 28, c.dy - 20)
//       ..lineTo(c.dx - 28, c.dy - 20)
//       ..close();
//     canvas.drawPath(roof2, Paint()..color = roofC2);
//     // Floor
//     canvas.drawOval(
//       Rect.fromCenter(center: c.translate(0, 2), width: 36, height: 14),
//       Paint()..color = const Color(0xFF3A4A3A),
//     );
//     // Open book shape on floor
//     if (unlocked) {
//       final bookPath = Path()
//         ..moveTo(c.dx, c.dy)
//         ..lineTo(c.dx - 8, c.dy - 4)
//         ..lineTo(c.dx - 8, c.dy + 4)
//         ..lineTo(c.dx, c.dy + 2)
//         ..lineTo(c.dx + 8, c.dy - 4)
//         ..lineTo(c.dx + 8, c.dy + 4)
//         ..close();
//       canvas.drawPath(bookPath, Paint()..color = const Color(0xFFE8D0A0));
//       canvas.drawLine(
//           c.translate(0, -4),
//           c.translate(0, 4),
//           Paint()
//             ..color = const Color(0xFFB8A070)
//             ..strokeWidth = 1);
//     }
//   }

//   void _drawFountain(Canvas canvas, Offset c, bool unlocked, double wT) {
//     final basinC = unlocked ? const Color(0xFF5A7A8A) : const Color(0xFF2A3A3A);
//     final waterC = unlocked ? const Color(0xFF38BDF8) : const Color(0xFF1A3A4A);

//     // Basin outer
//     canvas.drawOval(
//       Rect.fromCenter(center: c.translate(0, 4), width: 36, height: 16),
//       Paint()..color = basinC,
//     );
//     // Basin inner water
//     canvas.drawOval(
//       Rect.fromCenter(center: c.translate(0, 3), width: 26, height: 11),
//       Paint()..color = waterC.withOpacity(0.8),
//     );
//     // Center pillar
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//           Rect.fromCenter(center: c.translate(0, -6), width: 6, height: 18),
//           const Radius.circular(3)),
//       Paint()..color = const Color(0xFF6A8A9A),
//     );
//     if (!unlocked) return;
//     // Animated water arc
//     final arcH = 12.0 + 4 * math.sin(wT * math.pi * 2);
//     final waterArc = Path()
//       ..moveTo(c.dx, c.dy - 14)
//       ..quadraticBezierTo(c.dx + 8, c.dy - 14 - arcH, c.dx + 10, c.dy);
//     canvas.drawPath(
//       waterArc,
//       Paint()
//         ..color = waterC.withOpacity(0.7)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 2.5
//         ..strokeCap = StrokeCap.round,
//     );
//     final waterArc2 = Path()
//       ..moveTo(c.dx, c.dy - 14)
//       ..quadraticBezierTo(c.dx - 8, c.dy - 14 - arcH, c.dx - 10, c.dy);
//     canvas.drawPath(
//       waterArc2,
//       Paint()
//         ..color = waterC.withOpacity(0.7)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 2.5
//         ..strokeCap = StrokeCap.round,
//     );
//     // Water glow
//     canvas.drawCircle(
//       c.translate(0, -5),
//       10,
//       Paint()
//         ..color = waterC.withOpacity(0.15)
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
//     );
//   }

//   void _drawDateTree(Canvas canvas, Offset c, bool unlocked, double fT) {
//     final trunkC = unlocked ? const Color(0xFF8B5E3C) : const Color(0xFF2A1A0A);
//     final leafC = unlocked ? const Color(0xFF2ECC6A) : const Color(0xFF1A2A1A);
//     final sway = math.sin(fT * math.pi) * 3;

//     // Trunk (slightly curved)
//     final trunk = Path()
//       ..moveTo(c.dx - 3, c.dy + 6)
//       ..quadraticBezierTo(
//           c.dx - 1 + sway * 0.2, c.dy - 20, c.dx + sway, c.dy - 44)
//       ..lineTo(c.dx + 4 + sway, c.dy - 44)
//       ..quadraticBezierTo(c.dx + 3 + sway * 0.2, c.dy - 20, c.dx + 4, c.dy + 6)
//       ..close();
//     canvas.drawPath(trunk, Paint()..color = trunkC);

//     if (!unlocked) return;

//     // Palm fronds (swaying)
//     final frondAngles = [-0.8, -0.3, 0.1, 0.5, 0.9, 1.3];
//     for (final angle in frondAngles) {
//       final swayAngle = angle + sway * 0.05;
//       final ex = c.dx + sway + math.cos(swayAngle) * 24;
//       final ey = c.dy - 44 + math.sin(swayAngle) * 12;
//       final frond = Path()
//         ..moveTo(c.dx + sway, c.dy - 44)
//         ..quadraticBezierTo(
//           c.dx + sway + math.cos(swayAngle) * 12,
//           c.dy - 44 + math.sin(swayAngle) * 6 - 4,
//           ex,
//           ey,
//         );
//       canvas.drawPath(
//         frond,
//         Paint()
//           ..color = leafC
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 3.5
//           ..strokeCap = StrokeCap.round,
//       );
//     }
//     // Dates (small circles)
//     for (int i = 0; i < 5; i++) {
//       canvas.drawCircle(
//         Offset(c.dx + sway + (i - 2) * 3, c.dy - 40),
//         2.5,
//         Paint()..color = const Color(0xFFD4A843),
//       );
//     }
//   }

//   void _drawLantern(Canvas canvas, Offset c, bool unlocked, double fT) {
//     final postC = unlocked ? const Color(0xFF7A6A4A) : const Color(0xFF2A2A1A);
//     final glowC = unlocked ? const Color(0xFFFFD070) : const Color(0xFF2A2A1A);
//     final pulse = 0.7 + 0.3 * math.sin(fT * math.pi * 2);

//     // Post
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//           Rect.fromCenter(center: c.translate(0, -8), width: 5, height: 28),
//           const Radius.circular(2)),
//       Paint()..color = postC,
//     );
//     // Base
//     canvas.drawOval(
//         Rect.fromCenter(center: c.translate(0, 4), width: 18, height: 8),
//         Paint()..color = const Color(0xFF3A3A2A));

//     if (!unlocked) return;

//     // Lantern head
//     final lanternRect =
//         Rect.fromCenter(center: c.translate(0, -28), width: 14, height: 16);
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(lanternRect, const Radius.circular(3)),
//       Paint()..color = glowC.withOpacity(0.9 * pulse),
//     );
//     // Glow
//     canvas.drawCircle(
//       c.translate(0, -28),
//       16 * pulse,
//       Paint()
//         ..color = glowC.withOpacity(0.25 * pulse)
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
//     );
//     // Top hook
//     canvas.drawLine(
//       c.translate(0, -36),
//       c.translate(0, -42),
//       Paint()
//         ..color = postC
//         ..strokeWidth = 2,
//     );
//   }

//   void _drawBridge(Canvas canvas, Offset c, bool unlocked) {
//     final stoneC = unlocked ? const Color(0xFF7A7A6A) : const Color(0xFF2A2A2A);
//     final archC = unlocked ? const Color(0xFF6A6A5A) : const Color(0xFF1A1A1A);

//     // Bridge deck
//     final deck = Path()
//       ..moveTo(c.dx - 26, c.dy - 2)
//       ..lineTo(c.dx + 26, c.dy - 2)
//       ..lineTo(c.dx + 22, c.dy + 8)
//       ..lineTo(c.dx - 22, c.dy + 8)
//       ..close();
//     canvas.drawPath(deck, Paint()..color = stoneC);

//     // Arch below deck
//     final archRect =
//         Rect.fromCenter(center: c.translate(0, 6), width: 28, height: 18);
//     canvas.drawArc(
//         archRect,
//         0,
//         math.pi,
//         false,
//         Paint()
//           ..color = archC
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 5);

//     // Railings
//     for (final dx in [-18.0, -10.0, -2.0, 6.0, 14.0, 22.0]) {
//       canvas.drawLine(
//         Offset(c.dx + dx, c.dy - 2),
//         Offset(c.dx + dx, c.dy - 12),
//         Paint()
//           ..color = stoneC.withGreen((stoneC.green * 0.85).toInt())
//           ..strokeWidth = 2.5,
//       );
//     }
//     // Top rail
//     canvas.drawLine(
//       Offset(c.dx - 22, c.dy - 12),
//       Offset(c.dx + 26, c.dy - 12),
//       Paint()
//         ..color = stoneC
//         ..strokeWidth = 3,
//     );
//   }

//   void _drawCottage(Canvas canvas, Offset c, bool unlocked) {
//     final wallC = unlocked ? const Color(0xFFD4C090) : const Color(0xFF2A2A1A);
//     final roofC = unlocked ? const Color(0xFFA84848) : const Color(0xFF2A1A1A);
//     final windowC =
//         unlocked ? const Color(0xFF88CCF0) : const Color(0xFF1A1A2A);

//     // Wall box
//     _drawIsoBox(canvas, c.translate(0, -2), 44, 26, wallC,
//         const Color(0xFFB8A878), const Color(0xFFC8B888));

//     // Triangular roof
//     final roof = Path()
//       ..moveTo(c.dx, c.dy - 32)
//       ..lineTo(c.dx + 26, c.dy - 18)
//       ..lineTo(c.dx - 26, c.dy - 18)
//       ..close();
//     canvas.drawPath(roof, Paint()..color = roofC);
//     canvas.drawPath(
//       roof,
//       Paint()
//         ..color = const Color(0xFF882828)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 1,
//     );

//     // Windows
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//           Rect.fromCenter(center: c.translate(-10, -8), width: 9, height: 9),
//           const Radius.circular(1)),
//       Paint()..color = windowC,
//     );
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//           Rect.fromCenter(center: c.translate(10, -8), width: 9, height: 9),
//           const Radius.circular(1)),
//       Paint()..color = windowC,
//     );
//     // Window cross
//     canvas.drawLine(
//         Offset(c.dx - 10, c.dy - 12),
//         Offset(c.dx - 10, c.dy - 4),
//         Paint()
//           ..color = wallC
//           ..strokeWidth = 1);
//     canvas.drawLine(
//         Offset(c.dx - 14, c.dy - 8),
//         Offset(c.dx - 6, c.dy - 8),
//         Paint()
//           ..color = wallC
//           ..strokeWidth = 1);

//     // Door
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//           Rect.fromCenter(center: c.translate(0, -2), width: 8, height: 12),
//           const Radius.circular(4)),
//       Paint()..color = const Color(0xFF8B5E3C),
//     );

//     // Chimney
//     _drawIsoBox(canvas, c.translate(14, -30), 8, 14, wallC,
//         const Color(0xFFB8A878), const Color(0xFFC8B888));

//     if (unlocked) {
//       // Smoke particles
//       for (int i = 0; i < 3; i++) {
//         canvas.drawCircle(
//           c.translate(14 + math.sin(i * 1.2) * 4, -42 - i * 5),
//           3.0 - i * 0.5,
//           Paint()..color = Colors.white.withOpacity(0.12 - i * 0.03),
//         );
//       }
//     }
//   }

//   void _drawGoldenTree(Canvas canvas, Offset c, bool unlocked, double fT) {
//     final trunkC = unlocked ? const Color(0xFFD4A843) : const Color(0xFF2A2A0A);
//     final leafC = unlocked ? const Color(0xFFFFD700) : const Color(0xFF2A2A1A);
//     final sway = math.sin(fT * math.pi) * 2;

//     // Trunk
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//           Rect.fromCenter(
//               center: c.translate(sway * 0.1, -18), width: 6, height: 38),
//           const Radius.circular(3)),
//       Paint()..color = trunkC,
//     );

//     if (!unlocked) return;

//     // Golden foliage layers
//     for (int layer = 0; layer < 3; layer++) {
//       final r = 18.0 - layer * 4;
//       final y = -36.0 - layer * 10 + sway;
//       canvas.drawCircle(
//         c.translate(sway * (layer * 0.2), y),
//         r,
//         Paint()
//           ..color = leafC.withOpacity(0.85 - layer * 0.15)
//           ..maskFilter =
//               layer == 0 ? const MaskFilter.blur(BlurStyle.normal, 3) : null,
//       );
//     }

//     // Radiating glow
//     canvas.drawCircle(
//       c.translate(0, -46),
//       24,
//       Paint()
//         ..color = leafC.withOpacity(0.2)
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
//     );

//     // Star points
//     for (int i = 0; i < 6; i++) {
//       final angle = i * math.pi / 3 + fT * 0.5;
//       final r2 = 20.0 + 4 * math.sin(fT * math.pi + i);
//       canvas.drawLine(
//         c.translate(0, -46 + sway),
//         c.translate(
//             math.cos(angle) * r2, -46 + sway + math.sin(angle) * r2 * 0.5),
//         Paint()
//           ..color = leafC.withOpacity(0.6)
//           ..strokeWidth = 1.5
//           ..strokeCap = StrokeCap.round,
//       );
//     }
//   }

//   void _drawPalace(Canvas canvas, Offset c, bool unlocked, double fT) {
//     final wallC = unlocked ? const Color(0xFFF0E8D0) : const Color(0xFF2A2A1A);
//     final domeC = unlocked ? const Color(0xFF2ECC88) : const Color(0xFF1A2A1A);
//     final goldC = unlocked ? const Color(0xFFD4A843) : const Color(0xFF2A2A1A);
//     final glow = 0.15 + 0.08 * math.sin(fT * math.pi);

//     // Base platform (wide)
//     _drawIsoBox(canvas, c.translate(0, 4), 60, 10, const Color(0xFF4A5A3A),
//         const Color(0xFF3A4A2A), const Color(0xFF3A4A2A));

//     // Main body
//     _drawIsoBox(canvas, c.translate(0, -6), 48, 32, wallC,
//         const Color(0xFFD0C8A8), const Color(0xFFE0D8B8));

//     // Side wings
//     _drawIsoBox(canvas, c.translate(-28, -2), 18, 22, wallC,
//         const Color(0xFFD0C8A8), const Color(0xFFE0D8B8));
//     _drawIsoBox(canvas, c.translate(28, -2), 18, 22, wallC,
//         const Color(0xFFD0C8A8), const Color(0xFFE0D8B8));

//     // Central large dome
//     final mainDomeRect =
//         Rect.fromCenter(center: c.translate(0, -34), width: 34, height: 30);
//     canvas.drawArc(
//         mainDomeRect, math.pi, math.pi, false, Paint()..color = domeC);
//     canvas.drawArc(
//         mainDomeRect,
//         math.pi,
//         math.pi,
//         false,
//         Paint()
//           ..color = goldC
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 2);

//     // Side minarets + domes
//     for (final dx in [-18.0, 18.0]) {
//       _drawIsoBox(canvas, c.translate(dx, -16), 8, 36, wallC,
//           const Color(0xFFD0C8A8), const Color(0xFFE0D8B8));
//       final sdRect =
//           Rect.fromCenter(center: c.translate(dx, -38), width: 14, height: 12);
//       canvas.drawArc(sdRect, math.pi, math.pi, false, Paint()..color = domeC);
//       // Finial
//       canvas.drawLine(
//         c.translate(dx, -44),
//         c.translate(dx, -50),
//         Paint()
//           ..color = goldC
//           ..strokeWidth = 2,
//       );
//       canvas.drawCircle(c.translate(dx, -52), 3, Paint()..color = goldC);
//     }

//     // Windows — arched
//     for (final dx in [-14.0, 0.0, 14.0]) {
//       final wRect =
//           Rect.fromCenter(center: c.translate(dx, -14), width: 7, height: 10);
//       canvas.drawRRect(
//         RRect.fromRectAndCorners(
//           Rect.fromCenter(center: c.translate(dx, -14), width: 7, height: 10),
//           topLeft: const Radius.circular(4),
//           topRight: const Radius.circular(4),
//         ),
//         Paint()..color = const Color(0xFF88CCEE),
//       );
//     }

//     if (!unlocked) return;

//     // Palace glow halo
//     canvas.drawCircle(
//       c.translate(0, -30),
//       36,
//       Paint()
//         ..color = goldC.withOpacity(glow)
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
//     );

//     // Floating gold particles
//     for (int i = 0; i < 8; i++) {
//       final angle = i * math.pi / 4 + fT * math.pi * 0.5;
//       final r = 28.0 + 6 * math.sin(fT * math.pi + i * 0.7);
//       canvas.drawCircle(
//         c.translate(math.cos(angle) * r, -30 + math.sin(angle) * r * 0.4),
//         2.5,
//         Paint()
//           ..color = goldC.withOpacity(0.5 + 0.4 * math.sin(fT * math.pi + i)),
//       );
//     }
//   }

//   // ── Iso box helper (3 faces) ──────────────────────────────────────────────
//   void _drawIsoBox(Canvas canvas, Offset c, double w, double h, Color top,
//       Color left, Color right) {
//     final hw = w / 2;
//     // Top face (flat, slightly angled for iso feel)
//     canvas.drawRect(
//       Rect.fromCenter(center: c.translate(0, -h / 2), width: w, height: 8),
//       Paint()..color = top,
//     );
//     // Front face
//     canvas.drawRect(
//       Rect.fromCenter(center: c, width: w, height: h),
//       Paint()..color = left,
//     );
//     // Right shading
//     canvas.drawRect(
//       Rect.fromLTWH(c.dx + hw - 4, c.dy - h / 2, 4, h),
//       Paint()..color = right,
//     );
//   }

//   void _drawLockedFog(Canvas canvas, Offset c, double opacity) {
//     // Dark pulsing fog around locked buildings
//     canvas.drawCircle(
//       c.translate(0, -10),
//       34,
//       Paint()
//         ..color = Colors.black.withOpacity(opacity * 0.5)
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
//     );
//     // Lock icon (simple drawn)
//     final lockBody =
//         Rect.fromCenter(center: c.translate(0, -8), width: 14, height: 12);
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(lockBody, const Radius.circular(2)),
//       Paint()..color = Colors.white.withOpacity(opacity * 0.3),
//     );
//     canvas.drawArc(
//       Rect.fromCenter(center: c.translate(0, -16), width: 10, height: 10),
//       math.pi,
//       math.pi,
//       false,
//       Paint()
//         ..color = Colors.white.withOpacity(opacity * 0.3)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 2.5,
//     );
//   }

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Draw tiles bottom-first for correct iso layering
//     for (int r = 0; r < kRows; r++) {
//       for (int c2 = 0; c2 < kCols; c2++) {
//         _drawTile(canvas, c2, r, _tileAt(c2, r));
//       }
//     }

//     // Draw buildings sorted by depth (higher row = drawn later = in front)
//     final sorted = List<JannahBuilding>.from(kBuildings)
//       ..sort(
//           (a, b) => (a.gridCol + a.gridRow).compareTo(b.gridCol + b.gridRow));
//     for (final b in sorted) {
//       _drawBuilding(canvas, b);
//     }
//   }

//   @override
//   bool shouldRepaint(_JannahWorldPainter old) =>
//       old.waterT != waterT ||
//       old.floatT != floatT ||
//       old.pulseT != pulseT ||
//       old.state.unlockedIds != state.unlockedIds;
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // SECTION 5 — TAP LAYER (transparent hit areas over each building)
// // ═══════════════════════════════════════════════════════════════════════════

// class _TapLayer extends StatelessWidget {
//   final JannahWorldState state;
//   final Size size;
//   final void Function(JannahBuilding) onTap;

//   const _TapLayer(
//       {required this.state, required this.size, required this.onTap});

//   Offset _isoToScreen(double col, double row) {
//     const kTW = 72.0;
//     const kTH = 36.0;
//     final ox = size.width / 2;
//     final oy = size.height * 0.38;
//     return Offset(ox + (col - row) * (kTW / 2), oy + (col + row) * (kTH / 2));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: kBuildings.map((b) {
//         final p = _isoToScreen(b.gridCol.toDouble(), b.gridRow.toDouble());
//         return Positioned(
//           left: p.dx - 30,
//           top: p.dy - 55,
//           width: 60,
//           height: 70,
//           child: GestureDetector(
//             onTap: () => onTap(b),
//             child: Container(color: Colors.transparent),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // SECTION 6 — SKY PAINTER
// // ═══════════════════════════════════════════════════════════════════════════

// class _SkyPainter extends CustomPainter {
//   final double t;
//   _SkyPainter({required this.t});

//   static final _rng = math.Random(42);
//   static final _stars = List.generate(
//       80,
//       (_) => [
//             _rng.nextDouble(),
//             _rng.nextDouble() * 0.45,
//             _rng.nextDouble() * 1.8 + 0.3,
//             _rng.nextDouble() * math.pi * 2,
//           ]);

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Sky gradient
//     canvas.drawRect(
//       Offset.zero & size,
//       Paint()
//         ..shader = const LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             Color(0xFF020C06),
//             Color(0xFF061A0C),
//             Color(0xFF0D2E14),
//             Color(0xFF1A5C2A)
//           ],
//           stops: [0, 0.3, 0.65, 1],
//         ).createShader(Offset.zero & size),
//     );

//     // Moon
//     canvas.drawCircle(
//       Offset(size.width * 0.78, size.height * 0.12),
//       18,
//       Paint()..color = const Color(0xFFE8E0C8),
//     );
//     canvas.drawCircle(
//       Offset(size.width * 0.78 + 6, size.height * 0.12 - 2),
//       14,
//       Paint()..color = const Color(0xFF061A0C),
//     );

//     // Stars
//     final p = Paint();
//     for (final s in _stars) {
//       final o = 0.2 + 0.65 * math.sin(s[3] + t * math.pi * 2).abs();
//       p.color = Colors.white.withOpacity(o.clamp(0.05, 0.9));
//       canvas.drawCircle(Offset(s[0] * size.width, s[1] * size.height), s[2], p);
//     }
//   }

//   @override
//   bool shouldRepaint(_SkyPainter old) => old.t != t;
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // SECTION 7 — UI OVERLAYS
// // ═══════════════════════════════════════════════════════════════════════════

// // ── Top HUD ──────────────────────────────────────────────────────────────────

// class _TopHUD extends StatelessWidget {
//   final JannahWorldState state;
//   final bool isLoading;
//   const _TopHUD({required this.state, required this.isLoading});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
//       child: Row(children: [
//         // Title block
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text('আমার জান্নাত',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 19,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: -0.4,
//                     shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
//                   )),
//               Text(
//                 isLoading
//                     ? 'লোড হচ্ছে...'
//                     : '${state.unlockedIds.length} / ${kBuildings.length} স্থাপনা উন্মুক্ত',
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.55),
//                   fontSize: 11,
//                   shadows: const [Shadow(color: Colors.black54, blurRadius: 6)],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         _HUDChip(
//           label: '${state.streakDays} দিন',
//           icon: Icons.local_fire_department_rounded,
//           color: const Color(0xFFFF6B35),
//         ),
//         const SizedBox(width: 7),
//         _HUDChip(
//           label: '${state.totalPoints} pts',
//           icon: Icons.stars_rounded,
//           color: const Color(0xFFD4A843),
//         ),
//         const SizedBox(width: 7),
//         _HUDChip(
//           label: '${state.completionPct.toInt()}%',
//           icon: Icons.pie_chart_rounded,
//           color: const Color(0xFF2ECC88),
//         ),
//       ]),
//     );
//   }
// }

// class _HUDChip extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final Color color;
//   const _HUDChip(
//       {required this.label, required this.icon, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.55),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color.withOpacity(0.4), width: 0.5),
//       ),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [
//         Icon(icon, size: 11, color: color),
//         const SizedBox(width: 4),
//         Text(label,
//             style: TextStyle(
//                 color: color, fontSize: 10.5, fontWeight: FontWeight.w700)),
//       ]),
//     );
//   }
// }

// // ── Bottom bar ────────────────────────────────────────────────────────────────

// class _BottomProgressBar extends StatelessWidget {
//   final JannahWorldState state;
//   const _BottomProgressBar({required this.state});

//   @override
//   Widget build(BuildContext context) {
//     final next = state.nextBuilding;
//     final pad = MediaQuery.of(context).padding.bottom;

//     return Container(
//       padding: EdgeInsets.fromLTRB(16, 12, 16, pad + 14),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.75),
//         border: Border(
//             top: BorderSide(color: Colors.white.withOpacity(0.08), width: 0.5)),
//       ),
//       child: next == null
//           ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//               Icon(Icons.celebration_rounded,
//                   color: Color(0xFFD4A843), size: 16),
//               SizedBox(width: 8),
//               Text('মাশাআল্লাহ! জান্নাত পরিপূর্ণ হয়েছে 🌟',
//                   style: TextStyle(
//                       color: Color(0xFFD4A843),
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600)),
//             ])
//           : Column(mainAxisSize: MainAxisSize.min, children: [
//               Row(children: [
//                 Expanded(
//                   child: Text(
//                     'পরবর্তী: ${next.nameBn}',
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600),
//                   ),
//                 ),
//                 Text(
//                   state.pointsToNext > 0
//                       ? 'আরও ${state.pointsToNext} pts'
//                       : 'অন্য শর্ত বাকি',
//                   style: const TextStyle(
//                       color: Color(0xFFD4A843),
//                       fontSize: 11,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ]),
//               const SizedBox(height: 6),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(99),
//                 child: LinearProgressIndicator(
//                   value: state.progressToNext,
//                   minHeight: 6,
//                   backgroundColor: Colors.white.withOpacity(0.1),
//                   valueColor: const AlwaysStoppedAnimation(Color(0xFFD4A843)),
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 next.howBn,
//                 style: TextStyle(
//                     color: Colors.white.withOpacity(0.45), fontSize: 10),
//               ),
//             ]),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // SECTION 8 — BUILDING DETAIL SHEETS
// // ═══════════════════════════════════════════════════════════════════════════

// class _UnlockedBuildingSheet extends StatelessWidget {
//   final JannahBuilding building;
//   const _UnlockedBuildingSheet({required this.building});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF0A1E0E),
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: const Color(0xFF163320), width: 0.5),
//       ),
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         // Handle
//         Padding(
//           padding: const EdgeInsets.only(top: 10),
//           child: Container(
//             width: 36,
//             height: 4,
//             decoration: BoxDecoration(
//               color: const Color(0xFF163320),
//               borderRadius: BorderRadius.circular(99),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
//           child: Column(mainAxisSize: MainAxisSize.min, children: [
//             // Building mini-canvas preview
//             Container(
//               height: 100,
//               decoration: BoxDecoration(
//                 gradient: const RadialGradient(
//                   colors: [Color(0xFF0D3A1A), Color(0xFF061209)],
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Center(
//                 child: CustomPaint(
//                   size: const Size(200, 100),
//                   painter: _BuildingPreviewPainter(type: building.type),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 14),

//             Text(building.nameBn,
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700)),
//             const SizedBox(height: 6),
//             Text(building.descBn,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     color: Colors.white.withOpacity(0.55), fontSize: 13)),
//             const SizedBox(height: 14),

//             // Unlocked badge
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF16A34A).withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(12),
//                 border:
//                     Border.all(color: const Color(0xFF16A34A).withOpacity(0.4)),
//               ),
//               child: Row(mainAxisSize: MainAxisSize.min, children: [
//                 const Icon(Icons.check_circle_rounded,
//                     color: Color(0xFF16A34A), size: 16),
//                 const SizedBox(width: 8),
//                 Text(building.howBn,
//                     style: const TextStyle(
//                         color: Color(0xFF16A34A),
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600)),
//               ]),
//             ),
//           ]),
//         ),
//       ]),
//     );
//   }
// }

// class _LockedBuildingSheet extends StatelessWidget {
//   final JannahBuilding building;
//   final JannahWorldState state;
//   const _LockedBuildingSheet({required this.building, required this.state});

//   Widget _row(IconData icon, String label, String cur, String need, bool done) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5),
//       child: Row(children: [
//         Icon(icon,
//             size: 14,
//             color: done ? const Color(0xFF16A34A) : const Color(0xFF4A7A56)),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(label,
//               style: const TextStyle(color: Color(0xFFD4EAD8), fontSize: 12)),
//         ),
//         Text('$cur / $need',
//             style: TextStyle(
//                 color: done ? const Color(0xFF16A34A) : const Color(0xFFD4A843),
//                 fontSize: 11,
//                 fontWeight: FontWeight.w600)),
//       ]),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF0A1E0E),
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: const Color(0xFF163320), width: 0.5),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           Container(
//             width: 36,
//             height: 4,
//             decoration: BoxDecoration(
//               color: const Color(0xFF163320),
//               borderRadius: BorderRadius.circular(99),
//             ),
//           ),
//           const SizedBox(height: 14),

//           // Greyed preview
//           Opacity(
//             opacity: 0.25,
//             child: Container(
//               height: 80,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF061209),
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: Center(
//                 child: CustomPaint(
//                   size: const Size(180, 80),
//                   painter: _BuildingPreviewPainter(type: building.type),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),

//           Text(building.nameBn,
//               style: const TextStyle(
//                   color: Color(0xFFD4EAD8),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700)),
//           const SizedBox(height: 5),
//           Text(building.descBn,
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: Color(0xFF4A7A56), fontSize: 12)),
//           const SizedBox(height: 14),

//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: const Color(0xFF061209),
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(color: const Color(0xFF163320)),
//             ),
//             child: Column(mainAxisSize: MainAxisSize.min, children: [
//               if (building.reqPoints != null)
//                 _row(
//                     Icons.stars_rounded,
//                     'মোট পয়েন্ট',
//                     '${state.totalPoints}',
//                     '${building.reqPoints}',
//                     state.totalPoints >= building.reqPoints!),
//               if (building.reqStreak != null)
//                 _row(
//                     Icons.local_fire_department_rounded,
//                     'ধারাবাহিক দিন',
//                     '${state.streakDays}',
//                     '${building.reqStreak}',
//                     state.streakDays >= building.reqStreak!),
//               if (building.reqPct != null)
//                 _row(
//                     Icons.percent_rounded,
//                     'সমাপ্তি হার',
//                     '${state.completionPct.toInt()}%',
//                     '${building.reqPct!.toInt()}%',
//                     state.completionPct >= building.reqPct!),
//               if (building.reqAmalKey != null)
//                 _row(
//                     Icons.task_alt_rounded,
//                     'আমল: ${building.reqAmalKey}',
//                     '—',
//                     'সম্পন্ন',
//                     state.completedAmalKeys.contains(building.reqAmalKey)),
//             ]),
//           ),
//         ]),
//       ),
//     );
//   }
// }

// // ── Building preview painter (used inside sheets) ─────────────────────────────
// class _BuildingPreviewPainter extends CustomPainter {
//   final BuildingType type;
//   _BuildingPreviewPainter({required this.type});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final c = Offset(size.width / 2, size.height * 0.65);
//     // Reuse the same drawing functions with a smaller canvas
//     final worldPainter = _JannahWorldPainter(
//       state: const JannahWorldState(unlockedIds: {
//         'sprout',
//         'mosque',
//         'pavilion',
//         'fountain',
//         'date_tree',
//         'lantern',
//         'bridge',
//         'cottage',
//         'golden_tree',
//         'palace',
//       }),
//       size: size,
//       waterT: 0.5,
//       floatT: 0.3,
//       pulseT: 0.5,
//       onBuildingTap: (_) {},
//     );
//     canvas.save();
//     canvas.translate(0, 0);
//     switch (type) {
//       case BuildingType.sprout:
//         worldPainter._drawSprout(canvas, c, true);
//         break;
//       case BuildingType.mosque:
//         worldPainter._drawMosque(canvas, c, true);
//         break;
//       case BuildingType.quranPavilion:
//         worldPainter._drawPavilion(canvas, c, true);
//         break;
//       case BuildingType.fountain:
//         worldPainter._drawFountain(canvas, c, true, 0.5);
//         break;
//       case BuildingType.dateTree:
//         worldPainter._drawDateTree(canvas, c, true, 0.3);
//         break;
//       case BuildingType.lanternPost:
//         worldPainter._drawLantern(canvas, c, true, 0.4);
//         break;
//       case BuildingType.bridge:
//         worldPainter._drawBridge(canvas, c, true);
//         break;
//       case BuildingType.cottage:
//         worldPainter._drawCottage(canvas, c, true);
//         break;
//       case BuildingType.goldenTree:
//         worldPainter._drawGoldenTree(canvas, c, true, 0.3);
//         break;
//       case BuildingType.palace:
//         worldPainter._drawPalace(canvas, c, true, 0.3);
//         break;
//     }
//     canvas.restore();
//   }

//   @override
//   bool shouldRepaint(_) => false;
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // SECTION 9 — UNLOCK CELEBRATION
// // ═══════════════════════════════════════════════════════════════════════════

// class _UnlockCelebrationDialog extends StatelessWidget {
//   final JannahBuilding building;
//   const _UnlockCelebrationDialog({required this.building});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: Container(
//         decoration: BoxDecoration(
//           color: const Color(0xFF0A1E0E),
//           borderRadius: BorderRadius.circular(24),
//           border: Border.all(
//               color: const Color(0xFFD4A843).withOpacity(0.6), width: 1.5),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFFD4A843).withOpacity(0.15),
//               blurRadius: 30,
//               spreadRadius: 5,
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(24),
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           // Animated building preview
//           Container(
//             height: 110,
//             decoration: BoxDecoration(
//               gradient: const RadialGradient(
//                 colors: [Color(0xFF1A4A2A), Color(0xFF061209)],
//               ),
//               borderRadius: BorderRadius.circular(18),
//               border:
//                   Border.all(color: const Color(0xFFD4A843).withOpacity(0.3)),
//             ),
//             child: Center(
//               child: CustomPaint(
//                 size: const Size(200, 110),
//                 painter: _BuildingPreviewPainter(type: building.type),
//               ),
//             ),
//           )
//               .animate()
//               .scale(
//                 begin: const Offset(0.3, 0.3),
//                 curve: Curves.elasticOut,
//                 duration: 800.ms,
//               )
//               .fadeIn(duration: 400.ms),
//           const SizedBox(height: 12),

//           const Text('নতুন স্থাপনা উন্মুক্ত!',
//               style: TextStyle(
//                   color: Color(0xFFD4A843),
//                   fontSize: 12,
//                   letterSpacing: 1.5,
//                   fontWeight: FontWeight.w600)),
//           const SizedBox(height: 6),

//           Text(building.nameBn,
//               style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 22,
//                   fontWeight: FontWeight.w800)),
//           const SizedBox(height: 8),

//           Text(building.descBn,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   color: Colors.white.withOpacity(0.55), fontSize: 13)),
//           const SizedBox(height: 20),

//           GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF0E3D22), Color(0xFF1A6A35)],
//                 ),
//                 borderRadius: BorderRadius.circular(14),
//                 border:
//                     Border.all(color: const Color(0xFFD4A843).withOpacity(0.3)),
//               ),
//               child: const Center(
//                 child: Text('আলহামদুলিল্লাহ',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700)),
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // SECTION 10 — UNLOCK PARTICLES
// // ═══════════════════════════════════════════════════════════════════════════

// class _ParticleBurstPainter extends CustomPainter {
//   final double t;
//   _ParticleBurstPainter({required this.t});

//   static final _rng = math.Random(55);
//   static final _particles = List.generate(
//       40,
//       (_) => [
//             (_rng.nextDouble() - 0.5) * 3.0,
//             (_rng.nextDouble() - 0.5) * 3.0,
//             _rng.nextDouble(),
//           ]);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = size.center(Offset.zero);
//     final p = Paint();
//     final eased = Curves.easeOut.transform(t);

//     for (int i = 0; i < _particles.length; i++) {
//       final pt = _particles[i];
//       final dist = eased * 250.0;
//       final opacity = (1 - eased).clamp(0.0, 1.0);
//       final r = 4.0 * (1 - eased * 0.7);
//       final pos = center + Offset(pt[0] * dist, pt[1] * dist);

//       // Gold particles
//       p.color = const Color(0xFFD4A843).withOpacity(opacity * 0.9);
//       canvas.drawCircle(pos, r, p);

//       // White sparkle trails
//       if (i % 3 == 0) {
//         p.color = Colors.white.withOpacity(opacity * 0.5);
//         canvas.drawCircle(
//           center + Offset(pt[0] * dist * 0.6, pt[1] * dist * 0.6),
//           r * 0.5,
//           p,
//         );
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(_ParticleBurstPainter old) => old.t != t;
// }
// ═══════════════════════════════════════════════════════════════════════════
// jannah_world_screen.dart  —  single file, drop anywhere in your project
//
// SETUP (3 steps):
//   1. Add to pubspec.yaml dependencies:  flutter_animate: ^4.5.0  (already there)
//   2. Fix the 2 import paths just below (search "adjust path")
//   3. Add JannahWorldScreen() as a tab in your shell
//
// DATA: 100% from progressSummaryProvider + categoriesProvider — zero mock.
// NO extra packages — only what you already have.
// ═══════════════════════════════════════════════════════════════════════════

// import 'dart:math' as math;
// import 'package:amal_tracker/features/tracker/models/tracker_model.dart';
// import 'package:amal_tracker/features/tracker/providers/tracker_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // ═══════════════════════════════════════════════════════════════════════════
// // 1. DESIGN TOKENS
// // ═══════════════════════════════════════════════════════════════════════════

// class _C {
//   static const bg = Color(0xFF020C06);
//   static const cardBg = Color(0xFF0A1E0E);
//   static const cardBorder = Color(0xFF163320);
//   static const gold = Color(0xFFD4A843);
//   static const goldDim = Color(0xFF6B5220);
//   static const green = Color(0xFF16A34A);
//   static const greenLight = Color(0xFF2ECC88);
//   static const river = Color(0xFF38BDF8);
//   static const fire = Color(0xFFFF6B35);
//   static const white = Colors.white;
//   static const textMuted = Color(0xFF4A7A56);
//   static const textLight = Color(0xFFD4EAD8);
//   static const grassA = Color(0xFF1E7A35);
//   static const grassB = Color(0xFF1A6A2E);
//   static const pathC = Color(0xFF4A5E4A);
//   static const waterC = Color(0xFF1E6A8A);
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // 2. BUILDING DATA
// // ═══════════════════════════════════════════════════════════════════════════

// enum _Tier { seed, small, medium, large, grand }

// enum _Anim { none, float, glow, water, sway, swayHeavy, sparkle, rise, flame }

// class _Building {
//   final String id, nameBn, storyBn, howBn;
//   final _Tier tier;
//   final int col, row;
//   final _Anim anim;
//   final int? reqPts, reqStreak;
//   final double? reqPct;
//   final String? reqKey;

//   const _Building({
//     required this.id,
//     required this.nameBn,
//     required this.storyBn,
//     required this.howBn,
//     required this.tier,
//     required this.col,
//     required this.row,
//     required this.anim,
//     this.reqPts,
//     this.reqStreak,
//     this.reqPct,
//     this.reqKey,
//   });

//   bool metBy(
//           {required int pts,
//           required int streak,
//           required double pct,
//           required Set<String> keys}) =>
//       (reqPts == null || pts >= reqPts!) &&
//       (reqStreak == null || streak >= reqStreak!) &&
//       (reqPct == null || pct >= reqPct!) &&
//       (reqKey == null || keys.contains(reqKey));
// }

// const _kB = <_Building>[
//   _Building(
//       id: 'sprout',
//       nameBn: 'প্রথম চারা',
//       tier: _Tier.seed,
//       storyBn:
//           'প্রতিটি জান্নাতি বাগান একটি ছোট্ট চারা থেকে শুরু হয়।\nআপনার প্রথম আমল এই বীজ বপন করেছে।',
//       howBn: 'যেকোনো ১টি আমল করুন',
//       col: 4,
//       row: 4,
//       anim: _Anim.sway,
//       reqPts: 1),
//   _Building(
//       id: 'mosque',
//       nameBn: 'ফজরের মসজিদ',
//       tier: _Tier.small,
//       storyBn:
//           'নবীজি ﷺ বলেছেন — ফজরের দুই রাকাত সুন্নত দুনিয়া ও তার সব কিছুর চেয়ে উত্তম।\nএই মসজিদ সেই নূরের প্রতীক।',
//       howBn: 'ফজর নামাজ আদায় করুন  +  ১০ pts',
//       col: 3,
//       row: 3,
//       anim: _Anim.glow,
//       reqPts: 10,
//       reqKey: 'fajr'),
//   _Building(
//       id: 'pavilion',
//       nameBn: 'তিলাওয়াতের চত্বর',
//       tier: _Tier.small,
//       storyBn:
//           'কুরআন তিলাওয়াতকারীর সাথে সম্মানিত পুণ্যবান ফেরেশতারা থাকেন।\nএই চত্বরে প্রতিটি আয়াত বাতাসে ভাসে।',
//       howBn: 'কুরআন তিলাওয়াত করুন  +  ২০ pts',
//       col: 6,
//       row: 3,
//       anim: _Anim.float,
//       reqPts: 20,
//       reqKey: 'tilawat'),
//   _Building(
//       id: 'fountain',
//       nameBn: 'জিকিরের ফোয়ারা',
//       tier: _Tier.small,
//       storyBn:
//           'আল্লাহর জিকির হলো সবচেয়ে বড় ইবাদত।\nপ্রতিটি তাসবীহে এই ফোয়ারার পানি আরও উঁচুতে ওঠে।',
//       howBn: 'তাসবীহ / জিকির করুন  +  ৩০ pts',
//       col: 4,
//       row: 6,
//       anim: _Anim.water,
//       reqPts: 30,
//       reqKey: 'tasbih'),
//   _Building(
//       id: 'palm',
//       nameBn: 'কাউসারের খেজুর',
//       tier: _Tier.small,
//       storyBn:
//           '৭ দিন ধারাবাহিক আমলের বিশেষ পুরস্কার।\nজান্নাতের খেজুর গাছ যার নিচে হাজার বছরেও শেষ হয় না।',
//       howBn: '৭ দিন ধারাবাহিক আমল করুন  +  ৩৫ pts',
//       col: 2,
//       row: 5,
//       anim: _Anim.swayHeavy,
//       reqPts: 35,
//       reqStreak: 7),
//   _Building(
//       id: 'lantern',
//       nameBn: 'দরুদের আলো',
//       tier: _Tier.small,
//       storyBn:
//           'যে ব্যক্তি একবার দরুদ পড়ে — আল্লাহ তার উপর ১০টি রহমত নাজিল করেন।\nএই স্তম্ভ সেই নূরের প্রতীক।',
//       howBn: 'দরুদ পড়ুন  +  ৪৮ pts',
//       col: 7,
//       row: 5,
//       anim: _Anim.flame,
//       reqPts: 48,
//       reqKey: 'darud'),
//   _Building(
//       id: 'bridge',
//       nameBn: 'সবরের সেতু',
//       tier: _Tier.medium,
//       storyBn:
//           'রোজাদারের জন্য জান্নাতে রাইয়ান নামক বিশেষ দরজা আছে।\nএই সেতু সেই পথের প্রতীক।',
//       howBn: 'রোজা রাখুন  +  ৬০ pts',
//       col: 4,
//       row: 7,
//       anim: _Anim.water,
//       reqPts: 60,
//       reqKey: 'siyam'),
//   _Building(
//       id: 'cottage',
//       nameBn: 'আমলের ঘর',
//       tier: _Tier.medium,
//       storyBn:
//           '১০ দিন ধারাবাহিক আমলের পুরস্কার।\nজান্নাতে নেককার বান্দার জন্য প্রস্তুত বাসস্থান।',
//       howBn: '১০ দিনের streak ধরুন  +  ৭৫ pts',
//       col: 2,
//       row: 2,
//       anim: _Anim.float,
//       reqPts: 75,
//       reqStreak: 10),
//   _Building(
//       id: 'river',
//       nameBn: 'কাউসার নহর',
//       tier: _Tier.medium,
//       storyBn:
//           'কাউসার হলো জান্নাতের একটি নদী —\nযার পানি দুধের চেয়ে সাদা, মধুর চেয়ে মিষ্টি।',
//       howBn: 'মাসে ৭০%+ আমল সম্পন্ন করুন  +  ৯০ pts',
//       col: 5,
//       row: 6,
//       anim: _Anim.water,
//       reqPts: 90,
//       reqPct: 70),
//   _Building(
//       id: 'tuba',
//       nameBn: 'তুবা গাছ',
//       tier: _Tier.large,
//       storyBn:
//           'তুবা এমন একটি গাছ — এর ছায়ায় একজন ঘোড়সওয়ার ১০০ বছর চলতে পারবে।\nমাসে ৯০% আমলকারীর পুরস্কার।',
//       howBn: 'মাসে ৯০%+ আমল সম্পন্ন করুন  +  ১৩০ pts',
//       col: 7,
//       row: 2,
//       anim: _Anim.sparkle,
//       reqPts: 130,
//       reqPct: 90),
//   _Building(
//       id: 'minaret',
//       nameBn: 'তাহাজ্জুদের মিনার',
//       tier: _Tier.large,
//       storyBn:
//           'রাতের তৃতীয় ভাগে আল্লাহ নেমে আসেন — কে আছ যে চাইবে?\nতাহাজ্জুদ পড়লে এই মিনার থেকে নূর বের হয়।',
//       howBn: 'তাহাজ্জুদ নামাজ আদায় করুন  +  ১৫০ pts',
//       col: 2,
//       row: 7,
//       anim: _Anim.glow,
//       reqPts: 150,
//       reqKey: 'tahajjud'),
//   _Building(
//       id: 'palace',
//       nameBn: 'জান্নাতের মহল',
//       tier: _Tier.grand,
//       storyBn:
//           'যে ব্যক্তি আল্লাহর সন্তুষ্টির জন্য আমল করে —\nআল্লাহ তার জন্য জান্নাতে একটি মহল নির্মাণ করেন।',
//       howBn: '২০০ pts  +  ১৫ দিনের streak',
//       col: 4,
//       row: 1,
//       anim: _Anim.rise,
//       reqPts: 200,
//       reqStreak: 15),
// ];

// // ═══════════════════════════════════════════════════════════════════════════
// // 3. STATE & PROVIDER
// // ═══════════════════════════════════════════════════════════════════════════

// class _JState {
//   final bool isLoading;
//   final int pts, streak;
//   final double pct;
//   final Set<String> keys, unlocked;
//   final String? newId;

//   const _JState({
//     this.isLoading = true,
//     this.pts = 0,
//     this.streak = 0,
//     this.pct = 0,
//     this.keys = const {},
//     this.unlocked = const {},
//     this.newId,
//   });

//   _JState cw(
//           {bool? isLoading,
//           int? pts,
//           int? streak,
//           double? pct,
//           Set<String>? keys,
//           Set<String>? unlocked,
//           String? newId,
//           bool clearNew = false}) =>
//       _JState(
//         isLoading: isLoading ?? this.isLoading,
//         pts: pts ?? this.pts,
//         streak: streak ?? this.streak,
//         pct: pct ?? this.pct,
//         keys: keys ?? this.keys,
//         unlocked: unlocked ?? this.unlocked,
//         newId: clearNew ? null : (newId ?? this.newId),
//       );

//   bool isOpen(String id) => unlocked.contains(id);

//   _Building? get nextB {
//     final locked = _kB.where((b) => !unlocked.contains(b.id)).toList()
//       ..sort((a, b) => (a.reqPts ?? 0).compareTo(b.reqPts ?? 0));
//     return locked.isEmpty ? null : locked.first;
//   }

//   int get ptsToNext => math.max(0, (nextB?.reqPts ?? 0) - pts);

//   double get progToNext {
//     final n = nextB;
//     if (n == null) return 1.0;
//     final needed = n.reqPts ?? 1;
//     final base = unlocked.isEmpty
//         ? 0
//         : _kB
//             .where((b) => unlocked.contains(b.id))
//             .map((b) => b.reqPts ?? 0)
//             .fold<int>(0, math.max);
//     final range = needed - base;
//     if (range <= 0) return 1.0;
//     return ((pts - base) / range).clamp(0.0, 1.0);
//   }
// }

// class _JNotifier extends StateNotifier<_JState> {
//   _JNotifier() : super(const _JState());

//   void sync(ProgressSummary s, List<AmalCategory> cats) {
//     final t = s.currentMonth;
//     final p = t?.totalPoints ?? 0;
//     final str = t?.streakDays ?? 0;
//     final pct = t?.completionPercentage ?? 0.0;

//     final idToKey = {for (final c in cats) c.id: c.key};
//     final done = <String>{};
//     for (final e in (s.todayEntry?.entries ?? [])) {
//       if (e.completed) {
//         final k = idToKey[e.categoryId];
//         if (k != null) done.add(k);
//       }
//     }

//     final prev = state.unlocked;
//     final now = _kB
//         .where((b) => b.metBy(pts: p, streak: str, pct: pct, keys: done))
//         .map((b) => b.id)
//         .toSet();
//     final brandNew = now.difference(prev);

//     state = state.cw(
//       isLoading: false,
//       pts: p,
//       streak: str,
//       pct: pct,
//       keys: done,
//       unlocked: now,
//       newId: brandNew.isNotEmpty ? brandNew.first : null,
//     );
//   }

//   void clearNew() => state = state.cw(clearNew: true);
// }

// final _jProvider = StateNotifierProvider.autoDispose<_JNotifier, _JState>(
//   (_) => _JNotifier(),
// );

// // ═══════════════════════════════════════════════════════════════════════════
// // 4. MAIN SCREEN
// // ═══════════════════════════════════════════════════════════════════════════

// class JannahGardenScreen extends ConsumerStatefulWidget {
//   const JannahGardenScreen({super.key});
//   @override
//   ConsumerState<JannahGardenScreen> createState() => _ScreenState();
// }

// class _ScreenState extends ConsumerState<JannahGardenScreen>
//     with TickerProviderStateMixin {
//   late final AnimationController _sky =
//       AnimationController(vsync: this, duration: const Duration(seconds: 10))
//         ..repeat();
//   late final AnimationController _water =
//       AnimationController(vsync: this, duration: const Duration(seconds: 2))
//         ..repeat();
//   late final AnimationController _float =
//       AnimationController(vsync: this, duration: const Duration(seconds: 5))
//         ..repeat(reverse: true);
//   late final AnimationController _pulse =
//       AnimationController(vsync: this, duration: const Duration(seconds: 3))
//         ..repeat(reverse: true);
//   late final AnimationController _burst = AnimationController(
//       vsync: this, duration: const Duration(milliseconds: 1400));

//   final _txCtrl = TransformationController();

//   // View mode: 'world' or 'list'
//   String _view = 'world';

//   _Building? _sheetB;
//   bool _sheetOpen = false;

//   // Hint visibility
//   bool _showHint = true;

//   @override
//   void initState() {
//     super.initState();
//     // Hide hint after 5 seconds
//     Future.delayed(const Duration(seconds: 5), () {
//       if (mounted) setState(() => _showHint = false);
//     });
//   }

//   @override
//   void dispose() {
//     _sky.dispose();
//     _water.dispose();
//     _float.dispose();
//     _pulse.dispose();
//     _burst.dispose();
//     _txCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final progA = ref.watch(progressSummaryProvider);
//     final catsA = ref.watch(categoriesProvider);
//     final js = ref.watch(_jProvider);

//     if (progA.hasValue && catsA.hasValue) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (!mounted) return;
//         ref.read(_jProvider.notifier).sync(progA.value!, catsA.value!);
//       });
//     }

//     if (js.newId != null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (!mounted) return;
//         _burst.forward(from: 0);
//         final b =
//             _kB.firstWhere((b) => b.id == js.newId, orElse: () => _kB.first);
//         ref.read(_jProvider.notifier).clearNew();
//         _showUnlockDialog(b);
//       });
//     }

//     final size = MediaQuery.of(context).size;
//     final isLoading = progA.isLoading || catsA.isLoading;

//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: _C.bg,
//         body: Stack(children: [
//           // ── Sky ─────────────────────────────────────────────────────────
//           AnimatedBuilder(
//             animation: _sky,
//             builder: (_, __) => CustomPaint(
//               size: size,
//               painter: _SkyPainter(_sky.value),
//             ),
//           ),

//           // ── World or List ────────────────────────────────────────────────
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 350),
//             switchInCurve: Curves.easeOut,
//             switchOutCurve: Curves.easeIn,
//             child: _view == 'world'
//                 ? _WorldView(
//                     key: const ValueKey('world'),
//                     js: js,
//                     size: size,
//                     water: _water,
//                     float: _float,
//                     pulse: _pulse,
//                     txCtrl: _txCtrl,
//                     onTap: _onBuildingTap,
//                     onDoubleTap: _resetCamera,
//                   )
//                 : _ListView(
//                     key: const ValueKey('list'),
//                     js: js,
//                     onTap: _onBuildingTap,
//                   ),
//           ),

//           // ── Top gradient for HUD legibility ──────────────────────────────
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             height: 110,
//             child: IgnorePointer(
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [Colors.black.withOpacity(0.7), Colors.transparent],
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // ── HUD ─────────────────────────────────────────────────────────
//           SafeArea(
//               child: _HUD(
//                   js: js,
//                   isLoading: isLoading,
//                   view: _view,
//                   onToggleView: () => setState(
//                       () => _view = _view == 'world' ? 'list' : 'world'))),

//           // ── Gesture hint (auto-hides) ─────────────────────────────────────
//           if (_view == 'world')
//             AnimatedOpacity(
//               opacity: _showHint ? 1.0 : 0.0,
//               duration: const Duration(milliseconds: 600),
//               child: Positioned(
//                 top: MediaQuery.of(context).padding.top + 58,
//                 left: 0,
//                 right: 0,
//                 child: const _GestureHint(),
//               ),
//             ),

//           // ── Bottom bar ──────────────────────────────────────────────────
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: _BottomBar(js: js),
//           ),

//           // ── Loading ──────────────────────────────────────────────────────
//           if (isLoading)
//             Container(
//               color: Colors.black.withOpacity(0.4),
//               child: const Center(
//                   child: CircularProgressIndicator(
//                       color: _C.gold, strokeWidth: 2)),
//             ),

//           // ── Particle burst ────────────────────────────────────────────────
//           AnimatedBuilder(
//             animation: _burst,
//             builder: (_, __) => _burst.value > 0 && _burst.value < 1
//                 ? IgnorePointer(
//                     child: CustomPaint(
//                         size: size, painter: _BurstPainter(_burst.value)))
//                 : const SizedBox.shrink(),
//           ),

//           // ── Building sheet ────────────────────────────────────────────────
//           if (_sheetB != null)
//             _Sheet(
//               building: _sheetB!,
//               isOpen: _sheetOpen,
//               js: js,
//               onClose: _closeSheet,
//             ),

//           // ── Sheet backdrop ────────────────────────────────────────────────
//           if (_sheetOpen)
//             Positioned.fill(
//               child: GestureDetector(
//                 onTap: _closeSheet,
//                 child: Container(color: Colors.transparent),
//               ),
//             ),
//         ]),
//       ),
//     );
//   }

//   void _onBuildingTap(_Building b) {
//     HapticFeedback.mediumImpact();
//     setState(() {
//       _sheetB = b;
//       _sheetOpen = true;
//     });
//   }

//   void _closeSheet() => setState(() => _sheetOpen = false);

//   void _resetCamera() {
//     _txCtrl.value = Matrix4.identity();
//   }

//   void _showUnlockDialog(_Building b) {
//     showDialog(
//         context: context,
//         barrierColor: Colors.black87,
//         builder: (_) => _UnlockDialog(b: b));
//   }
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // 5. HUD
// // ═══════════════════════════════════════════════════════════════════════════

// class _HUD extends StatelessWidget {
//   final _JState js;
//   final bool isLoading;
//   final String view;
//   final VoidCallback onToggleView;
//   const _HUD(
//       {required this.js,
//       required this.isLoading,
//       required this.view,
//       required this.onToggleView});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
//       child: Row(children: [
//         Expanded(
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text('আমার জান্নাত',
//                     style: TextStyle(
//                         color: _C.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: -0.4,
//                         shadows: [
//                           Shadow(color: Colors.black54, blurRadius: 8)
//                         ])),
//                 Text(
//                     isLoading
//                         ? 'লোড হচ্ছে...'
//                         : '${js.unlocked.length} / ${_kB.length} স্থাপনা উন্মুক্ত',
//                     style: TextStyle(
//                         color: _C.white.withOpacity(0.5), fontSize: 11)),
//               ]),
//         ),
//         _Chip(Icons.local_fire_department_rounded, '${js.streak}', 'দিন',
//             _C.fire),
//         const SizedBox(width: 6),
//         _Chip(Icons.stars_rounded, '${js.pts}', 'pts', _C.gold),
//         const SizedBox(width: 6),
//         _Chip(Icons.pie_chart_rounded, '${js.pct.toInt()}%', '', _C.greenLight),
//         const SizedBox(width: 8),
//         // View toggle button
//         GestureDetector(
//           onTap: onToggleView,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: view == 'list'
//                   ? _C.gold.withOpacity(0.2)
//                   : Colors.black.withOpacity(0.55),
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                   color: view == 'list'
//                       ? _C.gold.withOpacity(0.5)
//                       : Colors.white.withOpacity(0.15)),
//             ),
//             child: Icon(
//               view == 'list' ? Icons.landscape_rounded : Icons.list_rounded,
//               color: view == 'list' ? _C.gold : Colors.white.withOpacity(0.7),
//               size: 18,
//             ),
//           ),
//         ),
//       ]),
//     );
//   }
// }

// class _Chip extends StatelessWidget {
//   final IconData icon;
//   final String val, suffix;
//   final Color color;
//   const _Chip(this.icon, this.val, this.suffix, this.color);
//   @override
//   Widget build(BuildContext context) => Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//         decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.6),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: color.withOpacity(0.35), width: 0.5)),
//         child: Row(mainAxisSize: MainAxisSize.min, children: [
//           Icon(icon, size: 11, color: color),
//           const SizedBox(width: 4),
//           Text('$val${suffix.isEmpty ? '' : ' $suffix'}',
//               style: TextStyle(
//                   color: color, fontSize: 10.5, fontWeight: FontWeight.w700)),
//         ]),
//       );
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // 6. GESTURE HINT
// // ═══════════════════════════════════════════════════════════════════════════

// class _GestureHint extends StatelessWidget {
//   const _GestureHint();
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 40),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//         decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.55),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.white.withOpacity(0.12)),
//         ),
//         child: Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _hintItem(Icons.touch_app_rounded, 'ট্যাপ করুন'),
//               _divider(),
//               _hintItem(Icons.pinch_rounded, 'পিঞ্চ করুন'),
//               _divider(),
//               _hintItem(Icons.open_with_rounded, 'টেনে দেখুন'),
//               _divider(),
//               _hintItem(Icons.my_location_rounded, 'ডাবল-ট্যাপ'),
//             ]),
//       ),
//     );
//   }

//   Widget _hintItem(IconData icon, String label) => Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           Icon(icon, size: 14, color: Colors.white.withOpacity(0.5)),
//           const SizedBox(height: 3),
//           Text(label,
//               style:
//                   TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 9)),
//         ]),
//       );

//   Widget _divider() => Container(
//         width: 0.5,
//         height: 24,
//         color: Colors.white.withOpacity(0.12),
//       );
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // 7. WORLD VIEW (canvas + interactive viewer)
// // ═══════════════════════════════════════════════════════════════════════════

// class _WorldView extends StatelessWidget {
//   final _JState js;
//   final Size size;
//   final AnimationController water, float, pulse;
//   final TransformationController txCtrl;
//   final void Function(_Building) onTap;
//   final VoidCallback onDoubleTap;

//   const _WorldView(
//       {super.key,
//       required this.js,
//       required this.size,
//       required this.water,
//       required this.float,
//       required this.pulse,
//       required this.txCtrl,
//       required this.onTap,
//       required this.onDoubleTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onDoubleTap: onDoubleTap,
//       child: InteractiveViewer(
//         transformationController: txCtrl,
//         minScale: 0.45,
//         maxScale: 2.8,
//         boundaryMargin: EdgeInsets.all(size.width * 0.6),
//         child: SizedBox(
//           width: size.width,
//           height: size.height,
//           child: AnimatedBuilder(
//             animation: Listenable.merge([water, float, pulse]),
//             builder: (_, __) => Stack(children: [
//               // Canvas: tiles + buildings
//               CustomPaint(
//                 size: size,
//                 painter: _WorldPainter(
//                   js: js,
//                   size: size,
//                   wT: water.value,
//                   fT: float.value,
//                   pT: pulse.value,
//                 ),
//               ),
//               // Tap layer
//               ..._kB.map((b) {
//                 final p = _iso(b.col.toDouble(), b.row.toDouble(), size);
//                 return Positioned(
//                   left: p.dx - 32,
//                   top: p.dy - 52,
//                   width: 64,
//                   height: 72,
//                   child: GestureDetector(
//                     onTap: () => onTap(b),
//                     child: Container(color: Colors.transparent),
//                   ),
//                 );
//               }),
//             ]),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Iso projection helper
// Offset _iso(double col, double row, Size s) => Offset(
//       s.width / 2 + (col - row) * 36.0,
//       s.height * 0.40 + (col + row) * 18.0,
//     );

// // ═══════════════════════════════════════════════════════════════════════════
// // 8. LIST VIEW — journey map with all buildings, locked/unlocked state
// // ═══════════════════════════════════════════════════════════════════════════

// class _ListView extends StatelessWidget {
//   final _JState js;
//   final void Function(_Building) onTap;
//   const _ListView({super.key, required this.js, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final pad = MediaQuery.of(context).padding;
//     // Sort: unlocked first (by tier), then locked by req pts
//     final unlocked = _kB.where((b) => js.isOpen(b.id)).toList()
//       ..sort((a, b) => a.tier.index.compareTo(b.tier.index));
//     final locked = _kB.where((b) => !js.isOpen(b.id)).toList()
//       ..sort((a, b) => (a.reqPts ?? 0).compareTo(b.reqPts ?? 0));

//     return Container(
//       color: const Color(0xFF020C06),
//       child: ListView(
//         padding: EdgeInsets.fromLTRB(16, pad.top + 60, 16, 110 + pad.bottom),
//         children: [
//           // ── Summary card ──────────────────────────────────────────────────
//           _SummaryCard(js: js),
//           const SizedBox(height: 20),

//           // ── Unlocked section ──────────────────────────────────────────────
//           if (unlocked.isNotEmpty) ...[
//             _sectionLabel('✦  অর্জিত স্থাপনা  (${unlocked.length})', _C.gold),
//             const SizedBox(height: 10),
//             ...unlocked.map((b) => _BuildingListTile(
//                   b: b,
//                   js: js,
//                   onTap: () => onTap(b),
//                 )),
//             const SizedBox(height: 20),
//           ],

//           // ── Locked section ────────────────────────────────────────────────
//           if (locked.isNotEmpty) ...[
//             _sectionLabel('🔒  বাকি স্থাপনা  (${locked.length})', _C.textMuted),
//             const SizedBox(height: 10),
//             ...locked.map((b) => _BuildingListTile(
//                   b: b,
//                   js: js,
//                   onTap: () => onTap(b),
//                 )),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _sectionLabel(String text, Color color) => Text(text,
//       style: TextStyle(
//           color: color,
//           fontSize: 11,
//           fontWeight: FontWeight.w600,
//           letterSpacing: 0.8));
// }

// class _SummaryCard extends StatelessWidget {
//   final _JState js;
//   const _SummaryCard({required this.js});

//   @override
//   Widget build(BuildContext context) {
//     final pct = js.unlocked.length / _kB.length;
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _C.cardBg,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: _C.cardBorder, width: 0.5),
//       ),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(children: [
//           Expanded(
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               const Text('জান্নাতের যাত্রা',
//                   style: TextStyle(
//                       color: _C.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700)),
//               const SizedBox(height: 3),
//               Text('${js.unlocked.length} টি স্থাপনা উন্মুক্ত হয়েছে',
//                   style: const TextStyle(color: _C.textMuted, fontSize: 12)),
//             ]),
//           ),
//           // Big pts display
//           Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
//             Text('${js.pts}',
//                 style: const TextStyle(
//                     color: _C.gold,
//                     fontSize: 28,
//                     fontWeight: FontWeight.w800,
//                     height: 1)),
//             const Text('pts',
//                 style: TextStyle(color: _C.textMuted, fontSize: 11)),
//           ]),
//         ]),
//         const SizedBox(height: 14),
//         // Journey progress bar
//         Row(children: [
//           Expanded(
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(99),
//               child: LinearProgressIndicator(
//                 value: pct,
//                 minHeight: 7,
//                 backgroundColor: Colors.white.withOpacity(0.07),
//                 valueColor: const AlwaysStoppedAnimation(_C.gold),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Text('${(pct * 100).toInt()}%',
//               style: const TextStyle(
//                   color: _C.gold, fontSize: 11, fontWeight: FontWeight.w600)),
//         ]),
//         const SizedBox(height: 12),
//         // Stats row
//         Row(children: [
//           _statItem(Icons.local_fire_department_rounded, '${js.streak} দিন',
//               'streak', _C.fire),
//           const SizedBox(width: 12),
//           _statItem(Icons.pie_chart_rounded, '${js.pct.toInt()}%', 'সমাপ্তি',
//               _C.greenLight),
//           const SizedBox(width: 12),
//           _statItem(Icons.landscape_rounded,
//               '${_kB.length - js.unlocked.length}টি', 'বাকি', _C.textMuted),
//         ]),
//       ]),
//     );
//   }

//   Widget _statItem(IconData icon, String val, String lbl, Color color) =>
//       Row(mainAxisSize: MainAxisSize.min, children: [
//         Icon(icon, size: 12, color: color),
//         const SizedBox(width: 4),
//         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text(val,
//               style: TextStyle(
//                   color: color, fontSize: 11, fontWeight: FontWeight.w600)),
//           Text(lbl, style: TextStyle(color: _C.textMuted, fontSize: 9)),
//         ]),
//       ]);
// }

// class _BuildingListTile extends StatelessWidget {
//   final _Building b;
//   final _JState js;
//   final VoidCallback onTap;
//   const _BuildingListTile(
//       {required this.b, required this.js, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final open = js.isOpen(b.id);
//     final tierColor = _tierColor(b.tier);

//     // Compute individual condition progress for locked tiles
//     final ptsOk = b.reqPts == null || js.pts >= b.reqPts!;
//     final strOk = b.reqStreak == null || js.streak >= b.reqStreak!;
//     final pctOk = b.reqPct == null || js.pct >= b.reqPct!;
//     final keyOk = b.reqKey == null || js.keys.contains(b.reqKey);

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.all(13),
//         decoration: BoxDecoration(
//           color: open ? _C.cardBg : const Color(0xFF061209),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: open ? tierColor.withOpacity(0.3) : _C.cardBorder,
//             width: open ? 1 : 0.5,
//           ),
//         ),
//         child: Row(children: [
//           // Icon badge
//           Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               color: open
//                   ? tierColor.withOpacity(0.12)
//                   : Colors.white.withOpacity(0.04),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                   color: open
//                       ? tierColor.withOpacity(0.3)
//                       : Colors.white.withOpacity(0.08)),
//             ),
//             child: Icon(
//               open ? _tierIcon(b.tier) : Icons.lock_rounded,
//               color: open ? tierColor : _C.textMuted.withOpacity(0.5),
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 12),

//           // Info
//           Expanded(
//               child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(children: [
//                 Expanded(
//                     child: Text(b.nameBn,
//                         style: TextStyle(
//                             color:
//                                 open ? _C.white : _C.textLight.withOpacity(0.6),
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600))),
//                 // Tier badge
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: tierColor.withOpacity(open ? 0.15 : 0.06),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(_tierLabel(b.tier),
//                       style: TextStyle(
//                           color: open ? tierColor : _C.textMuted,
//                           fontSize: 9,
//                           fontWeight: FontWeight.w600)),
//                 ),
//               ]),
//               const SizedBox(height: 4),

//               // Open: show story snippet / Locked: show conditions
//               if (open)
//                 Text(b.storyBn.split('\n').first,
//                     style: const TextStyle(color: _C.textMuted, fontSize: 11),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis)
//               else ...[
//                 // Condition pills
//                 Wrap(spacing: 6, runSpacing: 4, children: [
//                   if (b.reqPts != null)
//                     _condPill(
//                         '✦ ${b.reqPts} pts', ptsOk, '${js.pts} / ${b.reqPts}'),
//                   if (b.reqStreak != null)
//                     _condPill('🔥 ${b.reqStreak} দিন', strOk,
//                         '${js.streak} / ${b.reqStreak}'),
//                   if (b.reqPct != null)
//                     _condPill('% ${b.reqPct!.toInt()}', pctOk,
//                         '${js.pct.toInt()} / ${b.reqPct!.toInt()}'),
//                   if (b.reqKey != null)
//                     _condPill(b.reqKey!, keyOk, keyOk ? 'সম্পন্ন' : 'বাকি'),
//                 ]),
//               ],
//             ],
//           )),

//           // Arrow
//           const SizedBox(width: 8),
//           Icon(Icons.chevron_right_rounded,
//               color: open
//                   ? tierColor.withOpacity(0.6)
//                   : _C.textMuted.withOpacity(0.3),
//               size: 20),
//         ]),
//       ),
//     ).animate().fadeIn(duration: 220.ms).slideX(begin: 0.04);
//   }

//   Widget _condPill(String label, bool done, String progress) => Container(
//         padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
//         decoration: BoxDecoration(
//           color: done
//               ? _C.green.withOpacity(0.12)
//               : Colors.white.withOpacity(0.05),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//               color: done
//                   ? _C.green.withOpacity(0.3)
//                   : Colors.white.withOpacity(0.08)),
//         ),
//         child: Row(mainAxisSize: MainAxisSize.min, children: [
//           if (done) const Icon(Icons.check_rounded, size: 9, color: _C.green),
//           if (done) const SizedBox(width: 3),
//           Text(done ? label : '$label  ($progress)',
//               style: TextStyle(
//                   color: done ? _C.green : _C.textMuted,
//                   fontSize: 9,
//                   fontWeight: FontWeight.w500)),
//         ]),
//       );
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // 9. BOTTOM BAR
// // ═══════════════════════════════════════════════════════════════════════════

// class _BottomBar extends StatelessWidget {
//   final _JState js;
//   const _BottomBar({required this.js});

//   @override
//   Widget build(BuildContext context) {
//     final next = js.nextB;
//     final pad = MediaQuery.of(context).padding.bottom;

//     return Container(
//       padding: EdgeInsets.fromLTRB(16, 12, 16, pad + 14),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.82),
//         border: Border(
//             top: BorderSide(color: Colors.white.withOpacity(0.07), width: 0.5)),
//       ),
//       child: next == null
//           ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//               const Icon(Icons.celebration_rounded, color: _C.gold, size: 16),
//               const SizedBox(width: 8),
//               const Text('মাশাআল্লাহ! জান্নাত পরিপূর্ণ হয়েছে 🌟',
//                   style: TextStyle(
//                       color: _C.gold,
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600)),
//             ])
//           : Column(mainAxisSize: MainAxisSize.min, children: [
//               Row(children: [
//                 Expanded(
//                     child: Text('পরবর্তী: ${next.nameBn}',
//                         style: const TextStyle(
//                             color: _C.white,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600))),
//                 Text(
//                     js.ptsToNext > 0
//                         ? 'আরও ${js.ptsToNext} pts'
//                         : 'অন্য শর্ত বাকি',
//                     style: const TextStyle(
//                         color: _C.gold,
//                         fontSize: 11,
//                         fontWeight: FontWeight.w600)),
//               ]),
//               const SizedBox(height: 6),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(99),
//                 child: LinearProgressIndicator(
//                   value: js.progToNext,
//                   minHeight: 5,
//                   backgroundColor: Colors.white.withOpacity(0.08),
//                   valueColor: const AlwaysStoppedAnimation(_C.gold),
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(next.howBn,
//                   style: TextStyle(
//                       color: Colors.white.withOpacity(0.4), fontSize: 10)),
//             ]),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // 10. BUILDING SHEET
// // ═══════════════════════════════════════════════════════════════════════════

// class _Sheet extends StatelessWidget {
//   final _Building building;
//   final bool isOpen;
//   final _JState js;
//   final VoidCallback onClose;
//   const _Sheet(
//       {required this.building,
//       required this.isOpen,
//       required this.js,
//       required this.onClose});

//   @override
//   Widget build(BuildContext context) {
//     final open = js.isOpen(building.id);
//     final pad = MediaQuery.of(context).padding.bottom;
//     final tc = _tierColor(building.tier);

//     return AnimatedPositioned(
//       duration: const Duration(milliseconds: 320),
//       curve: Curves.easeOutCubic,
//       bottom: isOpen ? 0 : -520,
//       left: 0,
//       right: 0,
//       child: Container(
//         decoration: BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//           border: Border.all(color: _C.cardBorder, width: 0.5),
//           boxShadow: [
//             BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 30)
//           ],
//         ),
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           // Handle
//           Padding(
//             padding: const EdgeInsets.only(top: 10),
//             child: Container(
//                 width: 36,
//                 height: 4,
//                 decoration: BoxDecoration(
//                     color: _C.cardBorder,
//                     borderRadius: BorderRadius.circular(99))),
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(20, 10, 20, pad + 18),
//             child: Column(mainAxisSize: MainAxisSize.min, children: [
//               // Tier pill
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                 decoration: BoxDecoration(
//                     color: tc.withOpacity(0.12),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: tc.withOpacity(0.3))),
//                 child: Text(_tierLabel(building.tier),
//                     style: TextStyle(
//                         color: tc,
//                         fontSize: 10,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 0.8)),
//               ),
//               const SizedBox(height: 10),

//               Text(building.nameBn,
//                   style: const TextStyle(
//                       color: _C.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.w700)),
//               const SizedBox(height: 8),

//               Text(building.storyBn,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                       color: _C.textMuted, fontSize: 13, height: 1.6)),
//               const SizedBox(height: 16),

//               if (open) ...[
//                 // Unlocked
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(vertical: 11),
//                   decoration: BoxDecoration(
//                       color: _C.green.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: _C.green.withOpacity(0.3))),
//                   child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Icons.check_circle_rounded,
//                             color: _C.green, size: 16),
//                         const SizedBox(width: 8),
//                         Flexible(
//                             child: Text(building.howBn,
//                                 style: const TextStyle(
//                                     color: _C.green,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w600))),
//                       ]),
//                 ),
//               ] else ...[
//                 // Locked conditions
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(14),
//                   decoration: BoxDecoration(
//                       color: const Color(0xFF061209),
//                       borderRadius: BorderRadius.circular(14),
//                       border: Border.all(color: _C.cardBorder)),
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('আনলক করতে হবে',
//                             style: TextStyle(
//                                 color: Colors.white.withOpacity(0.3),
//                                 fontSize: 10,
//                                 letterSpacing: 0.8)),
//                         const SizedBox(height: 10),
//                         if (building.reqPts != null)
//                           _condRow(
//                               Icons.stars_rounded,
//                               'মোট পয়েন্ট',
//                               '${js.pts}',
//                               '${building.reqPts}',
//                               js.pts >= building.reqPts!),
//                         if (building.reqStreak != null)
//                           _condRow(
//                               Icons.local_fire_department_rounded,
//                               'ধারাবাহিক দিন',
//                               '${js.streak} দিন',
//                               '${building.reqStreak} দিন',
//                               js.streak >= building.reqStreak!),
//                         if (building.reqPct != null)
//                           _condRow(
//                               Icons.pie_chart_rounded,
//                               'মাসিক সমাপ্তি',
//                               '${js.pct.toInt()}%',
//                               '${building.reqPct!.toInt()}%',
//                               js.pct >= building.reqPct!),
//                         if (building.reqKey != null)
//                           _condRow(
//                               Icons.task_alt_rounded,
//                               'আমল: ${building.reqKey}',
//                               js.keys.contains(building.reqKey)
//                                   ? 'সম্পন্ন'
//                                   : 'বাকি',
//                               'সম্পন্ন',
//                               js.keys.contains(building.reqKey)),
//                       ]),
//                 ),
//               ],
//             ]),
//           ),
//         ]),
//       ),
//     );
//   }

//   Widget _condRow(
//           IconData icon, String label, String cur, String need, bool done) =>
//       Padding(
//         padding: const EdgeInsets.only(bottom: 9),
//         child: Row(children: [
//           Icon(icon, size: 13, color: done ? _C.green : _C.textMuted),
//           const SizedBox(width: 10),
//           Expanded(
//               child: Text(label,
//                   style: const TextStyle(color: _C.textLight, fontSize: 12))),
//           if (!done) ...[
//             SizedBox(
//                 width: 55,
//                 height: 4,
//                 child: ClipRRect(
//                     borderRadius: BorderRadius.circular(99),
//                     child: LinearProgressIndicator(
//                         value: _rowProg(cur, need),
//                         backgroundColor: Colors.white.withOpacity(0.07),
//                         valueColor: const AlwaysStoppedAnimation(_C.gold)))),
//             const SizedBox(width: 8),
//           ],
//           Text(done ? '✓' : '$cur / $need',
//               style: TextStyle(
//                   color: done ? _C.green : _C.gold,
//                   fontSize: 10.5,
//                   fontWeight: FontWeight.w600)),
//         ]),
//       );

//   double _rowProg(String cur, String need) {
//     try {
//       final c = double.parse(cur.replaceAll(RegExp(r'[^\d.]'), ''));
//       final n = double.parse(need.replaceAll(RegExp(r'[^\d.]'), ''));
//       return (c / n).clamp(0.0, 1.0);
//     } catch (_) {
//       return 0;
//     }
//   }
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // 11. WORLD PAINTER — tiles + buildings
// // ═══════════════════════════════════════════════════════════════════════════

// class _WorldPainter extends CustomPainter {
//   final _JState js;
//   final Size size;
//   final double wT, fT, pT;
//   _WorldPainter(
//       {required this.js,
//       required this.size,
//       required this.wT,
//       required this.fT,
//       required this.pT});

//   static const int _cols = 9, _rows = 9;
//   static const double _tw = 72.0, _th = 36.0, _dep = 7.0;

//   Offset _p(double c, double r) => Offset(
//         size.width / 2 + (c - r) * _tw / 2,
//         size.height * 0.40 + (c + r) * _th / 2,
//       );

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Tiles
//     for (int r = 0; r < _rows; r++) {
//       for (int c = 0; c < _cols; c++) {
//         _tile(canvas, c, r);
//       }
//     }
//     // Buildings sorted by depth
//     final sorted = List<_Building>.from(_kB)
//       ..sort((a, b) => (a.col + a.row).compareTo(b.col + b.row));
//     for (final b in sorted) _drawB(canvas, b);
//   }

//   void _tile(Canvas canvas, int c, int r) {
//     final p = _p(c.toDouble(), r.toDouble());
//     final hw = _tw / 2, hh = _th / 2;
//     final face = Path()
//       ..moveTo(p.dx, p.dy - hh)
//       ..lineTo(p.dx + hw, p.dy)
//       ..lineTo(p.dx, p.dy + hh)
//       ..lineTo(p.dx - hw, p.dy)
//       ..close();

//     final isRiver =
//         [(4, 5), (4, 6), (5, 6), (5, 7), (4, 7), (3, 7)].contains((c, r));
//     final isPath = [
//       (4, 2),
//       (4, 3),
//       (4, 4),
//       (3, 3),
//       (5, 3),
//       (3, 4),
//       (5, 4),
//       (3, 5),
//       (5, 5),
//       (3, 2),
//       (5, 2)
//     ].contains((c, r));

//     Color top, left, right;
//     if (isRiver) {
//       final wv = 0.5 + 0.4 * math.sin(wT * math.pi * 2 + c * 0.7);
//       top = Color.lerp(const Color(0xFF1E6A8A), const Color(0xFF2A88AA), wv)!;
//       left = const Color(0xFF0E3A50);
//       right = const Color(0xFF104055);
//     } else if (isPath) {
//       top = _C.pathC;
//       left = const Color(0xFF2E3E2E);
//       right = const Color(0xFF3A4A3A);
//     } else if ((c + r) % 2 == 0) {
//       top = _C.grassA;
//       left = const Color(0xFF0E4020);
//       right = const Color(0xFF124A24);
//     } else {
//       top = _C.grassB;
//       left = const Color(0xFF0C3018);
//       right = const Color(0xFF0F3A1C);
//     }

//     canvas.drawPath(face, Paint()..color = top);
//     // Left depth
//     canvas.drawPath(
//         Path()
//           ..moveTo(p.dx - hw, p.dy)
//           ..lineTo(p.dx, p.dy + hh)
//           ..lineTo(p.dx, p.dy + hh + _dep)
//           ..lineTo(p.dx - hw, p.dy + _dep)
//           ..close(),
//         Paint()..color = left);
//     // Right depth
//     canvas.drawPath(
//         Path()
//           ..moveTo(p.dx + hw, p.dy)
//           ..lineTo(p.dx, p.dy + hh)
//           ..lineTo(p.dx, p.dy + hh + _dep)
//           ..lineTo(p.dx + hw, p.dy + _dep)
//           ..close(),
//         Paint()..color = right);
//     canvas.drawPath(
//         face,
//         Paint()
//           ..color = Colors.black.withOpacity(0.1)
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 0.5);
//     if (isRiver) {
//       final sy = p.dy - hh * 0.3 + math.sin(wT * math.pi * 2 + c) * 1.5;
//       canvas.drawLine(
//           Offset(p.dx - hw * 0.5, sy),
//           Offset(p.dx + hw * 0.5, sy),
//           Paint()
//             ..color = Colors.white.withOpacity(0.14)
//             ..strokeWidth = 1.2
//             ..strokeCap = StrokeCap.round);
//     }
//   }

//   void _drawB(Canvas canvas, _Building b) {
//     final open = js.isOpen(b.id);
//     final pos = _p(b.col.toDouble(), b.row.toDouble());
//     final float = open ? math.sin(fT * math.pi + b.col * 0.5) * 2.5 : 0.0;

//     canvas.save();
//     canvas.translate(pos.dx, pos.dy - float);

//     if (!open) {
//       canvas.saveLayer(null, Paint()..color = const Color(0x00000000));
//       _silhouette(canvas, b);
//       canvas.restore();
//       _drawLock(canvas, pT);
//     } else {
//       _drawBuilding(canvas, b, wT, fT);
//     }
//     canvas.restore();
//   }

//   void _silhouette(Canvas canvas, _Building b) {
//     final h = [28.0, 38.0, 50.0, 62.0, 76.0][b.tier.index];
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(
//             Rect.fromCenter(center: Offset(0, -h / 2), width: 28, height: h),
//             const Radius.circular(4)),
//         Paint()
//           ..color =
//               Color.fromRGBO(10, 30, 12, 0.6 + 0.15 * math.sin(pT * math.pi)));
//     canvas.drawCircle(
//         Offset(0, -h / 2),
//         h * 0.45,
//         Paint()
//           ..color =
//               Colors.black.withOpacity(0.35 + 0.12 * math.sin(pT * math.pi))
//           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12));
//   }

//   void _drawLock(Canvas canvas, double pT) {
//     final o = 0.35 + 0.2 * math.sin(pT * math.pi);
//     final p = Paint()..color = Colors.white.withOpacity(o);
//     canvas.drawArc(
//         Rect.fromCenter(center: const Offset(0, -24), width: 10, height: 10),
//         math.pi,
//         math.pi,
//         false,
//         Paint()
//           ..color = Colors.white.withOpacity(o)
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 2.2);
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(
//             Rect.fromCenter(
//                 center: const Offset(0, -16), width: 13, height: 10),
//             const Radius.circular(2)),
//         p);
//   }

//   void _drawBuilding(Canvas canvas, _Building b, double wT, double fT) {
//     switch (b.id) {
//       case 'sprout':
//         _sprout(canvas);
//         break;
//       case 'mosque':
//         _mosque(canvas, fT);
//         break;
//       case 'pavilion':
//         _pavilion(canvas);
//         break;
//       case 'fountain':
//         _fountain(canvas, wT);
//         break;
//       case 'palm':
//         _palm(canvas, fT);
//         break;
//       case 'lantern':
//         _lantern(canvas, fT);
//         break;
//       case 'bridge':
//         _bridge(canvas);
//         break;
//       case 'cottage':
//         _cottage(canvas, fT);
//         break;
//       case 'river':
//         _riverMarker(canvas, wT);
//         break;
//       case 'tuba':
//         _tuba(canvas, fT);
//         break;
//       case 'minaret':
//         _minaret(canvas, fT);
//         break;
//       case 'palace':
//         _palace(canvas, fT);
//         break;
//     }
//   }

//   // ── Building drawers ───────────────────────────────────────────────────

//   void _sprout(Canvas canvas) {
//     canvas.drawOval(
//         Rect.fromCenter(center: const Offset(0, 4), width: 28, height: 11),
//         Paint()..color = const Color(0xFF1A5C2A));
//     canvas.drawLine(
//         const Offset(0, 4),
//         const Offset(0, -10),
//         Paint()
//           ..color = const Color(0xFF2ECC5A)
//           ..strokeWidth = 2.5
//           ..strokeCap = StrokeCap.round
//           ..style = PaintingStyle.stroke);
//     for (final l in [true, false]) {
//       canvas.drawPath(
//           Path()
//             ..moveTo(0, l ? -4 : -6)
//             ..cubicTo(l ? -10 : -8, l ? -10 : -10, l ? -14 : -12, l ? -16 : -18,
//                 l ? -6 : -5, l ? -20 : -20)
//             ..quadraticBezierTo(l ? -3 : -1, l ? -12 : -10, 0, l ? -5 : -7)
//             ..close(),
//           Paint()
//             ..color = l ? const Color(0xFF2ECC5A) : const Color(0xFF26BB50));
//     }
//   }

//   void _mosque(Canvas canvas, double fT) {
//     final g = 0.1 + 0.07 * math.sin(fT * math.pi * 1.2);
//     canvas.drawOval(
//         Rect.fromCenter(center: const Offset(0, 6), width: 44, height: 16),
//         Paint()..color = const Color(0xFF2A3A2A));
//     _isoBox(canvas, 0, -2, 38, 26, const Color(0xFFE8D5B0),
//         const Color(0xFFB8A880), const Color(0xFFD0BC90));
//     canvas.drawArc(
//         Rect.fromCenter(center: const Offset(0, -26), width: 24, height: 22),
//         math.pi,
//         math.pi,
//         false,
//         Paint()..color = const Color(0xFF2EA868));
//     canvas.drawArc(
//         Rect.fromCenter(center: const Offset(0, -26), width: 24, height: 22),
//         math.pi,
//         math.pi,
//         false,
//         Paint()
//           ..color = _C.gold
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 1.5);
//     for (final dx in [-15.0, 15.0]) {
//       _isoBox(canvas, dx, -6, 8, 38, const Color(0xFFE8D5B0),
//           const Color(0xFFB8A880), const Color(0xFFD0BC90));
//       canvas.drawCircle(Offset(dx, -30), 3, Paint()..color = _C.gold);
//     }
//     canvas.drawCircle(
//         const Offset(0, -22),
//         20,
//         Paint()
//           ..color = _C.gold.withOpacity(g)
//           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12));
//   }

//   void _pavilion(Canvas canvas) {
//     for (final dx in [-12.0, -4.0, 4.0, 12.0]) {
//       canvas.drawRRect(
//           RRect.fromRectAndRadius(
//               Rect.fromCenter(center: Offset(dx, -12), width: 4, height: 28),
//               const Radius.circular(2)),
//           Paint()..color = const Color(0xFFD4B870));
//     }
//     canvas.drawPath(
//         Path()
//           ..moveTo(0, -38)
//           ..lineTo(28, -22)
//           ..lineTo(-28, -22)
//           ..close(),
//         Paint()..color = const Color(0xFF2A7A4A));
//     canvas.drawPath(
//         Path()
//           ..moveTo(0, -46)
//           ..lineTo(22, -32)
//           ..lineTo(-22, -32)
//           ..close(),
//         Paint()..color = const Color(0xFF4A9A6A));
//     canvas.drawPath(
//         Path()
//           ..moveTo(-8, -2)
//           ..lineTo(8, -6)
//           ..lineTo(8, 4)
//           ..lineTo(-8, 2)
//           ..close(),
//         Paint()..color = const Color(0xFFE8D0A0));
//     canvas.drawLine(
//         const Offset(0, -6),
//         const Offset(0, 4),
//         Paint()
//           ..color = const Color(0xFFB8A070)
//           ..strokeWidth = 1
//           ..style = PaintingStyle.stroke);
//   }

//   void _fountain(Canvas canvas, double wT) {
//     canvas.drawOval(
//         Rect.fromCenter(center: const Offset(0, 4), width: 36, height: 16),
//         Paint()..color = const Color(0xFF5A7A8A));
//     canvas.drawOval(
//         Rect.fromCenter(center: const Offset(0, 3), width: 26, height: 11),
//         Paint()..color = _C.river.withOpacity(0.85));
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(
//             Rect.fromCenter(center: const Offset(0, -6), width: 6, height: 18),
//             const Radius.circular(3)),
//         Paint()..color = const Color(0xFF6A8A9A));
//     final ah = 12 + 4 * math.sin(wT * math.pi * 2);
//     final wp = Paint()
//       ..color = _C.river.withOpacity(0.75)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.5
//       ..strokeCap = StrokeCap.round;
//     canvas.drawPath(
//         Path()
//           ..moveTo(0, -14)
//           ..quadraticBezierTo(10, (-14 - ah), 12, 0),
//         wp);
//     canvas.drawPath(
//         Path()
//           ..moveTo(0, -14)
//           ..quadraticBezierTo(-10, (-14 - ah), -12, 0),
//         wp);
//     canvas.drawCircle(
//         const Offset(0, -6),
//         11,
//         Paint()
//           ..color = _C.river.withOpacity(0.12)
//           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
//   }

//   void _palm(Canvas canvas, double fT) {
//     final sw = math.sin(fT * 0.9) * 3.0;
//     canvas.drawPath(
//         Path()
//           ..moveTo(-3, 6)
//           ..quadraticBezierTo(sw * 0.3 - 1, -18, sw, -42)
//           ..lineTo(sw + 4, -42)
//           ..quadraticBezierTo(sw * 0.3 + 3, -18, 4, 6)
//           ..close(),
//         Paint()..color = const Color(0xFF8B5E3C));
//     final fp = Paint()
//       ..color = const Color(0xFF2ECC6A)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3.5
//       ..strokeCap = StrokeCap.round;
//     for (final a in [-0.8, -0.3, 0.1, 0.5, 0.9, 1.3]) {
//       canvas.drawPath(
//           Path()
//             ..moveTo(sw, -42)
//             ..quadraticBezierTo(
//                 sw + math.cos(a + sw * 0.05) * 12,
//                 -42 + math.sin(a + sw * 0.05) * 6 - 4,
//                 sw + math.cos(a + sw * 0.05) * 24,
//                 -42 + math.sin(a + sw * 0.05) * 12),
//           fp);
//     }
//     for (int i = 0; i < 5; i++)
//       canvas.drawCircle(
//           Offset(sw + (i - 2) * 3, -40), 2.5, Paint()..color = _C.gold);
//   }

//   void _lantern(Canvas canvas, double fT) {
//     final pulse = 0.7 + 0.3 * math.sin(fT * math.pi * 2.5);
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(
//             Rect.fromCenter(center: const Offset(0, -8), width: 5, height: 28),
//             const Radius.circular(2)),
//         Paint()..color = const Color(0xFF7A6A4A));
//     canvas.drawOval(
//         Rect.fromCenter(center: const Offset(0, 4), width: 18, height: 8),
//         Paint()..color = const Color(0xFF3A3A2A));
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(
//             Rect.fromCenter(
//                 center: const Offset(0, -28), width: 14, height: 16),
//             const Radius.circular(3)),
//         Paint()..color = const Color(0xFFFFD070).withOpacity(0.9 * pulse));
//     canvas.drawCircle(
//         const Offset(0, -28),
//         16 * pulse,
//         Paint()
//           ..color = const Color(0xFFFFD070).withOpacity(0.22 * pulse)
//           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
//   }

//   void _bridge(Canvas canvas) {
//     const sc = Color(0xFF7A7A6A);
//     canvas.drawPath(
//         Path()
//           ..moveTo(-26, -2)
//           ..lineTo(26, -2)
//           ..lineTo(22, 8)
//           ..lineTo(-22, 8)
//           ..close(),
//         Paint()..color = sc);
//     canvas.drawArc(
//         Rect.fromCenter(center: const Offset(0, 6), width: 28, height: 18),
//         0,
//         math.pi,
//         false,
//         Paint()
//           ..color = const Color(0xFF5A5A4A)
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 5);
//     for (double dx = -18; dx <= 22; dx += 8) {
//       canvas.drawLine(
//           Offset(dx, -2),
//           Offset(dx, -12),
//           Paint()
//             ..color = sc
//             ..strokeWidth = 2.5);
//     }
//     canvas.drawLine(
//         const Offset(-22, -12),
//         const Offset(26, -12),
//         Paint()
//           ..color = sc
//           ..strokeWidth = 3);
//   }

//   void _cottage(Canvas canvas, double fT) {
//     _isoBox(canvas, 0, -2, 44, 26, const Color(0xFFD4C090),
//         const Color(0xFFB8A878), const Color(0xFFC8B888));
//     canvas.drawPath(
//         Path()
//           ..moveTo(0, -32)
//           ..lineTo(26, -18)
//           ..lineTo(-26, -18)
//           ..close(),
//         Paint()..color = const Color(0xFFA84848));
//     for (final dx in [-10.0, 10.0]) {
//       canvas.drawRect(
//           Rect.fromCenter(center: Offset(dx, -8), width: 9, height: 9),
//           Paint()..color = const Color(0xFF88CCF0));
//     }
//     canvas.drawRRect(
//         RRect.fromRectAndCorners(
//             Rect.fromCenter(center: const Offset(0, -2), width: 8, height: 12),
//             topLeft: const Radius.circular(4),
//             topRight: const Radius.circular(4)),
//         Paint()..color = const Color(0xFF8B5E3C));
//     _isoBox(canvas, 14, -30, 8, 14, const Color(0xFFD4C090),
//         const Color(0xFFB8A878), const Color(0xFFC8B888));
//     for (int i = 0; i < 3; i++)
//       canvas.drawCircle(
//           Offset(14 + math.sin(fT * 0.8 + i) * 2, -42 - i * 5),
//           2.5 - i * 0.4,
//           Paint()..color = Colors.white.withOpacity(0.09 - i * 0.025));
//   }

//   void _riverMarker(Canvas canvas, double wT) {
//     final wv = 0.5 + 0.5 * math.sin(wT * math.pi * 2);
//     canvas.drawOval(
//         Rect.fromCenter(center: Offset.zero, width: 44, height: 18),
//         Paint()
//           ..color = Color.lerp(
//               const Color(0xFF1A5A7A), const Color(0xFF2A8AA0), wv)!);
//     for (int i = 0; i < 6; i++)
//       canvas.drawCircle(
//           Offset(-20.0 + i * 8 + math.sin(wT * 2 + i) * 2,
//               math.sin(wT * 1.5 + i * 0.8) * 3),
//           1.5,
//           Paint()..color = Colors.white.withOpacity(0.55));
//   }

//   void _tuba(Canvas canvas, double fT) {
//     final sw = math.sin(fT * 0.7) * 2.0;
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(
//             Rect.fromCenter(
//                 center: Offset(sw * 0.1, -18), width: 6, height: 38),
//             const Radius.circular(3)),
//         Paint()..color = _C.gold);
//     for (int i = 0; i < 3; i++) {
//       canvas.drawCircle(
//           Offset(sw * (i * 0.2), -36 - i * 10 + sw),
//           (18 - i * 4).toDouble(),
//           Paint()
//             ..color = const Color(0xFFFFD700).withOpacity(0.85 - i * 0.15));
//     }
//     for (int i = 0; i < 6; i++) {
//       final a = i * math.pi / 3 + fT * 0.5;
//       final r = 20.0 + 4 * math.sin(fT + i * 0.7);
//       canvas.drawLine(
//           Offset(0, -46 + sw),
//           Offset(math.cos(a) * r, -46 + sw + math.sin(a) * r * 0.4),
//           Paint()
//             ..color = const Color(0xFFFFD700).withOpacity(0.6)
//             ..strokeWidth = 1.5
//             ..strokeCap = StrokeCap.round);
//     }
//     canvas.drawCircle(
//         Offset(0, -46 + sw),
//         26,
//         Paint()
//           ..color = const Color(0xFFFFD700).withOpacity(0.16)
//           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14));
//   }

//   void _minaret(Canvas canvas, double fT) {
//     _isoBox(canvas, 0, -22, 14, 58, const Color(0xFFD8D0C0),
//         const Color(0xFFB0A898), const Color(0xFFC0B8A8));
//     canvas.drawArc(
//         Rect.fromCenter(center: const Offset(0, -54), width: 20, height: 18),
//         math.pi,
//         math.pi,
//         false,
//         Paint()..color = _C.greenLight);
//     final pulse = 0.6 + 0.4 * math.sin(fT * math.pi * 1.2);
//     canvas.drawCircle(
//         const Offset(0, -66), 8, Paint()..color = _C.gold.withOpacity(pulse));
//     canvas.drawCircle(
//         const Offset(3, -66), 6, Paint()..color = const Color(0xFF0A1E0A));
//     canvas.drawCircle(
//         const Offset(0, -66),
//         14 * pulse,
//         Paint()
//           ..color = _C.gold.withOpacity(0.14 * pulse)
//           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
//   }

//   void _palace(Canvas canvas, double fT) {
//     final fl = 0.14 + 0.07 * math.sin(fT * 0.8);
//     _isoBox(canvas, 0, 4, 60, 10, const Color(0xFF3A4A2A),
//         const Color(0xFF2A3A1A), const Color(0xFF2A3A1A));
//     for (final dx in [-28.0, 28.0]) {
//       _isoBox(canvas, dx, -2, 18, 22, const Color(0xFFF0E8D0),
//           const Color(0xFFD0C8A8), const Color(0xFFE0D8B8));
//     }
//     _isoBox(canvas, 0, -6, 48, 32, const Color(0xFFF0E8D0),
//         const Color(0xFFD0C8A8), const Color(0xFFE0D8B8));
//     canvas.drawArc(
//         Rect.fromCenter(center: const Offset(0, -34), width: 34, height: 30),
//         math.pi,
//         math.pi,
//         false,
//         Paint()..color = _C.greenLight);
//     canvas.drawArc(
//         Rect.fromCenter(center: const Offset(0, -34), width: 34, height: 30),
//         math.pi,
//         math.pi,
//         false,
//         Paint()
//           ..color = _C.gold
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 2);
//     for (final dx in [-18.0, 18.0]) {
//       _isoBox(canvas, dx, -16, 8, 36, const Color(0xFFF0E8D0),
//           const Color(0xFFD0C8A8), const Color(0xFFE0D8B8));
//       canvas.drawArc(
//           Rect.fromCenter(center: Offset(dx, -38), width: 14, height: 12),
//           math.pi,
//           math.pi,
//           false,
//           Paint()..color = _C.greenLight);
//       canvas.drawLine(
//           Offset(dx, -44),
//           Offset(dx, -52),
//           Paint()
//             ..color = _C.gold
//             ..strokeWidth = 2);
//       canvas.drawCircle(Offset(dx, -54), 3, Paint()..color = _C.gold);
//     }
//     for (final dx in [-14.0, 0.0, 14.0]) {
//       canvas.drawRRect(
//           RRect.fromRectAndCorners(
//               Rect.fromCenter(center: Offset(dx, -14), width: 7, height: 10),
//               topLeft: const Radius.circular(4),
//               topRight: const Radius.circular(4)),
//           Paint()..color = const Color(0xFF88CCEE).withOpacity(0.85));
//     }
//     canvas.drawCircle(
//         const Offset(0, -30),
//         38,
//         Paint()
//           ..color = _C.gold.withOpacity(fl)
//           ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22));
//     for (int i = 0; i < 8; i++) {
//       final a = i * math.pi / 4 + fT * 0.4;
//       final r = 28.0 + 6 * math.sin(fT + i * 0.7);
//       canvas.drawCircle(
//           Offset(math.cos(a) * r, -30 + math.sin(a) * r * 0.4),
//           2.5,
//           Paint()..color = _C.gold.withOpacity(0.5 + 0.4 * math.sin(fT + i)));
//     }
//   }

//   void _isoBox(Canvas canvas, double cx, double cy, double w, double h,
//       Color top, Color left, Color right) {
//     canvas.drawRect(
//         Rect.fromCenter(center: Offset(cx, cy), width: w, height: h),
//         Paint()..color = left);
//     canvas.drawRect(
//         Rect.fromLTWH(cx - w / 2, cy - h / 2, w, 6), Paint()..color = top);
//     canvas.drawRect(Rect.fromLTWH(cx + w / 2 - 4, cy - h / 2, 4, h),
//         Paint()..color = right);
//   }

//   @override
//   bool shouldRepaint(_WorldPainter o) =>
//       o.wT != wT || o.fT != fT || o.pT != pT || o.js.unlocked != js.unlocked;
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // 12. SKY PAINTER
// // ═══════════════════════════════════════════════════════════════════════════

// class _SkyPainter extends CustomPainter {
//   final double t;
//   _SkyPainter(this.t);

//   static final _rng = math.Random(42);
//   static final _stars = List.generate(
//       75,
//       (_) => [
//             _rng.nextDouble(),
//             _rng.nextDouble() * 0.45,
//             _rng.nextDouble() * 1.6 + 0.4,
//             _rng.nextDouble() * math.pi * 2,
//           ]);

//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.drawRect(
//         Offset.zero & size,
//         Paint()
//           ..shader = const LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF020C06),
//               Color(0xFF061A0C),
//               Color(0xFF0D2E14),
//               Color(0xFF1A5C2A)
//             ],
//             stops: [0, 0.3, 0.65, 1],
//           ).createShader(Offset.zero & size));
//     // Moon
//     canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.11), 16,
//         Paint()..color = const Color(0xFFE8E0C8));
//     canvas.drawCircle(Offset(size.width * 0.8 + 5, size.height * 0.11 - 2), 12,
//         Paint()..color = const Color(0xFF061A0C));
//     // Stars
//     for (final s in _stars) {
//       final o = 0.2 +
//           0.65 * math.sin(s[3] + t * math.pi * 1.2).abs().clamp(0.05, 0.9);
//       canvas.drawCircle(Offset(s[0] * size.width, s[1] * size.height), s[2],
//           Paint()..color = Colors.white.withOpacity(o));
//     }
//   }

//   @override
//   bool shouldRepaint(_SkyPainter o) => o.t != t;
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // 13. BURST PAINTER
// // ═══════════════════════════════════════════════════════════════════════════

// class _BurstPainter extends CustomPainter {
//   final double t;
//   _BurstPainter(this.t);

//   static final _rng = math.Random(55);
//   static final _pts = List.generate(
//       36,
//       (_) => [
//             (_rng.nextDouble() - 0.5) * 3.0,
//             (_rng.nextDouble() - 0.5) * 3.0,
//           ]);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final c = size.center(Offset.zero);
//     final eased = Curves.easeOut.transform(t);
//     final p = Paint();
//     for (final pt in _pts) {
//       final dist = eased * 240.0;
//       final o = (1 - eased).clamp(0.0, 1.0);
//       p.color = _C.gold.withOpacity(o * 0.85);
//       canvas.drawCircle(
//           c + Offset(pt[0] * dist, pt[1] * dist), 4 * (1 - eased * 0.6), p);
//       p.color = Colors.white.withOpacity(o * 0.4);
//       canvas.drawCircle(c + Offset(pt[0] * dist * 0.55, pt[1] * dist * 0.55),
//           2 * (1 - eased * 0.6), p);
//     }
//   }

//   @override
//   bool shouldRepaint(_BurstPainter o) => o.t != t;
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // 14. UNLOCK DIALOG
// // ═══════════════════════════════════════════════════════════════════════════

// class _UnlockDialog extends StatefulWidget {
//   final _Building b;
//   const _UnlockDialog({required this.b});
//   @override
//   State<_UnlockDialog> createState() => _UnlockDialogState();
// }

// class _UnlockDialogState extends State<_UnlockDialog>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c =
//       AnimationController(vsync: this, duration: const Duration(seconds: 3))
//         ..repeat();
//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final tc = _tierColor(widget.b.tier);
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: Container(
//         decoration: BoxDecoration(
//           color: _C.cardBg,
//           borderRadius: BorderRadius.circular(24),
//           border: Border.all(color: _C.gold.withOpacity(0.5), width: 1.5),
//           boxShadow: [
//             BoxShadow(
//                 color: _C.gold.withOpacity(0.15),
//                 blurRadius: 40,
//                 spreadRadius: 4)
//           ],
//         ),
//         padding: const EdgeInsets.all(24),
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           // Spinning ring
//           AnimatedBuilder(
//                   animation: _c,
//                   builder: (_, __) => Container(
//                         width: 96,
//                         height: 96,
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: SweepGradient(
//                                 colors: [
//                                   _C.gold.withOpacity(0),
//                                   _C.gold.withOpacity(0.45),
//                                   _C.gold.withOpacity(0)
//                                 ],
//                                 transform:
//                                     GradientRotation(_c.value * math.pi * 2))),
//                         child: Center(
//                             child: Container(
//                                 width: 80,
//                                 height: 80,
//                                 decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: _C.cardBg,
//                                     border: Border.all(color: _C.cardBorder)),
//                                 child: Icon(_tierIcon(widget.b.tier),
//                                     color: tc, size: 34))),
//                       ))
//               .animate()
//               .scale(
//                   begin: const Offset(0.2, 0.2),
//                   curve: Curves.elasticOut,
//                   duration: 900.ms)
//               .fadeIn(duration: 400.ms),
//           const SizedBox(height: 12),
//           Text(_tierLabel(widget.b.tier).toUpperCase(),
//               style: TextStyle(
//                   color: tc,
//                   fontSize: 10,
//                   letterSpacing: 2,
//                   fontWeight: FontWeight.w600)),
//           const SizedBox(height: 4),
//           Text(widget.b.nameBn,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                       color: _C.white,
//                       fontSize: 22,
//                       fontWeight: FontWeight.w800))
//               .animate(delay: 300.ms)
//               .fadeIn(duration: 400.ms)
//               .slideY(begin: 0.2),
//           const SizedBox(height: 8),
//           Text(widget.b.storyBn,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                       color: _C.textMuted, fontSize: 12, height: 1.6))
//               .animate(delay: 500.ms)
//               .fadeIn(duration: 400.ms),
//           const SizedBox(height: 20),
//           GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                       colors: [Color(0xFF0E3D22), Color(0xFF1A6A35)]),
//                   borderRadius: BorderRadius.circular(14),
//                   border: Border.all(color: _C.gold.withOpacity(0.25))),
//               child: const Center(
//                   child: Text('আলহামদুলিল্লাহ',
//                       style: TextStyle(
//                           color: _C.white,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                           letterSpacing: 0.5))),
//             ),
//           ).animate(delay: 700.ms).fadeIn(duration: 300.ms).slideY(begin: 0.3),
//         ]),
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════════════════
// // 15. HELPERS
// // ═══════════════════════════════════════════════════════════════════════════

// Color _tierColor(_Tier t) {
//   switch (t) {
//     case _Tier.seed:
//       return const Color(0xFF2ECC6A);
//     case _Tier.small:
//       return const Color(0xFF38BDF8);
//     case _Tier.medium:
//       return const Color(0xFFD4A843);
//     case _Tier.large:
//       return const Color(0xFFFF6B35);
//     case _Tier.grand:
//       return const Color(0xFFE040FB);
//   }
// }

// IconData _tierIcon(_Tier t) {
//   switch (t) {
//     case _Tier.seed:
//       return Icons.eco_rounded;
//     case _Tier.small:
//       return Icons.mosque_rounded;
//     case _Tier.medium:
//       return Icons.water_rounded;
//     case _Tier.large:
//       return Icons.park_rounded;
//     case _Tier.grand:
//       return Icons.castle_rounded;
//   }
// }

// String _tierLabel(_Tier t) {
//   switch (t) {
//     case _Tier.seed:
//       return 'প্রথম পদক্ষেপ';
//     case _Tier.small:
//       return 'নিয়মিত আমল';
//     case _Tier.medium:
//       return 'গভীর সাধনা';
//     case _Tier.large:
//       return 'উচ্চ মর্যাদা';
//     case _Tier.grand:
//       return 'চূড়ান্ত পুরস্কার';
//   }
// }
// jannah_world_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
// SETUP:
//   1. Fix the 2 import paths below (search "← adjust")
//   2. Add JannahWorldScreen() as a tab in your shell
//   No extra packages — uses only flutter_animate + flutter_riverpod
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:math' as math;
import 'package:amal_tracker/features/tracker/models/tracker_model.dart';
import 'package:amal_tracker/features/tracker/providers/tracker_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ══════════════════════════════════════════════════════════════════════════════
// TOKENS
// ══════════════════════════════════════════════════════════════════════════════
class _K {
  static const bg = Color(0xFF020C06);
  static const card = Color(0xFF0A1E0E);
  static const border = Color(0xFF163320);
  static const gold = Color(0xFFD4A843);
  static const green = Color(0xFF16A34A);
  static const teal = Color(0xFF2ECC88);
  static const river = Color(0xFF38BDF8);
  static const fire = Color(0xFFFF6B35);
  static const white = Colors.white;
  static const muted = Color(0xFF4A7A56);
  static const light = Color(0xFFD4EAD8);
  static const grassA = Color(0xFF1E7A35);
  static const grassB = Color(0xFF1A6A2E);
  static const path = Color(0xFF4A5E4A);
}

// ══════════════════════════════════════════════════════════════════════════════
// DATA MODEL
// ══════════════════════════════════════════════════════════════════════════════
enum _Tier { seed, small, medium, large, grand }

class _B {
  final String id, name, story, how;
  final _Tier tier;
  final int col, row;
  final int? reqPts, reqStreak;
  final double? reqPct;
  final String? reqKey;

  const _B(
      {required this.id,
      required this.name,
      required this.story,
      required this.how,
      required this.tier,
      required this.col,
      required this.row,
      this.reqPts,
      this.reqStreak,
      this.reqPct,
      this.reqKey});

  bool met(int pts, int str, double pct, Set<String> keys) =>
      (reqPts == null || pts >= reqPts!) &&
      (reqStreak == null || str >= reqStreak!) &&
      (reqPct == null || pct >= reqPct!) &&
      (reqKey == null || keys.contains(reqKey));
}

const _kAll = <_B>[
  _B(
      id: 'sprout',
      name: 'প্রথম চারা',
      tier: _Tier.seed,
      story:
          'প্রতিটি জান্নাতি বাগান একটি ছোট চারা থেকে শুরু।\nআপনার প্রথম আমল এই বীজ বপন করেছে।',
      how: 'যেকোনো ১টি আমল করুন',
      col: 4,
      row: 4,
      reqPts: 1),
  _B(
      id: 'mosque',
      name: 'ফজরের মসজিদ',
      tier: _Tier.small,
      story:
          'নবীজি ﷺ বলেছেন — ফজরের দুই রাকাত সুন্নত দুনিয়ার সব কিছুর চেয়ে উত্তম।\nএই মসজিদ সেই নূরের প্রতীক।',
      how: 'ফজর নামাজ + ১০ pts',
      col: 3,
      row: 3,
      reqPts: 10,
      reqKey: 'fajr'),
  _B(
      id: 'pavilion',
      name: 'তিলাওয়াতের চত্বর',
      tier: _Tier.small,
      story:
          'কুরআন তিলাওয়াতকারীর সাথে সম্মানিত ফেরেশতারা থাকেন।\nএই চত্বরে প্রতিটি আয়াত বাতাসে ভাসে।',
      how: 'কুরআন তিলাওয়াত + ২০ pts',
      col: 6,
      row: 3,
      reqPts: 20,
      reqKey: 'tilawat'),
  _B(
      id: 'fountain',
      name: 'জিকিরের ফোয়ারা',
      tier: _Tier.small,
      story:
          'আল্লাহর জিকির সবচেয়ে বড় ইবাদত।\nপ্রতিটি তাসবীহে এই ফোয়ারার পানি উঁচুতে ওঠে।',
      how: 'তাসবীহ / জিকির + ৩০ pts',
      col: 4,
      row: 6,
      reqPts: 30,
      reqKey: 'tasbih'),
  _B(
      id: 'palm',
      name: 'কাউসার খেজুর',
      tier: _Tier.small,
      story:
          '৭ দিন ধারাবাহিক আমলের বিশেষ পুরস্কার।\nজান্নাতের খেজুর গাছ যার নিচে শেষ হয় না।',
      how: '৭ দিনের streak + ৩৫ pts',
      col: 2,
      row: 5,
      reqPts: 35,
      reqStreak: 7),
  _B(
      id: 'lantern',
      name: 'দরুদের আলো',
      tier: _Tier.small,
      story:
          'একবার দরুদ পড়লে আল্লাহ ১০টি রহমত নাজিল করেন।\nএই স্তম্ভ সেই নূরের প্রতীক।',
      how: 'দরুদ পড়ুন + ৪৮ pts',
      col: 7,
      row: 5,
      reqPts: 48,
      reqKey: 'darud'),
  _B(
      id: 'bridge',
      name: 'সবরের সেতু',
      tier: _Tier.medium,
      story:
          'রোজাদারের জন্য জান্নাতে রাইয়ান নামক বিশেষ দরজা আছে।\nএই সেতু সেই পথের প্রতীক।',
      how: 'রোজা রাখুন + ৬০ pts',
      col: 4,
      row: 7,
      reqPts: 60,
      reqKey: 'siyam'),
  _B(
      id: 'cottage',
      name: 'আমলের ঘর',
      tier: _Tier.medium,
      story:
          '১০ দিন ধারাবাহিক আমলের পুরস্কার।\nজান্নাতে নেককার বান্দার বাসস্থান।',
      how: '১০ দিনের streak + ৭৫ pts',
      col: 2,
      row: 2,
      reqPts: 75,
      reqStreak: 10),
  _B(
      id: 'river',
      name: 'কাউসার নহর',
      tier: _Tier.medium,
      story:
          'কাউসার জান্নাতের একটি নদী —\nযার পানি দুধের চেয়ে সাদা, মধুর চেয়ে মিষ্টি।',
      how: 'মাসে ৭০%+ + ৯০ pts',
      col: 5,
      row: 6,
      reqPts: 90,
      reqPct: 70),
  _B(
      id: 'tuba',
      name: 'তুবা গাছ',
      tier: _Tier.large,
      story:
          'তুবার ছায়ায় একজন ঘোড়সওয়ার ১০০ বছর চলতে পারবে।\nমাসে ৯০% আমলকারীর পুরস্কার।',
      how: 'মাসে ৯০%+ + ১৩০ pts',
      col: 7,
      row: 2,
      reqPts: 130,
      reqPct: 90),
  _B(
      id: 'minaret',
      name: 'তাহাজ্জুদের মিনার',
      tier: _Tier.large,
      story:
          'রাতের তৃতীয় ভাগে আল্লাহ নেমে আসেন — কে আছ যে চাইবে?\nতাহাজ্জুদে এই মিনার থেকে নূর বের হয়।',
      how: 'তাহাজ্জুদ + ১৫০ pts',
      col: 2,
      row: 7,
      reqPts: 150,
      reqKey: 'tahajjud'),
  _B(
      id: 'palace',
      name: 'জান্নাতের মহল',
      tier: _Tier.grand,
      story:
          'যে আল্লাহর জন্য আমল করে —\nআল্লাহ তার জন্য জান্নাতে মহল নির্মাণ করেন।',
      how: '২০০ pts + ১৫ দিনের streak',
      col: 4,
      row: 1,
      reqPts: 200,
      reqStreak: 15),
];

// ══════════════════════════════════════════════════════════════════════════════
// STATE
// ══════════════════════════════════════════════════════════════════════════════
class _S {
  final bool loading;
  final int pts, streak;
  final double pct;
  final Set<String> keys, open;
  final String? newId;
  const _S(
      {this.loading = true,
      this.pts = 0,
      this.streak = 0,
      this.pct = 0,
      this.keys = const {},
      this.open = const {},
      this.newId});
  _S cp(
          {bool? loading,
          int? pts,
          int? streak,
          double? pct,
          Set<String>? keys,
          Set<String>? open,
          String? newId,
          bool clr = false}) =>
      _S(
          loading: loading ?? this.loading,
          pts: pts ?? this.pts,
          streak: streak ?? this.streak,
          pct: pct ?? this.pct,
          keys: keys ?? this.keys,
          open: open ?? this.open,
          newId: clr ? null : (newId ?? this.newId));
  bool isOpen(String id) => open.contains(id);
  _B? get next {
    final l = _kAll.where((b) => !open.contains(b.id)).toList()
      ..sort((a, b) => (a.reqPts ?? 0).compareTo(b.reqPts ?? 0));
    return l.isEmpty ? null : l.first;
  }

  int get ptsLeft => math.max(0, (next?.reqPts ?? 0) - pts);
  double get prog {
    final n = next;
    if (n == null) return 1.0;
    final needed = n.reqPts ?? 1;
    final base = open.isEmpty
        ? 0
        : _kAll
            .where((b) => open.contains(b.id))
            .map((b) => b.reqPts ?? 0)
            .fold<int>(0, math.max);
    final range = needed - base;
    if (range <= 0) return 1.0;
    return ((pts - base) / range).clamp(0.0, 1.0);
  }
}

class _N extends StateNotifier<_S> {
  _N() : super(const _S());
  void sync(ProgressSummary s, List<AmalCategory> cats) {
    final t = s.currentMonth;
    final p = t?.totalPoints ?? 0,
        str = t?.streakDays ?? 0,
        pct = t?.completionPercentage ?? 0.0;
    final idToKey = {for (final c in cats) c.id: c.key};
    final done = <String>{};
    for (final e in (s.todayEntry?.entries ?? [])) {
      if (e.completed) {
        final k = idToKey[e.categoryId];
        if (k != null) done.add(k);
      }
    }
    final prev = state.open;
    final now =
        _kAll.where((b) => b.met(p, str, pct, done)).map((b) => b.id).toSet();
    final brandNew = now.difference(prev);
    state = state.cp(
        loading: false,
        pts: p,
        streak: str,
        pct: pct,
        keys: done,
        open: now,
        newId: brandNew.isNotEmpty ? brandNew.first : null);
  }

  void clrNew() => state = state.cp(clr: true);
}

final _jp = StateNotifierProvider.autoDispose<_N, _S>((_) => _N());

// ══════════════════════════════════════════════════════════════════════════════
// SCREEN
// ══════════════════════════════════════════════════════════════════════════════
class JannahWorldScreen extends ConsumerStatefulWidget {
  const JannahWorldScreen({super.key});
  @override
  ConsumerState<JannahWorldScreen> createState() => _SS();
}

class _SS extends ConsumerState<JannahWorldScreen>
    with TickerProviderStateMixin {
  late final _sky =
      AnimationController(vsync: this, duration: const Duration(seconds: 10))
        ..repeat();
  late final _wave =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat();
  late final _flt =
      AnimationController(vsync: this, duration: const Duration(seconds: 5))
        ..repeat(reverse: true);
  late final _pls =
      AnimationController(vsync: this, duration: const Duration(seconds: 3))
        ..repeat(reverse: true);
  late final _burst = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1400));
  final _tx = TransformationController();

  bool _listView = false;
  _B? _sheetB;
  bool _sheetOpen = false;
  bool _hintShown = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) setState(() => _hintShown = false);
    });
  }

  @override
  void dispose() {
    _sky.dispose();
    _wave.dispose();
    _flt.dispose();
    _pls.dispose();
    _burst.dispose();
    _tx.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    final now = DateTime.now();

// হোম স্ক্রিন বা ড্যাশবোর্ডে এইভাবে কল করবেন
    final pa = ref.watch(
      progressSummaryProvider((year: now.year, month: now.month)),
    );
    // final pa = ref.watch(progressSummaryProvider);
    final ca = ref.watch(categoriesProvider);
    final s = ref.watch(_jp);

    if (pa.hasValue && ca.hasValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(_jp.notifier).sync(pa.value!, ca.value!);
      });
    }
    if (s.newId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _burst.forward(from: 0);
        final b =
            _kAll.firstWhere((b) => b.id == s.newId, orElse: () => _kAll.first);
        ref.read(_jp.notifier).clrNew();
        _showUnlock(b);
      });
    }

    final sz = MediaQuery.of(ctx).size;
    final loading = pa.isLoading || ca.isLoading;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _K.bg,
        body: Stack(children: [
          // Sky
          AnimatedBuilder(
              animation: _sky,
              builder: (_, __) =>
                  CustomPaint(size: sz, painter: _SkyP(_sky.value))),

          // World / List
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _listView
                ? _ListV(key: const ValueKey('l'), s: s, onTap: _tap)
                : _WorldV(
                    key: const ValueKey('w'),
                    s: s,
                    sz: sz,
                    wave: _wave,
                    flt: _flt,
                    pls: _pls,
                    tx: _tx,
                    onTap: _tap,
                    onDbl: () => _tx.value = Matrix4.identity()),
          ),

          // Top fade
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 120,
              child: IgnorePointer(
                  child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                    Colors.black.withOpacity(0.72),
                    Colors.transparent
                  ]))))),

          // HUD
          SafeArea(
              child: _HUD(
                  s: s,
                  loading: loading,
                  isList: _listView,
                  onToggle: () => setState(() => _listView = !_listView))),

          // Hint — FIX: wrap in SafeArea+Padding, NOT Positioned
          if (!_listView)
            SafeArea(
                child: AnimatedOpacity(
                    opacity: _hintShown ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 600),
                    child: Padding(
                        padding: const EdgeInsets.only(top: 52),
                        child: const Align(
                            alignment: Alignment.topCenter, child: _Hint())))),

          // Bottom bar
          Positioned(bottom: 0, left: 0, right: 0, child: _Bar(s: s)),

          // Loading
          if (loading)
            Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(
                    child: CircularProgressIndicator(
                        color: _K.gold, strokeWidth: 2))),

          // Burst
          AnimatedBuilder(
              animation: _burst,
              builder: (_, __) => _burst.value > 0 && _burst.value < 1
                  ? IgnorePointer(
                      child:
                          CustomPaint(size: sz, painter: _BurstP(_burst.value)))
                  : const SizedBox.shrink()),

          // Sheet backdrop — MUST be inside Stack but BELOW sheet
          if (_sheetOpen)
            Positioned.fill(
                child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _closeSheet,
                    child: Container(color: Colors.black.withOpacity(0.5)))),

          // Sheet
          if (_sheetB != null)
            _Sheet(b: _sheetB!, open: _sheetOpen, s: s, onClose: _closeSheet),
        ]),
      ),
    );
  }

  void _tap(_B b) {
    HapticFeedback.mediumImpact();
    setState(() {
      _sheetB = b;
      _sheetOpen = true;
    });
  }

  void _closeSheet() => setState(() => _sheetOpen = false);
  void _showUnlock(_B b) => showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => _UnlockDlg(b: b));
}

// ══════════════════════════════════════════════════════════════════════════════
// HUD
// ══════════════════════════════════════════════════════════════════════════════
class _HUD extends StatelessWidget {
  final _S s;
  final bool loading, isList;
  final VoidCallback onToggle;
  const _HUD(
      {required this.s,
      required this.loading,
      required this.isList,
      required this.onToggle});
  @override
  Widget build(BuildContext ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                const Text('আমার জান্নাত',
                    style: TextStyle(
                        color: _K.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                        shadows: [
                          Shadow(color: Colors.black54, blurRadius: 8)
                        ])),
                Text(
                    loading
                        ? 'লোড হচ্ছে...'
                        : '${s.open.length} / ${_kAll.length} স্থাপনা উন্মুক্ত',
                    style: TextStyle(
                        color: _K.white.withOpacity(0.5), fontSize: 11)),
              ])),
          _C2(Icons.local_fire_department_rounded, '${s.streak}', 'দিন',
              _K.fire),
          const SizedBox(width: 6),
          _C2(Icons.stars_rounded, '${s.pts}', 'pts', _K.gold),
          const SizedBox(width: 6),
          _C2(Icons.pie_chart_rounded, '${s.pct.toInt()}%', '', _K.teal),
          const SizedBox(width: 8),
          GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      color: isList
                          ? _K.gold.withOpacity(0.2)
                          : Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: isList
                              ? _K.gold.withOpacity(0.5)
                              : Colors.white.withOpacity(0.15))),
                  child: Icon(
                      isList ? Icons.landscape_rounded : Icons.list_rounded,
                      color: isList ? _K.gold : Colors.white.withOpacity(0.7),
                      size: 18))),
        ]),
      );
}

class _C2 extends StatelessWidget {
  final IconData ic;
  final String v, s;
  final Color c;
  const _C2(this.ic, this.v, this.s, this.c);
  @override
  Widget build(BuildContext _) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: c.withOpacity(0.35), width: 0.5)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(ic, size: 11, color: c),
        const SizedBox(width: 4),
        Text(s.isEmpty ? v : '$v $s',
            style: TextStyle(
                color: c, fontSize: 10.5, fontWeight: FontWeight.w700)),
      ]));
}

// ══════════════════════════════════════════════════════════════════════════════
// HINT — plain widget, no Positioned
// ══════════════════════════════════════════════════════════════════════════════
class _Hint extends StatelessWidget {
  const _Hint();
  @override
  Widget build(BuildContext ctx) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.55),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.12))),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _hi(Icons.touch_app_rounded, 'ট্যাপ'),
            _div(),
            _hi(Icons.pinch_rounded, 'পিঞ্চ'),
            _div(),
            _hi(Icons.open_with_rounded, 'টান'),
            _div(),
            _hi(Icons.my_location_rounded, 'রিসেট'),
          ]));
  Widget _hi(IconData i, String l) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(i, size: 14, color: Colors.white.withOpacity(0.5)),
        const SizedBox(height: 3),
        Text(l,
            style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 9))
      ]));
  Widget _div() =>
      Container(width: 0.5, height: 22, color: Colors.white.withOpacity(0.12));
}

// ══════════════════════════════════════════════════════════════════════════════
// WORLD VIEW
// ══════════════════════════════════════════════════════════════════════════════
class _WorldV extends StatelessWidget {
  final _S s;
  final Size sz;
  final AnimationController wave, flt, pls;
  final TransformationController tx;
  final void Function(_B) onTap;
  final VoidCallback onDbl;
  const _WorldV(
      {super.key,
      required this.s,
      required this.sz,
      required this.wave,
      required this.flt,
      required this.pls,
      required this.tx,
      required this.onTap,
      required this.onDbl});

  // Iso projection
  static Offset _iso(double c, double r, Size sz) =>
      Offset(sz.width / 2 + (c - r) * 36.0, sz.height * 0.40 + (c + r) * 18.0);

  @override
  Widget build(BuildContext ctx) => GestureDetector(
        onDoubleTap: onDbl,
        child: InteractiveViewer(
          transformationController: tx,
          minScale: 0.45, maxScale: 2.8,
          // FIX: large boundary so world can pan freely
          boundaryMargin: EdgeInsets.all(sz.width * 0.8),
          child: SizedBox(
              width: sz.width,
              height: sz.height,
              child: AnimatedBuilder(
                  animation: Listenable.merge([wave, flt, pls]),
                  builder: (_, __) => Stack(children: [
                        // Canvas
                        CustomPaint(
                            size: sz,
                            painter: _WP(
                                s: s,
                                sz: sz,
                                wT: wave.value,
                                fT: flt.value,
                                pT: pls.value)),
                        // Tap areas — sized & positioned correctly
                        ..._kAll.map((b) {
                          final p =
                              _iso(b.col.toDouble(), b.row.toDouble(), sz);
                          // Larger hit area, centred on building
                          return Positioned(
                              left: p.dx - 36,
                              top: p.dy - 60,
                              width: 72,
                              height: 80,
                              child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => onTap(b),
                                  child: Container(color: Colors.transparent)));
                        }),
                      ]))),
        ),
      );
}

// ══════════════════════════════════════════════════════════════════════════════
// LIST VIEW
// ══════════════════════════════════════════════════════════════════════════════
class _ListV extends StatelessWidget {
  final _S s;
  final void Function(_B) onTap;
  const _ListV({super.key, required this.s, required this.onTap});

  @override
  Widget build(BuildContext ctx) {
    final pad = MediaQuery.of(ctx).padding;
    final opened = _kAll.where((b) => s.isOpen(b.id)).toList()
      ..sort((a, b) => a.tier.index.compareTo(b.tier.index));
    final locked = _kAll.where((b) => !s.isOpen(b.id)).toList()
      ..sort((a, b) => (a.reqPts ?? 0).compareTo(b.reqPts ?? 0));
    return ListView(
      padding: EdgeInsets.fromLTRB(16, pad.top + 62, 16, 110 + pad.bottom),
      children: [
        _SumCard(s: s),
        const SizedBox(height: 18),
        if (opened.isNotEmpty) ...[
          _sec('✦  অর্জিত (${opened.length})', _K.gold),
          const SizedBox(height: 8),
          ...opened.map((b) => _Tile(b: b, s: s, onTap: () => onTap(b))),
          const SizedBox(height: 18),
        ],
        if (locked.isNotEmpty) ...[
          _sec('🔒  বাকি (${locked.length})', _K.muted),
          const SizedBox(height: 8),
          ...locked.map((b) => _Tile(b: b, s: s, onTap: () => onTap(b))),
        ],
      ],
    );
  }

  Widget _sec(String t, Color c) => Text(t,
      style: TextStyle(
          color: c,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8));
}

class _SumCard extends StatelessWidget {
  final _S s;
  const _SumCard({required this.s});
  @override
  Widget build(BuildContext _) {
    final pct = s.open.length / _kAll.length;
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: _K.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _K.border, width: 0.5)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text('জান্নাতের যাত্রা',
                      style: TextStyle(
                          color: _K.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text('${s.open.length} টি স্থাপনা উন্মুক্ত',
                      style: const TextStyle(color: _K.muted, fontSize: 12)),
                ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('${s.pts}',
                  style: const TextStyle(
                      color: _K.gold,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 1)),
              const Text('pts',
                  style: TextStyle(color: _K.muted, fontSize: 11)),
            ]),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                        value: pct,
                        minHeight: 7,
                        backgroundColor: Colors.white.withOpacity(0.07),
                        valueColor: const AlwaysStoppedAnimation(_K.gold)))),
            const SizedBox(width: 10),
            Text('${(pct * 100).toInt()}%',
                style: const TextStyle(
                    color: _K.gold, fontSize: 11, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            _si(Icons.local_fire_department_rounded, '${s.streak} দিন',
                'streak', _K.fire),
            const SizedBox(width: 14),
            _si(Icons.pie_chart_rounded, '${s.pct.toInt()}%', 'সমাপ্তি',
                _K.teal),
            const SizedBox(width: 14),
            _si(Icons.lock_outline_rounded, '${_kAll.length - s.open.length}টি',
                'বাকি', _K.muted),
          ]),
        ]));
  }

  Widget _si(IconData i, String v, String l, Color c) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(i, size: 12, color: c),
        const SizedBox(width: 4),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(v,
              style: TextStyle(
                  color: c, fontSize: 11, fontWeight: FontWeight.w600)),
          Text(l, style: const TextStyle(color: _K.muted, fontSize: 9)),
        ])
      ]);
}

class _Tile extends StatelessWidget {
  final _B b;
  final _S s;
  final VoidCallback onTap;
  const _Tile({required this.b, required this.s, required this.onTap});
  @override
  Widget build(BuildContext _) {
    final open = s.isOpen(b.id);
    final tc = _tc(b.tier);
    final ptsOk = b.reqPts == null || s.pts >= b.reqPts!;
    final strOk = b.reqStreak == null || s.streak >= b.reqStreak!;
    final pctOk = b.reqPct == null || s.pct >= b.reqPct!;
    final keyOk = b.reqKey == null || s.keys.contains(b.reqKey);
    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
              color: open ? _K.card : const Color(0xFF061209),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: open ? tc.withOpacity(0.3) : _K.border,
                  width: open ? 1.0 : 0.5)),
          child: Row(children: [
            // Icon
            Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: open
                        ? tc.withOpacity(0.12)
                        : Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: open
                            ? tc.withOpacity(0.3)
                            : Colors.white.withOpacity(0.08))),
                child: Icon(open ? _ti(b.tier) : Icons.lock_rounded,
                    color: open ? tc : _K.muted.withOpacity(0.5), size: 20)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Expanded(
                        child: Text(b.name,
                            style: TextStyle(
                                color:
                                    open ? _K.white : _K.light.withOpacity(0.6),
                                fontSize: 13,
                                fontWeight: FontWeight.w600))),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                            color: tc.withOpacity(open ? 0.15 : 0.06),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(_tl(b.tier),
                            style: TextStyle(
                                color: open ? tc : _K.muted,
                                fontSize: 9,
                                fontWeight: FontWeight.w600))),
                  ]),
                  const SizedBox(height: 4),
                  if (open)
                    Text(b.story.split('\n').first,
                        style: const TextStyle(color: _K.muted, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis)
                  else
                    Wrap(spacing: 5, runSpacing: 4, children: [
                      if (b.reqPts != null)
                        _pill(
                            '✦ ${b.reqPts} pts', ptsOk, '${s.pts}/${b.reqPts}'),
                      if (b.reqStreak != null)
                        _pill('🔥 ${b.reqStreak}দিন', strOk,
                            '${s.streak}/${b.reqStreak}'),
                      if (b.reqPct != null)
                        _pill('% ${b.reqPct!.toInt()}', pctOk,
                            '${s.pct.toInt()}%'),
                      if (b.reqKey != null)
                        _pill(b.reqKey!, keyOk, keyOk ? '✓' : 'বাকি'),
                    ]),
                ])),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right_rounded,
                color: open ? tc.withOpacity(0.6) : _K.muted.withOpacity(0.3),
                size: 20),
          ]),
        )).animate().fadeIn(duration: 200.ms).slideX(begin: 0.03);
  }

  Widget _pill(String l, bool ok, String prog) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
          color:
              ok ? _K.green.withOpacity(0.12) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: ok
                  ? _K.green.withOpacity(0.3)
                  : Colors.white.withOpacity(0.08))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (ok) const Icon(Icons.check_rounded, size: 9, color: _K.green),
        if (ok) const SizedBox(width: 3),
        Text(ok ? l : '$l  ($prog)',
            style: TextStyle(
                color: ok ? _K.green : _K.muted,
                fontSize: 9,
                fontWeight: FontWeight.w500)),
      ]));
}

// ══════════════════════════════════════════════════════════════════════════════
// BOTTOM BAR
// ══════════════════════════════════════════════════════════════════════════════
class _Bar extends StatelessWidget {
  final _S s;
  const _Bar({required this.s});
  @override
  Widget build(BuildContext ctx) {
    final n = s.next;
    final pad = MediaQuery.of(ctx).padding.bottom;
    return Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, pad + 14),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.82),
            border: Border(
                top: BorderSide(
                    color: Colors.white.withOpacity(0.07), width: 0.5))),
        child: n == null
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.celebration_rounded, color: _K.gold, size: 16),
                const SizedBox(width: 8),
                const Text('মাশাআল্লাহ! জান্নাত পরিপূর্ণ হয়েছে 🌟',
                    style: TextStyle(
                        color: _K.gold,
                        fontSize: 13,
                        fontWeight: FontWeight.w600))
              ])
            : Column(mainAxisSize: MainAxisSize.min, children: [
                Row(children: [
                  Expanded(
                      child: Text('পরবর্তী: ${n.name}',
                          style: const TextStyle(
                              color: _K.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600))),
                  Text(
                      s.ptsLeft > 0 ? 'আরও ${s.ptsLeft} pts' : 'অন্য শর্ত বাকি',
                      style: const TextStyle(
                          color: _K.gold,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ]),
                const SizedBox(height: 6),
                ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                        value: s.prog,
                        minHeight: 5,
                        backgroundColor: Colors.white.withOpacity(0.08),
                        valueColor: const AlwaysStoppedAnimation(_K.gold))),
                const SizedBox(height: 4),
                Text(n.how,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.4), fontSize: 10)),
              ]));
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SHEET
// ══════════════════════════════════════════════════════════════════════════════
class _Sheet extends StatelessWidget {
  final _B b;
  final bool open;
  final _S s;
  final VoidCallback onClose;
  const _Sheet(
      {required this.b,
      required this.open,
      required this.s,
      required this.onClose});

  @override
  Widget build(BuildContext ctx) {
    final isOpen = s.isOpen(b.id);
    final pad = MediaQuery.of(ctx).padding.bottom;
    final tc = _tc(b.tier);
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      bottom: open ? 0 : -520,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              color: _K.card,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(color: _K.border, width: 0.5),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 30)
              ]),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                        color: _K.border,
                        borderRadius: BorderRadius.circular(99)))),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, pad + 18),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                // Tier badge
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                        color: tc.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: tc.withOpacity(0.3))),
                    child: Text(_tl(b.tier),
                        style: TextStyle(
                            color: tc,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8))),
                const SizedBox(height: 10),
                Text(b.name,
                    style: const TextStyle(
                        color: _K.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(b.story,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: _K.muted, fontSize: 13, height: 1.6)),
                const SizedBox(height: 16),
                isOpen
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        decoration: BoxDecoration(
                            color: _K.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: _K.green.withOpacity(0.3))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle_rounded,
                                  color: _K.green, size: 16),
                              const SizedBox(width: 8),
                              Flexible(
                                  child: Text(b.how,
                                      style: const TextStyle(
                                          color: _K.green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600))),
                            ]))
                    : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            color: const Color(0xFF061209),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: _K.border)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('আনলক করতে হবে',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.3),
                                      fontSize: 10,
                                      letterSpacing: 0.8)),
                              const SizedBox(height: 10),
                              if (b.reqPts != null)
                                _cr(
                                    Icons.stars_rounded,
                                    'মোট পয়েন্ট',
                                    '${s.pts}',
                                    '${b.reqPts}',
                                    s.pts >= b.reqPts!),
                              if (b.reqStreak != null)
                                _cr(
                                    Icons.local_fire_department_rounded,
                                    'ধারাবাহিক দিন',
                                    '${s.streak}',
                                    '${b.reqStreak}',
                                    s.streak >= b.reqStreak!),
                              if (b.reqPct != null)
                                _cr(
                                    Icons.pie_chart_rounded,
                                    'মাসিক সমাপ্তি',
                                    '${s.pct.toInt()}%',
                                    '${b.reqPct!.toInt()}%',
                                    s.pct >= b.reqPct!),
                              if (b.reqKey != null)
                                _cr(
                                    Icons.task_alt_rounded,
                                    'আমল: ${b.reqKey}',
                                    s.keys.contains(b.reqKey)
                                        ? 'সম্পন্ন'
                                        : 'বাকি',
                                    'সম্পন্ন',
                                    s.keys.contains(b.reqKey)),
                            ])),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _cr(IconData ic, String lbl, String cur, String need, bool done) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 9),
          child: Row(children: [
            Icon(ic, size: 13, color: done ? _K.green : _K.muted),
            const SizedBox(width: 10),
            Expanded(
                child: Text(lbl,
                    style: const TextStyle(color: _K.light, fontSize: 12))),
            if (!done) ...[
              SizedBox(
                  width: 55,
                  height: 4,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                          value: _prog(cur, need),
                          backgroundColor: Colors.white.withOpacity(0.07),
                          valueColor: const AlwaysStoppedAnimation(_K.gold)))),
              const SizedBox(width: 8),
            ],
            Text(done ? '✓' : '$cur / $need',
                style: TextStyle(
                    color: done ? _K.green : _K.gold,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600)),
          ]));

  double _prog(String c, String n) {
    try {
      return (double.parse(c.replaceAll(RegExp(r'[^\d.]'), '')) /
              double.parse(n.replaceAll(RegExp(r'[^\d.]'), '')))
          .clamp(0.0, 1.0);
    } catch (_) {
      return 0;
    }
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// WORLD PAINTER — canvas buildings, all shapes properly drawn
// ══════════════════════════════════════════════════════════════════════════════
class _WP extends CustomPainter {
  final _S s;
  final Size sz;
  final double wT, fT, pT;
  _WP(
      {required this.s,
      required this.sz,
      required this.wT,
      required this.fT,
      required this.pT});

  static const int _C = 9, _R = 9;
  static const double _TW = 72, _TH = 36, _D = 7;

  // Iso projection
  Offset _p(double c, double r) => Offset(
      sz.width / 2 + (c - r) * _TW / 2, sz.height * 0.40 + (c + r) * _TH / 2);

  @override
  void paint(Canvas canvas, Size _) {
    // Tiles
    for (int r = 0; r < _R; r++)
      for (int c = 0; c < _C; c++) _tile(canvas, c, r);
    // Buildings sorted back→front
    final sorted = List<_B>.from(_kAll)
      ..sort((a, b) => (a.col + a.row).compareTo(b.col + b.row));
    for (final b in sorted) _bld(canvas, b);
  }

  // ── Tile ──────────────────────────────────────────────────────────────────
  void _tile(Canvas canvas, int c, int r) {
    final p = _p(c.toDouble(), r.toDouble());
    final hw = _TW / 2, hh = _TH / 2;
    final face = Path()
      ..moveTo(p.dx, p.dy - hh)
      ..lineTo(p.dx + hw, p.dy)
      ..lineTo(p.dx, p.dy + hh)
      ..lineTo(p.dx - hw, p.dy)
      ..close();
    const river = [(4, 5), (4, 6), (5, 6), (5, 7), (4, 7), (3, 7)];
    const path = [
      (4, 2),
      (4, 3),
      (4, 4),
      (3, 3),
      (5, 3),
      (3, 4),
      (5, 4),
      (3, 5),
      (5, 5),
      (3, 2),
      (5, 2)
    ];
    final isRiver = river.contains((c, r));
    final isPath = path.contains((c, r));
    Color top, left, right;
    if (isRiver) {
      final wv = 0.5 + 0.4 * math.sin(wT * math.pi * 2 + c * 0.7);
      top = Color.lerp(const Color(0xFF1E6A8A), const Color(0xFF2A88AA), wv)!;
      left = const Color(0xFF0E3A50);
      right = const Color(0xFF104055);
    } else if (isPath) {
      top = _K.path;
      left = const Color(0xFF2E3E2E);
      right = const Color(0xFF3A4A3A);
    } else if ((c + r) % 2 == 0) {
      top = _K.grassA;
      left = const Color(0xFF0E4020);
      right = const Color(0xFF124A24);
    } else {
      top = _K.grassB;
      left = const Color(0xFF0C3018);
      right = const Color(0xFF0F3A1C);
    }
    canvas.drawPath(face, Paint()..color = top);
    canvas.drawPath(
        Path()
          ..moveTo(p.dx - hw, p.dy)
          ..lineTo(p.dx, p.dy + hh)
          ..lineTo(p.dx, p.dy + hh + _D)
          ..lineTo(p.dx - hw, p.dy + _D)
          ..close(),
        Paint()..color = left);
    canvas.drawPath(
        Path()
          ..moveTo(p.dx + hw, p.dy)
          ..lineTo(p.dx, p.dy + hh)
          ..lineTo(p.dx, p.dy + hh + _D)
          ..lineTo(p.dx + hw, p.dy + _D)
          ..close(),
        Paint()..color = right);
    canvas.drawPath(
        face,
        Paint()
          ..color = Colors.black.withOpacity(0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5);
    if (isRiver) {
      final sy = p.dy - hh * 0.3 + math.sin(wT * math.pi * 2 + c) * 1.5;
      canvas.drawLine(
          Offset(p.dx - hw * 0.5, sy),
          Offset(p.dx + hw * 0.5, sy),
          Paint()
            ..color = Colors.white.withOpacity(0.14)
            ..strokeWidth = 1.2
            ..strokeCap = StrokeCap.round);
    }
  }

  // ── Building dispatcher ───────────────────────────────────────────────────
  void _bld(Canvas canvas, _B b) {
    final isOpen = s.isOpen(b.id);
    final pos = _p(b.col.toDouble(), b.row.toDouble());
    final float = isOpen ? math.sin(fT * math.pi + b.col * 0.5) * 2.5 : 0.0;
    canvas.save();
    canvas.translate(pos.dx, pos.dy - float);
    if (isOpen) {
      switch (b.id) {
        case 'sprout':
          _sprout(canvas);
          break;
        case 'mosque':
          _mosque(canvas);
          break;
        case 'pavilion':
          _pavilion(canvas);
          break;
        case 'fountain':
          _fountain(canvas);
          break;
        case 'palm':
          _palm(canvas);
          break;
        case 'lantern':
          _lantern(canvas);
          break;
        case 'bridge':
          _bridge(canvas);
          break;
        case 'cottage':
          _cottage(canvas);
          break;
        case 'river':
          _riverM(canvas);
          break;
        case 'tuba':
          _tuba(canvas);
          break;
        case 'minaret':
          _minaret(canvas);
          break;
        case 'palace':
          _palace(canvas);
          break;
      }
    } else {
      _locked(canvas, b);
    }
    canvas.restore();
  }

  // ── LOCKED — clear silhouette + lock icon ─────────────────────────────────
  void _locked(Canvas canvas, _B b) {
    final h = [28.0, 40.0, 52.0, 62.0, 78.0][b.tier.index];
    final pulseAlpha = 0.55 + 0.2 * math.sin(pT * math.pi);

    // Draw the actual building shape but dark/desaturated
    canvas.saveLayer(
        null,
        Paint()
          ..color = Color.fromARGB((pulseAlpha * 255).toInt(), 255, 255, 255));
    switch (b.id) {
      case 'sprout':
        _sprout(canvas, locked: true);
        break;
      case 'mosque':
        _mosque(canvas, locked: true);
        break;
      case 'pavilion':
        _pavilion(canvas, locked: true);
        break;
      case 'fountain':
        _fountain(canvas, locked: true);
        break;
      case 'palm':
        _palm(canvas, locked: true);
        break;
      case 'lantern':
        _lantern(canvas, locked: true);
        break;
      case 'bridge':
        _bridge(canvas, locked: true);
        break;
      case 'cottage':
        _cottage(canvas, locked: true);
        break;
      case 'river':
        _riverM(canvas, locked: true);
        break;
      case 'tuba':
        _tuba(canvas, locked: true);
        break;
      case 'minaret':
        _minaret(canvas, locked: true);
        break;
      case 'palace':
        _palace(canvas, locked: true);
        break;
    }
    canvas.restore();

    // Dark fog
    canvas.drawCircle(
        Offset(0, -h * 0.45),
        h * 0.55,
        Paint()
          ..color = Colors.black.withOpacity(0.45)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14));

    // Lock icon — clear & visible
    final lkO = 0.8 + 0.15 * math.sin(pT * math.pi);
    final lkP = Paint()..color = Colors.white.withOpacity(lkO);
    // shackle arc
    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(0, -h * 0.45 + 2), width: 13, height: 13),
        math.pi,
        math.pi,
        false,
        Paint()
          ..color = Colors.white.withOpacity(lkO)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.8
          ..strokeCap = StrokeCap.round);
    // body
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(0, -h * 0.45 + 10), width: 17, height: 12),
            const Radius.circular(3)),
        lkP);
    // keyhole
    canvas.drawCircle(
        Offset(0, -h * 0.45 + 10), 3, Paint()..color = const Color(0xFF0A1E0E));
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(0, -h * 0.45 + 13), width: 2.5, height: 4),
        Paint()..color = const Color(0xFF0A1E0E));
  }

  // ── Buildings ─────────────────────────────────────────────────────────────

  // helper: desaturate color for locked state
  Color _dim(Color c) => Color.lerp(c, const Color(0xFF1A2A1A), 0.72)!;

  void _isoBox(Canvas canvas, double cx, double cy, double w, double h,
      Color top, Color left, Color right,
      {bool locked = false}) {
    if (locked) {
      top = _dim(top);
      left = _dim(left);
      right = _dim(right);
    }
    canvas.drawRect(
        Rect.fromCenter(center: Offset(cx, cy), width: w, height: h),
        Paint()..color = left);
    canvas.drawRect(
        Rect.fromLTWH(cx - w / 2, cy - h / 2, w, 6), Paint()..color = top);
    canvas.drawRect(Rect.fromLTWH(cx + w / 2 - 4, cy - h / 2, 4, h),
        Paint()..color = right);
  }

  // ── SPROUT ────────────────────────────────────────────────────────────────
  void _sprout(Canvas canvas, {bool locked = false}) {
    final g = locked ? _dim(const Color(0xFF2ECC5A)) : const Color(0xFF2ECC5A);
    final g2 = locked ? _dim(const Color(0xFF26BB50)) : const Color(0xFF26BB50);
    final base =
        locked ? _dim(const Color(0xFF1A5C2A)) : const Color(0xFF1A5C2A);
    canvas.drawOval(
        Rect.fromCenter(center: const Offset(0, 4), width: 28, height: 11),
        Paint()..color = base);
    canvas.drawLine(
        const Offset(0, 4),
        const Offset(0, -10),
        Paint()
          ..color = g
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke);
    canvas.drawPath(
        Path()
          ..moveTo(0, -4)
          ..cubicTo(-10, -10, -14, -16, -6, -20)
          ..quadraticBezierTo(-3, -12, 0, -5)
          ..close(),
        Paint()..color = g);
    canvas.drawPath(
        Path()
          ..moveTo(0, -6)
          ..cubicTo(8, -10, 12, -16, 5, -20)
          ..quadraticBezierTo(2, -11, 0, -7)
          ..close(),
        Paint()..color = g2);
  }

  // ── MOSQUE ────────────────────────────────────────────────────────────────
  void _mosque(Canvas canvas, {bool locked = false}) {
    final wall =
        locked ? _dim(const Color(0xFFE8D5B0)) : const Color(0xFFE8D5B0);
    final dome =
        locked ? _dim(const Color(0xFF2EA868)) : const Color(0xFF2EA868);
    final gold = locked ? _dim(_K.gold) : _K.gold;
    final base =
        locked ? _dim(const Color(0xFF2A3A2A)) : const Color(0xFF2A3A2A);
    canvas.drawOval(
        Rect.fromCenter(center: const Offset(0, 6), width: 44, height: 16),
        Paint()..color = base);
    _isoBox(
        canvas,
        0,
        -2,
        38,
        26,
        wall,
        locked ? _dim(const Color(0xFFB8A880)) : const Color(0xFFB8A880),
        locked ? _dim(const Color(0xFFD0BC90)) : const Color(0xFFD0BC90),
        locked: false);
    canvas.drawArc(
        Rect.fromCenter(center: const Offset(0, -26), width: 24, height: 22),
        math.pi,
        math.pi,
        false,
        Paint()..color = dome);
    canvas.drawArc(
        Rect.fromCenter(center: const Offset(0, -26), width: 24, height: 22),
        math.pi,
        math.pi,
        false,
        Paint()
          ..color = gold
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
    for (final dx in [-15.0, 15.0]) {
      _isoBox(
          canvas,
          dx,
          -6,
          8,
          38,
          wall,
          locked ? _dim(const Color(0xFFB8A880)) : const Color(0xFFB8A880),
          locked ? _dim(const Color(0xFFD0BC90)) : const Color(0xFFD0BC90),
          locked: false);
      canvas.drawCircle(Offset(dx, -30), 3, Paint()..color = gold);
    }
    if (!locked) {
      final g = 0.1 + 0.07 * math.sin(fT * math.pi * 1.2);
      canvas.drawCircle(
          const Offset(0, -22),
          20,
          Paint()
            ..color = _K.gold.withOpacity(g)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12));
    }
  }

  // ── PAVILION ──────────────────────────────────────────────────────────────
  void _pavilion(Canvas canvas, {bool locked = false}) {
    final post =
        locked ? _dim(const Color(0xFFD4B870)) : const Color(0xFFD4B870);
    final rf1 =
        locked ? _dim(const Color(0xFF2A7A4A)) : const Color(0xFF2A7A4A);
    final rf2 =
        locked ? _dim(const Color(0xFF4A9A6A)) : const Color(0xFF4A9A6A);
    for (final dx in [-12.0, -4.0, 4.0, 12.0]) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset(dx, -12), width: 4, height: 28),
              const Radius.circular(2)),
          Paint()..color = post);
    }
    canvas.drawPath(
        Path()
          ..moveTo(0, -38)
          ..lineTo(28, -22)
          ..lineTo(-28, -22)
          ..close(),
        Paint()..color = rf1);
    canvas.drawPath(
        Path()
          ..moveTo(0, -46)
          ..lineTo(22, -32)
          ..lineTo(-22, -32)
          ..close(),
        Paint()..color = rf2);
    if (!locked) {
      canvas.drawPath(
          Path()
            ..moveTo(-8, -2)
            ..lineTo(8, -6)
            ..lineTo(8, 4)
            ..lineTo(-8, 2)
            ..close(),
          Paint()..color = const Color(0xFFE8D0A0));
      canvas.drawLine(
          const Offset(0, -6),
          const Offset(0, 4),
          Paint()
            ..color = const Color(0xFFB8A070)
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke);
    }
  }

  // ── FOUNTAIN ──────────────────────────────────────────────────────────────
  void _fountain(Canvas canvas, {bool locked = false}) {
    final basin =
        locked ? _dim(const Color(0xFF5A7A8A)) : const Color(0xFF5A7A8A);
    final water = locked ? _dim(_K.river) : _K.river;
    final pillar =
        locked ? _dim(const Color(0xFF6A8A9A)) : const Color(0xFF6A8A9A);
    canvas.drawOval(
        Rect.fromCenter(center: const Offset(0, 4), width: 36, height: 16),
        Paint()..color = basin);
    canvas.drawOval(
        Rect.fromCenter(center: const Offset(0, 3), width: 26, height: 11),
        Paint()..color = water.withOpacity(0.85));
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: const Offset(0, -6), width: 6, height: 18),
            const Radius.circular(3)),
        Paint()..color = pillar);
    if (!locked) {
      final ah = 12 + 4 * math.sin(wT * math.pi * 2);
      final wp = Paint()
        ..color = _K.river.withOpacity(0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(
          Path()
            ..moveTo(0, -14)
            ..quadraticBezierTo(10, -14 - ah, 12, 0),
          wp);
      canvas.drawPath(
          Path()
            ..moveTo(0, -14)
            ..quadraticBezierTo(-10, -14 - ah, -12, 0),
          wp);
      canvas.drawCircle(
          const Offset(0, -6),
          11,
          Paint()
            ..color = _K.river.withOpacity(0.12)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
    }
  }

  // ── PALM ──────────────────────────────────────────────────────────────────
  void _palm(Canvas canvas, {bool locked = false}) {
    final trunk =
        locked ? _dim(const Color(0xFF8B5E3C)) : const Color(0xFF8B5E3C);
    final leaf =
        locked ? _dim(const Color(0xFF2ECC6A)) : const Color(0xFF2ECC6A);
    final date = locked ? _dim(_K.gold) : _K.gold;
    final sw = locked ? 0.0 : math.sin(fT * 0.9) * 3.0;
    canvas.drawPath(
        Path()
          ..moveTo(-3, 6)
          ..quadraticBezierTo(sw * 0.3 - 1, -18, sw, -42)
          ..lineTo(sw + 4, -42)
          ..quadraticBezierTo(sw * 0.3 + 3, -18, 4, 6)
          ..close(),
        Paint()..color = trunk);
    final fp = Paint()
      ..color = leaf
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    for (final a in [-0.8, -0.3, 0.1, 0.5, 0.9, 1.3]) {
      final sa = a + sw * 0.05;
      canvas.drawPath(
          Path()
            ..moveTo(sw, -42)
            ..quadraticBezierTo(
                sw + math.cos(sa) * 12,
                -42 + math.sin(sa) * 6 - 4,
                sw + math.cos(sa) * 24,
                -42 + math.sin(sa) * 12),
          fp);
    }
    for (int i = 0; i < 5; i++)
      canvas.drawCircle(
          Offset(sw + (i - 2) * 3, -40), 2.5, Paint()..color = date);
  }

  // ── LANTERN ───────────────────────────────────────────────────────────────
  void _lantern(Canvas canvas, {bool locked = false}) {
    final post =
        locked ? _dim(const Color(0xFF7A6A4A)) : const Color(0xFF7A6A4A);
    final base =
        locked ? _dim(const Color(0xFF3A3A2A)) : const Color(0xFF3A3A2A);
    final flame =
        locked ? _dim(const Color(0xFFFFD070)) : const Color(0xFFFFD070);
    final pulse = locked ? 0.7 : 0.7 + 0.3 * math.sin(fT * math.pi * 2.5);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: const Offset(0, -8), width: 5, height: 28),
            const Radius.circular(2)),
        Paint()..color = post);
    canvas.drawOval(
        Rect.fromCenter(center: const Offset(0, 4), width: 18, height: 8),
        Paint()..color = base);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: const Offset(0, -28), width: 14, height: 16),
            const Radius.circular(3)),
        Paint()..color = flame.withOpacity(0.9 * pulse));
    if (!locked) {
      canvas.drawCircle(
          const Offset(0, -28),
          16 * pulse,
          Paint()
            ..color = const Color(0xFFFFD070).withOpacity(0.22 * pulse)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
    }
  }

  // ── BRIDGE ────────────────────────────────────────────────────────────────
  void _bridge(Canvas canvas, {bool locked = false}) {
    final sc = locked ? _dim(const Color(0xFF7A7A6A)) : const Color(0xFF7A7A6A);
    final sc2 =
        locked ? _dim(const Color(0xFF5A5A4A)) : const Color(0xFF5A5A4A);
    canvas.drawPath(
        Path()
          ..moveTo(-26, -2)
          ..lineTo(26, -2)
          ..lineTo(22, 8)
          ..lineTo(-22, 8)
          ..close(),
        Paint()..color = sc);
    canvas.drawArc(
        Rect.fromCenter(center: const Offset(0, 6), width: 28, height: 18),
        0,
        math.pi,
        false,
        Paint()
          ..color = sc2
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5);
    for (double dx = -18; dx <= 22; dx += 8) {
      canvas.drawLine(
          Offset(dx, -2),
          Offset(dx, -12),
          Paint()
            ..color = sc
            ..strokeWidth = 2.5);
    }
    canvas.drawLine(
        const Offset(-22, -12),
        const Offset(26, -12),
        Paint()
          ..color = sc
          ..strokeWidth = 3);
  }

  // ── COTTAGE ───────────────────────────────────────────────────────────────
  void _cottage(Canvas canvas, {bool locked = false}) {
    final wall =
        locked ? _dim(const Color(0xFFD4C090)) : const Color(0xFFD4C090);
    final roof =
        locked ? _dim(const Color(0xFFA84848)) : const Color(0xFFA84848);
    final win =
        locked ? _dim(const Color(0xFF88CCF0)) : const Color(0xFF88CCF0);
    final door =
        locked ? _dim(const Color(0xFF8B5E3C)) : const Color(0xFF8B5E3C);
    _isoBox(
        canvas,
        0,
        -2,
        44,
        26,
        wall,
        locked ? _dim(const Color(0xFFB8A878)) : const Color(0xFFB8A878),
        locked ? _dim(const Color(0xFFC8B888)) : const Color(0xFFC8B888));
    canvas.drawPath(
        Path()
          ..moveTo(0, -32)
          ..lineTo(26, -18)
          ..lineTo(-26, -18)
          ..close(),
        Paint()..color = roof);
    for (final dx in [-10.0, 10.0]) {
      canvas.drawRect(
          Rect.fromCenter(center: Offset(dx, -8), width: 9, height: 9),
          Paint()..color = win);
    }
    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromCenter(center: const Offset(0, -2), width: 8, height: 12),
            topLeft: const Radius.circular(4),
            topRight: const Radius.circular(4)),
        Paint()..color = door);
    _isoBox(
        canvas,
        14,
        -30,
        8,
        14,
        wall,
        locked ? _dim(const Color(0xFFB8A878)) : const Color(0xFFB8A878),
        locked ? _dim(const Color(0xFFC8B888)) : const Color(0xFFC8B888));
    if (!locked) {
      for (int i = 0; i < 3; i++)
        canvas.drawCircle(
            Offset(14 + math.sin(fT * 0.8 + i) * 2, -42 - i * 5),
            2.5 - i * 0.4,
            Paint()..color = Colors.white.withOpacity(0.09 - i * 0.025));
    }
  }

  // ── RIVER MARKER ──────────────────────────────────────────────────────────
  void _riverM(Canvas canvas, {bool locked = false}) {
    final wv = locked ? 0.5 : 0.5 + 0.5 * math.sin(wT * math.pi * 2);
    final c = locked
        ? _dim(
            Color.lerp(const Color(0xFF1A5A7A), const Color(0xFF2A8AA0), wv)!)
        : Color.lerp(const Color(0xFF1A5A7A), const Color(0xFF2A8AA0), wv)!;
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 44, height: 18),
        Paint()..color = c);
    if (!locked) {
      for (int i = 0; i < 6; i++)
        canvas.drawCircle(
            Offset(-20.0 + i * 8 + math.sin(wT * 2 + i) * 2,
                math.sin(wT * 1.5 + i * 0.8) * 3),
            1.5,
            Paint()..color = Colors.white.withOpacity(0.55));
    }
  }

  // ── TUBA ──────────────────────────────────────────────────────────────────
  void _tuba(Canvas canvas, {bool locked = false}) {
    final trunk = locked ? _dim(_K.gold) : _K.gold;
    final leaf =
        locked ? _dim(const Color(0xFFFFD700)) : const Color(0xFFFFD700);
    final sw = locked ? 0.0 : math.sin(fT * 0.7) * 2.0;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(sw * 0.1, -18), width: 6, height: 38),
            const Radius.circular(3)),
        Paint()..color = trunk);
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
          Offset(sw * (i * 0.2), -36 - i * 10 + sw),
          (18 - i * 4).toDouble(),
          Paint()..color = leaf.withOpacity(0.85 - i * 0.15));
    }
    if (!locked) {
      for (int i = 0; i < 6; i++) {
        final a = i * math.pi / 3 + fT * 0.5;
        final r = 20.0 + 4 * math.sin(fT + i * 0.7);
        canvas.drawLine(
            Offset(0, -46 + sw),
            Offset(math.cos(a) * r, -46 + sw + math.sin(a) * r * 0.4),
            Paint()
              ..color = const Color(0xFFFFD700).withOpacity(0.6)
              ..strokeWidth = 1.5
              ..strokeCap = StrokeCap.round);
      }
      canvas.drawCircle(
          Offset(0, -46 + sw),
          26,
          Paint()
            ..color = const Color(0xFFFFD700).withOpacity(0.16)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14));
    }
  }

  // ── MINARET ───────────────────────────────────────────────────────────────
  void _minaret(Canvas canvas, {bool locked = false}) {
    final wall =
        locked ? _dim(const Color(0xFFD8D0C0)) : const Color(0xFFD8D0C0);
    final dome = locked ? _dim(_K.teal) : _K.teal;
    final gold = locked ? _dim(_K.gold) : _K.gold;
    _isoBox(
        canvas,
        0,
        -22,
        14,
        58,
        wall,
        locked ? _dim(const Color(0xFFB0A898)) : const Color(0xFFB0A898),
        locked ? _dim(const Color(0xFFC0B8A8)) : const Color(0xFFC0B8A8));
    canvas.drawArc(
        Rect.fromCenter(center: const Offset(0, -54), width: 20, height: 18),
        math.pi,
        math.pi,
        false,
        Paint()..color = dome);
    final pulse = locked ? 0.7 : 0.6 + 0.4 * math.sin(fT * math.pi * 1.2);
    canvas.drawCircle(
        const Offset(0, -66), 8, Paint()..color = gold.withOpacity(pulse));
    canvas.drawCircle(
        const Offset(3, -66), 6, Paint()..color = const Color(0xFF0A1E0A));
    if (!locked) {
      canvas.drawCircle(
          const Offset(0, -66),
          14 * pulse,
          Paint()
            ..color = _K.gold.withOpacity(0.14 * pulse)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
    }
  }

  // ── PALACE ────────────────────────────────────────────────────────────────
  void _palace(Canvas canvas, {bool locked = false}) {
    final wall =
        locked ? _dim(const Color(0xFFF0E8D0)) : const Color(0xFFF0E8D0);
    final dome = locked ? _dim(_K.teal) : _K.teal;
    final gold = locked ? _dim(_K.gold) : _K.gold;
    final base =
        locked ? _dim(const Color(0xFF3A4A2A)) : const Color(0xFF3A4A2A);
    final fl = locked ? 0.14 : 0.14 + 0.07 * math.sin(fT * 0.8);
    _isoBox(
        canvas,
        0,
        4,
        60,
        10,
        base,
        locked ? _dim(const Color(0xFF2A3A1A)) : const Color(0xFF2A3A1A),
        locked ? _dim(const Color(0xFF2A3A1A)) : const Color(0xFF2A3A1A));
    for (final dx in [-28.0, 28.0]) {
      _isoBox(
          canvas,
          dx,
          -2,
          18,
          22,
          wall,
          locked ? _dim(const Color(0xFFD0C8A8)) : const Color(0xFFD0C8A8),
          locked ? _dim(const Color(0xFFE0D8B8)) : const Color(0xFFE0D8B8));
    }
    _isoBox(
        canvas,
        0,
        -6,
        48,
        32,
        wall,
        locked ? _dim(const Color(0xFFD0C8A8)) : const Color(0xFFD0C8A8),
        locked ? _dim(const Color(0xFFE0D8B8)) : const Color(0xFFE0D8B8));
    canvas.drawArc(
        Rect.fromCenter(center: const Offset(0, -34), width: 34, height: 30),
        math.pi,
        math.pi,
        false,
        Paint()..color = dome);
    canvas.drawArc(
        Rect.fromCenter(center: const Offset(0, -34), width: 34, height: 30),
        math.pi,
        math.pi,
        false,
        Paint()
          ..color = gold
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    for (final dx in [-18.0, 18.0]) {
      _isoBox(
          canvas,
          dx,
          -16,
          8,
          36,
          wall,
          locked ? _dim(const Color(0xFFD0C8A8)) : const Color(0xFFD0C8A8),
          locked ? _dim(const Color(0xFFE0D8B8)) : const Color(0xFFE0D8B8));
      canvas.drawArc(
          Rect.fromCenter(center: Offset(dx, -38), width: 14, height: 12),
          math.pi,
          math.pi,
          false,
          Paint()..color = dome);
      canvas.drawLine(
          Offset(dx, -44),
          Offset(dx, -52),
          Paint()
            ..color = gold
            ..strokeWidth = 2);
      canvas.drawCircle(Offset(dx, -54), 3, Paint()..color = gold);
    }
    for (final dx in [-14.0, 0.0, 14.0]) {
      canvas.drawRRect(
          RRect.fromRectAndCorners(
              Rect.fromCenter(center: Offset(dx, -14), width: 7, height: 10),
              topLeft: const Radius.circular(4),
              topRight: const Radius.circular(4)),
          Paint()..color = const Color(0xFF88CCEE).withOpacity(0.85));
    }
    if (!locked) {
      canvas.drawCircle(
          const Offset(0, -30),
          38,
          Paint()
            ..color = _K.gold.withOpacity(fl)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22));
      for (int i = 0; i < 8; i++) {
        final a = i * math.pi / 4 + fT * 0.4;
        final r = 28.0 + 6 * math.sin(fT + i * 0.7);
        canvas.drawCircle(
            Offset(math.cos(a) * r, -30 + math.sin(a) * r * 0.4),
            2.5,
            Paint()..color = _K.gold.withOpacity(0.5 + 0.4 * math.sin(fT + i)));
      }
    }
  }

  @override
  bool shouldRepaint(_WP o) =>
      o.wT != wT || o.fT != fT || o.pT != pT || o.s.open != s.open;
}

// ══════════════════════════════════════════════════════════════════════════════
// SKY PAINTER
// ══════════════════════════════════════════════════════════════════════════════
class _SkyP extends CustomPainter {
  final double t;
  _SkyP(this.t);
  static final _rng = math.Random(42);
  static final _stars = List.generate(
      75,
      (_) => [
            _rng.nextDouble(),
            _rng.nextDouble() * 0.45,
            _rng.nextDouble() * 1.6 + 0.4,
            _rng.nextDouble() * math.pi * 2
          ]);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..shader = const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF020C06),
                Color(0xFF061A0C),
                Color(0xFF0D2E14),
                Color(0xFF1A5C2A)
              ],
              stops: [
                0,
                0.3,
                0.65,
                1
              ]).createShader(Offset.zero & size));
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.11), 16,
        Paint()..color = const Color(0xFFE8E0C8));
    canvas.drawCircle(Offset(size.width * 0.8 + 5, size.height * 0.11 - 2), 12,
        Paint()..color = const Color(0xFF061A0C));
    for (final s in _stars) {
      final o = 0.2 +
          0.65 * math.sin(s[3] + t * math.pi * 1.2).abs().clamp(0.05, 0.9);
      canvas.drawCircle(Offset(s[0] * size.width, s[1] * size.height), s[2],
          Paint()..color = Colors.white.withOpacity(o));
    }
  }

  @override
  bool shouldRepaint(_SkyP o) => o.t != t;
}

// ══════════════════════════════════════════════════════════════════════════════
// BURST
// ══════════════════════════════════════════════════════════════════════════════
class _BurstP extends CustomPainter {
  final double t;
  _BurstP(this.t);
  static final _rng = math.Random(55);
  static final _pts = List.generate(
      36,
      (_) =>
          [(_rng.nextDouble() - 0.5) * 3.0, (_rng.nextDouble() - 0.5) * 3.0]);
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final e = Curves.easeOut.transform(t);
    final p = Paint();
    for (final pt in _pts) {
      final d = e * 240.0, o = (1 - e).clamp(0.0, 1.0);
      p.color = _K.gold.withOpacity(o * 0.85);
      canvas.drawCircle(c + Offset(pt[0] * d, pt[1] * d), 4 * (1 - e * 0.6), p);
      p.color = Colors.white.withOpacity(o * 0.4);
      canvas.drawCircle(
          c + Offset(pt[0] * d * 0.55, pt[1] * d * 0.55), 2 * (1 - e * 0.6), p);
    }
  }

  @override
  bool shouldRepaint(_BurstP o) => o.t != t;
}

// ══════════════════════════════════════════════════════════════════════════════
// UNLOCK DIALOG
// ══════════════════════════════════════════════════════════════════════════════
class _UnlockDlg extends StatefulWidget {
  final _B b;
  const _UnlockDlg({required this.b});
  @override
  State<_UnlockDlg> createState() => _UDS();
}

class _UDS extends State<_UnlockDlg> with SingleTickerProviderStateMixin {
  late final _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 3))
        ..repeat();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    final tc = _tc(widget.b.tier);
    return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
            decoration: BoxDecoration(
                color: _K.card,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _K.gold.withOpacity(0.5), width: 1.5),
                boxShadow: [
                  BoxShadow(
                      color: _K.gold.withOpacity(0.15),
                      blurRadius: 40,
                      spreadRadius: 4)
                ]),
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              AnimatedBuilder(
                      animation: _c,
                      builder: (_, __) => Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: SweepGradient(
                                  colors: [
                                    _K.gold.withOpacity(0),
                                    _K.gold.withOpacity(0.45),
                                    _K.gold.withOpacity(0)
                                  ],
                                  transform: GradientRotation(
                                      _c.value * math.pi * 2))),
                          child: Center(
                              child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _K.card,
                                      border: Border.all(color: _K.border)),
                                  child: Icon(_ti(widget.b.tier),
                                      color: tc, size: 34)))))
                  .animate()
                  .scale(
                      begin: const Offset(0.2, 0.2),
                      curve: Curves.elasticOut,
                      duration: 900.ms)
                  .fadeIn(duration: 400.ms),
              const SizedBox(height: 12),
              Text(_tl(widget.b.tier).toUpperCase(),
                  style: TextStyle(
                      color: tc,
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(widget.b.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: _K.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800))
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.2),
              const SizedBox(height: 8),
              Text(widget.b.story,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: _K.muted, fontSize: 12, height: 1.6))
                  .animate(delay: 500.ms)
                  .fadeIn(duration: 400.ms),
              const SizedBox(height: 20),
              GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color(0xFF0E3D22),
                                Color(0xFF1A6A35)
                              ]),
                              borderRadius: BorderRadius.circular(14),
                              border:
                                  Border.all(color: _K.gold.withOpacity(0.25))),
                          child: const Center(
                              child: Text('আলহামদুলিল্লাহ',
                                  style: TextStyle(
                                      color: _K.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5)))))
                  .animate(delay: 700.ms)
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.3),
            ])));
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// HELPERS
// ══════════════════════════════════════════════════════════════════════════════
Color _tc(_Tier t) {
  switch (t) {
    case _Tier.seed:
      return const Color(0xFF2ECC6A);
    case _Tier.small:
      return const Color(0xFF38BDF8);
    case _Tier.medium:
      return const Color(0xFFD4A843);
    case _Tier.large:
      return const Color(0xFFFF6B35);
    case _Tier.grand:
      return const Color(0xFFE040FB);
  }
}

IconData _ti(_Tier t) {
  switch (t) {
    case _Tier.seed:
      return Icons.eco_rounded;
    case _Tier.small:
      return Icons.mosque_rounded;
    case _Tier.medium:
      return Icons.water_rounded;
    case _Tier.large:
      return Icons.park_rounded;
    case _Tier.grand:
      return Icons.castle_rounded;
  }
}

String _tl(_Tier t) {
  switch (t) {
    case _Tier.seed:
      return 'প্রথম পদক্ষেপ';
    case _Tier.small:
      return 'নিয়মিত আমল';
    case _Tier.medium:
      return 'গভীর সাধনা';
    case _Tier.large:
      return 'উচ্চ মর্যাদা';
    case _Tier.grand:
      return 'চূড়ান্ত পুরস্কার';
  }
}
