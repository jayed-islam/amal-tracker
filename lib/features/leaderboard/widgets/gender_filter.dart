import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';
// ─────────────────────────────────────────────────────────────────────────────
// GENDER FILTER CHIPS
// ─────────────────────────────────────────────────────────────────────────────

class GenderFilterChips extends StatelessWidget {
  final String? selected; // "male" | "female" | null
  final ValueChanged<String?> onChanged;

  const GenderFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.cardBg,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(
              children: [
                // Label
                Text(
                  'দেখাচ্ছে:',
                  style: TextStyle(
                    color: context.colors.textHint,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),

                // ছেলে chip
                _GenderChip(
                  label: '👨 ছেলেদের',
                  value: 'male',
                  selected: selected,
                  activeColor: context.colors.blue,
                  activeBg: context.colors.blueLight,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    // same tap করলে toggle off (সবাই দেখাবে)
                    onChanged(selected == 'male' ? null : 'male');
                  },
                ),

                const SizedBox(width: 8),

                // মেয়ে chip
                _GenderChip(
                  label: '👩 মেয়েদের',
                  value: 'female',
                  selected: selected,
                  activeColor: context.colors.purple,
                  activeBg: context.colors.purpleLight,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onChanged(selected == 'female' ? null : 'female');
                  },
                ),

                const Spacer(),

                // Total count indicator
                if (selected != null)
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onChanged(null); // সবাই দেখাও
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.colors.pageBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: context.colors.border, width: 0.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.close_rounded,
                              size: 10, color: context.colors.textHint),
                          SizedBox(width: 3),
                          Text(
                            'সবাই',
                            style: TextStyle(
                              color: context.colors.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 0.5, thickness: 0.5, color: context.colors.border),
        ],
      ),
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String label;
  final String value;
  final String? selected;
  final Color activeColor;
  final Color activeBg;
  final VoidCallback onTap;

  const _GenderChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.activeColor,
    required this.activeBg,
    required this.onTap,
  });

  bool get isActive => selected == value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? activeBg : context.colors.pageBg,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: isActive ? activeColor : context.colors.border,
            width: isActive ? 1.5 : 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? activeColor : context.colors.textSecondary,
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
