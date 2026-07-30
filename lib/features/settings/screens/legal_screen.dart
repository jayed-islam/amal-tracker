import 'package:amal_tracker/features/settings/constants/legal_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amal_tracker/core/theme/app_colors.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

// ── Design Tokens ────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────
// UNIFIED LEGAL SCREEN (Privacy Policy & Terms of Use on One Page)
// ─────────────────────────────────────────────────────────────────────────────

class LegalScreen extends StatefulWidget {
  const LegalScreen({super.key});

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  Lang _lang = Lang.bn;

  bool get _isBn => _lang == Lang.bn;

  String get _screenTitle => _isBn ? 'আইনি তথ্যাবলী' : 'Legal Information';

  String get _privacyTitle => _isBn ? '১. গোপনীয়তা নীতি' : '1. Privacy Policy';
  String get _termsTitle => _isBn ? '২. ব্যবহারের শর্তাবলী' : '2. Terms of Use';

  void _toggleLang() {
    HapticFeedback.selectionClick();
    setState(() => _lang = _isBn ? Lang.en : Lang.bn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bg,
      appBar: AppBar(
        backgroundColor: context.colors.darkGreen,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
        title: Text(
          _screenTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _toggleLang,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.white.withOpacity(0.18),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LangPill(label: 'বাং', active: _isBn),
                  const SizedBox(width: 2),
                  _LangPill(label: 'EN', active: !_isBn),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          // ── Metadata Header ────────────────────────────────────────────────
          Text(
            kLegalLastUpdated[_lang]!,
            style: TextStyle(
              color: context.colors.textHint,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),

          // ── Segment 1: Privacy Policy ──────────────────────────────────────
          Text(
            _privacyTitle,
            style: TextStyle(
              color: context.colors.darkGreen,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            kPrivacyIntro[_lang]!,
            style: TextStyle(
              color: context.colors.textBody,
              fontSize: 14,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 20),
          ...kPrivacySections.map((section) => _SectionBlock(
                section: section,
                lang: _lang,
              )),

          const SizedBox(height: 16),
          Divider(color: context.colors.divider, thickness: 1.5, height: 1),
          const SizedBox(height: 32),

          // ── Segment 2: Terms of Use ────────────────────────────────────────
          Text(
            _termsTitle,
            style: TextStyle(
              color: context.colors.darkGreen,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            kTermsIntro[_lang]!,
            style: TextStyle(
              color: context.colors.textBody,
              fontSize: 14,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 20),
          ...kTermsSections.map((section) => _SectionBlock(
                section: section,
                lang: _lang,
              )),

          // ── Footer ─────────────────────────────────────────────────────────
          const SizedBox(height: 16),
          Divider(color: context.colors.divider, height: 1),
          const SizedBox(height: 24),
          Text(
            _isBn
                ? 'প্রশ্ন বা মতামতের জন্য যোগাযোগ করুন:'
                : 'For questions or feedback, contact us:',
            style: TextStyle(
              color: context.colors.textMuted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'support@amaltracker.app',
            style: TextStyle(
              color: context.colors.darkGreen,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION BLOCK
// ─────────────────────────────────────────────────────────────────────────────

class _SectionBlock extends StatelessWidget {
  final LegalSection section;
  final Lang lang;

  const _SectionBlock({required this.section, required this.lang});

  @override
  Widget build(BuildContext context) {
    final points = section.points[lang]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title[lang]!,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          ...points.map((p) => _PointRow(point: p)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// POINT ROW
// ─────────────────────────────────────────────────────────────────────────────

class _PointRow extends StatelessWidget {
  final LegalPoint point;
  const _PointRow({required this.point});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: context.colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: context.colors.textBody,
                  fontSize: 13.5,
                  height: 1.65,
                ),
                children: [
                  if (point.heading != null) ...[
                    TextSpan(
                      text: '${point.heading} ',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ],
                  TextSpan(text: point.body),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LANGUAGE PILL
// ─────────────────────────────────────────────────────────────────────────────

class _LangPill extends StatelessWidget {
  final String label;
  final bool active;
  const _LangPill({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? context.colors.darkGreen : Colors.white.withOpacity(0.65),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
