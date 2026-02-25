import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/cocktail.dart';
import '../cocktails_provider.dart';

class CocktailCard extends ConsumerWidget {
  final Cocktail cocktail;
  final VoidCallback onTap;

  const CocktailCard({
    super.key,
    required this.cocktail,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final favorites = ref.watch(favoriteCocktailsProvider);
    final isFav = favorites.contains(cocktail.name);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cocktail.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cocktail.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.people_outline_rounded,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${cocktail.nbPerson} pers.',
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.restaurant_menu_rounded,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${cocktail.ingredients.length} ingr.',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : theme.colorScheme.outline,
                  ),
                  onPressed: () {
                    ref
                        .read(favoriteCocktailsProvider.notifier)
                        .toggle(cocktail.name);
                  },
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
