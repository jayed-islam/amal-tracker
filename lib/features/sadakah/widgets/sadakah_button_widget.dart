import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';
import 'package:amal_tracker/core/router/app_router.dart';

class SadakahButtonWidget extends StatelessWidget {
  const SadakahButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.sadaqah),
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
