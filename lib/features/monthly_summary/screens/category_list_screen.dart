// import 'package:amal_tracker/features/monthly_summary/widgets/monthly_amol_shared.dart';
// import 'package:amal_tracker/features/tracker/models/tracker_model.dart';
// import 'package:amal_tracker/features/tracker/providers/tracker_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../core/constants/app_constants.dart';
// import 'category_progress_screen.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // CATEGORY LIST SCREEN — full page (was a bottom sheet before). Shows every
// // active category (from /tracker/categories, dynamic — no static bucket),
// // with a search box, section filter chips, and the current month's real stat
// // (from MonthlyTracker.categoryStats) per row. Tapping a row opens the
// // dedicated CategoryProgressScreen for full detail.
// // ─────────────────────────────────────────────────────────────────────────────

// class CategoryListScreen extends ConsumerStatefulWidget {
//   final int year;
//   final int month;
//   const CategoryListScreen(
//       {super.key, required this.year, required this.month});

//   @override
//   ConsumerState<CategoryListScreen> createState() => _CategoryListScreenState();
// }

// class _CategoryListScreenState extends ConsumerState<CategoryListScreen> {
//   final _searchCtrl = TextEditingController();
//   String _query = '';
//   String _selectedSection = 'all';

//   @override
//   void dispose() {
//     _searchCtrl.dispose();
//     super.dispose();
//   }

//   void _openDetail(AmalCategory cat) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => CategoryProgressScreen(category: cat)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final params = (year: widget.year, month: widget.month);
//     final catsAsync = ref.watch(categoriesProvider);
//     final catsBySection = ref.watch(categoriesBySection);
//     final progressAsync = ref.watch(progressSummaryProvider(params));
//     final monthName = AppConstants.bengaliMonths[widget.month - 1];

//     final q = _query.trim().toLowerCase();
//     final sections = catsBySection.keys.toList();

//     return Scaffold(
//       backgroundColor: AmolColors.pageBg,
//       appBar: AppBar(
//         backgroundColor: AmolColors.darkGreen,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         titleSpacing: 0,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text('সব আমল',
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
//             Text('$monthName ${widget.year}',
//                 style: TextStyle(
//                     fontSize: 10.5, color: Colors.white.withOpacity(0.6))),
//           ],
//         ),
//       ),
//       body: catsAsync.when(
//         loading: () => const _ListSkeleton(),
//         error: (_, __) =>
//             AmolErrorCard(onRetry: () => ref.invalidate(categoriesProvider)),
//         data: (_) {
//           final filteredMap = <String, List<AmalCategory>>{};
//           for (final s in sections) {
//             final list = catsBySection[s]!
//                 .where((c) =>
//                     q.isEmpty ||
//                     c.nameBn.toLowerCase().contains(q) ||
//                     c.nameEn.toLowerCase().contains(q))
//                 .toList();
//             if (list.isNotEmpty) filteredMap[s] = list;
//           }
//           final visibleSections = _selectedSection == 'all'
//               ? filteredMap.keys.toList()
//               : [_selectedSection];

//           final tracker = progressAsync.valueOrNull?.currentMonth;
//           final stats = tracker?.categoryStats ?? const {};
//           final daysElapsed =
//               (tracker?.eligibleDays ?? 0) + (tracker?.exemptDays ?? 0);
//           final eligibleDays = tracker?.eligibleDays ?? 0;

//           return CustomScrollView(
//             slivers: [
//               // ── Search + Filter ────────────────────────────────────────
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: AmolColors.cardBg,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: AmolColors.border, width: 0.5),
//                     ),
//                     child: TextField(
//                       controller: _searchCtrl,
//                       onChanged: (v) => setState(() => _query = v),
//                       style: const TextStyle(
//                           fontSize: 13.5, color: AmolColors.textPrimary),
//                       decoration: InputDecoration(
//                         hintText:
//                             'আমলের নাম লিখুন (যেমন: তাহাজ্জুদ, ইস্তিগফার...)',
//                         hintStyle: const TextStyle(
//                             color: AmolColors.textHint,
//                             fontSize: 12.5,
//                             fontWeight: FontWeight.w500),
//                         prefixIcon: const Icon(Icons.search_rounded,
//                             size: 18, color: AmolColors.textHint),
//                         suffixIcon: _query.isNotEmpty
//                             ? GestureDetector(
//                                 onTap: () {
//                                   _searchCtrl.clear();
//                                   setState(() => _query = '');
//                                 },
//                                 child: const Icon(Icons.close_rounded,
//                                     size: 16, color: AmolColors.textHint),
//                               )
//                             : null,
//                         border: InputBorder.none,
//                         contentPadding: const EdgeInsets.symmetric(
//                             vertical: 12, horizontal: 4),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//                   child: SizedBox(
//                     height: 34,
//                     child: ListView(
//                       scrollDirection: Axis.horizontal,
//                       children: [
//                         AmolFilterChip(
//                           label: 'সব',
//                           emoji: '✨',
//                           selected: _selectedSection == 'all',
//                           onTap: () => setState(() => _selectedSection = 'all'),
//                         ),
//                         ...sections.map((s) => Padding(
//                               padding: const EdgeInsets.only(left: 6),
//                               child: AmolFilterChip(
//                                 label: AmolSectionMeta.label(s),
//                                 emoji: s == 'salat'
//                                     ? '🕌'
//                                     : s == 'quran'
//                                         ? '📖'
//                                         : s == 'dhikr'
//                                             ? '📿'
//                                             : s == 'fasting'
//                                                 ? '🌙'
//                                                 : '🤲',
//                                 selected: _selectedSection == s,
//                                 onTap: () =>
//                                     setState(() => _selectedSection = s),
//                               ),
//                             )),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               const SliverToBoxAdapter(child: SizedBox(height: 12)),

//               // ── List ────────────────────────────────────────────────────
//               if (filteredMap.isEmpty)
//                 const SliverFillRemaining(
//                   hasScrollBody: false,
//                   child: Center(
//                     child: Padding(
//                       padding: EdgeInsets.only(bottom: 60),
//                       child: Column(mainAxisSize: MainAxisSize.min, children: [
//                         Text('🔍', style: TextStyle(fontSize: 30)),
//                         SizedBox(height: 10),
//                         Text('কোনো আমল পাওয়া যায়নি',
//                             style: TextStyle(
//                                 color: AmolColors.textHint, fontSize: 13)),
//                       ]),
//                     ),
//                   ),
//                 )
//               else
//                 SliverPadding(
//                   padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
//                   sliver: SliverList(
//                     delegate: SliverChildListDelegate([
//                       for (final section in visibleSections) ...[
//                         if (filteredMap[section] != null) ...[
//                           Padding(
//                             padding: const EdgeInsets.only(top: 6, bottom: 8),
//                             child: Text(AmolSectionMeta.label(section),
//                                 style: const TextStyle(
//                                     color: AmolColors.textSecondary,
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: 12)),
//                           ),
//                           Container(
//                             margin: const EdgeInsets.only(bottom: 14),
//                             decoration: BoxDecoration(
//                               color: AmolColors.cardBg,
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(
//                                   color: AmolColors.border, width: 0.5),
//                             ),
//                             child: Column(
//                               children: List.generate(
//                                   filteredMap[section]!.length, (i) {
//                                 final cat = filteredMap[section]![i];
//                                 final stat =
//                                     stats[cat.id] ?? CategoryStat.empty;
//                                 final isLast =
//                                     i == filteredMap[section]!.length - 1;
//                                 return InkWell(
//                                   onTap: () => _openDetail(cat),
//                                   borderRadius: BorderRadius.vertical(
//                                     top: i == 0
//                                         ? const Radius.circular(16)
//                                         : Radius.zero,
//                                     bottom: isLast
//                                         ? const Radius.circular(16)
//                                         : Radius.zero,
//                                   ),
//                                   child: _CategoryRow(
//                                     category: cat,
//                                     stat: stat,
//                                     daysElapsed: daysElapsed,
//                                     eligibleDays: eligibleDays,
//                                     isLast: isLast,
//                                   ),
//                                 );
//                               }),
//                             ),
//                           ),
//                         ],
//                       ],
//                     ]),
//                   ),
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // CATEGORY ROW
// // ─────────────────────────────────────────────────────────────────────────────

// class _CategoryRow extends StatelessWidget {
//   final AmalCategory category;
//   final CategoryStat stat;
//   final int daysElapsed;
//   final int eligibleDays;
//   final bool isLast;
//   const _CategoryRow({
//     required this.category,
//     required this.stat,
//     required this.daysElapsed,
//     required this.eligibleDays,
//     required this.isLast,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isFardPrayer = category.isFard && category.isPrayer;
//     final isCounter = category.inputType == AmalInputType.counter ||
//         category.inputType == AmalInputType.duration;

//     String valueText;
//     String subText;
//     double rate;
//     Color barColor;

//     if (isFardPrayer) {
//       final total = stat.congregationDays + stat.soloDays;
//       final denom = eligibleDays > 0 ? eligibleDays : 1;
//       valueText = '$total/$denom';
//       subText =
//           'জামাত ${stat.congregationDays} · একা ${stat.soloDays} · মিস ${stat.missedDays}';
//       rate = (total / denom).clamp(0.0, 1.0);
//       barColor = stat.congregationDays >= stat.soloDays
//           ? AmolColors.purple
//           : AmolColors.green;
//     } else if (isCounter) {
//       final unitBn = AmolUnit.bn(category.unit);
//       valueText = '${stat.totalCount}${unitBn.isNotEmpty ? " $unitBn" : ""}';
//       subText = '${stat.daysActive} দিন সক্রিয়';
//       rate =
//           daysElapsed > 0 ? (stat.daysActive / daysElapsed).clamp(0.0, 1.0) : 0;
//       barColor = AmolColors.green;
//     } else {
//       valueText = '${stat.daysActive} দিন';
//       subText = daysElapsed > 0
//           ? '${((stat.daysActive / daysElapsed) * 100).toInt()}% মাস জুড়ে'
//           : 'কোনো ডেটা নেই';
//       rate =
//           daysElapsed > 0 ? (stat.daysActive / daysElapsed).clamp(0.0, 1.0) : 0;
//       barColor = AmolColors.amber;
//     }

//     final hasAny = stat.daysActive > 0 ||
//         stat.totalCount > 0 ||
//         stat.congregationDays > 0 ||
//         stat.soloDays > 0;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         border: isLast
//             ? null
//             : const Border(
//                 bottom: BorderSide(color: AmolColors.border, width: 0.5)),
//       ),
//       child: Row(children: [
//         AmolIcon(category: category, size: 38),
//         const SizedBox(width: 12),
//         Expanded(
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Row(children: [
//               Expanded(
//                 child: Text(category.nameBn,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                         color: AmolColors.textPrimary,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 13)),
//               ),
//               if (category.isFard)
//                 Container(
//                   margin: const EdgeInsets.only(left: 6),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                   decoration: BoxDecoration(
//                       color: AmolColors.purpleLight,
//                       borderRadius: BorderRadius.circular(20)),
//                   child: const Text('ফরজ',
//                       style: TextStyle(
//                           color: AmolColors.purple,
//                           fontSize: 8.5,
//                           fontWeight: FontWeight.w700)),
//                 ),
//             ]),
//             const SizedBox(height: 3),
//             Text(subText,
//                 style:
//                     const TextStyle(color: AmolColors.textHint, fontSize: 10)),
//             const SizedBox(height: 6),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(99),
//               child: LinearProgressIndicator(
//                 value: rate,
//                 minHeight: 4,
//                 backgroundColor: AmolColors.pageBg,
//                 valueColor: AlwaysStoppedAnimation(
//                     hasAny ? barColor : AmolColors.border),
//               ),
//             ),
//           ]),
//         ),
//         const SizedBox(width: 10),
//         Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
//           Text(valueText,
//               style: TextStyle(
//                   color: hasAny ? AmolColors.textPrimary : AmolColors.textHint,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 13)),
//           const SizedBox(height: 2),
//           const Icon(Icons.chevron_right_rounded,
//               size: 16, color: AmolColors.textHint),
//         ]),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // LOADING SKELETON
// // ─────────────────────────────────────────────────────────────────────────────

// class _ListSkeleton extends StatelessWidget {
//   const _ListSkeleton();

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
//       children: [
//         const AmolShimmerBox(height: 44, radius: 12),
//         const SizedBox(height: 12),
//         const AmolShimmerBox(height: 34, radius: 20),
//         const SizedBox(height: 16),
//         Container(
//           decoration: BoxDecoration(
//               color: AmolColors.cardBg,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: AmolColors.border, width: 0.5)),
//           child: Column(
//               children: List.generate(
//                   6,
//                   (i) => Padding(
//                         padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
//                         child: const AmolShimmerBox(height: 52, radius: 10),
//                       ))),
//         ),
//       ],
//     );
//   }
// }
import 'package:amal_tracker/features/monthly_summary/widgets/monthly_amol_shared.dart';
import 'package:amal_tracker/features/tracker/models/tracker_model.dart';
import 'package:amal_tracker/features/tracker/providers/tracker_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import 'category_progress_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CATEGORY LIST SCREEN — full page (was a bottom sheet before). Shows every
// active category (from /tracker/categories, dynamic — no static bucket),
// with a search box, section filter chips, and the current month's real stat
// (from MonthlyTracker.categoryStats) per row. Tapping a row opens the
// category progress as a bottom sheet (showCategoryProgressSheet) — a quick
// detail peek fits a sheet better than a full navigation page.
// ─────────────────────────────────────────────────────────────────────────────

class CategoryListScreen extends ConsumerStatefulWidget {
  final int year;
  final int month;
  const CategoryListScreen(
      {super.key, required this.year, required this.month});

  @override
  ConsumerState<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends ConsumerState<CategoryListScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _selectedSection = 'all';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openDetail(AmalCategory cat) {
    showCategoryProgressSheet(context, cat);
  }

  @override
  Widget build(BuildContext context) {
    final params = (year: widget.year, month: widget.month);
    final catsAsync = ref.watch(categoriesProvider);
    final catsBySection = ref.watch(categoriesBySection);
    final progressAsync = ref.watch(progressSummaryProvider(params));
    final monthName = AppConstants.bengaliMonths[widget.month - 1];

    final q = _query.trim().toLowerCase();
    // final sections = catsBySection.keys.toList();

    final sections = AmolSectionMeta.orderedSections
        .where((s) => catsBySection.containsKey(s))
        .toList();

    for (final key in catsBySection.keys) {
      if (!sections.contains(key)) {
        sections.add(key);
      }
    }

    return Scaffold(
      backgroundColor: AmolColors.pageBg,
      appBar: AppBar(
        backgroundColor: AmolColors.darkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('সব আমল',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            Text('$monthName ${widget.year}',
                style: TextStyle(
                    fontSize: 10.5, color: Colors.white.withOpacity(0.6))),
          ],
        ),
      ),
      body: catsAsync.when(
        loading: () => const _ListSkeleton(),
        error: (_, __) =>
            AmolErrorCard(onRetry: () => ref.invalidate(categoriesProvider)),
        data: (_) {
          final filteredMap = <String, List<AmalCategory>>{};
          for (final s in sections) {
            final list = catsBySection[s]!
                .where((c) =>
                    q.isEmpty ||
                    c.nameBn.toLowerCase().contains(q) ||
                    c.nameEn.toLowerCase().contains(q))
                .toList();
            if (list.isNotEmpty) filteredMap[s] = list;
          }
          final visibleSections = _selectedSection == 'all'
              ? filteredMap.keys.toList()
              : [_selectedSection];

          final tracker = progressAsync.valueOrNull?.currentMonth;
          final stats = tracker?.categoryStats ?? const {};
          final daysElapsed =
              (tracker?.eligibleDays ?? 0) + (tracker?.exemptDays ?? 0);
          final eligibleDays = tracker?.eligibleDays ?? 0;

          return CustomScrollView(
            slivers: [
              // ── Search + Filter ────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AmolColors.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AmolColors.border, width: 0.5),
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (v) => setState(() => _query = v),
                      style: const TextStyle(
                          fontSize: 13.5, color: AmolColors.textPrimary),
                      decoration: InputDecoration(
                        hintText:
                            'আমলের নাম লিখুন (যেমন: তাহাজ্জুদ, ইস্তিগফার...)',
                        hintStyle: const TextStyle(
                            color: AmolColors.textHint,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500),
                        prefixIcon: const Icon(Icons.search_rounded,
                            size: 18, color: AmolColors.textHint),
                        suffixIcon: _query.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  _searchCtrl.clear();
                                  setState(() => _query = '');
                                },
                                child: const Icon(Icons.close_rounded,
                                    size: 16, color: AmolColors.textHint),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 4),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: SizedBox(
                    height: 34,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        AmolFilterChip(
                          label: 'সব',
                          emoji: '✨',
                          selected: _selectedSection == 'all',
                          onTap: () => setState(() => _selectedSection = 'all'),
                        ),
                        ...sections.map((s) => Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: AmolFilterChip(
                                label: AmolSectionMeta.label(s),
                                emoji: s == 'salat'
                                    ? '🕌'
                                    : s == 'quran'
                                        ? '📖'
                                        : s == 'dhikr'
                                            ? '📿'
                                            : s == 'fasting'
                                                ? '🌙'
                                                : '🤲',
                                selected: _selectedSection == s,
                                onTap: () =>
                                    setState(() => _selectedSection = s),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // ── List ────────────────────────────────────────────────────
              if (filteredMap.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text('🔍', style: TextStyle(fontSize: 30)),
                        SizedBox(height: 10),
                        Text('কোনো আমল পাওয়া যায়নি',
                            style: TextStyle(
                                color: AmolColors.textHint, fontSize: 13)),
                      ]),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      for (final section in visibleSections) ...[
                        if (filteredMap[section] != null) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 6, bottom: 8),
                            child: Text(AmolSectionMeta.label(section),
                                style: const TextStyle(
                                    color: AmolColors.textSecondary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: AmolColors.cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AmolColors.border, width: 0.5),
                            ),
                            child: Column(
                              children: List.generate(
                                  filteredMap[section]!.length, (i) {
                                final cat = filteredMap[section]![i];
                                final stat =
                                    stats[cat.id] ?? CategoryStat.empty;
                                final isLast =
                                    i == filteredMap[section]!.length - 1;
                                return InkWell(
                                  onTap: () => _openDetail(cat),
                                  borderRadius: BorderRadius.vertical(
                                    top: i == 0
                                        ? const Radius.circular(16)
                                        : Radius.zero,
                                    bottom: isLast
                                        ? const Radius.circular(16)
                                        : Radius.zero,
                                  ),
                                  child: _CategoryRow(
                                    category: cat,
                                    stat: stat,
                                    daysElapsed: daysElapsed,
                                    eligibleDays: eligibleDays,
                                    isLast: isLast,
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ],
                    ]),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CATEGORY ROW
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryRow extends StatelessWidget {
  final AmalCategory category;
  final CategoryStat stat;
  final int daysElapsed;
  final int eligibleDays;
  final bool isLast;
  const _CategoryRow({
    required this.category,
    required this.stat,
    required this.daysElapsed,
    required this.eligibleDays,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isFardPrayer = category.isFard && category.isPrayer;
    final isCounter = category.inputType == AmalInputType.counter ||
        category.inputType == AmalInputType.duration;

    String valueText;
    String subText;
    double rate;
    Color barColor;

    if (isFardPrayer) {
      final total = stat.congregationDays + stat.soloDays;
      final denom = eligibleDays > 0 ? eligibleDays : 1;
      valueText = '$total/$denom';
      subText =
          'জামাত ${stat.congregationDays} · একা ${stat.soloDays} · মিস ${stat.missedDays}';
      rate = (total / denom).clamp(0.0, 1.0);
      barColor = stat.congregationDays >= stat.soloDays
          ? AmolColors.purple
          : AmolColors.green;
    } else if (isCounter) {
      final unitBn = AmolUnit.bn(category.unit);
      valueText = '${stat.totalCount}${unitBn.isNotEmpty ? " $unitBn" : ""}';
      subText = '${stat.daysActive} দিন সক্রিয়';
      rate =
          daysElapsed > 0 ? (stat.daysActive / daysElapsed).clamp(0.0, 1.0) : 0;
      barColor = AmolColors.green;
    } else {
      valueText = '${stat.daysActive} দিন';
      subText = daysElapsed > 0
          ? '${((stat.daysActive / daysElapsed) * 100).toInt()}% মাস জুড়ে'
          : 'কোনো ডেটা নেই';
      rate =
          daysElapsed > 0 ? (stat.daysActive / daysElapsed).clamp(0.0, 1.0) : 0;
      barColor = AmolColors.amber;
    }

    final hasAny = stat.daysActive > 0 ||
        stat.totalCount > 0 ||
        stat.congregationDays > 0 ||
        stat.soloDays > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: AmolColors.border, width: 0.5)),
      ),
      child: Row(children: [
        AmolIcon(category: category, size: 38),
        const SizedBox(width: 12),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(category.nameBn,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AmolColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
              ),
              if (category.isFard)
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: AmolColors.purpleLight,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text('ফরজ',
                      style: TextStyle(
                          color: AmolColors.purple,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700)),
                ),
            ]),
            const SizedBox(height: 3),
            Text(subText,
                style:
                    const TextStyle(color: AmolColors.textHint, fontSize: 10)),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: rate,
                minHeight: 4,
                backgroundColor: AmolColors.pageBg,
                valueColor: AlwaysStoppedAnimation(
                    hasAny ? barColor : AmolColors.border),
              ),
            ),
          ]),
        ),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(valueText,
              style: TextStyle(
                  color: hasAny ? AmolColors.textPrimary : AmolColors.textHint,
                  fontWeight: FontWeight.w800,
                  fontSize: 13)),
          const SizedBox(height: 2),
          const Icon(Icons.chevron_right_rounded,
              size: 16, color: AmolColors.textHint),
        ]),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LOADING SKELETON
// ─────────────────────────────────────────────────────────────────────────────

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        const AmolShimmerBox(height: 44, radius: 12),
        const SizedBox(height: 12),
        const AmolShimmerBox(height: 34, radius: 20),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
              color: AmolColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AmolColors.border, width: 0.5)),
          child: Column(
              children: List.generate(
                  6,
                  (i) => Padding(
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                        child: const AmolShimmerBox(height: 52, radius: 10),
                      ))),
        ),
      ],
    );
  }
}
