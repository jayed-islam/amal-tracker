import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_color_tokens.dart';
import '../../user/widgets/app_silver_bar.dart';
import '../providers/daily_knowledge_provider.dart';

enum DailyKnowledgeCategory { all, ayah, hadith, dua, amal }

extension DailyKnowledgeCategoryExt on DailyKnowledgeCategory {
  String get title => switch (this) {
        DailyKnowledgeCategory.all => 'সব',
        DailyKnowledgeCategory.ayah => '📖 আয়াত',
        DailyKnowledgeCategory.hadith => '📜 হাদিস',
        DailyKnowledgeCategory.dua => '🤲 দুআ',
        DailyKnowledgeCategory.amal => '✨ আমল',
      };
}

class DailyKnowledgeScreen extends ConsumerStatefulWidget {
  const DailyKnowledgeScreen({super.key});

  @override
  ConsumerState<DailyKnowledgeScreen> createState() =>
      _DailyKnowledgeScreenState();
}

class _DailyKnowledgeScreenState extends ConsumerState<DailyKnowledgeScreen> {
  final ScrollController _scrollController = ScrollController();
  DailyKnowledgeCategory _selectedCategory = DailyKnowledgeCategory.all;
  String? _copiedId;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _copyText(String id, String text) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.selectionClick();
    setState(() => _copiedId = id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text('ক্লিপবোর্ডে কপি করা হয়েছে!'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          backgroundColor: context.colors.darkGreen,
        ),
      );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _copiedId == id) {
        setState(() => _copiedId = null);
      }
    });
  }

  void _shareText(String title, String content) {
    HapticFeedback.selectionClick();
    Share.share(
      '$title\n\n$content\n\n— Sabeq (সাবিক্ব) অ্যাপ থেকে শেয়ারকৃত',
      subject: title,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final hPad = isTablet ? (size.width - 600) / 2 + 16.0 : 16.0;

    final ayahAsync = ref.watch(ayahProvider);
    final hadithAsync = ref.watch(hadithProvider);
    final duaData = ref.watch(duaProvider);
    final amalData = ref.watch(amalProvider);

    return Scaffold(
      backgroundColor: context.colors.bg,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          AppSliverBar(
            scrollController: _scrollController,
            title: 'দৈনিক ইলম ও আমল',
            subtitle: 'আয়াত, হাদিস, দুআ ও প্রাত্যহিক আমল',
            icon: Icons.menu_book_rounded,
            color: context.colors.midGreen,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: DailyKnowledgeCategory.values.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedCategory = cat);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? context.colors.darkGreen
                                : context.colors.card,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? context.colors.darkGreen
                                  : context.colors.border2,
                              width: isSelected ? 1.0 : 0.5,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: context.colors.darkGreen
                                          .withOpacity(0.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : [],
                          ),
                          child: Text(
                            cat.title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : context.colors.textSec,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── AYAH SECTION ──────────────────────────────────────────
                if (_shouldShowCategory(DailyKnowledgeCategory.ayah))
                  ayahAsync.when(
                    data: (d) => _AyahDetailCard(
                      data: d,
                      copiedId: _copiedId,
                      onCopy: _copyText,
                      onShare: _shareText,
                      onNext: () =>
                          ref.read(ayahIndexProvider.notifier).next(),
                    ).animate().fadeIn(duration: 250.ms),
                    loading: () =>
                        const _LoadingCard(label: 'আজকের আয়াত লোড হচ্ছে...'),
                    error: (_, __) => const SizedBox.shrink(),
                  ),

                if (_shouldShowCategory(DailyKnowledgeCategory.ayah))
                  const SizedBox(height: 16),

                // ── HADITH SECTION ────────────────────────────────────────
                if (_shouldShowCategory(DailyKnowledgeCategory.hadith))
                  hadithAsync.when(
                    data: (d) => _HadithDetailCard(
                      data: d,
                      copiedId: _copiedId,
                      onCopy: _copyText,
                      onShare: _shareText,
                      onNext: () =>
                          ref.read(hadithSeedProvider.notifier).next(),
                    ).animate().fadeIn(duration: 260.ms),
                    loading: () =>
                        const _LoadingCard(label: 'আজকের হাদিস লোড হচ্ছে...'),
                    error: (_, __) => const SizedBox.shrink(),
                  ),

                if (_shouldShowCategory(DailyKnowledgeCategory.hadith))
                  const SizedBox(height: 16),

                // ── DUA SECTION ───────────────────────────────────────────
                if (_shouldShowCategory(DailyKnowledgeCategory.dua)) ...[
                  _DuaDetailCard(
                    data: duaData,
                    copiedId: _copiedId,
                    onCopy: _copyText,
                    onShare: _shareText,
                    onNext: () => ref.read(duaIndexProvider.notifier).next(),
                  ).animate().fadeIn(duration: 270.ms),
                  const SizedBox(height: 16),
                ],

                // ── AMAL SECTION ──────────────────────────────────────────
                if (_shouldShowCategory(DailyKnowledgeCategory.amal)) ...[
                  _AmalDetailCard(
                    data: amalData,
                    copiedId: _copiedId,
                    onCopy: _copyText,
                    onShare: _shareText,
                    onNext: () =>
                        ref.read(amalIndexProvider.notifier).next(),
                  ).animate().fadeIn(duration: 280.ms),
                  const SizedBox(height: 16),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowCategory(DailyKnowledgeCategory cat) {
    if (_selectedCategory == DailyKnowledgeCategory.all) return true;
    return _selectedCategory == cat;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD COMPONENTS
// ─────────────────────────────────────────────────────────────────────────────

class _AyahDetailCard extends StatelessWidget {
  final AyahData data;
  final String? copiedId;
  final Function(String id, String text) onCopy;
  final Function(String title, String content) onShare;
  final VoidCallback onNext;

  const _AyahDetailCard({
    required this.data,
    required this.copiedId,
    required this.onCopy,
    required this.onShare,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final cardId = 'ayah_${data.surahNumber}_${data.ayahNumber}';
    final shareContent =
        '${data.arabic}\n\n"${data.bengali}"\n\n— ${data.surahNameBn} (${bnNum(data.surahNumber)}:${bnNum(data.ayahNumber)})';

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.greenBorder, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: context.colors.darkGreen.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Accent
          Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [context.colors.midGreen, const Color(0xFF4ADE80)],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Meta Badge Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.colors.greenLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: context.colors.greenBorder, width: 0.5),
                      ),
                      child: Text(
                        '📖  আজকের আয়াত',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: context.colors.midGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${data.surahNameBn} • আয়াত ${bnNum(data.ayahNumber)} (পারা ${bnNum(data.juzNumber)})',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textHint2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _RefreshIconButton(onTap: onNext),
                  ],
                ),
                const SizedBox(height: 14),

                // Arabic Text Block
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: context.colors.goldBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: context.colors.goldBorder, width: 0.6),
                  ),
                  child: Text(
                    data.arabic,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 18,
                      color: context.colors.goldText,
                      height: 2.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Bengali Translation
                Text(
                  data.bengali,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPri,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 10),

                // Action Bar
                Row(
                  children: [
                    _ActionButton(
                      icon: copiedId == cardId
                          ? Icons.check_rounded
                          : Icons.copy_rounded,
                      label: copiedId == cardId ? 'কপি হয়েছে' : 'কপি করুন',
                      color: copiedId == cardId
                          ? context.colors.darkGreen
                          : context.colors.textSec,
                      onTap: () => onCopy(cardId, shareContent),
                    ),
                    const SizedBox(width: 12),
                    _ActionButton(
                      icon: Icons.share_rounded,
                      label: 'শেয়ার করুন',
                      color: context.colors.textSec,
                      onTap: () => onShare('আজকের আয়াত', shareContent),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HadithDetailCard extends StatelessWidget {
  final HadithData data;
  final String? copiedId;
  final Function(String id, String text) onCopy;
  final Function(String title, String content) onShare;
  final VoidCallback onNext;

  const _HadithDetailCard({
    required this.data,
    required this.copiedId,
    required this.onCopy,
    required this.onShare,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final cardId = 'hadith_${data.bookName}_${data.hadithNumber}';
    final shareContent =
        '${data.arabic.isNotEmpty ? "${data.arabic}\n\n" : ""}"${data.bengali}"\n\n— ${data.bookName}, হাদিস নং ${bnNum(data.hadithNumber)} (${data.grade})';

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.purpleBorder, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: context.colors.purple.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Accent
          Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [context.colors.purple, const Color(0xFFA78BFA)],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Meta Badge Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.colors.purpleLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: context.colors.purpleBorder, width: 0.5),
                      ),
                      child: Text(
                        '📜  আজকের হাদিস',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: context.colors.purple,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${data.bookName} • হাদিস ${bnNum(data.hadithNumber)}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textHint2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _RefreshIconButton(onTap: onNext),
                  ],
                ),
                const SizedBox(height: 14),

                // Arabic Text Block (if available)
                if (data.arabic.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: context.colors.goldBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: context.colors.goldBorder, width: 0.6),
                    ),
                    child: Text(
                      data.arabic,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 17,
                        color: context.colors.goldText,
                        height: 1.9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Bengali Translation
                Text(
                  data.bengali,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPri,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 12),

                // Authenticity Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.colors.purple.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: context.colors.purple.withOpacity(0.3),
                        width: 0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded,
                          size: 13, color: context.colors.purple),
                      const SizedBox(width: 5),
                      Text(
                        'মান: ${data.grade} (${data.bookName})',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: context.colors.purple,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 10),

                // Action Bar
                Row(
                  children: [
                    _ActionButton(
                      icon: copiedId == cardId
                          ? Icons.check_rounded
                          : Icons.copy_rounded,
                      label: copiedId == cardId ? 'কপি হয়েছে' : 'কপি করুন',
                      color: copiedId == cardId
                          ? context.colors.darkGreen
                          : context.colors.textSec,
                      onTap: () => onCopy(cardId, shareContent),
                    ),
                    const SizedBox(width: 12),
                    _ActionButton(
                      icon: Icons.share_rounded,
                      label: 'শেয়ার করুন',
                      color: context.colors.textSec,
                      onTap: () => onShare('আজকের হাদিস', shareContent),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DuaDetailCard extends StatelessWidget {
  final DuaData data;
  final String? copiedId;
  final Function(String id, String text) onCopy;
  final Function(String title, String content) onShare;
  final VoidCallback onNext;

  const _DuaDetailCard({
    required this.data,
    required this.copiedId,
    required this.onCopy,
    required this.onShare,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final cardId = 'dua_${data.occasion.hashCode}';
    final shareContent =
        '${data.arabic}\n\nউচ্চারণ: ${data.transliteration}\n\nঅর্থ: "${data.bengali}"\n\nউপলক্ষ: ${data.occasion}\nফজিলত: ${data.fadhilah}';

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.blueBorder, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: context.colors.blue2.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Accent
          Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [context.colors.blue2, const Color(0xFF38BDF8)],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Meta Badge Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.colors.blueLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: context.colors.blueBorder, width: 0.5),
                      ),
                      child: Text(
                        '🤲  মাসনুন দুআ',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: context.colors.blue2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'উপলক্ষ: ${data.occasion}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textHint2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _RefreshIconButton(onTap: onNext),
                  ],
                ),
                const SizedBox(height: 14),

                // Arabic Text Block
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: context.colors.goldBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: context.colors.goldBorder, width: 0.6),
                  ),
                  child: Text(
                    data.arabic,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 18,
                      color: context.colors.goldText,
                      height: 2.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Transliteration Note Block
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.colors.blue2.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border(
                        left: BorderSide(color: context.colors.blue2, width: 3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'উচ্চারণ',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: context.colors.blue2,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        data.transliteration,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textPri,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Bengali Translation
                Text(
                  data.bengali,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textSec,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 10),

                // Fadhilah Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.colors.goldLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: context.colors.gold.withOpacity(0.3), width: 0.5),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('✨', style: TextStyle(fontSize: 13)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'ফজিলত: ${data.fadhilah}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: context.colors.goldText,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 10),

                // Action Bar
                Row(
                  children: [
                    _ActionButton(
                      icon: copiedId == cardId
                          ? Icons.check_rounded
                          : Icons.copy_rounded,
                      label: copiedId == cardId ? 'কপি হয়েছে' : 'কপি করুন',
                      color: copiedId == cardId
                          ? context.colors.darkGreen
                          : context.colors.textSec,
                      onTap: () => onCopy(cardId, shareContent),
                    ),
                    const SizedBox(width: 12),
                    _ActionButton(
                      icon: Icons.share_rounded,
                      label: 'শেয়ার করুন',
                      color: context.colors.textSec,
                      onTap: () => onShare('মাসনুন দুআ', shareContent),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AmalDetailCard extends StatelessWidget {
  final AmalData data;
  final String? copiedId;
  final Function(String id, String text) onCopy;
  final Function(String title, String content) onShare;
  final VoidCallback onNext;

  const _AmalDetailCard({
    required this.data,
    required this.copiedId,
    required this.onCopy,
    required this.onShare,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final cardId = 'amal_${data.title.hashCode}';
    final shareContent =
        '${data.title}\n\n${data.paragraph}\n\nফজিলত: ${data.fadhilah}';

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.amberBorder, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: context.colors.amber3.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Accent
          Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [context.colors.amber3, const Color(0xFFFCD34D)],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Meta Badge Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.colors.amberLight2,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: context.colors.amberBorder, width: 0.5),
                      ),
                      child: Text(
                        '✨  আজকের আমল',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: context.colors.amber3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'পরামর্শ ও ফজিলত',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textHint2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _RefreshIconButton(onTap: onNext),
                  ],
                ),
                const SizedBox(height: 14),

                // Title
                Text(
                  data.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPri,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 8),

                // Explanation
                Text(
                  data.paragraph,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: context.colors.textSec,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 12),

                // Fadhilah Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.colors.amber3.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(10),
                    border: Border(
                        left:
                            BorderSide(color: context.colors.amber3, width: 3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'আমলের ফজিলত',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: context.colors.amber3,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        data.fadhilah,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textPri,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 10),

                // Action Bar
                Row(
                  children: [
                    _ActionButton(
                      icon: copiedId == cardId
                          ? Icons.check_rounded
                          : Icons.copy_rounded,
                      label: copiedId == cardId ? 'কপি হয়েছে' : 'কপি করুন',
                      color: copiedId == cardId
                          ? context.colors.darkGreen
                          : context.colors.textSec,
                      onTap: () => onCopy(cardId, shareContent),
                    ),
                    const SizedBox(width: 12),
                    _ActionButton(
                      icon: Icons.share_rounded,
                      label: 'শেয়ার করুন',
                      color: context.colors.textSec,
                      onTap: () => onShare(data.title, shareContent),
                    ),
                  ],
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
// SHARED HELPER WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingCard extends StatelessWidget {
  final String label;
  const _LoadingCard({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border2, width: 0.5),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: context.colors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            backgroundColor: context.colors.borderLight,
            color: context.colors.darkGreen,
            minHeight: 2,
          ),
        ],
      ),
    );
  }
}

class _RefreshIconButton extends StatelessWidget {
  final VoidCallback onTap;
  const _RefreshIconButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: context.colors.chipBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.colors.border2, width: 0.5),
        ),
        child: Icon(
          Icons.refresh_rounded,
          size: 14,
          color: context.colors.textMuted,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
