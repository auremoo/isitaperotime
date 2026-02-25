import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/drinking_game.dart';
import '../../data/repositories/game_repository.dart';

final gamesProvider = FutureProvider<List<DrinkingGame>>((ref) async {
  return ref.watch(gameRepositoryProvider).getAllGames();
});

final gameByIdProvider =
    FutureProvider.family<DrinkingGame?, String>((ref, id) async {
  return ref.watch(gameRepositoryProvider).getGameById(id);
});

final gameSessionProvider =
    StateNotifierProvider<GameSessionNotifier, GameSession?>((ref) {
  return GameSessionNotifier();
});

class GameSession {
  final DrinkingGame game;
  final List<String> players;
  final int currentCardIndex;
  final List<GameCard> shuffledCards;

  const GameSession({
    required this.game,
    required this.players,
    required this.currentCardIndex,
    required this.shuffledCards,
  });

  GameCard get currentCard => shuffledCards[currentCardIndex];

  bool get isLastCard => currentCardIndex >= shuffledCards.length - 1;

  String get formattedCardText {
    var text = currentCard.text;
    if (players.isNotEmpty) {
      final random = Random();
      // Replace {player} with a random player name
      while (text.contains('{player2}')) {
        text = text.replaceFirst(
          '{player2}',
          players[random.nextInt(players.length)],
        );
      }
      while (text.contains('{player}')) {
        text = text.replaceFirst(
          '{player}',
          players[random.nextInt(players.length)],
        );
      }
    }
    return text;
  }
}

class GameSessionNotifier extends StateNotifier<GameSession?> {
  GameSessionNotifier() : super(null);

  void startGame(DrinkingGame game, List<String> players) {
    final shuffled = List<GameCard>.from(game.cards)..shuffle(Random());
    state = GameSession(
      game: game,
      players: players,
      currentCardIndex: 0,
      shuffledCards: shuffled,
    );
  }

  void nextCard() {
    if (state == null) return;
    final nextIndex = state!.currentCardIndex + 1;
    if (nextIndex >= state!.shuffledCards.length) {
      // Reshuffle and restart
      final reshuffled = List<GameCard>.from(state!.shuffledCards)
        ..shuffle(Random());
      state = GameSession(
        game: state!.game,
        players: state!.players,
        currentCardIndex: 0,
        shuffledCards: reshuffled,
      );
    } else {
      state = GameSession(
        game: state!.game,
        players: state!.players,
        currentCardIndex: nextIndex,
        shuffledCards: state!.shuffledCards,
      );
    }
  }

  void endGame() => state = null;
}
