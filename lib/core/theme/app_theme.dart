import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_color_tokens.dart';

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

// ─────────────────────────────────────────────────────────────────────────────
// AppColorsDark — dark-mode counterparts for the ColorScheme/Material-component
// colors above. First-draft, auto-generated (HSL inversion by role), same
// review note as AppColorTokens.dark in app_color_tokens.dart.
// ─────────────────────────────────────────────────────────────────────────────
class AppColorsDark {
  AppColorsDark._();
  static const Color primary = Color(0xFF2A845A);
  static const Color primaryDark = Color(0xFF1A6146);
  static const Color primaryLight = Color(0xFF41A273);
  static const Color primaryPale = Color(0xFF293D32);
  static const Color primarySoft = Color(0xFF293D32);
  static const Color gold = Color(0xFFD3B46D);
  static const Color goldLight = Color(0xFFE9CC86);
  static const Color goldPale = Color(0xFF493D1D);
  static const Color success = Color(0xFF28BA5E);
  static const Color warning = Color(0xFFE8AA41);
  static const Color error = Color(0xFFD65555);
  static const Color errorPale = Color(0xFF491D1D);
  static const Color info = Color(0xFF5782E2);
  static const Color congregation = Color(0xFF2A845A);
  static const Color solo = Color(0xFFE8AA41);
  static const Color missed = Color(0xFF303236);
  static const Color background = Color(0xFF12160F);
  static const Color surface = Color(0xFF1B211A);
  static const Color surfaceAlt = Color(0xFF212820);
  static const Color border = Color(0xFF33402F);
  static const Color divider = Color(0xFF262E24);
  static const Color textPrimary = Color(0xFFE0E3EB);
  static const Color textSecondary = Color(0xFFE4E5E7);
  static const Color textTertiary = Color(0xFFF2F2F3);
  static const Color textHint = Color(0xFFF2F3F2);
  static const Color rankGold = Color(0xFFEFD239);
  static const Color rankSilver = Color(0xFFAEBBC1);
  static const Color rankBronze = Color(0xFFCEA174);
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
        extensions: const [AppColorTokens.light],
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

  // ─── Dark theme ─────────────────────────────────────────────────────────
  // Mirrors `light` exactly, just swapping AppColors -> AppColorsDark and
  // the ThemeExtension to AppColorTokens.dark. First-draft palette — see the
  // review note on AppColorTokens.dark / AppColorsDark above.
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColorsDark.background,
        extensions: const [AppColorTokens.dark],
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: AppColorsDark.primary,
          onPrimary: Colors.white,
          primaryContainer: AppColorsDark.primaryPale,
          onPrimaryContainer: AppColorsDark.primaryLight,
          secondary: AppColorsDark.gold,
          onSecondary: Colors.black,
          secondaryContainer: AppColorsDark.goldPale,
          onSecondaryContainer: Color(0xFFE9CC86),
          tertiary: AppColorsDark.info,
          onTertiary: Colors.white,
          tertiaryContainer: Color(0xFF1E3A5F),
          onTertiaryContainer: Color(0xFFBFDBFE),
          error: AppColorsDark.error,
          onError: Colors.white,
          errorContainer: AppColorsDark.errorPale,
          onErrorContainer: Color(0xFFFCA5A5),
          background: AppColorsDark.background,
          onBackground: AppColorsDark.textPrimary,
          surface: AppColorsDark.surface,
          onSurface: AppColorsDark.textPrimary,
          surfaceVariant: AppColorsDark.surfaceAlt,
          onSurfaceVariant: AppColorsDark.textSecondary,
          outline: AppColorsDark.border,
          outlineVariant: AppColorsDark.divider,
          shadow: Color(0x40000000),
          scrim: Color(0x80000000),
          inverseSurface: AppColorsDark.textPrimary,
          onInverseSurface: Colors.black,
          inversePrimary: AppColorsDark.primaryDark,
          surfaceTint: AppColorsDark.primary,
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
            bodyColor: AppColorsDark.textPrimary,
            displayColor: AppColorsDark.textPrimary),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsDark.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColorsDark.primary.withOpacity(0.35),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.md_),
          minimumSize: const Size(double.infinity, 54),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        )),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColorsDark.surfaceAlt,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
              borderRadius: AppRadius.md_,
              borderSide: const BorderSide(color: AppColorsDark.border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.md_,
              borderSide: const BorderSide(color: AppColorsDark.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.md_,
              borderSide:
                  const BorderSide(color: AppColorsDark.primary, width: 2)),
          errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.md_,
              borderSide: const BorderSide(color: AppColorsDark.error)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.md_,
              borderSide:
                  const BorderSide(color: AppColorsDark.error, width: 2)),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          errorStyle: const TextStyle(
              color: AppColorsDark.error,
              fontSize: 12,
              fontWeight: FontWeight.w500),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColorsDark.surfaceAlt,
          contentTextStyle: const TextStyle(color: AppColorsDark.textPrimary),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.md_),
        ),
        dividerTheme: const DividerThemeData(
            color: AppColorsDark.divider, thickness: 1, space: 0),
        cardTheme: CardThemeData(
          color: AppColorsDark.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: AppRadius.lg_,
              side: const BorderSide(color: AppColorsDark.border)),
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
        ),
      );
}
