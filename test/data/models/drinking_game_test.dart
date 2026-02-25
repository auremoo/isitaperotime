import 'package:flutter_test/flutter_test.dart';
import 'package:isitaperotime/data/models/drinking_game.dart';

void main() {
  group('DrinkingGame', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 'test_game',
        'name': 'Test Game',
        'description': 'A test game',
        'icon': '\ud83c\udfae',
        'minPlayers': 2,
        'maxPlayers': 10,
        'category': 'prompts',
        'rules': ['Rule 1', 'Rule 2'],
        'cards': [
          {'text': 'Card 1', 'action': 'drink', 'sips': 1},
          {'text': 'Card 2', 'action': 'challenge', 'sips': 2},
        ],
      };

      final game = DrinkingGame.fromJson(json);

      expect(game.id, 'test_game');
      expect(game.name, 'Test Game');
      expect(game.minPlayers, 2);
      expect(game.maxPlayers, 10);
      expect(game.rules.length, 2);
      expect(game.cards.length, 2);
    });

    test('GameCard fromJson parses correctly', () {
      final json = {
        'text': 'Bois 2 gorg\u00e9es',
        'action': 'drink',
        'sips': 2,
      };

      final card = GameCard.fromJson(json);

      expect(card.text, 'Bois 2 gorg\u00e9es');
      expect(card.action, 'drink');
      expect(card.sips, 2);
    });

    test('GameCard handles null optional fields', () {
      final json = {
        'text': 'Some text',
      };

      final card = GameCard.fromJson(json);

      expect(card.text, 'Some text');
      expect(card.action, isNull);
      expect(card.sips, isNull);
    });

    test('toJson roundtrip', () {
      const original = DrinkingGame(
        id: 'test',
        name: 'Test',
        description: 'Desc',
        icon: '\ud83c\udfae',
        minPlayers: 3,
        maxPlayers: 8,
        category: 'cards',
        rules: ['R1'],
        cards: [GameCard(text: 'C1', action: 'drink', sips: 1)],
      );

      // Simulate real JSON roundtrip (encode then decode)
      final jsonString = original.toJson();
      final decoded = Map<String, dynamic>.from(jsonString.map(
        (key, value) => MapEntry(
          key,
          value is List
              ? value.map((e) => e is GameCard ? e.toJson() : e).toList()
              : value,
        ),
      ));
      final restored = DrinkingGame.fromJson(decoded);

      expect(restored.id, original.id);
      expect(restored.cards.length, 1);
      expect(restored.cards.first.text, 'C1');
    });
  });
}
