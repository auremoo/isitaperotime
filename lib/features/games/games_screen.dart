import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/app_error_widget.dart';
import '../../data/models/drinking_game.dart';
import 'games_provider.dart';

class GamesScreen extends ConsumerWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamesAsync = ref.watch(gamesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jeux d\'alcool'),
      ),
      body: gamesAsync.when(
        data: (games) => Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return _GameSelectionCard(
                game: game,
                onTap: () => context.go('/games/play/${game.id}'),
              ).animate().fadeIn(
                    delay: Duration(milliseconds: index * 100),
                    duration: 400.ms,
                  );
            },
          ),
        ),
        loading: () => const LoadingWidget(message: 'Chargement des jeux...'),
        error: (error, _) => AppErrorWidget(
          message: 'Erreur de chargement',
          onRetry: () => ref.invalidate(gamesProvider),
        ),
      ),
    );
  }
}

class _GameSelectionCard extends StatelessWidget {
  final DrinkingGame game;
  final VoidCallback onTap;

  const _GameSelectionCard({required this.game, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                game.icon,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 8),
              Text(
                game.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '${game.minPlayers}-${game.maxPlayers} joueurs',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                game.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
