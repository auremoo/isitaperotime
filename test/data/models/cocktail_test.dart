import 'package:flutter_test/flutter_test.dart';
import 'package:isitaperotime/data/models/cocktail.dart';

void main() {
  group('Cocktail', () {
    test('fromJson parses correctly', () {
      final json = {
        'name': 'Mojito',
        'description': 'Un cocktail cubain',
        'nb_person': 8,
        'recipe': ['Etape 1', 'Etape 2'],
        'ingredients': {'Rhum': '70cl', 'Citron': '3'},
      };

      final cocktail = Cocktail.fromJson(json);

      expect(cocktail.name, 'Mojito');
      expect(cocktail.description, 'Un cocktail cubain');
      expect(cocktail.nbPerson, 8);
      expect(cocktail.recipe.length, 2);
      expect(cocktail.ingredients.length, 2);
      expect(cocktail.ingredients['Rhum'], '70cl');
    });

    test('toJson roundtrip', () {
      final original = Cocktail(
        name: 'Test',
        description: 'Test desc',
        nbPerson: 4,
        recipe: ['Step 1'],
        ingredients: {'Vodka': '5cl'},
      );

      final json = original.toJson();
      final restored = Cocktail.fromJson(json);

      expect(restored.name, original.name);
      expect(restored.nbPerson, original.nbPerson);
      expect(restored.ingredients, original.ingredients);
    });

    test('ingredientNames returns lowercase set', () {
      final cocktail = Cocktail(
        name: 'Test',
        description: 'desc',
        nbPerson: 1,
        recipe: [],
        ingredients: {'Rhum Blanc': '5cl', 'Citron Vert': '2'},
      );

      final names = cocktail.ingredientNames;
      expect(names, contains('rhum blanc'));
      expect(names, contains('citron vert'));
      expect(names.length, 2);
    });
  });
}
