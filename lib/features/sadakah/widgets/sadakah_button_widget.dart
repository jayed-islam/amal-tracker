import 'package:flutter/material.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';
import '../screens/sadakah_screen.dart';

class SadakahButtonWidget extends StatelessWidget {
  const SadakahButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showSadaqahSheet(context),
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: context.colors.bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: context.colors.border,
            width: 0.5,
          ),
        ),
        child: Icon(
          Icons.volunteer_activism_rounded,
          color: context.colors.textMuted,
          size: 18,
        ),
      ),
    );
  }
}
