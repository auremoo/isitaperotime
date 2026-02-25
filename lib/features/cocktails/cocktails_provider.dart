import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/cocktail.dart';
import '../../data/repositories/cocktail_repository.dart';
import '../../data/repositories/settings_repository.dart';

final cocktailsProvider = FutureProvider<List<Cocktail>>((ref) async {
  return ref.watch(cocktailRepositoryProvider).getAllCocktails();
});

final cocktailSearchQueryProvider = StateProvider<String>((ref) => '');

final selectedIngredientsProvider = StateProvider<Set<String>>((ref) => {});

final allIngredientsProvider = FutureProvider<Set<String>>((ref) async {
  return ref.watch(cocktailRepositoryProvider).getAllIngredients();
});

final showOnlyFavoritesProvider = StateProvider<bool>((ref) => false);

final filteredCocktailsProvider = Provider<AsyncValue<List<Cocktail>>>((ref) {
  final cocktailsAsync = ref.watch(cocktailsProvider);
  final query = ref.watch(cocktailSearchQueryProvider).toLowerCase();
  final selectedIngredients = ref.watch(selectedIngredientsProvider);
  final showOnlyFavs = ref.watch(showOnlyFavoritesProvider);
  final favorites = ref.watch(favoriteCocktailsProvider);

  return cocktailsAsync.whenData((cocktails) {
    var filtered = cocktails;

    if (query.isNotEmpty) {
      filtered = filtered
          .where((c) =>
              c.name.toLowerCase().contains(query) ||
              c.description.toLowerCase().contains(query) ||
              c.ingredientNames.any((i) => i.contains(query)))
          .toList();
    }

    if (selectedIngredients.isNotEmpty) {
      filtered = filtered
          .where((c) => selectedIngredients
              .every((ing) => c.ingredientNames.contains(ing.toLowerCase())))
          .toList();
    }

    if (showOnlyFavs) {
      filtered =
          filtered.where((c) => favorites.contains(c.name)).toList();
    }

    return filtered;
  });
});

final favoriteCocktailsProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier(ref.watch(settingsRepositoryProvider));
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  final SettingsRepository _repo;

  FavoritesNotifier(this._repo) : super({}) {
    _load();
  }

  Future<void> _load() async {
    state = await _repo.getFavorites();
  }

  Future<void> toggle(String cocktailName) async {
    final newSet = Set<String>.from(state);
    if (newSet.contains(cocktailName)) {
      newSet.remove(cocktailName);
    } else {
      newSet.add(cocktailName);
    }
    state = newSet;
    await _repo.saveFavorites(newSet);
  }

  bool isFavorite(String name) => state.contains(name);
}

final randomCocktailProvider = Provider<Cocktail?>((ref) {
  final cocktailsAsync = ref.watch(cocktailsProvider);
  return cocktailsAsync.whenOrNull(
    data: (cocktails) {
      if (cocktails.isEmpty) return null;
      return cocktails[Random().nextInt(cocktails.length)];
    },
  );
});
