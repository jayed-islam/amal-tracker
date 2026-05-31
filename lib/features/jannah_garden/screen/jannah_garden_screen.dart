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
//   3. Add JannahWorldScreen() as a tab in your shell.
//
// DATA: 100% from your real providers — progressSummaryProvider + categoriesProvider.
//       Month separation intentionally absent — this is a cumulative lifetime journey.
// ═══════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:amal_tracker/features/tracker/models/tracker_model.dart';
import 'package:amal_tracker/features/tracker/providers/tracker_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 1 — WORLD DEFINITION
// ═══════════════════════════════════════════════════════════════════════════

// Every JannahBuilding is drawn by its own Painter method — no assets/emojis.
enum BuildingType {
  sprout, // first life — tiny green mound
  mosque, // fajr — minaret + dome
  quranPavilion, // tilawat — open arch pavilion
  fountain, // dhikr/tasbih — circular basin with water arc
  dateTree, // tilawat milestone — tall palm shape
  bridge, // siyam — arched stone bridge
  lanternPost, // darud — glowing post
  cottage, // streak — walls + roof + chimney
  goldenTree, // 90% completion — radiating tree
  palace, // final — multi-tier with domes
}

enum TileType { grass, grassDark, stonePath, water, waterDeep, sand }

class JannahBuilding {
  final String id;
  final String nameBn;
  final String descBn;
  final String howBn; // how to unlock — shown in sheet
  final BuildingType type;
  final int gridCol, gridRow; // position in 9×9 iso grid
  // unlock conditions (all non-null must be satisfied)
  final int? reqPoints;
  final int? reqStreak;
  final double? reqPct; // 0–100
  final String? reqAmalKey;

  const JannahBuilding({
    required this.id,
    required this.nameBn,
    required this.descBn,
    required this.howBn,
    required this.type,
    required this.gridCol,
    required this.gridRow,
    this.reqPoints,
    this.reqStreak,
    this.reqPct,
    this.reqAmalKey,
  });
}

const kBuildings = <JannahBuilding>[
  JannahBuilding(
    id: 'sprout',
    nameBn: 'প্রথম চারা',
    descBn:
        'আপনার প্রথম আমল রেকর্ড হওয়ার সাথে সাথে এই চারা জন্ম নেয়। প্রতিটি আমল এটিকে বড় করে।',
    howBn: 'যেকোনো ১ টি আমল করুন',
    type: BuildingType.sprout,
    gridCol: 4,
    gridRow: 4,
    reqPoints: 1,
  ),
  JannahBuilding(
    id: 'mosque',
    nameBn: 'ফজরের মসজিদ',
    descBn:
        'ফজরের নামাজের নূর দিয়ে এই মসজিদ আলোকিত। প্রতিদিন ফজর পড়লে মিনারে আলো জ্বলে।',
    howBn: 'ফজর নামাজ আদায় করুন + ১০ pts',
    type: BuildingType.mosque,
    gridCol: 3,
    gridRow: 3,
    reqPoints: 10,
    reqAmalKey: 'fajr',
  ),
  JannahBuilding(
    id: 'pavilion',
    nameBn: 'তিলাওয়াতের চত্বর',
    descBn: 'এখানে বসে কুরআন পড়া হয়। প্রতিটি আয়াতের শব্দ বাতাসে ভাসে।',
    howBn: 'কুরআন তিলাওয়াত করুন + ২০ pts',
    type: BuildingType.quranPavilion,
    gridCol: 6,
    gridRow: 3,
    reqPoints: 20,
    reqAmalKey: 'tilawat',
  ),
  JannahBuilding(
    id: 'fountain',
    nameBn: 'জিকিরের ফোয়ারা',
    descBn:
        'তাসবীহ-জিকিরের শব্দে এই ফোয়ারার পানি নাচে। যত জিকির, তত উঁচুতে ওঠে পানি।',
    howBn: 'তাসবীহ/জিকির করুন + ৩০ pts',
    type: BuildingType.fountain,
    gridCol: 4,
    gridRow: 6,
    reqPoints: 30,
    reqAmalKey: 'tasbih',
  ),
  JannahBuilding(
    id: 'date_tree',
    nameBn: 'কাউসারের খেজুর',
    descBn: 'জান্নাতের বিশেষ খেজুর গাছ। ৭ দিন ধারাবাহিক আমলের পুরস্কার।',
    howBn: '৭ দিনের streak ধরুন',
    type: BuildingType.dateTree,
    gridCol: 2,
    gridRow: 5,
    reqPoints: 35,
    reqStreak: 7,
  ),
  JannahBuilding(
    id: 'lantern',
    nameBn: 'দরুদের আলোকস্তম্ভ',
    descBn: 'নবীজির উপর দরুদ পড়লে এই স্তম্ভ থেকে নূর বের হয়।',
    howBn: 'দরুদ পড়ুন + ৪৫ pts',
    type: BuildingType.lanternPost,
    gridCol: 6,
    gridRow: 6,
    reqPoints: 45,
    reqAmalKey: 'darud',
  ),
  JannahBuilding(
    id: 'bridge',
    nameBn: 'সবরের সেতু',
    descBn: 'রোজার কষ্ট সহ্যের পুরস্কার। এই সেতু দুই তীরকে যুক্ত করে।',
    howBn: 'রোজা রাখুন + ৫৫ pts',
    type: BuildingType.bridge,
    gridCol: 4,
    gridRow: 7,
    reqPoints: 55,
    reqAmalKey: 'siyam',
  ),
  JannahBuilding(
    id: 'cottage',
    nameBn: 'আমলের ঘর',
    descBn: '১০ দিন ধারাবাহিক আমলের পুরস্কার। এখানে বিশ্রাম নেওয়া যায়।',
    howBn: '১০ দিনের streak + ৭০ pts',
    type: BuildingType.cottage,
    gridCol: 2,
    gridRow: 2,
    reqPoints: 70,
    reqStreak: 10,
  ),
  JannahBuilding(
    id: 'golden_tree',
    nameBn: 'তুবা গাছ',
    descBn: 'মাসে ৯০% আমল সম্পন্ন করলে তুবা গাছের শাখা জন্মায়।',
    howBn: 'মাসে ৯০%+ completion + ১২০ pts',
    type: BuildingType.goldenTree,
    gridCol: 7,
    gridRow: 2,
    reqPoints: 120,
    reqPct: 90,
  ),
  JannahBuilding(
    id: 'palace',
    nameBn: 'জান্নাতের মহল',
    descBn:
        'আপনার সমস্ত আমলের চূড়ান্ত পুরস্কার। আল্লাহর রহমতে নির্মিত আপনার চিরস্থায়ী আবাস।',
    howBn: '২০০ pts + ১৫ দিনের streak',
    type: BuildingType.palace,
    gridCol: 4,
    gridRow: 1,
    reqPoints: 200,
    reqStreak: 15,
  ),
];

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 2 — STATE & PROVIDER
// ═══════════════════════════════════════════════════════════════════════════

class JannahWorldState {
  final bool isLoading;
  final int totalPoints;
  final int streakDays;
  final double completionPct;
  final Set<String> completedAmalKeys;
  final Set<String> unlockedIds;
  final String? newlyUnlockedId;
  final JannahBuilding? focusedBuilding;

  const JannahWorldState({
    this.isLoading = true,
    this.totalPoints = 0,
    this.streakDays = 0,
    this.completionPct = 0,
    this.completedAmalKeys = const {},
    this.unlockedIds = const {},
    this.newlyUnlockedId,
    this.focusedBuilding,
  });

  JannahWorldState copyWith({
    bool? isLoading,
    int? totalPoints,
    int? streakDays,
    double? completionPct,
    Set<String>? completedAmalKeys,
    Set<String>? unlockedIds,
    String? newlyUnlockedId,
    JannahBuilding? focusedBuilding,
    bool clearUnlock = false,
    bool clearFocus = false,
  }) =>
      JannahWorldState(
        isLoading: isLoading ?? this.isLoading,
        totalPoints: totalPoints ?? this.totalPoints,
        streakDays: streakDays ?? this.streakDays,
        completionPct: completionPct ?? this.completionPct,
        completedAmalKeys: completedAmalKeys ?? this.completedAmalKeys,
        unlockedIds: unlockedIds ?? this.unlockedIds,
        newlyUnlockedId:
            clearUnlock ? null : (newlyUnlockedId ?? this.newlyUnlockedId),
        focusedBuilding:
            clearFocus ? null : (focusedBuilding ?? this.focusedBuilding),
      );

  bool isUnlocked(String id) => unlockedIds.contains(id);

  JannahBuilding? get nextBuilding {
    final locked = kBuildings.where((b) => !unlockedIds.contains(b.id)).toList()
      ..sort((a, b) => (a.reqPoints ?? 0).compareTo(b.reqPoints ?? 0));
    return locked.isEmpty ? null : locked.first;
  }

  int get pointsToNext {
    final n = nextBuilding;
    return n == null ? 0 : math.max(0, (n.reqPoints ?? 0) - totalPoints);
  }

  double get progressToNext {
    final n = nextBuilding;
    if (n == null) return 1.0;
    final needed = n.reqPoints ?? 1;
    final base = unlockedIds.isEmpty
        ? 0
        : kBuildings
            .where((b) => unlockedIds.contains(b.id))
            .map((b) => b.reqPoints ?? 0)
            .fold<int>(0, math.max);
    final range = needed - base;
    if (range <= 0) return 1.0;
    return ((totalPoints - base) / range).clamp(0.0, 1.0);
  }
}

class JannahWorldNotifier extends StateNotifier<JannahWorldState> {
  JannahWorldNotifier() : super(const JannahWorldState());

  void sync({
    required ProgressSummary summary,
    required List<AmalCategory> categories,
  }) {
    final tracker = summary.currentMonth;
    final pts = tracker?.totalPoints ?? 0;
    final streak = tracker?.streakDays ?? 0;
    final pct = tracker?.completionPercentage ?? 0.0;

    final idToKey = {for (final c in categories) c.id: c.key};
    final doneKeys = <String>{};
    if (summary.todayEntry != null) {
      for (final e in summary.todayEntry!.entries) {
        if (e.completed) {
          final k = idToKey[e.categoryId];
          if (k != null) doneKeys.add(k);
        }
      }
    }

    final prev = state.unlockedIds;
    final now = <String>{};
    for (final b in kBuildings) {
      if ((b.reqPoints == null || pts >= b.reqPoints!) &&
          (b.reqStreak == null || streak >= b.reqStreak!) &&
          (b.reqPct == null || pct >= b.reqPct!) &&
          (b.reqAmalKey == null || doneKeys.contains(b.reqAmalKey))) {
        now.add(b.id);
      }
    }
    final brandNew = now.difference(prev);

    state = state.copyWith(
      isLoading: false,
      totalPoints: pts,
      streakDays: streak,
      completionPct: pct,
      completedAmalKeys: doneKeys,
      unlockedIds: now,
      newlyUnlockedId: brandNew.isNotEmpty ? brandNew.first : null,
    );
  }

  void focus(JannahBuilding b) => state = state.copyWith(focusedBuilding: b);
  void clearFocus() => state = state.copyWith(clearFocus: true);
  void clearUnlock() => state = state.copyWith(clearUnlock: true);
}

final jannahWorldProvider =
    StateNotifierProvider.autoDispose<JannahWorldNotifier, JannahWorldState>(
  (_) => JannahWorldNotifier(),
);

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 3 — MAIN SCREEN
// ═══════════════════════════════════════════════════════════════════════════

class JannahWorldScreen extends ConsumerStatefulWidget {
  const JannahWorldScreen({super.key});

  @override
  ConsumerState<JannahWorldScreen> createState() => _JannahWorldScreenState();
}

class _JannahWorldScreenState extends ConsumerState<JannahWorldScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  late final AnimationController _skyCtrl // stars twinkle
      = AnimationController(vsync: this, duration: const Duration(seconds: 10))
        ..repeat();
  late final AnimationController _waterCtrl // river shimmer
      = AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat();
  late final AnimationController _floatCtrl // building float / tree sway
      = AnimationController(vsync: this, duration: const Duration(seconds: 6))
        ..repeat(reverse: true);
  late final AnimationController _unlockCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1600));
  late final AnimationController _pulseCtrl // locked areas pulse
      = AnimationController(vsync: this, duration: const Duration(seconds: 3))
        ..repeat(reverse: true);

  // Pan/zoom via InteractiveViewer
  final TransformationController _transformCtrl = TransformationController();

  @override
  void dispose() {
    _skyCtrl.dispose();
    _waterCtrl.dispose();
    _floatCtrl.dispose();
    _unlockCtrl.dispose();
    _pulseCtrl.dispose();
    _transformCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(progressSummaryProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final ws = ref.watch(jannahWorldProvider);

    // Sync real data
    if (progressAsync.hasValue && categoriesAsync.hasValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(jannahWorldProvider.notifier).sync(
                summary: progressAsync.value!,
                categories: categoriesAsync.value!,
              );
        }
      });
    }

    // Trigger unlock animation
    if (ws.newlyUnlockedId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _unlockCtrl.forward(from: 0);
        final b = kBuildings.firstWhere(
          (b) => b.id == ws.newlyUnlockedId,
          orElse: () => kBuildings.first,
        );
        ref.read(jannahWorldProvider.notifier).clearUnlock();
        _showUnlockCelebration(b);
      });
    }

    final size = MediaQuery.of(context).size;
    final isLoading = progressAsync.isLoading || categoriesAsync.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF020C06),
      body: Stack(children: [
        // ── Animated sky layer ─────────────────────────────────────────────
        AnimatedBuilder(
          animation: _skyCtrl,
          builder: (_, __) => CustomPaint(
            size: size,
            painter: _SkyPainter(t: _skyCtrl.value),
          ),
        ),

        // ── Pinch/zoom/pan interactive world ──────────────────────────────
        InteractiveViewer(
          transformationController: _transformCtrl,
          minScale: 0.5,
          maxScale: 3.0,
          boundaryMargin: EdgeInsets.all(size.width * 0.5),
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: AnimatedBuilder(
              animation: Listenable.merge([_waterCtrl, _floatCtrl, _pulseCtrl]),
              builder: (_, __) => CustomPaint(
                painter: _JannahWorldPainter(
                  state: ws,
                  size: size,
                  waterT: _waterCtrl.value,
                  floatT: _floatCtrl.value,
                  pulseT: _pulseCtrl.value,
                  onBuildingTap: _onBuildingTap,
                ),
                child: _TapLayer(
                  state: ws,
                  size: size,
                  onTap: _onBuildingTap,
                ),
              ),
            ),
          ),
        ),

        // ── Top HUD ────────────────────────────────────────────────────────
        SafeArea(child: _TopHUD(state: ws, isLoading: isLoading)),

        // ── Bottom bar: next unlock progress ──────────────────────────────
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _BottomProgressBar(state: ws),
        ),

        // ── Unlock burst particles ─────────────────────────────────────────
        AnimatedBuilder(
          animation: _unlockCtrl,
          builder: (_, __) {
            if (_unlockCtrl.value <= 0 || _unlockCtrl.value >= 1) {
              return const SizedBox.shrink();
            }
            return IgnorePointer(
              child: CustomPaint(
                size: size,
                painter: _ParticleBurstPainter(t: _unlockCtrl.value),
              ),
            );
          },
        ),

        // ── Loading overlay ────────────────────────────────────────────────
        if (isLoading)
          Container(
            color: const Color(0x88020C06),
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFFD4A843)),
            ),
          ),
      ]),
    );
  }

  void _onBuildingTap(JannahBuilding b) {
    HapticFeedback.mediumImpact();
    final unlocked = ref.read(jannahWorldProvider).isUnlocked(b.id);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => unlocked
          ? _UnlockedBuildingSheet(building: b)
          : _LockedBuildingSheet(
              building: b,
              state: ref.read(jannahWorldProvider),
            ),
    );
  }

  void _showUnlockCelebration(JannahBuilding b) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => _UnlockCelebrationDialog(building: b),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 4 — WORLD PAINTER (the heart of the feature)
// ═══════════════════════════════════════════════════════════════════════════

class _JannahWorldPainter extends CustomPainter {
  final JannahWorldState state;
  final Size size;
  final double waterT, floatT, pulseT;
  final void Function(JannahBuilding) onBuildingTap;

  _JannahWorldPainter({
    required this.state,
    required this.size,
    required this.waterT,
    required this.floatT,
    required this.pulseT,
    required this.onBuildingTap,
  });

  static const int kCols = 9;
  static const int kRows = 9;
  static const double kTW = 72.0; // tile width
  static const double kTH = 36.0; // tile height (half of width for iso)

  // ── Isometric projection ────────────────────────────────────────────────
  Offset _isoToScreen(double col, double row, Size s) {
    final ox = s.width / 2;
    final oy = s.height * 0.38;
    return Offset(
      ox + (col - row) * (kTW / 2),
      oy + (col + row) * (kTH / 2),
    );
  }

  // ── Tile type for grid position ──────────────────────────────────────────
  TileType _tileAt(int c, int r) {
    // River flows diagonally
    if ((c == 4 && r >= 5) || (c == 5 && r == 6) || (c == 6 && r == 7)) {
      return TileType.waterDeep;
    }
    if ((c == 3 && r >= 5) || (c == 4 && r == 4 && r >= 4)) {
      // path tiles
    }
    // Stone path between buildings
    final pathTiles = {
      const (4, 3),
      const (4, 4),
      const (4, 5),
      const (3, 4),
      const (5, 4),
      const (3, 3),
      const (5, 3),
      const (2, 3),
      const (6, 3),
      const (4, 6),
      const (4, 7),
      const (3, 6),
      const (5, 6),
    };
    if (pathTiles.contains((c, r))) return TileType.stonePath;
    // Alternating grass
    return (c + r) % 2 == 0 ? TileType.grass : TileType.grassDark;
  }

  // ── Draw an iso tile ─────────────────────────────────────────────────────
  void _drawTile(Canvas canvas, int c, int r, TileType type) {
    final p = _isoToScreen(c.toDouble(), r.toDouble(), size);
    final hw = kTW / 2;
    final hh = kTH / 2;

    final path = Path()
      ..moveTo(p.dx, p.dy - hh)
      ..lineTo(p.dx + hw, p.dy)
      ..lineTo(p.dx, p.dy + hh)
      ..lineTo(p.dx - hw, p.dy)
      ..close();

    Color top, shadow, border;
    switch (type) {
      case TileType.grass:
        top = const Color(0xFF1E7A35);
        shadow = const Color(0xFF185C28);
        border = const Color(0xFF16522A);
        break;
      case TileType.grassDark:
        top = const Color(0xFF1A6A2E);
        shadow = const Color(0xFF144E22);
        border = const Color(0xFF124420);
        break;
      case TileType.stonePath:
        top = const Color(0xFF4A5E4A);
        shadow = const Color(0xFF3A4E3A);
        border = const Color(0xFF2E3E2E);
        break;
      case TileType.water:
        final wv = 0.5 + 0.5 * math.sin(waterT * math.pi * 2 + c * 0.8);
        top = Color.lerp(const Color(0xFF1E6A8A), const Color(0xFF2A88AA), wv)!;
        shadow = const Color(0xFF154E6A);
        border = const Color(0xFF0E3A50);
        break;
      case TileType.waterDeep:
        final wv = 0.5 + 0.5 * math.sin(waterT * math.pi * 2 + r * 0.6);
        top = Color.lerp(const Color(0xFF1A5A7A), const Color(0xFF2A7A9A), wv)!;
        shadow = const Color(0xFF104055);
        border = const Color(0xFF0A2A3A);
        break;
      case TileType.sand:
        top = const Color(0xFF8A7A4A);
        shadow = const Color(0xFF6A5A3A);
        border = const Color(0xFF5A4A2A);
        break;
    }

    // Top face
    canvas.drawPath(
        path,
        Paint()
          ..color = top
          ..style = PaintingStyle.fill);
    // Left face (depth illusion)
    final leftFace = Path()
      ..moveTo(p.dx - hw, p.dy)
      ..lineTo(p.dx, p.dy + hh)
      ..lineTo(p.dx, p.dy + hh + 6)
      ..lineTo(p.dx - hw, p.dy + 6)
      ..close();
    canvas.drawPath(leftFace, Paint()..color = shadow);
    // Right face
    final rightFace = Path()
      ..moveTo(p.dx + hw, p.dy)
      ..lineTo(p.dx, p.dy + hh)
      ..lineTo(p.dx, p.dy + hh + 6)
      ..lineTo(p.dx + hw, p.dy + 6)
      ..close();
    canvas.drawPath(rightFace,
        Paint()..color = shadow.withGreen((shadow.green * 0.9).toInt()));
    // Border
    canvas.drawPath(
        path,
        Paint()
          ..color = border
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5);

    // Water shimmer line
    if (type == TileType.waterDeep || type == TileType.water) {
      final shimmerY = p.dy - hh * 0.3 + math.sin(waterT * math.pi * 2 + c) * 2;
      canvas.drawLine(
        Offset(p.dx - hw * 0.5, shimmerY),
        Offset(p.dx + hw * 0.5, shimmerY),
        Paint()
          ..color = Colors.white.withOpacity(0.15)
          ..strokeWidth = 1.2
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  // ── Draw all buildings ────────────────────────────────────────────────────
  void _drawBuilding(Canvas canvas, JannahBuilding b) {
    final p = _isoToScreen(b.gridCol.toDouble(), b.gridRow.toDouble(), size);
    final unlocked = state.isUnlocked(b.id);
    final float = math.sin(floatT * math.pi) * 2.0;

    final center = p.translate(0, -float);
    canvas.save();

    if (!unlocked) {
      // Dim locked buildings
      canvas.saveLayer(null, Paint()..color = Colors.black.withOpacity(0.0));
    }

    switch (b.type) {
      case BuildingType.sprout:
        _drawSprout(canvas, center, unlocked);
        break;
      case BuildingType.mosque:
        _drawMosque(canvas, center, unlocked);
        break;
      case BuildingType.quranPavilion:
        _drawPavilion(canvas, center, unlocked);
        break;
      case BuildingType.fountain:
        _drawFountain(canvas, center, unlocked, waterT);
        break;
      case BuildingType.dateTree:
        _drawDateTree(canvas, center, unlocked, floatT);
        break;
      case BuildingType.lanternPost:
        _drawLantern(canvas, center, unlocked, floatT);
        break;
      case BuildingType.bridge:
        _drawBridge(canvas, center, unlocked);
        break;
      case BuildingType.cottage:
        _drawCottage(canvas, center, unlocked);
        break;
      case BuildingType.goldenTree:
        _drawGoldenTree(canvas, center, unlocked, floatT);
        break;
      case BuildingType.palace:
        _drawPalace(canvas, center, unlocked, floatT);
        break;
    }

    if (!unlocked) {
      // Locked fog overlay
      final fogOpacity = 0.55 + 0.2 * math.sin(pulseT * math.pi);
      canvas.restore();
      _drawLockedFog(canvas, center, fogOpacity);
    }

    canvas.restore();
  }

  // ─── Individual building drawers ──────────────────────────────────────────

  void _drawSprout(Canvas canvas, Offset c, bool unlocked) {
    final color = unlocked ? const Color(0xFF2ECC5A) : const Color(0xFF1A4A1A);
    // Mound
    canvas.drawOval(
      Rect.fromCenter(center: c.translate(0, 4), width: 28, height: 12),
      Paint()..color = const Color(0xFF1A5C2A),
    );
    if (!unlocked) return;
    // Stem
    canvas.drawLine(
      c.translate(0, 4),
      c.translate(0, -8),
      Paint()
        ..color = color
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
    // Left leaf
    final leafPath = Path()
      ..moveTo(c.dx, c.dy - 4)
      ..quadraticBezierTo(c.dx - 12, c.dy - 14, c.dx - 6, c.dy - 18)
      ..quadraticBezierTo(c.dx - 2, c.dy - 10, c.dx, c.dy - 4);
    canvas.drawPath(leafPath, Paint()..color = color);
    // Right leaf
    final leafPath2 = Path()
      ..moveTo(c.dx, c.dy - 6)
      ..quadraticBezierTo(c.dx + 10, c.dy - 14, c.dx + 5, c.dy - 20)
      ..quadraticBezierTo(c.dx + 1, c.dy - 10, c.dx, c.dy - 6);
    canvas.drawPath(leafPath2, Paint()..color = color.withGreen(180));
  }

  void _drawMosque(Canvas canvas, Offset c, bool unlocked) {
    final wallC = unlocked ? const Color(0xFFE8D5B0) : const Color(0xFF2A2A1A);
    final domeC = unlocked ? const Color(0xFF2EA868) : const Color(0xFF1A3A1A);
    final accentC =
        unlocked ? const Color(0xFFD4A843) : const Color(0xFF2A2A1A);

    // Base platform
    final platform = Path()
      ..moveTo(c.dx, c.dy - 6)
      ..lineTo(c.dx + 22, c.dy + 5)
      ..lineTo(c.dx + 22, c.dy + 10)
      ..lineTo(c.dx, c.dy + 4)
      ..lineTo(c.dx - 22, c.dy + 10)
      ..lineTo(c.dx - 22, c.dy + 5)
      ..close();
    canvas.drawPath(platform, Paint()..color = const Color(0xFF3A4A3A));

    // Main building body (iso box)
    _drawIsoBox(canvas, c.translate(0, -4), 38, 28, wallC,
        const Color(0xFFB8A880), const Color(0xFFD0BC90));

    // Central dome
    final domeRect =
        Rect.fromCenter(center: c.translate(0, -28), width: 24, height: 22);
    canvas.drawArc(
        domeRect,
        math.pi,
        math.pi,
        false,
        Paint()
          ..color = domeC
          ..style = PaintingStyle.fill);
    canvas.drawArc(
        domeRect,
        math.pi,
        math.pi,
        false,
        Paint()
          ..color = accentC
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);

    // Minaret left
    _drawIsoBox(canvas, c.translate(-16, -8), 8, 40, wallC,
        const Color(0xFFB8A880), const Color(0xFFD0BC90));
    // Minaret tip
    canvas.drawCircle(c.translate(-16, -30), 3, Paint()..color = accentC);

    // Minaret right
    _drawIsoBox(canvas, c.translate(16, -8), 8, 40, wallC,
        const Color(0xFFB8A880), const Color(0xFFD0BC90));
    canvas.drawCircle(c.translate(16, -30), 3, Paint()..color = accentC);

    // Glow if unlocked
    if (unlocked) {
      canvas.drawCircle(
        c.translate(0, -25),
        18,
        Paint()
          ..color = accentC.withOpacity(0.12)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      );
    }
  }

  void _drawPavilion(Canvas canvas, Offset c, bool unlocked) {
    final postC = unlocked ? const Color(0xFFD4B870) : const Color(0xFF2A2A1A);
    final roofC = unlocked ? const Color(0xFF4A9A6A) : const Color(0xFF1A2A1A);
    final roofC2 = unlocked ? const Color(0xFF2A7A4A) : const Color(0xFF141E14);

    // 4 columns
    for (final dx in [-12.0, -4.0, 4.0, 12.0]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: c.translate(dx, -14), width: 4, height: 28),
          const Radius.circular(2),
        ),
        Paint()..color = postC,
      );
    }
    // Roof — pagoda style
    final roof1 = Path()
      ..moveTo(c.dx, c.dy - 40)
      ..lineTo(c.dx + 22, c.dy - 26)
      ..lineTo(c.dx - 22, c.dy - 26)
      ..close();
    canvas.drawPath(roof1, Paint()..color = roofC);
    final roof2 = Path()
      ..moveTo(c.dx, c.dy - 32)
      ..lineTo(c.dx + 28, c.dy - 20)
      ..lineTo(c.dx - 28, c.dy - 20)
      ..close();
    canvas.drawPath(roof2, Paint()..color = roofC2);
    // Floor
    canvas.drawOval(
      Rect.fromCenter(center: c.translate(0, 2), width: 36, height: 14),
      Paint()..color = const Color(0xFF3A4A3A),
    );
    // Open book shape on floor
    if (unlocked) {
      final bookPath = Path()
        ..moveTo(c.dx, c.dy)
        ..lineTo(c.dx - 8, c.dy - 4)
        ..lineTo(c.dx - 8, c.dy + 4)
        ..lineTo(c.dx, c.dy + 2)
        ..lineTo(c.dx + 8, c.dy - 4)
        ..lineTo(c.dx + 8, c.dy + 4)
        ..close();
      canvas.drawPath(bookPath, Paint()..color = const Color(0xFFE8D0A0));
      canvas.drawLine(
          c.translate(0, -4),
          c.translate(0, 4),
          Paint()
            ..color = const Color(0xFFB8A070)
            ..strokeWidth = 1);
    }
  }

  void _drawFountain(Canvas canvas, Offset c, bool unlocked, double wT) {
    final basinC = unlocked ? const Color(0xFF5A7A8A) : const Color(0xFF2A3A3A);
    final waterC = unlocked ? const Color(0xFF38BDF8) : const Color(0xFF1A3A4A);

    // Basin outer
    canvas.drawOval(
      Rect.fromCenter(center: c.translate(0, 4), width: 36, height: 16),
      Paint()..color = basinC,
    );
    // Basin inner water
    canvas.drawOval(
      Rect.fromCenter(center: c.translate(0, 3), width: 26, height: 11),
      Paint()..color = waterC.withOpacity(0.8),
    );
    // Center pillar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(center: c.translate(0, -6), width: 6, height: 18),
          const Radius.circular(3)),
      Paint()..color = const Color(0xFF6A8A9A),
    );
    if (!unlocked) return;
    // Animated water arc
    final arcH = 12.0 + 4 * math.sin(wT * math.pi * 2);
    final waterArc = Path()
      ..moveTo(c.dx, c.dy - 14)
      ..quadraticBezierTo(c.dx + 8, c.dy - 14 - arcH, c.dx + 10, c.dy);
    canvas.drawPath(
      waterArc,
      Paint()
        ..color = waterC.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
    final waterArc2 = Path()
      ..moveTo(c.dx, c.dy - 14)
      ..quadraticBezierTo(c.dx - 8, c.dy - 14 - arcH, c.dx - 10, c.dy);
    canvas.drawPath(
      waterArc2,
      Paint()
        ..color = waterC.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
    // Water glow
    canvas.drawCircle(
      c.translate(0, -5),
      10,
      Paint()
        ..color = waterC.withOpacity(0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
  }

  void _drawDateTree(Canvas canvas, Offset c, bool unlocked, double fT) {
    final trunkC = unlocked ? const Color(0xFF8B5E3C) : const Color(0xFF2A1A0A);
    final leafC = unlocked ? const Color(0xFF2ECC6A) : const Color(0xFF1A2A1A);
    final sway = math.sin(fT * math.pi) * 3;

    // Trunk (slightly curved)
    final trunk = Path()
      ..moveTo(c.dx - 3, c.dy + 6)
      ..quadraticBezierTo(
          c.dx - 1 + sway * 0.2, c.dy - 20, c.dx + sway, c.dy - 44)
      ..lineTo(c.dx + 4 + sway, c.dy - 44)
      ..quadraticBezierTo(c.dx + 3 + sway * 0.2, c.dy - 20, c.dx + 4, c.dy + 6)
      ..close();
    canvas.drawPath(trunk, Paint()..color = trunkC);

    if (!unlocked) return;

    // Palm fronds (swaying)
    final frondAngles = [-0.8, -0.3, 0.1, 0.5, 0.9, 1.3];
    for (final angle in frondAngles) {
      final swayAngle = angle + sway * 0.05;
      final ex = c.dx + sway + math.cos(swayAngle) * 24;
      final ey = c.dy - 44 + math.sin(swayAngle) * 12;
      final frond = Path()
        ..moveTo(c.dx + sway, c.dy - 44)
        ..quadraticBezierTo(
          c.dx + sway + math.cos(swayAngle) * 12,
          c.dy - 44 + math.sin(swayAngle) * 6 - 4,
          ex,
          ey,
        );
      canvas.drawPath(
        frond,
        Paint()
          ..color = leafC
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5
          ..strokeCap = StrokeCap.round,
      );
    }
    // Dates (small circles)
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(c.dx + sway + (i - 2) * 3, c.dy - 40),
        2.5,
        Paint()..color = const Color(0xFFD4A843),
      );
    }
  }

  void _drawLantern(Canvas canvas, Offset c, bool unlocked, double fT) {
    final postC = unlocked ? const Color(0xFF7A6A4A) : const Color(0xFF2A2A1A);
    final glowC = unlocked ? const Color(0xFFFFD070) : const Color(0xFF2A2A1A);
    final pulse = 0.7 + 0.3 * math.sin(fT * math.pi * 2);

    // Post
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(center: c.translate(0, -8), width: 5, height: 28),
          const Radius.circular(2)),
      Paint()..color = postC,
    );
    // Base
    canvas.drawOval(
        Rect.fromCenter(center: c.translate(0, 4), width: 18, height: 8),
        Paint()..color = const Color(0xFF3A3A2A));

    if (!unlocked) return;

    // Lantern head
    final lanternRect =
        Rect.fromCenter(center: c.translate(0, -28), width: 14, height: 16);
    canvas.drawRRect(
      RRect.fromRectAndRadius(lanternRect, const Radius.circular(3)),
      Paint()..color = glowC.withOpacity(0.9 * pulse),
    );
    // Glow
    canvas.drawCircle(
      c.translate(0, -28),
      16 * pulse,
      Paint()
        ..color = glowC.withOpacity(0.25 * pulse)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    // Top hook
    canvas.drawLine(
      c.translate(0, -36),
      c.translate(0, -42),
      Paint()
        ..color = postC
        ..strokeWidth = 2,
    );
  }

  void _drawBridge(Canvas canvas, Offset c, bool unlocked) {
    final stoneC = unlocked ? const Color(0xFF7A7A6A) : const Color(0xFF2A2A2A);
    final archC = unlocked ? const Color(0xFF6A6A5A) : const Color(0xFF1A1A1A);

    // Bridge deck
    final deck = Path()
      ..moveTo(c.dx - 26, c.dy - 2)
      ..lineTo(c.dx + 26, c.dy - 2)
      ..lineTo(c.dx + 22, c.dy + 8)
      ..lineTo(c.dx - 22, c.dy + 8)
      ..close();
    canvas.drawPath(deck, Paint()..color = stoneC);

    // Arch below deck
    final archRect =
        Rect.fromCenter(center: c.translate(0, 6), width: 28, height: 18);
    canvas.drawArc(
        archRect,
        0,
        math.pi,
        false,
        Paint()
          ..color = archC
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5);

    // Railings
    for (final dx in [-18.0, -10.0, -2.0, 6.0, 14.0, 22.0]) {
      canvas.drawLine(
        Offset(c.dx + dx, c.dy - 2),
        Offset(c.dx + dx, c.dy - 12),
        Paint()
          ..color = stoneC.withGreen((stoneC.green * 0.85).toInt())
          ..strokeWidth = 2.5,
      );
    }
    // Top rail
    canvas.drawLine(
      Offset(c.dx - 22, c.dy - 12),
      Offset(c.dx + 26, c.dy - 12),
      Paint()
        ..color = stoneC
        ..strokeWidth = 3,
    );
  }

  void _drawCottage(Canvas canvas, Offset c, bool unlocked) {
    final wallC = unlocked ? const Color(0xFFD4C090) : const Color(0xFF2A2A1A);
    final roofC = unlocked ? const Color(0xFFA84848) : const Color(0xFF2A1A1A);
    final windowC =
        unlocked ? const Color(0xFF88CCF0) : const Color(0xFF1A1A2A);

    // Wall box
    _drawIsoBox(canvas, c.translate(0, -2), 44, 26, wallC,
        const Color(0xFFB8A878), const Color(0xFFC8B888));

    // Triangular roof
    final roof = Path()
      ..moveTo(c.dx, c.dy - 32)
      ..lineTo(c.dx + 26, c.dy - 18)
      ..lineTo(c.dx - 26, c.dy - 18)
      ..close();
    canvas.drawPath(roof, Paint()..color = roofC);
    canvas.drawPath(
      roof,
      Paint()
        ..color = const Color(0xFF882828)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Windows
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(center: c.translate(-10, -8), width: 9, height: 9),
          const Radius.circular(1)),
      Paint()..color = windowC,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(center: c.translate(10, -8), width: 9, height: 9),
          const Radius.circular(1)),
      Paint()..color = windowC,
    );
    // Window cross
    canvas.drawLine(
        Offset(c.dx - 10, c.dy - 12),
        Offset(c.dx - 10, c.dy - 4),
        Paint()
          ..color = wallC
          ..strokeWidth = 1);
    canvas.drawLine(
        Offset(c.dx - 14, c.dy - 8),
        Offset(c.dx - 6, c.dy - 8),
        Paint()
          ..color = wallC
          ..strokeWidth = 1);

    // Door
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(center: c.translate(0, -2), width: 8, height: 12),
          const Radius.circular(4)),
      Paint()..color = const Color(0xFF8B5E3C),
    );

    // Chimney
    _drawIsoBox(canvas, c.translate(14, -30), 8, 14, wallC,
        const Color(0xFFB8A878), const Color(0xFFC8B888));

    if (unlocked) {
      // Smoke particles
      for (int i = 0; i < 3; i++) {
        canvas.drawCircle(
          c.translate(14 + math.sin(i * 1.2) * 4, -42 - i * 5),
          3.0 - i * 0.5,
          Paint()..color = Colors.white.withOpacity(0.12 - i * 0.03),
        );
      }
    }
  }

  void _drawGoldenTree(Canvas canvas, Offset c, bool unlocked, double fT) {
    final trunkC = unlocked ? const Color(0xFFD4A843) : const Color(0xFF2A2A0A);
    final leafC = unlocked ? const Color(0xFFFFD700) : const Color(0xFF2A2A1A);
    final sway = math.sin(fT * math.pi) * 2;

    // Trunk
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: c.translate(sway * 0.1, -18), width: 6, height: 38),
          const Radius.circular(3)),
      Paint()..color = trunkC,
    );

    if (!unlocked) return;

    // Golden foliage layers
    for (int layer = 0; layer < 3; layer++) {
      final r = 18.0 - layer * 4;
      final y = -36.0 - layer * 10 + sway;
      canvas.drawCircle(
        c.translate(sway * (layer * 0.2), y),
        r,
        Paint()
          ..color = leafC.withOpacity(0.85 - layer * 0.15)
          ..maskFilter =
              layer == 0 ? const MaskFilter.blur(BlurStyle.normal, 3) : null,
      );
    }

    // Radiating glow
    canvas.drawCircle(
      c.translate(0, -46),
      24,
      Paint()
        ..color = leafC.withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );

    // Star points
    for (int i = 0; i < 6; i++) {
      final angle = i * math.pi / 3 + fT * 0.5;
      final r2 = 20.0 + 4 * math.sin(fT * math.pi + i);
      canvas.drawLine(
        c.translate(0, -46 + sway),
        c.translate(
            math.cos(angle) * r2, -46 + sway + math.sin(angle) * r2 * 0.5),
        Paint()
          ..color = leafC.withOpacity(0.6)
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  void _drawPalace(Canvas canvas, Offset c, bool unlocked, double fT) {
    final wallC = unlocked ? const Color(0xFFF0E8D0) : const Color(0xFF2A2A1A);
    final domeC = unlocked ? const Color(0xFF2ECC88) : const Color(0xFF1A2A1A);
    final goldC = unlocked ? const Color(0xFFD4A843) : const Color(0xFF2A2A1A);
    final glow = 0.15 + 0.08 * math.sin(fT * math.pi);

    // Base platform (wide)
    _drawIsoBox(canvas, c.translate(0, 4), 60, 10, const Color(0xFF4A5A3A),
        const Color(0xFF3A4A2A), const Color(0xFF3A4A2A));

    // Main body
    _drawIsoBox(canvas, c.translate(0, -6), 48, 32, wallC,
        const Color(0xFFD0C8A8), const Color(0xFFE0D8B8));

    // Side wings
    _drawIsoBox(canvas, c.translate(-28, -2), 18, 22, wallC,
        const Color(0xFFD0C8A8), const Color(0xFFE0D8B8));
    _drawIsoBox(canvas, c.translate(28, -2), 18, 22, wallC,
        const Color(0xFFD0C8A8), const Color(0xFFE0D8B8));

    // Central large dome
    final mainDomeRect =
        Rect.fromCenter(center: c.translate(0, -34), width: 34, height: 30);
    canvas.drawArc(
        mainDomeRect, math.pi, math.pi, false, Paint()..color = domeC);
    canvas.drawArc(
        mainDomeRect,
        math.pi,
        math.pi,
        false,
        Paint()
          ..color = goldC
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);

    // Side minarets + domes
    for (final dx in [-18.0, 18.0]) {
      _drawIsoBox(canvas, c.translate(dx, -16), 8, 36, wallC,
          const Color(0xFFD0C8A8), const Color(0xFFE0D8B8));
      final sdRect =
          Rect.fromCenter(center: c.translate(dx, -38), width: 14, height: 12);
      canvas.drawArc(sdRect, math.pi, math.pi, false, Paint()..color = domeC);
      // Finial
      canvas.drawLine(
        c.translate(dx, -44),
        c.translate(dx, -50),
        Paint()
          ..color = goldC
          ..strokeWidth = 2,
      );
      canvas.drawCircle(c.translate(dx, -52), 3, Paint()..color = goldC);
    }

    // Windows — arched
    for (final dx in [-14.0, 0.0, 14.0]) {
      final wRect =
          Rect.fromCenter(center: c.translate(dx, -14), width: 7, height: 10);
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromCenter(center: c.translate(dx, -14), width: 7, height: 10),
          topLeft: const Radius.circular(4),
          topRight: const Radius.circular(4),
        ),
        Paint()..color = const Color(0xFF88CCEE),
      );
    }

    if (!unlocked) return;

    // Palace glow halo
    canvas.drawCircle(
      c.translate(0, -30),
      36,
      Paint()
        ..color = goldC.withOpacity(glow)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );

    // Floating gold particles
    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4 + fT * math.pi * 0.5;
      final r = 28.0 + 6 * math.sin(fT * math.pi + i * 0.7);
      canvas.drawCircle(
        c.translate(math.cos(angle) * r, -30 + math.sin(angle) * r * 0.4),
        2.5,
        Paint()
          ..color = goldC.withOpacity(0.5 + 0.4 * math.sin(fT * math.pi + i)),
      );
    }
  }

  // ── Iso box helper (3 faces) ──────────────────────────────────────────────
  void _drawIsoBox(Canvas canvas, Offset c, double w, double h, Color top,
      Color left, Color right) {
    final hw = w / 2;
    // Top face (flat, slightly angled for iso feel)
    canvas.drawRect(
      Rect.fromCenter(center: c.translate(0, -h / 2), width: w, height: 8),
      Paint()..color = top,
    );
    // Front face
    canvas.drawRect(
      Rect.fromCenter(center: c, width: w, height: h),
      Paint()..color = left,
    );
    // Right shading
    canvas.drawRect(
      Rect.fromLTWH(c.dx + hw - 4, c.dy - h / 2, 4, h),
      Paint()..color = right,
    );
  }

  void _drawLockedFog(Canvas canvas, Offset c, double opacity) {
    // Dark pulsing fog around locked buildings
    canvas.drawCircle(
      c.translate(0, -10),
      34,
      Paint()
        ..color = Colors.black.withOpacity(opacity * 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
    );
    // Lock icon (simple drawn)
    final lockBody =
        Rect.fromCenter(center: c.translate(0, -8), width: 14, height: 12);
    canvas.drawRRect(
      RRect.fromRectAndRadius(lockBody, const Radius.circular(2)),
      Paint()..color = Colors.white.withOpacity(opacity * 0.3),
    );
    canvas.drawArc(
      Rect.fromCenter(center: c.translate(0, -16), width: 10, height: 10),
      math.pi,
      math.pi,
      false,
      Paint()
        ..color = Colors.white.withOpacity(opacity * 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw tiles bottom-first for correct iso layering
    for (int r = 0; r < kRows; r++) {
      for (int c2 = 0; c2 < kCols; c2++) {
        _drawTile(canvas, c2, r, _tileAt(c2, r));
      }
    }

    // Draw buildings sorted by depth (higher row = drawn later = in front)
    final sorted = List<JannahBuilding>.from(kBuildings)
      ..sort(
          (a, b) => (a.gridCol + a.gridRow).compareTo(b.gridCol + b.gridRow));
    for (final b in sorted) {
      _drawBuilding(canvas, b);
    }
  }

  @override
  bool shouldRepaint(_JannahWorldPainter old) =>
      old.waterT != waterT ||
      old.floatT != floatT ||
      old.pulseT != pulseT ||
      old.state.unlockedIds != state.unlockedIds;
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 5 — TAP LAYER (transparent hit areas over each building)
// ═══════════════════════════════════════════════════════════════════════════

class _TapLayer extends StatelessWidget {
  final JannahWorldState state;
  final Size size;
  final void Function(JannahBuilding) onTap;

  const _TapLayer(
      {required this.state, required this.size, required this.onTap});

  Offset _isoToScreen(double col, double row) {
    const kTW = 72.0;
    const kTH = 36.0;
    final ox = size.width / 2;
    final oy = size.height * 0.38;
    return Offset(ox + (col - row) * (kTW / 2), oy + (col + row) * (kTH / 2));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: kBuildings.map((b) {
        final p = _isoToScreen(b.gridCol.toDouble(), b.gridRow.toDouble());
        return Positioned(
          left: p.dx - 30,
          top: p.dy - 55,
          width: 60,
          height: 70,
          child: GestureDetector(
            onTap: () => onTap(b),
            child: Container(color: Colors.transparent),
          ),
        );
      }).toList(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 6 — SKY PAINTER
// ═══════════════════════════════════════════════════════════════════════════

class _SkyPainter extends CustomPainter {
  final double t;
  _SkyPainter({required this.t});

  static final _rng = math.Random(42);
  static final _stars = List.generate(
      80,
      (_) => [
            _rng.nextDouble(),
            _rng.nextDouble() * 0.45,
            _rng.nextDouble() * 1.8 + 0.3,
            _rng.nextDouble() * math.pi * 2,
          ]);

  @override
  void paint(Canvas canvas, Size size) {
    // Sky gradient
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
          stops: [0, 0.3, 0.65, 1],
        ).createShader(Offset.zero & size),
    );

    // Moon
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.12),
      18,
      Paint()..color = const Color(0xFFE8E0C8),
    );
    canvas.drawCircle(
      Offset(size.width * 0.78 + 6, size.height * 0.12 - 2),
      14,
      Paint()..color = const Color(0xFF061A0C),
    );

    // Stars
    final p = Paint();
    for (final s in _stars) {
      final o = 0.2 + 0.65 * math.sin(s[3] + t * math.pi * 2).abs();
      p.color = Colors.white.withOpacity(o.clamp(0.05, 0.9));
      canvas.drawCircle(Offset(s[0] * size.width, s[1] * size.height), s[2], p);
    }
  }

  @override
  bool shouldRepaint(_SkyPainter old) => old.t != t;
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 7 — UI OVERLAYS
// ═══════════════════════════════════════════════════════════════════════════

// ── Top HUD ──────────────────────────────────────────────────────────────────

class _TopHUD extends StatelessWidget {
  final JannahWorldState state;
  final bool isLoading;
  const _TopHUD({required this.state, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: Row(children: [
        // Title block
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('আমার জান্নাত',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                  )),
              Text(
                isLoading
                    ? 'লোড হচ্ছে...'
                    : '${state.unlockedIds.length} / ${kBuildings.length} স্থাপনা উন্মুক্ত',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 11,
                  shadows: const [Shadow(color: Colors.black54, blurRadius: 6)],
                ),
              ),
            ],
          ),
        ),
        _HUDChip(
          label: '${state.streakDays} দিন',
          icon: Icons.local_fire_department_rounded,
          color: const Color(0xFFFF6B35),
        ),
        const SizedBox(width: 7),
        _HUDChip(
          label: '${state.totalPoints} pts',
          icon: Icons.stars_rounded,
          color: const Color(0xFFD4A843),
        ),
        const SizedBox(width: 7),
        _HUDChip(
          label: '${state.completionPct.toInt()}%',
          icon: Icons.pie_chart_rounded,
          color: const Color(0xFF2ECC88),
        ),
      ]),
    );
  }
}

class _HUDChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _HUDChip(
      {required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4), width: 0.5),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                color: color, fontSize: 10.5, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

// ── Bottom bar ────────────────────────────────────────────────────────────────

class _BottomProgressBar extends StatelessWidget {
  final JannahWorldState state;
  const _BottomProgressBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final next = state.nextBuilding;
    final pad = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, pad + 14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.08), width: 0.5)),
      ),
      child: next == null
          ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.celebration_rounded,
                  color: Color(0xFFD4A843), size: 16),
              SizedBox(width: 8),
              Text('মাশাআল্লাহ! জান্নাত পরিপূর্ণ হয়েছে 🌟',
                  style: TextStyle(
                      color: Color(0xFFD4A843),
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ])
          : Column(mainAxisSize: MainAxisSize.min, children: [
              Row(children: [
                Expanded(
                  child: Text(
                    'পরবর্তী: ${next.nameBn}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  state.pointsToNext > 0
                      ? 'আরও ${state.pointsToNext} pts'
                      : 'অন্য শর্ত বাকি',
                  style: const TextStyle(
                      color: Color(0xFFD4A843),
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ]),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: state.progressToNext,
                  minHeight: 6,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFFD4A843)),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                next.howBn,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.45), fontSize: 10),
              ),
            ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 8 — BUILDING DETAIL SHEETS
// ═══════════════════════════════════════════════════════════════════════════

class _UnlockedBuildingSheet extends StatelessWidget {
  final JannahBuilding building;
  const _UnlockedBuildingSheet({required this.building});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1E0E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF163320), width: 0.5),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Handle
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF163320),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // Building mini-canvas preview
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: const RadialGradient(
                  colors: [Color(0xFF0D3A1A), Color(0xFF061209)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: CustomPaint(
                  size: const Size(200, 100),
                  painter: _BuildingPreviewPainter(type: building.type),
                ),
              ),
            ),
            const SizedBox(height: 14),

            Text(building.nameBn,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(building.descBn,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.55), fontSize: 13)),
            const SizedBox(height: 14),

            // Unlocked badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF16A34A).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: const Color(0xFF16A34A).withOpacity(0.4)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.check_circle_rounded,
                    color: Color(0xFF16A34A), size: 16),
                const SizedBox(width: 8),
                Text(building.howBn,
                    style: const TextStyle(
                        color: Color(0xFF16A34A),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _LockedBuildingSheet extends StatelessWidget {
  final JannahBuilding building;
  final JannahWorldState state;
  const _LockedBuildingSheet({required this.building, required this.state});

  Widget _row(IconData icon, String label, String cur, String need, bool done) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [
        Icon(icon,
            size: 14,
            color: done ? const Color(0xFF16A34A) : const Color(0xFF4A7A56)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label,
              style: const TextStyle(color: Color(0xFFD4EAD8), fontSize: 12)),
        ),
        Text('$cur / $need',
            style: TextStyle(
                color: done ? const Color(0xFF16A34A) : const Color(0xFFD4A843),
                fontSize: 11,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1E0E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF163320), width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF163320),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 14),

          // Greyed preview
          Opacity(
            opacity: 0.25,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF061209),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: CustomPaint(
                  size: const Size(180, 80),
                  painter: _BuildingPreviewPainter(type: building.type),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Text(building.nameBn,
              style: const TextStyle(
                  color: Color(0xFFD4EAD8),
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 5),
          Text(building.descBn,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF4A7A56), fontSize: 12)),
          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF061209),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF163320)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (building.reqPoints != null)
                _row(
                    Icons.stars_rounded,
                    'মোট পয়েন্ট',
                    '${state.totalPoints}',
                    '${building.reqPoints}',
                    state.totalPoints >= building.reqPoints!),
              if (building.reqStreak != null)
                _row(
                    Icons.local_fire_department_rounded,
                    'ধারাবাহিক দিন',
                    '${state.streakDays}',
                    '${building.reqStreak}',
                    state.streakDays >= building.reqStreak!),
              if (building.reqPct != null)
                _row(
                    Icons.percent_rounded,
                    'সমাপ্তি হার',
                    '${state.completionPct.toInt()}%',
                    '${building.reqPct!.toInt()}%',
                    state.completionPct >= building.reqPct!),
              if (building.reqAmalKey != null)
                _row(
                    Icons.task_alt_rounded,
                    'আমল: ${building.reqAmalKey}',
                    '—',
                    'সম্পন্ন',
                    state.completedAmalKeys.contains(building.reqAmalKey)),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ── Building preview painter (used inside sheets) ─────────────────────────────
class _BuildingPreviewPainter extends CustomPainter {
  final BuildingType type;
  _BuildingPreviewPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height * 0.65);
    // Reuse the same drawing functions with a smaller canvas
    final worldPainter = _JannahWorldPainter(
      state: const JannahWorldState(unlockedIds: {
        'sprout',
        'mosque',
        'pavilion',
        'fountain',
        'date_tree',
        'lantern',
        'bridge',
        'cottage',
        'golden_tree',
        'palace',
      }),
      size: size,
      waterT: 0.5,
      floatT: 0.3,
      pulseT: 0.5,
      onBuildingTap: (_) {},
    );
    canvas.save();
    canvas.translate(0, 0);
    switch (type) {
      case BuildingType.sprout:
        worldPainter._drawSprout(canvas, c, true);
        break;
      case BuildingType.mosque:
        worldPainter._drawMosque(canvas, c, true);
        break;
      case BuildingType.quranPavilion:
        worldPainter._drawPavilion(canvas, c, true);
        break;
      case BuildingType.fountain:
        worldPainter._drawFountain(canvas, c, true, 0.5);
        break;
      case BuildingType.dateTree:
        worldPainter._drawDateTree(canvas, c, true, 0.3);
        break;
      case BuildingType.lanternPost:
        worldPainter._drawLantern(canvas, c, true, 0.4);
        break;
      case BuildingType.bridge:
        worldPainter._drawBridge(canvas, c, true);
        break;
      case BuildingType.cottage:
        worldPainter._drawCottage(canvas, c, true);
        break;
      case BuildingType.goldenTree:
        worldPainter._drawGoldenTree(canvas, c, true, 0.3);
        break;
      case BuildingType.palace:
        worldPainter._drawPalace(canvas, c, true, 0.3);
        break;
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_) => false;
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 9 — UNLOCK CELEBRATION
// ═══════════════════════════════════════════════════════════════════════════

class _UnlockCelebrationDialog extends StatelessWidget {
  final JannahBuilding building;
  const _UnlockCelebrationDialog({required this.building});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A1E0E),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: const Color(0xFFD4A843).withOpacity(0.6), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4A843).withOpacity(0.15),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Animated building preview
          Container(
            height: 110,
            decoration: BoxDecoration(
              gradient: const RadialGradient(
                colors: [Color(0xFF1A4A2A), Color(0xFF061209)],
              ),
              borderRadius: BorderRadius.circular(18),
              border:
                  Border.all(color: const Color(0xFFD4A843).withOpacity(0.3)),
            ),
            child: Center(
              child: CustomPaint(
                size: const Size(200, 110),
                painter: _BuildingPreviewPainter(type: building.type),
              ),
            ),
          )
              .animate()
              .scale(
                begin: const Offset(0.3, 0.3),
                curve: Curves.elasticOut,
                duration: 800.ms,
              )
              .fadeIn(duration: 400.ms),
          const SizedBox(height: 12),

          const Text('নতুন স্থাপনা উন্মুক্ত!',
              style: TextStyle(
                  color: Color(0xFFD4A843),
                  fontSize: 12,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),

          Text(building.nameBn,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),

          Text(building.descBn,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.55), fontSize: 13)),
          const SizedBox(height: 20),

          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0E3D22), Color(0xFF1A6A35)],
                ),
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: const Color(0xFFD4A843).withOpacity(0.3)),
              ),
              child: const Center(
                child: Text('আলহামদুলিল্লাহ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION 10 — UNLOCK PARTICLES
// ═══════════════════════════════════════════════════════════════════════════

class _ParticleBurstPainter extends CustomPainter {
  final double t;
  _ParticleBurstPainter({required this.t});

  static final _rng = math.Random(55);
  static final _particles = List.generate(
      40,
      (_) => [
            (_rng.nextDouble() - 0.5) * 3.0,
            (_rng.nextDouble() - 0.5) * 3.0,
            _rng.nextDouble(),
          ]);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final p = Paint();
    final eased = Curves.easeOut.transform(t);

    for (int i = 0; i < _particles.length; i++) {
      final pt = _particles[i];
      final dist = eased * 250.0;
      final opacity = (1 - eased).clamp(0.0, 1.0);
      final r = 4.0 * (1 - eased * 0.7);
      final pos = center + Offset(pt[0] * dist, pt[1] * dist);

      // Gold particles
      p.color = const Color(0xFFD4A843).withOpacity(opacity * 0.9);
      canvas.drawCircle(pos, r, p);

      // White sparkle trails
      if (i % 3 == 0) {
        p.color = Colors.white.withOpacity(opacity * 0.5);
        canvas.drawCircle(
          center + Offset(pt[0] * dist * 0.6, pt[1] * dist * 0.6),
          r * 0.5,
          p,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_ParticleBurstPainter old) => old.t != t;
}
