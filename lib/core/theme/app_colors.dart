import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AmolColors — single shared source of truth for the app's color tokens.
//
// This consolidates the color tokens that used to be copy-pasted as a private
// `class _C { ... }` inside ~20 different screens/widgets (and the separate
// `AmolColors` in monthly_amol_shared.dart). No color VALUE has been changed —
// every constant below keeps the exact hex value the screen already used.
//
// A few tokens had the same name but slightly different hex values across
// screens (copy-paste drift, e.g. `amber`, `border`, `red`, `textHint`,
// `textSec`, `gold`...). Those are kept as SEPARATE constants (name, name2,
// name3...) so nothing renders differently. See CONSOLIDATION_NOTES.md for
// the list of drifted names — worth a deliberate design decision later.
// ─────────────────────────────────────────────────────────────────────────────
class AmolColors {
  AmolColors._();

  static const ambalText = Color(0xFF92400E);
  static const amber = Color(0xFFF59E0B);
  static const amber2 = Color(0xFFFF6B35);
  static const amber3 = Color(0xFFD97706);
  static const amberBorder = Color(0xFFFDE68A);
  static const amberDark = Color(0xFF92400E);
  static const amberLight = Color(0xFFFFF3E0);
  static const amberLight2 = Color(0xFFFEF3C7);
  static const avatar1 = Color(0xFF0E3D22);
  static const avatar2 = Color(0xFF374151);
  static const avatar3 = Color(0xFF7C3AED);
  static const avatar4 = Color(0xFF0891B2);
  static const avatar5 = Color(0xFF9D174D);
  static const bg = Color(0xFFF4F6F1);
  static const blue = Color(0xFF0891B2);
  static const blue2 = Color(0xFF0369A1);
  static const blueBorder = Color(0xFFBAE6FD);
  static const blueLight = Color(0xFFE0F2FE);
  static const border = Color(0xFFE4EAE4);
  static const border2 = Color(0xFFE0E8E2);
  static const border3 = Color(0xFFE2E8E2);
  static const borderLight = Color(0xFFEEF2EE);
  static const borderMid = Color(0xFFD0DAD2);
  static const borderMid2 = Color(0xFFC8D4C8);
  static const card = Color(0xFFFFFFFF);
  static const cardBg = Color(0xFFFFFFFF);
  static const chipBg = Color(0xFFF4F6F1);
  static const darkGreen = Color(0xFF0E3D22);
  static const darkGreen2 = Color(0xFF033019);
  static const districtBg = Color(0xFFEDF2ED);
  static const districtText = Color(0xFF2D5A3D);
  static const divider = Color(0xFFE8EEE8);
  static const gold = Color(0xFFD4A843);
  static const gold2 = Color(0xFFF5C842);
  static const goldBg = Color(0xFFFDFAF3);
  static const goldBorder = Color(0xFFEDD98A);
  static const goldBorder2 = Color(0xFFFFCC80);
  static const goldLight = Color(0xFFFFF8E7);
  static const goldLight2 = Color(0xFFFFF3E0);
  static const goldPale = Color(0xFFFFFBF0);
  static const goldText = Color(0xFF8B6914);
  static const green = Color(0xFF16A34A);
  static const greenAccent = Color(0xFF4CAF78);
  static const greenBorder = Color(0xFFD4E9D9);
  static const greenLight = Color(0xFFE8F5EE);
  static const greenMid = Color(0xFF2D8A52);
  static const indigo = Color(0xFF4F46E5);
  static const indigoLight = Color(0xFFE0E7FF);
  static const inputBg = Color(0xFFF8FAF8);
  static const maafBg = Color(0xFFE8F5EE);
  static const maafText = Color(0xFF1B7045);
  static const midGreen = Color(0xFF1B7045);
  static const orange = Color(0xFFEA580C);
  static const orangeLight = Color(0xFFFFF0EB);
  static const pageBg = Color(0xFFF4F6F1);
  static const pink = Color(0xFFEC4899);
  static const pink2 = Color(0xFFDB2777);
  static const pinkLight = Color(0xFFFCE7F3);
  static const purple = Color(0xFF7C3AED);
  static const purpleBorder = Color(0xFFDDD6FE);
  static const purpleLight = Color(0xFFEDE9FE);
  static const purplePale = Color(0xFFF3F0FF);
  static const rankBronze = Color(0xFFCD7F32);
  static const rankGold = Color(0xFFD4A843);
  static const rankSilver = Color(0xFF94A3B8);
  static const red = Color(0xFFEF4444);
  static const red2 = Color(0xFFDC2626);
  static const red3 = Color(0xFFE53935);
  static const redLight = Color(0xFFFEF2F2);
  static const redLight2 = Color(0xFFFEE2E2);
  static const rose = Color(0xFFE11D48);
  static const roseLight = Color(0xFFFFE4E6);
  static const serialBg = Color(0xFFF0F4F0);
  static const serialText = Color(0xFF8FA98F);
  static const skelBase = Color(0xFFEDF1EC);
  static const skelBaseDark = Color(0xFFE2E8E2);
  static const shimmerHighlight = Color(0xFFE8ECE8);
  static const success = Color(0xFF16A34A);
  static const surfaceAlt = Color(0xFFF8FAF8);
  static const tafsirBg = Color(0xFFF6FAF7);
  static const teal = Color(0xFF0D9488);
  static const tealLight = Color(0xFFCCFBF1);
  static const textBody = Color(0xFF2D3F31);
  static const textHint = Color(0xFFABBAAE);
  static const textHint2 = Color(0xFFABBABE);
  static const textHint3 = Color(0xFFB0BDB2);
  static const textMuted = Color(0xFF6B7C6E);
  static const textPri = Color(0xFF0A1A0F);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSec = Color(0xFF4A5C50);
  static const textSec2 = Color(0xFF6B7C6E);
  static const textSec3 = Color(0xFF4E6357);
  static const textSec4 = Color(0xFF5A7A67);
  static const textSecondary = Color(0xFF6B7C6E);
}
