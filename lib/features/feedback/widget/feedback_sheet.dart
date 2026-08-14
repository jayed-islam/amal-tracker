import 'package:amal_tracker/core/theme/app_color_tokens.dart';
import 'package:amal_tracker/features/auth/providers/auth_provider.dart';
import 'package:amal_tracker/features/feedback/provider/feedback_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// FEEDBACK SHEET
// ─────────────────────────────────────────────────────────────────────────────
//
// Write-only ফিচার — submit করার পর user নিজের পাঠানো মতামত আর দেখতে/এডিট
// করতে পারবে না, তাই এখানে কোনো history/list নেই, শুধু single-purpose form।
//
// UX সিদ্ধান্ত:
//  • Category প্রথমে বেছে নিতে হয় (default "অন্যান্য" প্রি-সিলেক্টেড) —
//    এতে backend এ ভালো bucket হয়ে যায়, user কে বাড়তি টাইপ করতে হয় না।
//  • Star rating সম্পূর্ণ ঐচ্ছিক ও আলাদা — কারো "বাগ রিপোর্ট" এর সাথে রেটিং
//    জড়ানো জোরপূর্বক মনে হতে পারে, তাই কখনোই required নয়।
//  • সফল হলে sheet নিজেই বন্ধ হয়ে যায় (Navigator.pop(true)) — সাফল্যের
//    snackbar caller (settings screen) থেকে দেখানো হয়, কারণ sheet বন্ধ
//    হওয়ার পর ওই context এই আর valid থাকে না।
//  • Submit চলাকালীন sheet dismiss করা যাবে না (PopScope) — মাঝপথে বন্ধ
//    করলে request ঝুলে থাকতে পারে, silent data loss এর সুযোগ রাখা হয়নি।
//
class FeedbackSheet extends ConsumerStatefulWidget {
  const FeedbackSheet({super.key});

  @override
  ConsumerState<FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends ConsumerState<FeedbackSheet> {
  final _messageCtrl = TextEditingController();
  FeedbackCategory _category = FeedbackCategory.other;
  int? _rating;
  String? _localError;

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  ({Color fg, Color bg}) _categoryColors(
      BuildContext context, FeedbackCategory c) {
    switch (c) {
      case FeedbackCategory.bug:
        return (fg: context.colors.red, bg: context.colors.redLight);
      case FeedbackCategory.suggestion:
        return (fg: context.colors.blue, bg: context.colors.blueLight);
      case FeedbackCategory.complaint:
        return (fg: context.colors.amber, bg: context.colors.amberLight);
      case FeedbackCategory.praise:
        return (fg: context.colors.purple, bg: context.colors.purpleLight);
      case FeedbackCategory.other:
        return (fg: context.colors.teal, bg: context.colors.tealLight);
    }
  }

  Future<void> _submit() async {
    final message = _messageCtrl.text.trim();
    if (message.length < 3) {
      setState(() => _localError = 'কমপক্ষে ৩ অক্ষর লিখুন');
      return;
    }

    setState(() => _localError = null);
    HapticFeedback.selectionClick();

    final ok = await ref.read(feedbackProvider.notifier).submit(
          message: message,
          category: _category,
          rating: _rating,
        );

    if (!mounted) return;
    if (ok) {
      HapticFeedback.mediumImpact();
      Navigator.of(context).pop(true);
    }
    // ব্যর্থ হলে sheet খোলা থাকে, নিচে state.error inline দেখানো হয় — user
    // লেখাটা আবার টাইপ না করেই আবার চেষ্টা করতে পারে।
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(feedbackProvider);
    final isSubmitting = state.isSubmitting;

    return PopScope(
      canPop: !isSubmitting,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: context.colors.border,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  Row(children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.colors.greenLight,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(Icons.rate_review_rounded,
                          color: context.colors.darkGreen, size: 19),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('মতামত জানান',
                              style: TextStyle(
                                  color: context.colors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16.5,
                                  letterSpacing: -0.2)),
                          const SizedBox(height: 1),
                          Text('শুধু আমাদের টিম এটি দেখবে',
                              style: TextStyle(
                                  color: context.colors.textSecondary,
                                  fontSize: 11.5)),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(height: 20),

                  // ── Category chips ───────────────────────────────────────
                  Text('কী ধরনের মতামত?',
                      style: TextStyle(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                  const SizedBox(height: 9),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: FeedbackCategory.values.map((c) {
                      final selected = c == _category;
                      final colors = _categoryColors(context, c);
                      return GestureDetector(
                        onTap: isSubmitting
                            ? null
                            : () {
                                HapticFeedback.selectionClick();
                                setState(() => _category = c);
                              },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected ? colors.bg : context.colors.bg,
                            borderRadius: BorderRadius.circular(99),
                            border: Border.all(
                                color: selected
                                    ? colors.fg.withOpacity(0.35)
                                    : context.colors.border,
                                width: selected ? 1 : 0.7),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(c.icon,
                                size: 14,
                                color: selected
                                    ? colors.fg
                                    : context.colors.textHint),
                            const SizedBox(width: 6),
                            Text(c.labelBn,
                                style: TextStyle(
                                    color: selected
                                        ? colors.fg
                                        : context.colors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w500)),
                          ]),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // ── Optional rating ──────────────────────────────────────
                  Row(children: [
                    Text('সামগ্রিক অভিজ্ঞতা',
                        style: TextStyle(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13)),
                    const SizedBox(width: 6),
                    Text('(ঐচ্ছিক)',
                        style: TextStyle(
                            color: context.colors.textHint, fontSize: 11)),
                  ]),
                  const SizedBox(height: 9),
                  Row(
                      children: List.generate(5, (i) {
                    final starValue = i + 1;
                    final filled = _rating != null && starValue <= _rating!;
                    return GestureDetector(
                      onTap: isSubmitting
                          ? null
                          : () {
                              HapticFeedback.selectionClick();
                              setState(() => _rating =
                                  (_rating == starValue) ? null : starValue);
                            },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Icon(
                          filled
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 30,
                          color: filled
                              ? context.colors.gold
                              : context.colors.textHint,
                        ),
                      ),
                    );
                  })),

                  const SizedBox(height: 20),

                  // ── Message ───────────────────────────────────────────────
                  Text('বিস্তারিত লিখুন',
                      style: TextStyle(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                  const SizedBox(height: 9),
                  TextField(
                    controller: _messageCtrl,
                    maxLines: 5,
                    minLines: 4,
                    maxLength: 1000,
                    enabled: !isSubmitting,
                    onChanged: (_) {
                      if (_localError != null)
                        setState(() => _localError = null);
                    },
                    style: TextStyle(
                        color: context.colors.textPrimary, fontSize: 13.5),
                    decoration: InputDecoration(
                      hintText:
                          'অ্যাপ ব্যবহার করে কেমন লাগছে, কী উন্নতি করা যায়, বা কোনো সমস্যা হলে লিখুন…',
                      hintStyle: TextStyle(
                          color: context.colors.textHint, fontSize: 12.5),
                      filled: true,
                      fillColor: context.colors.bg,
                      counterStyle: TextStyle(
                          color: context.colors.textHint, fontSize: 10.5),
                      contentPadding: const EdgeInsets.all(13),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: BorderSide(color: context.colors.border)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: BorderSide(color: context.colors.border)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: BorderSide(
                              color: context.colors.darkGreen, width: 1.4)),
                    ),
                  ),

                  if (_localError != null || state.error != null) ...[
                    const SizedBox(height: 8),
                    Row(children: [
                      Icon(Icons.error_outline_rounded,
                          size: 14, color: context.colors.red),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(_localError ?? state.error ?? '',
                            style: TextStyle(
                                color: context.colors.red, fontSize: 12)),
                      ),
                    ]),
                  ],

                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.darkGreen,
                        disabledBackgroundColor:
                            context.colors.darkGreen.withOpacity(0.5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.2, color: Colors.white),
                            )
                          : const Text('পাঠিয়ে দিন',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.5)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .slideY(begin: 0.06, duration: 220.ms, curve: Curves.easeOut)
        .fadeIn(duration: 200.ms);
  }
}
