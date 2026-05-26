import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

enum FieldType {
  password, // obscure toggle, strength bar if label == new
  phone, // numeric keyboard, BD validation
  text, // plain text
  email, // email keyboard, basic @ validation
  number, // numeric only
}

enum FieldStatus { none, match, error }

class _C {
  static const bg = Color(0xFFF4F6F1);
  static const card = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const midGreen = Color(0xFF1B7045);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const gold = Color(0xFFD4A843);
  static const red = Color(0xFFE53935);
  static const amber = Color(0xFFF59E0B);
  static const border = Color(0xFFE2E8E2);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFB0BDB2);
}

class UniversalField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final FieldType type;
  final String? error;
  final ValueChanged<String> onChanged;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final FieldStatus trailingStatus;

  const UniversalField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.nextFocus,
    this.type = FieldType.text,
    this.error,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.trailingStatus = FieldStatus.none,
  });

  @override
  State<UniversalField> createState() => UniversalFieldState();
}

class UniversalFieldState extends State<UniversalField> {
  bool _obscure = true;

  bool get _focused => widget.focusNode.hasFocus;

  TextInputType get _keyboard => switch (widget.type) {
        FieldType.phone => TextInputType.phone,
        FieldType.email => TextInputType.emailAddress,
        FieldType.number => TextInputType.number,
        FieldType.password => TextInputType.visiblePassword,
        FieldType.text => TextInputType.text,
      };

  bool get _isObscured => widget.type == FieldType.password && _obscure;

  // ── icon per type ────────────────────────────────────────────
  IconData get _typeIcon => switch (widget.type) {
        FieldType.password =>
          _obscure ? Icons.lock_outline_rounded : Icons.lock_open_rounded,
        FieldType.phone => Icons.phone_outlined,
        FieldType.email => Icons.alternate_email_rounded,
        FieldType.number => Icons.tag_rounded,
        FieldType.text => Icons.edit_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final focused = _focused;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── left icon box ──────────────────────────
          AnimatedContainer(
            duration: 180.ms,
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: focused ? _C.greenLight : _C.bg,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              _typeIcon,
              size: 17,
              color: focused ? _C.darkGreen : _C.textHint,
            ),
          ),

          const SizedBox(width: 12),

          // ── label + input column ───────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // label row — includes trailing match/error badge
                Row(
                  children: [
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: focused ? _C.darkGreen : _C.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    // trailing status badge (confirm field)
                    AnimatedSwitcher(
                      duration: 160.ms,
                      child: switch (widget.trailingStatus) {
                        FieldStatus.match => Row(
                            key: const ValueKey('m'),
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.check_circle_rounded,
                                  color: _C.green, size: 12),
                              SizedBox(width: 3),
                              Text('মিলেছে',
                                  style: TextStyle(
                                      color: _C.green,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        FieldStatus.error => Row(
                            key: const ValueKey('e'),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.error_outline_rounded,
                                  color: _C.red, size: 12),
                              const SizedBox(width: 3),
                              Text(widget.error ?? '',
                                  style: const TextStyle(
                                      color: _C.red,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        FieldStatus.none =>
                          const SizedBox.shrink(key: ValueKey('n')),
                      },
                    ),
                  ],
                ),

                // text input
                Focus(
                  onFocusChange: (_) => setState(() {}),
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    obscureText: _isObscured,
                    keyboardType: _keyboard,
                    onChanged: widget.onChanged,
                    textInputAction: widget.textInputAction,
                    onSubmitted: widget.onSubmitted ??
                        (_) => widget.nextFocus?.requestFocus(),
                    style: const TextStyle(
                      color: _C.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.only(
                          top: 13, bottom: 13, left: 13, right: 13),
                      border: InputBorder.none,
                      hintText: widget.hint,
                      hintStyle: const TextStyle(
                        color: _C.textHint,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),

                // error text (current + new password fields)
                AnimatedSize(
                  duration: 200.ms,
                  curve: Curves.easeOut,
                  alignment: Alignment.topLeft,
                  child: widget.error != null &&
                          widget.trailingStatus == FieldStatus.none
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(widget.error!,
                                    style: const TextStyle(
                                      color: _C.red,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      height: 1.3,
                                    )),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          // ── right visibility toggle (password only) ──
          if (widget.type == FieldType.password)
            GestureDetector(
              onTap: () => setState(() => _obscure = !_obscure),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: AnimatedSwitcher(
                  duration: 160.ms,
                  child: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    key: ValueKey(_obscure),
                    size: 20,
                    color: focused ? _C.darkGreen : _C.textHint,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
