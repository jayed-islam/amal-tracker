import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amal_tracker/core/router/app_router.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';
import 'package:amal_tracker/features/daily_knowledge/providers/daily_knowledge_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CARD TYPE CONFIG
// ─────────────────────────────────────────────────────────────────────────────
enum _CardType { ayah, hadith, dua, amal }

extension _CardTypeExt on _CardType {
  Color gradStart(BuildContext context) => switch (this) {
        _CardType.ayah => context.colors.midGreen,
        _CardType.hadith => context.colors.purple,
        _CardType.dua => context.colors.blue2,
        _CardType.amal => context.colors.amber3,
      };
  Color get gradEnd => switch (this) {
        _CardType.ayah => const Color(0xFF4ADE80),
        _CardType.hadith => const Color(0xFFA78BFA),
        _CardType.dua => const Color(0xFF38BDF8),
        _CardType.amal => const Color(0xFFFCD34D),
      };
  Color badgeBg(BuildContext context) => switch (this) {
        _CardType.ayah => context.colors.greenLight,
        _CardType.hadith => context.colors.purpleLight,
        _CardType.dua => context.colors.blueLight,
        _CardType.amal => context.colors.amberLight2,
      };
  Color accentColor(BuildContext context) => switch (this) {
        _CardType.ayah => context.colors.midGreen,
        _CardType.hadith => context.colors.purple,
        _CardType.dua => context.colors.blue2,
        _CardType.amal => context.colors.amber3,
      };
  Color accentBorder(BuildContext context) => switch (this) {
        _CardType.ayah => context.colors.greenBorder,
        _CardType.hadith => context.colors.purpleBorder,
        _CardType.dua => context.colors.blueBorder,
        _CardType.amal => context.colors.amberBorder,
      };
  String get badgeLabel => switch (this) {
        _CardType.ayah => '📖  আজকের আয়াত',
        _CardType.hadith => '📜  আজকের হাদিস',
        _CardType.dua => '🤲  মাসনুন দুআ',
        _CardType.amal => '✨  আজকের আমল',
      };
  String get loadingMessage => switch (this) {
        _CardType.ayah => 'আপনার জন্য একটা আয়াত আনা হচ্ছে...',
        _CardType.hadith => 'আপনার জন্য একটা হাদিস খোঁজা হচ্ছে...',
        _CardType.dua => 'মাসনুন দুআ লোড হচ্ছে...',
        _CardType.amal => 'আসন্ন আমল খোঁজা হচ্ছে...',
      };
  String get actionLabel => switch (this) {
        _CardType.ayah => 'তাফসির পড়ুন',
        _CardType.hadith => 'বিস্তারিত হাদিস',
        _CardType.dua => 'উচ্চারণ ও ফজিলত',
        _CardType.amal => 'আমলের ফজিলত',
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN HORIZONTAL SCROLL LIST SECTION
// ─────────────────────────────────────────────────────────────────────────────
class DailyCardsSection extends StatelessWidget {
  const DailyCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            const Text('🌿', style: TextStyle(fontSize: 13)),
            const SizedBox(width: 6),
            Text(
              'দৈনিক ইলম',
              style: TextStyle(
                color: context.colors.textPri,
                fontWeight: FontWeight.w800,
                fontSize: 13,
                letterSpacing: -.1,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => context.push(AppRoutes.dailyKnowledge),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: context.colors.greenLight,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  'সব দেখুন →',
                  style: TextStyle(
                    color: context.colors.darkGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
          // crossAxisAlignment.start so cards don't stretch to the tallest sibling
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _AyahCardWidget(),
              SizedBox(width: 10),
              _HadithCardWidget(),
              SizedBox(width: 10),
              _DuaCardWidget(),
              SizedBox(width: 10),
              _AmalCardWidget(),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD SHELL
// No static heights anywhere. AnimatedSize handles the smooth grow/shrink.
// ─────────────────────────────────────────────────────────────────────────────
class _CardShell extends StatelessWidget {
  final _CardType type;
  final String meta;
  final VoidCallback onRefresh;
  final Widget body;
  final Widget expandedExtra; // shown only when open
  final bool isOpen;
  final VoidCallback onToggle;

  const _CardShell({
    required this.type,
    required this.meta,
    required this.onRefresh,
    required this.body,
    required this.expandedExtra,
    required this.isOpen,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Container(
        width: 272,
        // No height constraint at all — content drives the size naturally
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.colors.border2, width: .5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.015),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize:
                MainAxisSize.min, // critical: never expand beyond content
            children: [
              // ── Top accent bar ──────────────────────────────────────────────
              Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [type.gradStart(context), type.gradEnd],
                  ),
                ),
              ),

              // ── Header + body ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Badge row
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: type.badgeBg(context),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: type.accentBorder(context), width: .5),
                        ),
                        child: Text(
                          type.badgeLabel,
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            color: type.accentColor(context),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                          width: 1,
                          height: 11,
                          color: context.colors.borderLight),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          meta,
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w600,
                            color: context.colors.textHint2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: onRefresh,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: context.colors.chipBg,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                                color: context.colors.border2, width: .5),
                          ),
                          child: Icon(
                            Icons.refresh_rounded,
                            size: 13,
                            color: context.colors.textMuted,
                          ),
                        ),
                      ),
                    ]),

                    const SizedBox(height: 8),

                    // Always-visible body (preview text)
                    body,

                    // Expanded extra — AnimatedSize already handles the outer
                    // container, but we still wrap in a Visibility so the widget
                    // tree stays lean when collapsed.
                    if (isOpen) ...[
                      const SizedBox(height: 8),
                      expandedExtra,
                    ],
                  ],
                ),
              ),

              // ── Divider ─────────────────────────────────────────────────────
              Container(
                  height: .5, color: context.colors.border2.withOpacity(.5)),

              // ── Action bar ──────────────────────────────────────────────────
              Material(
                color: const Color(0xFFFAFBFA),
                child: InkWell(
                  onTap: onToggle,
                  child: SizedBox(
                    height: 25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isOpen ? 'সংক্ষেপ করুন' : type.actionLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: type.accentColor(context),
                          ),
                        ),
                        const SizedBox(width: 2),
                        AnimatedRotation(
                          turns: isOpen ? .5 : 0,
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeInOut,
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 16,
                            color: type.accentColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SKELETON LOADER
// ─────────────────────────────────────────────────────────────────────────────
class _CardSkeleton extends StatelessWidget {
  final _CardType type;
  const _CardSkeleton({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 272,
      height: 125,
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.border2, width: .5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [type.gradStart(context), type.gradEnd],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        type.loadingMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      backgroundColor: context.colors.borderLight,
                      color: context.colors.border2,
                      minHeight: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 500.ms);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PREVIEW BODY  (always visible — just text, no height constraints)
// ─────────────────────────────────────────────────────────────────────────────

/// Plain bengali text shown in collapsed state (3 lines max).
/// When open the shell inserts expandedExtra below, so this widget
/// never needs to know about open/closed state.
class _PreviewText extends StatelessWidget {
  final String title;
  final String text;
  final bool isOpen;

  const _PreviewText({
    this.title = '',
    required this.text,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: context.colors.textPri,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
        ],
        Text(
          text,
          // collapsed → 2-3 lines preview; open → full text
          maxLines: isOpen ? null : (title.isNotEmpty ? 2 : 3),
          overflow: isOpen ? TextOverflow.visible : TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: context.colors.textSec,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD IMPLEMENTATIONS
// ─────────────────────────────────────────────────────────────────────────────
class _AyahCardWidget extends ConsumerStatefulWidget {
  const _AyahCardWidget();
  @override
  ConsumerState<_AyahCardWidget> createState() => _AyahCardWidgetState();
}

class _AyahCardWidgetState extends ConsumerState<_AyahCardWidget> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return ref.watch(ayahProvider).when(
          loading: () => const _CardSkeleton(type: _CardType.ayah),
          error: (_, __) => const SizedBox.shrink(),
          data: (d) => _CardShell(
            type: _CardType.ayah,
            isOpen: _open,
            onToggle: () => setState(() => _open = !_open),
            meta:
                '${d.surahNameBn} ${bnNum(d.surahNumber)}:${bnNum(d.ayahNumber)}',
            onRefresh: () => ref.read(ayahIndexProvider.notifier).next(),
            body: _PreviewText(text: d.bengali, isOpen: _open),
            expandedExtra: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _ArabicBlock(text: d.arabic),
                const SizedBox(height: 6),
                Row(children: [
                  _MiniChip(label: 'সূরা', value: d.surahNameBn),
                  const SizedBox(width: 5),
                  _MiniChip(label: 'আয়াত', value: bnNum(d.ayahNumber)),
                ]),
              ],
            ),
          ),
        );
  }
}

class _HadithCardWidget extends ConsumerStatefulWidget {
  const _HadithCardWidget();
  @override
  ConsumerState<_HadithCardWidget> createState() => _HadithCardWidgetState();
}

class _HadithCardWidgetState extends ConsumerState<_HadithCardWidget> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return ref.watch(hadithProvider).when(
          loading: () => const _CardSkeleton(type: _CardType.hadith),
          error: (_, __) => const SizedBox.shrink(),
          data: (d) => _CardShell(
            type: _CardType.hadith,
            isOpen: _open,
            onToggle: () => setState(() => _open = !_open),
            meta: '${d.bookName} · ${bnNum(d.hadithNumber)}',
            onRefresh: () => ref.read(hadithSeedProvider.notifier).next(),
            body: _PreviewText(text: d.bengali, isOpen: _open),
            expandedExtra: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (d.arabic.isNotEmpty) ...[
                  _ArabicBlock(text: d.arabic),
                  const SizedBox(height: 6),
                ],
                _NoteBlock(
                  label: 'উৎস ও মান',
                  text: '${d.bookName} (${d.grade})',
                  color: context.colors.purple,
                ),
              ],
            ),
          ),
        );
  }
}

class _DuaCardWidget extends ConsumerStatefulWidget {
  const _DuaCardWidget();
  @override
  ConsumerState<_DuaCardWidget> createState() => _DuaCardWidgetState();
}

class _DuaCardWidgetState extends ConsumerState<_DuaCardWidget> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final d = ref.watch(duaProvider);
    return _CardShell(
      type: _CardType.dua,
      isOpen: _open,
      onToggle: () => setState(() => _open = !_open),
      meta: d.occasion,
      onRefresh: () => ref.read(duaIndexProvider.notifier).next(),
      body: _PreviewText(text: d.bengali, isOpen: _open),
      expandedExtra: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _ArabicBlock(text: d.arabic),
          const SizedBox(height: 6),
          _NoteBlock(
              label: 'উচ্চারণ',
              text: d.transliteration,
              color: context.colors.blue2),
          const SizedBox(height: 5),
          _NoteBlock(
              label: 'ফজিলত', text: d.fadhilah, color: context.colors.blue2),
        ],
      ),
    );
  }
}

class _AmalCardWidget extends ConsumerStatefulWidget {
  const _AmalCardWidget();
  @override
  ConsumerState<_AmalCardWidget> createState() => _AmalCardWidgetState();
}

class _AmalCardWidgetState extends ConsumerState<_AmalCardWidget> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final d = ref.watch(amalProvider);
    return _CardShell(
      type: _CardType.amal,
      isOpen: _open,
      onToggle: () => setState(() => _open = !_open),
      meta: 'আসন্ন আমল',
      onRefresh: () => ref.read(amalIndexProvider.notifier).next(),
      body: _PreviewText(title: d.title, text: d.paragraph, isOpen: _open),
      expandedExtra: _NoteBlock(
        label: 'আমলের ফজিলত',
        text: d.fadhilah,
        color: context.colors.amber3,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE CHIPS & BLOCKS
// ─────────────────────────────────────────────────────────────────────────────
class _ArabicBlock extends StatelessWidget {
  final String text;
  const _ArabicBlock({required this.text});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: context.colors.goldBg,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: context.colors.goldBorder, width: .5),
        ),
        child: Text(
          text,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 13,
            color: context.colors.goldText,
            height: 1.8,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
}

class _MiniChip extends StatelessWidget {
  final String label, value;
  const _MiniChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: context.colors.chipBg,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: context.colors.border2, width: .5),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(
              '$label: ',
              style: TextStyle(
                fontSize: 8,
                color: context.colors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 9,
                  color: context.colors.textPri,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
        ),
      );
}

class _NoteBlock extends StatelessWidget {
  final String label, text;
  final Color color;
  const _NoteBlock({
    required this.label,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(.05),
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: color, width: 2.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: .4,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(
                fontSize: 10.5,
                height: 1.5,
                color: context.colors.textSec,
              ),
            ),
          ],
        ),
      );
}
