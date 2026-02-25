import 'package:flutter/material.dart';

class UserSettings {
  final ThemeMode themeMode;
  final Set<String> favoriteCocktails;

  const UserSettings({
    this.themeMode = ThemeMode.system,
    this.favoriteCocktails = const {},
  });

  UserSettings copyWith({
    ThemeMode? themeMode,
    Set<String>? favoriteCocktails,
  }) =>
      UserSettings(
        themeMode: themeMode ?? this.themeMode,
        favoriteCocktails: favoriteCocktails ?? this.favoriteCocktails,
      );
}
