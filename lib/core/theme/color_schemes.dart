import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

abstract final class AppColorSchemes {
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryLight,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFFFDCC2),
    onPrimaryContainer: Color(0xFF3A1800),
    secondary: AppColors.secondaryLight,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFFFD9E5),
    onSecondaryContainer: Color(0xFF3B0720),
    tertiary: AppColors.tertiaryLight,
    onTertiary: Colors.black,
    tertiaryContainer: Color(0xFFFFECB3),
    onTertiaryContainer: Color(0xFF3E2E00),
    error: Color(0xFFBA1A1A),
    onError: Colors.white,
    surface: AppColors.surfaceLight,
    onSurface: Color(0xFF1C1B1F),
    onSurfaceVariant: Color(0xFF6B6560),
    outline: Color(0xFF857E78),
    shadow: Colors.black,
  );

  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryDark,
    onPrimary: Color(0xFF3A1800),
    primaryContainer: Color(0xFF5C2D0E),
    onPrimaryContainer: Color(0xFFFFDCC2),
    secondary: AppColors.secondaryDark,
    onSecondary: Color(0xFF3B0720),
    secondaryContainer: Color(0xFF6B1540),
    onSecondaryContainer: Color(0xFFFFD9E5),
    tertiary: AppColors.tertiaryDark,
    onTertiary: Color(0xFF3E2E00),
    tertiaryContainer: Color(0xFF594400),
    onTertiaryContainer: Color(0xFFFFECB3),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    surface: AppColors.surfaceDark,
    onSurface: Color(0xFFE6E1E5),
    onSurfaceVariant: Color(0xFFCFC6BE),
    outline: Color(0xFF99918A),
    shadow: Colors.black,
  );
}
