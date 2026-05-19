// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AppColors {
//   AppColors._();

//   // ── Primary (Deep Green - Islamic) ────────────────────────────────────────
//   static const Color primary = Color(0xFF1B5E20);
//   static const Color primaryLight = Color(0xFF2E7D32);
//   static const Color primaryDark = Color(0xFF0A3D13);
//   static const Color primaryContainer = Color(0xFFE8F5E9);

//   // ── Secondary (Gold) ──────────────────────────────────────────────────────
//   static const Color secondary = Color(0xFFD4A017);
//   static const Color secondaryLight = Color(0xFFFFD54F);
//   static const Color secondaryDark = Color(0xFF9E7B00);
//   static const Color secondaryContainer = Color(0xFFFFF8E1);

//   // ── Accent ────────────────────────────────────────────────────────────────
//   static const Color accent = Color(0xFF00695C); // Teal

//   // ── Status ────────────────────────────────────────────────────────────────
//   static const Color success = Color(0xFF388E3C);
//   static const Color warning = Color(0xFFF57C00);
//   static const Color error = Color(0xFFD32F2F);
//   static const Color info = Color(0xFF1976D2);

//   // ── Prayer Modes ──────────────────────────────────────────────────────────
//   static const Color congregation = Color(0xFF1B5E20); // ✔ Green
//   static const Color solo = Color(0xFFF57C00); // / Orange
//   static const Color missed = Color(0xFFEEEEEE); // Empty

//   // ── Neutrals ─────────────────────────────────────────────────────────────
//   static const Color background = Color(0xFFF5F7F5);
//   static const Color surface = Color(0xFFFFFFFF);
//   static const Color surfaceVariant = Color(0xFFF1F4F1);
//   static const Color outline = Color(0xFFE0E5E0);
//   static const Color divider = Color(0xFFEEEEEE);

//   // ── Text ─────────────────────────────────────────────────────────────────
//   static const Color textPrimary = Color(0xFF1A1A1A);
//   static const Color textSecondary = Color(0xFF616161);
//   static const Color textTertiary = Color(0xFF9E9E9E);
//   static const Color textOnPrimary = Color(0xFFFFFFFF);

//   // ── Dark Mode ────────────────────────────────────────────────────────────
//   static const Color darkBackground = Color(0xFF0D1B0E);
//   static const Color darkSurface = Color(0xFF1A2E1C);
//   static const Color darkSurfaceVariant = Color(0xFF243527);
//   static const Color darkOutline = Color(0xFF2D4330);

//   // ── Leaderboard ───────────────────────────────────────────────────────────
//   static const Color gold = Color(0xFFFFD700);
//   static const Color silver = Color(0xFFC0C0C0);
//   static const Color bronze = Color(0xFFCD7F32);

//   // ── Gradients ─────────────────────────────────────────────────────────────
//   static const LinearGradient primaryGradient = LinearGradient(
//     colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   static const LinearGradient headerGradient = LinearGradient(
//     colors: [Color(0xFF0A3D13), Color(0xFF1B5E20), Color(0xFF2E7D32)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   static const LinearGradient goldGradient = LinearGradient(
//     colors: [Color(0xFFFFD700), Color(0xFFFFC107)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );
// }

// class AppTheme {
//   AppTheme._();

//   static ThemeData get light => ThemeData(
//         useMaterial3: true,
//         brightness: Brightness.light,
//         colorScheme: ColorScheme(
//           brightness: Brightness.light,
//           primary: AppColors.primary,
//           onPrimary: AppColors.textOnPrimary,
//           primaryContainer: AppColors.primaryContainer,
//           onPrimaryContainer: AppColors.primaryDark,
//           secondary: AppColors.secondary,
//           onSecondary: AppColors.textOnPrimary,
//           secondaryContainer: AppColors.secondaryContainer,
//           onSecondaryContainer: AppColors.secondaryDark,
//           tertiary: AppColors.accent,
//           onTertiary: Colors.white,
//           tertiaryContainer: const Color(0xFFE0F2F1),
//           onTertiaryContainer: AppColors.accent,
//           error: AppColors.error,
//           onError: Colors.white,
//           errorContainer: const Color(0xFFFFEBEE),
//           onErrorContainer: AppColors.error,
//           background: AppColors.background,
//           onBackground: AppColors.textPrimary,
//           surface: AppColors.surface,
//           onSurface: AppColors.textPrimary,
//           surfaceVariant: AppColors.surfaceVariant,
//           onSurfaceVariant: AppColors.textSecondary,
//           outline: AppColors.outline,
//           outlineVariant: AppColors.divider,
//           shadow: Colors.black12,
//           scrim: Colors.black54,
//           inverseSurface: AppColors.primaryDark,
//           onInverseSurface: Colors.white,
//           inversePrimary: AppColors.primaryLight,
//           surfaceTint: AppColors.primary,
//         ),
//         textTheme: _buildTextTheme(Brightness.light),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           scrolledUnderElevation: 0,
//           centerTitle: true,
//           iconTheme: IconThemeData(color: AppColors.textPrimary),
//           titleTextStyle: TextStyle(
//             color: AppColors.textPrimary,
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//             letterSpacing: -0.3,
//           ),
//         ),
//         cardTheme: CardThemeData(
//           color: AppColors.surface,
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//             side: const BorderSide(color: AppColors.outline, width: 1),
//           ),
//           margin: EdgeInsets.zero,
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.primary,
//             foregroundColor: Colors.white,
//             elevation: 0,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             minimumSize: const Size(double.infinity, 52),
//             textStyle: const TextStyle(
//                 fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.3),
//           ),
//         ),
//         outlinedButtonTheme: OutlinedButtonThemeData(
//           style: OutlinedButton.styleFrom(
//             foregroundColor: AppColors.primary,
//             side: const BorderSide(color: AppColors.primary, width: 1.5),
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             minimumSize: const Size(double.infinity, 52),
//             textStyle:
//                 const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//           ),
//         ),
//         inputDecorationTheme: InputDecorationTheme(
//           filled: true,
//           fillColor: AppColors.surfaceVariant,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: AppColors.outline),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: AppColors.outline),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: AppColors.primary, width: 2),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: AppColors.error, width: 1.5),
//           ),
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           labelStyle: const TextStyle(color: AppColors.textSecondary),
//           hintStyle: const TextStyle(color: AppColors.textTertiary),
//         ),
//         bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//           backgroundColor: AppColors.surface,
//           selectedItemColor: AppColors.primary,
//           unselectedItemColor: AppColors.textTertiary,
//           elevation: 8,
//           type: BottomNavigationBarType.fixed,
//           showSelectedLabels: true,
//           showUnselectedLabels: true,
//           selectedLabelStyle:
//               TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
//           unselectedLabelStyle: TextStyle(fontSize: 11),
//         ),
//         chipTheme: ChipThemeData(
//           backgroundColor: AppColors.surfaceVariant,
//           selectedColor: AppColors.primaryContainer,
//           checkmarkColor: AppColors.primary,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//         ),
//         dividerTheme: const DividerThemeData(
//           color: AppColors.divider,
//           thickness: 1,
//           space: 0,
//         ),
//         scaffoldBackgroundColor: AppColors.background,
//         fontFamily: GoogleFonts.inter().fontFamily,
//       );

//   static TextTheme _buildTextTheme(Brightness brightness) {
//     final color =
//         brightness == Brightness.light ? AppColors.textPrimary : Colors.white;
//     return GoogleFonts.interTextTheme(
//       TextTheme(
//         displayLarge: TextStyle(
//             fontSize: 57,
//             fontWeight: FontWeight.w700,
//             color: color,
//             letterSpacing: -1.5),
//         displayMedium:
//             TextStyle(fontSize: 45, fontWeight: FontWeight.w600, color: color),
//         displaySmall:
//             TextStyle(fontSize: 36, fontWeight: FontWeight.w600, color: color),
//         headlineLarge: TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.w700,
//             color: color,
//             letterSpacing: -0.5),
//         headlineMedium:
//             TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: color),
//         headlineSmall:
//             TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: color),
//         titleLarge: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//             color: color,
//             letterSpacing: -0.3),
//         titleMedium:
//             TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color),
//         titleSmall:
//             TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color),
//         bodyLarge: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             color: color,
//             height: 1.5),
//         bodyMedium: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w400,
//             color: color,
//             height: 1.5),
//         bodySmall: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w400,
//             color: color.withOpacity(0.7),
//             height: 1.4),
//         labelLarge: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: color,
//             letterSpacing: 0.1),
//         labelMedium:
//             TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color),
//         labelSmall: TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w500,
//             color: color.withOpacity(0.7)),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();
  static const Color primary = Color(0xFF1A6B45);
  static const Color primaryDark = Color(0xFF0D4530);
  static const Color primaryLight = Color(0xFF2E8C5F);
  static const Color primaryPale = Color(0xFFE8F5EE);
  static const Color primarySoft = Color(0xFFCCE8D8);
  static const Color gold = Color(0xFFD4A843);
  static const Color goldLight = Color(0xFFF0C96B);
  static const Color goldPale = Color(0xFFFDF6E3);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
  static const Color errorPale = Color(0xFFFEF2F2);
  static const Color info = Color(0xFF2563EB);
  static const Color congregation = Color(0xFF1A6B45);
  static const Color solo = Color(0xFFF59E0B);
  static const Color missed = Color(0xFFE5E7EB);
  static const Color background = Color(0xFFF4F7F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF0F4F1);
  static const Color border = Color(0xFFE2E8E4);
  static const Color divider = Color(0xFFEDF1EF);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textHint = Color(0xFFBEC5C1);
  static const Color rankGold = Color(0xFFFFD700);
  static const Color rankSilver = Color(0xFFB0BEC5);
  static const Color rankBronze = Color(0xFFCD8C4C);

  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFF092E1E), Color(0xFF1A6B45), Color(0xFF2E8C5F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF061810), Color(0xFF0D4530), Color(0xFF1A6B45)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A6B45), Color(0xFF2E8C5F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFD4A843), Color(0xFFF0C96B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppRadius {
  AppRadius._();
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 24;
  static const double xxl = 32;
  static BorderRadius get xs_ => BorderRadius.circular(xs);
  static BorderRadius get sm_ => BorderRadius.circular(sm);
  static BorderRadius get md_ => BorderRadius.circular(md);
  static BorderRadius get lg_ => BorderRadius.circular(lg);
  static BorderRadius get xl_ => BorderRadius.circular(xl);
  static BorderRadius get xxl_ => BorderRadius.circular(xxl);
  static BorderRadius get full => BorderRadius.circular(999);
}

List<BoxShadow> shadowSm() => [
      BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2))
    ];
List<BoxShadow> shadowMd() => [
      BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, 6)),
      BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 4,
          offset: const Offset(0, 1))
    ];
List<BoxShadow> shadowLg() => [
      BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 32,
          offset: const Offset(0, 10)),
      BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2))
    ];
List<BoxShadow> shadowGreen() => [
      BoxShadow(
          color: AppColors.primary.withOpacity(0.28),
          blurRadius: 24,
          offset: const Offset(0, 8))
    ];
List<BoxShadow> shadowGold() => [
      BoxShadow(
          color: AppColors.gold.withOpacity(0.35),
          blurRadius: 20,
          offset: const Offset(0, 6))
    ];

class AppTheme {
  AppTheme._();
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primary,
          onPrimary: Colors.white,
          primaryContainer: AppColors.primaryPale,
          onPrimaryContainer: AppColors.primaryDark,
          secondary: AppColors.gold,
          onSecondary: Colors.white,
          secondaryContainer: AppColors.goldPale,
          onSecondaryContainer: Color(0xFF7C4F00),
          tertiary: AppColors.info,
          onTertiary: Colors.white,
          tertiaryContainer: Color(0xFFDBEAFE),
          onTertiaryContainer: Color(0xFF1E3A8A),
          error: AppColors.error,
          onError: Colors.white,
          errorContainer: AppColors.errorPale,
          onErrorContainer: Color(0xFF991B1B),
          background: AppColors.background,
          onBackground: AppColors.textPrimary,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          surfaceVariant: AppColors.surfaceAlt,
          onSurfaceVariant: AppColors.textSecondary,
          outline: AppColors.border,
          outlineVariant: AppColors.divider,
          shadow: Color(0x1A000000),
          scrim: Color(0x80000000),
          inverseSurface: AppColors.textPrimary,
          onInverseSurface: Colors.white,
          inversePrimary: AppColors.primaryLight,
          surfaceTint: AppColors.primary,
        ),
        textTheme: GoogleFonts.interTextTheme(const TextTheme(
          displayLarge: TextStyle(
              fontSize: 54,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
              height: 1.1),
          headlineLarge: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w700, letterSpacing: -0.5),
          headlineMedium: TextStyle(
              fontSize: 26, fontWeight: FontWeight.w600, letterSpacing: -0.3),
          headlineSmall: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: -0.2),
          titleLarge: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.1),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          bodyLarge:
              TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.6),
          bodyMedium:
              TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
          bodySmall:
              TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4),
          labelLarge: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
          labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          labelSmall: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.3),
        )).apply(
            bodyColor: AppColors.textPrimary,
            displayColor: AppColors.textPrimary),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.35),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.md_),
          minimumSize: const Size(double.infinity, 54),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        )),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceAlt,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
              borderRadius: AppRadius.md_,
              borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.md_,
              borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.md_,
              borderSide: const BorderSide(color: AppColors.primary, width: 2)),
          errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.md_,
              borderSide: const BorderSide(color: AppColors.error)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.md_,
              borderSide: const BorderSide(color: AppColors.error, width: 2)),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          errorStyle: const TextStyle(
              color: AppColors.error,
              fontSize: 12,
              fontWeight: FontWeight.w500),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.md_),
        ),
        dividerTheme: const DividerThemeData(
            color: AppColors.divider, thickness: 1, space: 0),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: AppRadius.lg_,
              side: const BorderSide(color: AppColors.border)),
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
        ),
      );
}
