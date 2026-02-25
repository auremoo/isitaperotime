import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cocktail.dart';
import '../services/asset_service.dart';

final cocktailRepositoryProvider = Provider<CocktailRepository>((ref) {
  return CocktailRepository(ref.watch(assetServiceProvider));
});

class CocktailRepository {
  final AssetService _assetService;
  List<Cocktail>? _cachedCocktails;

  CocktailRepository(this._assetService);

  Future<List<Cocktail>> getAllCocktails() async {
    if (_cachedCocktails != null) return _cachedCocktails!;
    final jsonList =
        await _assetService.loadJsonList('assets/data/cocktails.json');
    _cachedCocktails = jsonList.map(Cocktail.fromJson).toList();
    return _cachedCocktails!;
  }

  Future<Cocktail?> getCocktailByName(String name) async {
    final all = await getAllCocktails();
    for (final c in all) {
      if (c.name == name) return c;
    }
    return null;
  }

  Future<List<Cocktail>> searchCocktails(String query) async {
    final all = await getAllCocktails();
    final lowerQuery = query.toLowerCase();
    return all
        .where((c) =>
            c.name.toLowerCase().contains(lowerQuery) ||
            c.description.toLowerCase().contains(lowerQuery) ||
            c.ingredientNames.any((i) => i.contains(lowerQuery)))
        .toList();
  }

  Future<Set<String>> getAllIngredients() async {
    final all = await getAllCocktails();
    final ingredients = <String>{};
    for (final cocktail in all) {
      ingredients.addAll(cocktail.ingredients.keys);
    }
    return ingredients;
  }

  Future<List<Cocktail>> filterByIngredients(Set<String> ingredients) async {
    final all = await getAllCocktails();
    final lowerIngredients = ingredients.map((i) => i.toLowerCase()).toSet();
    return all
        .where((c) =>
            lowerIngredients.every((ing) => c.ingredientNames.contains(ing)))
        .toList();
  }
}
