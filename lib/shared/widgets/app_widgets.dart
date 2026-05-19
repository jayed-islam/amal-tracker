import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';

// ─── App Text Field ────────────────────────────────────────────────────────────

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final bool readOnly;
  final int maxLines;
  final FocusNode? focusNode;
  final bool autofocus;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffix,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.readOnly = false,
    this.maxLines = 1,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;
  bool _isFocused = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(() {
      setState(() => _isFocused = widget.focusNode?.hasFocus ?? false);
    });
  }

  void _validate(String value) {
    if (widget.validator != null) {
      setState(() => _error = widget.validator!(value));
    }
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _error != null && _error!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: hasError
                      ? AppColors.error
                      : _isFocused
                          ? AppColors.primary
                          : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),

        // Field
        AnimatedContainer(
          duration: 200.ms,
          decoration: BoxDecoration(
            borderRadius: AppRadius.md_,
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: hasError
                          ? AppColors.error.withOpacity(0.12)
                          : AppColors.primary.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            obscureText: widget.isPassword && _obscure,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onEditingComplete: widget.onEditingComplete,
            readOnly: widget.readOnly,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            autofocus: widget.autofocus,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
            onChanged: _validate,
            onTap: () => setState(() => _isFocused = true),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.textHint,
                    fontWeight: FontWeight.w400,
                  ),
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Icon(widget.prefixIcon,
                          size: 20,
                          color: hasError
                              ? AppColors.error
                              : _isFocused
                                  ? AppColors.primary
                                  : AppColors.textSecondary),
                    )
                  : null,
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 52, minHeight: 52),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                        color: _isFocused
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    )
                  : widget.suffix,
              filled: true,
              fillColor: hasError
                  ? AppColors.error.withOpacity(0.04)
                  : _isFocused
                      ? AppColors.surface
                      : AppColors.surfaceAlt,
              border: OutlineInputBorder(
                borderRadius: AppRadius.md_,
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.md_,
                borderSide: BorderSide(
                  color: hasError
                      ? AppColors.error.withOpacity(0.5)
                      : AppColors.border,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.md_,
                borderSide: BorderSide(
                  color: hasError ? AppColors.error : AppColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: AppRadius.md_,
                borderSide: const BorderSide(color: AppColors.error),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              error: const SizedBox.shrink(), // Hide default error, show custom
            ),
          ),
        ),

        // Custom error
        AnimatedSize(
          duration: 200.ms,
          child: hasError
              ? Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.error_rounded,
                          size: 13, color: AppColors.error),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          _error!,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  void clearError() => setState(() => _error = null);
  String? get error => _error;
}

// ─── App Button ────────────────────────────────────────────────────────────────

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;
  final Color? color;
  final Color? textColor;
  final double height;
  final double? width;
  final double borderRadius;
  final EdgeInsets? padding;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.color,
    this.textColor,
    this.height = 54,
    this.width,
    this.borderRadius = 14,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.primary;
    final fg = textColor ?? Colors.white;

    return AnimatedContainer(
      duration: 150.ms,
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        gradient: isOutlined
            ? null
            : LinearGradient(
                colors: [bg, Color.lerp(bg, Colors.white, 0.12)!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: isOutlined ? Border.all(color: bg, width: 1.5) : null,
        boxShadow: isOutlined || onPressed == null
            ? []
            : [
                BoxShadow(
                    color: bg.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6)),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: Colors.white.withOpacity(0.15),
          highlightColor: Colors.white.withOpacity(0.08),
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(
                          isOutlined ? bg : fg,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, size: 20, color: isOutlined ? bg : fg),
                          const SizedBox(width: 8),
                        ],
                        Text(label,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: isOutlined ? bg : fg,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                )),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Auth Divider ─────────────────────────────────────────────────────────────

class AuthDivider extends StatelessWidget {
  final String label;
  const AuthDivider({super.key, this.label = 'অথবা'});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(label,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: AppColors.textTertiary)),
          ),
          const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
        ],
      );
}

// ─── Section Header ───────────────────────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader(
      {super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.gold, AppColors.primary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w700)),
          ),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(action!,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
        ],
      );
}

// ─── Stat Card ────────────────────────────────────────────────────────────────

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppRadius.lg_,
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: AppRadius.sm_,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(value,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                    )),
            const SizedBox(height: 2),
            Text(label,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: color.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    )),
          ],
        ),
      );
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? action;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryPale,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primaryLight, size: 40),
              ),
              const SizedBox(height: 20),
              Text(title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppColors.textSecondary)),
              if (action != null) ...[
                const SizedBox(height: 24),
                AppButton(
                    onPressed: onAction,
                    label: action!,
                    width: 180,
                    height: 46),
              ],
            ],
          ),
        ),
      );
}

// ─── Loading Shimmer ──────────────────────────────────────────────────────────

class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: 1200.ms)..repeat();
    _anim = Tween<double>(begin: -2, end: 2)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_anim.value - 1, 0),
              end: Alignment(_anim.value + 1, 0),
              colors: [
                AppColors.divider,
                AppColors.border.withOpacity(0.5),
                AppColors.divider,
              ],
            ),
          ),
        ),
      );
}
