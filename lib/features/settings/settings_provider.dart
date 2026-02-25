import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/settings_repository.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref.watch(settingsRepositoryProvider));
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SettingsRepository _repo;

  ThemeModeNotifier(this._repo) : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    state = await _repo.getThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _repo.saveThemeMode(mode);
  }

  Future<void> toggleDarkMode() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}
