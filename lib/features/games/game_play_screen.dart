import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/widgets/loading_widget.dart';
import 'games_provider.dart';

class GamePlayScreen extends ConsumerStatefulWidget {
  final String gameId;

  const GamePlayScreen({super.key, required this.gameId});

  @override
  ConsumerState<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends ConsumerState<GamePlayScreen> {
  final List<String> _players = [];
  final TextEditingController _playerController = TextEditingController();
  bool _gameStarted = false;

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameAsync = ref.watch(gameByIdProvider(widget.gameId));
    final session = ref.watch(gameSessionProvider);
    final theme = Theme.of(context);

    return gameAsync.when(
      data: (game) {
        if (game == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Jeu introuvable')),
            body: const Center(child: Text('Ce jeu n\'existe pas.')),
          );
        }

        if (!_gameStarted || session == null) {
          return _buildSetupScreen(context, game, theme);
        }

        return _buildGameScreen(context, session, theme);
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const LoadingWidget(),
      ),
      error: (_, __) => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Erreur de chargement')),
      ),
    );
  }

  Widget _buildSetupScreen(
      BuildContext context, dynamic game, ThemeData theme) {
    return Scaffold(
      appBar: AppBar(title: Text(game.name)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              game.icon,
              style: const TextStyle(fontSize: 60),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              game.description,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Rules
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'R\u00e8gles',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...game.rules.map<Widget>((rule) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('\u2022 '),
                              Expanded(child: Text(rule as String)),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Player input
            if (game.minPlayers > 1) ...[
              Text(
                'Joueurs (${_players.length})',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _playerController,
                      decoration: const InputDecoration(
                        hintText: 'Pr\u00e9nom du joueur',
                      ),
                      onSubmitted: (_) => _addPlayer(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _addPlayer,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _players
                    .map((p) => Chip(
                          label: Text(p),
                          onDeleted: () =>
                              setState(() => _players.remove(p)),
                        ))
                    .toList(),
              ),
            ],
            const Spacer(),
            FilledButton.icon(
              onPressed: (_players.length >= game.minPlayers ||
                      game.minPlayers <= 1)
                  ? () {
                      ref
                          .read(gameSessionProvider.notifier)
                          .startGame(game, _players);
                      setState(() => _gameStarted = true);
                    }
                  : null,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(
                _players.length < game.minPlayers && game.minPlayers > 1
                    ? 'Min. ${game.minPlayers} joueurs'
                    : 'C\'est parti !',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameScreen(
      BuildContext context, GameSession session, ThemeData theme) {
    return Scaffold(
      appBar: AppBar(
        title: Text(session.game.name),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(gameSessionProvider.notifier).endGame();
              setState(() => _gameStarted = false);
            },
            child: Text(
              'Quitter',
              style: TextStyle(color: theme.colorScheme.onPrimary),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => ref.read(gameSessionProvider.notifier).nextCard(),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Progress
              LinearProgressIndicator(
                value: (session.currentCardIndex + 1) /
                    session.shuffledCards.length,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
              const SizedBox(height: 8),
              Text(
                'Carte ${session.currentCardIndex + 1} / ${session.shuffledCards.length}',
                style: theme.textTheme.bodySmall,
              ),
              const Spacer(),
              // Card
              Card(
                elevation: 4,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (session.currentCard.sips != null &&
                          session.currentCard.sips! > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              session.currentCard.sips!,
                              (_) => const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: Icon(Icons.local_drink_rounded,
                                    size: 20),
                              ),
                            ),
                          ),
                        ),
                      Text(
                        session.formattedCardText,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
                  .animate(
                    key: ValueKey(session.currentCardIndex),
                  )
                  .fadeIn(duration: 300.ms)
                  .slideX(begin: 0.1, end: 0),
              const Spacer(),
              Text(
                'Appuyez pour la carte suivante',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _addPlayer() {
    final name = _playerController.text.trim();
    if (name.isNotEmpty && !_players.contains(name)) {
      setState(() {
        _players.add(name);
        _playerController.clear();
      });
    }
  }
}
