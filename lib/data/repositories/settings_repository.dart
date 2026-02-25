import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

class SettingsRepository {
  static const _themeKey = 'theme_mode';
  static const _favoritesKey = 'favorite_cocktails';

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_themeKey);
    return switch (value) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
  }

  Future<Set<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey)?.toSet() ?? {};
  }

  Future<void> saveFavorites(Set<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, favorites.toList());
  }
}
