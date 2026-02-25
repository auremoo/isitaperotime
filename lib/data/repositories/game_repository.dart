import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/drinking_game.dart';
import '../services/asset_service.dart';

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepository(ref.watch(assetServiceProvider));
});

class GameRepository {
  final AssetService _assetService;
  List<DrinkingGame>? _cachedGames;

  GameRepository(this._assetService);

  Future<List<DrinkingGame>> getAllGames() async {
    if (_cachedGames != null) return _cachedGames!;
    final jsonList =
        await _assetService.loadJsonList('assets/data/drinking_games.json');
    _cachedGames = jsonList.map(DrinkingGame.fromJson).toList();
    return _cachedGames!;
  }

  Future<DrinkingGame?> getGameById(String id) async {
    final all = await getAllGames();
    for (final g in all) {
      if (g.id == id) return g;
    }
    return null;
  }
}
