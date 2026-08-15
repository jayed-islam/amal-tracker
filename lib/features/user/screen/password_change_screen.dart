import 'package:amal_tracker/features/user/widgets/app_silver_bar.dart';
import 'package:amal_tracker/features/user/widgets/universal_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';

// ─────────────────────────────────────────────────────────────
// TOKENS  (unchanged)
// ─────────────────────────────────────────────────────────────
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

// ─────────────────────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────────────────────
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _State();
}

class _State extends ConsumerState<ChangePasswordScreen> {
  final _curCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _conCtrl = TextEditingController();
  final _curFocus = FocusNode();
  final _newFocus = FocusNode();
  final _conFocus = FocusNode();

  String? _curErr, _newErr, _conErr;
  bool _saving = false;
  int _score = 0;
  String _strengthLabel = '';
  late Color _strengthColor = context.colors
      .textHint; // dead default; live value set via context in _onNewChanged

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _newCtrl.addListener(_onNewChanged);
    for (final f in [_curFocus, _newFocus, _conFocus]) {
      f.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (final c in [_curCtrl, _newCtrl, _conCtrl]) c.dispose();
    for (final f in [_curFocus, _newFocus, _conFocus]) f.dispose();
    super.dispose();
  }

  void _onNewChanged() {
    final p = _newCtrl.text;
    int s = 0;
    if (p.length >= 8) s++;
    if (RegExp(r'[A-Z]').hasMatch(p)) s++;
    if (RegExp(r'[0-9]').hasMatch(p)) s++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(p)) s++;
    final (lbl, col) = switch (s) {
      0 || 1 => ('দুর্বল', context.colors.red),
      2 => ('মধ্যম', context.colors.amber),
      3 => ('ভালো', context.colors.green),
      _ => ('শক্তিশালী', context.colors.darkGreen),
    };
    if (_newErr != null) _valNew(p);
    setState(() {
      _score = s;
      _strengthLabel = p.isEmpty ? '' : lbl;
      _strengthColor = col;
    });
  }

  void _valCur(String v) => setState(
      () => _curErr = v.trim().isEmpty ? 'বর্তমান পাসওয়ার্ড দিন' : null);

  void _valNew(String v) => setState(() {
        if (v.isEmpty)
          _newErr = 'নতুন পাসওয়ার্ড দিন';
        else if (v.length < 8)
          _newErr = 'কমপক্ষে ৮ অক্ষর হতে হবে';
        else if (v == _curCtrl.text && v.isNotEmpty)
          _newErr = 'পুরানো পাসওয়ার্ডের মতো হতে পারবে না';
        else
          _newErr = null;
        if (_conCtrl.text.isNotEmpty)
          _conErr = _conCtrl.text != v ? 'পাসওয়ার্ড মিলছে না' : null;
      });

  void _valCon(String v) => setState(
      () => _conErr = v != _newCtrl.text ? 'পাসওয়ার্ড মিলছে না' : null);

  bool _validateAll() {
    _valCur(_curCtrl.text);
    _valNew(_newCtrl.text);
    _valCon(_conCtrl.text);
    return _curCtrl.text.trim().isNotEmpty &&
        _newCtrl.text.length >= 8 &&
        _newCtrl.text != _curCtrl.text &&
        _conCtrl.text == _newCtrl.text;
  }

  bool get _canSubmit =>
      _curCtrl.text.trim().isNotEmpty &&
      _newCtrl.text.length >= 8 &&
      _newCtrl.text != _curCtrl.text &&
      _conCtrl.text == _newCtrl.text &&
      _curErr == null &&
      _newErr == null &&
      _conErr == null;

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_validateAll()) {
      HapticFeedback.vibrate();
      return;
    }
    setState(() => _saving = true);
    HapticFeedback.mediumImpact();
    final ok = await ref.read(authProvider.notifier).changePassword(
          _curCtrl.text.trim(),
          _newCtrl.text.trim(),
        );
    setState(() => _saving = false);
    if (!mounted) return;
    if (ok) {
      HapticFeedback.selectionClick();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Row(children: [
          Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'পাসওয়ার্ড পরিবর্তন সফল হয়েছে! নিরাপত্তার জন্য অন্যান্য ডিভাইস থেকে লগআউট করা হয়েছে।',
              style: TextStyle(fontSize: 12.5),
            ),
          ),
        ]),
        backgroundColor: context.colors.darkGreen,
        margin: const EdgeInsets.all(16),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ));
      context.pop();
    } else {
      setState(() => _curErr =
          ref.read(authProvider).error ?? 'বর্তমান পাসওয়ার্ড ভুল হয়েছে');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isTablet = mq.size.width > 600;
    final hPad = isTablet ? (mq.size.width - 600) / 2 + 20.0 : 20.0;

    return Scaffold(
      backgroundColor: context.colors.bg,
      bottomNavigationBar:
          _SubmitBar(saving: _saving, canSubmit: _canSubmit, onTap: _save),
      body: CustomScrollView(
        controller: _scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        slivers: [
          AppSliverBar(
            scrollController: _scrollController,
            title: 'পাসওয়ার্ড পরিবর্তন',
            subtitle: 'নিরাপদ থাকতে নিয়মিত পরিবর্তন করুন',
            icon: Icons.lock_reset_rounded,
            color: context.colors.darkGreen,
          ),

          // ── body ──────────────────────────────────────────
          SliverPadding(
            padding:
                EdgeInsets.fromLTRB(hPad, 24, hPad, mq.padding.bottom + 24),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── 3 password fields inside one card ─────
                  _FormSection(
                    children: [
                      // 1. Current password
                      UniversalField(
                        label: 'বর্তমান পাসওয়ার্ড',
                        hint: 'বর্তমান পাসওয়ার্ড লিখুন',
                        controller: _curCtrl,
                        focusNode: _curFocus,
                        nextFocus: _newFocus,
                        type: FieldType.password,
                        error: _curErr,
                        onChanged: _valCur,
                      ),

                      // 2. New password
                      UniversalField(
                        label: 'নতুন পাসওয়ার্ড',
                        hint: 'নতুন পাসওয়ার্ড লিখুন',
                        controller: _newCtrl,
                        focusNode: _newFocus,
                        nextFocus: _conFocus,
                        type: FieldType.password,
                        error: _newErr,
                        onChanged: _valNew,
                      ),

                      // // strength bar — expands inside the card
                      // AnimatedSize(
                      //   duration: 260.ms,
                      //   curve: Curves.easeOut,
                      //   alignment: Alignment.topCenter,
                      //   child: hasNew
                      //       ? _StrengthBar(
                      //           score: _score,
                      //           label: _strengthLabel,
                      //           color: _strengthColor,
                      //           password: _newCtrl.text,
                      //         )
                      //       : const SizedBox.shrink(),
                      // ),

                      // 3. Confirm password
                      UniversalField(
                        label: 'নতুন পাসওয়ার্ড নিশ্চিত করুন',
                        hint: 'পাসওয়ার্ড আবার লিখুন',
                        controller: _conCtrl,
                        focusNode: _conFocus,
                        type: FieldType.password,
                        error: _conErr,
                        onChanged: _valCon,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _save(),
                        trailingStatus:
                            _conCtrl.text.isNotEmpty && _conErr == null
                                ? FieldStatus.match
                                : _conErr != null
                                    ? FieldStatus.error
                                    : FieldStatus.none,
                      ),
                    ],
                  ).animate().fadeIn(delay: 60.ms, duration: 280.ms),

                  const SizedBox(height: 20),

                  _TipsCard().animate().fadeIn(delay: 140.ms, duration: 280.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// FIELD GROUP CARD  (unchanged)
// ─────────────────────────────────────────────────────────────

class _FormSection extends StatelessWidget {
  final String? label;
  final List<Widget> children;

  const _FormSection({this.label, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 8),
            child: Text(
              label!.toUpperCase(),
              style: TextStyle(
                color: context.colors.textHint,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.7,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colors.border, width: 0.5),
          ),
          child: Column(
            children: List.generate(children.length, (i) {
              return Column(
                children: [
                  children[i],
                  if (i < children.length - 1)
                    Divider(
                        height: 0.5,
                        thickness: 0.5,
                        color: context.colors.border,
                        indent: 52),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _CardDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Divider(
      height: 0.5, thickness: 0.5, color: context.colors.border, indent: 16);
}

// ─────────────────────────────────────────────────────────────
// FIELD STATUS ENUM
// ─────────────────────────────────────────────────────────────
enum _FieldStatus { none, match, error }

// ─────────────────────────────────────────────────────────────
// STRENGTH BAR  (unchanged)
// ─────────────────────────────────────────────────────────────
class _StrengthBar extends StatelessWidget {
  final int score;
  final String label, password;
  final Color color;

  const _StrengthBar({
    required this.score,
    required this.label,
    required this.color,
    required this.password,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child: Row(
                  children: List.generate(
                      4,
                      (i) => Expanded(
                            child: AnimatedContainer(
                              duration: 220.ms,
                              height: 4,
                              margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                              decoration: BoxDecoration(
                                color:
                                    i < score ? color : context.colors.border,
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                          )),
                ),
              ),
              const SizedBox(width: 10),
              AnimatedDefaultTextStyle(
                duration: 200.ms,
                style: TextStyle(
                    color: color, fontSize: 11, fontWeight: FontWeight.w700),
                child: Text(label),
              ),
            ]),
            const SizedBox(height: 10),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: [
                _Chip(label: '৮+ অক্ষর', met: password.length >= 8),
                _Chip(
                    label: 'বড় হাতের অক্ষর',
                    met: RegExp(r'[A-Z]').hasMatch(password)),
                _Chip(
                    label: 'সংখ্যা', met: RegExp(r'[0-9]').hasMatch(password)),
                _Chip(
                    label: 'বিশেষ চিহ্ন',
                    met: RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)),
              ],
            ),
          ],
        ),
      );
}

class _Chip extends StatelessWidget {
  final String label;
  final bool met;
  const _Chip({required this.label, required this.met});

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: met ? context.colors.greenLight : context.colors.bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: met
                  ? context.colors.green.withOpacity(0.35)
                  : context.colors.border),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          AnimatedSwitcher(
            duration: 150.ms,
            child: Icon(
              met ? Icons.check_rounded : Icons.remove_rounded,
              key: ValueKey(met),
              size: 11,
              color: met ? context.colors.green : context.colors.textHint,
            ),
          ),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                color: met ? context.colors.darkGreen : context.colors.textHint,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              )),
        ]),
      );
}

// ─────────────────────────────────────────────────────────────
// TIPS CARD  (unchanged)
// ─────────────────────────────────────────────────────────────
class _TipsCard extends StatelessWidget {
  const _TipsCard();

  static const _tips = [
    'কমপক্ষে ৮টি অক্ষর ব্যবহার করুন',
    r'সংখ্যা ও বিশেষ চিহ্ন (!@#$) যোগ করুন',
    'নিজের নাম বা জন্মতারিখ ব্যবহার করবেন না',
    'আগের পাসওয়ার্ড পুনরায় ব্যবহার করবেন না',
  ];

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.colors.goldLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: context.colors.gold.withOpacity(0.35), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: context.colors.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.lightbulb_rounded,
                    color: context.colors.gold, size: 14),
              ),
              const SizedBox(width: 8),
              const Text('শক্তিশালী পাসওয়ার্ডের নিয়ম',
                  style: TextStyle(
                    color: Color(0xFF78350F),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  )),
            ]),
            const SizedBox(height: 10),
            ..._tips.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.only(top: 6, right: 8),
                        decoration: BoxDecoration(
                            color: context.colors.gold, shape: BoxShape.circle),
                      ),
                      Expanded(
                        child: Text(t,
                            style: TextStyle(
                              color: context.colors.ambalText,
                              fontSize: 12,
                              height: 1.45,
                            )),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      );
}

// ─────────────────────────────────────────────────────────────
// SUBMIT BAR  (unchanged)
// ─────────────────────────────────────────────────────────────
class _SubmitBar extends StatelessWidget {
  final bool saving, canSubmit;
  final VoidCallback onTap;
  const _SubmitBar({
    required this.saving,
    required this.canSubmit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: context.colors.card,
          border:
              Border(top: BorderSide(color: context.colors.border, width: 0.5)),
        ),
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          MediaQuery.of(context).padding.bottom + 12,
        ),
        child: GestureDetector(
          onTap: saving || !canSubmit ? null : onTap,
          child: AnimatedContainer(
            duration: 200.ms,
            height: 54,
            decoration: BoxDecoration(
              color: saving
                  ? context.colors.darkGreen.withOpacity(0.6)
                  : canSubmit
                      ? context.colors.darkGreen
                      : context.colors.darkGreen.withOpacity(0.35),
              borderRadius: BorderRadius.circular(16),
              boxShadow: canSubmit && !saving
                  ? [
                      BoxShadow(
                        color: context.colors.darkGreen.withOpacity(0.22),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      )
                    ]
                  : [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: saving
                  ? const [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      ),
                      SizedBox(width: 10),
                      Text('সংরক্ষণ হচ্ছে...',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                    ]
                  : [
                      Icon(
                        canSubmit
                            ? Icons.lock_rounded
                            : Icons.lock_outline_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text('পাসওয়ার্ড পরিবর্তন করুন',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          )),
                    ],
            ),
          ),
        ),
      );
}
