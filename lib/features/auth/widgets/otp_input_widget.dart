import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

class OtpInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;
  final bool disabled;
  final bool hasError;
  final int length;

  const OtpInputWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onCompleted,
    this.disabled = false,
    this.hasError = false,
    this.length = 6,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 46,
      height: 54,
      textStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: hasError ? context.colors.red : context.colors.textPri,
      ),
      decoration: BoxDecoration(
        color: context.colors.inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasError ? context.colors.red : context.colors.border,
          width: hasError ? 1.8 : 1.0,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: context.colors.greenLight.withOpacity(0.3),
        border: Border.all(
          color: hasError ? context.colors.red : context.colors.green,
          width: 1.8,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.green.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(
          color: hasError ? context.colors.red : context.colors.darkGreen,
          width: 1.0,
        ),
      ),
    );

    final disabledPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: context.colors.inputBg.withOpacity(0.5),
      ),
    );

    return Pinput(
      length: length,
      controller: controller,
      enabled: !disabled,
      autofocus: true,
      keyboardType: TextInputType.number,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      disabledPinTheme: disabledPinTheme,
      forceErrorState: hasError,
      errorPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration?.copyWith(
          border: Border.all(color: context.colors.red, width: 1.8),
        ),
      ),
      onChanged: onChanged,
      onCompleted: onCompleted,
      hapticFeedbackType: HapticFeedbackType.lightImpact,
    );
  }
}
