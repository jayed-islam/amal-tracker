import 'package:amal_tracker/features/challenge/model/challenge_model.dart';
import 'package:amal_tracker/features/challenge/provider/challenge_provider.dart';
import 'package:amal_tracker/features/challenge/widgets/challenge_surah_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

/// progress-update bottom sheet খোলার হেল্পার। সফল আপডেট হলে true রিটার্ন
/// করে (caller চাইলে celebration snackbar/dialog দেখাতে পারে — এই ফাইলেই
/// "মাশাআল্লাহ" celebration দেখানো হয়, তাই caller কে আলাদা কিছু করতে হয় না)।
Future<void> showUpdateProgressSheet(
    BuildContext context, Challenge challenge) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => UpdateProgressSheet(challenge: challenge),
  );
}

class UpdateProgressSheet extends ConsumerStatefulWidget {
  final Challenge challenge;
  const UpdateProgressSheet({super.key, required this.challenge});

  @override
  ConsumerState<UpdateProgressSheet> createState() =>
      _UpdateProgressSheetState();
}

class _UpdateProgressSheetState extends ConsumerState<UpdateProgressSheet> {
  final _addValueCtrl = TextEditingController();
  final _ayahCtrl = TextEditingController();
  int? _selectedSurah;
  bool _showPositionOverride = false;
  String? _localError;

  @override
  void dispose() {
    _addValueCtrl.dispose();
    _ayahCtrl.dispose();
    super.dispose();
  }

  int get _addValue => int.tryParse(_addValueCtrl.text.trim()) ?? 0;

  ({int surahNumber, int ayahInSurah})? get _livePreview {
    final c = widget.challenge;
    if (!c.isQuranChallenge || _addValue <= 0) return null;
    final current = c.myProgress?.currentValue ?? 0;
    final projected = (current + _addValue).clamp(0, c.targetValue);
    return positionFromCumulativeAyah(projected);
  }

  Future<void> _submit() async {
    setState(() => _localError = null);
    final addValue = _addValue;
    if (addValue < 1) {
      setState(() => _localError = 'কমপক্ষে ১ পরিমাণ লিখুন');
      return;
    }

    final c = widget.challenge;
    final current = c.myProgress?.currentValue ?? 0;
    final maxAllowed = c.targetValue - current;
    if (addValue > maxAllowed) {
      if (maxAllowed <= 0) {
        setState(() => _localError = 'চ্যালেঞ্জটি ইতিমধ্যেই সম্পন্ন হয়েছে!');
      } else {
        setState(() => _localError = 'আপনি সর্বোচ্চ ${_bnNum(maxAllowed)} ${c.unitBn} যোগ করতে পারবেন। (লক্ষ্যমাত্রা: ${_bnNum(c.targetValue)} ${c.unitBn})');
      }
      return;
    }

    int? surahNumber;
    int? ayahInSurah;
    if (widget.challenge.isQuranChallenge && _showPositionOverride) {
      surahNumber = _selectedSurah;
      ayahInSurah = int.tryParse(_ayahCtrl.text.trim());
      if (surahNumber == null || ayahInSurah == null || ayahInSurah < 1) {
        setState(() => _localError = 'সূরা ও আয়াত নম্বর সঠিকভাবে দিন');
        return;
      }
      final maxAyah = surahByNumber(surahNumber).ayahCount;
      if (ayahInSurah > maxAyah) {
        setState(() => _localError = 'এই সূরায় সর্বোচ্চ ${_bnNum(maxAyah)}টি আয়াত আছে');
        return;
      }
    }

    final notifier =
        ref.read(challengeActionProvider(widget.challenge.id).notifier);
    final result = await notifier.updateProgress(
      addValue: addValue,
      surahNumber: surahNumber,
      ayahInSurah: ayahInSurah,
    );

    if (!mounted) return;
    if (!result.success) {
      setState(
          () => _localError = result.errorMessage ?? 'আপডেট ব্যর্থ হয়েছে');
      return;
    }

    HapticFeedback.mediumImpact();
    Navigator.of(context).pop();
    if (result.isJustCompleted) {
      _showCompletionCelebration(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('অগ্রগতি আপডেট হয়েছে',
            style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: context.colors.darkGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  void _showCompletionCelebration(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: context.colors.card,
              borderRadius: BorderRadius.circular(20)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('🎉', style: TextStyle(fontSize: 44)),
            const SizedBox(height: 10),
            Text('মাশাআল্লাহ!',
                style: TextStyle(
                    color: context.colors.darkGreen,
                    fontWeight: FontWeight.w900,
                    fontSize: 20)),
            const SizedBox(height: 6),
            Text('আপনি "${widget.challenge.title}" চ্যালেঞ্জ সম্পন্ন করেছেন!',
                textAlign: TextAlign.center,
                style: TextStyle(color: context.colors.textSec2, fontSize: 13)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.darkGreen,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text('আলহামদুলিল্লাহ',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _showSurahSelectionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SurahSelectionSheet(
        initialSelectedSurah: _selectedSurah,
        onSelected: (surahNum) {
          setState(() {
            _selectedSurah = surahNum;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.challenge;
    final actionState = ref.watch(challengeActionProvider(c.id));
    final isSubmitting = actionState.isLoading;
    final preview = _livePreview;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.pageBg,
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
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                        color: context.colors.border,
                        borderRadius: BorderRadius.circular(99)),
                  ),
                ),
                Text('অগ্রগতি আপডেট করুন',
                    style: TextStyle(
                        color: context.colors.textPri,
                        fontWeight: FontWeight.w800,
                        fontSize: 17)),
                const SizedBox(height: 3),
                Text(c.title,
                    style: TextStyle(
                        color: context.colors.textSec2, fontSize: 12.5)),
                const SizedBox(height: 18),

                // ── addValue input ──────────────────────────────────────
                Text(
                    c.isQuranChallenge
                        ? 'আজ কতটুকু আয়াত পড়লেন?'
                        : 'কতটুকু যোগ করবেন?',
                    style: TextStyle(
                        color: context.colors.textPri,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
                const SizedBox(height: 8),
                TextField(
                  controller: _addValueCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) => setState(() {}),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: context.colors.textPri),
                  decoration: InputDecoration(
                    hintText: '0',
                    suffixText: c.unitBn,
                    suffixStyle:
                        TextStyle(color: context.colors.textHint, fontSize: 13),
                    filled: true,
                    fillColor: context.colors.card,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: context.colors.border)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: context.colors.border)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: context.colors.midGreen, width: 1.4)),
                  ),
                ),

                if (preview != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                        color: context.colors.purpleLight,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [
                      Icon(Icons.auto_awesome_rounded,
                          size: 14, color: context.colors.purple),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                            'অনুমানিত অবস্থান: সূরা ${surahByNumber(preview.surahNumber).name}, আয়াত ${_bnNum(preview.ayahInSurah)}',
                            style: TextStyle(
                                color: context.colors.purple,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600)),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => setState(() {
                      _showPositionOverride = !_showPositionOverride;
                      if (_showPositionOverride) {
                        _selectedSurah ??= preview.surahNumber;
                        _ayahCtrl.text = preview.ayahInSurah.toString();
                      }
                    }),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                          _showPositionOverride
                              ? 'অবস্থান ঠিক আছে (লুকান)'
                              : 'সঠিক না হলে অবস্থান নিজে ঠিক করুন',
                          style: TextStyle(
                              color: context.colors.midGreen,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline)),
                    ),
                  ),
                ],

                if (c.isQuranChallenge && _showPositionOverride) ...[
                  const SizedBox(height: 6),
                  Row(children: [
                    Expanded(
                      flex: 3,
                      child: _SurahSelectorButton(
                        selectedSurahNumber: _selectedSurah,
                        onTap: _showSurahSelectionSheet,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _ayahCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          hintText: 'আয়াত #',
                          filled: true,
                          fillColor: context.colors.card,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: context.colors.border)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: context.colors.border)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: context.colors.midGreen, width: 1.4)),
                        ),
                      ),
                    ),
                  ]),
                ],

                if (_localError != null) ...[
                  const SizedBox(height: 10),
                  Text(_localError!,
                      style:
                          TextStyle(color: context.colors.red, fontSize: 12)),
                ],

                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.darkGreen,
                      disabledBackgroundColor:
                          context.colors.darkGreen.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.2, color: Colors.white))
                        : const Text('আপডেট করুন',
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
    );
  }
}

class _SurahSelectorButton extends StatelessWidget {
  final int? selectedSurahNumber;
  final VoidCallback onTap;

  const _SurahSelectorButton({
    required this.selectedSurahNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final surahName = selectedSurahNumber != null
        ? '${_bnNum(selectedSurahNumber!)}. ${surahByNumber(selectedSurahNumber!).name}'
        : 'সূরা';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                surahName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selectedSurahNumber != null
                      ? context.colors.textPri
                      : context.colors.textHint,
                  fontSize: 12.5,
                  fontWeight: selectedSurahNumber != null
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
            Icon(
              Icons.expand_more_rounded,
              size: 18,
              color: context.colors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}

class _SurahSelectionSheet extends StatefulWidget {
  final int? initialSelectedSurah;
  final ValueChanged<int> onSelected;

  const _SurahSelectionSheet({
    required this.initialSelectedSurah,
    required this.onSelected,
  });

  @override
  State<_SurahSelectionSheet> createState() => _SurahSelectionSheetState();
}

class _SurahSelectionSheetState extends State<_SurahSelectionSheet> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSurahs = kSurahs.where((s) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return s.number.toString() == q ||
          s.name.toLowerCase().contains(q) ||
          s.number.toString().contains(q);
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: context.colors.pageBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                    color: context.colors.border,
                    borderRadius: BorderRadius.circular(99)),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                'সূরা নির্বাচন করুন',
                style: TextStyle(
                  color: context.colors.textPri,
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Search Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (val) => setState(() => _query = val),
                style: TextStyle(color: context.colors.textPri, fontSize: 13.5),
                decoration: InputDecoration(
                  hintText: 'সূরা খুঁজুন (যেমন: আল-বাকারা বা ২)...',
                  prefixIcon: Icon(Icons.search_rounded, color: context.colors.textHint, size: 18),
                  suffixIcon: _query.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchCtrl.clear();
                            setState(() => _query = '');
                          },
                          child: Icon(Icons.clear_rounded, color: context.colors.textHint, size: 18),
                        )
                      : null,
                  filled: true,
                  fillColor: context.colors.card,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: context.colors.border, width: 0.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: context.colors.border, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: context.colors.midGreen, width: 1.2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                itemCount: filteredSurahs.length,
                itemBuilder: (context, index) {
                  final s = filteredSurahs[index];
                  final isSelected = s.number == widget.initialSelectedSurah;
                  return GestureDetector(
                    onTap: () {
                      widget.onSelected(s.number);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? context.colors.greenLight : context.colors.card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? context.colors.darkGreen.withOpacity(0.3) : context.colors.border,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: isSelected ? context.colors.darkGreen : context.colors.pageBg,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _bnNum(s.number),
                                style: TextStyle(
                                  color: isSelected ? Colors.white : context.colors.textPri,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  s.name,
                                  style: TextStyle(
                                    color: context.colors.textPri,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  '${_bnNum(s.ayahCount)}টি আয়াত',
                                  style: TextStyle(
                                    color: context.colors.textHint,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_circle_rounded, color: context.colors.darkGreen, size: 18),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _bnNum(int n) {
  const d = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
  return n.toString().split('').map((c) => d[int.parse(c)]).join();
}
