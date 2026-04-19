import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens for the LaTeX editor.
abstract final class LatexTheme {
  // ── Brand Colors ──
  static const primary = Color(0xFF2563EB);
  static const primaryLight = Color(0xFFDBEAFE);
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFEAB308);
  static const error = Color(0xFFDC2626);

  // ── Surface Colors ──
  static const background = Color(0xFFFAFAFA);
  static const surface = Color(0xFFFFFFFF);
  static const sidebar = Color(0xFFF8FAFC);
  static const editorBg = Color(0xFFFFFFF8);
  static const gutterBg = Color(0xFFF1F5F9);
  static const logBg = Color(0xFF1E293B);

  // ── Text Colors ──
  static const textPrimary = Color(0xFF1E293B);
  static const textSecondary = Color(0xFF64748B);
  static const gutterText = Color(0xFF94A3B8);
  static const logText = Color(0xFFE2E8F0);

  // ── Border ──
  static const border = Color(0xFFE2E8F0);

  // ── Typography ──
  static TextStyle get monoStyle => GoogleFonts.jetBrainsMono(
        fontSize: 14,
        height: 1.6,
        color: textPrimary,
      );

  static TextStyle get monoSmall => GoogleFonts.jetBrainsMono(
        fontSize: 12,
        height: 1.4,
        color: logText,
      );

  // ── Theme Data ──
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: primary,
        brightness: Brightness.light,
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          backgroundColor: surface,
          foregroundColor: textPrimary,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
        dividerTheme: const DividerThemeData(
          color: border,
          thickness: 1,
        ),
      );
}
