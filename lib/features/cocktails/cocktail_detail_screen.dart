import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/repositories/cocktail_repository.dart';
import '../../core/widgets/loading_widget.dart';
import 'cocktails_provider.dart';

class CocktailDetailScreen extends ConsumerWidget {
  final String cocktailName;

  const CocktailDetailScreen({super.key, required this.cocktailName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final favorites = ref.watch(favoriteCocktailsProvider);
    final isFav = favorites.contains(cocktailName);

    return FutureBuilder(
      future: ref.read(cocktailRepositoryProvider).getCocktailByName(cocktailName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text(cocktailName)),
            body: const LoadingWidget(),
          );
        }

        final cocktail = snapshot.data;
        if (cocktail == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Cocktail introuvable')),
            body: const Center(child: Text('Ce cocktail n\'existe pas.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(cocktail.name),
            actions: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : null,
                ),
                onPressed: () {
                  ref
                      .read(favoriteCocktailsProvider.notifier)
                      .toggle(cocktail.name);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  cocktail.name,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 8),
                // Description
                Text(
                  cocktail.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                // Persons
                Chip(
                  avatar: const Icon(Icons.people_rounded, size: 18),
                  label: Text('Pour ${cocktail.nbPerson} personne${cocktail.nbPerson > 1 ? 's' : ''}'),
                ),
                const SizedBox(height: 24),
                // Ingredients
                Text(
                  'Ingr\u00e9dients',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: cocktail.ingredients.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ),
                              Text(
                                entry.value,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                const SizedBox(height: 24),
                // Recipe
                Text(
                  'Recette',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...cocktail.recipe.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Text(
                            '${entry.key + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.value.replaceFirst(RegExp(r'^\d+\.\s*'), ''),
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(
                        delay: Duration(milliseconds: 300 + entry.key * 100),
                        duration: 400.ms,
                      );
                }),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
