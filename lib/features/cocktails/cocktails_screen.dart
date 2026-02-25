import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/app_error_widget.dart';
import 'cocktails_provider.dart';
import 'widgets/cocktail_card.dart';
import 'widgets/cocktail_search_bar.dart';

class CocktailsScreen extends ConsumerStatefulWidget {
  const CocktailsScreen({super.key});

  @override
  ConsumerState<CocktailsScreen> createState() => _CocktailsScreenState();
}

class _CocktailsScreenState extends ConsumerState<CocktailsScreen> {
  bool _showSearch = false;

  @override
  Widget build(BuildContext context) {
    final filteredAsync = ref.watch(filteredCocktailsProvider);
    final showFavs = ref.watch(showOnlyFavoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: _showSearch
            ? CocktailSearchBar(
                onChanged: (value) {
                  ref.read(cocktailSearchQueryProvider.notifier).state = value;
                },
              )
            : const Text('Cocktails'),
        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.close : Icons.search_rounded),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  ref.read(cocktailSearchQueryProvider.notifier).state = '';
                }
              });
            },
          ),
          IconButton(
            icon: Icon(
              showFavs ? Icons.favorite : Icons.favorite_border,
              color: showFavs ? Colors.red : null,
            ),
            onPressed: () {
              ref.read(showOnlyFavoritesProvider.notifier).state = !showFavs;
            },
          ),
        ],
      ),
      body: filteredAsync.when(
        data: (cocktails) {
          if (cocktails.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Aucun cocktail trouv\u00e9',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: cocktails.length,
            itemBuilder: (context, index) {
              return CocktailCard(
                cocktail: cocktails[index],
                onTap: () {
                  context.go(
                    '/cocktails/detail/${Uri.encodeComponent(cocktails[index].name)}',
                  );
                },
              );
            },
          );
        },
        loading: () => const LoadingWidget(message: 'Chargement des cocktails...'),
        error: (error, _) => AppErrorWidget(
          message: 'Erreur de chargement: $error',
          onRetry: () => ref.invalidate(cocktailsProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final random = ref.read(randomCocktailProvider);
          if (random != null) {
            context.go(
              '/cocktails/detail/${Uri.encodeComponent(random.name)}',
            );
          }
        },
        icon: const Icon(Icons.shuffle_rounded),
        label: const Text('Au hasard !'),
      ),
    );
  }
}
